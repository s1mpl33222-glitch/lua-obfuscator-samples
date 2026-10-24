local UIS = game:GetService("UserInputService")
_G.MelodyB64 = [[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_9YetH_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_9YetH_CBk7RPBdz/2gAIAQEABj8C/wCNhuq9IUkrs7dGxUB7iHRcPcw22VOko7L9D1VvdDpWKh0bEdLbqrLAW6P3v7sbbLq6vNdX2W6DpsqrZG2yhVtboq5qoVNYroFK6lTRKqmn72j91XpaltJ7KmmRbo/bT4jpaI6WpbQoz1q7kqO8I5BfFd+VDG3hzQc0xBzxZh7z/wDSriH7KmI5BuPQ/NPBQ0ePqNgi5xiTJ7N3kd/Gdg3zulGDiW9JnjoEZyfSKCZjuPHOPPAUEzXeqxmhoAmeeJpPiN5GObe7kJ3M5jRRPht7xnf9M3ifSfDPecZ4T4f0nf8AtzeJPh/uE4zwnwnfafFd9s3iDtPhjvOM8JyflrO3m6ucezkZvF8onGilpsU5h4ShvDjnRjN+hmifM6umxb8QWRa4QI2+FgiVD1G5zpBsVEVw+fKQYmKNzgOen/qNit3EI+y33uKhhthn4FRbFh7L4v8ACjDxHv1/EalAaH21GA0amTPs3kNFkxzrkTFrXloamv48cnBuj0W9kXubey3QStx5+i32AqrHLyPW5hfkrzeEf0ougSOJTsP0kR1yir7+DhEI+zaBFb7BFbj3BUxB+F8Rq3sT8BeXxHuvDAeHkj7NoEchSmnUVdCuqatUbL5i+2p1y+2ysre6srK2y6v/AJ7z/8QALRABAAIABAUEAgIBBQAAAAAAAQARICExQTBAUFFhYHGBkaGxEMHwsMDR4fH/2gAIAQEAAT8h/wBi1V6XT0s+galcI9PvWjkD0pUPdTwjv6ORAazNBbKiNGB8mYg9wMsWcE9a24WYNWUfmxJZtMvCy7W3oI4NH3S6exFttx5a5WunebBc8bDo6dceALEf5cBUJZqNdieZHPX0KFs78ZXsgDYEP5cAXBZvQmuFoq55mCM2pZHeaOPUnIPlwXrZwMjdSZ/3YloIHhEv30Y1xMgfUvz+kRUKcFZpPMs+hAR4KKxpgVs8w8nT+L4r1ojrwn0UR5nXrpwHh3/Fy/Qy+ngvSCaKDbQ3hCHmTzs96e59zzs8jKd0VtD4GJQhqJ1m+DohYnWibov8IANDkNSETpZO6JrS63ohY7XU2q/eVzGlEPfU1s+uraGZQHcwK057VynxOwEcuoqZPma5myuhaInfB04LaJufSBRl0bwHdFP26WyyhGWvfpICksjZ8/STK4IVkOmW5Gfbo9i2Aoo6d5j++iv4N4AKOof33Q2IIdR1LP8AU6FmDVx7n+hjz6djlUQAfoNWlYYQH6h36Q95ymy2GcaqxmIyX_9YetH_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]]

local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local CoreGui = game:GetService("CoreGui")
local lp = Players.LocalPlayer
local cam = workspace.CurrentCamera
local mouse = lp:GetMouse()

local cfg = {
    silentAim = true,
    useKeybind = true,
    silentAimKey = Enum.KeyCode.V,
    uiToggleKey = Enum.KeyCode.RightControl,
    silentAimHitChance = 100,
    silentAimFOV = 150,
    silentAimFOVShow = false,
    silentAimFOVFilled = false,
    silentAimFOVOpacity = 0.2,
    silentAimFOVColor = Color3.fromRGB(255, 182, 215),

    silentAimPart = "Head",
    silentAimClosestPart = false,

    silentAimTeamCheck = false,
    silentAimWallCheck = false,
    knockCheck = false, -- ignore knocked / downed players
    triggerBot = false,
    triggerBotKey = Enum.KeyCode.T,
    triggerBotDelay = 0.08, -- seconds between auto clicks
    camlock = false,
    camlockKey = Enum.KeyCode.V,
    camlockSmooth = 0.25,
    espBoxes = false,
    espNames = false,
    espHealth = false,
    espColor = Color3.fromRGB(255, 112, 196),
    silentAimMaxDist = 1000,

    silentAimPredX = 0,
    silentAimPredY = 0,

    bypassRevolver = false,
    device = "pc",
}

local whitelist = {} -- [UserId] = true

local bodyPartsList = {
    "Head", "UpperTorso", "HumanoidRootPart", "LowerTorso",
    "LeftUpperArm", "RightUpperArm", "LeftLowerArm", "RightLowerArm",
    "LeftHand", "RightHand", "LeftUpperLeg", "RightUpperLeg",
    "LeftLowerLeg", "RightLowerLeg", "LeftFoot", "RightFoot"
}

local fovCircle
pcall(function()
    fovCircle = Drawing.new("Circle")
    fovCircle.Thickness = 1.5
    fovCircle.NumSides = 64
    fovCircle.Radius = cfg.silentAimFOV
    fovCircle.Color = cfg.silentAimFOVColor
    fovCircle.Filled = cfg.silentAimFOVFilled
    fovCircle.Visible = false
    fovCircle.Transparency = 1
end)

local fovGuiCircle
local function updateFovCircle(mousePos, show)
    local radius = math.max(10, cfg.silentAimFOV)
    if fovCircle then
        fovCircle.Visible = false
    end
    if fovGuiCircle then
        fovGuiCircle.Visible = show
        fovGuiCircle.Size = UDim2.fromOffset(radius * 2, radius * 2)
        fovGuiCircle.Position = UDim2.fromOffset(mousePos.X - radius, mousePos.Y - radius)
        local stroke = fovGuiCircle:FindFirstChildOfClass("UIStroke")
        if stroke then
            stroke.Color = cfg.silentAimFOVColor
        end
    end
end

local silentAimCachedPart = nil
local camlockPart = nil
local lastTriggerClick = 0
local triggerUi = nil
local camlockUi = nil
local espObjects = {}
local espParent = nil

local function clickMouse()
    if typeof(mouse1click) == "function" then
        mouse1click()
        return true
    end
    local ok = pcall(function()
        local vim = game:GetService("VirtualInputManager")
        local pos
        if cfg.device == "mob" then
            local vs = cam.ViewportSize
            pos = Vector2.new(vs.X / 2, vs.Y / 2)
        else
            pos = UIS:GetMouseLocation()
        end
        vim:SendMouseButtonEvent(pos.X, pos.Y, 0, true, game, 0)
        task.delay(0.02, function()
            vim:SendMouseButtonEvent(pos.X, pos.Y, 0, false, game, 0)
        end)
    end)
    return ok
end

local function isHoldingRevolver()
    if not cfg.bypassRevolver then return false end
    local char = lp.Character
    if not char then return false end
    local tool = char:FindFirstChildOfClass("Tool")
    if tool then
        local toolName = string.lower(tool.Name)
        if string.find(toolName, "revolver") or string.find(toolName, "rev") then
            return true
        end
    end
    return false
end

local function getAimPos()
    if cfg.device == "mob" then
        local vs = cam.ViewportSize
        return Vector2.new(vs.X / 2, vs.Y / 2)
    end
    return UIS:GetMouseLocation()
end

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

local function isWhitelisted(p)
    return p and whitelist[p.UserId] == true
end

local function sameTeam(p)
    return lp.Team and p.Team and lp.Team == p.Team
end

-- True when the player is knocked / downed and should be ignored.
-- Covers common FFA layouts: BodyEffects.K.O, Knocked bools, and a Knocked attribute.
local function isKnocked(p)
    local c = p and p.Character
    if not c then return false end

    if c:GetAttribute("Knocked") == true or c:GetAttribute("K.O") == true then
        return true
    end

    local be = c:FindFirstChild("BodyEffects")
    if be then
        for _, name in ipairs({ "K.O", "KO", "Knocked", "Downed" }) do
            local v = be:FindFirstChild(name)
            if v and v:IsA("BoolValue") and v.Value == true then
                return true
            end
        end
    end

    for _, name in ipairs({ "K.O", "KO", "Knocked", "Downed" }) do
        local v = c:FindFirstChild(name)
        if v and v:IsA("BoolValue") and v.Value == true then
            return true
        end
    end

    return false
end

local function wallBetween(pos)
    if not cfg.silentAimWallCheck then return false end
    local ro = cam.CFrame.Position
    local rd = pos - ro
    local params = RaycastParams.new()
    params.FilterDescendantsInstances = { lp.Character }
    params.FilterType = Enum.RaycastFilterType.Exclude
    local hit = workspace:Raycast(ro, rd, params)
    if not hit then return false end
    for _, p in pairs(Players:GetPlayers()) do
        if p.Character and hit.Instance:IsDescendantOf(p.Character) then return false end
    end
    return true
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
    local mousePos = getAimPos()
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

local function getClosestPlayerToCursor()
    if isHoldingRevolver() then return nil end

    local closestPlayer = nil
    local shortestDist = cfg.silentAimFOV
    local mousePos = getAimPos()

    for _, p in pairs(Players:GetPlayers()) do
        if p ~= lp and isAlive(p) then
            if cfg.silentAimTeamCheck and sameTeam(p) then continue end
            if isWhitelisted(p) then continue end
            if cfg.knockCheck and isKnocked(p) then continue end
            local hrp = getHRP(p)
            if hrp then
                local dist3D = (hrp.Position - cam.CFrame.Position).Magnitude
                if dist3D <= cfg.silentAimMaxDist then
                    local sp, onScreen = safeWorldToViewportPoint(hrp.Position)
                    if onScreen then
                        local dist2D = (Vector2.new(sp.X, sp.Y) - mousePos).Magnitude
                        if dist2D < shortestDist then
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

local function clearEsp(p)
    local pack = espObjects[p]
    if not pack then return end
    if pack.highlight then pack.highlight:Destroy() end
    if pack.bill then pack.bill:Destroy() end
    espObjects[p] = nil
end

local function updateEsp()
    if not (cfg.espBoxes or cfg.espNames or cfg.espHealth) then
        for p in pairs(espObjects) do
            clearEsp(p)
        end
        return
    end
    local seen = {}
    for _, p in ipairs(Players:GetPlayers()) do
        if p ~= lp and not isWhitelisted(p) and p.Character then
            local char = p.Character
            local hrp = char:FindFirstChild("HumanoidRootPart")
            local hum = char:FindFirstChildOfClass("Humanoid")
            if hrp and hum and hum.Health > 0 then
                seen[p] = true
                local pack = espObjects[p]
                if not pack or pack.char ~= char then
                    clearEsp(p)
                    pack = { char = char }
                    espObjects[p] = pack
                end
                if cfg.espBoxes then
                    if not pack.highlight then
                        local h = Instance.new("Highlight")
                        h.Name = "CuteEsp"
                        h.Adornee = char
                        h.FillTransparency = 0.72
                        h.OutlineTransparency = 0
                        h.DepthMode = Enum.HighlightDepthMode.AlwaysOnTop
                        h.Parent = espParent or CoreGui
                        pack.highlight = h
                    end
                    pack.highlight.Enabled = true
                    pack.highlight.FillColor = cfg.espColor
                    pack.highlight.OutlineColor = cfg.espColor
                elseif pack.highlight then
                    pack.highlight.Enabled = false
                end
                if cfg.espNames or cfg.espHealth then
                    if not pack.bill then
                        local bb = Instance.new("BillboardGui")
                        bb.Name = "CuteEspBill"
                        bb.AlwaysOnTop = true
                        bb.Size = UDim2.fromOffset(140, 40)
                        bb.StudsOffset = Vector3.new(0, 3.4, 0)
                        bb.Adornee = hrp
                        bb.Parent = espParent or CoreGui
                        local name = Instance.new("TextLabel", bb)
                        name.BackgroundTransparency = 1
                        name.Size = UDim2.new(1, 0, 0, 18)
                        name.Font = Enum.Font.FredokaOne
                        name.TextSize = 14
                        name.TextStrokeTransparency = 0.55
                        name.TextStrokeColor3 = Color3.fromRGB(64, 43, 75)
                        local barBg = Instance.new("Frame", bb)
                        barBg.BackgroundColor3 = Color3.fromRGB(64, 43, 75)
                        barBg.Position = UDim2.new(0.18, 0, 0, 22)
                        barBg.Size = UDim2.new(0.64, 0, 0, 7)
                        barBg.BorderSizePixel = 0
                        Instance.new("UICorner", barBg).CornerRadius = UDim.new(1, 0)
                        local fill = Instance.new("Frame", barBg)
                        fill.Size = UDim2.new(1, 0, 1, 0)
                        fill.BorderSizePixel = 0
                        Instance.new("UICorner", fill).CornerRadius = UDim.new(1, 0)
                        pack.bill = bb
                        pack.name = name
                        pack.bar = barBg
                        pack.fill = fill
                    end
                    pack.bill.Enabled = true
                    pack.bill.Adornee = hrp
                    pack.name.Visible = cfg.espNames
                    pack.name.Text = "♡ " .. p.DisplayName
                    pack.name.TextColor3 = cfg.espColor
                    pack.bar.Visible = cfg.espHealth
                    local ratio = hum.MaxHealth > 0 and math.clamp(hum.Health / hum.MaxHealth, 0, 1) or 0
                    pack.fill.Size = UDim2.new(ratio, 0, 1, 0)
                    pack.fill.BackgroundColor3 = cfg.espColor
                elseif pack.bill then
                    pack.bill.Enabled = false
                end
            end
        end
    end
    for p in pairs(espObjects) do
        if not seen[p] then
            clearEsp(p)
        end
    end
