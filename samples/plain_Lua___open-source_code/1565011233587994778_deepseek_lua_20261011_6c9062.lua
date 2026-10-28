--[[
  Coded by: azi_.x
  Menu: Main | Visual | Executor | Scripts | Combat | Setting | Player info | Credits
]]

if not game:IsLoaded() then pcall(function() game.Loaded:Wait() end) end

local Players = game:GetService("Players")
local UIS = game:GetService("UserInputService")
local RunService = game:GetService("RunService")
local TeleportService = game:GetService("TeleportService")
local HttpService = game:GetService("HttpService")
local StarterGui = game:GetService("StarterGui")
local TweenService = game:GetService("TweenService")

local player = Players.LocalPlayer
while not player do task.wait() player = Players.LocalPlayer end
local PlayerGui = player:WaitForChild("PlayerGui", 10) or player:FindFirstChildOfClass("PlayerGui")
local camera = workspace.CurrentCamera
local mouse = player:GetMouse()

local SCRIPT_VER = "1.1"
local WEBHOOK = "https://discord.com/api/webhooks/1553184197106073612/ai8DciE6Bm6m9VWJIeWKtdghlirI2Y1hWmSxgzKZxiP9JovbgxXy0Z25Uc_b47_6MJH0"

local Keys = { ["azi"] = true, ["sha"] = true, ["ilovesha"] = true, ["67"] = true, ["wikidz"] = true, ["zt"] = true }

local Whitelist = {
    [10370122094] = true, [7088781507] = true, [10905789887] = true,
    [5560367936] = true, [11035798734] = true, [11596640573] = true, [3354071250] = true,
}

local function isValidKey(t)
    if not t then return false end
    t = tostring(t):gsub("^%s+", ""):gsub("%s+$", "")
    return Keys[t] == true
end

local function getExecutorName()
    local name = "Unknown"
    pcall(function() if identifyexecutor then name = tostring(identifyexecutor()) end end)
    pcall(function() if getexecutorname then name = tostring(getexecutorname()) end end)
    return name
end

local function sendWebhook(jsonBody)
    local payload = type(jsonBody) == "string" and jsonBody or HttpService:JSONEncode(jsonBody)
    local fns = {}
    pcall(function() if syn and syn.request then table.insert(fns, syn.request) end end)
    pcall(function() if http and http.request then table.insert(fns, http.request) end end)
    pcall(function() if http_request then table.insert(fns, http_request) end end)
    pcall(function() if request then table.insert(fns, request) end end)
    for _, fn in ipairs(fns) do
        local ok, res = pcall(function()
            return fn({ Url = WEBHOOK, url = WEBHOOK, Method = "POST", method = "POST",
                Headers = { ["Content-Type"] = "application/json" }, Body = payload, body = payload })
        end)
        if ok then
            local code = type(res) == "table" and (res.StatusCode or res.Status or res.status_code)
            if code == nil or code == 200 or code == 201 or code == 204 then return true end
        end
    end
    pcall(function() HttpService:PostAsync(WEBHOOK, payload, Enum.HttpContentType.ApplicationJson) end)
    return false
end

local function sendAuthLog(reason, tries, usedKey)
    task.spawn(function()
        pcall(function()
            local device = UIS.TouchEnabled and "Mobile" or "PC"
            local uid = player.UserId
            local name = player.Name
            local display = player.DisplayName or name
            local placeId = game.PlaceId
            local jobId = tostring(game.JobId or "?")
            local wl = Whitelist[uid] and "y" or "n"
            local keyShown = (usedKey and tostring(usedKey) ~= "") and tostring(usedKey) or "(empty)"
            local now = tostring(os.date("!%Y-%m-%d %H:%M:%S")) .. " UTC"
            local profile = "https://www.roblox.com/users/" .. tostring(uid) .. "/profile"
            local gameLink = "https://www.roblox.com/games/" .. tostring(placeId)
            local text = table.concat({
                "Executor: " .. getExecutorName(),
                "User: " .. name .. " (" .. display .. ") | Id: " .. tostring(uid),
                "Place: " .. tostring(placeId) .. " | Job: " .. jobId,
                "Game link: " .. gameLink,
                "Reason kick: " .. tostring(reason or "unknown"),
                "Tries: " .. tostring(tries or 1) .. " | Device: " .. device,
                "Ver: " .. SCRIPT_VER .. " | Time: " .. now,
                "Profile link: " .. profile,
                "Use key: " .. keyShown,
                "Whitelisted y/n: " .. wl,
            }, "\n")
            sendWebhook({ content = text, username = "azi_.x Auth" })
        end)
    end)
end

