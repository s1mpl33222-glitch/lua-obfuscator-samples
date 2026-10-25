local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local TweenService = game:GetService("TweenService")
local UserInputService = game:GetService("UserInputService")
local workspace = game:GetService("Workspace")

local player = Players.LocalPlayer
local camera = workspace.CurrentCamera


local WindUI = getgenv().KrisisWindUI

if not WindUI then
    WindUI = loadstring(game:HttpGet("https://github.com/Footagesus/WindUI/releases/latest/download/main.lua"))()
    getgenv().KrisisWindUI = WindUI
end

local Window = WindUI:CreateWindow({
    Icon = "rbxassetid://7229442422",
    IconThemed = true,
    Title = "Krisis",
    Author = "by Krisis",
    Folder = "Krisis",
    Size = UDim2.fromOffset(400, 400),
    MinSize = Vector2.new(560, 350),
    MaxSize = Vector2.new(850, 560),
    Transparent = true,
    Theme = "Dark",
    Resizable = true,
    SideBarWidth = 200,
    BackgroundImageTransparency = 0.42,
    HideSearchBar = false,
    ScrollBarEnabled = false,
    OpenButton = {
        Title = "Krisis Hub",
        CornerRadius = UDim.new(1, 0),
        StrokeThickness = 1,
        Enabled = true,
        Draggable = true,
        OnlyMobile = false
    }
})

Window:Tag({
    Title = "MM2",
    Color = Color3.fromHex("#FF0000"),
    Radius = 13
})

local logoContainer = Instance.new("Frame")
logoContainer.Name = "NikeLogoContainer"
logoContainer.Size = UDim2.new(0, 50, 0, 50)
logoContainer.Position = UDim2.new(0, 10, 0, 10)
logoContainer.BackgroundTransparency = 1
logoContainer.ZIndex = 999
logoContainer.Parent = game:GetService("CoreGui")

local logoImage = Instance.new("ImageLabel")
logoImage.Name = "NikeLogo"
logoImage.Size = UDim2.new(1, 0, 1, 0)
logoImage.BackgroundTransparency = 1
logoImage.Image = "https://imgur.com/a/gunUCkR"
logoImage.ScaleType = Enum.ScaleType.Fit
logoImage.Parent = logoContainer

local logoStroke = Instance.new("UIStroke")
logoStroke.Color = Color3.fromRGB(255, 255, 255)
logoStroke.Thickness = 2
logoStroke.Transparency = 0.5
logoStroke.ApplyStrokeMode = Enum.ApplyStrokeMode.Border
logoStroke.Parent = logoImage

local logoCorner = Instance.new("UICorner")
logoCorner.CornerRadius = UDim.new(0, 12)
logoCorner.Parent = logoImage

task.spawn(function()
    while logoImage and logoImage.Parent do
        TweenService:Create(logoStroke, TweenInfo.new(1.5, Enum.EasingStyle.Sine, Enum.EasingDirection.InOut), {Transparency = 0.2}):Play()
        task.wait(1.5)
        TweenService:Create(logoStroke, TweenInfo.new(1.5, Enum.EasingStyle.Sine, Enum.EasingDirection.InOut), {Transparency = 0.8}):Play()
        task.wait(1.5)
    end
end)

local function applyStrokeEffect(stroke)
    task.spawn(function()
        while stroke and stroke.Parent do
            TweenService:Create(stroke, TweenInfo.new(0.8, Enum.EasingStyle.Sine, Enum.EasingDirection.InOut), {Color = Color3.fromRGB(255, 255, 255)}):Play()
            task.wait(0.8)
            if not stroke.Parent then break end
            TweenService:Create(stroke, TweenInfo.new(0.8, Enum.EasingStyle.Sine, Enum.EasingDirection.InOut), {Color = Color3.fromRGB(200, 200, 200)}):Play()
            task.wait(0.8)
        end
    end)
end

local SettingsTab = Window:Tab({Title="General", Icon="settings"})
local MainTab = Window:Tab({Title="ESP", Icon="eye"})
local TeleportTab = Window:Tab({Title="Teleport", Icon="navigation"})
local VisualsTab = Window:Tab({Title="Visuals", Icon="skull"})
local MurderTab = Window:Tab({Title="Murderer", Icon="sword"})
local MapTab = Window:Tab({Title="Coins", Icon="coins"})
local GunTab = Window:Tab({Title="Sheriff", Icon="sword"})

local FloatingGui = game:GetService("CoreGui"):FindFirstChild("WeaponTeleportGui")
if not FloatingGui then
    FloatingGui = Instance.new("ScreenGui")
    FloatingGui.Name = "WeaponTeleportGui"
    FloatingGui.ResetOnSpawn = false
    FloatingGui.Parent = game:GetService("CoreGui")
end

local function getMurdererFrontCFrame()
    for _, p in ipairs(Players:GetPlayers()) do
        if p ~= player then
            local knife = p:FindFirstChild("Backpack") and p.Backpack:FindFirstChild("Knife") or p.Character and p.Character:FindFirstChild("Knife")
            if knife and p.Character and p.Character:FindFirstChild("HumanoidRootPart") then
                local hrp = p.Character.HumanoidRootPart
                return hrp.CFrame + (hrp.CFrame.LookVector * 2)
            end
        end
    end
    return nil
end

local function getClosestPlayerFrontCFrame()
    local closestCharacter = nil
    local shortestDistance = math.huge
    local myChar = player.Character
    if not myChar or not myChar:FindFirstChild("HumanoidRootPart") then return nil, nil end
    local myHRP = myChar.HumanoidRootPart
    for _, p in ipairs(Players:GetPlayers()) do
        if p ~= player and p.Character and p.Character:FindFirstChild("HumanoidRootPart") and p.Character:FindFirstChild("Humanoid") then
            if p.Character.Humanoid.Health > 0 then
                local targetHRP = p.Character.HumanoidRootPart
                local distance = (myHRP.Position - targetHRP.Position).Magnitude
                if distance < shortestDistance then
                    shortestDistance = distance
                    closestCharacter = p.Character
                end
            end
        end
    end
    if closestCharacter then
        local hrp = closestCharacter.HumanoidRootPart
        return hrp.CFrame + (hrp.CFrame.LookVector * 2), hrp.CFrame
    end
    return nil, nil
end

MurderTab:Paragraph({Title = "TP Knife", Desc = ""})

