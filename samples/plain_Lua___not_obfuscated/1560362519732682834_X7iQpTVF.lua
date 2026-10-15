-- FIXZ HUB | MEME SEA 📍
-- Auto Farm Only - Fluent UI
-- Based on redz9999's script

print("📍 Loading Fixz Hub for Meme Sea...")

local _wait = task.wait
repeat _wait() until game:IsLoaded()
local _env = getgenv and getgenv() or {}

local ReplicatedStorage = game:GetService("ReplicatedStorage")
local VirtualUser = game:GetService("VirtualUser")
local Players = game:GetService("Players")

local Player = Players.LocalPlayer

local rs_Monsters = ReplicatedStorage:WaitForChild("MonsterSpawn")
local Modules = ReplicatedStorage:WaitForChild("ModuleScript")
local OtherEvent = ReplicatedStorage:WaitForChild("OtherEvent")
local Monsters = workspace:WaitForChild("Monster")

local MQuestSettings = require(Modules:WaitForChild("Quest_Settings"))
local MSetting = require(Modules:WaitForChild("Setting"))

local NPCs = workspace:WaitForChild("NPCs")
local Location = workspace:WaitForChild("Location")

local Quests_Npc = NPCs:WaitForChild("Quests_Npc")
local EnemyLocation = Location:WaitForChild("Enemy_Location")
local QuestLocation = Location:WaitForChild("QuestLocaion")

local QuestFolder = Player:WaitForChild("QuestFolder")
local Ability = Player:WaitForChild("Ability")
local PlayerData = Player:WaitForChild("PlayerData")
local PlayerLevel = PlayerData:WaitForChild("Level")

local sethiddenproperty = sethiddenproperty or (function()end)

local CFrame_Angles = CFrame.Angles
local CFrame_new = CFrame.new
local _huge = math.huge

-- Anti-AFK
Player.Idled:Connect(function()
    VirtualUser:CaptureController()
    VirtualUser:ClickButton2(Vector2.new())
end)

-- Initialize Data
local Loaded, Funcs = {}, {} do
  Loaded.WeaponsList = { "Fight", "Power", "Weapon" }
  Loaded.EnemeiesList = {}
  Loaded.EnemiesQuests = {}
  Loaded.Quests = {}
  
  Funcs.GetPlayerLevel = function(self)
    return PlayerLevel.Value
  end
  
  Funcs.GetCurrentQuest = function(self)
    for _,Quest in pairs(Loaded.Quests) do
      if Quest.Level <= self:GetPlayerLevel() and not Quest.RaidBoss and not Quest.SpecialQuest then
        return Quest
      end
    end
  end
  
  Funcs.CheckQuest = function(self)
    for _,v in ipairs(QuestFolder:GetChildren()) do
      if v.Target.Value ~= "None" then
        return v
      end
    end
  end
  
  Funcs.AbilityUnlocked = function(self, Ablt)
    return Ability:FindFirstChild(Ablt) and Ability[Ablt].Value
  end
  
  for Npc,Quest in pairs(MQuestSettings) do
    if QuestLocation:FindFirstChild(Npc) then
      table.insert(Loaded.Quests, {
        RaidBoss = Quest.Raid_Boss,
        SpecialQuest = Quest.Special_Quest,
        QuestPos = QuestLocation[Npc].CFrame,
        EnemyPos = EnemyLocation[Quest.Target].CFrame,
        Level = Quest.LevelNeed,
        Enemy = Quest.Target,
        NpcName = Npc
      })
    end
  end
  
  table.sort(Loaded.Quests, function(a, b) return a.Level > b.Level end)
  for _,v in ipairs(Loaded.Quests) do
    table.insert(Loaded.EnemeiesList, v.Enemy)
    Loaded.EnemiesQuests[v.Enemy] = v.NpcName
  end
end

-- Settings
local Settings = {} do
  Settings.AutoStats_Points = 1
  Settings.BringMobs = true
  Settings.FarmDistance = 9
  Settings.AutoHaki = true
  Settings.AutoClick = true
  Settings.ToolFarm = "Fight"
  Settings.FarmCFrame = CFrame_new(0, Settings.FarmDistance, 0) * CFrame_Angles(math.rad(-90), 0, 0)