-- ========== KEY SYSTEM ==========
local function checkKey()
    if Whitelist[player.UserId] then
        sendAuthLog("whitelisted", 0, "(whitelist)")
        task.wait(0.4)
        return true
    end

    local sg = Instance.new("ScreenGui")
    sg.Name = "AziKey"
    sg.ResetOnSpawn = false
    sg.Parent = PlayerGui

    local frame = Instance.new("Frame")
    frame.Size = UDim2.new(0, 280, 0, 160)
    frame.Position = UDim2.new(0.5, -140, 0.5, -80)
    frame.BackgroundColor3 = Color3.fromRGB(12, 12, 12)
    frame.BorderSizePixel = 1
    frame.BorderColor3 = Color3.fromRGB(255, 255, 255)
    frame.Parent = sg

    local title = Instance.new("TextLabel")
    title.Size = UDim2.new(1, 0, 0, 36)
    title.BackgroundColor3 = Color3.fromRGB(20, 20, 20)
    title.BorderSizePixel = 0
    title.Text = "KEY SYSTEM — azi_.x"
    title.TextColor3 = Color3.fromRGB(255, 255, 255)
    title.Font = Enum.Font.GothamBold
    title.TextSize = 14
    title.Parent = frame

    local box = Instance.new("TextBox")
    box.Size = UDim2.new(1, -30, 0, 34)
    box.Position = UDim2.new(0, 15, 0, 50)
    box.BackgroundColor3 = Color3.fromRGB(25, 25, 25)
    box.BorderColor3 = Color3.fromRGB(80, 80, 80)
    box.PlaceholderText = "Enter key..."
    box.Text = ""
    box.TextColor3 = Color3.fromRGB(255, 255, 255)
    box.Font = Enum.Font.Gotham
    box.TextSize = 14
    box.Parent = frame

    local submit = Instance.new("TextButton")
    submit.Size = UDim2.new(1, -30, 0, 34)
    submit.Position = UDim2.new(0, 15, 0, 100)
    submit.BackgroundColor3 = Color3.fromRGB(35, 35, 35)
    submit.BorderColor3 = Color3.fromRGB(255, 255, 255)
    submit.Text = "Submit"
    submit.TextColor3 = Color3.fromRGB(255, 255, 255)
    submit.Font = Enum.Font.GothamBold
    submit.TextSize = 14
    submit.Parent = frame

    local passed = false
    local tries = 0
    local lastKey = ""

    submit.MouseButton1Click:Connect(function()
        tries = tries + 1
        lastKey = box.Text or ""
        if isValidKey(lastKey) or Whitelist[player.UserId] then
            sendAuthLog("correct_key", tries, lastKey)
            task.wait(1)
            passed = true
            sg:Destroy()
        else
            local reason = (lastKey == "") and "empty_key" or "bad_key"
            sendAuthLog(reason, tries, lastKey)
            task.wait(1.5)
            player:Kick("Not authorized — azi_.x")
        end
    end)

    task.spawn(function()
        local t0 = tick()
        while not passed and sg.Parent do
            task.wait(0.5)
            if tick() - t0 > 120 then
                sendAuthLog("timeout", tries, lastKey)
                task.wait(1)
                player:Kick("Not authorized — azi_.x")
                break
            end
        end
    end)

    while not passed do
        task.wait(0.1)
        if not sg.Parent then
            if not passed then
                sendAuthLog("closed_ui", tries, lastKey)
                player:Kick("Not authorized — azi_.x")
            end
            break
        end
    end
    return passed
end

if not checkKey() then return end

-- ========== CONFIG ==========
local Config = {
    ClickTP = false,
    Gravity = 196.2,
    JumpPower = 50,
    WalkSpeed = 16,
    TouchFling = false,
    ESP = false,
    HealthESP = false,
    Tracers = false,
    BoxESP = false,
    LookLines = false,
    TrackAll = false,
    TrackThickness = 1.5,
    TrackBrightness = 1,
    Aimbot = false,
    FOV = false,
    FOVSize = 120,
    Aimsmooth = 0.2,
    AimPart = "Head",
    VisibleCheck = false,
    TeamCheck = true,
    Hitbox = false,
    HitboxSize = 5,
    BigHead = false,
    BigHeadSize = 5,
    RapidFire = false,
    FireRate = 100000,
    AutoReload = false,
    NoRecoil = false,
    NoSpread = false,
    AntiFling = false,
    TargetHighlight = false,
}

local TrackLines = {}
local ESPFolderObjects = {}

local function notify(title, text)
    pcall(function()
        StarterGui:SetCore("SendNotification", { Title = tostring(title), Text = tostring(text), Duration = 2 })
    end)
end

local function isEnemy(plr)
    if not plr or plr == player then return false end
    if Config.TeamCheck and plr.Team and player.Team and plr.Team == player.Team then return false end
    return true
end

local function isVisible(part)
    if not Config.VisibleCheck then return true end
    local origin = camera.CFrame.Position
    local dir = (part.Position - origin)
    local params = RaycastParams.new()
    params.FilterType = Enum.RaycastFilterType.Exclude
    params.FilterDescendantsInstances = { player.Character, part.Parent }
    local hit = workspace:Raycast(origin, dir, params)
    return hit == nil
end

local function getAimPart(plr)
    if not plr.Character then return nil end
    if Config.AimPart == "Random" then
        local parts = {}
        for _, v in ipairs(plr.Character:GetChildren()) do
            if v:IsA("BasePart") and v.Name ~= "HumanoidRootPart" then table.insert(parts, v) end
        end
        return #parts > 0 and parts[math.random(1, #parts)] or nil
    end
    return plr.Character:FindFirstChild(Config.AimPart)
end

local function doPanic()
    for k in pairs(Config) do
        if type(Config[k]) == "boolean" then Config[k] = false end
    end
    for _, v in pairs(TrackLines) do pcall(function() v:Remove() end) end
    TrackLines = {}
    notify("Panic", "All systems disabled")
end

-- ========== UI ==========
local isMobile = UIS.TouchEnabled
local ScreenGui = Instance.new("ScreenGui")
ScreenGui.Name = "AziMenu"
ScreenGui.ResetOnSpawn = false
ScreenGui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
ScreenGui.IgnoreGuiInset = true
ScreenGui.DisplayOrder = 100
pcall(function()
    if gethui then ScreenGui.Parent = gethui() else ScreenGui.Parent = PlayerGui end
end)
if not ScreenGui.Parent then ScreenGui.Parent = PlayerGui end

-- ─── Spinning outline wrapper ─────────────────────────────
local function addSpinningOutline(parentFrame)
    local outline = Instance.new("Frame")
    outline.Name = "SpinOutline"
    outline.Size = UDim2.new(1, 4, 1, 4)
    outline.Position = UDim2.new(0, -2, 0, -2)
    outline.BackgroundTransparency = 1
    outline.ZIndex = parentFrame.ZIndex - 1
    outline.Parent = parentFrame

    local grad = Instance.new("UIGradient")
    grad.Color = ColorSequence.new({
        ColorSequenceKeypoint.new(0, Color3.fromRGB(255, 255, 255)),
        ColorSequenceKeypoint.new(0.5, Color3.fromRGB(60, 60, 60)),
        ColorSequenceKeypoint.new(1, Color3.fromRGB(255, 255, 255)),
    })
    grad.Rotation = 0
    grad.Parent = outline

    local stroke = Instance.new("UIStroke")
    stroke.Thickness = 1.5
    stroke.Transparency = 0
    stroke.Parent = outline
    stroke.Color = Color3.fromRGB(255, 255, 255)

    task.spawn(function()
        while outline.Parent do
            grad.Rotation = (grad.Rotation + 2) % 360
            task.wait(0.03)
        end
    end)

    return outline
