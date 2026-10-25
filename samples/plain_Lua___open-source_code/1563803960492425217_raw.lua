-- olliE build | Urban Reload V7b (1/10)
local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local UIS = game:GetService("UserInputService")
local CoreGui = game:GetService("CoreGui")
local GuiService = game:GetService("GuiService")
local LP = Players.LocalPlayer
local Cam = workspace.CurrentCamera

local Config = {
    ESP = { Enabled = true, Tracers = true, Skeleton = true, Health = true, Name = true },
    Aimbot = { Enabled = true, LockHead = true, LockBody = false, FOV = 1.309, Smoothness = 2.209, ShowFOV = true, ManualLock = false, PowerAimbot = false, TouchAim = true, AlwaysActive = false },
    Fly = { Enabled = false, MobileControls = false },
    Speed = { InfSpeed = false },
    Camera = { FOV = 70 },
    Menu = { Key = Enum.KeyCode.Insert },
    AimKey = Enum.KeyCode.ButtonL2,
    AimMouseKey = Enum.UserInputType.MouseButton2
}

-- ==== UI CONSTRUCTION (V7b Grey) ====
local ScreenGui = Instance.new("ScreenGui")
ScreenGui.Name = "V7b_Menu"
ScreenGui.ResetOnSpawn = false
ScreenGui.Parent = CoreGui

local MainFrame = Instance.new("Frame")
MainFrame.Size = UDim2.new(0, 380, 0, 680)
MainFrame.Position = UDim2.new(0.5, -190, 0.5, -340)
MainFrame.BackgroundColor3 = Color3.fromRGB(45, 45, 45)
MainFrame.BackgroundTransparency = 0.1
MainFrame.BorderSizePixel = 0
MainFrame.Active = true
MainFrame.Parent = ScreenGui

local TitleBar = Instance.new("Frame")
TitleBar.Size = UDim2.new(1, 0, 0, 25)
TitleBar.BackgroundColor3 = Color3.fromRGB(70, 70, 70)
TitleBar.BorderSizePixel = 0
TitleBar.Parent = MainFrame

local TitleText = Instance.new("TextLabel")
TitleText.Size = UDim2.new(1, -30, 1, 0)
TitleText.Position = UDim2.new(0, 10, 0, 0)
TitleText.BackgroundTransparency = 1
TitleText.Text = "V7b"
TitleText.TextColor3 = Color3.fromRGB(230, 230, 230)
TitleText.TextXAlignment = Enum.TextXAlignment.Left
TitleText.Font = Enum.Font.SourceSans
TitleText.TextSize = 15
TitleText.Parent = TitleBar

local CloseBtn = Instance.new("TextButton")
CloseBtn.Size = UDim2.new(0, 20, 0, 20)
CloseBtn.Position = UDim2.new(1, -25, 0, 2)
CloseBtn.BackgroundTransparency = 1
CloseBtn.Text = "X"
CloseBtn.TextColor3 = Color3.fromRGB(220, 220, 230)
CloseBtn.Font = Enum.Font.SourceSans
CloseBtn.TextSize = 16
CloseBtn.Parent = TitleBar

local Scroll = Instance.new("ScrollingFrame")
Scroll.Size = UDim2.new(1, -10, 1, -35)
Scroll.Position = UDim2.new(0, 5, 0, 30)
Scroll.BackgroundTransparency = 1
Scroll.BorderSizePixel = 0
Scroll.ScrollBarThickness = 4
Scroll.CanvasSize = UDim2.new(0, 0, 0, 0)
Scroll.AutomaticCanvasSize = Enum.AutomaticSize.Y
Scroll.Parent = MainFrame

