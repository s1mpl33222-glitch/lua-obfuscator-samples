if not game:IsLoaded() then game.Loaded:Wait() end

local Players = game:GetService("Players")
local CoreGui = game:GetService("CoreGui")
local RunService = game:GetService("RunService")
local UserInputService = game:GetService("UserInputService")
local TweenService = game:GetService("TweenService")
local Workspace = game:GetService("Workspace")
local Lighting = game:GetService("Lighting")
local LocalPlayer = Players.LocalPlayer

local Ghost = {Active = true}
local function GR(len) local c = "abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789_"; local s = ""; for i = 1, len do s = s .. c:sub(math.random(1, #c), math.random(1, #c)) end; return s end

function Ghost:DeepObfuscate(gui) 
    pcall(function() 
        gui.Name = "RobloxGui" 
        for _, obj in ipairs(gui:GetDescendants()) do 
            pcall(function() 
                if obj:IsA("Frame") then obj.Name = GR(math.random(8, 16)) end
                if obj:IsA("TextLabel") then obj.Name = GR(math.random(6, 14)) end
                if obj:IsA("TextButton") then obj.Name = GR(math.random(7, 15)) end
                if obj:IsA("ScrollingFrame") then obj.Name = GR(math.random(5, 12)) end
                if obj:IsA("ImageLabel") then obj.Name = GR(math.random(6, 13)) end
                if obj:IsA("TextBox") then obj.Name = GR(math.random(5, 10)) end
            end) 
        end 
    end) 
end

function Ghost:CoreGuiMask(gui) 
    pcall(function() 
        gui.Parent = CoreGui 
        if CoreGui:FindFirstChild("RobloxGui") then 
            local r = CoreGui.RobloxGui 
            local f = Instance.new("Frame", r) 
            f.Size = UDim2.new(0, 0, 0, 0) 
            f.Name = GR(10) 
            f.Visible = false 
        end 
    end) 
end

function Ghost:KillTimeBombScanners() 
    coroutine.wrap(function() 
        while Ghost.Active do 
            pcall(function() 
                for _, v in ipairs(game:GetDescendants()) do 
                    if v:IsA("Script") or v:IsA("LocalScript") or v:IsA("ModuleScript") then 
                        local src = pcall(function() return v.Source end) and v.Source or "" 
                        local ls = src:lower() 
                        if ls:match("timebomb") or ls:match("anticheat") or ls:match("detection") or ls:match("scanner") or ls:match("exploit") or ls:match("hack") or ls:match("cheat") or ls:match("kick") or ls:match("ban") then 
                            v.Enabled = false 
                            v.Disabled = true 
                            pcall(function() v:Destroy() end) 
                        end 
                    end 
                    if v:IsA("RemoteEvent") or v:IsA("RemoteFunction") then 
                        local n = v.Name:lower() 
                        if n:match("detect") or n:match("ban") or n:match("kick") or n:match("scan") then 
                            pcall(function() v:Destroy() end) 
                        end 
                    end 
                end 
                for _, v in ipairs(Workspace:GetDescendants()) do 
                    if v:IsA("Script") or v:IsA("LocalScript") then 
                        local src = pcall(function() return v.Source end) and v.Source or "" 
                        if src:lower():match("bomb") or src:lower():match("detect") then 
                            v.Enabled = false 
                        end 
                    end 
                end 
            end) 
            task.wait(math.random(3, 7)) 
        end 
    end)() 
end

function Ghost:NetworkMask() 
    coroutine.wrap(function() 
        while Ghost.Active do 
            pcall(function() 
                local f = Instance.new("RemoteEvent") 
                f.Name = GR(12) 
                task.wait(0.1) 
                f:Destroy() 
            end) 
            task.wait(math.random(5, 12)) 
        end 
    end)() 
end

function Ghost:AntiKickShield() 
    LocalPlayer.OnKicked:Connect(function(msg) 
        pcall(function() 
            task.wait(0.5) 
            game:GetService("TeleportService"):Teleport(game.PlaceId, LocalPlayer) 
        end) 
    end) 
end

function Ghost:PlayerGuiShield() 
    coroutine.wrap(function() 
        while Ghost.Active do 
            pcall(function() 
                local pg = LocalPlayer:FindFirstChild("PlayerGui") 
                if pg then 
                    for _, v in ipairs(pg:GetChildren()) do 
                        if v:IsA("ScreenGui") and v.Name ~= "RobloxGui" then 
                            pcall(function() v.Enabled = true end) 
                        end 
                    end 
                end 
            end) 
            task.wait(math.random(2, 5)) 
        end 
    end)() 
end

function Ghost:AntiTeleportDetect() 
    coroutine.wrap(function() 
        while Ghost.Active do 
            pcall(function() 
                if LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("Humanoid") then 
                    local h = LocalPlayer.Character.Humanoid 
                    if h.WalkSpeed > 16 and h.WalkSpeed < 30 then end 
                end 
            end) 
            task.wait(math.random(10, 20)) 
        end 
    end)() 
end

local PROTECTED_TEXTS = {
    "LOL HOP V1",
    "tiktok · lolhopsc",
    "lolhopsc",
}

local function checkIntegrity()
    for _, text in pairs(PROTECTED_TEXTS) do
        local found = false
        for _, obj in ipairs(CoreGui:GetDescendants()) do
            if obj:IsA("TextLabel") or obj:IsA("TextButton") then
                if obj.Text and string.find(obj.Text, text) then
                    found = true
                    break
                end
            end
        end
        if not found then
            game:Shutdown()
            return
        end
    end
end

local autoMode = "Classic"
local isTracking = false
local targetNumber = 5
local KEEP_DISTANCE = 3.5
local wallDistance = 2.5
local wallHopEnabled = true
local debounceJump = true
local flickEnabled = false
local flickPower = 45
local isFlicking = false
local flickConnection = nil
local stretchEnabled = false
local stretchConn = nil
local fpsEnabled = false
local escapeMode = false
local escConn = nil
local escapeStep = 0
local hadTool = false
local cam = workspace.CurrentCamera

local selectedLanguage = "English"

local Translations = {
    English = {
        Welcome = "Welcome",
        COMBAT = "COMBAT",
        Auto = "Auto",
        ClassicMode = "Classic Mode",
        ProMode = "Pro Mode",
        SETTINGS = "SETTINGS",
        MaxNumber = "Max Number",
        KeepDistance = "Keep Distance",
        WallDistance = "Wall Distance",
        Flick = "Flick",
        FlickPower = "Flick Power",
        StretchScreen = "Stretch Screen",
        FPSBoost = "FPS Boost",
        Escape = "Escape",
        PING = "PING",
        SelectLanguage = "SELECT LANGUAGE",
        ChooseLanguage = "Choose your language",
        English = "ENGLISH",
        Arabic = "العربية",
        Title = "LOL HOP V1",
        PingText = "PING",
        WelcomeText = "Welcome, ",
    },
    Arabic = {
        Welcome = "مرحبا بك",
        COMBAT = "اعدادات المبارزة",
        Auto = "اللعب الذاتي",
        ClassicMode = "اللعب الذاتي الكلاسيكي",
        ProMode = "اللعب الذاتي الاحترافي",
        SETTINGS = "الاعدادات",
        MaxNumber = "الحد الأقصى (للنقاط)",
        KeepDistance = "مسافة التتبع",
        WallDistance = "مسافة الجدار",
        Flick = "الالتفاف السريع",
        FlickPower = "قوة الالتفاف",
        StretchScreen = "تمديد الشاشه (زياده العرض)",
        FPSBoost = "زياده السلاسه (الفريمات)",
        Escape = "الهروب",
        PING = "البينق",
        SelectLanguage = "اختر اللغة",
        ChooseLanguage = "اختر لغتك",
        English = "ENGLISH",
        Arabic = "العربية",
        Title = "LOL HOP V1",
        PingText = "البينق",
        WelcomeText = "مرحبا بك، ",
    }
}

local function T(key)
    return Translations[selectedLanguage][key] or key
end

local function hasTool(plr)
    local c = plr and plr.Character
    if not c then return false end
    for _, v in ipairs(c:GetChildren()) do 
        if v:IsA("Tool") then return true end 
    end 
    return false 
end

local function getClosest()
    if not LocalPlayer.Character or not LocalPlayer.Character:FindFirstChild("HumanoidRootPart") then 
        return nil, 999 
    end
    local mp = LocalPlayer.Character.HumanoidRootPart.Position
    local cp, cd = nil, 999
    for _, p in ipairs(Players:GetPlayers()) do 
        if p ~= LocalPlayer and p.Character and p.Character:FindFirstChild("HumanoidRootPart") then 
            local d = (p.Character.HumanoidRootPart.Position - mp).Magnitude 
            if d < cd then cd = d; cp = p end 
        end 
    end 
    return cp, cd 
end

local function getNum(plr)
    if not plr or not plr.Character then return nil end
    for _, t in pairs(plr.Character:GetChildren()) do 
        if t:IsA("Tool") then 
            for _, ch in pairs(t:GetDescendants()) do 
                if ch:IsA("BillboardGui") then 
                    for _, gc in pairs(ch:GetDescendants()) do 
                        if gc:IsA("TextLabel") and gc.Text ~= "" then 
                            local n = tonumber(gc.Text) 
                            if n then return n end 
                        end 
                    end 
                end 
                if ch:IsA("Highlight") then 
                    local n = tonumber(ch.Name) 
                    if n then return n end 
                end 
            end 
            local n = tonumber(t.Name) 
            if n then return n end 
        end 
    end 
    return nil 
end

local function startAuto()
    isTracking = true
    local conn = RunService.Heartbeat:Connect(function()
        if not isTracking then conn:Disconnect() return end
        if not LocalPlayer.Character or not LocalPlayer.Character:FindFirstChild("Humanoid") then return end
        local h = LocalPlayer.Character.Humanoid
        local t, d = getClosest()
        if not t or not t.Character or not t.Character:FindFirstChild("HumanoidRootPart") then return end
        local mn = getNum(LocalPlayer)
        local tn = getNum(t)
        local chase = false
        if autoMode == "Classic" then 
            if hasTool(LocalPlayer) or hasTool(t) then 
                if mn and mn <= targetNumber then chase = true end
                if tn and tn <= targetNumber then chase = true end
                if not hasTool(LocalPlayer) and hasTool(t) then chase = true end 
            end 
        elseif autoMode == "Pro" then 
            if hasTool(LocalPlayer) and mn and mn <= targetNumber then chase = true end 
        end 
        if chase then 
            h.WalkSpeed = 21 
            if d <= KEEP_DISTANCE then 
                local dir = (LocalPlayer.Character.HumanoidRootPart.Position - t.Character.HumanoidRootPart.Position).Unit 
                h:MoveTo(t.Character.HumanoidRootPart.Position + dir * KEEP_DISTANCE) 
            else 
                h:MoveTo(t.Character.HumanoidRootPart.Position) 
            end 
        end 
    end)
end

local function stopAuto()
    isTracking = false 
    escapeMode = false 
    if LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("Humanoid") then 
        LocalPlayer.Character.Humanoid.WalkSpeed = 16 
    end 
end

local function doFlick()
    if isFlicking then return end
    if not LocalPlayer.Character or not LocalPlayer.Character:FindFirstChild("HumanoidRootPart") then return end
    if not hasTool(LocalPlayer) then return end
    
    isFlicking = true
    local root = LocalPlayer.Character.HumanoidRootPart
    local duration = 1.5
    local cycleCounter = 0
    local currentDirection = 1
    
    flickConnection = RunService.RenderStepped:Connect(function()
        if not root or not root.Parent then 
            if flickConnection then flickConnection:Disconnect() end
            isFlicking = false
            return 
        end
        cycleCounter = cycleCounter + 1
        if cycleCounter % 5 == 0 then
            task.wait(math.random(1, 3) / 100)
            if math.random(1, 10) > 7 then currentDirection = -currentDirection end
        end
        local humanizer = math.random(36, 42) * currentDirection
        root.CFrame = root.CFrame * CFrame.Angles(0, math.rad(humanizer), 0)
    end)
    
    task.wait(duration)
    if flickConnection then 
        flickConnection:Disconnect() 
        flickConnection = nil 
    end
    isFlicking = false
end

local function toggleFlick(state)
    flickEnabled = state
    if state then
        task.spawn(function()
            while flickEnabled do
                if hasTool(LocalPlayer) then
                    local _, d = getClosest()
                    if d <= KEEP_DISTANCE then
                        doFlick()
                    end
                end
                task.wait(0.5)
            end
        end)
    else
        if flickConnection then 
            flickConnection:Disconnect() 
            flickConnection = nil 
        end
        isFlicking = false
    end
end

coroutine.wrap(function()
    while true do
        if isTracking and escapeMode then
            local htn = hasTool(LocalPlayer)
            if not hadTool and htn and not escConn then
                escapeStep = 1
                escConn = RunService.Heartbeat:Connect(function()
                    if escapeStep == 1 then
                        local c = LocalPlayer.Character
                        if not c then return end
                        local r = c:FindFirstChild("HumanoidRootPart")
                        local h = c:FindFirstChildOfClass("Humanoid")
                        if not r or not h then return end
                        local t, d = getClosest()
                        if t then 
                            h.WalkSpeed = 30 
                            local dir = (r.Position - t.Character.HumanoidRootPart.Position).Unit 
                            h:MoveTo(r.Position + dir * 10) 
                        end 
                        task.wait(0.5) 
                        escapeStep = 2
                    elseif escapeStep == 2 then
                        local c = LocalPlayer.Character
                        if not c then return end
                        local r = c:FindFirstChild("HumanoidRootPart")
                        local h = c:FindFirstChildOfClass("Humanoid")
                        if not r or not h then return end
                        local t, d = getClosest()
                        if t then 
                            h.WalkSpeed = 21 
                            h:MoveTo(t.Character.HumanoidRootPart.Position) 
                        end 
                    end
                end)
            end
            if hadTool and not htn then escapeStep = 2 end
            hadTool = htn
        else 
            hadTool = false 
            escapeStep = 0 
            if escConn then escConn:Disconnect(); escConn = nil end 
        end 
        task.wait(0.2) 
    end 
end)()

local function updateStretch()
    if stretchConn then stretchConn:Disconnect(); stretchConn = nil end
    if not stretchEnabled then return end
    stretchConn = RunService.RenderStepped:Connect(function()
        cam.CFrame = cam.CFrame * CFrame.new(0, 0, 0, 1, 0, 0, 0, 0.75, 0, 0, 0, 1) 
    end) 
end

local function applyFPS()
    if not fpsEnabled then return end
    Lighting.Ambient = Color3.fromRGB(255, 255, 255)
    Lighting.OutdoorAmbient = Color3.fromRGB(255, 255, 255)
    Lighting.GlobalShadows = false
    pcall(function() settings().Rendering.QualityLevel = Enum.QualityLevel.Level01 end)
    local function h(o)
        if o:IsA("BasePart") then 
            o.Material = Enum.Material.SmoothPlastic 
            o.Reflectance = 0 
        end 
    end
    Workspace.DescendantAdded:Connect(h)
    for _, v in pairs(Workspace:GetDescendants()) do h(v) end
end

local rP = RaycastParams.new()
rP.FilterType = Enum.RaycastFilterType.Blacklist

local function getWall()
    local c = LocalPlayer.Character
    if not c then return nil end
    local r = c:FindFirstChild("HumanoidRootPart")
    if not r then return nil end
    rP.FilterDescendantsInstances = {c}
    local dirs = {r.CFrame.LookVector, -r.CFrame.LookVector, r.CFrame.RightVector, -r.CFrame.RightVector}
    local h, md = nil, wallDistance + 1
    for _, d in pairs(dirs) do 
        local ry = workspace:Raycast(r.Position, d * wallDistance, rP)
        if ry and ry.Instance and ry.Distance < md then 
            md = ry.Distance 
            h = ry 
        end 
    end 
    return h 
end

UserInputService.JumpRequest:Connect(function()
    if not wallHopEnabled or not debounceJump then return end
    local c = LocalPlayer.Character
    local h = c and c:FindFirstChildOfClass("Humanoid")
    local r = c and c:FindFirstChild("HumanoidRootPart")
    if not (h and r) then return end
    local w = getWall()
    if w then 
        debounceJump = false
        local wn = w.Normal
        local hwn = Vector3.new(wn.X, 0, wn.Z).Unit
        if hwn.Magnitude < 0.1 then 
            hwn = (r.CFrame.LookVector * Vector3.new(1, 0, 1)).Unit 
        end
        local b = hwn
        local cl = workspace.CurrentCamera.CFrame.LookVector
        local hcl = Vector3.new(cl.X, 0, cl.Z).Unit
        local ma = math.rad(40)
        local dt = math.clamp(b:Dot(hcl), -1, 1)
        local ab = math.acos(dt)
        local cr = b:Cross(hcl)
        local rs = math.sign(cr.Y)
        if rs == 0 then ab = 0 end
        local aa = math.min(ab, ma)
        local ar = CFrame.Angles(0, aa * rs, 0)
        local it = ar * b
        r.CFrame = CFrame.lookAt(r.Position, r.Position + it)
        RunService.Heartbeat:Wait()
        h:ChangeState(Enum.HumanoidStateType.Jumping)
        h.JumpPower = 100
        r.CFrame = CFrame.lookAt(r.Position, r.Position - b)
        task.wait(0.15)
        debounceJump = true 
    end 
end)

local function tw(obj, props, t, style, dir)
    local tween = TweenService:Create(obj, TweenInfo.new(t or 0.5, style or Enum.EasingStyle.Quart, dir or Enum.EasingDirection.Out), props)
    tween:Play()
    return tween
end

local function createRipple(parent, z, color)
    local r = Instance.new("Frame", parent)
    r.Size = UDim2.new(0, 0, 0, 0)
    r.Position = UDim2.new(0.5, 0, 0.5, 0)
    r.AnchorPoint = Vector2.new(0.5, 0.5)
    r.BackgroundColor3 = color or Color3.fromRGB(200, 50, 255)
    r.BackgroundTransparency = 0.5
    r.BorderSizePixel = 0
    r.ZIndex = z or 25
    Instance.new("UICorner", r).CornerRadius = UDim.new(1, 0)
    tw(r, {Size = UDim2.new(2, 0, 2, 0), BackgroundTransparency = 1}, 0.4, Enum.EasingStyle.Quad)
    task.delay(0.4, function() r:Destroy() end)
end

local function showLanguageSelection()
    local C = {
        bg    = Color3.fromRGB(8,  0,  10),
        panel = Color3.fromRGB(14, 2,  16),
        card  = Color3.fromRGB(20, 5,  25),
        blood = Color3.fromRGB(100, 0,  140),
        red   = Color3.fromRGB(160, 0,  200),
        glow  = Color3.fromRGB(200, 50,  255),
        white = Color3.new(1, 1, 1),
        muted = Color3.fromRGB(150, 100, 180),
        dim   = Color3.fromRGB(50,  20,  60),
    }

    local LangScreen = Instance.new("ScreenGui", CoreGui)
    LangScreen.Name = "LOL_HOP_LANG_SELECT"
    LangScreen.ResetOnSpawn = false
    LangScreen.DisplayOrder = 99999

    local Win = Instance.new("Frame", LangScreen)
    Win.Size = UDim2.new(0, 400, 0, 200)
    Win.Position = UDim2.new(0.5, -200, 0.5, -100)
    Win.BackgroundColor3 = C.bg
    Win.BackgroundTransparency = 0.05
    Win.BorderSizePixel = 0
    Win.ClipsDescendants = true
    Instance.new("UICorner", Win).CornerRadius = UDim.new(0, 14)

    local OV = Instance.new("Frame", Win)
    OV.Size = UDim2.new(1, 0, 1, 0)
    OV.BackgroundColor3 = Color3.fromRGB(0, 0, 0)
    OV.BackgroundTransparency = 0.72
    OV.BorderSizePixel = 0
    OV.ZIndex = 2
    Instance.new("UICorner", OV).CornerRadius = UDim.new(0, 14)

    local TitleBar = Instance.new("Frame", Win)
    TitleBar.Size = UDim2.new(1, 0, 0, 50)
    TitleBar.BackgroundColor3 = C.panel
    TitleBar.BackgroundTransparency = 0.3
    TitleBar.BorderSizePixel = 0
    TitleBar.ZIndex = 10

    local titleTxt = Instance.new("TextLabel", TitleBar)
    titleTxt.Size = UDim2.new(1, 0, 1, 0)
    titleTxt.BackgroundTransparency = 1
    titleTxt.Text = "SELECT LANGUAGE / اختر اللغة"
    titleTxt.TextColor3 = C.white
    titleTxt.TextTransparency = 0
    titleTxt.TextSize = 16
    titleTxt.Font = Enum.Font.GothamBold
    titleTxt.ZIndex = 11

    local divLine = Instance.new("Frame", Win)
    divLine.Size = UDim2.new(1, -24, 0, 1)
    divLine.Position = UDim2.new(0, 12, 0, 50)
    divLine.BackgroundColor3 = C.blood
    divLine.BackgroundTransparency = 0.4
    divLine.BorderSizePixel = 0
    divLine.ZIndex = 10

    local subText = Instance.new("TextLabel", Win)
    subText.Size = UDim2.new(1, -20, 0, 25)
    subText.Position = UDim2.new(0, 10, 0, 60)
    subText.BackgroundTransparency = 1
    subText.Text = "Choose your language / اختر لغتك"
    subText.TextColor3 = C.muted
    subText.TextSize = 12
    subText.Font = Enum.Font.GothamMedium
    subText.ZIndex = 11

    local btnContainer = Instance.new("Frame", Win)
    btnContainer.Size = UDim2.new(1, -40, 0, 60)
    btnContainer.Position = UDim2.new(0, 20, 0, 100)
    btnContainer.BackgroundTransparency = 1
    btnContainer.ZIndex = 12

    local engBtn = Instance.new("TextButton", btnContainer)
    engBtn.Size = UDim2.new(0.45, -5, 1, 0)
    engBtn.Position = UDim2.new(0, 0, 0, 0)
    engBtn.BackgroundColor3 = C.blood
    engBtn.BackgroundTransparency = 0.4
    engBtn.Text = "ENGLISH"
    engBtn.TextColor3 = C.white
    engBtn.TextSize = 18
    engBtn.Font = Enum.Font.GothamBold
    engBtn.BorderSizePixel = 0
    engBtn.ZIndex = 13
    Instance.new("UICorner", engBtn).CornerRadius = UDim.new(0, 8)
    local engStr = Instance.new("UIStroke", engBtn)
    engStr.Color = C.glow
    engStr.Thickness = 1.5
    engStr.Transparency = 0.3

    engBtn.MouseEnter:Connect(function()
        tw(engBtn, {BackgroundTransparency = 0.2}, 0.15)
        tw(engStr, {Transparency = 0}, 0.15)
    end)
    engBtn.MouseLeave:Connect(function()
        tw(engBtn, {BackgroundTransparency = 0.4}, 0.15)
        tw(engStr, {Transparency = 0.3}, 0.15)
    end)

    engBtn.MouseButton1Click:Connect(function()
        createRipple(engBtn, 20, C.glow)
        selectedLanguage = "English"
        LangScreen:Destroy()
        task.wait(0.2)
        launchMainHub()
    end)

    local arbBtn = Instance.new("TextButton", btnContainer)
    arbBtn.Size = UDim2.new(0.45, -5, 1, 0)
    arbBtn.Position = UDim2.new(0.55, 0, 0, 0)
    arbBtn.BackgroundColor3 = C.blood
    arbBtn.BackgroundTransparency = 0.4
    arbBtn.Text = "العربية"
    arbBtn.TextColor3 = C.white
    arbBtn.TextSize = 18
    arbBtn.Font = Enum.Font.GothamBold
    arbBtn.BorderSizePixel = 0
    arbBtn.ZIndex = 13
    Instance.new("UICorner", arbBtn).CornerRadius = UDim.new(0, 8)
    local arbStr = Instance.new("UIStroke", arbBtn)
    arbStr.Color = C.glow
    arbStr.Thickness = 1.5
    arbStr.Transparency = 0.3

    arbBtn.MouseEnter:Connect(function()
        tw(arbBtn, {BackgroundTransparency = 0.2}, 0.15)
        tw(arbStr, {Transparency = 0}, 0.15)
    end)
    arbBtn.MouseLeave:Connect(function()
        tw(arbBtn, {BackgroundTransparency = 0.4}, 0.15)
        tw(arbStr, {Transparency = 0.3}, 0.15)
    end)

    arbBtn.MouseButton1Click:Connect(function()
        createRipple(arbBtn, 20, C.glow)
        selectedLanguage = "Arabic"
        LangScreen:Destroy()
        task.wait(0.2)
        launchMainHub()
    end)

    Win.Size = UDim2.new(0, 0, 0, 0)
    Win.Position = UDim2.new(0.5, 0, 0.5, 0)
    tw(Win, {Size = UDim2.new(0, 400, 0, 200), Position = UDim2.new(0.5, -200, 0.5, -100)}, 0.4, Enum.EasingStyle.Back)
end

function launchMainHub()
    local C = {
        bg    = Color3.fromRGB(8,  0,  10),
        panel = Color3.fromRGB(14, 2,  16),
        card  = Color3.fromRGB(20, 5,  25),
        blood = Color3.fromRGB(100, 0,  140),
        red   = Color3.fromRGB(160, 0,  200),
        glow  = Color3.fromRGB(200, 50,  255),
        white = Color3.new(1, 1, 1),
        muted = Color3.fromRGB(150, 100, 180),
        dim   = Color3.fromRGB(50,  20,  60),
    }

    if CoreGui:FindFirstChild("LOL_HOP_V1_UI") then 
        CoreGui:FindFirstChild("LOL_HOP_V1_UI"):Destroy() 
    end

    local Screen = Instance.new("ScreenGui", CoreGui)
    Screen.Name = "LOL_HOP_V1_UI"
    Screen.ResetOnSpawn = false
    Screen.DisplayOrder = 9999

    local Win = Instance.new("Frame", Screen)
    Win.Size = UDim2.new(0, 420, 0, 400)
    Win.Position = UDim2.new(0.5, -210, 0.5, -200)
    Win.BackgroundColor3 = C.bg
    Win.BackgroundTransparency = 0.05
    Win.BorderSizePixel = 0
    Win.ClipsDescendants = true
    Instance.new("UICorner", Win).CornerRadius = UDim.new(0, 14)

    local OV = Instance.new("Frame", Win)
    OV.Size = UDim2.new(1, 0, 1, 0)
    OV.BackgroundColor3 = Color3.fromRGB(0, 0, 0)
    OV.BackgroundTransparency = 0.72
    OV.BorderSizePixel = 0
    OV.ZIndex = 2
    Instance.new("UICorner", OV).CornerRadius = UDim.new(0, 14)

    local TitleBar = Instance.new("Frame", Win)
    TitleBar.Size = UDim2.new(1, 0, 0, 50)
    TitleBar.BackgroundColor3 = C.panel
    TitleBar.BackgroundTransparency = 0.3
    TitleBar.BorderSizePixel = 0
    TitleBar.ZIndex = 10

    local titleTxt = Instance.new("TextLabel", TitleBar)
    titleTxt.Size = UDim2.new(0, 180, 1, 0)
    titleTxt.Position = UDim2.new(0, 12, 0, 0)
    titleTxt.BackgroundTransparency = 1
    titleTxt.Text = T("Title")
    titleTxt.TextColor3 = C.white
    titleTxt.TextTransparency = 0
    titleTxt.TextSize = 14
    titleTxt.Font = Enum.Font.GothamBold
    titleTxt.TextXAlignment = Enum.TextXAlignment.Left
    titleTxt.ZIndex = 11

    local subTxt = Instance.new("TextLabel", TitleBar)
    subTxt.Size = UDim2.new(0, 120, 1, 0)
    subTxt.Position = UDim2.new(0, 130, 0, 0)
    subTxt.BackgroundTransparency = 1
    subTxt.Text = "|  tiktok · lolhopsc"
    subTxt.TextColor3 = C.muted
    subTxt.TextTransparency = 0
    subTxt.TextSize = 10
    subTxt.Font = Enum.Font.GothamMedium
    subTxt.TextXAlignment = Enum.TextXAlignment.Left
    subTxt.ZIndex = 11

    local minBtn = Instance.new("TextButton", TitleBar)
    minBtn.Size = UDim2.new(0, 26, 0, 26)
    minBtn.Position = UDim2.new(1, -62, 0.5, -13)
    minBtn.BackgroundColor3 = C.dim
    minBtn.BackgroundTransparency = 0.3
    minBtn.Text = "⤹"
    minBtn.TextColor3 = C.muted
    minBtn.TextTransparency = 0
    minBtn.TextSize = 16
    minBtn.Font = Enum.Font.GothamBold
    minBtn.BorderSizePixel = 0
    minBtn.ZIndex = 11
    Instance.new("UICorner", minBtn).CornerRadius = UDim.new(0, 5)

    local closeBtn = Instance.new("TextButton", TitleBar)
    closeBtn.Size = UDim2.new(0, 26, 0, 26)
    closeBtn.Position = UDim2.new(1, -30, 0.5, -13)
    closeBtn.BackgroundColor3 = C.blood
    closeBtn.BackgroundTransparency = 0.3
    closeBtn.Text = "X"
    closeBtn.TextColor3 = C.white
    closeBtn.TextTransparency = 0
    closeBtn.TextSize = 14
    closeBtn.Font = Enum.Font.GothamBold
    closeBtn.BorderSizePixel = 0
    closeBtn.ZIndex = 11
    Instance.new("UICorner", closeBtn).CornerRadius = UDim.new(0, 5)

    local pingLabel = Instance.new("TextLabel", TitleBar)
    pingLabel.Size = UDim2.new(0, 100, 0, 28)
    pingLabel.Position = UDim2.new(1, -168, 0.5, -14)
    pingLabel.BackgroundColor3 = Color3.fromRGB(10, 10, 10)
    pingLabel.BackgroundTransparency = 0.85
    pingLabel.BorderSizePixel = 0
    pingLabel.Text = T("PingText") .. "  --"
    pingLabel.TextColor3 = C.white
    pingLabel.TextSize = 14
    pingLabel.Font = Enum.Font.GothamBold
    pingLabel.TextTransparency = 1
    pingLabel.ZIndex = 13
    Instance.new("UICorner", pingLabel).CornerRadius = UDim.new(0, 5)
    local pingStroke = Instance.new("UIStroke", pingLabel)
    pingStroke.Color = C.glow
    pingStroke.Thickness = 0.8
    pingStroke.Transparency = 0.5

    local divLine = Instance.new("Frame", Win)
    divLine.Size = UDim2.new(1, -24, 0, 1)
    divLine.Position = UDim2.new(0, 12, 0, 50)
    divLine.BackgroundColor3 = C.blood
    divLine.BackgroundTransparency = 0.4
    divLine.BorderSizePixel = 0
    divLine.ZIndex = 10

    local Scroll = Instance.new("ScrollingFrame", Win)
    Scroll.Size = UDim2.new(1, -16, 1, -60)
    Scroll.Position = UDim2.new(0, 8, 0, 56)
    Scroll.BackgroundTransparency = 1
    Scroll.BorderSizePixel = 0
    Scroll.ScrollBarThickness = 2
    Scroll.ScrollBarImageColor3 = C.blood
    Scroll.CanvasSize = UDim2.new(0, 0, 0, 600)
    Scroll.ZIndex = 12

    local function makeSection(y, text)
        local row = Instance.new("Frame", Scroll)
        row.Size = UDim2.new(1, -8, 0, 22)
        row.Position = UDim2.new(0, 4, 0, y)
        row.BackgroundTransparency = 1
        row.ZIndex = 14
        local line = Instance.new("Frame", row)
        line.Size = UDim2.new(1, 0, 0, 1)
        line.Position = UDim2.new(0, 0, 0.5, 0)
        line.BackgroundColor3 = C.blood
        line.BackgroundTransparency = 0.5
        line.BorderSizePixel = 0
        line.ZIndex = 14
        local bg = Instance.new("Frame", row)
        bg.Position = UDim2.new(0.5, 0, 0, 0)
        bg.AnchorPoint = Vector2.new(0.5, 0)
        bg.BackgroundColor3 = Color3.fromRGB(0, 0, 0)
        bg.BackgroundTransparency = 0.1
        bg.BorderSizePixel = 0
        bg.AutomaticSize = Enum.AutomaticSize.X
        bg.Size = UDim2.new(0, 0, 1, 0)
        bg.ZIndex = 15
        local lbl = Instance.new("TextLabel", bg)
        lbl.BackgroundTransparency = 1
        lbl.Text = "  " .. text .. "  "
        lbl.TextColor3 = C.glow
        lbl.TextSize = 10
        lbl.Font = Enum.Font.GothamBold
        lbl.AutomaticSize = Enum.AutomaticSize.X
        lbl.Size = UDim2.new(0, 0, 1, 0)
        lbl.ZIndex = 16
    end

    local function makeToggle(y, icon, label, default, callback)
        local c = Instance.new("Frame", Scroll)
        c.Size = UDim2.new(1, -8, 0, 42)
        c.Position = UDim2.new(0, 4, 0, y)
        c.BackgroundColor3 = C.card
        c.BackgroundTransparency = 0.4
        c.BorderSizePixel = 0
        c.ZIndex = 14
        c.ClipsDescendants = true
        Instance.new("UICorner", c).CornerRadius = UDim.new(0, 8)
        local cs = Instance.new("UIStroke", c)
        cs.Color = C.dim
        cs.Thickness = 1

        local side = Instance.new("Frame", c)
        side.Size = UDim2.new(0, 3, 0.6, 0)
        side.Position = UDim2.new(0, 0, 0.2, 0)
        side.BackgroundColor3 = default and C.glow or C.dim
        side.BorderSizePixel = 0
        side.ZIndex = 15
        Instance.new("UICorner", side).CornerRadius = UDim.new(1, 0)

        local il = Instance.new("TextLabel", c)
        il.Size = UDim2.new(0, 26, 0, 26)
        il.Position = UDim2.new(0, 10, 0.5, -13)
        il.BackgroundTransparency = 1
        il.Text = icon
        il.TextSize = 15
        il.ZIndex = 15

        local lbl = Instance.new("TextLabel", c)
        lbl.Size = UDim2.new(1, -105, 1, 0)
        lbl.Position = UDim2.new(0, 42, 0, 0)
        lbl.BackgroundTransparency = 1
        lbl.Text = label
        lbl.TextColor3 = C.white
        lbl.TextSize = 13
        lbl.Font = Enum.Font.GothamMedium
        lbl.TextXAlignment = Enum.TextXAlignment.Left
        lbl.ZIndex = 15

        local tBg = Instance.new("Frame", c)
        tBg.Size = UDim2.new(0, 40, 0, 20)
        tBg.Position = UDim2.new(1, -48, 0.5, -10)
        tBg.BackgroundColor3 = default and C.blood or C.dim
        tBg.BackgroundTransparency = default and 0.25 or 0.1
        tBg.BorderSizePixel = 0
        tBg.ZIndex = 15
        Instance.new("UICorner", tBg).CornerRadius = UDim.new(1, 0)
        local tStr = Instance.new("UIStroke", tBg)
        tStr.Color = default and C.glow or C.dim
        tStr.Thickness = 1.2

        local circ = Instance.new("Frame", tBg)
        circ.Size = UDim2.new(0, 14, 0, 14)
        circ.Position = default and UDim2.new(1, -17, 0.5, -7) or UDim2.new(0, 3, 0.5, -7)
        circ.BackgroundColor3 = C.white
        circ.BorderSizePixel = 0
        circ.ZIndex = 16
        Instance.new("UICorner", circ).CornerRadius = UDim.new(1, 0)

        local val = default or false
        local btn = Instance.new("TextButton", c)
        btn.Size = UDim2.new(1, 0, 1, 0)
        btn.BackgroundTransparency = 1
        btn.Text = ""
        btn.ZIndex = 17

        btn.MouseButton1Click:Connect(function()
            val = not val
            createRipple(c, 17, C.glow)
            tw(tBg, {BackgroundColor3 = val and C.blood or C.dim, BackgroundTransparency = val and 0.25 or 0.1}, 0.2)
            tw(tStr, {Color = val and C.glow or C.dim}, 0.2)
            tw(circ, {Position = val and UDim2.new(1, -17, 0.5, -7) or UDim2.new(0, 3, 0.5, -7)}, 0.2)
            tw(side, {BackgroundColor3 = val and C.glow or C.dim}, 0.2)
            if callback then callback(val) end
        end)
        btn.MouseEnter:Connect(function() tw(c, {BackgroundTransparency = 0.22}, 0.12) end)
        btn.MouseLeave:Connect(function() tw(c, {BackgroundTransparency = 0.4},  0.12) end)
        return {set = function(v)
            val = v
            tw(tBg, {BackgroundColor3 = val and C.blood or C.dim, BackgroundTransparency = val and 0.25 or 0.1}, 0.2)
            tw(tStr, {Color = val and C.glow or C.dim}, 0.2)
            tw(circ, {Position = val and UDim2.new(1, -17, 0.5, -7) or UDim2.new(0, 3, 0.5, -7)}, 0.2)
            tw(side, {BackgroundColor3 = val and C.glow or C.dim}, 0.2)
        end}
    end

    local function makeButton(y, icon, label, cb)
        local c = Instance.new("Frame", Scroll)
        c.Size = UDim2.new(1, -8, 0, 40)
        c.Position = UDim2.new(0, 4, 0, y)
        c.BackgroundColor3 = C.blood
        c.BackgroundTransparency = 0.6
        c.BorderSizePixel = 0
        c.ZIndex = 14
        c.ClipsDescendants = true
        Instance.new("UICorner", c).CornerRadius = UDim.new(0, 8)
        local cs = Instance.new("UIStroke", c)
        cs.Color = C.glow
        cs.Thickness = 1
        cs.Transparency = 0.5

        local side = Instance.new("Frame", c)
        side.Size = UDim2.new(0, 3, 0.6, 0)
        side.Position = UDim2.new(0, 0, 0.2, 0)
        side.BackgroundColor3 = C.glow
        side.BorderSizePixel = 0
        side.ZIndex = 15
        Instance.new("UICorner", side).CornerRadius = UDim.new(1, 0)

        local lbl = Instance.new("TextLabel", c)
        lbl.Size = UDim2.new(1, -36, 1, 0)
        lbl.Position = UDim2.new(0, 14, 0, 0)
        lbl.BackgroundTransparency = 1
        lbl.Text = icon .. "  " .. label
        lbl.TextColor3 = C.white
        lbl.TextSize = 13
        lbl.Font = Enum.Font.GothamBold
        lbl.TextXAlignment = Enum.TextXAlignment.Left
        lbl.ZIndex = 15

        local arr = Instance.new("TextLabel", c)
        arr.Size = UDim2.new(0, 22, 1, 0)
        arr.Position = UDim2.new(1, -24, 0, 0)
        arr.BackgroundTransparency = 1
        arr.Text = ">"
        arr.TextColor3 = C.glow
        arr.TextSize = 20
        arr.Font = Enum.Font.GothamBold
        arr.ZIndex = 15

        local btn = Instance.new("TextButton", c)
        btn.Size = UDim2.new(1, 0, 1, 0)
        btn.BackgroundTransparency = 1
        btn.Text = ""
        btn.ZIndex = 16
        btn.MouseButton1Click:Connect(function()
            createRipple(c, 16, C.glow)
            tw(c, {BackgroundTransparency = 0.35}, 0.1)
            task.delay(0.18, function() tw(c, {BackgroundTransparency = 0.6}, 0.2) end)
            if cb then cb() end
        end)
        btn.MouseEnter:Connect(function() tw(c, {BackgroundTransparency = 0.45}, 0.12) end)
        btn.MouseLeave:Connect(function() tw(c, {BackgroundTransparency = 0.6}, 0.12) end)
    end

    local function makeSlider(y, icon, label, min, max, default, callback)
        local c = Instance.new("Frame", Scroll)
        c.Size = UDim2.new(1, -8, 0, 56)
        c.Position = UDim2.new(0, 4, 0, y)
        c.BackgroundColor3 = C.card
        c.BackgroundTransparency = 0.4
        c.BorderSizePixel = 0
        c.ZIndex = 14
        Instance.new("UICorner", c).CornerRadius = UDim.new(0, 8)
        local cs = Instance.new("UIStroke", c)
        cs.Color = C.dim
        cs.Thickness = 1

        local side = Instance.new("Frame", c)
        side.Size = UDim2.new(0, 3, 0.6, 0)
        side.Position = UDim2.new(0, 0, 0.2, 0)
        side.BackgroundColor3 = C.blood
        side.BorderSizePixel = 0
        side.ZIndex = 15
        Instance.new("UICorner", side).CornerRadius = UDim.new(1, 0)

        local top = Instance.new("Frame", c)
        top.Size = UDim2.new(1, -16, 0, 22)
        top.Position = UDim2.new(0, 12, 0, 6)
        top.BackgroundTransparency = 1
        top.ZIndex = 15
        local lbl = Instance.new("TextLabel", top)
        lbl.Size = UDim2.new(0.75, 0, 1, 0)
        lbl.BackgroundTransparency = 1
        lbl.Text = icon .. "  " .. label
        lbl.TextColor3 = C.white
        lbl.TextSize = 12
        lbl.Font = Enum.Font.GothamMedium
        lbl.TextXAlignment = Enum.TextXAlignment.Left
        lbl.ZIndex = 15
        local valLbl = Instance.new("TextLabel", top)
        valLbl.Size = UDim2.new(0.25, 0, 1, 0)
        valLbl.Position = UDim2.new(0.75, 0, 0, 0)
        valLbl.BackgroundTransparency = 1
        valLbl.Text = tostring(default)
        valLbl.TextColor3 = C.glow
        valLbl.TextSize = 12
        valLbl.Font = Enum.Font.GothamBold
        valLbl.TextXAlignment = Enum.TextXAlignment.Right
        valLbl.ZIndex = 15

        local track = Instance.new("Frame", c)
        track.Size = UDim2.new(1, -20, 0, 4)
        track.Position = UDim2.new(0, 12, 0, 40)
        track.BackgroundColor3 = C.dim
        track.BackgroundTransparency = 0.2
        track.BorderSizePixel = 0
        track.ZIndex = 15
        Instance.new("UICorner", track).CornerRadius = UDim.new(1, 0)

        local pct = (default - min) / (max - min)
        local fill = Instance.new("Frame", track)
        fill.Size = UDim2.new(pct, 0, 1, 0)
        fill.BackgroundColor3 = C.red
        fill.BackgroundTransparency = 0.2
        fill.BorderSizePixel = 0
        fill.ZIndex = 16
        Instance.new("UICorner", fill).CornerRadius = UDim.new(1, 0)

        local thumb = Instance.new("Frame", track)
        thumb.Size = UDim2.new(0, 14, 0, 14)
        thumb.Position = UDim2.new(pct, -7, 0.5, -7)
        thumb.BackgroundColor3 = C.white
        thumb.BorderSizePixel = 0
        thumb.ZIndex = 17
        Instance.new("UICorner", thumb).CornerRadius = UDim.new(1, 0)
        local tStr = Instance.new("UIStroke", thumb)
        tStr.Color = C.glow
        tStr.Thickness = 1.8

        local dragging = false
        local function updateSlider(rel)
            rel = math.clamp(rel, 0, 1)
            fill.Size = UDim2.new(rel, 0, 1, 0)
            thumb.Position = UDim2.new(rel, -7, 0.5, -7)
            local v = min + (max - min) * rel
            valLbl.Text = tostring(math.floor(v * 10) / 10)
            if callback then callback(v) end
        end

        thumb.InputBegan:Connect(function(i)
            if i.UserInputType == Enum.UserInputType.MouseButton1 or i.UserInputType == Enum.UserInputType.Touch then 
                dragging = true 
            end 
        end)
        UserInputService.InputEnded:Connect(function(i)
            if i.UserInputType == Enum.UserInputType.MouseButton1 or i.UserInputType == Enum.UserInputType.Touch then 
                dragging = false 
            end 
        end)
        UserInputService.InputChanged:Connect(function(i)
            if dragging and (i.UserInputType == Enum.UserInputType.MouseMovement or i.UserInputType == Enum.UserInputType.Touch) then
                updateSlider((i.Position.X - track.AbsolutePosition.X) / track.AbsoluteSize.X)
            end
        end)
    end

    local welcome = Instance.new("Frame", Scroll)
    welcome.Size = UDim2.new(1, -8, 0, 60)
    welcome.Position = UDim2.new(0, 4, 0, 4)
    welcome.BackgroundColor3 = C.blood
    welcome.BackgroundTransparency = 0.5
    welcome.BorderSizePixel = 0
    welcome.ZIndex = 14
    welcome.ClipsDescendants = true
    Instance.new("UICorner", welcome).CornerRadius = UDim.new(0, 10)
    local wStr = Instance.new("UIStroke", welcome)
    wStr.Color = C.glow
    wStr.Thickness = 1.2
    wStr.Transparency = 0.4

    local wT = Instance.new("TextLabel", welcome)
    wT.Size = UDim2.new(1, -14, 0, 26)
    wT.Position = UDim2.new(0, 12, 0, 6)
    wT.BackgroundTransparency = 1
    wT.Text = T("WelcomeText") .. LocalPlayer.Name
    wT.TextColor3 = C.white
    wT.TextSize = 14
    wT.Font = Enum.Font.GothamBold
    wT.TextXAlignment = Enum.TextXAlignment.Left
    wT.ZIndex = 15

    local wS = Instance.new("TextLabel", welcome)
    wS.Size = UDim2.new(1, -14, 0, 18)
    wS.Position = UDim2.new(0, 12, 0, 34)
    wS.BackgroundTransparency = 1
    wS.Text = T("Title")
    wS.TextColor3 = C.glow
    wS.TextSize = 11
    wS.Font = Enum.Font.GothamMedium
    wS.TextXAlignment = Enum.TextXAlignment.Left
    wS.ZIndex = 15

    makeSection(72, T("COMBAT"))
    local autoToggle = makeToggle(100, "", T("Auto"), false, function(v) if v then startAuto() else stopAuto() end end)
    local classicBtn = makeButton(148, "", T("ClassicMode"), function() autoMode = "Classic" end)
    local proBtn = makeButton(194, "", T("ProMode"), function() autoMode = "Pro" end)

    makeSection(242, T("SETTINGS"))
    makeSlider(270, "", T("MaxNumber"), 1, 10, 5, function(v) targetNumber = v end)
    makeSlider(332, "", T("KeepDistance"), 1, 10, 3.5, function(v) KEEP_DISTANCE = v end)
    makeSlider(394, "", T("WallDistance"), 1, 10, 2.5, function(v) wallDistance = v end)
    
    local flickToggle = makeToggle(456, "", T("Flick"), false, function(v) 
        toggleFlick(v) 
    end)
    makeSlider(504, "", T("FlickPower"), 5, 45, 45, function(v) 
        flickPower = v 
    end)
    
    local stretchToggle = makeToggle(566, "", T("StretchScreen"), false, function(v) 
        stretchEnabled = v 
        if v then 
            updateStretch() 
        else 
            if stretchConn then stretchConn:Disconnect(); stretchConn = nil end 
        end 
    end)
    local fpsToggle = makeToggle(614, "", T("FPSBoost"), false, function(v) 
        fpsEnabled = v 
        if v then applyFPS() end 
    end)
    local escapeToggle = makeToggle(662, "", T("Escape"), true, function(v) escapeMode = v end)

    Scroll.CanvasSize = UDim2.new(0, 0, 0, 720)

    local drag, ds, wp = false, nil, nil
    TitleBar.InputBegan:Connect(function(i) 
        if i.UserInputType == Enum.UserInputType.MouseButton1 or i.UserInputType == Enum.UserInputType.Touch then 
            drag = true 
            ds = i.Position 
            wp = Win.Position 
        end 
    end)
    UserInputService.InputChanged:Connect(function(i) 
        if drag and (i.UserInputType == Enum.UserInputType.MouseMovement or i.UserInputType == Enum.UserInputType.Touch) then 
            local d = i.Position - ds 
            Win.Position = UDim2.new(wp.X.Scale, wp.X.Offset + d.X, wp.Y.Scale, wp.Y.Offset + d.Y) 
        end 
    end)
    UserInputService.InputEnded:Connect(function(i) 
        if i.UserInputType == Enum.UserInputType.MouseButton1 or i.UserInputType == Enum.UserInputType.Touch then 
            drag = false 
        end 
    end)

    local mini = false
    minBtn.MouseButton1Click:Connect(function() 
        mini = not mini 
        tw(Win, {Size = mini and UDim2.new(0, 420, 0, 50) or UDim2.new(0, 420, 0, 400)}, 0.35, Enum.EasingStyle.Back) 
        
        if mini then
            minBtn.Text = "⤴"
        else
            minBtn.Text = "⤹"
        end
        
        if mini then 
            tw(pingLabel, {TextTransparency = 0, BackgroundTransparency = 0.35}, 0.3) 
        else 
            tw(pingLabel, {TextTransparency = 1, BackgroundTransparency = 1}, 0.2) 
        end 
    end)

    task.spawn(function() 
        while Win and Win.Parent do 
            local ping = math.floor(LocalPlayer:GetNetworkPing() * 1000) 
            pingLabel.Text = T("PingText") .. "  " .. ping .. "ms" 
            task.wait(0.5) 
        end 
    end)

    closeBtn.MouseButton1Click:Connect(function() 
        tw(Win, {Size = UDim2.new(0, 0, 0, 0), BackgroundTransparency = 1}, 0.3, Enum.EasingStyle.Back, Enum.EasingDirection.In) 
        task.delay(0.3, function() Screen:Destroy() end) 
    end)

    task.spawn(function()
        task.wait(0.5)
        checkIntegrity()
    end)
end

task.spawn(function()
    task.wait(0.3)
    showLanguageSelection()
end)

Ghost:KillTimeBombScanners()
Ghost:NetworkMask()
Ghost:AntiKickShield()
Ghost:PlayerGuiShield()
Ghost:AntiTeleportDetect()