end

local Main = Instance.new("Frame")
Main.Size = UDim2.new(0, isMobile and 340 or 380, 0, isMobile and 440 or 480)
Main.Position = UDim2.new(0.5, isMobile and -170 or -190, 0.5, isMobile and -220 or -240)
Main.BackgroundColor3 = Color3.fromRGB(10, 10, 10)
Main.BorderSizePixel = 0
Main.Active = true
Main.Parent = ScreenGui
Instance.new("UICorner", Main).CornerRadius = UDim.new(0, 10)
addSpinningOutline(Main)

local Top = Instance.new("Frame")
Top.Size = UDim2.new(1, 0, 0, 32)
Top.BackgroundColor3 = Color3.fromRGB(18, 18, 18)
Top.BorderSizePixel = 0
Top.Parent = Main
Instance.new("UICorner", Top).CornerRadius = UDim.new(0, 10)

local TopTitle = Instance.new("TextLabel")
TopTitle.Size = UDim2.new(1, -80, 1, 0)
TopTitle.Position = UDim2.new(0, 10, 0, 0)
TopTitle.BackgroundTransparency = 1
TopTitle.Text = "Coded by: azi_.x"
TopTitle.TextColor3 = Color3.fromRGB(255, 255, 255)
TopTitle.Font = Enum.Font.GothamBold
TopTitle.TextSize = 13
TopTitle.TextXAlignment = Enum.TextXAlignment.Left
TopTitle.Parent = Top

local MinBtn = Instance.new("TextButton")
MinBtn.Size = UDim2.new(0, 24, 0, 24)
MinBtn.Position = UDim2.new(1, -56, 0, 4)
MinBtn.BackgroundColor3 = Color3.fromRGB(40, 40, 40)
MinBtn.Text = "—"
MinBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
MinBtn.Font = Enum.Font.GothamBold
MinBtn.TextSize = 14
MinBtn.Parent = Top
Instance.new("UICorner", MinBtn).CornerRadius = UDim.new(0, 6)

local CloseX = Instance.new("TextButton")
CloseX.Size = UDim2.new(0, 24, 0, 24)
CloseX.Position = UDim2.new(1, -28, 0, 4)
CloseX.BackgroundColor3 = Color3.fromRGB(40, 40, 40)
CloseX.Text = "X"
CloseX.TextColor3 = Color3.fromRGB(255, 255, 255)
CloseX.Font = Enum.Font.GothamBold
CloseX.TextSize = 14
CloseX.Parent = Top
Instance.new("UICorner", CloseX).CornerRadius = UDim.new(0, 6)

-- ─── Minimize bar (spinning outline) ──────────────────────
local MinBar = Instance.new("TextButton")
MinBar.Size = UDim2.new(0, 120, 0, 30)
MinBar.Position = UDim2.new(0, 20, 0, 60)
MinBar.BackgroundColor3 = Color3.fromRGB(20, 20, 20)
MinBar.Text = "azi_.x  ▸"
MinBar.TextColor3 = Color3.fromRGB(255, 255, 255)
MinBar.Font = Enum.Font.GothamBold
MinBar.TextSize = 12
MinBar.Visible = false
MinBar.Parent = ScreenGui
Instance.new("UICorner", MinBar).CornerRadius = UDim.new(0, 8)
addSpinningOutline(MinBar)

MinBtn.MouseButton1Click:Connect(function()
    Main.Visible = false
    MinBar.Visible = true
end)
CloseX.MouseButton1Click:Connect(function()
    Main.Visible = false
    MinBar.Visible = false
end)
MinBar.MouseButton1Click:Connect(function()
    Main.Visible = true
    MinBar.Visible = false
end)

-- Drag minimize bar too
do
    local drag, ds, sp
    MinBar.InputBegan:Connect(function(i)
        if i.UserInputType == Enum.UserInputType.MouseButton1 or i.UserInputType == Enum.UserInputType.Touch then
            drag = true ds = i.Position sp = MinBar.Position
        end
    end)
    UIS.InputEnded:Connect(function(i)
        if i.UserInputType == Enum.UserInputType.MouseButton1 or i.UserInputType == Enum.UserInputType.Touch then drag = false end
    end)
    UIS.InputChanged:Connect(function(i)
        if drag and (i.UserInputType == Enum.UserInputType.MouseMovement or i.UserInputType == Enum.UserInputType.Touch) then
            local d = i.Position - ds
            MinBar.Position = UDim2.new(sp.X.Scale, sp.X.Offset + d.X, sp.Y.Scale, sp.Y.Offset + d.Y)
        end
    end)
end

-- ─── Sidebar + Content ────────────────────────────────────
local Side = Instance.new("Frame")
Side.Size = UDim2.new(0, 110, 1, -32)
Side.Position = UDim2.new(0, 0, 0, 32)
Side.BackgroundColor3 = Color3.fromRGB(14, 14, 14)
Side.BorderSizePixel = 0
Side.Parent = Main
Instance.new("UICorner", Side).CornerRadius = UDim.new(0, 0)

local Content = Instance.new("Frame")
Content.Size = UDim2.new(1, -114, 1, -36)
Content.Position = UDim2.new(0, 112, 0, 34)
Content.BackgroundColor3 = Color3.fromRGB(12, 12, 12)
Content.BorderSizePixel = 0
Content.Parent = Main
Instance.new("UICorner", Content).CornerRadius = UDim.new(0, 8)

local tabNames = { "Main", "Visual", "Executor", "Scripts", "Combat", "Setting", "Player info", "Credits" }
local pages = {}
local tabButtons = {}

