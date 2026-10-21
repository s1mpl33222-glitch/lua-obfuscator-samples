-- [[ ของเล่นใหม่ Brookhaven แบบ Source code เอาไปแกะกันเองนะ Made by Lloyd(ลอยด์) ]]
if _G.PropClusterCleanup and type(_G.PropClusterCleanup) == "function" then
    pcall(_G.PropClusterCleanup)
end

-- Disconnect any lingering ghost connections from older uncleaned script executions
pcall(function()
    local uis = game:GetService("UserInputService")
    local rs = game:GetService("RunService")
    for _, c in ipairs(getconnections(uis.InputChanged)) do
        if not c.ForeignState and pcall(function() return c.Function end) and c.Function then
            local info = debug.getinfo(c.Function)
            if info and (info.source == "" or string.find(info.source, "PropFollowUI") or string.find(info.short_src, "PropFollowUI")) then
                c:Disconnect()
            end
        end
    end
    for _, c in ipairs(getconnections(uis.InputBegan)) do
        if not c.ForeignState and pcall(function() return c.Function end) and c.Function then
            local info = debug.getinfo(c.Function)
            if info and (info.source == "" or string.find(info.source, "PropFollowUI") or string.find(info.short_src, "PropFollowUI")) then
                c:Disconnect()
            end
        end
    end
    for _, c in ipairs(getconnections(rs.Heartbeat)) do
        if not c.ForeignState and pcall(function() return c.Function end) and c.Function then
            local info = debug.getinfo(c.Function)
            if info and (info.source == "" or string.find(info.source, "PropFollowUI") or string.find(info.short_src, "PropFollowUI")) then
                c:Disconnect()
            end
        end
    end
    for _, c in ipairs(getconnections(rs.RenderStepped)) do
        if not c.ForeignState and pcall(function() return c.Function end) and c.Function then
            local info = debug.getinfo(c.Function)
            if info and (info.source == "" or string.find(info.source, "PropFollowUI") or string.find(info.short_src, "PropFollowUI")) then
                c:Disconnect()
            end
        end
    end
end)

local _activeConnections = {}
local function trackConn(conn)
    table.insert(_activeConnections, conn)
    return conn
end

_G.PropClusterCleanup = function()
    for _, conn in ipairs(_activeConnections) do
        pcall(function() conn:Disconnect() end)
    end
    _activeConnections = {}
end

-- [[ Brookhaven RP - Prop Cluster Master Controller & Auto Builder (15-Piece Ultimate Edition) ]]
-- Upgraded Features:
-- 1. Full 15-Piece Cushion Cage Support (Triple-reinforced 4-wall structure)
-- 2. "Drive / Play as Prop" Mode:
--    - User stands completely still in place (hrp.Anchored = true)
--    - Real Roblox character movement: WASD (PC) & Mobile Touch Thumbstick
--    - Jump leaps up and lands normally with real workspace gravity
--    - Toggle between Ground Walking and Full 3D Flight Mode (โหมดบินอิสระ)
-- 3. Escape / Unstuck Feature (ออกจากกรงตัวเองทันที ไม่ติดขัด)
-- 4. Abduct / Pull Nearest Player Feature (ดึงคนใกล้ตัว 10-20 studs มาขังในกรงแล้วกลับมาอยู่คงที่)
--    - Real-time nearest player tracker & configurable distance (10, 15, 20, 30, 50 studs)
--    - Automatic or Manual Abduct button
-- 5. Touch & Mouse Screen Dragging + 6-Axis D-Pad Controller
-- 6. Auto Build Cage up to 15 props (Max allowed in Brookhaven)

local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local UserInputService = game:GetService("UserInputService")
local lp = Players.LocalPlayer

local parentGui = (gethui and gethui()) or (pcall(function() return game:GetService("CoreGui") end) and game:GetService("CoreGui")) or lp:WaitForChild("PlayerGui")

if parentGui:FindFirstChild("PropFollowerGUI") then
    parentGui.PropFollowerGUI:Destroy()
end

local screenGui = Instance.new("ScreenGui")
screenGui.Name = "PropFollowerGUI"
screenGui.ResetOnSpawn = false
screenGui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
screenGui.Parent = parentGui

-- [[ ControlModule for Player Inputs (WASD + Mobile Thumbstick) ]]
local cm = nil
pcall(function()
    local PlayerModule = lp.PlayerScripts:WaitForChild("PlayerModule", 2)
    local controlMod = PlayerModule and PlayerModule:WaitForChild("ControlModule", 2)
    if controlMod then cm = require(controlMod) end
end)

-- [[ State Variables ]]
local isFollowing = false
local isDriving = false
local isFlying = false
local targetPlayer = lp
local heightOffset = 0.0
local rotateWithPlayer = true
local networkThread = nil
local localRenderConn = nil
local driveRenderConn = nil
local trackedProps = {}

local clusterPos = Vector3.zero
local clusterYaw = 0
local clusterCFrame = CFrame.new()
local isDragMode = false
local isTapToPlace = false
local moveSpeed = 16
local speedMultiplier = 1.0
local holdingDir = nil
local lastNetSync = 0
local lastDriveNetSync = 0

-- Driving Physics Variables
local driveSpeed = 20
local vertVel = 0
local isOnGround = true
local jumpRequested = false
local savedWalkSpeed = 16
local propDriveProxy = nil

-- Abduct Feature Variables
local abductRange = 15 -- default 15 studs (user range 10-20+)
local isAutoAbduct = false
local lastAbductCheck = 0

-- [[ Prop Geometry Definitions ]]
local distSide = 1.55
local distFrontBack = 1.50

-- 11-Piece Cushion Cage
local symRel11 = {
    [1]  = CFrame.new(0, -2.8, 0) * CFrame.Angles(0, 0, 0), -- Floor
    [2]  = CFrame.new(0, -1.4, distFrontBack) * CFrame.Angles(0, math.rad(90), math.rad(-90)), -- Front lower
    [3]  = CFrame.new(0, -1.4, -distFrontBack) * CFrame.Angles(0, math.rad(-90), math.rad(-90)), -- Back lower
    [4]  = CFrame.new(distSide, -1.4, 0) * CFrame.Angles(0, math.rad(180), math.rad(-90)), -- Right lower
    [5]  = CFrame.new(-distSide, -1.4, 0) * CFrame.Angles(0, math.rad(0), math.rad(-90)), -- Left lower
    [6]  = CFrame.new(0, 0, 0) * CFrame.Angles(0, 0, math.rad(180)), -- Middle shelf
    [7]  = CFrame.new(0, 1.4, distFrontBack) * CFrame.Angles(0, math.rad(90), math.rad(-90)), -- Front upper
    [8]  = CFrame.new(0, 1.4, -distFrontBack) * CFrame.Angles(0, math.rad(-90), math.rad(-90)), -- Back upper
    [9]  = CFrame.new(distSide, 1.4, 0) * CFrame.Angles(0, math.rad(180), math.rad(-90)), -- Right upper
    [10] = CFrame.new(-distSide, 1.4, 0) * CFrame.Angles(0, math.rad(0), math.rad(-90)), -- Left upper
    [11] = CFrame.new(0, 2.8, 0) * CFrame.Angles(0, 0, math.rad(180)), -- Ceiling
}

-- 15-Piece Reinforced Cushion Cage (Props 1-11 = Base Cage, Props 12-15 = Harpoon Grabbers)
local symRel15 = {
    -- [1] to [11]: Symmetric Base Cage (stays at home position during abduct)
    [1]  = CFrame.new(0, -2.8, 0) * CFrame.Angles(0, 0, 0), -- Bottom Floor
    [2]  = CFrame.new(0, -1.4, distFrontBack) * CFrame.Angles(0, math.rad(90), math.rad(-90)), -- Front lower
    [3]  = CFrame.new(0, -1.4, -distFrontBack) * CFrame.Angles(0, math.rad(-90), math.rad(-90)), -- Back lower
    [4]  = CFrame.new(distSide, -1.4, 0) * CFrame.Angles(0, math.rad(180), math.rad(-90)), -- Right lower
    [5]  = CFrame.new(-distSide, -1.4, 0) * CFrame.Angles(0, math.rad(0), math.rad(-90)), -- Left lower
    [6]  = CFrame.new(0, 0, 0) * CFrame.Angles(0, 0, math.rad(180)), -- Middle shelf
    [7]  = CFrame.new(0, 1.4, distFrontBack) * CFrame.Angles(0, math.rad(90), math.rad(-90)), -- Front upper
    [8]  = CFrame.new(0, 1.4, -distFrontBack) * CFrame.Angles(0, math.rad(-90), math.rad(-90)), -- Back upper
    [9]  = CFrame.new(distSide, 1.4, 0) * CFrame.Angles(0, math.rad(180), math.rad(-90)), -- Right upper
    [10] = CFrame.new(-distSide, 1.4, 0) * CFrame.Angles(0, math.rad(0), math.rad(-90)), -- Left upper
    [11] = CFrame.new(0, 2.8, 0) * CFrame.Angles(0, 0, math.rad(180)), -- Top Ceiling

    -- [12] to [15]: The 4 Harpoon Grabbers / Mid Walls (Detach to grab target, then dock back)
    [12] = CFrame.new(0, 0, distFrontBack) * CFrame.Angles(0, math.rad(90), math.rad(-90)), -- Front mid
    [13] = CFrame.new(0, 0, -distFrontBack) * CFrame.Angles(0, math.rad(-90), math.rad(-90)), -- Back mid
    [14] = CFrame.new(distSide, 0, 0) * CFrame.Angles(0, math.rad(180), math.rad(-90)), -- Right mid
    [15] = CFrame.new(-distSide, 0, 0) * CFrame.Angles(0, math.rad(0), math.rad(-90)), -- Left mid
}

local function getMyPropsList()
    local found = {}
    local folder = workspace:FindFirstChild("WorkspaceCom") and workspace.WorkspaceCom:FindFirstChild("001_TrafficCones")
    if folder then
        for _, c in ipairs(folder:GetChildren()) do
            if c.Name == ("Prop" .. lp.Name) and c:FindFirstChild("SetCurrentCFrame") then
                table.insert(found, c)
            end
        end
    end
    for _, d in ipairs(workspace:GetChildren()) do
        if d:IsA("Model") and d.Name == ("Prop" .. lp.Name) and d:FindFirstChild("SetCurrentCFrame") and not table.find(found, d) then
            table.insert(found, d)
        end
    end
    return found
end

local seatConns = {}
local function hookSeatEvents()
    for _, c in ipairs(seatConns) do pcall(function() c:Disconnect() end) end
    seatConns = {}

    for _, item in ipairs(trackedProps) do
        if item.model and item.model.Parent then
            local seat = item.model:FindFirstChildWhichIsA("Seat", true)
            if seat then
                local conn = seat:GetPropertyChangedSignal("Occupant"):Connect(function()
                    if isAutoVoidOnSit and not isVoidingTrap and not isAbducting then
                        local occ = seat.Occupant
                        if occ and occ.Parent and occ.Parent ~= lp.Character then
                            local victimChar = occ.Parent
                            local victimP = Players:GetPlayerFromCharacter(victimChar)
                            local victimName = victimP and victimP.DisplayName or victimChar.Name
                            task.spawn(function()
                                performVoidDrop(victimName, victimChar, victimP)
                            end)
                        end
                    end
                end)
                table.insert(seatConns, trackConn(conn))
            end
        end
    end
end

local function bindAllProps(useSymmetricCage)
    local found = getMyPropsList()
    if #found == 0 then
        trackedProps = {}
        return 0
    end

    table.sort(found, function(a, b) return a:GetPivot().Y < b:GetPivot().Y end)
    trackedProps = {}

    local activeSym = (#found >= 15) and symRel15 or ((#found == 11) and symRel11 or nil)

    if useSymmetricCage and activeSym then
        local limit = math.min(#found, #activeSym)
        for i = 1, limit do
            table.insert(trackedProps, {
                model = found[i],
                setCF = found[i].SetCurrentCFrame,
                relCF = activeSym[i]
            })
        end
    else
        local centerPos = Vector3.zero
        for _, p in ipairs(found) do
            centerPos = centerPos + p:GetPivot().Position
        end
        centerPos = centerPos / #found
        local rootCF = CFrame.new(centerPos)

        for _, p in ipairs(found) do
            table.insert(trackedProps, {
                model = p,
                setCF = p.SetCurrentCFrame,
                relCF = rootCF:ToObjectSpace(p:GetPivot())
            })
        end
    end

    if #trackedProps > 0 then
        local p = trackedProps[10] and trackedProps[10].model or (trackedProps[6] and trackedProps[6].model or trackedProps[1].model)
        if p and p.Parent then
            clusterCFrame = p:GetPivot()
            clusterPos = clusterCFrame.Position
            local _, y, _ = clusterCFrame:ToEulerAnglesYXZ()
            clusterYaw = y
        end
    end

    pcall(function() hookSeatEvents() end)
    return #trackedProps
end

local function updateClusterVisuals(targetRootCF)
    for _, item in ipairs(trackedProps) do
        if item.model and item.model.Parent then
            item.model:PivotTo(targetRootCF * item.relCF)
        end
    end
end

local function syncClusterToNetwork(targetRootCF)
    for _, item in ipairs(trackedProps) do
        if item.setCF and item.setCF.Parent then
            local targetCF = targetRootCF * item.relCF
            task.spawn(function()
                pcall(item.setCF.InvokeServer, item.setCF, targetCF)
            end)
        end
    end
end

local function moveClusterTo(targetRootCF)
    clusterCFrame = targetRootCF
    clusterPos = targetRootCF.Position
    local _, y, _ = targetRootCF:ToEulerAnglesYXZ()
    clusterYaw = y
    updateClusterVisuals(targetRootCF)
    syncClusterToNetwork(targetRootCF)
end

bindAllProps(true)

-- [[ UI Construction ]]
local mainFrame = Instance.new("Frame")
mainFrame.Name = "MainFrame"
mainFrame.Size = UDim2.new(0, 325, 0, 530)
mainFrame.Position = UDim2.new(0.5, -160, 0.20, -200)
mainFrame.BackgroundColor3 = Color3.fromRGB(20, 22, 28)
mainFrame.BorderSizePixel = 0
mainFrame.ClipsDescendants = true
mainFrame.Active = true
mainFrame.Parent = screenGui
Instance.new("UICorner", mainFrame).CornerRadius = UDim.new(0, 14)
local stroke = Instance.new("UIStroke", mainFrame)
stroke.Color = Color3.fromRGB(60, 70, 95)
stroke.Thickness = 1.5

-- [[ Title Bar ]]
local titleBar = Instance.new("Frame", mainFrame)
titleBar.Name = "TitleBar"
titleBar.Size = UDim2.new(1, 0, 0, 40)
titleBar.BackgroundColor3 = Color3.fromRGB(28, 31, 42)
titleBar.BorderSizePixel = 0
Instance.new("UICorner", titleBar).CornerRadius = UDim.new(0, 14)

local titleText = Instance.new("TextLabel", titleBar)
titleText.Size = UDim2.new(1, -70, 1, 0)
titleText.Position = UDim2.new(0, 12, 0, 0)
titleText.BackgroundTransparency = 1
titleText.Text = "📦 Prop Cluster Master (15 Props)"
titleText.TextColor3 = Color3.fromRGB(240, 245, 255)
titleText.Font = Enum.Font.GothamBold
titleText.TextSize = 13
titleText.TextXAlignment = Enum.TextXAlignment.Left

local closeBtn = Instance.new("TextButton", titleBar)
closeBtn.Size = UDim2.new(0, 24, 0, 24)
closeBtn.Position = UDim2.new(1, -30, 0, 8)
closeBtn.BackgroundColor3 = Color3.fromRGB(215, 55, 65)
closeBtn.Text = "✕"
closeBtn.TextColor3 = Color3.new(1, 1, 1)
closeBtn.Font = Enum.Font.GothamBold
closeBtn.TextSize = 11
Instance.new("UICorner", closeBtn).CornerRadius = UDim.new(0, 5)

local minBtn = Instance.new("TextButton", titleBar)
minBtn.Size = UDim2.new(0, 24, 0, 24)
minBtn.Position = UDim2.new(1, -58, 0, 8)
minBtn.BackgroundColor3 = Color3.fromRGB(48, 52, 70)
minBtn.Text = "—"
minBtn.TextColor3 = Color3.new(1, 1, 1)
minBtn.Font = Enum.Font.GothamBold
minBtn.TextSize = 11
Instance.new("UICorner", minBtn).CornerRadius = UDim.new(0, 5)

-- Window Dragging
local dragging, dragInput, dragStart, startPos
titleBar.InputBegan:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
        dragging = true; dragStart = input.Position; startPos = mainFrame.Position
        input.Changed:Connect(function()
            if input.UserInputState == Enum.UserInputState.End then dragging = false end
        end)
    end
end)
titleBar.InputChanged:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch then
        dragInput = input
    end
end)
trackConn(UserInputService.InputChanged:Connect(function(input)
    if input == dragInput and dragging then
        local delta = input.Position - dragStart
        mainFrame.Position = UDim2.new(startPos.X.Scale, startPos.X.Offset + delta.X, startPos.Y.Scale, startPos.Y.Offset + delta.Y)
    end
end))

