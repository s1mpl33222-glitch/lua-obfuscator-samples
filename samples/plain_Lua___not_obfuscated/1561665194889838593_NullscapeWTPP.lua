local ReplicatedStorage = game:GetService("ReplicatedStorage")
local ReplicatedFirst = game:GetService("ReplicatedFirst")
local RunService = game:GetService("RunService")
local Players = game:GetService("Players")

local giftClient = ReplicatedFirst.ClientModules:FindFirstChild("GiftClient")
local upgradeHandler = ReplicatedFirst.ClientModules:FindFirstChild("UpgradeHandler")
local projectileClient = ReplicatedFirst.ClientModules:FindFirstChild("ProjectileClient")
local enemiesFolder = workspace:FindFirstChild("Enemies")

local chargerMod = require(ReplicatedStorage.Movement.Specials.Charger)
local gliderMod = require(ReplicatedStorage.Movement.Specials.Glider)
local diverMod = require(ReplicatedStorage.Movement.Specials.Dive)
local grapplerMod = require(ReplicatedStorage.Movement.Specials.Grapple)
local spiritMod = require(ReplicatedStorage.Movement.Specials.Spirit)
local inventoryHandler = require(ReplicatedFirst.ClientModules.Core.PlayerData.InventoryHandler)

local ClientUpgrades = {
    "MatrixTetrahedron",
    "Helmet",
    "AdvancedGravityCoil",
    "IceSkates",
    "SportShoes",
    "NinjaBelt",
    "MiniatureHourglass",
    "SharkTail",
    "SwiftnessRing",
    "RealWings",
    "DoubleJump",
    "GiftMagnet",
}

local repo = "https://raw.githubusercontent.com/deividcomsono/Obsidian/main/"
local Library = loadstring(game:HttpGet(repo .. "Library.lua"))()
local SaveManager = loadstring(game:HttpGet(repo .. "addons/SaveManager.lua"))() 
local ImageManager = Library.ImageManager

local Options = Library.Options
local Toggles = Library.Toggles

-- im doing this because Obsidian doesnt yield when downloading assets
local function DownloadAssetYield(url, name)
    local asset = ImageManager.AddAsset(name, 0, url)
    repeat RunService.PreRender:Wait() until ImageManager.GetAsset(name)
end

local Loading = Library:CreateLoading({
    Title = "Whats the point of playing",
    TotalSteps = 1
})

Loading:SetMessage("Downloading Assets...")
DownloadAssetYield(
    "https://gitlab.com/anteater1019/nassets/-/raw/main/Entropy_Game_Icon.png",
    "WTPP_icon.png"
)

Loading:SetCurrentStep(1)
Loading:SetMessage("Ready to start!")
task.wait(0.1)
Loading:Continue()


local Window = Library:CreateWindow({
    Title = "whats the point\nof playing",
    Footer = `v{game.PlaceVersion}`,
    Icon = ImageManager.GetAsset("WTPP_icon.png") -- no one told me this was the issue until a scriptblox mod told me
})

local Tabs = {
    Main = Window:AddTab("Main", "user"),
    Enemies = Window:AddTab("Enemies", "face-angry"),
    Settings = Window:AddTab("UI Settings", "settings")
}

local Boxes = {
    Main = {
        Groupboxes = {
            ClassMod = Tabs.Main:AddGroupbox({
                Side = "Left",
                Name = "Class Modifier"
            }),
            ClassChanger = Tabs.Main:AddGroupbox({
                Side = "Right",
                Name = "Class Changer"
            }),
            Upgrades = Tabs.Main:AddGroupbox({
                Side = "Right",
                Name = "Upgrades",
                Visible = upgradeHandler ~= nil
            })
        },
    },
    Enemies = {
        Groupboxes = {
            Objects = Tabs.Enemies:AddGroupbox({
                Side = "Left",
                Name = "Objects Disabler"
            }),
            Entities = Tabs.Enemies:AddGroupbox({
                Side = "Right",
                Name = "Entity Disabler"
            })
        },
    },
    Settings = {
        Groupboxes = {
            Binders = Tabs.Settings:AddGroupbox({
                Side = "Left",
                Name = "Binders"
            })
        }
    }
}

