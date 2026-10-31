local Rayfield = loadstring(game:HttpGet("https://sirius.menu/gen2"))()
local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local UserInputService = game:GetService("UserInputService")
local Workspace = game:GetService("Workspace")
local Lighting = game:GetService("Lighting")
local CoreGui = game:GetService("CoreGui")
local TextChatService = game:GetService("TextChatService")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local TweenService = game:GetService("TweenService")

local LocalPlayer = Players.LocalPlayer
local Camera = Workspace.CurrentCamera
local Character = LocalPlayer.Character or LocalPlayer.CharacterAdded:Wait()
local Humanoid = Character:WaitForChild("Humanoid")
local RootPart = Character:WaitForChild("HumanoidRootPart")
local PlayerGui = LocalPlayer:WaitForChild("PlayerGui")

local LoadingGui = Instance.new("ScreenGui")
LoadingGui.Name = "KNLoading"
LoadingGui.ResetOnSpawn = false
LoadingGui.DisplayOrder = 999999
LoadingGui.IgnoreGuiInset = true
LoadingGui.Parent = CoreGui

local LoadingBg = Instance.new("Frame")
LoadingBg.Size = UDim2.new(1, 0, 1, 0)
LoadingBg.BackgroundColor3 = Color3.fromRGB(0, 0, 0)
LoadingBg.BorderSizePixel = 0
LoadingBg.Parent = LoadingGui

local LoadingTitle = Instance.new("TextLabel")
LoadingTitle.Size = UDim2.new(1, 0, 0, 80)
LoadingTitle.Position = UDim2.new(0, 0, 0.5, -80)
LoadingTitle.BackgroundTransparency = 1
LoadingTitle.Text = "KN HUB"
LoadingTitle.TextColor3 = Color3.fromRGB(255, 255, 255)
LoadingTitle.TextSize = 72
LoadingTitle.Font = Enum.Font.GothamBlack
LoadingTitle.Parent = LoadingBg

local LoadingSub = Instance.new("TextLabel")
LoadingSub.Size = UDim2.new(1, 0, 0, 30)
LoadingSub.Position = UDim2.new(0, 0, 0.5, 0)
LoadingSub.BackgroundTransparency = 1
LoadingSub.Text = "by KN"
LoadingSub.TextColor3 = Color3.fromRGB(150, 150, 150)
LoadingSub.TextSize = 20
LoadingSub.Font = Enum.Font.GothamBold
LoadingSub.Parent = LoadingBg

local LoadingBarBg = Instance.new("Frame")
LoadingBarBg.Size = UDim2.new(0, 300, 0, 6)
LoadingBarBg.Position = UDim2.new(0.5, -150, 0.5, 60)
LoadingBarBg.BackgroundColor3 = Color3.fromRGB(30, 30, 30)
LoadingBarBg.BorderSizePixel = 0
LoadingBarBg.Parent = LoadingBg
Instance.new("UICorner", LoadingBarBg).CornerRadius = UDim.new(1, 0)

local LoadingBar = Instance.new("Frame")
LoadingBar.Size = UDim2.new(0, 0, 1, 0)
LoadingBar.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
LoadingBar.BorderSizePixel = 0
LoadingBar.Parent = LoadingBarBg
Instance.new("UICorner", LoadingBar).CornerRadius = UDim.new(1, 0)

local LoadingPercent = Instance.new("TextLabel")
LoadingPercent.Size = UDim2.new(1, 0, 0, 20)
LoadingPercent.Position = UDim2.new(0, 0, 0.5, 80)
LoadingPercent.BackgroundTransparency = 1
LoadingPercent.Text = "0%"
LoadingPercent.TextColor3 = Color3.fromRGB(150, 150, 150)
LoadingPercent.TextSize = 14
LoadingPercent.Font = Enum.Font.Gotham
LoadingPercent.Parent = LoadingBg

local LoadingStatus = Instance.new("TextLabel")
LoadingStatus.Size = UDim2.new(1, 0, 0, 20)
LoadingStatus.Position = UDim2.new(0, 0, 0.5, 105)
LoadingStatus.BackgroundTransparency = 1
LoadingStatus.Text = "Carregando..."
LoadingStatus.TextColor3 = Color3.fromRGB(100, 100, 100)
LoadingStatus.TextSize = 12
LoadingStatus.Font = Enum.Font.Gotham
LoadingStatus.Parent = LoadingBg

