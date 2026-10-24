-- V1PRWARE - Complete Final Version with Error Flashing
print("v1prware loading...")

-- ============================================================
-- ERROR HANDLER - Flashes errors on screen
-- ============================================================
local function flashError(msg)
    local ok, flashErr = pcall(function()
        local player = game:GetService("Players").LocalPlayer
        local gui = player:FindFirstChild("PlayerGui") or player:WaitForChild("PlayerGui", 5)
        if not gui then return end
        
        local errorGui = Instance.new("ScreenGui")
        errorGui.Name = "V1PRWARE_Error"
        errorGui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
        errorGui.Parent = gui
        
        local frame = Instance.new("Frame")
        frame.Size = UDim2.new(0, 500, 0, 100)
        frame.Position = UDim2.new(0.5, -250, 0.5, -50)
        frame.BackgroundColor3 = Color3.fromRGB(30, 0, 0)
        frame.BackgroundTransparency = 0.15
        frame.BorderSizePixel = 3
        frame.BorderColor3 = Color3.fromRGB(255, 50, 50)
        frame.Parent = errorGui
        
        local corner = Instance.new("UICorner")
        corner.CornerRadius = UDim.new(0, 8)
        corner.Parent = frame
        
        local label = Instance.new("TextLabel")
        label.Size = UDim2.new(1, -20, 1, -20)
        label.Position = UDim2.new(0, 10, 0, 10)
        label.Text = "⚠️ V1PRWARE ERROR\n\n" .. tostring(msg):sub(1, 150)
        label.TextColor3 = Color3.fromRGB(255, 200, 200)
        label.TextScaled = true
        label.BackgroundTransparency = 1
        label.TextWrapped = true
        label.TextXAlignment = Enum.TextXAlignment.Left
        label.Font = Enum.Font.GothamBold
        label.Parent = frame
        
        local closeBtn = Instance.new("TextButton")
        closeBtn.Size = UDim2.new(0, 80, 0, 30)
        closeBtn.Position = UDim2.new(1, -90, 1, -40)
        closeBtn.Text = "Dismiss"
        closeBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
        closeBtn.BackgroundColor3 = Color3.fromRGB(60, 60, 60)
        closeBtn.BorderSizePixel = 0
        closeBtn.Font = Enum.Font.GothamBold
        closeBtn.Parent = frame
        
        local closeCorner = Instance.new("UICorner")
        closeCorner.CornerRadius = UDim.new(0, 4)
        closeCorner.Parent = closeBtn
        
        closeBtn.MouseButton1Click:Connect(function()
            errorGui:Destroy()
        end)
        
        task.delay(15, function()
            pcall(function() errorGui:Destroy() end)
        end)
    end)
    if not ok then warn("[v1prware] flashError itself failed: " .. tostring(flashErr)) end
end