end

Players.PlayerRemoving:Connect(function(p)
    clearEsp(p)
end)

-- HOOK
pcall(function()
    local _grm = getrawmetatable(game)
    local _oldIndex = _grm.__index
    setreadonly(_grm, false)

    _grm.__index = function(self, key)
        if not checkcaller() and self == mouse and cfg.silentAim and not isHoldingRevolver() then
            if (key == "Hit" or key == "Target" or key == "UnitRay") and silentAimCachedPart then
                if math.random(1, 100) <= cfg.silentAimHitChance then
                    local origin = cam.CFrame.Position
                    local hitPos = silentAimCachedPart.Position + Vector3.new(
                        silentAimCachedPart.AssemblyLinearVelocity.X * cfg.silentAimPredX,
                        silentAimCachedPart.AssemblyLinearVelocity.Y * cfg.silentAimPredY,
                        silentAimCachedPart.AssemblyLinearVelocity.Z * cfg.silentAimPredX
                    )
                    if key == "UnitRay" then
                        return Ray.new(origin, (hitPos - origin).Unit)
                    elseif key == "Hit" then
                        return CFrame.new(hitPos)
                    elseif key == "Target" then
                        return silentAimCachedPart
                    end
                end
            end
        end
        return _oldIndex(self, key)
    end
    setreadonly(_grm, true)
end)

RunService.RenderStepped:Connect(function()
    local mousePos = getAimPos()
    updateFovCircle(mousePos, cfg.silentAimFOVShow and not isHoldingRevolver())

    if cfg.silentAim or cfg.triggerBot or cfg.camlock then
        silentAimCachedPart = getClosestPlayerToCursor()
    else
        silentAimCachedPart = nil
    end

    if cfg.camlock and not isHoldingRevolver() then
        local lockedOk = camlockPart and camlockPart.Parent and camlockPart:IsDescendantOf(workspace)
        if not lockedOk then
            camlockPart = silentAimCachedPart
        end
        if camlockPart then
            local goal = CFrame.lookAt(cam.CFrame.Position, camlockPart.Position)
            local alpha = math.clamp(cfg.camlockSmooth, 0.01, 1)
            cam.CFrame = cam.CFrame:Lerp(goal, alpha)
        end
    else
        camlockPart = nil
    end

    if cfg.triggerBot and silentAimCachedPart and not isHoldingRevolver() then
        local now = os.clock()
        if now - lastTriggerClick >= cfg.triggerBotDelay then
            lastTriggerClick = now
            clickMouse()
        end
    end
end)

------------------------------------------------
-- UI
------------------------------------------------
local ScreenGui = Instance.new("ScreenGui")
ScreenGui.Name = "AngelsDanFFA"
ScreenGui.ResetOnSpawn = false
ScreenGui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
ScreenGui.IgnoreGuiInset = true
ScreenGui.Enabled = true
ScreenGui.DisplayOrder = 999999

local function mountGui(gui)
    if typeof(gethui) == "function" then
        local ok = pcall(function()
            gui.Parent = gethui()
        end)
        if ok and gui.Parent then return end
    end
    if typeof(syn) == "table" and typeof(syn.protect_gui) == "function" then
        pcall(function()
            syn.protect_gui(gui)
            gui.Parent = CoreGui
        end)
        if gui.Parent then return end
    end
    local ok = pcall(function()
        gui.Parent = CoreGui
    end)
    if not ok or not gui.Parent then
        gui.Parent = lp:WaitForChild("PlayerGui")
    end
end

mountGui(ScreenGui)
espParent = ScreenGui
RunService.RenderStepped:Connect(updateEsp)

fovGuiCircle = Instance.new("Frame")
fovGuiCircle.Name = "FovCircle"
fovGuiCircle.AnchorPoint = Vector2.new(0, 0)
fovGuiCircle.BackgroundTransparency = 1
fovGuiCircle.BorderSizePixel = 0
fovGuiCircle.Active = false
fovGuiCircle.Visible = cfg.silentAimFOVShow
fovGuiCircle.ZIndex = 20
fovGuiCircle.Parent = ScreenGui
Instance.new("UICorner", fovGuiCircle).CornerRadius = UDim.new(1, 0)
local fovStroke = Instance.new("UIStroke", fovGuiCircle)
fovStroke.Color = cfg.silentAimFOVColor
fovStroke.Thickness = 2
fovStroke.ApplyStrokeMode = Enum.ApplyStrokeMode.Border

local Main = Instance.new("Frame")
Main.Name = "Main"
Main.ClipsDescendants = true
Main.Size = UDim2.new(0, 480, 0, 575)
Main.Position = UDim2.new(0.5, -240, 0.5, -287)
Main.BackgroundColor3 = Color3.fromRGB(28, 18, 38)
Main.BorderSizePixel = 0
Main.Active = true
Main.Visible = false
Main.Parent = ScreenGui

-- Dragging
local dragging, dragInput, dragStart, startPos
local Header

-- drag is bound for every panel at the end of the script

local UICorner = Instance.new("UICorner", Main)
UICorner.CornerRadius = UDim.new(0, 22)

local UIStroke = Instance.new("UIStroke", Main)
UIStroke.Color = Color3.fromRGB(255, 112, 45)
UIStroke.Thickness = 2.5

-- Header
Header = Instance.new("Frame", Main)
Header.Name = "Header"
Header.Size = UDim2.new(1, 0, 0, 62)
Header.BackgroundTransparency = 1

local Title = Instance.new("TextLabel", Header)
Title.Size = UDim2.new(1, -50, 1, 0)
Title.Position = UDim2.new(0, 18, 0, 0)
Title.BackgroundTransparency = 1
Title.Text = "☾🎃 Angels Dan FFA 🎃☽"
Title.TextColor3 = Color3.fromRGB(255, 143, 55)
Title.TextSize = 18
Title.Font = Enum.Font.FredokaOne
Title.TextXAlignment = Enum.TextXAlignment.Left
Title.TextYAlignment = Enum.TextYAlignment.Center
Title.TextStrokeTransparency = 0.75
Title.TextStrokeColor3 = Color3.fromRGB(255, 239, 220)

local Subtitle = Instance.new("TextLabel", Header)
Subtitle.Size = UDim2.new(1, -60, 0, 16)
Subtitle.Position = UDim2.new(0, 20, 0, 26)
Subtitle.BackgroundTransparency = 1
Subtitle.Text = "🎃 spooky cute menu · boo! 👻"
Subtitle.TextColor3 = Color3.fromRGB(200, 140, 180)
Subtitle.Font = Enum.Font.FredokaOne
Subtitle.TextSize = 11
Subtitle.TextXAlignment = Enum.TextXAlignment.Left

local DateLbl = Instance.new("TextLabel", Header)
DateLbl.Size = UDim2.new(1, -60, 0, 14)
DateLbl.Position = UDim2.new(0, 20, 1, -16)
DateLbl.BackgroundTransparency = 1
DateLbl.Text = os.date("%A, %d %B, %y")
DateLbl.TextColor3 = Color3.fromRGB(190, 151, 220)
DateLbl.Font = Enum.Font.FredokaOne
DateLbl.TextSize = 11
DateLbl.TextXAlignment = Enum.TextXAlignment.Left

task.spawn(function()
    while DateLbl.Parent do
        DateLbl.Text = os.date("%A, %d %B, %y")
        task.wait(30)
    end
end)

local melodyIcon = Instance.new("ImageLabel", Header)
melodyIcon.Name = "Melody"
melodyIcon.Size = UDim2.fromOffset(36, 36)
melodyIcon.Position = UDim2.new(1, -78, 0.5, -18)
melodyIcon.BackgroundColor3 = Color3.fromRGB(64, 43, 75)
melodyIcon.BackgroundTransparency = 0
melodyIcon.BorderSizePixel = 0
melodyIcon.Image = "rbxthumb://type=Asset&id=77227088795835&w=150&h=150"
melodyIcon.ScaleType = Enum.ScaleType.Fit
Instance.new("UICorner", melodyIcon).CornerRadius = UDim.new(1, 0)
local melodyStroke = Instance.new("UIStroke", melodyIcon)
melodyStroke.Color = Color3.fromRGB(255, 129, 48)
melodyStroke.Thickness = 1.5

task.spawn(function()
    pcall(function()
        if not writefile then return end
        local loader = getcustomasset or getsynasset
        if typeof(loader) ~= "function" then return end
        if not isfile or not isfile("melody_face.jpg") then
            if not _G.MelodyB64 then return end
            local b = "ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz0123456789+/"
            local data = string.gsub(_G.MelodyB64, "[^" .. b .. "=]", "")
            local decoded = data:gsub(".", function(x)
                if x == "=" then return "" end
                local r, f = "", (b:find(x) - 1)
                for i = 6, 1, -1 do
                    r = r .. (f % 2 ^ i - f % 2 ^ (i - 1) > 0 and "1" or "0")
                end
                return r
            end):gsub("%d%d%d?%d?%d?%d?%d?%d?", function(x)
                if #x ~= 8 then return "" end
                local c = 0
                for i = 1, 8 do
                    c = c + (x:sub(i, i) == "1" and 2 ^ (8 - i) or 0)
                end
                return string.char(c)
            end)
            writefile("melody_face.jpg", decoded)
        end
        local img = loader("melody_face.jpg")
        melodyIcon.Image = img
        if bubbleFace then
            bubbleFace.Image = img
        end
    end)
end)

local Device = Instance.new("Frame")
Device.Name = "DevicePick"
Device.Size = UDim2.new(0, 340, 0, 250)
Device.Position = UDim2.new(0.5, -170, 0.5, -125)
Device.BackgroundColor3 = Color3.fromRGB(28, 18, 38)
Device.BorderSizePixel = 0
Device.Active = true
Device.Visible = true
Device.Parent = ScreenGui
Instance.new("UICorner", Device).CornerRadius = UDim.new(0, 22)
local deviceStroke = Instance.new("UIStroke", Device)
deviceStroke.Color = Color3.fromRGB(255, 112, 45)
deviceStroke.Thickness = 2.5

local dTitle = Instance.new("TextLabel", Device)
dTitle.Size = UDim2.new(1, -24, 0, 32)
dTitle.Position = UDim2.new(0, 16, 0, 16)
dTitle.BackgroundTransparency = 1
dTitle.Text = "🎃 pick your spooky device 🎃"
dTitle.TextColor3 = Color3.fromRGB(255, 143, 55)
dTitle.Font = Enum.Font.FredokaOne
dTitle.TextSize = 22
dTitle.TextXAlignment = Enum.TextXAlignment.Left

local dSub = Instance.new("TextLabel", Device)
dSub.Size = UDim2.new(1, -24, 0, 18)
dSub.Position = UDim2.new(0, 16, 0, 48)
dSub.BackgroundTransparency = 1
dSub.Text = "☾ choose your haunt: pc or mob ☽"
dSub.TextColor3 = Color3.fromRGB(190, 151, 220)
dSub.Font = Enum.Font.FredokaOne
dSub.TextSize = 13
dSub.TextXAlignment = Enum.TextXAlignment.Left