end

-- Helper Functions
local function PlayerClick()
  local Char = Player.Character
  if Char then
    if Settings.AutoClick then
      VirtualUser:CaptureController()
      VirtualUser:Button1Down(Vector2.new(1e4, 1e4))
    end
    if Settings.AutoHaki and Char:FindFirstChild("AuraColor_Folder") and Funcs:AbilityUnlocked("Aura") then
      if #Char.AuraColor_Folder:GetChildren() < 1 then
        OtherEvent.MainEvents.Ability:InvokeServer("Aura")
      end
    end
  end
end

local function IsAlive(Char)
  local Hum = Char and Char:FindFirstChild("Humanoid")
  return Hum and Hum.Health > 0
end

local function GetNextEnemie(EnemieName)
  for _,v in ipairs(Monsters:GetChildren()) do
    if (not EnemieName or v.Name == EnemieName) and IsAlive(v) then
      return v
    end
  end
  return false
end

local function GoTo(CFrame)
  local Char = Player.Character
  if IsAlive(Char) then
    Char:SetPrimaryPartCFrame(CFrame)
  end
end

local function EquipWeapon()
  local Backpack, Char = Player:FindFirstChild("Backpack"), Player.Character
  if IsAlive(Char) and Backpack then
    for _,v in ipairs(Backpack:GetChildren()) do
      if v:IsA("Tool") and v.ToolTip:find(Settings.ToolFarm) then
        Char.Humanoid:EquipTool(v)
        return
      end
    end
    -- If no weapon in backpack, check character
    for _,v in ipairs(Char:GetChildren()) do
      if v:IsA("Tool") and v.ToolTip:find(Settings.ToolFarm) then
        return -- Already equipped
      end
    end
  end
end

local function BringMobsTo(_Enemie, CFrame)
  for _,v in ipairs(Monsters:GetChildren()) do
    if v.Name == _Enemie and IsAlive(v) then
      local PP, Hum = v.PrimaryPart, v.Humanoid
      if PP and (PP.Position - CFrame.p).Magnitude < 500 then
        Hum.WalkSpeed = 0
        Hum:ChangeState(14)
        PP.CFrame = CFrame
        PP.CanCollide = false
        PP.Transparency = 1
        PP.Size = Vector3.new(50, 50, 50)
      end
    end
  end
  return pcall(sethiddenproperty, Player, "SimulationRadius", _huge)
end

local function KillMonster(_Enemie)
  local Enemy = typeof(_Enemie) == "Instance" and _Enemie or GetNextEnemie(_Enemie)
  if IsAlive(Enemy) and Enemy.PrimaryPart then
    GoTo(Enemy.PrimaryPart.CFrame * Settings.FarmCFrame)
    EquipWeapon()
    if not Enemy:FindFirstChild("Reverse_Mark") then PlayerClick() end
    if Settings.BringMobs then BringMobsTo(_Enemie, Enemy.PrimaryPart.CFrame) end
    return true
  end
end

local function TakeQuest(QuestName, CFrame)
  local QuestGiver = Quests_Npc:FindFirstChild(QuestName)
  if QuestGiver and Player:DistanceFromCharacter(QuestGiver.WorldPivot.p) < 5 then
    return fireproximityprompt(QuestGiver.Block.QuestPrompt), _wait(0.1)
  end
  GoTo(CFrame or QuestLocation[QuestName].CFrame)
end

local function ClearQuests(Ignore)
  for _,v in ipairs(QuestFolder:GetChildren()) do
    if v.QuestGiver.Value ~= Ignore and v.Target.Value ~= "None" then
      OtherEvent.QuestEvents.Quest:FireServer("Abandon_Quest", { QuestSlot = v.Name })
    end
  end
end

local function VerifyQuest(QName)
  local Quest = Funcs:CheckQuest()
  return Quest and Quest.QuestGiver.Value == QName
end