local success, err = pcall(function()

local svc = {
    Players        = game:GetService("Players"),
    Run            = game:GetService("RunService"),
    Input          = game:GetService("UserInputService"),
    RS             = game:GetService("ReplicatedStorage"),
    WS             = game:GetService("Workspace"),
    TweenService   = game:GetService("TweenService"),
    TextChat       = game:GetService("TextChatService"),
    Http           = game:GetService("HttpService"),
    SoundService   = game:GetService("SoundService"),
}

local lp  = svc.Players.LocalPlayer
local gui = lp:WaitForChild("PlayerGui", 10)

local fs = {
    hasFolder = isfolder     or function() return false end,
    makeFolder= makefolder   or function() end,
    write     = writefile    or function() end,
    hasFile   = isfile       or function() return false end,
    read      = readfile     or function() return "" end,
    asset     = getcustomasset or function(p) return p end,
}

local WIND_DIR  = "v1prware"
local WIND_FILE = WIND_DIR .. "/WindUI.lua"
local WIND_URL  = "https://github.com/Footagesus/WindUI/releases/latest/download/main.lua"

local function loadWindUI()
    if fs.hasFolder(WIND_DIR) and fs.hasFile(WIND_FILE) then
        local src = fs.read(WIND_FILE)
        if src and #src > 100 then
            local ok, result = pcall(loadstring, src)
            if ok and result then
                local ok2, ui = pcall(result)
                if ok2 and ui then
                    print("[v1prware] WindUI loaded from cache")
                    return ui
                end
            end
        end
    end
    
    print("[v1prware] Downloading WindUI...")
    local success, src = pcall(game.HttpGet, game, WIND_URL)
    if success and src and #src > 100 then
        pcall(function()
            if not fs.hasFolder(WIND_DIR) then fs.makeFolder(WIND_DIR) end
            fs.write(WIND_FILE, src)
        end)
        
        local ok, result = pcall(loadstring, src)
        if ok and result then
            local ok2, ui = pcall(result)
            if ok2 and ui then
                print("[v1prware] WindUI downloaded and loaded")
                return ui
            end
        end
    end
    
    print("[v1prware] Trying alternative WindUI URL...")
    local altURL = "https://raw.githubusercontent.com/Footagesus/WindUI/main/main.lua"
    local success2, src2 = pcall(game.HttpGet, game, altURL)
    if success2 and src2 and #src2 > 100 then
        local ok, result = pcall(loadstring, src2)
        if ok and result then
            local ok2, ui = pcall(result)
            if ok2 and ui then
                print("[v1prware] WindUI loaded from alternative URL")
                return ui
            end
        end
    end
    
    error("Failed to load WindUI from all sources")
    return nil
end

local ui = loadWindUI()

if not ui then
    error("WindUI is nil - cannot create window")
end

local win
pcall(function()
    win = ui:CreateWindow({
        Title          = "V1PRWARE",
        Icon           = "sparkles",
        Author         = "V1pr & Mitsuki",
        Folder         = "v1prware",
        Size           = UDim2.fromOffset(350, 480),
        Transparent    = false,
        Theme          = "Dark",
        Resizable      = false,
        SideBarWidth   = 150,
        HideSearchBar  = true,
        ScrollBarEnabled = false,
    })
end)

if not win then
    error("Failed to create window - WindUI may be incompatible")
end

local ConfigManager = win.ConfigManager
local v1prConfig = ConfigManager:CreateConfig("v1prware")

win:SetToggleKey(Enum.KeyCode.L)
pcall(function() ui:SetFont("rbxasset://fonts/families/AccanthisADFStd.json") end)

pcall(function()
    win:EditOpenButton({
        Title          = "V1PRWARE",
        Icon           = "sparkles",
        CornerRadius   = UDim.new(0, 16),
        StrokeThickness = 0,
        Color = ColorSequence.new(Color3.fromHex("000000"), Color3.fromHex("000000")),
        OnlyMobile = false,
        Enabled    = true,
        Draggable  = true,
    })
end)

-- ============================================================
-- UTILITY FUNCTIONS
-- ============================================================

local function getTeamFolder(name)
    local root = svc.WS:FindFirstChild("Players")
    return root and root:FindFirstChild(name)
end

local function getIngame()
    local m = svc.WS:FindFirstChild("Map")
    return m and m:FindFirstChild("Ingame")
end

local function getMapContent()
    local ig = getIngame()
    return ig and ig:FindFirstChild("Map")
end

local _networkModule = nil
local function getNetwork()
    if _networkModule then return _networkModule end
    local ok, m = pcall(function() return require(svc.RS.Modules.Network.Network) end)
    if ok and m then _networkModule = m end
    return _networkModule
end

local _hbRemote = nil
local function hbGetRemote()
    if _hbRemote and _hbRemote.Parent then return _hbRemote end
    local ok, re = pcall(function()
        return svc.RS.Modules.Network.Network:FindFirstChild("RemoteEvent")
    end)
    if ok and re then _hbRemote = re; return re end
    return nil
end

-- ============================================================
-- SETTINGS TAB
-- ============================================================

do -- tabSettings
local tabSettings = win:Tab({ Title = "Setting", Icon = "settings" })
local secInterface = tabSettings:Section({ Title = "Interface", Opened = true })

-- Spoof Usernames
local spoofActive = false
local spoofText   = "V1PRWARE"
local spoofCache  = {}
local spoofConns  = {}

local function spoofApply(lbl)
    pcall(function()
        if not (lbl:IsA("TextLabel") or lbl:IsA("TextButton")) then return end
        if lbl.Name ~= "Username" then return end
        if not spoofCache[lbl] then spoofCache[lbl] = lbl.Text end
        if spoofActive then lbl.Text = spoofText end
    end)
end

local function spoofRevert()
    pcall(function()
        for lbl, orig in pairs(spoofCache) do if lbl and lbl.Parent then lbl.Text = orig end end
        spoofCache = {}
    end)
end

local function spoofScan()
    pcall(function()
        local pg = lp:FindFirstChild("PlayerGui"); if not pg then return end
        task.defer(function()
            for _, root in ipairs({ pg:FindFirstChild("MainUI"), pg:FindFirstChild("TemporaryUI") }) do
                if root then for _, obj in ipairs(root:GetDescendants()) do spoofApply(obj) end end
            end
        end)
    end)
end

local function spoofWatch(root)
    pcall(function()
        if not root then return end
        table.insert(spoofConns, root.DescendantAdded:Connect(function(obj)
            if spoofActive then task.defer(spoofApply, obj) end
        end))
    end)
end

local function spoofStart()
    pcall(function()
        for _, c in ipairs(spoofConns) do if c.Connected then c:Disconnect() end end
        spoofConns = {}
        local pg = lp:FindFirstChild("PlayerGui"); if not pg then return end
        spoofScan()
        spoofWatch(pg:FindFirstChild("MainUI"))
        spoofWatch(pg:FindFirstChild("TemporaryUI"))
        table.insert(spoofConns, pg.ChildAdded:Connect(function(child)
            if (child.Name == "MainUI" or child.Name == "TemporaryUI") and spoofActive then
                task.delay(0.1, spoofScan); spoofWatch(child)
            end
        end))
    end)
end

local function spoofStop()
    pcall(function()
        for _, c in ipairs(spoofConns) do if c.Connected then c:Disconnect() end end
        spoofConns = {}; spoofRevert()
    end)
end

secInterface:Toggle({
    Title = "Spoof Usernames", Type = "Checkbox", Flag = "spoofActive", Default = spoofActive,
    Callback = function(on) pcall(function() spoofActive = on; if on then spoofStart() else spoofStop() end end) end
})

-- Show Chat Logs
local chatForceEnabled = false
local chatForceConn    = nil

local function enforceChatOn()
    pcall(function()
        if not chatForceEnabled then return end
        local cw = svc.TextChat:FindFirstChild("ChatWindowConfiguration")
        local ci = svc.TextChat:FindFirstChild("ChatInputBarConfiguration")
        if cw and not cw.Enabled then cw.Enabled = true end
        if ci and not ci.Enabled then ci.Enabled = true end
    end)
end

secInterface:Toggle({
    Title = "Show Chat Logs", Type = "Checkbox", Flag = "chatForceEnabled", Default = chatForceEnabled,
    Callback = function(on)
        pcall(function()
            chatForceEnabled = on; 
            if chatForceConn then chatForceConn:Disconnect(); chatForceConn = nil end
            if on then
                enforceChatOn()
                chatForceConn = svc.Run.Heartbeat:Connect(enforceChatOn)
                for _, key in ipairs({ "ChatWindowConfiguration", "ChatInputBarConfiguration" }) do
                    local obj = svc.TextChat:FindFirstChild(key)
                    if obj then obj:GetPropertyChangedSignal("Enabled"):Connect(enforceChatOn) end
                end
            end
        end)
    end
})

-- Timer Position
local timerSide = "Middle"

local function applyTimerPos()
    pcall(function()
        local rt = lp.PlayerGui:FindFirstChild("RoundTimer")
        local m  = rt and rt:FindFirstChild("Main")
        if m then m.Position = UDim2.new(timerSide == "Middle" and 0.5 or 0.9, 0, m.Position.Y.Scale, m.Position.Y.Offset) end
    end)
end

applyTimerPos()

secInterface:Dropdown({
    Title = "Timer Position", Flag = "timerSide", Values = { "Middle", "Right" }, Value = timerSide,
    Callback = function(v) pcall(function() timerSide = v; applyTimerPos() end) end
})

lp.CharacterAdded:Connect(function()
    task.delay(1, function() pcall(function() if spoofActive then spoofStart() end; applyTimerPos() end) end)
end)

-- Platform Spoofer
local secPlatform = tabSettings:Section({ Title = "Platform Spoofer", Opened = true })
local platEnabled = false
local platDevice  = "Console"
local platLoop    = nil
local platConn    = nil

local function platPush()
    pcall(function()
        if not platEnabled then return end
        local net = getNetwork()
        if net then pcall(function() net:FireServerConnection("SetDevice", "REMOTE_EVENT", platDevice) end) end
    end)
end

local function platStart()
    pcall(function()
        if platLoop then return end; platPush()
        if platConn then platConn:Disconnect() end
        platConn = svc.Input.LastInputTypeChanged:Connect(function() if platEnabled then platPush() end end)
        platLoop = task.spawn(function() while platEnabled do platPush(); task.wait(1) end; platLoop = nil end)
    end)
end

local function platStop()
    pcall(function()
        platEnabled = false
        if platLoop then task.cancel(platLoop); platLoop = nil end
        if platConn then platConn:Disconnect(); platConn = nil end
    end)
end

secPlatform:Toggle({ Title = "Enable Spoofer", Type = "Checkbox", Flag = "platEnabled", Default = platEnabled,
    Callback = function(on) pcall(function() platEnabled = on; if on then platStart() else platStop() end end) end })

secPlatform:Dropdown({ Title = "Device", Flag = "platDevice", Values = { "PC", "Mobile", "Console" }, Value = platDevice,
    Callback = function(v) pcall(function() platDevice = v; if platEnabled then platPush() end end) end })

lp.CharacterAdded:Connect(function() task.delay(1, function() pcall(function() if platEnabled then platPush() end end) end) end)

-- ============================================================
-- EMOTES  (Settings Tab)
-- ============================================================
local secEmotes = tabSettings:Section({ Title = "Emotes", Opened = true })

do
    local EmFolderPath = svc.RS:FindFirstChild("Assets") and svc.RS.Assets:FindFirstChild("Emotes")

    local emState = {
        emoting = false, track = nil,
        spd = 16, jump = 50,
        rotConn = nil, guiOn = false, sg = nil,
    }

    local function emStop()
        if not emState.emoting then return end
        emState.emoting = false
        if emState.rotConn then emState.rotConn:Disconnect(); emState.rotConn = nil end
        local ch = lp.Character
        if ch then
            local root = ch:FindFirstChild("HumanoidRootPart") or ch.PrimaryPart
            local hum  = ch:FindFirstChildOfClass("Humanoid")
            local vfx  = ch:FindFirstChild("PlayerEmoteVFX"); if vfx then vfx:Destroy() end
            if root then
                root.Anchored = false
                local snd = root:FindFirstChild("EmoteSound"); if snd then snd:Destroy() end
                local att = root:FindFirstChild("RootAttachment"); if att then att:Destroy() end
            end
            if hum then hum.WalkSpeed = emState.spd; hum.JumpPower = emState.jump end
        end
        if emState.track then pcall(function() emState.track:Stop() end); emState.track = nil end
    end

    local function emPlay(mod)
        if emState.emoting then emStop(); task.wait(0.1) end
        local ch   = lp.Character; if not ch then return end
        local hum  = ch:FindFirstChildOfClass("Humanoid")
        local root = ch:FindFirstChild("HumanoidRootPart") or ch.PrimaryPart
        local anim = hum and hum:WaitForChild("Animator", 2)
        if not hum or not root or not anim then return end
        local ok, data = pcall(require, mod)
        if not ok or not data.AssetID then return end
        emState.emoting = true
        emState.spd = hum.WalkSpeed; emState.jump = hum.JumpPower
        hum.WalkSpeed = 0; hum.JumpPower = 0; root.Anchored = true
        local an = Instance.new("Animation"); an.AnimationId = tostring(data.AssetID)
        emState.track = anim:LoadAnimation(an); emState.track.Looped = true; emState.track:Play()
        -- Shiftlock camera follow
        if emState.rotConn then emState.rotConn:Disconnect() end
        emState.rotConn = svc.Run.RenderStepped:Connect(function()
            if not emState.emoting then return end
            -- Only rotate to match camera when shiftlock is on
            local cam = workspace.CurrentCamera; if not cam then return end
            if cam.CameraType ~= Enum.CameraType.Custom then return end
            local ch2 = lp.Character; if not ch2 then return end
            local r2  = ch2:FindFirstChild("HumanoidRootPart"); if not r2 then return end
            -- CameraMode LockFirstPerson = shiftlock
            if lp.CameraMode ~= Enum.CameraMode.LockFirstPerson then return end
            local _, camY, _ = cam.CFrame:ToEulerAnglesYXZ()
            r2.CFrame = CFrame.new(r2.Position) * CFrame.Angles(0, camY, 0)
        end)
        -- Sound on HumanoidRootPart only
        if data.SFX then
            local old2 = root:FindFirstChild("EmoteSound"); if old2 then old2:Destroy() end
            local snd = Instance.new("Sound"); snd.Name = "EmoteSound"
            snd.SoundId = tostring(data.SFX); snd.Volume = 1; snd.Looped = true
            snd.RollOffMode = Enum.RollOffMode.Inverse
            snd.RollOffMaxDistance = 60; snd.RollOffMinDistance = 10
            snd.Parent = root; snd:Play()
        end
        -- Particle effect
        local att = Instance.new("Attachment"); att.Name = "RootAttachment"; att.Parent = root
        local burst = Instance.new("ParticleEmitter"); burst.Name = "EmoteBurst"
        burst.Texture = "rbxassetid://635533604"; burst.Rate = 60
        burst.Speed = NumberRange.new(2,5); burst.Lifetime = NumberRange.new(0.5,1.2)
        burst.Drag = 5; burst.Parent = att
        -- Hakari VFX
        if string.lower(mod.Name) == "hakaridance" or string.lower(mod.Name) == "hakari" then
            local beamVFX = mod:FindFirstChild("HakariBeamEffect")
            if beamVFX then
                local v3 = beamVFX:Clone(); v3.Name = "PlayerEmoteVFX"
                v3.CFrame = root.CFrame * CFrame.new(0,-1,-0.3)
                local weld = Instance.new("WeldConstraint")
                weld.Part0 = root; weld.Part1 = v3; weld.Parent = v3; v3.Parent = ch
            end
        end
        local remote = svc.RS:FindFirstChild("EmoteHandler") or svc.RS:FindFirstChild("PlayEmote") or svc.RS:FindFirstChild("Emote")
        if remote and remote:IsA("RemoteEvent") then pcall(function() remote:FireServer("PlayEmote", mod.Name) end) end
    end

    local function buildEmoteGui()
        if emState.sg and emState.sg.Parent then return end
        local PGui2 = lp:WaitForChild("PlayerGui")
        local old3 = PGui2:FindFirstChild("V1PR_EmoteGUI"); if old3 then old3:Destroy() end
        local SG2 = Instance.new("ScreenGui"); SG2.Name = "V1PR_EmoteGUI"
        SG2.ResetOnSpawn = false; SG2.IgnoreGuiInset = true
        SG2.ZIndexBehavior = Enum.ZIndexBehavior.Sibling; SG2.Parent = PGui2
        emState.sg = SG2
        local function rnd2(i,r) local c=Instance.new("UICorner"); c.CornerRadius=UDim.new(0,r or 8); c.Parent=i end
        local function tw2(o,t,p) svc.TS:Create(o,TweenInfo.new(t,Enum.EasingStyle.Quad,Enum.EasingDirection.Out),p):Play() end
        -- Toggle button (draggable)
        local Tog2=Instance.new("TextButton"); Tog2.Size=UDim2.new(0,50,0,50); Tog2.Position=UDim2.new(1,-70,1,-70)
        Tog2.Text="🎵"; Tog2.TextSize=24; Tog2.BackgroundColor3=Color3.fromRGB(30,30,40)
        Tog2.AutoButtonColor=false; Tog2.BorderSizePixel=0; Tog2.ZIndex=20; Tog2.Parent=SG2; rnd2(Tog2,25)
        -- Drag state for the button itself
        local togDragging=false; local togDragStart; local togStartPos; local togMoved=false
        Tog2.InputBegan:Connect(function(inp)
            if inp.UserInputType==Enum.UserInputType.MouseButton1 or inp.UserInputType==Enum.UserInputType.Touch then
                togDragging=true; togMoved=false
                togDragStart=inp.Position; togStartPos=Tog2.Position
                inp.Changed:Connect(function()
                    if inp.UserInputState==Enum.UserInputState.End then togDragging=false end
                end)
            end
        end)
        svc.Input.InputChanged:Connect(function(inp)
            if togDragging and (inp.UserInputType==Enum.UserInputType.MouseMovement or inp.UserInputType==Enum.UserInputType.Touch) then
                local d=inp.Position-togDragStart
                if d.Magnitude > 4 then togMoved=true end
                Tog2.Position=UDim2.new(togStartPos.X.Scale,togStartPos.X.Offset+d.X,togStartPos.Y.Scale,togStartPos.Y.Offset+d.Y)
            end
        end)
        -- Panel
        local PW,PH=220,340
        local Panel2=Instance.new("Frame"); Panel2.Size=UDim2.new(0,PW,0,PH)
        Panel2.Position=UDim2.new(0.5,-PW/2,0.5,-PH/2); Panel2.BackgroundColor3=Color3.fromRGB(16,16,22)
        Panel2.BorderSizePixel=0; Panel2.ClipsDescendants=true; Panel2.Visible=false; Panel2.ZIndex=15; Panel2.Parent=SG2; rnd2(Panel2,10)
        -- Draggable
        local drag2,dInp2,dSt2,sSt2
        Panel2.InputBegan:Connect(function(inp)
            if inp.UserInputType==Enum.UserInputType.MouseButton1 or inp.UserInputType==Enum.UserInputType.Touch then
                drag2=true; dSt2=inp.Position; sSt2=Panel2.Position
                inp.Changed:Connect(function() if inp.UserInputState==Enum.UserInputState.End then drag2=false end end)
            end
        end)
        svc.Input.InputChanged:Connect(function(inp)
            if inp.UserInputType==Enum.UserInputType.MouseMovement or inp.UserInputType==Enum.UserInputType.Touch then dInp2=inp end
        end)
        svc.Input.InputChanged:Connect(function(inp)
            if inp==dInp2 and drag2 then
                local d=inp.Position-dSt2
                Panel2.Position=UDim2.new(sSt2.X.Scale,sSt2.X.Offset+d.X,sSt2.Y.Scale,sSt2.Y.Offset+d.Y)
            end
        end)
        -- Accent, header
        local Ac2=Instance.new("Frame"); Ac2.Size=UDim2.new(1,0,0,2); Ac2.BackgroundColor3=Color3.fromRGB(80,140,255); Ac2.BorderSizePixel=0; Ac2.Parent=Panel2
        local Hdr2=Instance.new("Frame"); Hdr2.Size=UDim2.new(1,0,0,34); Hdr2.Position=UDim2.new(0,0,0,2); Hdr2.BackgroundTransparency=1; Hdr2.Parent=Panel2
        local HTit2=Instance.new("TextLabel"); HTit2.Size=UDim2.new(1,-36,1,0); HTit2.Position=UDim2.new(0,10,0,0)
        HTit2.Text="Emotes"; HTit2.TextSize=14; HTit2.Font=Enum.Font.GothamBold
        HTit2.TextColor3=Color3.fromRGB(220,220,235); HTit2.BackgroundTransparency=1
        HTit2.TextXAlignment=Enum.TextXAlignment.Left; HTit2.Parent=Hdr2
        local CX2=Instance.new("TextButton"); CX2.Size=UDim2.new(0,26,0,26); CX2.Position=UDim2.new(1,-30,0,4)
        CX2.Text="✕"; CX2.TextSize=12; CX2.Font=Enum.Font.GothamBold
        CX2.TextColor3=Color3.fromRGB(140,140,160); CX2.BackgroundColor3=Color3.fromRGB(30,30,42)
        CX2.AutoButtonColor=false; CX2.BorderSizePixel=0; CX2.Parent=Hdr2; rnd2(CX2,6)
        -- Search
        local Srch2=Instance.new("TextBox"); Srch2.Size=UDim2.new(1,-12,0,28); Srch2.Position=UDim2.new(0,6,0,38)
        Srch2.PlaceholderText="Search..."; Srch2.Text=""
        Srch2.TextColor3=Color3.fromRGB(210,210,225); Srch2.PlaceholderColor3=Color3.fromRGB(90,90,110)
        Srch2.TextSize=12; Srch2.Font=Enum.Font.Gotham; Srch2.BackgroundColor3=Color3.fromRGB(24,24,34)
        Srch2.BorderSizePixel=0; Srch2.ClearTextOnFocus=false; Srch2.Parent=Panel2; rnd2(Srch2,6)
        do local p=Instance.new("UIPadding"); p.PaddingLeft=UDim.new(0,8); p.PaddingRight=UDim.new(0,8); p.Parent=Srch2 end
        -- Scroll
        local Scrl2=Instance.new("ScrollingFrame"); Scrl2.Size=UDim2.new(1,-8,1,-106); Scrl2.Position=UDim2.new(0,4,0,72)
        Scrl2.BackgroundTransparency=1; Scrl2.BorderSizePixel=0; Scrl2.CanvasSize=UDim2.new(0,0,0,0)
        Scrl2.ScrollBarThickness=3; Scrl2.ScrollBarImageColor3=Color3.fromRGB(80,140,255)
        Scrl2.ScrollBarImageTransparency=0.5; Scrl2.ScrollingDirection=Enum.ScrollingDirection.Y; Scrl2.Parent=Panel2
        local LL3=Instance.new("UIListLayout"); LL3.SortOrder=Enum.SortOrder.LayoutOrder; LL3.Padding=UDim.new(0,2); LL3.Parent=Scrl2
        LL3:GetPropertyChangedSignal("AbsoluteContentSize"):Connect(function()
            Scrl2.CanvasSize=UDim2.new(0,0,0,LL3.AbsoluteContentSize.Y+6)
        end)
        -- Stop btn
        local Dv2=Instance.new("Frame"); Dv2.Size=UDim2.new(1,0,0,1); Dv2.Position=UDim2.new(0,0,1,-37)
        Dv2.BackgroundColor3=Color3.fromRGB(36,36,50); Dv2.BorderSizePixel=0; Dv2.Parent=Panel2
        local Stp2=Instance.new("TextButton"); Stp2.Size=UDim2.new(1,0,0,36); Stp2.Position=UDim2.new(0,0,1,-36)
        Stp2.Text="■  Stop Emote"; Stp2.TextSize=12; Stp2.Font=Enum.Font.GothamBold
        Stp2.TextColor3=Color3.fromRGB(255,100,100); Stp2.BackgroundColor3=Color3.fromRGB(22,14,14)
        Stp2.AutoButtonColor=false; Stp2.BorderSizePixel=0; Stp2.Parent=Panel2
        Stp2.MouseEnter:Connect(function() tw2(Stp2,0.1,{BackgroundColor3=Color3.fromRGB(40,16,16)}) end)
        Stp2.MouseLeave:Connect(function() tw2(Stp2,0.1,{BackgroundColor3=Color3.fromRGB(22,14,14)}) end)
        Stp2.MouseButton1Click:Connect(function() emStop() end)
        -- Rows
        local rows2={}
        local function refreshList2(q)
            for _,r in ipairs(rows2) do pcall(function() r:Destroy() end) end; rows2={}
            q=q and string.lower(q) or ""
            if not EmFolderPath then return end
            local emotes={}
            for _,v in ipairs(EmFolderPath:GetDescendants()) do if v:IsA("ModuleScript") then table.insert(emotes,v) end end
            table.sort(emotes,function(a,b) return a.Name<b.Name end)
            local n=0
            for _,ch in ipairs(emotes) do
                if q=="" or string.find(string.lower(ch.Name),q,1,true) then
                    n+=1
                    local row=Instance.new("TextButton"); row.Size=UDim2.new(1,0,0,28)
                    row.Text=ch.Name; row.TextColor3=Color3.fromRGB(200,200,215)
                    row.TextSize=11; row.Font=Enum.Font.Gotham; row.TextXAlignment=Enum.TextXAlignment.Left
                    row.BackgroundColor3=Color3.fromRGB(22,22,32); row.BackgroundTransparency=0
                    row.AutoButtonColor=false; row.BorderSizePixel=0; row.LayoutOrder=n; row.Parent=Scrl2; rnd2(row,4)
                    do local p=Instance.new("UIPadding"); p.PaddingLeft=UDim.new(0,8); p.Parent=row end
                    row.MouseEnter:Connect(function()     tw2(row,0.08,{BackgroundColor3=Color3.fromRGB(38,38,56)}) end)
                    row.MouseLeave:Connect(function()     tw2(row,0.08,{BackgroundColor3=Color3.fromRGB(22,22,32)}) end)
                    row.MouseButton1Down:Connect(function() tw2(row,0.05,{BackgroundColor3=Color3.fromRGB(50,80,160)}) end)
                    row.MouseButton1Click:Connect(function() emPlay(ch) end)
                    table.insert(rows2,row)
                end
            end
            if n==0 then
                local e=Instance.new("TextLabel"); e.Size=UDim2.new(1,0,0,28); e.Text="None found"
                e.TextColor3=Color3.fromRGB(90,90,110); e.TextSize=11; e.Font=Enum.Font.Gotham
                e.BackgroundTransparency=1; e.TextXAlignment=Enum.TextXAlignment.Center; e.Parent=Scrl2
                table.insert(rows2,e)
            end
        end
        Srch2:GetPropertyChangedSignal("Text"):Connect(function() refreshList2(Srch2.Text) end)
        -- Open/close
        local pOpen2=false
        local function setPanel2(open)
            pOpen2=open; Tog2.Text=open and "✕" or "🎵"; Panel2.Visible=open
            if open then refreshList2(Srch2.Text) end
        end
        Tog2.MouseButton1Click:Connect(function() if not togMoved then setPanel2(not pOpen2) end; togMoved=false end)
        CX2.MouseButton1Click:Connect(function() setPanel2(false) end)
    end

    local function destroyEmoteGui()
        emStop()
        if emState.sg then emState.sg:Destroy(); emState.sg=nil end
    end

    secEmotes:Toggle({
        Title="Show Emotes GUI", Type="Checkbox", Flag="emoteGuiOn", Default=false,
        Callback=function(on) pcall(function()
            emState.guiOn=on
            if on then buildEmoteGui() else destroyEmoteGui() end
        end) end
    })

    lp.CharacterAdded:Connect(function() task.wait(0.5); if emState.emoting then emStop() end end)
    lp.CharacterRemoving:Connect(function() if emState.emoting then emStop() end end)
end


-- ============================================================
-- GLOBAL TAB
-- ============================================================

end -- tabSettings
do -- tabGlobal
local tabGlobal  = win:Tab({ Title = "Global", Icon = "globe" })

-- Stamina
local secStamina = tabGlobal:Section({ Title = "Stamina", Opened = true })

local stam = {
    on      = false,
    loss    = 10,
    gain    = 20,
    max     = 100,
    current = 100,
    noLoss  = false,
    thread  = nil,
}

local function stamModule()
    local ok, m = pcall(function() return require(svc.RS.Systems.Character.Game.Sprinting) end)
    return ok and m or nil
end

local function stamIsKiller()
    local ch = lp.Character; if not ch then return false end
    local kf = getTeamFolder("Killers")
    return kf and ch:IsDescendantOf(kf)
end

local function stamApply()
    pcall(function()
        local m = stamModule(); if not m then return end
        if not m.DefaultsSet then pcall(function() m.Init() end) end
        local forceNoLoss = stam.noLoss or stamIsKiller()
        m.StaminaLoss = stam.loss; m.StaminaGain = stam.gain
        local abilityCapActive = type(m.StaminaCap) == "number" and m.StaminaCap < (m.MaxStamina or math.huge)
        if not abilityCapActive then
            m.MaxStamina = stam.max
            if type(m.StaminaCap) == "number" then m.StaminaCap = stam.max end
        end
        m.StaminaLossDisabled = forceNoLoss
        if m.Stamina and m.Stamina > stam.max then m.Stamina = stam.current end
        pcall(function() if m.__staminaChangedEvent then m.__staminaChangedEvent:Fire() end end)
    end)
end

local function stamStart()
    if stam.thread then return end
    stam.thread = task.spawn(function()
        while stam.on do
            pcall(function()
                if lp.Character and lp.Character:FindFirstChild("HumanoidRootPart") then stamApply() end
            end)
            task.wait(0.5)
        end; stam.thread = nil
    end)
end

local function stamStop()
    stam.on = false
    if stam.thread then task.cancel(stam.thread); stam.thread = nil end
end

secStamina:Toggle({ Title = "Custom Stamina", Type = "Checkbox", Flag = "stamOn", Default = stam.on,
    Callback = function(on) pcall(function() stam.on = on; if on then stamStart() else stamStop() end end) end })

secStamina:Slider({ Title = "Loss Rate",     Flag = "stamLoss", Step = 1, Value = { Min = 0,  Max = 50,  Default = stam.loss    }, Callback = function(v) pcall(function() stam.loss = v end) end })
secStamina:Slider({ Title = "Gain Rate",     Flag = "stamGain", Step = 1, Value = { Min = 0,  Max = 50,  Default = stam.gain    }, Callback = function(v) pcall(function() stam.gain = v end) end })
secStamina:Slider({ Title = "Max Pool",      Flag = "stamMax", Step = 1, Value = { Min = 50, Max = 500, Default = stam.max     }, Callback = function(v) pcall(function() stam.max = v end) end })
secStamina:Slider({ Title = "Current Value", Flag = "stamCurrent", Step = 1, Value = { Min = 0,  Max = 500, Default = stam.current }, Callback = function(v) pcall(function() stam.current = v end) end })
secStamina:Toggle({ Title = "Infinite Stamina", Type = "Checkbox", Flag = "stamNoLoss", Default = stam.noLoss,
    Callback = function(on)
        pcall(function()
            stam.noLoss = on; stamApply()
            if on and not stam.on then stam.on = true; stamStart() end
        end)
    end
})

if stam.on then stamStart() end

lp.CharacterAdded:Connect(function()
    task.delay(1.5, function()
        pcall(function()
            if stam.on then stamApply(); if not stam.thread then stamStart() end end
        end)
    end)
end)

-- Speed Hack
local secSpeed = tabGlobal:Section({ Title = "Speed Hack", Opened = true })
local speedHack = { on=false, speed=30, thread=nil, lastApplied=0 }

local function speedModule()
    local ok, m = pcall(function() return require(svc.RS.Systems.Character.Game.Sprinting) end)
    return ok and m or nil
end

local function speedApply()
    pcall(function()
        if not speedHack.on then return end
        local m = speedModule(); if not m then return end
        if not m.DefaultsSet then pcall(function() m.Init() end) end
        if speedHack.speed ~= speedHack.lastApplied then
            m.SprintSpeed = speedHack.speed; pcall(function() m.MaxSprintSpeed = speedHack.speed end)
            speedHack.lastApplied = speedHack.speed
        end
    end)
end

local function speedStart()
    if speedHack.thread then return end
    speedHack.thread = task.spawn(function()
        while speedHack.on do
            pcall(function()
                if lp.Character and lp.Character:FindFirstChild("HumanoidRootPart") then speedApply() end
            end)
            task.wait(0.2)
        end; speedHack.thread = nil
    end)
end

local function speedStop()
    speedHack.on = false
    if speedHack.thread then task.cancel(speedHack.thread); speedHack.thread = nil end
    pcall(function()
        local m = speedModule(); if m then m.SprintSpeed = 26; pcall(function() m.MaxSprintSpeed = 26 end) end
    end)
end

lp.CharacterAdded:Connect(function()
    task.delay(1, function() pcall(function() speedHack.lastApplied=0; if speedHack.on then speedApply(); if not speedHack.thread then speedStart() end end end) end)
end)

if speedHack.on then speedStart() end

secSpeed:Toggle({ Title="Custom Sprint Speed", Type="Checkbox", Flag="speedOn", Default=speedHack.on,
    Callback=function(on) pcall(function() speedHack.on=on; speedHack.lastApplied=0; if on then speedStart() else speedStop() end end) end })

secSpeed:Input({ Title="Sprint Speed Value", Flag="speedValue", CurrentValue=tostring(speedHack.speed), Placeholder="e.g. 30",
    Callback=function(t) pcall(function() local n=tonumber(t); if n and n>0 and n<=200 then speedHack.speed=n; speedHack.lastApplied=0 end end) end })

-- Status Effects
local secStatus = tabGlobal:Section({ Title = "Status", Opened = true })

local statusGroups = {
    Slowness      = { on = false, paths = { "Modules.Schematics.StatusEffects.Slowness" } },
    Hallucination = { on = false, paths = { "Modules.Schematics.StatusEffects.KillerExclusive.Hallucination" } },
    Visual        = { on = false, paths = {
        "Modules.Schematics.StatusEffects.Blindness",
        "Modules.Schematics.StatusEffects.SurvivorExclusive.Subspaced",
        "Modules.Schematics.StatusEffects.KillerExclusive.Glitched",
    }},
}

local statusBackup = {}

local function statusResolve(path)
    local node = svc.RS
    for seg in path:gmatch("[^%.]+") do node = node:FindFirstChild(seg); if not node then return nil end end
    return node
end

local function statusBlock(path)
    pcall(function()
        if statusBackup[path] then return end
        local mod = statusResolve(path); if not mod then return end
        if mod:IsA("Folder") then
            statusBackup[path] = { clone = mod:Clone(), isFolder = true, parentPath = path:match("^(.-)%.?[^%.]+$") }
            mod:Destroy()
        elseif mod:IsA("ModuleScript") or mod:IsA("LocalScript") then
            statusBackup[path] = { clone = mod:Clone(), src = mod.Source, isFolder = false }
            mod:Destroy()
        end
    end)
end

local function statusRestore(path)
    pcall(function()
        local saved = statusBackup[path]; if not saved then return end
        local existing = statusResolve(path); if existing then existing:Destroy() end
        local parentPath = saved.parentPath or path:match("^(.-)%.?[^%.]+$")
        local parent = statusResolve(parentPath)
        if parent then
            if not saved.isFolder then saved.clone.Source = saved.src end
            saved.clone.Parent = parent
        end
        statusBackup[path] = nil
    end)
end

local statusLoopThread = nil

local function statusTick()
    if statusLoopThread then return end
    statusLoopThread = task.spawn(function()
        while true do
            local any = false
            for _, g in pairs(statusGroups) do
                if g.on then any = true; for _, p in ipairs(g.paths) do local m = statusResolve(p); if m then m:Destroy() end end end
            end
            if not any then break end; task.wait(0.8)
        end; statusLoopThread = nil
    end)
end

local function statusToggle(name)
    pcall(function()
        local g = statusGroups[name]; if not g then return end; g.on = not g.on
        for _, p in ipairs(g.paths) do if g.on then statusBlock(p) else statusRestore(p) end end
        local any = false; for _, sg in pairs(statusGroups) do if sg.on then any = true; break end end
        if any then statusTick() elseif statusLoopThread then task.cancel(statusLoopThread); statusLoopThread = nil end
    end)
end

secStatus:Button({ Title = "Toggle: Slowness",       Callback = function() statusToggle("Slowness")      end })
secStatus:Button({ Title = "Toggle: Hallucination",  Callback = function() statusToggle("Hallucination") end })
secStatus:Button({ Title = "Toggle: Visual Effects", Callback = function() statusToggle("Visual")        end })

lp.CharacterAdded:Connect(function()
    pcall(function()
        statusBackup = {}; for _, g in pairs(statusGroups) do g.on = false end
        if statusLoopThread then task.cancel(statusLoopThread); statusLoopThread = nil end
    end)
end)

-- Hitbox Expander
local secHitbox = tabGlobal:Section({ Title = "Hitbox", Opened = true })
local hb = { on = false, strength = 50, conn = nil, active = {} }

local hbAbilities = {
    Slash=1,Swing=1,Dagger=1,Punch=1,PlasmaBeam=1,Shoot=1,Behead=1,
    GashingWound=1,WalkspeedOverride=1,Stab=1,Nova=1,MassInfection=1,
    Axe=1,["INFERNALCRY"]=1,["Carving Slash"]=1,Carving=1,
}

local function hbReadName(raw)
    if typeof(raw) == "buffer" then
        local s = buffer.tostring(raw)
        local name = s:match("^[%c%z%p]*(.+)$") or s
        name = name:match("^(.-)%s*$") or name
        return name ~= "" and name or nil
    end
    return tostring(raw):gsub("\"","")
end

local function hbPush(dist)
    pcall(function()
        local ch = lp.Character; if not ch then return end
        local r  = ch:FindFirstChild("HumanoidRootPart"); if not r then return end
        local was = r.AssemblyLinearVelocity
        r.AssemblyLinearVelocity = was + r.CFrame.LookVector * dist
        svc.Run.RenderStepped:Wait()
        if ch and ch.Parent and r and r.Parent then r.AssemblyLinearVelocity = was end
    end)
end

local function hbStart()
    pcall(function()
        if hb.conn then return end
        local remote = hbGetRemote()
        if not remote then warn("[v1prware] hbStart: could not find RemoteEvent for hitbox — feature disabled"); return end
        hb.conn = remote.OnClientEvent:Connect(function(action, data)
            if not hb.on or action ~= "UseActorAbility" then return end
            if typeof(data) ~= "table" or not data[1] then return end
            local name = hbReadName(data[1])
            if not name or not hbAbilities[name] or hb.active[name] then return end
            hb.active[name] = true; local t0 = tick()
            local c; c = svc.Run.Heartbeat:Connect(function()
                if tick() - t0 >= 1 then c:Disconnect(); hb.active[name] = nil; return end
                if hb.on then hbPush(hb.strength) else c:Disconnect(); hb.active[name] = nil end
            end)
        end)
    end)
end

local function hbStop()
    pcall(function()
        if hb.conn then hb.conn:Disconnect(); hb.conn = nil end
        for k in pairs(hb.active) do hb.active[k] = nil end
    end)
end

secHitbox:Toggle({ Title = "Hitbox Expander", Type = "Checkbox", Flag = "hbOn", Default = hb.on,
    Callback = function(on) pcall(function() hb.on = on; if on then hbStart() else hbStop() end end) end })

secHitbox:Slider({ Title = "Strength", Flag = "hbStrength", Step = 1, Value = { Min = 5, Max = 100, Default = hb.strength },
    Callback = function(v) pcall(function() hb.strength = v end) end })

lp.CharacterAdded:Connect(function()
    pcall(function()
        for k in pairs(hb.active) do hb.active[k] = nil end
        task.delay(1, function() if hb.on then hbStop(); hbStart() end end)
    end)
end)

lp.CharacterRemoving:Connect(function() pcall(function() for k in pairs(hb.active) do hb.active[k] = nil end end) end)

-- Auto Collision
local ac = {
    on         = false,
    strength   = 50,
    maxDist    = 100,
    active     = {},
    chaseTarget  = nil,
    damageTarget = nil,
}

local function acGetHRP(model)
    if not model or not model.Parent then return nil end
    local h = model:FindFirstChildOfClass("Humanoid")
    if not h or h.Health <= 0 then return nil end
    local r = model:FindFirstChild("HumanoidRootPart")
    return r and r.Parent and r or nil
end

local function acFindChaseTarget()
    local sf = getTeamFolder("Survivors"); if not sf then return nil end
    for _, model in ipairs(sf:GetChildren()) do
        if model ~= lp.Character and model:IsA("Model") then
            local chased = model:GetAttribute("IsChased") or model:GetAttribute("InChase")
                        or model:GetAttribute("ChasedBy") or model:GetAttribute("IsBeingChased")
            if chased and chased ~= false and chased ~= "" then
                local r = acGetHRP(model); if r then return r end
            end
        end
    end
    return nil
end

local function acPickTarget()
    if ac.chaseTarget and ac.chaseTarget.Parent then
        local model = ac.chaseTarget.Parent
        local h = model:FindFirstChildOfClass("Humanoid")
        if h and h.Health > 0 then
            local chased = model:GetAttribute("IsChased") or model:GetAttribute("InChase")
                        or model:GetAttribute("ChasedBy") or model:GetAttribute("IsBeingChased")
            if chased and chased ~= false and chased ~= "" then return ac.chaseTarget end
        end
        ac.chaseTarget = nil
    end
    local fresh = acFindChaseTarget()
    if fresh then ac.chaseTarget = fresh; return fresh end
    if ac.damageTarget and ac.damageTarget.Parent then
        local model = ac.damageTarget.Parent
        local h = model:FindFirstChildOfClass("Humanoid")
        if h and h.Health > 0 then return ac.damageTarget end
        ac.damageTarget = nil
    end
    local sf = getTeamFolder("Survivors"); local myChar = lp.Character
    if not sf or not myChar then return nil end
    local origin = myChar:FindFirstChild("QueryHitbox", true) or myChar:FindFirstChild("HumanoidRootPart")
    if not origin then return nil end
    local myPos = origin.Position
    local best, bd = nil, math.huge
    for _, model in ipairs(sf:GetChildren()) do
        if model ~= myChar and model:IsA("Model") then
            local r = acGetHRP(model)
            if r then local d = (r.Position - myPos).Magnitude; if d < bd and d <= ac.maxDist then bd = d; best = r end end
        end
    end
    return best
end

local function acPickKillerTarget()
    local kf = getTeamFolder("Killers"); local myChar = lp.Character
    if not kf or not myChar then return nil end
    local origin = myChar:FindFirstChild("HumanoidRootPart"); if not origin then return nil end
    local myPos = origin.Position
    local best, bd = nil, math.huge
    for _, model in ipairs(kf:GetChildren()) do
        if model ~= myChar and model:IsA("Model") then
            local r = acGetHRP(model)
            if r then local d = (r.Position - myPos).Magnitude; if d < bd and d <= ac.maxDist then bd = d; best = r end end
        end
    end
    return best
end

local function acPush(targetRoot, facingOverrideCFrame)
    pcall(function()
        if not targetRoot or not targetRoot.Parent then return end
        local myChar = lp.Character; if not myChar then return end
        local hrp = myChar:FindFirstChild("HumanoidRootPart"); if not hrp then return end
        local dir = (targetRoot.Position - hrp.Position)
        if dir.Magnitude < 0.1 then return end
        dir = dir.Unit
        local lookDir
        if facingOverrideCFrame then
            lookDir = facingOverrideCFrame.LookVector * Vector3.new(1, 0, 1)
        else
            lookDir = dir * Vector3.new(1, 0, 1)
        end
        if lookDir.Magnitude > 0.01 then
            hrp.CFrame = CFrame.new(hrp.Position, hrp.Position + lookDir.Unit)
        end
        local was = hrp.AssemblyLinearVelocity
        hrp.AssemblyLinearVelocity = was + dir * ac.strength
        svc.Run.RenderStepped:Wait()
        if myChar and myChar.Parent and hrp and hrp.Parent then hrp.AssemblyLinearVelocity = was end
    end)
end

local acAttrConns = {}

local function acWatchModel(model)
    pcall(function()
        if acAttrConns[model] then return end
        acAttrConns[model] = model.AttributeChanged:Connect(function(attr)
            if attr ~= "IsChased" and attr ~= "InChase" and attr ~= "ChasedBy" and attr ~= "IsBeingChased" then return end
            local chased = model:GetAttribute(attr)
            if chased and chased ~= false and chased ~= "" then
                local r = acGetHRP(model); if r then ac.chaseTarget = r end
            else
                if ac.chaseTarget and ac.chaseTarget.Parent == model then ac.chaseTarget = nil end
            end
        end)
    end)
end

local function acStopWatchModel(model)
    pcall(function()
        if acAttrConns[model] then pcall(function() acAttrConns[model]:Disconnect() end); acAttrConns[model] = nil end
    end)
end

local function acSetupWatchers()
    pcall(function()
        local sf = getTeamFolder("Survivors"); if not sf then return end
        for _, model in ipairs(sf:GetChildren()) do if model:IsA("Model") then acWatchModel(model) end end
        sf.ChildAdded:Connect(function(child) if child:IsA("Model") then task.wait(0.1); acWatchModel(child) end end)
        sf.ChildRemoved:Connect(function(child)
            acStopWatchModel(child)
            if ac.chaseTarget  and ac.chaseTarget.Parent  == child then ac.chaseTarget  = nil end
            if ac.damageTarget and ac.damageTarget.Parent == child then ac.damageTarget = nil end
        end)
    end)
end

task.spawn(function()
    pcall(function()
        local remote = hbGetRemote()
        if not remote then warn("[v1prware] AutoCollision: could not find RemoteEvent — feature disabled"); return end
        task.spawn(acSetupWatchers)
        remote.OnClientEvent:Connect(function(action, data)
            if not ac.on then return end
            if action ~= "UseActorAbility" then return end
            if typeof(data) ~= "table" or not data[1] then return end
            local name = hbReadName(data[1])
            if not name or not hbAbilities[name] then return end
            if ac.active[name] then return end
            local myChar = lp.Character
            local killerFolder   = getTeamFolder("Killers")
            local survivorFolder = getTeamFolder("Survivors")
            local amKiller   = killerFolder   and myChar and myChar:IsDescendantOf(killerFolder)
            local amSurvivor = survivorFolder and myChar and myChar:IsDescendantOf(survivorFolder)
            if amKiller and data[2] and typeof(data[2]) == "Instance" then
                local hrpTarget = nil
                if data[2]:IsA("Model") then
                    hrpTarget = data[2]:FindFirstChild("HumanoidRootPart")
                elseif data[2]:IsA("BasePart") then
                    local model = data[2]:FindFirstAncestorOfClass("Model")
                    if model then hrpTarget = model:FindFirstChild("HumanoidRootPart") end
                end
                if hrpTarget and hrpTarget.Parent then
                    local sf = getTeamFolder("Survivors")
                    if sf and hrpTarget.Parent:IsDescendantOf(sf) then
                        local h = hrpTarget.Parent:FindFirstChildOfClass("Humanoid")
                        if h and h.Health > 0 then ac.damageTarget = hrpTarget end
                    end
                end
            end
            ac.active[name] = true
            local t0 = tick()
            local conn; conn = svc.Run.Heartbeat:Connect(function()
                if tick() - t0 >= 1 or not ac.on then conn:Disconnect(); ac.active[name] = nil; return end
                local target
                local facingOverride = nil
                if amKiller then
                    target = acPickTarget()
                elseif amSurvivor then
                    target = acPickKillerTarget()
                    if target and target.Parent and target.Parent.Name == "TwoTime" and name == "Stab" then
                        facingOverride = target.CFrame
                    end
                end
                if target then task.spawn(acPush, target, facingOverride) end
            end)
        end)
    end)
end)

task.spawn(function()
    while true do
        task.wait(0.5)
        pcall(function()
            if ac.on then local fresh = acFindChaseTarget(); if fresh then ac.chaseTarget = fresh end end
        end)
    end
end)

lp.CharacterAdded:Connect(function()
    pcall(function()
        for k in pairs(ac.active) do ac.active[k] = nil end
        ac.chaseTarget = nil; ac.damageTarget = nil
    end)
end)

lp.CharacterRemoving:Connect(function()
    pcall(function()
        for k in pairs(ac.active) do ac.active[k] = nil end
        ac.chaseTarget = nil; ac.damageTarget = nil
    end)
end)

local secAutoCollision = tabGlobal:Section({ Title = "Auto Collision", Opened = true })

secAutoCollision:Toggle({
    Title = "Push Hitbox on Ability", Type = "Checkbox", Flag = "acOn", Default = ac.on,
    Callback = function(on)
        pcall(function()
            ac.on = on; 
            if not on then for k in pairs(ac.active) do ac.active[k] = nil end; ac.chaseTarget = nil; ac.damageTarget = nil end
        end)
    end
})

secAutoCollision:Slider({ Title = "Push Strength", Flag = "acStrength", Step = 1, Value = { Min = 5,  Max = 100, Default = ac.strength }, Callback = function(v) pcall(function() ac.strength = v end) end })
secAutoCollision:Slider({ Title = "Max Distance",  Flag = "acMaxDist", Step = 5, Value = { Min = 20, Max = 200, Default = ac.maxDist  }, Callback = function(v) pcall(function() ac.maxDist = v end) end })

-- ============================================================
-- GENERATOR TAB
-- ============================================================

end -- tabGlobal
do -- tabGen
local tabGen     = win:Tab({ Title = "Generator", Icon = "circuit-board" })
local secGenAuto = tabGen:Section({ Title = "Auto Solve", Opened = true })

local flow = { on = false, nodeDelay = 0.04, lineDelay = 0.60 }

local function flowKey(n) return n.row.."-"..n.col end

local function flowNeighbour(r1,c1,r2,c2)
    if r2==r1-1 and c2==c1 then return"up" end; if r2==r1+1 and c2==c1 then return"down" end
    if r2==r1 and c2==c1-1 then return"left" end; if r2==r1 and c2==c1+1 then return"right" end; return false
end

local function flowOrder(path, endpoints)
    if not path or #path == 0 then return path end
    local lookup = {}
    for _, n in ipairs(path) do lookup[flowKey(n)] = n end
    local start
    for _, ep in ipairs(endpoints or {}) do
        for _, n in ipairs(path) do
            if n.row == ep.row and n.col == ep.col then start = { row = ep.row, col = ep.col }; break end
        end
        if start then break end
    end
    if not start then
        for _, n in ipairs(path) do
            local nb = 0
            for _, d in ipairs({{-1,0},{1,0},{0,-1},{0,1}}) do
                if lookup[(n.row+d[1]).."-"..(n.col+d[2])] then nb += 1 end
            end
            if nb == 1 then start = { row = n.row, col = n.col }; break end
        end
    end
    if not start then start = { row = path[1].row, col = path[1].col } end
    local pool, ordered = {}, {}
    for _, n in ipairs(path) do pool[flowKey(n)] = { row = n.row, col = n.col } end
    local cur = start
    table.insert(ordered, { row = cur.row, col = cur.col }); pool[flowKey(cur)] = nil
    while next(pool) do
        local moved = false
        for k, node in pairs(pool) do
            if flowNeighbour(cur.row, cur.col, node.row, node.col) then
                table.insert(ordered, { row = node.row, col = node.col })
                pool[k] = nil; cur = node; moved = true; break
            end
        end
        if not moved then break end
    end
    return ordered
end

local function flowSolve(puzzle)
    pcall(function()
        if not puzzle or not puzzle.Solution then return end
        local indices = {}
        for i = 1, #puzzle.Solution do indices[i] = i end
        for i = #indices, 2, -1 do local j = math.random(1, i); indices[i], indices[j] = indices[j], indices[i] end
        for _, ci in ipairs(indices) do
            local solution = puzzle.Solution[ci]; if not solution then continue end
            local ordered = flowOrder(solution, puzzle.targetPairs[ci])
            if not ordered or #ordered == 0 then continue end
            puzzle.paths[ci] = {}
            for _, node in ipairs(ordered) do
                table.insert(puzzle.paths[ci], { row = node.row, col = node.col })
                puzzle:updateGui(); task.wait(flow.nodeDelay)
            end
            task.wait(flow.lineDelay); puzzle:checkForWin()
        end
    end)
end

do
    pcall(function()
        local modFolder  = svc.RS:FindFirstChild("Modules")
        local miniFolder = modFolder and modFolder:FindFirstChild("Minigames")
        local fgFolder   = miniFolder and miniFolder:FindFirstChild("FlowGameManager")
        local fgModule   = fgFolder and fgFolder:FindFirstChild("FlowGame")
        if fgModule then
            local ok, FG = pcall(require, fgModule)
            if ok and FG and FG.new then
                local orig = FG.new
                FG.new = function(...)
                    local p = orig(...)
                    if flow.on then task.spawn(function() task.wait(0.3); flowSolve(p) end) end
                    return p
                end
            else warn("[v1prware] FlowGame: failed to require FlowGame module — auto-solve disabled") end
        else warn("[v1prware] FlowGame: FlowGame not found — auto-solve disabled") end
    end)
end

secGenAuto:Toggle({ Title = "Auto Solve", Type = "Checkbox", Flag = "flowOn", Default = flow.on, Callback = function(on) pcall(function() flow.on = on end) end })
secGenAuto:Slider({ Title = "Node Speed", Flag = "flowNodeDelay", Step = 0.02, Value = { Min = 0.01, Max = 0.50, Default = flow.nodeDelay }, Callback = function(v) pcall(function() flow.nodeDelay = v end) end })
secGenAuto:Slider({ Title = "Line Pause", Flag = "flowLineDelay", Step = 0.10, Value = { Min = 0.00, Max = 1.00, Default = flow.lineDelay }, Callback = function(v) pcall(function() flow.lineDelay = v end) end })

-- ============================================================
-- KILLER TAB
-- ============================================================

end -- tabGen
do -- tabKiller
local tabKiller = win:Tab({ Title = "Killer", Icon = "crosshair" })

-- Aimbot
local secAimbot = tabKiller:Section({ Title = "Aimbot", Opened = true })

local aim = {
    on=false, cooldown=0.3, lockTime=0.4,
    maxDist=30, smooth=0.35,
    targeting=false, target=nil, deathConn=nil, autoRotate=nil, lastFired=0,
    hum=nil, hrp=nil, cache={}, cacheTime=0, cacheLife=0.5,
}

local function aimAmIKiller() local ch=lp.Character; if not ch then return false end; local kf=getTeamFolder("Killers"); return kf and ch:IsDescendantOf(kf) end

local function aimRefreshChar(ch) pcall(function() aim.hum=ch:FindFirstChildOfClass("Humanoid"); aim.hrp=ch:FindFirstChild("HumanoidRootPart") end) end

local function aimRefreshTargets()
    pcall(function()
        local now=tick(); if now-aim.cacheTime<aim.cacheLife then return end; aim.cacheTime=now; aim.cache={}
        local sf=getTeamFolder("Survivors"); if not sf then return end
        for _,model in ipairs(sf:GetChildren()) do if model~=lp.Character and model:IsA("Model") then local h=model:FindFirstChildOfClass("Humanoid"); local r=model:FindFirstChild("HumanoidRootPart"); if h and r and h.Health>0 then table.insert(aim.cache,r) end end end
    end)
end

local function aimNearest()
    aimRefreshTargets(); if not aim.hrp or #aim.cache==0 then return nil end
    local best,bd=nil,math.huge; for _,r in ipairs(aim.cache) do local d=(r.Position-aim.hrp.Position).Magnitude; if d<bd and d<=aim.maxDist then bd=d; best=r end end; return best
end

local function aimUnlock()
    pcall(function()
        if not aim.targeting then return end
        if aim.deathConn then aim.deathConn:Disconnect(); aim.deathConn=nil end
        if aim.autoRotate~=nil and aim.hum and aim.hum.Parent then pcall(function() aim.hum.AutoRotate=aim.autoRotate end) end
        aim.targeting=false; aim.target=nil
    end)
end

local function aimLock(r)
    pcall(function()
        if not r or not r.Parent or not aim.hum or not aim.hrp then return end
        if aim.targeting and aim.target==r then return end
        aimUnlock(); aim.target=r; aim.targeting=true; aim.autoRotate=aim.hum.AutoRotate; aim.hum.AutoRotate=false
        local th=r.Parent:FindFirstChildOfClass("Humanoid"); if th then aim.deathConn=th.Died:Connect(aimUnlock) end
        task.delay(aim.lockTime, function() if aim.target==r then aimUnlock() end end)
    end)
end

svc.Run.RenderStepped:Connect(function()
    pcall(function()
        if not aim.on or not aim.targeting or not aim.hrp or not aim.target then return end
        if not aim.target.Parent then aimUnlock(); return end
        local th=aim.target.Parent:FindFirstChildOfClass("Humanoid"); if not th or th.Health<=0 then aimUnlock(); return end
        local flat=Vector3.new(aim.target.Position.X-aim.hrp.Position.X,0,aim.target.Position.Z-aim.hrp.Position.Z).Unit
        if flat.Magnitude>0 then aim.hrp.CFrame=aim.hrp.CFrame:Lerp(CFrame.new(aim.hrp.Position,aim.hrp.Position+flat),aim.smooth) end
    end)
end)

task.spawn(function()
    pcall(function()
        local remote = hbGetRemote()
        if not remote then warn("[v1prware] Aimbot: could not find RemoteEvent — aimbot trigger disabled"); return end
        remote.OnClientEvent:Connect(function(...)
            if not aim.on then return end
            local a={...}; if typeof(a[1])~="string" then return end; local n=a[1]
            if not (n:match("Ability") or n:match("[QER]") or n=="Slash" or n=="Dagger" or n=="Charge") then return end
            if tick()-aim.lastFired<aim.cooldown then return end; aim.lastFired=tick()
            if aimAmIKiller() then local t=aimNearest(); if t then aimLock(t) end end
        end)
    end)
end)

lp.CharacterAdded:Connect(function(ch) task.wait(0.5); aimRefreshChar(ch) end)
if lp.Character then aimRefreshChar(lp.Character) end

secAimbot:Toggle({ Title="Enable Aimbot",      Type="Checkbox", Flag="aimOn",       Default=aim.on,       Callback=function(on) pcall(function() aim.on=on; if not on then aimUnlock() end end) end })
secAimbot:Slider({ Title="Cooldown (s)",        Flag="aimCooldown", Step=0.05, Value={Min=0.1, Max=2.0, Default=aim.cooldown}, Callback=function(v) pcall(function() aim.cooldown=v end) end })
secAimbot:Slider({ Title="Lock Time (s)",       Flag="aimLockTime", Step=0.1,  Value={Min=0.1, Max=3.0, Default=aim.lockTime}, Callback=function(v) pcall(function() aim.lockTime=v end) end })
secAimbot:Slider({ Title="Max Distance",        Flag="aimMaxDist", Step=5,    Value={Min=5,   Max=100, Default=aim.maxDist},  Callback=function(v) pcall(function() aim.maxDist=v end) end })
secAimbot:Slider({ Title="Rotation Smoothing",  Flag="aimSmooth", Step=0.05, Value={Min=0.05,Max=1.0, Default=aim.smooth},  Callback=function(v) pcall(function() aim.smooth=v end) end })

-- Anti-Backstab
local secABS = tabKiller:Section({ Title = "Anti-Backstab", Opened = true })

local abs = { on=false, range=40, duration=1.5, locked=false, soundConn=nil, scanThread=nil, rings={} }
local absTriggerSounds = { ["86710781315432"]=true, ["99820161736138"]=true }
local absScreenGui = nil

local function absGui()
    if absScreenGui and absScreenGui.Parent then return absScreenGui end
    local pg=lp:FindFirstChild("PlayerGui"); if not pg then return nil end
    absScreenGui=Instance.new("ScreenGui"); absScreenGui.Name="AbsGui"; absScreenGui.ResetOnSpawn=false; absScreenGui.ZIndexBehavior=Enum.ZIndexBehavior.Sibling; absScreenGui.Parent=pg; return absScreenGui
end

local function absShowLabel(show)
    pcall(function()
        local g=absGui(); if not g then return end; local lbl=g:FindFirstChild("AbsTaunt")
        if not lbl then lbl=Instance.new("TextLabel"); lbl.Name="AbsTaunt"; lbl.Size=UDim2.new(0,500,0,50); lbl.Position=UDim2.new(0.5,-250,0.38,0); lbl.BackgroundTransparency=1; lbl.TextColor3=Color3.new(1,1,1); lbl.TextStrokeTransparency=0.4; lbl.TextStrokeColor3=Color3.new(0,0,0); lbl.Text="At least they tried 😂"; lbl.Font=Enum.Font.GothamBold; lbl.TextSize=36; lbl.TextTransparency=1; lbl.Parent=g end
        pcall(function() svc.TweenService:Create(lbl,TweenInfo.new(show and 0.15 or 0.5),{TextTransparency=show and 0 or 1}):Play() end)
    end)
end

local function absAddRing(model)
    pcall(function()
        local hrp=model:FindFirstChild("HumanoidRootPart"); if not hrp or abs.rings[model] then return end
        local ring=Instance.new("Part"); ring.Name="AbsRing"; ring.Shape=Enum.PartType.Cylinder; ring.Size=Vector3.new(0.1,abs.range*2,abs.range*2); ring.Color=Color3.fromRGB(220,50,50); ring.Material=Enum.Material.ForceField; ring.Transparency=0.5; ring.CanCollide=false; ring.CanTouch=false; ring.CFrame=hrp.CFrame*CFrame.Angles(0,0,math.rad(90)); ring.Parent=hrp
        local w=Instance.new("WeldConstraint"); w.Part0=hrp; w.Part1=ring; w.Parent=ring; abs.rings[model]=ring
    end)
end

local function absRemoveRing(model) pcall(function() local r=abs.rings[model]; if r then r:Destroy() end; abs.rings[model]=nil end) end

local function absResizeRings() pcall(function() for _,r in pairs(abs.rings) do if r and r.Parent then r.Size=Vector3.new(0.1,abs.range*2,abs.range*2) end end end) end

local function absCleanRings() pcall(function() for m in pairs(abs.rings) do absRemoveRing(m) end end) end

local function absFindTwoTime() local players=svc.WS:FindFirstChild("Players"); if not players then return nil end; for _,folder in ipairs(players:GetChildren()) do local tt=folder:FindFirstChild("TwoTime"); if tt then return tt end end; return nil end

local function absTrigger()
    pcall(function()
        if abs.locked then return end; local ch=lp.Character; local myRoot=ch and ch:FindFirstChild("HumanoidRootPart"); if not myRoot then return end
        local ttModel=absFindTwoTime(); if not ttModel then return end; local ttRoot=ttModel:FindFirstChild("HumanoidRootPart"); if not ttRoot then return end
        if (myRoot.Position-ttRoot.Position).Magnitude>abs.range then return end
        abs.locked=true; absShowLabel(true)
        task.spawn(function()
            local deadline=tick()+abs.duration
            while tick()<deadline do if not abs.on then break end; local ch2=lp.Character; local r2=ch2 and ch2:FindFirstChild("HumanoidRootPart"); if not r2 or not ttRoot.Parent then break end; r2.CFrame=CFrame.lookAt(r2.Position,Vector3.new(ttRoot.Position.X,r2.Position.Y,ttRoot.Position.Z)); svc.Run.RenderStepped:Wait() end
            abs.locked=false; absShowLabel(false)
        end)
    end)
end

local function absHookSounds()
    pcall(function()
        if abs.soundConn then abs.soundConn:Disconnect(); abs.soundConn=nil end
        local function checkSound(obj)
            if not abs.on or not obj:IsA("Sound") then return end
            local id = obj.SoundId:match("%d+")
            if id and absTriggerSounds[id] then absTrigger() end
        end
        abs.soundConn=svc.WS.DescendantAdded:Connect(function(obj)
            if obj:IsA("Sound") then
                checkSound(obj)
                obj:GetPropertyChangedSignal("SoundId"):Connect(function() checkSound(obj) end)
            end
        end)
    end)
end

local function absStartScan()
    if abs.scanThread then return end
    abs.scanThread=task.spawn(function()
        while abs.on do
            pcall(function()
                local players=svc.WS:FindFirstChild("Players")
                if players then for _,folder in ipairs(players:GetChildren()) do for _,model in ipairs(folder:GetChildren()) do if model.Name=="TwoTime" then absAddRing(model) end end end end
                for m in pairs(abs.rings) do if not m.Parent then absRemoveRing(m) end end
            end)
            task.wait(1)
        end; abs.scanThread=nil
    end)
end

local function absStart() pcall(function() absHookSounds(); absStartScan() end) end

local function absStop() pcall(function() abs.on=false; if abs.soundConn then abs.soundConn:Disconnect(); abs.soundConn=nil end; if abs.scanThread then task.cancel(abs.scanThread); abs.scanThread=nil end; absCleanRings(); abs.locked=false; absShowLabel(false) end) end

lp.CharacterAdded:Connect(function() pcall(function() abs.locked=false; if abs.on then absStart() end end) end)

task.spawn(function()
    while true do
        task.wait(10)
        pcall(function()
            local deadRings = {}
            for model, ring in pairs(abs.rings) do
                if not model or not model.Parent or not ring or not ring.Parent then table.insert(deadRings, model) end
            end
            for _, model in ipairs(deadRings) do abs.rings[model] = nil end
        end)
    end
end)

secABS:Toggle({ Title="Enable Anti-Backstab", Type="Checkbox", Flag="absOn", Default=abs.on, Callback=function(on) pcall(function() abs.on=on; if on then absStart() else absStop() end end) end })
secABS:Slider({ Title="Detection Range",   Flag="absRange", Step=5,  Value={Min=10,Max=120,Default=abs.range},    Callback=function(v) pcall(function() abs.range=v; absResizeRings() end) end })
secABS:Slider({ Title="Look Duration (s)", Flag="absDur", Step=0.1,Value={Min=0.3,Max=5.0,Default=abs.duration}, Callback=function(v) pcall(function() abs.duration=v end) end })

-- Killer Abilities
local secKillerAbilities = tabKiller:Section({ Title = "Killer Abilities", Opened = true })

local sixerStrafeOn = false
local SIXER_BIND    = "LunawareSixerStrafe"

svc.Run:BindToRenderStep(SIXER_BIND, Enum.RenderPriority.Character.Value + 2, function()
    pcall(function()
        if not sixerStrafeOn then return end
        local char = lp.Character; if not char then return end
        if char:GetAttribute("PursuitState") ~= "Dashing" then return end
        local hrp = char:FindFirstChild("HumanoidRootPart")
        local hum = char:FindFirstChildOfClass("Humanoid")
        if not hrp or not hum then return end
        if hum.FloorMaterial ~= Enum.Material.Air then return end
        local cam  = svc.WS.CurrentCamera
        local flat = cam.CFrame.LookVector * Vector3.new(1, 0, 1)
        if flat.Magnitude < 0.01 then return end
        flat = flat.Unit
        local vel   = hrp.AssemblyLinearVelocity
        local hVel  = Vector3.new(vel.X, 0, vel.Z)
        local hSpeed= hVel.Magnitude
        if hSpeed < 0.1 then return end
        local newH = hVel:Lerp(flat * hSpeed, 1)
        hrp.AssemblyLinearVelocity = Vector3.new(newH.X, vel.Y, newH.Z)
    end)
end)

local coolkidWSOOn = false

local function coolkidGetInputDir()
    local cf       = svc.WS.CurrentCamera.CFrame
    local camFwd   = Vector3.new(cf.LookVector.X,  0, cf.LookVector.Z)
    local camRight = Vector3.new(cf.RightVector.X, 0, cf.RightVector.Z)
    local x, z = 0, 0
    if svc.Input:IsKeyDown(Enum.KeyCode.W) or svc.Input:IsKeyDown(Enum.KeyCode.Up)    then z = z - 1 end
    if svc.Input:IsKeyDown(Enum.KeyCode.S) or svc.Input:IsKeyDown(Enum.KeyCode.Down)  then z = z + 1 end
    if svc.Input:IsKeyDown(Enum.KeyCode.A) or svc.Input:IsKeyDown(Enum.KeyCode.Left)  then x = x - 1 end
    if svc.Input:IsKeyDown(Enum.KeyCode.D) or svc.Input:IsKeyDown(Enum.KeyCode.Right) then x = x + 1 end
    local dir = camFwd * -z + camRight * x
    if dir.Magnitude > 0.01 then return dir.Unit end
    if camFwd.Magnitude > 0.01 then return camFwd.Unit end
    return Vector3.new(0, 0, -1)
end

svc.Run.RenderStepped:Connect(function(dt)
    pcall(function()
        if not coolkidWSOOn then return end
        local char = lp.Character
        local hrp  = char and char:FindFirstChild("HumanoidRootPart")
        if not char or not hrp then return end
        if char:GetAttribute("FootstepsMuted") ~= true then return end
        local dir = coolkidGetInputDir()
        local lv  = hrp:FindFirstChildWhichIsA("LinearVelocity")
        if lv then lv.LineDirection = dir end
        if dir.Magnitude > 0.01 then
            local targetRot = CFrame.new(hrp.Position, hrp.Position + dir).Rotation
            hrp.CFrame = CFrame.new(hrp.Position) * hrp.CFrame.Rotation:Lerp(targetRot, math.min(dt * 16, 1))
        end
    end)
end)

local noliVoidRushOn     = false
local noliOverrideActive = false
local noliOrigWalkSpeed  = nil
local noliConn           = nil

local function noliStop()
    pcall(function()
        if not noliOverrideActive then return end
        noliOverrideActive = false
        local char = lp.Character
        local hum  = char and char:FindFirstChild("Humanoid")
        if hum then hum.WalkSpeed=noliOrigWalkSpeed or 16; hum.AutoRotate=true; pcall(function() hum:Move(Vector3.new(0,0,0)) end) end
        noliOrigWalkSpeed = nil
        if noliConn then noliConn:Disconnect(); noliConn = nil end
    end)
end

local function noliStart()
    pcall(function()
        if noliOverrideActive then return end
        noliOverrideActive = true
        noliConn = svc.Run.RenderStepped:Connect(function()
            local char = lp.Character
            local hum  = char and char:FindFirstChild("Humanoid")
            local root = char and char:FindFirstChild("HumanoidRootPart")
            if not hum or not root then return end
            if not noliOrigWalkSpeed then noliOrigWalkSpeed = hum.WalkSpeed end
            hum.WalkSpeed=60; hum.AutoRotate=false
            local horiz = Vector3.new(root.CFrame.LookVector.X, 0, root.CFrame.LookVector.Z)
            if horiz.Magnitude > 0 then hum:Move(horiz.Unit) end
        end)
    end)
end

svc.Run.RenderStepped:Connect(function()
    pcall(function()
        if not noliVoidRushOn then if noliOverrideActive then noliStop() end; return end
        local char = lp.Character; if not char then return end
        if char:GetAttribute("VoidRushState") == "Dashing" then noliStart() else noliStop() end
    end)
end)

lp.CharacterAdded:Connect(function() pcall(function() noliStop(); noliOrigWalkSpeed = nil end) end)

secKillerAbilities:Toggle({ Title="Sixer — Air Strafe",       Type="Checkbox", Flag="sixerStrafeOn", Default=sixerStrafeOn, Callback=function(on) pcall(function() sixerStrafeOn=on end) end })
secKillerAbilities:Toggle({ Title="c00lkidd — Dash Turn",     Type="Checkbox", Flag="coolkidWSOOn",  Default=coolkidWSOOn,  Callback=function(on) pcall(function() coolkidWSOOn=on end) end })
secKillerAbilities:Toggle({ Title="Noli — Void Rush Control", Type="Checkbox", Flag="noliVoidRushOn",Default=noliVoidRushOn,Callback=function(on) pcall(function() noliVoidRushOn=on; if not on then noliStop() end end) end })

-- ============================================================
-- NOSFERATU SECTION
-- ============================================================

local secNosferatu = tabKiller:Section({ Title = "Nosferatu", Opened = true })

-- AUTO QTE
local qte = {
    on = false,
    speed = 0.03,
}

local qteThread = nil

local function qteGetButton()
    local pg = lp:FindFirstChild("PlayerGui")
    if not pg then return nil end
    
    local tu = pg:FindFirstChild("TemporaryUI")
    if not tu then return nil end
    
    local qteUI = tu:FindFirstChild("QTE")
    if not qteUI then return nil end
    
    for _, child in ipairs(qteUI:GetDescendants()) do
        if child.Name == "ActiveButton" and (child:IsA("TextButton") or child:IsA("ImageButton")) then
            return child
        end
    end
    
    for _, child in ipairs(qteUI:GetDescendants()) do
        if (child:IsA("TextButton") or child:IsA("ImageButton")) and child.Visible then
            return child
        end
    end
    
    return nil
end

local function qtePressButton(btn)
    if not btn then return false end
    
    pcall(function()
        btn.MouseButton1Click:Fire()
        btn.MouseButton1Down:Fire()
        btn.MouseButton1Up:Fire()
        btn.Activated:Fire()
        
        if getconnections then
            for _, conn in ipairs(getconnections(btn.MouseButton1Down)) do
                if conn.Function then conn.Function() end
            end
            for _, conn in ipairs(getconnections(btn.MouseButton1Click)) do
                if conn.Function then conn.Function() end
            end
        end
    end)
    
    return true
end

local function qteStart()
    if qteThread then return end
    qteThread = task.spawn(function()
        while qte.on do
            pcall(function()
                local btn = qteGetButton()
                if btn then
                    qtePressButton(btn)
                    task.wait(qte.speed)
                else
                    task.wait(0.05)
                end
            end)
        end
        qteThread = nil
    end)
end

local function qteStop()
    qte.on = false
    if qteThread then 
        task.cancel(qteThread)
        qteThread = nil 
    end
end

secNosferatu:Toggle({ 
    Title = "Auto QTE", 
    Type = "Checkbox", 
    Flag = "qteOn", 
    Default = qte.on,
    Callback = function(on) 
        pcall(function() 
            qte.on = on
            if on then 
                qteStart() 
            else 
                qteStop() 
            end 
        end) 
    end 
})

secNosferatu:Slider({ 
    Title = "Click Speed (s)", 
    Flag = "qteSpeed", 
    Step = 0.005,
    Value = { Min = 0.005, Max = 0.2, Default = qte.speed },
    Callback = function(v) 
        pcall(function() 
            qte.speed = v 
        end) 
    end 
})

-- BATS AIM ASSIST (Character Snap Method)
local batsAim = {
    on = false,
    maxDist = 100,
    prediction = 0.3,
    depthOffset = 0,
}

local batsVelocityData = {}

local function batsGetSurvivorVelocity(hrp)
    if not hrp then return Vector3.zero end
    
    local data = batsVelocityData[hrp]
    local now = tick()
    
    if not data then
        batsVelocityData[hrp] = {
            lastPos = hrp.Position,
            lastTime = now,
            velocity = Vector3.zero
        }
        return Vector3.zero
    end
    
    local dt = now - data.lastTime
    if dt <= 0 then return data.velocity end
    
    local vel = (hrp.Position - data.lastPos) / dt
    data.lastPos = hrp.Position
    data.lastTime = now
    data.velocity = vel
    
    return vel
end

local function batsGetNearestSurvivor()
    local char = lp.Character
    if not char then return nil end
    local hrp = char:FindFirstChild("HumanoidRootPart")
    if not hrp then return nil end
    
    local sf = getTeamFolder("Survivors")
    if not sf then return nil end
    
    local best, bd = nil, math.huge
    local pos = hrp.Position
    
    for _, model in ipairs(sf:GetChildren()) do
        if model ~= char and model:IsA("Model") then
            local r = model:FindFirstChild("HumanoidRootPart")
            local h = model:FindFirstChildOfClass("Humanoid")
            if r and h and h.Health > 0 then
                local vel = batsGetSurvivorVelocity(r)
                local predictedPos = r.Position + (vel * batsAim.prediction)
                predictedPos = predictedPos + Vector3.new(0, batsAim.depthOffset, 0)
                
                local d = (predictedPos - pos).Magnitude
                if d < bd and d <= batsAim.maxDist then
                    bd = d
                    best = { root = r, pos = predictedPos }
                end
            end
        end
    end
    return best
end

local function batsRotateToTarget(target)
    if not target or not target.root or not target.root.Parent then return end
    
    local char = lp.Character
    if not char then return end
    local hrp = char:FindFirstChild("HumanoidRootPart")
    if not hrp then return end
    
    local targetPos = target.pos or target.root.Position
    local dir = Vector3.new(targetPos.X - hrp.Position.X, 0, targetPos.Z - hrp.Position.Z)
    if dir.Magnitude < 0.1 then return end
    dir = dir.Unit
    
    hrp.CFrame = CFrame.new(hrp.Position, hrp.Position + dir)
    
    local hum = char:FindFirstChildOfClass("Humanoid")
    if hum then
        hum.AutoRotate = true
    end
end

local function batsOnAbility()
    if not batsAim.on then return end
    local target = batsGetNearestSurvivor()
    if target then
        task.spawn(function()
            batsRotateToTarget(target)
        end)
    end
end

local function batsSetupHook()
    local remote = hbGetRemote()
    if not remote then return end
    
    remote.OnClientEvent:Connect(function(action, data)
        if action ~= "UseActorAbility" then return end
        if typeof(data) ~= "table" then return end
        
        local isBats = false
        for i, v in ipairs(data) do
            if typeof(v) == "buffer" then
                local str = buffer.tostring(v)
                if str:lower():match("bat") then
                    isBats = true
                    break
                end
            end
        end
        
        if isBats then
            batsOnAbility()
        end
    end)
end

task.spawn(batsSetupHook)

task.spawn(function()
    while true do
        task.wait(5)
        local now = tick()
        for hrp, data in pairs(batsVelocityData) do
            if not hrp or not hrp.Parent or (now - data.lastTime) > 2 then
                batsVelocityData[hrp] = nil
            end
        end
    end
end)

local secBatsAim = tabKiller:Section({ Title = "Bats Aim Assist", Opened = true })

secBatsAim:Toggle({
    Title = "Aim Assist (Bats)",
    Type = "Checkbox",
    Flag = "batsAimOn",
    Default = batsAim.on,
    Callback = function(on)
        pcall(function()
            batsAim.on = on
        end)
    end
})

secBatsAim:Slider({
    Title = "Prediction (s)",
    Flag = "batsPrediction",
    Step = 0.05,
    Value = { Min = 0, Max = 1.0, Default = batsAim.prediction },
    Callback = function(v)
        pcall(function()
            batsAim.prediction = v
        end)
    end
})

secBatsAim:Slider({
    Title = "Depth Offset",
    Flag = "batsDepthOffset",
    Step = 0.5,
    Value = { Min = -5, Max = 5, Default = batsAim.depthOffset },
    Callback = function(v)
        pcall(function()
            batsAim.depthOffset = v
        end)
    end
})

secBatsAim:Slider({
    Title = "Max Distance",
    Flag = "batsMaxDist",
    Step = 5,
    Value = { Min = 10, Max = 150, Default = batsAim.maxDist },
    Callback = function(v)
        pcall(function()
            batsAim.maxDist = v
        end)
    end})

-- ============================================================
-- ESP TAB
-- ============================================================

end -- tabKiller
do -- tabESP
local tabESP = win:Tab({ Title = "ESP", Icon = "eye" })

local esp = {
    enabled = true,
    highlights = {}, billboards = {}, connections = {}, healthConnections = {},
    hlMonitorConns = {},
    scanThread = nil,
    showKillers = true, showSurvivors = true, showGenerators = true,
    showItems = true, showStructures = true,
    maxDistance = 200, transparency = 0.5,
    scanRate = 1.0,
    -- cached item/structure lists so we don't GetDescendants every tick
    cachedItems = {}, cachedStructures = {},
    itemCacheTime = 0, structCacheTime = 0, cacheLife = 5,
}

-- ============================================================
-- GENERATOR LABEL SYSTEM
-- genLabels: obj -> TextLabel   genConns: obj -> {connections}
-- ============================================================
local genLabels = {}
local genConns  = {}

local function genGetProgress(obj)
    if not obj or not obj.Parent then return 0 end
    local pv = obj:FindFirstChild("Progress")
    if pv and (pv:IsA("NumberValue") or pv:IsA("IntValue")) then return pv.Value end
    local av = obj:GetAttribute("Progress") or obj:GetAttribute("Charge")
    if type(av) == "number" then return av end
    return 0
end

local function genBuildText(progress)
    if progress >= 100 then
        return "Generator  ✓ DONE  (100%)", Color3.fromRGB(100, 255, 100)
    end
    local puzzles = math.floor(progress / 25)
    return string.format("Generator  %d/4  (%d%%)", puzzles, puzzles * 25),
           Color3.fromRGB(255, 200, 50)
end

local function genUpdateLabel(obj)
    if not obj or not obj.Parent then return end
    local label = genLabels[obj]
    if not label then
        local bb = obj:FindFirstChildWhichIsA("BillboardGui")
        if bb then label = bb:FindFirstChildWhichIsA("TextLabel") end
        if label then genLabels[obj] = label else return end
    end
    if not label.Parent then genLabels[obj] = nil; return end
    local txt, col = genBuildText(genGetProgress(obj))
    label.Text = txt; label.TextColor3 = col
    label.TextSize = 9; label.TextStrokeTransparency = 0.2; label.Visible = true
end

local function genDisconnectObj(obj)
    local conns = genConns[obj]
    if conns then
        for _, c in ipairs(conns) do pcall(function() c:Disconnect() end) end
        genConns[obj] = nil
    end
end

local function genRemoveObj(obj)
    genDisconnectObj(obj)
    genLabels[obj] = nil
end

local function genWatchGenerator(obj)
    if not obj then return end
    genDisconnectObj(obj)
    local conns = {}
    local pv = obj:FindFirstChild("Progress")
    if pv and (pv:IsA("NumberValue") or pv:IsA("IntValue")) then
        table.insert(conns, pv:GetPropertyChangedSignal("Value"):Connect(function()
            pcall(genUpdateLabel, obj)
        end))
    end
    table.insert(conns, obj.ChildAdded:Connect(function(child)
        if child.Name == "Progress" and (child:IsA("NumberValue") or child:IsA("IntValue")) then
            table.insert(conns, child:GetPropertyChangedSignal("Value"):Connect(function()
                pcall(genUpdateLabel, obj)
            end))
            pcall(genUpdateLabel, obj)
        end
    end))
    table.insert(conns, obj.AttributeChanged:Connect(function(attr)
        if attr == "Progress" or attr == "Charge" then pcall(genUpdateLabel, obj) end
    end))
    genConns[obj] = conns
    pcall(genUpdateLabel, obj)
end

local function genSetupGenerator(obj, label)
    if not obj or not label then return end
    genLabels[obj] = label
    local bb = label.Parent
    if bb and bb:IsA("BillboardGui") then
        bb.Enabled = true; bb.AlwaysOnTop = true
        bb.Size = UDim2.new(0, 200, 0, 18); bb.StudsOffset = Vector3.new(0, 4, 0)
    end
    local txt, col = genBuildText(genGetProgress(obj))
    label.Text = txt; label.TextColor3 = col
    label.TextSize = 9; label.TextStrokeTransparency = 0.2; label.Visible = true
    genWatchGenerator(obj)
end

local function genClearAll()
    pcall(function()
        for obj in pairs(genConns) do genDisconnectObj(obj) end
        -- billboards are destroyed by espClearAll; do NOT destroy labels here
        genLabels = {}
        genConns  = {}
    end)
end

-- ESP COLORS
local COLORS = {
    Killer = Color3.fromRGB(255,50,50), Survivor = Color3.fromRGB(50,255,50),
    Generator = Color3.fromRGB(255,200,50), Item = Color3.fromRGB(50,200,255),
    Structure = Color3.fromRGB(255,150,50),
}

local function espGetTeamFolder(name)
    local root = svc.WS:FindFirstChild("Players")
    return root and root:FindFirstChild(name)
end

local function espGetIngame()
    local m = svc.WS:FindFirstChild("Map")
    return m and m:FindFirstChild("Ingame")
end

local function espGetMapContent()
    local ig = espGetIngame()
    return ig and ig:FindFirstChild("Map")
end

local function espClearAll()
    pcall(function()
        for obj, hl in pairs(esp.highlights) do pcall(function() hl:Destroy() end) end
        esp.highlights = {}
        for obj, bb in pairs(esp.billboards) do pcall(function() bb:Destroy() end) end
        esp.billboards = {}
        for obj, conn in pairs(esp.healthConnections) do pcall(function() conn:Disconnect() end) end
        esp.healthConnections = {}
        for _, conn in ipairs(esp.connections) do pcall(function() conn:Disconnect() end) end
        esp.connections = {}
        for _, conn in pairs(esp.hlMonitorConns) do pcall(function() conn:Disconnect() end) end
        esp.hlMonitorConns = {}
        genClearAll()
    end)
end

local function espMakeHighlight(obj, color)
    local hl = Instance.new("Highlight")
    hl.Name = "V1PR_Highlight"
    hl.FillColor = color
    hl.FillTransparency = esp.transparency
    hl.OutlineColor = color
    hl.OutlineTransparency = 0.1
    hl.DepthMode = Enum.HighlightDepthMode.AlwaysOnTop
    hl.Adornee = obj
    hl.Parent = obj
    return hl
end

local function espCreate(obj, color, labelText, isCharacter)
    pcall(function()
        if not obj or not obj.Parent or esp.highlights[obj] then return end
        local attach = obj:FindFirstChild("HumanoidRootPart") or obj:FindFirstChild("Torso") or obj:FindFirstChildWhichIsA("BasePart") or obj:FindFirstChildOfClass("BasePart")
        if not attach then return end

        local hl = espMakeHighlight(obj, color)
        local bb = Instance.new("BillboardGui")
        bb.Adornee = attach
        bb.Size = UDim2.new(0, 120, 0, 18)
        bb.StudsOffset = Vector3.new(0, 4, 0)
        bb.AlwaysOnTop = true
        bb.MaxDistance = esp.maxDistance
        bb.Parent = obj
        
        local label = Instance.new("TextLabel")
        label.Size = UDim2.new(1, 0, 1, 0)
        label.BackgroundTransparency = 1
        label.Text = labelText or obj.Name
        label.TextColor3 = color
        label.TextStrokeColor3 = Color3.new(0, 0, 0)
        label.TextStrokeTransparency = 0.3
        label.TextSize = 9
        label.Font = Enum.Font.GothamBold
        label.Parent = bb
        
        esp.highlights[obj] = hl
        esp.billboards[obj] = bb

        if esp.hlMonitorConns[obj] then
            pcall(function() esp.hlMonitorConns[obj]:Disconnect() end)
        end
        esp.hlMonitorConns[obj] = obj.ChildRemoved:Connect(function(child)
            if not esp.enabled or not obj.Parent then return end
            if child == esp.highlights[obj] or child.Name == "V1PR_Highlight" or child:IsA("Highlight") then
                task.defer(function()
                    if not esp.enabled or not obj.Parent or not esp.highlights[obj] then return end
                    local existing = obj:FindFirstChild("V1PR_Highlight")
                    if not existing then
                        local newHl = espMakeHighlight(obj, color)
                        esp.highlights[obj] = newHl
                    end
                end)
            end
        end)

        -- Generator label setup
        if labelText == "Generator" or (not isCharacter and obj.Name == "Generator") then
            genSetupGenerator(obj, label)
        end

        if isCharacter then
            local function updateLabel()
                if not obj or not obj.Parent then return end
                local name = labelText or obj.Name
                local distText = ""
                local hpText = ""
                local myChar = lp.Character
                local myRoot = myChar and myChar:FindFirstChild("HumanoidRootPart")
                if myRoot then
                    local a = obj:FindFirstChild("HumanoidRootPart") or obj:FindFirstChild("Torso") or obj:FindFirstChildWhichIsA("BasePart")
                    if a then distText = string.format("%.0f", (a.Position - myRoot.Position).Magnitude) end
                end
                local hum = obj:FindFirstChildOfClass("Humanoid")
                if hum then hpText = string.format("%d", math.floor(hum.Health)) end
                if distText ~= "" and hpText ~= "" then label.Text = string.format("%s (%s) %s HP", name, distText, hpText)
                elseif distText ~= "" then label.Text = string.format("%s (%s)", name, distText)
                elseif hpText ~= "" then label.Text = string.format("%s %s HP", name, hpText)
                else label.Text = name end
            end
            updateLabel()
            local hum = obj:FindFirstChildOfClass("Humanoid")
            if hum then esp.healthConnections[obj] = hum.HealthChanged:Connect(updateLabel) end
            table.insert(esp.connections, svc.Run.Heartbeat:Connect(function()
                if esp.enabled and obj and obj.Parent then pcall(updateLabel) end
            end))
        end

        table.insert(esp.connections, obj.AncestryChanged:Connect(function()
            if not obj.Parent then
                pcall(function()
                    if esp.highlights[obj] then esp.highlights[obj]:Destroy() end
                    if esp.billboards[obj] then esp.billboards[obj]:Destroy() end
                    if esp.healthConnections[obj] then esp.healthConnections[obj]:Disconnect() end
                    if esp.hlMonitorConns[obj] then esp.hlMonitorConns[obj]:Disconnect() end
                    genRemoveObj(obj)
                    esp.highlights[obj] = nil
                    esp.billboards[obj] = nil
                    esp.healthConnections[obj] = nil
                    esp.hlMonitorConns[obj] = nil
                end)
            end
        end))
    end)
end

-- ESP SCAN
local function espScan()
    pcall(function()
        if not esp.enabled or not lp then return end
        local myChar = lp.Character
        local myRoot = myChar and myChar:FindFirstChild("HumanoidRootPart")
        local myPos = myRoot and myRoot.Position or Vector3.new(0,0,0)
        local toRemove = {}
        for obj in pairs(esp.highlights) do if not obj or not obj.Parent then table.insert(toRemove, obj) end end
        for _, obj in ipairs(toRemove) do pcall(function()
            if esp.highlights[obj] then esp.highlights[obj]:Destroy() end
            if esp.billboards[obj] then esp.billboards[obj]:Destroy() end
            if esp.healthConnections[obj] then esp.healthConnections[obj]:Disconnect() end
            esp.highlights[obj] = nil
            esp.billboards[obj] = nil
            esp.healthConnections[obj] = nil
        end) end
        local processed = {}
        local function addESP(obj, objType, color, label)
            if not obj or not obj.Parent or processed[obj] or esp.highlights[obj] then return end
            processed[obj] = true
            local attach = obj:FindFirstChild("HumanoidRootPart") or obj:FindFirstChild("Torso") or obj:FindFirstChildWhichIsA("BasePart") or obj:FindFirstChildOfClass("BasePart")
            if not attach then return end
            if myRoot and (attach.Position - myPos).Magnitude > esp.maxDistance then return end
            espCreate(obj, color, label, objType == "Character")
        end
        if esp.showKillers then
            local kf = espGetTeamFolder("Killers")
            if kf then for _, m in ipairs(kf:GetChildren()) do if m:IsA("Model") and m ~= myChar then local h = m:FindFirstChildOfClass("Humanoid"); if h and h.Health > 0 then addESP(m,"Character",COLORS.Killer,m.Name) end end end end
        end
        if esp.showSurvivors then
            local sf = espGetTeamFolder("Survivors")
            if sf then for _, m in ipairs(sf:GetChildren()) do if m:IsA("Model") and m ~= myChar then local h = m:FindFirstChildOfClass("Humanoid"); if h and h.Health > 0 then addESP(m,"Character",COLORS.Survivor,m.Name) end end end end
        end
        if esp.showGenerators then
            local mc = espGetMapContent()
            if mc then
                for _, o in ipairs(mc:GetChildren()) do
                    if o.Name == "Generator" and o.Parent then
                        addESP(o, "Object", COLORS.Generator, "Generator")
                    end
                end
            end
        end
        -- Items: rebuild cache every cacheLife seconds to avoid GetDescendants every scan
        if esp.showItems then
            local now = tick()
            if now - esp.itemCacheTime > esp.cacheLife then
                esp.itemCacheTime = now
                esp.cachedItems = {}
                pcall(function()
                    for _, o in ipairs(svc.WS:GetDescendants()) do
                        if o.Name == "BloxyCola" or o.Name == "Medkit" then
                            table.insert(esp.cachedItems, o)
                        end
                    end
                end)
            end
            for _, o in ipairs(esp.cachedItems) do addESP(o,"Object",COLORS.Item,o.Name) end
        end
        -- Structures: same caching approach
        if esp.showStructures then
            local now = tick()
            if now - esp.structCacheTime > esp.cacheLife then
                esp.structCacheTime = now
                esp.cachedStructures = {}
                pcall(function()
                    local ig = espGetIngame()
                    if ig then
                        for _, o in ipairs(ig:GetChildren()) do
                            if o.Name == "BuildermanSentry" or o.Name == "SubspaceTripmine" or o.Name == "BuildermanDispenser" then
                                table.insert(esp.cachedStructures, o)
                            end
                        end
                    end
                end)
            end
            for _, o in ipairs(esp.cachedStructures) do addESP(o,"Object",COLORS.Structure,o.Name) end
        end
    end)
end

local function espStart()
    pcall(function()
        espClearAll()
        esp.enabled = true
        if esp.scanThread then task.cancel(esp.scanThread) end
        esp.scanThread = task.spawn(function() while esp.enabled do pcall(espScan); task.wait(esp.scanRate) end end)
    end)
end

local function espStop()
    pcall(function()
        esp.enabled = false
        if esp.scanThread then task.cancel(esp.scanThread) end
        esp.scanThread = nil
        espClearAll()
    end)
end

local function espSetupListeners()
    pcall(function()
        if not lp then return end
        local function onTeamChild(child, team, color)
            task.wait(0.2)
            if esp.enabled and child:IsA("Model") and child ~= lp.Character then
                local h = child:FindFirstChildOfClass("Humanoid")
                if h and h.Health > 0 and esp["show"..team] then espCreate(child, color, child.Name, true) end
            end
        end
        local kf = espGetTeamFolder("Killers")
        if kf then table.insert(esp.connections, kf.ChildAdded:Connect(function(c) onTeamChild(c,"Killers",COLORS.Killer) end)) end
        local sf = espGetTeamFolder("Survivors")
        if sf then table.insert(esp.connections, sf.ChildAdded:Connect(function(c) onTeamChild(c,"Survivors",COLORS.Survivor) end)) end
        table.insert(esp.connections, svc.WS.DescendantAdded:Connect(function(o)
            task.wait(0.1)
            if esp.enabled then
                if o.Name == "Generator" and esp.showGenerators then espCreate(o,COLORS.Generator,"Generator")
                elseif (o.Name == "BloxyCola" or o.Name == "Medkit") and esp.showItems then espCreate(o,COLORS.Item,o.Name)
                elseif esp.showStructures and (o.Name == "BuildermanSentry" or o.Name == "SubspaceTripmine" or o.Name == "BuildermanDispenser") then espCreate(o,COLORS.Structure,o.Name) end
            end
        end))
    end)
end

if lp then lp.CharacterAdded:Connect(function() task.wait(2); if esp.enabled then espClearAll(); espStart() end end) end

task.wait(2)
espSetupListeners()
if esp.enabled then espStart() end

-- Generator label poller — safety net, refreshes all labels every second.
task.spawn(function()
    while true do
        task.wait(1)
        pcall(function()
            for obj, label in pairs(genLabels) do
                if obj and obj.Parent and label and label.Parent then
                    pcall(genUpdateLabel, obj)
                else
                    genRemoveObj(obj)
                end
            end
        end)
    end
end)

-- ESP UI
local mainSection = tabESP:Section({ Title = "Main Settings", Opened = true })

mainSection:Toggle({ Title="Enable ESP", Type="Checkbox", Flag="espEnabled", Default=esp.enabled,
    Callback=function(on) pcall(function() esp.enabled=on; if on then espStart() else espStop() end end) end })

local catSection = tabESP:Section({ Title = "Categories", Opened = true })

catSection:Toggle({ Title="Killers", Type="Checkbox", Flag="espKillers", Default=esp.showKillers,
    Callback=function(on) pcall(function() esp.showKillers=on; if esp.enabled then espClearAll(); espStart() end end) end })

catSection:Toggle({ Title="Survivors", Type="Checkbox", Flag="espSurvivors", Default=esp.showSurvivors,
    Callback=function(on) pcall(function() esp.showSurvivors=on; if esp.enabled then espClearAll(); espStart() end end) end })

catSection:Toggle({ Title="Generators", Type="Checkbox", Flag="espGenerators", Default=esp.showGenerators,
    Callback=function(on) pcall(function() esp.showGenerators=on; if esp.enabled then espClearAll(); espStart() end end) end })

catSection:Toggle({ Title="Items", Type="Checkbox", Flag="espItems", Default=esp.showItems,
    Callback=function(on) pcall(function() esp.showItems=on; if esp.enabled then espClearAll(); espStart() end end) end })

catSection:Toggle({ Title="Structures", Type="Checkbox", Flag="espStructures", Default=esp.showStructures,
    Callback=function(on) pcall(function() esp.showStructures=on; if esp.enabled then espClearAll(); espStart() end end) end })

local visSection = tabESP:Section({ Title = "Visual Settings", Opened = true })

visSection:Slider({ Title="Max Distance", Flag="espMaxDistance", Step=10, Value={Min=50,Max=500,Default=esp.maxDistance},
    Callback=function(v) pcall(function() esp.maxDistance=v; if esp.enabled then espClearAll(); espStart() end end) end })

visSection:Slider({ Title="Highlight Opacity", Flag="espTransparency", Step=0.05, Value={Min=0.1,Max=1.0,Default=esp.transparency},
    Callback=function(v) pcall(function() esp.transparency=v; if esp.enabled then espClearAll(); espStart() end end) end })

visSection:Slider({ Title="Scan Rate (s)", Flag="espScanRate", Step=0.5, Value={Min=0.5,Max=5.0,Default=esp.scanRate},
    Callback=function(v) pcall(function()
        esp.scanRate=v
        -- Restart scan loop with new rate
        if esp.enabled and esp.scanThread then
            task.cancel(esp.scanThread)
            esp.scanThread = task.spawn(function() while esp.enabled do pcall(espScan); task.wait(esp.scanRate) end end)
        end
    end) end })

visSection:Button({ Title="Refresh ESP", Callback=function() pcall(function() if esp.enabled then espClearAll(); espStart() end end) end })

visSection:Button({ Title="Refresh Generator Labels", Callback=function()
    pcall(function()
        for obj in pairs(genLabels) do
            if obj and obj.Parent then genWatchGenerator(obj)
            else genRemoveObj(obj) end
        end
        local mc = espGetMapContent()
        if mc then
            for _, o in ipairs(mc:GetChildren()) do
                if o.Name == "Generator" and o.Parent then
                    if not genLabels[o] then
                        if esp.enabled and not esp.highlights[o] then
                            espCreate(o, COLORS.Generator, "Generator", false)
                        end
                    else
                        genWatchGenerator(o)
                    end
                end
            end
        end
    end)
end })

-- MINION ESP
local secMinion = tabESP:Section({ Title = "Minion & Ability ESP", Opened = true })

local mset = { pizza=false, zombie=false, puddle=false, transparency=0.25 }
local tracked = { pizza={}, zombie={}, puddle={} }

local function isRealPlayer(obj)
    for _, p in ipairs(svc.Players:GetPlayers()) do if p.Character == obj or (p.Character and obj:IsDescendantOf(p.Character)) then return true end end
    return false
end

local function addHighlight(obj, color, tag, label, offset)
    pcall(function()
        if not obj or tracked[tag][obj] or isRealPlayer(obj) then return end
        tracked[tag][obj] = true
        local root = obj
        if obj:IsA("Model") then root = obj:FindFirstChild("HumanoidRootPart") or obj:FindFirstChild("Torso") or obj.PrimaryPart
            if not root then for _, c in ipairs(obj:GetChildren()) do if c:IsA("BasePart") then root=c; break end end end end
        local hl = Instance.new("Highlight"); hl.Name=tag.."_HL"; hl.FillColor=color; hl.FillTransparency=mset.transparency
        hl.OutlineColor=color; hl.OutlineTransparency=0.1; hl.DepthMode=Enum.HighlightDepthMode.AlwaysOnTop
        hl.Adornee=obj; hl.Parent=obj
        if root then
            local bb = Instance.new("BillboardGui"); bb.Name=tag.."_BB"; bb.Adornee=root; bb.Size=UDim2.new(0,130,0,24)
            bb.StudsOffset=Vector3.new(0,offset or 3,0); bb.AlwaysOnTop=true; bb.Parent=obj
            local lbl = Instance.new("TextLabel"); lbl.Size=UDim2.new(1,0,1,0); lbl.BackgroundTransparency=1; lbl.Text=label
            lbl.TextColor3=color; lbl.TextStrokeColor3=Color3.new(0,0,0); lbl.TextStrokeTransparency=0.2
            lbl.TextSize=12; lbl.Font=Enum.Font.GothamBold; lbl.Parent=bb
        end
        obj.AncestryChanged:Connect(function() if obj.Parent then return end
            local h2 = obj:FindFirstChild(tag.."_HL"); if h2 then h2:Destroy() end
            local b2 = obj:FindFirstChild(tag.."_BB"); if b2 then b2:Destroy() end
            tracked[tag][obj] = nil
        end)
    end)
end

local function updateTransparency()
    pcall(function()
        for tag, tbl in pairs(tracked) do for obj in pairs(tbl) do local h=obj:FindFirstChild(tag.."_HL"); if h then h.FillTransparency=mset.transparency end end end
    end)
end

local function clearTag(tag)
    pcall(function()
        for obj in pairs(tracked[tag]) do
            local h=obj:FindFirstChild(tag.."_HL"); if h then h:Destroy() end
            local b=obj:FindFirstChild(tag.."_BB"); if b then b:Destroy() end
            if tag=="puddle" then local h2=obj:FindFirstChild("PuddleHolder"); if h2 then h2:Destroy() end end
        end
        tracked[tag]={}
    end)
end

local function addPuddleHighlight(part, color, tag, label)
    pcall(function()
        if not part or tracked[tag][part] or isRealPlayer(part) then return end
        tracked[tag][part] = true
        local hl = Instance.new("Highlight"); hl.Name=tag.."_HL"; hl.FillColor=color; hl.FillTransparency=mset.transparency
        hl.OutlineColor=color; hl.OutlineTransparency=0.1; hl.DepthMode=Enum.HighlightDepthMode.AlwaysOnTop
        hl.Adornee=part; hl.Parent=part
        task.wait(0.05)
        local radius = math.max(math.max(part.Size.X,part.Size.Z)*0.5,3)
        local holder = Instance.new("Part"); holder.Name="PuddleHolder"; holder.Size=Vector3.new(1,0.1,1)
        holder.Transparency=1; holder.CanCollide=false; holder.Anchored=true
        holder.Position=part.Position+Vector3.new(0,0.05,0); holder.Parent=part
        local bc = Instance.new("CylinderHandleAdornment"); bc.Name="PuddleBlack"; bc.Adornee=holder
        bc.Color3=Color3.fromRGB(0,0,0); bc.Transparency=0.2; bc.Radius=radius; bc.Height=0.02
        bc.CFrame=CFrame.Angles(math.rad(90),0,0); bc.ZIndex=5; bc.AlwaysOnTop=true; bc.Parent=holder
        local ro = Instance.new("CylinderHandleAdornment"); ro.Name="PuddleRed"; ro.Adornee=holder
        ro.Color3=Color3.fromRGB(255,0,0); ro.Transparency=0.4; ro.Radius=radius+0.8; ro.Height=0.02
        ro.CFrame=CFrame.Angles(math.rad(90),0,0); ro.ZIndex=4; ro.AlwaysOnTop=true; ro.Parent=holder
        local bb = Instance.new("BillboardGui"); bb.Name=tag.."_BB"; bb.Adornee=holder
        bb.Size=UDim2.new(0,140,0,20); bb.StudsOffset=Vector3.new(0,1.5,0); bb.AlwaysOnTop=true; bb.Parent=holder
        local lbl = Instance.new("TextLabel"); lbl.Size=UDim2.new(1,0,1,0); lbl.BackgroundTransparency=1
        lbl.Text=label; lbl.TextColor3=Color3.fromRGB(255,255,255)
        lbl.TextStrokeColor3=Color3.fromRGB(255,0,0); lbl.TextStrokeTransparency=0.1
        lbl.TextSize=11; lbl.Font=Enum.Font.GothamBold; lbl.Parent=bb
        part:GetPropertyChangedSignal("Size"):Connect(function()
            if not part.Parent then return end
            local nr = math.max(math.max(part.Size.X,part.Size.Z)*0.5,3)
            bc.Radius=nr; ro.Radius=nr+0.8
        end)
        part.AncestryChanged:Connect(function()
            if part.Parent then return end
            hl:Destroy(); holder:Destroy(); tracked[tag][part]=nil
        end)
    end)
end

local function isJohnDoePuddle(o)
    if not o:IsA("BasePart") or o.Name ~= "Shadow" then return false end
    local p = o.Parent; return p and p.Name:find("Shadows$") ~= nil
end

local function scanPizza() pcall(function() if mset.pizza then for _,o in ipairs(svc.WS:GetDescendants()) do if o.Name=="PizzaDeliveryRig" and o:IsA("Model") and not isRealPlayer(o) and not tracked.pizza[o] then addHighlight(o,Color3.fromRGB(255,100,0),"pizza","C00LKIDD PIZZA DELIVERY",3) end end end end) end

local function scanZombie() pcall(function() if mset.zombie then for _,o in ipairs(svc.WS:GetDescendants()) do if o.Name=="1x1x1x1Zombie" and o:IsA("Model") and not isRealPlayer(o) and not tracked.zombie[o] then addHighlight(o,Color3.fromRGB(80,255,120),"zombie","1X1X1X1 ZOMBIE",3) end end end end) end

local function scanPuddles() pcall(function() if mset.puddle then for _,o in ipairs(svc.WS:GetDescendants()) do if isJohnDoePuddle(o) and not tracked.puddle[o] then addPuddleHighlight(o,Color3.fromRGB(255,50,50),"puddle","JOHN DOE PUDDLE") end end end end) end

task.spawn(function() while true do task.wait(3); scanPizza(); scanZombie(); scanPuddles() end end)

secMinion:Toggle({ Title="c00lkidd Pizza Bots", Type="Checkbox", Flag="espPizza", Default=mset.pizza, Callback=function(on) pcall(function() mset.pizza=on; if on then scanPizza() else clearTag("pizza") end end) end })

secMinion:Toggle({ Title="1x1x1x1 Zombies", Type="Checkbox", Flag="espZombie", Default=mset.zombie, Callback=function(on) pcall(function() mset.zombie=on; if on then scanZombie() else clearTag("zombie") end end) end })

secMinion:Toggle({ Title="JD Digital Footprints", Type="Checkbox", Flag="espPuddle", Default=mset.puddle, Callback=function(on) pcall(function() mset.puddle=on; if on then scanPuddles() else clearTag("puddle") end end) end })

secMinion:Slider({ Title="Highlight Transparency", Flag="espMinionTrans", Step=0.05, Value={Min=0,Max=1,Default=mset.transparency}, Callback=function(v) pcall(function() mset.transparency=v; updateTransparency() end) end })

secMinion:Button({ Title="Force Rescan", Callback=function() pcall(function() clearTag("pizza"); clearTag("zombie"); clearTag("puddle"); task.wait(0.1); scanPizza(); scanZombie(); scanPuddles() end) end })

-- ============================================================
-- MUSIC TAB
-- ============================================================

end -- tabESP
do -- tabMusic
local tabMusic = win:Tab({ Title = "Music", Icon = "music" })
local secLMS   = tabMusic:Section({ Title = "LMS Music", Opened = true })

local music = {
    on = false, selected = "CondemnedLMS", cached = {}, origId = nil,
    thread = nil, lastSoundCheck = 0, cachedSound = nil,
}

local musicDir = "v1prware/LMS_Songs"
if not fs.hasFolder("v1prware") then fs.makeFolder("v1prware") end
if not fs.hasFolder(musicDir) then fs.makeFolder(musicDir) end

local ghBase = "https://raw.githubusercontent.com/r3take/lmsstuff/main/"
local musicTracks = {
    AbberantLMS=ghBase.."AbberantLMS.mp3", OvertimeLMS=ghBase.."OvertimeLMS.mp3",
    PhotoshopLMS=ghBase.."PhotoshopLMS.mp3", JX1DX1LMS=ghBase.."JX1DX1LMS.mp3",
    CondemnedLMS=ghBase.."CondemnedLMS.mp3", GeometryLMS=ghBase.."GeometryLMS.mp3",
    SixerVsNoobLMS=ghBase.."SixerVsNoobLMS.mp3", Milestone4LMS=ghBase.."MS4LMS.mp3",
    BluududLMS=ghBase.."BluududLMS.mp3", JohnDoeLMS=ghBase.."JohnDoeLMS.mp3",
    EternalIShallEndure=ghBase.."EternallShallEndure.mp3",
    ChanceVSMafiosoLMS=ghBase.."ChanceVSMafioso.mp3",
    MafiosoVsChanceLMS=ghBase.."ChanceVSMafioso.mp3",
    JohnVsJaneLMS=ghBase.."JohnVSJaneLMS.mp3",
    SynonymsForEternity=ghBase.."synonymsforeternity.mp3",
    EternityEpicfied=ghBase.."EternityEpicfied.mp3",
    EternalHopeEternalFight=ghBase.."EternalHopeEternalFight.mp3",
    SlasherVSGuest=ghBase.."slashervguestlms.mp3", Debth=ghBase.."Debth.mp3",
    ShatteredHopes=ghBase.."ShatteredHopesLMS.mp3", EmberRageLMS=ghBase.."emberragelms.mp3",
    SprunkinLMS=ghBase.."SPRUNKINLMS.mp3", AzureVSTwoTimeLMS=ghBase.."azurevstwotimelms.mp3",
    AshleLMS=ghBase.."Ashlelms.mp3", MeetYourMaking=ghBase.."MeetYourMaking.mp3",
    ReceadingLifespan=ghBase.."ReceadingLifespan.mp3", PhoenixLMS=ghBase.."phoenixlms.mp3",
    JerseyDebth=ghBase.."JerseyDebth.mp3",
}

local musicList = {}
for k in pairs(musicTracks) do table.insert(musicList, k) end
table.sort(musicList)

local MUSIC_DIR = "v1prware/Music"

local function musicTrackPath(name) return MUSIC_DIR.."/"..name..".mp3" end

local function musicHttpGet(url) local ok,d=pcall(function() return game:HttpGet(url) end); return ok and d or nil end

local function musicFetch(name)
    pcall(function()
        if music.cached[name] then return music.cached[name] end
        local url = musicTracks[name]; if not url then return nil end
        if not fs.hasFolder(MUSIC_DIR) then fs.makeFolder(MUSIC_DIR) end
        local path = musicTrackPath(name)
        if not fs.hasFile(path) then
            local data = musicHttpGet(url); if not data then return nil end
            pcall(function() fs.write(path,data) end)
        end
        local ok, asset = pcall(function() return fs.asset(path) end)
        if ok and asset then music.cached[name]=asset; return asset end
        return nil
    end)
end

local musicFetchInFlight = {}

local function musicFetchAsync(name, cb)
    if music.cached[name] then if cb then cb(music.cached[name]) end; return end
    if musicFetchInFlight[name] then return end
    musicFetchInFlight[name] = true
    task.spawn(function()
        local asset = musicFetch(name)
        musicFetchInFlight[name] = nil
        if asset and cb then cb(asset) end
    end)
end

local function musicGetSound()
    local now = tick()
    if music.cachedSound and music.cachedSound.Parent and (now - music.lastSoundCheck) < 0.5 then return music.cachedSound end
    music.lastSoundCheck = now
    local snd = svc.WS:FindFirstChild("Themes") and svc.WS.Themes:FindFirstChild("LastSurvivor")
        or svc.WS:FindFirstChild("LastSurvivor", true) or svc.SoundService:FindFirstChild("LastSurvivor", true)
    if snd and snd:IsA("Sound") then music.cachedSound=snd; return snd end
    music.cachedSound=nil; return nil
end

local function musicPlay(name)
    pcall(function()
        local snd = musicGetSound(); if not snd then return false end
        if not music.origId then music.origId = snd.SoundId end
        local asset = musicFetch(name); if not asset then return false end
        if snd.SoundId ~= asset then snd.SoundId=asset; snd:Stop(); task.wait(0.05); snd:Play()
        elseif not snd.IsPlaying then snd:Play() end
        return true
    end)
end

local function musicReset()
    pcall(function()
        local snd = musicGetSound()
        if snd and music.origId then snd.SoundId=music.origId; snd:Stop(); task.wait(0.05); snd:Play() end
    end)
end

local function musicMonitor()
    while music.on do
        pcall(function()
            local snd = musicGetSound()
            if snd then
                local asset = music.cached[music.selected]
                if asset then
                    if snd.SoundId ~= asset then
                        if not music.origId then music.origId = snd.SoundId end
                        snd.SoundId=asset; snd:Stop(); task.wait(0.05); snd:Play()
                    elseif not snd.IsPlaying then snd:Play() end
                else
                    musicFetchAsync(music.selected, function(a)
                        local s = musicGetSound(); if s then
                            if not music.origId then music.origId = s.SoundId end
                            s.SoundId=a; s:Stop(); task.wait(0.05); s:Play()
                        end
                    end)
                end
            end
        end)
        task.wait(1)
    end
end

secLMS:Toggle({ Title="Auto-Play on LMS", Type="Checkbox", Flag="musicOn", Default=music.on,
    Callback=function(on) pcall(function() music.on=on; if on then musicFetchAsync(music.selected); music.thread=task.spawn(musicMonitor) else if music.thread then task.cancel(music.thread); music.thread=nil end; musicReset() end end) end })

secLMS:Dropdown({ Title="Track", Flag="musicSel", Values=musicList, Value=music.selected,
    Callback=function(sel) pcall(function() music.selected=type(sel)=="table" and sel[1] or sel; task.spawn(function() musicFetchAsync(music.selected) end) end) end })

secLMS:Button({ Title="Play", Callback=function() pcall(function() musicPlay(music.selected) end) end })

secLMS:Button({ Title="Stop", Callback=function() pcall(function() musicReset() end) end })

secLMS:Button({ Title="Preload LMS", Callback=function() pcall(function() for name in pairs(musicTracks) do musicFetchAsync(name); task.wait(0.05) end end) end })

-- ============================================================
-- CHARACTER TAB
-- ============================================================

end -- tabMusic
do
local tabChar = win:Tab({ Title = "Character", Icon = "user" })
local secSentinels = tabChar:Section({ Title = "Sentinels", Opened = true })
secSentinels:Button({ Title="Guest1337", Callback=function() pcall(function() loadstring(game:HttpGet("https://raw.githubusercontent.com/r3take/Forsakan/refs/heads/main/Guest"))() end) end })
secSentinels:Button({ Title="Chance",    Callback=function() pcall(function() loadstring(game:HttpGet("https://pastebin.com/raw/XnXQY5VD"))() end) end })
secSentinels:Button({ Title="TwoTime",   Callback=function() pcall(function() loadstring(game:HttpGet("https://raw.githubusercontent.com/r3take/Forsakan/refs/heads/main/viperstab"))() end) end })
secSentinels:Button({ Title="Jane Doe",  Callback=function() pcall(function() loadstring(game:HttpGet("https://raw.githubusercontent.com/bezenadduca-code/Ok/refs/heads/main/Jane%20doe"))() end) end })
local secSupports = tabChar:Section({ Title = "Supports", Opened = true })
secSupports:Button({ Title="Dusekkar", Callback=function() pcall(function() loadstring(game:HttpGet("https://pastebin.com/raw/ugJKrDyw"))() end) end })
secSupports:Button({ Title="Elliot",   Callback=function() pcall(function() loadstring(game:HttpGet("https://raw.githubusercontent.com/bezenadduca-code/Noob/refs/heads/main/elliot_aimbot_windui.lua"))() end) end })
end

-- ============================================================
-- INTERFACE TAB
-- ============================================================
do
local tabInterface = win:Tab({ Title = "Interface", Icon = "scan" })
local secUIFunctions = tabInterface:Section({ Title = "UI Functions", Opened = true })

secUIFunctions:Button({ Title = "Close UI", Callback = function()
    pcall(function()
        local ok = pcall(function() win:Destroy() end)
        if not ok then pcall(function() win:Close() end) end
    end)
end })

-- CONFIG SHARE
local secConfigShare = tabInterface:Section({ Title = "Config Share", Opened = true })

local B64CHARS = "ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz0123456789+/"

local function b64Encode(str)
    local result = {}
    local bytes = {string.byte(str, 1, #str)}
    for i = 1, #bytes, 3 do
        local b1,b2,b3 = bytes[i] or 0, bytes[i+1] or 0, bytes[i+2] or 0
        local n = b1*65536 + b2*256 + b3
        result[#result+1] = B64CHARS:sub(math.floor(n/262144)%64+1, math.floor(n/262144)%64+1)
        result[#result+1] = B64CHARS:sub(math.floor(n/4096)%64+1, math.floor(n/4096)%64+1)
        result[#result+1] = bytes[i+1] and B64CHARS:sub(math.floor(n/64)%64+1, math.floor(n/64)%64+1) or "="
        result[#result+1] = bytes[i+2] and B64CHARS:sub(n%64+1, n%64+1) or "="
    end
    return table.concat(result)
end

local function b64Decode(str)
    local lookup = {}; for i=1,#B64CHARS do lookup[B64CHARS:sub(i,i)] = i-1 end
    local bytes = {}
    for i = 1, #str, 4 do
        local c1 = lookup[str:sub(i,i)] or 0; local c2 = lookup[str:sub(i+1,i+1)] or 0
        local c3 = lookup[str:sub(i+2,i+2)]; local c4 = lookup[str:sub(i+3,i+3)]
        local n = c1*262144 + c2*4096 + (c3 or 0)*64 + (c4 or 0)
        bytes[#bytes+1] = string.char(math.floor(n/65536)%256)
        if c3 then bytes[#bytes+1] = string.char(math.floor(n/256)%256) end
        if c4 then bytes[#bytes+1] = string.char(n%256) end
    end
    return table.concat(bytes)
end

local CONFIG_PATH = "WindUI/v1prware/config/v1prware.json"

secConfigShare:Button({
    Title = "📋 Copy Config",
    Icon = "copy",
    Callback = function()
        pcall(function()
            local ok,e = pcall(function()
                local raw = readfile(CONFIG_PATH)
                setclipboard("v1prw_full:"..b64Encode(raw))
                print("[v1prware] Config copied!")
            end)
            if not ok then print("[v1prware] Copy failed: "..tostring(e)) end
        end)
    end
})

local importStr = ""

secConfigShare:Input({
    Title = "Paste Config String",
    Icon = "clipboard",
    Placeholder = "v1prw_full:...",
    Callback = function(v) pcall(function() importStr = v end) end
})

secConfigShare:Button({
    Title = "🔄 Load Config",
    Icon = "download",
    Callback = function()
        pcall(function()
            if importStr == "" then print("[v1prware] Paste a config string first"); return end
            if importStr:match("^v1prw_full:") then
                local ok,e = pcall(function()
                    local d = b64Decode(importStr:sub(12))
                    writefile(CONFIG_PATH, d)
                    v1prConfig:Load()
                    applyConfigFromFlags()
                end)
                if ok then print("[v1prware] Config loaded!") else print("[v1prware] Load failed: "..tostring(e)) end
            else
                print("[v1prware] Must start with v1prw_full:")
            end
        end)
    end
})

secConfigShare:Button({
    Title = "💾 Save Config",
    Icon = "save",
    Callback = function() pcall(function() v1prConfig:Save(); print("[v1prware] Config saved") end) end
})

end -- interface tab
-- ============================================================
-- CONFIG APPLY
-- ============================================================

function applyConfigFromFlags()
    pcall(function()
        task.wait(0.5)
        if not (win and win.Flags) then return end
        print("[v1prware] Applying config flags...")
        
        if win.Flags.spoofActive ~= nil then spoofActive=win.Flags.spoofActive; if spoofActive then spoofStart() else spoofStop() end end
        if win.Flags.chatForceEnabled ~= nil then chatForceEnabled=win.Flags.chatForceEnabled; if chatForceConn then chatForceConn:Disconnect(); chatForceConn=nil end; if chatForceEnabled then enforceChatOn(); chatForceConn=svc.Run.Heartbeat:Connect(enforceChatOn) end end
        if win.Flags.timerSide ~= nil then timerSide=type(win.Flags.timerSide)=="table" and win.Flags.timerSide[1] or win.Flags.timerSide; applyTimerPos() end
        if win.Flags.platEnabled ~= nil then platEnabled=win.Flags.platEnabled; if platEnabled then platStart() else platStop() end end
        if win.Flags.platDevice ~= nil then platDevice=win.Flags.platDevice end
        if win.Flags.stamOn ~= nil then stam.on=win.Flags.stamOn end
        if win.Flags.stamNoLoss ~= nil then stam.noLoss=win.Flags.stamNoLoss end
        if type(win.Flags.stamLoss)=="number" then stam.loss=win.Flags.stamLoss end
        if type(win.Flags.stamGain)=="number" then stam.gain=win.Flags.stamGain end
        if type(win.Flags.stamMax)=="number" then stam.max=win.Flags.stamMax end
        if type(win.Flags.stamCurrent)=="number" then stam.current=win.Flags.stamCurrent end
        if stam.on or stam.noLoss then stamStart() end; if stam.noLoss then stamApply() end
        if win.Flags.speedOn ~= nil then speedHack.on=win.Flags.speedOn; if speedHack.on then speedStart() end end
        if type(win.Flags.speedValue)=="number" then speedHack.speed=win.Flags.speedValue; speedHack.lastApplied=0 end
        if win.Flags.hbOn ~= nil then hb.on=win.Flags.hbOn; if hb.on then hbStart() else hbStop() end end
        if type(win.Flags.hbStrength)=="number" then hb.strength=win.Flags.hbStrength end
        if win.Flags.acOn ~= nil then ac.on=win.Flags.acOn; if not ac.on then for k in pairs(ac.active) do ac.active[k]=nil end; ac.chaseTarget=nil; ac.damageTarget=nil end end
        if type(win.Flags.acStrength)=="number" then ac.strength=win.Flags.acStrength end
        if type(win.Flags.acMaxDist)=="number" then ac.maxDist=win.Flags.acMaxDist end
        if win.Flags.flowOn ~= nil then flow.on=win.Flags.flowOn end
        if type(win.Flags.flowNodeDelay)=="number" then flow.nodeDelay=win.Flags.flowNodeDelay end
        if type(win.Flags.flowLineDelay)=="number" then flow.lineDelay=win.Flags.flowLineDelay end
        if win.Flags.aimOn ~= nil then aim.on=win.Flags.aimOn end
        if type(win.Flags.aimCooldown)=="number" then aim.cooldown=win.Flags.aimCooldown end
        if type(win.Flags.aimLockTime)=="number" then aim.lockTime=win.Flags.aimLockTime end
        if type(win.Flags.aimMaxDist)=="number" then aim.maxDist=win.Flags.aimMaxDist end
        if type(win.Flags.aimSmooth)=="number" then aim.smooth=win.Flags.aimSmooth end
        if not aim.on then aimUnlock() end
        if win.Flags.absOn ~= nil then abs.on=win.Flags.absOn; if abs.on then absStart() else absStop() end end
        if type(win.Flags.absRange)=="number" then abs.range=win.Flags.absRange end
        if type(win.Flags.absDur)=="number" then abs.duration=win.Flags.absDur end
        if win.Flags.sixerStrafeOn ~= nil then sixerStrafeOn=win.Flags.sixerStrafeOn end
        if win.Flags.coolkidWSOOn ~= nil then coolkidWSOOn=win.Flags.coolkidWSOOn end
        if win.Flags.noliVoidRushOn ~= nil then noliVoidRushOn=win.Flags.noliVoidRushOn; if not noliVoidRushOn then noliStop() end end
        if win.Flags.qteOn ~= nil then qte.on = win.Flags.qteOn; if qte.on then qteStart() else qteStop() end end
        if type(win.Flags.qteSpeed)=="number" then qte.speed = win.Flags.qteSpeed end
        if win.Flags.batsAimOn ~= nil then batsAim.on=win.Flags.batsAimOn end
        if type(win.Flags.batsPrediction)=="number" then batsAim.prediction=win.Flags.batsPrediction end
        if type(win.Flags.batsDepthOffset)=="number" then batsAim.depthOffset=win.Flags.batsDepthOffset end
        if type(win.Flags.batsMaxDist)=="number" then batsAim.maxDist=win.Flags.batsMaxDist end
        if win.Flags.espEnabled ~= nil then esp.enabled=win.Flags.espEnabled; if esp.enabled then espStart() else espStop() end end
        if win.Flags.espKillers ~= nil then esp.showKillers=win.Flags.espKillers end
        if win.Flags.espSurvivors ~= nil then esp.showSurvivors=win.Flags.espSurvivors end
        if win.Flags.espGenerators ~= nil then esp.showGenerators=win.Flags.espGenerators end
        if win.Flags.espItems ~= nil then esp.showItems=win.Flags.espItems end
        if win.Flags.espStructures ~= nil then esp.showStructures=win.Flags.espStructures end
        if win.Flags.espPizza ~= nil then mset.pizza=win.Flags.espPizza end
        if win.Flags.espZombie ~= nil then mset.zombie=win.Flags.espZombie end
        if win.Flags.espPuddle ~= nil then mset.puddle=win.Flags.espPuddle end
        if type(win.Flags.espMaxDistance)=="number" then esp.maxDistance=win.Flags.espMaxDistance end
        if type(win.Flags.espTransparency)=="number" then esp.transparency=win.Flags.espTransparency end
        if type(win.Flags.espScanRate)=="number" then esp.scanRate=win.Flags.espScanRate end
        if type(win.Flags.espMinionTrans)=="number" then mset.transparency=win.Flags.espMinionTrans; updateTransparency() end
        if win.Flags.musicOn ~= nil then music.on=win.Flags.musicOn; if music.on then if music.thread then task.cancel(music.thread) end; music.thread=task.spawn(musicMonitor) else if music.thread then task.cancel(music.thread); music.thread=nil end; musicReset() end end
        if win.Flags.musicSel ~= nil then music.selected=win.Flags.musicSel end
        
        print("[v1prware] All features restored from config!")
    end)
end

task.spawn(function()
    while true do task.wait(2); pcall(function() v1prConfig:Save() end) end
end)

task.spawn(function()
    pcall(function()
        task.wait(1.5)
        pcall(function() v1prConfig:Load() end)
        task.defer(function()
            print("[v1prware] Syncing flags...")
            if win and win.Flags then applyConfigFromFlags() else print("[v1prware] win.Flags not yet available") end
        end)
    end)
end)

print("[v1prware] Loaded successfully")

end) -- End of main pcall

-- Error handling
if not success then
    local errMsg = tostring(err)
    warn("V1PRWARE failed to load: " .. errMsg)
    print("V1PRWARE encountered an error: " .. errMsg)
    flashError(errMsg)
end