local content = Instance.new("Frame", mainFrame)
content.Name = "Content"
content.Size = UDim2.new(1, -16, 1, -48)
content.Position = UDim2.new(0, 8, 0, 44)
content.BackgroundTransparency = 1

-- [[ Status & Build Row ]]
local statusCard = Instance.new("Frame", content)
statusCard.Size = UDim2.new(1, 0, 0, 28)
statusCard.BackgroundColor3 = Color3.fromRGB(26, 29, 40)
Instance.new("UICorner", statusCard).CornerRadius = UDim.new(0, 7)

local statusLabel = Instance.new("TextLabel", statusCard)
statusLabel.Size = UDim2.new(1, -70, 1, 0)
statusLabel.Position = UDim2.new(0, 8, 0, 0)
statusLabel.BackgroundTransparency = 1
statusLabel.Text = "🔗 เชื่อมต่อ Prop: " .. #trackedProps .. " ชิ้น (ทั้งก้อน)"
statusLabel.TextColor3 = Color3.fromRGB(120, 230, 160)
statusLabel.Font = Enum.Font.GothamBold
statusLabel.TextSize = 11
statusLabel.TextXAlignment = Enum.TextXAlignment.Left

local rescanBtn = Instance.new("TextButton", statusCard)
rescanBtn.Size = UDim2.new(0, 62, 0, 22)
rescanBtn.Position = UDim2.new(1, -66, 0, 3)
rescanBtn.BackgroundColor3 = Color3.fromRGB(42, 50, 70)
rescanBtn.Text = "🔄 สแกนใหม่"
rescanBtn.TextColor3 = Color3.new(1, 1, 1)
rescanBtn.Font = Enum.Font.GothamBold
rescanBtn.TextSize = 9
Instance.new("UICorner", rescanBtn).CornerRadius = UDim.new(0, 5)

-- Top Action Row (Build 15, Align, and Escape from Cage!)
local quickActionRow = Instance.new("Frame", content)
quickActionRow.Size = UDim2.new(1, 0, 0, 30)
quickActionRow.Position = UDim2.new(0, 0, 0, 32)
quickActionRow.BackgroundTransparency = 1

local buildBtn = Instance.new("TextButton", quickActionRow)
buildBtn.Size = UDim2.new(0.40, -2, 1, 0)
buildBtn.BackgroundColor3 = Color3.fromRGB(125, 55, 215)
buildBtn.Text = "🔨 สร้างกรง 15 ชิ้น"
buildBtn.TextColor3 = Color3.new(1, 1, 1)
buildBtn.Font = Enum.Font.GothamBold
buildBtn.TextSize = 10
Instance.new("UICorner", buildBtn).CornerRadius = UDim.new(0, 6)

local alignBtn = Instance.new("TextButton", quickActionRow)
alignBtn.Size = UDim2.new(0.30, -2, 1, 0)
alignBtn.Position = UDim2.new(0.40, 2, 0, 0)
alignBtn.BackgroundColor3 = Color3.fromRGB(45, 110, 210)
alignBtn.Text = "🎯 จัดตรงเป๊ะ"
alignBtn.TextColor3 = Color3.new(1, 1, 1)
alignBtn.Font = Enum.Font.GothamBold
alignBtn.TextSize = 10
Instance.new("UICorner", alignBtn).CornerRadius = UDim.new(0, 6)

local escapeBtn = Instance.new("TextButton", quickActionRow)
escapeBtn.Size = UDim2.new(0.30, -2, 1, 0)
escapeBtn.Position = UDim2.new(0.70, 2, 0, 0)
escapeBtn.BackgroundColor3 = Color3.fromRGB(205, 90, 30)
escapeBtn.Text = "🔓 ออกจากกรง"
escapeBtn.TextColor3 = Color3.new(1, 1, 1)
escapeBtn.Font = Enum.Font.GothamBold
escapeBtn.TextSize = 10
Instance.new("UICorner", escapeBtn).CornerRadius = UDim.new(0, 6)

-- [[ Tab Bar (4 Tabs: ขับกรง, ดึงคน, สายเกรียน, ตามคน) ]]
local tabBar = Instance.new("Frame", content)
tabBar.Size = UDim2.new(1, 0, 0, 30)
tabBar.Position = UDim2.new(0, 0, 0, 66)
tabBar.BackgroundColor3 = Color3.fromRGB(24, 26, 36)
Instance.new("UICorner", tabBar).CornerRadius = UDim.new(0, 7)

local tabFreeBtn = Instance.new("TextButton", tabBar)
tabFreeBtn.Size = UDim2.new(0.25, -2, 1, 0)
tabFreeBtn.BackgroundColor3 = Color3.fromRGB(50, 70, 115)
tabFreeBtn.Text = "🕹️ ขับกรง"
tabFreeBtn.TextColor3 = Color3.new(1, 1, 1)
tabFreeBtn.Font = Enum.Font.GothamBold
tabFreeBtn.TextSize = 10
Instance.new("UICorner", tabFreeBtn).CornerRadius = UDim.new(0, 6)

local tabAbductBtn = Instance.new("TextButton", tabBar)
tabAbductBtn.Size = UDim2.new(0.25, -2, 1, 0)
tabAbductBtn.Position = UDim2.new(0.25, 1, 0, 0)
tabAbductBtn.BackgroundColor3 = Color3.fromRGB(30, 33, 46)
tabAbductBtn.Text = "🧲 ดึงคน"
tabAbductBtn.TextColor3 = Color3.fromRGB(180, 185, 205)
tabAbductBtn.Font = Enum.Font.GothamBold
tabAbductBtn.TextSize = 10
Instance.new("UICorner", tabAbductBtn).CornerRadius = UDim.new(0, 6)

local tabTrollBtn = Instance.new("TextButton", tabBar)
tabTrollBtn.Size = UDim2.new(0.25, -2, 1, 0)
tabTrollBtn.Position = UDim2.new(0.50, 1, 0, 0)
tabTrollBtn.BackgroundColor3 = Color3.fromRGB(30, 33, 46)
tabTrollBtn.Text = "🕳️ ขอบโลก"
tabTrollBtn.TextColor3 = Color3.fromRGB(180, 185, 205)
tabTrollBtn.Font = Enum.Font.GothamBold
tabTrollBtn.TextSize = 10
Instance.new("UICorner", tabTrollBtn).CornerRadius = UDim.new(0, 6)

local tabFollowBtn = Instance.new("TextButton", tabBar)
tabFollowBtn.Size = UDim2.new(0.25, -2, 1, 0)
tabFollowBtn.Position = UDim2.new(0.75, 1, 0, 0)
tabFollowBtn.BackgroundColor3 = Color3.fromRGB(30, 33, 46)
tabFollowBtn.Text = "👤 ตามคน"
tabFollowBtn.TextColor3 = Color3.fromRGB(180, 185, 205)
tabFollowBtn.Font = Enum.Font.GothamBold
tabFollowBtn.TextSize = 10
Instance.new("UICorner", tabFollowBtn).CornerRadius = UDim.new(0, 6)

-- [[ Tab Containers ]]
local tabFreeContainer = Instance.new("Frame", content)
tabFreeContainer.Name = "FreeContainer"
tabFreeContainer.Size = UDim2.new(1, 0, 1, -102)
tabFreeContainer.Position = UDim2.new(0, 0, 0, 102)
tabFreeContainer.BackgroundTransparency = 1
tabFreeContainer.Visible = true

local tabAbductContainer = Instance.new("Frame", content)
tabAbductContainer.Name = "AbductContainer"
tabAbductContainer.Size = UDim2.new(1, 0, 1, -102)
tabAbductContainer.Position = UDim2.new(0, 0, 0, 102)
tabAbductContainer.BackgroundTransparency = 1
tabAbductContainer.Visible = false

local tabTrollContainer = Instance.new("ScrollingFrame", content)
tabTrollContainer.Name = "TrollContainer"
tabTrollContainer.Size = UDim2.new(1, 0, 1, -102)
tabTrollContainer.Position = UDim2.new(0, 0, 0, 102)
tabTrollContainer.BackgroundTransparency = 1
tabTrollContainer.ScrollBarThickness = 4
tabTrollContainer.Visible = false
local tcLayout = Instance.new("UIListLayout", tabTrollContainer)
tcLayout.Padding = UDim.new(0, 6)

local tabFollowContainer = Instance.new("Frame", content)
tabFollowContainer.Name = "FollowContainer"
tabFollowContainer.Size = UDim2.new(1, 0, 1, -102)
tabFollowContainer.Position = UDim2.new(0, 0, 0, 102)
tabFollowContainer.BackgroundTransparency = 1
tabFollowContainer.Visible = false

local function switchTab(active)
    tabFreeContainer.Visible = (active == "free")
    tabAbductContainer.Visible = (active == "abduct")
    tabTrollContainer.Visible = (active == "troll")
    tabFollowContainer.Visible = (active == "follow")

    tabFreeBtn.BackgroundColor3 = (active == "free") and Color3.fromRGB(50, 70, 115) or Color3.fromRGB(30, 33, 46)
    tabFreeBtn.TextColor3 = (active == "free") and Color3.new(1, 1, 1) or Color3.fromRGB(180, 185, 205)

    tabAbductBtn.BackgroundColor3 = (active == "abduct") and Color3.fromRGB(50, 70, 115) or Color3.fromRGB(30, 33, 46)
    tabAbductBtn.TextColor3 = (active == "abduct") and Color3.new(1, 1, 1) or Color3.fromRGB(180, 185, 205)

    tabTrollBtn.BackgroundColor3 = (active == "troll") and Color3.fromRGB(130, 35, 75) or Color3.fromRGB(30, 33, 46)
    tabTrollBtn.TextColor3 = (active == "troll") and Color3.new(1, 1, 1) or Color3.fromRGB(180, 185, 205)

    tabFollowBtn.BackgroundColor3 = (active == "follow") and Color3.fromRGB(50, 70, 115) or Color3.fromRGB(30, 33, 46)
    tabFollowBtn.TextColor3 = (active == "follow") and Color3.new(1, 1, 1) or Color3.fromRGB(180, 185, 205)
end

tabFreeBtn.MouseButton1Click:Connect(function() switchTab("free") end)
tabAbductBtn.MouseButton1Click:Connect(function() switchTab("abduct") end)
tabTrollBtn.MouseButton1Click:Connect(function() switchTab("troll") end)
tabFollowBtn.MouseButton1Click:Connect(function() switchTab("follow") end)

-- ========================================================
-- [[ ESCAPE CAGE (UNSTUCK) IMPLEMENTATION ]]
-- ========================================================
local function escapeFromOwnCage()
    local char = lp.Character
    local hrp = char and char:FindFirstChild("HumanoidRootPart")
    if not hrp then return end

    -- Safe escape vector: 7 studs in front of look direction
    local look = hrp.CFrame.LookVector
    local safePos = clusterPos + look * 7.0 + Vector3.new(0, 1, 0)
    hrp.CFrame = CFrame.new(safePos, safePos + look)

    escapeBtn.Text = "✔ หลุดแล้ว!"
    task.delay(1.5, function() escapeBtn.Text = "🔓 ออกจากกรง" end)
end

escapeBtn.MouseButton1Click:Connect(escapeFromOwnCage)

-- ========================================================
-- [[ DRIVE PROP MODE HUD OVERLAY ]]
-- ========================================================
local driveHud = Instance.new("Frame", screenGui)
driveHud.Name = "DriveHud"
driveHud.Size = UDim2.new(0, 380, 0, 72)
driveHud.Position = UDim2.new(0.5, -190, 0, 14)
driveHud.BackgroundColor3 = Color3.fromRGB(22, 26, 36)
driveHud.BorderSizePixel = 0
driveHud.Visible = false
Instance.new("UICorner", driveHud).CornerRadius = UDim.new(0, 10)
local dhStroke = Instance.new("UIStroke", driveHud)
dhStroke.Color = Color3.fromRGB(50, 130, 230)
dhStroke.Thickness = 1.5