-- Farm Functions
_env.FarmFuncs = {
  {"Level Farm", (function()
    local Quest, QuestChecker = Funcs:GetCurrentQuest(), Funcs:CheckQuest()
    if Quest then
      if QuestChecker then
        local _QuestName = QuestChecker.QuestGiver.Value
        if _QuestName == Quest.NpcName then
          if KillMonster(Quest.Enemy) then else GoTo(Quest.EnemyPos) end
        else
          if KillMonster(QuestChecker.Target.Value) then else GoTo(QuestLocation[_QuestName].CFrame) end
        end
      else TakeQuest(Quest.NpcName) end
    end
    return true
  end)},
  {"FS Enemie", (function()
    local Enemy = _env.SelecetedEnemie
    local Quest = Loaded.EnemiesQuests[Enemy]
    if VerifyQuest(Quest) or not _env["FS Take Quest"] then
      if KillMonster(Enemy) then else GoTo(EnemyLocation[Enemy].CFrame) end
    else ClearQuests(Quest)TakeQuest(Quest) end
    return true
  end)},
  {"Nearest Farm", (function() return KillMonster(GetNextEnemie()) end)}
}

-- Start Farm Loop
if not _env.LoadedFarm then
  _env.LoadedFarm = true
  task.spawn(function()
    while _wait() do
      for _,f in _env.FarmFuncs do
        if _env[f[1]] then 
          local s,r=pcall(f[2])
          if s and r then break end
        end
      end
    end
  end)
end

-- Load Fluent UI
print("Loading Fluent UI...")
local Fluent = loadstring(game:HttpGet("https://github.com/dawid-scripts/Fluent/releases/latest/download/main.lua"))()
local SaveManager = loadstring(game:HttpGet("https://raw.githubusercontent.com/dawid-scripts/Fluent/master/Addons/SaveManager.lua"))()
local InterfaceManager = loadstring(game:HttpGet("https://raw.githubusercontent.com/dawid-scripts/Fluent/master/Addons/InterfaceManager.lua"))()

print("Creating window...")

-- Create Window
local Window = Fluent:CreateWindow({
    Title = "📍 Fixz Hub | Meme Sea",
    SubTitle = ("MaxLevel: %i"):format(MSetting.Setting.MaxLevel),
    TabWidth = 160,
    Size = UDim2.fromOffset(580, 460),
    Acrylic = true,
    Theme = "Darker",
    MinimizeKey = Enum.KeyCode.LeftControl
})

-- Create Tabs
local Tabs = {
    Main = Window:AddTab({ Title = "⚔️ Auto Farm", Icon = "swords" }),
    Settings = Window:AddTab({ Title = "⚙️ Settings", Icon = "settings" })
}

-- MAIN TAB
Tabs.Main:AddParagraph({
    Title = "📍 Fixz Hub | Meme Sea",
    Content = "Auto farm levels, enemies, and more! Simple and effective farming script."
})

local StatsLabel = Tabs.Main:AddParagraph({
    Title = "📊 Current Stats",
    Content = string.format("Level: %i / %i\nFarm Tool: %s", PlayerLevel.Value, MSetting.Setting.MaxLevel, Settings.ToolFarm)
})

-- Update stats every 5 seconds
task.spawn(function()
    while _wait(5) do
        pcall(function()
            StatsLabel:SetDesc(string.format("Level: %i / %i\nFarm Tool: %s", PlayerLevel.Value, MSetting.Setting.MaxLevel, Settings.ToolFarm))
        end)
    end
end)

Tabs.Main:AddButton({
    Title = "🎮 Join Discord",
    Description = "Get support and updates",
    Callback = function()
        setclipboard("https://discord.gg/w7mpnRStv3")
        Fluent:Notify({
            Title = "Discord Copied!",
            Content = "Discord invite copied to clipboard!",
            Duration = 3
        })
    end
})

Tabs.Main:AddSection("Farm Configuration")

local FarmToolDropdown = Tabs.Main:AddDropdown("FarmTool", {
    Title = "⚔️ Farm Tool",
    Description = "Select weapon type for farming",
    Values = Loaded.WeaponsList,
    Multi = false,
    Default = 1,
})

FarmToolDropdown:OnChanged(function(value)
    Settings.ToolFarm = value
    Fluent:Notify({
        Title = "Farm Tool Changed!",
        Content = "Now using: " .. value,
        Duration = 2
    })
end)

Tabs.Main:AddSection("Auto Farm Options")