MurderTab:Button({
    Title = "TP Knife To Player",
    Desc = "",
    Callback = function()
        if FloatingGui:FindFirstChild("BtnKnifeTeleport") then return end
        local btnKnife = Instance.new("TextButton")
        btnKnife.Name = "BtnKnifeTeleport"
        btnKnife.Size = UDim2.new(0, 140, 0, 52)
        btnKnife.Position = UDim2.new(0.5, 10, 0.87, 0)
        btnKnife.AnchorPoint = Vector2.new(0.5, 0)
        btnKnife.BackgroundColor3 = Color3.fromRGB(180, 220, 255)
        btnKnife.BackgroundTransparency = 0.35
        btnKnife.TextColor3 = Color3.fromRGB(0, 70, 150)
        btnKnife.Text = "Throwing Knife"
        btnKnife.Font = Enum.Font.GothamBold
        btnKnife.TextSize = 14
        btnKnife.Parent = FloatingGui
        btnKnife.Active = true
        btnKnife.Draggable = true
        Instance.new("UICorner", btnKnife).CornerRadius = UDim.new(0, 18)
        local strokeKnife = Instance.new("UIStroke", btnKnife)
        strokeKnife.Thickness = 2.5
        strokeKnife.ApplyStrokeMode = Enum.ApplyStrokeMode.Border
        strokeKnife.Color = Color3.fromRGB(255, 50, 50)
        applyStrokeEffect(strokeKnife)
        btnKnife.MouseButton1Click:Connect(function()
            local knife = player.Character and player.Character:FindFirstChild("Knife") or player:FindFirstChild("Backpack") and player.Backpack:FindFirstChild("Knife")
            if knife and knife:FindFirstChild("Events") and knife.Events:FindFirstChild("KnifeThrown") then
                local frontTarget, exactTarget = getClosestPlayerFrontCFrame()
                if frontTarget and exactTarget then
                    local args = {frontTarget, exactTarget}
                    knife.Events.KnifeThrown:FireServer(unpack(args))
                else
                    btnKnife.Text = "Target Not Found"
                    task.wait(1)
                    btnKnife.Text = "Throwing Knife"
                end
            else
                btnKnife.Text = "No Knife"
                task.wait(1)
                btnKnife.Text = "Throwing Knife"
            end
        end)
    end
})

GunTab:Paragraph({Title = "TP Ammunition", Desc = ""})

GunTab:Button({
    Title = "TP Ammo To Murderer",
    Desc = "",
    Callback = function()
        if FloatingGui:FindFirstChild("BtnGunTeleport") then return end
        local btnGun = Instance.new("TextButton")
        btnGun.Name = "BtnGunTeleport"
        btnGun.Size = UDim2.new(0, 140, 0, 52)
        btnGun.Position = UDim2.new(0.5, -150, 0.87, 0)
        btnGun.AnchorPoint = Vector2.new(0.5, 0)
        btnGun.BackgroundColor3 = Color3.fromRGB(180, 220, 255)
        btnGun.BackgroundTransparency = 0.35
        btnGun.TextColor3 = Color3.fromRGB(0, 70, 150)
        btnGun.Text = "Shooting"
        btnGun.Font = Enum.Font.GothamBold
        btnGun.TextSize = 14
        btnGun.Parent = FloatingGui
        btnGun.Active = true
        btnGun.Draggable = true
        Instance.new("UICorner", btnGun).CornerRadius = UDim.new(0, 18)
        local strokeGun = Instance.new("UIStroke", btnGun)
        strokeGun.Thickness = 2.5
        strokeGun.ApplyStrokeMode = Enum.ApplyStrokeMode.Border
        strokeGun.Color = Color3.fromRGB(0, 120, 255)
        applyStrokeEffect(strokeGun)
        btnGun.MouseButton1Click:Connect(function()
            local gun = player.Character and player.Character:FindFirstChild("Gun") or player:FindFirstChild("Backpack") and player.Backpack:FindFirstChild("Gun")
            if gun and gun:FindFirstChild("Shoot") then
                local targetCFrame = getMurdererFrontCFrame()
                if targetCFrame then
                    local myCFrame = player.Character and player.Character:FindFirstChild("HumanoidRootPart") and player.Character.HumanoidRootPart.CFrame or CFrame.new()
                    local args = {targetCFrame, myCFrame}
                    gun.Shoot:FireServer(unpack(args))
                else
                    btnGun.Text = "Murderer Not Found"
                    task.wait(1)
                    btnGun.Text = "Shooting"
                end
            else
                btnGun.Text = "No Gun"
                task.wait(1)
                btnGun.Text = "Shooting"
            end
        end)
    end
})

local autoGunDrop = false
local teleporting = false

local function findGunDrop()
    for _,v in pairs(workspace:GetDescendants()) do
        if v.Name == "GunDrop" and v:IsA("BasePart") then
            return v
        end
    end
end

SettingsTab:Toggle({
    Title="Auto TP To Gun",
    Default=false,
    Callback=function(state)
        autoGunDrop = state
    end
})

RunService.Heartbeat:Connect(function()
    if not autoGunDrop then return end
    if teleporting then return end
    local char = player.Character
    if not char then return end
    local root = char:FindFirstChild("HumanoidRootPart")
    if not root then return end
    local gunDrop = findGunDrop()
    if gunDrop then
        teleporting = true
        local oldPos = root.CFrame
        root.CFrame = gunDrop.CFrame + Vector3.new(0,2,0)
        task.wait(0.5)
        if root then root.CFrame = oldPos end
        task.wait(0.3)
        teleporting = false
    end
end)

local function hasItem(plr,item)
    local backpack = plr:FindFirstChild("Backpack")
    local char = plr.Character
    if backpack and backpack:FindFirstChild(item) then return true end
    if char and char:FindFirstChild(item) then return true end
    return false
end

local function getRole(plr)
    local hasGun = hasItem(plr,"Gun")
    local hasKnife = hasItem(plr,"Knife")
    if hasGun then return "Gun" elseif hasKnife then return "Knife" else return "Good" end
end

local function getColor(role)
    if role == "Gun" then return Color3.fromRGB(0,150,255)
    elseif role == "Knife" then return Color3.fromRGB(255,0,0)
    elseif role == "Good" then return Color3.fromRGB(0,255,0) end
end

local function getText(role)
    if role == "Gun" then return "Sheriff"
    elseif role == "Knife" then return "Murderer"
    elseif role == "Good" then return "Innocents" end
end

local function removeESP(char)
    local esp = char:FindFirstChild("RoleESP")
    if esp then esp:Destroy() end
    local tag = char:FindFirstChild("RoleTag")
    if tag then tag:Destroy() end
