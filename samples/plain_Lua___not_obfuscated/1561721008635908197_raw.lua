Players = game:GetService("Players")
TweenService = game:GetService("TweenService")
UserInputService = game:GetService("UserInputService")
RunService = game:GetService("RunService")
Lighting = game:GetService("Lighting")
TeleportService = game:GetService("TeleportService")
VirtualUser = game:GetService("VirtualUser")
HttpService = game:GetService("HttpService")
CoreGui = game:GetService("CoreGui")
SoundService = game:GetService("SoundService")
player = Players.LocalPlayer

if not getgenv().OkayKickHook then
    getgenv().OkayKickHook = true
    local oldKick
    oldKick = hookmetamethod(game, "__namecall", newcclosure(function(self, ...)
        local method = getnamecallmethod()
        if method == "Kick" and self == player then return nil end
        return oldKick(self, ...)
    end))
end

origBrightness = Lighting.Brightness
origClockTime = Lighting.ClockTime
origAmbient = Lighting.Ambient
origOutdoor = Lighting.OutdoorAmbient
origColorShiftTop = Lighting.ColorShift_Top
origColorShiftBottom = Lighting.ColorShift_Bottom
noclipConn = nil

GetScale = function()
    local vp = workspace.CurrentCamera and workspace.CurrentCamera.ViewportSize or Vector2.new(1920, 1080)
    return math.min(vp.X / 1920, vp.Y / 1080) * 2
end
currentScale = GetScale()
ScalePixels = function(value) return math.round(value * currentScale) end
workspace.CurrentCamera:GetPropertyChangedSignal("ViewportSize"):Connect(function() currentScale = GetScale() end)

pcall(function()
    local old = CoreGui:FindFirstChild("OkayHub")
    if old then old:Destroy() end
    if getgenv().OkayMainLoop then getgenv().OkayMainLoop = false end
    if getgenv().OkayAimRunning then getgenv().OkayAimRunning = false end
end)
getgenv().OkayMainLoop = true
getgenv().OkayAimRunning = true

gui = Instance.new("ScreenGui")
gui.Name = "OkayHub"
gui.Parent = (gethui and gethui()) or CoreGui
gui.IgnoreGuiInset = true
gui.ResetOnSpawn = false

local CONFIG_FILE = "OkayHub_Config.json"

local function LoadConfig()
    local cfg = { lang = "en" }
    pcall(function()
        if isfile and isfile(CONFIG_FILE) then
            local raw = readfile(CONFIG_FILE)
            if raw and raw ~= "" then
                local ok, decoded = pcall(function() return HttpService:JSONDecode(raw) end)
                if ok and type(decoded) == "table" then
                    if decoded.lang == "vn" or decoded.lang == "en" then
                        cfg.lang = decoded.lang
                    end
                end
            end
        elseif getgenv().OkayHub_Lang then
            if getgenv().OkayHub_Lang == "vn" or getgenv().OkayHub_Lang == "en" then
                cfg.lang = getgenv().OkayHub_Lang
            end
        end
    end)
    return cfg
end

local function SaveConfig(cfg)
    pcall(function()
        getgenv().OkayHub_Lang = cfg.lang
        if writefile then
            writefile(CONFIG_FILE, HttpService:JSONEncode(cfg))
        end
    end)
end

local Config = LoadConfig()
CurrentLanguage = Config.lang

local function SetLanguage(lang)
    Config.lang = lang
    SaveConfig(Config)

    local reloaded = LoadConfig()
    if reloaded.lang == lang then
        Config = reloaded
        CurrentLanguage = Config.lang
    else
        CurrentLanguage = lang
        Config.lang = lang
    end

    RefreshUI()
    NotificationSystem:Show(
        CurrentLanguage == "vn"
            and "Đã chuyển sang Tiếng Việt"
            or "Switched to English"
    )
end

do
    local GM_Players    = Players
    local GM_RunService = RunService
    local GM_Player     = player

    local GodModeActive          = false
    local InfiniteHPActive       = false
    local ShieldActive           = false
    local HugeHPActive           = false
    local GodModeMetatableHooked = false
    local GodModeLastCFrame      = nil
    local GodModeTouchConn       = nil
    local GodModeInternalWrite   = false
    local GodModeOrigMaxHealth   = 100

    local GM_StatesApplied = false
    local GM_LastRaycast   = 0

    local GM_HealthSigConn    = nil
    local GM_MaxHealthSigConn = nil
    local GM_ForceField       = nil

    local HugeHPValue         = 9e15
    local HugeHPOriginalMax   = nil

    _G.GodModeStatus    = false
    _G.InfiniteHPStatus = false
    _G.ShieldStatus     = false
    _G.HugeHPStatus     = false

    local function GM_IsCharHumanoid(hum)
        if not hum then return false end
        local char = GM_Player.Character
        if not char then return false end
        return hum:IsDescendantOf(char) or hum.Parent == char
    end

    local function GM_IsKillZoneCFrame(cf)
        if not cf then return true end
        local pos = cf.Position
        local fallenHeight = workspace.FallenPartsDestroyHeight or -500
        if pos.Y <= (fallenHeight + 20) then return true end

        local rp = RaycastParams.new()
        rp.FilterType = Enum.RaycastFilterType.Exclude
        if GM_Player.Character then
            rp.FilterDescendantsInstances = {GM_Player.Character}
        end
        local result = workspace:Raycast(pos, Vector3.new(0, -20, 0), rp)
        if result then
            local n = result.Instance.Name:lower()
            if n:find("lava") or n:find("kill") or n:find("void") or n:find("acid")
                or n:find("death") or n:find("hurt") or n:find("damage") then
                return true
            end
        end
        return false
    end

    local function GM_Internal_TP(part, cf)
        if not part or not cf then return end
        GodModeInternalWrite = true
        pcall(function() part.CFrame = cf end)
        GodModeInternalWrite = false
    end

    local function GM_ResetStateCache()
        GM_StatesApplied = false
    end

    local function GM_ProtectParts(char)
        if not char then return end
        for _, v in ipairs(char:GetDescendants()) do
            if v:IsA("BasePart") then
                v.CanTouch = false
                v.CanQuery = false
            end
        end
        if GodModeTouchConn then GodModeTouchConn:Disconnect() end
        GodModeTouchConn = char.DescendantAdded:Connect(function(v)
            if GodModeActive and v:IsA("BasePart") then
                v.CanTouch = false
                v.CanQuery = false
            end
        end)
    end

    local function GM_UnprotectParts(char)
        if not char then return end
        for _, v in ipairs(char:GetDescendants()) do
            if v:IsA("BasePart") then
                pcall(function()
                    v.CanTouch = true
                    v.CanQuery = true
                end)
            end
        end
        if GodModeTouchConn then GodModeTouchConn:Disconnect() GodModeTouchConn = nil end
    end

    local function GM_ApplyStatesOnce(hum)
        if GM_StatesApplied or not hum then return end
        GM_StatesApplied = true
        pcall(function()
            hum.BreakJointsOnDeath = false
            hum:SetStateEnabled(Enum.HumanoidStateType.FallingDown, false)
            hum:SetStateEnabled(Enum.HumanoidStateType.Ragdoll, false)
            hum:SetStateEnabled(Enum.HumanoidStateType.Dead, false)
        end)
    end

    local function GM_HardRestore()
        GodModeInternalWrite = false
        GM_StatesApplied = false

        local char = GM_Player.Character
        if not char then return end

        for _, v in ipairs(char:GetDescendants()) do
            if v:IsA("BasePart") then
                pcall(function()
                    v.CanTouch = true
                    v.CanQuery = true
                end)
            end
        end

        local hum = char:FindFirstChildOfClass("Humanoid")
        if hum then
            pcall(function()
                hum.BreakJointsOnDeath = true
                hum:SetStateEnabled(Enum.HumanoidStateType.FallingDown, true)
                hum:SetStateEnabled(Enum.HumanoidStateType.Ragdoll, true)
                hum:SetStateEnabled(Enum.HumanoidStateType.Dead, true)
            end)
        end
    end

    local function GM_BindHealthSignals(hum)
        if GM_HealthSigConn then GM_HealthSigConn:Disconnect() GM_HealthSigConn = nil end
        if GM_MaxHealthSigConn then GM_MaxHealthSigConn:Disconnect() GM_MaxHealthSigConn = nil end
        if not hum then return end

        GM_HealthSigConn = hum.HealthChanged:Connect(function(h)
            if not InfiniteHPActive then return end
            if h > 0 and h < hum.MaxHealth then
                GodModeInternalWrite = true
                pcall(function() hum.Health = hum.MaxHealth end)
                GodModeInternalWrite = false
            end
        end)

        GM_MaxHealthSigConn = hum:GetPropertyChangedSignal("MaxHealth"):Connect(function()
            if hum.MaxHealth > GodModeOrigMaxHealth then
                GodModeOrigMaxHealth = hum.MaxHealth
            end
        end)
    end

    local function GM_UnbindHealthSignals()
        if GM_HealthSigConn then GM_HealthSigConn:Disconnect() GM_HealthSigConn = nil end
        if GM_MaxHealthSigConn then GM_MaxHealthSigConn:Disconnect() GM_MaxHealthSigConn = nil end
    end

    local function GM_EnableShield(char)
        if not char then return end
        local hum = char:FindFirstChildOfClass("Humanoid")
        if not hum then return end

        for _, v in ipairs(char:GetChildren()) do
            if v:IsA("ForceField") and v.Name == "OkayHub_Shield" then
                pcall(function() v:Destroy() end)
            end
        end

        local ff = Instance.new("ForceField", char)
        ff.Name = "OkayHub_Shield"
        ff.Visible = false
        GM_ForceField = ff
    end

    local function GM_DisableShield()
        local char = GM_Player.Character
        if char then
            for _, v in ipairs(char:GetChildren()) do
                if v:IsA("ForceField") and v.Name == "OkayHub_Shield" then
                    pcall(function() v:Destroy() end)
                end
            end
        end
        GM_ForceField = nil
    end

    local function GM_ApplyHugeHP(hum)
        if not hum or not HugeHPActive then return end
        GodModeInternalWrite = true
        pcall(function()
            if HugeHPOriginalMax == nil then
                HugeHPOriginalMax = hum.MaxHealth
            end
            if hum.MaxHealth ~= HugeHPValue then hum.MaxHealth = HugeHPValue end
            if hum.Health    ~= HugeHPValue then hum.Health    = HugeHPValue end
        end)
        GodModeInternalWrite = false
    end

    local function GM_RestoreHugeHP(hum)
        if not hum then return end
        GodModeInternalWrite = true
        pcall(function()
            local back = HugeHPOriginalMax or 100
            if hum.MaxHealth ~= back then hum.MaxHealth = back end
            if hum.Health > back then hum.Health = back end
        end)
        GodModeInternalWrite = false
        HugeHPOriginalMax = nil
    end

    local gmRawmt, gmOldNamecall, gmOldNewIndex

    local function GM_EnableHook()
        if GodModeMetatableHooked then return end

        local ok = pcall(function()
            gmRawmt = getrawmetatable(game)
            gmOldNamecall = gmRawmt.__namecall
            gmOldNewIndex = gmRawmt.__newindex

            if setreadonly then setreadonly(gmRawmt, false) end

            gmRawmt.__namecall = newcclosure(function(self, ...)
                local method = getnamecallmethod()
                if GodModeActive and typeof(self) == "Instance" then
                    if method == "TakeDamage" and self:IsA("Humanoid") then
                        if GM_IsCharHumanoid(self) then return nil end
                    end
                    if method == "ChangeState" and self:IsA("Humanoid") then
                        local arg = ...
                        if arg == Enum.HumanoidStateType.Dead and GM_IsCharHumanoid(self) then
                            return nil
                        end
                    end
                    if method == "BreakJoints" then
                        if self:IsA("Humanoid") and GM_IsCharHumanoid(self) then return nil end
                        if self:IsA("Model") and self == GM_Player.Character then return nil end
                    end
                end
                return gmOldNamecall(self, ...)
            end)

            gmRawmt.__newindex = newcclosure(function(self, key, value)
                if GodModeActive and not GodModeInternalWrite
                    and typeof(self) == "Instance" and self:IsA("Humanoid") then
                    if key == "Health" then
                        local v = tonumber(value)
                        if v and v < self.MaxHealth then return end
                    end
                    if key == "MaxHealth" then
                        local v = tonumber(value)
                        if v and v < GodModeOrigMaxHealth then return end
                    end
                    if key == "BreakJointsOnDeath" and value == true then
                        return
                    end
                end
                return gmOldNewIndex(self, key, value)
            end)

            if setreadonly then setreadonly(gmRawmt, true) end
        end)

        if ok then
            GodModeMetatableHooked = true
        else
            gmRawmt = nil
            gmOldNamecall = nil
            gmOldNewIndex = nil
            GodModeMetatableHooked = false
        end
    end

    local function GM_DisableHook() end

    function _G.SetInfiniteHP(state)
        state = state and true or false
        if state == InfiniteHPActive then return end
        InfiniteHPActive = state
        _G.InfiniteHPStatus = state

        if state then
            local char = GM_Player.Character
            local hum = char and char:FindFirstChildOfClass("Humanoid")
            if hum then
                if hum.MaxHealth > GodModeOrigMaxHealth then
                    GodModeOrigMaxHealth = hum.MaxHealth
                end
                GM_BindHealthSignals(hum)
            end
        else
            GM_UnbindHealthSignals()
        end
    end

    function _G.SetShield(state)
        state = state and true or false
        if state == ShieldActive then return end
        ShieldActive = state
        _G.ShieldStatus = state

        if state then
            GM_EnableShield(GM_Player.Character)
        else
            GM_DisableShield()
        end
    end

    function _G.SetHugeHP(state)
        state = state and true or false
        if state == HugeHPActive then return end
        HugeHPActive = state
        _G.HugeHPStatus = state

        local char = GM_Player.Character
        local hum  = char and char:FindFirstChildOfClass("Humanoid")
        if state then
            if hum then
                HugeHPOriginalMax = hum.MaxHealth
                GM_ApplyHugeHP(hum)
            end
        else
            if hum then GM_RestoreHugeHP(hum) end
        end
    end

    function SetGodMode(state)
        state = state and true or false
        if state == GodModeActive then
            _G.GodModeStatus = state
            return
        end

        GodModeActive = state
        _G.GodModeStatus = state
        GM_ResetStateCache()
        GodModeInternalWrite = false

        if state then
            GM_EnableHook()
            _G.SetInfiniteHP(true)
            _G.SetShield(true)
            _G.SetHugeHP(true)

            local char = GM_Player.Character
            if char then
                local hum = char:FindFirstChildOfClass("Humanoid")
                if hum then
                    if hum.MaxHealth > GodModeOrigMaxHealth then
                        GodModeOrigMaxHealth = hum.MaxHealth
                    end
                    GM_ApplyStatesOnce(hum)
                end
                GM_ProtectParts(char)
            end
        else
            _G.SetInfiniteHP(false)
            _G.SetShield(false)
            _G.SetHugeHP(false)

            GodModeLastCFrame = nil
            GM_LastRaycast = 0

            GM_HardRestore()
            GM_UnprotectParts(GM_Player.Character)
        end
    end
    _G.SetGodMode = SetGodMode

    local function GM_OnCharacter(char)
        GM_ResetStateCache()
        GodModeLastCFrame = nil

        if not GodModeActive then return end
        task.spawn(function()
            for _ = 1, 20 do
                if not GodModeActive then return end
                if char.Parent then break end
                GM_RunService.Heartbeat:Wait()
            end

            GM_ProtectParts(char)

            local hum = char:FindFirstChildOfClass("Humanoid")
                or char:WaitForChild("Humanoid", 5)

            if hum then
                if hum.MaxHealth > GodModeOrigMaxHealth then
                    GodModeOrigMaxHealth = hum.MaxHealth
                end
                GM_ApplyStatesOnce(hum)
            end

            if InfiniteHPActive and hum then
                GM_BindHealthSignals(hum)
            end

            if ShieldActive then
                GM_EnableShield(char)
            end

            if HugeHPActive and hum then
                HugeHPOriginalMax = nil
                GM_ApplyHugeHP(hum)
            end
        end)
    end

    if GM_Player and GM_Player.CharacterAdded then
        GM_Player.CharacterAdded:Connect(GM_OnCharacter)
    end

    GM_RunService.Heartbeat:Connect(function()
        if not (GodModeActive or InfiniteHPActive or HugeHPActive or ShieldActive) or not GM_Player then return end
        local char = GM_Player.Character
        if not char then return end
        local hum  = char:FindFirstChildOfClass("Humanoid")
        local root = char:FindFirstChild("HumanoidRootPart")
        if not hum or not root then return end

        if InfiniteHPActive and hum.Health > 0 and hum.Health < hum.MaxHealth then
            GodModeInternalWrite = true
            pcall(function() hum.Health = hum.MaxHealth end)
            GodModeInternalWrite = false
        end

        if HugeHPActive and hum.Health > 0 then
            if hum.MaxHealth ~= HugeHPValue or hum.Health ~= HugeHPValue then
                GM_ApplyHugeHP(hum)
            end
        end

        if ShieldActive then
            local hasShield = false
            for _, v in ipairs(char:GetChildren()) do
                if v:IsA("ForceField") and v.Name == "OkayHub_Shield" then
                    hasShield = true
                    break
                end
            end
            if not hasShield then
                GM_EnableShield(char)
            end
        end

        if not GodModeActive then return end

        if hum.Health > 0 then
            GodModeLastCFrame = root.CFrame
        else
            GM_ResetStateCache()
            GodModeLastCFrame = nil
            if char.Parent then pcall(function() char:BreakJoints() end) end
            return
        end

        local now = tick()
        if now - GM_LastRaycast >= 0.2 then
            GM_LastRaycast = now
            if GM_IsKillZoneCFrame(root.CFrame) and GodModeLastCFrame then
                GM_Internal_TP(root, GodModeLastCFrame + Vector3.new(0, 5, 0))
            end
        end
    end)
end

NotificationSystem = {}
do
    local notifGui = Instance.new("ScreenGui")
    notifGui.Name = "OkayNotifications"
    notifGui.Parent = (gethui and gethui()) or CoreGui
    notifGui.ResetOnSpawn = false
    notifGui.IgnoreGuiInset = true
    local notifFrame = Instance.new("Frame")
    notifFrame.Size = UDim2.new(0, ScalePixels(350), 0, ScalePixels(50))
    notifFrame.Position = UDim2.new(1, ScalePixels(-370), 0, ScalePixels(60))
    notifFrame.BackgroundColor3 = Color3.fromRGB(20, 20, 20)
    notifFrame.BackgroundTransparency = 1
    notifFrame.Parent = notifGui
    notifFrame.ZIndex = 9999
    Instance.new("UICorner", notifFrame).CornerRadius = UDim.new(0, ScalePixels(10))
    local notifStroke = Instance.new("UIStroke", notifFrame)
    notifStroke.Color = Color3.fromRGB(255, 255, 255)
    notifStroke.Thickness = ScalePixels(1.5)
    local notifText = Instance.new("TextLabel", notifFrame)
    notifText.Size = UDim2.new(1, ScalePixels(-25), 1, 0)
    notifText.Position = UDim2.new(0, ScalePixels(12), 0, 0)
    notifText.BackgroundTransparency = 1
    notifText.Text = ""
    notifText.TextColor3 = Color3.fromRGB(255, 255, 255)
    notifText.Font = Enum.Font.GothamBold
    notifText.TextSize = ScalePixels(15)
    notifText.TextXAlignment = Enum.TextXAlignment.Left
    notifText.TextWrapped = true
    notifText.ZIndex = 9999
    local queue, isShowing = {}, false
    function NotificationSystem:Show(message, duration)
        duration = duration or 3
        table.insert(queue, {message = message, duration = duration})
        if not isShowing then self:ProcessQueue() end
    end
    function NotificationSystem:ProcessQueue()
        if #queue == 0 then isShowing = false notifFrame.BackgroundTransparency = 1 return end
        isShowing = true
        local notif = table.remove(queue, 1)
        notifText.Text = "✦ " .. notif.message
        notifFrame.Visible = true
        notifFrame.Size = UDim2.new(0, 0, 0, ScalePixels(50))
        notifFrame.BackgroundTransparency = 1
        notifFrame.Position = UDim2.new(1, ScalePixels(-30), 0, ScalePixels(60))
        TweenService:Create(notifFrame, TweenInfo.new(0.3, Enum.EasingStyle.Back), {
            Size = UDim2.new(0, ScalePixels(350), 0, ScalePixels(50)),
            Position = UDim2.new(1, ScalePixels(-370), 0, ScalePixels(60)),
            BackgroundTransparency = 0
        }):Play()
        task.wait(notif.duration)
        local hideTween = TweenService:Create(notifFrame, TweenInfo.new(0.3), {
            Size = UDim2.new(0, 0, 0, ScalePixels(50)),
            Position = UDim2.new(1, ScalePixels(-30), 0, ScalePixels(60)),
            BackgroundTransparency = 1
        })
        hideTween:Play()
        hideTween.Completed:Wait()
        notifFrame.Visible = false
        self:ProcessQueue()
    end
