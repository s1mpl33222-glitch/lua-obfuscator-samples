
--// AUTO SAVE SYSTEM
local HttpService = game:GetService("HttpService")
local CONFIG_FILE = "kawatan_config.json"
local Saved = {}

if readfile and isfile and isfile(CONFIG_FILE) then
    pcall(function()
        Saved = HttpService:JSONDecode(readfile(CONFIG_FILE))
    end)
end

local function SaveConfig()
    if writefile then
        writefile(CONFIG_FILE,HttpService:JSONEncode(Saved))
    end
end

local UserInputService = game:GetService("UserInputService")
local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local TweenService = game:GetService("TweenService")
local CoreGui = game:GetService("CoreGui")
local Workspace = game:GetService("Workspace")
local ReplicatedStorage = game:GetService("ReplicatedStorage")

local lp = Players.LocalPlayer
local ScreenGui = Instance.new("ScreenGui")
ScreenGui.Name = "KawatanHub_Official"
ScreenGui.Parent = CoreGui
ScreenGui.ResetOnSpawn = false

--------------------------------------------------------------------------- Color Palette
local COLORS = {
    MainBG = Color3.fromRGB(11, 14, 20),
    TabBG = Color3.fromRGB(15, 20, 28),
    Border = Color3.fromRGB(35, 125, 255),
    TextActive = Color3.fromRGB(35, 125, 255),
    TextInactive = Color3.fromRGB(140, 140, 140),
    RowBG = Color3.fromRGB(18, 24, 35)
}

-------------------------------------------------------------------------
-- UI CORE ENGINE
-------------------------------------------------------------------------
local function create(class, props)
    local obj = Instance.new(class)
    for k, v in pairs(props) do if k ~= "Parent" then obj[k] = v end end
    obj.Parent = props.Parent
    return obj
end-------------------------------------------------------------------------
-- SAFE FOLLOW MODULE (Lock Target)
-------------------------------------------------------------------------
local SafeFollow = {
    Enabled = false,
    Locked = false,
    FOLLOW_DISTANCE = 6,
    lastMove = 0,
    gui = nil,
    btn = nil,
    targetChar = nil,
    heartbeatConn = nil,
    charAddedConn = nil
}

-- Function to create the Safe Follow UI
local function createSafeFollowUI()
    SafeFollow.gui = Instance.new("ScreenGui")
    SafeFollow.gui.Name = "SafeFollowUI"
    SafeFollow.gui.ResetOnSpawn = false
    SafeFollow.gui.Enabled = false
    SafeFollow.gui.Parent = CoreGui

    SafeFollow.btn = Instance.new("TextButton")
    SafeFollow.btn.Size = UDim2.new(0, 120, 0, 40)
    SafeFollow.btn.Position = UDim2.new(0.5, -60, 0.8, 0)
    SafeFollow.btn.Text = "LOCK"
    SafeFollow.btn.Font = Enum.Font.GothamBold
    SafeFollow.btn.TextSize = 14
    SafeFollow.btn.TextColor3 = Color3.new(1, 1, 1)
    SafeFollow.btn.BackgroundColor3 = Color3.fromRGB(43, 160, 235)
    SafeFollow.btn.AutoButtonColor = true
    SafeFollow.btn.Parent = SafeFollow.gui

    local uiCorner = Instance.new("UICorner")
    uiCorner.CornerRadius = UDim.new(0, 8)
    uiCorner.Parent = SafeFollow.btn

    -- Dragging functionality
    local dragging, dragInput, dragStart, startPos

    local function update(input)
        local delta = input.Position - dragStart
        SafeFollow.btn.Position = UDim2.new(startPos.X.Scale, startPos.X.Offset + delta.X, startPos.Y.Scale, startPos.Y.Offset + delta.Y)
    end

    SafeFollow.btn.InputBegan:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
            dragging = true
            dragStart = input.Position
            startPos = SafeFollow.btn.Position

            input.Changed:Connect(function()
                if input.UserInputState == Enum.UserInputState.End then
                    dragging = false
                end
            end)
        end
    end)

    SafeFollow.btn.InputChanged:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch then
            dragInput = input
        end
    end)

    UserInputService.InputChanged:Connect(function(input)
        if input == dragInput and dragging then
            update(input)
        end
    end)

    -- Toggle button functionality
    SafeFollow.btn.MouseButton1Click:Connect(function()
        SafeFollow.Locked = not SafeFollow.Locked
        if SafeFollow.Locked then
            SafeFollow.btn.Text = "LOCK"
            SafeFollow.btn.BackgroundColor3 = Color3.fromRGB(255, 65, 65)
        else
            SafeFollow.btn.Text = "LOCK"
            SafeFollow.btn.BackgroundColor3 = Color3.fromRGB(43, 160, 235)
        end
    end)

    task.delay(1,function()
        if active then
            callback(true)
        end
    end)
end

-- Function to get nearest player
local function getNearestPlayer(character, hrp)
    local nearest, dist = nil, math.huge
    for _, p in pairs(Players:GetPlayers()) do
        if p ~= lp and p.Character and p.Character:FindFirstChild("HumanoidRootPart") then
            local d = (p.Character.HumanoidRootPart.Position - hrp.Position).Magnitude
            if d < dist then
                dist = d
                nearest = p.Character
            end
        end
    end
    return nearest
end

-- Function to start Safe Follow
local function startSafeFollow()
    if SafeFollow.heartbeatConn then
        SafeFollow.heartbeatConn:Disconnect()
    end

    SafeFollow.heartbeatConn = RunService.Heartbeat:Connect(function()
        if not SafeFollow.Enabled or not SafeFollow.Locked then
            return
        end

        local character = lp.Character
        if not character then return end

        local hrp = character:FindFirstChild("HumanoidRootPart")
        local hum = character:FindFirstChild("Humanoid")

        if not hrp or not hum then return end

        -- Aqui definimos a velocidade para 55
        hum.Walk  = 55

        if tick() - SafeFollow.lastMove < 0.15 then return end
        SafeFollow.lastMove = tick()

        -- If no target or target is invalid, get nearest
        if not SafeFollow.targetChar or not SafeFollow.targetChar.Parent then
            SafeFollow.targetChar = getNearestPlayer(character, hrp)
            return
        end

        local trgHRP = SafeFollow.targetChar:FindFirstChild("HumanoidRootPart")
        local trgHum = SafeFollow.targetChar:FindFirstChild("Humanoid")

        if not trgHRP or not trgHum or trgHum.Health <= 0 then
            SafeFollow.targetChar = getNearestPlayer(character, hrp)
            return
        end

        local direction = (trgHRP.Position - hrp.Position)
        direction = Vector3.new(direction.X, 0, direction.Z)

        if direction.Magnitude > 0 then
            local moveDistance = math.min(direction.Magnitude, SafeFollow.FOLLOW_DISTANCE)
            local goalPos = hrp.Position + direction.Unit * moveDistance
            hum:MoveTo(goalPos)
        end
    end)

    task.delay(1,function()
        if active then
            callback(true)
        end
    end)
end

-- Function to enable Safe Follow
local function enableSafeFollow()
    if SafeFollow.Enabled then return end

    SafeFollow.Enabled = true

    -- Create UI if it doesn't exist
    if not SafeFollow.gui then
        createSafeFollowUI()
    end

    SafeFollow.gui.Enabled = true

    -- Reset locked state
    SafeFollow.Locked = false
    if SafeFollow.btn then
        SafeFollow.btn.Text = "LOCK"
        SafeFollow.btn.BackgroundColor3 = Color3.fromRGB(43, 160, 235)
    end

    -- Start the follow logic
    startSafeFollow()

    -- Handle character added
    SafeFollow.charAddedConn = lp.CharacterAdded:Connect(function(c)
        local hum = c:WaitForChild("Humanoid", 5)
        if hum then
            hum.AutoRotate = true
        end
    end)

    -- Set current character's auto rotate
    if lp.Character and lp.Character:FindFirstChild("Humanoid") then
        lp.Character.Humanoid.AutoRotate = true
    end
end

-- Function to disable Safe Follow
local function disableSafeFollow()
    if not SafeFollow.Enabled then return end

    SafeFollow.Enabled = false
    SafeFollow.Locked = false

    -- Hide UI
    if SafeFollow.gui then
        SafeFollow.gui.Enabled = false
    end

    -- Disconnect connections
    if SafeFollow.heartbeatConn then
        SafeFollow.heartbeatConn:Disconnect()
        SafeFollow.heartbeatConn = nil
    end

    if SafeFollow.charAddedConn then
        SafeFollow.charAddedConn:Disconnect()
        SafeFollow.charAddedConn = nil
    end

    -- Reset target
    SafeFollow.targetChar = nil

    -- Reset auto rotate
    if lp.Character and lp.Character:FindFirstChild("Humanoid") then
        lp.Character.Humanoid.AutoRotate = true
    end
end


local ToggleIcon = create("TextButton", {
    Size = UDim2.new(0, 60, 0, 60),
    Position = UDim2.new(0.05, 0, 0.2, 0),

    BackgroundColor3 = Color3.fromRGB(43,160,235),
    Text = "",

    Parent = ScreenGui
})

create("UICorner", {
    CornerRadius = UDim.new(0,6),
    Parent = ToggleIcon
})

create("UIStroke", {
    Color = Color3.fromRGB(255,255,255),
    Thickness = 1.2,
    Parent = ToggleIcon
})

-- Container das linhas
local LineContainer = Instance.new("Frame")
LineContainer.Size = UDim2.new(0.6,0,0.5,0)
LineContainer.Position = UDim2.new(0.2,0,0.25,0)
LineContainer.BackgroundTransparency = 1
LineContainer.Parent = ToggleIcon

local layout = Instance.new("UIListLayout")
layout.FillDirection = Enum.FillDirection.Vertical
layout.HorizontalAlignment = Enum.HorizontalAlignment.Center
layout.VerticalAlignment = Enum.VerticalAlignment.Center
layout.Padding = UDim.new(0,4) -- espaço pequeno entre linhas
layout.Parent = LineContainer

-- função para criar linha
local function createLine()
    local line = Instance.new("Frame")
    line.Size = UDim2.new(1,0,0,5) -- linhas grandes
    line.BackgroundColor3 = Color3.fromRGB(255,255,255)
    line.BorderSizePixel = 0
    line.Parent = LineContainer

    local corner = Instance.new("UICorner")
    corner.CornerRadius = UDim.new(1,0)
    corner.Parent = line
end

createLine()
createLine()
createLine()