local Elements = {
    Main = {
        Toggles = {
            GliderInstaCharge = Boxes.Main.Groupboxes.ClassMod:AddToggle("GliderCharge", {
                Text = "Enable Glider Inf Charge",
                Default = false,

                Disabled = typeof(hookfunction) ~= "function"
            }),
            GrapplerInfCharge = Boxes.Main.Groupboxes.ClassMod:AddToggle("GrapplerInfCharge", {
                Text = "Enable Grappler Inf Charge",
                Default = false,

                Disabled = typeof(hookfunction) ~= "function"
            }),
            SpiritInfCharge = Boxes.Main.Groupboxes.ClassMod:AddToggle("SpiritInfCharge", {
                Text = "Enable Spirit Inf Charge",
                Default = false,

                Disabled = typeof(hookfunction) ~= "function"
            }),
            GrapplerNoCD = Boxes.Main.Groupboxes.ClassMod:AddToggle("GrapplerNoCD", {
                Text = "Enable Grappler No Cooldown",
                Default = false,

                Disabled = typeof(hookfunction) ~= "function"
            }),
            ChargerNoCD = Boxes.Main.Groupboxes.ClassMod:AddToggle("ChargerCD", {
                Text = "Enable Charger No Cooldown",
                Default = false,

                Disabled = typeof(hookfunction) ~= "function"
            }),
            DiverNoCD = Boxes.Main.Groupboxes.ClassMod:AddToggle("DiverCD", {
                Text = "Enable Diver No Cooldown",
                Default = false,

                Disabled = typeof(hookfunction) ~= "function"
            }),
            DiverNoBonk = Boxes.Main.Groupboxes.ClassMod:AddToggle("DiverFreeMovement", {
                Text = "Enable Diver Free Movement",
                Default = false,
                Tooltip = "Allows you to move around with your camera when diving",

                Disabled = typeof(hookfunction) ~= "function"
            }),
        },
        Dropdowns = {
            ClassChange = Boxes.Main.Groupboxes.ClassChanger:AddDropdown("ClassChange", {
                Text = "Class Changer",
                Values = {"Diver", "Charger", "Grappler", "Glider", "Spirit", "Phoon", "Wanted", "Wicked"},
                Default = 1,
                Multi = false,
                Searchable = true,
                Disabled = typeof(firesignal) ~= "function"
                
            }),
            UpgradeDropdown = Boxes.Main.Groupboxes.Upgrades:AddDropdown("Upgrades", {
                Values = ClientUpgrades,
                Text = "Upgrades Enabler",
                Multi = true,
                Searchable = true,
                Default = 0,
            }),
            StackUpgradeDropdown = Boxes.Main.Groupboxes.Upgrades:AddDropdown("StackUpgrades", {
                Values = ClientUpgrades,
                Text = "Upgrades Stack Modifier",
                Searchable = true,
                Default = 0,
            }),
        },
        Slider = {
            GrapplerRange = Boxes.Main.Groupboxes.ClassMod:AddSlider("GrappleRange", {
                Text = "Grappler Range",
                Default = 90,
                Min = 90,
                Max = 9e9,
                Rounding = 0,

                Disabled = typeof(hookmetamethod) ~= "function"
            }),
            StackSlider = Boxes.Main.Groupboxes.Upgrades:AddSlider("UpgradeStack", {
                Text = "Stacks",
                Default = 1,
                Min = 0,
                Max = 100,
                Rounding = 0,
                Visible = false
            })
        },
    },
    Enemies = {
        Toggles = {
            TripminesDisabler = Boxes.Enemies.Groupboxes.Objects:AddToggle("Tripmines", {
                Text = "Tripmine Disabler",
                Default = false,
                Disabled = typeof(hookfunction) ~= "function"
            }),
            ProjectileDisabler = Boxes.Enemies.Groupboxes.Objects:AddToggle("Projectiles", {
                Text = "Projectile Disabler",
                Default = false,
                Disabled = typeof(hookfunction) ~= "function"
            }),
            EnemyDisabler = Boxes.Enemies.Groupboxes.Entities:AddDropdown("Enemies", {
                -- yeah, whats wrong with transforms?
                Values = if enemiesFolder then (function() 
                local names = {} 
                
                for _, enemy in ReplicatedStorage.EnemyFolder.Enemies:GetChildren() do
                    table.insert(names, enemy.Name)
                end

                return names
                end)() else {},
                Text = "Enemy Disabler",
                Default = 0,
                Multi = true,
                Searchable = true,
                Disabled = workspace:FindFirstChild("Enemies") == nil
            }),
        }
    },
    Settings = {
        Bindings = {
            MenuBind = Boxes.Settings.Groupboxes.Binders:AddLabel("Menu bind"):AddKeyPicker("MenuKeybind", {
                Default = "RightShift",
                NoUI = true,
                Text = "Menu keybind"
            })
        }
    }
}

