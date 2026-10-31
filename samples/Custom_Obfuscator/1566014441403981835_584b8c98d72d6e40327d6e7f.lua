-- ================================================================    
-- FRX X BLOCKSPIN  •  OPPS  •  SILENT AIM + ESP + TARGET LINE    
-- + FRX SYSTEM (Skip Crates + Auto Pickup)    
-- game : [💎 HEIST] OPPS 🔪    
-- ================================================================    
    
local Players = game:GetService("Players")    
local RS      = game:GetService("ReplicatedStorage")    
local Run     = game:GetService("RunService")    
local UIS     = game:GetService("UserInputService")    
local Http    = game:GetService("HttpService")    
local TweenService = game:GetService("TweenService")    
local L       = Players.LocalPlayer    
local PG      = L:WaitForChild("PlayerGui")    
local Camera  = workspace.CurrentCamera    
    
if not isfile and is_file then isfile = is_file end    
if not readfile and read_file then readfile = read_file end    
if not writefile and write_file then writefile = write_file end    
if not setclipboard and toclipboard then setclipboard = toclipboard end    
    
-- ================================================================    
-- SETTINGS & STATE    
-- ================================================================    
local FILE = "frx_opps.json"    
local S = {    
    SilentAim = false, SilentAimHitPart = "Head",    
    TargetLine = true, SA_FOV = 120,    
    StickyTurn = 16, StickyRatio = 0.5, StickyMinPix = 100,    
    ESP_Box = false, ESP_Lines = false, ESP_Highlight = false, ESP_Name = false,    
    ESP_Health = false, ESP_Dist = false, ESP_Weapon = false, ESP_Item = false,    
    ESP_MaxRange = 1000000, ESP_Size = 1,    
    ESP_LineThickness = 1, ESP_OffsetX = -1, ESP_OffsetY = 12,    
    Friends = {},    
    SkipCrates = false,    
    AutoPickup = false,    
    AutoPickupRadius = 85    
}    
pcall(function()    
    if isfile and isfile(FILE) then    
        for k, v in pairs(Http:JSONDecode(readfile(FILE))) do    
            if S[k] ~= nil and type(S[k]) == type(v) then S[k] = v end    
        end    
    end    
end)    
    
S.ESP_OffsetX = -1    
S.ESP_OffsetY = 12    
    
local function save() pcall(function() if writefile then writefile(FILE, Http:JSONEncode(S)) end end) end    
    
local TargetVisibleColor = Color3.fromRGB(0, 255, 0)    
local TargetHiddenColor  = Color3.fromRGB(255, 0, 0)    
local HP_HI  = Color3.fromRGB(0, 255, 40)    
local HP_MID = Color3.fromRGB(255, 200, 40)    
local HP_LO  = Color3.fromRGB(255, 50, 50)    
local HP_BG  = Color3.fromRGB(20, 20, 20)    
    
local RarityColors = {    
    Common=Color3.fromRGB(255,255,255), Uncommon=Color3.fromRGB(99,255,52),    
    Rare=Color3.fromRGB(51,170,255), Epic=Color3.fromRGB(237,44,255),    
    Legendary=Color3.fromRGB(255,150,0), Omega=Color3.fromRGB(255,20,51)    
}    
    
local function hudParent()    
    local ok, h = pcall(function() return gethui and gethui() end)    
    if ok and h then return h end    
    local ok2, cg = pcall(function() return game:GetService("CoreGui") end)    
    if ok2 and cg then    
        local t = Instance.new("Folder")    
        local ok3 = pcall(function() t.Parent = cg end)    
        t:Destroy()    
        if ok3 then return cg end    
    end    
    return PG    
end    
    
-- Safe Friend Logic    
local function IsSafeFriend(pl)    
    return pl ~= nil and S.Friends[pl.Name] == true    
end    
    
local SafeFriendMarkedChars = {}    
local function UpdateSafeFriendMarker()    
    local currentFriendChars = {}    
    for _, p in ipairs(Players:GetPlayers()) do    
        if S.Friends[p.Name] and p.Character then    
            currentFriendChars[p.Character] = true    
            local char = p.Character    
            local head = char:FindFirstChild("Head")    
                
            if head then    
                local hl = char:FindFirstChild("CHINO_SafeFriendHighlight")    
                if not hl then    
                    hl = Instance.new("Highlight")    
                    hl.Name = "CHINO_SafeFriendHighlight"    
                    hl.Parent = char    
                end    
                hl.Adornee = char    
                hl.DepthMode = Enum.HighlightDepthMode.AlwaysOnTop    
                hl.FillColor = Color3.fromRGB(46, 245, 109)    
                hl.FillTransparency = 0.59    
                hl.OutlineColor = Color3.fromRGB(132, 255, 151)    
                hl.OutlineTransparency = 0    
                hl.Enabled = true    
    
                local tag = head:FindFirstChild("CHINO_SafeFriendTag")    
                if not tag then    
                    tag = Instance.new("BillboardGui")    
                    tag.Name = "CHINO_SafeFriendTag"    
                    tag.Size = UDim2.fromOffset(112, 19)    
                    tag.StudsOffsetWorldSpace = Vector3.new(0, 1.65, 0)    
                    tag.AlwaysOnTop = true    
                    tag.MaxDistance = 1400    
                    tag.Parent = head    
                    local plate = Instance.new("TextLabel")    
                    plate.Name = "Label"    
                    plate.Size = UDim2.fromScale(1, 1)    
                    plate.BackgroundColor3 = Color3.fromRGB(13, 32, 24)    
                    plate.BackgroundTransparency = 0.19    
                    plate.BorderSizePixel = 0    
                    plate.Text = "MY TEAM"    
                    plate.Font = Enum.Font.GothamBold    
                    plate.TextSize = 10    
                    plate.TextColor3 = Color3.fromRGB(163, 255, 187)    
                    plate.TextStrokeTransparency = 0.76    
                    plate.Parent = tag    
                    Instance.new("UICorner", plate).CornerRadius = UDim.new(0, 6)    
                    local stroke = Instance.new("UIStroke", plate)    
                    stroke.Color = Color3.fromRGB(75, 235, 118)    
                    stroke.Thickness = 0.8    
                    stroke.Transparency = 0.26    
                end    
                tag.Adornee = head    
                tag.Enabled = true    
            end    
        end    
    end    
    
    for char, _ in pairs(SafeFriendMarkedChars) do    
        if not currentFriendChars[char] then    
            if char and char.Parent then    
                local hl = char:FindFirstChild("CHINO_SafeFriendHighlight")    
                if hl then hl:Destroy() end    
                local head = char:FindFirstChild("Head")    
                if head then    
                    local tag = head:FindFirstChild("CHINO_SafeFriendTag")    
                    if tag then tag:Destroy() end    
                end    
            end    
        end    
    end    
    SafeFriendMarkedChars = currentFriendChars    
end    
    
task.spawn(function()    
    while PG and PG.Parent do    
        pcall(UpdateSafeFriendMarker)    
        task.wait(0.55)    
    end    
end)    
    
-- ================================================================    
-- REMOTES & NETWORKING    
-- ================================================================    
local RemotesFolder = RS:WaitForChild("Remotes", 10)    
local SendRemote = RemotesFolder and (RemotesFolder:FindFirstChild("Send") or RemotesFolder:FindFirstChild("FireServer"))    
local GetRemote = RemotesFolder and RemotesFolder:FindFirstChild("Get")    
    
local RemoteCounter    
pcall(function()    
    if getgc then    
        for _, obj in ipairs(getgc(true)) do    
            if typeof(obj) == "table" and rawget(obj, "event") and rawget(obj, "func") then    
                RemoteCounter = obj    
                break    
            end    
        end    
    end    
end)    
    
local function NetGet(...)    
    if not RemoteCounter or not RemoteCounter.func or not GetRemote then return end    
    local args = {...}    
    RemoteCounter.func = (RemoteCounter.func or 0) + 1    
    local ok, res = pcall(function()    
        return GetRemote:InvokeServer(RemoteCounter.func, unpack(args))    
    end)    
    return res    
end    
    
local function FireServerHook(...)    
    if not SendRemote then return false end    
    local args = {...}    
    if RemoteCounter and type(RemoteCounter.event) == "number" then    
        RemoteCounter.event = RemoteCounter.event + 1    
        local ok = pcall(function() SendRemote:FireServer(RemoteCounter.event, unpack(args)) end)    
        return ok    
    else    
        local ok = pcall(function() SendRemote:FireServer(unpack(args)) end)    
        return ok    
    end    
end    
    
-- ================================================================    
-- FRX SYSTEM: SKIP CRATES    
-- ================================================================    
local SkipCratesEnabled = false    
local AutoPickupEnabled = false    
local AutoPickupRadius = S.AutoPickupRadius or 85    
local ak = false    
local al = {}    
local DroppedItems = workspace:WaitForChild("DroppedItems", 10)    
    
local SkipCratesAPI = (function()    
    local ENV = _G    
    if type(getgenv) == "function" then    
        local ok, env = pcall(getgenv)    
        if ok and type(env) == "table" then ENV = env end    
    end    
    
    if ENV.CHINO_AutoSkipCrate and type(ENV.CHINO_AutoSkipCrate.Destroy) == "function" then    
        pcall(ENV.CHINO_AutoSkipCrate.Destroy)    
    end    
    
    local State = {    
        Enabled = false,    
        Running = true,    
        CrateController = nil,    
        OriginalTween = nil,    
        WrappedTween = nil,    
        UtilModule = nil,    
        StepConnection = nil,    
    }    
    
    local function getModule(...)    
        local names = {...}    
        local current = RS    
        for _, name in ipairs(names) do    
            current = current:FindFirstChild(name)    
            if not current then return nil end    
        end    
        if not current:IsA("ModuleScript") then return nil end    
        local ok, module = pcall(require, current)    
        if ok and type(module) == "table" then return module end    
        return nil    
    end    
    
    local function stopCrateAnimations()    
        local character = L.Character    
        if not character then return end    
        local humanoid = character:FindFirstChildOfClass("Humanoid")    
        local animator = humanoid and humanoid:FindFirstChildOfClass("Animator")    
        if not animator then return end    
        for _, track in ipairs(animator:GetPlayingAnimationTracks()) do    
            local name = tostring(track.Name):lower()    
            if name:find("crate", 1, true) or name:find("use", 1, true) then    
                pcall(function() track:Stop(0) end)    
            end    
        end    
    end    
    
    State.CrateController = getModule("Modules", "Game", "CrateSystem", "Crate")    
    State.UtilModule = getModule("Modules", "Core", "Util")    
    
    if State.UtilModule and type(State.UtilModule.tween) == "function" then    
        State.OriginalTween = State.UtilModule.tween    
        State.WrappedTween = function(instance, tweenInfo, properties, ...)    
            if State.Enabled    
                and instance    
                and instance:IsA("NumberValue")    
                and typeof(tweenInfo) == "TweenInfo"    
                and type(properties) == "table"    
                and properties.Value == 1    
                and tweenInfo.Time > 0 then    
                tweenInfo = TweenInfo.new(0, tweenInfo.EasingStyle, tweenInfo.EasingDirection)    
            end    
            return State.OriginalTween(instance, tweenInfo, properties, ...)    
        end    
        State.UtilModule.tween = State.WrappedTween    
    end    
    
    State.StepConnection = Run.Stepped:Connect(function()    
        if State.Running and State.Enabled then    
            pcall(stopCrateAnimations)    
        end    
    end)    
    
    task.spawn(function()    
        while State.Running do    
            task.wait(0.1)    
            if State.Enabled and State.CrateController then    
                pcall(function()    
                    local controller = State.CrateController    
                    local objects = controller.class and controller.class.objects    
                    if type(objects) == "table" then    
                        for _, crate in pairs(objects) do    
                            local open = crate.states and crate.states.open    
                            if open and type(open.set) == "function" then    
                                open.set(true)    
                            end    
                        end    
                    end    
                    local skipping = controller.skipping    
                    if skipping and type(skipping.set) == "function" then    
                        skipping.set(true)    
                    end    
                end)    
            end    
        end    
    end)    
    
    local API = {}    
    function API.SetEnabled(on)    
        if not State.Running then return false end    
        State.Enabled = (on == true)    
        return State.Enabled    
    end    
    function API.IsEnabled() return State.Enabled end    
    function API.Destroy()    
        State.Enabled = false    
        State.Running = false    
        if State.StepConnection then State.StepConnection:Disconnect(); State.StepConnection = nil end    
        if State.UtilModule and State.UtilModule.tween == State.WrappedTween then    
            State.UtilModule.tween = State.OriginalTween    
        end    
        if ENV.CHINO_AutoSkipCrate == API then ENV.CHINO_AutoSkipCrate = nil end    
    end    
    ENV.CHINO_AutoSkipCrate = API    
    return API    
end)()    
    
SkipCratesAPI.SetEnabled(S.SkipCrates == true)    
    
-- ================================================================    
-- FRX SYSTEM: AUTO PICKUP    
-- ================================================================    
local function setupAutoPickupLogic()    
    local myRoot = L.Character and L.Character:FindFirstChild("HumanoidRootPart")    
    if not DroppedItems or not myRoot then return end    
        
    local currentTime = tick()    
    local itemsToPickup = {}    
        
    for _, itemModel in ipairs(DroppedItems:GetChildren()) do    
        if itemModel:IsA("Model") then    
            local zone = itemModel:FindFirstChildWhichIsA("BasePart") or itemModel:FindFirstChild("PickUpZone")    
            if zone then    
                local dist = (myRoot.Position - zone.Position).Magnitude    
                if dist <= AutoPickupRadius and (currentTime - (al[itemModel] or 0)) >= 0.25 then    
                    table.insert(itemsToPickup, itemModel)    
                    al[itemModel] = currentTime    
                    if #itemsToPickup >= 6 then break end    
                end    
            end    
        end    
    end    
        
    if #itemsToPickup > 0 then    
        for _, itemModel in ipairs(itemsToPickup) do    
            task.spawn(function()    
                NetGet("pickup_dropped_item", itemModel)    
            end)    
        end    
    end    
end    
    
task.spawn(function()    
    while PG and PG.Parent do    
        task.wait(0.25)    
        if ak then    
            pcall(setupAutoPickupLogic)    
        end    
    end    
end)    
    
ak = S.AutoPickup == true    
    
-- ================================================================    
-- FRX TARGET STICKY & TARGET LINE SYSTEM    
-- ================================================================    
local function isDirectVisible(targetChar, targetPart)    
    local cam = workspace.CurrentCamera    
    if not cam or not targetChar or not targetPart then return false end    
    local origin = cam.CFrame.Position    
    local dir = targetPart.Position - origin    
    if dir.Magnitude <= 0.001 then return true end    
    local params = RaycastParams.new()    
    params.FilterType = Enum.RaycastFilterType.Exclude    
    params.IgnoreWater = true    
    params.FilterDescendantsInstances = {L.Character}    
    local hit = workspace:Raycast(origin, dir, params)    
    if not hit then return true end    
    return hit.Instance:IsDescendantOf(targetChar)    
end    
    
local TargetSticky = { Locked=nil, LockForward=nil, CacheAt=0, CacheValue=nil }    
local StickyTurnDegrees = 16.0    
local StickySwitchMinPixels = 100    
local StickySwitchRatio = 0.50    
local StickyKeepFOVMultiplier = 3.20    
local StickyScanInterval = 0.055    
local StickySwitchScoreAdvantage = 30    
    