local ListLayout = Instance.new("UIListLayout")
ListLayout.Padding = UDim.new(0, 4)
ListLayout.SortOrder = Enum.SortOrder.LayoutOrder
ListLayout.Parent = Scroll
-- Helpers (2/10)
local function AddSection(title)
    local btn = Instance.new("TextButton")
    btn.Size = UDim2.new(1, 0, 0, 22)
    btn.BackgroundTransparency = 1
    btn.Text = "► " .. title
    btn.TextColor3 = Color3.fromRGB(255, 255, 255)
    btn.TextXAlignment = Enum.TextXAlignment.Left
    btn.Font = Enum.Font.SourceSans
    btn.TextSize = 14
    btn.Parent = Scroll
end

local function AddCheckbox(text, default, callback)
    local frame = Instance.new("Frame")
    frame.Size = UDim2.new(1, 0, 0, 22)
    frame.BackgroundTransparency = 1
    frame.Parent = Scroll
    local box = Instance.new("TextButton")
    box.Size = UDim2.new(0, 16, 0, 16)
    box.Position = UDim2.new(0, 10, 0.5, -8)
    box.BackgroundColor3 = default and Color3.fromRGB(80, 80, 80) or Color3.fromRGB(35, 35, 35)
    box.BorderSizePixel = 1
    box.BorderColor3 = Color3.fromRGB(100, 100, 100)
    box.Text = default and "✓" or ""
    box.TextColor3 = Color3.fromRGB(255, 255, 255)
    box.Font = Enum.Font.SourceSansBold
    box.TextSize = 12
    box.Parent = frame
    local lbl = Instance.new("TextLabel")
    lbl.Size = UDim2.new(1, -35, 1, 0)
    lbl.Position = UDim2.new(0, 30, 0, 0)
    lbl.BackgroundTransparency = 1
    lbl.Text = text
    lbl.TextColor3 = Color3.fromRGB(200, 200, 210)
    lbl.TextXAlignment = Enum.TextXAlignment.Left
    lbl.Font = Enum.Font.SourceSans
    lbl.TextSize = 14
    lbl.Parent = frame
    local state = default
    box.MouseButton1Click:Connect(function()
        state = not state
        box.BackgroundColor3 = state and Color3.fromRGB(80, 80, 80) or Color3.fromRGB(35, 35, 35)
        box.Text = state and "✓" or ""
        if callback then callback(state) end
    end)
end

local function AddKeybind(text, default, callback)
    local frame = Instance.new("Frame")
    frame.Size = UDim2.new(1, 0, 0, 22)
    frame.BackgroundTransparency = 1
    frame.Parent = Scroll
    local btn = Instance.new("TextButton")
    btn.Size = UDim2.new(0, 100, 1, 0)
    btn.Position = UDim2.new(0, 10, 0, 0)
    btn.BackgroundColor3 = Color3.fromRGB(60, 60, 60)
    btn.BorderSizePixel = 0
    btn.Text = tostring(default):gsub("Enum.KeyCode.", "")
    btn.TextColor3 = Color3.fromRGB(200, 200, 210)
    btn.Font = Enum.Font.SourceSans
    btn.TextSize = 14
    btn.Parent = frame
    local lbl = Instance.new("TextLabel")
    lbl.Size = UDim2.new(1, -120, 1, 0)
    lbl.Position = UDim2.new(0, 120, 0, 0)
    lbl.BackgroundTransparency = 1
    lbl.Text = text
    lbl.TextColor3 = Color3.fromRGB(200, 200, 210)
    lbl.TextXAlignment = Enum.TextXAlignment.Right
    lbl.Font = Enum.Font.SourceSans
    lbl.TextSize = 14
    lbl.Parent = frame
    
    local listening = false
    btn.MouseButton1Click:Connect(function()
        if listening then return end
        listening = true
        btn.Text = "..."
        local conn
        conn = UIS.InputBegan:Connect(function(input, gp)
            if gp then return end
            if input.UserInputType == Enum.UserInputType.Keyboard then
                if input.KeyCode ~= Enum.KeyCode.Unknown then
                    btn.Text = input.KeyCode.Name
                    callback(input.KeyCode)
                    listening = false
                    conn:Disconnect()
                end
            end
        end)
    end)
