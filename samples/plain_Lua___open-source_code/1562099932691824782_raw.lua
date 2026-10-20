-- =============================================
-- 🫐 ESP STANDALONE (แยกออกมาเฉพาะระบบ ESP)
-- =============================================

local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local Workspace = game:GetService("Workspace")
local Camera = Workspace.CurrentCamera
local LocalPlayer = Players.LocalPlayer

-- =============================================
-- ✅ ESP CACHE
-- =============================================
local espCache = {}

-- =============================================
-- ✅ ESP DROPPED ITEMS (สีรุ้ง + ระยะ 400)
-- =============================================
local droppedItemESPSettings = {
    Enabled = false,
    Drawings = {}
}

local function updateDroppedItemESP()
    local droppedItemsFolder = Workspace:FindFirstChild("DroppedItems")
    if not droppedItemsFolder then return end

    local activeItems = {}
    local myRoot = LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("HumanoidRootPart")
    if not myRoot then return end
    
    local rainbowColor = Color3.fromHSV((tick() % 5) / 5, 1, 1)

    for _, item in ipairs(droppedItemsFolder:GetChildren()) do
        if item:IsA("Model") then
            local primaryPart = item:FindFirstChildWhichIsA("BasePart")
            if primaryPart then
                local distance = (myRoot.Position - primaryPart.Position).Magnitude
                if distance <= 400 then
                    activeItems[item] = primaryPart
                    
                    if not droppedItemESPSettings.Drawings[item] then
                        local textDrawing = Drawing.new("Text")
                        textDrawing.Center = true
                        textDrawing.Outlined = true
                        textDrawing.OutlineColor = Color3.fromRGB(0, 0, 0)
                        textDrawing.Size = 14
                        textDrawing.Font = 2
                        textDrawing.Visible = false
                        
                        droppedItemESPSettings.Drawings[item] = {
                            Text = textDrawing,
                            Part = primaryPart
                        }
                    end
                end
            end
        end
    end

    for item, data in pairs(droppedItemESPSettings.Drawings) do
        if not item.Parent or not data.Part or not data.Part.Parent then
            if data.Text then data.Text:Remove() end
            droppedItemESPSettings.Drawings[item] = nil
        else
            if droppedItemESPSettings.Enabled then
                local pos, onScreen = Camera:WorldToViewportPoint(data.Part.Position)
                if onScreen and pos.Z > 0 then
                    local dist = myRoot and math.floor((myRoot.Position - data.Part.Position).Magnitude) or 0
                    data.Text.Text = "[" .. item.Name .. " (" .. dist .. "m)]"
                    data.Text.Position = Vector2.new(pos.X, pos.Y)
                    data.Text.Color = rainbowColor
                    data.Text.Visible = true
                else
                    data.Text.Visible = false
                end
            else
                data.Text.Visible = false
            end
        end
    end
end

-- =============================================
-- ✅ ESP NAME (Drawing)
-- =============================================
local function createESPName(player)
    if espCache[player] and espCache[player].nameDrawing then
        return
    end
    
    local textDrawing = Drawing.new("Text")
    textDrawing.Center = true
    textDrawing.Outlined = true
    textDrawing.OutlineColor = Color3.fromRGB(0, 0, 0)
    textDrawing.Size = 18
    textDrawing.Font = 2
    textDrawing.Visible = false
    textDrawing.Color = Color3.fromRGB(255, 255, 255)
    textDrawing.Text = player.Name
    
    local function updateNameESP()
        if not player.Character then
            textDrawing.Visible = false
            return
        end
        
        local head = player.Character:FindFirstChild("Head")
        if not head then
            textDrawing.Visible = false
            return
        end
        
        local pos, onScreen = Camera:WorldToViewportPoint(head.Position + Vector3.new(0, 3, 0))
        if onScreen and pos.Z > 0 then
            textDrawing.Position = Vector2.new(pos.X, pos.Y - 20)
            textDrawing.Visible = true
        else
            textDrawing.Visible = false
        end
    end
    
    local updateConnection = RunService.RenderStepped:Connect(updateNameESP)
    
    if not espCache[player] then
        espCache[player] = {}
    end
    espCache[player].nameDrawing = textDrawing
    espCache[player].nameConnection = updateConnection
