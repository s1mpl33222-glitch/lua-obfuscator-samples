local Players           = game:GetService("Players")
local RunService        = game:GetService("RunService")
local UserInputService  = game:GetService("UserInputService")
local GuiService        = game:GetService("GuiService")
local Lighting          = game:GetService("Lighting")
local Workspace         = game:GetService("Workspace")
local TeleportService   = game:GetService("TeleportService")
local VirtualUser       = game:GetService("VirtualUser")
local StarterGui        = game:GetService("StarterGui")
local ReplicatedStorage = game:GetService("ReplicatedStorage")

local Heartbeat     = RunService.Heartbeat
local RenderStepped = RunService.RenderStepped
local Stepped       = RunService.Stepped

local LocalPlayer = Players.LocalPlayer
local playerGui   = LocalPlayer:WaitForChild("PlayerGui")

local PLATFORM = "PC"
if UserInputService.TouchEnabled and not UserInputService.KeyboardEnabled then
    PLATFORM = "MOBILE"
elseif UserInputService.GamepadEnabled and not UserInputService.KeyboardEnabled then
    PLATFORM = "CONSOLE"
elseif UserInputService.VREnabled then
    PLATFORM = "VR"
end
local IS_MOBILE  = PLATFORM == "MOBILE"
local IS_CONSOLE = PLATFORM == "CONSOLE"
local IS_VR      = PLATFORM == "VR"
local HAS_MOUSE  = not IS_MOBILE and not IS_CONSOLE

print("[NEXUS HUB] Platform: " .. PLATFORM)

local Rayfield
do
    local urls = {
        "https://sirius.menu/rayfield",
        "https://raw.githubusercontent.com/SiriusSoftwareLtd/Rayfield/main/source.lua",
    }
    local lastErr
    for _, url in ipairs(urls) do
        local ok, result = pcall(function()
            return loadstring(game:HttpGet(url, true))()
        end)
        if ok and result then Rayfield = result break end
        lastErr = result
    end
    if not Rayfield then
        warn("[NEXUS HUB] Rayfield load failed: " .. tostring(lastErr))
        return
    end
end

local function newBag()
    local bag = {conns = {}, insts = {}, threads = {}, destroyed = false}
    function bag:conn(c) if c then table.insert(self.conns, c) end return c end
    function bag:inst(i) if i then table.insert(self.insts, i) end return i end
    function bag:thread(t) if t then table.insert(self.threads, t) end return t end
    function bag:destroy()
        if self.destroyed then return end
        self.destroyed = true
        for _, c in ipairs(self.conns) do pcall(function() c:Disconnect() end) end
        for _, t in ipairs(self.threads) do pcall(function() task.cancel(t) end) end
        for _, i in ipairs(self.insts) do pcall(function() i:Destroy() end) end
        table.clear(self.conns); table.clear(self.insts); table.clear(self.threads)
    end
    return bag
end

local charState = {char = nil, hum = nil, root = nil}
local function resetCharCache() charState.char, charState.hum, charState.root = nil, nil, nil end

local function getChar()
    if charState.char and charState.char.Parent then return charState.char end
    charState.char = LocalPlayer.Character
    charState.hum, charState.root = nil, nil
    return charState.char
end

local function getHumanoid()
    local c = getChar()
    if not c then return nil end
    if charState.hum and charState.hum.Parent then return charState.hum end
    charState.hum = c:FindFirstChildOfClass("Humanoid")
    return charState.hum
end

local function getRoot()
    local c = getChar()
    if not c then return nil end
    if charState.root and charState.root.Parent then return charState.root end
    charState.root = c:FindFirstChild("HumanoidRootPart")
    return charState.root
end

local function getCamera() return Workspace.CurrentCamera end

local function notify(title, content, duration)
    pcall(function()
        Rayfield:Notify({Title = title, Content = content, Duration = duration or 3, Image = 4483362458})
    end)
end

local Window = Rayfield:CreateWindow({
    Name = "NEXUS HUB",
    Icon = 0,
    LoadingTitle = "NEXUS HUB",
    LoadingSubtitle = "by AZERTY/DEV and WhiteDevv",
    ShowText = "Rayfield",
    Theme = "Default",
    ToggleUIKeybind = "K",
    DisableRayfieldPrompts = false,
    DisableBuildWarnings = false,
    ConfigurationSaving = {Enabled = true, FolderName = "NexusHub", FileName = "NEXUS HUB"},
    Discord = {Enabled = true, Invite = "bE7C3aJJ7r", RememberJoins = true},
    KeySystem = false,
})

local GlobalBag = newBag()
local CharAddedHandlers, CharRemovingHandlers = {}, {}
local function registerCharAdded(fn) table.insert(CharAddedHandlers, fn) end
local function registerCharRemoving(fn) table.insert(CharRemovingHandlers, fn) end

GlobalBag:conn(LocalPlayer.CharacterAdded:Connect(function(c)
    charState.char = c
    charState.hum, charState.root = nil, nil
    task.wait(0.1)
    local h = c:FindFirstChildOfClass("Humanoid")
    if h then
        h.PlatformStand = false
        pcall(function() h:ChangeState(Enum.HumanoidStateType.GettingUp) end)
    end
    for _, fn in ipairs(CharAddedHandlers) do task.spawn(function() pcall(fn, c) end) end
end))

GlobalBag:conn(LocalPlayer.CharacterRemoving:Connect(function()
    for _, fn in ipairs(CharRemovingHandlers) do task.spawn(function() pcall(fn) end) end
    resetCharCache()
end))

local PlayerTab = Window:CreateTab("Player", 4483362458)

do
    PlayerTab:CreateSection("WalkSpeed")
    local MoveState = {
        WalkEnabled = false, WalkValue = 16, WalkDefault = 16,
        JumpEnabled = false, JumpValue = 50, JumpDefault = 50,
        JumpUsePower = true, JumpHeightDefault = 7.2, DefaultsCaptured = false,
    }
    local function captureDefaults()
        if MoveState.DefaultsCaptured then return end
        local h = getHumanoid()
        if not h then return end
        MoveState.WalkDefault = h.WalkSpeed
        MoveState.JumpUsePower = h.UseJumpPower
        if h.UseJumpPower then MoveState.JumpDefault = h.JumpPower
        else MoveState.JumpHeightDefault = h.JumpHeight end
        MoveState.DefaultsCaptured = true
    end
    GlobalBag:thread(task.spawn(function()
        for _ = 1, 40 do
            if getHumanoid() then
                captureDefaults()
                if MoveState.DefaultsCaptured then return end
            end
            task.wait(0.1)
        end
    end))

    PlayerTab:CreateToggle({
        Name = "Enable Speed", CurrentValue = false, Flag = "Enable Speed",
        Callback = function(v)
            MoveState.WalkEnabled = v
            local h = getHumanoid()
            if h then h.WalkSpeed = v and MoveState.WalkValue or MoveState.WalkDefault end
            notify(v and "Speed Enabled" or "Speed Disabled",
                v and ("Speed set to " .. MoveState.WalkValue) or ("Reset to " .. MoveState.WalkDefault), 2)
        end,
    })
    PlayerTab:CreateSlider({
        Name = "Player Speed", Range = {16, 500}, Increment = 1, Suffix = "Speed",
        CurrentValue = 16, Flag = "Speed Slider",
        Callback = function(v)
            MoveState.WalkValue = v
            if MoveState.WalkEnabled then
                local h = getHumanoid()
                if h then h.WalkSpeed = v end
            end
        end,
    })
    PlayerTab:CreateSection("Jump")
    PlayerTab:CreateToggle({
        Name = "Enable Jump Height", CurrentValue = false, Flag = "Enable Jump Height",
        Callback = function(v)
            MoveState.JumpEnabled = v
            local h = getHumanoid()
            if h then
                if v then
                    h.UseJumpPower = true
                    h.JumpPower = MoveState.JumpValue
                else
                    h.UseJumpPower = MoveState.JumpUsePower
                    if MoveState.JumpUsePower then h.JumpPower = MoveState.JumpDefault
                    else h.JumpHeight = MoveState.JumpHeightDefault end
                end
            end
            notify(v and "Jump Height Enabled" or "Jump Height Disabled",
                v and ("Jump set to " .. MoveState.JumpValue) or ("Reset to " .. MoveState.JumpDefault), 2)
        end,
    })
    PlayerTab:CreateSlider({
        Name = "Jump Height", Range = {50, 300}, Increment = 1, Suffix = "Jump",
        CurrentValue = 50, Flag = "Jump Height Slider",
        Callback = function(v)
            MoveState.JumpValue = v
            if MoveState.JumpEnabled then
                local h = getHumanoid()
                if h then h.UseJumpPower = true; h.JumpPower = v end
            end
        end,
    })
    registerCharAdded(function()
        captureDefaults()
        local h = getHumanoid()
        if not h then return end
        if MoveState.WalkEnabled then h.WalkSpeed = MoveState.WalkValue end
        if MoveState.JumpEnabled then h.UseJumpPower = true; h.JumpPower = MoveState.JumpValue end
    end)

    PlayerTab:CreateSection("Fly Speed")
    local FlyState = {Speed = 50}
    PlayerTab:CreateSlider({
        Name = "Fly Speed", Range = {1, 5000}, Increment = 1, Suffix = "Speed",
        CurrentValue = 50, Flag = "FlySpeed",
        Callback = function(v) FlyState.Speed = math.clamp(v, 1, 5000) end,
    })

    PlayerTab:CreateSection("FPS Boost & Counter")
    local FpsTool = {
        gui = nil, label = nil, conn = nil, frames = 0, accum = 0, current = 0,
        enabled = false, pos = UDim2.new(0, 10, 0, 10), size = 18,
        showAvg = true, history = {}, historyMax = 60,
    }
    local function fpsEnsureGui()
        if FpsTool.gui and FpsTool.gui.Parent then return end
        local old = playerGui:FindFirstChild("NexusFpsGui")
        if old then old:Destroy() end
        local gui = Instance.new("ScreenGui")
        gui.Name = "NexusFpsGui"; gui.ResetOnSpawn = false
        gui.IgnoreGuiInset = true; gui.DisplayOrder = 9998
        gui.Parent = playerGui; FpsTool.gui = gui
        local lbl = Instance.new("TextLabel")
        lbl.Name = "FpsLabel"; lbl.BackgroundTransparency = 1
        lbl.Size = UDim2.new(0, 320, 0, 40); lbl.Position = FpsTool.pos
        lbl.Font = Enum.Font.Code; lbl.TextSize = FpsTool.size
        lbl.TextXAlignment = Enum.TextXAlignment.Left
        lbl.TextYAlignment = Enum.TextYAlignment.Top
        lbl.TextStrokeTransparency = 0.3; lbl.TextStrokeColor3 = Color3.new(0, 0, 0)
        lbl.Text = "FPS: --"; lbl.Visible = false; lbl.Parent = gui
        FpsTool.label = lbl
    end
    local function fpsUpdate()
        if not FpsTool.label then return end
        FpsTool.label.Position = FpsTool.pos
        FpsTool.label.TextSize = FpsTool.size
        local color
        if FpsTool.current >= 60 then color = Color3.fromRGB(0, 255, 120)
        elseif FpsTool.current >= 30 then color = Color3.fromRGB(255, 200, 0)
        else color = Color3.fromRGB(255, 60, 60) end
        FpsTool.label.TextColor3 = color
        local sum, n = 0, #FpsTool.history
        for _, v in ipairs(FpsTool.history) do sum += v end
        local avg = n > 0 and sum / n or 0
        local mn = n > 0 and FpsTool.history[1] or FpsTool.current
        for _, v in ipairs(FpsTool.history) do if v < mn then mn = v end end
        if FpsTool.showAvg then
            FpsTool.label.Text = string.format("FPS: %d | Avg: %d | Min: %d",
                math.floor(FpsTool.current + 0.5), math.floor(avg + 0.5), math.floor(mn + 0.5))
        else
            FpsTool.label.Text = string.format("FPS: %d", math.floor(FpsTool.current + 0.5))
        end
    end
    local function fpsStart()
        if FpsTool.conn then return end
        fpsEnsureGui()
        if FpsTool.label then FpsTool.label.Visible = true end
        FpsTool.frames, FpsTool.accum, FpsTool.history = 0, 0, {}
        FpsTool.conn = RenderStepped:Connect(function(dt)
            FpsTool.frames += 1
            FpsTool.accum += dt
            if FpsTool.accum >= 0.5 then
                FpsTool.current = FpsTool.frames / FpsTool.accum
                table.insert(FpsTool.history, FpsTool.current)
                if #FpsTool.history > FpsTool.historyMax then table.remove(FpsTool.history, 1) end
                FpsTool.frames, FpsTool.accum = 0, 0
                fpsUpdate()
            end
        end)
    end
    local function fpsStop()
        if FpsTool.conn then FpsTool.conn:Disconnect(); FpsTool.conn = nil end
        if FpsTool.label then FpsTool.label.Visible = false end
    end
    PlayerTab:CreateToggle({
        Name = "Show FPS Counter", CurrentValue = false, Flag = "FpsCounter",
        Callback = function(v)
            FpsTool.enabled = v
            if v then fpsStart() else fpsStop() end
        end,
    })
    PlayerTab:CreateToggle({
        Name = "Show Average / Min FPS", CurrentValue = true, Flag = "FpsAvg",
        Callback = function(v) FpsTool.showAvg = v; fpsUpdate() end,
    })
    PlayerTab:CreateSlider({
        Name = "FPS Counter Text Size", Range = {10, 40}, Increment = 1, Suffix = "px",
        CurrentValue = 18, Flag = "FpsSize",
        Callback = function(v) FpsTool.size = v; fpsUpdate() end,
    })
    PlayerTab:CreateSlider({
        Name = "FPS Counter X Position", Range = {0, 1920}, Increment = 5, Suffix = "px",
        CurrentValue = 10, Flag = "FpsX",
        Callback = function(v)
            FpsTool.pos = UDim2.new(0, v, 0, FpsTool.pos.Y.Offset)
            fpsUpdate()
        end,
    })
    PlayerTab:CreateSlider({
        Name = "FPS Counter Y Position", Range = {0, 1080}, Increment = 5, Suffix = "px",
        CurrentValue = 10, Flag = "FpsY",
        Callback = function(v)
            FpsTool.pos = UDim2.new(0, FpsTool.pos.X.Offset, 0, v)
            fpsUpdate()
        end,
    })

    local FpsBoost = {active = false, conn = nil, original = {}}
    local function fpsBoostApply()
        if FpsBoost.active then return end
        FpsBoost.active = true
        local orig = FpsBoost.original
        orig.GlobalShadows = Lighting.GlobalShadows
        Lighting.GlobalShadows = false
        orig.PostEffects = {}
        for _, fx in ipairs(Lighting:GetChildren()) do
            if fx:IsA("PostEffect") then
                orig.PostEffects[fx] = fx.Enabled
                fx.Enabled = false
            end
        end
        pcall(function()
            orig.QualityLevel = settings().Rendering.QualityLevel
            settings().Rendering.QualityLevel = Enum.QualityLevel.Level01
        end)
        orig.FogEnd = Lighting.FogEnd
        orig.FogStart = Lighting.FogStart
        Lighting.FogEnd = 100000
        Lighting.FogStart = 100000
        FpsBoost.conn = Heartbeat:Connect(function()
            if not FpsBoost.active then return end
            if Lighting.GlobalShadows then Lighting.GlobalShadows = false end
            for _, fx in ipairs(Lighting:GetChildren()) do
                if fx:IsA("PostEffect") and fx.Enabled then fx.Enabled = false end
            end
        end)
    end
    local function fpsBoostRemove()
        if not FpsBoost.active then return end
        FpsBoost.active = false
        if FpsBoost.conn then FpsBoost.conn:Disconnect(); FpsBoost.conn = nil end
        local orig = FpsBoost.original
        if orig.GlobalShadows ~= nil then Lighting.GlobalShadows = orig.GlobalShadows end
        if orig.PostEffects then
            for fx, enabled in pairs(orig.PostEffects) do
                if fx and fx.Parent then fx.Enabled = enabled end
            end
        end
        pcall(function()
            if orig.QualityLevel then settings().Rendering.QualityLevel = orig.QualityLevel end
        end)
        if orig.FogEnd then Lighting.FogEnd = orig.FogEnd end
        if orig.FogStart then Lighting.FogStart = orig.FogStart end
        FpsBoost.original = {}
    end
    PlayerTab:CreateToggle({
        Name = "FPS Boost (Max Performance)", CurrentValue = false, Flag = "FpsBoost",
        Callback = function(v)
            if v then fpsBoostApply(); notify("FPS Boost", "Max performance enabled", 2)
            else fpsBoostRemove(); notify("FPS Boost", "Settings restored", 2) end
        end,
    })
    local particleStore = setmetatable({}, {__mode = "k"})
    local particleConn = nil
    PlayerTab:CreateToggle({
        Name = "FPS Boost - Disable Particles", CurrentValue = false, Flag = "FpsBoostParticles",
        Callback = function(v)
            if v then
                local function disable(obj)
                    if not particleStore[obj] then
                        particleStore[obj] = obj.Enabled
                        obj.Enabled = false
                    end
                end
                for _, obj in ipairs(Workspace:GetDescendants()) do
                    if obj:IsA("ParticleEmitter") or obj:IsA("Trail") or obj:IsA("Smoke")
                        or obj:IsA("Fire") or obj:IsA("Sparkles") or obj:IsA("Beam") then disable(obj) end
                end
                particleConn = Workspace.DescendantAdded:Connect(function(obj)
                    if obj:IsA("ParticleEmitter") or obj:IsA("Trail") or obj:IsA("Smoke")
                        or obj:IsA("Fire") or obj:IsA("Sparkles") or obj:IsA("Beam") then disable(obj) end
                end)
            else
                if particleConn then particleConn:Disconnect(); particleConn = nil end
                for obj, enabled in pairs(particleStore) do
                    if obj and obj.Parent then pcall(function() obj.Enabled = enabled end) end
                end
                particleStore = setmetatable({}, {__mode = "k"})
            end
        end,
    })
    registerCharRemoving(function() if FpsBoost.active then fpsBoostRemove() end end)
