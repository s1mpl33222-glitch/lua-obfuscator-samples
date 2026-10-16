-- ================================================
-- By ThiAez
-- Game: ¡Construye un arte de píxeles!
-- ================================================

local UserInputService = game:GetService("UserInputService")
local RunService = game:GetService("RunService")
local Workspace = game:GetService("Workspace")
local Players = game:GetService("Players")
local LocalPlayer = Players.LocalPlayer

----------------------------------------------------------------
-- 0. LIMPIEZA DE SCRIPTS / INTERFACES ANTERIORES
----------------------------------------------------------------
local targetContainer = gethui and gethui() or (game:GetService("CoreGui") or LocalPlayer:WaitForChild("PlayerGui"))

for _, oldGui in ipairs(targetContainer:GetChildren()) do
    if oldGui:IsA("ScreenGui") and (oldGui.Name == "ThiAezAutoDrawHub" or oldGui.Name == "ThiAezHub") then
        print("[ThiAez Hub] Removiendo versión anterior...")
        if _G.ThiAezAutoFarmActive ~= nil then
            _G.ThiAezAutoFarmActive = false
        end
        oldGui:Destroy()
    end
end

_G.ThiAezAutoFarmActive = false
task.wait(0.1)
_G.ThiAezAutoFarmActive = true

-- Configuraciones principales
local GAME_NAME = "¡Construye un arte de píxeles!"
local autoFarmActive = false
local autoSelectNextArt = true
local useFlightMode = true  -- true = Vuelo Suave | false = Teleport Directo
local flySpeed = 160        -- Velocidad de vuelo
local tpDelay = 0.05        -- Delay para Teleport Directo
local ultimoBotonElegido = nil

----------------------------------------------------------------
-- INTERFAZ GRÁFICA (GUI)
----------------------------------------------------------------
local ScreenGui = Instance.new("ScreenGui")
ScreenGui.Name = "ThiAezAutoDrawHub"
ScreenGui.ResetOnSpawn = false
ScreenGui.Parent = targetContainer

local MainFrame = Instance.new("Frame")
MainFrame.Name = "MainFrame"
MainFrame.Size = UDim2.new(0, 330, 0, 450)
MainFrame.Position = UDim2.new(0.5, -165, 0.3, -225)
MainFrame.BackgroundColor3 = Color3.fromRGB(15, 15, 15)
MainFrame.BackgroundTransparency = 0.2
MainFrame.BorderSizePixel = 0
MainFrame.Active = true
MainFrame.Parent = ScreenGui

local UICorner = Instance.new("UICorner")
UICorner.CornerRadius = UDim.new(0, 8)
UICorner.Parent = MainFrame

local UIStroke = Instance.new("UIStroke")
UIStroke.Color = Color3.fromRGB(45, 45, 45)
UIStroke.Thickness = 1.5
UIStroke.Parent = MainFrame

-- Header
local TopBar = Instance.new("Frame")
TopBar.Name = "TopBar"
TopBar.Size = UDim2.new(1, 0, 0, 35)
TopBar.BackgroundColor3 = Color3.fromRGB(25, 25, 25)
TopBar.BackgroundTransparency = 0.15
TopBar.BorderSizePixel = 0
TopBar.Parent = MainFrame

local TopBarCorner = Instance.new("UICorner")
TopBarCorner.CornerRadius = UDim.new(0, 8)
TopBarCorner.Parent = TopBar

local TitleLabel = Instance.new("TextLabel")
TitleLabel.Name = "TitleLabel"
TitleLabel.Size = UDim2.new(1, -40, 1, 0)
TitleLabel.Position = UDim2.new(0, 10, 0, 0)
TitleLabel.BackgroundTransparency = 1
TitleLabel.Text = "By ThiAez"
TitleLabel.TextColor3 = Color3.fromRGB(255, 255, 255)
TitleLabel.TextSize = 14
TitleLabel.Font = Enum.Font.SourceSansBold
TitleLabel.TextXAlignment = Enum.TextXAlignment.Left
TitleLabel.Parent = TopBar

