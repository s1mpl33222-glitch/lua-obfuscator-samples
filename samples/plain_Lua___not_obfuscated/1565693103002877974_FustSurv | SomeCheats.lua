local Rayfield = loadstring(game:HttpGet("https://github.com/UnknownDeveloper-sqd/UnknownSquad-RayField-Lib/raw/refs/heads/main/Rayfield/CustomRayfield.luau"))()

local Window = Rayfield:CreateWindow({
    Name = "FustSurv | SomeCheats",
    LoadingTitle = "FustSurv | SomeCheats",
    LoadingSubtitle = "By: UnknownSquad",
    Theme = "Amethyst",
    Width = 460,
    Height = 360,
    Font = "Code",
    ConfigurationSaving = { Enabled = false },
    KeySystem = false
})

local PvpTab = Window:CreateTab("PVP")
local PveTab = Window:CreateTab("PVE")
local VisualsTab = Window:CreateTab("Visuals")

local lp = game.Players.LocalPlayer
local plrs = game:GetService("Players")
local uis = game:GetService("UserInputService")
local cs = game:GetService("CollectionService")
local rs = game:GetService("RunService")
local ws = game:GetService("Workspace")

local cam = ws.CurrentCamera
ws:GetPropertyChangedSignal("CurrentCamera"):Connect(function()
    cam = ws.CurrentCamera
end)

local autoCross = false
local silentAim = false
local playerEsp = false

local newc = newcclosure or function(f) return f end
local check = checkcaller or function() return false end

PvpTab:CreateToggle({
    Name = "SilentAim",
    CurrentValue = false,
    Callback = function(v) silentAim = v end
})

PveTab:CreateToggle({
    Name = "AutoCross",
    CurrentValue = false,
    Callback = function(v) autoCross = v end
})

VisualsTab:CreateToggle({
    Name = "PlayerESP",
    CurrentValue = false,
    Callback = function(v) playerEsp = v end
})

local function getCharRoot()
    local c = lp.Character
    return c, c and c:FindFirstChild("HumanoidRootPart")
end

local function getCrosshair()
    local vp = cam and cam.ViewportSize or Vector2.new(800, 600)
    if uis.TouchEnabled or not uis.MouseEnabled or uis.MouseBehavior == Enum.MouseBehavior.LockCenter then
        return Vector2.new(vp.X * 0.5, vp.Y * 0.5)
    end
    return uis:GetMouseLocation()
end

local function getAllTargets()
    local list = {}
    local seen = {}
    local function addTarget(m)
        if not m or m == lp.Character or seen[m] or not m:IsA("Model") then return end
        seen[m] = true
        local hum = m:FindFirstChild("Humanoid")
        local head = m:FindFirstChild("Head") or m:FindFirstChild("HumanoidRootPart") or m.PrimaryPart or m:FindFirstChildWhichIsA("BasePart")
        if hum and hum.Health > 0 and head then
            table.insert(list, {model = m, head = head})
        end
    end
    for _, p in ipairs(plrs:GetPlayers()) do
        if p ~= lp and p.Character then addTarget(p.Character) end
    end
    local npcs = ws:FindFirstChild("Npcs")
    if npcs then for _, m in ipairs(npcs:GetChildren()) do addTarget(m) end end
    local animals = ws:FindFirstChild("Animals")
    if animals then for _, m in ipairs(animals:GetChildren()) do addTarget(m) end end
    for _, m in ipairs(cs:GetTagged("FustNpc")) do addTarget(m) end
    for _, m in ipairs(cs:GetTagged("FustAnimal")) do addTarget(m) end
    for _, m in ipairs(cs:GetTagged("FustDino")) do addTarget(m) end
    return list
end

