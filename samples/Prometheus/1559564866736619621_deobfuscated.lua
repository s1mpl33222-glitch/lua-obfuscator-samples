-- This file was generated at discord.gg/syncrypt

local t1 = {}
local v2 = unpack or table.unpack
t1.value1 = loadstring(game:HttpGet("https://raw.githubusercontent.com/Dabixic/windmodv4/refs/heads/main/lua"))()
local value1 = t1.value1
local CreateWindow = value1.CreateWindow
local uDim2 = UDim2.fromOffset(580, 460)
local t2 = {
	Enabled = true,
	Anonymous = true
}
t1.value2 = CreateWindow(value1, {
	Title = "RexHub | Sailor Piece",
	Icon = "globe",
	Author = "Free Script",
	Folder = "RexHub",
	Size = uDim2,
	Transparent = true,
	Theme = "Midnight",
	User = t2,
	SideBarWidth = 200,
	HasOutline = true
})
local value2 = t1.value2
local uDim = UDim.new(0, 16)
local EditOpenButton = value2.EditOpenButton
local colorSequence = ColorSequence.new(Color3.fromHex("FF0F7B"), Color3.fromHex("F89B29"))

EditOpenButton(value2, {
	Title = "Open UI",
	Icon = "monitor",
	CornerRadius = uDim,
	StrokeThickness = 2,
	Color = colorSequence,
	Draggable = true
})
local v11 = t1.value2:Tab({
	Title = "General",
	Icon = "settings",
	ShowTabTitle = true
})
local v12 = t1.value2:Divider()
local v13 = t1.value2:Tab({
	Title = "Main",
	Icon = "house",
	Desc = "Auto Farm & Misc"
})
local v14 = t1.value2:Tab({
	Title = "Boss Farm",
	Icon = "swords",
	Desc = "Farm Bosses"
})
local v15 = t1.value2:Tab({
	Title = "Dungeon",
	Icon = "door-open",
	Desc = "Auto Dungeon"
})
local v16 = t1.value2:Tab({
	Title = "Auto Stats",
	Icon = "chart-no-axes-column-increasing",
	Desc = "Upgrade Stats"
})
local v17 = t1.value2:Tab({
	Title = "Misc",
	Icon = "shopping-cart",
	Desc = "Merchant & Misc"
})
local v18 = t1.value2:Tab({
	Title = "Quest",
	Icon = "scroll-text",
	Desc = "Auto Quest"
})
local v19 = t1.value2:Divider()
local v20 = t1.value2:Tab({
	Title = "Settings Gui",
	Icon = "settings",
	Desc = "Manage window settings and file configurations.",
	ShowTabTitle = true
})
local t3 = {
	Tests = v11,
	v12,
	Main = v13,
	Boss = v14,
	Dungeon = v15,
	Stats = v16,
	Misc = v17,
	Quest = v18,
	v19,
	WindowTab = v20
}
t1.value3 = game:GetService("Players").LocalPlayer
t1.value4 = game:GetService("Players").LocalPlayer.Name
local _ = game.Players.LocalPlayer.Character.HumanoidRootPart
t1.value5 = game:GetService("VirtualInputManager")
t1.value6 = game:GetService("TweenService")
t1.value7 = nil
game:GetService("ReplicatedStorage"):WaitForChild("RemoteEvents"):WaitForChild("AllocateStat")
t1.value8 = game:GetService("ReplicatedStorage"):WaitForChild("RemoteEvents"):WaitForChild("QuestAccept")
t1.value9 = game:GetService("ReplicatedStorage"):WaitForChild("Remotes"):WaitForChild("TeleportToPortal")
t1.value10 = 0
t1.value11 = ""
t1.value12 = {
	YujiBoss = "Shibuya",
	GojoBoss = "Shibuya",
	SukunaBoss = "Shibuya",
	JinwooBoss = "Sailor",
	AizenBoss = "HuecoMundo",
	YamatoBoss = "Judgement",
	AlucardBoss = "Sailor",
	StrongestShinobiBoss = "Ninja"
}
t1.value13 = {
	"YujiBoss",
	"GojoBoss",
	"SukunaBoss",
	"JinwooBoss",
	"AizenBoss",
	"YamatoBoss",
	"AlucardBoss",
	"StrongestShinobiBoss"
}
t1.value14 = {
	WeaponSelect = "None",
	DistanceSlider = 8,
	AutofarmToggle = false,
	AutoAttckToggle = true,
	SkillSelect = {
		"Z",
		"X"
	},
	AutoAllBoss = false,
	AutoBoss = false,
	SelectBoss = {},
	AutoStatToggle = false,
	SelectedStats = {},
	MovementMode = "Teleport",
	Haki = true,
	Observation = true,
	FarmPosition = "Upper",
	DungeonSelect = "CidDungeon",
	AutoDungeon = false,
	DungeonDifficulty = "Easy",
	AutoDungeonFarm = false,
	AutoReplay = false,
	SummonBossSelect = "SaberBoss",
	SummonBossDifficulty = "Normal",
	AutoSummonBoss = false,
	AutoBrokenSword = false,
	AutoCraftDivineGrail = false,
	AutoFarmMonTarget = {},
	AutoFarmMonToggle = false,
	MerchantItem = "Boss Key",
	AutoBuyMerchant = false,
	ChestSelect = {},
	AutoOpenChest = false,
	AutoBuso = false
}
for _, v in ipairs(t1.value13) do
    t1.value14["Auto" .. v] = false
end
t1.value15 = {
	Thief1 = "",
	Thief2 = "",
	Thief3 = "",
	Thief4 = "",
	Thief15 = "",
	ThiefBoss = "",
	Monkey1 = "Jungle",
	Monkey2 = "Jungle",
	Monkey3 = "Jungle",
	Monkey4 = "Jungle",
	Monkey5 = "Jungle",
	MonkeyBoss = "Jungle",
	DesertBandit1 = "Desert",
	DesertBandit2 = "Desert",
	DesertBandit3 = "Desert",
	DesertBandit4 = "Desert",
	DesertBandit5 = "Desert",
	FrostRogue1 = "Snow",
	FrostRogue2 = "Snow",
	FrostRogue3 = "Snow",
	FrostRogue4 = "Snow",
	FrostRogue5 = "Snow",
	Hollow1 = "HuecoMundo",
	Hollow2 = "HuecoMundo",
	Hollow3 = "HuecoMundo",
	Hollow4 = "HuecoMundo",
	Hollow5 = "HuecoMundo",
	Curse1 = "Shinjuku",
	Curse2 = "Shinjuku",
	Curse3 = "Shinjuku",
	Curse4 = "Shinjuku",
	Curse5 = "Shinjuku",
	Slime1 = "Slime",
	Slime2 = "Slime",
	Slime3 = "Slime",
	Slime4 = "Slime",
	Slime5 = "Slime",
	AcademyTeacher1 = "Academy",
	AcademyTeacher2 = "Academy",
	AcademyTeacher3 = "Academy",
	AcademyTeacher4 = "Academy",
	AcademyTeacher5 = "Academy",
	Swordsman1 = "Judgement",
	Swordsman2 = "Judgement",
	Swordsman3 = "Judgement",
	Swordsman4 = "Judgement",
	Swordsman5 = "Judgement",
	Quincy1 = "SoulSociety",
	Quincy2 = "SoulSociety",
	Quincy3 = "SoulSociety",
	Quincy4 = "SoulSociety",
	Quincy5 = "SoulSociety",
	Ninja1 = "Ninja",
	Ninja2 = "Ninja",
	Ninja3 = "Ninja",
	Ninja4 = "Ninja",
	Ninja5 = "Ninja",
	ArenaFighter1 = "Lawless",
	ArenaFighter2 = "Lawless",
	ArenaFighter3 = "Lawless",
	ArenaFighter4 = "Lawless",
	ArenaFighter5 = "Lawless",
	Thief = "",
	ThiefBoss = "",
	Monkey = "Jungle",
	MonkeyBoss = "Jungle",
	DesertBandit = "Desert",
	FrostRogue = "Snow",
	Hollow = "HuecoMundo",
	Curse = "Shinjuku",
	Slime = "Slime",
	AcademyTeacher = "Academy",
	Swordsman = "Judgement",
	Quincy = "SoulSociety",
	Ninja = "Ninja",
	ArenaFighter = "Lawless"
}
t1.value16 = {
	Thief = {
		"Thief1",
		"Thief2",
		"Thief3",
		"Thief4",
		"Thief15"
	},
	ThiefBoss = { "ThiefBoss" },
	Monkey = {
		"Monkey1",
		"Monkey2",
		"Monkey3",
		"Monkey4",
		"Monkey5"
	},
	MonkeyBoss = { "MonkeyBoss" },
	DesertBandit = {
		"DesertBandit1",
		"DesertBandit2",
		"DesertBandit3",
		"DesertBandit4",
		"DesertBandit5"
	},
	FrostRogue = {
		"FrostRogue1",
		"FrostRogue2",
		"FrostRogue3",
		"FrostRogue4",
		"FrostRogue5"
	},
	Hollow = {
		"Hollow1",
		"Hollow2",
		"Hollow3",
		"Hollow4",
		"Hollow5"
	},
	Curse = {
		"Curse1",
		"Curse2",
		"Curse3",
		"Curse4",
		"Curse5"
	},
	Slime = {
		"Slime1",
		"Slime2",
		"Slime3",
		"Slime4",
		"Slime5"
	},
	AcademyTeacher = {
		"AcademyTeacher1",
		"AcademyTeacher2",
		"AcademyTeacher3",
		"AcademyTeacher4",
		"AcademyTeacher5"
	},
	Swordsman = {
		"Swordsman1",
		"Swordsman2",
		"Swordsman3",
		"Swordsman4",
		"Swordsman5"
	},
	Quincy = {
		"Quincy1",
		"Quincy2",
		"Quincy3",
		"Quincy4",
		"Quincy5"
	},
	Ninja = {
		"Ninja1",
		"Ninja2",
		"Ninja3",
		"Ninja4",
		"Ninja5"
	},
	ArenaFighter = {
		"ArenaFighter1",
		"ArenaFighter2",
		"ArenaFighter3",
		"ArenaFighter4",
		"ArenaFighter5"
	}
}
function t1.value17(p1)
    local v66 = t1.value14.FarmPosition or "Upper"

    if v66 == "Upper" then
        return CFrame.new(0, p1, 0) * CFrame.Angles(-1.5707963267948966, 0, 0)
    end

    if v66 == "Bottom" then
        return CFrame.new(0, -p1, 0) * CFrame.Angles(1.5707963267948966, 0, 0)
    end

    if v66 == "Behind" then
        return CFrame.new(0, 0, p1)
    end

    return CFrame.new(0, p1, 0) * CFrame.Angles(-1.5707963267948966, 0, 0)