end

-- =============================================
-- ✅ ESP DISTANCE (Drawing)
-- =============================================
local function createESPDistance(player)
    if espCache[player] and espCache[player].distanceDrawing then
        return
    end
    
    local textDrawing = Drawing.new("Text")
    textDrawing.Center = true
    textDrawing.Outlined = true
    textDrawing.OutlineColor = Color3.fromRGB(0, 0, 0)
    textDrawing.Size = 15
    textDrawing.Font = 2
    textDrawing.Visible = false
    textDrawing.Color = Color3.fromRGB(255, 255, 255)
    textDrawing.Text = "[?m]"
    
    local function updateDistanceESP()
        if not player.Character then
            textDrawing.Visible = false
            textDrawing.Text = "[Dead]"
            return
        end
        
        local rootPart = player.Character:FindFirstChild("HumanoidRootPart")
        if not rootPart then
            textDrawing.Visible = false
            return
        end
        
        if LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("HumanoidRootPart") then
            local myRoot = LocalPlayer.Character.HumanoidRootPart
            local distance = (myRoot.Position - rootPart.Position).Magnitude
            textDrawing.Text = "[" .. math.floor(distance) .. "m]"
        end
        
        local pos, onScreen = Camera:WorldToViewportPoint(rootPart.Position + Vector3.new(0, -4.5, 0))
        if onScreen and pos.Z > 0 then
            textDrawing.Position = Vector2.new(pos.X, pos.Y)
            textDrawing.Visible = true
        else
            textDrawing.Visible = false
        end
    end
    
    local updateConnection = RunService.RenderStepped:Connect(updateDistanceESP)
    
    if not espCache[player] then
        espCache[player] = {}
    end
    espCache[player].distanceDrawing = textDrawing
    espCache[player].distanceConnection = updateConnection
end

-- =============================================
-- ลบ ESP ทั้งหมดของผู้เล่น
-- =============================================
local function removeAllESP(player)
    if espCache[player] then
        if espCache[player].nameDrawing then
            espCache[player].nameDrawing:Remove()
        end
        if espCache[player].distanceDrawing then
            espCache[player].distanceDrawing:Remove()
        end
        if espCache[player].nameConnection then
            espCache[player].nameConnection:Disconnect()
        end
        if espCache[player].distanceConnection then
            espCache[player].distanceConnection:Disconnect()
        end
        espCache[player] = nil
    end
end

-- =============================================
-- สร้าง ESP Health Bar สำหรับผู้เล่น
-- =============================================
local ESPHealth = {}
local healthESPEnabled = false

local function createESPHealth(player)
    if ESPHealth[player] then return end
    
    local outline = Drawing.new("Square")
    outline.Filled = false
    outline.Thickness = 1
    outline.Color = Color3.fromRGB(0, 0, 0)
    outline.Transparency = 0.9
    outline.Visible = false
    
    local fill = Drawing.new("Square")
    fill.Filled = true
    fill.Transparency = 0.9
    fill.Visible = false
    
    local drawings = {outline, fill}
    
    local conn = RunService.RenderStepped:Connect(function()
        if not player or not player.Character or not player.Character:FindFirstChild("HumanoidRootPart") then
            for _, d in pairs(drawings) do d.Visible = false end
            return
        end
        
        local root = player.Character.HumanoidRootPart
        local humanoid = player.Character:FindFirstChild("Humanoid")
        
        local pos, onScreen = Camera:WorldToViewportPoint(root.Position)
        if not onScreen or pos.Z <= 0 then
            for _, d in pairs(drawings) do d.Visible = false end
            return
        end
        
        local x = pos.X
        local y = pos.Y
        
        if healthESPEnabled and humanoid and humanoid.Health > 0 then
            local ratio = humanoid.Health / (humanoid.MaxHealth > 0 and humanoid.MaxHealth or 1)
            local h = 4
            local w = 60
            local startX = x - w / 2
            
            outline.Position = Vector2.new(startX, y - h - 2)
            outline.Size = Vector2.new(w, h)
            outline.Visible = true
            
            fill.Position = Vector2.new(startX, y - h - 2)
            fill.Size = Vector2.new(w * ratio, h)
            fill.Color = Color3.fromHSV(ratio * 0.333, 0.8, 0.9)
            fill.Visible = true
        else
            outline.Visible = false
            fill.Visible = false
        end
    end)
    
    ESPHealth[player] = {conn = conn, drawings = drawings}