local MainFrame = create("Frame", {
    Size = UDim2.new(0, 220, 0, 260), -- interface menor
    Position = UDim2.new(0.04, 0, 0.40, 0), -- lado esquerdo mais centralizado
    BackgroundColor3 = COLORS.MainBG,
    BackgroundTransparency = 0.2,
    Visible = false,
    Parent = ScreenGui
})

create("UICorner", {
    CornerRadius = UDim.new(0, 12),
    Parent = MainFrame
})

-- SEM CONTORNO NA INTERFACE

-- HEADER
local Header = create("Frame", {
    Size = UDim2.new(1,0,0,40),
    BackgroundTransparency = 1,
    Parent = MainFrame
})

create("TextLabel", {
    Text = "Kawatan Hub (.gg/Elys1um)",
    TextColor3 = Color3.fromRGB(85,170,255), -- azul claro igual botão
    Font = "GothamBold",
    TextSize = 16,
    Size = UDim2.new(1,0,1,0),
    BackgroundTransparency = 1,
    Parent = Header
})




local TabContainer = create("Frame", {
    Size = UDim2.new(0.92, 0, 0, 30), Position = UDim2.new(0.04, 0, 0.13, 0),
    BackgroundColor3 = COLORS.TabBG, Parent = MainFrame
})
create("UICorner", {CornerRadius = UDim.new(0, 6), Parent = TabContainer})
local TabList = create("UIListLayout", {FillDirection = "Horizontal", HorizontalAlignment = "Center", Parent = TabContainer})

local PageContainer = create("Frame", {
    Size = UDim2.new(1, 0, 0.75, 0), Position = UDim2.new(0, 0, 0.22, 0),
    BackgroundTransparency = 1, Parent = MainFrame
})

local HttpService = game:GetService("HttpService")

local Pages = {}
local TabButtons = {}

local function CreatePage(name)
    local Page = create("ScrollingFrame", {
        Size = UDim2.new(1, 0, 1, 0),
        BackgroundTransparency = 1,
        Visible = false,
        ScrollBarThickness = 0,
        AutomaticCanvasSize = "Y",
        Parent = PageContainer
    })

    create("UIListLayout", {
        HorizontalAlignment = "Center",
        Padding = UDim.new(0, 8),
        Parent = Page
    })

    Pages[name] = Page

    local TabBtn = create("TextButton", {
        Size = UDim2.new(0.25, 0, 1, 0),
        BackgroundTransparency = 1,
        Text = name,
        TextColor3 = COLORS.TextInactive,
        Font = "GothamBold",
        TextSize = 10,
        Parent = TabContainer
    })

    TabBtn.MouseButton1Click:Connect(function()
        for _, p in pairs(Pages) do
            p.Visible = false
        end

        for _, b in pairs(TabButtons) do
            b.TextColor3 = COLORS.TextInactive
        end

        Page.Visible = true
        TabBtn.TextColor3 = COLORS.TextActive
    end)

    TabButtons[name] = TabBtn
end


local function AddToggle(pageName, labelText, default, callback)
    local active = Saved[labelText] ~= nil and Saved[labelText] or default

    local Row = create("Frame", {
        Size = UDim2.new(0.92, 0, 0, 50),
        BackgroundColor3 = COLORS.RowBG,
        BackgroundTransparency = 0.5,
        Parent = Pages[pageName]
    })

    create("UICorner", {CornerRadius = UDim.new(0, 8), Parent = Row})
    create("UIStroke", {Color = Color3.fromRGB(255,255,255), Thickness = 1, Transparency = 0, Parent = Row})

    create("TextLabel", {
        Text = labelText,
        Size = UDim2.new(0.6, 0, 1, 0),
        Position = UDim2.new(0.05, 0, 0, 0),
        TextColor3 = Color3.new(1,1,1),
        Font = "GothamBold",
        TextSize = 13,
        BackgroundTransparency = 1,
        TextXAlignment = "Left",
        Parent = Row
    })

    local TglBg = create("Frame", {
        Size = UDim2.new(0, 42, 0, 20),
        Position = UDim2.new(0.95, -42, 0.5, -10),
        BackgroundColor3 = active and COLORS.Border or Color3.fromRGB(40,45,55),
        Parent = Row
    })

    create("UICorner", {CornerRadius = UDim.new(1,0), Parent = TglBg})

    local Circle = create("Frame", {
        Size = UDim2.new(0,16,0,16),
        Position = active and UDim2.new(0.55,0,0.1,0) or UDim2.new(0.1,0,0.1,0),
        BackgroundColor3 = Color3.new(1,1,1),
        Parent = TglBg
    })

    create("UICorner", {CornerRadius = UDim.new(1,0), Parent = Circle})

    local Btn = create("TextButton", {
        Size = UDim2.new(1,0,1,0),
        BackgroundTransparency = 1,
        Text = "",
        Parent = Row
    })

    Btn.MouseButton1Click:Connect(function()
        active = not active

        TweenService:Create(TglBg, TweenInfo.new(0.2), {
            BackgroundColor3 = active and COLORS.Border or Color3.fromRGB(40,45,55)
        }):Play()

        TweenService:Create(Circle, TweenInfo.new(0.2), {
            Position = active and UDim2.new(0.55,0,0.1,0) or UDim2.new(0.1,0,0.1,0)
        }):Play()

        Saved[labelText]=active
        SaveConfig()
        callback(active)
    end)

    task.delay(1,function()
        if active then
            callback(true)
        end
    end)
end


-- CRIAR PÁGINAS
for _, tab in ipairs({"Combat","Protect","Visual","Settings"}) do
    CreatePage(tab)
end

TabButtons["Combat"].TextColor3 = COLORS.TextActive
Pages["Combat"].Visible = true


-- BOTÃO SAVE SETTINGS
local SaveRow = create("Frame", {
    Size = UDim2.new(0.92,0,0,50),
    BackgroundColor3 = COLORS.RowBG,
    BackgroundTransparency = 0.5,
    Parent = Pages["Settings"]
})

create("UICorner",{CornerRadius = UDim.new(0,8),Parent = SaveRow})
create("UIStroke",{Color = Color3.fromRGB(255,255,255),Thickness = 1,Parent = SaveRow})

local SaveLabel = create("TextLabel",{
    Text = "SAVE SETTINGS📸",
    Size = UDim2.new(1,0,1,0),
    BackgroundTransparency = 1,
    TextColor3 = Color3.new(1,1,1),
    Font = "GothamBold",
    TextSize = 13,
    Parent = SaveRow
})

local SaveBtn = create("TextButton",{
    Size = UDim2.new(1,0,1,0),
    BackgroundTransparency = 1,
    Text = "",
    Parent = SaveRow
})

SaveBtn.MouseButton1Click:Connect(function()

    SaveLabel.Text = "SAVED✌🏼"

    local data = {}

    for name,page in pairs(Pages) do
        data[name] = page.CanvasPosition.Y
    end

    local json = HttpService:JSONEncode(data)

    if writefile then
        writefile("hub_settings.json",json)
    end

    task.wait(3)

    SaveLabel.Text = "SAVE SETTINGS📸"

end)

-- SAFE FOLLOW MODULE (Lock Target)

local LOCK_RADIUS = 70
local LOCK_SPEED = 50

local SafeFollow = {
Enabled = false,
Locked = false,
lastMove = 0,
gui = nil,
btn = nil,
targetChar = nil,
heartbeatConn = nil,
charAddedConn = nil,

att = nil,
lv = nil,
gyro = nil

}

-- Function to create the Safe Follow UI
local function createSafeFollowUI()

SafeFollow.gui = Instance.new("ScreenGui")
SafeFollow.gui.Name = "SafeFollowUI"
SafeFollow.gui.ResetOnSpawn = false
SafeFollow.gui.Enabled = false
SafeFollow.gui.Parent = CoreGui

local savedPos = Saved.LockPos

SafeFollow.btn = Instance.new("TextButton")
SafeFollow.btn.Size = UDim2.new(0,120,0,40)

if savedPos then
    SafeFollow.btn.Position = UDim2.new(savedPos.XS,savedPos.XO,savedPos.YS,savedPos.YO)
else
    SafeFollow.btn.Position = UDim2.new(0.5,-60,0.8,0)
end

SafeFollow.btn.Text = "LOCK"
SafeFollow.btn.Font = Enum.Font.GothamBold
SafeFollow.btn.TextSize = 14
SafeFollow.btn.TextColor3 = Color3.new(1,1,1)
SafeFollow.btn.BackgroundColor3 = Color3.fromRGB(43,160,235)
SafeFollow.btn.Parent = SafeFollow.gui

local uiCorner = Instance.new("UICorner")
uiCorner.CornerRadius = UDim.new(0,8)
uiCorner.Parent = SafeFollow.btn


-- seta ^
local toggleBtn = Instance.new("TextButton")
toggleBtn.Size = UDim2.new(0,18,0,18)
toggleBtn.Position = UDim2.new(1,-20,0,2)
toggleBtn.Text = "^"
toggleBtn.Font = Enum.Font.GothamBold
toggleBtn.TextSize = 14
toggleBtn.TextColor3 = Color3.new(1,1,1)
toggleBtn.BackgroundTransparency = 1
toggleBtn.Parent = SafeFollow.btn


-- botão Save
local saveBtn = Instance.new("TextButton")
saveBtn.Size = UDim2.new(0,120,0,25)
saveBtn.Position = UDim2.new(0,0,1,4)
saveBtn.Text = "Save"
saveBtn.Visible = false
saveBtn.Font = Enum.Font.Gotham
saveBtn.TextSize = 13
saveBtn.TextColor3 = Color3.new(1,1,1)
saveBtn.BackgroundColor3 = Color3.fromRGB(50,50,50)
saveBtn.Parent = SafeFollow.btn

local corner3 = Instance.new("UICorner")
corner3.Parent = saveBtn


-- mostrar/esconder botão Save
toggleBtn.MouseButton1Click:Connect(function()
    saveBtn.Visible = not saveBtn.Visible
end)


-- salvar posição
saveBtn.MouseButton1Click:Connect(function()

    local pos = SafeFollow.btn.Position

    Saved.LockPos = {
        XS = pos.X.Scale,
        XO = pos.X.Offset,
        YS = pos.Y.Scale,
        YO = pos.Y.Offset
    }

    SaveConfig()

end)


-- Drag system
local dragging, dragInput, dragStart, startPos

local function update(input)
    local delta = input.Position - dragStart
    SafeFollow.btn.Position =
        UDim2.new(
            startPos.X.Scale,
            startPos.X.Offset + delta.X,
            startPos.Y.Scale,
            startPos.Y.Offset + delta.Y
        )
end

