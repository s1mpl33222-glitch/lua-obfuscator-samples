local UIS = game:GetService("UserInputService")
local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local CoreGui = game:GetService("CoreGui")

local lp = Players.LocalPlayer
while not lp do
    task.wait()
    lp = Players.LocalPlayer
end

local cam = workspace.CurrentCamera
local mouse = lp:GetMouse()
local gameId = game.GameId
local placeId = game.PlaceId

-- Game ID Check: Disable silent aim on 9825515356, enable on 75882626617183 (or default)
local isTargetGameDisabled = (gameId == 9825515356 or placeId == 9825515356)

local cfg = {
    silentAim = not isTargetGameDisabled,
    silentAimKey = Enum.KeyCode.V,
    uiToggleKey = Enum.KeyCode.RightControl,
    silentAimHitChance = 100,
    silentAimFOV = 150,
    silentAimFOVShow = false,
    silentAimFOVFilled = false,
    silentAimFOVOpacity = 0.2,
    silentAimFOVColor = Color3.fromRGB(255, 175, 204),
    
    -- Camlock Configurations
    camlockEnabled = false,
    camlockActive = false,
    camlockSmoothness = 0.25,
    camlockKey = Enum.KeyCode.Q,
    camlockPart = "Head",
    camlockTarget = nil,
    
    silentAimPart = "Head",
    silentAimClosestPart = false,
    
    silentAimTeamCheck = false,
    silentAimWallCheck = false,
    silentAimMaxDist = 1000,
    
    silentAimPredX = 0,
    silentAimPredY = 0,
    
    bypassRevolver = false,
    
    -- Visuals Configurations
    espBoxes = false,
    espNames = false,
    espHealth = false,
    espColor = Color3.fromRGB(255, 175, 204),
    
    -- Whitelist Configuration
    whitelisted = {}
}

local bodyPartsList = {
    "Head", "UpperTorso", "HumanoidRootPart", "LowerTorso",
    "LeftUpperArm", "RightUpperArm", "LeftLowerArm", "RightLowerArm",
    "LeftHand", "RightHand", "LeftUpperLeg", "RightUpperLeg",
    "LeftLowerLeg", "RightLowerLeg", "LeftFoot", "RightFoot"
}

local function getHum(p)
    local c = p and p.Character
    return c and c:FindFirstChildOfClass("Humanoid")
end

local function getHRP(p)
    local c = p and p.Character
    return c and c:FindFirstChild("HumanoidRootPart")
end

local function isAlive(p)
    local h = getHum(p)
    return h and h.Health > 0
end

local function sameTeam(p)
    return lp.Team and p.Team and lp.Team == p.Team
end

local function isWhitelisted(p)
    return cfg.whitelisted[p.UserId] == true
end

local function safeWorldToViewportPoint(pos)
    local sp, on = Vector3.new(), false
    pcall(function()
        sp, on = cam:WorldToViewportPoint(pos)
    end)
    return sp, on
end

local function getClosestBodyPart(char)
    local closestPart, shortestDist = nil, math.huge
    local mousePos = UIS:GetMouseLocation()
    for _, pName in ipairs(bodyPartsList) do
        local part = char:FindFirstChild(pName)
        if part then
            local screenPos, onScreen = safeWorldToViewportPoint(part.Position)
            local dist = onScreen and (Vector2.new(screenPos.X, screenPos.Y) - mousePos).Magnitude or math.huge
            if dist < shortestDist then
                shortestDist = dist
                closestPart = part
            end
        end
    end
    return closestPart or char:FindFirstChild("Head") or char:FindFirstChild("HumanoidRootPart")
end

local function getTargetPart(char)
    if not char then return nil end
    if cfg.silentAimClosestPart then
        return getClosestBodyPart(char)
    end
    return char:FindFirstChild(cfg.silentAimPart) or char:FindFirstChild("Head") or char:FindFirstChild("HumanoidRootPart")
end

local function wallBetween(pos)
    if not cfg.silentAimWallCheck then return false end
    local ro = cam.CFrame.Position
    local rd = pos - ro
    local params = RaycastParams.new()
    params.FilterDescendantsInstances = {lp.Character}
    params.FilterType = Enum.RaycastFilterType.Exclude
    local hit = workspace:Raycast(ro, rd, params)
    if not hit then return false end
    for _, p in pairs(Players:GetPlayers()) do
        if p.Character and hit.Instance:IsDescendantOf(p.Character) then return false end
    end
    return true
end

local function isHoldingRevolver()
    if not cfg.bypassRevolver then return false end
    local char = lp.Character
    if not char then return false end
    local tool = char:FindFirstChildOfClass("Tool")
    if tool and string.find(string.lower(tool.Name), "revolver") then
        return true
    end
    return false
end

local function getClosestPlayerForCamlock()
    local closestPlayer = nil
    local shortestDist = math.huge
    local mousePos = UIS:GetMouseLocation()

    for _, p in pairs(Players:GetPlayers()) do
        if p ~= lp and isAlive(p) and not isWhitelisted(p) then
            local char = p.Character
            if char then
                local part = char:FindFirstChild(cfg.camlockPart) or char:FindFirstChild("Head")
                if part then
                    local sp, onScreen = cam:WorldToViewportPoint(part.Position)
                    if onScreen then
                        local dist2D = (Vector2.new(sp.X, sp.Y) - mousePos).Magnitude
                        if dist2D < shortestDist then
                            shortestDist = dist2D
                            closestPlayer = part
                        end
                    end
                end
            end
        end
    end
    return closestPlayer
end

local function getClosestPlayerToCursor()
    if isTargetGameDisabled or isHoldingRevolver() then return nil end
    
    local closestPlayer = nil
    local shortestDist = cfg.silentAimFOV
    local mousePos = UIS:GetMouseLocation()

    for _, p in pairs(Players:GetPlayers()) do
        if p ~= lp and isAlive(p) and not isWhitelisted(p) then
            if cfg.silentAimTeamCheck and sameTeam(p) then continue end
            local hrp = getHRP(p)
            if hrp then
                local dist3D = (hrp.Position - cam.CFrame.Position).Magnitude
                if dist3D <= cfg.silentAimMaxDist then
                    local sp, onScreen = safeWorldToViewportPoint(hrp.Position)
                    if onScreen then
                        local dist2D = (Vector2.new(sp.X, sp.Y) - mousePos).Magnitude
                        if dist2D <= cfg.silentAimFOV and dist2D < shortestDist then
                            local part = getTargetPart(p.Character)
                            if part and not wallBetween(part.Position) then
                                shortestDist = dist2D
                                closestPlayer = part
                            end
                        end
                    end
                end
            end
        end
    end
    return closestPlayer