end

local MoveTab = Window:CreateTab("Movement", 4483362458)

do
    MoveTab:CreateSection("Fly")
    local Fly = {Enabled = false, Speed = 50, Conn = nil, BV = nil, BG = nil, ToggleRef = nil}
    local function flyStart()
        if Fly.Enabled then return end
        local char = getChar()
        if not char then return end
        local root = char:FindFirstChild("HumanoidRootPart")
        if not root then return end
        Fly.Enabled = true
        local hum = char:FindFirstChildOfClass("Humanoid")
        if hum then
            if not IS_VR then hum.PlatformStand = true end
            pcall(function() hum:ChangeState(Enum.HumanoidStateType.Freefall) end)
        end
        Fly.BV = Instance.new("BodyVelocity")
        Fly.BV.MaxForce = Vector3.new(9e9, 9e9, 9e9)
        Fly.BV.Velocity = Vector3.zero
        Fly.BV.P = 1250
        Fly.BV.Parent = root
        Fly.BG = Instance.new("BodyGyro")
        Fly.BG.MaxTorque = Vector3.new(9e9, 9e9, 9e9)
        Fly.BG.P = 10000; Fly.BG.D = 500
        Fly.BG.CFrame = root.CFrame
        Fly.BG.Parent = root
        Fly.Conn = RenderStepped:Connect(function()
            if not Fly.Enabled then return end
            local cam = getCamera()
            local bv, bg = Fly.BV, Fly.BG
            if not cam or not bv or not bv.Parent or not bg or not bg.Parent then return end
            local speed = Fly.Speed
            if not IS_MOBILE and UserInputService:IsKeyDown(Enum.KeyCode.LeftControl) then speed *= 2 end
            local cf = cam.CFrame
            local mv = Vector3.zero
            if UserInputService:IsKeyDown(Enum.KeyCode.W) then mv += cf.LookVector end
            if UserInputService:IsKeyDown(Enum.KeyCode.S) then mv -= cf.LookVector end
            if UserInputService:IsKeyDown(Enum.KeyCode.D) then mv += cf.RightVector end
            if UserInputService:IsKeyDown(Enum.KeyCode.A) then mv -= cf.RightVector end
            if UserInputService:IsKeyDown(Enum.KeyCode.Space) then mv += Vector3.yAxis end
            if not IS_MOBILE and UserInputService:IsKeyDown(Enum.KeyCode.LeftShift) then mv -= Vector3.yAxis end
            bv.Velocity = mv.Magnitude > 0 and mv.Unit * speed or Vector3.zero
            bg.CFrame = CFrame.new(root.Position) * (cf - cf.Position)
        end)
    end
    local function flyStop()
        if not Fly.Enabled then return end
        Fly.Enabled = false
        if Fly.Conn then Fly.Conn:Disconnect(); Fly.Conn = nil end
        if Fly.BV then Fly.BV:Destroy(); Fly.BV = nil end
        if Fly.BG then Fly.BG:Destroy(); Fly.BG = nil end
        local char = getChar()
        if char then
            local hum = char:FindFirstChildOfClass("Humanoid")
            if hum then
                hum.PlatformStand = false
                pcall(function() hum:ChangeState(Enum.HumanoidStateType.GettingUp) end)
            end
        end
    end
    local function flyToggle()
        if Fly.Enabled then flyStop() else flyStart() end
        if Fly.ToggleRef then pcall(function() Fly.ToggleRef:Set(Fly.Enabled) end) end
    end
    registerCharRemoving(flyStop)
    registerCharAdded(function()
        if Fly.Enabled then task.wait(0.3); flyStart() end
    end)
    if not IS_MOBILE then
        GlobalBag:conn(UserInputService.InputBegan:Connect(function(input, gp)
            if gp then return end
            if input.KeyCode == Enum.KeyCode.E then flyToggle() end
        end))
    end
    Fly.ToggleRef = MoveTab:CreateToggle({
        Name = IS_MOBILE and "Fly" or "Fly (Key E)",
        CurrentValue = false, Flag = "Fly",
        Callback = function(v)
            if v and not Fly.Enabled then flyStart()
            elseif not v and Fly.Enabled then flyStop() end
        end,
    })

    MoveTab:CreateSection("Gravity")
    local DEFAULT_GRAVITY = Workspace.Gravity
    MoveTab:CreateSlider({
        Name = "Gravity", Range = {0, 500}, Increment = 1,
        Suffix = "Gravity", CurrentValue = DEFAULT_GRAVITY, Flag = "Gravity",
        Callback = function(v) Workspace.Gravity = v end,
    })
    MoveTab:CreateButton({
        Name = "Reset Gravity",
        Callback = function() Workspace.Gravity = DEFAULT_GRAVITY end,
    })

    MoveTab:CreateSection("Noclip")
    local Noclip = {Enabled = false, Conn = nil, Modified = setmetatable({}, {__mode = "k"}), ScanCounter = 0}
    local function noclipApply(part)
        if Noclip.Modified[part] then return end
        Noclip.Modified[part] = part.CanCollide
        part.CanCollide = false
    end
    local function noclipScan()
        local c = getChar()
        if not c then return end
        for _, p in ipairs(c:GetDescendants()) do
            if p:IsA("BasePart") and not Noclip.Modified[p] then
                local par = p.Parent
                if not (par and (par:IsA("Tool") or par:IsA("Accessory"))) then
                    noclipApply(p)
                end
            end
        end
    end
    local function noclipRestore()
        for part, orig in pairs(Noclip.Modified) do
            if part and part.Parent then pcall(function() part.CanCollide = orig end) end
        end
        Noclip.Modified = setmetatable({}, {__mode = "k"})
    end
    local function noclipStart()
        if Noclip.Conn then return end
        Noclip.Enabled = true
        noclipScan()
        Noclip.Conn = Heartbeat:Connect(function()
            Noclip.ScanCounter += 1
            if Noclip.ScanCounter % 4 ~= 0 then return end
            noclipScan()
        end)
    end
    local function noclipStop()
        Noclip.Enabled = false
        if Noclip.Conn then Noclip.Conn:Disconnect(); Noclip.Conn = nil end
        noclipRestore()
    end
    MoveTab:CreateToggle({
        Name = "Noclip", CurrentValue = false, Flag = "Noclip",
        Callback = function(v) if v then noclipStart() else noclipStop() end end,
    })
    registerCharRemoving(function()
        Noclip.Modified = setmetatable({}, {__mode = "k"})
    end)

    MoveTab:CreateSection("Infinite Jump")
    local InfJump = {Conn = nil, Enabled = false}
    local function infJumpStart()
        if InfJump.Conn then return end
        InfJump.Enabled = true
        local ok, conn = pcall(function()
            return UserInputService.JumpRequest:Connect(function()
                local h = getHumanoid()
                if h then h:ChangeState(Enum.HumanoidStateType.Jumping) end
            end)
        end)
        if ok and conn then InfJump.Conn = conn
        else
            InfJump.Conn = Heartbeat:Connect(function()
                local h = getHumanoid()
                if h and h:GetState() ~= Enum.HumanoidStateType.Jumping then
                    h:ChangeState(Enum.HumanoidStateType.Jumping)
                end
            end)
        end
    end
    local function infJumpStop()
        InfJump.Enabled = false
        if InfJump.Conn then InfJump.Conn:Disconnect(); InfJump.Conn = nil end
    end
    MoveTab:CreateToggle({
        Name = "Infinite Jump", CurrentValue = false, Flag = "InfJump",
        Callback = function(v) if v then infJumpStart() else infJumpStop() end end,
    })
    registerCharRemoving(infJumpStop)
