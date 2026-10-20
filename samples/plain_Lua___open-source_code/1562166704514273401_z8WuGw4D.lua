-- =======================================================
-- MONITE HUB BY ALVESCRIPT - MÓDULO ESP (PARTE 1)
-- =======================================================

local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local LocalPlayer = Players.LocalPlayer

local EspModule = {}
EspModule.Name = "ESP"

-- Configurações das Opções do ESP
EspModule.Box = false
EspModule.NameFlag = false
EspModule.Health = false
EspModule.Distance = false
EspModule.Skeleton = false
EspModule.Hat = false
EspModule.Chams = false
EspModule.Tracer = false
EspModule.HeadDot = false

-- Configurações de Cor
EspModule.Rainbow = false
EspModule.CurrentColor = Color3.fromRGB(0, 170, 255)

local EspObjects = {}

local function getEspColor()
    if EspModule.Rainbow then
        local hue = (tick() % 5) / 5
        return Color3.fromHSV(hue, 1, 1)
    end
    return EspModule.CurrentColor
end

local function removeEsp(player)
    if EspObjects[player] then
        for _, obj in pairs(EspObjects[player]) do
            if type(obj) == "table" then
                for _, subObj in pairs(obj) do
                    if typeof(subObj) == "userdata" and subObj.Remove then subObj:Remove() end
                end
            elseif typeof(obj) == "userdata" and obj.Remove then
                obj:Remove()
            elseif typeof(obj) == "Instance" then
                obj:Destroy()
            end
        end
        EspObjects[player] = nil
    end
end

local function createEspObjects(player)
    if EspObjects[player] then return end

    local skelLines = {}
    for i = 1, 5 do
        local l = Drawing.new("Line")
        l.Thickness = 1.5
        l.Visible = false
        table.insert(skelLines, l)
    end

    local hatLines = {}
    for i = 1, 12 do
        local l = Drawing.new("Line")
        l.Thickness = 1.5
        l.Visible = false
        table.insert(hatLines, l)
    end

    local drawings = {
        Box = Drawing.new("Square"),
        Name = Drawing.new("Text"),
        Health = Drawing.new("Text"),
        Distance = Drawing.new("Text"),
        Tracer = Drawing.new("Line"),
        HeadDot = Drawing.new("Circle"),
        Skeleton = skelLines,
        Hat = hatLines,
        Chams = Instance.new("Highlight")
    }

    drawings.Box.Thickness = 1.5
    drawings.Name.Size = 13
    drawings.Name.Center = true
    drawings.Name.Outline = true
    drawings.Health.Size = 11
    drawings.Health.Center = true
    drawings.Health.Outline = true
    drawings.Distance.Size = 11
    drawings.Distance.Center = true
    drawings.Distance.Outline = true
    drawings.Tracer.Thickness = 1.5
    drawings.HeadDot.Radius = 4
    drawings.HeadDot.Filled = true

    EspObjects[player] = drawings
end
-- =======================================================
-- MONITE HUB BY ALVESCRIPT - MÓDULO ESP (PARTE 2)
-- =======================================================