SafeFollow.btn.InputBegan:Connect(function(input)

    if input.UserInputType == Enum.UserInputType.MouseButton1
    or input.UserInputType == Enum.UserInputType.Touch then

        dragging = true
        dragStart = input.Position
        startPos = SafeFollow.btn.Position

        input.Changed:Connect(function()

            if input.UserInputState == Enum.UserInputState.End then
                dragging = false
            end

        end)
    end
end)

SafeFollow.btn.InputChanged:Connect(function(input)

    if input.UserInputType == Enum.UserInputType.MouseMovement
    or input.UserInputType == Enum.UserInputType.Touch then
        dragInput = input
    end

end)

UserInputService.InputChanged:Connect(function(input)

    if input == dragInput and dragging then
        update(input)
    end

end)


-- Toggle button
SafeFollow.btn.MouseButton1Click:Connect(function()

    SafeFollow.Locked = not SafeFollow.Locked

    if SafeFollow.Locked then
        SafeFollow.btn.BackgroundColor3 = Color3.fromRGB(255,65,65)
    else
        SafeFollow.btn.BackgroundColor3 = Color3.fromRGB(43,160,235)
    end

end)

end

-- Get nearest player
local function getNearestPlayer()

local char = lp.Character
if not char then return nil end

local hrp = char:FindFirstChild("HumanoidRootPart")
if not hrp then return nil end

local nearest = nil
local nearestDist = LOCK_RADIUS

for _,p in pairs(Players:GetPlayers()) do

    if p ~= lp then

        local pc = p.Character
        local phrp = pc and pc:FindFirstChild("HumanoidRootPart")

        if phrp then

            local d = (phrp.Position - hrp.Position).Magnitude

            if d <= nearestDist then
                nearest = pc
                nearestDist = d
            end

        end
    end
end

return nearest

end

-- Start follow logic
local function startSafeFollow()

if SafeFollow.heartbeatConn then
    SafeFollow.heartbeatConn:Disconnect()
end

local char = lp.Character
if not char then return end

local hrp = char:FindFirstChild("HumanoidRootPart")
if not hrp then return end

SafeFollow.att = Instance.new("Attachment", hrp)

SafeFollow.lv = Instance.new("LinearVelocity", hrp)
SafeFollow.lv.Attachment0 = SafeFollow.att
SafeFollow.lv.MaxForce = 50000
SafeFollow.lv.RelativeTo = Enum.ActuatorRelativeTo.World
SafeFollow.lv.Enabled = false

SafeFollow.gyro = Instance.new("AlignOrientation", hrp)
SafeFollow.gyro.Attachment0 = SafeFollow.att
SafeFollow.gyro.MaxTorque = 50000
SafeFollow.gyro.Responsiveness = 120
SafeFollow.gyro.Enabled = false

SafeFollow.heartbeatConn = RunService.Heartbeat:Connect(function()

    if not SafeFollow.Enabled or not SafeFollow.Locked then
        SafeFollow.lv.Enabled = false
        SafeFollow.gyro.Enabled = false
        return
    end

    local character = lp.Character
    if not character then return end

    local hrp = character:FindFirstChild("HumanoidRootPart")
    if not hrp then return end

    if not SafeFollow.targetChar or not SafeFollow.targetChar.Parent then
        SafeFollow.targetChar = getNearestPlayer()
        return
    end

    local trgHRP = SafeFollow.targetChar:FindFirstChild("HumanoidRootPart")

    if not trgHRP then
        SafeFollow.targetChar = getNearestPlayer()
        return
    end

    SafeFollow.lv.Enabled = true
    SafeFollow.gyro.Enabled = true

    local frontPos = trgHRP.Position + trgHRP.CFrame.LookVector * 2.2
    local dir = frontPos - hrp.Position

    if dir.Magnitude > 0.5 then
        SafeFollow.lv.VectorVelocity = dir.Unit * LOCK_SPEED
    else
        SafeFollow.lv.VectorVelocity = Vector3.zero
    end

    SafeFollow.gyro.CFrame = CFrame.lookAt(hrp.Position, frontPos)

end)

end

-- Enable
local function enableSafeFollow()

if SafeFollow.Enabled then return end

SafeFollow.Enabled = true

if not SafeFollow.gui then
    createSafeFollowUI()
end

SafeFollow.gui.Enabled = true
SafeFollow.Locked = false

if SafeFollow.btn then
    SafeFollow.btn.BackgroundColor3 = Color3.fromRGB(43,160,235)
end

startSafeFollow()

end

-- Disable
local function disableSafeFollow()

if not SafeFollow.Enabled then return end

SafeFollow.Enabled = false
SafeFollow.Locked = false

if SafeFollow.gui then
    SafeFollow.gui.Enabled = false
end

if SafeFollow.heartbeatConn then
    SafeFollow.heartbeatConn:Disconnect()
    SafeFollow.heartbeatConn = nil
end

if SafeFollow.lv then
    SafeFollow.lv:Destroy()
    SafeFollow.lv = nil
end

if SafeFollow.gyro then
    SafeFollow.gyro:Destroy()
    SafeFollow.gyro = nil
end

if SafeFollow.att then
    SafeFollow.att:Destroy()
    SafeFollow.att = nil
end

SafeFollow.targetChar = nil

end
-------------------------------------------------------------------------
-- IMPROVED ANTI-RAGDOLL MODULE (Replaced)
-------------------------------------------------------------------------
local AntiRagdoll = {
    Enabled = false,
    RAGDOLL_SPEED = 16,   -- movement speed while "ragdolled" (adjustable)

    currentCharacter = nil,
    ragdollRemoteConnection = nil,
    moveConnection = nil,
    playerModule = nil,
    controls = nil
}

-- Safely load PlayerModule controls
pcall(function()
    AntiRagdoll.playerModule = require(lp:WaitForChild("PlayerScripts"):WaitForChild("PlayerModule"))
    AntiRagdoll.controls = AntiRagdoll.playerModule:GetControls()
end)

-- ────────────────────────────────────────────────
--  Cleanup functions
-- ────────────────────────────────────────────────

local function cleanupRagdoll()
    if AntiRagdoll.currentCharacter then
        local root = AntiRagdoll.currentCharacter:FindFirstChild("HumanoidRootPart")
        if root then
            local anchor = root:FindFirstChild("RagdollAnchor")
            if anchor then
                anchor:Destroy()
            end
        end
    end

    if AntiRagdoll.moveConnection then
        AntiRagdoll.moveConnection:Disconnect()
        AntiRagdoll.moveConnection = nil
    end
end

local function disconnectRemote()
    if AntiRagdoll.ragdollRemoteConnection then
        AntiRagdoll.ragdollRemoteConnection:Disconnect()
        AntiRagdoll.ragdollRemoteConnection = nil
    end
end

-- ────────────────────────────────────────────────
--  Core anti-ragdoll logic (intercepts remote "Make"/"Destroy")
-- ────────────────────────────────────────────────

local function setupAntiRagdoll(char)
    AntiRagdoll.currentCharacter = char

    cleanupRagdoll()
    disconnectRemote()

    local humanoid = char:WaitForChild("Humanoid", 5)
    local root     = char:WaitForChild("HumanoidRootPart", 5)
    local head     = char:WaitForChild("Head", 5)

    if not (humanoid and root and head) then return end

    -- Path to the ragdoll remote (game-specific)
    local ragdollRemote = ReplicatedStorage:WaitForChild("Packages", 8)
                             :WaitForChild("Ragdoll", 5)
                             :WaitForChild("Ragdoll", 5)

    if not ragdollRemote or not ragdollRemote:IsA("RemoteEvent") then
        warn("[Anti-Ragdoll] Could not find Ragdoll remote")
        return
    end

    -- Listen for ragdoll trigger from server
    AntiRagdoll.ragdollRemoteConnection = ragdollRemote.OnClientEvent:Connect(function(arg1, arg2)
        if not AntiRagdoll.Enabled then return end

        -- Server wants to ragdoll → fake it and allow movement
        if arg1 == "Make" or arg2 == "manualM" then
            humanoid:ChangeState(Enum.HumanoidStateType.Freefall)
            Workspace.CurrentCamera.CameraSubject = head
            root.CanCollide = false

            -- Re-enable controls so WASD still works
            if AntiRagdoll.controls then
                pcall(AntiRagdoll.controls.Enable, AntiRagdoll.controls)
            end

            cleanupRagdoll()

            -- Anchor the player in place but allow controlled movement
            local anchor = Instance.new("BodyPosition")
            anchor.Name      = "RagdollAnchor"
            anchor.MaxForce  = Vector3.new(1e6, 1e6, 1e6)
            anchor.P         = 5000
            anchor.D         = 1000
            anchor.Position  = root.Position
            anchor.Parent    = root

            -- Smooth movement while anchored
            AntiRagdoll.moveConnection = RunService.RenderStepped:Connect(function()
                if not AntiRagdoll.Enabled or not anchor or not anchor.Parent then
                    if AntiRagdoll.moveConnection then
                        AntiRagdoll.moveConnection:Disconnect()
                        AntiRagdoll.moveConnection = nil
                    end
                    return
                end

                local moveDir = humanoid.MoveDirection
                if moveDir.Magnitude > 0 then
                    anchor.Position = root.Position + moveDir.Unit * AntiRagdoll.RAGDOLL_SPEED
                else
                    anchor.Position = root.Position
                end
            end)
        end

        -- Server wants to un-ragdoll → clean up
        if arg1 == "Destroy" or arg2 == "manualD" then
            humanoid:ChangeState(Enum.HumanoidStateType.GettingUp)
            Workspace.CurrentCamera.CameraSubject = humanoid
            root.CanCollide = true

            if AntiRagdoll.controls then
                pcall(AntiRagdoll.controls.Enable, AntiRagdoll.controls)
            end

            cleanupRagdoll()
        end
    end)

    task.delay(1,function()
        if active then
            callback(true)
        end
    end)
end

-- Character event connections
lp.CharacterAdded:Connect(function(char)
    if AntiRagdoll.Enabled then
        setupAntiRagdoll(char)
    end
end)

lp.CharacterRemoving:Connect(function()
    cleanupRagdoll()
    disconnectRemote()
    AntiRagdoll.currentCharacter = nil
end)

-------------------------------------------------------------------------
-- ANTI TURRET
-------------------------------------------------------------------------
local AntiTurret = { Enabled = false, Target = nil, Conn = nil, Dist = 60, Pull = -5 }
local function getWeapon() return lp.Backpack:FindFirstChild("Bat") or (lp.Character and lp.Character:FindFirstChild("Bat")) end

