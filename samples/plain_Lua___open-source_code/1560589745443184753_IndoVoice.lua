repeat task.wait() until game:IsLoaded()

do
    local _prevUnload = getgenv and getgenv().IndoVoice_Unload
    if type(_prevUnload) == "function" then
        pcall(_prevUnload)
        task.wait(0.2)
    end
end

local RAW_URL = "https://raw.githubusercontent.com/DanteLuau/Delirium/refs/heads/main/dist/test.lua?v=" .. tostring(tick())

local Delirium
do
    local ok, res = pcall(function()
        return loadstring(game:HttpGet(RAW_URL))()
    end)
    if ok and res and res.CreateWindow then
        Delirium = res
    else
        error("[Delirium] Gagal memuat dari GitHub.")
    end
end
assert(Delirium and Delirium.CreateWindow, "[Indo Voice] Delirium.CreateWindow tidak ditemukan")

local ActiveWindow
local function Notify(props)
    if not ActiveWindow then return end
    local nt = tostring(props.Type or props.type or "info"):lower()
    if nt ~= "success" and nt ~= "warning" and nt ~= "error" and nt ~= "info" then
        nt = "info"
    end
    pcall(function()
        ActiveWindow:Notify({
            title    = props.Title    or props.title    or "Indo Voice",
            content  = props.Message  or props.content  or "",
            type     = nt,
            duration = props.Duration or props.duration or 3,
        })
    end)
end

local Players              = game:GetService("Players")
local RunService           = game:GetService("RunService")
local UserInputService     = game:GetService("UserInputService")
local VirtualInputManager  = game:GetService("VirtualInputManager")
local PathfindingService   = game:GetService("PathfindingService")
local ReplicatedStorage    = game:GetService("ReplicatedStorage")
local CollectionService    = game:GetService("CollectionService")
local TeleportService      = game:GetService("TeleportService")
local LocalPlayer          = Players.LocalPlayer
local PlayerGui            = LocalPlayer:WaitForChild("PlayerGui")

local Settings = {
    Fishing = {
        Enabled           = false,
        AutoEquipRod      = true,
        CastMethod        = "Legit",
        CatchMethod       = "Legit",
        CastHoldDuration  = 2.0,
        ClickSpeedCPS     = 10,
        ClickInterval     = 1 / 15,
        BaitTimeout       = 25,
        TotalFishCaught   = 0,
    },
    Mining = {
        Enabled           = false,
        FullyAuto         = false,
        TargetFilter      = "Hotspot Only",
        UndergroundDepth  = 9,
        AutoEquipPickaxe  = false,
        AutoWalk          = false,
        AutoWalkReachDist = 12,
        FakeHitAnimation  = false,
        FakeHitRepeatCount= 3,
        SearchRadius      = 40,
        SafeZonePercent   = 1,
        LoopDelay         = 0.15,
        HitGap            = 0.12,
        WatchdogTimeout   = 3.0,
        MineMethod        = "Legit",
        BlatantHitDelay   = 5.5,
        TotalMined        = 0,
        TotalFailed       = 0,
    }
}

local Runtime = {
    Fishing = {
        Thread = nil, ActiveRod = nil, CastToken = nil, LastUsedToken = nil,
        IsCasting = false, BaitLanded = false, IsBusy = false,
        IsInternalReEquip = false, ActiveCatchThread = nil,
        LastCastTime = 0, LastBaitLandedTime = 0,
        FacingLockConn = nil, Connections = {},
    },
    Mining = {
        Thread = nil, IsBusy = false, SessionToken = nil, HookedPickaxe = nil,
        CurrentTargetStone = nil, ActiveHitThread = nil, IsInternalReEquip = false,
        Connections = {}, FloatMover = nil, FloatGyro = nil, FloatConn = nil,
        TargetFloatCF = nil, IsFloating = false,
    },
    GlobalConnections = {},
}

local Utils = {}

function Utils.AddConnection(list, conn) table.insert(list, conn) return conn end
function Utils.ClearConnections(list)
    for _, c in ipairs(list) do pcall(function() c:Disconnect() end) end
    table.clear(list)
end
function Utils.GetCharacter() return LocalPlayer.Character end
function Utils.GetHumanoid()
    local c = LocalPlayer.Character
    return c and c:FindFirstChildOfClass("Humanoid")
end
function Utils.GetHumanoidRootPart()
    local c = LocalPlayer.Character
    return c and c:FindFirstChild("HumanoidRootPart")
end
function Utils.GetCharacterPosition()
    local h = Utils.GetHumanoidRootPart()
    return h and h.Position or Vector3.zero
end

local IsMobile = UserInputService.TouchEnabled and not UserInputService.KeyboardEnabled

local function SendTouchSafe(id, x, y, state)
    local ok = pcall(VirtualInputManager.SendTouchEvent, VirtualInputManager, id, Vector2.new(x, y), state, game)
    if not ok then
        pcall(VirtualInputManager.SendTouchEvent, VirtualInputManager, id, x, y, state, game)
    end
end

function Utils.SendClick(x, y)
    if IsMobile then
        SendTouchSafe(0, x, y, Enum.UserInputState.Begin)
        task.wait(0.01)
        SendTouchSafe(0, x, y, Enum.UserInputState.End)
    else
        VirtualInputManager:SendMouseButtonEvent(x, y, 0, true, game, 1)
        task.wait(0.01)
        VirtualInputManager:SendMouseButtonEvent(x, y, 0, false, game, 1)
    end
end

function SafeTeleportTo(pos)
    local hrp = Utils.GetHumanoidRootPart()
    if not hrp then return end
    hrp.CFrame = CFrame.new(pos + Vector3.new(0, 3, 0))
end

local FishingSystem = {}

function FishingSystem.GetEquippedRod()
    local c = Utils.GetCharacter() if not c then return nil end
    for _, item in ipairs(c:GetChildren()) do
        if item:IsA("Tool") and string.find(string.lower(item.Name), "rod") then return item end
    end
    return nil
end

function FishingSystem.GetBackpackRod()
    local bp = LocalPlayer:FindFirstChildOfClass("Backpack") if not bp then return nil end
    for _, item in ipairs(bp:GetChildren()) do
        if item:IsA("Tool") and string.find(string.lower(item.Name), "rod") then return item end
    end
    return nil
end

function FishingSystem.EnsureRodEquipped()
    local eq = FishingSystem.GetEquippedRod() if eq then return eq end
    if not Settings.Fishing.AutoEquipRod then return nil end
    local bpRod = FishingSystem.GetBackpackRod()
    local hum = Utils.GetHumanoid()
    if bpRod and hum then
        hum:EquipTool(bpRod)
        task.wait(0.3)
        return FishingSystem.GetEquippedRod()
    end
    return nil
end

function FishingSystem.FindActiveBobber()
    local c = Utils.GetCharacter()
    if c and c:FindFirstChild("Bobber") then return c:FindFirstChild("Bobber") end
    local lpName = string.lower(LocalPlayer.Name)
    for _, obj in ipairs(workspace:GetChildren()) do
        local n = string.lower(obj.Name)
        if (string.find(n, lpName) and string.find(n, "bobber")) or obj.Name == "Bobber" then
            return obj
        end
    end
    return nil
end

function FishingSystem.GetFishingGui()
    local pg = LocalPlayer:FindFirstChildOfClass("PlayerGui") if not pg then return nil end
    for _, g in ipairs(pg:GetChildren()) do
        if g.Name == "FishingUI" or g:FindFirstChild("FishingHolder") or g:FindFirstChild("PreFishingHolder") then
            return g
        end
    end
    return nil
end

function FishingSystem.CheckSuspension()
    local pg = LocalPlayer:FindFirstChildOfClass("PlayerGui")
    local msg = pg and pg:FindFirstChild("Message")
    local lbl = msg and msg:FindFirstChild("MessageHolder")
        and msg.MessageHolder:FindFirstChild("MessageLabel")
    if lbl and lbl.Visible and lbl.Text and lbl.Text:find("temporarily disabled") then
        local secs = tonumber(lbl.Text:match("(%d+)%s+seconds"))
        return true, secs or 5
    end
    return false, 0
end

function FishingSystem.SolvePreFishingDrag(pre)
    if not pre or not pre.Visible then return end
    local dragBtn = pre:WaitForChild("DragButton", 2)
    local target = pre:WaitForChild("TargetFrame", 2)
    if not dragBtn or not target then return end
    local det = dragBtn:WaitForChild("UIDragDetector", 2)
    if not det then return end
    local t0 = os.clock()
    while pre.Visible and (os.clock() - t0) < 5 do
        pcall(function()
            dragBtn.Position = target.Position
            task.wait(0.03)
            if firesignal then
                firesignal(det.DragStart) task.wait(0.02)
                firesignal(det.DragContinue) task.wait(0.02)
                firesignal(det.DragEnd)
            elseif IsMobile then
                local bap = dragBtn.AbsolutePosition
                local bas = dragBtn.AbsoluteSize
                local bx0 = math.floor(bap.X + bas.X * 0.5)
                local by0 = math.floor(bap.Y + bas.Y * 0.5)
                local tap, tas = target.AbsolutePosition, target.AbsoluteSize
                local tx = math.floor(tap.X + tas.X * 0.5)
                local ty = math.floor(tap.Y + tas.Y * 0.5)
                SendTouchSafe(0, bx0, by0, Enum.UserInputState.Begin)
                task.wait(0.04)
                for si = 1, 5 do
                    local t = si / 5
                    local ix = math.floor(bx0 + (tx - bx0) * t)
                    local iy = math.floor(by0 + (ty - by0) * t)
                    SendTouchSafe(0, ix, iy, Enum.UserInputState.Change)
                    task.wait(0.025)
                end
                SendTouchSafe(0, tx, ty, Enum.UserInputState.End)
            end
        end)
        task.wait(0.2)
    end
end

function FishingSystem.ProcessBarMinigame(holder)
    if not holder or not holder.Visible then return end
    local frame = holder:FindFirstChild("FishingFrame") if not frame then return end
    local info = frame:FindFirstChild("InfoLabel") if not info then return end
    local txt = info.Text
    if txt == "Click/tap to raise the bar!" then
        local vp = workspace.CurrentCamera and workspace.CurrentCamera.ViewportSize or Vector2.new(800, 600)
        local tapX = math.floor(vp.X * 0.5)
        local tapY = math.floor(vp.Y * 0.75)
        pcall(function() Utils.SendClick(tapX, tapY) end)
        if firesignal then
            pcall(function() firesignal(frame.InputBegan, {UserInputType = Enum.UserInputType.Touch}) end)
        end
        task.wait(Settings.Fishing.ClickInterval)
    else
        task.wait(0.05)
    end
end

function FishingSystem.GetFishingZone()
    local world = workspace:FindFirstChild("World")
    if world then
        for _, map in ipairs(world:GetChildren()) do
            if map.Name ~= "MainBaseplate" then
                local asset = map:FindFirstChild("Asset")
                local fz = asset and (asset:FindFirstChild("FishingZone") or asset:FindFirstChild("FishingSpots"))
                if fz then return fz end
            end
        end
    end
    local main = workspace:FindFirstChild("Main")
    if main and main:FindFirstChild("FishingZone") then return main.FishingZone end
    local rs_main = ReplicatedStorage:FindFirstChild("Main")
    return rs_main and rs_main:FindFirstChild("FishingZone")
end

function FishingSystem.IsHotspotActive(part)
    if not part then return false end
    local att = part:FindFirstChildOfClass("Attachment")
    local emitter = att and att:FindFirstChild("GroundFlasg")
    if emitter and emitter.Enabled == true then return true end
    return part:GetAttribute("IsActive") == true
end

function FishingSystem.ResetSession()
    if Runtime.Fishing.ActiveCatchThread then
        pcall(task.cancel, Runtime.Fishing.ActiveCatchThread)
        Runtime.Fishing.ActiveCatchThread = nil
    end
    Runtime.Fishing.CastToken = nil
    Runtime.Fishing.LastUsedToken = nil
    Runtime.Fishing.BaitLanded = false
    Runtime.Fishing.IsBusy = false
    Runtime.Fishing.IsCasting = false
    if Runtime.Fishing.FacingLockConn then
        Runtime.Fishing.FacingLockConn:Disconnect()
        Runtime.Fishing.FacingLockConn = nil
    end
    local h = Utils.GetHumanoid() if h then h.AutoRotate = true end
    local pg = LocalPlayer:FindFirstChildOfClass("PlayerGui")
    if pg then
        for _, g in ipairs(pg:GetChildren()) do
            if g.Name == "FishingUI" or g:FindFirstChild("FishingHolder") or g:FindFirstChild("PreFishingHolder") then
                pcall(function() g:Destroy() end)
            end
        end
    end
end

function FishingSystem.UnhookRodEvents()
    Runtime.Fishing.ActiveRod = nil
    Runtime.Fishing.CastToken = nil
    Runtime.Fishing.LastUsedToken = nil
    Runtime.Fishing.BaitLanded = false
    Runtime.Fishing.IsBusy = false
    Runtime.Fishing.IsCasting = false
    Utils.ClearConnections(Runtime.Fishing.Connections)
end

function FishingSystem.HookRodEvents(tool)
    if not tool then return end
    if Runtime.Fishing.ActiveRod == tool and tool:GetAttribute("_IVRodHooked") then return end
    FishingSystem.UnhookRodEvents()
    Runtime.Fishing.ActiveRod = tool
    tool:SetAttribute("_IVRodHooked", true)

    Utils.AddConnection(Runtime.Fishing.Connections, tool.Unequipped:Connect(function()
        if Runtime.Fishing.IsInternalReEquip then return end
        FishingSystem.ResetSession()
        Runtime.Fishing.CastToken = nil
    end))

    local toolReady    = tool:WaitForChild("ToolReady", 4)
    local baitLanded   = tool:WaitForChild("BaitLanded", 4)
    local canceled     = tool:WaitForChild("FishingCanceled", 4)
    local startMinigame= tool:WaitForChild("StartMinigame", 4)

    if toolReady and toolReady:IsA("RemoteEvent") then
        Utils.AddConnection(Runtime.Fishing.Connections, toolReady.OnClientEvent:Connect(function(token)
            Runtime.Fishing.CastToken = token
            Runtime.Fishing.IsCasting = false
        end))
    end

    if baitLanded and baitLanded:IsA("RemoteEvent") then
        Utils.AddConnection(Runtime.Fishing.Connections, baitLanded.OnClientEvent:Connect(function(_, ...)
            Runtime.Fishing.BaitLanded = true
            Runtime.Fishing.IsCasting = false
            Runtime.Fishing.LastBaitLandedTime = os.clock()
            if Settings.Fishing.CastMethod == "Blatant" or Settings.Fishing.CatchMethod == "Blatant" then
                task.spawn(function()
                    task.wait(0.06)
                    local char = Utils.GetCharacter()
                    local hrp  = char and char:FindFirstChild("HumanoidRootPart")
                    local hum  = char and char:FindFirstChildOfClass("Humanoid")
                    if not hrp or not hum then return end
                    local savedLook = hrp.CFrame.LookVector
                    hum.AutoRotate = true
                    if Runtime.Fishing.FacingLockConn then
                        Runtime.Fishing.FacingLockConn:Disconnect()
                        Runtime.Fishing.FacingLockConn = nil
                    end
                    Runtime.Fishing.FacingLockConn = RunService.PreRender:Connect(function()
                        if not Runtime.Fishing.BaitLanded or not hrp or not hrp.Parent then
                            if Runtime.Fishing.FacingLockConn then
                                Runtime.Fishing.FacingLockConn:Disconnect()
                                Runtime.Fishing.FacingLockConn = nil
                            end
                            hum.AutoRotate = true
                            return
                        end
                        hrp.CFrame    = CFrame.lookAt(hrp.Position, hrp.Position + savedLook)
                        hum.AutoRotate = true
                    end)
                end)
            end
        end))
    end

    if canceled and canceled:IsA("RemoteEvent") then
        Utils.AddConnection(Runtime.Fishing.Connections, canceled.OnClientEvent:Connect(function()
            FishingSystem.ResetSession()
        end))
    end

    if startMinigame and startMinigame:IsA("RemoteEvent") then
        Utils.AddConnection(Runtime.Fishing.Connections, startMinigame.OnClientEvent:Connect(function(arg1, arg2, arg3, ...)
            if Settings.Fishing.CatchMethod ~= "Blatant" then return end
            local catchRemote = tool:FindFirstChild("Catch")
            if not catchRemote or not catchRemote:IsA("RemoteEvent") then return end
            if Runtime.Fishing.IsBusy then return end
            Runtime.Fishing.IsBusy = true
            if Runtime.Fishing.ActiveCatchThread then pcall(task.cancel, Runtime.Fishing.ActiveCatchThread) end
            local eventArgs = { arg1, arg2, arg3, ... }

            Runtime.Fishing.ActiveCatchThread = task.spawn(function()
                task.wait(3.8)
                if not Settings.Fishing.Enabled or Settings.Fishing.CatchMethod ~= "Blatant" then
                    Runtime.Fishing.IsBusy = false
                    return
                end
                local char = Utils.GetCharacter()
                if not char or tool.Parent ~= char then FishingSystem.ResetSession() return end
                Runtime.Fishing.BaitLanded = false
                pcall(function() catchRemote:FireServer(true) end)
                local pg = LocalPlayer:FindFirstChildOfClass("PlayerGui")
                if pg then
                    for _, g in ipairs(pg:GetChildren()) do
                        if g.Name == "FishingUI" or g:FindFirstChild("FishingHolder") or g:FindFirstChild("PreFishingHolder") then
                            pcall(function() g:Destroy() end)
                        end
                    end
                end
                task.wait(0.5)
                if Settings.Fishing.Enabled and Settings.Fishing.CatchMethod == "Blatant" then
                    local after = Utils.GetCharacter()
                    if after and tool.Parent == after then
                        FishingSystem.FastReEquipRod(tool)
                        local dl = os.clock() + 2.5
                        while os.clock() < dl do
                            local ct = Runtime.Fishing.CastToken or FishingSystem.ExtractToken(tool)
                            if ct and ct ~= Runtime.Fishing.LastUsedToken then
                                Runtime.Fishing.CastToken = ct
                                break
                            end
                            task.wait(0.05)
                        end
                    end
                end
                Runtime.Fishing.IsBusy = false
                Runtime.Fishing.ActiveCatchThread = nil
            end)
        end))
    end
end

function FishingSystem.ExtractToken(tool)
    if not tool then return nil end
    local toolReady = tool:FindFirstChild("ToolReady")
    if not toolReady then return nil end
    if getconnections and getupvalues then
        local conns = getconnections(toolReady.OnClientEvent)
        for _, c in ipairs(conns) do
            if c.Function then
                local ups = getupvalues(c.Function)
                for _, val in pairs(ups) do
                    if type(val) == "number" and val > 1000000000 then
                        if val ~= Runtime.Fishing.LastUsedToken then return val end
                    end
                end
            end
        end
    end
    return nil
end

function FishingSystem.EnsureCastToken()
    if Runtime.Fishing.CastToken and Runtime.Fishing.CastToken ~= Runtime.Fishing.LastUsedToken then
        return Runtime.Fishing.CastToken
    end
    local rod = FishingSystem.EnsureRodEquipped()
    if not rod then return nil end
    FishingSystem.HookRodEvents(rod)
    local token = FishingSystem.ExtractToken(rod)
    if token and token ~= Runtime.Fishing.LastUsedToken then
        Runtime.Fishing.CastToken = token
        return token
    end
    local dl = os.clock() + 1.0
    while (not Runtime.Fishing.CastToken or Runtime.Fishing.CastToken == Runtime.Fishing.LastUsedToken)
        and os.clock() < dl do
        task.wait(0.05)
    end
    if Runtime.Fishing.CastToken ~= Runtime.Fishing.LastUsedToken then
        return Runtime.Fishing.CastToken
    end
    return nil
end

function FishingSystem.FastReEquipRod(tool)
    local hum = Utils.GetHumanoid()
    local target = tool or Runtime.Fishing.ActiveRod or FishingSystem.GetEquippedRod()
    if not hum or not target then return end
    Runtime.Fishing.IsInternalReEquip = true
    Runtime.Fishing.CastToken = nil
    if Runtime.Fishing.FacingLockConn then
        Runtime.Fishing.FacingLockConn:Disconnect()
        Runtime.Fishing.FacingLockConn = nil
    end
    local h = Utils.GetHumanoid() if h then h.AutoRotate = true end
    hum:UnequipTools() task.wait(0.15) hum:EquipTool(target)
    FishingSystem.HookRodEvents(target) task.wait(0.05)
    Runtime.Fishing.IsInternalReEquip = false
end

function FishingSystem.RunBlatantCycle()
    if Runtime.Fishing.IsBusy or Runtime.Fishing.IsCasting then task.wait(0.1) return end
    local sus, waitSecs = FishingSystem.CheckSuspension()
    if sus then task.wait(math.clamp(waitSecs, 1, 5)) return end
    local rod = FishingSystem.EnsureRodEquipped()
    if not rod then task.wait(0.5) return end
    FishingSystem.HookRodEvents(rod)
    local castRemote = rod:FindFirstChild("Cast")

    local fishingGui = FishingSystem.GetFishingGui()
    if fishingGui then
        local pre = fishingGui:FindFirstChild("PreFishingHolder")
        local hol = fishingGui:FindFirstChild("FishingHolder")
        if (pre and pre.Visible) or (hol and hol.Visible) then task.wait(0.1) return end
    end

    local bobber = FishingSystem.FindActiveBobber()
    if Runtime.Fishing.BaitLanded or bobber then
        if Runtime.Fishing.LastBaitLandedTime
            and (os.clock() - Runtime.Fishing.LastBaitLandedTime) > Settings.Fishing.BaitTimeout then
            Runtime.Fishing.BaitLanded = false
            Runtime.Fishing.CastToken = nil
        end
        task.wait(0.2) return
    end

    if (os.clock() - Runtime.Fishing.LastCastTime) < 0 then task.wait(0.1) return end

    local token = FishingSystem.EnsureCastToken()
    if not token or token == Runtime.Fishing.LastUsedToken then task.wait(0.3) return end

    if castRemote and castRemote:IsA("RemoteFunction") then
        Runtime.Fishing.IsCasting = true
        Runtime.Fishing.IsBusy = true
        Runtime.Fishing.LastUsedToken = token
        Runtime.Fishing.CastToken = nil
        Runtime.Fishing.LastCastTime = os.clock()
        local power = Settings.Fishing.CastHoldDuration or 1.0
        pcall(function() return castRemote:InvokeServer(power, token) end)
        local dl = os.clock() + 3.5
        while Runtime.Fishing.IsCasting and os.clock() < dl do
            if Runtime.Fishing.BaitLanded or not Settings.Fishing.Enabled then break end
            task.wait(0.05)
        end
        Runtime.Fishing.IsCasting = false
        Runtime.Fishing.IsBusy = false
    else
        task.wait(0.3)
    end
end

function FishingSystem.RunLegitCycle()
    if Runtime.Fishing.IsBusy then task.wait(0.1) return end
    local sus, waitSecs = FishingSystem.CheckSuspension()
    if sus then task.wait(math.clamp(waitSecs, 1, 5)) return end
    local char = Utils.GetCharacter()
    local hum  = Utils.GetHumanoid()
    if not char or not hum or hum.Health <= 0 then task.wait(0.5) return end
    local rod = FishingSystem.EnsureRodEquipped()
    if not rod then task.wait(0.5) return end
    FishingSystem.HookRodEvents(rod)

    local gui = FishingSystem.GetFishingGui()
    local bobber = FishingSystem.FindActiveBobber()

    if gui then
        local pre = gui:FindFirstChild("PreFishingHolder")
        local hol = gui:FindFirstChild("FishingHolder")
        if pre and pre.Visible then
            if Settings.Fishing.CatchMethod == "Legit" then
                FishingSystem.SolvePreFishingDrag(pre)
            else task.wait(0.1) end
        elseif hol and hol.Visible then
            if Settings.Fishing.CatchMethod ~= "Blatant" then
                FishingSystem.ProcessBarMinigame(hol)
            else task.wait(0.1) end
        else task.wait(0.05) end
        return
    end

    if Runtime.Fishing.BaitLanded or bobber then
        if Runtime.Fishing.LastBaitLandedTime
            and (os.clock() - Runtime.Fishing.LastBaitLandedTime) > Settings.Fishing.BaitTimeout then
            Runtime.Fishing.BaitLanded = false
        end
        task.wait(0.3) return
    end

    if (os.clock() - Runtime.Fishing.LastCastTime) < 0 then task.wait(0.2) return end

    local cam = workspace.CurrentCamera
    local vp = cam and cam.ViewportSize or Vector2.new(800, 600)
    local cx, cy = math.floor(vp.X * 0.5), math.floor(vp.Y * 0.5)

    if IsMobile then
        SendTouchSafe(0, cx, cy, Enum.UserInputState.Begin)
        task.wait(0.05)
        pcall(function() rod:Activate() end)
        task.wait(Settings.Fishing.CastHoldDuration)
        SendTouchSafe(0, cx, cy, Enum.UserInputState.End)
    else
        VirtualInputManager:SendMouseButtonEvent(cx, cy, 0, false, game, 1)
        task.wait(0.05)
        rod:Activate()
        task.wait(0.05)
        VirtualInputManager:SendMouseButtonEvent(cx, cy, 0, true, game, 1)
        task.wait(Settings.Fishing.CastHoldDuration)
        VirtualInputManager:SendMouseButtonEvent(cx, cy, 0, false, game, 1)
    end
    Runtime.Fishing.LastCastTime = os.clock()
    task.wait(1.0)
end

function FishingSystem.Start()
    if Runtime.Fishing.Thread then return end
    Runtime.Fishing.Thread = task.spawn(function()
        while Settings.Fishing.Enabled do
            if Settings.Fishing.CastMethod == "Blatant" then
                FishingSystem.RunBlatantCycle()
            else
                FishingSystem.RunLegitCycle()
            end
            task.wait(0.01)
        end
        Runtime.Fishing.Thread = nil
    end)
end

function FishingSystem.Stop()
    Settings.Fishing.Enabled = false
    FishingSystem.ResetSession()
    FishingSystem.UnhookRodEvents()
    if Runtime.Fishing.Thread then
        task.cancel(Runtime.Fishing.Thread)
        Runtime.Fishing.Thread = nil
    end
end

local MiningSystem = {}

function MiningSystem.GetMiningContainer()
    do
        local _genv = getgenv and getgenv()
        local _idvMap = _genv and _genv.IDV_Map
        if _idvMap and _idvMap.GetMiningContainer then
            local c = _idvMap.GetMiningContainer()
            if c then return c end
        end
    end
    local world = workspace:FindFirstChild("World")
    if world then
        for _, map in ipairs(world:GetChildren()) do
            if map.Name ~= "MainBaseplate" then
                local asset = map:FindFirstChild("Asset")
                local cont  = asset and asset:FindFirstChild("ActiveMiningStones")
                if cont then return cont end
            end
        end
    end
    local main = workspace:FindFirstChild("Main")
    if main and main:FindFirstChild("ActiveMiningStones") then return main.ActiveMiningStones end
    local rs_main = ReplicatedStorage:FindFirstChild("Main")
    if rs_main and rs_main:FindFirstChild("ActiveMiningStones") then return rs_main.ActiveMiningStones end
    return nil
end

function MiningSystem.GetOrePosition(o)
    if o:IsA("Model") then return o:GetBoundingBox().Position end
    if o:IsA("BasePart") then return o.Position end
    return nil
end

function MiningSystem.IsHotspot(s)
    if not s then return false end
    local a = s:GetAttribute("IsHotspot")
    if a ~= nil then return a == true end
    local n = s.Name:lower()
    return n:find("hotspot") ~= nil or n:find("hot") ~= nil
end

function MiningSystem.IsAllowed(s)
    if not s then return false end
    return s:IsA("BasePart") or s:IsA("Model")
end

function MiningSystem.FindNearestOre(radius)
    local hrp = Utils.GetHumanoidRootPart()
    local cont = MiningSystem.GetMiningContainer()
    if not hrp or not cont then return nil, nil end
    local bestD, bestS = radius, nil
    for _, s in ipairs(cont:GetChildren()) do
        if MiningSystem.IsAllowed(s) then
            local pos = MiningSystem.GetOrePosition(s)
            if pos then
                local d = (hrp.Position - pos).Magnitude
                if d < bestD then bestD, bestS = d, s end
            end
        end
    end
    return bestS, bestD
end

function MiningSystem.GetNextTargetStone()
    local hrp = Utils.GetHumanoidRootPart()
    local cont = MiningSystem.GetMiningContainer()
    if not hrp or not cont then return nil, nil end
    local filter = Settings.Mining.TargetFilter or "Hotspot Only"
    local bestD, bestS = math.huge, nil
    for _, s in ipairs(cont:GetChildren()) do
        if MiningSystem.IsAllowed(s) and s.Parent then
            local isHot = MiningSystem.IsHotspot(s)
            local allowed = true
            if filter == "Hotspot Only" and not isHot then allowed = false end
            local slot = s:GetAttribute("AvailableSlot")
            if slot ~= nil and slot <= 0 then allowed = false end
            if allowed then
                local pos = MiningSystem.GetOrePosition(s)
                if pos then
                    local d = (hrp.Position - pos).Magnitude
                    if d < bestD then bestD, bestS = d, s end
                end
            end
        end
    end
    return bestS, bestD
end

function MiningSystem.EnableUndergroundFloat(targetCF)
    local hrp = Utils.GetHumanoidRootPart()
    local char = Utils.GetCharacter()
    local hum = Utils.GetHumanoid()
    if not hrp or not char then return end
    Runtime.Mining.IsFloating = true
    Runtime.Mining.TargetFloatCF = targetCF
    if hum then
        pcall(function()
            hum:ChangeState(Enum.HumanoidStateType.Physics)
            hum.AutoRotate = false
        end)
    end
    for _, p in ipairs(char:GetDescendants()) do
        if p:IsA("BasePart") then
            p.CanCollide = false
            p.AssemblyLinearVelocity = Vector3.zero
            p.AssemblyAngularVelocity = Vector3.zero
        end
    end
    hrp.CFrame = targetCF
    hrp.AssemblyLinearVelocity = Vector3.zero
    hrp.AssemblyAngularVelocity = Vector3.zero

    if not Runtime.Mining.FloatMover or not Runtime.Mining.FloatMover.Parent then
        local bv = Instance.new("BodyVelocity")
        bv.Name = "Delirium_UndergroundMover"
        bv.Velocity = Vector3.zero
        bv.MaxForce = Vector3.new(1e7, 1e7, 1e7)
        bv.P = 1e5
        bv.Parent = hrp
        Runtime.Mining.FloatMover = bv
    else
        Runtime.Mining.FloatMover.Velocity = Vector3.zero
    end

    if not Runtime.Mining.FloatGyro or not Runtime.Mining.FloatGyro.Parent then
        local bg = Instance.new("BodyGyro")
        bg.Name = "Delirium_UndergroundGyro"
        bg.CFrame = targetCF
        bg.MaxTorque = Vector3.new(1e7, 1e7, 1e7)
        bg.P = 1e5 bg.D = 500
        bg.Parent = hrp
        Runtime.Mining.FloatGyro = bg
    else
        Runtime.Mining.FloatGyro.CFrame = targetCF
    end

    if not Runtime.Mining.FloatConn then
        Runtime.Mining.FloatConn = RunService.Stepped:Connect(function()
            if not Runtime.Mining.IsFloating then return end
            local c = Utils.GetCharacter()
            local root = Utils.GetHumanoidRootPart()
            local tCF = Runtime.Mining.TargetFloatCF
            if c and root then
                for _, part in ipairs(c:GetDescendants()) do
                    if part:IsA("BasePart") then
                        if part.CanCollide then part.CanCollide = false end
                    end
                end
                root.AssemblyLinearVelocity = Vector3.zero
                root.AssemblyAngularVelocity = Vector3.zero
                if tCF then root.CFrame = tCF end
            end
        end)
    end
