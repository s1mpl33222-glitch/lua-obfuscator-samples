--==================================================
-- ELLA MAIN DA HOOD - CUTE PROFILE & UI CUSTOMIZER
--==================================================
-- Updated with multiple valid access keys ♡
local validKeys = {
    ["love_ella"] = true,
    ["ellalove"] = true,
    ["lovella"] = true,
    ["ellalovesyou"] = true
}

-- Key System Prompt UI
local CoreGui = game:GetService("CoreGui")
if CoreGui:FindFirstChild("EllarougKeyUI") then CoreGui.EllarougKeyUI:Destroy() end

local KeyGui = Instance.new("ScreenGui")
KeyGui.Name = "EllarougKeyUI"
KeyGui.Parent = CoreGui

local KeyFrame = Instance.new("Frame", KeyGui)
KeyFrame.Size = UDim2.new(0, 320, 0, 160)
KeyFrame.Position = UDim2.new(0.5, -160, 0.5, -80)
KeyFrame.BackgroundColor3 = Color3.fromRGB(245, 242, 235)
KeyFrame.BorderSizePixel = 0
Instance.new("UICorner", KeyFrame).CornerRadius = UDim.new(0, 12)
local KeyStroke = Instance.new("UIStroke", KeyFrame)
KeyStroke.Color = Color3.fromRGB(185, 164, 147)
KeyStroke.Thickness = 2

local KeyTitle = Instance.new("TextLabel", KeyFrame)
KeyTitle.Size = UDim2.new(1, 0, 0, 35)
KeyTitle.Position = UDim2.new(0, 0, 0, 10)
KeyTitle.BackgroundTransparency = 1
KeyTitle.Text = "♡ enter key to access ♡"
KeyTitle.TextColor3 = Color3.fromRGB(75, 65, 55)
KeyTitle.Font = Enum.Font.SourceSansBold
KeyTitle.TextSize = 15

local KeyBox = Instance.new("TextBox", KeyFrame)
KeyBox.Size = UDim2.new(0.8, 0, 0, 32)
KeyBox.Position = UDim2.new(0.1, 0, 0, 55)
KeyBox.BackgroundColor3 = Color3.fromRGB(250, 248, 243)
KeyBox.PlaceholderText = "type key here..."
KeyBox.Text = ""
KeyBox.TextColor3 = Color3.fromRGB(75, 65, 55)
KeyBox.Font = Enum.Font.GothamBold
KeyBox.TextSize = 12
Instance.new("UICorner", KeyBox).CornerRadius = UDim.new(0, 8)
local BoxStroke = Instance.new("UIStroke", KeyBox)
BoxStroke.Color = Color3.fromRGB(205, 194, 182)

local SubmitBtn = Instance.new("TextButton", KeyFrame)
SubmitBtn.Size = UDim2.new(0.5, 0, 0, 30)
SubmitBtn.Position = UDim2.new(0.25, 0, 0, 105)
SubmitBtn.BackgroundColor3 = Color3.fromRGB(185, 164, 147)
SubmitBtn.Text = "submit ♡"
SubmitBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
SubmitBtn.Font = Enum.Font.SourceSansBold
SubmitBtn.TextSize = 13
Instance.new("UICorner", SubmitBtn).CornerRadius = UDim.new(0, 8)

local keyUnlocked = false
SubmitBtn.MouseButton1Click:Connect(function()
    if validKeys[KeyBox.Text] then
        keyUnlocked = true
        KeyGui:Destroy()
    else
        KeyBox.Text = ""
        KeyBox.PlaceholderText = "wrong key! try again ♡"
    end
end)

repeat task.wait() until keyUnlocked

-- Main Script Execution & Setup
local UIS = game:GetService("UserInputService")
local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local Lighting = game:GetService("Lighting")
local ReplicatedStorage = game:GetService("ReplicatedStorage")

local lp = Players.LocalPlayer
while not lp do
    task.wait()
    lp = Players.LocalPlayer
end

local cam = workspace.CurrentCamera
local mouse = lp:GetMouse()

game:GetService("StarterGui"):SetCore("SendNotification", {
    Title = "♡ ella main dahood ♡",
    Text = "bunny latte script loaded successfully ♡",
    Duration = 5
})

local originalFogStart = Lighting.FogStart
local originalFogEnd = Lighting.FogEnd
local originalFogColor = Lighting.FogColor

local cfg = {
    silentAim = true,
    silentAimFOV = 150,
    silentAimFOVShow = false,
    silentAimColor = Color3.fromRGB(255, 105, 180),
    silentAimPart = "Head",
    silentAimClosestPart = false,
    silentAimWallCheck = false,
    bypassRevolver = false,
    uiToggleKey = Enum.KeyCode.RightControl,
    
    hitboxEnabled = false,
    hitboxSize = 4,
    hitboxTransparency = 0.7,
    hitboxColor = Color3.fromRGB(255, 105, 180),
    
    fogEnabled = false,
    fogColor = Color3.fromRGB(255, 105, 180),
    fogStart = 0,
    fogEnd = 250,
    
    speedEnabled = false,
    speedValue = 50,
    speedKey = Enum.KeyCode.X,
    speedActive = false,
    
    jumpEnabled = false,
    jumpValue = 50,
    jumpKey = Enum.KeyCode.C,
    jumpActive = false,
    
    camlockEnabled = false,
    camlockActive = false,
    camlockSmoothness = 0.25,
    camlockKey = Enum.KeyCode.Q,
    camlockPart = "Head",
    camlockTarget = nil,
    
    whitelisted = {}
}

local bodyPartsList = {
    "Head", "HumanoidRootPart", "LeftUpperLeg", "LeftLowerLeg", "LeftFoot", 
    "RightUpperLeg", "RightLowerLeg", "RightFoot", "LeftUpperArm", 
    "LeftLowerArm", "LeftHand", "RightUpperArm", "RightLowerArm", "RightHand"
}

local function isWhitelisted(player)
    return cfg.whitelisted[player.Name] == true or cfg.whitelisted[player.UserId] == true
end

local function getClosestPart(char)
    local closest = nil
    local shortestDist = math.huge
    local mousePos = Vector2.new(mouse.X, mouse.Y)
    for _, partName in pairs(bodyPartsList) do
        local p = char:FindFirstChild(partName)
        if p then
            local screenPos, onScreen = cam:WorldToScreenPoint(p.Position)
            if onScreen then
                local dist = (Vector2.new(screenPos.X, screenPos.Y) - mousePos).Magnitude
                if dist < shortestDist then shortestDist = dist closest = p end
            end
        end
    end
    return closest or char:FindFirstChild("Head")
end