end

-- Cleanup existing UI
if CoreGui:FindFirstChild("EllarougTabUI") then
    CoreGui.EllarougTabUI:Destroy()
end
if lp:FindFirstChild("PlayerGui") and lp.PlayerGui:FindFirstChild("EllarougTabUI") then
    lp.PlayerGui.EllarougTabUI:Destroy()
end

local ScreenGui = Instance.new("ScreenGui")
ScreenGui.Name = "EllarougTabUI"
ScreenGui.ResetOnSpawn = false
ScreenGui.IgnoreGuiInset = true
ScreenGui.DisplayOrder = 10000

local success, _ = pcall(function()
    ScreenGui.Parent = CoreGui
end)
if not success or not ScreenGui.Parent then
    ScreenGui.Parent = lp:WaitForChild("PlayerGui", 5) or lp.PlayerGui
end

-- ESP Drawing Storage Management
local espDrawings = {}

local function removeEsp(p)
    if espDrawings[p] then
        for _, obj in pairs(espDrawings[p]) do
            pcall(function() obj:Remove() end)
        end
        espDrawings[p] = nil
    end
end

-- FOV Circle Drawing Object
local fovCircle = Drawing.new("Circle")
fovCircle.Thickness = 1.5
fovCircle.NumSides = 96
fovCircle.Radius = cfg.silentAimFOV
fovCircle.Color = cfg.silentAimFOVColor
fovCircle.Filled = cfg.silentAimFOVFilled
fovCircle.Visible = cfg.silentAimFOVShow
fovCircle.Transparency = 1 - cfg.silentAimFOVOpacity

local silentAimCachedPart = nil

RunService.RenderStepped:Connect(function()
    local mousePos = UIS:GetMouseLocation()
    if fovCircle then
        fovCircle.Position = mousePos
        fovCircle.Radius = cfg.silentAimFOV
        fovCircle.Color = cfg.silentAimFOVColor
        fovCircle.Filled = cfg.silentAimFOVFilled
        fovCircle.Visible = cfg.silentAimFOVShow
    end

    if cfg.camlockEnabled and cfg.camlockActive then
        if not cfg.camlockTarget or not cfg.camlockTarget.Parent or not isAlive(Players:GetPlayerFromCharacter(cfg.camlockTarget.Parent)) then
            cfg.camlockTarget = getClosestPlayerForCamlock()
        end
        if cfg.camlockTarget then
            local targetPos = cfg.camlockTarget.Position
            local currentCFrame = cam.CFrame
            local goalCFrame = CFrame.new(currentCFrame.Position, targetPos)
            cam.CFrame = currentCFrame:Lerp(goalCFrame, math.clamp(cfg.camlockSmoothness, 0.01, 1))
        end
    else
        cfg.camlockTarget = nil
    end

    for _, p in pairs(Players:GetPlayers()) do
        if p ~= lp then
            if isAlive(p) and (cfg.espBoxes or cfg.espNames or cfg.espHealth) then
                if not espDrawings[p] then
                    espDrawings[p] = {
                        Box = Drawing.new("Square"),
                        Name = Drawing.new("Text"),
                        HealthBarBg = Drawing.new("Square"),
                        HealthBar = Drawing.new("Square")
                    }
                    espDrawings[p].Box.Filled = false
                    espDrawings[p].Box.Thickness = 1
                    espDrawings[p].Name.Size = 14
                    espDrawings[p].Name.Center = true
                    espDrawings[p].Name.Outline = true
                    espDrawings[p].HealthBarBg.Filled = true
                    espDrawings[p].HealthBar.Filled = true
                end

                local char = p.Character
                local hrp = char and char:FindFirstChild("HumanoidRootPart")
                local hum = char and char:FindFirstChildOfClass("Humanoid")
                if char and hrp and hum then
                    local vector, onScreen = cam:WorldToViewportPoint(hrp.Position)
                    if onScreen then
                        local head = char:FindFirstChild("Head")
                        local leg = hrp.Position - Vector3.new(0, 3, 0)
                        local headPos = head and cam:WorldToViewportPoint(head.Position + Vector3.new(0, 0.5, 0)) or vector
                        local legPos = cam:WorldToViewportPoint(leg)
                        
                        local height = math.abs(headPos.Y - legPos.Y)
                        local width = height / 2
                        local pos = Vector2.new(vector.X - width / 2, headPos.Y)

                        local box = espDrawings[p].Box
                        if cfg.espBoxes then
                            box.Visible = true
                            box.Size = Vector2.new(width, height)
                            box.Position = pos
                            box.Color = cfg.espColor
                        else
                            box.Visible = false
                        end

                        local nameObj = espDrawings[p].Name
                        if cfg.espNames then
                            nameObj.Visible = true
                            nameObj.Text = p.DisplayName
                            nameObj.Position = Vector2.new(vector.X, pos.Y - 18)
                            nameObj.Color = cfg.espColor
                        else
                            nameObj.Visible = false
                        end

                        local hbBg = espDrawings[p].HealthBarBg
                        local hb = espDrawings[p].HealthBar
                        if cfg.espHealth then
                            hbBg.Visible = true
                            hb.Visible = true
                            local healthPct = math.clamp(hum.Health / hum.MaxHealth, 0, 1)
                            hbBg.Size = Vector2.new(3, height)
                            hbBg.Position = Vector2.new(pos.X - 6, pos.Y)
                            hbBg.Color = Color3.fromRGB(240, 220, 235)

                            hb.Size = Vector2.new(1, height * healthPct)
                            hb.Position = Vector2.new(pos.X - 5, pos.Y + (height * (1 - healthPct)))
                            hb.Color = Color3.fromRGB(255, 140, 180)
                        else
                            hbBg.Visible = false
                            hb.Visible = false
                        end
                    else
                        for _, obj in pairs(espDrawings[p]) do obj.Visible = false end
                    end
                else
                    removeEsp(p)
                end
            else
                removeEsp(p)
            end
        end
    end

    if cfg.silentAim and not isTargetGameDisabled then
        silentAimCachedPart = getClosestPlayerToCursor()
    else
        silentAimCachedPart = nil
    end
end)

Players.PlayerRemoving:Connect(removeEsp)

