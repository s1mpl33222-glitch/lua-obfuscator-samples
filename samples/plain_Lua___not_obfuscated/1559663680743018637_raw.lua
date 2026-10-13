return(function(5pQeX, ...)
local jrXtIV = {"RRuXW2";"71K";"9met";"weroKYX";"Bip2czLAeC9Wsyif";"wpGrn";"0455WDV6k";"gZXmfuEDjEZqHsFCv";"QL7IioquI";"OeXKSJzi9wfEvMg8";"jYFU97SmqndKUN";"YwM"}
local KzfnKlrc = function(...)
-- LUA HUB 🌙 - FLY NAVE + ANCORAR (COMPLETO)
-- ✅ Câmera 100% funcional (voa na direção que você mira)
-- ✅ Âncora para prender construções
-- ✅ Câmera volta ao normal quando desliga

local Players = game:GetService(loadstring(base64decode("UGxheWVycw=="))())
local RunService = game:GetService(loadstring(base64decode("UnVuU2VydmljZQ=="))())
local UserInputService = game:GetService(loadstring(base64decode("VXNlcklucHV0U2VydmljZQ=="))())
local Camera = workspace.CurrentCamera

local player = Players.LocalPlayer
local character = player.Character or player.CharacterAdded:Wait()
local humanoid = character:WaitForChild(loadstring(base64decode("SHVtYW5vaWQ="))())
local rootPart = character:WaitForChild(loadstring(base64decode("SHVtYW5vaWRSb290UGFydA=="))())

-- ESTADOS
local flyActive = false
local anchorActive = false
local thrustPressed = false
local currentVehicle = nil
local bodyVelocity = nil
local bodyGyro = nil
local renderConnection = nil
local anchoredParts = {}

-- CONFIGS
local FLY_SPEED = 80

-- ═══════════════════════════════════════════════
-- FUNÇÃO PARA OBTER O VEÍCULO/ASSENTO ATUAL
-- ═══════════════════════════════════════════════
local function getVehicle()
    local seat = humanoid.SeatPart
    if seat and seat:IsA(loadstring(base64decode("QmFzZVBhcnQ="))()) and seat:IsDescendantOf(workspace) then
        local parent = seat.Parent
        while parent and parent ~= workspace do
            if parent:IsA(loadstring(base64decode("TW9kZWw="))()) then
                return parent
            end
            parent = parent.Parent
        end
        return seat
    end
    return nil
end

-- ═══════════════════════════════════════════════
-- FUNÇÃO PARA OBTER A PARTE PRINCIPAL DO VEÍCULO
-- ═══════════════════════════════════════════════
local function getMainPart(vehicle)
    if not vehicle then return nil end
    if vehicle:IsA(loadstring(base64decode("TW9kZWw="))()) and vehicle.PrimaryPart then
        return vehicle.PrimaryPart
    elseif vehicle:IsA(loadstring(base64decode("TW9kZWw="))()) then
        return vehicle:FindFirstChildWhichIsA(loadstring(base64decode("QmFzZVBhcnQ="))())
    end
    return vehicle
end

-- ═══════════════════════════════════════════════
-- ANCORAR CONSTRUÇÃO INTEIRA (COM WELDS)
-- ═══════════════════════════════════════════════
local function anchorRecursive(part, visited)
    if not part or not part:IsA(loadstring(base64decode("QmFzZVBhcnQ="))()) then return end
    if visited[part] then return end
    visited[part] = true
    
    part.Anchored = true
    
    -- Procura por welds conectados
    for _, descendant in ipairs(workspace:GetDescendants()) do
        if descendant:IsA(loadstring(base64decode("QmFzZVBhcnQ="))()) and descendant ~= part then
            local weld = descendant:FindFirstChildWhichIsA(loadstring(base64decode("V2VsZENvbnN0cmFpbnQ="))()) or 
                        descendant:FindFirstChildWhichIsA(loadstring(base64decode("V2VsZA=="))())
            if weld and (weld.Part0 == part or weld.Part1 == part) then
                anchorRecursive(descendant, visited)
            end
        end
    end
end

local function anchorConstruction(part)
    if not part or anchoredParts[part] then return end
    
    local visited = {}
    anchorRecursive(part, visited)
    
    -- Marca todas as partes ancoradas
    for obj, _ in pairs(visited) do
        anchoredParts[obj] = true
    end
    
    anchorBtn.BackgroundColor3 = Color3.fromRGB(0, 200, 0)
    anchorBtn.Text = loadstring(base64decode("4pqTIEFuY29yYXIgW09OXQ=="))()
    print(loadstring(base64decode("4pyFIENvbnN0cnXDp8OjbyBhbmNvcmFkYSBjb20gc3VjZXNzbyE="))())
end

local function unanchorAll()
    for part, _ in pairs(anchoredParts) do
        if part and part:IsA(loadstring(base64decode("QmFzZVBhcnQ="))()) and part.Parent then
            part.Anchored = false
        end
    end
    anchoredParts = {}
    anchorBtn.BackgroundColor3 = Color3.fromRGB(120, 0, 255)
    anchorBtn.Text = loadstring(base64decode("4pqTIEFuY29yYXIgW09GRl0="))()
    print(loadstring(base64decode("4pyFIEFuY29yYWdlbSByZW1vdmlkYSE="))())
end

-- ═══════════════════════════════════════════════
-- CRIA FÍSICA DE VOO
-- ═══════════════════════════════════════════════
local function setupFlyPhysics(vehicle)
    if not vehicle then return end
    
    local mainPart = getMainPart(vehicle)
    if not mainPart then return end
    
    currentVehicle = mainPart
    currentVehicle.Anchored = false
    
    if bodyVelocity then bodyVelocity:Destroy() end
    bodyVelocity = Instance.new(loadstring(base64decode("Qm9keVZlbG9jaXR5"))())
    bodyVelocity.MaxForce = Vector3.new(1e6, 1e6, 1e6)
    bodyVelocity.Velocity = Vector3.zero
    bodyVelocity.Parent = currentVehicle
    
    if bodyGyro then bodyGyro:Destroy() end
    bodyGyro = Instance.new(loadstring(base64decode("Qm9keUd5cm8="))())
    bodyGyro.MaxTorque = Vector3.new(1e8, 1e8, 1e8)
    bodyGyro.P = 50000
    bodyGyro.CFrame = currentVehicle.CFrame
    bodyGyro.Parent = currentVehicle
end

-- ═══════════════════════════════════════════════
-- LIMPA FÍSICA
-- ═══════════════════════════════════════════════
local function clearFlyPhysics()
    if bodyVelocity then bodyVelocity:Destroy() bodyVelocity = nil end
    if bodyGyro then bodyGyro:Destroy() bodyGyro = nil end
    currentVehicle = nil
end

-- ═══════════════════════════════════════════════
-- RESTAURA CÂMERA NORMAL
-- ═══════════════════════════════════════════════
local function restoreCamera()
    local hum = character:FindFirstChild(loadstring(base64decode("SHVtYW5vaWQ="))())
    if hum then
        Camera.CameraSubject = hum
    end
    Camera.CameraType = Enum.CameraType.Custom
end

-- ═══════════════════════════════════════════════
-- LOOP PRINCIPAL (CÂMERA + MOVIMENTO)
-- ═══════════════════════════════════════════════
local function onRenderStep()
    if not flyActive then return end
    
    local vehicle = getVehicle()
    if not vehicle then
        flyActive = false
        flyBtn.Text = loadstring(base64decode("8J+agCBGbHkgTmF2ZSBbT0ZGXQ=="))()
        flyBtn.BackgroundColor3 = Color3.fromRGB(0, 120, 255)
        clearFlyPhysics()
        restoreCamera()
        return
    end
    
    local mainPart = getMainPart(vehicle)
    if mainPart and mainPart ~= currentVehicle then
        clearFlyPhysics()
        setupFlyPhysics(vehicle)
    end
    
    if not currentVehicle then return end
    
    -- Mantém personagem sentado
    humanoid.Sit = true
    
    -- 🔥 CÂMERA SEGUE A NAVE COM VOCÊ NO CONTROLE
    Camera.CameraSubject = currentVehicle
    Camera.CameraType = Enum.CameraType.Custom
    
    -- 🚀 MOVIMENTO NA DIREÇÃO DA CÂMERA
    if thrustPressed then
        local cameraDirection = Camera.CFrame.LookVector
        bodyVelocity.Velocity = cameraDirection * FLY_SPEED
        
        if cameraDirection.Magnitude > 0.1 then
            local targetCF = CFrame.lookAt(currentVehicle.Position, currentVehicle.Position + cameraDirection)
            bodyGyro.CFrame = targetCF
        end
    else
        bodyVelocity.Velocity = Vector3.zero
    end
end

-- ═══════════════════════════════════════════════
-- LIGA/DESLIGA FLY
-- ═══════════════════════════════════════════════
local function toggleFly()
    if flyActive then
        -- DESLIGA FLY
        flyActive = false
        if renderConnection then
            renderConnection:Disconnect()
            renderConnection = nil
        end
        clearFlyPhysics()
        restoreCamera() -- 🔥 VOLTA A CÂMERA NORMAL
        flyBtn.Text = loadstring(base64decode("8J+agCBGbHkgTmF2ZSBbT0ZGXQ=="))()
        flyBtn.BackgroundColor3 = Color3.fromRGB(0, 120, 255)
        print(loadstring(base64decode("4pyFIEZseSBkZXNhdGl2YWRvIC0gQ8OibWVyYSByZXN0YXVyYWRhIQ=="))())
    else
        -- LIGA FLY
        local vehicle = getVehicle()
        if not vehicle then
            print(loadstring(base64decode("4p2MIFZvY8OqIHByZWNpc2EgZXN0YXIgc2VudGFkbyBlbSB1bSB2ZcOtY3Vsby9uYXZlIQ=="))())
            return
        end
        
        -- Se âncora está ativa, ancora antes de voar
        if anchorActive then
            local mainPart = getMainPart(vehicle)
            if mainPart and not mainPart.Anchored then
                anchorConstruction(mainPart)
            end
        end
        
        flyActive = true
        setupFlyPhysics(vehicle)
        
        if renderConnection then
            renderConnection:Disconnect()
        end
        renderConnection = RunService.RenderStepped:Connect(onRenderStep)
        
        flyBtn.Text = loadstring(base64decode("8J+agCBGbHkgTmF2ZSBbT05d"))()
        flyBtn.BackgroundColor3 = Color3.fromRGB(0, 200, 0)
        print(loadstring(base64decode("4pyFIEZseSBhdGl2YWRvISBVc2Ug4pqhIG91IFQgcGFyYSB2b2FyIG5hIGRpcmXDp8OjbyBkYSBjw6JtZXJhIQ=="))())
    end
end

-- ═══════════════════════════════════════════════
-- LIGA/DESLIGA ANCORA
-- ═══════════════════════════════════════════════
local function toggleAnchor()
    if anchorActive then
        -- DESLIGA ANCORA
        anchorActive = false
        unanchorAll()
    else
        -- LIGA ANCORA
        local vehicle = getVehicle()
        if not vehicle then
            print(loadstring(base64decode("4p2MIFZvY8OqIHByZWNpc2EgZXN0YXIgZW0gdW0gdmXDrWN1bG8gcGFyYSBhbmNvcmFyIQ=="))())
            return
        end
        
        local mainPart = getMainPart(vehicle)
        if not mainPart then
            print(loadstring(base64decode("4p2MIE7Do28gZm9pIHBvc3PDrXZlbCBlbmNvbnRyYXIgYSBwYXJ0ZSBwcmluY2lwYWwgZG8gdmXDrWN1bG8h"))())
            return
        end
        
        anchorActive = true
        anchorConstruction(mainPart)
        
        -- Se fly estiver ativo, desativa para evitar conflito
        if flyActive then
            toggleFly()
        end
    end
end

-- ═══════════════════════════════════════════════
-- CRIAR INTERFACE
-- ═══════════════════════════════════════════════
local function createGUI()
    local gui = Instance.new(loadstring(base64decode("U2NyZWVuR3Vp"))())
    gui.Name = loadstring(base64decode("THVhSHVi"))()
    gui.ResetOnSpawn = false
    gui.Parent = player:WaitForChild(loadstring(base64decode("UGxheWVyR3Vp"))())
    
    local frame = Instance.new(loadstring(base64decode("RnJhbWU="))(), gui)
    frame.Size = UDim2.new(0, 180, 0, 170)
    frame.Position = UDim2.new(0, 10, 0, 10)
    frame.BackgroundColor3 = Color3.fromRGB(0, 0, 0)
    frame.BackgroundTransparency = 0.4
    frame.BorderSizePixel = 0
    Instance.new(loadstring(base64decode("VUlDb3JuZXI="))(), frame).CornerRadius = UDim.new(0, 12)
    
    local title = Instance.new(loadstring(base64decode("VGV4dExhYmVs"))(), frame)
    title.Size = UDim2.new(1, 0, 0, 30)
    title.BackgroundTransparency = 1
    title.Font = Enum.Font.GothamBold
    title.TextSize = 18
    title.Text = loadstring(base64decode("8J+MmSBMVUEgSFVC"))()
    title.TextColor3 = Color3.fromRGB(0, 200, 255)
    
    -- Botão Fly
    flyBtn = Instance.new(loadstring(base64decode("VGV4dEJ1dHRvbg=="))(), frame)
    flyBtn.Size = UDim2.new(1, -20, 0, 35)
    flyBtn.Position = UDim2.new(0, 10, 0, 40)
    flyBtn.BackgroundColor3 = Color3.fromRGB(0, 120, 255)
    flyBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
    flyBtn.Font = Enum.Font.GothamBold
    flyBtn.TextSize = 14
    flyBtn.Text = loadstring(base64decode("8J+agCBGbHkgTmF2ZSBbT0ZGXQ=="))()
    flyBtn.AutoButtonColor = false
    Instance.new(loadstring(base64decode("VUlDb3JuZXI="))(), flyBtn).CornerRadius = UDim.new(0, 8)
    flyBtn.MouseButton1Click:Connect(toggleFly)
    
    -- Botão Âncora
    anchorBtn = Instance.new(loadstring(base64decode("VGV4dEJ1dHRvbg=="))(), frame)
    anchorBtn.Size = UDim2.new(1, -20, 0, 35)
    anchorBtn.Position = UDim2.new(0, 10, 0, 85)
    anchorBtn.BackgroundColor3 = Color3.fromRGB(120, 0, 255)
    anchorBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
    anchorBtn.Font = Enum.Font.GothamBold
    anchorBtn.TextSize = 14
    anchorBtn.Text = loadstring(base64decode("4pqTIEFuY29yYXIgW09GRl0="))()
    anchorBtn.AutoButtonColor = false
    Instance.new(loadstring(base64decode("VUlDb3JuZXI="))(), anchorBtn).CornerRadius = UDim.new(0, 8)
    anchorBtn.MouseButton1Click:Connect(toggleAnchor)
    
    -- Botão de impulso
    local thrustBtn = Instance.new(loadstring(base64decode("VGV4dEJ1dHRvbg=="))(), gui)
    thrustBtn.Size = UDim2.new(0, 70, 0, 70)
    thrustBtn.Position = UDim2.new(0, 15, 1, -85)
    thrustBtn.BackgroundColor3 = Color3.fromRGB(0, 0, 0)
    thrustBtn.BackgroundTransparency = 0.3
    thrustBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
    thrustBtn.Font = Enum.Font.GothamBold
    thrustBtn.TextSize = 30
    thrustBtn.Text = loadstring(base64decode("4pqh"))()
    Instance.new(loadstring(base64decode("VUlDb3JuZXI="))(), thrustBtn).CornerRadius = UDim.new(0, 35)
    
    thrustBtn.MouseButton1Down:Connect(function()
        if flyActive then
            thrustPressed = true
            thrustBtn.BackgroundColor3 = Color3.fromRGB(100, 100, 100)
        end
    end)
    
    thrustBtn.MouseButton1Up:Connect(function()
        thrustPressed = false
        thrustBtn.BackgroundColor3 = Color3.fromRGB(0, 0, 0)
    end)
    
    -- Tecla T
    UserInputService.InputBegan:Connect(function(input, gameProcessed)
        if gameProcessed then return end
        if input.KeyCode == Enum.KeyCode.T and flyActive then
            thrustPressed = true
            thrustBtn.BackgroundColor3 = Color3.fromRGB(100, 100, 100)
        end
    end)
    
    UserInputService.InputEnded:Connect(function(input, gameProcessed)
        if gameProcessed then return end
        if input.KeyCode == Enum.KeyCode.T then
            thrustPressed = false
            thrustBtn.BackgroundColor3 = Color3.fromRGB(0, 0, 0)
        end
    end)
    
    -- Informações
    local info1 = Instance.new(loadstring(base64decode("VGV4dExhYmVs"))(), frame)
    info1.Size = UDim2.new(1, 0, 0, 18)
    info1.Position = UDim2.new(0, 0, 1, -40)
    info1.BackgroundTransparency = 1
    info1.Font = Enum.Font.Gotham
    info1.TextSize = 11
    info1.Text = loadstring(base64decode("4pqhIG91IFQgPSBWb2Fy"))()
    info1.TextColor3 = Color3.fromRGB(150, 150, 150)
    
    local info2 = Instance.new(loadstring(base64decode("VGV4dExhYmVs"))(), frame)
    info2.Size = UDim2.new(1, 0, 0, 18)
    info2.Position = UDim2.new(0, 0, 1, -22)
    info2.BackgroundTransparency = 1
    info2.Font = Enum.Font.Gotham
    info2.TextSize = 11
    info2.Text = loadstring(base64decode("TW91c2UgPSBNaXJhcg=="))()
    info2.TextColor3 = Color3.fromRGB(150, 150, 150)
end

-- ═══════════════════════════════════════════════
-- EVENTOS DE LIMPEZA
-- ═══════════════════════════════════════════════
player.CharacterAdded:Connect(function(newChar)
    character = newChar
    humanoid = newChar:WaitForChild(loadstring(base64decode("SHVtYW5vaWQ="))())
    rootPart = newChar:WaitForChild(loadstring(base64decode("SHVtYW5vaWRSb290UGFydA=="))())
    
    if flyActive then
        flyActive = false
        if renderConnection then renderConnection:Disconnect() end
        clearFlyPhysics()
        flyBtn.Text = loadstring(base64decode("8J+agCBGbHkgTmF2ZSBbT0ZGXQ=="))()
        flyBtn.BackgroundColor3 = Color3.fromRGB(0, 120, 255)
    end
    
    restoreCamera()
end)

-- INICIAR
createGUI()
print(loadstring(base64decode("4pyFIExVQSBIVUIgQ09NUExFVE8gQ0FSUkVHQURPIQ=="))())
print(loadstring(base64decode("8J+OriBGbHkgTmF2ZTogU2VudGUgZW0gdW1hIG5hdmUgLT4gQXRpdmUgLT4gTWlyZSBjb20gbyBtb3VzZSAtPiBTZWd1cmUg4pqhIG91IFQ="))())
print(loadstring(base64decode("4pqTIEFuY29yYXI6IFByZW5kZSBhIG5hdmUvY29uc3RydcOnw6NvIGludGVpcmEgbm8gbHVnYXI="))())
end
OB5Rocnh(hrodE)
end)(...)