end
function t1.value18(p2, p3)
    if t1.value14.MovementMode == "Tween" then
        local Magnitude = (p2.Position - p3.Position).Magnitude

        if Magnitude < 1 then
            return
        end

        local v61 = math.clamp(Magnitude / 150, 0.05, 3)

        if t1.value7 then
            pcall(function()
                t1.value7:Cancel()
            end)
        end

        local tweenInfo = TweenInfo.new(v61, Enum.EasingStyle.Linear, Enum.EasingDirection.Out)

        t1.value7 = t1.value6:Create(p2, tweenInfo, {
			CFrame = p3
		})
        t1.value7:Play()

        return
    end

    p2.CFrame = p3
    p2.Velocity = Vector3.new(0, 0, 0)
end
function t1.value19()
    local t4 = { "None" }
    local t5 = {}

    if t1.value3.Backpack then
        for _, child in ipairs(t1.value3.Backpack:GetChildren()) do
            if child:IsA("Tool") and not t5[child.Name] then
                table.insert(t4, child.Name)
                t5[child.Name] = true
            end
        end
    end

    if t1.value3.Character then
        for _, child in ipairs(t1.value3.Character:GetChildren()) do
            if child:IsA("Tool") and not t5[child.Name] then
                table.insert(t4, child.Name)
                t5[child.Name] = true
            end
        end
    end

    return t4
end
t1.value20 = {}
t3.Main:Section({
	Title = "Main Farm"
})
local value20 = t1.value20
local Main = t3.Main
local v27 = t1.value19()
value20.WeaponDropdown = Main:Dropdown({
	Title = "Select Weapon",
	Values = v27,
	Multi = false,
	Value = "None",
	Callback = function(p4)
    t1.value14.WeaponSelect = p4
end
})
t3.Main:Button({
	Title = "Refresh Weapons",
	Callback = function()
    t1.value20.WeaponDropdown:Refresh(t1.value19())
end
})
t1.value20.AutofarmToggle = t3.Main:Toggle({
	Title = "Enable Autofarm",
	Value = false,
	Callback = function(p5)
    t1.value14.AutofarmToggle = p5
end
})
t3.Main:Section({
	Title = "Specific Mon Farm"
})
t1.value20.AutoFarmMonTarget = t3.Main:Dropdown({
	Title = "Select Mon",
	Values = {
		"Thief",
		"ThiefBoss",
		"Monkey",
		"MonkeyBoss",
		"DesertBandit",
		"FrostRogue",
		"Hollow",
		"Curse",
		"Slime",
		"AcademyTeacher",
		"Swordsman",
		"Quincy",
		"Ninja",
		"ArenaFighter"
	},
	Multi = false,
	Value = nil,
	Callback = function(p6)
    t1.value14.AutoFarmMonTarget = p6
end
})
t1.value20.AutoFarmMonToggle = t3.Main:Toggle({
	Title = "Enable Autofarm Mon",
	Value = false,
	Callback = function(p7)
    t1.value14.AutoFarmMonToggle = p7
end
})
t3.Main:Section({
	Title = "Farm Distance"
})
local value20_2 = t1.value20
local Main2 = t3.Main
local t6 = {
	Min = 0,
	Max = 50,
	Default = 8
}
value20_2.DistanceSlider = Main2:Slider({
	Title = "Farm Distance",
	Value = t6,
	Callback = function(p8)
    t1.value14.DistanceSlider = p8
end
})
t1.value20.MovementMode = t3.Main:Dropdown({
	Title = "Movement Mode",
	Values = {
		"Teleport",
		"Tween"
	},
	Multi = false,
	Value = "Teleport",
	Callback = function(p9)
    t1.value14.MovementMode = p9
end
})
t1.value20.FarmPosition = t3.Main:Dropdown({
	Title = "Farm Position",
	Values = {
		"Upper",
		"Bottom",
		"Behind"
	},
	Multi = false,
	Value = "Upper",
	Callback = function(p10)
    t1.value14.FarmPosition = p10
end
})
t3.Main:Section({
	Title = "Setting Farm"
})
t1.value20.AutoAttckToggle = t3.Main:Toggle({
	Title = "Enable AutoAttck",
	Value = true,
	Callback = function(p11)
    t1.value14.AutoAttckToggle = p11
end
})
t1.value20.SkillSelect = t3.Main:Dropdown({
	Title = "Auto Skills",
	Values = {
		"Z",
		"X",
		"C",
		"V",
		"F"
	},
	Multi = true,
	Value = {
		"Z",
		"X"
	},
	Callback = function(p12)
    t1.value14.SkillSelect = p12
end
})
t3.Main:Section({
	Title = "Haki"
})
t1.value20.Haki = t3.Main:Toggle({
	Title = "Enable AutoHaki",
	Value = true,
	Callback = function(p13)
    t1.value14.Haki = p13
end
})
t1.value20.Observation = t3.Main:Toggle({
	Title = "Enable AutoObservation",
	Value = true,
	Callback = function(p14)
    t1.value14.Observation = p14
end
})
t1.value20.AutoAllBoss = t3.Boss:Toggle({
	Title = "Auto All Boss",
	Value = false,
	Callback = function(p15)
    t1.value14.AutoAllBoss = p15
end
})
t3.Boss:Section({
	Title = "Specific Bosses"
})
local value20_3 = t1.value20
local Boss = t3.Boss
local Dropdown = Boss.Dropdown
local value13 = t1.value13
value20_3.SelectBoss = Dropdown(Boss, {
	Title = "Select Boss",
	Multi = true,
	AllowNone = false,
	Value = nil,
	Values = value13,
	Callback = function(p16)
    t1.value14.SelectBoss = p16
end
})
t1.value20.AutoBoss = t3.Boss:Toggle({
	Title = "Auto Boss",
	Value = false,
	Callback = function(p17)
    t1.value14.AutoBoss = p17
end
})
t1.value20.AutoBrokenSword = t3.Boss:Toggle({
	Title = "Auto Broken Sword (Gilgamesh)",
	Value = false,
	Callback = function(p18)
    t1.value14.AutoBrokenSword = p18
end
})
t1.value20.AutoCraftDivineGrail = t3.Boss:Toggle({
	Title = "Auto Craft Divine Grail",
	Value = false,
	Callback = function(p19)
    t1.value14.AutoCraftDivineGrail = p19
end
})
t3.Boss:Section({
	Title = "Summon Boss"
})
t1.value20.SummonBossSelect = t3.Boss:Dropdown({
	Title = "Select Summon Boss",
	Values = {
		"SaberBoss",
		"Qin shi",
		"Ichigo",
		"Gilgamesh",
		"Blessed Maiden",
		"Saber Alter"
	},
	Multi = false,
	Value = "SaberBoss",
	Callback = function(p20)
    t1.value14.SummonBossSelect = p20
end
})
t1.value20.SummonBossDifficulty = t3.Boss:Dropdown({
	Title = "Select Difficulty",
	Values = {
		"Normal",
		"Medium",
		"Hard",
		"Extreme"
	},
	Multi = false,
	Value = "Normal",
	Callback = function(p21)
    t1.value14.SummonBossDifficulty = p21
end
})
t1.value20.AutoSummonBoss = t3.Boss:Toggle({
	Title = "Auto Boss",
	Value = false,
	Callback = function(p22)
    t1.value14.AutoSummonBoss = p22
end
})
t3.Dungeon:Section({
	Title = "Dungeon Settings"
})
t1.value20.DungeonSelect = t3.Dungeon:Dropdown({
	Title = "Select Dungeon",
	Values = {
		"CidDungeon",
		"RuneDungeon",
		"DoubleDungeon",
		"BossRush"
	},
	Multi = false,
	Value = "CidDungeon",
	Callback = function(p23)
    t1.value14.DungeonSelect = p23
end
})
t1.value20.AutoDungeon = t3.Dungeon:Toggle({
	Title = "Auto Enter Dungeon",
	Value = false,
	Callback = function(p24)
    t1.value14.AutoDungeon = p24
end
})
t3.Dungeon:Section({
	Title = "Dungeon Mode"
})
t1.value20.DungeonDifficulty = t3.Dungeon:Dropdown({
	Title = "Select Difficulty",
	Values = {
		"Easy",
		"Medium",
		"Hard",
		"Extreme"
	},
	Multi = false,
	Value = "Easy",
	Callback = function(p25)
    t1.value14.DungeonDifficulty = p25
end
})
t3.Dungeon:Section({
	Title = "Dungeon Farm"
})
t1.value20.AutoDungeonFarm = t3.Dungeon:Toggle({
	Title = "Auto Farm Dungeon Mobs",
	Value = false,
	Callback = function(p26)
    t1.value14.AutoDungeonFarm = p26
end
})
t1.value20.AutoReplay = t3.Dungeon:Toggle({
	Title = "Auto Replay Dungeon",
	Value = false,
	Callback = function(p27)
    t1.value14.AutoReplay = p27
end
})
t1.value20.AutoStatToggle = t3.Stats:Toggle({
	Title = "Enable Auto Stats",
	Value = false,
	Callback = function(p28)
    t1.value14.AutoStatToggle = p28
end
})
t1.value20.SelectedStats = t3.Stats:Dropdown({
	Title = "Select Stats to Upgrade",
	Values = {
		"Melee",
		"Defense",
		"Sword",
		"DevilFruit"
	},
	Multi = true,
	Value = {},
	Callback = function(p29)
    t1.value14.SelectedStats = p29
end
})
t3.Misc:Section({
	Title = "Merchant"
})
t1.value20.MerchantItem = t3.Misc:Dropdown({
	Title = "Select Merchant Item",
	Values = {
		"Boss Key",
		"Passive Shards",
		"Dungeon Key",
		"Rune Key",
		"Clan Reroll",
		"Race Reroll",
		"Trait Reroll",
		"Aura Crate",
		"Cosmetic Crate",
		"Secret Chest",
		"Mythical Chest",
		"Legendary Chest",
		"Epic Chest",
		"Rare Chest",
		"Common Chest"
	},
	Multi = true,
	Value = {},
	Callback = function(p30)
    t1.value14.MerchantItem = p30
end
})
t1.value20.AutoBuyMerchant = t3.Misc:Toggle({
	Title = "Auto Buy Merchant Item",
	Value = false,
	Callback = function(p31)
    t1.value14.AutoBuyMerchant = p31
end
})
t3.Misc:Section({
	Title = "Open Chest"
})
t1.value20.ChestSelect = t3.Misc:Dropdown({
	Title = "Select Chest",
	Values = {
		"Secret Chest",
		"Mythical Chest",
		"Legendary Chest",
		"Epic Chest",
		"Rare Chest",
		"Common Chest"
	},
	Multi = true,
	Value = {},
	Callback = function(p32)
    t1.value14.ChestSelect = p32
end
})
t1.value20.AutoOpenChest = t3.Misc:Toggle({
	Title = "Auto Open Chest",
	Value = false,
	Callback = function(p33)
    t1.value14.AutoOpenChest = p33
end
})
t3.Misc:Section({
	Title = "Performance"
})
t3.Misc:Button({
	Title = "Boost FPS",
	Callback = function()
    pcall(function()
        local Lighting = game:GetService("Lighting")

        Lighting.GlobalShadows = false
        Lighting.FogEnd = 9000000000

        local GetDescendants = Lighting.GetDescendants

        Lighting.Brightness = 1

        for _, v in pairs(GetDescendants(Lighting)) do
            local v230 = v:IsA("BlurEffect")

            if not v230 then
                v230 = v:IsA("SunRaysEffect")

                if not v230 then
                    v230 = v:IsA("ColorCorrectionEffect")

                    if not v230 then
                        v230 = v:IsA("BloomEffect")

                        if not v230 then
                            v230 = v:IsA("DepthOfFieldEffect")

                            if not v230 then
                                v230 = v:IsA("AtmosphereEffect")
                            end
                        end
                    end
                end
            end

            if v230 then
                v.Enabled = false
            end
        end

        local Terrain = workspace:FindFirstChildOfClass("Terrain")

        if Terrain then
            Terrain.WaterWaveSize = 0
            Terrain.WaterWaveSpeed = 0
            Terrain.WaterReflectance = 0
            Terrain.WaterTransparency = 0
            pcall(function()
                Terrain.Decoration = false
            end)
        end

        settings().Rendering.QualityLevel = Enum.QualityLevel.Level01

        for _, descendant in pairs(workspace:GetDescendants()) do
            local v234 = descendant:IsA("ParticleEmitter")

            if not v234 then
                v234 = descendant:IsA("Trail")

                if not v234 then
                    v234 = descendant:IsA("Smoke")

                    if not v234 then
                        v234 = descendant:IsA("Fire") or descendant:IsA("Sparkles")
                    end
                end
            end

            if v234 then
                descendant.Enabled = false
            else
                local v235 = descendant:IsA("Decal")

                if not v235 then
                    v235 = descendant:IsA("Texture")
                end

                if v235 then
                    descendant.Transparency = 1
                elseif descendant:IsA("MeshPart") or descendant:IsA("Part") then
                    descendant.Material = Enum.Material.SmoothPlastic
                    descendant.Reflectance = 0
                end
            end
        end
    end)
    t1.value1:Notify({
			Title = "⚡ Boost FPS",
			Content = "ปรับ FPS สำเร็จ! ลด Effects ทั้งหมดแล้ว",
			Duration = 4
		})
end
})
t3.Quest:Paragraph({
	Title = "Coming Soon",
	Desc = "Auto Quest features are currently in development."
})
t3.Misc:Section({
	Title = "Auto Buso Haki"
})
t1.value20.AutoBuso = t3.Misc:Toggle({
	Title = "Auto Buso Haki",
	Desc = "อัพเกรด Buso Haki อัตโนมัติ (ต้องมี Combat tool)",
	Value = false,
	Callback = function(p34)
    t1.value14.AutoBuso = p34
end
})
t1.value21 = {
	"WeaponSelect",
	"DistanceSlider",
	"AutofarmToggle",
	"AutoAttckToggle",
	"SkillSelect",
	"MovementMode",
	"FarmPosition",
	"Haki",
	"Observation",
	"AutoFarmMonTarget",
	"AutoFarmMonToggle",
	"AutoAllBoss",
	"AutoBoss",
	"SelectBoss",
	"AutoBrokenSword",
	"AutoCraftDivineGrail",
	"SummonBossSelect",
	"AutoSummonBoss",
	"SummonBossDifficulty",
	"DungeonSelect",
	"AutoDungeon",
	"DungeonDifficulty",
	"AutoDungeonFarm",
	"AutoReplay",
	"AutoStatToggle",
	"SelectedStats",
	"MerchantItem",
	"AutoBuyMerchant",
	"ChestSelect",
	"AutoOpenChest",
	"AutoBuso"
}
t1.value22 = {
	"AutofarmToggle",
	"AutoAttckToggle",
	"Haki",
	"Observation",
	"AutoFarmMonToggle",
	"AutoAllBoss",
	"AutoBoss",
	"AutoBrokenSword",
	"AutoCraftDivineGrail",
	"AutoSummonBoss",
	"AutoDungeon",
	"AutoDungeonFarm",
	"AutoReplay",
	"AutoStatToggle",
	"AutoBuyMerchant",
	"AutoOpenChest",
	"AutoBuso"
}
t1.value23 = {
	"WeaponDropdown",
	"AutoFarmMonTarget",
	"MovementMode",
	"FarmPosition",
	"SkillSelect",
	"SelectBoss",
	"SummonBossSelect",
	"SummonBossDifficulty",
	"DungeonSelect",
	"DungeonDifficulty",
	"SelectedStats",
	"MerchantItem",
	"ChestSelect"
}
t1.value24 = { "DistanceSlider" }
t1.value25 = {
	WeaponDropdown = "WeaponSelect"
}
local function v35(p35)
    return t1.value25[p35] or p35