local function getClosestPlayer()
    local mousePos = Vector2.new(mouse.X, mouse.Y)
    local bestPlayer = nil
    local bestDist = math.huge
    for _, v in pairs(Players:GetPlayers()) do
        if v ~= lp and not isWhitelisted(v) and v.Character and v.Character:FindFirstChild("Humanoid") and v.Character.Humanoid.Health > 0 then
            local part = v.Character:FindFirstChild("Head") or v.Character:FindFirstChild("HumanoidRootPart")
            if part then
                local screenPos, onScreen = cam:WorldToScreenPoint(part.Position)
                if onScreen then
                    local dist = (Vector2.new(screenPos.X, screenPos.Y) - mousePos).Magnitude
                    if dist < bestDist then
                        bestDist = dist
                        bestPlayer = v
                    end
                end
            end
        end
    end
    return bestPlayer
end

local function getClosest()
    local mousePos = Vector2.new(mouse.X, mouse.Y)
    local best = nil
    local bestDist = cfg.silentAimFOV
    for _, v in pairs(Players:GetPlayers()) do
        if v ~= lp and not isWhitelisted(v) and v.Character and v.Character:FindFirstChild("Humanoid") and v.Character.Humanoid.Health > 0 then
            local part
            if cfg.silentAimClosestPart then
                part = getClosestPart(v.Character)
            else
                part = v.Character:FindFirstChild(cfg.silentAimPart) or v.Character:FindFirstChild("Head")
            end
            
            if part then
                local screenPos, onScreen = cam:WorldToScreenPoint(part.Position)
                if onScreen then
                    local screenVec = Vector2.new(screenPos.X, screenPos.Y)
                    local dist = (screenVec - mousePos).Magnitude
                    if dist < bestDist then
                        if cfg.silentAimWallCheck then
                            local ray = Ray.new(cam.CFrame.Position, (part.Position - cam.CFrame.Position).Unit * 500)
                            local hit = workspace:FindPartOnRayWithIgnoreList(ray, {lp.Character, cam})
                            if hit and hit:IsDescendantOf(v.Character) then bestDist = dist best = part end
                        else bestDist = dist best = part end
                    end
                end
            end
        end
    end
    return best
end

local handler, oldFunc = nil, nil
pcall(function()
    local modules = ReplicatedStorage:FindFirstChild("Modules")
    if modules and modules:FindFirstChild("GunHandler") then
        handler = require(modules.GunHandler)
        if handler and handler.getAim then oldFunc = handler.getAim end
    end
end)

if handler and oldFunc then
    handler.getAim = function(origin, maxDist)
        if not cfg.silentAim then return oldFunc(origin, maxDist) end
        if cfg.bypassRevolver then
            local currentTool = lp.Character and lp.Character:FindFirstChildOfClass("Tool")
            if currentTool and (currentTool.Name == "[Revolver]" or currentTool.Name == "Revolver") then return oldFunc(origin, maxDist) end
        end
        local target = getClosest()
        if target then
            local dir = (target.Position - origin).Unit
            return dir, maxDist
        end
        return oldFunc(origin, maxDist)
    end
end

if CoreGui:FindFirstChild("EllarougHoodCustomUI") then CoreGui.EllarougHoodCustomUI:Destroy() end

local ScreenGui = Instance.new("ScreenGui")
ScreenGui.Name = "EllarougHoodCustomUI"
ScreenGui.ResetOnSpawn = false
ScreenGui.IgnoreGuiInset = true
ScreenGui.DisplayOrder = 10000
ScreenGui.Parent = CoreGui

local fovCircle = Drawing.new("Circle")
fovCircle.Thickness = 2
fovCircle.NumSides = 64
fovCircle.Filled = false
fovCircle.Transparency = 0.85
fovCircle.Visible = false

RunService.RenderStepped:Connect(function()
    if cfg.silentAimFOVShow then
        fovCircle.Visible = true
        fovCircle.Radius = cfg.silentAimFOV
        fovCircle.Position = Vector2.new(mouse.X, mouse.Y + 36)
        fovCircle.Color = cfg.silentAimColor
    else
        fovCircle.Visible = false
    end

    for _, v in pairs(Players:GetPlayers()) do
        if v ~= lp and v.Character and v.Character:FindFirstChild("HumanoidRootPart") then
            local hrp = v.Character.HumanoidRootPart
            if cfg.hitboxEnabled then
                hrp.Size = Vector3.new(cfg.hitboxSize, cfg.hitboxSize, cfg.hitboxSize)
                hrp.Transparency = cfg.hitboxTransparency
                hrp.Color = cfg.hitboxColor
                hrp.Material = Enum.Material.Neon
                hrp.CanCollide = false
            else
                hrp.Size = Vector3.new(2, 2, 1)
                hrp.Transparency = 1
                hrp.Material = Enum.Material.Plastic
                hrp.CanCollide = true
            end
        end
    end

    local char = lp.Character
    local hum = char and char:FindFirstChildOfClass("Humanoid")
    if hum then
        if cfg.speedEnabled and cfg.speedActive then
            hum.WalkSpeed = cfg.speedValue
        end

        if cfg.jumpEnabled and cfg.jumpActive then
            hum.JumpPower = cfg.jumpValue
            if hum.UseJumpPower == false then
                pcall(function() hum.JumpHeight = cfg.jumpValue / 7.2 end)
            end
        end
    end

    if cfg.camlockEnabled and cfg.camlockActive then
        if not cfg.camlockTarget or not cfg.camlockTarget.Character or not cfg.camlockTarget.Character:FindFirstChild("Humanoid") or cfg.camlockTarget.Character.Humanoid.Health <= 0 then
            cfg.camlockTarget = getClosestPlayer()
        end
        if cfg.camlockTarget and cfg.camlockTarget.Character and not isWhitelisted(cfg.camlockTarget) then
            local part = cfg.camlockTarget.Character:FindFirstChild(cfg.camlockPart) or cfg.camlockTarget.Character:FindFirstChild("Head")
            if part then
                local targetCFrame = CFrame.new(cam.CFrame.Position, part.Position)
                cam.CFrame = cam.CFrame:Lerp(targetCFrame, math.clamp(cfg.camlockSmoothness, 0.01, 1))
            end
        end
    else
        cfg.camlockTarget = nil
    end
    
    if cfg.fogEnabled then
        Lighting.FogStart = cfg.fogStart
        Lighting.FogEnd = cfg.fogEnd
        Lighting.FogColor = cfg.fogColor
    else
        Lighting.FogStart = originalFogStart
        Lighting.FogEnd = originalFogEnd
        Lighting.FogColor = originalFogColor
    end
end)

