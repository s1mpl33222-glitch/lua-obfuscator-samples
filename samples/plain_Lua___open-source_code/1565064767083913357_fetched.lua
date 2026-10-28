-- by ItzKonst (Mobile Optimized)

local player = game.Players.LocalPlayer
local mouse = player:GetMouse()
local camera = game.Workspace.CurrentCamera
local uis = game:GetService("UserInputService")

-- Создание GUI
local gui = Instance.new("ScreenGui")
gui.Name = "MegaAimbot"
gui.Parent = player:WaitForChild("PlayerGui")
gui.ResetOnSpawn = false

-- ОСНОВНОЕ ОКНО (БОЛЬШОЕ ДЛЯ ПАЛЬЦЕВ)
local mainFrame = Instance.new("Frame")
mainFrame.Name = "MainFrame"
mainFrame.Size = UDim2.new(0, 350, 0, 550) -- Увеличил для мобилы
mainFrame.Position = UDim2.new(0.5, -175, 0.5, -275)
mainFrame.BackgroundColor3 = Color3.fromRGB(20, 20, 20)
mainFrame.BackgroundTransparency = 0.05
mainFrame.BorderSizePixel = 0
mainFrame.Active = true
mainFrame.Draggable = true -- Встроенный драг для мобилы!
mainFrame.Parent = gui

-- ЗАКРУГЛЕНИЯ (красиво)
local corner = Instance.new("UICorner")
corner.CornerRadius = UDim.new(0, 15)
corner.Parent = mainFrame

-- ЗАГОЛОВОК с подсветкой
local titleBar = Instance.new("Frame")
titleBar.Size = UDim2.new(1, 0, 0, 45)
titleBar.BackgroundColor3 = Color3.fromRGB(30, 30, 30)
titleBar.BorderSizePixel = 0
titleBar.Parent = mainFrame

local titleCorner = Instance.new("UICorner")
titleCorner.CornerRadius = UDim.new(0, 15)
titleCorner.Parent = titleBar

local title = Instance.new("TextLabel")
title.Size = UDim2.new(1, -50, 1, 0)
title.Position = UDim2.new(0, 15, 0, 0)
title.BackgroundTransparency = 1
title.Text = "⚡ MEGA AIMBOT v5 ⚡"
title.TextColor3 = Color3.fromRGB(255, 50, 50)
title.TextScaled = true
title.Font = Enum.Font.GothamBold
title.TextXAlignment = Enum.TextXAlignment.Left
title.Parent = titleBar

-- Кнопка закрытия (большая для мобилы)
local closeBtn = Instance.new("TextButton")
closeBtn.Size = UDim2.new(0, 40, 0, 40)
closeBtn.Position = UDim2.new(1, -45, 0, 2.5)
closeBtn.BackgroundColor3 = Color3.fromRGB(255, 50, 50)
closeBtn.Text = "✕"
closeBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
closeBtn.TextScaled = true
closeBtn.Font = Enum.Font.GothamBold
closeBtn.AutoButtonColor = false
closeBtn.Parent = titleBar

local closeCorner = Instance.new("UICorner")
closeCorner.CornerRadius = UDim.new(0, 10)
closeCorner.Parent = closeBtn

closeBtn.MouseButton1Click:Connect(function()
    gui:Destroy()
end)

-- КОНТЕЙНЕР ДЛЯ СКРОЛЛА (ВАЖНО ДЛЯ МОБИЛЫ!)
local scrollingFrame = Instance.new("ScrollingFrame")
scrollingFrame.Size = UDim2.new(1, 0, 1, -50)
scrollingFrame.Position = UDim2.new(0, 0, 0, 50)
scrollingFrame.BackgroundTransparency = 1
scrollingFrame.ScrollBarThickness = 8
scrollingFrame.ScrollBarImageColor3 = Color3.fromRGB(255, 50, 50)
scrollingFrame.CanvasSize = UDim2.new(0, 0, 0, 0)
scrollingFrame.AutomaticCanvasSize = Enum.AutomaticSize.Y
scrollingFrame.Parent = mainFrame

-- UI Спиннер (для красоты)
local uiCorner = Instance.new("UICorner")
uiCorner.CornerRadius = UDim.new(0, 10)
uiCorner.Parent = scrollingFrame

