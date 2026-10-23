-- SERVICES
local UserInputService = game:GetService("UserInputService")
local StarterGui = game:GetService("StarterGui")
local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local Workspace = game:GetService("Workspace")

local player = Players.LocalPlayer

-- CONFIG
local CONFIG = {
    reach = 10,
    magnetStrength = 0,
    showReachSphere = true,
    autoSecondTouch = true,
    scanCooldown = 1.5,
    ballNames = { "TPS", "ESA", "MRS", "PRS", "MPS", "SSS", "AIFA", "RBZ", "RSF", "MPS", "VEF", "SAML", "VEF"}

}

-- VARIÁVEIS
local balls = {}
local lastRefresh = 0
local reachSphere
local gui, reachLabel

-- BALL SET
local BALL_NAME_SET = {}
for _, n in ipairs(CONFIG.ballNames) do
    BALL_NAME_SET[n] = true
end

-- NOTIFY
local function notify(txt, t)
    pcall(function()
        StarterGui:SetCore("SendNotification", {
            Title = "JOTA HUB V10",
            Text = txt,
            Duration = t or 2
        })
    end)
end

-- REFRESH BALLS
local function refreshBalls(force)
    if not force and tick() - lastRefresh < CONFIG.scanCooldown then return end
    lastRefresh = tick()
    table.clear(balls)

    for _, v in ipairs(Workspace:GetDescendants()) do
        if v:IsA("BasePart") and BALL_NAME_SET[v.Name] then
            balls[#balls+1] = v
        end
    end
end

-- PARTES DO CORPO
local function getValidParts(char)
    local parts = {}
    for _, v in ipairs(char:GetChildren()) do
        if v:IsA("BasePart") and v.Name ~= "HumanoidRootPart" then
            parts[#parts+1] = v
        end
    end
    return parts
end

-- REACH SPHERE
local function updateReachSphere()
    if not CONFIG.showReachSphere then
        if reachSphere then reachSphere:Destroy() end
        reachSphere = nil
        return
    end

    if not reachSphere then
        reachSphere = Instance.new("Part")
        reachSphere.Name = "JOTAReachSphere"
        reachSphere.Shape = Enum.PartType.Ball
        reachSphere.Anchored = true
        reachSphere.CanCollide = false
        reachSphere.Transparency = 0.8
        reachSphere.Material = Enum.Material.ForceField
        reachSphere.Color = Color3.fromRGB(0,85,255)
        reachSphere.Parent = Workspace

        RunService.RenderStepped:Connect(function()
            local hrp = player.Character and player.Character:FindFirstChild("HumanoidRootPart")
            if hrp then
                reachSphere.Position = hrp.Position
            end
        end)
    end

    reachSphere.Size = Vector3.new(CONFIG.reach*2, CONFIG.reach*2, CONFIG.reach*2)
end

-- GUI COM + / -
local function buildGUI()
    if gui then return end

    gui = Instance.new("ScreenGui")
    gui.Name = "JOTAHUBGUI"
    gui.ResetOnSpawn = false
    gui.Parent = player:WaitForChild("PlayerGui")

    local frame = Instance.new("Frame")
    frame.Size = UDim2.fromScale(0.22, 0.16)
    frame.Position = UDim2.fromScale(0.02, 0.05)
    frame.BackgroundColor3 = Color3.fromRGB(0,0,0)
    frame.BackgroundTransparency = 0.35
    frame.BorderSizePixel = 0
    frame.Parent = gui

    Instance.new("UICorner", frame).CornerRadius = UDim.new(0.1,0)

    local title = Instance.new("TextLabel")
    title.Size = UDim2.new(1,0,0.2,0)
    title.BackgroundTransparency = 1
    title.Text = "JOTA HUB V10"
    title.TextScaled = true
    title.Font = Enum.Font.SourceSansBold
    title.TextColor3 = Color3.new(1,1,1)
    title.Parent = frame

    reachLabel = Instance.new("TextLabel")
    reachLabel.Size = UDim2.new(1,0,0.2,0)
    reachLabel.Position = UDim2.new(0,0,0.2,0)
    reachLabel.BackgroundTransparency = 1
    reachLabel.Text = "Reach: "..CONFIG.reach
    reachLabel.TextScaled = true
    reachLabel.Font = Enum.Font.SourceSans
    reachLabel.TextColor3 = Color3.new(1,1,1)
    reachLabel.Parent = frame

    local minus = Instance.new("TextButton")
    minus.Size = UDim2.new(0.4,0,0.3,0)
    minus.Position = UDim2.new(0.05,0,0.6,0)
    minus.Text = "-"
    minus.TextScaled = true
    minus.Font = Enum.Font.SourceSansBold
    minus.BackgroundColor3 = Color3.fromRGB(60,60,60)
    minus.TextColor3 = Color3.new(1,1,1)
    minus.Parent = frame

    local plus = Instance.new("TextButton")
    plus.Size = UDim2.new(0.4,0,0.3,0)
    plus.Position = UDim2.new(0.55,0,0.6,0)
    plus.Text = "+"
    plus.TextScaled = true
    plus.Font = Enum.Font.SourceSansBold
    plus.BackgroundColor3 = Color3.fromRGB(60,60,60)
    plus.TextColor3 = Color3.new(1,1,1)
    plus.Parent = frame

    minus.MouseButton1Click:Connect(function()
        CONFIG.reach = math.max(1, CONFIG.reach - 1)
        reachLabel.Text = "Reach: "..CONFIG.reach
        updateReachSphere()
        notify("Reach: "..CONFIG.reach,1)
    end)

    plus.MouseButton1Click:Connect(function()
        CONFIG.reach += 1
        reachLabel.Text = "Reach: "..CONFIG.reach
        updateReachSphere()
        notify("Reach: "..CONFIG.reach,1)
    end)
end

-- AUTO TOUCH
local function processTouch()
    local char = player.Character
    if not char then return end

    for _, part in ipairs(getValidParts(char)) do
        for _, ball in ipairs(balls) do
            if ball and ball.Parent then
                if (ball.Position - part.Position).Magnitude <= CONFIG.reach then
                    pcall(function()
                        firetouchinterest(ball, part, 0)
                        firetouchinterest(ball, part, 1)
                    end)
                end
            end
        end
    end
end

-- LOOPS
RunService.RenderStepped:Connect(function()
    if CONFIG.autoSecondTouch then
        processTouch()
    end
end)

task.spawn(function()
    while true do
        refreshBalls(false)
        task.wait(CONFIG.scanCooldown)
    end
end)

-- INIT
buildGUI()
updateReachSphere()
refreshBalls(true)
notify("✅ JOTA HUB V10 ONLINE",3)
print("JOTA HUB V10 OK")