-- Theme Palette State
local currentTheme = {
    ACCENT = Color3.fromRGB(185, 164, 147),
    BG = Color3.fromRGB(245, 242, 235),
    CARD_BG = Color3.fromRGB(250, 248, 243),
    CARD = Color3.fromRGB(238, 234, 226),
    SOFT_TEXT = Color3.fromRGB(75, 65, 55),
    SUB_TEXT = Color3.fromRGB(135, 118, 104),
    LIGHT_BTN = Color3.fromRGB(230, 224, 215),
    TOGGLE_OFF = Color3.fromRGB(215, 208, 198),
    STROKE = Color3.fromRGB(205, 194, 182),
    SLIDER_BG = Color3.fromRGB(230, 224, 215)
}

local Main = Instance.new("Frame", ScreenGui)
Main.Name = "Main"
Main.ClipsDescendants = true
Main.Size = UDim2.new(0, 560, 0, 480)
Main.Position = UDim2.new(0.5, -280, 0.5, -240)
Main.BackgroundColor3 = currentTheme.BG
Main.BorderSizePixel = 0
Main.Active = true

Instance.new("UICorner", Main).CornerRadius = UDim.new(0, 14)
local MainStroke = Instance.new("UIStroke", Main)
MainStroke.Color = currentTheme.ACCENT
MainStroke.Thickness = 2

-- Real Roblox Profile Avatar Thumbnail Frame on the Left
local AvatarHolder = Instance.new("Frame", Main)
AvatarHolder.Size = UDim2.new(0, 38, 0, 38)
AvatarHolder.Position = UDim2.new(0, 8, 0, 4)
AvatarHolder.BackgroundColor3 = currentTheme.CARD
AvatarHolder.BorderSizePixel = 0
Instance.new("UICorner", AvatarHolder).CornerRadius = UDim.new(0, 8)
local AvatarStroke = Instance.new("UIStroke", AvatarHolder)
AvatarStroke.Color = currentTheme.STROKE
AvatarStroke.Thickness = 1

local AvatarImg = Instance.new("ImageLabel", AvatarHolder)
AvatarImg.Size = UDim2.new(1, 0, 1, 0)
AvatarImg.BackgroundTransparency = 1
Instance.new("UICorner", AvatarImg).CornerRadius = UDim.new(0, 8)

task.spawn(function()
    pcall(function()
        local content = Players:GetUserThumbnailAsync(lp.UserId, Enum.ThumbnailType.AvatarBust, Enum.ThumbnailSize.Size420x420)
        AvatarImg.Image = content
    end)
end)

local Header = Instance.new("Frame", Main)
Header.Name = "Header"
Header.Size = UDim2.new(1, -60, 0, 45)
Header.Position = UDim2.new(0, 52, 0, 0)
Header.BackgroundTransparency = 1

local Title = Instance.new("TextLabel", Header)
Title.Size = UDim2.new(1, 0, 0, 18)
Title.Position = UDim2.new(0, 5, 0, 4)
Title.BackgroundTransparency = 1
Title.Text = "♡ ella main dahood ♡"
Title.TextColor3 = currentTheme.SOFT_TEXT
Title.TextSize = 12
Title.Font = Enum.Font.SourceSansBold
Title.TextXAlignment = Enum.TextXAlignment.Left

local UserSubTitle = Instance.new("TextLabel", Header)
UserSubTitle.Size = UDim2.new(1, 0, 0, 15)
UserSubTitle.Position = UDim2.new(0, 5, 0, 22)
UserSubTitle.BackgroundTransparency = 1
UserSubTitle.Text = lp.DisplayName .. " - id: " .. lp.UserId
UserSubTitle.TextColor3 = currentTheme.SUB_TEXT
UserSubTitle.TextSize = 10
UserSubTitle.Font = Enum.Font.GothamBold
UserSubTitle.TextXAlignment = Enum.TextXAlignment.Left

local TabBar = Instance.new("ScrollingFrame", Main)
TabBar.Size = UDim2.new(1, -16, 0, 30)
TabBar.Position = UDim2.new(0, 8, 0, 48)
TabBar.BackgroundTransparency = 1
TabBar.BorderSizePixel = 0
TabBar.CanvasSize = UDim2.new(0, 420, 0, 0)
TabBar.ScrollBarThickness = 0

local TabListLayout = Instance.new("UIListLayout", TabBar)
TabListLayout.FillDirection = Enum.FillDirection.Horizontal
TabListLayout.SortOrder = Enum.SortOrder.LayoutOrder
TabListLayout.Padding = UDim.new(0, 4)

local dragging, dragStart, startPos
Main.InputBegan:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseButton1 then
        dragging = true
        dragStart = input.Position
        startPos = Main.Position
    end
end)
Main.InputEnded:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseButton1 then
        dragging = false
    end
end)
UIS.InputChanged:Connect(function(input)
    if dragging and input.UserInputType == Enum.UserInputType.MouseMovement then
        local delta = input.Position - dragStart
        Main.Position = UDim2.new(
            startPos.X.Scale, startPos.X.Offset + delta.X,
            startPos.Y.Scale, startPos.Y.Offset + delta.Y
        )
    end
end)

local Content = Instance.new("Frame", Main)
Content.Size = UDim2.new(1, -16, 1, -92)
Content.Position = UDim2.new(0, 8, 0, 84)
Content.BackgroundColor3 = currentTheme.CARD_BG
Content.BorderSizePixel = 0
Instance.new("UICorner", Content).CornerRadius = UDim.new(0, 10)

local pages = {}
local tabButtons = {}

local function createPage(pageName, titleText, descText)
    local pageScroll = Instance.new("ScrollingFrame", Content)
    pageScroll.Size = UDim2.new(1, -12, 1, -12)
    pageScroll.Position = UDim2.new(0, 6, 0, 6)
    pageScroll.BackgroundTransparency = 1
    pageScroll.BorderSizePixel = 0
    pageScroll.ScrollBarThickness = 3
    pageScroll.ScrollBarImageColor3 = currentTheme.ACCENT
    pageScroll.Visible = false

    local pList = Instance.new("UIListLayout", pageScroll)
    pList.SortOrder = Enum.SortOrder.LayoutOrder
    pList.Padding = UDim.new(0, 6)

    pList:GetPropertyChangedSignal("AbsoluteContentSize"):Connect(function()
        pageScroll.CanvasSize = UDim2.new(0, 0, 0, pList.AbsoluteContentSize.Y + 12)
    end)

    local headerFrame = Instance.new("Frame", pageScroll)
    headerFrame.Size = UDim2.new(1, 0, 0, 32)
    headerFrame.BackgroundTransparency = 1

    local pTitle = Instance.new("TextLabel", headerFrame)
    pTitle.Name = "PageTitle"
    pTitle.Size = UDim2.new(1, 0, 0, 18)
    pTitle.BackgroundTransparency = 1
    pTitle.Text = "♡ " .. titleText .. " ♡"
    pTitle.TextColor3 = currentTheme.SOFT_TEXT
    pTitle.Font = Enum.Font.SourceSansBold
    pTitle.TextSize = 14
    pTitle.TextXAlignment = Enum.TextXAlignment.Left

    local pDesc = Instance.new("TextLabel", headerFrame)
    pDesc.Name = "PageDesc"
    pDesc.Size = UDim2.new(1, 0, 0, 14)
    pDesc.Position = UDim2.new(0, 0, 0, 18)
    pDesc.BackgroundTransparency = 1
    pDesc.Text = descText or ""
    pDesc.TextColor3 = currentTheme.SUB_TEXT
    pDesc.Font = Enum.Font.GothamBold
    pDesc.TextSize = 10
    pDesc.TextXAlignment = Enum.TextXAlignment.Left

    pages[pageName] = pageScroll
    return pageScroll