-- ========== ВСЕ НАСТРОЙКИ ==========
local settings = {
    -- Основное
    Enabled = true,
    AimKey = "MouseButton2", -- ПКМ для мобилы? Заменим на кнопку!
    AimKeyMobile = true, -- Специально для мобилы: авто-прицел
    
    -- Цели
    TeamCheck = false,
    WallCheck = false,
    VisibleCheck = false,
    IgnoreFriends = false,
    
    -- Прицеливание
    TargetPart = "Head",
    Smoothness = 5,
    Prediction = 0.165,
    FOV = 180,
    HitChance = 100,
    
    -- Визуал
    ShowFOV = true,
    ShowTargetLine = true,
    ShowTargetInfo = true,
    FOVColor = Color3.fromRGB(255, 50, 50),
    
    -- Дополнительно
    AutoShoot = false,
    TriggerBot = false,
    Airshot = false,
    Knockback = false
}

-- ========== ФУНКЦИИ СОЗДАНИЯ ЭЛЕМЕНТОВ (ВСЕ БОЛЬШИЕ ДЛЯ МОБИЛЫ) ==========

function createSection(parent, title, yPos)
    local section = Instance.new("Frame")
    section.Size = UDim2.new(1, -20, 0, 35)
    section.Position = UDim2.new(0, 10, 0, yPos)
    section.BackgroundTransparency = 1
    section.Parent = parent
    
    local line = Instance.new("Frame")
    line.Size = UDim2.new(1, 0, 0, 2)
    line.Position = UDim2.new(0, 0, 1, -10)
    line.BackgroundColor3 = Color3.fromRGB(255, 50, 50)
    line.BorderSizePixel = 0
    line.Parent = section
    
    local label = Instance.new("TextLabel")
    label.Size = UDim2.new(1, 0, 0, 25)
    label.BackgroundTransparency = 1
    label.Text = title
    label.TextColor3 = Color3.fromRGB(255, 255, 255)
    label.TextScaled = true
    label.Font = Enum.Font.GothamBold
    label.TextXAlignment = Enum.TextXAlignment.Left
    label.Parent = section
    
    return 35 -- Возвращаем высоту секции
end

function createBigToggle(parent, name, yPos, setting, defaultColor)
    local frame = Instance.new("Frame")
    frame.Size = UDim2.new(1, -20, 0, 50) -- ВЫСОКИЙ ДЛЯ ПАЛЬЦЕВ!
    frame.Position = UDim2.new(0, 10, 0, yPos)
    frame.BackgroundColor3 = Color3.fromRGB(30, 30, 30)
    frame.BorderSizePixel = 0
    frame.Parent = parent
    
    local frameCorner = Instance.new("UICorner")
    frameCorner.CornerRadius = UDim.new(0, 10)
    frameCorner.Parent = frame
    
    local label = Instance.new("TextLabel")
    label.Size = UDim2.new(0.6, 0, 1, 0)
    label.Position = UDim2.new(0, 15, 0, 0)
    label.BackgroundTransparency = 1
    label.Text = name
    label.TextColor3 = Color3.fromRGB(255, 255, 255)
    label.TextScaled = true
    label.Font = Enum.Font.SourceSansBold
    label.TextXAlignment = Enum.TextXAlignment.Left
    label.Parent = frame
    
    local toggleBtn = Instance.new("TextButton")
    toggleBtn.Size = UDim2.new(0, 80, 0, 40) -- БОЛЬШАЯ КНОПКА
    toggleBtn.Position = UDim2.new(1, -90, 0.5, -20)
    toggleBtn.BackgroundColor3 = defaultColor or Color3.fromRGB(0, 255, 0)
    toggleBtn.Text = "ON"
    toggleBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
    toggleBtn.TextScaled = true
    toggleBtn.Font = Enum.Font.GothamBold
    toggleBtn.AutoButtonColor = false
    toggleBtn.Parent = frame
    
    local btnCorner = Instance.new("UICorner")
    btnCorner.CornerRadius = UDim.new(0, 8)
    btnCorner.Parent = toggleBtn
    
    toggleBtn.MouseButton1Click:Connect(function()
        settings[setting] = not settings[setting]
        if settings[setting] then
            toggleBtn.BackgroundColor3 = Color3.fromRGB(0, 255, 0)
            toggleBtn.Text = "ON"
        else
            toggleBtn.BackgroundColor3 = Color3.fromRGB(255, 0, 0)
            toggleBtn.Text = "OFF"
        end
    end)
    
    return 60
