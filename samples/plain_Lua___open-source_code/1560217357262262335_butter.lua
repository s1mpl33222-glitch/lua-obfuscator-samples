-- ===================== LOAD RAYFIELD =====================
local Rayfield = loadstring(game:HttpGet('https://sirius.menu/rayfield'))()

-- ===================== SERVICES =====================
local Players = game:GetService("Players")
local ReplicatedStorage = game:GetService("ReplicatedStorage")

local player = Players.LocalPlayer
local Events = ReplicatedStorage:WaitForChild("Events")

-- ===================== WINDOW =====================
local Window = Rayfield:CreateWindow({
    Name = "Auto Farm | Keycap Script",
    LoadingTitle = "Auto Farm",
    LoadingSubtitle = "Optimized",
    ConfigurationSaving = {Enabled = false},
})

local Tab = Window:CreateTab("Main", 4483362458)

-- ===================== VARIABLES =====================
local autoFarm = false

local autoWalk = false
local autoRoller = false
local autoTank = false
local autoWorkerSpeed = false
local autoWorker = false

local cachedKeycaps = {}
local lastScan = 0

-- ===================== FUNCTIONS =====================

local function getPlot()
    return workspace.Map.Plots:FindFirstChild("Plot_" .. player.UserId)
end

-- 🔥 SCAN ALL ZONES
local function scanKeycaps()
    local plot = getPlot()
    if not plot then return {} end

    local items = plot:FindFirstChild("Items")
    if not items then return {} end

    local list = {}

    for _, zone in pairs(items:GetChildren()) do
        local objects = zone:FindFirstChild("Objects")
        if objects then
            for _, obj in pairs(objects:GetChildren()) do
                local butter = obj:FindFirstChild("Butter")
                if butter then
                    local hitbox = butter:FindFirstChild("Hitbox")
                    if hitbox then
                        table.insert(list, hitbox)
                    end
                end
            end
        end
    end

    return list
end

-- 🔀 SHUFFLE (FIX REPETITION)
local function shuffleKeycaps(keycaps)
    for i = #keycaps, 2, -1 do
        local j = math.random(1, i)
        keycaps[i], keycaps[j] = keycaps[j], keycaps[i]
    end
    return keycaps
end

-- 📏 SORT (CLOSE ONES FIRST)
local function sortKeycaps(keycaps, hrp)
    table.sort(keycaps, function(a, b)
        return (hrp.Position - a.Position).Magnitude < (hrp.Position - b.Position).Magnitude
    end)
    return keycaps
end

-- 🧠 HYBRID (BEST)
local function getSmartKeycaps(hrp)
    local keycaps = {unpack(cachedKeycaps)}

    if math.random() < 0.5 then
        return sortKeycaps(keycaps, hrp)
    else
        return shuffleKeycaps(keycaps)
    end
end

-- 💧 BUTTER VALUE
local function getButter()
    local textLabel = player.PlayerGui.GameUI.HUD.Bottom.PaintBar.Paint
    return tonumber(textLabel.Text:match("(%d+)/")) or 0
end

-- 🔁 REFILL
local function refill(hrp)
    local plot = getPlot()
    if not plot then return end

    local refillPart = plot:FindFirstChild("Paint")
        and plot.Paint:FindFirstChild("Touch")

    if hrp and refillPart then
        hrp.CFrame = refillPart.CFrame + Vector3.new(0,3,0)
        task.wait(1.2)
    end
end

-- ===================== AUTO FARM =====================
task.spawn(function()
    while true do
        if autoFarm then
            local char = player.Character
            local hrp = char and char:FindFirstChild("HumanoidRootPart")

            if hrp then
                -- 🔥 FAST RESCAN
                if tick() - lastScan > 12 then
                    cachedKeycaps = scanKeycaps()
                    lastScan = tick()
                end

                local keycaps = getSmartKeycaps(hrp)

                for _, hitbox in pairs(keycaps) do
                    if not autoFarm then break end
                    if not hitbox or not hitbox.Parent then continue end

                    -- 💧 instant refill
                    if getButter() <= 0 then
                        refill(hrp)
                        break
                    end

                    -- move
                    hrp.CFrame = hitbox.CFrame + Vector3.new(0,2,0)
                    task.wait(0.18)
                end
            end
        end

        task.wait(0.1)
    end
end)

-- ===================== AUTO UPGRADES =====================
task.spawn(function()
    while true do
        pcall(function()
            if autoWalk then
                Events.RequestBuyUpgrade:InvokeServer("WalkSpeed")
            end

            if autoRoller then
                Events.RequestBuyUpgrade:InvokeServer("RollerSize")
            end

            if autoTank then
                Events.RequestBuyUpgrade:InvokeServer("PaintTank")
            end

            if autoWorkerSpeed then
                Events.RequestBuyUpgrade:InvokeServer("WorkerSpeed")
            end

            if autoWorker then
                Events.RequestBuyWorker:InvokeServer()
            end
        end)

        task.wait(5)
    end
end)

-- ===================== UI =====================

Tab:CreateToggle({
    Name = "Auto Farm",
    CurrentValue = false,
    Callback = function(v)
        autoFarm = v
    end,
})

Tab:CreateLabel("===== AUTO UPGRADES =====")

Tab:CreateToggle({
    Name = "Auto WalkSpeed",
    CurrentValue = false,
    Callback = function(v)
        autoWalk = v
    end,
})

Tab:CreateToggle({
    Name = "Auto RollerSize",
    CurrentValue = false,
    Callback = function(v)
        autoRoller = v
    end,
})

Tab:CreateToggle({
    Name = "Auto PaintTank",
    CurrentValue = false,
    Callback = function(v)
        autoTank = v
    end,
})

Tab:CreateToggle({
    Name = "Auto WorkerSpeed",
    CurrentValue = false,
    Callback = function(v)
        autoWorkerSpeed = v
    end,
})

Tab:CreateToggle({
    Name = "Auto Buy Worker",
    CurrentValue = false,
    Callback = function(v)
        autoWorker = v
    end,
})