local function SetProgress(percent, status)
    LoadingBar:TweenSize(UDim2.new(percent / 100, 0, 1, 0), Enum.EasingDirection.Out, Enum.EasingStyle.Quad, 0.3, true)
    LoadingPercent.Text = math.floor(percent) .. "%"
    if status then LoadingStatus.Text = status end
end

task.spawn(function()
    local steps = {
        {20, "Inicializando..."},
        {40, "Carregando modulos..."},
        {60, "Preparando interface..."},
        {80, "Aplicando tema preto..."},
        {100, "Pronto!"},
    }
    for _, step in ipairs(steps) do
        SetProgress(step[1], step[2])
        task.wait(0.5)
    end
    task.wait(0.5)
    LoadingBg:TweenSize(UDim2.new(1, 0, 0, 0), Enum.EasingDirection.In, Enum.EasingStyle.Quart, 0.4, true)
    task.wait(0.5)
    LoadingGui:Destroy()
end)

local Estado = {
    FollowBall = false,
    Reach = false,
    ReachDist = 10,
    ESPBall = false,
    ESPPlayer = false,
    AutoCatch = false,
    AutoCatchRange = 8,
    AutoCatchDelay = 1,
    AutoCatchLast = 0,
    CorBola = nil,
    Rainbow = false,
    RainbowConn = nil,
    CachedBall = nil,
    EspHighlights = {},
    Backups = {},
    OriginalColorsGrama = {},
    OriginalSky = nil,
    OriginalAtmos = nil,
    OriginalClouds = nil,
    OriginalPostEffects = {},
    CorGrama = nil,
}

local VERDE = Color3.fromRGB(50, 255, 130)

local function AtualizarChar(newChar)
    Character = newChar
    Humanoid = newChar:WaitForChild("Humanoid")
    RootPart = newChar:WaitForChild("HumanoidRootPart")
end
LocalPlayer.CharacterAdded:Connect(AtualizarChar)

local function EhBolaDeVerdade(obj)
    if not obj or not obj.Parent then return false end
    if obj:IsDescendantOf(Character) then return false end
    local nomeLower = obj.Name:lower()
    if nomeLower == "head" or nomeLower == "torso" then return false end
    if nomeLower:find("stadium") or nomeLower:find("map") or nomeLower:find("goal") or nomeLower:find("net") or nomeLower:find("grass") or nomeLower:find("field") then return false end
    local parentModel = obj:FindFirstAncestorOfClass("Model")
    if parentModel and parentModel:FindFirstChildOfClass("Humanoid") then return false end
    local n = obj.Name:lower()
    if n == "tps" or n == "ball" or n == "bola" or n:find("soccerball") or n:find("football") or n:find("sphere") then return true end
    local temMesh = obj:FindFirstChildOfClass("SpecialMesh") ~= nil
    if temMesh and not obj.Anchored then
        local size = obj.Size
        if size.X >= 0.5 and size.X <= 8 then
            return true
        end
    end
    return false
end

local function GetValidBall()
    if not RootPart or not RootPart.Parent then return nil end
    local bolaMaisProxima = nil
    local menorDistancia = math.huge
    for _, obj in ipairs(workspace:GetDescendants()) do
        if obj:IsA("BasePart") or obj:IsA("MeshPart") then
            if not obj:IsDescendantOf(Character) then
                local n = obj.Name:lower()
                if n == "tps" or n == "ball" or n == "bola" or n:find("soccerball") or n:find("football") then
                    local parentModel = obj:FindFirstAncestorOfClass("Model")
                    local isPersonagem = parentModel and parentModel:FindFirstChildOfClass("Humanoid")
                    if not isPersonagem then
                        local size = obj.Size
                        if size.X >= 0.5 and size.X <= 8 then
                            local distancia = (obj.Position - RootPart.Position).Magnitude
                            if distancia < menorDistancia then
                                menorDistancia = distancia
                                bolaMaisProxima = obj
                            end
                        end
                    end
                end
            end
        end
    end
    Estado.CachedBall = bolaMaisProxima
    return bolaMaisProxima
end

