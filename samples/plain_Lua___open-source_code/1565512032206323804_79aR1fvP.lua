-- GRANNY ULTIMATE + YOUR SPIDER HUB | CHEATS BUTTON FIXED
repeat task.wait() until game:IsLoaded() and workspace:FindFirstChild("Map")
local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local UserInputService = game:GetService("UserInputService")
local TweenService = game:GetService("TweenService")
local Lighting = game:GetService("Lighting")
local player = Players.LocalPlayer
local playerGui = player:WaitForChild("PlayerGui")
local camera = workspace.CurrentCamera

-- Wait for Tools Folder
local ToolsFolder = nil
repeat
    task.wait(0.5)
    for _, map in pairs(workspace.Map:GetChildren()) do
        if map:FindFirstChild("Tools") then
            ToolsFolder = map.Tools
            print("MAP LOADED:", map.Name)
            break
        end
    end
until ToolsFolder

-- MAIN GUI
local sg = Instance.new("ScreenGui")
sg.Name = "GrannyUltimatePro"
sg.ResetOnSpawn = false
sg.Parent = game.CoreGui

local frame = Instance.new("Frame", sg)
frame.Size = UDim2.new(0, 420, 0, 520)
frame.Position = UDim2.new(0.02, 0, 0.12, 0)
frame.BackgroundColor3 = Color3.fromRGB(28, 28, 38)
frame.Active = true
frame.Draggable = true
local fc = Instance.new("UICorner", frame)
fc.CornerRadius = UDim.new(0, 14)

local title = Instance.new("TextLabel", frame)
title.Size = UDim2.new(1, 0, 0, 50)
title.BackgroundTransparency = 1
title.Text = "GRANNY - Spider HUB"
title.TextColor3 = Color3.fromRGB(0, 255, 150)
title.Font = Enum.Font.GothamBold
title.TextSize = 20

-- BUTTONS
local function makeBtn(name, posY, color, callback)
    local btn = Instance.new("TextButton", frame)
    btn.Position = UDim2.new(0, 15, 0, posY)
    btn.Size = UDim2.new(0, 185, 0, 45)
    btn.BackgroundColor3 = color
    btn.Text = name
    btn.TextColor3 = Color3.new(1,1,1)
    btn.Font = Enum.Font.GothamBold
    local c = Instance.new("UICorner", btn)
    c.CornerRadius = UDim.new(0, 10)
    btn.MouseButton1Click:Connect(callback)
    return btn
end

local espBtn = makeBtn("ESP: ON", 60, Color3.fromRGB(0, 200, 100), function() end)
local cheatsBtn = makeBtn("CHEATS", 60, Color3.fromRGB(255, 100, 0), function() end)

-- Scroll List
local scroll = Instance.new("ScrollingFrame", frame)
scroll.Position = UDim2.new(0, 15, 0, 115)
scroll.Size = UDim2.new(1, -30, 1, -185)
scroll.BackgroundTransparency = 1
scroll.ScrollBarThickness = 6

local list = Instance.new("UIListLayout", scroll)
list.Padding = UDim.new(0, 8)

-- TP Button
local tpBtn = Instance.new("TextButton", frame)
tpBtn.Position = UDim2.new(0, 15, 1, -65)
tpBtn.Size = UDim2.new(1, -30, 0, 50)
tpBtn.BackgroundColor3 = Color3.fromRGB(200, 50, 50)
tpBtn.Text = "SELECT → TP"
tpBtn.TextColor3 = Color3.new(1,1,1)
local tc = Instance.new("UICorner", tpBtn)
tc.CornerRadius = UDim.new(0, 12)

-- VARS
local selectedPart = nil
local espBoxes = {}
local espLabels = {}
local buttons = {}
local espOn = true