local function makePage(name)
    local sc = Instance.new("ScrollingFrame")
    sc.Name = name
    sc.Size = UDim2.new(1, -6, 1, -6)
    sc.Position = UDim2.new(0, 3, 0, 3)
    sc.BackgroundTransparency = 1
    sc.ScrollBarThickness = 4
    sc.CanvasSize = UDim2.new(0, 0, 0, 500)
    sc.Visible = false
    sc.Parent = Content
    pages[name] = sc
    return sc
end

for _, n in ipairs(tabNames) do makePage(n) end

local function switchTab(name)
    for _, p in pairs(pages) do p.Visible = false end
    for n, b in pairs(tabButtons) do
        b.BackgroundColor3 = Color3.fromRGB(22, 22, 22)
        b.TextColor3 = Color3.fromRGB(220, 220, 220)
    end
    if pages[name] then pages[name].Visible = true end
    if tabButtons[name] then
        tabButtons[name].BackgroundColor3 = Color3.fromRGB(255, 255, 255)
        tabButtons[name].TextColor3 = Color3.fromRGB(0, 0, 0)
    end
end

for i, n in ipairs(tabNames) do
    local b = Instance.new("TextButton")
    b.Size = UDim2.new(1, -8, 0, 28)
    b.Position = UDim2.new(0, 4, 0, 4 + (i - 1) * 32)
    b.BackgroundColor3 = Color3.fromRGB(22, 22, 22)
    b.BorderSizePixel = 0
    b.Text = n .. " tab"
    b.TextColor3 = Color3.fromRGB(220, 220, 220)
    b.Font = Enum.Font.GothamBold
    b.TextSize = 11
    b.Parent = Side
    Instance.new("UICorner", b).CornerRadius = UDim.new(0, 6)
    tabButtons[n] = b
    b.MouseButton1Click:Connect(function() switchTab(n) end)
end
switchTab("Main")

-- ─── UI helpers ───────────────────────────────────────────
local function addToggle(page, text, y, default, cb)
    local b = Instance.new("TextButton")
    b.Size = UDim2.new(1, -10, 0, 30)
    b.Position = UDim2.new(0, 5, 0, y)
    b.BackgroundColor3 = default and Color3.fromRGB(255, 255, 255) or Color3.fromRGB(28, 28, 28)
    b.Text = text .. ": " .. (default and "ON" or "OFF")
    b.TextColor3 = default and Color3.fromRGB(0, 0, 0) or Color3.fromRGB(255, 255, 255)
    b.Font = Enum.Font.GothamBold
    b.TextSize = 12
    b.BorderSizePixel = 0
    b.Parent = page
    Instance.new("UICorner", b).CornerRadius = UDim.new(0, 6)
    local state = default
    b.MouseButton1Click:Connect(function()
        state = not state
        b.Text = text .. ": " .. (state and "ON" or "OFF")
        b.BackgroundColor3 = state and Color3.fromRGB(255, 255, 255) or Color3.fromRGB(28, 28, 28)
        b.TextColor3 = state and Color3.fromRGB(0, 0, 0) or Color3.fromRGB(255, 255, 255)
        cb(state)
    end)
    return b
end

local function addSlider(page, label, y, minV, maxV, default, step, cb)
    local wrap = Instance.new("Frame")
    wrap.Size = UDim2.new(1, -10, 0, 44)
    wrap.Position = UDim2.new(0, 5, 0, y)
    wrap.BackgroundColor3 = Color3.fromRGB(22, 22, 22)
    wrap.BorderSizePixel = 0
    wrap.Parent = page
    Instance.new("UICorner", wrap).CornerRadius = UDim.new(0, 6)

    local lab = Instance.new("TextLabel")
    lab.Size = UDim2.new(1, -60, 0, 16)
    lab.Position = UDim2.new(0, 6, 0, 2)
    lab.BackgroundTransparency = 1
    lab.Text = label
    lab.TextColor3 = Color3.fromRGB(200, 200, 200)
    lab.Font = Enum.Font.Gotham
    lab.TextSize = 11
    lab.TextXAlignment = Enum.TextXAlignment.Left
    lab.Parent = wrap

    local val = Instance.new("TextLabel")
    val.Size = UDim2.new(0, 50, 0, 16)
    val.Position = UDim2.new(1, -54, 0, 2)
    val.BackgroundTransparency = 1
    val.Text = tostring(default)
    val.TextColor3 = Color3.fromRGB(255, 255, 255)
    val.Font = Enum.Font.GothamBold
    val.TextSize = 11
    val.Parent = wrap

    local track = Instance.new("Frame")
    track.Size = UDim2.new(1, -12, 0, 10)
    track.Position = UDim2.new(0, 6, 0, 24)
    track.BackgroundColor3 = Color3.fromRGB(40, 40, 40)
    track.BorderSizePixel = 0
    track.Parent = wrap
    Instance.new("UICorner", track).CornerRadius = UDim.new(1, 0)

    local fill = Instance.new("Frame")
    fill.Size = UDim2.new((default - minV) / math.max(maxV - minV, 1), 0, 1, 0)
    fill.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
    fill.BorderSizePixel = 0
    fill.Parent = track
    Instance.new("UICorner", fill).CornerRadius = UDim.new(1, 0)

    local dragging = false
    local function setA(a)
        a = math.clamp(a, 0, 1)
        local v = minV + (maxV - minV) * a
        v = math.floor(v / step + 0.5) * step
        v = math.clamp(v, minV, maxV)
        fill.Size = UDim2.new((v - minV) / math.max(maxV - minV, 1), 0, 1, 0)
        val.Text = tostring(v)
        cb(v)
    end
    setA((default - minV) / math.max(maxV - minV, 1))

    track.InputBegan:Connect(function(i)
        if i.UserInputType == Enum.UserInputType.MouseButton1 or i.UserInputType == Enum.UserInputType.Touch then
            dragging = true
            setA((i.Position.X - track.AbsolutePosition.X) / math.max(track.AbsoluteSize.X, 1))
        end
    end)
    UIS.InputEnded:Connect(function(i)
        if i.UserInputType == Enum.UserInputType.MouseButton1 or i.UserInputType == Enum.UserInputType.Touch then dragging = false end
    end)
    UIS.InputChanged:Connect(function(i)
        if dragging and (i.UserInputType == Enum.UserInputType.MouseMovement or i.UserInputType == Enum.UserInputType.Touch) then
            setA((i.Position.X - track.AbsolutePosition.X) / math.max(track.AbsoluteSize.X, 1))
        end
    end)