local function findTurret()
    local char = lp.Character
    if not char or not char:FindFirstChild("HumanoidRootPart") then return end
    for _, obj in pairs(Workspace:GetChildren()) do
        if obj.Name:find("Sentry") and not obj.Name:lower():find("bullet") then
            local ownerId = obj.Name:match("Sentry_(%d+)")
            if ownerId and tonumber(ownerId) == lp.UserId then continue end
            local part = obj:IsA("BasePart") and obj or (obj:IsA("Model") and (obj.PrimaryPart or obj:FindFirstChildWhichIsA("BasePart")))
            if part and (char.HumanoidRootPart.Position - part.Position).Magnitude <= AntiTurret.Dist then return obj end
        end
    end
end

-------------------------------------------------------------------------
-- XRAY BASE MODULE
-------------------------------------------------------------------------
local XrayBase = {
    Enabled = false,
    OriginalTransparency = {},
    Connections = {},
    BaseKeywords = {"base", "claim"}
}

local function isPlayerBase(obj)
    if not (obj:IsA("BasePart") or obj:IsA("MeshPart") or obj:IsA("UnionOperation")) then
        return false
    end
    local n = obj.Name:lower()
    local p = obj.Parent and obj.Parent.Name:lower() or ""
    for _, keyword in ipairs(XrayBase.BaseKeywords) do
        if n:find(keyword) or p:find(keyword) then
            return true
        end
    end
    return false
end

local function applyTransparency(obj)
    if isPlayerBase(obj) then
        if not XrayBase.OriginalTransparency[obj] then
            XrayBase.OriginalTransparency[obj] = obj.LocalTransparencyModifier
        end
        obj.LocalTransparencyModifier = 0.8
    end
end

local function restoreTransparency(obj)
    if XrayBase.OriginalTransparency[obj] then
        obj.LocalTransparencyModifier = XrayBase.OriginalTransparency[obj]
        XrayBase.OriginalTransparency[obj] = nil
    end
end

local function enableXrayBase()
    if XrayBase.Enabled then return end
    XrayBase.Enabled = true

    -- Apply to existing parts
    for _, obj in ipairs(Workspace:GetDescendants()) do
        applyTransparency(obj)
    end

    -- Set up connections for new parts
    XrayBase.Connections.descendantAdded = Workspace.DescendantAdded:Connect(function(obj)
        applyTransparency(obj)
    end)

    XrayBase.Connections.characterAdded = lp.CharacterAdded:Connect(function()
        task.wait(0.5)
        for _, obj in ipairs(Workspace:GetDescendants()) do
            applyTransparency(obj)
        end
    end)

    task.delay(1,function()
        if active then
            callback(true)
        end
    end)
end

local function disableXrayBase()
    if not XrayBase.Enabled then return end
    XrayBase.Enabled = false

    -- Disconnect connections
    for _, conn in pairs(XrayBase.Connections) do
        conn:Disconnect()
    end
    XrayBase.Connections = {}

    -- Restore transparency
    for obj, original in pairs(XrayBase.OriginalTransparency) do
        obj.LocalTransparencyModifier = original
    end
    XrayBase.OriginalTransparency = {}
end

-------------------------------------------------------------------------
-- NO ANIMATIONS MODULE
-------------------------------------------------------------------------
local NoAnim = {
    Enabled = false,
    CharacterConnections = {}
}

local function disableAnims(character)
    local humanoid = character:FindFirstChildOfClass("Humanoid")
    if not humanoid then return end

    -- Stop all current animations
    for _, track in pairs(humanoid:GetPlayingAnimationTracks()) do
        track:Stop()
    end

    -- Prevent new animations from playing
    if NoAnim.CharacterConnections[character] then
        NoAnim.CharacterConnections[character]:Disconnect()
    end

    NoAnim.CharacterConnections[character] = humanoid.AnimationPlayed:Connect(function(track)
        track:Stop()
    end)

    task.delay(1,function()
        if active then
            callback(true)
        end
    end)
end

local function enableNoAnim()
    if NoAnim.Enabled then return end
    NoAnim.Enabled = true

    -- Run for current character
    if lp.Character then
        disableAnims(lp.Character)
    end

    -- Run for respawns
    NoAnim.CharacterConnections.characterAdded = lp.CharacterAdded:Connect(function(char)
        disableAnims(char)
    end)

    task.delay(1,function()
        if active then
            callback(true)
        end
    end)
end

local function disableNoAnim()
    if not NoAnim.Enabled then return end
    NoAnim.Enabled = false

    -- Disconnect character added connection
    if NoAnim.CharacterConnections.characterAdded then
        NoAnim.CharacterConnections.characterAdded:Disconnect()
        NoAnim.CharacterConnections.characterAdded = nil
    end

    -- Disconnect all per-character connections
    for character, conn in pairs(NoAnim.CharacterConnections) do
        if character ~= "characterAdded" then
            conn:Disconnect()
            NoAnim.CharacterConnections[character] = nil
        end
    end

    -- Re-enable animations for current character
    if lp.Character then
        local humanoid = lp.Character:FindFirstChildOfClass("Humanoid")
        if humanoid then
            -- Remove the animation blocker connection
            if NoAnim.CharacterConnections[lp.Character] then
                NoAnim.CharacterConnections[lp.Character]:Disconnect()
                NoAnim.CharacterConnections[lp.Character] = nil
            end
        end
    end
end

-------------------------------------------------------------------------
-- PLAYER ESP MODULE
-------------------------------------------------------------------------
local PlayerESP = {
    Enabled = false,
    ESP_COLOR = Color3.fromRGB(85, 170, 255),
    Highlights = {},
    Billboards = {},
    Connections = {}
}

-- CREATE HIGHLIGHT
local function createHighlight(character)
    local h = Instance.new("Highlight")
    h.Name = "Kawatan_PlayerESP_Highlight"
    h.Adornee = character
    h.FillColor = PlayerESP.ESP_COLOR
    h.FillTransparency = 0.25
    h.OutlineColor = PlayerESP.ESP_COLOR
    h.OutlineTransparency = 0
    h.DepthMode = Enum.HighlightDepthMode.AlwaysOnTop
    h.Parent = CoreGui
    return h
end

-- CREATE NAME TAG
local function createBillboard(character, player)
    local hrp = character:WaitForChild("HumanoidRootPart", 5)
    if not hrp then return nil end

    local bb = Instance.new("BillboardGui")
    bb.Name = "Kawatan_PlayerESP_Name"
    bb.Adornee = hrp
    bb.AlwaysOnTop = true
    bb.Size = UDim2.new(0, 100, 0, 20)
    bb.StudsOffsetWorldSpace = Vector3.new(0, 3, 0)
    bb.MaxDistance = 600
    bb.Parent = CoreGui

    local bg = Instance.new("Frame", bb)
    bg.Size = UDim2.new(1, 0, 1, 0)
    bg.BackgroundColor3 = Color3.fromRGB(0, 0, 0)
    bg.BackgroundTransparency = 0.4
    Instance.new("UICorner", bg).CornerRadius = UDim.new(0, 6)

    local txt = Instance.new("TextLabel", bg)
    txt.Size = UDim2.new(1, 0, 1, 0)
    txt.BackgroundTransparency = 1
    txt.Font = Enum.Font.GothamSemibold
    txt.TextSize = 13
    txt.TextColor3 = Color3.new(1, 1, 1)
    txt.TextStrokeTransparency = 0.2
    txt.Text = player.DisplayName

    return bb
end

-- ATTACH ESP TO PLAYER
local function attachESP(player)
    if player == lp then return end

    local function apply(character)
        if PlayerESP.Highlights[player] then
            pcall(function() PlayerESP.Highlights[player]:Destroy() end)
        end
        if PlayerESP.Billboards[player] then
            pcall(function() PlayerESP.Billboards[player]:Destroy() end)
        end

        PlayerESP.Highlights[player] = createHighlight(character)
        PlayerESP.Billboards[player] = createBillboard(character, player)
    end

    if player.Character then
        apply(player.Character)
    end

    local conn = player.CharacterAdded:Connect(apply)
    table.insert(PlayerESP.Connections, conn)
end

-- REMOVE ESP FROM PLAYER
local function removeESP(player)
    if PlayerESP.Highlights[player] then
        pcall(function() PlayerESP.Highlights[player]:Destroy() end)
        PlayerESP.Highlights[player] = nil
    end
    if PlayerESP.Billboards[player] then
        pcall(function() PlayerESP.Billboards[player]:Destroy() end)
        PlayerESP.Billboards[player] = nil
    end
end

-- ENABLE ESP
local function enableESP()
    if PlayerESP.Enabled then return end
    PlayerESP.Enabled = true

    -- Apply ESP to all current players
    for _, p in ipairs(Players:GetPlayers()) do
        attachESP(p)
    end

    -- Set up connections for new players
    table.insert(PlayerESP.Connections, Players.PlayerAdded:Connect(function(p)
        attachESP(p)
    end))

    -- Set up connection for players leaving
    table.insert(PlayerESP.Connections, Players.PlayerRemoving:Connect(function(p)
        removeESP(p)
    end))
end

-- DISABLE ESP
local function disableESP()
    if not PlayerESP.Enabled then return end
    PlayerESP.Enabled = false

    -- Remove all highlights and billboards
    for _, h in pairs(PlayerESP.Highlights) do
        pcall(function() h:Destroy() end)
    end
    for _, b in pairs(PlayerESP.Billboards) do
        pcall(function() b:Destroy() end)
    end

    -- Disconnect all connections
    for _, c in ipairs(PlayerESP.Connections) do
        pcall(function() c:Disconnect() end)
    end

    -- Clear storage
    PlayerESP.Highlights = {}
    PlayerESP.Billboards = {}
    PlayerESP.Connections = {}
end
-- SPEED CUSTOMIZER MODULE

local SpeedCustomizer = {
Enabled = false,
SpeedUI = nil,
SpeedValue = 58,
StealValue = 29,
JumpValue = 80,
GravityValue = 196.2,
HeartbeatConn = nil,
JumpConn = nil,
character = nil,
hrp = nil,
hum = nil
}

local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local UserInputService = game:GetService("UserInputService")
local Workspace = game:GetService("Workspace")
local lp = Players.LocalPlayer

---

-- LOAD SAVED VALUES

if Saved and Saved.SpeedConfig then
SpeedCustomizer.SpeedValue = Saved.SpeedConfig.Speed or 58
SpeedCustomizer.StealValue = Saved.SpeedConfig.Steal or 29
SpeedCustomizer.JumpValue = Saved.SpeedConfig.Jump or 80
SpeedCustomizer.GravityValue = Saved.SpeedConfig.Gravity or 196.2
Workspace.Gravity = SpeedCustomizer.GravityValue
end

