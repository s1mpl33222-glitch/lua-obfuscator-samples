-- This file was generated at discord.gg/syncrypt

local v1 = unpack or table.unpack
repeat
    task.wait()
until game:IsLoaded()
if _G.AnimeZero_Connections then
    for _, v in ipairs(_G.AnimeZero_Connections) do
        local v4 = v

        pcall(function()
            v4:Disconnect()
        end)
    end
end
_G.AnimeZero_Connections = {}
pcall(function()
    local function v257(p1)
        if not p1 then
            return
        end

        pcall(function()
            for _, child in ipairs(p1:GetChildren()) do
                local v1015 = child
                local v1016 = v1015.Name:find("WindUI")

                if not v1016 then
                    v1016 = v1015.Name:find("RexHub_AnimeZero")
                end

                if v1016 then
                    pcall(function()
                        v1015:Destroy()
                    end)
                end
            end
        end)
    end

    local LocalPlayer = game:GetService("Players").LocalPlayer

    if LocalPlayer then
        v257(LocalPlayer:FindFirstChild("PlayerGui"))
    end

    pcall(function()
        v257(game:GetService("CoreGui"))
    end)
end)
local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local UserInputService = game:GetService("UserInputService")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local HttpService = game:GetService("HttpService")
local VirtualUser = game:GetService("VirtualUser")
local VirtualInputManager = game:GetService("VirtualInputManager")
local Lighting = game:GetService("Lighting")
game:GetService("TweenService")
local LocalPlayer = Players.LocalPlayer
local PlayerGui = LocalPlayer:WaitForChild("PlayerGui")
local function v15(p2, p3)
    local u264 = p3
    pcall(function()
        game:GetService("StarterGui"):SetCore("SendNotification", {
			Title = p2,
			Text = u264,
			Duration = 3
		})
    end)
end
local function u16()
    return LocalPlayer.Character
end
local function v17()
    local v265 = u16()

    if v265 then
        local HumanoidRootPart = v265:FindFirstChild("HumanoidRootPart")

        if not HumanoidRootPart then
            HumanoidRootPart = v265:FindFirstChildWhichIsA("BasePart")
        end

        v265 = HumanoidRootPart
    end

    return v265
end
local function v18()
    local v267 = u16()

    if v267 then
        v267 = v267:FindFirstChildOfClass("Humanoid")
    end

    return v267
end
local function v19(p4)
    if not p4 then
        return nil
    end

    if p4:IsA("BasePart") then
        return p4.CFrame
    end

    if p4:IsA("Model") then
        if p4.PrimaryPart then
            return p4.PrimaryPart.CFrame
        end

        local Pivot = p4:GetPivot()

        if Pivot then
            return Pivot
        end

        local BasePart = p4:FindFirstChildWhichIsA("BasePart", true)

        if BasePart then
            return BasePart.CFrame
        end
    end

    return nil
end
local function v20(p5)
    local v269 = u16()
    local v270 = v17()
    if not v270 then
        return
    end
    local cFrame
    if typeof(p5) == "Vector3" then
        cFrame = CFrame.new(p5)
    elseif typeof(p5) == "CFrame" then
        cFrame = p5
    elseif typeof(p5) == "Instance" then
        local v272 = v19(p5)

        if v272 then
            cFrame = v272 + Vector3.new(0, 3.5, 0)
        end
    end
    if cFrame then
        if v269 and v269.PivotTo then
            v269:PivotTo(cFrame)

            return
        end

        v270.CFrame = cFrame
    end
end
local v21 = ReplicatedStorage:FindFirstChild("lobby") ~= nil
if not v21 then
    v21 = ReplicatedStorage:WaitForChild("lobby", 2) ~= nil
end
local v22 = v21 and workspace:FindFirstChild("enemies") == nil
local function v23()
    return PlayerGui
end
if typeof(getgenv) == "function" then
    getgenv().gethui = v23