end
t1.value26 = game:GetService("HttpService")
t1.value27 = "WindUI"
pcall(function()
    makefolder(t1.value27)
end)

function t1.value28(p36, p37)
    local v127 = t1.value27 .. "/" .. p36 .. ".json"
    local json = t1.value26:JSONEncode(p37)

    writefile(v127, json)
end
function t1.value29(p38)
    local v123 = t1.value27 .. "/" .. p38 .. ".json"

    if isfile(v123) then
        local v124 = readfile(v123)

        return t1.value26:JSONDecode(v124)
    end
end
function t1.value30()
    local t7 = {}
    pcall(function()
        for _, v in ipairs(listfiles(t1.value27)) do
            local v238 = v:match("([^/\\]+)%.json$")

            if v238 then
                table.insert(t7, v238)
            end
        end
    end)

    return t7
end
function t1.value31(p39)
    local t8 = {}

    for _, v in ipairs(t1.value21) do
        t8[v] = t1.value14[v]
    end

    t8._Theme = t1.value1:GetCurrentTheme()
    t8._Transparent = t1.value1:GetTransparency()
    t1.value28(p39, t8)
end
function t1.value32(p40)
    local v135 = t1.value29(p40)
    if not v135 then
        local value1_2 = t1.value1
        local v137 = "ไม่พบไฟล์: " .. tostring(p40)

        value1_2:Notify({
			Title = "Error",
			Content = v137,
			Duration = 4
		})

        return false
    end
    for v140, v141 in ipairs(t1.value21) do

        if v135[v141] ~= nil then
            t1.value14[v141] = v135[v141]
        end
    end
    for v144, v145 in ipairs(t1.value22) do

        local v146 = v145
        local v147 = t1.value20[v146]

        if v147 and t1.value14[v146] ~= nil then
            pcall(function()
                v147:SetValue(t1.value14[v146])
            end)
        end
    end
    for v150, v151 in ipairs(t1.value23) do

        local v152 = t1.value20[v151]
        local v153 = v35(v151)

        if v152 and t1.value14[v153] ~= nil then
            pcall(function()
                v152:Select(t1.value14[v153])
            end)
        end
    end
    for v156, v157 in ipairs(t1.value24) do

        local v158 = v157
        local v159 = t1.value20[v158]

        if v159 and t1.value14[v158] ~= nil then
            pcall(function()
                v159:SetValue(t1.value14[v158])
            end)
        end
    end
    if v135._Theme then
        pcall(function()
            t1.value1:SetTheme(v135._Theme)
        end)
    end
    if v135._Transparent ~= nil then
        pcall(function()
            t1.value2:ToggleTransparency(v135._Transparent)
        end)
    end
    local value1_3 = t1.value1
    local v161 = "โหลดโปรไฟล์: " .. tostring(p40) .. " สำเร็จ!"
    value1_3:Notify({
		Title = "✅ Loaded",
		Content = v161,
		Duration = 4
	})

    return true
end
function t1.value33()
    local LevelValue = t1.value3.Data.Level.Value

    if LevelValue >= 0 and LevelValue <= 99 then
        return "QuestNPC1", {
			"Thief1",
			"Thief2",
			"Thief3",
			"Thief4",
			"Thief15"
		}
    end

    if LevelValue >= 100 and LevelValue <= 249 then
        return "QuestNPC2", { "ThiefBoss" }
    end

    if LevelValue >= 250 and LevelValue <= 499 then
        return "QuestNPC3", {
			"Monkey1",
			"Monkey2",
			"Monkey3",
			"Monkey4",
			"Monkey5"
		}
    end

    if LevelValue >= 500 and LevelValue <= 749 then
        return "QuestNPC4", { "MonkeyBoss" }
    end

    if LevelValue >= 750 and LevelValue <= 1499 then
        return "QuestNPC5", {
			"DesertBandit1",
			"DesertBandit2",
			"DesertBandit3",
			"DesertBandit4",
			"DesertBandit5"
		}
    end

    if LevelValue >= 1500 and LevelValue <= 5499 then
        return "QuestNPC7", {
			"FrostRogue1",
			"FrostRogue2",
			"FrostRogue3",
			"FrostRogue4",
			"FrostRogue5"
		}
    end

    if LevelValue >= 5500 and LevelValue <= 6999 then
        return "QuestNPC11", {
			"Hollow1",
			"Hollow2",
			"Hollow3",
			"Hollow4",
			"Hollow5"
		}
    end

    if LevelValue >= 7000 and LevelValue <= 7999 then
        return "QuestNPC13", {
			"Curse1",
			"Curse2",
			"Curse3",
			"Curse4",
			"Curse5"
		}
    end

    if LevelValue >= 8000 and LevelValue <= 8999 then
        return "QuestNPC14", {
			"Slime1",
			"Slime2",
			"Slime3",
			"Slime4",
			"Slime5"
		}
    end

    if LevelValue >= 9000 and LevelValue <= 9999 then
        return "QuestNPC15", {
			"AcademyTeacher1",
			"AcademyTeacher2",
			"AcademyTeacher3",
			"AcademyTeacher4",
			"AcademyTeacher5"
		}
    end

    if LevelValue >= 10000 and LevelValue <= 10749 then
        return "QuestNPC16", {
			"Swordsman1",
			"Swordsman2",
			"Swordsman3",
			"Swordsman4",
			"Swordsman5"
		}
    end

    if LevelValue >= 10750 and LevelValue <= 11499 then
        return "QuestNPC17", {
			"Quincy1",
			"Quincy2",
			"Quincy3",
			"Quincy4",
			"Quincy5"
		}
    end

    if LevelValue >= 11500 and LevelValue <= 11999 then
        return "QuestNPC18", {
			"Ninja1",
			"Ninja2",
			"Ninja3",
			"Ninja4",
			"Ninja5"
		}
    end

    if LevelValue >= 12000 then
        return "QuestNPC19", {
			"ArenaFighter1",
			"ArenaFighter2",
			"ArenaFighter3",
			"ArenaFighter4",
			"ArenaFighter5"
		}
    end

    return nil, nil
