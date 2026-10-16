local Players = game:GetService("Players")
local TweenService = game:GetService("TweenService")
local HttpService = game:GetService("HttpService")

local NAME = "final test"
local FREE = false
local URL = "https://zlvwc44y52.apps.bot-hosting.cloud/s/qw1xJ3ReXlta7cJn"

local function corner(o, r) local c = Instance.new("UICorner") c.CornerRadius = UDim.new(0, r) c.Parent = o end

local gui = Instance.new("ScreenGui")
gui.Name = HttpService:GenerateGUID(false)
gui.ResetOnSpawn = false
gui.IgnoreGuiInset = true
gui.DisplayOrder = 999999
pcall(function() if syn and syn.protect_gui then syn.protect_gui(gui) end end)
local mounted = pcall(function() gui.Parent = gethui() end) and gui.Parent
if not mounted then mounted = pcall(function() gui.Parent = game:GetService("CoreGui") end) and gui.Parent end
if not mounted then gui.Parent = Players.LocalPlayer:WaitForChild("PlayerGui") end

local card = Instance.new("CanvasGroup")
card.AnchorPoint = Vector2.new(0.5, 0.5)
card.Position = UDim2.new(0.5, 0, 0.5, 24)
card.Size = UDim2.fromOffset(340, 138)
card.BackgroundColor3 = Color3.fromRGB(13, 14, 20)
card.GroupTransparency = 1
card.Parent = gui
corner(card, 14)
local stroke = Instance.new("UIStroke")
stroke.Color = Color3.fromRGB(88, 101, 242)
stroke.Thickness = 1.5
stroke.Transparency = 0.35
stroke.Parent = card

local title = Instance.new("TextLabel")
title.BackgroundTransparency = 1
title.Position = UDim2.fromOffset(20, 16)
title.Size = UDim2.new(1, -110, 0, 24)
title.Font = Enum.Font.GothamBold
title.TextSize = 18
title.TextXAlignment = Enum.TextXAlignment.Left
title.TextColor3 = Color3.fromRGB(240, 242, 255)
title.Text = NAME
title.TextTruncate = Enum.TextTruncate.AtEnd
title.Parent = card

local badge = Instance.new("TextLabel")
badge.AnchorPoint = Vector2.new(1, 0)
badge.Position = UDim2.new(1, -18, 0, 18)
badge.Size = UDim2.fromOffset(70, 20)
badge.Font = Enum.Font.GothamBold
badge.TextSize = 11
badge.Text = FREE and "FREE" or "PREMIUM"
badge.TextColor3 = FREE and Color3.fromRGB(93, 217, 141) or Color3.fromRGB(224, 169, 93)
badge.BackgroundColor3 = FREE and Color3.fromRGB(24, 52, 38) or Color3.fromRGB(58, 46, 30)
badge.Parent = card
corner(badge, 10)

local status = Instance.new("TextLabel")
status.BackgroundTransparency = 1
status.Position = UDim2.fromOffset(20, 52)
status.Size = UDim2.new(1, -40, 0, 18)
status.Font = Enum.Font.Gotham
status.TextSize = 13
status.TextXAlignment = Enum.TextXAlignment.Left
status.TextColor3 = Color3.fromRGB(150, 156, 175)
status.Text = "Starting..."
status.Parent = card

local track = Instance.new("Frame")
track.Position = UDim2.fromOffset(20, 84)
track.Size = UDim2.new(1, -40, 0, 8)
track.BackgroundColor3 = Color3.fromRGB(28, 30, 42)
track.BorderSizePixel = 0
track.ClipsDescendants = true
track.Parent = card
corner(track, 4)

local fill = Instance.new("Frame")
fill.Size = UDim2.fromScale(0, 1)
fill.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
fill.BorderSizePixel = 0
fill.Parent = track
corner(fill, 4)
local grad = Instance.new("UIGradient")
grad.Color = ColorSequence.new({
    ColorSequenceKeypoint.new(0, Color3.fromRGB(88, 101, 242)),
    ColorSequenceKeypoint.new(0.5, Color3.fromRGB(150, 110, 255)),
    ColorSequenceKeypoint.new(1, Color3.fromRGB(88, 101, 242)),
})
grad.Parent = fill

local pct = Instance.new("TextLabel")
pct.BackgroundTransparency = 1
pct.Position = UDim2.fromOffset(20, 102)
pct.Size = UDim2.new(1, -40, 0, 20)
pct.Font = Enum.Font.GothamMedium
pct.TextSize = 12
pct.TextXAlignment = Enum.TextXAlignment.Right
pct.TextColor3 = Color3.fromRGB(110, 116, 140)
pct.Text = "0%"
pct.Parent = card

local alive = true
task.spawn(function()
    while alive do
        grad.Offset = Vector2.new(-1, 0)
        local t = TweenService:Create(grad, TweenInfo.new(1.1, Enum.EasingStyle.Linear), { Offset = Vector2.new(1, 0) })
        t:Play()
        t.Completed:Wait()
    end
end)

TweenService:Create(card, TweenInfo.new(0.45, Enum.EasingStyle.Quint), { GroupTransparency = 0, Position = UDim2.fromScale(0.5, 0.5) }):Play()

local function step(text, p)
    status.Text = text
    pct.Text = math.floor(p * 100) .. "%"
    TweenService:Create(fill, TweenInfo.new(0.5, Enum.EasingStyle.Quint), { Size = UDim2.fromScale(p, 1) }):Play()
end

local function close(wait)
    task.wait(wait or 0)
    alive = false
    TweenService:Create(card, TweenInfo.new(0.35, Enum.EasingStyle.Quint), { GroupTransparency = 1, Position = UDim2.new(0.5, 0, 0.5, -24) }):Play()
    task.wait(0.4)
    gui:Destroy()
end

local function fail(msg)
    status.Text = tostring(msg)
    status.TextColor3 = Color3.fromRGB(240, 100, 100)
    stroke.Color = Color3.fromRGB(240, 100, 100)
    grad.Color = ColorSequence.new(Color3.fromRGB(220, 70, 70))
    pct.Text = "Failed"
    warn("[Loader] " .. tostring(msg))
    close(3.5)
end

task.wait(0.35)
step("Connecting...", 0.15)

local url = URL
if not FREE then
    local key = ""
    local okEnv, env = pcall(getgenv)
    if okEnv and type(env) == "table" and env.SCRIPT_KEY then
        key = tostring(env.SCRIPT_KEY)
    else
        local okG, v = pcall(function() return SCRIPT_KEY end)
        if okG and v then key = tostring(v) end
    end
    step("Identifying device...", 0.3)
    local hwid
    pcall(function() hwid = gethwid() end)
    if not hwid then
        pcall(function() hwid = game:GetService("RbxAnalyticsService"):GetClientId() end)
    end
    url = URL .. "?key=" .. HttpService:UrlEncode(key) .. "&hwid=" .. HttpService:UrlEncode(tostring(hwid or "unknown"))
end

step(FREE and "Downloading script..." or "Verifying license...", 0.55)
local got, src = pcall(function() return game:HttpGet(url) end)
if not got or type(src) ~= "string" or src == "" then
    return fail("Could not reach the server.")
end
if src:sub(1, 7) == "--FAIL:" then
    return fail(src:sub(8))
end

step("Preparing...", 0.8)
local fn, err = loadstring(src)
if not fn then
    return fail("Script failed to load.")
end

step("Launching", 1)
task.wait(0.5)
close(0)
return fn()