-- Metatable Hooks (Only active if not disabled for this game)
if not isTargetGameDisabled then
    local mt = getrawmetatable(game)
    local oldIndex = mt.__index
    local oldNamecall = mt.__namecall
    setreadonly(mt, false)

    mt.__index = function(self, key)
        if not checkcaller() and self == mouse and cfg.silentAim and silentAimCachedPart then
            if key == "Hit" then
                if math.random(1, 100) <= cfg.silentAimHitChance then
                    local hitPos = silentAimCachedPart.Position + Vector3.new(
                        silentAimCachedPart.AssemblyLinearVelocity.X * cfg.silentAimPredX,
                        silentAimCachedPart.AssemblyLinearVelocity.Y * cfg.silentAimPredY,
                        silentAimCachedPart.AssemblyLinearVelocity.Z * cfg.silentAimPredX
                    )
                    return CFrame.new(hitPos)
                end
            elseif key == "Target" then
                return silentAimCachedPart
            elseif key == "UnitRay" then
                local origin = cam.CFrame.Position
                local hitPos = silentAimCachedPart.Position
                return Ray.new(origin, (hitPos - origin).Unit)
            end
        end
        return oldIndex(self, key)
    end

    mt.__namecall = function(self, ...)
        local args = {...}
        local method = getnamecallmethod()
        if not checkcaller() and cfg.silentAim and silentAimCachedPart then
            if method == "GetMouse" or (self == mouse and (method == "Hit" or method == "Target")) then
                if math.random(1, 100) <= cfg.silentAimHitChance then
                    local hitPos = silentAimCachedPart.Position
                    if method == "Hit" then
                        return CFrame.new(hitPos)
                    elseif method == "Target" then
                        return silentAimCachedPart
                    end
                end
            end
        end
        return oldNamecall(self, unpack(args))
    end

    setreadonly(mt, true)
end

-- Cute Pastel Theme Configurations
local theme = {
    ACCENT = Color3.fromRGB(255, 170, 200),
    BG = Color3.fromRGB(253, 245, 250),
    CARD = Color3.fromRGB(255, 255, 255),
    ACTIVE_CARD = Color3.fromRGB(255, 232, 242),
    TEXT = Color3.fromRGB(130, 95, 125),
    SUB_TEXT = Color3.fromRGB(175, 145, 170),
    STROKE = Color3.fromRGB(245, 205, 225),
    LIGHT_BTN = Color3.fromRGB(250, 235, 245)
}

-- Main Frame
local Main = Instance.new("Frame", ScreenGui)
Main.Name = "Main"
Main.Size = UDim2.new(0, 560, 0, 420)
Main.Position = UDim2.new(0.5, -280, 0.5, -210)
Main.BackgroundColor3 = theme.BG
Main.BorderSizePixel = 0
Main.Active = true

Instance.new("UICorner", Main).CornerRadius = UDim.new(0, 16)
local MainStroke = Instance.new("UIStroke", Main)
MainStroke.Color = theme.ACCENT
MainStroke.Thickness = 2

-- Make UI Draggable
local dragging, dragInput, dragStart, startPos
Main.InputBegan:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
        dragging = true
        dragStart = input.Position
        startPos = Main.Position
        input.Changed:Connect(function()
            if input.UserInputState == Enum.UserInputState.End then
                dragging = false
            end
        end)
    end
end)

Main.InputChanged:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch then
        dragInput = input
    end
end)

UIS.InputChanged:Connect(function(input)
    if input == dragInput and dragging then
        local delta = input.Position - dragStart
        Main.Position = UDim2.new(startPos.X.Scale, startPos.X.Offset + delta.X, startPos.Y.Scale, startPos.Y.Offset + delta.Y)
    end
end)

-- Top Header Text (Updated Title)
local TopLabel = Instance.new("TextLabel", Main)
TopLabel.Size = UDim2.new(1, -20, 0, 24)
TopLabel.Position = UDim2.new(0, 16, 0, 8)
TopLabel.BackgroundTransparency = 1
TopLabel.Text = "✧ ELLA MAIN DANFFA ✧"
TopLabel.TextColor3 = theme.TEXT
TopLabel.Font = Enum.Font.FredokaOne
TopLabel.TextSize = 13
TopLabel.TextXAlignment = Enum.TextXAlignment.Left

-- Sidebar Tabs Container
local Sidebar = Instance.new("ScrollingFrame", Main)
Sidebar.Size = UDim2.new(0, 160, 1, -44)
Sidebar.Position = UDim2.new(0, 10, 0, 36)
Sidebar.BackgroundTransparency = 1
Sidebar.BorderSizePixel = 0
Sidebar.ScrollBarThickness = 0

local SidebarLayout = Instance.new("UIListLayout", Sidebar)
SidebarLayout.SortOrder = Enum.SortOrder.LayoutOrder
SidebarLayout.Padding = UDim.new(0, 8)

-- Content Pages Container
local Container = Instance.new("Frame", Main)
Container.Size = UDim2.new(1, -185, 1, -44)
Container.Position = UDim2.new(0, 175, 0, 36)
Container.BackgroundTransparency = 1

local pages = {}
local tabButtons = {}

local function createPage(name)
    local page = Instance.new("ScrollingFrame", Container)
    page.Name = name .. "Page"
    page.Size = UDim2.new(1, 0, 1, 0)
    page.BackgroundTransparency = 1
    page.BorderSizePixel = 0
    page.Visible = false
    page.ScrollBarThickness = 3
    page.ScrollBarImageColor3 = theme.ACCENT

    local layout = Instance.new("UIListLayout", page)
    layout.SortOrder = Enum.SortOrder.LayoutOrder
    layout.Padding = UDim.new(0, 8)
    
    layout:GetPropertyChangedSignal("AbsoluteContentSize"):Connect(function()
        page.CanvasSize = UDim2.new(0, 0, 0, layout.AbsoluteContentSize.Y + 10)
    end)

    pages[name] = page
    return page
end

local function addTab(name)
    local tabCard = Instance.new("Frame", Sidebar)
    tabCard.Size = UDim2.new(1, 0, 0, 42)
    tabCard.BackgroundColor3 = theme.CARD
    tabCard.BorderSizePixel = 0

    Instance.new("UICorner", tabCard).CornerRadius = UDim.new(0, 12)
    local stroke = Instance.new("UIStroke", tabCard)
    stroke.Color = theme.STROKE
    stroke.Thickness = 1

    local activeBar = Instance.new("Frame", tabCard)
    activeBar.Name = "ActiveBar"
    activeBar.Size = UDim2.new(0, 4, 0, 22)
    activeBar.Position = UDim2.new(0, 6, 0.5, -11)
    activeBar.BackgroundColor3 = theme.ACCENT
    activeBar.Visible = false
    Instance.new("UICorner", activeBar).CornerRadius = UDim.new(1, 0)

    local btn = Instance.new("TextButton", tabCard)
    btn.Size = UDim2.new(1, 0, 1, 0)
    btn.BackgroundTransparency = 1
    btn.Text = "  ♥ " .. name
    btn.TextColor3 = theme.TEXT
    btn.Font = Enum.Font.FredokaOne
    btn.TextSize = 13
    btn.TextXAlignment = Enum.TextXAlignment.Left

    local page = createPage(name)
    table.insert(tabButtons, {Card = tabCard, Bar = activeBar, Page = page, Button = btn})
    return page
