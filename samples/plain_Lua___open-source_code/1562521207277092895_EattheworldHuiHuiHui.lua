--aislop warning, but i dont care about it 














-- Защита от дублирования интерфейса
if getgenv()._HUB_CLEAN_ACTIVE and type(getgenv()._HUB_CLEAN_ACTIVE.unload) == "function" then
    pcall(getgenv()._HUB_CLEAN_ACTIVE.unload)
    task.wait(0.15)
end

-- === СЕРВИСЫ И УТИЛИТЫ ===
local G = {
    Services = {
        Players = game:GetService("Players"),
        TweenService = game:GetService("TweenService"),
        UserInputService = game:GetService("UserInputService"),
        RunService = game:GetService("RunService"),
        Stats = game:GetService("Stats"),
        Workspace = game:GetService("Workspace"),
        ReplicatedStorage = game:GetService("ReplicatedStorage"),
        CoreGui = game:GetService("CoreGui")
    },
    Math = {
        v3 = Vector3.new,
        ud2 = UDim2.new,
        ud = UDim.new,
        c3 = Color3.fromRGB,
        cf = CFrame.new,
        tw = TweenInfo.new,
        rgb = Color3.fromRGB,
        clamp = math.clamp,
        floor = math.floor
    }
}

local player = G.Services.Players.LocalPlayer or G.Services.Players.PlayerAdded:Wait()
local Camera = G.Services.Workspace.CurrentCamera or G.Services.Workspace:FindFirstChildOfClass("Camera")
local isTouchDevice = G.Services.UserInputService.TouchEnabled

-- Хранилище состояний переключателей и игровых систем (Язык по умолчанию: English)
local states = {
    language = "English",
    menuKey = "F1",
    watermark = true,
    
    -- Игровые модули
    randomTPFarm = false,
    autoSell = true,
    flashVacuum = false,
    instantMagnet = false,
    playerESP = false,
    antiGiant = false,
    antiRagdoll = false,
    fly = false,
    noclip = false,
    infJump = false,
    autoRewards = false,
    
    -- Слайдеры и настройки
    flySpeed = 60,
    tpDelay = 0.05
}

local LOCALIZATION = {
    English = {
        -- Вкладки
        tabFarm = "FARM",
        tabMagnet = "MAGNET",
        tabVisuals = "VISUALS",
        tabCombat = "COMBAT",
        tabMovement = "MOVEMENT",
        tabRewards = "REWARDS",
        tabSettings = "SETTINGS",
        
        -- Уведомления
        titleAlert = "ALERT",
        titleWarning = "WARNING",
        titleSuccess = "SUCCESS",
        titleInfo = "NOTIFICATION",
        
        searchPlaceholder = "Search features...",
        tipToggle = "Tip: Press %s to Toggle Menu",
        
        -- Секции
        secFarm = "MAP AUTO-FARM",
        secSell = "AUTO-SELL CONTROLLER",
        secMagnet = "COLLECTION SYSTEMS",
        secVisuals = "RADAR & DETECTION",
        secCombat = "DEFENSE & COMBAT",
        secMove = "MOBILITY MODIFIERS",
        secRewards = "DAILY & TIMED GIFTS",
        secPrefs = "FRAMEWORK PREFERENCES",
        
        -- Функции: Фарм
        toggleRandomFarm = "Auto farm",
        toggleAutoSell = "Auto-Sell on Full Size",
        btnForceSell = "Force Sell Now",
        
        -- Функции: Магнит
        toggleFlashVacuum = "Tp to money",
        toggleInstantMagnet = "Money magnet",
        btnSweepOnce = "1-Click Full Sweep",
        
        -- Функции: Визуал
        togglePlayerESP = "Player Size Radar (ESP)",
        
        -- Функции: Бой
        toggleAntiRagdoll = "Anti-Ragdoll (No Fall)",
        toggleAntiGiant = "Auto-Dodge Giants",
        
        -- Функции: Движение
        toggleFly = "Flight Mode (Fly)",
        toggleNoclip = "Wall Noclip",
        toggleInfJump = "Infinite Jump",
        sliderFlySpeed = "Flight Speed",
        
        -- Функции: Награды
        toggleAutoRewards = "Auto-Claim Timed Rewards",
        btnClaimAllNow = "Claim All Ready Rewards",
        
        -- Модальные окна и настройки
        modalCloseTitle = "EXIT MENU",
        modalCloseDesc = "Are you sure you want to unload and close the interface?",
        modalBtnConfirm = "Exit",
        modalBtnCancel = "Cancel",
        
        langBtn = "Language: English",
        menuKeyBtn = "Menu Keybind: ",
        pressAnyKey = "Press any key...",
        btnViewChangelog = "📋 View Changelog",
        
        -- Внутриигровой статус
        statusSellSuccess = "Size sold successfully!",
        statusRewardsClaimed = "Rewards claimed!",
        espEdible = "EDIBLE",
        espDanger = "DANGER!"
    },
    Russian = {
        -- Вкладки
        tabFarm = "ФАРМ",
        tabMagnet = "МАГНИТ",
        tabVisuals = "ВИЗУАЛ",
        tabCombat = "БОЙ",
        tabMovement = "ДВИЖЕНИЕ",
        tabRewards = "НАГРАДЫ",
        tabSettings = "НАСТРОЙКИ",
        
        -- Уведомления
        titleAlert = "ТРЕВОГА",
        titleWarning = "ВНИМАНИЕ",
        titleSuccess = "УСПЕХ",
        titleInfo = "ИНФОРМАЦИЯ",
        
        searchPlaceholder = "Поиск функций...",
        tipToggle = "Подсказка: Нажми %s для меню",
        
        -- Секции
        secFarm = "АВТО-ФАРМ КАРТЫ",
        secSell = "УПРАВЛЕНИЕ ПРОДАЖЕЙ",
        secMagnet = "СИСТЕМЫ СБОРА",
        secVisuals = "РАДАР И ОБНАРУЖЕНИЕ",
        secCombat = "ЗАЩИТА И БОЙ",
        secMove = "МОДИФИКАТОРЫ ДВИЖЕНИЯ",
        secRewards = "ТАЙМЕРЫ И ПОДАРКИ",
        secPrefs = "НАСТРОЙКИ ИНТЕРФЕЙСА",
        
        -- Функции: Фарм
        toggleRandomFarm = "Авто фарм",
        toggleAutoSell = "Авто-Продажа при заполнении",
        btnForceSell = "Продать размер сейчас",
        
        -- Функции: Магнит
        toggleFlashVacuum = "Тп к деньгам",
        toggleInstantMagnet = "Магнит денег",
        btnSweepOnce = "Собрать все деньги за 1 раз",
        
        -- Функции: Визуал
        togglePlayerESP = "ESP Игроков (Радар веса)",
        
        -- Функции: Бой
        toggleAntiRagdoll = "Анти-Рэгдолл (Без падений)",
        toggleAntiGiant = "Авто-Уклонение от гигантов",
        
        -- Функции: Движение
        toggleFly = "Режим полета (Fly)",
        toggleNoclip = "Проход сквозь стены (Noclip)",
        toggleInfJump = "Бесконечный прыжок",
        sliderFlySpeed = "Скорость полета",
        
        -- Функции: Награды
        toggleAutoRewards = "Авто-Сбор наград таймера",
        btnClaimAllNow = "Забрать все готовые награды",
        
        -- Модальные окна и настройки
        modalCloseTitle = "ЗАКРЫТЬ МЕНЮ?",
        modalCloseDesc = "Вы уверены, что хотите полностью выгрузить и закрыть интерфейс?",
        modalBtnConfirm = "Выйти",
        modalBtnCancel = "Отмена",
        
        langBtn = "Язык: Русский",
        menuKeyBtn = "Клавиша Меню: ",
        pressAnyKey = "Нажмите клавишу...",
        btnViewChangelog = "📋 Посмотреть Ченджлог",
        
        -- Внутриигровой статус
        statusSellSuccess = "Размер успешно продан!",
        statusRewardsClaimed = "Награды собраны!",
        espEdible = "МОЖНО СЪЕСТЬ",
        espDanger = "ОПАСНОСТЬ!"
    }
}

local function getText(key)
    local lang = states.language or "English"
    return (LOCALIZATION[lang] and LOCALIZATION[lang][key]) or (LOCALIZATION.English and LOCALIZATION.English[key]) or key
end

-- ====================================================================
--                     ВНУТРИИГРОВОЙ ДВИЖОК И ХУКИ
-- ====================================================================
local Character = player.Character or player.CharacterAdded:Wait()
local Humanoid = Character:WaitForChild("Humanoid")
local HumanoidRootPart = Character:WaitForChild("HumanoidRootPart")

player.CharacterAdded:Connect(function(newChar)
    Character = newChar
    Humanoid = newChar:WaitForChild("Humanoid")
    HumanoidRootPart = newChar:WaitForChild("HumanoidRootPart")
end)

local function getCharEvents()
    local char = player.Character
    if not char then return nil end
    local ev = char:FindFirstChild("Events")
    if ev then
        return {
            Grab = ev:FindFirstChild("Grab"),
            Eat = ev:FindFirstChild("Eat"),
            Throw = ev:FindFirstChild("Throw"),
            Sell = ev:FindFirstChild("Sell"),
            ChunkLoaded = ev:FindFirstChild("ChunkLoaded")
        }
    end
    return nil
end

local isFullServerFlag = false
local function hookServerEatError()
    local char = player.Character
    if not char then return end
    local ev = char:FindFirstChild("Events")
    if ev and ev:FindFirstChild("Eat") then
        ev.Eat.OnClientEvent:Connect(function()
            isFullServerFlag = true
        end)
    end
end
hookServerEatError()
player.CharacterAdded:Connect(function()
    task.wait(1)
    hookServerEatError()
end)

local function isInventoryFull()
    if isFullServerFlag then
        return true
    end

    local playerGui = player:FindFirstChild("PlayerGui")
    local sellGui = playerGui and playerGui:FindFirstChild("ScreenGui") and playerGui.ScreenGui:FindFirstChild("Sell")
    if sellGui then
        local warn = sellGui:FindFirstChild("WarningText")
        if warn and warn.Visible and warn.TextTransparency < 0.5 then
            return true
        end

        local sellText = sellGui:FindFirstChild("SellText")
        if sellText and sellText.Visible then
            return true
        end

        local bar = sellGui:FindFirstChild("ProgressBar")
        if bar and bar.Size.X.Scale >= 0.98 then
            return true
        end
    end

    return false
end

local function executeSell()
    local events = getCharEvents()
    if events and events.Sell then
        events.Sell:FireServer()
    end

    local playerGui = player:FindFirstChild("PlayerGui")
    local sellGui = playerGui and playerGui:FindFirstChild("ScreenGui") and playerGui.ScreenGui:FindFirstChild("Sell")
    if sellGui then
        local btn = sellGui:FindFirstChild("SellButton")
        if btn and typeof(firesignal) == "function" then
            firesignal(btn.Activated)
            firesignal(btn.MouseButton1Click)
        end
    end

    isFullServerFlag = false
end

local GROUND_KEYWORDS = {
    "ground", "grass", "dirt", "soil", "sand", "floor", 
    "road", "path", "terrain", "base", "plate", "mud", "earth"
}

-- Только валидные системные материалы Roblox
local GROUND_MATERIALS = {
    [Enum.Material.Grass] = true,
    [Enum.Material.Ground] = true,
    [Enum.Material.Mud] = true,
    [Enum.Material.Sand] = true,
    [Enum.Material.LeafyGrass] = true,
    [Enum.Material.Cobblestone] = true,
    [Enum.Material.Asphalt] = true,
    [Enum.Material.Slate] = true
}

local function isGroundPart(part)
    if not part or not part:IsA("BasePart") then return false end
    
    -- 1. Проверка по валидному материалу
    if part.Material and GROUND_MATERIALS[part.Material] then
        return true
    end

    -- 2. Проверка по названию (любые объекты со словом "dirt", "grass", "ground" и т.д.)
    local lowerName = string.lower(part.Name)
    for _, keyword in ipairs(GROUND_KEYWORDS) do
        if string.find(lowerName, keyword) then
            return true
        end
    end

    -- 3. Проверка плоских горизонтальных плит
    if part.Size.Y <= 5 and (part.Size.X >= 8 or part.Size.Z >= 8) then
        return true
    end

    return false
end

