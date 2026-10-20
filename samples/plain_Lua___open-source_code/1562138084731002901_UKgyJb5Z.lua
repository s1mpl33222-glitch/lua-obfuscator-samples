if not game:IsLoaded() then
    repeat task.wait() until game:IsLoaded()
end
local TS = game:GetService("TweenService")
local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local UIS = game:GetService("UserInputService")
local LocalPlayer = Players.LocalPlayer
local Mouse = LocalPlayer:GetMouse()
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local Lighting = game:GetService("Lighting")
local CoreGui = game:GetService("CoreGui")
local TeleportService = game:GetService("TeleportService")
_G.AnimsEnabled = true
_G.RGBOutline = false
_G.Noclip = false
_G.InfJump = false
_G.AntiAFK = true
_G.FullBright = false
_G.ESPToggled = false
_G.WalkSpeed = 16
_G.JumpPower = 50
_G.Flying = false
_G.MasterActive = true
_G.FlySpeed = 60
local CurrentBgColor = Color3.fromRGB(12, 12, 12)
local CurrentOutlineColor = Color3.fromRGB(0, 255, 0)
local UI = Instance.new("ScreenGui")
UI.Name = "GreenHub_V2"
local ok = pcall(function() UI.Parent = CoreGui end)
if not ok then UI.Parent = LocalPlayer:WaitForChild("PlayerGui") end
local NotifFrame = Instance.new("Frame", UI)
NotifFrame.Size = UDim2.new(0, 220, 0, 0)
NotifFrame.Position = UDim2.new(1, -230, 1, -20)
NotifFrame.BackgroundTransparency = 1
NotifFrame.AnchorPoint = Vector2.new(0, 1)
local NotifLayout = Instance.new("UIListLayout", NotifFrame)
NotifLayout.VerticalAlignment = Enum.VerticalAlignment.Bottom
NotifLayout.Padding = UDim.new(0, 6)
NotifLayout.SortOrder = Enum.SortOrder.LayoutOrder
local notifCount = 0
local function Notify(text, color)
    notifCount = notifCount + 1
    local n = Instance.new("Frame", NotifFrame)
    n.Size = UDim2.new(1, 0, 0, 0)
    n.BackgroundColor3 = Color3.fromRGB(18, 18, 18)
    n.BorderSizePixel = 0
    n.LayoutOrder = -notifCount
    local stroke = Instance.new("UIStroke", n)
    stroke.Color = color or CurrentOutlineColor
    stroke.Thickness = 2
    Instance.new("UICorner", n).CornerRadius = UDim.new(0, 8)
    local lbl = Instance.new("TextLabel", n)
    lbl.Size = UDim2.new(1, -10, 1, 0)
    lbl.Position = UDim2.new(0, 8, 0, 0)
    lbl.BackgroundTransparency = 1
    lbl.Text = text
    lbl.TextColor3 = color or Color3.fromRGB(255, 255, 255)
    lbl.Font = "GothamBold"
    lbl.TextSize = 12
    lbl.TextXAlignment = Enum.TextXAlignment.Left
    lbl.TextWrapped = true
    TS:Create(n, TweenInfo.new(0.3), {Size = UDim2.new(1, 0, 0, 40)}):Play()
    task.delay(3, function()
        TS:Create(n, TweenInfo.new(0.3), {Size = UDim2.new(1, 0, 0, 0)}):Play()
        task.wait(0.3); n:Destroy()
    end)
end
local function ApplyStyle(obj, color)
    local c = Instance.new("UICorner", obj); c.CornerRadius = UDim.new(0, 9)
    local s = Instance.new("UIStroke", obj)
    s.Name = "MainStroke"; s.Color = color or CurrentOutlineColor
    s.Thickness = 2; s.ApplyStrokeMode = Enum.ApplyStrokeMode.Border
end
local function MakeMoveable(obj)
    local drag, start, pos
    obj.InputBegan:Connect(function(i)
        if i.UserInputType == Enum.UserInputType.MouseButton1 or i.UserInputType == Enum.UserInputType.Touch then
            drag = true; start = i.Position; pos = obj.Position
        end
    end)
    UIS.InputChanged:Connect(function(i)
        if drag and (i.UserInputType == Enum.UserInputType.MouseMovement or i.UserInputType == Enum.UserInputType.Touch) then
            local d = i.Position - start
            obj.Position = UDim2.new(pos.X.Scale, pos.X.Offset + d.X, pos.Y.Scale, pos.Y.Offset + d.Y)
        end
    end)
    obj.InputEnded:Connect(function() drag = false end)
end
local function AnimateClick(btn)
    if not _G.AnimsEnabled then return end
    local os = btn.Size
    local inf = TweenInfo.new(0.1, Enum.EasingStyle.Back, Enum.EasingDirection.Out)
    local sh = TS:Create(btn, inf, {Size = UDim2.new(os.X.Scale, os.X.Offset-7, os.Y.Scale, os.Y.Offset-7)})
    local gr = TS:Create(btn, inf, {Size = os})
    sh:Play(); sh.Completed:Wait(); gr:Play()
end
local VU = game:GetService("VirtualUser")
LocalPlayer.Idled:Connect(function()
    if _G.AntiAFK then
        VU:Button2Down(Vector2.new(0,0), workspace.CurrentCamera.CFrame)
        task.wait(1)
        VU:Button2Up(Vector2.new(0,0), workspace.CurrentCamera.CFrame)
    end
end)
RunService.Heartbeat:Connect(function()
    local c = LocalPlayer.Character
    if c then
        local h = c:FindFirstChild("Humanoid")
        if h then
            h.WalkSpeed = _G.WalkSpeed
            h.JumpPower = _G.JumpPower
        end
    end
end)
RunService.Heartbeat:Connect(function()
    if _G.FullBright then
        Lighting.Brightness = 2; Lighting.ClockTime = 14
        Lighting.FogEnd = 100000; Lighting.GlobalShadows = false
        Lighting.Ambient = Color3.fromRGB(255,255,255)
    end
end)
task.spawn(function()
    while task.wait(0.03) and _G.MasterActive do
        if _G.RGBOutline then
            local hue = tick() % 3 / 3
            local col = Color3.fromHSV(hue, 0.8, 1)
            for _, v in pairs(UI:GetDescendants()) do
                if v:IsA("UIStroke") and v.Name == "MainStroke" then v.Color = col end
            end
        end
    end
end)
RunService.Stepped:Connect(function()
    if _G.Noclip then
        local c = LocalPlayer.Character
        if c then
            for _, p in pairs(c:GetDescendants()) do
                if p:IsA("BasePart") then p.CanCollide = false end
            end
        end
    end
end)
UIS.JumpRequest:Connect(function()
    if _G.InfJump then
        local c = LocalPlayer.Character
        if c then
            local h = c:FindFirstChild("Humanoid")
            if h then h:ChangeState(Enum.HumanoidStateType.Jumping) end
        end
    end
end)
local flyConn, bodyVel, bodyGyr
local function getMobileMove()
    local ctrl = require(LocalPlayer:WaitForChild("PlayerScripts"):WaitForChild("PlayerModule")):GetControls()
    return ctrl:GetMoveVector()
end
local function StartFly()
    local c = LocalPlayer.Character; if not c then return end
    local hrp = c:FindFirstChild("HumanoidRootPart")
    local hum = c:FindFirstChild("Humanoid")
    if not hrp or not hum then return end
    hum.PlatformStand = true
    bodyVel = Instance.new("BodyVelocity", hrp)
    bodyVel.Velocity = Vector3.zero; bodyVel.MaxForce = Vector3.new(1e5,1e5,1e5)
    bodyGyr = Instance.new("BodyGyro", hrp)
    bodyGyr.MaxTorque = Vector3.new(1e5,1e5,1e5); bodyGyr.D = 50
    flyConn = RunService.Heartbeat:Connect(function()
        if not _G.Flying then
            if bodyVel then bodyVel:Destroy(); bodyVel = nil end
            if bodyGyr then bodyGyr:Destroy(); bodyGyr = nil end
            hum.PlatformStand = false
            if flyConn then flyConn:Disconnect(); flyConn = nil end
            return
        end
        local cam = workspace.CurrentCamera
        local dir = Vector3.zero
        if UIS:IsKeyDown(Enum.KeyCode.W) then dir = dir + cam.CFrame.LookVector end
        if UIS:IsKeyDown(Enum.KeyCode.S) then dir = dir - cam.CFrame.LookVector end
        if UIS:IsKeyDown(Enum.KeyCode.A) then dir = dir - cam.CFrame.RightVector end
        if UIS:IsKeyDown(Enum.KeyCode.D) then dir = dir + cam.CFrame.RightVector end
        if UIS:IsKeyDown(Enum.KeyCode.Space) then dir = dir + Vector3.new(0,1,0) end
        if UIS:IsKeyDown(Enum.KeyCode.LeftShift) then dir = dir - Vector3.new(0,1,0) end
        local ok2, mv = pcall(getMobileMove)
        if ok2 and mv.Magnitude > 0.1 then
            dir = dir + cam.CFrame.RightVector * mv.X + cam.CFrame.LookVector * -mv.Z
        end
        bodyVel.Velocity = dir.Magnitude > 0 and dir.Unit * _G.FlySpeed or Vector3.zero
        bodyGyr.CFrame = cam.CFrame
    end)