end
local function AddSlider(valText, sideText, min, max, default, isFloat, callback)
    local frame = Instance.new("Frame")
    frame.Size = UDim2.new(1, 0, 0, 45)
    frame.BackgroundTransparency = 1
    frame.Parent = Scroll
    local valLbl = Instance.new("TextLabel")
    valLbl.Size = UDim2.new(0, 60, 0, 20)
    valLbl.Position = UDim2.new(0, 10, 0, 0)
    valLbl.BackgroundColor3 = Color3.fromRGB(60, 60, 60)
    valLbl.BorderSizePixel = 0
    valLbl.Text = isFloat and string.format("%.3f", default) or tostring(math.floor(default))
    valLbl.TextColor3 = Color3.fromRGB(200, 200, 210)
    valLbl.Font = Enum.Font.SourceSans
    valLbl.TextSize = 14
    valLbl.Parent = frame
    local lbl = Instance.new("TextLabel")
    lbl.Size = UDim2.new(1, -80, 0, 20)
    lbl.Position = UDim2.new(0, 75, 0, 0)
    lbl.BackgroundTransparency = 1
    lbl.Text = sideText
    lbl.TextColor3 = Color3.fromRGB(200, 200, 210)
    lbl.TextXAlignment = Enum.TextXAlignment.Right
    lbl.Font = Enum.Font.SourceSans
    lbl.TextSize = 14
    lbl.Parent = frame
    local track = Instance.new("Frame")
    track.Size = UDim2.new(1, -20, 0, 6)
    track.Position = UDim2.new(0, 10, 0, 28)
    track.BackgroundColor3 = Color3.fromRGB(60, 60, 60)
    track.BorderSizePixel = 0
    track.Parent = frame
    local fill = Instance.new("Frame")
    fill.Size = UDim2.new((default - min) / (max - min), 0, 1, 0)
    fill.BackgroundColor3 = Color3.fromRGB(120, 120, 120)
    fill.BorderSizePixel = 0
    fill.Parent = track
    local dragging = false
    local function update(input)
        local pct = math.clamp((input.Position.X - track.AbsolutePosition.X) / track.AbsoluteSize.X, 0, 1)
        local val = min + (max - min) * pct
        fill.Size = UDim2.new(pct, 0, 1, 0)
        if isFloat then
            valLbl.Text = string.format("%.3f", val)
            if callback then callback(val) end
        else
            valLbl.Text = tostring(math.floor(val))
            if callback then callback(math.floor(val)) end
        end
    end
    track.InputBegan:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then dragging = true; update(input) end
    end)
    UIS.InputChanged:Connect(function(input)
        if dragging and (input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch) then update(input) end
    end)
    UIS.InputEnded:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then dragging = false end
    end)
end

-- Build Menu
AddSection("ESP")
AddCheckbox("Enable ESP", Config.ESP.Enabled, function(v) Config.ESP.Enabled = v end)
AddCheckbox("Show Tracers", Config.ESP.Tracers, function(v) Config.ESP.Tracers = v end)
AddCheckbox("Show Skeleton", Config.ESP.Skeleton, function(v) Config.ESP.Skeleton = v end)
AddCheckbox("Show health", Config.ESP.Health, function(v) Config.ESP.Health = v end)
AddCheckbox("Show name", Config.ESP.Name, function(v) Config.ESP.Name = v end)