end

do
    local wmGui = Instance.new("ScreenGui")
    wmGui.Name = "OkayWatermark"
    wmGui.Parent = (gethui and gethui()) or CoreGui
    wmGui.ResetOnSpawn = false
    wmGui.IgnoreGuiInset = true
    local wmFrame = Instance.new("Frame")
    wmFrame.Size = UDim2.new(0, ScalePixels(320), 0, ScalePixels(30))
    wmFrame.Position = UDim2.new(0, ScalePixels(12), 1, ScalePixels(-42))
    wmFrame.BackgroundColor3 = Color3.fromRGB(10, 10, 10)
    wmFrame.BackgroundTransparency = 0.3
    wmFrame.Parent = wmGui
    wmFrame.ZIndex = 9999
    Instance.new("UICorner", wmFrame).CornerRadius = UDim.new(0, ScalePixels(8))
    local wmStroke = Instance.new("UIStroke", wmFrame)
    wmStroke.Color = Color3.fromRGB(60, 60, 60)
    wmStroke.Thickness = ScalePixels(1)
    local wmText = Instance.new("TextLabel", wmFrame)
    wmText.Size = UDim2.new(1, ScalePixels(-12), 1, 0)
    wmText.Position = UDim2.new(0, ScalePixels(6), 0, 0)
    wmText.BackgroundTransparency = 1
    wmText.Text = "OKAY HUB V3.6 | discord.gg/rdhWDYuyg8 | FPS: 0"
    wmText.TextColor3 = Color3.fromRGB(255, 255, 255)
    wmText.Font = Enum.Font.GothamBold
    wmText.TextSize = ScalePixels(12)
    wmText.TextXAlignment = Enum.TextXAlignment.Left
    wmText.ZIndex = 9999
    local fpsCount, fpsAccum = 0, 0
    RunService.Heartbeat:Connect(function(dt)
        fpsAccum = fpsAccum + dt
        fpsCount = fpsCount + 1
        if fpsAccum >= 0.5 then
            local fps = math.floor(fpsCount / fpsAccum)
            wmText.Text = "OKAY HUB V3.6 | discord.gg/rdhWDYuyg8 | FPS: " .. fps
            fpsCount, fpsAccum = 0, 0
        end
    end)
end

ApplyShineEffect = function(target, isImage)
    if not target then return end
    local function StartEffect()
        local grad = Instance.new("UIGradient")
        grad.Name = "CyberGradient"
        grad.Rotation = 45
        grad.Color = ColorSequence.new({
            ColorSequenceKeypoint.new(0, Color3.fromRGB(255,255,255)),
            ColorSequenceKeypoint.new(0.5, Color3.fromRGB(100,100,100)),
            ColorSequenceKeypoint.new(1, Color3.fromRGB(255,255,255))
        })
        grad.Parent = target
        task.spawn(function()
            while target and target.Parent do
                grad.Offset = Vector2.new(-1, -1)
                local tw = TweenService:Create(grad, TweenInfo.new(3, Enum.EasingStyle.Linear), { Offset = Vector2.new(1, 1) })
                tw:Play() tw.Completed:Wait() task.wait(2)
            end
        end)
        task.spawn(function()
            while target and target.Parent do
                local prop = isImage and "ImageTransparency" or "TextTransparency"
                TweenService:Create(target, TweenInfo.new(0.5), {[prop] = 0.3}):Play()
                task.wait(0.5)
                TweenService:Create(target, TweenInfo.new(0.5), {[prop] = 0}):Play()
                task.wait(math.random(5, 10))
            end
        end)
    end
    target.AncestryChanged:Connect(function(_, parent)
        if parent and not target:FindFirstChild("CyberGradient") then StartEffect() end
    end)
    StartEffect()
end

MakeDraggable = function(targetFrame, dragAnchor)
    local dragging = false
    local dragStart, startPos
    dragAnchor.InputBegan:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
            dragging = true
            dragStart = input.Position
            startPos = targetFrame.Position
            input.Changed:Connect(function()
                if input.UserInputState == Enum.UserInputState.End then dragging = false end
            end)
        end
    end)
    UserInputService.InputChanged:Connect(function(input)
        if dragging and (input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch) then
            local delta = input.Position - dragStart
            targetFrame.Position = UDim2.new(startPos.X.Scale, startPos.X.Offset + delta.X, startPos.Y.Scale, startPos.Y.Offset + delta.Y)
        end
    end)
end

LanguageData = {
    Title = { vn = "OKAY HUB", en = "OKAY HUB" },
    SubTitle = { vn = "MADE BY BAO ✦", en = "MADE BY BAO ✦" },
    Search = { vn = "Tìm Script...", en = "Search Script..." },
    MucLuc = { vn = "MỤC LỤC", en = "CATEGORIES" },
    DanhSach = { vn = "DANH SÁCH SCRIPT", en = "SCRIPT LIST" },
    TrangChu = { vn = "Trang Chủ", en = "Home" },
    DiChuyen = { vn = "Di Chuyển", en = "Movement" },
    HienThi = { vn = "Hiển Thị", en = "Visuals" },
    NguoiChoi = { vn = "Người Chơi", en = "Player" },
    CongCu = { vn = "Công Cụ", en = "Tools" },
    NhanVat = { vn = "Nhân Vật", en = "Character" },
    DichThuat = { vn = "Dịch Thuật", en = "Translate" },
    MayChu = { vn = "Máy Chủ", en = "Server" },
    GiaiTri = { vn = "Giải Trí", en = "Fun" },
    Support = { vn = "Hỗ Trợ", en = "Support" },
    KillNPC = { vn = "Tiêu Diệt NPC", en = "Kill NPC" },
    TouchFling = { vn = "Đá Bay Khi Chạm", en = "Touch Fling" },
    GodMode = { vn = "Chế Độ Bất Tử", en = "God Mode" },
    TangHinh = { vn = "Tàng Hình V2", en = "Invisible V2" },
    TangHinhV1 = { vn = "Tàng Hình V1", en = "Invisible V1" },
    TangHinhV3 = { vn = "Tàng Hình V3", en = "Invisible V3" },
    BayV2 = { vn = "Bay V2", en = "Fly V2" },
    NhayVoHan = { vn = "Nhảy Vô Hạn", en = "Infinite Jump" },
    MaxZoom = { vn = "Mở Khóa Camera", en = "Unlock Camera" },
    ClickTP = { vn = "Công Cụ Dịch Chuyển", en = "Teleport Tool" },
    Noclip = { vn = "Xuyên Tường", en = "Noclip" },
    FullBright = { vn = "Tăng Sáng", en = "Full Bright" },
    ESP = { vn = "Đánh Dấu Đối Thủ", en = "Highlight ESP" },
    PlayerESP = { vn = "ESP Người Chơi", en = "Player ESP" },
    NpcESP = { vn = "ESP NPC", en = "NPC ESP" },
    XRay = { vn = "Xuyên Vật Thể", en = "XRay" },
    FPSBoost = { vn = "Tăng FPS", en = "FPS Boost" },
    ResetChar = { vn = "Hồi Sinh Nhân Vật", en = "Reset Character" },
    PackBack = { vn = "Giao Diện Túi", en = "Custom Backpack" },
    Freecam = { vn = "Camera Tự Do", en = "Freecam" },
    LangVN = { vn = "Tiếng Việt", en = "Vietnamese" },
    LangEN = { vn = "Tiếng Anh", en = "English" },
    Rejoin = { vn = "Vào Lại Server", en = "Rejoin Server" },
    ServerHop = { vn = "Chuyển Server", en = "Server Hop" },
    LowServer = { vn = "Server Ít Người", en = "Low Player Server" },
    VipServer = { vn = "Server VIP", en = "VIP Server" },
    RejoinSame = { vn = "Vào Lại Cùng Server", en = "Rejoin Same" },
    ServerInfo = { vn = "Thông Tin Server", en = "Server Info" },
    CopyJobId = { vn = "Sao Chép JobId", en = "Copy JobId" },
    CopyPlaceId = { vn = "Sao Chép PlaceId", en = "Copy PlaceId" },
    SpinBot = { vn = "Xoay Tròn", en = "Spin Bot" },
    JerkOff = { vn = "Cử Chỉ Kỳ Quặc", en = "Jerk Off" },
    FeEmote = { vn = "Điệu Nhảy FE", en = "FE Emotes" },
    AnimPack = { vn = "Animation R6 trên R15", en = "R6 Anim on R15" },
    NamelessAdmin = { vn = "Nameless Admin", en = "Nameless Admin" },
    AnimSpeed = { vn = "Tăng Tốc Animation", en = "Fast Animation" },
    FakeLag = { vn = "Trễ Mạng Giả", en = "Fake Lag" },
    Disco = { vn = "Disco", en = "Disco" },
    SpeedJumpPanel = { vn = "Tốc Độ & Nhảy", en = "Speed & Jump" },
    TPPlayerPanel = { vn = "TP Người Chơi", en = "TP Player" },
    HitboxPanel = { vn = "Mở Bảng Hitbox", en = "Open Hitbox Panel" },
    AimbotPanel = { vn = "Mở Bảng Aimbot", en = "Open Aimbot Panel" },
    SilentAimPanel = { vn = "Mở Bảng Silent Aim", en = "Open Silent Aim Panel" },
    FloatPlatform = { vn = "Tạo Sàn Bay", en = "Float Platform" },
    MasterESP = { vn = "ESP Tổng Hợp", en = "Master ESP" },
    ShiftLock = { vn = "Shift Lock", en = "Shift Lock" },
    AimBotAce = { vn = "Aim Bot Ace", en = "Aim Bot Ace" },
    InstBrowser = { vn = "Trình Duyệt Instance", en = "Instance Browser" },
    AutoFarm = { vn = "Farm Tự Động", en = "Auto Farm" },
    PlayerList = { vn = "Danh Sách Người Chơi", en = "Player List" },
    GiveTool = { vn = "Nhận Tool", en = "Give Tool" },
    DupeTool = { vn = "Nhân Đôi Tool", en = "Dupe Tool" },
    ToolList = { vn = "DS Tool", en = "Tool List" },
    CharScale = { vn = "Kích Thước", en = "Scale" },
    HeadSize = { vn = "Đầu To", en = "Head Size" },
    Gravity = { vn = "Trọng Lực", en = "Gravity" },
    Hue = { vn = "Màu Cầu Vồng", en = "Rainbow" },
    Spectate = { vn = "Theo Dõi Người Chơi", en = "Spectate Player" },
    BringPlayers = { vn = "Gom Người Chơi", en = "Bring Players" },
    BringNpcs = { vn = "Gom NPC", en = "Bring NPCs" },
    PortalGun = { vn = "Súng Portal", en = "Portal Gun" },
    RickBomb = { vn = "Bom Rick Prime", en = "Rick Prime Bomb" },
    RickPrime = { vn = "Rick Prime Hồi Sinh", en = "Rick Prime Revive" },
    DiscordPanel = { vn = "Discord Panel", en = "Discord Panel" },
    Version = { vn = "Phiên Bản", en = "Version" },
    MadeBy = { vn = "Tạo Bởi", en = "Made By" },
    PanelHitbox = { vn = "HITBOX", en = "HITBOX" },
    PanelAimbot = { vn = "AIMBOT", en = "AIMBOT" },
    PanelSilent = { vn = "SILENT AIM", en = "SILENT AIM" },
    PanelTP = { vn = "DỊCH CHUYỂN", en = "TP PLAYER" },
    PanelSpeedJump = { vn = "TỐC ĐỘ & NHẢY", en = "SPEED & JUMP" },
    PanelInst = { vn = "TRÌNH DUYỆT", en = "INSTANCE BROWSER" },
    PanelFarm = { vn = "FARM TỰ ĐỘNG", en = "AUTO FARM" },
    PanelPlayers = { vn = "NGƯỜI CHƠI", en = "PLAYERS" },
    PanelGiveTool = { vn = "NHẬN TOOL", en = "GIVE TOOL" },
    PanelToolList = { vn = "DS TOOL", en = "TOOL LIST" },
    PanelScale = { vn = "KÍCH THƯỚC", en = "SCALE" },
    PanelHeadSize = { vn = "ĐẦU TO", en = "HEAD SIZE" },
    PanelGravity = { vn = "TRỌNG LỰC", en = "GRAVITY" },
    PanelSpectate = { vn = "THEO DÕI", en = "SPECTATE" },
    PanelServerInfo = { vn = "THÔNG TIN SERVER", en = "SERVER INFO" },
    PanelPlatform = { vn = "SÀN BAY", en = "PLATFORM" },
    PanelGodMode = { vn = "GOD MODE", en = "GOD MODE" },
    PanelTeamCheck = { vn = "Kiểm Tra Đồng Đội", en = "Team Check" },
    TeamCheck = { vn = "Kiểm Tra Đồng Đội", en = "Team Check" },
    StatusOn = { vn = "BẬT", en = "ON" },
    StatusOff = { vn = "TẮT", en = "OFF" },
    EnterSize = { vn = "Nhập kích thước (mặc định: 5)...", en = "Enter Size (default: 5)..." },
    EnterSpeed = { vn = "Nhập tốc độ...", en = "Enter Speed..." },
    EnterJump = { vn = "Nhập lực nhảy...", en = "Enter Jump Power..." },
    LockSpeed = { vn = "Khóa Tốc Độ", en = "Lock Speed" },
    LockJump = { vn = "Khóa Lực Nhảy", en = "Lock Jump" },
    PlayerName = { vn = "Tên người chơi...", en = "Player Name..." },
    Teleport = { vn = "DỊCH CHUYỂN", en = "TELEPORT" },
    ClickTPTool = { vn = "Công Cụ Click TP", en = "Click TP Tool" },
    Status = { vn = "Trạng Thái", en = "Status" },
    AutoShoot = { vn = "Tự Động Bắn", en = "Auto Shoot" },
    Target = { vn = "Mục Tiêu", en = "Target" },
    TargetPlayers = { vn = "Mục Tiêu: Người Chơi", en = "Target: Players" },
    TargetBots = { vn = "Mục Tiêu: Bot", en = "Target: Bots" },
    TargetAll = { vn = "Mục Tiêu: Tất Cả", en = "Target: All" },
    Mode = { vn = "Chế Độ", en = "Mode" },
    Interval = { vn = "Khoảng Nghỉ (giây)", en = "Interval (s)" },
    Start = { vn = "BẮT ĐẦU", en = "START" },
    Stop = { vn = "DỪNG", en = "STOP" },
    SavePos = { vn = "LƯU VỊ TRÍ", en = "SAVE POS" },
    NamePlaceholder = { vn = "Tên tool...", en = "Tool name..." },
    Give = { vn = "NHẬN", en = "GIVE" },
    Copy = { vn = "SAO CHÉP", en = "COPY" },
    PathPlaceholder = { vn = "game.Workspace.Part", en = "game.Workspace.Part" },
    JoinDiscord = { vn = "Vào Discord", en = "Join Discord" },
    CopyLink = { vn = "Sao Chép Link", en = "Copy Link" },
    OpenBrowser = { vn = "Mở Trình Duyệt", en = "Open Browser" },
    GodModeToggle = { vn = "BẬT GOD MODE", en = "ENABLE GOD MODE" },
    GodModeDisable = { vn = "TẮT GOD MODE", en = "DISABLE GOD MODE" },
}
Text = function(key) return (LanguageData[key] and LanguageData[key][CurrentLanguage]) or key end

local function NotifyExec(nameKey)
    local p = CurrentLanguage == "vn" and "Đã chạy: " or "Executed: "
    NotificationSystem:Show(p .. Text(nameKey))
end
local function NotifyOpen(nameKey)
    local p = CurrentLanguage == "vn" and "Đã mở: " or "Opened: "
    NotificationSystem:Show(p .. Text(nameKey))
end
local function NotifyLoad(nameKey)
    local p = CurrentLanguage == "vn" and "Đã tải: " or "Loaded: "
    NotificationSystem:Show(p .. Text(nameKey))
end
local function NotifyOnOff(state, nameKey)
    local s
    if CurrentLanguage == "vn" then
        s = state and "✦ BẬT " or "✦ TẮT "
    else
        s = state and "✦ ON " or "✦ OFF "
    end
    NotificationSystem:Show(s .. Text(nameKey))
end

MiniTextRegistry = {}
RegisterMiniText = function(obj, key, suffix)
    if not obj or not key then return end
    table.insert(MiniTextRegistry, {obj = obj, key = key, suffix = suffix})
    obj.Text = Text(key) .. (suffix or "")
end
UpdateMiniTexts = function()
    for i = #MiniTextRegistry, 1, -1 do
        local entry = MiniTextRegistry[i]
        if entry.obj and entry.obj.Parent then
            pcall(function() entry.obj.Text = Text(entry.key) .. (entry.suffix or "") end)
        else
            table.remove(MiniTextRegistry, i)
        end
    end
end

TogglesState = {
    NhayVoHan = false, Noclip = false, FullBright = false,
    ESP = false, PlayerESP = false, NpcESP = false, XRay = false,
    SpinBot = false, HitboxToggle = false, AimbotUni = false,
    Hue = false, AnimSpeed = false, FakeLag = false, Disco = false,
}

infJumpConnection = nil
ToggleInfiniteJump = function(state)
    TogglesState.NhayVoHan = state
    if infJumpConnection then infJumpConnection:Disconnect() infJumpConnection = nil end
    if state then
        infJumpConnection = UserInputService.JumpRequest:Connect(function()
            if TogglesState.NhayVoHan and player.Character then
                local hum = player.Character:FindFirstChildOfClass("Humanoid")
                if hum then hum:ChangeState(Enum.HumanoidStateType.Jumping) end
            end
        end)
    end
end

CreateMiniGui = function(id, titleKey, height, setupFunc)
    if gui:FindFirstChild(id) then gui[id]:Destroy() end
    local miniGui = Instance.new("Frame", gui)
    miniGui.Name = id
    miniGui.Size = UDim2.new(0, ScalePixels(280), 0, ScalePixels(height))
    miniGui.Position = UDim2.new(0.5, ScalePixels(-140), 0.4, 0)
    miniGui.BackgroundColor3 = Color3.fromRGB(12, 12, 12)
    miniGui.BackgroundTransparency = 0.25
    miniGui.Active = true
    Instance.new("UICorner", miniGui).CornerRadius = UDim.new(0, ScalePixels(10))
    local stroke = Instance.new("UIStroke", miniGui)
    stroke.Color = Color3.fromRGB(200, 200, 200)
    stroke.Thickness = ScalePixels(1.5)
    local header = Instance.new("Frame", miniGui)
    header.Size = UDim2.new(1, 0, 0, ScalePixels(34))
    header.BackgroundTransparency = 1
    local title = Instance.new("TextLabel", header)
    title.Size = UDim2.new(1, ScalePixels(-35), 1, 0)
    title.Position = UDim2.new(0, ScalePixels(12), 0, 0)
    title.BackgroundTransparency = 1
    title.TextColor3 = Color3.fromRGB(255, 255, 255)
    title.Font = Enum.Font.GothamBold
    title.TextSize = ScalePixels(14)
    title.TextXAlignment = Enum.TextXAlignment.Left
    ApplyShineEffect(title, false)
    RegisterMiniText(title, titleKey)
    local closeBtn = Instance.new("TextButton", header)
    closeBtn.Size = UDim2.new(0, ScalePixels(26), 0, ScalePixels(26))
    closeBtn.Position = UDim2.new(1, ScalePixels(-30), 0, ScalePixels(4))
    closeBtn.BackgroundColor3 = Color3.fromRGB(30, 30, 30)
    closeBtn.Text = "X"
    closeBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
    closeBtn.Font = Enum.Font.GothamBold
    closeBtn.TextSize = ScalePixels(14)
    Instance.new("UICorner", closeBtn).CornerRadius = UDim.new(0, ScalePixels(6))
    closeBtn.MouseButton1Click:Connect(function() miniGui:Destroy() end)
    MakeDraggable(miniGui, header)
    local content = Instance.new("Frame", miniGui)
    content.Size = UDim2.new(1, ScalePixels(-20), 1, ScalePixels(-42))
    content.Position = UDim2.new(0, ScalePixels(10), 0, ScalePixels(38))
    content.BackgroundTransparency = 1
    local layout = Instance.new("UIListLayout", content)
    layout.Padding = UDim.new(0, ScalePixels(8))
    layout.SortOrder = Enum.SortOrder.LayoutOrder
    setupFunc(content)
    return miniGui