end

function MiningSystem.DisableUndergroundFloat()
    local wasFloating = Runtime.Mining.IsFloating
    Runtime.Mining.IsFloating = false
    Runtime.Mining.TargetFloatCF = nil
    if Runtime.Mining.FloatConn then
        pcall(function() Runtime.Mining.FloatConn:Disconnect() end)
        Runtime.Mining.FloatConn = nil
    end
    if Runtime.Mining.FloatMover then
        pcall(function() Runtime.Mining.FloatMover:Destroy() end)
        Runtime.Mining.FloatMover = nil
    end
    if Runtime.Mining.FloatGyro then
        pcall(function() Runtime.Mining.FloatGyro:Destroy() end)
        Runtime.Mining.FloatGyro = nil
    end
    local hum = Utils.GetHumanoid()
    if hum then
        pcall(function()
            hum.AutoRotate = true
            hum:ChangeState(Enum.HumanoidStateType.GettingUp)
        end)
    end
    local hrp = Utils.GetHumanoidRootPart()
    if hrp then
        hrp.AssemblyLinearVelocity = Vector3.zero
        hrp.AssemblyAngularVelocity = Vector3.zero
        if wasFloating then
            local stone = Runtime.Mining.CurrentTargetStone
            local stonePos = stone and stone.Parent and MiningSystem.GetOrePosition(stone)
            if stonePos then
                hrp.CFrame = CFrame.new(stonePos + Vector3.new(0, 4.0, 0))
            else
                local depth = Settings.Mining.UndergroundDepth or 9
                hrp.CFrame = CFrame.new(hrp.Position + Vector3.new(0, depth + 5.0, 0))
            end
            hrp.AssemblyLinearVelocity = Vector3.zero
        end
    end
    pcall(function()
        local isNoclip = (typeof(MiscSettings) == "table" and MiscSettings.Noclip == true)
        if not isNoclip then
            local c = Utils.GetCharacter()
            if c then
                for _, part in ipairs(c:GetDescendants()) do
                    if part:IsA("BasePart") then part.CanCollide = true end
                end
            end
        end
    end)
end

function MiningSystem.FindPickaxe()
    local char = Utils.GetCharacter()
    local bp = LocalPlayer:FindFirstChildOfClass("Backpack")
    local function check(parent)
        if not parent then return nil end
        for _, item in ipairs(parent:GetChildren()) do
            if item:IsA("Tool") and (item:FindFirstChild("Mine") or item:GetAttribute("IsPickaxe")) then
                return item
            end
        end
        return nil
    end
    return check(char) or check(bp)
end

function MiningSystem.EnsurePickaxeEquipped()
    local px = MiningSystem.FindPickaxe() if not px then return nil end
    if Runtime.Mining.HookedPickaxe ~= px then
        Runtime.Mining.SessionToken = nil
        MiningSystem.HookPickaxeEvents(px)
        Runtime.Mining.HookedPickaxe = px
    end
    local char = Utils.GetCharacter()
    if Settings.Mining.AutoEquipPickaxe and char and px.Parent ~= char then
        local hum = Utils.GetHumanoid()
        if hum then
            hum:EquipTool(px)
            local dl = os.clock() + 2.0
            while not Runtime.Mining.SessionToken and os.clock() < dl do task.wait(0.05) end
        end
    end
    return px
end