end

local function addTab(labelText, pageName)
    local btn = Instance.new("TextButton", TabBar)
    btn.Size = UDim2.new(0, 55, 0, 28)
    btn.BackgroundColor3 = currentTheme.LIGHT_BTN
    btn.BackgroundTransparency = 1
    btn.Text = ""
    btn.AutoButtonColor = false
    Instance.new("UICorner", btn).CornerRadius = UDim.new(0, 6)

    local lbl = Instance.new("TextLabel", btn)
    lbl.Size = UDim2.new(1, 0, 1, 0)
    lbl.BackgroundTransparency = 1
    lbl.Text = labelText
    lbl.TextColor3 = currentTheme.SUB_TEXT
    lbl.Font = Enum.Font.SourceSansBold
    lbl.TextSize = 11
    lbl.TextXAlignment = Enum.TextXAlignment.Center

    tabButtons[pageName] = {Button = btn, Label = lbl}

    btn.MouseButton1Click:Connect(function()
        for pName, pFrame in pairs(pages) do
            pFrame.Visible = (pName == pageName)
        end
        for pName, data in pairs(tabButtons) do
            if pName == pageName then
                data.Button.BackgroundTransparency = 0
                data.Label.TextColor3 = currentTheme.SOFT_TEXT
            else
                data.Button.BackgroundTransparency = 1
                data.Label.TextColor3 = currentTheme.SUB_TEXT
            end
        end
    end)
end

local silentAimPage = createPage("silentAim", "silent aim", "aim accuracy tools")
local camlockPage = createPage("camlock", "camlock", "camera lock & tracking")
local hitboxPage = createPage("hitbox", "hitbox", "player hitbox expander")
local visualsPage = createPage("visuals", "visuals", "speed & jump movement")
local fogPage = createPage("fog", "fog", "atmosphere & world fog settings")
local whitelistPage = createPage("whitelist", "whitelist", "whitelisted friends & players")
local themePage = createPage("theme", "ui customizer", "personalize your colors & theme")

addTab("aim", "silentAim")
addTab("cam", "camlock")
addTab("hit", "hitbox")
addTab("move", "visuals")
addTab("fog", "fog")
addTab("list", "whitelist")
addTab("theme", "theme")

local function createCard(parentPage, height)
    local card = Instance.new("Frame", parentPage)
    card.Size = UDim2.new(1, -4, 0, height or 36)
    card.BackgroundColor3 = currentTheme.CARD
    card.BorderSizePixel = 0
    card.ClipsDescendants = true
    Instance.new("UICorner", card).CornerRadius = UDim.new(0, 8)
    local s = Instance.new("UIStroke", card)
    s.Name = "CardStroke"
    s.Color = currentTheme.STROKE
    s.Thickness = 1
    return card
end

local function addToggle(parentPage, text, subtext, default, callback)
    local card = createCard(parentPage, 36)
    local lbl = Instance.new("TextLabel", card)
    lbl.Name = "CardLabel"
    lbl.Size = UDim2.new(0.65, 0, 0, 16)
    lbl.Position = UDim2.new(0, 10, 0, 3)
    lbl.BackgroundTransparency = 1
    lbl.Text = text
    lbl.TextColor3 = currentTheme.SOFT_TEXT
    lbl.Font = Enum.Font.SourceSansBold
    lbl.TextSize = 12
    lbl.TextXAlignment = Enum.TextXAlignment.Left

    local sub = Instance.new("TextLabel", card)
    sub.Name = "CardSub"
    sub.Size = UDim2.new(0.65, 0, 0, 14)
    sub.Position = UDim2.new(0, 10, 0, 18)
    sub.BackgroundTransparency = 1
    sub.Text = subtext or ""
    sub.TextColor3 = currentTheme.SUB_TEXT
    sub.Font = Enum.Font.GothamBold
    sub.TextSize = 10
    sub.TextXAlignment = Enum.TextXAlignment.Left

    local btn = Instance.new("TextButton", card)
    btn.Name = "ToggleBtn"
    btn.Size = UDim2.new(0, 36, 0, 18)
    btn.Position = UDim2.new(1, -44, 0, 9)
    btn.BackgroundColor3 = default and currentTheme.ACCENT or currentTheme.TOGGLE_OFF
    btn.Text = ""
    btn.AutoButtonColor = false
    Instance.new("UICorner", btn).CornerRadius = UDim.new(1, 0)

    local circle = Instance.new("Frame", btn)
    circle.Size = UDim2.new(0, 14, 0, 14)
    circle.Position = default and UDim2.new(1, -16, 0.5, -7) or UDim2.new(0, 2, 0.5, -7)
    circle.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
    Instance.new("UICorner", circle).CornerRadius = UDim.new(1, 0)

    local state = default
    local function setToggleState(newState)
        state = newState
        btn.BackgroundColor3 = state and currentTheme.ACCENT or currentTheme.TOGGLE_OFF
        circle:TweenPosition(
            state and UDim2.new(1, -16, 0.5, -7) or UDim2.new(0, 2, 0.5, -7),
            Enum.EasingDirection.Out, Enum.EasingStyle.Quad, 0.1, true
        )
        callback(state)
    end

    btn.MouseButton1Click:Connect(function() setToggleState(not state) end)
    return setToggleState
end