end
function t1.value34(p41)
    if not p41 then
        return nil
    end
    local NPCs = workspace:FindFirstChild("NPCs")
    if not NPCs then
        return nil
    end
    local v116
    for _, v in pairs(p41) do
        local v3 = NPCs:FindFirstChild(v)
        local v120 = v3

        if v3 then
            v120 = v3:FindFirstChild("Humanoid")

            if v120 then
                v120 = v3.Humanoid.Health > 0 and v3:FindFirstChild("HumanoidRootPart")
            end
        end

        if not v120 then
            continue
        end

        if v3.Humanoid.Health >= v3.Humanoid.MaxHealth then
            return v3
        end

        if not v116 then
            v116 = v3
        end
    end

    return v116
end
function t1.value35(p42)
    local NPCs = workspace:FindFirstChild("NPCs")

    if not NPCs then
        return nil
    end

    local p42_2 = NPCs:FindFirstChild(p42)
    local v107 = p42_2

    if p42_2 then
        v107 = p42_2:FindFirstChild("Humanoid")

        if v107 then
            v107 = p42_2.Humanoid.Health > 0

            if v107 then
                v107 = p42_2:FindFirstChild("HumanoidRootPart")
            end
        end
    end

    if v107 then
        return p42_2
    end

    return nil
end
function t1.value36(p43)
    local v109 = not p43

    if not v109 then
        v109 = p43 == "None"

        if not v109 then
            v109 = not t1.value3.Character

            if not v109 then
                v109 = not t1.value3.Character:FindFirstChild("Humanoid")
            end
        end
    end

    if v109 then
        return
    end

    local p43_2 = t1.value3.Character:FindFirstChild(p43)

    if p43_2 then
        p43_2 = t1.value3.Character[p43]:IsA("Tool")
    end

    if p43_2 then
        return
    end

    local Humanoid = t1.value3.Character:FindFirstChild("Humanoid")
    local p43_3 = t1.value3.Backpack:FindFirstChild(p43)

    if p43_3 and (p43_3:IsA("Tool") and Humanoid) then
        Humanoid:EquipTool(p43_3)
    end