end
pcall(function()
    getfenv().gethui = v23
end)
local v24 = loadstring(game:HttpGet("https://wareguardv2.xyz/raw?service=rexhub&script=ui"))()
if not v22 then
    local characterPackets
    pcall(function()
        characterPackets = require(ReplicatedStorage.game.packets.characterPackets)
    end)
    local u26
    pcall(function()
        u26 = require(ReplicatedStorage.game.packets.rewardPackets)
    end)
    local u27
    pcall(function()
        u27 = require(ReplicatedStorage.game.packets.runPackets)
    end)
    pcall(function()
        require(ReplicatedStorage.game.Trials)
    end)
    local enemyStore
    pcall(function()
        enemyStore = require(ReplicatedStorage.game.stores.enemyStore)
    end)
    local u29
    pcall(function()
        u29 = require(ReplicatedStorage.game.stores.dropStore)
    end)
    local u30
    pcall(function()
        u30 = require(ReplicatedStorage.game.stores.runStore)
    end)
    local u31
    local function v32()
        if not u31 then
            pcall(function()
                u31 = require(LocalPlayer.PlayerScripts.game.controllers.characterController)
            end)
        end

        return u31
    end
    local v33 = "AnimeZero_Folder" .. "/DungeonSettings.json"
    local t1 = {
		AutoFarmMobs = true,
		AutoBreakWalls = true,
		InstantKill = false,
		AttackMultiplier = 6,
		FarmDistance = 2.2,
		FarmPosition = "Front of Target",
		FastM1Attack = true,
		AutoSkills = true,
		HitboxExpander = false,
		HitboxSize = 16,
		AutoCollectDrops = true,
		AutoNextWave = true,
		AutoEndScreen = "Next",
		AutoBlock = false,
		AutoDash = false,
		GodPlatform = false,
		DisableCollision = false,
		MobESP = false,
		BossESP = false,
		WalkSpeed = 16,
		JumpPower = 50,
		InfiniteJump = false,
		Noclip = false,
		AntiAFK = true,
		FPSBoost = false,
		BlackScreen = false,
		InfiniteAutoFarm = true,
		InfinitePrioritizeBoss = true,
		InfiniteAutoLeave = false,
		InfiniteTargetWave = 50,
		InfiniteLowHpLeave = false,
		InfiniteLowHpThreshold = 20,
		InfiniteAutoRetry = true,
		InfiniteStayInArena = true,
		RaidAutoElevator = true,
		RaidSmartTarget = true,
		RaidPrioritizeOath = true,
		RaidSkipCutscenes = true,
		RaidEnrageSafezone = true,
		RaidEndAction = "Retry",
		TrialsAutoFarm = true,
		TrialsHoverHeight = 8,
		TrialsSafeFly = true,
		TrialsAutoSkipFloor = false,
		TrialsPrioritizeBoss = true,
		TrialsAutoNextRoom = true,
		TrialsTargetRoom = 125,
		TrialsAutoLeaveAtTarget = false,
		TrialsAutoRetry = true,
		TrialsRankSpeedAlert = true
	}
    local function v35()
        if isfile and isfile(v33) then
            local ok, result = pcall(function()
                local v976 = HttpService
                local t2 = { readfile(v33) }

                return v976:JSONDecode(v1(t2))
            end)

            if ok then
                ok = type(result) == "table"
            end

            if ok then
                for k, v in pairs(result) do
                    local v277 = k

                    if t1[v277] ~= nil then
                        t1[v277] = v
                    end
                end
            end
        end
    end
    local function v36()
        pcall(function()
            if not isfolder("AnimeZero_Folder") then
                makefolder("AnimeZero_Folder")
            end

            writefile(v33, HttpService:JSONEncode(t1))
        end)
    end
    v35()
    local _UDim2 = UDim2
    local CreateWindow = v24.CreateWindow
    local v39 = _UDim2.fromOffset(600, 490)
    local v40 = CreateWindow(v24, {
		Title = "Rex Hub | Anime Zero [Dungeon Combat]",
		Icon = "swords",
		Author = "AutoPlay Helper",
		Folder = "AnimeZero_Folder",
		Size = v39,
		Transparent = true,
		Theme = "Midnight"
	})
    local v41 = v40:Tab({
		Title = "Combat",
		Icon = "swords"
	})
    local v42 = v40:Tab({
		Title = "Trials Mode",
		Icon = "trophy"
	})
    local v43 = v40:Tab({
		Title = "Infinite Mode",
		Icon = "infinity"
	})
    local v44 = v40:Tab({
		Title = "Raid Mode",
		Icon = "flame"
	})
    local v45 = v40:Tab({
		Title = "Dungeon",
		Icon = "flag"
	})
    local v46 = v40:Tab({
		Title = "Survival",
		Icon = "shield"
	})
    local v47 = v40:Tab({
		Title = "Visuals",
		Icon = "eye"
	})
    local v48 = v40:Tab({
		Title = "Player",
		Icon = "user"
	})
    local v49 = v40:Tab({
		Title = "Settings",
		Icon = "settings"
	})
    v41:Section({
		Title = "Auto Farm Controls"
	})
    local AutoFarmMobs = t1.AutoFarmMobs
    v41:Toggle({
		Title = "Auto Farm Mobs",
		Value = AutoFarmMobs,
		Callback = function(p6)
        t1.AutoFarmMobs = p6
        v36()

        if not p6 then
            local v279 = v32()
            local v280 = v279

            if v280 then
                v280 = v279.setTouchHeld
            end

            if v280 then
                pcall(function()
                    v279.setTouchHeld("Attack", false)
                end)
            end
        end
    end
	})
    local Toggle = v41.Toggle
    local AutoBreakWalls = t1.AutoBreakWalls
    Toggle(v41, {
		Title = "Auto Break Walls (Rubble)",
		Value = AutoBreakWalls,
		Callback = function(p7)
        t1.AutoBreakWalls = p7
        v36()
    end
	})
    local InstantKill = t1.InstantKill
    v41:Toggle({
		Title = "Instant Kill / Burst Attack",
		Value = InstantKill,
		Callback = function(p8)
        t1.InstantKill = p8
        v36()
    end
	})
    local AttackMultiplier = t1.AttackMultiplier
    local t3 = {
		Min = 1,
		Max = 20,
		Default = AttackMultiplier or 6
	}
    v41:Slider({
		Title = "Attack Burst Multiplier",
		Value = t3,
		Callback = function(p9)
        local v284 = type(p9) == "table"

        if v284 then
            v284 = p9.Default or (p9.Min or 6)
        end

        t1.AttackMultiplier = v284 or p9
        v36()
    end
	})
    local v56 = t1.FarmPosition or "Front of Target"
    v41:Dropdown({
		Title = "Farm Stance",
		Values = {
			"Front of Target",
			"Behind Target",
			"Above Target"
		},
		Value = v56,
		Callback = function(p10)
        t1.FarmPosition = p10
        v36()
    end
	})
    local v57 = math.floor(tonumber(t1.FarmDistance) or 3)
    local t4 = {
		Min = 1,
		Max = 50,
		Default = v57
	}
    v41:Slider({
		Title = "Farm Distance",
		Step = 1,
		Value = t4,
		Callback = function(p11)
        local v287 = type(p11) == "table"

        if v287 then
            v287 = p11.Default or (p11.Min or 3)
        end

        t1.FarmDistance = tonumber(v287 or p11) or 3
        v36()
    end
	})
    v41:Section({
		Title = "Attacks & Skills"
	})
    local FastM1Attack = t1.FastM1Attack
    v41:Toggle({
		Title = "Continuous M1 Attacks",
		Value = FastM1Attack,
		Callback = function(p12)
        t1.FastM1Attack = p12
        v36()
    end
	})
    local AutoSkills = t1.AutoSkills
    v41:Toggle({
		Title = "Auto Cast Skills (1, 2, 3, 4)",
		Value = AutoSkills,
		Callback = function(p13)
        t1.AutoSkills = p13
        v36()
    end
	})
    v41:Section({
		Title = "Hitbox Expander"
	})
    local HitboxExpander = t1.HitboxExpander
    v41:Toggle({
		Title = "Hitbox Expander",
		Value = HitboxExpander,
		Callback = function(p14)
        t1.HitboxExpander = p14
        v36()
    end
	})
    local HitboxSize = t1.HitboxSize
    local t5 = {
		Min = 4,
		Max = 40,
		Default = HitboxSize or 16
	}
    v41:Slider({
		Title = "Hitbox Size",
		Value = t5,
		Callback = function(p15)
        local v292 = type(p15) == "table"

        if v292 then
            v292 = p15.Default or (p15.Min or 16)
        end

        t1.HitboxSize = v292 or p15
        v36()
    end
	})
    v43:Section({
		Title = "Live Status & Telemetry"
	})
    local function v64()
        local s1 = "Wave 1"
        local s2 = "Wave 10"
        local s3 = "0 left"
        local InfiniteSide = PlayerGui:FindFirstChild("InfiniteSide")

        if InfiniteSide then
            local Container = InfiniteSide:FindFirstChild("Container")

            if Container then
                local Title = Container:FindFirstChild("Title")

                if Title then
                    local v299 = Title:FindFirstChild("Txt") or Title
                    local v300 = v299

                    if v299 then
                        v300 = v299.Text

                        if v300 then
                            v300 = v299.Text ~= ""
                        end
                    end

                    if v300 then
                        s1 = v299.Text
                    end
                end

                local NextBoss = Container:FindFirstChild("NextBoss")

                if NextBoss then
                    local v302 = NextBoss:FindFirstChild("Value") or NextBoss
                    local v303 = v302

                    if v302 then
                        v303 = v302.Text

                        if v303 then
                            v303 = v302.Text ~= ""
                        end
                    end

                    if v303 then
                        s2 = v302.Text
                    end
                end
            end
        end

        local RoundHUD = PlayerGui:FindFirstChild("RoundHUD")

        if RoundHUD then
            local EnemyCount = RoundHUD:FindFirstChild("EnemyCount", true)
            local v306 = EnemyCount

            if EnemyCount then
                v306 = EnemyCount.Text

                if v306 then
                    v306 = EnemyCount.Text ~= ""
                end
            end

            if v306 then
                s3 = EnemyCount.Text
            end
        end

        local v307 = u30

        if v307 then
            v307 = u30.store

            if v307 then
                v307 = u30.store.state
            end
        end

        if v307 then
            local state = u30.store.state

            if state.wave then
                local v309 = state.wave:get()
                local v310 = v309

                if v309 then
                    v310 = tonumber(v309) and tonumber(v309) > 0
                end

                if v310 then
                    s1 = "Wave " .. tostring(v309)
                end
            end

            if state.remaining then
                local v311 = state.remaining:get()

                if v311 then
                    s3 = tostring(v311) .. " left"
                end
            end
        end

        return s1, s2, s3
    end
    v43:Button({
		Title = "Check Live Wave Info",
		Callback = function()
        local v312, v313, v314 = v64()

        v15("Infinite Status", string.format("%s | Next Boss: %s | %s", v312, v313, v314))
    end
	})
    v43:Section({
		Title = "Endless Auto Farm"
	})
    local AutoFarmMobs2 = t1.AutoFarmMobs
    v43:Toggle({
		Title = "Auto Farm Infinite Waves",
		Value = AutoFarmMobs2,
		Callback = function(p16)
        t1.AutoFarmMobs = p16
        t1.InfiniteAutoFarm = p16
        v36()

        if not p16 then
            local v316 = v32()
            local v317 = v316

            if v317 then
                v317 = v316.setTouchHeld
            end

            if v317 then
                pcall(function()
                    v316.setTouchHeld("Attack", false)
                end)
            end
        end
    end
	})
    local Toggle2 = v43.Toggle
    local InfinitePrioritizeBoss = t1.InfinitePrioritizeBoss
    Toggle2(v43, {
		Title = "Prioritize Boss on Boss Waves",
		Value = InfinitePrioritizeBoss,
		Callback = function(p17)
        t1.InfinitePrioritizeBoss = p17
        v36()
    end
	})
    local InfiniteStayInArena = t1.InfiniteStayInArena
    v43:Toggle({
		Title = "Stay Center Arena Between Waves",
		Value = InfiniteStayInArena,
		Callback = function(p18)
        t1.InfiniteStayInArena = p18
        v36()
    end
	})
    v43:Section({
		Title = "Wave Target & Exit Safeguards"
	})
    local InfiniteAutoLeave = t1.InfiniteAutoLeave
    v43:Toggle({
		Title = "Auto Leave at Target Wave",
		Value = InfiniteAutoLeave,
		Callback = function(p19)
        t1.InfiniteAutoLeave = p19
        v36()
    end
	})
    local Slider = v43.Slider
    local InfiniteTargetWave = t1.InfiniteTargetWave
    local t6 = {
		Min = 5,
		Max = 150,
		Default = InfiniteTargetWave or 50
	}
    Slider(v43, {
		Title = "Target Wave to Leave",
		Step = 5,
		Value = t6,
		Callback = function(p20)
        local v322 = type(p20) == "table"

        if v322 then
            v322 = p20.Default or (p20.Min or 50)
        end

        t1.InfiniteTargetWave = tonumber(v322 or p20) or 50
        v36()
    end
	})
    local Toggle3 = v43.Toggle
    local InfiniteLowHpLeave = t1.InfiniteLowHpLeave
    Toggle3(v43, {
		Title = "Emergency Leave on Low HP",
		Value = InfiniteLowHpLeave,
		Callback = function(p21)
        t1.InfiniteLowHpLeave = p21
        v36()
    end
	})
    local Slider2 = v43.Slider
    local InfiniteLowHpThreshold = t1.InfiniteLowHpThreshold
    local t7 = {
		Min = 10,
		Max = 50,
		Default = InfiniteLowHpThreshold or 20
	}
    Slider2(v43, {
		Title = "Emergency Leave HP %",
		Step = 5,
		Value = t7,
		Callback = function(p22)
        local v325 = type(p22) == "table"

        if v325 then
            v325 = p22.Default or (p22.Min or 20)
        end

        t1.InfiniteLowHpThreshold = tonumber(v325 or p22) or 20
        v36()
    end
	})
    v43:Button({
		Title = "Emergency Leave Run Now",
		Callback = function()
        local v326 = u27

        if v326 then
            v326 = u27.endAction
        end

        if v326 then
            pcall(function()
                u27.endAction:fire(3)
            end)
        end

        local InfiniteSide = PlayerGui:FindFirstChild("InfiniteSide")
        local v328 = InfiniteSide and InfiniteSide:FindFirstChild("Leave", true)

        if v328 then
            clickGuiButton(v328)
        end

        v15("Infinite", "Leaving Infinite run...")
    end
	})
    v43:Section({
		Title = "Looping"
	})
    local Toggle4 = v43.Toggle
    local InfiniteAutoRetry = t1.InfiniteAutoRetry
    Toggle4(v43, {
		Title = "Auto Restart on Defeat (Infinite Loop)",
		Value = InfiniteAutoRetry,
		Callback = function(p23)
        t1.InfiniteAutoRetry = p23
        v36()
    end
	})
    v42:Section({
		Title = "Live Trials Telemetry & Milestone Radar"
	})
    local function v80()
        local num = tonumber(workspace:GetAttribute("TrialsRoom") or 1)
        local num2 = tonumber(workspace:GetAttribute("TrialsFloor") or 1)
        local v332 = workspace:GetAttribute("TrialsSkipOpen") == true
        local num3 = tonumber(workspace:GetAttribute("TrialsSkips") or 0)
        local s4 = "Room 10 (Gems & Rolls)"
        local t8 = {
			room = 10,
			reward = "300 Gems + 5 Rolls"
		}
        local t9 = {
			room = 20,
			reward = "500 Gems + 10 Rolls"
		}
        local t10 = {
			room = 30,
			reward = "800 Gems + 15 Rolls + 10 Rerolls"
		}
        local t11 = {
			room = 50,
			reward = "1,500 Gems + 25 Rolls + 3 Lucky Spins"
		}
        local t12 = {
			room = 75,
			reward = "2,500 Gems + 35 Rolls + 25 Rerolls"
		}
        local t13 = {
			room = 100,
			reward = "4,000 Gems + 50 Rolls + 5 Lucky Spins"
		}
        local t14 = {
			room = 125,
			reward = "UNIT: Frieren (Solo Mode)"
		}
        local t15 = {
			room = 150,
			reward = "UNIT: Astra Yao (Coop Mode)"
		}
        local t16 = {
			room = 175,
			reward = "7,000 Gems + 85 Rolls"
		}
        local t17 = {
			room = 200,
			reward = "8,000 Gems + 100 Rolls + 10 Lucky Spins"
		}
        local t18 = {
			room = 250,
			reward = "10,000 Gems + 125 Rolls + 75 Rerolls"
		}
        local t19 = {
			room = 300,
			reward = "12,000 Gems + 150 Rolls + 15 Lucky Spins"
		}
        local t20 = {
			room = 325,
			reward = "UNIT: Ye Shunguang"
		}
        local t21 = {
			room = 400,
			reward = "16,000 Gems + 200 Rolls + 100 Rerolls"
		}
        local t22 = {
			room = 500,
			reward = "25,000 Gems + 300 Rolls + 25 Lucky Spins"
		}
        local v350, v351, v352 = ipairs({
			t8,
			t9,
			t10,
			t11,
			t12,
			t13,
			t14,
			t15,
			t16,
			t17,
			t18,
			t19,
			t20,
			t21,
			t22
		})
        local g354
        local v353
        repeat
            v352, v353 = v350(v351, v352)

            if not v352 then
                g354 = true
            end

            if g354 then
                break
            end
        until num <= v353.room
        if not g354 then
            s4 = string.format("Room %d: %s", v353.room, v353.reward)
        end
        local n1 = 0
        local enemies = workspace:FindFirstChild("enemies")
        if enemies then
            local GetChildren = enemies.GetChildren

            for _, v in ipairs(GetChildren(enemies)) do
                local Humanoid = v:FindFirstChildOfClass("Humanoid")

                if Humanoid and Humanoid.Health > 0 then
                    n1 += 1
                end
            end
        end
        local format = string.format
        local v362 = v332 and "YES"
        if not v362 then
            v362 = "NO"
        end

        return format("Room: %d | Floor: %d/5 (Boss at Floor 5)\nEnemies Alive: %d | Skip Open: %s (%d used)\nNext Milestone -> %s", num, num2, n1, v362, num3, s4)
    end
    v42:Button({
		Title = "Check Live Trials Status",
		Callback = function()
        local v363 = v80()

        v15("Trials Status", v363)
    end
	})
    v42:Section({
		Title = "Auto Farm & Combat Stance"
	})
    local Toggle5 = v42.Toggle
    local TrialsAutoFarm = t1.TrialsAutoFarm
    Toggle5(v42, {
		Title = "Auto Farm Trials (Auto Kill & Clear)",
		Value = TrialsAutoFarm,
		Callback = function(p24)
        t1.TrialsAutoFarm = p24
        t1.AutoFarmMobs = p24
        v36()

        if not p24 then
            local v365 = v32()
            local v366 = v365

            if v366 then
                v366 = v365.setTouchHeld
            end

            if v366 then
                pcall(function()
                    v365.setTouchHeld("Attack", false)
                end)
            end
        end
    end
	})
    local TrialsSafeFly = t1.TrialsSafeFly
    v42:Toggle({
		Title = "Safe Hover Stance (Fly Above Enemies)",
		Value = TrialsSafeFly,
		Callback = function(p25)
        t1.TrialsSafeFly = p25
        v36()
    end
	})
    local Slider3 = v42.Slider
    local TrialsHoverHeight = t1.TrialsHoverHeight
    local t23 = {
		Min = 4,
		Max = 25,
		Default = TrialsHoverHeight or 8
	}
    Slider3(v42, {
		Title = "Safe Hover Height",
		Step = 1,
		Value = t23,
		Callback = function(p26)
        local v369 = type(p26) == "table"

        if v369 then
            v369 = p26.Default or (p26.Min or 8)
        end

        t1.TrialsHoverHeight = tonumber(v369 or p26) or 8
        v36()
    end
	})
    local Toggle6 = v42.Toggle
    local TrialsPrioritizeBoss = t1.TrialsPrioritizeBoss
    Toggle6(v42, {
		Title = "Prioritize Boss on Floor 5",
		Value = TrialsPrioritizeBoss,
		Callback = function(p27)
        t1.TrialsPrioritizeBoss = p27
        v36()
    end
	})
    v42:Section({
		Title = "Floor Skip & Progression"
	})
    local Toggle7 = v42.Toggle
    local TrialsAutoSkipFloor = t1.TrialsAutoSkipFloor
    Toggle7(v42, {
		Title = "Auto Skip Floor when Available",
		Value = TrialsAutoSkipFloor,
		Callback = function(p28)
        t1.TrialsAutoSkipFloor = p28
        v36()
    end
	})
    v42:Button({
		Title = "Instant Skip Current Floor",
		Callback = function()
        local v372 = u27

        if v372 then
            v372 = u27.trialsSkip
        end

        if v372 then
            pcall(function()
                u27.trialsSkip:fire()
            end)
            v15("Trials", "Dispatched trialsSkip packet!")

            return
        end

        v15("Trials", "runPackets.trialsSkip unavailable.")
    end
	})
    local Toggle8 = v42.Toggle
    local DisableCollision = t1.DisableCollision
    Toggle8(v42, {
		Title = "Auto Clear World Barriers (No Obstacles)",
		Value = DisableCollision,
		Callback = function(p29)
        t1.DisableCollision = p29
        v36()

        local World = workspace:FindFirstChild("World")

        if World then
            World = World:FindFirstChild("Barriers")
        end

        if World then
            for _, child in ipairs(World:GetChildren()) do
                if child:IsA("BasePart") then
                    child.CanCollide = not p29
                end
            end
        end
    end
	})
    v42:Section({
		Title = "Milestones & Auto Leave Safeguard"
	})
    local TrialsAutoLeaveAtTarget = t1.TrialsAutoLeaveAtTarget
    v42:Toggle({
		Title = "Auto Leave at Milestone Target Room",
		Value = TrialsAutoLeaveAtTarget,
		Callback = function(p30)
        t1.TrialsAutoLeaveAtTarget = p30
        v36()
    end
	})
    local Slider4 = v42.Slider
    local TrialsTargetRoom = t1.TrialsTargetRoom
    local t24 = {
		Min = 10,
		Max = 500,
		Default = TrialsTargetRoom or 125
	}
    Slider4(v42, {
		Title = "Target Room to Leave",
		Step = 5,
		Value = t24,
		Callback = function(p31)
        local v379 = type(p31) == "table"

        if v379 then
            v379 = p31.Default or (p31.Min or 125)
        end

        t1.TrialsTargetRoom = tonumber(v379 or p31) or 125
        v36()
    end
	})
    v42:Button({
		Title = "Emergency Leave Trials Run Now",
		Callback = function()
        local v380 = u27

        if v380 then
            v380 = u27.endAction
        end

        if v380 then
            pcall(function()
                u27.endAction:fire(3)
            end)
        end

        local RunSide = PlayerGui:FindFirstChild("RunSide")
        local v382 = RunSide and RunSide:FindFirstChild("Leave", true)

        if v382 then
            clickGuiButton(v382)
        end

        v15("Trials", "Dispatched leave run request.")
    end
	})
    v42:Section({
		Title = "Auto Retry"
	})
    local Toggle9 = v42.Toggle
    local TrialsAutoRetry = t1.TrialsAutoRetry
    Toggle9(v42, {
		Title = "Auto Retry on Defeat",
		Value = TrialsAutoRetry,
		Callback = function(p32)
        t1.TrialsAutoRetry = p32
        v36()
    end
	})
    v44:Section({
		Title = "Live Raid Telemetry & Phase Tracker"
	})
    local function v99()
        local str = tostring(workspace:GetAttribute("Mode") or "N/A")
        local str2 = tostring(workspace:GetAttribute("Segment") or "N/A")
        local v386 = workspace:GetAttribute("RaidBossGuarded") == true and "YES (Shielded)"

        if not v386 then
            v386 = "NO"
        end

        local v387 = workspace:GetAttribute("RaidBossEnraged") == true and "YES (Dangerous!)"

        if not v387 then
            v387 = "NO"
        end

        local v388 = workspace:GetAttribute("RaidExitOpen") ~= true and "CLOSED" or "OPEN (Ready)"
        local str3 = tostring(workspace:GetAttribute("RaidOathCount") or 0)
        local v390 = workspace:GetAttribute("RaidRedGate") == true and "YES"

        if not v390 then
            v390 = "NO"
        end

        return string.format("Mode: %s | Segment: %s\nBoss Guard: %s | Enraged: %s\nElevator: %s | Oath: %s | Red Gate: %s", str, str2, v386, v387, v388, str3, v390)
    end
    v44:Button({
		Title = "Check Live Raid Telemetry",
		Callback = function()
        local v391 = v99()

        v15("Raid Status", v391)
    end
	})
    v44:Section({
		Title = "Raid Automation"
	})
    local AutoFarmMobs3 = t1.AutoFarmMobs
    v44:Toggle({
		Title = "Auto Farm Raid Mobs",
		Value = AutoFarmMobs3,
		Callback = function(p33)
        t1.AutoFarmMobs = p33
        v36()

        if not p33 then
            local v393 = v32()
            local v394 = v393

            if v394 then
                v394 = v393.setTouchHeld
            end

            if v394 then
                pcall(function()
                    v393.setTouchHeld("Attack", false)
                end)
            end
        end
    end
	})
    local Toggle10 = v44.Toggle
    local RaidAutoElevator = t1.RaidAutoElevator
    Toggle10(v44, {
		Title = "Auto Enter Elevator (Next Floor)",
		Value = RaidAutoElevator,
		Callback = function(p34)
        t1.RaidAutoElevator = p34
        v36()
    end
	})
    local RaidSmartTarget = t1.RaidSmartTarget
    v44:Toggle({
		Title = "Smart Boss Guard Target Switching",
		Value = RaidSmartTarget,
		Callback = function(p35)
        t1.RaidSmartTarget = p35
        v36()
    end
	})
    local RaidPrioritizeOath = t1.RaidPrioritizeOath
    v44:Toggle({
		Title = "Prioritize Oath Targets on DPS Check",
		Value = RaidPrioritizeOath,
		Callback = function(p36)
        t1.RaidPrioritizeOath = p36
        v36()
    end
	})
    local Toggle11 = v44.Toggle
    local RaidEnrageSafezone = t1.RaidEnrageSafezone
    Toggle11(v44, {
		Title = "Enrage Mode Safezone (Hover High)",
		Value = RaidEnrageSafezone,
		Callback = function(p37)
        t1.RaidEnrageSafezone = p37
        v36()
    end
	})
    local RaidSkipCutscenes = t1.RaidSkipCutscenes
    v44:Toggle({
		Title = "Auto Skip Raid Cutscenes",
		Value = RaidSkipCutscenes,
		Callback = function(p38)
        t1.RaidSkipCutscenes = p38
        v36()
    end
	})
    v44:Section({
		Title = "Manual Controls & Exit"
	})
    v44:Button({
		Title = "Force Enter Elevator / Next Segment",
		Callback = function()
        local World = workspace:FindFirstChild("World")
        local v401 = World and World:FindFirstChild("Markers")
        local v402 = v401 and v401:FindFirstChild("Exit")

        if v401 then
            v401 = v401:FindFirstChild("ExitPrompt", true)
        end

        if not v401 then
            v401 = v402 and v402:FindFirstChildWhichIsA("ProximityPrompt", true)
        end

        local v403 = v401

        if v402 and v17() then
            v20(v402.CFrame + Vector3.new(0, 3, 0))
            task.wait(0.15)

            if v403 then
                pcall(function()
                    if fireproximityprompt then
                        fireproximityprompt(v403)

                        return
                    end

                    if v403.InputHoldBegin then
                        v403:InputHoldBegin()
                        task.wait(v403.HoldDuration + 0.05)
                        v403:InputHoldEnd()
                    end
                end)
            end

            v15("Raid", "Interacted with elevator.")

            return
        end

        v15("Raid", "Elevator not found.")
    end
	})
    local v108 = t1.RaidEndAction or "Retry"
    v44:Dropdown({
		Title = "Auto EndScreen Action",
		Values = {
			"Retry",
			"Leave",
			"Disabled"
		},
		Value = v108,
		Callback = function(p39)
        t1.RaidEndAction = p39
        v36()
    end
	})
    v44:Button({
		Title = "Emergency Leave Raid",
		Callback = function()
        local v405 = u27

        if v405 then
            v405 = u27.endAction
        end

        if v405 then
            pcall(function()
                u27.endAction:fire(3)
            end)
        end

        local RunSide = PlayerGui:FindFirstChild("RunSide")

        if RunSide then
            RunSide = RunSide:FindFirstChild("Leave", true)
        end

        if RunSide then
            clickGuiButton(RunSide)
        end

        v15("Raid", "Leaving Raid run...")
    end
	})
    v45:Section({
		Title = "Automation"
	})
    local Toggle12 = v45.Toggle
    local AutoFarmMobs4 = t1.AutoFarmMobs
    Toggle12(v45, {
		Title = "Auto Farm Mobs",
		Value = AutoFarmMobs4,
		Callback = function(p40)
        t1.AutoFarmMobs = p40
        v36()

        if not p40 then
            local v408 = v32()
            local v409 = v408

            if v409 then
                v409 = v408.setTouchHeld
            end

            if v409 then
                pcall(function()
                    v408.setTouchHeld("Attack", false)
                end)
            end
        end
    end
	})
    local AutoNextWave = t1.AutoNextWave
    v45:Toggle({
		Title = "Auto Next Wave / Zone",
		Value = AutoNextWave,
		Callback = function(p41)
        t1.AutoNextWave = p41
        v36()
    end
	})
    local AutoBreakWalls2 = t1.AutoBreakWalls
    v45:Toggle({
		Title = "Auto Break Walls (Rubble)",
		Value = AutoBreakWalls2,
		Callback = function(p42)
        t1.AutoBreakWalls = p42
        v36()
    end
	})
    local v113 = t1.AutoEndScreen or "Next"
    v45:Dropdown({
		Title = "Auto EndScreen Action",
		Values = {
			"Next",
			"Retry",
			"Leave",
			"Disabled"
		},
		Value = v113,
		Callback = function(p43)
        t1.AutoEndScreen = p43
        v36()
    end
	})
    local AutoCollectDrops = t1.AutoCollectDrops
    v45:Toggle({
		Title = "Auto Collect Loot Drops",
		Value = AutoCollectDrops,
		Callback = function(p44)
        t1.AutoCollectDrops = p44
        v36()
    end
	})
    v45:Section({
		Title = "Manual Teleports"
	})
    v45:Button({
		Title = "Teleport to Barrier",
		Callback = function()
        local World = workspace:FindFirstChild("World")

        if World then
            World = workspace.World:FindFirstChild("Barriers")
        end

        if World then
            local GetChildren = World.GetChildren

            for _, v in ipairs(GetChildren(World)) do
                if v:IsA("BasePart") then
                    v20(v.Position + Vector3.new(0, 4, 6))
                    v15("Dungeon", "Teleported to barrier: " .. v.Name)

                    return
                end
            end
        end

        v15("Dungeon", "No barrier found.")
    end
	})
    v45:Button({
		Title = "Teleport to Spawn Point",
		Callback = function()
        local World = workspace:FindFirstChild("World")

        if World then
            World = workspace.World:FindFirstChild("Spawns")
        end

        if World then
            local v419 = World:GetChildren()[1]

            if v419 then
                v20(v419)
                v15("Dungeon", "Teleported to spawn.")

                return
            end
        end

        v15("Dungeon", "No spawn point found.")
    end
	})
    v46:Section({
		Title = "Protection"
	})
    local Part
    local GodPlatform = t1.GodPlatform
    v46:Toggle({
		Title = "God Platform (Sky Safezone)",
		Value = GodPlatform,
		Callback = function(p45)
        t1.GodPlatform = p45
        v36()

        if p45 then
            local v421 = v17()

            if v421 then
                if not Part then
                    Part = Instance.new("Part")
                    Part.Name = "RexHub_GodPlatform"
                    Part.Size = Vector3.new(30, 2, 30)
                    Part.Anchored = true
                    Part.Transparency = 0.5
                    Part.Material = Enum.Material.ForceField
                    Part.Color = Color3.fromRGB(0, 170, 255)
                    Part.Parent = workspace
                end

                Part.CFrame = CFrame.new(v421.Position.X, v421.Position.Y + 35, v421.Position.Z)
                v421.CFrame = Part.CFrame + Vector3.new(0, 3, 0)

                return
            end
        elseif Part then
            Part:Destroy()
        end
    end
	})
    local AutoBlock = t1.AutoBlock
    v46:Toggle({
		Title = "Auto Block",
		Value = AutoBlock,
		Callback = function(p46)
        t1.AutoBlock = p46
        v36()

        local v423 = v32()
        local v424 = v423

        if v424 then
            v424 = v423.setTouchHeld
        end

        if v424 then
            pcall(function()
                v423.setTouchHeld("Block", p46)
            end)

            return
        end

        if characterPackets then
            pcall(function()
                characterPackets.performBlock:fire(p46)
            end)
        end
    end
	})
    local AutoDash = t1.AutoDash
    v46:Toggle({
		Title = "Infinite Dash Spammer",
		Value = AutoDash,
		Callback = function(p47)
        t1.AutoDash = p47
        v36()
    end
	})
    local DisableCollision2 = t1.DisableCollision
    v46:Toggle({
		Title = "Disable Enemy Collision",
		Value = DisableCollision2,
		Callback = function(p48)
        t1.DisableCollision = p48
        v36()
    end
	})
    v47:Section({
		Title = "Enemy ESP"
	})
    local MobESP = t1.MobESP
    v47:Toggle({
		Title = "Mob ESP",
		Value = MobESP,
		Callback = function(p49)
        t1.MobESP = p49
        v36()

        if not p49 then
            local enemies = workspace:FindFirstChild("enemies")

            if enemies then
                for _, child in ipairs(enemies:GetChildren()) do
                    local v431 = child:FindFirstChild("HumanoidRootPart") or child.PrimaryPart

                    if v431 and v431:FindFirstChild("RexHub_ESP") then
                        v431.RexHub_ESP:Destroy()
                    end
                end
            end
        end
    end
	})
    local BossESP = t1.BossESP
    v47:Toggle({
		Title = "Boss Highlight ESP",
		Value = BossESP,
		Callback = function(p50)
        t1.BossESP = p50
        v36()

        if not p50 then
            local enemies = workspace:FindFirstChild("enemies")

            if enemies then
                local GetChildren = enemies.GetChildren

                for _, v in ipairs(GetChildren(enemies)) do
                    local RexHub_BossHL = v:FindFirstChild("RexHub_BossHL")

                    if RexHub_BossHL then
                        RexHub_BossHL:Destroy()
                    end
                end
            end
        end
    end
	})
    v48:Section({
		Title = "Movement"
	})
    local Slider5 = v48.Slider
    local WalkSpeed = t1.WalkSpeed
    local t25 = {
		Min = 16,
		Max = 250,
		Default = WalkSpeed or 16
	}
    Slider5(v48, {
		Title = "WalkSpeed",
		Value = t25,
		Callback = function(p51)
        local v439 = type(p51) == "table"

        if v439 then
            v439 = p51.Default or (p51.Min or 16)
        end

        local v440 = v439 or p51

        t1.WalkSpeed = v440

        local v441 = v18()

        if v441 then
            v441.WalkSpeed = v440
        end

        v36()
    end
	})
    local v125 = t1.JumpPower or 50
    local Slider6 = v48.Slider
    local t26 = {
		Min = 50,
		Max = 300,
		Default = v125
	}
    Slider6(v48, {
		Title = "JumpPower",
		Value = t26,
		Callback = function(p52)
        local v443 = type(p52) == "table"

        if v443 then
            v443 = p52.Default or (p52.Min or 50)
        end

        local v444 = v443 or p52

        t1.JumpPower = v444

        local v445 = v18()

        if v445 then
            v445.UseJumpPower = true
            v445.JumpPower = v444
        end

        v36()
    end
	})
    local Toggle13 = v48.Toggle
    local InfiniteJump = t1.InfiniteJump
    Toggle13(v48, {
		Title = "Infinite Jump",
		Value = InfiniteJump,
		Callback = function(p53)
        t1.InfiniteJump = p53
        v36()
    end
	})
    local Noclip = t1.Noclip
    v48:Toggle({
		Title = "Noclip",
		Value = Noclip,
		Callback = function(p54)
        t1.Noclip = p54
        v36()
    end
	})
    v48:Section({
		Title = "Optimization & Safety"
	})
    local Toggle14 = v48.Toggle
    local AntiAFK = t1.AntiAFK
    Toggle14(v48, {
		Title = "Anti-AFK Protection",
		Value = AntiAFK,
		Callback = function(p55)
        t1.AntiAFK = p55
        v36()
    end
	})
    local Toggle15 = v48.Toggle
    local FPSBoost = t1.FPSBoost
    Toggle15(v48, {
		Title = "FPS Boost (Reduce Graphics)",
		Value = FPSBoost,
		Callback = function(p56)
        t1.FPSBoost = p56
        v36()

        if p56 then
            pcall(function()
                Lighting.GlobalShadows = false
                Lighting.FogEnd = 9000000000
                settings().Rendering.QualityLevel = 1

                for _, descendant in ipairs(workspace:GetDescendants()) do
                    local v980 = descendant:IsA("BasePart")

                    if v980 then
                        v980 = not descendant.Parent:FindFirstChildOfClass("Humanoid")
                    end

                    if v980 then
                        descendant.Material = Enum.Material.SmoothPlastic
                        descendant.CastShadow = false
                    else
                        local v981 = descendant:IsA("Decal")

                        if not v981 then
                            v981 = descendant:IsA("Texture")
                        end

                        if v981 then
                            descendant.Transparency = 1
                        end
                    end
                end
            end)
        end
    end
	})
    local Toggle16 = v48.Toggle
    local BlackScreen = t1.BlackScreen
    Toggle16(v48, {
		Title = "Disable 3D Rendering",
		Value = BlackScreen,
		Callback = function(p57)
        t1.BlackScreen = p57
        v36()
        pcall(function()
            RunService:Set3dRenderingEnabled(not p57)
        end)
    end
	})
    v49:Section({
		Title = "Configuration Manager"
	})
    v49:Button({
		Title = "Save Configuration",
		Callback = function()
        v36()
        v15("Settings", "Dungeon configuration saved.")
    end
	})
    v49:Button({
		Title = "Reload Configuration",
		Callback = function()
        v35()
        v15("Settings", "Dungeon configuration reloaded.")
    end
	})
    local function v137()
        local enemies = workspace:FindFirstChild("enemies")
        if not enemies then
            return nil, nil
        end
        local v452 = v17()
        if not v452 then
            return nil, nil
        end
        local v453
        local v454
        local v456 = enemyStore
        local n2 = 999999
        if v456 then
            v456 = enemyStore.store

            if v456 then
                v456 = enemyStore.store:toTable()
            end
        end
        local v458 = v456 or nil
        local GetChildren = enemies.GetChildren
        for _, v in ipairs(GetChildren(enemies)) do
            local HumanoidRootPart = v:FindFirstChild("HumanoidRootPart")

            if not HumanoidRootPart then
                HumanoidRootPart = v.PrimaryPart

                if not HumanoidRootPart then
                    HumanoidRootPart = v:FindFirstChildWhichIsA("BasePart")
                end
            end

            if HumanoidRootPart and HumanoidRootPart.Parent then
                local num = tonumber(v.Name)
                local v464 = v458

                if v458 then
                    v464 = v458[num]

                    if not v464 then
                        v464 = v458[tostring(num)] or v458[v.Name]
                    end
                end

                local v465

                if v464 and v464.health ~= nil then
                    v465 = v464.health > 0
                else
                    local Humanoid = v:FindFirstChildOfClass("Humanoid")

                    if Humanoid then
                        v465 = Humanoid.Health > 0
                    else
                        v465 = HumanoidRootPart ~= nil and #v:GetChildren() > 2
                    end
                end

                if v465 then
                    local v467 = v.Name:lower():find("boss")

                    if not v467 then
                        v467 = v:GetAttribute("Boss") == true
                    end

                    local str = tostring(workspace:GetAttribute("Mode") or "")
                    local v469 = str:sub(-4) == "raid"
                    local v470 = workspace:GetAttribute("RaidBossGuarded") == true
                    local RaidOathCount = workspace:GetAttribute("RaidOathCount")

                    if RaidOathCount then
                        RaidOathCount = workspace:GetAttribute("RaidOathCount") > 0
                    end

                    local n3 = 0
                    local v473 = str == "trials"
                    local InfinitePrioritizeBoss2 = t1.InfinitePrioritizeBoss

                    if InfinitePrioritizeBoss2 then
                        InfinitePrioritizeBoss2 = v467

                        if v467 then
                            InfinitePrioritizeBoss2 = not v469

                            if InfinitePrioritizeBoss2 then
                                InfinitePrioritizeBoss2 = not v473
                            end
                        end
                    end

                    if InfinitePrioritizeBoss2 then
                        n3 -= 10000
                    else
                        if v473 then
                            v473 = t1.TrialsPrioritizeBoss and v467
                        end

                        if v473 then
                            n3 -= 10000
                        end
                    end

                    if v469 and v467 then
                        n3 += 5000
                    end

                    local v475 = v469

                    if v469 then
                        v475 = t1.RaidSmartTarget and (v470 and v467)
                    end

                    if v475 then
                        n3 += 50000
                    end

                    if v469 then
                        v469 = t1.RaidPrioritizeOath and RaidOathCount
                    end

                    if v469 then
                        local v476 = v.Name:lower()

                        if v476:find("oath") or v476:find("summon") then
                            n3 -= 25000
                        end
                    end

                    local v477 = (HumanoidRootPart.Position - v452.Position).Magnitude + n3

                    if v477 < n2 then
                        v454 = num
                        v453 = v
                        n2 = v477
                    end
                end
            end
        end

        return v453, v454
    end
    local function v138()
        local World = workspace:FindFirstChild("World")
        if World then
            World = workspace.World:FindFirstChild("Map")
        end
        if not World then
            return nil, nil
        end
        local v479 = v17()
        local GetDescendants = World.GetDescendants
        local v481
        local v482
        local n4 = 999999
        for _, v in ipairs(GetDescendants(World)) do
            local RubbleHealth = v:GetAttribute("RubbleHealth")

            if RubbleHealth and RubbleHealth > 0 then
                local Blocker = v:FindFirstChild("Blocker", true)
                local Rubble = v:FindFirstChild("Rubble", true)

                if not Blocker then
                    if Rubble then
                        Rubble = Rubble:FindFirstChildWhichIsA("BasePart")
                    end

                    if not Rubble then
                        Rubble = v:FindFirstChildWhichIsA("BasePart")
                    end

                    Blocker = Rubble
                end

                if Blocker then
                    local v489 = v479

                    if v479 then
                        v489 = (Blocker.Position - v479.Position).Magnitude
                    end

                    local v490 = v489 or 0

                    if v490 < n4 then
                        v481 = v
                        n4 = v490
                        v482 = Blocker
                    end
                end
            end
        end

        return v481, v482
    end
    if game.PlaceId == 109151342576370 then
        task.spawn(function()
            task.wait(1.5)

            local World = workspace:FindFirstChild("World")

            if World then
                World = workspace.World:FindFirstChild("Map")
            end

            if World then
                local v492 = World:GetChildren()[35]

                if v492 then
                    v492 = v492:FindFirstChild("Cube.036")
                end

                local v493 = v492 or World:FindFirstChild("Cube.036", true)

                if v493 then
                    v20(v493.CFrame + Vector3.new(0, 3, 0))
                    v15("Farm", "Teleported to mob farming spot (Cube.036)")
                end
            end
        end)
    end
    local u139
    local s5
    local function v141()
        local v494 = v17()

        if v494 then
            local RexHub_FarmBV = v494:FindFirstChild("RexHub_FarmBV")

            if RexHub_FarmBV then
                RexHub_FarmBV:Destroy()
            end
        end
    end
    task.spawn(function()
        while task.wait(0.1) do
            if t1.AutoFarmMobs then
                local v496, _ = v137()

                if v496 then
                    local HumanoidRootPart = v496:FindFirstChild("HumanoidRootPart")

                    if not HumanoidRootPart then
                        HumanoidRootPart = v496.PrimaryPart

                        if not HumanoidRootPart then
                            HumanoidRootPart = v496:FindFirstChildWhichIsA("BasePart")
                        end
                    end

                    if HumanoidRootPart and HumanoidRootPart.Parent then
                        u139 = HumanoidRootPart
                        s5 = "enemy"
                    else
                        u139 = nil
                        s5 = nil
                    end
                elseif t1.AutoBreakWalls then
                    local v499, v500 = v138()

                    if v499 and v500 then
                        u139 = v500
                        s5 = "wall"
                    else
                        u139 = nil
                        s5 = nil
                    end
                else
                    u139 = nil
                    s5 = nil
                end
            else
                u139 = nil
                s5 = nil
            end

            if not u139 then
                v141()

                local v501 = v32()
                local v502 = v501

                if v502 then
                    v502 = v501.setTouchHeld
                end

                if v502 then
                    pcall(function()
                        v501.setTouchHeld("Attack", false)
                    end)
                end
            end
        end
    end)
    local connection = RunService.Heartbeat:Connect(function(dt)
        local v504 = not t1.AutoFarmMobs
        if not v504 then
            v504 = not u139

            if not v504 then
                v504 = not u139.Parent
            end
        end
        if v504 then
            v141()

            return
        end
        local v505 = v17()
        local v506 = v18()
        local v507 = not v505
        if not v507 then
            v507 = not v506 or v506.Health <= 0
        end
        if v507 then
            v141()

            return
        end
        local RexHub_FarmBV = v505:FindFirstChild("RexHub_FarmBV")
        if not RexHub_FarmBV then
            local BodyVelocity = Instance.new("BodyVelocity")

            BodyVelocity.Name = "RexHub_FarmBV"
            BodyVelocity.MaxForce = Vector3.new(1000000, 1000000, 1000000)
            BodyVelocity.Velocity = Vector3.zero
            BodyVelocity.Parent = v505
        else
            RexHub_FarmBV.Velocity = Vector3.zero
        end
        v506:ChangeState(Enum.HumanoidStateType.RunningNoPhysics)
        v505.AssemblyLinearVelocity = Vector3.zero
        v505.AssemblyAngularVelocity = Vector3.zero
        local cFrame
        if s5 == "enemy" then
            local v511 = math.clamp(tonumber(t1.FarmDistance) or 2.5, 0.5, 60)
            local v512 = u139.CFrame.LookVector * v511
            local str = tostring(workspace:GetAttribute("Mode") or "")
            local v514 = str:sub(-4) == "raid"
            local v515 = str == "trials"

            if v514 then
                v514 = t1.RaidEnrageSafezone

                if v514 then
                    v514 = workspace:GetAttribute("RaidBossEnraged") == true
                end
            end

            if v514 then
                v512 = Vector3.new(0, math.max(12, v511), 0)
            else
                if v515 then
                    v515 = t1.TrialsSafeFly
                end

                if v515 then
                    local v516 = tonumber(t1.TrialsHoverHeight) or 8

                    v512 = Vector3.new(0, v516, 0)
                elseif t1.FarmPosition == "Behind Target" then
                    v512 = u139.CFrame.LookVector * -v511
                elseif t1.FarmPosition == "Above Target" then
                    v512 = Vector3.new(0, v511, 0)
                end
            end

            cFrame = CFrame.lookAt(u139.Position + v512, u139.Position)
        elseif s5 == "wall" then
            local Position = u139.Position
            local v518 = v505.Position - Position
            local Unit = Vector3.new(v518.X, 0, v518.Z).Unit

            if Unit.Magnitude < 0.1 then
                Unit = Vector3.new(0, 0, 1)
            end

            local vector3 = Vector3.new(Position.X + Unit.X * 3.5, Position.Y + 1.5, Position.Z + Unit.Z * 3.5)

            cFrame = CFrame.lookAt(vector3, Vector3.new(Position.X, vector3.Y, Position.Z))
        end
        if cFrame then
            local Magnitude = (v505.Position - cFrame.Position).Magnitude

            if Magnitude > 15 then
                v505.CFrame = cFrame
            elseif Magnitude > 3 then
                local v522 = math.clamp(dt * 20, 0.2, 1)

                v505.CFrame = v505.CFrame:Lerp(cFrame, v522)
            else
                v505.CFrame = cFrame
            end

            if LocalPlayer.Character then
                for _, child in ipairs(LocalPlayer.Character:GetChildren()) do
                    if child:IsA("BasePart") then
                        child.CanCollide = false
                    end
                end
            end
        end
    end)
    table.insert(_G.AnimeZero_Connections, connection)
    task.spawn(function()
        local n5 = 0
        local n6 = 0

        while task.wait(0.08) do
            local AutoFarmMobs5 = t1.AutoFarmMobs

            if AutoFarmMobs5 then
                AutoFarmMobs5 = u139

                if AutoFarmMobs5 then
                    AutoFarmMobs5 = u139.Parent
                end
            end

            if AutoFarmMobs5 then
                local v528 = v32()
                local FastM1Attack2 = t1.FastM1Attack

                if FastM1Attack2 then
                    FastM1Attack2 = v528

                    if FastM1Attack2 then
                        FastM1Attack2 = v528.setTouchHeld
                    end
                end

                if FastM1Attack2 then
                    pcall(function()
                        v528.setTouchHeld("Attack", true)
                    end)
                end

                local AutoSkills2 = t1.AutoSkills

                if AutoSkills2 then
                    AutoSkills2 = v528

                    if AutoSkills2 then
                        AutoSkills2 = v528.performSkill
                    end
                end

                if AutoSkills2 then
                    local elapsed = os.clock()

                    if elapsed - n5 >= 0.25 then
                        n5 = elapsed

                        for i = 1, 4 do
                            local u533 = i
                            pcall(function()
                                v528.performSkill(u533)
                            end)
                        end
                    end
                end

                local v534 = characterPackets

                if v534 then
                    v534 = os.clock() - n6 >= 0.2
                end

                if v534 then
                    n6 = os.clock()
                    pcall(function()
                        characterPackets.performM1:fire()
                    end)

                    if t1.InstantKill then
                        task.defer(function()
                            for _ = 1, tonumber(t1.AttackMultiplier) or 6 do
                                pcall(function()
                                    characterPackets.performM1:fire()
                                end)
                            end
                        end)
                    end
                end
            end
        end
    end)
    task.spawn(function()
        while task.wait(0.4) do
            if t1.AutoCollectDrops and u26 then
                local v535 = u29

                if v535 then
                    v535 = u29.store
                end

                if v535 then
                    local v536 = u29.store:toTable()

                    if type(v536) == "table" then
                        for k, v in pairs(v536) do
                            local v539 = type(v) == "table" and v.id or k

                            pcall(function()
                                u26.recoverDrop:fire(v539)
                            end)
                        end
                    end
                end

                local World = workspace:FindFirstChild("World")

                if World then
                    World = workspace.World:FindFirstChild("Debris")
                end

                if World then
                    local v541 = v17()

                    for _, child in ipairs(World:GetChildren()) do
                        if child:IsA("BasePart") and v541 then
                            child.CFrame = v541.CFrame
                        end
                    end
                end
            end
        end
    end)
    task.spawn(function()
        while task.wait(0.4) do
            local enemies = workspace:FindFirstChild("enemies")

            if enemies then
                local GetChildren = enemies.GetChildren

                for _, v in ipairs(GetChildren(enemies)) do
                    local HumanoidRootPart = v:FindFirstChild("HumanoidRootPart")

                    if HumanoidRootPart then
                        if t1.HitboxExpander then
                            local v549 = t1.HitboxSize or 16

                            HumanoidRootPart.Size = Vector3.new(v549, v549, v549)
                            HumanoidRootPart.Transparency = 0.65
                            HumanoidRootPart.Color = Color3.fromRGB(255, 60, 60)
                            HumanoidRootPart.Material = Enum.Material.ForceField
                            HumanoidRootPart.CanCollide = false
                            HumanoidRootPart.Massless = true
                        else
                            HumanoidRootPart.Size = Vector3.new(2, 2, 1)
                            HumanoidRootPart.Transparency = 1
                        end
                    end

                    if t1.DisableCollision then
                        local GetDescendants = v.GetDescendants

                        for _, v2 in ipairs(GetDescendants(v)) do
                            if v2:IsA("BasePart") then
                                v2.CanCollide = false
                            end
                        end
                    end
                end
            end
        end
    end)
    local function v143(p58)
        if not p58 then
            return false
        end

        pcall(function()
            if getconnections then
                for _, v in ipairs({
					"Activated",
					"MouseButton1Click",
					"MouseButton1Down"
				}) do
                    if p58[v] then
                        for _, v3 in ipairs(getconnections(p58[v])) do
                            local v987 = v3

                            pcall(function()
                                v987:Fire()
                            end)
                        end
                    end
                end
            end

            if firesignal then
                pcall(function()
                    firesignal(p58.Activated)
                end)
                pcall(function()
                    firesignal(p58.MouseButton1Click)
                end)
            end

            local v988 = VirtualInputManager

            if v988 then
                v988 = p58.AbsolutePosition
            end

            if v988 then
                local AbsolutePosition = p58.AbsolutePosition
                local AbsoluteSize = p58.AbsoluteSize
                local v991 = AbsolutePosition.X + AbsoluteSize.X / 2
                local v992 = AbsolutePosition.Y + AbsoluteSize.Y / 2

                VirtualInputManager:SendMouseButtonEvent(v991, v992, 0, true, game, 1)
                task.wait(0.04)
                VirtualInputManager:SendMouseButtonEvent(v991, v992, 0, false, game, 1)
            end
        end)

        return true
    end
    local function v144()
        local PlayerGui2 = LocalPlayer:FindFirstChild("PlayerGui")

        if not PlayerGui2 then
            return nil, nil
        end

        local GetDescendants = PlayerGui2.GetDescendants

        for _, v in ipairs(GetDescendants(PlayerGui2)) do
            local v564 = v:IsA("TextLabel")

            if not v564 then
                v564 = v:IsA("TextBox")
            end

            if not v564 then
                continue
            end

            local vText = v.Text

            if vText and vText ~= "" then
                local v566, v567 = vText:match("[Aa]rea%s*(%d+)%s*/%s*(%d+)")

                if not (v566 and v567) then
                    continue
                end

                return tonumber(v566), tonumber(v567)
            end
        end

        return nil, nil
    end
    local function u145(p59)
        local ray = Ray.new(Vector3.new(p59.X, math.max(p59.Y + 25, 45), p59.Z), Vector3.new(0, -150, 0))
        local _workspace = workspace
        local t27 = { u16() }
        local part, position = _workspace:FindPartOnRayWithIgnoreList(ray, { v1(t27) })

        if part then
            return position + Vector3.new(0, 3.5, 0)
        end

        return Vector3.new(p59.X, math.max(p59.Y, 3.5), p59.Z)
    end
    local function v146(p60)
        local n7 = 11853603
        if game.PlaceId == 109151342576374 then
            local World = workspace:FindFirstChild("World")

            if World then
                World = workspace.World:FindFirstChild("Map")
            end

            if World then
                n7 = World:GetChildren()[35]

                local v571 = n7 and n7:FindFirstChild("Cube.036")

                if not v571 then
                    v571 = (World:FindFirstChild("Cube.036", true))
                end

                if v571 then
                    return v571.CFrame + Vector3.new(0, 3, 0), v571
                end
            end
        end
        local v572 = workspace:FindFirstChild("World") or workspace
        local v573 = tonumber(p60) or 1
        local str = tostring(v573)
        local Areas = v572:FindFirstChild("Areas")
        if not Areas then
            Areas = v572:FindFirstChild("Zones")

            if not Areas then
                Areas = workspace:FindFirstChild("Areas")
            end
        end
        local Spawns = v572:FindFirstChild("Spawns")
        if not Spawns then
            Spawns = workspace:FindFirstChild("Spawns")
        end
        local v577 = Areas
        if Areas then
            v577 = Areas:FindFirstChild(str)

            if not v577 then
                v577 = Areas:FindFirstChild("Area" .. str)

                if not v577 then
                    v577 = Areas:FindFirstChild("Zone" .. str)
                end
            end
        end
        if not v577 and Areas then
            local GetChildren = Areas.GetChildren

            for _, v in ipairs(GetChildren(Areas)) do
                local v581 = str == v.Name

                if not v581 then
                    v581 = v.Name == "Area" .. str

                    if not v581 then
                        v581 = v.Name == "Zone" .. str

                        if not v581 then
                            v581 = v.Name:match("^Area%s*" .. str .. "$")
                        end
                    end
                end

                if v581 then
                    v577 = v

                    break
                end
            end
        end
        if v577 then
            local v582 = v577:IsA("BasePart") and v577.Position

            if not v582 then
                v582 = v577:IsA("Model")

                if v582 then
                    v582 = v577:GetPivot().Position
                end
            end

            if v582 then
                local v583 = u145(v582)

                return CFrame.new(v583), v577
            end
        end
        if Spawns then
            local str4 = Spawns:FindFirstChild(str)

            if not str4 then
                str4 = Spawns:FindFirstChild("Spawn" .. str)

                if not str4 then
                    str4 = Spawns:FindFirstChild("Area" .. str)
                end
            end

            if not str4 then
                for _, child in ipairs(Spawns:GetChildren()) do
                    local v587 = str == child.Name

                    if not v587 then
                        v587 = child.Name == "Spawn" .. str

                        if not v587 then
                            v587 = child.Name:match("^Spawn%s*" .. str .. "$")
                        end
                    end

                    if v587 then
                        str4 = child

                        break
                    end
                end
            end

            if str4 then
                local v588 = v19(str4)

                if v588 then
                    return v588 + Vector3.new(0, 3.5, 0), v577 or str4
                end
            end
        end
        local Barriers = v572:FindFirstChild("Barriers")
        if not Barriers then
            Barriers = workspace:FindFirstChild("Barriers")
        end
        if Barriers then
            local v590 = math.max(1, v573 - 1)
            local v591 = Barriers:FindFirstChild((tostring(v590)))

            if not v591 then
                v591 = Barriers:FindFirstChild("Barrier" .. v590)
            end

            if v591 then
                local v592 = v19(v591)

                if v592 then
                    return v592 * CFrame.new(0, 3.5, -20), v591
                end
            end
        end
        local GetDescendants = v572.GetDescendants
        for _, v in ipairs(GetDescendants(v572)) do
            local v596 = v:IsA("BasePart")

            if not v596 then
                v596 = v:IsA("Model")
            end

            if not v596 then
                continue
            end

            local v597 = v.Name:lower()
            local v598 = v597:find("area")

            if not v598 then
                v598 = v597:find("zone")

                if not v598 then
                    v598 = v597:find("spawn")
                end
            end

            if v598 then
                v598 = v597:find(str)
            end

            if not v598 then
                continue
            end

            local v599 = v:IsA("BasePart") and v.Position

            if not v599 then
                v599 = v:IsA("Model")

                if v599 then
                    v599 = v:GetPivot().Position
                end
            end

            if v599 then
                local v600 = u145(v599)

                return CFrame.new(v600), v
            end
        end

        return nil, nil
    end
    local n8 = 0
    task.spawn(function()
        while task.wait(0.6) do
            local AutoEndScreen = t1.AutoEndScreen

            if AutoEndScreen then
                AutoEndScreen = t1.AutoEndScreen ~= "Disabled"
            end

            if AutoEndScreen then
                local EndScreen = PlayerGui:FindFirstChild("EndScreen")
                local v614 = u30
                if v614 then
                    v614 = u30.store

                    if v614 then
                        v614 = u30.store.state
                    end
                end
                local v615 = EndScreen
                local v616 = v614 or nil
                if EndScreen then
                    v615 = EndScreen.Enabled ~= false
                end
                if not v615 then
                    if v616 then
                        v616 = v616.finishedAt and v616.finishedAt:get() ~= nil
                    end

                    v615 = v616
                end
                if v615 then
                    local AutoEndScreen2 = t1.AutoEndScreen
                    local v618 = u27

                    if v618 then
                        v618 = u27.endAction
                    end

                    if v618 then
                        local v619 = AutoEndScreen2 == "Retry" and 1

                        if not v619 then
                            v619 = if AutoEndScreen2 ~= "Next" then AutoEndScreen2 == "Leave" and 3 else 2
                        end

                        local v620 = v619

                        if v620 then
                            pcall(function()
                                u27.endAction:fire(v620)
                            end)
                        end
                    end

                    if EndScreen and EndScreen.Enabled ~= false then
                        local v621 = false
                        local Holder = EndScreen:FindFirstChild("Holder")

                        if Holder then
                            Holder = Holder:FindFirstChild("ConstraintedHolder")
                        end

                        if Holder then
                            Holder = Holder:FindFirstChild("ButtonsHolder")
                        end

                        if Holder then
                            local v623 = AutoEndScreen2 == "Next" and "NextButton"

                            if not v623 then
                                v623 = AutoEndScreen2 == "Retry" and "RetryButton"

                                if not v623 then
                                    v623 = AutoEndScreen2 == "Leave" and "LeaveButton"
                                end
                            end

                            local v624 = v623 and Holder:FindFirstChild(v623)

                            if v624 then
                                local GuiButton = v624:FindFirstChildWhichIsA("GuiButton", true)

                                if not GuiButton then
                                    GuiButton = v624:IsA("GuiButton") and v624
                                end

                                if GuiButton then
                                    v621 = v143(GuiButton)
                                end
                            end
                        end

                        if not v621 then
                            local v626 = AutoEndScreen2:lower()

                            for _, descendant in ipairs(EndScreen:GetDescendants()) do
                                local v629 = descendant:IsA("GuiButton")

                                if v629 then
                                    v629 = descendant.Name:lower():find(v626)

                                    if not v629 then
                                        v629 = descendant:IsA("TextButton") and descendant.Text:lower():find(v626)
                                    end
                                end

                                if v629 then
                                    v143(descendant)

                                    break
                                end
                            end
                        end
                    end
                end
            end

            local AutoNextWave2 = t1.AutoNextWave

            if not AutoNextWave2 then
                AutoNextWave2 = t1.AutoFarmMobs
            end

            if AutoNextWave2 then
                AutoNextWave2 = os.clock() - n8 > 1.2
            end

            if AutoNextWave2 then
                local EndScreen = PlayerGui:FindFirstChild("EndScreen")
                local v632 = EndScreen and EndScreen.Enabled ~= false
                local v633 = workspace:GetAttribute("Mode") == "infinite"

                if not v633 then
                    v633 = PlayerGui:FindFirstChild("InfiniteSide")

                    if v633 then
                        v633 = PlayerGui.InfiniteSide.Enabled == true
                    end
                end

                local v634 = not v632

                if v634 then
                    v634 = not v633
                end

                if v634 then
                    local v635 = v137()
                    local v636, _ = v138()
                    local v638, v639 = v144()
                    local v640 = u30

                    if v640 then
                        v640 = u30.store

                        if v640 then
                            v640 = u30.store.state
                        end
                    end

                    local v641 = v640 or nil
                    local v642 = v641

                    if v641 then
                        v642 = v641.area

                        if v642 then
                            v642 = tonumber(v641.area:get())
                        end
                    end

                    local v643 = v641

                    if v641 then
                        v643 = v641.areaCount

                        if v643 then
                            v643 = tonumber(v641.areaCount:get())
                        end
                    end

                    local v644 = v641

                    if v641 then
                        v644 = v641.canNext and v641.canNext:get() == true
                    end

                    if v641 then
                        local remaining = v641.remaining

                        if remaining then
                            remaining = tonumber(v641.remaining:get())
                        end

                        v641 = remaining
                    end

                    local v646 = v642

                    if not v642 then
                        v646 = v638 or 1
                    end

                    local v647 = v643 or (v639 or 5)
                    local v648 = v17()

                    if v648 then
                        local v649
                        local v650 = v638
                        if v638 then
                            if v642 then
                                v642 = v642 < v638
                            end

                            v650 = v642
                        end
                        if v650 then
                            v649 = v638
                        elseif v644 then
                            if v646 < v647 then
                                v649 = v646 + 1
                            end
                        else
                            local v651 = not v635

                            if v651 then
                                v651 = not v636

                                if not v651 then
                                    v651 = not t1.AutoBreakWalls
                                end
                            end

                            if v651 then
                                v649 = v638 or v646
                            end
                        end
                        if v649 then
                            local v652, _ = v146(v649)

                            if v652 then
                                local Magnitude = Vector2.new(v648.Position.X - v652.Position.X, v648.Position.Z - v652.Position.Z).Magnitude

                                if Magnitude > 12 then
                                    n8 = os.clock()
                                    v141()
                                    v20(v652)
                                    v15("Progression", "Moving to Area " .. tostring(v649) .. "/" .. tostring(v647))
                                    task.spawn(function()
                                        local v993 = v18()
                                        local v994 = v17()

                                        if v993 and v994 then
                                            v993:ChangeState(Enum.HumanoidStateType.Running)

                                            local LookVector = v994.CFrame.LookVector

                                            for _ = 1, 3 do
                                                if not v994 or not v994.Parent then
                                                    break
                                                end

                                                v994.AssemblyLinearVelocity = LookVector * 18 + Vector3.new(0, -1, 0)
                                                v993:Move(Vector3.new(0, 0, -1), false)
                                                task.wait(0.1)
                                            end

                                            pcall(function()
                                                if VirtualInputManager then
                                                    VirtualInputManager:SendKeyEvent(true, Enum.KeyCode.W, false, game)
                                                    task.wait(0.12)
                                                    VirtualInputManager:SendKeyEvent(false, Enum.KeyCode.W, false, game)
                                                end
                                            end)

                                            if v993 and v993.Parent then
                                                v993:Move(Vector3.zero, false)
                                            end
                                        end
                                    end)
                                else
                                    local v655 = Magnitude <= 12

                                    if v655 then
                                        v655 = not v635

                                        if v655 then
                                            v655 = v641 == 0 or v641 == nil
                                        end
                                    end

                                    if v655 then
                                        n8 = os.clock()
                                        pcall(function()
                                            if VirtualInputManager then
                                                VirtualInputManager:SendKeyEvent(true, Enum.KeyCode.W, false, game)
                                                task.wait(0.15)
                                                VirtualInputManager:SendKeyEvent(false, Enum.KeyCode.W, false, game)
                                            end
                                        end)
                                    end
                                end
                            else
                                local World = workspace:FindFirstChild("World")

                                if World then
                                    World = workspace.World:FindFirstChild("Barriers")
                                end

                                if World and v648 then
                                    local v657
                                    local n9 = 999999
                                    for _, child in ipairs(World:GetChildren()) do
                                        local v661 = v19(child)

                                        if v661 then
                                            local Magnitude = (v648.Position - v661.Position).Magnitude

                                            if Magnitude < n9 and Magnitude > 10 then
                                                v657 = v661
                                                n9 = Magnitude
                                            end
                                        end
                                    end
                                    if v657 and n9 < 300 then
                                        n8 = os.clock()
                                        v141()
                                        v20(v657 * CFrame.new(0, 3.5, -18))
                                    end
                                end
                            end
                        end
                    end
                end
            end
        end
    end)
    task.spawn(function()
        local n10 = 0

        while task.wait(0.5) do
            local v664 = workspace:GetAttribute("Mode") == "infinite"

            if not v664 then
                v664 = PlayerGui:FindFirstChild("InfiniteSide")

                if v664 then
                    v664 = PlayerGui.InfiniteSide.Enabled == true
                end
            end

            if v664 then
                local v665 = v18()
                local v666 = v17()
                local InfiniteLowHpLeave2 = t1.InfiniteLowHpLeave
                if InfiniteLowHpLeave2 then
                    InfiniteLowHpLeave2 = v665 and v665.MaxHealth > 0
                end
                if InfiniteLowHpLeave2 then
                    local v668 = v665.Health / v665.MaxHealth * 100

                    if v668 <= (t1.InfiniteLowHpThreshold or 20) and v668 > 0 then
                        v15("Infinite", "Low HP alert! Triggering emergency leave...")

                        local v669 = u27

                        if v669 then
                            v669 = u27.endAction
                        end

                        if v669 then
                            pcall(function()
                                u27.endAction:fire(3)
                            end)
                        end

                        local InfiniteSide = PlayerGui:FindFirstChild("InfiniteSide")
                        local v671 = InfiniteSide and InfiniteSide:FindFirstChild("Leave", true)

                        if v671 then
                            v143(v671)
                        end

                        task.wait(2)
                    end
                end
                local InfiniteAutoLeave2 = t1.InfiniteAutoLeave
                if InfiniteAutoLeave2 then
                    InfiniteAutoLeave2 = t1.InfiniteTargetWave
                end
                if InfiniteAutoLeave2 then
                    local v673, _, _ = v64()
                    local num = tonumber(v673:match("(%d+)"))
                    local v677 = num

                    if num then
                        v677 = num >= t1.InfiniteTargetWave
                    end

                    if v677 then
                        v15("Infinite", string.format("Target Wave %d reached! Leaving run...", num))

                        local v678 = u27

                        if v678 then
                            v678 = u27.endAction
                        end

                        if v678 then
                            pcall(function()
                                u27.endAction:fire(3)
                            end)
                        end

                        local InfiniteSide = PlayerGui:FindFirstChild("InfiniteSide")

                        if InfiniteSide then
                            InfiniteSide = InfiniteSide:FindFirstChild("Leave", true)
                        end

                        if InfiniteSide then
                            v143(InfiniteSide)
                        end

                        task.wait(3)
                    end
                end
                local InfiniteStayInArena2 = t1.InfiniteStayInArena
                if InfiniteStayInArena2 then
                    InfiniteStayInArena2 = t1.AutoFarmMobs

                    if InfiniteStayInArena2 then
                        InfiniteStayInArena2 = os.clock() - n10 > 3
                    end
                end
                if InfiniteStayInArena2 and (not v137() and v666) then
                    n10 = os.clock()

                    local World = workspace:FindFirstChild("World")

                    if World then
                        World = workspace.World:FindFirstChild("Spawns")
                    end

                    if World then
                        World = World:FindFirstChild("1")
                    end

                    if not World then
                        World = workspace.World

                        if World then
                            World = workspace.World:FindFirstChild("Areas")

                            if World then
                                World = workspace.World.Areas:FindFirstChild("1")
                            end
                        end

                        if not World then
                            World = workspace.World

                            if World then
                                World = workspace.World:FindFirstChild("SpawnLocation")
                            end
                        end
                    end

                    if World then
                        local v682 = v19(World)

                        if v682 and Vector2.new(v666.Position.X - v682.Position.X, v666.Position.Z - v682.Position.Z).Magnitude > 40 then
                            v20(v682 + Vector3.new(0, 3.5, 0))
                        end
                    end
                end
                if t1.InfiniteAutoRetry then
                    local EndScreen = PlayerGui:FindFirstChild("EndScreen")

                    if EndScreen and EndScreen.Enabled ~= false then
                        local v684 = u27

                        if v684 then
                            v684 = u27.endAction
                        end

                        if v684 then
                            pcall(function()
                                u27.endAction:fire(1)
                            end)
                        end
                    end
                end
            end
        end
    end)
    task.spawn(function()
        local n11 = 0
        local n12 = 0

        while task.wait(0.4) do
            local Mode = workspace:GetAttribute("Mode")

            if Mode then
                local v688 = type(Mode) == "string"

                if v688 then
                    v688 = Mode:sub(-4) == "raid"
                end

                Mode = v688
            end

            if Mode then
                local v689 = v17()
                local RaidAutoElevator2 = t1.RaidAutoElevator

                if RaidAutoElevator2 then
                    RaidAutoElevator2 = workspace:GetAttribute("RaidExitOpen") == true

                    if RaidAutoElevator2 then
                        RaidAutoElevator2 = os.clock() - n11 > 1
                    end
                end

                if RaidAutoElevator2 then
                    n11 = os.clock()

                    local World = workspace:FindFirstChild("World")

                    if World then
                        World = World:FindFirstChild("Markers")
                    end

                    local v692 = World

                    if World then
                        v692 = World:FindFirstChild("Exit")
                    end

                    if World then
                        World = World:FindFirstChild("ExitPrompt", true)
                    end

                    if not World then
                        World = v692

                        if v692 then
                            World = v692:FindFirstChildWhichIsA("ProximityPrompt", true)
                        end
                    end

                    local v693 = World

                    if v692 and v689 then
                        v20(v692.CFrame + Vector3.new(0, 3, 0))
                        v15("Raid", "Elevator open! Teleporting to next segment...")
                        task.wait(0.15)

                        if v693 then
                            pcall(function()
                                if fireproximityprompt then
                                    fireproximityprompt(v693)

                                    return
                                end

                                if v693.InputHoldBegin then
                                    v693:InputHoldBegin()
                                    task.wait(v693.HoldDuration + 0.05)
                                    v693:InputHoldEnd()
                                end
                            end)
                        end
                    end
                end

                local RaidSkipCutscenes2 = t1.RaidSkipCutscenes

                if RaidSkipCutscenes2 then
                    RaidSkipCutscenes2 = workspace:GetAttribute("RaidCutscene") ~= nil
                end

                if RaidSkipCutscenes2 then
                    pcall(function()
                        local CurrentCamera = workspace.CurrentCamera
                        local v998 = CurrentCamera

                        if CurrentCamera then
                            v998 = CurrentCamera.CameraType ~= Enum.CameraType.Custom
                        end

                        if v998 then
                            CurrentCamera.CameraType = Enum.CameraType.Custom
                        end
                    end)
                end

                local RaidEndAction = t1.RaidEndAction

                if RaidEndAction then
                    RaidEndAction = t1.RaidEndAction ~= "Disabled"

                    if RaidEndAction then
                        RaidEndAction = os.clock() - n12 > 1.5
                    end
                end

                if RaidEndAction then
                    local EndScreen = PlayerGui:FindFirstChild("EndScreen")
                    local v697 = u30

                    if v697 then
                        v697 = u30.store

                        if v697 then
                            v697 = u30.store.state
                        end
                    end

                    local v698 = v697 or nil

                    if EndScreen then
                        EndScreen = EndScreen.Enabled ~= false
                    end

                    if not EndScreen then
                        if v698 then
                            v698 = v698.finishedAt and v698.finishedAt:get() ~= nil
                        end

                        EndScreen = v698
                    end

                    if EndScreen then
                        n12 = os.clock()

                        local v699 = t1.RaidEndAction == "Retry" and 1

                        if not v699 then
                            v699 = t1.RaidEndAction == "Leave" and 3
                        end

                        local v700 = v699
                        local v701 = v700

                        if v701 then
                            v701 = u27

                            if v701 then
                                v701 = u27.endAction
                            end
                        end

                        if v701 then
                            pcall(function()
                                u27.endAction:fire(v700)
                            end)
                        end
                    end
                end
            end
        end
    end)
    task.spawn(function()
        local n13 = 0
        local n14 = 0
        local n15 = 0

        while task.wait(0.5) do
            if workspace:GetAttribute("Mode") == "trials" then
                local TrialsAutoSkipFloor2 = t1.TrialsAutoSkipFloor

                if TrialsAutoSkipFloor2 then
                    TrialsAutoSkipFloor2 = workspace:GetAttribute("TrialsSkipOpen") == true

                    if TrialsAutoSkipFloor2 then
                        TrialsAutoSkipFloor2 = os.clock() - n13 > 2
                    end
                end

                if TrialsAutoSkipFloor2 then
                    n13 = os.clock()

                    local v706 = u27

                    if v706 then
                        v706 = u27.trialsSkip
                    end

                    if v706 then
                        pcall(function()
                            u27.trialsSkip:fire()
                        end)
                        v15("Trials", "Auto Floor Skip executed!")
                    end
                end

                local TrialsAutoLeaveAtTarget2 = t1.TrialsAutoLeaveAtTarget

                if TrialsAutoLeaveAtTarget2 then
                    TrialsAutoLeaveAtTarget2 = t1.TrialsTargetRoom

                    if TrialsAutoLeaveAtTarget2 then
                        TrialsAutoLeaveAtTarget2 = os.clock() - n14 > 3
                    end
                end

                if TrialsAutoLeaveAtTarget2 then
                    n14 = os.clock()

                    local num = tonumber(workspace:GetAttribute("TrialsRoom") or 1)
                    local v709 = num

                    if num then
                        v709 = num >= t1.TrialsTargetRoom
                    end

                    if v709 then
                        v15("Trials", string.format("Target Room %d reached! Leaving Trials...", num))

                        local v710 = u27

                        if v710 then
                            v710 = u27.endAction
                        end

                        if v710 then
                            pcall(function()
                                u27.endAction:fire(3)
                            end)
                        end

                        local RunSide = PlayerGui:FindFirstChild("RunSide")

                        if RunSide then
                            RunSide = RunSide:FindFirstChild("Leave", true)
                        end

                        if RunSide then
                            v143(RunSide)
                        end

                        task.wait(3)
                    end
                end

                local TrialsAutoRetry2 = t1.TrialsAutoRetry

                if TrialsAutoRetry2 then
                    TrialsAutoRetry2 = os.clock() - n15 > 1.5
                end

                if TrialsAutoRetry2 then
                    local EndScreen = PlayerGui:FindFirstChild("EndScreen")
                    local v714 = u30

                    if v714 then
                        v714 = u30.store

                        if v714 then
                            v714 = u30.store.state
                        end
                    end

                    local v715 = v714 or nil
                    local v716 = EndScreen and EndScreen.Enabled ~= false

                    if not v716 then
                        if v715 then
                            v715 = v715.finishedAt and v715.finishedAt:get() ~= nil
                        end

                        v716 = v715
                    end

                    if v716 then
                        n15 = os.clock()

                        local v717 = u27

                        if v717 then
                            v717 = u27.endAction
                        end

                        if v717 then
                            pcall(function()
                                u27.endAction:fire(1)
                            end)
                        end
                    end
                end

                local World = workspace:FindFirstChild("World")
                local v719 = World and World:FindFirstChild("Barriers")

                if v719 then
                    for _, child in ipairs(v719:GetChildren()) do
                        if child:IsA("BasePart") and child.CanCollide then
                            child.CanCollide = false
                        end
                    end
                end
            end
        end
    end)
    task.spawn(function()
        while task.wait(0.25) do
            if t1.AutoDash and characterPackets then
                pcall(function()
                    characterPackets.performDash:fire()
                end)
            end
        end
    end)
    task.spawn(function()
        while task.wait(0.8) do
            local enemies = workspace:FindFirstChild("enemies")
            if enemies then
                local v724 = enemyStore

                if v724 then
                    v724 = enemyStore.store

                    if v724 then
                        v724 = enemyStore.store:toTable()
                    end
                end

                local v725 = v724 or nil
                local GetChildren = enemies.GetChildren

                for _, v in ipairs(GetChildren(enemies)) do
                    local v729 = v:FindFirstChild("HumanoidRootPart") or v.PrimaryPart
                    local num = tonumber(v.Name)
                    local n16 = 100
                    local n17 = 100
                    local v733 = true
                    local v734 = v725

                    if v725 then
                        v734 = num and v725[num]
                    end

                    if v734 then
                        local health = v725[num].health
                        local v736 = v725[num]

                        n16 = health or 0
                        n17 = v736.maxHealth or 100
                        v733 = n16 > 0
                    else
                        local Humanoid = v:FindFirstChildOfClass("Humanoid")

                        if Humanoid then
                            n16 = Humanoid.Health
                            n17 = Humanoid.MaxHealth
                            v733 = n16 > 0
                        end
                    end

                    if v729 and v733 then
                        local RexHub_ESP = v729:FindFirstChild("RexHub_ESP")

                        if t1.MobESP then
                            if not RexHub_ESP then
                                RexHub_ESP = Instance.new("BillboardGui")
                                RexHub_ESP.Name = "RexHub_ESP"
                                RexHub_ESP.Size = UDim2.fromOffset(130, 42)
                                RexHub_ESP.AlwaysOnTop = true
                                RexHub_ESP.Adornee = v729

                                local TextLabel = Instance.new("TextLabel")

                                TextLabel.Name = "Txt"
                                TextLabel.Size = UDim2.fromScale(1, 1)
                                TextLabel.BackgroundTransparency = 1
                                TextLabel.TextColor3 = Color3.fromRGB(255, 65, 65)
                                TextLabel.TextStrokeTransparency = 0
                                TextLabel.TextSize = 13
                                TextLabel.Font = Enum.Font.GothamBold
                                TextLabel.Parent = RexHub_ESP
                                RexHub_ESP.Parent = v729
                            end

                            local v740 = v17()

                            if v740 then
                                v740 = math.floor((v740.Position - v729.Position).Magnitude)
                            end

                            local v741 = v740 or 0

                            RexHub_ESP.Txt.Text = string.format("Enemy [%s]\nHP: %d/%d (%dm)", v.Name, math.floor(n16), math.floor(n17), v741)
                        elseif RexHub_ESP then
                            RexHub_ESP:Destroy()
                        end

                        local RexHub_BossHL = v:FindFirstChild("RexHub_BossHL")
                        local BossESP2 = t1.BossESP

                        if BossESP2 then
                            BossESP2 = v.Name:lower():find("boss") or n17 > 300
                        end

                        if BossESP2 then
                            if not RexHub_BossHL then
                                local Highlight = Instance.new("Highlight")

                                Highlight.Name = "RexHub_BossHL"
                                Highlight.FillColor = Color3.fromRGB(255, 215, 0)
                                Highlight.OutlineColor = Color3.fromRGB(255, 255, 255)
                                Highlight.Parent = v
                            end
                        elseif RexHub_BossHL then
                            RexHub_BossHL:Destroy()
                        end
                    elseif v729 and v729:FindFirstChild("RexHub_ESP") then
                        v729.RexHub_ESP:Destroy()
                    end
                end
            end
        end
    end)
    local connection2 = LocalPlayer.Idled:Connect(function()
        if t1.AntiAFK then
            VirtualUser:CaptureController()
            VirtualUser:ClickButton2(Vector2.new())
        end
    end)
    table.insert(_G.AnimeZero_Connections, connection2)
    local connection3 = UserInputService.JumpRequest:Connect(function()
        if t1.InfiniteJump then
            local v745 = v18()

            if v745 then
                v745:ChangeState(Enum.HumanoidStateType.Jumping)
            end
        end
    end)
    table.insert(_G.AnimeZero_Connections, connection3)
    local connection4 = RunService.RenderStepped:Connect(function()
        local v746 = v18()

        if v746 then
            local WalkSpeed2 = t1.WalkSpeed

            if WalkSpeed2 then
                WalkSpeed2 = t1.WalkSpeed ~= 16
            end

            if WalkSpeed2 then
                v746.WalkSpeed = t1.WalkSpeed
            end

            local JumpPower = t1.JumpPower

            if JumpPower then
                JumpPower = t1.JumpPower ~= 50
            end

            if JumpPower then
                v746.UseJumpPower = true
                v746.JumpPower = t1.JumpPower
            end
        end
    end)
    table.insert(_G.AnimeZero_Connections, connection4)
    local connection5 = RunService.Stepped:Connect(function()
        local Noclip2 = t1.Noclip

        if Noclip2 then
            Noclip2 = LocalPlayer.Character
        end

        if Noclip2 then
            for _, descendant in ipairs(LocalPlayer.Character:GetDescendants()) do
                if descendant:IsA("BasePart") then
                    descendant.CanCollide = false
                end
            end
        end
    end)
    table.insert(_G.AnimeZero_Connections, connection5)
    print("[Rex Hub] Anime Zero Dungeon Combat Suite loaded.")

    return