end

local function selectTab(targetPageName)
    for _, tab in ipairs(tabButtons) do
        if tab.Page.Name == targetPageName .. "Page" then
            tab.Page.Visible = true
            tab.Card.BackgroundColor3 = theme.ACTIVE_CARD
            tab.Bar.Visible = true
        else
            tab.Page.Visible = false
            tab.Card.BackgroundColor3 = theme.CARD
            tab.Bar.Visible = false
        end
    end
end

local function createContentCard(page, height)
    local card = Instance.new("Frame", page)
    card.Size = UDim2.new(1, -10, 0, height or 46)
    card.BackgroundColor3 = theme.CARD
    card.BorderSizePixel = 0
    Instance.new("UICorner", card).CornerRadius = UDim.new(0, 12)
    local s = Instance.new("UIStroke", card)
    s.Color = theme.STROKE
    s.Thickness = 1
    return card
end

local function addDetailedToggleCard(page, titleText, configKey)
    local card = createContentCard(page, 46)
    
    local titleLbl = Instance.new("TextLabel", card)
    titleLbl.Size = UDim2.new(0.65, 0, 1, 0)
    titleLbl.Position = UDim2.new(0, 12, 0, 0)
    titleLbl.BackgroundTransparency = 1
    titleLbl.Text = "♡ " .. titleText
    titleLbl.TextColor3 = theme.TEXT
    titleLbl.Font = Enum.Font.FredokaOne
    titleLbl.TextSize = 13
    titleLbl.TextXAlignment = Enum.TextXAlignment.Left

    local btn = Instance.new("TextButton", card)
    btn.Size = UDim2.new(0, 40, 0, 20)
    btn.Position = UDim2.new(1, -50, 0.5, -10)
    btn.BackgroundColor3 = cfg[configKey] and theme.ACCENT or theme.LIGHT_BTN
    btn.Text = ""
    btn.AutoButtonColor = false
    Instance.new("UICorner", btn).CornerRadius = UDim.new(1, 0)
    
    local circ = Instance.new("Frame", btn)
    circ.Size = UDim2.new(0, 16, 0, 16)
    circ.Position = cfg[configKey] and UDim2.new(1, -18, 0.5, -8) or UDim2.new(0, 2, 0.5, -8)
    circ.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
    Instance.new("UICorner", circ).CornerRadius = UDim.new(1, 0)

    btn.MouseButton1Click:Connect(function()
        cfg[configKey] = not cfg[configKey]
        btn.BackgroundColor3 = cfg[configKey] and theme.ACCENT or theme.LIGHT_BTN
        circ:TweenPosition(cfg[configKey] and UDim2.new(1, -18, 0.5, -8) or UDim2.new(0, 2, 0.5, -8), Enum.EasingDirection.Out, Enum.EasingStyle.Quad, 0.12, true)
    end)
end

-- ================= TAB 1: COMBAT =================
local combatPage = addTab("combat")

if not isTargetGameDisabled then
    -- Silent Aim Toggle
    local sCard = createContentCard(combatPage, 46)
    local sLbl = Instance.new("TextLabel", sCard)
    sLbl.Size = UDim2.new(0.65, 0, 1, 0)
    sLbl.Position = UDim2.new(0, 12, 0, 0)
    sLbl.BackgroundTransparency = 1
    sLbl.Text = "♡ silent aim"
    sLbl.TextColor3 = theme.TEXT
    sLbl.Font = Enum.Font.FredokaOne
    sLbl.TextSize = 13
    sLbl.TextXAlignment = Enum.TextXAlignment.Left

    local sBtn = Instance.new("TextButton", sCard)
    sBtn.Size = UDim2.new(0, 40, 0, 20)
    sBtn.Position = UDim2.new(1, -50, 0.5, -10)
    sBtn.BackgroundColor3 = cfg.silentAim and theme.ACCENT or theme.LIGHT_BTN
    sBtn.Text = ""
    sBtn.AutoButtonColor = false
    Instance.new("UICorner", sBtn).CornerRadius = UDim.new(1, 0)
    local sCircle = Instance.new("Frame", sBtn)
    sCircle.Size = UDim2.new(0, 16, 0, 16)
    sCircle.Position = cfg.silentAim and UDim2.new(1, -18, 0.5, -8) or UDim2.new(0, 2, 0.5, -8)
    sCircle.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
    Instance.new("UICorner", sCircle).CornerRadius = UDim.new(1, 0)

    sBtn.MouseButton1Click:Connect(function()
        cfg.silentAim = not cfg.silentAim
        sBtn.BackgroundColor3 = cfg.silentAim and theme.ACCENT or theme.LIGHT_BTN
        sCircle:TweenPosition(cfg.silentAim and UDim2.new(1, -18, 0.5, -8) or UDim2.new(0, 2, 0.5, -8), Enum.EasingDirection.Out, Enum.EasingStyle.Quad, 0.12, true)
    end)
end

-- Show FOV Toggle
local fShowCard = createContentCard(combatPage, 46)
local fShowLbl = Instance.new("TextLabel", fShowCard)
fShowLbl.Size = UDim2.new(0.65, 0, 1, 0)
fShowLbl.Position = UDim2.new(0, 12, 0, 0)
fShowLbl.BackgroundTransparency = 1
fShowLbl.Text = "♡ show fov"
fShowLbl.TextColor3 = theme.TEXT
fShowLbl.Font = Enum.Font.FredokaOne
fShowLbl.TextSize = 13
fShowLbl.TextXAlignment = Enum.TextXAlignment.Left

local fShowBtn = Instance.new("TextButton", fShowCard)
fShowBtn.Size = UDim2.new(0, 40, 0, 20)
fShowBtn.Position = UDim2.new(1, -50, 0.5, -10)
fShowBtn.BackgroundColor3 = cfg.silentAimFOVShow and theme.ACCENT or theme.LIGHT_BTN
fShowBtn.Text = ""
fShowBtn.AutoButtonColor = false
Instance.new("UICorner", fShowBtn).CornerRadius = UDim.new(1, 0)
local fShowCircle = Instance.new("Frame", fShowBtn)
fShowCircle.Size = UDim2.new(0, 16, 0, 16)
fShowCircle.Position = cfg.silentAimFOVShow and UDim2.new(1, -18, 0.5, -8) or UDim2.new(0, 2, 0.5, -8)
fShowCircle.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
Instance.new("UICorner", fShowCircle).CornerRadius = UDim.new(1, 0)