local function makeDeviceButton(text, sub, y)
    local btn = Instance.new("TextButton", Device)
    btn.Size = UDim2.new(1, -32, 0, 64)
    btn.Position = UDim2.new(0, 16, 0, y)
    btn.BackgroundColor3 = Color3.fromRGB(48, 31, 61)
    btn.Text = ""
    btn.AutoButtonColor = false
    Instance.new("UICorner", btn).CornerRadius = UDim.new(0, 16)
    local s = Instance.new("UIStroke", btn)
    s.Color = Color3.fromRGB(255, 126, 55)
    s.Thickness = 1.4

    local name = Instance.new("TextLabel", btn)
    name.Size = UDim2.new(1, -20, 0, 24)
    name.Position = UDim2.new(0, 14, 0, 8)
    name.BackgroundTransparency = 1
    name.Text = text
    name.TextColor3 = Color3.fromRGB(255, 143, 55)
    name.Font = Enum.Font.FredokaOne
    name.TextSize = 18
    name.TextXAlignment = Enum.TextXAlignment.Left

    local hint = Instance.new("TextLabel", btn)
    hint.Size = UDim2.new(1, -20, 0, 18)
    hint.Position = UDim2.new(0, 14, 0, 34)
    hint.BackgroundTransparency = 1
    hint.Text = sub
    hint.TextColor3 = Color3.fromRGB(190, 151, 220)
    hint.Font = Enum.Font.FredokaOne
    hint.TextSize = 12
    hint.TextXAlignment = Enum.TextXAlignment.Left
    return btn
end

local pcBtn = makeDeviceButton("♡ pc", "⋆ follows your cursor ⋆", 82)
local mobBtn = makeDeviceButton("♡ mob", "⋆ fov stays in the middle ⋆", 158)

local function pickDevice(mode)
    cfg.device = mode
    Device.Visible = false
    if mode == "mob" then
        Main.Size = UDim2.fromOffset(300, 420)
        Main.Position = UDim2.new(0.5, -150, 0.5, -210)
        Title.TextSize = 16
        if White then
            White.Size = UDim2.fromOffset(280, 340)
            White.Position = UDim2.new(0.5, -140, 0.55, -150)
        end
    else
        Main.Size = UDim2.fromOffset(480, 575)
        Main.Position = UDim2.new(0.5, -240, 0.5, -287)
        Title.TextSize = 18
        if White then
            White.Size = UDim2.fromOffset(340, 460)
            White.Position = UDim2.new(0.5, 250, 0.5, -230)
        end
    end
    Main.Visible = true
    Subtitle.Text = mode == "mob" and "⋆˚｡⋆ mob · middle fov ⋆｡˚⋆" or "🎃 spooky cute menu · boo! 👻"
end

pcBtn.MouseButton1Click:Connect(function()
    pickDevice("pc")
end)
mobBtn.MouseButton1Click:Connect(function()
    pickDevice("mob")
end)

local MinimizeBtn = Instance.new("TextButton", Header)
MinimizeBtn.Size = UDim2.new(0, 28, 0, 28)
MinimizeBtn.Position = UDim2.new(1, -38, 0.5, -14)
MinimizeBtn.BackgroundColor3 = Color3.fromRGB(100, 55, 130)
MinimizeBtn.Text = "−"
MinimizeBtn.TextColor3 = Color3.fromRGB(255, 157, 65)
MinimizeBtn.Font = Enum.Font.FredokaOne
MinimizeBtn.TextSize = 18
MinimizeBtn.AutoButtonColor = false

Instance.new("UICorner", MinimizeBtn).CornerRadius = UDim.new(0, 10)

-- Mini Bubble
local MiniBubble = Instance.new("TextButton", ScreenGui)
MiniBubble.Name = "MiniBubble"
MiniBubble.Size = UDim2.new(0, 56, 0, 56)
MiniBubble.Position = UDim2.new(0.5, -28, 0.5, -28)
MiniBubble.BackgroundColor3 = Color3.fromRGB(57, 34, 72)
MiniBubble.Text = ""
MiniBubble.AutoButtonColor = false
MiniBubble.Visible = false
MiniBubble.Active = true
Instance.new("UICorner", MiniBubble).CornerRadius = UDim.new(1, 0)

local bubbleFace = Instance.new("ImageLabel", MiniBubble)
bubbleFace.Name = "Melody"
bubbleFace.Size = UDim2.new(1, -8, 1, -8)
bubbleFace.Position = UDim2.new(0, 4, 0, 4)
bubbleFace.BackgroundColor3 = Color3.fromRGB(38, 25, 51)
bubbleFace.BackgroundTransparency = 0
bubbleFace.BorderSizePixel = 0
bubbleFace.Image = melodyIcon.Image
bubbleFace.ScaleType = Enum.ScaleType.Crop
Instance.new("UICorner", bubbleFace).CornerRadius = UDim.new(1, 0)

local BubbleStroke = Instance.new("UIStroke", MiniBubble)
BubbleStroke.Color = Color3.fromRGB(255, 123, 45)
BubbleStroke.Thickness = 2.4

-- Scroll
local Scroll = Instance.new("ScrollingFrame", Main)
Scroll.Size = UDim2.new(1, -24, 1, -72)
Scroll.Position = UDim2.new(0, 12, 0, 62)
Scroll.BackgroundTransparency = 1
Scroll.BorderSizePixel = 0
Scroll.ScrollBarThickness = 6
Scroll.ScrollBarImageColor3 = Color3.fromRGB(156, 91, 196)
Scroll.ScrollingEnabled = true
Scroll.Active = true
Scroll.ElasticBehavior = Enum.ElasticBehavior.Never
Scroll.CanvasSize = UDim2.new(0, 0, 0, 0)

Scroll.InputBegan:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.MouseWheel then
        dragging = false
    end
end)

local UIList = Instance.new("UIListLayout", Scroll)
UIList.SortOrder = Enum.SortOrder.LayoutOrder
UIList.Padding = UDim.new(0, 11)

UIList:GetPropertyChangedSignal("AbsoluteContentSize"):Connect(function()
    Scroll.CanvasSize = UDim2.new(0, 0, 0, UIList.AbsoluteContentSize.Y + 12)
end)

local function minimizeUI()
    local x = math.clamp(Main.AbsolutePosition.X + (Main.AbsoluteSize.X / 2) - 25, 0, cam.ViewportSize.X - 50)
    local y = math.clamp(Main.AbsolutePosition.Y + (Main.AbsoluteSize.Y / 2) - 25, 0, cam.ViewportSize.Y - 50)
    MiniBubble.Position = UDim2.new(0, x, 0, y)
    Main.Visible = false
    MiniBubble.Visible = true
end

local function restoreUI()
    local x = math.clamp(MiniBubble.AbsolutePosition.X - (Main.AbsoluteSize.X / 2) + 25, 0, cam.ViewportSize.X - Main.AbsoluteSize.X)
    local y = math.clamp(MiniBubble.AbsolutePosition.Y - (Main.AbsoluteSize.Y / 2) + 25, 0, cam.ViewportSize.Y - Main.AbsoluteSize.Y)
    Main.Position = UDim2.new(0, x, 0, y)
    MiniBubble.Visible = false
    Main.Visible = true
end

MinimizeBtn.MouseButton1Click:Connect(minimizeUI)
MiniBubble.MouseButton1Click:Connect(restoreUI)

-- Helpers
local function createCard(height)
    local card = Instance.new("Frame")
    card.Size = UDim2.new(1, -8, 0, height or 42)
    card.BackgroundColor3 = Color3.fromRGB(48, 31, 61)
    card.BorderSizePixel = 0
    card.Parent = Scroll

    Instance.new("UICorner", card).CornerRadius = UDim.new(0, 14)

    local s = Instance.new("UIStroke", card)
    s.Color = Color3.fromRGB(111, 71, 137)
    s.Thickness = 1.2
    return card
end

local function addToggle(text, default, callback, subtitle)
    local card = createCard(subtitle and 52 or 42)
    local lbl = Instance.new("TextLabel", card)
    lbl.Size = UDim2.new(0.7, 0, subtitle and 0 or 1, subtitle and 22 or 0)
    lbl.Position = UDim2.new(0, 12, 0, subtitle and 6 or 0)
    lbl.BackgroundTransparency = 1
    lbl.Text = text
    lbl.TextColor3 = Color3.fromRGB(255, 143, 55)
    lbl.Font = Enum.Font.FredokaOne
    lbl.TextSize = 14
    lbl.TextXAlignment = Enum.TextXAlignment.Left

    if subtitle then
        local sub = Instance.new("TextLabel", card)
        sub.Size = UDim2.new(0.7, 0, 0, 16)
        sub.Position = UDim2.new(0, 12, 0, 28)
        sub.BackgroundTransparency = 1
        sub.Text = "♡ " .. subtitle
        sub.TextColor3 = Color3.fromRGB(190, 151, 220)
        sub.Font = Enum.Font.FredokaOne
        sub.TextSize = 11
        sub.TextXAlignment = Enum.TextXAlignment.Left
    end

    local btn = Instance.new("TextButton", card)
    btn.Size = UDim2.new(0, 46, 0, 24)
    btn.Position = UDim2.new(1, -56, 0.5, -12)
    btn.BackgroundColor3 = default and Color3.fromRGB(255, 119, 38) or Color3.fromRGB(59, 39, 72)
    btn.Text = ""
    btn.AutoButtonColor = false

    Instance.new("UICorner", btn).CornerRadius = UDim.new(1, 0)

    local circle = Instance.new("Frame", btn)
    circle.Size = UDim2.new(0, 20, 0, 20)
    circle.Position = default and UDim2.new(1, -22, 0.5, -10) or UDim2.new(0, 2, 0.5, -10)
    circle.BackgroundColor3 = Color3.fromRGB(255, 239, 220)

    Instance.new("UICorner", circle).CornerRadius = UDim.new(1, 0)

    local state = default
    btn.MouseButton1Click:Connect(function()
        state = not state
        btn.BackgroundColor3 = state and Color3.fromRGB(255, 119, 38) or Color3.fromRGB(59, 39, 72)
        circle:TweenPosition(state and UDim2.new(1, -22, 0.5, -10) or UDim2.new(0, 2, 0.5, -10), Enum.EasingDirection.Out, Enum.EasingStyle.Quad, 0.15, true)
        callback(state)
    end)
end

local sliderLock = false

local function addSlider(text, min, max, default, callback)
    local card = createCard(52)

    local lbl = Instance.new("TextLabel", card)
    lbl.Size = UDim2.new(0.6, 0, 0, 20)
    lbl.Position = UDim2.new(0, 12, 0, 5)
    lbl.BackgroundTransparency = 1
    lbl.Text = text
    lbl.TextColor3 = Color3.fromRGB(255, 143, 55)
    lbl.Font = Enum.Font.FredokaOne
    lbl.TextSize = 14
    lbl.TextXAlignment = Enum.TextXAlignment.Left

    local valLbl = Instance.new("TextLabel", card)
    valLbl.Size = UDim2.new(0.3, 0, 0, 20)
    valLbl.Position = UDim2.new(0.7, -10, 0, 5)
    valLbl.BackgroundTransparency = 1
    valLbl.Text = tostring(default)
    valLbl.TextColor3 = Color3.fromRGB(218, 164, 228)
    valLbl.Font = Enum.Font.SourceSans
    valLbl.TextSize = 14
    valLbl.TextXAlignment = Enum.TextXAlignment.Right

    local bg = Instance.new("Frame", card)
    bg.Size = UDim2.new(1, -24, 0, 9)
    bg.Position = UDim2.new(0, 12, 0, 32)
    bg.BackgroundColor3 = Color3.fromRGB(78, 48, 91)
    Instance.new("UICorner", bg).CornerRadius = UDim.new(1, 0)

    local fill = Instance.new("Frame", bg)
    local startPos = (default - min) / (max - min)
    fill.Size = UDim2.new(startPos, 0, 1, 0)
    fill.BackgroundColor3 = Color3.fromRGB(255, 119, 38)
    Instance.new("UICorner", fill).CornerRadius = UDim.new(1, 0)

    local knob = Instance.new("Frame", bg)
    knob.Size = UDim2.fromOffset(16, 16)
    knob.AnchorPoint = Vector2.new(0.5, 0.5)
    knob.Position = UDim2.new(startPos, 0, 0.5, 0)
    knob.BackgroundColor3 = Color3.fromRGB(255, 239, 220)
    knob.ZIndex = 3
    Instance.new("UICorner", knob).CornerRadius = UDim.new(1, 0)
    local knobStroke = Instance.new("UIStroke", knob)
    knobStroke.Color = Color3.fromRGB(255, 129, 48)
    knobStroke.Thickness = 1.5

    local sDragging = false
    local function update(input)
        local pos = math.clamp((input.Position.X - bg.AbsolutePosition.X) / bg.AbsoluteSize.X, 0, 1)
        local val = math.floor(min + (max - min) * pos)
        fill.Size = UDim2.new(pos, 0, 1, 0)
        knob.Position = UDim2.new(pos, 0, 0.5, 0)
        valLbl.Text = tostring(val)
        callback(val)
    end

    bg.InputBegan:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
            sDragging = true
            sliderLock = true
            dragTarget = nil
            update(input)
        end
    end)

    UIS.InputEnded:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
            sDragging = false
            sliderLock = false
        end
    end)

    UIS.InputChanged:Connect(function(input)
        if sDragging and (input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch) then
            update(input)
        end
    end)