AddSection("Aimbot")
AddCheckbox("Enable aimbot", Config.Aimbot.Enabled, function(v) Config.Aimbot.Enabled = v end)
AddCheckbox("Lock Head", Config.Aimbot.LockHead, function(v) Config.Aimbot.LockHead = v; Config.Aimbot.LockBody = not v end)
AddCheckbox("Lock Body", Config.Aimbot.LockBody, function(v) Config.Aimbot.LockBody = v; Config.Aimbot.LockHead = not v end)
AddCheckbox("Always Active (No Key)", Config.Aimbot.AlwaysActive, function(v) Config.Aimbot.AlwaysActive = v end)
AddCheckbox("Power Aimbot (Max)", Config.Aimbot.PowerAimbot, function(v) Config.Aimbot.PowerAimbot = v end)
AddCheckbox("Touch Screen Aim", Config.Aimbot.TouchAim, function(v) Config.Aimbot.TouchAim = v end)
AddSlider("1.309", "Aim FOV", 0.1, 10, Config.Aimbot.FOV, true, function(v) Config.Aimbot.FOV = v end)
AddSlider("2.209", "Aim smoothness", 0.1, 10, Config.Aimbot.Smoothness, true, function(v) Config.Aimbot.Smoothness = v end)
AddCheckbox("Show FOV range", Config.Aimbot.ShowFOV, function(v) Config.Aimbot.ShowFOV = v end)

AddSection("Camera")
AddSlider("70", "Camera FOV", 50, 120, Config.Camera.FOV, false, function(v) Config.Camera.FOV = v end)

AddSection("Vehicle")
AddCheckbox("Enable Vehicle Fly (Max 22)", Config.Fly.Enabled, function(v) Config.Fly.Enabled = v end)
AddCheckbox("Show Mobile Fly Controls", Config.Fly.MobileControls, function(v) Config.Fly.MobileControls = v end)
AddCheckbox("Manual Lock (In Vehicle)", Config.Aimbot.ManualLock, function(v) Config.Aimbot.ManualLock = v end)

AddSection("Misc")
AddCheckbox("Inf Speed (27)", Config.Speed.InfSpeed, function(v) Config.Speed.InfSpeed = v end)

AddSection("Info")
AddKeybind("Key for opening / closing menu", Config.Menu.Key, function(v) Config.Menu.Key = v end)
local MobileFrame = Instance.new("Frame")
MobileFrame.Size = UDim2.new(0, 150, 0, 150)
MobileFrame.Position = UDim2.new(1, -170, 1, -170)
MobileFrame.BackgroundTransparency = 1
MobileFrame.Visible = false
MobileFrame.Parent = ScreenGui

local mobileInputs = { Fwd = false, Bwd = false, Lft = false, Rgt = false, Up = false, Dwn = false }

local function CreateMobileBtn(txt, pos, inputKey)
    local btn = Instance.new("TextButton")
    btn.Size = UDim2.new(0, 45, 0, 45)
    btn.Position = pos
    btn.BackgroundColor3 = Color3.fromRGB(60, 60, 60)
    btn.BackgroundTransparency = 0.3
    btn.BorderSizePixel = 0
    btn.Text = txt
    btn.TextColor3 = Color3.fromRGB(255, 255, 255)
    btn.Font = Enum.Font.SourceSansBold
    btn.TextSize = 18
    btn.Parent = MobileFrame
    local c = Instance.new("UICorner", btn)
    c.CornerRadius = UDim.new(0, 8)
    
    btn.InputBegan:Connect(function(i) 
        if i.UserInputType == Enum.UserInputType.Touch or i.UserInputType == Enum.UserInputType.MouseButton1 then 
            mobileInputs[inputKey] = true 
        end 
    end)
    btn.InputEnded:Connect(function(i) 
        if i.UserInputType == Enum.UserInputType.Touch or i.UserInputType == Enum.UserInputType.MouseButton1 then 
            mobileInputs[inputKey] = false 
        end 
    end)
end

CreateMobileBtn("↑", UDim2.new(0.5, -22.5, 0, 0), "Fwd")
CreateMobileBtn("↓", UDim2.new(0.5, -22.5, 1, -45), "Bwd")
CreateMobileBtn("←", UDim2.new(0, 0, 0.5, -22.5), "Lft")
CreateMobileBtn("→", UDim2.new(1, -45, 0.5, -22.5), "Rgt")
CreateMobileBtn("MONTER", UDim2.new(1, 5, 0, 0), "Up")
CreateMobileBtn("BAISSER", UDim2.new(1, 5, 1, -45), "Dwn")