-- SCAN
local function scan()
    local count = 0
    local seen = {}
    for _, btn in pairs(buttons) do btn:Destroy() end
    buttons = {}
    for obj, box in pairs(espBoxes) do pcall(function() box:Remove() end) end
    for obj, label in pairs(espLabels) do pcall(function() label:Remove() end) end
    espBoxes, espLabels = {}, {}

    for _, obj in pairs(ToolsFolder:GetDescendants()) do
        if (obj:IsA("BasePart") or obj.Name == "Handle") and not seen[obj] then
            seen[obj] = true
            local root = obj.Parent
            if not root then continue end
            count = count + 1

            local btn = Instance.new("TextButton")
            btn.Parent = scroll
            btn.Size = UDim2.new(1, 0, 0, 40)
            btn.BackgroundColor3 = Color3.fromRGB(60, 120, 220)
            btn.Text = root.Name
            btn.TextColor3 = Color3.new(1,1,1)
            btn.Font = Enum.Font.GothamBold
            local c = Instance.new("UICorner", btn)
            c.CornerRadius = UDim.new(0, 10)
            btn.MouseButton1Click:Connect(function()
                selectedPart = obj
                tpBtn.Text = "TP → " .. root.Name
                tpBtn.BackgroundColor3 = Color3.fromRGB(0, 255, 0)
            end)
            table.insert(buttons, btn)

            local box = Drawing.new("Square")
            box.Filled = false
            box.Thickness = 2.5
            box.Color = Color3.new(1,1,1)
            box.Transparency = 0.9
            espBoxes[root] = box

            local label = Drawing.new("Text")
            label.Text = root.Name
            label.Size = 14
            label.Color = Color3.new(1,1,1)
            label.Center = true
            label.Outline = true
            espLabels[root] = label
        end
    end

    scroll.CanvasSize = UDim2.new(0, 0, 0, list.AbsoluteContentSize.Y + 10)
    title.Text = "GRANNY - Spider HUB [" .. count .. "]"
end

-- TP
tpBtn.MouseButton1Click:Connect(function()
    if selectedPart and player.Character and player.Character:FindFirstChild("HumanoidRootPart") then
        player.Character.HumanoidRootPart.CFrame = selectedPart.CFrame + Vector3.new(0, 4, 0)
    end
end)

-- ESP
espBtn.MouseButton1Click:Connect(function()
    espOn = not espOn
    espBtn.Text = espOn and "ESP: ON" or "ESP: OFF"
    espBtn.BackgroundColor3 = espOn and Color3.fromRGB(0,200,100) or Color3.fromRGB(200,50,50)
end)

RunService.RenderStepped:Connect(function()
    if not espOn then return end
    for root, box in pairs(espBoxes) do
        local part = root:FindFirstChildWhichIsA("BasePart") or root
        if part and part.Parent then
            local pos, onScreen = camera:WorldToViewportPoint(part.Position)
            if onScreen then
                local headY = camera:WorldToViewportPoint(part.Position + Vector3.new(0,3,0)).Y
                local size = math.abs(headY - pos.Y) * 0.7
                local corner = math.max(28, size * 0.35)
                box.Size = Vector2.new(corner, corner)
                box.Position = Vector2.new(pos.X - corner/2, pos.Y - corner/2)
                box.Visible = true
                espLabels[root].Position = Vector2.new(pos.X, pos.Y - 28)
                espLabels[root].Visible = true
            else
                box.Visible = false
                espLabels[root].Visible = false
            end
        end
    end
end)