end
t1.value37 = nil
t1.value38 = nil
t1.value39 = nil
t1.value40 = nil
t1.value41 = nil
game:GetService("RunService").Stepped:Connect(function()
    local AutofarmToggle = t1.value14.AutofarmToggle
    if not AutofarmToggle then
        AutofarmToggle = t1.value14.AutoAllBoss

        if not AutofarmToggle then
            AutofarmToggle = t1.value14.AutoBoss

            if not AutofarmToggle then
                AutofarmToggle = t1.value14.AutoDungeonFarm

                if not AutofarmToggle then
                    AutofarmToggle = t1.value14.AutoSummonBoss

                    if not AutofarmToggle then
                        AutofarmToggle = t1.value14.AutoBrokenSword

                        if not AutofarmToggle then
                            AutofarmToggle = t1.value14.AutoFarmMonToggle
                        end
                    end
                end
            end
        end
    end
    for v165, v166 in ipairs(t1.value13) do

        if t1.value14["Auto" .. v166] then
            AutofarmToggle = true
        end
    end
    if AutofarmToggle then
        AutofarmToggle = t1.value3.Character
    end
    if AutofarmToggle then

        for v169, v170 in pairs(t1.value3.Character:GetDescendants()) do

            if v170:IsA("BasePart") then
                v170.CanCollide = false
            end
        end
        local HumanoidRootPart = t1.value3.Character:FindFirstChild("HumanoidRootPart")
        if HumanoidRootPart and not HumanoidRootPart:FindFirstChild("BodyClip") then
            local BodyVelocity = Instance.new("BodyVelocity")

            BodyVelocity.Name = "BodyClip"
            BodyVelocity.Parent = HumanoidRootPart
            BodyVelocity.MaxForce = Vector3.new(100000, 100000, 100000)
            BodyVelocity.Velocity = Vector3.new(0, 0, 0)
        end
    elseif t1.value3.Character then
        local HumanoidRootPart = t1.value3.Character:FindFirstChild("HumanoidRootPart")
        local v174 = HumanoidRootPart

        if HumanoidRootPart then
            v174 = HumanoidRootPart:FindFirstChild("BodyClip")
        end

        if v174 then
            HumanoidRootPart.BodyClip:Destroy()
        end
    end
    if t1.value14.MovementMode ~= "Tween" then
        local value37 = t1.value37

        if value37 then
            value37 = t1.value3.Character

            if value37 then
                value37 = t1.value3.Character:FindFirstChild("HumanoidRootPart")
            end
        end

        if value37 then
            pcall(function()
                local HumanoidRootPart = t1.value37:FindFirstChild("HumanoidRootPart")

                if HumanoidRootPart then
                    HumanoidRootPart = t1.value37:FindFirstChild("Humanoid")

                    if HumanoidRootPart then
                        HumanoidRootPart = t1.value37.Humanoid.Health > 0
                    end
                end

                if HumanoidRootPart then
                    local HumanoidRootPart2 = t1.value3.Character.HumanoidRootPart
                    local v241 = t1.value14.DistanceSlider or 8

                    HumanoidRootPart2.CFrame = t1.value37.HumanoidRootPart.CFrame * t1.value17(v241)
                    HumanoidRootPart2.Velocity = Vector3.new(0, 0, 0)
                end
            end)
        end

        local value38 = t1.value38

        if value38 then
            value38 = t1.value3.Character

            if value38 then
                value38 = t1.value3.Character:FindFirstChild("HumanoidRootPart")
            end
        end

        if value38 then
            pcall(function()
                local HumanoidRootPart = t1.value38:FindFirstChild("HumanoidRootPart")

                if HumanoidRootPart then
                    HumanoidRootPart = t1.value38:FindFirstChild("Humanoid")

                    if HumanoidRootPart then
                        HumanoidRootPart = t1.value38.Humanoid.Health > 0
                    end
                end

                if HumanoidRootPart then
                    local HumanoidRootPart3 = t1.value3.Character.HumanoidRootPart
                    local v244 = t1.value14.DistanceSlider or 8

                    HumanoidRootPart3.CFrame = t1.value38.HumanoidRootPart.CFrame * t1.value17(v244)
                    HumanoidRootPart3.Velocity = Vector3.new(0, 0, 0)
                end
            end)
        end

        local value39 = t1.value39

        if value39 then
            value39 = t1.value3.Character

            if value39 then
                value39 = t1.value3.Character:FindFirstChild("HumanoidRootPart")
            end
        end

        if value39 then
            pcall(function()
                local HumanoidRootPart = t1.value39:FindFirstChild("HumanoidRootPart")

                if HumanoidRootPart then
                    HumanoidRootPart = t1.value39:FindFirstChild("Humanoid")

                    if HumanoidRootPart then
                        HumanoidRootPart = t1.value39.Humanoid.Health > 0
                    end
                end

                if HumanoidRootPart then
                    local HumanoidRootPart4 = t1.value3.Character.HumanoidRootPart
                    local v247 = t1.value14.DistanceSlider or 8

                    HumanoidRootPart4.CFrame = t1.value39.HumanoidRootPart.CFrame * t1.value17(v247)
                    HumanoidRootPart4.Velocity = Vector3.new(0, 0, 0)
                end
            end)
        end

        local value40 = t1.value40

        if value40 then
            value40 = t1.value3.Character

            if value40 then
                value40 = t1.value3.Character:FindFirstChild("HumanoidRootPart")
            end
        end

        if value40 then
            pcall(function()
                local HumanoidRootPart = t1.value40:FindFirstChild("HumanoidRootPart")

                if HumanoidRootPart then
                    HumanoidRootPart = t1.value40:FindFirstChild("Humanoid")

                    if HumanoidRootPart then
                        HumanoidRootPart = t1.value40.Humanoid.Health > 0
                    end
                end

                if HumanoidRootPart then
                    local HumanoidRootPart5 = t1.value3.Character.HumanoidRootPart
                    local v250 = t1.value14.DistanceSlider or 8

                    HumanoidRootPart5.CFrame = t1.value40.HumanoidRootPart.CFrame * t1.value17(v250)
                    HumanoidRootPart5.Velocity = Vector3.new(0, 0, 0)
                end
            end)
        end

        local value41 = t1.value41

        if value41 then
            value41 = t1.value3.Character

            if value41 then
                value41 = t1.value3.Character:FindFirstChild("HumanoidRootPart")
            end
        end

        if value41 then
            pcall(function()
                local HumanoidRootPart = t1.value41:FindFirstChild("HumanoidRootPart")

                if HumanoidRootPart then
                    HumanoidRootPart = t1.value41:FindFirstChild("Humanoid")

                    if HumanoidRootPart then
                        HumanoidRootPart = t1.value41.Humanoid.Health > 0
                    end
                end

                if HumanoidRootPart then
                    local HumanoidRootPart6 = t1.value3.Character.HumanoidRootPart
                    local v253 = t1.value14.DistanceSlider or 8

                    HumanoidRootPart6.CFrame = t1.value41.HumanoidRootPart.CFrame * t1.value17(v253)
                    HumanoidRootPart6.Velocity = Vector3.new(0, 0, 0)
                end
            end)
        end
    end
end)
t1.value42 = {}
task.spawn(function()
    while task.wait() do
        pcall(function()
            local v254 = false
            local v255
            local s1 = ""
            local v257 = (function()
                if t1.value14.AutoAllBoss then
                    return t1.value13
                end

                local AutoBoss = t1.value14.AutoBoss

                if AutoBoss then
                    AutoBoss = type(t1.value14.SelectBoss) == "table"

                    if AutoBoss then
                        AutoBoss = #t1.value14.SelectBoss > 0
                    end
                end

                if AutoBoss then
                    return t1.value14.SelectBoss
                end

                local t9 = {}

                for _, v in ipairs(t1.value13) do
                    if t1.value14["Auto" .. v] then
                        table.insert(t9, v)
                    end
                end

                return t9
            end)()
            local v258 = false
            if #v257 > 0 then
                for _, v in ipairs(v257) do
                    local v261 = t1.value35(v)

                    if v261 then
                        v254 = true
                        v255 = v261
                        s1 = t1.value12[v] or ""
                        t1.value42[v] = 0

                        break
                    end

                    if not (tick() - (t1.value42[v] or 0) > 30) then
                        continue
                    end

                    local v262 = t1.value12[v] or ""

                    if v262 == "" then
                        continue
                    end

                    if v262 ~= t1.value11 then
                        local v263 = v262

                        if v262 then
                            v263 = v262 ~= "" and v262 ~= t1.value11
                        end

                        if v263 then
                            t1.value9:FireServer(v262)
                            t1.value11 = v262
                            task.wait(1.5)
                        end

                        v258 = true

                        break
                    end

                    t1.value42[v] = tick()
                end
            end
            if v258 then
                task.wait(1)

                return
            end
            if v254 and v255 then
                if s1 ~= "" and s1 ~= t1.value11 then
                    local v264 = s1

                    if s1 then
                        v264 = s1 ~= "" and s1 ~= t1.value11
                    end

                    if v264 then
                        t1.value9:FireServer(s1)
                        t1.value11 = s1
                        task.wait(1.5)
                    end
                end

                t1.value37 = v255
                t1.value38 = nil

                local Character = t1.value3.Character

                if Character then
                    Character = t1.value3.Character:FindFirstChild("HumanoidRootPart")
                end

                if Character then
                    t1.value36(t1.value14.WeaponSelect)
                    task.spawn(function()
                        for k, v in pairs(t1.value14.SkillSelect) do
                            local v358 = v == true and tostring(k) or tostring(v)
                            local v359 = v358

                            if v358 then
                                v359 = Enum.KeyCode[v358]
                            end

                            if v359 then
                                t1.value5:SendKeyEvent(true, Enum.KeyCode[v358], false, game)
                                task.wait(0.01)
                                t1.value5:SendKeyEvent(false, Enum.KeyCode[v358], false, game)
                            end
                        end
                    end)

                    return
                end
            else
                local AutoFarmMonToggle = t1.value14.AutoFarmMonToggle

                if not AutoFarmMonToggle then
                    AutoFarmMonToggle = t1.value14.AutofarmToggle
                end

                if AutoFarmMonToggle then
                    t1.value37 = nil
                    local s2 = ""
                    local u268
                    local t10 = {}
                    local u283
                    if t1.value14.AutoFarmMonToggle then
                        local t11 = {}
                        local v271 = type(t1.value14.AutoFarmMonTarget) == "string"
                        if v271 then
                            v271 = t1.value14.AutoFarmMonTarget ~= ""
                        end
                        if v271 then
                            table.insert(t11, t1.value14.AutoFarmMonTarget)
                        elseif type(t1.value14.AutoFarmMonTarget) == "table" then
                            for k, v in pairs(t1.value14.AutoFarmMonTarget) do
                                local v274 = k

                                if v == true then
                                    table.insert(t11, v274)
                                end

                                local v275 = type(v274) == "number"

                                if v275 then
                                    v275 = type(v) == "string"
                                end

                                if v275 then
                                    table.insert(t11, v)
                                end
                            end
                        end
                        for v278, v279 in ipairs(t11) do

                            local v280 = t1.value16[v279]

                            if v280 then
                                for _, v in ipairs(v280) do
                                    table.insert(t10, v)
                                end
                            else
                                table.insert(t10, v279)
                            end
                        end
                        u283 = t1.value34(t10)
                        if u283 then
                            s2 = t1.value15[u283.Name] or ""
                        elseif #t10 > 0 then
                            local v284 = false

                            if type(t1.value14.AutoFarmMonTarget) == "table" then
                                for k, v in pairs(t1.value14.AutoFarmMonTarget) do
                                    local v287 = v == true and k

                                    if not v287 then
                                        v287 = type(v) == "string" and v or nil
                                    end

                                    if not v287 then
                                        continue
                                    end

                                    local v288 = t1.value15[v287] or ""

                                    if v288 ~= "" and v288 ~= t1.value11 then
                                        s2 = v288
                                        v284 = true

                                        break
                                    end
                                end
                            end

                            if not v284 then
                                s2 = t1.value15[t10[1]] or ""
                            end
                        end
                    else
                        local LevelValue = t1.value3.Data.Level.Value
                        local v290, v291 = t1.value33()

                        u268 = v290
                        t10 = v291
                        u283 = t1.value34(t10)
                        s2 = LevelValue >= 12000 and "Lawless"

                        if not s2 then
                            s2 = LevelValue >= 11500 and "Ninja"

                            if not s2 then
                                s2 = LevelValue >= 10750 and "SoulSociety"

                                if not s2 then
                                    s2 = LevelValue >= 10000 and "Judgement"

                                    if not s2 then
                                        s2 = LevelValue >= 9000 and "Academy"

                                        if not s2 then
                                            s2 = LevelValue >= 8000 and "Slime"

                                            if not s2 then
                                                s2 = LevelValue >= 7000 and "Shinjuku"

                                                if not s2 then
                                                    s2 = LevelValue >= 5500 and "HuecoMundo"

                                                    if not s2 then
                                                        s2 = LevelValue >= 1500 and "Snow"

                                                        if not s2 then
                                                            s2 = LevelValue >= 750 and "Desert"

                                                            if not s2 then
                                                                s2 = not (LevelValue >= 250) and "" or "Jungle"
                                                            end
                                                        end
                                                    end
                                                end
                                            end
                                        end
                                    end
                                end
                            end
                        end
                    end
                    if s2 ~= "" then
                        local v292 = s2

                        if s2 then
                            v292 = s2 ~= "" and s2 ~= t1.value11
                        end

                        if v292 then
                            t1.value9:FireServer(s2)
                            t1.value11 = s2
                            task.wait(1.5)
                        end
                    end
                    t1.value36(t1.value14.WeaponSelect)
                    if not u283 then
                        t1.value11 = ""

                        if s2 ~= "" then
                            local v293 = s2

                            if s2 then
                                v293 = s2 ~= "" and s2 ~= t1.value11
                            end

                            if v293 then
                                t1.value9:FireServer(s2)
                                t1.value11 = s2
                                task.wait(1.5)
                            end
                        end
                    end
                    local v294 = u283
                    if v294 then
                        v294 = t1.value3.Character

                        if v294 then
                            v294 = t1.value3.Character:FindFirstChild("HumanoidRootPart")
                        end
                    end
                    if v294 then
                        t1.value38 = u283

                        local HumanoidRootPart = t1.value3.Character.HumanoidRootPart
                        local v296 = t1.value14.DistanceSlider or 8

                        task.spawn(function()
                            pcall(function()
                                t1.value18(HumanoidRootPart, u283.HumanoidRootPart.CFrame * t1.value17(v296))
                            end)
                        end)

                        if t1.value14.AutoFarmMonToggle then
                            task.spawn(function()
                                pcall(function()
                                    local HumanoidRootPartPosition = u283.HumanoidRootPart.Position

                                    for _, child in pairs(workspace.NPCs:GetChildren()) do
                                        local v373 = child ~= u283

                                        if v373 then
                                            v373 = table.find(t10, child.Name)

                                            if v373 then
                                                v373 = child:FindFirstChild("Humanoid")

                                                if v373 then
                                                    v373 = child.Humanoid.Health > 0
                                                end
                                            end
                                        end

                                        if v373 and child.Humanoid.Health == child.Humanoid.MaxHealth then
                                            local HumanoidRootPart7 = child:FindFirstChild("HumanoidRootPart")

                                            if HumanoidRootPart7 and (HumanoidRootPart7.Position - HumanoidRootPartPosition).Magnitude <= 800 then
                                                t1.value38 = child

                                                local value18 = t1.value18
                                                local v376 = HumanoidRootPart
                                                local HumanoidRootPart7CFrame = HumanoidRootPart7.CFrame
                                                local v378 = v296

                                                value18(v376, HumanoidRootPart7CFrame * t1.value17(v378))
                                                task.spawn(function()
                                                    pcall(function()
                                                        for k, v in pairs(t1.value14.SkillSelect) do
                                                            local v395 = v == true

                                                            if v395 then
                                                                v395 = tostring(k)
                                                            end

                                                            local v396 = v395 or tostring(v)
                                                            local v397 = v396

                                                            if v396 then
                                                                v397 = Enum.KeyCode[v396]
                                                            end

                                                            if v397 then
                                                                t1.value5:SendKeyEvent(true, Enum.KeyCode[v396], false, game)
                                                                task.wait(0.01)
                                                                t1.value5:SendKeyEvent(false, Enum.KeyCode[v396], false, game)
                                                            end
                                                        end
                                                    end)
                                                end)
                                                task.wait(0.15)
                                            end
                                        end
                                    end

                                    t1.value38 = u283
                                end)
                            end)
                        end

                        task.spawn(function()
                            for k, v in pairs(t1.value14.SkillSelect) do
                                local v362 = v == true and tostring(k) or tostring(v)
                                local v363 = v362

                                if v362 then
                                    v363 = Enum.KeyCode[v362]
                                end

                                if v363 then
                                    t1.value5:SendKeyEvent(true, Enum.KeyCode[v362], false, game)
                                    task.wait(0.01)
                                    t1.value5:SendKeyEvent(false, Enum.KeyCode[v362], false, game)
                                end
                            end
                        end)

                        local QuestUI = t1.value3.PlayerGui:FindFirstChild("QuestUI")

                        if QuestUI then
                            QuestUI = QuestUI.Quest.Visible == false

                            if QuestUI then
                                QuestUI = tick() - t1.value10 > 3 and u268
                            end
                        end

                        if QuestUI then
                            pcall(function()
                                t1.value8:FireServer(u268)
                            end)
                            t1.value10 = tick()
                        end
                    else
                        t1.value38 = nil
                    end

                    return
                end

                t1.value38 = nil
            end
        end)
    end
end)
t1.value43 = game:GetService("ReplicatedStorage"):WaitForChild("Remotes"):WaitForChild("RequestDungeonPortal")
t1.value44 = game:GetService("ReplicatedStorage"):WaitForChild("Remotes"):WaitForChild("DungeonWaveVote")
t1.value45 = game:GetService("ReplicatedStorage"):WaitForChild("Remotes"):WaitForChild("DungeonWaveReplayVote")
task.spawn(function()
    while task.wait(2) do
        pcall(function()
            local AutoDungeon = t1.value14.AutoDungeon

            if AutoDungeon then
                AutoDungeon = t1.value14.DungeonSelect

                if AutoDungeon then
                    AutoDungeon = t1.value14.DungeonSelect ~= ""
                end
            end

            if AutoDungeon then
                t1.value43:FireServer(t1.value14.DungeonSelect)
            end

            local AutoDungeon2 = t1.value14.AutoDungeon

            if AutoDungeon2 then
                AutoDungeon2 = t1.value14.DungeonDifficulty
            end

            if AutoDungeon2 then
                t1.value44:FireServer(t1.value14.DungeonDifficulty)
            end

            if t1.value14.AutoReplay then
                t1.value45:FireServer("sponsor")
            end
        end)
    end
end)
task.spawn(function()
    while task.wait() do
        pcall(function()
            local AutoDungeonFarm = t1.value14.AutoDungeonFarm
            local g308
            if AutoDungeonFarm then
                AutoDungeonFarm = t1.value3.Character

                if AutoDungeonFarm then
                    AutoDungeonFarm = t1.value3.Character:FindFirstChild("HumanoidRootPart")
                end
            end
            if AutoDungeonFarm then
                local NPCs = workspace:FindFirstChild("NPCs")
                if not NPCs then
                    t1.value39 = nil

                    return
                end
                local u302
                local GetChildren = NPCs.GetChildren
                local v304, v305, v306 = pairs(GetChildren(NPCs))
                local v307
                repeat
                    v306, v307 = v304(v305, v306)

                    if not v306 then
                        g308 = true
                    end

                    if g308 then
                        break
                    end

                    local Humanoid = v307:FindFirstChild("Humanoid")

                    if Humanoid then
                        Humanoid = v307.Humanoid.Health > 0 and v307:FindFirstChild("HumanoidRootPart")
                    end
                until Humanoid
                if not g308 then
                    u302 = v307
                end
                if u302 then
                    t1.value39 = u302
                    t1.value36(t1.value14.WeaponSelect)

                    local HumanoidRootPart = t1.value3.Character.HumanoidRootPart
                    local v311 = t1.value14.DistanceSlider or 8

                    task.spawn(function()
                        pcall(function()
                            t1.value18(HumanoidRootPart, u302.HumanoidRootPart.CFrame * t1.value17(v311))
                        end)
                    end)
                    task.spawn(function()
                        pcall(function()
                            for k, v in pairs(t1.value14.SkillSelect) do
                                local v381 = v == true and tostring(k) or tostring(v)
                                local v382 = v381

                                if v381 then
                                    v382 = Enum.KeyCode[v381]
                                end

                                if v382 then
                                    t1.value5:SendKeyEvent(true, Enum.KeyCode[v381], false, game)
                                    task.wait(0.01)
                                    t1.value5:SendKeyEvent(false, Enum.KeyCode[v381], false, game)
                                end
                            end
                        end)
                    end)
                else
                    t1.value39 = nil
                end

                return
            end
            t1.value39 = nil
        end)
    end
end)
t1.value46 = game:GetService("ReplicatedStorage"):WaitForChild("Remotes"):WaitForChild("RequestSummonBoss")
t1.value47 = false
t1.value48 = 0
task.spawn(function()
    while task.wait() do
        local AutoSummonBoss = t1.value14.AutoSummonBoss

        if AutoSummonBoss then
            AutoSummonBoss = t1.value14.SummonBossSelect

            if AutoSummonBoss then
                AutoSummonBoss = t1.value14.SummonBossSelect ~= ""
            end
        end

        if not AutoSummonBoss then
            t1.value40 = nil
            t1.value47 = false
        else
            local NPCs = workspace:FindFirstChild("NPCs")

            if NPCs then
                local SummonBossSelect = t1.value14.SummonBossSelect
                local v183 = t1.value14.SummonBossSelect == "Gilgamesh"

                if not v183 then
                    v183 = t1.value14.SummonBossSelect == "Blessed Maiden"

                    if not v183 then
                        v183 = t1.value14.SummonBossSelect == "Saber Alter"
                    end
                end

                if v183 then
                    SummonBossSelect = t1.value14.SummonBossSelect .. "Boss"
                end

                local function v184()
                    local SummonBossSelect2 = NPCs:FindFirstChild(SummonBossSelect)
                    local v313 = SummonBossSelect2

                    if SummonBossSelect2 then
                        v313 = SummonBossSelect2:FindFirstChild("Humanoid")

                        if v313 then
                            v313 = SummonBossSelect2.Humanoid.Health > 0

                            if v313 then
                                v313 = SummonBossSelect2:FindFirstChild("HumanoidRootPart")
                            end
                        end
                    end

                    if v313 then
                        return SummonBossSelect2
                    end

                    local t1value14SummonBossSelect = NPCs:FindFirstChild(t1.value14.SummonBossSelect)
                    local v315 = t1value14SummonBossSelect

                    if t1value14SummonBossSelect then
                        v315 = t1value14SummonBossSelect:FindFirstChild("Humanoid")

                        if v315 then
                            v315 = t1value14SummonBossSelect.Humanoid.Health > 0

                            if v315 then
                                v315 = t1value14SummonBossSelect:FindFirstChild("HumanoidRootPart")
                            end
                        end
                    end

                    if v315 then
                        return t1value14SummonBossSelect
                    end

                    for _, child in pairs(NPCs:GetChildren()) do
                        local Humanoid = child:FindFirstChild("Humanoid")

                        if Humanoid then
                            Humanoid = child.Humanoid.Health > 0 and child:FindFirstChild("HumanoidRootPart")
                        end

                        if Humanoid and string.find(child.Name, t1.value14.SummonBossSelect) then
                            return child
                        end
                    end

                    return nil
                end

                local u185 = v184()

                if u185 ~= nil then
                    t1.value47 = true
                    t1.value40 = u185
                    task.spawn(function()
                        pcall(function()
                            local HumanoidRootPart = t1.value3.Character.HumanoidRootPart
                            local v365 = t1.value14.DistanceSlider or 8

                            t1.value18(HumanoidRootPart, u185.HumanoidRootPart.CFrame * t1.value17(v365))
                        end)
                    end)
                    pcall(function()
                        t1.value36(t1.value14.WeaponSelect)
                    end)
                    task.spawn(function()
                        pcall(function()
                            for k, v in pairs(t1.value14.SkillSelect) do
                                local v368 = v == true and tostring(k) or tostring(v)
                                local v369 = v368

                                if v368 then
                                    v369 = Enum.KeyCode[v368]
                                end

                                if v369 then
                                    t1.value5:SendKeyEvent(true, Enum.KeyCode[v368], false, game)
                                    task.wait(0.01)
                                    t1.value5:SendKeyEvent(false, Enum.KeyCode[v368], false, game)
                                end
                            end
                        end)
                    end)
                else
                    t1.value40 = nil

                    if tick() - t1.value48 > 10 then
                        t1.value47 = true

                        if t1.value11 ~= "Boss" then
                            if t1.value11 ~= "Boss" then
                                t1.value9:FireServer("Boss")
                                t1.value11 = "Boss"
                                task.wait(1.5)
                            end

                            task.wait(1.5)
                        end

                        u185 = v184()

                        if not u185 then
                            pcall(function()
                                local v319 = t1.value14.SummonBossSelect == "Gilgamesh"

                                if not v319 then
                                    v319 = t1.value14.SummonBossSelect == "Blessed Maiden"

                                    if not v319 then
                                        v319 = t1.value14.SummonBossSelect == "Saber Alter"
                                    end
                                end

                                if v319 then
                                    t1.value46:FireServer(SummonBossSelect, t1.value14.SummonBossDifficulty)

                                    return
                                end

                                t1.value46:FireServer(t1.value14.SummonBossSelect)
                            end)

                            for _ = 1, 5 do
                                task.wait(0.1)
                                u185 = v184()

                                if u185 then
                                    break
                                end
                            end
                        end

                        if u185 then
                            t1.value40 = u185
                        else
                            t1.value48 = tick()
                            t1.value47 = false
                        end
                    else
                        t1.value47 = false
                    end
                end
            end
        end
    end
end)
task.spawn(function()
    while task.wait() do
        pcall(function()
            local AutoBrokenSword = t1.value14.AutoBrokenSword

            if AutoBrokenSword then
                AutoBrokenSword = not t1.value47

                if AutoBrokenSword then
                    AutoBrokenSword = t1.value3.Character

                    if AutoBrokenSword then
                        AutoBrokenSword = t1.value3.Character:FindFirstChild("HumanoidRootPart")
                    end
                end
            end

            if AutoBrokenSword then
                local NPCs = workspace:FindFirstChild("NPCs")

                if not NPCs then
                    return
                end

                if t1.value11 ~= "Slime" and t1.value11 ~= "Slime" then
                    t1.value9:FireServer("Slime")
                    t1.value11 = "Slime"
                    task.wait(1.5)
                end

                local t12 = {
					"Slime1",
					"Slime2",
					"Slime3",
					"Slime4",
					"Slime5"
				}
                local v323 = t1.value34(t12)

                if v323 then
                    t1.value41 = v323

                    local HumanoidRootPart = t1.value3.Character.HumanoidRootPart
                    local v325 = t1.value14.DistanceSlider or 8

                    task.spawn(function()
                        pcall(function()
                            t1.value18(HumanoidRootPart, v323.HumanoidRootPart.CFrame * t1.value17(v325))
                        end)
                    end)
                    task.spawn(function()
                        pcall(function()
                            for _, child in pairs(NPCs:GetChildren()) do
                                local v385 = child
                                local v386 = table.find(t12, v385.Name)

                                if v386 then
                                    v386 = v385:FindFirstChild("Humanoid")

                                    if v386 then
                                        v386 = v385.Humanoid.Health > 0
                                    end
                                end

                                if v386 and v385.Humanoid.Health == v385.Humanoid.MaxHealth then
                                    local HumanoidRootPart8 = v385:FindFirstChild("HumanoidRootPart")
                                    local v388 = HumanoidRootPart8

                                    if HumanoidRootPart8 then
                                        v388 = v323

                                        if v388 then
                                            v388 = v323:FindFirstChild("HumanoidRootPart")
                                        end
                                    end

                                    if v388 and (HumanoidRootPart8.Position - v323.HumanoidRootPart.Position).Magnitude <= 800 then
                                        HumanoidRootPart8.CFrame = v323.HumanoidRootPart.CFrame
                                        HumanoidRootPart8.Velocity = Vector3.new(0, 0, 0)
                                        pcall(function()
                                            if v385.Humanoid.PlatformStand == false then
                                                v385.Humanoid.PlatformStand = true
                                            end
                                        end)
                                    end
                                end
                            end
                        end)
                    end)
                    t1.value36(t1.value14.WeaponSelect)
                    task.spawn(function()
                        pcall(function()
                            for k, v in pairs(t1.value14.SkillSelect) do
                                local v391 = v == true and tostring(k) or tostring(v)
                                local v392 = v391

                                if v391 then
                                    v392 = Enum.KeyCode[v391]
                                end

                                if v392 then
                                    t1.value5:SendKeyEvent(true, Enum.KeyCode[v391], false, game)
                                    task.wait(0.01)
                                    t1.value5:SendKeyEvent(false, Enum.KeyCode[v391], false, game)
                                end
                            end
                        end)
                    end)

                    return
                end

                t1.value41 = nil
                t1.value11 = ""
                task.wait(1)

                return
            end

            t1.value41 = nil
        end)
    end
end)
task.spawn(function()
    local s3
    while task.wait() do
        if t1.value14.AutoBuso then
            local v188 = not t1.value3.Character

            if not v188 then
                v188 = not t1.value3.Character.Parent
            end

            if v188 then
                t1.value3.CharacterAdded:Wait()
            end

            local HumanoidRootPart = t1.value3.Character:WaitForChild("HumanoidRootPart")

            pcall(function()
                return t1.value3:WaitForChild("PlayerGui"):WaitForChild("QuestUI"):WaitForChild("Quest")
            end)

            local ok, result = pcall(function()
                return t1.value3.PlayerGui:WaitForChild("QuestUI"):WaitForChild("Quest")
            end)
            local v192 = result

            if ok then
                local success, result = pcall(function()
                    return v192:WaitForChild("Quest"):WaitForChild("Holder"):WaitForChild("Content"):WaitForChild("QuestInfo"):WaitForChild("QuestDescription")
                end)
                if success then
                    local v195 = result.Text or ""
                    local v196 = string.find(v195, "Kill 150")

                    if not v196 then
                        v196 = string.find(v195, "Use Z")

                        if not v196 then
                            v196 = string.find(v195, "Punch 750")
                        end
                    end

                    if v192.Visible and not v196 then
                        pcall(function()
                            game:GetService("ReplicatedStorage"):WaitForChild("RemoteEvents"):WaitForChild("QuestAbandon"):FireServer()
                        end)
                        task.wait(0.5)
                    elseif not v192.Visible then
                        pcall(function()
                            game:GetService("ReplicatedStorage"):WaitForChild("RemoteEvents"):WaitForChild("QuestAccept"):FireServer("HakiQuestNPC")
                        end)
                        task.wait(1)
                    else
                        if string.find(v195, "Kill 150") then
                            pcall(function()
                                local g333
                                if s3 ~= "" then
                                    game:GetService("ReplicatedStorage"):WaitForChild("Remotes"):WaitForChild("TeleportToPortal"):FireServer("Starter")
                                    s3 = "Starter"
                                    task.wait(2)
                                end
                                local NPCs = workspace:WaitForChild("NPCs")
                                local v327
                                local GetChildren = NPCs.GetChildren
                                local v329, v330, v331 = pairs(GetChildren(NPCs))
                                local v332
                                repeat
                                    v331, v332 = v329(v330, v331)

                                    if not v331 then
                                        g333 = true
                                    end

                                    if g333 then
                                        break
                                    end

                                    local v334 = v332.Name ~= "TrainingDummy"

                                    if v334 then
                                        v334 = v332:FindFirstChild("Humanoid")

                                        if v334 then
                                            v334 = v332.Humanoid.Health > 0 and v332:FindFirstChild("HumanoidRootPart")
                                        end
                                    end
                                until v334
                                if not g333 then
                                    v327 = v332
                                end
                                if v327 then
                                    HumanoidRootPart.CFrame = v327.HumanoidRootPart.CFrame * CFrame.new(0, 0, 5)
                                    game:GetService("ReplicatedStorage"):WaitForChild("CombatSystem"):WaitForChild("Remotes"):WaitForChild("RequestHit"):FireServer()
                                end
                            end)
                        end

                        if string.find(v195, "Use Z") then
                            pcall(function()
                                game:GetService("ReplicatedStorage"):WaitForChild("AbilitySystem"):WaitForChild("Remotes"):WaitForChild("RequestAbility"):FireServer(1)
                            end)
                            task.wait(0.2)
                        end

                        if string.find(v195, "Punch 750") then
                            pcall(function()
                                game:GetService("ReplicatedStorage"):WaitForChild("CombatSystem"):WaitForChild("Remotes"):WaitForChild("RequestHit"):FireServer()
                            end)
                            task.wait(0.05)
                        end

                        if not v192.Visible then
                            pcall(function()
                                game:GetService("ReplicatedStorage"):WaitForChild("Remotes"):WaitForChild("TeleportToPortal"):FireServer("Snow")
                                task.wait(2)

                                local HakiQuestNPC = workspace:WaitForChild("ServiceNPCs"):FindFirstChild("HakiQuestNPC")

                                if HakiQuestNPC and HakiQuestNPC:FindFirstChild("HumanoidRootPart") then
                                    HumanoidRootPart.CFrame = HakiQuestNPC.HumanoidRootPart.CFrame
                                    task.wait(0.2)

                                    local ProximityPrompt = HakiQuestNPC.HumanoidRootPart:FindFirstChildOfClass("ProximityPrompt")

                                    if ProximityPrompt then
                                        fireproximityprompt(ProximityPrompt)
                                    end
                                end
                            end)
                            t1.value14.AutoBuso = false

                            if t1.value20.AutoBuso then
                                pcall(function()
                                    t1.value20.AutoBuso:SetValue(false)
                                end)
                            end

                            t1.value1:Notify({
								Title = "✅ Buso Haki",
								Content = "Buso Haki Unlocked สำเร็จ!",
								Duration = 5
							})
                        end
                    end
                end
            end
        end
    end
end)
t1.value49 = game:GetService("ReplicatedStorage"):WaitForChild("Remotes"):WaitForChild("RequestGrailCraft")
task.spawn(function()
    while task.wait(1) do
        pcall(function()
            if t1.value14.AutoCraftDivineGrail then
                t1.value49:InvokeServer("DivineGrail", 1)
            end
        end)
    end
end)
task.spawn(function()
    while task.wait(0.5) do
        pcall(function()
            if t1.value14.Haki and not workspace[t1.value4]["Right Arm"]:FindFirstChild("ParticeEmitter") then
                game:GetService("ReplicatedStorage"):WaitForChild("RemoteEvents"):WaitForChild("HakiRemote"):FireServer("Toggle")
            end
        end)
    end
end)
task.spawn(function()
    while task.wait(0.5) do
        pcall(function()
            if t1.value14.Observation and not game:GetService("Players").LocalPlayer.PlayerGui.DodgeCounterUI.MainFrame.Visible then
                game:GetService("ReplicatedStorage"):WaitForChild("RemoteEvents"):WaitForChild("ObservationHakiRemote"):FireServer("Toggle")
            end
        end)
    end
end)
task.spawn(function()
    while task.wait(0.2) do
        local AutoStatToggle = t1.value14.AutoStatToggle

        if AutoStatToggle then
            AutoStatToggle = type(t1.value14.SelectedStats) == "table"
        end

        if AutoStatToggle then
            for k, v in pairs(t1.value14.SelectedStats) do
                local str
                local v201 = k
                if v == true then
                    str = tostring(v201)
                else
                    local v202 = type(v201) == "number"

                    if v202 then
                        v202 = type(v) == "string"
                    end

                    if v202 then
                        str = v
                    end
                end
                if str then
                    if str == "DevilFruit" then
                        str = "Power"
                    end

                    local t14 = {
						str,
						10
					}

                    pcall(function()
                        game:GetService("ReplicatedStorage"):WaitForChild("RemoteEvents"):WaitForChild("AllocateStat"):FireServer(unpack(t14))
                    end)
                end
            end
        end
    end
end)
task.spawn(function()
    while task.wait() do
        if t1.value14.AutoAttckToggle then
            game:GetService("ReplicatedStorage"):WaitForChild("CombatSystem"):WaitForChild("Remotes"):WaitForChild("RequestHit"):FireServer()
        end
    end
end)
t1.value50 = game:GetService("ReplicatedStorage"):WaitForChild("Remotes"):WaitForChild("MerchantRemotes"):WaitForChild("PurchaseMerchantItem")
task.spawn(function()
    while task.wait(1) do
        pcall(function()
            local AutoBuyMerchant = t1.value14.AutoBuyMerchant

            if AutoBuyMerchant then
                AutoBuyMerchant = t1.value14.MerchantItem
            end

            if AutoBuyMerchant then
                if type(t1.value14.MerchantItem) == "table" then
                    for k, v in pairs(t1.value14.MerchantItem) do
                        if v == true then
                            t1.value50:InvokeServer(k, 1)
                            task.wait(0.3)
                        end
                    end

                    return
                end

                local v340 = type(t1.value14.MerchantItem) == "string"

                if v340 then
                    v340 = t1.value14.MerchantItem ~= ""
                end

                if v340 then
                    t1.value50:InvokeServer(t1.value14.MerchantItem, 1)
                end
            end
        end)
    end
end)
task.spawn(function()
    while task.wait(1) do
        pcall(function()
            local AutoOpenChest = t1.value14.AutoOpenChest

            if AutoOpenChest then
                AutoOpenChest = t1.value14.ChestSelect
            end

            if AutoOpenChest then
                if type(t1.value14.ChestSelect) == "table" then
                    for k, v in pairs(t1.value14.ChestSelect) do
                        local v344 = k
                        local str
                        if v == true then
                            str = tostring(v344)
                        else
                            local v346 = type(v344) == "number"

                            if v346 then
                                v346 = type(v) == "string"
                            end

                            if v346 then
                                str = v
                            end
                        end
                        if str then
                            game:GetService("ReplicatedStorage"):WaitForChild("Remotes"):WaitForChild("UseItem"):FireServer("Use", str, 1, false)
                            task.wait(0.3)
                        end
                    end

                    return
                end

                local v347 = type(t1.value14.ChestSelect) == "string"

                if v347 then
                    v347 = t1.value14.ChestSelect ~= ""
                end

                if v347 then
                    game:GetService("ReplicatedStorage"):WaitForChild("Remotes"):WaitForChild("UseItem"):FireServer("Use", t1.value14.ChestSelect, 1, false)
                end
            end
        end)
    end
end)
t1.value1:SetTheme("Midnight")
t1.value51 = "https://discord.com/api/v10/invites/" .. "RtBy7MRSXk" .. "?with_counts=true&with_expiration=true"
local HttpService = game:GetService("HttpService")
local Request = t1.value1.Creator.Request
local value51 = t1.value51
local JSONDecode = HttpService.JSONDecode
local t15 = {
	["User-Agent"] = "RobloxBot/1.0",
	Accept = "application/json"
}
local v41 = JSONDecode(HttpService, Request({
	Url = value51,
	Method = "GET",
	Headers = t15
}).Body)

