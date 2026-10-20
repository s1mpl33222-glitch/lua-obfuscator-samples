--[[
    RBX SCRIPT — MM2 Instant ESP + Coin Farm
    Telegram: https://t.me/Rbxscriptonik0 | https://t.me/LuaRobloxScripts
    Функции: Auto Coin Farm, ESP Murderer, ESP Sheriff (мгновенное определение)
]]

-- Services
local Players = game:GetService("Players")
local Workspace = game:GetService("Workspace")
local StarterGui = game:GetService("StarterGui")
local LocalPlayer = Players.LocalPlayer
local RunService = game:GetService("RunService")
local TweenService = game:GetService("TweenService")
local CoreGui = game:GetService("CoreGui")

-- State
local State = {
    CoinFarm = false,
    FlySpeed = 30,
    CollectDelay = 0.3,
    ESPMurderer = false,
    ESPSheriff = false,
    Minimized = false
}

-- ========== Уведомления ==========
local function Notify(title, text, dur)
    StarterGui:SetCore("SendNotification", {Title = title, Text = text, Duration = dur or 2})
end

-- ========== UI Components ==========
local function Corner(p, r)
    local c = Instance.new("UICorner"); c.CornerRadius = UDim.new(0, r); c.Parent = p
end
local function Stroke(p, t, clr)
    local s = Instance.new("UIStroke"); s.Thickness = t; s.Color = clr or Color3.fromRGB(100,100,100); s.Parent = p
end