---

-- CHARACTER SETUP

local function setupSpeedCharacter(char)
SpeedCustomizer.character = char
SpeedCustomizer.hrp = char:WaitForChild("HumanoidRootPart")
SpeedCustomizer.hum = char:WaitForChild("Humanoid")
end

---

-- CREATE UI

local function createSpeedUI()

local SpeedScreenGui = Instance.new("ScreenGui")
SpeedScreenGui.Name = "Kawatan_SpeedUI"
SpeedScreenGui.ResetOnSpawn = false
SpeedScreenGui.Parent = game:GetService("CoreGui")

local MainFrame = Instance.new("Frame")
MainFrame.Name = "SpeedMainFrame"
MainFrame.Size = UDim2.new(0,200,0,180)

if Saved and Saved.SpeedPos then
MainFrame.Position = UDim2.new(
Saved.SpeedPos.XS,
Saved.SpeedPos.XO,
Saved.SpeedPos.YS,
Saved.SpeedPos.YO
)
else
MainFrame.Position = UDim2.new(0.5,-100,0.4,0)
end

MainFrame.BackgroundColor3 = Color3.fromRGB(20,25,30)
MainFrame.BackgroundTransparency = 0.2
MainFrame.BorderSizePixel = 0
MainFrame.Active = true
MainFrame.Draggable = true
MainFrame.Parent = SpeedScreenGui

Instance.new("UICorner",MainFrame)

local UIStroke = Instance.new("UIStroke")
UIStroke.Color = Color3.fromRGB(50,150,250)
UIStroke.Thickness = 2
UIStroke.Parent = MainFrame

---

-- HEADER

local Header = Instance.new("Frame")
Header.Size = UDim2.new(1,-20,0,25)
Header.Position = UDim2.new(0,10,0,5)
Header.BackgroundTransparency = 1
Header.Parent = MainFrame

local CollapseBtn = Instance.new("TextButton")
CollapseBtn.Size = UDim2.new(0,20,0,20)
CollapseBtn.Position = UDim2.new(0,0,0,0)
CollapseBtn.Text = "^"
CollapseBtn.BackgroundTransparency = 1
CollapseBtn.TextColor3 = Color3.new(1,1,1)
CollapseBtn.Font = Enum.Font.GothamBold
CollapseBtn.TextSize = 14
CollapseBtn.Parent = Header

local Title = Instance.new("TextLabel")
Title.Size = UDim2.new(1,-40,1,0)
Title.Position = UDim2.new(0,20,0,0)
Title.BackgroundTransparency = 1
Title.Text = "Speed Customizer"
Title.TextColor3 = Color3.fromRGB(80,180,255)
Title.TextSize = 14
Title.TextXAlignment = Enum.TextXAlignment.Left
Title.Font = Enum.Font.GothamBold
Title.Parent = Header

local ArrowBtn = Instance.new("TextButton")
ArrowBtn.Size = UDim2.new(0,20,0,20)
ArrowBtn.Position = UDim2.new(1,-20,0,0)
ArrowBtn.Text = "^"
ArrowBtn.BackgroundTransparency = 1
ArrowBtn.TextColor3 = Color3.new(1,1,1)
ArrowBtn.Font = Enum.Font.GothamBold
ArrowBtn.TextSize = 14
ArrowBtn.Parent = Header

---

-- SAVE BUTTON

local SaveBtn = Instance.new("TextButton")
SaveBtn.Size = UDim2.new(1,-20,0,25)
SaveBtn.Position = UDim2.new(0,10,1,4)
SaveBtn.Text = "Save"
SaveBtn.Visible = false
SaveBtn.BackgroundColor3 = Color3.fromRGB(50,50,50)
SaveBtn.TextColor3 = Color3.new(1,1,1)
SaveBtn.Font = Enum.Font.Gotham
SaveBtn.TextSize = 13
SaveBtn.Parent = MainFrame

Instance.new("UICorner",SaveBtn)

ArrowBtn.MouseButton1Click:Connect(function()
SaveBtn.Visible = not SaveBtn.Visible
end)

---

-- ON OFF BUTTON

local ToggleBtn = Instance.new("TextButton")
ToggleBtn.Size = UDim2.new(1,-20,0,25)
ToggleBtn.Position = UDim2.new(0,10,0,35)
ToggleBtn.Text = "ON"
ToggleBtn.BackgroundColor3 = Color3.fromRGB(0,120,215)
ToggleBtn.TextColor3 = Color3.new(1,1,1)
ToggleBtn.Font = Enum.Font.GothamBold
ToggleBtn.TextSize = 14
ToggleBtn.Parent = MainFrame

Instance.new("UICorner",ToggleBtn)

---

-- INPUT ROW FUNCTION

local function createInputRow(text,value,pos)

local label = Instance.new("TextLabel")
label.Size = UDim2.new(0.6,0,0,20)
label.Position = UDim2.new(0,10,0,pos)
label.BackgroundTransparency = 1
label.Text = text
label.TextColor3 = Color3.fromRGB(200,200,200)
label.TextSize = 12
label.Font = Enum.Font.Gotham
label.TextXAlignment = Enum.TextXAlignment.Left
label.Parent = MainFrame

local box = Instance.new("TextBox")
box.Size = UDim2.new(0,70,0,20)
box.Position = UDim2.new(1,-80,0,pos)
box.BackgroundColor3 = Color3.fromRGB(30,35,40)
box.Text = tostring(value)
box.TextColor3 = Color3.new(1,1,1)
box.TextSize = 14
box.Font = Enum.Font.GothamBold
box.ClearTextOnFocus = false
box.Parent = MainFrame

Instance.new("UICorner",box)

return box,label

end

local SpeedInput,SpeedLabel = createInputRow("Speed",SpeedCustomizer.SpeedValue,70)
local StealInput,StealLabel = createInputRow("Steal Spd",SpeedCustomizer.StealValue,100)
local JumpInput,JumpLabel = createInputRow("Jump",SpeedCustomizer.JumpValue,130)
local GravityInput,GravityLabel = createInputRow("Gravity",SpeedCustomizer.GravityValue,160)

---

-- COLLAPSE

local open = true

CollapseBtn.MouseButton1Click:Connect(function()

open = not open

SpeedInput.Visible = open
StealInput.Visible = open
JumpInput.Visible = open
GravityInput.Visible = open

SpeedLabel.Visible = open
StealLabel.Visible = open
JumpLabel.Visible = open
GravityLabel.Visible = open

if open then
MainFrame.Size = UDim2.new(0,200,0,180)
else
MainFrame.Size = UDim2.new(0,200,0,40)
end

end)

---

-- SAVE

SaveBtn.MouseButton1Click:Connect(function()

if not Saved then Saved = {} end

Saved.SpeedConfig = {
Speed = SpeedCustomizer.SpeedValue,
Steal = SpeedCustomizer.StealValue,
Jump = SpeedCustomizer.JumpValue,
Gravity = SpeedCustomizer.GravityValue
}

local pos = MainFrame.Position

Saved.SpeedPos = {
XS = pos.X.Scale,
XO = pos.X.Offset,
YS = pos.Y.Scale,
YO = pos.Y.Offset
}

if SaveConfig then
SaveConfig()
end

end)

---

-- INPUT UPDATE

SpeedInput.FocusLost:Connect(function()
local n = tonumber(SpeedInput.Text)
if n then SpeedCustomizer.SpeedValue = n end
end)

StealInput.FocusLost:Connect(function()
local n = tonumber(StealInput.Text)
if n then SpeedCustomizer.StealValue = n end
end)

JumpInput.FocusLost:Connect(function()
local n = tonumber(JumpInput.Text)
if n then SpeedCustomizer.JumpValue = n end
end)

GravityInput.FocusLost:Connect(function()
local n = tonumber(GravityInput.Text)
if n then
SpeedCustomizer.GravityValue = n
Workspace.Gravity = n
end
end)

---

-- TOGGLE BUTTON

ToggleBtn.MouseButton1Click:Connect(function()

SpeedCustomizer.Enabled = not SpeedCustomizer.Enabled

ToggleBtn.Text = SpeedCustomizer.Enabled and "ON" or "OFF"

ToggleBtn.BackgroundColor3 =
SpeedCustomizer.Enabled and Color3.fromRGB(0,120,215)
or Color3.fromRGB(150,40,40)

end)

return SpeedScreenGui

end

---

-- ENABLE

local function enableSpeedCustomizer()

if not SpeedCustomizer.SpeedUI then
SpeedCustomizer.SpeedUI = createSpeedUI()
end

SpeedCustomizer.Enabled = true

if lp.Character then
setupSpeedCharacter(lp.Character)
end

lp.CharacterAdded:Connect(setupSpeedCharacter)

SpeedCustomizer.HeartbeatConn = RunService.Heartbeat:Connect(function()

if not SpeedCustomizer.Enabled then return end
if not SpeedCustomizer.hrp then return end
if not SpeedCustomizer.hum then return end

local moveDir = SpeedCustomizer.hum.MoveDirection

if moveDir.Magnitude > 0 then

SpeedCustomizer.hrp.AssemblyLinearVelocity = Vector3.new(
moveDir.X * SpeedCustomizer.SpeedValue,
SpeedCustomizer.hrp.AssemblyLinearVelocity.Y,
moveDir.Z * SpeedCustomizer.SpeedValue
)

end

end)

end

---

-- DISABLE

local function disableSpeedCustomizer()

SpeedCustomizer.Enabled = false

if SpeedCustomizer.SpeedUI then
SpeedCustomizer.SpeedUI.Enabled = false
end

if SpeedCustomizer.HeartbeatConn then
SpeedCustomizer.HeartbeatConn:Disconnect()
SpeedCustomizer.HeartbeatConn = nil
end

end

---

-- HUB TOGGLE

AddToggle("Movement","Speed Customizer",false,function(v)

if v then
enableSpeedCustomizer()
else
disableSpeedCustomizer()
end

end)
-------------------------------------------------------------------------
-- INFINITE JUMP MODULE
-------------------------------------------------------------------------
local InfiniteJump = {
    Enabled = false,
    JUMP_POWER = 50,       -- Standard Roblox jump height
    COOLDOWN = 0.15,       -- Prevents "velocity stacking" which causes lag/kicks
    lastJump = 0,
    JumpConnection = nil
}