local FloatIcon = Instance.new("ImageButton")
FloatIcon.Size = UDim2.new(0, 50, 0, 50)
FloatIcon.Position = UDim2.new(0, 20, 0, 20)
FloatIcon.BackgroundColor3 = Color3.fromRGB(60, 60, 60)
FloatIcon.Image = "rbxassetid://82183432871878"
FloatIcon.Visible = false
FloatIcon.Parent = ScreenGui
local UIC = Instance.new("UICorner")
UIC.CornerRadius = UDim.new(0, 10)
UIC.Parent = FloatIcon

local draggingFloat, dragFloatInput, dragFloatStart, startFloatPos, floatDragMoved
FloatIcon.InputBegan:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
        draggingFloat = true
        floatDragMoved = false
        dragFloatStart = input.Position
        startFloatPos = FloatIcon.Position
        input.Changed:Connect(function()
            if input.UserInputState == Enum.UserInputState.End then draggingFloat = false end
        end)
    end
end)
UIS.InputChanged:Connect(function(input)
    if draggingFloat and (input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch) then
        local delta = input.Position - dragFloatStart
        if delta.Magnitude > 5 then floatDragMoved = true end
        FloatIcon.Position = UDim2.new(startFloatPos.X.Scale, startFloatPos.X.Offset + delta.X, startFloatPos.Y.Scale, startFloatPos.Y.Offset + delta.Y)
    end
end)
FloatIcon.MouseButton1Click:Connect(function()
    if not floatDragMoved then
        MainFrame.Visible = true
        FloatIcon.Visible = false
    end
end)

CloseBtn.MouseButton1Click:Connect(function()
    MainFrame.Visible = false
    FloatIcon.Visible = true
end)

local dragging, dragInput, dragStart, startPos
TitleBar.InputBegan:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
        dragging = true
        dragStart = input.Position
        startPos = MainFrame.Position
        input.Changed:Connect(function()
            if input.UserInputState == Enum.UserInputState.End then dragging = false end
        end)
    end
end)
UIS.InputChanged:Connect(function(input)
    if dragging and (input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch) then
        local delta = input.Position - dragStart
        MainFrame.Position = UDim2.new(startPos.X.Scale, startPos.X.Offset + delta.X, startPos.Y.Scale, startPos.Y.Offset + delta.Y)
    end
end)

UIS.InputBegan:Connect(function(input, gp)
    if gp then return end
    if input.KeyCode == Config.Menu.Key then
        MainFrame.Visible = not MainFrame.Visible
        FloatIcon.Visible = not MainFrame.Visible
    end
end)
local FOVCircle = Drawing.new("Circle")
FOVCircle.Thickness = 1
FOVCircle.NumSides = 60
FOVCircle.Radius = 150
FOVCircle.Filled = false
FOVCircle.Visible = false

local ESPStore = {}
local function CreateESP(plr)
    if plr == LP then return end
    local store = { Tracer = Drawing.new("Line"), Name = Drawing.new("Text"), Health = Drawing.new("Line"), Skel = {} }
    for i=1, 15 do store.Skel[i] = Drawing.new("Line") end
    ESPStore[plr] = store
end
Players.PlayerAdded:Connect(CreateESP)
Players.PlayerRemoving:Connect(function(plr)
    if ESPStore[plr] then
        ESPStore[plr].Tracer:Remove(); ESPStore[plr].Name:Remove(); ESPStore[plr].Health:Remove()
        for _, l in ipairs(ESPStore[plr].Skel) do l:Remove() end
        ESPStore[plr] = nil
    end
end)
for _, p in ipairs(Players:GetPlayers()) do CreateESP(p) end

local activeBVs = {}
local activeBGs = {}

local function ClearVehicleFly()
    for _, bv in pairs(activeBVs) do if bv and bv.Parent then bv:Destroy() end end
    for _, bg in pairs(activeBGs) do if bg and bg.Parent then bg:Destroy() end end
    table.clear(activeBVs)
    table.clear(activeBGs)