if v41 and v41.guild then
    local Tests = t3.Tests
    local name = v41.guild.name
    local v44 = " <font color=\"#52525b\">•</font> Member Count : " .. tostring(v41.approximate_member_count) .. "\n <font color=\"#16a34a\">•</font> Online Count : " .. tostring(v41.approximate_presence_count)
    local guild = v41.guild
    local Paragraph = Tests.Paragraph
    local v47 = "https://cdn.discordapp.com/icons/" .. guild.id .. "/" .. v41.guild.icon .. ".png?size=1024"
    local v48 = Paragraph(Tests, {
		Title = name,
		Desc = v44,
		Image = v47,
		ImageSize = 42
	})

    t3.Tests:Button({
		Title = "Update Info",
		Callback = function()
        local data = game:GetService("HttpService"):JSONDecode(t1.value1.Creator.Request({
				Url = t1.value51,
				Method = "GET"
			}).Body)
        local v205 = data

        if data then
            v205 = data and data.guild
        end

        if v205 then
            v48:SetDesc(" <font color=\"#52525b\">•</font> Member Count : " .. tostring(data.approximate_member_count) .. "\n <font color=\"#16a34a\">•</font> Online Count : " .. tostring(data.approximate_presence_count))
        end
    end
	})
else
    local Tests = t3.Tests
    local json = game:GetService("HttpService"):JSONEncode(v41)

    Tests:Paragraph({
		Title = "Error when receiving information about the Discord server",
		Desc = json,
		Image = "triangle-alert",
		ImageSize = 26,
		Color = "Red"
	})