-- Utility
local function RemoveEnemy(enemy)
    local ai = enemy:FindFirstChild(`{enemy.Name}_ClientAI`)
    if ai then
        ai.Disabled = true
    end
    enemy:Destroy()
end

-- Core

-- glider inf charge
local glider_WallCheck; glider_WallCheck = hookfunction(gliderMod.WallCheck, function(self, ...)

    self.Time = Toggles.GliderCharge.Value and self.TimeClamp or self.Time
    return glider_WallCheck(self, ...)
end)
-- grappler inf charge 
local grappler_Step; grappler_Step = hookfunction(grapplerMod.Step, function(self, ...)
    self.Time = Toggles.GrapplerInfCharge.Value and self.TimeClamp or self.Time

    self.reelCooldown = if Toggles.GrapplerNoCD.Value then false else self.reelCooldown
    self.Charges = Toggles.GrapplerNoCD.Value and 3 or self.Charges
    return grappler_Step(self, ...)
end)
-- spirit inf charge
local spirit_Step; spirit_Step = hookfunction(spiritMod.Step, function(self, ...)
    self.stamina = Toggles.SpiritInfCharge.Value and self.maxTime or self.stamina
    return spirit_Step(self, ...)
end)
-- diver free movement (longest shit)
local diver_Step; diver_Step = hookfunction(diverMod.Step, function(data, ...)
    data.Movement.slideJumped = if Toggles.DiverCD.Value then false else data.Movement.slideJumped
    if Toggles.DiverFreeMovement.Value then
        local rootPart = data.RootPart
        if rootPart then
            local diveVelocity = rootPart:FindFirstChild("DiveVelocity")
            if diveVelocity then
                local direction = data.Movement.Camera.CFrame.LookVector
                direction = direction * Vector3.new(1, 0, 1)

                if direction.Magnitude > 0.001 then
                    direction = direction.Unit

                    data.Movement:SetMoveDirection(direction)

                    local speed = (data.RootPart.Velocity * Vector3.new(1, 0, 1)).Magnitude

                    diveVelocity.Velocity = direction * speed
                    data.Animator:FaceMoveDirection()
                end
            end
        end
    end
    return diver_Step(data, ...)
end)
-- charger no cooldown
local charger_End; charger_End = hookfunction(chargerMod.End, function(self, ...)
    -- had an eureka when i was bed rotting, now i dont have to use task.delay
    local result = charger_End(self, ...)

    self.debounce = if Toggles.ChargerCD.Value then false else self.debounce

    return result
end)

-- class changer
Options.ClassChange:OnChanged(function()
    firesignal(ReplicatedStorage.RemoteEvents.ReplicaSet.OnClientEvent, inventoryHandler.GetReplica().Id, {
        "Class",
        "Equipped"
    },
    "class/"..Options.ClassChange.Value)
end)

