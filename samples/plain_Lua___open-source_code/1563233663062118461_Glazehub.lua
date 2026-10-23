local Players = game:GetService("Players")
local TeleportService = game:GetService("TeleportService")
local HttpService = game:GetService("HttpService")
local TweenService = game:GetService("TweenService")

local LocalPlayer = Players.LocalPlayer
local PlaceId = game.PlaceId

-- GUI Creation
local ScreenGui = Instance.new("ScreenGui")
ScreenGui.Name = "PrivateServerFinder"
ScreenGui.ResetOnSpawn = false

if syn and syn.protect_gui then
    syn.protect_gui(ScreenGui)
    ScreenGui.Parent = game.CoreGui
elseif gethui then
    ScreenGui.Parent = gethui()
else
    ScreenGui.Parent = game.CoreGui
end

-- Main Window (Dark Neon Glass Style)
local MainFrame = Instance.new("Frame")
MainFrame.Parent = ScreenGui
MainFrame.BackgroundColor3 = Color3.fromRGB(15, 12, 25)
MainFrame.BorderSizePixel = 0
MainFrame.Position = UDim2.new(0.5, -130, 0.5, -120)
MainFrame.Size = UDim2.new(0, 260, 0, 240)
MainFrame.Active = true
MainFrame.Draggable = true
MainFrame.ClipsDescendants = true
Instance.new("UICorner", MainFrame).CornerRadius = UDim.new(0, 12)

local UIStroke = Instance.new("UIStroke", MainFrame)
UIStroke.Color = Color3.fromRGB(60, 50, 90)
UIStroke.Thickness = 1.5

-- Header
local Title = Instance.new("TextLabel", MainFrame)
Title.Position = UDim2.new(0, 15, 0, 12)
Title.Size = UDim2.new(0, 180, 0, 18)
Title.BackgroundTransparency = 1
Title.Font = Enum.Font.FredokaOne
Title.Text = "PRIVATE SERVER FINDER"
Title.TextColor3 = Color3.fromRGB(0, 230, 255)
Title.TextSize = 13
Title.TextXAlignment = Enum.TextXAlignment.Left

local Subtitle = Instance.new("TextLabel", MainFrame)
Subtitle.Position = UDim2.new(0, 15, 0, 30)
Subtitle.Size = UDim2.new(0, 180, 0, 14)
Subtitle.BackgroundTransparency = 1
Subtitle.Font = Enum.Font.GothamMedium
Subtitle.Text = "by GlazeOnTop"
Subtitle.TextColor3 = Color3.fromRGB(120, 120, 150)
Subtitle.TextSize = 10
Subtitle.TextXAlignment = Enum.TextXAlignment.Left

-- Close Button
local CloseBtn = Instance.new("TextButton", MainFrame)
CloseBtn.BackgroundColor3 = Color3.fromRGB(35, 30, 50)
CloseBtn.Position = UDim2.new(1, -32, 0, 12)
CloseBtn.Size = UDim2.new(0, 20, 0, 20)
CloseBtn.Font = Enum.Font.GothamBold
CloseBtn.Text = "✕"
CloseBtn.TextColor3 = Color3.fromRGB(200, 200, 220)
CloseBtn.TextSize = 11
Instance.new("UICorner", CloseBtn).CornerRadius = UDim.new(0, 6)
CloseBtn.MouseButton1Click:Connect(function() ScreenGui:Destroy() end)

-- Status Card
local StatusCard = Instance.new("Frame", MainFrame)
StatusCard.Position = UDim2.new(0, 15, 0, 52)
StatusCard.Size = UDim2.new(1, -30, 0, 50)
StatusCard.BackgroundColor3 = Color3.fromRGB(24, 20, 40)
StatusCard.BorderSizePixel = 0
Instance.new("UICorner", StatusCard).CornerRadius = UDim.new(0, 8)