-- Function to handle the jump logic
local function handleJumpRequest()
    if not InfiniteJump.Enabled then return end

    local character = lp.Character
    local hrp = character and character:FindFirstChild("HumanoidRootPart")
    local humanoid = character and character:FindFirstChildOfClass("Humanoid")

    -- Check if character exists and is actually in the air
    if hrp and humanoid then
        if humanoid.FloorMaterial == Enum.Material.Air then
            local now = tick()
            if now - InfiniteJump.lastJump >= InfiniteJump.COOLDOWN then
                InfiniteJump.lastJump = now
                -- Set vertical velocity while maintaining horizontal momentum
                hrp.Velocity = Vector3.new(hrp.Velocity.X, InfiniteJump.JUMP_POWER, hrp.Velocity.Z)
            end
        end
    end
end

-- Enable Infinite Jump
local function enableInfJump()
    if InfiniteJump.Enabled then return end

    InfiniteJump.Enabled = true

    -- Connect to JumpRequest (fired when player presses Space/Jump Button)
    InfiniteJump.JumpConnection = UserInputService.JumpRequest:Connect(handleJumpRequest)
end

-- Disable Infinite Jump
local function disableInfJump()
    if not InfiniteJump.Enabled then return end

    InfiniteJump.Enabled = false

    -- Disconnect the jump connection
    if InfiniteJump.JumpConnection then
        InfiniteJump.JumpConnection:Disconnect()
        InfiniteJump.JumpConnection = nil
    end
end

-------------------------------------------------------------------------
-- UI TOGGLE CALLBACKS
-------------------------------------------------------------------------

-- COMBAT TAB
local batConn = nil
AddToggle("Combat", "Auto Bat", false, function(v)
    if v then batConn = RunService.Heartbeat:Connect(function()
        local c = lp.Character; local b = getWeapon()
        if b and c and c:FindFirstChild("Humanoid") then if b.Parent ~= c then c.Humanoid:EquipTool(b) end b:Activate() end
    end) else if batConn then batConn:Disconnect() batConn = nil end end
end)

local Cebo = { Conn = nil, Circle = nil, Align = nil, Attach = nil }
AddToggle("Combat", "Melee Aimbot", false, function(active)
    if active then
        local char = lp.Character or lp.CharacterAdded:Wait()
        local hrp = char:WaitForChild("HumanoidRootPart")
        Cebo.Attach = Instance.new("Attachment", hrp)
        Cebo.Align = Instance.new("AlignOrientation", hrp)
        Cebo.Align.Attachment0, Cebo.Align.Mode, Cebo.Align.RigidityEnabled = Cebo.Attach, Enum.OrientationAlignmentMode.OneAttachment, true
        Cebo.Circle = create("Part", {Shape = "Cylinder", Material = "Neon", Size = Vector3.new(0.05, 14.5, 14.5), Color = Color3.new(1,0,0), CanCollide = false, Massless = true, Parent = Workspace})
        create("Weld", {Part0 = hrp, Part1 = Cebo.Circle, C0 = CFrame.new(0, -1, 0) * CFrame.Angles(0, 0, math.rad(90)), Parent = Cebo.Circle})
        Cebo.Conn = RunService.RenderStepped:Connect(function()
            local target, dmin = nil, 7.25
            for _, p in ipairs(Players:GetPlayers()) do if p ~= lp and p.Character and p.Character:FindFirstChild("HumanoidRootPart") then local d = (p.Character.HumanoidRootPart.Position - hrp.Position).Magnitude if d <= dmin then target, dmin = p.Character.HumanoidRootPart, d end end end
            if target then char.Humanoid.AutoRotate, Cebo.Align.Enabled, Cebo.Align.CFrame = false, true, CFrame.lookAt(hrp.Position, Vector3.new(target.Position.X, hrp.Position.Y, target.Position.Z)) local t = char:FindFirstChild("Bat") or char:FindFirstChild("Medusa") if t then t:Activate() end
            else Cebo.Align.Enabled, char.Humanoid.AutoRotate = false, true end
        end)
    else if Cebo.Conn then Cebo.Conn:Disconnect() end if Cebo.Circle then Cebo.Circle:Destroy() end if Cebo.Align then Cebo.Align:Destroy() end if Cebo.Attach then Cebo.Attach:Destroy() end if lp.Character and lp.Character:FindFirstChild("Humanoid") then lp.Character.Humanoid.AutoRotate = true end end
end)

AddToggle("Combat", "Speed Customizer", false, function(v)
    if v then
        enableSpeedCustomizer()
    else
        disableSpeedCustomizer()
    end
end)

AddToggle("Combat", "Inf Jump", false, function(v)
    if v then
        enableInfJump()
    else
        disableInfJump()
    end
end)

-- PROTECT TAB
AddToggle("Protect", "Optimizer", false, function(v)
    if v then Workspace.Terrain.WaterWaveSize = 0; game:GetService("Lighting").GlobalShadows = false
    for _, obj in pairs(game:GetDescendants()) do if obj:IsA("BasePart") then obj.Material = Enum.Material.Plastic elseif obj:IsA("Decal") then obj.Transparency = 1 end end end
end)

AddToggle("Protect", "Anti-Ragdoll", false, function(v)
    AntiRagdoll.Enabled = v
    if v and lp.Character then
        setupAntiRagdoll(lp.Character)
    else
        cleanupRagdoll()
        disconnectRemote()
    end
end)

local AntiEffects = { Enabled = false, DisabledRemotes = {}, Watcher = nil, Keywords = {"effect", "vfx", "fx", "particle", "camera", "shake", "blur", "flash", "visual", "ui", "item"} }
AddToggle("Protect", "Anti Bee & Disco", false, function(v)
    AntiEffects.Enabled = v
    if v then AntiEffects.Watcher = ReplicatedStorage.DescendantAdded:Connect(function(r) if AntiEffects.Enabled and r:IsA("RemoteEvent") then for _, k in pairs(AntiEffects.Keywords) do if r.Name:lower():find(k) then for _, c in pairs(getconnections(r.OnClientEvent)) do if c.Disable then c:Disable() end end break end end end end)
    else if AntiEffects.Watcher then AntiEffects.Watcher:Disconnect() end end
end)

AddToggle("Protect", "Anti Turret", false, function(v)
    AntiTurret.Enabled = v
    if v then AntiTurret.Conn = RunService.Heartbeat:Connect(function()
        if not AntiTurret.Enabled then return end
        if AntiTurret.Target and AntiTurret.Target.Parent == Workspace then
            local char = lp.Character; local root = char and char:FindFirstChild("HumanoidRootPart")
            if root then for _, p in pairs(AntiTurret.Target:GetDescendants()) do if p:IsA("BasePart") then p.CanCollide = false end end
            local main = AntiTurret.Target:IsA("Model") and (AntiTurret.Target.PrimaryPart or AntiTurret.Target:FindFirstChildWhichIsA("BasePart")) or AntiTurret.Target
            if main then main.CFrame = root.CFrame * CFrame.new(0, 0, AntiTurret.Pull) end
            local w = getWeapon(); if w then if w.Parent == lp.Backpack then char.Humanoid:EquipTool(w) end w:Activate() for _, r in pairs(w:GetDescendants()) do if r:IsA("RemoteEvent") then r:FireServer() end end end end
        else AntiTurret.Target = findTurret() end
    end) else if AntiTurret.Conn then AntiTurret.Conn:Disconnect() AntiTurret.Conn = nil end AntiTurret.Target = nil end
end)

-- VISUAL TAB
local RunService = game:GetService("RunService")
local Stats = game:GetService("Stats")

local PerformanceGui
local PerfConnection

-- mesma cor do botão da interface
local HUB_BLUE = Color3.fromRGB(85,170,255)

AddToggle("Visual", "Xray Base", false, function(v)
    if v then
        enableXrayBase()
    else
        disableXrayBase()
    end
end)

AddToggle("Visual", "No Anim", false, function(v)
    if v then
        enableNoAnim()
    else
        disableNoAnim()
    end
end)

AddToggle("Visual", "Player ESP", false, function(v)
    if v then
        enableESP()
    else
        disableESP()
    end
end)

AddToggle("Visual", "Show Performance", false, function(v)

    if v then

        if not PerformanceGui then

            PerformanceGui = Instance.new("ScreenGui")
            PerformanceGui.Name = "KawatanPerformance"
            PerformanceGui.ResetOnSpawn = false
            PerformanceGui.Parent = game.CoreGui

            local Frame = Instance.new("Frame")
            Frame.Size = UDim2.new(0,260,0,28) -- menor
            Frame.Position = UDim2.new(0.5,-130,0.015,0)
            Frame.BackgroundColor3 = Color3.fromRGB(0,0,0)
            Frame.BackgroundTransparency = 0.45
            Frame.BorderSizePixel = 0
            Frame.Parent = PerformanceGui

            local Corner = Instance.new("UICorner")
            Corner.CornerRadius = UDim.new(0,10)
            Corner.Parent = Frame

            local Label = Instance.new("TextLabel")
            Label.Size = UDim2.new(1,0,1,0)
            Label.BackgroundTransparency = 1
            Label.Font = Enum.Font.GothamBold
            Label.TextSize = 14
            Label.RichText = true
            Label.TextColor3 = HUB_BLUE
            Label.Text = "<font color='rgb(85,170,255)'>Kawatan Hub | FPS 0 PING 0ms</font>"
            Label.Parent = Frame

            local frames = 0
            local last = tick()

            PerfConnection = RunService.RenderStepped:Connect(function()

                frames += 1

                if tick() - last >= 1 then

                    local fps = frames
                    frames = 0
                    last = tick()

                    local ping = math.floor(
                        Stats.Network.ServerStatsItem["Data Ping"]:GetValue()
                    )

                    Label.Text = "<font color='rgb(85,170,255)'>Kawatan Hub | FPS "..fps.." PING "..ping.."ms</font>"

                end

            end)

        else
            PerformanceGui.Enabled = true
        end

    else

        if PerformanceGui then
            PerformanceGui.Enabled = false
        end

        if PerfConnection then
            PerfConnection:Disconnect()
            PerfConnection = nil
        end

    end

end)

-- STATIC BUTTONS
AddToggle("Combat", "", false, function(v) end)

AddToggle("Combat", "Lock Target", false, function(v)
    if v then
        enableSafeFollow()
    else
        disableSafeFollow()
    end
end)

AddToggle("Combat", "Auto Medusa", false, function(v) end)

---------------------------------------------------------------------
-- AUTO GRAB
---------------------------------------------------------------------

local AutoGrab = {
    Enabled = false,
    Radius = 13,
    Delay = 0.3,
    Conn = nil,
    LastGrab = 0
}