local function PegarTodasBolas()
    local bolas = {}
    for _, obj in ipairs(workspace:GetDescendants()) do
        if obj:IsA("BasePart") or obj:IsA("MeshPart") then
            local n = obj.Name:lower()
            if n == "tps" or n == "ball" or n == "bola" or n:find("soccerball") or n:find("football") then
                if EhBolaDeVerdade(obj) then
                    local size = obj.Size
                    if size.X >= 0.5 and size.X <= 8 then
                        table.insert(bolas, obj)
                    end
                end
            end
        end
    end
    return bolas
end

local function SalvarOriginal(part)
    if Estado.Backups[part] then return end
    local data = {
        Color = part.Color,
        Material = part.Material,
        TextureID = part:IsA("MeshPart") and part.TextureID or nil,
        Mesh = part:FindFirstChildWhichIsA("SpecialMesh"),
        MeshTexId = nil,
        Decals = {},
    }
    if data.Mesh then data.MeshTexId = data.Mesh.TextureId end
    for _, child in ipairs(part:GetChildren()) do
        if child:IsA("Texture") or child:IsA("Decal") then
            table.insert(data.Decals, {Obj = child, Trans = child.Transparency})
        end
    end
    Estado.Backups[part] = data
end

local function LimparTextura(part)
    pcall(function()
        if part:IsA("MeshPart") then part.TextureID = "" end
    end)
    pcall(function()
        local mesh = part:FindFirstChildWhichIsA("SpecialMesh")
        if mesh then mesh.TextureId = "" end
    end)
    for _, child in ipairs(part:GetChildren()) do
        pcall(function()
            if child:IsA("Texture") or child:IsA("Decal") then
                child.Transparency = 1
            end
        end)
    end
end

local function AplicarCorBola(cor, material)
    Estado.CorBola = cor
    Estado.Rainbow = false
    if Estado.RainbowConn then Estado.RainbowConn:Disconnect() Estado.RainbowConn = nil end
    for _, part in ipairs(PegarTodasBolas()) do
        SalvarOriginal(part)
        LimparTextura(part)
        part.Color = cor
        if material then part.Material = material end
    end
end

local function IniciarRainbow()
    Estado.Rainbow = true
    Estado.CorBola = "rainbow"
    if Estado.RainbowConn then Estado.RainbowConn:Disconnect() end
    local hue = 0
    Estado.RainbowConn = RunService.Heartbeat:Connect(function(dt)
        hue = (hue + dt * 0.5) % 1
        local c = Color3.fromHSV(hue, 0.85, 1)
        for _, part in ipairs(PegarTodasBolas()) do
            SalvarOriginal(part)
            LimparTextura(part)
            part.Color = c
        end
    end)
end

local function RestaurarBola()
    Estado.CorBola = nil
    Estado.Rainbow = false
    if Estado.RainbowConn then Estado.RainbowConn:Disconnect() Estado.RainbowConn = nil end
    for part, data in pairs(Estado.Backups) do
        if part and part.Parent then
            pcall(function()
                part.Color = data.Color
                part.Material = data.Material
                if data.TextureID and part:IsA("MeshPart") then
                    part.TextureID = data.TextureID
                end
                if data.MeshTexId and data.Mesh and data.Mesh.Parent then
                    data.Mesh.TextureId = data.MeshTexId
                end
                for _, d in ipairs(data.Decals) do
                    if d.Obj and d.Obj.Parent then
                        d.Obj.Transparency = d.Trans
                    end
                end
            end)
        end
    end
    Estado.Backups = {}
end

workspace.DescendantAdded:Connect(function(obj)
    task.wait(0.3)
    if not Estado.CorBola then return end
    if obj:IsA("BasePart") or obj:IsA("MeshPart") then
        if EhBolaDeVerdade(obj) then
            SalvarOriginal(obj)
            LimparTextura(obj)
            if Estado.CorBola ~= "rainbow" then
                obj.Color = Estado.CorBola
            end
        end
    end
end)

