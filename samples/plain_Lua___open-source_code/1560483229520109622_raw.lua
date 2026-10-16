-- 28 HUB - Baseado em WindUI

local WindUI = loadstring(game:HttpGet("https://raw.githubusercontent.com/Footagesus/WindUI/main/dist/main.lua"))()

-- ============ SERVIÇOS ============
local Players = game:GetService("Players")
local Lighting = game:GetService("Lighting")
local RunService = game:GetService("RunService")
local Workspace = game:GetService("Workspace")
local UIS = game:GetService("UserInputService")
local TweenService = game:GetService("TweenService")
local StarterGui = game:GetService("StarterGui")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local Player = Players.LocalPlayer
local Terrain = Workspace:FindFirstChildOfClass("Terrain")

-- ============ ESTADO GLOBAL ============
local ballTextureId = ""
local ballMeshId = ""
local ballFireEnabled = false
local ballRGBEnabled = false
local rgbConnection = nil
local savedBallVisuals = setmetatable({}, {__mode = "k"})
local savedGrassParts = setmetatable({}, {__mode = "k"})
local originalSkies = {}
local originalTerrainGrass = nil
local floatingFollowButton = nil
local followToggleButton = nil
local followBindButton = nil
local CurrentBallColor = nil -- cor atual da bola (pra aplicar em novas bolas)

-- Reach
local ReachEnabled = false
local ReachDistance = 10
local ReachSphereEnabled = false
local reachSphere = nil
local reachBalls = {}
local reachLastRefresh = 0
local ReachScanCooldown = 1.5
local ReachBallNames = {"TPS","ESA","MRS","PRS","MPS","SSS","AIFA","RBZ","RSF","VEF","SAML"}
local ReachBallSet = {}
for _, n in ipairs(ReachBallNames) do ReachBallSet[n] = true end

-- ESP Ball
local ESPEnabled = false
local ESPNumberEnabled = true
local ESPHighlights = {}
local ESPBillboards = {}
local ESPConnection = nil
local ESPRenderConn = nil
local ESPTextSize = 18
local ESPColor = Color3.fromRGB(0, 255, 255)

-- Auto Catch
local AutoCatchEnabled = false
local AutoCatchRange = 8
local AutoCatchDelay = 1
local AutoCatchLast = 0
local CatchRemote = nil
pcall(function() CatchRemote = ReplicatedStorage:FindFirstChild("CatchBall", true) end)

-- Seguir Bola
local AutoFollowBallEnabled = false
local AutoFollowConnection = nil
local CurrentFollowBall = nil
local FollowScanTimer = 0
local FollowStopDistance = 0.20
local ManualSteerStrength = 1.25
local PlayerControls = nil
local FollowBallBind = Enum.KeyCode.Q

pcall(function()
    local PlayerModule = require(
        Player:WaitForChild("PlayerScripts"):WaitForChild("PlayerModule")
    )
    PlayerControls = PlayerModule:GetControls()
end)

for _, v in ipairs(Lighting:GetChildren()) do
    if v:IsA("Sky") then table.insert(originalSkies, v:Clone()) end
end

if Terrain then
    pcall(function() originalTerrainGrass = Terrain:GetMaterialColor(Enum.Material.Grass) end)
end

-- ============ AUXILIARES ============
local function IsCharacterPart(obj)
    local current = obj
    while current and current ~= Workspace do
        if current:IsA("Model") and current:FindFirstChildOfClass("Humanoid") then return true end
        current = current.Parent
    end
    return false
end

local function IsBall(part)
    if not part or not part:IsA("BasePart") then return false end
    if IsCharacterPart(part) then return false end
    
    local n = string.lower(part.Name)
    -- Nomes exatos que são bola
    if n == "tps" or n == "ball" or n == "bola" then return true end
    if n:find("soccerball") or n:find("football") or n:find("matchball") then return true end
    
    -- Exclui coisas que NÃO são bola
    if n:find("stadium") or n:find("map") or n:find("goal") or n:find("net") then return false end
    if n:find("grass") or n:find("field") or n:find("post") then return false end
    if n:find("head") or n:find("torso") or n:find("arm") or n:find("leg") then return false end
    
    -- Tamanho típico de bola
    local biggest = math.max(part.Size.X, part.Size.Y, part.Size.Z)
    local smallest = math.min(part.Size.X, part.Size.Y, part.Size.Z)
    if biggest < 0.5 or biggest > 8 then return false end
    
    -- Part redonda + não ancorada
    if part:IsA("Part") and part.Shape == Enum.PartType.Ball and not part.Anchored then return true end
    
    -- MeshPart redonda
    if part:IsA("MeshPart") and not part.Anchored and smallest / biggest >= 0.80 then return true end
    
    return false
end

local function GetBalls()
    local list = {}
    for _, v in ipairs(Workspace:GetDescendants()) do
        if v:IsA("BasePart") and IsBall(v) then table.insert(list, v) end
    end
    return list
end

local function FormatID(id)
    if not id or id == "" then return "" end
    local clean = string.match(id, "%d+")
    return clean and ("rbxassetid://" .. clean) or id
end

-- ============ SEGUIR BOLA ============
local function GetKeyName(key)
    local names = {
        LeftControl="CTRL ESQ.",RightControl="CTRL DIR.",
        LeftShift="SHIFT ESQ.",RightShift="SHIFT DIR.",
        LeftAlt="ALT ESQ.",RightAlt="ALT DIR.",
        Space="ESPAÇO",Return="ENTER",Escape="ESC",Backspace="BACKSPACE"
    }
    return names[key.Name] or key.Name