local function getNearestGrabPrompt()
    local char = lp.Character
    if not char then return end
    local hrp = char:FindFirstChild("HumanoidRootPart")
    if not hrp then return end
    local plots = workspace:FindFirstChild("Plots")
    if not plots then return end

    for _,plot in pairs(plots:GetChildren()) do
        local podiums = plot:FindFirstChild("AnimalPodiums")
        if podiums then
            for _,pod in pairs(podiums:GetChildren()) do
                local base = pod:FindFirstChild("Base")
                local spawn = base and base:FindFirstChild("Spawn")
                if spawn then
                    local dist = (spawn.Position - hrp.Position).Magnitude
                    if dist <= AutoGrab.Radius then
                        local att = spawn:FindFirstChild("PromptAttachment")
                        if att then
                            for _,obj in pairs(att:GetChildren()) do
                                if obj:IsA("ProximityPrompt") then
                                    return obj
                                end
                            end
                        end
                    end
                end
            end
        end
    end
end

local function startAutoGrab()
    if AutoGrab.Conn then
        AutoGrab.Conn:Disconnect()
    end

    AutoGrab.Conn = RunService.Heartbeat:Connect(function()
        if not AutoGrab.Enabled then return end

        if os.clock() - AutoGrab.LastGrab < AutoGrab.Delay then
            return
        end

        local prompt = getNearestGrabPrompt()
        if prompt then
            fireproximityprompt(prompt)
            AutoGrab.LastGrab = os.clock()
        end
    end)

    task.delay(1,function()
        if active then
            callback(true)
        end
    end)
end

local function stopAutoGrab()
    if AutoGrab.Conn then
        AutoGrab.Conn:Disconnect()
        AutoGrab.Conn = nil
    end
end

AddToggle("Combat", "Auto Grab", false, function(v)
    AutoGrab.Enabled = v
    if v then
        startAutoGrab()
    else
        stopAutoGrab()
    end
end)

-------------------------------------------------------------------------
-- SETUP & DRAG
-------------------------------------------------------------------------
local function drag(f)
    local d, ds, sp

    f.InputBegan:Connect(function(i)
        if i.UserInputType == Enum.UserInputType.MouseButton1 or i.UserInputType == Enum.UserInputType.Touch then
            d, ds, sp = true, i.Position, f.Position
        end
    end)

    UserInputService.InputChanged:Connect(function(i)
        if d and (i.UserInputType == Enum.UserInputType.MouseMovement or i.UserInputType == Enum.UserInputType.Touch) then
            local delta = i.Position - ds
            f.Position = UDim2.new(
                sp.X.Scale,
                sp.X.Offset + delta.X,
                sp.Y.Scale,
                sp.Y.Offset + delta.Y
            )
        end
    end)

    f.InputEnded:Connect(function(i)
        if i.UserInputType == Enum.UserInputType.MouseButton1 or i.UserInputType == Enum.UserInputType.Touch then
            d = false
        end
    end)

    task.delay(1,function()
        if active then
            callback(true)
        end
    end)
end

task.wait()

if MainFrame then drag(MainFrame) end

if ToggleIcon then
    drag(ToggleIcon)

    ToggleIcon.MouseButton1Click:Connect(function()
        if MainFrame then
            MainFrame.Visible = not MainFrame.Visible
        end
    end)

    task.delay(1,function()
        if active then
            callback(true)
        end
    end)
end
-------------------------------------------------------------------------
-- LOCK BUTTON
-------------------------------------------------------------------------
local SafeFollow = {
    Enabled = false,
    Locked = false,
    FOLLOW_DISTANCE = 6,
    lastMove = 0,
    gui = nil,
    btn = nil
}

local function createSafeFollowUI()
    SafeFollow.gui = Instance.new("ScreenGui")
    SafeFollow.gui.Name = "SafeFollowUI"
    SafeFollow.gui.ResetOnSpawn = false
    SafeFollow.gui.Enabled = false
    SafeFollow.gui.Parent = CoreGui

    SafeFollow.btn = Instance.new("TextButton")
    SafeFollow.btn.Size = UDim2.new(0,120,0,40) -- MESMO TAMANHO
    SafeFollow.btn.Position = UDim2.new(0.5,-60,0.8,0)
    SafeFollow.btn.Text = "LOCK"
    SafeFollow.btn.Font = Enum.Font.GothamBold
    SafeFollow.btn.TextSize = 14
    SafeFollow.btn.TextColor3 = Color3.new(1,1,1)
    SafeFollow.btn.BackgroundColor3 = Color3.fromRGB(43,160,235) -- AZUL
    SafeFollow.btn.Parent = SafeFollow.gui

    local uiCorner = Instance.new("UICorner")
    uiCorner.CornerRadius = UDim.new(0,8)
    uiCorner.Parent = SafeFollow.btn

    drag(SafeFollow.btn)

    SafeFollow.btn.MouseButton1Click:Connect(function()
        SafeFollow.Locked = not SafeFollow.Locked
        SafeFollow.btn.BackgroundColor3 =
            SafeFollow.Locked
            and Color3.fromRGB(255,65,65)
            or Color3.fromRGB(43,160,235)
    end)

    task.delay(1,function()
        if active then
            callback(true)
        end
    end)
end

createSafeFollowUI()

-- TP BUTTON

local TpEnabled = false
local chosenRoute = nil

local detectA = Vector3.new(-466.51,-7.81,113.79)
local detectB = Vector3.new(-466.43,-7.89,6.55)

local routeA = {
    Vector3.new(-432.87,-7.98,54.04),
    Vector3.new(-461.95,-7.98,97.28),
    Vector3.new(-483.72,-6.08,94.77)
}

local routeB = {
    Vector3.new(-447.12,-7.98,61.52),
    Vector3.new(-463.56,-7.98,25.78),
    Vector3.new(-486.73,-5.51,23.99)
}

local TpButton = Instance.new("TextButton")
TpButton.Size = UDim2.new(0,120,0,40)

local savedPos = Saved.TpPos

if savedPos then
    TpButton.Position = UDim2.new(savedPos.XS,savedPos.XO,savedPos.YS,savedPos.YO)
else
    TpButton.Position = UDim2.new(0.05,0,0.7,0)
end

TpButton.BackgroundColor3 = Color3.fromRGB(43,160,235)
TpButton.Text = "TP"
TpButton.TextColor3 = Color3.new(1,1,1)
TpButton.Font = Enum.Font.GothamBold
TpButton.TextSize = 14
TpButton.Visible = false
TpButton.Parent = ScreenGui
Instance.new("UICorner",TpButton)

-- seta ^
local toggleBtn = Instance.new("TextButton")
toggleBtn.Size = UDim2.new(0,18,0,18)
toggleBtn.Position = UDim2.new(1,-20,0,2)
toggleBtn.Text = "^"
toggleBtn.Font = Enum.Font.GothamBold
toggleBtn.TextSize = 14
toggleBtn.TextColor3 = Color3.new(1,1,1)
toggleBtn.BackgroundTransparency = 1
toggleBtn.Parent = TpButton

-- botão Save
local saveBtn = Instance.new("TextButton")
saveBtn.Size = UDim2.new(0,120,0,25)
saveBtn.Position = UDim2.new(0,0,1,4)
saveBtn.Text = "Save"
saveBtn.Visible = false
saveBtn.Font = Enum.Font.Gotham
saveBtn.TextSize = 13
saveBtn.TextColor3 = Color3.new(1,1,1)
saveBtn.BackgroundColor3 = Color3.fromRGB(50,50,50)
saveBtn.Parent = TpButton
Instance.new("UICorner",saveBtn)

toggleBtn.MouseButton1Click:Connect(function()
    saveBtn.Visible = not saveBtn.Visible
end)

saveBtn.MouseButton1Click:Connect(function()

    local pos = TpButton.Position

    Saved.TpPos = {
        XS = pos.X.Scale,
        XO = pos.X.Offset,
        YS = pos.Y.Scale,
        YO = pos.Y.Offset
    }

    SaveConfig()

end)

drag(TpButton)

AddToggle("Combat","TP Ragdoll",false,function(v)
    TpEnabled = v
    TpButton.Visible = v
end)

-- DETECÇÃO AUTOMÁTICA DA ROTA (igual ao script antiloser)

task.spawn(function()
    while not chosenRoute do
        task.wait(.1)

        local char = lp.Character
        if char and char:FindFirstChild("HumanoidRootPart") then

            local pos = char.HumanoidRootPart.Position

            if (pos - detectA).Magnitude < 5 then
                chosenRoute = routeB

            elseif (pos - detectB).Magnitude < 5 then
                chosenRoute = routeA
            end

        end
    end
end)

-- TP FIXED

TpButton.MouseButton1Click:Connect(function()

    local char = lp.Character
    if not char then return end

    local root = char:FindFirstChild("HumanoidRootPart")
    if not root then return end

    if not chosenRoute then
        repeat task.wait() until chosenRoute
    end

    for _,p in ipairs(chosenRoute) do
        root.CFrame = CFrame.new(p)
        task.wait(.2)
    end

end)
-- DROP BUTTON

local DropEnabled = false

local DropButton = Instance.new("TextButton")
DropButton.Size = UDim2.new(0,120,0,40)

local savedPos = Saved.DropPos

if savedPos then
DropButton.Position = UDim2.new(savedPos.XS,savedPos.XO,savedPos.YS,savedPos.YO)
else
DropButton.Position = UDim2.new(0.05,0,0.78,0)
end

DropButton.BackgroundColor3 = Color3.fromRGB(43,160,235)
DropButton.Text = "DROP"
DropButton.TextColor3 = Color3.new(1,1,1)
DropButton.Font = Enum.Font.GothamBold
DropButton.TextSize = 14
DropButton.Visible = false
DropButton.Parent = ScreenGui
Instance.new("UICorner",DropButton)

-- seta ^
local toggleBtn = Instance.new("TextButton")
toggleBtn.Size = UDim2.new(0,18,0,18)
toggleBtn.Position = UDim2.new(1,-20,0,2)
toggleBtn.Text = "^"
toggleBtn.Font = Enum.Font.GothamBold
toggleBtn.TextSize = 14
toggleBtn.TextColor3 = Color3.new(1,1,1)
toggleBtn.BackgroundTransparency = 1
toggleBtn.Parent = DropButton

-- botão Save
local saveBtn = Instance.new("TextButton")
saveBtn.Size = UDim2.new(0,120,0,25)
saveBtn.Position = UDim2.new(0,0,1,4)
saveBtn.Text = "Save"
saveBtn.Visible = false
saveBtn.Font = Enum.Font.Gotham
saveBtn.TextSize = 13
saveBtn.TextColor3 = Color3.new(1,1,1)
saveBtn.BackgroundColor3 = Color3.fromRGB(50,50,50)
saveBtn.Parent = DropButton

