local Players = game:GetService("Players")
local UIS = game:GetService("UserInputService")
local player = Players.LocalPlayer
local discordLink = "https://discord.gg/ZN4jtyPNHG"
local requiredKey = "kairon-script"

local keyGui = Instance.new("ScreenGui")
keyGui.Name = "KaironKeySystem"
keyGui.ResetOnSpawn = false
keyGui.Parent = player:WaitForChild("PlayerGui")

local frame = Instance.new("Frame")
frame.Size = UDim2.new(0, 320, 0, 180)
frame.Position = UDim2.new(0.5, -160, 0.5, -90)
frame.BackgroundColor3 = Color3.fromRGB(18, 8, 8)
frame.BorderSizePixel = 0
frame.Parent = keyGui
Instance.new("UICorner", frame).CornerRadius = UDim.new(0, 10)

local title = Instance.new("TextLabel")
title.Size = UDim2.new(1, -20, 0, 32)
title.Position = UDim2.new(0, 10, 0, 8)
title.BackgroundTransparency = 1
title.Text = "KAIRON SCRIPT | KEY SYSTEM"
title.TextColor3 = Color3.fromRGB(230, 55, 55)
title.Font = Enum.Font.GothamBold
title.TextSize = 15
title.Parent = frame

local keyBox = Instance.new("TextBox")
keyBox.Size = UDim2.new(1, -32, 0, 34)
keyBox.Position = UDim2.new(0, 16, 0, 48)
keyBox.BackgroundColor3 = Color3.fromRGB(35, 20, 20)
keyBox.TextColor3 = Color3.fromRGB(255, 255, 255)
keyBox.PlaceholderText = "Enter key here"
keyBox.Text = ""
keyBox.ClearTextOnFocus = false
keyBox.Font = Enum.Font.Gotham
keyBox.TextSize = 13
keyBox.Parent = frame
Instance.new("UICorner", keyBox).CornerRadius = UDim.new(0, 6)

local status = Instance.new("TextLabel")
status.Size = UDim2.new(1, -20, 0, 20)
status.Position = UDim2.new(0, 10, 0, 86)
status.BackgroundTransparency = 1
status.Text = "Get the key from our Discord"
status.TextColor3 = Color3.fromRGB(200, 180, 180)
status.Font = Enum.Font.Gotham
status.TextSize = 11
status.Parent = frame

local function makeKeyButton(text, position, color, callback)
    local button = Instance.new("TextButton")
    button.Size = UDim2.new(0.5, -22, 0, 34)
    button.Position = position
    button.BackgroundColor3 = color
    button.TextColor3 = Color3.fromRGB(255, 255, 255)
    button.Text = text
    button.Font = Enum.Font.GothamBold
    button.TextSize = 12
    button.BorderSizePixel = 0
    button.Parent = frame
    Instance.new("UICorner", button).CornerRadius = UDim.new(0, 6)
    button.MouseButton1Click:Connect(callback)
    return button
end

makeKeyButton("GET KEY", UDim2.new(0, 16, 0, 122), Color3.fromRGB(105, 15, 15), function()
    local copied = pcall(function()
        if setclipboard then
            setclipboard(discordLink)
        else
            error("Clipboard is not supported by this executor")
        end
    end)
    if copied then
        status.Text = "Discord link copied! Open Discord to get the key."
    else
        status.Text = "Copy unavailable. Discord: " .. discordLink
    end
end)

local verifyButton = makeKeyButton("VERIFY", UDim2.new(0.5, 6, 0, 122), Color3.fromRGB(45, 90, 45), function()
    if keyBox.Text == requiredKey then
        keyGui:Destroy()
        startMain()
    else
        status.Text = "Invalid key. Please try again."
        status.TextColor3 = Color3.fromRGB(255, 80, 80)
    end
end)

function startMain()
local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local TweenService = game:GetService("TweenService")
local UIS = game:GetService("UserInputService")
local LP = Players.LocalPlayer
local function char() return LP.Character end
local function hrp()  return char() and char():FindFirstChild("HumanoidRootPart") end
local function hum()  return char() and char():FindFirstChildOfClass("Humanoid") end
local enabled = {
    autowin    = false,
    fly        = false,
    godmode    = false,
    antiafk    = false,
    autorebirth= false,
    lockws     = false,
    lockjp     = false,
}
local cfg = { ws = 16, jp = 50, flyspd = 80, winspd = 120 }
local loops = {}
local function startLoop(id, fn)
    if loops[id] then loops[id]:Disconnect() end
    loops[id] = RunService.Heartbeat:Connect(fn)