end
local function StopFly() _G.Flying = false end
local espBBs = {}
local function UpdateESP()
    for _, v in pairs(espBBs) do pcall(function() v:Destroy() end) end
    espBBs = {}
    if not _G.ESPToggled then return end
    for _, plr in pairs(Players:GetPlayers()) do
        if plr ~= LocalPlayer and plr.Character then
            local hrp = plr.Character:FindFirstChild("HumanoidRootPart")
            if hrp then
                local bb = Instance.new("BillboardGui", hrp)
                bb.Size = UDim2.new(0,100,0,40); bb.StudsOffset = Vector3.new(0,3,0); bb.AlwaysOnTop = true
                local lbl = Instance.new("TextLabel", bb)
                lbl.Size = UDim2.new(1,0,1,0); lbl.BackgroundTransparency = 1
                lbl.Text = plr.Name; lbl.TextColor3 = Color3.fromRGB(255,50,50)
                lbl.Font = "GothamBold"; lbl.TextSize = 14; lbl.TextStrokeTransparency = 0
                table.insert(espBBs, bb)
            end
        end
    end
end
task.spawn(function()
    while _G.MasterActive do
        if _G.ESPToggled then UpdateESP()
        else
            for _, v in pairs(espBBs) do pcall(function() v:Destroy() end) end
            espBBs = {}
        end
        task.wait(0.5)
    end
end)
local itemESPActive = false
local itemESPBBs = {}
local function ClearItemESP()
    for _, v in pairs(itemESPBBs) do pcall(function() v:Destroy() end) end; itemESPBBs = {}
end
local function UpdateItemESP()
    ClearItemESP(); if not itemESPActive then return end
    for _, obj in pairs(workspace:GetDescendants()) do
        if obj:IsA("Model") then
            local isLog = obj.Name:sub(1,6) == "Loose_"
            local isTree = obj:FindFirstChild("TreeClass") ~= nil
            if isLog or isTree then
                local part = obj.PrimaryPart or obj:FindFirstChildWhichIsA("BasePart")
                if part then
                    local bb = Instance.new("BillboardGui", part)
                    bb.Size = UDim2.new(0,120,0,35); bb.StudsOffset = Vector3.new(0,4,0)
                    bb.AlwaysOnTop = true; bb.MaxDistance = 500
                    local lbl = Instance.new("TextLabel", bb)
                    lbl.Size = UDim2.new(1,0,1,0); lbl.BackgroundTransparency = 1
                    lbl.Font = "GothamBold"; lbl.TextSize = 13; lbl.TextStrokeTransparency = 0
                    if isLog then lbl.Text = "LOG"; lbl.TextColor3 = Color3.fromRGB(255,200,0)
                    else
                        local tc = obj:FindFirstChild("TreeClass")
                        lbl.Text = tc and tc.Value or "TREE"; lbl.TextColor3 = Color3.fromRGB(0,255,100)
                    end
                    table.insert(itemESPBBs, bb)
                end
            end
        end
    end
end
task.spawn(function()
    while _G.MasterActive do
        if itemESPActive then UpdateItemESP() end
        task.wait(3)
    end
end)
local godActive = false
local Main = Instance.new("Frame", UI)
Main.Name = "MainFrame"; Main.Size = UDim2.new(0,550,0,380)
Main.Position = UDim2.new(0.5,-275,0.5,-190)
Main.BackgroundColor3 = CurrentBgColor; Main.BorderSizePixel = 0; Main.Active = true
ApplyStyle(Main); MakeMoveable(Main)
local Sidebar = Instance.new("ScrollingFrame", Main)
Sidebar.Size = UDim2.new(0,140,1,-80); Sidebar.Position = UDim2.new(0,10,0,60)
Sidebar.BackgroundTransparency = 1; Sidebar.ScrollBarThickness = 0; Sidebar.AutomaticCanvasSize = "Y"
Instance.new("UIListLayout", Sidebar).Padding = UDim.new(0,8)
local Container = Instance.new("Frame", Main)
Container.Size = UDim2.new(1,-170,1,-80); Container.Position = UDim2.new(0,160,0,60)
Container.BackgroundTransparency = 1
local Title = Instance.new("TextLabel", Main)
Title.Size = UDim2.new(0,200,0,25); Title.Position = UDim2.new(0,10,0,8)
Title.Text = "Green Hub | Let7829"; Title.TextColor3 = Color3.fromRGB(0,255,0)
Title.Font = "GothamBold"; Title.TextSize = 15; Title.BackgroundTransparency = 1
Title.TextXAlignment = "Left"
local SubTitle = Instance.new("TextLabel", Main)
SubTitle.Size = UDim2.new(0,150,0,20); SubTitle.Position = UDim2.new(0,10,0,32)
SubTitle.Text = "LT2 Master Hub V2"; SubTitle.TextColor3 = Color3.fromRGB(150,150,150)
SubTitle.Font = "Gotham"; SubTitle.TextSize = 11; SubTitle.BackgroundTransparency = 1
SubTitle.TextXAlignment = "Left"
local SearchBox = Instance.new("TextBox", Main)
SearchBox.Size = UDim2.new(0,170,0,28); SearchBox.Position = UDim2.new(1,-185,0,16)
SearchBox.BackgroundColor3 = Color3.fromRGB(25,25,25); SearchBox.TextColor3 = Color3.fromRGB(255,255,255)
SearchBox.PlaceholderText = "Search..."; SearchBox.PlaceholderColor3 = Color3.fromRGB(100,100,100)
SearchBox.Font = "Gotham"; SearchBox.TextSize = 12; SearchBox.Text = ""
SearchBox.BorderSizePixel = 0; SearchBox.ClearTextOnFocus = false
ApplyStyle(SearchBox, Color3.fromRGB(0,255,0))
local allButtons = {}
local function filterButtons(q)
    q = q:lower()
    for _, d in pairs(allButtons) do
        d.btn.Visible = q == "" or d.name:lower():find(q,1,true) ~= nil
    end
end
SearchBox:GetPropertyChangedSignal("Text"):Connect(function() filterButtons(SearchBox.Text) end)
local Pages, TabBtns = {}, {}
local function NewTab(name)
    local pg = Instance.new("ScrollingFrame", Container)
    pg.Name = name.."Page"; pg.Size = UDim2.new(1,0,1,0)
    pg.BackgroundTransparency = 1; pg.Visible = false
    pg.ScrollBarThickness = 4; pg.AutomaticCanvasSize = "Y"
    local lay = Instance.new("UIListLayout", pg)
    lay.Padding = UDim.new(0,10); lay.HorizontalAlignment = "Center"
    local pad = Instance.new("UIPadding", pg); pad.PaddingTop = UDim.new(0,10)
    local b = Instance.new("TextButton", Sidebar)
    b.Size = UDim2.new(1,0,0,38); b.BackgroundColor3 = Color3.fromRGB(28,28,28)
    b.Text = name; b.TextColor3 = Color3.fromRGB(200,200,200)
    b.Font = "GothamMedium"; b.TextSize = 13
    ApplyStyle(b, Color3.fromRGB(50,50,50))
    b.MouseButton1Click:Connect(function()
        AnimateClick(b)
        for _, v in pairs(Pages) do v.Visible = false end
        for _, v in pairs(TabBtns) do v.BackgroundColor3 = Color3.fromRGB(28,28,28); v:FindFirstChild("MainStroke").Color = Color3.fromRGB(50,50,50) end
        pg.Visible = true; b.BackgroundColor3 = Color3.fromRGB(40,40,40); b:FindFirstChild("MainStroke").Color = CurrentOutlineColor
    end)
    Pages[name] = pg; TabBtns[name] = b
    return pg
end
local function NewButton(txt, pg, color, func)
    local b = Instance.new("TextButton", pg)
    b.Size = UDim2.new(0.96,0,0,42); b.BackgroundColor3 = Color3.fromRGB(22,22,22)
    b.Text = txt; b.TextColor3 = Color3.fromRGB(255,255,255)
    b.Font = "GothamBold"; b.TextSize = 13
    ApplyStyle(b, color)
    b.MouseButton1Click:Connect(function() spawn(function() AnimateClick(b) end); func(b) end)
    table.insert(allButtons, {btn=b, name=txt})
    return b
end
local function NewLabel(txt, pg, color)
    local l = Instance.new("TextLabel", pg)
    l.Size = UDim2.new(0.96,0,0,28); l.BackgroundTransparency = 1
    l.Text = txt; l.TextColor3 = color or Color3.fromRGB(180,180,180)
    l.Font = "GothamBold"; l.TextSize = 12; l.TextXAlignment = Enum.TextXAlignment.Center
    return l