end

local function createESP(plr)
    local char = plr.Character
    if not char then return end
    removeESP(char)
    local role = getRole(plr)
    local color = getColor(role)
    local text = getText(role)
    local highlight = Instance.new("Highlight")
    highlight.Name = "RoleESP"
    highlight.FillTransparency = 1
    highlight.OutlineColor = color
    highlight.DepthMode = Enum.HighlightDepthMode.AlwaysOnTop
    highlight.Parent = char
    local billboard = Instance.new("BillboardGui")
    billboard.Name = "RoleTag"
    billboard.Size = UDim2.new(0,200,0,40)
    billboard.StudsOffset = Vector3.new(0,2,0)
    billboard.AlwaysOnTop = true
    billboard.Adornee = char:FindFirstChild("Head")
    billboard.Parent = char
    local label = Instance.new("TextLabel")
    label.Size = UDim2.new(1,0,1,0)
    label.BackgroundTransparency = 1
    label.TextScaled = true
    label.Text = text
    label.TextColor3 = color
    label.Parent = billboard
end

local function updateGunDrop()
    for _,obj in pairs(workspace:GetDescendants()) do
        if obj.Name == "GunDrop" and obj:IsA("BasePart") then
            if gunDropEnabled then
                if not obj:FindFirstChild("GunDropESP") then
                    local hl = Instance.new("Highlight")
                    hl.Name = "GunDropESP"
                    hl.FillTransparency = 1
                    hl.OutlineColor = Color3.fromRGB(255,255,0)
                    hl.DepthMode = Enum.HighlightDepthMode.AlwaysOnTop
                    hl.Parent = obj
                    local billboard = Instance.new("BillboardGui")
                    billboard.Name = "GunDropText"
                    billboard.Size = UDim2.new(0,200,0,40)
                    billboard.StudsOffset = Vector3.new(0,2,0)
                    billboard.AlwaysOnTop = true
                    billboard.Adornee = obj
                    billboard.Parent = obj
                    local label = Instance.new("TextLabel")
                    label.Size = UDim2.new(1,0,1,0)
                    label.BackgroundTransparency = 1
                    label.TextScaled = true
                    label.Text = "Sheriff Gun"
                    label.TextColor3 = Color3.fromRGB(255,255,0)
                    label.Parent = billboard
                end
            else
                local hl = obj:FindFirstChild("GunDropESP")
                if hl then hl:Destroy() end
                local text = obj:FindFirstChild("GunDropText")
                if text then text:Destroy() end
            end
        end
    end
end

local function updatePlayers()
    for _,plr in pairs(Players:GetPlayers()) do
        if plr ~= player and plr.Character then
            if enabled then createESP(plr) else removeESP(plr.Character) end
        end
    end
end

local enabled = false
local gunDropEnabled = false

MainTab:Toggle({
    Title="Enable ESP Player",
    Default=false,
    Callback=function(state)
        enabled = state
        updatePlayers()
    end
})

MainTab:Toggle({
    Title="Enable ESP Sheriff Gun",
    Default=false,
    Callback=function(state)
        gunDropEnabled = state
        updateGunDrop()
    end
})

task.spawn(function()
    while true do
        task.wait(0.5)
        if enabled then updatePlayers() end
        if gunDropEnabled then updateGunDrop() end
    end
end)

Players.PlayerAdded:Connect(function(plr)
    plr.CharacterAdded:Connect(function()
        task.wait(1)
        if enabled then updatePlayers() end
    end)
end)

local function findSheriff()
    for _,plr in pairs(Players:GetPlayers()) do
        if plr ~= player then
            local backpack = plr:FindFirstChild("Backpack")
            local char = plr.Character
            if backpack and backpack:FindFirstChild("Gun") then return plr end
            if char and char:FindFirstChild("Gun") then return plr end
        end
    end
end

local function findMurderer()
    for _,plr in pairs(Players:GetPlayers()) do
        if plr ~= player then
            local backpack = plr:FindFirstChild("Backpack")
            local char = plr.Character
            if backpack and backpack:FindFirstChild("Knife") then return plr end
            if char and char:FindFirstChild("Knife") then return plr end
        end
    end
end

local function teleportTo(plr)
    if plr and plr.Character and plr.Character:FindFirstChild("HumanoidRootPart") then
        local myChar = player.Character
        if myChar and myChar:FindFirstChild("HumanoidRootPart") then
            myChar.HumanoidRootPart.CFrame = plr.Character.HumanoidRootPart.CFrame * CFrame.new(0,0,3)
        end
    end
end

TeleportTab:Button({
    Title="TP To Sheriff",
    Callback=function()
        local sheriff = findSheriff()
        if sheriff then teleportTo(sheriff) end
    end
})

TeleportTab:Button({
    Title="TP To Murderer",
    Callback=function()
        local murderer = findMurderer()
        if murderer then teleportTo(murderer) end
    end
})

local lockEnabled = false
local circleRadius = 200

local gui = Instance.new("ScreenGui")
gui.ResetOnSpawn = false
gui.Parent = player.PlayerGui

local circle = Instance.new("Frame")
circle.AnchorPoint = Vector2.new(0.5,0.5)
circle.Position = UDim2.new(0.5,0,0.5,0)
circle.Size = UDim2.new(0,circleRadius,0,circleRadius)
circle.BackgroundTransparency = 1
circle.Visible = false
circle.Parent = gui

local stroke = Instance.new("UIStroke")
stroke.Color = Color3.fromRGB(255,0,0)
stroke.Thickness = 2
stroke.Parent = circle

local corner = Instance.new("UICorner")
corner.CornerRadius = UDim.new(1,0)
corner.Parent = circle

local function getMurdererAim()
    for _,plr in pairs(Players:GetPlayers()) do
        if plr ~= player then
            local backpack = plr:FindFirstChild("Backpack")
            local char = plr.Character
            if backpack and backpack:FindFirstChild("Knife") then return plr end
            if char and char:FindFirstChild("Knife") then return plr end
        end
    end
end

local function isInCircle(pos)
    local screenPos,visible = camera:WorldToViewportPoint(pos)
    if not visible then return false end
    local center = Vector2.new(camera.ViewportSize.X/2,camera.ViewportSize.Y/2)
    local dist = (Vector2.new(screenPos.X,screenPos.Y) - center).Magnitude
    return dist <= circleRadius/2
end