local dhTitle = Instance.new("TextLabel", driveHud)
dhTitle.Size = UDim2.new(1, -90, 0, 22)
dhTitle.Position = UDim2.new(0, 10, 0, 5)
dhTitle.BackgroundTransparency = 1
dhTitle.Text = "🎮 ขับกรง: เดิน(WASD/จอย) | กระโดด(ปุ่ม Roblox/Space)"
dhTitle.TextColor3 = Color3.fromRGB(140, 225, 255)
dhTitle.Font = Enum.Font.GothamBold
dhTitle.TextSize = 11
dhTitle.TextXAlignment = Enum.TextXAlignment.Left

local exitDriveBtn = Instance.new("TextButton", driveHud)
exitDriveBtn.Size = UDim2.new(0, 80, 0, 24)
exitDriveBtn.Position = UDim2.new(1, -86, 0, 5)
exitDriveBtn.BackgroundColor3 = Color3.fromRGB(215, 55, 65)
exitDriveBtn.Text = "🚪 ออกจากโหมด"
exitDriveBtn.TextColor3 = Color3.new(1, 1, 1)
exitDriveBtn.Font = Enum.Font.GothamBold
exitDriveBtn.TextSize = 10
Instance.new("UICorner", exitDriveBtn).CornerRadius = UDim.new(0, 6)

local dhControlsRow = Instance.new("Frame", driveHud)
dhControlsRow.Size = UDim2.new(1, -20, 0, 26)
dhControlsRow.Position = UDim2.new(0, 10, 0, 32)
dhControlsRow.BackgroundTransparency = 1

local flyToggleBtn = Instance.new("TextButton", dhControlsRow)
flyToggleBtn.Size = UDim2.new(0, 105, 1, 0)
flyToggleBtn.BackgroundColor3 = Color3.fromRGB(40, 48, 68)
flyToggleBtn.Text = "🚶 โหมด: เดินพื้น"
flyToggleBtn.TextColor3 = Color3.fromRGB(150, 230, 170)
flyToggleBtn.Font = Enum.Font.GothamBold
flyToggleBtn.TextSize = 10
Instance.new("UICorner", flyToggleBtn).CornerRadius = UDim.new(0, 5)

local sp16 = Instance.new("TextButton", dhControlsRow)
sp16.Size = UDim2.new(0, 50, 1, 0); sp16.Position = UDim2.new(0, 115, 0, 0)
sp16.BackgroundColor3 = Color3.fromRGB(45, 95, 175); sp16.Text = "16 ปกติ"
sp16.TextColor3 = Color3.new(1, 1, 1); sp16.Font = Enum.Font.GothamBold; sp16.TextSize = 10
Instance.new("UICorner", sp16).CornerRadius = UDim.new(0, 5)

local sp28 = Instance.new("TextButton", dhControlsRow)
sp28.Size = UDim2.new(0, 50, 1, 0); sp28.Position = UDim2.new(0, 170, 0, 0)
sp28.BackgroundColor3 = Color3.fromRGB(36, 42, 58); sp28.Text = "28 วิ่ง"
sp28.TextColor3 = Color3.fromRGB(180, 185, 200); sp28.Font = Enum.Font.GothamBold; sp28.TextSize = 10
Instance.new("UICorner", sp28).CornerRadius = UDim.new(0, 5)

local sp45 = Instance.new("TextButton", dhControlsRow)
sp45.Size = UDim2.new(0, 55, 1, 0); sp45.Position = UDim2.new(0, 225, 0, 0)
sp45.BackgroundColor3 = Color3.fromRGB(36, 42, 58); sp45.Text = "45 เทอร์โบ"
sp45.TextColor3 = Color3.fromRGB(180, 185, 200); sp45.Font = Enum.Font.GothamBold; sp45.TextSize = 10
Instance.new("UICorner", sp45).CornerRadius = UDim.new(0, 5)

local hudEscapeBtn = Instance.new("TextButton", dhControlsRow)
hudEscapeBtn.Size = UDim2.new(0, 70, 1, 0); hudEscapeBtn.Position = UDim2.new(1, -70, 0, 0)
hudEscapeBtn.BackgroundColor3 = Color3.fromRGB(190, 80, 25); hudEscapeBtn.Text = "🔓 หลุดกรง"
hudEscapeBtn.TextColor3 = Color3.new(1, 1, 1); hudEscapeBtn.Font = Enum.Font.GothamBold; hudEscapeBtn.TextSize = 10
Instance.new("UICorner", hudEscapeBtn).CornerRadius = UDim.new(0, 5)
hudEscapeBtn.MouseButton1Click:Connect(escapeFromOwnCage)

local function updateDriveSpeed(val)
    driveSpeed = val
    sp16.BackgroundColor3 = (val == 16) and Color3.fromRGB(45, 95, 175) or Color3.fromRGB(36, 42, 58)
    sp28.BackgroundColor3 = (val == 28) and Color3.fromRGB(45, 95, 175) or Color3.fromRGB(36, 42, 58)
    sp45.BackgroundColor3 = (val == 45) and Color3.fromRGB(45, 95, 175) or Color3.fromRGB(36, 42, 58)
end
sp16.MouseButton1Click:Connect(function() updateDriveSpeed(16) end)
sp28.MouseButton1Click:Connect(function() updateDriveSpeed(28) end)
sp45.MouseButton1Click:Connect(function() updateDriveSpeed(45) end)

flyToggleBtn.MouseButton1Click:Connect(function()
    isFlying = not isFlying
    if isFlying then
        flyToggleBtn.Text = "🕊️ โหมด: บินอิสระ"
        flyToggleBtn.TextColor3 = Color3.fromRGB(255, 215, 100)
    else
        flyToggleBtn.Text = "🚶 โหมด: เดินพื้น"
        flyToggleBtn.TextColor3 = Color3.fromRGB(150, 230, 170)
        vertVel = 0
    end
end)


-- ========================================================
-- [[ TAB 1: FREE MOVEMENT & DRIVE CONTROLLER ]]
-- ========================================================

-- Big Drive Button
local driveEnterBtn = Instance.new("TextButton", tabFreeContainer)
driveEnterBtn.Size = UDim2.new(1, 0, 0, 36)
driveEnterBtn.Position = UDim2.new(0, 0, 0, 0)
driveEnterBtn.BackgroundColor3 = Color3.fromRGB(30, 120, 210)
driveEnterBtn.Text = "🎮 สวมวิญญาณขับกรง (WASD / จอยมือถือ / โดด)"
driveEnterBtn.TextColor3 = Color3.new(1, 1, 1)
driveEnterBtn.Font = Enum.Font.GothamBold
driveEnterBtn.TextSize = 12
Instance.new("UICorner", driveEnterBtn).CornerRadius = UDim.new(0, 7)
local deStroke = Instance.new("UIStroke", driveEnterBtn)
deStroke.Color = Color3.fromRGB(110, 190, 255)
deStroke.Thickness = 1.2

-- Quick Teleport Row
local quickTpRow = Instance.new("Frame", tabFreeContainer)
quickTpRow.Size = UDim2.new(1, 0, 0, 26)
quickTpRow.Position = UDim2.new(0, 0, 0, 42)
quickTpRow.BackgroundTransparency = 1

local bringMeBtn = Instance.new("TextButton", quickTpRow)
bringMeBtn.Size = UDim2.new(0.5, -3, 1, 0)
bringMeBtn.BackgroundColor3 = Color3.fromRGB(35, 120, 90)
bringMeBtn.Text = "🚀 ดึงมาหน้าฉัน"
bringMeBtn.TextColor3 = Color3.new(1, 1, 1)
bringMeBtn.Font = Enum.Font.GothamBold
bringMeBtn.TextSize = 11
Instance.new("UICorner", bringMeBtn).CornerRadius = UDim.new(0, 6)

local sendTargetBtn = Instance.new("TextButton", quickTpRow)
sendTargetBtn.Size = UDim2.new(0.5, -3, 1, 0)
sendTargetBtn.Position = UDim2.new(0.5, 3, 0, 0)
sendTargetBtn.BackgroundColor3 = Color3.fromRGB(130, 85, 30)
sendTargetBtn.Text = "📍 ส่งไปหาเป้าหมาย"
sendTargetBtn.TextColor3 = Color3.new(1, 1, 1)
sendTargetBtn.Font = Enum.Font.GothamBold
sendTargetBtn.TextSize = 11
Instance.new("UICorner", sendTargetBtn).CornerRadius = UDim.new(0, 6)

-- Interactive Drag & Tap Controls
local dragRow = Instance.new("Frame", tabFreeContainer)
dragRow.Size = UDim2.new(1, 0, 0, 26)
dragRow.Position = UDim2.new(0, 0, 0, 72)
dragRow.BackgroundTransparency = 1

local dragToggleBtn = Instance.new("TextButton", dragRow)
dragToggleBtn.Size = UDim2.new(0.65, -3, 1, 0)
dragToggleBtn.BackgroundColor3 = Color3.fromRGB(40, 44, 60)
dragToggleBtn.Text = "🖐️ ลากด้วยเมาส์/นิ้ว: ปิด"
dragToggleBtn.TextColor3 = Color3.fromRGB(220, 225, 240)
dragToggleBtn.Font = Enum.Font.GothamBold
dragToggleBtn.TextSize = 11
Instance.new("UICorner", dragToggleBtn).CornerRadius = UDim.new(0, 6)

local tapPlaceBtn = Instance.new("TextButton", dragRow)
tapPlaceBtn.Size = UDim2.new(0.35, -3, 1, 0)
tapPlaceBtn.Position = UDim2.new(0.65, 3, 0, 0)
tapPlaceBtn.BackgroundColor3 = Color3.fromRGB(45, 50, 70)
tapPlaceBtn.Text = "🎯 แตะพื้นวาง"
tapPlaceBtn.TextColor3 = Color3.new(1, 1, 1)
tapPlaceBtn.Font = Enum.Font.GothamBold
tapPlaceBtn.TextSize = 10
Instance.new("UICorner", tapPlaceBtn).CornerRadius = UDim.new(0, 6)

-- Drag Banner Indicator
local dragBanner = Instance.new("Frame", screenGui)
dragBanner.Name = "DragBanner"
dragBanner.Size = UDim2.new(0, 360, 0, 36)
dragBanner.Position = UDim2.new(0.5, -180, 0, 10)
dragBanner.BackgroundColor3 = Color3.fromRGB(20, 85, 175)
dragBanner.BorderSizePixel = 0
dragBanner.Visible = false
Instance.new("UICorner", dragBanner).CornerRadius = UDim.new(0, 10)

local bannerLabel = Instance.new("TextLabel", dragBanner)
bannerLabel.Size = UDim2.new(1, -70, 1, 0)
bannerLabel.Position = UDim2.new(0, 12, 0, 0)
bannerLabel.BackgroundTransparency = 1
bannerLabel.Text = "🖐️ โหมดลากอิสระ: แตะ/ลากบนจอเพื่อย้ายกรง"
bannerLabel.TextColor3 = Color3.new(1, 1, 1)
bannerLabel.Font = Enum.Font.GothamBold
bannerLabel.TextSize = 11
bannerLabel.TextXAlignment = Enum.TextXAlignment.Left

local bannerClose = Instance.new("TextButton", dragBanner)
bannerClose.Size = UDim2.new(0, 52, 0, 24)
bannerClose.Position = UDim2.new(1, -60, 0, 6)
bannerClose.BackgroundColor3 = Color3.fromRGB(215, 55, 65)
bannerClose.Text = "ปิดโหมด"
bannerClose.TextColor3 = Color3.new(1, 1, 1)
bannerClose.Font = Enum.Font.GothamBold
bannerClose.TextSize = 10
Instance.new("UICorner", bannerClose).CornerRadius = UDim.new(0, 5)

local isDraggingNow = false

local function setDragMode(enable)
    isDragMode = enable
    isDraggingNow = false
    if isDragMode then
        isTapToPlace = false
        dragToggleBtn.BackgroundColor3 = Color3.fromRGB(25, 130, 220)
        dragToggleBtn.Text = "🖐️ ลากด้วยเมาส์/นิ้ว: เปิด"
        dragBanner.Visible = true
    else
        dragToggleBtn.BackgroundColor3 = Color3.fromRGB(40, 44, 60)
        dragToggleBtn.Text = "🖐️ ลากด้วยเมาส์/นิ้ว: ปิด"
        dragBanner.Visible = false
        syncClusterToNetwork(clusterCFrame)
    end
end

trackConn(dragToggleBtn.MouseButton1Click:Connect(function() setDragMode(not isDragMode) end))
trackConn(bannerClose.MouseButton1Click:Connect(function() setDragMode(false) end))

trackConn(tapPlaceBtn.MouseButton1Click:Connect(function()
    isTapToPlace = not isTapToPlace
    if isTapToPlace then
        setDragMode(false)
        tapPlaceBtn.BackgroundColor3 = Color3.fromRGB(220, 140, 30)
        tapPlaceBtn.Text = "📍 แตะบนจอเลย!"
    else
        tapPlaceBtn.BackgroundColor3 = Color3.fromRGB(45, 50, 70)
        tapPlaceBtn.Text = "🎯 แตะพื้นวาง"
    end
end))
-- [[ D-Pad Directional Controller Box ]]
local dpadFrame = Instance.new("Frame", tabFreeContainer)
dpadFrame.Size = UDim2.new(1, 0, 0, 150)
dpadFrame.Position = UDim2.new(0, 0, 0, 102)
dpadFrame.BackgroundColor3 = Color3.fromRGB(25, 28, 38)
Instance.new("UICorner", dpadFrame).CornerRadius = UDim.new(0, 8)
local dpStroke = Instance.new("UIStroke", dpadFrame)
dpStroke.Color = Color3.fromRGB(45, 52, 70)
dpStroke.Thickness = 1

local dpadTitle = Instance.new("TextLabel", dpadFrame)
dpadTitle.Size = UDim2.new(1, 0, 0, 18)
dpadTitle.BackgroundTransparency = 1
dpadTitle.Text = "🎮 ปุ่มควบคุม 6 ทิศทาง (กดแตะ / กดค้าง)"
dpadTitle.TextColor3 = Color3.fromRGB(150, 160, 185)
dpadTitle.Font = Enum.Font.GothamMedium
dpadTitle.TextSize = 10