-- Чекбокс
local function MakeCheckbox(parent, text, callback)
    local frame = Instance.new("Frame")
    frame.Size = UDim2.new(1, -20, 0, 28)
    frame.Position = UDim2.new(0, 10, 0, #parent:GetChildren() * 30 + 5)
    frame.BackgroundTransparency = 1
    frame.Parent = parent

    local label = Instance.new("TextLabel")
    label.Size = UDim2.new(0, 120, 1, 0)
    label.Position = UDim2.new(0, 0, 0, 0)
    label.BackgroundTransparency = 1
    label.Text = text
    label.TextColor3 = Color3.fromRGB(255, 255, 255)
    label.Font = Enum.Font.GothamBold
    label.TextSize = 14
    label.TextXAlignment = Enum.TextXAlignment.Left
    label.Parent = frame

    local box = Instance.new("Frame")
    box.Size = UDim2.new(0, 20, 0, 20)
    box.Position = UDim2.new(1, -25, 0.5, -10)
    box.BackgroundColor3 = Color3.fromRGB(30, 30, 30)
    box.BorderSizePixel = 0
    box.Parent = frame
    Corner(box, 3)
    Stroke(box, 1.5, Color3.fromRGB(150,150,150))

    local check = Instance.new("TextLabel")
    check.Size = UDim2.new(1, 0, 1, 0)
    check.BackgroundTransparency = 1
    check.Text = "✔"
    check.TextColor3 = Color3.fromRGB(0, 200, 0)
    check.Font = Enum.Font.GothamBold
    check.TextSize = 14
    check.Visible = false
    check.Parent = box

    local enabled = false
    local btn = Instance.new("TextButton")
    btn.Size = UDim2.new(1, 0, 1, 0)
    btn.BackgroundTransparency = 1
    btn.Text = ""
    btn.Parent = frame

    local function setState(state)
        enabled = state
        check.Visible = state
        if state then
            box.BackgroundColor3 = Color3.fromRGB(0, 120, 255)
            Stroke(box, 1.5, Color3.fromRGB(0, 120, 255))
        else
            box.BackgroundColor3 = Color3.fromRGB(30, 30, 30)
            Stroke(box, 1.5, Color3.fromRGB(150,150,150))
        end
    end

    btn.MouseButton1Click:Connect(function()
        enabled = not enabled
        setState(enabled)
        callback(enabled)
    end)

    return { SetState = setState }
end

-- Поле ввода
local function MakeInput(parent, labelText, defaultValue, placeholder)
    local frame = Instance.new("Frame")
    frame.Size = UDim2.new(1, -20, 0, 24)
    frame.Position = UDim2.new(0, 10, 0, #parent:GetChildren() * 30 + 5)
    frame.BackgroundTransparency = 1
    frame.Parent = parent

    local label = Instance.new("TextLabel")
    label.Size = UDim2.new(0, 120, 1, 0)
    label.Position = UDim2.new(0, 0, 0, 0)
    label.BackgroundTransparency = 1
    label.Text = labelText
    label.TextColor3 = Color3.fromRGB(255, 255, 255)
    label.Font = Enum.Font.GothamBold
    label.TextSize = 13
    label.TextXAlignment = Enum.TextXAlignment.Left
    label.Parent = frame

    local input = Instance.new("TextBox")
    input.Size = UDim2.new(0, 60, 0, 20)
    input.Position = UDim2.new(1, -65, 0.5, -10)
    input.BackgroundColor3 = Color3.fromRGB(40, 40, 40)
    input.TextColor3 = Color3.fromRGB(255, 255, 255)
    input.Font = Enum.Font.Gotham
    input.TextSize = 12
    input.Text = defaultValue
    input.PlaceholderText = placeholder or defaultValue
    input.BorderSizePixel = 0
    input.Parent = frame
    Corner(input, 4)
    Stroke(input, 1, Color3.fromRGB(100,100,100))

    return input
end

-- ========== GUI ==========
local GUI = Instance.new("ScreenGui"); GUI.Name = "MinimalMM2Farm"; GUI.ResetOnSpawn = false; GUI.Parent = CoreGui
local Main = Instance.new("Frame")
Main.Size = UDim2.new(0, 220, 0, 260)  -- увеличили высоту для двух ссылок
Main.Position = UDim2.new(0.5, -110, 0.5, -130)
Main.BackgroundColor3 = Color3.fromRGB(15, 15, 15)
Main.BorderSizePixel = 0
Main.Active = true; Main.Draggable = true
Main.Parent = GUI
Corner(Main, 8)

-- Header
local Header = Instance.new("Frame")
Header.Size = UDim2.new(1, 0, 0, 28)
Header.BackgroundColor3 = Color3.fromRGB(25, 25, 25)
Header.BorderSizePixel = 0
Header.Parent = Main
Corner(Header, 8)

-- Заголовок
local Title = Instance.new("TextLabel")
Title.Size = UDim2.new(1, -54, 1, 0)
Title.Position = UDim2.new(0, 5, 0, 0)
Title.BackgroundTransparency = 1
Title.Text = "RBX SCRIPT"
Title.TextColor3 = Color3.fromRGB(255, 255, 255)
Title.Font = Enum.Font.GothamBold
Title.TextSize = 14
Title.TextXAlignment = Enum.TextXAlignment.Center
Title.Parent = Header

-- Кнопка сворачивания (минус)
local MinimizeBtn = Instance.new("TextButton")
MinimizeBtn.Size = UDim2.new(0, 22, 0, 22)
MinimizeBtn.Position = UDim2.new(1, -48, 0.5, -11)
MinimizeBtn.BackgroundColor3 = Color3.fromRGB(45, 45, 45)
MinimizeBtn.Text = "—"
MinimizeBtn.TextColor3 = Color3.fromRGB(220,220,220)
MinimizeBtn.Font = Enum.Font.GothamBold
MinimizeBtn.TextSize = 16
MinimizeBtn.BorderSizePixel = 0
MinimizeBtn.Parent = Header
Corner(MinimizeBtn, 4)

-- Кнопка закрытия (крестик)
local CloseBtn = Instance.new("TextButton")
CloseBtn.Size = UDim2.new(0, 22, 0, 22)
CloseBtn.Position = UDim2.new(1, -24, 0.5, -11)
CloseBtn.BackgroundColor3 = Color3.fromRGB(45, 45, 45)
CloseBtn.Text = "X"
CloseBtn.TextColor3 = Color3.fromRGB(220,220,220)
CloseBtn.Font = Enum.Font.GothamBold
CloseBtn.TextSize = 14
CloseBtn.BorderSizePixel = 0
CloseBtn.Parent = Header
Corner(CloseBtn, 4)
CloseBtn.MouseButton1Click:Connect(function()
    State.CoinFarm = false
    State.ESPMurderer = false
    State.ESPSheriff = false
    GUI:Destroy()
end)

-- Контейнер контента
local Content = Instance.new("Frame")
Content.Size = UDim2.new(1, -10, 1, -35)
Content.Position = UDim2.new(0, 5, 0, 32)
Content.BackgroundTransparency = 1
Content.Parent = Main

-- Auto Farm Toggle
MakeCheckbox(Content, "Auto Farm Coins", function(state)
    State.CoinFarm = state
end)

-- Speed и Delay
local speedInput = MakeInput(Content, "Speed:", "30", "30")
local delayInput = MakeInput(Content, "Delay:", "0.3", "0.3")

speedInput.FocusLost:Connect(function()
    local val = tonumber(speedInput.Text)
    if val and val > 0 then State.FlySpeed = val end
end)
delayInput.FocusLost:Connect(function()
    local val = tonumber(delayInput.Text)
    if val and val > 0 then State.CollectDelay = val end
end)

-- ESP чекбоксы
MakeCheckbox(Content, "ESP Murderer", function(state)
    State.ESPMurderer = state
end)
MakeCheckbox(Content, "ESP Sheriff", function(state)
    State.ESPSheriff = state
end)

-- ===== НОВЫЙ ФУТЕР С ДВУМЯ ССЫЛКАМИ =====
local Footer = Instance.new("Frame")
Footer.Size = UDim2.new(1, -10, 0, 32)    -- чуть выше для двух строк
Footer.Position = UDim2.new(0, 5, 1, -36)
Footer.BackgroundTransparency = 1
Footer.Parent = Main

-- Первая ссылка
local Link1 = Instance.new("TextButton")
Link1.Size = UDim2.new(1, 0, 0, 14)
Link1.Position = UDim2.new(0, 0, 0, 0)
Link1.BackgroundTransparency = 1
Link1.Text = "t.me/Rbxscriptonik0"
Link1.TextColor3 = Color3.fromRGB(180, 180, 255)
Link1.Font = Enum.Font.Gotham
Link1.TextSize = 10
Link1.TextXAlignment = Enum.TextXAlignment.Center
Link1.Parent = Footer

Link1.MouseButton1Click:Connect(function()
    pcall(function()
        if setclipboard then setclipboard("https://t.me/Rbxscriptonik0")
        elseif ClipboardService then ClipboardService:SetAsync("https://t.me/Rbxscriptonik0")
        else game:GetService("Clipboard"):SetAsync("https://t.me/Rbxscriptonik0") end
        Notify("Copied!", "t.me/Rbxscriptonik0", 2)
    end)
end)

-- Вторая ссылка
local Link2 = Instance.new("TextButton")
Link2.Size = UDim2.new(1, 0, 0, 14)
Link2.Position = UDim2.new(0, 0, 0, 16)
Link2.BackgroundTransparency = 1
Link2.Text = "t.me/LuaRobloxScripts"
Link2.TextColor3 = Color3.fromRGB(180, 180, 255)
Link2.Font = Enum.Font.Gotham
Link2.TextSize = 10
Link2.TextXAlignment = Enum.TextXAlignment.Center
Link2.Parent = Footer

Link2.MouseButton1Click:Connect(function()
    pcall(function()
        if setclipboard then setclipboard("https://t.me/LuaRobloxScripts")
        elseif ClipboardService then ClipboardService:SetAsync("https://t.me/LuaRobloxScripts")
        else game:GetService("Clipboard"):SetAsync("https://t.me/LuaRobloxScripts") end
        Notify("Copied!", "t.me/LuaRobloxScripts", 2)
    end)
end)

-- Сворачивание
MinimizeBtn.MouseButton1Click:Connect(function()
    State.Minimized = not State.Minimized
    Content.Visible = not State.Minimized
    Footer.Visible = not State.Minimized
    if State.Minimized then
        Main:TweenSize(UDim2.new(0, 220, 0, 28), "Out", "Quad", 0.3, true)
        MinimizeBtn.Text = "▲"
    else
        Main:TweenSize(UDim2.new(0, 220, 0, 260), "Out", "Quad", 0.3, true)
        MinimizeBtn.Text = "—"
    end
end)

-- ========== ЛОГИКА ФАРМА ==========
local coinCache = {}
local lastScan = 0
local currentTween = nil

local function forceNoClip()
    local char = LocalPlayer.Character
    if char then
        for _, part in pairs(char:GetDescendants()) do
            if part:IsA("BasePart") then part.CanCollide = false end
        end
    end
end

local function findCoins()
    local coins = {}
    for _, obj in pairs(Workspace:GetDescendants()) do
        if obj:IsA("BasePart") and not obj:IsA("Terrain") and obj.CanCollide == false then
            local n = obj.Name:lower()
            if n:find("coin") or n:find("money") or n:find("gem") or n:find("gold") or n:find("cash") or n:find("collect") or n:find("loot") then
                table.insert(coins, obj)
            end
        end
    end
    return coins
end

local function collectCoin(coin)
    if not coin or not coin.Parent then return false end
    local char = LocalPlayer.Character
    if not char then return false end
    local root = char:FindFirstChild("HumanoidRootPart")
    if not root then return false end

    root.CFrame = CFrame.new(coin.Position + Vector3.new(0, 2, 0))
    task.wait(0.05)
    firetouchinterest(root, coin, 0)
    firetouchinterest(root, coin, 1)
    local cd = coin:FindFirstChildOfClass("ClickDetector")
    if cd then fireclickdetector(cd) end
    local prompt = coin:FindFirstChildOfClass("ProximityPrompt") or (coin.Parent and coin.Parent:FindFirstChildOfClass("ProximityPrompt"))
    if prompt then fireproximityprompt(prompt) end
    task.wait(0.1)
    return not coin.Parent
end

local function moveToPosition(targetPos)
    local char = LocalPlayer.Character
    if not char then return false end
    local root = char:FindFirstChild("HumanoidRootPart")
    if not root then return false end

    if currentTween then currentTween:Cancel(); currentTween = nil end
    local dist = (root.Position - targetPos).Magnitude
    if dist < 0.5 then return true end

    local speed = State.FlySpeed * (0.8 + math.random() * 0.4)
    local duration = math.clamp(dist / speed, 0.2, 3.0)
    local tweenInfo = TweenInfo.new(duration, Enum.EasingStyle.Linear, Enum.EasingDirection.Out)
    local tween = TweenService:Create(root, tweenInfo, {CFrame = CFrame.new(targetPos)})
    currentTween = tween
    local finished = false
    tween.Completed:Connect(function() finished = true; currentTween = nil end)
    tween:Play()
    local startTime = tick()
    while not finished do
        if not root.Parent then if currentTween then currentTween:Cancel() end return false end
        forceNoClip()
        if tick() - startTime > 5 then if currentTween then currentTween:Cancel() end break end
        task.wait(0.1)
    end
    return true
end

task.spawn(function()
    while true do
        if State.CoinFarm then
            if tick() - lastScan > 0.8 then coinCache = findCoins(); lastScan = tick() end
        else coinCache = {}; lastScan = 0 end
        task.wait(0.5)
    end
end)

task.spawn(function()
    while true do
        if State.CoinFarm then
            local char = LocalPlayer.Character
            if char and char:FindFirstChild("HumanoidRootPart") then
                local root = char.HumanoidRootPart
                forceNoClip()
                if root.Position.Y < -10 then root.CFrame = CFrame.new(root.Position.X, 5, root.Position.Z) end
                if #coinCache > 0 then
                    local nearest = coinCache[1]
                    local minDist = (root.Position - nearest.Position).Magnitude
                    for _, coin in pairs(coinCache) do
                        local d = (root.Position - coin.Position).Magnitude
                        if d < minDist then nearest = coin; minDist = d end
                    end
                    if nearest and nearest.Parent then
                        local safePos = nearest.Position + Vector3.new(0, 3 + math.random() * 2, 0)
                        moveToPosition(safePos)
                        collectCoin(nearest)
                        for i, c in pairs(coinCache) do if c == nearest then table.remove(coinCache, i); break end end
                        local delay = State.CollectDelay * (0.8 + math.random() * 0.4)
                        task.wait(delay)
                    end
                else
                    root.CFrame = root.CFrame + Vector3.new(math.random(-3,3), 0, math.random(-3,3))
                    task.wait(1.5 + math.random())
                end
            else
                task.wait(1)
            end
        else
            local char = LocalPlayer.Character
            if char then for _, part in pairs(char:GetDescendants()) do if part:IsA("BasePart") then part.CanCollide = true end end end
            task.wait(0.5)
        end
        task.wait(0.1)
    end
end)

-- ========== ESP LOGIC (Мгновенное определение через Backpack и Character) ==========
local espObjects = {}

local function clearESP()
    for _, obj in pairs(espObjects) do
        if obj and obj.Parent then obj:Destroy() end
    end
    espObjects = {}
end

local function getRole(player)
    if not player.Character then
        return "Innocent"
    end

    local tool = player.Backpack and player.Backpack:FindFirstChildOfClass("Tool")
    if not tool then
        tool = player.Character:FindFirstChildOfClass("Tool")
    end

    if tool then
        local name = tool.Name:lower()
        if name:find("gun") or name:find("pistol") or name:find("revolver") or name:find("sheriff") then
            return "Sheriff"
        end
        return "Murderer"
    end

    return "Innocent"
end

local function updateESP()
    clearESP()
    for _, player in pairs(Players:GetPlayers()) do
        if player ~= LocalPlayer and player.Character and player.Character:FindFirstChild("Head") then
            local role = getRole(player)
            local head = player.Character.Head
            local show = false
            local color = Color3.fromRGB(255, 255, 255)

            if role == "Murderer" and State.ESPMurderer then
                show = true
                color = Color3.fromRGB(255, 50, 50)
            elseif role == "Sheriff" and State.ESPSheriff then
                show = true
                color = Color3.fromRGB(50, 50, 255)
            end

            if show then
                -- BillboardGui
                local billboard = Instance.new("BillboardGui")
                billboard.Size = UDim2.new(0, 100, 0, 20)
                billboard.StudsOffset = Vector3.new(0, 2.5, 0)
                billboard.AlwaysOnTop = true
                billboard.MaxDistance = 300
                local txt = Instance.new("TextLabel")
                txt.Size = UDim2.new(1, 0, 1, 0)
                txt.BackgroundTransparency = 1
                txt.Text = role
                txt.TextColor3 = color
                txt.Font = Enum.Font.GothamBold
                txt.TextSize = 12
                txt.Parent = billboard
                billboard.Parent = head
                table.insert(espObjects, billboard)

                -- Highlight
                local highlight = Instance.new("Highlight")
                highlight.FillColor = color
                highlight.OutlineColor = Color3.fromRGB(255, 255, 255)
                highlight.FillTransparency = 0.5
                highlight.Adornee = player.Character
                highlight.Parent = player.Character
                table.insert(espObjects, highlight)
            end
        end
    end
end

task.spawn(function()
    while true do
        if State.ESPMurderer or State.ESPSheriff then
            updateESP()
        else
            clearESP()
        end
        task.wait(0.5)
    end
end)

-- ========== RESPAWN ==========
LocalPlayer.CharacterAdded:Connect(function(char)
    coinCache = {}; lastScan = 0
    if currentTween then currentTween:Cancel(); currentTween = nil end
    if State.CoinFarm then task.wait(0.5); forceNoClip() end
end)

Notify("RBX SCRIPT", "Instant ESP + Farm loaded!", 3)