RunService.RenderStepped:Connect(function()
    if not lockEnabled then return end
    local murderer = getMurdererAim()
    if murderer and murderer.Character and murderer.Character:FindFirstChild("Head") then
        local head = murderer.Character.Head
        if isInCircle(head.Position) then
            camera.CFrame = CFrame.new(camera.CFrame.Position, head.Position)
        end
    end
end)

GunTab:Toggle({
    Title="Enable Aim Lock Murderer",
    Default=false,
    Callback=function(state)
        lockEnabled = state
        circle.Visible = state
    end
})

GunTab:Slider({
    Title="FOV Circle",
    Value={Min=100, Max=600, Default=200},
    Callback=function(v)
        circleRadius = v
        circle.Size = UDim2.new(0,v,0,v)
    end
})

TeleportTab:Button({
    Title = "TP To Sheriff Gun",
    Callback = function()
        local char = player.Character
        if not char then return end
        local root = char:FindFirstChild("HumanoidRootPart")
        if not root then return end
        local gunDrop = workspace:FindFirstChild("GunDrop", true)
        if gunDrop then
            local oldPos = root.CFrame
            root.CFrame = gunDrop.CFrame * CFrame.new(0,0,0)
            task.wait(0.5)
            if root then root.CFrame = oldPos end
        end
    end
})

TeleportTab:Button({
    Title="TP To Lobby",
    Callback=function()
        local char = player.Character
        if not char then return end
        local root = char:FindFirstChild("HumanoidRootPart")
        if not root then return end
        local lobby = workspace:FindFirstChild("Lobby")
        if lobby then
            local part
            if lobby:IsA("Model") then
                part = lobby.PrimaryPart or lobby:FindFirstChildWhichIsA("BasePart")
            elseif lobby:IsA("BasePart") then
                part = lobby
            end
            if part then root.CFrame = part.CFrame + Vector3.new(0,3,0) end
        end
    end
})

TeleportTab:Button({
    Title="TP To Map",
    Callback=function()
        local char = player.Character
        if not char then return end
        local root = char:FindFirstChild("HumanoidRootPart")
        if not root then return end
        local spawnPart = workspace:FindFirstChild("Spawn", true)
        if spawnPart and spawnPart:IsA("BasePart") then
            root.CFrame = spawnPart.CFrame + Vector3.new(0,3,0)
        end
    end
})

local autoShoot = false

local function getMurdererTarget()
    local closest = nil
    local distance = math.huge
    for _,plr in pairs(Players:GetPlayers()) do
        if plr ~= player and plr.Character and plr.Character:FindFirstChild("HumanoidRootPart") then
            local backpack = plr:FindFirstChild("Backpack")
            local char = plr.Character
            local isMurderer = false
            if backpack and backpack:FindFirstChild("Knife") then isMurderer = true end
            if char and char:FindFirstChild("Knife") then isMurderer = true end
            if isMurderer then
                local pos, visible = camera:WorldToViewportPoint(plr.Character.HumanoidRootPart.Position)
                if visible then
                    local dist = (Vector2.new(pos.X,pos.Y) - Vector2.new(camera.ViewportSize.X/2, camera.ViewportSize.Y/2)).Magnitude
                    if dist < distance then
                        distance = dist
                        closest = plr
                    end
                end
            end
        end
    end
    return closest
end

RunService.RenderStepped:Connect(function()
    if not autoShoot then return end
    local char = player.Character
    if not char then return end
    local tool = char:FindFirstChild("Gun")
    if not tool then return end
    local remote = tool:FindFirstChild("Shoot")
    if not remote then return end
    local root = char:FindFirstChild("HumanoidRootPart")
    if not root then return end
    local attachment = root:FindFirstChild("GunRaycastAttachment")
    if not attachment then return end
    local target = getMurdererTarget()
    if not target then return end
    local targetHRP = target.Character:FindFirstChild("HumanoidRootPart")
    if not targetHRP then return end
    remote:FireServer(attachment.WorldCFrame, CFrame.new(targetHRP.Position))
end)

SettingsTab:Toggle({
    Title="Enable Auto Shoot Murderer",
    Default=false,
    Callback=function(state)
        autoShoot = state
    end
})

local function walkFling(target)
    local char = player.Character
    if not char then return end
    local root = char:FindFirstChild("HumanoidRootPart")
    local hum = char:FindFirstChild("Humanoid")
    if not root or not hum then return end
    if not target.Character then return end
    local targetRoot = target.Character:FindFirstChild("HumanoidRootPart")
    if not targetRoot then return end
    local oldPos = root.CFrame
    local cam = workspace.CurrentCamera
    local oldSubject = cam.CameraSubject
    local targetHum = target.Character:FindFirstChildOfClass("Humanoid")
    if targetHum then cam.CameraSubject = targetHum end
    local enabledFling = true
    local spin = Instance.new("BodyAngularVelocity")
    spin.MaxTorque = Vector3.new(math.huge,math.huge,math.huge)
    spin.AngularVelocity = Vector3.new(0,99999,0)
    spin.P = math.huge
    spin.Parent = root
    task.spawn(function()
        while enabledFling do
            RunService.Heartbeat:Wait()
            local vel = root.Velocity
            root.Velocity = vel * 8000 + Vector3.new(0,8000,0)
            RunService.RenderStepped:Wait()
            root.Velocity = vel
        end
    end)
    local start = tick()
    while tick() - start < 2 do
        if targetRoot then
            local offset = Vector3.new(math.random(-2,2),0,math.random(-2,2))
            root.CFrame = targetRoot.CFrame * CFrame.new(offset)
            root.Velocity = (targetRoot.Position - root.Position).Unit * 120
        end
        RunService.Heartbeat:Wait()
    end
    enabledFling = false
    spin:Destroy()
    root.Velocity = Vector3.zero
    root.RotVelocity = Vector3.zero
    RunService.Heartbeat:Wait()
    cam.CameraSubject = oldSubject
    root.CFrame = oldPos
end

local selectedPlayer = nil
local playerDropdown

local function getPlayers()
    local list = {}
    for _,v in pairs(Players:GetPlayers()) do
        if v ~= player then table.insert(list,v.Name) end
    end
    return list
end

local function getPlayerByName(name)
    for _,v in pairs(Players:GetPlayers()) do
        if v.Name == name then return v end
    end
end

playerDropdown = VisualsTab:Dropdown({
    Title = "Player Select",
    Values = getPlayers(),
    Callback = function(v)
        selectedPlayer = getPlayerByName(v)
    end
})

local function refreshPlayers()
    if playerDropdown and playerDropdown.Refresh then
        playerDropdown:Refresh(getPlayers())
    end
end