local function createDpadBtn(text, posX, posY, sizeX, sizeY, bgCol)
    local btn = Instance.new("TextButton", dpadFrame)
    btn.Size = UDim2.new(0, sizeX, 0, sizeY)
    btn.Position = UDim2.new(0, posX, 0, posY)
    btn.BackgroundColor3 = bgCol or Color3.fromRGB(40, 46, 62)
    btn.Text = text
    btn.TextColor3 = Color3.new(1, 1, 1)
    btn.Font = Enum.Font.GothamBold
    btn.TextSize = 11
    Instance.new("UICorner", btn).CornerRadius = UDim.new(0, 6)
    return btn
end

local upBtn = createDpadBtn("⏫ ขึ้น", 16, 26, 74, 46, Color3.fromRGB(38, 70, 110))
local downBtn = createDpadBtn("⏬ ลง", 16, 84, 74, 46, Color3.fromRGB(38, 70, 110))
local fwdBtn = createDpadBtn("⬆️ หน้า", 120, 20, 64, 38, Color3.fromRGB(45, 85, 140))
local leftBtn = createDpadBtn("⬅️ ซ้าย", 96, 62, 52, 38, Color3.fromRGB(45, 85, 140))
local rightBtn = createDpadBtn("ขวา ➡️", 152, 62, 52, 38, Color3.fromRGB(45, 85, 140))
local backBtn = createDpadBtn("⬇️ หลัง", 120, 104, 64, 38, Color3.fromRGB(45, 85, 140))
local rotLeftBtn = createDpadBtn("⟲ หมุนซ้าย", 214, 26, 74, 46, Color3.fromRGB(55, 50, 80))
local rotRightBtn = createDpadBtn("หมุนขวา ⟳", 214, 84, 74, 46, Color3.fromRGB(55, 50, 80))

local function startMoving(dir)
    if holdingDir == dir then return end
    holdingDir = dir
    task.spawn(function()
        local lastTime = os.clock()
        while holdingDir == dir do
            local now = os.clock()
            local dt = math.min(now - lastTime, 0.1)
            lastTime = now

            local cam = workspace.CurrentCamera
            local forward = Vector3.new(cam.CFrame.LookVector.X, 0, cam.CFrame.LookVector.Z)
            if forward.Magnitude > 0.001 then forward = forward.Unit else forward = Vector3.new(0, 0, -1) end
            local right = Vector3.new(cam.CFrame.RightVector.X, 0, cam.CFrame.RightVector.Z)
            if right.Magnitude > 0.001 then right = right.Unit else right = Vector3.new(1, 0, 0) end
            local up = Vector3.new(0, 1, 0)

            local delta = Vector3.zero
            local actualSpeed = moveSpeed * speedMultiplier * dt

            if dir == "fwd" then delta = forward * actualSpeed
            elseif dir == "back" then delta = -forward * actualSpeed
            elseif dir == "left" then delta = -right * actualSpeed
            elseif dir == "right" then delta = right * actualSpeed
            elseif dir == "up" then delta = up * actualSpeed
            elseif dir == "down" then delta = -up * actualSpeed
            elseif dir == "rotL" then clusterYaw = clusterYaw + math.rad(90 * speedMultiplier * dt)
            elseif dir == "rotR" then clusterYaw = clusterYaw - math.rad(90 * speedMultiplier * dt)
            end

            clusterPos = clusterPos + delta
            clusterCFrame = CFrame.new(clusterPos) * CFrame.Angles(0, clusterYaw, 0)
            updateClusterVisuals(clusterCFrame)

            if os.clock() - lastNetSync > 0.07 then
                lastNetSync = os.clock()
                for _, item in ipairs(trackedProps) do
                    if item.setCF and item.setCF.Parent then
                        local targetCF = clusterCFrame * item.relCF
                        task.spawn(function() pcall(item.setCF.InvokeServer, item.setCF, targetCF) end)
                    end
                end
            end

            task.wait(0.02)
        end
    end)
end

local function stopMoving()
    holdingDir = nil
    syncClusterToNetwork(clusterCFrame)
end

local function bindHoldEvents(btn, dir)
    btn.InputBegan:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
            startMoving(dir)
        end
    end)
    btn.InputEnded:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
            stopMoving()
        end
    end)
end

bindHoldEvents(fwdBtn, "fwd")
bindHoldEvents(backBtn, "back")
bindHoldEvents(leftBtn, "left")
bindHoldEvents(rightBtn, "right")
bindHoldEvents(upBtn, "up")
bindHoldEvents(downBtn, "down")
bindHoldEvents(rotLeftBtn, "rotL")
bindHoldEvents(rotRightBtn, "rotR")

-- Screen Raycasting Drag Handler
local function handleScreenRay(screenPos)
    local cam = workspace.CurrentCamera
    local unitRay = cam:ViewportPointToRay(screenPos.X, screenPos.Y)
    local raycastParams = RaycastParams.new()
    raycastParams.FilterType = Enum.RaycastFilterType.Exclude

    local ignore = { lp.Character }
    for _, item in ipairs(trackedProps) do
        if item.model then table.insert(ignore, item.model) end
    end
    raycastParams.FilterDescendantsInstances = ignore

    local result = workspace:Raycast(unitRay.Origin, unitRay.Direction * 350, raycastParams)
    local hitPos
    if result then
        hitPos = result.Position + Vector3.new(0, 2.8 + heightOffset, 0)
    else
        hitPos = unitRay.Origin + unitRay.Direction * 20 + Vector3.new(0, heightOffset, 0)
    end

    clusterPos = hitPos
    clusterCFrame = CFrame.new(clusterPos) * CFrame.Angles(0, clusterYaw, 0)
    updateClusterVisuals(clusterCFrame)

    if os.clock() - lastNetSync > 0.07 then
        lastNetSync = os.clock()
        for _, item in ipairs(trackedProps) do
            if item.setCF and item.setCF.Parent then
                local targetCF = clusterCFrame * item.relCF
                task.spawn(function() pcall(item.setCF.InvokeServer, item.setCF, targetCF) end)
            end
        end
    end
end

trackConn(UserInputService.InputBegan:Connect(function(input, gpe)
    if not isDragMode and not isTapToPlace then return end
    if gpe then return end

    if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
        local mPos = UserInputService:GetMouseLocation()
        local guiObjects = parentGui:GetGuiObjectsAtPosition(mPos.X, mPos.Y)
        local isOverMain = false
        for _, obj in ipairs(guiObjects) do
            if obj:IsDescendantOf(mainFrame) or obj:IsDescendantOf(dragBanner) or obj:IsDescendantOf(driveHud) then
                isOverMain = true
                break
            end
        end
        if not isOverMain then
            if isDragMode then
                isDraggingNow = true
                handleScreenRay(mPos)
            elseif isTapToPlace then
                handleScreenRay(mPos)
                isTapToPlace = false
                tapPlaceBtn.BackgroundColor3 = Color3.fromRGB(45, 50, 70)
                tapPlaceBtn.Text = "🎯 แตะพื้นวาง"
                syncClusterToNetwork(clusterCFrame)
            end
        end
    end
end))

trackConn(UserInputService.InputChanged:Connect(function(input, gpe)
    if not isDragMode or not isDraggingNow then return end

    if input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch then
        if input.UserInputType == Enum.UserInputType.Touch or UserInputService:IsMouseButtonPressed(Enum.UserInputType.MouseButton1) then
            local mPos = UserInputService:GetMouseLocation()
            handleScreenRay(mPos)
        end
    end
end))

trackConn(UserInputService.InputEnded:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
        if isDraggingNow then
            isDraggingNow = false
            syncClusterToNetwork(clusterCFrame)
        end
    end
end))

-- ========================================================
-- [[ DRIVE PROP MODE IMPLEMENTATION (WASD + MOBILE + JUMP) ]]
-- ========================================================
-- "ตอนใช้ฟีเจอร์ขับให้ผู้ใช้ยืนอยู่กับที่" -> hrp.Anchored = true
-- "การเคลื่นที่ของกรงอะ เอาตามrobloxทำไรก็ทำตามกระโดดก็แบบขึ้นและลงตามปกติ" -> Gravity + JumpPower 50
-- "เอาโหมดลอยขึ้นออกเปลี่ยนเป็นโหมดบิน" -> Flight mode in 3D direction

local jumpConns = {}

local function startDriving()
    if isDriving then return end
    if #trackedProps == 0 then bindAllProps(true) end
    if #trackedProps == 0 then return end

    isDriving = true
    mainFrame.Visible = false
    driveHud.Visible = true

    -- 1. Freeze & Anchor player character completely stationary
    local char = lp.Character
    local hrp = char and char:FindFirstChild("HumanoidRootPart")
    local hum = char and char:FindFirstChildOfClass("Humanoid")
    if char and hum and hrp then
        savedWalkSpeed = hum.WalkSpeed
        hum.JumpPower = 50
        hum.WalkSpeed = (savedWalkSpeed > 0) and savedWalkSpeed or 16
        hrp.Anchored = true
    end

    -- 2. Create / Position Camera Proxy Part
    if not propDriveProxy or not propDriveProxy.Parent then
        propDriveProxy = Instance.new("Part")
        propDriveProxy.Name = "PropDriveProxy"
        propDriveProxy.Size = Vector3.new(2, 2, 2)
        propDriveProxy.Transparency = 1
        propDriveProxy.CanCollide = false
        propDriveProxy.CanTouch = false
        propDriveProxy.CanQuery = false
        propDriveProxy.Anchored = true
        propDriveProxy.Parent = workspace
    end

    local p = trackedProps[10] and trackedProps[10].model or (trackedProps[6] and trackedProps[6].model or trackedProps[1].model)
    if p and p.Parent then
        clusterCFrame = p:GetPivot()
        clusterPos = clusterCFrame.Position
        local _, y, _ = clusterCFrame:ToEulerAnglesYXZ()
        clusterYaw = y
    end
    propDriveProxy.CFrame = CFrame.new(clusterPos)

    local cam = workspace.CurrentCamera
    cam.CameraSubject = propDriveProxy

    vertVel = 0
    isOnGround = true
    jumpRequested = false

    -- Native Roblox Jump Detection Function
    local function onRobloxJump()
        if not isDriving then return end
        if isFlying then
            jumpRequested = true
        elseif isOnGround then
            vertVel = 52
            isOnGround = false
        end
    end

    jumpConns = {}
    table.insert(jumpConns, UserInputService.JumpRequest:Connect(onRobloxJump))
    table.insert(jumpConns, UserInputService.InputBegan:Connect(function(inp, gpe)
        if isDriving and inp.KeyCode == Enum.KeyCode.Space then
            onRobloxJump()
        end
    end))

    if hum then
        table.insert(jumpConns, hum:GetPropertyChangedSignal("Jump"):Connect(function()
            if hum.Jump then
                onRobloxJump()
                hum.Jump = false
            end
        end))
        table.insert(jumpConns, hum.StateChanged:Connect(function(oldState, newState)
            if newState == Enum.HumanoidStateType.Jumping then
                onRobloxJump()
            end
        end))
    end

    pcall(function()
        local touchGui = lp.PlayerGui:FindFirstChild("TouchGui")
        if touchGui then
            local jb = touchGui:FindFirstChild("JumpButton", true)
            if jb and jb:IsA("GuiButton") then
                table.insert(jumpConns, jb.InputBegan:Connect(function()
                    onRobloxJump()
                end))
            end
        end
    end)

    driveRenderConn = RunService.RenderStepped:Connect(function(dt)
        if not isDriving then return end

        local camCF = workspace.CurrentCamera.CFrame

        local moveVec = Vector3.zero
        if cm then
            local v = cm:GetMoveVector()
            if v and v.Magnitude > 0.01 then
                moveVec = v
            end
        end
        if moveVec.Magnitude < 0.01 then
            local x, z = 0, 0
            if UserInputService:IsKeyDown(Enum.KeyCode.W) or UserInputService:IsKeyDown(Enum.KeyCode.Up) then z = z - 1 end
            if UserInputService:IsKeyDown(Enum.KeyCode.S) or UserInputService:IsKeyDown(Enum.KeyCode.Down) then z = z + 1 end
            if UserInputService:IsKeyDown(Enum.KeyCode.A) or UserInputService:IsKeyDown(Enum.KeyCode.Left) then x = x - 1 end
            if UserInputService:IsKeyDown(Enum.KeyCode.D) or UserInputService:IsKeyDown(Enum.KeyCode.Right) then x = x + 1 end
            local raw = Vector3.new(x, 0, z)
            if raw.Magnitude > 0.01 then moveVec = raw.Unit end
        end

        -- [[ FLIGHT MODE (3D Fly in Camera Direction) ]]
        if isFlying then
            local flyLook = camCF.LookVector
            local flyRight = camCF.RightVector
            local moveDir = (flyRight * moveVec.X - flyLook * moveVec.Z)

            if moveDir.Magnitude > 0.05 then
                clusterPos = clusterPos + moveDir.Unit * (driveSpeed * dt)
                clusterYaw = math.atan2(-flyLook.X, -flyLook.Z)
            end

            if jumpRequested or UserInputService:IsKeyDown(Enum.KeyCode.Space) then
                clusterPos = clusterPos + Vector3.new(0, driveSpeed * dt, 0)
            end
            if UserInputService:IsKeyDown(Enum.KeyCode.LeftControl) or UserInputService:IsKeyDown(Enum.KeyCode.C) then
                clusterPos = clusterPos - Vector3.new(0, driveSpeed * dt, 0)
            end
            jumpRequested = false

        -- [[ GROUND WALKING & ROBLOX JUMP PHYSICS ]]
        else
            local camFwd = Vector3.new(camCF.LookVector.X, 0, camCF.LookVector.Z)
            if camFwd.Magnitude > 0.001 then camFwd = camFwd.Unit else camFwd = Vector3.new(0, 0, -1) end
            local camRight = Vector3.new(camCF.RightVector.X, 0, camCF.RightVector.Z)
            if camRight.Magnitude > 0.001 then camRight = camRight.Unit else camRight = Vector3.new(1, 0, 0) end

            local moveDir = (camRight * moveVec.X - camFwd * moveVec.Z)
            local isMoving = moveDir.Magnitude > 0.05

            -- 1. Wall Obstacle Avoidance / Sliding
            if isMoving then
                local forwardRayParams = RaycastParams.new()
                forwardRayParams.FilterType = Enum.RaycastFilterType.Exclude
                local ignoreList = { lp.Character }
                for _, item in ipairs(trackedProps) do
                    if item.model then table.insert(ignoreList, item.model) end
                end
                forwardRayParams.FilterDescendantsInstances = ignoreList

                local wallRay = workspace:Raycast(clusterPos, moveDir.Unit * 2.2, forwardRayParams)
                if wallRay and wallRay.Instance and wallRay.Instance.CanCollide then
                    local normal = wallRay.Normal
                    moveDir = moveDir - normal * moveDir:Dot(normal)
                end

                if moveDir.Magnitude > 0.01 then
                    clusterPos = clusterPos + moveDir.Unit * (driveSpeed * dt)
                end
                clusterYaw = math.atan2(-camFwd.X, -camFwd.Z)
            end

            -- 2. Ground Detection Raycast
            local groundRayParams = RaycastParams.new()
            groundRayParams.FilterType = Enum.RaycastFilterType.Exclude
            local ignoreList = { lp.Character }
            for _, item in ipairs(trackedProps) do
                if item.model then table.insert(ignoreList, item.model) end
            end
            groundRayParams.FilterDescendantsInstances = ignoreList

            local rayOrigin = Vector3.new(clusterPos.X, clusterPos.Y + 2.0, clusterPos.Z)
            local rayResult = workspace:Raycast(rayOrigin, Vector3.new(0, -25, 0), groundRayParams)
            local targetGroundY = rayResult and (rayResult.Position.Y + 3.08) or nil

            -- 3. Realistic Gravity & Landing Physics
            local currentGrav = workspace.Gravity or 196.2

            if not isOnGround then
                vertVel = vertVel - (currentGrav * dt)
                clusterPos = clusterPos + Vector3.new(0, vertVel * dt, 0)

                -- Only land when moving DOWNWARD (vertVel <= 0) and reached ground!
                if targetGroundY and vertVel <= 0 and clusterPos.Y <= targetGroundY then
                    clusterPos = Vector3.new(clusterPos.X, targetGroundY, clusterPos.Z)
                    vertVel = 0
                    isOnGround = true
                end
            else
                if targetGroundY then
                    local diff = targetGroundY - clusterPos.Y
                    if math.abs(diff) <= 2.2 then
                        clusterPos = Vector3.new(clusterPos.X, targetGroundY, clusterPos.Z)
                    elseif targetGroundY < clusterPos.Y - 2.2 then
                        isOnGround = false
                        vertVel = 0
                    end
                else
                    isOnGround = false
                    vertVel = 0
                end
            end
        end

        clusterCFrame = CFrame.new(clusterPos) * CFrame.Angles(0, clusterYaw, 0)
        propDriveProxy.CFrame = CFrame.new(clusterPos)
        updateClusterVisuals(clusterCFrame)

        -- Parallel Server Sync
        if os.clock() - lastDriveNetSync > 0.06 then
            lastDriveNetSync = os.clock()
            for _, item in ipairs(trackedProps) do
                if item.setCF and item.setCF.Parent then
                    local targetCF = clusterCFrame * item.relCF
                    task.spawn(function() pcall(item.setCF.InvokeServer, item.setCF, targetCF) end)
                end
            end
        end
    end)

    exitDriveBtn.MouseButton1Click:Connect(function()
        if not isDriving then return end
        isDriving = false
        if driveRenderConn then
            driveRenderConn:Disconnect()
            driveRenderConn = nil
        end
        for _, conn in ipairs(jumpConns) do
            pcall(function() conn:Disconnect() end)
        end
        jumpConns = {}

        driveHud.Visible = false
        mainFrame.Visible = true

        local cam = workspace.CurrentCamera
        local char = lp.Character
        local hrp = char and char:FindFirstChild("HumanoidRootPart")
        local hum = char and char:FindFirstChildOfClass("Humanoid")
        if char and hum and hrp then
            cam.CameraSubject = hum
            hrp.Anchored = false
            hum.WalkSpeed = (savedWalkSpeed > 0) and savedWalkSpeed or 16
            hum.JumpPower = 50
        end

        if propDriveProxy then
            propDriveProxy:Destroy()
            propDriveProxy = nil
        end

        syncClusterToNetwork(clusterCFrame)
    end)