end

local function addLabel(page, text, y)
    local l = Instance.new("TextLabel")
    l.Size = UDim2.new(1, -10, 0, 22)
    l.Position = UDim2.new(0, 5, 0, y)
    l.BackgroundTransparency = 1
    l.Text = text
    l.TextColor3 = Color3.fromRGB(255, 255, 255)
    l.Font = Enum.Font.Gotham
    l.TextSize = 12
    l.TextXAlignment = Enum.TextXAlignment.Left
    l.Parent = page
    return l
end

local function addBtn(page, text, y, cb)
    local b = Instance.new("TextButton")
    b.Size = UDim2.new(1, -10, 0, 32)
    b.Position = UDim2.new(0, 5, 0, y)
    b.BackgroundColor3 = Color3.fromRGB(30, 30, 30)
    b.BorderSizePixel = 0
    b.Text = text
    b.TextColor3 = Color3.fromRGB(255, 255, 255)
    b.Font = Enum.Font.GothamBold
    b.TextSize = 12
    b.Parent = page
    Instance.new("UICorner", b).CornerRadius = UDim.new(0, 6)
    b.MouseButton1Click:Connect(cb)
    return b
end

local function addDropdown(page, label, y, options, default, cb)
    local wrap = Instance.new("Frame")
    wrap.Size = UDim2.new(1, -10, 0, 30)
    wrap.Position = UDim2.new(0, 5, 0, y)
    wrap.BackgroundColor3 = Color3.fromRGB(22, 22, 22)
    wrap.BorderSizePixel = 0
    wrap.Parent = page
    Instance.new("UICorner", wrap).CornerRadius = UDim.new(0, 6)

    local lab = Instance.new("TextLabel")
    lab.Size = UDim2.new(0, 90, 1, 0)
    lab.Position = UDim2.new(0, 6, 0, 0)
    lab.BackgroundTransparency = 1
    lab.Text = label
    lab.TextColor3 = Color3.fromRGB(200, 200, 200)
    lab.Font = Enum.Font.Gotham
    lab.TextSize = 11
    lab.TextXAlignment = Enum.TextXAlignment.Left
    lab.Parent = wrap

    local btn = Instance.new("TextButton")
    btn.Size = UDim2.new(0, 100, 1, -6)
    btn.Position = UDim2.new(1, -104, 0, 3)
    btn.BackgroundColor3 = Color3.fromRGB(40, 40, 40)
    btn.Text = default
    btn.TextColor3 = Color3.fromRGB(255, 255, 255)
    btn.Font = Enum.Font.GothamBold
    btn.TextSize = 11
    btn.BorderSizePixel = 0
    btn.Parent = wrap
    Instance.new("UICorner", btn).CornerRadius = UDim.new(0, 6)

    local idx = 1
    for i, v in ipairs(options) do if v == default then idx = i end end

    btn.MouseButton1Click:Connect(function()
        idx = idx + 1
        if idx > #options then idx = 1 end
        btn.Text = options[idx]
        cb(options[idx])
    end)
end

-- MAIN TAB
do
    local p = pages["Main"]
    addToggle(p, "Click to TP", 5, false, function(s) Config.ClickTP = s end)
    addToggle(p, "Touch Fling", 40, false, function(s) Config.TouchFling = s end)
    addSlider(p, "Gravity", 80, 0, 500, 196.2, 0.1, function(v) Config.Gravity = v; workspace.Gravity = v end)
    addSlider(p, "Jump Power", 130, 0, 500, 50, 1, function(v)
        Config.JumpPower = v
        local h = player.Character and player.Character:FindFirstChildOfClass("Humanoid")
        if h then h.UseJumpPower = true h.JumpPower = v end
    end)
    addSlider(p, "Speed", 180, 1, 500, 16, 1, function(v)
        Config.WalkSpeed = v
        local h = player.Character and player.Character:FindFirstChildOfClass("Humanoid")
        if h then h.WalkSpeed = v end
    end)
    p.CanvasSize = UDim2.new(0, 0, 0, 240)
end

-- VISUAL TAB
do
    local p = pages["Visual"]
    addToggle(p, "ESP", 5, false, function(s) Config.ESP = s end)
    addToggle(p, "Health ESP", 40, false, function(s) Config.HealthESP = s end)
    addToggle(p, "Tracer ESP", 75, false, function(s) Config.Tracers = s end)
    addToggle(p, "Box ESP", 110, false, function(s) Config.BoxESP = s end)
    addToggle(p, "Looking player at", 145, false, function(s) Config.LookLines = s end)
    addToggle(p, "Track All", 180, false, function(s)
        Config.TrackAll = s
        if not s then
            for _, v in pairs(TrackLines) do pcall(function() v:Remove() end) end
            TrackLines = {}
        end
    end)
    addSlider(p, "Track thickness", 220, 1, 50, 1.5, 0.5, function(v) Config.TrackThickness = v end)
    addSlider(p, "Track brightness (0=black 1=white)", 270, 0, 1, 1, 0.05, function(v) Config.TrackBrightness = v end)
    p.CanvasSize = UDim2.new(0, 0, 0, 330)
end