Players.PlayerAdded:Connect(function()
    task.wait(1)
    refreshPlayers()
end)

Players.PlayerRemoving:Connect(function()
    task.wait(1)
    refreshPlayers()
end)

VisualsTab:Button({
    Title="Sheriff Fling",
    Callback=function()
        local sheriff = findSheriff()
        if sheriff then walkFling(sheriff) end
    end
})

VisualsTab:Button({
    Title="Murderer Fling",
    Callback=function()
        local murderer = findMurderer()
        if murderer then walkFling(murderer) end
    end
})

VisualsTab:Button({
    Title="Selected Fling Player",
    Callback=function()
        if selectedPlayer then walkFling(selectedPlayer) end
    end
})

local TrollSection = VisualsTab:Section({Title = "Fling"})

local touchKick = false
local flingAll = false

local function flingPlayer(target)
    local char = player.Character
    if not char then return end
    local root = char:FindFirstChild("HumanoidRootPart")
    if not root then return end
    if not target.Character then return end
    local targetRoot = target.Character:FindFirstChild("HumanoidRootPart")
    if not targetRoot then return end
    local oldPos = root.CFrame
    local enabledFling = true
    task.spawn(function()
        while enabledFling do
            RunService.Heartbeat:Wait()
            local vel = root.Velocity
            root.Velocity = vel * 8000 + Vector3.new(0,8000,0)
            RunService.RenderStepped:Wait()
            root.Velocity = vel
        end
    end)
    local start = tick()
    while tick() - start < 2 do
        if targetRoot then
            root.CFrame = targetRoot.CFrame
            root.Velocity = (targetRoot.Position - root.Position).Unit * 150
        end
        RunService.Heartbeat:Wait()
    end
    enabledFling = false
    root.CFrame = oldPos
end

TrollSection:Toggle({
    Title="Fling Player",
    Default=false,
    Callback=function(state)
        touchKick = state
    end
})

RunService.Heartbeat:Connect(function()
    if not touchKick then return end
    local char = player.Character
    if not char then return end
    local root = char:FindFirstChild("HumanoidRootPart")
    if not root then return end
    for _,plr in pairs(Players:GetPlayers()) do
        if plr ~= player and plr.Character and plr.Character:FindFirstChild("HumanoidRootPart") then
            local dist = (root.Position - plr.Character.HumanoidRootPart.Position).Magnitude
            if dist < 3 then flingPlayer(plr) end
        end
    end
end)

TrollSection:Toggle({
    Title="Fling All Player",
    Default=false,
    Callback=function(state)
        flingAll = state
        if state then
            task.spawn(function()
                while flingAll do
                    for _,plr in pairs(Players:GetPlayers()) do
                        if not flingAll then break end
                        if plr ~= player then
                            flingPlayer(plr)
                            task.wait(1)
                        end
                    end
                end
            end)
        end
    end
})

local MoveSection = SettingsTab:Section({Title = "Movement"})

local walkSpeed = 16
local jumpPower = 50
local infJump = false

MoveSection:Slider({
    Title = "Walk Speed",
    Step = 1,
    Value = {Min = 16, Max = 200, Default = 16},
    Callback = function(value)
        walkSpeed = value
        if player.Character and player.Character:FindFirstChild("Humanoid") then
            player.Character.Humanoid.WalkSpeed = walkSpeed
        end
    end
})

MoveSection:Slider({
    Title = "Jump Power",
    Step = 1,
    Value = {Min = 50, Max = 200, Default = 50},
    Callback = function(value)
        jumpPower = value
        if player.Character and player.Character:FindFirstChild("Humanoid") then
            player.Character.Humanoid.JumpPower = jumpPower
        end
    end
})

MoveSection:Toggle({
    Title = "Infinite Jump",
    Default = false,
    Callback = function(state)
        infJump = state
    end
})

UserInputService.JumpRequest:Connect(function()
    if infJump then
        local char = player.Character
        if char and char:FindFirstChild("Humanoid") then            char.Humanoid:ChangeState("Jumping")
        end
    end
end)

local HitboxSection = MurderTab:Section({Title = "Hitbox"})

local hitboxEnabled = false
local hitboxSize = 12
local circlePart = nil

local function createCirclePart()
    if circlePart then circlePart:Destroy() end
    circlePart = Instance.new("Part")
    circlePart.Name = "RedCircle"
    circlePart.Shape = Enum.PartType.Cylinder
    circlePart.Size = Vector3.new(0.2, hitboxSize, hitboxSize)
    circlePart.Color = Color3.fromRGB(255,0,0)
    circlePart.Material = Enum.Material.Neon
    circlePart.Anchored = true
    circlePart.CanCollide = false
    circlePart.Parent = workspace
    circlePart.Orientation = Vector3.new(0,0,90)
end

HitboxSection:Toggle({
    Title="Enable Hitbox",
    Default=false,
    Callback=function(state)
        hitboxEnabled = state
        if state then createCirclePart() else if circlePart then circlePart:Destroy() circlePart = nil end end
    end
})

HitboxSection:Slider({
    Title="Hitbox Size",
    Step=1,
    Value={Min=6, Max=150, Default=12},
    Callback=function(value)
        hitboxSize = value
        if circlePart then circlePart.Size = Vector3.new(0.2,hitboxSize,hitboxSize) end
    end
})

RunService.RenderStepped:Connect(function()
    if not hitboxEnabled then return end
    local char = player.Character
    if not char then return end
    local root = char:FindFirstChild("HumanoidRootPart")
    if not root then return end
    if circlePart then
        circlePart.Position = Vector3.new(root.Position.X, root.Position.Y - 3, root.Position.Z)
    end
    for _,plr in pairs(Players:GetPlayers()) do
        if plr ~= player and plr.Character and plr.Character:FindFirstChild("HumanoidRootPart") then
            local enemyRoot = plr.Character.HumanoidRootPart
            local dist = (enemyRoot.Position - root.Position).Magnitude
            if dist < (hitboxSize/2) then
                enemyRoot.CFrame = root.CFrame * CFrame.new(0,0,-4)
            end
        end
    end
end)

local KillSection = MurderTab:Section({Title = "Mass Kill"})

local killAll = false
local autoKill = false

local function pullPlayers()
    local char = player.Character
    if not char then return end
    local root = char:FindFirstChild("HumanoidRootPart")
    if not root then return end
    local knife = char:FindFirstChild("Knife") or player.Backpack:FindFirstChild("Knife")
    if knife and knife.Parent ~= char then knife.Parent = char end
    for _,plr in pairs(Players:GetPlayers()) do
        if plr ~= player and plr.Character and plr.Character:FindFirstChild("HumanoidRootPart") then
            local enemyRoot = plr.Character.HumanoidRootPart
            enemyRoot.CFrame = root.CFrame * CFrame.new(0,0,-3)
        end
    end