fShowBtn.MouseButton1Click:Connect(function()
    cfg.silentAimFOVShow = not cfg.silentAimFOVShow
    fShowBtn.BackgroundColor3 = cfg.silentAimFOVShow and theme.ACCENT or theme.LIGHT_BTN
    fShowCircle:TweenPosition(cfg.silentAimFOVShow and UDim2.new(1, -18, 0.5, -8) or UDim2.new(0, 2, 0.5, -8), Enum.EasingDirection.Out, Enum.EasingStyle.Quad, 0.12, true)
    
    if fovCircle then
        fovCircle.Visible = cfg.silentAimFOVShow
    end
end)

-- FOV Size Card & Input
local fovCard = createContentCard(combatPage, 52)
local fovLbl = Instance.new("TextLabel", fovCard)
fovLbl.Size = UDim2.new(0.5, 0, 0, 18)
fovLbl.Position = UDim2.new(0, 12, 0, 4)
fovLbl.BackgroundTransparency = 1
fovLbl.Text = "♡ fov size"
fovLbl.TextColor3 = theme.TEXT
fovLbl.Font = Enum.Font.FredokaOne
fovLbl.TextSize = 13
fovLbl.TextXAlignment = Enum.TextXAlignment.Left

local fovBox = Instance.new("TextBox", fovCard)
fovBox.Size = UDim2.new(0, 55, 0, 22)
fovBox.Position = UDim2.new(1, -65, 0, 4)
fovBox.BackgroundColor3 = theme.LIGHT_BTN
fovBox.Text = tostring(cfg.silentAimFOV)
fovBox.TextColor3 = theme.TEXT
fovBox.Font = Enum.Font.FredokaOne
fovBox.TextSize = 11
Instance.new("UICorner", fovBox).CornerRadius = UDim.new(0, 8)

local fovBg = Instance.new("Frame", fovCard)
fovBg.Size = UDim2.new(1, -24, 0, 6)
fovBg.Position = UDim2.new(0, 12, 0, 36)
fovBg.BackgroundColor3 = theme.LIGHT_BTN
Instance.new("UICorner", fovBg).CornerRadius = UDim.new(1, 0)

local fovFill = Instance.new("Frame", fovBg)
fovFill.Size = UDim2.new((cfg.silentAimFOV - 10) / (500 - 10), 0, 1, 0)
fovFill.BackgroundColor3 = theme.ACCENT
Instance.new("UICorner", fovFill).CornerRadius = UDim.new(1, 0)

local fovKnob = Instance.new("Frame", fovBg)
fovKnob.Size = UDim2.new(0, 12, 0, 12)
fovKnob.AnchorPoint = Vector2.new(0.5, 0.5)
fovKnob.Position = UDim2.new((cfg.silentAimFOV - 10) / (500 - 10), 0, 0.5, 0)
fovKnob.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
Instance.new("UICorner", fovKnob).CornerRadius = UDim.new(1, 0)

local fovDragging = false
local function updateFovSlider(input)
    local pos = math.clamp((input.Position.X - fovBg.AbsolutePosition.X) / fovBg.AbsoluteSize.X, 0, 1)
    local val = math.floor(10 + (500 - 10) * pos)
    fovFill.Size = UDim2.new(pos, 0, 1, 0)
    fovKnob.Position = UDim2.new(pos, 0, 0.5, 0)
    fovBox.Text = tostring(val)
    cfg.silentAimFOV = val
end
fovBox.FocusLost:Connect(function()
    local num = tonumber(fovBox.Text)
    if num then
        num = math.clamp(num, 10, 500)
        cfg.silentAimFOV = num
        fovBox.Text = tostring(num)
        local pos = (num - 10) / (500 - 10)
        fovFill.Size = UDim2.new(pos, 0, 1, 0)
        fovKnob.Position = UDim2.new(pos, 0, 0.5, 0)
    else
        fovBox.Text = tostring(cfg.silentAimFOV)
    end
end)
fovBg.InputBegan:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseButton1 then fovDragging = true updateFovSlider(input) end
end)
UIS.InputEnded:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseButton1 then fovDragging = false end
end)
UIS.InputChanged:Connect(function(input)
    if fovDragging and input.UserInputType == Enum.UserInputType.MouseMovement then updateFovSlider(input) end
end)

-- FOV Color Picker Card
local fovColorCard = createContentCard(combatPage, 84)
local fovColorLbl = Instance.new("TextLabel", fovColorCard)
fovColorLbl.Size = UDim2.new(1, -24, 0, 20)
fovColorLbl.Position = UDim2.new(0, 12, 0, 6)
fovColorLbl.BackgroundTransparency = 1
fovColorLbl.Text = "♡ fov color"
fovColorLbl.TextColor3 = theme.TEXT
fovColorLbl.Font = Enum.Font.FredokaOne
fovColorLbl.TextSize = 13
fovColorLbl.TextXAlignment = Enum.TextXAlignment.Left

local fovColorGrid = Instance.new("Frame", fovColorCard)
fovColorGrid.Size = UDim2.new(1, -24, 0, 44)
fovColorGrid.Position = UDim2.new(0, 12, 0, 30)
fovColorGrid.BackgroundTransparency = 1

local fovGridLayout = Instance.new("UIGridLayout", fovColorGrid)
fovGridLayout.CellSize = UDim2.new(0, 22, 0, 20)
fovGridLayout.CellPadding = UDim2.new(0, 6, 0, 6)

local presetColors = {
    Color3.fromRGB(255, 170, 200), Color3.fromRGB(255, 185, 150), Color3.fromRGB(255, 235, 150),
    Color3.fromRGB(180, 235, 160), Color3.fromRGB(150, 225, 200), Color3.fromRGB(150, 215, 255),
    Color3.fromRGB(175, 180, 255), Color3.fromRGB(215, 170, 255), Color3.fromRGB(255, 170, 230),
    Color3.fromRGB(255, 130, 170), Color3.fromRGB(230, 140, 210), Color3.fromRGB(190, 140, 230),
    Color3.fromRGB(140, 160, 230), Color3.fromRGB(130, 190, 230), Color3.fromRGB(140, 210, 200),
    Color3.fromRGB(200, 200, 210), Color3.fromRGB(80, 70, 90)
}