end
local function NewSlider(labelText, pg, minVal, maxVal, curVal, cb)
    local frame = Instance.new("Frame", pg)
    frame.Size = UDim2.new(0.96,0,0,60); frame.BackgroundColor3 = Color3.fromRGB(22,22,22)
    frame.BorderSizePixel = 0; ApplyStyle(frame)
    local label = Instance.new("TextLabel", frame)
    label.Size = UDim2.new(1,0,0,25); label.BackgroundTransparency = 1
    label.Text = labelText..": "..curVal; label.TextColor3 = Color3.fromRGB(255,255,255)
    label.Font = "GothamBold"; label.TextSize = 13
    local track = Instance.new("Frame", frame)
    track.Size = UDim2.new(1,-20,0,8); track.Position = UDim2.new(0,10,0,38)
    track.BackgroundColor3 = Color3.fromRGB(50,50,50); track.BorderSizePixel = 0
    Instance.new("UICorner", track).CornerRadius = UDim.new(1,0)
    local fill = Instance.new("Frame", track)
    fill.Size = UDim2.new((curVal-minVal)/(maxVal-minVal),0,1,0)
    fill.BackgroundColor3 = CurrentOutlineColor; fill.BorderSizePixel = 0
    Instance.new("UICorner", fill).CornerRadius = UDim.new(1,0)
    local knob = Instance.new("TextButton", track)
    knob.Size = UDim2.new(0,18,0,18)
    knob.Position = UDim2.new((curVal-minVal)/(maxVal-minVal),-9,0.5,-9)
    knob.BackgroundColor3 = Color3.fromRGB(255,255,255); knob.Text = ""; knob.BorderSizePixel = 0
    Instance.new("UICorner", knob).CornerRadius = UDim.new(1,0)
    local sliding = false
    knob.InputBegan:Connect(function(i)
        if i.UserInputType == Enum.UserInputType.MouseButton1 or i.UserInputType == Enum.UserInputType.Touch then sliding = true end
    end)
    UIS.InputEnded:Connect(function(i)
        if i.UserInputType == Enum.UserInputType.MouseButton1 or i.UserInputType == Enum.UserInputType.Touch then sliding = false end
    end)
    UIS.InputChanged:Connect(function(i)
        if sliding and (i.UserInputType == Enum.UserInputType.MouseMovement or i.UserInputType == Enum.UserInputType.Touch) then
            local relX = math.clamp((i.Position.X - track.AbsolutePosition.X) / track.AbsoluteSize.X, 0, 1)
            local val = math.floor(minVal + relX*(maxVal-minVal))
            fill.Size = UDim2.new(relX,0,1,0); knob.Position = UDim2.new(relX,-9,0.5,-9)
            label.Text = labelText..": "..val; cb(val)
        end
    end)