end

local VisionTab = Window:CreateTab("Vision", 4483362458)

do
    VisionTab:CreateSection("ESP")
    local ESP = {
        Enabled = false, Color = Color3.fromRGB(220, 30, 40), Transparency = 0.3,
        Highlights = setmetatable({}, {__mode = "k"}),
        CharBags = {},
        PlayerAddedConn = nil, PlayerRemovingConn = nil,
    }
    local function espMakeHighlight(player)
        if not player.Character then return end
        local old = ESP.Highlights[player]
        if old and old.Parent then old:Destroy() end
        local hl = Instance.new("Highlight")
        hl.Name = "NexusESP"
        hl.Adornee = player.Character
        hl.DepthMode = Enum.HighlightDepthMode.AlwaysOnTop
        hl.FillColor = ESP.Color
        hl.OutlineColor = Color3.fromRGB(255, 0, 0)
        hl.FillTransparency = ESP.Transparency
        hl.OutlineTransparency = 0
        hl.Parent = player.Character
        ESP.Highlights[player] = hl
    end
    local function espRemoveHighlight(player)
        local hl = ESP.Highlights[player]
        if hl then pcall(function() hl:Destroy() end); ESP.Highlights[player] = nil end
    end
    local function espSetupPlayer(player)
        if player == LocalPlayer then return end
        espMakeHighlight(player)
        if ESP.CharBags[player] then ESP.CharBags[player]:destroy() end
        local b = newBag()
        ESP.CharBags[player] = b
        b:conn(player.CharacterAdded:Connect(function()
            task.wait(0.5)
            if ESP.Enabled then espMakeHighlight(player) end
        end))
    end
    local function espCleanupPlayer(player)
        espRemoveHighlight(player)
        if ESP.CharBags[player] then ESP.CharBags[player]:destroy(); ESP.CharBags[player] = nil end
    end
    local function espUpdateAppearance()
        for _, hl in pairs(ESP.Highlights) do
            if hl and hl.Parent then
                hl.FillColor = ESP.Color
                hl.OutlineColor = Color3.fromRGB(255, 0, 0)
                hl.FillTransparency = ESP.Transparency
            end
        end
    end
    local function espSetEnabled(v)
        ESP.Enabled = v
        if v then
            for _, p in ipairs(Players:GetPlayers()) do espSetupPlayer(p) end
            ESP.PlayerAddedConn = Players.PlayerAdded:Connect(espSetupPlayer)
            ESP.PlayerRemovingConn = Players.PlayerRemoving:Connect(espCleanupPlayer)
        else
            if ESP.PlayerAddedConn then ESP.PlayerAddedConn:Disconnect(); ESP.PlayerAddedConn = nil end
            if ESP.PlayerRemovingConn then ESP.PlayerRemovingConn:Disconnect(); ESP.PlayerRemovingConn = nil end
            for _, b in pairs(ESP.CharBags) do b:destroy() end
            ESP.CharBags = {}
            for _, hl in pairs(ESP.Highlights) do
                if hl then pcall(function() hl:Destroy() end) end
            end
            ESP.Highlights = setmetatable({}, {__mode = "k"})
        end
    end
    VisionTab:CreateToggle({
        Name = "Player ESP (Red Outline)", CurrentValue = false, Flag = "ESP",
        Callback = espSetEnabled,
    })
    VisionTab:CreateSlider({
        Name = "ESP Fill Transparency", Range = {0, 1}, Increment = 0.05, Suffix = "",
        CurrentValue = 0.3, Flag = "ESPTransparency",
        Callback = function(v) ESP.Transparency = v; espUpdateAppearance() end,
    })

    VisionTab:CreateSection("Fullbright")
    local Fullbright = {Enabled = false, Conn = nil, Original = nil}
    local function fullbrightStart()
        if Fullbright.Enabled then return end
        Fullbright.Enabled = true
        Fullbright.Original = {
            Ambient = Lighting.Ambient,
            OutdoorAmbient = Lighting.OutdoorAmbient,
            Brightness = Lighting.Brightness,
        }
        Lighting.Ambient = Color3.fromRGB(200, 200, 210)
        Lighting.OutdoorAmbient = Color3.fromRGB(200, 200, 210)
        Lighting.Brightness = 1.8
        Fullbright.Conn = Heartbeat:Connect(function()
            if not Fullbright.Enabled then return end
            if Lighting.Brightness < 1.8 then Lighting.Brightness = 1.8 end
        end)
    end
    local function fullbrightStop()
        if not Fullbright.Enabled then return end
        Fullbright.Enabled = false
        if Fullbright.Conn then Fullbright.Conn:Disconnect(); Fullbright.Conn = nil end
        if Fullbright.Original then
            Lighting.Ambient = Fullbright.Original.Ambient
            Lighting.OutdoorAmbient = Fullbright.Original.OutdoorAmbient
            Lighting.Brightness = Fullbright.Original.Brightness
        end
        Fullbright.Original = nil
    end
    VisionTab:CreateToggle({
        Name = "Fullbright", CurrentValue = false, Flag = "Fullbright",
        Callback = function(v) if v then fullbrightStart() else fullbrightStop() end end,
    })
    VisionTab:CreateSlider({
        Name = "Field of View", Range = {60, 110}, Increment = 1, Suffix = "FOV",
        CurrentValue = 90, Flag = "FOV",
        Callback = function(v)
            local cam = getCamera()
            if cam then cam.FieldOfView = math.clamp(v, 60, 110) end
        end,
    })

    VisionTab:CreateSection("X-Ray")
    local Xray = {
        Enabled = false, Conn = nil, Transparency = 0.7, IncludeLocal = false,
        Original = setmetatable({}, {__mode = "k"}),
    }
    local function xrayIsTarget(part)
        if not part or not part.Parent then return false end
        if not part:IsA("BasePart") then return false end
        local model = part:FindFirstAncestorOfClass("Model")
        if not model then return false end
        if not model:FindFirstChildOfClass("Humanoid") then return false end
        if not Xray.IncludeLocal and model == getChar() then return false end
        local p = part.Parent
        if p and (p:IsA("Accessory") or p:IsA("Tool")) then return false end
        return true
    end
    local function xrayApply(part)
        if Xray.Original[part] then return end
        Xray.Original[part] = {LocalTransparencyModifier = part.LocalTransparencyModifier}
        pcall(function() part.LocalTransparencyModifier = Xray.Transparency end)
    end
    local function xrayRestore(part)
        local orig = Xray.Original[part]
        if not orig then return end
        pcall(function() part.LocalTransparencyModifier = orig.LocalTransparencyModifier end)
        Xray.Original[part] = nil
    end
    local function xrayScan()
        for _, p in ipairs(Players:GetPlayers()) do
            local c = p.Character
            if c and c:FindFirstChildOfClass("Humanoid") then
                for _, part in ipairs(c:GetDescendants()) do
                    if xrayIsTarget(part) then
                        if Xray.Enabled then xrayApply(part) else xrayRestore(part) end
                    end
                end
            end
        end
    end
    local function xrayStart()
        if Xray.Conn then return end
        Xray.Enabled = true
        xrayScan()
        Xray.Conn = Heartbeat:Connect(xrayScan)
    end
    local function xrayStop()
        Xray.Enabled = false
        if Xray.Conn then Xray.Conn:Disconnect(); Xray.Conn = nil end
        for part in pairs(Xray.Original) do xrayRestore(part) end
        Xray.Original = setmetatable({}, {__mode = "k"})
    end
    VisionTab:CreateToggle({
        Name = "X-Ray (See Through Walls)", CurrentValue = false, Flag = "XRay",
        Callback = function(v)
            if v then xrayStart(); notify("X-Ray", "Players visible through walls", 2)
            else xrayStop(); notify("X-Ray", "Transparency restored", 2) end
        end,
    })
    VisionTab:CreateSlider({
        Name = "X-Ray Transparency", Range = {0.3, 1}, Increment = 0.05, Suffix = "",
        CurrentValue = 0.7, Flag = "XRayTransparency",
        Callback = function(v)
            Xray.Transparency = v
            if Xray.Enabled then
                for part in pairs(Xray.Original) do
                    if part and part.Parent then
                        pcall(function() part.LocalTransparencyModifier = v end)
                    end
                end
            end
        end,
    })
    VisionTab:CreateToggle({
        Name = "Include My Character", CurrentValue = false, Flag = "XRayIncludeLocal",
        Callback = function(v) Xray.IncludeLocal = v; if Xray.Enabled then xrayScan() end end,
    })
    registerCharRemoving(function() if Xray.Enabled then task.wait(0.1); xrayScan() end end)

    VisionTab:CreateSection("Ultra Realistic Graphics")
    local Realistic = {
        Enabled = false, Conn = nil, Original = nil, Created = {},
        State = {
            Bloom = true, ColorCorrection = true, DepthOfField = true,
            SunRays = true, Atmosphere = true, Clouds = true, Sky = true,
            Saturation = 0.15, Contrast = 0.12, Brightness = 0.05,
            BloomIntensity = 0.9, DOFFocus = 60, SunRaysIntensity = 0.12,
            ClockTime = 15.5, BrightnessValue = 2.1,
        },
    }
    local function realisticSaveOriginal()
        if Realistic.Original then return end
        local o = {
            Ambient = Lighting.Ambient, OutdoorAmbient = Lighting.OutdoorAmbient,
            Brightness = Lighting.Brightness, ClockTime = Lighting.ClockTime,
            GeographicLatitude = Lighting.GeographicLatitude,
            GlobalShadows = Lighting.GlobalShadows,
            EnvironmentDiffuseScale = Lighting.EnvironmentDiffuseScale,
            EnvironmentSpecularScale = Lighting.EnvironmentSpecularScale,
            FogStart = Lighting.FogStart, FogEnd = Lighting.FogEnd,
            FogColor = Lighting.FogColor,
            ExposureCompensation = Lighting.ExposureCompensation,
            Children = {},
        }
        for _, child in ipairs(Lighting:GetChildren()) do
            if child:IsA("PostEffect") or child:IsA("Atmosphere")
                or child:IsA("Sky") or child:IsA("Clouds") then
                o.Children[child] = {Enabled = child.Enabled, Parent = child.Parent}
            end
        end
        Realistic.Original = o
    end
    local function realisticDestroyCreated()
        for _, inst in ipairs(Realistic.Created) do
            if inst and inst.Parent then pcall(function() inst:Destroy() end) end
        end
        Realistic.Created = {}
    end
    local function realisticGetOrCreate(class, name)
        local existing = Lighting:FindFirstChild(name)
        if existing and existing.ClassName == class then return existing end
        local inst = Instance.new(class)
        inst.Name = name
        inst.Parent = Lighting
        table.insert(Realistic.Created, inst)
        return inst
    end
    local function realisticApply()
        local s = Realistic.State
        local cc = realisticGetOrCreate("ColorCorrectionEffect", "Nexus_ColorCorrection")
        cc.Enabled = s.ColorCorrection
        cc.Brightness = s.Brightness
        cc.Contrast = s.Contrast
        cc.Saturation = s.Saturation
        cc.TintColor = Color3.fromRGB(255, 250, 245)
        local bl = realisticGetOrCreate("BloomEffect", "Nexus_Bloom")
        bl.Enabled = s.Bloom
        bl.Intensity = s.BloomIntensity
        bl.Size = 24
        bl.Threshold = 1.2
        local dof = realisticGetOrCreate("DepthOfFieldEffect", "Nexus_DOF")
        dof.Enabled = s.DepthOfField
        dof.FocusDistance = s.DOFFocus
        dof.NearIntensity = 0.02
        dof.FarIntensity = 0.35
        dof.InFocusRadius = 30
        local sr = realisticGetOrCreate("SunRaysEffect", "Nexus_SunRays")
        sr.Enabled = s.SunRays
        sr.Intensity = s.SunRaysIntensity
        sr.Spread = 0.95
        local atmo = realisticGetOrCreate("Atmosphere", "Nexus_Atmosphere")
        atmo.Enabled = s.Atmosphere
        atmo.Density = 0.32; atmo.Offset = 0.15
        atmo.Color = Color3.fromRGB(200, 210, 225)
        atmo.Decay = Color3.fromRGB(110, 130, 160)
        atmo.Glare = 0.25; atmo.Haze = 1.4
        local sky = realisticGetOrCreate("Sky", "Nexus_Sky")
        sky.Enabled = s.Sky
        sky.SkyboxBk = "rbxassetid://159454299"
        sky.SkyboxDn = "rbxassetid://159454296"
        sky.SkyboxFt = "rbxassetid://159454293"
        sky.SkyboxLf = "rbxassetid://159454286"
        sky.SkyboxRt = "rbxassetid://159454300"
        sky.SkyboxUp = "rbxassetid://159454288"
        sky.StarCount = 3000
        sky.SunAngularSize = 21
        sky.MoonAngularSize = 11
        local clouds = Lighting:FindFirstChild("Nexus_Clouds")
        if not clouds then
            clouds = Instance.new("Clouds")
            clouds.Name = "Nexus_Clouds"
            clouds.Parent = Lighting
            table.insert(Realistic.Created, clouds)
        end
        clouds.Enabled = s.Clouds
        clouds.Cover = 0.6; clouds.Density = 0.7
        clouds.Color = Color3.fromRGB(255, 255, 255)
        Lighting.Ambient = Color3.fromRGB(70, 75, 85)
        Lighting.OutdoorAmbient = Color3.fromRGB(85, 95, 110)
        Lighting.Brightness = s.BrightnessValue
        Lighting.ClockTime = s.ClockTime
        Lighting.GeographicLatitude = 20
        Lighting.GlobalShadows = true
        Lighting.EnvironmentDiffuseScale = 0.6
        Lighting.EnvironmentSpecularScale = 0.7
        Lighting.FogStart = 80
        Lighting.FogEnd = 900
        Lighting.FogColor = Color3.fromRGB(180, 195, 210)
        pcall(function() Lighting.ExposureCompensation = 0.15 end)
    end
    local function realisticRestore()
        local o = Realistic.Original
        if not o then return end
        Lighting.Ambient = o.Ambient
        Lighting.OutdoorAmbient = o.OutdoorAmbient
        Lighting.Brightness = o.Brightness
        Lighting.ClockTime = o.ClockTime
        Lighting.GeographicLatitude = o.GeographicLatitude
        Lighting.GlobalShadows = o.GlobalShadows
        Lighting.EnvironmentDiffuseScale = o.EnvironmentDiffuseScale
        Lighting.EnvironmentSpecularScale = o.EnvironmentSpecularScale
        Lighting.FogStart = o.FogStart
        Lighting.FogEnd = o.FogEnd
        Lighting.FogColor = o.FogColor
        pcall(function() Lighting.ExposureCompensation = o.ExposureCompensation end)
        for child, data in pairs(o.Children) do
            if child and child.Parent == nil and data.Parent then
                pcall(function() child.Parent = data.Parent end)
            end
            if child and child.Parent then
                pcall(function() child.Enabled = data.Enabled end)
            end
        end
    end
    local function realisticStart()
        if Realistic.Enabled then return end
        Realistic.Enabled = true
        realisticSaveOriginal()
        realisticApply()
        Realistic.Conn = Heartbeat:Connect(function()
            if not Realistic.Enabled then return end
            if not Lighting.GlobalShadows then Lighting.GlobalShadows = true end
        end)
        notify("Ultra Realistic Graphics", "Enabled", 4)
    end
    local function realisticStop()
        if not Realistic.Enabled then return end
        Realistic.Enabled = false
        if Realistic.Conn then Realistic.Conn:Disconnect(); Realistic.Conn = nil end
        realisticDestroyCreated()
        realisticRestore()
        Realistic.Original = nil
        notify("Ultra Realistic Graphics", "Disabled", 3)
    end
    local function realisticRefresh()
        if not Realistic.Enabled then return end
        pcall(realisticApply)
    end
    VisionTab:CreateToggle({
        Name = "Ultra Realistic Graphics (Master)",
        CurrentValue = false, Flag = "RealisticMaster",
        Callback = function(v) if v then realisticStart() else realisticStop() end end,
    })
    VisionTab:CreateButton({
        Name = "Apply Realistic (Force Refresh)",
        Callback = function()
            if not Realistic.Enabled then realisticStart() else realisticRefresh() end
        end,
    })
    local function realToggleSetter(key, findName)
        return function(v)
            Realistic.State[key] = v
            if Realistic.Enabled then
                local inst = Lighting:FindFirstChild(findName)
                if inst then inst.Enabled = v end
            end
        end
    end
    VisionTab:CreateToggle({Name = "Realistic - Color Correction", CurrentValue = true, Flag = "RealisticCC", Callback = realToggleSetter("ColorCorrection", "Nexus_ColorCorrection")})
    VisionTab:CreateToggle({Name = "Realistic - Bloom", CurrentValue = true, Flag = "RealisticBloom", Callback = realToggleSetter("Bloom", "Nexus_Bloom")})
    VisionTab:CreateToggle({Name = "Realistic - Depth of Field", CurrentValue = true, Flag = "RealisticDOF", Callback = realToggleSetter("DepthOfField", "Nexus_DOF")})
    VisionTab:CreateToggle({Name = "Realistic - Sun Rays", CurrentValue = true, Flag = "RealisticSunRays", Callback = realToggleSetter("SunRays", "Nexus_SunRays")})
    VisionTab:CreateToggle({Name = "Realistic - Atmosphere", CurrentValue = true, Flag = "RealisticAtmo", Callback = realToggleSetter("Atmosphere", "Nexus_Atmosphere")})
    VisionTab:CreateToggle({Name = "Realistic - Sky", CurrentValue = true, Flag = "RealisticSky", Callback = realToggleSetter("Sky", "Nexus_Sky")})
    VisionTab:CreateToggle({Name = "Realistic - Clouds", CurrentValue = true, Flag = "RealisticClouds", Callback = realToggleSetter("Clouds", "Nexus_Clouds")})
    VisionTab:CreateSlider({
        Name = "Realistic - Saturation", Range = {-1, 1}, Increment = 0.05, Suffix = "",
        CurrentValue = 0.15, Flag = "RealisticSat",
        Callback = function(v)
            Realistic.State.Saturation = v
            if Realistic.Enabled then
                local cc = Lighting:FindFirstChild("Nexus_ColorCorrection")
                if cc then cc.Saturation = v end
            end
        end,
    })
    VisionTab:CreateSlider({
        Name = "Realistic - Contrast", Range = {-1, 1}, Increment = 0.05, Suffix = "",
        CurrentValue = 0.12, Flag = "RealisticContrast",
        Callback = function(v)
            Realistic.State.Contrast = v
            if Realistic.Enabled then
                local cc = Lighting:FindFirstChild("Nexus_ColorCorrection")
                if cc then cc.Contrast = v end
            end
        end,
    })
    VisionTab:CreateSlider({
        Name = "Realistic - Brightness Boost", Range = {-0.5, 0.5}, Increment = 0.02, Suffix = "",
        CurrentValue = 0.05, Flag = "RealisticBright",
        Callback = function(v)
            Realistic.State.Brightness = v
            if Realistic.Enabled then
                local cc = Lighting:FindFirstChild("Nexus_ColorCorrection")
                if cc then cc.Brightness = v end
            end
        end,
    })
    VisionTab:CreateSlider({
        Name = "Realistic - Bloom Intensity", Range = {0, 3}, Increment = 0.1, Suffix = "",
        CurrentValue = 0.9, Flag = "RealisticBloomI",
        Callback = function(v)
            Realistic.State.BloomIntensity = v
            if Realistic.Enabled then
                local bl = Lighting:FindFirstChild("Nexus_Bloom")
                if bl then bl.Intensity = v end
            end
        end,
    })
    VisionTab:CreateSlider({
        Name = "Realistic - DOF Focus Distance", Range = {5, 500}, Increment = 5, Suffix = "studs",
        CurrentValue = 60, Flag = "RealisticDOFDist",
        Callback = function(v)
            Realistic.State.DOFFocus = v
            if Realistic.Enabled then
                local dof = Lighting:FindFirstChild("Nexus_DOF")
                if dof then dof.FocusDistance = v end
            end
        end,
    })
    VisionTab:CreateSlider({
        Name = "Realistic - Sun Rays Intensity", Range = {0, 1}, Increment = 0.02, Suffix = "",
        CurrentValue = 0.12, Flag = "RealisticSunI",
        Callback = function(v)
            Realistic.State.SunRaysIntensity = v
            if Realistic.Enabled then
                local sr = Lighting:FindFirstChild("Nexus_SunRays")
                if sr then sr.Intensity = v end
            end
        end,
    })
    VisionTab:CreateSlider({
        Name = "Realistic - Time of Day", Range = {0, 24}, Increment = 0.5, Suffix = "h",
        CurrentValue = 15.5, Flag = "RealisticTime",
        Callback = function(v)
            Realistic.State.ClockTime = v
            if Realistic.Enabled then Lighting.ClockTime = v end
        end,
    })
    VisionTab:CreateSlider({
        Name = "Realistic - Ambient Brightness", Range = {0, 5}, Increment = 0.1, Suffix = "",
        CurrentValue = 2.1, Flag = "RealisticAmbB",
        Callback = function(v)
            Realistic.State.BrightnessValue = v
            if Realistic.Enabled then Lighting.Brightness = v end
        end,
    })
    registerCharRemoving(function() if Realistic.Enabled then task.wait(0.1); realisticRefresh() end end)
