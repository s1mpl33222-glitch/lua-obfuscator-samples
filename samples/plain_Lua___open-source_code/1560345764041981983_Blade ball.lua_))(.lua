--[[
    SCRIPT: Combat Suite v1.7 (Rayfield UI)
    UI: Rayfield
    FUNÇÕES: Aimbot + Hitbox + ESP + FOV + Save/Load
--]]

-- ============================================================
-- CARREGA RAYFIELD
-- ============================================================
local Rayfield = loadstring(game:HttpGet('https://sirius.menu/rayfield'))()

-- ============================================================
-- SERVIÇOS
-- ============================================================
local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local UserInputService = game:GetService("UserInputService")
local CoreGui = game:GetService("CoreGui")
local Workspace = game:GetService("Workspace")
local StarterGui = game:GetService("StarterGui")

local LocalPlayer = Players.LocalPlayer
local Camera = Workspace.CurrentCamera

-- ============================================================
-- PARENT ROBUSTO PARA UI
-- ============================================================
local function GetUIParent()
    if gethui then
        local ok, hui = pcall(gethui)
        if ok and hui then return hui end
    end
    return CoreGui
end

-- ============================================================
-- CONFIG (SALVAR/CARREGAR)
-- ============================================================
local CONFIG_FILE = "combat_suite_rayfield.json"

local DefaultSettings = {
    AimbotEnabled = false,
    FOV = 120,
    Smoothness = 0.15,
    TargetPart = "Head",
    TeamCheck = true,
    MaxDistance = 500,
    WallCheck = true,
    ShowFovCircle = true,
    ScreenMargin = 0,
    HitboxEnabled = false,
    HitboxSize = 5,
    ESPEnabled = false,
    ESPName = true,
    ESPHealth = true,
    ESPDistance = true,
    ESPHighlight = true,
}

local Settings = {}
for k, v in pairs(DefaultSettings) do Settings[k] = v end

local function Serialize(tbl)
    local parts = {}
    for k, v in pairs(tbl) do
        local val
        if type(v) == "string" then val = string.format("%q", v)
        elseif type(v) == "boolean" or type(v) == "number" then val = tostring(v)
        else val = "nil" end
        table.insert(parts, string.format("  [%q] = %s", k, val))
    end
    return "{\n" .. table.concat(parts, ",\n") .. "\n}"
end

local function Deserialize(str)
    local ok, result = pcall(function() return loadstring("return " .. str)() end)
    if ok and type(result) == "table" then return result end
    return nil
end

local function SaveConfig()
    if not writefile then return false end
    return pcall(function() writefile(CONFIG_FILE, Serialize(Settings)) end)
end

local function LoadConfig()
    if not readfile or not isfile then return false end
    if not isfile(CONFIG_FILE) then return false end
    local ok, data = pcall(function() return readfile(CONFIG_FILE) end)
    if not ok or not data then return false end
    local tbl = Deserialize(data)
    if not tbl then return false end
    for k, v in pairs(tbl) do
        if DefaultSettings[k] ~= nil then Settings[k] = v end
    end
    return true
end

local function ResetConfig()
    for k, v in pairs(DefaultSettings) do Settings[k] = v end
    if writefile and delfile then pcall(function() delfile(CONFIG_FILE) end) end
end

LoadConfig()

-- ============================================================
-- ESTADO GLOBAL
-- ============================================================
local CurrentTarget = nil
local AimbotBindName = "AimbotRenderStep"
local HitboxConnections = {}
local ESPObjects = {}
local FovCircle = nil
local FovGui = nil

-- ============================================================
-- UTILITÁRIOS
-- ============================================================
local function IsEnemy(player)
    if not Settings.TeamCheck then return true end
    if player.Team == LocalPlayer.Team then return false end
    return true
end

local function IsAlive(player)
    if not player or not player.Character then return false end
    local humanoid = player.Character:FindFirstChildOfClass("Humanoid")
    return humanoid and humanoid.Health > 0
end

local function GetDistance(p1, p2)
    return (p1 - p2).Magnitude
end

local function GetTargetPart(character, partName)
    if not character then return nil end
    if partName == "Closest" then
        local closestPart, closestDist = nil, math.huge
        local center = Camera.ViewportSize / 2
        for _, part in ipairs(character:GetChildren()) do
            if part:IsA("BasePart") and part.Name ~= "HumanoidRootPart" then
                local sp, onScreen = Camera:WorldToViewportPoint(part.Position)
                if onScreen then
                    local dist = (Vector2.new(sp.X, sp.Y) - center).Magnitude
                    if dist < closestDist then
                        closestDist = dist
                        closestPart = part
                    end
                end
            end
        end
        return closestPart
    end
    return character:FindFirstChild(partName)
end

local function HasClearView(targetPart)
    local myChar = LocalPlayer.Character
    if not myChar then return false end
    local targetCharacter = targetPart.Parent
    if not targetCharacter then return false end

    local cameraPos = Camera.CFrame.Position
    local targetPos = targetPart.Position
    local testPoints = {
        targetPos,
        cameraPos:Lerp(targetPos, 0.25),
        cameraPos:Lerp(targetPos, 0.5),
        cameraPos:Lerp(targetPos, 0.75),
    }
    for _, point in ipairs(testPoints) do
        local success, parts = pcall(function()
            return Camera:GetPartsObscuringTarget(
                { point },
                { myChar, targetCharacter, Camera }
            )
        end)
        if success and parts and #parts > 0 then return false end
    end
    return true
end

local function GetScreenPosition(targetPart)
    local sp, onScreen = Camera:WorldToViewportPoint(targetPart.Position)
    if not onScreen then return nil end
    local vp = Camera.ViewportSize
    local m = Settings.ScreenMargin
    if sp.Z <= 0 then return nil end
    if sp.X < m or sp.X > vp.X - m then return nil end
    if sp.Y < m or sp.Y > vp.Y - m then return nil end
    return Vector2.new(sp.X, sp.Y)
end

-- ============================================================
-- FOV CIRCLE
-- ============================================================
local function CreateFovCircle()
    if FovCircle then pcall(function() FovCircle:Destroy() end); FovCircle = nil end
    if FovGui then pcall(function() FovGui:Destroy() end); FovGui = nil end

    FovGui = Instance.new("ScreenGui")
    FovGui.Name = "FovGui_" .. tostring(math.random(1000, 9999))
    FovGui.ResetOnSpawn = false
    FovGui.IgnoreGuiInset = true
    FovGui.DisplayOrder = 999998
    FovGui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
    FovGui.Parent = GetUIParent()

    local circle = Instance.new("Frame")
    circle.Name = "FovCircle"
    circle.AnchorPoint = Vector2.new(0.5, 0.5)
    circle.Position = UDim2.new(0.5, 0, 0.5, 0)
    circle.Size = UDim2.new(0, Settings.FOV * 2, 0, Settings.FOV * 2)
    circle.BackgroundTransparency = 1
    circle.BorderSizePixel = 0
    circle.ZIndex = 100
    circle.Visible = Settings.ShowFovCircle
    circle.Parent = FovGui

    local corner = Instance.new("UICorner")
    corner.CornerRadius = UDim.new(1, 0)
    corner.Parent = circle

    local s1 = Instance.new("UIStroke")
    s1.Thickness = 4
    s1.Color = Color3.fromRGB(0, 0, 0)
    s1.Transparency = 0.6
    s1.Parent = circle

    local s2 = Instance.new("UIStroke")
    s2.Thickness = 2
    s2.Color = Color3.fromRGB(0, 200, 255)
    s2.Parent = circle

    FovCircle = circle
end

local function UpdateFovCircle()
    if not FovCircle then CreateFovCircle() end
    if FovCircle then
        FovCircle.Size = UDim2.new(0, Settings.FOV * 2, 0, Settings.FOV * 2)
        FovCircle.Visible = Settings.ShowFovCircle
    end
end

-- ============================================================
-- AIMBOT
-- ============================================================
local function GetClosestTarget()
    local closestTarget = nil
    local shortestDist = math.huge
    local center = Camera.ViewportSize / 2
    local myChar = LocalPlayer.Character
    if not myChar then return nil end
    local myRoot = myChar:FindFirstChild("HumanoidRootPart")
    if not myRoot then return nil end
    local myPos = myRoot.Position

    for _, player in ipairs(Players:GetPlayers()) do
        if player ~= LocalPlayer and IsAlive(player) and IsEnemy(player) then
            local part = GetTargetPart(player.Character, Settings.TargetPart)
            if part then
                local worldDist = (myPos - part.Position).Magnitude
                if worldDist <= Settings.MaxDistance then
                    local screenVec = GetScreenPosition(part)
                    if screenVec then
                        local d = (screenVec - center).Magnitude
                        if d <= Settings.FOV then
                            local clearView = true
                            if Settings.WallCheck then clearView = HasClearView(part) end
                            if clearView and d < shortestDist then
                                shortestDist = d
                                closestTarget = player
                            end
                        end
                    end
                end
            end
        end
    end
    return closestTarget
end

local function UpdateAimbot()
    if not Settings.AimbotEnabled then return end
    local target = GetClosestTarget()
    CurrentTarget = target
    if not target or not target.Character then return end

    local part = GetTargetPart(target.Character, Settings.TargetPart)
    if not part then return end

    local screenVec = GetScreenPosition(part)
    if not screenVec then return end

    local center = Camera.ViewportSize / 2
    if (screenVec - center).Magnitude > Settings.FOV then return end
    if Settings.WallCheck and not HasClearView(part) then return end

    local cf = CFrame.new(Camera.CFrame.Position, part.Position)
    local alpha = 1 - math.clamp(Settings.Smoothness, 0, 0.99)
    Camera.CFrame = Camera.CFrame:Lerp(cf, alpha)
end

local function ToggleAimbot(state)
    Settings.AimbotEnabled = state
    if state then
        RunService:UnbindFromRenderStep(AimbotBindName)
        RunService:BindToRenderStep(AimbotBindName, Enum.RenderPriority.Camera.Value - 1, UpdateAimbot)
    else
        RunService:UnbindFromRenderStep(AimbotBindName)
        CurrentTarget = nil
    end
    SaveConfig()
end

-- ============================================================
-- HITBOX
-- ============================================================
local function ApplyHitbox(player)
    if player == LocalPlayer then return end
    if not IsAlive(player) or not IsEnemy(player) then return end
    for _, part in ipairs(player.Character:GetChildren()) do
        if part:IsA("BasePart") then
            if not part:GetAttribute("OriginalSize") then
                part:SetAttribute("OriginalSize", part.Size)
            end
            local os = part:GetAttribute("OriginalSize")
            if os then
                part.Size = os + Vector3.new(Settings.HitboxSize, Settings.HitboxSize, Settings.HitboxSize)
            end
        end
    end
end

local function RestoreHitbox(player)
    if not player or not player.Character then return end
    for _, part in ipairs(player.Character:GetChildren()) do
        if part:IsA("BasePart") then
            local os = part:GetAttribute("OriginalSize")
            if os then
                part.Size = os
                part:SetAttribute("OriginalSize", nil)
            end
        end
    end
end

local function UpdateAllHitboxes()
    if not Settings.HitboxEnabled then return end
    for _, player in ipairs(Players:GetPlayers()) do
        if player ~= LocalPlayer and IsAlive(player) and IsEnemy(player) then
            ApplyHitbox(player)
        end
    end
end

local function ToggleHitbox(state)
    Settings.HitboxEnabled = state
    if state then
        UpdateAllHitboxes()
        if not HitboxConnections.loop then
            HitboxConnections.loop = RunService.Heartbeat:Connect(function()
                if Settings.HitboxEnabled then UpdateAllHitboxes() end
            end)
        end
    else
        for _, player in ipairs(Players:GetPlayers()) do RestoreHitbox(player) end
        if HitboxConnections.loop then
            HitboxConnections.loop:Disconnect()
            HitboxConnections.loop = nil
        end
    end
    SaveConfig()
end

-- ============================================================
-- ESP
-- ============================================================
local function DestroyESP(player)
    local esp = ESPObjects[player]
    if not esp then return end
    if esp.Highlight then esp.Highlight:Destroy() end
    if esp.Billboard then esp.Billboard:Destroy() end
    ESPObjects[player] = nil
end

local function CreateESP(player)
    if player == LocalPlayer then return end
    if not IsAlive(player) then return end
    DestroyESP(player)

    local char = player.Character
    local hum = char:FindFirstChildOfClass("Humanoid")
    local root = char:FindFirstChild("HumanoidRootPart")
    if not hum or not root then return end

    local color = IsEnemy(player) and Color3.fromRGB(255, 50, 50) or Color3.fromRGB(50, 255, 50)

    local highlight = nil
    if Settings.ESPHighlight then
        highlight = Instance.new("Highlight")
        highlight.Adornee = char
        highlight.FillColor = color
        highlight.OutlineColor = Color3.new(1, 1, 1)
        highlight.FillTransparency = 0.5
        highlight.OutlineTransparency = 0
        highlight.Parent = char
    end

    local bb = Instance.new("BillboardGui")
    bb.Adornee = root
    bb.Size = UDim2.new(0, 200, 0, 100)
    bb.StudsOffset = Vector3.new(0, 3, 0)
    bb.AlwaysOnTop = true
    bb.Parent = char

    local nameL = Instance.new("TextLabel")
    nameL.Size = UDim2.new(1, 0, 0.3, 0)
    nameL.BackgroundTransparency = 1
    nameL.Text = player.DisplayName or player.Name
    nameL.TextColor3 = color
    nameL.TextStrokeTransparency = 0
    nameL.TextSize = 14
    nameL.Font = Enum.Font.GothamBold
    nameL.Visible = Settings.ESPName
    nameL.Parent = bb

    local distL = Instance.new("TextLabel")
    distL.Size = UDim2.new(1, 0, 0.2, 0)
    distL.Position = UDim2.new(0, 0, 0.3, 0)
    distL.BackgroundTransparency = 1
    distL.Text = "0m"
    distL.TextColor3 = Color3.new(1, 1, 1)
    distL.TextStrokeTransparency = 0
    distL.TextSize = 12
    distL.Font = Enum.Font.Gotham
    distL.Visible = Settings.ESPDistance
    distL.Parent = bb

    local hpBg = Instance.new("Frame")
    hpBg.Size = UDim2.new(0.8, 0, 0.08, 0)
    hpBg.Position = UDim2.new(0.1, 0, 0.5, 0)
    hpBg.BackgroundColor3 = Color3.fromRGB(50, 50, 50)
    hpBg.BorderSizePixel = 0
    hpBg.Visible = Settings.ESPHealth
    hpBg.Parent = bb

    local hpBar = Instance.new("Frame")
    hpBar.Size = UDim2.new(1, 0, 1, 0)
    hpBar.BackgroundColor3 = Color3.fromRGB(0, 255, 0)
    hpBar.BorderSizePixel = 0
    hpBar.Parent = hpBg

    ESPObjects[player] = {
        Highlight = highlight, Billboard = bb,
        NameLabel = nameL, DistanceLabel = distL,
        HealthBar = hpBar, HealthBg = hpBg,
    }
end

local function UpdateESP()
    for player, esp in pairs(ESPObjects) do
        if not player or not player.Parent or not player.Character then
            DestroyESP(player)
            continue
        end
        local char = player.Character
        local hum = char:FindFirstChildOfClass("Humanoid")
        local root = char:FindFirstChild("HumanoidRootPart")
        if not hum or not root or hum.Health <= 0 then
            DestroyESP(player)
            continue
        end
        local color = IsEnemy(player) and Color3.fromRGB(255, 50, 50) or Color3.fromRGB(50, 255, 50)
        if esp.Highlight then esp.Highlight.FillColor = color end
        if esp.NameLabel then
            esp.NameLabel.TextColor3 = color
            esp.NameLabel.Visible = Settings.ESPName
        end
        if esp.DistanceLabel then
            local myRoot = LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("HumanoidRootPart")
            if myRoot then
                esp.DistanceLabel.Text = string.format("%.0fm", GetDistance(myRoot.Position, root.Position))
            end
            esp.DistanceLabel.Visible = Settings.ESPDistance
        end
        if esp.HealthBg then esp.HealthBg.Visible = Settings.ESPHealth end
        if esp.HealthBar then
            local hp = hum.Health / math.max(hum.MaxHealth, 1)
            esp.HealthBar.Size = UDim2.new(hp, 0, 1, 0)
            if hp > 0.5 then esp.HealthBar.BackgroundColor3 = Color3.fromRGB(0, 255, 0)
            elseif hp > 0.25 then esp.HealthBar.BackgroundColor3 = Color3.fromRGB(255, 255, 0)
            else esp.HealthBar.BackgroundColor3 = Color3.fromRGB(255, 0, 0) end
        end
    end
end

local function ToggleESP(state)
    Settings.ESPEnabled = state
    if state then
        for _, player in ipairs(Players:GetPlayers()) do
            if player ~= LocalPlayer then CreateESP(player) end
        end
        if not ESPObjects.loop then
            local last = 0
            ESPObjects.loop = RunService.Heartbeat:Connect(function(dt)
                if not Settings.ESPEnabled then return end
                last = last + dt
                if last >= 0.1 then
                    last = 0
                    UpdateESP()
                end
            end)
        end
    else
        for player, _ in pairs(ESPObjects) do DestroyESP(player) end
        if ESPObjects.loop then
            ESPObjects.loop:Disconnect()
            ESPObjects.loop = nil
        end
    end
    SaveConfig()
end

-- ============================================================
-- CICLO DE VIDA
-- ============================================================
local function OnCharAdded(player)
    task.wait(0.5)
    if Settings.HitboxEnabled and IsEnemy(player) then ApplyHitbox(player) end
    if Settings.ESPEnabled then CreateESP(player) end
end

for _, p in ipairs(Players:GetPlayers()) do
    if p ~= LocalPlayer then
        p.CharacterAdded:Connect(function() OnCharAdded(p) end)
        p.CharacterRemoving:Connect(function()
            DestroyESP(p); RestoreHitbox(p)
        end)
    end
end

Players.PlayerAdded:Connect(function(player)
    player.CharacterAdded:Connect(function() OnCharAdded(player) end)
    player.CharacterRemoving:Connect(function()
        DestroyESP(player); RestoreHitbox(player)
    end)
end)

Players.PlayerRemoving:Connect(function(player)
    DestroyESP(player); RestoreHitbox(player)
end)

-- ============================================================
-- RAYFIELD UI
-- ============================================================
local Window = Rayfield:CreateWindow({
    Name = "Combat Suite | Blade Ball",
    LoadingTitle = "Carregando Combat Suite...",
    LoadingSubtitle = "por Rafild",
    ConfigurationSaving = {
        Enabled = true,
        FolderName = "CombatSuite",
        FileName = "Config",
    },
    KeySystem = false,
})

-- ============================================================
-- ABA AIMBOT
-- ============================================================
local AimbotTab = Window:CreateTab("Aimbot", 4483362458) -- ícone aim

local AimbotSection = AimbotTab:CreateSection("Configurações do Aimbot")

AimbotTab:CreateToggle({
    Name = "Ativar Aimbot",
    CurrentValue = Settings.AimbotEnabled,
    Flag = "AimbotEnabled",
    Callback = function(value)
        ToggleAimbot(value)
    end,
})

AimbotTab:CreateToggle({
    Name = "Mostrar FOV",
    CurrentValue = Settings.ShowFovCircle,
    Flag = "ShowFovCircle",
    Callback = function(value)
        Settings.ShowFovCircle = value
        UpdateFovCircle()
        SaveConfig()
    end,
})

AimbotTab:CreateToggle({
    Name = "Wall Check (não pega através de parede)",
    CurrentValue = Settings.WallCheck,
    Flag = "WallCheck",
    Callback = function(value)
        Settings.WallCheck = value
        SaveConfig()
    end,
})

AimbotTab:CreateToggle({
    Name = "Team Check",
    CurrentValue = Settings.TeamCheck,
    Flag = "TeamCheck",
    Callback = function(value)
        Settings.TeamCheck = value
        SaveConfig()
    end,
})

AimbotTab:CreateSlider({
    Name = "FOV (tamanho do círculo)",
    Range = {10, 500},
    Increment = 5,
    Suffix = "px",
    CurrentValue = Settings.FOV,
    Flag = "FOV",
    Callback = function(value)
        Settings.FOV = value
        UpdateFovCircle()
        SaveConfig()
    end,
})

AimbotTab:CreateSlider({
    Name = "Suavidade",
    Range = {1, 99},
    Increment = 1,
    Suffix = "%",
    CurrentValue = math.floor(Settings.Smoothness * 100),
    Flag = "Smoothness",
    Callback = function(value)
        Settings.Smoothness = value / 100
        SaveConfig()
    end,
})

AimbotTab:CreateSlider({
    Name = "Distância Máxima",
    Range = {50, 2000},
    Increment = 50,
    Suffix = "studs",
    CurrentValue = Settings.MaxDistance,
    Flag = "MaxDistance",
    Callback = function(value)
        Settings.MaxDistance = value
        SaveConfig()
    end,
})

AimbotTab:CreateSlider({
    Name = "Margem da Tela",
    Range = {0, 200},
    Increment = 10,
    Suffix = "px",
    CurrentValue = Settings.ScreenMargin,
    Flag = "ScreenMargin",
    Callback = function(value)
        Settings.ScreenMargin = value
        SaveConfig()
    end,
})

AimbotTab:CreateDropdown({
    Name = "Parte Alvo",
    Options = {"Head", "Torso", "Closest"},
    CurrentOption = {Settings.TargetPart},
    Flag = "TargetPart",
    Callback = function(option)
        Settings.TargetPart = option
        SaveConfig()
    end,
})

-- ============================================================
-- ABA HITBOX
-- ============================================================
local HitboxTab = Window:CreateTab("Hitbox", 4483362458)

HitboxTab:CreateSection("Configurações da Hitbox")

HitboxTab:CreateToggle({
    Name = "Ativar Hitbox Expander",
    CurrentValue = Settings.HitboxEnabled,
    Flag = "HitboxEnabled",
    Callback = function(value)
        ToggleHitbox(value)
    end,
})

HitboxTab:CreateSlider({
    Name = "Tamanho da Hitbox",
    Range = {1, 20},
    Increment = 1,
    Suffix = "studs",
    CurrentValue = Settings.HitboxSize,
    Flag = "HitboxSize",
    Callback = function(value)
        Settings.HitboxSize = value
        SaveConfig()
    end,
})

-- ============================================================
-- ABA ESP
-- ============================================================
local ESPTab = Window:CreateTab("ESP", 4483362458)

ESPTab:CreateSection("Configurações do ESP")

ESPTab:CreateToggle({
    Name = "Ativar ESP",
    CurrentValue = Settings.ESPEnabled,
    Flag = "ESPEnabled",
    Callback = function(value)
        ToggleESP(value)
    end,
})

ESPTab:CreateToggle({
    Name = "Nome",
    CurrentValue = Settings.ESPName,
    Flag = "ESPName",
    Callback = function(value)
        Settings.ESPName = value
        SaveConfig()
    end,
})

ESPTab:CreateToggle({
    Name = "Distância",
    CurrentValue = Settings.ESPDistance,
    Flag = "ESPDistance",
    Callback = function(value)
        Settings.ESPDistance = value
        SaveConfig()
    end,
})

ESPTab:CreateToggle({
    Name = "Barra de Vida",
    CurrentValue = Settings.ESPHealth,
    Flag = "ESPHealth",
    Callback = function(value)
        Settings.ESPHealth = value
        SaveConfig()
    end,
})

ESPTab:CreateToggle({
    Name = "Highlight",
    CurrentValue = Settings.ESPHighlight,
    Flag = "ESPHighlight",
    Callback = function(value)
        Settings.ESPHighlight = value
        if Settings.ESPEnabled then
            ToggleESP(false); ToggleESP(true)
        end
        SaveConfig()
    end,
})

-- ============================================================
-- ABA CONFIG
-- ============================================================
local ConfigTab = Window:CreateTab("Config", 4483362458)

ConfigTab:CreateSection("Gerenciar Configuração")

ConfigTab:CreateButton({
    Name = "💾 Salvar Configuração",
    Callback = function()
        if SaveConfig() then
            Rayfield:Notify({
                Title = "Combat Suite",
                Content = "✅ Configuração salva!",
                Duration = 3,
            })
        end
    end,
})

ConfigTab:CreateButton({
    Name = "📂 Carregar Configuração",
    Callback = function()
        LoadConfig()
        Rayfield:Notify({
            Title = "Combat Suite",
            Content = "📂 Config carregada! Reabra a UI para ver as mudanças.",
            Duration = 3,
        })
    end,
})

ConfigTab:CreateButton({
    Name = "🔄 Resetar Padrão",
    Callback = function()
        ResetConfig()
        Rayfield:Notify({
            Title = "Combat Suite",
            Content = "🔄 Config resetada!",
            Duration = 3,
        })
    end,
})

ConfigTab:CreateSection("Informações")
ConfigTab:CreateParagraph({
    Title = "Combat Suite v1.7",
    Content = "UI: Rayfield | Versão: 1.7\nRecursos: Aimbot + Hitbox + ESP\nSave/Load automático\nWall Check + FOV Circle",
})

-- ============================================================
-- INICIALIZAÇÃO
-- ============================================================
CreateFovCircle()
UpdateFovCircle()

if Settings.AimbotEnabled then ToggleAimbot(true) end
if Settings.HitboxEnabled then ToggleHitbox(true) end
if Settings.ESPEnabled then ToggleESP(true) end

Rayfield:Notify({
    Title = "Combat Suite",
    Content = "✅ Script carregado com sucesso!",
    Duration = 4,
})

print("✅ Combat Suite v1.7 (Rayfield) carregado!")