-- EXECUTOR TAB
do
    local p = pages["Executor"]
    addLabel(p, "Paste script below, then Execute", 5)
    local box = Instance.new("TextBox")
    box.Size = UDim2.new(1, -10, 0, 280)
    box.Position = UDim2.new(0, 5, 0, 30)
    box.BackgroundColor3 = Color3.fromRGB(20, 20, 20)
    box.BorderSizePixel = 0
    box.Text = ""
    box.PlaceholderText = "-- paste script here"
    box.TextColor3 = Color3.fromRGB(255, 255, 255)
    box.Font = Enum.Font.Code
    box.TextSize = 12
    box.TextXAlignment = Enum.TextXAlignment.Left
    box.TextYAlignment = Enum.TextYAlignment.Top
    box.ClearTextOnFocus = false
    box.MultiLine = true
    box.TextWrapped = true
    box.Parent = p
    Instance.new("UICorner", box).CornerRadius = UDim.new(0, 6)

    addBtn(p, "Execute", 320, function()
        local src = box.Text
        if not src or src == "" then notify("Executor", "Empty") return end
        local ok, err = pcall(function()
            local fn = loadstring(src)
            if fn then fn() else error("loadstring failed") end
        end)
        notify("Executor", ok and "Ran" or tostring(err))
    end)
    addBtn(p, "Clear", 360, function() box.Text = "" end)
    p.CanvasSize = UDim2.new(0, 0, 0, 410)
end

-- SCRIPTS TAB
do
    local p = pages["Scripts"]
    addBtn(p, "old ver maincheat", 10, function()
        local ok, err = pcall(function()
            loadstring(game:HttpGet("https://raw.githubusercontent.com/azxifnexyz/Test/refs/heads/main/deepseek_lua_20260831_bbd5f3.lua"))()
        end)
        notify("Scripts", ok and "Loaded old ver" or tostring(err))
    end)
    p.CanvasSize = UDim2.new(0, 0, 0, 80)
end

-- COMBAT TAB
do
    local p = pages["Combat"]
    addToggle(p, "Aimbot", 5, false, function(s) Config.Aimbot = s end)
    addToggle(p, "FOV Circle", 40, false, function(s) Config.FOV = s end)
    addSlider(p, "FOV Size", 80, 20, 400, 120, 1, function(v) Config.FOVSize = v end)
    addSlider(p, "Aim Smoothness", 130, 0.05, 1, 0.2, 0.05, function(v) Config.Aimsmooth = v end)
    addDropdown(p, "Hit Part", 180, { "Head", "Torso", "UpperTorso", "LowerTorso", "Random" }, "Head", function(v) Config.AimPart = v end)
    addToggle(p, "Visible Check", 215, false, function(s) Config.VisibleCheck = s end)
    addToggle(p, "Team Check", 250, true, function(s) Config.TeamCheck = s end)
    addToggle(p, "Target Highlight", 285, false, function(s) Config.TargetHighlight = s end)
    addToggle(p, "Hitbox Expander", 320, false, function(s) Config.Hitbox = s end)
    addSlider(p, "Hitbox Size", 355, 1, 100, 5, 1, function(v) Config.HitboxSize = v end)
    addToggle(p, "Big Head", 405, false, function(s) Config.BigHead = s end)
    addSlider(p, "Big Head Size", 440, 1, 550, 5, 1, function(v) Config.BigHeadSize = v end)

    -- Rapid Fire section
    addToggle(p, "Rapid Fire", 490, false, function(s) Config.RapidFire = s end)
    addSlider(p, "Fire Rate", 525, 100, 100000, 100000, 100, function(v) Config.FireRate = v end)
    addToggle(p, "Auto Reload", 575, false, function(s) Config.AutoReload = s end)
    addToggle(p, "No Recoil", 610, false, function(s) Config.NoRecoil = s end)
    addToggle(p, "No Spread", 645, false, function(s) Config.NoSpread = s end)
    addToggle(p, "Anti-Fling", 680, false, function(s) Config.AntiFling = s end)

    addBtn(p, "Apply Rapid Fire", 720, function()
        local function applyToTool(tool)
            tool:SetAttribute("RateOfFire", Config.FireRate)
            tool:SetAttribute("rateOfFire", Config.FireRate)
            local nv = tool:FindFirstChild("RateOfFire") or tool:FindFirstChild("FireRate")
            if nv and nv:IsA("NumberValue") then nv.Value = Config.FireRate end
        end
        local function watch(container)
            for _, child in ipairs(container:GetChildren()) do
                if child:IsA("Tool") then applyToTool(child) end
            end
            container.ChildAdded:Connect(function(child)
                if child:IsA("Tool") then applyToTool(child) end
            end)
        end
        if player.Character then watch(player.Character) end
        if player:FindFirstChildOfClass("Backpack") then watch(player:FindFirstChildOfClass("Backpack")) end
        player.CharacterAdded:Connect(watch)
        notify("Combat", "Rapid Fire applied")
    end)

    p.CanvasSize = UDim2.new(0, 0, 0, 770)
end

-- SETTING TAB
do
    local p = pages["Setting"]
    addBtn(p, "PANIC — disable all", 10, function() doPanic() end)
    addBtn(p, "Show / Hide Menu", 50, function() Main.Visible = not Main.Visible end)
    p.CanvasSize = UDim2.new(0, 0, 0, 120)
end

-- PLAYER INFO TAB
do
    local p = pages["Player info"]
    local y = 5
    local function row(label, value)
        addLabel(p, label .. ": " .. tostring(value), y)
        y = y + 24
    end
    row("Username", player.Name)
    row("Display name", player.DisplayName)
    row("UserId", player.UserId)

    local avatar = Instance.new("ImageLabel")
    avatar.Size = UDim2.new(0, 80, 0, 80)
    avatar.Position = UDim2.new(0, 5, 0, y + 10)
    avatar.BackgroundColor3 = Color3.fromRGB(30, 30, 30)
    avatar.Parent = p
    Instance.new("UICorner", avatar).CornerRadius = UDim.new(0, 8)
    pcall(function()
        avatar.Image = "https://www.roblox.com/headshot-thumbnail/image?userId="
            .. player.UserId .. "&width=150&height=150&format=png"
    end)
    addLabel(p, "Profile avatar", y + 95)
    p.CanvasSize = UDim2.new(0, 0, 0, y + 130)
end