end

local AimbotTab = Window:CreateTab("Aimbot", 4483362458)

do
    AimbotTab:CreateSection("Aimbot")
    local Aim = {
        Enabled = false, WallCheck = false, TeamCheck = false,
        Smoothness = 0.35, FOV = 150, TargetPart = "Head",
        MaxDistance = 500, TriggerKey = Enum.UserInputType.MouseButton2,
        ShowFOV = true, Prediction = 0.15, LockMouse = true, RotateChar = true,
    }
    local AimRuntime = {Conn = nil, Target = nil, FovGui = nil, FovCircle = nil, SavedCameraType = nil, SavedAutoRotate = nil}
    local aimRayParams = RaycastParams.new()
    aimRayParams.FilterType = Enum.RaycastFilterType.Exclude
    aimRayParams.IgnoreWater = true
    local function aimMakeFov()
        if AimRuntime.FovGui then pcall(function() AimRuntime.FovGui:Destroy() end) end
        local old = playerGui:FindFirstChild("NexusFOVGui")
        if old then old:Destroy() end
        local gui = Instance.new("ScreenGui")
        gui.Name = "NexusFOVGui"; gui.ResetOnSpawn = false
        gui.IgnoreGuiInset = true; gui.DisplayOrder = 9999
        gui.Parent = playerGui; AimRuntime.FovGui = gui
        local c = Instance.new("Frame")
        c.AnchorPoint = Vector2.new(0.5, 0.5)
        c.BackgroundTransparency = 1; c.BorderSizePixel = 0
        c.Position = UDim2.new(0.5, 0, 0.5, 0); c.ZIndex = 9999
        c.Visible = false; c.Parent = gui
        AimRuntime.FovCircle = c
        local cr = Instance.new("UICorner"); cr.CornerRadius = UDim.new(0, 9999); cr.Parent = c
        local s = Instance.new("UIStroke")
        s.Color = Color3.fromRGB(180, 30, 45); s.Thickness = 1.5
        s.Transparency = 0.35; s.Parent = c
    end
    local function aimUpdateFov()
        local c = AimRuntime.FovCircle
        if not c then return end
        local cam = getCamera()
        local vp = cam and cam.ViewportSize or Vector2.new(1920, 1080)
        local maxD = math.min(vp.X, vp.Y) - 4
        local d = math.min(Aim.FOV * 2, maxD)
        c.Size = UDim2.new(0, d, 0, d)
        c.Visible = Aim.ShowFOV and Aim.Enabled
    end
    local function aimGetPart(char)
        if not char then return nil end
        local part = char:FindFirstChild(Aim.TargetPart)
        if not part then
            part = char:FindFirstChild("Head") or char:FindFirstChild("UpperTorso")
                or char:FindFirstChild("Torso") or char:FindFirstChild("HumanoidRootPart")
        end
        return part
    end
    local function aimHasLos(targetPart, camPos, filter)
        aimRayParams.FilterDescendantsInstances = filter
        local dir = targetPart.Position - camPos
        local result = Workspace:Raycast(camPos, dir, aimRayParams)
        if not result then return true end
        local char = targetPart.Parent
        return char and result.Instance:IsDescendantOf(char) or false
    end
    local function aimFindTarget(myRoot)
        local cam = getCamera()
        if not cam then return nil end
        local vp = cam.ViewportSize
        if not vp or vp.X == 0 then return nil end
        local refX, refY = vp.X * 0.5, vp.Y * 0.5
        local camPos = cam.CFrame.Position
        local myPos = myRoot.Position
        local checkTeam = Aim.TeamCheck
        local myTeam = LocalPlayer.Team
        local filter = {LocalPlayer.Character, cam}
        local best, bestScore = nil, math.huge
        for _, p in ipairs(Players:GetPlayers()) do
            if p ~= LocalPlayer then
                local c = p.Character
                if c then
                    local teamOk = not (checkTeam and myTeam and p.Team and p.Team == myTeam)
                    if teamOk then
                        local h = c:FindFirstChildOfClass("Humanoid")
                        if h and h.Health > 0 then
                            local tp = aimGetPart(c)
                            if tp then
                                local d3 = (tp.Position - myPos).Magnitude
                                if d3 <= Aim.MaxDistance then
                                    local sp, onScreen = cam:WorldToViewportPoint(tp.Position)
                                    if onScreen and sp.Z > 0 then
                                        local dx, dy = sp.X - refX, sp.Y - refY
                                        local sdist = math.sqrt(dx * dx + dy * dy)
                                        if sdist <= Aim.FOV then
                                            local score = sdist + d3 * 0.05
                                            if score < bestScore then
                                                if not Aim.WallCheck or aimHasLos(tp, camPos, filter) then
                                                    bestScore = score
                                                    best = p
                                                end
                                            end
                                        end
                                    end
                                end
                            end
                        end
                    end
                end
            end
        end
        return best
    end
    local function aimSetScriptable(on)
        local cam = getCamera()
        if not cam then return end
        if on then
            if cam.CameraType ~= Enum.CameraType.Scriptable then
                AimRuntime.SavedCameraType = cam.CameraType
                cam.CameraType = Enum.CameraType.Scriptable
            end
        else
            if AimRuntime.SavedCameraType and cam.CameraType == Enum.CameraType.Scriptable then
                cam.CameraType = AimRuntime.SavedCameraType
            end
            AimRuntime.SavedCameraType = nil
        end
    end
    local function aimRestoreAutoRotate()
        local h = getHumanoid()
        if h and AimRuntime.SavedAutoRotate ~= nil then
            h.AutoRotate = AimRuntime.SavedAutoRotate
        end
        AimRuntime.SavedAutoRotate = nil
    end
    local function aimRotateTo(targetPos, myRoot)
        if not Aim.RotateChar or not myRoot then return end
        local h = getHumanoid()
        if not h then return end
        if AimRuntime.SavedAutoRotate == nil then AimRuntime.SavedAutoRotate = h.AutoRotate end
        h.AutoRotate = false
        local dir = targetPos - myRoot.Position
        local flat = Vector3.new(dir.X, 0, dir.Z)
        if flat.Magnitude > 0.001 then
            local cf = CFrame.lookAt(myRoot.Position, myRoot.Position + flat.Unit)
            myRoot.CFrame = CFrame.new(myRoot.Position) * (cf - cf.Position)
        end
    end
    local function aimApply(target, dt)
        local cam = getCamera()
        if not cam then return end
        local c = target.Character
        if not c then return end
        local part = aimGetPart(c)
        if not part then return end
        local pos = part.Position
        if Aim.Prediction > 0 then
            local h = c:FindFirstChildOfClass("Humanoid")
            if h and h.RootPart then
                pos = pos + h.RootPart.AssemblyLinearVelocity * Aim.Prediction
            end
        end
        local myRoot = getRoot()
        if myRoot then aimRotateTo(pos, myRoot) end
        local curCF = cam.CFrame
        local tgtCF = CFrame.lookAt(curCF.Position, pos)
        local alpha
        if Aim.Smoothness <= 0 then alpha = 1
        else
            local k = (1 - Aim.Smoothness) * 35
            alpha = 1 - math.exp(-k * dt)
        end
        alpha = math.clamp(alpha, 0, 1)
        if curCF.LookVector:Dot(tgtCF.LookVector) > 0.99995 then cam.CFrame = tgtCF
        else cam.CFrame = curCF:Lerp(tgtCF, alpha) end
        if Aim.LockMouse and HAS_MOUSE then
            pcall(function() UserInputService.MouseBehavior = Enum.MouseBehavior.LockCenter end)
        end
    end
    local function aimIsAiming()
        local k = Aim.TriggerKey
        if k == Enum.UserInputType.MouseButton1 then
            return UserInputService:IsMouseButtonPressed(Enum.UserInputType.MouseButton1)
        elseif k == Enum.UserInputType.MouseButton2 then
            return UserInputService:IsMouseButtonPressed(Enum.UserInputType.MouseButton2)
        elseif k == Enum.KeyCode.E then return UserInputService:IsKeyDown(Enum.KeyCode.E)
        elseif k == Enum.KeyCode.Q then return UserInputService:IsKeyDown(Enum.KeyCode.Q)
        elseif k == Enum.KeyCode.LeftAlt then return UserInputService:IsKeyDown(Enum.KeyCode.LeftAlt) end
        return false
    end
    local function aimLoop(dt)
        if not Aim.Enabled or not aimIsAiming() then
            if AimRuntime.SavedCameraType then aimSetScriptable(false) end
            aimRestoreAutoRotate()
            if HAS_MOUSE then
                pcall(function() UserInputService.MouseBehavior = Enum.MouseBehavior.Default end)
            end
            AimRuntime.Target = nil
            return
        end
        local myRoot = getRoot()
        if not myRoot then
            if AimRuntime.SavedCameraType then aimSetScriptable(false) end
            AimRuntime.Target = nil
            return
        end
        local t = aimFindTarget(myRoot)
        if t then
            AimRuntime.Target = t
            aimSetScriptable(true)
            aimApply(t, dt)
        else
            AimRuntime.Target = nil
            aimSetScriptable(false)
            aimRestoreAutoRotate()
        end
    end
    local function aimStart()
        if AimRuntime.Conn then return end
        AimRuntime.Conn = RenderStepped:Connect(aimLoop)
    end
    local function aimStop()
        if AimRuntime.Conn then AimRuntime.Conn:Disconnect(); AimRuntime.Conn = nil end
        AimRuntime.Target = nil
        aimSetScriptable(false)
        aimRestoreAutoRotate()
        if HAS_MOUSE then
            pcall(function() UserInputService.MouseBehavior = Enum.MouseBehavior.Default end)
        end
    end
    aimMakeFov()
    aimUpdateFov()
    local cam = getCamera()
    if cam then
        GlobalBag:conn(cam:GetPropertyChangedSignal("ViewportSize"):Connect(aimUpdateFov))
    end
    AimbotTab:CreateToggle({
        Name = "Enable Aimbot", CurrentValue = false, Flag = "Aimbot",
        Callback = function(v)
            Aim.Enabled = v
            if v then aimStart() else aimStop() end
            aimUpdateFov()
        end,
    })
    AimbotTab:CreateToggle({Name = "Rotate Character to Target", CurrentValue = true, Flag = "RotateChar", Callback = function(v) Aim.RotateChar = v end})
    AimbotTab:CreateToggle({Name = "Lock Mouse", CurrentValue = HAS_MOUSE, Flag = "LockMouse", Callback = function(v) Aim.LockMouse = v end})
    AimbotTab:CreateToggle({Name = "Wall Check", CurrentValue = false, Flag = "WallCheck", Callback = function(v) Aim.WallCheck = v end})
    AimbotTab:CreateToggle({Name = "Team Check", CurrentValue = false, Flag = "TeamCheck", Callback = function(v) Aim.TeamCheck = v end})
    AimbotTab:CreateToggle({
        Name = "Show FOV Circle", CurrentValue = true, Flag = "ShowFOV",
        Callback = function(v)
            Aim.ShowFOV = v
            if v and not AimRuntime.FovCircle then aimMakeFov() end
            aimUpdateFov()
        end,
    })
    AimbotTab:CreateSlider({
        Name = "FOV Radius", Range = {10, 800}, Increment = 1, Suffix = "px",
        CurrentValue = 150, Flag = "AimFOV",
        Callback = function(v) Aim.FOV = v; aimUpdateFov() end,
    })
    AimbotTab:CreateSlider({
        Name = "Smoothness", Range = {0, 1}, Increment = 0.05, Suffix = "",
        CurrentValue = 0.35, Flag = "Smoothness",
        Callback = function(v) Aim.Smoothness = v end,
    })
    AimbotTab:CreateSlider({
        Name = "Max Distance", Range = {10, 2000}, Increment = 1, Suffix = "studs",
        CurrentValue = 500, Flag = "MaxDistance",
        Callback = function(v) Aim.MaxDistance = v end,
    })
    AimbotTab:CreateSlider({
        Name = "Prediction", Range = {0, 1}, Increment = 0.05, Suffix = "",
        CurrentValue = 0.15, Flag = "Prediction",
        Callback = function(v) Aim.Prediction = v end,
    })
    AimbotTab:CreateDropdown({
        Name = "Target Part", Options = {"Head", "Torso", "Pelvis", "Root"},
        CurrentOption = {"Head"}, Flag = "TargetPart",
        Callback = function(opt)
            local map = {Head = "Head", Torso = "UpperTorso", Pelvis = "LowerTorso", Root = "HumanoidRootPart"}
            local key = type(opt) == "table" and opt[1] or opt
            Aim.TargetPart = map[key] or "Head"
        end,
    })
    AimbotTab:CreateDropdown({
        Name = "Activation Key",
        Options = {"Right Click", "Left Click", "E", "Q", "Left Alt"},
        CurrentOption = {"Right Click"}, Flag = "TriggerKey",
        Callback = function(opt)
            local map = {
                ["Right Click"] = Enum.UserInputType.MouseButton2,
                ["Left Click"] = Enum.UserInputType.MouseButton1,
                E = Enum.KeyCode.E, Q = Enum.KeyCode.Q,
                ["Left Alt"] = Enum.KeyCode.LeftAlt,
            }
            local key = type(opt) == "table" and opt[1] or opt
            Aim.TriggerKey = map[key] or Enum.UserInputType.MouseButton2
        end,
    })
    registerCharRemoving(function()
        aimSetScriptable(false)
        aimRestoreAutoRotate()
        if HAS_MOUSE then
            pcall(function() UserInputService.MouseBehavior = Enum.MouseBehavior.Default end)
        end
        AimRuntime.Target = nil
    end)