end

KillSection:Toggle({
    Title="Kill All Player",
    Default=false,
    Callback=function(state)
        killAll = state
        if state then pullPlayers() end
    end
})

KillSection:Toggle({
    Title="Enable Auto Kill All Player",
    Default=false,
    Callback=function(state)
        autoKill = state
    end
})

RunService.RenderStepped:Connect(function()
    if not autoKill then return end
    local char = player.Character
    if not char then return end
    local knife = char:FindFirstChild("Knife") or player.Backpack:FindFirstChild("Knife")
    if knife then pullPlayers() end
end)

local walkThrough = false

RunService.Stepped:Connect(function()
    if not walkThrough then return end
    local char = player.Character
    if not char then return end
    for _,plr in pairs(Players:GetPlayers()) do
        if plr ~= player and plr.Character then
            for _,part in pairs(plr.Character:GetDescendants()) do
                if part:IsA("BasePart") then
                    part.CanCollide = false
                end
            end
        end
    end
end)

MainTab:Toggle({
    Title="Noclip Friends",
    Default=false,
    Callback=function(state)
        walkThrough = state
        if not state then
            for _,plr in pairs(Players:GetPlayers()) do
                if plr.Character then
                    for _,part in pairs(plr.Character:GetDescendants()) do
                        if part:IsA("BasePart") then
                            part.CanCollide = true
                        end
                    end
                end
            end
        end
    end
})

local selectedPlayerTP = nil

local function getPlayerList()
    local list = {}
    for _,plr in pairs(Players:GetPlayers()) do
        if plr ~= player then table.insert(list, plr.Name) end
    end
    return list
end

local playerDropdownTP = TeleportTab:Dropdown({
    Title = "Select Player",
    Values = getPlayerList(),
    Callback = function(value)
        selectedPlayerTP = value
    end
})

TeleportTab:Button({
    Title = "TP To Selected Player",
    Callback = function()
        if not selectedPlayerTP then return end
        local target = Players:FindFirstChild(selectedPlayerTP)
        if target and target.Character and target.Character:FindFirstChild("HumanoidRootPart") then
            local myChar = player.Character
            if myChar and myChar:FindFirstChild("HumanoidRootPart") then
                myChar.HumanoidRootPart.CFrame = target.Character.HumanoidRootPart.CFrame + Vector3.new(2,0,0)
            end
        end
    end
})

local function refreshPlayersTP()
    if playerDropdownTP and playerDropdownTP.Refresh then
        playerDropdownTP:Refresh(getPlayerList())
    end
end

Players.PlayerAdded:Connect(refreshPlayersTP)
Players.PlayerRemoving:Connect(refreshPlayersTP)

local floatingGunButton = nil

local function createFloatingGunButton()
    if floatingGunButton then return end
    local FloatingGui = Instance.new("ScreenGui")
    FloatingGui.Name = "GunTeleportButton"
    FloatingGui.ResetOnSpawn = false
    FloatingGui.Parent = player.PlayerGui
    local btn = Instance.new("TextButton")
    btn.Size = UDim2.new(0,140,0,52)
    btn.Position = UDim2.new(0.5,-70,0.87,0)
    btn.AnchorPoint = Vector2.new(0.5,0)
    btn.BackgroundColor3 = Color3.fromRGB(180,220,255)
    btn.BackgroundTransparency = 0.35
    btn.TextColor3 = Color3.fromRGB(0,70,150)
    btn.Text = "TP To Sheriff Gun"
    btn.Font = Enum.Font.GothamBold
    btn.TextSize = 14
    btn.Parent = FloatingGui
    btn.Active = true
    btn.Draggable = true
    local corner = Instance.new("UICorner", btn)
    corner.CornerRadius = UDim.new(0,18)
    local stroke = Instance.new("UIStroke", btn)
    stroke.Thickness = 2.5
    stroke.ApplyStrokeMode = Enum.ApplyStrokeMode.Border
    stroke.Color = Color3.fromRGB(0,120,255)
    task.spawn(function()
        while btn.Parent do
            TweenService:Create(stroke, TweenInfo.new(0.8,Enum.EasingStyle.Sine,Enum.EasingDirection.InOut), {Color = Color3.fromRGB(0,80,255)}):Play()
            task.wait(0.8)
            TweenService:Create(stroke, TweenInfo.new(0.8,Enum.EasingStyle.Sine,Enum.EasingDirection.InOut), {Color = Color3.fromRGB(160,230,255)}):Play()
            task.wait(0.8)
        end
    end)
    btn.MouseButton1Click:Connect(function()
        local char = player.Character
        if not char then return end
        local root = char:FindFirstChild("HumanoidRootPart")
        if not root then return end
        local gun = findGunDrop()
        if not gun then return end
        local oldPos = root.CFrame
        root.CFrame = gun.CFrame + Vector3.new(0,2,0)
        task.wait(0.3)
        root.CFrame = oldPos
    end)
    floatingGunButton = FloatingGui
end

local function removeFloatingGunButton()
    if floatingGunButton then
        floatingGunButton:Destroy()
        floatingGunButton = nil
    end
end

SettingsTab:Toggle({
    Title="Enable TP To Sheriff Gun (Mini Button)",
    Default=false,
    Callback=function(state)
        if state then createFloatingGunButton() else removeFloatingGunButton() end
    end
})

local autoWin = false
local undergroundPos

local function getCharacter()
    return player.Character or player.CharacterAdded:Wait()
end

local function findKnifePlayer()
    for _,plr in pairs(Players:GetPlayers()) do
        if plr ~= player then
            local char = plr.Character
            if char and char:FindFirstChild("Knife") then return plr end
        end
    end
end

local function hasGun()
    local char = getCharacter()
    if char:FindFirstChild("Gun") then return true end
    if player.Backpack:FindFirstChild("Gun") then return true end
    return false
end

local function hasKnife()
    local char = getCharacter()
    if char:FindFirstChild("Knife") then return true end
    if player.Backpack:FindFirstChild("Knife") then return true end
    return false
end

