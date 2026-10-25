local ReplicatedStorage = cloneref(game:GetService("ReplicatedStorage"))
local Players = cloneref(game:GetService("Players"))
local RunService = cloneref(game:GetService("RunService"))
local Workspace = cloneref(game:GetService("Workspace"))

local lplr = Players.LocalPlayer
local util = require(ReplicatedStorage.Modules.Utility)
local enum = require(ReplicatedStorage.Modules.EnumLibrary)
local FighterController = require(lplr.PlayerScripts.Controllers.FighterController)

-- Rayfield
local Rayfield = loadstring(game:HttpGet('https://sirius.menu/rayfield'))()

getgenv().Config = {
    Enabled = true,
    FireRate = 0.05,
    WeaponSlot = "Primary",
    MaxDistance = 500
}

local slots = { Primary = 1, Secondary = 2, Melee = 3 }
local function getSlotNumber()
    return slots[getgenv().Config.WeaponSlot] or 1
end

-- Auto equip loop
task.spawn(function()
    while true do
        task.wait(1)
        if not getgenv().Config.Enabled then continue end
        local localFighter = FighterController.LocalFighter
        if localFighter and localFighter.EquippedItem == nil then
            pcall(function() localFighter:EquipItem(getSlotNumber()) end)
        end
    end
end)

local lastFire = 0

local function getClosestTarget()
    local char = lplr.Character
    local myRoot = char and char:FindFirstChild("HumanoidRootPart")
    if not myRoot then return nil, nil, nil end

    local closestModel, closestRoot, closestHead = nil, nil, nil
    local closestDist = getgenv().Config.MaxDistance

    for _, obj in ipairs(Workspace:GetDescendants()) do
        if obj:IsA("Model") and obj ~= char then
            local pRoot = obj:FindFirstChild("HumanoidRootPart")
            local pHead = obj:FindFirstChild("Head")
            local pHum = obj:FindFirstChildWhichIsA("Humanoid")

            if pRoot and pHead and pHum and pHum.Health > 0 then
                if not Players:GetPlayerFromCharacter(obj) then
                    local dist = (myRoot.Position - pRoot.Position).Magnitude
                    if dist < closestDist then
                        closestDist = dist
                        closestModel = obj
                        closestRoot = pRoot
                        closestHead = pHead
                    end
                end
            end
        end
    end
    return closestModel, closestRoot, closestHead
end

-- Heartbeat fire loop
RunService.Heartbeat:Connect(function()
    if not getgenv().Config.Enabled then return end

    local targetModel, targetRoot, targetHead = getClosestTarget()
    if not targetModel or not targetHead or not targetRoot then return end

    local char = lplr.Character
    if not char or not char:FindFirstChild("HumanoidRootPart") then return end

    local localFighter = FighterController.LocalFighter
    if not localFighter or not localFighter.EquippedItem then return end

    if tick() - lastFire < getgenv().Config.FireRate then return end
    lastFire = tick()

    local originPos = targetHead.Position + Vector3.new(0, 1, 0)
    local targetPos = targetHead.Position
    local aimCF = CFrame.lookAt(originPos, targetPos)
    local targetCF = targetHead.CFrame

    local randomOffset = Vector3.new(
        (math.random() - 0.5) * 0.02,
        (math.random() - 0.5) * 0.02,
        (math.random() - 0.5) * 0.02
    )
    local aimedPos = targetPos + randomOffset
    local objSpaceHeadOffset = targetHead.CFrame:ToObjectSpace(CFrame.new(aimedPos))

    local cameradata = {}
    cameradata[utf8.char(1)] = {
        [utf8.char(0)] = util:EncodeCFrame(aimCF),
        [utf8.char(1)] = util:EncodeCFrame(targetCF),
        [utf8.char(2)] = targetHead,
        [utf8.char(3)] = util:EncodeCFrame(objSpaceHeadOffset)
    }

    pcall(function()
        ReplicatedStorage.Remotes.Replication.Fighter.UseItem:FireServer(
            localFighter.EquippedItem:Get("ObjectID"),
            enum:ToEnum("StartShooting"),
            cameradata,
            nil
        )
    end)
end)

-- ─── RAYFIELD UI ───────────────────────────────────────────────

local Window = Rayfield:CreateWindow({
    Name = "boneclawlegend",
    LoadingTitle = "boneclawlegend",
    LoadingSubtitle = "by nullstate",
    Theme = "Default",
    DisableRayfieldPrompts = false,
    DisableBuildWarnings = false,
    ConfigurationSaving = {
        Enabled = true,
        FolderName = "boneclawlegend",
        FileName = "config"
    },
    Discord = {
        Enabled = false,
    },
    KeySystem = false,
})

local CombatTab = Window:CreateTab("Combat", 4483362458)

-- Toggle
CombatTab:CreateToggle({
    Name = "Enable Auto-Shoot",
    CurrentValue = getgenv().Config.Enabled,
    Flag = "EnabledToggle",
    Callback = function(Value)
        getgenv().Config.Enabled = Value
    end,
})

-- Weapon Slot Dropdown
CombatTab:CreateDropdown({
    Name = "Weapon Slot",
    Options = {"Primary", "Secondary", "Melee"},
    CurrentOption = {"Primary"},
    MultipleOptions = false,
    Flag = "WeaponSlotDropdown",
    Callback = function(Option)
        getgenv().Config.WeaponSlot = Option
    end,
})

-- Fire Rate Slider
CombatTab:CreateSlider({
    Name = "Fire Rate (seconds)",
    Range = {0.01, 0.5},
    Increment = 0.01,
    Suffix = "s",
    CurrentValue = getgenv().Config.FireRate,
    Flag = "FireRateSlider",
    Callback = function(Value)
        getgenv().Config.FireRate = Value
    end,
})

-- Max Distance Slider
CombatTab:CreateSlider({
    Name = "Max Distance",
    Range = {50, 2000},
    Increment = 10,
    Suffix = "studs",
    CurrentValue = getgenv().Config.MaxDistance,
    Flag = "MaxDistSlider",
    Callback = function(Value)
        getgenv().Config.MaxDistance = Value
    end,
})

-- Settings Tab
local SettingsTab = Window:CreateTab("Settings", 4483362458)

SettingsTab:CreateButton({
    Name = "Unload GUI",
    Callback = function()
        Rayfield:Destroy()
    end,
})

-- Notify on load
Rayfield:Notify({
    Title = "boneclawlegend",
    Content = "Script loaded successfully",
    Duration = 4,
    Image = 4483362458,
})