end

local function addDropdown(text, list, default, callback)
    local card = createCard(42)

    local lbl = Instance.new("TextLabel", card)
    lbl.Size = UDim2.new(0.4, 0, 1, 0)
    lbl.Position = UDim2.new(0, 12, 0, 0)
    lbl.BackgroundTransparency = 1
    lbl.Text = text
    lbl.TextColor3 = Color3.fromRGB(255, 143, 55)
    lbl.Font = Enum.Font.FredokaOne
    lbl.TextSize = 14
    lbl.TextXAlignment = Enum.TextXAlignment.Left

    local btn = Instance.new("TextButton", card)
    btn.Size = UDim2.new(0.55, 0, 0, 28)
    btn.Position = UDim2.new(0.42, 0, 0.5, -14)
    btn.BackgroundColor3 = Color3.fromRGB(255, 230, 245)
    btn.Text = default
    btn.TextColor3 = Color3.fromRGB(170, 209, 115)
    btn.Font = Enum.Font.SourceSans
    btn.TextSize = 14
    Instance.new("UICorner", btn).CornerRadius = UDim.new(0, 8)

    local s = Instance.new("UIStroke", btn)
    s.Color = Color3.fromRGB(255, 126, 55)

    local dropFrame = Instance.new("ScrollingFrame", Scroll)
    dropFrame.Size = UDim2.new(1, -6, 0, 120)
    dropFrame.BackgroundColor3 = Color3.fromRGB(255, 239, 220)
    dropFrame.Visible = false
    dropFrame.BorderSizePixel = 0
    dropFrame.ScrollBarThickness = 3
    Instance.new("UICorner", dropFrame).CornerRadius = UDim.new(0, 10)

    local dList = Instance.new("UIListLayout", dropFrame)
    dList.SortOrder = Enum.SortOrder.LayoutOrder

    dList:GetPropertyChangedSignal("AbsoluteContentSize"):Connect(function()
        dropFrame.CanvasSize = UDim2.new(0, 0, 0, dList.AbsoluteContentSize.Y)
    end)

    for _, v in ipairs(list) do
        local item = Instance.new("TextButton", dropFrame)
        item.Size = UDim2.new(1, 0, 0, 26)
        item.BackgroundTransparency = 1
        item.Text = v
        item.TextColor3 = Color3.fromRGB(255, 163, 72)
        item.Font = Enum.Font.SourceSans
        item.TextSize = 13

        item.MouseButton1Click:Connect(function()
            btn.Text = v
            dropFrame.Visible = false
            callback(v)
        end)
    end

    btn.MouseButton1Click:Connect(function()
        dropFrame.Visible = not dropFrame.Visible
    end)
end

local function addKeybind(text, defaultKey, callback)
    local card = createCard(42)
    local lbl = Instance.new("TextLabel", card)
    lbl.Size = UDim2.new(0.6, 0, 1, 0)
    lbl.Position = UDim2.new(0, 12, 0, 0)
    lbl.BackgroundTransparency = 1
    lbl.Text = text
    lbl.TextColor3 = Color3.fromRGB(255, 143, 55)
    lbl.Font = Enum.Font.FredokaOne
    lbl.TextSize = 14
    lbl.TextXAlignment = Enum.TextXAlignment.Left

    local btn = Instance.new("TextButton", card)
    btn.Size = UDim2.new(0, 84, 0, 26)
    btn.Position = UDim2.new(1, -94, 0.5, -13)
    btn.BackgroundColor3 = Color3.fromRGB(255, 230, 245)
    btn.Text = defaultKey.Name
    btn.TextColor3 = Color3.fromRGB(170, 209, 115)
    btn.Font = Enum.Font.SourceSansBold
    btn.TextSize = 12
    Instance.new("UICorner", btn).CornerRadius = UDim.new(0, 8)

    local s = Instance.new("UIStroke", btn)
    s.Color = Color3.fromRGB(255, 126, 55)

    local listening = false
    btn.MouseButton1Click:Connect(function()
        listening = true
        btn.Text = "..."
    end)

    UIS.InputBegan:Connect(function(input, gpe)
        if listening and not gpe and input.UserInputType == Enum.UserInputType.Keyboard then
            listening = false
            btn.Text = input.KeyCode.Name
            callback(input.KeyCode)
        end
    end)
end