local NowLabel = Instance.new("TextLabel", StatusCard)
NowLabel.Position = UDim2.new(0, 10, 0, 6)
NowLabel.Size = UDim2.new(1, -20, 0, 18)
NowLabel.BackgroundTransparency = 1
NowLabel.Font = Enum.Font.GothamBold
NowLabel.TextXAlignment = Enum.TextXAlignment.Left
NowLabel.TextColor3 = Color3.fromRGB(0, 230, 255)
NowLabel.TextSize = 12

local StatusLabel = Instance.new("TextLabel", StatusCard)
StatusLabel.Position = UDim2.new(0, 10, 0, 24)
StatusLabel.Size = UDim2.new(1, -20, 0, 22)
StatusLabel.BackgroundTransparency = 1
StatusLabel.Font = Enum.Font.GothamMedium
StatusLabel.TextXAlignment = Enum.TextXAlignment.Left
StatusLabel.TextColor3 = Color3.fromRGB(160, 160, 180)
StatusLabel.TextSize = 10
StatusLabel.TextWrapped = true

-- Input Field
local MaxBox = Instance.new("TextBox", MainFrame)
MaxBox.Position = UDim2.new(0, 15, 0, 110)
MaxBox.Size = UDim2.new(1, -30, 0, 32)
MaxBox.BackgroundColor3 = Color3.fromRGB(24, 20, 40)
MaxBox.BorderSizePixel = 0
MaxBox.Font = Enum.Font.GothamBold
MaxBox.Text = "1"
MaxBox.PlaceholderText = "Max Players Allowed"
MaxBox.TextColor3 = Color3.fromRGB(255, 255, 255)
MaxBox.TextSize = 13
MaxBox.ClearTextOnFocus = false
Instance.new("UICorner", MaxBox).CornerRadius = UDim.new(0, 8)

-- Action Buttons (Stacked Layout)
local JoinBtn = Instance.new("TextButton", MainFrame)
JoinBtn.Position = UDim2.new(0, 15, 0, 150)
JoinBtn.Size = UDim2.new(1, -30, 0, 34)
JoinBtn.BackgroundColor3 = Color3.fromRGB(0, 140, 255)
JoinBtn.BorderSizePixel = 0
JoinBtn.Font = Enum.Font.GothamBold
JoinBtn.Text = "HOP SERVER NOW"
JoinBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
JoinBtn.TextSize = 11
Instance.new("UICorner", JoinBtn).CornerRadius = UDim.new(0, 8)

local AutoBtn = Instance.new("TextButton", MainFrame)
AutoBtn.Position = UDim2.new(0, 15, 0, 190)
AutoBtn.Size = UDim2.new(1, -30, 0, 34)
AutoBtn.BackgroundColor3 = Color3.fromRGB(35, 30, 50)
AutoBtn.BorderSizePixel = 0
AutoBtn.Font = Enum.Font.GothamBold
AutoBtn.Text = "AUTO HOP: DISABLED"
AutoBtn.TextColor3 = Color3.fromRGB(180, 180, 200)
AutoBtn.TextSize = 11
Instance.new("UICorner", AutoBtn).CornerRadius = UDim.new(0, 8)

-- Hover Animations helper
local function addHover(btn, normalColor, hoverColor)
    btn.MouseEnter:Connect(function()
        TweenService:Create(btn, TweenInfo.new(0.2), {BackgroundColor3 = hoverColor}):Play()
    end)
    btn.MouseLeave:Connect(function()
        TweenService:Create(btn, TweenInfo.new(0.2), {BackgroundColor3 = normalColor}):Play()
    end)
end

addHover(JoinBtn, Color3.fromRGB(0, 140, 255), Color3.fromRGB(30, 160, 255))
addHover(CloseBtn, Color3.fromRGB(35, 30, 50), Color3.fromRGB(220, 50, 70))

-- ==============================
-- LOGIC
-- ==============================
local autoEnabled = false
local autoThread = nil

