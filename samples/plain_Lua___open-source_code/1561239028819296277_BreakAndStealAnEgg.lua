-- 動態載入 ValueHatGui UI 模組
local success, UIModule = pcall(function()
    return loadstring(game:HttpGet("https://raw.githubusercontent.com/ValueHat-Script/Valuehat-script/refs/heads/main/ValueHatGui4.lua"))()
end)

if not success or not UIModule then
    warn("[Error] UI 模組載入失敗，請檢查網路或鏈接：", UIModule)
    return
end

-- 服務
local Players = game:GetService("Players")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local LocalPlayer = Players.LocalPlayer

-- 遠端事件 (Remote Events)
local petsRemote = ReplicatedStorage:FindFirstChild("PetsInventoryRemote")
local upgradeTreadmillRemote = ReplicatedStorage:FindFirstChild("UpgradeTreadmillRequest")

-- 變數
local selectedZone = "Zone1"
local autoEggEnabled = false
local equipBestEnabled = false
local upgradeTreadmillEnabled = false
local currentRound = 0

-- 即時傳送
local function teleportTo(cframe)
    local character = LocalPlayer.Character
    local root = character and character:FindFirstChild("HumanoidRootPart")
    if root then
        root.CFrame = cframe
    end
end

-- 自動裝備最佳寵物
local function equipBestPets()
    if equipBestEnabled and petsRemote then
        pcall(function()
            petsRemote:FireServer("EquipBest", nil)
        end)
    end
end

-- 自動升級 Treadmill
local function startUpgradeTreadmill()
    task.spawn(function()
        while upgradeTreadmillEnabled do
            if upgradeTreadmillRemote then
                pcall(function()
                    upgradeTreadmillRemote:FireServer()
                end)
            end
            task.wait(1)
        end
    end)
end

-- 自動裝備名稱為 Pickaxe 的 Tool
local function equipPickaxe()
    local character = LocalPlayer.Character
    if not character then return end

    local currentTool = character:FindFirstChildOfClass("Tool")
    if currentTool and currentTool.Name == "Pickaxe" then
        return
    end

    local backpack = LocalPlayer:FindFirstChildOfClass("Backpack")
    if backpack then
        local pickaxe = backpack:FindFirstChild("Pickaxe")
        local humanoid = character:FindFirstChildOfClass("Humanoid")
        if pickaxe and humanoid then
            humanoid:EquipTool(pickaxe)
        end
    end
end

-- 正確路徑：workspace.Build
local function getBuild()
    return workspace:FindFirstChild("Build")
end

-- 掃描 Zone
local zoneList = {}
local build = getBuild()
local zoneBuilds = build and build:FindFirstChild("ZoneBuilds")

if zoneBuilds then
    for _, child in ipairs(zoneBuilds:GetChildren()) do
        if child.Name:match("^Zone%d+$") then
            table.insert(zoneList, child.Name)
        end
    end
    table.sort(zoneList, function(a, b)
        return (tonumber(a:match("%d+")) or 0) < (tonumber(b:match("%d+")) or 0)
    end)
end

if #zoneList == 0 then
    for i = 1, 10 do
        table.insert(zoneList, "Zone" .. i)
    end
end

selectedZone = zoneList[1]

-- 返回點：Build.Parts[4]
local function getReturnCFrame()
    local build = getBuild()
    if not build then return nil end

    local parts = build:FindFirstChild("Parts")
    if not parts then return nil end

    local target = parts:GetChildren()[4]
    if not target then return nil end

    if target:IsA("BasePart") then
        return target.CFrame
    elseif target:IsA("Model") then
        return target:GetPivot()
    end
    return nil
end

-- 取得物件 CFrame
local function getCFrame(obj)
    if not obj then return nil end
    if obj:IsA("BasePart") then
        return obj.CFrame
    elseif obj:IsA("Model") then
        if obj.PrimaryPart then
            return obj.PrimaryPart.CFrame
        end
        local best, size = nil, 0
        for _, d in ipairs(obj:GetDescendants()) do
            if d:IsA("BasePart") and d.Size.Magnitude > size then
                best, size = d, d.Size.Magnitude
            end
        end
        if best then return best.CFrame end
        return obj:GetPivot()
    end
    return nil