for _, col in ipairs(presetColors) do
    local cBtn = Instance.new("TextButton", fovColorGrid)
    cBtn.BackgroundColor3 = col
    cBtn.Text = ""
    cBtn.AutoButtonColor = false
    Instance.new("UICorner", cBtn).CornerRadius = UDim.new(0, 8)
    cBtn.MouseButton1Click:Connect(function()
        cfg.silentAimFOVColor = col
    end)
end

if not isTargetGameDisabled then
    -- Target Part Selector Card
    local partCard = createContentCard(combatPage, 46)
    local partLbl = Instance.new("TextLabel", partCard)
    partLbl.Size = UDim2.new(0.5, 0, 1, 0)
    partLbl.Position = UDim2.new(0, 12, 0, 0)
    partLbl.BackgroundTransparency = 1
    partLbl.Text = "♡ target part"
    partLbl.TextColor3 = theme.TEXT
    partLbl.Font = Enum.Font.FredokaOne
    partLbl.TextSize = 13
    partLbl.TextXAlignment = Enum.TextXAlignment.Left

    local partBtn = Instance.new("TextButton", partCard)
    partBtn.Size = UDim2.new(0, 110, 0, 26)
    partBtn.Position = UDim2.new(1, -120, 0.5, -13)
    partBtn.BackgroundColor3 = theme.LIGHT_BTN
    partBtn.Text = cfg.silentAimPart
    partBtn.TextColor3 = theme.TEXT
    partBtn.Font = Enum.Font.FredokaOne
    partBtn.TextSize = 11
    partBtn.AutoButtonColor = false
    Instance.new("UICorner", partBtn).CornerRadius = UDim.new(0, 8)

    local currentPartIdx = 1
    for i, name in ipairs(bodyPartsList) do
        if name == cfg.silentAimPart then currentPartIdx = i break end
    end

    partBtn.MouseButton1Click:Connect(function()
        currentPartIdx = currentPartIdx % #bodyPartsList + 1
        cfg.silentAimPart = bodyPartsList[currentPartIdx]
        partBtn.Text = cfg.silentAimPart
    end)

    addDetailedToggleCard(combatPage, "target closest part", "silentAimClosestPart")
    addDetailedToggleCard(combatPage, "revolver bypass", "bypassRevolver")
    addDetailedToggleCard(combatPage, "wall check", "silentAimWallCheck")
end

-- ================= TAB 2: CAMLOCK =================
local camlockPage = addTab("camlock")

local camCard = createContentCard(camlockPage, 46)
local camLbl = Instance.new("TextLabel", camCard)
camLbl.Size = UDim2.new(0.65, 0, 1, 0)
camLbl.Position = UDim2.new(0, 12, 0, 0)
camLbl.BackgroundTransparency = 1
camLbl.Text = "♡ camlock enabled"
camLbl.TextColor3 = theme.TEXT
camLbl.Font = Enum.Font.FredokaOne
camLbl.TextSize = 13
camLbl.TextXAlignment = Enum.TextXAlignment.Left

local camBtn = Instance.new("TextButton", camCard)
camBtn.Size = UDim2.new(0, 40, 0, 20)
camBtn.Position = UDim2.new(1, -50, 0.5, -10)
camBtn.BackgroundColor3 = cfg.camlockEnabled and theme.ACCENT or theme.LIGHT_BTN
camBtn.Text = ""
camBtn.AutoButtonColor = false
Instance.new("UICorner", camBtn).CornerRadius = UDim.new(1, 0)
local camCircle = Instance.new("Frame", camBtn)
camCircle.Size = UDim2.new(0, 16, 0, 16)
camCircle.Position = cfg.camlockEnabled and UDim2.new(1, -18, 0.5, -8) or UDim2.new(0, 2, 0.5, -8)
camCircle.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
Instance.new("UICorner", camCircle).CornerRadius = UDim.new(1, 0)

camBtn.MouseButton1Click:Connect(function()
    cfg.camlockEnabled = not cfg.camlockEnabled
    if not cfg.camlockEnabled then cfg.camlockActive = false end
    camBtn.BackgroundColor3 = cfg.camlockEnabled and theme.ACCENT or theme.LIGHT_BTN
    camCircle:TweenPosition(cfg.camlockEnabled and UDim2.new(1, -18, 0.5, -8) or UDim2.new(0, 2, 0.5, -8), Enum.EasingDirection.Out, Enum.EasingStyle.Quad, 0.12, true)
end)

-- Camlock Part Selector Card
local cPartCard = createContentCard(camlockPage, 46)
local cPartLbl = Instance.new("TextLabel", cPartCard)
cPartLbl.Size = UDim2.new(0.5, 0, 1, 0)
cPartLbl.Position = UDim2.new(0, 12, 0, 0)
cPartLbl.BackgroundTransparency = 1
cPartLbl.Text = "♡ camlock part"
cPartLbl.TextColor3 = theme.TEXT
cPartLbl.Font = Enum.Font.FredokaOne
cPartLbl.TextSize = 13
cPartLbl.TextXAlignment = Enum.TextXAlignment.Left

local cPartBtn = Instance.new("TextButton", cPartCard)
cPartBtn.Size = UDim2.new(0, 110, 0, 26)
cPartBtn.Position = UDim2.new(1, -120, 0.5, -13)
cPartBtn.BackgroundColor3 = theme.LIGHT_BTN
cPartBtn.Text = cfg.camlockPart
cPartBtn.TextColor3 = theme.TEXT
cPartBtn.Font = Enum.Font.FredokaOne
cPartBtn.TextSize = 11
cPartBtn.AutoButtonColor = false
Instance.new("UICorner", cPartBtn).CornerRadius = UDim.new(0, 8)

local currentCamPartIdx = 1
for i, name in ipairs(bodyPartsList) do
    if name == cfg.camlockPart then currentCamPartIdx = i break end
end

cPartBtn.MouseButton1Click:Connect(function()
    currentCamPartIdx = currentCamPartIdx % #bodyPartsList + 1
    cfg.camlockPart = bodyPartsList[currentCamPartIdx]
    cPartBtn.Text = cfg.camlockPart
end)

-- Camlock Keybind Card
local keyCard = createContentCard(camlockPage, 46)
local keyLbl = Instance.new("TextLabel", keyCard)
keyLbl.Size = UDim2.new(0.6, 0, 1, 0)
keyLbl.Position = UDim2.new(0, 12, 0, 0)
keyLbl.BackgroundTransparency = 1
keyLbl.Text = "♡ camlock key"
keyLbl.TextColor3 = theme.TEXT
keyLbl.Font = Enum.Font.FredokaOne
keyLbl.TextSize = 13
keyLbl.TextXAlignment = Enum.TextXAlignment.Left