end
local lobby = ReplicatedStorage:WaitForChild("lobby", 10)
if not lobby then
    lobby = ReplicatedStorage.lobby
end
local global = ReplicatedStorage:WaitForChild("global", 10)
if not global then
    global = ReplicatedStorage.global
end
local assets = ReplicatedStorage:WaitForChild("assets", 10)
if not assets then
    assets = ReplicatedStorage.assets
end
local v155 = assets
local packets = require(lobby:WaitForChild("packets", 5))
local accountNamespace = require(global:WaitForChild("stores", 5):WaitForChild("accountNamespace", 5))
local skillTreePackets = require(lobby:WaitForChild("modules", 5):WaitForChild("skillTree", 5):WaitForChild("skillTreePackets", 5))
local characterSkillTreeConfig = require(v155:WaitForChild("config", 5):WaitForChild("characterSkillTreeConfig", 5))
local u160
pcall(function()
    local Traits = v155.config:FindFirstChild("Traits")

    if not Traits then
        Traits = v155.config:FindFirstChild("traits")
    end

    if Traits then
        local _require = require
        local traitConfig = Traits:FindFirstChild("traitConfig")

        if not traitConfig then
            traitConfig = Traits:FindFirstChild("TraitConfig")
        end

        u160 = _require(traitConfig)

        return
    end

    u160 = require(v155.config.Traits.traitConfig)
end)
if not u160 then
    pcall(function()
        u160 = require(v155.config.Traits.traitConfig)
    end)