end
local Close = Instance.new("TextButton", Main)
Close.Size = UDim2.new(0,35,0,35); Close.Position = UDim2.new(1,-45,0,10)
Close.BackgroundColor3 = Color3.fromRGB(80,0,0); Close.Text = "X"
Close.TextColor3 = Color3.fromRGB(255,0,0); Close.Font = "GothamBold"
ApplyStyle(Close, Color3.fromRGB(200,0,0))
local ShowBtn = Instance.new("TextButton", UI)
ShowBtn.Size = UDim2.new(0,100,0,40); ShowBtn.Position = UDim2.new(0,20,0,20)
ShowBtn.BackgroundColor3 = Color3.fromRGB(15,15,15); ShowBtn.Text = "OPEN"
ShowBtn.TextColor3 = CurrentOutlineColor; ShowBtn.Font = "GothamBold"; ShowBtn.Visible = false
ApplyStyle(ShowBtn); MakeMoveable(ShowBtn)
Close.MouseButton1Click:Connect(function()
    TS:Create(Main, TweenInfo.new(0.4, Enum.EasingStyle.Back, Enum.EasingDirection.In), {Size = UDim2.new(0,0,0,0)}):Play()
    task.wait(0.4); Main.Visible = false; ShowBtn.Visible = true
end)
ShowBtn.MouseButton1Click:Connect(function()
    Main.Visible = true; ShowBtn.Visible = false
    TS:Create(Main, TweenInfo.new(0.4, Enum.EasingStyle.Back, Enum.EasingDirection.Out), {Size = UDim2.new(0,550,0,380)}):Play()
end)
local keybindToggleKey = Enum.KeyCode.RightShift
UIS.InputBegan:Connect(function(input, gameProcessed)
    if gameProcessed then return end
    if input.KeyCode == keybindToggleKey then
        if Main.Visible then
            TS:Create(Main, TweenInfo.new(0.4, Enum.EasingStyle.Back, Enum.EasingDirection.In), {Size = UDim2.new(0,0,0,0)}):Play()
            task.wait(0.4); Main.Visible = false; ShowBtn.Visible = true
            Notify("Hub hidden (RightShift to show)", Color3.fromRGB(200,200,200))
        else
            Main.Visible = true; ShowBtn.Visible = false
            TS:Create(Main, TweenInfo.new(0.4, Enum.EasingStyle.Back, Enum.EasingDirection.Out), {Size = UDim2.new(0,550,0,380)}):Play()
            Notify("Hub opened", CurrentOutlineColor)
        end
    end
    if input.KeyCode == Enum.KeyCode.F then
        _G.Flying = not _G.Flying
        if _G.Flying then StartFly() else StopFly() end
        Notify(_G.Flying and "Fly: ON [F]" or "Fly: OFF [F]", Color3.fromRGB(0,255,255))
    end
    if input.KeyCode == Enum.KeyCode.N then
        _G.Noclip = not _G.Noclip
        Notify(_G.Noclip and "Noclip: ON [N]" or "Noclip: OFF [N]", Color3.fromRGB(255,255,255))
    end
    if input.KeyCode == Enum.KeyCode.J then
        _G.InfJump = not _G.InfJump
        Notify(_G.InfJump and "Inf Jump: ON [J]" or "Inf Jump: OFF [J]", Color3.fromRGB(255,200,0))
    end
    if input.KeyCode == Enum.KeyCode.B then
        for _, Log in pairs(workspace.LogModels:GetChildren()) do
            if Log.Name:sub(1,6) == "Loose_" and Log:FindFirstChild("Owner") and Log.Owner.Value == LocalPlayer then
                Log:MoveTo(LocalPlayer.Character.HumanoidRootPart.Position + Vector3.new(0,10,0))
            end
        end
        Notify("Wood brought! [B]", Color3.fromRGB(139,90,43))
    end
end)
local HomeT  = NewTab("Home")
local WoodT  = NewTab("Wood")
local TeleT  = NewTab("Teleport")
local BuyT   = NewTab("Autobuy")
local VehT   = NewTab("Vehicle")
local PlayT  = NewTab("Player")
local VisT   = NewTab("Visuals")
local AutoT  = NewTab("Automation")
local FarmT  = NewTab("Farm")
local SlotT  = NewTab("Slots")
local MiscT  = NewTab("Misc")
local DupeT  = NewTab("Dupe")
local UiT    = NewTab("Settings")
local lonecaveStatus = NewLabel("Lonecave: Checking...", HomeT, Color3.fromRGB(255,200,0))
task.spawn(function()
    while _G.MasterActive do
        pcall(function()
            local found = false
            for _, r in pairs(workspace:GetChildren()) do
                if r.Name == "TreeRegion" then
                    for _, t in pairs(r:GetChildren()) do
                        if t:IsA("Model") and t:FindFirstChild("TreeClass") and t.TreeClass.Value == "Lonecave" then
                            found = true; break
                        end
                    end
                end
            end
            lonecaveStatus.Text = found and "Lonecave Tree: ON SERVER!" or "Lonecave Tree: Not found"
            lonecaveStatus.TextColor3 = found and Color3.fromRGB(0,255,100) or Color3.fromRGB(255,80,80)
        end)
        task.wait(5)
    end
end)
local serverInfoLabel = NewLabel("Players: "..#Players:GetPlayers(), HomeT, Color3.fromRGB(150,200,255))
task.spawn(function()
    while _G.MasterActive do
        serverInfoLabel.Text = "Players in server: "..#Players:GetPlayers()
        task.wait(5)
    end
end)
NewLabel("-- KEYBINDS: RShift=Hub | F=Fly | N=Noclip | J=InfJump | B=BringWood --", HomeT, Color3.fromRGB(100,200,100))
NewButton("LOAD RTX GRAPHICS", HomeT, Color3.fromRGB(0,255,100), function()
    loadstring(game:HttpGet('https://pastebin.com/raw/kH90gD5d'))()
end)
NewButton("INFINITE YIELD", HomeT, Color3.fromRGB(0,180,255), function()
    loadstring(game:HttpGet('https://raw.githubusercontent.com/EdgeIY/infiniteyield/master/source'))()
end)
NewButton("NAMELESS ADMIN", HomeT, Color3.fromRGB(255,0,255), function()
    loadstring(game:HttpGet('https://raw.githubusercontent.com/FilteringEnabled/NamelessAdmin/main/Source'))()
end)
NewButton("REJOIN SERVER", HomeT, Color3.fromRGB(255,150,0), function()
    TeleportService:Teleport(game.PlaceId, LocalPlayer)
end)
NewButton("COPY SERVER LINK", HomeT, Color3.fromRGB(0,200,200), function()
    setclipboard("roblox://experiences/start?placeId="..game.PlaceId.."&gameInstanceId="..game.JobId)
    Notify("Server link copied!", Color3.fromRGB(0,200,200))
end)
NewButton("BRING ALL LOOSE WOOD", HomeT, Color3.fromRGB(139,90,43), function()
    local count = 0
    for _, Log in pairs(workspace.LogModels:GetChildren()) do
        if Log.Name:sub(1,6) == "Loose_" and Log:FindFirstChild("Owner") and Log.Owner.Value == LocalPlayer then
            Log:MoveTo(LocalPlayer.Character.HumanoidRootPart.Position + Vector3.new(0,10,0))
            count = count + 1
        end
    end
    Notify("Brought "..count.." logs!", Color3.fromRGB(139,90,43))
end)
NewButton("SELL EVERYTHING", HomeT, Color3.fromRGB(255,50,50), function()
    pcall(function() loadstring(game:HttpGet('https://pastebin.com/raw/YZMvDRHB',true))() end)
    Notify("Selling everything...", Color3.fromRGB(255,50,50))
end)
NewButton("DESTROY HUB", HomeT, Color3.fromRGB(255,0,0), function()
    _G.MasterActive = false; if UI then UI:Destroy() end
end)
local function getAxStats(axName, treClas)
    local mod = ReplicatedStorage.AxeClasses:FindFirstChild("AxeClass_"..axName)
    if not mod then return end
    local s = require(mod).new()
    if s.SpecialTrees and s.SpecialTrees[treClas] then
        for k, v in next, s.SpecialTrees[treClas] do s[k] = v end
    end
    return s
end
local function getTreeOfClass(clas)
    local pos = {}
    for _, r in next, workspace:GetChildren() do
        if r.Name == "TreeRegion" then
            for _, t in next, r:GetChildren() do
                if t:IsA("Model") and t:FindFirstChild("TreeClass") and t.TreeClass.Value == clas then
                    if t:FindFirstChild("CutEvent") and (not t:FindFirstChild("Owner") or t.Owner.Value == nil) then
                        local m = 0
                        for _, p in next, t:GetDescendants() do if p:IsA("BasePart") then m = m + p.Mass end end
                        table.insert(pos, {tre=t, mass=m})
                    end
                end
            end
        end
    end
    table.sort(pos, function(a,b) return a.mass > b.mass end)
    return pos[1] and pos[1].tre or nil
end
NewButton("BRING ALL WOOD", WoodT, Color3.fromRGB(139,90,43), function()
    local count = 0
    for _, Log in pairs(workspace.LogModels:GetChildren()) do
        if Log.Name:sub(1,6) == "Loose_" and Log:FindFirstChild("Owner") and Log.Owner.Value == LocalPlayer then
            Log:MoveTo(LocalPlayer.Character.HumanoidRootPart.Position + Vector3.new(0,10,0))
            count = count + 1
        end
    end
    Notify("Brought "..count.." logs!", Color3.fromRGB(139,90,43))
end)
NewButton("SELL EVERYTHING", WoodT, Color3.fromRGB(255,50,50), function()
    pcall(function() loadstring(game:HttpGet('https://pastebin.com/raw/YZMvDRHB',true))() end)
    Notify("Selling...", Color3.fromRGB(255,50,50))
end)
NewButton("DELETE MY WOOD", WoodT, Color3.fromRGB(200,50,50), function()
    local count = 0
    for _, Log in pairs(workspace.LogModels:GetChildren()) do
        if Log.Name:sub(1,6) == "Loose_" and Log:FindFirstChild("Owner") and Log.Owner.Value == LocalPlayer then
            Log:Destroy(); count = count + 1
        end
    end
    Notify("Deleted "..count.." logs!", Color3.fromRGB(200,50,50))
end)
local woodTypes = {
    {"BRING GENERIC",    "Generic",     Color3.fromRGB(150,150,150)},
    {"BRING OAK",        "Oak",         Color3.fromRGB(139,69,19)},
    {"BRING BIRCH",      "Birch",       Color3.fromRGB(255,228,196)},
    {"BRING CHERRY",     "Cherry",      Color3.fromRGB(255,105,180)},
    {"BRING WALNUT",     "Walnut",      Color3.fromRGB(101,67,33)},
    {"BRING FIR",        "Fir",         Color3.fromRGB(34,139,34)},
    {"BRING PINE",       "Pine",        Color3.fromRGB(0,100,0)},
    {"BRING VOLCANO",    "Volcano",     Color3.fromRGB(255,69,0)},
    {"BRING FROST",      "Frost",       Color3.fromRGB(0,255,255)},
    {"BRING GOLD",       "GoldSwampy",  Color3.fromRGB(255,215,0)},
    {"BRING KOA",        "Koa",         Color3.fromRGB(205,133,63)},
    {"BRING PALM",       "Palm",        Color3.fromRGB(244,164,96)},
    {"BRING CAVECRAWLER","CaveCrawler", Color3.fromRGB(169,169,169)},
    {"BRING ZOMBIE",     "GreenSwampy", Color3.fromRGB(85,107,47)},
}
for _, data in pairs(woodTypes) do
    local lbl, woodType, color = data[1], data[2], data[3]
    NewButton(lbl, WoodT, color, function()
        local cooper = LocalPlayer
        local curpos = cooper.Character.HumanoidRootPart.CFrame
        local target = getTreeOfClass(woodType)
        local ax = nil
        for _, v in next, cooper.Backpack:GetChildren() do if v:FindFirstChild("ToolName") then ax = v; break end end
        if target and ax then
            Notify("Bringing "..woodType.."...", color)
            local stats = getAxStats(ax.ToolName.Value, woodType)
            local newLog = nil
            local con = workspace.LogModels.ChildAdded:Connect(function(l) task.wait() if l:FindFirstChild("Owner") and l.Owner.Value == cooper then newLog = l end end)
            local lp = RunService.Heartbeat:Connect(function() cooper.Character.HumanoidRootPart.CFrame = target.WoodSection.CFrame + Vector3.new(5,3,0) end)
            repeat ReplicatedStorage.Interaction.RemoteProxy:FireServer(target.CutEvent, {tool=ax,height=0.3,faceVector=Vector3.new(1,0,0),sectionId=1,hitPoints=stats.Damage,cooldown=stats.SwingCooldown,cuttingClass="Axe"}) task.wait(stats.SwingCooldown) until newLog ~= nil
            lp:Disconnect(); con:Disconnect(); task.wait(0.2)
            for i=1,60 do ReplicatedStorage.Interaction.ClientIsDragging:FireServer(newLog); newLog:PivotTo(curpos); task.wait() end
            cooper.Character.HumanoidRootPart.CFrame = curpos
            Notify(woodType.." brought!", color)
        else
            Notify("No tree or axe found!", Color3.fromRGB(255,80,80))
        end
    end)
end
NewButton("BRING LONECAVE", WoodT, Color3.fromRGB(128,0,128), function()
    local char = LocalPlayer.Character; if not char then return end
    local hrp = char:FindFirstChild("HumanoidRootPart"); if not hrp then return end
    local found = false
    for _, tree in pairs(workspace:GetDescendants()) do
        if tree:IsA("Model") and tree:FindFirstChild("TreeClass") and tree.TreeClass.Value == "Lonecave" then
            local rootPart = tree:FindFirstChildWhichIsA("BasePart")
            if rootPart then
                local offset = tree:GetPivot():Inverse() * rootPart.CFrame
                tree:PivotTo(hrp.CFrame * offset:Inverse())
            end
            for _, part in pairs(tree:GetDescendants()) do
                if part:IsA("BasePart") then part.CanCollide = false; part.Anchored = true end
            end
            found = true
        end
    end
    Notify(found and "Lonecave brought!" or "Lonecave not found!", found and Color3.fromRGB(128,0,128) or Color3.fromRGB(255,80,80))
end)
local LocData = {
    {"Wood R Us",         CFrame.new(264,3,57)},
    {"Land Store",        CFrame.new(111,11,-987)},
    {"Links Logic",       CFrame.new(114,3,-611)},
    {"Volcano",           CFrame.new(-1585,625,1140)},
    {"Swamp",             CFrame.new(-1209,138,-801)},
    {"Cave",              CFrame.new(3581,-177,430)},
    {"Palm Island",       CFrame.new(2549,5,-42)},
    {"Fancy Furnishings", CFrame.new(491,13,-1720)},
    {"Boxed Cars",        CFrame.new(509,5,-1463)},
    {"Fine Arts Shop",    CFrame.new(5207,-156,719)},
    {"Bob's Shack",       CFrame.new(260,10,-2542)},
    {"The Den",           CFrame.new(323,49,1930)},
    {"Shrine of Sight",   CFrame.new(-1600,205,919)},
    {"Ski Lodge",         CFrame.new(1244,66,2306)},
    {"Strange Man",       CFrame.new(1061,20,1131)},
    {"End Times",         CFrame.new(113,-204,-951)},
    {"Spawn",             CFrame.new(0,5,0)},
}
for _, d in pairs(LocData) do
    NewButton("TP: "..d[1], TeleT, Color3.fromRGB(0,150,255), function()
        LocalPlayer.Character.HumanoidRootPart.CFrame = d[2]
        Notify("Teleported to "..d[1], Color3.fromRGB(0,150,255))
    end)
end
NewButton("TP TO NEAREST PLAYER", TeleT, Color3.fromRGB(255,100,100), function()
    local char = LocalPlayer.Character; if not char then return end
    local hrp = char:FindFirstChild("HumanoidRootPart"); if not hrp then return end
    local nearest, dist = nil, math.huge
    for _, plr in pairs(Players:GetPlayers()) do
        if plr ~= LocalPlayer and plr.Character then
            local oHrp = plr.Character:FindFirstChild("HumanoidRootPart")
            if oHrp then
                local d2 = (oHrp.Position - hrp.Position).Magnitude
                if d2 < dist then nearest = oHrp; dist = d2 end
            end
        end
    end
    if nearest then
        hrp.CFrame = nearest.CFrame + Vector3.new(3,0,0)
        Notify("Teleported to nearest player!", Color3.fromRGB(255,100,100))
    else
        Notify("No players found!", Color3.fromRGB(255,80,80))
    end
end)
NewLabel("-- PLAYER TELEPORT --", TeleT, Color3.fromRGB(0,255,150))
local playerSubFrames = {}
local function BuildPlayerButtons()
    for _, f in pairs(playerSubFrames) do pcall(function() f:Destroy() end) end
    playerSubFrames = {}
    for _, plr in pairs(Players:GetPlayers()) do
        if plr ~= LocalPlayer then
            NewButton(plr.Name, TeleT, Color3.fromRGB(100,200,255), function()
                local existing = playerSubFrames[plr.Name]
                if existing and existing.Parent then
                    existing:Destroy(); playerSubFrames[plr.Name] = nil; return
                end
                for n, f in pairs(playerSubFrames) do
                    pcall(function() f:Destroy() end); playerSubFrames[n] = nil
                end
                local subFrame = Instance.new("Frame", TeleT)
                subFrame.Size = UDim2.new(0.96,0,0,98)
                subFrame.BackgroundColor3 = Color3.fromRGB(18,18,18)
                subFrame.BorderSizePixel = 0
                ApplyStyle(subFrame, Color3.fromRGB(100,200,255))
                playerSubFrames[plr.Name] = subFrame
                local subLayout = Instance.new("UIListLayout", subFrame)
                subLayout.Padding = UDim.new(0,6)
                subLayout.HorizontalAlignment = Enum.HorizontalAlignment.Center
                local pad = Instance.new("UIPadding", subFrame)
                pad.PaddingTop = UDim.new(0,8); pad.PaddingBottom = UDim.new(0,8)
                local tpPlr = Instance.new("TextButton", subFrame)
                tpPlr.Size = UDim2.new(0.92,0,0,36)
                tpPlr.BackgroundColor3 = Color3.fromRGB(0,150,220)
                tpPlr.Text = "TP TO "..plr.Name:upper()
                tpPlr.TextColor3 = Color3.fromRGB(255,255,255)
                tpPlr.Font = "GothamBold"; tpPlr.TextSize = 13
                ApplyStyle(tpPlr, Color3.fromRGB(0,200,255))
                tpPlr.MouseButton1Click:Connect(function()
                    local hrp = LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("HumanoidRootPart")
                    local tgt = plr.Character and plr.Character:FindFirstChild("HumanoidRootPart")
                    if hrp and tgt then
                        hrp.CFrame = tgt.CFrame + Vector3.new(3,0,0)
                        Notify("Teleported to "..plr.Name, Color3.fromRGB(0,200,255))
                    else
                        Notify(plr.Name.." not found!", Color3.fromRGB(255,80,80))
                    end
                end)
                local tpBase = Instance.new("TextButton", subFrame)
                tpBase.Size = UDim2.new(0.92,0,0,36)
                tpBase.BackgroundColor3 = Color3.fromRGB(180,100,0)
                tpBase.Text = "TP TO "..plr.Name:upper().."'S BASE"
                tpBase.TextColor3 = Color3.fromRGB(255,255,255)
                tpBase.Font = "GothamBold"; tpBase.TextSize = 13
                ApplyStyle(tpBase, Color3.fromRGB(255,150,0))
                tpBase.MouseButton1Click:Connect(function()
                    local hrp = LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("HumanoidRootPart")
                    if not hrp then return end
                    local base = nil
                    for _, obj in pairs(workspace:GetDescendants()) do
                        if obj.Name == "Owner" and obj.Value == plr then
                            local plot = obj.Parent
                            local part = plot and (plot.PrimaryPart or plot:FindFirstChildWhichIsA("BasePart"))
                            if part then base = part; break end
                        end
                    end
                    if base then
                        hrp.CFrame = CFrame.new(base.Position + Vector3.new(0,5,0))
                        Notify("Teleported to "..plr.Name.."'s base!", Color3.fromRGB(255,150,0))
                    else
                        local tgt = plr.Character and plr.Character:FindFirstChild("HumanoidRootPart")
                        if tgt then
                            hrp.CFrame = tgt.CFrame + Vector3.new(3,0,0)
                            Notify("Base not found, tp'd to player", Color3.fromRGB(255,150,0))
                        else
                            Notify("Could not find "..plr.Name.."'s base!", Color3.fromRGB(255,80,80))
                        end
                    end
                end)
            end)
        end
    end
end
BuildPlayerButtons()
NewButton("REFRESH PLAYER LIST", TeleT, Color3.fromRGB(60,60,60), function()
    BuildPlayerButtons()
    Notify("Player list refreshed!", Color3.fromRGB(0,255,150))
end)
local autoBuyActive = false
local autoBuyTarget = nil
local function buyViaDialog(npcName, itemName)
    local npc = nil
    for _, obj in pairs(workspace:GetDescendants()) do
        if obj.Name == npcName and obj:IsA("Model") then npc = obj; break end
    end
    if not npc then return false end
    local dialog = npc:FindFirstChildOfClass("Dialog")
    if not dialog then return false end
    for _, choice in pairs(dialog:GetChildren()) do
        if choice:IsA("DialogChoice") and choice.UserDialog:lower():find(itemName:lower()) then
            firedialogchoiceclicked(choice); return true
        end
    end
    return false
end
local buyStatusLabel = NewLabel("No item selected", BuyT, Color3.fromRGB(180,180,180))
local function tryDirectBuy(itemId, remoteType)
    local trans = ReplicatedStorage:FindFirstChild("Transactions")
    if not trans then return false end
    local cts = trans:FindFirstChild("ClientToServer")
    if not cts then return false end
    local rem = cts:FindFirstChild(remoteType)
    if not rem then return false end
    pcall(function() rem:InvokeServer(itemId) end)
    return true
end
local shopItems = {
    {label="Basic Hatchet",   cf=CFrame.new(264,3,57),   id="WoodRUs",   itemId=1,  remote="PurchaseTool", npc="Wood_R_Us_NPC",  dialog="basic"},
    {label="Steel Axe",       cf=CFrame.new(264,3,57),   id="WoodRUs",   itemId=2,  remote="PurchaseTool", npc="Wood_R_Us_NPC",  dialog="steel"},
    {label="Silver Axe",      cf=CFrame.new(264,3,57),   id="WoodRUs",   itemId=3,  remote="PurchaseTool", npc="Wood_R_Us_NPC",  dialog="silver"},
    {label="Rukiryaxe",       cf=CFrame.new(264,3,57),   id="WoodRUs",   itemId=4,  remote="PurchaseTool", npc="Wood_R_Us_NPC",  dialog="rukiryaxe"},
    {label="Sawmill",         cf=CFrame.new(264,3,57),   id="WoodRUs",   itemId=10, remote="PurchaseItem",  npc="Wood_R_Us_NPC",  dialog="sawmill"},
    {label="Plank Conveyor",  cf=CFrame.new(264,3,57),   id="WoodRUs",   itemId=11, remote="PurchaseItem",  npc="Wood_R_Us_NPC",  dialog="conveyor"},
    {label="Small Land",      cf=CFrame.new(111,11,-987), id="LandStore", itemId=1,  remote="PurchaseLand",  npc="Land_Store_NPC", dialog="small"},
    {label="Medium Land",     cf=CFrame.new(111,11,-987), id="LandStore", itemId=2,  remote="PurchaseLand",  npc="Land_Store_NPC", dialog="medium"},
    {label="Large Land",      cf=CFrame.new(111,11,-987), id="LandStore", itemId=3,  remote="PurchaseLand",  npc="Land_Store_NPC", dialog="large"},
}
local autoBuyToggleBtn
autoBuyToggleBtn = NewButton("AUTO BUY: OFF", BuyT, Color3.fromRGB(0,200,100), function(b)
    if not autoBuyTarget then
        Notify("Select an item first!", Color3.fromRGB(255,80,80))
        buyStatusLabel.Text = "Select an item first!"
        buyStatusLabel.TextColor3 = Color3.fromRGB(255,80,80)
        return
    end
    autoBuyActive = not autoBuyActive
    b.Text = autoBuyActive and ("AUTO BUY: ON ["..autoBuyTarget.label.."]") or "AUTO BUY: OFF"
    if autoBuyActive then
        Notify("Auto Buy ON: "..autoBuyTarget.label, Color3.fromRGB(0,255,100))
        buyStatusLabel.TextColor3 = Color3.fromRGB(0,255,100)
        task.spawn(function()
            while autoBuyActive and _G.MasterActive do
                pcall(function()
                    local char = LocalPlayer.Character; if not char then return end
                    local hrp = char:FindFirstChild("HumanoidRootPart"); if not hrp then return end
                    hrp.CFrame = autoBuyTarget.cf
                    task.wait(0.8)
                    local success = buyViaDialog(autoBuyTarget.npc, autoBuyTarget.dialog)
                    if not success then tryDirectBuy(autoBuyTarget.itemId, autoBuyTarget.remote) end
                    buyStatusLabel.Text = "Buying: "..autoBuyTarget.label
                end)
                task.wait(2)
            end
            buyStatusLabel.Text = "Stopped"
            buyStatusLabel.TextColor3 = Color3.fromRGB(180,180,180)
        end)
    else
        Notify("Auto Buy OFF", Color3.fromRGB(255,80,80))
        buyStatusLabel.Text = "Paused: "..autoBuyTarget.label
        buyStatusLabel.TextColor3 = Color3.fromRGB(180,180,180)
    end
end)
NewLabel("-- WOOD R US --", BuyT, Color3.fromRGB(200,150,50))
local _prevLandLabel = false
for _, item in pairs(shopItems) do
    local col = item.id == "LandStore" and Color3.fromRGB(100,180,255) or Color3.fromRGB(255,160,0)
    if item.id == "LandStore" and not _prevLandLabel then
        NewLabel("-- LAND STORE --", BuyT, Color3.fromRGB(100,180,255))
        _prevLandLabel = true
    end
    NewButton("BUY: "..item.label, BuyT, col, function()
        autoBuyTarget = item
        autoBuyActive = false
        autoBuyToggleBtn.Text = "AUTO BUY: OFF"
        buyStatusLabel.Text = "Selected: "..item.label
        buyStatusLabel.TextColor3 = Color3.fromRGB(255,200,0)
        Notify("Selected: "..item.label, Color3.fromRGB(255,200,0))
    end)
end
NewLabel("-- ONE CLICK BUY --", BuyT, Color3.fromRGB(0,255,200))
for _, item in pairs(shopItems) do
    local col = item.id == "LandStore" and Color3.fromRGB(50,120,200) or Color3.fromRGB(180,100,0)
    NewButton("INSTANT: "..item.label, BuyT, col, function()
        local char = LocalPlayer.Character; if not char then return end
        local hrp = char:FindFirstChild("HumanoidRootPart"); if not hrp then return end
        hrp.CFrame = item.cf
        task.wait(0.8)
        local ok2 = buyViaDialog(item.npc, item.dialog)
        if not ok2 then tryDirectBuy(item.itemId, item.remote) end
        Notify("Buying: "..item.label, Color3.fromRGB(0,255,200))
    end)
end
NewButton("FLIP VEHICLE", VehT, Color3.fromRGB(255,150,0), function()
    local char = LocalPlayer.Character; if not char then return end
    local hrp = char:FindFirstChild("HumanoidRootPart"); if not hrp then return end
    local nearest, nearestDist = nil, math.huge
    for _, obj in pairs(workspace:GetDescendants()) do
        if obj:IsA("VehicleSeat") then
            local d = (obj.Position - hrp.Position).Magnitude
            if d < nearestDist then nearest = obj; nearestDist = d end
        end
    end
    if nearest and nearest.Parent then
        nearest.Parent:PivotTo(nearest.Parent:GetPivot() * CFrame.Angles(0,0,math.pi))
        Notify("Vehicle flipped!", Color3.fromRGB(255,150,0))
    end
end)
NewButton("TELEPORT VEHICLE TO ME", VehT, Color3.fromRGB(0,200,255), function()
    local char = LocalPlayer.Character; if not char then return end
    local hrp = char:FindFirstChild("HumanoidRootPart"); if not hrp then return end
    local nearest, nearestDist = nil, math.huge
    for _, obj in pairs(workspace:GetDescendants()) do
        if obj:IsA("VehicleSeat") then
            local d = (obj.Position - hrp.Position).Magnitude
            if d < nearestDist then nearest = obj; nearestDist = d end
        end
    end
    if nearest and nearest.Parent then
        nearest.Parent:PivotTo(CFrame.new(hrp.Position + Vector3.new(5,0,0)))
        Notify("Vehicle teleported!", Color3.fromRGB(0,200,255))
    end
end)
NewButton("EJECT FROM VEHICLE", VehT, Color3.fromRGB(255,50,50), function()
    local char = LocalPlayer.Character; if not char then return end
    local hum = char:FindFirstChild("Humanoid")
    if hum then hum.Sit = false; Notify("Ejected!", Color3.fromRGB(255,50,50)) end
end)
NewButton("SINK ALL VEHICLES", VehT, Color3.fromRGB(100,100,255), function()
    local count = 0
    for _, obj in pairs(workspace:GetDescendants()) do
        if obj:IsA("VehicleSeat") and obj.Parent then
            obj.Parent:PivotTo(CFrame.new(obj.Parent:GetPivot().Position + Vector3.new(0,-50,0)))
            count = count + 1
        end
    end
    Notify("Sank "..count.." vehicles!", Color3.fromRGB(100,100,255))
end)
NewButton("FREEZE NEAREST VEHICLE", VehT, Color3.fromRGB(0,200,255), function()
    local char = LocalPlayer.Character; if not char then return end
    local hrp = char:FindFirstChild("HumanoidRootPart"); if not hrp then return end
    local nearest, nearestDist = nil, math.huge
    for _, obj in pairs(workspace:GetDescendants()) do
        if obj:IsA("VehicleSeat") then
            local d = (obj.Position - hrp.Position).Magnitude
            if d < nearestDist then nearest = obj; nearestDist = d end
        end
    end
    if nearest and nearest.Parent then
        local frozen = false
        for _, p in pairs(nearest.Parent:GetDescendants()) do
            if p:IsA("BasePart") then p.Anchored = not p.Anchored; frozen = p.Anchored end
        end
        Notify(frozen and "Vehicle frozen!" or "Vehicle unfrozen!", Color3.fromRGB(0,200,255))
    end
end)
NewButton("RESPAWN VEHICLE", VehT, Color3.fromRGB(0,255,100), function()
    local char = LocalPlayer.Character; if not char then return end
    local hrp = char:FindFirstChild("HumanoidRootPart"); if not hrp then return end
    local nearest, nearestDist = nil, math.huge
    for _, obj in pairs(workspace:GetDescendants()) do
        if obj:IsA("VehicleSeat") then
            local d = (obj.Position - hrp.Position).Magnitude
            if d < nearestDist then nearest = obj; nearestDist = d end
        end
    end
    if nearest and nearest.Parent then
        nearest.Parent:PivotTo(CFrame.new(hrp.Position + Vector3.new(5,2,0)))
        for _, p in pairs(nearest.Parent:GetDescendants()) do
            if p:IsA("BasePart") then p.Anchored = false end
        end
        Notify("Vehicle respawned!", Color3.fromRGB(0,255,100))
    end
end)
local vehSpeedActive = false
local vehSpeedVal = 100
NewButton("VEHICLE SPEED BOOST: OFF", VehT, Color3.fromRGB(0,255,100), function(b)
    vehSpeedActive = not vehSpeedActive
    b.Text = vehSpeedActive and "VEHICLE SPEED BOOST: ON" or "VEHICLE SPEED BOOST: OFF"
    Notify(vehSpeedActive and "Vehicle Speed: ON" or "Vehicle Speed: OFF", Color3.fromRGB(0,255,100))
    task.spawn(function()
        while vehSpeedActive and _G.MasterActive do
            for _, obj in pairs(workspace:GetDescendants()) do
                if obj:IsA("VehicleSeat") then obj.MaxSpeed = vehSpeedVal; obj.Torque = 500; obj.TurnSpeed = 2 end
            end
            task.wait(0.5)
        end
    end)
end)
NewSlider("VEHICLE SPEED", VehT, 50, 500, 100, function(val) vehSpeedVal = val end)
NewButton("NOCLIP (TOGGLE)", PlayT, Color3.fromRGB(255,255,255), function(b)
    _G.Noclip = not _G.Noclip; b.Text = _G.Noclip and "NOCLIP: ON" or "NOCLIP (TOGGLE)"
    Notify(_G.Noclip and "Noclip: ON" or "Noclip: OFF", Color3.fromRGB(255,255,255))
end)
NewButton("FLY (TOGGLE)", PlayT, Color3.fromRGB(0,255,255), function(b)
    _G.Flying = not _G.Flying; b.Text = _G.Flying and "FLY: ON" or "FLY (TOGGLE)"
    if _G.Flying then StartFly() else StopFly() end
    Notify(_G.Flying and "Fly: ON" or "Fly: OFF", Color3.fromRGB(0,255,255))
end)
NewButton("INF JUMP (TOGGLE)", PlayT, Color3.fromRGB(255,200,0), function(b)
    _G.InfJump = not _G.InfJump; b.Text = _G.InfJump and "INF JUMP: ON" or "INF JUMP (TOGGLE)"
    Notify(_G.InfJump and "Inf Jump: ON" or "Inf Jump: OFF", Color3.fromRGB(255,200,0))
end)
NewButton("FULLBRIGHT (TOGGLE)", PlayT, Color3.fromRGB(255,255,100), function(b)
    _G.FullBright = not _G.FullBright; b.Text = _G.FullBright and "FULLBRIGHT: ON" or "FULLBRIGHT (TOGGLE)"
    Notify(_G.FullBright and "Fullbright: ON" or "Fullbright: OFF", Color3.fromRGB(255,255,100))
end)
NewButton("ANTI AFK (TOGGLE)", PlayT, Color3.fromRGB(0,255,100), function(b)
    _G.AntiAFK = not _G.AntiAFK; b.Text = _G.AntiAFK and "ANTI AFK: ON" or "ANTI AFK (TOGGLE)"
    Notify(_G.AntiAFK and "Anti AFK: ON" or "Anti AFK: OFF", Color3.fromRGB(0,255,100))
end)
NewButton("GOD MODE: OFF", PlayT, Color3.fromRGB(255,215,0), function(b)
    godActive = not godActive; b.Text = godActive and "GOD MODE: ON" or "GOD MODE: OFF"
    Notify(godActive and "God Mode: ON" or "God Mode: OFF", Color3.fromRGB(255,215,0))
    task.spawn(function()
        while godActive and _G.MasterActive do
            pcall(function()
                local char = LocalPlayer.Character; if not char then return end
                local hum = char:FindFirstChild("Humanoid")
                if hum then hum.MaxHealth = math.huge; hum.Health = math.huge end
            end)
            task.wait(0.1)
        end
    end)
end)
NewButton("WALK ON WATER", PlayT, Color3.fromRGB(0,160,255), function()
    loadstring(game:HttpGet("https://pastebin.com/raw/tASirLbL"))()
    Notify("Walk on water loaded!", Color3.fromRGB(0,160,255))
end)
NewButton("RESET CHARACTER", PlayT, Color3.fromRGB(255,80,80), function()
    LocalPlayer.Character:FindFirstChild("Humanoid").Health = 0
end)
NewButton("SIT DOWN", PlayT, Color3.fromRGB(180,100,255), function()
    local char = LocalPlayer.Character; if not char then return end
    local hum = char:FindFirstChild("Humanoid"); if hum then hum.Sit = true end
end)
NewButton("PUNCH (HIT ALL)", PlayT, Color3.fromRGB(255,100,50), function()
    for _, plr in pairs(Players:GetPlayers()) do
        if plr ~= LocalPlayer and plr.Character then
            local hum = plr.Character:FindFirstChild("Humanoid")
            if hum then hum.Health = hum.Health - 10 end
        end
    end
    Notify("Hit all players!", Color3.fromRGB(255,100,50))
end)
NewButton("INVISIBLE", PlayT, Color3.fromRGB(200,200,200), function()
    local char = LocalPlayer.Character; if not char then return end
    for _, p in pairs(char:GetDescendants()) do
        if p:IsA("BasePart") then p.LocalTransparencyModifier = 1 end
    end
    Notify("Invisible!", Color3.fromRGB(200,200,200))
end)
NewButton("VISIBLE AGAIN", PlayT, Color3.fromRGB(100,200,100), function()
    local char = LocalPlayer.Character; if not char then return end
    for _, p in pairs(char:GetDescendants()) do
        if p:IsA("BasePart") then p.LocalTransparencyModifier = 0 end
    end
    Notify("Visible!", Color3.fromRGB(100,200,100))
end)
NewSlider("WALKSPEED", PlayT, 16, 200, 16, function(val) _G.WalkSpeed = val end)
NewSlider("JUMPPOWER", PlayT, 50, 500, 50, function(val) _G.JumpPower = val end)
NewSlider("FLY SPEED", PlayT, 10, 300, 60, function(val) _G.FlySpeed = val end)
NewButton("TOGGLE PLAYER ESP", VisT, Color3.fromRGB(255,200,0), function(b)
    _G.ESPToggled = not _G.ESPToggled; b.Text = _G.ESPToggled and "PLAYER ESP: ON" or "TOGGLE PLAYER ESP"
    Notify(_G.ESPToggled and "Player ESP: ON" or "Player ESP: OFF", Color3.fromRGB(255,200,0))
end)
NewButton("ITEM ESP: OFF", VisT, Color3.fromRGB(0,255,150), function(b)
    itemESPActive = not itemESPActive; b.Text = itemESPActive and "ITEM ESP: ON" or "ITEM ESP: OFF"
    if not itemESPActive then ClearItemESP() end
    Notify(itemESPActive and "Item ESP: ON" or "Item ESP: OFF", Color3.fromRGB(0,255,150))
end)
NewButton("REMOVE FOG", VisT, Color3.fromRGB(200,200,200), function()
    Lighting.FogEnd = 100000; Notify("Fog removed!", Color3.fromRGB(200,200,200))
end)
NewButton("NIGHT MODE", VisT, Color3.fromRGB(50,50,200), function()
    Lighting.ClockTime = 0; Lighting.Brightness = 0.1
    Notify("Night mode!", Color3.fromRGB(50,50,200))
end)
NewButton("RESTORE LIGHTING", VisT, Color3.fromRGB(255,200,100), function()
    Lighting.ClockTime = 14; Lighting.Brightness = 1
    Lighting.FogEnd = 100000; Lighting.GlobalShadows = true
    Lighting.Ambient = Color3.fromRGB(70,70,70)
    Notify("Lighting restored!", Color3.fromRGB(255,200,100))
end)
local autoSellLoop2 = false
NewButton("AUTO SELL: OFF", AutoT, Color3.fromRGB(255,50,50), function(b)
    autoSellLoop2 = not autoSellLoop2
    b.Text = autoSellLoop2 and "AUTO SELL: ON" or "AUTO SELL: OFF"
    Notify(autoSellLoop2 and "Auto Sell: ON" or "Auto Sell: OFF", Color3.fromRGB(255,50,50))
    task.spawn(function()
        while autoSellLoop2 and _G.MasterActive do
            pcall(function() loadstring(game:HttpGet('https://pastebin.com/raw/YZMvDRHB',true))() end)
            task.wait(3)
        end
    end)
end)
local autoRejoinActive = false
local autoRejoinConn = nil
NewButton("AUTO REJOIN ON KICK: OFF", AutoT, Color3.fromRGB(255,100,0), function(b)
    autoRejoinActive = not autoRejoinActive
    b.Text = autoRejoinActive and "AUTO REJOIN: ON" or "AUTO REJOIN ON KICK: OFF"
    Notify(autoRejoinActive and "Auto Rejoin: ON" or "Auto Rejoin: OFF", Color3.fromRGB(255,100,0))
    if autoRejoinActive and not autoRejoinConn then
        autoRejoinConn = LocalPlayer.CharacterRemoving:Connect(function()
            if autoRejoinActive then
                task.wait(3)
                if not LocalPlayer.Character then TeleportService:Teleport(game.PlaceId, LocalPlayer) end
            end
        end)
    elseif not autoRejoinActive and autoRejoinConn then
        autoRejoinConn:Disconnect(); autoRejoinConn = nil
    end
end)
local autoFarmActive = false
local autoFarmWoodType = "Oak"
local farmStatus = NewLabel("Farm: OFF", FarmT, Color3.fromRGB(180,180,180))
NewButton("AUTO FARM: OFF", FarmT, Color3.fromRGB(0,200,100), function(b)
    autoFarmActive = not autoFarmActive
    b.Text = autoFarmActive and "AUTO FARM: ON" or "AUTO FARM: OFF"
    Notify(autoFarmActive and "Auto Farm: ON ("..autoFarmWoodType..")" or "Auto Farm: OFF", Color3.fromRGB(0,200,100))
    if autoFarmActive then
        farmStatus.TextColor3 = Color3.fromRGB(0,255,100)
        task.spawn(function()
            while autoFarmActive and _G.MasterActive do
                pcall(function()
                    local char = LocalPlayer.Character; if not char then return end
                    local hrp = char:FindFirstChild("HumanoidRootPart"); if not hrp then return end
                    local curpos = hrp.CFrame
                    local target = getTreeOfClass(autoFarmWoodType)
                    local ax = nil
                    for _, v in next, LocalPlayer.Backpack:GetChildren() do if v:FindFirstChild("ToolName") then ax = v; break end end
                    if not ax then
                        for _, v in pairs(LocalPlayer.Character:GetChildren()) do if v:FindFirstChild("ToolName") then ax = v; break end end
                    end
                    if target and ax then
                        farmStatus.Text = "Cutting "..autoFarmWoodType.."..."
                        local stats = getAxStats(ax.ToolName.Value, autoFarmWoodType)
                        if not stats then farmStatus.Text = "No axe stats!"; return end
                        local newLog = nil
                        local con = workspace.LogModels.ChildAdded:Connect(function(l)
                            task.wait(); if l:FindFirstChild("Owner") and l.Owner.Value == LocalPlayer then newLog = l end
                        end)
                        local lp = RunService.Heartbeat:Connect(function() hrp.CFrame = target.WoodSection.CFrame + Vector3.new(5,3,0) end)
                        local timeout = 0
                        repeat
                            ReplicatedStorage.Interaction.RemoteProxy:FireServer(target.CutEvent, {tool=ax,height=0.3,faceVector=Vector3.new(1,0,0),sectionId=1,hitPoints=stats.Damage,cooldown=stats.SwingCooldown,cuttingClass="Axe"})
                            task.wait(stats.SwingCooldown); timeout = timeout + stats.SwingCooldown
                        until newLog ~= nil or timeout > 30
                        lp:Disconnect(); con:Disconnect(); task.wait(0.2)
                        if newLog then
                            farmStatus.Text = "Bringing log..."
                            for i=1,60 do ReplicatedStorage.Interaction.ClientIsDragging:FireServer(newLog); newLog:PivotTo(curpos); task.wait() end
                        end
                        hrp.CFrame = curpos
                        farmStatus.Text = "Selling..."
                        pcall(function() loadstring(game:HttpGet('https://pastebin.com/raw/YZMvDRHB',true))() end)
                        task.wait(2)
                        farmStatus.Text = "Farming: "..autoFarmWoodType
                    else
                        farmStatus.Text = "No tree/axe found!"; task.wait(2)
                    end
                end)
            end
            farmStatus.Text = "Farm: OFF"; farmStatus.TextColor3 = Color3.fromRGB(180,180,180)
        end)
    else
        farmStatus.TextColor3 = Color3.fromRGB(180,180,180); farmStatus.Text = "Farm: OFF"
    end
end)
local farmWoodTypes = {"Oak","Birch","Cherry","Walnut","Fir","Pine","Volcano","Frost","GoldSwampy","Koa","Palm","CaveCrawler","GreenSwampy"}
for _, wt in pairs(farmWoodTypes) do
    NewButton("FARM: "..wt:upper(), FarmT, Color3.fromRGB(80,160,80), function()
        autoFarmWoodType = wt; farmStatus.Text = "Target: "..wt
        Notify("Farm target: "..wt, Color3.fromRGB(80,160,80))
    end)
end
for i = 1, 6 do
    local SlotContainer = Instance.new("Frame", SlotT)
    SlotContainer.Size = UDim2.new(0.96,0,0,42)
    SlotContainer.BackgroundTransparency = 1
    local lay = Instance.new("UIListLayout", SlotContainer)
    lay.FillDirection = Enum.FillDirection.Horizontal; lay.Padding = UDim.new(0,4)
    local LoadSlot = NewButton("LOAD "..i, SlotContainer, Color3.fromRGB(0,255,150), function()
        ReplicatedStorage:WaitForChild("LoadSaveRequests"):WaitForChild("RequestLoad"):InvokeServer(i, LocalPlayer)
        Notify("Loaded slot "..i, Color3.fromRGB(0,255,150))
    end)
    LoadSlot.Size = UDim2.new(0.31,0,1,0)
    local SaveSlot = NewButton("SAVE "..i, SlotContainer, Color3.fromRGB(0,150,255), function()
        local target = nil
        for _, plr in pairs(Players:GetPlayers()) do if plr ~= LocalPlayer then target = plr; break end end
        if target then
            ReplicatedStorage:WaitForChild("Transactions"):WaitForChild("ClientToServer"):WaitForChild("Donate"):InvokeServer(target,0,i)
            Notify("Saved slot "..i, Color3.fromRGB(0,150,255))
        else
            Notify("No other players!", Color3.fromRGB(255,80,80))
        end
    end)
    SaveSlot.Size = UDim2.new(0.31,0,1,0)
    local SelSlot = NewButton("SEL "..i, SlotContainer, Color3.fromRGB(150,150,0), function()
        pcall(function() ReplicatedStorage:WaitForChild("LoadSaveRequests"):WaitForChild("RequestLoad"):InvokeServer(i, LocalPlayer) end)
        Notify("Selected slot "..i, Color3.fromRGB(150,150,0))
    end)
    SelSlot.Size = UDim2.new(0.31,0,1,0)
end
NewLabel("-- LAND --", SlotT, Color3.fromRGB(0,200,100))
NewButton("FREE LAND", SlotT, Color3.fromRGB(0,200,100), function()
    LocalPlayer.Character.HumanoidRootPart.CFrame = CFrame.new(111,11,-987)
    task.wait(0.5)
    pcall(function() ReplicatedStorage:FindFirstChild("Transactions").ClientToServer:FindFirstChild("PurchaseLand"):InvokeServer(1) end)
    Notify("Buying free land...", Color3.fromRGB(0,200,100))
end)
NewButton("MAX LAND", SlotT, Color3.fromRGB(255,150,0), function()
    LocalPlayer.Character.HumanoidRootPart.CFrame = CFrame.new(111,11,-987)
    task.wait(0.5)
    pcall(function() ReplicatedStorage:FindFirstChild("Transactions").ClientToServer:FindFirstChild("PurchaseLand"):InvokeServer(3) end)
    Notify("Buying max land...", Color3.fromRGB(255,150,0))
end)
NewButton("SELECT LAND", SlotT, Color3.fromRGB(0,150,255), function()
    LocalPlayer.Character.HumanoidRootPart.CFrame = CFrame.new(111,11,-987)
    Notify("Teleported to Land Store", Color3.fromRGB(0,150,255))
end)
NewButton("GIVE BTOOLS", MiscT, Color3.fromRGB(0,200,255), function()
    for _, toolName in pairs({"Clone","Fill","Resize","Smooth"}) do
        local t = Instance.new("HopperBin"); t.BinType = Enum.BinType[toolName]; t.Parent = LocalPlayer.Backpack
    end
    Notify("Btools given!", Color3.fromRGB(0,200,255))
end)
NewButton("REMOVE FOG", MiscT, Color3.fromRGB(200,200,200), function()
    Lighting.FogEnd = 100000; Notify("Fog removed!", Color3.fromRGB(200,200,200))
end)
NewButton("COPY GAME ID", MiscT, Color3.fromRGB(100,200,255), function()
    setclipboard(tostring(game.PlaceId)); Notify("Game ID copied!", Color3.fromRGB(100,200,255))
end)
NewButton("PRINT ALL REMOTES", MiscT, Color3.fromRGB(200,150,50), function()
    for _, v in pairs(ReplicatedStorage:GetDescendants()) do
        if v:IsA("RemoteEvent") or v:IsA("RemoteFunction") then print(v:GetFullName()) end
    end
    Notify("Remotes printed to console!", Color3.fromRGB(200,150,50))
end)
NewButton("AXE DUPE", DupeT, Color3.fromRGB(255,100,0), function()
    local char = LocalPlayer.Character; if not char then return end
    local hrp = char:FindFirstChild("HumanoidRootPart")
    local hum = char:FindFirstChild("Humanoid")
    if not hrp or not hum then return end
    local hasAxe = false
    for _, v in pairs(LocalPlayer.Backpack:GetChildren()) do if v:FindFirstChild("ToolName") then hasAxe = true; break end end
    if not hasAxe then Notify("No axe found!", Color3.fromRGB(255,80,80)); return end
    hrp.CFrame = CFrame.new(-2097.192139,-408.477966,932.395508)
    Notify("Dupe initiated...", Color3.fromRGB(255,100,0))
    hum.Died:Connect(function() task.wait(0.1); TeleportService:Teleport(game.PlaceId, LocalPlayer) end)
end)
NewButton("RGB OUTLINE: TOGGLE", UiT, Color3.fromRGB(255,0,255), function(b)
    _G.RGBOutline = not _G.RGBOutline; b.Text = _G.RGBOutline and "RGB OUTLINE: ON" or "RGB OUTLINE: TOGGLE"
    Notify(_G.RGBOutline and "RGB: ON" or "RGB: OFF", Color3.fromRGB(255,0,255))
end)
NewButton("ANIMATIONS: ON", UiT, Color3.fromRGB(0,200,255), function(b)
    _G.AnimsEnabled = not _G.AnimsEnabled; b.Text = _G.AnimsEnabled and "ANIMATIONS: ON" or "ANIMATIONS: OFF"
    Notify(_G.AnimsEnabled and "Anims: ON" or "Anims: OFF", Color3.fromRGB(0,200,255))
end)
NewButton("TRANSPARENT BG", UiT, Color3.fromRGB(150,150,150), function(b)
    local isTransp = Main.BackgroundTransparency == 0
    Main.BackgroundTransparency = isTransp and 0.5 or 0
    b.Text = isTransp and "BG: SEMI-TRANSPARENT" or "TRANSPARENT BG"
end)
NewButton("HIDE SIDEBAR", UiT, Color3.fromRGB(100,100,200), function(b)
    Sidebar.Visible = not Sidebar.Visible
    b.Text = Sidebar.Visible and "HIDE SIDEBAR" or "SHOW SIDEBAR"
    Container.Size = Sidebar.Visible and UDim2.new(1,-170,1,-80) or UDim2.new(1,-20,1,-80)
    Container.Position = Sidebar.Visible and UDim2.new(0,160,0,60) or UDim2.new(0,10,0,60)
end)
NewLabel("-- KEYBIND INFO --", UiT, Color3.fromRGB(0,255,0))
NewLabel("RightShift = Toggle Hub", UiT, Color3.fromRGB(150,255,150))
NewLabel("F = Fly  |  N = Noclip", UiT, Color3.fromRGB(150,255,150))
NewLabel("J = Inf Jump  |  B = Bring Wood", UiT, Color3.fromRGB(150,255,150))
NewLabel("-- OUTLINE COLOR --", UiT, Color3.fromRGB(180,180,180))
local Colors = {
    {"Green",  Color3.fromRGB(0,255,0)},
    {"Cyan",   Color3.fromRGB(0,255,255)},
    {"Purple", Color3.fromRGB(180,0,255)},
    {"Red",    Color3.fromRGB(255,0,0)},
    {"White",  Color3.fromRGB(255,255,255)},
    {"Orange", Color3.fromRGB(255,165,0)},
    {"Pink",   Color3.fromRGB(255,105,180)},
    {"Yellow", Color3.fromRGB(255,255,0)},
}
for _, c in pairs(Colors) do
    NewButton("COLOR: "..c[1], UiT, c[2], function()
        CurrentOutlineColor = c[2]
        for _, v in pairs(UI:GetDescendants()) do
            if v:IsA("UIStroke") and v.Name == "MainStroke" then v.Color = CurrentOutlineColor end
        end
        Title.TextColor3 = CurrentOutlineColor
        ShowBtn.TextColor3 = CurrentOutlineColor
        Notify("Color: "..c[1], c[2])
    end)
end
NewSlider("UI SIZE", UiT, 300, 750, 550, function(val)
    Main.Size = UDim2.new(0, val, 0, math.floor(val * 0.69))
end)
HomeT.Visible = true
TabBtns["Home"].BackgroundColor3 = Color3.fromRGB(40,40,40)
TabBtns["Home"]:FindFirstChild("MainStroke").Color = CurrentOutlineColor
Notify("Green Hub V2 Loaded!", Color3.fromRGB(0,255,0))
print("Green Hub V2 by Let7829 - Loaded!")