-- Executa com máxima prioridade e sem travamentos para atingir 120+ FPS
RunService:UnbindFromRenderStep("MoniteEspRender")
RunService:BindToRenderStep("MoniteEspRender", Enum.RenderPriority.Camera.Value + 1, function()
    local Camera = workspace.CurrentCamera
    if not Camera then return end

    local color = getEspColor()
    local viewportSize = Camera.ViewportSize
    local screenCenter = Vector2.new(viewportSize.X / 2, viewportSize.Y)

    for _, player in ipairs(Players:GetPlayers()) do
        if player ~= LocalPlayer then
            local char = player.Character
            if char and char:FindFirstChild("Humanoid") and char.Humanoid.Health > 0 then
                createEspObjects(player)
                local objs = EspObjects[player]
                local root = char:FindFirstChild("HumanoidRootPart")
                local head = char:FindFirstChild("Head")

                if root and head then
                    local headWorld = head.Position + Vector3.new(0, 0.5, 0)
                    local legWorld = root.Position - Vector3.new(0, 3, 0)

                    local rootPos, onScreen = Camera:WorldToViewportPoint(root.Position)
                    local headPos = Camera:WorldToViewportPoint(headWorld)
                    local legPos = Camera:WorldToViewportPoint(legWorld)

                    if onScreen then
                        local boxHeight = math.abs(headPos.Y - legPos.Y)
                        local boxWidth = boxHeight / 1.5

                        -- ESP BOX
                        if EspModule.Box then
                            objs.Box.Visible = true
                            objs.Box.Size = Vector2.new(boxWidth, boxHeight)
                            objs.Box.Position = Vector2.new(rootPos.X - boxWidth / 2, headPos.Y)
                            objs.Box.Color = color
                        else
                            objs.Box.Visible = false
                        end

                        -- ESP NOME
                        if EspModule.NameFlag then
                            objs.Name.Visible = true
                            objs.Name.Text = player.DisplayName
                            objs.Name.Position = Vector2.new(rootPos.X, headPos.Y - 16)
                            objs.Name.Color = color
                        else
                            objs.Name.Visible = false
                        end

                        -- ESP VIDA
                        if EspModule.Health then
                            objs.Health.Visible = true
                            objs.Health.Text = "Vida: " .. math.floor(char.Humanoid.Health)
                            objs.Health.Position = Vector2.new(rootPos.X, legPos.Y + 2)
                            objs.Health.Color = Color3.fromRGB(0, 255, 100)
                        else
                            objs.Health.Visible = false
                        end

                        -- ESP DISTÂNCIA
                        if EspModule.Distance then
                            objs.Distance.Visible = true
                            local dist = math.floor((root.Position - Camera.CFrame.Position).Magnitude)
                            objs.Distance.Text = dist .. "m"
                            objs.Distance.Position = Vector2.new(rootPos.X, legPos.Y + 14)
                            objs.Distance.Color = Color3.fromRGB(200, 200, 200)
                        else
                            objs.Distance.Visible = false
                        end

                        -- ESP TRACER
                        if EspModule.Tracer then
                            objs.Tracer.Visible = true
                            objs.Tracer.From = screenCenter
                            objs.Tracer.To = Vector2.new(rootPos.X, rootPos.Y)
                            objs.Tracer.Color = color
                        else
                            objs.Tracer.Visible = false
                        end

                        -- HEAD DOT
                        if EspModule.HeadDot then
                            objs.HeadDot.Visible = true
                            objs.HeadDot.Position = Vector2.new(headPos.X, headPos.Y + 4)
                            objs.HeadDot.Color = color
                        else
                            objs.HeadDot.Visible = false
                        end

                        -- ESP ESQUELETO
                        if EspModule.Skeleton then
                            local headP = Camera:WorldToViewportPoint(head.Position)
                            local torsoP = Camera:WorldToViewportPoint(root.Position)
                            local leftArm = char:FindFirstChild("LeftUpperArm") or char:FindFirstChild("Left Arm")
                            local rightArm = char:FindFirstChild("RightUpperArm") or char:FindFirstChild("Right Arm")
                            local leftLeg = char:FindFirstChild("LeftLowerLeg") or char:FindFirstChild("Left Leg")
                            local rightLeg = char:FindFirstChild("RightLowerLeg") or char:FindFirstChild("Right Leg")

                            local joints = {
                                {headP, torsoP},
                                leftArm and {torsoP, Camera:WorldToViewportPoint(leftArm.Position)},
                                rightArm and {torsoP, Camera:WorldToViewportPoint(rightArm.Position)},
                                leftLeg and {torsoP, Camera:WorldToViewportPoint(leftLeg.Position)},
                                rightLeg and {torsoP, Camera:WorldToViewportPoint(rightLeg.Position)}
                            }

                            for i, line in ipairs(objs.Skeleton) do
                                local pair = joints[i]
                                if pair and pair[1] and pair[2] then
                                    line.Visible = true
                                    line.From = Vector2.new(pair[1].X, pair[1].Y)
                                    line.To = Vector2.new(pair[2].X, pair[2].Y)
                                    line.Color = color
                                else
                                    line.Visible = false
                                end
                            end
                        else
                            for _, line in ipairs(objs.Skeleton) do line.Visible = false end
                        end

                        -- ESP CHAPÉU
                        if EspModule.Hat then
                            local topPoint = Camera:WorldToViewportPoint(head.Position + Vector3.new(0, 1.2, 0))
                            local radius = 1.5
                            local points = {}
                            for i = 1, 6 do
                                local angle = (i / 6) * math.pi * 2
                                local ringPos = head.Position + Vector3.new(math.cos(angle) * radius, 0.3, math.sin(angle) * radius)
                                local p2d = Camera:WorldToViewportPoint(ringPos)
                                table.insert(points, Vector2.new(p2d.X, p2d.Y))
                            end

                            for i = 1, 6 do
                                local l = objs.Hat[i]
                                l.Visible = true
                                l.From = Vector2.new(topPoint.X, topPoint.Y)
                                l.To = points[i]
                                l.Color = color
                            end

                            for i = 1, 6 do
                                local l = objs.Hat[6 + i]
                                if l then
                                    l.Visible = true
                                    l.From = points[i]
                                    l.To = points[(i % 6) + 1]
                                    l.Color = color
                                end
                            end
                        else
                            for _, line in ipairs(objs.Hat) do line.Visible = false end
                        end

                        -- ESP CHAMS
                        if EspModule.Chams then
                            objs.Chams.Parent = char
                            objs.Chams.FillColor = color
                            objs.Chams.OutlineColor = Color3.fromRGB(255, 255, 255)
                            objs.Chams.FillTransparency = 0.5
                            objs.Chams.Enabled = true
                        else
                            objs.Chams.Enabled = false
                        end
                    else
                        objs.Box.Visible = false
                        objs.Name.Visible = false
                        objs.Health.Visible = false
                        objs.Distance.Visible = false
                        objs.Tracer.Visible = false
                        objs.HeadDot.Visible = false
                        objs.Chams.Enabled = false
                        for _, line in ipairs(objs.Skeleton) do line.Visible = false end
                        for _, line in ipairs(objs.Hat) do line.Visible = false end
                    end
                end
            else
                removeEsp(player)
            end
        end
    end
end)