local LevelFarmToggle = Tabs.Main:AddToggle("LevelFarm", {
    Title = "⚔️ Auto Farm Level",
    Description = "Farm best quest for your level (auto quest + kill)",
    Default = false
})

LevelFarmToggle:OnChanged(function(state)
    _env["Level Farm"] = state
    Fluent:Notify({
        Title = state and "Level Farm ON!" or "Level Farm OFF",
        Content = state and "Auto farming levels" or "Stopped level farming",
        Duration = 3
    })
end)

local NearestFarmToggle = Tabs.Main:AddToggle("NearestFarm", {
    Title = "🎯 Auto Farm Nearest",
    Description = "Farm closest enemy without quests",
    Default = false
})

NearestFarmToggle:OnChanged(function(state)
    _env["Nearest Farm"] = state
    Fluent:Notify({
        Title = state and "Nearest Farm ON!" or "Nearest Farm OFF",
        Content = state and "Farming nearest enemies" or "Stopped farming",
        Duration = 3
    })
end)

Tabs.Main:AddSection("Enemy Select Farm")

local EnemyDropdown = Tabs.Main:AddDropdown("SelectEnemy", {
    Title = "🐉 Select Enemy",
    Description = "Choose specific enemy to farm",
    Values = Loaded.EnemeiesList,
    Multi = false,
    Default = 1,
})

EnemyDropdown:OnChanged(function(value)
    _env.SelecetedEnemie = value
    Fluent:Notify({
        Title = "Enemy Selected!",
        Content = "Selected: " .. value,
        Duration = 2
    })
end)

local EnemyFarmToggle = Tabs.Main:AddToggle("EnemyFarm", {
    Title = "⚔️ Auto Farm Selected Enemy",
    Description = "Farm the selected enemy",
    Default = false
})

EnemyFarmToggle:OnChanged(function(state)
    _env["FS Enemie"] = state
    Fluent:Notify({
        Title = state and "Enemy Farm ON!" or "Enemy Farm OFF",
        Content = state and ("Farming: " .. (_env.SelecetedEnemie or "None")) or "Stopped farming",
        Duration = 3
    })
end)

local TakeQuestToggle = Tabs.Main:AddToggle("TakeQuest", {
    Title = "📜 Take Quest (Selected Enemy)",
    Description = "Auto take quest for selected enemy",
    Default = true
})

TakeQuestToggle:OnChanged(function(state)
    _env["FS Take Quest"] = state
end)

-- SETTINGS TAB
Tabs.Settings:AddParagraph({
    Title = "⚙️ Farm Settings",
    Content = "Configure farming behavior and preferences"
})

Tabs.Settings:AddSection("Auto Stats Upgrade")

local StatsName = {
    ["Power"] = "MemePowerLevel", 
    ["Health"] = "DefenseLevel",
    ["Weapon"] = "SwordLevel", 
    ["Melee"] = "MeleeLevel"
}

local SelectedStats = {}

local StatsPointsSlider = Tabs.Settings:AddSlider("StatsPoints", {
    Title = "📊 Points Per Upgrade",
    Description = "How many points to use per upgrade",
    Default = 1,
    Min = 1,
    Max = 100,
    Rounding = 1,
    Callback = function(value)
        Settings.AutoStats_Points = value
    end
})

local AutoStatsToggle = Tabs.Settings:AddToggle("AutoStats", {
    Title = "📈 Auto Stats",
    Description = "Automatically upgrade selected stats",
    Default = false
})

AutoStatsToggle:OnChanged(function(state)
    _env.AutoStats = state
    if state then
        Fluent:Notify({
            Title = "Auto Stats ON!",
            Content = "Upgrading selected stats automatically",
            Duration = 3
        })
    end
    
    local _Points = PlayerData.SkillPoint
    while _env.AutoStats do _wait(0.5)
        for stat, enabled in pairs(SelectedStats) do
            local _p, _s = _Points.Value, PlayerData[StatsName[stat]]
            if enabled and _p > 0 and _s.Value < MSetting.Setting.MaxLevel then
                pcall(function()
                    OtherEvent.MainEvents.StatsFunction:InvokeServer({
                        ["Target"] = StatsName[stat],
                        ["Action"] = "UpgradeStats",
                        ["Amount"] = math.clamp(Settings.AutoStats_Points or 1, 0, MSetting.Setting.MaxLevel - _s.Value)
                    })
                end)
            end
        end
    end
end)