local function addSlider(parentPage, text, min, max, default, callback)
    local card = createCard(parentPage, 40)
    local lbl = Instance.new("TextLabel", card)
    lbl.Name = "CardLabel"
    lbl.Size = UDim2.new(0.65, 0, 0, 15)
    lbl.Position = UDim2.new(0, 10, 0, 3)
    lbl.BackgroundTransparency = 1
    lbl.Text = text
    lbl.TextColor3 = currentTheme.SOFT_TEXT
    lbl.Font = Enum.Font.SourceSansBold
    lbl.TextSize = 12
    lbl.TextXAlignment = Enum.TextXAlignment.Left

    local valLbl = Instance.new("TextLabel", card)
    valLbl.Name = "ValueLabel"
    valLbl.Size = UDim2.new(0.25, 0, 0, 15)
    valLbl.Position = UDim2.new(0, 10, 0, 15)
    valLbl.BackgroundTransparency = 1
    valLbl.Text = tostring(default)
    valLbl.TextColor3 = currentTheme.ACCENT
    valLbl.Font = Enum.Font.SourceSansBold
    valLbl.TextSize = 11
    valLbl.TextXAlignment = Enum.TextXAlignment.Left

    local bg = Instance.new("Frame", card)
    bg.Name = "SliderBG"
    bg.Size = UDim2.new(1, -20, 0, 5)
    bg.Position = UDim2.new(0, 10, 0, 30)
    bg.BackgroundColor3 = currentTheme.SLIDER_BG
    Instance.new("UICorner", bg).CornerRadius = UDim.new(1, 0)

    local fill = Instance.new("Frame", bg)
    fill.Name = "SliderFill"
    fill.Size = UDim2.new((default - min) / (max - min), 0, 1, 0)
    fill.BackgroundColor3 = currentTheme.ACCENT
    Instance.new("UICorner", fill).CornerRadius = UDim.new(1, 0)

    local knob = Instance.new("Frame", bg)
    knob.Size = UDim2.new(0, 11, 0, 11)
    knob.AnchorPoint = Vector2.new(0.5, 0.5)
    knob.Position = UDim2.new((default - min) / (max - min), 0, 0.5, 0)
    knob.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
    Instance.new("UICorner", knob).CornerRadius = UDim.new(1, 0)

    local sDragging = false
    local function update(input)
        local pos = math.clamp((input.Position.X - bg.AbsolutePosition.X) / bg.AbsoluteSize.X, 0, 1)
        local val = math.floor(min + (max - min) * pos)
        fill.Size = UDim2.new(pos, 0, 1, 0)
        knob.Position = UDim2.new(pos, 0, 0.5, 0)
        valLbl.Text = tostring(val)
        callback(val)
    end
    bg.InputBegan:Connect(function(input) if input.UserInputType == Enum.UserInputType.MouseButton1 then sDragging = true update(input) end end)
    UIS.InputEnded:Connect(function(input) if input.UserInputType == Enum.UserInputType.MouseButton1 then sDragging = false end end)
    UIS.InputChanged:Connect(function(input) if sDragging and input.UserInputType == Enum.UserInputType.MouseMovement then update(input) end end)
end

local function addFloatSlider(parentPage, text, min, max, default, callback)
    local card = createCard(parentPage, 40)
    local lbl = Instance.new("TextLabel", card)
    lbl.Name = "CardLabel"
    lbl.Size = UDim2.new(0.65, 0, 0, 15)
    lbl.Position = UDim2.new(0, 10, 0, 3)
    lbl.BackgroundTransparency = 1
    lbl.Text = text
    lbl.TextColor3 = currentTheme.SOFT_TEXT
    lbl.Font = Enum.Font.SourceSansBold
    lbl.TextSize = 12
    lbl.TextXAlignment = Enum.TextXAlignment.Left

    local valLbl = Instance.new("TextLabel", card)
    valLbl.Name = "ValueLabel"
    valLbl.Size = UDim2.new(0.25, 0, 0, 15)
    valLbl.Position = UDim2.new(0, 10, 0, 15)
    valLbl.BackgroundTransparency = 1
    valLbl.Text = string.format("%.2f", default)
    valLbl.TextColor3 = currentTheme.ACCENT
    valLbl.Font = Enum.Font.SourceSansBold
    valLbl.TextSize = 11
    valLbl.TextXAlignment = Enum.TextXAlignment.Left

    local bg = Instance.new("Frame", card)
    bg.Name = "SliderBG"
    bg.Size = UDim2.new(1, -20, 0, 5)
    bg.Position = UDim2.new(0, 10, 0, 30)
    bg.BackgroundColor3 = currentTheme.SLIDER_BG
    Instance.new("UICorner", bg).CornerRadius = UDim.new(1, 0)

    local fill = Instance.new("Frame", bg)
    fill.Name = "SliderFill"
    fill.Size = UDim2.new((default - min) / (max - min), 0, 1, 0)
    fill.BackgroundColor3 = currentTheme.ACCENT
    Instance.new("UICorner", fill).CornerRadius = UDim.new(1, 0)

    local knob = Instance.new("Frame", bg)
    knob.Size = UDim2.new(0, 11, 0, 11)
    knob.AnchorPoint = Vector2.new(0.5, 0.5)
    knob.Position = UDim2.new((default - min) / (max - min), 0, 0.5, 0)
    knob.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
    Instance.new("UICorner", knob).CornerRadius = UDim.new(1, 0)

    local sDragging = false
    local function update(input)
        local pos = math.clamp((input.Position.X - bg.AbsolutePosition.X) / bg.AbsoluteSize.X, 0, 1)
        local val = min + (max - min) * pos
        fill.Size = UDim2.new(pos, 0, 1, 0)
        knob.Position = UDim2.new(pos, 0, 0.5, 0)
        valLbl.Text = string.format("%.2f", val)
        callback(val)
    end
    bg.InputBegan:Connect(function(input) if input.UserInputType == Enum.UserInputType.MouseButton1 then sDragging = true update(input) end end)
    UIS.InputEnded:Connect(function(input) if input.UserInputType == Enum.UserInputType.MouseButton1 then sDragging = false end end)
    UIS.InputChanged:Connect(function(input) if sDragging and input.UserInputType == Enum.UserInputType.MouseMovement then update(input) end end)
end