end
local function stopLoop(id)
    if loops[id] then loops[id]:Disconnect() loops[id] = nil end
end
local function startFly()
    local h = hrp() if not h then return end
    local bv = Instance.new("BodyVelocity")
    bv.MaxForce = Vector3.new(1e5,1e5,1e5)
    bv.Velocity = Vector3.zero
    bv.Name = "_BV"; bv.Parent = h
    local bg = Instance.new("BodyGyro")
    bg.MaxTorque = Vector3.new(9e4,9e4,9e4)
    bg.D = 100; bg.CFrame = h.CFrame
    bg.Name = "_BG"; bg.Parent = h
    local hm = hum() if hm then hm.PlatformStand = true end
    startLoop("fly", function()
        local rp = hrp() if not rp then return end
        local bv2 = rp:FindFirstChild("_BV")
        local bg2 = rp:FindFirstChild("_BG")
        if not bv2 or not bg2 then return end
        local cf = workspace.CurrentCamera.CFrame
        local dir = Vector3.zero
        if UIS:IsKeyDown(Enum.KeyCode.W) then dir += cf.LookVector end
        if UIS:IsKeyDown(Enum.KeyCode.S) then dir -= cf.LookVector end
        if UIS:IsKeyDown(Enum.KeyCode.A) then dir -= cf.RightVector end
        if UIS:IsKeyDown(Enum.KeyCode.D) then dir += cf.RightVector end
        if UIS:IsKeyDown(Enum.KeyCode.Space) then dir += Vector3.yAxis end
        if UIS:IsKeyDown(Enum.KeyCode.LeftControl) then dir -= Vector3.yAxis end
        bv2.Velocity = dir.Magnitude > 0 and dir.Unit * cfg.flyspd or Vector3.zero
        bg2.CFrame = cf
    end)
end
local function stopFly()
    stopLoop("fly")
    local h = hrp()
    if h then
        for _, n in next, {"_BV","_BG"} do
            local x = h:FindFirstChild(n) if x then x:Destroy() end
        end
    end
    local hm = hum() if hm then hm.PlatformStand = false end
end
local function startGodmode()
    startLoop("god", function()
        for _, v in next, workspace:GetDescendants() do
            if v:IsA("BasePart") and v.CanTouch then
                local n = v.Name:lower()
                if n:find("kill") or n:find("lava") or n:find("tsunami")
                or n:find("trap") or n:find("spike") or n:find("hazard") then
                    v.CanTouch = false
                end
            end
        end
    end)
end
startLoop("wsjp", function()
    local h = hum() if not h then return end
    if enabled.lockws then h.WalkSpeed = cfg.ws end
    if enabled.lockjp then h.JumpPower  = cfg.jp end
end)
local function startAntiAFK()
    task.spawn(function()
        while enabled.antiafk do
            task.wait(240)
            if not enabled.antiafk then break end
            local h = hrp()
            if h then
                local cf = h.CFrame
                h.CFrame = cf + Vector3.new(0, 0.1, 0)
                task.wait(0.1)
                h.CFrame = cf
            end
        end
    end)
end
local function startAutoRebirth()
    task.spawn(function()
        while enabled.autorebirth do
            for _, v in next, game:GetService("ReplicatedStorage"):GetDescendants() do
                if (v:IsA("RemoteEvent") or v:IsA("RemoteFunction")) then
                    local n = v.Name:lower()
                    if n:find("rebirth") or n:find("reborn") or n:find("prestige") then
                        pcall(function()
                            if v:IsA("RemoteEvent") then v:FireServer()
                            else v:InvokeServer() end
                        end)
                    end
                end
            end
            task.wait(1.5)
        end
    end)
end
local function startAutoWin()
    task.spawn(function()
        while enabled.autowin do
            local cps = {}
            for _, v in next, workspace:GetDescendants() do
                if v:IsA("BasePart") then
                    local n = tonumber(v.Name) or tonumber(v.Name:match("%d+"))
                    if n then table.insert(cps, {n=n, v=v}) end
                end
            end
            table.sort(cps, function(a,b) return a.n < b.n end)
            for _, cp in next, cps do
                if not enabled.autowin then break end
                local h = hrp() if not h then break end
                local pos = cp.v.Position + Vector3.new(0, 4, 0)
                local dist = (h.Position - pos).Magnitude
                local dur = math.max(0.05, dist / cfg.winspd)
                local tw = TweenService:Create(h,
                    TweenInfo.new(dur, Enum.EasingStyle.Linear),
                    {CFrame = CFrame.new(pos)})
                tw:Play(); tw.Completed:Wait()
                task.wait(0.03)
            end
            for _, v in next, workspace:GetDescendants() do
                if v:IsA("BasePart") then
                    local n = v.Name:lower()
                    if n:find("win") or n:find("finish") or n:find("end") or n:find("goal") then
                        local h = hrp() if not h then break end
                        h.CFrame = CFrame.new(v.Position + Vector3.new(0,4,0))
                        break
                    end
                end
            end
            task.wait(1.5)
        end
    end)