local function getRandomEdiblePart()
    local map = Workspace:FindFirstChild("Map")
    if not map then return nil end

    local allDescendants = map:GetDescendants()
    if #allDescendants == 0 then return nil end

    -- Считываем текущий размер (из Character или leaderstats)
    local char = player.Character
    local rawSize = char and char:FindFirstChild("Size") and char.Size.Value or 1
    local leaderSize = player:FindFirstChild("leaderstats") and player.leaderstats:FindFirstChild("Size") and player.leaderstats.Size.Value or rawSize
    local currentSize = math.max(rawSize, leaderSize)

    -- Если размер меньше 400 — берем СТРОГО землю
    local prioritizeGround = (currentSize < 400)
    local fallbackPart = nil

    -- 1. Быстрый случайный поиск (O(1) оптимизация для мобилок)
    for _ = 1, 40 do
        local randomObj = allDescendants[math.random(1, #allDescendants)]
        if randomObj:IsA("BasePart") 
            and randomObj.Name ~= "Bedrock" 
            and randomObj.Name ~= "Barrier" 
            and randomObj.CanCollide 
            and randomObj.Transparency < 0.8 
            and randomObj.Size.Magnitude > 2.5 
            and randomObj.Position.Y > 0 then
            
            if prioritizeGround then
                if isGroundPart(randomObj) then
                    return randomObj, true -- Нашли землю!
                elseif not fallbackPart then
                    fallbackPart = randomObj -- Запасной вариант
                end
            else
                -- После 400 размера едим всё подряд (дома, стены, заборы)
                return randomObj, false
            end
        end
    end

    -- 2. Если за 40 случайных попыток земля не выпала, ищем ближайший блок земли
    if prioritizeGround then
        for _, obj in ipairs(allDescendants) do
            if obj:IsA("BasePart") 
                and obj.Name ~= "Bedrock" 
                and obj.Name ~= "Barrier" 
                and obj.CanCollide 
                and obj.Transparency < 0.8 
                and obj.Position.Y > 0 
                and isGroundPart(obj) then
                return obj, true
            end
        end
    end

    return fallbackPart, false
end

local VALID_DROPS = {
    ["Cube"] = true,
    ["Token"] = true,
    ["Candy"] = true,
    ["Present"] = true,
    ["Ornament"] = true,
    ["Egg"] = true
}

local function canCollect(item)
    if not item or not item:IsA("BasePart") or not item.Parent then return false end
    if not VALID_DROPS[item.Name] then return false end

    local owner = item:FindFirstChild("Owner")
    local timeLeft = item:FindFirstChild("TimeLeft")

    if owner and owner.Value ~= "" and owner.Value ~= player.Name then
        if timeLeft and timeLeft.Value > 0 then
            return false
        end
    end

    return true
end

local function getPrioritizedDrops()
    local drops = {}
    local myPos = HumanoidRootPart.Position

    for _, obj in ipairs(G.Services.Workspace:GetChildren()) do
        if canCollect(obj) then
            local dist = (obj.Position - myPos).Magnitude
            local timeLeftVal = obj:FindFirstChild("TimeLeft") and obj.TimeLeft.Value or 15
            table.insert(drops, {
                Part = obj,
                Dist = dist,
                TimeLeft = timeLeftVal
            })
        end
    end

    table.sort(drops, function(a, b)
        if a.TimeLeft <= 4 and b.TimeLeft > 4 then
            return true
        elseif b.TimeLeft <= 4 and a.TimeLeft > 4 then
            return false
        end
        return a.Dist < b.Dist
    end)

    return drops
end

local function claimTimedRewards()
    local playerGui = player:FindFirstChild("PlayerGui")
    local rewardsGui = playerGui and playerGui:FindFirstChild("ScreenGui") and playerGui.ScreenGui:FindFirstChild("Rewards")
    if rewardsGui then
        local grid = rewardsGui:FindFirstChild("TimedRewards") and rewardsGui.TimedRewards:FindFirstChild("RewardGrid")
        if grid then
            for _, btn in ipairs(grid:GetChildren()) do
                if btn:IsA("ImageButton") or btn:IsA("TextButton") then
                    local timeLbl = btn:FindFirstChild("Time") or btn:FindFirstChildWhichIsA("TextLabel")
                    if timeLbl then
                        local txt = string.upper(timeLbl.Text)
                        if txt == "CLAIM" or txt == "00:00" or txt == "0:00" or not string.find(txt, ":") then
                            if typeof(firesignal) == "function" then
                                firesignal(btn.Activated)
                                firesignal(btn.MouseButton1Click)
                            end
                        end
                    end
                end
            end
        end
    end

    local timedFolder = player:FindFirstChild("TimedRewards")
    local rewardRemote = G.Services.ReplicatedStorage:FindFirstChild("Events") and G.Services.ReplicatedStorage.Events:FindFirstChild("RewardEvent")
    if timedFolder and rewardRemote then
        local now = os.time()
        for idx, val in ipairs(timedFolder:GetChildren()) do
            if (val:IsA("IntValue") or val:IsA("NumberValue")) and now >= val.Value then
                rewardRemote:FireServer(idx)
                rewardRemote:FireServer(val.Name)
            end
        end
    end

    local spinRemote = G.Services.ReplicatedStorage:FindFirstChild("Events") and G.Services.ReplicatedStorage.Events:FindFirstChild("SpinEvent")
    if spinRemote then
        spinRemote:FireServer()
    end
end

-- ====================================================================
--                     ВЫПОЛНЕНИЕ UI ЭЛЕМЕНТОВ
-- ====================================================================
local function create(className, properties, children)
    local obj = Instance.new(className)
    for k, v in pairs(properties or {}) do obj[k] = v end
    if children then for _, child in ipairs(children) do child.Parent = obj end end
    return obj
end

local function cCorner(r, p) return create("UICorner", {CornerRadius = G.Math.ud(0, r or 8), Parent = p}) end
local function cStroke(c, t, p) return create("UIStroke", {Color = c or G.Math.rgb(55, 55, 65), Thickness = t or 1, Parent = p}) end
local function cTextConstraint(minS, maxS, p)
    return create("UITextSizeConstraint", {
        MinTextSize = minS or 8,
        MaxTextSize = maxS or 11,
        Parent = p
    })
end

local function getGuiParent()
    local s, h = pcall(function() return gethui and gethui() end)
    if s and h then return h end
    local s2, cg = pcall(function() return game:GetService("CoreGui") end)
    if s2 and cg and pcall(function() local t = Instance.new("Folder", cg) t:Destroy() end) then
        return cg
    end
    return player:WaitForChild("PlayerGui", 10) or player:FindFirstChild("PlayerGui")
end

pcall(function()
    local p = getGuiParent()
    if p then
        local old = p:FindFirstChild("CleanHub_BW_Main")
        if old then old:Destroy() end
        local oldNotif = p:FindFirstChild("CleanHub_Notifications")
        if oldNotif then oldNotif:Destroy() end
    end
end)

local function setSmartFade(targetFrame, isFading)
    if not targetFrame then return end
    local tweenInfo = G.Math.tw(0.15, Enum.EasingStyle.Quad, Enum.EasingDirection.Out)
    local fadeDelta = isFading and 0.20 or 0

    pcall(function()
        if isFading then
            if targetFrame:GetAttribute("BaseBgTrans") == nil then
                targetFrame:SetAttribute("BaseBgTrans", targetFrame.BackgroundTransparency)
            end
            G.Services.TweenService:Create(targetFrame, tweenInfo, {BackgroundTransparency = 0.20}):Play()
        else
            local base = targetFrame:GetAttribute("BaseBgTrans") or 0
            G.Services.TweenService:Create(targetFrame, tweenInfo, {BackgroundTransparency = base}):Play()
            targetFrame:SetAttribute("BaseBgTrans", nil)
        end
    end)

    for _, obj in ipairs(targetFrame:GetDescendants()) do
        pcall(function()
            if obj:IsA("GuiObject") then
                if isFading then
                    if obj:GetAttribute("BaseBgTrans") == nil then
                        obj:SetAttribute("BaseBgTrans", obj.BackgroundTransparency)
                    end
                    local baseBg = obj:GetAttribute("BaseBgTrans")
                    if baseBg < 0.95 then
                        local targetVal = G.Math.clamp(baseBg + fadeDelta, 0, 1)
                        G.Services.TweenService:Create(obj, tweenInfo, {BackgroundTransparency = targetVal}):Play()
                    end
                else
                    local baseBg = obj:GetAttribute("BaseBgTrans")
                    if baseBg ~= nil then
                        G.Services.TweenService:Create(obj, tweenInfo, {BackgroundTransparency = baseBg}):Play()
                        obj:SetAttribute("BaseBgTrans", nil)
                    end
                end
            end

            if obj:IsA("TextLabel") or obj:IsA("TextButton") or obj:IsA("TextBox") then
                if isFading then
                    if obj:GetAttribute("BaseTxtTrans") == nil then
                        obj:SetAttribute("BaseTxtTrans", obj.TextTransparency)
                    end
                    local baseTxt = obj:GetAttribute("BaseTxtTrans")
                    if baseTxt < 0.95 then
                        local targetVal = G.Math.clamp(baseTxt + fadeDelta, 0, 1)
                        G.Services.TweenService:Create(obj, tweenInfo, {TextTransparency = targetVal}):Play()
                    end
                else
                    local baseTxt = obj:GetAttribute("BaseTxtTrans")
                    if baseTxt ~= nil then
                        G.Services.TweenService:Create(obj, tweenInfo, {TextTransparency = baseTxt}):Play()
                        obj:SetAttribute("BaseTxtTrans", nil)
                    end
                end
            end

            if obj:IsA("ImageLabel") or obj:IsA("ImageButton") then
                if isFading then
                    if obj:GetAttribute("BaseImgTrans") == nil then
                        obj:SetAttribute("BaseImgTrans", obj.ImageTransparency)
                    end
                    local baseImg = obj:GetAttribute("BaseImgTrans")
                    if baseImg < 0.95 then
                        local targetVal = G.Math.clamp(baseImg + fadeDelta, 0, 1)
                        G.Services.TweenService:Create(obj, tweenInfo, {ImageTransparency = targetVal}):Play()
                    end
                else
                    local baseImg = obj:GetAttribute("BaseImgTrans")
                    if baseImg ~= nil then
                        G.Services.TweenService:Create(obj, tweenInfo, {ImageTransparency = baseImg}):Play()
                        obj:SetAttribute("BaseImgTrans", nil)
                    end
                end
            end

            if obj:IsA("UIStroke") then
                if isFading then
                    if obj:GetAttribute("BaseStrokeTrans") == nil then
                        obj:SetAttribute("BaseStrokeTrans", obj.Transparency)
                    end
                    local baseStroke = obj:GetAttribute("BaseStrokeTrans")
                    if baseStroke < 0.95 then
                        local targetVal = G.Math.clamp(baseStroke + fadeDelta, 0, 1)
                        G.Services.TweenService:Create(obj, tweenInfo, {Transparency = targetVal}):Play()
                    end
                else
                    local baseStroke = obj:GetAttribute("BaseStrokeTrans")
                    if baseStroke ~= nil then
                        G.Services.TweenService:Create(obj, tweenInfo, {Transparency = baseStroke}):Play()
                        obj:SetAttribute("BaseStrokeTrans", nil)
                    end
                end
            end
        end)
    end
end

local function makeDraggable(gui, target)
    target = target or gui
    local dragging, dragInput, dragStart, startPos
    
    gui.InputBegan:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
            dragging = true
            dragStart = input.Position
            startPos = target.Position
            setSmartFade(target, true)
        end
    end)
    
    G.Services.UserInputService.InputEnded:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
            if dragging then
                dragging = false
                setSmartFade(target, false)
            end
        end 
    end)
    
    gui.InputChanged:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch then
            dragInput = input
        end
    end)
    
    G.Services.UserInputService.InputChanged:Connect(function(input)
        if dragging and input == dragInput then
            local delta = input.Position - dragStart
            target.Position = G.Math.ud2(startPos.X.Scale, startPos.X.Offset + delta.X, startPos.Y.Scale, startPos.Y.Offset + delta.Y)
        end
    end)
end

-- ====================================================================
--                  СИСТЕМА УВЕДОМЛЕНИЙ (TOASTS)
-- ====================================================================
local NotificationGui = create("ScreenGui", {
    Name = "CleanHub_Notifications",
    ResetOnSpawn = false,
    IgnoreGuiInset = true,
    Parent = getGuiParent()
})

local NOTIFY_COLORS = {
    Info = G.Math.rgb(240, 240, 250),
    Success = G.Math.rgb(255, 255, 255),
    Warning = G.Math.rgb(220, 220, 230),
    Error = G.Math.rgb(255, 75, 75),
    Background = G.Math.rgb(18, 18, 22),
    Stroke = G.Math.rgb(50, 50, 60)
}

local activeToastList = {}
local function getToastResponsiveConfig()
    local cam = G.Services.Workspace.CurrentCamera or Camera
    local vp = (cam and cam.ViewportSize) or Vector2.new(1280, 720)
    local isSmall = vp.X < 750 or isTouchDevice
    local cardWidth = isSmall and G.Math.clamp(G.Math.floor(vp.X * 0.42), 200, 250) or 290
    local cardHeight = isSmall and 48 or 56

    return {
        CARD_WIDTH = cardWidth,
        CARD_HEIGHT = cardHeight,
        PADDING = isSmall and 6 or 8,
        OFFSET_X = isSmall and 10 or 20,
        OFFSET_Y = isSmall and 12 or 22,
        ANIM_TIME = 0.3,
        TITLE_SIZE = isSmall and 11 or 12,
        DESC_SIZE = isSmall and 9 or 11,
        BAR_WIDTH = 3,
        MAX_STACK = 4,
        isSmall = isSmall
    }
end

local function repositionToasts()
    local cfg = getToastResponsiveConfig()
    for i, data in ipairs(activeToastList) do
        local targetY = cfg.OFFSET_Y + (i - 1) * (cfg.CARD_HEIGHT + cfg.PADDING)
        local targetPos = G.Math.ud2(1, -(cfg.CARD_WIDTH + cfg.OFFSET_X), 0, targetY)
        G.Services.TweenService:Create(data.frame, G.Math.tw(0.24, Enum.EasingStyle.Quart, Enum.EasingDirection.Out), {
            Position = targetPos
        }):Play()
    end
end