end

driveEnterBtn.MouseButton1Click:Connect(function()
    startDriving()
end)

-- ========================================================
-- [[ TAB 2: ABDUCT / PULL NEAREST PLAYER ]]
-- ========================================================
-- "ใครอยู่ใกล้ๆประมาณ10-20แล้วแต่ผู้ใช้ให้ทำการดึงคนนั้นมาด้วยpropแล้วกลับมาอยู่คงที่"

local abductCard = Instance.new("Frame", tabAbductContainer)
abductCard.Size = UDim2.new(1, 0, 0, 48)
abductCard.BackgroundColor3 = Color3.fromRGB(26, 30, 44)
Instance.new("UICorner", abductCard).CornerRadius = UDim.new(0, 8)

local abductTitle = Instance.new("TextLabel", abductCard)
abductTitle.Size = UDim2.new(1, -16, 0, 20)
abductTitle.Position = UDim2.new(0, 8, 0, 4)
abductTitle.BackgroundTransparency = 1
abductTitle.Text = "🧲 ดึงคนใกล้ตัว (สูงสุด 4 คน) เข้ากรงโดยกรงไม่ขยับหาเรา"
abductTitle.TextColor3 = Color3.fromRGB(130, 215, 255)
abductTitle.Font = Enum.Font.GothamBold
abductTitle.TextSize = 11
abductTitle.TextXAlignment = Enum.TextXAlignment.Left

local nearestTrackerLabel = Instance.new("TextLabel", abductCard)
nearestTrackerLabel.Size = UDim2.new(1, -16, 0, 20)
nearestTrackerLabel.Position = UDim2.new(0, 8, 0, 24)
nearestTrackerLabel.BackgroundTransparency = 1
nearestTrackerLabel.Text = "🔍 ตรวจจับผู้เล่นใกล้ที่สุด: กำลังสแกน..."
nearestTrackerLabel.TextColor3 = Color3.fromRGB(180, 190, 210)
nearestTrackerLabel.Font = Enum.Font.Gotham
nearestTrackerLabel.TextSize = 10
nearestTrackerLabel.TextXAlignment = Enum.TextXAlignment.Left

-- Range Selector Row (10, 15, 20, 30, 50 studs)
local rangeRow = Instance.new("Frame", tabAbductContainer)
rangeRow.Size = UDim2.new(1, 0, 0, 32)
rangeRow.Position = UDim2.new(0, 0, 0, 54)
rangeRow.BackgroundTransparency = 1

local rangeLabel = Instance.new("TextLabel", rangeRow)
rangeLabel.Size = UDim2.new(0, 105, 1, 0)
rangeLabel.BackgroundTransparency = 1
rangeLabel.Text = "ระยะค้นหา: 15 studs"
rangeLabel.TextColor3 = Color3.fromRGB(255, 215, 120)
rangeLabel.Font = Enum.Font.GothamBold
rangeLabel.TextSize = 10
rangeLabel.TextXAlignment = Enum.TextXAlignment.Left

local r10 = Instance.new("TextButton", rangeRow)
r10.Size = UDim2.new(0, 34, 0, 24); r10.Position = UDim2.new(0, 110, 0, 4)
r10.BackgroundColor3 = Color3.fromRGB(36, 40, 54); r10.Text = "10"
r10.TextColor3 = Color3.fromRGB(180, 185, 200); r10.Font = Enum.Font.GothamBold; r10.TextSize = 10
Instance.new("UICorner", r10).CornerRadius = UDim.new(0, 5)

local r15 = Instance.new("TextButton", rangeRow)
r15.Size = UDim2.new(0, 34, 0, 24); r15.Position = UDim2.new(0, 148, 0, 4)
r15.BackgroundColor3 = Color3.fromRGB(45, 95, 175); r15.Text = "15"
r15.TextColor3 = Color3.new(1, 1, 1); r15.Font = Enum.Font.GothamBold; r15.TextSize = 10
Instance.new("UICorner", r15).CornerRadius = UDim.new(0, 5)

local r20 = Instance.new("TextButton", rangeRow)
r20.Size = UDim2.new(0, 34, 0, 24); r20.Position = UDim2.new(0, 186, 0, 4)
r20.BackgroundColor3 = Color3.fromRGB(36, 40, 54); r20.Text = "20"
r20.TextColor3 = Color3.fromRGB(180, 185, 200); r20.Font = Enum.Font.GothamBold; r20.TextSize = 10
Instance.new("UICorner", r20).CornerRadius = UDim.new(0, 5)

local r30 = Instance.new("TextButton", rangeRow)
r30.Size = UDim2.new(0, 34, 0, 24); r30.Position = UDim2.new(0, 224, 0, 4)
r30.BackgroundColor3 = Color3.fromRGB(36, 40, 54); r30.Text = "30"
r30.TextColor3 = Color3.fromRGB(180, 185, 200); r30.Font = Enum.Font.GothamBold; r30.TextSize = 10
Instance.new("UICorner", r30).CornerRadius = UDim.new(0, 5)

local r50 = Instance.new("TextButton", rangeRow)
r50.Size = UDim2.new(0, 34, 0, 24); r50.Position = UDim2.new(0, 262, 0, 4)
r50.BackgroundColor3 = Color3.fromRGB(36, 40, 54); r50.Text = "50"
r50.TextColor3 = Color3.fromRGB(180, 185, 200); r50.Font = Enum.Font.GothamBold; r50.TextSize = 10
Instance.new("UICorner", r50).CornerRadius = UDim.new(0, 5)

local function updateRange(val)
    abductRange = val
    rangeLabel.Text = string.format("ระยะค้นหา: %d studs", val)
    r10.BackgroundColor3 = (val == 10) and Color3.fromRGB(45, 95, 175) or Color3.fromRGB(36, 40, 54)
    r15.BackgroundColor3 = (val == 15) and Color3.fromRGB(45, 95, 175) or Color3.fromRGB(36, 40, 54)
    r20.BackgroundColor3 = (val == 20) and Color3.fromRGB(45, 95, 175) or Color3.fromRGB(36, 40, 54)
    r30.BackgroundColor3 = (val == 30) and Color3.fromRGB(45, 95, 175) or Color3.fromRGB(36, 40, 54)
    r50.BackgroundColor3 = (val == 50) and Color3.fromRGB(45, 95, 175) or Color3.fromRGB(36, 40, 54)
end
r10.MouseButton1Click:Connect(function() updateRange(10) end)
r15.MouseButton1Click:Connect(function() updateRange(15) end)
r20.MouseButton1Click:Connect(function() updateRange(20) end)
r30.MouseButton1Click:Connect(function() updateRange(30) end)
r50.MouseButton1Click:Connect(function() updateRange(50) end)

-- Big Abduct Action Button
local abductActionBtn = Instance.new("TextButton", tabAbductContainer)
abductActionBtn.Size = UDim2.new(1, 0, 0, 42)
abductActionBtn.Position = UDim2.new(0, 0, 0, 92)
abductActionBtn.BackgroundColor3 = Color3.fromRGB(180, 50, 110)
abductActionBtn.Text = "🧲 ดึงคนใกล้ที่สุด (สูงสุด 4 คน) มาขังในกรงทันที!"
abductActionBtn.TextColor3 = Color3.new(1, 1, 1)
abductActionBtn.Font = Enum.Font.GothamBold
abductActionBtn.TextSize = 12
Instance.new("UICorner", abductActionBtn).CornerRadius = UDim.new(0, 8)
local aStroke = Instance.new("UIStroke", abductActionBtn)
aStroke.Color = Color3.fromRGB(255, 110, 170)
aStroke.Thickness = 1.2

local autoAbductToggleBtn = Instance.new("TextButton", tabAbductContainer)
autoAbductToggleBtn.Size = UDim2.new(1, 0, 0, 28)
autoAbductToggleBtn.Position = UDim2.new(0, 0, 0, 140)
autoAbductToggleBtn.BackgroundColor3 = Color3.fromRGB(40, 45, 62)
autoAbductToggleBtn.Text = "⚡ ดูดคนอัตโนมัติเมื่อเดินเข้าใกล้: ปิด"
autoAbductToggleBtn.TextColor3 = Color3.fromRGB(200, 205, 220)
autoAbductToggleBtn.Font = Enum.Font.GothamBold
autoAbductToggleBtn.TextSize = 10
Instance.new("UICorner", autoAbductToggleBtn).CornerRadius = UDim.new(0, 6)

autoAbductToggleBtn.MouseButton1Click:Connect(function()
    isAutoAbduct = not isAutoAbduct
    if isAutoAbduct then
        autoAbductToggleBtn.BackgroundColor3 = Color3.fromRGB(35, 130, 80)
        autoAbductToggleBtn.Text = "⚡ ดูดคนอัตโนมัติเมื่อเดินเข้าใกล้: เปิด"
        autoAbductToggleBtn.TextColor3 = Color3.new(1, 1, 1)
    else
        autoAbductToggleBtn.BackgroundColor3 = Color3.fromRGB(40, 45, 62)
        autoAbductToggleBtn.Text = "⚡ ดูดคนอัตโนมัติเมื่อเดินเข้าใกล้: ปิด"
        autoAbductToggleBtn.TextColor3 = Color3.fromRGB(200, 205, 220)
    end
end)

-- Abduct Helper: Check if player is already inside cage or seated on our props
local function isPlayerInCage(p)
    if not p or not p.Character then return false end
    local pChar = p.Character
    local pHrp = pChar:FindFirstChild("HumanoidRootPart")

    -- Check 1: Sitting on ANY seat belonging to our tracked props
    for _, item in ipairs(trackedProps) do
        if item.model and item.model.Parent then
            local seat = item.model:FindFirstChildWhichIsA("Seat", true)
            if seat and seat.Occupant and seat.Occupant.Parent == pChar then
                return true
            end
        end
    end

    -- Check 2: Positioned within the physical cage bounds (radius 5.5 studs around clusterPos)
    if pHrp and clusterPos and clusterPos.Magnitude > 1 then
        local dist = (pHrp.Position - clusterPos).Magnitude
        if dist < 5.5 then
            return true
        end
    end

    return false
end

