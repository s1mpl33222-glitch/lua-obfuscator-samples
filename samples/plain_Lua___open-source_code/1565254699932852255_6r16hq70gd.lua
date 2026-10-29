-- MAX Click | Black & White Edition
-- Roblox / Delta

local Players = game:GetService("Players")
local UIS = game:GetService("UserInputService")

local Player = Players.LocalPlayer
local PlayerGui = Player:WaitForChild("PlayerGui")
local ENV = getgenv and getgenv() or _G

local NAME = "MAX Click"
local DISCORD = "https://discord.gg/9JQVgn7kx"

local BLACK = Color3.fromRGB(13, 13, 15)
local DARK = Color3.fromRGB(27, 27, 30)
local WHITE = Color3.fromRGB(255, 255, 255)
local GRAY = Color3.fromRGB(170, 170, 175)

-- Stop previous instance
if type(ENV.MAXClickCleanup) == "function" then
    pcall(ENV.MAXClickCleanup)
end

local Old = PlayerGui:FindFirstChild("MAX_Click_GUI")
if Old then Old:Destroy() end

local Running = true
local Clicking = false
local MultiMode = false
local ClickDelay = 0.5
local MaxCircles = 10

local Circles = {}
local Connections = {}

local Gui = Instance.new("ScreenGui")
Gui.Name = "MAX_Click_GUI"
Gui.ResetOnSpawn = false
Gui.IgnoreGuiInset = true
Gui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
Gui.Parent = PlayerGui

local function Corner(parent, radius)
    local c = Instance.new("UICorner")
    c.CornerRadius = UDim.new(0, radius)
    c.Parent = parent
    return c
end

local function Stroke(parent, thickness)
    local s = Instance.new("UIStroke")
    s.Color = WHITE
    s.Thickness = thickness
    s.Parent = parent
    return s
end

local Main = Instance.new("Frame")
Main.Size = UDim2.fromOffset(285, 305)
Main.Position = UDim2.new(0.5, -142, 0.25, 0)
Main.BackgroundColor3 = BLACK
Main.BorderSizePixel = 0
Main.Active = true
Main.Parent = Gui

Corner(Main, 15)
Stroke(Main, 1.5)

local Header = Instance.new("Frame")
Header.Size = UDim2.new(1, 0, 0, 45)
Header.BackgroundColor3 = DARK
Header.BorderSizePixel = 0
Header.Active = true
Header.Parent = Main

Corner(Header, 15)

local Title = Instance.new("TextLabel")
Title.Size = UDim2.new(1, -105, 1, 0)
Title.Position = UDim2.fromOffset(14, 0)
Title.BackgroundTransparency = 1
Title.Text = NAME
Title.TextColor3 = WHITE
Title.Font = Enum.Font.GothamBold
Title.TextSize = 19
Title.TextXAlignment = Enum.TextXAlignment.Left
Title.Parent = Header

-- Discord
local DiscordButton = Instance.new("ImageButton")
DiscordButton.Name = "Discord"
DiscordButton.Size = UDim2.fromOffset(31, 31)
DiscordButton.Position = UDim2.new(1, -78, 0, 7)
DiscordButton.BackgroundColor3 = BLACK
DiscordButton.Image = "rbxassetid://8482830248"
DiscordButton.ImageColor3 = WHITE
DiscordButton.Parent = Header
Corner(DiscordButton, 8)

DiscordButton.MouseButton1Click:Connect(function()
    if type(setclipboard) == "function" then
        pcall(function()
            setclipboard(DISCORD)
        end)
    end

    pcall(function()
        game:GetService("GuiService"):OpenBrowserWindow(DISCORD)
    end)
end)

local Close = Instance.new("TextButton")
Close.Size = UDim2.fromOffset(30, 30)
Close.Position = UDim2.new(1, -37, 0, 8)
Close.BackgroundColor3 = BLACK
Close.Text = "×"
Close.TextColor3 = WHITE
Close.Font = Enum.Font.GothamBold
Close.TextSize = 22
Close.Parent = Header
Corner(Close, 8)

-- Floating button
local Bubble = Instance.new("TextButton")
Bubble.Size = UDim2.fromOffset(60, 60)
Bubble.Position = UDim2.fromOffset(20, 180)
Bubble.BackgroundColor3 = BLACK
Bubble.BackgroundTransparency = 0.15
Bubble.Text = "MAX"
Bubble.TextColor3 = WHITE
Bubble.Font = Enum.Font.GothamBlack
Bubble.TextSize = 14
Bubble.Visible = false
Bubble.Active = true
Bubble.Parent = Gui