-- grappler range mod
-- im using pufo's method because its simple
local oldenv = getfenv(grapplerMod.Cast)
local fakeWorkspace = setmetatable({}, {
    __index = function(self, index)
        if index == 'Raycast' then
            return function(_, origin, direction, parameters)
                return workspace:Raycast(origin, direction * Options.GrappleRange.Value, parameters)
            end
        end
        return workspace[index]
    end
})
local newenv = setmetatable({}, {
    __index = function(self, index)
        if index == 'workspace' then
            return fakeWorkspace
        end
        return oldenv[index]
    end
})
setfenv(grapplerMod.Cast, newenv)

-- Object disabler

if giftClient and projectileClient then
    local TripmineMod = require(giftClient.GiftClientHandler.Gifts.TripmineClient)
    local Projectiles = require(projectileClient.ProjectileClientHandler)
    local tripmine_Collect; tripmine_Collect = hookfunction(TripmineMod.Collect, function(...)
        return if Toggles.Tripmines.Value then nil else tripmine_Collect(...) 
    end)
    local projectiles_New; projectiles_New = hookfunction(Projectiles.new, function(...)
        return if Toggles.Projectiles.Value then nil else projectiles_New(...)
    end)
else
    Toggles.Tripmines:SetDisabled(true)
    Toggles.Projectiles:SetDisabled(true)
end

-- Enemy Disabler
if enemiesFolder then
    local enemyPrevious = {}

    Options.Enemies:OnChanged(function(current)
        for entity, selected in current do
            if selected and not enemyPrevious[entity] then
                for _, enemy in enemiesFolder:GetChildren() do
                    if enemy.Name == entity then
                        RemoveEnemy(enemy)
                    end
                end
            end
        end

        enemyPrevious = table.clone(current)
    end)

    enemiesFolder.ChildAdded:Connect(function(enemy)
        if enemyPrevious[enemy.Name] then
            RemoveEnemy(enemy)
        end
    end)
end

-- Upgrades stuff
if upgradeHandler then
    local upgradeMod = require(upgradeHandler)
    local EnabledUpgrades = {}
    local UpgradeStacks = {}

    -- i was so fucking tired during the produciton of this code that i did not realize
    -- i was returning the values like this `return upgrade and true or upgrade_IsUpgradeEnabled(upgrade)`
    local upgrade_IsUpgradeEnabled; upgrade_IsUpgradeEnabled = hookfunction(upgradeMod.IsUpgradeEnabled, function(name)
        local upgrade = name and EnabledUpgrades[name]
        
        return upgrade or upgrade_IsUpgradeEnabled(name)
    end)
    local upgrade_GetUpgradeStack; upgrade_GetUpgradeStack = hookfunction(upgradeMod.GetUpgradeStack, function(name)
        local upgrade = name and UpgradeStacks[name]

        return upgrade or upgrade_GetUpgradeStack(name)
    end)

    Options.Upgrades:OnChanged(function(values)
        for upgrade, enabled in values do
            EnabledUpgrades[upgrade] = enabled
        end
    end)

    Options.StackUpgrades:OnChanged(function(upgrade)
        Elements.Main.Slider.StackSlider:SetVisible(true)
        local stack = UpgradeStacks[upgrade] or 0
        Elements.Main.Slider.StackSlider:SetValue(stack)
    end)

    Options.UpgradeStack:OnChanged(function(value)
        local upgrade = Options.StackUpgrades.Value

        if upgrade then
            UpgradeStacks[upgrade] = value
        end
    end)

end
-- Settings

SaveManager:SetLibrary(Library)
SaveManager:IgnoreThemeSettings()
SaveManager:SetFolder("Nullscaper")
SaveManager:BuildConfigSection(Tabs.Settings)
SaveManager:LoadAutoloadConfig()
Library.ToggleKeybind = Options.MenuKeybind 