end

-- =============================================
-- ✅ HIGHLIGHT ESP
-- =============================================
local Highlights = {}
local highlightEnabled = false

local function updateHighlight(player)
    if player == LocalPlayer then return end
    if not player.Character then return end
    local root = player.Character:FindFirstChild("HumanoidRootPart")
    if not root then return end
    
    if Highlights[player] then Highlights[player]:Destroy() Highlights[player] = nil end
    
    if highlightEnabled then
        local hl = Instance.new("Highlight")
        hl.Name = "PlayerHighlight"
        hl.Adornee = player.Character
        hl.FillColor = Color3.fromRGB(0, 170, 255)
        hl.OutlineColor = Color3.fromRGB(0, 170, 255)
        hl.Parent = Workspace
        Highlights[player] = hl
    end
end

local function updateHighlights()
    for _, player in pairs(Players:GetPlayers()) do
        updateHighlight(player)
    end
end

-- =============================================
-- โหลด ESP
-- =============================================
local nameESPEnabled = false
local distanceESPEnabled = false

local function loadESP()
    for _, player in pairs(Players:GetPlayers()) do
        if player ~= LocalPlayer then
            if nameESPEnabled then createESPName(player) end
            if distanceESPEnabled then createESPDistance(player) end
            if not ESPHealth[player] then
                createESPHealth(player)
            end
        end
    end
    
    Players.PlayerAdded:Connect(function(player)
        if player ~= LocalPlayer then
            player.CharacterAdded:Connect(function()
                task.wait(0.1)
                if nameESPEnabled then createESPName(player) end
                if distanceESPEnabled then createESPDistance(player) end
                if not ESPHealth[player] then
                    createESPHealth(player)
                end
            end)
            
            if player.Character then
                task.wait(0.1)
                if nameESPEnabled then createESPName(player) end
                if distanceESPEnabled then createESPDistance(player) end
                if not ESPHealth[player] then
                    createESPHealth(player)
                end
            end
        end
    end)
    
    Players.PlayerRemoving:Connect(function(player)
        if ESPHealth[player] then
            for _, d in pairs(ESPHealth[player].drawings) do
                if d and d.Remove then
                    pcall(function() d:Remove() end)
                elseif typeof(d) == "table" and d.Visible ~= nil then
                    d.Visible = false
                end
            end
            
            if ESPHealth[player].conn then
                pcall(function() ESPHealth[player].conn:Disconnect() end)
            end
            ESPHealth[player] = nil
        end
        
        if Highlights[player] then
            Highlights[player]:Destroy()
            Highlights[player] = nil
        end
        
        removeAllESP(player)
    end)
end

-- =============================================
-- RenderStepped อัปเดต Dropped Items ESP
-- =============================================
RunService.RenderStepped:Connect(function()
    if droppedItemESPSettings.Enabled then
        updateDroppedItemESP()
    end
end)

-- =============================================
-- 🫐 สร้าง UI สำหรับ ESP
-- =============================================
local playerGui = LocalPlayer:WaitForChild("PlayerGui")

local screenGui = Instance.new("ScreenGui")
screenGui.Name = "ESP_Menu"
screenGui.ResetOnSpawn = false
screenGui.Parent = playerGui

local mainFrame = Instance.new("Frame")
mainFrame.Size = UDim2.new(0, 260, 0, 300)
mainFrame.Position = UDim2.new(0, 20, 0.5, -150)
mainFrame.BackgroundColor3 = Color3.fromRGB(20, 20, 30)
mainFrame.BackgroundTransparency = 0.15
mainFrame.BorderSizePixel = 0
mainFrame.Parent = screenGui