Corner(Bubble, 30)
Stroke(Bubble, 3)

-- Dragging
local function MakeDraggable(handle, target)
    local dragging = false
    local startInput
    local startPosition
    local moved = false

    local began = handle.InputBegan:Connect(function(input)
        if input.UserInputType ~= Enum.UserInputType.Touch
            and input.UserInputType ~= Enum.UserInputType.MouseButton1 then
            return
        end

        dragging = true
        moved = false
        startInput = input.Position
        startPosition = target.Position

        local ended
        ended = input.Changed:Connect(function()
            if input.UserInputState == Enum.UserInputState.End then
                dragging = false
                ended:Disconnect()
            end
        end)
    end)

    local changed = UIS.InputChanged:Connect(function(input)
        if not dragging then return end

        if input.UserInputType ~= Enum.UserInputType.Touch
            and input.UserInputType ~= Enum.UserInputType.MouseMovement then
            return
        end

        local delta = input.Position - startInput

        if delta.Magnitude > 7 then
            moved = true
        end

        target.Position = UDim2.new(
            startPosition.X.Scale,
            startPosition.X.Offset + delta.X,
            startPosition.Y.Scale,
            startPosition.Y.Offset + delta.Y
        )
    end)

    table.insert(Connections, began)
    table.insert(Connections, changed)

    return function()
        return moved
    end
end

MakeDraggable(Header, Main)
local BubbleMoved = MakeDraggable(Bubble, Bubble)

Close.MouseButton1Click:Connect(function()
    Main.Visible = false
    Bubble.Visible = true
end)

Bubble.MouseButton1Click:Connect(function()
    if not BubbleMoved() then
        Main.Visible = true
        Bubble.Visible = false
    end
end)

local function Button(text, position, size)
    local b = Instance.new("TextButton")
    b.Size = size or UDim2.new(1, -24, 0, 36)
    b.Position = position
    b.BackgroundColor3 = DARK
    b.Text = text
    b.TextColor3 = WHITE
    b.Font = Enum.Font.GothamBold
    b.TextSize = 13
    b.Parent = Main

    Corner(b, 9)
    Stroke(b, 1)

    return b
end

local ModeButton = Button(
    "هدف واحد",
    UDim2.fromOffset(12, 56)
)

local AddButton = Button(
    "+ إضافة دائرة",
    UDim2.fromOffset(12, 102),
    UDim2.fromOffset(125, 37)
)

local RemoveButton = Button(
    "- حذف دائرة",
    UDim2.fromOffset(148, 102),
    UDim2.fromOffset(125, 37)
)

local DelayLabel = Instance.new("TextLabel")
DelayLabel.Size = UDim2.new(1, -24, 0, 24)
DelayLabel.Position = UDim2.fromOffset(12, 150)
DelayLabel.BackgroundTransparency = 1
DelayLabel.Text = "الفاصل بين النقرات: 0.1 - 10 ثوانٍ"
DelayLabel.TextColor3 = GRAY
DelayLabel.Font = Enum.Font.Gotham
DelayLabel.TextSize = 12
DelayLabel.Parent = Main

local DelayBox = Instance.new("TextBox")
DelayBox.Size = UDim2.new(1, -24, 0, 38)
DelayBox.Position = UDim2.fromOffset(12, 180)
DelayBox.BackgroundColor3 = DARK
DelayBox.Text = "0.5"
DelayBox.TextColor3 = WHITE
DelayBox.PlaceholderText = "الثواني"
DelayBox.Font = Enum.Font.GothamBold
DelayBox.TextSize = 16
DelayBox.ClearTextOnFocus = false
DelayBox.Parent = Main

Corner(DelayBox, 9)
Stroke(DelayBox, 1)

DelayBox.FocusLost:Connect(function()
    local value = tonumber(DelayBox.Text)

    if value then
        ClickDelay = math.clamp(value, 0.1, 10)
    end

    DelayBox.Text = tostring(ClickDelay)
end)

local StartButton = Button(
    "▶ تشغيل النقر",
    UDim2.fromOffset(12, 231),
    UDim2.new(1, -24, 0, 42)
)

