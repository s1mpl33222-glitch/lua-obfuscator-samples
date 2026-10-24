-- nguồn Tora Hub Zombie Arena
local Players = game:GetService("Players")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local CoreGui = game:GetService("CoreGui")
local VirtualInputManager = game:GetService("VirtualInputManager")
local LocalPlayer = Players.LocalPlayer

local existingScript = CoreGui:FindFirstChild("ToraScript")
if existingScript then
    existingScript:Destroy()
end

local library = loadstring(game:HttpGet("https://raw.githubusercontent.com/liebertsx/Tora-Library/main/src/librarynew", true))()
local mainWindow = library:CreateWindow("Survive Zombie Arena")

local function runKillAura()
    task.spawn(function()
        _G.Kill = true
        while _G.Kill do
            task.wait()
            pcall(function()
                local character = LocalPlayer.Character
                if character then
                    local backpack = LocalPlayer.Backpack
                    local equippedTool = character:FindFirstChildOfClass("Tool")
                    
                    if not equippedTool then
                        local tools = backpack:GetChildren()
                        for _, tool in pairs(tools) do
                            if tool:IsA("Tool") then
                                tool.Parent = character
                                break
                            end
                        end
                    end
                    
                    local currentTool = character:FindFirstChildOfClass("Tool")
                    if currentTool then
                        local zombies = workspace:FindFirstChild("Zombies_Local")
                        if zombies then
                            local gunHitRemote = ReplicatedStorage:FindFirstChild("GunRemotes") and ReplicatedStorage.GunRemotes:FindFirstChild("GunHit")
                            if gunHitRemote then
                                for _, zombie in pairs(zombies:GetChildren()) do
                                    local root = zombie:FindFirstChild("HumanoidRootPart")
                                    if root then
                                        local id = tonumber(string.match(zombie.Name, "%d+"))
                                        gunHitRemote:FireServer(currentTool.Name, id, root.Position)
                                    end
                                end
                            end
                        end
                    end
                else
                    LocalPlayer.CharacterAdded:Wait()
                end
            end)
        end
    end)
end

mainWindow:AddToggle({
    ["text"] = "Hào quang sát thương",
    ["flag"] = "toggle",
    ["state"] = false,
    ["callback"] = function(state)
        _G.Kill = state
        if state then
            runKillAura()
        end
    end
})

mainWindow:AddToggle({
    ["text"] = "SafeZone",
    ["flag"] = "toggle",
    ["state"] = false,
    ["callback"] = function(state)
        _G.Safe = state
        local character = LocalPlayer.Character
        if character and character:FindFirstChild("Humanoid") then
            character.Humanoid.HipHeight = state and 20 or 2
        end
    end
})

local cachedCFrame = nil
mainWindow:AddToggle({
    ["text"] = "Instant ClearWave (Solo)",
    ["flag"] = "toggle",
    ["state"] = false,
    ["callback"] = function(state)
        _G.Wave = state
        local character = LocalPlayer.Character
        local root = character and character:WaitForChild("HumanoidRootPart")
        if root then
            if state then
                cachedCFrame = root.CFrame
                root.CFrame = CFrame.new(31, -67, -145)
                task.wait(0.2)
                root.Anchored = true
            else
                root.Anchored = false
                if cachedCFrame then
                    root.CFrame = cachedCFrame
                end
            end
        end
    end
})

mainWindow:AddSlider({
    ["text"] = "Tốc độ đi bộ",
    ["flag"] = "slider1",
    ["value"] = 16,
    ["min"] = 16,
    ["max"] = 100,
    ["callback"] = function(value)
        local character = LocalPlayer.Character
        if character and character:FindFirstChild("Humanoid") then
            character.Humanoid.WalkSpeed = value
        end
    end
})

-- Đã thay đổi hiển thị theo yêu cầu của bạn
mainWindow:AddLabel({["text"] = "by: zen hub"})

local purchaseWindow = library:CreateWindow("Purchase")

purchaseWindow:AddToggle({
    ["text"] = "Nâng cấp khả năng hồi phục",
    ["flag"] = "toggle",
    ["state"] = false,
    ["callback"] = function(state)
        _G.Heal = state
        if state then
            task.spawn(function()
                while _G.Heal do
                    task.wait(1)
                    pcall(function()
                        ReplicatedStorage.UpgradeRemotes.PurchaseHealthUpgrade:FireServer()
                    end)
                end
            end)
        end
    end
})

purchaseWindow:AddToggle({
    ["text"] = "Nâng cấp vũ khí",
    ["flag"] = "toggle",
    ["state"] = false,
    ["callback"] = function(state)
        _G.Weapon = state
        if state then
            task.spawn(function()
                while _G.Weapon do
                    task.wait(1)
                    pcall(function()
                        ReplicatedStorage.UpgradeRemotes.PurchaseWeaponUpgrade:FireServer()
                    end)
                end
            end)
        end
    end
})

purchaseWindow:AddToggle({
    ["text"] = "Kỹ năng điện tử",
    ["flag"] = "toggle",
    ["state"] = false,
    ["callback"] = function(state)
        _G.SkillE = state
        if state then
            task.spawn(function()
                while _G.SkillE do
                    task.wait(1)
                    VirtualInputManager:SendKeyEvent(true, Enum.KeyCode.E, false, game)
                    VirtualInputManager:SendKeyEvent(false, Enum.KeyCode.E, false, game)
                end
            end)
        end
    end
})

purchaseWindow:AddToggle({
    ["text"] = "Kỹ năng R",
    ["flag"] = "toggle",
    ["state"] = false,
    ["callback"] = function(state)
        _G.SkillR = state
        if state then
            task.spawn(function()
                while _G.SkillR do
                    task.wait(1)
                    VirtualInputManager:SendKeyEvent(true, Enum.KeyCode.R, false, game)
                    VirtualInputManager:SendKeyEvent(false, Enum.KeyCode.R, false, game)
                end
            end)
        end
    end
})

purchaseWindow:AddToggle({
    ["text"] = "Kỹ năng Q",
    ["flag"] = "toggle",
    ["state"] = false,
    ["callback"] = function(state)
        _G.SkillQ = state
        if state then
            task.spawn(function()
                while _G.SkillQ do
                    task.wait(1)
                    VirtualInputManager:SendKeyEvent(true, Enum.KeyCode.Q, false, game)
                    VirtualInputManager:SendKeyEvent(false, Enum.KeyCode.Q, false, game)
                end
            end)
        end
    end
})

library:Init()