end
local accessoryConfig = require(v155:WaitForChild("config", 5):WaitForChild("accessoryConfig", 5))
local accessoryCraftConfig = require(v155:WaitForChild("config", 5):WaitForChild("accessoryCraftConfig", 5))
local v164 = accessoryCraftConfig
local u163
pcall(function()
    u163 = require(v155.config.economyConfig)
end)
local u165
pcall(function()
    if accountNamespace.getLocalAccount then
        u165 = accountNamespace.getLocalAccount()

        return
    end

    if accountNamespace.getAccount then
        u165 = accountNamespace.getAccount()

        return
    end

    if accountNamespace.currentAccount then
        u165 = accountNamespace.currentAccount

        return
    end

    if accountNamespace.account then
        u165 = accountNamespace.account

        return
    end

    if accountNamespace.store then
        u165 = accountNamespace.store
    end
end)
accountNamespace.onLocalAccountLoad(function(p61)
    u165 = p61
end)
local function v166(p62, p63, p64)
    local v759 = not p62

    if not v759 then
        v759 = type(p62) ~= "table" or #p62 == 0
    end

    if v759 then
        return false
    end

    if p63 then
        p63 = p63:lower():gsub("%s+", "")
    end

    if not p63 then
        p63 = ""
    end

    if p64 then
        p64 = p64:lower():gsub("%s+", "")
    end

    local v760 = p64 or ""

    for _, v in ipairs(p62) do
        if type(v) ~= "string" then
            continue
        end

        local v763 = v:lower():gsub("%s+", "")
        local v764 = v760 ~= ""

        if v764 then
            v764 = v763 == v760

            if not v764 then
                v764 = v763:find("%(" .. v760 .. "%)") or v763:find(v760, 1, true)
            end
        end

        if v764 then
            return true
        end

        if p63 ~= "" then
            local v765 = v763:match("^([^%(]+)") or v763
            local v766 = p63 == v765

            if not v766 then
                v766 = p63:find(v765, 1, true) or v765:find(p63, 1, true)
            end

            if not v766 then
                continue
            end

            return true
        end
    end

    return false