local GameLabel = Instance.new("TextLabel")
GameLabel.Name = "GameLabel"
GameLabel.Size = UDim2.new(1, -20, 0, 15)
GameLabel.Position = UDim2.new(0, 10, 1, -18)
GameLabel.BackgroundTransparency = 1
GameLabel.Text = "Game: " .. GAME_NAME
GameLabel.TextColor3 = Color3.fromRGB(150, 150, 150)
GameLabel.TextSize = 11
GameLabel.Font = Enum.Font.SourceSans
GameLabel.TextXAlignment = Enum.TextXAlignment.Left
GameLabel.Parent = MainFrame

local MinimizeBtn = Instance.new("TextButton")
MinimizeBtn.Name = "MinimizeBtn"
MinimizeBtn.Size = UDim2.new(0, 25, 0, 25)
MinimizeBtn.Position = UDim2.new(1, -30, 0, 5)
MinimizeBtn.BackgroundColor3 = Color3.fromRGB(35, 35, 35)
MinimizeBtn.BackgroundTransparency = 0.3
MinimizeBtn.Text = "-"
MinimizeBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
MinimizeBtn.TextSize = 16
MinimizeBtn.Font = Enum.Font.SourceSansBold
MinimizeBtn.Parent = TopBar

local BtnCorner = Instance.new("UICorner")
BtnCorner.CornerRadius = UDim.new(0, 4)
BtnCorner.Parent = MinimizeBtn

local Container = Instance.new("Frame")
Container.Name = "Container"
Container.Size = UDim2.new(1, -20, 1, -65)
Container.Position = UDim2.new(0, 10, 0, 40)
Container.BackgroundTransparency = 1
Container.Parent = MainFrame

local UIListLayout = Instance.new("UIListLayout")
UIListLayout.SortOrder = Enum.SortOrder.LayoutOrder
UIListLayout.Padding = UDim.new(0, 8)
UIListLayout.Parent = Container

----------------------------------------------------------------
-- SISTEMA DE DRAG
----------------------------------------------------------------
local dragging, dragInput, dragStart, startPos
local function updateDrag(input)
    local delta = input.Position - dragStart
    MainFrame.Position = UDim2.new(startPos.X.Scale, startPos.X.Offset + delta.X, startPos.Y.Scale, startPos.Y.Offset + delta.Y)
end

TopBar.InputBegan:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
        dragging = true
        dragStart = input.Position
        startPos = MainFrame.Position
        input.Changed:Connect(function()
            if input.UserInputState == Enum.UserInputState.End then dragging = false end
        end)
    end
end)

TopBar.InputChanged:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch then
        dragInput = input
    end
end)

UserInputService.InputChanged:Connect(function(input)
    if input == dragInput and dragging then updateDrag(input) end
end)

----------------------------------------------------------------
-- MINIMIZAR
----------------------------------------------------------------
local minimized = false
MinimizeBtn.MouseButton1Click:Connect(function()
    minimized = not minimized
    if minimized then
        Container.Visible = false
        GameLabel.Visible = false
        MainFrame:TweenSize(UDim2.new(0, 330, 0, 35), Enum.EasingDirection.Out, Enum.EasingStyle.Quart, 0.2, true)
        MinimizeBtn.Text = "+"
    else
        MainFrame:TweenSize(UDim2.new(0, 330, 0, 450), Enum.EasingDirection.Out, Enum.EasingStyle.Quart, 0.2, true)
        task.wait(0.1)
        Container.Visible = true
        GameLabel.Visible = true
        MinimizeBtn.Text = "-"
    end
end)

----------------------------------------------------------------
-- MOVIMIENTO
----------------------------------------------------------------
local function moveTo(targetCFrame)
    local char = LocalPlayer.Character
    if not char then return end
    local root = char:FindFirstChild("HumanoidRootPart")
    if not root then return end

    local targetPos = targetCFrame.Position + Vector3.new(0, 2.2, 0)

    if useFlightMode then
        local distance = (targetPos - root.Position).Magnitude
        local duration = distance / flySpeed
        local startTime = tick()
        local startPos = root.Position

        while tick() - startTime < duration and autoFarmActive and _G.ThiAezAutoFarmActive do
            local alpha = (tick() - startTime) / duration
            root.CFrame = CFrame.new(startPos:Lerp(targetPos, alpha))
            root.AssemblyLinearVelocity = Vector3.zero
            RunService.Heartbeat:Wait()
        end
        root.CFrame = CFrame.new(targetPos)
    else
        root.CFrame = CFrame.new(targetPos)
        if tpDelay > 0 then
            task.wait(tpDelay)
        end
    end