end

function createSlider(parent, name, yPos, setting, min, max, suffix)
    local frame = Instance.new("Frame")
    frame.Size = UDim2.new(1, -20, 0, 70)
    frame.Position = UDim2.new(0, 10, 0, yPos)
    frame.BackgroundColor3 = Color3.fromRGB(30, 30, 30)
    frame.BorderSizePixel = 0
    frame.Parent = parent
    
    local frameCorner = Instance.new("UICorner")
    frameCorner.CornerRadius = UDim.new(0, 10)
    frameCorner.Parent = frame
    
    local label = Instance.new("TextLabel")
    label.Size = UDim2.new(0.6, 0, 0, 25)
    label.Position = UDim2.new(0, 15, 0, 5)
    label.BackgroundTransparency = 1
    label.Text = name
    label.TextColor3 = Color3.fromRGB(255, 255, 255)
    label.TextScaled = true
    label.Font = Enum.Font.SourceSansBold
    label.TextXAlignment = Enum.TextXAlignment.Left
    label.Parent = frame
    
    local valueLabel = Instance.new("TextLabel")
    valueLabel.Size = UDim2.new(0.3, 0, 0, 25)
    valueLabel.Position = UDim2.new(0.7, 0, 0, 5)
    valueLabel.BackgroundTransparency = 1
    valueLabel.Text = settings[setting] .. (suffix or "")
    valueLabel.TextColor3 = Color3.fromRGB(255, 50, 50)
    valueLabel.TextScaled = true
    valueLabel.Font = Enum.Font.GothamBold
    valueLabel.TextXAlignment = Enum.TextXAlignment.Right
    valueLabel.Parent = frame
    
    local inputBox = Instance.new("TextBox")
    inputBox.Size = UDim2.new(1, -30, 0, 35)
    inputBox.Position = UDim2.new(0, 15, 0, 30)
    inputBox.BackgroundColor3 = Color3.fromRGB(20, 20, 20)
    inputBox.Text = tostring(settings[setting])
    inputBox.TextColor3 = Color3.fromRGB(255, 255, 255)
    inputBox.TextScaled = true
    inputBox.Font = Enum.Font.SourceSansBold
    inputBox.PlaceholderText = "Введи значение..."
    inputBox.ClearTextOnFocus = false
    inputBox.Parent = frame
    
    local inputCorner = Instance.new("UICorner")
    inputCorner.CornerRadius = UDim.new(0, 8)
    inputCorner.Parent = inputBox
    
    inputBox.FocusLost:Connect(function()
        local val = tonumber(inputBox.Text)
        if val then
            settings[setting] = math.clamp(val, min, max)
            inputBox.Text = tostring(settings[setting])
            valueLabel.Text = settings[setting] .. (suffix or "")
        else
            inputBox.Text = tostring(settings[setting])
        end
    end)
    
    return 80
end