local keyBtn = Instance.new("TextButton", keyCard)
keyBtn.Size = UDim2.new(0, 75, 0, 26)
keyBtn.Position = UDim2.new(1, -85, 0.5, -13)
keyBtn.BackgroundColor3 = theme.LIGHT_BTN
keyBtn.Text = cfg.camlockKey.Name
keyBtn.TextColor3 = theme.TEXT
keyBtn.Font = Enum.Font.FredokaOne
keyBtn.TextSize = 12
keyBtn.AutoButtonColor = false
Instance.new("UICorner", keyBtn).CornerRadius = UDim.new(0, 8)

local listeningKey = false
keyBtn.MouseButton1Click:Connect(function()
    if listeningKey then return end
    listeningKey = true
    keyBtn.Text = "..."
    keyBtn.BackgroundColor3 = theme.ACCENT
    keyBtn.TextColor3 = Color3.fromRGB(255, 255, 255)

    local conn
    conn = UIS.InputBegan:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.Keyboard then
            cfg.camlockKey = input.KeyCode
            keyBtn.Text = cfg.camlockKey.Name
            keyBtn.BackgroundColor3 = theme.LIGHT_BTN
            keyBtn.TextColor3 = theme.TEXT
            listeningKey = false
            conn:Disconnect()
        end
    end)
end)

local smoothCard = createContentCard(camlockPage, 52)
local smoothLbl = Instance.new("TextLabel", smoothCard)
smoothLbl.Size = UDim2.new(0.5, 0, 0, 18)
smoothLbl.Position = UDim2.new(0, 12, 0, 4)
smoothLbl.BackgroundTransparency = 1
smoothLbl.Text = "♡ smoothness"
smoothLbl.TextColor3 = theme.TEXT
smoothLbl.Font = Enum.Font.FredokaOne
smoothLbl.TextSize = 13
smoothLbl.TextXAlignment = Enum.TextXAlignment.Left

local smoothBox = Instance.new("TextBox", smoothCard)
smoothBox.Size = UDim2.new(0, 55, 0, 22)
smoothBox.Position = UDim2.new(1, -65, 0, 4)
smoothBox.BackgroundColor3 = theme.LIGHT_BTN
smoothBox.Text = string.format("%.2f", cfg.camlockSmoothness)
smoothBox.TextColor3 = theme.TEXT
smoothBox.Font = Enum.Font.FredokaOne
smoothBox.TextSize = 11
Instance.new("UICorner", smoothBox).CornerRadius = UDim.new(0, 8)

local smoothBg = Instance.new("Frame", smoothCard)
smoothBg.Size = UDim2.new(1, -24, 0, 6)
smoothBg.Position = UDim2.new(0, 12, 0, 36)
smoothBg.BackgroundColor3 = theme.LIGHT_BTN
Instance.new("UICorner", smoothBg).CornerRadius = UDim.new(1, 0)

local smoothFill = Instance.new("Frame", smoothBg)
smoothFill.Size = UDim2.new((cfg.camlockSmoothness - 0.01) / (1 - 0.01), 0, 1, 0)
smoothFill.BackgroundColor3 = theme.ACCENT
Instance.new("UICorner", smoothFill).CornerRadius = UDim.new(1, 0)

local smoothKnob = Instance.new("Frame", smoothBg)
smoothKnob.Size = UDim2.new(0, 12, 0, 12)
smoothKnob.AnchorPoint = Vector2.new(0.5, 0.5)
smoothKnob.Position = UDim2.new((cfg.camlockSmoothness - 0.01) / (1 - 0.01), 0, 0.5, 0)
smoothKnob.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
Instance.new("UICorner", smoothKnob).CornerRadius = UDim.new(1, 0)

local smoothDragging = false
local function updateSmoothSlider(input)
    local pos = math.clamp((input.Position.X - smoothBg.AbsolutePosition.X) / smoothBg.AbsoluteSize.X, 0, 1)
    local val = 0.01 + (1 - 0.01) * pos
    smoothFill.Size = UDim2.new(pos, 0, 1, 0)
    smoothKnob.Position = UDim2.new(pos, 0, 0.5, 0)
    smoothBox.Text = string.format("%.2f", val)
    cfg.camlockSmoothness = val
end
smoothBox.FocusLost:Connect(function()
    local num = tonumber(smoothBox.Text)
    if num then
        num = math.clamp(num, 0.01, 1)
        cfg.camlockSmoothness = num
        smoothBox.Text = string.format("%.2f", num)
        local pos = (num - 0.01) / (1 - 0.01)
        smoothFill.Size = UDim2.new(pos, 0, 1, 0)
        smoothKnob.Position = UDim2.new(pos, 0, 0.5, 0)
    else
        smoothBox.Text = string.format("%.2f", cfg.camlockSmoothness)
    end
end)
smoothBg.InputBegan:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseButton1 then smoothDragging = true updateSmoothSlider(input) end
end)
UIS.InputEnded:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseButton1 then smoothDragging = false end
end)
UIS.InputChanged:Connect(function(input)
    if smoothDragging and input.UserInputType == Enum.UserInputType.MouseMovement then updateSmoothSlider(input) end
end)

-- ================= TAB 3: VISUALS =================
local visualsPage = addTab("visuals")

local function addToggleCard(page, text, configKey)
    local card = createContentCard(page, 46)
    local lbl = Instance.new("TextLabel", card)
    lbl.Size = UDim2.new(0.65, 0, 1, 0)
    lbl.Position = UDim2.new(0, 12, 0, 0)
    lbl.BackgroundTransparency = 1
    lbl.Text = "♡ " .. text
    lbl.TextColor3 = theme.TEXT
    lbl.Font = Enum.Font.FredokaOne
    lbl.TextSize = 13
    lbl.TextXAlignment = Enum.TextXAlignment.Left

    local btn = Instance.new("TextButton", card)
    btn.Size = UDim2.new(0, 40, 0, 20)
    btn.Position = UDim2.new(1, -50, 0.5, -10)
    btn.BackgroundColor3 = cfg[configKey] and theme.ACCENT or theme.LIGHT_BTN
    btn.Text = ""
    btn.AutoButtonColor = false
    Instance.new("UICorner", btn).CornerRadius = UDim.new(1, 0)
    local circ = Instance.new("Frame", btn)
    circ.Size = UDim2.new(0, 16, 0, 16)
    circ.Position = cfg[configKey] and UDim2.new(1, -18, 0.5, -8) or UDim2.new(0, 2, 0.5, -8)
    circ.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
    Instance.new("UICorner", circ).CornerRadius = UDim.new(1, 0)

    btn.MouseButton1Click:Connect(function()
        cfg[configKey] = not cfg[configKey]
        btn.BackgroundColor3 = cfg[configKey] and theme.ACCENT or theme.LIGHT_BTN
        circ:TweenPosition(cfg[configKey] and UDim2.new(1, -18, 0.5, -8) or UDim2.new(0, 2, 0.5, -8), Enum.EasingDirection.Out, Enum.EasingStyle.Quad, 0.12, true)
    end)