end
local sg = Instance.new("ScreenGui")
sg.Name = "Rivo hub"
sg.ResetOnSpawn = false
sg.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
pcall(function() sg.Parent = game:GetService("CoreGui") end)
if not sg.Parent then sg.Parent = LP:WaitForChild("PlayerGui") end
local win = Instance.new("Frame")
win.Size = UDim2.new(0, 220, 0, 0)
win.Position = UDim2.new(0.5, -110, 0.3, 0)
win.BackgroundColor3 = Color3.fromRGB(15, 5, 5)
win.BorderSizePixel = 0
win.ZIndex = 5
win.Parent = sg
Instance.new("UICorner", win).CornerRadius = UDim.new(0, 8)
local stroke = Instance.new("UIStroke", win)
stroke.Color = Color3.fromRGB(139, 0, 0)
stroke.Thickness = 2
local dragging, dragStart, winStart = false, nil, nil
local titleBar = Instance.new("Frame")
titleBar.Size = UDim2.new(1, 0, 0, 32)
titleBar.BackgroundColor3 = Color3.fromRGB(8, 2, 2)
titleBar.BorderSizePixel = 0
titleBar.ZIndex = 6
titleBar.Parent = win
Instance.new("UICorner", titleBar).CornerRadius = UDim.new(0, 8)
local titleLbl = Instance.new("TextLabel")
titleLbl.Text = "Rivo Hub v2"
titleLbl.Size = UDim2.new(1, -10, 1, 0)
titleLbl.Position = UDim2.new(0, 10, 0, 0)
titleLbl.Font = Enum.Font.GothamBold
titleLbl.TextSize = 13
titleLbl.TextColor3 = Color3.fromRGB(180, 20, 20)
titleLbl.BackgroundTransparency = 1
titleLbl.TextXAlignment = Enum.TextXAlignment.Left
titleLbl.ZIndex = 7
titleLbl.Parent = titleBar
titleBar.InputBegan:Connect(function(i)
    if i.UserInputType == Enum.UserInputType.MouseButton1 then
        dragging = true; dragStart = i.Position; winStart = win.Position
    end
end)
titleBar.InputEnded:Connect(function(i)
    if i.UserInputType == Enum.UserInputType.MouseButton1 then dragging = false end
end)
UIS.InputChanged:Connect(function(i)
    if dragging and i.UserInputType == Enum.UserInputType.MouseMovement then
        local d = i.Position - dragStart
        win.Position = UDim2.new(winStart.X.Scale, winStart.X.Offset+d.X,
                                  winStart.Y.Scale, winStart.Y.Offset+d.Y)
    end
end)
local layout = Instance.new("UIListLayout")
layout.Padding = UDim.new(0, 3)
layout.SortOrder = Enum.SortOrder.LayoutOrder
layout.Parent = win
local pad = Instance.new("UIPadding")
pad.PaddingLeft   = UDim.new(0, 6)
pad.PaddingRight  = UDim.new(0, 6)
pad.PaddingBottom = UDim.new(0, 6)
pad.Parent = win
local spacer = Instance.new("Frame")
spacer.Size = UDim2.new(1, 0, 0, 32)
spacer.BackgroundTransparency = 1
spacer.LayoutOrder = 0
spacer.Parent = win
layout:GetPropertyChangedSignal("AbsoluteContentSize"):Connect(function()
    win.Size = UDim2.new(0, 220, 0, layout.AbsoluteContentSize.Y + 10)
end)
local order = 1
local function makeToggle(label, id, onFn, offFn)
    local btn = Instance.new("TextButton")
    btn.Size = UDim2.new(1, 0, 0, 30)
    btn.BackgroundColor3 = Color3.fromRGB(20, 7, 7)
    btn.Font = Enum.Font.Gotham
    btn.TextSize = 12
    btn.TextColor3 = Color3.fromRGB(180, 160, 160)
    btn.Text = "[ OFF ]  " .. label
    btn.BorderSizePixel = 0
    btn.ZIndex = 6
    btn.LayoutOrder = order; order += 1
    btn.Parent = win
    Instance.new("UICorner", btn).CornerRadius = UDim.new(0, 5)
    local on = false
    btn.MouseButton1Click:Connect(function()
        on = not on
        enabled[id] = on
        if on then
            btn.Text = "[ ON  ]  " .. label
            btn.TextColor3 = Color3.fromRGB(220, 60, 60)
            btn.BackgroundColor3 = Color3.fromRGB(35, 10, 10)
            if onFn then onFn() end
        else
            btn.Text = "[ OFF ]  " .. label
            btn.TextColor3 = Color3.fromRGB(180, 160, 160)
            btn.BackgroundColor3 = Color3.fromRGB(20, 7, 7)
            if offFn then offFn() end
        end
    end)
    return btn