-- Helper to check if a specific prop is currently occupied by someone other than local player
local function isPropOccupied(item)
    if not item or not item.model or not item.model.Parent then return false end
    local seat = item.model:FindFirstChildWhichIsA("Seat", true)
    if seat and seat.Occupant and seat.Occupant.Parent and seat.Occupant.Parent ~= lp.Character then
        return true
    end
    return false
end

-- Abduct Core Function (ดึงสูงสุด 4 คน + ไม่ดึงตัวเอง + กรงไม่ขยับหาผู้ใช้ + ข้ามคนที่อยู่ในกรง + อันไหนมีคนนั่งไม่เอาไปดึง)
local isAbducting = false
local function performAbduct()
    if isAbducting then return end
    isAbducting = true

    local char = lp.Character
    local hrp = char and char:FindFirstChild("HumanoidRootPart")
    if not hrp then
        abductActionBtn.Text = "❌ ไม่พบตัวละครของคุณ"
        task.wait(1.5)
        abductActionBtn.Text = "🧲 ดึงคนใกล้ที่สุด (สูงสุด 4 คน) มาขังในกรงทันที!"
        isAbducting = false
        return
    end

    if #trackedProps == 0 then bindAllProps(true) end
    if #trackedProps == 0 then
        abductActionBtn.Text = "❌ ไม่มี Prop ในเกม (กรุณากดสร้างกรงก่อน)"
        task.wait(1.5)
        abductActionBtn.Text = "🧲 ดึงคนใกล้ที่สุด (สูงสุด 4 คน) มาขังในกรงทันที!"
        isAbducting = false
        return
    end

    -- Home base is WHERE THE CAGE CURRENTLY IS!
    -- "ไม่ต้องขยับมาหาผู้ใช้" -> Keep cage at clusterCFrame, NEVER move cage to user's character!
    local homeCF = clusterCFrame
    if not homeCF or homeCF.Position.Magnitude < 1 then
        homeCF = hrp.CFrame * CFrame.new(0, 0, -6)
        clusterCFrame = homeCF
        clusterPos = homeCF.Position
    end

    -- Separate props into occupied (KEEP IN CAGE, DO NOT TOUCH!) and free (can fly to grab)
    local occupiedProps = {}
    local freeProps = {}

    for _, item in ipairs(trackedProps) do
        if isPropOccupied(item) then
            table.insert(occupiedProps, item)
        else
            table.insert(freeProps, item)
        end
    end

    -- If all props are occupied, cage is 100% full!
    if #freeProps == 0 then
        abductActionBtn.Text = "❌ กรงเต็มแล้ว! ทุกเบาะมีคนนั่งหมดแล้ว"
        abductActionBtn.BackgroundColor3 = Color3.fromRGB(150, 40, 50)
        task.wait(2)
        abductActionBtn.Text = "🧲 ดึงคนใกล้ที่สุด (สูงสุด 4 คน) มาขังในกรงทันที!"
        abductActionBtn.BackgroundColor3 = Color3.fromRGB(180, 50, 110)
        isAbducting = false
        return
    end

    -- Reference position to measure distance is the cage itself
    local refPos = homeCF.Position

    -- Find candidates outside the cage
    local candidates = {}
    for _, p in ipairs(Players:GetPlayers()) do
        if p ~= lp and p.Character and p.Character:FindFirstChild("HumanoidRootPart") then
            local pChar = p.Character
            local pHrp = pChar.HumanoidRootPart
            local pHum = pChar:FindFirstChildOfClass("Humanoid")
            if pHum and pHum.Health > 0 and not isPlayerInCage(p) then
                local dist = (pHrp.Position - refPos).Magnitude
                if dist <= abductRange then
                    table.insert(candidates, {player = p, char = pChar, hrp = pHrp, dist = dist})
                end
            end
        end
    end

    if #candidates == 0 then
        abductActionBtn.Text = string.format("❌ ไม่พบใครนอกกรงในระยะ %d studs!", abductRange)
        abductActionBtn.BackgroundColor3 = Color3.fromRGB(120, 60, 70)
        task.wait(1.5)
        abductActionBtn.Text = "🧲 ดึงคนใกล้ที่สุด (สูงสุด 4 คน) มาขังในกรงทันที!"
        abductActionBtn.BackgroundColor3 = Color3.fromRGB(180, 50, 110)
        isAbducting = false
        return
    end

    -- Sort candidates closest to cage first
    table.sort(candidates, function(a, b) return a.dist < b.dist end)

    -- Max targets is min(4, available free props, candidates)
    local maxTargets = math.min(4, #freeProps, #candidates)
    local targets = {}
    local targetNames = {}
    for i = 1, maxTargets do
        table.insert(targets, candidates[i])
        table.insert(targetNames, candidates[i].player.DisplayName)
    end
    local namesStr = table.concat(targetNames, ", ")

    abductActionBtn.Text = string.format("🚀 ปล่อยเบาะว่างไปดึง %d คน (%s)...", #targets, namesStr)
    abductActionBtn.BackgroundColor3 = Color3.fromRGB(220, 110, 30)

    -- Plan prop assignments: ONLY use freeProps, NEVER touch occupiedProps!
    local assignedGrabs = {} -- array of {item = propItem, targetPropCF = CFrame}
    local usedFreeProps = {}

    if #targets == 1 and #freeProps >= 4 then
        -- 1 Victim and plenty of free props: form a complete 4-prop clamp box
        local t = targets[1]
        local _, tYaw, _ = t.hrp.CFrame:ToEulerAnglesYXZ()
        local tRootCF = CFrame.new(t.hrp.Position) * CFrame.Angles(0, tYaw, 0)
        table.insert(assignedGrabs, {item = freeProps[1], targetPropCF = tRootCF * CFrame.new(0, -1.0, 0)}) -- Floor seat
        table.insert(assignedGrabs, {item = freeProps[2], targetPropCF = tRootCF * CFrame.new(0, 0.4, 1.45) * CFrame.Angles(0, math.rad(90), math.rad(-90))}) -- Front
        table.insert(assignedGrabs, {item = freeProps[3], targetPropCF = tRootCF * CFrame.new(0, 0.4, -1.45) * CFrame.Angles(0, math.rad(-90), math.rad(-90))}) -- Back
        table.insert(assignedGrabs, {item = freeProps[4], targetPropCF = tRootCF * CFrame.new(0, 2.0, 0) * CFrame.Angles(0, 0, math.rad(180))}) -- Lid
        for i = 1, 4 do usedFreeProps[freeProps[i]] = true end
    elseif #targets == 2 and #freeProps >= 4 then
        -- 2 Victims: 2 free props each (seat + wall)
        local t1, t2 = targets[1], targets[2]
        local _, y1, _ = t1.hrp.CFrame:ToEulerAnglesYXZ()
        local _, y2, _ = t2.hrp.CFrame:ToEulerAnglesYXZ()
        local r1 = CFrame.new(t1.hrp.Position) * CFrame.Angles(0, y1, 0)
        local r2 = CFrame.new(t2.hrp.Position) * CFrame.Angles(0, y2, 0)
        table.insert(assignedGrabs, {item = freeProps[1], targetPropCF = r1 * CFrame.new(0, -1.0, 0)})
        table.insert(assignedGrabs, {item = freeProps[2], targetPropCF = r1 * CFrame.new(0, 0.4, 1.45) * CFrame.Angles(0, math.rad(90), math.rad(-90))})
        table.insert(assignedGrabs, {item = freeProps[3], targetPropCF = r2 * CFrame.new(0, -1.0, 0)})
        table.insert(assignedGrabs, {item = freeProps[4], targetPropCF = r2 * CFrame.new(0, 0.4, 1.45) * CFrame.Angles(0, math.rad(90), math.rad(-90))})
        for i = 1, 4 do usedFreeProps[freeProps[i]] = true end
    else
        -- 1 to 4 Victims: Assign exactly 1 free seat directly under each victim's feet!
        for idx, t in ipairs(targets) do
            local item = freeProps[idx]
            local _, tYaw, _ = t.hrp.CFrame:ToEulerAnglesYXZ()
            local seatCF = CFrame.new(t.hrp.Position) * CFrame.Angles(0, tYaw, 0) * CFrame.new(0, -1.0, 0)
            table.insert(assignedGrabs, {item = item, targetPropCF = seatCF})
            usedFreeProps[item] = true
        end
    end

    -- 1. Ensure all occupied props and unassigned props stay rigidly at homeCF (NEVER MOVE THEM!)
    for _, item in ipairs(trackedProps) do
        if not usedFreeProps[item] then
            if item.model and item.setCF then
                local partCF = homeCF * item.relCF
                item.model:PivotTo(partCF)
                task.spawn(function() pcall(item.setCF.InvokeServer, item.setCF, partCF) end)
            end
        end
    end

    -- 2. Fly assigned free props to targets!
    for _, grab in ipairs(assignedGrabs) do
        local item = grab.item
        local tCF = grab.targetPropCF
        if item.model and item.setCF then
            item.model:PivotTo(tCF)
            task.spawn(function() pcall(item.setCF.InvokeServer, item.setCF, tCF) end)
        end
    end

    -- Fast Active Wait for victims to touch seats (checks every 20ms, max 0.16s)
    local seatWaitStart = os.clock()
    while os.clock() - seatWaitStart < 0.16 do
        local allSeated = true
        for _, grab in ipairs(assignedGrabs) do
            local seat = grab.item.model and grab.item.model:FindFirstChildWhichIsA("Seat", true)
            if not (seat and seat.Occupant) then
                allSeated = false
                break
            end
        end
        if allSeated then break end
        RunService.Heartbeat:Wait()
    end

    -- 3. High-Speed Harpoon Pull (Snaps back in ~80ms!)
    abductActionBtn.Text = string.format("🧲 ดึง %d คนเข้ามารวมกับกรงหลัก...", #targets)
    local steps = 4
    for s = 1, steps do
        local alpha = s / steps
        for _, grab in ipairs(assignedGrabs) do
            local item = grab.item
            local startCF = grab.targetPropCF
            local dockCF = homeCF * item.relCF
            if item and item.model and item.setCF then
                local currentCF = startCF:Lerp(dockCF, alpha)
                item.model:PivotTo(currentCF)
                task.spawn(function() pcall(item.setCF.InvokeServer, item.setCF, currentCF) end)
            end
        end
        task.wait(0.02)
    end

    -- 4. Final Lock: Refresh cluster at homeCF
    moveClusterTo(homeCF)

    abductActionBtn.Text = string.format("✔ ดึง %d คนขังในกรงสำเร็จ!", #targets)
    abductActionBtn.BackgroundColor3 = Color3.fromRGB(35, 150, 85)

    -- INSTANTLY UNBLOCK isAbducting so Auto-Void or next abduct can trigger immediately!
    isAbducting = false

    task.delay(1.0, function()
        if not isAbducting then
            abductActionBtn.Text = "🧲 ดึงคนใกล้ที่สุด (สูงสุด 4 คน) มาขังในกรงทันที!"
            abductActionBtn.BackgroundColor3 = Color3.fromRGB(180, 50, 110)
        end
    end)
end

abductActionBtn.MouseButton1Click:Connect(performAbduct)

-- Real-Time Nearest Player Scanner Loop (สแกนสูงสุด 4 คน + ข้ามคนในกรง)
trackConn(RunService.Heartbeat:Connect(function()
    if os.clock() - lastAbductCheck > 0.04 then
        lastAbductCheck = os.clock()
        local char = lp.Character
        local hrp = char and char:FindFirstChild("HumanoidRootPart")
        if hrp then
            local refPos = (clusterPos and clusterPos.Magnitude > 1) and clusterPos or hrp.Position
            local candidates = {}
            for _, p in ipairs(Players:GetPlayers()) do
                if p ~= lp and p.Character and p.Character:FindFirstChild("HumanoidRootPart") then
                    local pChar = p.Character
                    local pHrp = pChar.HumanoidRootPart
                    local pHum = pChar:FindFirstChildOfClass("Humanoid")
                    if pHum and pHum.Health > 0 and not isPlayerInCage(p) then
                        local dist = (pHrp.Position - refPos).Magnitude
                        if dist <= abductRange then
                            table.insert(candidates, {player = p, dist = dist})
                        end
                    end
                end
            end

            table.sort(candidates, function(a, b) return a.dist < b.dist end)

            if #candidates > 0 then
                local nearest = candidates[1]
                local targetCount = math.min(#candidates, 4)
                nearestTrackerLabel.Text = string.format("🔍 พบ %d คนนอกกรง (ใกล้สุด: %s - %.1f studs)", targetCount, nearest.player.DisplayName, nearest.dist)
                nearestTrackerLabel.TextColor3 = Color3.fromRGB(120, 255, 160)
                if isAutoAbduct and not isAbducting then
                    task.spawn(performAbduct)
                end
            else
                nearestTrackerLabel.Text = "🔍 ตรวจจับคนนอกกรง: ไม่พบเป้าหมายใหม่ในระยะ"
                nearestTrackerLabel.TextColor3 = Color3.fromRGB(160, 170, 185)
            end
        end
    end
end))

-- ========================================================
-- ========================================================
-- [[ TAB 3: TROLL & CHAOS SUITE (เมนูสายเกรียน + วาร์ปลงสุดขอบโลก) ]]
-- ========================================================
local isAutoVoidOnSit = true
local isVoidingTrap = false
local isSpinning = false
local isShaking = false

-- 1. Void Abyss Drop Function (วาร์ปไปขอบแมพ Y = -480 + ทิ้งดิ่งเร็วๆ 2 วินาที สู่ -4,000 Studs)
local function performVoidDrop(victimName, directVictimChar, directVictimPlayer)
    if isVoidingTrap then return end
    isVoidingTrap = true

    if #trackedProps == 0 then bindAllProps(true) end
    if #trackedProps == 0 then isVoidingTrap = false; return end

    local savedCF = clusterCFrame

    local ok, err = pcall(function()
        -- 1. Locate all victims currently sitting in the cage
        local victimList = {}
        for _, item in ipairs(trackedProps) do
            if item.model and item.model.Parent then
                local seat = item.model:FindFirstChildWhichIsA("Seat", true)
                if seat and seat.Occupant and seat.Occupant.Parent and seat.Occupant.Parent ~= lp.Character then
                    local vChar = seat.Occupant.Parent
                    local vPlayer = Players:GetPlayerFromCharacter(vChar)
                    local exists = false
                    for _, v in ipairs(victimList) do
                        if v.char == vChar then exists = true; break end
                    end
                    if not exists then
                        table.insert(victimList, {
                            char = vChar,
                            player = vPlayer,
                            hum = vChar:FindFirstChildOfClass("Humanoid"),
                            name = vPlayer and vPlayer.DisplayName or vChar.Name
                        })
                    end
                end
            end
        end

        if #victimList == 0 and directVictimChar then
            table.insert(victimList, {
                char = directVictimChar,
                player = directVictimPlayer or Players:GetPlayerFromCharacter(directVictimChar),
                hum = directVictimChar:FindFirstChildOfClass("Humanoid"),
                name = (directVictimPlayer and directVictimPlayer.DisplayName) or (directVictimChar and directVictimChar.Name) or (victimName or "เหยื่อ")
            })
        end

        local victimNames = {}
        for _, v in ipairs(victimList) do
            table.insert(victimNames, v.name)
        end
        local victimNamesStr = #victimNames > 0 and table.concat(victimNames, ", ") or (victimName or "เหยื่อ")

        -- Step 1: Notify user & Warp to map boundary edge (ขอบแมพ: Y = -480)
        dragBanner.BackgroundColor3 = Color3.fromRGB(225, 40, 40)
        bannerLabel.Text = "⚡ วาร์ปสู่ขอบแมพ (Y: -480) เป้าหมาย: " .. victimNamesStr
        dragBanner.Visible = true

        local edgePos = Vector3.new(savedCF.Position.X, -480, savedCF.Position.Z)
        local edgeCF = CFrame.new(edgePos) * savedCF.Rotation
        moveClusterTo(edgeCF)
        task.wait(0.2)

        -- Step 2: Plunge down rapidly for 2 seconds (ลงไปอีกเร็วๆ 2 วิ ถึง -4,000 studs!)
        bannerLabel.Text = "🌪️ ทิ้งดิ่งสู่ก้นบึ้งนรก 2 วินาที (-4,000 Studs)... เหยื่อ: " .. victimNamesStr

        local plungeDuration = 2.0
        local plungeStart = os.clock()
        local startY = -480
        local targetY = -4000
        local ejected = false
        local lastSync = 0

        while true do
            local elapsed = os.clock() - plungeStart
            local progress = math.min(elapsed / plungeDuration, 1.0)
            local eased = progress * progress
            local currentY = startY + (targetY - startY) * eased
            local tilt = savedCF.Rotation * CFrame.Angles(math.rad(180 * progress), 0, 0)
            local curCF = CFrame.new(savedCF.Position.X, currentY, savedCF.Position.Z) * tilt

            clusterCFrame = curCF
            clusterPos = curCF.Position
            updateClusterVisuals(curCF)

            if os.clock() - lastSync > 0.08 then
                lastSync = os.clock()
                for _, item in ipairs(trackedProps) do
                    if item.setCF and item.setCF.Parent then
                        local tCF = curCF * item.relCF
                        task.spawn(function() pcall(item.setCF.InvokeServer, item.setCF, tCF) end)
                    end
                end
            end

            -- Eject seats midway through plunge
            if progress >= 0.5 and not ejected then
                ejected = true
                for _, item in ipairs(trackedProps) do
                    if item.model then
                        local seat = item.model:FindFirstChildWhichIsA("Seat", true)
                        if seat then seat.Disabled = true end
                    end
                end
            end

            if progress >= 1.0 then break end
            RunService.Heartbeat:Wait()
        end

        -- Step 3: Re-enable seats so props remain usable
        task.wait(0.15)
        for _, item in ipairs(trackedProps) do
            if item.model then
                local seat = item.model:FindFirstChildWhichIsA("Seat", true)
                if seat then seat.Disabled = false end
            end
        end

        -- Step 4: Active Real-Time Death Pulse Detector for all victims
        bannerLabel.Text = "🔍 กำลังตรวจจับสถานะชีพจรของเหยื่อทั้งหมด..."
        local checkStart = os.clock()
        local allDead = false

        while os.clock() - checkStart < 3.5 do
            local deadCount = 0
            for _, v in ipairs(victimList) do
                local isDead = false
                if v.hum and (v.hum.Health <= 0 or v.hum:GetState() == Enum.HumanoidStateType.Dead) then
                    isDead = true
                elseif not v.char or not v.char.Parent then
                    isDead = true
                elseif v.player and v.player.Character and v.player.Character ~= v.char then
                    isDead = true
                elseif v.char and (not v.char:FindFirstChild("HumanoidRootPart") or not v.char:FindFirstChild("Head")) then
                    isDead = true
                end
                if isDead then deadCount = deadCount + 1 end
            end

            if #victimList > 0 and deadCount >= #victimList then
                allDead = true
                break
            end
            task.wait(0.1)
        end

        -- Step 5: Status feedback
        if allDead and #victimList > 0 then
            bannerLabel.Text = "💀 ยืนยันการตาย 100%! เหยื่อทั้ง " .. #victimList .. " คน สิ้นชีพสู่ก้นบึ้งเรียบร้อย!"
            dragBanner.BackgroundColor3 = Color3.fromRGB(170, 20, 20)
        else
            bannerLabel.Text = "✔ ดรอปลงสุดขอบโลกเรียบร้อย! กำลังนำกรงกลับ..."
            dragBanner.BackgroundColor3 = Color3.fromRGB(40, 160, 80)
        end
    end)

    if not ok then
        warn("performVoidDrop error:", err)
    end

    -- Step 6: ALWAYS return cage back up to original position safely
    if savedCF then
        pcall(function()
            moveClusterTo(savedCF)
            task.wait(0.1)
            syncClusterToNetwork(savedCF)
        end)
    end

    task.delay(3.0, function()
        dragBanner.Visible = false
        dragBanner.BackgroundColor3 = Color3.fromRGB(20, 85, 175)
        bannerLabel.Text = "🖐️ โหมดลากอิสระ: แตะ/ลากบนจอเพื่อย้ายกรง"
    end)

    isVoidingTrap = false
end

-- [[ Tab 3: Dedicated Void Abyss Controls ]]
-- Toggle: Auto Void on Sit
local autoVoidToggleBtn = Instance.new("TextButton", tabTrollContainer)
autoVoidToggleBtn.Size = UDim2.new(1, -6, 0, 42)
autoVoidToggleBtn.BackgroundColor3 = Color3.fromRGB(150, 30, 45)
autoVoidToggleBtn.Text = "⚡ วาร์ปลงสุดขอบโลกเมื่อมีคนนั่ง: เปิด"
autoVoidToggleBtn.TextColor3 = Color3.new(1, 1, 1)
autoVoidToggleBtn.Font = Enum.Font.GothamBold
autoVoidToggleBtn.TextSize = 11
Instance.new("UICorner", autoVoidToggleBtn).CornerRadius = UDim.new(0, 8)
local avStroke = Instance.new("UIStroke", autoVoidToggleBtn)
avStroke.Color = Color3.fromRGB(240, 80, 100)
avStroke.Thickness = 1.2

autoVoidToggleBtn.MouseButton1Click:Connect(function()
    isAutoVoidOnSit = not isAutoVoidOnSit
    if isAutoVoidOnSit then
        autoVoidToggleBtn.BackgroundColor3 = Color3.fromRGB(150, 30, 45)
        autoVoidToggleBtn.Text = "⚡ วาร์ปลงสุดขอบโลกเมื่อมีคนนั่ง: เปิด"
        avStroke.Color = Color3.fromRGB(240, 80, 100)
    else
        autoVoidToggleBtn.BackgroundColor3 = Color3.fromRGB(40, 44, 58)
        autoVoidToggleBtn.Text = "⚡ วาร์ปลงสุดขอบโลกเมื่อมีคนนั่ง: ปิด"
        avStroke.Color = Color3.fromRGB(60, 68, 88)
    end
end)

-- Main Manual Void Drop Button
local dropVoidBtn = Instance.new("TextButton", tabTrollContainer)
dropVoidBtn.Size = UDim2.new(1, -6, 0, 52)
dropVoidBtn.BackgroundColor3 = Color3.fromRGB(195, 30, 45)
dropVoidBtn.Text = "🕳️ วาร์ปไปขอบแมพ + ทิ้งดิ่ง 2 วิสู่ก้นบึ้ง (Void Drop)"
dropVoidBtn.TextColor3 = Color3.new(1, 1, 1)
dropVoidBtn.Font = Enum.Font.GothamBold
dropVoidBtn.TextSize = 12
Instance.new("UICorner", dropVoidBtn).CornerRadius = UDim.new(0, 8)
local dvStroke = Instance.new("UIStroke", dropVoidBtn)
dvStroke.Color = Color3.fromRGB(255, 90, 110)
dvStroke.Thickness = 1.4

dropVoidBtn.MouseButton1Click:Connect(function()
    task.spawn(function() performVoidDrop(nil) end)
end)

-- Info Card
local voidInfoCard = Instance.new("Frame", tabTrollContainer)
voidInfoCard.Size = UDim2.new(1, -6, 0, 95)
voidInfoCard.BackgroundColor3 = Color3.fromRGB(25, 28, 40)
Instance.new("UICorner", voidInfoCard).CornerRadius = UDim.new(0, 8)
local viStroke = Instance.new("UIStroke", voidInfoCard)
viStroke.Color = Color3.fromRGB(55, 65, 90)
viStroke.Thickness = 1

local voidInfoLabel = Instance.new("TextLabel", voidInfoCard)
voidInfoLabel.Size = UDim2.new(1, -16, 1, -12)
voidInfoLabel.Position = UDim2.new(0, 8, 0, 6)
voidInfoLabel.BackgroundTransparency = 1
voidInfoLabel.Text = "💀 ขั้นตอนการทำงาน:\n1. วาร์ปกรงลงสู่ขอบแมพใต้ดิน (Y = -480)\n2. ทิ้งดิ่งเร็วๆ 2 วินาที สู่ก้นบึ้งนรก (-4,000 Studs)\n3. ดีดเบาะส่งเหยื่อร่วงสู่ Void ลับแล\n4. ตรวจชีพจรยืนยันการตาย 100% แล้วนำกรงกลับ"
voidInfoLabel.TextColor3 = Color3.fromRGB(180, 195, 220)
voidInfoLabel.Font = Enum.Font.GothamMedium
voidInfoLabel.TextSize = 10
voidInfoLabel.TextXAlignment = Enum.TextXAlignment.Left
voidInfoLabel.TextYAlignment = Enum.TextYAlignment.Top

tabTrollContainer.CanvasSize = UDim2.new(0, 0, 0, 210)

-- Auto Seat Monitor Loop (Detects when someone sits and void drops them if enabled)
local lastSeatCheck = 0
trackConn(RunService.Heartbeat:Connect(function()
    if isAutoVoidOnSit and not isVoidingTrap and not isAbducting and os.clock() - lastSeatCheck > 0.03 then
        lastSeatCheck = os.clock()
        if #trackedProps > 0 then
            for _, item in ipairs(trackedProps) do
                if item.model and item.model.Parent then
                    local seat = item.model:FindFirstChildWhichIsA("Seat", true)
                    if seat and seat.Occupant and seat.Occupant.Parent and seat.Occupant.Parent ~= lp.Character then
                        local victimChar = seat.Occupant.Parent
                        local victimP = Players:GetPlayerFromCharacter(victimChar)
                        local victimName = victimP and victimP.DisplayName or victimChar.Name
                        task.spawn(function()
                            performVoidDrop(victimName, victimChar, victimP)
                        end)
                        break
                    end
                end
            end
        end
    end
end))

-- [[ TAB 3: PLAYER FOLLOW (TARGET SELECTION) ]]
-- ========================================================

local targetCard = Instance.new("Frame", tabFollowContainer)
targetCard.Size = UDim2.new(1, 0, 0, 32)
targetCard.BackgroundColor3 = Color3.fromRGB(28, 32, 44)
Instance.new("UICorner", targetCard).CornerRadius = UDim.new(0, 7)

local targetLabel = Instance.new("TextLabel", targetCard)
targetLabel.Size = UDim2.new(1, -12, 1, 0)
targetLabel.Position = UDim2.new(0, 8, 0, 0)
targetLabel.BackgroundTransparency = 1
targetLabel.Text = "🎯 เป้าหมาย: " .. targetPlayer.DisplayName .. " (@" .. targetPlayer.Name .. ")"
targetLabel.TextColor3 = Color3.fromRGB(140, 215, 255)
targetLabel.Font = Enum.Font.GothamMedium
targetLabel.TextSize = 11
targetLabel.TextXAlignment = Enum.TextXAlignment.Left

local followBtn = Instance.new("TextButton", tabFollowContainer)
followBtn.Size = UDim2.new(1, 0, 0, 34)
followBtn.Position = UDim2.new(0, 0, 0, 36)
followBtn.BackgroundColor3 = Color3.fromRGB(40, 165, 95)
followBtn.Text = "▶ เริ่มติดตาม (ขยับไปพร้อมกันทั้งก้อน)"
followBtn.TextColor3 = Color3.new(1, 1, 1)
followBtn.Font = Enum.Font.GothamBold
followBtn.TextSize = 12
Instance.new("UICorner", followBtn).CornerRadius = UDim.new(0, 7)

local settingsRow = Instance.new("Frame", tabFollowContainer)
settingsRow.Size = UDim2.new(1, 0, 0, 26)
settingsRow.Position = UDim2.new(0, 0, 0, 74)
settingsRow.BackgroundTransparency = 1

local offsetLabel = Instance.new("TextLabel", settingsRow)
offsetLabel.Size = UDim2.new(0, 105, 1, 0)
offsetLabel.BackgroundTransparency = 1
offsetLabel.Text = "ความสูง (Y): +0.0"
offsetLabel.TextColor3 = Color3.fromRGB(200, 205, 220)
offsetLabel.Font = Enum.Font.Gotham
offsetLabel.TextSize = 11
offsetLabel.TextXAlignment = Enum.TextXAlignment.Left

local downOffsetBtn = Instance.new("TextButton", settingsRow)
downOffsetBtn.Size = UDim2.new(0, 32, 0, 22); downOffsetBtn.Position = UDim2.new(0, 108, 0, 2)
downOffsetBtn.BackgroundColor3 = Color3.fromRGB(45, 50, 70); downOffsetBtn.Text = "▼ -1"
downOffsetBtn.TextColor3 = Color3.new(1, 1, 1); downOffsetBtn.Font = Enum.Font.GothamBold; downOffsetBtn.TextSize = 9
Instance.new("UICorner", downOffsetBtn).CornerRadius = UDim.new(0, 4)

local upOffsetBtn = Instance.new("TextButton", settingsRow)
upOffsetBtn.Size = UDim2.new(0, 32, 0, 22); upOffsetBtn.Position = UDim2.new(0, 144, 0, 2)
upOffsetBtn.BackgroundColor3 = Color3.fromRGB(45, 50, 70); upOffsetBtn.Text = "▲ +1"
upOffsetBtn.TextColor3 = Color3.new(1, 1, 1); upOffsetBtn.Font = Enum.Font.GothamBold; upOffsetBtn.TextSize = 9
Instance.new("UICorner", upOffsetBtn).CornerRadius = UDim.new(0, 4)

local rotBtn = Instance.new("TextButton", settingsRow)
rotBtn.Size = UDim2.new(1, -182, 0, 22); rotBtn.Position = UDim2.new(0, 182, 0, 2)
rotBtn.BackgroundColor3 = Color3.fromRGB(38, 42, 58); rotBtn.Text = "🔄 หมุนตาม: เปิด"
rotBtn.TextColor3 = Color3.fromRGB(150, 255, 180); rotBtn.Font = Enum.Font.GothamBold; rotBtn.TextSize = 9
Instance.new("UICorner", rotBtn).CornerRadius = UDim.new(0, 4)

local searchBox = Instance.new("TextBox", tabFollowContainer)
searchBox.Size = UDim2.new(1, 0, 0, 24)
searchBox.Position = UDim2.new(0, 0, 0, 104)
searchBox.BackgroundColor3 = Color3.fromRGB(28, 30, 42)
searchBox.PlaceholderText = "🔍 ค้นหาผู้เล่นเพื่อติดตาม..."
searchBox.PlaceholderColor3 = Color3.fromRGB(120, 125, 140)
searchBox.Text = ""
searchBox.TextColor3 = Color3.new(1, 1, 1)
searchBox.Font = Enum.Font.Gotham
searchBox.TextSize = 11
Instance.new("UICorner", searchBox).CornerRadius = UDim.new(0, 5)

local playerScroll = Instance.new("ScrollingFrame", tabFollowContainer)
playerScroll.Size = UDim2.new(1, 0, 1, -134)
playerScroll.Position = UDim2.new(0, 0, 0, 134)
playerScroll.BackgroundColor3 = Color3.fromRGB(16, 17, 24)
playerScroll.BorderSizePixel = 0
playerScroll.ScrollBarThickness = 4
Instance.new("UICorner", playerScroll).CornerRadius = UDim.new(0, 6)
local pListLayout = Instance.new("UIListLayout", playerScroll)
pListLayout.Padding = UDim.new(0, 3)
local pListPad = Instance.new("UIPadding", playerScroll)
pListPad.PaddingTop = UDim.new(0, 3); pListPad.PaddingLeft = UDim.new(0, 3); pListPad.PaddingRight = UDim.new(0, 3)

local function refreshPlayerList()
    for _, child in ipairs(playerScroll:GetChildren()) do
        if child:IsA("TextButton") then child:Destroy() end
    end
    local filter = searchBox.Text:lower()
    local players = Players:GetPlayers()
    table.sort(players, function(a, b)
        if a == lp then return true elseif b == lp then return false end
        return a.Name:lower() < b.Name:lower()
    end)
    local count = 0
    for _, p in ipairs(players) do
        local dName, uName = p.DisplayName, p.Name
        if filter == "" or dName:lower():find(filter) or uName:lower():find(filter) then
            count = count + 1
            local btn = Instance.new("TextButton", playerScroll)
            btn.Size = UDim2.new(1, -4, 0, 24)
            btn.BackgroundColor3 = (p == targetPlayer) and Color3.fromRGB(45, 90, 150) or Color3.fromRGB(26, 28, 38)
            btn.Text = (p == lp and "⭐ " or "  ") .. dName .. " (@" .. uName .. ")"
            btn.TextColor3 = (p == targetPlayer) and Color3.new(1, 1, 1) or Color3.fromRGB(200, 205, 220)
            btn.Font = Enum.Font.GothamMedium
            btn.TextSize = 11
            btn.TextXAlignment = Enum.TextXAlignment.Left
            Instance.new("UICorner", btn).CornerRadius = UDim.new(0, 4)
            btn.MouseButton1Click:Connect(function()
                targetPlayer = p
                targetLabel.Text = "🎯 เป้าหมาย: " .. p.DisplayName .. " (@" .. p.Name .. ")"
                refreshPlayerList()
            end)
        end
    end
    playerScroll.CanvasSize = UDim2.new(0, 0, 0, count * 28 + 6)
end

searchBox:GetPropertyChangedSignal("Text"):Connect(refreshPlayerList)
trackConn(Players.PlayerAdded:Connect(refreshPlayerList))
trackConn(Players.PlayerRemoving:Connect(refreshPlayerList))
refreshPlayerList()

-- Follow Engine
local function startFollowing()
    if isFollowing then return end
    isFollowing = true
    followBtn.BackgroundColor3 = Color3.fromRGB(215, 55, 65)
    followBtn.Text = "⏹ หยุดติดตาม (Stop Following)"

    localRenderConn = RunService.RenderStepped:Connect(function()
        if not isFollowing then return end
        if targetPlayer and targetPlayer.Character then
            local root = targetPlayer.Character:FindFirstChild("HumanoidRootPart")
            if root then
                local targetPos = root.Position + Vector3.new(0, heightOffset, 0)
                local _, yaw, _ = root.CFrame:ToEulerAnglesYXZ()
                local targetRot = rotateWithPlayer and CFrame.Angles(0, yaw, 0) or CFrame.new()
                local targetRootCF = CFrame.new(targetPos) * targetRot

                clusterCFrame = targetRootCF
                clusterPos = targetPos
                clusterYaw = yaw
                updateClusterVisuals(targetRootCF)
            end
        end
    end)

    networkThread = task.spawn(function()
        while isFollowing do
            if targetPlayer and targetPlayer.Character then
                local root = targetPlayer.Character:FindFirstChild("HumanoidRootPart")
                if root then
                    local targetPos = root.Position + Vector3.new(0, heightOffset, 0)
                    local _, yaw, _ = root.CFrame:ToEulerAnglesYXZ()
                    local targetRot = rotateWithPlayer and CFrame.Angles(0, yaw, 0) or CFrame.new()
                    local targetRootCF = CFrame.new(targetPos) * targetRot

                    for _, item in ipairs(trackedProps) do
                        if item.setCF and item.setCF.Parent then
                            local targetCF = targetRootCF * item.relCF
                            task.spawn(function()
                                pcall(item.setCF.InvokeServer, item.setCF, targetCF)
                            end)
                        end
                    end
                end
            end
            task.wait(0.06)
        end
    end)
end

local function stopFollowing()
    isFollowing = false
    followBtn.BackgroundColor3 = Color3.fromRGB(40, 165, 95)
    followBtn.Text = "▶ เริ่มติดตาม (ขยับไปพร้อมกันทั้งก้อน)"
    if localRenderConn then
        localRenderConn:Disconnect()
        localRenderConn = nil
    end
    networkThread = nil
end

followBtn.MouseButton1Click:Connect(function()
    if isFollowing then
        stopFollowing()
    else
        if #trackedProps == 0 then bindAllProps(true) end
        startFollowing()
    end
end)

upOffsetBtn.MouseButton1Click:Connect(function()
    heightOffset = heightOffset + 0.5
    offsetLabel.Text = string.format("ความสูง (Y): %+.1f", heightOffset)
end)

downOffsetBtn.MouseButton1Click:Connect(function()
    heightOffset = heightOffset - 0.5
    offsetLabel.Text = string.format("ความสูง (Y): %+.1f", heightOffset)
end)

rotBtn.MouseButton1Click:Connect(function()
    rotateWithPlayer = not rotateWithPlayer
    rotBtn.Text = rotateWithPlayer and "🔄 หมุนตาม: เปิด" or "🔒 หมุนตาม: ปิด"
    rotBtn.TextColor3 = rotateWithPlayer and Color3.fromRGB(150, 255, 180) or Color3.fromRGB(255, 180, 150)
end)

-- [[ AUTO-BUILD (UP TO 15 PROPS) & ALIGN ]]
local isBuilding = false
local function autoBuildCage()
    if isBuilding then return end
    isBuilding = true
    buildBtn.BackgroundColor3 = Color3.fromRGB(80, 80, 95)
    buildBtn.Text = "⏳ เตรียมของ..."

    local rem = require(game.ReplicatedStorage.Packages.Remotes)
    local char = lp.Character
    local hrp = char and char:FindFirstChild("HumanoidRootPart")
    if not hrp then
        buildBtn.Text = "❌ ไม่พบตัวละคร"
        task.wait(1.5)
        buildBtn.Text = "🔨 สร้างกรง 15 ชิ้น"
        buildBtn.BackgroundColor3 = Color3.fromRGB(125, 55, 215)
        isBuilding = false
        return
    end

    pcall(function()
        game.ReplicatedStorage.RE["1Clea1rTool1s"]:FireServer("RequestingPropFeatureName", "FloorCushion", "Decor")
    end)
    task.wait(0.2)

    local props = getMyPropsList()
    if #props == 0 then
        buildBtn.Text = "⏳ วางชิ้นแรก..."
        local pm = lp.Backpack:FindFirstChild("PropMaker") or (char and char:FindFirstChild("PropMaker"))
        if pm then
            pm.Parent = char
            task.wait(0.25)
            local targetPart = workspace.Terrain
            local targetPos = hrp.Position + hrp.CFrame.LookVector * 6
            pcall(function()
                rem.fireServerComponent(pm, "Tool_PropMake", targetPart, targetPos)
            end)

            local waited = 0
            while #props == 0 and waited < 3 do
                task.wait(0.2)
                waited = waited + 0.2
                props = getMyPropsList()
            end

            if pm.Parent == char then
                pm.Parent = lp.Backpack
            end
        end
    end

    props = getMyPropsList()
    if #props == 0 then
        buildBtn.Text = "❌ ล้มเหลว"
        task.wait(1.5)
        buildBtn.Text = "🔨 สร้างกรง 15 ชิ้น"
        buildBtn.BackgroundColor3 = Color3.fromRGB(125, 55, 215)
        isBuilding = false
        return
    end

    local dups = 0
    while #props < 15 and #props > 0 and dups < 20 do
        buildBtn.Text = string.format("⏳ ปั๊ม (%d/15)...", #props)
        local p = props[1]
        pcall(function() rem.invokeServerComponent(p, "DuplicateProp") end)
        task.wait(0.18)
        props = getMyPropsList()
        dups = dups + 1
    end

    buildBtn.Text = "⏳ จัดทรงกรงเป๊ะ..."
    bindAllProps(true)
    statusLabel.Text = "🔗 เชื่อมต่อ Prop: " .. #trackedProps .. " ชิ้น (กรงพร้อม)"

    local target = targetPlayer or lp
    local targetChar = (target and target.Character) or char
    local targetHrp = targetChar and targetChar:FindFirstChild("HumanoidRootPart")
    if targetHrp then
        local targetPos = targetHrp.Position + Vector3.new(0, heightOffset, 0)
        local _, yaw, _ = targetHrp.CFrame:ToEulerAnglesYXZ()
        local targetRot = rotateWithPlayer and CFrame.Angles(0, yaw, 0) or CFrame.new()
        moveClusterTo(CFrame.new(targetPos) * targetRot)
    end

    buildBtn.Text = "✔ สร้าง 15 ชิ้นสำเร็จ!"
    buildBtn.BackgroundColor3 = Color3.fromRGB(40, 175, 110)
    task.wait(2)
    buildBtn.Text = "🔨 สร้างกรง 15 ชิ้น"
    buildBtn.BackgroundColor3 = Color3.fromRGB(125, 55, 215)
    isBuilding = false
end

buildBtn.MouseButton1Click:Connect(function()
    task.spawn(autoBuildCage)
end)

alignBtn.MouseButton1Click:Connect(function()
    local count = bindAllProps(true)
    statusLabel.Text = "🔗 เชื่อมต่อ Prop: " .. count .. " ชิ้น (จัดตรงแล้ว)"

    local target = targetPlayer or lp
    if target and target.Character and target.Character:FindFirstChild("HumanoidRootPart") then
        local root = target.Character.HumanoidRootPart
        local targetPos = root.Position + Vector3.new(0, heightOffset, 0)
        local _, yaw, _ = root.CFrame:ToEulerAnglesYXZ()
        local targetRot = rotateWithPlayer and CFrame.Angles(0, yaw, 0) or CFrame.new()
        moveClusterTo(CFrame.new(targetPos) * targetRot)

        alignBtn.Text = "✔ ตรงเป๊ะ 100%!"
        task.delay(1.5, function() alignBtn.Text = "🎯 จัดทรงตรงเป๊ะ" end)
    end
end)

rescanBtn.MouseButton1Click:Connect(function()
    local count = bindAllProps(false)
    statusLabel.Text = "🔗 เชื่อมต่อ Prop: " .. count .. " ชิ้น (ทั้งก้อน)"
    rescanBtn.Text = "✔ ครบแล้ว"
    task.delay(1.2, function() rescanBtn.Text = "🔄 สแกนใหม่" end)
end)

-- [[ Window Controls ]]
local isMinimized = false
minBtn.MouseButton1Click:Connect(function()
    isMinimized = not isMinimized
    if isMinimized then
        content.Visible = false
        mainFrame.Size = UDim2.new(0, 320, 0, 40)
        minBtn.Text = "＋"
    else
        content.Visible = true
        mainFrame.Size = UDim2.new(0, 325, 0, 530)
        minBtn.Text = "—"
    end
end)

closeBtn.MouseButton1Click:Connect(function()
    if _G.PropClusterCleanup then _G.PropClusterCleanup() end
    stopFollowing()
    setDragMode(false)
    if isDriving then
        isDriving = false
        if driveRenderConn then driveRenderConn:Disconnect() end
        local cam = workspace.CurrentCamera
        local char = lp.Character
        local hrp = char and char:FindFirstChild("HumanoidRootPart")
        if char and char:FindFirstChild("Humanoid") and hrp then
            cam.CameraSubject = char.Humanoid
            hrp.Anchored = false
            char.Humanoid.WalkSpeed = 16
            char.Humanoid.JumpPower = 50
        end
        if propDriveProxy then propDriveProxy:Destroy() end
    end
    screenGui:Destroy()
end)