local function GetTargetWeaponPriority(pl)    
    local bonus=0    
    local char=pl and pl.Character    
    if char then    
        for _,tool in ipairs(char:GetChildren()) do    
            if tool:IsA("Tool") and tool.Name~="Fists" and tool:GetAttribute("AmmoType")~=nil then    
                bonus=15    
                break    
            end    
        end    
    end    
    return bonus    
end    
    
local function GetChinoStickyTarget(fovRadius)    
    local Camera = workspace.CurrentCamera    
    local state=TargetSticky    
    if not Camera then state.Locked=nil; state.CacheValue=nil; return nil end    
    local now=os.clock()    
    if now-(state.CacheAt or 0) < StickyScanInterval then return state.CacheValue end    
    state.CacheAt=now    
    
    local radius=math.max(35,tonumber(fovRadius) or 120)    
    local center=Camera.ViewportSize/2    
    local center2=Vector2.new(center.X,center.Y)    
    local ownChar=L.Character    
    local ownRoot=ownChar and ownChar:FindFirstChild("HumanoidRootPart")    
    local origin=ownRoot and ownRoot.Position or Camera.CFrame.Position    
    local forward=Camera.CFrame.LookVector    
    
    local function evaluate(pl)    
        if not pl or pl==L or IsSafeFriend(pl) or not pl.Character then return nil end    
        local char=pl.Character    
        local hum=char:FindFirstChildOfClass("Humanoid")    
        local root=char:FindFirstChild("HumanoidRootPart")    
        local head=char:FindFirstChild("Head") or char:FindFirstChild("UpperTorso") or root    
        if not hum or hum.Health<=0 or not root or not head then return nil end    
        local projected,onScreen=Camera:WorldToViewportPoint(head.Position)    
        if not onScreen or projected.Z<=0 then return nil end    
        local screenDistance=(Vector2.new(projected.X,projected.Y)-center2).Magnitude    
        local worldDistance=(root.Position-origin).Magnitude    
        local visible=isDirectVisible(char,head)    
        local armedBonus=GetTargetWeaponPriority(pl)    
        local score=screenDistance + math.min(worldDistance,300)*0.26    
        if worldDistance>120 then score+=(worldDistance-120)*0.16 end    
        if visible then score-=8 end    
        score-=armedBonus    
        return {Player=pl,Screen=screenDistance,Score=score,Distance=worldDistance}    
    end    
    
    local locked=state.Locked    
    local lockedInfo=evaluate(locked)    
    local keepRadius=radius*StickyKeepFOVMultiplier    
    if lockedInfo and lockedInfo.Screen>keepRadius then lockedInfo=nil end    
    
    local bestInfo=nil    
    for _,pl in ipairs(Players:GetPlayers()) do    
        if pl~=L then    
            local info=evaluate(pl)    
            if info and info.Screen<=radius and (not bestInfo or info.Score<bestInfo.Score) then    
                bestInfo=info    
            end    
        end    
    end    
    
    local chosen=lockedInfo and locked or nil    
    if not lockedInfo then    
        chosen=bestInfo and bestInfo.Player or nil    
    elseif bestInfo and bestInfo.Player~=locked then    
        local initial=state.LockForward or forward    
        local angle=math.deg(math.acos(math.clamp(initial:Dot(forward),-1,1)))    
        local changedEnough=angle >= StickyTurnDegrees and lockedInfo.Screen >= StickySwitchMinPixels    
        local clearlyBetter=bestInfo.Screen <= lockedInfo.Screen*StickySwitchRatio    
            and bestInfo.Score <= lockedInfo.Score-StickySwitchScoreAdvantage    
        if changedEnough and clearlyBetter then    
            chosen=bestInfo.Player    
        end    
    end    
    
    if chosen~=state.Locked then    
        state.LockForward=chosen and forward or nil    
        state.Locked=chosen    
    end    
    state.CacheValue=chosen    
    return chosen    
end    
    
local function getBypassedTargetPart(character, partName)    
    if not character then return nil, Vector3.zero end    
    local head = character:FindFirstChild("Head")    
    local upperTorso = character:FindFirstChild("UpperTorso") or character:FindFirstChild("Torso")    
    if partName == "Head" then    
        if head then return head, Vector3.zero end    
        return upperTorso, Vector3.zero    
    elseif partName == "Neck" then    
        if upperTorso then return upperTorso, Vector3.new(0, upperTorso.Size.Y * 0.08, 0) end    
        if head then return head, Vector3.new(0, -(head.Size.Y * 1.15), 0) end    
        return nil, Vector3.zero    
    elseif partName == "Chest" then    
        if upperTorso then return upperTorso, Vector3.new(0, -(upperTorso.Size.Y * 0.30), 0) end    
        if head then return head, Vector3.new(0, -(head.Size.Y * 1.65), 0) end    
        return nil, Vector3.zero    
    end    
    return head or upperTorso, Vector3.zero    
end    
    
-- ================================================================    
-- TARGET LINE & OCTAGON UI    
-- ================================================================    
local Gui = Instance.new("ScreenGui")    
Gui.Name = "FRX_SimpleSA"    
Gui.ResetOnSpawn = false    
Gui.IgnoreGuiInset = true    
Gui.DisplayOrder = 200    
Gui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling    
Gui.Parent = hudParent()    
    
local TargetLineThickness = 3    
    
local TargetLine = Instance.new("Frame", Gui)    
TargetLine.Name = "TargetLine"    
TargetLine.AnchorPoint = Vector2.new(0.5, 0.5)    
TargetLine.BackgroundColor3 = TargetHiddenColor    
TargetLine.BackgroundTransparency = 0    
TargetLine.BorderSizePixel = 0    
TargetLine.Size = UDim2.fromOffset(0, TargetLineThickness)    
TargetLine.Visible = false    
TargetLine.ZIndex = 20    
Instance.new("UICorner", TargetLine).CornerRadius = UDim.new(1, 0)    
    
local TargetOctagon = Instance.new("Frame", Gui)    
TargetOctagon.Name = "TargetOctagon"    
TargetOctagon.Size = UDim2.fromOffset(12, 12)    
TargetOctagon.AnchorPoint = Vector2.new(0.5, 0.5)    
TargetOctagon.BackgroundTransparency = 1    
TargetOctagon.Visible = false    
TargetOctagon.ZIndex = 30    
    
local TargetOctagonSegments = {}    
local TargetFXTime = 0    
    
local function CreateTargetOctagonSegment(size, x, y, rotation, dirX, dirY)    
    local segment = Instance.new("Frame", TargetOctagon)    
    segment.AnchorPoint = Vector2.new(0.5, 0.5)    
    segment.BackgroundColor3 = TargetHiddenColor    
    segment.BorderSizePixel = 0    
    segment.Size = size    
    segment.Position = UDim2.fromOffset(x, y)    
    segment.Rotation = rotation or 0    
    segment.ZIndex = 30    
    table.insert(TargetOctagonSegments, {    
        Frame = segment,    
        BasePosition = Vector2.new(x, y),    
        Dir = Vector2.new(dirX, dirY)    
    })    
end    
    
CreateTargetOctagonSegment(UDim2.fromOffset(5, 1), 6, 1, 0, 0, -1)    
CreateTargetOctagonSegment(UDim2.fromOffset(5, 1), 6, 11, 0, 0, 1)    
CreateTargetOctagonSegment(UDim2.fromOffset(1, 5), 1, 6, 0, -1, 0)    
CreateTargetOctagonSegment(UDim2.fromOffset(1, 5), 11, 6, 0, 1, 0)    
CreateTargetOctagonSegment(UDim2.fromOffset(3, 1), 2.5, 2.5, 45, -0.707, -0.707)    
CreateTargetOctagonSegment(UDim2.fromOffset(3, 1), 9.5, 2.5, -45, 0.707, -0.707)    
CreateTargetOctagonSegment(UDim2.fromOffset(3, 1), 2.5, 9.5, -45, -0.707, 0.707)    
CreateTargetOctagonSegment(UDim2.fromOffset(3, 1), 9.5, 9.5, 45, 0.707, 0.707)    
    
local TargetArrow = Instance.new("BillboardGui")    
TargetArrow.Name = "CHINO_TargetArrow3D"    
TargetArrow.Size = UDim2.fromOffset(38, 38)    
TargetArrow.StudsOffset = Vector3.new(0, 3.2, 0)    
TargetArrow.AlwaysOnTop = true    
TargetArrow.LightInfluence = 0    
TargetArrow.MaxDistance = 1000000    
TargetArrow.Enabled = false    
TargetArrow.Parent = PG    
    
local TargetArrowText = Instance.new("TextLabel", TargetArrow)    
TargetArrowText.BackgroundTransparency = 1    
TargetArrowText.Size = UDim2.fromScale(1, 1)    
TargetArrowText.Font = Enum.Font.GothamBlack    
TargetArrowText.Text = "▼"    
TargetArrowText.TextColor3 = TargetHiddenColor    
TargetArrowText.TextSize = 28    
TargetArrowText.TextStrokeTransparency = 1    
    
local function HideNewTargetVisuals()    
    TargetLine.Visible = false    
    TargetOctagon.Visible = false    
    TargetArrow.Enabled = false    
    TargetArrow.Adornee = nil    
    TargetArrow.StudsOffset = Vector3.new(0, 3.2, 0)    
    for _, info in ipairs(TargetOctagonSegments) do    
        if info.Frame then    
            info.Frame.Position = UDim2.fromOffset(info.BasePosition.X, info.BasePosition.Y)    
        end    
    end    
end    
    
local function SetNewTargetColor(isVisible)    
    local color = isVisible and TargetVisibleColor or TargetHiddenColor    
    TargetLine.BackgroundColor3 = Color3.fromRGB(0, 0, 0)    
    TargetArrowText.TextColor3 = color    
    for _, info in ipairs(TargetOctagonSegments) do    
        if info.Frame then info.Frame.BackgroundColor3 = color end    
    end    
    return color    
end    
    
local function AnimateNewTargetFX(dt)    
    TargetFXTime = (TargetFXTime or 0) + (dt or 0)    
    if TargetFXTime > 10000 then TargetFXTime = 0 end    
    local t = TargetFXTime    
    local openPulse = (math.sin(t * 8.5) + 1) * 0.5    
    local spread = 0.18 + (openPulse * 1.12)    
    for _, info in ipairs(TargetOctagonSegments) do    
        if info.Frame then    
            info.Frame.Position = UDim2.fromOffset(    
                info.BasePosition.X + (info.Dir.X * spread),    
                info.BasePosition.Y + (info.Dir.Y * spread)    
            )    
        end    
    end    
    TargetArrow.StudsOffset = Vector3.new(0, 3.15 + math.sin(t * 6.5) * 0.26, 0)    
end    
    
local function GetProjectedCharacterBounds(char)    
    local Camera = workspace.CurrentCamera    
    if not Camera or not char then return nil end    
    local root = char:FindFirstChild("HumanoidRootPart") or char:FindFirstChild("UpperTorso") or char:FindFirstChild("Torso")    
    local ok, boxCF, boxSize = pcall(function() return char:GetBoundingBox() end)    
    if ok and boxCF and boxSize then    
        local centerOffset = root and (boxCF.Position - root.Position).Magnitude or 0    
        local anomalous = boxSize.X > 12 or boxSize.Y > 14 or boxSize.Z > 12 or centerOffset > 7    
        if not anomalous then    
            local hx, hy, hz = boxSize.X * 0.5, boxSize.Y * 0.5, boxSize.Z * 0.5    
            local minX, minY = math.huge, math.huge    
            local maxX, maxY = -math.huge, -math.huge    
            local visiblePoints = 0    
            for _, sx in ipairs({-1, 1}) do    
                for _, sy in ipairs({-1, 1}) do    
                    for _, sz in ipairs({-1, 1}) do    
                        local worldPoint = boxCF:PointToWorldSpace(Vector3.new(hx * sx, hy * sy, hz * sz))    
                        local screenPoint = Camera:WorldToViewportPoint(worldPoint)    
                        if screenPoint.Z > 0 then    
                            visiblePoints += 1    
                            minX = math.min(minX, screenPoint.X); maxX = math.max(maxX, screenPoint.X)    
                            minY = math.min(minY, screenPoint.Y); maxY = math.max(maxY, screenPoint.Y)    
                        end    
                    end    
                end    
            end    
            if visiblePoints > 0 and minX ~= math.huge and minY ~= math.huge then    
                return { Left = minX, Right = maxX, Top = minY, Bottom = maxY, Width = math.max(8, maxX - minX), Height = math.max(12, maxY - minY), Center = Vector2.new((minX + maxX) * 0.5, (minY + maxY) * 0.5) }    
            end    
        end    
    end    
    return nil    
end    
    
-- ================================================================    
-- SILENT AIM    
-- ================================================================    
local VelocityHistory = {}    
Run.Heartbeat:Connect(function()    
    for _, pl in ipairs(Players:GetPlayers()) do    
        if pl ~= L and pl.Character then    
            local root = pl.Character:FindFirstChild("HumanoidRootPart")    
            local hum = pl.Character:FindFirstChildOfClass("Humanoid")    
            if root and hum and hum.Health > 0 then    
                local h = VelocityHistory[pl] or {}    
                table.insert(h, { t=os.clock(), pos=root.Position })    
                if #h > 6 then table.remove(h, 1) end    
                VelocityHistory[pl] = h    
            else VelocityHistory[pl] = nil end    
        end    
    end    
end)    
Players.PlayerRemoving:Connect(function(pl)    
    VelocityHistory[pl] = nil    
    if TargetSticky.Locked == pl then TargetSticky.Locked = nil end    
end)    
    
local function getPing()    
    local pGui = L:FindFirstChild("PlayerGui")    
    if not pGui then return 0.2 end    
    local stats = pGui:FindFirstChild("NetworkStats")    
    if not stats then return 0.2 end    
    local lbl = stats:FindFirstChild("PingLabel")    
    if not lbl then return 0.2 end    
    local ms = tonumber(tostring(lbl.Text):match("%d+"))    
    if not ms then return 0.2 end    
    return math.clamp(ms / 1000, 0.04, 1.2)    
end    
    
local function predictTarget(part, offset)    
    if not part then return Vector3.zero end    
    offset = offset or Vector3.zero    
    local char = part.Parent    
    local pl = char and Players:GetPlayerFromCharacter(char)    
    local base = part.Position + offset    
    if not pl then return base end    
    local h = VelocityHistory[pl]    
    if not h or #h < 2 then return base end    
    local sum, n = Vector3.new(), 0    
    for i = 2, #h do    
        local dt = h[i].t - h[i-1].t    
        if dt > 0 then sum += (h[i].pos - h[i-1].pos) / dt; n += 1 end    
    end    
    if n == 0 then return base end    
    local vel = sum / n    
    local ping = getPing()    
    return base + (vel * ping * 1.2)    
end    
    
local currentTargetForHook = nil    
Run.RenderStepped:Connect(function()    
    if S.SilentAim or S.TargetLine then     
        currentTargetForHook = GetChinoStickyTarget(S.SA_FOV)    
    else     
        currentTargetForHook = nil     
    end    
end)    
    