end

local function GetCharacterData()
    local char = Player.Character
    if not char then return nil,nil,nil end
    return char, char:FindFirstChildOfClass("Humanoid"), char:FindFirstChild("HumanoidRootPart")
end

local function IsValidTPSBall(part)
    if not part or not part.Parent or not part:IsA("BasePart") then return false end
    if string.lower(part.Name) ~= "tps" then return false end
    if IsCharacterPart(part) or part.Anchored then return false end
    local biggest = math.max(part.Size.X, part.Size.Y, part.Size.Z)
    local smallest = math.min(part.Size.X, part.Size.Y, part.Size.Z)
    if biggest < 0.5 or biggest > 6 then return false end
    if smallest / biggest < 0.60 then return false end
    return true
end

local function FindClosestBall()
    local _,_,root = GetCharacterData()
    if not root then return nil end
    local closest, closestDistance = nil, math.huge
    for _, part in ipairs(Workspace:GetDescendants()) do
        if IsValidTPSBall(part) then
            local offset = Vector3.new(part.Position.X - root.Position.X, 0, part.Position.Z - root.Position.Z)
            if offset.Magnitude < closestDistance then closestDistance = offset.Magnitude closest = part end
        end
    end
    if closest then return closest end
    for _, part in ipairs(Workspace:GetDescendants()) do
        if part:IsA("BasePart") and IsBall(part) then
            local offset = Vector3.new(part.Position.X - root.Position.X, 0, part.Position.Z - root.Position.Z)
            if offset.Magnitude < closestDistance then closestDistance = offset.Magnitude closest = part end
        end
    end
    return closest
end

local function GetManualDirection()
    local cam = Workspace.CurrentCamera
    if not cam then return Vector3.zero end
    local forward = Vector3.new(cam.CFrame.LookVector.X, 0, cam.CFrame.LookVector.Z)
    local right = Vector3.new(cam.CFrame.RightVector.X, 0, cam.CFrame.RightVector.Z)
    if forward.Magnitude > 0 then forward = forward.Unit end
    if right.Magnitude > 0 then right = right.Unit end
    if PlayerControls then
        local ok, move = pcall(function() return PlayerControls:GetMoveVector() end)
        if ok and move then
            local dir = right * move.X + forward * -move.Z
            if dir.Magnitude > 1 then dir = dir.Unit end
            if dir.Magnitude > 0.01 then return dir end
        end
    end
    local dir = Vector3.zero
    if UIS:IsKeyDown(Enum.KeyCode.W) then dir += forward end
    if UIS:IsKeyDown(Enum.KeyCode.S) then dir -= forward end
    if UIS:IsKeyDown(Enum.KeyCode.D) then dir += right end
    if UIS:IsKeyDown(Enum.KeyCode.A) then dir -= right end
    if dir.Magnitude > 1 then dir = dir.Unit end
    return dir
end

local function UpdateFollowButtons()
    if followToggleButton then followToggleButton:Set("Seguir Bola", AutoFollowBallEnabled) end
    if followBindButton then followBindButton:SetTitle("Bind ligar/desligar: " .. GetKeyName(FollowBallBind)) end
    if floatingFollowButton then
        if AutoFollowBallEnabled then
            floatingFollowButton.Text = "⚽ FOLLOW: ON"
            floatingFollowButton.BackgroundColor3 = Color3.fromRGB(20, 20, 20)
        else
            floatingFollowButton.Text = "⚽ FOLLOW: OFF"
            floatingFollowButton.BackgroundColor3 = Color3.fromRGB(0, 0, 0)
        end
    end
end

local function StopAutoFollowBall()
    AutoFollowBallEnabled = false
    CurrentFollowBall = nil
    FollowScanTimer = 0
    if AutoFollowConnection then AutoFollowConnection:Disconnect() AutoFollowConnection = nil end
    local _, hum = GetCharacterData()
    if hum then hum.AutoRotate = true hum:Move(Vector3.zero, false) end
    UpdateFollowButtons()
end

local function StartAutoFollowBall()
    if AutoFollowBallEnabled then return end
    AutoFollowBallEnabled = true
    CurrentFollowBall = nil
    FollowScanTimer = 1
    if AutoFollowConnection then AutoFollowConnection:Disconnect() end
    UpdateFollowButtons()
    AutoFollowConnection = RunService.RenderStepped:Connect(function(dt)
        if not AutoFollowBallEnabled then return end
        local _, hum, root = GetCharacterData()
        if not hum or not root or hum.Health <= 0 then return end
        hum.AutoRotate = true
        FollowScanTimer += dt
        local currentInvalid = not CurrentFollowBall or not CurrentFollowBall.Parent
            or (string.lower(CurrentFollowBall.Name) == "tps" and not IsValidTPSBall(CurrentFollowBall))
        local currentTooFar = false
        if CurrentFollowBall and CurrentFollowBall.Parent then
            local off = Vector3.new(CurrentFollowBall.Position.X - root.Position.X, 0, CurrentFollowBall.Position.Z - root.Position.Z)
            currentTooFar = off.Magnitude > 250
        end
        if currentInvalid or currentTooFar then
            FollowScanTimer = 0
            CurrentFollowBall = FindClosestBall()
        elseif FollowScanTimer >= 0.25 then
            FollowScanTimer = 0
        end
        local ball = CurrentFollowBall
        if not ball or not ball.Parent then return end
        local toBall = Vector3.new(ball.Position.X - root.Position.X, 0, ball.Position.Z - root.Position.Z)
        local distance = toBall.Magnitude
        local manual = GetManualDirection()
        if distance > FollowStopDistance then
            local follow = toBall.Unit
            local final = follow
            if manual.Magnitude > 0.01 then
                local inputAmount = math.clamp(manual.Magnitude, 0, 1)
                final = follow * (1 - inputAmount * 0.45) + manual * ManualSteerStrength
                if final.Magnitude > 0 then final = final.Unit end
            end
            hum:Move(final, false)
        elseif manual.Magnitude > 0.01 then
            hum:Move(manual, false)
        end
    end)