end
t3.Tests:Section({
	Title = "Update Log"
})
t3.Tests:Paragraph({
	Title = "Update 0.0.1",
	Desc = [[📌 All Features / ฟังก์ชันทั้งหมด:

🇬🇧 [English]
- [Main]: Auto Farm, Specific Mon Farm, Set Distance/Position, Auto Skills/Attack
- [Haki]: Auto Haki, Auto Observation
- [Boss]: Auto All Bosses, Auto Broken Sword (Gilgamesh), Auto Craft Divine Grail, Auto Summon Boss
- [Dungeon]: Auto Enter & Replay, Select Difficulty, Auto Farm Dungeon Mobs
- [Stats]: Auto Upgrade Stats (Melee, Defense, Sword, Fruit)
- [Misc]: Auto Buy Merchant, Auto Open Chest,  Boost FPS, NoClip
- [Quest]: Coming Soon!
- [Settings]: Full Save/Load Profiles, Auto Save (30s), UI Customization

🇹🇭 [ภาษาไทย]
- [Main]: ออโต้ฟาร์มรอบตัว/เฉพาะตัว, ตั้งระยะการตี, เลือกสกิลอัตโนมัติ
- [Haki]: เปิดฮาคิเกราะ/สังเกตอัตโนมัติ
- [Boss]: ตีบอสทั้งหมด, ตีบอสดาบหัก (Gilgamesh), คราฟจอกศักดิ์สิทธิ์, ซัมม่อนบอส
- [Dungeon]: ลงดัน/รีเพลย์อัตโนมัติ, เลือกระดับดันเจี้ยน, ตีมอนดัน
- [Stats]: อัพสเตตัสอัตโนมัติ (หมัด, เลือด, ดาบ, ผล)
- [Misc]: ซื้อตู้พ่อค้า-เปิดกล่องสุ่มอัตโนมัติ,  บูส FPS ลดแลค, เดินทะลุกำแพง
- [Quest]: กำลังพัฒนา
- [Settings]: ระบบเซฟการตั้งค่าทั้งหมด, ออโต้เซฟ, เปลี่ยนธีมโปรไฟล์]]
})
t3.WindowTab:Keybind({
	Title = "Keybind Example",
	Desc = "Keybind to open ui",
	Value = "G",
	Callback = function(p44)
    t1.value2:SetToggleKey(Enum.KeyCode[p44])
end
})
t3.WindowTab:Section({
	Title = "Window"
})
local t16 = {}
for k, _ in pairs(t1.value1:GetThemes()) do
    table.insert(t16, k)
