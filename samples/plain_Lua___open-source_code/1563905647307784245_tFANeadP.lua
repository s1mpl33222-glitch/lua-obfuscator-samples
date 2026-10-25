-- Loading Screen Minimal | Pika Scripts
-- Бесконечная загрузка, останавливается на 98.7%

local Players = game:GetService("Players")
local TweenService = game:GetService("TweenService")
local LocalPlayer = Players.LocalPlayer

-- Удалить старый если есть
pcall(function()
    if game:GetService("CoreGui"):FindFirstChild("LoadingScreenMin") then
        game:GetService("CoreGui"):FindFirstChild("LoadingScreenMin"):Destroy()
    end
end)
if LocalPlayer.PlayerGui:FindFirstChild("LoadingScreenMin") then
    LocalPlayer.PlayerGui:FindFirstChild("LoadingScreenMin"):Destroy()
end

-- ========== SCREENGUI ==========
local ScreenGui = Instance.new("ScreenGui")
ScreenGui.Name = "LoadingScreenMin"
ScreenGui.ResetOnSpawn = false
ScreenGui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
ScreenGui.IgnoreGuiInset = true
ScreenGui.DisplayOrder = 999999

if syn and syn.protect_gui then
    syn.protect_gui(ScreenGui)
    ScreenGui.Parent = game:GetService("CoreGui")
elseif gethui then
    ScreenGui.Parent = gethui()
elseif get_hidden_gui then
    ScreenGui.Parent = get_hidden_gui()
else
    ScreenGui.Parent = game:GetService("CoreGui")
end

-- ========== ФОН ==========
local Background = Instance.new("Frame")
Background.Size = UDim2.new(1, 0, 1, 0)
Background.BackgroundColor3 = Color3.fromRGB(8, 8, 8)
Background.BorderSizePixel = 0
Background.ZIndex = 1
Background.Parent = ScreenGui

-- Блокировщик кликов
local Blocker = Instance.new("TextButton")
Blocker.Size = UDim2.new(1, 0, 1, 0)
Blocker.BackgroundTransparency = 1
Blocker.Text = ""
Blocker.ZIndex = 0
Blocker.Parent = ScreenGui

-- Тонкая сетка (имитация через несколько линий)
for i = 1, 20 do
    local hLine = Instance.new("Frame")
    hLine.Size = UDim2.new(1, 0, 0, 1)
    hLine.Position = UDim2.new(0, 0, i / 20, 0)
    hLine.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
    hLine.BackgroundTransparency = 0.97
    hLine.BorderSizePixel = 0
    hLine.ZIndex = 1
    hLine.Parent = Background

    local vLine = Instance.new("Frame")
    vLine.Size = UDim2.new(0, 1, 1, 0)
    vLine.Position = UDim2.new(i / 20, 0, 0, 0)
    vLine.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
    vLine.BackgroundTransparency = 0.97
    vLine.BorderSizePixel = 0
    vLine.ZIndex = 1
    vLine.Parent = Background
end

-- ========== WRAPPER (центр) ==========
local Wrapper = Instance.new("Frame")
Wrapper.Size = UDim2.new(0, 480, 0, 500)
Wrapper.Position = UDim2.new(0.5, -240, 0.5, -250)
Wrapper.BackgroundTransparency = 1
Wrapper.ZIndex = 2
Wrapper.Parent = Background

-- ========== АВАТАР ==========
local RingOuter = Instance.new("Frame")
RingOuter.Size = UDim2.new(0, 84, 0, 84)
RingOuter.Position = UDim2.new(0.5, -42, 0, 0)
RingOuter.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
RingOuter.BackgroundTransparency = 0.85
RingOuter.BorderSizePixel = 0
RingOuter.ZIndex = 3
RingOuter.Parent = Wrapper
Instance.new("UICorner", RingOuter).CornerRadius = UDim.new(1, 0)