Instance.new("UICorner",saveBtn)

toggleBtn.MouseButton1Click:Connect(function()
saveBtn.Visible = not saveBtn.Visible
end)

saveBtn.MouseButton1Click:Connect(function()

local pos = DropButton.Position

Saved.DropPos = {
    XS = pos.X.Scale,
    XO = pos.X.Offset,
    YS = pos.Y.Scale,
    YO = pos.Y.Offset
}

SaveConfig()

end)

drag(DropButton)

AddToggle("Combat","Drop Toggle",false,function(v)
DropEnabled = v
DropButton.Visible = v
end)

DropButton.MouseButton1Click:Connect(function()

local char = lp.Character or lp.CharacterAdded:Wait()
local hrp = char:WaitForChild("HumanoidRootPart")
local startCF = hrp.CFrame

hrp.AssemblyLinearVelocity = Vector3.new(0,120,0)

task.wait(0.35)

hrp.AssemblyLinearVelocity = Vector3.zero
hrp.CFrame = startCF

end)

repeat task.wait() until game:IsLoaded()

local Players = game:GetService("Players")
local UIS = game:GetService("UserInputService")
local RunService = game:GetService("RunService")

local lp = Players.LocalPlayer

local autoPlay = false
local opened = false
local saveOpened = false

local SPEED_NO_STEAL = 56
local SPEED_STEAL = 29

if Saved and Saved.AutoPlayConfig then
SPEED_NO_STEAL = Saved.AutoPlayConfig.NoSteal or 56
SPEED_STEAL = Saved.AutoPlayConfig.Steal or 29
end

-- TRIGGERS
local AUTO1_TRIGGER = Vector3.new(-466.43,-7.89,6.55)
local AUTO2_TRIGGER = Vector3.new(-466.51,-7.81,113.79)

-- POSIÇÕES AUTO PLAY 1
local A1 = Vector3.new(-472.59,-7.30,94.43)
local A2 = Vector3.new(-484.55,-5.33,95.05)
local A3 = Vector3.new(-472.59,-7.30,94.43)
local A4 = Vector3.new(-471.25,-6.83,7.08)

-- POSIÇÕES AUTO PLAY 2
local B1 = Vector3.new(-474.02,-7.30,25.55)
local B2 = Vector3.new(-484.92,-5.13,24.53)
local B3 = Vector3.new(-474.02,-7.30,25.55)
local B4 = Vector3.new(-470.93,-6.83,113.38)

local mode = nil

local function hrp()
local c = lp.Character
return c and c:FindFirstChild("HumanoidRootPart")
end

local function go(pos,speed,cond)

local r = hrp()
if not r then return end

while cond() and (r.Position - pos).Magnitude > 1 do

    local dir = (pos - r.Position).Unit

    r.AssemblyLinearVelocity = Vector3.new(
        dir.X * speed,
        r.AssemblyLinearVelocity.Y,
        dir.Z * speed
    )

    task.wait()
end

end

RunService.Heartbeat:Connect(function()

if mode then return end

local r = hrp()
if not r then return end

if (r.Position - AUTO1_TRIGGER).Magnitude < 4 then
    mode = 1
end

if (r.Position - AUTO2_TRIGGER).Magnitude < 4 then
    mode = 2
end

end)

-- GUI
local gui = Instance.new("ScreenGui")
gui.Name = "AutoPlay_UI"
gui.ResetOnSpawn = false
gui.Parent = game:GetService("CoreGui")

local main = Instance.new("Frame")
main.Size = UDim2.new(0,210,0,60)

if Saved and Saved.AutoPlayPos then
main.Position = UDim2.new(
Saved.AutoPlayPos.XS,
Saved.AutoPlayPos.XO,
Saved.AutoPlayPos.YS,
Saved.AutoPlayPos.YO
)
else
main.Position = UDim2.new(0.4,0,0.4,0)
end

main.BackgroundColor3 = Color3.fromRGB(20,25,30)
main.BackgroundTransparency = 0.2
main.BorderSizePixel = 0
main.Active = true
main.Draggable = true
main.Parent = gui

Instance.new("UICorner",main)

local stroke = Instance.new("UIStroke")
stroke.Color = Color3.fromRGB(50,150,250)
stroke.Thickness = 2
stroke.Parent = main

-- HEADER
local header = Instance.new("Frame")
header.Size = UDim2.new(1,-20,0,25)
header.Position = UDim2.new(0,10,0,5)
header.BackgroundTransparency = 1
header.Parent = main

local arrowLeft = Instance.new("TextButton")
arrowLeft.Size = UDim2.new(0,20,0,20)
arrowLeft.Position = UDim2.new(0,0,0,0)
arrowLeft.Text = "^"
arrowLeft.BackgroundTransparency = 1
arrowLeft.TextColor3 = Color3.new(1,1,1)
arrowLeft.Font = Enum.Font.GothamBold
arrowLeft.TextSize = 14
arrowLeft.Parent = header

local title = Instance.new("TextLabel")
title.Size = UDim2.new(1,-40,1,0)
title.Position = UDim2.new(0,20,0,0)
title.BackgroundTransparency = 1
title.Text = "Auto Play"
title.TextColor3 = Color3.fromRGB(80,180,255)
title.TextSize = 14
title.TextXAlignment = Enum.TextXAlignment.Left
title.Font = Enum.Font.GothamBold
title.Parent = header

local arrowRight = Instance.new("TextButton")
arrowRight.Size = UDim2.new(0,20,0,20)
arrowRight.Position = UDim2.new(1,-20,0,0)
arrowRight.Text = "^"
arrowRight.BackgroundTransparency = 1
arrowRight.TextColor3 = Color3.new(1,1,1)
arrowRight.Font = Enum.Font.GothamBold
arrowRight.TextSize = 14
arrowRight.Parent = header

-- PLAY BUTTON
local button = Instance.new("TextButton")
button.Size = UDim2.new(1,-20,0,23)
button.Position = UDim2.new(0,10,0,32)
button.BackgroundColor3 = Color3.fromRGB(43,160,235)
button.TextColor3 = Color3.new(1,1,1)
button.Text = "PLAY"
button.Font = Enum.Font.GothamBold
button.TextSize = 14
button.Parent = main
Instance.new("UICorner",button)

-- SAVE BUTTON
local saveBtn = Instance.new("TextButton")
saveBtn.Size = UDim2.new(1,-20,0,25)
saveBtn.Position = UDim2.new(0,10,1,4)
saveBtn.Text = "Save"
saveBtn.Visible = false
saveBtn.BackgroundColor3 = Color3.fromRGB(50,50,50)
saveBtn.TextColor3 = Color3.new(1,1,1)
saveBtn.Font = Enum.Font.Gotham
saveBtn.TextSize = 13
saveBtn.Parent = main
Instance.new("UICorner",saveBtn)

-- CONFIG GUI
local speedGui = Instance.new("Frame")
speedGui.Size = UDim2.new(0,210,0,90)
speedGui.Position = main.Position + UDim2.new(0,0,0,65)
speedGui.BackgroundColor3 = Color3.fromRGB(20,25,30)
speedGui.BackgroundTransparency = 0.2
speedGui.Visible = false
speedGui.Parent = gui
Instance.new("UICorner",speedGui)

-- INPUTS
local function createRow(text,val,pos)

local label = Instance.new("TextLabel")
label.Size = UDim2.new(0.6,0,0,20)
label.Position = UDim2.new(0,10,0,pos)
label.BackgroundTransparency = 1
label.Text = text
label.TextColor3 = Color3.fromRGB(200,200,200)
label.Font = Enum.Font.Gotham
label.TextSize = 13
label.TextXAlignment = Enum.TextXAlignment.Left
label.Parent = speedGui

local box = Instance.new("TextBox")
box.Size = UDim2.new(0,60,0,20)
box.Position = UDim2.new(1,-70,0,pos)
box.BackgroundColor3 = Color3.fromRGB(30,35,40)
box.TextColor3 = Color3.new(1,1,1)
box.Text = tostring(val)
box.Font = Enum.Font.GothamBold
box.TextSize = 13
box.ClearTextOnFocus = false
box.Parent = speedGui
Instance.new("UICorner",box)

return box

end

local noStealBox = createRow("Speed No Steal",SPEED_NO_STEAL,10)
local stealBox = createRow("Speed Steal",SPEED_STEAL,40)

noStealBox.FocusLost:Connect(function()
local n = tonumber(noStealBox.Text)
if n then SPEED_NO_STEAL = n end
end)

stealBox.FocusLost:Connect(function()
local n = tonumber(stealBox.Text)
if n then SPEED_STEAL = n end
end)

-- ARROWS
arrowLeft.MouseButton1Click:Connect(function()
opened = not opened
speedGui.Visible = opened
end)

arrowRight.MouseButton1Click:Connect(function()
saveOpened = not saveOpened
saveBtn.Visible = saveOpened
end)

-- SAVE
saveBtn.MouseButton1Click:Connect(function()

if not Saved then Saved = {} end

Saved.AutoPlayConfig = {
NoSteal = SPEED_NO_STEAL,
Steal = SPEED_STEAL
}

local pos = main.Position

Saved.AutoPlayPos = {
XS = pos.X.Scale,
XO = pos.X.Offset,
YS = pos.Y.Scale,
YO = pos.Y.Offset
}

if SaveConfig then
SaveConfig()
end

end)

-- PLAY
button.MouseButton1Click:Connect(function()

autoPlay = not autoPlay

if autoPlay then

button.Text="STOP"
button.BackgroundColor3=Color3.fromRGB(255,120,120)

task.spawn(function()

if mode == 1 then

go(A1,SPEED_NO_STEAL,function()return autoPlay end)
go(A2,SPEED_NO_STEAL,function()return autoPlay end)
go(A3,SPEED_STEAL,function()return autoPlay end)
go(A4,SPEED_STEAL,function()return autoPlay end)

elseif mode == 2 then

go(B1,SPEED_NO_STEAL,function()return autoPlay end)
go(B2,SPEED_NO_STEAL,function()return autoPlay end)
go(B3,SPEED_STEAL,function()return autoPlay end)
go(B4,SPEED_STEAL,function()return autoPlay end)

end

autoPlay=false
button.Text="PLAY"
button.BackgroundColor3=Color3.fromRGB(43,160,235)

end)

else

button.Text="PLAY"
button.BackgroundColor3=Color3.fromRGB(43,160,235)

end

end)