end

CreateMiniGuiSmall = function(id, titleKey, height, setupFunc)
    if gui:FindFirstChild(id) then gui[id]:Destroy() end
    local miniGui = Instance.new("Frame", gui)
    miniGui.Name = id
    miniGui.Size = UDim2.new(0, ScalePixels(180), 0, ScalePixels(height))
    miniGui.Position = UDim2.new(0.5, ScalePixels(-90), 0.4, 0)
    miniGui.BackgroundColor3 = Color3.fromRGB(12, 12, 12)
    miniGui.BackgroundTransparency = 0.25
    miniGui.Active = true
    Instance.new("UICorner", miniGui).CornerRadius = UDim.new(0, ScalePixels(8))
    local stroke = Instance.new("UIStroke", miniGui)
    stroke.Color = Color3.fromRGB(200, 200, 200)
    stroke.Thickness = ScalePixels(1)
    local header = Instance.new("Frame", miniGui)
    header.Size = UDim2.new(1, 0, 0, ScalePixels(24))
    header.BackgroundTransparency = 1
    local title = Instance.new("TextLabel", header)
    title.Size = UDim2.new(1, ScalePixels(-28), 1, 0)
    title.Position = UDim2.new(0, ScalePixels(8), 0, 0)
    title.BackgroundTransparency = 1
    title.TextColor3 = Color3.fromRGB(255, 255, 255)
    title.Font = Enum.Font.GothamBold
    title.TextSize = ScalePixels(11)
    title.TextXAlignment = Enum.TextXAlignment.Left
    ApplyShineEffect(title, false)
    RegisterMiniText(title, titleKey)
    local closeBtn = Instance.new("TextButton", header)
    closeBtn.Size = UDim2.new(0, ScalePixels(18), 0, ScalePixels(18))
    closeBtn.Position = UDim2.new(1, ScalePixels(-22), 0, ScalePixels(3))
    closeBtn.BackgroundColor3 = Color3.fromRGB(30, 30, 30)
    closeBtn.Text = "X"
    closeBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
    closeBtn.Font = Enum.Font.GothamBold
    closeBtn.TextSize = ScalePixels(10)
    Instance.new("UICorner", closeBtn).CornerRadius = UDim.new(0, ScalePixels(4))
    closeBtn.MouseButton1Click:Connect(function() miniGui:Destroy() end)
    MakeDraggable(miniGui, header)
    local content = Instance.new("Frame", miniGui)
    content.Size = UDim2.new(1, ScalePixels(-12), 1, ScalePixels(-28))
    content.Position = UDim2.new(0, ScalePixels(6), 0, ScalePixels(26))
    content.BackgroundTransparency = 1
    local layout = Instance.new("UIListLayout", content)
    layout.Padding = UDim.new(0, ScalePixels(4))
    layout.SortOrder = Enum.SortOrder.LayoutOrder
    setupFunc(content)
    return miniGui
end

OpenGodModeGui = function()
    CreateMiniGui("GodModeMini", "PanelGodMode", 110, function(content)
        local isOn = _G.GodModeStatus == true
        local mainBtn = Instance.new("TextButton", content)
        mainBtn.Size = UDim2.new(1, 0, 0, ScalePixels(55))
        mainBtn.BackgroundColor3 = isOn and Color3.fromRGB(0, 180, 90) or Color3.fromRGB(180, 40, 40)
        mainBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
        mainBtn.Text = isOn and Text("GodModeDisable") or Text("GodModeToggle")
        mainBtn.Font = Enum.Font.GothamBold
        mainBtn.TextSize = ScalePixels(15)
        Instance.new("UICorner", mainBtn).CornerRadius = UDim.new(0, ScalePixels(8))
        ApplyShineEffect(mainBtn, false)
        mainBtn.MouseButton1Click:Connect(function()
            local newState = not (_G.GodModeStatus == true)
            _G.SetGodMode(newState)
            mainBtn.Text = newState and Text("GodModeDisable") or Text("GodModeToggle")
            mainBtn.BackgroundColor3 = newState and Color3.fromRGB(0, 180, 90) or Color3.fromRGB(180, 40, 40)
            NotificationSystem:Show(newState and "God Mode: ON (4 layer)" or "God Mode: OFF")
        end)
    end)
end

hitboxConnection = nil
HitboxSizeValue = 5
HitboxTeamCheck = false

IsSameTeam = function(p)
    if not p or p == player then return true end
    if p.Team and player.Team and p.Team == player.Team then return true end
    return false
end

ToggleHitbox = function(state)
    if hitboxConnection then pcall(task.cancel, hitboxConnection) hitboxConnection = nil end
    if not state then
        for _, p in pairs(Players:GetPlayers()) do
            if p ~= player and p.Character then
                local hrp = p.Character:FindFirstChild("HumanoidRootPart")
                if hrp then
                    pcall(function()
                        hrp.Size = Vector3.new(2, 2, 1)
                        hrp.Transparency = 1
                        hrp.Material = Enum.Material.Plastic
                        hrp.CanCollide = false
                    end)
                end
            end
        end
        return
    end
    hitboxConnection = task.spawn(function()
        while TogglesState.HitboxToggle do
            local ok = pcall(function()
                for _, p in pairs(Players:GetPlayers()) do
                    if p ~= player and p.Character then
                        local hum = p.Character:FindFirstChildOfClass("Humanoid")
                        local hrp = p.Character:FindFirstChild("HumanoidRootPart")
                        if hum and hum.Health > 0 and hrp then
                            if HitboxTeamCheck and IsSameTeam(p) then
                                hrp.Size = Vector3.new(2, 2, 1)
                                hrp.Transparency = 1
                                hrp.Material = Enum.Material.Plastic
                                hrp.CanCollide = false
                            else
                                hrp.Size = Vector3.new(HitboxSizeValue, HitboxSizeValue, HitboxSizeValue)
                                hrp.Transparency = 0.5
                                hrp.Material = Enum.Material.ForceField
                                hrp.Color = Color3.fromRGB(0, 255, 120)
                                hrp.CanCollide = false
                            end
                        end
                    end
                end
            end)
            if not ok then task.wait(0.5) else task.wait(0.1) end
        end
    end)
end

OpenHitboxGui = function()
    CreateMiniGui("HitboxMini", "PanelHitbox", 180, function(content)
        local box = Instance.new("TextBox", content)
        box.ClearTextOnFocus = false
        box.Size = UDim2.new(1, 0, 0, ScalePixels(34))
        box.BackgroundColor3 = Color3.fromRGB(20, 20, 20)
        box.TextColor3 = Color3.new(1, 1, 1)
        box.PlaceholderText = Text("EnterSize")
        box.Font = Enum.Font.GothamMedium
        box.TextSize = ScalePixels(14)
        Instance.new("UICorner", box).CornerRadius = UDim.new(0, ScalePixels(6))
        local teamBtn = Instance.new("TextButton", content)
        teamBtn.Size = UDim2.new(1, 0, 0, ScalePixels(34))
        teamBtn.BackgroundColor3 = HitboxTeamCheck and Color3.fromRGB(255,255,255) or Color3.fromRGB(30,30,30)
        teamBtn.TextColor3 = HitboxTeamCheck and Color3.fromRGB(0,0,0) or Color3.new(1,1,1)
        teamBtn.Font = Enum.Font.GothamBold
        teamBtn.TextSize = ScalePixels(14)
        Instance.new("UICorner", teamBtn).CornerRadius = UDim.new(0, ScalePixels(6))
        ApplyShineEffect(teamBtn, false)
        RegisterMiniText(teamBtn, "TeamCheck", ": " .. (HitboxTeamCheck and Text("StatusOn") or Text("StatusOff")))
        local btn = Instance.new("TextButton", content)
        btn.Size = UDim2.new(1, 0, 0, ScalePixels(34))
        btn.BackgroundColor3 = TogglesState.HitboxToggle and Color3.fromRGB(255,255,255) or Color3.fromRGB(30,30,30)
        btn.TextColor3 = TogglesState.HitboxToggle and Color3.fromRGB(0,0,0) or Color3.new(1,1,1)
        btn.Text = TogglesState.HitboxToggle and Text("StatusOn") or Text("StatusOff")
        btn.Font = Enum.Font.GothamBold
        btn.TextSize = ScalePixels(14)
        Instance.new("UICorner", btn).CornerRadius = UDim.new(0, ScalePixels(6))
        ApplyShineEffect(btn, false)
        box.FocusLost:Connect(function()
            local val = tonumber(box.Text)
            if val and val > 0 then HitboxSizeValue = val end
        end)
        teamBtn.MouseButton1Click:Connect(function()
            HitboxTeamCheck = not HitboxTeamCheck
            teamBtn.Text = Text("TeamCheck") .. ": " .. (HitboxTeamCheck and Text("StatusOn") or Text("StatusOff"))
            teamBtn.BackgroundColor3 = HitboxTeamCheck and Color3.fromRGB(255,255,255) or Color3.fromRGB(30,30,30)
            teamBtn.TextColor3 = HitboxTeamCheck and Color3.fromRGB(0,0,0) or Color3.fromRGB(255,255,255)
        end)
        btn.MouseButton1Click:Connect(function()
            TogglesState.HitboxToggle = not TogglesState.HitboxToggle
            ToggleHitbox(TogglesState.HitboxToggle)
            btn.Text = TogglesState.HitboxToggle and Text("StatusOn") or Text("StatusOff")
            btn.BackgroundColor3 = TogglesState.HitboxToggle and Color3.fromRGB(255,255,255) or Color3.fromRGB(30,30,30)
            btn.TextColor3 = TogglesState.HitboxToggle and Color3.fromRGB(0,0,0) or Color3.fromRGB(255,255,255)
        end)
    end)
end

aimbotConnection = nil
AimbotTarget = nil
AimbotTeamCheck = false

GetClosestPlayer = function()
    local closest, dist = nil, math.huge
    local myRoot = player.Character and player.Character:FindFirstChild("HumanoidRootPart")
    if not myRoot then return nil end
    for _, p in pairs(Players:GetPlayers()) do
        if p ~= player and p.Character and p.Character:FindFirstChild("Head") and p.Character:FindFirstChildOfClass("Humanoid") and p.Character.Humanoid.Health > 0 then
            if AimbotTeamCheck and IsSameTeam(p) then continue end
            local hrp = p.Character:FindFirstChild("HumanoidRootPart")
            if hrp then
                local d = (myRoot.Position - hrp.Position).Magnitude
                if d < dist then closest = p.Character.Head dist = d end
            end
        end
    end
    return closest
end

ToggleAimbot = function(state)
    if aimbotConnection then aimbotConnection:Disconnect() aimbotConnection = nil end
    if not state then AimbotTarget = nil return end
    AimbotTarget = GetClosestPlayer()
    aimbotConnection = RunService.RenderStepped:Connect(function()
        local targetHum = AimbotTarget and AimbotTarget.Parent and AimbotTarget.Parent:FindFirstChildOfClass("Humanoid")
        if not AimbotTarget or not AimbotTarget.Parent or not targetHum or targetHum.Health <= 0 then
            AimbotTarget = GetClosestPlayer()
            if not AimbotTarget then return end
        end
        if AimbotTarget and workspace.CurrentCamera then
            workspace.CurrentCamera.CFrame = CFrame.new(workspace.CurrentCamera.CFrame.Position, AimbotTarget.Position)
        end
    end)
end

OpenAimbotGui = function()
    CreateMiniGui("AimbotMini", "PanelAimbot", 140, function(content)
        local teamBtn = Instance.new("TextButton", content)
        teamBtn.Size = UDim2.new(1, 0, 0, ScalePixels(34))
        teamBtn.BackgroundColor3 = AimbotTeamCheck and Color3.fromRGB(255,255,255) or Color3.fromRGB(30,30,30)
        teamBtn.TextColor3 = AimbotTeamCheck and Color3.fromRGB(0,0,0) or Color3.new(1,1,1)
        teamBtn.Font = Enum.Font.GothamBold
        teamBtn.TextSize = ScalePixels(14)
        Instance.new("UICorner", teamBtn).CornerRadius = UDim.new(0, ScalePixels(6))
        ApplyShineEffect(teamBtn, false)
        RegisterMiniText(teamBtn, "TeamCheck", ": " .. (AimbotTeamCheck and Text("StatusOn") or Text("StatusOff")))
        local btn = Instance.new("TextButton", content)
        btn.Size = UDim2.new(1, 0, 0, ScalePixels(38))
        btn.BackgroundColor3 = TogglesState.AimbotUni and Color3.fromRGB(255,255,255) or Color3.fromRGB(30,30,30)
        btn.TextColor3 = TogglesState.AimbotUni and Color3.fromRGB(0,0,0) or Color3.new(1,1,1)
        btn.Text = TogglesState.AimbotUni and Text("StatusOn") or Text("StatusOff")
        btn.Font = Enum.Font.GothamBold
        btn.TextSize = ScalePixels(14)
        Instance.new("UICorner", btn).CornerRadius = UDim.new(0, ScalePixels(6))
        ApplyShineEffect(btn, false)
        teamBtn.MouseButton1Click:Connect(function()
            AimbotTeamCheck = not AimbotTeamCheck
            teamBtn.Text = Text("TeamCheck") .. ": " .. (AimbotTeamCheck and Text("StatusOn") or Text("StatusOff"))
            teamBtn.BackgroundColor3 = AimbotTeamCheck and Color3.fromRGB(255,255,255) or Color3.fromRGB(30,30,30)
            teamBtn.TextColor3 = AimbotTeamCheck and Color3.fromRGB(0,0,0) or Color3.fromRGB(255,255,255)
        end)
        btn.MouseButton1Click:Connect(function()
            TogglesState.AimbotUni = not TogglesState.AimbotUni
            ToggleAimbot(TogglesState.AimbotUni)
            btn.Text = TogglesState.AimbotUni and Text("StatusOn") or Text("StatusOff")
            btn.BackgroundColor3 = TogglesState.AimbotUni and Color3.fromRGB(255,255,255) or Color3.fromRGB(30,30,30)
            btn.TextColor3 = TogglesState.AimbotUni and Color3.fromRGB(0,0,0) or Color3.fromRGB(255,255,255)
        end)
    end)
end

getgenv().OkaySilent = getgenv().OkaySilent or {
    Enabled = false, TeamCheck = true, AutoShoot = false,
    TargetMode = "Players", targetPosition = nil, closestPart = nil,
}

SilentIsVisible = function(targetPart)
    if not targetPart then return false end
    local myRoot = player.Character and (player.Character:FindFirstChild("HumanoidRootPart") or player.Character:FindFirstChild("Head"))
    if not myRoot then return false end
    local origin = myRoot.Position
    local direction = targetPart.Position - origin
    local rp = RaycastParams.new()
    rp.FilterType = Enum.RaycastFilterType.Blacklist
    rp.FilterDescendantsInstances = {player.Character, targetPart.Parent}
    local rr = workspace:Raycast(origin, direction, rp)
    if rr and not rr.Instance:IsDescendantOf(targetPart.Parent) then return false end
    return true
end

if not getgenv().OkaySilentRender then
    getgenv().OkaySilentRender = RunService.RenderStepped:Connect(function()
        local cfg = getgenv().OkaySilent
        if not cfg.Enabled then cfg.targetPosition = nil cfg.closestPart = nil return end
        local closestPart, minDist = nil, math.huge
        local myRoot = player.Character and player.Character:FindFirstChild("HumanoidRootPart")
        if not myRoot then cfg.targetPosition = nil cfg.closestPart = nil return end
        local function checkChar(char, isPlr, plrObj)
            if not char or char == player.Character then return end
            local hum = char:FindFirstChildOfClass("Humanoid")
            local tPart = char:FindFirstChild("Head")
            if hum and hum.Health > 0 and tPart and not tPart.Anchored then
                local skip = false
                if isPlr and plrObj and cfg.TeamCheck and plrObj.Team and player.Team and plrObj.Team == player.Team then skip = true end
                if not skip and SilentIsVisible(tPart) then
                    local d = (myRoot.Position - tPart.Position).Magnitude
                    if d < minDist then minDist = d closestPart = tPart end
                end
            end
        end
        if cfg.TargetMode == "Players" or cfg.TargetMode == "All" then
            for _, p in ipairs(Players:GetPlayers()) do
                if p ~= player then checkChar(p.Character, true, p) end
            end
        end
        if cfg.TargetMode == "Bots" or cfg.TargetMode == "All" then
            for _, obj in ipairs(workspace:GetChildren()) do
                if obj:IsA("Model") and not Players:GetPlayerFromCharacter(obj) then checkChar(obj, false, nil) end
            end
        end
        if closestPart then
            cfg.targetPosition = closestPart.Position
            cfg.closestPart = closestPart
        else
            cfg.targetPosition = nil
            cfg.closestPart = nil
        end
    end)
end

if not getgenv().OkaySilentShoot then
    getgenv().OkaySilentShoot = task.spawn(function()
        local lastShootTick = 0
        while true do
            task.wait(0.02)
            local cfg = getgenv().OkaySilent
            if cfg.Enabled and cfg.AutoShoot and cfg.closestPart and SilentIsVisible(cfg.closestPart) then
                local t = tick()
                if t - lastShootTick >= 0.1 then
                    lastShootTick = t
                    pcall(function()
                        VirtualUser:Button1Down(Vector2.new(0,0))
                        task.wait(0.02)
                        VirtualUser:Button1Up(Vector2.new(0,0))
                    end)
                end
            end
        end
    end)
end

if not getgenv().OkaySilentHook then
    local oldNamecall
    oldNamecall = hookmetamethod(game, "__namecall", newcclosure(function(self, ...)
        local cfg = getgenv().OkaySilent
        local method = getnamecallmethod()
        if cfg.Enabled and cfg.targetPosition and self == workspace and (method == "Raycast" or method == "FindPartOnRay" or method == "FindPartOnRayWithIgnoreList") then
            local args = {...}
            if typeof(args[1]) == "Vector3" then
                local origin = args[1]
                local direction = args[2]
                local mag = typeof(direction) == "Vector3" and direction.Magnitude or 999999
                args[2] = (cfg.targetPosition - origin).Unit * mag
                return oldNamecall(self, unpack(args))
            end
        end
        return oldNamecall(self, ...)
    end))
    getgenv().OkaySilentHook = true
end