end
RunService.RenderStepped:Connect(function()
    if Cam.FieldOfView ~= Config.Camera.FOV then
        Cam.FieldOfView = Config.Camera.FOV
    end

    local char = LP.Character
    local hum = char and char:FindFirstChildOfClass("Humanoid")
    if hum then
        if Config.Speed.InfSpeed then
            if hum.WalkSpeed ~= 27 then hum.WalkSpeed = 27 end
        else
            if hum.WalkSpeed == 27 then hum.WalkSpeed = 16 end
        end
    end

    MobileFrame.Visible = Config.Fly.Enabled and Config.Fly.MobileControls

    local rainbowCol = Color3.fromHSV(tick() % 1, 1, 1)
    for plr, store in pairs(ESPStore) do
        local pchar = plr.Character
        local phum = pchar and pchar:FindFirstChildOfClass("Humanoid")
        if Config.ESP.Enabled and pchar and phum and phum.Health > 0 then
            local head, root = pchar:FindFirstChild("Head"), pchar:FindFirstChild("HumanoidRootPart") or pchar:FindFirstChild("Torso")
            if head and root then
                local headPos, onScreen = Cam:WorldToViewportPoint(head.Position)
                local rootPos = Cam:WorldToViewportPoint(root.Position)
                if onScreen then
                    if Config.ESP.Tracers then
                        store.Tracer.From = Vector2.new(Cam.ViewportSize.X/2, Cam.ViewportSize.Y)
                        store.Tracer.To = Vector2.new(headPos.X, headPos.Y)
                        store.Tracer.Color = rainbowCol
                        store.Tracer.Thickness = 1
                        store.Tracer.Visible = true
                    else store.Tracer.Visible = false end
                    if Config.ESP.Name then
                        store.Name.Text, store.Name.Position = plr.Name, Vector2.new(headPos.X, headPos.Y - 20)
                        store.Name.Size, store.Name.Center, store.Name.Outline = 14, true, true
                        store.Name.Color, store.Name.Visible = Color3.new(1,1,1), true
                    else store.Name.Visible = false end
                    if Config.ESP.Health then
                        store.Health.From = Vector2.new(headPos.X - 30, rootPos.Y)
                        store.Health.To = Vector2.new(headPos.X - 30, headPos.Y)
                        store.Health.Color = Color3.fromRGB(0, 255, 0):Lerp(Color3.fromRGB(255, 0, 0), 1 - (phum.Health/phum.MaxHealth))
                        store.Health.Thickness, store.Health.Visible = 2, true
                    else store.Health.Visible = false end
                    if Config.ESP.Skeleton then
                        local function getPart(n) return pchar:FindFirstChild(n) end
                        local lines = {
                            {getPart("Head"), getPart("Torso")}, {getPart("Head"), getPart("UpperTorso")},
                            {getPart("Torso"), getPart("Left Arm")}, {getPart("Torso"), getPart("Right Arm")}, {getPart("Torso"), getPart("Left Leg")}, {getPart("Torso"), getPart("Right Leg")},
                            {getPart("UpperTorso"), getPart("LowerTorso")}, {getPart("UpperTorso"), getPart("LeftUpperArm")}, {getPart("UpperTorso"), getPart("RightUpperArm")},
                            {getPart("LeftUpperArm"), getPart("LeftLowerArm")}, {getPart("RightUpperArm"), getPart("RightLowerArm")},
                            {getPart("LowerTorso"), getPart("LeftUpperLeg")}, {getPart("LowerTorso"), getPart("RightUpperLeg")},
                            {getPart("LeftUpperLeg"), getPart("LeftLowerLeg")}, {getPart("RightUpperLeg"), getPart("RightLowerLeg")}
                        }
                        for _, l in ipairs(store.Skel) do l.Visible = false end
                        local idx = 1
                        for _, pair in ipairs(lines) do
                            if pair[1] and pair[2] and idx <= #store.Skel then
                                local s1, on1 = Cam:WorldToViewportPoint(pair[1].Position)
                                local s2, on2 = Cam:WorldToViewportPoint(pair[2].Position)
                                if on1 and on2 then
                                    local line = store.Skel[idx]
                                    line.From, line.To = Vector2.new(s1.X, s1.Y), Vector2.new(s2.X, s2.Y)
                                    line.Color, line.Thickness, line.Visible = rainbowCol, 1, true
                                    idx = idx + 1
                                end
                            end
                        end
                    else for _, l in ipairs(store.Skel) do l.Visible = false end end
                else
                    store.Tracer.Visible, store.Name.Visible, store.Health.Visible = false, false, false
                    for _, l in ipairs(store.Skel) do l.Visible = false end
                end
            end
        else
            store.Tracer.Visible, store.Name.Visible, store.Health.Visible = false, false, false
            for _, l in ipairs(store.Skel) do l.Visible = false end
        end
    end
    
    if Config.Aimbot.ShowFOV and Config.Aimbot.Enabled then
        FOVCircle.Visible = true
        FOVCircle.Position = Vector2.new(Cam.ViewportSize.X/2, Cam.ViewportSize.Y/2)
        FOVCircle.Radius = Config.Aimbot.FOV * 100
        FOVCircle.Color = rainbowCol
    else FOVCircle.Visible = false end
        local seat = hum and hum.SeatPart
    if Config.Fly.Enabled and seat then
        local vehicle = seat.Parent
        local dir = Vector3.zero
        if UIS:IsKeyDown(Enum.KeyCode.W) or mobileInputs.Fwd then dir += Cam.CFrame.LookVector end
        if UIS:IsKeyDown(Enum.KeyCode.S) or mobileInputs.Bwd then dir -= Cam.CFrame.LookVector end
        if UIS:IsKeyDown(Enum.KeyCode.A) or mobileInputs.Lft then dir -= Cam.CFrame.RightVector end
        if UIS:IsKeyDown(Enum.KeyCode.D) or mobileInputs.Rgt then dir += Cam.CFrame.RightVector end
        if UIS:IsKeyDown(Enum.KeyCode.Space) or mobileInputs.Up then dir += Vector3.yAxis end
        if UIS:IsKeyDown(Enum.KeyCode.LeftControl) or mobileInputs.Dwn then dir -= Vector3.yAxis end
        
        local gp = UIS:GetGamepadState(Enum.UserInputType.Gamepad1)
        for _, btn in ipairs(gp) do
            if btn.KeyCode == Enum.KeyCode.Thumbstick1 then
                if btn.Position.Y > 0.1 then dir += Cam.CFrame.LookVector * btn.Position.Y end
                if btn.Position.Y < -0.1 then dir -= Cam.CFrame.LookVector * math.abs(btn.Position.Y) end
                if btn.Position.X > 0.1 then dir += Cam.CFrame.RightVector * btn.Position.X end
                if btn.Position.X < -0.1 then dir -= Cam.CFrame.RightVector * math.abs(btn.Position.X) end
            end
            if btn.KeyCode == Enum.KeyCode.ButtonL2 then dir -= Vector3.yAxis end
            if btn.KeyCode == Enum.KeyCode.ButtonR2 then dir += Vector3.yAxis end
        end
        
        local targetVel = dir.Magnitude > 0 and (dir.Unit * 22) or Vector3.zero
        
        if #activeBVs == 0 then
            for _, v in ipairs(vehicle:GetDescendants()) do
                if v:IsA("BasePart") and not v.Anchored then
                    local bv = Instance.new("BodyVelocity")
                    bv.MaxForce = Vector3.new(1e6, 1e6, 1e6)
                    bv.Parent = v
                    table.insert(activeBVs, bv)
                    
                    local bg = Instance.new("BodyGyro")
                    bg.MaxTorque = Vector3.new(1e6, 1e6, 1e6)
                    bg.P = 3000
                    bg.Parent = v
                    table.insert(activeBGs, bg)
                end
            end
        end
        
        for _, bv in ipairs(activeBVs) do
            if bv.Parent then bv.Velocity = targetVel end
        end
        for _, bg in ipairs(activeBGs) do
            if bg.Parent then bg.CFrame = Cam.CFrame end
        end
        
    else
        if #activeBVs > 0 then ClearVehicleFly() end
    end
end)
RunService:BindToRenderStep("AimbotLock", Enum.RenderPriority.Camera.Value + 1, function()
    local char = LP.Character
    local hum = char and char:FindFirstChildOfClass("Humanoid")
    local inVehicle = hum and hum.SeatPart ~= nil
    
    local isAiming = Config.Aimbot.AlwaysActive
    
    if not isAiming then
        isAiming = UIS:IsMouseButtonPressed(Enum.UserInputType.MouseButton2) 
            or UIS:IsGamepadButtonDown(Enum.UserInputType.Gamepad1, Enum.KeyCode.ButtonL2)
            or (Config.Aimbot.TouchAim and UIS.TouchEnabled and #UIS:GetTouches() > 0)
    end
    
    if inVehicle and Config.Aimbot.ManualLock then
        isAiming = true
    end

    if Config.Aimbot.Enabled and isAiming then
        local center = Vector2.new(Cam.ViewportSize.X/2, Cam.ViewportSize.Y/2)
        local closest, bestDist = nil, math.huge
        local fovRadius = Config.Aimbot.FOV * 100
        
        for _, plr in ipairs(Players:GetPlayers()) do
            if plr ~= LP and plr.Character and plr.Character:FindFirstChildOfClass("Humanoid") then
                local targetHum = plr.Character.Humanoid
                if targetHum.Health > 0 then
                    
                    local targetPart = nil
                    if Config.Aimbot.LockHead then
                        targetPart = plr.Character:FindFirstChild("Head")
                    else
                        targetPart = plr.Character:FindFirstChild("UpperTorso") or plr.Character:FindFirstChild("HumanoidRootPart") or plr.Character:FindFirstChild("Torso")
                    end
                    
                    if targetPart then
                        local sp, onScreen = Cam:WorldToViewportPoint(targetPart.Position)
                        if onScreen then
                            local dist = (Vector2.new(sp.X, sp.Y) - center).Magnitude
                            
                            local ignoreList = {LP.Character, plr.Character}
                            if hum and hum.SeatPart and hum.SeatPart.Parent then
                                table.insert(ignoreList, hum.SeatPart.Parent)
                            end
                            
                            local rayParams = RaycastParams.new()
                            rayParams.FilterDescendantsInstances = ignoreList
                            rayParams.FilterType = Enum.RaycastFilterType.Exclude
                            local ray = workspace:Raycast(Cam.CFrame.Position, (targetPart.Position - Cam.CFrame.Position), rayParams)
                            
                            if not ray and dist < fovRadius and dist < bestDist then
                                bestDist = dist
                                closest = targetPart
                            end
                        end
                    end
                end
            end
        end
        if closest then
            local lookAt = CFrame.lookAt(Cam.CFrame.Position, closest.Position)
            local alpha = Config.Aimbot.PowerAimbot and 1 or (1 / math.max(Config.Aimbot.Smoothness, 0.1))
            Cam.CFrame = Cam.CFrame:Lerp(lookAt, math.clamp(alpha, 0.05, 1))
        end
    end
end)

GuiService.SelectedObject = CloseBtn
-- Partie 9/10 : Préparation du script
local scriptSource = [[
-- COLLE LES PARTIES 1 À 8 ICI DANS L'ORDRE EXACT
]]
-- Partie 10/10 : Exécution finale
local Success, Error = pcall(function()
    local func = loadstring(scriptSource)
    if func then
        func()
    else
        warn("Erreur de compilation dans le script.")
    end
end)

if not Success then
    warn("Erreur d'exécution : " .. tostring(Error))
end