end

local FlingTab = Window:CreateTab("Fling", 4483362458)

do
    FlingTab:CreateSection("Touch Fling")

    local TF = {
        Enabled = false, Generation = 0, Running = false, Thread = nil,
    }

    local function tfResetVelocity()
        local char = getChar()
        local hrp = char and char:FindFirstChild("HumanoidRootPart")
        if hrp then
            hrp.Velocity = Vector3.zero
            hrp.RotVelocity = Vector3.zero
        end
    end

    local function tfLoop(gen)
        local movel = 0.1
        while TF.Enabled and TF.Generation == gen do
            Heartbeat:Wait()
            if not TF.Enabled or TF.Generation ~= gen then break end

            local char = getChar()
            local hrp = char and char:FindFirstChild("HumanoidRootPart")
            if hrp and hrp.Parent then
                local vel = hrp.Velocity
                hrp.Velocity = vel * 10000 + Vector3.new(0, 10000, 0)

                RenderStepped:Wait()
                if not TF.Enabled or TF.Generation ~= gen then break end
                if hrp.Parent then hrp.Velocity = vel end

                Stepped:Wait()
                if not TF.Enabled or TF.Generation ~= gen then break end
                if hrp.Parent then
                    hrp.Velocity = vel + Vector3.new(0, movel, 0)
                end
                movel = -movel
            end
        end
        if TF.Generation == gen then TF.Running = false end
    end

    local function tfStart()
        if TF.Running and TF.Enabled then return end
        TF.Enabled = true
        TF.Running = true
        TF.Generation += 1
        local gen = TF.Generation
        TF.Thread = task.spawn(function() tfLoop(gen) end)
    end

    local function tfStop()
        TF.Enabled = false
        TF.Running = false
        TF.Generation += 1
        tfResetVelocity()
    end

    FlingTab:CreateToggle({
        Name = "Touch Fling", CurrentValue = false, Flag = "TouchFlingMain",
        Callback = function(v)
            if v then tfStart(); notify("Touch Fling", "Enabled", 2)
            else tfStop(); notify("Touch Fling", "Disabled", 2) end
        end,
    })

    registerCharRemoving(function()
        if TF.Enabled then tfResetVelocity() end
    end)

    registerCharAdded(function()
        if TF.Enabled then task.wait(0.4); tfResetVelocity() end
    end)