local function addFOVColorPicker()
    local card = createCard(58)

    local title = Instance.new("TextLabel", card)
    title.Size = UDim2.new(1, -20, 0, 22)
    title.Position = UDim2.new(0, 12, 0, 4)
    title.BackgroundTransparency = 1
    title.Text = "♡ fov color"
    title.Font = Enum.Font.FredokaOne
    title.TextSize = 14
    title.TextXAlignment = Enum.TextXAlignment.Left

    local colors = {
        Color3.fromRGB(235, 64, 64),
        Color3.fromRGB(255, 149, 48),
        Color3.fromRGB(255, 214, 48),
        Color3.fromRGB(92, 214, 92),
        Color3.fromRGB(48, 214, 214),
        Color3.fromRGB(72, 112, 255),
        Color3.fromRGB(168, 92, 255),
        Color3.fromRGB(255, 112, 196),
        Color3.fromRGB(24, 24, 28),
    }

    local row = Instance.new("Frame", card)
    row.Size = UDim2.new(1, -20, 0, 22)
    row.Position = UDim2.new(0, 10, 0, 28)
    row.BackgroundTransparency = 1

    local layout = Instance.new("UIListLayout", row)
    layout.FillDirection = Enum.FillDirection.Horizontal
    layout.Padding = UDim.new(0, 6)
    layout.VerticalAlignment = Enum.VerticalAlignment.Center

    local swatches = {}
    local function paintSelection()
        for _, sw in ipairs(swatches) do
            sw.stroke.Enabled = sw.color == cfg.silentAimFOVColor
            sw.stroke.Color = Color3.fromRGB(255, 239, 220)
            sw.stroke.Thickness = 2
        end
    end

    for _, color in ipairs(colors) do
        local sw = Instance.new("TextButton", row)
        sw.Size = UDim2.new(0, 18, 0, 18)
        sw.BackgroundColor3 = color
        sw.Text = ""
        sw.AutoButtonColor = false
        Instance.new("UICorner", sw).CornerRadius = UDim.new(0, 4)
        local stroke = Instance.new("UIStroke", sw)
        stroke.Enabled = false
        swatches[#swatches + 1] = { color = color, stroke = stroke }
        sw.MouseButton1Click:Connect(function()
            cfg.silentAimFOVColor = color
            paintSelection()
        end)
    end
    paintSelection()
end

local function addSection(title, sub)
    local holder = Instance.new("Frame")
    holder.Size = UDim2.new(1, -8, 0, sub and 34 or 18)
    holder.BackgroundTransparency = 1
    holder.Parent = Scroll

    local dot = Instance.new("TextLabel", holder)
    dot.Size = UDim2.new(1, -8, 0, 16)
    dot.Position = UDim2.new(0, 4, 0, 0)
    dot.BackgroundTransparency = 1
    dot.Text = "♡˚  " .. title .. "  ˚♡"
    dot.TextColor3 = Color3.fromRGB(255, 143, 55)
    dot.Font = Enum.Font.FredokaOne
    dot.TextSize = 15
    dot.TextXAlignment = Enum.TextXAlignment.Left

    if sub then
        local subLbl = Instance.new("TextLabel", holder)
        subLbl.Size = UDim2.new(1, -8, 0, 14)
        subLbl.Position = UDim2.new(0, 16, 0, 16)
        subLbl.BackgroundTransparency = 1
        subLbl.Text = "⋆˚ " .. sub .. " ˚⋆"
        subLbl.TextColor3 = Color3.fromRGB(190, 151, 220)
        subLbl.Font = Enum.Font.FredokaOne
        subLbl.TextSize = 11
        subLbl.TextXAlignment = Enum.TextXAlignment.Left
    end
end

-- Add all controls
addSection("🎃 haunted controls", "spooky little settings 👻")
addToggle("🎃 soft aim", cfg.silentAim, function(v) cfg.silentAim = v end)
addToggle("♡ show fov ring", cfg.silentAimFOVShow, function(v) cfg.silentAimFOVShow = v end)
addSlider("♡ fov size", 10, 500, cfg.silentAimFOV, function(v) cfg.silentAimFOV = v end)

addFOVColorPicker()

addSection("👻 spooky visuals", "haunted little overlays 🎃")
addToggle("♡ pretty boxes", cfg.espBoxes, function(v) cfg.espBoxes = v end, "see them through walls")
addToggle("♡ cute names", cfg.espNames, function(v) cfg.espNames = v end, "hearts by names")
addToggle("♡ health hearts", cfg.espHealth, function(v) cfg.espHealth = v end, "pink health bar")

do
    local card = createCard(58)
    local title = Instance.new("TextLabel", card)
    title.Size = UDim2.new(1, -20, 0, 22)
    title.Position = UDim2.new(0, 12, 0, 4)
    title.BackgroundTransparency = 1
    title.Text = "♡ pretty color"
    title.TextColor3 = Color3.fromRGB(255, 143, 55)
    title.Font = Enum.Font.FredokaOne
    title.TextSize = 15
    title.TextXAlignment = Enum.TextXAlignment.Left

    local colors = {
        Color3.fromRGB(235, 64, 64),
        Color3.fromRGB(255, 149, 48),
        Color3.fromRGB(255, 214, 48),
        Color3.fromRGB(92, 214, 92),
        Color3.fromRGB(48, 214, 214),
        Color3.fromRGB(72, 112, 255),
        Color3.fromRGB(168, 92, 255),
        Color3.fromRGB(255, 112, 196),
        Color3.fromRGB(24, 24, 28),
    }
    local row = Instance.new("Frame", card)
    row.Size = UDim2.new(1, -20, 0, 22)
    row.Position = UDim2.new(0, 10, 0, 28)
    row.BackgroundTransparency = 1
    local layout = Instance.new("UIListLayout", row)
    layout.FillDirection = Enum.FillDirection.Horizontal
    layout.Padding = UDim.new(0, 6)
    local swatches = {}
    local function paintSelection()
        for _, sw in ipairs(swatches) do
            sw.stroke.Enabled = sw.color == cfg.espColor
            sw.stroke.Color = Color3.fromRGB(255, 239, 220)
            sw.stroke.Thickness = 2
        end
    end
    for _, color in ipairs(colors) do
        local sw = Instance.new("TextButton", row)
        sw.Size = UDim2.new(0, 18, 0, 18)
        sw.BackgroundColor3 = color
        sw.Text = ""
        sw.AutoButtonColor = false
        Instance.new("UICorner", sw).CornerRadius = UDim.new(0, 4)
        local stroke = Instance.new("UIStroke", sw)
        stroke.Enabled = false
        swatches[#swatches + 1] = { color = color, stroke = stroke }
        sw.MouseButton1Click:Connect(function()
            cfg.espColor = color
            paintSelection()
        end)
    end
    paintSelection()
end

addSection("🎃 haunted fog", "cute spooky mist presets 👻")

local Lighting = game:GetService("Lighting")
local savedFog = {
    FogColor = Lighting.FogColor,
    FogStart = Lighting.FogStart,
    FogEnd = Lighting.FogEnd,
    Ambient = Lighting.Ambient,
    OutdoorAmbient = Lighting.OutdoorAmbient,
    Brightness = Lighting.Brightness,
}

local fogPresets = {
    { "♡ Reset Lighting", nil },
    { "♡ Soft Pink", Color3.fromRGB(255, 126, 38) },
    { "♡ Dreamy Blue", Color3.fromRGB(140, 112, 190) },
    { "♡ Lavender Mist", Color3.fromRGB(156, 104, 205) },
    { "♡ Warm Sunset", Color3.fromRGB(255, 126, 38) },
    { "♡ Mint Dream", Color3.fromRGB(147, 211, 112) },
    { "♡ Red", Color3.fromRGB(255, 73, 61) },
    { "♡ Light Red", Color3.fromRGB(255, 144, 91) },
    { "♡ Dark Red", Color3.fromRGB(135, 31, 48) },
    { "♡ Orange", Color3.fromRGB(255, 119, 30) },
    { "♡ Light Orange", Color3.fromRGB(255, 173, 93) },
    { "♡ Dark Orange", Color3.fromRGB(172, 72, 20) },
    { "♡ Yellow", Color3.fromRGB(255, 201, 76) },
    { "♡ Lime", Color3.fromRGB(165, 218, 89) },
    { "♡ Green", Color3.fromRGB(108, 179, 76) },
    { "♡ Cyan", Color3.fromRGB(93, 203, 181) },
    { "♡ Electric Blue", Color3.fromRGB(125, 142, 255) },
    { "♡ Blue", Color3.fromRGB(103, 101, 226) },
    { "♡ Purple", Color3.fromRGB(153, 85, 214) },
    { "♡ Violet", Color3.fromRGB(121, 60, 177) },
    { "♡ Pink", Color3.fromRGB(255, 121, 89) },
    { "🎃 Pumpkin Glow", Color3.fromRGB(255, 119, 30) },
    { "👻 Ghostly White", Color3.fromRGB(225, 232, 245) },
    { "🧙 Witchy Purple", Color3.fromRGB(121, 60, 177) },
    { "🕸️ Midnight Black", Color3.fromRGB(22, 14, 31) },
    { "☠️ Toxic Slime", Color3.fromRGB(145, 210, 65) },
    { "🩸 Spooky Crimson", Color3.fromRGB(165, 30, 52) },
    { "♡ Hot Pink", Color3.fromRGB(245, 78, 107) },
}

local function applyFog(color)
    if not color then
        Lighting.FogColor = savedFog.FogColor
        Lighting.FogStart = savedFog.FogStart
        Lighting.FogEnd = savedFog.FogEnd
        Lighting.Ambient = savedFog.Ambient
        Lighting.OutdoorAmbient = savedFog.OutdoorAmbient
        Lighting.Brightness = savedFog.Brightness
        return
    end
    Lighting.FogColor = color
    Lighting.FogStart = 0
    Lighting.FogEnd = 280
    Lighting.Ambient = color:Lerp(Color3.new(1, 1, 1), 0.35)
    Lighting.OutdoorAmbient = color
end

for _, preset in ipairs(fogPresets) do
    local name, color = preset[1], preset[2]
    local btn = Instance.new("TextButton")
    btn.Size = UDim2.new(1, -8, 0, 36)
    btn.BackgroundColor3 = Color3.fromRGB(38, 25, 51)
    btn.Text = name
    btn.TextColor3 = color or Color3.fromRGB(255, 145, 56)
    btn.Font = Enum.Font.FredokaOne
    btn.TextSize = 14
    btn.AutoButtonColor = false
    btn.Parent = Scroll
    Instance.new("UICorner", btn).CornerRadius = UDim.new(0, 12)
    local stroke = Instance.new("UIStroke", btn)
    stroke.Color = Color3.fromRGB(255, 210, 230)
    stroke.Thickness = 1.2
    btn.MouseButton1Click:Connect(function()
        applyFog(color)
    end)
end

addSection("camlock", "soft camera hug")
addToggle("♡ camlock", cfg.camlock, function(v)
    cfg.camlock = v
    if not v then
        camlockPart = nil
    end
end, "sticky little lock")

do
    local smoothLbl = Instance.new("TextLabel")
    smoothLbl.Size = UDim2.new(1, -8, 0, 16)
    smoothLbl.BackgroundTransparency = 1
    smoothLbl.Text = "·  softness :: " .. string.format("%.2f", cfg.camlockSmooth)
    smoothLbl.TextColor3 = Color3.fromRGB(255, 140, 190)
    smoothLbl.Font = Enum.Font.GothamMedium
    smoothLbl.TextSize = 12
    smoothLbl.TextXAlignment = Enum.TextXAlignment.Left
    smoothLbl.Parent = Scroll

    local card = createCard(58)
    local title = Instance.new("TextLabel", card)
    title.Size = UDim2.new(0.6, 0, 0, 18)
    title.Position = UDim2.new(0, 12, 0, 6)
    title.BackgroundTransparency = 1
    title.Text = "♡ softness"
    title.TextColor3 = Color3.fromRGB(255, 145, 56)
    title.Font = Enum.Font.GothamBold
    title.TextSize = 14
    title.TextXAlignment = Enum.TextXAlignment.Left

    local valLbl = Instance.new("TextLabel", card)
    valLbl.Size = UDim2.new(0.5, 0, 0, 16)
    valLbl.Position = UDim2.new(0, 12, 0, 24)
    valLbl.BackgroundTransparency = 1
    valLbl.Text = string.format("%.2f", cfg.camlockSmooth)
    valLbl.TextColor3 = Color3.fromRGB(255, 140, 190)
    valLbl.Font = Enum.Font.GothamMedium
    valLbl.TextSize = 13
    valLbl.TextXAlignment = Enum.TextXAlignment.Left

    local bg = Instance.new("Frame", card)
    bg.Size = UDim2.new(1, -24, 0, 6)
    bg.Position = UDim2.new(0, 12, 0, 44)
    bg.BackgroundColor3 = Color3.fromRGB(255, 214, 232)
    Instance.new("UICorner", bg).CornerRadius = UDim.new(1, 0)

    local fill = Instance.new("Frame", bg)
    fill.Size = UDim2.new(cfg.camlockSmooth, 0, 1, 0)
    fill.BackgroundColor3 = Color3.fromRGB(255, 132, 61)
    Instance.new("UICorner", fill).CornerRadius = UDim.new(1, 0)

    local knob = Instance.new("Frame", bg)
    knob.Size = UDim2.fromOffset(16, 16)
    knob.AnchorPoint = Vector2.new(0.5, 0.5)
    knob.Position = UDim2.new(cfg.camlockSmooth, 0, 0.5, 0)
    knob.BackgroundColor3 = Color3.fromRGB(255, 239, 220)
    knob.ZIndex = 3
    Instance.new("UICorner", knob).CornerRadius = UDim.new(1, 0)
    local knobStroke = Instance.new("UIStroke", knob)
    knobStroke.Color = Color3.fromRGB(255, 129, 48)
    knobStroke.Thickness = 1.5

    local sDragging = false
    local function update(input)
        local pos = math.clamp((input.Position.X - bg.AbsolutePosition.X) / bg.AbsoluteSize.X, 0, 1)
        local val = math.floor(pos * 100 + 0.5) / 100
        if val < 0.01 then val = 0.01 end
        cfg.camlockSmooth = val
        fill.Size = UDim2.new(val, 0, 1, 0)
        knob.Position = UDim2.new(val, 0, 0.5, 0)
        valLbl.Text = string.format("%.2f", val)
        smoothLbl.Text = "·  softness :: " .. string.format("%.2f", val)
    end
    bg.InputBegan:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
            sDragging = true
            sliderLock = true
            dragTarget = nil
            update(input)
        end
    end)
    UIS.InputEnded:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
            sDragging = false
            sliderLock = false
        end
    end)
    UIS.InputChanged:Connect(function(input)
        if sDragging and (input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch) then
            update(input)
        end
    end)
end

do
    local card = createCard(42)
    local lbl = Instance.new("TextLabel", card)
    lbl.Size = UDim2.new(0.5, 0, 1, 0)
    lbl.Position = UDim2.new(0, 12, 0, 0)
    lbl.BackgroundTransparency = 1
    lbl.Text = "♡ keybind"
    lbl.TextColor3 = Color3.fromRGB(255, 145, 56)
    lbl.Font = Enum.Font.GothamMedium
    lbl.TextSize = 14
    lbl.TextXAlignment = Enum.TextXAlignment.Left

    local btn = Instance.new("TextButton", card)
    btn.Size = UDim2.new(0, 72, 0, 26)
    btn.Position = UDim2.new(1, -84, 0.5, -13)
    btn.BackgroundColor3 = Color3.fromRGB(64, 43, 75)
    btn.Text = cfg.camlockKey.Name
    btn.TextColor3 = Color3.fromRGB(255, 151, 73)
    btn.Font = Enum.Font.GothamMedium
    btn.TextSize = 13
    btn.AutoButtonColor = false
    Instance.new("UICorner", btn).CornerRadius = UDim.new(0, 8)

    local listening = false
    btn.MouseButton1Click:Connect(function()
        listening = true
        btn.Text = "..."
    end)

    camlockUi = {
        set = function(state)
            cfg.camlock = state
            if not state then
                camlockPart = nil
            end
        end,
        setKey = function(key)
            cfg.camlockKey = key
            btn.Text = key.Name
            listening = false
        end,
        isListening = function()
            return listening
        end,
    }
end

addToggle("♡ skip revolver", cfg.bypassRevolver, function(v) cfg.bypassRevolver = v end)
addToggle("♡ wall check", cfg.silentAimWallCheck, function(v) cfg.silentAimWallCheck = v end)
addToggle("♡ knock check", cfg.knockCheck, function(v) cfg.knockCheck = v end, "skip knocked cuties")

do
    local card = createCard(64)
    local lbl = Instance.new("TextLabel", card)
    lbl.Size = UDim2.new(0.7, 0, 0, 20)
    lbl.Position = UDim2.new(0, 12, 0, 6)
    lbl.BackgroundTransparency = 1
    lbl.Text = "♡ triggerbot"
    lbl.TextColor3 = Color3.fromRGB(255, 143, 55)
    lbl.Font = Enum.Font.FredokaOne
    lbl.TextSize = 14
    lbl.TextXAlignment = Enum.TextXAlignment.Left

    local sub = Instance.new("TextLabel", card)
    sub.Size = UDim2.new(0.7, 0, 0, 14)
    sub.Position = UDim2.new(0, 12, 0, 26)
    sub.BackgroundTransparency = 1
    sub.Text = "♡ auto click when ready"
    sub.TextColor3 = Color3.fromRGB(194, 153, 213)
    sub.Font = Enum.Font.Gotham
    sub.TextSize = 11
    sub.TextXAlignment = Enum.TextXAlignment.Left

    local keyLbl = Instance.new("TextButton", card)
    keyLbl.Size = UDim2.new(0.7, 0, 0, 14)
    keyLbl.Position = UDim2.new(0, 12, 0, 42)
    keyLbl.BackgroundTransparency = 1
    keyLbl.Text = "key: " .. cfg.triggerBotKey.Name
    keyLbl.TextColor3 = Color3.fromRGB(203, 144, 193)
    keyLbl.Font = Enum.Font.Gotham
    keyLbl.TextSize = 11
    keyLbl.TextXAlignment = Enum.TextXAlignment.Left
    keyLbl.AutoButtonColor = false

    local btn = Instance.new("TextButton", card)
    btn.Size = UDim2.new(0, 46, 0, 24)
    btn.Position = UDim2.new(1, -56, 0.5, -12)
    btn.BackgroundColor3 = cfg.triggerBot and Color3.fromRGB(255, 119, 38) or Color3.fromRGB(59, 39, 72)
    btn.Text = ""
    btn.AutoButtonColor = false
    Instance.new("UICorner", btn).CornerRadius = UDim.new(1, 0)

    local circle = Instance.new("Frame", btn)
    circle.Size = UDim2.new(0, 20, 0, 20)
    circle.Position = cfg.triggerBot and UDim2.new(1, -22, 0.5, -10) or UDim2.new(0, 2, 0.5, -10)
    circle.BackgroundColor3 = Color3.fromRGB(255, 239, 220)
    Instance.new("UICorner", circle).CornerRadius = UDim.new(1, 0)

    local listening = false

    local function setTrigger(state)
        cfg.triggerBot = state
        btn.BackgroundColor3 = state and Color3.fromRGB(255, 119, 38) or Color3.fromRGB(59, 39, 72)
        circle:TweenPosition(state and UDim2.new(1, -22, 0.5, -10) or UDim2.new(0, 2, 0.5, -10), Enum.EasingDirection.Out, Enum.EasingStyle.Quad, 0.15, true)
    end

    btn.MouseButton1Click:Connect(function()
        setTrigger(not cfg.triggerBot)
    end)

    keyLbl.MouseButton1Click:Connect(function()
        listening = true
        keyLbl.Text = "key: ..."
    end)

    triggerUi = {
        set = setTrigger,
        setKey = function(key)
            cfg.triggerBotKey = key
            keyLbl.Text = "key: " .. key.Name
            listening = false
        end,
        isListening = function()
            return listening
        end,
    }