end
local t28 = {
	"RELEASE",
	"AZISOUT",
	"DABITHEGOAT",
	"HOP3YOU3NJOY",
	"HAVESOME",
	"LETSGO",
	"FIRSTUPDATE",
	"Update1",
	"Update2",
	"HYPE",
	"UPDATETHREE",
	"TYASHIRA",
	"TYFRIGID",
	"NEWRAID",
	"SORRYFORDELAY",
	"UPDATESOONWEPROMISE"
}
local t30 = {
	CachedCodes = {},
	KnownCodeMap = {},
	GetRedeemedCodes = function()
    local t29 = {}

    if u165 then
        local v768 = u165:toTable()
        local v769 = v768

        if v768 then
            v769 = type(v768.cdk) == "table"
        end

        if v769 then
            for _, v in ipairs(v768.cdk) do
                t29[string.upper(v)] = true
            end
        end
    end

    return t29
end
}
function t30.ScanInGameCodes()
    local t31 = {}
    local t32 = {}

    for _, v in ipairs(t28) do
        local v776 = string.upper(v)

        if not t32[v776] then
            t32[v776] = true
            table.insert(t31, v776)
        end
    end

    t30.CachedCodes = t31

    return t31
end
function t30.GetAvailableCodes()
    local v777 = #t30.CachedCodes > 0

    if v777 then
        v777 = t30.CachedCodes
    end

    if not v777 then
        v777 = t30.ScanInGameCodes()
    end

    local v778 = t30.GetRedeemedCodes()
    local t33 = {}

    for _, v in ipairs(v777) do
        if not v778[string.upper(v)] then
            table.insert(t33, v)
        end
    end

    return t33