end

local TrollTab = Window:CreateTab("Troll", 4483362458)

do
    TrollTab:CreateSection("Target Selection")
    local TrollState = {SelectedPlayer = nil}
    local function buildTrollOptions()
        local t = {"None"}
        for _, p in ipairs(Players:GetPlayers()) do
            if p ~= LocalPlayer then table.insert(t, p.Name) end
        end
        return t
    end
    TrollTab:CreateDropdown({
        Name = "Select Player", Options = buildTrollOptions(),
        CurrentOption = {"None"}, Flag = "SelectedPlayerTroll",
        Callback = function(opt)
            local key = type(opt) == "table" and opt[1] or opt
            TrollState.SelectedPlayer = nil
            for _, p in ipairs(Players:GetPlayers()) do
                if p.Name == key then TrollState.SelectedPlayer = p end
            end
        end,
    })

    TrollTab:CreateSection("Follow")
    local Follow = {
        Enabled = false, Distance = 3, Height = 0, Method = "CFrame",
        Smooth = false, Smoothness = 0.3, Target = nil, Conn = nil,
        Attach0 = nil, Attach1 = nil, Align = nil, Orient = nil,
    }
    local function followStop()
        Follow.Enabled = false
        if Follow.Conn then Follow.Conn:Disconnect(); Follow.Conn = nil end
        if Follow.Align then Follow.Align:Destroy(); Follow.Align = nil end
        if Follow.Orient then Follow.Orient:Destroy(); Follow.Orient = nil end
        if Follow.Attach0 then Follow.Attach0:Destroy(); Follow.Attach0 = nil end
        if Follow.Attach1 then Follow.Attach1:Destroy(); Follow.Attach1 = nil end
        Follow.Target = nil
    end
    local function followStart(target)
        if not target or not target.Character then return end
        local tr = target.Character:FindFirstChild("HumanoidRootPart")
        if not tr then return end
        followStop()
        Follow.Target = target
        Follow.Enabled = true
        if Follow.Method == "AlignPosition" then
            local myRoot = getRoot()
            if not myRoot then followStop(); return end
            local a0 = Instance.new("Attachment"); a0.Name = "NexusFAtt"; a0.Parent = myRoot
            local a1 = Instance.new("Attachment"); a1.Name = "NexusFTT"; a1.Parent = tr
            Follow.Attach0, Follow.Attach1 = a0, a1
            local ap = Instance.new("AlignPosition")
            ap.Attachment0 = a0; ap.Attachment1 = a1
            ap.MaxForce = 1e6; ap.Responsiveness = 50; ap.Parent = myRoot
            Follow.Align = ap
            local ao = Instance.new("AlignOrientation")
            ao.Attachment0 = a0; ao.Attachment1 = a1
            ao.MaxTorque = 1e6; ao.Responsiveness = 50; ao.Parent = myRoot
            Follow.Orient = ao
            Follow.Conn = Heartbeat:Connect(function()
                if not Follow.Target or not Follow.Target.Character then return end
                local newTr = Follow.Target.Character:FindFirstChild("HumanoidRootPart")
                if newTr and Follow.Attach1 then Follow.Attach1.Parent = newTr end
            end)
        else
            Follow.Conn = Heartbeat:Connect(function()
                if not Follow.Target or not Follow.Target.Character then return end
                local myRoot = getRoot()
                if not myRoot then return end
                local tr2 = Follow.Target.Character:FindFirstChild("HumanoidRootPart")
                if not tr2 then return end
                local behind = tr2.Position - tr2.CFrame.LookVector * Follow.Distance + Vector3.new(0, Follow.Height, 0)
                local targetCF = CFrame.lookAt(behind, behind + tr2.CFrame.LookVector)
                if Follow.Smooth then
                    local alpha = 1 - math.exp(-(1 - Follow.Smoothness) * 20 * (1 / 60))
                    myRoot.CFrame = myRoot.CFrame:Lerp(targetCF, alpha)
                else
                    myRoot.CFrame = targetCF
                end
            end)
        end
        notify("Follow", "Following " .. target.Name, 2)
    end
    TrollTab:CreateButton({
        Name = "Follow Selected Target",
        Callback = function()
            local p = TrollState.SelectedPlayer
            if p and p.Parent then followStart(p) end
        end,
    })
    TrollTab:CreateButton({Name = "Stop Following", Callback = followStop})
    TrollTab:CreateDropdown({
        Name = "Follow Method", Options = {"CFrame", "AlignPosition"},
        CurrentOption = {"CFrame"}, Flag = "FollowMethod",
        Callback = function(opt) Follow.Method = type(opt) == "table" and opt[1] or opt end,
    })
    TrollTab:CreateSlider({
        Name = "Distance Behind Target", Range = {0, 20}, Increment = 0.5, Suffix = "studs",
        CurrentValue = 3, Flag = "FollowDistance",
        Callback = function(v) Follow.Distance = v end,
    })
    TrollTab:CreateSlider({
        Name = "Height", Range = {-5, 20}, Increment = 0.5, Suffix = "studs",
        CurrentValue = 0, Flag = "FollowHeight",
        Callback = function(v) Follow.Height = v end,
    })
    registerCharRemoving(followStop)

    TrollTab:CreateSection("Spin Bot")
    local SpinBot = {Active = false, Conn = nil, Angle = 0, Speed = 30}
    local function spinBotStart()
        if SpinBot.Active then return end
        SpinBot.Active = true
        SpinBot.Angle = 0
        SpinBot.Conn = RenderStepped:Connect(function(dt)
            local root = getRoot()
            if not root then return end
            SpinBot.Angle += SpinBot.Speed * math.pi * 2 * dt
            if SpinBot.Angle > math.pi * 2 then SpinBot.Angle -= math.pi * 2 end
            root.CFrame = CFrame.new(root.Position) * CFrame.Angles(0, SpinBot.Angle, 0)
        end)
        notify("Spin Bot", "Enabled", 2)
    end
    local function spinBotStop()
        if not SpinBot.Active then return end
        SpinBot.Active = false
        if SpinBot.Conn then SpinBot.Conn:Disconnect(); SpinBot.Conn = nil end
        notify("Spin Bot", "Disabled", 2)
    end
    TrollTab:CreateToggle({
        Name = "Spin Bot (Visible to All)", CurrentValue = false, Flag = "SpinBot",
        Callback = function(v) if v then spinBotStart() else spinBotStop() end end,
    })
    TrollTab:CreateSlider({
        Name = "Spin Bot Speed", Range = {1, 100}, Increment = 1, Suffix = "t/s",
        CurrentValue = 30, Flag = "SpinBotSpeed",
        Callback = function(v) SpinBot.Speed = v end,
    })
    registerCharRemoving(spinBotStop)

    TrollTab:CreateSection("Fling (Troll)")
    local TFling = {
        AutoConn = nil, TouchConn = nil, AutoEnabled = false, TouchEnabled = false,
        Power = 100, Range = 5, TouchRange = 3, LastTime = 0,
    }
    local function tflingTarget(targetChar, myRoot)
        if not targetChar or not myRoot or not myRoot.Parent then return end
        local tr = targetChar:FindFirstChild("HumanoidRootPart")
        local th = targetChar:FindFirstChildOfClass("Humanoid")
        if not tr or not th or th.Health <= 0 then return end
        local dir = tr.Position - myRoot.Position
        if dir.Magnitude > 0.001 then
            myRoot.CFrame = CFrame.new(tr.Position - dir.Unit * 0.5, tr.Position)
        end
        local bv = Instance.new("BodyVelocity")
        bv.MaxForce = Vector3.new(math.huge, math.huge, math.huge)
        bv.P = math.huge
        bv.Velocity = Vector3.new(
            math.random(-1, 1) * TFling.Power * 5,
            TFling.Power * 3,
            math.random(-1, 1) * TFling.Power * 5)
        bv.Parent = myRoot
        local bg = Instance.new("BodyGyro")
        bg.MaxTorque = Vector3.new(math.huge, math.huge, math.huge)
        bg.P = math.huge
        bg.CFrame = CFrame.Angles(
            math.rad(math.random(-360, 360)),
            math.rad(math.random(-360, 360)),
            math.rad(math.random(-360, 360)))
        bg.Parent = myRoot
        task.delay(0.15, function()
            if bv and bv.Parent then bv:Destroy() end
            if bg and bg.Parent then bg:Destroy() end
        end)
        pcall(function()
            tr.AssemblyLinearVelocity = Vector3.new(
                math.random(-1, 1) * TFling.Power * 8,
                TFling.Power * 5,
                math.random(-1, 1) * TFling.Power * 8)
        end)
    end
    TrollTab:CreateButton({
        Name = "Fling Selected Target",
        Callback = function()
            local p = TrollState.SelectedPlayer
            if not p or not p.Character then notify("Fling", "No target"); return end
            local myRoot = getRoot()
            if not myRoot then return end
            tflingTarget(p.Character, myRoot)
        end,
    })
    TrollTab:CreateButton({
        Name = "Fling All Nearby Players",
        Callback = function()
            local myRoot = getRoot()
            if not myRoot then return end
            for _, p in ipairs(Players:GetPlayers()) do
                if p ~= LocalPlayer and p.Character then
                    local r = p.Character:FindFirstChild("HumanoidRootPart")
                    if r and (r.Position - myRoot.Position).Magnitude <= TFling.Range then
                        tflingTarget(p.Character, myRoot)
                    end
                end
            end
        end,
    })
    TrollTab:CreateToggle({
        Name = "Auto Fling on Contact", CurrentValue = false, Flag = "AutoFling",
        Callback = function(v)
            TFling.AutoEnabled = v
            if v then
                if TFling.AutoConn then return end
                TFling.AutoConn = Heartbeat:Connect(function()
                    if not TFling.AutoEnabled then return end
                    local myRoot = getRoot()
                    if not myRoot then return end
                    local now = tick()
                    if now - TFling.LastTime < 0.05 then return end
                    for _, p in ipairs(Players:GetPlayers()) do
                        if p ~= LocalPlayer and p.Character then
                            local r = p.Character:FindFirstChild("HumanoidRootPart")
                            if r and (r.Position - myRoot.Position).Magnitude <= TFling.Range then
                                TFling.LastTime = now
                                tflingTarget(p.Character, myRoot)
                                break
                            end
                        end
                    end
                end)
            else
                if TFling.AutoConn then TFling.AutoConn:Disconnect(); TFling.AutoConn = nil end
            end
        end,
    })
    TrollTab:CreateToggle({
        Name = "Touch Fling (Direct Contact)", CurrentValue = false, Flag = "TouchFling",
        Callback = function(v)
            TFling.TouchEnabled = v
            if v then
                if TFling.TouchConn then return end
                TFling.TouchConn = Heartbeat:Connect(function()
                    if not TFling.TouchEnabled then return end
                    local myRoot = getRoot()
                    if not myRoot then return end
                    for _, p in ipairs(Players:GetPlayers()) do
                        if p ~= LocalPlayer and p.Character then
                            local r = p.Character:FindFirstChild("HumanoidRootPart")
                            if r and (r.Position - myRoot.Position).Magnitude <= TFling.TouchRange then
                                tflingTarget(p.Character, myRoot)
                            end
                        end
                    end
                end)
            else
                if TFling.TouchConn then TFling.TouchConn:Disconnect(); TFling.TouchConn = nil end
            end
        end,
    })
    TrollTab:CreateSlider({
        Name = "Fling Power", Range = {10, 500}, Increment = 1, Suffix = "Power",
        CurrentValue = 100, Flag = "FlingPower",
        Callback = function(v) TFling.Power = v end,
    })
    TrollTab:CreateSlider({
        Name = "Auto Fling Range", Range = {1, 50}, Increment = 1, Suffix = "studs",
        CurrentValue = 5, Flag = "FlingRange",
        Callback = function(v) TFling.Range = v end,
    })
    TrollTab:CreateSlider({
        Name = "Touch Fling Range", Range = {1, 20}, Increment = 1, Suffix = "studs",
        CurrentValue = 3, Flag = "TouchFlingRange",
        Callback = function(v) TFling.TouchRange = v end,
    })

    TrollTab:CreateSection("Freeze")
    local FrozenPlayers = {}
    local function freezePlayer(target, duration)
        if not target or not target.Character then return end
        local root = target.Character:FindFirstChild("HumanoidRootPart")
        local hum = target.Character:FindFirstChildOfClass("Humanoid")
        if not root then return end
        if hum then hum.PlatformStand = true end
        root.Anchored = true
        FrozenPlayers[target] = true
        task.delay(duration or 10, function()
            if FrozenPlayers[target] and target.Character then
                local r = target.Character:FindFirstChild("HumanoidRootPart")
                local h = target.Character:FindFirstChildOfClass("Humanoid")
                if r then r.Anchored = false end
                if h then h.PlatformStand = false end
            end
            FrozenPlayers[target] = nil
        end)
    end
    TrollTab:CreateButton({
        Name = "Freeze Selected Target (10s)",
        Callback = function()
            if TrollState.SelectedPlayer then freezePlayer(TrollState.SelectedPlayer, 10) end
        end,
    })
    TrollTab:CreateButton({
        Name = "Freeze ALL Players (5s)",
        Callback = function()
            for _, p in ipairs(Players:GetPlayers()) do
                if p ~= LocalPlayer then freezePlayer(p, 5) end
            end
            notify("Freeze", "Everyone frozen 5 seconds", 3)
        end,
    })
    TrollTab:CreateButton({
        Name = "Unfreeze Everyone",
        Callback = function()
            for p in pairs(FrozenPlayers) do
                if p and p.Character then
                    local r = p.Character:FindFirstChild("HumanoidRootPart")
                    local h = p.Character:FindFirstChildOfClass("Humanoid")
                    if r then r.Anchored = false end
                    if h then h.PlatformStand = false end
                end
            end
            FrozenPlayers = {}
        end,
    })

    TrollTab:CreateSection("Moderate Lagger")
    local Lagger = {Active = false, Conn = nil, Objects = {}, Count = 20, MaxObjects = 300}
    local function laggerStart()
        if Lagger.Active then return end
        Lagger.Active = true
        Lagger.Conn = Heartbeat:Connect(function()
            if not Lagger.Active then return end
            local root = getRoot()
            if not root then return end
            for _ = 1, Lagger.Count do
                local part = Instance.new("Part")
                part.Size = Vector3.new(5, 5, 5)
                part.Position = root.Position + Vector3.new(
                    math.random(-100, 100), math.random(-50, 100), math.random(-100, 100))
                part.Anchored = false; part.CanCollide = true
                part.Transparency = 1; part.Parent = Workspace
                table.insert(Lagger.Objects, part)
            end
            while #Lagger.Objects > Lagger.MaxObjects do
                local old = table.remove(Lagger.Objects, 1)
                if old and old.Parent then old:Destroy() end
            end
        end)
        notify("Lagger", "Enabled (moderate)", 2)
    end
    local function laggerStop()
        if not Lagger.Active then return end
        Lagger.Active = false
        if Lagger.Conn then Lagger.Conn:Disconnect(); Lagger.Conn = nil end
        for _, obj in ipairs(Lagger.Objects) do
            if obj and obj.Parent then obj:Destroy() end
        end
        Lagger.Objects = {}
        notify("Lagger", "Disabled", 2)
    end
    TrollTab:CreateToggle({
        Name = "Moderate Lagger", CurrentValue = false, Flag = "Lagger",
        Callback = function(v) if v then laggerStart() else laggerStop() end end,
    })
    TrollTab:CreateSlider({
        Name = "Parts Per Frame", Range = {5, 50}, Increment = 5, Suffix = "parts",
        CurrentValue = 20, Flag = "LaggerCount",
        Callback = function(v) Lagger.Count = v end,
    })

    TrollTab:CreateSection("Chat Spam")
    local ChatSpam = {Text = "NEXUS HUB", Thread = nil, Active = false}
    local function sendChat(msg)
        local ok = pcall(function()
            local evt = ReplicatedStorage:FindFirstChild("DefaultChatSystemChatEvents")
            if evt then
                local say = evt:FindFirstChild("SayMessageRequest")
                if say then say:FireServer(msg, "All"); return true end
            end
        end)
        if ok then return end
        pcall(function() StarterGui:SetCore("ChatSendMessage", msg) end)
    end
    TrollTab:CreateInput({
        Name = "Message to Spam", CurrentValue = "NEXUS HUB",
        PlaceholderText = "Message", RemoveTextAfterFocusLost = false,
        Flag = "ChatSpamText",
        Callback = function(v) ChatSpam.Text = v end,
    })
    TrollTab:CreateToggle({
        Name = "Chat Spam (1 msg / 1.5s)", CurrentValue = false, Flag = "ChatSpam",
        Callback = function(v)
            if v then
                if ChatSpam.Active then return end
                ChatSpam.Active = true
                ChatSpam.Thread = task.spawn(function()
                    while ChatSpam.Active do
                        sendChat(ChatSpam.Text)
                        task.wait(1.5)
                    end
                end)
            else
                ChatSpam.Active = false
                if ChatSpam.Thread then
                    pcall(function() task.cancel(ChatSpam.Thread) end)
                    ChatSpam.Thread = nil
                end
            end
        end,
    })
    TrollTab:CreateButton({
        Name = "Send 5 Spaced Messages",
        Callback = function()
            task.spawn(function()
                for _ = 1, 5 do
                    sendChat(ChatSpam.Text)
                    task.wait(0.4)
                end
            end)
        end,
    })

    TrollTab:CreateSection("🌐 Actions Serveur")
    local padRemote = ReplicatedStorage:WaitForChild("NexusLaunchPadRemote", 5)
    local trollRemote = ReplicatedStorage:WaitForChild("NexusTrollRemote", 5)
    local permsRemote = ReplicatedStorage:WaitForChild("NexusPermsRemote", 5)
    local hasServerScript = padRemote and trollRemote and permsRemote
    if not hasServerScript then
        TrollTab:CreateParagraph({
            Title = "⚠️ Script serveur manquant",
            Content = "Installe 'NexusServerCore' dans ServerScriptService pour activer les features serveur.",
        })
    else
        GlobalBag:conn(padRemote.OnClientEvent:Connect(function(action, data)
            if action == "created" then notify("Launch Pad", "✅ Créé côté serveur", 2)
            elseif action == "removed" then notify("Launch Pad", "🗑️ Supprimé", 2)
            elseif action == "expired" then notify("Launch Pad", "⏱️ Expiré", 2)
            elseif action == "error" then notify("Launch Pad", "❌ " .. tostring(data), 3) end
        end))
        GlobalBag:conn(trollRemote.OnClientEvent:Connect(function(action, data)
            if action == "error" then notify("Serveur", "❌ " .. tostring(data), 3) end
        end))
        GlobalBag:conn(permsRemote.OnClientEvent:Connect(function(admin)
            if admin then notify("Permissions", "✅ Admin confirmé", 2)
            else notify("Permissions", "⚠️ Tu n'es pas admin", 4) end
        end))
        pcall(function() permsRemote:FireServer() end)

        TrollTab:CreateSection("🚀 Launch Pad (Serveur)")
        TrollTab:CreateParagraph({
            Title = "ℹ️ Info",
            Content = "La plateforme est créée CÔTÉ SERVEUR. Les AUTRES joueurs qui la touchent seront propulsés.",
        })
        local padOpts = {
            force = 60, size = 8, color = {255, 100, 0},
            material = "Neon", rotate = false, rotateSpeed = 45, texture = "",
        }
        TrollTab:CreateSlider({Name = "Force", Range = {10, 500}, Increment = 1, Suffix = "Power", CurrentValue = 60, Flag = "PadForce", Callback = function(v) padOpts.force = v end})
        TrollTab:CreateSlider({Name = "Taille", Range = {2, 50}, Increment = 1, Suffix = "studs", CurrentValue = 8, Flag = "PadSize", Callback = function(v) padOpts.size = v end})
        TrollTab:CreateSlider({Name = "Vitesse de rotation", Range = {0, 360}, Increment = 5, Suffix = "°/s", CurrentValue = 45, Flag = "PadRotSpeed", Callback = function(v) padOpts.rotateSpeed = v end})
        TrollTab:CreateDropdown({
            Name = "Matériau",
            Options = {"Neon", "ForceField", "Glass", "Ice", "Marble", "Metal", "Plastic"},
            CurrentOption = {"Neon"}, Flag = "PadMaterial",
            Callback = function(o) padOpts.material = type(o) == "table" and o[1] or o end,
        })
        TrollTab:CreateInput({Name = "Texture ID (optionnel)", CurrentValue = "", PlaceholderText = "rbxassetid://123456789", RemoveTextAfterFocusLost = false, Flag = "PadTexture", Callback = function(v) padOpts.texture = v end})
        TrollTab:CreateInput({
            Name = "Couleur RGB", CurrentValue = "255,100,0",
            PlaceholderText = "255,100,0", RemoveTextAfterFocusLost = false,
            Flag = "PadColor",
            Callback = function(v)
                local r, g, b = v:match("(%d+),(%d+),(%d+)")
                if r and g and b then
                    padOpts.color = {tonumber(r), tonumber(g), tonumber(b)}
                end
            end,
        })
        TrollTab:CreateToggle({Name = "Rotation automatique", CurrentValue = false, Flag = "PadRotate", Callback = function(v) padOpts.rotate = v end})
        TrollTab:CreateButton({Name = "🚀 Créer le Launch Pad", Callback = function() pcall(function() padRemote:FireServer("create", padOpts) end) end})
        TrollTab:CreateButton({Name = "🗑️ Supprimer le Launch Pad", Callback = function() pcall(function() padRemote:FireServer("remove") end) end})
        TrollTab:CreateButton({
            Name = "📍 Me téléporter sur ma plateforme",
            Callback = function()
                local pad = Workspace:FindFirstChild("NexusLaunchPad_" .. LocalPlayer.Name)
                if not pad then notify("Launch Pad", "Aucune plateforme active", 2); return end
                local root = getRoot()
                if root then root.CFrame = CFrame.new(pad.Position + Vector3.new(0, 5, 0)) end
            end,
        })

        TrollTab:CreateSection("💥 Fling Serveur")
        local srvFling = {Power = 100, TargetName = ""}
        TrollTab:CreateInput({Name = "Nom de la cible", CurrentValue = "", PlaceholderText = "Pseudo", RemoveTextAfterFocusLost = false, Flag = "FlingTargetName", Callback = function(v) srvFling.TargetName = v end})
        TrollTab:CreateSlider({Name = "Puissance", Range = {10, 500}, Increment = 10, Suffix = "Power", CurrentValue = 100, Flag = "FlingPowerSrv", Callback = function(v) srvFling.Power = v end})
        TrollTab:CreateButton({
            Name = "💥 Fling la cible",
            Callback = function()
                if srvFling.TargetName == "" then notify("Fling", "Entre un nom", 2); return end
                pcall(function()
                    trollRemote:FireServer("fling", srvFling.TargetName, {power = srvFling.Power})
                end)
            end,
        })

        TrollTab:CreateSection("🧊 Freeze Serveur")
        local srvFreeze = {Duration = 5, TargetName = ""}
        TrollTab:CreateInput({Name = "Nom de la cible", CurrentValue = "", PlaceholderText = "Pseudo", RemoveTextAfterFocusLost = false, Flag = "FreezeTargetName", Callback = function(v) srvFreeze.TargetName = v end})
        TrollTab:CreateSlider({Name = "Durée", Range = {1, 30}, Increment = 1, Suffix = "secondes", CurrentValue = 5, Flag = "FreezeDuration", Callback = function(v) srvFreeze.Duration = v end})
        TrollTab:CreateButton({
            Name = "🧊 Geler la cible",
            Callback = function()
                if srvFreeze.TargetName == "" then notify("Freeze", "Entre un nom", 2); return end
                pcall(function()
                    trollRemote:FireServer("freeze", srvFreeze.TargetName, {duration = srvFreeze.Duration})
                end)
            end,
        })

        TrollTab:CreateSection("💀 Kill Serveur")
        local srvKill = {TargetName = ""}
        TrollTab:CreateInput({Name = "Nom de la cible", CurrentValue = "", PlaceholderText = "Pseudo", RemoveTextAfterFocusLost = false, Flag = "KillTargetName", Callback = function(v) srvKill.TargetName = v end})
        TrollTab:CreateButton({
            Name = "💀 Tuer la cible",
            Callback = function()
                if srvKill.TargetName == "" then notify("Kill", "Entre un nom", 2); return end
                pcall(function() trollRemote:FireServer("kill", srvKill.TargetName) end)
            end,
        })

        TrollTab:CreateSection("🌀 Téléportation Serveur")
        local srvTp = {TargetName = ""}
        TrollTab:CreateInput({Name = "Nom de la cible", CurrentValue = "", PlaceholderText = "Pseudo", RemoveTextAfterFocusLost = false, Flag = "TPTargetName", Callback = function(v) srvTp.TargetName = v end})
        TrollTab:CreateButton({
            Name = "➡️ Me TP vers la cible",
            Callback = function()
                if srvTp.TargetName == "" then notify("TP", "Entre un nom", 2); return end
                pcall(function() trollRemote:FireServer("tp_to", srvTp.TargetName) end)
            end,
        })
        TrollTab:CreateButton({
            Name = "⬅️ Amener la cible à moi",
            Callback = function()
                if srvTp.TargetName == "" then notify("TP", "Entre un nom", 2); return end
                pcall(function() trollRemote:FireServer("tp_bring", srvTp.TargetName) end)
            end,
        })

        TrollTab:CreateSection("🐌 Lagger Serveur")
        local srvLagger = {Parts = 10, Active = false}
        TrollTab:CreateSlider({Name = "Parts par frame", Range = {1, 50}, Increment = 1, Suffix = "parts", CurrentValue = 10, Flag = "LaggerParts", Callback = function(v) srvLagger.Parts = v end})
        TrollTab:CreateToggle({
            Name = "Activer le Lagger", CurrentValue = false, Flag = "LaggerToggle",
            Callback = function(v)
                srvLagger.Active = v
                if v then
                    pcall(function()
                        trollRemote:FireServer("lagger_start", nil, {parts = srvLagger.Parts})
                    end)
                else
                    pcall(function() trollRemote:FireServer("lagger_stop") end)
                end
            end,
        })
    end

    registerCharRemoving(function()
        if TFling.AutoEnabled and TFling.AutoConn then
            TFling.AutoConn:Disconnect(); TFling.AutoConn = nil
        end
        if TFling.TouchEnabled and TFling.TouchConn then
            TFling.TouchConn:Disconnect(); TFling.TouchConn = nil
        end
        laggerStop()
    end)