local Status = Instance.new("TextLabel")
Status.Size = UDim2.new(1, -24, 0, 18)
Status.Position = UDim2.fromOffset(12, 279)
Status.BackgroundTransparency = 1
Status.Text = "الحالة: متوقف"
Status.TextColor3 = GRAY
Status.Font = Enum.Font.Gotham
Status.TextSize = 11
Status.Parent = Main

local function UpdateStatus()
    StartButton.Text = Clicking
        and "■ إيقاف النقر"
        or "▶ تشغيل النقر"

    Status.Text = Clicking
        and "الحالة: يعمل"
        or "الحالة: متوقف"
end

StartButton.MouseButton1Click:Connect(function()
    Clicking = not Clicking
    UpdateStatus()
end)

local function ScreenSize()
    local camera = workspace.CurrentCamera
    return camera and camera.ViewportSize or Vector2.new(720, 1280)
end

local function SafePosition(index)
    local screen = ScreenSize()
    local size = 85

    if index == 1 then
        return UDim2.fromOffset(
            math.max(0, (screen.X - size) / 2),
            math.max(0, (screen.Y - size) / 2)
        )
    end

    local columns = math.max(1, math.floor(screen.X / 95))
    local col = (index - 1) % columns
    local row = math.floor((index - 1) / columns)

    local x = math.clamp(
        10 + col * 95,
        0,
        math.max(0, screen.X - size)
    )

    local y = math.clamp(
        screen.Y * 0.55 + row * 95,
        0,
        math.max(0, screen.Y - size)
    )

    return UDim2.fromOffset(x, y)
end

local function CreateCircle()
    if #Circles >= MaxCircles then return end

    local number = #Circles + 1

    local circle = Instance.new("TextButton")
    circle.Name = "Target_" .. number
    circle.Size = UDim2.fromOffset(85, 85)
    circle.Position = SafePosition(number)
    circle.BackgroundColor3 = WHITE
    circle.BackgroundTransparency = 0.85
    circle.Text = tostring(number)
    circle.TextColor3 = WHITE
    circle.Font = Enum.Font.GothamBlack
    circle.TextSize = 42
    circle.Visible = MultiMode or number == 1
    circle.Active = true
    circle.Parent = Gui

    Corner(circle, 43)
    Stroke(circle, 5)

    MakeDraggable(circle, circle)

    table.insert(Circles, circle)
end

CreateCircle()

ModeButton.MouseButton1Click:Connect(function()
    MultiMode = not MultiMode

    ModeButton.Text = MultiMode
        and "أهداف متعددة"
        or "هدف واحد"

    for i, circle in ipairs(Circles) do
        circle.Visible = MultiMode or i == 1
    end
end)

AddButton.MouseButton1Click:Connect(CreateCircle)

RemoveButton.MouseButton1Click:Connect(function()
    if #Circles <= 1 then return end

    local circle = table.remove(Circles)
    circle:Destroy()
end)

-- Virtual input
local VirtualInputManager

pcall(function()
    VirtualInputManager = game:GetService("VirtualInputManager")
end)

local function PerformClick(x, y)
    if not VirtualInputManager then
        return false
    end

    return pcall(function()
        VirtualInputManager:SendMouseButtonEvent(
            x, y, 0, true, game, 0
        )

        task.wait(0.03)

        VirtualInputManager:SendMouseButtonEvent(
            x, y, 0, false, game, 0
        )
    end)
end

local function ClickTarget(circle)
    if not circle or not circle.Parent then
        return false
    end

    local pos = circle.AbsolutePosition
    local size = circle.AbsoluteSize

    return PerformClick(
        pos.X + size.X / 2,
        pos.Y + size.Y / 2
    )
end

task.spawn(function()
    while Running do
        if Clicking then
            local count = MultiMode and #Circles or 1

            for i = 1, count do
                if not Running or not Clicking then
                    break
                end

                local circle = Circles[i]

                if circle and not ClickTarget(circle) then
                    Clicking = false
                    UpdateStatus()
                    Status.Text = "النقر غير مدعوم في Delta"
                    break
                end
            end

            task.wait(ClickDelay)
        else
            task.wait(0.2)
        end
    end
end)

ENV.MAXClickCleanup = function()
    Running = false
    Clicking = false

    for _, connection in ipairs(Connections) do
        connection:Disconnect()
    end

    Gui:Destroy()
end

print("MAX Click loaded")