-- === YOUR EXACT SPIDER HUB SCRIPT (FIXED & WORKING) ===
local function executeYourCheatsGUI()
    if playerGui:FindFirstChild("SpiderHUB") then return end

    -- Wait for character
    local character = player.Character or player.CharacterAdded:Wait()
    local humanoid = character:WaitForChild("Humanoid")
    local hrp = character:WaitForChild("HumanoidRootPart")

    -- Your full script starts here (100% unchanged)
    local function executeCheatsGUI()
        if playerGui:FindFirstChild("SpiderHUB") then return end

        character = player.Character or player.CharacterAdded:Wait()
        humanoid = character:WaitForChild("Humanoid")
        hrp = character:WaitForChild("HumanoidRootPart")

        local screenGui = Instance.new("ScreenGui")
        screenGui.Name = "SpiderHUB"
        screenGui.ResetOnSpawn = false
        screenGui.Parent = playerGui

        local mainFrame = Instance.new("Frame")
        mainFrame.Size = UDim2.new(0, 360, 0, 500)
        mainFrame.Position = UDim2.new(0, 20, 0.5, -250)
        mainFrame.BackgroundColor3 = Color3.fromRGB(20, 20, 20)
        mainFrame.Active = true
        mainFrame.Draggable = true
        mainFrame.Parent = screenGui

        local title = Instance.new("TextLabel")
        title.Size = UDim2.new(1, 0, 0, 50)
        title.BackgroundTransparency = 1
        title.Text = "Spider HUB"
        title.TextColor3 = Color3.fromRGB(255, 255, 255)
        title.Font = Enum.Font.GothamBold
        title.TextSize = 24
        title.Parent = mainFrame

        local scroll = Instance.new("ScrollingFrame")
        scroll.Size = UDim2.new(1, -20, 1, -70)
        scroll.Position = UDim2.new(0, 10, 0, 60)
        scroll.BackgroundTransparency = 1
        scroll.ScrollBarThickness = 5
        scroll.Parent = mainFrame

        local layout = Instance.new("UIListLayout")
        layout.Padding = UDim.new(0, 8)
        layout.Parent = scroll

        local function round(obj, r)
            local c = Instance.new("UICorner")
            c.CornerRadius = UDim.new(0, r)
            c.Parent = obj
        end
        local function stroke(obj, t, col)
            local s = Instance.new("UIStroke")
            s.Thickness = t
            s.Color = col
            s.Parent = obj
        end

        round(mainFrame, 12)
        stroke(mainFrame, 2, Color3.fromRGB(60, 60, 60))

        local buttons = {}
        local function btn(name, text, order, callback)
            local b = Instance.new("TextButton")
            b.Name = name
            b.Size = UDim2.new(1, -10, 0, 40)
            b.BackgroundColor3 = Color3.fromRGB(45, 45, 45)
            b.Text = text
            b.TextColor3 = Color3.fromRGB(255, 255, 255)
            b.Font = Enum.Font.GothamBold
            b.TextSize = 16
            b.LayoutOrder = order
            b.Parent = scroll
            round(b, 8)
            stroke(b, 1, Color3.fromRGB(80, 80, 80))

            b.MouseEnter:Connect(function()
                if not string.find(b.Text, "%[ON%]") then
                    TweenService:Create(b, TweenInfo.new(0.2), {BackgroundColor3 = Color3.fromRGB(60, 60, 60)}):Play()
                end
            end)
            b.MouseLeave:Connect(function()
                if not string.find(b.Text, "%[ON%]") then
                    TweenService:Create(b, TweenInfo.new(0.2), {BackgroundColor3 = Color3.fromRGB(45, 45, 45)}):Play()
                end
            end)

            b.MouseButton1Click:Connect(callback)
            buttons[name] = b
        end

        -- Variables
        local fly = {on = false, speed = 50, conn = nil, vel = nil, ang = nil}
        local noclip = {on = false, conn = nil}
        local infjump = {on = false, conn = nil}
        local esp = {on = false, hl = {}}
        local bright = {on = false}
        local speedhack = {on = false}

        -- FLY
        btn("Fly", "FLY [OFF]", 1, function()
            fly.on = not fly.on
            local b = buttons.Fly
            if fly.on then
                b.Text = "FLY [ON]"
                b.BackgroundColor3 = Color3.fromRGB(0, 255, 0)
                fly.vel = Instance.new("BodyVelocity")
                fly.vel.MaxForce = Vector3.new(1e5, 1e5, 1e5)
                fly.vel.Velocity = Vector3.zero
                fly.vel.Parent = hrp
                fly.ang = Instance.new("BodyAngularVelocity")
                fly.ang.MaxTorque = Vector3.new(1e5, 1e5, 1e5)
                fly.ang.AngularVelocity = Vector3.zero
                fly.ang.Parent = hrp
                fly.conn = RunService.Heartbeat:Connect(function()
                    local cam = workspace.CurrentCamera
                    local move = Vector3.new()
                    if UserInputService:IsKeyDown(Enum.KeyCode.W) then move += cam.CFrame.LookVector end
                    if UserInputService:IsKeyDown(Enum.KeyCode.S) then move -= cam.CFrame.LookVector end
                    if UserInputService:IsKeyDown(Enum.KeyCode.A) then move -= cam.CFrame.RightVector end
                    if UserInputService:IsKeyDown(Enum.KeyCode.D) then move += cam.CFrame.RightVector end
                    if UserInputService:IsKeyDown(Enum.KeyCode.Space) then move += Vector3.new(0,1,0) end
                    if UserInputService:IsKeyDown(Enum.KeyCode.LeftShift) then move -= Vector3.new(0,1,0) end
                    fly.vel.Velocity = move * fly.speed
                end)
            else
                b.Text = "FLY [OFF]"
                b.BackgroundColor3 = Color3.fromRGB(45, 45, 45)
                if fly.conn then fly.conn:Disconnect() end
                if fly.vel then fly.vel:Destroy() end
                if fly.ang then fly.ang:Destroy() end
            end
        end)

        -- NOCLIP
        btn("Noclip", "NOCLIP [OFF]", 2, function()
            noclip.on = not noclip.on
            local b = buttons.Noclip
            if noclip.on then
                b.Text = "NOCLIP [ON]"
                b.BackgroundColor3 = Color3.fromRGB(0, 255, 0)
                noclip.conn = RunService.Stepped:Connect(function()
                    for _, p in pairs(character:GetDescendants()) do
                        if p:IsA("BasePart") then p.CanCollide = false end
                    end
                end)
            else
                b.Text = "NOCLIP [OFF]"
                b.BackgroundColor3 = Color3.fromRGB(45, 45, 45)
                if noclip.conn then noclip.conn:Disconnect() end
            end
        end)

        -- INF JUMP
        btn("InfJump", "INF JUMP [OFF]", 3, function()
            infjump.on = not infjump.on
            local b = buttons.InfJump
            if infjump.on then
                b.Text = "INF JUMP [ON]"
                b.BackgroundColor3 = Color3.fromRGB(0, 255, 0)
                infjump.conn = UserInputService.JumpRequest:Connect(function()
                    humanoid:ChangeState(Enum.HumanoidStateType.Jumping)
                end)
            else
                b.Text = "INF JUMP [OFF]"
                b.BackgroundColor3 = Color3.fromRGB(45, 45, 45)
                if infjump.conn then infjump.conn:Disconnect() end
            end
        end)

        -- CTRL-TP
        btn("TP", "CTRL-TP",  4, function()
            local mouse = player:GetMouse()
            local pos = mouse.Hit.Position
            hrp.CFrame = CFrame.new(pos + Vector3.new(0, 5, 0))
        end)

        -- ESP
        btn("ESP", "ESP [OFF]", 5, function()
            esp.on = not esp.on
            local b = buttons.ESP
            if esp.on then
                b.Text = "ESP [ON]"
                b.BackgroundColor3 = Color3.fromRGB(0, 255, 0)
                for _, p in pairs(Players:GetPlayers()) do
                    if p ~= player and p.Character then
                        local hl = Instance.new("Highlight")
                        hl.FillColor = Color3.fromRGB(255, 0, 0)
                        hl.OutlineColor = Color3.fromRGB(255, 255, 255)
                        hl.FillTransparency = 0.5
                        hl.Parent = p.Character
                        esp.hl[p] = hl
                    end
                end
            else
                b.Text = "ESP [OFF]"
                b.BackgroundColor3 = Color3.fromRGB(45, 45, 45)
                for _, hl in pairs(esp.hl) do
                    if hl then hl:Destroy() end
                end
                esp.hl = {}
            end
        end)

        -- BRIGHTER
        btn("Bright", "BRIGHTER [OFF]", 6, function()
            bright.on = not bright.on
            local b = buttons.Bright
            if bright.on then
                b.Text = "BRIGHTER [ON]"
                b.BackgroundColor3 = Color3.fromRGB(0, 255, 0)
                Lighting.Brightness = 10
                Lighting.GlobalShadows = false
                Lighting.FogEnd = 9e9
            else
                b.Text = "BRIGHTER [OFF]"
                b.BackgroundColor3 = Color3.fromRGB(45, 45, 45)
                Lighting.Brightness = 1
                Lighting.GlobalShadows = true
                Lighting.FogEnd = 100000
            end
        end)

        -- SPEED HACK
        btn("Speed", "SPEED HACK [OFF]", 7, function()
            speedhack.on = not speedhack.on
            local b = buttons.Speed
            if speedhack.on then
                b.Text = "SPEED HACK [ON]"
                b.BackgroundColor3 = Color3.fromRGB(0, 255, 0)
                humanoid.WalkSpeed = 50
            else
                b.Text = "SPEED HACK [OFF]"
                b.BackgroundColor3 = Color3.fromRGB(45, 45, 45)
                humanoid.WalkSpeed = 16
            end
        end)

        -- WALKSPEED SLIDER
        local sliderFrame = Instance.new("Frame")
        sliderFrame.Size = UDim2.new(1, -10, 0, 50)
        sliderFrame.BackgroundColor3 = Color3.fromRGB(35, 35, 35)
        sliderFrame.LayoutOrder = 8
        sliderFrame.Parent = scroll
        round(sliderFrame, 8)
        stroke(sliderFrame, 1, Color3.fromRGB(70, 70, 70))

        local label = Instance.new("TextLabel")
        label.Size = UDim2.new(1, 0, 0, 20)
        label.BackgroundTransparency = 1
        label.Text = "WalkSpeed: 16"
        label.TextColor3 = Color3.fromRGB(255, 255, 255)
        label.Font = Enum.Font.Gotham
        label.Parent = sliderFrame

        local bar = Instance.new("TextButton")
        bar.Size = UDim2.new(1, -20, 0, 15)
        bar.Position = UDim2.new(0, 10, 0, 25)
        bar.BackgroundColor3 = Color3.fromRGB(60, 60, 60)
        bar.Text = ""
        bar.Parent = sliderFrame
        round(bar, 8)

        local fill = Instance.new("Frame")
        fill.Size = UDim2.new(0.1, 0, 1, 0)
        fill.BackgroundColor3 = Color3.fromRGB(0, 170, 255)
        fill.Parent = bar
        round(fill, 8)

        local dragging = false
        bar.InputBegan:Connect(function(i) if i.UserInputType == Enum.UserInputType.MouseButton1 then dragging = true end end)
        bar.InputEnded:Connect(function(i) if i.UserInputType == Enum.UserInputType.MouseButton1 then dragging = false end end)

        RunService.RenderStepped:Connect(function()
            if dragging then
                local mouse = UserInputService:GetMouseLocation()
                local rel = math.clamp((mouse.X - bar.AbsolutePosition.X) / bar.AbsoluteSize.X, 0, 1)
                local val = math.floor(1 + rel * 499)
                fill.Size = UDim2.new(rel, 0, 1, 0)
                label.Text = "WalkSpeed: " .. val
                humanoid.WalkSpeed = val
            end
        end)

        -- Update Canvas
        layout:GetPropertyChangedSignal("AbsoluteContentSize"):Connect(function()
            scroll.CanvasSize = UDim2.new(0, 0, 0, layout.AbsoluteContentSize.Y + 20)
        end)

        -- Respawn Handler
        player.CharacterAdded:Connect(function(char)
            character = char
            humanoid = char:WaitForChild("Humanoid")
            hrp = char:WaitForChild("HumanoidRootPart")
            humanoid.WalkSpeed = 16
            if speedhack.on then humanoid.WalkSpeed = 50 end
        end)
    end

    -- Run your script safely
    pcall(executeCheatsGUI)
end

-- CHEATS BUTTON — NOW WORKS 100%
cheatsBtn.MouseButton1Click:Connect(function()
    spawn(executeYourCheatsGUI)
end)

-- LIVE SCAN
task.spawn(function()
    while task.wait(1.5) do
        if ToolsFolder and ToolsFolder.Parent then
            pcall(scan)
        end
    end
end)

task.wait(2)
pcall(scan)
print("GRANNY - Spider HUB LOADED")