local function applySilentAim(args)    
    if type(args) ~= "table" or not S.SilentAim or args[2] ~= "shoot_gun" then return args, nil end    
    local target = currentTargetForHook    
    if not target or not target.Character then return args, nil end    
    local targetPart, off = getBypassedTargetPart(target.Character, S.SilentAimHitPart or "Head")    
    if not targetPart then return args, nil end    
    local predicted = predictTarget(targetPart, off)    
    local myHead = L.Character and L.Character:FindFirstChild("Head")    
    if not myHead then return args, nil end    
    if args[4] ~= nil then    
        args[4] = CFrame.new(myHead.Position, predicted)    
        args[5] = {{ {Instance=targetPart, Normal=Vector3.new(0,1,0), Position=predicted} }}    
    end    
    return args, target    
end    
    
if SendRemote and type(hookfunction) == "function" then    
    pcall(function()    
        local oldFire    
        oldFire = hookfunction(SendRemote.FireServer, function(self, ...)    
            if self ~= SendRemote then return oldFire(self, ...) end    
            local args = { ... }    
            if S.SilentAim and args[2] == "shoot_gun" then    
                args = applySilentAim(args)    
            end    
            return oldFire(self, unpack(args))    
        end)    
    end)    
end    
    
-- ================================================================    
-- WEAPON DATABASE    
-- ================================================================    
local ItemsFolder = RS:FindFirstChild("Items")    
local RegisteredWeaponDB = {}    
local function registerFolderItems(folder)    
    if not folder then return end    
    for _, item in ipairs(folder:GetChildren()) do    
        if item:IsA("Tool") then    
            local handle = item:FindFirstChild("Handle")    
            local dName = item:GetAttribute("DisplayName") or item.Name    
            local iId = item:GetAttribute("ItemId") or item:GetAttribute("Id") or item.Name    
            local rarity = item:GetAttribute("RarityName") or "Common"    
            local img = item:GetAttribute("ImageId") or ""    
            local key    
            if handle then    
                local mesh = handle:FindFirstChildOfClass("SpecialMesh")    
                if mesh and mesh.MeshId ~= "" then key = mesh.MeshId .. (mesh.TextureId or "") .. "_RARITY_" .. rarity    
                elseif handle:IsA("MeshPart") and handle.MeshId ~= "" then key = handle.MeshId .. (handle.TextureID or "") .. "_RARITY_" .. rarity end    
            end    
            if not key and iId ~= "" and iId ~= item.Name then key = "ITEMID_" .. iId .. "_RARITY_" .. rarity end    
            if not key then key = "NAME_" .. dName .. "_" .. item.Name .. "_RARITY_" .. rarity end    
            RegisteredWeaponDB[key] = { Name=dName, Rarity=rarity, ImageId=img, ToolName=item.Name }    
        end    
    end    
end    
if ItemsFolder then    
    for _, sub in ipairs({"gun","melee","throwable","consumable","farming","misc","rod","fish"}) do    
        registerFolderItems(ItemsFolder:FindFirstChild(sub))    
    end    
end    
local function getWeaponData(tool)    
    if not tool or not tool:IsA("Tool") then return nil end    
    local handle = tool:FindFirstChild("Handle")    
    local dName = tool:GetAttribute("DisplayName") or tool.Name    
    local iId = tool:GetAttribute("ItemId") or tool:GetAttribute("Id") or tool.Name    
    local rarity = tool:GetAttribute("RarityName") or "Common"    
    local key    
    if handle then    
        local mesh = handle:FindFirstChildOfClass("SpecialMesh")    
        if mesh and mesh.MeshId ~= "" then key = mesh.MeshId .. (mesh.TextureId or "") .. "_RARITY_" .. rarity    
        elseif handle:IsA("MeshPart") and handle.MeshId ~= "" then key = handle.MeshId .. (handle.TextureID or "") .. "_RARITY_" .. rarity end    
    end    
    if not key and iId ~= "" and iId ~= tool.Name then key = "ITEMID_" .. iId .. "_RARITY_" .. rarity end    
    if not key then key = "NAME_" .. dName .. "_" .. tool.Name .. "_RARITY_" .. rarity end    
    return RegisteredWeaponDB[key]    
end    
    
-- ================================================================    
-- ESP    
-- ================================================================    
local ESPGui = Instance.new("ScreenGui")    
ESPGui.Name = "FRX_ESP"    
ESPGui.ResetOnSpawn = false    
ESPGui.IgnoreGuiInset = true    
ESPGui.DisplayOrder = 60    
ESPGui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling    
ESPGui.Parent = hudParent()    
    
local ModernESPObjects = {}    
local HighlightCache = {}    
local ESPNameTags = {}    
local ESPDistTags = {}    
local WeaponBillboardCache = {}    
local WeaponCacheTokens = {}    
    
local function projectBox(boxCF, boxSize)    
    local cam = workspace.CurrentCamera    
    if not cam then return nil end    
    local hx, hy, hz = boxSize.X*0.5, boxSize.Y*0.5, boxSize.Z*0.5    
    local minX, minY = math.huge, math.huge    
    local maxX, maxY = -math.huge, -math.huge    
    local visiblePoints = 0    
    for _, sx in ipairs({-1,1}) do    
        for _, sy in ipairs({-1,1}) do    
            for _, sz in ipairs({-1,1}) do    
                local world = boxCF:PointToWorldSpace(Vector3.new(hx*sx, hy*sy, hz*sz))    
                local sp = cam:WorldToViewportPoint(world)    
                if sp.Z > 0 then    
                    visiblePoints += 1    
                    minX = math.min(minX, sp.X); minY = math.min(minY, sp.Y)    
                    maxX = math.max(maxX, sp.X); maxY = math.max(maxY, sp.Y)    
                end    
            end    
        end    
    end    
    if visiblePoints == 0 or minX == math.huge or minY == math.huge then return nil end    
    return { Left=minX, Right=maxX, Top=minY, Bottom=maxY,    
        Width=math.max(8,maxX-minX), Height=math.max(12,maxY-minY),    
        Center=Vector2.new((minX+maxX)*0.5, (minY+maxY)*0.5) }    
end    
    
local VALID_BODY_PARTS = {    
    Head=true, HumanoidRootPart=true, Torso=true, UpperTorso=true, LowerTorso=true,    
    ["Left Arm"]=true, ["Right Arm"]=true, ["Left Leg"]=true, ["Right Leg"]=true,    
    LeftUpperArm=true, LeftLowerArm=true, LeftHand=true,    
    RightUpperArm=true, RightLowerArm=true, RightHand=true,    
    LeftUpperLeg=true, LeftLowerLeg=true, LeftFoot=true,    
    RightUpperLeg=true, RightLowerLeg=true, RightFoot=true,    
}    
    
local function getBounds(char)    
    local cam = workspace.CurrentCamera    
    if not cam or not char then return nil end    
    local root = char:FindFirstChild("HumanoidRootPart") or char:FindFirstChild("UpperTorso") or char:FindFirstChild("Torso")    
    local ok, cf, size = pcall(function() return char:GetBoundingBox() end)    
    if ok and cf and size then    
        local centerOffset = root and (cf.Position - root.Position).Magnitude or 0    
        local anomalous = size.X > 12 or size.Y > 14 or size.Z > 12 or centerOffset > 7    
        if not anomalous then return projectBox(cf, size) end    
    end    
    local minX, minY = math.huge, math.huge    
    local maxX, maxY = -math.huge, -math.huge    
    local visiblePoints = 0    
    for _, part in ipairs(char:GetChildren()) do    
        if part:IsA("BasePart") and VALID_BODY_PARTS[part.Name] then    
            if not root or (part.Position - root.Position).Magnitude <= 8 then    
                local safe = Vector3.new(math.min(part.Size.X,4.5), math.min(part.Size.Y,4.5), math.min(part.Size.Z,4.5))    
                local hx, hy, hz = safe.X*0.5, safe.Y*0.5, safe.Z*0.5    
                for _, sx in ipairs({-1,1}) do    
                    for _, sy in ipairs({-1,1}) do    
                        for _, sz in ipairs({-1,1}) do    
                            local world = part.CFrame:PointToWorldSpace(Vector3.new(hx*sx, hy*sy, hz*sz))    
                            local sp = cam:WorldToViewportPoint(world)    
                            if sp.Z > 0 then    
                                visiblePoints += 1    
                                minX = math.min(minX, sp.X); minY = math.min(minY, sp.Y)    
                                maxX = math.max(maxX, sp.X); maxY = math.max(maxY, sp.Y)    
                            end    
                        end    
                    end    
                end    
            end    
        end    
    end    
    if visiblePoints > 0 and minX ~= math.huge and minY ~= math.huge then    
        return { Left=minX, Right=maxX, Top=minY, Bottom=maxY,    
            Width=math.max(8,maxX-minX), Height=math.max(12,maxY-minY),    
            Center=Vector2.new((minX+maxX)*0.5, (minY+maxY)*0.5) }    
    end    
    if root then return projectBox(root.CFrame, Vector3.new(4,6.5,3)) end    
    return nil    
end    
    
local function buildESP(pl)    
    if pl == L then return nil end    
    if ModernESPObjects[pl] and ModernESPObjects[pl].Root and ModernESPObjects[pl].Root.Parent then return ModernESPObjects[pl] end    
    if ModernESPObjects[pl] and ModernESPObjects[pl].Root then pcall(function() ModernESPObjects[pl].Root:Destroy() end) end    
    local rootGui = Instance.new("Frame", ESPGui)    
    rootGui.Size = UDim2.fromScale(1,1)    
    rootGui.BackgroundTransparency = 1    
    rootGui.BorderSizePixel = 0    
    rootGui.ZIndex = 25    
    local box = Instance.new("Frame", rootGui)    
    box.BackgroundTransparency = 1    
    box.BorderSizePixel = 0    
    box.Visible = false    
    box.ZIndex = 25    
    local boxStroke = Instance.new("UIStroke", box)    
    boxStroke.Thickness = 1    
    boxStroke.Transparency = 0    
    boxStroke.Color = TargetHiddenColor    
    boxStroke.ApplyStrokeMode = Enum.ApplyStrokeMode.Border        
    local tracer = Instance.new("Frame", rootGui)    
    tracer.AnchorPoint = Vector2.new(0.5,0.5)    
    tracer.BackgroundColor3 = TargetHiddenColor    
    tracer.BorderSizePixel = 0    
    tracer.Visible = false    
    tracer.ZIndex = 24    
    Instance.new("UICorner", tracer).CornerRadius = UDim.new(1,0)    
    local hpBg = Instance.new("Frame", rootGui)    
    hpBg.BackgroundColor3 = HP_BG    
    hpBg.BackgroundTransparency = 0.15    
    hpBg.BorderSizePixel = 0    
    hpBg.Visible = false    
    hpBg.ZIndex = 26    
    Instance.new("UICorner", hpBg).CornerRadius = UDim.new(0,2)    
    local hpFill = Instance.new("Frame", hpBg)    
    hpFill.Size = UDim2.fromScale(1,1)    
    hpFill.BackgroundColor3 = HP_HI    
    hpFill.BorderSizePixel = 0    
    hpFill.ZIndex = 27    
    Instance.new("UICorner", hpFill).CornerRadius = UDim.new(0,2)    
    local hpText = Instance.new("TextLabel", hpBg)    
    hpText.Size = UDim2.fromScale(1,1)    
    hpText.BackgroundTransparency = 1    
    hpText.Font = Enum.Font.GothamBold    
    hpText.TextSize = 8    
    hpText.TextColor3 = Color3.new(1,1,1)    
    hpText.TextStrokeTransparency = 0    
    hpText.TextStrokeColor3 = Color3.new(0,0,0)    
    hpText.Text = "100/100"    
    hpText.ZIndex = 28    
    ModernESPObjects[pl] = {    
        Root=rootGui, Box=box, BoxStroke=boxStroke, Tracer=tracer,    
        HealthOutline=hpBg, HealthBar=hpFill, HealthText=hpText    
    }    
    return ModernESPObjects[pl]    
end    
    
local function hideModernESP(d)    
    if not d then return end    
    for _, k in ipairs({"Box","Tracer","HealthOutline","HealthBar","HealthText"}) do    
        if d[k] then d[k].Visible = false end    
    end    
end    
    
local function removePlayerESP(pl)    
    local d = ModernESPObjects[pl]    
    if d and d.Root then pcall(function() d.Root:Destroy() end) end    
    ModernESPObjects[pl] = nil    
    if HighlightCache[pl] then pcall(function() HighlightCache[pl]:Destroy() end); HighlightCache[pl]=nil end    
    if ESPNameTags[pl] then pcall(function() ESPNameTags[pl]:Destroy() end); ESPNameTags[pl]=nil end    
    if ESPDistTags[pl] then pcall(function() ESPDistTags[pl]:Destroy() end); ESPDistTags[pl]=nil end    
    if WeaponBillboardCache[pl] then pcall(function() WeaponBillboardCache[pl]:Destroy() end); WeaponBillboardCache[pl]=nil end    
    if WeaponCacheTokens[pl] then WeaponCacheTokens[pl]=nil end    
end    
    
for _, pl in ipairs(Players:GetPlayers()) do buildESP(pl) end    
Players.PlayerAdded:Connect(buildESP)    
Players.PlayerRemoving:Connect(removePlayerESP)    
    