local function addKeybindPicker(parentPage, text, currentKey, callback)
    local card = createCard(parentPage, 36)
    local lbl = Instance.new("TextLabel", card)
    lbl.Name = "CardLabel"
    lbl.Size = UDim2.new(0.65, 0, 1, 0)
    lbl.Position = UDim2.new(0, 10, 0, 0)
    lbl.BackgroundTransparency = 1
    lbl.Text = text
    lbl.TextColor3 = currentTheme.SOFT_TEXT
    lbl.Font = Enum.Font.SourceSansBold
    lbl.TextSize = 12
    lbl.TextXAlignment = Enum.TextXAlignment.Left

    local keyBtn = Instance.new("TextButton", card)
    keyBtn.Size = UDim2.new(0, 52, 0, 22)
    keyBtn.Position = UDim2.new(1, -58, 0.5, -11)
    keyBtn.BackgroundColor3 = currentTheme.LIGHT_BTN
    keyBtn.Text = currentKey.Name
    keyBtn.TextColor3 = currentTheme.SOFT_TEXT
    keyBtn.Font = Enum.Font.SourceSansBold
    keyBtn.TextSize = 11
    keyBtn.AutoButtonColor = false
    Instance.new("UICorner", keyBtn).CornerRadius = UDim.new(0, 6)

    local listening = false
    keyBtn.MouseButton1Click:Connect(function()
        if listening then return end
        listening = true
        keyBtn.Text = "..."
        keyBtn.BackgroundColor3 = currentTheme.ACCENT
        keyBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
        local connection
        connection = UIS.InputBegan:Connect(function(input)
            if input.UserInputType == Enum.UserInputType.Keyboard then
                local newKey = input.KeyCode
                keyBtn.Text = newKey.Name
                keyBtn.BackgroundColor3 = currentTheme.LIGHT_BTN
                keyBtn.TextColor3 = currentTheme.SOFT_TEXT
                listening = false
                callback(newKey)
                connection:Disconnect()
            end
        end)
    end)
end

local function addDropdown(parentPage, text, list, default, callback)
    local card = createCard(parentPage, 36)
    local topFrame = Instance.new("Frame", card)
    topFrame.Size = UDim2.new(1, 0, 0, 36)
    topFrame.BackgroundTransparency = 1

    local lbl = Instance.new("TextLabel", topFrame)
    lbl.Name = "CardLabel"
    lbl.Size = UDim2.new(0.42, 0, 1, 0)
    lbl.Position = UDim2.new(0, 10, 0, 0)
    lbl.BackgroundTransparency = 1
    lbl.Text = text
    lbl.TextColor3 = currentTheme.SOFT_TEXT
    lbl.Font = Enum.Font.SourceSansBold
    lbl.TextSize = 12
    lbl.TextXAlignment = Enum.TextXAlignment.Left

    local btn = Instance.new("TextButton", topFrame)
    btn.Size = UDim2.new(0.52, 0, 0, 22)
    btn.Position = UDim2.new(0.44, 0, 0.5, -11)
    btn.BackgroundColor3 = currentTheme.LIGHT_BTN
    btn.Text = default
    btn.TextColor3 = currentTheme.SOFT_TEXT
    btn.Font = Enum.Font.GothamBold
    btn.TextSize = 10
    btn.AutoButtonColor = false
    Instance.new("UICorner", btn).CornerRadius = UDim.new(0, 6)

    local dropScroll = Instance.new("ScrollingFrame", card)
    dropScroll.Size = UDim2.new(1, -20, 0, 100)
    dropScroll.Position = UDim2.new(0, 10, 0, 38)
    dropScroll.BackgroundColor3 = currentTheme.SLIDER_BG
    dropScroll.Visible = false
    dropScroll.BorderSizePixel = 0
    dropScroll.ScrollBarThickness = 3
    Instance.new("UICorner", dropScroll).CornerRadius = UDim.new(0, 6)

    local dList = Instance.new("UIListLayout", dropScroll)
    dList.SortOrder = Enum.SortOrder.LayoutOrder
    dList:GetPropertyChangedSignal("AbsoluteContentSize"):Connect(function()
        dropScroll.CanvasSize = UDim2.new(0, 0, 0, dList.AbsoluteContentSize.Y)
    end)

    for _, v in ipairs(list) do
        local item = Instance.new("TextButton", dropScroll)
        item.Size = UDim2.new(1, 0, 0, 22)
        item.BackgroundTransparency = 1
        item.Text = v
        item.TextColor3 = currentTheme.SOFT_TEXT
        item.Font = Enum.Font.GothamBold
        item.TextSize = 10
        item.MouseButton1Click:Connect(function()
            btn.Text = v
            dropScroll.Visible = false
            card.Size = UDim2.new(1, -4, 0, 36)
            callback(v)
        end)
    end

    btn.MouseButton1Click:Connect(function()
        local opened = not dropScroll.Visible
        dropScroll.Visible = opened
        card.Size = UDim2.new(1, -4, 0, opened and 140 or 36)
    end)
end

local function addColorSelector(parentPage, titleText, currentColor, callback)
    local card = createCard(parentPage, 36)
    local topFrame = Instance.new("Frame", card)
    topFrame.Size = UDim2.new(1, 0, 0, 36)
    topFrame.BackgroundTransparency = 1

    local lbl = Instance.new("TextLabel", topFrame)
    lbl.Name = "CardLabel"
    lbl.Size = UDim2.new(0.42, 0, 1, 0)
    lbl.Position = UDim2.new(0, 10, 0, 0)
    lbl.BackgroundTransparency = 1
    lbl.Text = titleText
    lbl.TextColor3 = currentTheme.SOFT_TEXT
    lbl.Font = Enum.Font.SourceSansBold
    lbl.TextSize = 12
    lbl.TextXAlignment = Enum.TextXAlignment.Left

    local colorMap = {
        ["hot pink"] = Color3.fromRGB(255, 20, 147),
        ["pink"] = Color3.fromRGB(255, 105, 180),
        ["light orange"] = Color3.fromRGB(255, 160, 122),
        ["cyan"] = Color3.fromRGB(0, 255, 255),
        ["green"] = Color3.fromRGB(50, 205, 50),
        ["purple"] = Color3.fromRGB(153, 50, 204),
        ["blue"] = Color3.fromRGB(30, 144, 255),
        ["electric blue"] = Color3.fromRGB(0, 191, 255),
        ["light red"] = Color3.fromRGB(255, 99, 71),
        ["violet"] = Color3.fromRGB(238, 130, 238)
    }

    local currentName = "hot pink"
    for name, col in pairs(colorMap) do
        if math.abs(col.R - currentColor.R) < 0.05 and math.abs(col.G - currentColor.G) < 0.05 and math.abs(col.B - currentColor.B) < 0.05 then
            currentName = name
            break
        end
    end

    local btn = Instance.new("TextButton", topFrame)
    btn.Size = UDim2.new(0.52, 0, 0, 22)
    btn.Position = UDim2.new(0.44, 0, 0.5, -11)
    btn.BackgroundColor3 = currentTheme.LIGHT_BTN
    btn.Text = currentName
    btn.TextColor3 = currentTheme.SOFT_TEXT
    btn.Font = Enum.Font.GothamBold
    btn.TextSize = 10
    btn.AutoButtonColor = false
    Instance.new("UICorner", btn).CornerRadius = UDim.new(0, 6)

    local dropScroll = Instance.new("ScrollingFrame", card)
    dropScroll.Size = UDim2.new(1, -20, 0, 140)
    dropScroll.Position = UDim2.new(0, 10, 0, 38)
    dropScroll.BackgroundColor3 = currentTheme.SLIDER_BG
    dropScroll.Visible = false
    dropScroll.BorderSizePixel = 0
    dropScroll.ScrollBarThickness = 3
    Instance.new("UICorner", dropScroll).CornerRadius = UDim.new(0, 6)

    local dList = Instance.new("UIListLayout", dropScroll)
    dList.SortOrder = Enum.SortOrder.LayoutOrder
    dList:GetPropertyChangedSignal("AbsoluteContentSize"):Connect(function()
        dropScroll.CanvasSize = UDim2.new(0, 0, 0, dList.AbsoluteContentSize.Y)
    end)

    for name, col in pairs(colorMap) do
        local item = Instance.new("TextButton", dropScroll)
        item.Size = UDim2.new(1, 0, 0, 24)
        item.BackgroundTransparency = 1
        item.Text = name
        item.TextColor3 = currentTheme.SOFT_TEXT
        item.Font = Enum.Font.GothamBold
        item.TextSize = 10
        item.MouseButton1Click:Connect(function()
            btn.Text = name
            dropScroll.Visible = false
            card.Size = UDim2.new(1, -4, 0, 36)
            callback(col)
        end)
    end

    btn.MouseButton1Click:Connect(function()
        local opened = not dropScroll.Visible
        dropScroll.Visible = opened
        card.Size = UDim2.new(1, -4, 0, opened and 180 or 36)
    end)