end

-- 在選定 Zone 的 Eggs 資料夾找 Model
local function getZoneEggs(zoneName)
    local list = {}
    local build = getBuild()
    if not build then return list end

    local zoneBuilds = build:FindFirstChild("ZoneBuilds")
    if not zoneBuilds then return list end

    local zone = zoneBuilds:FindFirstChild(zoneName)
    if not zone then return list end

    local eggsFolder = zone:FindFirstChild("Eggs")
    if not eggsFolder then return list end

    for _, child in ipairs(eggsFolder:GetChildren()) do
        table.insert(list, child)
    end
    return list
end

-- 無時間限制持續監控 Prompt（範圍設定為 5）
local function waitForPrompt(target, roundId)
    while currentRound == roundId do
        local prompt = target:FindFirstChildWhichIsA("ProximityPrompt", true)

        -- 備案：搜尋角色腳下周圍 5 單位內的 Prompt
        if not prompt and LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("HumanoidRootPart") then
            local rootPos = LocalPlayer.Character.HumanoidRootPart.Position
            for _, p in ipairs(workspace:GetDescendants()) do
                if p:IsA("ProximityPrompt") and p.Parent and p.Parent:IsA("BasePart") then
                    if (p.Parent.Position - rootPos).Magnitude < 5 then
                        prompt = p
                        break
                    end
                end
            end
        end

        if prompt and prompt.Enabled then
            return prompt
        end

        task.wait(0.1)
    end
    return nil
end

-- UI 介面設定
local Hub = UIModule.CreateWindow("Break And steal an egg", "TikTok: ValueHat")

Hub:CreateDropdown("Select Zone", zoneList, selectedZone, function(v)
    selectedZone = v
    currentRound = currentRound + 1

    local ret = getReturnCFrame()
    if ret then
        teleportTo(ret * CFrame.new(0, 3, 0))
    end
end)

Hub:CreateButton("TP Back", function()
    currentRound = currentRound + 1

    local ret = getReturnCFrame()
    if ret then
        teleportTo(ret * CFrame.new(0, 3, 0))
    else
        warn("[TP Back] 找不到返回點 (Build.Parts[4])")
    end
end)

-- Auto Egg 邏輯
local function startAutoEgg()
    task.spawn(function()
        while autoEggEnabled do
            currentRound = currentRound + 1
            local myRound = currentRound

            equipBestPets()
            equipPickaxe()

            local eggs = getZoneEggs(selectedZone)

            if #eggs > 0 then
                local egg = eggs[math.random(1, #eggs)]
                local cf = getCFrame(egg)

                if cf then
                    teleportTo(cf * CFrame.new(0, 1.5, 0))
                    equipPickaxe()

                    local prompt = waitForPrompt(egg, myRound)

                    if prompt and currentRound == myRound then
                        fireproximityprompt(prompt)
                        task.wait(0.3)

                        local ret = getReturnCFrame()
                        if ret and currentRound == myRound then
                            teleportTo(ret * CFrame.new(0, 3, 0))
                        end
                    end
                end
            else
                warn("[Auto Egg] " .. selectedZone .. " 的 Eggs 是空的")
                task.wait(2)
            end

            task.wait(0.5)
        end
    end)
end

Hub:CreateToggle("Auto Egg", false, function(on)
    autoEggEnabled = on
    if on then startAutoEgg() end
end)

-- 放最下面的選項：Equip Best & Upgrade Treadmill
Hub:CreateToggle("Equip Best", false, function(on)
    equipBestEnabled = on
    if on then
        equipBestPets()
    end
end)

Hub:CreateToggle("Upgrade Treadmill", false, function(on)
    upgradeTreadmillEnabled = on
    if on then
        startUpgradeTreadmill()
    end
end)