end

addToggle("♡ closest part", cfg.silentAimClosestPart, function(v) cfg.silentAimClosestPart = v end)
addDropdown("♡ hit part", bodyPartsList, cfg.silentAimPart, function(v) cfg.silentAimPart = v end)
addToggle("♡ use keybind", cfg.useKeybind, function(v) cfg.useKeybind = v end)
addKeybind("♡ aim key", cfg.silentAimKey, function(v) cfg.silentAimKey = v end)
addKeybind("♡ hide menu key", cfg.uiToggleKey, function(v) cfg.uiToggleKey = v end)

-- Whitelist menu
White = Instance.new("Frame")
White.Name = "Whitelist"
White.Size = UDim2.new(0, 340, 0, 460)
White.Position = UDim2.new(0.5, 250, 0.5, -230)
White.BackgroundColor3 = Color3.fromRGB(38, 25, 51)
White.BorderSizePixel = 0
White.Visible = false
White.Active = true
White.Parent = ScreenGui
Instance.new("UICorner", White).CornerRadius = UDim.new(0, 18)
local whiteStroke = Instance.new("UIStroke", White)
whiteStroke.Color = Color3.fromRGB(255, 129, 48)
whiteStroke.Thickness = 2

local wTitle = Instance.new("TextLabel", White)
wTitle.Size = UDim2.new(1, -50, 0, 28)
wTitle.Position = UDim2.new(0, 16, 0, 10)
wTitle.BackgroundTransparency = 1
wTitle.Text = "♡ sweet list ♡"
wTitle.TextColor3 = Color3.fromRGB(255, 145, 56)
wTitle.Font = Enum.Font.FredokaOne
wTitle.TextSize = 22
wTitle.TextXAlignment = Enum.TextXAlignment.Left

local wClose = Instance.new("TextButton", White)
wClose.Size = UDim2.new(0, 26, 0, 26)
wClose.Position = UDim2.new(1, -36, 0, 10)
wClose.BackgroundColor3 = Color3.fromRGB(88, 51, 111)
wClose.Text = "×"
wClose.TextColor3 = Color3.fromRGB(255, 145, 56)
wClose.Font = Enum.Font.FredokaOne
wClose.TextSize = 18
wClose.AutoButtonColor = false
Instance.new("UICorner", wClose).CornerRadius = UDim.new(0, 8)

local wSub = Instance.new("TextLabel", White)
wSub.Size = UDim2.new(1, -24, 0, 16)
wSub.Position = UDim2.new(0, 16, 0, 40)
wSub.BackgroundTransparency = 1
wSub.Text = "⋆ friends to skip, cutie ⋆"
wSub.Font = Enum.Font.FredokaOne
wSub.TextSize = 14
wSub.TextXAlignment = Enum.TextXAlignment.Left

local wScroll = Instance.new("ScrollingFrame", White)
wScroll.Size = UDim2.new(1, -20, 1, -78)
wScroll.Position = UDim2.new(0, 10, 0, 66)
wScroll.BackgroundTransparency = 1
wScroll.BorderSizePixel = 0
wScroll.ScrollBarThickness = 4
wScroll.ScrollBarImageColor3 = Color3.fromRGB(156, 91, 196)
wScroll.CanvasSize = UDim2.new(0, 0, 0, 0)

local wList = Instance.new("UIListLayout", wScroll)
wList.SortOrder = Enum.SortOrder.LayoutOrder
wList.Padding = UDim.new(0, 8)
wList:GetPropertyChangedSignal("AbsoluteContentSize"):Connect(function()
    wScroll.CanvasSize = UDim2.new(0, 0, 0, wList.AbsoluteContentSize.Y + 8)
end)

local playerRows = {}

local function makePlayerRow(p)
    if playerRows[p] then return end

    local row = Instance.new("Frame")
    row.Size = UDim2.new(1, -6, 0, 52)
    row.BackgroundColor3 = Color3.fromRGB(255, 239, 220)
    row.BorderSizePixel = 0
    row.Parent = wScroll
    Instance.new("UICorner", row).CornerRadius = UDim.new(0, 12)
    local rs = Instance.new("UIStroke", row)
    rs.Color = Color3.fromRGB(255, 214, 232)
    rs.Thickness = 1

    local nameLbl = Instance.new("TextLabel", row)
    nameLbl.Size = UDim2.new(1, -78, 0, 20)
    nameLbl.Position = UDim2.new(0, 12, 0, 6)
    nameLbl.BackgroundTransparency = 1
    nameLbl.Text = p.DisplayName
    nameLbl.TextColor3 = Color3.fromRGB(245, 229, 255)
    nameLbl.Font = Enum.Font.GothamMedium
    nameLbl.TextSize = 14
    nameLbl.TextXAlignment = Enum.TextXAlignment.Left
    nameLbl.TextTruncate = Enum.TextTruncate.AtEnd

    local userLbl = Instance.new("TextLabel", row)
    userLbl.Size = UDim2.new(1, -78, 0, 16)
    userLbl.Position = UDim2.new(0, 12, 0, 28)
    userLbl.BackgroundTransparency = 1
    userLbl.Text = "@" .. p.Name
    userLbl.TextColor3 = Color3.fromRGB(199, 157, 205)
    userLbl.Font = Enum.Font.Gotham
    userLbl.TextSize = 12
    userLbl.TextXAlignment = Enum.TextXAlignment.Left
    userLbl.TextTruncate = Enum.TextTruncate.AtEnd

    local on = whitelist[p.UserId] == true
    local btn = Instance.new("TextButton", row)
    btn.Size = UDim2.new(0, 46, 0, 24)
    btn.Position = UDim2.new(1, -58, 0.5, -12)
    btn.BackgroundColor3 = on and Color3.fromRGB(143, 72, 171) or Color3.fromRGB(64, 43, 75)
    btn.Text = ""
    btn.AutoButtonColor = false
    Instance.new("UICorner", btn).CornerRadius = UDim.new(1, 0)

    local circle = Instance.new("Frame", btn)
    circle.Size = UDim2.new(0, 18, 0, 18)
    circle.Position = on and UDim2.new(1, -21, 0.5, -9) or UDim2.new(0, 3, 0.5, -9)
    circle.BackgroundColor3 = on and Color3.fromRGB(255, 126, 38) or Color3.fromRGB(255, 239, 220)
    Instance.new("UICorner", circle).CornerRadius = UDim.new(1, 0)

    btn.MouseButton1Click:Connect(function()
        on = not on
        whitelist[p.UserId] = on or nil
        btn.BackgroundColor3 = on and Color3.fromRGB(143, 72, 171) or Color3.fromRGB(64, 43, 75)
        circle.BackgroundColor3 = on and Color3.fromRGB(255, 126, 38) or Color3.fromRGB(255, 239, 220)
        circle:TweenPosition(on and UDim2.new(1, -21, 0.5, -9) or UDim2.new(0, 3, 0.5, -9), Enum.EasingDirection.Out, Enum.EasingStyle.Quad, 0.15, true)
    end)

    playerRows[p] = row
end

local function refreshWhitelist()
    for _, p in ipairs(Players:GetPlayers()) do
        if p ~= lp then
            makePlayerRow(p)
        end
    end
end

Players.PlayerAdded:Connect(function(p)
    if p ~= lp then
        makePlayerRow(p)
    end
end)

Players.PlayerRemoving:Connect(function(p)
    local row = playerRows[p]
    if row then
        row:Destroy()
        playerRows[p] = nil
    end
end)

refreshWhitelist()

local openCard = createCard(42)
local openLbl = Instance.new("TextLabel", openCard)
openLbl.Size = UDim2.new(0.62, 0, 1, 0)
openLbl.Position = UDim2.new(0, 12, 0, 0)
openLbl.BackgroundTransparency = 1
openLbl.Text = "♡ sweet list"
openLbl.TextColor3 = Color3.fromRGB(255, 143, 55)
openLbl.Font = Enum.Font.FredokaOne
openLbl.TextSize = 14
openLbl.TextXAlignment = Enum.TextXAlignment.Left

local openBtn = Instance.new("TextButton", openCard)
openBtn.Size = UDim2.new(0, 84, 0, 26)
openBtn.Position = UDim2.new(1, -94, 0.5, -13)
openBtn.BackgroundColor3 = Color3.fromRGB(255, 230, 245)
openBtn.Text = "open ♡"
openBtn.TextColor3 = Color3.fromRGB(255, 145, 56)
openBtn.Font = Enum.Font.GothamMedium
openBtn.TextSize = 13
openBtn.AutoButtonColor = false
Instance.new("UICorner", openBtn).CornerRadius = UDim.new(0, 8)
Instance.new("UIStroke", openBtn).Color = Color3.fromRGB(255, 126, 55)

openBtn.MouseButton1Click:Connect(function()
    White.Visible = not White.Visible
    openBtn.Text = White.Visible and "close ♡" or "open ♡"
end)
wClose.MouseButton1Click:Connect(function()
    White.Visible = false
    openBtn.Text = "open ♡"
end)

-- Character / outfit menu
local CharMenu = Instance.new("Frame")
CharMenu.Name = "CharMenu"
CharMenu.Size = UDim2.fromOffset(cfg.device == "mob" and 280 or 340, 230)
CharMenu.Position = UDim2.new(0.5, -170, 0.5, -115)
CharMenu.BackgroundColor3 = Color3.fromRGB(38, 25, 51)
CharMenu.BorderSizePixel = 0
CharMenu.Visible = false
CharMenu.Active = true
CharMenu.Parent = ScreenGui
Instance.new("UICorner", CharMenu).CornerRadius = UDim.new(0, 18)
local charStroke = Instance.new("UIStroke", CharMenu)
charStroke.Color = Color3.fromRGB(255, 129, 48)
charStroke.Thickness = 2

local cTitle = Instance.new("TextLabel", CharMenu)
cTitle.Size = UDim2.new(1, -50, 0, 28)
cTitle.Position = UDim2.new(0, 16, 0, 12)
cTitle.BackgroundTransparency = 1
cTitle.Text = "♡˚ outfit copy ˚♡"
cTitle.TextColor3 = Color3.fromRGB(255, 143, 55)
cTitle.Font = Enum.Font.FredokaOne
cTitle.TextSize = 22
cTitle.TextXAlignment = Enum.TextXAlignment.Left

local cClose = Instance.new("TextButton", CharMenu)
cClose.Size = UDim2.new(0, 26, 0, 26)
cClose.Position = UDim2.new(1, -36, 0, 12)
cClose.BackgroundColor3 = Color3.fromRGB(88, 51, 111)
cClose.Text = "×"
cClose.TextColor3 = Color3.fromRGB(255, 145, 56)
cClose.Font = Enum.Font.FredokaOne
cClose.TextSize = 18
cClose.AutoButtonColor = false
Instance.new("UICorner", cClose).CornerRadius = UDim.new(0, 8)

local cSub = Instance.new("TextLabel", CharMenu)
cSub.Size = UDim2.new(1, -24, 0, 16)
cSub.Position = UDim2.new(0, 16, 0, 42)
cSub.BackgroundTransparency = 1
cSub.Text = "⋆ username or id, cutie ⋆"
cSub.TextColor3 = Color3.fromRGB(190, 151, 220)
cSub.Font = Enum.Font.FredokaOne
cSub.TextSize = 13
cSub.TextXAlignment = Enum.TextXAlignment.Left

local nameBox = Instance.new("TextBox", CharMenu)
nameBox.Size = UDim2.new(1, -32, 0, 36)
nameBox.Position = UDim2.new(0, 16, 0, 72)
nameBox.BackgroundColor3 = Color3.fromRGB(48, 31, 61)
nameBox.PlaceholderText = "♡ username or id"
nameBox.PlaceholderColor3 = Color3.fromRGB(214, 160, 190)
nameBox.Text = ""
nameBox.TextColor3 = Color3.fromRGB(255, 145, 56)
nameBox.Font = Enum.Font.FredokaOne
nameBox.TextSize = 16
nameBox.ClearTextOnFocus = false
Instance.new("UICorner", nameBox).CornerRadius = UDim.new(0, 12)
Instance.new("UIStroke", nameBox).Color = Color3.fromRGB(255, 126, 55)