local RingInner = Instance.new("Frame")
RingInner.Size = UDim2.new(0, 76, 0, 76)
RingInner.Position = UDim2.new(0.5, -38, 0, 4)
RingInner.BackgroundColor3 = Color3.fromRGB(8, 8, 8)
RingInner.BorderSizePixel = 0
RingInner.ZIndex = 4
RingInner.Parent = Wrapper
Instance.new("UICorner", RingInner).CornerRadius = UDim.new(1, 0)

local Avatar = Instance.new("ImageLabel")
Avatar.Size = UDim2.new(0, 72, 0, 72)
Avatar.Position = UDim2.new(0.5, -36, 0, 6)
Avatar.BackgroundTransparency = 1
Avatar.ZIndex = 5
Avatar.Parent = Wrapper
Instance.new("UICorner", Avatar).CornerRadius = UDim.new(1, 0)
Avatar.Image = string.format("https://www.roblox.com/headshot-thumbnail/image?userId=%d&width=150&height=150&format=png", LocalPlayer.UserId)

-- Пульсация кольца
task.spawn(function()
    while ScreenGui.Parent do
        TweenService:Create(RingOuter, TweenInfo.new(1.5, Enum.EasingStyle.Sine), {
            BackgroundTransparency = 0.6
        }):Play()
        task.wait(1.5)
        TweenService:Create(RingOuter, TweenInfo.new(1.5, Enum.EasingStyle.Sine), {
            BackgroundTransparency = 0.88
        }):Play()
        task.wait(1.5)
    end
end)

-- ========== ЗАГОЛОВОК ==========
local Title = Instance.new("TextLabel")
Title.Size = UDim2.new(1, 0, 0, 34)
Title.Position = UDim2.new(0, 0, 0, 96)
Title.BackgroundTransparency = 1
Title.Text = "VINZ HUB"
Title.TextColor3 = Color3.fromRGB(255, 255, 255)
Title.TextSize = 24
Title.Font = Enum.Font.GothamBold
Title.ZIndex = 3
Title.Parent = Wrapper

local Subtitle = Instance.new("TextLabel")
Subtitle.Size = UDim2.new(1, 0, 0, 20)
Subtitle.Position = UDim2.new(0, 0, 0, 130)
Subtitle.BackgroundTransparency = 1
Subtitle.Text = "LOADING SCRIPT"
Subtitle.TextColor3 = Color3.fromRGB(255, 255, 255)
Subtitle.TextTransparency = 0.7
Subtitle.TextSize = 11
Subtitle.Font = Enum.Font.GothamBold
Subtitle.ZIndex = 3
Subtitle.Parent = Wrapper

-- ========== РАЗДЕЛИТЕЛЬ ==========
local DivTop = Instance.new("Frame")
DivTop.Size = UDim2.new(1, 0, 0, 1)
DivTop.Position = UDim2.new(0, 0, 0, 160)
DivTop.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
DivTop.BackgroundTransparency = 0.93
DivTop.BorderSizePixel = 0
DivTop.ZIndex = 3
DivTop.Parent = Wrapper

-- ========== ЛОГИ ==========
local LogFrame = Instance.new("Frame")
LogFrame.Size = UDim2.new(1, 0, 0, 170)
LogFrame.Position = UDim2.new(0, 0, 0, 166)
LogFrame.BackgroundTransparency = 1
LogFrame.ClipsDescendants = true
LogFrame.ZIndex = 3
LogFrame.Parent = Wrapper

local LogLayout = Instance.new("UIListLayout", LogFrame)
LogLayout.SortOrder = Enum.SortOrder.LayoutOrder
LogLayout.Padding = UDim.new(0, 5)
LogLayout.VerticalAlignment = Enum.VerticalAlignment.Bottom

local logLines = {}
local logIndex = 0