OpenSilentAimGui = function()
    CreateMiniGui("SilentAimMini", "PanelSilent", 220, function(content)
        local cfg = getgenv().OkaySilent
        local toggleBtn = Instance.new("TextButton", content)
        toggleBtn.Size = UDim2.new(1, 0, 0, ScalePixels(34))
        toggleBtn.BackgroundColor3 = cfg.Enabled and Color3.fromRGB(255,255,255) or Color3.fromRGB(30,30,30)
        toggleBtn.TextColor3 = cfg.Enabled and Color3.fromRGB(0,0,0) or Color3.fromRGB(255,255,255)
        toggleBtn.Text = Text("Status") .. ": " .. (cfg.Enabled and Text("StatusOn") or Text("StatusOff"))
        toggleBtn.Font = Enum.Font.GothamBold
        toggleBtn.TextSize = ScalePixels(14)
        Instance.new("UICorner", toggleBtn).CornerRadius = UDim.new(0, ScalePixels(6))
        local teamBtn = Instance.new("TextButton", content)
        teamBtn.Size = UDim2.new(1, 0, 0, ScalePixels(34))
        teamBtn.BackgroundColor3 = cfg.TeamCheck and Color3.fromRGB(255,255,255) or Color3.fromRGB(30,30,30)
        teamBtn.TextColor3 = cfg.TeamCheck and Color3.fromRGB(0,0,0) or Color3.fromRGB(255,255,255)
        teamBtn.Text = Text("TeamCheck") .. ": " .. (cfg.TeamCheck and Text("StatusOn") or Text("StatusOff"))
        teamBtn.Font = Enum.Font.GothamBold
        teamBtn.TextSize = ScalePixels(14)
        Instance.new("UICorner", teamBtn).CornerRadius = UDim.new(0, ScalePixels(6))
        local autoBtn = Instance.new("TextButton", content)
        autoBtn.Size = UDim2.new(1, 0, 0, ScalePixels(34))
        autoBtn.BackgroundColor3 = cfg.AutoShoot and Color3.fromRGB(255,255,255) or Color3.fromRGB(30,30,30)
        autoBtn.TextColor3 = cfg.AutoShoot and Color3.fromRGB(0,0,0) or Color3.fromRGB(255,255,255)
        autoBtn.Text = Text("AutoShoot") .. ": " .. (cfg.AutoShoot and Text("StatusOn") or Text("StatusOff"))
        autoBtn.Font = Enum.Font.GothamBold
        autoBtn.TextSize = ScalePixels(14)
        Instance.new("UICorner", autoBtn).CornerRadius = UDim.new(0, ScalePixels(6))
        local targetModes = {"Players", "Bots", "All"}
        local targetKeys = {"TargetPlayers", "TargetBots", "TargetAll"}
        local targetIndex = 1
        for i, m in ipairs(targetModes) do if m == cfg.TargetMode then targetIndex = i end end
        local targetBtn = Instance.new("TextButton", content)
        targetBtn.Size = UDim2.new(1, 0, 0, ScalePixels(34))
        targetBtn.BackgroundColor3 = Color3.fromRGB(30,30,30)
        targetBtn.TextColor3 = Color3.fromRGB(255,255,255)
        targetBtn.Text = Text(targetKeys[targetIndex])
        targetBtn.Font = Enum.Font.GothamBold
        targetBtn.TextSize = ScalePixels(14)
        Instance.new("UICorner", targetBtn).CornerRadius = UDim.new(0, ScalePixels(6))
        toggleBtn.MouseButton1Click:Connect(function()
            cfg.Enabled = not cfg.Enabled
            toggleBtn.Text = Text("Status") .. ": " .. (cfg.Enabled and Text("StatusOn") or Text("StatusOff"))
            toggleBtn.BackgroundColor3 = cfg.Enabled and Color3.fromRGB(255,255,255) or Color3.fromRGB(30,30,30)
            toggleBtn.TextColor3 = cfg.Enabled and Color3.fromRGB(0,0,0) or Color3.fromRGB(255,255,255)
        end)
        teamBtn.MouseButton1Click:Connect(function()
            cfg.TeamCheck = not cfg.TeamCheck
            teamBtn.Text = Text("TeamCheck") .. ": " .. (cfg.TeamCheck and Text("StatusOn") or Text("StatusOff"))
            teamBtn.BackgroundColor3 = cfg.TeamCheck and Color3.fromRGB(255,255,255) or Color3.fromRGB(30,30,30)
            teamBtn.TextColor3 = cfg.TeamCheck and Color3.fromRGB(0,0,0) or Color3.fromRGB(255,255,255)
        end)
        autoBtn.MouseButton1Click:Connect(function()
            cfg.AutoShoot = not cfg.AutoShoot
            autoBtn.Text = Text("AutoShoot") .. ": " .. (cfg.AutoShoot and Text("StatusOn") or Text("StatusOff"))
            autoBtn.BackgroundColor3 = cfg.AutoShoot and Color3.fromRGB(255,255,255) or Color3.fromRGB(30,30,30)
            autoBtn.TextColor3 = cfg.AutoShoot and Color3.fromRGB(0,0,0) or Color3.fromRGB(255,255,255)
        end)
        targetBtn.MouseButton1Click:Connect(function()
            targetIndex = targetIndex + 1
            if targetIndex > #targetModes then targetIndex = 1 end
            cfg.TargetMode = targetModes[targetIndex]
            targetBtn.Text = Text(targetKeys[targetIndex])
        end)
    end)
end

TeleportToPlayer = function(nameQuery)
    if not nameQuery or nameQuery == "" then return end
    local query = nameQuery:lower()
    local target = nil
    for _, p in pairs(Players:GetPlayers()) do
        if p ~= player and (p.Name:lower():find(query) or p.DisplayName:lower():find(query)) then target = p break end
    end
    if target and player.Character and player.Character:FindFirstChild("HumanoidRootPart") and target.Character and target.Character:FindFirstChild("HumanoidRootPart") then
        player.Character.HumanoidRootPart.CFrame = target.Character.HumanoidRootPart.CFrame * CFrame.new(0, 3, 0)
    end
end

OpenTPGui = function()
    CreateMiniGui("TPMini", "PanelTP", 130, function(content)
        local box = Instance.new("TextBox", content)
        box.ClearTextOnFocus = false
        box.Size = UDim2.new(1, 0, 0, ScalePixels(34))
        box.BackgroundColor3 = Color3.fromRGB(20, 20, 20)
        box.TextColor3 = Color3.new(1, 1, 1)
        box.PlaceholderText = Text("PlayerName")
        box.Font = Enum.Font.GothamMedium
        box.TextSize = ScalePixels(14)
        Instance.new("UICorner", box).CornerRadius = UDim.new(0, ScalePixels(6))
        local btn = Instance.new("TextButton", content)
        btn.Size = UDim2.new(1, 0, 0, ScalePixels(34))
        btn.BackgroundColor3 = Color3.fromRGB(30, 30, 30)
        btn.TextColor3 = Color3.new(1, 1, 1)
        btn.Font = Enum.Font.GothamBold
        btn.TextSize = ScalePixels(14)
        Instance.new("UICorner", btn).CornerRadius = UDim.new(0, ScalePixels(6))
        ApplyShineEffect(btn, false)
        RegisterMiniText(btn, "Teleport")
        btn.MouseButton1Click:Connect(function() TeleportToPlayer(box.Text) end)
    end)
end

speedLockConn, jumpLockConn = nil, nil
customSpeedValue = 16
customJumpPowerValue = 50
isSpeedLocked, isJumpLocked = false, false
originalWalkSpeed, originalJumpPower = 16, 50

UpdateOriginalHumanoidValues = function()
    local char = player.Character
    if char then
        local hum = char:FindFirstChildOfClass("Humanoid")
        if hum then
            if not isSpeedLocked then originalWalkSpeed = hum.WalkSpeed end
            if not isJumpLocked then originalJumpPower = hum.JumpPower end
        end
    end
end

player.CharacterAdded:Connect(function(char)
    task.wait(0.5)
    isSpeedLocked = false
    isJumpLocked = false
    if speedLockConn then speedLockConn:Disconnect() speedLockConn = nil end
    if jumpLockConn then jumpLockConn:Disconnect() jumpLockConn = nil end
    UpdateOriginalHumanoidValues()
end)

OpenSpeedJumpGui = function()
    CreateMiniGui("SpeedJumpMini", "PanelSpeedJump", 240, function(content)
        local speedBox = Instance.new("TextBox", content)
        speedBox.Size = UDim2.new(1, 0, 0, ScalePixels(34))
        speedBox.BackgroundColor3 = Color3.fromRGB(20, 20, 20)
        speedBox.TextColor3 = Color3.fromRGB(255, 255, 255)
        speedBox.Text = tostring(customSpeedValue)
        speedBox.PlaceholderText = Text("EnterSpeed")
        speedBox.Font = Enum.Font.GothamMedium
        speedBox.TextSize = ScalePixels(14)
        Instance.new("UICorner", speedBox).CornerRadius = UDim.new(0, ScalePixels(6))
        local speedBtn = Instance.new("TextButton", content)
        speedBtn.Size = UDim2.new(1, 0, 0, ScalePixels(34))
        speedBtn.BackgroundColor3 = isSpeedLocked and Color3.fromRGB(255,255,255) or Color3.fromRGB(30,30,30)
        speedBtn.TextColor3 = isSpeedLocked and Color3.fromRGB(0,0,0) or Color3.fromRGB(255,255,255)
        speedBtn.Font = Enum.Font.GothamBold
        speedBtn.TextSize = ScalePixels(14)
        Instance.new("UICorner", speedBtn).CornerRadius = UDim.new(0, ScalePixels(6))
        ApplyShineEffect(speedBtn, false)
        RegisterMiniText(speedBtn, "LockSpeed", ": " .. (isSpeedLocked and Text("StatusOn") or Text("StatusOff")))
        local jumpBox = Instance.new("TextBox", content)
        jumpBox.Size = UDim2.new(1, 0, 0, ScalePixels(34))
        jumpBox.BackgroundColor3 = Color3.fromRGB(20, 20, 20)
        jumpBox.TextColor3 = Color3.fromRGB(255, 255, 255)
        jumpBox.Text = tostring(customJumpPowerValue)
        jumpBox.PlaceholderText = Text("EnterJump")
        jumpBox.Font = Enum.Font.GothamMedium
        jumpBox.TextSize = ScalePixels(14)
        Instance.new("UICorner", jumpBox).CornerRadius = UDim.new(0, ScalePixels(6))
        local jumpBtn = Instance.new("TextButton", content)
        jumpBtn.Size = UDim2.new(1, 0, 0, ScalePixels(34))
        jumpBtn.BackgroundColor3 = isJumpLocked and Color3.fromRGB(255,255,255) or Color3.fromRGB(30,30,30)
        jumpBtn.TextColor3 = isJumpLocked and Color3.fromRGB(0,0,0) or Color3.fromRGB(255,255,255)
        jumpBtn.Font = Enum.Font.GothamBold
        jumpBtn.TextSize = ScalePixels(14)
        Instance.new("UICorner", jumpBtn).CornerRadius = UDim.new(0, ScalePixels(6))
        ApplyShineEffect(jumpBtn, false)
        RegisterMiniText(jumpBtn, "LockJump", ": " .. (isJumpLocked and Text("StatusOn") or Text("StatusOff")))
        speedBox.FocusLost:Connect(function()
            local v = tonumber(speedBox.Text)
            if v then customSpeedValue = v else speedBox.Text = tostring(customSpeedValue) end
        end)
        jumpBox.FocusLost:Connect(function()
            local v = tonumber(jumpBox.Text)
            if v then customJumpPowerValue = v else jumpBox.Text = tostring(customJumpPowerValue) end
        end)
        speedBtn.MouseButton1Click:Connect(function()
            isSpeedLocked = not isSpeedLocked
            speedBtn.Text = Text("LockSpeed") .. ": " .. (isSpeedLocked and Text("StatusOn") or Text("StatusOff"))
            speedBtn.BackgroundColor3 = isSpeedLocked and Color3.fromRGB(255,255,255) or Color3.fromRGB(30,30,30)
            speedBtn.TextColor3 = isSpeedLocked and Color3.fromRGB(0,0,0) or Color3.fromRGB(255,255,255)
            if speedLockConn then speedLockConn:Disconnect() speedLockConn = nil end
            if isSpeedLocked then
                local char = player.Character
                if char and char:FindFirstChildOfClass("Humanoid") then originalWalkSpeed = char:FindFirstChildOfClass("Humanoid").WalkSpeed end
                speedLockConn = RunService.Heartbeat:Connect(function()
                    local c = player.Character
                    if c then
                        local h = c:FindFirstChildOfClass("Humanoid")
                        if h then h.WalkSpeed = customSpeedValue end
                    end
                end)
            else
                local char = player.Character
                if char then
                    local h = char:FindFirstChildOfClass("Humanoid")
                    if h then h.WalkSpeed = originalWalkSpeed end
                end
            end
        end)
        jumpBtn.MouseButton1Click:Connect(function()
            isJumpLocked = not isJumpLocked
            jumpBtn.Text = Text("LockJump") .. ": " .. (isJumpLocked and Text("StatusOn") or Text("StatusOff"))
            jumpBtn.BackgroundColor3 = isJumpLocked and Color3.fromRGB(255,255,255) or Color3.fromRGB(30,30,30)
            jumpBtn.TextColor3 = isJumpLocked and Color3.fromRGB(0,0,0) or Color3.fromRGB(255,255,255)
            if jumpLockConn then jumpLockConn:Disconnect() jumpLockConn = nil end
            if isJumpLocked then
                local char = player.Character
                if char and char:FindFirstChildOfClass("Humanoid") then
                    local h = char:FindFirstChildOfClass("Humanoid")
                    originalJumpPower = h.JumpPower
                    h.UseJumpPower = true
                end
                jumpLockConn = RunService.Heartbeat:Connect(function()
                    local c = player.Character
                    if c then
                        local h = c:FindFirstChildOfClass("Humanoid")
                        if h then h.UseJumpPower = true h.JumpPower = customJumpPowerValue end
                    end
                end)
            else
                local char = player.Character
                if char then
                    local h = char:FindFirstChildOfClass("Humanoid")
                    if h then h.JumpPower = originalJumpPower end
                end
            end
        end)
    end)
end

floatHeartbeatConn, globalPlatform, globalScreenGui = nil, nil, nil

CreateFloatPlatform = function()
    if floatHeartbeatConn then floatHeartbeatConn:Disconnect() floatHeartbeatConn = nil end
    if globalPlatform then globalPlatform:Destroy() globalPlatform = nil end
    if globalScreenGui then globalScreenGui:Destroy() globalScreenGui = nil end
    local platform = Instance.new("Part", workspace)
    platform.Size = Vector3.new(100, 0.5, 100)
    platform.Transparency = 1
    platform.Anchored = true
    platform.CanCollide = false
    globalPlatform = platform
    local sGui = Instance.new("ScreenGui", player:WaitForChild("PlayerGui"))
    globalScreenGui = sGui
    sGui.ResetOnSpawn = false
    local f = Instance.new("Frame", sGui)
    f.Size = UDim2.new(0, ScalePixels(160), 0, ScalePixels(60))
    f.Position = UDim2.new(0.5, ScalePixels(-80), 0.35, 0)
    f.BackgroundColor3 = Color3.fromRGB(15, 15, 15)
    f.BackgroundTransparency = 0.3
    Instance.new("UICorner", f).CornerRadius = UDim.new(0, ScalePixels(10))
    Instance.new("UIStroke", f).Color = Color3.fromRGB(200, 200, 200)
    local lbl = Instance.new("TextLabel", f)
    lbl.Size = UDim2.new(1, 0, 0, ScalePixels(22))
    lbl.TextColor3 = Color3.new(1, 1, 1)
    lbl.Font = Enum.Font.GothamBold
    lbl.TextSize = ScalePixels(11)
    lbl.BackgroundTransparency = 1
    ApplyShineEffect(lbl, false)
    RegisterMiniText(lbl, "PanelPlatform")
    local toggleBtn = Instance.new("TextButton", f)
    toggleBtn.Size = UDim2.new(0, ScalePixels(42), 0, ScalePixels(26))
    toggleBtn.Position = UDim2.new(0, ScalePixels(10), 0, ScalePixels(26))
    toggleBtn.Text = Text("StatusOff")
    toggleBtn.BackgroundColor3 = Color3.fromRGB(25, 25, 25)
    toggleBtn.TextColor3 = Color3.new(1, 1, 1)
    toggleBtn.Font = Enum.Font.GothamBold
    toggleBtn.TextSize = ScalePixels(11)
    Instance.new("UICorner", toggleBtn).CornerRadius = UDim.new(0, ScalePixels(6))
    ApplyShineEffect(toggleBtn, false)
    local downBtn = Instance.new("TextButton", f)
    downBtn.Size = UDim2.new(0, ScalePixels(36), 0, ScalePixels(26))
    downBtn.Position = UDim2.new(0, ScalePixels(58), 0, ScalePixels(26))
    downBtn.Text = "▼"
    downBtn.BackgroundColor3 = Color3.fromRGB(25, 25, 25)
    downBtn.TextColor3 = Color3.new(1, 1, 1)
    downBtn.Font = Enum.Font.GothamBold
    downBtn.TextSize = ScalePixels(14)
    Instance.new("UICorner", downBtn).CornerRadius = UDim.new(0, ScalePixels(6))
    ApplyShineEffect(downBtn, false)
    local upBtn = Instance.new("TextButton", f)
    upBtn.Size = UDim2.new(0, ScalePixels(36), 0, ScalePixels(26))
    upBtn.Position = UDim2.new(0, ScalePixels(100), 0, ScalePixels(26))
    upBtn.Text = "▲"
    upBtn.BackgroundColor3 = Color3.fromRGB(25, 25, 25)
    upBtn.TextColor3 = Color3.new(1, 1, 1)
    upBtn.Font = Enum.Font.GothamBold
    upBtn.TextSize = ScalePixels(14)
    Instance.new("UICorner", upBtn).CornerRadius = UDim.new(0, ScalePixels(6))
    ApplyShineEffect(upBtn, false)
    local pfEnabled, pfHeight, holdUp, holdDown = false, 0, false, false
    toggleBtn.MouseButton1Click:Connect(function()
        pfEnabled = not pfEnabled
        if pfEnabled and player.Character and player.Character:FindFirstChild("HumanoidRootPart") then
            pfHeight = player.Character.HumanoidRootPart.Position.Y - 3.5
        end
        toggleBtn.Text = pfEnabled and Text("StatusOn") or Text("StatusOff")
        toggleBtn.BackgroundColor3 = pfEnabled and Color3.fromRGB(255,255,255) or Color3.fromRGB(25,25,25)
        toggleBtn.TextColor3 = pfEnabled and Color3.fromRGB(0,0,0) or Color3.fromRGB(255,255,255)
    end)
    local function bindHold(btn, mode)
        btn.InputBegan:Connect(function(i)
            if i.UserInputType == Enum.UserInputType.MouseButton1 or i.UserInputType == Enum.UserInputType.Touch then
                if mode == "up" then holdUp = true else holdDown = true end
                task.spawn(function()
                    while (mode == "up" and holdUp) or (mode == "down" and holdDown) do
                        pfHeight = pfHeight + (mode == "up" and 0.6 or -0.6)
                        task.wait(0.04)
                    end
                end)
            end
        end)
        btn.InputEnded:Connect(function() holdUp = false holdDown = false end)
    end
    bindHold(upBtn, "up")
    bindHold(downBtn, "down")
    floatHeartbeatConn = RunService.Heartbeat:Connect(function()
        local root = player.Character and player.Character:FindFirstChild("HumanoidRootPart")
        if pfEnabled and root and platform and platform.Parent then
            platform.CFrame = CFrame.new(root.Position.X, pfHeight, root.Position.Z)
            platform.CanCollide = true
        else
            if platform and platform.Parent then
                platform.CFrame = CFrame.new(0, -9999, 0)
                platform.CanCollide = false
            end
        end
    end)
    MakeDraggable(f, lbl)
end