Tabs.Settings:AddParagraph({
    Title = "Select Stats to Upgrade",
    Content = "Choose which stats to automatically upgrade"
})

local PowerStatsToggle = Tabs.Settings:AddToggle("PowerStats", {
    Title = "⚡ Power",
    Description = "Upgrade Meme Power Level",
    Default = false
})

PowerStatsToggle:OnChanged(function(state)
    SelectedStats["Power"] = state
end)

local HealthStatsToggle = Tabs.Settings:AddToggle("HealthStats", {
    Title = "❤️ Health",
    Description = "Upgrade Defense Level",
    Default = false
})

HealthStatsToggle:OnChanged(function(state)
    SelectedStats["Health"] = state
end)

local WeaponStatsToggle = Tabs.Settings:AddToggle("WeaponStats", {
    Title = "⚔️ Weapon",
    Description = "Upgrade Sword Level",
    Default = false
})

WeaponStatsToggle:OnChanged(function(state)
    SelectedStats["Weapon"] = state
end)

local MeleeStatsToggle = Tabs.Settings:AddToggle("MeleeStats", {
    Title = "👊 Melee",
    Description = "Upgrade Melee Level",
    Default = false
})

MeleeStatsToggle:OnChanged(function(state)
    SelectedStats["Melee"] = state
end)

Tabs.Settings:AddSection("Combat Settings")

local BringMobsToggle = Tabs.Settings:AddToggle("BringMobs", {
    Title = "🧲 Bring Mobs",
    Description = "Teleport mobs to you for easier farming",
    Default = Settings.BringMobs
})

BringMobsToggle:OnChanged(function(state)
    Settings.BringMobs = state
    Fluent:Notify({
        Title = state and "Bring Mobs ON!" or "Bring Mobs OFF",
        Content = state and "Teleporting mobs to you" or "Disabled mob bringing",
        Duration = 2
    })
end)

local AutoHakiToggle = Tabs.Settings:AddToggle("AutoHaki", {
    Title = "✨ Auto Haki",
    Description = "Auto enable Aura ability when available",
    Default = Settings.AutoHaki
})

AutoHakiToggle:OnChanged(function(state)
    Settings.AutoHaki = state
end)

local AutoAttackToggle = Tabs.Settings:AddToggle("AutoAttack", {
    Title = "⚔️ Auto Attack",
    Description = "Auto click to attack enemies",
    Default = Settings.AutoClick
})

AutoAttackToggle:OnChanged(function(state)
    Settings.AutoClick = state
end)

Tabs.Settings:AddSection("Distance Settings")

local FarmDistanceSlider = Tabs.Settings:AddSlider("FarmDistance", {
    Title = "📏 Farm Distance",
    Description = "Distance from enemy while farming",
    Default = Settings.FarmDistance,
    Min = 5,
    Max = 15,
    Rounding = 1,
    Callback = function(value)
        Settings.FarmDistance = value
        Settings.FarmCFrame = CFrame_new(0, value, 0) * CFrame_Angles(math.rad(-90), 0, 0)
    end
})

-- Save/Load System
SaveManager:SetLibrary(Fluent)
InterfaceManager:SetLibrary(Fluent)

SaveManager:IgnoreThemeSettings()
SaveManager:SetIgnoreIndexes({})

InterfaceManager:SetFolder("FixzHub")
SaveManager:SetFolder("FixzHub/MemeSea")

InterfaceManager:BuildInterfaceSection(Tabs.Settings)
SaveManager:BuildConfigSection(Tabs.Settings)

Window:SelectTab(1)

Fluent:Notify({
    Title = "📍 Fixz Hub Loaded!",
    Content = "Meme Sea Auto Farm ready!",
    Duration = 5
})

SaveManager:LoadAutoloadConfig()

print("✅ Fixz Hub fully loaded!")
print("⚔️ Auto Farm features enabled!")
print("🔧 Weapon system fixed - weapons will now equip properly!")