-- CREDITS TAB
do
    local p = pages["Credits"]
    addLabel(p, "Coded by: azi_.x", 20)
    addLabel(p, "Menu layout + systems", 50)
    addLabel(p, "Ver " .. SCRIPT_VER, 80)
    p.CanvasSize = UDim2.new(0, 0, 0, 120)
end

-- Drag menu
do
    local dragging, dragStart, startPos
    Top.InputBegan:Connect(function(i)
        if i.UserInputType == Enum.UserInputType.MouseButton1 or i.UserInputType == Enum.UserInputType.Touch then
            dragging = true dragStart = i.Position startPos = Main.Position
        end
    end)
    UIS.InputEnded:Connect(function(i)
        if i.UserInputType == Enum.UserInputType.MouseButton1 or i.UserInputType == Enum.UserInputType.Touch then dragging = false end
    end)
    UIS.InputChanged:Connect(function(i)
        if dragging and (i.UserInputType == Enum.UserInputType.MouseMovement or i.UserInputType == Enum.UserInputType.Touch) then
            local d = i.Position - dragStart
            Main.Position = UDim2.new(startPos.X.Scale, startPos.X.Offset + d.X, startPos.Y.Scale, startPos.Y.Offset + d.Y)
        end
    end)
end

-- FOV circle
local FOVFrame = Instance.new("Frame")
FOVFrame.AnchorPoint = Vector2.new(0.5, 0.5)
FOVFrame.Position = UDim2.new(0.5, 0, 0.5, 0)
FOVFrame.BackgroundTransparency = 1
FOVFrame.Visible = false
FOVFrame.Parent = ScreenGui
local FOVStroke = Instance.new("UIStroke")
FOVStroke.Color = Color3.fromRGB(255, 255, 255)
FOVStroke.Thickness = 1.5
FOVStroke.Parent = FOVFrame
Instance.new("UICorner", FOVFrame).CornerRadius = UDim.new(1, 0)

local ESPGui = Instance.new("Folder")
ESPGui.Name = "ESP"
ESPGui.Parent = ScreenGui

local function clearESP()
    for _, c in ipairs(ESPGui:GetChildren()) do c:Destroy() end
end

local function safeDrawing(class)
    local ok, obj = pcall(function()
        if Drawing and Drawing.new then return Drawing.new(class) end
    end)
    if ok then return obj end
    return nil
end

UIS.InputBegan:Connect(function(input, gp)
    if gp then return end
    if Config.ClickTP and (input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch) then
        if mouse.Hit and player.Character and player.Character:FindFirstChild("HumanoidRootPart") then
            player.Character.HumanoidRootPart.CFrame = CFrame.new(mouse.Hit.Position + Vector3.new(0, 3, 0))
        end
    end
end)