function createDropdown(parent, name, yPos, setting, options)
    local frame = Instance.new("Frame")
    frame.Size = UDim2.new(1, -20, 0, 70)
    frame.Position = UDim2.new(0, 10, 0, yPos)
    frame.BackgroundColor3 = Color3.fromRGB(30, 30, 30)
    frame.BorderSizePixel = 0
    frame.Parent = parent
    
    local frameCorner = Instance.new("UICorner")
    frameCorner.CornerRadius = UDim.new(0, 10)
    frameCorner.Parent = frame
    
    local label = Instance.new("TextLabel")
    label.Size = UDim2.new(1, -30, 0, 25)
    label.Position = UDim2.new(0, 15, 0, 5)
    label.BackgroundTransparency = 1
    label.Text = name
    label.TextColor3 = Color3.fromRGB(255, 255, 255)
    label.TextScaled = true
    label.Font = Enum.Font.SourceSansBold
    label.TextXAlignment = Enum.TextXAlignment.Left
    label.Parent = frame
    
    local dropdownBtn = Instance.new("TextButton")
    dropdownBtn.Size = UDim2.new(1, -30, 0, 35)
    dropdownBtn.Position = UDim2.new(0, 15, 0, 30)
    dropdownBtn.BackgroundColor3 = Color3.fromRGB(20, 20, 20)
    dropdownBtn.Text = settings[setting]
    dropdownBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
    dropdownBtn.TextScaled = true
    dropdownBtn.Font = Enum.Font.SourceSansBold
    dropdownBtn.Parent = frame
    
    local btnCorner = Instance.new("UICorner")
    btnCorner.CornerRadius = UDim.new(0, 8)
    btnCorner.Parent = dropdownBtn
    
    local expanded = false
    local dropdownItems = {}
    
    dropdownBtn.MouseButton1Click:Connect(function()
        expanded = not expanded
        
        if expanded then
            frame.Size = UDim2.new(1, -20, 0, 70 + (#options * 45))
            
            for i, opt in ipairs(options) do
                local optBtn = Instance.new("TextButton")
                optBtn.Size = UDim2.new(1, -30, 0, 40)
                optBtn.Position = UDim2.new(0, 15, 0, 65 + ((i-1) * 45))
                optBtn.BackgroundColor3 = Color3.fromRGB(25, 25, 25)
                optBtn.Text = opt
                optBtn.TextColor3 = Color3.fromRGB(200, 200, 200)
                optBtn.TextScaled = true
                optBtn.Font = Enum.Font.SourceSans
                optBtn.Parent = frame
                
                local optCorner = Instance.new("UICorner")
                optCorner.CornerRadius = UDim.new(0, 8)
                optCorner.Parent = optBtn
                
                optBtn.MouseButton1Click:Connect(function()
                    settings[setting] = opt
                    dropdownBtn.Text = opt
                    expanded = false
                    frame.Size = UDim2.new(1, -20, 0, 70)
                    for _, btn in pairs(frame:GetChildren()) do
                        if btn:IsA("TextButton") and btn ~= dropdownBtn then
                            btn:Destroy()
                        end
                    end
                end)
                
                table.insert(dropdownItems, optBtn)
            end
        else
            frame.Size = UDim2.new(1, -20, 0, 70)
            for _, btn in pairs(dropdownItems) do
                btn:Destroy()
            end
            dropdownItems = {}
        end
    end)
    
    return 80
end

-- ========== СБОРКА ИНТЕРФЕЙСА ==========
local yPos = 10

-- Секция: Основное
yPos = yPos + createSection(scrollingFrame, "🎯 ОСНОВНЫЕ НАСТРОЙКИ", yPos)
yPos = yPos + createBigToggle(scrollingFrame, "Включить аимбот", yPos, "Enabled")
yPos = yPos + createBigToggle(scrollingFrame, "Мобильный режим (авто-цель)", yPos, "AimKeyMobile")

-- Секция: Проверки
yPos = yPos + createSection(scrollingFrame, "🛡️ ПРОВЕРКИ", yPos)
yPos = yPos + createBigToggle(scrollingFrame, "Не целиться в тиммейтов", yPos, "TeamCheck")
yPos = yPos + createBigToggle(scrollingFrame, "Проверка стен", yPos, "WallCheck")
yPos = yPos + createBigToggle(scrollingFrame, "Проверка видимости", yPos, "VisibleCheck")
yPos = yPos + createBigToggle(scrollingFrame, "Игнорировать друзей", yPos, "IgnoreFriends")

-- Секция: Настройки прицела
yPos = yPos + createSection(scrollingFrame, "⚙️ НАСТРОЙКИ ПРИЦЕЛА", yPos)
yPos = yPos + createSlider(scrollingFrame, "Плавность", yPos, "Smoothness", 1, 20)
yPos = yPos + createSlider(scrollingFrame, "Предсказание", yPos, "Prediction", 0, 1, "с")
yPos = yPos + createSlider(scrollingFrame, "Радиус FOV", yPos, "FOV", 30, 360, "°")
yPos = yPos + createDropdown(scrollingFrame, "Часть тела", yPos, "TargetPart", {"Head", "Torso", "HumanoidRootPart", "Random"})

-- Секция: Визуал
yPos = yPos + createSection(scrollingFrame, "👁️ ВИЗУАЛ", yPos)
yPos = yPos + createBigToggle(scrollingFrame, "Показывать FOV", yPos, "ShowFOV")
yPos = yPos + createBigToggle(scrollingFrame, "Линия до цели", yPos, "ShowTargetLine")
yPos = yPos + createBigToggle(scrollingFrame, "Инфо о цели", yPos, "ShowTargetInfo")

-- Секция: Экстра
yPos = yPos + createSection(scrollingFrame, "💥 ЭКСТРА ФИЧИ", yPos)
yPos = yPos + createBigToggle(scrollingFrame, "Авто-стрельба", yPos, "AutoShoot")
yPos = yPos + createBigToggle(scrollingFrame, "Триггер бот", yPos, "TriggerBot")
yPos = yPos + createBigToggle(scrollingFrame, "Эйршот (в воздухе)", yPos, "Airshot")
yPos = yPos + createBigToggle(scrollingFrame, "Нокбек (отдача)", yPos, "Knockback")

-- ========== МОБИЛЬНЫЕ СОВЕТЫ ==========

-- Добавляем панель с советами для мобилы
local tipsFrame = Instance.new("Frame")
tipsFrame.Size = UDim2.new(1, -20, 0, 60)
tipsFrame.Position = UDim2.new(0, 10, 0, yPos)
tipsFrame.BackgroundColor3 = Color3.fromRGB(255, 50, 50)
tipsFrame.BackgroundTransparency = 0.2
tipsFrame.Parent = scrollingFrame

local tipsCorner = Instance.new("UICorner")
tipsCorner.CornerRadius = UDim.new(0, 10)
tipsCorner.Parent = tipsFrame

local tipsText = Instance.new("TextLabel")
tipsText.Size = UDim2.new(1, -20, 1, -10)
tipsText.Position = UDim2.new(0, 10, 0, 5)
tipsText.BackgroundTransparency = 1
tipsText.Text = "📱 МОБИЛЬНЫЕ СОВЕТЫ:\n• Тапай по переключателям пальцем\n• Листай список вверх/вниз\n• Держи окно чтобы перетащить\n• Вводи значения в поля"
tipsText.TextColor3 = Color3.fromRGB(255, 255, 255)
tipsText.TextScaled = true
tipsText.Font = Enum.Font.SourceSansBold
tipsText.TextXAlignment = Enum.TextXAlignment.Left
tipsText.Parent = tipsFrame

-- ========== ОСНОВНАЯ ЛОГИКА ==========

-- Создание FOV круга
local fovCircle = Drawing.new("Circle")
fovCircle.Visible = false
fovCircle.Radius = settings.FOV
fovCircle.Thickness = 2
fovCircle.Color = settings.FOVColor
fovCircle.Position = Vector2.new(camera.ViewportSize.X / 2, camera.ViewportSize.Y / 2)
fovCircle.NumSides = 64
fovCircle.Filled = false

-- Линия до цели
local targetLine = Drawing.new("Line")
targetLine.Visible = false
targetLine.Thickness = 2
targetLine.Color = Color3.fromRGB(255, 50, 50)

-- Инфо о цели
local targetInfo = Drawing.new("Text")
targetInfo.Visible = false
targetInfo.Color = Color3.fromRGB(255, 255, 255)
targetInfo.Size = 18
targetInfo.Center = true
targetInfo.Outline = true

-- Функция получения ближайшей цели
function getClosestTarget()
    local closestTarget = nil
    local shortestDistance = settings.FOV
    local mousePos = Vector2.new(mouse.X, mouse.Y)
    
    -- Для мобилы используем центр экрана если включен мобильный режим
    if settings.AimKeyMobile then
        mousePos = Vector2.new(camera.ViewportSize.X / 2, camera.ViewportSize.Y / 2)
    end
    
    for _, target in pairs(game.Players:GetPlayers()) do
        if target ~= player and target.Character and target.Character:FindFirstChild("Humanoid") and target.Character.Humanoid.Health > 0 then
            
            -- Проверка на друзей
            if settings.IgnoreFriends and target:IsFriendsWith(player.UserId) then
                continue
            end
            
            -- Team check
            if settings.TeamCheck and target.Team == player.Team then
                continue
            end
            
            local targetPart
            if settings.TargetPart == "Random" then
                local parts = {"Head", "Torso", "HumanoidRootPart", "LeftArm", "RightArm"}
                targetPart = target.Character:FindFirstChild(parts[math.random(1, #parts)])
            else
                targetPart = target.Character:FindFirstChild(settings.TargetPart)
            end
            
            if not targetPart then
                targetPart = target.Character:FindFirstChild("Head")
            end
            
            if targetPart then
                local screenPos, onScreen = camera:WorldToScreenPoint(targetPart.Position)
                if onScreen then
                    local distance = (mousePos - Vector2.new(screenPos.X, screenPos.Y)).Magnitude
                    
                    if distance < shortestDistance then
                        -- Проверка видимости
                        if settings.VisibleCheck then
                            local ray = Ray.new(camera.CFrame.Position, (targetPart.Position - camera.CFrame.Position).Unit * 1000)
                            local hit, pos = game.Workspace:FindPartOnRay(ray, player.Character)
                            if hit and hit:IsDescendantOf(target.Character) then
                                closestTarget = {Part = targetPart, Player = target, ScreenPos = screenPos}
                                shortestDistance = distance
                            end
                        else
                            closestTarget = {Part = targetPart, Player = target, ScreenPos = screenPos}
                            shortestDistance = distance
                        end
                    end
                end
            end
        end
    end
    
    return closestTarget
end

-- Основной цикл
game:GetService("RunService").RenderStepped:Connect(function()
    -- Обновление FOV круга
    fovCircle.Radius = settings.FOV
    fovCircle.Visible = settings.ShowFOV
    fovCircle.Position = Vector2.new(camera.ViewportSize.X / 2, camera.ViewportSize.Y / 2)
    fovCircle.Color = settings.FOVColor
    
    if settings.Enabled then
        local targetData = getClosestTarget()
        
        if targetData then
            local target = targetData.Part
            local targetPos = target.Position
            
            -- Предсказание движения
            if settings.Prediction > 0 and target.Parent and target.Parent:FindFirstChild("HumanoidRootPart") then
                local velocity = target.Parent.HumanoidRootPart.Velocity
                targetPos = targetPos + velocity * settings.Prediction
            end
            
            -- Эйршот (целится в воздушные цели)
            if settings.Airshot and target.Parent and target.Parent:FindFirstChild("Humanoid") then
                local humanoid = target.Parent.Humanoid
                if humanoid.FloorMaterial == Enum.Material.Air then
                    -- Приоритет для воздушных целей
                    targetPos = targetPos + Vector3.new(0, 2, 0)
                end
            end
            
            -- Плавное наведение
            local targetCFrame = CFrame.new(camera.CFrame.Position, targetPos)
            camera.CFrame = camera.CFrame:Lerp(targetCFrame, 1 / settings.Smoothness)
            
            -- Линия до цели
            if settings.ShowTargetLine then
                targetLine.Visible = true
                targetLine.From = Vector2.new(camera.ViewportSize.X / 2, camera.ViewportSize.Y)
                targetLine.To = Vector2.new(targetData.ScreenPos.X, targetData.ScreenPos.Y)
            else
                targetLine.Visible = false
            end
            
            -- Инфо о цели
            if settings.ShowTargetInfo then
                targetInfo.Visible = true
                targetInfo.Position = Vector2.new(targetData.ScreenPos.X, targetData.ScreenPos.Y - 50)
                targetInfo.Text = targetData.Player.Name .. " [" .. math.floor(targetData.Player.Character.Humanoid.Health) .. "HP]"
            else
                targetInfo.Visible = false
            end
            
            -- Авто-стрельба
            if settings.AutoShoot then
                local tool = player.Character and player.Character:FindFirstChildOfClass("Tool")
                if tool and tool:FindFirstChild("RemoteFunction") then
                    tool:Activate()
                end
            end
            
            -- Триггер бот (стреляет когда цель близко)
            if settings.TriggerBot then
                local mousePos = Vector2.new(camera.ViewportSize.X / 2, camera.ViewportSize.Y / 2)
                local distToCenter = (mousePos - Vector2.new(targetData.ScreenPos.X, targetData.ScreenPos.Y)).Magnitude
                
                if distToCenter < 50 then
                    local tool = player.Character and player.Character:FindFirstChildOfClass("Tool")
                    if tool and tool:FindFirstChild("RemoteFunction") then
                        tool:Activate()
                    end
                end
            end
            
            -- Нокбек (отдача)
            if settings.Knockback and target.Parent and target.Parent:FindFirstChild("HumanoidRootPart") then
                local root = target.Parent.HumanoidRootPart
                local direction = (root.Position - camera.CFrame.Position).Unit
                root.Velocity = root.Velocity + direction * 50
            end
            
        else
            targetLine.Visible = false
            targetInfo.Visible = false
        end
    else
        targetLine.Visible = false
        targetInfo.Visible = false
    end
end)

-- Очистка при выгрузке
gui.Destroying:Connect(function()
    fovCircle:Remove()
    targetLine:Remove()
    targetInfo:Remove()
end)