local function EhGrama(obj)
    if not obj:IsA("BasePart") then return false end
    if obj.Material == Enum.Material.Grass then return true end
    local n = string.lower(obj.Name)
    return string.find(n, "grass", 1, true) ~= nil
        or string.find(n, "grama", 1, true) ~= nil
        or string.find(n, "gramado", 1, true) ~= nil
        or string.find(n, "campo", 1, true) ~= nil
        or string.find(n, "field", 1, true) ~= nil
        or string.find(n, "pitch", 1, true) ~= nil
        or string.find(n, "turf", 1, true) ~= nil
end

local function AplicarCorGrama(cor)
    Estado.CorGrama = cor
    for _, obj in ipairs(Workspace:GetDescendants()) do
        if obj:IsA("BasePart") and EhGrama(obj) then
            local n = string.lower(obj.Name)
            if not string.find(n, "line") and not string.find(n, "linha") then
                if not Estado.OriginalColorsGrama[obj] then
                    Estado.OriginalColorsGrama[obj] = obj.Color
                end
                obj.Color = cor
            end
        end
    end
end

local function RestaurarGrama()
    for part, color in pairs(Estado.OriginalColorsGrama) do
        if part and part.Parent then
            part.Color = color
        end
    end
    Estado.OriginalColorsGrama = {}
    Estado.CorGrama = nil
end

local function ForceSky(assetId)
    for _, obj in pairs(Workspace:GetDescendants()) do
        if obj:IsA("BasePart") or obj:IsA("Model") then
            local n = string.lower(obj.Name)
            if string.find(n, "sky") or string.find(n, "dome") or string.find(n, "ceu") or string.find(n, "atmosphere") then
                if not string.find(n, "kn") then
                    pcall(function() obj:Destroy() end)
                end
            end
        end
    end

    for _, child in pairs(Lighting:GetChildren()) do
        if child:IsA("Sky") then
            if not Estado.OriginalSky then Estado.OriginalSky = child:Clone() end
            child:Destroy()
        elseif child:IsA("Atmosphere") then
            if not Estado.OriginalAtmos then Estado.OriginalAtmos = child:Clone() end
            child:Destroy()
        elseif child:IsA("Clouds") then
            if not Estado.OriginalClouds then Estado.OriginalClouds = child:Clone() end
            child:Destroy()
        elseif child:IsA("PostEffect") or child:IsA("ColorCorrectionEffect") then
            table.insert(Estado.OriginalPostEffects, child:Clone())
            child:Destroy()
        end
    end

    local loaded = false
    pcall(function()
        local objects = game:GetObjects("rbxassetid://" .. tostring(assetId))
        for _, v in pairs(objects) do
            if v:IsA("Sky") then
                v.Name = "KNSky"
                v.Parent = Lighting
                loaded = true
            end
        end
    end)

    if not loaded then
        local newSky = Instance.new("Sky")
        newSky.Name = "KNSky"
        local url = "rbxassetid://" .. tostring(assetId)
        newSky.SkyboxBk = url
        newSky.SkyboxDn = url
        newSky.SkyboxFt = url
        newSky.SkyboxLf = url
        newSky.SkyboxRt = url
        newSky.SkyboxUp = url
        newSky.Parent = Lighting
    end
end

local function RestaurarSky()
    for _, child in pairs(Lighting:GetChildren()) do
        if child:IsA("Sky") or child.Name == "KNSky" then
            child:Destroy()
        end
    end
    if Estado.OriginalSky then
        local clone = Estado.OriginalSky:Clone()
        clone.Parent = Lighting
        Estado.OriginalSky = nil
    end
    if Estado.OriginalAtmos then
        local clone = Estado.OriginalAtmos:Clone()
        clone.Parent = Lighting
        Estado.OriginalAtmos = nil
    end
    if Estado.OriginalClouds then
        local clone = Estado.OriginalClouds:Clone()
        clone.Parent = Lighting
        Estado.OriginalClouds = nil
    end
    for _, effect in ipairs(Estado.OriginalPostEffects) do
        if effect then
            effect:Clone().Parent = Lighting
        end
    end
    Estado.OriginalPostEffects = {}
end

local function LimparESP()
    for _, h in pairs(Estado.EspHighlights) do
        if h and h.Parent then h:Destroy() end
    end
    Estado.EspHighlights = {}
end