-- FRX FIXED WEAPON ESP LOOP    
task.spawn(function()    
    while ESPGui and ESPGui.Parent do    
        task.wait(0.12)    
        if S.ESP_Weapon then    
            for _, pl in ipairs(Players:GetPlayers()) do    
                if pl ~= L and pl.Character and not IsSafeFriend(pl) then    
                    local char = pl.Character    
                    local root = char:FindFirstChild("HumanoidRootPart") or char.PrimaryPart or char:FindFirstChildWhichIsA("BasePart")    
                    if root then    
                        local display = {}    
                        local fingerprint = {}    
                            
                        local function scanContainer(container)    
                            if not container then return end    
                            for _, tool in ipairs(container:GetChildren()) do    
                                if tool:IsA("Tool") and tool.Name ~= "Fists" then    
                                    local db = getWeaponData(tool)    
                                    local isGun = tool:GetAttribute("AmmoType") ~= nil or (db and db.Name ~= nil)    
                                    if isGun then    
                                        local icon = (db and db.ImageId) or ""    
                                        if type(icon) == "string" and icon ~= "" then    
                                            if icon:match("^%d+$") then icon = "rbxassetid://" .. icon end    
                                            local rarity = (db and db.Rarity) or "Common"    
                                            table.insert(display, {Icon=icon, Rarity=rarity})    
                                            table.insert(fingerprint, icon..":"..rarity)    
                                        end    
                                    end    
                                end    
                            end    
                        end    
                        scanContainer(char)    
                        scanContainer(pl:FindFirstChild("Backpack"))    
                            
                        local token = table.concat(fingerprint, "|")    
                        local bg = WeaponBillboardCache[pl]    
                        if not bg or not bg.Parent or bg.Adornee ~= root then    
                            if bg then pcall(function() bg:Destroy() end) end    
                            bg = Instance.new("BillboardGui", PG)    
                            bg.Name = "WeaponESP_" .. pl.Name    
                            bg.Adornee = root    
                            bg.Size = UDim2.new(0, 140, 0, 18)    
                            bg.StudsOffset = Vector3.new(0, 8, 0)    
                            bg.AlwaysOnTop = true    
                            bg.MaxDistance = S.ESP_MaxRange or 1000000    
                            bg.LightInfluence = 0    
                            WeaponBillboardCache[pl] = bg    
                            WeaponCacheTokens[pl] = nil    
                        end    
                            
                        if WeaponCacheTokens[pl] ~= token then    
                            WeaponCacheTokens[pl] = token    
                            bg:ClearAllChildren()    
                            local layout = Instance.new("UIListLayout", bg)    
                            layout.FillDirection = Enum.FillDirection.Horizontal    
                            layout.HorizontalAlignment = Enum.HorizontalAlignment.Center    
                            layout.Padding = UDim.new(0, 4)    
                            for i = 1, math.min(#display, 8) do    
                                local item = display[i]    
                                local iconLbl = Instance.new("ImageLabel", bg)    
                                iconLbl.Size = UDim2.fromOffset(16, 16)    
                                iconLbl.BackgroundTransparency = 1    
                                iconLbl.Image = item.Icon    
                                iconLbl.ScaleType = Enum.ScaleType.Fit    
                                Instance.new("UICorner", iconLbl).CornerRadius = UDim.new(0, 6)    
                                local border = Instance.new("UIStroke", iconLbl)    
                                border.Color = RarityColors[item.Rarity] or Color3.fromRGB(255,255,255)    
                                border.Thickness = 1.5    
                            end    
                        end    
                        if bg then bg.Enabled = true end    
                    end    
                end    
            end    
        else    
            for pl, bg in pairs(WeaponBillboardCache) do    
                if bg then bg.Enabled = false end    
            end    
        end    
    end    
end)    
    
Run.RenderStepped:Connect(function(dt)    
    local cam = workspace.CurrentCamera    
    if not cam then     
        for _, d in pairs(ModernESPObjects) do hideModernESP(d) end    
        HideNewTargetVisuals()    
        return     
    end    
    local vp = cam.ViewportSize    
    local tracerFromX, tracerFromY = vp.X/2, vp.Y - 2    
    local myRoot = L.Character and L.Character:FindFirstChild("HumanoidRootPart")    
        
    for pl, d in pairs(ModernESPObjects) do    
        local char = pl.Character    
        local hum = char and char:FindFirstChildOfClass("Humanoid")    
        local rp = char and (char:FindFirstChild("HumanoidRootPart") or char.PrimaryPart)    
        if not char or not hum or hum.Health <= 0 or not rp then    
            hideModernESP(d)    
            if HighlightCache[pl] then HighlightCache[pl].Enabled = false end    
            if ESPNameTags[pl] then ESPNameTags[pl].Enabled = false end    
            if ESPDistTags[pl] then ESPDistTags[pl].Enabled = false end    
            continue    
        end    
        local bounds = getBounds(char)    
        if not bounds then hideModernESP(d); continue end    
        local visualPart = char:FindFirstChild("UpperTorso") or char:FindFirstChild("Torso") or rp    
        local visible = isDirectVisible(char, visualPart)    
        local color = visible and TargetVisibleColor or TargetHiddenColor    
        local isFriendly = S.Friends[pl.Name] == true or IsSafeFriend(pl)    
        if S.ESP_Box and not isFriendly then    
            d.Box.Position = UDim2.fromOffset(bounds.Center.X - bounds.Width/2 + S.ESP_OffsetX, bounds.Top + S.ESP_OffsetY)    
            d.Box.Size = UDim2.fromOffset(bounds.Width, bounds.Height)    
            d.BoxStroke.Color = color    
            d.Box.Visible = true    
        else d.Box.Visible = false end    
        if S.ESP_Lines and not isFriendly then    
            local toX = bounds.Center.X + S.ESP_OffsetX    
            local toY = bounds.Center.Y + S.ESP_OffsetY    
            local dx, dy = toX - tracerFromX, toY - tracerFromY    
            local len = math.sqrt(dx*dx + dy*dy)    
            d.Tracer.Position = UDim2.fromOffset((tracerFromX + toX)/2, (tracerFromY + toY)/2)    
            d.Tracer.Size = UDim2.fromOffset(len, S.ESP_LineThickness)    
            d.Tracer.Rotation = math.deg(math.atan2(dy, dx))    
            d.Tracer.BackgroundColor3 = color    
            d.Tracer.Visible = true    
        else d.Tracer.Visible = false end    
        if S.ESP_Health and not isFriendly then    
            local pct = math.clamp(hum.Health / math.max(hum.MaxHealth, 1), 0, 1)    
            local barW, barH = 66, 8    
            local barX = bounds.Center.X - barW/2 + S.ESP_OffsetX    
            local barY = bounds.Bottom + 3 + S.ESP_OffsetY    
            d.HealthOutline.Position = UDim2.fromOffset(barX, barY)    
            d.HealthOutline.Size = UDim2.fromOffset(barW, barH)    
            d.HealthOutline.Visible = true    
            d.HealthBar.Size = UDim2.fromScale(pct, 1)    
            d.HealthBar.BackgroundColor3 = pct > 0.6 and HP_HI or pct > 0.3 and HP_MID or HP_LO    
            d.HealthBar.Visible = true    
            d.HealthText.Text = string.format("%d/%d", math.floor(hum.Health + 0.5), math.floor(hum.MaxHealth + 0.5))    
            d.HealthText.Visible = true    
        else    
            d.HealthOutline.Visible = false; d.HealthBar.Visible = false; d.HealthText.Visible = false    
        end    
        if S.ESP_Highlight and not isFriendly then    
            local hl = HighlightCache[pl]    
            if not hl or not hl.Parent or hl.Adornee ~= char then    
                if hl then hl:Destroy() end    
                hl = Instance.new("Highlight")    
                hl.Adornee = char    
                hl.FillColor = Color3.fromRGB(135,150,255)    
                hl.FillTransparency = 0.5    
                hl.OutlineColor = Color3.fromRGB(200,210,255)    
                hl.OutlineTransparency = 0.3    
                hl.DepthMode = Enum.HighlightDepthMode.AlwaysOnTop    
                hl.Parent = char    
                HighlightCache[pl] = hl    
            end    
            hl.Enabled = true    
        elseif HighlightCache[pl] then HighlightCache[pl].Enabled = false end    
        if S.ESP_Name then    
            local tag = ESPNameTags[pl]    
            if not tag or not tag.Parent or tag.Adornee ~= rp then    
                if tag then tag:Destroy() end    
                tag = Instance.new("BillboardGui")    
                tag.Adornee = rp    
                tag.Size = UDim2.new(0,140,0,16)    
                tag.StudsOffset = Vector3.new(0,2.6,0)    
                tag.AlwaysOnTop = true    
                tag.MaxDistance = S.ESP_MaxRange    
                tag.Parent = PG    
                local lbl = Instance.new("TextLabel", tag)    
                lbl.Name = "Label"    
                lbl.Size = UDim2.fromScale(1,1)    
                lbl.BackgroundTransparency = 1    
                lbl.TextColor3 = Color3.new(1,1,1)    
                lbl.TextStrokeTransparency = 0.2    
                lbl.TextSize = 11    
                lbl.Font = Enum.Font.GothamBold    
                ESPNameTags[pl] = tag    
            end    
            tag.Enabled = true    
            tag.MaxDistance = S.ESP_MaxRange    
            local lbl = tag:FindFirstChild("Label")    
            if lbl then    
                lbl.Text = pl.DisplayName ~= "" and pl.DisplayName or pl.Name    
                lbl.TextColor3 = isFriendly and Color3.fromRGB(46,245,109) or Color3.new(1,1,1)    
            end    
        elseif ESPNameTags[pl] then ESPNameTags[pl].Enabled = false end    
        if S.ESP_Dist then    
            local tag = ESPDistTags[pl]    
            if not tag or not tag.Parent or tag.Adornee ~= rp then    
                if tag then tag:Destroy() end    
                tag = Instance.new("BillboardGui")    
                tag.Adornee = rp    
                tag.Size = UDim2.new(0,100,0,14)    
                tag.StudsOffset = Vector3.new(0,2.15,0)    
                tag.AlwaysOnTop = true    
                tag.MaxDistance = S.ESP_MaxRange    
                tag.Parent = PG    
                local lbl = Instance.new("TextLabel", tag)    
                lbl.Name = "Label"    
                lbl.Size = UDim2.fromScale(1,1)    
                lbl.BackgroundTransparency = 1    
                lbl.TextColor3 = Color3.fromRGB(230,230,240)    
                lbl.TextSize = 9    
                lbl.Font = Enum.Font.Gotham    
                ESPDistTags[pl] = tag    
            end    
            tag.Enabled = true    
            tag.MaxDistance = S.ESP_MaxRange    
            local lbl = tag:FindFirstChild("Label")    
            if lbl then    
                local dist = myRoot and (rp.Position - myRoot.Position).Magnitude or 0    
                lbl.Text = string.format("%.0f m", dist * 0.28)    
            end    
        elseif ESPDistTags[pl] then ESPDistTags[pl].Enabled = false end    
    end    
    
    local visualTarget = S.TargetLine and currentTargetForHook or nil    
    if IsSafeFriend(visualTarget) then visualTarget = nil end    
    
    if Gui.Enabled and S.TargetLine and visualTarget and visualTarget.Character and L.Character then    
        local myHead = L.Character:FindFirstChild("Head") or L.Character:FindFirstChild("HumanoidRootPart")    
        local targetChar = visualTarget.Character    
        local targetPart, targetOffset = getBypassedTargetPart(targetChar, S.SilentAimHitPart or "Head")    
        if not targetPart then    
            targetPart = targetChar:FindFirstChild("UpperTorso") or targetChar:FindFirstChild("Torso") or targetChar:FindFirstChild("HumanoidRootPart") or targetChar:FindFirstChild("Head")    
            targetOffset = Vector3.zero    
        end    
    
        if myHead and targetPart then    
            local from3, fromOnScreen = cam:WorldToViewportPoint(myHead.Position)    
            local to3, toOnScreen = cam:WorldToViewportPoint(targetPart.Position + targetOffset)    
            local targetBounds = GetProjectedCharacterBounds(targetChar)    
    
            if toOnScreen and to3.Z > 0 and targetBounds then    
                local from = (fromOnScreen and from3.Z > 0)    
                    and Vector2.new(from3.X + 61, from3.Y + 10)    
                    or Vector2.new((vp.X / 2) + 61, (vp.Y / 2) + 10)    
    
                local to = Vector2.new(    
                    targetBounds.Center.X + S.ESP_OffsetX,    
                    targetBounds.Center.Y + S.ESP_OffsetY    
                )    
    
                local diff = to - from    
                local len = diff.Magnitude    
                if len > 0.001 then    
                    TargetLine.Position = UDim2.fromOffset((from.X + to.X) / 2, (from.Y + to.Y) / 2)    
                    TargetLine.Size = UDim2.fromOffset(len, TargetLineThickness)    
                    TargetLine.Rotation = math.deg(math.atan2(diff.Y, diff.X))    
                    TargetLine.Visible = true    
                else    
                    TargetLine.Visible = false    
                end    
    
                TargetOctagon.Position = UDim2.fromOffset(to.X, to.Y)    
                TargetOctagon.Visible = true    
                TargetArrow.Adornee = targetChar:FindFirstChild("Head") or targetPart    
                TargetArrow.Enabled = TargetArrow.Adornee ~= nil    
    
                local targetVisible = isDirectVisible(targetChar, targetPart)    
                SetNewTargetColor(targetVisible)    
                AnimateNewTargetFX(dt)    
            else    
                HideNewTargetVisuals()    
            end    
        else    
            HideNewTargetVisuals()    
        end    
    else    
        HideNewTargetVisuals()    
    end    
end)    
    
-- ================================================================    
-- GUI    
-- ================================================================    
local pill = Instance.new("TextButton", Gui)    
pill.Size = UDim2.fromOffset(175, 34)    
pill.Position = UDim2.new(0, 12, 0, 12)    
pill.BackgroundColor3 = Color3.fromRGB(20,20,24)    
pill.BackgroundTransparency = 0.15    
pill.BorderSizePixel = 0    
pill.Text = "FRX X BLOCKSPIN"    
pill.TextColor3 = Color3.new(1,1,1)    
pill.Font = Enum.Font.GothamBold    
pill.TextSize = 13    
pill.AutoButtonColor = false    
Instance.new("UICorner", pill).CornerRadius = UDim.new(1,0)    
local pStroke = Instance.new("UIStroke", pill)    
pStroke.Color = Color3.fromRGB(180,20,20)    
pStroke.Thickness = 1.5    
    
local panel = Instance.new("Frame", Gui)    
panel.Position = UDim2.new(0, 12, 0, 54)    
panel.Size = UDim2.fromOffset(280, 430)    
panel.BackgroundColor3 = Color3.fromRGB(14,14,18)    
panel.BackgroundTransparency = 0    
panel.BorderSizePixel = 0    
panel.Visible = true    
panel.ClipsDescendants = true    
Instance.new("UICorner", panel).CornerRadius = UDim.new(0,12)    
local panelStroke = Instance.new("UIStroke", panel)    
panelStroke.Color = Color3.fromRGB(180,20,20)    
panelStroke.Thickness = 1.5    
    
local panelBg = Instance.new("ImageLabel", panel)    
panelBg.Name = "FRX_Background"    
panelBg.Size = UDim2.fromScale(1, 1)    
panelBg.Position = UDim2.fromScale(0, 0)    
panelBg.BackgroundTransparency = 1    
panelBg.ScaleType = Enum.ScaleType.Crop    
panelBg.Image = "rbxthumb://type=Asset&id=118906140821224&w=420&h=420"    
panelBg.ZIndex = 1    
Instance.new("UICorner", panelBg).CornerRadius = UDim.new(0, 12)    
    
local overlay = Instance.new("Frame", panel)    
overlay.Name = "FRX_Overlay"    
overlay.Size = UDim2.fromScale(1, 1)    
overlay.Position = UDim2.fromScale(0, 0)    
overlay.BackgroundColor3 = Color3.fromRGB(10, 10, 14)    
overlay.BackgroundTransparency = 0.55    
overlay.BorderSizePixel = 0    
overlay.ZIndex = 1    
Instance.new("UICorner", overlay).CornerRadius = UDim.new(0, 12)    
    
local title = Instance.new("TextLabel", panel)    
title.Size = UDim2.new(1, -20, 0, 26)    
title.Position = UDim2.fromOffset(10, 8)    
title.BackgroundTransparency = 1    
title.Text = "FRX X BLOCKSPIN"    
title.TextColor3 = Color3.new(1,1,1)    
title.Font = Enum.Font.GothamBold    
title.TextSize = 13    
title.TextXAlignment = Enum.TextXAlignment.Left    
title.ZIndex = 2    
    
local scroll = Instance.new("ScrollingFrame", panel)    
scroll.ZIndex = 2    
scroll.Position = UDim2.fromOffset(6, 40)    
scroll.Size = UDim2.new(1, -12, 1, -46)    
scroll.BackgroundTransparency = 1    
scroll.BorderSizePixel = 0    
scroll.ScrollBarThickness = 3    
scroll.ScrollBarImageColor3 = Color3.fromRGB(180,20,20)    
scroll.CanvasSize = UDim2.new(0,0,0,0)    
local list = Instance.new("UIListLayout", scroll)    
list.Padding = UDim.new(0,4)    
list.SortOrder = Enum.SortOrder.LayoutOrder    
list:GetPropertyChangedSignal("AbsoluteContentSize"):Connect(function()    
    scroll.CanvasSize = UDim2.new(0,0,0, list.AbsoluteContentSize.Y + 6)    
end)    
    
local function Section(text)    
    local l = Instance.new("TextLabel", scroll)    
    l.Size = UDim2.new(1,-8,0,20)    
    l.BackgroundTransparency = 1    
    l.Text = text    
    l.TextColor3 = Color3.fromRGB(190,190,205)    
    l.Font = Enum.Font.GothamBold    
    l.TextSize = 11    
    l.TextXAlignment = Enum.TextXAlignment.Left    
end    
    
local function Toggle(titleText, key, cb)    
    local row = Instance.new("Frame", scroll)    
    row.Size = UDim2.new(1,-8,0,28)    
    row.BackgroundColor3 = Color3.fromRGB(24,24,30)    
    row.BackgroundTransparency = 0.15    
    row.BorderSizePixel = 0    
    Instance.new("UICorner", row).CornerRadius = UDim.new(0,6)    
    local lbl = Instance.new("TextLabel", row)    
    lbl.Size = UDim2.new(1,-48,1,0)    
    lbl.Position = UDim2.fromOffset(8,0)    
    lbl.BackgroundTransparency = 1    
    lbl.Text = titleText    
    lbl.TextColor3 = Color3.new(1,1,1)    
    lbl.Font = Enum.Font.Gotham    
    lbl.TextSize = 11    
    lbl.TextXAlignment = Enum.TextXAlignment.Left    
    local btn = Instance.new("TextButton", row)    
    btn.Size = UDim2.fromOffset(34,18)    
    btn.Position = UDim2.new(1,-42,0.5,-9)    
    btn.BackgroundColor3 = S[key] and Color3.fromRGB(180,20,20) or Color3.fromRGB(45,45,55)    
    btn.Text = ""    
    btn.AutoButtonColor = false    
    btn.BorderSizePixel = 0    
    Instance.new("UICorner", btn).CornerRadius = UDim.new(1,0)    
    local knob = Instance.new("Frame", btn)    
    knob.Size = UDim2.fromOffset(14,14)    
    knob.Position = S[key] and UDim2.new(1,-16,0.5,-7) or UDim2.fromOffset(2,2)    
    knob.BackgroundColor3 = Color3.new(1,1,1)    
    knob.BorderSizePixel = 0    
    Instance.new("UICorner", knob).CornerRadius = UDim.new(1,0)    
    btn.Activated:Connect(function()    
        S[key] = not S[key]    
        save()    
        btn.BackgroundColor3 = S[key] and Color3.fromRGB(180,20,20) or Color3.fromRGB(45,45,55)    
        knob.Position = S[key] and UDim2.new(1,-16,0.5,-7) or UDim2.fromOffset(2,2)    
        if cb then cb(S[key]) end    
    end)    
end    
    
local function Slider(titleText, key, mn, mx, step, cb)    
    local row = Instance.new("Frame", scroll)    
    row.Size = UDim2.new(1,-8,0,44)    
    row.BackgroundColor3 = Color3.fromRGB(24,24,30)    
    row.BackgroundTransparency = 0.15    
    row.BorderSizePixel = 0    
    Instance.new("UICorner", row).CornerRadius = UDim.new(0,6)    
        
    local isLocked = (key == "ESP_OffsetX" or key == "ESP_OffsetY")    
    
    local lbl = Instance.new("TextLabel", row)    
    lbl.Size = UDim2.new(1,-60,0,16)    
    lbl.Position = UDim2.fromOffset(8,4)    
    lbl.BackgroundTransparency = 1    
    lbl.Text = titleText    
    lbl.TextColor3 = Color3.new(1,1,1)    
    lbl.Font = Enum.Font.Gotham    
    lbl.TextSize = 11    
    lbl.TextXAlignment = Enum.TextXAlignment.Left    
    
    local valLbl = Instance.new("TextLabel", row)    
    valLbl.Size = UDim2.fromOffset(50,16)    
    valLbl.Position = UDim2.new(1,-58,0,4)    
    valLbl.BackgroundTransparency = 1    
    valLbl.Text = tostring(S[key])    
    valLbl.TextColor3 = Color3.fromRGB(200,200,220)    
    valLbl.Font = Enum.Font.GothamBold    
    valLbl.TextSize = 11    
    valLbl.TextXAlignment = Enum.TextXAlignment.Right    
    
    local bar = Instance.new("Frame", row)    
    bar.Size = UDim2.new(1,-16,0,6)    
    bar.Position = UDim2.fromOffset(8,28)    
    bar.BackgroundColor3 = Color3.fromRGB(45,45,55)    
    bar.BorderSizePixel = 0    
    Instance.new("UICorner", bar).CornerRadius = UDim.new(1,0)    
    
    local fill = Instance.new("Frame", bar)    
    fill.BackgroundColor3 = Color3.fromRGB(180,20,20)    
    fill.BorderSizePixel = 0    
    Instance.new("UICorner", fill).CornerRadius = UDim.new(1,0)    
    fill.Size = UDim2.new((S[key]-mn)/(mx-mn), 0, 1, 0)    
    
    if isLocked then    
        row.BackgroundTransparency = 0.4    
        bar.BackgroundTransparency = 0.5    
        fill.BackgroundTransparency = 0.5    
        return    
    end    
    
    local dragging = false    
    local function setFromX(x)    
        local a = math.clamp((x - bar.AbsolutePosition.X) / math.max(bar.AbsoluteSize.X, 1), 0, 1)    
        local v = mn + (mx-mn) * a    
        v = math.floor(v/step + 0.5)*step    
        v = math.clamp(v, mn, mx)    
        S[key] = v    
        fill.Size = UDim2.new(a,0,1,0)    
        valLbl.Text = tostring(v)    
        save()    
        if cb then cb(v) end    
    end    
    bar.InputBegan:Connect(function(i)    
        if i.UserInputType == Enum.UserInputType.MouseButton1 or i.UserInputType == Enum.UserInputType.Touch then    
            dragging = true    
            setFromX(i.Position.X)    
        end    
    end)    
    UIS.InputChanged:Connect(function(i)    
        if dragging and (i.UserInputType == Enum.UserInputType.MouseMovement or i.UserInputType == Enum.UserInputType.Touch) then    
            setFromX(i.Position.X)    
        end    
    end)    
    UIS.InputEnded:Connect(function(i)    
        if i.UserInputType == Enum.UserInputType.MouseButton1 or i.UserInputType == Enum.UserInputType.Touch then    
            dragging = false    
        end    
    end)    
end    
    
local function Dropdown(titleText, key, values, cb)    
    local row = Instance.new("Frame", scroll)    
    row.Size = UDim2.new(1,-8,0,28)    
    row.BackgroundColor3 = Color3.fromRGB(24,24,30)    
    row.BackgroundTransparency = 0.15    
    row.BorderSizePixel = 0    
    Instance.new("UICorner", row).CornerRadius = UDim.new(0,6)    
    local lbl = Instance.new("TextLabel", row)    
    lbl.Size = UDim2.new(0.5,-8,1,0)    
    lbl.Position = UDim2.fromOffset(8,0)    
    lbl.BackgroundTransparency = 1    
    lbl.Text = titleText    
    lbl.TextColor3 = Color3.new(1,1,1)    
    lbl.Font = Enum.Font.Gotham    
    lbl.TextSize = 11    
    lbl.TextXAlignment = Enum.TextXAlignment.Left    
    local valBtn = Instance.new("TextButton", row)    
    valBtn.Size = UDim2.new(0.5,-8,0,20)    
    valBtn.Position = UDim2.new(0.5,0,0.5,-10)    
    valBtn.BackgroundColor3 = Color3.fromRGB(45,45,55)    
    valBtn.Text = tostring(S[key])    
    valBtn.TextColor3 = Color3.new(1,1,1)    
    valBtn.Font = Enum.Font.GothamBold    
    valBtn.TextSize = 11    
    valBtn.AutoButtonColor = false    
    valBtn.BorderSizePixel = 0    
    Instance.new("UICorner", valBtn).CornerRadius = UDim.new(0,5)    
    local idx = table.find(values, S[key]) or 1    
    valBtn.Activated:Connect(function()    
        idx = idx % #values + 1    
        S[key] = values[idx]    
        valBtn.Text = tostring(S[key])    
        save()    
        if cb then cb(S[key]) end    
    end)    
end    
    
local function SafeFriendsMenu()    
    local btn = Instance.new("TextButton", scroll)    
    btn.Size = UDim2.new(1, -8, 0, 28)    
    btn.BackgroundColor3 = Color3.fromRGB(24, 24, 30)    
    btn.BackgroundTransparency = 0.15    
    btn.BorderSizePixel = 0    
    btn.Text = "Select Safe Friends"    
    btn.TextColor3 = Color3.new(1, 1, 1)    
    btn.Font = Enum.Font.GothamBold    
    btn.TextSize = 11    
    Instance.new("UICorner", btn).CornerRadius = UDim.new(0, 6)    
    
    local popup = Instance.new("Frame", Gui)    
    popup.Size = UDim2.fromOffset(220, 260)    
    popup.Position = UDim2.new(0.5, -110, 0.5, -130)    
    popup.BackgroundColor3 = Color3.fromRGB(18, 18, 22)    
    popup.BorderSizePixel = 0    
    popup.Visible = false    
    popup.ZIndex = 100    
    Instance.new("UICorner", popup).CornerRadius = UDim.new(0, 10)    
    
    local titleLbl = Instance.new("TextLabel", popup)    
    titleLbl.Size = UDim2.new(1, 0, 0, 30)    
    titleLbl.BackgroundTransparency = 1    
    titleLbl.Text = "Safe Friends"    
    titleLbl.TextColor3 = Color3.new(1, 1, 1)    
    titleLbl.Font = Enum.Font.GothamBold    
    titleLbl.TextSize = 14    
    titleLbl.ZIndex = 101    
    
    local closeBtn = Instance.new("TextButton", popup)    
    closeBtn.Size = UDim2.fromOffset(30, 30)    
    closeBtn.Position = UDim2.new(1, -30, 0, 0)    
    closeBtn.BackgroundTransparency = 1    
    closeBtn.Text = "X"    
    closeBtn.TextColor3 = Color3.fromRGB(255, 80, 80)    
    closeBtn.Font = Enum.Font.GothamBold    
    closeBtn.TextSize = 14    
    closeBtn.ZIndex = 101    
    
    local listScroll = Instance.new("ScrollingFrame", popup)    
    listScroll.Size = UDim2.new(1, -10, 1, -80)    
    listScroll.Position = UDim2.fromOffset(5, 35)    
    listScroll.BackgroundTransparency = 1    
    listScroll.BorderSizePixel = 0    
    listScroll.ScrollBarThickness = 3    
    listScroll.ZIndex = 101    
    
    local listLayout = Instance.new("UIListLayout", listScroll)    
    listLayout.Padding = UDim.new(0, 4)    
    listLayout.SortOrder = Enum.SortOrder.LayoutOrder    
    
    local clearBtn = Instance.new("TextButton", popup)    
    clearBtn.Size = UDim2.new(1, -20, 0, 28)    
    clearBtn.Position = UDim2.new(0, 10, 1, -36)    
    clearBtn.BackgroundColor3 = Color3.fromRGB(180, 20, 20)    
    clearBtn.BorderSizePixel = 0    
    clearBtn.Text = "Clear All"    
    clearBtn.TextColor3 = Color3.new(1, 1, 1)    
    clearBtn.Font = Enum.Font.GothamBold    
    clearBtn.TextSize = 12    
    clearBtn.ZIndex = 101    
    Instance.new("UICorner", clearBtn).CornerRadius = UDim.new(0, 6)    
    
    local function updateList()    
        for _, child in ipairs(listScroll:GetChildren()) do    
            if child:IsA("TextButton") then child:Destroy() end    
        end    
        for _, plr in ipairs(Players:GetPlayers()) do    
            if plr ~= L then    
                local isSelected = S.Friends[plr.Name] == true    
                local item = Instance.new("TextButton", listScroll)    
                item.Size = UDim2.new(1, -5, 0, 28)    
                item.BackgroundColor3 = isSelected and Color3.fromRGB(40, 120, 40) or Color3.fromRGB(30, 30, 40)    
                item.BorderSizePixel = 0    
                item.Text = (isSelected and "✅ " or "❌ ") .. plr.Name    
                item.TextColor3 = Color3.new(1, 1, 1)    
                item.Font = Enum.Font.Gotham    
                item.TextSize = 11    
                item.TextXAlignment = Enum.TextXAlignment.Left    
                item.ZIndex = 102    
                Instance.new("UICorner", item).CornerRadius = UDim.new(0, 6)    
    
                item.Activated:Connect(function()    
                    S.Friends[plr.Name] = not isSelected    
                    save()    
                    updateList()    
                end)    
            end    
        end    
    end    
    
    btn.Activated:Connect(function()    
        popup.Visible = not popup.Visible    
        if popup.Visible then updateList() end    
    end)    
    closeBtn.Activated:Connect(function() popup.Visible = false end)    
    clearBtn.Activated:Connect(function()    
        S.Friends = {}    
        save()    
        updateList()    
    end)    
end    
    
Section("Silent Aim")    
SafeFriendsMenu()    
Toggle("Silent Aim", "SilentAim", function(v) S.SilentAim = v end)    
Toggle("Target Line", "TargetLine", function(v) S.TargetLine = v end)    
Dropdown("Hit Part", "SilentAimHitPart", {"Head","Neck","Chest"})    
Slider("FOV Radius", "SA_FOV", 20, 800, 5)    
Slider("Sticky Turn", "StickyTurn", 5, 45, 1)    
Slider("Sticky Ratio", "StickyRatio", 0.2, 0.9, 0.05)    
Slider("Sticky Min Pix", "StickyMinPix", 20, 300, 5)    
    
Section("ESP")    
Toggle("ESP Box", "ESP_Box")    
Toggle("ESP Lines", "ESP_Lines")    
Toggle("ESP Highlight", "ESP_Highlight")    
Toggle("ESP Names", "ESP_Name")    
Toggle("ESP Health", "ESP_Health")    
Toggle("ESP Distance", "ESP_Dist")    
Toggle("ESP Weapons", "ESP_Weapon")    
Toggle("ESP Items", "ESP_Item")    
Slider("ESP Range", "ESP_MaxRange", 100, 1000000, 100)    
Slider("ESP Size", "ESP_Size", 0.6, 2, 0.05)    
Slider("ESP Line Width", "ESP_LineThickness", 1, 5, 1)    
Slider("ESP Offset X", "ESP_OffsetX", -50, 50, 1)    
Slider("ESP Offset Y", "ESP_OffsetY", -50, 50, 1)    
    
Section("FRX SYSTEM")    
Toggle("Skip Crates", "SkipCrates", function(v)    
    SkipCratesEnabled = v    
    SkipCratesAPI.SetEnabled(v)    
end)    
Toggle("Auto Pickup", "AutoPickup", function(v)    
    AutoPickupEnabled = v    
    ak = v    
end)    
Slider("Pickup Radius", "AutoPickupRadius", 20, 500, 5, function(v)    
    AutoPickupRadius = v    
end)    
    
pill.Activated:Connect(function()    
    panel.Visible = not panel.Visible    
end)    
    
do    
    local dragging, start, pos = false, nil, nil    
    pill.InputBegan:Connect(function(i)    
        if i.UserInputType == Enum.UserInputType.MouseButton1 or i.UserInputType == Enum.UserInputType.Touch then    
            dragging, start, pos = true, i.Position, pill.Position    
        end    
    end)    
    UIS.InputChanged:Connect(function(i)    
        if dragging and (i.UserInputType == Enum.UserInputType.MouseMovement or i.UserInputType == Enum.UserInputType.Touch) then    
            local d = i.Position - start    
            pill.Position = UDim2.new(pos.X.Scale, pos.X.Offset + d.X, pos.Y.Scale, pos.Y.Offset + d.Y)    
            panel.Position = UDim2.new(pill.Position.X.Scale, pill.Position.X.Offset, pill.Position.Y.Scale, pill.Position.Y.Offset + 42)    
        end    
    end)    
    UIS.InputEnded:Connect(function(i)    
        if i.UserInputType == Enum.UserInputType.MouseButton1 or i.UserInputType == Enum.UserInputType.Touch then    
            dragging = false    
        end    
    end)    
end    
--============================================================--  
-- FRX | TOUCH PANEL (SLIDER + LIVE DEPTH EDIT + BLACK BG)  
--============================================================--  
  
if not game:IsLoaded() then repeat task.wait() until game:IsLoaded() end  
  
local Players = game:GetService("Players")  
local RunService = game:GetService("RunService")  
local UserInputService = game:GetService("UserInputService")  
local TweenService = game:GetService("TweenService")  
local Player = Players.LocalPlayer  
local PlayerGui = Player:WaitForChild("PlayerGui")  
local Camera = workspace.CurrentCamera  
  
local COLORS = {  
    Blue = Color3.fromRGB(45, 155, 255),  
    White = Color3.fromRGB(235, 245, 255),  
    Glass = Color3.fromRGB(7, 18, 32),  
}  
  
local SettingsVisual = {}  
SettingsVisual.ExecutorGuiParent = PlayerGui  
SettingsVisual.TouchPanelKey = Enum.KeyCode.Z  
SettingsVisual.TouchLeftBoxKey = Enum.KeyCode.X  
SettingsVisual.TouchRightBoxKey = Enum.KeyCode.C  
SettingsVisual.TouchPanelUpMode = false  
SettingsVisual.TouchRightDroppedItemsEnabled = false  
SettingsVisual.VehicleRarityModeEnabled = false  
SettingsVisual.VehicleRarityTarget = nil  
SettingsVisual.VehicleRarityArrived = false  
SettingsVisual.VehicleRarityAvoidSide = 0  
SettingsVisual.VehicleRarityAvoidUntil = 0  
SettingsVisual.VehicleRarityStopDistance = 18  
SettingsVisual.VehicleRarityResumeDistance = 28  
SettingsVisual.VehicleRarityObstacleDistance = 22  
SettingsVisual.VehicleRarityAvoidAngle = 58  
SettingsVisual.SelectedVehiclePlayer = nil  
SettingsVisual.VehicleForwardMaxSpeed = 90  
SettingsVisual.VehicleReverseMaxSpeed = 90  
SettingsVisual.VehicleAcceleration = 200  
SettingsVisual.VehicleBraking = 200  
SettingsVisual.VehicleDirectionRate = 200  
SettingsVisual.VehicleSteerPower = 200  
  
-- متغيرات السلايدر  
local SlideValue = 20   
  
local function addSnow(parent, count)  
    for i = 1, count do  
        local f = Instance.new("TextLabel")  
        f.Size = UDim2.fromOffset(math.random(5,9), math.random(5,9))  
        f.BackgroundTransparency = 1  
        f.Text = "✦"  
        f.TextColor3 = Color3.fromRGB(205,230,255)  
        f.TextTransparency = math.random(20,50)/100  
        f.TextScaled = true  
        f.Font = Enum.Font.GothamBold  
        f.ZIndex = 2  
        f.Parent = parent  
        task.spawn(function()  
            task.wait(math.random()*2)  
            while f.Parent do  
                local sx = math.random()  
                f.Position = UDim2.fromScale(sx, -0.08)  
                local tw = TweenService:Create(f, TweenInfo.new(math.random(25,50)/10, Enum.EasingStyle.Linear), {  
                    Position = UDim2.fromScale(math.clamp(sx + math.random(-15,15)/100,0,1), 1.05),  
                })  
                tw:Play()  
                tw.Completed:Wait()  
            end  
        end)  
    end  
end  
  
local function getSnapCar()  
    local char = Player.Character  
    local hum = char and char:FindFirstChildOfClass("Humanoid")  
    local seat = hum and hum.SeatPart  
    if not seat or not seat:IsA("VehicleSeat") then return nil,nil,nil end  
    local vehicle = seat:FindFirstAncestorOfClass("Model")  
    if not vehicle then return nil,nil,nil end  
    local root = vehicle.PrimaryPart or seat.AssemblyRootPart or seat  
    if root then root = root.AssemblyRootPart or root end  
    return vehicle, root, seat  
end  
  
local function flatLook(cf)  
    local l = Vector3.new(cf.LookVector.X, 0, cf.LookVector.Z)  
    if l.Magnitude <= 0.001 then return Vector3.new(0,0,-1) end  
    return l.Unit  
end  
  
local function uprightAt(pos, look)  
    return CFrame.lookAt(pos, pos + flatLook(CFrame.new(Vector3.zero, look)), Vector3.yAxis)  
end  
  
local function moveTowards(cur, tgt, delta)  
    if cur < tgt then return math.min(cur + delta, tgt) end  
    if cur > tgt then return math.max(cur - delta, tgt) end  
    return tgt  
end  
  
--============================================================--  
-- GUI   
--============================================================--  
local TouchPanelGui = Instance.new("ScreenGui")  
TouchPanelGui.Name = "FRX_TouchPanelSlider"  
TouchPanelGui.ResetOnSpawn = false  
TouchPanelGui.IgnoreGuiInset = true  
TouchPanelGui.Parent = PlayerGui  
  
local TouchCard = Instance.new("Frame", TouchPanelGui)  
TouchCard.Size = UDim2.fromOffset(210, 150)  
TouchCard.Position = UDim2.new(0.04, 0, 0.42, 0)  
TouchCard.BackgroundColor3 = Color3.fromRGB(12, 12, 15)  
TouchCard.BackgroundTransparency = 0 -- خلفية احتياطية حتى تظهر الصورة  
TouchCard.BorderSizePixel = 0  
TouchCard.Active = true  
TouchCard.Draggable = true  
TouchCard.ClipsDescendants = true  
Instance.new("UICorner", TouchCard).CornerRadius = UDim.new(0, 16)  
  
-- إضافة صورة الخلفية FRX  
local BackgroundImage = Instance.new("ImageLabel", TouchCard)  
BackgroundImage.Name = "FRX_Background"  
BackgroundImage.Size = UDim2.fromScale(1, 1)  
BackgroundImage.Position = UDim2.fromScale(0, 0)  
BackgroundImage.BackgroundTransparency = 1  
BackgroundImage.ScaleType = Enum.ScaleType.Crop  
BackgroundImage.Image = "rbxthumb://type=Asset&id=118906140821224&w=420&h=420"  
BackgroundImage.ZIndex = 1  
Instance.new("UICorner", BackgroundImage).CornerRadius = UDim.new(0, 16)  
  
local btnLock = Instance.new("TextButton", TouchCard)  
btnLock.Size = UDim2.fromOffset(28, 28)  
btnLock.Position = UDim2.new(1, -66, 0, 8)  
btnLock.BackgroundColor3 = Color3.fromRGB(20,24,38)  
btnLock.BackgroundTransparency = 0.5  
btnLock.BorderSizePixel = 0  
btnLock.Text = "🔓"  
btnLock.TextSize = 12  
btnLock.ZIndex = 3  
Instance.new("UICorner", btnLock).CornerRadius = UDim.new(0, 8)  
  
local locked = false  
btnLock.MouseButton1Click:Connect(function()  
    locked = not locked  
    TouchCard.Draggable = not locked  
    btnLock.Text = locked and "🔒" or "🔓"  
end)  
  
local btnClose = Instance.new("TextButton", TouchCard)  
btnClose.Size = UDim2.fromOffset(28, 28)  
btnClose.Position = UDim2.new(1, -36, 0, 8)  
btnClose.BackgroundColor3 = Color3.fromRGB(220, 50, 80)  
btnClose.BackgroundTransparency = 0.3  
btnClose.BorderSizePixel = 0  
btnClose.Text = "X"  
btnClose.TextColor3 = COLORS.White  
btnClose.TextSize = 12  
btnClose.Font = Enum.Font.GothamBold  
btnClose.ZIndex = 3  
Instance.new("UICorner", btnClose).CornerRadius = UDim.new(0, 8)  
  
local btnReopen = Instance.new("TextButton", TouchPanelGui)  
btnReopen.Size = UDim2.fromOffset(50, 50)  
btnReopen.Position = UDim2.new(0.04, 0, 0.42, 0)  
btnReopen.BackgroundColor3 = COLORS.Glass  
btnReopen.BackgroundTransparency = 0.3  
btnReopen.BorderSizePixel = 0  
btnReopen.Text = "SNAP"  
btnReopen.TextColor3 = COLORS.White  
btnReopen.TextSize = 10  
btnReopen.Font = Enum.Font.GothamBold  
btnReopen.Visible = false  
btnReopen.ZIndex = 10  
Instance.new("UICorner", btnReopen).CornerRadius = UDim.new(0, 12)  
  
btnClose.MouseButton1Click:Connect(function()  
    TouchCard.Visible = false  
    btnReopen.Visible = true  
end)  
btnReopen.MouseButton1Click:Connect(function()  
    btnReopen.Visible = false  
    TouchCard.Visible = true  
end)  
  
--============================================================--  
-- السلايدر  
--============================================================--  
local sliderFrame = Instance.new("Frame", TouchCard)  
sliderFrame.Size = UDim2.new(1, -30, 0, 40)  
sliderFrame.Position = UDim2.new(0, 15, 0, 50)  
sliderFrame.BackgroundTransparency = 1  
sliderFrame.ZIndex = 3  
  
local track = Instance.new("Frame", sliderFrame)  
track.Size = UDim2.new(1, 0, 0, 6)  
track.Position = UDim2.new(0, 0, 0.5, -3)  
track.BackgroundColor3 = Color3.fromRGB(200, 200, 200)  
track.BorderSizePixel = 0  
track.ZIndex = 3  
Instance.new("UICorner", track).CornerRadius = UDim.new(1, 0)  
  
local fill = Instance.new("Frame", track)  
fill.Size = UDim2.new(SlideValue / 100, 0, 1, 0)  
fill.BackgroundColor3 = Color3.fromRGB(90, 210, 120)  
fill.BorderSizePixel = 0  
fill.ZIndex = 4  
Instance.new("UICorner", fill).CornerRadius = UDim.new(1, 0)  
  
local knob = Instance.new("Frame", fill)  
knob.Size = UDim2.fromOffset(18, 18)  
knob.AnchorPoint = Vector2.new(1, 0.5)  
knob.Position = UDim2.new(1, 0, 0.5, 0)  
knob.BackgroundColor3 = Color3.fromRGB(255, 255, 255)  
knob.BorderSizePixel = 0  
knob.ZIndex = 5  
Instance.new("UICorner", knob).CornerRadius = UDim.new(1, 0)  
local knobStroke = Instance.new("UIStroke", knob)  
knobStroke.Color = Color3.fromRGB(90, 210, 120)  
knobStroke.Thickness = 2  
  
local valueLabel = Instance.new("TextLabel", sliderFrame)  
valueLabel.Size = UDim2.fromOffset(40, 20)  
valueLabel.Position = UDim2.new(1, -40, 0, -15)  
valueLabel.BackgroundTransparency = 1  
valueLabel.Text = tostring(SlideValue)  
valueLabel.TextColor3 = Color3.fromRGB(90, 210, 120)  
valueLabel.TextSize = 12  
valueLabel.Font = Enum.Font.GothamBold  
valueLabel.TextXAlignment = Enum.TextXAlignment.Right  
valueLabel.ZIndex = 4  
  
local snapLabel = Instance.new("TextLabel", sliderFrame)  
snapLabel.Size = UDim2.fromOffset(100, 20)  
snapLabel.Position = UDim2.new(0, 0, 0, -15)  
snapLabel.BackgroundTransparency = 1  
snapLabel.Text = "Snap Down"  
snapLabel.TextColor3 = Color3.fromRGB(60, 60, 70)  
snapLabel.TextSize = 12  
snapLabel.Font = Enum.Font.GothamMedium  
snapLabel.TextXAlignment = Enum.TextXAlignment.Left  
snapLabel.ZIndex = 4  
  
local draggingSlider = false  
local function updateSlider(inputPosX)  
    local relX = math.clamp(inputPosX - track.AbsolutePosition.X, 0, track.AbsoluteSize.X)  
    local newVal = math.floor((relX / track.AbsoluteSize.X) * 100 + 0.5)  
    if newVal ~= SlideValue then  
        SlideValue = newVal  
        fill.Size = UDim2.new(SlideValue / 100, 0, 1, 0)  
        valueLabel.Text = tostring(SlideValue)  
        if SettingsVisual.TouchSnapCarApplyManualDepth then  
            pcall(SettingsVisual.TouchSnapCarApplyManualDepth, SlideValue)  
        end  
    end  
end  
  
track.InputBegan:Connect(function(input)  
    if input.UserInputType == Enum.UserInputType.Touch or input.UserInputType == Enum.UserInputType.MouseButton1 then  
        draggingSlider = true  
        updateSlider(input.Position.X)  
    end  
end)  
UserInputService.InputChanged:Connect(function(input)  
    if draggingSlider and (input.UserInputType == Enum.UserInputType.Touch or input.UserInputType == Enum.UserInputType.MouseMovement) then  
        updateSlider(input.Position.X)  
    end  
end)  
UserInputService.InputEnded:Connect(function(input)  
    if input.UserInputType == Enum.UserInputType.Touch or input.UserInputType == Enum.UserInputType.MouseButton1 then  
        draggingSlider = false  
    end  
end)  
  
local btnSnap = Instance.new("TextButton", TouchCard)  
btnSnap.Size = UDim2.new(1, -16, 0, 36)  
btnSnap.Position = UDim2.new(0, 8, 1, -46)  
btnSnap.BackgroundColor3 = COLORS.Blue  
btnSnap.BackgroundTransparency = 0.25  
btnSnap.BorderSizePixel = 0  
btnSnap.Text = "SNAP"  
btnSnap.TextColor3 = COLORS.White  
btnSnap.TextSize = 14  
btnSnap.Font = Enum.Font.GothamBold  
btnSnap.ZIndex = 3  
Instance.new("UICorner", btnSnap).CornerRadius = UDim.new(0, 9)  
  
--============================================================--  
-- حالة Snap (هنا سر التثبيت)  
--============================================================--  
local S = {  
    Enabled = false,  
    AboveMode = false,  
    AboveHeightStuds = 19,  
    AboveMoveSpeed = 24,  
    AboveLowerSpeed = 20,  
    AboveLowering = false,  
    AboveLandingReady = false,  
    Vehicle = nil, Root = nil, Seat = nil,  
    DesiredRootY = nil, RootToBottom = nil,  
    Depth = 13, BaseDepth = 13,  
    DepthMoveSpeed = 32, DepthMoveActive = false,  
    VerticalChaseMode = "ready",  
    VerticalChaseEnabled = false,  
    VerticalChaseDescending = false,  
    VerticalChaseHomeY = nil,  
    VerticalChaseAnchorXZ = nil,  
    VerticalChaseSpeed = 72,  
    VerticalChaseRiseSpeed = 56,  
    SnapGroundY = nil,  
    SafeStartXZ = nil,  
    CurrentDriveSpeed = 0,  
    Speed = 90, ReverseSpeed = 90,  
    AccelRate = 200, StopRate = 200, DirectionRate = 200, SteerPower = 200,  
    Exiting = false,  
    OneShotBusy = false,  
    ItemPulseBusy = false,  
    ItemPulseTargetRootY = nil,  
    ItemPulseLastItem = nil,  
    ItemPulseHoldTime = 1.0,  
    ItemPulseBelowOffset = 4,  
    ItemNextAcquireTime = 0,  
    NativeForwardHeld = false, NativeReverseHeld = false,  
    NativeForwardTouch = nil, NativeReverseTouch = nil,  
    NativeSteerTouch = nil, NativeSteerAxis = 0,  
    OriginalProps = setmetatable({}, {__mode = "k"}),  
    PTeleportBusy = false,  
    PTeleportGeneration = 0,  
    PRescuePending = false,  
    PRescueCharacter = nil, PRescueHumanoid = nil, PRescueSeat = nil,  
    PRescueVehicle = nil, PRescueSafeXZ = nil,  
    PRescueOriginXZ = nil, PRescueSurfaceY = nil, PRescueExpiresAt = 0,  
    SnapVehicleSafeMax = 140,  
    AutoEnemySnapEnabled = false,  
    AutoEnemySnapStillSince = nil,  
    AutoEnemySnapLastTrigger = 0,  
    AutoEnemySnapStopSeconds = 1.0,  
    AutoEnemySnapSpeedThreshold = 1.35,  
    AutoEnemySnapCooldown = 0.6,  
    SafeStartXZ = nil,  
    VerticalChaseStart = 0,  
    ItemVerticalDrop = 4,  
    ItemTriggerDistance = 5,  
    ImpactProtectionEnabled = true,  
    ObstacleProtectionEnabled = true,  
    ObstacleProbeDistance = 8,  
    ObstacleLowLift = 3.2,  
    ObstacleWallLift = 1.35,  
    ObstacleLiftOffset = 0,  
    ObstacleLiftUntil = 0,  
    ObstacleCooldownUntil = 0,  
    ExitRiseSteps = 14,  
    ExitGhostHold = 0.35,  
}  
SettingsVisual.TouchSnapCarState = S  
  
--============================================================--  
-- دوال Snap Car  
--============================================================--  
local function savePart(part, allowTouch)  
    if not part or not part:IsA("BasePart") then return end  
    if S.OriginalProps[part] == nil then  
        S.OriginalProps[part] = {  
            CanCollide = part.CanCollide,  
            CanTouch = part.CanTouch,  
            CanQuery = part.CanQuery,  
        }  
    end  
    pcall(function()  
        part.CanCollide = false  
        part.CanTouch = allowTouch == true  
        part.CanQuery = false  
    end)  
end  
  
local function phaseVehicle(vehicle)  
    if vehicle then  
        for _, o in ipairs(vehicle:GetDescendants()) do  
            if o:IsA("BasePart") then savePart(o, true) end  
        end  
    end  
    local char = Player.Character  
    if char then  
        for _, o in ipairs(char:GetDescendants()) do  
            if o:IsA("BasePart") then savePart(o, false) end  
        end  
    end  
end  
  
local function restoreAll()  
    for part, props in pairs(S.OriginalProps) do  
        if part and part.Parent and props then  
            pcall(function()  
                part.CanCollide = props.CanCollide  
                part.CanTouch = props.CanTouch  
                part.CanQuery = props.CanQuery  
            end)  
        end  
        S.OriginalProps[part] = nil  
    end  
end  
  
local function zeroMotion(vehicle, root)  
    if root and root.Parent then  
        pcall(function()  
            root.AssemblyLinearVelocity = Vector3.zero  
            root.AssemblyAngularVelocity = Vector3.zero  
        end)  
    end  
    if vehicle then  
        for _, o in ipairs(vehicle:GetDescendants()) do  
            if o:IsA("BasePart") then  
                pcall(function()  
                    o.AssemblyLinearVelocity = Vector3.zero  
                    o.AssemblyAngularVelocity = Vector3.zero  
                end)  
            end  
        end  
    end  
end  
  
local function fullGhost(vehicle)  
    if not vehicle then return end  
    for _, o in ipairs(vehicle:GetDescendants()) do  
        if o:IsA("BasePart") then  
            savePart(o, false)  
            pcall(function()  
                o.CanCollide = false  
                o.CanTouch = false  
                o.CanQuery = false  
            end)  
        end  
    end  
    local char = Player.Character  
    if char then  
        for _, o in ipairs(char:GetDescendants()) do  
            if o:IsA("BasePart") then  
                savePart(o, false)  
                pcall(function()  
                    o.CanCollide = false  
                    o.CanTouch = false  
                    o.CanQuery = false  
                end)  
            end  
        end  
    end  
end  
  
local function groundY(vehicle, root)  
    if not root then return nil end  
    local p = RaycastParams.new()  
    p.FilterType = Enum.RaycastFilterType.Exclude  
    p.IgnoreWater = true  
    local ignore = {vehicle}  
    if Player.Character then table.insert(ignore, Player.Character) end  
    p.FilterDescendantsInstances = ignore  
    local r = workspace:Raycast(root.Position + Vector3.new(0, 8, 0), Vector3.new(0, -300, 0), p)  
    return r and r.Position.Y or (root.Position.Y - 3)  
end  
  
local function surfaceY(vehicle, root)  
    if not root then return nil end  
    local p = RaycastParams.new()  
    p.FilterType = Enum.RaycastFilterType.Exclude  
    p.IgnoreWater = true  
    local ignore = {vehicle}  
    if Player.Character then table.insert(ignore, Player.Character) end  
    local veh = workspace:FindFirstChild("Vehicles")  
    if veh then table.insert(ignore, veh) end  
    p.FilterDescendantsInstances = ignore  
    local safe = tonumber(S.SnapGroundY)  
    local r = workspace:Raycast(root.Position + Vector3.new(0, 0.2, 0), Vector3.new(0, 340, 0), p)  
    if not r then return safe or (root.Position.Y + 13) end  
    local part = r.Instance  
    local sy = r.Position.Y  
    if part and part:IsA("BasePart") then  
        local cf, sz = part.CFrame, part.Size  
        sy = cf.Position.Y  
            + math.abs(cf.RightVector.Y)*sz.X*0.5  
            + math.abs(cf.UpVector.Y)*sz.Y*0.5  
            + math.abs(cf.LookVector.Y)*sz.Z*0.5  
    end  
    if safe and math.abs(sy - safe) > 60 then return safe end  
    return sy  
end  
  
--============================================================--  
-- تشغيل Snap (المصحح)  
--============================================================--  
local function setSnap(state)  
    state = state == true  
    if S.Exiting then return false end  
  
    if state then  
        if S.Enabled then return true end  
        local v, r, seat = getSnapCar()  
        if not v or not r or not seat then return false end  
        local gy = groundY(v, r)  
        if not gy then return false end  
        S.SnapGroundY = gy  
        S.SafeStartXZ = Vector3.new(r.Position.X, gy, r.Position.Z)  
        local boxCF, boxSz = v:GetBoundingBox()  
        S.RootToBottom = r.Position.Y - (boxCF.Position.Y - boxSz.Y*0.5)  
          
        -- التثبيت الفعلي للعمق  
        local targetDepth = math.clamp(tonumber(SlideValue) or 20, 5, 100)  
        S.Depth = targetDepth  
          
        S.DesiredRootY = gy - targetDepth + (S.RootToBottom or 2.5) + 0.35  
        S.Vehicle, S.Root, S.Seat = v, r, seat  
        S.SnapVehicleSafeMax = 140  
        S.CurrentDriveSpeed = 0  
        phaseVehicle(v)  
        local up = uprightAt(Vector3.new(r.Position.X, S.DesiredRootY, r.Position.Z), flatLook(r.CFrame))  
        local r2p = r.CFrame:ToObjectSpace(v:GetPivot())  
        pcall(function()  
            v:PivotTo(up * r2p)  
            r.AssemblyLinearVelocity = Vector3.zero  
            r.AssemblyAngularVelocity = Vector3.zero  
        end)  
        S.Enabled = true  
        btnSnap.Text = "SNAP UP"  
        btnSnap.BackgroundColor3 = Color3.fromRGB(180, 35, 60)  
        return true  
    end  
  
    if not S.Enabled then return true end  
    if S.Exiting then return false end  
    S.Exiting = true  
    S.Enabled = false  
    S.VerticalChaseMode = "ready"  
    S.VerticalChaseEnabled = false  
    S.VerticalChaseHomeY = nil  
    S.VerticalChaseAnchorXZ = nil  
  
    local v, r = S.Vehicle, S.Root  
    if v and v.Parent and r and r.Parent then  
        fullGhost(v)  
        zeroMotion(v, r)  
        local sy = surfaceY(v, r) or S.SnapGroundY or r.Position.Y  
        local boxCF, boxSz = v:GetBoundingBox()  
        local rootBottom = r.Position.Y - (boxCF.Position.Y - boxSz.Y*0.5)  
        local tgtY = sy + 1.65 + rootBottom  
        local startY = r.Position.Y  
        local look = flatLook(r.CFrame)  
        local r2p = r.CFrame:ToObjectSpace(v:GetPivot())  
        for i = 1, 14 do  
            if not v.Parent or not r.Parent then break end  
            local a = i/14  
            local y = startY + (tgtY - startY)*a*a*(3-2*a)  
            pcall(function() v:PivotTo(uprightAt(Vector3.new(r.Position.X, y, r.Position.Z), look) * r2p) end)  
            zeroMotion(v, r)  
            RunService.Heartbeat:Wait()  
        end  
    end  
    restoreAll()  
    S.Depth = tonumber(S.BaseDepth) or 13  
    S.SnapGroundY = nil  
    S.SafeStartXZ = nil  
    S.Exiting = false  
    S.Vehicle, S.Root, S.Seat = nil, nil, nil  
    S.DesiredRootY, S.RootToBottom = nil, nil  
    btnSnap.Text = "SNAP"  
    btnSnap.BackgroundColor3 = COLORS.Blue  
    return true  
end  
  
--============================================================--  
-- تطبيق العمق يدوياً (لما تحرك السلايدر وأنت تحت الأرض)  
--============================================================--  
function SettingsVisual.TouchSnapCarApplyManualDepth(d)  
    if not S.Enabled or S.AboveMode then return false end  
    if not S.Vehicle or not S.Root or not S.Vehicle.Parent or not S.Root.Parent then return false end  
    local gy = tonumber(S.SnapGroundY)  
    if not gy then return false end  
    local depth = math.clamp(tonumber(d) or 20, 5, 100)  
      
    S.Depth = depth  
    S.DesiredRootY = gy - depth + (tonumber(S.RootToBottom) or 2.5) + 0.35  
    S.DepthMoveSpeed = 32  
    S.DepthMoveActive = true  
    S.CurrentDriveSpeed = 0  
    fullGhost(S.Vehicle)  
    zeroMotion(S.Vehicle, S.Root)  
    return true  
end  
  
--============================================================--  
-- Snap Pulse (يبحث عن الـ items)  
--============================================================--  
local function itemPulseCheck()  
    local now = os.clock()  
    local trigger = tonumber(S.ItemTriggerDistance) or 5  
    local newItem, newPart, hd = SettingsVisual.FindNearestDroppedItem(S.Root.Position, trigger + 2, true)  
    if S.ItemPulseLastItem then  
        if not newItem or newItem ~= S.ItemPulseLastItem or hd > (trigger + 1.25) then  
            S.ItemPulseLastItem = nil  
        end  
    end  
    if not S.AboveMode and not S.ItemPulseBusy and not S.VerticalChaseEnabled  
        and now >= (S.ItemNextAcquireTime or 0) and newItem and newPart  
        and hd <= trigger and newItem ~= S.ItemPulseLastItem then  
        S.ItemPulseLastItem = newItem  
        S.ItemPulseBusy = true  
        local gen = (S.ItemPulseGeneration or 0) + 1  
        S.ItemPulseGeneration = gen  
        local rtb = S.RootToBottom or 2.5  
        local below = S.ItemPulseBelowOffset or 4  
        S.ItemPulseTargetRootY = newPart.Position.Y - below + rtb  
        task.spawn(function()  
            local untilTime = os.clock() + (S.ItemPulseHoldTime or 1.0)  
            while S.Enabled and S.ItemPulseGeneration == gen and os.clock() < untilTime do  
                if newPart and newPart.Parent then  
                    S.ItemPulseTargetRootY = newPart.Position.Y - below + rtb  
                end  
                task.wait(0.03)  
            end  
            if S.ItemPulseGeneration == gen then  
                S.ItemPulseBusy = false  
                S.ItemPulseTargetRootY = nil  
                S.ItemNextAcquireTime = os.clock() + 0.2  
            end  
        end)  
    end  
end  
  
--============================================================--  
-- محرك Snap الأساسي (Heartbeat)  
--============================================================--  
RunService.Heartbeat:Connect(function(dt)  
    if not S.Enabled then return end  
  
    local v, r, seat = getSnapCar()  
    if not v or not r or not seat or v ~= S.Vehicle then  
        if S.Enabled then setSnap(false) end  
        return  
    end  
    S.Root, S.Seat = r, seat  
    if S.OneShotBusy then phaseVehicle(v); return end  
    phaseVehicle(v)  
  
    itemPulseCheck()  
  
    local nT, nS = 0, 0  
    pcall(function()  
        local tf = tonumber(seat.ThrottleFloat) or 0  
        local ti = tonumber(seat.Throttle) or 0  
        local sf = tonumber(seat.SteerFloat) or 0  
        local si = tonumber(seat.Steer) or 0  
        nT = math.abs(tf) >= math.abs(ti) and tf or ti  
        nS = math.abs(sf) >= math.abs(si) and sf or si  
    end)  
    if math.abs(nT) < 0.05 then nT = 0 end  
    if math.abs(nS) < 0.05 then nS = 0 end  
  
    if S.NativeForwardHeld and not S.NativeReverseHeld then nT = 1  
    elseif S.NativeReverseHeld and not S.NativeForwardHeld then nT = -1  
    elseif S.NativeForwardHeld and S.NativeReverseHeld then nT = 0 end  
    if S.NativeSteerTouch then nS = S.NativeSteerAxis end  
  
    if nT == 0 and nS == 0 then  
        pcall(function()  
            local char = Player.Character  
            local hum = char and char:FindFirstChildOfClass("Humanoid")  
            if hum and hum.MoveDirection.Magnitude > 0.05 then  
                local f = flatLook(r.CFrame)  
                local rt = Vector3.new(r.CFrame.RightVector.X, 0, r.CFrame.RightVector.Z)  
                if rt.Magnitude > 0.001 then rt = rt.Unit end  
                nT = math.clamp(hum.MoveDirection:Dot(f), -1, 1)  
                nS = math.clamp(hum.MoveDirection:Dot(rt), -1, 1)  
            end  
        end)  
    end  
  
    local desiredY = (S.ItemPulseBusy and S.ItemPulseTargetRootY) or (S.DesiredRootY or r.Position.Y)  
    local activeY = desiredY  
  
    if S.VerticalChaseMode == "down" then  
        nT, nS = 0, 0  
        S.CurrentDriveSpeed = 0  
        local lowY = (S.SnapGroundY or r.Position.Y) - 2000 + (S.RootToBottom or 2.5) + 0.35  
        activeY = math.max(lowY, r.Position.Y - (S.VerticalChaseSpeed or 72) * math.clamp(dt, 1/240, 0.05))  
        if activeY <= lowY + 0.1 then  
            S.VerticalChaseMode = "stop_down"  
            S.VerticalChaseEnabled = false  
            S.VerticalChaseAnchorXZ = nil  
            S.DesiredRootY = activeY  
            S.DepthMoveActive = false  
        end  
    elseif S.DepthMoveActive and not S.ItemPulseBusy then  
        local dy = math.abs(r.Position.Y - desiredY)  
        if dy > 0.20 then  
            activeY = moveTowards(r.Position.Y, desiredY,  
                (S.VerticalChaseMode == "up" and (S.VerticalChaseRiseSpeed or 56) or S.DepthMoveSpeed or 32)  
                * math.clamp(dt, 1/240, 0.05))  
            nT = 0  
            S.CurrentDriveSpeed = 0  
        else  
            activeY = desiredY  
            S.DepthMoveActive = false  
            S.ItemNextAcquireTime = os.clock() + 0.40  
            if S.VerticalChaseMode == "up" then  
                S.VerticalChaseMode = "stop_up"  
                S.VerticalChaseEnabled = true  
                S.VerticalChaseHomeY = nil  
                S.VerticalChaseAnchorXZ = nil  
                S.DepthMoveSpeed = 32  
                S.DesiredRootY = desiredY  
            end  
        end  
    end  
  
    local chaseXZ = (S.VerticalChaseMode == "down" or S.VerticalChaseMode == "up")  
        and S.VerticalChaseAnchorXZ or nil  
    local look = flatLook(r.CFrame)  
    local up = uprightAt(Vector3.new(  
        chaseXZ and chaseXZ.X or r.Position.X,  
        activeY,  
        chaseXZ and chaseXZ.Y or r.Position.Z  
    ), look)  
  
    local thMag = math.clamp(math.abs(nT), 0, 1)  
    local tgtSpeed = 0  
    if thMag > 0 then  
        tgtSpeed = (nT < 0 and -(S.ReverseSpeed or 90) or (S.Speed or 90)) * thMag  
    end  
    local safe = math.clamp(S.SnapVehicleSafeMax or 140, 28, 200)  
    tgtSpeed = math.clamp(tgtSpeed, -safe * 0.65, safe)  
  
    local cur = S.CurrentDriveSpeed or 0  
    local changing = (cur ~= 0 and tgtSpeed ~= 0)  
        and ((cur > 0 and tgtSpeed < 0) or (cur < 0 and tgtSpeed > 0))  
    local rate = tgtSpeed == 0 and (S.StopRate or 200)  
        or (changing and (S.DirectionRate or 200) or (S.AccelRate or 200))  
    rate = math.min(rate, math.max(25, safe * 1.15))  
  
    S.CurrentDriveSpeed = moveTowards(cur, tgtSpeed, rate * math.max(dt, 1/240))  
  
    local steerMul = math.clamp((S.SteerPower or 200)/100, 0, 2)  
    local turn = -nS * 2.8 * steerMul * math.max(thMag, 0.42) * dt  
    local rot = up * CFrame.Angles(0, turn, 0)  
    local r2p = r.CFrame:ToObjectSpace(v:GetPivot())  
    pcall(function() v:PivotTo(rot * r2p) end)  
    local drive = rot.LookVector * S.CurrentDriveSpeed  
    r.AssemblyLinearVelocity = Vector3.new(drive.X, 0, drive.Z)  
    r.AssemblyAngularVelocity = Vector3.zero  
  
    pcall(function()  
        local char = Player.Character  
        local hum = char and char:FindFirstChildOfClass("Humanoid")  
        if hum then  
            hum.PlatformStand = false  
            hum.Sit = true  
        end  
    end)  
end)  
  
--============================================================--  
-- زر Snap (Toggle)  
--============================================================--  
local function shouldUseSnap()  
    local _, _, seat = getSnapCar()  
    return seat ~= nil  
end  
  
local isSnappedDown = false  
local savedY = nil  
local tDepth = 20  
  
local function toggleNormalSnap()  
    local char = Player.Character  
    local root = char and char:FindFirstChild("HumanoidRootPart")  
    if not root then return end  
    if not isSnappedDown then  
        savedY = root.Position.Y  
        tDepth = math.clamp(tonumber(SlideValue) or 20, 5, 100)  
        local ty = savedY - tDepth  
        isSnappedDown = true  
        root.CFrame = CFrame.new(root.Position.X, ty, root.Position.Z)  
        btnSnap.Text = "UP"  
        btnSnap.BackgroundColor3 = Color3.fromRGB(180, 35, 60)  
    else  
        isSnappedDown = false  
        if savedY then  
            root.CFrame = CFrame.new(root.Position.X, savedY + 1.5, root.Position.Z)  
        end  
        savedY = nil  
        btnSnap.Text = "SNAP"  
        btnSnap.BackgroundColor3 = COLORS.Blue  
    end  
end  
  
local function toggleSnap()  
    if shouldUseSnap() then  
        setSnap(not S.Enabled)  
    else  
        toggleNormalSnap()  
    end  
end  
  
btnSnap.MouseButton1Click:Connect(toggleSnap)  
  
UserInputService.InputBegan:Connect(function(input, gp)  
    if gp then return end  
    if input.KeyCode == SettingsVisual.TouchPanelKey then  
        toggleSnap()  
    end  
end)  
  
--============================================================--  
-- تحديث الزر لو البلاعر رجع فوق  
--============================================================--  
RunService.Heartbeat:Connect(function(dt)  
    if isSnappedDown and savedY then  
        local char = Player.Character  
        local root = char and char:FindFirstChild("HumanoidRootPart")  
        local hum = char and char:FindFirstChildOfClass("Humanoid")  
        if root and (not hum or not hum.SeatPart) then  
            local ty = savedY - tDepth  
            local extra = Vector3.zero  
            if hum and hum.MoveDirection.Magnitude > 0.05 then  
                local md = hum.MoveDirection  
                local fl = Vector3.new(md.X, 0, md.Z)  
                if fl.Magnitude > 0 then extra = fl.Unit * (7 * math.clamp(dt, 0, 0.05)) end  
            end  
            local p = root.Position + extra  
            root.CFrame = CFrame.new(p.X, ty, p.Z)  
            root.AssemblyLinearVelocity = Vector3.zero  
        end  
    end  
end)  
  
--============================================================--  
-- أسهم ▲▼  
--============================================================--  
local function stepVertical(direction)  
    if not S.Enabled or S.AboveMode or S.Exiting then return false end  
    local v, r, seat = getSnapCar()  
    if not v or not r or not seat or v ~= S.Vehicle then return false end  
    if not S.SnapGroundY or r.Position.Y >= S.SnapGroundY - 1 then return false end  
    if direction == "down" then  
        if S.VerticalChaseMode == "down" then  
            S.VerticalChaseMode = "stop_down"; S.VerticalChaseEnabled = true  
            S.VerticalChaseAnchorXZ = nil  
            S.DesiredRootY = r.Position.Y  
            S.DepthMoveActive = false  
            S.CurrentDriveSpeed = 0  
            zeroMotion(v, r)  
            return true  
        end  
        if S.OneShotBusy or S.ItemPulseBusy then return false end  
        S.VerticalChaseMode = "down"; S.VerticalChaseEnabled = true  
        S.VerticalChaseHomeY = r.Position.Y  
        S.VerticalChaseAnchorXZ = Vector2.new(r.Position.X, r.Position.Z)  
        S.VerticalChaseStart = os.clock()  
        S.CurrentDriveSpeed = 0  
        S.DepthMoveActive = false  
        S.DepthMoveSpeed = 32  
        zeroMotion(v, r)  
        return true  
    elseif direction == "up" then  
        if S.VerticalChaseMode == "up" then  
            S.VerticalChaseMode = "stop_up"; S.VerticalChaseEnabled = true  
            S.VerticalChaseAnchorXZ = nil  
            S.DesiredRootY = r.Position.Y  
            S.DepthMoveActive = false  
            S.VerticalChaseHomeY = nil  
            S.CurrentDriveSpeed = 0  
            zeroMotion(v, r)  
            return true  
        end  
        local ceilingY = (S.SnapGroundY or r.Position.Y) - 20 + (S.RootToBottom or 2.5) + 0.35  
        local home = math.max(tonumber(S.VerticalChaseHomeY) or ceilingY, ceilingY)  
        S.VerticalChaseHomeY = home  
        S.VerticalChaseMode = "up"; S.VerticalChaseEnabled = true  
        S.VerticalChaseAnchorXZ = Vector2.new(r.Position.X, r.Position.Z)  
        S.DesiredRootY = home  
        S.DepthMoveSpeed = S.VerticalChaseRiseSpeed or 56  
        S.DepthMoveActive = true  
        S.CurrentDriveSpeed = 0  
        zeroMotion(v, r)  
        return true  
    end  
    return false  
end  
  
--============================================================--  
-- زر P و TPx3  
--============================================================--  
local function pTeleport()  
    if not S.Enabled or S.AboveMode or S.Exiting or S.PTeleportBusy or S.OneShotBusy or S.ItemPulseBusy then return false end  
    local v, r, seat = getSnapCar()  
    if not v or not r or not seat or v ~= S.Vehicle then return false end  
    if not S.SnapGroundY or r.Position.Y >= S.SnapGroundY - 1 then return false end  
      
    -- اختيار هدف  
    local target = nil  
    local bestDist = math.huge  
    for _, pl in ipairs(Players:GetPlayers()) do  
        if pl ~= Player and pl.Character then  
            local hrp = pl.Character:FindFirstChild("HumanoidRootPart")  
            if hrp and hrp.Position.Y > r.Position.Y + 7 then  
                local dist = (hrp.Position - r.Position).Magnitude  
                if dist < bestDist then bestDist = dist target = hrp end  
            end  
        end  
    end  
    if not target then return false end  
  
    local point = target.Position  
    local savedY = r.Position.Y  
    local look = flatLook(r.CFrame)  
    local r2p = r.CFrame:ToObjectSpace(v:GetPivot())  
    local gen = (S.PTeleportGeneration or 0) + 1  
    S.PTeleportGeneration = gen  
    S.PTeleportBusy = true  
    S.OneShotBusy = true  
      
    local ok = pcall(function()  
        phaseVehicle(v)  
        local at = uprightAt(Vector3.new(point.X, savedY, point.Z), look)  
        v:PivotTo(at * r2p)  
        zeroMotion(v, r)  
    end)  
      
    task.delay(0.12, function()  
        if S.PTeleportGeneration ~= gen then return end  
        S.PTeleportBusy = false  
        S.OneShotBusy = false  
        S.CurrentDriveSpeed = 0  
    end)  
    return ok  
end  
  
--============================================================--  
-- عرض / إخفاء الأزرار  
--============================================================--  
local arrowUp = Instance.new("TextButton", TouchCard)  
arrowUp.Size = UDim2.fromOffset(32, 20)  
arrowUp.Position = UDim2.new(0.5, -36, 0, 126)  
arrowUp.BackgroundColor3 = Color3.fromRGB(34, 28, 54)  
arrowUp.BackgroundTransparency = 0.4  
arrowUp.Text = "▲"  
arrowUp.TextColor3 = Color3.fromRGB(237, 218, 255)  
arrowUp.TextSize = 11  
arrowUp.Visible = false  
arrowUp.ZIndex = 6  
Instance.new("UICorner", arrowUp).CornerRadius = UDim.new(0, 5)  
  
local arrowDown = Instance.new("TextButton", TouchCard)  
arrowDown.Size = UDim2.fromOffset(32, 20)  
arrowDown.Position = UDim2.new(0.5, 4, 0, 126)  
arrowDown.BackgroundColor3 = Color3.fromRGB(34, 28, 54)  
arrowDown.BackgroundTransparency = 0.4  
arrowDown.Text = "▼"  
arrowDown.TextColor3 = Color3.fromRGB(237, 218, 255)  
arrowDown.TextSize = 11  
arrowDown.Visible = false  
arrowDown.ZIndex = 6  
Instance.new("UICorner", arrowDown).CornerRadius = UDim.new(0, 5)  
  
arrowDown.MouseButton1Click:Connect(function() stepVertical("down") end)  
arrowUp.MouseButton1Click:Connect(function() stepVertical("up") end)  
  
local jumpBtn = Instance.new("TextButton", TouchCard)  
jumpBtn.Size = UDim2.fromOffset(36, 36)  
jumpBtn.Position = UDim2.new(0.5, -18, 0, 82)  
jumpBtn.BackgroundColor3 = Color3.fromRGB(28, 32, 44)  
jumpBtn.BackgroundTransparency = 0.7  
jumpBtn.BorderSizePixel = 0  
jumpBtn.Text = ""  
jumpBtn.TextColor3 = COLORS.White  
jumpBtn.TextSize = 14  
jumpBtn.Font = Enum.Font.GothamBold  
jumpBtn.Visible = false  
jumpBtn.ZIndex = 6  
Instance.new("UICorner", jumpBtn).CornerRadius = UDim.new(1, 0)  
  
jumpBtn.MouseButton1Click:Connect(function()  
    if not pTeleport() then  
        jumpBtn.BackgroundColor3 = Color3.fromRGB(150, 45, 62)  
        task.delay(0.25, function()  
            if jumpBtn.Parent then jumpBtn.BackgroundColor3 = Color3.fromRGB(28, 32, 44) end  
        end)  
    end  
end)  
  
RunService.Heartbeat:Connect(function()  
    local v, r, seat = getSnapCar()  
    local underground = S.Enabled and not S.AboveMode and v and r and S.SnapGroundY and r.Position.Y < S.SnapGroundY - 1  
    jumpBtn.Visible = underground and true or false  
    arrowDown.Visible = underground and true or false  
    arrowUp.Visible = underground and true or false  
    if underground then  
        jumpBtn.Text = "P"  
        jumpBtn.TextSize = 15  
    else  
        jumpBtn.Text = ""  
    end  
end)  
  
--============================================================--  
-- حركة السيارة العادية  
--============================================================--  
SettingsVisual.SetVehicleSliderDriveState = function(enabled)  
    S.Enabled = enabled and true or false  
end  
  
print("[FRX] Touch Panel with Slider loaded (Black BG).")  