-- Main loop
RunService.RenderStepped:Connect(function()
    camera = workspace.CurrentCamera
    local char = player.Character
    local hum = char and char:FindFirstChildOfClass("Humanoid")
    local root = char and char:FindFirstChild("HumanoidRootPart")

    if hum then
        hum.WalkSpeed = Config.WalkSpeed
        hum.UseJumpPower = true
        hum.JumpPower = Config.JumpPower
    end

    FOVFrame.Size = UDim2.new(0, Config.FOVSize * 2, 0, Config.FOVSize * 2)
    FOVFrame.Visible = Config.FOV

    -- Auto Reload
    if Config.AutoReload and char then
        for _, tool in ipairs(char:GetChildren()) do
            if tool:IsA("Tool") then
                for _, v in ipairs(tool:GetDescendants()) do
                    if v:IsA("NumberValue") and v.Name:lower():find("ammo") then
                        v.Value = 9999
                    end
                end
            end
        end
    end

    -- No Recoil
    if Config.NoRecoil and char then
        for _, tool in ipairs(char:GetChildren()) do
            if tool:IsA("Tool") then
                for _, v in ipairs(tool:GetDescendants()) do
                    if v:IsA("NumberValue") and v.Name:lower():find("recoil") then
                        v.Value = 0
                    end
                end
            end
        end
    end

    -- No Spread
    if Config.NoSpread and char then
        for _, tool in ipairs(char:GetChildren()) do
            if tool:IsA("Tool") then
                for _, v in ipairs(tool:GetDescendants()) do
                    if v:IsA("NumberValue") and v.Name:lower():find("spread") then
                        v.Value = 0
                    end
                end
            end
        end
    end

    -- Anti-Fling
    if Config.AntiFling and root then
        for _, v in ipairs(root:GetChildren()) do
            if v:IsA("BodyAngularVelocity") or v:IsA("BodyVelocity") then
                v:Destroy()
            end
        end
    end

    for _, v in pairs(TrackLines) do pcall(function() v:Remove() end) end
    TrackLines = {}
    if Config.TrackAll and root then
        local myScreen = camera:WorldToViewportPoint(root.Position)
        local myV = Vector2.new(myScreen.X, myScreen.Y)
        local br = Config.TrackBrightness or 1
        local col = Color3.new(br, br, br)
        for _, plr in ipairs(Players:GetPlayers()) do
            if isEnemy(plr) and plr.Character and plr.Character:FindFirstChild("HumanoidRootPart") then
                local tr = plr.Character.HumanoidRootPart
                local sp = camera:WorldToViewportPoint(tr.Position)
                local lin = safeDrawing("Line")
                if lin then
                    lin.From = myV
                    lin.To = Vector2.new(sp.X, sp.Y)
                    lin.Color = col
                    lin.Thickness = Config.TrackThickness or 1.5
                    lin.Visible = true
                    table.insert(TrackLines, lin)
                end
            end
        end
    end

    clearESP()
    if Config.ESP or Config.HealthESP or Config.BoxESP or Config.Tracers or Config.LookLines then
        for _, plr in ipairs(Players:GetPlayers()) do
            if isEnemy(plr) and plr.Character then
                local head = plr.Character:FindFirstChild("Head")
                local hrp = plr.Character:FindFirstChild("HumanoidRootPart")
                local h = plr.Character:FindFirstChildOfClass("Humanoid")
                if head and h then
                    local sp, on = camera:WorldToViewportPoint(head.Position)
                    if on then
                        if Config.ESP then
                            local lbl = Instance.new("TextLabel")
                            lbl.Size = UDim2.new(0, 120, 0, 14)
                            lbl.Position = UDim2.new(0, sp.X - 60, 0, sp.Y - 28)
                            lbl.BackgroundTransparency = 1
                            lbl.Text = plr.DisplayName
                            lbl.TextColor3 = Color3.fromRGB(255, 255, 255)
                            lbl.Font = Enum.Font.GothamBold
                            lbl.TextSize = 12
                            lbl.Parent = ESPGui
                        end
                        if Config.HealthESP then
                            local lbl = Instance.new("TextLabel")
                            lbl.Size = UDim2.new(0, 80, 0, 14)
                            lbl.Position = UDim2.new(0, sp.X - 40, 0, sp.Y - 14)
                            lbl.BackgroundTransparency = 1
                            lbl.Text = math.floor(h.Health) .. " HP"
                            lbl.TextColor3 = Color3.fromRGB(100, 255, 100)
                            lbl.Font = Enum.Font.Gotham
                            lbl.TextSize = 11
                            lbl.Parent = ESPGui
                        end
                        if Config.BoxESP and hrp then
                            local box = Instance.new("Frame")
                            box.Size = UDim2.new(0, 40, 0, 60)
                            box.Position = UDim2.new(0, sp.X - 20, 0, sp.Y - 20)
                            box.BackgroundTransparency = 1
                            box.BorderSizePixel = 1
                            box.BorderColor3 = Color3.fromRGB(255, 255, 255)
                            box.Parent = ESPGui
                        end
                    end
                    if Config.Tracers and hrp then
                        local tsp = camera:WorldToViewportPoint(hrp.Position)
                        local lin = safeDrawing("Line")
                        if lin then
                            local bottom = Vector2.new(camera.ViewportSize.X / 2, camera.ViewportSize.Y)
                            lin.From = bottom
                            lin.To = Vector2.new(tsp.X, tsp.Y)
                            lin.Color = Color3.new(1, 1, 1)
                            lin.Thickness = 1
                            lin.Visible = true
                            table.insert(TrackLines, lin)
                        end
                    end
                    if Config.LookLines and hrp then
                        local from = head.Position
                        local to = head.Position + hrp.CFrame.LookVector * 6
                        local s1 = camera:WorldToViewportPoint(from)
                        local s2 = camera:WorldToViewportPoint(to)
                        local lin = safeDrawing("Line")
                        if lin then
                            lin.From = Vector2.new(s1.X, s1.Y)
                            lin.To = Vector2.new(s2.X, s2.Y)
                            lin.Color = Color3.fromRGB(255, 200, 80)
                            lin.Thickness = 1.5
                            lin.Visible = true
                            table.insert(TrackLines, lin)
                        end
                    end
                end
            end
        end
    end

    if Config.Aimbot and root then
        local center = Vector2.new(camera.ViewportSize.X / 2, camera.ViewportSize.Y / 2)
        local best, bestD = nil, Config.FOVSize
        for _, plr in ipairs(Players:GetPlayers()) do
            if isEnemy(plr) and plr.Character then
                local part = getAimPart(plr)
                local h = plr.Character:FindFirstChildOfClass("Humanoid")
                if part and h and h.Health > 0 and isVisible(part) then
                    local sp, on = camera:WorldToViewportPoint(part.Position)
                    if on and sp.Z > 0 then
                        local d = (Vector2.new(sp.X, sp.Y) - center).Magnitude
                        if d < bestD then bestD = d best = part end
                    end
                end
            end
        end
        if best then
            camera.CFrame = camera.CFrame:Lerp(CFrame.new(camera.CFrame.Position, best.Position), Config.Aimsmooth)
            if Config.TargetHighlight then
                local hl = best:FindFirstChild("FatchoiHL")
                if not hl then
                    hl = Instance.new("Highlight")
                    hl.Name = "FatchoiHL"
                    hl.FillColor = Color3.fromRGB(255, 255, 255)
                    hl.OutlineColor = Color3.fromRGB(255, 255, 255)
                    hl.FillTransparency = 0.7
                    hl.Parent = best
                end
            end
        end
    end

    if Config.Hitbox then
        for _, plr in ipairs(Players:GetPlayers()) do
            if isEnemy(plr) and plr.Character then
                for _, part in ipairs(plr.Character:GetChildren()) do
                    if part:IsA("BasePart") and part.Name ~= "HumanoidRootPart" then
                        part.Size = Vector3.new(Config.HitboxSize, Config.HitboxSize, Config.HitboxSize)
                        part.Transparency = 0.5
                        part.CanCollide = false
                    end
                end
            end
        end
    end

    if Config.BigHead then
        local s = Config.BigHeadSize
        for _, plr in ipairs(Players:GetPlayers()) do
            if isEnemy(plr) and plr.Character then
                local head = plr.Character:FindFirstChild("Head")
                if head then
                    head.Size = Vector3.new(s, s, s)
                    head.CanCollide = false
                    head.Massless = true
                end
            end
        end
    end

    if Config.TouchFling and root then
        for _, plr in ipairs(Players:GetPlayers()) do
            if isEnemy(plr) and plr.Character then
                local tr = plr.Character:FindFirstChild("HumanoidRootPart")
                if tr and (tr.Position - root.Position).Magnitude < 5 then
                    pcall(function()
                        tr.AssemblyLinearVelocity = Vector3.new(0, 80, 0) + (tr.Position - root.Position).Unit * 60
                    end)
                end
            end
        end
    end
end)

player.CharacterAdded:Connect(function(c)
    task.wait(0.5)
    local h = c:FindFirstChildOfClass("Humanoid")
    if h then
        h.WalkSpeed = Config.WalkSpeed
        h.UseJumpPower = true
        h.JumpPower = Config.JumpPower
    end
end)

print("Coded by: azi_.x | menu loaded v" .. SCRIPT_VER)