local function getBestWeakSpot(hitPart)
    local _, root = getCharRoot()
    if not root then return nil, nil end
    local rPos = root.Position
    if hitPart and hitPart:IsA("BasePart") then
        local node = hitPart.Parent
        while node and node ~= ws do
            if cs:HasTag(node, "FustNode") or node:GetAttribute("NodeType") ~= nil then
                local wsSpot = node:GetAttribute("WeakSpot")
                if typeof(wsSpot) == "Vector3" then
                    return hitPart, wsSpot
                end
                break
            end
            node = node.Parent
        end
    end
    local bestPart = nil
    local bestSpot = nil
    local minDistSq = 196
    local nodes = cs:GetTagged("FustNode")
    for i = 1, #nodes do
        local node = nodes[i]
        if node:IsDescendantOf(ws) and node:GetAttribute("Depleted") ~= true then
            local wsSpot = node:GetAttribute("WeakSpot")
            if typeof(wsSpot) == "Vector3" then
                local ox = rPos.X - wsSpot.X
                local oy = rPos.Y - wsSpot.Y
                local oz = rPos.Z - wsSpot.Z
                local dSq = ox * ox + oy * oy + oz * oz
                if dSq < minDistSq then
                    minDistSq = dSq
                    bestPart = node:FindFirstChild("Rock") or node:FindFirstChild("Trunk") or node:FindFirstChildWhichIsA("BasePart") or node.PrimaryPart
                    bestSpot = wsSpot
                end
            end
        end
    end
    return bestPart, bestSpot
end

local function getGunTarget()
    if not cam then return nil end
    local best = nil
    local vp = cam.ViewportSize
    local minDist = math.min(vp.X, vp.Y) * 0.45
    local curPos = getCrosshair()
    local targets = getAllTargets()
    for i = 1, #targets do
        local head = targets[i].head
        local sPos = cam:WorldToViewportPoint(head.Position)
        if sPos.Z > 0 then
            local dx = sPos.X - curPos.X
            local dy = sPos.Y - curPos.Y
            local d = math.sqrt(dx * dx + dy * dy)
            if d < minDist then
                minDist = d
                best = head
            end
        end
    end
    return best
end

local function getWeaponStats()
    local char = lp.Character
    local tool = char and char:FindFirstChildWhichIsA("Tool")
    local name = tool and tool.Name:lower() or ""
    if name:find("bow") or name:find("crossbow") then
        return 260, 150
    elseif name:find("revolver") or name:find("pistol") or name:find("smg") then
        return 450, 110
    elseif name:find("sniper") or name:find("bolt") then
        return 800, 70
    elseif name:find("rifle") or name:find("sar") or name:find("ak") then
        return 650, 90
    end
    return 550, 100
end

local targetVelocities = {}
local lastTargetPositions = {}
local lastVelTime = os.clock()

rs.Heartbeat:Connect(function()
    local now = os.clock()
    local dt = now - lastVelTime
    if dt >= 0.05 then
        lastVelTime = now
        local targets = getAllTargets()
        for i = 1, #targets do
            local h = targets[i].head
            local last = lastTargetPositions[h]
            if last then
                targetVelocities[h] = (h.Position - last) / dt
            end
            lastTargetPositions[h] = h.Position
        end
    end
end)

local guiParent = (gethui and gethui())
if not guiParent then
    local s, res = pcall(function() return game:GetService("CoreGui") end)
    guiParent = (s and res) or lp:WaitForChild("PlayerGui")
end

local espFolder = Instance.new("Folder")
espFolder.Name = "ESPFolder"
espFolder.Parent = guiParent
local espCache = {}

local function removeEsp(p)
    local hl = espCache[p]
    if hl then
        hl:Destroy()
        espCache[p] = nil
    end
end
plrs.PlayerRemoving:Connect(removeEsp)

local function updatePlayerEsp()
    if not playerEsp then
        for p in pairs(espCache) do
            removeEsp(p)
        end
        return
    end
    local all = plrs:GetPlayers()
    for i = 1, #all do
        local p = all[i]
        if p ~= lp then
            local char = p.Character
            local hum = char and char:FindFirstChild("Humanoid")
            if hum and hum.Health > 0 then
                local hl = espCache[p]
                if not hl or hl.Parent ~= espFolder then
                    hl = Instance.new("Highlight")
                    hl.Adornee = char
                    hl.FillColor = Color3.fromRGB(255, 60, 60)
                    hl.FillTransparency = 0.5
                    hl.OutlineColor = Color3.fromRGB(255, 255, 255)
                    hl.OutlineTransparency = 0
                    hl.DepthMode = Enum.HighlightDepthMode.AlwaysOnTop
                    hl.Parent = espFolder
                    espCache[p] = hl
                elseif hl.Adornee ~= char then
                    hl.Adornee = char
                end
            else
                removeEsp(p)
            end
        end
    end