end

addToggleCard(visualsPage, "esp boxes", "espBoxes")
addToggleCard(visualsPage, "esp names", "espNames")
addToggleCard(visualsPage, "esp health", "espHealth")

-- ESP Color Picker Card
local espColorCard = createContentCard(visualsPage, 84)
local espColorLbl = Instance.new("TextLabel", espColorCard)
espColorLbl.Size = UDim2.new(1, -24, 0, 20)
espColorLbl.Position = UDim2.new(0, 12, 0, 6)
espColorLbl.BackgroundTransparency = 1
espColorLbl.Text = "♡ esp color"
espColorLbl.TextColor3 = theme.TEXT
espColorLbl.Font = Enum.Font.FredokaOne
espColorLbl.TextSize = 13
espColorLbl.TextXAlignment = Enum.TextXAlignment.Left

local espColorGrid = Instance.new("Frame", espColorCard)
espColorGrid.Size = UDim2.new(1, -24, 0, 44)
espColorGrid.Position = UDim2.new(0, 12, 0, 30)
espColorGrid.BackgroundTransparency = 1

local espGridLayout = Instance.new("UIGridLayout", espColorGrid)
espGridLayout.CellSize = UDim2.new(0, 22, 0, 20)
espGridLayout.CellPadding = UDim2.new(0, 6, 0, 6)

for _, col in ipairs(presetColors) do
    local cBtn = Instance.new("TextButton", espColorGrid)
    cBtn.BackgroundColor3 = col
    cBtn.Text = ""
    cBtn.AutoButtonColor = false
    Instance.new("UICorner", cBtn).CornerRadius = UDim.new(0, 8)
    cBtn.MouseButton1Click:Connect(function()
        cfg.espColor = col
    end)
end

-- ================= TAB 4: WHITELIST =================
local whitelistPage = addTab("whitelist")

local wlScrollContainer = Instance.new("ScrollingFrame", whitelistPage)
wlScrollContainer.Size = UDim2.new(1, -10, 1, 0)
wlScrollContainer.BackgroundTransparency = 1
wlScrollContainer.BorderSizePixel = 0
wlScrollContainer.ScrollBarThickness = 3
wlScrollContainer.ScrollBarImageColor3 = theme.ACCENT

local wlListLayout = Instance.new("UIListLayout", wlScrollContainer)
wlListLayout.SortOrder = Enum.SortOrder.LayoutOrder
wlListLayout.Padding = UDim.new(0, 6)

wlListLayout:GetPropertyChangedSignal("AbsoluteContentSize"):Connect(function()
    wlScrollContainer.CanvasSize = UDim2.new(0, 0, 0, wlListLayout.AbsoluteContentSize.Y + 10)
end)

local function refreshWhitelist()
    for _, child in pairs(wlScrollContainer:GetChildren()) do
        if child:IsA("Frame") then child:Destroy() end
    end

    for _, p in pairs(Players:GetPlayers()) do
        if p ~= lp then
            local pCard = Instance.new("Frame", wlScrollContainer)
            pCard.Size = UDim2.new(1, 0, 0, 40)
            pCard.BackgroundColor3 = theme.CARD
            pCard.BorderSizePixel = 0
            Instance.new("UICorner", pCard).CornerRadius = UDim.new(0, 12)
            local s = Instance.new("UIStroke", pCard)
            s.Color = theme.STROKE
            s.Thickness = 1

            local nameLbl = Instance.new("TextLabel", pCard)
            nameLbl.Size = UDim2.new(0.6, 0, 1, 0)
            nameLbl.Position = UDim2.new(0, 12, 0, 0)
            nameLbl.BackgroundTransparency = 1
            nameLbl.Text = p.Name
            nameLbl.TextColor3 = theme.TEXT
            nameLbl.Font = Enum.Font.FredokaOne
            nameLbl.TextSize = 12
            nameLbl.TextXAlignment = Enum.TextXAlignment.Left

            local tBtn = Instance.new("TextButton", pCard)
            tBtn.Size = UDim2.new(0, 38, 0, 20)
            tBtn.Position = UDim2.new(1, -46, 0.5, -10)
            local isWl = cfg.whitelisted[p.UserId] == true
            tBtn.BackgroundColor3 = isWl and theme.ACCENT or theme.LIGHT_BTN
            tBtn.Text = ""
            tBtn.AutoButtonColor = false
            Instance.new("UICorner", tBtn).CornerRadius = UDim.new(1, 0)

            local c = Instance.new("Frame", tBtn)
            c.Size = UDim2.new(0, 16, 0, 16)
            c.Position = isWl and UDim2.new(1, -18, 0.5, -8) or UDim2.new(0, 2, 0.5, -8)
            c.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
            Instance.new("UICorner", c).CornerRadius = UDim.new(1, 0)

            tBtn.MouseButton1Click:Connect(function()
                cfg.whitelisted[p.UserId] = not cfg.whitelisted[p.UserId]
                local active = cfg.whitelisted[p.UserId]
                tBtn.BackgroundColor3 = active and theme.ACCENT or theme.LIGHT_BTN
                c:TweenPosition(active and UDim2.new(1, -18, 0.5, -8) or UDim2.new(0, 2, 0.5, -8), Enum.EasingDirection.Out, Enum.EasingStyle.Quad, 0.12, true)
            end)
        end
    end
end

Players.PlayerAdded:Connect(refreshWhitelist)
Players.PlayerRemoving:Connect(refreshWhitelist)
refreshWhitelist()

for _, tab in ipairs(tabButtons) do
    tab.Button.MouseButton1Click:Connect(function()
        selectTab(string.gsub(tab.Page.Name, "Page", ""))
    end)
end

selectTab("combat")

UIS.InputBegan:Connect(function(i, gpe)
    if gpe then return end
    if cfg.camlockEnabled and i.KeyCode == cfg.camlockKey then
        cfg.camlockActive = not cfg.camlockActive
        if not cfg.camlockActive then cfg.camlockTarget = nil end
    end
    if i.KeyCode == cfg.uiToggleKey then
        ScreenGui.Enabled = not ScreenGui.Enabled
    end
end)