OpenInstanceBrowser = function()
    if gui:FindFirstChild("InstBrowserMini") then gui.InstBrowserMini:Destroy() end
    local mini = Instance.new("Frame", gui)
    mini.Name = "InstBrowserMini"
    mini.Size = UDim2.new(0, ScalePixels(260), 0, ScalePixels(360))
    mini.Position = UDim2.new(0.5, ScalePixels(-130), 0.3, 0)
    mini.BackgroundColor3 = Color3.fromRGB(12, 12, 12)
    mini.BackgroundTransparency = 0.25
    mini.Active = true
    Instance.new("UICorner", mini).CornerRadius = UDim.new(0, ScalePixels(8))
    local mstroke = Instance.new("UIStroke", mini)
    mstroke.Color = Color3.fromRGB(200, 200, 200)
    mstroke.Thickness = ScalePixels(1.2)
    local hdr = Instance.new("Frame", mini)
    hdr.Size = UDim2.new(1, 0, 0, ScalePixels(26))
    hdr.BackgroundTransparency = 1
    local ttl = Instance.new("TextLabel", hdr)
    ttl.Size = UDim2.new(1, ScalePixels(-70), 1, 0)
    ttl.Position = UDim2.new(0, ScalePixels(10), 0, 0)
    ttl.BackgroundTransparency = 1
    ttl.TextColor3 = Color3.new(1,1,1)
    ttl.Font = Enum.Font.GothamBold
    ttl.TextSize = ScalePixels(12)
    ttl.TextXAlignment = Enum.TextXAlignment.Left
    ApplyShineEffect(ttl, false)
    RegisterMiniText(ttl, "PanelInst")
    local refreshBtn = Instance.new("TextButton", hdr)
    refreshBtn.Size = UDim2.new(0, ScalePixels(44), 0, ScalePixels(20))
    refreshBtn.Position = UDim2.new(1, ScalePixels(-70), 0, ScalePixels(3))
    refreshBtn.BackgroundColor3 = Color3.fromRGB(30,30,30)
    refreshBtn.Text = "RFR"
    refreshBtn.TextColor3 = Color3.new(1,1,1)
    refreshBtn.Font = Enum.Font.GothamBold
    refreshBtn.TextSize = ScalePixels(10)
    Instance.new("UICorner", refreshBtn).CornerRadius = UDim.new(0, ScalePixels(5))
    local closeB = Instance.new("TextButton", hdr)
    closeB.Size = UDim2.new(0, ScalePixels(20), 0, ScalePixels(20))
    closeB.Position = UDim2.new(1, ScalePixels(-24), 0, ScalePixels(3))
    closeB.BackgroundColor3 = Color3.fromRGB(30,30,30)
    closeB.Text = "X"
    closeB.TextColor3 = Color3.new(1,1,1)
    closeB.Font = Enum.Font.GothamBold
    closeB.TextSize = ScalePixels(11)
    Instance.new("UICorner", closeB).CornerRadius = UDim.new(0, ScalePixels(5))
    closeB.MouseButton1Click:Connect(function() mini:Destroy() end)
    local scroll = Instance.new("ScrollingFrame", mini)
    scroll.Size = UDim2.new(1, ScalePixels(-14), 1, ScalePixels(-64))
    scroll.Position = UDim2.new(0, ScalePixels(7), 0, ScalePixels(30))
    scroll.BackgroundTransparency = 1
    scroll.ScrollBarThickness = ScalePixels(3)
    scroll.CanvasSize = UDim2.new(0,0,0,0)
    scroll.AutomaticCanvasSize = Enum.AutomaticSize.Y
    Instance.new("UIListLayout", scroll).Padding = UDim.new(0, ScalePixels(2))
    local pathBox = Instance.new("TextBox", mini)
    pathBox.Size = UDim2.new(1, ScalePixels(-14), 0, ScalePixels(24))
    pathBox.Position = UDim2.new(0, ScalePixels(7), 1, ScalePixels(-30))
    pathBox.BackgroundColor3 = Color3.fromRGB(20,20,20)
    pathBox.TextColor3 = Color3.fromRGB(255, 200, 100)
    pathBox.PlaceholderText = Text("PathPlaceholder")
    pathBox.Font = Enum.Font.Code
    pathBox.TextSize = ScalePixels(10)
    Instance.new("UICorner", pathBox).CornerRadius = UDim.new(0, ScalePixels(5))
    local expanded = {}
    local function renderChildren(parent, depth, container)
        for _, child in ipairs(parent:GetChildren()) do
            local row = Instance.new("Frame", container)
            row.Size = UDim2.new(1, 0, 0, ScalePixels(18))
            row.BackgroundColor3 = Color3.fromRGB(18, 18, 18)
            row.BackgroundTransparency = 0.4
            Instance.new("UICorner", row).CornerRadius = UDim.new(0, ScalePixels(3))
            local btn = Instance.new("TextButton", row)
            btn.Size = UDim2.new(1, 0, 1, 0)
            btn.BackgroundTransparency = 1
            btn.Text = string.rep("  ", depth) .. "▸ " .. child.Name .. "  [" .. child.ClassName .. "]"
            btn.TextColor3 = Color3.fromRGB(230, 230, 230)
            btn.Font = Enum.Font.Code
            btn.TextSize = ScalePixels(10)
            btn.TextXAlignment = Enum.TextXAlignment.Left
            btn.TextTruncate = Enum.TextTruncate.AtEnd
            local childContainer = nil
            btn.MouseButton1Click:Connect(function()
                pathBox.Text = child:GetFullName()
                if expanded[child] then
                    expanded[child] = false
                    btn.Text = string.rep("  ", depth) .. "▸ " .. child.Name .. "  [" .. child.ClassName .. "]"
                    if childContainer then childContainer:Destroy() childContainer = nil end
                else
                    expanded[child] = true
                    btn.Text = string.rep("  ", depth) .. "▾ " .. child.Name .. "  [" .. child.ClassName .. "]"
                    childContainer = Instance.new("Frame", container)
                    childContainer.Size = UDim2.new(1, 0, 0, 0)
                    childContainer.BackgroundTransparency = 1
                    childContainer.AutomaticSize = Enum.AutomaticSize.Y
                    Instance.new("UIListLayout", childContainer).Padding = UDim.new(0, ScalePixels(2))
                    renderChildren(child, depth + 1, childContainer)
                end
            end)
        end
    end
    local function rebuild()
        for _, c in ipairs(scroll:GetChildren()) do if c:IsA("Frame") then c:Destroy() end end
        expanded = {}
        renderChildren(game, 0, scroll)
    end
    refreshBtn.MouseButton1Click:Connect(rebuild)
    pathBox.FocusLost:Connect(function(enter)
        if enter then
            local ok, target = pcall(function() return loadstring("return " .. pathBox.Text)() end)
            if ok and typeof(target) == "Instance" then
                local box = Instance.new("SelectionBox", workspace.CurrentCamera)
                box.Adornee = target
                task.delay(2, function() box:Destroy() end)
                pathBox.TextColor3 = Color3.fromRGB(100, 255, 100)
            else
                pathBox.TextColor3 = Color3.fromRGB(255, 100, 100)
            end
        end
    end)
    rebuild()
    MakeDraggable(mini, hdr)
end

getgenv().OkayFarm = { running = false, mode = "Click", interval = 1 }
OpenAutoFarmGui = function()
    CreateMiniGui("AutoFarmMini", "PanelFarm", 260, function(content)
        local modes = {"Click", "Touch", "ProximityPrompt"}
        local modeIdx = 1
        local info = Instance.new("TextLabel", content)
        info.Size = UDim2.new(1, 0, 0, ScalePixels(28))
        info.BackgroundColor3 = Color3.fromRGB(20,20,20)
        info.Text = Text("Status") .. ": " .. Text("StatusOff")
        info.TextColor3 = Color3.fromRGB(255, 80, 80)
        info.Font = Enum.Font.GothamBold
        info.TextSize = ScalePixels(12)
        Instance.new("UICorner", info).CornerRadius = UDim.new(0, ScalePixels(6))
        local modeBtn = Instance.new("TextButton", content)
        modeBtn.Size = UDim2.new(1, 0, 0, ScalePixels(32))
        modeBtn.BackgroundColor3 = Color3.fromRGB(30,30,30)
        modeBtn.Text = Text("Mode") .. ": " .. modes[modeIdx]
        modeBtn.TextColor3 = Color3.new(1,1,1)
        modeBtn.Font = Enum.Font.GothamBold
        modeBtn.TextSize = ScalePixels(12)
        Instance.new("UICorner", modeBtn).CornerRadius = UDim.new(0, ScalePixels(6))
        ApplyShineEffect(modeBtn, false)
        local intervalBox = Instance.new("TextBox", content)
        intervalBox.Size = UDim2.new(1, 0, 0, ScalePixels(30))
        intervalBox.BackgroundColor3 = Color3.fromRGB(20,20,20)
        intervalBox.Text = "1"
        intervalBox.PlaceholderText = Text("Interval")
        intervalBox.TextColor3 = Color3.new(1,1,1)
        intervalBox.Font = Enum.Font.GothamMedium
        intervalBox.TextSize = ScalePixels(12)
        Instance.new("UICorner", intervalBox).CornerRadius = UDim.new(0, ScalePixels(6))
        intervalBox.FocusLost:Connect(function()
            local v = tonumber(intervalBox.Text)
            if v and v > 0 then getgenv().OkayFarm.interval = v end
        end)
        local toggle = Instance.new("TextButton", content)
        toggle.Size = UDim2.new(1, 0, 0, ScalePixels(36))
        toggle.BackgroundColor3 = Color3.fromRGB(30,30,30)
        toggle.Text = Text("Start")
        toggle.TextColor3 = Color3.new(1,1,1)
        toggle.Font = Enum.Font.GothamBold
        toggle.TextSize = ScalePixels(14)
        Instance.new("UICorner", toggle).CornerRadius = UDim.new(0, ScalePixels(6))
        ApplyShineEffect(toggle, false)
        modeBtn.MouseButton1Click:Connect(function()
            modeIdx = modeIdx % #modes + 1
            getgenv().OkayFarm.mode = modes[modeIdx]
            modeBtn.Text = Text("Mode") .. ": " .. modes[modeIdx]
        end)
        toggle.MouseButton1Click:Connect(function()
            local f = getgenv().OkayFarm
            f.running = not f.running
            toggle.Text = f.running and Text("Stop") or Text("Start")
            info.Text = Text("Status") .. ": " .. (f.running and Text("StatusOn") or Text("StatusOff"))
            info.TextColor3 = f.running and Color3.fromRGB(80, 255, 80) or Color3.fromRGB(255, 80, 80)
            toggle.BackgroundColor3 = f.running and Color3.fromRGB(255,255,255) or Color3.fromRGB(30,30,30)
            toggle.TextColor3 = f.running and Color3.fromRGB(0,0,0) or Color3.new(1,1,1)
            if f.running and not getgenv().OkayFarmLoop then
                getgenv().OkayFarmLoop = task.spawn(function()
                    while getgenv().OkayFarm.running do
                        pcall(function()
                            local char = player.Character
                            local root = char and char:FindFirstChild("HumanoidRootPart")
                            if not root then return end
                            if getgenv().OkayFarm.mode == "Click" then
                                local bp = player:FindFirstChild("Backpack")
                                local tool = char:FindFirstChildOfClass("Tool") or (bp and bp:FindFirstChildOfClass("Tool"))
                                if tool then
                                    if not tool.Parent:IsA("Model") then tool.Parent = char end
                                    tool:Activate()
                                end
                            elseif getgenv().OkayFarm.mode == "Touch" then
                                for _, obj in ipairs(workspace:GetDescendants()) do
                                    if obj:IsA("BasePart") and obj.Name:lower():find("touch") then
                                        firetouchinterest(root, obj, 0)
                                        task.wait(0.05)
                                        firetouchinterest(root, obj, 1)
                                    end
                                end
                            elseif getgenv().OkayFarm.mode == "ProximityPrompt" then
                                for _, obj in ipairs(workspace:GetDescendants()) do
                                    if obj:IsA("ProximityPrompt") and fireproximityprompt then pcall(fireproximityprompt, obj) end
                                end
                            end
                        end)
                        task.wait(getgenv().OkayFarm.interval)
                    end
                    getgenv().OkayFarmLoop = nil
                end)
            end
        end)
    end)
end

OpenPlayerList = function()
    if gui:FindFirstChild("PlayerListMini") then gui.PlayerListMini:Destroy() end
    local mini = Instance.new("Frame", gui)
    mini.Name = "PlayerListMini"
    mini.Size = UDim2.new(0, ScalePixels(280), 0, ScalePixels(360))
    mini.Position = UDim2.new(0.05, 0, 0.3, 0)
    mini.BackgroundColor3 = Color3.fromRGB(12,12,12)
    mini.BackgroundTransparency = 0.25
    mini.Active = true
    Instance.new("UICorner", mini).CornerRadius = UDim.new(0, ScalePixels(8))
    Instance.new("UIStroke", mini).Color = Color3.fromRGB(200,200,200)
    local hdr = Instance.new("Frame", mini)
    hdr.Size = UDim2.new(1, 0, 0, ScalePixels(26))
    hdr.BackgroundTransparency = 1
    local ttl = Instance.new("TextLabel", hdr)
    ttl.Size = UDim2.new(1, ScalePixels(-34), 1, 0)
    ttl.Position = UDim2.new(0, ScalePixels(10), 0, 0)
    ttl.BackgroundTransparency = 1
    ttl.TextColor3 = Color3.new(1,1,1)
    ttl.Font = Enum.Font.GothamBold
    ttl.TextSize = ScalePixels(12)
    ttl.TextXAlignment = Enum.TextXAlignment.Left
    ApplyShineEffect(ttl, false)
    RegisterMiniText(ttl, "PanelPlayers")
    local cl = Instance.new("TextButton", hdr)
    cl.Size = UDim2.new(0, ScalePixels(20), 0, ScalePixels(20))
    cl.Position = UDim2.new(1, ScalePixels(-24), 0, ScalePixels(3))
    cl.BackgroundColor3 = Color3.fromRGB(30,30,30)
    cl.Text = "X"
    cl.TextColor3 = Color3.new(1,1,1)
    cl.Font = Enum.Font.GothamBold
    cl.TextSize = ScalePixels(11)
    Instance.new("UICorner", cl).CornerRadius = UDim.new(0, ScalePixels(5))
    cl.MouseButton1Click:Connect(function() mini:Destroy() end)
    local scroll = Instance.new("ScrollingFrame", mini)
    scroll.Size = UDim2.new(1, ScalePixels(-14), 1, ScalePixels(-38))
    scroll.Position = UDim2.new(0, ScalePixels(7), 0, ScalePixels(30))
    scroll.BackgroundTransparency = 1
    scroll.ScrollBarThickness = ScalePixels(3)
    scroll.CanvasSize = UDim2.new(0,0,0,0)
    scroll.AutomaticCanvasSize = Enum.AutomaticSize.Y
    Instance.new("UIListLayout", scroll).Padding = UDim.new(0, ScalePixels(3))
    local function rebuild()
        for _, c in ipairs(scroll:GetChildren()) do if c:IsA("Frame") then c:Destroy() end end
        for _, p in ipairs(Players:GetPlayers()) do
            if p == player then continue end
            local row = Instance.new("Frame", scroll)
            row.Size = UDim2.new(1, 0, 0, ScalePixels(26))
            row.BackgroundColor3 = Color3.fromRGB(20,20,20)
            Instance.new("UICorner", row).CornerRadius = UDim.new(0, ScalePixels(4))
            local nameL = Instance.new("TextLabel", row)
            nameL.Size = UDim2.new(1, ScalePixels(-130), 1, 0)
            nameL.Position = UDim2.new(0, ScalePixels(6), 0, 0)
            nameL.BackgroundTransparency = 1
            nameL.Text = p.Name
            nameL.TextColor3 = Color3.new(1,1,1)
            nameL.Font = Enum.Font.GothamBold
            nameL.TextSize = ScalePixels(10)
            nameL.TextXAlignment = Enum.TextXAlignment.Left
            nameL.TextTruncate = Enum.TextTruncate.AtEnd
            local tpB = Instance.new("TextButton", row)
            tpB.Size = UDim2.new(0, ScalePixels(32), 0, ScalePixels(18))
            tpB.Position = UDim2.new(1, ScalePixels(-118), 0.5, ScalePixels(-9))
            tpB.BackgroundColor3 = Color3.fromRGB(30,30,60)
            tpB.Text = "TP"
            tpB.TextColor3 = Color3.fromRGB(150,200,255)
            tpB.Font = Enum.Font.GothamBold
            tpB.TextSize = ScalePixels(9)
            Instance.new("UICorner", tpB).CornerRadius = UDim.new(0, ScalePixels(3))
            tpB.MouseButton1Click:Connect(function()
                local myRoot = player.Character and player.Character:FindFirstChild("HumanoidRootPart")
                local trg = p.Character and p.Character:FindFirstChild("HumanoidRootPart")
                if myRoot and trg then myRoot.CFrame = trg.CFrame * CFrame.new(0, 3, 0) end
            end)
            local specB = Instance.new("TextButton", row)
            specB.Size = UDim2.new(0, ScalePixels(44), 0, ScalePixels(18))
            specB.Position = UDim2.new(1, ScalePixels(-82), 0.5, ScalePixels(-9))
            specB.BackgroundColor3 = Color3.fromRGB(30,60,30)
            specB.Text = "SPEC"
            specB.TextColor3 = Color3.fromRGB(150,255,150)
            specB.Font = Enum.Font.GothamBold
            specB.TextSize = ScalePixels(9)
            Instance.new("UICorner", specB).CornerRadius = UDim.new(0, ScalePixels(3))
            specB.MouseButton1Click:Connect(function()
                local trg = p.Character and p.Character:FindFirstChildOfClass("Humanoid")
                if trg and workspace.CurrentCamera then workspace.CurrentCamera.CameraSubject = trg end
            end)
            local killB = Instance.new("TextButton", row)
            killB.Size = UDim2.new(0, ScalePixels(32), 0, ScalePixels(18))
            killB.Position = UDim2.new(1, ScalePixels(-46), 0.5, ScalePixels(-9))
            killB.BackgroundColor3 = Color3.fromRGB(60,20,20)
            killB.Text = "KILL"
            killB.TextColor3 = Color3.fromRGB(255,150,150)
            killB.Font = Enum.Font.GothamBold
            killB.TextSize = ScalePixels(8)
            Instance.new("UICorner", killB).CornerRadius = UDim.new(0, ScalePixels(3))
            killB.MouseButton1Click:Connect(function()
                local hum = p.Character and p.Character:FindFirstChildOfClass("Humanoid")
                if hum then hum.Health = 0 end
            end)
            local sitB = Instance.new("TextButton", row)
            sitB.Size = UDim2.new(0, ScalePixels(14), 0, ScalePixels(18))
            sitB.Position = UDim2.new(1, ScalePixels(-14), 0.5, ScalePixels(-9))
            sitB.BackgroundColor3 = Color3.fromRGB(60,30,60)
            sitB.Text = "×"
            sitB.TextColor3 = Color3.fromRGB(255,150,255)
            sitB.Font = Enum.Font.GothamBold
            sitB.TextSize = ScalePixels(11)
            Instance.new("UICorner", sitB).CornerRadius = UDim.new(0, ScalePixels(3))
            sitB.MouseButton1Click:Connect(function()
                local hum = p.Character and p.Character:FindFirstChildOfClass("Humanoid")
                if hum then hum.Sit = true end
            end)
        end
    end
    rebuild()
    Players.PlayerAdded:Connect(function() task.wait(1) rebuild() end)
    Players.PlayerRemoving:Connect(function() rebuild() end)
    MakeDraggable(mini, hdr)
end

OpenGiveToolGui = function()
    CreateMiniGuiSmall("GiveToolMini", "PanelGiveTool", 80, function(content)
        local box = Instance.new("TextBox", content)
        box.Size = UDim2.new(1,0,0,ScalePixels(22))
        box.BackgroundColor3 = Color3.fromRGB(20,20,20)
        box.PlaceholderText = Text("NamePlaceholder")
        box.TextColor3 = Color3.new(1,1,1)
        box.Font = Enum.Font.GothamMedium
        box.TextSize = ScalePixels(10)
        Instance.new("UICorner", box).CornerRadius = UDim.new(0, ScalePixels(4))
        local b = Instance.new("TextButton", content)
        b.Size = UDim2.new(1,0,0,ScalePixels(22))
        b.BackgroundColor3 = Color3.fromRGB(30,30,30)
        b.TextColor3 = Color3.new(1,1,1)
        b.Font = Enum.Font.GothamBold
        b.TextSize = ScalePixels(10)
        Instance.new("UICorner", b).CornerRadius = UDim.new(0, ScalePixels(4))
        RegisterMiniText(b, "Give")
        b.MouseButton1Click:Connect(function()
            local q = box.Text:lower()
            if q == "" then return end
            local bp = player:FindFirstChild("Backpack")
            local char = player.Character
            if not bp then return end
            local candidates = {}
            if bp then for _, t in ipairs(bp:GetChildren()) do if t:IsA("Tool") then table.insert(candidates, t) end end end
            if char then for _, t in ipairs(char:GetChildren()) do if t:IsA("Tool") then table.insert(candidates, t) end end end
            for _, t in ipairs(candidates) do
                if t.Name:lower():find(q) then
                    local c = t:Clone()
                    c.Parent = bp
                    return
                end
            end
        end)
    end)