local function AtualizarESP()
    if not Estado.ESPBall and not Estado.ESPPlayer then
        LimparESP()
        return
    end

    local vistos = {}

    if Estado.ESPBall then
        for _, ball in ipairs(PegarTodasBolas()) do
            vistos[ball] = true
            if not Estado.EspHighlights[ball] or not Estado.EspHighlights[ball].Parent then
                local h = Instance.new("Highlight")
                h.Adornee = ball
                h.FillColor = Color3.fromRGB(0, 255, 255)
                h.FillTransparency = 0.5
                h.OutlineColor = Color3.fromRGB(0, 255, 255)
                h.OutlineTransparency = 0
                h.Parent = Camera
                Estado.EspHighlights[ball] = h
            end
        end
    end

    if Estado.ESPPlayer then
        for _, plr in ipairs(Players:GetPlayers()) do
            if plr ~= LocalPlayer and plr.Character then
                local char = plr.Character
                vistos[char] = true
                if not Estado.EspHighlights[char] or not Estado.EspHighlights[char].Parent then
                    local h = Instance.new("Highlight")
                    h.Adornee = char
                    h.FillColor = VERDE
                    h.FillTransparency = 0.6
                    h.OutlineColor = VERDE
                    h.OutlineTransparency = 0
                    h.Parent = Camera
                    Estado.EspHighlights[char] = h
                end
            end
        end
    end

    for obj, h in pairs(Estado.EspHighlights) do
        if not vistos[obj] then
            if h and h.Parent then h:Destroy() end
            Estado.EspHighlights[obj] = nil
        end
    end
end

local CatchRemote = nil
pcall(function() CatchRemote = ReplicatedStorage:FindFirstChild("CatchBall", true) end)

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
    Estado.AutoCatchLast = tick()
end

local function IsManualInputActive()
    return UserInputService:IsKeyDown(Enum.KeyCode.W)
        or UserInputService:IsKeyDown(Enum.KeyCode.A)
        or UserInputService:IsKeyDown(Enum.KeyCode.S)
        or UserInputService:IsKeyDown(Enum.KeyCode.D)
end

RunService.PreRender:Connect(function()
    if not RootPart or not RootPart.Parent or not Humanoid then return end
    local ball = GetValidBall()

    AtualizarESP()

    if Estado.FollowBall and not IsManualInputActive() and ball then
        local delta = ball.Position - RootPart.Position
        local dir = Vector3.new(delta.X, 0, delta.Z)
        if dir.Magnitude > 0.5 then
            Humanoid:Move(dir.Unit, false)
        end
    end

    if Estado.Reach and ball then
        local dist = (ball.Position - RootPart.Position).Magnitude
        if dist <= Estado.ReachDist then
            firetouchinterest(RootPart, ball, 0)
            firetouchinterest(RootPart, ball, 1)
            local lf = Character:FindFirstChild("Left Foot") or Character:FindFirstChild("Left Leg")
            local rf = Character:FindFirstChild("Right Foot") or Character:FindFirstChild("Right Leg")
            if lf then firetouchinterest(lf, ball, 0) firetouchinterest(lf, ball, 1) end
            if rf then firetouchinterest(rf, ball, 0) firetouchinterest(rf, ball, 1) end
        end
    end

    if Estado.AutoCatch and tick() - Estado.AutoCatchLast >= Estado.AutoCatchDelay then
        local hrp = Character and Character:FindFirstChild("HumanoidRootPart")
        if ball and hrp and (ball.Position - hrp.Position).Magnitude <= Estado.AutoCatchRange then
            TryCatch(ball)
        end
    end
end)

local FloatGui = Instance.new("ScreenGui")
FloatGui.Name = "KNFloatGui"
FloatGui.ResetOnSpawn = false
FloatGui.DisplayOrder = 9998
FloatGui.Parent = PlayerGui

local FloatFollowBtn = Instance.new("TextButton")
FloatFollowBtn.Name = "FloatFollow"
FloatFollowBtn.Size = UDim2.new(0, 170, 0, 55)
FloatFollowBtn.Position = UDim2.new(0.83, 0, 0.20, 0)
FloatFollowBtn.BackgroundColor3 = Color3.fromRGB(0, 0, 0)
FloatFollowBtn.BackgroundTransparency = 0.1
FloatFollowBtn.Text = "⚽ FOLLOW: OFF"
FloatFollowBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
FloatFollowBtn.Font = Enum.Font.GothamBlack
FloatFollowBtn.TextSize = 14
FloatFollowBtn.AutoButtonColor = false
FloatFollowBtn.BorderSizePixel = 0
FloatFollowBtn.Visible = true
FloatFollowBtn.Parent = FloatGui
Instance.new("UICorner", FloatFollowBtn).CornerRadius = UDim.new(0, 12)