end

task.spawn(function()
    while true do
        task.wait(0.2)
        updatePlayerEsp()
    end
end)

if uis.TouchEnabled then
    local toggleGui = Instance.new("ScreenGui")
    toggleGui.Name = "MobileToggleGui"
    toggleGui.ResetOnSpawn = false
    toggleGui.Parent = guiParent

    local toggleBtn = Instance.new("TextButton")
    toggleBtn.Name = "ToggleUI"
    toggleBtn.Size = UDim2.fromOffset(45, 45)
    toggleBtn.Position = UDim2.new(0.02, 0, 0.25, 0)
    toggleBtn.BackgroundColor3 = Color3.fromRGB(80, 40, 120)
    toggleBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
    toggleBtn.Text = "UI"
    toggleBtn.TextSize = 16
    toggleBtn.Font = Enum.Font.Code
    toggleBtn.Parent = toggleGui

    local corner = Instance.new("UICorner")
    corner.CornerRadius = UDim.new(0, 10)
    corner.Parent = toggleBtn

    local stroke = Instance.new("UIStroke")
    stroke.Color = Color3.fromRGB(150, 90, 220)
    stroke.Thickness = 1.5
    stroke.Parent = toggleBtn

    toggleBtn.Activated:Connect(function()
        for _, g in ipairs(guiParent:GetChildren()) do
            if g:IsA("ScreenGui") and g ~= toggleGui and g.Name ~= "ESPFolder" then
                g.Enabled = not g.Enabled
            end
        end
    end)
end

local oldNamecall

local function namecallHook(self, ...)
    if check() then return oldNamecall(self, ...) end
    local rawMethod = getnamecallmethod and getnamecallmethod()
    local method = rawMethod and rawMethod:lower() or ""
    if method == "fireserver" then
        if self.Name == "Swing" and autoCross then
            local args = {...}
            local payload = typeof(args[1]) == "table" and args[1] or {}
            local nodePart, weakSpot = getBestWeakSpot(payload.target)
            if weakSpot then
                payload.target = payload.target or nodePart
                payload.pos = weakSpot
                if setnamecallmethod and rawMethod then
                    setnamecallmethod(rawMethod)
                end
                return oldNamecall(self, payload)
            end
        elseif self.Name == "Shoot" and silentAim then
            local target = getGunTarget()
            if target then
                local args = {...}
                local payload = typeof(args[1]) == "table" and args[1] or {}
                local origin = typeof(payload.origin) == "Vector3" and payload.origin or (cam and cam.CFrame.Position)
                if origin then
                    local speed, grav = getWeaponStats()
                    local vel = target.AssemblyLinearVelocity
                    if not vel or vel.Magnitude < 0.5 then
                        vel = targetVelocities[target] or Vector3.zero
                    end
                    local aimPos = target.Position
                    local dist = (aimPos - origin).Magnitude
                    local t = dist / speed
                    aimPos = aimPos + vel * t + Vector3.new(0, 0.5 * grav * t * t, 0)
                    dist = (aimPos - origin).Magnitude
                    t = dist / speed
                    aimPos = target.Position + vel * t + Vector3.new(0, 0.5 * grav * t * t, 0)
                    payload.dir = (aimPos - origin).Unit
                    if setnamecallmethod and rawMethod then
                        setnamecallmethod(rawMethod)
                    end
                    return oldNamecall(self, payload)
                end
            end
        end
    end
    if setnamecallmethod and rawMethod then
        setnamecallmethod(rawMethod)
    end
    return oldNamecall(self, ...)
end

if hookmetamethod then
    oldNamecall = hookmetamethod(game, "__namecall", newc(namecallHook))
else
    local mt = getrawmetatable(game)
    oldNamecall = mt.__namecall
    setreadonly(mt, false)
    mt.__namecall = newc(namecallHook)
    setreadonly(mt, true)
end