end

local PlayerActionsTab = Window:CreateTab("Player Actions", 4483362458)

do
    PlayerActionsTab:CreateSection("Player Actions")
    PlayerActionsTab:CreateButton({
        Name = "Heal Me",
        Callback = function()
            local h = getHumanoid()
            if h then h.Health = h.MaxHealth end
        end,
    })
    PlayerActionsTab:CreateButton({
        Name = "Teleport to Cursor",
        Callback = function()
            if not HAS_MOUSE then notify("TP", "Not available on mobile/console", 2); return end
            local m = LocalPlayer:GetMouse()
            local r = getRoot()
            if r and m and m.Hit then
                r.CFrame = CFrame.new(m.Hit.Position + Vector3.new(0, 3, 0))
            end
        end,
    })
    PlayerActionsTab:CreateButton({
        Name = "Respawn",
        Callback = function()
            local h = getHumanoid()
            if h then h.Health = 0 end
        end,
    })

    PlayerActionsTab:CreateSection("NPC Mode")
    local NPC = {Active = false, Conn = nil}
    local function npcStart()
        if NPC.Active then return end
        NPC.Active = true
        local h = getHumanoid()
        if h then h.WalkSpeed = 0; h.JumpPower = 0 end
        NPC.Conn = RenderStepped:Connect(function()
            local root = getRoot()
            if not root then return end
            root.AssemblyLinearVelocity = Vector3.zero
            root.AssemblyAngularVelocity = Vector3.zero
        end)
        notify("NPC Mode", "Enabled", 2)
    end
    local function npcStop()
        if not NPC.Active then return end
        NPC.Active = false
        if NPC.Conn then NPC.Conn:Disconnect(); NPC.Conn = nil end
        local h = getHumanoid()
        if h then h.WalkSpeed = 16; h.JumpPower = 50 end
        notify("NPC Mode", "Disabled", 2)
    end
    PlayerActionsTab:CreateToggle({
        Name = "NPC Mode (Stay Still)", CurrentValue = false, Flag = "NPCMode",
        Callback = function(v) if v then npcStart() else npcStop() end end,
    })
    registerCharRemoving(npcStop)

    PlayerActionsTab:CreateSection("Anti-AFK")
    local AntiAFK = {Conn = nil, Enabled = false}
    local function antiAFKStart()
        if AntiAFK.Conn then return end
        AntiAFK.Enabled = true
        AntiAFK.Conn = LocalPlayer.Idled:Connect(function()
            pcall(function()
                VirtualUser:CaptureController()
                VirtualUser:ClickButton2(Vector2.new())
            end)
        end)
    end
    local function antiAFKStop()
        AntiAFK.Enabled = false
        if AntiAFK.Conn then AntiAFK.Conn:Disconnect(); AntiAFK.Conn = nil end
    end
    PlayerActionsTab:CreateToggle({
        Name = "Anti-AFK", CurrentValue = true, Flag = "AntiAFK",
        Callback = function(v) if v then antiAFKStart() else antiAFKStop() end end,
    })
    antiAFKStart()