local logMessages = {
    {txt = "> [SUCCESS] Vinz Hub module loaded.",               color = Color3.fromRGB(200, 200, 200)},
    {txt = "> Bypassing server-side heartbeats...",         color = Color3.fromRGB(140, 140, 140)},
    {txt = "> Scanning game memory for integrity checks...", color = Color3.fromRGB(100, 100, 100)},
    {txt = "> Hooking LuaU virtual machine...",             color = Color3.fromRGB(100, 100, 100)},
    {txt = "> Spoofing client environment...",              color = Color3.fromRGB(100, 100, 100)},
    {txt = "> Memory patch applied at 0x7FF8A2",            color = Color3.fromRGB(100, 100, 100)},
    {txt = "> [SUCCESS] Bypass module downloaded.",          color = Color3.fromRGB(200, 200, 200)},
    {txt = "> Bypassing server-side heartbeats...",         color = Color3.fromRGB(140, 140, 140)},
    {txt = "> Scanning game memory for checks...",          color = Color3.fromRGB(100, 100, 100)},
    {txt = "> Memory patch applied at 0x7FF8A2",            color = Color3.fromRGB(100, 100, 100)},
    {txt = "> [SUCCESS] Auto module downloaded.",           color = Color3.fromRGB(200, 200, 200)},
    {txt = "> Bypassing server-side heartbeats...",         color = Color3.fromRGB(140, 140, 140)},
    {txt = "> Hooking LuaU virtual machine...",             color = Color3.fromRGB(100, 100, 100)},
}

local function addLog(msg, color)
    logIndex += 1
    local line = Instance.new("TextLabel")
    line.Size = UDim2.new(1, 0, 0, 16)
    line.BackgroundTransparency = 1
    line.Text = msg
    line.TextColor3 = color
    line.TextSize = 11
    line.Font = Enum.Font.Code
    line.TextXAlignment = Enum.TextXAlignment.Left
    line.LayoutOrder = logIndex
    line.ZIndex = 4
    line.Parent = LogFrame
    table.insert(logLines, line)
    if #logLines > 9 then
        table.remove(logLines, 1):Destroy()
    end
end

-- ========== РАЗДЕЛИТЕЛЬ НИЖНИЙ ==========
local DivBottom = Instance.new("Frame")
DivBottom.Size = UDim2.new(1, 0, 0, 1)
DivBottom.Position = UDim2.new(0, 0, 0, 344)
DivBottom.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
DivBottom.BackgroundTransparency = 0.93
DivBottom.BorderSizePixel = 0
DivBottom.ZIndex = 3
DivBottom.Parent = Wrapper

-- ========== ПРОГРЕСС ==========
local ProgressRow = Instance.new("Frame")
ProgressRow.Size = UDim2.new(1, -60, 0, 8)
ProgressRow.Position = UDim2.new(0, 0, 0, 360)
ProgressRow.BackgroundTransparency = 1
ProgressRow.ZIndex = 3
ProgressRow.Parent = Wrapper

local ProgressTrack = Instance.new("Frame")
ProgressTrack.Size = UDim2.new(1, -60, 0, 2)
ProgressTrack.Position = UDim2.new(0, 0, 0, 363)
ProgressTrack.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
ProgressTrack.BackgroundTransparency = 0.9
ProgressTrack.BorderSizePixel = 0
ProgressTrack.ZIndex = 3
ProgressTrack.Parent = Wrapper
Instance.new("UICorner", ProgressTrack).CornerRadius = UDim.new(1, 0)

local ProgressFill = Instance.new("Frame")
ProgressFill.Size = UDim2.new(0, 0, 1, 0)
ProgressFill.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
ProgressFill.BorderSizePixel = 0
ProgressFill.ZIndex = 4
ProgressFill.Parent = ProgressTrack
Instance.new("UICorner", ProgressFill).CornerRadius = UDim.new(1, 0)

local ProgressPct = Instance.new("TextLabel")
ProgressPct.Size = UDim2.new(0, 55, 0, 20)
ProgressPct.Position = UDim2.new(1, -55, 0, 356)
ProgressPct.BackgroundTransparency = 1
ProgressPct.Text = "0.0%"
ProgressPct.TextColor3 = Color3.fromRGB(255, 255, 255)
ProgressPct.TextTransparency = 0.5
ProgressPct.TextSize = 12
ProgressPct.Font = Enum.Font.Code
ProgressPct.TextXAlignment = Enum.TextXAlignment.Right
ProgressPct.ZIndex = 3
ProgressPct.Parent = Wrapper