MapTab:Toggle({
    Title="Enable Auto Win",
    Default=false,
    Callback=function(state)
        autoWin = state
        if not state then return end
        task.spawn(function()
            local char = getCharacter()
            local root = char:WaitForChild("HumanoidRootPart")
            undergroundPos = root.Position - Vector3.new(0,15,0)
            root.CFrame = CFrame.new(undergroundPos)
            RunService.Heartbeat:Connect(function()
                if not autoWin then return end
                if not root then return end
                root.CFrame = CFrame.new(undergroundPos)
                if hasGun() then
                    local murderer = findKnifePlayer()
                    if murderer and murderer.Character then
                        local mroot = murderer.Character:FindFirstChild("HumanoidRootPart")
                        if mroot then
                            root.CFrame = mroot.CFrame * CFrame.new(0,5,0)
                        end
                    end
                end
                if hasKnife() then
                    for _,plr in pairs(Players:GetPlayers()) do
                        if plr ~= player and plr.Character then
                            local targetRoot = plr.Character:FindFirstChild("HumanoidRootPart")
                            if targetRoot then
                                targetRoot.CFrame = root.CFrame * CFrame.new(0,0,-5)
                            end
                        end
                    end
                end
            end)
        end)
    end
})

local function getMurdererShoot()
    for _,plr in pairs(Players:GetPlayers()) do
        if plr ~= player then
            local char = plr.Character
            local backpack = plr:FindFirstChild("Backpack")
            if char and char:FindFirstChild("Knife") then return plr end
            if backpack and backpack:FindFirstChild("Knife") then return plr end
        end
    end
end

local function shootMurderer()
    local char = player.Character
    if not char then return end
    local gun = char:FindFirstChild("Gun") or player.Backpack:FindFirstChild("Gun")
    if not gun then return end
    if gun.Parent ~= char then gun.Parent = char end
    local remote = gun:FindFirstChild("Shoot")
    if not remote then return end
    local root = char:FindFirstChild("HumanoidRootPart")
    if not root then return end
    local attachment = root:FindFirstChild("GunRaycastAttachment")
    if not attachment then return end
    local murderer = getMurdererShoot()
    if not murderer then return end
    local mchar = murderer.Character
    if not mchar then return end
    local mroot = mchar:FindFirstChild("HumanoidRootPart")
    if not mroot then return end
    local velocity = mroot.AssemblyLinearVelocity
    local predictedPosition = mroot.Position + velocity * 0.15
    remote:FireServer(attachment.WorldCFrame, CFrame.new(predictedPosition))
end

local floatingShootButton = nil

local function createFloatingShootButton()
    if floatingShootButton then floatingShootButton:Destroy() end
    local FloatingGui = Instance.new("ScreenGui")
    FloatingGui.Parent = player.PlayerGui
    FloatingGui.ResetOnSpawn = false
    local btn = Instance.new("TextButton")
    btn.Size = UDim2.new(0,140,0,52)
    btn.Position = UDim2.new(0.5,-70,0.87,0)
    btn.AnchorPoint = Vector2.new(0.5,0)
    btn.BackgroundColor3 = Color3.fromRGB(180,220,255)
    btn.BackgroundTransparency = 0.35
    btn.TextColor3 = Color3.fromRGB(0,70,150)
    btn.Text = "Shoot Murderer"
    btn.Font = Enum.Font.GothamBold
    btn.TextSize = 14
    btn.Parent = FloatingGui
    btn.Active = true
    btn.Draggable = true
    local corner = Instance.new("UICorner", btn)
    corner.CornerRadius = UDim.new(0,18)
    local stroke = Instance.new("UIStroke", btn)
    stroke.Thickness = 2.5
    stroke.ApplyStrokeMode = Enum.ApplyStrokeMode.Border
    stroke.Color = Color3.fromRGB(0,120,255)
    task.spawn(function()
        while btn.Parent do
            TweenService:Create(stroke, TweenInfo.new(0.8, Enum.EasingStyle.Sine, Enum.EasingDirection.InOut), {Color = Color3.fromRGB(0,80,255)}):Play()
            task.wait(0.8)
            TweenService:Create(stroke, TweenInfo.new(0.8, Enum.EasingStyle.Sine, Enum.EasingDirection.InOut), {Color = Color3.fromRGB(160,230,255)}):Play()
            task.wait(0.8)
        end
    end)
    btn.MouseButton1Click:Connect(function()
        shootMurderer()
    end)
    floatingShootButton = FloatingGui
end

GunTab:Button({
    Title="Shoot Murderer",
    Callback=function()
        shootMurderer()
    end
})

GunTab:Button({
    Title="Shoot Murderer (Mini Button)",
    Callback=function()
        createFloatingShootButton()
    end
})

local roleESP = {
    murder = false,
    sheriff = false,
    innocent = false
}

local espObjects = {}

local function clearESPObjects()
    for _,v in pairs(espObjects) do
        if v then v:Destroy() end
    end
    espObjects = {}
end

local function createESPRole(plr,color,text)
    if not plr.Character then return end
    local char = plr.Character
    local root = char:FindFirstChild("HumanoidRootPart")
    if not root then return end
    local highlight = Instance.new("Highlight")
    highlight.FillTransparency = 1
    highlight.OutlineColor = color
    highlight.OutlineTransparency = 0
    highlight.Parent = char
    local bill = Instance.new("BillboardGui")
    bill.Size = UDim2.new(0,120,0,40)
    bill.StudsOffset = Vector3.new(0,3,0)
    bill.AlwaysOnTop = true
    bill.Parent = root
    local label = Instance.new("TextLabel")
    label.Size = UDim2.new(1,0,1,0)
    label.BackgroundTransparency = 1
    label.TextColor3 = color
    label.TextStrokeTransparency = 0
    label.Font = Enum.Font.GothamBold
    label.TextScaled = true
    label.Text = text
    label.Parent = bill
    table.insert(espObjects,highlight)
    table.insert(espObjects,bill)
end

local function updateESPRole()
    clearESPObjects()
    for _,plr in pairs(Players:GetPlayers()) do
        if plr ~= player then
            local char = plr.Character
            local backpack = plr:FindFirstChild("Backpack")
            if char then
                local hasKnife = (char:FindFirstChild("Knife")) or (backpack and backpack:FindFirstChild("Knife"))
                local hasGun = (char:FindFirstChild("Gun")) or (backpack and backpack:FindFirstChild("Gun"))
                if roleESP.murder and hasKnife then
                    createESPRole(plr,Color3.fromRGB(255,0,0),"Murderer")
                end
                if roleESP.sheriff and hasGun then
                    createESPRole(plr,Color3.fromRGB(0,120,255),"Sheriff")
                end
                if roleESP.innocent and not hasKnife and not hasGun then
                    createESPRole(plr,Color3.fromRGB(0,255,120),"Innocents")
                end
            end
        end
    end