end
local function makeButton(label, fn)
    local btn = Instance.new("TextButton")
    btn.Size = UDim2.new(1, 0, 0, 30)
    btn.BackgroundColor3 = Color3.fromRGB(100, 5, 5)
    btn.Font = Enum.Font.GothamBold
    btn.TextSize = 12
    btn.TextColor3 = Color3.fromRGB(240, 220, 220)
    btn.Text = label
    btn.BorderSizePixel = 0
    btn.ZIndex = 6
    btn.LayoutOrder = order; order += 1
    btn.Parent = win
    Instance.new("UICorner", btn).CornerRadius = UDim.new(0, 5)
    btn.MouseButton1Click:Connect(fn)
    return btn
end
local function makeSep()
    local f = Instance.new("Frame")
    f.Size = UDim2.new(1, 0, 0, 1)
    f.BackgroundColor3 = Color3.fromRGB(60, 10, 10)
    f.BorderSizePixel = 0
    f.LayoutOrder = order; order += 1
    f.Parent = win
end
makeToggle("Auto Win Obby",     "autowin",     startAutoWin, nil)
makeToggle("Auto Rebirth",      "autorebirth", startAutoRebirth, nil)
makeSep()
makeToggle("Fly (WASD+Space)",  "fly",  startFly, stopFly)
makeToggle("Godmode (No Kill)", "godmode", startGodmode, function() stopLoop("god") end)
makeToggle("Anti-AFK",          "antiafk", startAntiAFK, nil)
makeSep()
makeToggle("Lock WalkSpeed 50", "lockws", function()
    cfg.ws = 50
    local h = hum() if h then h.WalkSpeed = 50 end
end, function()
    local h = hum() if h then h.WalkSpeed = 16 end
end)
makeToggle("Lock JumpPower 100","lockjp", function()
    cfg.jp = 100
    local h = hum() if h then h.JumpPower = 100 end
end, function()
    local h = hum() if h then h.JumpPower = 50 end
end)
makeSep()
makeButton("Speed +50", function()
    cfg.ws = math.min(cfg.ws + 50, 500)
    local h = hum() if h then h.WalkSpeed = cfg.ws end
end)
makeButton("Speed -50", function()
    cfg.ws = math.max(cfg.ws - 50, 16)
    local h = hum() if h then h.WalkSpeed = cfg.ws end
end)
makeButton("Jump +50", function()
    cfg.jp = math.min(cfg.jp + 50, 500)
    local h = hum() if h then h.JumpPower = cfg.jp end
end)
makeSep()
makeButton("Print Debug (F9)", function()
    print("=== PORTOLAN DEBUG ===")
    print("WalkSpeed:", hum() and hum().WalkSpeed)
    print("JumpPower:", hum() and hum().JumpPower)
    for _, v in next, game:GetService("ReplicatedStorage"):GetDescendants() do
        if v:IsA("RemoteEvent") or v:IsA("RemoteFunction") then
            print("Remote:", v:GetFullName())
        end
    end
    print("======================")
end)
UIS.InputBegan:Connect(function(i, gp)
    if not gp and i.KeyCode == Enum.KeyCode.F9 then
        for _, v in next, game:GetService("ReplicatedStorage"):GetDescendants() do
            if v:IsA("RemoteEvent") or v:IsA("RemoteFunction") then
                print("Remote:", v:GetFullName())
            end
        end
    end
    if not gp and i.KeyCode == Enum.KeyCode.RightControl then
        win.Visible = not win.Visible
    end
end)
LP.CharacterAdded:Connect(function(c)
    c:WaitForChild("HumanoidRootPart")
    c:WaitForChild("Humanoid")
    task.wait(0.5)
    if enabled.fly     then startFly()      end
    if enabled.godmode then startGodmode()  end
    if enabled.lockws  then
        local h = c:FindFirstChildOfClass("Humanoid")
        if h then h.WalkSpeed = cfg.ws end
    end
end)
print("[PORTOLAN SIMPLE] Loaded. RightControl = toggle UI, F9 = debug")
end