end

----------------------------------------------------------------
-- DETECCIÓN DE PLOT Y BLOQUES
----------------------------------------------------------------
local function tieneBloquesCargados()
    local char = LocalPlayer.Character
    if not char then return false end
    local carryStack = char:FindFirstChild("CarryStack")
    return carryStack and #carryStack:GetChildren() > 0
end

local function hayBloquesEnPilasDisponibles(myPlot)
    local contents = myPlot and myPlot:FindFirstChild("Contents")
    if not contents then return false end

    local pilesFolder = contents:FindFirstChild("Piles")
    if not pilesFolder then return false end

    for _, pile in ipairs(pilesFolder:GetChildren()) do
        local blocksFolder = pile:FindFirstChild("Blocks")
        if blocksFolder and #blocksFolder:GetChildren() > 0 then
            return true
        end
    end
    return false
end

local function getMyPlot()
    local plotsFolder = Workspace:FindFirstChild("Plots")
    if not plotsFolder then return nil end

    for _, plot in ipairs(plotsFolder:GetChildren()) do
        local nameplateText = plot:FindFirstChild("PlotPlatform") 
            and plot.PlotPlatform:FindFirstChild("OwnerMarker")
            and plot.PlotPlatform.OwnerMarker:FindFirstChild("Nameplate")
            and plot.PlotPlatform.OwnerMarker.Nameplate:FindFirstChild("Frame")
            and plot.PlotPlatform.OwnerMarker.Nameplate.Frame:FindFirstChild("TextLabel")

        if nameplateText and (nameplateText.Text == LocalPlayer.Name or nameplateText.Text == LocalPlayer.DisplayName) then
            return plot
        end
    end
    return nil
end

local function recargarBloques(myPlot)
    local contents = myPlot:FindFirstChild("Contents")
    if not contents then return false end

    local pilesFolder = contents:FindFirstChild("Piles")
    if not pilesFolder then return false end

    local algunBloqueEncontrado = false

    for _, pile in ipairs(pilesFolder:GetChildren()) do
        if not autoFarmActive or not _G.ThiAezAutoFarmActive or tieneBloquesCargados() then break end
        
        local blocksFolder = pile:FindFirstChild("Blocks")
        local pad = pile:FindFirstChild("Pad") or pile:FindFirstChild("Trigger") or pile:FindFirstChildWhichIsA("BasePart")

        if blocksFolder and #blocksFolder:GetChildren() > 0 and pad then
            algunBloqueEncontrado = true
            moveTo(pad.CFrame)
            task.wait(0.15)
        end
    end

    return algunBloqueEncontrado or tieneBloquesCargados()
end

----------------------------------------------------------------
-- SELECCIÓN CON ESPERA REALISTA (3-5 SEGUNDOS)
----------------------------------------------------------------
local function forzarClickBoton(btn)
    if not btn then return end

    if firesignal then
        pcall(function() firesignal(btn.MouseButton1Click) end)
        pcall(function() firesignal(btn.MouseButton1Down) end)
        pcall(function() firesignal(btn.Activated) end)
    end

    if getconnections then
        for _, eventName in ipairs({"MouseButton1Click", "MouseButton1Down", "Activated"}) do
            if btn[eventName] then
                pcall(function()
                    for _, c in pairs(getconnections(btn[eventName])) do
                        c:Fire()
                    end
                end)
            end
        end
    end

    for _, child in ipairs(btn:GetChildren()) do
        if child:IsA("GuiButton") then
            forzarClickBoton(child)
        end
    end
end

local function obtenerObrasEnGaleria(myPlot)
    local completados = {}
    local gallery = myPlot and (myPlot:FindFirstChild("Gallery") or Workspace:FindFirstChild("Gallery", true))
    
    if gallery then
        for _, item in ipairs(gallery:GetChildren()) do
            local cleanName = item.Name:gsub("Piece_%d+_", ""):lower()
            completados[cleanName] = true
            completados[item.Name:lower()] = true
        end
    end
    return completados
end