local corner = Instance.new("UICorner")
corner.CornerRadius = UDim.new(0, 12)
corner.Parent = mainFrame

local stroke = Instance.new("UIStroke")
stroke.Color = Color3.fromRGB(0, 170, 255)
stroke.Thickness = 1.5
stroke.Transparency = 0.3
stroke.Parent = mainFrame

local titleBar = Instance.new("Frame")
titleBar.Size = UDim2.new(1, 0, 0, 38)
titleBar.BackgroundColor3 = Color3.fromRGB(0, 120, 200)
titleBar.BackgroundTransparency = 0.3
titleBar.BorderSizePixel = 0
titleBar.Parent = mainFrame

local titleCorner = Instance.new("UICorner")
titleCorner.CornerRadius = UDim.new(0, 12)
titleCorner.Parent = titleBar

local titleLabel = Instance.new("TextLabel")
titleLabel.Size = UDim2.new(1, -40, 1, 0)
titleLabel.Position = UDim2.new(0, 12, 0, 0)
titleLabel.BackgroundTransparency = 1
titleLabel.Text = "🫐 ESP MENU"
titleLabel.Font = Enum.Font.GothamBold
titleLabel.TextSize = 16
titleLabel.TextColor3 = Color3.fromRGB(255, 255, 255)
titleLabel.TextXAlignment = Enum.TextXAlignment.Left
titleLabel.Parent = titleBar

local closeBtn = Instance.new("TextButton")
closeBtn.Size = UDim2.new(0, 26, 0, 26)
closeBtn.Position = UDim2.new(1, -32, 0, 6)
closeBtn.BackgroundColor3 = Color3.fromRGB(200, 50, 50)
closeBtn.BorderSizePixel = 0
closeBtn.Text = "X"
closeBtn.Font = Enum.Font.GothamBold
closeBtn.TextSize = 14
closeBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
closeBtn.Parent = titleBar

local closeCorner = Instance.new("UICorner")
closeCorner.CornerRadius = UDim.new(0, 6)
closeCorner.Parent = closeBtn

closeBtn.MouseButton1Click:Connect(function()
    screenGui.Enabled = false
end)

-- ปุ่มเปิดเมนู (ตอนปิด)
local openBtn = Instance.new("TextButton")
openBtn.Size = UDim2.new(0, 44, 0, 44)
openBtn.Position = UDim2.new(0, 20, 0, 20)
openBtn.BackgroundColor3 = Color3.fromRGB(0, 120, 200)
openBtn.BorderSizePixel = 0
openBtn.Text = "ESP"
openBtn.Font = Enum.Font.GothamBold
openBtn.TextSize = 12
openBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
openBtn.Visible = false
openBtn.Parent = screenGui

local openCorner = Instance.new("UICorner")
openCorner.CornerRadius = UDim.new(0, 22)
openCorner.Parent = openBtn

openBtn.MouseButton1Click:Connect(function()
    screenGui.Enabled = true
end)

-- =============================================
-- สร้าง Toggle Button
-- =============================================
local function createToggle(parent, text, yPos, default, callback)
    local btn = Instance.new("TextButton")
    btn.Size = UDim2.new(1, -24, 0, 34)
    btn.Position = UDim2.new(0, 12, 0, yPos)
    btn.BackgroundColor3 = Color3.fromRGB(40, 40, 55)
    btn.BorderSizePixel = 0
    btn.Text = text .. ": OFF"
    btn.Font = Enum.Font.Gotham
    btn.TextSize = 13
    btn.TextColor3 = Color3.fromRGB(200, 200, 220)
    btn.TextXAlignment = Enum.TextXAlignment.Left
    btn.Parent = parent
    
    local c = Instance.new("UICorner")
    c.CornerRadius = UDim.new(0, 8)
    c.Parent = btn
    
    local padding = Instance.new("UIPadding")
    padding.PaddingLeft = UDim.new(0, 10)
    padding.Parent = btn
    
    local state = default or false
    
    local function updateVisual()
        if state then
            btn.BackgroundColor3 = Color3.fromRGB(0, 150, 80)
            btn.Text = text .. ": ON"
        else
            btn.BackgroundColor3 = Color3.fromRGB(40, 40, 55)
            btn.Text = text .. ": OFF"
        end
    end
    
    updateVisual()
    
    btn.MouseButton1Click:Connect(function()
        state = not state
        updateVisual()
        callback(state)
    end)
    
    return btn