end

task.spawn(function()
    while true do
        task.wait(1)
        if roleESP.murder or roleESP.sheriff or roleESP.innocent then
            updateESPRole()
        end
    end
end)

MainTab:Toggle({
    Title="Enable ESP Murderer",
    Default=false,
    Callback=function(v)
        roleESP.murder = v
        updateESPRole()
    end
})

MainTab:Toggle({
    Title="Enable ESP Sheriff",
    Default=false,
    Callback=function(v)
        roleESP.sheriff = v
        updateESPRole()
    end
})

MainTab:Toggle({
    Title="Enable ESP Innocents",
    Default=false,
    Callback=function(v)
        roleESP.innocent = v
        updateESPRole()
    end
})

local flying = false
local autoReset = false
local flyMode = "normal"
local collectedCoins = {}
local startedCollecting = false
local flySpeed = 16

MapTab:Paragraph({
    Title = "Warning",
    Desc = "We recommend setting it to 19. Exceeding this risks a ban."
})

MapTab:Slider({
    Title = "Speed",
    Value = {Min = 1, Max = 26, Default = 16},
    Callback = function(v)
        flySpeed = v
    end
})

MapTab:Dropdown({
    Title = "Fly Mode",
    Values = {"normal", "down"},
    Default = "normal",
    Callback = function(v)
        flyMode = v
    end
})

MapTab:Toggle({
    Title = "Reset When Coins Run Out",
    Default = false,
    Callback = function(v)
        autoReset = v
    end
})

local function getChar()
    return player.Character or player.CharacterAdded:Wait()
end

local function noclipLoop(char)
    task.spawn(function()
        while flying and char.Parent do
            for _, v in pairs(char:GetDescendants()) do
                if v:IsA("BasePart") then
                    v.CanCollide = false
                end
            end
            RunService.Stepped:Wait()
        end
    end)
end

local function restoreChar()
    local char = getChar()
    local hum = char:WaitForChild("Humanoid")
    local hrp = char:WaitForChild("HumanoidRootPart")
    hum.PlatformStand = false
    hrp.AssemblyLinearVelocity = Vector3.zero
    for _, v in pairs(char:GetDescendants()) do
        if v:IsA("BasePart") then
            v.CanCollide = true
        end
    end
end

player.CharacterAdded:Connect(function(char)
    if not flying then return end
    char:WaitForChild("HumanoidRootPart")
    char:WaitForChild("Humanoid")
    local hrp = char:WaitForChild("HumanoidRootPart")
    local lastPos = hrp.Position
    repeat
        task.wait(0.2)
        local newPos = hrp.Position
        if (newPos - lastPos).Magnitude > 1 then
            lastPos = newPos
        else
            break
        end
    until not flying
    task.wait(0.3)
    if flying then
        for _, v in pairs(char:GetDescendants()) do
            if v:IsA("BasePart") then
                v.CanCollide = false
            end
        end
        noclipLoop(char)
    end
end)

local function getNearestCoin(root)
    local nearest
    local dist = math.huge
    for _, v in pairs(workspace:GetDescendants()) do
        if v.Name == "Coin_Server" and v:IsA("BasePart") and v:FindFirstChild("TouchInterest") and v:FindFirstChild("CoinVisual") and not collectedCoins[v] and not v:GetAttribute("Collected") then
            local d = (root.Position - v.Position).Magnitude
            if d < dist then
                dist = d
                nearest = v
            end
        end
    end
    return nearest
end

local function flyToCoin(targetPart)
    local char = getChar()
    local hrp = char:WaitForChild("HumanoidRootPart")
    local hum = char:WaitForChild("Humanoid")
    hum.PlatformStand = true
    local timeout = tick() + 10
    while flying and char.Parent and targetPart.Parent do
        if tick() > timeout then break end
        if targetPart:GetAttribute("Collected") then break end
        local targetPos = targetPart.Position
        if flyMode == "down" then
            targetPos = targetPos - Vector3.new(0, 3, 0)
        end
        local dir = (targetPos - hrp.Position).Unit
        hrp.AssemblyLinearVelocity = dir * flySpeed
        if flyMode == "down" then
            hrp.CFrame = CFrame.new(hrp.Position, targetPart.Position) * CFrame.Angles(math.rad(90), 0, 0)
        else
            hrp.CFrame = CFrame.new(hrp.Position, targetPart.Position)
        end
        if (hrp.Position - targetPos).Magnitude < 2 then
            hrp.CFrame = CFrame.new(targetPos)
            break
        end
        RunService.RenderStepped:Wait()
    end
    hrp.AssemblyLinearVelocity = Vector3.zero
    collectedCoins[targetPart] = true
    startedCollecting = true
end

MapTab:Toggle({
    Title = "Enable Auto Farm Coins",
    Default = false,
    Callback = function(state)
        flying = state
        collectedCoins = {}
        startedCollecting = false
        local char = getChar()
        if not state then restoreChar() return end
        noclipLoop(char)
        task.spawn(function()
            while flying do
                local ok, err = pcall(function()
                    local char = getChar()
                    local root = char:WaitForChild("HumanoidRootPart", 5)
                    if not root then return end
                    local coin = getNearestCoin(root)
                    if coin then
                        flyToCoin(coin)
                    else
                        if autoReset and startedCollecting then
                            if char then char:BreakJoints() end
                            task.wait(2)
                            startedCollecting = false
                        end
                        task.wait(0.1)
                    end
                end)
                if not ok then
                    warn("CoinFarm error: " .. tostring(err))
                    task.wait(0.5)
                end
            end
        end)
    end
})

local AntiAFKConnection

MapTab:Toggle({
    Title = "Enable Anti AFK",
    Default = true,
    Callback = function(state)
        if state then
            if not AntiAFKConnection then
                AntiAFKConnection = player.Idled:Connect(function()
                    pcall(function()
                        local VirtualUser = game:GetService("VirtualUser")
                        VirtualUser:Button2Down(Vector2.new(0,0), workspace.CurrentCamera.CFrame)
                        task.wait(1)
                        VirtualUser:Button2Up(Vector2.new(0,0), workspace.CurrentCamera.CFrame)
                    end)
                end)
            end
        else
            if AntiAFKConnection then
                AntiAFKConnection:Disconnect()
                AntiAFKConnection = nil
            end
        end
    end
})

MapTab:GetToggle("Enable Anti AFK"):SetState(true)