Players.PlayerRemoving:Connect(removeEsp)
-- =======================================================
-- MONITE HUB BY ALVESCRIPT - MÓDULO ESP (PARTE 3)
-- =======================================================

function EspModule.BuildTab(parentContainer)
    for _, child in ipairs(parentContainer:GetChildren()) do
        if child:IsA("GuiObject") then
            child:Destroy()
        end
    end

    local ScrollFrame = Instance.new("ScrollingFrame")
    ScrollFrame.Name = "EspScroll"
    ScrollFrame.Parent = parentContainer
    ScrollFrame.BackgroundTransparency = 1
    ScrollFrame.Size = UDim2.new(1, 0, 1, 0)
    ScrollFrame.CanvasSize = UDim2.new(0, 0, 0, 540)
    ScrollFrame.ScrollBarThickness = 4
    ScrollFrame.ScrollBarImageColor3 = Color3.fromRGB(100, 105, 120)

    local UIListLayout = Instance.new("UIListLayout")
    UIListLayout.Parent = ScrollFrame
    UIListLayout.SortOrder = Enum.SortOrder.LayoutOrder
    UIListLayout.Padding = UDim.new(0, 8)

    local UIPadding = Instance.new("UIPadding")
    UIPadding.Parent = ScrollFrame
    UIPadding.PaddingTop = UDim.new(0, 6)
    UIPadding.PaddingLeft = UDim.new(0, 6)
    UIPadding.PaddingRight = UDim.new(0, 6)

    local function createToggleSwitch(text, order, initialState, callback)
        local card = Instance.new("Frame")
        card.Name = text .. "Card"
        card.Parent = ScrollFrame
        card.BackgroundColor3 = Color3.fromRGB(20, 20, 20)
        card.BackgroundTransparency = 0.4
        card.BorderSizePixel = 0
        card.Size = UDim2.new(1, 0, 0, 36)
        card.LayoutOrder = order

        local cardCorner = Instance.new("UICorner")
        cardCorner.CornerRadius = UDim.new(0, 6)
        cardCorner.Parent = card

        local label = Instance.new("TextLabel")
        label.Parent = card
        label.BackgroundTransparency = 1
        label.Position = UDim2.new(0, 12, 0, 0)
        label.Size = UDim2.new(1, -70, 1, 0)
        label.Font = Enum.Font.GothamSemibold
        label.Text = text
        label.TextColor3 = Color3.fromRGB(240, 240, 240)
        label.TextSize = 12
        label.TextXAlignment = Enum.TextXAlignment.Left

        local switchBg = Instance.new("TextButton")
        switchBg.Parent = card
        switchBg.BackgroundColor3 = initialState and Color3.fromRGB(0, 150, 230) or Color3.fromRGB(45, 45, 50)
        switchBg.Position = UDim2.new(1, -48, 0.5, -11)
        switchBg.Size = UDim2.new(0, 38, 0, 22)
        switchBg.Text = ""

        local switchCorner = Instance.new("UICorner")
        switchCorner.CornerRadius = UDim.new(1, 0)
        switchCorner.Parent = switchBg

        local circle = Instance.new("Frame")
        circle.Parent = switchBg
        circle.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
        circle.Position = initialState and UDim2.new(1, -19, 0.5, -8) or UDim2.new(0, 3, 0.5, -8)
        circle.Size = UDim2.new(0, 16, 0, 16)

        local circleCorner = Instance.new("UICorner")
        circleCorner.CornerRadius = UDim.new(1, 0)
        circleCorner.Parent = circle

        local active = initialState
        switchBg.MouseButton1Click:Connect(function()
            active = not active
            switchBg.BackgroundColor3 = active and Color3.fromRGB(0, 150, 230) or Color3.fromRGB(45, 45, 50)
            circle.Position = active and UDim2.new(1, -19, 0.5, -8) or UDim2.new(0, 3, 0.5, -8)
            callback(active)
        end)
    end

    -- Toggles de ESP
    createToggleSwitch("ESP Esqueleto", 1, EspModule.Skeleton, function(st) EspModule.Skeleton = st end)
    createToggleSwitch("ESP Chapéu", 2, EspModule.Hat, function(st) EspModule.Hat = st end)
    createToggleSwitch("ESP Box", 3, EspModule.Box, function(st) EspModule.Box = st end)
    createToggleSwitch("ESP Nome", 4, EspModule.NameFlag, function(st) EspModule.NameFlag = st end)
    createToggleSwitch("ESP Vida", 5, EspModule.Health, function(st) EspModule.Health = st end)
    createToggleSwitch("ESP Distância", 6, EspModule.Distance, function(st) EspModule.Distance = st end)
    createToggleSwitch("ESP Chams", 7, EspModule.Chams, function(st) EspModule.Chams = st end)
    createToggleSwitch("ESP Linha (Tracer)", 8, EspModule.Tracer, function(st) EspModule.Tracer = st end)
    createToggleSwitch("Head Dot", 9, EspModule.HeadDot, function(st) EspModule.HeadDot = st end)
    createToggleSwitch("ESP Rainbow", 10, EspModule.Rainbow, function(st) EspModule.Rainbow = st end)

    -- Seletor de Cores
    local colorCard = Instance.new("Frame")
    colorCard.Parent = ScrollFrame
    colorCard.BackgroundColor3 = Color3.fromRGB(20, 20, 20)
    colorCard.BackgroundTransparency = 0.4
    colorCard.BorderSizePixel = 0
    colorCard.Size = UDim2.new(1, 0, 0, 36)
    colorCard.LayoutOrder = 11

    local cardCorner = Instance.new("UICorner")
    cardCorner.CornerRadius = UDim.new(0, 6)
    cardCorner.Parent = colorCard

    local colorLabel = Instance.new("TextLabel")
    colorLabel.Parent = colorCard
    colorLabel.BackgroundTransparency = 1
    colorLabel.Position = UDim2.new(0, 12, 0, 0)
    colorLabel.Size = UDim2.new(0, 150, 1, 0)
    colorLabel.Font = Enum.Font.GothamSemibold
    colorLabel.Text = "Cor do ESP"
    colorLabel.TextColor3 = Color3.fromRGB(240, 240, 240)
    colorLabel.TextSize = 12
    colorLabel.TextXAlignment = Enum.TextXAlignment.Left

    local colorBtn = Instance.new("TextButton")
    colorBtn.Parent = colorCard
    colorBtn.BackgroundColor3 = EspModule.CurrentColor
    colorBtn.Position = UDim2.new(1, -110, 0.5, -12)
    colorBtn.Size = UDim2.new(0, 100, 0, 24)
    colorBtn.Font = Enum.Font.GothamBold
    colorBtn.Text = "Escolher Cor"
    colorBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
    colorBtn.TextSize = 11

    local btnCorner = Instance.new("UICorner")
    btnCorner.CornerRadius = UDim.new(0, 4)
    btnCorner.Parent = colorBtn

    local mainFrame = parentContainer.Parent
    local colorPickerWindow = mainFrame:FindFirstChild("ColorPickerWindow")
    if not colorPickerWindow then
        colorPickerWindow = Instance.new("Frame")
        colorPickerWindow.Name = "ColorPickerWindow"
        colorPickerWindow.Parent = mainFrame
        colorPickerWindow.BackgroundColor3 = Color3.fromRGB(20, 20, 20)
        colorPickerWindow.Position = UDim2.new(0.5, -100, 0.5, -75)
        colorPickerWindow.Size = UDim2.new(0, 200, 0, 150)
        colorPickerWindow.Visible = false
        colorPickerWindow.ZIndex = 30

        local subCorner = Instance.new("UICorner")
        subCorner.CornerRadius = UDim.new(0, 8)
        subCorner.Parent = colorPickerWindow

        local subTitle = Instance.new("TextLabel")
        subTitle.Parent = colorPickerWindow
        subTitle.BackgroundTransparency = 1
        subTitle.Position = UDim2.new(0, 10, 0, 5)
        subTitle.Size = UDim2.new(1, -40, 0, 25)
        subTitle.Font = Enum.Font.GothamBold
        subTitle.Text = "Selecione a Cor"
        subTitle.TextColor3 = Color3.fromRGB(255, 255, 255)
        subTitle.TextSize = 12
        subTitle.TextXAlignment = Enum.TextXAlignment.Left
        subTitle.ZIndex = 31

        local subMinBtn = Instance.new("TextButton")
        subMinBtn.Parent = colorPickerWindow
        subMinBtn.BackgroundColor3 = Color3.fromRGB(180, 40, 40)
        subMinBtn.Position = UDim2.new(1, -26, 0, 5)
        subMinBtn.Size = UDim2.new(0, 20, 0, 20)
        subMinBtn.Font = Enum.Font.GothamBold
        subMinBtn.Text = "X"
        subMinBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
        subMinBtn.TextSize = 11
        subMinBtn.ZIndex = 31

        local subMinCorner = Instance.new("UICorner")
        subMinCorner.CornerRadius = UDim.new(0, 4)
        subMinCorner.Parent = subMinBtn

        subMinBtn.MouseButton1Click:Connect(function() colorPickerWindow.Visible = false end)

        local PaletteGrid = Instance.new("Frame")
        PaletteGrid.Parent = colorPickerWindow
        PaletteGrid.BackgroundTransparency = 1
        PaletteGrid.Position = UDim2.new(0, 10, 0, 35)
        PaletteGrid.Size = UDim2.new(1, -20, 1, -45)
        PaletteGrid.ZIndex = 31

        local gridLayout = Instance.new("UIGridLayout")
        gridLayout.Parent = PaletteGrid
        gridLayout.CellSize = UDim2.new(0, 38, 0, 38)
        gridLayout.CellPadding = UDim2.new(0, 8, 0, 8)
        gridLayout.HorizontalAlignment = Enum.HorizontalAlignment.Center
        gridLayout.VerticalAlignment = Enum.VerticalAlignment.Center

        local colorPalette = {
            Color3.fromRGB(255, 0, 0),
            Color3.fromRGB(0, 255, 0),
            Color3.fromRGB(0, 170, 255),
            Color3.fromRGB(255, 255, 0),
            Color3.fromRGB(255, 0, 255),
            Color3.fromRGB(0, 255, 255),
            Color3.fromRGB(255, 128, 0),
            Color3.fromRGB(255, 255, 255)
        }

        for _, colorValue in ipairs(colorPalette) do
            local colorTile = Instance.new("TextButton")
            colorTile.Parent = PaletteGrid
            colorTile.BackgroundColor3 = colorValue
            colorTile.Text = ""
            colorTile.ZIndex = 32

            local tileCorner = Instance.new("UICorner")
            tileCorner.CornerRadius = UDim.new(0, 6)
            tileCorner.Parent = colorTile

            colorTile.MouseButton1Click:Connect(function()
                EspModule.CurrentColor = colorValue
                colorBtn.BackgroundColor3 = colorValue
                colorPickerWindow.Visible = false
            end)
        end
    end

    colorBtn.MouseButton1Click:Connect(function()
        colorPickerWindow.Visible = not colorPickerWindow.Visible
    end)
end

return EspModule