end

-- Refresh UI colors dynamically when a new theme preset is selected
local function updateThemeColors(newThemeData)
    for k, v in pairs(newThemeData) do
        currentTheme[k] = v
    end

    Main.BackgroundColor3 = currentTheme.BG
    MainStroke.Color = currentTheme.ACCENT
    Content.BackgroundColor3 = currentTheme.CARD_BG

    Title.TextColor3 = currentTheme.SOFT_TEXT
    UserSubTitle.TextColor3 = currentTheme.SUB_TEXT

    for _, page in pairs(pages) do
        page.ScrollBarImageColor3 = currentTheme.ACCENT
        local hFrame = page:FindFirstChildOfClass("Frame")
        if hFrame then
            local pTitle = hFrame:FindFirstChild("PageTitle")
            local pDesc = hFrame:FindFirstChild("PageDesc")
            if pTitle then pTitle.TextColor3 = currentTheme.SOFT_TEXT end
            if pDesc then pDesc.TextColor3 = currentTheme.SUB_TEXT end
        end

        for _, card in ipairs(page:GetChildren()) do
            if card:IsA("Frame") and card.Name ~= "Header" then
                card.BackgroundColor3 = currentTheme.CARD
                local stroke = card:FindFirstChild("CardStroke")
                if stroke then stroke.Color = currentTheme.STROKE end

                local lbl = card:FindFirstChild("CardLabel")
                if lbl then lbl.TextColor3 = currentTheme.SOFT_TEXT end

                local sub = card:FindFirstChild("CardSub")
                if sub then sub.TextColor3 = currentTheme.SUB_TEXT end

                local valLbl = card:FindFirstChild("ValueLabel")
                if valLbl then valLbl.TextColor3 = currentTheme.ACCENT end

                local sliderBG = card:FindFirstChild("SliderBG")
                if sliderBG then
                    sliderBG.BackgroundColor3 = currentTheme.SLIDER_BG
                    local fill = sliderBG:FindFirstChild("SliderFill")
                    if fill then fill.BackgroundColor3 = currentTheme.ACCENT end
                end

                local toggleBtn = card:FindFirstChild("ToggleBtn")
                if toggleBtn then
                    toggleBtn.BackgroundColor3 = currentTheme.LIGHT_BTN
                end
            end
        end
    end
end

-- Theme Presets Configuration
local themesList = {"latte cream", "cute pink", "matcha green", "lavender dream", "dark gothic"}
local themePresets = {
    ["latte cream"] = {
        ACCENT = Color3.fromRGB(185, 164, 147),
        BG = Color3.fromRGB(245, 242, 235),
        CARD_BG = Color3.fromRGB(250, 248, 243),
        CARD = Color3.fromRGB(238, 234, 226),
        SOFT_TEXT = Color3.fromRGB(75, 65, 55),
        SUB_TEXT = Color3.fromRGB(135, 118, 104),
        LIGHT_BTN = Color3.fromRGB(230, 224, 215),
        TOGGLE_OFF = Color3.fromRGB(215, 208, 198),
        STROKE = Color3.fromRGB(205, 194, 182),
        SLIDER_BG = Color3.fromRGB(230, 224, 215)
    },
    ["cute pink"] = {
        ACCENT = Color3.fromRGB(255, 105, 180),
        BG = Color3.fromRGB(255, 240, 245),
        CARD_BG = Color3.fromRGB(255, 248, 250),
        CARD = Color3.fromRGB(255, 228, 238),
        SOFT_TEXT = Color3.fromRGB(120, 40, 80),
        SUB_TEXT = Color3.fromRGB(180, 100, 130),
        LIGHT_BTN = Color3.fromRGB(255, 218, 228),
        TOGGLE_OFF = Color3.fromRGB(230, 190, 205),
        STROKE = Color3.fromRGB(255, 182, 193),
        SLIDER_BG = Color3.fromRGB(255, 218, 228)
    },
    ["matcha green"] = {
        ACCENT = Color3.fromRGB(120, 165, 120),
        BG = Color3.fromRGB(240, 245, 240),
        CARD_BG = Color3.fromRGB(246, 250, 246),
        CARD = Color3.fromRGB(228, 238, 228),
        SOFT_TEXT = Color3.fromRGB(50, 75, 50),
        SUB_TEXT = Color3.fromRGB(95, 125, 95),
        LIGHT_BTN = Color3.fromRGB(215, 230, 215),
        TOGGLE_OFF = Color3.fromRGB(195, 210, 195),
        STROKE = Color3.fromRGB(180, 205, 180),
        SLIDER_BG = Color3.fromRGB(215, 230, 215)
    },
    ["lavender dream"] = {
        ACCENT = Color3.fromRGB(165, 140, 200),
        BG = Color3.fromRGB(245, 242, 250),
        CARD_BG = Color3.fromRGB(250, 248, 253),
        CARD = Color3.fromRGB(235, 228, 245),
        SOFT_TEXT = Color3.fromRGB(75, 55, 100),
        SUB_TEXT = Color3.fromRGB(125, 105, 150),
        LIGHT_BTN = Color3.fromRGB(222, 212, 238),
        TOGGLE_OFF = Color3.fromRGB(200, 190, 220),
        STROKE = Color3.fromRGB(190, 175, 215),
        SLIDER_BG = Color3.fromRGB(222, 212, 238)
    },
    ["dark gothic"] = {
        ACCENT = Color3.fromRGB(200, 75, 120),
        BG = Color3.fromRGB(25, 22, 28),
        CARD_BG = Color3.fromRGB(35, 30, 38),
        CARD = Color3.fromRGB(45, 38, 48),
        SOFT_TEXT = Color3.fromRGB(240, 230, 245),
        SUB_TEXT = Color3.fromRGB(160, 145, 165),
        LIGHT_BTN = Color3.fromRGB(55, 46, 60),
        TOGGLE_OFF = Color3.fromRGB(70, 58, 75),
        STROKE = Color3.fromRGB(75, 60, 80),
        SLIDER_BG = Color3.fromRGB(55, 46, 60)
    }
}