local function seleccionarNuevoPixelArt(myPlot)
    print("[ThiAez Hub] Buscando nuevo Pixel Art...")

    local playerGui = LocalPlayer:FindFirstChild("PlayerGui")
    if not playerGui then return end

    local pixelArtMenu = playerGui:FindFirstChild("PixelArtMenu")
    if not pixelArtMenu then return end

    local grid = pixelArtMenu:FindFirstChild("Backdrop", true)
        and pixelArtMenu.Backdrop:FindFirstChild("Panel", true)
        and pixelArtMenu.Backdrop.Panel:FindFirstChild("Body", true)
        and pixelArtMenu.Backdrop.Panel.Body:FindFirstChild("GridHolder", true)
        and pixelArtMenu.Backdrop.Panel.Body.GridHolder:FindFirstChild("Grid", true)

    if not grid then
        grid = pixelArtMenu:FindFirstChild("Grid", true)
    end

    if not grid then return end

    local completadosInGallery = obtenerObrasEnGaleria(myPlot)
    local candidatos = {}

    for index, item in ipairs(grid:GetChildren()) do
        local btn = item:IsA("GuiButton") and item or item:FindFirstChildWhichIsA("GuiButton", true)
        local btnObj = btn or item
        
        if item:IsA("GuiButton") or item:IsA("Frame") or item:IsA("TextButton") or item:IsA("ImageButton") then
            local cleanName = item.Name:gsub("Piece_%d+_", ""):lower()

            if btnObj.Name ~= ultimoBotonElegido and not completadosInGallery[cleanName] then
                table.insert(candidatos, { btn = btnObj, idx = index })
            end
        end
    end

    if #candidatos == 0 then
        for index, item in ipairs(grid:GetChildren()) do
            local btn = item:IsA("GuiButton") and item or item:FindFirstChildWhichIsA("GuiButton", true)
            local btnObj = btn or item
            if (item:IsA("GuiButton") or item:IsA("Frame")) and btnObj.Name ~= ultimoBotonElegido then
                table.insert(candidatos, { btn = btnObj, idx = index })
            end
        end
    end

    if #candidatos == 0 then return end

    -- Mezclar opciones
    for i = #candidatos, 2, -1 do
        local j = math.random(i)
        candidatos[i], candidatos[j] = candidatos[j], candidatos[i]
    end

    for _, data in ipairs(candidatos) do
        if not autoFarmActive and not _G.ThiAezAutoFarmActive then break end
        
        local btnElegido = data.btn
        print("[ThiAez Hub] Click en cuadro: " .. btnElegido.Name)
        forzarClickBoton(btnElegido)

        -- ESPERA DE 4 SEGUNDOS PARA QUE EL JUEGO CARGUE EL LIENZO Y LOS BLOQUES
        print("[ThiAez Hub] Esperando 4 segundos a que se cargue la pintura en el Plot...")
        task.wait(4)

        -- Verificar si aparecieron bloques o celdas cargadas
        if hayBloquesEnPilasDisponibles(myPlot) or tieneBloquesCargados() then
            print("[ThiAez Hub] ¡Pintura cargada con éxito! Empezando a dibujar...")
            ultimoBotonElegido = btnElegido.Name
            return true
        else
            print("[ThiAez Hub] No se cargaron bloques (Bloqueado/Paga). Probando otro cuadro...")
        end
    end
end

