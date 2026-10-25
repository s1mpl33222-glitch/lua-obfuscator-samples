--== AUTO COPY LINK ON START ==--
pcall(function()
    if setclipboard then 
        setclipboard("https://youtube.com/@invis_in") 
    elseif toclipboard then 
        toclipboard("https://youtube.com/@invis_in") 
    end
end)

-- ═══ INITIALIZE SAFE SHARED TABLE ══════════════════════════════════════
getgenv().shared = getgenv().shared or shared or {}
local shared = getgenv().shared

-- ═══ SERVICES & GLOBALS ════════════════════════════════════════════════
local RunService        = game:GetService("RunService")
local Players           = game:GetService("Players")
local LocalPlayer       = Players.LocalPlayer
local Player            = Players.LocalPlayer
local UserInputService  = game:GetService("UserInputService")
local TweenService      = game:GetService("TweenService")
local CoreGui           = game:GetService("CoreGui")
local StarterGui        = game:GetService("StarterGui")
local StatsService      = game:GetService("Stats")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local Debris            = game:GetService("Debris")
local Lighting          = game:GetService("Lighting")
local TeleportService   = game:GetService("TeleportService")
local HttpService       = game:GetService("HttpService")
local Terrain = workspace:FindFirstChildOfClass("Terrain")

if shared._InvisRunning then
    shared._InvisRunning = false
    if shared._PhysicsBind then shared._PhysicsBind:Disconnect(); shared._PhysicsBind = nil end
    task.wait(0.1)
end
shared._InvisRunning = true

-- ═══ DEEP BAC BYPASS HOOKS (INVISIBLE SCRIPT) ════════════════════════════
local hookfunction = hookfunction or (getgenv and getgenv().hookfunction)
if hookfunction and getrenv then
    pcall(function()
        local _BAC_oldDebugInfo
        _BAC_oldDebugInfo = hookfunction(getrenv().debug.info, function(f, t)
            if type(f) == "function" then return "[C]"
            elseif f == 4 and t == "s" then return "ReplicatedStorage.Controllers.SwordsController " end
            return _BAC_oldDebugInfo(f, t)
        end)

        local _BAC_oldGetfenv
        _BAC_oldGetfenv = hookfunction(getrenv().getfenv, function(l)
            if l ~= nil and type(l) == "number" and l >= 1 and l <= 10 then return _BAC_oldGetfenv(10) end
            return _BAC_oldGetfenv(l)
        end)
    end)
end

-- ═══ CONFIGURATION & GLOBAL STATE ══════════════════════════════════════
local Config = {
    AutoParry = false,
    ParryMode = "Distance", 
    TargetTime = 0.3,       
    DistanceTiming = 100, 
    ParryCurveMode = "Front", 
    HitSpeedMode = "Fast ball", 
    TargetMode = "Nearest",
    SelectedTarget = "",
    AutoSpam = false,
    ManualSpam = false,
    ManualSpamSpeed = 0.015,
    SuperSpam = false,
    SuperSpamClicks = 1,
    AutoAbility = false, 
    SpecialSkillDetections = false,
    AbilityESP = false,
    SoccerMode = false,
    GodMode = false,
    CustomSpeed = nil,
    CustomJump = nil,
    CustomAnimID = "",
    
    SkinChangerEnabled = false,
    SwordName = "",
    SwordAnimName = "",
    SwordFXName = "",
    SwordAnimationsEnabled = true,
    LowGraphicsEnabled = false,
    AutoPlay = false,
    AutoJumpEnabled = false,
    AfkMode = false,
}

local Auto_Parry = {}
local lastParryTime = 0
local parryCooldown = 0.035
local lastHitTick = 0
local lastTargetChecked = nil
local Last_Parry = 0
local Cache_Update_Tick = 0
local Last_Positions_Cache = {}

getgenv()._ZX_VelHistory = getgenv()._ZX_VelHistory or { ball = {}, player = {}, MAX_SAMPLES = 7 }
local _ZX_VelHistory = getgenv()._ZX_VelHistory

local function _ZX_pushVelSample(target, pos, vel)
    local history = target == "ball" and _ZX_VelHistory.ball or _ZX_VelHistory.player
    table.insert(history, 1, { pos = pos, vel = vel, t = tick() })
    while #history > _ZX_VelHistory.MAX_SAMPLES do table.remove(history, #history) end
end

-- ═══ EMERGENCY DISTANCE CALCULATOR (OPTIMIZED FORMULA) ═════════════════
local function GetEmergencyDistance(speed)
    local calculated = 8 + (speed * 0.09)
    return math.clamp(calculated, 10, 75)
end

-- ═══ UPVALUE EVENT RESOLVER (INVISIBLE SCRIPT) ═════════════════════════
ZX_Parry = { Remote = nil, Function = nil, KeyTable = nil, TransformFn = nil, NetModule = nil, RemoteId = nil, ParryHash = nil, Hooked = false }
task.spawn(function()
    pcall(function()
        local getupvals = debug.getupvalues or getupvalues
        local SC = ReplicatedStorage:WaitForChild("Controllers", 10):FindFirstChild("SwordsController \12")
        local PRY = SC and SC:WaitForChild("PRY", 10)
        if not PRY then return end
        ZX_Parry.Function = require(PRY)
        local ups = getupvals(ZX_Parry.Function)
        ZX_Parry.KeyTable = ups[3]
        ZX_Parry.TransformFn = ups[4]
        ZX_Parry.NetModule = ups[6]
        ZX_Parry.RemoteId = ups[7]
        ZX_Parry.ParryHash = ups[8]
        if ZX_Parry.KeyTable and ZX_Parry.TransformFn and ZX_Parry.NetModule and ZX_Parry.RemoteId then
            ZX_Parry.Remote = ZX_Parry.NetModule:RemoteEvent(ZX_Parry.RemoteId)
            ZX_Parry.Hooked = true
        end
    end)
end)

local cachedToken = nil
local lastTokenTick = 0
local function generateToken(currentKey)
    if not currentKey or not ZX_Parry.TransformFn then return nil end
    if tick() - lastTokenTick < 0.01 and cachedToken then return cachedToken end
    local tok, transformed = pcall(ZX_Parry.TransformFn, currentKey, "TIME")
    if not tok or not transformed then return nil end
    local serverTime = workspace:GetServerTimeNow() * 100
    local timeStr = tostring(math.floor(serverTime))
    local tokenChars = {}
    for i = 1, #timeStr do
        local ki = (i - 1) % #transformed + 1
        local xb = bit32.bxor((string.byte(timeStr, i) + i) % 256, string.byte(transformed, ki))
        tokenChars[i] = string.char(xb)
    end
    cachedToken = table.concat(tokenChars)
    lastTokenTick = tick()
    return cachedToken
end

function Auto_Parry.Get_Balls()
    local balls = {}
    local processedNames = {}
    local bc = workspace:FindFirstChild("Balls")

    if bc then
        for _, b in pairs(bc:GetChildren()) do
            if b:IsA("BasePart") then
                -- 1. ยอมรับทั้งบอลที่มี realBall = true หรือบอลในโฟลเดอร์ Balls ที่ไม่มี attribute นี้ (เผื่อ Training Server)
                local realAttr = b:GetAttribute("realBall")
                if realAttr == nil or realAttr == true then
                    if not processedNames[b.Name] then
                        processedNames[b.Name] = true
                        table.insert(balls, b)
                    end
                end
            end
        end
    end
    return balls
end
function Auto_Parry.Get_Ball()
     local balls = Auto_Parry.Get_Balls()
     return balls[1]
end

function Auto_Parry.GetTargetPlayer()
    local alive = workspace:FindFirstChild("Alive")
    if not alive or not LocalPlayer.Character or not LocalPlayer.Character.PrimaryPart then return nil end
    
    if Config.TargetMode == "Nearest" then
        local minDist, chosen = math.huge, nil
        for _, p in pairs(alive:GetChildren()) do
            if p ~= LocalPlayer.Character and p.PrimaryPart then
                local d = (p.PrimaryPart.Position - LocalPlayer.Character.PrimaryPart.Position).Magnitude
                if d < minDist then minDist = d; chosen = p end
            end
        end
        return chosen
    elseif Config.TargetMode == "Farest" then
        local maxDist, chosen = -1, nil
        for _, p in pairs(alive:GetChildren()) do
            if p ~= LocalPlayer.Character and p.PrimaryPart then
                local d = (p.PrimaryPart.Position - LocalPlayer.Character.PrimaryPart.Position).Magnitude
                if d > maxDist then maxDist = d; chosen = p end
            end
        end
        return chosen
    -- ⚡ เติมเงื่อนไขนี้เพิ่มเติม: ค้นหาผู้เล่นตามชื่อที่พิมพ์ไว้
    elseif Config.TargetMode == "Selected" then
        if Config.SelectedTarget ~= "" then
            local searchName = Config.SelectedTarget:lower()
            for _, p in pairs(alive:GetChildren()) do
                if p ~= LocalPlayer.Character and p.PrimaryPart then
                    local pName = p.Name:lower()
                    local hum = p:FindFirstChildOfClass("Humanoid")
                    local dName = hum and hum.DisplayName:lower() or ""
                    
                    -- ค้นหาว่าชื่อตรงกันหรือมีคำนั้นอยู่หรือไม่
                    if pName:find(searchName) or dName:find(searchName) then
                        return p
                    end
                end
            end
        end
    end
    return nil
end

function Auto_Parry.Parry_Animation()
    if not Config.SwordAnimationsEnabled then return end
    pcall(function()
        local Parry_Animation = ReplicatedStorage.Shared.SwordAPI.Collection.Default:FindFirstChild("GrabParry")
        local Current_Sword = Player.Character:GetAttribute("CurrentlyEquippedSword")
        if not Current_Sword or not Parry_Animation then return end
        local Sword_Data = ReplicatedStorage.Shared.ReplicatedInstances.Swords.GetSword:Invoke(Current_Sword)
        if not Sword_Data or not Sword_Data["AnimationType"] then return end
        for _, object in pairs(ReplicatedStorage.Shared.SwordAPI.Collection:GetChildren()) do
            if object.Name == Sword_Data["AnimationType"] then
                local animType = object:FindFirstChild("GrabParry") and "GrabParry" or (object:FindFirstChild("Grab") and "Grab")
                if animType then Parry_Animation = object[animType] end
            end
        end
        local track = Player.Character.Humanoid.Animator:LoadAnimation(Parry_Animation)
        track:Play()
    end)
end