end

OpenToolListGui = function()
    CreateMiniGuiSmall("ToolListMini", "PanelToolList", 200, function(content)
        local list = Instance.new("ScrollingFrame", content)
        list.Size = UDim2.new(1,0,0,ScalePixels(170))
        list.BackgroundColor3 = Color3.fromRGB(15,15,15)
        list.BorderSizePixel = 0
        list.ScrollBarThickness = ScalePixels(3)
        list.CanvasSize = UDim2.new(0,0,0,0)
        list.AutomaticCanvasSize = Enum.AutomaticSize.Y
        Instance.new("UICorner", list).CornerRadius = UDim.new(0, ScalePixels(4))
        Instance.new("UIListLayout", list).Padding = UDim.new(0, ScalePixels(3))
        local bp = player:FindFirstChild("Backpack")
        if bp then
            for _, t in ipairs(bp:GetChildren()) do
                if t:IsA("Tool") then
                    local b = Instance.new("TextButton", list)
                    b.Size = UDim2.new(1,0,0,ScalePixels(18))
                    b.BackgroundColor3 = Color3.fromRGB(22,22,22)
                    b.Text = t.Name
                    b.TextColor3 = Color3.new(1,1,1)
                    b.Font = Enum.Font.GothamBold
                    b.TextSize = ScalePixels(9)
                    Instance.new("UICorner", b).CornerRadius = UDim.new(0, ScalePixels(3))
                    b.MouseButton1Click:Connect(function()
                        local c = t:Clone()
                        c.Parent = bp
                    end)
                end
            end
        end
    end)
end

OpenCharScaleGui = function()
    CreateMiniGuiSmall("ScaleMini2", "PanelScale", 90, function(content)
        local box = Instance.new("TextBox", content)
        box.Size = UDim2.new(1,0,0,ScalePixels(22))
        box.BackgroundColor3 = Color3.fromRGB(20,20,20)
        box.Text = "1"
        box.TextColor3 = Color3.new(1,1,1)
        box.Font = Enum.Font.GothamMedium
        box.TextSize = ScalePixels(10)
        Instance.new("UICorner", box).CornerRadius = UDim.new(0, ScalePixels(4))
        box.FocusLost:Connect(function()
            local v = tonumber(box.Text)
            if not v then return end
            local char = player.Character
            local hum = char and char:FindFirstChildOfClass("Humanoid")
            if not hum then return end
            local bhs = hum:FindFirstChild("BodyHeightScale")
            if not bhs then bhs = Instance.new("NumberValue", hum) bhs.Name = "BodyHeightScale" end
            bhs.Value = v
        end)
    end)
end

OpenHeadScaleGui = function()
    CreateMiniGuiSmall("HeadScaleMini", "PanelHeadSize", 90, function(content)
        local box = Instance.new("TextBox", content)
        box.Size = UDim2.new(1,0,0,ScalePixels(22))
        box.BackgroundColor3 = Color3.fromRGB(20,20,20)
        box.Text = "1"
        box.TextColor3 = Color3.new(1,1,1)
        box.Font = Enum.Font.GothamMedium
        box.TextSize = ScalePixels(10)
        Instance.new("UICorner", box).CornerRadius = UDim.new(0, ScalePixels(4))
        box.FocusLost:Connect(function()
            local v = tonumber(box.Text)
            if not v then return end
            local char = player.Character
            local head = char and char:FindFirstChild("Head")
            if not head then return end
            local mesh = head:FindFirstChildOfClass("SpecialMesh")
            if mesh then mesh.Scale = Vector3.new(v,v,v) else head.Size = Vector3.new(2,1,1) * v end
        end)
    end)
end

OpenGravityGui = function()
    CreateMiniGuiSmall("GravityMini2", "PanelGravity", 90, function(content)
        local box = Instance.new("TextBox", content)
        box.Size = UDim2.new(1,0,0,ScalePixels(22))
        box.BackgroundColor3 = Color3.fromRGB(20,20,20)
        box.Text = tostring(workspace.Gravity)
        box.TextColor3 = Color3.new(1,1,1)
        box.Font = Enum.Font.GothamMedium
        box.TextSize = ScalePixels(10)
        Instance.new("UICorner", box).CornerRadius = UDim.new(0, ScalePixels(4))
        box.FocusLost:Connect(function()
            local v = tonumber(box.Text)
            if v then workspace.Gravity = v end
        end)
    end)
end

getgenv().OkayHue = { Running = false, Conn = nil, OriginalColors = {} }
StartHue = function()
    if getgenv().OkayHue.Running then return end
    getgenv().OkayHue.Running = true
    getgenv().OkayHue.OriginalColors = {}
    local char = player.Character
    if char then
        for _, part in ipairs(char:GetChildren()) do
            if part:IsA("BasePart") then
                getgenv().OkayHue.OriginalColors[part] = part.Color
            end
        end
    end
    getgenv().OkayHue.Conn = RunService.Heartbeat:Connect(function()
        local c = player.Character
        if not c then return end
        local hue = tick() % 5 / 5
        local color = Color3.fromHSV(hue, 1, 1)
        for _, part in ipairs(c:GetChildren()) do
            if part:IsA("BasePart") then
                if not getgenv().OkayHue.OriginalColors[part] then
                    getgenv().OkayHue.OriginalColors[part] = part.Color
                end
                part.Color = color
            end
        end
    end)
end
StopHue = function()
    getgenv().OkayHue.Running = false
    if getgenv().OkayHue.Conn then getgenv().OkayHue.Conn:Disconnect() getgenv().OkayHue.Conn = nil end
    for part, col in pairs(getgenv().OkayHue.OriginalColors) do
        pcall(function() if part and part.Parent then part.Color = col end end)
    end
    getgenv().OkayHue.OriginalColors = {}
end

HopLowServer = function()
    local req = game:HttpGet("https://games.roblox.com/v1/games/"..game.PlaceId.."/servers/Public?sortOrder=Asc&limit=100")
    local data = HttpService:JSONDecode(req)
    for _, s in pairs(data.data) do
        if s.playing > 0 and s.playing <= 3 and s.id ~= game.JobId then
            TeleportService:TeleportToPlaceInstance(game.PlaceId, s.id, player)
            return
        end
    end
    NotificationSystem:Show(CurrentLanguage == "vn" and "Không tìm thấy server ít người" or "No low server found")
end

HopVipServer = function()
    local req = game:HttpGet("https://games.roblox.com/v1/games/"..game.PlaceId.."/servers/Public?sortOrder=Asc&limit=100")
    local data = HttpService:JSONDecode(req)
    for _, s in pairs(data.data) do
        if s.playing == 1 and s.id ~= game.JobId then
            TeleportService:TeleportToPlaceInstance(game.PlaceId, s.id, player)
            return
        end
    end
    for _, s in pairs(data.data) do
        if s.playing < 3 and s.id ~= game.JobId then
            TeleportService:TeleportToPlaceInstance(game.PlaceId, s.id, player)
            return
        end
    end
    NotificationSystem:Show(CurrentLanguage == "vn" and "Không tìm thấy server VIP" or "No VIP server found")
end

RejoinSameServer = function()
    local placeId = game.PlaceId
    local jobId = game.JobId
    if #Players:GetPlayers() <= 1 then
        TeleportService:Teleport(placeId, player)
    else
        TeleportService:TeleportToPlaceInstance(placeId, jobId, player)
    end
end