local wearBtn = Instance.new("TextButton", CharMenu)
wearBtn.Size = UDim2.new(1, -32, 0, 36)
wearBtn.Position = UDim2.new(0, 16, 0, 118)
wearBtn.BackgroundColor3 = Color3.fromRGB(255, 129, 48)
wearBtn.Text = "♡ copy outfit"
wearBtn.TextColor3 = Color3.fromRGB(48, 31, 61)
wearBtn.Font = Enum.Font.FredokaOne
wearBtn.TextSize = 16
wearBtn.AutoButtonColor = false
Instance.new("UICorner", wearBtn).CornerRadius = UDim.new(0, 12)

local cStatus = Instance.new("TextLabel", CharMenu)
cStatus.Size = UDim2.new(1, -32, 0, 36)
cStatus.Position = UDim2.new(0, 16, 0, 162)
cStatus.BackgroundTransparency = 1
cStatus.Text = "⋆ type a name, then wear ♡ ⋆"
cStatus.TextColor3 = Color3.fromRGB(190, 151, 220)
cStatus.Font = Enum.Font.FredokaOne
cStatus.TextSize = 13
cStatus.TextWrapped = true

local wearing = false
local copiedUserId = nil

local function resolveUserId(typed)
    typed = tostring(typed):gsub("%s+", ""):gsub("^@", "")
    if typed == "" then return nil end
    local id = tonumber(typed)
    if id then return id end
    local ok, result = pcall(function()
        return Players:GetUserIdFromNameAsync(typed)
    end)
    if ok then return result end
    return nil
end

local function applyAnimationsFromDummy(char, dummyModel)
    local dummyAnimate = dummyModel:FindFirstChild("Animate")
    local myHumanoid = char:FindFirstChildOfClass("Humanoid")
    if not myHumanoid then return end

    local animator = myHumanoid:FindFirstChildOfClass("Animator")
    if not animator then
        animator = Instance.new("Animator")
        animator.Parent = myHumanoid
    end
    for _, track in ipairs(animator:GetPlayingAnimationTracks()) do
        track:Stop(0)
    end

    if dummyAnimate then
        local old = char:FindFirstChild("Animate")
        if old then old:Destroy() end
        local clone = dummyAnimate:Clone()
        clone.Disabled = true
        clone.Parent = char
        task.wait(0.05)
        clone.Disabled = false
    end

    local animate = char:FindFirstChild("Animate")
    local dummyHum = dummyModel:FindFirstChildOfClass("Humanoid")
    local desc = dummyHum and dummyHum:GetAppliedDescription()
    if animate and desc then
        local map = {
            idle = desc.IdleAnimation,
            walk = desc.WalkAnimation,
            run = desc.RunAnimation,
            jump = desc.JumpAnimation,
            fall = desc.FallAnimation,
            climb = desc.ClimbAnimation,
            swim = desc.SwimAnimation,
        }
        pcall(function()
            map.mood = desc.MoodAnimation
        end)
        for folderName, animId in pairs(map) do
            if typeof(animId) == "number" and animId ~= 0 then
                local folder = animate:FindFirstChild(folderName)
                if not folder then
                    folder = Instance.new("StringValue")
                    folder.Name = folderName
                    folder.Parent = animate
                end
                local id = "rbxassetid://" .. tostring(animId)
                local found = false
                for _, child in ipairs(folder:GetChildren()) do
                    if child:IsA("Animation") then
                        child.AnimationId = id
                        found = true
                    end
                end
                if not found then
                    local anim = Instance.new("Animation")
                    anim.Name = folderName .. "Anim"
                    anim.AnimationId = id
                    anim.Parent = folder
                end
            end
        end
    end

    if dummyAnimate and animate then
        for _, dummyChild in ipairs(dummyAnimate:GetChildren()) do
            local myChild = animate:FindFirstChild(dummyChild.Name)
            if not myChild then
                dummyChild:Clone().Parent = animate
            else
                for _, animObj in ipairs(dummyChild:GetDescendants()) do
                    if animObj:IsA("Animation") then
                        local targetAnim = myChild:FindFirstChild(animObj.Name, true)
                        if targetAnim and targetAnim:IsA("Animation") then
                            targetAnim.AnimationId = animObj.AnimationId
                        else
                            animObj:Clone().Parent = myChild
                        end
                    end
                end
            end
        end
    end

    local idleId
    if desc and typeof(desc.IdleAnimation) == "number" and desc.IdleAnimation ~= 0 then
        idleId = "rbxassetid://" .. tostring(desc.IdleAnimation)
    end
    if idleId then
        local anim = Instance.new("Animation")
        anim.AnimationId = idleId
        pcall(function()
            local track = animator:LoadAnimation(anim)
            track.Priority = Enum.AnimationPriority.Idle
            track.Looped = true
            track:Play(0.15)
        end)
    end
end

local function applyFullOutfit(char, userId)
    local myHumanoid = char:WaitForChild("Humanoid", 5)
    if not myHumanoid then error("no humanoid") end

    local dummyModel
    local okDummy = pcall(function()
        dummyModel = Players:CreateHumanoidModelFromUserId(userId)
    end)
    if not okDummy or not dummyModel then
        local desc = Players:GetHumanoidDescriptionFromUserId(userId)
        dummyModel = Players:CreateHumanoidModelFromDescription(desc, myHumanoid.RigType)
    end
    if not dummyModel then error("could not build avatar") end

    local holder = Instance.new("Folder")
    holder.Name = "AvatarCopyHold"
    holder.Parent = workspace
    dummyModel.Parent = holder

    pcall(function()
        local dummyHum = dummyModel:FindFirstChildOfClass("Humanoid")
        local humDesc = dummyHum and dummyHum:GetAppliedDescription()
        if humDesc then
            myHumanoid:ApplyDescription(humDesc)
            pcall(function() myHumanoid.BodyHeightScale.Value = humDesc.HeightScale end)
            pcall(function() myHumanoid.BodyWidthScale.Value = humDesc.WidthScale end)
            pcall(function() myHumanoid.BodyDepthScale.Value = humDesc.DepthScale end)
            pcall(function() myHumanoid.HeadScale.Value = humDesc.HeadScale end)
            pcall(function() myHumanoid.BodyTypeScale.Value = humDesc.BodyTypeScale end)
            pcall(function() myHumanoid.BodyProportionScale.Value = humDesc.ProportionScale end)
        end
    end)
    task.wait(0.15)

    for _, obj in ipairs(char:GetChildren()) do
        if obj:IsA("Accessory") or obj:IsA("Hat") or obj:IsA("Shirt") or obj:IsA("Pants") or obj:IsA("ShirtGraphic") or obj:IsA("BodyColors") or obj:IsA("CharacterMesh") or obj.Name == "FakeHead" or string.sub(obj.Name, 1, 4) == "Fake" then
            obj:Destroy()
        end
    end

    local targetColors = dummyModel:FindFirstChildOfClass("BodyColors")
    if targetColors then
        targetColors:Clone().Parent = char
    end

    for _, item in ipairs(dummyModel:GetChildren()) do
        if item:IsA("Shirt") or item:IsA("Pants") or item:IsA("ShirtGraphic") or item:IsA("CharacterMesh") then
            item:Clone().Parent = char
        end
    end

    local function copyNamedPart(partName)
        local src = dummyModel:FindFirstChild(partName)
        local dst = char:FindFirstChild(partName)
        if not src or not dst or not src:IsA("BasePart") or not dst:IsA("BasePart") then return end
        dst.Color = src.Color
        pcall(function() dst.Size = src.Size end)
        local meshOk = false
        if src:IsA("MeshPart") and dst:IsA("MeshPart") then
            meshOk = pcall(function()
                dst.MeshId = src.MeshId
                dst.TextureID = src.TextureID
            end)
        end
        local srcMesh = src:FindFirstChildOfClass("SpecialMesh")
        local dstMesh = dst:FindFirstChildOfClass("SpecialMesh")
        if srcMesh and dstMesh then
            dstMesh.MeshId = srcMesh.MeshId
            dstMesh.TextureId = srcMesh.TextureId
            dstMesh.Scale = srcMesh.Scale
            meshOk = true
        elseif srcMesh then
            srcMesh:Clone().Parent = dst
            meshOk = true
        end
        for _, child in ipairs(src:GetChildren()) do
            if child:IsA("WrapLayer") or child:IsA("WrapTarget") or child:IsA("SurfaceAppearance") then
                local old = dst:FindFirstChild(child.Name)
                if old then old:Destroy() end
                child:Clone().Parent = dst
            end
        end
        local fakeName = "Fake" .. partName
        local oldFake = char:FindFirstChild(fakeName)
        if oldFake then oldFake:Destroy() end
        if src:IsA("MeshPart") and not meshOk then
            dst.Transparency = 1
            local fake = src:Clone()
            fake.Name = fakeName
            fake.CanCollide = false
            fake.Massless = true
            fake.Anchored = false
            for _, c in ipairs(fake:GetChildren()) do
                if c:IsA("Motor6D") or c:IsA("Weld") or c:IsA("Attachment") then
                    c:Destroy()
                end
            end
            fake.Parent = char
            local weld = Instance.new("Weld")
            weld.Name = fakeName .. "Weld"
            weld.Part0 = dst
            weld.Part1 = fake
            weld.Parent = fake
        else
            dst.Transparency = src.Transparency
        end
    end

    local bodyNames = {
        "Torso", "UpperTorso", "LowerTorso",
        "Left Arm", "Right Arm", "Left Leg", "Right Leg",
        "LeftUpperArm", "LeftLowerArm", "LeftHand",
        "RightUpperArm", "RightLowerArm", "RightHand",
        "LeftUpperLeg", "LeftLowerLeg", "LeftFoot",
        "RightUpperLeg", "RightLowerLeg", "RightFoot",
    }
    for _, partName in ipairs(bodyNames) do
        copyNamedPart(partName)
    end
    for _, src in ipairs(dummyModel:GetChildren()) do
        if src:IsA("BasePart") and src.Name ~= "HumanoidRootPart" and src.Name ~= "Head" then
            if char:FindFirstChild(src.Name) then
                copyNamedPart(src.Name)
            end
        end
    end
    local colors = char:FindFirstChildOfClass("BodyColors")
    if colors then
        local map = {
            HeadColor3 = "Head",
            TorsoColor3 = "Torso",
            LeftArmColor3 = "Left Arm",
            RightArmColor3 = "Right Arm",
            LeftLegColor3 = "Left Leg",
            RightLegColor3 = "Right Leg",
        }
        for prop, partName in pairs(map) do
            local part = char:FindFirstChild(partName) or char:FindFirstChild(partName == "Torso" and "UpperTorso" or "")
            if part and part:IsA("BasePart") then
                pcall(function() part.Color = colors[prop] end)
            end
        end
        local upper = char:FindFirstChild("UpperTorso")
        local lower = char:FindFirstChild("LowerTorso")
        if upper then pcall(function() upper.Color = colors.TorsoColor3 end) end
        if lower then pcall(function() lower.Color = colors.TorsoColor3 end) end
    end

    local targetHead = dummyModel:FindFirstChild("Head")
    local myHead = char:FindFirstChild("Head")
    if targetHead and myHead then
        for _, child in ipairs(myHead:GetChildren()) do
            if child:IsA("SpecialMesh") or child:IsA("CharacterMesh") or child:IsA("Decal") or child:IsA("Texture") or child:IsA("SurfaceAppearance") or child:IsA("WrapTarget") then
                child:Destroy()
            end
        end
        myHead.Color = targetHead.Color
        local meshOk = false
        if targetHead:IsA("MeshPart") and myHead:IsA("MeshPart") then
            meshOk = pcall(function()
                myHead.MeshId = targetHead.MeshId
                myHead.TextureID = targetHead.TextureID
            end)
        end
        for _, child in ipairs(targetHead:GetChildren()) do
            if child:IsA("SpecialMesh") or child:IsA("Decal") or child:IsA("SurfaceAppearance") or child:IsA("Texture") then
                child:Clone().Parent = myHead
            end
        end
        if not myHead:FindFirstChildOfClass("Decal") then
            local face = targetHead:FindFirstChild("face") or targetHead:FindFirstChildOfClass("Decal")
            if face then face:Clone().Parent = myHead end
        end
        if targetHead:IsA("MeshPart") and not meshOk then
            myHead.Transparency = 1
            local fakeHead = targetHead:Clone()
            fakeHead.Name = "FakeHead"
            fakeHead.CanCollide = false
            fakeHead.Massless = true
            fakeHead.Anchored = false
            fakeHead.Parent = char
            local weld = Instance.new("Weld")
            weld.Name = "FakeHeadWeld"
            weld.Part0 = myHead
            weld.Part1 = fakeHead
            weld.Parent = fakeHead
        else
            myHead.Transparency = 0
        end
    end

    for _, item in ipairs(dummyModel:GetChildren()) do
        if item:IsA("Accessory") or item:IsA("Hat") then
            local accClone = item:Clone()
            local handle = accClone:FindFirstChild("Handle")
            if handle then
                handle.CanCollide = false
                handle.Massless = true
                local added = pcall(function()
                    myHumanoid:AddAccessory(accClone)
                end)
                if not added or accClone.Parent ~= char then
                    accClone.Parent = char
                    local handleAttachment = handle:FindFirstChildOfClass("Attachment")
                    local targetAttachment
                    if handleAttachment then
                        for _, p in ipairs(char:GetDescendants()) do
                            if p:IsA("Attachment") and p.Name == handleAttachment.Name and p.Parent ~= handle then
                                targetAttachment = p
                                break
                            end
                        end
                    end
                    local weld = Instance.new("Weld")
                    weld.Name = "AccessoryWeld"
                    weld.Part0 = handle
                    weld.Part1 = targetAttachment and targetAttachment.Parent or myHead or char:FindFirstChild("HumanoidRootPart")
                    if handleAttachment and targetAttachment then
                        weld.C0 = handleAttachment.CFrame
                        weld.C1 = targetAttachment.CFrame
                    end
                    weld.Parent = handle
                end
            end
        end
    end

    local srcFace = dummyModel:FindFirstChild("FaceControls") or (targetHead and targetHead:FindFirstChildOfClass("FaceControls"))
    if srcFace then
        local oldFace = char:FindFirstChild("FaceControls") or (myHead and myHead:FindFirstChildOfClass("FaceControls"))
        if oldFace then oldFace:Destroy() end
        srcFace:Clone().Parent = char
    end

    local desc
    pcall(function()
        desc = Players:GetHumanoidDescriptionFromUserId(userId)
    end)
    if desc and myHead then
        if typeof(desc.Face) == "number" and desc.Face ~= 0 then
            local face = myHead:FindFirstChild("face") or Instance.new("Decal")
            face.Name = "face"
            face.Face = Enum.NormalId.Front
            face.Texture = "rbxassetid://" .. tostring(desc.Face)
            face.Parent = myHead
        end
        local function ensureClothing(className, id, prop)
            if typeof(id) ~= "number" or id == 0 then return end
            local item = char:FindFirstChildOfClass(className) or Instance.new(className)
            item[prop] = "rbxassetid://" .. tostring(id)
            item.Parent = char
        end
        ensureClothing("Shirt", desc.Shirt, "ShirtTemplate")
        ensureClothing("Pants", desc.Pants, "PantsTemplate")
        ensureClothing("ShirtGraphic", desc.GraphicTShirt, "Graphic")

        local InsertService = game:GetService("InsertService")
        local accFields = {
            "HatAccessory", "HairAccessory", "FaceAccessory", "NeckAccessory",
            "ShouldersAccessory", "FrontAccessory", "BackAccessory", "WaistAccessory",
        }
        local function hasAccessory(assetId)
            local needle = tostring(assetId)
            for _, acc in ipairs(char:GetChildren()) do
                if acc:IsA("Accessory") or acc:IsA("Hat") then
                    local mesh = acc:FindFirstChildWhichIsA("SpecialMesh", true)
                    local id = mesh and (mesh.MeshId or mesh.TextureId) or ""
                    if string.find(id, needle, 1, true) then
                        return true
                    end
                end
            end
            return false
        end
        for _, field in ipairs(accFields) do
            local raw = desc[field]
            if typeof(raw) == "string" and raw ~= "" then
                for piece in string.gmatch(raw, "[^,]+") do
                    local assetId = tonumber(piece)
                    if assetId and not hasAccessory(assetId) then
                        pcall(function()
                            local model = InsertService:LoadAsset(assetId)
                            local acc = model:FindFirstChildWhichIsA("Accessory", true) or model:FindFirstChildWhichIsA("Hat", true)
                            if acc then
                                acc.Parent = nil
                                local handle = acc:FindFirstChild("Handle")
                                if handle then handle.CanCollide = false end
                                local added = pcall(function()
                                    myHumanoid:AddAccessory(acc)
                                end)
                                if not added then
                                    acc.Parent = char
                                end
                            end
                            model:Destroy()
                        end)
                    end
                end
            end
        end
    end

    applyAnimationsFromDummy(char, dummyModel)
    holder:Destroy()
    copiedUserId = userId

    task.delay(0.8, function()
        if copiedUserId ~= userId then return end
        if lp.Character ~= char then return end
        pcall(function()
            local face = myHead and myHead:FindFirstChild("face")
            if desc and myHead and (not face or face.Texture == "") and desc.Face ~= 0 then
                face = face or Instance.new("Decal")
                face.Name = "face"
                face.Face = Enum.NormalId.Front
                face.Texture = "rbxassetid://" .. tostring(desc.Face)
                face.Parent = myHead
            end
        end)
    end)