task.spawn(function()
    while ScreenGui.Parent do
        local count = #Players:GetPlayers()
        NowLabel.Text = "Current Server: " .. count .. " player(s)"
        task.wait(1)
    end
end)

local function getRandomServer()
    local url = "https://games.roblox.com/v1/games/" .. PlaceId .. "/servers/Public?sortOrder=Asc&limit=100"
    local ok, raw = pcall(function() return game:HttpGet(url) end)
    if not ok or not raw or raw == "" then return nil end

    local ok2, data = pcall(HttpService.JSONDecode, HttpService, raw)
    if not ok2 or not data or not data.data or #data.data == 0 then return nil end

    local currentId = tostring(game.JobId)
    local candidates = {}
    for _, s in ipairs(data.data) do
        if s.id and tostring(s.id) ~= currentId then
            table.insert(candidates, tostring(s.id))
        end
    end

    if #candidates == 0 then return nil end
    return candidates[math.random(1, #candidates)]
end

local function joinOnce()
    local threshold = math.max(1, math.floor(tonumber(MaxBox.Text) or 1))
    local currentCount = #Players:GetPlayers()

    if currentCount <= threshold then
        StatusLabel.Text = "Server matches target (" .. currentCount .. " <= " .. threshold .. ")"
        StatusLabel.TextColor3 = Color3.fromRGB(0, 230, 150)
        return false
    end

    StatusLabel.Text = "Searching for lower player server..."
    StatusLabel.TextColor3 = Color3.fromRGB(255, 180, 50)
    task.wait(0.5)

    local serverId = getRandomServer()
    if not serverId then
        StatusLabel.Text = "HTTP fetch failed. Check executor."
        StatusLabel.TextColor3 = Color3.fromRGB(255, 80, 80)
        return false
    end

    StatusLabel.Text = "Teleporting..."
    StatusLabel.TextColor3 = Color3.fromRGB(0, 230, 255)
    task.wait(0.5)

    local ok, err = pcall(function()
        TeleportService:TeleportToPlaceInstance(PlaceId, serverId, LocalPlayer)
    end)

    if not ok then
        StatusLabel.Text = "Teleport error!"
        StatusLabel.TextColor3 = Color3.fromRGB(255, 80, 80)
        return false
    end

    return true
end

JoinBtn.MouseButton1Click:Connect(function()
    JoinBtn.Active = false
    joinOnce()
    task.wait(2)
    JoinBtn.Active = true
end)

AutoBtn.MouseButton1Click:Connect(function()
    autoEnabled = not autoEnabled

    if autoEnabled then
        AutoBtn.Text = "AUTO HOP: ENABLED"
        AutoBtn.BackgroundColor3 = Color3.fromRGB(0, 180, 120)
        AutoBtn.TextColor3 = Color3.fromRGB(255, 255, 255)

        autoThread = task.spawn(function()
            while autoEnabled and ScreenGui.Parent do
                local threshold = math.max(1, math.floor(tonumber(MaxBox.Text) or 1))
                local count = #Players:GetPlayers()

                if count <= threshold then
                    StatusLabel.Text = "Optimal server. Waiting..."
                    StatusLabel.TextColor3 = Color3.fromRGB(0, 230, 150)
                    task.wait(3)
                else
                    joinOnce()
                    task.wait(5)
                end
            end
        end)
    else
        AutoBtn.Text = "AUTO HOP: DISABLED"
        AutoBtn.BackgroundColor3 = Color3.fromRGB(35, 30, 50)
        AutoBtn.TextColor3 = Color3.fromRGB(180, 180, 200)
        if autoThread then
            task.cancel(autoThread)
            autoThread = nil
        end
        StatusLabel.Text = "Auto hop stopped."
        StatusLabel.TextColor3 = Color3.fromRGB(160, 160, 180)
    end
end)

StatusLabel.Text = "Set max threshold & click Hop."