function Auto_Parry.CalculateParryCFrame()
    local cam = workspace.CurrentCamera
    local char = LocalPlayer.Character
    if not char or not char.PrimaryPart then 
        return cam and cam.CFrame or CFrame.new() 
    end

    local hrp = char.PrimaryPart
    local playerPos = hrp.Position
    local targetPlr = Auto_Parry.GetTargetPlayer()

    -- ทิศทางตั้งต้นไปยังเป้าหมาย (ถ้ามี) หรือหน้าตัวละคร
    local targetDir = hrp.CFrame.LookVector
    if targetPlr and targetPlr.PrimaryPart then
        targetDir = (targetPlr.PrimaryPart.Position - playerPos).Unit
    end

    local mode = Config.ParryCurveMode

    -- 🎲 ประมวลผลโหมดสุ่มต่างๆ
    if mode == "Random" then
        local allModes = {"Straight", "Right", "Left", "Up", "Back", "Fastball", "Slowball"}
        mode = allModes[math.random(1, #allModes)]
    elseif mode == "LeftRightRandom" then
        mode = (math.random(1, 2) == 1) and "Left" or "Right"
    elseif mode == "BackStraightRandom" then
        mode = (math.random(1, 2) == 1) and "Back" or "Straight"
    end

    -- 🎯 คำนวณวิถี CFrame แยกตามแต่ละโหมด
    if mode == "Straight" then
        -- ตรงไปหาเป้าหมาย
        return CFrame.new(playerPos, playerPos + targetDir)

    elseif mode == "Right" then
        -- โค้งไปทางขวา
        local rightVec = hrp.CFrame.RightVector
        return CFrame.new(playerPos, playerPos + targetDir + (rightVec * 2.5))

    elseif mode == "Left" then
        -- โค้งไปทางซ้าย
        local rightVec = hrp.CFrame.RightVector
        return CFrame.new(playerPos, playerPos + targetDir - (rightVec * 2.5))

    elseif mode == "Up" then
        -- เสยขึ้นฟ้า
        return CFrame.new(playerPos, playerPos + targetDir + Vector3.new(0, 12, 0))

    elseif mode == "Back" then
        -- หันยิงกลับหลัง
        return CFrame.new(playerPos, playerPos - targetDir)

    elseif mode == "Fastball" then
        -- พุ่งตรงความเร็วสูงแบบเลียดพื้น
        return CFrame.new(playerPos, playerPos + (targetDir * 100) + Vector3.new(0, -1.5, 0))

    elseif mode == "Slowball" then
        -- ยิงย้อยขึ้นฟ้าเพื่อให้บอลย้อยลงมาช้าๆ
        return CFrame.new(playerPos, playerPos + Vector3.new(0, 45, 0) + (targetDir * 0.2))

    elseif mode == "Camera" then
        -- อิงตามมุมกล้องของผู้เล่น
        if cam then
            return CFrame.new(cam.CFrame.Position, cam.CFrame.Position + cam.CFrame.LookVector)
        end
        return hrp.CFrame

    elseif mode == "Character" then
        -- หันตามหน้าตัวละครเท่านั้น (ไม่สนใจเป้าหมายและ Camera)
        return CFrame.new(playerPos, playerPos + hrp.CFrame.LookVector)
    end

    return CFrame.new(playerPos, playerPos + targetDir)
end


function Auto_Parry.FireParryRemote(ignoreCooldown)
    local curTime = tick()
    if not ignoreCooldown and (curTime - lastParryTime < parryCooldown) then return end
    if ignoreCooldown and (curTime - lastParryTime < 0.003) then return end 
    
    if not ZX_Parry.Hooked or not ZX_Parry.Remote then return end
    local keyIndex = ZX_Parry.KeyTable and ZX_Parry.KeyTable[3]
    local currentKey = keyIndex and ZX_Parry.KeyTable[1][keyIndex]
    if not currentKey then return end
    local token = generateToken(currentKey)
    if not token then return end

    lastParryTime = curTime
    lastHitTick = curTime
    local pCF = Auto_Parry.CalculateParryCFrame()
    local alive = workspace:FindFirstChild("Alive")
    local cam = workspace.CurrentCamera
    
    if tick() - Cache_Update_Tick > 0.1 then
        table.clear(Last_Positions_Cache)
        if alive and cam then
            for _, character in ipairs(alive:GetChildren()) do
                local primary = character.PrimaryPart
                if primary then Last_Positions_Cache[character.Name] = cam:WorldToScreenPoint(primary.Position) end
            end
        end
        Cache_Update_Tick = tick()
    end
    if Config.SwordAnimationsEnabled and (tick() - Last_Parry > 0.4) then Auto_Parry.Parry_Animation() end
    Last_Parry = tick()
    pcall(function() ZX_Parry.Remote:FireServer(ZX_Parry.ParryHash, currentKey, token, 0.5, pCF, Last_Positions_Cache, {cam.ViewportSize.X / 2, cam.ViewportSize.Y / 2}, false) end)
end

-- ═══ GUI ENGINE DESIGN ═══════════════════════════════════════════════
local ScreenGui = Instance.new("ScreenGui", CoreGui)
ScreenGui.Name = "InvisHub_Horizontal_" .. math.random(100,999); ScreenGui.ResetOnSpawn = false
shared._InvisHubStealthGui = ScreenGui

-- ═══ CUSTOM STACK-SAFE NOTIFICATION GUI QUEUE ═══
local NotificationHolder = Instance.new("Frame", ScreenGui)
NotificationHolder.Size = UDim2.new(0, 240, 0, 450)
NotificationHolder.Position = UDim2.new(1, -255, 0, 30)
NotificationHolder.BackgroundTransparency = 1
local notifyList = Instance.new("UIListLayout", NotificationHolder)
notifyList.Padding = UDim.new(0, 6)
notifyList.SortOrder = Enum.SortOrder.LayoutOrder

local function CustomNotify(text, duration)
    duration = duration or 3.5
    local card = Instance.new("Frame", NotificationHolder)
    card.Size = UDim2.new(1, 0, 0, 38)
    card.BackgroundColor3 = Color3.fromRGB(16, 16, 22)
    Instance.new("UICorner", card).CornerRadius = UDim.new(0, 6)
    local stroke = Instance.new("UIStroke", card)
    stroke.Color = Color3.fromRGB(255, 60, 60)
    stroke.Thickness = 1.2
    
    local txt = Instance.new("TextLabel", card)
    txt.Size = UDim2.new(1, -12, 1, 0)
    txt.Position = UDim2.new(0, 8, 0, 0)
    txt.Text = "🔔 " .. text
    txt.TextColor3 = Color3.fromRGB(255, 255, 255)
    txt.Font = Enum.Font.GothamBold
    txt.TextSize = 11
    txt.BackgroundTransparency = 1
    txt.TextXAlignment = Enum.TextXAlignment.Left

    card.BackgroundTransparency = 1
    txt.TextTransparency = 1
    stroke.Transparency = 1
    
    TweenService:Create(card, TweenInfo.new(0.2), {BackgroundTransparency = 0}):Play()
    TweenService:Create(txt, TweenInfo.new(0.2), {TextTransparency = 0}):Play()
    TweenService:Create(stroke, TweenInfo.new(0.2), {Transparency = 0}):Play()

    task.delay(duration, function()
        local t1 = TweenService:Create(card, TweenInfo.new(0.25), {BackgroundTransparency = 1})
        local t2 = TweenService:Create(txt, TweenInfo.new(0.25), {TextTransparency = 1})
        local t3 = TweenService:Create(stroke, TweenInfo.new(0.25), {Transparency = 1})
        t1:Play() t2:Play() t3:Play()
        t1.Completed:Connect(function() card:Destroy() end)
    end)
end

-- ----------------------------------------------------------------
-- 🛡️ SAFE IS_CURVED FUNCTION (ไม่มีการเรียกใช้ฟังก์ชั่นย่อยภายนอก)
-- ----------------------------------------------------------------
function Auto_Parry.Is_Curved(ballInstance)
    -- 1. ค้นหา Instance ของบอลแบบปลอดภัย
    local Ball = ballInstance
    if not Ball or typeof(Ball) ~= "Instance" or not Ball:IsA("BasePart") then
        local bc = workspace:FindFirstChild("Balls")
        if bc then
            for _, child in ipairs(bc:GetChildren()) do
                if child:IsA("BasePart") then
                    Ball = child
                    break
                end
            end
        end
    end

    if not Ball or not Ball.Parent then return false end

    -- 2. คำนวณวิถีโค้งด้วย pcall เพื่อป้องกัน Error ทุกกรณี
    local success, isCurving = pcall(function()
        local char = LocalPlayer.Character
        local hrp = char and char:FindFirstChild("HumanoidRootPart")
        if not hrp then return false end

        local zoomies = Ball:FindFirstChild("zoomies")
        local velocity = zoomies and zoomies.VectorVelocity or Ball.AssemblyLinearVelocity
        local speed = velocity.Magnitude

        -- ถ้าบอลช้ามาก ถือว่าไม่โค้ง
        if speed < 10 then return false end

        local ballPos = Ball.Position
        local playerPos = hrp.Position
        
        local toPlayer = (playerPos - ballPos).Unit
        local ballDir = velocity.Unit

        -- เช็กค่า Dot Product (ถ้าพุ่งตรงเข้าหาตัว Dot จะใกล้เคียง 1)
        local dot = ballDir:Dot(toPlayer)
        
        -- บอลโค้ง คือบอลที่ไม่ได้พุ่งตรงเข้าหาตัวละครเราตรงๆ (Dot น้อยกว่า 0.75)
        return (dot < 0.75 and dot > -0.6)
    end)

    return (success and isCurving == true)
end

-- low graphics
local function applyLowGraphics(enabled)
    Config.LowGraphicsEnabled = enabled
    if enabled then
        pcall(function()
            -- ปิดแสงเงาและเอฟเฟกต์หนักๆ ใน Lighting
            Lighting.GlobalShadows = false
            Lighting.FogEnd = 9e9
            for _, v in pairs(Lighting:GetChildren()) do
                if v:IsA("PostEffect") or v:IsA("Atmosphere") or v:IsA("Sky") then
                    v.Enabled = false
                end
            end
            
            -- ปิดเงาและวัสดุฟุ่มเฟือยของ Terrain
            if Terrain then
                Terrain.WaterWaveSize = 0
                Terrain.WaterWaveTransparency = 1
                Terrain.WaterTransparency = 0
                Terrain.WaterReflectance = 0
            end
            
            -- ปิดเงาและคุณภาพพาร์ททั้งหมดใน Workspace
            for _, obj in pairs(workspace:GetDescendants()) do
                if obj:IsA("BasePart") then
                    obj.CastShadow = false
                    obj.Material = Enum.Material.SmoothPlastic
                    obj.Reflectance = 0
                elseif obj:IsA("ParticleEmitter") or obj:IsA("Trail") or obj:IsA("Beam") then
                    obj.Enabled = false
                end
            end
        end)
        CustomNotify("Low Graphics Enabled (Boost FPS)", 2)
    else
        CustomNotify("Low Graphics Disabled (Rejoin or Reset to restore)", 2)
    end
end

-- ═══ SKIN CHANGER BACKEND SYSTEM (BUG FIXED + FULL FX SUPPORT) ═══════════════
getgenv().skinChanger = false
getgenv().swordModel = ""
getgenv().swordAnimations = ""
getgenv().swordFX = ""

task.spawn(function()
    local rs = ReplicatedStorage
    local swordInstancesInstance = rs:WaitForChild("Shared", 9e9):WaitForChild("ReplicatedInstances", 9e9):WaitForChild("Swords", 9e9)
    local swordInstances = require(swordInstancesInstance)

    local swordsController
    task.spawn(function()
        while task.wait() and not swordsController do
            local ok, conns = pcall(getconnections, rs.Remotes.FireSwordInfo.OnClientEvent)
            if ok and conns then
                for _, v in ipairs(conns) do
                                    if v.Function and islclosure and islclosure(v.Function) then
                        local ok2, up = pcall(getupvalues, v.Function)
                        if ok2 and #up == 1 and type(up[1]) == "table" then
                            swordsController = up[1]
                            break
                        end
                    end
                end
            end
        end
    end)

    local function getSlashName(swordName)
        local ok, sln = pcall(function() return swordInstances:GetSword(swordName) end)
        return (ok and sln and sln.SlashName) or "SlashEffect"
    end

    local function refreshSlashName()
        local fxName = (getgenv().swordFX and getgenv().swordFX ~= "") and getgenv().swordFX or getgenv().swordModel
        if fxName ~= "" then 
            getgenv().slashName = getSlashName(fxName) 
        else 
            getgenv().slashName = "SlashEffect" 
        end
    end

    local function setSword()
        if not getgenv().skinChanger then return end
        if not LocalPlayer.Character then return end
        
        pcall(function()
            local f = rawget(swordInstances, "EquipSwordTo")
            if type(f) == "function" then
                local ups = getupvalues(f)
                for i = 1, #ups do 
                    if type(ups[i]) == "boolean" then setupvalue(f, i, false) break end 
                end
            end
        end)
        
        pcall(function() swordInstances:EquipSwordTo(LocalPlayer.Character, getgenv().swordModel) end)
        
        task.spawn(function()
            local attempts = 0
            while not swordsController and attempts < 20 do task.wait(0.5); attempts = attempts + 1 end
            if not swordsController then return end
            
            local animSword = (getgenv().swordAnimations and getgenv().swordAnimations ~= "") and getgenv().swordAnimations or getgenv().swordModel
            local targetFX = (getgenv().swordFX and getgenv().swordFX ~= "") and getgenv().swordFX or getgenv().swordModel
            
            pcall(function()
                if swordsController.SetSword then
                    swordsController:SetSword(animSword)
                end
            end)
            
            pcall(function()
                if rs.Remotes:FindFirstChild("FireSwordInfo") then 
                    rs.Remotes.FireSwordInfo:FireServer(targetFX) 
                end
                swordsController.currentSword = getgenv().swordModel
                swordsController.SwordFX = targetFX
            end)
        end)
    end

    getgenv().updateSword = function() 
        refreshSlashName()
        setSword() 
    end
    
    -- ⚡ Hook ParrySuccessAll เพื่อแสดงผล Sword FX และ Slash ตอนตีโดน
    local hookedFuncs = {}
    task.spawn(function()
        while task.wait(0.5) do
            local ok, conns = pcall(getconnections, rs.Remotes.ParrySuccessAll.OnClientEvent)
            if ok and type(conns) == "table" then
                for _, v in ipairs(conns) do
                    local func = v.Function
                    if func and not hookedFuncs[func] then
                        if isourclosure and isourclosure(func) then
                            hookedFuncs[func] = true
                            continue
                        end
                        hookedFuncs[func] = true
                        v:Disable()
                        local targetFunc = func
                        local ourFunc = function(...)
                            local args = { ... }
                            if tostring(args[4]) == LocalPlayer.Name and getgenv().skinChanger then
                                local fxSword = (getgenv().swordFX and getgenv().swordFX ~= "") and getgenv().swordFX or getgenv().swordModel
                                refreshSlashName()
                                args[1] = getgenv().slashName
                                args[3] = fxSword
                            end
                            if setthreadidentity then pcall(setthreadidentity, 2) end
                            pcall(targetFunc, unpack(args))
                        end
                        hookedFuncs[ourFunc] = true
                        rs.Remotes.ParrySuccessAll.OnClientEvent:Connect(ourFunc)
                    end
                end
            end
        end
    end)
    
    -- Persistent Sync Loop (วนล็อก Sword FX และโมเดลไม่ให้หลุดระหว่างเล่น)
    task.spawn(function()
        while task.wait(0.5) do
            if getgenv().skinChanger and getgenv().swordModel ~= "" then
                local char = LocalPlayer.Character
                if char then
                    if LocalPlayer:GetAttribute("CurrentlyEquippedSword") ~= getgenv().swordModel then setSword() end
                    if not char:FindFirstChild(getgenv().swordModel) then setSword() end
                end
                
                if swordsController then
                    local targetFX = (getgenv().swordFX and getgenv().swordFX ~= "") and getgenv().swordFX or getgenv().swordModel
                    pcall(function()
                        if swordsController.SwordFX ~= targetFX then
                            swordsController.SwordFX = targetFX
                        end
                    end)
                end
            end
        end
    end)

    -- Bug Fix: ลบดาบซ้อนตอนตัวละครเกิดใหม่
    LocalPlayer.CharacterAdded:Connect(function(char)
        if getgenv().skinChanger then
            getgenv().skinChanger = false; task.wait(1.5)
            getgenv().skinChanger = true; task.wait(0.5)
            for _, v in pairs(char:GetChildren()) do
                if v:IsA("Model") and v.Name ~= getgenv().swordModel and v:FindFirstChild("Handle") then
                    v:Destroy()
                end
            end
            pcall(function() getgenv().updateSword() end)
        end
    end)
end)

-- ═══ STABLE HUMANOID ENFORCER (SPEED & JUMPPOWER CONTROLLER) ═══
task.spawn(function()
    while true do
        task.wait(0.1)
        pcall(function()
            local char = LocalPlayer.Character
            local hum = char and char:FindFirstChildOfClass("Humanoid")
            if hum then
                if Config.CustomSpeed then hum.WalkSpeed = Config.CustomSpeed end
                if Config.CustomJump then 
                    hum.JumpPower = Config.CustomJump 
                    hum.UseJumpPower = true
                end
            end
        end)
    end
end)

-- ═══ AUTO JUMP MODULE (SINGLE JUMP ON FLOOR) ═══
task.spawn(function()
    while shared._InvisRunning do
        task.wait(0.05)
        pcall(function()
            if Config.AutoJumpEnabled then
                local char = LocalPlayer.Character
                local hum = char and char:FindFirstChildOfClass("Humanoid")
                
                if hum and hum.Health > 0 then
                    if hum.FloorMaterial ~= Enum.Material.Air then
                        hum.Jump = true
                        task.wait(0.15)
                    end
                end
            end
        end)
    end
end)

-- ============================================================
-- FIXED SMART AUTO ABILITY 
-- ============================================================
local AbilityRemote = nil
local abilityHooked = false

local AutoAbilityData = {
    Enabled = true, -- เปิดใช้งานอัตโนมัติ
    LastAbilityName = nil,
}
getgenv().ZX_AutoAbility = AutoAbilityData

local ABILITY_TIMINGS = {
    ["Raging Deflection"] = { cooldown = 15, fireAt = 0.2, trigger = "target" },
    ["Calming Deflection"] = { cooldown = 15, fireAt = 0.3, trigger = "target" },
    ["Rapture"]            = { cooldown = 20, fireAt = 0.5, trigger = "proximity" },
    ["Aerodynamic Slash"]  = { cooldown = 12, fireAt = 0.2, trigger = "target" },
    ["Fracture"]           = { cooldown = 18, fireAt = 0.4, trigger = "proximity" },
    ["Death Slash"]        = { cooldown = 25, fireAt = 0.5, trigger = "clash" },
}

local _abilityLastFire = {}
local _lastTargetPlayer = false
local _targetStartTime = 0

-- Hook Remote สำหรับกด สกิล
task.spawn(function()
    local remotes = game:GetService("ReplicatedStorage"):WaitForChild("Remotes", 10)
    if remotes then
        AbilityRemote = remotes:FindFirstChild("AbilityButtonPress") or remotes:FindFirstChild("CastAbility")
    end
end)

local function fireAbilityRemote()
    if AbilityRemote then
        pcall(function()
            if AbilityRemote:IsA("RemoteEvent") then
                AbilityRemote:FireServer()
            elseif AbilityRemote:IsA("RemoteFunction") then
                AbilityRemote:InvokeServer()
            end
        end)
        return true
    end
    return false
end

local function getEquippedAbility()
    local char = game.Players.LocalPlayer.Character
    if not char then return nil end
    local abilities = char:FindFirstChild("Abilities")
    if not abilities then return nil end
    
    for _, abil in ipairs(abilities:GetChildren()) do
        if abil:GetAttribute("Equipped") or abil.Enabled == true then
            return abil.Name
        end
    end
    return nil
end

-- ตัวตรวจจับเวลาที่ลูกบอลเปลี่ยนเป้าหมายมาที่เรา (แก้ไขบั๊กเวลา)
task.spawn(function()
    while true do
        task.wait(0.02)
        local balls = Auto_Parry.Get_Balls()
        if balls then
            for _, ball in ipairs(balls) do
                local target = tostring(ball:GetAttribute("target") or ball:GetAttribute("Target") or "")
                local isMe = (target == LocalPlayer.Name or target == tostring(LocalPlayer))
                if isMe and not _lastTargetPlayer then
                    _targetStartTime = tick()
                    _lastTargetPlayer = true
        elseif not isMe then
            _lastTargetPlayer = false
        end
    end
end
    end
end)

-- ลูปหลักการทำงาน Smart Auto Ability
task.spawn(function()
    while true do
        task.wait(0.03)
        if AutoAbilityData.Enabled then
            pcall(function()
                local ball = Auto_Parry.Get_Ball()
                if not ball then return end
                
                local abilityName = getEquippedAbility()
                if not abilityName then return end
                
                local timing = ABILITY_TIMINGS[abilityName] or { cooldown = 10, fireAt = 0.2, trigger = "target" }
                local lastFire = _abilityLastFire[abilityName] or 0
                
                -- เช็ค คูลดาวน์สกิล
                if (tick() - lastFire) < timing.cooldown then return end
                
                local isTargetingMe = (tostring(ball:GetAttribute("target")) == game.Players.LocalPlayer.Name)
                local char = game.Players.LocalPlayer.Character
                local hrp = char and char:FindFirstChild("HumanoidRootPart")
                local ballDist = hrp and (ball.Position - hrp.Position).Magnitude or 999
                
                local shouldFire = false
                
                if timing.trigger == "target" and isTargetingMe then
                    if (tick() - _targetStartTime) >= timing.fireAt then
                        shouldFire = true
                    end
                elseif timing.trigger == "proximity" and isTargetingMe and ballDist <= 45 then
                    shouldFire = true
                end
                
                if shouldFire then
                    if fireAbilityRemote() then
                        _abilityLastFire[abilityName] = tick()
                        AutoAbilityData.LastAbilityName = abilityName
                    end
                end
            end)
        end
    end
end)


local RunService = game:GetService("RunService")
local StatsService = game:GetService("Stats")
local LocalPlayer = game.Players.LocalPlayer

-- ═══════════════════════════════════════════════════════════════════════════
-- ⚡ ULTRA SPAM THREAD (ทำงานตลอดเมื่อเข้าเงื่อนไข Overtime)
-- ═══════════════════════════════════════════════════════════════════════════
shared.ManualSpamActive = false

task.spawn(function()
    while true do
        if shared.ManualSpamActive then
            Auto_Parry.FireParryRemote(true)
            RunService.RenderStepped:Wait() -- วนรัวตาม Frame Rate ของเครื่อง
        else
            task.wait(0.05)
        end
    end
end)

-- ตัวแประบบติดตามบอลและเวลา Clash
local _lastBallInstance = nil
local _clashStartTime = 0

local lastHitTicks = {}

-- ═══════════════════════════════════════════════════════════════════════════
-- ═══ CORE PHYSICS LOOP (OPTIMIZED AUTO PARRY ENGINE - FIXED & LOCKED) ═══
-- ═══════════════════════════════════════════════════════════════════════════

local parryLocked = {}
local lockTime = {}
local lastParryTime = 0

shared._PhysicsBind = RunService.RenderStepped:Connect(function()
    if not shared._InvisRunning then return end
    
    if not LocalPlayer.Character or not LocalPlayer.Character.PrimaryPart then 
        shared.ManualSpamActive = false
        _clashStartTime = 0
        return 
    end

    local balls = Auto_Parry.Get_Balls()

    if #balls == 0 then
        shared.ManualSpamActive = false
        _clashStartTime = 0
        return
    end

    local hrp = LocalPlayer.Character.HumanoidRootPart
    local playerPos = hrp.Position

    -- 📡 คำนวณ Ping
    local pingSeconds = 0.03
    pcall(function() 
        pingSeconds = (StatsService.Network.ServerStatsItem["Data Ping"]:GetValue()) / 1000 
    end)

    local anyTargetingMe = false
    local shouldSpamAny = false
    local now = tick()

    -- 🔄 วน Loop เช็คบอลทุกลูกในแมพ
    for idx, Ball in ipairs(balls) do
        if not Ball or not Ball.Parent then continue end

        local Zoomies = Ball:FindFirstChild("zoomies")
        local Velocity = Zoomies and Zoomies.VectorVelocity or Ball.AssemblyLinearVelocity
        local Speed = Velocity.Magnitude
        
        -- 🎯 ตรวจสอบ Target (รองรับทั้ง target และ Target)
        local targetAttr = Ball:GetAttribute("target") or Ball:GetAttribute("Target")
        local ballTargetStr = tostring(targetAttr or "")
        local isTargetingMe = (ballTargetStr == LocalPlayer.Name or ballTargetStr == tostring(LocalPlayer))
        
        if Config.SoccerMode then isTargetingMe = true end

        -- ⚡ ถ้าบอลไม่ได้เล็งเรา ให้ล้าง Lock และ Cooldown ทันที
        if not isTargetingMe then
            lastHitTicks[Ball] = 0
            parryLocked[Ball] = false
            lockTime[Ball] = 0
        else
            anyTargetingMe = true
        end

        -- 🔓 ระบบ Unlock อัตโนมัติเมื่อตีไปแล้วครบ 0.72 วินาที (แม้บอลยังเล็งเราอยู่)
        if parryLocked[Ball] then
            if (now - (lockTime[Ball] or 0)) >= 0.72 then
                parryLocked[Ball] = false
            end
        end

        local ballPos = Ball.Position
        local Distance = (playerPos - ballPos).Magnitude

        _ZX_pushVelSample("ball_" .. tostring(idx), ballPos, Velocity)
        _ZX_pushVelSample("player", playerPos, hrp.AssemblyLinearVelocity)

        local isCurving = Auto_Parry.Is_Curved and Auto_Parry.Is_Curved(Ball) or Auto_Parry.Is_Curved()
        local isVerticalDrop = (ballPos.Y - playerPos.Y > 6) and (Velocity.Y < -12)
        
        -- 🛡️ [PROTECTION OVERRIDE] (ระบบกันโค้งคงเดิม)
        if Speed > 120 or Distance <= 30 then
            isCurving = false
        elseif not isCurving then
            isCurving = false
        else
            if Distance <= 45 or Speed <= 85 then
                isCurving = false
            end
        end

        -- 📡 คำนวณ Cooldown แบบ Dynamic
        local dynamicCooldown = math.clamp(pingSeconds * 1.2 + 0.15, 0.15, 1.2)

        if Speed > 150 or Distance <= 25 then
            dynamicCooldown = math.max(0.08, dynamicCooldown * 0.8)
        end

        -- เช็คเงื่อนไข Cooldown และ Status Lock ก่อนอนุญาตให้ตี
        local cooldownPassed = (now - (lastHitTicks[Ball] or 0)) >= dynamicCooldown
        local notLocked = not parryLocked[Ball]
        local allowedToHit = isTargetingMe and cooldownPassed and notLocked

        -- 🎯 AUTO PARRY CALCULATION
        if Config.AutoParry and allowedToHit and isTargetingMe then
            local reachTime = Distance / math.max(Speed, 1)
            
            -- กันบั๊ก Vector คำนวณได้ NaN เมื่อความเร็วบอลเป็น 0
            local ballDirection = Speed > 1 and Velocity.Unit or Vector3.new(0, -1, 0)
            local toPlayerDirection = Distance > 0.1 and (playerPos - ballPos).Unit or Vector3.new(0, 0, 0)
            local dotProduct = (Speed > 1 and Distance > 0.1) and ballDirection:Dot(toPlayerDirection) or 1

            local triggerParry = false

            if Config.ParryMode == "Distance" then
                local emergencyDist = GetEmergencyDistance(Speed)
                
                -- ระยะฉุกเฉิน / บอลใกล้ตัวมาก ตีทันที
                if Distance <= emergencyDist or Distance <= 12 then
                    triggerParry = true
                else
                    if isCurving then
                        local curveSafetyDistance = math.clamp(Speed * 0.35, 15, 65)
                        if Distance <= curveSafetyDistance and dotProduct > -0.4 then
                            triggerParry = true
                        end
                    else
                        local userScale = (Config.DistanceTiming or 100) / 100
                        local baseThreshold = (15 + Speed * 0.18) * userScale
                        local pingBuffer = pingSeconds * Speed * 1.35 
                        
                        if Speed > 100 then
                            local speedFactor = (Speed - 100) * 0.3
                            baseThreshold = baseThreshold + speedFactor
                        end
                        
                        local calculatedThreshold = baseThreshold + pingBuffer
                        local maxAllowedDist = math.max(emergencyDist + 10, Speed * (pingSeconds + 0.55))
                        local finalThreshold = math.min(calculatedThreshold, maxAllowedDist)
                        
                        if Distance <= finalThreshold and (dotProduct > -0.25 or Distance <= 20) and reachTime <= 0.6 then
                            triggerParry = true
                        end
                    end
                end
            elseif Config.ParryMode == "Time" then
                local targetWindow = Config.TargetTime or 0.2
                local triggerTime = targetWindow + pingSeconds + (Speed > 120 and 0.05 or 0)
                
                if isCurving and not isVerticalDrop then
                    local curveSafetyDistance = math.clamp(Speed * 0.35, 14, 75)
                    if Distance <= curveSafetyDistance and dotProduct > -0.5 then
                        triggerParry = true
                    end
                else
                    if (reachTime <= triggerTime or Distance <= 15) and dotProduct > -0.25 then
                        triggerParry = true
                    end
                end
            end

            -- 🚀 สั่ง Parry พร้อม Lock และป้องกัน Double Click
            if triggerParry and (now - lastParryTime >= 0.08) then
                Auto_Parry.FireParryRemote()
                lastParryTime = now
                lastHitTicks[Ball] = now
                parryLocked[Ball] = true
                lockTime[Ball] = now
            end
        end

        -- ⚡ AUTO CLASH / OVERTIME SPAM SYSTEM
        if Config.AutoSpam and isTargetingMe then
            local targetPlr = Auto_Parry.GetTargetPlayer()
            local isSpamZone = targetPlr and targetPlr.PrimaryPart and (playerPos - targetPlr.PrimaryPart.Position).Magnitude <= 35
            local dynamicSpamDist = math.clamp(Speed * 0.08, 12, 30) 
            
            if (Distance <= dynamicSpamDist) or (isSpamZone and Distance <= 20) then
                shouldSpamAny = true
                
if Speed >= 80 or (isSpamZone and Distance <= 15) then
                    -- ป้องกันการคลิกซ้ำเกินไป (Debounce 0.08 วินาที)
                    if now - lastParryTime > 0.08 then
                        Auto_Parry.FireParryRemote(true)
                        lastParryTime = now
                        lastHitTicks[Ball] = now
                    end
                end
            end
        end
    end

    -- 🚨 ระบบจัดการสถานะ Clash / Spam
    if not anyTargetingMe then
        _clashStartTime = 0
        shared.ManualSpamActive = false
    else
        if shouldSpamAny then
            if _clashStartTime == 0 then
                _clashStartTime = tick()
            end
            shared.ManualSpamActive = true
        else
            _clashStartTime = 0
            shared.ManualSpamActive = false
        end
    end
end)

local Players = game:GetService("Players")
local TextChatService = game:GetService("TextChatService")
local player = Players.LocalPlayer

local isVipTagEnabled = false

-- ฟังก์ชันสำหรับดักจับและแก้ไขข้อความแชทฝั่ง Client (TextChatService แบบใหม่)
local function setupTextChat()
    if TextChatService.ChatVersion == Enum.ChatVersion.TextChatService then
        local channels = TextChatService:WaitForChild("TextChannels", 5)
        if channels then
            local rbxGeneral = channels:WaitForChild("RBXGeneral", 5)
            if rbxGeneral then
                rbxGeneral.OnIncomingMessage = function(message)
                    if isVipTagEnabled and message.TextSource then
                        local sender = Players:GetPlayerByUserId(message.TextSource.UserId)
                        if sender and sender == player then
                            local properties = Instance.new("TextChatMessageProperties")
                            properties.PrefixText = "<font color=\"#ffff00\">[VIP]</font> " .. message.PrefixText
                            return properties
                        end
                    end
                end
            end
        end
    end
end

-- รองรับระบบแชทแบบเก่า (Legacy Chat)
local function setupLegacyChat()
    local coreGui = game:GetService("CoreGui")
    
    player.Chatted:Connect(function(msg)
        if isVipTagEnabled then
            task.spawn(function()
                -- ค้นหาหน้าต่างแชทแบบเก่า (ClassicChatGui) ใน CoreGui หรือ PlayerGui
                local chatGui = coreGui:FindFirstChild("Chat") or player.PlayerGui:FindFirstChild("Chat")
                if chatGui then
                    local chatWindow = chatGui:FindFirstChild("ChatWindow")
                    local scroller = chatWindow and chatWindow:FindFirstChild("ScrollingFrame")
                    
                    if scroller then
                        -- ดักรอข้อความล่าสุดที่ถูกเพิ่มเข้ามาในแชทบ็อกซ์
                        local connection
                        connection = scroller.ChildAdded:Connect(function(child)
                            if child:IsA("TextLabel") or child.Name == "MessageTemplate" then
                                local textLabel = child:FindFirstChildOfClass("TextLabel") or (child:IsA("TextLabel") and child)
                                if textLabel and textLabel.Text:find(msg) then
                                    -- แก้ไขข้อความเฉพาะฝั่ง Local ให้แสดงแท็ก [VIP]
                                    textLabel.Text = "<font color=\"#ffff00\">[VIP]</font> " .. textLabel.Text
                                    connection:Disconnect()
                                end
                            end
                        end)
                        
                        -- ป้องกันการค้างกรณีหาไม่เจอ
                        task.delay(1, function()
                            if connection then
                                connection:Disconnect()
                            end
                        end)
                    end
                end
            end)
        end
    end)
end

pcall(setupTextChat)
pcall(setupLegacyChat)

-- ═══ GOD MODE SYSTEM THREAD ═══
task.spawn(function()
    while shared._InvisRunning do
        RunService.Heartbeat:Wait()
        if Config.GodMode then
            pcall(function()
                local ball = Auto_Parry.Get_Ball()
                if ball and LocalPlayer.Character and LocalPlayer.Character.PrimaryPart then
                    local sideVector = ball.CFrame.RightVector * 18
                    LocalPlayer.Character.PrimaryPart.CFrame = CFrame.new(ball.Position + sideVector, ball.Position)
                    LocalPlayer.Character.PrimaryPart.AssemblyLinearVelocity = Vector3.new(0,0,0)
                end
            end)
        else
            task.wait(0.1)
        end
    end
end)

task.spawn(function()
    local lastState = Config.LowGraphicsEnabled
    while shared._InvisRunning do
        task.wait(0.5)
        if Config.LowGraphicsEnabled ~= lastState then
            lastState = Config.LowGraphicsEnabled
            applyLowGraphics(Config.LowGraphicsEnabled)
        end
    end
end)

-- 🤖 AUTO PLAY BACKGROUND TASK (ADVANCED DYNAMIC MOVEMENT - UPDATED)
task.spawn(function()
    local lastBehaviorChange = 0
    local currentBehavior = "Chase"
    local randomOffset = Vector3.new(0, 0, 0)

    while true do
        task.wait(0.2)
        
        -- เช็คเงื่อนไข: เปิด AutoPlay, ตัวละครต้อง Alive และมีชีวิตจริง
        local character = LocalPlayer.Character
        local humanoid = character and character:FindFirstChildOfClass("Humanoid")
        local hrp = character and character:FindFirstChild("HumanoidRootPart")
        
        if Config.AutoPlay and shared._InvisRunning and humanoid and hrp and humanoid.Health > 0 then
            local balls = Auto_Parry.Get_Balls()
            local targetBall = nil
            local shortestDist = math.huge
            
            -- หาลูกบอลที่ใกล้ที่สุด
            for _, b in ipairs(balls) do
                if b and b.Parent then
                    local d = (hrp.Position - b.Position).Magnitude
                    if d < shortestDist then
                        shortestDist = d
                        targetBall = b
                    end
                end
            end
            
            if targetBall then
                -- เช็คความเร็วบอล (ดึงค่า Velocity)
                local zoomies = targetBall:FindFirstChild("zoomies")
                local velocity = zoomies and zoomies.VectorVelocity or targetBall.AssemblyLinearVelocity
                local ballSpeed = velocity.Magnitude
                
                local now = tick()
                
                -- 🚨 ถ้ารอบอลเร็วเกิน 250+ บังคับหนีและกระโดดรัวๆ ทันที (ไม่สุ่มโหมดอื่น)
                if ballSpeed >= 250 then
                    currentBehavior = "EmergencyEvade"
                    if humanoid.FloorMaterial ~= Enum.Material.Air then
                        humanoid.Jump = true
                    end
                else
                    -- สลับโหมดพฤติกรรมปกติทุกๆ 5 - 15 วินาที
                    if now - lastBehaviorChange > math.random(50, 150) / 10 then
                        lastBehaviorChange = now
                        local randRoll = math.random(1, 100)
                        
                        if randRoll <= 30 then
                            currentBehavior = "Chase"           -- 30% วิ่งเข้าหาบอล
                        elseif randRoll <= 45 then
                            currentBehavior = "Retreat"         -- 15% วิ่งถอยหลัง
                        elseif randRoll <= 60 then
                            currentBehavior = "Strafe"          -- 15% วิ่งวนรอบบอล
                            randomOffset = Vector3.new(math.random(-25, 25), 0, math.random(-25, 25))
                        elseif randRoll <= 75 then
                            currentBehavior = "TargetApproach"  -- 15% วิ่งเข้าหาคนที่โดนเล็ง
                        elseif randRoll <= 90 then
                            currentBehavior = "TargetEvade"     -- 15% วิ่งหนีคนที่โดนเล็ง
                        else
                            currentBehavior = "TargetOther"     -- 10% วิ่งไปหาคนอื่น
                        end
                        
                        if math.random(1, 100) <= 30 then
                            humanoid.Jump = true
                        end
                    end
                end
                
                -- ควบคุมการเคลื่อนไหวตามพฤติกรรม
                if currentBehavior == "EmergencyEvade" then
                    -- วิ่งหนีทั้งบอลและผู้เล่นคนอื่นที่อยู่ใกล้
                    local evadeDir = (hrp.Position - targetBall.Position).Unit
                    local evadePos = hrp.Position + (evadeDir * 35)
                    humanoid:MoveTo(evadePos)
                    
                elseif currentBehavior == "Chase" then
                    humanoid:MoveTo(targetBall.Position)
                    
                elseif currentBehavior == "Retreat" then
                    local escapeDir = (hrp.Position - targetBall.Position).Unit
                    humanoid:MoveTo(hrp.Position + (escapeDir * 20))
                    
                elseif currentBehavior == "Strafe" then
                    humanoid:MoveTo(targetBall.Position + randomOffset)
                    
                elseif currentBehavior == "TargetApproach" or currentBehavior == "TargetEvade" then
                    -- หาคนที่บอลกำลัง Target อยู่
                    local targetPlayerName = targetBall:GetAttribute("target") or targetBall:GetAttribute("Target")
                    local targetPlayerObj = nil
                    
                    for _, p in ipairs(game:GetService("Players"):GetPlayers()) do
                        if p.Name == tostring(targetPlayerName) or tostring(p) == tostring(targetPlayerName) then
                            targetPlayerObj = p
                            break
                        end
                    end
                    
                    if targetPlayerObj and targetPlayerObj.Character and targetPlayerObj.Character:FindFirstChild("HumanoidRootPart") then
                        local targetPlrPos = targetPlayerObj.Character.HumanoidRootPart.Position
                        if currentBehavior == "TargetApproach" then
                            humanoid:MoveTo(targetPlrPos) -- วิ่งเข้าหาคนที่โดน target
                        else
                            local runAwayDir = (hrp.Position - targetPlrPos).Unit
                            humanoid:MoveTo(hrp.Position + (runAwayDir * 25)) -- วิ่งหนีคนที่โดน target
                        end
                    else
                        humanoid:MoveTo(targetBall.Position)
                    end
                    
                elseif currentBehavior == "TargetOther" then
                    local randomOtherPos = nil
                    for _, player in ipairs(game:GetService("Players"):GetPlayers()) do
                        if player ~= LocalPlayer and player.Character and player.Character:FindFirstChild("HumanoidRootPart") then
                            randomOtherPos = player.Character.HumanoidRootPart.Position
                            break
                        end
                    end
                    
                    if randomOtherPos then
                        humanoid:MoveTo(randomOtherPos)
                    else
                        humanoid:MoveTo(targetBall.Position)
                    end
                end
            end
        else
            -- ถ้าไม่ได้เปิด หรือตัวละครตาย/ยังไม่เกิด ให้พักลูปยาวขึ้นเพื่อรอรอบใหม่
            task.wait(1)
        end
    end
end)

-- ═══ AFK MODE SYSTEM ═══
local ReplicatedStorage = game:GetService("ReplicatedStorage")

task.spawn(function()
    local lastAfkState = Config.AfkMode
    while shared._InvisRunning do
        task.wait(0.2)
        if Config.AfkMode ~= lastAfkState then
            lastAfkState = Config.AfkMode
            
            -- ยิง Remote ตามสถานะปัจจุบัน (true หรือ false)
            pcall(function()
                local event = ReplicatedStorage:FindFirstChild("Remotes") and ReplicatedStorage.Remotes:FindFirstChild("ChangedAfkMode")
                if event then
                    event:FireServer(Config.AfkMode)
                end
            end)
            
            local statusText = Config.AfkMode and "Enabled" or "Disabled"
            CustomNotify("AFK Mode " .. statusText, 2)
        end
    end
end)

-- ═══ SERVER CONTROLLER UTILITIES ══════════════════════════════════════
local function RejoinServer()
    task.wait(0.5)
    pcall(function() TeleportService:TeleportToPlaceInstance(game.PlaceId, game.JobId, LocalPlayer) end)
end

local function ServerHop()
    pcall(function()
        local sfUrl = "https://games.roblox.com/v1/games/" .. game.PlaceId .. "/servers/Public?sortOrder=Asc&limit=100"
        local req = HttpService:JSONDecode(game:HttpGet(sfUrl))
        for _, server in ipairs(req.data) do
            if server.id ~= game.JobId and server.playing < server.maxPlayers then
                TeleportService:TeleportToPlaceInstance(game.PlaceId, server.id, LocalPlayer)
                break
            end
        end
    end)
end

local function PlayCustomAnimation(id)
    pcall(function()
        local char = LocalPlayer.Character
        local hum = char and char:FindFirstChildOfClass("Humanoid")
        if hum and hum.Animator and id ~= "" then
            local anim = Instance.new("Animation")
            anim.AnimationId = "rbxassetid://" .. tostring(id)
            local track = hum.Animator:LoadAnimation(anim)
            track:Play()
            pcall(function() anim:Destroy() end)
        end
    end)
end


-- ═══ PLAYER ABILITY ESP TRACKER MODULE ═══
local function createBillboardGui(p)
    if p == LocalPlayer then return end
    task.spawn(function()
        local character = p.Character or p.CharacterAdded:Wait()
        local head = character:WaitForChild("Head", 10)
        if not head then return end
        if head:FindFirstChild("AbilityESP_Gui") then head.AbilityESP_Gui:Destroy() end
        
        local bg = Instance.new("BillboardGui", head)
        bg.Name = "AbilityESP_Gui"; bg.Adornee = head; bg.Size = UDim2.new(0, 200, 0, 40); bg.StudsOffset = Vector3.new(0, 3, 0); bg.AlwaysOnTop = true
        
        local tl = Instance.new("TextLabel", bg)
        tl.Size = UDim2.new(1, 0, 1, 0); tl.TextColor3 = Color3.fromRGB(255, 75, 75); tl.TextSize = 13; tl.TextStrokeTransparency = 0; tl.TextStrokeColor3 = Color3.fromRGB(0, 0, 0); tl.Font = Enum.Font.GothamBold; tl.BackgroundTransparency = 1
        
        local conn
        conn = RunService.Heartbeat:Connect(function()
            if not character or not character.Parent or not bg or not bg.Parent then conn:Disconnect() return end
            if Config.AbilityESP then
                bg.Enabled = true
                local currentAbil = p:GetAttribute("EquippedAbility") or p:GetAttribute("Ability") or "None"
                tl.Text = p.DisplayName .. " ⚔️ [" .. tostring(currentAbil) .. "]"
            else
                bg.Enabled = false
            end
        end)
    end)
end
for _, p in pairs(Players:GetPlayers()) do p.CharacterAdded:Connect(function() createBillboardGui(p) end) if p.Character then createBillboardGui(p) end end
Players.PlayerAdded:Connect(function(p) p.CharacterAdded:Connect(function() createBillboardGui(p) end) end)

-- ═══ GUI SETUP LAYOUTS ═══
local ToggleBtn = Instance.new("TextButton", ScreenGui)
ToggleBtn.Size = UDim2.new(0, 85, 0, 38); ToggleBtn.Position = UDim2.new(0.05, 0, 0.15, 0); ToggleBtn.BackgroundColor3 = Color3.fromRGB(15, 15, 22); ToggleBtn.Text = "INVIS"; ToggleBtn.TextColor3 = Color3.fromRGB(255, 60, 60); ToggleBtn.Font = Enum.Font.GothamBold; ToggleBtn.TextSize = 14
Instance.new("UICorner", ToggleBtn).CornerRadius = UDim.new(0, 8)
local tStroke = Instance.new("UIStroke", ToggleBtn); tStroke.Color = Color3.fromRGB(255, 60, 60); tStroke.Thickness = 1.5
local tDrag, tStart, tPos
ToggleBtn.InputBegan:Connect(function(i) if i.UserInputType == Enum.UserInputType.MouseButton1 or i.UserInputType == Enum.UserInputType.Touch then tDrag = true; tStart = i.Position; tPos = ToggleBtn.Position end end)
UserInputService.InputChanged:Connect(function(i) if tDrag and (i.UserInputType == Enum.UserInputType.MouseMovement or i.UserInputType == Enum.UserInputType.Touch) then local d = i.Position - tStart; ToggleBtn.Position = UDim2.new(tPos.X.Scale, tPos.X.Offset + d.X, tPos.Y.Scale, tPos.Y.Offset + d.Y) end end)
UserInputService.InputEnded:Connect(function(i) if i.UserInputType == Enum.UserInputType.MouseButton1 or i.UserInputType == Enum.UserInputType.Touch then tDrag = false end end)

local MainFrame = Instance.new("CanvasGroup", ScreenGui)
MainFrame.Size = UDim2.new(0, 560, 0, 330); MainFrame.Position = UDim2.new(0.3, 0, 0.25, 0); MainFrame.BackgroundColor3 = Color3.fromRGB(11, 11, 14); MainFrame.Visible = true; MainFrame.GroupTransparency = 0
Instance.new("UICorner", MainFrame).CornerRadius = UDim.new(0, 10)
local MainStroke = Instance.new("UIStroke", MainFrame); MainStroke.Thickness = 2.5
task.spawn(function() while shared._InvisRunning do MainStroke.Color = Color3.fromHSV((tick() % 4) / 4, 1, 1) task.wait() end end)
local guiOpenState, isTweening = true, false
local fadeTweenInfo = TweenInfo.new(0.23, Enum.EasingStyle.Quad, Enum.EasingDirection.Out)
ToggleBtn.MouseButton1Click:Connect(function()
    if isTweening then return end isTweening = true; guiOpenState = not guiOpenState
    if guiOpenState then
        MainFrame.Visible = true local tween = TweenService:Create(MainFrame, fadeTweenInfo, {GroupTransparency = 0}) tween:Play() tween.Completed:Connect(function() isTweening = false end)
    else
        local tween = TweenService:Create(MainFrame, fadeTweenInfo, {GroupTransparency = 1}) tween:Play() tween.Completed:Connect(function() if not guiOpenState then MainFrame.Visible = false end isTweening = false end)
    end
end)
local mDrag, mStart, mPos
MainFrame.InputBegan:Connect(function(i) if i.UserInputType == Enum.UserInputType.MouseButton1 or i.UserInputType == Enum.UserInputType.Touch then mDrag = true; mStart = i.Position; mPos = MainFrame.Position end end)
UserInputService.InputChanged:Connect(function(i) if mDrag and (i.UserInputType == Enum.UserInputType.MouseMovement or i.UserInputType == Enum.UserInputType.Touch) then local d = i.Position - mStart; MainFrame.Position = UDim2.new(mPos.X.Scale, mPos.X.Offset + d.X, mPos.Y.Scale, mPos.Y.Offset + d.Y) end end)
UserInputService.InputEnded:Connect(function(i) if i.UserInputType == Enum.UserInputType.MouseButton1 or i.UserInputType == Enum.UserInputType.Touch then mDrag = false end end)

local Title = Instance.new("TextLabel", MainFrame)
Title.Size = UDim2.new(1, 0, 0, 42); Title.Text = "⚡ INVIS HUB PREMIUM EDITION  [ V4 FULL EXPLOITS OMNI ]"; Title.TextColor3 = Color3.fromRGB(255,255,255); Title.Font = Enum.Font.GothamBold; Title.TextSize = 11; Title.BackgroundColor3 = Color3.fromRGB(15, 15, 20)
local Sidebar = Instance.new("Frame", MainFrame)
Sidebar.Size = UDim2.new(0, 140, 1, -42); Sidebar.Position = UDim2.new(0, 0, 0, 42); Sidebar.BackgroundColor3 = Color3.fromRGB(14, 14, 18)
local SideList = Instance.new("UIListLayout", Sidebar); SideList.Padding = UDim.new(0, 4); SideList.HorizontalAlignment = Enum.HorizontalAlignment.Center
local ContentContainer = Instance.new("Frame", MainFrame)
ContentContainer.Size = UDim2.new(1, -145, 1, -46); ContentContainer.Position = UDim2.new(0, 145, 0, 44); ContentContainer.BackgroundTransparency = 1
local TabFrames = {}
local function createTabScroll(tabName)
    local scr = Instance.new("ScrollingFrame", ContentContainer)
    scr.Size = UDim2.new(1, 0, 1, 0); scr.BackgroundTransparency = 1; scr.CanvasSize = UDim2.new(0, 0, 0, 680); scr.ScrollBarThickness = 3; scr.Visible = false
        local UIList = Instance.new("UIListLayout", scr); UIList.Padding = UDim.new(0, 5); UIList.HorizontalAlignment = Enum.HorizontalAlignment.Center
    TabFrames[tabName] = scr return scr
end

local combatScroll = createTabScroll("Combat")
local visualScroll = createTabScroll("Visuals")
local settingsScroll = createTabScroll("Settings")
TabFrames["Combat"].Visible = true

local function setupTabButton(name)
    local btn = Instance.new("TextButton", Sidebar); btn.Size = UDim2.new(1, -10, 0, 36); btn.BackgroundColor3 = Color3.fromRGB(22, 22, 28); btn.Text = name; btn.TextColor3 = Color3.fromRGB(230, 230, 230); btn.Font = Enum.Font.GothamBold; btn.TextSize = 11
    Instance.new("UICorner", btn).CornerRadius = UDim.new(0, 6)
    btn.MouseButton1Click:Connect(function() for tName, frame in pairs(TabFrames) do frame.Visible = (tName == name) end end)
end
setupTabButton("Combat")
setupTabButton("Visuals")
setupTabButton("Settings")

local function createToggle(name, stateKey, parent)
local btn = Instance.new("TextButton")
    if typeof(parent) == "Instance" then 
        btn.Parent = parent 
    end
    btn.Size = UDim2.new(1, -10, 0, 34)
    btn.BackgroundColor3 = Color3.fromRGB(20, 20, 26)
    btn.Font = Enum.Font.GothamBold
    btn.TextSize = 11
    Instance.new("UICorner", btn).CornerRadius = UDim.new(0, 5)
    local update = function()
        if stateKey == "SkinChangerEnabled" then
             if getgenv().skinChanger then btn.Text = name .. " : ACTIVE"; btn.TextColor3 = Color3.fromRGB(80, 255, 80) else btn.Text = name .. " : DISABLED"; btn.TextColor3 = Color3.fromRGB(255, 80, 80) end
        else
            if Config[stateKey] then btn.Text = name .. " : ACTIVE"; btn.TextColor3 = Color3.fromRGB(80, 255, 80) else btn.Text = name .. " : DISABLED"; btn.TextColor3 = Color3.fromRGB(255, 80, 80) end
        end
    end
    btn.MouseButton1Click:Connect(function()
        if stateKey == "SkinChangerEnabled" then
            getgenv().skinChanger = not getgenv().skinChanger
            pcall(function() getgenv().updateSword() end)
        else
            Config[stateKey] = not Config[stateKey]
        end
        CustomNotify(name .. " Toggled!", 2) update()
    end)
    update()
end

local function createCycle(name, stateKey, list, parent)
    local btn = Instance.new("TextButton", parent); btn.Size = UDim2.new(1, -10, 0, 34); btn.BackgroundColor3 = Color3.fromRGB(26, 28, 38); btn.TextColor3 = Color3.fromRGB(100, 160, 255); btn.Font = Enum.Font.GothamBold; btn.TextSize = 11
    Instance.new("UICorner", btn).CornerRadius = UDim.new(0, 5)
    local update = function() btn.Text = name .. " : [ " .. tostring(Config[stateKey]) .. " ]" end
    btn.MouseButton1Click:Connect(function() local idx = table.find(list, Config[stateKey]) or 1 Config[stateKey] = list[idx + 1 > #list and 1 or idx + 1] update() end)
    update()
end

local function createActionBtn(text, color, fn, parent)
    local btn = Instance.new("TextButton", parent); btn.Size = UDim2.new(1, -10, 0, 32); btn.BackgroundColor3 = color; btn.TextColor3 = Color3.fromRGB(255,255,255); btn.Font = Enum.Font.GothamBold; btn.TextSize = 11; btn.Text = text
    Instance.new("UICorner", btn).CornerRadius = UDim.new(0, 5)
    btn.MouseButton1Click:Connect(fn)
end

-- --- COMBAT CONTROLS ---
createToggle("Auto Parry System", "AutoParry", combatScroll)
createToggle("Soccer Mode (No Locked Target)", "SoccerMode", combatScroll)
createToggle("God Mode (18 Studs Loop Side)", "GodMode", combatScroll)
createToggle("Smart Auto Ability", "AutoAbility", combatScroll)
createToggle("Special Skill Detections", "SpecialSkillDetections", combatScroll)
createCycle("Parry Mode Selection", "ParryMode", {"Distance", "Time"}, combatScroll)
local lblTTime = Instance.new("TextLabel", combatScroll); lblTTime.Size = UDim2.new(1,0,0,16); lblTTime.Text = "—— Pre-Hit Time Input (Time Mode) ——"; lblTTime.TextColor3 = Color3.fromRGB(255,140,140); lblTTime.Font = Enum.Font.Gotham; lblTTime.TextSize = 10; lblTTime.BackgroundTransparency = 1
local TimeInputBox = Instance.new("TextBox", combatScroll)
TimeInputBox.Size = UDim2.new(1, -10, 0, 32); TimeInputBox.BackgroundColor3 = Color3.fromRGB(30, 20, 20); TimeInputBox.Text = tostring(Config.TargetTime); TimeInputBox.TextColor3 = Color3.fromRGB(255,100,100); TimeInputBox.Font = Enum.Font.GothamBold; TimeInputBox.TextSize = 11
Instance.new("UICorner", TimeInputBox).CornerRadius = UDim.new(0, 5)
TimeInputBox.FocusLost:Connect(function()
    local n = tonumber(TimeInputBox.Text)
    if n then Config.TargetTime = n CustomNotify("Pre-Hit TargetTime: " .. tostring(n), 2) else TimeInputBox.Text = tostring(Config.TargetTime) end
end)
local lblDistHeader = Instance.new("TextLabel", combatScroll); lblDistHeader.Size = UDim2.new(1,0,0,18); lblDistHeader.Text = "—— Distance Mode Timing ——"; lblDistHeader.TextColor3 = Color3.fromRGB(160,160,160); lblDistHeader.Font = Enum.Font.Gotham; lblDistHeader.TextSize = 10; lblDistHeader.BackgroundTransparency = 1
local DistInput = Instance.new("TextBox", settingsScroll)
DistInput.Size = UDim2.new(1, -10, 0, 34); DistInput.BackgroundColor3 = Color3.fromRGB(24, 24, 30); DistInput.Text = tostring(Config.DistanceTiming); DistInput.TextColor3 = Color3.fromRGB(80, 220, 255); DistInput.Font = Enum.Font.GothamBold; DistInput.TextSize = 11
Instance.new("UICorner", DistInput).CornerRadius = UDim.new(0, 5)
DistInput.FocusLost:Connect(function() local val = tonumber(DistInput.Text) if val then Config.DistanceTiming = val else DistInput.Text = tostring(Config.DistanceTiming) end end)
createToggle("Play Parry Animation Track", "SwordAnimationsEnabled", combatScroll)
createToggle("Auto Spam Clash", "AutoSpam", combatScroll)
createToggle("Auto Play (Alive)", "AutoPlay", combatScroll)


createActionBtn("🔥 Ultra Spam (Can kill forcefield)", Color3.fromRGB(80, 20, 20), function()
    loadstring(game:HttpGet("https://gist.githubusercontent.com/foreverspacexc-blip/570db122f01f685727b3409adb314419/raw/dd3631412ec66ca86d22778a592f9a32abf45a5d/gistfile1.txt"))()
    CustomNotify("Ultra Spam Loaded!", 2.5)
end, combatScroll)

-- --- VISUAL CONTROLS ---
createToggle("Player Ability ESP Tracker", "AbilityESP", visualScroll)
createToggle("Enable Visual Sword Changer Backend", "SkinChangerEnabled", visualScroll)
createToggle("⭐ VIP Tag (Local Only)", false, combatScroll, function(state)
    isVipTagEnabled = state
    
    if type(CustomNotify) == "function" then
        if state then
            CustomNotify("VIP Tag Enabled (Local)", 2)
        else
            CustomNotify("VIP Tag Disabled", 2)
        end
    end
end)

createActionBtn("🔓 Unlock All [Sword/Emote/Explode]", Color3.fromRGB(40, 40, 95), function()
    if type(CustomNotify) == "function" then
        CustomNotify("[Levi Hub] Executing Unlock All...", 2)
    end
    
    local successRun, err = pcall(function()
        loadstring(game:HttpGet("https://pastebin.com/raw/0V5CWx1v"))()
    end)
    
    if successRun then
        if type(CustomNotify) == "function" then
            CustomNotify("[Make By xbudsx] Successfully Unlocked All! [remake By Levi hub]", 2)
        end
    else
        warn("Levi Hub Error: " .. tostring(err))
        if type(CustomNotify) == "function" then
            CustomNotify("Failed to execute script!", 2)
        end
    end
end, visualScroll)


local SwordInput = Instance.new("TextBox", visualScroll)
SwordInput.Size = UDim2.new(1, -10, 0, 32); SwordInput.BackgroundColor3 = Color3.fromRGB(24, 24, 30); SwordInput.PlaceholderText = "Type Sword Model Asset Name..."; SwordInput.Text = ""; SwordInput.TextColor3 = Color3.fromRGB(255, 255, 255); SwordInput.Font = Enum.Font.GothamBold; SwordInput.TextSize = 11
Instance.new("UICorner", SwordInput).CornerRadius = UDim.new(0, 5)
SwordInput.FocusLost:Connect(function() getgenv().swordModel = SwordInput.Text; pcall(function() getgenv().updateSword() end) end)
local SwordAnimInput = Instance.new("TextBox", visualScroll)
SwordAnimInput.Size = UDim2.new(1, -10, 0, 32); SwordAnimInput.BackgroundColor3 = Color3.fromRGB(24, 24, 30); SwordAnimInput.PlaceholderText = "Type Custom Animations Name (Optional)..."; SwordAnimInput.Text = ""; SwordAnimInput.TextColor3 = Color3.fromRGB(255, 255, 255); SwordAnimInput.Font = Enum.Font.GothamBold; SwordAnimInput.TextSize = 11
Instance.new("UICorner", SwordAnimInput).CornerRadius = UDim.new(0, 5)
SwordAnimInput.FocusLost:Connect(function() getgenv().swordAnimations = SwordAnimInput.Text; pcall(function() getgenv().updateSword() end) end)
local SwordFXInput = Instance.new("TextBox", visualScroll)
SwordFXInput.Size = UDim2.new(1, -10, 0, 32); SwordFXInput.BackgroundColor3 = Color3.fromRGB(24, 24, 30); SwordFXInput.PlaceholderText = "Type Sword Custom FX Name (Optional)..."; SwordFXInput.Text = ""; SwordFXInput.TextColor3 = Color3.fromRGB(255, 255, 255); SwordFXInput.Font = Enum.Font.GothamBold; SwordFXInput.TextSize = 11
Instance.new("UICorner", SwordFXInput).CornerRadius = UDim.new(0, 5)
SwordFXInput.FocusLost:Connect(function() getgenv().swordFX = SwordFXInput.Text; pcall(function() getgenv().updateSword() end) end)

-- --- SYSTEM SETTINGS ---
local lblSpeed = Instance.new("TextLabel", settingsScroll); lblSpeed.Size = UDim2.new(1,0,0,16); lblSpeed.Text = "—— Set WalkSpeed Modifier ——"; lblSpeed.TextColor3 = Color3.fromRGB(150,255,150); lblSpeed.Font = Enum.Font.Gotham; lblSpeed.TextSize = 10; lblSpeed.BackgroundTransparency = 1
local SpeedBox = Instance.new("TextBox", settingsScroll)
SpeedBox.Size = UDim2.new(1, -10, 0, 32); SpeedBox.BackgroundColor3 = Color3.fromRGB(20, 28, 20); SpeedBox.PlaceholderText = "Speed (Default is 25)"; SpeedBox.TextColor3 = Color3.fromRGB(100,255,100); SpeedBox.Font = Enum.Font.GothamBold; SpeedBox.TextSize = 11; SpeedBox.Text = ""
Instance.new("UICorner", SpeedBox).CornerRadius = UDim.new(0, 5)
SpeedBox.FocusLost:Connect(function() local n = tonumber(SpeedBox.Text) Config.CustomSpeed = n CustomNotify("WalkSpeed Enforced: " .. tostring(n or "Default"), 2) end)

local lblJump = Instance.new("TextLabel", settingsScroll); lblJump.Size = UDim2.new(1,0,0,16); lblJump.Text = "—— Set JumpPower Modifier ——"; lblJump.TextColor3 = Color3.fromRGB(255,200,100); lblJump.Font = Enum.Font.Gotham; lblJump.TextSize = 10; lblJump.BackgroundTransparency = 1
local JumpBox = Instance.new("TextBox", settingsScroll)
JumpBox.Size = UDim2.new(1, -10, 0, 32); JumpBox.BackgroundColor3 = Color3.fromRGB(32, 26, 20); JumpBox.PlaceholderText = "Default (50)"; JumpBox.TextColor3 = Color3.fromRGB(255,180,50); JumpBox.Font = Enum.Font.GothamBold; JumpBox.TextSize = 11; JumpBox.Text = ""
Instance.new("UICorner", JumpBox).CornerRadius = UDim.new(0, 5)
JumpBox.FocusLost:Connect(function() local n = tonumber(JumpBox.Text) Config.CustomJump = n CustomNotify("JumpPower Enforced: " .. tostring(n or "Default"), 2) end)

local lblTargetHeader = Instance.new("TextLabel", settingsScroll)
lblTargetHeader.Size = UDim2.new(1, 0, 0, 18)
lblTargetHeader.Text = "—— Target Player Name (Selected Mode) ——"
lblTargetHeader.TextColor3 = Color3.fromRGB(255, 200, 80)
lblTargetHeader.Font = Enum.Font.Gotham
lblTargetHeader.TextSize = 10
lblTargetHeader.BackgroundTransparency = 1

local TargetInputBox = Instance.new("TextBox", settingsScroll)
TargetInputBox.Size = UDim2.new(1, -10, 0, 34)
TargetInputBox.BackgroundColor3 = Color3.fromRGB(24, 24, 30)
TargetInputBox.PlaceholderText = "Type Player Name / DisplayName..."
TargetInputBox.Text = Config.SelectedTarget
TargetInputBox.TextColor3 = Color3.fromRGB(255, 200, 80)
TargetInputBox.Font = Enum.Font.GothamBold
TargetInputBox.TextSize = 11
Instance.new("UICorner", TargetInputBox).CornerRadius = UDim.new(0, 5)

TargetInputBox.FocusLost:Connect(function()
    Config.SelectedTarget = TargetInputBox.Text
    CustomNotify("Target Set To: " .. tostring(Config.SelectedTarget), 2)
end)

local CustomAnimBox = Instance.new("TextBox", settingsScroll)
CustomAnimBox.Size = UDim2.new(1, -10, 0, 32); CustomAnimBox.BackgroundColor3 = Color3.fromRGB(28, 28, 28); CustomAnimBox.PlaceholderText = "Enter Roblox Animation ID Here..."; CustomAnimBox.Text = ""; CustomAnimBox.TextColor3 = Color3.fromRGB(255,255,255); CustomAnimBox.Font = Enum.Font.GothamBold; CustomAnimBox.TextSize = 11
Instance.new("UICorner", CustomAnimBox).CornerRadius = UDim.new(0, 5)
CustomAnimBox.FocusLost:Connect(function() Config.CustomAnimID = CustomAnimBox.Text end)

createActionBtn("🎭 Execute Custom Anim ID Track", Color3.fromRGB(45, 20, 75), function() PlayCustomAnimation(Config.CustomAnimID) end, settingsScroll)
createActionBtn("🔄 Rejoin Server Instance", Color3.fromRGB(30, 75, 30), function() RejoinServer() end, settingsScroll)
createActionBtn("🌌 Server Hop Network Search", Color3.fromRGB(85, 60, 20), function() ServerHop() end, settingsScroll)
createActionBtn("🚀 Infinite Yield", Color3.fromRGB(50, 50, 50), function()
    if type(CustomNotify) == "function" then
        CustomNotify("[Levi Hub] Loading Infinite Yield...", 2)
    end
    
    local successRun, err = pcall(function()
        loadstring(game:HttpGet('https://raw.githubusercontent.com/EdgeIY/infiniteyield/master/source'))()
    end)
    
    if successRun then
        if type(CustomNotify) == "function" then
            CustomNotify("[Levi Hub] Infinite Yield Loaded!", 2)
        end
    else
        warn("Levi Hub Error: " .. tostring(err))
        if type(CustomNotify) == "function" then
            CustomNotify("[Levi Hub] Failed to load Infinite Yield!", 2)
        end
    end
end, settingsScroll)

createCycle("Curve Vector Direction", "ParryCurveMode", {
    "Straight",          -- ตรงไป
    "Right",             -- ขวา
    "Left",              -- ซ้าย
    "Up",                -- เสยขึ้น
    "Back",              -- ถอยหลัง
    "Fastball",          -- บอลเร็วเลียดพื้น
    "Slowball",          -- บอลย้อยช้า
    "Random",            -- สุ่มทุกวิถี
    "Camera",            -- ตามมุมกล้อง
    "Character",         -- ตามหน้าตัวละคร (ไม่สนกล้อง)
    "LeftRightRandom",   -- สุ่ม ซ้าย / ขวา
    "BackStraightRandom" -- สุ่ม หลัง / ตรงไป
}, settingsScroll)

createCycle("Lock Target Profile", "TargetMode", {"Nearest", "Farest", "Selected"}, settingsScroll)
createToggle("Auto Jump (Floor Only)", "AutoJumpEnabled", settingsScroll)
createToggle("AFK Mode", "AfkMode", settingsScroll)


-- ═══ KEYPAD WINDOWS SETUP ═══
local ManualSpamToggleBtn = Instance.new("TextButton", combatScroll)
ManualSpamToggleBtn.Size = UDim2.new(1, -10, 0, 34); ManualSpamToggleBtn.BackgroundColor3 = Color3.fromRGB(42, 22, 22); ManualSpamToggleBtn.TextColor3 = Color3.fromRGB(255, 140, 140); ManualSpamToggleBtn.Font = Enum.Font.GothamBold; ManualSpamToggleBtn.Text = "[ Open Manual Spam Keypad ]"; ManualSpamToggleBtn.TextSize = 11
Instance.new("UICorner", ManualSpamToggleBtn).CornerRadius = UDim.new(0, 5)

local MiniSpamFrame = Instance.new("Frame", ScreenGui)
MiniSpamFrame.Size = UDim2.new(0, 95, 0, 95); MiniSpamFrame.Position = UDim2.new(0.82, 0, 0.45, 0); MiniSpamFrame.BackgroundColor3 = Color3.fromRGB(16, 11, 11); MiniSpamFrame.Visible = false
Instance.new("UICorner", MiniSpamFrame).CornerRadius = UDim.new(0, 8)
local miniStroke = Instance.new("UIStroke", MiniSpamFrame); miniStroke.Color = Color3.fromRGB(220, 40, 40); miniStroke.Thickness = 2

local msDrag, msStart, msPos
MiniSpamFrame.InputBegan:Connect(function(i) if i.UserInputType == Enum.UserInputType.MouseButton1 or i.UserInputType == Enum.UserInputType.Touch then msDrag = true; msStart = i.Position; msPos = MiniSpamFrame.Position end end)
UserInputService.InputChanged:Connect(function(i) if msDrag and (i.UserInputType == Enum.UserInputType.MouseMovement or i.UserInputType == Enum.UserInputType.Touch) then local d = i.Position - msStart; MiniSpamFrame.Position = UDim2.new(msPos.X.Scale, msPos.X.Offset + d.X, msPos.Y.Scale, msPos.Y.Offset + d.Y) end end)
UserInputService.InputEnded:Connect(function(i) if i.UserInputType == Enum.UserInputType.MouseButton1 or i.UserInputType == Enum.UserInputType.Touch then msDrag = false end end)

local ClickSpamBtn = Instance.new("TextButton", MiniSpamFrame)
ClickSpamBtn.Size = UDim2.new(1, -10, 0, 40); ClickSpamBtn.Position = UDim2.new(0, 5, 0, 8); ClickSpamBtn.BackgroundColor3 = Color3.fromRGB(32, 16, 16); ClickSpamBtn.Text = "SPAM"; ClickSpamBtn.TextColor3 = Color3.fromRGB(255, 255, 255); ClickSpamBtn.Font = Enum.Font.GothamBold; ClickSpamBtn.TextSize = 11
Instance.new("UICorner", ClickSpamBtn).CornerRadius = UDim.new(0, 5)
ClickSpamBtn.MouseButton1Click:Connect(function() Config.ManualSpam = not Config.ManualSpam ClickSpamBtn.BackgroundColor3 = Config.ManualSpam and Color3.fromRGB(95, 22, 22) or Color3.fromRGB(32, 16, 16) end)

local SpeedInput = Instance.new("TextBox", MiniSpamFrame)
SpeedInput.Size = UDim2.new(1, -10, 0, 30); SpeedInput.Position = UDim2.new(0, 5, 0, 54); SpeedInput.BackgroundColor3 = Color3.fromRGB(24, 24, 30); SpeedInput.Text = "0.015"; SpeedInput.TextColor3 = Color3.fromRGB(0, 255, 150); SpeedInput.Font = Enum.Font.GothamBold; SpeedInput.TextSize = 10
Instance.new("UICorner", SpeedInput).CornerRadius = UDim.new(0, 4)
SpeedInput.FocusLost:Connect(function() local val = tonumber(SpeedInput.Text) if val then Config.ManualSpamSpeed = val else SpeedInput.Text = tostring(Config.ManualSpamSpeed) end end)
ManualSpamToggleBtn.MouseButton1Click:Connect(function() MiniSpamFrame.Visible = not MiniSpamFrame.Visible end)

local SuperSpamToggleBtn = Instance.new("TextButton", combatScroll)
SuperSpamToggleBtn.Size = UDim2.new(1, -10, 0, 34); SuperSpamToggleBtn.BackgroundColor3 = Color3.fromRGB(22, 22, 42); SuperSpamToggleBtn.TextColor3 = Color3.fromRGB(150, 150, 255); SuperSpamToggleBtn.Font = Enum.Font.GothamBold; SuperSpamToggleBtn.Text = "[ Open SUPER Spam Keypad ]"; SuperSpamToggleBtn.TextSize = 11
Instance.new("UICorner", SuperSpamToggleBtn).CornerRadius = UDim.new(0, 5)

local SuperSpamFrame = Instance.new("Frame", ScreenGui)
SuperSpamFrame.Size = UDim2.new(0, 105, 0, 95); SuperSpamFrame.Position = UDim2.new(0.82, 0, 0.60, 0); SuperSpamFrame.BackgroundColor3 = Color3.fromRGB(11, 11, 16); SuperSpamFrame.Visible = false
Instance.new("UICorner", SuperSpamFrame).CornerRadius = UDim.new(0, 8)
local SuperStroke = Instance.new("UIStroke", SuperSpamFrame); SuperStroke.Thickness = 2.5
task.spawn(function() while shared._InvisRunning do SuperStroke.Color = Color3.fromHSV((tick() % 35) / 35, 1, 1) task.wait() end end)

local ssDrag, ssStart, ssPos
SuperSpamFrame.InputBegan:Connect(function(i) if i.UserInputType == Enum.UserInputType.MouseButton1 or i.UserInputType == Enum.UserInputType.Touch then ssDrag = true; ssStart = i.Position; ssPos = SuperSpamFrame.Position end end)
SuperSpamFrame.InputChanged:Connect(function(i) if ssDrag and (i.UserInputType == Enum.UserInputType.MouseMovement or i.UserInputType == Enum.UserInputType.Touch) then local d = i.Position - ssStart; SuperSpamFrame.Position = UDim2.new(ssPos.X.Scale, ssPos.X.Offset + d.X, ssPos.Y.Scale, ssPos.Y.Offset + d.Y) end end)
SuperSpamFrame.InputEnded:Connect(function(i) if i.UserInputType == Enum.UserInputType.MouseButton1 or i.UserInputType == Enum.UserInputType.Touch then ssDrag = false end end)

local ClickSuperBtn = Instance.new("TextButton", SuperSpamFrame)
ClickSuperBtn.Size = UDim2.new(1, -10, 0, 40); ClickSuperBtn.Position = UDim2.new(0, 5, 0, 8); ClickSuperBtn.BackgroundColor3 = Color3.fromRGB(20, 20, 35); ClickSuperBtn.Text = "SUPER SPAM"; ClickSuperBtn.TextColor3 = Color3.fromRGB(255, 255, 255); ClickSuperBtn.Font = Enum.Font.GothamBold; ClickSuperBtn.TextSize = 10
Instance.new("UICorner", ClickSuperBtn).CornerRadius = UDim.new(0, 5)
ClickSuperBtn.MouseButton1Click:Connect(function() Config.SuperSpam = not Config.SuperSpam ClickSuperBtn.BackgroundColor3 = Config.SuperSpam and Color3.fromRGB(40, 40, 95) or Color3.fromRGB(20, 20, 35) end)

local SuperClicksInput = Instance.new("TextBox", SuperSpamFrame)
SuperClicksInput.Size = UDim2.new(1, -10, 0, 30); SuperClicksInput.Position = UDim2.new(0, 5, 0, 54); SuperClicksInput.BackgroundColor3 = Color3.fromRGB(24, 24, 32); SuperClicksInput.Text = "1"; SuperClicksInput.TextColor3 = Color3.fromRGB(255, 200, 0); SuperClicksInput.Font = Enum.Font.GothamBold; SuperClicksInput.TextSize = 11
Instance.new("UICorner", SuperClicksInput).CornerRadius = UDim.new(0, 4)
SuperClicksInput.FocusLost:Connect(function() local val = tonumber(SuperClicksInput.Text) if val and val >= 1 and math.floor(val) == val then Config.SuperSpamClicks = val else SuperClicksInput.Text = tostring(Config.SuperSpamClicks) end end)
SuperSpamToggleBtn.MouseButton1Click:Connect(function() SuperSpamFrame.Visible = not SuperSpamFrame.Visible end)

-- Normal Manual Spam Frame Loop
task.spawn(function()
    while shared._InvisRunning do
        if Config.ManualSpam then Auto_Parry.FireParryRemote() task.wait(math.clamp(Config.ManualSpamSpeed, 0.001, 1)) else task.wait(0.05) end
    end
end)

-- SUPER MANUAL SPAM ENGINE THREAD
task.spawn(function()
    while shared._InvisRunning do
        if Config.SuperSpam then
            local clickCounts = math.max(1, math.floor(Config.SuperSpamClicks))
            for i = 1, clickCounts do task.spawn(Auto_Parry.FireParryRemote) end
            task.wait(0.01)
        else
            task.wait(0.05)
        end
    end
end)

CustomNotify("INVIS V10 ULTRA FULLY INJECTED!", 4)