----------------------------------------------------------------
-- AUTO DIBUJO SMART
----------------------------------------------------------------
local function autoDibujarSmart(myPlot)
    local contents = myPlot:FindFirstChild("Contents")
    if not contents then return end

    local artCellsFolder = contents:FindFirstChild("ArtCells")
    local placedBlocksFolder = contents:FindFirstChild("PlacedBlocks")

    if not artCellsFolder or not placedBlocksFolder then return end

    local cellList = {}
    for _, cell in ipairs(artCellsFolder:GetChildren()) do
        local xStr, yStr = cell.Name:match("(%d+)_(%d+)")
        if xStr and yStr then
            table.insert(cellList, { inst = cell, name = cell.Name, x = tonumber(xStr), y = tonumber(yStr) })
        else
            table.insert(cellList, { inst = cell, name = cell.Name, x = 0, y = 0 })
        end
    end

    table.sort(cellList, function(a, b)
        if a.x == b.x then return a.y < b.y end
        return a.x < b.x
    end)

    local celdasPendientes = 0

    for _, item in ipairs(cellList) do
        if not autoFarmActive or not _G.ThiAezAutoFarmActive then break end

        local yaColocado = placedBlocksFolder:FindFirstChild(item.name)

        if not yaColocado then
            celdasPendientes = celdasPendientes + 1

            if not tieneBloquesCargados() then
                local hayBloquesEnPiles = recargarBloques(myPlot)

                -- Si no hay bloques, espera 5 segundos comprobando
                if not hayBloquesEnPiles and not tieneBloquesCargados() then
                    print("[ThiAez Hub] Sin bloques. Esperando 5s para recarga...")
                    local t = 0
                    while t < 5 and autoFarmActive and not tieneBloquesCargados() do
                        task.wait(1)
                        t = t + 1
                        if recargarBloques(myPlot) then break end
                    end

                    if not tieneBloquesCargados() and autoSelectNextArt then
                        seleccionarNuevoPixelArt(myPlot)
                        return
                    end
                end
            end

            if tieneBloquesCargados() then
                local part = item.inst:IsA("Model") and (item.inst.PrimaryPart or item.inst:FindFirstChildWhichIsA("BasePart")) or item.inst
                if part then
                    moveTo(part.CFrame)
                end
            end
        end
    end

    if celdasPendientes == 0 and autoSelectNextArt then
        seleccionarNuevoPixelArt(myPlot)
    end
end

local function startAutoFarm()
    autoFarmActive = true
    task.spawn(function()
        local myPlot = getMyPlot()
        if not myPlot then
            warn("[ThiAez Hub] No se encontró tu Plot activo.")
            autoFarmActive = false
            return
        end

        while autoFarmActive and _G.ThiAezAutoFarmActive do
            autoDibujarSmart(myPlot)
            task.wait(0.1)
        end
    end)
end

----------------------------------------------------------------
-- UI CONTROLES
----------------------------------------------------------------
local ToggleBtn = Instance.new("TextButton")
ToggleBtn.Size = UDim2.new(1, 0, 0, 38)
ToggleBtn.BackgroundColor3 = Color3.fromRGB(30, 30, 30)
ToggleBtn.BackgroundTransparency = 0.2
ToggleBtn.Text = "Auto Draw + Smart Next: OFF"
ToggleBtn.TextColor3 = Color3.fromRGB(255, 85, 85)
ToggleBtn.TextSize = 13
ToggleBtn.Font = Enum.Font.SourceSansBold
ToggleBtn.Parent = Container

local tCorner = Instance.new("UICorner")
tCorner.CornerRadius = UDim.new(0, 6)
tCorner.Parent = ToggleBtn

ToggleBtn.MouseButton1Click:Connect(function()
    autoFarmActive = not autoFarmActive
    if autoFarmActive then
        ToggleBtn.Text = "Auto Draw + Smart Next: ON"
        ToggleBtn.TextColor3 = Color3.fromRGB(85, 255, 127)
        startAutoFarm()
    else
        ToggleBtn.Text = "Auto Draw + Smart Next: OFF"
        ToggleBtn.TextColor3 = Color3.fromRGB(255, 85, 85)
    end
end)

local RandomArtBtn = Instance.new("TextButton")
RandomArtBtn.Size = UDim2.new(1, 0, 0, 35)
RandomArtBtn.BackgroundColor3 = Color3.fromRGB(35, 35, 45)
RandomArtBtn.BackgroundTransparency = 0.2
RandomArtBtn.Text = "🎲 Elegir Art Aleatorio (Nuevo)"
RandomArtBtn.TextColor3 = Color3.fromRGB(200, 200, 255)
RandomArtBtn.TextSize = 13
RandomArtBtn.Font = Enum.Font.SourceSansBold
RandomArtBtn.Parent = Container

local rCorner = Instance.new("UICorner")
rCorner.CornerRadius = UDim.new(0, 6)
rCorner.Parent = RandomArtBtn

RandomArtBtn.MouseButton1Click:Connect(function()
    local myPlot = getMyPlot()
    seleccionarNuevoPixelArt(myPlot)
end)