end

local function ToggleAutoFollowBall()
    if AutoFollowBallEnabled then StopAutoFollowBall() else StartAutoFollowBall() end
end

-- ============ REACH ============
local function RefreshReachBalls()
    if tick() - reachLastRefresh < ReachScanCooldown then return end
    reachLastRefresh = tick()
    table.clear(reachBalls)
    for _, v in ipairs(Workspace:GetDescendants()) do
        if v:IsA("BasePart") and ReachBallSet[v.Name] then
            reachBalls[#reachBalls+1] = v
        end
    end
end

local function GetValidBodyParts(char)
    local parts = {}
    for _, v in ipairs(char:GetChildren()) do
        if v:IsA("BasePart") and v.Name ~= "HumanoidRootPart" then
            parts[#parts+1] = v
        end
    end
    return parts
end

local function UpdateReachSphere()
    if not ReachSphereEnabled then
        if reachSphere then reachSphere:Destroy() reachSphere = nil end
        return
    end
    if not reachSphere then
        reachSphere = Instance.new("Part")
        reachSphere.Name = "Hub28ReachSphere"
        reachSphere.Shape = Enum.PartType.Ball
        reachSphere.Anchored = true
        reachSphere.CanCollide = false
        reachSphere.Transparency = 0.85
        reachSphere.Material = Enum.Material.ForceField
        reachSphere.Color = Color3.fromRGB(0, 0, 0)
        reachSphere.Parent = Workspace
        RunService.RenderStepped:Connect(function()
            local hrp = Player.Character and Player.Character:FindFirstChild("HumanoidRootPart")
            if hrp and reachSphere then reachSphere.Position = hrp.Position end
        end)
    end
    reachSphere.Size = Vector3.new(ReachDistance*2, ReachDistance*2, ReachDistance*2)
end

RunService.RenderStepped:Connect(function()
    if not ReachEnabled then return end
    local char = Player.Character
    if not char then return end
    RefreshReachBalls()
    for _, part in ipairs(GetValidBodyParts(char)) do
        for _, ball in ipairs(reachBalls) do
            if ball and ball.Parent then
                if (ball.Position - part.Position).Magnitude <= ReachDistance then
                    pcall(function()
                        firetouchinterest(ball, part, 0)
                        firetouchinterest(ball, part, 1)
                    end)
                end
            end
        end
    end
end)

-- ============ AUTO CATCH ============
local function TryCatch(ball)
    if not ball or not ball.Parent then return end
    if CatchRemote then
        pcall(function()
            if CatchRemote:IsA("RemoteEvent") then
                CatchRemote:FireServer(ball)
            elseif CatchRemote:IsA("RemoteFunction") then
                CatchRemote:InvokeServer(ball)
            end
        end)
    end
    AutoCatchLast = tick()
end

RunService.PreRender:Connect(function()
    if not AutoCatchEnabled then return end
    if tick() - AutoCatchLast < AutoCatchDelay then return end
    local char = Player.Character
    if not char then return end
    local hrp = char:FindFirstChild("HumanoidRootPart")
    if not hrp then return end
    local ball = FindClosestBall()
    if ball and (ball.Position - hrp.Position).Magnitude <= AutoCatchRange then
        TryCatch(ball)
    end
end)

-- ============ ESP BALL (SÓ BOLA, NÚMERO FIXO) ============
local function CreateESPForBall(ball)
    if ESPHighlights[ball] then return end
    if not ball or not ball.Parent then return end
    if not IsBall(ball) then return end -- SÓ BOLA
    
    -- Highlight
    local highlight = Instance.new("Highlight")
    highlight.Name = "Hub28ESPHighlight"
    highlight.Adornee = ball
    highlight.FillColor = ESPColor
    highlight.FillTransparency = 0.5
    highlight.OutlineColor = ESPColor
    highlight.OutlineTransparency = 0
    highlight.Parent = Workspace.CurrentCamera
    ESPHighlights[ball] = highlight
    
    -- Billboard com número
    local billboard = Instance.new("BillboardGui")
    billboard.Name = "Hub28ESPText"
    billboard.Adornee = ball
    billboard.Size = UDim2.fromOffset(100, 40)
    billboard.StudsOffset = Vector3.new(0, 3, 0)
    billboard.AlwaysOnTop = true
    billboard.Parent = ball
    
    local label = Instance.new("TextLabel")
    label.Size = UDim2.fromScale(1, 1)
    label.BackgroundTransparency = 1
    label.Text = "0m"
    label.TextColor3 = ESPColor
    label.TextStrokeTransparency = 0
    label.TextStrokeColor3 = Color3.fromRGB(0, 0, 0)
    label.Font = Enum.Font.GothamBold
    label.TextSize = ESPTextSize
    label.TextScaled = false
    label.Visible = ESPNumberEnabled
    label.Parent = billboard
    
    ESPBillboards[ball] = {billboard = billboard, label = label}
end

local function RemoveESPFromBall(ball)
    if ESPHighlights[ball] then
        pcall(function() ESPHighlights[ball]:Destroy() end)
        ESPHighlights[ball] = nil
    end
    if ESPBillboards[ball] then
        pcall(function() ESPBillboards[ball].billboard:Destroy() end)
        ESPBillboards[ball] = nil
    end
end

local function ClearAllESP()
    for ball, _ in pairs(ESPHighlights) do RemoveESPFromBall(ball) end
    ESPHighlights = {}
    ESPBillboards = {}
end

local function StartESP()
    if ESPEnabled then return end
    ESPEnabled = true
    for _, ball in ipairs(GetBalls()) do CreateESPForBall(ball) end
    ESPRenderConn = RunService.RenderStepped:Connect(function()
        if not ESPEnabled then return end
        local char = Player.Character
        if not char then return end
        local root = char:FindFirstChild("HumanoidRootPart")
        if not root then return end
        for ball, data in pairs(ESPBillboards) do
            if ball and ball.Parent and data.label then
                local dist = (ball.Position - root.Position).Magnitude
                data.label.Text = string.format("%dm", math.floor(dist))
                data.label.TextSize = ESPTextSize
                data.label.Visible = ESPNumberEnabled
            end
        end
    end)
    ESPConnection = Workspace.DescendantAdded:Connect(function(obj)
        if not ESPEnabled then return end
        task.wait(0.2)
        if obj:IsA("BasePart") and IsBall(obj) then
            CreateESPForBall(obj)
        end
    end)
end

local function StopESP()
    ESPEnabled = false
    if ESPConnection then ESPConnection:Disconnect() ESPConnection = nil end
    if ESPRenderConn then ESPRenderConn:Disconnect() ESPRenderConn = nil end
    ClearAllESP()
end

-- ============ SKYBOXES ============
local SKYBOXES = {
    {Category="Realistas", Name="Cinematic", Bk="162001887", Dn="161998893", Ft="162001897", Lf="162001904", Rt="162001919", Up="162001926"},
    {Category="Realistas", Name="Classic", Bk="rbxasset://textures/sky/sky512_bk.tex", Dn="rbxasset://textures/sky/sky512_dn.tex", Ft="rbxasset://textures/sky/sky512_ft.tex", Lf="rbxasset://textures/sky/sky512_lf.tex", Rt="rbxasset://textures/sky/sky512_rt.tex", Up="rbxasset://textures/sky/sky512_up.tex"},
    {Category="Realistas", Name="Blue Sky", Bk="135483466", Dn="135483484", Ft="135483461", Lf="135483495", Rt="135483499", Up="135483475"},
    {Category="Pôr do Sol", Name="Sunset", Bk="323494035", Dn="323494368", Ft="323494130", Lf="323494252", Rt="323494067", Up="323493360"},
    {Category="Espaço", Name="Galaxy", Bk="159454299", Dn="159454296", Ft="159454293", Lf="159454286", Rt="159454300", Up="159454288"},
    {Category="Noite", Name="Red Night", Bk="401664839", Dn="401664862", Ft="401664960", Lf="401664881", Rt="401664901", Up="401664936"},
    {Category="Noite", Name="Star Night", Bk="2570432999", Dn="2570433005", Ft="2570432998", Lf="2570433000", Rt="2570432997", Up="2570432996"},
    {Category="Coloridos", Name="Vaporwave", Bk="8631780182", Dn="8631784904", Ft="8631769834", Lf="8631777199", Rt="8631735555", Up="8631782345"},
}

local function FixAsset(id)
    id = tostring(id)
    if string.find(id, "rbxasset://", 1, true) then return id end
    return "rbxassetid://" .. id
end

local function ApplySkybox(data)
    for _, v in ipairs(Lighting:GetChildren()) do
        if v:IsA("Sky") then v:Destroy() end
    end
    local s = Instance.new("Sky")
    s.Name = "Hub28Sky"
    s.SkyboxBk = FixAsset(data.Bk)
    s.SkyboxDn = FixAsset(data.Dn)
    s.SkyboxFt = FixAsset(data.Ft)
    s.SkyboxLf = FixAsset(data.Lf)
    s.SkyboxRt = FixAsset(data.Rt)
    s.SkyboxUp = FixAsset(data.Up)
    s.CelestialBodiesShown = true
    s.StarCount = 3000
    s.Parent = Lighting
end

local function RestoreSky()
    for _, v in ipairs(Lighting:GetChildren()) do
        if v:IsA("Sky") then v:Destroy() end
    end
    for _, sky in ipairs(originalSkies) do
        pcall(function() sky:Clone().Parent = Lighting end)
    end
end

-- ============ GRAMADO ============
local function IsGrassPart(part)
    if not part or not part:IsA("BasePart") or IsBall(part) or IsCharacterPart(part) then return false end
    if part.Size.X < 15 or part.Size.Z < 15 or not part.Anchored then return false end
    if part.Material == Enum.Material.Grass then return true end
    local n = string.lower(part.Name)
    for _, word in ipairs({"grass","grama","campo","field","pitch","turf","ground","lawn"}) do
        if string.find(n, word, 1, true) then return true end
    end
    return false
end

local function ApplyGrass(color)
    if Terrain then
        pcall(function() Terrain:SetMaterialColor(Enum.Material.Grass, color) end)
    end
    for _, v in ipairs(Workspace:GetDescendants()) do
        if IsGrassPart(v) then
            if savedGrassParts[v] == nil then savedGrassParts[v] = v.Color end
            pcall(function() v.Color = color end)
        end
    end
end

local function RestoreGrass()
    if Terrain and originalTerrainGrass then
        pcall(function() Terrain:SetMaterialColor(Enum.Material.Grass, originalTerrainGrass) end)
    end
    for part, color in pairs(savedGrassParts) do
        if part and part.Parent then pcall(function() part.Color = color end) end
    end
    for part in pairs(savedGrassParts) do savedGrassParts[part] = nil end
end

-- ============ BOLA - COR (CORRIGIDO) ============
local function SaveBallVisual(obj)
    if savedBallVisuals[obj] then return end
    if obj:IsA("BasePart") then
        savedBallVisuals[obj] = {T = "Part", Color = obj.Color}
    elseif obj:IsA("Decal") or obj:IsA("Texture") then
        savedBallVisuals[obj] = {T = "Texture", Color = obj.Color3, Transparency = obj.Transparency}
    elseif obj:IsA("SpecialMesh") then
        savedBallVisuals[obj] = {T = "Mesh", VertexColor = obj.VertexColor}
    end
end

local function ColorBallObject(obj, color)
    SaveBallVisual(obj)
    pcall(function()
        if obj:IsA("BasePart") then obj.Color = color
        elseif obj:IsA("Decal") or obj:IsA("Texture") then obj.Color3 = color
        elseif obj:IsA("SpecialMesh") then obj.VertexColor = Vector3.new(color.R, color.G, color.B) end
    end)
end

local function ApplyColorToBall(ball, color)
    if not ball or not ball.Parent or not ball:IsA("BasePart") then return end
    ColorBallObject(ball, color)
    for _, v in ipairs(ball:GetDescendants()) do
        if v:IsA("Decal") or v:IsA("Texture") or v:IsA("SpecialMesh") then ColorBallObject(v, color) end
    end
end

local function StopRGBBall()
    ballRGBEnabled = false
    if rgbConnection then rgbConnection:Disconnect() rgbConnection = nil end
end

local function StartRGBBall()
    if ballRGBEnabled then return end
    ballRGBEnabled = true
    CurrentBallColor = nil -- RGB não fixa cor
    local hue = 0
    rgbConnection = RunService.RenderStepped:Connect(function(dt)
        if not ballRGBEnabled then return end
        hue = (hue + dt * 0.35) % 1
        local color = Color3.fromHSV(hue, 1, 1)
        for _, ball in ipairs(GetBalls()) do ApplyColorToBall(ball, color) end
    end)
end

local function SetBallColor(color)
    StopRGBBall()
    CurrentBallColor = color -- SALVA a cor pra aplicar em novas bolas
    for _, ball in ipairs(GetBalls()) do ApplyColorToBall(ball, color) end
end

local function RestoreBallColor()
    StopRGBBall()
    CurrentBallColor = nil
    for obj, data in pairs(savedBallVisuals) do
        if obj and obj.Parent then
            pcall(function()
                if data.T == "Part" then obj.Color = data.Color
                elseif data.T == "Texture" then obj.Color3 = data.Color obj.Transparency = data.Transparency
                elseif data.T == "Mesh" then obj.VertexColor = data.VertexColor end
            end)
        end
    end
    for obj in pairs(savedBallVisuals) do savedBallVisuals[obj] = nil end
end

-- Aplica cor em novas bolas automaticamente
Workspace.DescendantAdded:Connect(function(obj)
    task.wait(0.3)
    if not obj or not obj.Parent then return end
    if obj:IsA("BasePart") and IsBall(obj) then
        if CurrentBallColor then
            ApplyColorToBall(obj, CurrentBallColor)
        end
        if ESPEnabled then
            CreateESPForBall(obj)
        end
        if ballFireEnabled then
            AddFire(obj)
        end
    end
end)

-- ============ BOLA - FOGO ============
local function AddFire(ball)
    if not ball or not ball:IsA("BasePart") or ball:FindFirstChild("Hub28Fire") then return end
    local fire = Instance.new("Fire")
    fire.Name = "Hub28Fire"
    fire.Color = Color3.fromRGB(255,80,0)
    fire.SecondaryColor = Color3.fromRGB(255,220,0)
    fire.Size = 5
    fire.Heat = 10
    fire.Parent = ball
end

local function ToggleFire()
    ballFireEnabled = not ballFireEnabled
    if ballFireEnabled then
        for _, v in ipairs(GetBalls()) do AddFire(v) end
    else
        for _, v in ipairs(Workspace:GetDescendants()) do
            if v.Name == "Hub28Fire" then pcall(function() v:Destroy() end) end
        end
    end
end

-- ============ CHAT ============
local function SendChat(message)
    pcall(function()
        local TextChatService = game:GetService("TextChatService")
        if TextChatService.ChatVersion == Enum.ChatVersion.TextChatService then
            TextChatService.ChatInputBarConfiguration.TargetTextChannel:SendAsync(message)
        else
            StarterGui:SetCore("ChatSendMessage", message)
        end
    end)
end

-- ============ JANELA ============
local Window = WindUI:CreateWindow({
    Title = "28 HUB",
    Icon = "wind",
    Author = "by 28",
    Theme = "Dark",
    Folder = "28Hub",
    Size = UDim2.fromOffset(580, 460),
    Transparent = true,
    Resizable = true,
    SideBarWidth = 200,
    HideSearchBar = true,
    ScrollBarEnabled = false,
})

-- ============ ABAS ============
local ReachTab = Window:Tab({ Title = "Reach", Icon = "crosshair" })
local ESPTab = Window:Tab({ Title = "ESP", Icon = "eye" })
local BallTab = Window:Tab({ Title = "Bola", Icon = "circle" })
local CharsTab = Window:Tab({ Title = "Chars", Icon = "users" })
local SkyTab = Window:Tab({ Title = "Céus", Icon = "cloud" })
local GrassTab = Window:Tab({ Title = "Grama", Icon = "leaf" })
local MiscTab = Window:Tab({ Title = "Outros", Icon = "settings" })

-- ============ ABA REACH ============
local ReachSection = ReachTab:Section({ Title = "Reach", Opened = true })
ReachSection:Toggle({
    Title = "Ativar Reach",
    Value = false,
    Callback = function(state) ReachEnabled = state end,
})
ReachSection:Slider({
    Title = "Distância do Reach",
    Step = 1,
    Value = { Min = 1, Max = 100, Default = 10 },
    Callback = function(value) ReachDistance = value UpdateReachSphere() end,
})
ReachSection:Toggle({
    Title = "Mostrar Esfera",
    Value = false,
    Callback = function(state) ReachSphereEnabled = state UpdateReachSphere() end,
})

-- ============ ABA ESP ============
local ESPSection = ESPTab:Section({ Title = "ESP Ball (só bola)", Opened = true })
ESPSection:Toggle({
    Title = "ESP Ball",
    Desc = "Highlight + número em cima da bola",
    Value = false,
    Callback = function(state) if state then StartESP() else StopESP() end end,
})
ESPSection:Toggle({
    Title = "Mostrar Número",
    Value = true,
    Callback = function(state) 
        ESPNumberEnabled = state
        for _, data in pairs(ESPBillboards) do
            if data.label then data.label.Visible = state end
        end
    end,
})

-- ============ ABA BOLA ============
local FollowSection = BallTab:Section({ Title = "Seguir Bola", Opened = true })
followToggleButton = FollowSection:Toggle({
    Title = "Seguir Bola",
    Value = false,
    Callback = function(state) 
        if state then StartAutoFollowBall() else StopAutoFollowBall() end 
    end,
})
followBindButton = FollowSection:Keybind({
    Title = "Bind ligar/desligar",
    Value = "Q",
    Callback = function(key) FollowBallBind = key UpdateFollowButtons() end,
})

local CatchSection = BallTab:Section({ Title = "Auto Catch", Opened = true })
CatchSection:Toggle({
    Title = "Auto Catch",
    Value = false,
    Callback = function(state) AutoCatchEnabled = state end,
})
CatchSection:Slider({
    Title = "Distância do Catch",
    Step = 1,
    Value = { Min = 3, Max = 30, Default = 8 },
    Callback = function(value) AutoCatchRange = value end,
})
CatchSection:Slider({
    Title = "Cooldown do Catch",
    Step = 0.1,
    Value = { Min = 0.2, Max = 3, Default = 1 },
    Callback = function(value) AutoCatchDelay = value end,
})

local FireSection = BallTab:Section({ Title = "Efeitos", Opened = true })
FireSection:Toggle({
    Title = "Fogo na Bola",
    Value = false, Callback = function() ToggleFire() end,
})
FireSection:Toggle({
    Title = "Bola RGB",
    Value = false,
    Callback = function(state) if state then StartRGBBall() else StopRGBBall() end end,
})

local ColorSection = BallTab:Section({ Title = "Cores", Opened = false })

-- ColorPicker pra escolher qualquer cor
ColorSection:Colorpicker({
    Title = "Cor Personalizada",
    Color = Color3.fromRGB(40, 130, 255),
    Callback = function(color)
        SetBallColor(color)
        WindUI:Notify({ Title = "28 HUB", Content = "Cor da bola aplicada!", Duration = 2 })
    end,
})

local ballColors = {
    {"Vermelha", Color3.fromRGB(255,35,35)}, {"Azul", Color3.fromRGB(25,90,255)},
    {"Roxa", Color3.fromRGB(160,40,255)}, {"Rosa", Color3.fromRGB(255,60,170)},
    {"Verde", Color3.fromRGB(25,255,90)}, {"Ciano", Color3.fromRGB(0,230,255)},
    {"Dourada", Color3.fromRGB(255,190,20)}, {"Branca", Color3.new(1,1,1)},
    {"Preta", Color3.fromRGB(10,10,10)},
}
for _, data in ipairs(ballColors) do
    ColorSection:Button({ Title = data[1], Callback = function() SetBallColor(data[2]) end })
end
ColorSection:Button({ Title = "↩️ Restaurar Bola Original", Callback = function() 
    RestoreBallColor()
    WindUI:Notify({ Title = "28 HUB", Content = "Bola restaurada!", Duration = 2 })
end })

local CustomSection = BallTab:Section({ Title = "Custom (TCS)", Opened = false })
CustomSection:Input({
    Title = "Texture ID",
    Placeholder = "rbxassetid://...",
    Callback = function(input) ballTextureId = FormatID(input) end,
})
CustomSection:Input({
    Title = "Mesh ID",
    Placeholder = "rbxassetid://...",
    Callback = function(input) ballMeshId = FormatID(input) end,
})
CustomSection:Button({
    Title = "Aplicar Texture/Mesh",
    Callback = function()
        for _, ball in ipairs(GetBalls()) do
            pcall(function()
                if ballTextureId ~= "" then
                    if ball:IsA("MeshPart") then ball.TextureID = ballTextureId end
                    local mesh = ball:FindFirstChildOfClass("SpecialMesh")
                    if mesh then mesh.TextureId = ballTextureId end
                    for _, c in ipairs(ball:GetChildren()) do
                        if c:IsA("Decal") or c:IsA("Texture") then c.Texture = ballTextureId end
                    end
                end
                if ballMeshId ~= "" then
                    if ball:IsA("MeshPart") then ball.MeshId = ballMeshId end
                    local mesh = ball:FindFirstChildOfClass("SpecialMesh")
                    if mesh then mesh.MeshType = Enum.MeshType.FileMesh mesh.MeshId = ballMeshId end
                end
            end)
        end
        WindUI:Notify({ Title = "28 HUB", Content = "Texture/Mesh aplicada!", Duration = 2 })
    end,
})

-- ============ ABA CHARS ============
local CHAR_LIST = {
    {name = "Feliipeef"}, {name = "pret_oncio"}, {name = "jessnaldo"},
    {name = "lucasbr8181"}, {name = "PositiveVapor"}, {name = "kvbberdad"},
    {name = "kvbber"}, {name = "ongoal"}, {name = "leolity"},
    {name = "pauloneto05"}, {name = "candyxzzz0"}, {name = "zvbFaeTVXTq"},
    {name = "defantastico"}, {name = "emaofj"}, {name = "5zB4y"},
    {name = "ByGui08"}, {name = "levi_furacao"}, {name = "o_lfk"},
    {name = "feliou23"}, {name = "3qu"}, {name = "thunder65q"},
    {name = "MiguelcalebeGamer202"}, {name = "legendinho"}, {name = "THIXGOOOOOO"},
    {name = "talenttt"}, {name = "vnpthu"}, {name = "oxlade"},
    {name = "Dismalbeni"}, {name = "megutrap"}, {name = "brvnofalcon"},
    {name = "Rhuanbla"}, {name = "SenAstrozx"}, {name = "I_Ruanblox"},
    {name = "Rvnezzy"}, {name = "heheboi202000"}, {name = "Nescauzin_skills"},
    {name = "lilililililili_305"}, {name = "heitor756666"}, {name = "nexzaard"},
    {name = "mitoashpikachu2"}, {name = "rosa_skillsz"}, {name = "zico_alt123"},
    {name = "b_2020f"}, {name = "ry_dinno"}, {name = "cachorrao_fla"},
    {name = "barard28"}, {name = "Miguelcalebegame202"}, {name = "yurinho_0011"},
    {name = "deyvztcs"}, {name = "euperdro14"}, {name = "Alex151kk"},
    {name = "BRENOTAKEDA2011", troll = true}, {name = "monoball_jhh", troll = true},
}

local CharsSection = CharsTab:Section({ Title = "Chars", Opened = true })
for _, char in ipairs(CHAR_LIST) do
    local prefix = char.troll and "⚠️ " or ""
    CharsSection:Button({
        Title = prefix .. char.name,
        Callback = function()
            SendChat(":char " .. char.name)
            WindUI:Notify({ Title = "28 HUB", Content = "Enviado: :char " .. char.name, Duration = 2 })
        end,
    })
end

-- ============ CÉUS ============
local SkySection = SkyTab:Section({ Title = "Skyboxes", Opened = true })
for _, cat in ipairs({"Realistas", "Pôr do Sol", "Espaço", "Noite", "Coloridos"}) do
    local list = {}
    for _, sky in ipairs(SKYBOXES) do
        if sky.Category == cat then table.insert(list, sky.Name) end
    end
    SkySection:Dropdown({
        Title = cat, Values = list,
        Callback = function(selected)
            for _, sky in ipairs(SKYBOXES) do
                if sky.Name == selected then ApplySkybox(sky) break end
            end
        end,
    })
end
SkyTab:Section({ Title = "Restaurar", Opened = true }):Button({
    Title = "Restaurar Céu Original",
    Callback = function() RestoreSky() end,
})

-- ============ GRAMA ============
local GrassSection = GrassTab:Section({ Title = "Cores do Gramado", Opened = true })

-- ColorPicker pra escolher qualquer cor de grama
GrassSection:Colorpicker({
    Title = "Cor Personalizada do Campo",
    Color = Color3.fromRGB(60, 145, 60),
    Callback = function(color)
        ApplyGrass(color)
        WindUI:Notify({ Title = "28 HUB", Content = "Cor do campo aplicada!", Duration = 2 })
    end,
})

local GRASS_COLORS = {
    {"Azul", Color3.fromRGB(20,90,255)}, {"Azul Gelo", Color3.fromRGB(70,190,255)},
    {"Roxo", Color3.fromRGB(120,40,200)}, {"Violeta", Color3.fromRGB(170,60,255)},
    {"Vermelho", Color3.fromRGB(210,35,35)}, {"Rosa", Color3.fromRGB(255,75,170)},
    {"Laranja", Color3.fromRGB(255,120,25)}, {"Dourado", Color3.fromRGB(220,175,35)},
    {"Branco", Color3.fromRGB(225,225,225)}, {"Preto", Color3.fromRGB(20,20,20)},
    {"Ciano", Color3.fromRGB(25,220,215)}, {"Lime", Color3.fromRGB(120,255,25)},
    {"Verde Neon", Color3.fromRGB(0,255,70)}, {"Rosa Pink", Color3.fromRGB(255,20,147)},
}

for _, data in ipairs(GRASS_COLORS) do
    GrassSection:Button({ Title = data[1], Callback = function() ApplyGrass(data[2]) end })
end
GrassTab:Section({ Title = "Restaurar", Opened = true }):Button({
    Title = "↩️ Restaurar Grama Original",
    Callback = function() 
        RestoreGrass()
        WindUI:Notify({ Title = "28 HUB", Content = "Grama restaurada!", Duration = 2 })
    end,
})

-- ============ OUTROS ============
local MiscSection = MiscTab:Section({ Title = "Sistema", Opened = true })
MiscSection:Button({
    Title = "Limpar Tudo e Fechar",
    Callback = function()
        StopAutoFollowBall()
        StopRGBBall()
        StopESP()
        RestoreBallColor()
        RestoreGrass()
        RestoreSky()
        ReachEnabled = false
        AutoCatchEnabled = false
        for _, v in ipairs(Workspace:GetDescendants()) do
            if v.Name == "Hub28Fire" or v.Name == "Hub28ReachSphere" then
                pcall(function() v:Destroy() end)
            end
        end
        if floatingFollowButton then floatingFollowButton:Destroy() end
        if reachSphere then reachSphere:Destroy() end
        Window:Destroy()
    end,
})

-- ============ BIND Q ============
UIS.InputBegan:Connect(function(input, processed)
    if input.UserInputType ~= Enum.UserInputType.Keyboard then return end
    if processed or UIS:GetFocusedTextBox() then return end
    if input.KeyCode == FollowBallBind then
        ToggleAutoFollowBall()
        UpdateFollowButtons()
    end
end)

-- ============ BOTÃO FLUTUANTE (IGUAL KN) ============
local ScreenGui = Instance.new("ScreenGui")
ScreenGui.Name = "Hub28Floating"
ScreenGui.ResetOnSpawn = false
ScreenGui.IgnoreGuiInset = true
ScreenGui.DisplayOrder = 9998
ScreenGui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling

pcall(function()
    if gethui then ScreenGui.Parent = gethui()
    else ScreenGui.Parent = game:GetService("CoreGui") end
end)

if not ScreenGui.Parent then
    ScreenGui.Parent = Player:WaitForChild("PlayerGui")
end

floatingFollowButton = Instance.new("TextButton")
floatingFollowButton.Name = "Hub28FollowBtn"
floatingFollowButton.Size = UDim2.new(0, 170, 0, 55)
floatingFollowButton.Position = UDim2.new(0.83, 0, 0.20, 0)
floatingFollowButton.BackgroundColor3 = Color3.fromRGB(0, 0, 0)
floatingFollowButton.BackgroundTransparency = 0.1
floatingFollowButton.Text = "⚽ FOLLOW: OFF"
floatingFollowButton.TextColor3 = Color3.fromRGB(255, 255, 255)
floatingFollowButton.Font = Enum.Font.GothamBlack
floatingFollowButton.TextSize = 14
floatingFollowButton.AutoButtonColor = false
floatingFollowButton.BorderSizePixel = 0
floatingFollowButton.Visible = true
floatingFollowButton.Parent = ScreenGui

local cornerF = Instance.new("UICorner")
cornerF.CornerRadius = UDim.new(0, 12)
cornerF.Parent = floatingFollowButton

local strokeF = Instance.new("UIStroke")
strokeF.Color = Color3.fromRGB(255, 255, 255)
strokeF.Thickness = 2
strokeF.Transparency = 0.2
strokeF.Parent = floatingFollowButton

local followDragging = false
local followDragStart, followStartPos, followDragInput, followMoved

floatingFollowButton.InputBegan:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
        followDragging = true
        followMoved = false
        followDragStart = input.Position
        followStartPos = floatingFollowButton.Position
        input.Changed:Connect(function()
            if input.UserInputState == Enum.UserInputState.End then followDragging = false end
        end)
    end
end)

floatingFollowButton.InputChanged:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch then
        followDragInput = input
    end
end)

UIS.InputChanged:Connect(function(input)
    if input == followDragInput and followDragging then
        local delta = input.Position - followDragStart
        if math.abs(delta.X) > 5 or math.abs(delta.Y) > 5 then
            followMoved = true
            floatingFollowButton.Position = UDim2.new(
                followStartPos.X.Scale, followStartPos.X.Offset + delta.X,
                followStartPos.Y.Scale, followStartPos.Y.Offset + delta.Y
            )
        end
    end
end)

floatingFollowButton.MouseButton1Click:Connect(function()
    if not followMoved then
        ToggleAutoFollowBall()
        UpdateFollowButtons()
    end
end)

-- ============ NOTIFICAÇÃO ============
WindUI:Notify({
    Title = "28 HUB",
    Content = "Carregado! Reach + ESP + Auto Catch + Seguir Bola ⚽",
    Duration = 3,
    Icon = "check",
})

print("28 HUB carregado!")