end
function t30.Redeem(p65)
    local v783 = string.upper(p65:match("^%s*(.-)%s*$"))

    packets.redeemCode:fire(v783)

    return true
end
local t34 = {
	GetQuests = function()
    if u165 then
        local v784 = u165:toTable()

        if v784 and v784.quests then
            return v784.quests
        end
    end

    return {}
end
}
function t34.GetCompletedUnclaimed()
    local t35 = {}

    for k, v in pairs(t34.GetQuests()) do
        if type(v) == "table" then
            local v788 = v.claimed == true
            local v789 = v.current or 0
            local v790 = v.target or 1

            if not v788 and v790 <= v789 then
                table.insert(t35, (tostring(k)))
            end
        end
    end

    return t35
end
function t34.Claim(p66)
    packets.claimQuest:fire((tostring(p66)))

    return true
end
function t34.ClaimAll()
    local v792 = t34.GetCompletedUnclaimed()

    for _, v in ipairs(v792) do
        t34.Claim(v)
        task.wait(0.2)
    end

    return true, string.format("Claimed %d quests", #v792)
end
function t34.DeliveryAction(p67)
    packets.deliveryMinigameAction:fire(p67)

    return true
end
local t36 = {
	GetDailyState = function()
    if u165 then
        local v796 = u165:toTable()

        if v796 and v796.dailyLogin then
            return v796.dailyLogin
        end
    end

    return {
			loginProgress = 0,
			lastClaim = 0
		}
end
}
function t36.HasAvailableReward()
    local v797 = t36.GetDailyState()
    local v798 = v797.loginProgress or 0
    local v799 = v797.lastClaim or 0
    local v800 = v798 > 0

    if v800 then
        v800 = os.time() - v799 >= 86400 or v799 == 0
    end

    if v800 then
        return true, v798
    end

    return false, v798
end
function t36.ClaimAvailable()
    local v801, v802 = t36.HasAvailableReward()

    if not v801 then
        return false, "No reward available"
    end

    packets.claimDailyReward:fire()

    return true, string.format("Claimed Day %d", v802)
end
local t37 = {
	ReqCounter = 0,
	Branches = {
		"ATK",
		"CRIT",
		"DEF",
		"SPD"
	},
	GetActiveCharacter = function()
    if u165 then
        local v803 = u165:toTable()

        if v803 and v803.character then
            return tostring(v803.character)
        end
    end

    return "juuzou"
end
}
function t37.GetCharacterSkills(p68)
    if not p68 then
        p68 = t37.GetActiveCharacter()
    end

    if u165 then
        local v805 = u165:toTable()
        local v806 = v805

        if v805 then
            v806 = v805.CharactersData and v805.CharactersData[p68]
        end

        if v806 then
            local Progression = v805.CharactersData[p68].Progression

            if Progression and Progression.Skills then
                return Progression.Skills
            end
        end
    end

    return {
		ATK = 1,
		DEF = 1,
		SPD = 1,
		CRIT = 1
	}
end
function t37.UpgradeSkill(p69, p70)
    if not p69 then
        p69 = t37.GetActiveCharacter()
    end

    local v810 = (t37.GetCharacterSkills(p69)[p70] or 1) + 1

    if v810 > (characterSkillTreeConfig.maxLevel or 110) then
        return false, "Max level reached"
    end

    t37.ReqCounter = t37.ReqCounter % 65535 + 1

    local purchaseCharacterSkill = skillTreePackets.purchaseCharacterSkill
    local ReqCounter = t37.ReqCounter

    purchaseCharacterSkill:fire({
		character = p69,
		branch = p70,
		tier = v810,
		requestId = ReqCounter
	})

    return true, string.format("%s upgraded to Tier %d", p70, v810)
end
function t37.UpgradeAll()
    local v813 = t37.GetActiveCharacter()

    for _, v in ipairs(t37.Branches) do
        t37.UpgradeSkill(v813, v)
        task.wait(0.2)
    end
end
local v172 = u163
if v172 then
    v172 = u163.characterSlotUnlockCosts
end
if not v172 then
    v172 = {
		[2] = 25000,
		[3] = 100000,
		[4] = 1000000
	}
end
local t38 = {
	SelectedSlot = 1,
	SpinMode = "Lucky",
	ReqCounter = 0,
	SlotCosts = v172,
	GetCurrencies = function()
    if u165 then
        local v816 = u165:toTable()

        if v816 and v816.currencies then
            return v816.currencies
        end
    end

    return {
			rolls = 0,
			luckySpins = 0,
			money = 0,
			gems = 0
		}
end
}
function t38.GetSlotsData()
    local t39 = {}
    local v818 = u165 and u165:toTable()

    for i = 1, 4 do
        local v820 = i
        local v821 = "Slot" .. v820
        local v822 = v820 == 1
        local s6 = ""
        local v824 = v818
        local v825 = false

        if v818 then
            v824 = v818.UnlockedCharacters and v818.UnlockedCharacters[v821]
        end

        if v824 then
            local v826 = v818.UnlockedCharacters[v821]

            if not v822 then
                v822 = v826.Unlocked == true
            end

            s6 = tostring(v826.Character or "")
            v825 = v826.Favourite == true
        end

        local v827 = t38.SlotCosts[v820] or 0

        t39[v820] = {
			slot = v820,
			unlocked = v822,
			character = s6,
			favourite = v825,
			cost = v827
		}
    end

    return t39
end
function t38.UnlockSlot(p71)
    local v829 = tonumber(p71) or 2
    local v830 = t38.GetCurrencies()
    local v831 = t38.SlotCosts[v829] or 0

    if v831 > (v830.money or 0) then
        return false, string.format("Required: $%d (Current: $%d)", v831, v830.money or 0)
    end

    t38.ReqCounter = t38.ReqCounter % 65535 + 1

    local unlockCharacterSlot = packets.unlockCharacterSlot
    local v833 = t38
    local fire = unlockCharacterSlot.fire
    local ReqCounter = v833.ReqCounter

    fire(unlockCharacterSlot, {
		slot = v829,
		requestId = ReqCounter
	})

    return true, string.format("Slot %d unlocked", v829)
end
function t38.SetSlotLock(p72, p73)
    t38.ReqCounter = t38.ReqCounter % 65535 + 1

    local setCharacterSlotFavourite = packets.setCharacterSlotFavourite
    local ReqCounter = t38.ReqCounter

    setCharacterSlotFavourite:fire({
		slot = p72,
		favourite = p73,
		requestId = ReqCounter
	})

    return true, string.format("Slot %d lock status updated", p72)
end
function t38.InstantRoll(p74, p75, p76)
    if not p76 then
        p76 = t38.SelectedSlot or 1
    end

    if not p74 then
        p74 = t38.SpinMode
    end

    local v843 = t38.GetSlotsData()
    local v844 = v843[p76]

    if v844 then
        v844 = not v843[p76].unlocked
    end

    if v844 then
        return false, "Slot is locked"
    end

    local v845 = v843[p76]

    if v845 then
        v845 = v843[p76].favourite
    end

    if v845 then
        return false, "Slot unit is locked"
    end

    if not p75 then
        local v846 = t38.GetCurrencies()

        if p74 == "Lucky" then
            p75 = v846.luckySpins

            if p75 then
                p75 = v846.luckySpins > 0 and "luckySpins"
            end

            if not p75 then
                p75 = "gems"
            end
        else
            p75 = v846.rolls

            if p75 then
                p75 = v846.rolls > 0 and "rolls"
            end

            if not p75 then
                p75 = "money"
            end
        end
    end

    t38.ReqCounter = t38.ReqCounter % 65535 + 1

    local rollCharacter = packets.rollCharacter
    local ReqCounter = t38.ReqCounter

    rollCharacter:fire({
		spinType = p74,
		paymentCurrency = p75,
		slot = p76,
		requestId = ReqCounter
	})

    return true
end
function t38.ConvertGemsToSpins(p77)
    t38.ReqCounter = t38.ReqCounter % 65535 + 1

    local convertGemsToLuckySpins = packets.convertGemsToLuckySpins
    local v851 = p77 or 1
    local v852 = t38
    local fire = convertGemsToLuckySpins.fire
    local ReqCounter = v852.ReqCounter

    fire(convertGemsToLuckySpins, {
		amount = v851,
		requestId = ReqCounter
	})

    return true
end
local t40 = {}
for _, v in pairs(u160) do
    if type(v) == "table" and v.Id then
        t40[v.Id] = v
    end
end
local t41 = {
	ReqCounter = 0,
	GetActiveCharacter = function(p78)
    if not p78 then
        p78 = t38.SelectedSlot or 1
    end

    local v856 = "Slot" .. p78

    if u165 then
        local v857 = u165:toTable()
        local v858 = v857

        if v857 then
            v858 = v857.UnlockedCharacters and v857.UnlockedCharacters[v856]
        end

        if v858 then
            local Character = v857.UnlockedCharacters[v856].Character

            if Character and Character ~= "" then
                return string.lower(tostring(Character))
            end
        end

        if v857 and v857.character then
            return string.lower(tostring(v857.character))
        end
    end

    return "guts"
end
}
function t41.GetCharacterTrait(p79)
    local lower = string.lower

    if not p79 then
        p79 = t41.GetActiveCharacter()
    end

    local v862 = lower(p79)

    if u165 then
        local v863 = u165:toTable()

        if v863 and v863.CharactersData then
            local v864 = v863.CharactersData[v862]
            local v865 = v864

            if v864 then
                v865 = v864.TraitData

                if v865 then
                    v865 = v864.TraitData.Trait
                end
            end

            if v865 then
                local v866 = tonumber(v864.TraitData.Trait) or 0
                local v867 = t40[v866]

                if v867 then
                    return v866, v867.Name or "Unknown", v867.Rarity or "None", v867.Weight or 0
                end

                return v866, "Trait #" .. v866, "Unknown", 0
            end
        end
    end

    return 0, "None", "None", 0
end
function t41.GetRerollTokens()
    if u165 then
        local v868 = u165:toTable()
        local v869 = v868

        if v868 then
            v869 = v868.currencies

            if v869 then
                v869 = v868.currencies.traitRerolls
            end
        end

        if v869 then
            return tonumber(v868.currencies.traitRerolls) or 0
        end
    end

    return 0
end
function t41.RollOnce(p80)
    if not p80 then
        p80 = t41.GetActiveCharacter()
    end

    if t41.GetRerollTokens() < 1 then
        return false, "No reroll tokens remaining"
    end

    t41.ReqCounter = t41.ReqCounter % 65535 + 1

    local rollTrait = packets.rollTrait
    local v872 = t41
    local fire = rollTrait.fire
    local ReqCounter = v872.ReqCounter

    fire(rollTrait, {
		character = p80,
		requestId = ReqCounter
	})

    return true
end
function t41.SetPityTarget(p81)
    packets.setTraitPityTarget:fire({
		traitId = p81
	})
end
local t44 = {
	GetRecipes = function()
    local t42 = {}

    for k, v in pairs(v164) do
        local v879 = k
        local v880 = type(v) == "table" and v.CarftID

        if not v880 then
            v880 = tostring(v879)
        end

        local v881 = accessoryConfig[v880]
        local v882 = v881 and v881.Name or "Accessory #" .. tostring(v880)
        local v883 = v881 and v881.Rarity

        if not v883 then
            v883 = "Common"
        end

        table.insert(t42, {
				craftId = tostring(v879),
				name = v882,
				rarity = v883
			})
    end

    table.sort(t42, function(p82, p83)
        return (tonumber(p82.craftId) or 0) < (tonumber(p83.craftId) or 0)
    end)

    return t42
end,
	Craft = function(p84)
    local craftAccessory = packets.craftAccessory
    local t43 = { (tostring(p84)) }

    craftAccessory:fire(v1(t43))

    return true
end
}
local v179 = "AnimeZero_Folder" .. "/Settings.json"
local t45 = {
	AutoClaimQuests = true,
	AutoClaimDaily = true,
	AutoRollCharacter = false,
	CharacterRollMode = "Lucky",
	AutoConvertGems = false,
	TargetRollRarities = {
		"Zenless",
		"Arcane"
	},
	TargetRollCharacters = {},
	AutoLockOnTarget = true,
	AutoRollTraits = false,
	TargetTraitRarities = {
		"Exotic",
		"Legendary"
	},
	TargetTraitNames = {},
	AutoUpgradeSkills = false,
	AutoDelivery = false,
	AutoAFKChamber = false,
	SelectedQueueRoom = "1",
	QueueMap = "Hxh (Hunter x Hunter)",
	QueueGameMode = "Story",
	QueueChapter = "Act 1",
	QueueDifficulty = "Easy",
	QueueMaxPlayers = "4",
	QueueFriendsOnly = false,
	AutoStartQueue = false,
	WalkSpeed = 16,
	JumpPower = 50,
	InfiniteJump = false,
	Noclip = false,
	AntiAFK = true,
	FPSBoost = false,
	BlackScreen = false
}
local u181 = t45
local function v182()
    if isfile and isfile(v179) then
        local ok, result = pcall(function()
            local v1001 = HttpService
            local t46 = { readfile(v179) }

            return v1001:JSONDecode(v1(t46))
        end)

        if ok then
            ok = type(result) == "table"
        end

        if ok then
            for k, v in pairs(result) do
                local v891 = k

                if u181[v891] ~= nil then
                    u181[v891] = v
                end
            end
        end
    end
end
local function v183()
    pcall(function()
        if not isfolder("AnimeZero_Folder") then
            makefolder("AnimeZero_Folder")
        end

        writefile(v179, HttpService:JSONEncode(u181))
    end)
end
v182()
local uDim2 = UDim2.fromOffset(600, 480)
local v185 = v24:CreateWindow({
	Title = "Rex Hub | Anime Zero",
	Icon = "swords",
	Author = "AutoPlay Helper",
	Folder = "AnimeZero_Folder",
	Size = uDim2,
	Transparent = true,
	Theme = "Midnight"
})
local v186 = v185:Tab({
	Title = "Main",
	Icon = "home"
})
local v187 = v185:Tab({
	Title = "Summon",
	Icon = "sparkles"
})
local v188 = v185:Tab({
	Title = "Upgrades",
	Icon = "arrow-up-circle"
})
local v189 = v185:Tab({
	Title = "Dungeon",
	Icon = "swords"
})
local v190 = v185:Tab({
	Title = "Teleport",
	Icon = "map-pin"
})
local v191 = v185:Tab({
	Title = "Player",
	Icon = "user"
})
local v192 = v185:Tab({
	Title = "Settings",
	Icon = "settings"
})
v186:Section({
	Title = "Promo Codes"
})
v186:Button({
	Title = "Redeem Available Codes",
	Callback = function()
    task.spawn(function()
        local v1003 = t30.GetAvailableCodes()

        if #v1003 == 0 then
            v15("Codes", "All codes already redeemed.")

            return
        end

        for _, v in ipairs(v1003) do
            t30.Redeem(v)
            task.wait(0.6)
        end

        v15("Codes", "Finished redeeming codes.")
    end)
end
})
v186:Button({
	Title = "Rescan Codes",
	Callback = function()
    local v892 = t30.ScanInGameCodes()
    local v893 = t30.GetAvailableCodes()

    v15("Codes", string.format("Found %d codes (%d available)", #v892, #v893))
end
})
v186:Section({
	Title = "Quests & Daily Rewards"
})
local Toggle = v186.Toggle
local AutoClaimQuests = u181.AutoClaimQuests
Toggle(v186, {
	Title = "Auto Claim Quests",
	Value = AutoClaimQuests,
	Callback = function(p85)
    u181.AutoClaimQuests = p85
    v183()
end
})
v186:Button({
	Title = "Claim Completed Quests",
	Callback = function()
    local _, v896 = t34.ClaimAll()

    v15("Quests", v896)
end
})
local AutoClaimDaily = u181.AutoClaimDaily
v186:Toggle({
	Title = "Auto Claim Daily Reward",
	Value = AutoClaimDaily,
	Callback = function(p86)
    u181.AutoClaimDaily = p86
    v183()
end
})
v186:Button({
	Title = "Claim Daily Reward",
	Callback = function()
    local _, v899 = t36.ClaimAvailable()

    v15("Daily Reward", v899)
end
})
v186:Section({
	Title = "Lobby Farming"
})
local v196 = u181
local Toggle17 = v186.Toggle
local AutoDelivery = v196.AutoDelivery
Toggle17(v186, {
	Title = "Auto Delivery Quest",
	Value = AutoDelivery,
	Callback = function(p87)
    u181.AutoDelivery = p87
    v183()
end
})
v187:Section({
	Title = "Character Slots"
})
local Dropdown = v187.Dropdown
local v200 = "Slot " .. t38.SelectedSlot
Dropdown(v187, {
	Title = "Target Slot",
	Values = {
		"Slot 1",
		"Slot 2",
		"Slot 3",
		"Slot 4"
	},
	Value = v200,
	Callback = function(p88)
    t38.SelectedSlot = tonumber(p88:match("%d+")) or 1
end
})
v187:Button({
	Title = "Unlock Selected Slot",
	Callback = function()
    local _, v903 = t38.UnlockSlot(t38.SelectedSlot)

    v15("Slots", v903)
end
})
v187:Button({
	Title = "Lock Slot Unit",
	Callback = function()
    t38.SetSlotLock(t38.SelectedSlot, true)
    v15("Slots", "Slot unit locked.")
end
})
v187:Button({
	Title = "Unlock Slot Unit",
	Callback = function()
    t38.SetSlotLock(t38.SelectedSlot, false)
    v15("Slots", "Slot unit unlocked.")
end
})
v187:Section({
	Title = "Roll Actions"
})
local CharacterRollMode = u181.CharacterRollMode
v187:Dropdown({
	Title = "Spin Mode",
	Values = {
		"Lucky",
		"Normal"
	},
	Value = CharacterRollMode,
	Callback = function(p89)
    u181.CharacterRollMode = p89
    t38.SpinMode = p89
    v183()
end
})
v187:Button({
	Title = "Roll 1x",
	Callback = function()
    t38.InstantRoll(u181.CharacterRollMode)
end
})
v187:Button({
	Title = "Roll 10x",
	Callback = function()
    task.spawn(function()
        for _ = 1, 10 do
            t38.InstantRoll(u181.CharacterRollMode)
            task.wait(0.08)
        end
    end)
end
})
local AutoRollCharacter = u181.AutoRollCharacter
local v203 = v187:Toggle({
	Title = "Auto Roll Character",
	Value = AutoRollCharacter,
	Callback = function(p90)
    u181.AutoRollCharacter = p90
    v183()
end
})
local AutoConvertGems = u181.AutoConvertGems
v187:Toggle({
	Title = "Auto Convert Gems to Lucky Spins",
	Value = AutoConvertGems,
	Callback = function(p91)
    u181.AutoConvertGems = p91
    v183()
end
})
v187:Section({
	Title = "Target Stopping Filters"
})
local v205 = u181.TargetRollRarities or {
	"Zenless",
	"Arcane"
}
v187:Dropdown({
	Title = "Stop on Rarities",
	Values = {
		"Zenless",
		"Arcane",
		"Mythic",
		"Legendary",
		"Epic"
	},
	Value = v205,
	Multi = true,
	AllowNone = true,
	Callback = function(p92)
    u181.TargetRollRarities = p92
    v183()
end
})
local v206 = u181.TargetRollCharacters or {}
v187:Dropdown({
	Title = "Stop on Specific Characters",
	Values = {
		"sung_jinwoo (Zenless)",
		"sukuna (Arcane)",
		"shanks (Arcane)",
		"katakuri (Arcane)",
		"hutao (Zenless)",
		"miyabi (Zenless)",
		"alucard (Mythic)",
		"saber (Mythic)",
		"guts (Mythic)",
		"nagumo (Legendary)",
		"juuzou (Legendary)",
		"killua (Epic)",
		"goku (Epic)",
		"luffy (Epic)"
	},
	Value = v206,
	Multi = true,
	AllowNone = true,
	Callback = function(p93)
    u181.TargetRollCharacters = p93
    v183()
end
})
local v207 = u181
local Toggle18 = v187.Toggle
local AutoLockOnTarget = v207.AutoLockOnTarget
Toggle18(v187, {
	Title = "Auto Lock Slot Unit on Match",
	Value = AutoLockOnTarget,
	Callback = function(p94)
    u181.AutoLockOnTarget = p94
    v183()
end
})
v188:Section({
	Title = "Skill Tree"
})
v188:Button({
	Title = "Upgrade All Branches",
	Callback = function()
    t37.UpgradeAll()
    v15("Skill Tree", "All skill branches updated.")
end
})
local AutoUpgradeSkills = u181.AutoUpgradeSkills
v188:Toggle({
	Title = "Auto Upgrade Skills",
	Value = AutoUpgradeSkills,
	Callback = function(p95)
    u181.AutoUpgradeSkills = p95
    v183()
end
})
v188:Section({
	Title = "Traits & Enchants"
})
v188:Button({
	Title = "Reroll Trait 1x",
	Callback = function()
    t41.RollOnce()
end
})
local AutoRollTraits = u181.AutoRollTraits
local v212 = v188:Toggle({
	Title = "Auto Reroll Traits",
	Value = AutoRollTraits,
	Callback = function(p96)
    u181.AutoRollTraits = p96
    v183()
end
})
v188:Section({
	Title = "Trait Stopping Filters"
})
local v213 = u181.TargetTraitRarities or {
	"Exotic",
	"Legendary"
}
v188:Dropdown({
	Title = "Stop on Trait Rarities",
	Values = {
		"Exotic",
		"Legendary",
		"Epic",
		"Rare",
		"Uncommon",
		"Common"
	},
	Value = v213,
	Multi = true,
	AllowNone = true,
	Callback = function(p97)
    u181.TargetTraitRarities = p97
    v183()
end
})
local v214 = u181.TargetTraitNames or {}
v188:Dropdown({
	Title = "Stop on Specific Traits",
	Values = {
		"Supernova (Exotic)",
		"Deadeye (Exotic)",
		"Sniper (Legendary)",
		"Ferocity (Legendary)",
		"Hunter (Epic)",
		"Razor Focus (Epic)",
		"Overkill (Epic)",
		"Vitality (Rare)",
		"Power 3 (Rare)",
		"Swift 3 (Rare)",
		"Focus 3 (Rare)",
		"Fortune (Uncommon)",
		"Power 2 (Uncommon)",
		"Swift 2 (Uncommon)",
		"Focus 2 (Uncommon)",
		"Power 1 (Common)",
		"Swift 1 (Common)",
		"Focus 1 (Common)"
	},
	Value = v214,
	Multi = true,
	AllowNone = true,
	Callback = function(p98)
    u181.TargetTraitNames = p98
    v183()
end
})
v188:Dropdown({
	Title = "Pity Target",
	Values = {
		"None",
		"Monarch",
		"Godspeed",
		"Overpower",
		"Solar",
		"Glitched"
	},
	Value = "None",
	Callback = function(p99)
    local t47 = {
			Monarch = 1,
			Godspeed = 2,
			Overpower = 3,
			Solar = 4,
			Glitched = 5
		}

    if t47[p99] then
        t41.SetPityTarget(t47[p99])
    end
end
})
v188:Section({
	Title = "Accessory Crafting"
})
local v215 = t44.GetRecipes()
local t48 = {}
for _, v in ipairs(v215) do
    table.insert(t48, v.craftId .. ": " .. v.name)
end
if #t48 == 0 then
    table.insert(t48, "None")
end
local v219 = v215[1]
if v219 then
    v219 = v215[1].craftId
end
if not v219 then
    v219 = "1"
end
local u220 = v219
local v221 = t48[1]
if not v221 then
    v221 = "1"
end
v188:Dropdown({
	Title = "Select Recipe",
	Values = t48,
	Value = v221,
	Callback = function(p100)
    u220 = p100:match("^(%d+):") or "1"
end
})
v188:Button({
	Title = "Craft Selected Item",
	Callback = function()
    t44.Craft(u220)
    v15("Crafting", "Craft request dispatched.")
end
})
v189:Section({
	Title = "Queue Configuration"
})
local t49 = {
	"Hxh (Hunter x Hunter)",
	"ZZZ World (Infinite)",
	"Trials of Strength (Trials)",
	"Spirit's Bathtub (Raid)",
	"Shadow Gate (Raid)",
	"Sakamoto Days"
}
local function v223()
    local str = tostring(u181.QueueMap or "Hxh")
    local s7 = "Hxh"
    local s8 = "Story"
    local n18 = 1

    if str:find("Hxh") then
        s7 = "Hxh"
        s8 = "Story"
    elseif str:find("ZZZ") or str:find("Zzz") then
        s7 = "Zzz"
        s8 = "Infinite"
        n18 = 0
    else
        local v921 = str:find("Trials")

        if not v921 then
            v921 = str:find("trials")
        end

        if v921 then
            s7 = "trials"
            s8 = "trials"
            n18 = 0
        else
            local v922 = str:find("Bathtub")

            if not v922 then
                v922 = str:find("BathTub") or str:find("Spirit")
            end

            if v922 then
                s7 = "BathTub"
                s8 = "Raid"
                n18 = 0
            elseif str:find("Shadow") or str:find("Solo") then
                s7 = "ShadowGate"
                s8 = "Raid"
                n18 = 0
            elseif str:find("Sakamoto") or str:find("sakamoto") then
                s7 = "sakamoto"
                s8 = "Story"
            end
        end
    end

    local v923 = u181.QueueGameMode or s8

    if v923 == "" or v923 == "Normal" then
        v923 = s8
    end

    if n18 ~= 0 then
        local v924 = tostring(u181.QueueChapter):match("%d+")

        if v924 then
            v924 = tonumber(v924)
        end

        n18 = v924 or 1
    end

    local v925 = ({
		Easy = 1,
		Medium = 2,
		Hard = 3,
		Nightmare = 4
	})[u181.QueueDifficulty] or 1

    if v923 == "Raid" or v923 == "Infinite" then
        v925 = 1
    end

    local v926 = tonumber(u181.SelectedQueueRoom) or 1
    local v927 = tonumber(u181.QueueMaxPlayers) or 4
    local v928 = not not u181.QueueFriendsOnly

    return {
		roomNumber = v926,
		maxPlayers = v927,
		map = s7,
		gamemode = v923,
		friendsOnly = v928,
		difficulty = v925,
		chapter = n18
	}
end
local v224 = u181.QueueMap or t49[1]
v189:Dropdown({
	Title = "Map",
	Values = t49,
	Value = v224,
	Callback = function(p101)
    u181.QueueMap = p101

    if p101:find("ZZZ") then
        u181.QueueGameMode = "Infinite"
        u181.QueueChapter = "None (0)"
    else
        local v930 = p101:find("Trials")

        if not v930 then
            v930 = p101:find("trials")
        end

        if v930 then
            u181.QueueGameMode = "trials"
            u181.QueueChapter = "None (0)"
        else
            local v931 = p101:find("Bathtub")

            if not v931 then
                v931 = p101:find("Shadow")
            end

            if v931 then
                u181.QueueGameMode = "Raid"
                u181.QueueChapter = "None (0)"
            elseif p101:find("Hxh") or p101:find("Sakamoto") then
                u181.QueueGameMode = "Story"

                if u181.QueueChapter == "None (0)" then
                    u181.QueueChapter = "Act 1"
                end
            end
        end
    end

    v183()
end
})
local v225 = u181.QueueGameMode or "Story"
v189:Dropdown({
	Title = "Game Mode",
	Values = {
		"Story",
		"Infinite",
		"trials",
		"Raid",
		"Defense"
	},
	Value = v225,
	Callback = function(p102)
    u181.QueueGameMode = p102
    v183()
end
})
local v226 = u181.QueueChapter or "Act 1"
v189:Dropdown({
	Title = "Chapter / Act",
	Values = {
		"None (0)",
		"Act 1",
		"Act 2",
		"Act 3",
		"Act 4",
		"Act 5"
	},
	Value = v226,
	Callback = function(p103)
    u181.QueueChapter = p103
    v183()
end
})
local v227 = u181.QueueDifficulty or "Easy"
v189:Dropdown({
	Title = "Difficulty",
	Values = {
		"Easy",
		"Medium",
		"Hard",
		"Nightmare"
	},
	Value = v227,
	Callback = function(p104)
    u181.QueueDifficulty = p104
    v183()
end
})
local v228 = u181.SelectedQueueRoom or "1"
v189:Dropdown({
	Title = "Room Number",
	Values = {
		"1",
		"2",
		"3",
		"4",
		"5",
		"6"
	},
	Value = v228,
	Callback = function(p105)
    u181.SelectedQueueRoom = p105
    v183()
end
})
local v229 = u181.QueueMaxPlayers or "4"
v189:Dropdown({
	Title = "Max Players",
	Values = {
		"1",
		"2",
		"3",
		"4",
		"5",
		"6"
	},
	Value = v229,
	Callback = function(p106)
    u181.QueueMaxPlayers = p106
    v183()
end
})
local v230 = u181
local Toggle19 = v189.Toggle
local QueueFriendsOnly = v230.QueueFriendsOnly
Toggle19(v189, {
	Title = "Friends Only (Private Room)",
	Value = QueueFriendsOnly,
	Callback = function(p107)
    u181.QueueFriendsOnly = p107
    v183()
end
})
v189:Section({
	Title = "Match Actions"
})
v189:Button({
	Title = "Join / Create Selected Room",
	Callback = function()
    local v938 = v223()

    packets.createQuque:fire(v938)
    v15("Queue", string.format("Joining Room %d: %s (%s)", v938.roomNumber, tostring(v938.map), (tostring(v938.gamemode))))
end
})
v189:Button({
	Title = "Start Match Immediately",
	Callback = function()
    packets.startQuqueNow:fire()
    v15("Queue", "Match start requested.")
end
})
v189:Button({
	Title = "Leave Queue",
	Callback = function()
    packets.leaveQuque:fire()
    v15("Queue", "Queue cancelled.")
end
})
local AutoStartQueue = u181.AutoStartQueue
v189:Toggle({
	Title = "Auto Start Match when Ready",
	Value = AutoStartQueue,
	Callback = function(p108)
    u181.AutoStartQueue = p108
    v183()
end
})
v190:Section({
	Title = "Areas"
})
local s9 = "SpinArea"
local v235 = s9
v190:Dropdown({
	Title = "Select Area",
	Values = {
		"SpinArea",
		"Story",
		"Traits",
		"Evolutions",
		"Crafting",
		"Achievements",
		"Quests",
		"Titles",
		"AFK",
		"Arsenal",
		"Group",
		"Items"
	},
	Value = v235,
	Callback = function(p109)
    s9 = p109
end
})
v190:Button({
	Title = "Teleport to Area",
	Callback = function()
    pcall(function()
        packets.teleportToArea:fire(s9)
    end)
    task.spawn(function()
        local Systems = workspace:FindFirstChild("Systems")

        if Systems then
            Systems = Systems:FindFirstChild("AreasTeleportLocation")
        end

        if Systems then
            Systems = Systems:FindFirstChild(s9)
        end

        if Systems then
            v20(Systems)
        end
    end)
end
})
v190:Section({
	Title = "NPCs"
})
local s10 = "Sukuna"
local Dropdown2 = v190.Dropdown
local v238 = s10
Dropdown2(v190, {
	Title = "Select NPC",
	Values = {
		"Sukuna",
		"Mob",
		"Frieren",
		"Yuji",
		"Shiny Gojo",
		"MugetsuChris",
		"PrimeVoxel",
		"Heiyun",
		"Delight",
		"rocoper228"
	},
	Value = v238,
	Callback = function(p110)
    s10 = p110
end
})
v190:Button({
	Title = "Teleport to NPC",
	Callback = function()
    pcall(function()
        local Systems = workspace:FindFirstChild("Systems")

        if Systems then
            Systems = Systems:FindFirstChild("NPCS")
        end

        local v1009 = Systems and Systems:FindFirstChild(s10)

        if v1009 then
            v20(v1009)
        end
    end)
end
})
v191:Section({
	Title = "Movement"
})
local Slider = v191.Slider
local WalkSpeed = u181.WalkSpeed
local t50 = {
	Min = 16,
	Max = 250,
	Default = WalkSpeed or 16
}
Slider(v191, {
	Title = "WalkSpeed",
	Value = t50,
	Callback = function(p111)
    local v943 = type(p111) == "table"

    if v943 then
        v943 = p111.Default or (p111.Min or 16)
    end

    local v944 = v943 or p111

    u181.WalkSpeed = v944

    local v945 = v18()

    if v945 then
        v945.WalkSpeed = v944
    end

    v183()
end
})
local Slider7 = v191.Slider
local JumpPower = u181.JumpPower
local t51 = {
	Min = 50,
	Max = 300,
	Default = JumpPower or 50
}
Slider7(v191, {
	Title = "JumpPower",
	Value = t51,
	Callback = function(p112)
    local v947 = type(p112) == "table"

    if v947 then
        v947 = p112.Default or (p112.Min or 50)
    end

    local v948 = v947 or p112

    u181.JumpPower = v948

    local v949 = v18()

    if v949 then
        v949.UseJumpPower = true
        v949.JumpPower = v948
    end

    v183()
end
})
local InfiniteJump = u181.InfiniteJump
v191:Toggle({
	Title = "Infinite Jump",
	Value = InfiniteJump,
	Callback = function(p113)
    u181.InfiniteJump = p113
    v183()
end
})
local Noclip = u181.Noclip
v191:Toggle({
	Title = "Noclip",
	Value = Noclip,
	Callback = function(p114)
    u181.Noclip = p114
    v183()
end
})
v191:Section({
	Title = "Optimization & Safety"
})
local Toggle20 = v191.Toggle
local AntiAFK = u181.AntiAFK
Toggle20(v191, {
	Title = "Anti-AFK Protection",
	Value = AntiAFK,
	Callback = function(p115)
    u181.AntiAFK = p115
    v183()
end
})
local FPSBoost = u181.FPSBoost
v191:Toggle({
	Title = "FPS Boost (Reduce Graphics)",
	Value = FPSBoost,
	Callback = function(p116)
    u181.FPSBoost = p116
    v183()

    if p116 then
        pcall(function()
            Lighting.GlobalShadows = false
            Lighting.FogEnd = 9000000000
            settings().Rendering.QualityLevel = 1

            for _, descendant in ipairs(workspace:GetDescendants()) do
                local v1012 = descendant:IsA("BasePart")

                if v1012 then
                    v1012 = not descendant.Parent:FindFirstChildOfClass("Humanoid")
                end

                if v1012 then
                    descendant.Material = Enum.Material.SmoothPlastic
                    descendant.CastShadow = false
                elseif descendant:IsA("Decal") or descendant:IsA("Texture") then
                    descendant.Transparency = 1
                end
            end
        end)
    end
end
})
local BlackScreen = u181.BlackScreen
v191:Toggle({
	Title = "Disable 3D Rendering",
	Value = BlackScreen,
	Callback = function(p117)
    u181.BlackScreen = p117
    v183()
    pcall(function()
        RunService:Set3dRenderingEnabled(not p117)
    end)
end
})
v192:Section({
	Title = "Configuration Manager"
})
v192:Button({
	Title = "Save Configuration",
	Callback = function()
    v183()
    v15("Settings", "Configuration saved.")
end
})
v192:Button({
	Title = "Reload Configuration",
	Callback = function()
    v182()
    v15("Settings", "Configuration reloaded.")
end
})
local connection = LocalPlayer.Idled:Connect(function()
    if u181.AntiAFK then
        VirtualUser:CaptureController()
        VirtualUser:ClickButton2(Vector2.new())
    end
end)
table.insert(_G.AnimeZero_Connections, connection)
local connection6 = UserInputService.JumpRequest:Connect(function()
    if u181.InfiniteJump then
        local v955 = v18()

        if v955 then
            v955:ChangeState(Enum.HumanoidStateType.Jumping)
        end
    end
end)
table.insert(_G.AnimeZero_Connections, connection6)
local connection7 = RunService.RenderStepped:Connect(function()
    local v956 = v18()

    if v956 then
        local WalkSpeed3 = u181.WalkSpeed

        if WalkSpeed3 then
            WalkSpeed3 = u181.WalkSpeed ~= 16
        end

        if WalkSpeed3 then
            v956.WalkSpeed = u181.WalkSpeed
        end

        local JumpPower2 = u181.JumpPower

        if JumpPower2 then
            JumpPower2 = u181.JumpPower ~= 50
        end

        if JumpPower2 then
            v956.UseJumpPower = true
            v956.JumpPower = u181.JumpPower
        end
    end
end)
table.insert(_G.AnimeZero_Connections, connection7)
local connection8 = RunService.Stepped:Connect(function()
    local Noclip3 = u181.Noclip

    if Noclip3 then
        Noclip3 = LocalPlayer.Character
    end

    if Noclip3 then
        for _, descendant in ipairs(LocalPlayer.Character:GetDescendants()) do
            if descendant:IsA("BasePart") then
                descendant.CanCollide = false
            end
        end
    end
end)
table.insert(_G.AnimeZero_Connections, connection8)
task.spawn(function()
    while task.wait(3.5) do
        if u181.AutoClaimQuests then
            t34.ClaimAll()
        end

        if u181.AutoClaimDaily then
            t36.ClaimAvailable()
        end
    end
end)
local v255 = packets.characterRolled:on(function(p118)
    if p118 and p118.success then
        local str = tostring(p118.character or "")
        local str5 = tostring(p118.rarity or "")
        local num = tonumber(p118.slot)

        if not num then
            num = t38.SelectedSlot or 1
        end

        if (v166(u181.TargetRollRarities, nil, str5) or v166(u181.TargetRollCharacters, str, nil)) and u181.AutoRollCharacter then
            u181.AutoRollCharacter = false

            local v966 = v203

            if v966 then
                v966 = v203.Set
            end

            if v966 then
                pcall(function()
                    v203:Set(false)
                end)
            end

            v183()

            if u181.AutoLockOnTarget then
                t38.SetSlotLock(num, true)
            end

            v15("Summon Target Reached", string.format("Acquired %s (%s) in Slot %d! Auto Roll stopped.", str, str5, num))
        end
    end
end)
table.insert(_G.AnimeZero_Connections, v255)
local v256 = packets.traitRolled:on(function(p119)
    if p119 and p119.success then
        local v968 = t40[p119.traitId]
        local v969 = v968 and v968.Name

        if not v969 then
            v969 = "Trait #" .. tostring(p119.traitId)
        end

        if v968 then
            v968 = v968.Rarity
        end

        if not v968 then
            v968 = "Unknown"
        end

        if (v166(u181.TargetTraitRarities, nil, v968) or v166(u181.TargetTraitNames, v969, nil)) and u181.AutoRollTraits then
            u181.AutoRollTraits = false

            local v970 = v212

            if v970 then
                v970 = v212.Set
            end

            if v970 then
                pcall(function()
                    v212:Set(false)
                end)
            end

            v183()
            v15("Trait Target Reached", string.format("Acquired %s (%s)! Auto Reroll stopped.", v969, v968))
        end
    end
end)
table.insert(_G.AnimeZero_Connections, v256)
task.spawn(function()
    while task.wait(0.5) do
        if u181.AutoRollCharacter then
            t38.InstantRoll(u181.CharacterRollMode)
        end

        if u181.AutoConvertGems then
            t38.ConvertGemsToSpins(1)
        end

        if u181.AutoRollTraits then
            t41.RollOnce()
        end
    end
end)
task.spawn(function()
    while task.wait(2) do
        if u181.AutoUpgradeSkills then
            t37.UpgradeAll()
        end
    end
end)
task.spawn(function()
    while task.wait(1.5) do
        if u181.AutoDelivery then
            t34.DeliveryAction("claim")

            local Systems = workspace:FindFirstChild("Systems")

            if Systems then
                Systems = Systems:FindFirstChild("DeliverySpawns")
            end

            if Systems then
                local GetChildren = Systems.GetChildren

                for _, v in ipairs(GetChildren(Systems)) do
                    if not u181.AutoDelivery then
                        break
                    end

                    v20(v)
                    task.wait(0.3)
                    t34.DeliveryAction("deliver")
                end
            end
        end
    end
end)
task.spawn(function()
    while task.wait(1.5) do
        if u181.AutoStartQueue then
            pcall(function()
                packets.startQuqueNow:fire()
            end)
        end
    end
end)
print("[Rex Hub] Anime Zero Lobby script loaded cleanly.")