local FloatStroke = Instance.new("UIStroke")
FloatStroke.Color = Color3.fromRGB(255, 255, 255)
FloatStroke.Thickness = 2
FloatStroke.Transparency = 0.2
FloatStroke.Parent = FloatFollowBtn

local followDragging = false
local followDragStart, followStartPos, followDragInput, followMoved

FloatFollowBtn.InputBegan:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
        followDragging = true
        followMoved = false
        followDragStart = input.Position
        followStartPos = FloatFollowBtn.Position
        input.Changed:Connect(function()
            if input.UserInputState == Enum.UserInputState.End then followDragging = false end
        end)
    end
end)
FloatFollowBtn.InputChanged:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch then
        followDragInput = input
    end
end)
UserInputService.InputChanged:Connect(function(input)
    if input == followDragInput and followDragging then
        local delta = input.Position - followDragStart
        if math.abs(delta.X) > 5 or math.abs(delta.Y) > 5 then
            followMoved = true
            FloatFollowBtn.Position = UDim2.new(followStartPos.X.Scale, followStartPos.X.Offset + delta.X, followStartPos.Y.Scale, followStartPos.Y.Offset + delta.Y)
        end
    end
end)

FloatFollowBtn.MouseButton1Click:Connect(function()
    if not followMoved then
        Estado.FollowBall = not Estado.FollowBall
        if Estado.FollowBall then
            FloatFollowBtn.Text = "⚽ FOLLOW: ON"
            FloatFollowBtn.BackgroundColor3 = Color3.fromRGB(20, 20, 20)
        else
            FloatFollowBtn.Text = "⚽ FOLLOW: OFF"
            FloatFollowBtn.BackgroundColor3 = Color3.fromRGB(0, 0, 0)
            if Humanoid then Humanoid:Move(Vector3.zero, false) end
        end
    end
end)

local window = Rayfield:CreateWindow({
    name = "KN HUB",
    subtitle = "by KN",
    sidebarLayout = true,
    theme = "dark",
    configuration = {
        autoSave = true,
        autoLoad = true,
        fileName = "KNHubConfig",
    },
})

local tabPrincipal = window:CreateTab({ name = "Principal", icon = "home" })

tabPrincipal:CreateSection("Follow Ball")
tabPrincipal:CreateToggle({
    name = "Seguir Bola (Empurrar)",
    flag = "FollowBall",
    currentValue = false,
    callback = function(value)
        Estado.FollowBall = value
        if not value and Humanoid then Humanoid:Move(Vector3.zero, false) end
        if FloatFollowBtn then
            if value then
                FloatFollowBtn.Text = "⚽ FOLLOW: ON"
                FloatFollowBtn.BackgroundColor3 = Color3.fromRGB(20, 20, 20)
            else
                FloatFollowBtn.Text = "⚽ FOLLOW: OFF"
                FloatFollowBtn.BackgroundColor3 = Color3.fromRGB(0, 0, 0)
            end
        end
    end,
})

tabPrincipal:CreateSection("Auto Catch")
tabPrincipal:CreateToggle({
    name = "Auto Catch",
    flag = "AutoCatch",
    currentValue = false,
    callback = function(value) Estado.AutoCatch = value end,
})
tabPrincipal:CreateSlider({
    name = "Distância do Catch",
    flag = "AutoCatchRange",
    range = {3, 30},
    increment = 1,
    suffix = " studs",
    currentValue = 8,
    callback = function(value) Estado.AutoCatchRange = value end,
})
tabPrincipal:CreateSlider({
    name = "Cooldown do Catch",
    flag = "AutoCatchDelay",
    range = {0.2, 3},
    increment = 0.1,
    suffix = "s",
    currentValue = 1,
    callback = function(value) Estado.AutoCatchDelay = value end,
})

local tabReach = window:CreateTab({ name = "Reach", icon = "ruler" })