function MiningSystem.PlayFakeHit(stone, pickaxe)
    local hum = Utils.GetHumanoid()
    local animator = hum and hum:FindFirstChildWhichIsA("Animator")
    local tool = pickaxe or MiningSystem.FindPickaxe()
    local count = math.max(1, Settings.Mining.FakeHitRepeatCount or 1)
    local target = stone or Runtime.Mining.CurrentTargetStone
    local swings = {}
    if animator and tool then
        local af = tool:FindFirstChild("Animation")
        if af then
            for _, name in ipairs({"Swing1", "Swing2", "Swing3"}) do
                local a = af:FindFirstChild(name)
                if a and a:IsA("Animation") then table.insert(swings, a) end
            end
        end
    end
    local sounds = {}
    if tool then
        local ui = tool:FindFirstChild("MiningUI")
        if ui then
            for _, name in ipairs({"Mining1", "Mining2", "Mining3"}) do
                local s = ui:FindFirstChild(name)
                if s and s:IsA("Sound") then table.insert(sounds, s) end
            end
        end
    end
    for i = 1, count do
        if #swings > 0 then
            pcall(function()
                local t = animator:LoadAnimation(swings[math.random(1, #swings)])
                t.Priority = Enum.AnimationPriority.Action
                t:Play(0.05)
            end)
        end
        if #sounds > 0 then
            pcall(function() sounds[math.random(1, #sounds)]:Play() end)
        end
        if target then
            pcall(function()
                local pos = MiningSystem.GetOrePosition(target)
                if pos then
                    local pm = ReplicatedStorage:FindFirstChild("Lib")
                    pm = pm and pm:FindFirstChild("Particle")
                    if pm then
                        local P = require(pm)
                        if P and P.PlayClientEmitter then P.PlayClientEmitter("MiningEffect", pos) end
                    end
                end
            end)
        end
        if i < count then task.wait(0.25 + math.random() * 0.30) end
    end
end

function MiningSystem.PlayFakeHitTimed(stone, pickaxe, duration)
    local hum = Utils.GetHumanoid()
    local animator = hum and hum:FindFirstChildWhichIsA("Animator")
    local tool = pickaxe or MiningSystem.FindPickaxe()
    local target = stone or Runtime.Mining.CurrentTargetStone
    local dl = os.clock() + duration
    local swings, sounds = {}, {}
    if animator and tool then
        local af = tool:FindFirstChild("Animation")
        if af then
            for _, name in ipairs({"Swing1", "Swing2", "Swing3"}) do
                local a = af:FindFirstChild(name)
                if a and a:IsA("Animation") then table.insert(swings, a) end
            end
        end
    end
    if tool then
        local ui = tool:FindFirstChild("MiningUI")
        if ui then
            for _, name in ipairs({"Mining1", "Mining2", "Mining3"}) do
                local s = ui:FindFirstChild(name)
                if s and s:IsA("Sound") then table.insert(sounds, s) end
            end
        end
    end
    while os.clock() < dl do
        if #swings > 0 then
            pcall(function()
                local t = animator:LoadAnimation(swings[math.random(1, #swings)])
                t.Priority = Enum.AnimationPriority.Action
                t:Play(0.05)
            end)
        end
        if #sounds > 0 then
            pcall(function() sounds[math.random(1, #sounds)]:Play() end)
        end
        if target then
            pcall(function()
                local pos = MiningSystem.GetOrePosition(target)
                if pos then
                    local pm = ReplicatedStorage:FindFirstChild("Lib")
                    pm = pm and pm:FindFirstChild("Particle")
                    if pm then
                        local P = require(pm)
                        if P and P.PlayClientEmitter then P.PlayClientEmitter("MiningEffect", pos) end
                    end
                end
            end)
        end
        local rem = dl - os.clock()
        local jeda = 0.30 + math.random() * 0.35
        if rem <= jeda + 0.05 then break end
        task.wait(jeda)
    end
end

function MiningSystem.ResetSession()
    if Runtime.Mining.ActiveHitThread then
        pcall(task.cancel, Runtime.Mining.ActiveHitThread)
        Runtime.Mining.ActiveHitThread = nil
    end
    Runtime.Mining.SessionToken = nil
    Runtime.Mining.IsBusy = false
    Runtime.Mining.CurrentTargetStone = nil
    local pg = LocalPlayer:FindFirstChildOfClass("PlayerGui")
    if pg then
        for _, g in ipairs(pg:GetChildren()) do
            if g:FindFirstChild("PreMiningHolder") or g.Name == "MiningUI" then
                pcall(function() g:Destroy() end)
            end
        end
    end
end

function MiningSystem.FastReEquipPickaxe(px)
    local hum = Utils.GetHumanoid() if not hum then return end
    local target = px or MiningSystem.FindPickaxe() if not target then return end
    Runtime.Mining.IsInternalReEquip = true
    Runtime.Mining.SessionToken = nil
    hum:UnequipTools() task.wait(0.15) hum:EquipTool(target)
    MiningSystem.HookPickaxeEvents(target) task.wait(0.05)
    Runtime.Mining.IsInternalReEquip = false
end

function MiningSystem.UnhookPickaxeEvents()
    Utils.ClearConnections(Runtime.Mining.Connections)
    Runtime.Mining.HookedPickaxe = nil
end

function MiningSystem.HookPickaxeEvents(px)
    if not px then return end
    MiningSystem.UnhookPickaxeEvents()
    Runtime.Mining.HookedPickaxe = px
    Utils.AddConnection(Runtime.Mining.Connections, px.Unequipped:Connect(function()
        if not Runtime.Mining.IsInternalReEquip then MiningSystem.ResetSession() end
    end))
    local cancelRemote = px:FindFirstChild("MiningCancel")
    if cancelRemote then
        Utils.AddConnection(Runtime.Mining.Connections, cancelRemote.OnClientEvent:Connect(function()
            MiningSystem.ResetSession()
        end))
    end
    local toolReady = px:FindFirstChild("ToolReady")
    if toolReady then
        Utils.AddConnection(Runtime.Mining.Connections, toolReady.OnClientEvent:Connect(function(token)
            Runtime.Mining.SessionToken = token
        end))
    end
    local mineResult = px:FindFirstChild("MineResult")
    if mineResult then
        Utils.AddConnection(Runtime.Mining.Connections, mineResult.OnClientEvent:Connect(function(result)
            local success = (type(result) == "table" and result.CanMine == true)
            if success then
                Settings.Mining.TotalMined = Settings.Mining.TotalMined + 1
            else
                Settings.Mining.TotalFailed = Settings.Mining.TotalFailed + 1
            end
            if MiningSystem.OnStatsUpdated then
                MiningSystem.OnStatsUpdated(Settings.Mining.TotalMined, Settings.Mining.TotalFailed)
            end
        end))
    end
    local startMini = px:FindFirstChild("StartMinigame")
    if startMini then
        Utils.AddConnection(Runtime.Mining.Connections, startMini.OnClientEvent:Connect(function(_, arg3)
            if Settings.Mining.MineMethod ~= "Blatant" or not Settings.Mining.Enabled then return end
            local char = Utils.GetCharacter()
            if not char or px.Parent ~= char then MiningSystem.ResetSession() return end
            local mr = px:FindFirstChild("MineResult")
            if not mr then Runtime.Mining.IsBusy = false return end
            if Runtime.Mining.ActiveHitThread then
                pcall(task.cancel, Runtime.Mining.ActiveHitThread)
                Runtime.Mining.ActiveHitThread = nil
            end
            local boulder = (type(arg3) == "table" and arg3.boulder) or Runtime.Mining.CurrentTargetStone
            Runtime.Mining.ActiveHitThread = task.spawn(function()
                if Settings.Mining.FakeHitAnimation then
                    MiningSystem.PlayFakeHitTimed(boulder, px, Settings.Mining.BlatantHitDelay - 0.20)
                else
                    task.wait(Settings.Mining.BlatantHitDelay)
                end
                local cur = Utils.GetCharacter()
                if not Settings.Mining.Enabled
                    or Settings.Mining.MineMethod ~= "Blatant"
                    or not cur or px.Parent ~= cur then
                    MiningSystem.ResetSession() return
                end
                if Settings.Mining.FakeHitAnimation then
                    MiningSystem.PlayFakeHit(boulder, px)
                end
                pcall(function() mr:FireServer(true) end)
                local pg = LocalPlayer:FindFirstChildOfClass("PlayerGui")
                if pg then
                    for _, g in ipairs(pg:GetChildren()) do
                        if g:FindFirstChild("PreMiningHolder") or g.Name == "MiningUI" then
                            pcall(function() g:Destroy() end)
                        end
                    end
                end
                task.wait(0.25)
                local after = Utils.GetCharacter()
                if not Settings.Mining.Enabled or not after or px.Parent ~= after then
                    MiningSystem.ResetSession() return
                end
                MiningSystem.FastReEquipPickaxe(px)
                local dl = os.clock() + 2.5
                while not Runtime.Mining.SessionToken and os.clock() < dl do task.wait(0.05) end
                task.wait(0.08)
                Runtime.Mining.ActiveHitThread = nil
                Runtime.Mining.IsBusy = false
            end)
        end))
    end
end

function MiningSystem.HookMiningGui(gui)
    local pre = gui:FindFirstChild("PreMiningHolder")
    local mineH = gui:FindFirstChild("MiningHolder")
    if not (pre and mineH) then return end
    local dragBtn = pre:FindFirstChild("DragButton")
    local targetF = pre:FindFirstChild("TargetFrame")
    local dragDet = dragBtn and dragBtn:FindFirstChild("UIDragDetector")
    local mineF = mineH:FindFirstChild("MiningFrame")
    local barC = mineF and mineF:FindFirstChild("BarContainer")
    local bar  = barC and barC:FindFirstChild("Bar")
    local point= barC and barC:FindFirstChild("Point")
    if not (dragBtn and targetF and dragDet and bar and point) then return end

    local hitDebounce = false

local function executeHit()
    if hitDebounce then return end
    hitDebounce = true
    task.delay(Settings.Mining.HitGap or 0.12, function() hitDebounce = false end)
    local hitDone = false

    if firesignal then
        if bar and bar.Parent then
            pcall(function()
                firesignal(bar.InputBegan, {
                    UserInputType  = Enum.UserInputType.MouseButton1,
                    UserInputState = Enum.UserInputState.Begin,
                    KeyCode        = Enum.KeyCode.Unknown,
                })
                hitDone = true
            end)
        end
        if not hitDone and mineH and mineH.Parent then
            pcall(function()
                firesignal(mineH.InputBegan, {
                    UserInputType  = Enum.UserInputType.MouseButton1,
                    UserInputState = Enum.UserInputState.Begin,
                    KeyCode        = Enum.KeyCode.Unknown,
                })
                hitDone = true
            end)
        end
        if not hitDone then
            pcall(function()
                firesignal(UserInputService.InputBegan, {
                    UserInputType  = Enum.UserInputType.MouseButton1,
                    UserInputState = Enum.UserInputState.Begin,
                    KeyCode        = Enum.KeyCode.Unknown,
                }, false)
                hitDone = true
            end)
        end
    end

    if not hitDone and keypress and keyrelease then
        pcall(function()
            keypress(0x20) task.wait(0.02) keyrelease(0x20)
            hitDone = true
        end)
    end

    if not hitDone then
        pcall(function()
            if IsMobile and bar and bar.Parent then
                local bap3 = bar.AbsolutePosition
                local bas3 = bar.AbsoluteSize
                Utils.SendClick(
                    math.floor(bap3.X + bas3.X * 0.5),
                    math.floor(bap3.Y + bas3.Y * 0.5)
                )
            else
                Utils.SendClick(10, 10)
            end
        end)
    end
end

    local px = MiningSystem.FindPickaxe()
    if px and Runtime.Mining.SessionToken then
        local op = px:FindFirstChild("MinigameOpened")
        if op then task.spawn(function() pcall(function() op:FireServer(Runtime.Mining.SessionToken) end) end) end
    end

    local stepConn, roundConn
    stepConn = RunService.Heartbeat:Connect(function()
        if not Settings.Mining.Enabled or not gui.Parent then
            stepConn:Disconnect()
            if roundConn then roundConn:Disconnect() end
            Runtime.Mining.IsBusy = false
            return
        end
        if Settings.Mining.MineMethod ~= "Legit" then return end
        if pre.Visible and dragDet.Enabled then
            task.spawn(function()
                dragBtn.Position = UDim2.new(
                    targetF.Position.X.Scale, targetF.Position.X.Offset,
                    targetF.Position.Y.Scale, targetF.Position.Y.Offset)
                RunService.Heartbeat:Wait()
                if firesignal then
                    pcall(firesignal, dragDet.DragStart) task.wait(0.02)
                    pcall(firesignal, dragDet.DragContinue)
                elseif IsMobile then
                    local bap2 = dragBtn.AbsolutePosition
                    local bas2 = dragBtn.AbsoluteSize
                    local bx0m = math.floor(bap2.X + bas2.X * 0.5)
                    local by0m = math.floor(bap2.Y + bas2.Y * 0.5)
                    local tap2, tas2 = targetF.AbsolutePosition, targetF.AbsoluteSize
                    local txm = math.floor(tap2.X + tas2.X * 0.5)
                    local tym = math.floor(tap2.Y + tas2.Y * 0.5)
                    pcall(function()
                        SendTouchSafe(0, bx0m, by0m, Enum.UserInputState.Begin)
                        task.wait(0.04)
                        for si2 = 1, 5 do
                            local t2 = si2 / 5
                            local ix2 = math.floor(bx0m + (txm - bx0m) * t2)
                            local iy2 = math.floor(by0m + (tym - by0m) * t2)
                            SendTouchSafe(0, ix2, iy2, Enum.UserInputState.Change)
                            task.wait(0.025)
                        end
                        SendTouchSafe(0, txm, tym, Enum.UserInputState.End)
                    end)
                end
                repeat task.wait()
                until not gui.Parent or mineH.Visible or not pre.Visible
            end)
        elseif mineH.Visible then
            local mp = point.Position.X.Scale
            local cp = bar.Position.X.Scale
            local hw = bar.Size.X.Scale / 2
            local pct = Settings.Mining.SafeZonePercent or 0.5
            if pct > 1 then pct = pct / 100 end
            pct = math.clamp(pct, 0.1, 1.0)
            local r = hw * pct
            if mp >= (cp - r) and mp <= (cp + r) then executeHit() end
        end
    end)

    roundConn = gui:GetAttributeChangedSignal("CurrentRound"):Connect(function()
        if Settings.Mining.MineMethod ~= "Legit" then return end
        local cur = MiningSystem.FindPickaxe()
        if cur and Runtime.Mining.SessionToken then
            local ref = cur:FindFirstChild("RefreshMultipliers")
            if ref then pcall(function() ref:FireServer(Runtime.Mining.SessionToken) end) end
        end
    end)

    gui.Destroying:Connect(function()
        stepConn:Disconnect()
        if roundConn then roundConn:Disconnect() end
        task.wait(0.2)
        Runtime.Mining.IsBusy = false
    end)
end

function MiningSystem.MineOre(stone)
    local px = MiningSystem.EnsurePickaxeEquipped()
    if not px then Runtime.Mining.IsBusy = false return end
    local mr = px:FindFirstChild("Mine")
    if not mr then Runtime.Mining.IsBusy = false return end
    local hrp = Utils.GetHumanoidRootPart()
    local orePos = MiningSystem.GetOrePosition(stone)
    if hrp and orePos and not Runtime.Mining.IsFloating then
        local look = Vector3.new(orePos.X, hrp.Position.Y, orePos.Z)
        if (look - hrp.Position).Magnitude > 0.05 then
            hrp.CFrame = CFrame.lookAt(hrp.Position, look)
        end
    end
    if not Runtime.Mining.SessionToken then
        MiningSystem.FastReEquipPickaxe(px)
        local to = os.clock() + 2.0
        while not Runtime.Mining.SessionToken and os.clock() < to do task.wait(0.05) end
        if not Runtime.Mining.SessionToken then Runtime.Mining.IsBusy = false return end
    end
    local token = Runtime.Mining.SessionToken
    Runtime.Mining.SessionToken = nil
    task.spawn(function()
        local ok, success = pcall(function() return mr:InvokeServer(token) end)
        if not ok or success == false then
            task.delay(0.2, function()
                MiningSystem.FastReEquipPickaxe(px)
                Runtime.Mining.IsBusy = false
            end)
        end
    end)
    task.delay(Settings.Mining.WatchdogTimeout, function()
        if not Runtime.Mining.IsBusy then return end
        local hasGui = false
        local pg = LocalPlayer:FindFirstChildOfClass("PlayerGui")
        if pg then
            for _, g in ipairs(pg:GetChildren()) do
                if g:FindFirstChild("PreMiningHolder") or g.Name == "MiningUI" then
                    hasGui = true break
                end
            end
        end
        if not hasGui then Runtime.Mining.IsBusy = false end
    end)
end

function MiningSystem.WalkToOre(stone)
    local reachDist = Settings.Mining.AutoWalkReachDist or 12
    local function shouldAbort()
        return not Settings.Mining.Enabled or not Settings.Mining.AutoWalk or not stone.Parent
    end

    local hrp = Utils.GetHumanoidRootPart()
    local hum = Utils.GetHumanoid()
    if not hrp or not hum then return false end

    local orePos = MiningSystem.GetOrePosition(stone)
    if not orePos then return false end
    if (hrp.Position - orePos).Magnitude <= reachDist then return true end

    local PARAMS = {
        AgentRadius = 2, AgentHeight = 5,
        AgentCanJump = true, AgentCanClimb = true,
        WalkableSlopeAngle = 89,
    }
    local WP_REACH, WP_TIMEOUT, MAX_ATTEMPTS = 4, 6.0, 8

    for _ = 1, MAX_ATTEMPTS do
        if shouldAbort() then return false end
        hrp = Utils.GetHumanoidRootPart()
        hum = Utils.GetHumanoid()
        if not hrp or not hum then return false end
        orePos = MiningSystem.GetOrePosition(stone)
        if not orePos then return false end
        if (hrp.Position - orePos).Magnitude <= reachDist then return true end

        local path = PathfindingService:CreatePath(PARAMS)
        local ok = pcall(function() path:ComputeAsync(hrp.Position, orePos) end)

        if ok and path.Status == Enum.PathStatus.Success then
            local wps = path:GetWaypoints()
            if #wps > 0 then
                for _, wp in ipairs(wps) do
                    if shouldAbort() then return false end
                    hrp = Utils.GetHumanoidRootPart()
                    hum = Utils.GetHumanoid()
                    if not hrp or not hum then return false end
                    orePos = MiningSystem.GetOrePosition(stone)
                    if orePos and (hrp.Position - orePos).Magnitude <= reachDist then return true end
                    if wp.Action == Enum.PathWaypointAction.Jump then hum.Jump = true end
                    hum:MoveTo(wp.Position)
                    local t0 = os.clock()
                    repeat
                        task.wait(0.05)
                        hrp = Utils.GetHumanoidRootPart()
                        if not hrp then break end
                    until shouldAbort()
                        or (hrp.Position - wp.Position).Magnitude <= WP_REACH
                        or (os.clock() - t0) >= WP_TIMEOUT
                    if shouldAbort() then return false end
                end
            end
        else
            pcall(function() hum:MoveTo(orePos) end)
            local t0 = os.clock()
            repeat
                task.wait(0.1)
                hrp = Utils.GetHumanoidRootPart()
                if not hrp then break end
            until shouldAbort()
                or (hrp.Position - orePos).Magnitude <= reachDist
                or (os.clock() - t0) >= 4.0
            if shouldAbort() then return false end
        end

        hrp = Utils.GetHumanoidRootPart()
        if hrp then
            orePos = MiningSystem.GetOrePosition(stone)
            if orePos and (hrp.Position - orePos).Magnitude <= reachDist then return true end
        end
        task.wait(0.15)
    end

    hrp = Utils.GetHumanoidRootPart()
    if hrp then
        local fp = MiningSystem.GetOrePosition(stone)
        return fp ~= nil and (hrp.Position - fp).Magnitude <= reachDist
    end
    return false
end

function MiningSystem.Start()
    if Runtime.Mining.Thread then return end
    Runtime.Mining.Thread = task.spawn(function()
        while Settings.Mining.Enabled do
            task.wait(Settings.Mining.LoopDelay)
            if not Settings.Mining.Enabled then break end
            if Runtime.Mining.IsBusy then continue end
            local px = MiningSystem.EnsurePickaxeEquipped()
            if not px then continue end
            if Settings.Mining.FullyAuto then
                local cur = Runtime.Mining.CurrentTargetStone
                local valid = cur and cur.Parent and MiningSystem.IsAllowed(cur)
                    and (cur:GetAttribute("AvailableSlot") == nil or cur:GetAttribute("AvailableSlot") > 0)
                if not valid then
                    local next = MiningSystem.GetNextTargetStone()
                    if next then Runtime.Mining.CurrentTargetStone = next cur = next
                    else task.wait(0.5) continue end
                end
                if cur and cur.Parent then
                    local orePos = MiningSystem.GetOrePosition(cur)
                    if orePos then
                        local depth = math.clamp(Settings.Mining.UndergroundDepth or 9, 3, 40)
                        local under = orePos - Vector3.new(0, depth, 0)
                        local targetCF = CFrame.lookAt(under, orePos)
                        MiningSystem.EnableUndergroundFloat(targetCF)
                        Runtime.Mining.IsBusy = true
                        MiningSystem.MineOre(cur)
                    end
                end
            else
                if Runtime.Mining.IsFloating then MiningSystem.DisableUndergroundFloat() end
                local target = MiningSystem.FindNearestOre(Settings.Mining.AutoWalk and 5000 or Settings.Mining.SearchRadius)
                if target then
                    Runtime.Mining.CurrentTargetStone = target
                    Runtime.Mining.IsBusy = true
                    if Settings.Mining.AutoWalk then
                        if not MiningSystem.WalkToOre(target) then
                            Runtime.Mining.IsBusy = false
                            continue
                        end
                    end
                    MiningSystem.MineOre(target)
                end
            end
        end
        Runtime.Mining.Thread = nil
    end)
end

function MiningSystem.Stop()
    Settings.Mining.Enabled = false
    if Runtime.Mining.Thread then
        task.cancel(Runtime.Mining.Thread)
        Runtime.Mining.Thread = nil
    end
    MiningSystem.DisableUndergroundFloat()
    MiningSystem.ResetSession()
    MiningSystem.UnhookPickaxeEvents()
end

Utils.AddConnection(Runtime.GlobalConnections, PlayerGui.ChildAdded:Connect(function(child)
    RunService.Heartbeat:Wait()
    if child:FindFirstChild("PreMiningHolder") then
        if Settings.Mining.MineMethod == "Legit" then
            Runtime.Mining.IsBusy = true
            MiningSystem.HookMiningGui(child)
        end
    end
end))
for _, g in ipairs(PlayerGui:GetChildren()) do
    if g:FindFirstChild("PreMiningHolder") and Settings.Mining.MineMethod == "Legit" then
        Runtime.Mining.IsBusy = true
        MiningSystem.HookMiningGui(g)
    end
end

Utils.AddConnection(Runtime.GlobalConnections, LocalPlayer.CharacterAdded:Connect(function()
    Runtime.Mining.SessionToken = nil
    Runtime.Mining.HookedPickaxe = nil
    Runtime.Fishing.CastToken = nil
    Runtime.Fishing.BaitLanded = false
    task.wait(1)
    if Settings.Mining.Enabled then MiningSystem.EnsurePickaxeEquipped() end
    if Settings.Fishing.Enabled then FishingSystem.EnsureRodEquipped() end
end))

task.spawn(function()
    local gre = ReplicatedStorage:FindFirstChild("GameRemoteEvents")
                or ReplicatedStorage:WaitForChild("GameRemoteEvents", 6)
    if gre then
        local re = gre:FindFirstChild("CreateFishRewardInfoEvent")
                  or gre:WaitForChild("CreateFishRewardInfoEvent", 6)
        if re and re:IsA("RemoteEvent") then
            Utils.AddConnection(Runtime.GlobalConnections, re.OnClientEvent:Connect(function(_)
                Runtime.Fishing.BaitLanded = false
                Settings.Fishing.TotalFishCaught = Settings.Fishing.TotalFishCaught + 1
                if FishingSystem.OnFishCaught then
                    FishingSystem.OnFishCaught(Settings.Fishing.TotalFishCaught)
                end
            end))
        end
    end
end)

local AutoClaim = {}
local ClaimSettings = { AutoClaimDaily = false, AutoClaimSession = false }
local ClaimRuntime  = { Thread = nil }

local function GetClaimRemotes()
    local fns = ReplicatedStorage:FindFirstChild("GameRemoteFunctions")
    if not fns then return nil, nil end
    return fns:FindFirstChild("CollectDailyRewardFunction"),
           fns:FindFirstChild("CollectSessionRewardFunction")
end

local function TryClaimDaily()
    local dailyFn = GetClaimRemotes()
    if not dailyFn then return false end
    local ok, result = pcall(function() return dailyFn:InvokeServer() end)
    if ok and result then
        local pg = LocalPlayer:FindFirstChildOfClass("PlayerGui")
        local rGui = pg and pg:FindFirstChild("Reward")
        if rGui then
            local cb = rGui:FindFirstChild("Holder")
                and rGui.Holder:FindFirstChild("Frame")
                and rGui.Holder.Frame:FindFirstChild("Body")
                and rGui.Holder.Frame.Body:FindFirstChild("Daily")
                and rGui.Holder.Frame.Body.Daily:FindFirstChild("ClaimFrame")
                and rGui.Holder.Frame.Body.Daily.ClaimFrame:FindFirstChild("ClaimButton")
            if cb and cb.Visible then pcall(function() cb:activate() end) end
        end
        return true
    end
    return false
end

local function TryClaimSession()
    local _, sessionFn = GetClaimRemotes()
    if not sessionFn then return false end
    local claimedAny = false
    for i = 1, 12 do
        local ok, res = pcall(function() return sessionFn:InvokeServer(i) end)
        if ok and res == true then claimedAny = true end
        task.wait(0.08)
    end
    local pg = LocalPlayer:FindFirstChildOfClass("PlayerGui")
    local rGui = pg and pg:FindFirstChild("Reward")
    if rGui then
        local inner = rGui:FindFirstChild("Holder")
            and rGui.Holder:FindFirstChild("Frame")
            and rGui.Holder.Frame:FindFirstChild("Body")
            and rGui.Holder.Frame.Body:FindFirstChild("Session")
            and rGui.Holder.Frame.Body.Session:FindFirstChild("SessionFrame")
        if inner then
            for _, slot in ipairs(inner:GetChildren()) do
                if slot:IsA("Frame") then
                    local c = slot:FindFirstChild("Claimed", true)
                    if not (c and c.Visible) then
                        local b = slot:FindFirstChild("ClaimButton", true)
                        if b and b.Visible then pcall(function() b:activate() end) end
                    end
                end
            end
        end
    end
    return claimedAny
end

local function RunClaimLoop()
    while ClaimSettings.AutoClaimDaily or ClaimSettings.AutoClaimSession do
        if ClaimSettings.AutoClaimDaily then
            if TryClaimDaily() then
                Notify({ Title = "Auto Claim", Message = "Hadiah harian berhasil diklaim!",
                    Type = "success", Duration = 4 })
            end
        end
        if ClaimSettings.AutoClaimSession then
            if TryClaimSession() then
                Notify({ Title = "Auto Claim", Message = "Hadiah sesi berhasil diklaim!",
                    Type = "success", Duration = 4 })
            end
        end
        task.wait(30)
    end
end

function AutoClaim.Start()
    if ClaimRuntime.Thread then task.cancel(ClaimRuntime.Thread) end
    ClaimRuntime.Thread = task.spawn(RunClaimLoop)
end
function AutoClaim.Stop()
    if ClaimRuntime.Thread then
        task.cancel(ClaimRuntime.Thread)
        ClaimRuntime.Thread = nil
    end
end
local function UpdateClaimLoop()
    if ClaimSettings.AutoClaimDaily or ClaimSettings.AutoClaimSession then
        AutoClaim.Start()
    else
        AutoClaim.Stop()
    end
end

task.spawn(function()
    local pg = LocalPlayer:FindFirstChildOfClass("PlayerGui") if not pg then return end
    local rGui = pg:WaitForChild("Reward", 10) if not rGui then return end
    Utils.AddConnection(Runtime.GlobalConnections, rGui:GetPropertyChangedSignal("Enabled"):Connect(function()
        if not rGui.Enabled then return end
        task.wait(0.5)
        if ClaimSettings.AutoClaimDaily then TryClaimDaily() end
        if ClaimSettings.AutoClaimSession then TryClaimSession() end
    end))
end)

local AntiAFK = {}
local AntiAFKSettings = { Enabled = false }
local AntiAFKRuntime  = {
    Thread = nil, PopupConn = nil, AFKFrameConn = nil,
    ConfirmConn = nil, AFKCheckConn = nil,
}

local _afkDecision = nil
local function GetAFKDecisionEvent()
    if _afkDecision and _afkDecision.Parent then return _afkDecision end
    local ge = ReplicatedStorage:FindFirstChild("GameRemoteEvents")
    if ge then _afkDecision = ge:FindFirstChild("AFKCheckDecisionEvent") end
    return _afkDecision
end
local function FireAFKDecision()
    local ev = GetAFKDecisionEvent()
    if ev then pcall(function() ev:FireServer() end) end
end

local function HasDismissOption(gui)
    if not gui then return false end
    for _, d in ipairs(gui:GetDescendants()) do
        if d:IsA("TextLabel") or d:IsA("TextButton") then
            local t = string.lower(d.Text or "")
            if string.find(t, "dismiss") then return true end
        end
    end
    return false
end

local function HasAFKContent(pop)
    if not pop then return false end
    local ctrl = pop:FindFirstChild("PopUpNotificationUIController")
    local cfg  = ctrl and ctrl:FindFirstChild("ObjectConfig")
    local mv   = cfg and cfg:FindFirstChild("MessageLabel")
    local mb   = mv and mv.Value
    local txt  = string.lower((mb and mb.Text) or "")
    if string.find(txt, "afk") or string.find(txt, "idle") or string.find(txt, "moved to") then
        return true
    end
    for _, d in ipairs(pop:GetDescendants()) do
        if d:IsA("TextLabel") then
            local t = string.lower(d.Text or "")
            if string.find(t, "afk") or string.find(t, "idle") or string.find(t, "moved to") then
                return true
            end
        end
    end
    return false
end

local function DismissConfirmation(timeout)
    if not AntiAFKSettings.Enabled then return end
    local pg = LocalPlayer:FindFirstChildOfClass("PlayerGui") if not pg then return end
    local conf = pg:FindFirstChild("Confirmation")
    if not conf or not conf.Enabled then return end
    if not HasDismissOption(conf) then return end
    local ctrl = conf:FindFirstChild("ConfirmationUIController")
    local cfg  = ctrl and ctrl:FindFirstChild("ObjectConfig")
    local cbV  = cfg and cfg:FindFirstChild("CloseButton")
    local cb   = cbV and cbV.Value
    local dl = os.clock() + (timeout or 35)
    if cb then
        while not cb.Active and os.clock() < dl do
            if not HasDismissOption(conf) then return end
            task.wait(0.5)
        end
        if cb.Active and HasDismissOption(conf) then
            pcall(function() cb:Activate() end)
            if firesignal then
                pcall(function() firesignal(cb.Activated) end)
                pcall(function() firesignal(cb.MouseButton1Click) end)
            end
        end
    end
    FireAFKDecision()
end

local function DismissAFKFrame()
    local pg = LocalPlayer:FindFirstChildOfClass("PlayerGui")
    local hud = pg and pg:FindFirstChild("HUD") if not hud then return end
    local f = hud:FindFirstChild("AFKFrame")
    if not (f and f.Visible) then return end
    for _, o in ipairs(f:GetDescendants()) do
        if (o:IsA("TextButton") or o:IsA("ImageButton")) and o.Visible then
            pcall(function() o:Activate() end)
            if firesignal then
                pcall(function() firesignal(o.Activated) end)
                pcall(function() firesignal(o.MouseButton1Click) end)
            end
        end
    end
end

local function DismissPopUpNotification()
    local pg = LocalPlayer:FindFirstChildOfClass("PlayerGui")
    local pop = pg and pg:FindFirstChild("PopUpNotification")
    if not pop or not pop.Enabled then return end
    if not HasAFKContent(pop) then return end
    local ctrl = pop:FindFirstChild("PopUpNotificationUIController")
    local hideFn = ctrl and ctrl:FindFirstChild("HideFunction")
    local cfg  = ctrl and ctrl:FindFirstChild("ObjectConfig")
    local cbV  = cfg and cfg:FindFirstChild("CloseButton")
    local cb   = cbV and cbV.Value
    if not cb then
        local h = pop:FindFirstChild("Holder")
        local f = h and h:FindFirstChild("Frame")
        local b = f and f:FindFirstChild("Body")
        cb = b and b:FindFirstChild("CloseButton")
    end
    if cb then
        local dl = os.clock() + 35
        while not cb.Active and os.clock() < dl do
            if not pop.Enabled then return end
            task.wait(0.5)
        end
        if cb.Active then
            pcall(function() cb:Activate() end)
            if firesignal then
                pcall(function() firesignal(cb.Activated) end)
                pcall(function() firesignal(cb.MouseButton1Click) end)
            end
        end
    end
    if hideFn then pcall(function() hideFn:Invoke() end) end
    FireAFKDecision()
end

local function RunAntiAFKLoop()
    while AntiAFKSettings.Enabled do
        pcall(function()
            VirtualInputManager:SendMouseMoveEvent(1, 0, game)
            task.wait(0.03)
            VirtualInputManager:SendMouseMoveEvent(-1, 0, game)
        end)
        DismissAFKFrame()
        task.wait(15)
    end
end

function AntiAFK.Start()
    AntiAFKSettings.Enabled = true
    if AntiAFKRuntime.Thread then task.cancel(AntiAFKRuntime.Thread) end
    AntiAFKRuntime.Thread = task.spawn(RunAntiAFKLoop)

    local pg = LocalPlayer:FindFirstChildOfClass("PlayerGui") if not pg then return end

    local ge = ReplicatedStorage:FindFirstChild("GameRemoteEvents")
    local ce = ge and ge:FindFirstChild("AFKCheckEvent")
    if ce then
        if AntiAFKRuntime.AFKCheckConn then AntiAFKRuntime.AFKCheckConn:Disconnect() end
        AntiAFKRuntime.AFKCheckConn = ce.OnClientEvent:Connect(function(deadline)
            if not AntiAFKSettings.Enabled then return end
            task.spawn(function()
                task.wait(0.5)
                DismissConfirmation(deadline or 35)
            end)
        end)
    end

    local conf = pg:FindFirstChild("Confirmation")
    if conf then
        if AntiAFKRuntime.ConfirmConn then AntiAFKRuntime.ConfirmConn:Disconnect() end
        AntiAFKRuntime.ConfirmConn = conf:GetPropertyChangedSignal("Enabled"):Connect(function()
            if conf.Enabled and AntiAFKSettings.Enabled then
                task.spawn(function()
                    task.wait(0.3)
                    if HasDismissOption(conf) then DismissConfirmation(35) end
                end)
            end
        end)
    end

    local pop = pg:FindFirstChild("PopUpNotification")
    if pop then
        if AntiAFKRuntime.PopupConn then AntiAFKRuntime.PopupConn:Disconnect() end
        AntiAFKRuntime.PopupConn = pop:GetPropertyChangedSignal("Enabled"):Connect(function()
            if pop.Enabled and AntiAFKSettings.Enabled then
                task.spawn(function()
                    task.wait(0.3)
                    if HasAFKContent(pop) then DismissPopUpNotification() end
                end)
            end
        end)
    end

    local hud = pg:FindFirstChild("HUD")
    local f = hud and hud:FindFirstChild("AFKFrame")
    if f then
        if AntiAFKRuntime.AFKFrameConn then AntiAFKRuntime.AFKFrameConn:Disconnect() end
        AntiAFKRuntime.AFKFrameConn = f:GetPropertyChangedSignal("Visible"):Connect(function()
            if f.Visible and AntiAFKSettings.Enabled then
                task.wait(0.2)
                DismissAFKFrame()
            end
        end)
    end
end

function AntiAFK.Stop()
    AntiAFKSettings.Enabled = false
    if AntiAFKRuntime.Thread then
        task.cancel(AntiAFKRuntime.Thread)
        AntiAFKRuntime.Thread = nil
    end
    for _, k in ipairs({"PopupConn","AFKFrameConn","ConfirmConn","AFKCheckConn"}) do
        if AntiAFKRuntime[k] then
            AntiAFKRuntime[k]:Disconnect()
            AntiAFKRuntime[k] = nil
        end
    end
end

local PlayerTPBypass = {}
local TPBypassSettings = { BypassInGameMenu = false }

local function GetPlayerFromDetail(header, tpBtn)
    if getconnections and tpBtn then
        local ok, conns = pcall(getconnections, tpBtn.Activated)
        if ok and conns then
            for _, c in ipairs(conns) do
                local ok2, ups = pcall(debug.getupvalues, c.Function)
                if ok2 and type(ups) == "table" then
                    for _, v in pairs(ups) do
                        if typeof(v) == "Instance" and v:IsA("Player") and v ~= LocalPlayer then
                            return v
                        end
                    end
                end
            end
        end
    end
    if header then
        local ul = header:FindFirstChild("UsernameLabel")
        local nl = header:FindFirstChild("NameLabel")
        local ru = ul and ul.Text or ""
        local rn = nl and nl.Text or ""
        local cu = string.lower(string.gsub(ru, "[@%s]", ""))
        local cn = string.lower(string.gsub(rn, "^%s*(.-)%s*$", "%1"))
        for _, p in ipairs(Players:GetPlayers()) do
            if p ~= LocalPlayer then
                if cu ~= "" and string.lower(p.Name) == cu then return p end
                if cn ~= "" and (string.lower(p.DisplayName) == cn or string.lower(p.Name) == cn) then return p end
            end
        end
    end
    return nil
end

function PlayerTPBypass.TeleportToPlayer(target)
    if not target or target == LocalPlayer then return false end
    local fns = ReplicatedStorage:FindFirstChild("GameRemoteFunctions")
    local fn = fns and fns:FindFirstChild("TeleportPlayerFunction")
    if not fn then return false end
    local ok, res = pcall(function() return fn:InvokeServer(target) end)
    return ok and res == true
end

task.spawn(function()
    local pg = LocalPlayer:FindFirstChildOfClass("PlayerGui") if not pg then return end
    local pd = pg:WaitForChild("PlayerDetail", 10) if not pd then return end
    local h = pd:WaitForChild("Holder", 5)
    local frame = h and h:WaitForChild("Frame", 5)
    local hd = frame and frame:WaitForChild("Header", 5)
    local bd = frame and frame:WaitForChild("Body", 5)
    local bf = bd and bd:WaitForChild("ButtonFrame", 5)
    local tb = bf and bf:WaitForChild("TeleportButton", 5)
    if tb then
        local function forceUnlock()
            if TPBypassSettings.BypassInGameMenu then tb.Visible = true end
        end
        Utils.AddConnection(Runtime.GlobalConnections, tb:GetPropertyChangedSignal("Visible"):Connect(function()
            if not tb.Visible and TPBypassSettings.BypassInGameMenu then
                task.wait(0.02) tb.Visible = true
            end
        end))
        Utils.AddConnection(Runtime.GlobalConnections, pd:GetPropertyChangedSignal("Enabled"):Connect(function()
            if pd.Enabled then task.wait(0.05) forceUnlock() end
        end))
        local last = 0
        local function click()
            if not TPBypassSettings.BypassInGameMenu then return end
            if os.clock() - last < 1.0 then return end
            last = os.clock()
            local target = GetPlayerFromDetail(hd, tb)
            if target then
                if PlayerTPBypass.TeleportToPlayer(target) then
                    Notify({ Title = "Teleportasi",
                        Message = "Teleport ke @" .. target.Name .. " (" .. target.DisplayName .. ")",
                        Type = "success", Duration = 3 })
                    local cb = hd and hd:FindFirstChild("CloseButton")
                    if cb then pcall(function() cb:activate() end) end
                else
                    Notify({ Title = "Teleportasi", Message = "Teleport gagal atau diblokir server.",
                        Type = "warning", Duration = 3 })
                end
            else
                Notify({ Title = "Teleportasi", Message = "Tidak bisa menemukan Player target.",
                    Type = "warning", Duration = 2 })
            end
        end
        Utils.AddConnection(Runtime.GlobalConnections, tb.Activated:Connect(click))
        Utils.AddConnection(Runtime.GlobalConnections, tb.MouseButton1Click:Connect(click))
        forceUnlock()
    end
end)

local RefiningSystem = {}
local RefiningSettings = {
    AutoClaim = false, AutoRefine = false,
    PriorityMode = "Highest Density",
    ExcludedOres = {}, CheckInterval = 3.0,
    TotalClaimed = 0, TotalStarted = 0,
    RefineTiers = {"Ancient","Mythic","Legend","Epic","Rare","Uncommon","Common"},
}
local RefiningRuntime = {
    Thread = nil, IsBusy = false,
    ClaimFunction = nil, StartFunction = nil,
    RefiningConfig = nil, ReplicaManager = nil, OreContent = nil,
}

function RefiningSystem.Init()
    pcall(function()
        local fns = ReplicatedStorage:WaitForChild("GameRemoteFunctions", 5)
        if fns then
            RefiningRuntime.ClaimFunction = fns:FindFirstChild("RefineClaimFunction")
            RefiningRuntime.StartFunction = fns:FindFirstChild("RefineStartFunction")
        end
    end)
    pcall(function()
        local cfg = ReplicatedStorage:WaitForChild("Configuration", 5)
        if cfg and cfg:FindFirstChild("RefiningConfig") then
            RefiningRuntime.RefiningConfig = require(cfg.RefiningConfig)
        end
    end)
    pcall(function()
        local rf = game:GetService("ReplicatedFirst")
        local mgr = rf:WaitForChild("Manager", 5)
        if mgr and mgr:FindFirstChild("ReplicaManager") then
            RefiningRuntime.ReplicaManager = require(mgr.ReplicaManager)
        end
    end)
    pcall(function()
        local c = ReplicatedStorage:WaitForChild("Content", 5)
        if c and c:FindFirstChild("Ore") then RefiningRuntime.OreContent = require(c.Ore) end
    end)
end

function RefiningSystem.GetProfileData()
    if not RefiningRuntime.ReplicaManager then pcall(RefiningSystem.Init) end
    if not RefiningRuntime.ReplicaManager then return nil end
    local ok, pd = pcall(function()
        local r = RefiningRuntime.ReplicaManager:GetPlayerData(LocalPlayer)
        return r and r.ProfileReplica and r.ProfileReplica.Data
    end)
    return ok and pd or nil
end

function RefiningSystem.GetMaxUnlockedSlots(pd)
    if not pd then return 1 end
    local cfg = RefiningRuntime.RefiningConfig
    local loy = pd.Loyalty or 0
    local base = cfg and cfg.BASE_SLOT or 1
    local per  = cfg and cfg.LOYALTY_PER_SLOT or 100
    local max  = cfg and cfg.MAX_SLOT or 10
    return math.clamp(base + math.floor(loy / per), base, max)
end

function RefiningSystem.GetAvailableOresByType(pd)
    local cfg = RefiningRuntime.RefiningConfig
    local idMap = cfg and cfg.REFINED_ID or {}
    local tierSet = {}
    for _, t in ipairs(RefiningSettings.RefineTiers) do tierSet[t] = true end
    local oreData = RefiningRuntime.OreContent or {}
    local byType = {}
    local all = pd and pd.Ore or {}
    for k, v in pairs(all) do
        local oreRarity = oreData[v.OreId] and oreData[v.OreId].Rarity
        if typeof(v) == "table"
            and not v.IsRefined and not v.Favorite and not v.IsEquip
            and idMap[v.OreId] and not RefiningSettings.ExcludedOres[v.OreId]
            and (not oreRarity or tierSet[oreRarity]) then
            local list = byType[v.OreId] or {}
            byType[v.OreId] = list
            table.insert(list, { UniqueId = k, Density = v.Density or 0, OreId = v.OreId })
        end
    end
    for _, list in pairs(byType) do
        if RefiningSettings.PriorityMode == "Highest Density" then
            table.sort(list, function(a, b) return a.Density > b.Density end)
        elseif RefiningSettings.PriorityMode == "Lowest Density" then
            table.sort(list, function(a, b) return a.Density < b.Density end)
        else
            for i = #list, 2, -1 do
                local j = math.random(1, i)
                list[i], list[j] = list[j], list[i]
            end
        end
    end
    local copy = {}
    for id, list in pairs(byType) do
        local c = {}
        for _, v in ipairs(list) do table.insert(c, v) end
        copy[id] = c
    end
    local pairs_ = {}
    for id, pool in pairs(copy) do
        while #pool >= 2 do
            local a = table.remove(pool, 1)
            local b = table.remove(pool, 1)
            table.insert(pairs_, { OreId = id, OreA = a, OreB = b, Score = (a.Density + b.Density) / 2 })
        end
    end
    if RefiningSettings.PriorityMode == "Highest Density" then
        table.sort(pairs_, function(a, b) return a.Score > b.Score end)
    elseif RefiningSettings.PriorityMode == "Lowest Density" then
        table.sort(pairs_, function(a, b) return a.Score < b.Score end)
    end
    return byType, pairs_
end

function RefiningSystem.ProcessCycle()
    if RefiningRuntime.IsBusy then return end
    RefiningRuntime.IsBusy = true
    local pd = RefiningSystem.GetProfileData()
    if not pd then RefiningRuntime.IsBusy = false return end
    local serverNow = workspace:GetServerTimeNow()
    local slots = pd.Refining or {}
    local max = RefiningSystem.GetMaxUnlockedSlots(pd)
    local fns = ReplicatedStorage:FindFirstChild("GameRemoteFunctions")
    local claimFn = RefiningRuntime.ClaimFunction
                     or (fns and fns:FindFirstChild("RefineClaimFunction"))
    local startFn = RefiningRuntime.StartFunction
                     or (fns and fns:FindFirstChild("RefineStartFunction"))

    if RefiningSettings.AutoClaim and claimFn then
        for i = 1, max do
            local slotKey = tostring(i)
            local sd = slots[slotKey]
            if sd and (sd.OreId or sd.StartedAt or sd.EndTime) then
                local endT = sd.EndTime or ((sd.StartedAt or 0) + (sd.Duration or 0))
                if serverNow >= endT then
                    local ok, res = pcall(function() return claimFn:InvokeServer(slotKey) end)
                    if ok and res then
                        RefiningSettings.TotalClaimed = RefiningSettings.TotalClaimed + 1
                        if RefiningSystem.OnStatsUpdated then RefiningSystem.OnStatsUpdated() end
                        Notify({ Title = "Refinining",
                            Message = string.format("Slot %s dikumpulkan! Total: %d", slotKey, RefiningSettings.TotalClaimed),
                            Type = "success", Duration = 2.5 })
                        task.wait(0.35)
                    end
                end
            end
        end
    end

    pd = RefiningSystem.GetProfileData()
    if not pd then RefiningRuntime.IsBusy = false return end
    slots = pd.Refining or {}

    if RefiningSettings.AutoRefine and startFn then
        local empty = 0
        for i = 1, max do
            local sd = slots[tostring(i)]
            if not sd or (not sd.OreId and not sd.StartedAt and not sd.EndTime) then
                empty = empty + 1
            end
        end
        if empty > 0 then
            local _, list = RefiningSystem.GetAvailableOresByType(pd)
            for _, p in ipairs(list) do
                if empty <= 0 then break end
                local ok, res = pcall(function() return startFn:InvokeServer(p.OreA.UniqueId, p.OreB.UniqueId) end)
                if ok and res then
                    empty = empty - 1
                    RefiningSettings.TotalStarted = RefiningSettings.TotalStarted + 1
                    if RefiningSystem.OnStatsUpdated then RefiningSystem.OnStatsUpdated() end
                    local name = string.gsub(p.OreId, "^Ore_", "")
                    Notify({ Title = "Refining",
                        Message = string.format("Refining: %s (D: %.1f + %.1f, rata-rata %.1f)",
                            name, p.OreA.Density, p.OreB.Density, p.Score),
                        Type = "info", Duration = 2.5 })
                    task.wait(0.35)
                end
            end
        end
    end
    RefiningRuntime.IsBusy = false
end

function RefiningSystem.Start()
    if RefiningRuntime.Thread then return end
    RefiningSystem.Init()
    RefiningRuntime.Thread = task.spawn(function()
        while RefiningSettings.AutoClaim or RefiningSettings.AutoRefine do
            pcall(RefiningSystem.ProcessCycle)
            task.wait(RefiningSettings.CheckInterval)
        end
        RefiningRuntime.Thread = nil
    end)
end

function RefiningSystem.Stop()
    if RefiningRuntime.Thread then
        task.cancel(RefiningRuntime.Thread)
        RefiningRuntime.Thread = nil
    end
    RefiningRuntime.IsBusy = false
end

function RefiningSystem.CheckActive()
    if RefiningSettings.AutoClaim or RefiningSettings.AutoRefine then
        RefiningSystem.Start()
    else
        RefiningSystem.Stop()
    end
end

local MiscSystem = {}
local MiscSettings = {
    AutoRun = false, SpeedEnabled = false, WalkSpeed = 16,
    JumpEnabled = false, JumpPower = 50, InfiniteJump = false,
    Noclip = false, AutoLikeLoop = false,
    FPSBooster = false,
}
local MiscRuntime = {
    NoclipConn = nil, InfJumpConn = nil,
    AutoLikeThread = nil, AutoLikePlayerConn = nil, MovementThread = nil,
    FPSBoosterConn = nil, FPSBoosterConnL = nil, FPSBoosterSaved = {},
}

local TeleportManager = {
    Waypoints = {},
    OnUpdated = nil,
}

local TELEPORT_WP_FILE = "IndoVoice_Waypoints_" .. tostring(LocalPlayer.UserId) .. ".json"
local TeleportHttp = game:GetService("HttpService")

local function WP_Load()
    local ok, data = pcall(function()
        if not readfile or not isfile then return nil end
        if not isfile(TELEPORT_WP_FILE) then return nil end
        return readfile(TELEPORT_WP_FILE)
    end)
    if not ok or not data or data == "" then return end
    pcall(function()
        local decoded = TeleportHttp:JSONDecode(data)
        if type(decoded) ~= "table" then return end
        for name, comps in pairs(decoded) do
            if type(comps) == "table" and #comps == 12 then
                TeleportManager.Waypoints[name] = CFrame.new(table.unpack(comps))
            end
        end
    end)
end

local function WP_Save()
    if not writefile then return end
    pcall(function()
        local out = {}
        for name, cf in pairs(TeleportManager.Waypoints) do
            out[name] = { cf:GetComponents() }
        end
        writefile(TELEPORT_WP_FILE, TeleportHttp:JSONEncode(out))
    end)
end

function TeleportManager.SaveWaypoint(name, cf)
    if not name or name == "" then return false end
    local hrp = Utils.GetHumanoidRootPart()
    local targetCF = cf or (hrp and hrp.CFrame)
    if not targetCF then return false end
    TeleportManager.Waypoints[name] = targetCF
    WP_Save()
    if TeleportManager.OnUpdated then pcall(TeleportManager.OnUpdated) end
    return true
end

function TeleportManager.DeleteWaypoint(name)
    if not name or not TeleportManager.Waypoints[name] then return false end
    TeleportManager.Waypoints[name] = nil
    WP_Save()
    if TeleportManager.OnUpdated then pcall(TeleportManager.OnUpdated) end
    return true
end

function TeleportManager.TeleportTo(name)
    local cf = TeleportManager.Waypoints[name]
    if not cf then return false end
    local hrp = Utils.GetHumanoidRootPart()
    if not hrp then return false end
    hrp.CFrame = cf
    return true
end

function TeleportManager.GetNames()
    local names = {}
    for n, _ in pairs(TeleportManager.Waypoints) do
        table.insert(names, n)
    end
    table.sort(names)
    return names
end

WP_Load()

function MiscSystem.GetLovedPlayers()
    local set = {}
    pcall(function()
        local rf = game:GetService("ReplicatedFirst")
        local mgr = rf:FindFirstChild("Manager")
        local pl = mgr and mgr:FindFirstChild("PlayerListManager")
        local upd = pl and pl:FindFirstChild("PlayerListUpdater")
        if upd then
            local u = require(upd)
            if u then
                if u.UpdateLove then u.UpdateLove() end
                if u.GetLoveState then
                    for _, p in ipairs(Players:GetPlayers()) do
                        if p ~= LocalPlayer and u.GetLoveState(p.Name) == 1 then
                            set[p.Name] = true
                        end
                    end
                end
            end
        end
    end)
    pcall(function()
        local rf = game:GetService("ReplicatedFirst")
        local mgr = rf:FindFirstChild("Manager")
        local rm  = mgr and mgr:FindFirstChild("ReplicaManager")
        if rm then
            local R = require(rm)
            local pd = R:GetPlayerData(LocalPlayer)
            pd = pd and pd.ProfileReplica and pd.ProfileReplica.Data
            if pd and typeof(pd.DailyLoving) == "table" then
                local lib = ReplicatedStorage:FindFirstChild("Lib")
                lib = lib and lib:FindFirstChild("Misc")
                if lib then
                    local M = require(lib)
                    local key = M.GetDailyKey(workspace:GetServerTimeNow())
                    local today = pd.DailyLoving[key]
                    if typeof(today) == "table" then
                        for _, n in pairs(today) do set[tostring(n)] = true end
                    end
                end
            end
        end
    end)
    return set
end

function MiscSystem.GiveLoveToAll(notify)
    local fns = ReplicatedStorage:FindFirstChild("GameRemoteFunctions")
    local fn = fns and fns:FindFirstChild("GiveLoveFunction")
    if not fn then
        if notify then Notify({ Title = "Auto Love",
            Message = "Remote GiveLoveFunction tidak ditemukan",
            Type = "error", Duration = 3 }) end
        return 0, 0, "Remote tidak ditemukan"
    end
    local loved = MiscSystem.GetLovedPlayers()
    local liked, alreadyLiked = 0, 0
    local ageMsg = nil
    local targets = {}
    for _, p in ipairs(Players:GetPlayers()) do
        if p ~= LocalPlayer then
            if loved[p.Name] then alreadyLiked = alreadyLiked + 1
            else table.insert(targets, p) end
        end
    end
    if #targets == 0 then
        if notify then Notify({ Title = "Kasih Love",
            Message = string.format("Semua %d Player sudah di-like!", alreadyLiked),
            Type = "info", Duration = 3 }) end
        return 0, alreadyLiked, nil
    end
    if notify then Notify({ Title = "Kasih Love",
        Message = string.format("Me-like %d Player yang belum...", #targets),
        Type = "info", Duration = 2.5 }) end
    for i, p in ipairs(targets) do
        local ok, res, msg = pcall(function() return fn:InvokeServer(p) end)
        if ok and res == true then
            liked = liked + 1
            loved[p.Name] = true
            pcall(function()
                local rf = game:GetService("ReplicatedFirst")
                local u = require(rf.Manager.PlayerListManager.PlayerListUpdater)
                if u and u.PatchLoveState then u.PatchLoveState(p.Name, 1) end
            end)
        elseif ok and res == false then
            local s = tostring(msg or "")
            if s:find("under 30 days") then ageMsg = s break
            elseif s:find("already") or s:find("once per day") then
                loved[p.Name] = true
            elseif s:find("wait a moment") then
                task.wait(1.0)
                local ok2, res2 = pcall(function() return fn:InvokeServer(p) end)
                if ok2 and res2 == true then
                    liked = liked + 1 loved[p.Name] = true
                end
            end
        end
        if i < #targets then task.wait(1.02) end
    end
    if notify then
        if ageMsg then
            Notify({ Title = "Auto Love", Message = ageMsg,
                Type = "warning", Duration = 4 })
        elseif liked > 0 then
            Notify({ Title = "Auto Love",
                Message = string.format("Selesai! Sudah like %d Player. (%d sudah di-like)", liked, alreadyLiked),
                Type = "success", Duration = 3.5 })
        end
    end
    return liked, alreadyLiked, ageMsg
end

function MiscSystem.StartAutoLikeLoop()
    if MiscRuntime.AutoLikeThread then return end
    task.spawn(function() MiscSystem.GiveLoveToAll(true) end)
    if not MiscRuntime.AutoLikePlayerConn then
        MiscRuntime.AutoLikePlayerConn = Players.PlayerAdded:Connect(function(p)
            if not MiscSettings.AutoLikeLoop then return end
            if p == LocalPlayer then return end
            task.wait(2.5)
            local loved = MiscSystem.GetLovedPlayers()
            if not loved[p.Name] then
                local fns = ReplicatedStorage:FindFirstChild("GameRemoteFunctions")
                local fn = fns and fns:FindFirstChild("GiveLoveFunction")
                if fn then pcall(function() return fn:InvokeServer(p) end) end
            end
        end)
    end
    MiscRuntime.AutoLikeThread = task.spawn(function()
        while MiscSettings.AutoLikeLoop do
            for _ = 1, 30 do
                if not MiscSettings.AutoLikeLoop then break end
                task.wait(1)
            end
            if not MiscSettings.AutoLikeLoop then break end
            MiscSystem.GiveLoveToAll(false)
        end
        MiscRuntime.AutoLikeThread = nil
    end)
end

function MiscSystem.StopAutoLikeLoop()
    if MiscRuntime.AutoLikeThread then
        pcall(task.cancel, MiscRuntime.AutoLikeThread)
        MiscRuntime.AutoLikeThread = nil
    end
    if MiscRuntime.AutoLikePlayerConn then
        pcall(function() MiscRuntime.AutoLikePlayerConn:Disconnect() end)
        MiscRuntime.AutoLikePlayerConn = nil
    end
end

function MiscSystem.SetInfiniteJump(enabled)
    MiscSettings.InfiniteJump = enabled
    if MiscRuntime.InfJumpConn then
        MiscRuntime.InfJumpConn:Disconnect()
        MiscRuntime.InfJumpConn = nil
    end
    if enabled then
        MiscRuntime.InfJumpConn = UserInputService.JumpRequest:Connect(function()
            if MiscSettings.InfiniteJump then
                local h = Utils.GetHumanoid()
                if h then h:ChangeState(Enum.HumanoidStateType.Jumping) end
            end
        end)
    end
end

function MiscSystem.SetNoclip(enabled)
    MiscSettings.Noclip = enabled
    if MiscRuntime.NoclipConn then
        MiscRuntime.NoclipConn:Disconnect()
        MiscRuntime.NoclipConn = nil
    end
    if enabled then
        MiscRuntime.NoclipConn = RunService.Stepped:Connect(function()
            if not MiscSettings.Noclip then return end
            local c = LocalPlayer.Character
            if c then
                for _, p in ipairs(c:GetDescendants()) do
                    if p:IsA("BasePart") and p.CanCollide then p.CanCollide = false end
                end
            end
        end)
    else
        local c = LocalPlayer.Character
        if c then
            for _, p in ipairs(c:GetDescendants()) do
                if p:IsA("BasePart") then p.CanCollide = true end
            end
        end
    end
end

local FPS_DISABLE_CLASSES = {
    ParticleEmitter = true, Trail = true, Smoke = true,
    Fire = true, Sparkles = true, Beam = true,
    SpotLight = true, PointLight = true, SurfaceLight = true,
    SurfaceAppearance = true,
    BillboardGui = true, SurfaceGui = true,
}

local function _fpsApplyObj(obj, saving)
    local cn = obj.ClassName
    if FPS_DISABLE_CLASSES[cn] then
        if saving then
            if obj:IsA("BillboardGui") or obj:IsA("SurfaceGui") then
                local prev = obj.Enabled
                MiscRuntime.FPSBoosterSaved._guiState[obj] = prev
                if prev then pcall(function() obj.Enabled = false end) end
            elseif obj:IsA("SurfaceAppearance") then
                MiscRuntime.FPSBoosterSaved._saParent[obj] = obj.Parent
                pcall(function() obj.Parent = nil end)
            else
                local prev = obj.Enabled
                MiscRuntime.FPSBoosterSaved._state[obj] = prev
                if prev then pcall(function() obj.Enabled = false end) end
            end
        else
            pcall(function() obj.Enabled = false end)
        end
    end
end

function MiscSystem.SetFPSBooster(enabled)
    MiscSettings.FPSBooster = enabled

    if MiscRuntime.FPSBoosterConn then
        MiscRuntime.FPSBoosterConn:Disconnect()
        MiscRuntime.FPSBoosterConn = nil
    end
    if MiscRuntime.FPSBoosterConnL then
        MiscRuntime.FPSBoosterConnL:Disconnect()
        MiscRuntime.FPSBoosterConnL = nil
    end

    local lighting = game:GetService("Lighting")

    if enabled then
        MiscRuntime.FPSBoosterSaved = {
            GlobalShadows  = lighting.GlobalShadows,
            FogEnd         = lighting.FogEnd,
            Brightness     = lighting.Brightness,
            Technology     = lighting.Technology,
            _state         = {},
            _guiState      = {},
            _saParent      = {},
            _lightingFx    = {},
            _atmosParent   = {},
        }

        lighting.GlobalShadows = false
        lighting.FogEnd        = 9e9
        pcall(function() lighting.Technology = Enum.Technology.Compatibility end)

        for _, fx in ipairs(lighting:GetChildren()) do
            if fx:IsA("Atmosphere") then
                MiscRuntime.FPSBoosterSaved._atmosParent[fx] = fx.Parent
                pcall(function() fx.Parent = nil end)
            elseif fx:IsA("PostEffect") then
                MiscRuntime.FPSBoosterSaved._lightingFx[fx] = fx.Enabled
                pcall(function() fx.Enabled = false end)
            end
        end
        MiscRuntime.FPSBoosterConnL = lighting.DescendantAdded:Connect(function(obj)
            if not MiscSettings.FPSBooster then return end
            if obj:IsA("Atmosphere") then
                pcall(function() obj.Parent = nil end)
            elseif obj:IsA("PostEffect") then
                pcall(function() obj.Enabled = false end)
            end
        end)

        for _, obj in ipairs(workspace:GetDescendants()) do
            _fpsApplyObj(obj, true)
        end

        MiscRuntime.FPSBoosterConn = workspace.DescendantAdded:Connect(function(obj)
            if not MiscSettings.FPSBooster then return end
            _fpsApplyObj(obj, false)
        end)
    else
        local saved = MiscRuntime.FPSBoosterSaved
        if saved then
            if saved.GlobalShadows ~= nil then lighting.GlobalShadows = saved.GlobalShadows end
            if saved.FogEnd        ~= nil then lighting.FogEnd        = saved.FogEnd        end
            if saved.Technology    ~= nil then
                pcall(function() lighting.Technology = saved.Technology end)
            end
            if saved._lightingFx then
                for fx, wasEnabled in pairs(saved._lightingFx) do
                    pcall(function() fx.Enabled = wasEnabled end)
                end
            end
            if saved._atmosParent then
                for fx, parent in pairs(saved._atmosParent) do
                    pcall(function() fx.Parent = parent end)
                end
            end
            if saved._state then
                for obj, wasEnabled in pairs(saved._state) do
                    pcall(function() obj.Enabled = wasEnabled end)
                end
            end
            if saved._guiState then
                for obj, wasEnabled in pairs(saved._guiState) do
                    pcall(function() obj.Enabled = wasEnabled end)
                end
            end
            if saved._saParent then
                for obj, parent in pairs(saved._saParent) do
                    pcall(function() obj.Parent = parent end)
                end
            end
        end

        MiscRuntime.FPSBoosterSaved = {}
    end
end

function MiscSystem.Stop()
    MiscSettings.SpeedEnabled = false
    MiscSettings.JumpEnabled  = false
    MiscSettings.AutoRun      = false
    MiscSettings.InfiniteJump = false
    MiscSettings.Noclip       = false
    MiscSettings.AutoLikeLoop = false
    MiscSettings.FPSBooster   = false
    if MiscRuntime.MovementThread then
        pcall(task.cancel, MiscRuntime.MovementThread)
        MiscRuntime.MovementThread = nil
    end
    MiscSystem.SetNoclip(false)
    MiscSystem.SetInfiniteJump(false)
    MiscSystem.SetFPSBooster(false)
    MiscSystem.StopAutoLikeLoop()
    local h = Utils.GetHumanoid()
    if h then
        pcall(function()
            h.WalkSpeed = 16
            h.UseJumpPower = false
            h.JumpPower = 50
        end)
    end
end

MiscRuntime.MovementThread = task.spawn(function()
    local _wasAutoRunSprinting = false
    local _autoRunSprintSpeed  = 24
    while true do
        local h = Utils.GetHumanoid()
        if h then
            if MiscSettings.SpeedEnabled then
                local target = MiscSettings.WalkSpeed
                if h.WalkSpeed ~= target then h.WalkSpeed = target end
            end
            if MiscSettings.JumpEnabled then
                h.UseJumpPower = true
                h.JumpPower = MiscSettings.JumpPower
            end
            if MiscSettings.AutoRun then
                local isMoving = h.MoveDirection.Magnitude > 0.1
                if isMoving then
                    pcall(function()
                        VirtualInputManager:SendKeyEvent(true, Enum.KeyCode.LeftShift, false, game)
                    end)
                    if not MiscSettings.SpeedEnabled then
                        h.WalkSpeed = _autoRunSprintSpeed
                    end
                    _wasAutoRunSprinting = true
                else
                    if _wasAutoRunSprinting then
                        pcall(function()
                            VirtualInputManager:SendKeyEvent(false, Enum.KeyCode.LeftShift, false, game)
                        end)
                        if not MiscSettings.SpeedEnabled then
                            h.WalkSpeed = 16
                        end
                        _wasAutoRunSprinting = false
                    end
                end
            elseif _wasAutoRunSprinting then
                pcall(function()
                    VirtualInputManager:SendKeyEvent(false, Enum.KeyCode.LeftShift, false, game)
                end)
                if not MiscSettings.SpeedEnabled then
                    h.WalkSpeed = 16
                end
                _wasAutoRunSprinting = false
            end
        end
        task.wait(0.1)
    end
end)

local AutoSell = {}
local SELL_TIERS_ALL = {"Ancient","Mythic","Legend","Epic","Rare","Uncommon","Common"}
local AutoSellSettings = {
    FishEnabled = false, OreEnabled = false,
    FishShopType = "FishShop", FishTrigger = 50,
    OreTrigger = 30, OreFilterMode = "All", ReturnAfterSell = true,
    FishSellTiers = {"Ancient","Mythic","Legend","Epic","Rare","Uncommon","Common"},
    OreSellTiers  = {"Ancient","Mythic","Legend","Epic","Rare","Uncommon","Common"},
    MaxRetry = 5, RetryDelay = 1.5,
}
local AutoSellRuntime = {
    IsBusy = false, FishThread = nil, OreThread = nil,
    FishCountSnap = 0, OreCountSnap = 0, ReplicaManager = nil,
}

local function IsOnMainMap()
    local world = workspace:FindFirstChild("World")
    if world then
        for _, map in ipairs(world:GetChildren()) do
            if map.Name ~= "MainBaseplate" then
                local asset = map:FindFirstChild("Asset")
                if asset and (
                    asset:FindFirstChild("ShopNPC") or
                    asset:FindFirstChild("FishingZone") or
                    asset:FindFirstChild("ActiveMiningStones")
                ) then
                    return true
                end
            end
        end
    end
    local main = workspace:FindFirstChild("Main")
    if main and (main:FindFirstChild("FishingZone") or main:FindFirstChild("Fishing")) then
        return true
    end
    return false
end

local SELL_APPROACH = 7

local SHOP_FALLBACK = {
    FishShop   = Vector3.new(-259.418, 24.233, -5048.189),
    FishBroker = Vector3.new(265.043,  39.033, -4872.701),
    OreShop    = Vector3.new(309.462,  15.941, -4996.720),
}
local function GetShopPos(shopName)
    local world = workspace:FindFirstChild("World")
    if world then
        for _, map in ipairs(world:GetChildren()) do
            if map.Name ~= "MainBaseplate" then
                local asset    = map:FindFirstChild("Asset")
                local npcFolder = asset and asset:FindFirstChild("ShopNPC")
                local npc      = npcFolder and npcFolder:FindFirstChild(shopName)
                if npc then
                    local hrp = npc:FindFirstChild("HumanoidRootPart")
                    if hrp then return hrp.Position end
                    if npc.PrimaryPart then return npc.PrimaryPart.Position end
                    if npc:IsA("BasePart") then return npc.Position end
                end
            end
        end
    end
    return SHOP_FALLBACK[shopName]
end

local function AutoSell_TP(shopKey)
    local hrp = Utils.GetHumanoidRootPart() if not hrp then return false end
    local pos = GetShopPos(shopKey) if not pos then return false end
    if shopKey == "OreShop" then
        local under = pos - Vector3.new(0, 7.5, 0)
        MiningSystem.EnableUndergroundFloat(CFrame.lookAt(under, pos))
    else
        hrp.CFrame = CFrame.new(pos + Vector3.new(0, 0, SELL_APPROACH))
    end
    task.wait(0.35)
    return true
end

local function AutoSell_Fish()
    local fns = ReplicatedStorage:FindFirstChild("GameRemoteFunctions") if not fns then return false end
    local rem = fns:FindFirstChild("SellAllFishFunction") if not rem then return false end
    local tiers = (#AutoSellSettings.FishSellTiers > 0)
        and AutoSellSettings.FishSellTiers or SELL_TIERS_ALL
    local ok, r = pcall(function() return rem:InvokeServer(tiers) end)
    return ok and r ~= false and r ~= nil
end

local function AutoSell_GetOres()
    if not AutoSellRuntime.ReplicaManager then
        pcall(function()
            local rf = game:GetService("ReplicatedFirst")
            local mgr = rf:WaitForChild("Manager", 5)
            if mgr and mgr:FindFirstChild("ReplicaManager") then
                AutoSellRuntime.ReplicaManager = require(mgr.ReplicaManager)
            end
        end)
    end
    if not AutoSellRuntime.ReplicaManager then return nil end
    local ok, d = pcall(function()
        local r = AutoSellRuntime.ReplicaManager:GetPlayerData(LocalPlayer)
        return r and r.ProfileReplica and r.ProfileReplica.Data
    end)
    return ok and d and d.Ore or nil
end

local function AutoSell_CountFish()
    if not AutoSellRuntime.ReplicaManager then
        pcall(function()
            local rf = game:GetService("ReplicatedFirst")
            local mgr = rf:WaitForChild("Manager", 5)
            if mgr and mgr:FindFirstChild("ReplicaManager") then
                AutoSellRuntime.ReplicaManager = require(mgr.ReplicaManager)
            end
        end)
    end
    if not AutoSellRuntime.ReplicaManager then return nil end
    local ok, d = pcall(function()
        local r = AutoSellRuntime.ReplicaManager:GetPlayerData(LocalPlayer)
        return r and r.ProfileReplica and r.ProfileReplica.Data
    end)
    if not ok or not d or not d.Fish then return nil end
    local tierSet = {}
    for _, t in ipairs(AutoSellSettings.FishSellTiers) do tierSet[t] = true end
    local RARITY_LIST = {"Ancient","Mythic","Legend","Epic","Rare","Uncommon","Common"}
    local n = 0
    for _, fd in pairs(d.Fish) do
        if type(fd) == "table" and not fd.Favorite and not fd.IsEquip then
            local rarity = fd.Rarity
            if not rarity and type(fd.FishId) == "string" then
                local low = string.lower(fd.FishId)
                for _, rv in ipairs(RARITY_LIST) do
                    if string.find(low, string.lower(rv), 1, true) then
                        rarity = rv break
                    end
                end
            end
            if not rarity or tierSet[rarity] then
                n = n + 1
            end
        end
    end
    return n
end

local function AutoSell_CountOre()
    local ores = AutoSell_GetOres()
    if not ores then return nil end
    local n = 0
    for uid, od in pairs(ores) do
        if typeof(od) == "table" and not od.Favorite then
            n = n + 1
        end
    end
    return n
end

local function AutoSell_Ore()
    local fns = ReplicatedStorage:FindFirstChild("GameRemoteFunctions") if not fns then return false end
    local oreTiers = (#AutoSellSettings.OreSellTiers > 0)
        and AutoSellSettings.OreSellTiers or SELL_TIERS_ALL
    local rem = fns:FindFirstChild("SellAllOreFunction") if not rem then return false end
    local ok, r = pcall(function() return rem:InvokeServer(oreTiers) end)
    return ok and r ~= false and r ~= nil
end

local function AutoSell_DoFish()
    if AutoSellRuntime.IsBusy then return false end
    if not IsOnMainMap() then
        Notify({ Title = "Jual Otomatis", Message = "Bukan di map utama — jual dibatalkan.", Type = "warning", Duration = 3 })
        return false
    end
    AutoSellRuntime.IsBusy = true
    local hrp = Utils.GetHumanoidRootPart()
    local savedCF = (hrp and hrp.CFrame) or CFrame.new()
    local shop = AutoSellSettings.FishShopType or "FishShop"
    if not AutoSell_TP(shop) then AutoSellRuntime.IsBusy = false return false end

    local maxRetry  = AutoSellSettings.MaxRetry or 5
    local retryDelay = AutoSellSettings.RetryDelay or 1.5
    local sold = false

    for attempt = 1, maxRetry do
        local countBefore = AutoSell_CountFish()
        if countBefore and countBefore == 0 then break end
        AutoSell_Fish()
        task.wait(0.8)
        local countAfter = AutoSell_CountFish()
        if countBefore and countAfter then
            if countAfter < countBefore then
                sold = true
                break
            end
            if attempt < maxRetry then
                Notify({ Title = "Jual Otomatis",
                    Message = string.format("Jual ikan gagal, mencoba ulang %d/%d...", attempt, maxRetry),
                    Type = "warning", Duration = 1.5 })
                task.wait(retryDelay)
                AutoSell_TP(shop)
            end
        else
            sold = true
            break
        end
    end

    task.wait(0.25)
    if AutoSellSettings.ReturnAfterSell then
        local h = Utils.GetHumanoidRootPart()
        if h then h.CFrame = savedCF task.wait(0.2) end
    end
    AutoSellRuntime.FishCountSnap = Settings.Fishing.TotalFishCaught
    AutoSellRuntime.IsBusy = false
    if sold then
        Notify({ Title = "Jual Otomatis", Message = "Ikan terjual!", Type = "success", Duration = 2 })
    else
        Notify({ Title = "Jual Otomatis", Message = "Tidak ada ikan / jual masih gagal.", Type = "warning", Duration = 2 })
    end
    return sold
end

local function AutoSell_DoOre()
    if AutoSellRuntime.IsBusy then return false end
    if not IsOnMainMap() then
        Notify({ Title = "Jual Otomatis", Message = "Bukan di map utama — jual dibatalkan.", Type = "warning", Duration = 3 })
        return false
    end
    AutoSellRuntime.IsBusy = true
    local hrp = Utils.GetHumanoidRootPart()
    local savedCF = (hrp and hrp.CFrame) or CFrame.new()
    if not AutoSell_TP("OreShop") then AutoSellRuntime.IsBusy = false return false end
    local wasFloating = Runtime.Mining.IsFloating

    local maxRetry   = AutoSellSettings.MaxRetry or 5
    local retryDelay = AutoSellSettings.RetryDelay or 1.5
    local sold = false

    for attempt = 1, maxRetry do
        local countBefore = AutoSell_CountOre()
        if countBefore and countBefore == 0 then break end
        AutoSell_Ore()
        task.wait(0.8)
        local countAfter = AutoSell_CountOre()
        if countBefore and countAfter then
            if countAfter < countBefore then
                sold = true
                break
            end
            if attempt < maxRetry then
                Notify({ Title = "Jual Ore Otomatis",
                    Message = string.format("Jual ore gagal, mencoba ulang %d/%d...", attempt, maxRetry),
                    Type = "warning", Duration = 1.5 })
                task.wait(retryDelay)
                AutoSell_TP("OreShop")
            end
        else
            sold = true
            break
        end
    end

    task.wait(0.25)
    if AutoSellSettings.ReturnAfterSell then
        local h = Utils.GetHumanoidRootPart()
        if h then
            if wasFloating then
                MiningSystem.EnableUndergroundFloat(savedCF)
            else
                MiningSystem.DisableUndergroundFloat()
                h.CFrame = savedCF
            end
            task.wait(0.2)
        end
    else
        MiningSystem.DisableUndergroundFloat()
    end
    AutoSellRuntime.OreCountSnap = Settings.Mining.TotalMined
    AutoSellRuntime.IsBusy = false
    if sold then
        Notify({ Title = "Jual Ore Otomatis",
            Message = "Ore terjual!",
            Type = "success", Duration = 2 })
    else
        Notify({ Title = "Jual Ore Otomatis",
            Message = "Tidak ada ore / jual masih gagal.",
            Type = "warning", Duration = 2 })
    end
    return sold
end

function AutoSell.StartFishLoop()
    if AutoSellRuntime.FishThread then return end
    AutoSellRuntime.FishCountSnap = Settings.Fishing.TotalFishCaught
    AutoSellRuntime.FishThread = task.spawn(function()
        while AutoSellSettings.FishEnabled do
            task.wait(4)
            if not AutoSellSettings.FishEnabled then break end
            local caught = Settings.Fishing.TotalFishCaught - AutoSellRuntime.FishCountSnap
            if caught >= AutoSellSettings.FishTrigger then
                local was = Settings.Fishing.Enabled
                if was then Settings.Fishing.Enabled = false task.wait(1.5) end
                AutoSell_DoFish()
                if was and AutoSellSettings.FishEnabled then
                    Settings.Fishing.Enabled = true
                    task.spawn(FishingSystem.Start)
                end
            end
        end
        AutoSellRuntime.FishThread = nil
    end)
end

function AutoSell.StopFishLoop()
    AutoSellSettings.FishEnabled = false
    if AutoSellRuntime.FishThread then
        pcall(function() task.cancel(AutoSellRuntime.FishThread) end)
        AutoSellRuntime.FishThread = nil
    end
end

function AutoSell.StartOreLoop()
    if AutoSellRuntime.OreThread then return end
    AutoSellRuntime.OreThread = task.spawn(function()
        while AutoSellSettings.OreEnabled do
            local mined = Settings.Mining.TotalMined - AutoSellRuntime.OreCountSnap
            if mined >= AutoSellSettings.OreTrigger then
                local was = Settings.Mining.Enabled
                if was then Settings.Mining.Enabled = false task.wait(1.5) end
                AutoSell_DoOre()
                if was and AutoSellSettings.OreEnabled then
                    Settings.Mining.Enabled = true
                    task.spawn(MiningSystem.Start)
                end
            end
            task.wait(4)
            if not AutoSellSettings.OreEnabled then break end
        end
        AutoSellRuntime.OreThread = nil
    end)
end

function AutoSell.StopOreLoop()
    AutoSellSettings.OreEnabled = false
    if AutoSellRuntime.OreThread then
        pcall(function() task.cancel(AutoSellRuntime.OreThread) end)
        AutoSellRuntime.OreThread = nil
    end
end

local HotspotESP = {}
local HotspotSettings = {
    FishingEnabled = false, FishingESP = false, FishingTracer = false,
    FishingOnlyHotspot = false, FishingMaxDist = 5000,
    MiningEnabled = false, MiningESP = false, MiningTracer = false,
    MiningOnlyHotspot = false, MiningMaxDist = 5000,
    MiningChams = false, FishingChams = false,
}
local HotspotRuntime = {
    FishingDrawings = {}, MiningDrawings = {}, Highlights = {},
    HiddenBBs = {}, ChamsFolder = nil, Thread = nil,
}

local COLOR_HOTSPOT_GOLD   = Color3.fromRGB(255, 215, 0)
local COLOR_HOTSPOT_GREEN  = Color3.fromRGB(40, 255, 130)
local COLOR_NORMAL_ORE     = Color3.fromRGB(120, 205, 255)
local COLOR_NORMAL_FISHING = Color3.fromRGB(140, 185, 215)

local function EnsureChamsFolder()
    if not HotspotRuntime.ChamsFolder or not HotspotRuntime.ChamsFolder.Parent then
        local f = Instance.new("Folder")
        f.Name = "Delirium_Hotspot_Chams"
        f.Parent = workspace
        HotspotRuntime.ChamsFolder = f
    end
    return HotspotRuntime.ChamsFolder
end

local function NewTracerLine(color, thickness)
    if not Drawing then return nil end
    local outline = Drawing.new("Line")
    outline.Color = Color3.fromRGB(0, 0, 0)
    outline.Thickness = (thickness or 2) + 2.5
    outline.Visible = false
    outline.ZIndex = 9
    outline.Transparency = 0.5
    local line = Drawing.new("Line")
    line.Color = color or Color3.new(1, 1, 1)
    line.Thickness = thickness or 2
    line.Visible = false
    line.ZIndex = 10
    line._outline = outline
    return line
end

local function UpdateTracerLine(t, from, to, color, thickness)
    if not t then return end
    local screenDist = (to - from).Magnitude
    local dynThick = math.clamp((thickness or 2) * math.max(0.4, 1 - screenDist / 2000), 1, 4.5)
    t.From = from
    t.To   = to
    t.Color = color
    t.Thickness = dynThick
    t.Visible = true
    if t._outline then
        t._outline.From = from
        t._outline.To   = to
        t._outline.Thickness = dynThick + 2.5
        t._outline.Visible = true
    end
end

local function SetTracerVisible(t, v)
    if not t then return end
    t.Visible = v
    if t._outline then t._outline.Visible = v end
end

local function DestroyTracerLine(t)
    if not t then return end
    if t._outline then pcall(function() t._outline:Remove() end) end
    pcall(function() t:Remove() end)
end

local function CreateESPChams(adornee, text, color, isHotspot)
    if not adornee or not adornee.Parent then return end
    local container = EnsureChamsFolder()
    local existing = HotspotRuntime.Highlights[adornee]
    if existing then
        pcall(function()
            if existing.hl then existing.hl:Destroy() end
            if existing.bb then existing.bb:Destroy() end
        end)
        HotspotRuntime.Highlights[adornee] = nil
    end
    local function hideBB(inst)
        if inst:IsA("BillboardGui") and not inst:GetAttribute("DX8_IV_ESP") then
            table.insert(HotspotRuntime.HiddenBBs, { bb = inst, vis = inst.Enabled })
            inst.Enabled = false
        end
    end
    for _, c in ipairs(adornee:GetChildren()) do hideBB(c) end
    if adornee:IsA("Model") then
        for _, d in ipairs(adornee:GetDescendants()) do hideBB(d) end
    end
    local hl = Instance.new("Highlight")
    hl.Name = "IV_HL_" .. tostring(adornee.Name)
    hl.Adornee = adornee
    hl.FillColor = color
    hl.FillTransparency = isHotspot and 0.45 or 0.70
    hl.OutlineColor = isHotspot and COLOR_HOTSPOT_GOLD or Color3.fromRGB(255,255,255)
    hl.OutlineTransparency = 0.15
    hl.DepthMode = Enum.HighlightDepthMode.AlwaysOnTop
    hl.Parent = container

    local bb = Instance.new("BillboardGui")
    bb.Name = "IV_BB_" .. tostring(adornee.Name)
    bb.Adornee = adornee
    bb.Size = UDim2.new(0, 180, 0, 32)
    bb.StudsOffset = Vector3.new(0, isHotspot and 5 or 3.5, 0)
    bb.AlwaysOnTop = true bb.MaxDistance = 0 bb.LightInfluence = 0
    bb:SetAttribute("DX8_IV_ESP", true)
    bb.Parent = container

    local lbl = Instance.new("TextLabel")
    lbl.Size = UDim2.new(1, 0, 1, 0)
    lbl.BackgroundTransparency = 1
    lbl.Text = text
    lbl.TextColor3 = color
    lbl.Font = Enum.Font.GothamBold
    lbl.TextSize = isHotspot and 14 or 12
    lbl.TextStrokeColor3 = Color3.new(0,0,0)
    lbl.TextStrokeTransparency = 0.2
    lbl.Parent = bb

    HotspotRuntime.Highlights[adornee] = { hl = hl, bb = bb }
end

local function RemoveESPChams(adornee)
    local d = HotspotRuntime.Highlights[adornee]
    if d then
        pcall(function() if d.hl then d.hl:Destroy() end end)
        pcall(function() if d.bb then d.bb:Destroy() end end)
        HotspotRuntime.Highlights[adornee] = nil
    end
end

local function ClearDrawingsTable(tbl)
    for k, d in pairs(tbl) do
        if d.line then DestroyTracerLine(d.line) end
        if d.label then pcall(function() d.label:Remove() end) end
        tbl[k] = nil
    end
end

local function ClearAllHighlights()
    for _, e in ipairs(HotspotRuntime.HiddenBBs) do
        pcall(function() e.bb.Enabled = e.vis end)
    end
    HotspotRuntime.HiddenBBs = {}
    for inst, d in pairs(HotspotRuntime.Highlights) do
        pcall(function()
            if type(d) == "table" then
                if d.hl then d.hl:Destroy() end
                if d.bb then d.bb:Destroy() end
            else d:Destroy() end
        end)
        HotspotRuntime.Highlights[inst] = nil
    end
    if HotspotRuntime.ChamsFolder then
        pcall(function() HotspotRuntime.ChamsFolder:Destroy() end)
        HotspotRuntime.ChamsFolder = nil
    end
end

local function GetFishingZones()
    local out = {}
    local fz
    local world = workspace:FindFirstChild("World")
    if world then
        for _, map in ipairs(world:GetChildren()) do
            if map.Name ~= "MainBaseplate" then
                local asset = map:FindFirstChild("Asset")
                if asset then
                    fz = asset:FindFirstChild("FishingZone") or asset:FindFirstChild("FishingSpots")
                    if fz then break end
                end
            end
        end
    end
    if not fz then
        local main = workspace:FindFirstChild("Main")
        fz = main and main:FindFirstChild("FishingZone")
    end
    if not fz then
        local rs_main = ReplicatedStorage:FindFirstChild("Main")
        fz = rs_main and rs_main:FindFirstChild("FishingZone")
    end
    if fz then
        for i, c in ipairs(fz:GetChildren()) do
            local part = c:IsA("BasePart") and c
                       or (c:IsA("Model") and (c.PrimaryPart or c:FindFirstChildWhichIsA("BasePart")))
            if part then
                local isActive = c:GetAttribute("IsActive") == true
                    or c:FindFirstChild("DX8_Active") ~= nil
                    or part:GetAttribute("IsActive") == true
                table.insert(out, { index = i, instance = c, part = part, isActive = isActive })
            end
        end
    end
    return out
end

local function GetMiningStones()
    local out = {}
    local container = MiningSystem.GetMiningContainer()
        or (workspace:FindFirstChild("Main")
            and workspace:FindFirstChild("Main"):FindFirstChild("ActiveMiningStones"))
    if container then
        for i, c in ipairs(container:GetChildren()) do
            local part = c:IsA("BasePart") and c
                       or (c:IsA("Model") and (c.PrimaryPart or c:FindFirstChildWhichIsA("BasePart")))
            if part then
                local isHot = c:GetAttribute("IsHotspot") == true or c:FindFirstChild("Hotspot") ~= nil
                local slot  = c:GetAttribute("AvailableSlot") or 0
                local maxS  = c:GetAttribute("MaxSlot") or 0
                table.insert(out, {
                    index = i, instance = c, part = part,
                    isHotspot = isHot, availableSlot = slot, maxSlot = maxS,
                })
            end
        end
    end
    return out
end

function HotspotESP.TeleportToNearestFishing(onlyActive)
    local zones = GetFishingZones()
    local myPos = Utils.GetCharacterPosition()
    local near, nd = nil, math.huge
    for _, z in ipairs(zones) do
        if not onlyActive or z.isActive then
            local d = (z.part.Position - myPos).Magnitude
            if d < nd then nd, near = d, z end
        end
    end
    if near then
        SafeTeleportTo(near.part.Position)
        local tag = near.isActive and "HOTSPOT AKTIF" or ("Spot #" .. near.index)
        Notify({ Title = "Spot Mancing",
            Message = "Teleport ke " .. tag .. " (" .. math.floor(nd) .. "m)",
            Type = "success", Duration = 2 })
    else
        Notify({ Title = "Spot Mancing",
            Message = onlyActive and "Tidak ada hotspot mancing aktif." or "Tidak ada zona mancing.",
            Type = "warning", Duration = 2 })
    end
end

function HotspotESP.TeleportToNearestMining(onlyHotspot)
    local stones = GetMiningStones()
    local myPos = Utils.GetCharacterPosition()
    local near, nd = nil, math.huge
    for _, s in ipairs(stones) do
        if not onlyHotspot or s.isHotspot then
            local d = (s.part.Position - myPos).Magnitude
            if d < nd then nd, near = d, s end
        end
    end
    if near then
        SafeTeleportTo(near.part.Position)
        local tag = near.isHotspot and "ORE HOTSPOT" or near.instance.Name
        Notify({ Title = "Batu Tambang",
            Message = "Teleport ke " .. tag .. " (" .. math.floor(nd) .. "m)",
            Type = "success", Duration = 2 })
    else
        Notify({ Title = "Batu Tambang",
            Message = onlyHotspot and "Tidak ada ore hotspot aktif di map." or "Tidak ada batu tambang.",
            Type = "warning", Duration = 2 })
    end
end

local function UpdateHotspotESP()
    local cam = workspace.CurrentCamera if not cam then return end
    local myPos = Utils.GetCharacterPosition()
    local vp = cam.ViewportSize
    local hrp = LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("HumanoidRootPart")
    local hrpScreen = hrp and cam:WorldToViewportPoint(hrp.Position)
    local origin = (hrpScreen and hrpScreen.Z > 0)
        and Vector2.new(hrpScreen.X, hrpScreen.Y)
        or  Vector2.new(vp.X / 2, vp.Y)

    if HotspotSettings.FishingEnabled then
        local zones = GetFishingZones()
        local seen = {}
        for _, z in ipairs(zones) do
            local distVal = (z.part.Position - myPos).Magnitude
            if distVal <= HotspotSettings.FishingMaxDist then
                if not HotspotSettings.FishingOnlyHotspot or z.isActive then
                    seen[z.instance] = true
                    local d = HotspotRuntime.FishingDrawings[z.instance]
                    local isChasm = z.part.Position.Y < -5
                    local color = z.isActive
                        and (isChasm and Color3.fromRGB(0, 210, 255) or COLOR_HOTSPOT_GREEN)
                        or  (isChasm and Color3.fromRGB(255, 150, 0) or COLOR_NORMAL_FISHING)
                    local dist = math.floor(distVal)
                    if not d then
                        local line = NewTracerLine(color, z.isActive and 2.5 or 1.5)
                        local label
                        if Drawing then
                            label = Drawing.new("Text")
                            label.Color = color
                            label.Size = z.isActive and 14 or 12
                            label.Center = true
                            label.Outline = true
                            label.OutlineColor = Color3.fromRGB(0,0,0)
                            label.Font = Drawing.Fonts.UI
                            label.ZIndex = 11
                            label.Visible = false
                        end
                        d = { line = line, label = label, part = z.part }
                        HotspotRuntime.FishingDrawings[z.instance] = d
                    else
                        if d.line then d.line.Color = color end
                        if d.label then d.label.Color = color end
                    end
                    local screenPos, onScreen = cam:WorldToViewportPoint(z.part.Position)
                    if screenPos.Z > 0 then
                        if HotspotSettings.FishingTracer then
                            UpdateTracerLine(d.line, origin, Vector2.new(screenPos.X, screenPos.Y), color,
                                z.isActive and 2.5 or 1.5)
                        else
                            SetTracerVisible(d.line, false)
                        end
                    else
                        SetTracerVisible(d.line, false)
                    end
                    if d.label then
                        if onScreen and screenPos.Z > 0 then
                            d.label.Position = Vector2.new(screenPos.X, screenPos.Y - 14)
                            local zoneTag = isChasm and "[JURANG] " or ""
                            d.label.Text = z.isActive
                                and string.format("%sHOTSPOT AKTIF #%d (%dm)", zoneTag, z.index, dist)
                                or  string.format("%sSpot Mancing #%d (%dm)", zoneTag, z.index, dist)
                            d.label.Visible = true
                        else
                            d.label.Visible = false
                        end
                    end
                end
            end
        end
        for inst, d in pairs(HotspotRuntime.FishingDrawings) do
            if not seen[inst] then
                if d.line then DestroyTracerLine(d.line) end
                if d.label then pcall(function() d.label:Remove() end) end
                RemoveESPChams(inst)
                HotspotRuntime.FishingDrawings[inst] = nil
            end
        end
    else
        ClearDrawingsTable(HotspotRuntime.FishingDrawings)
    end

    if HotspotSettings.MiningEnabled then
        local stones = GetMiningStones()
        local seen = {}
        for _, s in ipairs(stones) do
            local wp = (s.instance:IsA("Model") and s.instance:GetPivot().Position) or s.part.Position
            local distVal = (wp - myPos).Magnitude
            if distVal <= HotspotSettings.MiningMaxDist then
                if not HotspotSettings.MiningOnlyHotspot or s.isHotspot then
                    seen[s.instance] = true
                    local d = HotspotRuntime.MiningDrawings[s.instance]
                    local color = s.isHotspot and COLOR_HOTSPOT_GOLD or COLOR_NORMAL_ORE
                    local dist = math.floor(distVal)
                    local slotStr = (s.maxSlot > 0) and string.format("[%d/%d]", s.availableSlot, s.maxSlot) or ""
                    if not d then
                        local line = NewTracerLine(color, s.isHotspot and 2 or 1.5)
                        local label
                        if Drawing then
                            label = Drawing.new("Text")
                            label.Color = color
                            label.Size = s.isHotspot and 14 or 12
                            label.Center = true
                            label.Outline = true
                            label.OutlineColor = Color3.fromRGB(0,0,0)
                            label.Font = Drawing.Fonts.UI
                            label.ZIndex = 11
                            label.Visible = false
                        end
                        d = { line = line, label = label, part = s.part }
                        HotspotRuntime.MiningDrawings[s.instance] = d
                    else
                        if d.line then d.line.Color = color end
                        if d.label then d.label.Color = color end
                    end
                    local screenPos, onScreen = cam:WorldToViewportPoint(wp)
                    if screenPos.Z > 0 then
                        if HotspotSettings.MiningTracer then
                            UpdateTracerLine(d.line, origin, Vector2.new(screenPos.X, screenPos.Y), color,
                                s.isHotspot and 2 or 1.5)
                        else
                            SetTracerVisible(d.line, false)
                        end
                    else
                        SetTracerVisible(d.line, false)
                    end
                    if d.label then
                        if onScreen and screenPos.Z > 0 and not HotspotSettings.MiningChams then
                            d.label.Position = Vector2.new(screenPos.X, screenPos.Y - 14)
                            d.label.Text = s.isHotspot
                                and string.format("ORE HOTSPOT %s (%dm)", slotStr, dist)
                                or  string.format("%s %s (%dm)", s.instance.Name, slotStr, dist)
                            d.label.Visible = true
                        else
                            d.label.Visible = false
                        end
                    end
                    if HotspotSettings.MiningChams then
                        local title = s.isHotspot
                            and string.format("HOTSPOT %s (%dm)", slotStr, dist)
                            or  string.format("%s %s (%dm)", s.instance.Name, slotStr, dist)
                        local ex = HotspotRuntime.Highlights[s.instance]
                        if not ex or not ex.hl or not ex.hl.Parent then
                            CreateESPChams(s.instance, title, color, s.isHotspot)
                        else
                            pcall(function()
                                local lbl = ex.bb:FindFirstChildWhichIsA("TextLabel")
                                if lbl then lbl.Text = title end
                            end)
                        end
                    end
                end
            end
        end
        for inst, d in pairs(HotspotRuntime.MiningDrawings) do
            if not seen[inst] then
                if d.line then DestroyTracerLine(d.line) end
                if d.label then pcall(function() d.label:Remove() end) end
                RemoveESPChams(inst)
                HotspotRuntime.MiningDrawings[inst] = nil
            end
        end
    else
        ClearDrawingsTable(HotspotRuntime.MiningDrawings)
    end
end

function HotspotESP.Start()
    if HotspotRuntime.Thread then return end
    HotspotRuntime.Thread = task.spawn(function()
        while HotspotSettings.FishingEnabled or HotspotSettings.MiningEnabled do
            pcall(UpdateHotspotESP)
            RunService.RenderStepped:Wait()
        end
        ClearDrawingsTable(HotspotRuntime.FishingDrawings)
        ClearDrawingsTable(HotspotRuntime.MiningDrawings)
        ClearAllHighlights()
        HotspotRuntime.Thread = nil
    end)
end

function HotspotESP.Stop()
    HotspotSettings.FishingEnabled = false
    HotspotSettings.FishingChams   = false
    HotspotSettings.MiningEnabled  = false
    HotspotSettings.MiningChams    = false
    if HotspotRuntime.Thread then
        task.cancel(HotspotRuntime.Thread)
        HotspotRuntime.Thread = nil
    end
    ClearDrawingsTable(HotspotRuntime.FishingDrawings)
    ClearDrawingsTable(HotspotRuntime.MiningDrawings)
    ClearAllHighlights()
    for _, item in ipairs(HotspotRuntime.HiddenBBs) do
        pcall(function()
            if item.bb and item.bb.Parent then item.bb.Enabled = item.vis end
        end)
    end
    table.clear(HotspotRuntime.HiddenBBs)
    if HotspotRuntime.ChamsFolder and HotspotRuntime.ChamsFolder.Parent then
        pcall(function() HotspotRuntime.ChamsFolder:Destroy() end)
        HotspotRuntime.ChamsFolder = nil
    end
    local cf = workspace:FindFirstChild("Delirium_Hotspot_Chams")
    if cf then pcall(function() cf:Destroy() end) end
end

function HotspotESP.CheckActive()
    if HotspotSettings.FishingEnabled or HotspotSettings.MiningEnabled then HotspotESP.Start()
    else HotspotESP.Stop() end
end

local GhostHuntESP = {}
local GhostHuntSettings = {
    Enabled   = false,
    Tracer    = true,
    MaxDist   = 5000,
}
local GhostHuntRuntime = {
    Thread    = nil,
    Drawings  = {},
    Highlights = {},
}

local GHOST_COLOR     = Color3.fromRGB(140, 220, 255)
local GHOST_NAMES     = { "Ghost1", "Ghost2", "Ghost3", "Ghost4", "Ghost5" }

local function GH_GetGhosts()
    local folder = workspace:FindFirstChild("GhostHunt")
    if not folder then return {} end
    local out = {}
    for _, name in ipairs(GHOST_NAMES) do
        local model = folder:FindFirstChild(name)
        if model then
            local part = model.PrimaryPart
                or model:FindFirstChild("HumanoidRootPart")
                or model:FindFirstChildWhichIsA("BasePart")
            if part then
                table.insert(out, { name = name, model = model, part = part })
            end
        end
    end
    return out
end

local function GH_CreateHighlight(model)
    if GhostHuntRuntime.Highlights[model] then return end
    local hl = Instance.new("Highlight")
    hl.FillColor           = GHOST_COLOR
    hl.OutlineColor        = Color3.fromRGB(255, 255, 255)
    hl.FillTransparency    = 0.40
    hl.OutlineTransparency = 0.10
    hl.DepthMode           = Enum.HighlightDepthMode.AlwaysOnTop
    hl.Adornee             = model
    hl.Parent              = model
    GhostHuntRuntime.Highlights[model] = hl
end

local function GH_RemoveHighlight(model)
    local hl = GhostHuntRuntime.Highlights[model]
    if hl then
        pcall(function() hl:Destroy() end)
        GhostHuntRuntime.Highlights[model] = nil
    end
end

local function GH_ClearAll()
    for _, d in pairs(GhostHuntRuntime.Drawings) do
        if d.line  then DestroyTracerLine(d.line) end
        if d.label then pcall(function() d.label:Remove() end) end
    end
    GhostHuntRuntime.Drawings = {}
    for model, _ in pairs(GhostHuntRuntime.Highlights) do
        GH_RemoveHighlight(model)
    end
end

local function GH_Update()
    local cam   = workspace.CurrentCamera if not cam then return end
    local myPos = Utils.GetCharacterPosition()
    local vp    = cam.ViewportSize
    local hrp   = LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("HumanoidRootPart")
    local hrpSc = hrp and cam:WorldToViewportPoint(hrp.Position)
    local origin = (hrpSc and hrpSc.Z > 0)
        and Vector2.new(hrpSc.X, hrpSc.Y)
        or  Vector2.new(vp.X / 2, vp.Y)

    local ghosts = GH_GetGhosts()
    local seen   = {}

    for _, g in ipairs(ghosts) do
        if not g.part.Parent then continue end
        local pos   = g.part.Position
        local dist  = (pos - myPos).Magnitude
        if dist > GhostHuntSettings.MaxDist then continue end

        seen[g.model] = true

        GH_CreateHighlight(g.model)

        local d = GhostHuntRuntime.Drawings[g.model]
        if not d then
            local line = NewTracerLine(GHOST_COLOR, 2)
            local label
            if Drawing then
                label = Drawing.new("Text")
                label.Color   = GHOST_COLOR
                label.Size    = 14
                label.Center  = true
                label.Outline = true
                label.OutlineColor = Color3.fromRGB(0, 0, 0)
                label.Font    = Drawing.Fonts.UI
                label.ZIndex  = 11
                label.Visible = false
            end
            d = { line = line, label = label }
            GhostHuntRuntime.Drawings[g.model] = d
        end

        local screenPos, onScreen = cam:WorldToViewportPoint(pos)
        if screenPos.Z > 0 then
            if GhostHuntSettings.Tracer then
                UpdateTracerLine(d.line, origin, Vector2.new(screenPos.X, screenPos.Y), GHOST_COLOR, 2)
            else
                SetTracerVisible(d.line, false)
            end
            if d.label then
                if onScreen then
                    d.label.Position = Vector2.new(screenPos.X, screenPos.Y - 16)
                    d.label.Text     = string.format("👻 %s [%dm]", g.name, math.floor(dist))
                    d.label.Visible  = true
                else
                    d.label.Visible  = false
                end
            end
        else
            SetTracerVisible(d.line, false)
            if d.label then d.label.Visible = false end
        end
    end

    for model, d in pairs(GhostHuntRuntime.Drawings) do
        if not seen[model] then
            if d.line  then DestroyTracerLine(d.line) end
            if d.label then pcall(function() d.label:Remove() end) end
            GhostHuntRuntime.Drawings[model] = nil
            GH_RemoveHighlight(model)
        end
    end
end

function GhostHuntESP.Start()
    if GhostHuntRuntime.Thread then return end
    GhostHuntRuntime.Thread = task.spawn(function()
        while GhostHuntSettings.Enabled do
            pcall(GH_Update)
            RunService.RenderStepped:Wait()
        end
        GH_ClearAll()
        GhostHuntRuntime.Thread = nil
    end)
end

function GhostHuntESP.Stop()
    GhostHuntSettings.Enabled = false
    if GhostHuntRuntime.Thread then
        task.cancel(GhostHuntRuntime.Thread)
        GhostHuntRuntime.Thread = nil
    end
    GH_ClearAll()
end

local AutoFavFish = {}
local AutoFavFishSettings = {
    Mode = "By Rarity", MinRarity = {"Ancient","Mythic","Legend","Epic","Rare","Uncommon","Common"},
    MinPrice = 100000, MinWeight = 50,
    BatchSize = 4, BatchDelay = 0.12,
    RetryFailed = true, RetryDelay = 0.6,
}
local AutoFavFishRuntime = {
    IsBusy = false, ReplicaManager = nil, FavRemote = nil,
    FishContent = nil, StatusLabel = nil,
}
local RARITY_ORDER = {
    Common = 1, Uncommon = 2, Rare = 3, Epic = 4,
    Legend = 5, Mythic = 6, Ancient = 7,
}

local function AutoFavFish_Init()
    pcall(function()
        local rf = game:GetService("ReplicatedFirst")
        local mgr = rf:WaitForChild("Manager", 5)
        if mgr and mgr:FindFirstChild("ReplicaManager") then
            AutoFavFishRuntime.ReplicaManager = require(mgr.ReplicaManager)
        end
    end)
    pcall(function()
        AutoFavFishRuntime.FishContent = require(
            ReplicatedStorage:WaitForChild("Content", 5):WaitForChild("Fish", 5))
    end)
    pcall(function()
        local fns = ReplicatedStorage:FindFirstChild("GameRemoteFunctions")
        AutoFavFishRuntime.FavRemote = fns and fns:FindFirstChild("InventoryFishFavoriteFunction")
    end)
end

local function AutoFavFish_GetProfileFish()
    if not AutoFavFishRuntime.ReplicaManager then return nil end
    local ok, d = pcall(function()
        local r = AutoFavFishRuntime.ReplicaManager:GetPlayerData(LocalPlayer)
        return r and r.ProfileReplica and r.ProfileReplica.Data
    end)
    if not ok or not d then return nil end
    return d.Fish
end

local function AutoFavFish_GetRarity(fd)
    if fd.Rarity and type(fd.Rarity) == "string" then return fd.Rarity end
    local c = AutoFavFishRuntime.FishContent
    if not c or not fd.FishId then return "Common" end
    local info = c[fd.FishId]
    if info and info.Rarity then return info.Rarity end
    local low = string.lower(fd.FishId)
    for k, v in pairs(c) do
        if string.lower(tostring(k)) == low then
            if v and v.Rarity then return v.Rarity end
            break
        end
    end
    if string.find(low, "ancient")  then return "Ancient"  end
    if string.find(low, "mythic")   then return "Mythic"   end
    if string.find(low, "legend")   then return "Legend"   end
    if string.find(low, "epic")     then return "Epic"     end
    if string.find(low, "rare")     then return "Rare"     end
    if string.find(low, "uncommon") then return "Uncommon" end
    return "Common"
end

local function AutoFavFish_Matches(fd)
    if AutoFavFishSettings.Mode == "All" then return true end
    if AutoFavFishSettings.Mode == "By Rarity" then
        local r = AutoFavFish_GetRarity(fd)
        local list = AutoFavFishSettings.MinRarity
        if type(list) == "string" then list = { list } end
        for _, tier in ipairs(list) do
            if tier == r then return true end
        end
        return false
    end
    if AutoFavFishSettings.Mode == "By Price" then
        return (fd.Price or 0) >= AutoFavFishSettings.MinPrice
    end
    if AutoFavFishSettings.Mode == "By Weight" then
        return (fd.Weight or 0) >= AutoFavFishSettings.MinWeight
    end
    return false
end

local function AutoFavFish_SetStatus(msg)
    local lbl = AutoFavFishRuntime.StatusLabel
    if not lbl then return end
    pcall(function() lbl:Set(msg) end)
end

local function AutoFavFish_FireBatch(uids)
    local results, finished, total = {}, 0, #uids
    for _, uid in ipairs(uids) do
        task.spawn(function()
            local ok, res = pcall(function() return AutoFavFishRuntime.FavRemote:InvokeServer(uid) end)
            results[uid] = ok and res == true
            finished += 1
        end)
    end
    local dl = os.clock() + 8
    while finished < total and os.clock() < dl do task.wait(0.02) end
    return results
end

function AutoFavFish.Run(unfavoriteAll)
    if AutoFavFishRuntime.IsBusy then
        Notify({ Title = "Favorit Otomatis", Message = "Masih berjalan, tunggu sampai selesai.",
            Type = "warning", Duration = 3 })
        return
    end
    AutoFavFishRuntime.IsBusy = true
    AutoFavFish_SetStatus("Status: memindai...")
    task.spawn(function()
        if not AutoFavFishRuntime.ReplicaManager or not AutoFavFishRuntime.FavRemote then
            AutoFavFish_Init()
        end
        if not AutoFavFishRuntime.FavRemote then
            AutoFavFish_SetStatus("Status: remote tidak ditemukan")
            Notify({ Title = "Favorit Otomatis", Message = "InventoryFishFavoriteFunction tidak ditemukan.",
                Type = "error", Duration = 4 })
            AutoFavFishRuntime.IsBusy = false
            return
        end
        local table_ = AutoFavFish_GetProfileFish()
        if not table_ then
            AutoFavFish_SetStatus("Status: tidak ada data profil")
            Notify({ Title = "Favorit Otomatis", Message = "Tidak bisa membaca inventory ikan.",
                Type = "error", Duration = 4 })
            AutoFavFishRuntime.IsBusy = false
            return
        end
        local toToggle = {}
        for uid, fd in pairs(table_) do
            if typeof(fd) == "table" and fd.FishId then
                local should
                if unfavoriteAll then should = false else should = AutoFavFish_Matches(fd) end
                local isFav = fd.Favorite == true
                if should ~= isFav then
                    if should then table.insert(toToggle, uid)
                    elseif unfavoriteAll then table.insert(toToggle, uid) end
                end
            end
        end
        if #toToggle == 0 then
            AutoFavFish_SetStatus("Status: tidak ada yang perlu diubah")
            Notify({ Title = "Favorit Otomatis", Message = "Semua ikan sudah sesuai target.",
                Type = "success", Duration = 3 })
            AutoFavFishRuntime.IsBusy = false
            return
        end
        Notify({ Title = "Favorit Otomatis",
            Message = string.format("Memproses %d ikan (batch %d)...", #toToggle, AutoFavFishSettings.BatchSize),
            Type = "info", Duration = 3 })
        local done, failed = 0, {}
        local bs = math.max(1, AutoFavFishSettings.BatchSize)
        local bd = AutoFavFishSettings.BatchDelay
        local total = #toToggle
        local bn = 0
        for bs_ = 1, total, bs do
            bn += 1
            local be = math.min(bs_ + bs - 1, total)
            local bu = {}
            for i = bs_, be do table.insert(bu, toToggle[i]) end
            AutoFavFish_SetStatus(string.format("Status: batch %d — %d / %d selesai", bn, math.min(bs_ - 1, total), total))
            local res = AutoFavFish_FireBatch(bu)
            for _, uid in ipairs(bu) do
                if res[uid] then done += 1 else table.insert(failed, uid) end
            end
            if bs_ + bs <= total then task.wait(bd) end
        end
        if AutoFavFishSettings.RetryFailed and #failed > 0 then
            AutoFavFish_SetStatus(string.format("Status: mencoba ulang %d yang gagal...", #failed))
            task.wait(AutoFavFishSettings.RetryDelay)
            local still = 0
            for _, uid in ipairs(failed) do
                local ok, res = pcall(function() return AutoFavFishRuntime.FavRemote:InvokeServer(uid) end)
                if ok and res then done += 1 else still += 1 end
                task.wait(0.15)
            end
            failed = {}
            for _ = 1, still do table.insert(failed, true) end
        end
        local action = unfavoriteAll and "Unfavorited" or "Difavoritkan"
        local msg = string.format("%s %d / %d ikan. Gagal: %d", action, done, total, #failed)
        AutoFavFish_SetStatus("Status: selesai — " .. msg)
        Notify({ Title = "Favorit Otomatis", Message = msg,
            Type = #failed > 0 and "warning" or "success", Duration = 5 })
        AutoFavFishRuntime.IsBusy = false
    end)
end

local AutoFavOre = {}
local AutoFavOreSettings = {
    Mode = "By Rarity",
    MinRarity = {"Ancient","Mythic","Legend","Epic","Rare","Uncommon","Common"},
    MinDensity = 50,
    BatchSize = 4,
    BatchDelay = 0.12,
    RetryFailed = true,
    RetryDelay = 0.6,
}
local AutoFavOreRuntime = {
    IsBusy = false, ReplicaManager = nil, FavRemote = nil,
    OreContent = nil, StatusLabel = nil,
}
local ORE_RARITY_ORDER = {
    Common = 1, Uncommon = 2, Rare = 3, Epic = 4,
    Legend = 5, Mythic = 6, Ancient = 7,
}

local function AutoFavOre_Init()
    pcall(function()
        local rf = game:GetService("ReplicatedFirst")
        local mgr = rf:WaitForChild("Manager", 5)
        if mgr and mgr:FindFirstChild("ReplicaManager") then
            AutoFavOreRuntime.ReplicaManager = require(mgr.ReplicaManager)
        end
    end)
    pcall(function()
        local cont = ReplicatedStorage:FindFirstChild("Content")
        if cont and cont:FindFirstChild("Ore") then
            AutoFavOreRuntime.OreContent = require(cont.Ore)
        end
    end)
    pcall(function()
        local fns = ReplicatedStorage:FindFirstChild("GameRemoteFunctions")
        AutoFavOreRuntime.FavRemote = fns and fns:FindFirstChild("InventoryOreFavoriteFunction")
    end)
end

local function AutoFavOre_GetProfileOres()
    if not AutoFavOreRuntime.ReplicaManager then return nil end
    local ok, d = pcall(function()
        local r = AutoFavOreRuntime.ReplicaManager:GetPlayerData(LocalPlayer)
        return r and r.ProfileReplica and r.ProfileReplica.Data
    end)
    if not ok or not d then return nil end
    return d.Ore
end

local function AutoFavOre_GetRarity(od)
    if od.Rarity and type(od.Rarity) == "string" then return od.Rarity end
    local c = AutoFavOreRuntime.OreContent
    if not c or not od.OreId then return "Common" end
    local info = c[od.OreId]
    if info and info.Rarity then return info.Rarity end
    local low = string.lower(tostring(od.OreId))
    if string.find(low, "ancient")  then return "Ancient"  end
    if string.find(low, "mythic")   then return "Mythic"   end
    if string.find(low, "legend")   then return "Legend"   end
    if string.find(low, "epic")     then return "Epic"     end
    if string.find(low, "rare")     then return "Rare"     end
    if string.find(low, "uncommon") then return "Uncommon" end
    return "Common"
end

local function AutoFavOre_Matches(od)
    if AutoFavOreSettings.Mode == "All" then return true end
    if AutoFavOreSettings.Mode == "By Rarity" then
        local r = AutoFavOre_GetRarity(od)
        local list = AutoFavOreSettings.MinRarity
        if type(list) == "string" then list = { list } end
        for _, tier in ipairs(list) do
            if tier == r then return true end
        end
        return false
    end
    if AutoFavOreSettings.Mode == "By Density" then
        return (od.Density or 0) >= AutoFavOreSettings.MinDensity
    end
    return false
end

local function AutoFavOre_SetStatus(msg)
    local lbl = AutoFavOreRuntime.StatusLabel
    if lbl then pcall(function() lbl:Set(msg) end) end
end

local function AutoFavOre_FireBatch(uids)
    local results = {}
    for _, uid in ipairs(uids) do
        local ok, res = pcall(function()
            return AutoFavOreRuntime.FavRemote:InvokeServer(uid)
        end)
        results[uid] = { ok = ok, res = res }
        task.wait(0.04)
    end
    return results
end

function AutoFavOre.Run(unfavoriteAll)
    if AutoFavOreRuntime.IsBusy then
        AutoFavOre_SetStatus("Status: masih berjalan...")
        return
    end
    AutoFavOreRuntime.IsBusy = true
    AutoFavOre_SetStatus("Status: memindai...")

    if not AutoFavOreRuntime.ReplicaManager or not AutoFavOreRuntime.FavRemote then
        AutoFavOre_Init()
    end
    if not AutoFavOreRuntime.FavRemote then
        AutoFavOre_SetStatus("Status: remote tidak ditemukan")
        AutoFavOreRuntime.IsBusy = false
        return
    end

    local ores = AutoFavOre_GetProfileOres()
    if not ores then
        AutoFavOre_SetStatus("Status: data profil tidak ada")
        AutoFavOreRuntime.IsBusy = false
        return
    end

    local toFav, toUnfav = {}, {}
    for uid, od in pairs(ores) do
        if typeof(od) == "table" then
            local should = unfavoriteAll and false or AutoFavOre_Matches(od)
            if should and not od.Favorite then
                table.insert(toFav, uid)
            elseif not should and od.Favorite and unfavoriteAll then
                table.insert(toUnfav, uid)
            end
        end
    end

    local toToggle = {}
    for _, uid in ipairs(toFav)   do table.insert(toToggle, uid) end
    for _, uid in ipairs(toUnfav) do table.insert(toToggle, uid) end

    if #toToggle == 0 then
        AutoFavOre_SetStatus("Status: tidak ada yang perlu diubah")
        AutoFavOreRuntime.IsBusy = false
        return
    end

    AutoFavOre_SetStatus(string.format("Status: memproses %d ore...", #toToggle))
    local bs = math.max(1, AutoFavOreSettings.BatchSize)
    local bd = AutoFavOreSettings.BatchDelay
    local failed, bn = {}, 0

    for i = 1, #toToggle, bs do
        bn = bn + 1
        local batch = {}
        for j = i, math.min(i + bs - 1, #toToggle) do
            table.insert(batch, toToggle[j])
        end
        AutoFavOre_SetStatus(string.format("Status: batch %d — %d / %d selesai",
            bn, math.min(i + bs - 1, #toToggle), #toToggle))
        local res = AutoFavOre_FireBatch(batch)
        for uid, r in pairs(res) do
            if not r.ok or r.res == false then table.insert(failed, uid) end
        end
        task.wait(bd)
    end

    if AutoFavOreSettings.RetryFailed and #failed > 0 then
        AutoFavOre_SetStatus(string.format("Status: mencoba ulang %d yang gagal...", #failed))
        task.wait(AutoFavOreSettings.RetryDelay)
        for _, uid in ipairs(failed) do
            pcall(function() AutoFavOreRuntime.FavRemote:InvokeServer(uid) end)
            task.wait(0.05)
        end
    end

    local msg = string.format("%d diubah", #toToggle - #failed)
    if #failed > 0 then msg = msg .. string.format(", %d gagal", #failed) end
    AutoFavOre_SetStatus("Status: selesai — " .. msg)
    Notify({ Title = "Favorit Ore Otomatis", Message = msg,
        Type = #failed > 0 and "warning" or "success", Duration = 4 })
    AutoFavOreRuntime.IsBusy = false
end

task.defer(AutoFavOre_Init)

local _Players_H, _RunService_H, _RS_H, _LocalPlayer_H
local _FriendGiverESP
local _FG_StartLoop
local _FG_StopLoop
do
_Players_H     = game:GetService("Players")
_RunService_H  = game:GetService("RunService")
_RS_H          = game:GetService("ReplicatedStorage")
_LocalPlayer_H = _Players_H.LocalPlayer

local _HCfg = {
    INTERACT_DISTANCE   = 25,
    RATE_LIMIT          = 0.55,
    ESP_ENABLED         = false,
    TREATER_ESP_ENABLED = false,
    AUTO_ENABLED        = false,
    COLOR_NORMAL        = Color3.fromRGB(255, 140, 40),
    COLOR_MY_TARGET     = Color3.fromRGB(90,  230, 110),
    COLOR_MY_TREATER    = Color3.fromRGB(170, 100, 255),
    BILLBOARD_DIST      = 5000,
    BILLBOARD_SIZE      = UDim2.new(0, 185, 0, 62),
    STUDS_OFFSET        = Vector3.new(0, 4.5, 0),
    HL_FILL_ALPHA       = 0.45,
    HL_OUTLINE_ALPHA    = 0.25,
}

local _HEsp              = {}
local _HTreaterEsp       = {}
local _HHeartbeat        = nil
local _HConns            = {}
local _HThrottle         = 0
local _HKnownTreaters    = {}

local function _H_getHandle(p)
    local c = p.Character
    if c then
        local t = c:FindFirstChild("Trick or Treat")
        if t then
            local hdl = t:FindFirstChild("Handle")
            if hdl then return hdl end
        end
    end
    local bp = p:FindFirstChildOfClass("Backpack")
    if bp then
        local t = bp:FindFirstChild("Trick or Treat")
        if t then
            local hdl = t:FindFirstChild("Handle")
            if hdl then return hdl end
        end
    end
    return nil
end

local function _H_getRootPos(p)
    local c = p.Character
    if not c then return nil end
    local h = c:FindFirstChild("HumanoidRootPart")
    return h and h.Position or nil
end

local function _H_distTo(p)
    local my = _H_getRootPos(_LocalPlayer_H)
    local th = _H_getRootPos(p)
    if not my or not th then return math.huge end
    return (my - th).Magnitude
end

local function _H_makeBillboard(hrp, name, color, tag)
    local bb = Instance.new("BillboardGui")
    bb.Name        = name
    bb.Size        = _HCfg.BILLBOARD_SIZE
    bb.StudsOffset = _HCfg.STUDS_OFFSET
    bb.AlwaysOnTop = true
    bb.MaxDistance = _HCfg.BILLBOARD_DIST
    bb.Adornee     = hrp
    bb.Parent      = hrp

    local bg = Instance.new("Frame", bb)
    bg.Name                   = "BG"
    bg.Size                   = UDim2.new(1, 0, 1, 0)
    bg.Position               = UDim2.new(0, 0, 0, 0)
    bg.BackgroundColor3       = Color3.fromRGB(0, 0, 0)
    bg.BackgroundTransparency = 0.42
    bg.BorderSizePixel        = 0
    bg.ZIndex                 = 0
    local bgCorner = Instance.new("UICorner", bg)
    bgCorner.CornerRadius     = UDim.new(0, 6)
    local bgStroke = Instance.new("UIStroke", bg)
    bgStroke.Color            = color
    bgStroke.Thickness        = 1.5
    bgStroke.Transparency     = 0.25

    local nl = Instance.new("TextLabel", bb)
    nl.Name                   = "NL"
    nl.Size                   = UDim2.new(1, 0, 0, 18)
    nl.Position               = UDim2.new(0, 0, 0, 2)
    nl.BackgroundTransparency = 1
    nl.TextColor3             = color
    nl.TextStrokeTransparency = 0.30
    nl.TextStrokeColor3       = Color3.new(0, 0, 0)
    nl.Font                   = Enum.Font.GothamBold
    nl.TextSize               = 12
    nl.TextScaled             = false
    nl.ZIndex                 = 2
    nl.Text                   = ""

    local tl = Instance.new("TextLabel", bb)
    tl.Name                   = "TL"
    tl.Size                   = UDim2.new(1, 0, 0, 18)
    tl.Position               = UDim2.new(0, 0, 0, 22)
    tl.BackgroundTransparency = 1
    tl.TextColor3             = color
    tl.TextStrokeTransparency = 0.40
    tl.TextStrokeColor3       = Color3.new(0, 0, 0)
    tl.Font                   = Enum.Font.GothamBold
    tl.TextSize               = 12
    tl.TextScaled             = false
    tl.ZIndex                 = 2
    tl.Text                   = tag

    local dl = Instance.new("TextLabel", bb)
    dl.Name                   = "DL"
    dl.Size                   = UDim2.new(1, 0, 0, 18)
    dl.Position               = UDim2.new(0, 0, 0, 42)
    dl.BackgroundTransparency = 1
    dl.TextColor3             = color
    dl.TextStrokeTransparency = 0.45
    dl.TextStrokeColor3       = Color3.new(0, 0, 0)
    dl.Font                   = Enum.Font.GothamBold
    dl.TextSize               = 12
    dl.TextScaled             = false
    dl.ZIndex                 = 2
    dl.Text                   = ""

    return bb
end

local function _H_makeHighlight(char, color)
    local hl = Instance.new("Highlight")
    hl.DepthMode           = Enum.HighlightDepthMode.AlwaysOnTop
    hl.FillColor           = color
    hl.OutlineColor        = color
    hl.FillTransparency    = _HCfg.HL_FILL_ALPHA
    hl.OutlineTransparency = _HCfg.HL_OUTLINE_ALPHA
    hl.Adornee             = char
    hl.Parent              = char
    return hl
end

local function _H_destroyObj(tbl, p)
    local obj = tbl[p]
    if not obj then return end
    for _, c in ipairs(obj.conns or {}) do pcall(function() c:Disconnect() end) end
    if obj.hl and obj.hl.Parent then pcall(function() obj.hl:Destroy() end) end
    if obj.bb and obj.bb.Parent then pcall(function() obj.bb:Destroy() end) end
    tbl[p] = nil
end

local function _H_removeESP(p)        _H_destroyObj(_HEsp, p) end
local function _H_removeTreaterESP(p) _H_destroyObj(_HTreaterEsp, p) end

local function _H_addESP(p, color, tag)
    if p == _LocalPlayer_H then return end
    if _HEsp[p] then return end
    local c   = p.Character
    if not c  then return end
    local hrp = c:FindFirstChild("HumanoidRootPart")
    if not hrp then return end

    local hl    = _H_makeHighlight(c, color)
    local bb    = _H_makeBillboard(hrp, "ToT_BB", color, tag)
    local conns = {}
    table.insert(conns, p.CharacterRemoving:Connect(function() _H_removeESP(p) end))
    table.insert(conns, p.CharacterAdded:Connect(function()   _H_removeESP(p) end))
    _HEsp[p] = { hl = hl, bb = bb, conns = conns }
end

local function _H_addTreaterESP(p)
    if p == _LocalPlayer_H then return end
    if _HTreaterEsp[p] then return end
    local c   = p.Character
    if not c  then return end
    local hrp = c:FindFirstChild("HumanoidRootPart")
    if not hrp then return end

    local color = _HCfg.COLOR_MY_TREATER
    local hl    = _H_makeHighlight(c, color)
    local bb    = _H_makeBillboard(hrp, "ToT_Treater_BB", color, "Candy Giver")
    local conns = {}
    table.insert(conns, p.CharacterRemoving:Connect(function() _H_removeTreaterESP(p) end))
    table.insert(conns, p.CharacterAdded:Connect(function()   _H_removeTreaterESP(p) end))
    _HTreaterEsp[p] = { hl = hl, bb = bb, conns = conns }
end

local function _H_updateESP(p, obj, color, tag)
    if not obj then return end
    if obj.hl and obj.hl.Parent then
        obj.hl.FillColor           = color
        obj.hl.OutlineColor        = color
        obj.hl.FillTransparency    = _HCfg.HL_FILL_ALPHA
        obj.hl.OutlineTransparency = _HCfg.HL_OUTLINE_ALPHA
    end
    if not (obj.bb and obj.bb.Parent) then return end
    local nl  = obj.bb:FindFirstChild("NL")
    local tl  = obj.bb:FindFirstChild("TL")
    local dl  = obj.bb:FindFirstChild("DL")
    local dist = _H_distTo(p)
    if nl then
        nl.TextColor3 = color
        nl.Text       = p.DisplayName .. " @" .. p.Name
    end
    if tl then
        tl.TextColor3 = color
        tl.Font       = Enum.Font.GothamBold
        tl.Text       = tag
    end
    if dl then
        dl.TextColor3 = color
        dl.Font       = Enum.Font.GothamBold
        dl.Text       = dist == math.huge
            and "? studs"
            or  string.format("%.1f studs", dist)
    end
    local bgFrame  = obj.bb and obj.bb:FindFirstChild("BG")
    local bgStroke = bgFrame and bgFrame:FindFirstChildOfClass("UIStroke")
    if bgStroke then bgStroke.Color = color end
end

local function _H_getMyHandle()
    local char = _LocalPlayer_H.Character
    if char then
        local tool = char:FindFirstChild("Trick or Treat")
        if tool then
            local hdl = tool:FindFirstChild("Handle")
            if hdl then return hdl end
        end
    end
    local bp = _LocalPlayer_H:FindFirstChildOfClass("Backpack")
    if bp then
        local tool = bp:FindFirstChild("Trick or Treat")
        if tool then
            local hdl = tool:FindFirstChild("Handle")
            if hdl then return hdl end
        end
    end
    return nil
end

local function _H_getTargetLabelText()
    local pg = _LocalPlayer_H:FindFirstChildOfClass("PlayerGui")
    if not pg then return "" end
    local tot = pg:FindFirstChild("TrickOrTreatTool")
    local holder = tot and tot:FindFirstChild("Holder")
    local tl = holder and holder:FindFirstChild("TargetLabel")
    if tl and tl:IsA("TextLabel") then
        return tl.Text or ""
    end
    return ""
end

local function _H_findMyTarget()
    local txt = _H_getTargetLabelText()

    if txt == "" or string.find(string.lower(txt), "no target") then
        return nil
    end

    local username = string.match(txt, "@([%w_]+)")
    if username then
        local found = _Players_H:FindFirstChild(username)
        if found and found ~= _LocalPlayer_H then return found end
        local low = string.lower(username)
        for _, p in ipairs(_Players_H:GetPlayers()) do
            if p ~= _LocalPlayer_H and string.lower(p.Name) == low then
                return p
            end
        end
    end

    local display = string.match(txt, "<b>(.-)%s*</b>")
    if display then
        local low = string.lower(display)
        for _, p in ipairs(_Players_H:GetPlayers()) do
            if p ~= _LocalPlayer_H then
                if string.lower(p.DisplayName) == low or string.lower(p.Name) == low then
                    return p
                end
            end
        end
    end

    return nil
end

local function _H_findMyTreaters()
    local list = {}
    local seen = {}
    local myId = _LocalPlayer_H.UserId

    local function addIfNew(p)
        if not p or p == _LocalPlayer_H or seen[p] then return end
        seen[p] = true
        table.insert(list, p)
    end

    local rawGiver = _LocalPlayer_H:GetAttribute("ToTGiver")
    local giverUid = tonumber(tostring(rawGiver or ""))
    if giverUid and giverUid ~= 0 and giverUid ~= myId then
        for _, p in ipairs(_Players_H:GetPlayers()) do
            if p.UserId == giverUid then addIfNew(p) break end
        end
    end

    local myHdl = _H_getMyHandle()
    if myHdl then
        local tid = myHdl:GetAttribute("TreaterId")
        if typeof(tid) == "number" and tid ~= 0 and tid ~= myId then
            for _, p in ipairs(_Players_H:GetPlayers()) do
                if p.UserId == tid then addIfNew(p) break end
            end
        end
        local tidList = myHdl:GetAttribute("TreaterIds")
        if type(tidList) == "table" then
            for _, uid in ipairs(tidList) do
                for _, p in ipairs(_Players_H:GetPlayers()) do
                    if p.UserId == uid then addIfNew(p) end
                end
            end
        end
    end

    for _, p in ipairs(_Players_H:GetPlayers()) do
        if p == _LocalPlayer_H then continue end
        local hdl = _H_getHandle(p)
        if not hdl then continue end
        local tid = hdl:GetAttribute("TreaterId")
        local gid = hdl:GetAttribute("GiverId")
        if (typeof(tid) == "number" and tid == myId)
        or (typeof(gid) == "number" and gid == myId) then
            addIfNew(p)
        end
    end

    return list
end

local function _H_checkNewTreaters(treaters)
    if not _HCfg.TREATER_ESP_ENABLED then return end
    local currentSet = {}
    for _, p in ipairs(treaters) do currentSet[p] = true end
    for _, p in ipairs(treaters) do
        if not _HKnownTreaters[p] then
            _HKnownTreaters[p] = true
            local dist = _H_distTo(p)
            local distStr = (dist == math.huge) and "? studs" or string.format("%.0f studs", dist)
            Notify({
                Title   = "Trick or Treater",
                Message = string.format("%s (@%s) lagi nyariin kamu [%s]",
                    p.DisplayName, p.Name, distStr),
                Type     = "info",
                Duration = 10,
            })
        end
    end
    for p in pairs(_HKnownTreaters) do
        if not currentSet[p] then
            _HKnownTreaters[p] = nil
        end
    end
end

local function _H_onHeartbeat(dt)
    _HThrottle = _HThrottle + dt

    if _HThrottle >= 0.033 then
        _HThrottle = 0

        local targetPlayer = _H_findMyTarget()

        local rawTreaters = _HCfg.TREATER_ESP_ENABLED and _H_findMyTreaters() or {}
        local treaters = {}
        for _, p in ipairs(rawTreaters) do
            if p ~= targetPlayer then
                table.insert(treaters, p)
            end
        end

        local treaterSet = {}
        for _, p in ipairs(treaters) do treaterSet[p] = true end

        for p in pairs(_HEsp)        do if p ~= targetPlayer then _H_removeESP(p)        end end
        for p in pairs(_HTreaterEsp) do if not treaterSet[p] or p == targetPlayer then _H_removeTreaterESP(p) end end

        if _HCfg.ESP_ENABLED and targetPlayer then
            if not _HEsp[targetPlayer] then
                _H_addESP(targetPlayer, _HCfg.COLOR_MY_TREATER, "Candy Giver")
            end
            local obj = _HEsp[targetPlayer]
            _H_updateESP(targetPlayer, obj, _HCfg.COLOR_MY_TREATER, "Candy Giver")
        end

        if _HCfg.TREATER_ESP_ENABLED then
            for _, p in ipairs(treaters) do
                if p == targetPlayer then continue end
                if not _HTreaterEsp[p] then _H_addTreaterESP(p) end
                local obj = _HTreaterEsp[p]
                _H_updateESP(p, obj, _HCfg.COLOR_MY_TARGET, "Trick or Treater")
            end
        end
        _H_checkNewTreaters(treaters)
    end
end

table.insert(_HConns, _Players_H.PlayerRemoving:Connect(function(p)
    _H_removeESP(p)
    _H_removeTreaterESP(p)
end))
table.insert(_HConns, _Players_H.PlayerAdded:Connect(function(p)
    p.CharacterRemoving:Connect(function()
        _H_removeESP(p)
        _H_removeTreaterESP(p)
    end)
end))
for _, p in ipairs(_Players_H:GetPlayers()) do
    if p ~= _LocalPlayer_H then
        p.CharacterRemoving:Connect(function()
            _H_removeESP(p)
            _H_removeTreaterESP(p)
        end)
    end
end
_HHeartbeat = _RunService_H.Heartbeat:Connect(_H_onHeartbeat)

 _FriendGiverESP = {
    Enabled     = false,
    Target      = nil,
    ESPObj      = nil,
}
local COLOR_FRIEND_GIVER = Color3.fromRGB(255, 175, 0)

local function _FG_FindGiverOf(friend)
    if not friend or friend == _LocalPlayer_H then return nil end
    local friendId = friend.UserId

    local raw = friend:GetAttribute("ToTGiver")
    local gid = tonumber(tostring(raw or ""))
    if gid and gid ~= 0 and gid ~= friendId then
        for _, p in ipairs(_Players_H:GetPlayers()) do
            if p.UserId == gid then return p end
        end
    end

    for _, p in ipairs(_Players_H:GetPlayers()) do
        if p == _LocalPlayer_H or p == friend then continue end
        local hdl = _H_getHandle(p)
        if not hdl then continue end
        local tid = hdl:GetAttribute("TreaterId")
        local gv  = hdl:GetAttribute("GiverId")
        if (typeof(tid) == "number" and tid == friendId)
        or (typeof(gv)  == "number" and gv  == friendId) then
            return p
        end
    end

    local fHdl = _H_getHandle(friend)
    if fHdl then
        local fGiverId = fHdl:GetAttribute("GiverId")
        if typeof(fGiverId) == "number" and fGiverId ~= 0 and fGiverId ~= friendId then
            for _, p in ipairs(_Players_H:GetPlayers()) do
                if p.UserId == fGiverId then return p end
            end
        end
    end

    return nil
end

local function _FG_MakeBillboard(hrp, name, tag)
    local bb = Instance.new("BillboardGui")
    bb.Name        = name
    bb.Size        = UDim2.new(0, 200, 0, 68)
    bb.StudsOffset = Vector3.new(0, 5.5, 0)
    bb.AlwaysOnTop = true
    bb.MaxDistance = 5000
    bb.Adornee     = hrp
    bb.Parent      = hrp

    local bg = Instance.new("Frame", bb)
    bg.Size                   = UDim2.new(1, 0, 1, 0)
    bg.BackgroundColor3       = Color3.fromRGB(0, 0, 0)
    bg.BackgroundTransparency = 0.38
    bg.BorderSizePixel        = 0
    bg.ZIndex                 = 0
    local bgCorner = Instance.new("UICorner", bg)
    bgCorner.CornerRadius = UDim.new(0, 6)
    local bgStroke = Instance.new("UIStroke", bg)
    bgStroke.Color       = COLOR_FRIEND_GIVER
    bgStroke.Thickness   = 2
    bgStroke.Transparency = 0.1

    local line1 = Instance.new("TextLabel", bb)
    line1.Name = "L1"
    line1.Size = UDim2.new(1, 0, 0, 18)
    line1.Position = UDim2.new(0, 0, 0, 2)
    line1.BackgroundTransparency = 1
    line1.TextColor3 = COLOR_FRIEND_GIVER
    line1.TextStrokeTransparency = 0.25
    line1.TextStrokeColor3 = Color3.new(0, 0, 0)
    line1.Font = Enum.Font.GothamBold
    line1.TextSize = 12
    line1.ZIndex = 2
    line1.Text = ""

    local line2 = Instance.new("TextLabel", bb)
    line2.Name = "L2"
    line2.Size = UDim2.new(1, 0, 0, 18)
    line2.Position = UDim2.new(0, 0, 0, 22)
    line2.BackgroundTransparency = 1
    line2.TextColor3 = COLOR_FRIEND_GIVER
    line2.TextStrokeTransparency = 0.30
    line2.TextStrokeColor3 = Color3.new(0, 0, 0)
    line2.Font = Enum.Font.GothamBold
    line2.TextSize = 12
    line2.ZIndex = 2
    line2.Text = tag

    local line3 = Instance.new("TextLabel", bb)
    line3.Name = "L3"
    line3.Size = UDim2.new(1, 0, 0, 18)
    line3.Position = UDim2.new(0, 0, 0, 44)
    line3.BackgroundTransparency = 1
    line3.TextColor3 = COLOR_FRIEND_GIVER
    line3.TextStrokeTransparency = 0.40
    line3.TextStrokeColor3 = Color3.new(0, 0, 0)
    line3.Font = Enum.Font.GothamBold
    line3.TextSize = 12
    line3.ZIndex = 2
    line3.Text = ""

    return bb
end

local function _FG_DestroyESP()
    local obj = _FriendGiverESP.ESPObj
    if not obj then return end
    for _, c in ipairs(obj.conns or {}) do pcall(function() c:Disconnect() end) end
    if obj.hl and obj.hl.Parent then pcall(function() obj.hl:Destroy() end) end
    if obj.bb and obj.bb.Parent then pcall(function() obj.bb:Destroy() end) end
    _FriendGiverESP.ESPObj = nil
end

local function _FG_AddESP(giver, friendName)
    _FG_DestroyESP()
    local c   = giver.Character if not c then return end
    local hrp = c:FindFirstChild("HumanoidRootPart") if not hrp then return end

    local hl = Instance.new("Highlight")
    hl.FillColor           = COLOR_FRIEND_GIVER
    hl.OutlineColor        = COLOR_FRIEND_GIVER
    hl.FillTransparency    = 0.30
    hl.OutlineTransparency = 0.05
    hl.DepthMode           = Enum.HighlightDepthMode.AlwaysOnTop
    hl.Adornee             = c
    hl.Parent              = c

    local tag = string.format("Candy Giver %s", friendName)
    local bb  = _FG_MakeBillboard(hrp, "FG_BB", tag)

    local conns = {}
    table.insert(conns, giver.CharacterRemoving:Connect(function() _FG_DestroyESP() end))
    table.insert(conns, giver.CharacterAdded:Connect(function()   _FG_DestroyESP() end))

    _FriendGiverESP.ESPObj = { hl = hl, bb = bb, conns = conns }
end

local function _FG_UpdateESP(giver, friendName)
    local obj = _FriendGiverESP.ESPObj
    if not obj then return end
    if not (obj.bb and obj.bb.Parent) then return end
    local l1 = obj.bb:FindFirstChild("L1")
    local l3 = obj.bb:FindFirstChild("L3")
    if l1 then l1.Text = giver.DisplayName .. " @" .. giver.Name end
    if l3 then
        local my = Utils.GetCharacterPosition()
        local gc = giver.Character
        local gh = gc and gc:FindFirstChild("HumanoidRootPart")
        local dist = gh and math.floor((gh.Position - my).Magnitude) or "?"
        l3.Text = tostring(dist) .. " studs"
    end
end

local _FG_LastGiver = nil
local _FG_HBConn    = nil

_FG_StartLoop = function()
    if _FG_HBConn then return end
    _FG_HBConn = RunService.Heartbeat:Connect(function()
        if not _FriendGiverESP.Enabled or not _FriendGiverESP.Target then
            _FG_DestroyESP()
            _FG_LastGiver = nil
            return
        end
        local friend = _FriendGiverESP.Target
        if not friend.Parent then return end
        local giver = _FG_FindGiverOf(friend)
        local fname = friend.DisplayName .. " @" .. friend.Name

        if giver ~= _FG_LastGiver then
            _FG_DestroyESP()
            _FG_LastGiver = giver
            if giver then _FG_AddESP(giver, fname) end
        elseif giver then
            _FG_UpdateESP(giver, fname)
        end
    end)
end

_FG_StopLoop = function()
    if _FG_HBConn then
        _FG_HBConn:Disconnect()
        _FG_HBConn = nil
    end
    _FG_DestroyESP()
    _FG_LastGiver = nil
end

local _HAutoGiveEnabled    = false
local _HAutoGiveThread     = nil
local _CANDY_INTERACT_WAIT = 0.8
local _CANDY_CYCLE_DELAY   = 3.0
local _CANDY_PICK_CHOICE   = 0

local function _H_getToTEvent()
    local gre = _RS_H:FindFirstChild("GameRemoteEvents")
    if not gre then gre = _RS_H:WaitForChild("GameRemoteEvents", 3) end
    return gre and gre:FindFirstChild("TrickOrTreatEvent")
end

local _CANDY_RADIUS        = 20

local function _H_findTreaterUid()
    local treaters = _H_findMyTreaters()
    for _, p in ipairs(treaters) do
        local dist = _H_distTo(p)
        if dist <= _CANDY_RADIUS then
            local c = p.Character
            if c and c:FindFirstChild("Trick or Treat") then
                return p.UserId
            end
        end
    end
    return nil
end

local function _H_giveCandyToUid(uid)
    if not uid or uid == 0 or uid == _LocalPlayer_H.UserId then return false end
    local ev = _H_getToTEvent()
    if not ev then return false end
    local ok1 = pcall(function() ev:FireServer("interact", uid) end)
    task.wait(_CANDY_INTERACT_WAIT)
    local ok2 = pcall(function() ev:FireServer("pick", uid, _CANDY_PICK_CHOICE) end)
    return ok1 and ok2
end

local function _H_startAutoGive()
    if _HAutoGiveThread then return end
    _HAutoGiveThread = task.spawn(function()
        while _HAutoGiveEnabled do
            local uid = _H_findTreaterUid()
            if uid then
                _H_giveCandyToUid(uid)
            end
            task.wait(_CANDY_CYCLE_DELAY)
        end
        _HAutoGiveThread = nil
    end)
end

local function _H_stopAutoGive()
    _HAutoGiveEnabled = false
    if _HAutoGiveThread then
        pcall(task.cancel, _HAutoGiveThread)
        _HAutoGiveThread = nil
    end
end

local _HSJ = {
    Enabled        = false,
    Mode           = "Skip",
    TargetMode     = "MyTarget",
    SkipThread     = nil,
    WalkThread     = nil,
    AutoWalk       = false,
    AutoWalkThread = nil,
    Reach          = 8,
    SkipInterval   = 5,
    WalkInterval   = 1.0,
    AutoWalkSpeed  = 24,
    LastTargetCF   = nil,
    StuckCount     = 0,
    LastWalkWarn   = 0,
    ReturnPoint    = nil,
    ReturnToStart  = true,
    ToTTimeout     = 30,
    ReturnReach    = 6,
}

local function _H_SJ_getHRP()
    local c = _LocalPlayer_H.Character
    return c and c:FindFirstChild("HumanoidRootPart")
end

local function _H_SJ_getHum()
    local c = _LocalPlayer_H.Character
    return c and c:FindFirstChildOfClass("Humanoid")
end

local function _H_SJ_getFn()
    local fns = _RS_H:FindFirstChild("GameRemoteFunctions")
    if not fns then fns = _RS_H:WaitForChild("GameRemoteFunctions", 3) end
    return fns and fns:FindFirstChild("TrickOrTreatFunction")
end

local function _H_SJ_findTarget()
    return _H_findMyTarget()
end

local function _H_SJ_walkToDest(destGetter, abortFn)
    if not destGetter then return end

    local REACH          = _HSJ.Reach or 8
    local TIMEOUT        = _HSJ.WalkTimeout or 30.0
    local WP_TIMEOUT     = 5.0
    local COMPUTE_LIMIT  = 0.6
    local DRIFT_DIST     = 15
    local STUCK_WINDOW   = 1.2
    local STUCK_MIN_MOVE = 1.5
    local MAX_UNSTICK    = 3

    local start       = os.clock()
    local lastCompute = 0

    local path = PathfindingService:CreatePath({
        AgentRadius     = 3,
        AgentHeight     = 5,
        AgentCanJump    = true,
        AgentCanClimb   = false,
        AgentJumpHeight = 8,
        AgentMaxSlope   = 45,
        WaypointSpacing = 4,
        Costs           = { Water = 20 },
    })

    local function shouldAbort()
        if not (_HSJ.AutoWalk or (_HSJ.Enabled and _HSJ.Mode == "Join")) then return true end
        if abortFn and abortFn() then return true end
        return false
    end

    local function getDest()
        local p = destGetter()
        if typeof(p) == "CFrame" then return p.Position end
        return p
    end

    local function stopMoving()
        local hum = _H_SJ_getHum()
        local hrp = _H_SJ_getHRP()
        if hum and hrp then pcall(function() hum:MoveTo(hrp.Position) end) end
    end

    local function reached()
        local hrp = _H_SJ_getHRP()
        local d   = getDest()
        return hrp and d and (hrp.Position - d).Magnitude <= REACH
    end

    if reached() then return end

    local rayParams = RaycastParams.new()
    rayParams.FilterType = Enum.RaycastFilterType.Exclude
    if _LocalPlayer_H.Character then
        rayParams.FilterDescendantsInstances = { _LocalPlayer_H.Character }
    end

    local function attemptUnstick(hrp, hum, towardPos)
        if not hrp or not hum or not hrp.Parent then return false end
        local dir = towardPos - hrp.Position
        if dir.Magnitude < 0.1 then return false end
        local flatDir = Vector3.new(dir.X, 0, dir.Z)
        if flatDir.Magnitude > 0.01 then flatDir = flatDir.Unit else flatDir = Vector3.zero end

        local obstacleHit = nil
        if flatDir.Magnitude > 0.01 then
            local hit = workspace:Raycast(hrp.Position, flatDir * 5, rayParams)
            if hit then obstacleHit = hit end
        end

        for _ = 1, 2 do
            pcall(function() hum:ChangeState(Enum.HumanoidStateType.Jumping) end)
            pcall(function() hum.Jump = true end)
            task.wait(0.15)
            if (hrp.Position - towardPos).Magnitude < (REACH or 8) then return true end
        end

        if flatDir.Magnitude > 0.01 then
            local side = Vector3.new(-flatDir.Z, 0, flatDir.X)
            if math.random() < 0.5 then side = -side end
            local sideTarget = hrp.Position + side * 5
            pcall(function() hum:MoveTo(sideTarget) end)
            task.wait(0.25)
            pcall(function() hum.Jump = true end)
            task.wait(0.15)
        end

        if obstacleHit and flatDir.Magnitude > 0.01 then
            local escDist = math.min(dir.Magnitude - 1, 5)
            if escDist > 1 then
                local target = hrp.Position + flatDir * escDist
                local floorHit = workspace:Raycast(target + Vector3.new(0, 5, 0),
                    Vector3.new(0, -20, 0), rayParams)
                if floorHit then
                    target = floorHit.Position + Vector3.new(0, 3, 0)
                end
                pcall(function()
                    hrp.CFrame = CFrame.new(target)
                    hrp.AssemblyLinearVelocity  = Vector3.zero
                    hrp.AssemblyAngularVelocity = Vector3.zero
                end)
                task.wait(0.15)
                return true
            end
        end

        return false
    end

    while not reached() do
        task.wait(0.1)
        if shouldAbort() then stopMoving() return end
        if os.clock() - start > TIMEOUT then stopMoving() return end

        local hrp  = _H_SJ_getHRP()
        local hum  = _H_SJ_getHum()
        local dest = getDest()
        if not hrp or not hum or not dest then stopMoving() return end

        local now = os.clock()
        if now - lastCompute < COMPUTE_LIMIT then
            pcall(function() hum:MoveTo(dest) end)
            task.wait(0.2)
            continue
        end
        lastCompute = now

        local ok = pcall(function() path:ComputeAsync(hrp.Position, dest) end)

        if not ok or path.Status ~= Enum.PathStatus.Success then
            pcall(function() hum:MoveTo(dest) end)
            task.wait(0.35)
            continue
        end

        local waypoints   = path:GetWaypoints()
        local lastDest    = dest
        local pathBlocked = false
        local blockConn   = path.Blocked:Connect(function() pathBlocked = true end)
        local abandoned   = false

        for _, wp in ipairs(waypoints) do
            if shouldAbort() then abandoned = true break end
            if reached()       then abandoned = true break end
            if os.clock() - start > TIMEOUT then abandoned = true break end
            if pathBlocked     then abandoned = true break end

            hrp = _H_SJ_getHRP()
            hum = _H_SJ_getHum()
            if not hrp or not hum then abandoned = true break end

            local curDest = getDest()
            if curDest and (curDest - lastDest).Magnitude > DRIFT_DIST then
                abandoned = true break
            end

            if wp.Action == Enum.PathWaypointAction.Jump then
                pcall(function() hum:ChangeState(Enum.HumanoidStateType.Jumping) end)
                pcall(function() hum.Jump = true end)
                task.wait(0.05)
            end

            hum:MoveTo(wp.Position)

            local wpStart      = os.clock()
            local lastPos      = hrp.Position
            local lastCheck    = os.clock()
            local unstickCount = 0

            while true do
                task.wait(0.1)
                if shouldAbort() then abandoned = true break end
                if pathBlocked     then abandoned = true break end

                hrp = _H_SJ_getHRP()
                if not hrp then abandoned = true break end

                if (hrp.Position - wp.Position).Magnitude <= (REACH * 0.6) then break end
                if os.clock() - wpStart >= WP_TIMEOUT then break end

                if os.clock() - lastCheck >= STUCK_WINDOW then
                    local moved = (hrp.Position - lastPos).Magnitude
                    if moved < STUCK_MIN_MOVE then
                        unstickCount = unstickCount + 1
                        hum = _H_SJ_getHum()
                        if hum then
                            attemptUnstick(hrp, hum, wp.Position)
                        end
                        if unstickCount >= MAX_UNSTICK then
                            abandoned = true
                            break
                        end
                    else
                        unstickCount = 0
                    end
                    lastPos   = hrp.Position
                    lastCheck = os.clock()
                end
            end

            if abandoned then break end
        end

        if blockConn then blockConn:Disconnect() end
    end

    stopMoving()
end

local function _H_SJ_walkTo(target)
    if not target or not target.Parent then return end
    _H_SJ_walkToDest(function()
        if not target.Parent then return nil end
        local c = target.Character
        local h = c and c:FindFirstChild("HumanoidRootPart")
        return h and h.Position or nil
    end, function()
        if not target.Parent then return true end
        local c = target.Character
        if not c or not c:FindFirstChild("HumanoidRootPart") then return true end
        return false
    end)
end

local function _H_SJ_walkToPos(pos)
    if not pos then return end
    if typeof(pos) == "CFrame" then pos = pos.Position end
    _H_SJ_walkToDest(function() return pos end, nil)
end

local function _H_SJ_getState()
    local ok, rm = pcall(function()
        local RF = game:GetService("ReplicatedFirst")
        local mgr = RF:FindFirstChild("Manager")
        local mod = mgr and mgr:FindFirstChild("ReplicaManager")
        return mod and require(mod)
    end)
    if not ok or not rm then return nil end
    local ok2, tm = pcall(function()
        local RS = game:GetService("ReplicatedStorage")
        local cont = RS:FindFirstChild("Content")
        local mod2 = cont and cont:FindFirstChild("TrickOrTreat")
        return mod2 and require(mod2)
    end)
    if not ok2 or not tm then return nil end
    local ok3, data = pcall(function()
        return rm:GetPlayerData(game:GetService("Players").LocalPlayer)
    end)
    if not ok3 then return nil end
    local profile = data and data.ProfileReplica and data.ProfileReplica.Data
    return profile and tm.STATE_KEY and profile[tm.STATE_KEY]
end

local function _H_SJ_getStatusLabelText()
    local pg = _LocalPlayer_H:FindFirstChildOfClass("PlayerGui")
    if not pg then return "" end
    local totGui = pg:FindFirstChild("TrickOrTreatTool")
    if not totGui then return "" end
    local holder = totGui:FindFirstChild("Holder")
    if not holder then return "" end
    local sl = holder:FindFirstChild("StatusLabel")
    if sl and sl:IsA("TextLabel") then
        return sl.Text or ""
    end
    return ""
end

local function _H_SJ_isTargetAnotherServer()
    local txt = string.lower(_H_SJ_getStatusLabelText())
    return string.find(txt, "another server") ~= nil
        or string.find(txt, "different server") ~= nil
end

local function _H_SJ_hasTargetHere()
    if _H_SJ_isTargetAnotherServer() then return false end

    local myHdl = _H_getMyHandle()
    if not myHdl then return false end
    local giverId = myHdl:GetAttribute("GiverId")
    if not giverId or giverId == 0 then return false end
    local myId = _LocalPlayer_H.UserId
    if giverId == myId then return false end
    for _, p in ipairs(_Players_H:GetPlayers()) do
        if p.UserId == giverId then return true end
    end
    return false
end

local function _H_SJ_stopSkip()
    if _HSJ.SkipThread then
        pcall(task.cancel, _HSJ.SkipThread)
        _HSJ.SkipThread = nil
    end
end

local function _H_SJ_stopWalk()
    if _HSJ.WalkThread then
        pcall(task.cancel, _HSJ.WalkThread)
        _HSJ.WalkThread = nil
    end
    local hum = _H_SJ_getHum()
    local hrp = _H_SJ_getHRP()
    if hum and hrp then pcall(function() hum:MoveTo(hrp.Position) end) end
end

local function _H_SJ_stopAutoWalk()
    if _HSJ.AutoWalkThread then
        pcall(task.cancel, _HSJ.AutoWalkThread)
        _HSJ.AutoWalkThread = nil
    end
    local hum = _H_SJ_getHum()
    local hrp = _H_SJ_getHRP()
    if hum and hrp then pcall(function() hum:MoveTo(hrp.Position) end) end
end

local function _H_GetToTFromBP()
    local bp = _LocalPlayer_H:FindFirstChildOfClass("Backpack")
    return bp and bp:FindFirstChild("Trick or Treat")
end

local function _H_GetToTEquipped()
    local char = _LocalPlayer_H.Character
    return char and char:FindFirstChild("Trick or Treat")
end

local function _H_EquipToT()
    local hum = _H_SJ_getHum()
    if not hum then return end
    if _H_GetToTEquipped() then return end
    local t = _H_GetToTFromBP()
    if t then pcall(function() hum:EquipTool(t) end) end
end

local function _H_UnequipToT()
    local hum = _H_SJ_getHum()
    if hum and _H_GetToTEquipped() then
        pcall(function() hum:UnequipTools() end)
    end
end

local _HAutoHoldEnabled = false
local _HAutoHoldThread  = nil

local function _H_startAutoHold()
    if _HAutoHoldThread then return end
    _HAutoHoldThread = task.spawn(function()
        while _HAutoHoldEnabled do
            local char = _LocalPlayer_H.Character
            local hum  = char and char:FindFirstChildOfClass("Humanoid")
            if hum and hum.Health > 0 and not _H_GetToTEquipped() then
                _H_EquipToT()
            end
            task.wait(2)
        end
        _HAutoHoldThread = nil
    end)
end

local function _H_stopAutoHold()
    _HAutoHoldEnabled = false
    if _HAutoHoldThread then
        pcall(task.cancel, _HAutoHoldThread)
        _HAutoHoldThread = nil
    end
    _H_UnequipToT()
end

local function _H_FindCandyGiver()
    local treaters = _H_findMyTreaters()
    return treaters[1]
end

local function _H_SJ_GetAutoWalkTarget()
    local mode = _HSJ.TargetMode or "MyTarget"
    if mode == "FriendTarget" then
        local friend = _FriendGiverESP and _FriendGiverESP.Target
        if friend and friend.Parent then
            return _FG_FindGiverOf(friend)
        end
        return nil
    end
    return _H_findMyTarget()
end

local function _H_SJ_startAutoWalk()
    if _HSJ.AutoWalkThread then return end
    _HSJ.AutoWalkThread = task.spawn(function()
        while _HSJ.AutoWalk do
            task.wait(0.05)
            local target = _H_SJ_GetAutoWalkTarget()

            if target and target.Parent then
                local targetUid = target.UserId

                do
                    local myHum = _H_SJ_getHum()
                    local tc = target.Character
                    local th = tc and tc:FindFirstChild("HumanoidRootPart")
                    if myHum and th then
                        pcall(function() myHum:MoveTo(th.Position) end)
                    end
                end

                pcall(_H_SJ_walkTo, target)
                if not _HSJ.AutoWalk then break end

                local r  = _H_SJ_getHRP()
                local tc = target.Character
                local th = tc and tc:FindFirstChild("HumanoidRootPart")
                local reachedTarget = r and th and
                    (r.Position - th.Position).Magnitude <= _HSJ.Reach

                if reachedTarget then
                    local shouldInteract = (_HSJ.TargetMode == "MyTarget")
                    local done = false

                    if shouldInteract then
                        _H_EquipToT()
                        task.wait(0.5)

                        local t0        = os.clock()
                        local timeout   = _HSJ.ToTTimeout or 30
                        local nilStreak = 0

                        while os.clock() - t0 < timeout do
                            if not _HSJ.AutoWalk then break end

                            local stillTreater = false
                            for _, p in ipairs(_H_findMyTreaters()) do
                                if p.UserId == targetUid then stillTreater = true; break end
                            end

                            if not stillTreater then
                                nilStreak = nilStreak + 1
                                if nilStreak >= 3 then done = true; break end
                            else
                                nilStreak = 0
                                if _H_distTo(target) > (_HSJ.Reach * 3) then done = true; break end
                            end

                            task.wait(0.3)
                        end

                        _H_UnequipToT()
                    else
                        done = true
                    end

                    if _HSJ.AutoWalk
                        and _HSJ.ReturnToStart ~= false
                        and _HSJ.ReturnPoint
                    then
                        local hrpNow = _H_SJ_getHRP()
                        if hrpNow then
                            local homePos  = _HSJ.ReturnPoint.Position
                            local distHome = (hrpNow.Position - homePos).Magnitude
                            if distHome > (_HSJ.ReturnReach or 6) then
                                if Notify then
                                    Notify({ Title = "AutoWalk",
                                        Message = done and "Candy Received — balik ke titik yang di saved."
                                                       or  "Timeout — balik ke titik yang di saved.",
                                        Type = "info", Duration = 2 })
                                end
                                pcall(_H_SJ_walkToPos, homePos)
                            end
                        end
                    end
                end

                task.wait(0.5)
            else
                task.wait(1.0)
            end
        end

        _H_UnequipToT()
        _HSJ.AutoWalkThread = nil
    end)
end

local function _H_SJ_startSkip()
    _H_SJ_stopWalk()
    if _HSJ.SkipThread then return end
    _HSJ.SkipThread = task.spawn(function()
        while _HSJ.Enabled and _HSJ.Mode == "Skip" do
            local anotherServer = _H_SJ_isTargetAnotherServer()
            local notHere = not _H_SJ_hasTargetHere()

            if anotherServer or notHere then
                local fn = _H_SJ_getFn()
                if fn then
                    pcall(function() fn:InvokeServer("skip") end)
                    task.wait(1.5)
                end
            end

            task.wait(_HSJ.SkipInterval)
        end
        _HSJ.SkipThread = nil
    end)
end

local function _H_SJ_startJoin()
    _H_SJ_stopSkip()
    local fn = _H_SJ_getFn()
    if fn then pcall(function() fn:InvokeServer("join") end) end
    if _HSJ.WalkThread then pcall(task.cancel, _HSJ.WalkThread) end
    _HSJ.WalkThread = task.spawn(function()
        while _HSJ.Enabled and _HSJ.Mode == "Join" do
            local target = _H_SJ_findTarget()
            if target then pcall(_H_SJ_walkTo, target) end
            task.wait(_HSJ.WalkInterval)
        end
        _HSJ.WalkThread = nil
    end)
end

HalloweenESP = {
    SetESP           = function(v) _HCfg.ESP_ENABLED         = v end,
    SetTreaterESP    = function(v)
        _HCfg.TREATER_ESP_ENABLED = v
        if not v then _HKnownTreaters = {} end
    end,
    SetAuto          = function(v) _HCfg.AUTO_ENABLED        = v end,
    SetTargetColor   = function(c) _HCfg.COLOR_MY_TARGET     = c end,
    SetTreaterColor  = function(c) _HCfg.COLOR_MY_TREATER    = c end,
    SetAutoGive      = function(v)
        _HAutoGiveEnabled = v
        if v then _H_startAutoGive() else _H_stopAutoGive() end
    end,
    SetAutoHold      = function(v)
        _HAutoHoldEnabled = v and true or false
        if _HAutoHoldEnabled then _H_startAutoHold() else _H_stopAutoHold() end
    end,
    SetSkipJoin      = function(mode, enabled)
        _HSJ.Mode    = (mode == "Join") and "Join" or "Skip"
        _HSJ.Enabled = enabled and true or false
        _H_SJ_stopSkip()
        _H_SJ_stopWalk()
        if not _HSJ.Enabled then return end
        if _HSJ.Mode == "Skip" then _H_SJ_startSkip()
        else                        _H_SJ_startJoin() end
    end,
    SetAutoWalk      = function(v)
        _HSJ.AutoWalk = v and true or false
        if _HSJ.AutoWalk then
            _H_SJ_startAutoWalk()
        else
            _H_SJ_stopAutoWalk()
        end
    end,
    SetReturnToStart = function(v)
        _HSJ.ReturnToStart = v and true or false
    end,
    SetReturnPoint = function(cf)
        if typeof(cf) == "CFrame" then
            _HSJ.ReturnPoint = cf
        elseif typeof(cf) == "Vector3" then
            _HSJ.ReturnPoint = CFrame.new(cf)
        end
    end,
    ClearReturnPoint = function()
        _HSJ.ReturnPoint = nil
    end,
    GetReturnPointPos = function()
        return _HSJ.ReturnPoint and _HSJ.ReturnPoint.Position or nil
    end,
    SetAutoWalkTarget = function(mode)
        _HSJ.TargetMode = mode or "Treater"
    end,
    Stop = function()
        _HCfg.ESP_ENABLED         = false
        _HCfg.TREATER_ESP_ENABLED = false
        _HCfg.AUTO_ENABLED        = false
        _HSJ.Enabled  = false
        _HSJ.AutoWalk = false
        _H_stopAutoGive()
        _H_stopAutoHold()
        _H_SJ_stopSkip()
        _H_SJ_stopWalk()
        _H_SJ_stopAutoWalk()
        _HKnownTreaters = {}
        if _HHeartbeat then _HHeartbeat:Disconnect() _HHeartbeat = nil end
        for _, c in ipairs(_HConns) do pcall(function() c:Disconnect() end) end
        for p in pairs(_HEsp)       do _H_removeESP(p) end
        for p in pairs(_HTreaterEsp) do _H_removeTreaterESP(p) end
    end,
}
end

Delirium:Boot("Indo Voice", function(Window)
ActiveWindow = Window

local TabMain      = Window:CreateTab({ name = "Main",       columns = 2, icon = "lucide:home" })
local TabFishing   = Window:CreateTab({ name = "Fishing",    columns = 2, icon = "lucide:fish" })
local TabMining    = Window:CreateTab({ name = "Mining",     columns = 2, icon = "lucide:pickaxe" })
local TabRefining  = Window:CreateTab({ name = "Refining",   columns = 2, icon = "lucide:flame" })
local TabSell      = Window:CreateTab({ name = "Auto Sell",  columns = 2, icon = "lucide:shopping-cart" })
local TabFavorites = Window:CreateTab({ name = "Favorites",  columns = 2, icon = "lucide:star" })
local TabMisc      = Window:CreateTab({ name = "Misc",       columns = 2, icon = "lucide:settings" })
Window:CreateTabDivider("Event")
local TabHalloween = Window:CreateTab({ name = "Halloween",  columns = 2, icon = "lucide:ghost" })


local MainStatsFishLabel
local MainStatsOreLabel
local MainStatsRefineLabel

local NoclipToggle
local function AutoNoclip_Sync()
    local should = Settings.Fishing.Enabled or Settings.Mining.Enabled
    MiscSystem.SetNoclip(should)
    if NoclipToggle then pcall(function() NoclipToggle:Set(should) end) end
end

local SecMainOverview = TabMain.Left:CreateSection({ name = "Live Overview" })
MainStatsFishLabel   = SecMainOverview:CreateLabel({ text = "Fish Caught: 0" })
MainStatsOreLabel    = SecMainOverview:CreateLabel({ text = "Ore Mined: 0" })
MainStatsRefineLabel = SecMainOverview:CreateLabel({ text = "Refined Claimed: 0" })

local SecMainClaim = TabMain.Left:CreateSection({ name = "Auto Claim" })

local IV_ClaimAll = SecMainClaim:CreateToggle({
    name = "Auto Claim Rewards", value = true,
    callback = function(v)
        ClaimSettings.AutoClaimDaily   = v
        ClaimSettings.AutoClaimSession = v
        UpdateClaimLoop()
    end,
})
SecMainClaim:CreateLabel({
    text = "Klaim hadiah harian dan hadiah sesi secara otomatis.",
})

local SecMainSocial = TabMain.Left:CreateSection({ name = "Social" })

local IV_AutoLikeLoop = SecMainSocial:CreateToggle({
    name = "Auto Love", value = false,
    callback = function(v)
        MiscSettings.AutoLikeLoop = v
        if v then MiscSystem.StartAutoLikeLoop() else MiscSystem.StopAutoLikeLoop() end
    end,
})

local SecMainAntiAFK = TabMain.Right:CreateSection({ name = "Anti AFK" })

local IV_AntiAFK = SecMainAntiAFK:CreateToggle({
    name = "Anti AFK", value = true,
    callback = function(v)
        if v then AntiAFK.Start() else AntiAFK.Stop() end
    end,
})
SecMainAntiAFK:CreateLabel({
    text = "Cegah teleport ke server AFK karena idle.",
})

local SecMainPerf = TabMain.Right:CreateSection({ name = "Performance" })

local IV_FPSBooster = SecMainPerf:CreateToggle({
    name = "FPS Booster", value = false,
    callback = function(v) MiscSystem.SetFPSBooster(v) end,
})
SecMainPerf:CreateLabel({
    text = "<b>FPS Booster</b>\nMatikan partikel, dan Lighting. Auto-restore saat dimatikan. ada bug, ESP jadi tidak nampil. <b>FIX SOON</b>",
})

local SecFishAutomation = TabFishing.Left:CreateSection({ name = "Automation" })

local IV_FishingEnabled = SecFishAutomation:CreateToggle({
    name = "Auto Fishing", value = false,
    callback = function(v)
        Settings.Fishing.Enabled = v
        Settings.Fishing.AutoEquipRod = true
        if v then FishingSystem.Start() else FishingSystem.Stop() end
    end,
})

local SecFishESP = TabFishing.Left:CreateSection({ name = "ESP" })

local IV_FishingESP = SecFishESP:CreateToggle({
    name = "Fishing Spot ESP", value = false,
    callback = function(v)
        HotspotSettings.FishingEnabled = v
        if v then HotspotESP.Start()
        else
            ClearDrawingsTable(HotspotRuntime.FishingDrawings)
            for _, z in ipairs(GetFishingZones()) do RemoveESPChams(z.instance) end
            if HotspotRuntime.Thread and not HotspotSettings.MiningEnabled then
                task.cancel(HotspotRuntime.Thread)
                HotspotRuntime.Thread = nil
            end
        end
    end,
})

local IV_FishingTracer = SecFishESP:CreateToggle({
    name = "Tracer Line", value = false,
    callback = function(v)
        HotspotSettings.FishingTracer = v
    end,
})

local IV_FishingOnlyHotspots = SecFishESP:CreateToggle({
    name = "Hotspots Only", value = false,
    callback = function(v)
        HotspotSettings.FishingOnlyHotspot = v
    end,
})

local SecFishConfig = TabFishing.Right:CreateSection({ name = "Configuration" })

local IV_FishingCastMethod = SecFishConfig:CreateDropdown({
    name = "Cast Method",
    options = { { Label = "Legit", Value = "Legit" }, { Label = "Blatant", Value = "Blatant" } },
    value = "Legit",
    callback = function(v) Settings.Fishing.CastMethod = v end,
})

local IV_FishingCatchMethod = SecFishConfig:CreateDropdown({
    name = "Catch Method",
    options = { { Label = "Legit", Value = "Legit" }, { Label = "Blatant", Value = "Blatant" } },
    value = "Legit",
    callback = function(v) Settings.Fishing.CatchMethod = v end,
})

local IV_FishingHoldDuration = SecFishConfig:CreateSlider({
    name = "Cast Hold", min = 0.1, max = 2.0, step = 0.1,
    value = Settings.Fishing.CastHoldDuration,
    callback = function(v) Settings.Fishing.CastHoldDuration = v end,
})

local IV_FishingCPS = SecFishConfig:CreateSlider({
    name = "Clicks Per Second", min = 1, max = 12, step = 1,
    value = Settings.Fishing.ClickSpeedCPS,
    callback = function(v)
        Settings.Fishing.ClickSpeedCPS = v
        Settings.Fishing.ClickInterval = 1 / math.max(v, 1)
    end,
})

SecFishConfig:CreateLabel({
    text = "<b>Informasi</b>\nSlider Tahan Cast memengaruhi kekuatan Cast Blatant — naikkan maksimal jika pakai Cast Blatant.",
})

FishingSystem.OnFishCaught = function(count)
    local txt = "Fish Caught: " .. tostring(count)
    if MainStatsFishLabel then pcall(function() MainStatsFishLabel:Set(txt) end) end
end

task.defer(AutoFavFish_Init)

local SecFavFish = TabFavorites.Left:CreateSection({ name = "Automatic Fish Favorites" })

AutoFavFishRuntime.StatusLabel = SecFavFish:CreateLabel({ text = "Status: idle" })

local IV_AutoFavMode = SecFavFish:CreateDropdown({
    name = "Mode",
    options = {
        { Label = "All Fish",     Value = "All" },
        { Label = "By Rarity",    Value = "By Rarity" },
        { Label = "By Price",     Value = "By Price" },
        { Label = "By Weight",    Value = "By Weight" },
    },
    value = "By Rarity",
    callback = function(v) AutoFavFishSettings.Mode = v end,
})

local IV_AutoFavMinRarity = SecFavFish:CreateDropdown({
    name = "Minimum Rarity",
    options = {"Common","Uncommon","Rare","Epic","Legend","Mythic","Ancient"},
    value = {"Ancient","Mythic","Legend","Epic","Rare","Uncommon","Common"},
    multiSelect = true,
    callback = function(v)
        AutoFavFishSettings.MinRarity = (type(v) == "table" and #v > 0) and v or {"Ancient","Mythic","Legend","Epic","Rare","Uncommon","Common"}
    end,
})

local IV_AutoFavMinWeight = SecFavFish:CreateSlider({
    name = "Minimum Weight ", min = 0, max = 500, step = 5,
    value = 50,
    callback = function(v) AutoFavFishSettings.MinWeight = v end,
})

SecFavFish:CreateButton({
    name = "Apply Now",
    callback = function() AutoFavFish.Run(false) end,
})
SecFavFish:CreateButton({
    name = "Unfavorite All Fish",
    callback = function() AutoFavFish.Run(true) end,
})

local SecFavOre = TabFavorites.Right:CreateSection({ name = "Automatic Ore Favorites" })

AutoFavOreRuntime.StatusLabel = SecFavOre:CreateLabel({ text = "Status: idle" })

local IV_AutoFavOreMode = SecFavOre:CreateDropdown({
    name = "Mode",
    options = {
        { Label = "All Ore",      Value = "All" },
        { Label = "By Rarity",    Value = "By Rarity" },
        { Label = "By Density",   Value = "By Density" },
    },
    value = "By Rarity",
    callback = function(v) AutoFavOreSettings.Mode = v end,
})

local IV_AutoFavOreMinRarity = SecFavOre:CreateDropdown({
    name = "Minimum Rarity",
    options = {"Common","Uncommon","Rare","Epic","Legend","Mythic","Ancient"},
    value = {"Ancient","Mythic","Legend","Epic","Rare","Uncommon","Common"},
    multiSelect = true,
    callback = function(v)
        AutoFavOreSettings.MinRarity = (type(v) == "table" and #v > 0) and v or {"Ancient","Mythic","Legend","Epic","Rare","Uncommon","Common"}
    end,
})

local IV_AutoFavOreMinDensity = SecFavOre:CreateSlider({
    name = "Minimum Density", min = 0, max = 500, step = 10,
    value = 50,
    callback = function(v) AutoFavOreSettings.MinDensity = v end,
})

SecFavOre:CreateButton({
    name = "Apply Now",
    callback = function() task.spawn(function() AutoFavOre.Run(false) end) end,
})
SecFavOre:CreateButton({
    name = "Unfavorite All Ore",
    callback = function() task.spawn(function() AutoFavOre.Run(true) end) end,
})

local SecMineAutomation = TabMining.Left:CreateSection({ name = "Automation" })

local IV_MiningEnabled = SecMineAutomation:CreateToggle({
    name = "Auto Mining", value = false,
    callback = function(v)
        Settings.Mining.Enabled = v
        if v then MiningSystem.Start() else MiningSystem.Stop() end
    end,
})

local IV_MiningAutoWalk = SecMineAutomation:CreateToggle({
    name = "Auto Walk to Ore", value = false,
    callback = function(v) Settings.Mining.AutoWalk = v end,
})

local SecMineESP = TabMining.Left:CreateSection({ name = "ESP" })

local IV_MiningESP = SecMineESP:CreateToggle({
    name = "Mining Stone ESP", value = false,
    callback = function(v)
        HotspotSettings.MiningEnabled = v
        HotspotSettings.MiningChams = v
        if v then HotspotESP.Start()
        else
            ClearDrawingsTable(HotspotRuntime.MiningDrawings)
            for _, s in ipairs(GetMiningStones()) do RemoveESPChams(s.instance) end
            if HotspotRuntime.Thread and not HotspotSettings.FishingEnabled then
                task.cancel(HotspotRuntime.Thread)
                HotspotRuntime.Thread = nil
            end
        end
    end,
})

local IV_MiningTracer = SecMineESP:CreateToggle({
    name = "Tracer Line", value = false,
    callback = function(v) HotspotSettings.MiningTracer = v end,
})

local IV_MiningOnlyHotspots = SecMineESP:CreateToggle({
    name = "Hotspot Ore Only", value = false,
    callback = function(v) HotspotSettings.MiningOnlyHotspot = v end,
})

local SecMineConfig = TabMining.Right:CreateSection({ name = "Configuration" })

local IV_MiningMethod = SecMineConfig:CreateDropdown({
    name = "Mining Method",
    options = { { Label = "Legit", Value = "Legit" }, { Label = "Blatant", Value = "Blatant" } },
    value = "Legit",
    callback = function(v) Settings.Mining.MineMethod = v end,
})

local IV_MiningFullyAuto = SecMineConfig:CreateToggle({
    name = "Under Stone OP", value = false,
    callback = function(v)
        Settings.Mining.FullyAuto = v
        if not v and Runtime.Mining.IsFloating then MiningSystem.DisableUndergroundFloat() end
        AutoNoclip_Sync()
    end,
})

local IV_MiningTargetFilter = SecMineConfig:CreateDropdown({
    name = "Stone Target",
    options = {
        { Label = "Hotspot Only", Value = "Hotspot Only" },
        { Label = "All Stones",   Value = "All Stones" },
    },
    value = "Hotspot Only",
    callback = function(v)
        Settings.Mining.TargetFilter = v
        Runtime.Mining.CurrentTargetStone = nil
    end,
})

local IV_MiningAutoEquip = SecMineConfig:CreateToggle({
    name = "Auto Equip Pickaxe", value = false,
    callback = function(v) Settings.Mining.AutoEquipPickaxe = v end,
})

local IV_MiningFakeHitAnim = SecMineConfig:CreateToggle({
    name = "Fake Hit Animation", value = false,
    callback = function(v) Settings.Mining.FakeHitAnimation = v end,
})

local IV_MiningSafeZone = SecMineConfig:CreateSlider({
    name = "Click Zone", min = 1, max = 100, step = 10,
    value = 80,
    callback = function(v) Settings.Mining.SafeZonePercent = v / 100 end,
})

local IV_MiningLoopDelay = SecMineConfig:CreateSlider({
    name = "Loop Delay", min = 0, max = 5.0, step = 0.1,
    value = Settings.Mining.LoopDelay,
    callback = function(v) Settings.Mining.LoopDelay = v end,
})

SecMineConfig:CreateLabel({
    text = "<b>Method Mining</b>\nLegit: Mulai & klik otomatis.\nBlatant: Bypass semua, lebih cepat tapi berisiko.\nSaran: Combokan dengan Fake Hit Animation",
})

MiningSystem.OnStatsUpdated = function(mined, failed)
    local str = string.format("Mined: %d", mined)
    if MainStatsOreLabel then pcall(function() MainStatsOreLabel:Set(str) end) end
end

local SecFriendGiver = TabHalloween.Right:CreateSection({ name = "Friend Giver ESP" })

local FG_SelectedName = ""
local FG_EnabledToggle

SecFriendGiver:CreateDropdown({
    name        = "Target Teman",
    specialType = "Player",
    searchable  = true,
    value       = "",
    callback = function(v)
        FG_SelectedName = tostring(v or "")
        local p = Players:FindFirstChild(FG_SelectedName)
        _FriendGiverESP.Target = p
    end,
})

FG_EnabledToggle = SecFriendGiver:CreateToggle({
    name = "Track Giver Teman", value = false,
    callback = function(v)
        _FriendGiverESP.Enabled = v
        if v then
            local p = (FG_SelectedName ~= "") and _Players_H:FindFirstChild(FG_SelectedName) or nil
            if not p then
                Notify({ Title = "Friend Giver ESP",
                    Message = "Pilih teman dulu di dropdown.",
                    Type = "warning", Duration = 3 })
                _FriendGiverESP.Enabled = false
                if FG_EnabledToggle then FG_EnabledToggle:Set(false, true) end
                return
            end
            _FriendGiverESP.Target = p
            _FG_StartLoop()
            Notify({ Title = "Friend Giver ESP",
                Message = "Tracking Candy Giver milik " .. p.Name,
                Type = "success", Duration = 3 })
        else
            _FG_StopLoop()
        end
    end,
})

SecFriendGiver:CreateLabel({
    text = "Pilih teman → ESP otomatis muncul di Candy Giver yang lagi nyariin mereka.\nESP gold biar beda dari punya lo sendiri.",
})

local SecHalloweenESP = TabHalloween.Left:CreateSection({ name = "ESP" })

local IV_ToT_ESP = SecHalloweenESP:CreateToggle({
    name = "Target ESP", value = true,
    callback = function(v)
        if HalloweenESP then HalloweenESP.SetESP(v) end
    end,
})
SecHalloweenESP:CreateLabel({
    text = "Highlight player yang harus kamu samperin.",
})

local IV_ToT_TreaterESP = SecHalloweenESP:CreateToggle({
    name = "Treater ESP", value = true,
    callback = function(v)
        if HalloweenESP then HalloweenESP.SetTreaterESP(v) end
    end,
})
SecHalloweenESP:CreateLabel({
    text = "Highlight siapa yang lagi nyariin kamu.",
})

local SecHalloweenAutoGive = TabHalloween.Left:CreateSection({ name = "Auto Give Candy" })

local IV_ToT_AutoGive = SecHalloweenAutoGive:CreateToggle({
    name = "Auto Give Candy", value = true,
    callback = function(v)
        if HalloweenESP then HalloweenESP.SetAutoGive(v) end
    end,
})

local IV_ToT_AutoHold = SecHalloweenAutoGive:CreateToggle({
    name = "Auto Hold Trick or Treat", value = false,
    callback = function(v)
        if HalloweenESP then HalloweenESP.SetAutoHold(v) end
    end,
})
SecHalloweenAutoGive:CreateLabel({
    text = "<b>Auto Hold Tool</b>\nSelalu pegang Tool <b>Trick or Treat</b>. "
        .. "Auto re-equip setelah respawn atau setelah selesai auto-walk.",
})

SecHalloweenAutoGive:CreateLabel({
    text = "Otomatis kasih permen ke Treater di jarak dekat. auto pick langsung berikan Candy.",
})

local SecToTSJ = TabHalloween.Right:CreateSection({ name = "Skip / Join Mode" })

local ToT_SJ_mode = "Skip"
local ToT_SJ_on   = false

local IV_ToT_SJEnabled = SecToTSJ:CreateToggle({
    name = "Skip/Join", value = true,
    callback = function(v)
        ToT_SJ_on = v
        if HalloweenESP then HalloweenESP.SetSkipJoin(ToT_SJ_mode, v) end
    end,
})

local IV_ToT_AutoWalk = SecToTSJ:CreateToggle({
    name = "Auto Walk to Target", value = true,
    callback = function(v) if HalloweenESP then HalloweenESP.SetAutoWalk(v) end end,
})

local IV_ToT_AutoWalkMode = SecToTSJ:CreateDropdown({
    name = "Auto Walk Target",
    options = {
        { Label = "My Giver (Receive Candy)", Value = "MyTarget" },
        { Label = "Friend's Giver",           Value = "FriendTarget" },
    },
    value = "MyTarget",
    callback = function(v)
        if HalloweenESP then HalloweenESP.SetAutoWalkTarget(v) end
    end,
})

local IV_ToT_ReturnToStart = SecToTSJ:CreateToggle({
    name = "Return to Position", value = true,
    callback = function(v)
        if HalloweenESP then HalloweenESP.SetReturnToStart(v) end
    end,
})

local ToT_RP_Label = SecToTSJ:CreateLabel({ text = "Return Point: (belum di-set)" })

local function ToT_UpdateRPLabel()
    if not HalloweenESP or not ToT_RP_Label then return end
    local pos = HalloweenESP.GetReturnPointPos and HalloweenESP.GetReturnPointPos()
    if pos then
        pcall(function()
            ToT_RP_Label:Set(string.format("Return Point: (%.0f, %.0f, %.0f)", pos.X, pos.Y, pos.Z))
        end)
    else
        pcall(function() ToT_RP_Label:Set("Return Point: (belum di-set)") end)
    end
end

SecToTSJ:CreateButton({
    name = "Set Return Point",
    callback = function()
        local hrp = Utils.GetHumanoidRootPart()
        if not hrp then
            Notify({ Title = "Return Point", Message = "Karakter belum spawn.",
                Type = "warning", Duration = 2 })
            return
        end
        if HalloweenESP then HalloweenESP.SetReturnPoint(hrp.CFrame) end
        ToT_UpdateRPLabel()
        Notify({ Title = "Return Point",
            Message = string.format("Titik: (%.0f, %.0f, %.0f)", hrp.Position.X, hrp.Position.Y, hrp.Position.Z),
            Type = "success", Duration = 2 })
    end,
})

SecToTSJ:CreateButton({
    name = "Clear Return Point",
    callback = function()
        if HalloweenESP then HalloweenESP.ClearReturnPoint() end
        ToT_UpdateRPLabel()
        Notify({ Title = "Return Point", Message = "Titik kembali dihapus.",
            Type = "info", Duration = 2 })
    end,
})

SecToTSJ:CreateLabel({
    text = "Jalan balik ke Return Point yang kamu set manual kalau Auto Walk selesai.\n"
        .. "Kalau belum di-set → <b>ga ada return sama sekali</b>.",
})

local IV_ToT_SJMode = SecToTSJ:CreateDropdown({
    name = "Mode",
    options = {
        { Label = "Skip", Value = "Skip" },
        { Label = "Join",   Value = "Join" },
    },
    value = "Skip",
    callback = function(v)
        ToT_SJ_mode = (v == "Join") and "Join" or "Skip"
        if HalloweenESP and ToT_SJ_on then
            HalloweenESP.SetSkipJoin(ToT_SJ_mode, true)
        end
    end,
})
SecToTSJ:CreateLabel({
    text = "<b>Skip</b> — skip hanya kalau target beda server.\n<b>Join</b> — auto join ke server target.",
})

local SecRefineAutomation = TabRefining.Left:CreateSection({ name = "Automation" })

local IV_RefiningAutoClaim = SecRefineAutomation:CreateToggle({
    name = "Auto Claim Refined", value = false,
    callback = function(v)
        RefiningSettings.AutoClaim = v
        RefiningSystem.CheckActive()
    end,
})

local IV_RefiningAutoRefine = SecRefineAutomation:CreateToggle({
    name = "Auto Refining", value = false,
    callback = function(v)
        RefiningSettings.AutoRefine = v
        RefiningSystem.CheckActive()
    end,
})

local SecRefineConfig = TabRefining.Right:CreateSection({ name = "Configuration" })

local IV_RefiningTiers = SecRefineConfig:CreateDropdown({
    name = "Refining Tier",
    options = {"Ancient","Mythic","Legend","Epic","Rare","Uncommon","Common"},
    value = {"Ancient","Mythic","Legend","Epic","Rare","Uncommon","Common"},
    multiSelect = true,
    callback = function(v)
        RefiningSettings.RefineTiers = (type(v) == "table" and #v > 0)
            and v or {"Ancient","Mythic","Legend","Epic","Rare","Uncommon","Common"}
    end,
})

SecRefineConfig:CreateButton({
    name = "Open Refining UI",
    callback = function()
        local g = LocalPlayer.PlayerGui:FindFirstChild("Refining")
        local fn = g and g:FindFirstChild("ShowFunction", true)
        if fn and fn:IsA("BindableFunction") then
            pcall(function() fn:Invoke() end)
        else
            Notify({ Title = "Refining", Message = "Refining UI belum ke load", Type = "warning", Duration = 2 })
        end
    end,
})

SecRefineConfig:CreateLabel({
    text = "<b>Cara Kerja Auto Refine</b>\nCek slot Refine yang terbuka, auto memasangkan 2 ore raw dengan tipe sama, lalu mulai Refining. Auto-ambil saat selesai.",
})

RefiningSystem.OnStatsUpdated = function()
    local a = RefiningSettings.TotalClaimed
    if MainStatsRefineLabel then
        pcall(function() MainStatsRefineLabel:Set(string.format("Refined Claimed: %d", a)) end)
    end
end

local SecSellFish = TabSell.Left:CreateSection({ name = "Auto Sell Fish" })

local IV_AutoSellFish = SecSellFish:CreateToggle({
    name = "Auto Sell Fish", value = false,
    callback = function(v)
        AutoSellSettings.FishEnabled = v
        if v then AutoSell.StartFishLoop() else AutoSell.StopFishLoop() end
    end,
})

local IV_AutoSellFishTiers = SecSellFish:CreateDropdown({
    name = "Sell Tiers",
    options = {"Ancient","Mythic","Legend","Epic","Rare","Uncommon","Common"},
    value = {"Ancient","Mythic","Legend","Epic","Rare","Uncommon","Common"},
    multiSelect = true,
    callback = function(v)
        AutoSellSettings.FishSellTiers = (type(v) == "table" and #v > 0) and v or SELL_TIERS_ALL
    end,
})

local IV_AutoSellFishTrigger = SecSellFish:CreateSlider({
    name = "Trigger At", min = 0, max = 1200, step = 10,
    value = AutoSellSettings.FishTrigger,
    callback = function(v) AutoSellSettings.FishTrigger = v end,
})

AutoSellSettings.ReturnAfterSell = true

SecSellFish:CreateButton({
    name = "Sell Fish Now",
    callback = function() task.spawn(AutoSell_DoFish) end,
})

local SecSellOre = TabSell.Right:CreateSection({ name = "Auto Sell Ore" })

local IV_AutoSellOre = SecSellOre:CreateToggle({
    name = "Auto Sell Ore", value = false,
    callback = function(v)
        AutoSellSettings.OreEnabled = v
        if v then AutoSell.StartOreLoop() else AutoSell.StopOreLoop() end
    end,
})

local IV_AutoSellOreTiers = SecSellOre:CreateDropdown({
    name = "Sell Tiers",
    options = {"Ancient","Mythic","Legend","Epic","Rare","Uncommon","Common"},
    value = {"Ancient","Mythic","Legend","Epic","Rare","Uncommon","Common"},
    multiSelect = true,
    callback = function(v)
        AutoSellSettings.OreSellTiers = (type(v) == "table" and #v > 0) and v or SELL_TIERS_ALL
    end,
})

local IV_AutoSellOreTrigger = SecSellOre:CreateSlider({
    name = "Trigger At", min = 0, max = 1500, step = 10,
    value = AutoSellSettings.OreTrigger,
    callback = function(v) AutoSellSettings.OreTrigger = v end,
})

SecSellOre:CreateButton({
    name = "Sell Ore Now",
    callback = function() task.spawn(AutoSell_DoOre) end,
})

local SecMiscBypass = TabMisc.Left:CreateSection({ name = "Bypass" })

local IV_TPBypass = SecMiscBypass:CreateToggle({
    name = "Bypass Teleport", value = false,
    callback = function(v)
        TPBypassSettings.BypassInGameMenu = v
    end,
})
SecMiscBypass:CreateLabel({
    text = "<b>Bypass Teleport</b>\nBypass kunci pertemanan. Klik 'Teleport' di menu Player List siapapun di dalam game akan muncul.",
})

local VoiceStalk = {
    Target       = nil,
    Spectating   = false,
    Connections  = {},
    StalkConn    = nil,
    SpectateConn = nil,
}

local function _VS_GetMyHRP()
    local char = LocalPlayer.Character
    return char and char:FindFirstChild("HumanoidRootPart")
end

local function _VS_FindListener()
    local hrp = _VS_GetMyHRP()
    if hrp then
        local l = hrp:FindFirstChild("CharacterVoiceListener")
        if l then return l end
    end
    local char = LocalPlayer.Character
    if char then
        local c = char:FindFirstChild("CharacterVoiceListener")
        if c then return c end
    end
    if VoiceStalk.Target and VoiceStalk.Target.Character then
        local t = VoiceStalk.Target.Character:FindFirstChild("CharacterVoiceListener")
        if t then return t end
    end
    return nil
end

local function _VS_MoveListenerTo(container)
    local listener = _VS_FindListener()
    if not listener or not container then return false end
    listener.Parent = container
    return true
end

local function _VS_StartSpectate(player)
    if not player or player == LocalPlayer then return false end
    local char = player.Character
    local hum  = char and char:FindFirstChildOfClass("Humanoid")
    local cam  = workspace.CurrentCamera
    if not hum or not cam then return false end

    cam.CameraType    = Enum.CameraType.Custom
    cam.CameraSubject = hum
    VoiceStalk.Spectating = true

    if VoiceStalk.SpectateConn then
        VoiceStalk.SpectateConn:Disconnect()
        VoiceStalk.SpectateConn = nil
    end
    VoiceStalk.SpectateConn = player.CharacterAdded:Connect(function(newChar)
        if not VoiceStalk.Spectating or VoiceStalk.Target ~= player then return end
        local newHum = newChar:WaitForChild("Humanoid", 5)
        if newHum and VoiceStalk.Spectating then
            local c = workspace.CurrentCamera
            if c then c.CameraSubject = newHum end
        end
    end)
    return true
end

local function _VS_StopSpectate()
    if VoiceStalk.SpectateConn then
        VoiceStalk.SpectateConn:Disconnect()
        VoiceStalk.SpectateConn = nil
    end
    local myChar = LocalPlayer.Character
    local myHum  = myChar and myChar:FindFirstChildOfClass("Humanoid")
    if myHum then
        local cam = workspace.CurrentCamera
        if cam then
            cam.CameraType    = Enum.CameraType.Custom
            cam.CameraSubject = myHum
        end
    end
    VoiceStalk.Spectating = false
end

local function _VS_Stalk(player)
    if not player or player == LocalPlayer then return false end
    local targetChar = player.Character
    if not targetChar then return false end
    if not _VS_MoveListenerTo(targetChar) then return false end
    VoiceStalk.Target = player

    if VoiceStalk.StalkConn then
        VoiceStalk.StalkConn:Disconnect()
        VoiceStalk.StalkConn = nil
    end
    VoiceStalk.StalkConn = player.CharacterAdded:Connect(function(newChar)
        if VoiceStalk.Target ~= player then
            if VoiceStalk.StalkConn then
                VoiceStalk.StalkConn:Disconnect()
                VoiceStalk.StalkConn = nil
            end
            return
        end
        task.wait(0.5)
        if not _VS_MoveListenerTo(newChar) then
            Notify({ Title = "Mic Stalker",
                Message = "Listener hilang setelah " .. player.Name .. " respawn. Toggle ulang.",
                Type = "warning", Duration = 4 })
        end
    end)
    return true
end

local function _VS_Unstalk()
    if VoiceStalk.StalkConn then
        VoiceStalk.StalkConn:Disconnect()
        VoiceStalk.StalkConn = nil
    end
    local hrp = _VS_GetMyHRP()
    if hrp then _VS_MoveListenerTo(hrp) end
    VoiceStalk.Target = nil
end

function VoiceStalk.Stop()
    _VS_Unstalk()
    _VS_StopSpectate()
    Utils.ClearConnections(VoiceStalk.Connections)
end

table.insert(VoiceStalk.Connections, Players.PlayerRemoving:Connect(function(p)
    if VoiceStalk.Target == p then
        VoiceStalk.Stop()
        Notify({ Title = "Mic Stalker",
            Message = p.Name .. " keluar — stalk & spectate dihentikan.",
            Type = "warning", Duration = 3 })
    end
end))

table.insert(VoiceStalk.Connections, LocalPlayer.CharacterAdded:Connect(function()
    VoiceStalk.Target = nil
    if VoiceStalk.Spectating then _VS_StopSpectate() end
end))

if not TabMisc then return end

local SecVoiceStalk = TabMisc.Left:CreateSection({ name = "Mic Stalker", icon = "mic" })

local VS_Enabled       = false
local VS_TargetName    = ""
local VS_TargetDropdown
local VS_EnabledToggle
local VS_SpectateToggle

VS_TargetDropdown = SecVoiceStalk:CreateDropdown({
    name        = "Target Player",
    specialType = "Player",
    searchable  = true,
    value       = "",
    callback = function(v)
        VS_TargetName = tostring(v or "")
        if VS_Enabled then
            local p = Players:FindFirstChild(VS_TargetName)
            if p then
                if _VS_Stalk(p) then
                    Notify({ Title = "Mic Stalker",
                        Message = "Sekarang mendengarkan " .. p.Name,
                        Type = "success", Duration = 2 })
                end
            end
        end
    end,
})

VS_EnabledToggle = SecVoiceStalk:CreateToggle({
    name = "Listen Target", value = false,
    callback = function(v)
        VS_Enabled = v
        if v then
            local p = VS_TargetName ~= "" and Players:FindFirstChild(VS_TargetName) or nil
            if not p then
                Notify({ Title = "Mic Stalker",
                    Message = "Pilih player target dulu di dropdown.",
                    Type = "warning", Duration = 3 })
                VS_Enabled = false
                if VS_EnabledToggle then VS_EnabledToggle:Set(false, true) end
                return
            end
            if _VS_Stalk(p) then
                Notify({ Title = "Mic Stalker",
                    Message = "Mendengarkan " .. p.Name,
                    Type = "success", Duration = 2 })
            else
                Notify({ Title = "Mic Stalker",
                    Message = "Gagal — pastikan voice chat aktif & target punya character.",
                    Type = "error", Duration = 4 })
                VS_Enabled = false
                if VS_EnabledToggle then VS_EnabledToggle:Set(false, true) end
            end
        else
            _VS_Unstalk()
            if VoiceStalk.Spectating then
                _VS_StopSpectate()
                if VS_SpectateToggle then VS_SpectateToggle:Set(false, true) end
            end
            Notify({ Title = "Mic Stalker",
                Message = "Dihentikan — listener di reset.",
                Type = "info", Duration = 2 })
        end
    end,
})

VS_SpectateToggle = SecVoiceStalk:CreateToggle({
    name = "Spectate Target", value = false,
    callback = function(v)
        if v then
            local p = VoiceStalk.Target
            if not p then
                Notify({ Title = "Mic Stalker",
                    Message = "Aktifin Mic Stalker dulu sebelum spectate.",
                    Type = "warning", Duration = 3 })
                if VS_SpectateToggle then VS_SpectateToggle:Set(false, true) end
                return
            end
            if _VS_StartSpectate(p) then
                Notify({ Title = "Mic Stalker",
                    Message = "Stalking " .. p.Name,
                    Type = "success", Duration = 2 })
            else
                Notify({ Title = "Mic Stalker",
                    Message = "Target ga punya character.",
                    Type = "error", Duration = 2 })
                if VS_SpectateToggle then VS_SpectateToggle:Set(false, true) end
            end
        else
            _VS_StopSpectate()
        end
    end,
})

SecVoiceStalk:CreateButton({
    name = "Stop Stalking",
    callback = function()
        _VS_Unstalk()
        _VS_StopSpectate()
        VS_Enabled = false
        if VS_EnabledToggle   then VS_EnabledToggle:Set(false, true) end
        if VS_SpectateToggle then VS_SpectateToggle:Set(false, true) end
        Notify({ Title = "Mic Stalker",
            Message = "Dihentikan total. Listener dan kamera kembali normal.",
            Type = "success", Duration = 3 })
    end,
})

SecVoiceStalk:CreateLabel({
    text = "<b>Cara Pakai</b>\n1. Pilih target di dropdown atas\n"
        .. "2. Toggle <b>Aktifkan Mic Stalker</b> — denger target + orang di sekitarnya\n"
        .. "3. Toggle <b>Spectate</b> — kamera ikutin, auto-follow respawn\n"
        .. "4. <b>Stop Stalking</b> atau matiin toggle = balik normal\n\n"
        .. "<i>Butuh voice chat aktif. Kalau target respawn, listener auto re-attach.</i>",
})

local SecMiscPlayers = TabMisc.Right:CreateSection({ name = "Player" })

local _AntiSlideEnabled = false
local _AntiSlideConns   = {}
local _AntiSlideSaved   = nil

local function _AntiSlide_LockSlopeAngle(hum)
    if not hum or not hum.Parent then return end
    pcall(function()
        if hum.MaxSlopeAngle ~= 89 then
            hum.MaxSlopeAngle = 89
        end
    end)
end

local function _AntiSlide_LockFriction(hrp)
    if not hrp or not hrp.Parent then return end
    pcall(function()
        local cur = hrp.CurrentPhysicalProperties
        local cp  = hrp.CustomPhysicalProperties
        local f   = cp and cp.Friction or cur.Friction
        if math.abs(f - 1.0) > 0.001 then
            hrp.CustomPhysicalProperties = PhysicalProperties.new(
                cur.Density, 1.0, cur.Elasticity,
                cur.FrictionWeight, cur.ElasticityWeight
            )
        end
    end)
end

local function _AntiSlide_SaveOriginal(char, hrp, hum)
    _AntiSlideSaved = {
        char       = char,
        savedSlope = hum.MaxSlopeAngle,
        savedCPP   = hrp.CustomPhysicalProperties,
        hadCPP     = hrp.CustomPhysicalProperties ~= nil,
    }
end

local function _AntiSlide_HookCharacter(char)
    if not char then return end
    local hrp = char:FindFirstChild("HumanoidRootPart")
        or char:WaitForChild("HumanoidRootPart", 10)
    local hum = char:FindFirstChildOfClass("Humanoid")
        or char:WaitForChild("Humanoid", 10)
    if not hrp or not hum then return end

    _AntiSlide_SaveOriginal(char, hrp, hum)
    _AntiSlide_LockSlopeAngle(hum)
    _AntiSlide_LockFriction(hrp)

    table.insert(_AntiSlideConns,
        hum:GetPropertyChangedSignal("MaxSlopeAngle"):Connect(function()
            if not _AntiSlideEnabled then return end
            _AntiSlide_LockSlopeAngle(hum)
        end))

    table.insert(_AntiSlideConns,
        hrp:GetPropertyChangedSignal("CustomPhysicalProperties"):Connect(function()
            if not _AntiSlideEnabled then return end
            _AntiSlide_LockFriction(hrp)
        end))

    table.insert(_AntiSlideConns,
        char.ChildAdded:Connect(function(child)
            if not _AntiSlideEnabled then return end
            if child.Name == "HumanoidRootPart" and child:IsA("BasePart") then
                _AntiSlide_LockFriction(child)
            end
        end))
end

local function _AntiSlide_Restore()
    local saved = _AntiSlideSaved
    if not saved then return end

    local curChar = LocalPlayer.Character
    local hum = curChar and curChar:FindFirstChildOfClass("Humanoid")
    local hrp = curChar and curChar:FindFirstChild("HumanoidRootPart")

    if hum then
        pcall(function()
            hum.MaxSlopeAngle = saved.savedSlope or 89
        end)
    end

    if hrp then
        if saved.hadCPP and saved.savedCPP then
            pcall(function()
                hrp.CustomPhysicalProperties = saved.savedCPP
            end)
        else
            local ok = pcall(function()
                hrp.CustomPhysicalProperties = nil
            end)
            if not ok or hrp.CustomPhysicalProperties ~= nil then
                pcall(function()
                    hrp.CustomPhysicalProperties = PhysicalProperties.new(0.7, 0.3, 0.5, 1, 1)
                end)
            end
        end
    end

    _AntiSlideSaved = nil
end

local function _AntiSlide_Stop()
    _AntiSlideEnabled = false
    for _, c in ipairs(_AntiSlideConns) do
        pcall(function() c:Disconnect() end)
    end
    table.clear(_AntiSlideConns)
    _AntiSlide_Restore()
end

local function _AntiSlide_Start()
    _AntiSlideEnabled = true
    for _, c in ipairs(_AntiSlideConns) do
        pcall(function() c:Disconnect() end)
    end
    table.clear(_AntiSlideConns)
    _AntiSlideSaved = nil

    if LocalPlayer.Character then
        _AntiSlide_HookCharacter(LocalPlayer.Character)
    end

    table.insert(_AntiSlideConns,
        LocalPlayer.CharacterAdded:Connect(function(newChar)
            if not _AntiSlideEnabled then return end
            task.wait(0.1)
            _AntiSlide_HookCharacter(newChar)
        end))
end

local IV_AutoRun = SecMiscPlayers:CreateToggle({
    name = "Auto Run", value = false,
    callback = function(v) MiscSettings.AutoRun = v end,
})

local IV_WalkSpeed = SecMiscPlayers:CreateSlider({
    name = "Walk Speed", min = 16, max = 100, step = 1,
    value = 16,
    callback = function(v) MiscSettings.WalkSpeed = v end,
})

local IV_SpeedEnabled = SecMiscPlayers:CreateToggle({
    name = "Custom Speed", value = false,
    callback = function(v)
        MiscSettings.SpeedEnabled = v
        if not v then
            local h = Utils.GetHumanoid()
            if h then h.WalkSpeed = 16 end
        end
    end,
})

local IV_JumpPower = SecMiscPlayers:CreateSlider({
    name = "Jump Power", min = 50, max = 250, step = 5,
    value = 50,
    callback = function(v) MiscSettings.JumpPower = v end,
})

local IV_JumpEnabled = SecMiscPlayers:CreateToggle({
    name = "Enable Jump Power", value = false,
    callback = function(v)
        MiscSettings.JumpEnabled = v
        if not v then
            local h = Utils.GetHumanoid()
            if h then h.UseJumpPower = false h.JumpPower = 50 end
        end
    end,
})

local IV_InfiniteJump = SecMiscPlayers:CreateToggle({
    name = "Infinite Jump", value = false,
    callback = function(v) MiscSystem.SetInfiniteJump(v) end,
})

NoclipToggle = SecMiscPlayers:CreateToggle({
    name = "Noclip", value = false,
    callback = function(v) MiscSystem.SetNoclip(v) end,
})

local IV_AntiSlide = SecMiscPlayers:CreateToggle({
    name = "Disable Sliding", value = true,
    callback = function(v)
        if v then _AntiSlide_Start() else _AntiSlide_Stop() end
    end,
})
SecMiscPlayers:CreateLabel({
    text = "Matikan efek merosot ketika menaiki tanjakan. fitur aneh tapi berguna ya gak?",
})

local SecGhostHunt = TabHalloween.Left:CreateSection({ name = "GhostHunt ESP" })

SecGhostHunt:CreateToggle({
    name = "Ghost ESP", value = false,
    callback = function(v)
        GhostHuntSettings.Enabled = v
        if v then GhostHuntESP.Start() else GhostHuntESP.Stop() end
    end,
})

SecGhostHunt:CreateToggle({
    name = "Tracer Line", value = true,
    callback = function(v) GhostHuntSettings.Tracer = v end,
})

SecGhostHunt:CreateLabel({
    text = "Highlight Ghost di map.\nAuto-detect saat event spawn. <b>INI MASI NEBAK YA KARNA GA SEMPET BUAT KARNA SEHARI CUMA 5 MENIT</b>\njadi report aja kalo ga works",
})

local SecMiscTeleport = TabMisc.Right:CreateSection({ name = "Teleport Manager" })

local TM_SelectedName = ""
local TM_WaypointDropdown = nil

local function TM_BuildOptions()
    local names = TeleportManager.GetNames()
    local opts = {}
    for _, n in ipairs(names) do
        table.insert(opts, { Label = n, Value = n })
    end
    if #opts == 0 then
        table.insert(opts, { Label = "(no waypoint)", Value = "" })
    end
    return opts
end

local function TM_RefreshDropdown()
    if not TM_WaypointDropdown then return end
    pcall(function()
        TM_WaypointDropdown:SetOptions(TM_BuildOptions())
    end)
end

TeleportManager.OnUpdated = TM_RefreshDropdown

TM_WaypointDropdown = SecMiscTeleport:CreateDropdown({
    name = "Waypoint",
    options = TM_BuildOptions(),
    value = "",
    callback = function(v)
        TM_SelectedName = tostring(v or "")
    end,
})

SecMiscTeleport:CreateButton({
    name = "Save Position",
    callback = function()
        local hrp = Utils.GetHumanoidRootPart()
        if not hrp then return end
        local existing = TeleportManager.GetNames()
        local name = "WP_" .. tostring(#existing + 1)
        TeleportManager.SaveWaypoint(name, hrp.CFrame)
        TM_RefreshDropdown()
        Notify({ Title = "Waypoint", Message = "Tersimpan sebagai '" .. name .. "'.", Type = "success", Duration = 2 })
    end,
})

SecMiscTeleport:CreateButton({
    name = "TP to Selected",
    callback = function()
        if TM_SelectedName == "" then
            Notify({ Title = "Waypoint", Message = "Pilih waypoint dulu.", Type = "warning", Duration = 2 })
            return
        end
        if TeleportManager.TeleportTo(TM_SelectedName) then
            Notify({ Title = "Waypoint", Message = "Teleport ke '" .. TM_SelectedName .. "'.", Type = "success", Duration = 2 })
        else
            Notify({ Title = "Waypoint", Message = "Waypoint tidak ditemukan.", Type = "error", Duration = 2 })
        end
    end,
})

SecMiscTeleport:CreateButton({
    name = "Delete Waypoint",
    callback = function()
        if TM_SelectedName == "" then
            Notify({ Title = "Waypoint", Message = "Pilih waypoint dulu.", Type = "warning", Duration = 2 })
            return
        end
        TeleportManager.DeleteWaypoint(TM_SelectedName)
        TM_SelectedName = ""
        TM_RefreshDropdown()
        Notify({ Title = "Waypoint", Message = "Waypoint dihapus.", Type = "info", Duration = 2 })
    end,
})

local function IndoVoice_Unload()
    pcall(function()
        Settings.Fishing.Enabled = false
        FishingSystem.Stop()
        FishingSystem.ResetSession()
        FishingSystem.UnhookRodEvents()
        if Runtime.Fishing.ActiveRod then
            pcall(function() Runtime.Fishing.ActiveRod:SetAttribute("_IVRodHooked", nil) end)
            Runtime.Fishing.ActiveRod = nil
        end
        Runtime.Fishing.CastToken = nil
        Runtime.Fishing.BaitLanded = false
    end)
    pcall(function()
        Settings.Mining.Enabled = false
        Settings.Mining.FullyAuto = false
        MiningSystem.Stop()
        MiningSystem.DisableUndergroundFloat()
        MiningSystem.ResetSession()
        MiningSystem.UnhookPickaxeEvents()
        Runtime.Mining.HookedPickaxe = nil
        Runtime.Mining.CurrentTargetStone = nil
        Runtime.Mining.IsBusy = false
    end)
    pcall(function()
        RefiningSettings.AutoClaim = false
        RefiningSettings.AutoRefine = false
        RefiningSystem.Stop()
        RefiningRuntime.IsBusy = false
    end)
    pcall(function()
        AutoSellSettings.FishEnabled = false
        AutoSellSettings.OreEnabled = false
        AutoSell.StopFishLoop()
        AutoSell.StopOreLoop()
        AutoSellRuntime.IsBusy = false
    end)
    pcall(function()
        if HalloweenESP then HalloweenESP.Stop() end
    end)
    pcall(function() AutoFavFishRuntime.IsBusy = false end)
    pcall(function() AutoFavOreRuntime.IsBusy = false end)
    pcall(function()
        ClaimSettings.AutoClaimDaily = false
        ClaimSettings.AutoClaimSession = false
        AutoClaim.Stop()
    end)
    pcall(function()
        AntiAFKSettings.Enabled = false
        AntiAFK.Stop()
    end)
    pcall(function()
        if HalloweenESP then HalloweenESP.Stop() end
    end)
    pcall(function()
        _FG_StopLoop()
        _FriendGiverESP.Enabled = false
        _FriendGiverESP.Target  = nil
    end)
    pcall(function()
        GhostHuntSettings.Enabled = false
        GhostHuntESP.Stop()
    end)
    pcall(function()
        HotspotSettings.FishingEnabled = false
        HotspotSettings.FishingChams = false
        HotspotSettings.MiningEnabled = false
        HotspotSettings.MiningChams = false
        HotspotESP.Stop()
    end)
    pcall(function()
        MiscSettings.AutoLikeLoop = false
        MiscSystem.Stop()
    end)
    pcall(function() _AntiSlide_Stop() end)
    pcall(function() TPBypassSettings.BypassInGameMenu = false end)
    pcall(function() VoiceStalk.Stop() end)
    pcall(function()
        Utils.ClearConnections(Runtime.GlobalConnections)
        Utils.ClearConnections(Runtime.Fishing.Connections)
        Utils.ClearConnections(Runtime.Mining.Connections)
    end)
    pcall(function()
        local pg = LocalPlayer:FindFirstChildOfClass("PlayerGui")
        if pg then
            for _, name in ipairs({"FishingUI", "MiningUI"}) do
                local g = pg:FindFirstChild(name)
                if g then pcall(function() g:Destroy() end) end
            end
        end
    end)
    pcall(function()
        local cf = workspace:FindFirstChild("Delirium_Hotspot_Chams")
        if cf then cf:Destroy() end
    end)
    pcall(function()
        if Window and Window.Unload then Window:Unload() end
    end)
    ActiveWindow = nil
    if getgenv then
        getgenv().IndoVoice_Unload = nil
    end
end

if getgenv then getgenv().IndoVoice_Unload = IndoVoice_Unload end

UpdateClaimLoop()

AntiAFK.Start()
_AntiSlide_Start()
if HalloweenESP then
    HalloweenESP.SetESP(true)
    HalloweenESP.SetTreaterESP(true)
    HalloweenESP.SetAutoGive(true)
    ToT_SJ_on = true
    HalloweenESP.SetSkipJoin("Skip", true)
    HalloweenESP.SetReturnToStart(true)
    HalloweenESP.SetAutoWalk(true)
end

Window:Notify({
    title = "Delirium",
    content = "Script berhasil dimuat.",
    type = "info",
    duration = 3,
})

end)