end

-- =============================================
-- สร้างปุ่ม ESP
-- =============================================
createToggle(mainFrame, "📦 Dropped Items ESP", 48, false, function(state)
    droppedItemESPSettings.Enabled = state
    if not state then
        for _, data in pairs(droppedItemESPSettings.Drawings) do
            if data.Text then
                data.Text.Visible = false
            end
        end
    end
end)

createToggle(mainFrame, "📛 Name ESP", 88, false, function(state)
    nameESPEnabled = state
    if state then
        for _, player in pairs(Players:GetPlayers()) do
            if player ~= LocalPlayer then
                createESPName(player)
            end
        end
    else
        for _, player in pairs(Players:GetPlayers()) do
            if player ~= LocalPlayer then
                if espCache[player] and espCache[player].nameDrawing then
                    espCache[player].nameDrawing:Remove()
                    espCache[player].nameDrawing = nil
                end
                if espCache[player] and espCache[player].nameConnection then
                    espCache[player].nameConnection:Disconnect()
                    espCache[player].nameConnection = nil
                end
            end
        end
    end
end)

createToggle(mainFrame, "❤️ Health ESP", 128, false, function(state)
    healthESPEnabled = state
end)

createToggle(mainFrame, "📏 Distance ESP", 168, false, function(state)
    distanceESPEnabled = state
    if state then
        for _, player in pairs(Players:GetPlayers()) do
            if player ~= LocalPlayer then
                createESPDistance(player)
            end
        end
    else
        for _, player in pairs(Players:GetPlayers()) do
            if player ~= LocalPlayer then
                if espCache[player] and espCache[player].distanceDrawing then
                    espCache[player].distanceDrawing:Remove()
                    espCache[player].distanceDrawing = nil
                end
                if espCache[player] and espCache[player].distanceConnection then
                    espCache[player].distanceConnection:Disconnect()
                    espCache[player].distanceConnection = nil
                end
            end
        end
    end
end)

createToggle(mainFrame, "✨ Highlight ESP", 208, false, function(state)
    highlightEnabled = state
    for _, player in pairs(Players:GetPlayers()) do
        updateHighlight(player)
    end
end)

-- =============================================
-- ปุ่มซ่อน/แสดงเมนู
-- =============================================
local hideBtn = Instance.new("TextButton")
hideBtn.Size = UDim2.new(1, -24, 0, 30)
hideBtn.Position = UDim2.new(0, 12, 0, 252)
hideBtn.BackgroundColor3 = Color3.fromRGB(60, 60, 80)
hideBtn.BorderSizePixel = 0
hideBtn.Text = "🔽 ซ่อนเมนู"
hideBtn.Font = Enum.Font.GothamBold
hideBtn.TextSize = 13
hideBtn.TextColor3 = Color3.fromRGB(200, 200, 220)
hideBtn.Parent = mainFrame

local hideCorner = Instance.new("UICorner")
hideCorner.CornerRadius = UDim.new(0, 8)
hideCorner.Parent = hideBtn

hideBtn.MouseButton1Click:Connect(function()
    mainFrame.Visible = false
    openBtn.Visible = true
end)

openBtn.MouseButton1Click:Connect(function()
    mainFrame.Visible = true
    openBtn.Visible = false
end)

-- =============================================
-- เริ่มต้นโหลด ESP
-- =============================================
loadESP()

-- อัปเดต Highlight ทุก 1 วินาที
task.spawn(function()
    while task.wait(1) do
        if highlightEnabled then
            updateHighlights()
        end
    end
end)

print("🫐 ESP Standalone โหลดสำเร็จ!")