tabReach:CreateSection("Reach")
tabReach:CreateToggle({
    name = "Ativar Reach",
    flag = "Reach",
    currentValue = false,
    callback = function(value) Estado.Reach = value end,
})
tabReach:CreateSlider({
    name = "Distância do Reach",
    flag = "ReachDist",
    range = {1, 50},
    increment = 1,
    suffix = " studs",
    currentValue = 10,
    callback = function(value) Estado.ReachDist = value end,
})

local tabVisual = window:CreateTab({ name = "Visual", icon = "eye" })

tabVisual:CreateSection("ESP")
tabVisual:CreateToggle({
    name = "ESP da Bola",
    flag = "ESPBall",
    currentValue = false,
    callback = function(value) Estado.ESPBall = value end,
})
tabVisual:CreateToggle({
    name = "ESP de Jogadores",
    flag = "ESPPlayer",
    currentValue = false,
    callback = function(value) Estado.ESPPlayer = value end,
})

local tabBola = window:CreateTab({ name = "Bola", icon = "circle" })

tabBola:CreateSection("Cor da Bola")
tabBola:CreateColorPicker({
    name = "Escolher Cor da Bola",
    flag = "CorBola",
    color = Color3.fromRGB(40, 130, 255),
    callback = function(color)
        AplicarCorBola(color, Enum.Material.Neon)
    end,
})

tabBola:CreateSection("Cores Rápidas")
local CORES_BALL = {
    {N = "Azul",      C = Color3.fromRGB(40, 130, 255)},
    {N = "Verde",     C = Color3.fromRGB(45, 225, 95)},
    {N = "Roxo",      C = Color3.fromRGB(155, 55, 255)},
    {N = "Amarelo",   C = Color3.fromRGB(255, 220, 30)},
    {N = "Branco",    C = Color3.fromRGB(255, 255, 255)},
    {N = "Vermelho",  C = Color3.fromRGB(255, 45, 45)},
    {N = "Rosa",      C = Color3.fromRGB(255, 85, 185)},
    {N = "Laranja",   C = Color3.fromRGB(255, 150, 30)},
    {N = "Ciano",     C = Color3.fromRGB(35, 220, 245)},
    {N = "Dourado",   C = Color3.fromRGB(255, 195, 50)},
    {N = "Lima",      C = Color3.fromRGB(140, 255, 50)},
}

for _, cor in ipairs(CORES_BALL) do
    tabBola:CreateButton({
        name = cor.N,
        callback = function()
            AplicarCorBola(cor.C, Enum.Material.Neon)
            Rayfield:Notify({Title = "Bola", Content = "Cor aplicada: " .. cor.N, Duration = 2})
        end,
    })
end

tabBola:CreateButton({
    name = "🌈 Arco-Íris",
    callback = function()
        IniciarRainbow()
        Rayfield:Notify({Title = "Bola", Content = "Arco-íris ativado!", Duration = 2})
    end,
})

tabBola:CreateButton({
    name = "↩ Restaurar Bola Original",
    callback = function()
        RestaurarBola()
        Rayfield:Notify({Title = "Bola", Content = "Bola restaurada!", Duration = 2})
    end,
})

local tabCampo = window:CreateTab({ name = "Campo", icon = "sprout" })

tabCampo:CreateSection("Cores da Grama")

tabCampo:CreateColorPicker({
    name = "Escolher Cor do Campo",
    flag = "CorGrama",
    color = Color3.fromRGB(60, 145, 60),
    callback = function(color)
        AplicarCorGrama(color)
    end,
})

tabCampo:CreateSection("Cores Rápidas do Scar")

local CORES_GRAMA = {
    {N = "Grama Cinza",           C = Color3.fromRGB(60, 60, 60)},
    {N = "Grama Roxa Escura",     C = Color3.fromRGB(50, 0, 80)},
    {N = "Grama Rosa",            C = Color3.fromRGB(255, 105, 180)},
    {N = "Grama Vermelho Escuro", C = Color3.fromRGB(130, 0, 0)},
    {N = "Grama Azul Escuro",     C = Color3.fromRGB(0, 10, 90)},
}