end

local function wearUsername()
    if wearing then return end
    local typed = string.gsub(nameBox.Text, "^%s+", "")
    typed = string.gsub(typed, "%s+$", "")
    typed = string.gsub(typed, "^@", "")
    if typed == "" then
        cStatus.Text = "⋆ type a username or id ⋆"
        return
    end
    wearing = true
    cStatus.Text = "⋆ looking for " .. typed .. " ⋆"
    task.spawn(function()
        local ok = pcall(function()
            local userId = resolveUserId(typed)
            if not userId then error("no user") end
            cStatus.Text = "⋆ painting the outfit ⋆"
            local char = lp.Character or lp.CharacterAdded:Wait()
            applyFullOutfit(char, userId)
        end)
        wearing = false
        if ok then
            cStatus.Text = "♡ wearing " .. typed .. " ⋆"
        else
            cStatus.Text = "⋆ could not find that cutie ⋆"
        end
    end)
end

lp.CharacterAdded:Connect(function(newChar)
    local id = copiedUserId
    if not id then return end
    task.wait(0.5)
    pcall(function()
        applyFullOutfit(newChar, id)
    end)
end)

wearBtn.MouseButton1Click:Connect(wearUsername)
nameBox.FocusLost:Connect(function(enter)
    if enter then
        wearUsername()
    end
end)

local charCard = createCard(42)
local charLbl = Instance.new("TextLabel", charCard)
charLbl.Size = UDim2.new(0.62, 0, 1, 0)
charLbl.Position = UDim2.new(0, 12, 0, 0)
charLbl.BackgroundTransparency = 1
charLbl.Text = "♡ outfit copy"
charLbl.TextColor3 = Color3.fromRGB(255, 143, 55)
charLbl.Font = Enum.Font.FredokaOne
charLbl.TextSize = 14
charLbl.TextXAlignment = Enum.TextXAlignment.Left

local charOpen = Instance.new("TextButton", charCard)
charOpen.Size = UDim2.new(0, 84, 0, 26)
charOpen.Position = UDim2.new(1, -94, 0.5, -13)
charOpen.BackgroundColor3 = Color3.fromRGB(255, 230, 245)
charOpen.Text = "open ♡"
charOpen.TextColor3 = Color3.fromRGB(255, 145, 56)
charOpen.Font = Enum.Font.GothamMedium
charOpen.TextSize = 13
charOpen.AutoButtonColor = false
Instance.new("UICorner", charOpen).CornerRadius = UDim.new(0, 8)
Instance.new("UIStroke", charOpen).Color = Color3.fromRGB(255, 126, 55)

charOpen.MouseButton1Click:Connect(function()
    CharMenu.Visible = not CharMenu.Visible
    charOpen.Text = CharMenu.Visible and "close ♡" or "open ♡"
    if cfg.device == "mob" then
        CharMenu.Size = UDim2.fromOffset(280, 230)
        CharMenu.Position = UDim2.new(0.5, -140, 0.5, -115)
    else
        CharMenu.Size = UDim2.fromOffset(340, 230)
        CharMenu.Position = UDim2.new(0.5, 20, 0.5, -115)
    end
end)
cClose.MouseButton1Click:Connect(function()
    CharMenu.Visible = false
    charOpen.Text = "open ♡"
end)

-- Keybinds
UIS.InputBegan:Connect(function(i, gpe)
    if gpe then return end

    if cfg.useKeybind and i.KeyCode == cfg.silentAimKey then
        cfg.silentAim = not cfg.silentAim
    end

    if triggerUi and triggerUi.isListening() and i.UserInputType == Enum.UserInputType.Keyboard then
        triggerUi.setKey(i.KeyCode)
        return
    end

    if camlockUi and camlockUi.isListening() and i.UserInputType == Enum.UserInputType.Keyboard then
        camlockUi.setKey(i.KeyCode)
        return
    end

    if i.KeyCode == cfg.triggerBotKey then
        if triggerUi then
            triggerUi.set(not cfg.triggerBot)
        else
            cfg.triggerBot = not cfg.triggerBot
        end
    end

    if i.KeyCode == cfg.camlockKey then
        cfg.camlock = not cfg.camlock
        if not cfg.camlock then
            camlockPart = nil
        end
    end

    if i.KeyCode == cfg.uiToggleKey then
        ScreenGui.Enabled = not ScreenGui.Enabled
    end
end)

print("♡˚ the sweetest menu is ready ˚♡")

local dragTarget, dragStartPos, dragOrigin
local function pointInside(frame, p)
    if not frame or not frame.Visible then return false end
    local pos, size = frame.AbsolutePosition, frame.AbsoluteSize
    return p.X >= pos.X and p.X <= pos.X + size.X and p.Y >= pos.Y and p.Y <= pos.Y + size.Y
end
local function onScrollBar(scroll, p)
    if not scroll or not scroll.Visible then return false end
    local parent = scroll.Parent
    if parent and not parent.Visible then return false end
    local pos, size = scroll.AbsolutePosition, scroll.AbsoluteSize
    return p.X >= pos.X + size.X - 16 and p.X <= pos.X + size.X + 4 and p.Y >= pos.Y and p.Y <= pos.Y + size.Y
end

UIS.InputBegan:Connect(function(input)
    if sliderLock then return end
    if input.UserInputType ~= Enum.UserInputType.MouseButton1 and input.UserInputType ~= Enum.UserInputType.Touch then return end
    local p = input.Position
    if onScrollBar(Scroll, p) or onScrollBar(wScroll, p) then
        dragTarget = nil
        return
    end
    local target
    if pointInside(MiniBubble, p) then target = MiniBubble end
    if pointInside(Main, p) then target = Main end
    if pointInside(White, p) then target = White end
    if pointInside(CharMenu, p) then target = CharMenu end
    if pointInside(Device, p) then target = Device end
    if not target then return end
    dragTarget = target
    dragStartPos = p
    dragOrigin = target.Position
    input.Changed:Connect(function()
        if input.UserInputState == Enum.UserInputState.End and dragTarget == target then
            dragTarget = nil
        end
    end)
end)

UIS.InputChanged:Connect(function(input)
    if sliderLock or not dragTarget then return end
    if input.UserInputType ~= Enum.UserInputType.MouseMovement and input.UserInputType ~= Enum.UserInputType.Touch then return end
    local delta = input.Position - dragStartPos
    local size = dragTarget.AbsoluteSize
    local newX = math.clamp(dragOrigin.X.Offset + delta.X, 0, math.max(0, cam.ViewportSize.X - size.X))
    local newY = math.clamp(dragOrigin.Y.Offset + delta.Y, 0, math.max(0, cam.ViewportSize.Y - size.Y))
    dragTarget.Position = UDim2.fromOffset(newX, newY)
end)

task.defer(function()
    pcall(function()
        ScreenGui.Enabled = true
        if cfg.device == nil then
            Device.Visible = true
            Main.Visible = false
        end
    end)
end)