local ProgressLabel = Instance.new("TextLabel")
ProgressLabel.Size = UDim2.new(1, 0, 0, 18)
ProgressLabel.Position = UDim2.new(0, 0, 0, 372)
ProgressLabel.BackgroundTransparency = 1
ProgressLabel.Text = "Initializing..."
ProgressLabel.TextColor3 = Color3.fromRGB(255, 255, 255)
ProgressLabel.TextTransparency = 0.75
ProgressLabel.TextSize = 11
ProgressLabel.Font = Enum.Font.Code
ProgressLabel.TextXAlignment = Enum.TextXAlignment.Left
ProgressLabel.ZIndex = 3
ProgressLabel.Parent = Wrapper

-- ========== FOOTER ==========
local Footer = Instance.new("TextLabel")
Footer.Size = UDim2.new(1, 0, 0, 36)
Footer.Position = UDim2.new(0, 0, 0, 454)
Footer.BackgroundTransparency = 1
Footer.Text = "SYSTEM: Do not disconnect. Premature exit may trigger anti-cheat flag.\nSynchronizing modules..."
Footer.TextColor3 = Color3.fromRGB(255, 255, 255)
Footer.TextTransparency = 0.82
Footer.TextSize = 10
Footer.Font = Enum.Font.Code
Footer.ZIndex = 3
Footer.Parent = Wrapper

-- ========== ПОЯВЛЕНИЕ ==========
Background.BackgroundTransparency = 1
TweenService:Create(Background, TweenInfo.new(0.4), {BackgroundTransparency = 0}):Play()

-- ========== ЛОГИ LOOP ==========
task.spawn(function()
    for _, log in ipairs(logMessages) do
        task.wait(math.random(3, 8) * 0.1)
        addLog(log.txt, log.color)
    end
    while ScreenGui.Parent do
        for _, log in ipairs(logMessages) do
            task.wait(math.random(3, 8) * 0.1)
            addLog(log.txt, log.color)
        end
    end
end)

-- ========== ПРОГРЕСС ==========
local stepLabels = {
    "Initializing...", "Connecting to server...", "Loading assets...",
    "Preparing modules...", "Patching memory...", "Verifying integrity...",
    "Applying patches...", "Synchronizing...", "Finalizing...",
    "Applying patches...", "Waiting for response..."
}

local steps = {
    {target = 8,    speed = 0.8,  label = stepLabels[1]},
    {target = 18,   speed = 1.0,  label = stepLabels[2]},
    {target = 29,   speed = 1.2,  label = stepLabels[3]},
    {target = 41,   speed = 1.4,  label = stepLabels[4]},
    {target = 55,   speed = 1.6,  label = stepLabels[5]},
    {target = 67,   speed = 1.4,  label = stepLabels[6]},
    {target = 76,   speed = 1.8,  label = stepLabels[7]},
    {target = 84,   speed = 2.0,  label = stepLabels[8]},
    {target = 91,   speed = 1.8,  label = stepLabels[9]},
    {target = 95,   speed = 2.2,  label = stepLabels[10]},
    {target = 98.7, speed = 2.8,  label = stepLabels[11]},
}

local progress = 0

for _, step in ipairs(steps) do
    ProgressLabel.Text = step.label
    while progress < step.target do
        progress = math.min(progress + 0.25, step.target)
        TweenService:Create(ProgressFill, TweenInfo.new(0.1), {
            Size = UDim2.new(progress / 100, 0, 1, 0)
        }):Play()
        ProgressPct.Text = string.format("%.1f%%", progress)
        task.wait(step.speed * 0.12)
    end
    task.wait(step.speed * 0.5)
end

-- Застрять навсегда на 98.7%
ProgressPct.Text = "98.7%"
ProgressLabel.Text = "Waiting for response..."
print("[Pika Scripts] Stuck at 98.7%")