for _, cor in ipairs(CORES_GRAMA) do
    tabCampo:CreateButton({
        name = cor.N,
        callback = function()
            AplicarCorGrama(cor.C)
            Rayfield:Notify({Title = "Campo", Content = "Cor aplicada: " .. cor.N, Duration = 2})
        end,
    })
end

tabCampo:CreateButton({
    name = "↩ Restaurar Grama Original",
    callback = function()
        RestaurarGrama()
        Rayfield:Notify({Title = "Campo", Content = "Grama restaurada!", Duration = 2})
    end,
})

local tabSky = window:CreateTab({ name = "Sky", icon = "cloud" })

tabSky:CreateSection("Skies do Scar")

local SKIES = {
    {N = "Green Sky",     ID = "113859918879279"},
    {N = "Pink Sky",      ID = "96902346573845"},
    {N = "Minecraft Sky", ID = "96736589365838"},
}

for _, sky in ipairs(SKIES) do
    tabSky:CreateButton({
        name = sky.N,
        callback = function()
            ForceSky(sky.ID)
            Rayfield:Notify({Title = "Sky", Content = "Aplicado: " .. sky.N, Duration = 2})
        end,
    })
end

tabSky:CreateButton({
    name = "↩ Restaurar Sky Original",
    callback = function()
        RestaurarSky()
        Rayfield:Notify({Title = "Sky", Content = "Sky restaurado!", Duration = 2})
    end,
})

local tabChars = window:CreateTab({ name = "Chars", icon = "user" })

tabChars:CreateSection("Chars Disponíveis")

local Chars = {
    "Feliipeef", "pret_oncio", "jessnaldo", "lucasbr8181", "PositiveVapor",
    "kvbberdad", "kvbber", "ongoal", "leolity", "pauloneto05",
    "candyxzzz0", "BRENOTAKEDA2011", "monoball_jhh", "zvbFaeTVXTq", "defantastico",
    "emaofj", "5zB4y", "ByGui08", "levi_furacao", "o_lfk",
    "feliou23", "3qu", "thunder65q", "MiguelcalebeGamer202", "legendinho",
    "THIXGOOOOOO", "talenttt", "vnpthu", "oxlade", "Dismalbeni",
    "megutrap", "brvnofalcon", "Rhuanbla", "SenAstrozx", "I_Ruanblox",
    "Rvnezzy", "heheboi202000", "Nescauzin_skills", "lilililililili_305", "heitor756666",
    "nexzaard", "mitoashpikachu2", "rosa_skillsz", "zico_alt123", "b_2020f",
    "ry_dinno", "cachorao_fla", "barard28", "Miguelcalebegame202", "yurinho_0011",
    "deyvztcs", "eperdro14", "Alex151kk"
}

local function SendCharCommand(Name)
    local success = pcall(function()
        local Channel = TextChatService.TextChannels:FindFirstChild("RBXGeneral")
        if Channel then Channel:SendAsync(":char " .. Name) else error("Canal não encontrado") end
    end)
    if not success then
        pcall(function()
            ReplicatedStorage:WaitForChild("DefaultChatSystemChatEvents"):WaitForChild("SayMessageRequest"):FireServer(":char " .. Name, "All")
        end)
    end
end

for _, charName in ipairs(Chars) do
    tabChars:CreateButton({
        name = charName,
        callback = function()
            SendCharCommand(charName)
            Rayfield:Notify({Title = "Char", Content = "Aplicando: " .. charName, Duration = 2})
        end,
    })
end

local tabCreditos = window:CreateTab({ name = "Créditos", icon = "info" })

tabCreditos:CreateSection("KN HUB")
tabCreditos:CreateParagraph({ title = "Criador", content = "KN" })
tabCreditos:CreateParagraph({ title = "Ajudando", content = "Vazio" })

tabCreditos:CreateSection("Links")
tabCreditos:CreateButton({
    name = "Discord: discord.gg/nVp7PFWHR",
    callback = function()
        pcall(function() if setclipboard then setclipboard("https://discord.gg/nVp7PFWHR") end end)
        Rayfield:Notify({Title = "Copiado!", Content = "Discord copiado!", Duration = 2})
    end,
})

Rayfield:Notify({
    Title = "KN HUB",
    Content = "Carregado com sucesso! by KN",
    Duration = 5,
})

print("[KN HUB] Carregado - by KN")