local ModeBtn = Instance.new("TextButton")
ModeBtn.Size = UDim2.new(1, 0, 0, 35)
ModeBtn.BackgroundColor3 = Color3.fromRGB(25, 25, 25)
ModeBtn.BackgroundTransparency = 0.2
ModeBtn.Text = "Modo: Vuelo Suave"
ModeBtn.TextColor3 = Color3.fromRGB(220, 220, 220)
ModeBtn.TextSize = 13
ModeBtn.Font = Enum.Font.SourceSans
ModeBtn.Parent = Container

local mCorner = Instance.new("UICorner")
mCorner.CornerRadius = UDim.new(0, 6)
mCorner.Parent = ModeBtn

ModeBtn.MouseButton1Click:Connect(function()
    useFlightMode = not useFlightMode
    if useFlightMode then
        ModeBtn.Text = "Modo: Vuelo Suave"
        ModeBtn.TextColor3 = Color3.fromRGB(220, 220, 220)
    else
        ModeBtn.Text = "Modo: Teleport"
        ModeBtn.TextColor3 = Color3.fromRGB(255, 170, 0)
    end
end)

local AutoNextBtn = Instance.new("TextButton")
AutoNextBtn.Size = UDim2.new(1, 0, 0, 35)
AutoNextBtn.BackgroundColor3 = Color3.fromRGB(25, 25, 25)
AutoNextBtn.BackgroundTransparency = 0.2
AutoNextBtn.Text = "Smart Auto-Next: ON"
AutoNextBtn.TextColor3 = Color3.fromRGB(85, 255, 127)
AutoNextBtn.TextSize = 13
AutoNextBtn.Font = Enum.Font.SourceSans
AutoNextBtn.Parent = Container

local anCorner = Instance.new("UICorner")
anCorner.CornerRadius = UDim.new(0, 6)
anCorner.Parent = AutoNextBtn

AutoNextBtn.MouseButton1Click:Connect(function()
    autoSelectNextArt = not autoSelectNextArt
    if autoSelectNextArt then
        AutoNextBtn.Text = "Smart Auto-Next: ON"
        AutoNextBtn.TextColor3 = Color3.fromRGB(85, 255, 127)
    else
        AutoNextBtn.Text = "Smart Auto-Next: OFF"
        AutoNextBtn.TextColor3 = Color3.fromRGB(255, 85, 85)
    end
end)

local SpeedFrame = Instance.new("Frame")
SpeedFrame.Size = UDim2.new(1, 0, 0, 40)
SpeedFrame.BackgroundColor3 = Color3.fromRGB(25, 25, 25)
SpeedFrame.BackgroundTransparency = 0.3
SpeedFrame.Parent = Container

local sCorner = Instance.new("UICorner")
sCorner.CornerRadius = UDim.new(0, 6)
sCorner.Parent = SpeedFrame

local SpeedLabel = Instance.new("TextLabel")
SpeedLabel.Size = UDim2.new(0.65, 0, 1, 0)
SpeedLabel.Position = UDim2.new(0, 10, 0, 0)
SpeedLabel.BackgroundTransparency = 1
SpeedLabel.Text = "Velocidad Vuelo:"
SpeedLabel.TextColor3 = Color3.fromRGB(200, 200, 200)
SpeedLabel.TextSize = 13
SpeedLabel.Font = Enum.Font.SourceSans
SpeedLabel.TextXAlignment = Enum.TextXAlignment.Left
SpeedLabel.Parent = SpeedFrame

local SpeedBox = Instance.new("TextBox")
SpeedBox.Size = UDim2.new(0.3, -10, 0.6, 0)
SpeedBox.Position = UDim2.new(0.7, 0, 0.2, 0)
SpeedBox.BackgroundColor3 = Color3.fromRGB(15, 15, 15)
SpeedBox.Text = tostring(flySpeed)
SpeedBox.TextColor3 = Color3.fromRGB(255, 255, 255)
SpeedBox.TextSize = 13
SpeedBox.Font = Enum.Font.SourceSansBold
SpeedBox.Parent = SpeedFrame

local sbCorner = Instance.new("UICorner")
sbCorner.CornerRadius = UDim.new(0, 4)
sbCorner.Parent = SpeedBox

SpeedBox.FocusLost:Connect(function()
    local val = tonumber(SpeedBox.Text)
    if val then
        flySpeed = math.clamp(val, 20, 600)
    else
        SpeedBox.Text = tostring(flySpeed)
    end
end)