OpenServerInfoGui = function()
    CreateMiniGuiSmall("ServerInfoMini", "PanelServerInfo", 130, function(content)
        local function makeLabel(text)
            local l = Instance.new("TextLabel", content)
            l.Size = UDim2.new(1,0,0,ScalePixels(20))
            l.BackgroundColor3 = Color3.fromRGB(22,22,22)
            l.Text = text
            l.TextColor3 = Color3.new(1,1,1)
            l.Font = Enum.Font.GothamBold
            l.TextSize = ScalePixels(10)
            Instance.new("UICorner", l).CornerRadius = UDim.new(0, ScalePixels(4))
            l.MouseButton1Click:Connect(function()
                if setclipboard then setclipboard(text) NotificationSystem:Show(CurrentLanguage == "vn" and "Đã sao chép" or "Copied", 2) end
            end)
        end
        makeLabel("PlaceID: " .. tostring(game.PlaceId))
        makeLabel("JobID: " .. tostring(game.JobId):sub(1, 12))
        makeLabel("Players: " .. #Players:GetPlayers() .. "/" .. Players.MaxPlayers)
    end)
end

ScriptData = {
    TrangChu = {
        { Name = "KillNPC", Type = "Button", Callback = function()
            loadstring(game:HttpGet("https://pastefy.app/Wl8lwLb4/raw"))()
            NotifyExec("KillNPC")
        end },
        { Name = "TouchFling", Type = "Button", Callback = function()
            loadstring(game:HttpGet("https://pastefy.app/5PsadgYM/raw"))()
            NotifyExec("TouchFling")
        end },
        { Name = "GodMode", Type = "Button", Callback = function()
            OpenGodModeGui()
            NotifyOpen("GodMode")
        end },
        { Name = "BayV2", Type = "Button", Callback = function()
            loadstring(game:HttpGet("https://pastefy.app/ZcG8vDIi/raw"))()
            NotifyExec("BayV2")
        end },
        { Name = "NhayVoHan", Type = "Toggle", Callback = function(s)
            ToggleInfiniteJump(s)
            NotifyOnOff(s, "NhayVoHan")
        end },
        { Name = "MaxZoom", Type = "Button", Callback = function()
            player.CameraMaxZoomDistance = 999999
            player.CameraMinZoomDistance = 0
            NotificationSystem:Show(CurrentLanguage == "vn" and "Đã mở khóa Camera Zoom" or "Camera Zoom unlocked")
        end },
        { Name = "TangHinh", Type = "Button", Callback = function()
            loadstring(game:HttpGet("https://pastefy.app/pWyEUVTR/raw"))()
            NotifyExec("TangHinh")
        end },
        { Name = "TangHinhV1", Type = "Button", Callback = function()
            loadstring(game:HttpGet("https://pastefy.app/Bm4CE4ax/raw"))()
            NotifyExec("TangHinhV1")
        end },
        { Name = "TangHinhV3", Type = "Button", Callback = function()
            loadstring(game:HttpGet("https://pastefy.app/zs61SM0i/raw"))()
            NotifyExec("TangHinhV3")
        end },
        { Name = "NamelessAdmin", Type = "Button", Callback = function()
            loadstring(game:HttpGet("https://raw.githubusercontent.com/FilteringEnabled/NamelessAdmin/main/Loader.lua"))()
            NotifyLoad("NamelessAdmin")
        end },
    },
    DiChuyen = {
        { Name = "SpeedJumpPanel", Type = "Button", Callback = function() OpenSpeedJumpGui() NotifyOpen("SpeedJumpPanel") end },
        { Name = "TPPlayerPanel", Type = "Button", Callback = function() OpenTPGui() NotifyOpen("TPPlayerPanel") end },
        { Name = "ClickTP", Type = "Button", Callback = function()
            local tool = Instance.new("Tool")
            tool.Name = "Click TP"
            tool.RequiresHandle = false
            tool.Parent = player.Backpack
            tool.Activated:Connect(function()
                local root = player.Character and player.Character:FindFirstChild("HumanoidRootPart")
                if root and player:GetMouse().Hit then
                    TweenService:Create(root, TweenInfo.new(0.15), { CFrame = CFrame.new(player:GetMouse().Hit.p + Vector3.new(0, 3, 0)) }):Play()
                end
            end)
            NotificationSystem:Show(CurrentLanguage == "vn" and ("Đã thêm: " .. Text("ClickTPTool")) or ("Added: " .. Text("ClickTPTool")))
        end },
        { Name = "Noclip", Type = "Toggle", Callback = function(state)
            TogglesState.Noclip = state
            if noclipConn then noclipConn:Disconnect() noclipConn = nil end
            if state then
                noclipConn = RunService.Stepped:Connect(function()
                    if player.Character then
                        for _, p in pairs(player.Character:GetDescendants()) do
                            if p:IsA("BasePart") then p.CanCollide = false end
                        end
                    end
                end)
            end
            NotifyOnOff(state, "Noclip")
        end },
        { Name = "FloatPlatform", Type = "Button", Callback = function()
            CreateFloatPlatform()
            NotificationSystem:Show(CurrentLanguage == "vn" and "Đã tạo: Sàn Bay" or "Created: Float Platform")
        end },
    },
    HienThi = {
        { Name = "HitboxPanel", Type = "Button", Callback = function() OpenHitboxGui() NotifyOpen("HitboxPanel") end },
        { Name = "FullBright", Type = "Toggle", Callback = function(state)
            TogglesState.FullBright = state
            if state then Lighting.Brightness = 5 Lighting.ClockTime = 14
            else Lighting.Brightness = origBrightness Lighting.ClockTime = origClockTime end
            NotifyOnOff(state, "FullBright")
        end },
        { Name = "ESP", Type = "Toggle", Callback = function(state)
            TogglesState.ESP = state
            if _G.ESPLoop then _G.ESPLoop = false task.wait(0.3) end
            for _, p in pairs(Players:GetPlayers()) do
                if p.Character and p.Character:FindFirstChild("OkayESP") then p.Character.OkayESP:Destroy() end
            end
            if state then
                _G.ESPLoop = true
                task.spawn(function()
                    while _G.ESPLoop do
                        for _, p in pairs(Players:GetPlayers()) do
                            if p ~= player and p.Character and p.Character:FindFirstChildOfClass("Humanoid") and p.Character.Humanoid.Health > 0 then
                                if not p.Character:FindFirstChild("OkayESP") then
                                    local h = Instance.new("Highlight", p.Character)
                                    h.Name = "OkayESP"
                                    h.FillColor = Color3.fromRGB(255,255,255)
                                    h.OutlineColor = Color3.fromRGB(255,0,0)
                                    h.FillTransparency = 0.7
                                    h.OutlineTransparency = 0
                                end
                            else
                                if p.Character and p.Character:FindFirstChild("OkayESP") then p.Character.OkayESP:Destroy() end
                            end
                        end
                        task.wait(0.15)
                    end
                end)
            end
            NotifyOnOff(state, "ESP")
        end },
        { Name = "PlayerESP", Type = "Toggle", Callback = function(state)
            TogglesState.PlayerESP = state
            if _G.PlayerEspStatus then _G.PlayerEspStatus = false task.wait(0.3) end
            for _, p in ipairs(Players:GetPlayers()) do
                if p.Character and p.Character:FindFirstChild("Dua2dev_PlayerESP") then p.Character.Dua2dev_PlayerESP:Destroy() end
            end
            if state then
                _G.PlayerEspStatus = true
                task.spawn(function()
                    while _G.PlayerEspStatus do
                        for _, p in pairs(Players:GetPlayers()) do
                            if p ~= player and p.Character and p.Character:FindFirstChild("HumanoidRootPart") then
                                if not p.Character:FindFirstChild("Dua2dev_PlayerESP") then
                                    local h = Instance.new("Highlight", p.Character)
                                    h.Name = "Dua2dev_PlayerESP"
                                    h.FillColor = Color3.fromRGB(255, 0, 0)
                                    h.OutlineColor = Color3.fromRGB(255, 255, 255)
                                end
                            end
                        end
                        task.wait(0.3)
                    end
                end)
            end
            NotifyOnOff(state, "PlayerESP")
        end },
        { Name = "NpcESP", Type = "Toggle", Callback = function(state)
            TogglesState.NpcESP = state
            if _G.NpcEspStatus then _G.NpcEspStatus = false task.wait(0.3) end
            for _, v in ipairs(workspace:GetDescendants()) do
                if v:IsA("Highlight") and v.Name == "Dua2dev_NpcESP" then v:Destroy() end
            end
            if state then
                _G.NpcEspStatus = true
                task.spawn(function()
                    while _G.NpcEspStatus do
                        for _, v in pairs(workspace:GetDescendants()) do
                            if v:IsA("Model") and v:FindFirstChildOfClass("Humanoid") and not Players:GetPlayerFromCharacter(v) then
                                if not v:FindFirstChild("Dua2dev_NpcESP") then
                                    local h = Instance.new("Highlight", v)
                                    h.Name = "Dua2dev_NpcESP"
                                    h.FillColor = Color3.fromRGB(0, 255, 100)
                                    h.OutlineColor = Color3.fromRGB(255, 255, 255)
                                end
                            end
                        end
                        task.wait(0.5)
                    end
                end)
            end
            NotifyOnOff(state, "NpcESP")
        end },
        { Name = "XRay", Type = "Toggle", Callback = function(state)
            TogglesState.XRay = state
            if state then
                for _, v in ipairs(workspace:GetDescendants()) do
                    if v:IsA("BasePart") and not v:IsDescendantOf(player.Character) then
                        pcall(function() v.LocalTransparencyModifier = 1 end)
                    end
                end
            else
                for _, v in ipairs(workspace:GetDescendants()) do
                    if v:IsA("BasePart") then
                        pcall(function() v.LocalTransparencyModifier = 0 end)
                    end
                end
            end
            NotifyOnOff(state, "XRay")
        end },
        { Name = "FPSBoost", Type = "Button", Callback = function()
            for _, v in pairs(workspace:GetDescendants()) do
                if v:IsA("BasePart") and not v:IsA("MeshPart") then v.Material = Enum.Material.SmoothPlastic
                elseif v:IsA("Decal") or v:IsA("Texture") then v:Destroy() end
            end
            if setfpscap then setfpscap(360) end
            NotificationSystem:Show(CurrentLanguage == "vn" and "Đã tăng FPS" or "FPS Boosted")
        end },
        { Name = "InstBrowser", Type = "Button", Callback = function() OpenInstanceBrowser() NotifyOpen("InstBrowser") end },
        { Name = "MasterESP", Type = "Button", Callback = function()
            loadstring(game:HttpGet("https://raw.githubusercontent.com/skatbr/Roblox-Releases/main/Aimbot%20v3.lua"))()
            NotifyExec("MasterESP")
        end },
    },
    NguoiChoi = {
        { Name = "AimbotPanel", Type = "Button", Callback = function() OpenAimbotGui() NotifyOpen("AimbotPanel") end },
        { Name = "SilentAimPanel", Type = "Button", Callback = function() OpenSilentAimGui() NotifyOpen("SilentAimPanel") end },
        { Name = "AutoFarm", Type = "Button", Callback = function() OpenAutoFarmGui() NotifyOpen("AutoFarm") end },
        { Name = "PlayerList", Type = "Button", Callback = function() OpenPlayerList() NotifyOpen("PlayerList") end },
        { Name = "AnimSpeed", Type = "Toggle", Callback = function(s)
            TogglesState.AnimSpeed = s
            if s then
                if getgenv().OkayAnimSpeedConn then getgenv().OkayAnimSpeedConn:Disconnect() end
                getgenv().OkayAnimSpeedConn = RunService.Heartbeat:Connect(function()
                    local char = player.Character
                    if not char then return end
                    local hum = char:FindFirstChildOfClass("Humanoid")
                    if not hum then return end
                    local animator = hum:FindFirstChildOfClass("Animator")
                    if not animator then return end
                    for _, track in ipairs(animator:GetPlayingAnimationTracks()) do
                        pcall(function() track:AdjustSpeed(5) end)
                    end
                end)
            else
                if getgenv().OkayAnimSpeedConn then getgenv().OkayAnimSpeedConn:Disconnect() getgenv().OkayAnimSpeedConn = nil end
            end
            NotifyOnOff(s, "AnimSpeed")
        end },
        { Name = "FakeLag", Type = "Toggle", Callback = function(s)
            TogglesState.FakeLag = s
            if s then
                if getgenv().OkayFakeLagConn then pcall(task.cancel, getgenv().OkayFakeLagConn) end
                getgenv().OkayFakeLagConn = task.spawn(function()
                    while TogglesState.FakeLag do
                        local c = player.Character
                        local r = c and c:FindFirstChild("HumanoidRootPart")
                        if r then
                            pcall(function() r.Anchored = true end)
                            task.wait(0.5)
                            pcall(function() r.Anchored = false end)
                            task.wait(0.02)
                        else
                            task.wait(0.1)
                        end
                    end
                end)
            else
                if getgenv().OkayFakeLagConn then pcall(task.cancel, getgenv().OkayFakeLagConn) getgenv().OkayFakeLagConn = nil end
                local char = player.Character
                local hrp = char and char:FindFirstChild("HumanoidRootPart")
                if hrp then pcall(function() hrp.Anchored = false end) end
            end
            NotifyOnOff(s, "FakeLag")
        end },
        { Name = "Spectate", Type = "Button", Callback = function()
            CreateMiniGuiSmall("SpectateMini", "PanelSpectate", 200, function(content)
                local list = Instance.new("ScrollingFrame", content)
                list.Size = UDim2.new(1, 0, 1, 0)
                list.BackgroundColor3 = Color3.fromRGB(15,15,15)
                list.BorderSizePixel = 0
                list.ScrollBarThickness = ScalePixels(3)
                list.CanvasSize = UDim2.new(0,0,0,0)
                list.AutomaticCanvasSize = Enum.AutomaticSize.Y
                Instance.new("UICorner", list).CornerRadius = UDim.new(0, ScalePixels(4))
                Instance.new("UIListLayout", list).Padding = UDim.new(0, ScalePixels(3))
                for _, p in ipairs(Players:GetPlayers()) do
                    if p == player then continue end
                    local b = Instance.new("TextButton", list)
                    b.Size = UDim2.new(1, 0, 0, ScalePixels(20))
                    b.BackgroundColor3 = Color3.fromRGB(22,22,22)
                    b.Text = p.Name
                    b.TextColor3 = Color3.new(1,1,1)
                    b.Font = Enum.Font.GothamBold
                    b.TextSize = ScalePixels(10)
                    Instance.new("UICorner", b).CornerRadius = UDim.new(0, ScalePixels(3))
                    b.MouseButton1Click:Connect(function()
                        local hum = p.Character and p.Character:FindFirstChildOfClass("Humanoid")
                        if hum and workspace.CurrentCamera then
                            workspace.CurrentCamera.CameraSubject = hum
                            NotificationSystem:Show((CurrentLanguage == "vn" and "Đang theo dõi: " or "Spectating: ") .. p.Name)
                        end
                    end)
                end
            end)
        end },
        { Name = "BringPlayers", Type = "Button", Callback = function()
            local myRoot = player.Character and player.Character:FindFirstChild("HumanoidRootPart")
            if not myRoot then return end
            for _, p in ipairs(Players:GetPlayers()) do
                if p ~= player and p.Character and p.Character:FindFirstChild("HumanoidRootPart") then
                    pcall(function()
                        p.Character.HumanoidRootPart.CFrame = myRoot.CFrame * CFrame.new(0, 0, -4)
                    end)
                end
            end
            NotificationSystem:Show(CurrentLanguage == "vn" and "Đã gom người chơi" or "Players brought")
        end },
        { Name = "BringNpcs", Type = "Button", Callback = function()
            local myRoot = player.Character and player.Character:FindFirstChild("HumanoidRootPart")
            if not myRoot then return end
            for _, v in ipairs(workspace:GetDescendants()) do
                if v:IsA("Model") and v:FindFirstChildOfClass("Humanoid") and not Players:GetPlayerFromCharacter(v) then
                    local npcRoot = v:FindFirstChild("HumanoidRootPart")
                    if npcRoot then
                        pcall(function()
                            npcRoot.CFrame = myRoot.CFrame * CFrame.new(0, 0, -5)
                        end)
                    end
                end
            end
            NotificationSystem:Show(CurrentLanguage == "vn" and "Đã gom NPC" or "NPCs brought")
        end },
        { Name = "ResetChar", Type = "Button", Callback = function()
            if player.Character then
                local hum = player.Character:FindFirstChildOfClass("Humanoid")
                if hum then hum.Health = 0 else player.Character:BreakJoints() end
            end
            NotificationSystem:Show(CurrentLanguage == "vn" and "Đã hồi sinh nhân vật" or "Character reset")
        end },
        { Name = "PackBack", Type = "Button", Callback = function()
            loadstring(game:HttpGet("https://pastefy.app/vPuVsajY/raw"))()
            NotifyLoad("PackBack")
        end },
        { Name = "ShiftLock", Type = "Button", Callback = function()
            loadstring(game:HttpGet("https://pastefy.app/nI6sZf0v/raw"))()
            NotifyExec("ShiftLock")
        end },
        { Name = "AimBotAce", Type = "Button", Callback = function()
            loadstring(game:HttpGet("https://raw.githubusercontent.com/Totocoems/Ace/main/Ace"))()
            NotifyExec("AimBotAce")
        end },
        { Name = "Freecam", Type = "Button", Callback = function()
            loadstring(game:HttpGet("https://pastefy.app/MXfy1wtS/raw"))()
            NotifyLoad("Freecam")
        end },
    },
    CongCu = {
        { Name = "GiveTool", Type = "Button", Callback = function() OpenGiveToolGui() NotifyOpen("GiveTool") end },
        { Name = "ToolList", Type = "Button", Callback = function() OpenToolListGui() NotifyOpen("ToolList") end },
        { Name = "DupeTool", Type = "Button", Callback = function()
            local bp = player:FindFirstChild("Backpack")
            local char = player.Character
            if not bp then return end
            local list = {}
            for _, t in ipairs(bp:GetChildren()) do if t:IsA("Tool") then table.insert(list, t) end end
            if char then for _, t in ipairs(char:GetChildren()) do if t:IsA("Tool") then table.insert(list, t) end end end
            for _, t in ipairs(list) do
                pcall(function()
                    local c = t:Clone()
                    c.Parent = bp
                end)
            end
            NotificationSystem:Show(CurrentLanguage == "vn" and "Đã nhân đôi tất cả tool" or "All tools duped")
        end },
    },
    NhanVat = {
        { Name = "CharScale", Type = "Button", Callback = function() OpenCharScaleGui() NotifyOpen("CharScale") end },
        { Name = "HeadSize", Type = "Button", Callback = function() OpenHeadScaleGui() NotifyOpen("HeadSize") end },
        { Name = "Gravity", Type = "Button", Callback = function() OpenGravityGui() NotifyOpen("Gravity") end },
        { Name = "Hue", Type = "Toggle", Callback = function(s)
            if s then StartHue() else StopHue() end
            NotifyOnOff(s, "Hue")
        end },
    },
    DichThuat = {
        { Name = "LangVN", Type = "Button", Callback = function()
            SetLanguage("vn")
        end },
        { Name = "LangEN", Type = "Button", Callback = function()
            SetLanguage("en")
        end },
    },
    MayChu = {
        { Name = "Rejoin", Type = "Button", Callback = function()
            NotificationSystem:Show(CurrentLanguage == "vn" and "Đang vào lại server..." or "Rejoining...")
            TeleportService:Teleport(game.PlaceId, player)
        end },
        { Name = "ServerHop", Type = "Button", Callback = function()
            local servers = {}
            local req = game:HttpGet("https://games.roblox.com/v1/games/"..game.PlaceId.."/servers/Public?sortOrder=Asc&limit=100")
            local data = HttpService:JSONDecode(req)
            for _, server in pairs(data.data) do
                if server.playing < server.maxPlayers and server.id ~= game.JobId then
                    table.insert(servers, server.id)
                end
            end
            if #servers > 0 then
                TeleportService:TeleportToPlaceInstance(game.PlaceId, servers[math.random(1, #servers)], player)
            end
            NotificationSystem:Show(CurrentLanguage == "vn" and "Đang chuyển server..." or "Server hopping...")
        end },
        { Name = "LowServer", Type = "Button", Callback = function() HopLowServer() end },
        { Name = "VipServer", Type = "Button", Callback = function() HopVipServer() end },
        { Name = "RejoinSame", Type = "Button", Callback = function()
            RejoinSameServer()
            NotificationSystem:Show(CurrentLanguage == "vn" and "Vào lại cùng server..." or "Rejoining same...")
        end },
        { Name = "ServerInfo", Type = "Button", Callback = function() OpenServerInfoGui() end },
        { Name = "CopyJobId", Type = "Button", Callback = function()
            if setclipboard then setclipboard(tostring(game.JobId)) end
            NotificationSystem:Show(CurrentLanguage == "vn" and "Đã sao chép JobId" or "JobId copied")
        end },
        { Name = "CopyPlaceId", Type = "Button", Callback = function()
            if setclipboard then setclipboard(tostring(game.PlaceId)) end
            NotificationSystem:Show(CurrentLanguage == "vn" and "Đã sao chép PlaceId" or "PlaceId copied")
        end },
    },
    GiaiTri = {
        { Name = "RickPrime", Type = "Button", Callback = function()
            loadstring(game:HttpGet("https://pastefy.app/DOLRH5Dp/raw"))()
            NotifyExec("RickPrime")
        end },
        { Name = "SpinBot", Type = "Toggle", Callback = function(state)
            TogglesState.SpinBot = state
            if state then
                task.spawn(function()
                    while TogglesState.SpinBot do
                        task.wait()
                        local char = player.Character
                        local root = char and char:FindFirstChild("HumanoidRootPart")
                        if root then root.CFrame = root.CFrame * CFrame.Angles(0, 1145.9155902616465, 0) end
                    end
                end)
            end
            NotifyOnOff(state, "SpinBot")
        end },
        { Name = "JerkOff", Type = "Button", Callback = function()
            loadstring(game:HttpGet("https://pastefy.app/wJgFD7Lp/raw"))()
            NotifyExec("JerkOff")
        end },
        { Name = "FeEmote", Type = "Button", Callback = function()
            loadstring(game:HttpGet("https://rawscripts.net/raw/Universal-Script-7yd7-I-Emote-Script-48024"))()
            NotifyExec("FeEmote")
        end },
        { Name = "AnimPack", Type = "Button", Callback = function()
            loadstring(game:HttpGet("https://pastefy.app/VMOWTd79/raw"))()
            NotifyExec("AnimPack")
        end },
        { Name = "Disco", Type = "Toggle", Callback = function(state)
            TogglesState.Disco = state
            if state then
                local tacos = SoundService:FindFirstChild("OkayTacos") or Instance.new("Sound", SoundService)
                tacos.Name = "OkayTacos"
                tacos.SoundId = "rbxassetid://142376088"
                tacos.Volume = 1
                tacos.Looped = true
                tacos:Play()
                if getgenv().OkayDiscoConn then getgenv().OkayDiscoConn:Disconnect() end
                getgenv().OkayDiscoConn = RunService.Heartbeat:Connect(function()
                    local hue = tick() % 5 / 5
                    local c = Color3.fromHSV(hue, 1, 1)
                    Lighting.Ambient = c
                    Lighting.OutdoorAmbient = c
                    Lighting.ColorShift_Top = c
                    Lighting.ColorShift_Bottom = c
                    Lighting.FogColor = c
                end)
            else
                local tacos = SoundService:FindFirstChild("OkayTacos")
                if tacos then tacos:Stop() end
                if getgenv().OkayDiscoConn then getgenv().OkayDiscoConn:Disconnect() getgenv().OkayDiscoConn = nil end
                Lighting.Ambient = origAmbient
                Lighting.OutdoorAmbient = origOutdoor
                Lighting.ColorShift_Top = origColorShiftTop
                Lighting.ColorShift_Bottom = origColorShiftBottom
                Lighting.FogColor = origAmbient
            end
            NotifyOnOff(state, "Disco")
        end },
        { Name = "PortalGun", Type = "Button", Callback = function()
            loadstring(game:HttpGet("https://pastefy.app/0TohwsID/raw"))()
            NotificationSystem:Show(CurrentLanguage == "vn" and "Đã chạy: Súng Portal Rick C137" or "Executed: Rick C137 Portal Gun")
        end },
        { Name = "RickBomb", Type = "Button", Callback = function()
            loadstring(game:HttpGet("https://pastefy.app/n9ROxwGo/raw"))()
            NotificationSystem:Show(CurrentLanguage == "vn" and "Đã chạy: Bom Rick Prime" or "Executed: Rick Prime Bomb")
        end },
    },
    Support = {
        { Name = "DiscordPanel", Type = "Button", Callback = function()
            if gui:FindFirstChild("SupportMini") then gui.SupportMini:Destroy() end
            local mini = Instance.new("Frame", gui)
            mini.Name = "SupportMini"
            mini.Size = UDim2.new(0, ScalePixels(280), 0, ScalePixels(340))
            mini.Position = UDim2.new(0.5, ScalePixels(-140), 0.4, 0)
            mini.BackgroundColor3 = Color3.fromRGB(12, 12, 12)
            mini.BackgroundTransparency = 0.15
            mini.Active = true
            Instance.new("UICorner", mini).CornerRadius = UDim.new(0, ScalePixels(14))
            local stroke = Instance.new("UIStroke", mini)
            stroke.Color = Color3.fromRGB(150, 150, 150)
            stroke.Thickness = ScalePixels(1.5)
            local banner = Instance.new("Frame", mini)
            banner.Size = UDim2.new(1, ScalePixels(-20), 0, ScalePixels(95))
            banner.Position = UDim2.new(0, ScalePixels(10), 0, ScalePixels(10))
            banner.BackgroundColor3 = Color3.fromRGB(88, 101, 242)
            Instance.new("UICorner", banner).CornerRadius = UDim.new(0, ScalePixels(12))
            local grad = Instance.new("UIGradient", banner)
            grad.Color = ColorSequence.new(Color3.fromRGB(88, 101, 242), Color3.fromRGB(150, 90, 255))
            grad.Rotation = 45
            local icon = Instance.new("TextLabel", banner)
            icon.Size = UDim2.new(0, ScalePixels(55), 0, ScalePixels(55))
            icon.Position = UDim2.new(0, ScalePixels(15), 0.5, ScalePixels(-28))
            icon.BackgroundTransparency = 1
            icon.Text = "💬"
            icon.TextColor3 = Color3.fromRGB(255,255,255)
            icon.TextSize = ScalePixels(42)
            icon.Font = Enum.Font.GothamBold
            local title = Instance.new("TextLabel", banner)
            title.Size = UDim2.new(1, ScalePixels(-85), 0, ScalePixels(26))
            title.Position = UDim2.new(0, ScalePixels(80), 0, ScalePixels(20))
            title.BackgroundTransparency = 1
            title.Text = "OKAY HUB"
            title.TextColor3 = Color3.fromRGB(255,255,255)
            title.Font = Enum.Font.GothamBold
            title.TextSize = ScalePixels(20)
            title.TextXAlignment = Enum.TextXAlignment.Left
            local sub = Instance.new("TextLabel", banner)
            sub.Size = UDim2.new(1, ScalePixels(-85), 0, ScalePixels(20))
            sub.Position = UDim2.new(0, ScalePixels(80), 0, ScalePixels(48))
            sub.BackgroundTransparency = 1
            sub.Text = "discord.gg/rdhWDYuyg8"
            sub.TextColor3 = Color3.fromRGB(230, 230, 255)
            sub.Font = Enum.Font.GothamMedium
            sub.TextSize = ScalePixels(12)
            sub.TextXAlignment = Enum.TextXAlignment.Left
            local function makeBtn(text, yOffset, color, callback)
                local btn = Instance.new("TextButton", mini)
                btn.Size = UDim2.new(1, ScalePixels(-20), 0, ScalePixels(42))
                btn.Position = UDim2.new(0, ScalePixels(10), 0, ScalePixels(yOffset))
                btn.BackgroundColor3 = color
                btn.Text = text
                btn.TextColor3 = Color3.fromRGB(255,255,255)
                btn.Font = Enum.Font.GothamBold
                btn.TextSize = ScalePixels(13)
                btn.AutoButtonColor = false
                Instance.new("UICorner", btn).CornerRadius = UDim.new(0, ScalePixels(10))
                local bStroke = Instance.new("UIStroke", btn)
                bStroke.Color = Color3.fromRGB(255,255,255)
                bStroke.Thickness = ScalePixels(1)
                bStroke.Transparency = 0.75
                btn.MouseEnter:Connect(function()
                    TweenService:Create(btn, TweenInfo.new(0.15), { BackgroundColor3 = color:Lerp(Color3.fromRGB(255,255,255), 0.15) }):Play()
                    TweenService:Create(bStroke, TweenInfo.new(0.15), { Transparency = 0.3 }):Play()
                end)
                btn.MouseLeave:Connect(function()
                    TweenService:Create(btn, TweenInfo.new(0.15), { BackgroundColor3 = color }):Play()
                    TweenService:Create(bStroke, TweenInfo.new(0.15), { Transparency = 0.75 }):Play()
                end)
                btn.MouseButton1Click:Connect(callback)
                ApplyShineEffect(btn, false)
                return btn
            end
            makeBtn("✦ " .. Text("JoinDiscord"), 115, Color3.fromRGB(88, 101, 242), function()
                if setclipboard then setclipboard("https://discord.gg/rdhWDYuyg8") end
                local req = (syn and syn.request) or (http and http.request) or http_request or request or (fluxus and fluxus.request)
                pcall(function()
                    if req then req({Url = "https://discord.gg/rdhWDYuyg8", Method = "GET"})
                    else game:GetService("GuiService"):OpenBrowserWindow("https://discord.gg/rdhWDYuyg8") end
                end)
                NotificationSystem:Show(CurrentLanguage == "vn" and "Đã sao chép: discord.gg/rdhWDYuyg8" or "Copied: discord.gg/rdhWDYuyg8", 5)
            end)
            makeBtn("📋 " .. Text("CopyLink"), 165, Color3.fromRGB(45, 45, 55), function()
                if setclipboard then setclipboard("https://discord.gg/rdhWDYuyg8") end
                NotificationSystem:Show(CurrentLanguage == "vn" and "Đã sao chép: discord.gg/rdhWDYuyg8" or "Copied: discord.gg/rdhWDYuyg8", 3)
            end)
            makeBtn("🌐 " .. Text("OpenBrowser"), 215, Color3.fromRGB(45, 45, 55), function()
                local req = (syn and syn.request) or (http and http.request) or http_request or request or (fluxus and fluxus.request)
                local ok = false
                pcall(function()
                    if req then req({Url = "https://discord.gg/rdhWDYuyg8", Method = "GET"}) ok = true
                    else game:GetService("GuiService"):OpenBrowserWindow("https://discord.gg/rdhWDYuyg8") ok = true end
                end)
                NotificationSystem:Show(ok and (CurrentLanguage == "vn" and "Đang mở Discord..." or "Opening Discord...") or (CurrentLanguage == "vn" and "Hãy sao chép thủ công" or "Copy manually"), 3)
            end)
            local info = Instance.new("TextLabel", mini)
            info.Size = UDim2.new(1, ScalePixels(-20), 0, ScalePixels(50))
            info.Position = UDim2.new(0, ScalePixels(10), 0, ScalePixels(270))
            info.BackgroundTransparency = 1
            info.Text = "OKAY HUB V3.6\nMade by BAO ✦"
            info.TextColor3 = Color3.fromRGB(140, 140, 140)
            info.Font = Enum.Font.GothamMedium
            info.TextSize = ScalePixels(11)
            info.TextWrapped = true
            local closeBtn = Instance.new("TextButton", mini)
            closeBtn.Size = UDim2.new(0, ScalePixels(26), 0, ScalePixels(26))
            closeBtn.Position = UDim2.new(1, ScalePixels(-34), 0, ScalePixels(10))
            closeBtn.BackgroundColor3 = Color3.fromRGB(0, 0, 0)
            closeBtn.BackgroundTransparency = 0.6
            closeBtn.Text = "✕"
            closeBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
            closeBtn.Font = Enum.Font.GothamBold
            closeBtn.TextSize = ScalePixels(14)
            Instance.new("UICorner", closeBtn).CornerRadius = UDim.new(0, ScalePixels(6))
            closeBtn.MouseButton1Click:Connect(function() mini:Destroy() end)
            local header = Instance.new("Frame", banner)
            header.Size = UDim2.new(1, 0, 1, 0)
            header.BackgroundTransparency = 1
            MakeDraggable(mini, header)
        end },
        { Name = "Version", Type = "Button", Callback = function()
            NotificationSystem:Show("OKAY HUB V3.6 | Made by BAO", 5)
        end },
        { Name = "MadeBy", Type = "Button", Callback = function()
            NotificationSystem:Show("Made by BAO ✦ | discord.gg/rdhWDYuyg8", 5)
        end },
    },
}

frame = Instance.new("Frame")
frame.Size = UDim2.new(0, ScalePixels(700), 0, ScalePixels(430))
frame.Position = UDim2.new(0.5, ScalePixels(-350), 0.5, ScalePixels(-215))
frame.BackgroundColor3 = Color3.fromRGB(10, 10, 10)
frame.BackgroundTransparency = 0.35
frame.Visible = false
frame.ClipsDescendants = true
frame.Parent = gui
Instance.new("UICorner", frame).CornerRadius = UDim.new(0, ScalePixels(16))

bgImage = Instance.new("ImageLabel", frame)
bgImage.Name = "BackgroundImage"
bgImage.Size = UDim2.new(1, 0, 1, 0)
bgImage.Position = UDim2.new(0, 0, 0, 0)
bgImage.BackgroundTransparency = 1
bgImage.Image = "rbxassetid://97880602844879"
bgImage.ScaleType = Enum.ScaleType.Crop
bgImage.ZIndex = 0
bgImage.ImageTransparency = 0.15
Instance.new("UICorner", bgImage).CornerRadius = UDim.new(0, ScalePixels(16))

frameStroke = Instance.new("UIStroke", frame)
frameStroke.Thickness = ScalePixels(2)
frameStroke.Color = Color3.fromRGB(60, 60, 60)
task.spawn(function()
    while getgenv().OkayMainLoop do
        TweenService:Create(frameStroke, TweenInfo.new(1, Enum.EasingStyle.Sine, Enum.EasingDirection.InOut), { Color = Color3.fromRGB(255, 255, 255) }):Play()
        task.wait(1)
        TweenService:Create(frameStroke, TweenInfo.new(1, Enum.EasingStyle.Sine, Enum.EasingDirection.InOut), { Color = Color3.fromRGB(15, 15, 15) }):Play()
        task.wait(1)
    end
end)

toggle = Instance.new("ImageButton", gui)
toggle.Size = UDim2.new(0, ScalePixels(70), 0, ScalePixels(70))
toggle.Position = UDim2.new(0, ScalePixels(22), 0.5, ScalePixels(-35))
toggle.BackgroundColor3 = Color3.fromRGB(15, 15, 15)
toggle.Image = "rbxassetid://107011889657637"
toggle.ClipsDescendants = true
toggle.Visible = false
Instance.new("UICorner", toggle).CornerRadius = UDim.new(0, ScalePixels(14))
ApplyShineEffect(toggle, true)
toggleStroke = Instance.new("UIStroke", toggle)
toggleStroke.Thickness = ScalePixels(1.8)
toggleStroke.Color = Color3.fromRGB(60, 60, 60)
task.spawn(function()
    while getgenv().OkayMainLoop do
        TweenService:Create(toggleStroke, TweenInfo.new(1, Enum.EasingStyle.Sine, Enum.EasingDirection.InOut), { Color = Color3.fromRGB(255, 255, 255) }):Play()
        task.wait(1)
        TweenService:Create(toggleStroke, TweenInfo.new(1, Enum.EasingStyle.Sine, Enum.EasingDirection.InOut), { Color = Color3.fromRGB(15, 15, 15) }):Play()
        task.wait(1)
    end
end)

header = Instance.new("Frame", frame)
header.Size = UDim2.new(1, ScalePixels(-26), 0, ScalePixels(70))
header.Position = UDim2.new(0, ScalePixels(13), 0, ScalePixels(13))
header.BackgroundTransparency = 1
header.ZIndex = 2
title = Instance.new("TextLabel", header)
title.Size = UDim2.new(0, ScalePixels(260), 0, ScalePixels(28))
title.Position = UDim2.new(0, ScalePixels(13), 0, ScalePixels(8))
title.BackgroundTransparency = 1
title.Font = Enum.Font.BuilderSansBold
title.TextSize = ScalePixels(24)
title.TextColor3 = Color3.fromRGB(255, 255, 255)
title.TextXAlignment = Enum.TextXAlignment.Left
title.ZIndex = 3
ApplyShineEffect(title, false)
subTitle = Instance.new("TextLabel", header)
subTitle.Size = UDim2.new(0, ScalePixels(260), 0, ScalePixels(20))
subTitle.Position = UDim2.new(0, ScalePixels(13), 0, ScalePixels(38))
subTitle.BackgroundTransparency = 1
subTitle.Font = Enum.Font.GothamBold
subTitle.TextSize = ScalePixels(12)
subTitle.TextColor3 = Color3.fromRGB(140, 140, 140)
subTitle.TextXAlignment = Enum.TextXAlignment.Left
subTitle.ZIndex = 3
ApplyShineEffect(subTitle, false)
searchBox = Instance.new("TextBox", header)
searchBox.Size = UDim2.new(0, ScalePixels(230), 0, ScalePixels(38))
searchBox.Position = UDim2.new(1, ScalePixels(-280), 0, ScalePixels(16))
searchBox.BackgroundColor3 = Color3.fromRGB(20, 20, 20)
searchBox.BackgroundTransparency = 0.55
searchBox.Text = ""
searchBox.TextColor3 = Color3.fromRGB(255, 255, 255)
searchBox.Font = Enum.Font.GothamMedium
searchBox.PlaceholderText = Text("Search")
searchBox.TextSize = ScalePixels(16)
searchBox.ZIndex = 3
Instance.new("UICorner", searchBox).CornerRadius = UDim.new(0, ScalePixels(10))
ApplyShineEffect(searchBox, false)
close = Instance.new("TextButton", header)
close.Size = UDim2.new(0, ScalePixels(38), 0, ScalePixels(38))
close.Position = UDim2.new(1, ScalePixels(-42), 0, ScalePixels(16))
close.BackgroundColor3 = Color3.fromRGB(22, 22, 22)
close.BackgroundTransparency = 0.5
close.Text = "✕"
close.TextColor3 = Color3.fromRGB(255, 255, 255)
close.Font = Enum.Font.GothamBold
close.TextSize = ScalePixels(18)
close.ZIndex = 3
Instance.new("UICorner", close).CornerRadius = UDim.new(0, ScalePixels(10))
close.MouseButton1Click:Connect(function() hide() end)
ApplyShineEffect(close, false)

mclabel = Instance.new("TextLabel", frame)
mclabel.Font = Enum.Font.GothamBold
mclabel.TextSize = ScalePixels(14)
mclabel.TextColor3 = Color3.fromRGB(180, 180, 180)
mclabel.Size = UDim2.new(0, ScalePixels(130), 0, ScalePixels(26))
mclabel.Position = UDim2.new(0, ScalePixels(18), 0, ScalePixels(95))
mclabel.BackgroundTransparency = 1
mclabel.TextXAlignment = Enum.TextXAlignment.Left
mclabel.ZIndex = 2
ApplyShineEffect(mclabel, false)
dslabel = Instance.new("TextLabel", frame)
dslabel.Font = Enum.Font.GothamBold
dslabel.TextSize = ScalePixels(14)
dslabel.TextColor3 = Color3.fromRGB(180, 180, 180)
dslabel.Size = UDim2.new(0, ScalePixels(200), 0, ScalePixels(26))
dslabel.Position = UDim2.new(0, ScalePixels(185), 0, ScalePixels(95))
dslabel.BackgroundTransparency = 1
dslabel.TextXAlignment = Enum.TextXAlignment.Left
dslabel.ZIndex = 2
ApplyShineEffect(dslabel, false)

categoryFrame = Instance.new("ScrollingFrame", frame)
categoryFrame.Size = UDim2.new(0, ScalePixels(150), 1, ScalePixels(-155))
categoryFrame.Position = UDim2.new(0, ScalePixels(18), 0, ScalePixels(125))
categoryFrame.BackgroundTransparency = 1
categoryFrame.ScrollBarThickness = 0
categoryFrame.AutomaticCanvasSize = Enum.AutomaticSize.Y
categoryFrame.CanvasSize = UDim2.new(0, 0, 0, 0)
categoryFrame.ZIndex = 2
contentFrame = Instance.new("ScrollingFrame", frame)
contentFrame.Size = UDim2.new(1, ScalePixels(-200), 1, ScalePixels(-155))
contentFrame.Position = UDim2.new(0, ScalePixels(185), 0, ScalePixels(125))
contentFrame.BackgroundTransparency = 1
contentFrame.ScrollBarThickness = ScalePixels(2)
contentFrame.ScrollBarImageColor3 = Color3.fromRGB(180, 180, 180)
contentFrame.AutomaticCanvasSize = Enum.AutomaticSize.Y
contentFrame.CanvasSize = UDim2.new(0, 0, 0, 0)
contentFrame.ZIndex = 2
Instance.new("UIListLayout", categoryFrame).Padding = UDim.new(0, ScalePixels(8))
UIGridLayout = Instance.new("UIGridLayout", contentFrame)
UIGridLayout.CellPadding = UDim2.new(0, ScalePixels(13), 0, ScalePixels(11))
UIGridLayout.CellSize = UDim2.new(0.5, ScalePixels(-7), 0, ScalePixels(44))

activeTab = "TrangChu"
TabOrder = {"TrangChu","DiChuyen","HienThi","NguoiChoi","CongCu","NhanVat","DichThuat","MayChu","GiaiTri","Support"}

CreateScriptButton = function(data)
    local btnFrame = Instance.new("Frame")
    btnFrame.BackgroundColor3 = Color3.fromRGB(18, 18, 18)
    btnFrame.BackgroundTransparency = 0.55
    btnFrame.Size = UDim2.new(0.5, ScalePixels(-7), 0, ScalePixels(44))
    btnFrame.ZIndex = 3
    Instance.new("UICorner", btnFrame).CornerRadius = UDim.new(0, ScalePixels(10))
    local bStroke = Instance.new("UIStroke", btnFrame)
    bStroke.Color = Color3.fromRGB(45, 45, 45)
    bStroke.Thickness = ScalePixels(1.3)
    local btn = Instance.new("TextButton", btnFrame)
    btn.Size = UDim2.new(1, ScalePixels(-53), 1, 0)
    btn.Position = UDim2.new(0, ScalePixels(14), 0, 0)
    btn.BackgroundTransparency = 1
    btn.Text = Text(data.Name)
    btn.Font = Enum.Font.GothamBold
    btn.TextSize = ScalePixels(14)
    btn.TextColor3 = Color3.fromRGB(235, 235, 235)
    btn.TextXAlignment = Enum.TextXAlignment.Left
    btn.ZIndex = 4
    ApplyShineEffect(btn, false)
    if data.Type == "Toggle" then
        local state = TogglesState[data.Name] or false
        local swBg = Instance.new("Frame", btnFrame)
        swBg.Size = UDim2.new(0, ScalePixels(35), 0, ScalePixels(19))
        swBg.Position = UDim2.new(1, ScalePixels(-43), 0.5, ScalePixels(-9))
        swBg.BackgroundColor3 = state and Color3.fromRGB(255,255,255) or Color3.fromRGB(35,35,35)
        swBg.BackgroundTransparency = 0.3
        swBg.ZIndex = 4
        Instance.new("UICorner", swBg).CornerRadius = UDim.new(0, ScalePixels(5))
        local swBall = Instance.new("Frame", swBg)
        swBall.Size = UDim2.new(0, ScalePixels(15), 0, ScalePixels(15))
        swBall.Position = state and UDim2.new(1, ScalePixels(-17), 0.5, ScalePixels(-7)) or UDim2.new(0, ScalePixels(3), 0.5, ScalePixels(-7))
        swBall.BackgroundColor3 = state and Color3.fromRGB(15,15,15) or Color3.fromRGB(150,150,150)
        swBall.ZIndex = 5
        Instance.new("UICorner", swBall).CornerRadius = UDim.new(0, ScalePixels(4))
        btn.Size = UDim2.new(1, ScalePixels(-53), 1, 0)
        btn.MouseButton1Up:Connect(function()
            local ns = not TogglesState[data.Name]
            TogglesState[data.Name] = ns
            pcall(data.Callback, ns)
            TweenService:Create(swBg, TweenInfo.new(0.18), {
                BackgroundColor3 = ns and Color3.fromRGB(255,255,255) or Color3.fromRGB(35,35,35),
                BackgroundTransparency = 0.3
            }):Play()
            TweenService:Create(swBall, TweenInfo.new(0.18, Enum.EasingStyle.Back), {
                Position = ns and UDim2.new(1, ScalePixels(-17), 0.5, ScalePixels(-7)) or UDim2.new(0, ScalePixels(3), 0.5, ScalePixels(-7)),
                BackgroundColor3 = ns and Color3.fromRGB(15,15,15) or Color3.fromRGB(150,150,150)
            }):Play()
        end)
    else
        btn.Size = UDim2.new(1, 0, 1, 0)
        btn.MouseButton1Up:Connect(function() pcall(data.Callback) end)
    end
    return btnFrame
end

RefreshUI = function()
    title.Text = Text("Title")
    subTitle.Text = Text("SubTitle")
    searchBox.PlaceholderText = Text("Search")
    mclabel.Text = Text("MucLuc")
    dslabel.Text = Text("DanhSach")
    for _, child in ipairs(categoryFrame:GetChildren()) do if child:IsA("Frame") then child:Destroy() end end
    for _, child in ipairs(contentFrame:GetChildren()) do if child:IsA("Frame") then child:Destroy() end end
    for _, tabKey in ipairs(TabOrder) do
        local isSelected = (tabKey == activeTab)
        local tabContainer = Instance.new("Frame", categoryFrame)
        tabContainer.Size = UDim2.new(1, ScalePixels(-8), 0, ScalePixels(38))
        tabContainer.BackgroundColor3 = isSelected and Color3.fromRGB(255,255,255) or Color3.fromRGB(14,14,14)
        tabContainer.BackgroundTransparency = isSelected and 0.15 or 0.75
        tabContainer.ZIndex = 3
        Instance.new("UICorner", tabContainer).CornerRadius = UDim.new(0, ScalePixels(8))
        local tBtn = Instance.new("TextButton", tabContainer)
        tBtn.Size = UDim2.new(1, 0, 1, 0)
        tBtn.BackgroundTransparency = 1
        tBtn.Text = Text(tabKey)
        tBtn.Font = Enum.Font.GothamBold
        tBtn.TextSize = ScalePixels(14)
        tBtn.TextColor3 = isSelected and Color3.fromRGB(15,15,15) or Color3.fromRGB(180,180,180)
        tBtn.ZIndex = 4
        ApplyShineEffect(tBtn, false)
        tBtn.MouseButton1Click:Connect(function()
            activeTab = tabKey
            if searchBox.Text ~= "" then searchBox.Text = ""
            else RefreshUI() end
        end)
    end
    local scripts = ScriptData[activeTab] or {}
    for _, data in ipairs(scripts) do
        local btnFrame = CreateScriptButton(data)
        btnFrame.Parent = contentFrame
    end
    UpdateMiniTexts()
end

searchBox:GetPropertyChangedSignal("Text"):Connect(function()
    local query = string.gsub(searchBox.Text, "^%s*(.-)%s*$", "%1"):lower()
    if query == "" then RefreshUI() return end
    for _, child in ipairs(contentFrame:GetChildren()) do if child:IsA("Frame") then child:Destroy() end end
    local found = {}
    for tabKey, scripts in pairs(ScriptData) do
        for _, data in ipairs(scripts) do
            local name = Text(data.Name):lower()
            local tabName = Text(tabKey):lower()
            if string.find(name, query, 1, true) or string.find(tabName, query, 1, true) then
                table.insert(found, data)
            end
        end
    end
    for _, data in ipairs(found) do
        local btnFrame = CreateScriptButton(data)
        btnFrame.Parent = contentFrame
    end
end)

RefreshUI()

currentDragPosition = frame.Position
isAnimating = false

function show()
    if isAnimating then return end
    isAnimating = true
    frame.Size = UDim2.new(0, ScalePixels(20), 0, ScalePixels(20))
    frame.Position = currentDragPosition + UDim2.new(0, ScalePixels(350), 0, ScalePixels(215))
    frame.BackgroundTransparency = 1
    bgImage.ImageTransparency = 1
    activeTab = "TrangChu"
    RefreshUI()
    frame.Visible = true
    TweenService:Create(frame, TweenInfo.new(0.38, Enum.EasingStyle.Back, Enum.EasingDirection.Out), {
        Size = UDim2.new(0, ScalePixels(700), 0, ScalePixels(430)),
        Position = currentDragPosition
    }):Play()
    TweenService:Create(frame, TweenInfo.new(0.25), { BackgroundTransparency = 0.35 }):Play()
    TweenService:Create(bgImage, TweenInfo.new(0.35), { ImageTransparency = 0.15 }):Play()
    task.wait(0.38)
    isAnimating = false
end

function hide()
    if isAnimating then return end
    isAnimating = true
    currentDragPosition = frame.Position
    local closeTween = TweenService:Create(frame, TweenInfo.new(0.22, Enum.EasingStyle.Quad, Enum.EasingDirection.In), {
        Size = UDim2.new(0, 0, 0, 0),
        Position = currentDragPosition + UDim2.new(0, ScalePixels(350), 0, ScalePixels(215)),
        BackgroundTransparency = 1
    })
    TweenService:Create(bgImage, TweenInfo.new(0.22), { ImageTransparency = 1 }):Play()
    closeTween:Play()
    closeTween.Completed:Connect(function()
        frame.Visible = false
        isAnimating = false
    end)
end

toggleDragging = false
toggleDragStart, toggleStartPos = nil, nil
totalMoved = 0

toggle.InputBegan:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
        toggleDragging = true
        toggleDragStart = input.Position
        toggleStartPos = toggle.Position
        totalMoved = 0
        input.Changed:Connect(function()
            if input.UserInputState == Enum.UserInputState.End then
                toggleDragging = false
                if totalMoved < 8 then
                    if frame.Visible then hide() else show() end
                end
            end
        end)
    end
end)

UserInputService.InputChanged:Connect(function(input)
    if toggleDragging and (input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch) then
        local delta = input.Position - toggleDragStart
        totalMoved = delta.Magnitude
        toggle.Position = UDim2.new(toggleStartPos.X.Scale, toggleStartPos.X.Offset + delta.X, toggleStartPos.Y.Scale, toggleStartPos.Y.Offset + delta.Y)
    end
end)

MakeDraggable(frame, header)

task.spawn(function()
    local intro = Instance.new("Frame", gui)
    intro.Size = UDim2.new(1, 0, 1, 0)
    intro.BackgroundColor3 = Color3.fromRGB(0, 0, 0)
    intro.ZIndex = 999
    local introText = Instance.new("TextLabel", intro)
    introText.Size = UDim2.new(1, 0, 0, ScalePixels(90))
    introText.Position = UDim2.new(0, 0, 0.45, ScalePixels(-45))
    introText.BackgroundTransparency = 1
    introText.Text = "OKAY HUB"
    introText.Font = Enum.Font.BuilderSansBold
    introText.TextSize = ScalePixels(70)
    introText.TextColor3 = Color3.fromRGB(255, 255, 255)
    introText.ZIndex = 1000
    ApplyShineEffect(introText, false)
    local subIntro = Instance.new("TextLabel", intro)
    subIntro.Size = UDim2.new(1, 0, 0, ScalePixels(40))
    subIntro.Position = UDim2.new(0, 0, 0.55, 0)
    subIntro.BackgroundTransparency = 1
    subIntro.Text = "Made by BAO ✦ | V3.6 | " .. (CurrentLanguage == "vn" and "Nhấn nút để mở" or "Click button to open")
    subIntro.Font = Enum.Font.GothamBold
    subIntro.TextSize = ScalePixels(16)
    subIntro.TextColor3 = Color3.fromRGB(150, 150, 150)
    subIntro.ZIndex = 1000
    task.wait(1.5)
    local tw = TweenService:Create(intro, TweenInfo.new(0.8), { BackgroundTransparency = 1 })
    TweenService:Create(introText, TweenInfo.new(0.8), { TextTransparency = 1 }):Play()
    TweenService:Create(subIntro, TweenInfo.new(0.8), { TextTransparency = 1 }):Play()
    tw:Play()
    tw.Completed:Connect(function()
        intro:Destroy()
        toggle.Visible = true
        show()
    end)
end)

print("okay hub loaded")