end
t3.WindowTab:Dropdown({
	Title = "Select Theme",
	Multi = false,
	AllowNone = false,
	Value = nil,
	Values = t16,
	Callback = function(p45)
    t1.value1:SetTheme(p45)
end
}):Select(v2({ t1.value1:GetCurrentTheme() }))

local WindowTab = t3.WindowTab
local Transparency = t1.value1:GetTransparency()
WindowTab:Toggle({
	Title = "Toggle Window Transparency",
	Callback = function(p46)
    t1.value2:ToggleTransparency(p46)
end,
	Value = Transparency
})
t3.WindowTab:Section({
	Title = "💾 Save Settings"
})
t1.value52 = ""
t3.WindowTab:Input({
	Title = "Profile Name",
	PlaceholderText = "Enter profile name...",
	Callback = function(p47)
    t1.value52 = p47
end
})
t3.WindowTab:Button({
	Title = "💾 Save Settings",
	Callback = function()
    if t1.value52 ~= "" then
        t1.value31(t1.value52)

        local value1_4 = t1.value1
        local Notify = value1_4.Notify
        local v212 = "บันทึกโปรไฟล์: " .. t1.value52 .. " สำเร็จ!"

        Notify(value1_4, {
				Title = "✅ Saved",
				Content = v212,
				Duration = 4
			})
        pcall(function()
            local _settingsFilesDropdown = settingsFilesDropdown
            local t17 = { t1.value30() }

            _settingsFilesDropdown:Refresh(v2(t17))
        end)

        return
    end

    t1.value1:Notify({
			Title = "⚠\239\184\143 Error",
			Content = "กรุณาใส่ชื่อโปรไฟล์ก่อน",
			Duration = 3
		})
end
})
t3.WindowTab:Section({
	Title = "📂 Load Settings"
})
local v56 = t1.value30()
t1.value53 = ""
t1.value54 = t3.WindowTab:Dropdown({
	Title = "Select Profile",
	Multi = false,
	AllowNone = true,
	Values = v56,
	Callback = function(p48)
    t1.value53 = p48
end
})
t3.WindowTab:Button({
	Title = "📂 Load Settings",
	Callback = function()
    if t1.value53 ~= "" then
        t1.value32(t1.value53)

        return
    end

    t1.value1:Notify({
			Title = "⚠\239\184\143 Error",
			Content = "กรุณาเลือกโปรไฟล์ก่อน",
			Duration = 3
		})
end
})
t3.WindowTab:Button({
	Title = "💾 Overwrite Selected Profile",
	Callback = function()
    if t1.value53 ~= "" then
        t1.value31(t1.value53)

        local value1_5 = t1.value1
        local Notify = value1_5.Notify
        local v216 = "เขียนทับโปรไฟล์: " .. t1.value53 .. " สำเร็จ!"

        Notify(value1_5, {
				Title = "✅ Overwritten",
				Content = v216,
				Duration = 4
			})

        return
    end

    t1.value1:Notify({
			Title = "⚠\239\184\143 Error",
			Content = "กรุณาเลือกโปรไฟล์ก่อน",
			Duration = 3
		})
end
})
t3.WindowTab:Button({
	Title = "🗑\239\184\143 Delete Selected Profile",
	Callback = function()
    if t1.value53 ~= "" then
        pcall(function()
            delfile(t1.value27 .. "/" .. t1.value53 .. ".json")
        end)

        local value1_6 = t1.value1
        local Notify = value1_6.Notify
        local v219 = "ลบโปรไฟล์: " .. t1.value53 .. " สำเร็จ!"

        Notify(value1_6, {
				Title = "🗑\239\184\143 Deleted",
				Content = v219,
				Duration = 4
			})
        t1.value53 = ""

        local value54 = t1.value54
        local t18 = { t1.value30() }

        value54:Refresh(v2(t18))

        return
    end

    t1.value1:Notify({
			Title = "⚠\239\184\143 Error",
			Content = "กรุณาเลือกโปรไฟล์ก่อน",
			Duration = 3
		})
end
})
t3.WindowTab:Button({
	Title = "🔄 Refresh Profile List",
	Callback = function()
    local value54 = t1.value54
    local t19 = { t1.value30() }

    value54:Refresh(v2(t19))
end
})
t3.WindowTab:Section({
	Title = "⚡ Auto Save"
})
t1.value55 = false
t1.value56 = "AutoSave"
t3.WindowTab:Toggle({
	Title = "Enable Auto Save (every 30s)",
	Value = false,
	Callback = function(p49)
    t1.value55 = p49
end
})
t3.WindowTab:Input({
	Title = "Auto Save Profile Name",
	PlaceholderText = "AutoSave",
	Callback = function(p50)
    if p50 ~= "" then
        t1.value56 = p50
    end
end
})
task.spawn(function()
    while task.wait(30) do
        pcall(function()
            local value55 = t1.value55

            if value55 then
                value55 = t1.value56 ~= ""
            end

            if value55 then
                local value56 = t1.value56

                t1.value31(value56)
            end
        end)
    end
end)
t1.value57 = t1.value1:GetCurrentTheme()
local Themes = t1.value1:GetThemes()
t1.value58 = Themes[t1.value57].Accent
t1.value59 = Themes[t1.value57].Outline
t1.value60 = Themes[t1.value57].Text
t1.value61 = Themes[t1.value57].Placeholder
function updateTheme()
    t1.value1:AddTheme({
		Name = t1.value57,
		Accent = t1.value58,
		Outline = t1.value59,
		Text = t1.value60,
		Placeholder = t1.value61
	})
    t1.value1:SetTheme(t1.value57)
end
t1.value2:SelectTab(1)