local function showNotification(message, nType, title, duration)
    if not message or message == "" then return end
    duration = duration or 3.0
    nType = nType or "Info"
    local accentColor = NOTIFY_COLORS[nType] or NOTIFY_COLORS.Info
    local cfg = getToastResponsiveConfig()

    if not title then
        if nType == "Error" then title = getText("titleAlert")
        elseif nType == "Warning" then title = getText("titleWarning")
        elseif nType == "Success" then title = getText("titleSuccess")
        else title = getText("titleInfo") end
    end

    if #activeToastList >= cfg.MAX_STACK then
        local oldest = activeToastList[1]
        if oldest and oldest.dismiss then oldest.dismiss() end
    end

    local nextIndex = #activeToastList + 1
    local spawnY = cfg.OFFSET_Y + (nextIndex - 1) * (cfg.CARD_HEIGHT + cfg.PADDING)
    local startPos = G.Math.ud2(1, 40, 0, spawnY)
    local finalPos = G.Math.ud2(1, -(cfg.CARD_WIDTH + cfg.OFFSET_X), 0, spawnY)

    local frame = create("Frame", {
        Name = "Toast_" .. tick(),
        Size = G.Math.ud2(0, cfg.CARD_WIDTH, 0, cfg.CARD_HEIGHT),
        Position = startPos,
        BackgroundColor3 = NOTIFY_COLORS.Background,
        BackgroundTransparency = 0.05,
        BorderSizePixel = 0,
        ClipsDescendants = true,
        Parent = NotificationGui
    }, {
        cCorner(8),
        create("UIStroke", {Color = NOTIFY_COLORS.Stroke, Thickness = 1}),
        create("Frame", {
            Name = "Accent",
            Size = G.Math.ud2(0, cfg.BAR_WIDTH, 1, 0),
            BackgroundColor3 = accentColor,
            BorderSizePixel = 0
        }),
        create("TextLabel", {
            Name = "Title",
            Size = G.Math.ud2(1, -18, 0, cfg.isSmall and 14 or 18),
            Position = G.Math.ud2(0, 12, 0, 4),
            BackgroundTransparency = 1,
            Text = tostring(title),
            TextColor3 = accentColor,
            Font = Enum.Font.GothamBold,
            TextSize = cfg.TITLE_SIZE,
            TextXAlignment = Enum.TextXAlignment.Left
        }),
        create("TextLabel", {
            Name = "Desc",
            Size = G.Math.ud2(1, -18, 0, cfg.isSmall and 24 or 28),
            Position = G.Math.ud2(0, 12, 0, 20),
            BackgroundTransparency = 1,
            Text = tostring(message),
            TextColor3 = G.Math.rgb(215, 215, 225),
            Font = Enum.Font.GothamMedium,
            TextSize = cfg.DESC_SIZE,
            TextWrapped = true,
            TextXAlignment = Enum.TextXAlignment.Left
        }),
        create("Frame", {
            Name = "TimerBar",
            Size = G.Math.ud2(1, 0, 0, 2),
            Position = G.Math.ud2(0, 0, 1, -2),
            BackgroundColor3 = accentColor,
            BorderSizePixel = 0
        })
    })

    local isDismissed = false
    local notifyData = { frame = frame }

    local function dismissToast()
        if isDismissed then return end
        isDismissed = true

        local exitTween = G.Services.TweenService:Create(frame, G.Math.tw(0.22, Enum.EasingStyle.Quart, Enum.EasingDirection.In), {
            Position = G.Math.ud2(1, 40, 0, frame.Position.Y.Offset),
            BackgroundTransparency = 1
        })
        exitTween:Play()
        exitTween.Completed:Wait()

        for i, item in ipairs(activeToastList) do
            if item == notifyData then
                table.remove(activeToastList, i)
                break
            end
        end

        frame:Destroy()
        repositionToasts()
    end

    notifyData.dismiss = dismissToast
    activeToastList[#activeToastList + 1] = notifyData

    G.Services.TweenService:Create(frame, G.Math.tw(cfg.ANIM_TIME, Enum.EasingStyle.Quart, Enum.EasingDirection.Out), {
        Position = finalPos
    }):Play()

    local tBar = frame:FindFirstChild("TimerBar")
    if tBar then
        G.Services.TweenService:Create(tBar, G.Math.tw(duration, Enum.EasingStyle.Linear), {
            Size = G.Math.ud2(0, 0, 0, 2)
        }):Play()
    end

    task.delay(duration, dismissToast)
end
-- ====================================================================
--                  ОСНОВНОЙ КОМПОНЕНТ ИНТЕРФЕЙСА
-- ====================================================================
local function BuildHubUI()
    local S = {
        Runtime = { running = true, connections = {} },
        Pages = {},
        TabBtns = {},
        currentActiveTabBtn = nil,
        registeredSearchElements = {},
        registeredRows = {},
        localizedLabels = {},
        UI_STORAGE = {}
    }

    S.ScreenGui = create("ScreenGui", {
        Name = "CleanHub_BW_Main",
        Parent = getGuiParent(),
        ResetOnSpawn = false,
        IgnoreGuiInset = true
    })

    local vp = Camera.ViewportSize
    local initialWidth = G.Math.clamp(vp.X * 0.48, 480, 640)
    local initialHeight = G.Math.clamp(vp.Y * 0.58, 330, 440)

    S.MainFrame = create("Frame", {
        Name = "MainFrame",
        Size = G.Math.ud2(0, initialWidth, 0, initialHeight),
        Position = G.Math.ud2(0.5, 0, 0.5, 0),
        AnchorPoint = Vector2.new(0.5, 0.5),
        BackgroundColor3 = G.Math.rgb(14, 14, 18),
        Active = true,
        ClipsDescendants = true,
        Parent = S.ScreenGui
    }, {
        cCorner(14),
        cStroke(G.Math.rgb(50, 50, 60), 1.5),
        create("UISizeConstraint", {MinSize = Vector2.new(450, 300), MaxSize = Vector2.new(900, 650)})
    })

    S.MainScale = create("UIScale", {Scale = 1, Parent = S.MainFrame})

    S.TopBar = create("Frame", {
        Name = "TopBar",
        Size = G.Math.ud2(1, 0, 0, 42),
        BackgroundTransparency = 1,
        ClipsDescendants = true,
        Parent = S.MainFrame
    }, {
        create("TextLabel", {
            Size = G.Math.ud2(0, 260, 1, 0),
            Position = G.Math.ud2(0, 15, 0, 0),
            BackgroundTransparency = 1,
            Text = "HUBHUBHUB :P",
            TextColor3 = G.Math.rgb(255, 255, 255),
            Font = Enum.Font.GothamBlack,
            TextSize = 13,
            TextXAlignment = Enum.TextXAlignment.Left
        })
    })
    makeDraggable(S.TopBar, S.MainFrame)

    S.closeBtn = create("TextButton", {
        Name = "CloseBtn",
        Size = G.Math.ud2(0, 28, 0, 28),
        Position = G.Math.ud2(1, -36, 0.5, -14),
        BackgroundColor3 = G.Math.rgb(24, 24, 30),
        Text = "X",
        TextColor3 = G.Math.rgb(200, 200, 210),
        Font = Enum.Font.GothamBold,
        TextSize = 12,
        AutoButtonColor = false,
        Parent = S.TopBar
    }, { cCorner(7), cStroke(G.Math.rgb(45, 45, 55), 1) })

    S.minBtn = create("TextButton", {
        Name = "MinBtn",
        Size = G.Math.ud2(0, 28, 0, 28),
        Position = G.Math.ud2(1, -70, 0.5, -14),
        BackgroundColor3 = G.Math.rgb(24, 24, 30),
        Text = "—",
        TextColor3 = G.Math.rgb(200, 200, 210),
        Font = Enum.Font.GothamBold,
        TextSize = 12,
        AutoButtonColor = false,
        Parent = S.TopBar
    }, { cCorner(7), cStroke(G.Math.rgb(45, 45, 55), 1) })

    S.closeBtn.MouseEnter:Connect(function()
        G.Services.TweenService:Create(S.closeBtn, G.Math.tw(0.15), {BackgroundColor3 = G.Math.rgb(200, 45, 45), TextColor3 = G.Math.rgb(255, 255, 255)}):Play()
    end)
    S.closeBtn.MouseLeave:Connect(function()
        G.Services.TweenService:Create(S.closeBtn, G.Math.tw(0.15), {BackgroundColor3 = G.Math.rgb(24, 24, 30), TextColor3 = G.Math.rgb(200, 200, 210)}):Play()
    end)

    S.minBtn.MouseEnter:Connect(function()
        G.Services.TweenService:Create(S.minBtn, G.Math.tw(0.15), {BackgroundColor3 = G.Math.rgb(45, 45, 55), TextColor3 = G.Math.rgb(255, 255, 255)}):Play()
    end)
    S.minBtn.MouseLeave:Connect(function()
        G.Services.TweenService:Create(S.minBtn, G.Math.tw(0.15), {BackgroundColor3 = G.Math.rgb(24, 24, 30), TextColor3 = G.Math.rgb(200, 200, 210)}):Play()
    end)

    S.ResizeGrip = create("ImageButton", {
        Name = "ResizeCorner",
        Size = G.Math.ud2(0, 20, 0, 20),
        Position = G.Math.ud2(1, 0, 1, 0),
        AnchorPoint = Vector2.new(1, 1),
        BackgroundTransparency = 1,
        Image = "rbxassetid://5854832560",
        ImageColor3 = G.Math.rgb(140, 140, 150),
        ImageTransparency = 0.4,
        ZIndex = 25,
        Parent = S.MainFrame
    })

    local isResizing = false
    local resizeStartPos = Vector2.new(0, 0)
    local resizeStartSize = Vector2.new(S.MainFrame.AbsoluteSize.X, S.MainFrame.AbsoluteSize.Y)

    S.ResizeGrip.InputBegan:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
            isResizing = true
            resizeStartPos = Vector2.new(input.Position.X, input.Position.Y)
            resizeStartSize = Vector2.new(S.MainFrame.AbsoluteSize.X, S.MainFrame.AbsoluteSize.Y)
            G.Services.TweenService:Create(S.ResizeGrip, G.Math.tw(0.1), {ImageColor3 = G.Math.rgb(255, 255, 255), ImageTransparency = 0}):Play()
        end
    end)

    S.Runtime.connections[#S.Runtime.connections + 1] = G.Services.UserInputService.InputChanged:Connect(function(input)
        if isResizing and (input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch) then
            local delta = Vector2.new(input.Position.X, input.Position.Y) - resizeStartPos
            S.MainFrame.Size = G.Math.ud2(0, G.Math.clamp(resizeStartSize.X + delta.X, 450, 900), 0, G.Math.clamp(resizeStartSize.Y + delta.Y, 300, 650))
        end
    end)

    S.Runtime.connections[#S.Runtime.connections + 1] = G.Services.UserInputService.InputEnded:Connect(function(input)
        if (input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch) and isResizing then
            isResizing = false
            G.Services.TweenService:Create(S.ResizeGrip, G.Math.tw(0.2), {ImageColor3 = G.Math.rgb(140, 140, 150), ImageTransparency = 0.4}):Play()
        end
    end)

    S.Sidebar = create("Frame", {
        Name = "Sidebar",
        Size = G.Math.ud2(0, 130, 1, -42),
        Position = G.Math.ud2(0, 0, 0, 42),
        BackgroundColor3 = G.Math.rgb(20, 20, 24),
        BorderSizePixel = 0,
        ZIndex = 5,
        Parent = S.MainFrame
    }, {
        cCorner(14),
        create("Frame", {Name = "TopPatch", Size = G.Math.ud2(1, 0, 0, 16), Position = G.Math.ud2(0, 0, 0, 0), BackgroundColor3 = G.Math.rgb(20, 20, 24), BorderSizePixel = 0}),
        create("Frame", {Name = "RightPatch", Size = G.Math.ud2(0, 16, 1, 0), Position = G.Math.ud2(1, -16, 0, 0), BackgroundColor3 = G.Math.rgb(20, 20, 24), BorderSizePixel = 0})
    })

    S.SidebarContent = create("Frame", {
        Name = "ButtonContainer",
        Size = G.Math.ud2(1, 0, 1, 0),
        BackgroundTransparency = 1,
        ZIndex = 6,
        Parent = S.Sidebar
    }, {
        create("UIPadding", {PaddingTop = G.Math.ud(0, 8)}),
        create("UIListLayout", {SortOrder = Enum.SortOrder.LayoutOrder, Padding = G.Math.ud(0, 5), HorizontalAlignment = Enum.HorizontalAlignment.Center})
    })

    S.ContentBackdrop = create("Frame", {
        Name = "ContentBackdrop",
        Size = G.Math.ud2(1, -130, 1, -42),
        Position = G.Math.ud2(0, 130, 0, 42),
        BackgroundColor3 = G.Math.rgb(16, 16, 20),
        BorderSizePixel = 0,
        ZIndex = 4,
        Parent = S.MainFrame
    }, { cCorner(14) })

    S.Content = create("Frame", {
        Name = "Content",
        Size = G.Math.ud2(1, -130, 1, -42),
        Position = G.Math.ud2(0, 130, 0, 42),
        BackgroundTransparency = 1,
        ZIndex = 5,
        Parent = S.MainFrame
    })

    S.SearchContainer = create("Frame", {
        Name = "SearchBarFrame",
        Size = G.Math.ud2(1, -20, 0, 32),
        Position = G.Math.ud2(0, 10, 0, 6),
        BackgroundColor3 = G.Math.rgb(22, 22, 28),
        ZIndex = 6,
        Parent = S.Content
    }, {
        cCorner(6),
        cStroke(G.Math.rgb(40, 40, 50), 1),
        create("ImageLabel", {
            Size = G.Math.ud2(0, 14, 0, 14),
            Position = G.Math.ud2(0, 9, 0.5, -7),
            BackgroundTransparency = 1,
            Image = "rbxassetid://3926305904",
            ImageRectOffset = Vector2.new(964, 324),
            ImageRectSize = Vector2.new(36, 36),
            ImageColor3 = G.Math.rgb(140, 140, 155)
        })
    })

    S.SearchBox = create("TextBox", {
        Size = G.Math.ud2(1, -56, 1, 0),
        Position = G.Math.ud2(0, 30, 0, 0),
        BackgroundTransparency = 1,
        PlaceholderText = getText("searchPlaceholder"),
        Text = "",
        TextColor3 = G.Math.rgb(240, 240, 250),
        PlaceholderColor3 = G.Math.rgb(120, 120, 135),
        Font = Enum.Font.GothamMedium,
        TextSize = 11,
        TextXAlignment = Enum.TextXAlignment.Left,
        ClearTextOnFocus = false,
        ZIndex = 7,
        Parent = S.SearchContainer
    })

    S.SearchClearBtn = create("TextButton", {
        Name = "ClearSearchBtn",
        Size = G.Math.ud2(0, 22, 0, 22),
        Position = G.Math.ud2(1, -26, 0.5, -11),
        BackgroundColor3 = G.Math.rgb(32, 32, 40),
        Text = "✖",
        TextColor3 = G.Math.rgb(160, 160, 175),
        Font = Enum.Font.GothamBold,
        TextSize = 10,
        Visible = false,
        AutoButtonColor = false,
        ZIndex = 8,
        Parent = S.SearchContainer
    }, { cCorner(11) })

    S.SearchClearBtn.MouseButton1Click:Connect(function()
        S.SearchBox.Text = ""
        S.SearchClearBtn.Visible = false
        S.applySearchFilter("")
    end)

    S.MiniButton = create("TextButton", {
        Size = G.Math.ud2(0, 48, 0, 48),
        Position = G.Math.ud2(0, 20, 0.5, -24),
        BackgroundColor3 = G.Math.rgb(18, 18, 24),
        Text = "",
        Visible = false,
        Parent = S.ScreenGui
    }, {
        cCorner(12),
        cStroke(G.Math.rgb(70, 70, 85), 1.5),
        create("ImageLabel", {
            Size = G.Math.ud2(1, -14, 1, -14),
            Position = G.Math.ud2(0, 7, 0, 7),
            BackgroundTransparency = 1,
            Image = "rbxassetid://7059346373",
            ImageColor3 = G.Math.rgb(240, 240, 245),
            ScaleType = Enum.ScaleType.Fit
        })
    })
    makeDraggable(S.MiniButton)

    S.wmFrame = create("Frame", {
        Name = "Watermark",
        Size = G.Math.ud2(0, 260, 0, 28),
        Position = G.Math.ud2(0.5, -130, 0, 10),
        BackgroundColor3 = G.Math.rgb(14, 14, 18),
        BackgroundTransparency = 0.15,
        Visible = states.watermark,
        Parent = S.ScreenGui
    }, {
        cCorner(8),
        cStroke(G.Math.rgb(60, 60, 75), 1.2),
        create("TextLabel", {
            Name = "StatsTxt",
            Size = G.Math.ud2(1, 0, 1, 0),
            BackgroundTransparency = 1,
            Text = "HUB  |  FPS: 60  |  Ping: 0ms",
            TextColor3 = G.Math.rgb(240, 240, 245),
            Font = Enum.Font.GothamBold,
            TextSize = 11
        })
    })
    makeDraggable(S.wmFrame)

    S.ModalOverlay = create("Frame", {
        Name = "ModalOverlay",
        Size = G.Math.ud2(1, 0, 1, 0),
        BackgroundColor3 = G.Math.rgb(0, 0, 0),
        BackgroundTransparency = 1,
        Visible = false,
        ZIndex = 50,
        Parent = S.MainFrame
    }, { cCorner(14) })

    S.ModalCard = create("Frame", {
        Name = "ModalCard",
        Size = G.Math.ud2(0, 290, 0, 145),
        Position = G.Math.ud2(0.5, 0, 0.5, 0),
        AnchorPoint = Vector2.new(0.5, 0.5),
        BackgroundColor3 = G.Math.rgb(20, 20, 26),
        ZIndex = 51,
        Parent = S.ModalOverlay
    }, {
        cCorner(10),
        cStroke(G.Math.rgb(60, 60, 75), 1.5),
        create("TextLabel", {
            Name = "Title",
            Size = G.Math.ud2(1, -20, 0, 24),
            Position = G.Math.ud2(0, 10, 0, 14),
            BackgroundTransparency = 1,
            Text = getText("modalCloseTitle"),
            TextColor3 = G.Math.rgb(255, 255, 255),
            Font = Enum.Font.GothamBlack,
            TextSize = 13,
            ZIndex = 52
        }),
        create("TextLabel", {
            Name = "Desc",
            Size = G.Math.ud2(1, -28, 0, 36),
            Position = G.Math.ud2(0, 14, 0, 42),
            BackgroundTransparency = 1,
            Text = getText("modalCloseDesc"),
            TextColor3 = G.Math.rgb(180, 180, 195),
            Font = Enum.Font.GothamMedium,
            TextSize = 11,
            TextWrapped = true,
            ZIndex = 52
        })
    })

    S.ModalBtnRow = create("Frame", {
        Size = G.Math.ud2(1, -24, 0, 32),
        Position = G.Math.ud2(0, 12, 1, -44),
        BackgroundTransparency = 1,
        ZIndex = 52,
        Parent = S.ModalCard
    }, {
        create("UIListLayout", {FillDirection = Enum.FillDirection.Horizontal, Padding = G.Math.ud(0.06, 0), HorizontalAlignment = Enum.HorizontalAlignment.Center})
    })

    S.modalBtnCancel = create("TextButton", {
        Size = G.Math.ud2(0.47, 0, 1, 0),
        BackgroundColor3 = G.Math.rgb(32, 32, 40),
        Text = getText("modalBtnCancel"),
        TextColor3 = G.Math.rgb(220, 220, 235),
        Font = Enum.Font.GothamBold,
        TextSize = 11,
        ZIndex = 53,
        Parent = S.ModalBtnRow
    }, { cCorner(6), cStroke(G.Math.rgb(50, 50, 65), 1) })

    S.modalBtnConfirm = create("TextButton", {
        Size = G.Math.ud2(0.47, 0, 1, 0),
        BackgroundColor3 = G.Math.rgb(210, 45, 45),
        Text = getText("modalBtnConfirm"),
        TextColor3 = G.Math.rgb(255, 255, 255),
        Font = Enum.Font.GothamBold,
        TextSize = 11,
        ZIndex = 53,
        Parent = S.ModalBtnRow
    }, { cCorner(6) })

    S.showCloseConfirmation = function(show)
        if show then
            S.ModalOverlay.Visible = true
            S.ModalCard.Size = G.Math.ud2(0, 260, 0, 130)
            G.Services.TweenService:Create(S.ModalOverlay, G.Math.tw(0.2), {BackgroundTransparency = 0.45}):Play()
            G.Services.TweenService:Create(S.ModalCard, G.Math.tw(0.25, Enum.EasingStyle.Back), {Size = G.Math.ud2(0, 290, 0, 145)}):Play()
        else
            local t = G.Services.TweenService:Create(S.ModalOverlay, G.Math.tw(0.18), {BackgroundTransparency = 1})
            G.Services.TweenService:Create(S.ModalCard, G.Math.tw(0.18), {Size = G.Math.ud2(0, 260, 0, 130)}):Play()
            t:Play()
            t.Completed:Connect(function()
                if S.ModalOverlay.BackgroundTransparency >= 0.99 then
                    S.ModalOverlay.Visible = false
                end
            end)
        end
    end

    S.closeBtn.MouseButton1Click:Connect(function() S.showCloseConfirmation(true) end)
    S.modalBtnCancel.MouseButton1Click:Connect(function() S.showCloseConfirmation(false) end)
    S.modalBtnConfirm.MouseButton1Click:Connect(function()
        S.Runtime.running = false
        for _, c in ipairs(S.Runtime.connections) do if c.Connected then c:Disconnect() end end
        table.clear(S.Runtime.connections)
        S.ScreenGui:Destroy()
        if NotificationGui then NotificationGui:Destroy() end
        getgenv()._HUB_CLEAN_ACTIVE = nil
    end)

    S.guiOpen = true
    S.setMenuOpen = function(open)
        S.guiOpen = open
        if open then
            S.MiniButton.Visible = false
            S.MainFrame.Visible = true
            setSmartFade(S.MainFrame, false)
            S.MainScale.Scale = 0.88
            G.Services.TweenService:Create(S.MainScale, G.Math.tw(0.28, Enum.EasingStyle.Quart, Enum.EasingDirection.Out), {Scale = 1}):Play()
        else
            S.showCloseConfirmation(false)
            local t = G.Services.TweenService:Create(S.MainScale, G.Math.tw(0.22, Enum.EasingStyle.Quart, Enum.EasingDirection.In), {Scale = 0.85})
            setSmartFade(S.MainFrame, true)
            t:Play()
            t.Completed:Connect(function()
                if not S.guiOpen then
                    S.MainFrame.Visible = false
                    S.MiniButton.Visible = true
                    S.MiniButton.Size = G.Math.ud2(0, 36, 0, 36)
                    G.Services.TweenService:Create(S.MiniButton, G.Math.tw(0.25, Enum.EasingStyle.Back), {Size = G.Math.ud2(0, 48, 0, 48)}):Play()
                end
            end)
        end
    end

    S.minBtn.MouseButton1Click:Connect(function() S.setMenuOpen(false) end)
    S.MiniButton.MouseButton1Click:Connect(function() S.setMenuOpen(true) end)

    S.applySearchFilter = function(query)
        query = string.lower(query or "")
        S.SearchClearBtn.Visible = (query ~= "")

        for _, item in ipairs(S.registeredSearchElements) do
            if item.container and item.container.Parent then
                if query == "" then
                    item.container.Visible = true
                else
                    local match = false
                    local mainTxt = string.lower(getText(item.key) or item.key)
                    if string.find(mainTxt, query, 1, true) ~= nil then
                        match = true
                    elseif item.subKeys then
                        for _, sk in ipairs(item.subKeys) do
                            local subTxt = string.lower(getText(sk) or sk)
                            if string.find(subTxt, query, 1, true) ~= nil then
                                match = true
                                break
                            end
                        end
                    end
                    item.container.Visible = match
                end
            end
        end

        for _, rowData in ipairs(S.registeredRows) do
            local row = rowData.frame
            if row and row.Parent then
                if query == "" then
                    row.Visible = (rowData.defaultVisible ~= false)
                else
                    local hasVisible = false
                    for _, c in ipairs(row:GetChildren()) do
                        if c:IsA("GuiObject") and not c:IsA("UIListLayout") and not c:IsA("UIPadding") and c.Visible then
                            hasVisible = true
                            break
                        end
                    end
                    row.Visible = hasVisible
                end
            end
        end
    end

    S.SearchBox:GetPropertyChangedSignal("Text"):Connect(function()
        S.applySearchFilter(S.SearchBox.Text)
    end)

    S.createPage = function(internalName, tabKey)
        local page = create("ScrollingFrame", {
            Name = internalName,
            Size = G.Math.ud2(1, -20, 1, -44),
            Position = G.Math.ud2(0, 10, 0, 42),
            BackgroundTransparency = 1,
            ScrollBarThickness = 3,
            Visible = false,
            AutomaticCanvasSize = Enum.AutomaticSize.Y,
            CanvasSize = G.Math.ud2(0, 0, 0, 0),
            ZIndex = 6,
            Parent = S.Content
        }, {
            create("UIListLayout", {SortOrder = Enum.SortOrder.LayoutOrder, Padding = G.Math.ud(0, 6), HorizontalAlignment = Enum.HorizontalAlignment.Center}),
            create("UIPadding", {PaddingTop = G.Math.ud(0, 4), PaddingBottom = G.Math.ud(0, 18)})
        })
        S.Pages[internalName] = page

        local btn = create("TextButton", {
            Size = G.Math.ud2(0.9, 0, 0, 34),
            BackgroundColor3 = G.Math.rgb(28, 28, 34),
            BackgroundTransparency = 1,
            Text = getText(tabKey),
            TextColor3 = G.Math.rgb(140, 140, 155),
            Font = Enum.Font.GothamBold,
            TextSize = 11,
            TextScaled = true,
            TextWrapped = true,
            ClipsDescendants = true,
            ZIndex = 7,
            Parent = S.SidebarContent
        }, { cCorner(6), cTextConstraint(9, 12) })
        S.TabBtns[#S.TabBtns + 1] = {instance = btn, key = tabKey}

        btn.MouseEnter:Connect(function() 
            if S.currentActiveTabBtn ~= btn then 
                G.Services.TweenService:Create(btn, G.Math.tw(0.15), {TextColor3 = G.Math.rgb(230, 230, 240)}):Play() 
            end 
        end)
        btn.MouseLeave:Connect(function() 
            if S.currentActiveTabBtn ~= btn then 
                G.Services.TweenService:Create(btn, G.Math.tw(0.15), {TextColor3 = G.Math.rgb(140, 140, 155)}):Play() 
            end 
        end)
        btn.MouseButton1Click:Connect(function()
            S.currentActiveTabBtn = btn
            for _, p in pairs(S.Pages) do p.Visible = false end
            for _, b in pairs(S.TabBtns) do
                if b.instance ~= btn then
                    G.Services.TweenService:Create(b.instance, G.Math.tw(0.2), {TextColor3 = G.Math.rgb(140, 140, 155), BackgroundTransparency = 1}):Play()
                end
            end
            page.Visible = true
            G.Services.TweenService:Create(btn, G.Math.tw(0.2), {TextColor3 = G.Math.rgb(255, 255, 255), BackgroundColor3 = G.Math.rgb(40, 40, 50), BackgroundTransparency = 0}):Play()
        end)

        return page
    end

    S.createDivider = function(parent, text, order)
        return create("TextLabel", {
            Size = G.Math.ud2(0.98, 0, 0, 18),
            BackgroundTransparency = 1,
            Text = "— " .. string.upper(text) .. " —",
            TextColor3 = G.Math.rgb(120, 120, 135),
            Font = Enum.Font.GothamBold,
            TextSize = 10,
            LayoutOrder = order or 0,
            TextXAlignment = Enum.TextXAlignment.Center,
            ZIndex = 7,
            Parent = parent
        })
    end

    local function updateRowChildren(row, childHeight)
        if not row then return end
        local children = {}
        for _, child in ipairs(row:GetChildren()) do
            if child:IsA("GuiObject") and not child:IsA("UIListLayout") and not child:IsA("UIPadding") then
                table.insert(children, child)
            end
        end
        local n = #children
        if n == 0 then return end
        local gap = 6
        local h = childHeight or row.Size.Y.Offset
        if h <= 0 then h = 38 end
        for _, child in ipairs(children) do
            child.Size = G.Math.ud2(1 / n, -math.floor(((n - 1) * gap) / n), 0, h)
        end
    end

    S.createRow = function(parent, height, order)
        height = height or 38
        local row = create("Frame", {
            Name = "Row",
            Size = G.Math.ud2(0.98, 0, 0, height),
            BackgroundTransparency = 1,
            LayoutOrder = order or 0,
            ZIndex = 7,
            Parent = parent
        }, {
            create("UIListLayout", {
                FillDirection = Enum.FillDirection.Horizontal,
                Padding = G.Math.ud(0, 6),
                HorizontalAlignment = Enum.HorizontalAlignment.Center,
                SortOrder = Enum.SortOrder.LayoutOrder
            })
        })
        S.registeredRows[#S.registeredRows + 1] = {frame = row, defaultVisible = true, height = height}
        return row
    end

    S.createToggle = function(parent, key, cb)
        local isInsideRow = (parent:IsA("Frame") and parent.Name ~= "Farm" and parent.Name ~= "Magnet" and parent.Name ~= "Visuals" and parent.Name ~= "Combat" and parent.Name ~= "Movement" and parent.Name ~= "Rewards" and parent.Name ~= "Settings")
        local isOn = (states[key] == true)

        local btn = create("TextButton", {
            Name = "Toggle_" .. key,
            Size = isInsideRow and G.Math.ud2(0.48, 0, 0, 38) or G.Math.ud2(0.98, 0, 0, 38),
            BackgroundColor3 = G.Math.rgb(22, 22, 28),
            AutoButtonColor = false,
            Text = "",
            ClipsDescendants = true,
            ZIndex = 7,
            Parent = parent
        }, { cCorner(8), cStroke(isOn and G.Math.rgb(65, 65, 80) or G.Math.rgb(42, 42, 52), 1) })

        local label = create("TextLabel", {
            Name = "BtnLabel",
            Size = G.Math.ud2(1, -54, 1, -4),
            Position = G.Math.ud2(0, 10, 0, 2),
            BackgroundTransparency = 1,
            Text = getText(key),
            TextColor3 = isOn and G.Math.rgb(255, 255, 255) or G.Math.rgb(200, 200, 215),
            Font = Enum.Font.GothamBold,
            TextSize = 11,
            TextScaled = true,
            TextWrapped = true,
            TextXAlignment = Enum.TextXAlignment.Left,
            TextYAlignment = Enum.TextYAlignment.Center,
            ZIndex = 8,
            Parent = btn
        }, { cTextConstraint(8, 11) })

        local switchTrack = create("Frame", {
            Name = "Track",
            Size = G.Math.ud2(0, 34, 0, 18),
            Position = G.Math.ud2(1, -44, 0.5, -9),
            BackgroundColor3 = isOn and G.Math.rgb(240, 240, 245) or G.Math.rgb(40, 40, 50),
            ZIndex = 8,
            Parent = btn
        }, { cCorner(9) })

        local switchDot = create("Frame", {
            Name = "Dot",
            Size = G.Math.ud2(0, 14, 0, 14),
            Position = isOn and G.Math.ud2(1, -16, 0.5, -7) or G.Math.ud2(0, 2, 0.5, -7),
            BackgroundColor3 = isOn and G.Math.rgb(16, 16, 20) or G.Math.rgb(150, 150, 165),
            ZIndex = 9,
            Parent = switchTrack
        }, { cCorner(7) })

        local stroke = btn:FindFirstChildOfClass("UIStroke")

        local function updateVisual(state)
            G.Services.TweenService:Create(switchTrack, G.Math.tw(0.16), {BackgroundColor3 = state and G.Math.rgb(240, 240, 245) or G.Math.rgb(40, 40, 50)}):Play()
            G.Services.TweenService:Create(switchDot, G.Math.tw(0.16, Enum.EasingStyle.Quad), {
                Position = state and G.Math.ud2(1, -16, 0.5, -7) or G.Math.ud2(0, 2, 0.5, -7),
                BackgroundColor3 = state and G.Math.rgb(16, 16, 20) or G.Math.rgb(150, 150, 165)
            }):Play()
            G.Services.TweenService:Create(label, G.Math.tw(0.16), {
                TextColor3 = state and G.Math.rgb(255, 255, 255) or G.Math.rgb(200, 200, 215)
            }):Play()
            if stroke then
                G.Services.TweenService:Create(stroke, G.Math.tw(0.16), {
                    Color = state and G.Math.rgb(75, 75, 95) or G.Math.rgb(42, 42, 52)
                }):Play()
            end
        end

        S.UI_STORAGE[key] = S.UI_STORAGE[key] or {}
        table.insert(S.UI_STORAGE[key], {type = "toggle", track = switchTrack, dot = switchDot, label = label, update = updateVisual})
        S.registeredSearchElements[#S.registeredSearchElements + 1] = {container = btn, key = key}

        btn.MouseButton1Click:Connect(function()
            G.Services.TweenService:Create(btn, G.Math.tw(0.08), {BackgroundColor3 = G.Math.rgb(32, 32, 40)}):Play()
            task.delay(0.1, function()
                G.Services.TweenService:Create(btn, G.Math.tw(0.15), {BackgroundColor3 = G.Math.rgb(22, 22, 28)}):Play()
            end)

            states[key] = not states[key]
            updateVisual(states[key])
            if cb then cb(states[key]) end
        end)

        return btn
    end

    S.createSlider = function(parent, min, max, default, key, step, cb)
        step = step or 1
        states[key] = G.Math.clamp(default or min, min, max)

        local cont = create("Frame", {
            Name = "Slider_" .. key,
            Size = G.Math.ud2(0.98, 0, 0, 52),
            BackgroundColor3 = G.Math.rgb(22, 22, 28),
            ClipsDescendants = true,
            ZIndex = 7,
            Parent = parent
        }, { cCorner(8), cStroke(G.Math.rgb(42, 42, 52), 1) })

        local lbl = create("TextLabel", {
            Name = "Title",
            Size = G.Math.ud2(1, -74, 0, 20),
            Position = G.Math.ud2(0, 10, 0, 4),
            BackgroundTransparency = 1,
            Text = getText(key),
            TextColor3 = G.Math.rgb(230, 230, 240),
            Font = Enum.Font.GothamBold,
            TextSize = 11,
            TextScaled = true,
            TextWrapped = true,
            TextXAlignment = Enum.TextXAlignment.Left,
            TextYAlignment = Enum.TextYAlignment.Center,
            ZIndex = 8,
            Parent = cont
        }, { cTextConstraint(8, 11) })

        local valBox = create("TextBox", {
            Name = "ValueInput",
            Size = G.Math.ud2(0, 48, 0, 18),
            Position = G.Math.ud2(1, -58, 0, 5),
            BackgroundColor3 = G.Math.rgb(32, 32, 40),
            Text = tostring(states[key]),
            TextColor3 = G.Math.rgb(255, 255, 255),
            Font = Enum.Font.GothamBold,
            TextSize = 11,
            ClearTextOnFocus = false,
            ZIndex = 8,
            Parent = cont
        }, { cCorner(4) })

        local decBtn = create("TextButton", {
            Name = "DecBtn",
            Size = G.Math.ud2(0, 24, 0, 22),
            Position = G.Math.ud2(0, 8, 0, 25),
            BackgroundColor3 = G.Math.rgb(28, 28, 36),
            Text = "—",
            TextColor3 = G.Math.rgb(200, 200, 215),
            Font = Enum.Font.GothamBold,
            TextSize = 10,
            AutoButtonColor = false,
            ZIndex = 9,
            Parent = cont
        }, { cCorner(4), cStroke(G.Math.rgb(45, 45, 55), 1) })

        local incBtn = create("TextButton", {
            Name = "IncBtn",
            Size = G.Math.ud2(0, 24, 0, 22),
            Position = G.Math.ud2(1, -32, 0, 25),
            BackgroundColor3 = G.Math.rgb(28, 28, 36),
            Text = "+",
            TextColor3 = G.Math.rgb(200, 200, 215),
            Font = Enum.Font.GothamBold,
            TextSize = 12,
            AutoButtonColor = false,
            ZIndex = 9,
            Parent = cont
        }, { cCorner(4), cStroke(G.Math.rgb(45, 45, 55), 1) })

        local hitZone = create("TextButton", {
            Name = "SlideHitZone",
            Size = G.Math.ud2(1, -74, 0, 22),
            Position = G.Math.ud2(0, 37, 0, 25),
            BackgroundTransparency = 1,
            Text = "",
            AutoButtonColor = false,
            ZIndex = 9,
            Parent = cont
        })

        local slideTrack = create("Frame", {
            Name = "TrackVisual",
            Size = G.Math.ud2(1, 0, 0, 6),
            Position = G.Math.ud2(0, 0, 0.5, -3),
            BackgroundColor3 = G.Math.rgb(14, 14, 18),
            BorderSizePixel = 0,
            ZIndex = 8,
            Parent = hitZone
        }, { cCorner(3) })

        local fillPct = G.Math.clamp((states[key] - min) / (max - min), 0, 1)
        local fill = create("Frame", {
            Name = "Fill",
            Size = G.Math.ud2(fillPct, 0, 1, 0),
            BackgroundColor3 = G.Math.rgb(240, 240, 250),
            ZIndex = 9,
            Parent = slideTrack
        }, { cCorner(3) })

        local function applyVal(val, updateBox)
            val = G.Math.clamp(val, min, max)
            if step > 0 then val = G.Math.floor((val / step) + 0.5) * step end
            states[key] = val
            local pct = G.Math.clamp((val - min) / (max - min), 0, 1)
            G.Services.TweenService:Create(fill, G.Math.tw(0.08), {Size = G.Math.ud2(pct, 0, 1, 0)}):Play()
            if updateBox then valBox.Text = tostring(val) end
            if cb then cb(val) end
        end

        decBtn.MouseButton1Click:Connect(function()
            applyVal(states[key] - step, true)
            G.Services.TweenService:Create(decBtn, G.Math.tw(0.08), {BackgroundColor3 = G.Math.rgb(45, 45, 55)}):Play()
            task.delay(0.1, function() G.Services.TweenService:Create(decBtn, G.Math.tw(0.1), {BackgroundColor3 = G.Math.rgb(28, 28, 36)}):Play() end)
        end)

        incBtn.MouseButton1Click:Connect(function()
            applyVal(states[key] + step, true)
            G.Services.TweenService:Create(incBtn, G.Math.tw(0.08), {BackgroundColor3 = G.Math.rgb(45, 45, 55)}):Play()
            task.delay(0.1, function() G.Services.TweenService:Create(incBtn, G.Math.tw(0.1), {BackgroundColor3 = G.Math.rgb(28, 28, 36)}):Play() end)
        end)

        valBox.FocusLost:Connect(function()
            local num = tonumber(valBox.Text)
            if num then applyVal(num, true) else valBox.Text = tostring(states[key]) end
        end)

        local dragging = false
        hitZone.InputBegan:Connect(function(input)
            if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
                dragging = true
                local percent = G.Math.clamp((input.Position.X - hitZone.AbsolutePosition.X) / hitZone.AbsoluteSize.X, 0, 1)
                applyVal(min + (max - min) * percent, true)
            end
        end)

        G.Services.UserInputService.InputEnded:Connect(function(input)
            if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
                dragging = false
            end
        end)

        G.Services.UserInputService.InputChanged:Connect(function(input)
            if dragging and (input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch) then
                local percent = G.Math.clamp((input.Position.X - hitZone.AbsolutePosition.X) / hitZone.AbsoluteSize.X, 0, 1)
                applyVal(min + (max - min) * percent, true)
            end
        end)

        S.UI_STORAGE[key] = S.UI_STORAGE[key] or {}
        table.insert(S.UI_STORAGE[key], {type = "slider", fill = fill, box = valBox, label = lbl, apply = applyVal})
        S.registeredSearchElements[#S.registeredSearchElements + 1] = {container = cont, key = key}

        return cont
    end

    S.createActionButton = function(parent, key, cb)
        local isInsideRow = (parent:IsA("Frame") and parent.Name ~= "Farm" and parent.Name ~= "Magnet" and parent.Name ~= "Visuals" and parent.Name ~= "Combat" and parent.Name ~= "Movement" and parent.Name ~= "Rewards" and parent.Name ~= "Settings")
        
        local label = create("TextLabel", {
            Name = "BtnLabel",
            Size = G.Math.ud2(1, -14, 1, -4),
            Position = G.Math.ud2(0, 7, 0, 2),
            BackgroundTransparency = 1,
            Text = getText(key),
            TextColor3 = G.Math.rgb(240, 240, 250),
            Font = Enum.Font.GothamBold,
            TextSize = 11,
            TextScaled = true,
            TextWrapped = true,
            ZIndex = 8
        }, { cTextConstraint(8, 11) })

        local btn = create("TextButton", {
            Name = "Action_" .. key,
            Size = isInsideRow and G.Math.ud2(0.48, 0, 0, 38) or G.Math.ud2(0.98, 0, 0, 38),
            Text = "",
            BackgroundColor3 = G.Math.rgb(28, 28, 36),
            AutoButtonColor = false,
            ClipsDescendants = true,
            ZIndex = 7,
            Parent = parent
        }, { cCorner(8), cStroke(G.Math.rgb(48, 48, 60), 1), label })

        S.localizedLabels[#S.localizedLabels + 1] = {instance = label, key = key}
        S.registeredSearchElements[#S.registeredSearchElements + 1] = {container = btn, key = key}

        btn.MouseButton1Click:Connect(function()
            G.Services.TweenService:Create(btn, G.Math.tw(0.08), {BackgroundColor3 = G.Math.rgb(65, 65, 80)}):Play()
            task.delay(0.12, function()
                G.Services.TweenService:Create(btn, G.Math.tw(0.15), {BackgroundColor3 = G.Math.rgb(28, 28, 36)}):Play()
            end)
            if cb then cb() end
        end)

        return btn
    end

    -- ====================================================================
    --                  МОДАЛЬНОЕ ОКНО ЧЕНДЖЛОГА
    -- ====================================================================
    local changelogData = {
        version = "v5.0 Master",
        changes = {
            Russian = {
                "Удалена авто-покупка улучшений по запросу",
                "Flash-Вакуум переписан с приоритетом TimeLeft и сортировкой дистанции",
                "Исправлен авто-сбор наград таймера и колеса фортуны",
                "Рандом ТП фарм теперь ориентируется строго на цель перед захватом",
                "Авто-селл полностью синхронизирован с сервером и WarningText",
                "Добавлена полная двуязычная локализация (RU/EN, по умолчанию EN)"
            },
            English = {
                "Removed auto-purchasing upgrades per user request",
                "Flash Vacuum redesigned with TimeLeft priority and distance sorting",
                "Fixed timed reward and lucky wheel auto-claiming",
                "Random TP Farm now strictly orients towards target before grab",
                "Auto-Sell perfectly synchronized with server error and WarningText",
                "Full bilingual localization integrated (RU/EN, default English)"
            }
        }
    }

    local function showChangelogModal()
        local vpNow = Camera.ViewportSize
        local isSmall = vpNow.X < 700 or isTouchDevice
        local cardW = isSmall and G.Math.clamp(G.Math.floor(vpNow.X * 0.85), 280, 370) or 400
        local cardH = isSmall and G.Math.clamp(G.Math.floor(vpNow.Y * 0.70), 260, 350) or 340

        local overlay = create("TextButton", {
            Name = "ChangelogOverlay",
            Size = G.Math.ud2(1, 0, 1, 0),
            BackgroundColor3 = G.Math.rgb(0, 0, 0),
            BackgroundTransparency = 1,
            AutoButtonColor = false,
            Text = "",
            ZIndex = 60,
            Parent = S.ScreenGui
        })

        local card = create("Frame", {
            Name = "ChangelogCard",
            Size = G.Math.ud2(0, cardW * 0.8, 0, cardH * 0.8),
            Position = G.Math.ud2(0.5, 0, 0.5, 0),
            AnchorPoint = Vector2.new(0.5, 0.5),
            BackgroundColor3 = G.Math.rgb(14, 14, 18),
            ZIndex = 61,
            ClipsDescendants = true,
            Parent = overlay
        }, {
            cCorner(12),
            cStroke(G.Math.rgb(65, 65, 80), 1.5)
        })
        makeDraggable(card)

        local topBar = create("Frame", {Size = G.Math.ud2(1, 0, 0, 42), BackgroundTransparency = 1, ZIndex = 62, Parent = card})
        create("TextLabel", {
            Size = G.Math.ud2(0.65, 0, 1, 0),
            Position = G.Math.ud2(0, 14, 0, 0),
            BackgroundTransparency = 1,
            Text = (states.language == "Russian") and "ЧТО НОВОГО" or "WHAT'S NEW",
            TextColor3 = G.Math.rgb(255, 255, 255),
            Font = Enum.Font.GothamBlack,
            TextSize = 13,
            TextXAlignment = Enum.TextXAlignment.Left,
            ZIndex = 63,
            Parent = topBar
        })

        local closeBtn = create("TextButton", {
            Size = G.Math.ud2(0, 26, 0, 26),
            Position = G.Math.ud2(1, -38, 0.5, -13),
            BackgroundColor3 = G.Math.rgb(24, 24, 30),
            Text = "X",
            TextColor3 = G.Math.rgb(200, 200, 215),
            Font = Enum.Font.GothamBold,
            TextSize = 11,
            AutoButtonColor = false,
            ZIndex = 63,
            Parent = topBar
        }, { cCorner(6), cStroke(G.Math.rgb(45, 45, 55), 1) })

        local scroll = create("ScrollingFrame", {
            Size = G.Math.ud2(1, -24, 1, -96),
            Position = G.Math.ud2(0, 12, 0, 44),
            BackgroundColor3 = G.Math.rgb(18, 18, 24),
            ScrollBarThickness = 3,
            CanvasSize = G.Math.ud2(0, 0, 0, 0),
            AutomaticCanvasSize = Enum.AutomaticSize.Y,
            ZIndex = 62,
            Parent = card
        }, {
            cCorner(8),
            cStroke(G.Math.rgb(40, 40, 50), 1),
            create("UIListLayout", {SortOrder = Enum.SortOrder.LayoutOrder, Padding = G.Math.ud(0, 6)}),
            create("UIPadding", {PaddingTop = G.Math.ud(0, 8), PaddingBottom = G.Math.ud(0, 8), PaddingLeft = G.Math.ud(0, 8), PaddingRight = G.Math.ud(0, 8)})
        })

        local curList = changelogData.changes[states.language] or changelogData.changes.English
        for _, textLine in ipairs(curList) do
            create("Frame", {
                Size = G.Math.ud2(1, 0, 0, 0),
                AutomaticSize = Enum.AutomaticSize.Y,
                BackgroundColor3 = G.Math.rgb(22, 22, 28),
                ZIndex = 63,
                Parent = scroll
            }, {
                cCorner(6),
                create("UIPadding", {PaddingTop = G.Math.ud(0, 6), PaddingBottom = G.Math.ud(0, 6), PaddingLeft = G.Math.ud(0, 8), PaddingRight = G.Math.ud(0, 8)}),
                create("TextLabel", {
                    Size = G.Math.ud2(1, 0, 0, 0),
                    AutomaticSize = Enum.AutomaticSize.Y,
                    BackgroundTransparency = 1,
                    Text = "• " .. textLine,
                    TextColor3 = G.Math.rgb(230, 230, 240),
                    Font = Enum.Font.GothamMedium,
                    TextSize = 11,
                    TextWrapped = true,
                    TextXAlignment = Enum.TextXAlignment.Left,
                    ZIndex = 64
                })
            })
        end

        local okBtn = create("TextButton", {
            Size = G.Math.ud2(1, -24, 0, 32),
            Position = G.Math.ud2(0, 12, 1, -42),
            BackgroundColor3 = G.Math.rgb(32, 32, 42),
            Text = (states.language == "Russian") and "Понятно!" or "Got it!",
            TextColor3 = G.Math.rgb(255, 255, 255),
            Font = Enum.Font.GothamBold,
            TextSize = 11,
            ZIndex = 63,
            Parent = card
        }, { cCorner(6), cStroke(G.Math.rgb(60, 60, 75), 1) })

        local function closeModal()
            local tw = G.Services.TweenService:Create(overlay, G.Math.tw(0.18), {BackgroundTransparency = 1})
            G.Services.TweenService:Create(card, G.Math.tw(0.18), {Size = G.Math.ud2(0, cardW * 0.8, 0, cardH * 0.8)}):Play()
            tw:Play()
            tw.Completed:Connect(function() overlay:Destroy() end)
        end

        closeBtn.MouseButton1Click:Connect(closeModal)
        okBtn.MouseButton1Click:Connect(closeModal)

        G.Services.TweenService:Create(overlay, G.Math.tw(0.25), {BackgroundTransparency = 0.5}):Play()
        G.Services.TweenService:Create(card, G.Math.tw(0.28, Enum.EasingStyle.Back, Enum.EasingDirection.Out), {Size = G.Math.ud2(0, cardW, 0, cardH)}):Play()
    end

    -- ====================================================================
    --                     НАПОЛНЕНИЕ ВКЛАДОК
    -- ====================================================================
    local pageFarm = S.createPage("Farm", "tabFarm")
    local pageMagnet = S.createPage("Magnet", "tabMagnet")
    local pageVisuals = S.createPage("Visuals", "tabVisuals")
    local pageCombat = S.createPage("Combat", "tabCombat")
    local pageMovement = S.createPage("Movement", "tabMovement")
    local pageRewards = S.createPage("Rewards", "tabRewards")
    local pageSettings = S.createPage("Settings", "tabSettings")

    -- 1. ВКЛАДКА: ФАРМ (FARM)
    S.createDivider(pageFarm, getText("secFarm"), 1)
    local farmRow1 = S.createRow(pageFarm, 38, 2)
    local toggleFarm = S.createToggle(farmRow1, "toggleRandomFarm", function(val)
        states.randomTPFarm = val
        showNotification(getText("toggleRandomFarm") .. ": " .. (val and "ON" or "OFF"), val and "Success" or "Warning")
    end)

    S.createDivider(pageFarm, getText("secSell"), 3)
    local farmRow2 = S.createRow(pageFarm, 38, 4)
    local toggleSell = S.createToggle(farmRow2, "toggleAutoSell", function(val)
        states.autoSell = val
        showNotification(getText("toggleAutoSell") .. ": " .. (val and "ON" or "OFF"), "Info")
    end)
    local btnSell = S.createActionButton(farmRow2, "btnForceSell", function()
        executeSell()
        showNotification(getText("statusSellSuccess"), "Success")
    end)

    -- 2. ВКЛАДКА: МАГНИТ (MAGNET)
    S.createDivider(pageMagnet, getText("secMagnet"), 1)
    local magRow1 = S.createRow(pageMagnet, 38, 2)
    local toggleVacuum = S.createToggle(magRow1, "toggleFlashVacuum", function(val)
        states.flashVacuum = val
        showNotification(getText("toggleFlashVacuum") .. ": " .. (val and "ON" or "OFF"), val and "Success" or "Warning")
    end)
    local toggleTouchMag = S.createToggle(magRow1, "toggleInstantMagnet", function(val)
        states.instantMagnet = val
        showNotification(getText("toggleInstantMagnet") .. ": " .. (val and "ON" or "OFF"), "Info")
    end)

    local magRow2 = S.createRow(pageMagnet, 38, 3)
    local btnSweep = S.createActionButton(magRow2, "btnSweepOnce", function()
        task.spawn(function()
            local dropsList = getPrioritizedDrops()
            if #dropsList > 0 and HumanoidRootPart then
                local startCF = HumanoidRootPart.CFrame
                for _, itemData in ipairs(dropsList) do
                    local itemPart = itemData.Part
                    if itemPart and itemPart.Parent and canCollect(itemPart) then
                        HumanoidRootPart.CFrame = itemPart.CFrame * CFrame.new(0, 0.4, 0)
                        HumanoidRootPart.AssemblyLinearVelocity = Vector3.new(0, 0.1, 0)
                        if typeof(firetouchinterest) == "function" then
                            firetouchinterest(HumanoidRootPart, itemPart, 0)
                            firetouchinterest(HumanoidRootPart, itemPart, 1)
                        end
                        G.Services.RunService.Heartbeat:Wait()
                    end
                end
                HumanoidRootPart.CFrame = startCF
                HumanoidRootPart.AssemblyLinearVelocity = Vector3.zero
                showNotification("Sweep complete! Gathered items.", "Success")
            end
        end)
    end)

    -- 3. ВКЛАДКА: ВИЗУАЛ (VISUALS)
    S.createDivider(pageVisuals, getText("secVisuals"), 1)
    local visRow1 = S.createRow(pageVisuals, 38, 2)
    local toggleESP = S.createToggle(visRow1, "togglePlayerESP", function(val)
        states.playerESP = val
        showNotification(getText("togglePlayerESP") .. ": " .. (val and "ON" or "OFF"), "Info")
    end)

    -- 4. ВКЛАДКА: БОЙ (COMBAT)
    S.createDivider(pageCombat, getText("secCombat"), 1)
    local comRow1 = S.createRow(pageCombat, 38, 2)
    local toggleRagdoll = S.createToggle(comRow1, "toggleAntiRagdoll", function(val)
        states.antiRagdoll = val
        showNotification(getText("toggleAntiRagdoll") .. ": " .. (val and "ON" or "OFF"), "Info")
    end)
    local toggleGiant = S.createToggle(comRow1, "toggleAntiGiant", function(val)
        states.antiGiant = val
        showNotification(getText("toggleAntiGiant") .. ": " .. (val and "ON" or "OFF"), "Info")
    end)

    -- 5. ВКЛАДКА: ДВИЖЕНИЕ (MOVEMENT)
    S.createDivider(pageMovement, getText("secMove"), 1)
    local moveRow1 = S.createRow(pageMovement, 38, 2)
    local toggleFly = S.createToggle(moveRow1, "toggleFly", function(val)
        states.fly = val
        showNotification(getText("toggleFly") .. ": " .. (val and "ON" or "OFF"), "Info")
    end)
    local toggleNoclip = S.createToggle(moveRow1, "toggleNoclip", function(val)
        states.noclip = val
        showNotification(getText("toggleNoclip") .. ": " .. (val and "ON" or "OFF"), "Info")
    end)

    local moveRow2 = S.createRow(pageMovement, 38, 3)
    local toggleJump = S.createToggle(moveRow2, "toggleInfJump", function(val)
        states.infJump = val
        showNotification(getText("toggleInfJump") .. ": " .. (val and "ON" or "OFF"), "Info")
    end)

    local moveSliderRow = S.createRow(pageMovement, 52, 4)
    local sliderSpeed = S.createSlider(moveSliderRow, 16, 200, 60, "sliderFlySpeed", 2, function(val)
        states.flySpeed = val
    end)

    -- 6. ВКЛАДКА: НАГРАДЫ (REWARDS)
    S.createDivider(pageRewards, getText("secRewards"), 1)
    local rewRow1 = S.createRow(pageRewards, 38, 2)
    local toggleRewards = S.createToggle(rewRow1, "toggleAutoRewards", function(val)
        states.autoRewards = val
        showNotification(getText("toggleAutoRewards") .. ": " .. (val and "ON" or "OFF"), "Info")
    end)
    local btnClaim = S.createActionButton(rewRow1, "btnClaimAllNow", function()
        claimTimedRewards()
        showNotification(getText("statusRewardsClaimed"), "Success")
    end)

    -- 7. ВКЛАДКА: НАСТРОЙКИ (SETTINGS)
    S.createDivider(pageSettings, getText("secPrefs"), 1)
    local setRow1 = S.createRow(pageSettings, 36, 2)
    local setRow2 = S.createRow(pageSettings, 36, 3)

    local langBtn = create("TextButton", {
        Size = G.Math.ud2(1, 0, 1, 0),
        BackgroundColor3 = G.Math.rgb(32, 32, 40),
        Text = getText("langBtn"),
        TextColor3 = G.Math.rgb(255, 255, 255),
        Font = Enum.Font.GothamBold,
        TextSize = 12,
        TextScaled = true,
        TextWrapped = true,
        ClipsDescendants = true,
        ZIndex = 7,
        Parent = setRow1
    }, {cCorner(8), cStroke(G.Math.rgb(50, 50, 65), 1), cTextConstraint(9, 12)})

    local keybindBtn = create("TextButton", {
        Size = G.Math.ud2(1, 0, 1, 0),
        BackgroundColor3 = G.Math.rgb(24, 24, 30),
        Text = getText("menuKeyBtn") .. "[" .. tostring(states.menuKey) .. "]",
        TextColor3 = G.Math.rgb(220, 220, 235),
        Font = Enum.Font.GothamBold,
        TextSize = 12,
        TextScaled = true,
        TextWrapped = true,
        ClipsDescendants = true,
        ZIndex = 7,
        Parent = setRow2
    }, {cCorner(8), cStroke(G.Math.rgb(45, 45, 55), 1), cTextConstraint(9, 12)})

    local changelogBtn = create("TextButton", {
        Size = G.Math.ud2(0.98, 0, 0, 34),
        BackgroundColor3 = G.Math.rgb(24, 24, 30),
        Text = getText("btnViewChangelog"),
        TextColor3 = G.Math.rgb(230, 230, 245),
        Font = Enum.Font.GothamBold,
        TextSize = 11,
        TextScaled = true,
        TextWrapped = true,
        ClipsDescendants = true,
        LayoutOrder = 4,
        ZIndex = 7,
        Parent = pageSettings
    }, {cCorner(8), cStroke(G.Math.rgb(45, 45, 55), 1), cTextConstraint(9, 12)})
    changelogBtn.MouseButton1Click:Connect(showChangelogModal)

    local isListeningKey = false
    keybindBtn.MouseButton1Click:Connect(function()
        if isListeningKey then return end
        isListeningKey = true
        keybindBtn.Text = getText("pressAnyKey")
        keybindBtn.TextColor3 = G.Math.rgb(255, 255, 255)

        local bindConn
        bindConn = G.Services.UserInputService.InputBegan:Connect(function(input)
            if input.UserInputType == Enum.UserInputType.Keyboard and input.KeyCode and input.KeyCode ~= Enum.KeyCode.Unknown then
                states.menuKey = input.KeyCode.Name
                keybindBtn.Text = getText("menuKeyBtn") .. "[" .. tostring(states.menuKey) .. "]"
                keybindBtn.TextColor3 = G.Math.rgb(220, 220, 235)
                isListeningKey = false
                bindConn:Disconnect()
            end
        end)
    end)

    langBtn.MouseButton1Click:Connect(function()
        states.language = (states.language == "English") and "Russian" or "English"
        langBtn.Text = getText("langBtn")
        keybindBtn.Text = getText("menuKeyBtn") .. "[" .. tostring(states.menuKey) .. "]"
        changelogBtn.Text = getText("btnViewChangelog")
        S.SearchBox.PlaceholderText = getText("searchPlaceholder")
        
        S.ModalCard.Title.Text = getText("modalCloseTitle")
        S.ModalCard.Desc.Text = getText("modalCloseDesc")
        S.modalBtnCancel.Text = getText("modalBtnCancel")
        S.modalBtnConfirm.Text = getText("modalBtnConfirm")

        for _, tab in ipairs(S.TabBtns) do
            tab.instance.Text = getText(tab.key)
        end
        for k, arr in pairs(S.UI_STORAGE) do
            local txt = getText(k)
            for _, ui in ipairs(arr) do
                if ui.label then
                    ui.label.Text = txt
                end
            end
        end
        for _, obj in ipairs(S.localizedLabels) do
            if obj.instance and obj.instance.Parent then
                obj.instance.Text = getText(obj.key)
            end
        end
        showNotification("Language: " .. states.language, "Info")
    end)

    -- ====================================================================
    --             СИСТЕМА ДИНАМИЧЕСКОЙ СЕТКИ (RESPONSIVE GRID)
    -- ====================================================================
    local currentLayoutMode = nil
    local function setRowDefVisible(row, isVis)
        for _, r in ipairs(S.registeredRows) do
            if r.frame == row then
                r.defaultVisible = isVis
                break
            end
        end
    end

    S.updateResponsiveLayout = function(force)
        local curWidth = S.MainFrame.AbsoluteSize.X
        local newMode = "Compact"
        if curWidth >= 660 then
            newMode = "Wide"
        else
            newMode = "Compact"
        end

        if not force and newMode == currentLayoutMode then
            return
        end
        currentLayoutMode = newMode

        updateRowChildren(farmRow1, 38)
        updateRowChildren(farmRow2, 38)
        updateRowChildren(magRow1, 38)
        updateRowChildren(magRow2, 38)
        updateRowChildren(visRow1, 38)
        updateRowChildren(comRow1, 38)
        updateRowChildren(moveRow1, 38)
        updateRowChildren(moveRow2, 38)
        updateRowChildren(moveSliderRow, 52)
        updateRowChildren(rewRow1, 38)
        updateRowChildren(setRow1, 36)
        updateRowChildren(setRow2, 36)

        if S.SearchBox and S.SearchBox.Text ~= "" then
            S.applySearchFilter(S.SearchBox.Text)
        end
    end

    S.Runtime.connections[#S.Runtime.connections + 1] = S.MainFrame:GetPropertyChangedSignal("AbsoluteSize"):Connect(function()
        S.updateResponsiveLayout(false)
    end)
    S.updateResponsiveLayout(true)

    pageFarm.Visible = true
    if S.TabBtns[1] and S.TabBtns[1].instance then
        S.currentActiveTabBtn = S.TabBtns[1].instance
        G.Services.TweenService:Create(S.TabBtns[1].instance, G.Math.tw(0.2), {
            TextColor3 = G.Math.rgb(255, 255, 255),
            BackgroundColor3 = G.Math.rgb(40, 40, 50),
            BackgroundTransparency = 0
        }):Play()
    end

    -- ====================================================================
    --              ФОНОВЫЕ ПОТОКИ И ИГРОВЫЕ СИСТЕМЫ
    -- ====================================================================
    S.Runtime.connections[#S.Runtime.connections + 1] = G.Services.UserInputService.InputBegan:Connect(function(i, gp)
        if gp or not i or not i.KeyCode or i.KeyCode == Enum.KeyCode.Unknown then return end
        if i.KeyCode.Name == states.menuKey then
            S.setMenuOpen(not S.guiOpen)
        end
    end)

    -- ==============================================================================
    -- 1. ПОТОК: РАНДОМ ТП АВТО-ФАРМ С WATCHDOG-ЗАЩИТОЙ (10 СЕК СТУПОР -> 3 СЕК ПЕРЕЗАПУСК)
    -- ==============================================================================
    task.spawn(function()
        local localGrab = G.Services.ReplicatedStorage:WaitForChild("LocalEvents"):WaitForChild("Grab")
        local localEat = G.Services.ReplicatedStorage:WaitForChild("LocalEvents"):WaitForChild("Eat")

        local lastActivityTime = os.clock()
        local wasFarming = false

        -- Функция синхронизации визуального состояния тумблера в GUI
        local function setFarmVisual(state)
            if S.UI_STORAGE["toggleRandomFarm"] then
                for _, elem in ipairs(S.UI_STORAGE["toggleRandomFarm"]) do
                    if elem.update then elem.update(state) end
                end
            end
        end

        while S.Runtime.running do
            if states.randomTPFarm then
                -- Сброс таймера при включении
                if not wasFarming then
                    wasFarming = true
                    lastActivityTime = os.clock()
                end

                -- ПРОВЕРКА WATCHDOG: Если 10 секунд ничего не подбиралось и не елось
                if os.clock() - lastActivityTime >= 10 then
                    showNotification(
                        (states.language == "Russian") and "Фарм завис! Перезапуск на 3 сек..." or "Farm stuck! Restarting in 3s...",
                        "Warning"
                    )

                    -- 1. Отключаем авто-фарм и визуально переключаем кнопку в OFF
                    states.randomTPFarm = false
                    setFarmVisual(false)

                    -- 2. Снимаем физические блокировки и сбрасываем персонажа
                    local char = player.Character
                    if char then
                        local hrp = char:FindFirstChild("HumanoidRootPart")
                        local hum = char:FindFirstChild("Humanoid")
                        if hrp then 
                            hrp.Anchored = false 
                            hrp.AssemblyLinearVelocity = Vector3.zero
                        end
                        if hum then 
                            hum:ChangeState(Enum.HumanoidStateType.Running) 
                        end
                    end

                    -- 3. Ждем ровно 3 секунды
                    task.wait(3.0)

                    -- 4. Включаем авто-фарм обратно и переключаем кнопку в ON
                    if S.Runtime.running then
                        states.randomTPFarm = true
                        setFarmVisual(true)
                        lastActivityTime = os.clock()
                        showNotification(
                            (states.language == "Russian") and "Авто-фарм перезапущен!" or "Auto-Farm resumed!",
                            "Success"
                        )
                    end
                end

                local char = player.Character
                if char and char:FindFirstChild("HumanoidRootPart") and char:FindFirstChild("Humanoid") then
                    local hrp = char.HumanoidRootPart
                    local hum = char.Humanoid
                    local currentChunkVal = char:FindFirstChild("CurrentChunk")
                    local events = getCharEvents()

                    if hum.Health > 0 and currentChunkVal and events then
                        hum:ChangeState(Enum.HumanoidStateType.Running)

                        -- Проверка на полный размер
                        if states.autoSell and isInventoryFull() then
                            if currentChunkVal.Value ~= nil then
                                if events.ChunkLoaded then events.ChunkLoaded:FireServer(currentChunkVal.Value) end
                                events.Eat:FireServer()
                                local wEat = os.clock()
                                while currentChunkVal.Value ~= nil and (os.clock() - wEat) < 0.3 do
                                    task.wait(0.02)
                                end
                            end

                            executeSell()
                            lastActivityTime = os.clock() -- Успешное действие: продажа

                            local wReset = os.clock()
                            while isInventoryFull() and (os.clock() - wReset) < 1.2 do
                                task.wait(0.05)
                            end
                            task.wait(0.1)
                        end

                        -- Поиск живого объекта на карте (с приоритетом земли)
                        local targetPart, isGround = getRandomEdiblePart()
                        if targetPart and targetPart.Parent then
                            local partPos = targetPart.Position
                            local standPos
                            local lookTarget

                            if isGround then
                                -- ТП прямо на землю с наклоном взгляда вниз под ноги
                                standPos = partPos + Vector3.new(math.random(-1, 1), hum.HipHeight + 0.2, math.random(-1, 1))
                                lookTarget = partPos - Vector3.new(0, 2, 0)
                            else
                                -- ТП перед стеной/зданием
                                standPos = partPos + Vector3.new(0, hum.HipHeight + 0.5, 2.5)
                                lookTarget = Vector3.new(partPos.X, standPos.Y, partPos.Z)
                            end

                            hrp.CFrame = CFrame.new(standPos, lookTarget)
                            hrp.AssemblyLinearVelocity = Vector3.zero
                            hrp.AssemblyAngularVelocity = Vector3.zero

                            task.wait(states.tpDelay)

                            -- Захват
                            if currentChunkVal.Value == nil then
                                localGrab:Fire()

                                local grabTimeout = os.clock()
                                while currentChunkVal.Value == nil and (os.clock() - grabTimeout) < 0.35 do
                                    task.wait(0.02)
                                end

                                if currentChunkVal.Value == nil and events.Grab then
                                    events.Grab:FireServer(false, false, false)
                                    task.wait(0.05)
                                end
                            end

                            -- Поедание взятого куска
                            local held = currentChunkVal.Value
                            if held and held.Parent then
                                lastActivityTime = os.clock() -- Успешное действие: кусок взят!

                                if events.ChunkLoaded then
                                    events.ChunkLoaded:FireServer(held)
                                end
                                task.wait(0.02)

                                localEat:Fire()

                                local eatTimeout = os.clock()
                                while currentChunkVal.Value ~= nil and (os.clock() - eatTimeout) < 0.35 do
                                    task.wait(0.02)
                                end

                                lastActivityTime = os.clock() -- Успешное действие: кусок съеден!
                            end

                            local anchorTimeout = os.clock()
                            while hrp.Anchored and (os.clock() - anchorTimeout) < 0.25 do
                                task.wait(0.02)
                            end
                        else
                            task.wait(0.1)
                        end
                    end
                end
            else
                wasFarming = false
            end
            task.wait(0.02)
        end
    end)

    -- 2. ПОТОК: FLASH VACUUM (СВЕРХБЫСТРЫЙ МАГНИТ)
    task.spawn(function()
        while S.Runtime.running do
            if states.flashVacuum then
                local char = player.Character
                if char and char:FindFirstChild("HumanoidRootPart") and char:FindFirstChild("Humanoid") then
                    local hrp = char.HumanoidRootPart
                    local hum = char.Humanoid

                    if hum.Health > 0 then
                        local dropsList = getPrioritizedDrops()
                        if #dropsList > 0 then
                            local startCF = hrp.CFrame

                            for _, itemData in ipairs(dropsList) do
                                if not states.flashVacuum then break end
                                local itemPart = itemData.Part

                                if itemPart and itemPart.Parent and canCollect(itemPart) then
                                    hrp.CFrame = itemPart.CFrame * CFrame.new(0, 0.4, 0)
                                    hrp.AssemblyLinearVelocity = Vector3.new(0, 0.1, 0)

                                    if typeof(firetouchinterest) == "function" then
                                        firetouchinterest(hrp, itemPart, 0)
                                        firetouchinterest(hrp, itemPart, 1)
                                    end

                                    G.Services.RunService.Heartbeat:Wait()
                                end
                            end

                            hrp.CFrame = startCF
                            hrp.AssemblyLinearVelocity = Vector3.zero
                        end
                    end
                end
            end
            task.wait(0.2)
        end
    end)

    -- 3. ПОТОК: ПАССИВНЫЙ TOUCH МАГНИТ
    task.spawn(function()
        while S.Runtime.running do
            if states.instantMagnet then
                local char = player.Character
                local hrp = char and char:FindFirstChild("HumanoidRootPart")
                if hrp then
                    for _, obj in ipairs(G.Services.Workspace:GetChildren()) do
                        if canCollect(obj) then
                            if typeof(firetouchinterest) == "function" then
                                firetouchinterest(hrp, obj, 0)
                                firetouchinterest(hrp, obj, 1)
                            end
                        end
                    end
                end
            end
            task.wait(0.08)
        end
    end)

    -- 4. ПОТОК: АВТО-СБОР НАГРАД
    task.spawn(function()
        while S.Runtime.running do
            if states.autoRewards then
                claimTimedRewards()
            end
            task.wait(3.0)
        end
    end)

    -- 5. ПОТОК: АНТИ-РЭГДОЛЛ
    task.spawn(function()
        while S.Runtime.running do
            if states.antiRagdoll then
                local char = player.Character
                if char then
                    local canRag = char:FindFirstChild("CanRagdoll")
                    if canRag then canRag.Value = false end

                    local lowerTorso = char:FindFirstChild("LowerTorso")
                    if lowerTorso then
                        for _, desc in ipairs(lowerTorso:GetChildren()) do
                            if desc:IsA("BallSocketConstraint") then desc:Destroy() end
                        end
                    end

                    local hum = char:FindFirstChild("Humanoid")
                    if hum and hum.PlatformStand then
                        hum.PlatformStand = false
                        hum:ChangeState(Enum.HumanoidStateType.GettingUp)
                    end
                end
            end
            task.wait(0.1)
        end
    end)

    -- 6. ПОТОК: АВТО-УКЛОНЕНИЕ ОТ ГИГАНТОВ
    task.spawn(function()
        while S.Runtime.running do
            if states.antiGiant then
                local char = player.Character
                local hrp = char and char:FindFirstChild("HumanoidRootPart")
                if char and hrp then
                    local myPhys = char:FindFirstChild("PhysicalSize") and char.PhysicalSize.Value or 1

                    for _, p in ipairs(G.Services.Players:GetPlayers()) do
                        if p ~= player and p.Character and p.Character:FindFirstChild("HumanoidRootPart") then
                            local otherChar = p.Character
                            local otherPhys = otherChar:FindFirstChild("PhysicalSize") and otherChar.PhysicalSize.Value or 1

                            if otherPhys > myPhys then
                                local dist = (otherChar.HumanoidRootPart.Position - hrp.Position).Magnitude
                                if dist < 30 then
                                    local fleeDir = (hrp.Position - otherChar.HumanoidRootPart.Position).Unit
                                    hrp.CFrame = hrp.CFrame + (fleeDir * 25) + Vector3.new(0, 35, 0)
                                    break
                                end
                            end
                        end
                    end
                end
            end
            task.wait(0.15)
        end
    end)

    -- 7. ПОТОК: РАДАР И ESP ИГРОКОВ
    local ESPFolder = Instance.new("Folder")
    ESPFolder.Name = "AdminESPFolder"
    ESPFolder.Parent = S.ScreenGui

    local function clearESP()
        ESPFolder:ClearAllChildren()
    end

    task.spawn(function()
        while S.Runtime.running do
            if states.playerESP then
                clearESP()
                local myChar = player.Character
                local myPhys = myChar and myChar:FindFirstChild("PhysicalSize") and myChar.PhysicalSize.Value or 1

                for _, p in ipairs(G.Services.Players:GetPlayers()) do
                    if p ~= player and p.Character and p.Character:FindFirstChild("HumanoidRootPart") then
                        local targetChar = p.Character
                        local targetHum = targetChar:FindFirstChild("Humanoid")
                        local targetPhys = targetChar:FindFirstChild("PhysicalSize") and targetChar.PhysicalSize.Value or 1

                        if targetHum and targetHum.Health > 0 then
                            local bg = Instance.new("BillboardGui")
                            bg.Name = p.Name .. "_ESP"
                            bg.Adornee = targetChar.HumanoidRootPart
                            bg.Size = UDim2.new(0, 100, 0, 30)
                            bg.AlwaysOnTop = true
                            bg.Parent = ESPFolder

                            local txt = Instance.new("TextLabel")
                            txt.Size = UDim2.new(1, 0, 1, 0)
                            txt.BackgroundTransparency = 1
                            txt.Font = Enum.Font.GothamBold
                            txt.TextSize = 11

                            if targetPhys < myPhys then
                                txt.TextColor3 = Color3.fromRGB(0, 255, 120)
                                txt.Text = p.Name .. " [" .. getText("espEdible") .. "]\nWeight: " .. math.floor(targetPhys * 10) / 10
                            else
                                txt.TextColor3 = Color3.fromRGB(255, 60, 60)
                                txt.Text = p.Name .. " [" .. getText("espDanger") .. "]\nWeight: " .. math.floor(targetPhys * 10) / 10
                            end
                            txt.Parent = bg
                        end
                    end
                end
            else
                clearESP()
            end
            task.wait(0.5)
        end
        clearESP()
    end)

    -- ==============================================================================
    -- 8. ПОЛЕТ (FLY) — ИСПРАВЛЕННОЕ 3D-УПРАВЛЕНИЕ (MOBILE TOUCH + PC WASD/SPACE)
    -- ==============================================================================
    local flyBV = nil
    local flyBG = nil

    task.spawn(function()
        local uis = G.Services.UserInputService

        while S.Runtime.running do
            local char = player.Character
            local hrp = char and char:FindFirstChild("HumanoidRootPart")
            local hum = char and char:FindFirstChild("Humanoid")

            if states.fly and hrp and hum and hum.Health > 0 then
                -- Отключаем физику ходьбы, чтобы персонаж не спотыкался
                hum.PlatformStand = true

                -- Создаем контроллеры физики, если их еще нет
                if not flyBV or flyBV.Parent ~= hrp then
                    flyBV = Instance.new("BodyVelocity")
                    flyBV.Name = "AdminFlyBV_Fixed"
                    flyBV.MaxForce = Vector3.new(9e9, 9e9, 9e9)
                    flyBV.Velocity = Vector3.zero
                    flyBV.Parent = hrp

                    flyBG = Instance.new("BodyGyro")
                    flyBG.Name = "AdminFlyBG_Fixed"
                    flyBG.MaxTorque = Vector3.new(9e9, 9e9, 9e9)
                    flyBG.P = 50000
                    flyBG.D = 500
                    flyBG.CFrame = hrp.CFrame
                    flyBG.Parent = hrp
                end

                local cam = G.Services.Workspace.CurrentCamera or Camera
                local camCF = cam.CFrame
                local worldMove = hum.MoveDirection

                -- Переводим мировое движение стика/клавиш в локальные координаты камеры
                local localMove = camCF:VectorToObjectSpace(worldMove)

                local targetVelocity = Vector3.zero

                -- 1. Горизонтальное и наклонное движение по направлению камеры
                if worldMove.Magnitude > 0 then
                    -- localMove.Z: -1 = вперед (W), 1 = назад (S)
                    -- localMove.X: 1 = вправо (D), -1 = влево (A)
                    local forwardFly = camCF.LookVector * (-localMove.Z)
                    local strafeFly = camCF.RightVector * (localMove.X)
                    targetVelocity = (forwardFly + strafeFly).Unit * states.flySpeed
                end

                -- 2. Вертикальное перемещение (Вверх / Вниз)
                if not isTouchDevice then
                    -- Управление для ПК
                    if uis:IsKeyDown(Enum.KeyCode.Space) then
                        targetVelocity = targetVelocity + Vector3.new(0, states.flySpeed, 0)
                    end
                    if uis:IsKeyDown(Enum.KeyCode.LeftShift) or uis:IsKeyDown(Enum.KeyCode.LeftControl) then
                        targetVelocity = targetVelocity - Vector3.new(0, states.flySpeed, 0)
                    end
                else
                    -- Управление для телефонов (Кнопка прыжка поднимает вверх)
                    if hum.Jump then
                        targetVelocity = targetVelocity + Vector3.new(0, states.flySpeed * 0.8, 0)
                    end
                end

                flyBV.Velocity = targetVelocity
                flyBG.CFrame = camCF
            else
                -- При выключении очищаем физику и возвращаем персонажа на ноги
                if flyBV then flyBV:Destroy(); flyBV = nil end
                if flyBG then flyBG:Destroy(); flyBG = nil end
                if hum and hum.PlatformStand then
                    hum.PlatformStand = false
                    hum:ChangeState(Enum.HumanoidStateType.GettingUp)
                end
            end
            task.wait()
        end

        if flyBV then flyBV:Destroy() end
        if flyBG then flyBG:Destroy() end
        if player.Character and player.Character:FindFirstChild("Humanoid") then
            player.Character.Humanoid.PlatformStand = false
        end
    end)

    -- 9. NOCLIP (ПРОХОД СКВОЗЬ СТЕНЫ)
    S.Runtime.connections[#S.Runtime.connections + 1] = G.Services.RunService.Stepped:Connect(function()
        if states.noclip and player.Character then
            for _, part in ipairs(player.Character:GetDescendants()) do
                if part:IsA("BasePart") and part.CanCollide then
                    part.CanCollide = false
                end
            end
        end
    end)

    -- 10. INFINITE JUMP
    S.Runtime.connections[#S.Runtime.connections + 1] = G.Services.UserInputService.JumpRequest:Connect(function()
        if states.infJump and player.Character then
            local hum = player.Character:FindFirstChild("Humanoid")
            if hum then
                hum:ChangeState(Enum.HumanoidStateType.Jumping)
            end
        end
    end)

    -- 11. FPS И ПИНГ МОНИТОР
    local frameCount = 0
    local frameTime = 0
    local currentFPS = 60

    S.Runtime.connections[#S.Runtime.connections + 1] = G.Services.RunService.RenderStepped:Connect(function(dt)
        if not S.Runtime.running then return end
        frameCount = frameCount + 1
        frameTime = frameTime + dt
        if frameTime >= 1.0 then
            currentFPS = G.Math.clamp(G.Math.floor(frameCount / frameTime), 1, 999)
            frameCount = 0
            frameTime = 0
        end
    end)

    task.spawn(function()
        while S.Runtime.running do
            task.wait(1.0)
            local ping = 0
            pcall(function()
                local net = G.Services.Stats and G.Services.Stats:FindFirstChild("Network")
                local ssi = net and net:FindFirstChild("ServerStatsItem")
                local dp = ssi and ssi:FindFirstChild("Data Ping")
                if dp and dp.GetValue then ping = G.Math.floor(dp:GetValue()) end
            end)
            if ping <= 0 then
                pcall(function()
                    if player and player.GetNetworkPing then
                        ping = G.Math.floor(player:GetNetworkPing() * 1000)
                    end
                end)
            end
            if S.wmFrame and S.wmFrame:FindFirstChild("StatsTxt") then
                S.wmFrame.StatsTxt.Text = string.format("HUB  |  FPS: %d  |  Ping: %dms", currentFPS, math.max(1, ping))
            end
        end
    end)

    getgenv()._HUB_CLEAN_ACTIVE = {
        unload = function()
            pcall(function()
                S.Runtime.running = false
                S.ScreenGui:Destroy()
                if NotificationGui then NotificationGui:Destroy() end
                for _, conn in ipairs(S.Runtime.connections) do if conn.Connected then conn:Disconnect() end end
                table.clear(S.Runtime.connections)
            end)
        end
    }

    showNotification(string.format(getText("tipToggle"), states.menuKey), "Info")
end

BuildHubUI()