addDropdown(themePage, "color theme", themesList, "latte cream", function(selectedName)
    if themePresets[selectedName] then
        updateThemeColors(themePresets[selectedName])
    end
end)

addToggle(silentAimPage, "silent aim", "improves shot accuracy", cfg.silentAim, function(v) cfg.silentAim = v end)
addSlider(silentAimPage, "fov radius", 10, 500, cfg.silentAimFOV, function(v) cfg.silentAimFOV = v end)
addToggle(silentAimPage, "show fov", "circle on screen", cfg.silentAimFOVShow, function(v) cfg.silentAimFOVShow = v end)
addColorSelector(silentAimPage, "fov color", cfg.silentAimColor, function(c) cfg.silentAimColor = c end)
addDropdown(silentAimPage, "hit part", bodyPartsList, cfg.silentAimPart, function(v) cfg.silentAimPart = v end)
addToggle(silentAimPage, "target closest part", "auto choose body part", cfg.silentAimClosestPart, function(v) cfg.silentAimClosestPart = v end)
addToggle(silentAimPage, "revolver bypass", "skip silent on revolver", cfg.bypassRevolver, function(v) cfg.bypassRevolver = v end)
addToggle(silentAimPage, "wall check", "only aim in open space", cfg.silentAimWallCheck, function(v) cfg.silentAimWallCheck = v end)

addToggle(camlockPage, "camlock", "sticky camera lock", cfg.camlockEnabled, function(v)
    cfg.camlockEnabled = v
    if not v then cfg.camlockActive = false end
end)
addFloatSlider(camlockPage, "smoothness", 0.01, 1, cfg.camlockSmoothness, function(v) cfg.camlockSmoothness = v end)
addKeybindPicker(camlockPage, "keybind", cfg.camlockKey, function(k) cfg.camlockKey = k end)
addDropdown(camlockPage, "target part", bodyPartsList, cfg.camlockPart, function(v) cfg.camlockPart = v end)

addToggle(hitboxPage, "enable hitbox", "enlarge enemy hitboxes", cfg.hitboxEnabled, function(v) cfg.hitboxEnabled = v end)
addSlider(hitboxPage, "hitbox size", 2, 20, cfg.hitboxSize, function(v) cfg.hitboxSize = v end)
addFloatSlider(hitboxPage, "transparency", 0, 1, cfg.hitboxTransparency, function(v) cfg.hitboxTransparency = v end)
addColorSelector(hitboxPage, "hitbox color", cfg.hitboxColor, function(c) cfg.hitboxColor = c end)

addToggle(visualsPage, "speed hack", "faster walk speed", cfg.speedEnabled, function(v)
    cfg.speedEnabled = v
    if not v then cfg.speedActive = false end
end)
addSlider(visualsPage, "speed value", 16, 500, cfg.speedValue, function(v) cfg.speedValue = v end)
addKeybindPicker(visualsPage, "speed keybind", cfg.speedKey, function(k) cfg.speedKey = k end)

addToggle(visualsPage, "jump power", "higher jump height", cfg.jumpEnabled, function(v)
    cfg.jumpEnabled = v
    if not v then cfg.jumpActive = false end
end)
addSlider(visualsPage, "jump value", 50, 500, cfg.jumpValue, function(v) cfg.jumpValue = v end)
addKeybindPicker(visualsPage, "jump keybind", cfg.jumpKey, function(k) cfg.jumpKey = k end)

addToggle(fogPage, "custom fog", "enable fog modifications", cfg.fogEnabled, function(v) cfg.fogEnabled = v end)
addSlider(fogPage, "fog start", 0, 500, cfg.fogStart, function(v) cfg.fogStart = v end)
addSlider(fogPage, "fog end", 50, 1000, cfg.fogEnd, function(v) cfg.fogEnd = v end)
addColorSelector(fogPage, "fog color", cfg.fogColor, function(c) cfg.fogColor = c end)

local whitelistListHolder = createPage("whitelist", "whitelist", "whitelisted friends & players")
local whitelistToggles = {}

local function rebuildWhitelistUI()
    for _, tObj in ipairs(whitelistToggles) do
        if tObj.Card and tObj.Card.Parent then tObj.Card:Destroy() end
    end
    whitelistToggles = {}

    for _, p in ipairs(Players:GetPlayers()) do
        if p ~= lp then
            local toggleObj = addToggle(whitelistListHolder, p.DisplayName, "@" .. p.Name, isWhitelisted(p), function(v)
                cfg.whitelisted[p.Name] = v
                cfg.whitelisted[p.UserId] = v
            end)
            table.insert(whitelistToggles, toggleObj)
        end
    end
end

rebuildWhitelistUI()

Players.PlayerAdded:Connect(function() task.wait(0.5) rebuildWhitelistUI() end)
Players.PlayerRemoving:Connect(function() task.wait(0.2) rebuildWhitelistUI() end)

tabButtons["silentAim"].Button.BackgroundTransparency = 0
tabButtons["silentAim"].Label.TextColor3 = currentTheme.SOFT_TEXT
pages["silentAim"].Visible = true

UIS.InputBegan:Connect(function(i, gpe)
    if gpe then return end
    if cfg.camlockEnabled and i.KeyCode == cfg.camlockKey then
        cfg.camlockActive = not cfg.camlockActive
        if not cfg.camlockActive then cfg.camlockTarget = nil end
    elseif cfg.speedEnabled and i.KeyCode == cfg.speedKey then
        cfg.speedActive = not cfg.speedActive
    elseif cfg.jumpEnabled and i.KeyCode == cfg.jumpKey then
        cfg.jumpActive = not cfg.jumpActive
    elseif i.KeyCode == cfg.uiToggleKey then
        ScreenGui.Enabled = not ScreenGui.Enabled
    end
end)