end

local PerfTab = Window:CreateTab("Performance", 4483362458)

do
    PerfTab:CreateSection("Optimization")
    local ParticleKiller = {Store = setmetatable({}, {__mode = "k"}), Conn = nil, Enabled = false}
    local function particleKillEnable()
        for _, obj in ipairs(Workspace:GetDescendants()) do
            if obj:IsA("ParticleEmitter") or obj:IsA("Trail") or obj:IsA("Smoke")
                or obj:IsA("Fire") or obj:IsA("Sparkles") or obj:IsA("Beam") then
                if not ParticleKiller.Store[obj] then
                    ParticleKiller.Store[obj] = obj.Enabled
                    obj.Enabled = false
                end
            end
        end
        ParticleKiller.Conn = Workspace.DescendantAdded:Connect(function(obj)
            if not ParticleKiller.Enabled then return end
            if obj:IsA("ParticleEmitter") or obj:IsA("Trail") or obj:IsA("Smoke")
                or obj:IsA("Fire") or obj:IsA("Sparkles") or obj:IsA("Beam") then
                ParticleKiller.Store[obj] = obj.Enabled
                obj.Enabled = false
            end
        end)
    end
    local function particleKillDisable()
        if ParticleKiller.Conn then ParticleKiller.Conn:Disconnect(); ParticleKiller.Conn = nil end
        for obj, enabled in pairs(ParticleKiller.Store) do
            if obj and obj.Parent then pcall(function() obj.Enabled = enabled end) end
        end
        ParticleKiller.Store = setmetatable({}, {__mode = "k"})
    end
    PerfTab:CreateToggle({
        Name = "Remove Particles (FPS Boost)", CurrentValue = false, Flag = "RemoveParticles",
        Callback = function(v)
            ParticleKiller.Enabled = v
            if v then particleKillEnable() else particleKillDisable() end
        end,
    })

    local TextureKiller = {Store = setmetatable({}, {__mode = "k"})}
    PerfTab:CreateToggle({
        Name = "Remove Textures (FPS Boost)", CurrentValue = false, Flag = "RemoveTextures",
        Callback = function(v)
            if v then
                for _, obj in ipairs(Workspace:GetDescendants()) do
                    if obj:IsA("Decal") or obj:IsA("Texture") then
                        if not TextureKiller.Store[obj] then
                            TextureKiller.Store[obj] = obj.Transparency
                            obj.Transparency = 1
                        end
                    end
                end
            else
                for obj, trans in pairs(TextureKiller.Store) do
                    if obj and obj.Parent then
                        pcall(function() obj.Transparency = trans end)
                    end
                end
                TextureKiller.Store = setmetatable({}, {__mode = "k"})
            end
        end,
    })

    PerfTab:CreateSection("FPS Unlocker")
    local FpsUnlock = {Unlocked = false, Limit = 240}
    PerfTab:CreateSlider({
        Name = "FPS Limit", Range = {30, 500}, Increment = 10, Suffix = "FPS",
        CurrentValue = 240, Flag = "FPSLimit",
        Callback = function(v)
            FpsUnlock.Limit = v
            if FpsUnlock.Unlocked then pcall(function() setfpscap(v) end) end
        end,
    })
    PerfTab:CreateToggle({
        Name = "Unlock FPS", CurrentValue = false, Flag = "FPSUnlock",
        Callback = function(v)
            FpsUnlock.Unlocked = v
            if not setfpscap then notify("FPS", "Not supported by your executor", 3); return end
            if v then
                pcall(function() setfpscap(FpsUnlock.Limit) end)
                notify("FPS", "FPS unlocked to " .. FpsUnlock.Limit, 2)
            else
                pcall(function() setfpscap(60) end)
                notify("FPS", "FPS reset to 60", 2)
            end
        end,
    })
    PerfTab:CreateButton({
        Name = "Unlimited FPS (9999)",
        Callback = function()
            if not setfpscap then notify("FPS", "Not supported by your executor", 3); return end
            pcall(function() setfpscap(9999) end)
            FpsUnlock.Unlocked = true
            notify("FPS", "Unlimited FPS enabled", 2)
        end,
    })

    PerfTab:CreateSection("Low Quality")
    local LowQuality = {Enabled = false, Original = nil, PostEffects = {}}
    PerfTab:CreateToggle({
        Name = "Low Quality Mode (Max FPS)", CurrentValue = false, Flag = "LowGraphics",
        Callback = function(v)
            LowQuality.Enabled = v
            if v then
                pcall(function()
                    LowQuality.Original = settings().Rendering.QualityLevel
                    settings().Rendering.QualityLevel = Enum.QualityLevel.Level01
                end)
                Lighting.GlobalShadows = false
                LowQuality.PostEffects = {}
                for _, effect in ipairs(Lighting:GetChildren()) do
                    if effect:IsA("PostEffect") then
                        LowQuality.PostEffects[effect] = effect.Enabled
                        effect.Enabled = false
                    end
                end
                notify("Graphics", "Low quality mode enabled", 2)
            else
                pcall(function()
                    if LowQuality.Original then
                        settings().Rendering.QualityLevel = LowQuality.Original
                    end
                end)
                Lighting.GlobalShadows = true
                for effect, enabled in pairs(LowQuality.PostEffects) do
                    if effect and effect.Parent then effect.Enabled = enabled end
                end
                LowQuality.PostEffects = {}
                notify("Graphics", "Quality restored", 2)
            end
        end,
    })
end

local ServerTab = Window:CreateTab("Server", 4483362458)

do
    ServerTab:CreateSection("Server")
    ServerTab:CreateButton({
        Name = "Rejoin",
        Callback = function()
            pcall(function()
                TeleportService:TeleportToPlaceInstance(game.PlaceId, game.JobId, LocalPlayer)
            end)
        end,
    })
    ServerTab:CreateButton({
        Name = "Change Server",
        Callback = function()
            pcall(function()
                TeleportService:TeleportAsync(game.PlaceId, {LocalPlayer})
            end)
        end,
    })
    ServerTab:CreateButton({
        Name = "Server Info",
        Callback = function()
            notify("Server Info",
                string.format("PlaceId: %s | JobId: %s | Players: %d",
                    tostring(game.PlaceId), tostring(game.JobId), #Players:GetPlayers()), 5)
        end,
    })
end

task.wait(1)
notify("NEXUS HUB", "Loading complete! (" .. PLATFORM .. ") Press K to open.", 5)