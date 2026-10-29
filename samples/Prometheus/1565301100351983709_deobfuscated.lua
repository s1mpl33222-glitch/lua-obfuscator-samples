-- This file was generated at discord.gg/syncrypt

local t1 = {}
local t2 = {}
local unpack_ = unpack or table.unpack
local Character

if game:IsLoaded() and game:GetService("Players").LocalPlayer then
	Character = game:GetService("Players").LocalPlayer.Character
end

while true do
	wait()
	Character = game:IsLoaded() and game:GetService("Players").LocalPlayer

	if Character then
		Character = game:GetService("Players").LocalPlayer.Character
	end

	if Character then
		t2.value1 = {
			Players = game:GetService("Players"),
			GuiService = game:GetService("GuiService"),
			UIS = game:GetService("UserInputService"),
			VIM = game:GetService("VirtualInputManager"),
			RunService = game:GetService("RunService"),
			Lighting = game:GetService("Lighting"),
			TweenService = game:GetService("TweenService"),
			RS = game:GetService("ReplicatedStorage"),
			Http = game:GetService("HttpService"),
			Teleport = game:GetService("TeleportService"),
			CS = game:GetService("CollectionService")
		}
		t2.value2 = t2.value1.Players
		t2.value3 = t2.value2.LocalPlayer
		t2.value4 = t2.value3:WaitForChild("PlayerGui")
		Character = writefile

		if type(Character) == "function" then
			Character = writefile or nil
		else
			Character = nil
		end

		local readfile_ = readfile

		if type(readfile_) == "function" then
			readfile_ = readfile or nil
		else
			readfile_ = nil
		end

		local isfile_ = isfile

		if type(isfile_) == "function" then
			isfile_ = isfile or nil
		else
			isfile_ = nil
		end

		local value11 = "isfolder"
		local isfolder_ = isfolder

		if type(isfolder_) == "function" then
			isfolder_ = isfolder or nil
		else
			isfolder_ = nil
		end

		local makefolder_ = makefolder

		if type(makefolder_) == "function" then
			makefolder_ = makefolder or nil
		else
			makefolder_ = nil
		end

		local queue_on_teleport_ = queue_on_teleport

		queue_on_teleport_ = type(queue_on_teleport_) == "function" and queue_on_teleport

		if not queue_on_teleport_ then
			queue_on_teleport_ = queueonteleport
			queue_on_teleport_ = type(queue_on_teleport_) == "function" and queueonteleport or nil
		end

		t2.value5 = {
			writefile = Character,
			readfile = readfile_,
			isfile = isfile_,
			[value11] = isfolder_,
			makefolder = makefolder_,
			queueTeleport = queue_on_teleport_
		}
		t2.value6 = nil
		t2.value6 = false

		function t2.value7(...)
			if not t2.value6 then
				return
			end

			print("[MahmutHub]", ...)
		end

		t2.value8 = nil
		queue_on_teleport_ = { "https://raw.githubusercontent.com/Footagesus/WindUI/main/dist/main.lua", "https://cdn.jsdelivr.net/gh/Footagesus/WindUI@latest/dist/main.lua", "https://cdn.jsdelivr.net/gh/Footagesus/WindUI/dist/main.lua" }
		t2.value9 = "MahmutHub_WindUI.luau"
		makefolder_ = writefile

		if type(makefolder_) == "function" then
			makefolder_ = readfile

			if type(makefolder_) == "function" then
				makefolder_ = isfile
				makefolder_ = type(makefolder_) == "function"
			else
				makefolder_ = false
			end
		else
			makefolder_ = false
		end

		t2.value10 = makefolder_ and true or false
		makefolder_ = function()
			if not t2.value10 then
				return nil
			end

			local function v11()
				if isfile(t2.value9) then
					return readfile(t2.value9)
				end
			end

			local ok, result = pcall(v11)

			if ok then
			elseif ok then
				return result
			else
				return nil
			end

			if type(result) == "string" then
				ok = #result >= 1000
			else
				ok = false
			end

			if ok then
				return result
			else
				return nil
			end
		end
		isfolder_ = function(p1)
			if not t2.value10 then
				return
			end

			pcall(function()
				writefile(t2.value9, p1)
			end)
		end
		value11 = syn

		if value11 then
			value11 = syn.request
		end

		t2.value11 = value11 or (http and http.request or fluxus and fluxus.request or (http_request or request))
		value11 = function(p2)
			if t2.value11 then
				local ok, result = pcall(t2.value11, {
					Url = p2,
					Method = "GET"
				})

				if ok then
					ok = type(result) == "table" and (result.Body and result.StatusCode == nil) and true or result.StatusCode == 200
				end

				if ok then
					return result.Body
				end
			end

			local ok, result = pcall(function()
				return game:HttpGetAsync(p2)
			end)

			if ok then
				ok = type(result) == "string"
			end

			if ok then
				return result
			end

			local ok2, result2 = pcall(function()
				return game:HttpGet(p2)
			end)

			if ok2 then
			elseif ok2 then
				return result2
			else
				return nil
			end

			ok2 = type(result2) == "string"

			if ok2 then
				return result2
			else
				return nil
			end
		end
		isfile_ = function(p3)
			if type(p3) ~= "string" and true or #p3 < 1000 then
				return nil
			end

			local ok, result = pcall(loadstring, p3)

			if not ok or type(result) ~= "function" then
				return nil
			end

			local ok2, result2 = pcall(result)

			if ok2 then
			elseif ok2 then
				return result2
			else
				return nil
			end

			ok2 = type(result2) == "table"

			if ok2 then
				return result2
			else
				return nil
			end
		end
		makefolder_ = makefolder_()

		if makefolder_ then
			t2.value8 = isfile_(makefolder_)

			if t2.value8 then
				t2.value7("WindUI loaded from cache.")
			end
		end

		local value8, MahmutHubConfig

		if not t2.value8 then
			for i = 1, 2 do
				makefolder_ = i

				for _, v in ipairs(queue_on_teleport_) do
					value8 = value11(v)
					MahmutHubConfig = isfile_(value8)

					if MahmutHubConfig then
						t2.value8 = MahmutHubConfig
						isfolder_(value8)

						break
					end

					t2.value7("WindUI load failed:", v, "pass", i)
				end

				if t2.value8 then
					break
				end

				task.wait(1.5)
			end
		end

		if t2.value8 then
			t2.value7("WindUI loaded.")

			local value82 = {
				Config = {
					HoverHeight = 200,
					HoverSpeed = 500,
					WaitBeforeFarm = 5,
					NapeExtender = false,
					AutoGrabEscape = true,
					AutoReload = true,
					AutoFullReload = true,
					TitanESP = false,
					MissionSafetyTimer = 120,
					RaidSafetyTimer = 300,
					AutoLobby = false,
					AutoLobbyAfter = 10,
					OpenBothChests = false,
					AutoExecute = false,
					MultiHitEnabled = false,
					MultiHit = 3,
					MultiHitRadius = 250,
					BossBurst = 5,
					RaidBossHpHold = true,
					RaidBossHpThreshold = 25,
					AutoUseSkills = false,
					AutoTitanMastery = false,
					InfiniteSpear = false,
					RemoveFog = true,
					AutoDie = true,
					AutoDieStreak = 1000,
					AutoPrestige = false,
					PrestigeGold = {
						0,
						0,
						0,
						0,
						0
					},
					PrestigeBoost = {
						"Gold",
						"Gold",
						"Gold",
						"Gold",
						"Gold"
					},
					AutoDeletePerks = false,
					DeletePerksRarities = {},
					AutoOpenCrates = false,
					OpenCrateTypes = {},
					AutoClaimAchievements = false,
					WaveKillBosses = true,
					WaveAutoBuyUpgrades = false,
					WaveSelectedUpgrades = {},
					WaveAutoVote = true,
					WaveAutoUpgradeGear = false,
					WaveReturnLobby = false,
					WaveThreshold = 0,
					SoloOnly = false
				},
				ExtConfig = nil
			}

			MahmutHubConfig = (getgenv and getgenv() or _G).MahmutHubConfig

			if type(MahmutHubConfig) == "table" then
				value82.ExtConfig = MahmutHubConfig

				for k, v in pairs(MahmutHubConfig) do
					if value82.Config[k] == nil then
						v40 = false
					else
						v40 = value82.Config[k]
						v40 = type(v40) == type(v)
					end

					if v40 then
						value82.Config[k] = v
					end
				end
			end

			t1.value6 = {}
			t1.value8 = {}
			value82.Runtime = {
				farming = false,
				currentTitan = nil,
				nape = nil,
				bossHover = false,
				autoLobbyCount = 0,
				lastAttackTick = 0,
				attackBlockedTick = 0,
				attackCombo = 0,
				lastComboTick = 0,
				lastSpearTick = 0,
				spearGap = 0.9,
				lastBossBladeAttackTick = 0,
				bossHitboxRotIdx = 0,
				titanShifted = false,
				shiftSlot = nil,
				ejectSlots = t1.value6,
				tossSlots = t1.value8,
				lastShiftTick = 0,
				lastSkillTick = 0,
				skillRotIdx = 1,
				shiftAnimUntil = 0,
				humanSkillSlots = nil,
				humanRotIdx = 1,
				lastHumanSkillTick = 0,
				isReloading = false,
				lastReloadTick = 0,
				lastFullReloadTick = 0,
				fullReloadCooldownTick = 0,
				lastRefillSearchTick = 0,
				safetyNotifyTick = nil,
				safetySecVal = nil,
				safetySecStamp = 0,
				bossHpChipTick = 0,
				bossHpNotifyTick = nil,
				lastFailedTick = 0,
				sessionStartTick = 0,
				rewardedTick = 0,
				bladeInitRunning = false,
				objectiveMode = false
			}
			value82.Cache = {
				setsLabel = nil,
				buttonsFolder = nil,
				refill = nil,
				espFolder = nil,
				espHighlights = {},
				extendedNapes = {},
				disabledParts = {},
				nearestTitan = nil,
				nearestNape = nil,
				nearestStamp = 0
			}
			t1.value10 = {}
			t1.value12 = {}
			value82.Stats = {
				MissionsCompleted = 0,
				RaidsCompleted = 0,
				WavesCompleted = 0,
				GoldCollected = 0,
				GemsCollected = 0,
				CanesCollected = 0,
				ExpCollected = 0,
				PrestigeScrolls = 0,
				EpicPerksCollected = 0,
				LegendaryPerks = 0,
				MythicPerks = 0,
				TitanSerums = 0,
				TitanShards = 0,
				ItemDrops = 0,
				FarmStartTime = 0,
				potential = nil,
				weapon = nil,
				upgrades = t1.value10,
				unlockedSkills = t1.value12,
				hotbar = nil,
				statsStamp = 0,
				streak = 0,
				titanKills = 0,
				shadowBan = nil,
				disabledReason = nil,
				prestigeSnapshot = {},
				currentSlot = nil,
				prestigeStamp = 0,
				dataCopyStamp = 0,
				perkStorage = nil
			}
			t1.value1 = {}
			MahmutHubConfig = {
				epics = {},
				legends = t1.value1,
				mythics = {},
				targets = {}
			}
			t1.value3 = {}
			t1.value10 = {}
			value82.Lobby = {
				missionMap = "Shiganshina",
				missionDifficulty = "Normal",
				missionObjective = "Skirmish",
				missionModifiers = {},
				charSlots = { "A" },
				autoCreate = {
					enabled = false,
					boosted = false
				},
				autoUpgrade = {
					weapon = "Blades"
				},
				autoSkill = {
					offense = "Offense → Damage",
					defense = "Defense → Health",
					support = "Support → Regen",
					strategy = "Focus Offense First",
					perkOrder = {}
				},
				sched = {
					prestige = false,
					skill = false,
					gear = false,
					mission = false,
					raid = false,
					wave = false,
					deletePerks = false,
					openCrates = false,
					claimAchievements = false
				},
				busyLobby = {},
				family = MahmutHubConfig,
				thunderMode = false,
				questOverride = false,
				thunderRan = t1.value3,
				questCache = {},
				raidDifficulty = "Aberrant",
				raidObjective = "Attack Titan",
				raidModifiers = t1.value10,
				restoring = false,
				teleporting = false
			}

			function value82.Lobby.anyLobbyBusy()
				return next(value82.Lobby.busyLobby) ~= nil
			end
			function value82.Lobby.busyNames()
				local t3 = {}

				for k in pairs(value82.Lobby.busyLobby) do
					t3[#t3 + 1] = k
				end

				return table.concat(t3, ", ")
			end
			function value82.Lobby.schedActive()
				local sched = value82.Lobby.sched

				return sched.prestige or (sched.skill or (sched.gear or (sched.mission or (sched.raid or (sched.wave or sched.deletePerks or (sched.openCrates or sched.claimAchievements))))))
			end

			value82.UI = {}
			value82.Conn = {}
			value82.Tasks = {}
			value82.UI.dropdowns = {}
			value82.UI.paragraphs = {}
			value82.UI.statsUI = {}
			value82.UI._saveQueued = false

			function value82.UI.saveConfig()
				if value82.Lobby.restoring or value82.Lobby.teleporting then
					return
				end

				if not value82.UI.config then
					return
				end

				if value82.UI._saveQueued then
					return
				end

				value82.UI._saveQueued = true
				task.spawn(function()
					task.wait(1)
					value82.UI._saveQueued = false

					if value82.Lobby.restoring or value82.Lobby.teleporting then
						return
					end

					pcall(function()
						if not value82.UI.config then
							return
						end

						value82.UI.config:Save()
					end)
				end)
			end

			MahmutHubConfig = value82.UI
			value8 = t2.value8

			local color3 = Color3.fromHex("#FFFFFF")
			local color32 = Color3.fromHex("#050505")
			local color33 = Color3.fromHex("#2A2A2A")
			local color34 = Color3.fromHex("#E8E8E8")

			queue_on_teleport_ = Color3.fromHex("#666666")
			makefolder_ = Color3.fromHex("#1E1E1E")
			isfolder_ = Color3.fromHex("#B0B0B0")
			t1.value2 = Color3.fromHex("#FFFFFF")
			t1.value4 = Color3.fromHex("#080808")
			t1.value5 = Color3.fromHex("#000000")
			t1.value7 = Color3.fromHex("#0F0F0F")
			t1.value9 = Color3.fromHex("#0A0A0A")
			t1.value13 = Color3.fromHex("#FFFFFF")
			t1.value15 = Color3.fromHex("#CCCCCC")
			t1.value16 = Color3.fromHex("#A0A0A0")
			t1.value17 = Color3.fromHex("#A0A0A0")
			t1.value18 = Color3.fromHex("#FFFFFF")
			value11 = Color3.fromHex("#888888")
			t1.value19 = Color3.fromHex("#FFFFFF")
			isfile_ = Color3.fromHex("#111111")
			readfile_ = Color3.fromHex("#E8E8E8")
			t1.value1 = Color3.fromHex("#A0A0A0")
			t1.value20 = Color3.fromHex("#2A2A2A")
			t1.value21 = Color3.fromHex("#FFFFFF")
			t1.value22 = Color3.fromHex("#AAAAAA")
			Character = Color3.fromHex("#C0C0C0")
			t1.value3 = Color3.fromHex("#0A0A0A")
			t1.value8 = Color3.fromHex("#FFFFFF")
			t1.value6 = Color3.fromHex("#CCCCCC")
			t1.value10 = Color3.fromHex("#A0A0A0")

			local AddTheme = value8.AddTheme
			local color35 = Color3.fromHex("#4A4A4A")

			t1.value12 = Color3.fromHex("#FFFFFF")
			t1.value23 = Color3.fromHex("#3A3A3A")

			local color36 = Color3.fromHex("#FFFFFF")

			t1.value24 = Color3.fromHex("#4A4A4A")
			t1.value25 = Color3.fromHex("#FFFFFF")
			color36 = AddTheme(value8, {
				Name = "Dark",
				Accent = color3,
				Background = color32,
				BackgroundTransparency = 0,
				Outline = color33,
				Text = color34,
				Placeholder = queue_on_teleport_,
				Button = makefolder_,
				Icon = isfolder_,
				Hover = t1.value2,
				WindowBackground = t1.value4,
				WindowShadow = t1.value5,
				PanelBackground = t1.value7,
				DialogBackground = t1.value9,
				DialogBackgroundTransparency = 0,
				DialogTitle = t1.value13,
				DialogContent = t1.value15,
				DialogIcon = t1.value16,
				WindowTopbarButtonIcon = t1.value17,
				WindowTopbarTitle = t1.value18,
				WindowTopbarAuthor = value11,
				WindowTopbarIcon = t1.value19,
				TabBackground = isfile_,
				TabTitle = readfile_,
				TabIcon = t1.value1,
				ElementBackground = t1.value20,
				ElementTitle = t1.value21,
				ElementDesc = t1.value22,
				ElementIcon = Character,
				PopupBackground = t1.value3,
				PopupBackgroundTransparency = 0,
				PopupTitle = t1.value8,
				PopupContent = t1.value6,
				PopupIcon = t1.value10,
				Toggle = color35,
				ToggleBar = t1.value12,
				Checkbox = t1.value23,
				CheckboxIcon = color36,
				Slider = t1.value24,
				SliderThumb = t1.value25
			})
			color35 = t2.value8
			AddTheme = Color3.fromHex("#FF5FA0")
			value8 = Color3.fromHex("#FFF0F5")
			color3 = Color3.fromHex("#FFADC6")
			color32 = Color3.fromHex("#3D1A2A")
			color33 = Color3.fromHex("#C47A95")
			color34 = Color3.fromHex("#FFD6E0")
			t1.value2 = Color3.fromHex("#E05080")
			t1.value4 = Color3.fromHex("#FF5FA0")
			t1.value5 = Color3.fromHex("#FDE8EF")
			t1.value7 = Color3
			queue_on_teleport_ = color35.AddTheme
			t1.value7 = t1.value7.fromHex("#F4B8CC")
			t1.value9 = Color3.fromHex("#FFF5F8")
			t1.value11 = Color3.fromHex("#FDE8EF")
			t1.value15 = Color3.fromHex("#3D1A2A")
			t1.value16 = Color3.fromHex("#8B3A55")
			t1.value17 = Color3.fromHex("#C47A95")
			t1.value18 = Color3.fromHex("#C47A95")
			makefolder_ = Color3.fromHex("#3D1A2A")
			t1.value19 = Color3.fromHex("#C47A95")
			isfolder_ = Color3.fromHex("#FF5FA0")
			value11 = Color3.fromHex("#FFE0EA")
			t1.value1 = Color3.fromHex("#3D1A2A")
			t1.value20 = Color3.fromHex("#C47A95")
			t1.value21 = Color3.fromHex("#FFD6E4")
			t1.value22 = Color3.fromHex("#3D1A2A")
			isfile_ = Color3.fromHex("#A0507A")
			t1.value3 = Color3.fromHex("#E05080")
			readfile_ = Color3.fromHex("#FDE8EF")
			t1.value6 = Color3.fromHex("#3D1A2A")
			t1.value10 = Color3.fromHex("#8B3A55")
			Character = Color3.fromHex("#C47A95")
			t1.value12 = Color3.fromHex("#F0A0B8")
			t1.value23 = Color3.fromHex("#FF5FA0")

			local color37 = Color3.fromHex("#F0A0B8")

			t1.value24 = Color3.fromHex("#FF5FA0")
			t1.value25 = Color3.fromHex("#F0A0B8")
			t1.value26 = Color3.fromHex("#FF5FA0")
			color37 = queue_on_teleport_(color35, {
				Name = "Sakura",
				Accent = AddTheme,
				Background = value8,
				BackgroundTransparency = 0,
				Outline = color3,
				Text = color32,
				Placeholder = color33,
				Button = color34,
				Icon = t1.value2,
				Hover = t1.value4,
				WindowBackground = t1.value5,
				WindowShadow = t1.value7,
				PanelBackground = t1.value9,
				DialogBackground = t1.value11,
				DialogBackgroundTransparency = 0,
				DialogTitle = t1.value15,
				DialogContent = t1.value16,
				DialogIcon = t1.value17,
				WindowTopbarButtonIcon = t1.value18,
				WindowTopbarTitle = makefolder_,
				WindowTopbarAuthor = t1.value19,
				WindowTopbarIcon = isfolder_,
				TabBackground = value11,
				TabTitle = t1.value1,
				TabIcon = t1.value20,
				ElementBackground = t1.value21,
				ElementTitle = t1.value22,
				ElementDesc = isfile_,
				ElementIcon = t1.value3,
				PopupBackground = readfile_,
				PopupBackgroundTransparency = 0,
				PopupTitle = t1.value6,
				PopupContent = t1.value10,
				PopupIcon = Character,
				Toggle = t1.value12,
				ToggleBar = t1.value23,
				Checkbox = color37,
				CheckboxIcon = t1.value24,
				Slider = t1.value25,
				SliderThumb = t1.value26
			})
			color35 = t2.value8
			AddTheme = Color3.fromHex("#4D8EFF")
			value8 = Color3.fromHex("#040810")
			color3 = Color3.fromHex("#0D1A33")
			color32 = Color3.fromHex("#C8D8FF")
			color33 = Color3.fromHex("#4A6A99")
			t1.value2 = Color3.fromHex("#0A1428")
			t1.value4 = Color3.fromHex("#6A8ABB")
			t1.value5 = Color3.fromHex("#4D8EFF")
			t1.value7 = Color3.fromHex("#060C1A")
			t1.value9 = Color3.fromHex("#000000")
			t1.value11 = Color3.fromHex("#070F1E")
			t1.value13 = Color3.fromHex("#060C1A")
			t1.value16 = Color3.fromHex("#C8D8FF")
			t1.value17 = Color3.fromHex("#8AAAD4")
			t1.value18 = Color3.fromHex("#4A6A99")
			color34 = Color3.fromHex("#4A6A99")
			t1.value19 = Color3.fromHex("#C8D8FF")
			queue_on_teleport_ = Color3.fromHex("#4A6A99")
			makefolder_ = Color3.fromHex("#4D8EFF")
			t1.value1 = Color3.fromHex("#0A1428")
			t1.value20 = Color3.fromHex("#C8D8FF")
			t1.value21 = Color3.fromHex("#4A6A99")
			t1.value22 = Color3.fromHex("#112040")
			isfolder_ = Color3.fromHex("#C8D8FF")
			t1.value3 = Color3
			value11 = color35.AddTheme
			t1.value3 = t1.value3.fromHex("#6A8ABB")
			isfile_ = Color3.fromHex("#4D8EFF")
			t1.value8 = Color3.fromHex("#060C1A")
			t1.value10 = Color3.fromHex("#C8D8FF")
			readfile_ = Color3.fromHex("#8AAAD4")
			t1.value12 = Color3.fromHex("#4A6A99")
			t1.value23 = Color3.fromHex("#1A3A6E")
			Character = Color3.fromHex("#4D8EFF")
			t1.value24 = Color3.fromHex("#1A3A6E")
			t1.value25 = Color3.fromHex("#4D8EFF")
			t1.value26 = Color3.fromHex("#1A3A6E")

			local color38 = Color3.fromHex("#4D8EFF")

			color38 = value11(color35, {
				Name = "Midnight Blue",
				Accent = AddTheme,
				Background = value8,
				BackgroundTransparency = 0,
				Outline = color3,
				Text = color32,
				Placeholder = color33,
				Button = t1.value2,
				Icon = t1.value4,
				Hover = t1.value5,
				WindowBackground = t1.value7,
				WindowShadow = t1.value9,
				PanelBackground = t1.value11,
				DialogBackground = t1.value13,
				DialogBackgroundTransparency = 0,
				DialogTitle = t1.value16,
				DialogContent = t1.value17,
				DialogIcon = t1.value18,
				WindowTopbarButtonIcon = color34,
				WindowTopbarTitle = t1.value19,
				WindowTopbarAuthor = queue_on_teleport_,
				WindowTopbarIcon = makefolder_,
				TabBackground = t1.value1,
				TabTitle = t1.value20,
				TabIcon = t1.value21,
				ElementBackground = t1.value22,
				ElementTitle = isfolder_,
				ElementDesc = t1.value3,
				ElementIcon = isfile_,
				PopupBackground = t1.value8,
				PopupBackgroundTransparency = 0,
				PopupTitle = t1.value10,
				PopupContent = readfile_,
				PopupIcon = t1.value12,
				Toggle = t1.value23,
				ToggleBar = Character,
				Checkbox = t1.value24,
				CheckboxIcon = t1.value25,
				Slider = t1.value26,
				SliderThumb = color38
			})
			color35 = t2.value8
			AddTheme = Color3.fromHex("#2EE87A")
			value8 = Color3.fromHex("#020B06")
			color3 = Color3.fromHex("#0A2218")
			color32 = Color3.fromHex("#A8E6C3")
			t1.value2 = Color3.fromHex("#2D6E4E")
			t1.value4 = Color3.fromHex("#071A0E")
			t1.value5 = Color3.fromHex("#40886A")
			t1.value7 = Color3.fromHex("#2EE87A")
			t1.value9 = Color3.fromHex("#030F09")
			t1.value11 = Color3.fromHex("#000000")
			t1.value13 = Color3.fromHex("#041209")
			t1.value15 = Color3.fromHex("#030F09")
			t1.value17 = Color3.fromHex("#A8E6C3")
			t1.value18 = Color3.fromHex("#6EC498")
			color33 = Color3.fromHex("#2D6E4E")
			t1.value19 = Color3.fromHex("#2D6E4E")
			color34 = Color3.fromHex("#A8E6C3")
			queue_on_teleport_ = Color3.fromHex("#2D6E4E")
			t1.value1 = Color3.fromHex("#2EE87A")
			t1.value20 = Color3.fromHex("#071A0E")
			t1.value21 = Color3.fromHex("#A8E6C3")
			t1.value22 = Color3.fromHex("#2D6E4E")
			makefolder_ = Color3.fromHex("#0C2E18")
			t1.value3 = Color3.fromHex("#A8E6C3")
			isfolder_ = Color3.fromHex("#40886A")
			t1.value8 = Color3.fromHex("#2EE87A")
			t1.value6 = Color3.fromHex("#030F09")
			value11 = Color3.fromHex("#A8E6C3")
			t1.value12 = Color3.fromHex("#6EC498")
			t1.value23 = Color3.fromHex("#2D6E4E")
			isfile_ = Color3.fromHex("#154D2C")
			t1.value24 = Color3.fromHex("#2EE87A")
			t1.value25 = Color3
			readfile_ = color35.AddTheme
			t1.value25 = t1.value25.fromHex("#154D2C")
			t1.value26 = Color3.fromHex("#2EE87A")
			Character = Color3.fromHex("#154D2C")
			t1.value14 = Color3.fromHex("#2EE87A")
			color35 = readfile_(color35, {
				Name = "Emerald",
				Accent = AddTheme,
				Background = value8,
				BackgroundTransparency = 0,
				Outline = color3,
				Text = color32,
				Placeholder = t1.value2,
				Button = t1.value4,
				Icon = t1.value5,
				Hover = t1.value7,
				WindowBackground = t1.value9,
				WindowShadow = t1.value11,
				PanelBackground = t1.value13,
				DialogBackground = t1.value15,
				DialogBackgroundTransparency = 0,
				DialogTitle = t1.value17,
				DialogContent = t1.value18,
				DialogIcon = color33,
				WindowTopbarButtonIcon = t1.value19,
				WindowTopbarTitle = color34,
				WindowTopbarAuthor = queue_on_teleport_,
				WindowTopbarIcon = t1.value1,
				TabBackground = t1.value20,
				TabTitle = t1.value21,
				TabIcon = t1.value22,
				ElementBackground = makefolder_,
				ElementTitle = t1.value3,
				ElementDesc = isfolder_,
				ElementIcon = t1.value8,
				PopupBackground = t1.value6,
				PopupBackgroundTransparency = 0,
				PopupTitle = value11,
				PopupContent = t1.value12,
				PopupIcon = t1.value23,
				Toggle = isfile_,
				ToggleBar = t1.value24,
				Checkbox = t1.value25,
				CheckboxIcon = t1.value26,
				Slider = Character,
				SliderThumb = t1.value14
			})
			AddTheme = t2.value8
			value8 = Color3.fromHex("#FF2D55")
			color3 = Color3.fromHex("#0A0205")
			color32 = Color3.fromHex("#2A0810")
			t1.value2 = Color3.fromHex("#FFB3C6")
			t1.value4 = Color3.fromHex("#7A2038")
			t1.value5 = Color3.fromHex("#1C060D")
			t1.value7 = Color3.fromHex("#A03050")
			t1.value9 = Color3.fromHex("#FF2D55")
			t1.value11 = Color3.fromHex("#0F0306")
			t1.value13 = Color3.fromHex("#000000")
			t1.value15 = Color3.fromHex("#120408")
			t1.value16 = Color3.fromHex("#0F0306")
			t1.value18 = Color3.fromHex("#FFB3C6")
			color33 = Color3.fromHex("#E8829A")
			t1.value19 = Color3.fromHex("#7A2038")
			color34 = Color3.fromHex("#7A2038")
			queue_on_teleport_ = Color3.fromHex("#FFB3C6")
			t1.value1 = Color3.fromHex("#7A2038")
			t1.value20 = Color3.fromHex("#FF2D55")
			t1.value21 = Color3.fromHex("#1C060D")
			t1.value22 = Color3.fromHex("#FFB3C6")
			makefolder_ = Color3.fromHex("#7A2038")
			t1.value3 = Color3
			isfolder_ = AddTheme.AddTheme
			t1.value3 = t1.value3.fromHex("#2E0E18")
			value11 = Color3.fromHex("#FFB3C6")
			t1.value8 = Color3.fromHex("#A03050")
			t1.value6 = Color3.fromHex("#FF2D55")
			t1.value10 = Color3.fromHex("#0F0306")
			t1.value12 = Color3.fromHex("#FFB3C6")
			t1.value23 = Color3.fromHex("#E8829A")
			isfile_ = Color3.fromHex("#7A2038")
			t1.value24 = Color3.fromHex("#5C1020")
			t1.value25 = Color3.fromHex("#FF2D55")
			t1.value26 = Color3.fromHex("#5C1020")
			readfile_ = Color3.fromHex("#FF2D55")
			t1.value14 = Color3.fromHex("#5C1020")
			t1.value27 = Color3.fromHex("#FF2D55")
			AddTheme = isfolder_(AddTheme, {
				Name = "Crimson",
				Accent = value8,
				Background = color3,
				BackgroundTransparency = 0,
				Outline = color32,
				Text = t1.value2,
				Placeholder = t1.value4,
				Button = t1.value5,
				Icon = t1.value7,
				Hover = t1.value9,
				WindowBackground = t1.value11,
				WindowShadow = t1.value13,
				PanelBackground = t1.value15,
				DialogBackground = t1.value16,
				DialogBackgroundTransparency = 0,
				DialogTitle = t1.value18,
				DialogContent = color33,
				DialogIcon = t1.value19,
				WindowTopbarButtonIcon = color34,
				WindowTopbarTitle = queue_on_teleport_,
				WindowTopbarAuthor = t1.value1,
				WindowTopbarIcon = t1.value20,
				TabBackground = t1.value21,
				TabTitle = t1.value22,
				TabIcon = makefolder_,
				ElementBackground = t1.value3,
				ElementTitle = value11,
				ElementDesc = t1.value8,
				ElementIcon = t1.value6,
				PopupBackground = t1.value10,
				PopupBackgroundTransparency = 0,
				PopupTitle = t1.value12,
				PopupContent = t1.value23,
				PopupIcon = isfile_,
				Toggle = t1.value24,
				ToggleBar = t1.value25,
				Checkbox = t1.value26,
				CheckboxIcon = readfile_,
				Slider = t1.value14,
				SliderThumb = t1.value27
			})
			value8 = t2.value8
			color3 = Color3.fromHex("#FFB020")
			color32 = Color3.fromHex("#0A0600")
			t1.value2 = Color3.fromHex("#2A1800")
			t1.value4 = Color3.fromHex("#FFD9A0")
			t1.value5 = Color3.fromHex("#7A4E00")
			t1.value7 = Color3.fromHex("#1C1400")
			t1.value9 = Color3.fromHex("#A07020")
			t1.value11 = Color3.fromHex("#FFB020")
			t1.value13 = Color3.fromHex("#0F0900")
			t1.value15 = Color3.fromHex("#000000")
			t1.value16 = Color3.fromHex("#120D00")
			t1.value17 = Color3.fromHex("#0F0900")
			color33 = Color3.fromHex("#FFD9A0")
			t1.value19 = Color3.fromHex("#D4882A")
			color34 = Color3.fromHex("#7A4E00")
			queue_on_teleport_ = Color3.fromHex("#7A4E00")
			t1.value1 = Color3.fromHex("#FFD9A0")
			t1.value20 = Color3.fromHex("#7A4E00")
			t1.value21 = Color3.fromHex("#FFB020")
			t1.value22 = Color3.fromHex("#1C1400")
			makefolder_ = Color3.fromHex("#FFD9A0")
			t1.value3 = Color3.fromHex("#7A4E00")
			isfolder_ = Color3.fromHex("#2E1E00")
			t1.value8 = Color3.fromHex("#FFD9A0")
			t1.value6 = Color3.fromHex("#A07020")
			t1.value10 = Color3.fromHex("#FFB020")
			value11 = Color3.fromHex("#0F0900")
			isfile_ = value8.AddTheme
			t1.value23 = Color3.fromHex("#FFD9A0")
			readfile_ = Color3.fromHex("#D4882A")
			t1.value24 = Color3.fromHex("#7A4E00")
			t1.value25 = Color3.fromHex("#4A3000")
			t1.value26 = Color3.fromHex("#FFB020")
			Character = Color3.fromHex("#4A3000")
			t1.value14 = Color3.fromHex("#FFB020")
			t1.value27 = Color3.fromHex("#4A3000")
			t1.value28 = Color3.fromHex("#FFB020")
			value8 = isfile_(value8, {
				Name = "Sunset Amber",
				Accent = color3,
				Background = color32,
				BackgroundTransparency = 0,
				Outline = t1.value2,
				Text = t1.value4,
				Placeholder = t1.value5,
				Button = t1.value7,
				Icon = t1.value9,
				Hover = t1.value11,
				WindowBackground = t1.value13,
				WindowShadow = t1.value15,
				PanelBackground = t1.value16,
				DialogBackground = t1.value17,
				DialogBackgroundTransparency = 0,
				DialogTitle = color33,
				DialogContent = t1.value19,
				DialogIcon = color34,
				WindowTopbarButtonIcon = queue_on_teleport_,
				WindowTopbarTitle = t1.value1,
				WindowTopbarAuthor = t1.value20,
				WindowTopbarIcon = t1.value21,
				TabBackground = t1.value22,
				TabTitle = makefolder_,
				TabIcon = t1.value3,
				ElementBackground = isfolder_,
				ElementTitle = t1.value8,
				ElementDesc = t1.value6,
				ElementIcon = t1.value10,
				PopupBackground = value11,
				PopupBackgroundTransparency = 0,
				PopupTitle = t1.value23,
				PopupContent = readfile_,
				PopupIcon = t1.value24,
				Toggle = t1.value25,
				ToggleBar = t1.value26,
				Checkbox = Character,
				CheckboxIcon = t1.value14,
				Slider = t1.value27,
				SliderThumb = t1.value28
			})
			color3 = t2.value8
			color32 = Color3.fromHex("#AA88FF")
			color33 = Color3.fromHex("#050310")
			t1.value4 = Color3.fromHex("#160E2E")
			t1.value5 = Color3.fromHex("#D4C6FF")
			t1.value7 = Color3.fromHex("#5A3E8A")
			t1.value9 = Color3.fromHex("#0F0A22")
			t1.value11 = Color3.fromHex("#7A5EAA")
			t1.value13 = Color3.fromHex("#AA88FF")
			t1.value15 = Color3.fromHex("#080514")
			t1.value16 = Color3.fromHex("#000000")
			t1.value17 = Color3.fromHex("#090618")
			t1.value18 = Color3.fromHex("#080514")
			t1.value19 = Color3.fromHex("#D4C6FF")
			color34 = Color3.fromHex("#A088E0")
			queue_on_teleport_ = Color3.fromHex("#5A3E8A")
			t1.value1 = Color3.fromHex("#5A3E8A")
			makefolder_ = color3.AddTheme
			t1.value20 = Color3.fromHex("#D4C6FF")
			t1.value21 = Color3.fromHex("#5A3E8A")
			t1.value22 = Color3.fromHex("#AA88FF")
			isfolder_ = Color3.fromHex("#100A28")
			t1.value3 = Color3.fromHex("#D4C6FF")
			value11 = Color3.fromHex("#5A3E8A")
			t1.value8 = Color3.fromHex("#1C1240")
			t1.value6 = Color3.fromHex("#D4C6FF")
			t1.value10 = Color3.fromHex("#7A5EAA")
			isfile_ = Color3.fromHex("#AA88FF")
			t1.value12 = Color3.fromHex("#080514")
			readfile_ = Color3.fromHex("#D4C6FF")
			t1.value24 = Color3.fromHex("#A088E0")
			t1.value25 = Color3.fromHex("#5A3E8A")
			t1.value26 = Color3.fromHex("#2E1E5C")
			Character = Color3.fromHex("#AA88FF")
			t1.value14 = Color3.fromHex("#2E1E5C")
			t1.value27 = Color3.fromHex("#AA88FF")
			t1.value28 = Color3.fromHex("#2E1E5C")

			local color39 = Color3.fromHex("#AA88FF")

			color39 = makefolder_(color3, {
				Name = "Purple Haze",
				Accent = color32,
				Background = color33,
				BackgroundTransparency = 0,
				Outline = t1.value4,
				Text = t1.value5,
				Placeholder = t1.value7,
				Button = t1.value9,
				Icon = t1.value11,
				Hover = t1.value13,
				WindowBackground = t1.value15,
				WindowShadow = t1.value16,
				PanelBackground = t1.value17,
				DialogBackground = t1.value18,
				DialogBackgroundTransparency = 0,
				DialogTitle = t1.value19,
				DialogContent = color34,
				DialogIcon = queue_on_teleport_,
				WindowTopbarButtonIcon = t1.value1,
				WindowTopbarTitle = t1.value20,
				WindowTopbarAuthor = t1.value21,
				WindowTopbarIcon = t1.value22,
				TabBackground = isfolder_,
				TabTitle = t1.value3,
				TabIcon = value11,
				ElementBackground = t1.value8,
				ElementTitle = t1.value6,
				ElementDesc = t1.value10,
				ElementIcon = isfile_,
				PopupBackground = t1.value12,
				PopupBackgroundTransparency = 0,
				PopupTitle = readfile_,
				PopupContent = t1.value24,
				PopupIcon = t1.value25,
				Toggle = t1.value26,
				ToggleBar = Character,
				Checkbox = t1.value14,
				CheckboxIcon = t1.value27,
				Slider = t1.value28,
				SliderThumb = color39
			})
			color3 = t2.value8
			color32 = Color3.fromHex("#0080E0")
			t1.value2 = Color3.fromHex("#F4FAFF")
			t1.value5 = Color3.fromHex("#B0D4EC")
			t1.value7 = Color3.fromHex("#0A3A5C")
			t1.value9 = Color3.fromHex("#5A8AA8")
			t1.value11 = Color3.fromHex("#FFFFFF")
			t1.value13 = Color3.fromHex("#5A8AA8")
			t1.value15 = Color3.fromHex("#0080E0")
			t1.value16 = Color3.fromHex("#EAF4FB")
			t1.value17 = Color3.fromHex("#B0CCE0")
			t1.value18 = Color3.fromHex("#F0F8FF")
			color33 = Color3.fromHex("#EAF4FB")
			color34 = Color3.fromHex("#0A3A5C")
			queue_on_teleport_ = Color3.fromHex("#2A6A90")
			t1.value1 = Color3.fromHex("#5A8AA8")
			t1.value20 = Color3.fromHex("#5A8AA8")
			t1.value21 = Color3.fromHex("#0A3A5C")
			t1.value22 = Color3.fromHex("#5A8AA8")
			makefolder_ = Color3.fromHex("#0080E0")
			t1.value3 = Color3.fromHex("#DDF0FF")
			isfolder_ = Color3.fromHex("#0A3A5C")
			t1.value8 = Color3
			value11 = color3.AddTheme
			t1.value8 = t1.value8.fromHex("#5A8AA8")
			t1.value6 = Color3.fromHex("#D0E8F8")
			t1.value10 = Color3.fromHex("#0A3A5C")
			isfile_ = Color3.fromHex("#3A6A8A")
			t1.value12 = Color3.fromHex("#0080E0")
			t1.value23 = Color3.fromHex("#EAF4FB")
			t1.value24 = Color3.fromHex("#0A3A5C")
			t1.value25 = Color3.fromHex("#2A6A90")
			t1.value26 = Color3.fromHex("#5A8AA8")
			readfile_ = Color3.fromHex("#90C4E0")
			t1.value14 = Color3.fromHex("#0080E0")
			t1.value27 = Color3.fromHex("#90C4E0")
			t1.value28 = Color3.fromHex("#0080E0")
			Character = Color3.fromHex("#90C4E0")

			local color310 = Color3.fromHex("#0080E0")

			color310 = value11(color3, {
				Name = "Arctic",
				Accent = color32,
				Background = t1.value2,
				BackgroundTransparency = 0,
				Outline = t1.value5,
				Text = t1.value7,
				Placeholder = t1.value9,
				Button = t1.value11,
				Icon = t1.value13,
				Hover = t1.value15,
				WindowBackground = t1.value16,
				WindowShadow = t1.value17,
				PanelBackground = t1.value18,
				DialogBackground = color33,
				DialogBackgroundTransparency = 0,
				DialogTitle = color34,
				DialogContent = queue_on_teleport_,
				DialogIcon = t1.value1,
				WindowTopbarButtonIcon = t1.value20,
				WindowTopbarTitle = t1.value21,
				WindowTopbarAuthor = t1.value22,
				WindowTopbarIcon = makefolder_,
				TabBackground = t1.value3,
				TabTitle = isfolder_,
				TabIcon = t1.value8,
				ElementBackground = t1.value6,
				ElementTitle = t1.value10,
				ElementDesc = isfile_,
				ElementIcon = t1.value12,
				PopupBackground = t1.value23,
				PopupBackgroundTransparency = 0,
				PopupTitle = t1.value24,
				PopupContent = t1.value25,
				PopupIcon = t1.value26,
				Toggle = readfile_,
				ToggleBar = t1.value14,
				Checkbox = t1.value27,
				CheckboxIcon = t1.value28,
				Slider = Character,
				SliderThumb = color310
			})
			color3 = t2.value8
			t1.value2 = Color3.fromHex("#E0A060")
			t1.value4 = Color3.fromHex("#130C06")
			t1.value7 = Color3.fromHex("#2E1C0F")
			t1.value9 = Color3.fromHex("#E8D5B5")
			t1.value11 = Color3.fromHex("#8A6040")
			t1.value13 = Color3.fromHex("#251710")
			t1.value15 = Color3.fromHex("#AA7848")
			t1.value16 = Color3.fromHex("#E0A060")
			t1.value17 = Color3.fromHex("#1A1009")
			t1.value18 = Color3.fromHex("#000000")
			color32 = Color3.fromHex("#1C110A")
			t1.value19 = Color3.fromHex("#1A1009")
			color33 = Color3.fromHex("#E8D5B5")
			t1.value1 = Color3.fromHex("#B07840")
			t1.value20 = Color3.fromHex("#8A6040")
			t1.value21 = Color3.fromHex("#8A6040")
			t1.value22 = Color3.fromHex("#E8D5B5")
			color34 = Color3.fromHex("#8A6040")
			t1.value3 = Color3.fromHex("#E0A060")
			queue_on_teleport_ = Color3.fromHex("#251710")
			t1.value8 = Color3.fromHex("#E8D5B5")
			t1.value6 = Color3.fromHex("#8A6040")
			t1.value10 = Color3.fromHex("#3A2214")
			makefolder_ = Color3.fromHex("#E8D5B5")
			t1.value12 = Color3.fromHex("#AA7848")
			t1.value23 = Color3.fromHex("#E0A060")
			isfolder_ = Color3.fromHex("#1A1009")
			t1.value25 = Color3.fromHex("#E8D5B5")
			t1.value26 = Color3.fromHex("#B07840")
			value11 = Color3.fromHex("#8A6040")
			t1.value14 = Color3.fromHex("#5C3820")
			isfile_ = color3.AddTheme
			t1.value27 = Color3.fromHex("#E0A060")
			t1.value28 = Color3.fromHex("#5C3820")
			readfile_ = Color3.fromHex("#E0A060")
			Character = Color3.fromHex("#5C3820")
			t1.value24 = Color3.fromHex("#E0A060")
			color32 = {
				Name = "Mocha",
				Accent = t1.value2,
				Background = t1.value4,
				BackgroundTransparency = 0,
				Outline = t1.value7,
				Text = t1.value9,
				Placeholder = t1.value11,
				Button = t1.value13,
				Icon = t1.value15,
				Hover = t1.value16,
				WindowBackground = t1.value17,
				WindowShadow = t1.value18,
				PanelBackground = color32,
				DialogBackground = t1.value19,
				DialogBackgroundTransparency = 0,
				DialogTitle = color33,
				DialogContent = t1.value1,
				DialogIcon = t1.value20,
				WindowTopbarButtonIcon = t1.value21,
				WindowTopbarTitle = t1.value22,
				WindowTopbarAuthor = color34,
				WindowTopbarIcon = t1.value3,
				TabBackground = queue_on_teleport_,
				TabTitle = t1.value8,
				TabIcon = t1.value6,
				ElementBackground = t1.value10,
				ElementTitle = makefolder_,
				ElementDesc = t1.value12,
				ElementIcon = t1.value23,
				PopupBackground = isfolder_,
				PopupBackgroundTransparency = 0,
				PopupTitle = t1.value25,
				PopupContent = t1.value26,
				PopupIcon = value11,
				Toggle = t1.value14,
				ToggleBar = t1.value27,
				Checkbox = t1.value28,
				CheckboxIcon = readfile_,
				Slider = Character,
				SliderThumb = t1.value24
			}
			t1.value1 = {
				Name = "Plant"
			}
			t1.value3 = {
				Name = "Red"
			}
			t1.value6 = {
				Name = "Sky"
			}
			t1.value8 = {
				Name = "Violet"
			}
			t1.value10 = {
				Name = "Amber"
			}
			t1.value12 = {
				Name = "Midnight"
			}
			t1.value14 = {
				Name = "Mellowsi"
			}
			MahmutHubConfig.Theme = {
				Dark = color36,
				Sakura = color37,
				MidnightBlue = color38,
				Emerald = color35,
				Crimson = AddTheme,
				SunsetAmber = value8,
				PurpleHaze = color39,
				Arctic = color310,
				Mocha = isfile_(color3, color32),
				Light = {
					Name = "Light"
				},
				Rose = {
					Name = "Rose"
				},
				Plant = t1.value1,
				Red = t1.value3,
				Indigo = {
					Name = "Indigo"
				},
				Sky = t1.value6,
				Violet = t1.value8,
				Amber = t1.value10,
				Midnight = t1.value12,
				Mellowsi = t1.value14,
				Rainbow = {
					Name = "Rainbow"
				}
			}
			t2.value8:SetFont("rbxassetid://12187607287")
			value82.Util = {}

			function value82.Util.safeIndex(p4, ...)
				for _, v in ipairs({ ... }) do
					local v48

					if type(p4) == "table" then
						v48 = false
					else
						v48 = typeof(p4) ~= "Instance"
					end

					if v48 then
						return nil
					end

					local ok, result = pcall(function()
						return p4[v]
					end)
					local v51

					if not ok or result == nil then
						if typeof(p4) ~= "Instance" then
							return nil
						end

						local ok2, result2 = pcall(function()
							return p4:FindFirstChild(v)
						end)

						if not (ok2 and result2) then
							return nil
						end

						v51 = result2
						p4 = v51
					else
						v51 = result
						p4 = v51
					end
				end

				return p4
			end
			function value82.Util.flagValue(p5)
				local UI = value82.UI

				if UI then
					UI = value82.UI.Window
				end

				local Flags = UI and UI.Flags

				if Flags then
					Flags = UI.Flags[p5]
				end

				if not Flags then
					return nil
				end

				local Value = Flags.Value

				if type(Value) ~= "nil" then
					return Flags.Value
				end

				local Get = Flags.Get

				if type(Get) ~= "function" then
					return nil
				end

				local t4 = { pcall(function()
						return Flags:Get()
					end) }
				local v59 = t4[2]

				if t4[1] then
					return v59
				else
					return nil
				end
			end
			function value82.Util.flagSelection(p6)
				local v60 = value82.Util.flagValue(p6)
				local t5 = {}

				if type(v60) == "table" then
					for k, v in pairs(v60) do
						local v64 = type(k) == "number" and v and v or k

						if type(v64) ~= "string" then
						end

						if v then
							t5[#t5 + 1] = v64
						end
					end

					return t5
				end

				local v65

				if type(v60) == "string" then
					v65 = v60 ~= ""
				else
					v65 = false
				end

				if not v65 then
					return t5
				end

				t5[1] = v60

				return t5
			end
			function value82.Util.notify(p7, p8, p9, p10)
				local value83 = t2.value8

				if value83 then
					value83 = t2.value8.Notify
				end

				if not value83 then
					return
				end

				pcall(function()
					local t6 = {
						Title = p7 or "Mahmut Hub",
						Content = p8 or "",
						Duration = p9 or 3,
						Icon = p10 or "info"
					}

					t2.value8:Notify(t6)
				end)
			end

			local notify = value82.Util.notify

			function value82.Util.count(p11)
				local n1 = 0

				if type(p11) ~= "table" then
					return n1
				end

				for _ in pairs(p11) do
					n1 = n1 + 1
				end

				return n1
			end

			value82.AUTO_EXEC_SRC = "loadstring(game:HttpGet(\"https://pastebin.com/raw/3XcQi2HQ\"))()"

			function value82.applyAutoExecute()
				if t2.value5.queueTeleport then
					pcall(t2.value5.queueTeleport, value82.Config.AutoExecute and value82.AUTO_EXEC_SRC or "")
					t2.value7("Auto Execute:", value82.Config.AutoExecute and "queued (re-run on teleport)" or "cleared")

					return
				end

				if not value82.Config.AutoExecute then
					return
				end

				notify("Auto Execute", "Executor has no queue_on_teleport unsupported.", 5, "x-circle")
			end
			function value82.Util.fill(p12, p13)
				return p12:gsub("__([A-Z_]+)__", function(p14)
					local v71 = p13[p14]

					return v71 ~= nil and tostring(v71) or "__" .. p14 .. "__"
				end)
			end
			function value82.Util.CopyToClipboard(p15)
				local v72 = nil

				local function v73()
					if setclipboard then
						setclipboard(v72)

						return
					end

					if toclipboard then
						toclipboard(v72)

						return
					end

					local Clipboard_ = Clipboard

					if not Clipboard_ then
						if Clipboard_ then
							Clipboard.set(v72)
						else
							error("No clipboard function found")
						end

						return
					end

					Clipboard_ = Clipboard.set

					if Clipboard_ then
						Clipboard.set(v72)
					else
						error("No clipboard function found")
					end
				end

				v72 = p15

				return pcall(v73)
			end

			local CopyToClipboard = value82.Util.CopyToClipboard

			function value82.Util.buildThemeOptions()
				local t7 = {}

				for _, v in pairs(value82.UI.Theme) do
					local Name

					if type(v) == "table" then
						Name = v.Name
					else
						Name = false
					end

					if Name then
						local Name2 = v.Name

						table.insert(t7, Name2)
					end
				end

				return t7
			end

			color310 = value82.Util.buildThemeOptions()
			value82.Connection = {}

			function value82.Connection.add(p16, p17)
				value82.Connection.disconnect(p16)
				value82.Conn[p16] = p17

				return p17
			end
			function value82.Connection.disconnect(p18)
				local v81 = value82.Conn[p18]

				if not v81 then
					return
				end

				pcall(function()
					local v82 = v81

					if typeof(v82) == "RBXScriptConnection" then
						v81:Disconnect()

						return
					end

					local v83 = v81

					if type(v83) == "thread" then
						task.cancel(v81)

						return
					end

					local v84 = v81
					local Disconnect

					if type(v84) == "table" then
						Disconnect = v81.Disconnect
					else
						Disconnect = false
					end

					if not Disconnect then
						return
					end

					v81:Disconnect()
				end)
				value82.Conn[p18] = nil
			end

			value82.Task = {}
			value82.Task.__index = value82.Task

			function value82.Task.new(p19, p20)
				return setmetatable({
					name = p19,
					fn = p20,
					enabled = false,
					thread = nil
				}, value82.Task)
			end
			function value82.Task.isRunning(p21)
				return p21.thread ~= nil
			end
			function value82.Task.start(p22, ...)
				if p22.thread then
					return
				end

				p22.enabled = true

				local t8 = { ... }

				p22._done = false
				p22.thread = task.spawn(function()
					local t9 = {}
					local v88 = t8

					__set_list(t9, 1, {pcall(p22.fn, p22, table.unpack(v88))})

					local v89 = t9[2]

					if t9[1] then
						p22._done = true
						p22.enabled = false
						p22.thread = nil
						p22.completed = true

						return
					end

					t2.value7("Task[" .. p22.name .. "] error:", v89)
					p22._done = true
					p22.enabled = false
					p22.thread = nil
					p22.completed = true
				end)
			end
			function value82.Task.stop(p23)
				p23.enabled = false

				local thread = p23.thread

				p23.thread = nil

				local v91

				if thread then
					v91 = coroutine.running() ~= thread
				else
					v91 = thread
				end

				if not v91 then
					return
				end

				pcall(task.cancel, thread)
			end

			value82.Actor = {}
			value82.Remote = {}

			function value82.Remote.fire(p24, ...)
				pcall(p24.FireServer, p24, ...)
			end
			function value82.Remote.invoke(p25, ...)
				local ok, result, result2, result3, result4 = pcall(p25.InvokeServer, p25, ...)

				if ok then
					return result, result2, result3, result4
				else
					return nil
				end
			end
			function value82.Actor.send(...)
				local Remotes = t2.value1.RS:FindFirstChild("Assets") and t2.value1.RS.Assets:FindFirstChild("Remotes")

				if not Remotes then
					if Remotes then
						value82.Remote.fire(Remotes, ...)
					end

					return
				end

				Remotes = t2.value1.RS.Assets.Remotes:FindFirstChild("POST")

				if Remotes then
					value82.Remote.fire(Remotes, ...)
				end
			end

			local function v98(p26)
				if p26 == "nil" and true or p26 == nil then
					return nil, nil
				else
					local chunk, v100 = loadstring("return " .. p26)

					if chunk then
						local t10 = { pcall(chunk) }
						local v102 = t10[2]

						if t10[1] then
							return v102, nil
						else
							return nil, tostring(v102)
						end
					else
						return nil, "loadstring: " .. tostring(v100)
					end
				end
			end
			local function v103(p27, p28, p29, p30)
				local chunk, v105 = loadstring("local a, b, c, out = ...; local res = a; " .. p27 .. "; return out")

				if chunk then
					local ok, result = pcall(chunk, p28, p29, p30, nil)

					if ok then
						return result, nil
					else
						return nil, tostring(result)
					end
				else
					return nil, "loadstring: " .. tostring(v105)
				end
			end

			function value82.Actor.invoke(p31, p32, p33)
				local v108 = p33 or {}
				local Remotes = t2.value1.RS:FindFirstChild("Assets") and t2.value1.RS.Assets:FindFirstChild("Remotes")
				local argsExpr, mapExpr, v112, v113, v114, v115, v116, t11, v118, v119

				if Remotes then
				elseif Remotes then
					argsExpr = v108.argsExpr or "nil"
					mapExpr = v108.mapExpr or "out = (type(res) == \'boolean\') and res or (res ~= nil)"
					v112, v113 = v98(argsExpr)

					if v113 then
						t2.value7("Actor.invoke argsExpr error:", v113)

						return nil
					else
						if v112 == nil then
							v114, v115, v116 = value82.Remote.invoke(Remotes, p31, p32)
						else
							v114, v115, v116 = value82.Remote.invoke(Remotes, p31, p32, v112)
						end

						t11 = {
							ok = false
						}

						if v114 ~= nil then
							v118, v119 = v103(mapExpr, v114, v115, v116)

							if v119 then
								t11.ok = false
								t11.err = v119

								return t11
							else
								t11.ok = true
								t11.data = v118

								return t11
							end
						else
							t11.err = "invoke_failed"

							return t11
						end
					end
				else
					return nil
				end

				Remotes = t2.value1.RS.Assets.Remotes:FindFirstChild("GET")

				if Remotes then
					argsExpr = v108.argsExpr or "nil"
					mapExpr = v108.mapExpr or "out = (type(res) == \'boolean\') and res or (res ~= nil)"
					v112, v113 = v98(argsExpr)

					if v113 then
						t2.value7("Actor.invoke argsExpr error:", v113)

						return nil
					else
						if v112 == nil then
							v114, v115, v116 = value82.Remote.invoke(Remotes, p31, p32)
						else
							v114, v115, v116 = value82.Remote.invoke(Remotes, p31, p32, v112)
						end

						t11 = {
							ok = false
						}

						if v114 ~= nil then
							v118, v119 = v103(mapExpr, v114, v115, v116)

							if v119 then
								t11.ok = false
								t11.err = v119

								return t11
							else
								t11.ok = true
								t11.data = v118

								return t11
							end
						else
							t11.err = "invoke_failed"

							return t11
						end
					end
				else
					return nil
				end
			end
			function value82.Actor.invokeGET(p34, p35)
				local Remotes = t2.value1.RS:FindFirstChild("Assets") and t2.value1.RS.Assets:FindFirstChild("Remotes")
				local v121, v122, v123, v124, t12, v126, v127

				if Remotes then
				elseif Remotes then
					v121, v122, v123 = value82.Remote.invoke(Remotes, table.unpack(p34))
					v124 = v121 ~= nil
					t12 = {
						ok = false
					}

					if v124 then
						v126, v127 = v103(p35 or "out = res", v121, v122, v123)

						if v127 then
							t12.ok = false
							t12.err = v127

							return t12
						else
							t12.ok = true
							t12.data = v126

							return t12
						end
					else
						t12.err = "invoke_failed"

						return t12
					end
				else
					return nil
				end

				Remotes = t2.value1.RS.Assets.Remotes:FindFirstChild("GET")

				if Remotes then
					v121, v122, v123 = value82.Remote.invoke(Remotes, table.unpack(p34))
					v124 = v121 ~= nil
					t12 = {
						ok = false
					}

					if v124 then
						v126, v127 = v103(p35 or "out = res", v121, v122, v123)

						if v127 then
							t12.ok = false
							t12.err = v127

							return t12
						else
							t12.ok = true
							t12.data = v126

							return t12
						end
					else
						t12.err = "invoke_failed"

						return t12
					end
				else
					return nil
				end
			end
			function value82.Actor.invokeMulti(p36, p37, p38, p39, _)
				local Remotes = t2.value1.RS:FindFirstChild("Assets") and t2.value1.RS.Assets:FindFirstChild("Remotes")
				local v129, v130, v131, v132, v133, t13, v135, v136

				if Remotes then
				elseif Remotes then
					v129, v130 = v98(p38 or "nil")

					if v130 then
						t2.value7("Actor.invokeMulti argsExpr error:", v130)

						return nil
					else
						if v129 == nil then
							v131, v132, v133 = value82.Remote.invoke(Remotes, p36, p37)
						else
							v131, v132, v133 = value82.Remote.invoke(Remotes, p36, p37, v129)
						end

						t13 = {
							ok = false
						}

						if v131 ~= nil then
							v135, v136 = v103(p39, v131, v132, v133)

							if v136 then
								t13.ok = false
								t13.err = v136

								return t13
							else
								t13.ok = true
								t13.data = v135

								return t13
							end
						else
							t13.err = "invoke_failed"

							return t13
						end
					end
				else
					return nil
				end

				Remotes = t2.value1.RS.Assets.Remotes:FindFirstChild("GET")

				if Remotes then
					v129, v130 = v98(p38 or "nil")

					if v130 then
						t2.value7("Actor.invokeMulti argsExpr error:", v130)

						return nil
					else
						if v129 == nil then
							v131, v132, v133 = value82.Remote.invoke(Remotes, p36, p37)
						else
							v131, v132, v133 = value82.Remote.invoke(Remotes, p36, p37, v129)
						end

						t13 = {
							ok = false
						}

						if v131 ~= nil then
							v135, v136 = v103(p39, v131, v132, v133)

							if v136 then
								t13.ok = false
								t13.err = v136

								return t13
							else
								t13.ok = true
								t13.data = v135

								return t13
							end
						else
							t13.err = "invoke_failed"

							return t13
						end
					end
				else
					return nil
				end
			end

			value82.RewardHook = {}
			value82.RewardHook.QUEUE = "__MH_REWARD_Q"
			value82.RewardHook._installed = false
			value82.RewardHook.SRC = "    local QUEUE_NAME = ...\n    if _G.__MH_REWARD_HOOK then return end          -- never double-hook one VM (corrupts chain)\n    _G.__MH_REWARD_HOOK = true\n\n    local RS = game:GetService(\"ReplicatedStorage\")\n    local remotes = RS:FindFirstChild(\"Assets\") and RS.Assets:FindFirstChild(\"Remotes\")\n    local GET = remotes and remotes:FindFirstChild(\"GET\")\n    if not GET then return end\n    if not (getrawmetatable and setreadonly and newcclosure and getnamecallmethod) then return end\n\n    local HS = game:GetService(\"HttpService\")\n    local function q()\n        local v = workspace:FindFirstChild(QUEUE_NAME)\n        if not v then v = Instance.new(\"StringValue\"); v.Name = QUEUE_NAME; v.Value = \"\"; v.Parent = workspace end\n        return v\n    end\n\n    -- Build a SMALL table from the return value. Two shapes:\n    --  * \"Get\"   -> a = { Obtained = {currency=n, Perks={}, Drops={}}, Stats = {...} }\n    --  * \"Chest\" -> a = ARRAY of item objects { {Rarity=, Tag/Real_Tag=name}, ... }\n    -- Only small scalar/string fields are read; the big player-data table is never touched.\n    local function extract(kind, a)\n        if type(a) ~= \"table\" then return nil end\n        local o = { obtained = {}, perks = {}, drops = {}, stats = {} }\n        if kind == \"Chest\" then\n            -- chest contents: list of item objects with a display name + rarity\n            for _, item in ipairs(a) do\n                if type(item) == \"table\" then\n                    local nm = item.Real_Tag or item.Tag or item.Name\n                    if nm ~= nil then o.drops[#o.drops+1] = tostring(nm) end\n                end\n            end\n            return o\n        end\n        -- \"Get\": run-info table\n        local ob = a.Obtained\n        if type(ob) == \"table\" then\n            for k, v in pairs(ob) do\n                if type(v) == \"number\" then o.obtained[tostring(k)] = v\n                elseif k == \"Perks\" and type(v) == \"table\" then\n                    for _, pn in pairs(v) do o.perks[#o.perks+1] = tostring(pn) end\n                elseif k == \"Drops\" and type(v) == \"table\" then\n                    for _, dn in pairs(v) do o.drops[#o.drops+1] = tostring(dn) end\n                end\n            end\n        end\n        local st = a.Stats\n        if type(st) == \"table\" then\n            for _, key in ipairs({ \"Time_Taken\", \"Damage\", \"Kills\", \"Crits\", \"Waves\" }) do\n                local n = st[key]\n                if type(n) == \"number\" then o.stats[key] = n end\n            end\n        end\n        if a.Completed ~= nil then o.completed = a.Completed and true or false end\n        return o\n    end\n\n    local function push(kind, a)\n        local ok, small = pcall(extract, kind, a)\n        if not ok or not small then return end\n        small.kind = kind\n        local ok2, json = pcall(function() return HS:JSONEncode(small) end)\n        if not ok2 then return end\n        local v = q()\n        local cur = v.Value\n        if #cur > 100000 then cur = \"\" end\n        v.Value = cur .. json .. \"\\n\"\n    end\n\n    local mt = getrawmetatable(game)\n    local old = mt.__namecall\n    setreadonly(mt, false)\n    mt.__namecall = newcclosure(function(self, ...)\n        if self == GET then\n            local ok, m = pcall(getnamecallmethod)\n            if ok and m == \"InvokeServer\" then\n                local a2 = select(2, ...)\n                if (...) == \"S_Rewards\" and (a2 == \"Get\" or a2 == \"Chest\") then\n                    -- Run the real call EXACTLY ONCE. Capture both returns so we can pass\n                    -- them through untouched, but only ever READ `a` (small run-info).\n                    -- `b` (full player data) is forwarded verbatim and never inspected.\n                    local a, b = old(self, ...)\n                    pcall(push, a2, a)\n                    return a, b\n                end\n            end\n        end\n        return old(self, ...)\n    end)\n    setreadonly(mt, true)\n"
			value82.RewardHook._get = nil
			value82.RewardHook._chest = nil
			value82.RewardHook._stamp = 0

			function value82.RewardHook.drain()
				local v137 = workspace:FindFirstChild(value82.RewardHook.QUEUE)

				if not v137 or v137.Value == "" then
					return
				end

				local Value = v137.Value

				v137.Value = ""

				for match in string.gmatch(Value, "([^\n]+)") do
					local function v140()
						return t2.value1.Http:JSONDecode(match)
					end

					local ok, get = pcall(v140)

					if ok then
						ok = type(get) == "table"
					end

					if ok then
						value82.RewardHook._stamp = tick()

						if get.kind == "Chest" then
							local _chest = value82.RewardHook._chest or {
								obtained = {},
								perks = {},
								drops = {}
							}

							for k, v in pairs(get.obtained or {}) do
								_chest.obtained[k] = (_chest.obtained[k] or 0) + (tonumber(v) or 0)
							end

							local v146, v147, v148 = ipairs(get.perks or {})

							while true do
								local v149

								v148, v149 = v146(v147, v148)

								if not v148 then
									break
								end

								_chest.perks[#_chest.perks + 1] = v149
							end

							for _, v in ipairs(get.drops or {}) do
								_chest.drops[#_chest.drops + 1] = v
							end

							value82.RewardHook._chest = _chest
						else
							value82.RewardHook._get = get
						end
					end
				end
			end
			function value82.RewardHook.reset()
				value82.RewardHook._get = nil
				value82.RewardHook._chest = nil

				local v152 = workspace:FindFirstChild(value82.RewardHook.QUEUE)

				if not v152 then
					return
				end

				v152.Value = ""
			end
			function value82.RewardHook.start()
				if value82.RewardHook._installed then
					return
				end

				local run_on_actor_ = run_on_actor
				local run_on_actor_2 = type(run_on_actor_) == "function" and run_on_actor or nil
				local getactors_ = getactors
				local getactors_2

				if type(getactors_) == "function" then
					getactors_2 = getactors
				else
					getactors_2 = false
				end

				local v157 = getactors_2 or nil

				if not (run_on_actor_2 and v157) then
					t2.value7("RewardHook: executor lacks run_on_actor/getactors — reward hook disabled")

					return
				end

				value82.RewardHook._installed = true

				local Name = t2.value3.Name
				local obj = setmetatable({}, {
					__mode = "k"
				})

				local function v160(p40)
					local ok, result = pcall(function()
						return p40.Parent
					end)

					if not (ok and result) then
						return false
					end

					if result.Name == Name and true or result.Name == "Character" then
						return true
					end

					if t2.value3.Character then
						local ok2, result2 = pcall(function()
							return result:IsDescendantOf(t2.value3.Character)
						end)

						if ok2 and result2 then
							return true
						end
					end

					local Parent = result.Parent

					if not Parent then
						return Parent and true or false
					end

					Parent = (Parent.Name == "Characters" or Parent.Name == "Shifters") and true or Parent.Name == "Titans"

					return Parent and true or false
				end

				value82.Connection.add("RewardHookPoll", task.spawn(function()
					while true do
						local ok, result = pcall(v157)

						if ok and result then
							for _, v in pairs(result) do
								local v170 = not obj[v]

								if v170 then
									v170 = v160(v)
								end

								if v170 and pcall(run_on_actor_2, v, value82.RewardHook.SRC, value82.RewardHook.QUEUE) then
									obj[v] = true
								end
							end
						end

						task.wait(0.5)
					end
				end))
				value82.Connection.add("RewardHookDrain", unpack_({ task.spawn(function()
						while true do
							pcall(value82.RewardHook.drain)
							task.wait(0.25)
						end
					end) }))
				t2.value7("RewardHook: started (actor injection + queue drain)")
			end
			function value82.UI.clickGui(p41)
				if not p41 then
					return false
				end

				local Visible = nil

				local function v172()
					if not p41:IsA("GuiObject") then
						return
					end

					Visible = p41.Visible
				end

				Visible = true
				pcall(v172)

				if Visible then
					t2.value1.GuiService.SelectedObject = p41
					task.wait(0.1)
					t2.value1.VIM:SendKeyEvent(true, Enum.KeyCode.Return, false, game)
					task.wait(0.1)
					t2.value1.VIM:SendKeyEvent(false, Enum.KeyCode.Return, false, game)

					return true
				else
					return false
				end
			end
			function value82.UI.clickButton(p42, p43, p44)
				local value4 = p43 or t2.value4
				local v174 = p44 or 5

				for _, v in ipairs(p42) do
					local ok, result = pcall(function()
						return value4:WaitForChild(v, v174)
					end)

					if not (ok and result) then
						return false
					end

					local v179 = result

					value4 = v179
				end

				return value82.UI.clickGui(value4)
			end
			function value82.UI.selectDropdown(p45, p46)
				if not p45 then
					return
				end

				pcall(function()
					p45:Select({ p46 })
				end)
			end
			function value82.UI.setParagraph(p47, p48, p49)
				if not p47 then
					return
				end

				pcall(function()
					if p49 then
						p47:SetTitle(p49)
					end

					if not p48 then
						return
					end

					p47:SetDesc(p48)
				end)
			end

			value82.PLACE = {
				MainMenu = 13379208636,
				Lobby = 14916516914,
				Trade = 14932214603
			}
			value82.LOBBY_PLACE_IDS = {}

			local function v180(p50)
				value82.Lobby.busyLobby[p50] = true
			end

			for _, v in pairs(value82.PLACE) do
				value82.LOBBY_PLACE_IDS[v] = true
			end

			function value82.isInGame()
				if value82.LOBBY_PLACE_IDS[game.PlaceId] then
					return false
				else
					return workspace:FindFirstChild("Titans") ~= nil
				end
			end

			local isInGame = value82.isInGame

			value82.Char = {}

			function value82.Char.get()
				local Character2 = t2.value3.Character

				if Character2 then
					local HumanoidRootPart = Character2:FindFirstChild("HumanoidRootPart")
					local v186 = not HumanoidRootPart
					local Humanoid = Character2:FindFirstChildOfClass("Humanoid")

					if v186 or (not Humanoid or Humanoid.Health <= 0) then
						return nil
					else
						return Character2, HumanoidRootPart, Humanoid
					end
				else
					return nil
				end
			end
			function value82.Char.setAnchor(p51)
				local _, v189 = value82.Char.get()

				if not v189 then
					return
				end

				pcall(function()
					v189.Anchored = p51
				end)
			end
			function value82.Char.getRig()
				local Character2 = t2.value3.Character

				if Character2 then
					for _, child in ipairs(Character2:GetChildren()) do
						if child.Name:match("^Rig_") then
							return child
						end
					end
				end

				local Characters = workspace:FindFirstChild("Characters")

				if Characters then
					Characters = Characters:FindFirstChild(t2.value3.Name)
				end

				if not Characters then
					return nil
				end

				for _, child in ipairs(Characters.GetChildren(Characters)) do
					if child.Name:match("^Rig_") then
						return child
					end
				end

				return nil
			end
			function value82.Char.getBlade1()
				return value82.Util.safeIndex(value82.Char.getRig(), "LeftHand", "Blade_1")
			end
			function value82.Char.allSetsUsed()
				local LowerTorso = value82.Char.getRig()
				local v197

				if LowerTorso then
				elseif LowerTorso then
					for i = 1, 3 do
						v197 = LowerTorso:FindFirstChild("Left_" .. i, true)

						if v197 then
							v197 = v197:GetAttribute("Used") == nil
						end

						if v197 then
							return false
						end
					end

					return true
				else
					return false
				end

				LowerTorso = LowerTorso:FindFirstChild("LowerTorso")

				if LowerTorso then
					for i = 1, 3 do
						v197 = LowerTorso:FindFirstChild("Left_" .. i, true)

						if v197 then
							v197 = v197:GetAttribute("Used") == nil
						end

						if v197 then
							return false
						end
					end

					return true
				else
					return false
				end
			end
			function value82.Char.initBladeRefs()
				if not isInGame() then
					return
				end

				local Character2 = t2.value3.Character or t2.value3.CharacterAdded:Wait()
				local v201 = nil

				local function v202()
					v201:WaitForChild("HumanoidRootPart", 10)
				end

				v201 = Character2
				pcall(v202)
				pcall(function()
					v201:WaitForChild("Humanoid", 10)
				end)

				local function v203()
					return value82.Char.getBlade1() ~= nil
				end

				local v204

				if t2.value3:GetAttribute("Weapon") == "Spears" then
					v204 = false
				else
					v204 = not v203()
				end

				if not v204 then
					value82.Cache.setsLabel = value82.Util.safeIndex(t2.value4, "Interface", "HUD", "Main", "Top", "Blade", "Sets")
					v252 = not value82.Cache.setsLabel and value82.Util.safeIndex(t2.value4, "Interface", "HUD")

					if not v252 then
						return
					end

					for _, descendant in ipairs(v252:GetDescendants()) do
						if descendant.Name == "Sets" and descendant:IsA("TextLabel") or descendant:IsA("TextButton") then
							value82.Cache.setsLabel = descendant

							break
						end
					end

					return
				end

				task.wait(1)

				local v207 = tick() + 5

				while true do
					local v208 = not v203()

					if v208 then
						v208 = tick() < v207
					end

					if not v208 then
						break
					end

					task.wait(0.2)
				end

				value82.Cache.setsLabel = value82.Util.safeIndex(t2.value4, "Interface", "HUD", "Main", "Top", "Blade", "Sets")

				local v209 = not value82.Cache.setsLabel and value82.Util.safeIndex(t2.value4, "Interface", "HUD")

				if not v209 then
					return
				end

				for _, descendant in ipairs(v209:GetDescendants()) do
					if descendant.Name == "Sets" and descendant:IsA("TextLabel") or descendant:IsA("TextButton") then
						value82.Cache.setsLabel = descendant

						break
					end
				end
			end
			function value82.Char.killSelf()
				task.wait(5)

				local _, _, v214 = value82.Char.get()

				if not v214 then
					return
				end

				pcall(function()
					v214.Health = 0
				end)
			end

			value82.Nape = {}

			function value82.Nape.extend(p52)
				if not p52 then
					return
				end

				pcall(function()
					p52.Size = Vector3.new(60, 60, 60)
					p52.Color = Color3.new(1, 1, 1)
					p52.Material = Enum.Material.Neon
				end)

				if table.find(value82.Cache.extendedNapes, p52) then
					return
				end

				local extendedNapes = value82.Cache.extendedNapes

				table.insert(extendedNapes, p52)
			end
			function value82.Nape.reset(p53)
				if not p53 then
					return
				end

				pcall(function()
					p53.Size = Vector3.new(15, 9, 11)
					p53.Color = Color3.new(1, 0, 0)
					p53.Transparency = 1
					p53.Material = Enum.Material.Plastic
				end)
			end
			function value82.Nape.applyAll()
				local Titans = workspace:FindFirstChild("Titans")

				if Titans then
					local GetChildren = Titans.GetChildren

					for _, v in ipairs(GetChildren(Titans)) do
						local v220 = value82.Util.safeIndex(v, "Hitboxes", "Hit", "Nape")

						if v220 then
							value82.Nape.extend(v220)
						end
					end
				end
			end
			function value82.Nape.removeAll()
				for _, extendedNape in ipairs(value82.Cache.extendedNapes) do
					local Parent

					if extendedNape then
						Parent = extendedNape.Parent
					else
						Parent = extendedNape
					end

					if Parent then
						value82.Nape.reset(extendedNape)
					end
				end

				value82.Cache.extendedNapes = {}
			end
			function value82.Nape.pruneStale()
				local extendedNapes = {}

				for _, extendedNape in ipairs(value82.Cache.extendedNapes) do
					local Parent

					if extendedNape then
						Parent = extendedNape.Parent
					else
						Parent = extendedNape
					end

					if Parent then
						extendedNapes[#extendedNapes + 1] = extendedNape
					end
				end

				value82.Cache.extendedNapes = extendedNapes
			end
			function value82.Nape.startMonitor()
				local Titans = workspace:FindFirstChild("Titans")

				if not Titans then
					return
				end

				value82.Connection.add("NapeMonitor", Titans.ChildAdded:Connect(function(child)
					if not value82.Config.NapeExtender then
						return
					end

					task.wait(0.1)

					local v229 = value82.Util.safeIndex(child, "Hitboxes", "Hit", "Nape")

					if not v229 then
						return
					end

					value82.Nape.extend(v229)
				end))

				local function v230()
					if not (#value82.Cache.extendedNapes > 20) then
						return
					end

					value82.Nape.pruneStale()
				end

				value82.Connection.add("NapeMonitorRemoved", Titans.ChildRemoved:Connect(v230))
			end

			value82.Target = {}

			function value82.Target.napeOf(p54)
				local Hit = not value82.Util.safeIndex(p54, "Hitboxes", "Hit", "Nape") and p54:FindFirstChild("Hit", true)

				if not Hit then
					return Hit
				end

				Hit = Hit:FindFirstChild("Nape")

				return Hit
			end

			value82.Target._bossStamp = 0

			function value82.Target.raidBossNape()
				local now = tick()

				if now - value82.Target._bossStamp < 0.5 then
					local _bossNape = value82.Target._bossNape

					if _bossNape and (_bossNape.Parent and _bossNape) then
						return _bossNape
					end

					_bossNape = nil

					return _bossNape
				else
					value82.Target._bossStamp = now
					value82.Target._bossNape = nil

					local attribute = workspace:GetAttribute("Type")
					local v235

					if attribute == "Raids" then
						v235 = true
					elseif attribute == "Waves" then
						v235 = value82.Config.WaveKillBosses
					else
						v235 = false
					end

					local Titans = v235 and workspace:FindFirstChild("Titans")

					if not Titans then
						return value82.Target._bossNape
					end

					local GetChildren = Titans.GetChildren

					for _, v in ipairs(GetChildren(Titans)) do
						local isModel = v:IsA("Model")

						if isModel then
							isModel = v:FindFirstChildOfClass("Humanoid")

							if isModel then
								isModel = not v.Name:match("^%x+%-%x+%-%x+%-%x+%-%x+$")

								if isModel then
									isModel = v:GetAttribute("State") ~= nil and v.Name ~= "Colossal_Titan"

									if isModel then
										isModel = value82.Colossal.phase() == 1
									end
								end
							end
						end

						if isModel then
							local v241 = value82.Target.napeOf(v)
							local Parent

							if v241 then
								Parent = v241.Parent
							else
								Parent = v241
							end

							if Parent then
								value82.Target._bossNape = v241

								break
							end
						end
					end

					return value82.Target._bossNape
				end
			end
			function value82.Target.smallTitanNape(p55)
				local Titans = workspace:FindFirstChild("Titans")

				if Titans then
					local _, Position = value82.Char.get()
					local GetChildren, huge, v248, v249, isModel, v251, Parent, Magnitude

					if p55 then
						Position = p55
					else
						if Position then
						elseif Position then
							GetChildren = Titans.GetChildren
							huge = math.huge
							v248 = nil
							v249 = nil

							for _, v in ipairs(GetChildren(Titans)) do
								isModel = v:IsA("Model")

								if isModel then
									isModel = v:FindFirstChildOfClass("Humanoid") and value82.Combat.titanAttackable(v)

									if isModel then
										isModel = v.Name:match("^%x+%-%x+%-%x+%-%x+%-%x+$")
									end
								end

								if isModel then
									v251 = value82.Target.napeOf(v)

									if v251 then
										Parent = v251.Parent
									else
										Parent = v251
									end

									if Parent then
										Magnitude = (Position - v251.Position).Magnitude

										if Magnitude < huge then
											v249 = v
											v248 = v251
											huge = Magnitude
										end
									end
								end
							end

							return v248, v249
						else
							return nil
						end

						Position = Position.Position
					end

					if Position then
						GetChildren = Titans.GetChildren
						huge = math.huge
						v248 = nil
						v249 = nil

						for _, v in ipairs(GetChildren(Titans)) do
							isModel = v:IsA("Model")

							if isModel then
								isModel = v:FindFirstChildOfClass("Humanoid") and value82.Combat.titanAttackable(v)

								if isModel then
									isModel = v.Name:match("^%x+%-%x+%-%x+%-%x+%-%x+$")
								end
							end

							if isModel then
								v251 = value82.Target.napeOf(v)

								if v251 then
									Parent = v251.Parent
								else
									Parent = v251
								end

								if Parent then
									Magnitude = (Position - v251.Position).Magnitude

									if Magnitude < huge then
										v249 = v
										v248 = v251
										huge = Magnitude
									end
								end
							end
						end

						return v248, v249
					else
						return nil
					end
				else
					return nil
				end
			end

			value82.Target.BOSS_HP_NAMES = {
				"Defend_Eren",
				"Armored_Boss",
				"Female_Boss",
				"Colossal_Boss"
			}
			value82.Target._bossHpStamp = 0
			value82.Target._bossHpPct = nil

			function value82.Target.raidBossHpPct()
				local now = tick()

				if now - value82.Target._bossHpStamp < 0.4 then
					return value82.Target._bossHpPct
				else
					value82.Target._bossHpStamp = now
					value82.Target._bossHpPct = nil

					local v259 = value82.Util.safeIndex(workspace, "Unclimbable", "Objective")

					if v259 then
						local v260 = nil

						for _, bossHpName in ipairs(value82.Target.BOSS_HP_NAMES) do
							local v263 = v259:FindFirstChild(bossHpName)

							if v263 then
								local attribute = nil
								local v265 = v263.FindFirstChild(v263, "Health")
								local Value = nil
								local isNumberValue

								if v265 then
									isNumberValue = v265:IsA("NumberValue")
								else
									isNumberValue = v265
								end

								if isNumberValue then
									Value = v265.Value
									attribute = v265:GetAttribute("Max_Health")
								end

								if not Value then
									local Humanoid = v263:FindFirstChildOfClass("Humanoid")

									if Humanoid then
										Value = Humanoid.Health
										attribute = Humanoid.MaxHealth
									end
								end

								local v269

								if Value then
									if attribute then
										if attribute > 0 then
											v269 = Value > 0
										else
											v269 = false
										end
									else
										v269 = attribute
									end
								else
									v269 = Value
								end

								if v269 then
									local v270 = Value / attribute * 100

									if not v260 or v270 < v260 then
										v260 = v270
									end
								end
							end
						end

						value82.Target._bossHpPct = v260

						return v260
					else
						return nil
					end
				end
			end

			value82.Target.OBJ_PRIORITY_RADIUS = 1000
			value82.Target.objStamp = 0
			value82.Target.objPosCache = nil
			value82.Target.objPrev = nil
			value82.Target.objPrevStamp = 0
			value82.Target.objMoving = false
			value82.Target.focusInst = nil
			value82.Target.titanPosPrev = setmetatable({}, {
				__mode = "k"
			})

			function value82.Target.objectivePositions()
				local now = tick()
				local objPosCache = value82.Target.objPosCache

				if objPosCache then
					objPosCache = now - value82.Target.objStamp < 0.5
				end

				if objPosCache then
					return value82.Target.objPosCache
				end

				local objPrev = {}

				local function v274(p56, p57)
					if not p56 then
						return
					end

					for _, child in ipairs(p56:GetChildren()) do
						if p57(child) then
							local v277 = nil

							local function v278()
								if v277:IsA("BasePart") then
									return v277.Position
								end

								local Collider = v277:FindFirstChild("Collider") or (v277:FindFirstChild("Hitbox") or v277:FindFirstChild("RootPart"))
								local isBasePart

								if Collider then
									isBasePart = Collider:IsA("BasePart")
								else
									isBasePart = Collider
								end

								if isBasePart then
									return Collider.Position
								end

								local isModel = v277:IsA("Model")

								if isModel then
									isModel = v277.PrimaryPart
								end

								if isModel then
									return v277:GetPivot().Position
								end

								local BasePart = v277:FindFirstChildWhichIsA("BasePart", true)

								if not BasePart then
									return BasePart
								end

								BasePart = BasePart.Position

								return BasePart
							end

							v277 = child

							local ok, result = pcall(v278)
							local v285 = ok and result and result or nil

							if typeof(v285) == "Vector3" then
								objPrev[#objPrev + 1] = {
									pos = v285,
									inst = child
								}
							end
						end
					end
				end

				local Unclimbable = workspace:FindFirstChild("Unclimbable")
				local Objective

				if Unclimbable then
					Objective = Unclimbable:FindFirstChild("Objective")
				else
					Objective = Unclimbable
				end

				v274(Objective, function(p58)
					return p58.Name ~= "Waves"
				end)

				local u288 = nil

				v274(Unclimbable, function(p59)
					local v289 = p59.Name:lower()

					return v289:match("^supplies_c") or v289:match("^thunderspear_supplies") or v289 == "plane"
				end)

				local function v290()
					for _, v in ipairs(t2.value1.CS:GetTagged("TS_Towers")) do
						local Parent = v.Parent

						if Parent then
							Parent = v.Name:lower():match("^watchtower_%d")
						end

						if Parent then
							u288 = v

							return
						end
					end
				end

				u288 = nil
				pcall(v290)
				v274(workspace, function(p60)
					local v294 = p60.Name:lower() ~= "escort" and u288

					if not v294 then
						return v294
					end

					v294 = p60 == u288

					return v294
				end)

				if #objPrev > 0 then
					local objPrev2 = value82.Target.objPrev

					if objPrev2 then
						objPrev2 = now - value82.Target.objPrevStamp >= 0.3
					end

					if objPrev2 then
						local objPrev3 = value82.Target.objPrev
						local v297 = math.min(#objPrev3, #objPrev)
						local n2 = 0
						local n3 = 1
						local v300 = false
						local v301 = false

						while true do
							n2 = n2 + n3

							local v302 = ((not v300 or v297 > n2) and true or false) and not v300

							if v302 then
								v302 = n2 <= v297
							end

							if not v302 then
								break
							end

							if (objPrev3[n2].pos - objPrev[n2].pos).Magnitude > 4 then
								v301 = true

								break
							end
						end

						local objMoving = #objPrev3 ~= #objPrev and true or v301

						value82.Target.objMoving = objMoving

						local Target = value82.Target
						local Target2 = value82.Target

						Target.objPrev = objPrev
						Target2.objPrevStamp = now
					else
						if value82.Target.objPrev then
							v351 = value82.Target
							v352 = value82.Target
							v351.objPosCache = objPrev
							v352.objStamp = now

							return objPrev
						end

						local Target = value82.Target
						local Target2 = value82.Target

						Target.objPrev = objPrev
						Target2.objPrevStamp = now
					end
				else
					local Target = value82.Target
					local Target2 = value82.Target

					Target.objMoving = false
					Target2.objPrev = nil
				end

				local Target = value82.Target
				local Target2 = value82.Target

				Target.objPosCache = objPrev
				Target2.objStamp = now

				return objPrev
			end

			local function v312(p61)
				local ok, result = pcall(function()
					local Health = p61:FindFirstChild("Health")
					local isValueBase

					if Health then
						isValueBase = Health:IsA("ValueBase")
					else
						isValueBase = Health
					end

					if isValueBase then
						return tonumber(Health.Value)
					else
						return nil
					end
				end)

				return ok and result and result or nil
			end

			function value82.Target.movingObjective()
				local v317 = value82.Target.objectivePositions()

				if #v317 == 0 then
					return nil, false
				end

				local v318, v319, v320 = ipairs(v317)
				local pos = nil

				while true do
					local v322

					v320, v322 = v318(v319, v320)

					if not v320 then
						break
					end

					if v322.inst == value82.Target.focusInst then
						pos = v322.pos

						break
					end
				end

				if pos then
					return pos, value82.Target.objMoving
				end

				local _, v324 = value82.Char.get()

				pos = v317[1].pos

				if not v324 then
					return pos, value82.Target.objMoving
				end

				local huge = math.huge

				for _, v in ipairs(v317) do
					local Magnitude = (v324.Position - v.pos).Magnitude

					if Magnitude < huge then
						pos = v.pos
						huge = Magnitude
					end
				end

				return pos, value82.Target.objMoving
			end
			function value82.Target.isValidTarget(p62, p63)
				local Parent = p62 and p62.Parent

				if Parent then
					if p63 then
						Parent = p63.Parent
					else
						Parent = p63
					end
				end

				if not Parent then
					return false
				end

				local active = value82.Colossal and value82.Colossal.active

				if active then
					active = value82.Colossal.active()
				end

				if active then
					if p62 == value82.Colossal.boss() then
						return value82.Colossal.phase() == 2
					end

					local v331 = value82.Colossal.erenPos()

					if not v331 then
						return not v331
					end

					v331 = (p63.Position - v331).Magnitude > value82.Colossal.EREN_GUARD_RADIUS

					return not v331
				else
					local defendingSuppliesActive = value82.Thunder and value82.Thunder.defendingSuppliesActive

					if defendingSuppliesActive then
						defendingSuppliesActive = value82.Thunder.defendingSuppliesActive()
					end

					if not defendingSuppliesActive then
						return true
					end

					local v333 = value82.Thunder.supplyPos()

					if not v333 then
						return not v333
					end

					v333 = (p63.Position - v333).Magnitude > value82.Thunder.SUPPLY_GUARD_RADIUS

					return not v333
				end
			end
			function value82.Target.nearest()
				local now = tick()
				local nearestTitan = value82.Cache.nearestTitan

				if nearestTitan then
					nearestTitan = now - value82.Cache.nearestStamp < 0.2
				end

				if nearestTitan then
					local nearestTitan2 = value82.Cache.nearestTitan
					local nearestNape = value82.Cache.nearestNape
					local Parent

					if nearestTitan2 then
						Parent = nearestTitan2.Parent and (nearestNape and nearestNape.Parent)

						if Parent then
							Parent = nearestTitan2:FindFirstChildOfClass("Humanoid")
						end
					else
						Parent = nearestTitan2
					end

					if Parent then
						return nearestTitan2, nearestNape
					end
				end

				local Titans = workspace:FindFirstChild("Titans")
				local _, v341 = value82.Char.get()

				if not (Titans and v341) then
					return nil, nil
				end

				local v342 = value82.Target.objectivePositions()
				local OBJ_PRIORITY_RADIUS = value82.Target.OBJ_PRIORITY_RADIUS
				local GetChildren = Titans.GetChildren
				local v345, v346, v347 = ipairs(GetChildren(Titans))
				local t14 = {}
				local huge = math.huge
				local v350 = nil
				local v353 = nil

				while true do
					local v354

					v347, v354 = v345(v346, v347)

					if not v347 then
						break
					end

					local Humanoid = v354:IsA("Model") and v354:FindFirstChildOfClass("Humanoid")

					if Humanoid then
						Humanoid = value82.Combat.titanAttackable(v354)
					end

					local v355, Magnitude

					if Humanoid then
						v355 = value82.Target.napeOf(v354)

						local v356

						if v355 then
							v356 = value82.Target.isValidTarget(v354, v355)
						else
							v356 = v355
						end

						if v356 then
							local Position = v355.Position

							t14[#t14 + 1] = {
								titan = v354,
								nape = v355,
								pos = Position
							}
							Magnitude = (v341.Position - Position).Magnitude

							if Magnitude >= huge then
								v355 = v353
								v354 = v350
								Magnitude = huge
							end
						else
							v355 = v353
							v354 = v350
							Magnitude = huge
						end
					else
						v355 = v353
						v354 = v350
						Magnitude = huge
					end

					v353 = v355
					v350 = v354
					huge = Magnitude
				end

				local Cache, Cache2, Cache3

				if not (#v342 > 0) then
					value82.Target.focusInst = nil
					Cache = value82.Cache
					Cache2 = value82.Cache
					Cache3 = value82.Cache
					Cache.nearestTitan = v350
					Cache2.nearestNape = v353
					Cache3.nearestStamp = now

					return v350, v353
				end

				local function v361(p64)
					local n4 = 0

					for _, v in ipairs(t14) do
						if (p64.pos - v.pos).Magnitude <= OBJ_PRIORITY_RADIUS then
							n4 = n4 + 1
						end
					end

					return n4
				end

				local v365 = nil
				local v366 = nil
				local v367 = nil
				local v368 = nil
				local v369 = nil
				local n5 = 0

				for _, v in ipairs(v342) do
					local v373 = v361(v)

					if v.inst == value82.Target.focusInst then
						n5 = v373
						v369 = v
					end

					local huge2 = v312(v.inst) or math.huge
					local Magnitude = (v341.Position - v.pos).Magnitude
					local v376 = not v365

					if not v376 then
						v376 = v366 < v373

						if not v376 then
							if v373 == v366 and huge2 < v368 then
								v376 = true
							elseif v373 == v366 and huge2 == v368 then
								v376 = Magnitude < v367
							else
								v376 = false
							end
						end
					end

					if v376 then
						v368 = huge2
						v367 = Magnitude
						v366 = v373
						v365 = v
					end
				end

				local v377 = not v369

				if not v377 then
					if n5 == 0 then
						v377 = true
					elseif v365 == v369 then
						v377 = false
					else
						v377 = n5 * 2 + 1 <= v366
					end
				end

				if v377 then
					v369 = v366 > 0 and v365 and v365 or nil
				end

				local Target = value82.Target
				local inst

				if v369 then
					inst = v369.inst or nil
				else
					inst = nil
				end

				Target.focusInst = inst

				if not v369 then
					value82.Target.focusInst = nil
					Cache = value82.Cache
					Cache2 = value82.Cache
					Cache3 = value82.Cache
					Cache.nearestTitan = v350
					Cache2.nearestNape = v353
					Cache3.nearestStamp = now

					return v350, v353
				end

				local inst2 = workspace:GetAttribute("Objective") == "Stall" and v369.inst

				if inst2 then
					inst2 = v369.inst.Name:lower() == "plane"
				end

				local v381, v382, v383, huge2, titan, nape, v387, Magnitude, v389, Cache4, Cache5, Cache6

				if not inst2 then
					v381, v382, v383 = ipairs(t14)
					huge2 = math.huge
					titan = nil
					nape = nil

					while true do
						v383, v387 = v381(v382, v383)

						if not v383 then
							break
						end

						Magnitude = (v369.pos - v387.pos).Magnitude

						if Magnitude <= OBJ_PRIORITY_RADIUS then
							v389 = Magnitude < huge2
						else
							v389 = false
						end

						if v389 then
							titan = v387.titan
							nape = v387.nape
						else
							Magnitude = huge2
						end

						huge2 = Magnitude
					end

					if titan then
						Cache4 = value82.Cache
						Cache5 = value82.Cache
						Cache6 = value82.Cache
						Cache4.nearestTitan = titan
						Cache5.nearestNape = nape
						Cache6.nearestStamp = now

						return titan, nape
					else
						value82.Target.focusInst = nil
						Cache = value82.Cache
						Cache2 = value82.Cache
						Cache3 = value82.Cache
						Cache.nearestTitan = v350
						Cache2.nearestNape = v353
						Cache3.nearestStamp = now

						return v350, v353
					end
				end

				local v393, v394, v395 = ipairs(t14)
				local v396 = -math.huge
				local titan2 = nil
				local nape2 = nil

				while true do
					local v399

					v395, v399 = v393(v394, v395)

					if not v395 then
						break
					end

					local Magnitude2 = (v369.pos - v399.pos).Magnitude
					local v401

					if Magnitude2 <= OBJ_PRIORITY_RADIUS then
						local n6 = 0
						local v403 = value82.Target.titanPosPrev[v399.titan]

						if v403 then
							local v404 = now - v403.t

							if v404 > 0.01 then
								n6 = ((v369.pos - v403.pos).Magnitude - Magnitude2) / v404
							end
						end

						value82.Target.titanPosPrev[v399.titan] = {
							pos = v399.pos,
							t = now
						}
						v401 = (1 - Magnitude2 / OBJ_PRIORITY_RADIUS) * 100 + n6 * 2

						if v396 < v401 then
							titan2 = v399.titan
							nape2 = v399.nape
						else
							v401 = v396
						end
					else
						v401 = v396
					end

					v396 = v401
				end

				if titan2 then
					local Cache7 = value82.Cache
					local Cache8 = value82.Cache
					local Cache9 = value82.Cache

					Cache7.nearestTitan = titan2
					Cache8.nearestNape = nape2
					Cache9.nearestStamp = now

					return titan2, nape2
				else
					v381, v382, v383 = ipairs(t14)
					huge2 = math.huge
					titan = nil
					nape = nil

					while true do
						v383, v387 = v381(v382, v383)

						if not v383 then
							break
						end

						Magnitude = (v369.pos - v387.pos).Magnitude

						if Magnitude <= OBJ_PRIORITY_RADIUS then
							v389 = Magnitude < huge2
						else
							v389 = false
						end

						if v389 then
							titan = v387.titan
							nape = v387.nape
						else
							Magnitude = huge2
						end

						huge2 = Magnitude
					end

					if titan then
						Cache4 = value82.Cache
						Cache5 = value82.Cache
						Cache6 = value82.Cache
						Cache4.nearestTitan = titan
						Cache5.nearestNape = nape
						Cache6.nearestStamp = now

						return titan, nape
					else
						value82.Target.focusInst = nil
						Cache = value82.Cache
						Cache2 = value82.Cache
						Cache3 = value82.Cache
						Cache.nearestTitan = v350
						Cache2.nearestNape = v353
						Cache3.nearestStamp = now

						return v350, v353
					end
				end
			end
			function value82.Target.update()
				local v408, v409 = value82.Target.nearest()

				if v408 == value82.Runtime.currentTitan then
					value82.Runtime.currentTitan = v408
					value82.Runtime.nape = v409

					return
				end

				value82.Runtime.bossHitboxRotIdx = 0
				value82.Runtime.currentTitan = v408
				value82.Runtime.nape = v409
			end

			value82.Move = {}
			value82.Move.dest = nil
			value82.Move.face = nil
			value82.Move._conn = nil
			value82.Move.ARRIVE = 3

			local function v410()
				if value82.Move._conn then
					return
				end

				value82.Move._conn = t2.value1.RunService.Heartbeat:Connect(function(dt)
					local dest = value82.Move.dest
					local _, v413, v414 = value82.Char.get()

					if dest then
						if not v413 then
							return
						end

						local v415

						if v414 then
							v415 = value82.Move._autoRotHum ~= v414
						else
							v415 = v414
						end

						if v415 then
							local _autoRotHum = value82.Move._autoRotHum

							if _autoRotHum then
								pcall(function()
									_autoRotHum.AutoRotate = true
								end)
							end

							pcall(function()
								v414.AutoRotate = false
							end)
							value82.Move._autoRotHum = v414
						end

						if v413.Anchored then
							return
						end

						local Position = v413.Position

						if (Position - dest).Magnitude <= value82.Move.ARRIVE then
							return
						end

						local HoverSpeed = value82.Config.HoverSpeed
						local v419 = tonumber(HoverSpeed) or 1500
						local v420 = -math.clamp(v419 / 130, 4, 16) * math.min(dt, 0.1)
						local v421 = 1 - math.exp(v420)
						local v422 = Position:Lerp(dest, v421)
						local face = value82.Move.face
						local v424 = nil

						local function v425()
							v413.AssemblyLinearVelocity = Vector3.zero
							v413.AssemblyAngularVelocity = Vector3.zero

							local v426 = v424
							local cFrame

							if not v426 then
								if v426 then
									cFrame = CFrame.lookAt(v422, v422 + v424)
									v413.CFrame = (CFrame.new(v422) * (v413.CFrame - v413.CFrame.Position)):Lerp(cFrame, v421)
								else
									v413.CFrame = CFrame.new(v422) * (v413.CFrame - v413.CFrame.Position)
								end

								return
							end

							v426 = v424.Magnitude > 0.01

							if v426 then
								cFrame = CFrame.lookAt(v422, v422 + v424)
								v413.CFrame = (CFrame.new(v422) * (v413.CFrame - v413.CFrame.Position)):Lerp(cFrame, v421)
							else
								v413.CFrame = CFrame.new(v422) * (v413.CFrame - v413.CFrame.Position)
							end
						end

						v424 = face
						pcall(v425)

						return
					end

					local _autoRotHum = value82.Move._autoRotHum

					if not _autoRotHum then
						return
					end

					pcall(function()
						_autoRotHum.AutoRotate = true
					end)
					value82.Move._autoRotHum = nil
				end)
				value82.Connection.add("MoveEngine", value82.Move._conn)
			end

			function value82.Move.to(p65, p66, p67)
				if typeof(p66) ~= "Vector3" then
					return
				end

				v410()
				value82.Move.dest = p66

				local Move = value82.Move

				if typeof(p67) ~= "Vector3" then
					p67 = false
				end

				Move.face = p67 or nil

				local Anchored

				if p65 then
					Anchored = p65.Anchored
				else
					Anchored = p65
				end

				if not Anchored then
					return
				end

				p65.Anchored = false
			end
			function value82.Move.cancel()
				value82.Move.dest = nil
				value82.Move.face = nil

				local _, v432 = value82.Char.get()

				if not v432 then
					return
				end

				pcall(function()
					v432.AssemblyLinearVelocity = Vector3.zero
				end)
				pcall(function()
					v432.AssemblyAngularVelocity = Vector3.zero
				end)
				v432.Anchored = false
			end
			function value82.Move.hold(p68)
				value82.Move.dest = nil

				if not p68 then
					return
				end

				p68.Anchored = true
			end

			value82.Combat = {}
			value82.Combat.AUTO_RELOAD_SKILL = "74"

			function value82.Combat.hasAutoReloadSkill()
				local unlockedSkills = value82.Stats.unlockedSkills
				local v434

				if type(unlockedSkills) == "table" then
					v434 = unlockedSkills[value82.Combat.AUTO_RELOAD_SKILL] == true
				else
					v434 = false
				end

				return v434
			end
			function value82.Combat.titanAttackable(p69)
				if p69 then
					local attribute = p69:GetAttribute("State")

					return attribute ~= nil and attribute ~= "Roar" and attribute ~= "HeatWave"
				else
					return false
				end
			end
			function value82.Combat.hasTarget(p70)
				local v436 = p70 or 500
				local _, v438 = value82.Char.get()

				if not v438 then
					return nil
				end

				local Position = v438.Position
				local nape = value82.Runtime.nape
				local currentTitan = value82.Runtime.currentTitan
				local Parent, Titans, GetChildren, v445, Humanoid, v447, Magnitude

				if nape then
					Parent = nape.Parent

					if Parent then
					elseif Parent then
						return nape
					else
						Titans = workspace:FindFirstChild("Titans")

						if Titans then
							GetChildren = Titans.GetChildren
							v445 = nil

							for _, v in ipairs(GetChildren(Titans)) do
								Humanoid = v:IsA("Model") and v:FindFirstChildOfClass("Humanoid")

								if Humanoid then
									Humanoid = value82.Combat.titanAttackable(v)
								end

								if Humanoid then
									v447 = value82.Target.napeOf(v)

									if v447 then
										Magnitude = (Position - v447.Position).Magnitude

										if Magnitude <= v436 then
											v445 = v447
											v436 = Magnitude
										end
									end
								end
							end

							return v445
						else
							return nil
						end
					end

					if currentTitan then
						Parent = currentTitan.Parent

						if Parent then
						elseif Parent then
							return nape
						else
							Titans = workspace:FindFirstChild("Titans")

							if Titans then
								GetChildren = Titans.GetChildren
								v445 = nil

								for _, v in ipairs(GetChildren(Titans)) do
									Humanoid = v:IsA("Model") and v:FindFirstChildOfClass("Humanoid")

									if Humanoid then
										Humanoid = value82.Combat.titanAttackable(v)
									end

									if Humanoid then
										v447 = value82.Target.napeOf(v)

										if v447 then
											Magnitude = (Position - v447.Position).Magnitude

											if Magnitude <= v436 then
												v445 = v447
												v436 = Magnitude
											end
										end
									end
								end

								return v445
							else
								return nil
							end
						end

						Parent = currentTitan:FindFirstChildOfClass("Humanoid") and value82.Combat.titanAttackable(currentTitan)

						if Parent then
						elseif Parent then
							return nape
						else
							Titans = workspace:FindFirstChild("Titans")

							if Titans then
								GetChildren = Titans.GetChildren
								v445 = nil

								for _, v in ipairs(GetChildren(Titans)) do
									Humanoid = v:IsA("Model") and v:FindFirstChildOfClass("Humanoid")

									if Humanoid then
										Humanoid = value82.Combat.titanAttackable(v)
									end

									if Humanoid then
										v447 = value82.Target.napeOf(v)

										if v447 then
											Magnitude = (Position - v447.Position).Magnitude

											if Magnitude <= v436 then
												v445 = v447
												v436 = Magnitude
											end
										end
									end
								end

								return v445
							else
								return nil
							end
						end

						Parent = (Position - nape.Position).Magnitude <= v436
					else
						Parent = currentTitan
					end
				else
					Parent = nape
				end

				if Parent then
					return nape
				else
					Titans = workspace:FindFirstChild("Titans")

					if Titans then
						GetChildren = Titans.GetChildren
						v445 = nil

						for _, v in ipairs(GetChildren(Titans)) do
							Humanoid = v:IsA("Model") and v:FindFirstChildOfClass("Humanoid")

							if Humanoid then
								Humanoid = value82.Combat.titanAttackable(v)
							end

							if Humanoid then
								v447 = value82.Target.napeOf(v)

								if v447 then
									Magnitude = (Position - v447.Position).Magnitude

									if Magnitude <= v436 then
										v445 = v447
										v436 = Magnitude
									end
								end
							end
						end

						return v445
					else
						return nil
					end
				end
			end
			function value82.Combat.napeNear(p71, p72)
				local Titans = workspace:FindFirstChild("Titans")

				if Titans then
					local v458 = nil

					for _, child in ipairs(Titans:GetChildren()) do
						local Humanoid = child:IsA("Model") and child:FindFirstChildOfClass("Humanoid")

						if Humanoid then
							Humanoid = value82.Combat.titanAttackable(child)
						end

						if Humanoid then
							local v462 = value82.Target.napeOf(child)

							if v462 then
								local Magnitude = (p71 - v462.Position).Magnitude

								if Magnitude <= p72 then
									v458 = v462
									p72 = Magnitude
								end
							end
						end
					end

					return v458
				else
					return nil
				end
			end
			function value82.Combat.chaseHold(p73, p74, p75)
				local v464 = value82.Combat.napeNear(p73, p74 or 1000)
				local Parent

				if v464 then
					Parent = v464.Parent
				else
					Parent = v464
				end

				if Parent then
					return v464.Position + Vector3.new(0, p75 or value82.Config.HoverHeight, 0)
				else
					return p73
				end
			end
			function value82.Combat.shiftSlot()
				value82.DataCopy.fetch()

				return value82.Runtime.shiftSlot
			end

			value82.Combat.LOC_SKILLS = {
				["164"] = "vec",
				["165"] = "tbl",
				["301"] = "vec"
			}

			function value82.Combat.fireSkill(p76, p77, p78)
				local Remotes = t2.value1.RS:FindFirstChild("Assets") and t2.value1.RS.Assets:FindFirstChild("Remotes")
				local v467

				if not Remotes then
					if Remotes then
						if p77 then
							v467 = p78 and ({ p77 } or p77) or p77
						else
							v467 = nil
						end

						value82.Remote.invoke(Remotes, "S_Skills", "Usage", p76, nil, v467)
					end

					return
				end

				Remotes = t2.value1.RS.Assets.Remotes:FindFirstChild("GET")

				if Remotes then
					if p77 then
						v467 = p78 and ({ p77 } or p77) or p77
					else
						v467 = nil
					end

					value82.Remote.invoke(Remotes, "S_Skills", "Usage", p76, nil, v467)
				end
			end
			function value82.Combat.humanSkillSlots()
				value82.DataCopy.fetch()

				return value82.Runtime.humanSkillSlots
			end
			function value82.Combat.multiHitRadius()
				local MultiHitRadius = value82.Config.MultiHitRadius

				return tonumber(MultiHitRadius) or 250
			end
			function value82.Combat.pickBossHitbox(p79, p80)
				local v469, v470, v471 = ipairs(p79:GetChildren())
				local t15 = {}

				while true do
					local v473

					v471, v473 = v469(v470, v471)

					if not v471 then
						break
					end

					local isBasePart = v473:IsA("BasePart")

					if isBasePart then
						isBasePart = v473.Name ~= "Nape"
					end

					if isBasePart then
						t15[#t15 + 1] = v473
					end
				end

				if #t15 == 0 then
					return p79.FindFirstChild(p79, "Nape")
				elseif p80 < 5 then
					return t15[p80 % #t15 + 1]
				else
					local v475 = p80 % 10

					if v475 < 5 then
						return t15[v475 % #t15 + 1]
					else
						return p79.FindFirstChild(p79, "Nape")
					end
				end
			end
			function value82.Combat.timeDiff()
				return math.random(100, 800) / 1000
			end
			function value82.Combat.BV()
				return math.random(200, 400)
			end
			function value82.Combat.attack()
				local nape = value82.Runtime.nape

				if not nape then
					return
				end

				local _, v478 = value82.Char.get()

				if not v478 then
					return
				end

				local v479 = value82.Util.safeIndex(nape, "Parent", "Parent", "Parent")

				if not value82.Combat.titanAttackable(v479) then
					return
				end

				local bossHover = value82.Runtime.bossHover

				if bossHover then
					bossHover = workspace:GetAttribute("Objective") == "Colossal Titan"
				end

				if (bossHover and math.huge or ((value82.Runtime.objectiveMode or value82.Runtime.bossHover) and 1000 or value82.Config.HoverHeight + 50)) < (v478.Position - nape.Position).Magnitude then
					return
				end

				local now = tick()

				if now - value82.Runtime.attackBlockedTick < 4 then
					return
				end

				if value82.Runtime.attackCombo >= 3 then
					if now - value82.Runtime.lastComboTick < 1 then
						return
					end

					value82.Runtime.attackCombo = 0
				end

				if now - value82.Runtime.lastAttackTick < 0.5 then
					return
				end

				local v482 = workspace:GetAttribute("Objective") == "Stall"
				local Name = v479 and (v479.Name or "") or ""
				local v484 = not v482

				if v484 then
					if Name == "" then
						v484 = false
					else
						v484 = not Name:match("^%x+%-%x+%-%x+%-%x+%-%x+$")
					end
				end

				local v485

				if v484 then
					v485 = now - value82.Runtime.lastBossBladeAttackTick < 1.5
				else
					v485 = v484
				end

				if v485 then
					return
				end

				local lastAttackTick = value82.Runtime.lastAttackTick
				local attackCombo = value82.Runtime.attackCombo
				local lastComboTick = value82.Runtime.lastComboTick

				value82.Runtime.lastAttackTick = now

				if v484 then
					value82.Runtime.lastBossBladeAttackTick = now
				end

				value82.Runtime.attackCombo = value82.Runtime.attackCombo + 1
				value82.Runtime.lastComboTick = now

				local v489 = t2.value3:GetAttribute("Shifting") == true
				local v490 = not v489

				if v490 then
					v490 = t2.value3:GetAttribute("Weapon") == "Spears"
				end

				if v490 then
					if now - value82.Runtime.lastSpearTick < value82.Runtime.spearGap then
						value82.Runtime.lastAttackTick = lastAttackTick
						value82.Runtime.attackCombo = attackCombo
						value82.Runtime.lastComboTick = lastComboTick

						return
					end

					value82.Runtime.lastSpearTick = now
					value82.Runtime.spearGap = 0.8 + math.random() * 0.2

					local v491 = value82.Util.safeIndex(t2.value4, "Interface", "HUD", "Main", "Top", "7", "Spears", "Spears")
					local v492

					if v491 then
						local Text = v491.Text
						local v494 = tostring(Text)

						v492 = tonumber(v494:match("^%s*(%d+)")) or 0
					else
						v492 = 0
					end

					local v495

					if v492 <= 0 then
						v495 = not value82.Config.InfiniteSpear
					else
						v495 = false
					end

					if v495 then
						return
					end

					local v496 = nape.Position.X .. "," .. nape.Position.Y .. "," .. nape.Position.Z
					local v497 = workspace:GetAttribute("Objective") == "Stall"
					local v498 = v492 > 0 and math.min(v492, 8) or 1
					local v499 = tostring(v498)
					local match = v479.Name:match("^%x+%-%x+%-%x+%-%x+%-%x+$")
					local v501 = not v497

					if v501 then
						local v502 = match ~= nil

						v501 = not v502
					end

					local match2, v504, v505

					if v501 then
						local v506 = value82.Util.safeIndex(v479, "Hitboxes", "Hit")
						local v507

						if v506 then
							v507 = value82.Combat.pickBossHitbox(v506, value82.Runtime.bossHitboxRotIdx) or nape
						else
							v507 = nape
						end

						local Position = v507 and v507.Position or nape.Position

						v496 = Position.X .. "," .. Position.Y .. "," .. Position.Z

						local BossBurst = value82.Config.BossBurst or 5
						local v510 = math.clamp(BossBurst, 1, 10)
						local n7 = 1
						local n8 = 1
						local v513 = false

						while true do
							n7 = n7 + n8

							local v514 = ((not v513 or v510 > n7) and true or false) and not v513

							if v514 then
								v514 = n7 <= v510
							end

							if not v514 then
								break
							end

							local vector3 = Vector3.new(math.random(-5, 5), math.random(-2, 2), math.random(-5, 5))
							local v516 = v507.Position + vector3

							v496 = v496 .. "\31" .. v516.X .. "," .. v516.Y .. "," .. v516.Z
						end

						value82.Runtime.bossHitboxRotIdx = value82.Runtime.bossHitboxRotIdx + 1
					else
						local n9

						if v497 or not value82.Config.MultiHitEnabled then
							n9 = 1
						else
							local MultiHit = value82.Config.MultiHit or 1

							n9 = math.max(1, MultiHit) or 1
						end

						if not (n9 > 1) then
							v581 = t2.value1.RS.Assets.Remotes.GET
							v582 = t2.value1.RS.Assets.Remotes.POST
							value82.Remote.invoke(v581, "Spears", "S_Fire", v499)

							for match3 in string.gmatch(v496, "([^\31]+)") do
								match2, v504, v505 = match3:match("([^,]+),([^,]+),([^,]+)")

								if match2 then
									value82.Remote.fire(v582, "Spears", "S_Explode", Vector3.new(tonumber(match2), tonumber(v504), (tonumber(v505))), value82.Combat.timeDiff())
								end
							end

							return
						end

						local Titans = workspace:FindFirstChild("Titans")
						local Position = v478.Position
						local t16 = {}

						if Titans then
							for _, child in ipairs(Titans.GetChildren(Titans)) do
								local v525 = child ~= v479

								if v525 then
									v525 = child:IsA("Model") and child:FindFirstChildOfClass("Humanoid")

									if v525 then
										v525 = value82.Combat.titanAttackable(child)
									end
								end

								if v525 then
									local v526 = value82.Util.safeIndex(child, "Hitboxes", "Hit", "Nape")
									local v527 = v526 and value82.Target.isValidTarget(child, v526)

									if v527 then
										v527 = (v526.Position - nape.Position).Magnitude <= value82.Combat.multiHitRadius()
									end

									if v527 then
										t16[#t16 + 1] = {
											pos = v526.Position,
											dist = (Position - v526.Position).Magnitude
										}
									end
								end
							end

							table.sort(t16, function(p81, p82)
								return p81.dist < p82.dist
							end)
						end

						local min = math.min
						local v529 = n9 - 1

						for i = 1, min(#t16, v529) do
							local pos = t16[i].pos

							v496 = v496 .. "\31" .. pos.X .. "," .. pos.Y .. "," .. pos.Z
						end
					end

					local GET = t2.value1.RS.Assets.Remotes.GET
					local POST = t2.value1.RS.Assets.Remotes.POST

					value82.Remote.invoke(GET, "Spears", "S_Fire", v499)

					for match3 in string.gmatch(v496, "([^\31]+)") do
						match2, v504, v505 = match3:match("([^,]+),([^,]+),([^,]+)")

						if match2 then
							value82.Remote.fire(POST, "Spears", "S_Explode", Vector3.new(tonumber(match2), tonumber(v504), (tonumber(v505))), value82.Combat.timeDiff())
						end
					end

					return
				end

				local BV = v478:FindFirstChild("BV")

				if BV then
					local _ = BV.Velocity.Magnitude
				end

				if v489 then
					t2.value7("TitanMastery: M1 punch (Slash + Register) on nape")
				end

				local Titans = workspace:FindFirstChild("Titans")

				if not Titans then
					return
				end

				local children = Titans:GetChildren()
				local v539 = value82.Util.safeIndex(nape, "Parent", "Parent", "Parent")
				local v540, v541, v542 = ipairs(children)
				local v543 = nil

				while true do
					local v544

					v542, v544 = v540(v541, v542)

					if not v542 then
						v542 = v543

						break
					end

					if v544 == v539 then
						break
					end
				end

				if not v542 then
					return
				end

				local v545 = workspace:GetAttribute("Objective") == "Stall"
				local v546 = v539.Name:match("^%x+%-%x+%-%x+%-%x+%-%x+$") ~= nil
				local v547 = value82.Util.safeIndex(v539, "Hitboxes", "Hit")
				local v548 = not (v545 or v546)

				if v548 then
					v548 = v547 ~= nil
				end

				local v549 = not v545

				if v549 then
					v549 = value82.Config.MultiHitEnabled
				end

				if v549 then
					local MultiHit = value82.Config.MultiHit or 1

					v549 = math.max(1, MultiHit)
				end

				local t17 = { v542 }
				local v552 = v549 or 1
				local v553, v554, v555, v556, Parent, v558, Parent2, Hitboxes

				if not (v552 > 1) then
					v623 = table.concat(t17, "\31")
					v624 = value82.Config.BossBurst or 5
					v625 = math.clamp(v624, 1, 10)
					v626 = t2.value1.RS.Assets.Remotes.POST
					value82.Remote.fire(v626, "Attacks", "Slash", true)

					if (v548 and 1 or 0) == 1 then
						v553, v554, v555 = string.gmatch(v623, "([^\31]+)")
						v556 = nil

						while true do
							v555 = v553(v554, v555)

							if not v555 then
								break
							end

							v556 = v556 or tonumber(v555)
						end

						if v556 then
							v556 = children[v556]
						end

						Parent = v556 and v556.Parent

						if Parent then
							Parent = v556:FindFirstChild("Hitboxes")
						end

						if Parent then
							Parent = Parent:FindFirstChild("Hit")
						end

						if Parent then
							Parent = value82.Combat.pickBossHitbox(Parent, value82.Runtime.bossHitboxRotIdx)
						end

						if not Parent then
							value82.Remote.fire(v626, "Attacks", "Slash", false)

							return
						end

						for _ = 1, v625 do
							value82.Remote.fire(v626, "Hitboxes", "Register", Parent, value82.Combat.BV(), value82.Combat.timeDiff())
						end

						value82.Runtime.bossHitboxRotIdx = value82.Runtime.bossHitboxRotIdx + 1
					else
						for match in string.gmatch(v623, "([^\31]+)") do
							v558 = children[tonumber(match)]

							if v558 then
								Parent2 = v558.Parent
							else
								Parent2 = v558
							end

							if Parent2 then
								Hitboxes = v558:FindFirstChild("Hitboxes")

								if Hitboxes then
									Hitboxes = Hitboxes:FindFirstChild("Hit")
								end

								if Hitboxes then
									Hitboxes = Hitboxes:FindFirstChild("Nape")
								end

								if Hitboxes then
									value82.Remote.fire(v626, "Hitboxes", "Register", Hitboxes, value82.Combat.BV(), value82.Combat.timeDiff())
								end
							end
						end
					end

					value82.Remote.fire(v626, "Attacks", "Slash", false)

					return
				end

				local Position = v478.Position
				local v564, v565, v566 = ipairs(children)
				local t18 = {}

				while true do
					local v568

					v566, v568 = v564(v565, v566)

					if not v566 then
						break
					end

					local v569 = v566 ~= v542

					if v569 then
						v569 = v568:IsA("Model") and v568:FindFirstChildOfClass("Humanoid")

						if v569 then
							v569 = value82.Combat.titanAttackable(v568)
						end
					end

					if v569 then
						local v570 = value82.Util.safeIndex(v568, "Hitboxes", "Hit", "Nape")
						local v571 = v570 and value82.Target.isValidTarget(v568, v570)

						if v571 then
							v571 = (v570.Position - nape.Position).Magnitude <= value82.Combat.multiHitRadius()
						end

						if v571 then
							t18[#t18 + 1] = {
								idx = v566,
								dist = (Position - v570.Position).Magnitude
							}
						end
					end
				end

				table.sort(t18, function(p83, p84)
					return p83.dist < p84.dist
				end)

				for _, v in ipairs(t18) do
					if v552 <= #t17 then
						v623 = table.concat(t17, "\31")
						v624 = value82.Config.BossBurst or 5
						v625 = math.clamp(v624, 1, 10)
						v626 = t2.value1.RS.Assets.Remotes.POST
						value82.Remote.fire(v626, "Attacks", "Slash", true)

						if (v548 and 1 or 0) == 1 then
							v553, v554, v555 = string.gmatch(v623, "([^\31]+)")
							v556 = nil

							while true do
								v555 = v553(v554, v555)

								if not v555 then
									break
								end

								v556 = v556 or tonumber(v555)
							end

							if v556 then
								v556 = children[v556]
							end

							Parent = v556 and v556.Parent

							if Parent then
								Parent = v556:FindFirstChild("Hitboxes")
							end

							if Parent then
								Parent = Parent:FindFirstChild("Hit")
							end

							if Parent then
								Parent = value82.Combat.pickBossHitbox(Parent, value82.Runtime.bossHitboxRotIdx)
							end

							if not Parent then
								value82.Remote.fire(v626, "Attacks", "Slash", false)

								return
							end

							for _ = 1, v625 do
								value82.Remote.fire(v626, "Hitboxes", "Register", Parent, value82.Combat.BV(), value82.Combat.timeDiff())
							end

							value82.Runtime.bossHitboxRotIdx = value82.Runtime.bossHitboxRotIdx + 1
						else
							for match in string.gmatch(v623, "([^\31]+)") do
								v558 = children[tonumber(match)]

								if v558 then
									Parent2 = v558.Parent
								else
									Parent2 = v558
								end

								if Parent2 then
									Hitboxes = v558:FindFirstChild("Hitboxes")

									if Hitboxes then
										Hitboxes = Hitboxes:FindFirstChild("Hit")
									end

									if Hitboxes then
										Hitboxes = Hitboxes:FindFirstChild("Nape")
									end

									if Hitboxes then
										value82.Remote.fire(v626, "Hitboxes", "Register", Hitboxes, value82.Combat.BV(), value82.Combat.timeDiff())
									end
								end
							end
						end

						value82.Remote.fire(v626, "Attacks", "Slash", false)

						return
					end

					t17[#t17 + 1] = v.idx
				end

				local v576 = table.concat(t17, "\31")
				local BossBurst = value82.Config.BossBurst or 5
				local v578 = math.clamp(BossBurst, 1, 10)
				local POST = t2.value1.RS.Assets.Remotes.POST

				value82.Remote.fire(POST, "Attacks", "Slash", true)

				if (v548 and 1 or 0) == 1 then
					v553, v554, v555 = string.gmatch(v576, "([^\31]+)")
					v556 = nil

					while true do
						v555 = v553(v554, v555)

						if not v555 then
							break
						end

						v556 = v556 or tonumber(v555)
					end

					if v556 then
						v556 = children[v556]
					end

					Parent = v556 and v556.Parent

					if Parent then
						Parent = v556:FindFirstChild("Hitboxes")
					end

					if Parent then
						Parent = Parent:FindFirstChild("Hit")
					end

					if Parent then
						Parent = value82.Combat.pickBossHitbox(Parent, value82.Runtime.bossHitboxRotIdx)
					end

					if not Parent then
						value82.Remote.fire(POST, "Attacks", "Slash", false)

						return
					end

					for _ = 1, v578 do
						value82.Remote.fire(POST, "Hitboxes", "Register", Parent, value82.Combat.BV(), value82.Combat.timeDiff())
					end

					value82.Runtime.bossHitboxRotIdx = value82.Runtime.bossHitboxRotIdx + 1
				else
					for match in string.gmatch(v576, "([^\31]+)") do
						v558 = children[tonumber(match)]

						if v558 then
							Parent2 = v558.Parent
						else
							Parent2 = v558
						end

						if Parent2 then
							Hitboxes = v558:FindFirstChild("Hitboxes")

							if Hitboxes then
								Hitboxes = Hitboxes:FindFirstChild("Hit")
							end

							if Hitboxes then
								Hitboxes = Hitboxes:FindFirstChild("Nape")
							end

							if Hitboxes then
								value82.Remote.fire(POST, "Hitboxes", "Register", Hitboxes, value82.Combat.BV(), value82.Combat.timeDiff())
							end
						end
					end
				end

				value82.Remote.fire(POST, "Attacks", "Slash", false)
			end
			function value82.Combat.reload()
				if not value82.Config.AutoReload or value82.Runtime.isReloading then
					return
				end

				if tick() - value82.Runtime.fullReloadCooldownTick < 4 then
					return
				end

				if tick() - value82.Runtime.lastReloadTick < 5 then
					return
				end

				local v583 = value82.Char.getBlade1()

				if not v583 or v583.Transparency ~= 1 then
					return
				end

				local Character2 = t2.value3.Character

				if Character2 then
					Character2 = Character2:GetAttribute("IFrames") ~= nil
				end

				if Character2 then
					return
				end

				local Text = value82.Cache.setsLabel and value82.Cache.setsLabel.Text or ""
				local v585 = tonumber(Text:match("^(%d+)"))

				if not v585 or v585 <= 0 then
					return
				end

				value82.Runtime.isReloading = true
				value82.Runtime.lastReloadTick = tick()
				value82.Runtime.attackBlockedTick = tick()

				local function v586()
					value82.Actor.invoke("Blades", "Reload", {
						timeout = 5
					})

					local v587 = tick() + 4

					if v587 >= tick() then
						local v588 = value82.Char.getBlade1()

						if v588 then
							local _ = v588.Transparency == 1
						end
					end

					while true do
						task.wait(0.1)

						local v590

						if v587 < tick() then
							v590 = true
						else
							v590 = value82.Char.getBlade1()

							if v590 then
								v590 = v590.Transparency ~= 1
							end
						end

						if v590 then
							return
						end
					end
				end

				pcall(v586)
				value82.Runtime.attackBlockedTick = 0
				value82.Runtime.isReloading = false
			end
			function value82.Combat.findRefill()
				local ipairs_ = ipairs
				local workspace_ = workspace

				for _, descendant in ipairs_(workspace_.GetDescendants(workspace_)) do
					local isBasePart

					if descendant.Name == "Refill" then
						isBasePart = descendant:IsA("BasePart")
					else
						isBasePart = false
					end

					if isBasePart then
						return descendant
					end
				end

				return nil
			end
			function value82.Combat.spearFullReload()
				if not value82.Config.AutoFullReload then
					return
				end

				local now = tick()

				if not (not value82.Cache.refill or (not value82.Cache.refill.Parent or now - value82.Runtime.lastRefillSearchTick > 10)) then
					if value82.Cache.refill then
						value82.Runtime.lastFullReloadTick = now
						value82.Runtime.fullReloadCooldownTick = now
						value82.Runtime.attackBlockedTick = now
						value82.Actor.send("Attacks", "Reload", value82.Cache.refill)
					end

					return
				end

				value82.Cache.refill = value82.Combat.findRefill()
				value82.Runtime.lastRefillSearchTick = now

				if value82.Cache.refill then
					value82.Runtime.lastFullReloadTick = now
					value82.Runtime.fullReloadCooldownTick = now
					value82.Runtime.attackBlockedTick = now
					value82.Actor.send("Attacks", "Reload", value82.Cache.refill)
				end
			end
			function value82.Combat.fullReload()
				if not value82.Config.AutoFullReload then
					return
				end

				if not value82.Cache.setsLabel then
					if value82.Runtime.bladeInitRunning then
						return
					end

					value82.Runtime.bladeInitRunning = true
					value82.Char.initBladeRefs()
					value82.Runtime.bladeInitRunning = false

					if not value82.Cache.setsLabel then
						return
					end
				end

				if value82.Cache.setsLabel.Text ~= "0 / 3" then
					return
				end

				if not value82.Char.allSetsUsed() then
					return
				end

				local v597 = value82.Char.getBlade1()

				if not v597 or v597.Transparency ~= 1 then
					return
				end

				local now = tick()

				if not (not value82.Cache.refill or (not value82.Cache.refill.Parent or now - value82.Runtime.lastRefillSearchTick > 10)) then
					if value82.Cache.refill then
						value82.Runtime.lastFullReloadTick = now
						value82.Runtime.fullReloadCooldownTick = now
						value82.Runtime.attackBlockedTick = now
						value82.Actor.send("Attacks", "Reload", value82.Cache.refill)
					end

					return
				end

				value82.Cache.refill = value82.Combat.findRefill()
				value82.Runtime.lastRefillSearchTick = now

				if value82.Cache.refill then
					value82.Runtime.lastFullReloadTick = now
					value82.Runtime.fullReloadCooldownTick = now
					value82.Runtime.attackBlockedTick = now
					value82.Actor.send("Attacks", "Reload", value82.Cache.refill)
				end
			end

			value82.Perf = {}
			value82.Perf._origAtmoDensity = nil
			value82.Perf.FOG_AMBIENT_DENSITY = 0.15

			function value82.Perf.setFog(p85)
				t2.value7("Perf.setFog: remove=" .. tostring(p85))

				local function v599()
					local Lighting = t2.value1.Lighting
					local v601 = Lighting.FindFirstChildOfClass(Lighting, "Atmosphere")

					if p85 then
						local function v602()
							if not v601 then
								return
							end

							local Density = v601.Density

							if not (value82.Perf.FOG_AMBIENT_DENSITY < Density) then
								return
							end

							if value82.Perf._origAtmoDensity == nil then
								value82.Perf._origAtmoDensity = Density
							end

							v601.Density = value82.Perf.FOG_AMBIENT_DENSITY
							t2.value7("Perf.setFog: density " .. string.format("%.2f", Density) .. " normalized to " .. value82.Perf.FOG_AMBIENT_DENSITY)
						end

						v602()

						if not (not value82.Conn.FogAtmoMonitor and v601) then
							return
						end

						value82.Connection.add("FogAtmoMonitor", v601:GetPropertyChangedSignal("Density"):Connect(function()
							if not value82.Config.RemoveFog or value82.Perf._fogReapply then
								return
							end

							value82.Perf._fogReapply = true
							task.delay(0.5, function()
								value82.Perf._fogReapply = false

								if not value82.Config.RemoveFog then
									return
								end

								pcall(v602)
							end)
						end))

						return
					end

					value82.Connection.disconnect("FogAtmoMonitor")

					local v604

					if v601 then
						v604 = value82.Perf._origAtmoDensity ~= nil
					else
						v604 = v601
					end

					if v604 then
						v601.Density = value82.Perf._origAtmoDensity
						t2.value7("Perf.setFog: Atmosphere density restored")
					end

					value82.Perf._origAtmoDensity = nil
				end

				pcall(v599)
			end
			function value82.Perf.applyAll()
				local value7 = t2.value7
				local v606 = isInGame
				local v607 = tostring(v606())
				local RemoveFog = value82.Config.RemoveFog

				value7("Perf.applyAll: inGame=" .. v607 .. " fog=" .. tostring(RemoveFog))

				if isInGame() then
					value82.Perf.setFog(value82.Config.RemoveFog)
				else
					t2.value7("Perf.applyAll: skipped (not in game)")
				end
			end

			value82.Runtime.bladeTransparentSince = 0
			value82.Tasks.reload = value82.Task.new("Reload", function(p86)
				value82.Char.initBladeRefs()

				while p86.enabled do
					task.wait(0.5)

					if not p86.enabled then
						return
					end

					if isInGame() then
						if t2.value3:GetAttribute("Weapon") == "Spears" then
							local v609 = value82.Util.safeIndex(t2.value4, "Interface", "HUD", "Main", "Top", "7", "Spears", "Spears")
							local v610 = false
							local v611

							if v609 then
								local Text = v609.Text
								local v613 = tostring(Text)

								v611 = tonumber(v613:match("^%s*(%d+)")) or 0
							else
								v611 = 0
							end

							if v611 <= 0 then
								v610 = not value82.Config.InfiniteSpear
							end

							if v610 then
								value82.Combat.spearFullReload()
							end
						else
							local setsLabel = value82.Cache.setsLabel

							if setsLabel then
								local v615 = value82.Char.getBlade1()

								if v615 then
									v615 = v615.Transparency == 1
								end

								if v615 then
									if value82.Runtime.bladeTransparentSince == 0 then
										value82.Runtime.bladeTransparentSince = tick()
									end

									local Text = setsLabel.Text

									if (tonumber(Text:match("^(%d+)")) or 0) == 0 then
										value82.Combat.fullReload()
									elseif value82.Combat.hasAutoReloadSkill() then
										if tick() - value82.Runtime.bladeTransparentSince > 2 then
											t2.value7("Reload fallback: skill 74 missed, firing Blades,Reload manually")
											value82.Combat.reload()
										end
									else
										value82.Combat.reload()
									end
								else
									value82.Runtime.bladeTransparentSince = 0
								end
							end
						end
					end
				end
			end)

			local function v617()
				value82.Tasks.reload:stop()
			end

			value82.Tasks.streakWatch = value82.Task.new("StreakWatch", function(p87)
				while true do
					if not p87.enabled then
						return
					end

					task.wait(2)

					if not p87.enabled then
						return
					end

					if not (value82.Config.AutoDie and isInGame()) then
						continue
					end

					local sessionStartTick = value82.Runtime.sessionStartTick

					if sessionStartTick > 0 and sessionStartTick < value82.Runtime.rewardedTick and true or sessionStartTick < value82.Runtime.lastFailedTick then
						continue
					end

					local value3 = t2.value3
					local streak = tonumber(value3:GetAttribute("Streak")) or (value82.Stats.streak or 0)
					local AutoDieStreak = value82.Config.AutoDieStreak
					local v622 = tonumber(AutoDieStreak) or 50

					if v622 > streak then
						continue
					end

					local function v627()
						return value82.Features.cutsceneActive()
					end
					local function v628()
						local v629 = value82.Util.safeIndex(t2.value4, "Cache", "Fullscreen_Interface", "Loading_Screen")
						local v630

						if v629 == nil then
							v630 = false
						else
							v630 = v629.Visible
						end

						return v630
					end

					if v627() or v628() then
						t2.value7("StreakWatch: streak hit but cutscene/loading active, waiting to clear before dying")

						local v631 = tick() + 30

						while (tick() < v631 and v627() or v628()) and p87.enabled do
							task.wait(0.5)
						end

						if not p87.enabled then
							return
						end

						if not (value82.Config.AutoDie and isInGame()) then
							continue
						end

						local sessionStartTick2 = value82.Runtime.sessionStartTick

						if sessionStartTick2 > 0 and sessionStartTick2 < value82.Runtime.rewardedTick and true or sessionStartTick2 < value82.Runtime.lastFailedTick then
							continue
						end

						local value32 = t2.value3

						if (tonumber(value32:GetAttribute("Streak")) or (value82.Stats.streak or 0)) < v622 then
							continue
						end

						task.wait(1)
					end

					t2.value7("StreakWatch: streak=" .. streak .. " >= " .. v622 .. ", killing self")
					notify("Auto Die", "Streak " .. streak .. " dying now", 3, "x")
					value82.Stats.dataCopyStamp = 0
					value82.Char.killSelf()
					task.wait(8)

					local function v632()
						local Visible = value82.Util.safeIndex(t2.value4, "Interface", "Rewards")

						if not Visible then
							return Visible or nil
						end

						Visible = Visible.Visible and Visible

						return Visible or nil
					end

					local v633 = tick() + 10

					while true do
						if true then
							local v634

							if tick() < v633 then
								v634 = not v632()
							else
								v634 = false
							end
						end

						if not v680 then
							break
						end

						task.wait(0.5)

						continue
					end

					if v632() then
						t2.value7("StreakWatch: reward screen visible clicking Retry")
						value82.Reward.clickRetrySure()
					else
						t2.value7("StreakWatch: no reward screen leaving to lobby")
						leaveToLobby(20)
					end

					continue
				end
			end)
			value82.Runtime.charSlotIndex = 1
			value82.Tasks.autoSelectChar = value82.Task.new("AutoSelectChar", function(p88)
				if game.PlaceId ~= value82.PLACE.MainMenu then
					t2.value7("AutoSelectChar: not in MainMenu, stopping.")
					p88:stop()

					return
				end

				local charSlots = value82.Lobby.charSlots

				if not charSlots or #charSlots == 0 then
					notify("Auto Select", "No slots configured.", 4, "info")
					p88:stop()

					return
				end

				local v635 = nil

				if not v635 then
					local _ = not p88.enabled
				end

				while true do
					task.wait(0.3)

					local PlayerGui = t2.value3:FindFirstChild("PlayerGui")

					if PlayerGui then
						PlayerGui = PlayerGui:FindFirstChild("Interface")
					end

					if PlayerGui then
						PlayerGui = PlayerGui:FindFirstChild("Title_Screen")
					end

					if PlayerGui then
						PlayerGui = PlayerGui:FindFirstChild("Slots")
					end

					local Visible

					if PlayerGui then
						Visible = PlayerGui.Visible
					else
						Visible = PlayerGui
					end

					if not Visible then
						PlayerGui = v635
					end

					if PlayerGui or not p88.enabled then
						break
					end

					v635 = PlayerGui
				end

				if not v684 then
					t2.value7("AutoSelectChar: Slots GUI not visible")
					notify("Auto Select", "Slots screen did not appear.", 4, "x-circle")
					p88:stop()

					return
				end

				local ok

				if not (value82.Runtime.charSlotIndex > #charSlots) then
					v687 = charSlots[value82.Runtime.charSlotIndex]
					value82.Runtime.charSlotIndex = value82.Runtime.charSlotIndex + 1
					t2.value7("AutoSelectChar: selecting slot", v687)
					v688 = value82.Actor.invoke("Functions", "Select", {
						argsExpr = string.format("%q", v687),
						mapExpr = "out = true",
						timeout = 6
					})

					if v688 then
						ok = v688.ok
					else
						ok = v688
					end

					if ok then
						t2.value7("AutoSelectChar: selected slot", v687, " teleporting to Lobby")
						task.wait(0.5)
						value82.Actor.invoke("Functions", "Teleport", {
							argsExpr = "\"Lobby\"",
							mapExpr = "out = true",
							timeout = 5
						})
					else
						t2.value7("AutoSelectChar: Select failed", v688 and v688.err or "nil")
						notify("Auto Select", "Failed to select slot " .. v687, 4, "x-circle")
					end

					p88:stop()

					return
				end

				value82.Runtime.charSlotIndex = 1

				local v640 = charSlots[value82.Runtime.charSlotIndex]

				value82.Runtime.charSlotIndex = value82.Runtime.charSlotIndex + 1
				t2.value7("AutoSelectChar: selecting slot", v640)

				local Functions = value82.Actor.invoke("Functions", "Select", {
					argsExpr = string.format("%q", v640),
					mapExpr = "out = true",
					timeout = 6
				})

				if Functions then
					ok = Functions.ok
				else
					ok = Functions
				end

				if ok then
					t2.value7("AutoSelectChar: selected slot", v640, " teleporting to Lobby")
					task.wait(0.5)
					value82.Actor.invoke("Functions", "Teleport", {
						argsExpr = "\"Lobby\"",
						mapExpr = "out = true",
						timeout = 5
					})
				else
					t2.value7("AutoSelectChar: Select failed", Functions and Functions.err or "nil")
					notify("Auto Select", "Failed to select slot " .. v640, 4, "x-circle")
				end

				p88:stop()
			end)
			value82.Tasks.attack = value82.Task.new("Attack", function(p89)
				local n10 = 0

				while true do
					if not p89.enabled then
						return
					end

					task.wait(0.3)

					if not p89.enabled then
						return
					end

					if workspace:GetAttribute("Rewarded") or workspace:GetAttribute("Force_End") then
						continue
					end

					if value82.Features.cutsceneActive() then
						n10 = os.clock() + 5

						continue
					else
						if os.clock() < n10 then
							continue
						end

						local currentTitan = value82.Runtime.currentTitan
						local nape = value82.Runtime.nape

						if not (currentTitan and nape and (nape.Parent and currentTitan.Parent and currentTitan:FindFirstChildOfClass("Humanoid"))) then
							continue
						end

						local active = value82.Colossal and value82.Colossal.active

						if active then
							active = value82.Colossal.active()
						end

						if active then
							local v646 = value82
							local v647 = currentTitan == value82.Colossal.boss()

							if v646.Colossal.phase() == 1 then
								if v647 then
									continue
								end

								local _, v649 = value82.Char.get()

								if not v649 or v649:FindFirstChild("Cannon") then
									continue
								end
							end

							if not v647 then
								local v650 = value82.Colossal.erenPos()

								if v650 then
									v650 = (nape.Position - v650).Magnitude > value82.Colossal.EREN_GUARD_RADIUS
								end

								if v650 then
									continue
								end
							end
						end

						local workspace_ = workspace
						local v652 = false
						local v653

						if workspace_.GetAttribute(workspace_, "Type") == "Raids" and workspace:GetAttribute("Objective") == "Attack Titan" then
							v653 = true
						elseif workspace:GetAttribute("Objective") == "Armored Titan" then
							v653 = currentTitan.Name:match("^%x+%-%x+%-%x+%-%x+%-%x+$")
						else
							v653 = false
						end

						if v653 then
							local Objectives = t2.value1.RS:FindFirstChild("Objectives")

							if Objectives and Objectives:FindFirstChild("Defeat_Attack_Titan") or Objectives:FindFirstChild("Defeat_Armored_Titan") then
								v652 = true

								local v655 = value82.Target.raidBossNape()
								local Parent = v655 and v655.Parent

								if Parent then
									Parent = (nape.Position - v655.Position).Magnitude <= 100
								end

								if Parent then
									v652 = false
								end
							end
						end

						if v652 then
							continue
						end

						local attribute = workspace:GetAttribute("Seconds") or 0
						local attribute2 = workspace:GetAttribute("Type")
						local MissionSafetyTimer = attribute2 == "Missions" and value82.Config.MissionSafetyTimer or (attribute2 == "Raids" and value82.Config.RaidSafetyTimer or nil)

						if attribute ~= value82.Runtime.safetySecVal then
							value82.Runtime.safetySecVal = attribute
							value82.Runtime.safetySecStamp = tick()
						end

						local v660 = tick() - value82.Runtime.safetySecStamp > 6
						local RaidBossHpHold = attribute2 == "Raids" and value82.Config.RaidBossHpHold

						if RaidBossHpHold then
							if MissionSafetyTimer then
								RaidBossHpHold = attribute < MissionSafetyTimer
							else
								RaidBossHpHold = MissionSafetyTimer
							end
						end

						if RaidBossHpHold then
							local v662 = value82.Target.raidBossHpPct()
							local v663

							if v662 then
								local RaidBossHpThreshold = value82.Config.RaidBossHpThreshold
								local v665 = tonumber(RaidBossHpThreshold) or 25

								v663 = v662 <= math.clamp(v665, 5, 50)
							else
								v663 = v662
							end

							if v663 then
								local v666

								if v660 then
									if tick() - value82.Runtime.bossHpChipTick < 1.5 then
										v666 = true
									else
										v666 = false
										value82.Runtime.bossHpChipTick = tick()

										if not value82.Runtime.bossHpNotifyTick or tick() - value82.Runtime.bossHpNotifyTick >= 10 then
											value82.Runtime.bossHpNotifyTick = tick()
											t2.value7("BossHpHold: timer frozen at", attribute, "boss", string.format("%.0f%%", v662), "-> slow-chipping to un-stick")
										end
									end
								else
									v666 = true

									if not value82.Runtime.bossHpNotifyTick or tick() - value82.Runtime.bossHpNotifyTick >= 10 then
										value82.Runtime.bossHpNotifyTick = tick()

										local v667 = notify
										local format = string.format
										local v669 = MissionSafetyTimer - attribute

										v667("Safety Timer", format("Boss at %.0f%% HP holding (%ds left)", v662, (math.ceil(v669))), 9, "shield")
									end
								end

								if v666 then
									local _, Position = value82.Char.get()
									local smallTitanNape = value82.Target.smallTitanNape

									if Position then
										Position = Position.Position
									end

									local v673, v674 = smallTitanNape(Position)

									if not (v673 and v674) then
										continue
									end

									local Runtime = value82.Runtime
									local Runtime2 = value82.Runtime

									Runtime.nape = v673
									Runtime2.currentTitan = v674
								end
							end
						end

						local t19 = {
							Slay = true,
							Kill = true
						}
						local t20 = {
							Slay = true,
							Kill = true,
							Defend = true,
							Protect = true,
							Guard = true,
							Protect_HQ = true
						}
						local v679

						if MissionSafetyTimer then
							if attribute < MissionSafetyTimer then
								v679 = not v660
							else
								v679 = false
							end
						else
							v679 = MissionSafetyTimer
						end

						local v681, v682, v683, now, v685, v686, v689, hotbar, v690, Position

						if v679 then
							local attribute3 = workspace:GetAttribute("Objective")
							local Objectives = t2.value1.RS:FindFirstChild("Objectives")
							local v692 = nil

							if Objectives then
								local GetChildren = Objectives.GetChildren

								for _, v in ipairs(GetChildren(Objectives)) do
									if t20[v.Name] then
										v692 = v

										break
									end
								end
							end

							if v692 then
								local Value = v692.Value or 0
								local attribute4 = v692:GetAttribute("Requirement") or 0
								local v698

								if value82.Config.MultiHitEnabled then
									local MultiHit = value82.Config.MultiHit or 1

									v698 = math.max(1, MultiHit) or 1
								else
									v698 = 1
								end

								local t21 = {
									Protect_HQ = true,
									Guard = true,
									Defend = true
								}
								local v701 = false

								if attribute3 == "Breach" then
									if v692.Name == "Protect_HQ" then
										if attribute4 > 1 then
											v701 = attribute4 - 2 <= Value
										else
											v701 = false
										end
									end
								elseif t21[v692.Name] then
									if attribute4 > 1 then
										v701 = attribute4 - 2 <= Value
									else
										v701 = false
									end
								elseif t19[v692.Name] then
									if attribute4 > 1 then
										v701 = attribute4 - v698 <= Value
									else
										v701 = false
									end
								end

								if v701 then
									if not value82.Runtime.safetyNotifyTick or tick() - value82.Runtime.safetyNotifyTick >= 10 then
										value82.Runtime.safetyNotifyTick = tick()

										local v702 = notify
										local format = string.format
										local Name = v692.Name
										local v705 = MissionSafetyTimer - attribute

										v702("Safety Timer", format("Holding %s %d/%d (%ds left)", Name, Value, attribute4, (math.ceil(v705))), 9, "clock")
									end

									continue
								else
									v751 = t2.value3:GetAttribute("Shifting")
									v752 = t2.value3
									v753 = v751 == true

									if v752:GetAttribute("Weapon") == "Spears" then
										v681 = false
									else
										v681 = not v753
									end

									if v681 then
										v682 = value82.Char.getBlade1()

										if v682 then
											v682 = v682.Transparency == 1
										end

										if v682 then
											continue
										end
									end

									value82.Combat.attack()

									if value82.Config.AutoUseSkills then
										v683 = value82.Combat.hasTarget(500)

										if not v753 and v683 then
											now = tick()

											if now - value82.Runtime.lastHumanSkillTick > 0.6 then
												v685 = value82.Combat.humanSkillSlots()

												if v685 then
													v686 = #v685 > 0
												else
													v686 = v685
												end

												if v686 then
													value82.Runtime.lastHumanSkillTick = now

													if value82.Runtime.humanRotIdx > #v685 then
														value82.Runtime.humanRotIdx = 1
													end

													v689 = v685[value82.Runtime.humanRotIdx]
													value82.Runtime.humanRotIdx = value82.Runtime.humanRotIdx % #v685 + 1
													hotbar = value82.Stats.hotbar

													if hotbar then
														hotbar = value82.Stats.hotbar[v689]
													end

													if hotbar then
														v690 = value82.Combat.LOC_SKILLS[hotbar]
													else
														v690 = hotbar
													end

													if v690 then
														Position = v683.Position
													else
														Position = v690
													end

													t2.value7("AutoUseSkills: cast hotbar slot", v689, "id", hotbar or "?")
													value82.Combat.fireSkill(v689, Position or nil, v690 == "tbl")
												end
											end
										end
									end

									continue
								end
							end
						else
							if v660 then
								if MissionSafetyTimer then
									MissionSafetyTimer = attribute < MissionSafetyTimer
								end
							else
								MissionSafetyTimer = v660
							end

							if MissionSafetyTimer and (not value82.Runtime.safetyNotifyTick or tick() - value82.Runtime.safetyNotifyTick >= 10) then
								value82.Runtime.safetyNotifyTick = tick()
								t2.value7("Safety Timer: Seconds frozen at", attribute, "-> attacking to un-stick")
							end
						end

						local attribute3 = t2.value3:GetAttribute("Shifting")
						local value3 = t2.value3
						local v708 = attribute3 == true

						if value3:GetAttribute("Weapon") == "Spears" then
							v681 = false
						else
							v681 = not v708
						end

						if v681 then
							v682 = value82.Char.getBlade1()

							if v682 then
								v682 = v682.Transparency == 1
							end

							if v682 then
								continue
							end
						end

						value82.Combat.attack()

						if value82.Config.AutoUseSkills then
							v683 = value82.Combat.hasTarget(500)

							if not v708 and v683 then
								now = tick()

								if now - value82.Runtime.lastHumanSkillTick > 0.6 then
									v685 = value82.Combat.humanSkillSlots()

									if v685 then
										v686 = #v685 > 0
									else
										v686 = v685
									end

									if v686 then
										value82.Runtime.lastHumanSkillTick = now

										if value82.Runtime.humanRotIdx > #v685 then
											value82.Runtime.humanRotIdx = 1
										end

										v689 = v685[value82.Runtime.humanRotIdx]
										value82.Runtime.humanRotIdx = value82.Runtime.humanRotIdx % #v685 + 1
										hotbar = value82.Stats.hotbar

										if hotbar then
											hotbar = value82.Stats.hotbar[v689]
										end

										if hotbar then
											v690 = value82.Combat.LOC_SKILLS[hotbar]
										else
											v690 = hotbar
										end

										if v690 then
											Position = v683.Position
										else
											Position = v690
										end

										t2.value7("AutoUseSkills: cast hotbar slot", v689, "id", hotbar or "?")
										value82.Combat.fireSkill(v689, Position or nil, v690 == "tbl")
									end
								end
							end
						end

						continue
					end
				end
			end)
			value82.Tasks.movement = value82.Task.new("Movement", function(p90)
				while p90.enabled do
					task.wait(0.1)

					if not p90.enabled then
						value82.Move.cancel()

						return
					end

					local _, v710 = value82.Char.get()

					if v710 then
						value82.Target.update()

						if not value82.Runtime.objectiveMode then
							local AutoTitanMastery = value82.Config.AutoTitanMastery

							if AutoTitanMastery then
								AutoTitanMastery = t2.value3:GetAttribute("Shifting") == true
							end

							if AutoTitanMastery then
								local nape = value82.Runtime.nape
								local currentTitan = value82.Runtime.currentTitan
								local Parent

								if nape then
									Parent = nape.Parent
								else
									Parent = nape
								end

								if Parent then
									local n11 = 40

									if currentTitan then
										currentTitan = currentTitan.PrimaryPart or (currentTitan:FindFirstChild("HumanoidRootPart") or currentTitan:FindFirstChild("Torso"))
									end

									if currentTitan then
										local LookVector = currentTitan.CFrame.LookVector
										local v717 = currentTitan.Position - LookVector * n11
										local vector3 = Vector3.new(v717.X, nape.Position.Y, v717.Z)

										value82.Move.to(v710, vector3, LookVector)
									else
										local v719 = v710.Position - nape.Position
										local Magnitude = v719.Magnitude
										local v721 = nape.Position + (Magnitude > 0.1 and v719 / Magnitude or Vector3.new(0, 0, 1) * n11)

										value82.Move.to(v710, v721, -(v719.Magnitude > 0.1) and v719 / Magnitude or Vector3.new(0, 0, 1))
									end
								else
									value82.Move.cancel()
								end
							else
								local v722, v723 = value82.Target.movingObjective()

								if v722 and v723 then
									value82.Move.to(v710, v722 + Vector3.new(0, value82.Config.HoverHeight, 0))
								else
									local v724 = value82.Target.raidBossNape()

									value82.Runtime.bossHover = v724 ~= nil

									if v724 then
										local v725 = v724.Position + Vector3.new(0, value82.Config.HoverHeight, 0)

										value82.Move.to(v710, value82.Combat.chaseHold(v725, 1000, value82.Config.HoverHeight))
									else
										local nape = value82.Runtime.nape
										local currentTitan = value82.Runtime.currentTitan

										if nape and currentTitan and (currentTitan:FindFirstChildOfClass("Humanoid") and currentTitan.Parent) then
											value82.Move.to(v710, nape.Position + Vector3.new(0, value82.Config.HoverHeight, 0))
										else
											value82.Move.cancel()

											if currentTitan then
												currentTitan = currentTitan.Parent
											end

											if not currentTitan then
												local Runtime = value82.Runtime
												local Runtime2 = value82.Runtime

												Runtime.currentTitan = nil
												Runtime2.nape = nil
											end
										end
									end
								end
							end
						end
					end
				end

				value82.Move.cancel()
			end)
			value82.Tasks.titanMastery = value82.Task.new("TitanMastery", function(p91)
				while true do
					if not p91.enabled then
						return
					end

					task.wait(0.3)

					if not p91.enabled then
						return
					end

					if value82.Runtime.farming and (value82.Config.AutoTitanMastery and isInGame()) and not (workspace:GetAttribute("Rewarded") or workspace:GetAttribute("Force_End")) then
						local titanShifted = t2.value3:GetAttribute("Shifting") == true
						local attribute = t2.value3:GetAttribute("Bar") or 0
						local attribute2 = t2.value3:GetAttribute("Max_Bar") or 100
						local now = tick()

						if titanShifted ~= value82.Runtime.titanShifted then
							value82.Runtime.titanShifted = titanShifted

							if titanShifted then
								value82.Runtime.skillRotIdx = 1
								value82.Runtime.shiftAnimUntil = now + 2.5
								value82.Features.startNoclip()
								t2.value7("TitanMastery: shifted into titan actor refreshed, waiting for shift animation")
							else
								t2.value7("TitanMastery: back to human actor refreshed, charging bar")
							end
						end

						if titanShifted then
							if now >= value82.Runtime.shiftAnimUntil and (value82.Combat.hasTarget(500) and now - value82.Runtime.lastSkillTick > 0.6) then
								value82.Runtime.lastSkillTick = now

								local skillRotIdx = value82.Runtime.skillRotIdx

								for _ = 1, 5 do
									if not value82.Runtime.ejectSlots[skillRotIdx] then
										break
									end

									skillRotIdx = skillRotIdx % 5 + 1
								end

								if value82.Runtime.tossSlots[skillRotIdx] then
									local _, v737 = value82.Char.get()
									local nape = not (v737 and v737.Position + v737.CFrame.LookVector * 80) and value82.Runtime.nape

									if nape then
										nape = value82.Runtime.nape.Position
									end

									t2.value7("TitanMastery: Titan Toss slot", skillRotIdx, "— grab")
									value82.Combat.fireSkill(skillRotIdx, nape)

									for _ = 1, 4 do
										task.wait(0.5)

										if t2.value3:GetAttribute("Target") == nil then
											break
										end

										value82.Combat.fireSkill(skillRotIdx, nape)
										t2.value7("TitanMastery: Titan Toss — throw attempt")
									end
								elseif not value82.Runtime.ejectSlots[skillRotIdx] then
									t2.value7("TitanMastery: skill Usage slot", skillRotIdx, "bar=" .. string.format("%.0f", attribute) .. "/" .. tostring(attribute2))
									value82.Combat.fireSkill(skillRotIdx)
								end

								value82.Runtime.skillRotIdx = skillRotIdx % 5 + 1
							end
						else
							local v740

							if attribute2 <= attribute then
								v740 = now - value82.Runtime.lastShiftTick > 2
							else
								v740 = false
							end

							if v740 then
								value82.Runtime.lastShiftTick = now

								local v741 = value82.Combat.shiftSlot()

								if v741 then
									t2.value7("TitanMastery: bar full (" .. string.format("%.0f", attribute) .. "/" .. tostring(attribute2) .. ") — firing shift on hotbar slot", v741)
									value82.Combat.fireSkill(v741)
								else
									t2.value7("TitanMastery: bar full but shift slot (\'999\') not resolved — retrying")
								end
							end
						end
					end
				end
			end)
			value82.Features = {}

			function value82.Features.startNoclip()
				local Character2 = t2.value3.Character

				if not Character2 then
					return
				end

				(function(p92)
					for _, descendant in ipairs(p92:GetDescendants()) do
						local isBasePart = descendant:IsA("BasePart")

						if isBasePart then
							isBasePart = descendant.CanCollide
						end

						if isBasePart then
							descendant.CanCollide = false
							value82.Cache.disabledParts[descendant] = true
						end
					end
				end)(Character2)
				value82.Connection.add("NoclipNewParts", Character2.DescendantAdded:Connect(function(descendant)
					local farming = value82.Runtime.farming

					if farming then
						farming = descendant:IsA("BasePart")
					end

					if not farming then
						return
					end

					task.defer(function()
						local Parent = descendant

						if Parent then
							Parent = descendant.Parent
						end

						if not Parent then
							return
						end

						descendant.CanCollide = false
						value82.Cache.disabledParts[descendant] = true
					end)
				end))
				value82.Connection.add("NoclipWatch", task.spawn(function()
					while value82.Runtime.farming do
						task.wait(0.5)

						for k in pairs(value82.Cache.disabledParts) do
							local Parent

							if k then
								Parent = k.Parent
							else
								Parent = k
							end

							if Parent then
								pcall(function()
									k.CanCollide = false
								end)
							else
								value82.Cache.disabledParts[k] = nil
							end
						end
					end
				end))
			end
			function value82.Features.initEscape()
				value82.Cache.buttonsFolder = value82.Util.safeIndex(t2.value4, "Interface", "Buttons")
			end
			function value82.Features.setupEscape()
				if not value82.Cache.buttonsFolder then
					value82.Features.initEscape()
				end

				if not value82.Cache.buttonsFolder then
					return
				end

				value82.Connection.add("Escape", value82.Cache.buttonsFolder.ChildAdded:Connect(function(child)
					if not value82.Config.AutoGrabEscape then
						return
					end

					task.wait(0.15)
					value82.Actor.send("Attacks", "Slash_Escape")
					pcall(function()
						child:Destroy()
					end)
					task.wait(0.3)
					value82.Target.update()

					local nape = value82.Runtime.nape

					if not nape then
						return
					end

					value82.Actor.send("Attacks", "Slash", true)

					if not nape then
						return
					end

					local POST = t2.value1.RS.Assets.Remotes.POST

					value82.Remote.fire(POST, "Hitboxes", "Register", nape, value82.Combat.BV(), value82.Combat.timeDiff())
				end))
			end
			function value82.Features.clearESP()
				value82.Connection.disconnect("ESP")
				value82.Connection.disconnect("ESPRemoved")

				if not value82.Cache.espFolder then
					value82.Cache.espFolder = nil
					value82.Cache.espHighlights = {}

					return
				end

				local function v754()
					value82.Cache.espFolder:Destroy()
				end

				pcall(v754)
				value82.Cache.espFolder = nil
				value82.Cache.espHighlights = {}
			end
			function value82.Features.updateESP()
				value82.Features.clearESP()

				local Titans = workspace:FindFirstChild("Titans")

				if not Titans then
					return
				end

				local Folder = Instance.new("Folder")

				Folder.Name = "MahmutESP"
				Folder.Parent = workspace
				value82.Cache.espFolder = Folder

				local function v755(p93)
					if value82.Cache.espHighlights[p93] then
					elseif p93:GetAttribute("State") == "Dead" then
						return
					else
						local Highlight = Instance.new("Highlight")

						Highlight.FillColor = Color3.fromRGB(255, 255, 255)
						Highlight.OutlineColor = Color3.fromRGB(255, 255, 255)
						Highlight.FillTransparency = 0.45
						Highlight.Adornee = p93
						Highlight.Parent = Folder
						value82.Cache.espHighlights[p93] = Highlight

						return
					end
				end

				local GetChildren = Titans.GetChildren

				for _, v in ipairs(GetChildren(Titans)) do
					v755(v)
				end

				local function v760(child)
					if value82.Config.TitanESP and value82.Cache.espFolder then
						task.wait(0.1)
						v755(child)
					end
				end

				value82.Connection.add("ESP", Titans.ChildAdded:Connect(v760))
				value82.Connection.add("ESPRemoved", Titans.ChildRemoved:Connect(function(child)
					local v761 = value82.Cache.espHighlights[child]

					if not v761 then
						value82.Cache.espHighlights[child] = nil

						return
					end

					pcall(function()
						v761:Destroy()
					end)
					value82.Cache.espHighlights[child] = nil
				end))
			end
			function value82.Features.skipCutscene(p94)
				if not (p94 and p94.Parent) then
					return
				end

				task.spawn(function()
					for _ = 1, 10 do
						local v763 = value82.Util.safeIndex(workspace, "Unclimbable", "Cutscene")

						if not v763 or #v763:GetChildren() == 0 then
							return
						end

						t2.value1.VIM:SendKeyEvent(true, Enum.KeyCode.E, false, game)
						task.wait(0.1)
						t2.value1.VIM:SendKeyEvent(false, Enum.KeyCode.E, false, game)
						task.wait(0.5)
					end
				end)
			end
			function value82.Features.startCutsceneMonitor()
				local v764 = value82.Util.safeIndex(workspace, "Unclimbable", "Cutscene")

				if not v764 then
					return
				end

				local GetChildren = v764.GetChildren

				for _, v in ipairs(GetChildren(v764)) do
					value82.Features.skipCutscene(v)
				end

				local function v768(child)
					value82.Features.skipCutscene(child)
				end

				value82.Connection.add("Cutscene", v764.ChildAdded:Connect(v768))
			end
			function value82.Features.stopCutsceneMonitor()
				value82.Connection.disconnect("Cutscene")
			end
			function value82.Features.skipActive()
				local v769 = value82.Util.safeIndex(workspace, "Unclimbable", "Cutscene")

				if v769 then
					local GetChildren = v769.GetChildren

					for _, v in ipairs(GetChildren(v769)) do
						value82.Features.skipCutscene(v)
					end
				end
			end
			function value82.Features.cutsceneActive()
				local v773 = value82.Util.safeIndex(workspace, "Unclimbable", "Cutscene")
				local v774

				if v773 == nil then
					v774 = false
				else
					v774 = #v773:GetChildren() > 0
				end

				return v774
			end

			value82.SoloOnly = {}

			function value82.SoloOnly.Setup()
				value82.Connection.disconnect("SoloOnly")

				if not value82.Config.SoloOnly then
					return
				end

				if not (value82.Runtime.farming and isInGame()) then
					return
				end

				local function v775(p95)
					notify("Solo Only", p95, 5, "log-out")
					value82.Farm.stop()
					task.delay(0.5, function()
						value82.Farm.leaveToLobby(30)
					end)
				end

				local ipairs_ = ipairs
				local value2 = t2.value2

				for _, player in ipairs_(value2.GetPlayers(value2)) do
					if player ~= t2.value3 then
						v775(player.Name .. " detected in server, leaving to lobby.")

						return
					end
				end

				value82.Connection.add("SoloOnly", t2.value2.PlayerAdded:Connect(function(player)
					if player == t2.value3 then
					elseif value82.Config.SoloOnly then
						if value82.Runtime.farming and isInGame() then
							v775(player.Name .. " joined, leaving to lobby.")

							return
						else
							return
						end
					else
						return
					end
				end))
			end

			value82.Farm = {}

			function value82.Farm.leaveToLobby(p96)
				local v780 = tick() + (p96 or 30)

				while true do
					local v781 = isInGame()

					if v781 then
						v781 = tick() < v780
					end

					if not v781 then
						return not isInGame()
					end

					value82.Actor.send("Functions", "Teleport")
					task.wait(2)
				end
			end
			function value82.Farm.start()
				if value82.Runtime.farming then
					return
				end

				value82.Runtime.farming = true
				value82.Stats.FarmStartTime = tick()
				value82.Features.initEscape()
				task.spawn(function()
					if value82.Cache.refill then
						value82.Char.initBladeRefs()

						return
					end

					value82.Cache.refill = value82.Combat.findRefill()
					value82.Char.initBladeRefs()
				end)
				task.spawn(function()
					task.wait(value82.Config.WaitBeforeFarm)

					if not value82.Runtime.farming then
						return
					end

					local v782 = tick() + 30

					while tick() < v782 do
						local PlayerGui = t2.value3:FindFirstChild("PlayerGui")

						if PlayerGui then
							PlayerGui = t2.value3.PlayerGui:FindFirstChild("Cache") and t2.value3.PlayerGui.Cache:FindFirstChild("Fullscreen_Interface")

							if PlayerGui then
								PlayerGui = t2.value3.PlayerGui.Cache.Fullscreen_Interface:FindFirstChild("Loading_Screen")
							end
						end

						if not (PlayerGui and PlayerGui.Visible) then
							break
						end

						t2.value7("Farm.start: waiting for loading screen to disappear...")
						task.wait(1)
					end

					if not value82.Runtime.farming then
						return
					end

					local v784 = tick() + 15

					while tick() < v784 do
						local Character2 = t2.value3.Character

						if Character2 then
							Character2 = Character2:FindFirstChild("HumanoidRootPart")
						end

						if Character2 then
							break
						end

						task.wait(0.5)
					end

					if not value82.Runtime.farming then
						return
					end

					value82.Char.setAnchor(true)
					value82.Features.startNoclip()

					if not value82.Conn.Escape then
						value82.Features.setupEscape()
					end

					local NapeExtender = value82.Config.NapeExtender

					if NapeExtender then
						NapeExtender = not value82.Conn.NapeMonitor
					end

					if NapeExtender then
						value82.Nape.startMonitor()
					end

					value82.Tasks.attack:start()
					value82.Tasks.movement:start()

					if value82.Config.AutoDie then
						value82.Tasks.streakWatch:start()
					end

					if value82.Config.AutoTitanMastery then
						value82.Runtime.titanShifted = false
						value82.Tasks.titanMastery:start()
						t2.value7("TitanMastery: task started with farm")
					end

					local SoloOnly = value82.Config.SoloOnly

					if SoloOnly then
						SoloOnly = value82.Runtime.farming
					end

					if not SoloOnly then
						return
					end

					value82.SoloOnly.Setup()
				end)

				if not value82.Config.TitanESP then
					value82.Features.startCutsceneMonitor()
					value82.Features.skipActive()
					value82.Colossal.startMonitor()
					value82.Tasks.waveMonitor:start()
					notify("Auto Farm", "Started!", 2, "play")

					return
				end

				value82.Features.updateESP()
				value82.Features.startCutsceneMonitor()
				value82.Features.skipActive()
				value82.Colossal.startMonitor()
				value82.Tasks.waveMonitor:start()
				notify("Auto Farm", "Started!", 2, "play")
			end
			function value82.Farm.stop()
				value82.Runtime.farming = false
				value82.Runtime.bossHover = false
				value82.Runtime.attackBlockedTick = 0
				value82.Runtime.fullReloadCooldownTick = 0
				value82.Runtime.isReloading = false
				value82.Move.cancel()
				value82.Tasks.attack:stop()
				value82.Tasks.movement:stop()
				value82.Tasks.streakWatch:stop()
				value82.Tasks.titanMastery:stop()
				value82.Runtime.titanShifted = false
				value82.Runtime.shiftSlot = nil
				value82.Runtime.humanSkillSlots = nil
				value82.Connection.disconnect("NoclipNewParts")
				value82.Connection.disconnect("NoclipWatch")
				value82.Connection.disconnect("SoloOnly")
				value82.Char.setAnchor(false)

				if value82.Config.TitanESP then
					value82.Features.stopCutsceneMonitor()
					value82.Colossal.stopMonitor()
					value82.Tasks.waveMonitor:stop()
					v836 = value82.Runtime
					v837 = value82.Runtime
					v836.currentTitan = nil
					v837.nape = nil

					return
				end

				value82.Features.clearESP()
				value82.Features.stopCutsceneMonitor()
				value82.Colossal.stopMonitor()
				value82.Tasks.waveMonitor:stop()

				local Runtime = value82.Runtime
				local Runtime2 = value82.Runtime

				Runtime.currentTitan = nil
				Runtime2.nape = nil
			end

			value82.DataCopy = {}
			value82.DataCopy.TTL = 30
			value82.DataCopy.fetching = false
			value82.DIFFICULTY_POTENTIAL = {
				{ "Easy", 0 },
				{ "Normal", 2 },
				{ "Hard", 5 },
				{ "Severe", 9 },
				{ "Aberrant", 12 }
			}

			function value82.DataCopy.highestDifficulty(p97)
				local s1 = "Easy"

				for _, v in ipairs(value82.DIFFICULTY_POTENTIAL) do
					if v[2] <= p97 then
						s1 = v[1]
					end
				end

				return s1
			end

			value82.DataCopy.MAP_EXPR = "            if type(res) ~= \"table\" then out = nil; return end\n            local slot = res.Current_Slot\n            local s    = slot and res.Slots and res.Slots[slot]\n            local prog = s and s.Progression or {}\n            local st   = res.Statistics and res.Statistics.Streak\n            local tk   = res.Statistics and res.Statistics.Titan_Kills\n            local dis  = res.Disabled\n            -- weapon / upgrades / potential\n            local weapon = tostring(s and s.Weapon or \"Blades\")\n            local upgrades = (s and s.Upgrades and s.Upgrades[weapon]) or {}\n            local total, count = 0, 0\n            for _, lv in pairs(upgrades) do total = total + (tonumber(lv) or 0); count = count + 1 end\n            local potential = count > 0 and math.floor(total / count) or 0\n            local upMap = {}\n            for stat, lv in pairs(upgrades) do upMap[tostring(stat)] = lv end\n            -- skill loadout\n            local sk = s and s.Skills\n            local hb, sh = sk and sk.Hotbar, sk and sk.Shifter\n            -- human hotbar slots 1-5\n            local hotbar = {}\n            if type(hb) == \"table\" then\n                for i = 1, 5 do hotbar[i] = tostring(hb[i] or \"\") end\n            end\n            -- titan skill loadout: shift slot + eject/toss (Shifter)\n            local shift, eject, toss = nil, {}, {}\n            if type(hb) == \"table\" then\n                for i = 1, 5 do if tostring(hb[i]) == \"999\" then shift = i; break end end\n            end\n            if type(sh) == \"table\" then\n                for i = 1, 5 do\n                    local id = tostring(sh[i])\n                    if id == \"200\" or id == \"300\" or id == \"400\" or id == \"500\" then eject[tostring(i)] = true end\n                    if id == \"301\" then toss[tostring(i)] = true end\n                end\n            end\n            -- unlocked skill IDs (set keyed by id string, value true)\n            local unlockedSkills = {}\n            local skillsUnlocked = sk and sk.Unlocked\n            if type(skillsUnlocked) == \"table\" then\n                for _, id in pairs(skillsUnlocked) do\n                    unlockedSkills[tostring(id)] = true\n                end\n            end\n            -- unequipped perk storage (rarity resolved after invoke, outside loadstring env)\n            local perkStorage = {}\n            local perksData = s and s.Perks\n            if perksData then\n                local equipped = {}\n                if type(perksData.Equipped) == \"table\" then\n                    for _, uuid in pairs(perksData.Equipped) do\n                        if type(uuid) == \"string\" and uuid ~= \"\" then equipped[uuid] = true end\n                    end\n                end\n                if type(perksData.Storage) == \"table\" then\n                    for id, info in pairs(perksData.Storage) do\n                        if type(info) == \"table\" and not equipped[tostring(id)] then\n                            perkStorage[#perkStorage+1] = {\n                                id   = tostring(id),\n                                name = tostring(info.Name or \"\"),\n                            }\n                        end\n                    end\n                end\n            end\n            out = {\n                slot     = tostring(slot or \"\"),\n                level    = tonumber(prog.Level)    or 0,\n                prestige = tonumber(prog.Prestige) or 0,\n                streak   = tonumber(st and st.Total) or 0,\n                titanKills = tonumber(tk and tk.Total) or 0,\n                disabled = (type(dis) == \"string\" and dis ~= \"\") and dis or false,\n                weapon = weapon, upgrades = upMap, potential = potential, hotbar = hotbar,\n                shiftSlot = shift, ejectSlots = eject, tossSlots = toss,\n                perkStorage = perkStorage,\n                unlockedSkills = unlockedSkills,\n            }\n"

			function value82.DataCopy.fetch(p98)
				if value82.DataCopy.fetching then
					return false
				end

				local v793 = not p98

				if v793 then
					v793 = tick() - (value82.Stats.dataCopyStamp or 0) < value82.DataCopy.TTL
				end

				if v793 then
					return false
				end

				value82.DataCopy.fetching = true

				local v794 = value82.Actor.invokeGET({
					"Functions",
					"Settings",
					"Blur",
					"Off"
				}, value82.DataCopy.MAP_EXPR)

				value82.DataCopy.fetching = false

				local v795 = not (v794 and v794.ok)
				local data

				if v795 then
					if v795 then
						t2.value7("DataCopy.fetch: failed", v794 and v794.err or "nil")

						return false
					else
						data = v794.data

						return value82.DataCopy._apply(data)
					end
				end

				local data2 = v794.data

				v795 = type(data2) ~= "table"

				if v795 then
					t2.value7("DataCopy.fetch: failed", v794 and v794.err or "nil")

					return false
				else
					data = v794.data

					return value82.DataCopy._apply(data)
				end
			end
			function value82.DataCopy._apply(p99)
				value82.Stats.dataCopyStamp = tick()
				value82.Stats.statsStamp = tick()

				if p99.weapon then
					value82.Stats.weapon = p99.weapon
				end

				local weapon = p99.weapon

				if weapon then
					local upgrades = p99.upgrades

					weapon = type(upgrades) == "table"
				end

				if weapon then
					value82.Stats.upgrades[p99.weapon] = p99.upgrades
				end

				value82.Stats.potential = p99.potential or 0

				local hotbar = p99.hotbar

				if type(hotbar) == "table" then
					local hotbar2 = {}
					local humanSkillSlots = {}

					for i = 1, 5 do
						local v804 = p99.hotbar[i] or ""
						local v805 = tostring(v804)

						hotbar2[i] = v805

						local v806

						if v805 == "" or v805 == "999" then
							v806 = false
						else
							v806 = v805 ~= "nil"
						end

						if v806 then
							humanSkillSlots[#humanSkillSlots + 1] = i
						end
					end

					value82.Stats.hotbar = hotbar2
					value82.Runtime.humanSkillSlots = humanSkillSlots
				end

				value82.Runtime.shiftSlot = p99.shiftSlot
				value82.Runtime.ejectSlots = {}
				value82.Runtime.tossSlots = {}

				if type(p99.ejectSlots) == "table" then
					for k in pairs(p99.ejectSlots) do
						value82.Runtime.ejectSlots[tonumber(k)] = true
					end
				end

				if type(p99.tossSlots) == "table" then
					for k in pairs(p99.tossSlots) do
						value82.Runtime.tossSlots[tonumber(k)] = true
					end
				end

				local disabled = p99.disabled

				value82.Stats.shadowBan = disabled and true or false

				local Stats = value82.Stats

				if disabled then
					disabled = tostring(disabled)
				end

				Stats.disabledReason = disabled or nil
				value82.Stats.streak = p99.streak
				value82.Stats.titanKills = p99.titanKills or (value82.Stats.titanKills or 0)

				local unlockedSkills = p99.unlockedSkills

				if type(unlockedSkills) == "table" then
					value82.Stats.unlockedSkills = p99.unlockedSkills
					t2.value7("DataCopy: unlockedSkills=" .. value82.Util.count(p99.unlockedSkills))
				end

				local perkStorage = p99.perkStorage
				local v813

				if type(perkStorage) == "table" then
					v813 = #p99.perkStorage > 0
				else
					v813 = false
				end

				if v813 then
					local v814 = nil

					local function v815()
						local Perks = require(game:GetService("ReplicatedStorage").Modules.Storage.Perks)
						local v817

						if type(Perks) == "table" then
							v870 = 0

							for k, Perk in pairs(Perks) do
								if type(Perk) == "table" then
									v817 = type(k) == "string"
								else
									v817 = false
								end

								if v817 then
									for k2 in pairs(Perk) do
										if type(k2) == "string" then
											v814[k2] = k
											v870 = v870 + 1
										end
									end
								end
							end

							t2.value7("DataCopy: perkRarityOf built,", v870, "entries")

							return
						end

						error("PM not a table: " .. type(Perks))

						local n12 = 0

						for k, Perk in pairs(Perks) do
							if type(Perk) == "table" then
								v817 = type(k) == "string"
							else
								v817 = false
							end

							if v817 then
								for k2 in pairs(Perk) do
									if type(k2) == "string" then
										v814[k2] = k
										n12 = n12 + 1
									end
								end
							end
						end

						t2.value7("DataCopy: perkRarityOf built,", n12, "entries")
					end

					v814 = {}

					local t22 = { pcall(v815) }
					local v826 = t22[2]

					if not t22[1] then
						t2.value7("DataCopy: require Perks failed:", v826)
					end

					local v827 = v814

					for _, v in ipairs(p99.perkStorage) do
						v.rarity = v827[v.name] or "Unknown"
					end

					value82.Stats.perkStorage = p99.perkStorage
					t2.value7("DataCopy: resolved rarity for", #p99.perkStorage, "storage perks")
				end

				if p99.slot == "" then
					v880 = t2.value7
					v881 = string.format
					v882 = p99.slot
					v883 = p99.level
					v884 = p99.prestige
					v885 = p99.streak
					v886 = p99.disabled
					v880(v881("DataCopy.fetch: slot=%s lvl=%d prestige=%d streak=%d banned=%s", v882, v883, v884, v885, (tostring(v886))))
					task.defer(value82.DB.save)

					return true
				end

				value82.Stats.currentSlot = p99.slot

				local v830

				if p99.prestige < value82.Prestige.MAX_TIER then
					v830 = p99.level >= value82.Prestige.maxLevelFor(p99.prestige)
				else
					v830 = false
				end

				value82.Stats.prestigeSnapshot[p99.slot] = {
					level = p99.level,
					prestige = p99.prestige,
					ready = v830
				}
				value82.Stats.prestigeStamp = tick()

				local value7 = t2.value7
				local format = string.format
				local slot = p99.slot
				local level = p99.level
				local prestige = p99.prestige
				local streak = p99.streak
				local disabled2 = p99.disabled

				value7(format("DataCopy.fetch: slot=%s lvl=%d prestige=%d streak=%d banned=%s", slot, level, prestige, streak, (tostring(disabled2))))
				task.defer(value82.DB.save)

				return true
			end

			value82.Prestige = value82.Prestige or {}
			value82.Prestige.MAX_TIER = 5

			function value82.Prestige.maxLevelFor(p100)
				return 100 + (tonumber(p100) or 0) * 25
			end
			function value82.Prestige.fetch(p101)
				value82.DataCopy.fetch(p101)
			end
			function value82.Prestige.snapshot()
				local currentSlot = value82.Stats.currentSlot

				if not currentSlot then
					return currentSlot or nil
				end

				currentSlot = value82.Stats.prestigeSnapshot[currentSlot]

				return currentSlot or nil
			end

			value82.Prestige.BOOST_TAG = {
				Luck = "Luck Boost",
				EXP = "EXP Boost",
				Gold = "Gold Boost"
			}

			function value82.Prestige.readGold()
				local v839 = tick() + 5
				local _ = v839 < tick()

				while true do
					local v841 = value82.Util.safeIndex(t2.value4, "Interface", "Topbar", "Main", "Currencies", "Gold", "Amount")

					if not v841 then
						task.wait(0.5)
					end

					if v841 or v839 < tick() then
						if v841 then
							local Text = v841.Text
							local v843 = tostring(Text)
							local v844 = v843:gsub("[%s,]", "")
							local v845 = tonumber(v844)

							t2.value7("readGold: raw=" .. v843 .. " result=" .. tostring(v845))

							return v845
						else
							t2.value7("readGold: label not found after 5s")

							return nil
						end
					end
				end
			end
			function value82.Prestige.runOnce()
				local v846 = value82.Prestige.snapshot()

				if not v846 then
					return false, "no snapshot (enter a game first)"
				end

				if not v846.ready then
					return false, "not eligible (Lvl/Prestige)"
				end

				local v847 = (v846.prestige or 0) + 1

				if v847 > 5 then
					return false, "max prestige"
				end

				local v848 = value82.Config.PrestigeGold[v847] or 0

				if v848 > 0 then
					local v849 = value82.Prestige.readGold()

					if not v849 then
						return false, "gold unreadable"
					end

					if v849 < v848 then
						return false, string.format("gold %d/%d", v849, v848)
					end
				end

				local S_Equipment = value82.Actor.invokeMulti("S_Equipment", "Talents", "nil", "        local ids = b\n        if type(ids) ~= \"table\" then out = nil; return end\n        local Mem = require(game:GetService(\"ReplicatedStorage\").Modules.Storage.Memories)\n        local root = Mem.Talents or Mem\n        local RANK = { Common = 1, Uncommon = 2, Rare = 3, Epic = 4 }\n        local bestTag, bestRank\n        for _, id in ipairs(ids) do\n            for tier, bucket in pairs(root) do\n                local e = type(bucket) == \"table\" and bucket[tostring(id)]\n                if e and e.Tag then\n                    local r = RANK[tier] or 0\n                    if not bestRank or r > bestRank then bestTag, bestRank = e.Tag, r end\n                end\n            end\n        end\n        out = bestTag and { tag = bestTag } or nil\n    ", 8)
				local v851 = not S_Equipment

				if not v851 then
					v851 = not S_Equipment.ok

					if not v851 then
						local data = S_Equipment.data

						v851 = type(data) ~= "table" and true or not S_Equipment.data.tag
					end
				end

				if v851 then
					return false, "Talents roll failed"
				end

				local tag = S_Equipment.data.tag
				local v854 = value82.Prestige.BOOST_TAG[value82.Config.PrestigeBoost[v847] or "Gold"] or "Gold Boost"
				local t23 = {
					argsExpr = string.format("{ Boosts = %q, Talents = %q }", v854, tag),
					mapExpr = "out = (res ~= nil)",
					timeout = 10
				}
				local S_Equipment2 = value82.Actor.invoke("S_Equipment", "Prestige", t23)

				if not (S_Equipment2 and S_Equipment2.ok) then
					return false, "Prestige invoke failed"
				end

				local currentSlot = value82.Stats.currentSlot
				local v858

				if currentSlot then
					v858 = value82.Stats.prestigeSnapshot[currentSlot]
				else
					v858 = currentSlot
				end

				if not v858 then
					t2.value7(string.format("Prestige.runOnce: P%d->%d boost=%s memory=%s", v846.prestige, v847, v854, tag))

					return true, string.format("P%d -> %d (%s, %s)", v846.prestige, v847, v854, tag)
				end

				local v859 = value82
				local prestige = v846.prestige + 1

				v859.Stats.prestigeSnapshot[currentSlot].prestige = prestige

				local v861 = value82.Stats.prestigeSnapshot[currentSlot]
				local ready

				if prestige < value82.Prestige.MAX_TIER then
					ready = v846.level >= value82.Prestige.maxLevelFor(prestige)
				else
					ready = false
				end

				v861.ready = ready
				t2.value7(string.format("Prestige.runOnce: P%d->%d boost=%s memory=%s", v846.prestige, v847, v854, tag))

				return true, string.format("P%d -> %d (%s, %s)", v846.prestige, v847, v854, tag)
			end

			local function v863(p102)
				local paragraphs = value82.UI.paragraphs

				if paragraphs then
					paragraphs = value82.UI.paragraphs.prestige
				end

				if not paragraphs then
					return
				end

				value82.UI.setParagraph(value82.UI.paragraphs.prestige, p102)
			end

			value82.Tasks.autoPrestige = value82.Task.new("AutoPrestige", function(p103)
				v180("AutoPrestige")

				if isInGame() then
					v863("Skipped in a game.")
					value82.Lobby.busyLobby.AutoPrestige = nil

					return
				end

				v863("Checking prestige eligibility...")

				while true do
					local enabled = p103.enabled

					if enabled then
						enabled = not isInGame()
					end

					if not enabled then
						value82.Lobby.busyLobby.AutoPrestige = nil

						return
					end

					local v866, prestiged = value82.Prestige.runOnce()

					if not v866 then
						break
					end

					notify("Auto Prestige", prestiged, 6, "award")
					v863("Prestiged: " .. prestiged)
					value82.Stats.statsStamp = 0
					value82.Stats.prestigeStamp = 0
					value82.Stats.dataCopyStamp = 0
					value82.Stats.unlockedSkills = {}
					value82.Stats.potential = nil
					value82.Stats.weapon = nil
					value82.Stats.upgrades = {}
					task.wait(8)
				end

				v863("Done " .. tostring(v919))
				value82.Lobby.busyLobby.AutoPrestige = nil
			end)
			value82.DB = {}
			value82.DB.FOLDER = "WindUI/Mahmut-Hub/AOTR/PlayerDB"
			value82.DB.FILE = value82.DB.FOLDER .. "/" .. t2.value3.Name .. "_data.json"
			value82.DB.loaded = false

			function value82.DB.save()
				if not t2.value5.writefile then
					return
				end

				if value82.Lobby.restoring or not value82.DB.loaded then
					return
				end

				local function v868()
					local v869 = t2.value5.isfolder and not t2.value5.isfolder(value82.DB.FOLDER)

					if v869 then
						v869 = t2.value5.makefolder
					end

					if not v869 then
						v923 = {
							autoLobbyCounter = value82.Runtime.autoLobbyCount,
							questCache = value82.Lobby.questCache,
							stats = {}
						}

						for _, v in ipairs({
							"MissionsCompleted",
							"RaidsCompleted",
							"GoldCollected",
							"GemsCollected",
							"CanesCollected",
							"ExpCollected",
							"PrestigeScrolls",
							"EpicPerksCollected",
							"LegendaryPerks",
							"MythicPerks",
							"TitanSerums",
							"TitanShards",
							"ItemDrops"
						}) do
							v923.stats[v] = value82.Stats[v]
						end

						t2.value5.writefile(value82.DB.FILE, t2.value1.Http:JSONEncode(v923))

						return
					end

					t2.value5.makefolder(value82.DB.FOLDER)

					local t24 = {
						autoLobbyCounter = value82.Runtime.autoLobbyCount,
						questCache = value82.Lobby.questCache,
						stats = {}
					}

					for _, v in ipairs({
						"MissionsCompleted",
						"RaidsCompleted",
						"GoldCollected",
						"GemsCollected",
						"CanesCollected",
						"ExpCollected",
						"PrestigeScrolls",
						"EpicPerksCollected",
						"LegendaryPerks",
						"MythicPerks",
						"TitanSerums",
						"TitanShards",
						"ItemDrops"
					}) do
						t24.stats[v] = value82.Stats[v]
					end

					t2.value5.writefile(value82.DB.FILE, t2.value1.Http:JSONEncode(t24))
				end

				pcall(v868)
			end
			function value82.DB.load()
				if not (t2.value5.isfile and t2.value5.readfile) then
					value82.DB.loaded = true

					return
				end

				pcall(function()
					if not t2.value5.isfile(value82.DB.FILE) then
						return
					end

					local data = t2.value1.Http:JSONDecode(t2.value5.readfile(value82.DB.FILE))
					local autoLobbyCounter = data.autoLobbyCounter

					if type(autoLobbyCounter) == "number" then
						value82.Runtime.autoLobbyCount = data.autoLobbyCounter
					end

					local questCache = data.questCache

					if type(questCache) == "table" then
						value82.Lobby.questCache = data.questCache
					end

					if type(data.stats) ~= "table" then
						return
					end

					for k, stat in pairs(data.stats) do
						if value82.Stats[k] ~= nil then
							value82.Stats[k] = stat
						end
					end
				end)
				value82.DB.loaded = true
			end
			function value82.DB.checkShadowBan()
				if value82.LOBBY_PLACE_IDS[game.PlaceId] then
					value82.DataCopy.fetch()

					local attribute = t2.value3:GetAttribute("Blacklisted")
					local attribute2 = t2.value3:GetAttribute("Exploiter")

					if (attribute == true or attribute2 == true) and true or value82.Stats.shadowBan == true then
						return "SHADOW_BANNED", value82.Stats.disabledReason or (attribute == true and true or (attribute2 == true and "Blacklisted/Exploiter" or "Disabled"))
					else
						return "SAFE", nil
					end
				elseif (value82.Stats.dataCopyStamp or 0) > 0 then
					if value82.Stats.shadowBan then
						return "SHADOW_BANNED", value82.Stats.disabledReason or "Disabled field set"
					else
						return "SAFE", nil
					end
				elseif value82.Stats.shadowBan == nil then
					return "UNKNOWN", nil
				else
					return value82.Stats.shadowBan and "SHADOW_BANNED" or "SAFE", value82.Stats.disabledReason
				end
			end

			value82.Mission = {}
			value82.Mission.MAPS = {
				{
					name = "Shiganshina",
					objectives = { "Skirmish", "Breach" }
				},
				{
					name = "Trost",
					objectives = { "Skirmish", "Protect" }
				},
				{
					name = "Outskirts",
					objectives = { "Skirmish", "Escort" }
				},
				{
					name = "Forest",
					objectives = { "Skirmish", "Guard" }
				},
				{
					name = "Utgard",
					objectives = { "Skirmish", "Defend" }
				},
				{
					name = "Docks",
					objectives = { "Skirmish", "Stall" }
				},
				{
					name = "Stohess",
					objectives = { "Skirmish" }
				},
				{
					name = "Chapel",
					objectives = { "Skirmish" }
				}
			}
			value82.Mission.MODIFIERS = {
				"No Perks",
				"No Skills",
				"No Memories",
				"Nightmare",
				"Oddball",
				"Injury Prone",
				"Chronic Injuries",
				"Fog",
				"Time Trial",
				"Glass Cannon",
				"Boring",
				"Simple"
			}
			value82.Mission.DIFFICULTIES = {
				"Easy",
				"Normal",
				"Hard",
				"Severe",
				"Aberrant"
			}
			value82.Mission.PERKS_RARITIES = {
				"Common",
				"Rare",
				"Epic",
				"Legendary"
			}
			value82.Mission.ALL_OBJECTIVES = (function()
				local t25 = {}
				local t26 = {}

				for _, map in ipairs(value82.Mission.MAPS) do
					for _, objective in ipairs(map.objectives) do
						if not t25[objective] then
							t25[objective] = true
							t26[#t26 + 1] = objective
						end
					end
				end

				return t26
			end)()

			function value82.Mission.objectivesFor(p104)
				for _, map in ipairs(value82.Mission.MAPS) do
					if map.name == p104 then
						return map.objectives
					end
				end

				return { "Skirmish" }
			end
			function value82.Mission.asStr(p105)
				local v890

				if type(p105) ~= "table" then
					if type(p105) == "string" then
						v890 = p105
					else
						v890 = false
					end

					return v890 or tostring(p105 or "")
				end

				local v891 = p105[1]

				if type(v891) == "string" then
					p105 = p105[1]
				else
					for k, v in pairs(p105) do
						local v894

						if v == true then
							v894 = type(k) == "string"
						else
							v894 = false
						end

						if v894 then
							p105 = k

							break
						end
					end
				end

				if type(p105) == "string" then
					v890 = p105
				else
					v890 = false
				end

				return v890 or tostring(p105 or "")
			end

			local function v895(p106)
				value82.UI.setParagraph(value82.UI.paragraphs.mission, p106)
			end

			function value82.Mission.create()
				local asStr = value82.Mission.asStr
				local t27 = {
					argsExpr = string.format("{ Name = %q, Difficulty = %q, Type = \"Missions\", Objective = %q, Minimum = nil }", asStr(value82.Lobby.missionMap), asStr(value82.Lobby.missionDifficulty), asStr(value82.Lobby.missionObjective)),
					mapExpr = "        if typeof(res) == \"Instance\" and res.Name then\n            out = { ok = true, name = res.Name, mtype = res:GetAttribute(\"Type\") }\n        else\n            out = { ok = false, retType = typeof(res), retVal = tostring(res) }\n        end\n    ",
					timeout = 8
				}
				local S_Missions = value82.Actor.invoke("S_Missions", "Create", t27)

				if not S_Missions then
					t2.value7("Mission.create: nil (timeout/no actor)")

					return nil
				end

				local data = S_Missions.data

				if not (not S_Missions.ok or (type(data) ~= "table" and true or not data.ok)) then
					local value7 = t2.value7
					local name = data.name
					local v902 = tostring(name)
					local mtype = data.mtype

					value7("Mission.create: OK name=" .. v902 .. " type=" .. tostring(mtype))

					return {
						ok = true,
						name = data.name,
						mtype = data.mtype
					}
				end

				local value7 = t2.value7
				local s2 = "Mission.create: rejected — serverReturn type="
				local tostring_ = tostring
				local retType

				if data then
					retType = data.retType
				else
					retType = data
				end

				local v908 = tostring_(retType)
				local s3 = " val="
				local tostring_2 = tostring

				if not data then
					v963 = tostring_2(data)
					v964 = S_Missions.err
					value7(s2 .. v908 .. s3 .. v963 .. " err=" .. tostring(v964))

					return {
						ok = false
					}
				end

				data = data.retVal

				local v911 = tostring_2(data)
				local err = S_Missions.err

				value7(s2 .. v908 .. s3 .. v911 .. " err=" .. tostring(err))

				return {
					ok = false
				}
			end
			function value82.Mission.start()
				local S_Missions = value82.Actor.invoke("S_Missions", "Start", {
					timeout = 8
				})
				local v914

				if S_Missions == nil then
					v914 = false
				else
					v914 = S_Missions.ok == true
				end

				return v914
			end
			function value82.Mission.toggleModifier(p107)
				value82.Actor.invoke("S_Missions", "Modify", {
					argsExpr = string.format("%q", p107),
					mapExpr = "out = true",
					timeout = 5
				})
			end
			function value82.Mission.leave()
				local S_Missions = value82.Actor.invoke("S_Missions", "Leave", {
					mapExpr = "out = (res == true)",
					timeout = 5
				})
				local v916

				if S_Missions == nil or S_Missions.ok ~= true then
					v916 = false
				else
					v916 = S_Missions.data == true
				end

				return v916
			end

			local function v917(p108, p109, p110, p111, p112)
				p109("Creating session...")

				local v918 = p110()

				if v918 == nil then
					p109("Timeout.")

					return false, "timeout"
				elseif v918.ok then
					for _, v in ipairs(p111) do
						value82.Mission.toggleModifier(v)
						task.wait(0.3)
					end

					p109("Starting session...")
					task.wait(0.5)

					if value82.Mission.start() then
						local v921 = #p111 > 0 and " [" .. table.concat(p111, ", ") .. "]" or ""

						p109("Started! " .. (v918.name or p112) .. v921)
						t2.value7(p108 .. " started:", v918.name or p112, v921)

						return true
					else
						p109("Start failed destroying session...")
						notify(p108, "Failed to start, destroying...", 3, "skull")
						value82.Mission.leave()

						return false, "start_failed"
					end
				else
					p109("Failed clearing old session...")
					t2.value7(p108 .. ".createStartOnce: create failed -> leaving any existing session")
					value82.Mission.leave()
					task.wait(0.5)

					return false, "failed"
				end
			end

			function value82.Mission.createStartOnce()
				return v917("Mission", v895, value82.Mission.create, value82.Lobby.missionModifiers, value82.Lobby.missionMap)
			end

			value82.Mission.DIFFICULTY_ORDER = {
				"Easy",
				"Normal",
				"Hard",
				"Severe",
				"Aberrant"
			}

			function value82.Mission.lowerDifficulty(p113)
				local v922 = nil

				for i, v in ipairs(value82.Mission.DIFFICULTY_ORDER) do
					if v == p113 then
						v922 = i

						break
					end
				end

				if not v922 or v922 <= 1 then
					return nil
				else
					return value82.Mission.DIFFICULTY_ORDER[v922 - 1]
				end
			end

			value82.Tasks.autoCreate = value82.Task.new("AutoCreate", function(p114)
				local n13 = 0

				while true do
					if not p114.enabled then
						v895("Idle.")

						return
					end

					if isInGame() then
						v895("Stopped entered game.")

						return
					end

					while true do
						local enabled = p114.enabled and value82.Lobby.anyLobbyBusy()

						if enabled then
							enabled = not isInGame()
						end

						if not enabled then
							break
						end

						v895("Waiting: " .. value82.Lobby.busyNames() .. " still running...")
						task.wait(1)
					end

					if not p114.enabled or isInGame() then
						v895("Idle.")

						return
					end

					local v927, thunderMode, v929

					if value82.Lobby.autoCreate.boosted then
						local attribute = workspace:GetAttribute("Boosted_Map")
						local v931, v932, v933 = ipairs(value82.Mission.MAPS)
						local v934 = false

						while true do
							local v935

							v933, v935 = v931(v932, v933)

							if not v933 then
								break
							end

							if v935.name == attribute then
								v934 = true

								break
							end
						end

						if attribute and v934 then
							local missionMap = value82.Lobby.missionMap
							local missionObjective = value82.Lobby.missionObjective

							value82.Lobby.missionMap = attribute

							local v938 = value82.Mission.objectivesFor(attribute)

							if value82.Lobby.missionObjective == "Skirmish" then
								value82.Lobby.missionObjective = "Skirmish"
							else
								value82.Lobby.missionObjective = v938[2] or (v938[1] or "Skirmish")
							end

							v895("Boosted map: " .. attribute .. " (" .. value82.Lobby.missionObjective .. ") creating...")

							local v939

							v927, v939 = value82.Mission.createStartOnce()

							local Lobby = value82.Lobby
							local Lobby2 = value82.Lobby

							Lobby.missionMap = missionMap
							Lobby2.missionObjective = missionObjective

							if v927 then
								v895("Idle.")

								return
							end

							n13 = n13 + 1

							if n13 >= 2 then
								thunderMode = not value82.Lobby.questOverride or value82.Lobby.thunderMode
							else
								thunderMode = false
							end

							if thunderMode then
								v929 = value82.Mission.lowerDifficulty(value82.Lobby.missionDifficulty)

								if v929 then
									value82.Lobby.missionDifficulty = v929
									value82.UI.selectDropdown(value82.UI.dropdowns.difficulty, v929)
									notify("Auto Create", "Repeated fails lowering difficulty to " .. v929, 4, "trending-down")
									t2.value7("AutoCreate fallback: difficulty -> " .. v929)
									v895("Lowered difficulty to " .. v929 .. " retrying...")
									n13 = 0
								else
									v895("Failing at Easy retrying...")
								end
							end

							v1002 = task.wait
							v1003 = n13 * 2 - 1
							v1002((math.clamp(v1003, 1, 6)))

							continue
						else
							v895("Waiting for any boosted map...")
							task.wait(5)

							continue
						end
					else
						local v942

						v927, v942 = value82.Mission.createStartOnce()
					end

					if v927 then
						v895("Idle.")

						return
					end

					n13 = n13 + 1

					if n13 >= 2 then
						thunderMode = not value82.Lobby.questOverride or value82.Lobby.thunderMode
					else
						thunderMode = false
					end

					if thunderMode then
						v929 = value82.Mission.lowerDifficulty(value82.Lobby.missionDifficulty)

						if v929 then
							value82.Lobby.missionDifficulty = v929
							value82.UI.selectDropdown(value82.UI.dropdowns.difficulty, v929)
							notify("Auto Create", "Repeated fails lowering difficulty to " .. v929, 4, "trending-down")
							t2.value7("AutoCreate fallback: difficulty -> " .. v929)
							v895("Lowered difficulty to " .. v929 .. " retrying...")
							n13 = 0
						else
							v895("Failing at Easy retrying...")
						end
					end

					local wait_ = task.wait
					local v944 = n13 * 2 - 1

					wait_((math.clamp(v944, 1, 6)))

					continue
				end
			end)
			value82.Raid = {}
			value82.Raid.MAPS = {
				"Shiganshina",
				"Trost",
				"Forest",
				"Outskirts",
				"Utgard",
				"Docks",
				"Stohess",
				"Chapel"
			}
			value82.Raid.OBJECTIVES = {
				"Attack Titan",
				"Armored Titan",
				"Female Titan",
				"Colossal Titan"
			}
			value82.Raid.DIFFICULTIES = { "Hard", "Severe", "Aberrant" }
			value82.Raid.OBJECTIVE_MAP = {
				["Attack Titan"] = "Trost",
				["Armored Titan"] = "Shiganshina",
				["Female Titan"] = "Stohess",
				["Colossal Titan"] = "Shiganshina"
			}
			value82.Raid.MODIFIERS = {
				"No Perks",
				"No Skills",
				"No Memories",
				"Nightmare",
				"Oddball",
				"Injury Prone",
				"Chronic Injuries",
				"Fog",
				"Time Trial",
				"Glass Cannon",
				"Boring",
				"Simple"
			}

			local function v945(p115)
				value82.UI.setParagraph(value82.UI.paragraphs.raid, p115)
			end

			function value82.Raid.create()
				local asStr = value82.Mission.asStr
				local v947 = asStr(value82.Lobby.raidDifficulty)
				local v948 = asStr(value82.Lobby.raidObjective)
				local v949 = value82.Raid.OBJECTIVE_MAP[v948] or "Trost"
				local v950

				if v948 == "Colossal Titan" then
					v950 = v947 ~= "Aberrant"
				else
					v950 = false
				end

				local t28 = {
					argsExpr = string.format("{ Name = %q, Difficulty = %q, Type = \"Raids\", Objective = %q }", v949, v950 and "Aberrant" or v947, v948),
					mapExpr = "        if typeof(res) == \"Instance\" and res.Name then\n            out = { ok = true, name = res.Name, mtype = res:GetAttribute(\"Type\") }\n        else\n            out = { ok = false, retType = typeof(res), retVal = tostring(res) }\n        end\n    ",
					timeout = 8
				}
				local S_Missions = value82.Actor.invoke("S_Missions", "Create", t28)

				if not S_Missions then
					t2.value7("Raid.create: nil (timeout/no actor)")

					return nil
				end

				local data = S_Missions.data

				if not (not S_Missions.ok or (type(data) ~= "table" and true or not data.ok)) then
					local value7 = t2.value7
					local name = data.name
					local v956 = tostring(name)
					local mtype = data.mtype

					value7("Raid.create: OK name=" .. v956 .. " type=" .. tostring(mtype))

					return {
						ok = true,
						name = data.name,
						mtype = data.mtype
					}
				end

				local value7 = t2.value7
				local s4 = "Raid.create: rejected — type="
				local tostring_ = tostring
				local retType

				if data then
					retType = data.retType
				else
					retType = data
				end

				local v962 = tostring_(retType)
				local s5 = " val="
				local tostring_2 = tostring

				if not data then
					value7(s4 .. v962 .. s5 .. tostring_2(data))

					return {
						ok = false
					}
				end

				data = data.retVal
				value7(s4 .. v962 .. s5 .. tostring_2(data))

				return {
					ok = false
				}
			end
			function value82.Raid.createStartOnce()
				return v917("Raid", v945, value82.Raid.create, value82.Lobby.raidModifiers, value82.Mission.asStr(value82.Lobby.raidObjective))
			end

			value82.Tasks.autoRaid = value82.Task.new("AutoRaid", function(p116)
				local n14 = 0

				while p116.enabled do
					if isInGame() then
						v945("Stopped entered game.")

						break
					end

					while true do
						local enabled = p116.enabled and value82.Lobby.anyLobbyBusy()

						if enabled then
							enabled = not isInGame()
						end

						if not enabled then
							break
						end

						v945("Waiting: " .. value82.Lobby.busyNames() .. " still running...")
						task.wait(1)
					end

					if not p116.enabled or isInGame() then
						v945("Idle.")

						return
					end

					local t29 = { value82.Raid.createStartOnce() }
					local _ = t29[2]

					if t29[1] then
						v945("Idle.")

						return
					end

					n14 = n14 + 1

					if n14 >= 2 then
						if value82.Mission.asStr(value82.Lobby.raidObjective) == "Colossal Titan" then
							v945("Colossal failed retrying...")
						else
							local v969 = value82.Mission.lowerDifficulty(value82.Lobby.raidDifficulty)
							local v970

							if v969 then
								v970 = table.find(value82.Raid.DIFFICULTIES, v969)
							else
								v970 = v969
							end

							if v970 then
								value82.Lobby.raidDifficulty = v969
								value82.UI.selectDropdown(value82.UI.dropdowns.raidDifficulty, v969)
								notify("Auto Raid", "Repeated fails lowering difficulty to " .. v969, 4, "trending-down")
								v945("Lowered difficulty to " .. v969 .. " retrying...")
								n14 = 0
							else
								v945("Failing at Hard retrying...")
							end
						end
					end

					local wait_ = task.wait
					local v972 = n14 * 2 - 1

					wait_((math.clamp(v972, 1, 6)))
				end

				v945("Idle.")
			end)
			value82.Wave = {}
			value82.Wave.DIFFICULTIES = { "Easy" }
			value82.Wave.UPGRADES = {
				"Max",
				"Refills",
				"Regen",
				"Replenish",
				"Revive"
			}

			local function v973(p117)
				value82.UI.setParagraph(value82.UI.paragraphs.wave, p117)
			end

			function value82.Wave.vote()
				t2.value7("Wave.vote: sending Update")
				value82.Actor.send("Waves", "Update")
			end
			function value82.Wave.upgradeGear()
				local Remotes = t2.value1.RS:FindFirstChild("Assets") and t2.value1.RS.Assets:FindFirstChild("Remotes")

				if Remotes then
					Remotes = t2.value1.RS.Assets.Remotes:FindFirstChild("GET")
				end

				if not Remotes then
					t2.value7("Wave.upgradeGear: GET remote not found")

					return false
				end

				local attribute = t2.value1.Players.LocalPlayer:GetAttribute("Weapon") or value82.Lobby.autoUpgrade.weapon

				t2.value7("Wave.upgradeGear: activeWeapon=" .. tostring(attribute))

				local v976 = value82.Gear.CATEGORIES[attribute]

				if not v976 then
					t2.value7("Wave.upgradeGear: no category for weapon=" .. tostring(attribute))

					return false
				end

				local t30 = {}

				for _, v in ipairs(v976) do
					t30[#t30 + 1] = v
				end

				local upgrades = value82.Stats.upgrades

				if upgrades then
					upgrades = value82.Stats.upgrades[attribute]
				end

				local v981, t31, v983, v984, v985, value7, kind, v988, kind2, v990, kind3

				if not upgrades then
					v1055 = value82.Util.safeIndex(t2.value1.Players.LocalPlayer, "PlayerGui", "Interface", "HUD", "Main", "Top", "2", "Gold", "Title")
					v1056 = v1055 and string.gsub(v1055.Text or "", ",", "") or "0"
					v1057 = tonumber(v1056) or 0
					t2.value7("Wave.upgradeGear: gold=" .. tostring(v1057))

					if v1057 < 100 then
						t2.value7("Wave.upgradeGear: gold too low, skip")

						return false
					else
						v981 = #t30

						while v981 > 0 do
							t31 = {}

							for i = 1, v981 do
								t31[i] = t30[i]
							end

							t2.value7("Wave.upgradeGear: invoking n=" .. v981 .. " stats=" .. table.concat(t31, ","))
							v983, v984, v985 = value82.Remote.invoke(Remotes, "Equipment", "Upgrade", t31)
							value7 = t2.value7
							kind = type(v983)
							v988 = tostring(kind)
							kind2 = type(v984)
							v990 = tostring(kind2)
							kind3 = type(v985)
							value7("Wave.upgradeGear: raw a=" .. v988 .. " b=" .. v990 .. " c=" .. tostring(kind3))

							if v983 ~= nil then
								t2.value7("Wave.upgradeGear: OK with " .. v981 .. " stats")

								return true
							end

							t2.value7("Wave.upgradeGear: nil return — dropping priciest stat, retry n=" .. v981 - 1)
							v981 = v981 - 1

							if v981 > 0 then
								task.wait(1)
							end
						end

						t2.value7("Wave.upgradeGear: not enough Gold for even cheapest stat")

						return false
					end
				end

				table.sort(t30, function(p118, p119)
					return (upgrades[p118] or 0) < (upgrades[p119] or 0)
				end)

				local v993 = value82.Util.safeIndex(t2.value1.Players.LocalPlayer, "PlayerGui", "Interface", "HUD", "Main", "Top", "2", "Gold", "Title")
				local v994 = v993 and string.gsub(v993.Text or "", ",", "") or "0"
				local v995 = tonumber(v994) or 0

				t2.value7("Wave.upgradeGear: gold=" .. tostring(v995))

				if v995 < 100 then
					t2.value7("Wave.upgradeGear: gold too low, skip")

					return false
				else
					v981 = #t30

					while v981 > 0 do
						t31 = {}

						for i = 1, v981 do
							t31[i] = t30[i]
						end

						t2.value7("Wave.upgradeGear: invoking n=" .. v981 .. " stats=" .. table.concat(t31, ","))
						v983, v984, v985 = value82.Remote.invoke(Remotes, "Equipment", "Upgrade", t31)
						value7 = t2.value7
						kind = type(v983)
						v988 = tostring(kind)
						kind2 = type(v984)
						v990 = tostring(kind2)
						kind3 = type(v985)
						value7("Wave.upgradeGear: raw a=" .. v988 .. " b=" .. v990 .. " c=" .. tostring(kind3))

						if v983 ~= nil then
							t2.value7("Wave.upgradeGear: OK with " .. v981 .. " stats")

							return true
						end

						t2.value7("Wave.upgradeGear: nil return — dropping priciest stat, retry n=" .. v981 - 1)
						v981 = v981 - 1

						if v981 > 0 then
							task.wait(1)
						end
					end

					t2.value7("Wave.upgradeGear: not enough Gold for even cheapest stat")

					return false
				end
			end
			function value82.Wave.buyUpgrade(p120)
				t2.value7("Wave.buyUpgrade: buying " .. p120)

				local Waves = value82.Actor.invoke("Waves", "Upgrade", {
					argsExpr = string.format("{ %q }", p120),
					timeout = 5
				})
				local v998

				if Waves == nil then
					v998 = false
				else
					v998 = Waves.ok
				end

				if v998 then
					t2.value7("Wave.buyUpgrade: " .. p120 .. " -> OK")

					return v998
				end

				local value7 = t2.value7
				local s6 = "Wave.buyUpgrade: "
				local s7 = " -> not enough Gold or maxed (err="
				local tostring_ = tostring

				if not Waves then
					value7(s6 .. p120 .. s7 .. tostring_(Waves) .. ")")

					return v998
				end

				Waves = Waves.err
				value7(s6 .. p120 .. s7 .. tostring_(Waves) .. ")")

				return v998
			end
			function value82.Wave.onWaveVote(p121)
				if not value82.Runtime.farming then
					t2.value7("Wave.onWaveVote: skipped (not farming)")

					return
				end

				if not value82.Config.WaveAutoVote then
					t2.value7("Wave.onWaveVote: skipped (WaveAutoVote off)")

					return
				end

				t2.value7("Wave.onWaveVote: phase=" .. tostring(p121) .. " — voting")

				local v1004, WaveSelectedUpgrades, v1005

				if p121 ~= "Start" then
					value82.Wave.vote()

					if p121 ~= "Skip" then
						t2.value7("Wave.onWaveVote: phase=" .. tostring(p121) .. " — skipping upgrades/spears (not Skip phase)")

						return
					end

					v1076 = value82.Util.safeIndex(workspace, "Unclimbable", "Objective", "Waves")
					v1077 = 0

					while true do
						if true then
							if v1076 then
								if v1076:GetAttribute("Show") == true then
									v1004 = v1077 < 20
								else
									v1004 = false
								end
							else
								v1004 = v1076
							end
						end

						if not v1004 then
							t2.value7("Wave.onWaveVote: Show cleared after " .. v1077 .. "s — proceeding with purchases")

							if value82.Config.WaveAutoUpgradeGear then
								value82.Wave.upgradeGear()
							end

							if not value82.Config.WaveAutoBuyUpgrades then
								t2.value7("Wave.onWaveVote: done")

								return
							end

							WaveSelectedUpgrades = value82.Config.WaveSelectedUpgrades

							if type(WaveSelectedUpgrades) == "table" then
								v1005 = #WaveSelectedUpgrades > 0
							else
								v1005 = false
							end

							if v1005 then
								t2.value7("Wave.onWaveVote: buying upgrades: " .. table.concat(WaveSelectedUpgrades, ", "))

								for _, WaveSelectedUpgrade in ipairs(WaveSelectedUpgrades) do
									task.wait(0.15)
									value82.Wave.buyUpgrade(WaveSelectedUpgrade)
								end
							else
								t2.value7("Wave.onWaveVote: no upgrades selected")
							end

							t2.value7("Wave.onWaveVote: done")

							return
						end

						task.wait(0.5)
						v1077 = v1077 + 0.5
					end

					return
				end

				local v1008 = tick() - (value82.Runtime.sessionStartTick or 0)
				local n15

				if v1008 < 10 then
					local v1010 = 5 - v1008
					local v1011 = math.max(0, v1010)

					if v1011 > 0 then
						t2.value7("Wave.onWaveVote: new session, pre-wait " .. string.format("%.1f", v1011) .. "s for cutscene to spawn")
						task.wait(v1011)
						n15 = 0
					else
						n15 = 0
					end
				else
					n15 = 0
				end

				while true do
					local v1012 = value82.Features.cutsceneActive()

					if v1012 then
						v1012 = n15 < 20
					end

					if not v1012 then
						break
					end

					task.wait(0.5)
					n15 = n15 + 0.5
				end

				t2.value7("Wave.onWaveVote: cutscene done (waited " .. n15 .. "s) — voting Start")
				task.wait(5)
				value82.Wave.vote()

				if p121 ~= "Skip" then
					t2.value7("Wave.onWaveVote: phase=" .. tostring(p121) .. " — skipping upgrades/spears (not Skip phase)")

					return
				end

				local v1013 = value82.Util.safeIndex(workspace, "Unclimbable", "Objective", "Waves")
				local n16 = 0

				while true do
					if true then
						if v1013 then
							if v1013:GetAttribute("Show") == true then
								v1004 = n16 < 20
							else
								v1004 = false
							end
						else
							v1004 = v1013
						end
					end

					if not v1004 then
						t2.value7("Wave.onWaveVote: Show cleared after " .. n16 .. "s — proceeding with purchases")

						if value82.Config.WaveAutoUpgradeGear then
							value82.Wave.upgradeGear()
						end

						if not value82.Config.WaveAutoBuyUpgrades then
							t2.value7("Wave.onWaveVote: done")

							return
						end

						WaveSelectedUpgrades = value82.Config.WaveSelectedUpgrades

						if type(WaveSelectedUpgrades) == "table" then
							v1005 = #WaveSelectedUpgrades > 0
						else
							v1005 = false
						end

						if v1005 then
							t2.value7("Wave.onWaveVote: buying upgrades: " .. table.concat(WaveSelectedUpgrades, ", "))

							for _, WaveSelectedUpgrade in ipairs(WaveSelectedUpgrades) do
								task.wait(0.15)
								value82.Wave.buyUpgrade(WaveSelectedUpgrade)
							end
						else
							t2.value7("Wave.onWaveVote: no upgrades selected")
						end

						t2.value7("Wave.onWaveVote: done")

						return
					end

					task.wait(0.5)
					n16 = n16 + 0.5
				end
			end

			value82.Tasks.waveMonitor = value82.Task.new("WaveMonitor", function(p122)
				t2.value7("WaveMonitor: started — waiting for Waves game type")

				local v1017 = tick() + 60

				while true do
					local enabled = p122.enabled

					if enabled then
						enabled = tick() < v1017
					end

					if not enabled or workspace:GetAttribute("Type") == "Waves" then
						break
					end

					task.wait(1)
				end

				if not p122.enabled or workspace:GetAttribute("Type") ~= "Waves" then
					t2.value7("WaveMonitor: aborted (not Waves type or disabled)")

					return
				end

				local v1019 = value82.Util.safeIndex(workspace, "Unclimbable", "Objective", "Waves")
				local Objectives = t2.value1.RS:FindFirstChild("Objectives")

				if Objectives then
					Objectives = t2.value1.RS.Objectives:FindFirstChild("Clearance")
				end

				local value7 = t2.value7
				local s8 = "WaveMonitor: wavesObj="
				local v1023 = tostring(v1019 and (v1019:GetFullName() or "nil") or "nil")
				local s9 = " clearance="
				local tostring_ = tostring
				local fullName

				if Objectives then
					fullName = Objectives:GetFullName()
				else
					fullName = Objectives
				end

				value7(s8 .. v1023 .. s9 .. tostring_(fullName or "nil"))

				local u1027 = false
				local Value

				if Objectives then
					Value = Objectives.Value
				else
					Value = Objectives
				end

				local v1029 = Value or 0

				t2.value7("WaveMonitor: running — lastWaveCount=" .. tostring(v1029))
				v973("Monitoring waves...")

				local connection = nil
				local connection2 = nil
				local connection3 = nil
				local attribute

				if v1019 then
					attribute = v1019:GetAttribute("Phase")
				else
					attribute = v1019
				end

				local v1034 = attribute or nil

				local function v1035()
					local attribute2 = v1019 and v1019:GetAttribute("Show") or false
					local attribute3 = v1019 and v1019:GetAttribute("Phase") or "?"
					local v1038

					if attribute2 then
						v1038 = not u1027
					else
						v1038 = attribute2
					end

					if v1038 then
						u1027 = true
						t2.value7("WaveMonitor: Show=true phase=" .. tostring(attribute3) .. " — spawning onWaveVote")
						task.spawn(function()
							value82.Wave.onWaveVote(attribute3)
						end)

						return
					end

					local v1039 = not attribute2

					if v1039 then
						v1039 = u1027
					end

					if not v1039 then
						return
					end

					t2.value7("WaveMonitor: Show=false — vote prompt closed")
				end
				local function v1040()
					local attribute2 = v1019 and v1019:GetAttribute("Phase") or nil

					if attribute2 == v1034 then
						return
					end

					local v1042 = v1034

					t2.value7("WaveMonitor: Phase changed " .. tostring(v1042) .. " -> " .. tostring(attribute2))
					v1035()
				end
				local function v1043()
					local Value2 = Objectives and Objectives.Value or 0

					if Value2 == v1029 then
						return
					end

					local v1045 = v1029

					t2.value7("WaveMonitor: wave count " .. tostring(v1045) .. " -> " .. tostring(Value2))
					v973("Wave " .. tostring(Value2))

					local v1046

					if value82.Config.WaveThreshold > 0 then
						v1046 = value82.Config.WaveThreshold <= Value2
					else
						v1046 = false
					end

					if not v1046 then
						return
					end

					t2.value7("WaveMonitor: threshold " .. value82.Config.WaveThreshold .. " reached at wave " .. Value2 .. " — stopping attack, waiting for base to fall")
					v973("Threshold reached — waiting for base to fall.")
					notify("Wave Farm", "Wave threshold reached. Stopping.", 4, "log-out")
					p122.enabled = false
					value82.Tasks.attack:stop()
					value82.Tasks.movement:stop()
				end

				if v1019 then
					connection3 = v1019:GetAttributeChangedSignal("Show"):Connect(v1035)
					connection2 = v1019:GetAttributeChangedSignal("Phase"):Connect(v1040)
					v1035()
				else
					t2.value7("WaveMonitor: wavesObj nil — Show detection disabled, poll-only mode")
				end

				if Objectives then
					connection = Objectives:GetPropertyChangedSignal("Value"):Connect(v1043)
				else
					t2.value7("WaveMonitor: clearanceObj nil — wave count poll-only mode")
				end

				while true do
					local enabled = p122.enabled

					if enabled then
						enabled = isInGame()
					end

					if not enabled then
						break
					end

					if v1019 then
						v1035()
					end

					v1043()
					task.wait(1)
				end

				local value72 = t2.value7
				local enabled = p122.enabled
				local v1050 = isInGame

				value72("WaveMonitor: loop ended — enabled=" .. tostring(enabled) .. " inGame=" .. tostring(v1050()))

				if connection3 then
					connection3:Disconnect()
				end

				if connection2 then
					connection2:Disconnect()
				end

				if not connection then
					v973("Idle.")

					return
				end

				connection:Disconnect()
				v973("Idle.")
			end)

			function value82.Wave.create()
				t2.value7("Wave.create: difficulty=Easy")

				local S_Missions = value82.Actor.invoke("S_Missions", "Create", {
					argsExpr = "{ Name = \"Trost\", Difficulty = \"Easy\", Type = \"Waves\", Objective = \"Waves\" }",
					mapExpr = "        if typeof(res) == \"Instance\" and res.Name then\n            out = { ok = true, name = res.Name, mtype = res:GetAttribute(\"Type\") }\n        else\n            out = { ok = false, retType = typeof(res), retVal = tostring(res) }\n        end\n    ",
					timeout = 10
				})

				if not S_Missions then
					t2.value7("Wave.create: nil (timeout/no actor)")

					return nil
				end

				local data = S_Missions.data

				if not (not S_Missions.ok or (type(data) ~= "table" and true or not data.ok)) then
					local value7 = t2.value7
					local name = data.name

					value7("Wave.create: OK name=" .. tostring(name))

					return {
						ok = true,
						name = data.name,
						mtype = data.mtype
					}
				end

				local value7 = t2.value7
				local s10 = "Wave.create: rejected type="
				local retType

				if data then
					retType = data.retType
				else
					retType = data
				end

				local v1058 = tostring(retType)
				local s11 = " val="
				local tostring_ = tostring

				if not data then
					value7(s10 .. v1058 .. s11 .. tostring_(data))

					return {
						ok = false
					}
				end

				data = data.retVal
				value7(s10 .. v1058 .. s11 .. tostring_(data))

				return {
					ok = false
				}
			end
			function value82.Wave.createStartOnce()
				return v917("Wave", v973, value82.Wave.create, {}, "Waves")
			end

			value82.Tasks.autoWave = value82.Task.new("AutoWave", function(p123)
				t2.value7("autoWave: task started")

				local n17 = 0

				while p123.enabled do
					if isInGame() then
						t2.value7("autoWave: already in game — stopping loop")
						v973("Stopped — entered game.")

						break
					end

					if value82.Lobby.anyLobbyBusy() then
						t2.value7("autoWave: busy wait — " .. value82.Lobby.busyNames())
					end

					while true do
						local enabled = p123.enabled and value82.Lobby.anyLobbyBusy()

						if enabled then
							enabled = not isInGame()
						end

						if not enabled then
							break
						end

						v973("Waiting: " .. value82.Lobby.busyNames() .. " still running...")
						task.wait(2)
					end

					if not p123.enabled or isInGame() then
						t2.value7("autoWave: task ended")
						v973("Idle.")

						return
					end

					t2.value7("autoWave: attempting createStartOnce (attempt #" .. n17 + 1 .. ")")

					local t32 = { value82.Wave.createStartOnce() }
					local v1064 = t32[2]

					if t32[1] then
						t2.value7("autoWave: session created OK — waiting for teleport")

						local v1065 = tick() + 30

						while true do
							local enabled = p123.enabled

							if enabled then
								if tick() < v1065 then
									enabled = not isInGame()
								else
									enabled = false
								end
							end

							if not enabled then
								break
							end

							task.wait(1)
						end

						local v1067 = isInGame

						t2.value7("autoWave: post-session wait done inGame=" .. tostring(v1067()))

						break
					end

					n17 = n17 + 1
					t2.value7("autoWave: fail #" .. n17 .. " reason=" .. tostring(v1064))
					v973("Failed (" .. n17 .. "x) retrying...")

					local wait_ = task.wait
					local v1069 = n17 * 2 - 1

					wait_((math.clamp(v1069, 1, 6)))
				end

				t2.value7("autoWave: task ended")
				v973("Idle.")
			end)
			value82.Thunder = {}
			color39 = value82.Thunder
			t1.value5 = { "RETRIEVE MISSING SUPPLIES", "DEFEND MISSING SUPPLIES" }
			color38 = {
				name = "Retrieve + Defend",
				map = "Forest",
				objective = "Skirmish",
				difficulty = "Aberrant",
				tags = t1.value5,
				components = { "Base" }
			}
			t1.value6 = { "ICE BURST STONES" }
			color39.QUESTS = {
				{
					name = "Towers + Escort",
					map = "Outskirts",
					objective = "Skirmish",
					difficulty = "Aberrant",
					tags = { "TOWERS", "ESCORT" },
					components = { "Handle" }
				},
				color38,
				{
					name = "Ice Burst Stones",
					map = "Utgard",
					objective = "Skirmish",
					difficulty = "Aberrant",
					tags = t1.value6,
					components = { "Thruster" }
				}
			}

			local function v1070(p124)
				value82.Lobby.lastThunderStatus = p124
				value82.UI.setParagraph(value82.UI.paragraphs.thunder, p124)
			end
			local function v1071()
				value82.Lobby.thunderMode = false

				local function v1072()
					if value82.Thunder.endFarming then
						value82.Thunder.endFarming()
					end

					pcall(function()
						local Flags = value82.UI.Window and value82.UI.Window.Flags

						if Flags then
							Flags = value82.UI.Window.Flags.AutoThunder
						end

						if not Flags then
							return
						end

						Flags:Set(false)
					end)
				end

				if not isInGame() then
					v1072()

					return
				end

				t2.value7("stopThunderMode: in-game -> will finalize on lobby return")
				task.spawn(function()
					while isInGame() do
						task.wait(2)
					end

					v1072()
				end)
			end

			function value82.Thunder.readProgress()
				local t33 = {}
				local questCache = {}

				for _, quest in ipairs(value82.Thunder.QUESTS) do
					for _, tag in ipairs(quest.tags) do
						t33[tag] = true
					end
				end

				local v1080 = value82.Util.safeIndex(t2.value4, "Interface")

				if not v1080 then
					return questCache
				end

				local v1081, v1082, v1083 = ipairs(v1080:GetDescendants())

				while true do
					local v1084

					v1083, v1084 = v1081(v1082, v1083)

					if not v1083 then
						break
					end

					local isTextLabel

					if v1084.Name == "Tag" then
						isTextLabel = v1084:IsA("TextLabel")
					else
						isTextLabel = false
					end

					if isTextLabel then
						local Text = v1084.Text
						local v1087 = tostring(Text):upper()

						if t33[v1087] then
							local Parent = v1084.Parent
							local v1089 = value82.Util.safeIndex(Parent, "Bar", "Amount")
							local v1090 = nil
							local match = nil
							local isTextLabel2

							if v1089 then
								isTextLabel2 = v1089:IsA("TextLabel")
							else
								isTextLabel2 = v1089
							end

							if isTextLabel2 then
								match, v1090 = v1089.Text:match("([%d%.]+)%s*/%s*([%d%.]+)")
							end

							local v1093 = value82.Util.safeIndex(Parent, "Claimed")

							if v1093 then
								local v1094 = value82.Util.safeIndex(v1093, "Title")
							end

							local v1095 = (v1157 and (v1157:IsA("TextLabel") and v1157.Text) or ""):upper()
							local u1096 = false

							local function v1097()
								local isGuiObject = v1093

								if isGuiObject then
									isGuiObject = v1093:IsA("GuiObject")
								end

								if not isGuiObject then
									return
								end

								u1096 = v1093.Visible
							end

							pcall(v1097)

							local v1099 = u1096

							if v1099 then
								v1099 = v1095:find("LOCK") ~= nil
							end

							local v1100 = u1096

							if v1100 then
								v1100 = not v1099
							end

							questCache[v1087] = {
								current = tonumber(match) or 0,
								target = tonumber(v1090) or 0,
								claimed = v1100,
								locked = v1099
							}
						end
					end
				end

				if not next(questCache) then
					return questCache
				end

				value82.Lobby.questCache = questCache

				return questCache
			end
			function value82.Thunder.missionDone(p125, p126)
				for _, tag in ipairs(p125.tags) do
					local v1103 = p126[tag]
					local claimed

					if v1103 then
						claimed = v1103.claimed

						if not claimed then
							if v1103.target > 0 then
								claimed = v1103.current >= v1103.target
							else
								claimed = false
							end
						end
					else
						claimed = v1103
					end

					if not claimed then
						return false
					end
				end

				return true
			end
			function value82.Thunder.missionProgressStr(p127, p128)
				local t34 = {}

				for _, tag in ipairs(p127.tags) do
					local v1108 = p128[tag]

					t34[#t34 + 1] = tag .. " " .. (v1108 and v1108.claimed and "✓" or (v1108.current .. "/" .. v1108.target or "?"))
				end

				return table.concat(t34, ", ")
			end
			function value82.Thunder.nextQuest(p129)
				local thunderRan = value82.Lobby.thunderRan or {}

				for _, quest in ipairs(value82.Thunder.QUESTS) do
					local v1112 = not value82.Thunder.missionDone(quest, p129)

					if v1112 then
						v1112 = not thunderRan[quest.name]
					end

					if v1112 then
						return quest, p129
					end
				end

				return nil
			end

			local function v1113(p130)
				if not p130 then
					return false
				end

				if not p130:IsDescendantOf(t2.value4) then
					return false
				end

				t2.value1.RunService.Heartbeat:Wait()

				if not p130:IsDescendantOf(t2.value4) then
					return false
				end

				return pcall(function()
					t2.value1.GuiService.SelectedObject = p130
					task.wait(0.1)
					t2.value1.VIM:SendKeyEvent(true, Enum.KeyCode.Return, false, game)
					task.wait(0.05)
					t2.value1.VIM:SendKeyEvent(false, Enum.KeyCode.Return, false, game)
				end)
			end

			function value82.Thunder.openPanelAndRead(p131)
				local v1114 = p131 or 4
				local v1115 = tick() + math.min(v1114, 5)
				local _ = v1115 < tick()

				while true do
					local v1117 = value82.Util.safeIndex(t2.value4, "Interface", "Topbar")
					local isGuiObject = v1117 and v1117:IsA("GuiObject")

					if isGuiObject then
						isGuiObject = v1117.Visible
					end

					local v1119 = isGuiObject and value82.Util.safeIndex(v1117, "Main", "Categories", "Quests", "Interact")

					if v1119 then
						break
					end

					task.wait(0.5)

					if v1115 < tick() then
						v1119 = nil

						break
					end
				end

				if not v1185 then
					t2.value7("Thunder.openPanelAndRead: Quests category Interact not ready, waiting 3s")
					task.wait(3)

					return {}
				end

				if v1113(v1185) then
					t2.value7("Thunder.openPanelAndRead: opened Quests category")
				else
					t2.value7("Thunder.openPanelAndRead: Quests category Interact not found")
				end

				task.wait(0.3)

				local function v1120()
					local v1121 = value82.Util.safeIndex(t2.value4, "Interface", "Quests", "Main", "Quests")

					if not v1121 then
						return false
					end

					local Q21 = v1121:FindFirstChild("Q_2.1")
					local v1123, v1124, v1125, t35, v1127, GetChildren, v1129, isTextLabel, Text, v1132

					if Q21 then
					elseif v1113(Q21) then
						t2.value7("Thunder.openPanelAndRead: opened Spear row Q_2.1")

						return true
					else
						v1123, v1124, v1125 = ipairs(value82.Thunder.QUESTS)
						t35 = {}

						while true do
							v1125, v1127 = v1123(v1124, v1125)

							if not v1125 then
								break
							end

							for _, tag in ipairs(v1127.tags) do
								t35[tag] = true
							end
						end

						GetChildren = v1121.GetChildren

						for _, v in ipairs(GetChildren(v1121)) do
							v1129 = value82.Util.safeIndex(v, "Inner", "Tag")
							isTextLabel = v1129 and v1129:IsA("TextLabel")

							if isTextLabel then
								Text = v1129.Text
								isTextLabel = tostring(Text):upper()
							end

							if isTextLabel then
								v1132 = t35[isTextLabel]
							else
								v1132 = isTextLabel
							end

							if v1132 and v1113(value82.Util.safeIndex(v, "Inner", "Interact")) then
								t2.value7("Thunder.openPanelAndRead: opened Spear row", v.Name, "(" .. isTextLabel .. ")")

								return true
							end
						end

						return false
					end

					Q21 = value82.Util.safeIndex(Q21, "Inner", "Interact")

					if v1113(Q21) then
						t2.value7("Thunder.openPanelAndRead: opened Spear row Q_2.1")

						return true
					else
						v1123, v1124, v1125 = ipairs(value82.Thunder.QUESTS)
						t35 = {}

						while true do
							v1125, v1127 = v1123(v1124, v1125)

							if not v1125 then
								break
							end

							for _, tag in ipairs(v1127.tags) do
								t35[tag] = true
							end
						end

						GetChildren = v1121.GetChildren

						for _, v in ipairs(GetChildren(v1121)) do
							v1129 = value82.Util.safeIndex(v, "Inner", "Tag")
							isTextLabel = v1129 and v1129:IsA("TextLabel")

							if isTextLabel then
								Text = v1129.Text
								isTextLabel = tostring(Text):upper()
							end

							if isTextLabel then
								v1132 = t35[isTextLabel]
							else
								v1132 = isTextLabel
							end

							if v1132 and v1113(value82.Util.safeIndex(v, "Inner", "Interact")) then
								t2.value7("Thunder.openPanelAndRead: opened Spear row", v.Name, "(" .. isTextLabel .. ")")

								return true
							end
						end

						return false
					end
				end

				pcall(v1120)

				local v1141 = tick() + v1114
				local _ = v1141 < tick()

				while true do
					task.wait(0.8)

					local v1143 = value82.Thunder.readProgress()

					if next(v1143) then
						break
					end

					pcall(v1120)

					if v1141 < tick() then
						break
					end
				end

				t2.value7("Thunder.openPanelAndRead: read", value82.Util.count(v1204), "Spear tag(s)")

				local function v1144()
					t2.value1.GuiService.SelectedObject = nil
				end

				pcall(v1144)

				return v1204
			end
			function value82.Thunder.runQuestSession(p132)
				local missionMap = value82.Lobby.missionMap
				local missionObjective = value82.Lobby.missionObjective
				local missionDifficulty = value82.Lobby.missionDifficulty
				local missionModifiers = value82.Lobby.missionModifiers

				value82.Lobby.questOverride = true
				value82.Lobby.missionMap = p132.map
				value82.Lobby.missionObjective = p132.objective

				if not p132.difficulty then
					value82.Lobby.missionModifiers = {}
					v1211 = t2.value7
					v1212 = p132.name
					v1213 = value82.Lobby.missionMap
					v1214 = "map=" .. tostring(v1213)
					v1215 = value82.Lobby.missionObjective
					v1216 = "obj=" .. tostring(v1215)
					v1217 = value82.Lobby.missionDifficulty
					v1218 = "diff=" .. tostring(v1217)
					v1219 = p132.difficulty or "any"
					v1211("Thunder.runQuestSession:", v1212, v1214, v1216, v1218, "(required=" .. tostring(v1219) .. ", modifiers cleared)")
					v1220, v1221 = pcall(value82.Mission.createStartOnce)
					v1222 = value82.Lobby
					v1223 = value82.Lobby
					v1224 = value82.Lobby
					v1222.missionMap = missionMap
					v1223.missionObjective = missionObjective
					v1224.missionDifficulty = missionDifficulty
					value82.Lobby.missionModifiers = missionModifiers
					value82.Lobby.questOverride = false

					if v1220 then
						return v1221
					else
						t2.value7("Thunder.runQuestSession: createStartOnce threw:", v1221)

						return false
					end
				end

				value82.Lobby.missionDifficulty = p132.difficulty
				value82.Lobby.missionModifiers = {}

				local value7 = t2.value7
				local name = p132.name
				local missionMap2 = value82.Lobby.missionMap
				local v1152 = "map=" .. tostring(missionMap2)
				local missionObjective2 = value82.Lobby.missionObjective
				local v1154 = "obj=" .. tostring(missionObjective2)
				local missionDifficulty2 = value82.Lobby.missionDifficulty
				local v1156 = "diff=" .. tostring(missionDifficulty2)
				local difficulty = p132.difficulty or "any"

				value7("Thunder.runQuestSession:", name, v1152, v1154, v1156, "(required=" .. tostring(difficulty) .. ", modifiers cleared)")

				local ok, result = pcall(value82.Mission.createStartOnce)
				local Lobby = value82.Lobby
				local Lobby2 = value82.Lobby
				local Lobby3 = value82.Lobby

				Lobby.missionMap = missionMap
				Lobby2.missionObjective = missionObjective
				Lobby3.missionDifficulty = missionDifficulty
				value82.Lobby.missionModifiers = missionModifiers
				value82.Lobby.questOverride = false

				if ok then
					return result
				else
					t2.value7("Thunder.runQuestSession: createStartOnce threw:", result)

					return false
				end
			end

			local function v1163(p133)
				local v1164 = nil

				local function v1165()
					local Hitbox = v1164:FindFirstChild("Hitbox", true)
					local isBasePart

					if Hitbox then
						isBasePart = Hitbox:IsA("BasePart")
					else
						isBasePart = Hitbox
					end

					if isBasePart then
						return Hitbox
					end

					local v1168, v1169, v1170 = ipairs(v1164:GetDescendants())

					while true do
						local v1171

						v1170, v1171 = v1168(v1169, v1170)

						if not v1170 then
							break
						end

						local isBasePart2 = v1171:IsA("BasePart")

						if isBasePart2 then
							isBasePart2 = v1171:FindFirstChildWhichIsA("TouchTransmitter")
						end

						if isBasePart2 then
							return v1171
						end
					end

					if v1164:IsA("BasePart") then
						return v1164
					end

					local isModel = v1164:IsA("Model")
					local v1174

					if isModel then
					elseif isModel then
						return v1164.PrimaryPart
					else
						v1174 = v1164

						return v1174.FindFirstChildWhichIsA(v1174, "BasePart", true)
					end

					isModel = v1164.PrimaryPart

					if isModel then
						return v1164.PrimaryPart
					else
						v1174 = v1164

						return v1174.FindFirstChildWhichIsA(v1174, "BasePart", true)
					end
				end

				v1164 = p133

				local ok, result = pcall(v1165)

				return ok and result and result or nil
			end

			value82.Thunder.SUPPLY_PATTERN = "^thunderspear_supplies"
			value82.Thunder.CRATE_PATTERN = "^supplies_c"
			value82.Thunder.TOWER_PATTERN = "^watchtower_(%d+)"
			value82.Thunder.ESCORT_PATTERN = "^escort$"

			function value82.Thunder.crateTarget()
				local Unclimbable = workspace:FindFirstChild("Unclimbable")
				local Objective

				if Unclimbable then
					Objective = Unclimbable:FindFirstChild("Objective") or nil
				else
					Objective = nil
				end

				local t36 = { Objective, Unclimbable, workspace }

				for _, v in ipairs(t36) do
					if v then
						for _, child in ipairs(v.GetChildren(v)) do
							if child.Name:lower():match(value82.Thunder.CRATE_PATTERN) then
								local v1184 = v1163(child)
								local isBasePart

								if v1184 then
									isBasePart = v1184:IsA("BasePart")
								else
									isBasePart = v1184
								end

								if isBasePart then
									return child, v1184
								end
							end
						end
					end
				end

				return nil, nil
			end
			function value82.Thunder.defendSuppliesNode()
				for _, v in ipairs({ t2.value1.RS:FindFirstChild("Objectives"), value82.Util.safeIndex(workspace, "Unclimbable", "Objective") }) do
					if v then
						local Defend_Supplies = v:FindFirstChild("Defend_Supplies")
						local Parent

						if Defend_Supplies then
							Parent = Defend_Supplies.Parent
						else
							Parent = Defend_Supplies
						end

						if Parent then
							return Defend_Supplies
						end
					end
				end

				return nil
			end
			function value82.Thunder.defendSuppliesDone()
				local v1190 = value82.Thunder.defendSuppliesNode()

				if v1190 then
					local attribute = v1190:GetAttribute("Requirement")
					local Value = v1190.Value
					local v1193 = tonumber(Value)
					local v1194

					if attribute == nil or (v1193 == nil or attribute <= 0) then
						v1194 = false
					else
						v1194 = attribute <= v1193
					end

					return v1194
				else
					return false
				end
			end

			value82.Thunder.SUPPLY_GUARD_RADIUS = 150
			value82.Thunder._sawDefend = false

			function value82.Thunder.defendingSuppliesActive()
				local v1195 = value82.Thunder.defendSuppliesNode()

				if v1195 then
					local attribute = v1195:GetAttribute("Requirement")
					local Value = v1195.Value
					local v1198 = tonumber(Value)

					if attribute then
						if v1198 then
						elseif v1198 then
							return false
						else
							value82.Thunder._sawDefend = true

							return true
						end

						if attribute > 0 then
							v1198 = attribute <= v1198
						else
							v1198 = false
						end
					else
						v1198 = attribute
					end

					if v1198 then
						return false
					else
						value82.Thunder._sawDefend = true

						return true
					end
				else
					return false
				end
			end
			function value82.Thunder.supplyPos()
				local _, Position = value82.Thunder.crateTarget()

				if not Position then
					return Position or nil
				end

				Position = Position.Position

				return Position or nil
			end
			function value82.Thunder.slayNode()
				for _, v in ipairs({ t2.value1.RS:FindFirstChild("Objectives"), value82.Util.safeIndex(workspace, "Unclimbable", "Objective") }) do
					if v then
						local Slay = v:FindFirstChild("Slay") or v:FindFirstChild("Kill")
						local Parent

						if Slay then
							Parent = Slay.Parent
						else
							Parent = Slay
						end

						if Parent then
							return Slay
						end
					end
				end

				return nil
			end
			function value82.Thunder.shouldLeaveDefendPhase()
				if value82.Thunder.defendSuppliesDone() then
					return "defend done (1/1)"
				end

				local _sawDefend = value82.Thunder._sawDefend
				local _sawDefend2, attribute, Value, v1209, v1210

				if _sawDefend then
				elseif _sawDefend then
					return "defend objective vanished (failed/removed)"
				else
					_sawDefend2 = value82.Thunder._sawDefend and value82.Thunder.slayNode()

					if _sawDefend2 then
						attribute = _sawDefend2:GetAttribute("Requirement")
						Value = _sawDefend2.Value
						v1209 = tonumber(Value)

						if attribute then
							if v1209 then
								if attribute > 0 then
									v1210 = attribute - 10 <= v1209
								else
									v1210 = false
								end
							else
								v1210 = v1209
							end
						else
							v1210 = attribute
						end

						if v1210 then
							return "Slay near requirement (" .. v1209 .. "/" .. attribute .. ")"
						else
							return nil
						end
					else
						return nil
					end
				end

				_sawDefend = not value82.Thunder.defendSuppliesNode()

				if _sawDefend then
					return "defend objective vanished (failed/removed)"
				else
					_sawDefend2 = value82.Thunder._sawDefend and value82.Thunder.slayNode()

					if _sawDefend2 then
						attribute = _sawDefend2:GetAttribute("Requirement")
						Value = _sawDefend2.Value
						v1209 = tonumber(Value)

						if attribute then
							if v1209 then
								if attribute > 0 then
									v1210 = attribute - 10 <= v1209
								else
									v1210 = false
								end
							else
								v1210 = v1209
							end
						else
							v1210 = attribute
						end

						if v1210 then
							return "Slay near requirement (" .. v1209 .. "/" .. attribute .. ")"
						else
							return nil
						end
					else
						return nil
					end
				end
			end
			function value82.Thunder.activeTower()
				local CS = t2.value1.CS
				local n18 = 0
				local v1225 = nil
				local ok, result = pcall(function()
					return CS:GetTagged("TS_Towers")
				end)

				if not (ok and result) then
					return v1225, n18
				end

				for _, v in ipairs(result) do
					local Parent = v.Parent

					if Parent then
						Parent = v.Name:lower():match(value82.Thunder.TOWER_PATTERN)
					end

					if Parent then
						n18 = n18 + 1

						local v1226 = v1163(v)
						local isBasePart

						if v1226 then
							isBasePart = v1226:IsA("BasePart")
						else
							isBasePart = v1226
						end

						if isBasePart then
							local Name = v.Name
							local v1227 = tonumber(Name:match("_(%d+)$")) or 0

							if not v1225 or v1227 < v1225.n then
								v1225 = {
									inst = v,
									part = v1226,
									n = v1227
								}
							end
						end
					end
				end

				return v1225, n18
			end
			function value82.Thunder.escortTarget()
				local Unclimbable = workspace:FindFirstChild("Unclimbable")
				local Objective

				if Unclimbable then
					Objective = Unclimbable:FindFirstChild("Objective") or nil
				else
					Objective = nil
				end

				local t37 = { Objective, Unclimbable, workspace }

				for _, v in ipairs(t37) do
					if v then
						for _, child in ipairs(v.GetChildren(v)) do
							local Collider = not child.Name:lower():match(value82.Thunder.ESCORT_PATTERN) and child:FindFirstChild("Collider")

							if Collider then
								Collider = child:FindFirstChild("Cart")
							end

							if Collider then
								local Collider2 = child:FindFirstChild("Collider", true)
								local isBasePart

								if Collider2 then
									isBasePart = Collider2:IsA("BasePart")
								else
									isBasePart = Collider2
								end

								if isBasePart then
									return child, Collider2
								end

								local v1233 = v1163(child)
								local isBasePart2

								if v1233 then
									isBasePart2 = v1233:IsA("BasePart")
								else
									isBasePart2 = v1233
								end

								if isBasePart2 then
									return child, v1233
								end
							end
						end
					end
				end

				return nil, nil
			end

			color39 = value82.Tasks
			color38 = value82.Task.new

			function t1.value3(p134)
				local t38 = {}

				local function v1236(p135)
					local Unclimbable = workspace:FindFirstChild("Unclimbable")
					local Objective

					if Unclimbable then
						Objective = Unclimbable:FindFirstChild("Objective") or nil
					else
						Objective = nil
					end

					local t39 = { Objective, Unclimbable, workspace }
					local v1240 = nil
					local v1241 = nil
					local v1242 = nil

					for _, v in ipairs(t39) do
						if v then
							local GetChildren = v.GetChildren

							for _, v2 in ipairs(GetChildren(v)) do
								local v1248 = v2.Name:lower():match(value82.Thunder.SUPPLY_PATTERN) and not t38[v2]

								if v1248 then
									v1248 = v2.Parent
								end

								if v1248 then
									local v1249 = v1163(v2)
									local isBasePart

									if v1249 then
										isBasePart = v1249:IsA("BasePart")
									else
										isBasePart = v1249
									end

									if isBasePart then
										local Magnitude = (p135.Position - v1249.Position).Magnitude

										if not v1240 or Magnitude < v1240 then
											v1242 = v1249
											v1241 = v2
											v1240 = Magnitude
										end
									end
								end
							end
						end
					end

					return v1241, v1242
				end

				local v1252 = nil
				local v1253 = nil
				local s12 = "PICKUP"
				local v1255 = nil
				local now = nil
				local now2 = nil
				local v1258 = nil
				local now3 = nil

				while true do
					local enabled = p134.enabled

					if enabled then
						enabled = isInGame()
					end

					if not enabled then
						value82.Move.cancel()

						return
					end

					task.wait(0.1)

					local _, v1262 = value82.Char.get()

					if v1262 then
						local v1263 = value82.Thunder.activeTower()
						local v1264 = value82
						local v1265 = v1263 ~= nil
						local v1266, v1267 = v1264.Thunder.escortTarget()
						local v1268

						if v1266 == nil then
							v1268 = false
						else
							v1268 = v1267 ~= nil
						end

						local v1269 = v1236(v1262) ~= nil and true or v1258 ~= nil

						if v1265 then
							value82.Runtime.objectiveMode = true

							if v1255 ~= v1263.n then
								v1255 = v1263.n
								tick()
								value82.Move.cancel()
								t2.value7("ThunderObjective: TOWERS -> holding WatchTower_" .. tostring(v1255))
								v1070("Towers: building WatchTower_" .. tostring(v1255))
							end

							local part = v1263.part
							local Parent

							if part then
								Parent = part.Parent
							else
								Parent = part
							end

							if Parent then
								local Position = part.Position
								local ok, result = pcall(function()
									return part.Size.Z * 0.5
								end)
								local v1275 = ok and result and result or 100
								local v1276 = v1275 * 0.92
								local v1277 = math.max(8, v1276)
								local v1278 = value82
								local v1279 = Position + Vector3.new(0, v1277, 0)
								local v1280 = v1278.Combat.chaseHold(v1279, v1275, v1277)

								if (v1262.Position - v1280).Magnitude > 12 then
									value82.Move.to(v1262, v1280)
								else
									value82.Move.hold(v1262)
								end
							end
						elseif v1268 then
							value82.Runtime.objectiveMode = true

							local HoverHeight = value82.Config.HoverHeight
							local v1282 = tonumber(HoverHeight) or 200

							value82.Move.to(v1262, v1267.Position + Vector3.new(0, v1282, 0))
							v1070("Escort: following cart")
						elseif v1269 then
							value82.Runtime.objectiveMode = true

							local v1283, v1284

							if v1252 and v1252.Parent then
								v1283 = v1252
								v1284 = v1253
							elseif s12 == "PICKUP" then
								v1284, v1283 = v1236(v1262)

								if v1284 then
									t2.value7("ThunderObjective: PICKUP", v1284:GetFullName())
									v1070("Carrying: picking up " .. v1284.Name)
									value82.Move.to(v1262, v1283.Position)
									v1258 = v1284
									now = nil
								else
									v1283 = v1252
									v1284 = v1253
								end
							else
								v1284, v1283 = value82.Thunder.crateTarget()

								if v1284 and v1283 then
									t2.value7("ThunderObjective: DROPOFF to", v1284:GetFullName())
									v1070("Carrying: returning to crate")
									value82.Move.to(v1262, v1283.Position)
									now = nil
								else
									value82.Move.cancel()
									v1070("Carrying: waiting for Supplies_Crate...")
									v1283 = v1252
									v1284 = v1253
								end
							end

							if s12 == "PICKUP" then
								local Parent

								if v1284 then
									if v1283 then
										Parent = v1283.Parent
									else
										Parent = v1283
									end
								else
									Parent = v1284
								end

								if Parent then
									local v1286

									if now2 then
										v1286 = tick() - now2 > 8
									else
										v1286 = now2
									end

									if v1286 then
										t2.value7("ThunderObjective: supply stuck, abandoning", v1284.Name)
										t38[v1284] = true
										v1252 = nil
										v1253 = nil
										s12 = "PICKUP"
										now = nil
										now2 = nil
										v1258 = nil
									else
										local Position = v1283.Position
										local Magnitude = (v1262.Position - Position).Magnitude
										local ok, result = pcall(function()
											local Size = v1283.Size
											local X = Size.X
											local Y = Size.Y
											local Z = Size.Z

											return math.max(X, Y, Z) * 0.5 + 4
										end)
										local v1295

										if (ok and result and result or 8) < Magnitude then
											value82.Move.to(v1262, Position)
											v1295 = false
										else
											v1295 = true
										end

										if v1295 then
											if not now2 then
												v1262.CFrame = CFrame.new(v1283.Position)
												now2 = tick()
											end

											value82.Move.hold(v1262)

											if tick() - now2 >= 1.5 then
												t2.value7("ThunderObjective: picked up", v1258 and (v1258.Name or "?") or "?")
												v1252 = nil
												v1253 = nil
												s12 = "DROPOFF"
												now = nil
												now2 = nil
											else
												v1253 = v1284
												v1252 = v1283
											end
										else
											v1253 = v1284
											v1252 = v1283
										end
									end
								else
									v1253 = v1284
									v1252 = v1283
								end
							else
								local v1296

								if v1258 then
									v1296 = not v1258.Parent
								else
									v1296 = v1258
								end

								if v1296 then
									t38[v1258] = true
									t2.value7("ThunderObjective: delivered (supply gone)")
									v1252 = nil
									v1253 = nil
									s12 = "PICKUP"
									now = nil
									now2 = nil
									v1258 = nil
								else
									local Parent

									if v1284 then
										if v1283 then
											Parent = v1283.Parent
										else
											Parent = v1283
										end
									else
										Parent = v1284
									end

									if Parent then
										local v1298

										if now then
											v1298 = tick() - now > 6
										else
											v1298 = now
										end

										if v1298 then
											t2.value7("ThunderObjective: dropoff re-approach", v1258 and (v1258.Name or "?") or "?")
											v1262.CFrame = CFrame.new(v1283.Position)
											now = tick()
											v1253 = v1284
											v1252 = v1283
										else
											local Position = v1283.Position
											local Magnitude = (v1262.Position - Position).Magnitude
											local ok, result = pcall(function()
												local Size = v1283.Size
												local X = Size.X
												local Y = Size.Y
												local Z = Size.Z

												return math.max(X, Y, Z) * 0.5 + 4
											end)
											local v1307

											if (ok and result and result or 8) < Magnitude then
												value82.Move.to(v1262, Position)
												v1307 = false
											else
												v1307 = true
											end

											if v1307 then
												if not now then
													v1262.CFrame = CFrame.new(v1283.Position)
													now = tick()
												end

												value82.Move.hold(v1262)
												v1253 = v1284
												v1252 = v1283
											else
												v1253 = v1284
												v1252 = v1283
											end
										end
									else
										v1253 = v1284
										v1252 = v1283
									end
								end
							end
						else
							local v1308, v1309 = value82.Thunder.crateTarget()
							local v1310

							if v1308 then
								if v1309 then
									v1310 = not now3 or tick() - now3 < 90
								else
									v1310 = v1309
								end
							else
								v1310 = v1308
							end

							if v1310 then
								value82.Runtime.objectiveMode = true
								now3 = now3 or tick()

								local HoverHeight = value82.Config.HoverHeight
								local v1312 = tonumber(HoverHeight) or 200
								local v1313 = v1309.Position + Vector3.new(0, v1312, 0)
								local v1314 = value82.Combat.chaseHold(v1313, 700, v1312)

								if (v1262.Position - v1314).Magnitude > 12 then
									value82.Move.to(v1262, v1314)
								else
									value82.Move.hold(v1262)
								end

								v1070("Defending supplies at " .. v1308.Name)
							else
								if value82.Runtime.objectiveMode then
									if not value82.Thunder._lastDoneWarn or tick() - value82.Thunder._lastDoneWarn > 5 then
										value82.Thunder._lastDoneWarn = tick()

										local t40 = {}
										local Unclimbable = workspace:FindFirstChild("Unclimbable")

										if Unclimbable then
											Unclimbable = Unclimbable:FindFirstChild("Objective")
										end

										if Unclimbable then
											for _, child in ipairs(Unclimbable.GetChildren(Unclimbable)) do
												t40[#t40 + 1] = child.Name
											end
										end

										t2.value7("ThunderObjective: DONE — Unclimbable.Objective children:", #t40 > 0 and table.concat(t40, ", ") or "(none)")
									end

									t2.value7("ThunderObjective: no objective objects -> DONE, switching to Slay/farm")
									v1070("Objective done slaying titans...")
									value82.Move.cancel()
									v1262.Anchored = false
									value82.Runtime.objectiveMode = false
								end

								task.wait(0.5)
							end
						end
					end
				end
			end

			t1.value1 = color38("ThunderObjective", t1.value3)
			color39.thunderObjective = t1.value1

			function value82.Thunder.beginFarming()
				local value7 = t2.value7
				local v1320 = isInGame
				local v1321 = tostring(v1320())
				local farming = value82.Runtime.farming
				local v1323 = tostring(farming)
				local v1324 = value82.Thunder._savedLobby ~= nil
				local v1325 = tostring(v1324)
				local HoverHeight = value82.Config.HoverHeight

				value7("Thunder.beginFarming: inGame=" .. v1321 .. " farming=" .. v1323 .. " alreadyArmed=" .. v1325 .. " hoverHeight=" .. tostring(HoverHeight))

				if value82.Tasks.thunderObjective:isRunning() then
					value82.Runtime.objectiveMode = true

					return
				end

				if not value82.Thunder._savedLobby then
					value82.Thunder._savedLobby = {
						on = value82.Config.AutoLobby,
						after = value82.Config.AutoLobbyAfter
					}
					value82.Runtime.objectiveMode = true

					if value82.Runtime.farming then
						value82.Thunder._startedFarm = false
					else
						value82.Farm.start()
						value82.Thunder._startedFarm = true
					end

					value82.Tasks.thunderObjective:start()
					t2.value7("Thunder.beginFarming: navigator running =", value82.Tasks.thunderObjective:isRunning(), "startedFarm =", value82.Thunder._startedFarm)

					return
				end

				value82.Runtime.objectiveMode = true

				if value82.Runtime.farming then
					value82.Tasks.thunderObjective:start()

					return
				end

				value82.Farm.start()
				value82.Thunder._startedFarm = true
				value82.Tasks.thunderObjective:start()
			end
			function value82.Thunder.endFarming()
				local u1327 = false

				local function v1328()
					local Flags = value82.UI.Window and value82.UI.Window.Flags

					if Flags then
						Flags = value82.UI.Window.Flags.AutoFarm
					end

					local v1330

					if Flags then
						v1330 = Flags.Value ~= nil
					else
						v1330 = Flags
					end

					if not v1330 then
						return
					end

					u1327 = Flags.Value == true
				end

				pcall(v1328)

				local _startedFarm = value82.Thunder._startedFarm

				if _startedFarm then
					_startedFarm = not u1327
				end

				local value7 = t2.value7
				local v1333 = tostring(_startedFarm)
				local _startedFarm2 = value82.Thunder._startedFarm
				local v1335 = u1327

				value7("Thunder.endFarming: stopping navigator; stopFarm=" .. v1333 .. " (startedFarm=" .. tostring(_startedFarm2) .. " userFarmOn=" .. tostring(v1335) .. ")")
				value82.Runtime.objectiveMode = false
				value82.Tasks.thunderObjective:stop()

				if _startedFarm then
					_startedFarm = value82.Runtime.farming
				end

				if not _startedFarm then
					value82.Thunder._startedFarm = nil
					value82.Thunder._savedLobby = nil

					return
				end

				value82.Farm.stop()
				value82.Thunder._startedFarm = nil
				value82.Thunder._savedLobby = nil
			end

			value82.Colossal = {}
			value82.Colossal.SHOOT_COOLDOWN = 5
			value82.Colossal.MOUNT_RADIUS = 4000
			value82.Colossal.IMPACT_BURST_MIN = 10
			value82.Colossal.IMPACT_BURST_MAX = 10
			value82.Colossal.SHOOT_BASE = 0
			value82.Colossal.SHOOT_BARREL = 40

			function value82.Colossal.boss()
				local Titans = workspace:FindFirstChild("Titans")
				local Parent

				if not Titans then
					if Titans then
						Parent = Titans.Parent
					else
						Parent = Titans
					end

					return Parent and Titans and Titans or nil
				end

				Titans = Titans:FindFirstChild("Colossal_Titan")

				if Titans then
					Parent = Titans.Parent
				else
					Parent = Titans
				end

				return Parent and Titans and Titans or nil
			end
			function value82.Colossal.active()
				local v1338

				if workspace:GetAttribute("Objective") == "Colossal Titan" then
					v1338 = value82.Colossal.boss() ~= nil
				else
					v1338 = false
				end

				return v1338
			end

			value82.Colossal.EREN_GUARD_RADIUS = 120

			function value82.Colossal.erenPos()
				local v1339 = value82.Util.safeIndex(workspace, "Unclimbable", "Objective")

				if v1339 then
					for _, child in ipairs(v1339:GetChildren()) do
						if child.Name:match("^Defend_Eren") then
							local Collider = child:FindFirstChild("Collider") or (child:FindFirstChild("Hitbox") or child:FindFirstChild("RootPart"))
							local isBasePart

							if Collider then
								isBasePart = Collider:IsA("BasePart")
							else
								isBasePart = Collider
							end

							if isBasePart then
								return Collider.Position
							end

							local isModel = child:IsA("Model")

							if isModel then
								isModel = child.PrimaryPart
							end

							if isModel then
								return child:GetPivot().Position
							end

							local BasePart = child:FindFirstChildWhichIsA("BasePart", true)

							if BasePart then
								return BasePart.Position
							end
						end
					end

					return nil
				else
					return nil
				end
			end
			function value82.Colossal.phase()
				local v1346 = value82.Colossal.boss()
				local Objectives

				if v1346 then
					local attribute = v1346:GetAttribute("Phase")

					if attribute == 2 then
						return 2
					elseif attribute == 1 then
						return 1
					else
						Objectives = t2.value1.RS:FindFirstChild("Objectives")

						if Objectives then
							if Objectives:FindFirstChild("Defeat_Colossal_Titan") then
								return 2
							elseif Objectives:FindFirstChild("Stall_Colossal_Titan") then
								return 1
							else
								return 1
							end
						else
							return 1
						end
					end
				else
					Objectives = t2.value1.RS:FindFirstChild("Objectives")

					if Objectives then
						if Objectives:FindFirstChild("Defeat_Colossal_Titan") then
							return 2
						elseif Objectives:FindFirstChild("Stall_Colossal_Titan") then
							return 1
						else
							return 1
						end
					else
						return 1
					end
				end
			end
			function value82.Colossal.cannons()
				local CS = t2.value1.CS
				local v1350 = value82.Colossal.boss()
				local PrimaryPart = v1350 and v1350.PrimaryPart

				if PrimaryPart then
					PrimaryPart = v1350.PrimaryPart.Position
				end

				local _, Position = value82.Char.get()

				if Position then
					Position = Position.Position
				end

				local t41 = {}

				for _, v in ipairs(CS.GetTagged(CS, "Cannon")) do
					local Parent = v.Parent

					if Parent then
						Parent = v:FindFirstChild("Base")
					end

					if Parent then
						local attribute = v:GetAttribute("Player")

						if not attribute or attribute == t2.value3.Name then
							local Base = v.Base
							local Magnitude

							if PrimaryPart then
								Magnitude = (PrimaryPart - Base.Position).Magnitude
							else
								Magnitude = PrimaryPart
							end

							if not PrimaryPart or (Magnitude or 0) <= value82.Colossal.MOUNT_RADIUS then
								local Magnitude2 = Position and ((Position - Base.Position).Magnitude or 0) or 0

								t41[#t41 + 1] = {
									inst = v,
									part = Base,
									dist = Magnitude2
								}
							end
						end
					end
				end

				table.sort(t41, function(p136, p137)
					return p136.dist < p137.dist
				end)

				return t41
			end
			function value82.Colossal.rotationLock(p138)
				if p138 then
					if value82.Conn.ColossalRotLock then
						return
					end

					value82.Connection.add("ColossalRotLock", t2.value1.RunService.Heartbeat:Connect(function()
						local Character2 = t2.value3.Character
						local Humanoid

						if Character2 then
							Humanoid = Character2:FindFirstChildOfClass("Humanoid")
						else
							Humanoid = Character2
						end

						local AutoRotate

						if Humanoid then
							AutoRotate = Humanoid.AutoRotate
						else
							AutoRotate = Humanoid
						end

						if AutoRotate then
							Humanoid.AutoRotate = false
						end

						if Character2 then
							Character2 = Character2:FindFirstChild("HumanoidRootPart")
						end

						if Character2 then
							Character2 = Character2:FindFirstChild("BG")
						end

						local isAlignOrientation = Character2 and Character2:IsA("AlignOrientation")

						if isAlignOrientation then
							isAlignOrientation = Character2.Enabled
						end

						if not isAlignOrientation then
							return
						end

						Character2.Enabled = false
					end))
					t2.value7("Colossal: rotation lock ON (manning cannon)")

					return
				end

				if not value82.Conn.ColossalRotLock then
					return
				end

				value82.Connection.disconnect("ColossalRotLock")

				local Character2 = t2.value3.Character
				local Humanoid

				if Character2 then
					Humanoid = Character2:FindFirstChildOfClass("Humanoid")
				else
					Humanoid = Character2
				end

				if Humanoid then
					Humanoid.AutoRotate = true
				end

				if Character2 then
					Character2 = Character2:FindFirstChild("HumanoidRootPart")
				end

				if Character2 then
					Character2 = Character2:FindFirstChild("BG")
				end

				local isAlignOrientation

				if Character2 then
					isAlignOrientation = Character2:IsA("AlignOrientation")
				else
					isAlignOrientation = Character2
				end

				if isAlignOrientation then
					Character2.Enabled = true
				end

				t2.value7("Colossal: rotation lock OFF")
			end
			function value82.Colossal.installVFXGuard()
				local v1369 = value82.Util.safeIndex(t2.value1.RS, "Assets", "Particles", "Cannon", "Explosion")

				if v1369 then
					local n19 = 0

					for _, descendant in ipairs(v1369:GetDescendants()) do
						if descendant:IsA("ParticleEmitter") then
							descendant:Destroy()
							n19 = n19 + 1
						end

						if descendant:IsA("Light") then
							descendant.Enabled = false
							descendant.Brightness = 0
						end
					end

					if n19 > 0 then
						t2.value7("Colossal VFXGuard: stripped " .. n19 .. " emitters from Cannon.Explosion template")
					end
				end

				local v1373 = value82.Util.safeIndex(t2.value1.RS, "Assets", "Objects", "Template_Debris")
				local isBasePart

				if v1373 then
					isBasePart = v1373:IsA("BasePart")
				else
					isBasePart = v1373
				end

				if isBasePart then
					v1373.Transparency = 1
					v1373.CastShadow = false
					t2.value7("Colossal VFXGuard: Template_Debris made invisible")
				end

				local Cache = t2.value1.RS:FindFirstChild("Cache")

				if not Cache then
					return
				end

				local GetDescendants = Cache.GetDescendants

				for _, v in ipairs(GetDescendants(Cache)) do
					local isBasePart2

					if v.Name == "Template_Debris" then
						isBasePart2 = v:IsA("BasePart")
					else
						isBasePart2 = false
					end

					if isBasePart2 then
						v.Transparency = 1
						v.CastShadow = false
					end
				end
			end
			function value82.Colossal.fireCycle(p139, p140, p141)
				if not p139 then
					return
				end

				if value82.Colossal._firing then
					return
				end

				value82.Colossal._firing = true

				local GET = t2.value1.RS.Assets.Remotes.GET
				local POST = t2.value1.RS.Assets.Remotes.POST
				local cycleCount = (value82.Colossal._cycleCount or 0) + 1

				value82.Colossal._cycleCount = cycleCount
				task.delay(15, function()
					local _firing = value82.Colossal._firing

					if _firing then
						_firing = value82.Colossal._cycleCount == cycleCount
					end

					if not _firing then
						return
					end

					value82.Colossal._firing = false
				end)

				if not p139:FindFirstChild("Base") then
					value82.Colossal._firing = false

					return
				end

				t2.value7("Colossal: fireCycle #" .. cycleCount .. " launching")

				local v1384 = math.random(value82.Colossal.IMPACT_BURST_MIN, value82.Colossal.IMPACT_BURST_MAX)

				task.spawn(function()
					local function v1385(p142)
						t2.value7("Colossal cycle [#" .. cycleCount .. "]: " .. p142)
						value82.Colossal._firing = false
					end

					local now = tick()

					while p139.Parent and p139:GetAttribute("Cooldown") ~= nil and true or p139:GetAttribute("Firing") ~= nil do
						if tick() - now > 4 then
							return v1385("SKIP:cooldown_timeout")
						end

						task.wait(0.1)
					end

					if not p139.Parent then
						return v1385("SKIP:cannon_despawned")
					end

					local _, v1388 = value82.Char.get()

					if not v1388 then
						return v1385("SKIP:no_hrp")
					end

					if not p139.Parent then
						return v1385("SKIP:cannon_no_parent")
					end

					value82.Remote.invoke(GET, "Cannon", "Claim", p139)
					value82.Remote.invoke(GET, "Cannon", "State", p139, true)

					local now2 = tick()

					while not v1388:FindFirstChild("Cannon") do
						if tick() - now2 > 3 then
							return v1385("SKIP:mount_weld_missing")
						end

						task.wait(0.05)
					end

					t2.value7("Colossal cycle [#" .. cycleCount .. "]: STEP:mounted")

					local t42 = {
						Base = p140,
						BarrelWood = p141
					}

					value82.Remote.invoke(GET, "Cannon", "Shoot", t42)
					t2.value7("Colossal cycle [#" .. cycleCount .. "]: STEP:shot")

					local v1391 = value82.Colossal.boss()
					local PrimaryPart = v1391 and v1391.PrimaryPart

					if PrimaryPart then
						PrimaryPart = v1391.PrimaryPart.Position
					end

					if not PrimaryPart then
						return v1385("SKIP:no_bossPos")
					end

					local Name = t2.value3.Name
					local v1394 = nil

					for _ = 1, 20 do
						for _, child in ipairs(workspace:GetChildren()) do
							local isModel = child.Name == "Cannon" and child:IsA("Model")

							if isModel then
								isModel = child:GetAttribute("Player") == Name
							end

							if isModel then
								v1394 = child

								break
							end
						end

						if v1394 then
							break
						end

						task.wait(0.1)
					end

					if not v1394 then
						return v1385("SKIP:proj_not_found")
					end

					v1394:SetAttribute("MH_Cycle", cycleCount)

					local v1399 = not v1394.Parent

					if v1399 then
						local getnilinstances_ = getnilinstances

						v1399 = type(getnilinstances_) == "function"
					end

					if v1399 then
						for _, v in ipairs(getnilinstances()) do
							local v1403

							if v.Name == "Cannon" then
								v1403 = v:GetAttribute("MH_Cycle") == cycleCount
							else
								v1403 = false
							end

							if v1403 then
								v1394 = v

								break
							end
						end
					end

					if not v1394 then
						return v1385("SKIP:proj_lost")
					end

					for _ = 1, v1384 do
						value82.Remote.fire(POST, "S_Skills", "Impact", v1394, PrimaryPart)
					end

					local v1405 = "STEP:impacts_sent x" .. v1384

					t2.value7("Colossal cycle [#" .. cycleCount .. "]: " .. v1405)

					local now3 = tick()

					while true do
						local Parent = p139.Parent

						if Parent then
							Parent = p139:GetAttribute("Firing") ~= nil
						end

						if not Parent then
							break
						end

						if tick() - now3 > 5 then
							return v1385("SKIP:firing_timeout")
						end

						task.wait(0.1)
					end

					if not p139.Parent then
						return v1385("SKIP:cannon_gone_before_dismount")
					end

					task.wait(0.1)

					local function v1408()
						value82.Remote.invoke(GET, "Cannon", "State", p139, false, {
							SFX = {},
							Object = p139,
							BarrelWood = p139.Barrel.BarrelWood,
							Angles = {
								Base = 0,
								BarrelWood = 0
							},
							Base = p139.Base,
							Directions = {}
						})
					end

					v1408()

					local now4 = tick()

					while true do
						local Parent = v1388.Parent

						if Parent then
							Parent = v1388:FindFirstChild("Cannon")
						end

						if not Parent then
							t2.value7("Colossal cycle [#" .. cycleCount .. "]: STEP:dismounted")
							t2.value7("Colossal cycle [#" .. cycleCount .. "]: DONE")
							value82.Colossal._firing = false

							return
						end

						if tick() - now4 > 3 then
							break
						end

						task.wait(0.1)
					end

					v1408()
					t2.value7("Colossal cycle [#" .. cycleCount .. "]: STEP:dismounted")
					t2.value7("Colossal cycle [#" .. cycleCount .. "]: DONE")
					value82.Colossal._firing = false
				end)
			end

			color39 = value82.Tasks
			color38 = value82.Task.new

			function t1.value3(p143)
				local inst = nil
				local v1412 = nil
				local n20 = 0

				while true do
					local enabled = p143.enabled

					if enabled then
						enabled = isInGame()
					end

					if not enabled then
						inst = nil
						value82.Colossal._firing = false
						value82.Colossal.rotationLock(false)
						value82.Move.cancel()
						value82.Move.cancel()

						return
					end

					task.wait(0.1)

					if value82.Colossal.active() then
						local _, v1416 = value82.Char.get()

						if not v1416 then
							continue
						end

						local v1417 = value82.Colossal.boss()
						local Position = v1417 and (v1417.PrimaryPart and v1417.PrimaryPart.Position) or nil
						local v1419 = value82.Colossal.phase()

						if v1419 ~= v1412 then
							notify("Colossal Raid", v1419 == 1 and "Stall phase manning cannon" or "Defeat phase attacking Bertholdt", 4, "crosshair")
							t2.value7("Colossal: phase " .. tostring(v1412) .. " -> " .. tostring(v1419))
							v1412 = v1419
						end

						if v1419 == 2 then
							local now = tick()

							while true do
								local _firing = value82.Colossal._firing

								if _firing then
									_firing = tick() - now < 12
								end

								if not _firing then
									break
								end

								task.wait(0.1)

								continue
							end

							inst = nil
							value82.Colossal._firing = false
							value82.Colossal.rotationLock(false)
							value82.Move.cancel()
							value82.Runtime.objectiveMode = false

							continue
						else
							if v1419 == 1 then
								local Objectives = t2.value1.RS:FindFirstChild("Objectives")

								if Objectives then
									Objectives = Objectives:FindFirstChild("Stall_Colossal_Titan")
								end

								if Objectives then
									local Value = Objectives.Value or 0
									local attribute = Objectives:GetAttribute("Requirement") or 0
									local v1425

									if attribute > 0 then
										v1425 = attribute <= Value
									else
										v1425 = false
									end

									if v1425 then
										inst = nil
										value82.Colossal._firing = false
										value82.Colossal.rotationLock(false)
										value82.Move.cancel()
										value82.Runtime.objectiveMode = false
										v1419 = -1
									end
								end
							end

							if v1419 == -1 then
								continue
							end

							value82.Runtime.objectiveMode = true

							local Position2, v1427, Magnitude, v1429, v1430, v1431, v1432, v1433, v1434

							if not (inst and inst.Parent) then
								inst = nil

								local v1435 = value82.Colossal.cannons()[1]

								if v1435 then
									inst = v1435.inst
									n20 = 0
									v1486 = inst:FindFirstChild("Base")

									if v1486 then
										Position2 = v1486.Position
										v1427 = tick() - n20
										Magnitude = (v1416.Position - Position2).Magnitude

										if Position then
											v1429 = value82.Colossal.SHOOT_COOLDOWN <= v1427
										else
											v1429 = Position
										end

										v1430 = v1416:FindFirstChild("Cannon") ~= nil
										v1431 = not v1429

										if v1431 then
											v1431 = not (value82.Colossal._firing or v1430)

											if v1431 then
												v1431 = value82.Colossal.SHOOT_COOLDOWN - v1427 > 1.5
											end
										end

										if v1431 then
											v1432 = value82.Colossal.erenPos()
											v1433, v1434 = value82.Target.smallTitanNape(v1432 or Position2)

											if v1433 then
												if v1432 then
													v1432 = (v1432 - v1433.Position).Magnitude <= value82.Colossal.EREN_GUARD_RADIUS
												end
											else
												v1432 = v1433
											end

											if v1432 then
												value82.Colossal.rotationLock(false)
												value82.Move.to(v1416, v1433.Position + Vector3.new(0, value82.Config.HoverHeight, 0))

												continue
											else
												if Magnitude > 14 then
													value82.Colossal.rotationLock(false)
													value82.Move.to(v1416, Position2 + Vector3.new(0, 6, 0))
												else
													value82.Move.cancel()
													value82.Colossal.rotationLock(true)

													if Position then
														if value82.Colossal.SHOOT_COOLDOWN <= v1427 then
															Position = not value82.Colossal._firing
														else
															Position = false
														end
													end

													if Position then
														value82.Colossal.fireCycle(inst, value82.Colossal.SHOOT_BASE, value82.Colossal.SHOOT_BARREL)
														n20 = tick()
													end
												end

												continue
											end
										end

										if Magnitude > 14 then
											value82.Colossal.rotationLock(false)
											value82.Move.to(v1416, Position2 + Vector3.new(0, 6, 0))
										else
											value82.Move.cancel()
											value82.Colossal.rotationLock(true)

											if Position then
												if value82.Colossal.SHOOT_COOLDOWN <= v1427 then
													Position = not value82.Colossal._firing
												else
													Position = false
												end
											end

											if Position then
												value82.Colossal.fireCycle(inst, value82.Colossal.SHOOT_BASE, value82.Colossal.SHOOT_BARREL)
												n20 = tick()
											end
										end

										continue
									else
										inst = nil

										continue
									end
								else
									value82.Runtime.objectiveMode = false

									continue
								end
							end

							local Base = inst:FindFirstChild("Base")

							if Base then
								Position2 = Base.Position
								v1427 = tick() - n20
								Magnitude = (v1416.Position - Position2).Magnitude

								if Position then
									v1429 = value82.Colossal.SHOOT_COOLDOWN <= v1427
								else
									v1429 = Position
								end

								v1430 = v1416:FindFirstChild("Cannon") ~= nil
								v1431 = not v1429

								if v1431 then
									v1431 = not (value82.Colossal._firing or v1430)

									if v1431 then
										v1431 = value82.Colossal.SHOOT_COOLDOWN - v1427 > 1.5
									end
								end

								if v1431 then
									v1432 = value82.Colossal.erenPos()
									v1433, v1434 = value82.Target.smallTitanNape(v1432 or Position2)

									if v1433 then
										if v1432 then
											v1432 = (v1432 - v1433.Position).Magnitude <= value82.Colossal.EREN_GUARD_RADIUS
										end
									else
										v1432 = v1433
									end

									if v1432 then
										value82.Colossal.rotationLock(false)
										value82.Move.to(v1416, v1433.Position + Vector3.new(0, value82.Config.HoverHeight, 0))

										continue
									else
										if Magnitude > 14 then
											value82.Colossal.rotationLock(false)
											value82.Move.to(v1416, Position2 + Vector3.new(0, 6, 0))
										else
											value82.Move.cancel()
											value82.Colossal.rotationLock(true)

											if Position then
												if value82.Colossal.SHOOT_COOLDOWN <= v1427 then
													Position = not value82.Colossal._firing
												else
													Position = false
												end
											end

											if Position then
												value82.Colossal.fireCycle(inst, value82.Colossal.SHOOT_BASE, value82.Colossal.SHOOT_BARREL)
												n20 = tick()
											end
										end

										continue
									end
								end

								if Magnitude > 14 then
									value82.Colossal.rotationLock(false)
									value82.Move.to(v1416, Position2 + Vector3.new(0, 6, 0))
								else
									value82.Move.cancel()
									value82.Colossal.rotationLock(true)

									if Position then
										if value82.Colossal.SHOOT_COOLDOWN <= v1427 then
											Position = not value82.Colossal._firing
										else
											Position = false
										end
									end

									if Position then
										value82.Colossal.fireCycle(inst, value82.Colossal.SHOOT_BASE, value82.Colossal.SHOOT_BARREL)
										n20 = tick()
									end
								end

								continue
							else
								inst = nil

								continue
							end
						end
					else
						local objectiveMode = value82.Runtime.objectiveMode

						if objectiveMode then
							objectiveMode = v1412 ~= nil
						end

						if objectiveMode then
							inst = nil
							value82.Colossal._firing = false
							value82.Colossal.rotationLock(false)
							value82.Move.cancel()
							value82.Runtime.objectiveMode = false
							v1412 = nil
						end

						continue
					end
				end
			end

			t1.value1 = color38("ColossalRaid", t1.value3)
			color39.colossalRaid = t1.value1

			function value82.Colossal.startMonitor()
				if value82.Conn.ColossalMonitor then
					return
				end

				value82.Connection.add("ColossalMonitor", task.spawn(function()
					while value82.Runtime.farming do
						task.wait(0.5)

						local v1438 = value82.Colossal.active()
						local v1439 = value82.Tasks.colossalRaid:isRunning()
						local v1440

						if v1438 then
							v1440 = not v1439
						else
							v1440 = v1438
						end

						if v1440 then
							value82.Colossal.installVFXGuard()
							value82.Tasks.colossalRaid:start()
						elseif not v1438 and v1439 then
							value82.Tasks.colossalRaid:stop()
							value82.Runtime.objectiveMode = false
						end
					end

					if not value82.Tasks.colossalRaid:isRunning() then
						return
					end

					value82.Tasks.colossalRaid:stop()
				end))
			end
			function value82.Colossal.stopMonitor()
				value82.Connection.disconnect("ColossalMonitor")

				if not value82.Tasks.colossalRaid:isRunning() then
					return
				end

				value82.Tasks.colossalRaid:stop()
			end

			color39 = value82.Tasks
			color38 = value82.Task.new

			function t1.value3(p144)
				if isInGame() then
					v1070("In game finish the run first.")

					return
				end

				value82.Lobby.thunderMode = true
				v1070("Reading quest progress...")

				local v1441 = value82.Thunder.openPanelAndRead(5)
				local questCache = not next(v1441) and (value82.Lobby.questCache or {}) or v1441
				local n21, n22

				if next(questCache) then
					n21 = 0
					n22 = 4
				else
					t2.value7("Thunder: no GUI/cache progress running missions in order (full-auto)")
					v1070("No progress data running all missions in order...")
					n21 = 0
					n22 = 4
				end

				while true do
					local enabled = p144.enabled

					if enabled then
						enabled = not isInGame()
					end

					if not enabled then
						v1070(value82.Lobby.lastThunderStatus or "Idle.")

						return
					end

					local v1446 = value82.Thunder.openPanelAndRead(4)
					local questCache2 = not next(v1446) and (value82.Lobby.questCache or {}) or v1446
					local v1448 = value82.Thunder.nextQuest(questCache2)

					if not v1448 then
						v1071()
						v1070("All Thunder Spear quests complete!")
						notify("Thunder Quest", "All quests done craft your Thunder Spear!", 5, "check")

						break
					end

					local v1449 = value82.Thunder.missionProgressStr(v1448, questCache2)

					v1070(("Mission: %s %s/%s [%s]"):format(v1448.name, v1448.map, v1448.objective, v1449))
					t2.value7("Thunder: next mission", v1448.name, "(" .. v1449 .. ")")
					v1070("Creating session for " .. v1448.name .. "...")

					if value82.Thunder.runQuestSession(v1448) then
						value82.Lobby.thunderRan[v1448.name] = true

						local v1450 = tick() + 15

						n21 = 0

						while true do
							local v1451 = not isInGame()

							if v1451 then
								if tick() < v1450 then
									v1451 = p144.enabled
								else
									v1451 = false
								end
							end

							if not v1451 then
								break
							end

							task.wait(1)
						end

						if isInGame() then
							value82.Thunder.beginFarming()
							v1070("In " .. v1448.map .. " farming the objective...")

							break
						end
					else
						n21 = n21 + 1

						if n22 <= n21 then
							v1071()
							v1070("Gave up on " .. v1448.name .. " after " .. n21 .. " failed attempts.")
							notify("Thunder Quest", "Couldn\'t create " .. v1448.name .. " session stopped.", 5, "skull")

							break
						end

						v1070("Session create failed (" .. n21 .. "/" .. n22 .. ") retrying...")
						task.wait(5)
					end
				end

				v1070(value82.Lobby.lastThunderStatus or "Idle.")
			end

			t1.value1 = color38("ThunderQuest", t1.value3)
			color39.thunder = t1.value1
			value82.Gear = {}
			color39 = value82.Gear
			t1.value2 = {
				"ODM_Damage",
				"Crit_Damage",
				"Crit_Chance",
				"Blade_Durability",
				"ODM_Speed",
				"ODM_Control",
				"ODM_Range",
				"ODM_Gas"
			}
			color39.CATEGORIES = {
				Blades = t1.value2,
				Spears = {
					"TS_Damage",
					"Crit_Damage",
					"Crit_Chance",
					"Blast_Radius",
					"TS_Speed",
					"TS_Control",
					"TS_Range",
					"TS_Gas"
				}
			}

			local function v1452(p145)
				value82.Lobby.lastGearStatus = p145
				value82.UI.setParagraph(value82.UI.paragraphs.gear, p145)
			end

			color39 = value82.Gear

			function t1.value1(p146)
				value82.Actor.invoke("S_Equipment", "Weapon", {
					argsExpr = string.format("%q", p146),
					mapExpr = "out = true",
					timeout = 5
				})
			end

			color39.switchWeapon = t1.value1
			color39 = value82.Gear

			function t1.value1()
				local v1453 = value82.Gear.CATEGORIES[value82.Lobby.autoUpgrade.weapon]

				if not v1453 then
					return false
				end

				value82.Gear.switchWeapon(value82.Lobby.autoUpgrade.weapon)
				task.wait(0.5)

				local t43 = {}

				for _, v in ipairs(v1453) do
					t43[#t43 + 1] = v
				end

				local v1457 = value82.Stats.upgrades[value82.Lobby.autoUpgrade.weapon]

				if v1457 then
					table.sort(t43, function(p147, p148)
						return (v1457[p147] or 0) < (v1457[p148] or 0)
					end)
				end

				local v1458 = #t43
				local v1459 = false

				while v1458 > 0 do
					local t44 = {}

					for i = 1, v1458 do
						t44[#t44 + 1] = string.format("%q", t43[i])
					end

					local t45 = {
						argsExpr = "{ " .. table.concat(t44, ", ") .. " }",
						mapExpr = "out = (res ~= nil)",
						timeout = 6
					}
					local S_Equipment = value82.Actor.invoke("S_Equipment", "Upgrade", t45)

					if not (S_Equipment and S_Equipment.ok) then
						break
					end

					if S_Equipment.data == true then
						t2.value7("upgradeAll: success with " .. v1458 .. "/" .. #t43 .. " stats")
						v1459 = true

						break
					end

					v1458 = v1458 - 1

					if v1458 > 0 then
						task.wait(0.3)
					end
				end

				if v1459 then
					return v1459
				end

				t2.value7("upgradeAll: not enough Gold for even the cheapest stat")

				return v1459
			end

			color39.upgradeAll = t1.value1
			color39 = value82.Tasks
			t1.value2 = value82.Task.new("AutoUpgrade", function(p149)
				v180("AutoUpgrade")

				if not (value82.Stats.upgrades and next(value82.Stats.upgrades)) then
					value82.DataCopy.fetch()
				end

				v1452("Running " .. value82.Lobby.autoUpgrade.weapon)

				while p149.enabled do
					if isInGame() then
						v1452("Waiting not in lobby.")
						task.wait(3)
					else
						if not value82.Gear.upgradeAll() then
							v1452("Idle (not enough Gold or maxed).")

							break
						end

						v1452("Upgraded! " .. value82.Lobby.autoUpgrade.weapon)
						task.wait(1)
					end
				end

				value82.Lobby.busyLobby.AutoUpgrade = nil
			end)
			color39.autoUpgrade = t1.value2
			value82.Inventory = {}
			color39 = value82.Inventory

			function t1.value1()
				local perkStorage = value82.Stats.perkStorage

				if not perkStorage or #perkStorage == 0 then
					return {}
				else
					local t46 = {}

					for _, v in ipairs(perkStorage) do
						t46[#t46 + 1] = {
							id = v.id,
							name = v.name,
							rarity = v.rarity or "Unknown"
						}
					end

					return t46
				end
			end

			color39.fetchStoragePerks = t1.value1
			color39 = value82.Inventory

			function t1.value1(p150)
				if not p150 or #p150 == 0 then
					return true
				end

				local Remotes = t2.value1.RS:FindFirstChild("Assets") and t2.value1.RS.Assets:FindFirstChild("Remotes")

				if Remotes then
					Remotes = t2.value1.RS.Assets.Remotes:FindFirstChild("GET")
				end

				if not Remotes then
					t2.value7("deletePerks: GET remote not found")

					return false
				end

				local ok, result = pcall(function()
					return Remotes:InvokeServer("S_Equipment", "Delete", "Perk", p150)
				end)

				if not ok then
					t2.value7("deletePerks: pcall failed:", result)
				end

				if not ok then
					return ok
				end

				ok = result ~= nil

				return ok
			end

			color39.deletePerks = t1.value1
			color39 = value82.Inventory

			function t1.value1()
				local DeletePerksRarities = value82.Config.DeletePerksRarities

				if not DeletePerksRarities or #DeletePerksRarities == 0 then
					DeletePerksRarities = value82.Util.flagSelection("SellPerksRarity")
					value82.Config.DeletePerksRarities = DeletePerksRarities
				end

				if not DeletePerksRarities or #DeletePerksRarities == 0 then
					t2.value7("AutoDeletePerks: no rarities selected")

					return
				end

				local t47 = {}

				for _, DeletePerksRarity in ipairs(DeletePerksRarities) do
					t47[DeletePerksRarity] = true
				end

				local v1476 = value82.Inventory.fetchStoragePerks()

				t2.value7("AutoDeletePerks: cache has", #v1476, "storage perks")

				if #v1476 == 0 then
					t2.value7("AutoDeletePerks: no storage perks found")

					return
				end

				local v1477, v1478, v1479 = ipairs(v1476)
				local t48 = {}

				while true do
					local v1481

					v1479, v1481 = v1477(v1478, v1479)

					if not v1479 then
						break
					end

					if t47[v1481.rarity] then
						t48[#t48 + 1] = v1481.id
					end
				end

				if #t48 == 0 then
					t2.value7("AutoDeletePerks: nothing to delete")

					return
				end

				t2.value7("AutoDeletePerks: queued", #t48, "perks to delete")
				notify("Auto Delete Perks", string.format("Deleting %d perk(s)...", #t48), 3, "trash-2")
				task.wait(3)

				local n23 = 20
				local n24 = 5
				local n25 = 0

				for i = 1, #t48, 20 do
					local min = math.min
					local v1487 = #t48
					local t49 = {}

					for i2 = i, min(i + n23 - 1, v1487) do
						t49[#t49 + 1] = t48[i2]
					end

					local v1490 = false

					for i2 = 1, n24 do
						if value82.Inventory.deletePerks(t49) then
							v1490 = true

							break
						end

						t2.value7("AutoDeletePerks: batch attempt", i2, "failed, retrying in 2s")
						task.wait(2)
					end

					if not v1490 then
						t2.value7("AutoDeletePerks: batch failed after", n24, "attempts, stopping")

						return
					end

					n25 = n25 + #t49
					t2.value7("AutoDeletePerks: deleted batch", #t49, "total so far", n25)
				end

				if not (n25 > 0) then
					return n25
				end

				notify("Auto Delete Perks", string.format("Deleted %d perk(s) (%s)", n25, table.concat(DeletePerksRarities, ", ")), 4, "trash-2")

				return n25
			end

			color39.autoDeletePerks = t1.value1
			color39 = value82.Tasks
			t1.value2 = value82.Task.new("AutoDeletePerks", function(_)
				if game.PlaceId ~= value82.PLACE.Lobby then
					return
				end

				if not value82.Stats.perkStorage or #value82.Stats.perkStorage == 0 then
					value82.DataCopy.fetch()
				end

				if not value82.Stats.perkStorage or #value82.Stats.perkStorage == 0 then
					t2.value7("AutoDeletePerks: no perk cache (fetch returned none)")

					return
				end

				v180("AutoDeletePerks")

				local v1492 = value82.Inventory.autoDeletePerks()

				if v1492 then
					v1492 = v1492 > 0
				end

				if not v1492 then
					value82.Lobby.busyLobby.AutoDeletePerks = nil

					return
				end

				local t50 = {}

				for _, deletePerksRarity in ipairs(value82.Config.DeletePerksRarities) do
					t50[deletePerksRarity] = true
				end

				local perkStorage = {}

				for _, v in ipairs(value82.Stats.perkStorage or {}) do
					if not t50[v.rarity] then
						perkStorage[#perkStorage + 1] = v
					end
				end

				value82.Stats.perkStorage = perkStorage
				value82.Lobby.busyLobby.AutoDeletePerks = nil
			end)
			color39.autoDeletePerks = t1.value2
			value82.Inventory.CRATE_TYPES = { "Scout Fashion", "Anime All-Stars", "Blade Burst" }
			color39 = value82.Inventory
			t1.value3 = { "Scout Fashion", "Scout Fashion [2]" }
			color39.CRATE_VARIANTS = {
				["Scout Fashion"] = t1.value3,
				["Anime All-Stars"] = {
					"Anime All-Stars",
					"Anime All-Stars [2]",
					"Anime All-Stars [3]",
					"Anime All-Stars [4]",
					"Anime All-Stars [5]",
					"Anime All-Stars [6]"
				},
				["Blade Burst"] = { "Blade Burst", "Blade Burst [2]" }
			}
			color39 = value82.Inventory

			function t1.value1(p151)
				local Remotes = t2.value1.RS:FindFirstChild("Assets") and t2.value1.RS.Assets:FindFirstChild("Remotes")

				if Remotes then
					Remotes = t2.value1.RS.Assets.Remotes:FindFirstChild("GET")
				end

				if not Remotes then
					t2.value7("openCrate: GET remote not found")

					return nil
				end

				local t51 = { pcall(function()
						return Remotes:InvokeServer("S_Inventory", "Crate", p151)
					end) }
				local v1501 = t51[2]

				if t51[1] then
					return v1501
				else
					t2.value7("openCrate: pcall failed:", v1501)

					return nil
				end
			end

			color39.openCrate = t1.value1
			color39 = value82.Inventory

			function t1.value1()
				local OpenCrateTypes = value82.Config.OpenCrateTypes

				if not OpenCrateTypes or #OpenCrateTypes == 0 then
					OpenCrateTypes = value82.Util.flagSelection("OpenCrateTypes")
					value82.Config.OpenCrateTypes = OpenCrateTypes
				end

				if not OpenCrateTypes or #OpenCrateTypes == 0 then
					t2.value7("AutoOpenCrates: no crate types selected")

					return 0
				end

				local n26 = 500
				local n27 = 0

				for _, OpenCrateType in ipairs(OpenCrateTypes) do
					local v1507 = value82.Inventory.CRATE_VARIANTS[OpenCrateType] or { OpenCrateType }

					for _, v in ipairs(v1507) do
						local n28 = 0

						while n28 < n26 do
							local v1511 = value82.Inventory.openCrate(v)

							if v1511 == nil then
								break
							end

							n28 = n28 + 1
							n27 = n27 + 1

							if type(v1511) == "table" then
								value82.Stats.lastSlotData = v1511
							end

							notify("Opening Crates", string.format("%s — opened #%d (total %d)", v, n28, n27), 1.5, "package-open")
							task.wait(0.35)
						end

						if n28 > 0 then
							t2.value7("AutoOpenCrates: opened", n28, v)
						end
					end
				end

				if n27 > 0 then
					notify("Auto Open Crates", string.format("Opened %d crate(s) (%s). Rejoin to refresh your inventory.", n27, table.concat(OpenCrateTypes, ", ")), 7, "package-open")

					return n27
				else
					t2.value7("AutoOpenCrates: nothing to open")
					notify("Auto Open Crates", "No matching crates to open.", 3, "package-open")

					return n27
				end
			end

			color39.autoOpenCrates = t1.value1
			color39 = value82.Tasks
			t1.value2 = value82.Task.new("AutoOpenCrates", function(_)
				if game.PlaceId ~= value82.PLACE.Lobby then
					return
				end

				value82.Lobby.waitUI(60)

				if game.PlaceId ~= value82.PLACE.Lobby then
					return
				end

				v180("AutoOpenCrates")

				local n29 = 0
				local n30 = 1
				local v1514 = false
				local n31 = 3
				local n32 = 3

				while true do
					n29 = n29 + n30

					local v1517 = ((not v1514 or n31 > n29) and true or false) and not v1514

					if v1517 then
						v1517 = n29 <= n31
					end

					if not (v1517 and (value82.Config.AutoOpenCrates and game.PlaceId == value82.PLACE.Lobby)) then
						value82.Lobby.busyLobby.AutoOpenCrates = nil

						return
					end

					local Remotes = t2.value1.RS:FindFirstChild("Assets") and t2.value1.RS.Assets:FindFirstChild("Remotes")

					if Remotes then
						Remotes = t2.value1.RS.Assets.Remotes:FindFirstChild("GET")
					end

					if Remotes then
						break
					end

					t2.value7("AutoOpenCrates: GET remote not ready, attempt", n29, "of", n32)
					task.wait(3)
				end

				value82.Inventory.autoOpenCrates()
				value82.Lobby.busyLobby.AutoOpenCrates = nil
			end)
			color39.autoOpenCrates = t1.value2
			value82.Achievements = {}
			value82.Achievements.MAX_ID = 71
			color39 = value82.Achievements

			function t1.value1(p152)
				local Remotes = t2.value1.RS:FindFirstChild("Assets") and t2.value1.RS.Assets:FindFirstChild("Remotes")

				if Remotes then
					Remotes = t2.value1.RS.Assets.Remotes:FindFirstChild("GET")
				end

				if not Remotes then
					t2.value7("claimAchievement: GET remote not found")

					return nil
				end

				local ok, result = pcall(function()
					return Remotes:InvokeServer("S_Achievements", "Claim", p152)
				end)

				if ok then
					return result
				else
					t2.value7("claimAchievement: pcall failed:", result)

					return nil
				end
			end

			color39.claim = t1.value1
			color39 = value82.Achievements

			function t1.value1()
				local n33 = 0

				for i = 1, value82.Achievements.MAX_ID do
					if not value82.Config.AutoClaimAchievements or game.PlaceId ~= value82.PLACE.Lobby then
						if n33 > 0 then
							notify("Auto Claim Achievements", string.format("Claimed %d achievement(s). Rejoin if rewards don\'t show.", n33), 7, "award")

							return n33
						else
							t2.value7("AutoClaimAchievements: nothing to claim")
							notify("Auto Claim Achievements", "No achievements ready to claim.", 3, "award")

							return n33
						end
					end

					local v1524 = value82.Achievements.claim(i)
					local v1525

					if v1524 == nil then
						v1525 = false
					else
						v1525 = v1524 ~= false
					end

					if v1525 then
						n33 = n33 + 1
						notify("Claiming Achievements", string.format("Claimed achievement #%d (total %d)", i, n33), 1.5, "award")
						task.wait(0.35)
					else
						task.wait(0.1)
					end
				end

				if n33 > 0 then
					notify("Auto Claim Achievements", string.format("Claimed %d achievement(s). Rejoin if rewards don\'t show.", n33), 7, "award")

					return n33
				else
					t2.value7("AutoClaimAchievements: nothing to claim")
					notify("Auto Claim Achievements", "No achievements ready to claim.", 3, "award")

					return n33
				end
			end

			color39.autoClaim = t1.value1
			color39 = value82.Tasks
			t1.value2 = value82.Task.new("AutoClaimAchievements", function(_)
				if game.PlaceId ~= value82.PLACE.Lobby then
					return
				end

				value82.Lobby.waitUI(60)

				if game.PlaceId ~= value82.PLACE.Lobby then
					return
				end

				v180("AutoClaimAchievements")

				local n34 = 3

				for i = 1, 3 do
					if not value82.Config.AutoClaimAchievements or game.PlaceId ~= value82.PLACE.Lobby then
						value82.Lobby.busyLobby.AutoClaimAchievements = nil

						return
					end

					local Remotes = t2.value1.RS:FindFirstChild("Assets") and t2.value1.RS.Assets:FindFirstChild("Remotes")

					if Remotes then
						Remotes = t2.value1.RS.Assets.Remotes:FindFirstChild("GET")
					end

					if Remotes then
						value82.Achievements.autoClaim()

						break
					end

					t2.value7("AutoClaimAchievements: GET remote not ready, attempt", i, "of", n34)
					task.wait(3)
				end

				value82.Lobby.busyLobby.AutoClaimAchievements = nil
			end)
			color39.autoClaimAchievements = t1.value2
			value82.ConfigManager = {}
			value82.ConfigManager.FOLDER = "WindUI/Mahmut-Hub/AOTR/config"
			color39 = value82.ConfigManager

			function t1.value1(p153)
				return value82.ConfigManager.FOLDER .. "/" .. t2.value3.Name .. "_" .. tostring(p153) .. ".json"
			end

			color39.path = t1.value1
			color39 = value82.ConfigManager

			function t1.value1()
				if not (t2.value5.isfolder and t2.value5.makefolder) then
					return
				end

				if t2.value5.isfolder(value82.ConfigManager.FOLDER) then
					return
				end

				t2.value5.makefolder(value82.ConfigManager.FOLDER)
			end

			color39.ensureFolder = t1.value1
			color39 = value82.ConfigManager

			function t1.value1()
				local isfolder_2 = t2.value5.isfolder
				local listfiles_, v1531, v1532, t52, match, v1535, v1536, ok, result

				if isfolder_2 then
				elseif isfolder_2 then
					value82.ConfigManager.ensureFolder()
					listfiles_ = listfiles
					v1531 = type(listfiles_) == "function" and listfiles(value82.ConfigManager.FOLDER) or {}
					v1532 = t2.value3.Name .. "_"
					t52 = {}

					for _, v in ipairs(v1531) do
						match = v:match("([^/\\]+)%.json$")

						if match then
							v1535 = match:sub(1, #v1532) == v1532
						else
							v1535 = match
						end

						if v1535 then
							v1536 = match:sub(#v1532 + 1)
							ok, result = pcall(t2.value5.readfile, v)

							if ok then
								if result then
									if result == "{}" then
										result = false
									else
										result = #result > 2
									end
								end
							else
								result = ok
							end

							if result then
								t52[#t52 + 1] = v1536
							end
						end
					end

					table.sort(t52)

					return t52
				else
					return {}
				end

				isfolder_2 = t2.value5.readfile

				if isfolder_2 then
					value82.ConfigManager.ensureFolder()
					listfiles_ = listfiles
					v1531 = type(listfiles_) == "function" and listfiles(value82.ConfigManager.FOLDER) or {}
					v1532 = t2.value3.Name .. "_"
					t52 = {}

					for _, v in ipairs(v1531) do
						match = v:match("([^/\\]+)%.json$")

						if match then
							v1535 = match:sub(1, #v1532) == v1532
						else
							v1535 = match
						end

						if v1535 then
							v1536 = match:sub(#v1532 + 1)
							ok, result = pcall(t2.value5.readfile, v)

							if ok then
								if result then
									if result == "{}" then
										result = false
									else
										result = #result > 2
									end
								end
							else
								result = ok
							end

							if result then
								t52[#t52 + 1] = v1536
							end
						end
					end

					table.sort(t52)

					return t52
				else
					return {}
				end
			end

			color39.list = t1.value1
			color39 = value82.ConfigManager

			function t1.value1(p154)
				if not p154 or p154 == "" then
					return false, "Preset name is required."
				end

				if not t2.value5.writefile then
					return false, "Executor does not support writefile."
				end

				local v1543 = t2.value3.Name .. "_"

				if p154.sub(p154, 1, #v1543) == v1543 then
					p154 = p154:sub(#v1543 + 1)
				end

				value82.ConfigManager.ensureFolder()

				local t53 = {}
				local Window = value82.UI.Window

				if Window then
					Window = value82.UI.Window.Flags
				end

				if Window then
					for k, v in pairs(Window) do
						if type(v) == "table" then
							local ok, result = pcall(function()
								return v.Value
							end)

							if ok then
								ok = result ~= nil
							end

							if ok then
								t53[k] = result
							end
						end
					end
				end

				local function v1550()
					t2.value5.writefile(value82.ConfigManager.path(p154), t2.value1.Http:JSONEncode(t53))
				end

				local t54 = { pcall(v1550) }
				local v1552 = t54[2]

				if t54[1] then
					t2.value7("ConfigManager.save:", t2.value3.Name .. "_" .. p154, "(", value82.Util.count(t53), "flags)")

					return true
				else
					return false, tostring(v1552)
				end
			end

			color39.save = t1.value1
			color39 = value82.ConfigManager

			function t1.value1(p155)
				if not p155 or p155 == "" then
					return false, "No preset selected."
				end

				local readfile_2 = t2.value5.readfile

				if readfile_2 then
					readfile_2 = t2.value5.isfile
				end

				if not readfile_2 then
					return false, "Executor does not support readfile."
				end

				local v1554 = value82.ConfigManager.path(p155)

				if not t2.value5.isfile(v1554) then
					return false, "Preset \'" .. p155 .. "\' not found."
				end

				local function v1555()
					local v1556 = t2.value5.readfile(v1554)
					local data = t2.value1.Http:JSONDecode(v1556)

					if not (data and next(data)) then
						error("Empty or invalid preset file.")
					end

					value82.Lobby.restoring = true

					local Window = value82.UI.Window

					if Window then
						Window = value82.UI.Window.Flags
					end

					if not Window then
						value82.Lobby.restoring = false

						return
					end

					local t55 = { "Map", "Difficulty", "Objective" }
					local v1560, v1561, v1562 = ipairs(t55)

					while true do
						local v1563

						v1562, v1563 = v1560(v1561, v1562)

						if not v1562 then
							break
						end

						if data[v1563] ~= nil then
							local v1564 = Window[v1563]

							if v1564 then
								pcall(function()
									local Set = v1564.Set

									if type(Set) == "function" then
										v1564:Set(data[v1563])

										return
									end

									local Select = v1564.Select

									if type(Select) ~= "function" then
										return
									end

									v1564:Select(data[v1563])
								end)
							end
						end
					end

					for k, v in pairs(data) do
						local v1569 = not table.find(t55, k) and Window[k]

						if v1569 then
							pcall(function()
								local Set = v1569.Set

								if type(Set) == "function" then
									v1569:Set(v)

									return
								end

								local Select = v1569.Select

								if type(Select) ~= "function" then
									return
								end

								v1569:Select(v)
							end)
						end
					end

					value82.Lobby.restoring = false
				end

				local t56 = { pcall(v1555) }
				local v1573 = t56[2]

				if t56[1] then
					t2.value7("ConfigManager.load:", t2.value3.Name .. "_" .. p155)

					return true
				else
					value82.Lobby.restoring = false

					return false, tostring(v1573)
				end
			end

			color39.load = t1.value1
			color39 = value82.ConfigManager

			function t1.value1(p156)
				if not p156 or p156 == "" then
					return false, "No preset selected."
				end

				if not t2.value5.writefile then
					return false, "Executor does not support file operations."
				end

				local v1574 = value82.ConfigManager.path(p156)
				local delfile_ = delfile
				local delfile_2 = type(delfile_) == "function" and delfile

				if delfile_2 then
					if delfile_2 then
						pcall(delfile_2, v1574)
					else
						pcall(t2.value5.writefile, v1574, "{}")
					end

					t2.value7("ConfigManager.delete:", t2.value3.Name .. "_" .. p156)

					return true
				end

				local deletefile_ = deletefile

				delfile_2 = type(deletefile_) == "function" and deletefile or nil

				if delfile_2 then
					pcall(delfile_2, v1574)
				else
					pcall(t2.value5.writefile, v1574, "{}")
				end

				t2.value7("ConfigManager.delete:", t2.value3.Name .. "_" .. p156)

				return true
			end

			color39.delete = t1.value1
			color39 = value82.ConfigManager

			function t1.value1()
				pcall(function()
					value82.Lobby.restoring = true

					if not value82.UI.config then
						value82.Lobby.restoring = false

						return
					end

					value82.UI.config:Reset()
					value82.Lobby.restoring = false
				end)
				t2.value7("ConfigManager.reset: all flags reset to defaults")
			end

			color39.reset = t1.value1
			value82.ConfigManager._selectedName = ""
			value82.Skill = {}
			color39 = value82.Skill
			t1.value6 = {
				"43",
				"42",
				"41",
				"40",
				"39",
				"38"
			}
			t1.value3 = {
				offense = {
					"11",
					"10",
					"9",
					"8",
					"7",
					"6",
					"5",
					"4",
					"3",
					"2",
					"1"
				},
				defense = t1.value6,
				support = {
					"80",
					"79",
					"78",
					"77",
					"76",
					"75",
					"74",
					"73",
					"72",
					"71",
					"70"
				}
			}
			t1.value6 = {
				"11",
				"10",
				"9",
				"8",
				"7",
				"6",
				"5",
				"4",
				"3",
				"2",
				"1"
			}
			t1.value8 = {
				"43",
				"42",
				"41",
				"150",
				"39",
				"38"
			}
			color39.PERK_SLOT_IDS = {
				Blades = t1.value3,
				Spears = {
					offense = t1.value6,
					defense = t1.value8,
					support = {
						"80",
						"79",
						"78",
						"77",
						"76",
						"75",
						"154",
						"73",
						"72",
						"71",
						"70"
					}
				}
			}
			color39 = value82.Skill
			t1.value6 = {
				"25",
				"24",
				"23",
				"22",
				"21",
				"20",
				"19",
				"18",
				"17",
				"16",
				"15",
				"14",
				"13",
				"12",
				"11",
				"10",
				"9",
				"8",
				"7",
				"6",
				"5",
				"4",
				"3",
				"2",
				"1"
			}
			t1.value8 = {
				"57",
				"56",
				"55",
				"54",
				"53",
				"52",
				"51",
				"50",
				"49",
				"48",
				"47",
				"46",
				"45",
				"44",
				"43",
				"42",
				"41",
				"40",
				"39",
				"38"
			}
			t1.value10 = {
				"69",
				"68",
				"67",
				"66",
				"65",
				"64",
				"63",
				"62",
				"61",
				"60",
				"59",
				"58",
				"45",
				"44",
				"43",
				"42",
				"41",
				"40",
				"39",
				"38"
			}
			t1.value12 = {
				"89",
				"88",
				"87",
				"86",
				"85",
				"84",
				"83",
				"82",
				"81",
				"80",
				"79",
				"78",
				"77",
				"76",
				"75",
				"74",
				"73",
				"72",
				"71",
				"70"
			}
			t1.value3 = {
				["Offense → Damage"] = {
					"37",
					"36",
					"35",
					"34",
					"33",
					"32",
					"31",
					"30",
					"29",
					"28",
					"27",
					"26",
					"13",
					"12",
					"11",
					"10",
					"9",
					"8",
					"7",
					"6",
					"5",
					"4",
					"3",
					"2",
					"1"
				},
				["Offense → Crit DMG"] = t1.value6,
				["Defense → Health"] = t1.value8,
				["Defense → Tank"] = t1.value10,
				["Support → Regen"] = t1.value12,
				["Support → Injury"] = {
					"98",
					"97",
					"96",
					"95",
					"94",
					"93",
					"92",
					"91",
					"90",
					"80",
					"79",
					"78",
					"77",
					"76",
					"75",
					"74",
					"73",
					"72",
					"71",
					"70"
				}
			}
			t1.value6 = {
				"149",
				"148",
				"147",
				"146",
				"145",
				"144",
				"143",
				"142",
				"141",
				"140",
				"139",
				"138",
				"125",
				"124",
				"123",
				"122",
				"121",
				"120",
				"119",
				"118",
				"117",
				"116",
				"115",
				"114",
				"113"
			}
			t1.value8 = {
				"137",
				"136",
				"135",
				"134",
				"133",
				"132",
				"131",
				"130",
				"129",
				"128",
				"127",
				"126",
				"125",
				"124",
				"123",
				"122",
				"121",
				"120",
				"119",
				"118",
				"117",
				"116",
				"115",
				"114",
				"113"
			}
			t1.value10 = {
				"57",
				"56",
				"55",
				"54",
				"53",
				"52",
				"51",
				"50",
				"49",
				"48",
				"47",
				"46",
				"45",
				"44",
				"43",
				"42",
				"41",
				"150",
				"39",
				"38"
			}
			t1.value12 = {
				"69",
				"68",
				"67",
				"66",
				"65",
				"64",
				"63",
				"62",
				"61",
				"60",
				"151",
				"58",
				"45",
				"44",
				"43",
				"42",
				"41",
				"150",
				"39",
				"38"
			}
			t1.value14 = {
				"89",
				"88",
				"87",
				"86",
				"85",
				"84",
				"83",
				"82",
				"81",
				"80",
				"79",
				"78",
				"77",
				"76",
				"75",
				"154",
				"73",
				"72",
				"71",
				"70"
			}
			color39.PATHS = {
				Blades = t1.value3,
				Spears = {
					["Offense → Damage"] = t1.value6,
					["Offense → Crit DMG"] = t1.value8,
					["Defense → Health"] = t1.value10,
					["Defense → Tank"] = t1.value12,
					["Support → Regen"] = t1.value14,
					["Support → Injury"] = {
						"98",
						"97",
						"96",
						"95",
						"94",
						"93",
						"92",
						"91",
						"90",
						"80",
						"79",
						"78",
						"77",
						"76",
						"75",
						"154",
						"73",
						"72",
						"71",
						"70"
					}
				}
			}

			local function v1578(p157)
				value82.Lobby.lastSkillStatus = p157
				value82.UI.setParagraph(value82.UI.paragraphs.skill, p157)
			end

			color39 = value82.Skill

			function t1.value2()
				local autoSkill = value82.Lobby.autoSkill
				local weapon = value82.Stats.weapon or "Blades"
				local Blades = value82.Skill.PERK_SLOT_IDS[weapon] or value82.Skill.PERK_SLOT_IDS.Blades
				local Blades2 = value82.Skill.PATHS[weapon] or value82.Skill.PATHS.Blades
				local t57

				if autoSkill.strategy == "Focus Defense First" then
					t57 = { autoSkill.defense, autoSkill.offense, autoSkill.support }
				elseif autoSkill.strategy == "Focus Support First" then
					t57 = { autoSkill.support, autoSkill.offense, autoSkill.defense }
				else
					t57 = { autoSkill.offense, autoSkill.defense, autoSkill.support }
				end

				local v1584, v1585, v1586 = ipairs(autoSkill.perkOrder)
				local t58 = {}

				while true do
					local v1588

					v1586, v1588 = v1584(v1585, v1586)

					if not v1586 then
						break
					end

					local v1589 = v1588:lower()

					if Blades[v1589] then
						t58[#t58 + 1] = {
							perkSlot = true,
							ids = Blades[v1589],
							label = "Perk Slot " .. v1588
						}
					end
				end

				for _, v in ipairs(t57) do
					t58[#t58 + 1] = v
				end

				return t58, Blades2
			end

			color39.strategyOrder = t1.value2
			color39 = value82.Skill

			function t1.value2(p158)
				local t59 = {}

				for _, v in ipairs(p158) do
					t59[#t59 + 1] = string.format("%q", v)
				end

				local v1595 = "{ " .. table.concat(t59, ", ") .. " }"
				local S_Equipment = value82.Actor.invokeMulti("S_Equipment", "Unlock", v1595, "        local data, sp, err = a, b, c\n        local unlocked = nil\n        if data and data.Slots and data.Current_Slot then\n            local slot = data.Slots[data.Current_Slot]\n            unlocked = slot and slot.Skills and slot.Skills.Unlocked\n        end\n        out = { success = data ~= nil, sp = sp, err = err, unlocked = unlocked }\n    ", 5)
				local value7 = t2.value7
				local ok

				if S_Equipment then
					ok = S_Equipment.ok
				else
					ok = S_Equipment
				end

				local v1599 = tostring(ok)
				local tostring_ = tostring
				local s13

				if S_Equipment then
					if S_Equipment.data and S_Equipment.data.success then
						s13 = "success"
					else
						local err = S_Equipment.data.err

						s13 = "fail err=" .. tostring(err)
					end
				else
					s13 = S_Equipment
				end

				value7("invokeUnlock: res.ok=" .. v1599 .. " res.data=" .. tostring_(s13) .. " argsExpr=" .. v1595)

				if not S_Equipment then
					return S_Equipment or nil
				end

				S_Equipment = S_Equipment.data

				return S_Equipment or nil
			end

			color39.invokeUnlock = t1.value2
			color39 = value82.Skill

			function t1.value2(p159)
				local v1603, v1604, v1605 = ipairs(p159)
				local t60 = {}

				while true do
					local v1607

					v1605, v1607 = v1603(v1604, v1605)

					if not v1605 then
						break
					end

					t60[v1605] = v1607
				end

				while #t60 > 0 do
					local v1608 = value82.Skill.invokeUnlock(t60)
					local value7 = t2.value7
					local s14 = "doUpgrade: ids="
					local v1611 = #t60
					local s15 = " r="
					local tostring_ = tostring
					local s16

					if v1608 then
						if v1608.success then
							s16 = "ok"
						else
							local err = v1608.err

							s16 = "fail err=" .. tostring(err)
						end
					else
						s16 = v1608
					end

					value7(s14 .. v1611 .. s15 .. tostring_(s16 or "nil"))

					if v1608 == nil then
						return false
					end

					if v1608.success then
						return true, v1608.sp
					end

					if v1608.err == nil then
						return false
					end

					table.remove(t60, 1)
					task.wait(0.5)
				end

				return false
			end

			color39.doUpgrade = t1.value2
			color39 = value82.Tasks
			t1.value2 = value82.Task.new
			t1.value3 = t1.value2("AutoSkill", function(p160)
				v180("AutoSkill")

				if isInGame() then
					v1578("Lobby only idle.")
					value82.Lobby.busyLobby.AutoSkill = nil

					return
				end

				local t61 = {}

				local function v1617(p161)
					if type(p161) == "table" then
						for _, v in pairs(p161) do
							t61[tostring(v)] = true
						end
					end
				end

				v1578("Loading unlocked skills...")

				if not (value82.Stats.unlockedSkills and next(value82.Stats.unlockedSkills)) then
					value82.DataCopy.fetch()
				end

				if type(value82.Stats.unlockedSkills) == "table" then
					for k in pairs(value82.Stats.unlockedSkills) do
						t61[tostring(k)] = true
					end
				end

				v1578("Running " .. value82.Lobby.autoSkill.strategy)

				local v1621, v1622 = value82.Skill.strategyOrder()
				local t62 = {}
				local t63 = {}

				for _, v in ipairs(v1621) do
					local perkSlot

					if type(v) == "table" then
						perkSlot = v.perkSlot
					else
						perkSlot = false
					end

					if perkSlot then
						t62[#t62 + 1] = v
					else
						t63[#t63 + 1] = v
					end
				end

				local value7 = t2.value7
				local weapon = value82.Stats.weapon

				value7("AutoSkill: weapon=" .. tostring(weapon) .. " unlockedSkills=" .. tostring(value82.Stats.unlockedSkills and #value82.Stats.unlockedSkills or "nil(dict?)") .. " pathEntries=" .. #t63 .. " perkEntries=" .. #t62)

				for _, v in ipairs(t63) do
					local v1632

					if v1622 then
						v1632 = v1622[v]
					else
						v1632 = v1622
					end

					t2.value7("  path=" .. tostring(v) .. " ids=" .. tostring(v1632 and #v1632 or v1632 or "nil"))
				end

				local v1633 = value82.Lobby.autoSkill.strategy == "Balanced"

				if #t62 > 0 then
					local v1634, v1635, v1636 = ipairs(t62)
					local t64 = {}
					local t65 = {}

					while true do
						local v1639

						v1636, v1639 = v1634(v1635, v1636)

						if not v1636 then
							break
						end

						local n35 = 0

						for i = #v1639.ids, 1, -1 do
							if not t61[v1639.ids[i]] then
								n35 = i

								break
							end
						end

						if n35 == 0 then
							t65[v1639.label] = true
						else
							t64[v1639.label] = n35
						end
					end

					while p160.enabled do
						if isInGame() then
							p160.enabled = false

							return
						end

						local v1642, v1643, v1644 = ipairs(t62)
						local v1645 = false

						while true do
							local v1646

							v1644, v1646 = v1642(v1643, v1644)

							if not v1644 then
								break
							end

							local enabled = not t65[v1646.label] and (p160.enabled and t64[v1646.label])

							if enabled then
								enabled = t64[v1646.label] >= 1
							end

							if enabled then
								local t66 = { v1646.ids[t64[v1646.label]] }

								v1578("Perk: " .. v1646.label .. " [" .. t66[1] .. "]")

								local v1649 = value82.Skill.invokeUnlock(t66)

								if v1649 == nil then
									p160.enabled = false

									break
								end

								if v1649.success then
									v1617(v1649.unlocked)
								end

								t64[v1646.label] = t64[v1646.label] - 1

								if t64[v1646.label] < 1 then
									t65[v1646.label] = true
								end

								task.wait(0.6)
								v1645 = true
							else
								t65[v1646.label] = true
							end
						end

						local v1650 = true

						for _, v in ipairs(t62) do
							if not t65[v.label] then
								v1650 = false

								break
							end
						end

						if v1650 or not v1645 then
							break
						end
					end
				end

				if not v1633 then
					for _, v in ipairs(t63) do
						if not p160.enabled then
							v1578("Idle.")
							notify("Auto Skill", "Skill upgrade complete!", 5, "check")
							value82.Lobby.busyLobby.AutoSkill = nil

							return
						end

						local v1655 = v1622[v]

						t2.value7("AutoSkill focus: path=" .. v .. " ids=" .. tostring(v1655 and #v1655 or v1655 or "nil"))
						v1578(v)

						local v1656 = value82.Skill.doUpgrade(v1655)

						t2.value7("AutoSkill focus: doUpgrade=" .. tostring(v1656))

						if not v1656 then
							v1578("Idle.")
							notify("Auto Skill", "Skill upgrade complete!", 5, "check")
							value82.Lobby.busyLobby.AutoSkill = nil

							return
						end

						task.wait(1)
					end

					v1578("Idle.")
					notify("Auto Skill", "Skill upgrade complete!", 5, "check")
					value82.Lobby.busyLobby.AutoSkill = nil

					return
				end

				local v1657, v1658, v1659 = ipairs(t63)
				local t67 = {}
				local t68 = {}

				while true do
					local v1662

					v1659, v1662 = v1657(v1658, v1659)

					if not v1659 then
						break
					end

					local v1663 = v1622[v1662]
					local n36 = 0

					for i = #v1663, 1, -1 do
						if not t61[v1663[i]] then
							n36 = i

							break
						end
					end

					t2.value7("AutoSkill balanced: path=" .. v1662 .. " start=" .. n36 .. "/" .. #v1663)

					if n36 == 0 then
						t68[v1662] = true
					else
						t67[v1662] = n36
					end
				end

				while true do
					if not (p160.enabled and not isInGame()) then
						v1578("Idle.")
						notify("Auto Skill", "Skill upgrade complete!", 5, "check")
						value82.Lobby.busyLobby.AutoSkill = nil

						return
					end

					local v1666, v1667, v1668 = ipairs(t63)
					local v1669 = false

					while true do
						local v1670

						v1668, v1670 = v1666(v1667, v1668)

						if not v1668 then
							break
						end

						local enabled = not t68[v1670] and (p160.enabled and t67[v1670])

						if enabled then
							enabled = t67[v1670] >= 1
						end

						if enabled then
							local t69 = { v1622[v1670][t67[v1670]] }

							v1578("Balanced: " .. v1670 .. " [" .. t69[1] .. "]")

							local v1673 = value82.Skill.invokeUnlock(t69)

							if v1673 == nil then
								p160.enabled = false

								break
							end

							if v1673.success then
								v1617(v1673.unlocked)
								task.wait(0.6)
							end

							t67[v1670] = t67[v1670] - 1

							if t67[v1670] < 1 then
								t68[v1670] = true
								v1669 = true
							else
								v1669 = true
							end
						else
							t68[v1670] = true
						end
					end

					local v1674 = true

					for _, v in ipairs(t63) do
						if not t68[v] then
							v1674 = false

							break
						end
					end

					if v1674 or not v1669 then
						v1578("Idle.")
						notify("Auto Skill", "Skill upgrade complete!", 5, "check")
						value82.Lobby.busyLobby.AutoSkill = nil

						return
					end
				end
			end)
			color39.autoSkill = t1.value3
			value82.Family = {}
			value82.Family.EPIC = {
				"Any",
				"GALLIARD",
				"ZOE",
				"LEONHART",
				"TYBUR",
				"KSAVER",
				"BRAUN",
				"FINGER",
				"ARLERT"
			}
			value82.Family.LEGEND = {
				"Any",
				"YEAGER",
				"ACKERMAN",
				"REISS"
			}
			value82.Family.MYTHIC = { "Any", "FRITZ", "HELOS" }
			value82.Family.webhook = ""
			value82.Family.autoStore = false
			color39 = value82.Family

			function t1.value2()
				local webhook = value82.Family.webhook

				if not (webhook == nil and true or webhook == "") then
					return webhook
				end

				local FamilyWebhook = value82.Util.flagValue("FamilyWebhook")

				webhook = type(FamilyWebhook) == "string" and FamilyWebhook:match("^%s*(.-)%s*$") or ""
				value82.Family.webhook = webhook

				return webhook
			end

			color39.url = t1.value2
			color39 = value82.Family

			function t1.value2(p162)
				local v1679 = value82.Family.url()

				if not v1679 or v1679 == "" then
					return
				end

				local Name = t2.value3.Name
				local v1681 = "||" .. tostring(Name) .. "||"
				local Http = t2.value1.Http
				local t70 = {
					username = "Mahmut Hub",
					avatar_url = "https://i.imgur.com/KrAE1vB.png",
					embeds = {
						{
							title = "Family Found!",
							description = string.format("%s rolled **%s**", v1681, p162),
							color = 16098851,
							fields = {
								{
									name = "Player",
									value = v1681,
									inline = true
								},
								{
									name = "Family",
									value = p162,
									inline = true
								}
							}
						}
					}
				}
				local v1684 = Http.JSONEncode(Http, t70)

				local function v1685()
					local request_ = syn and syn.request or (http and http.request or request)

					if request_ then
						request_({
							Url = v1679,
							Method = "POST",
							Headers = {
								["Content-Type"] = "application/json"
							},
							Body = v1684
						})
					else
						t2.value7("Family.sendWebhook: no request() available on this executor")
					end
				end

				local t71 = { pcall(v1685) }
				local v1688 = t71[2]

				if t71[1] then
					return
				end

				t2.value7("Family.sendWebhook error:", v1688)
			end

			color39.sendWebhook = t1.value2
			value82.StatsWebhook = {
				webhook = "",
				lastEvent = {
					level = nil,
					prestige = nil,
					shadowBan = nil,
					slot = nil
				}
			}
			color39 = value82.StatsWebhook

			function t1.value2()
				local webhook = value82.StatsWebhook.webhook

				if not (webhook == nil and true or webhook == "") then
					return webhook
				end

				local StatsWebhook = value82.Util.flagValue("StatsWebhook")

				webhook = type(StatsWebhook) == "string" and StatsWebhook:match("^%s*(.-)%s*$") or ""
				value82.StatsWebhook.webhook = webhook

				return webhook
			end

			color39.url = t1.value2
			color39 = value82.StatsWebhook

			function t1.value2()
				local Name = t2.value3.Name

				return "||" .. tostring(Name) .. "||"
			end

			color39.userTag = t1.value2
			color39 = value82.StatsWebhook

			function t1.value2(p163, p164, p165, p166, p167)
				local v1692 = value82.StatsWebhook.url()

				if not v1692 or v1692 == "" then
					return
				end

				local function v1693()
					local t72 = {
						title = p163,
						description = p164,
						color = p165 or 5793266,
						fields = p166 or {},
						footer = {
							text = "Mahmut Hub"
						}
					}

					if p167.thumbnail then
						t72.thumbnail = {
							url = p167.thumbnail
						}
					end

					local t73 = {
						username = "Mahmut Hub",
						avatar_url = "https://i.imgur.com/KrAE1vB.png",
						embeds = { t72 }
					}

					if not p167.mention then
						v1751 = t2.value1.Http:JSONEncode(t73)
						v1752 = syn and syn.request or (http and http.request or request)

						if v1752 then
							v1752({
								Url = v1692,
								Method = "POST",
								Headers = {
									["Content-Type"] = "application/json"
								},
								Body = v1751
							})
						else
							t2.value7("StatsWebhook.send: no request() available on this executor")
						end

						return
					end

					t73.content = "@everyone"
					t73.allowed_mentions = {
						parse = { "everyone" }
					}

					local json = t2.value1.Http:JSONEncode(t73)
					local request_ = syn and syn.request or (http and http.request or request)

					if request_ then
						request_({
							Url = v1692,
							Method = "POST",
							Headers = {
								["Content-Type"] = "application/json"
							},
							Body = json
						})
					else
						t2.value7("StatsWebhook.send: no request() available on this executor")
					end
				end

				local _ = p167 or {}
				local t74 = { pcall(v1693) }
				local v1700 = t74[2]

				if t74[1] then
					return
				end

				t2.value7("StatsWebhook.send error:", v1700)
			end

			color39.send = t1.value2

			function t1.value1(p168)
				local v1701 = tonumber(p168) or 0
				local v1702 = math.floor(v1701)

				return tostring(v1702):reverse():gsub("(%d%d%d)", "%1,"):reverse():gsub("^,", "")
			end
			function t1.value2(p169)
				local v1703 = tonumber(p169) or 0
				local v1704 = math.floor(v1703)
				local v1705 = math.max(0, v1704)
				local format = string.format
				local v1707 = v1705 / 60

				return format("%02d:%02d", math.floor(v1707), v1705 % 60)
			end

			local value1 = t1.value1
			local value2 = t1.value2

			t1.value2 = value82.StatsWebhook

			function t1.value4()
				local t75 = {}
				local v1711 = value82.Prestige.snapshot()
				local currentSlot = value82.Stats.currentSlot or "?"

				t75[#t75 + 1] = {
					name = "Player",
					value = value82.StatsWebhook.userTag(),
					inline = true
				}

				if not v1711 then
					v1774 = #t75 + 1
					v1775 = value82.Stats.streak or 0
					t75[v1774] = {
						name = "Kill Streak",
						value = tostring(v1775),
						inline = true
					}
					v1776 = value82.Stats.shadowBan and ("⚠️ BANNED" .. value82.Stats.disabledReason and " (" .. value82.Stats.disabledReason .. ")" or "") or "✅ Clean"
					t75[#t75 + 1] = {
						name = "Shadow Ban",
						value = v1776,
						inline = true
					}

					return t75
				end

				t75[#t75 + 1] = {
					name = "Slot",
					value = tostring(currentSlot),
					inline = true
				}

				local v1713 = #t75 + 1
				local level = v1711.level or 0

				t75[v1713] = {
					name = "Level",
					value = tostring(level),
					inline = true
				}

				local v1715 = #t75 + 1
				local prestige = v1711.prestige or 0

				t75[v1715] = {
					name = "Prestige",
					value = "P" .. tostring(prestige),
					inline = true
				}

				local v1717 = #t75 + 1
				local streak = value82.Stats.streak or 0

				t75[v1717] = {
					name = "Kill Streak",
					value = tostring(streak),
					inline = true
				}

				local v1719 = value82.Stats.shadowBan and ("⚠️ BANNED" .. value82.Stats.disabledReason and " (" .. value82.Stats.disabledReason .. ")" or "") or "✅ Clean"

				t75[#t75 + 1] = {
					name = "Shadow Ban",
					value = v1719,
					inline = true
				}

				return t75
			end

			t1.value2.progressFields = t1.value4
			t1.value2 = value82.StatsWebhook

			function t1.value4(p170, p171, p172)
				if value82.StatsWebhook.url() == "" then
					return
				end

				local v1720 = p172 or {}
				local v1721 = value82.Prestige.snapshot()
				local getexecutorname_ = identifyexecutor and select(1, identifyexecutor()) or (getexecutorname and getexecutorname() or "Unknown")
				local v1723 = value82.Stats.shadowBan and ("⚠️ Yes" .. value82.Stats.disabledReason and " (" .. value82.Stats.disabledReason .. ")" or "") or "✅ No"
				local v1724 = value82
				local v1725 = (value82.Stats.MissionsCompleted or 0) + (v1724.Stats.RaidsCompleted or 0) + (value82.Stats.WavesCompleted or 0)
				local t76 = {
					[#v1786 + 1] = {
						name = "👤 Account",
						value = string.format("**User:** %s\n**Executor:** %s\n**Games Played:** %s\n**Shadow Banned:** %s", value82.StatsWebhook.userTag(), tostring(getexecutorname_), value1(v1725), v1723),
						inline = true
					}
				}
				local v1727 = #t76 + 1
				local format = string.format
				local s17 = "**Level:** %s\n**Prestige:** P%s\n**Best Streak:** %s"
				local v1730

				if v1721 then
					local level = v1721.level or 0

					v1730 = tostring(level) or "?"
				else
					v1730 = "?"
				end

				local v1732

				if v1721 then
					local prestige = v1721.prestige or 0

					v1732 = tostring(prestige) or "0"
				else
					v1732 = "0"
				end

				t76[v1727] = {
					name = "📈 Progression",
					value = format(s17, v1730, v1732, value1(value82.Stats.streak or 0)),
					inline = true
				}

				local t77 = {}
				local seconds = v1720.seconds

				if seconds then
					seconds = v1720.seconds > 0
				end

				if seconds then
					t77[#t77 + 1] = string.format("**Time:** %s", value2(v1720.seconds))
				end

				if v1720.kills ~= nil then
					t77[#t77 + 1] = string.format("**Titans Killed:** %s", value1(v1720.kills))
				end

				if v1720.damage ~= nil then
					t77[#t77 + 1] = string.format("**Damage:** %s", value1(v1720.damage))
				end

				if v1720.crits ~= nil then
					t77[#t77 + 1] = string.format("**Crits:** %s", value1(v1720.crits))
				end

				local difficulty = v1720.difficulty

				if difficulty then
					difficulty = v1720.difficulty ~= ""
				end

				if difficulty then
					local v1737 = #t77 + 1
					local format2 = string.format
					local difficulty2 = v1720.difficulty

					t77[v1737] = format2("**Difficulty:** %s", (tostring(difficulty2)))
				end

				local objective = v1720.objective

				if objective then
					objective = v1720.objective ~= ""
				end

				if objective then
					local v1741 = #t77 + 1
					local format2 = string.format
					local objective2 = v1720.objective

					t77[v1741] = format2("**Objective:** %s", (tostring(objective2)))
				end

				if #t77 > 0 then
					t76[#t76 + 1] = {
						name = "⚔️ Combat",
						value = table.concat(t77, "\n"),
						inline = true
					}
				end

				local rewards = v1720.rewards

				if rewards then
					rewards = next(v1720.rewards)
				end

				if rewards then
					local t78 = {}
					local t79 = {}

					for _, v in ipairs({
						"Gold",
						"Gems",
						"XP",
						"Canes"
					}) do
						if v1720.rewards[v] then
							t78[#t78 + 1] = string.format("**%s** × %s", v, value1(v1720.rewards[v]))
							t79[v] = true
						end
					end

					local v1749, v1750, v1753 = pairs(v1720.rewards)
					local t80 = {}

					while true do
						v1753 = v1749(v1750, v1753)

						if not v1753 then
							break
						end

						if not t79[v1753] then
							t80[#t80 + 1] = v1753
						end
					end

					table.sort(t80)

					for _, v in ipairs(t80) do
						t78[#t78 + 1] = string.format("**%s** × %s", v, value1(v1720.rewards[v]))
					end

					t76[#t76 + 1] = {
						name = "🎁 Rewards This Run",
						value = table.concat(t78, "\n"),
						inline = true
					}
				end

				local drops = v1720.drops

				if drops then
					drops = #v1720.drops > 0
				end

				if drops then
					local t81 = {}

					for _, drop in ipairs(v1720.drops) do
						t81[#t81 + 1] = "✨ " .. tostring(drop)
					end

					t76[#t76 + 1] = {
						name = "✨ Special Drops",
						value = table.concat(t81, "\n"),
						inline = true
					}
				end

				local function v1759(p173)
					return value1(value82.Stats[p173] or 0)
				end

				t76[#t76 + 1] = {
					name = "📜 Lifetime Stats",
					value = string.format("🗺️ Missions `%s` · ⚔️ Raids `%s` · 🌊 Waves `%s` · 💀 Kills `%s`\n💰 Gold `%s` · 💎 Gems `%s` · ✨ EXP `%s` · 🍬 Canes `%s`\n🟣 Epic `%s` · 🟠 Legendary `%s` · 🔴 Mythic `%s`\n🧪 Serums `%s` · 🔷 Shards `%s` · 📜 Scrolls `%s` · 📦 Drops `%s`", v1759("MissionsCompleted"), v1759("RaidsCompleted"), v1759("WavesCompleted"), v1759("titanKills"), v1759("GoldCollected"), v1759("GemsCollected"), v1759("ExpCollected"), v1759("CanesCollected"), v1759("EpicPerksCollected"), v1759("LegendaryPerks"), v1759("MythicPerks"), v1759("TitanSerums"), v1759("TitanShards"), v1759("PrestigeScrolls"), v1759("ItemDrops")),
					inline = false
				}

				local v1760 = p171 and " — " .. tostring(p171) or ""
				local drops2 = v1720.drops
				local v1762, v1763, v1764

				if not drops2 then
					if p170 == "win" then
						v1762 = "✅ Run Completed" .. v1760
						v1763 = drops2 and 15844367 or 3066993
						v1764 = drops2 and "🔴 **Rare Drop Alert!**\nA rare item was obtained this run — see **Special Drops**." or drops2 or string.format("%s finished a run.", value82.StatsWebhook.userTag())
					elseif p170 == "fail" then
						v1762 = "❌ Run Failed" .. v1760
						v1764 = string.format("%s failed a run.", value82.StatsWebhook.userTag())
						v1763 = 15158332
					else
						v1764 = string.format("Manual stats report for %s.", value82.StatsWebhook.userTag())
						v1762 = "📊 Stats Report"
						v1763 = 5793266
					end

					v1823 = {
						thumbnail = string.format("https://www.roblox.com/headshot-thumbnail/image?userId=%d&width=150&height=150&format=png", t2.value3.UserId),
						mention = drops2
					}
					value82.StatsWebhook.send(v1762, v1764, v1763, t76, v1823)

					return
				end

				drops2 = #v1720.drops > 0

				if p170 == "win" then
					v1762 = "✅ Run Completed" .. v1760
					v1763 = drops2 and 15844367 or 3066993
					v1764 = drops2 and "🔴 **Rare Drop Alert!**\nA rare item was obtained this run — see **Special Drops**." or drops2 or string.format("%s finished a run.", value82.StatsWebhook.userTag())
				elseif p170 == "fail" then
					v1762 = "❌ Run Failed" .. v1760
					v1764 = string.format("%s failed a run.", value82.StatsWebhook.userTag())
					v1763 = 15158332
				else
					v1764 = string.format("Manual stats report for %s.", value82.StatsWebhook.userTag())
					v1762 = "📊 Stats Report"
					v1763 = 5793266
				end

				local t82 = {
					thumbnail = string.format("https://www.roblox.com/headshot-thumbnail/image?userId=%d&width=150&height=150&format=png", t2.value3.UserId),
					mention = drops2
				}

				value82.StatsWebhook.send(v1762, v1764, v1763, t76, t82)
			end

			t1.value2.sessionReport = t1.value4
			t1.value2 = value82.StatsWebhook

			function t1.value4()
				if value82.StatsWebhook.url() == "" then
					return
				end

				local lastEvent = value82.StatsWebhook.lastEvent
				local prestige = value82.Prestige.snapshot()
				local currentSlot = value82.Stats.currentSlot

				if currentSlot == lastEvent.slot then
					if prestige then
						local prestige2 = lastEvent.prestige ~= nil and prestige.prestige

						if prestige2 then
							prestige2 = prestige.prestige > lastEvent.prestige
						end

						if prestige2 then
							value82.StatsWebhook.send("Prestige Up!", string.format("%s reached **P%d** (was P%d).", value82.StatsWebhook.userTag(), prestige.prestige, lastEvent.prestige), 15844367, value82.StatsWebhook.progressFields(), {
								mention = true
							})
						else
							local level = lastEvent.level ~= nil and prestige.level

							if level then
								level = prestige.level > lastEvent.level
							end

							if level then
								value82.StatsWebhook.send("Level Up!", string.format("%s is now **Level %d** (was %d).", value82.StatsWebhook.userTag(), prestige.level, lastEvent.level), 3447003, value82.StatsWebhook.progressFields())
							end
						end

						lastEvent.level = prestige.level
						lastEvent.prestige = prestige.prestige
					end

					local v1771

					if lastEvent.shadowBan == true then
						v1771 = false
					else
						v1771 = value82.Stats.shadowBan == true
					end

					if not v1771 then
						lastEvent.shadowBan = value82.Stats.shadowBan

						return
					end

					value82.StatsWebhook.send("⚠️ Shadow Ban Detected!", string.format("%s is shadow-banned%s.", value82.StatsWebhook.userTag(), value82.Stats.disabledReason and " — " .. value82.Stats.disabledReason or ""), 15158332, value82.StatsWebhook.progressFields(), {
						mention = true
					})
					lastEvent.shadowBan = value82.Stats.shadowBan
				else
					lastEvent.slot = currentSlot

					local level

					if prestige then
						level = prestige.level
					else
						level = prestige
					end

					lastEvent.level = level

					if not prestige then
						lastEvent.prestige = prestige
						lastEvent.shadowBan = value82.Stats.shadowBan

						return
					end

					prestige = prestige.prestige
					lastEvent.prestige = prestige
					lastEvent.shadowBan = value82.Stats.shadowBan
				end
			end

			t1.value2.checkEvents = t1.value4

			local function v1773(p174)
				local t83 = {}

				if type(p174) == "table" then
					for k, v in pairs(p174) do
						local v1777 = type(k) == "number" and v and v or k

						if type(v1777) == "string" then
							t83[#t83 + 1] = v1777
						end
					end

					return t83
				end

				if type(p174) ~= "string" then
					return t83
				end

				t83[1] = p174

				return t83
			end

			t1.value3 = value82.Family

			function t1.value3.updateTargets()
				local targets = {}

				local function v1779(p175, p176)
					local v1780, v1781, v1782 = ipairs(p175)
					local v1783 = false

					while true do
						local v1784

						v1782, v1784 = v1780(v1781, v1782)

						if not v1782 then
							break
						end

						v1783 = v1784 == "Any" and true or v1783
					end

					local v1785

					if not v1783 then
						for _, v in ipairs(p175) do
							if v == "Any" then
								v1785 = false
							else
								v1785 = not table.find(targets, v)
							end

							if v1785 then
								targets[#targets + 1] = v
							end
						end

						return
					end

					p175 = p176 or p175

					for _, v in ipairs(p175) do
						if v == "Any" then
							v1785 = false
						else
							v1785 = not table.find(targets, v)
						end

						if v1785 then
							targets[#targets + 1] = v
						end
					end
				end

				v1779(value82.Lobby.family.epics, value82.Family.EPIC)
				v1779(value82.Lobby.family.legends, value82.Family.LEGEND)
				v1779(value82.Lobby.family.mythics, value82.Family.MYTHIC)
				value82.Lobby.family.targets = targets
			end

			t1.value3 = value82.Family

			function t1.value3.current()
				local match = value82.Util.safeIndex(t2.value4, "Interface", "Customisation", "Family", "Family", "Title")

				if not match then
					return match
				end

				match = match.Text:match("^(%S+)")

				return match
			end

			t1.value3 = value82.Family

			function t1.value3.spin()
				local v1791 = value82.Util.safeIndex(t2.value4, "Interface", "Customisation", "Family", "Buttons_2", "Roll")

				if not v1791 then
					return
				end

				t2.value1.GuiService.SelectedObject = v1791
				task.wait(0.1)
				t2.value1.VIM:SendKeyEvent(true, Enum.KeyCode.Return, false, game)
				task.wait(0.1)
				t2.value1.VIM:SendKeyEvent(false, Enum.KeyCode.Return, false, game)
				task.wait(0.6)

				local v1792 = value82.Util.safeIndex(t2.value4, "Interface", "Warning", "Prompt", "Main", "Yes")
				local Visible = v1792 and value82.Util.safeIndex(t2.value4, "Interface", "Warning")

				if Visible then
					Visible = t2.value4.Interface.Warning.Visible
				end

				if not Visible then
					return
				end

				t2.value1.GuiService.SelectedObject = v1792
				task.wait(0.1)
				t2.value1.VIM:SendKeyEvent(true, Enum.KeyCode.Return, false, game)
				task.wait(0.1)
				t2.value1.VIM:SendKeyEvent(false, Enum.KeyCode.Return, false, game)
			end

			t1.value3 = value82.Family

			function t1.value3.store()
				local v1794 = value82.Util.safeIndex(t2.value4, "Interface", "Customisation", "Family", "Buttons_2", "Store")

				if not v1794 then
					return false
				end

				t2.value1.GuiService.SelectedObject = v1794
				task.wait(0.1)
				t2.value1.VIM:SendKeyEvent(true, Enum.KeyCode.Return, false, game)
				task.wait(0.1)
				t2.value1.VIM:SendKeyEvent(false, Enum.KeyCode.Return, false, game)
				task.wait(0.6)

				local v1795 = value82.Util.safeIndex(t2.value4, "Interface", "Warning")
				local v1796

				if v1795 then
					v1796 = value82.Util.safeIndex(v1795, "Prompt", "Main", "Yes")
				else
					v1796 = v1795
				end

				local Visible

				if v1796 then
					Visible = v1795.Visible
				else
					Visible = v1796
				end

				if not Visible then
					return true
				end

				t2.value1.GuiService.SelectedObject = v1796
				task.wait(0.1)
				t2.value1.VIM:SendKeyEvent(true, Enum.KeyCode.Return, false, game)
				task.wait(0.1)
				t2.value1.VIM:SendKeyEvent(false, Enum.KeyCode.Return, false, game)
				task.wait(0.3)

				return true
			end
			function t1.value4(p177)
				value82.UI.setParagraph(value82.UI.paragraphs.family, p177)
			end

			local function v1798()
				local v1799 = value82.Util.safeIndex(t2.value4, "Interface", "Customisation", "Family")
				local u1800 = false

				local function v1801()
					local v1802 = v1799

					if not v1802 then
						u1800 = v1802

						return
					end

					v1802 = v1799.Visible == true
					u1800 = v1802
				end

				pcall(v1801)

				return u1800
			end

			local value4 = t1.value4

			color39 = value82.Tasks
			t1.value6 = value82.Task.new

			function t1.value9(p178)
				if #value82.Lobby.family.targets == 0 then
					value4("[!] Select at least 1 family!")
					notify("Family Spinner", "Select a family first!", 3, "skull")
					p178.enabled = false

					return
				end

				value4("[~] Waiting for Family panel...")

				local v1804 = tick() + 15

				while true do
					local enabled = p178.enabled

					if enabled then
						enabled = not v1798()
					end

					if not enabled then
						if not p178.enabled then
							return
						end

						local v1806 = value82.Family.current()
						local v1807

						if v1806 then
							v1807 = table.find(value82.Lobby.family.targets, v1806)
						else
							v1807 = v1806
						end

						if v1807 then
							task.spawn(function()
								value82.Family.sendWebhook(v1806)
							end)

							if not value82.Family.autoStore then
								t2.value1.GuiService.SelectedObject = nil
								value4("[OK] Already on target: " .. v1806)
								notify("Family Spinner", "Already on: " .. v1806 .. "!", 5, "check-circle")
								p178.enabled = false

								return
							end

							value4("[~] Already on target: " .. v1806 .. " — storing...")
							notify("Family Spinner", "Already on: " .. v1806 .. " storing!", 4, "check-circle")

							if not value82.Family.store() then
								value4("[!] Storage full — stopping.")
								notify("Family Spinner", "Storage full! Stopped rolling.", 5, "x-circle")
								p178.enabled = false

								return
							end

							value4("[~] Stored " .. v1806 .. " spinning for more...")
							notify("Family Spinner", "Stored " .. v1806 .. " spinning for more!", 3, "refresh-cw")
						end

						value4("[~] Spinning...")
						value82.Family.spin()

						while p178.enabled do
							task.wait(4)

							if not v1798() then
								value4("[||] Panel closed — stopped.")
								notify("Family Spinner", "Family panel closed stopping spin.", 3, "x-circle")
								p178.enabled = false

								return
							end

							local v1808 = value82.Family.current()
							local v1809

							if v1808 then
								v1809 = table.find(value82.Lobby.family.targets, v1808)
							else
								v1809 = v1808
							end

							if v1809 then
								t2.value1.GuiService.SelectedObject = nil
								value4("[OK] Found: " .. v1808)
								notify("Family Spinner", "Found: " .. v1808 .. "!", 5, "check-circle")
								task.spawn(function()
									value82.Family.sendWebhook(v1808)
								end)

								if not value82.Family.autoStore then
									p178.enabled = false

									return
								end

								value4("[~] Storing " .. v1808 .. " then spinning for more...")

								if not value82.Family.store() then
									value4("[!] Storage full — stopping.")
									notify("Family Spinner", "Storage full! Stopped rolling.", 5, "x-circle")
									p178.enabled = false

									return
								end

								value4("[~] Stored " .. v1808 .. " spinning for more...")
								notify("Family Spinner", "Stored " .. v1808 .. " spinning for more!", 3, "refresh-cw")
								value82.Family.spin()
							elseif p178.enabled then
								value82.Family.spin()
								value4("[~] Spinning... (last: " .. (v1808 or "?") .. ")")
							end
						end

						return
					end

					if v1804 < tick() then
						value4("[!] Family panel not visible — open Customisation first")
						notify("Family Spinner", "Open the Family panel first!", 4, "x-circle")
						p178.enabled = false

						return
					end

					task.wait(0.5)
				end
			end

			t1.value7 = t1.value6("FamilySpin", t1.value9)
			color39.familySpin = t1.value7

			function t1.value5()
				return game.PlaceId == value82.PLACE.Lobby
			end

			local value5 = t1.value5

			t1.value6 = value82.Lobby

			function t1.value8(p179)
				local v1811 = tick() + (p179 or 60)

				while true do
					local v1812

					if tick() < v1811 then
						v1812 = game.PlaceId == value82.PLACE.Lobby
					else
						v1812 = false
					end

					if not v1812 then
						return false
					end

					local PlayerGui = t2.value3:FindFirstChild("PlayerGui")
					local Interface

					if PlayerGui then
						Interface = PlayerGui:FindFirstChild("Interface")
					else
						Interface = PlayerGui
					end

					if PlayerGui then
						PlayerGui = PlayerGui:FindFirstChild("Fullscreen")
					end

					if PlayerGui then
						PlayerGui = PlayerGui:FindFirstChild("Loading_Screen")
					end

					if Interface and not PlayerGui or not PlayerGui.Visible then
						return true
					end

					task.wait(1)
				end
			end

			t1.value6.waitUI = t1.value8
			t1.value6 = value82.Lobby.waitUI

			function t1.value8()
				if not value5() then
					return
				end

				local sched = value82.Lobby.sched

				if sched.prestige then
					local autoPrestige = value82.Tasks.autoPrestige

					if not value82.Lobby.restoring and (value5() and not autoPrestige:isRunning()) then
						t2.value7("IndependentLayer: start " .. autoPrestige.name)
						autoPrestige:start()
					end
				end

				if sched.skill then
					local autoSkill = value82.Tasks.autoSkill

					if not value82.Lobby.restoring and (value5() and not autoSkill:isRunning()) then
						t2.value7("IndependentLayer: start " .. autoSkill.name)
						autoSkill:start()
					end
				end

				if sched.gear then
					local autoUpgrade = value82.Tasks.autoUpgrade

					if not value82.Lobby.restoring and (value5() and not autoUpgrade:isRunning()) then
						t2.value7("IndependentLayer: start " .. autoUpgrade.name)
						autoUpgrade:start()
					end
				end

				if sched.mission then
					local autoCreate = value82.Tasks.autoCreate

					if not value82.Lobby.restoring and (value5() and not autoCreate:isRunning()) then
						t2.value7("IndependentLayer: start " .. autoCreate.name)
						autoCreate:start()
					end
				end

				if sched.raid then
					local autoRaid = value82.Tasks.autoRaid

					if not value82.Lobby.restoring and (value5() and not autoRaid:isRunning()) then
						t2.value7("IndependentLayer: start " .. autoRaid.name)
						autoRaid:start()
					end
				end

				if sched.wave then
					local autoWave = value82.Tasks.autoWave

					if not value82.Lobby.restoring and (value5() and not autoWave:isRunning()) then
						t2.value7("IndependentLayer: start " .. autoWave.name)
						autoWave:start()
					end
				end

				if sched.deletePerks then
					local autoDeletePerks = value82.Tasks.autoDeletePerks

					if not value82.Lobby.restoring and (value5() and not autoDeletePerks:isRunning()) then
						t2.value7("IndependentLayer: start " .. autoDeletePerks.name)
						autoDeletePerks:start()
					end
				end

				if sched.openCrates then
					local autoOpenCrates = value82.Tasks.autoOpenCrates

					if not value82.Lobby.restoring and (value5() and not autoOpenCrates:isRunning()) then
						t2.value7("IndependentLayer: start " .. autoOpenCrates.name)
						autoOpenCrates:start()
					end
				end

				if not sched.claimAchievements then
					return
				end

				local autoClaimAchievements = value82.Tasks.autoClaimAchievements

				if value82.Lobby.restoring then
					return
				end

				if not value5() then
					return
				end

				if autoClaimAchievements:isRunning() then
					return
				end

				t2.value7("IndependentLayer: start " .. autoClaimAchievements.name)
				autoClaimAchievements:start()
			end

			local value6 = t1.value6
			local value83 = t1.value8

			t1.value8 = value82
			t1.value8.Reward = {}
			t1.value8 = value82.Reward

			function t1.value10(p180, p181)
				if p181 <= 0 then
					return
				end

				value82.Stats[p180] = p181

				local v1827 = value82.UI.statsUI[p180]

				if not v1827 then
					return
				end

				value82.UI.setParagraph(v1827, (tostring(p181)))
			end

			t1.value8.updateStat = t1.value10
			t1.value8 = value82.Reward

			function t1.value10()
				task.wait(1)

				return value82.UI.clickButton({
					"Interface",
					"Rewards",
					"Main",
					"Info",
					"Main",
					"Buttons",
					"Retry"
				})
			end

			t1.value8.clickRetry = t1.value10
			t1.value8 = value82.UI.clickGui

			function t1.value10(p182, p183)
				local v1828 = nil
				local u1829 = nil

				local function v1830()
					local isGuiObject = v1828 and v1828:IsA("GuiObject")

					if not isGuiObject then
						u1829 = isGuiObject

						return
					end

					isGuiObject = v1828.Visible
					u1829 = isGuiObject
				end

				v1828 = p182:FindFirstChild(p183)
				u1829 = false
				pcall(v1830)

				local v1832 = v1828 and u1829

				if not v1832 then
					return v1832 or nil
				end

				v1832 = v1828

				return v1832 or nil
			end

			local value84 = t1.value8
			local value10 = t1.value10

			function t1.value11(p184, p185, p186, p187)
				local v1835 = tick() + (p187 or 10)
				local _, v1837

				if not p186 then
					local v1838 = v1835 < tick()

					while true do
						v1837 = value10(p184, p185)

						if v1837 then
							break
						end

						task.wait(0.15)

						if v1835 < tick() then
							return nil
						end
					end

					return v1837
				end

				local v1839 = tick() + 2

				while true do
					local v1840 = value10(p184, p185)

					if v1840 then
						v1840 = tick() < v1839
					end

					if not v1840 then
						local v1841 = v1835 < tick()

						while true do
							v1837 = value10(p184, p185)

							if v1837 then
								break
							end

							task.wait(0.15)

							if v1835 < tick() then
								return nil
							end
						end

						return v1837
					end

					task.wait(0.1)
				end
			end

			local value112 = t1.value11

			t1.value11 = value82.Reward

			function t1.value13()
				local v1843 = tick() + 12
				local _ = v1843 < tick()
				local premium

				while true do
					local v1846 = value82.Util.safeIndex(t2.value4, "Interface", "Chests")
					local Visible

					if v1846 then
						Visible = v1846.Visible
					else
						Visible = v1846
					end

					if Visible then
						if not v1846 then
							return false
						end

						v1919 = value112(v1846, "Free", false, 8)

						if v1919 then
							value84(v1919)
							t2.value7("openChests: Free clicked")
						end

						if value82.Config.OpenBothChests then
							task.wait(1.5)
							premium = value112(v1846, "Premium", false, 10)

							if premium then
								value84(premium)
								t2.value7("openChests: Premium clicked")
							end
						end

						v1920 = value112(v1846, "Finish", true, 12)

						if v1920 then
							if v1920 then
								value84(v1920)
								t2.value7("openChests: Finish clicked")
							else
								t2.value7("openChests: Finish MISSING after retry — stuck")
							end

							return true
						end

						t2.value7("openChests: Finish not found in 12s — retrying once")
						task.wait(2)
						v1920 = value112(v1846, "Finish", true, 8)

						if v1920 then
							value84(v1920)
							t2.value7("openChests: Finish clicked")
						else
							t2.value7("openChests: Finish MISSING after retry — stuck")
						end

						return true
					end

					task.wait(0.3)

					if v1843 < tick() then
						v1846 = nil

						break
					end
				end

				if not v1917 then
					return false
				end

				local free = value112(v1917, "Free", false, 8)

				if free then
					value84(free)
					t2.value7("openChests: Free clicked")
				end

				if value82.Config.OpenBothChests then
					task.wait(1.5)
					premium = value112(v1917, "Premium", false, 10)

					if premium then
						value84(premium)
						t2.value7("openChests: Premium clicked")
					end
				end

				local finish = value112(v1917, "Finish", true, 12)

				if finish then
					if finish then
						value84(finish)
						t2.value7("openChests: Finish clicked")
					else
						t2.value7("openChests: Finish MISSING after retry — stuck")
					end

					return true
				end

				t2.value7("openChests: Finish not found in 12s — retrying once")
				task.wait(2)
				finish = value112(v1917, "Finish", true, 8)

				if finish then
					value84(finish)
					t2.value7("openChests: Finish clicked")
				else
					t2.value7("openChests: Finish MISSING after retry — stuck")
				end

				return true
			end

			t1.value11.openChests = t1.value13

			function t1.value13(p188, p189)
				task.delay(p189 + 0.5, function()
					if not value82.Runtime.farming then
						return
					end

					local v1850 = value82.Util.safeIndex(t2.value4, "Interface", "Rewards")
					local Visible

					if v1850 then
						Visible = v1850.Visible
					else
						Visible = v1850
					end

					if not (Visible and v1850 and v1850) then
						local v1852 = value82.Util.safeIndex(workspace, "Unclimbable", "Cutscene")

						if v1852 then
							v1852 = #v1852:GetChildren() > 0
						end

						if v1852 then
							pcall(value82.Features.skipActive)
						end
					end

					local v1853 = tick() + 20

					while true do
						if true then
							local v1854 = value82.Util.safeIndex(t2.value4, "Interface", "Rewards")
							local Visible2

							if v1854 then
								Visible2 = v1854.Visible
							else
								Visible2 = v1854
							end
						end

						local v1856 = not (v1928 and v1927 and v1927) and true or false

						if v1856 then
							v1856 = tick() < v1853
						end

						if not v1856 then
							break
						end

						task.wait(0.15)
					end

					if not value82.Runtime.farming then
						return
					end

					local v1857 = value82.Util.safeIndex(t2.value4, "Interface", "Rewards")
					local Visible2

					if v1857 then
						Visible2 = v1857.Visible
					else
						Visible2 = v1857
					end

					if not (Visible2 and v1857 and v1857) then
						local v1859 = value82.Util.safeIndex(t2.value4, "Interface", "Chests")
						local Visible3

						if v1859 then
							Visible3 = v1859.Visible
						else
							Visible3 = v1859
						end

						local finish = Visible3 and value112(v1859, "Finish", false, 5)

						if finish then
							t2.value7("waitForRewardsThen: fallback Finish click")
							value84(finish)
							task.wait(1.5)
						end
					end

					local v1862 = tick() + 10

					while true do
						if true then
							local v1863 = value82.Util.safeIndex(t2.value4, "Interface", "Rewards")
							local Visible3

							if v1863 then
								Visible3 = v1863.Visible
							else
								Visible3 = v1863
							end
						end

						local v1865 = not (v1937 and v1936 and v1936) and true or false

						if v1865 then
							v1865 = tick() < v1862
						end

						if not v1865 then
							if not value82.Runtime.farming then
								return
							end

							local v1866 = value82.Util.safeIndex(t2.value4, "Interface", "Rewards")
							local Visible3

							if v1866 then
								Visible3 = v1866.Visible
							else
								Visible3 = v1866
							end

							if not (Visible3 and v1866 and v1866 or nil) then
								return
							end

							p188()

							return
						end

						task.wait(0.15)
					end
				end)
			end

			local value13 = t1.value13

			t1.value13 = value82.Reward

			function t1.value15()
				for i = 1, 3 do
					value82.Reward.clickRetry()

					local v1870 = tick() + 8
					local _ = i

					while tick() < v1870 do
						if not value82.Runtime.farming then
							return true
						end

						local v1872 = value82.Util.safeIndex(t2.value4, "Interface", "Rewards")
						local Visible

						if v1872 then
							Visible = v1872.Visible
						else
							Visible = v1872
						end

						if not (Visible and v1872 and v1872 or nil) then
							return true
						end

						task.wait(0.25)
					end

					t2.value7("clickRetrySure: rewards still visible after attempt " .. i)
				end

				t2.value7("clickRetrySure: gave up after 3 attempts — watchdog will force-leave")

				return false
			end

			t1.value13.clickRetrySure = t1.value15
			t1.value13 = value82.Reward

			function t1.value13.onRewarded()
				if not workspace:GetAttribute("Rewarded") then
					return
				end

				local now = tick()

				if now - 0 < 5 then
					return
				end

				value82.Runtime.rewardedTick = now

				local attribute = workspace:GetAttribute("Type")
				local attribute2 = workspace:GetAttribute("Seconds") or 0

				t2.value7("onRewarded: type=" .. tostring(attribute) .. " seconds=" .. tostring(attribute2))
				task.spawn(function()
					value82.DataCopy.fetch(true)

					local v1877 = tick() + 6

					while true do
						local v1878 = not value82.RewardHook._get

						if v1878 then
							v1878 = tick() < v1877
						end

						if not v1878 then
							break
						end

						task.wait(0.2)
					end

					local _get = value82.RewardHook._get

					if not _get then
						t2.value7("onRewarded: hook capture missing -> one-shot S_Rewards Get fallback")

						local S_Rewards = value82.Actor.invoke("S_Rewards", "Get", {
							argsExpr = "true",
							mapExpr = "                    out = { obtained = {}, perks = {}, drops = {}, stats = {} }\n                    if type(res) == \"table\" then\n                        local ob = res.Obtained\n                        if type(ob) == \"table\" then\n                            for k, v in pairs(ob) do\n                                if type(v) == \"number\" then out.obtained[tostring(k)] = v\n                                elseif k == \"Perks\" and type(v) == \"table\" then\n                                    for _, pn in pairs(v) do out.perks[#out.perks+1] = tostring(pn) end\n                                elseif k == \"Drops\" and type(v) == \"table\" then\n                                    for _, dn in pairs(v) do out.drops[#out.drops+1] = tostring(dn) end\n                                end\n                            end\n                        end\n                        if type(res.Stats) == \"table\" then\n                            for _, key in ipairs({ \"Time_Taken\", \"Damage\", \"Kills\", \"Crits\" }) do\n                                if type(res.Stats[key]) == \"number\" then out.stats[key] = res.Stats[key] end\n                            end\n                        end\n                    end\n                ",
							timeout = 5
						})
						local ok = S_Rewards and S_Rewards.ok

						if ok then
							local data = S_Rewards.data

							ok = type(data) == "table"
						end

						if ok then
							_get = S_Rewards.data
						end
					end

					local Perks = nil

					local function v1884()
						Perks = require(t2.value1.RS.Modules.Storage.Perks)
					end

					pcall(v1884)

					local function v1885(p190)
						if type(Perks) == "table" then
							for k, Perk in pairs(Perks) do
								local v1888

								if type(Perk) == "table" then
									v1888 = Perk[p190] ~= nil
								else
									v1888 = false
								end

								if v1888 then
									return tostring(k)
								end
							end

							return nil
						else
							return nil
						end
					end

					local value7 = t2.value7
					local s18 = "onRewarded: hook cap="
					local v1891 = _get ~= nil
					local v1892 = tostring(v1891)
					local s19 = " kills="
					local stats = _get and _get.stats

					if stats then
						stats = _get.stats.Kills
					end

					value7(s18 .. v1892 .. s19 .. tostring(stats) .. " drops=" .. (_get and _get.drops and table.concat(_get.drops, ",") or "nil" .. (" perks=" .. _get and _get.perks and (table.concat(_get.perks, ",") or "nil") or "nil")))

					local t84 = {}
					local t85 = {}
					local t86 = {
						gold = "Gold",
						xp = "XP",
						gems = "Gems",
						gem = "Gems",
						canes = "Canes",
						cane = "Canes",
						spins = "Spins",
						bp_xp = "Battlepass XP",
						regiment_exp = "Regiment EXP"
					}
					local v1898

					if _get then
						v1898 = type(_get) == "table"
					else
						v1898 = _get
					end

					if v1898 then
						local v1899, v1900, v1901 = pairs(_get.obtained or {})

						while true do
							local v1902

							v1901, v1902 = v1899(v1900, v1901)

							if not v1901 then
								break
							end

							local v1903

							if type(v1902) == "number" then
								v1903 = v1902 > 0
							else
								v1903 = false
							end

							if v1903 then
								local v1904 = tostring(v1901):lower()

								if v1904:find("gold") then
									value82.Reward.updateStat("GoldCollected", value82.Stats.GoldCollected + v1902)
								elseif v1904 == "xp" then
									value82.Reward.updateStat("ExpCollected", value82.Stats.ExpCollected + v1902)
								elseif v1904:find("gem") then
									value82.Reward.updateStat("GemsCollected", value82.Stats.GemsCollected + v1902)
								elseif v1904:find("cane") then
									value82.Reward.updateStat("CanesCollected", value82.Stats.CanesCollected + v1902)
								end

								local v1905 = t86[v1904] or tostring(v1901)

								t85[v1905] = (t85[v1905] or 0) + v1902
							end
						end

						local v1906, v1907, v1908 = ipairs(_get.drops or {})

						while true do
							local v1909

							v1908, v1909 = v1906(v1907, v1908)

							if not v1908 then
								break
							end

							local v1910 = tostring(v1909):lower()
							local v1911 = tostring(v1909)

							t85[v1911] = (t85[v1911] or 0) + 1

							if v1910:find("serum") then
								value82.Reward.updateStat("TitanSerums", value82.Stats.TitanSerums + 1)
								t84[#t84 + 1] = tostring(v1909)
							elseif v1910:find("scroll") then
								value82.Reward.updateStat("PrestigeScrolls", value82.Stats.PrestigeScrolls + 1)
								t84[#t84 + 1] = tostring(v1909)
							elseif v1910:find("shard") then
								value82.Reward.updateStat("TitanShards", value82.Stats.TitanShards + 1)
								t84[#t84 + 1] = tostring(v1909)
							else
								value82.Reward.updateStat("ItemDrops", value82.Stats.ItemDrops + 1)
							end
						end

						for _, v in ipairs(_get.perks or {}) do
							local v1914 = v1885(v) or ""
							local v1915 = tostring(v1914):lower()

							if v1915:find("epic") then
								value82.Reward.updateStat("EpicPerksCollected", value82.Stats.EpicPerksCollected + 1)
							elseif v1915:find("legendary") then
								value82.Reward.updateStat("LegendaryPerks", value82.Stats.LegendaryPerks + 1)
								t84[#t84 + 1] = tostring(v) .. " (Legendary)"
							elseif v1915:find("mythic") then
								value82.Reward.updateStat("MythicPerks", value82.Stats.MythicPerks + 1)
								t84[#t84 + 1] = tostring(v) .. " (Mythic)"
							end

							local v1916 = v1915 ~= ""

							if v1916 then
								v1916 = " (" .. v1915:gsub("^%l", string.upper) .. ")"
							end

							local v1918 = "Perk" .. v1916 or ""

							t85[v1918] = (t85[v1918] or 0) + 1
						end
					end

					if attribute == "Missions" then
						value82.Reward.updateStat("MissionsCompleted", value82.Stats.MissionsCompleted + 1)
					elseif attribute == "Raids" then
						value82.Reward.updateStat("RaidsCompleted", value82.Stats.RaidsCompleted + 1)
					elseif attribute == "Waves" then
						value82.Reward.updateStat("WavesCompleted", (value82.Stats.WavesCompleted or 0) + 1)
					end

					local farming

					if attribute == "Raids" then
						farming = value82.Runtime.farming
					else
						farming = false
					end

					if farming then
						value82.Reward.openChests()

						local v1921 = tick() + 4

						while true do
							local v1922 = not value82.RewardHook._chest

							if v1922 then
								v1922 = tick() < v1921
							end

							if not v1922 then
								break
							end

							task.wait(0.2)
						end

						local _chest = value82.RewardHook._chest

						if _chest then
							local v1923, v1924, v1925 = pairs(_chest.obtained or {})

							while true do
								local v1926

								v1925, v1926 = v1923(v1924, v1925)

								if not v1925 then
									break
								end

								local v1929

								if type(v1926) == "number" then
									v1929 = v1926 > 0
								else
									v1929 = false
								end

								if v1929 then
									local v1930 = tostring(v1925):lower()

									if v1930:find("gold") then
										value82.Reward.updateStat("GoldCollected", value82.Stats.GoldCollected + v1926)
									elseif v1930 == "xp" then
										value82.Reward.updateStat("ExpCollected", value82.Stats.ExpCollected + v1926)
									elseif v1930:find("gem") then
										value82.Reward.updateStat("GemsCollected", value82.Stats.GemsCollected + v1926)
									elseif v1930:find("cane") then
										value82.Reward.updateStat("CanesCollected", value82.Stats.CanesCollected + v1926)
									end

									local v1931 = t86[v1930] or tostring(v1925)

									t85[v1931] = (t85[v1931] or 0) + v1926
								end
							end

							for _, v in ipairs(_chest.drops or {}) do
								local v1932 = tostring(v):lower()
								local v1933 = tostring(v)

								t85[v1933] = (t85[v1933] or 0) + 1

								if v1932:find("serum") then
									value82.Reward.updateStat("TitanSerums", value82.Stats.TitanSerums + 1)
									t84[#t84 + 1] = tostring(v)
								elseif v1932:find("scroll") then
									value82.Reward.updateStat("PrestigeScrolls", value82.Stats.PrestigeScrolls + 1)
									t84[#t84 + 1] = tostring(v)
								elseif v1932:find("shard") then
									value82.Reward.updateStat("TitanShards", value82.Stats.TitanShards + 1)
									t84[#t84 + 1] = tostring(v)
								else
									value82.Reward.updateStat("ItemDrops", value82.Stats.ItemDrops + 1)
								end
							end
						end
					end

					local stats2 = _get and _get.stats or {}
					local Kills = stats2.Kills
					local v1935 = tonumber(Kills)
					local Damage = stats2.Damage
					local v1938 = tonumber(Damage)
					local Crits = stats2.Crits
					local v1939 = tonumber(Crits)
					local v1940 = attribute2
					local v1941 = tonumber(v1940) or 0

					value82.StatsWebhook.checkEvents()
					value82.StatsWebhook.sessionReport("win", attribute, {
						rewards = t85,
						drops = t84,
						seconds = v1941,
						kills = v1935,
						damage = v1938,
						crits = v1939,
						difficulty = workspace:GetAttribute("Difficulty"),
						objective = workspace:GetAttribute("Objective")
					})

					local WaveReturnLobby = attribute == "Waves" and value82.Config.WaveReturnLobby

					if WaveReturnLobby then
						WaveReturnLobby = value82.Runtime.farming
					end

					if WaveReturnLobby then
						value82.Farm.stop()

						local function v1943()
							value82.Farm.leaveToLobby(30)
						end

						task.delay(0.5, v1943)

						return
					end

					local v1944 = false
					local thunderMode = value82.Lobby.thunderMode

					if thunderMode then
						thunderMode = value82.Runtime.farming
					end

					if thunderMode then
						value82.Farm.stop()

						local function v1946()
							value82.Farm.leaveToLobby(30)
						end

						task.delay(0.5, v1946)
						v1944 = true
					else
						local AutoLobby = value82.Config.AutoLobby

						if AutoLobby then
							AutoLobby = value82.Runtime.farming
						end

						if AutoLobby then
							value82.Runtime.autoLobbyCount = value82.Runtime.autoLobbyCount + 1

							if value82.Runtime.autoLobbyCount >= value82.Config.AutoLobbyAfter then
								value82.Runtime.autoLobbyCount = 0
								t2.value7("AutoLobby: returning to lobby after", value82.Config.AutoLobbyAfter, "runs")
								value82.Farm.stop()
								task.delay(0.5, function()
									t2.value7("AutoLobby: teleporting to lobby")

									if value82.Farm.leaveToLobby(30) then
										t2.value7("AutoLobby: left to lobby OK")
									else
										t2.value7("AutoLobby: STILL in game after 30s — teleport failed")
										notify("Auto Farm", "Couldn\'t leave to lobby try manually.", 5, "alert-triangle")
									end
								end)
								v1944 = true
							end
						end
					end

					local farming2 = value82.Runtime.farming

					if farming2 then
						farming2 = not v1944
					end

					if not farming2 then
						value82.UI.refreshFarmStatus()

						return
					end

					value13(function()
						value82.Reward.clickRetrySure()
					end, 0)
					value82.UI.refreshFarmStatus()
				end)
			end

			t1.value13 = value82.Reward

			function t1.value13.onFailed()
				local value7 = t2.value7
				local farming = value82.Runtime.farming

				value7("onFailed: farming=" .. tostring(farming))

				if not value82.Runtime.farming then
					return
				end

				local now = tick()

				if now - value82.Runtime.lastFailedTick < 3 then
					return
				end

				value82.Runtime.lastFailedTick = now
				task.spawn(function()
					value82.DataCopy.fetch(true)
					value82.StatsWebhook.checkEvents()
					value82.StatsWebhook.sessionReport("fail", workspace:GetAttribute("Type"))
				end)

				if value82.Lobby.thunderMode then
					notify("Thunder Quest", "Run failed returning to lobby.", 4, "alert-triangle")
					t2.value7("onFailed: Thunder mode -> leave to lobby (no retry)")
					value82.Farm.stop()
					task.delay(0.5, function()
						value82.Farm.leaveToLobby(30)
					end)
				else
					value13(function()
						local attribute = workspace:GetAttribute("Type")
						local value72 = t2.value7
						local v1954 = tostring(attribute)
						local WaveReturnLobby = value82.Config.WaveReturnLobby

						value72("onFailed: waitForRewardsThen — mType=" .. v1954 .. " WaveReturnLobby=" .. tostring(WaveReturnLobby))

						local WaveReturnLobby2

						if attribute == "Waves" then
							WaveReturnLobby2 = value82.Config.WaveReturnLobby
						else
							WaveReturnLobby2 = false
						end

						if WaveReturnLobby2 then
							t2.value7("onFailed: Waves + WaveReturnLobby -> leaving to lobby")
							value82.Farm.stop()
							value82.Farm.leaveToLobby(30)
						else
							value82.Reward.clickRetrySure()
						end
					end, 0)
				end
			end

			t1.value13 = t2.value1.UIS
			t1.value13.MouseIconEnabled = true
			value82.Connection.add("CursorWatch", task.spawn(function()
				while true do
					repeat
						task.wait(0.5)
					until isInGame()

					t2.value1.UIS.MouseIconEnabled = true
				end
			end))
			t1.value13 = value82.Connection.add
			t1.value16 = t2.value1.UIS.WindowFocusReleased

			function t1.value17()
				if value82.Conn.BlurMouseFree then
					return
				end

				value82.Connection.add("BlurMouseFree", t2.value1.RunService.RenderStepped:Connect(function()
					t2.value1.UIS.MouseBehavior = Enum.MouseBehavior.Default
					t2.value1.UIS.MouseIconEnabled = true
				end))
				t2.value7("FocusFreeMouse: window blurred -> mouse freed")
			end

			t1.value13("FocusFreeMouse", t1.value16:Connect(t1.value17))
			t1.value13 = value82.Connection.add
			t1.value16 = t2.value1.UIS.WindowFocused

			function t1.value17()
				if not value82.Conn.BlurMouseFree then
					return
				end

				value82.Connection.disconnect("BlurMouseFree")
				t2.value7("FocusFreeMouse: window focused -> shiftlock restored to game")
			end

			t1.value13("FocusLockMouse", t1.value16:Connect(t1.value17))
			t1.value13 = value82.UI
			color39 = t2.value8
			t1.value16 = color39.CreateWindow
			color38 = {
				Title = "Mahmut Hub",
				Icon = "rbxassetid://79791092079055",
				Author = "by @mmahmutt",
				Folder = "Mahmut-Hub/AOTR",
				Size = UDim2.fromOffset(600, 500),
				Transparent = false,
				Theme = "Dark",
				Resizable = true,
				HideSearchBar = false
			}
			t1.value16 = t1.value16(color39, color38)
			t1.value13.Window = t1.value16
			value82.UI.Window:CreateTopbarButton("Discord", "rbxassetid://10367063073", function()
				if CopyToClipboard("https://discord.gg/xHgUpRkh24") then
					notify("Discord Invite Copied", "https://discord.gg/xHgUpRkh24", 5, "nfc")
				else
					notify("Clipboard Unsupported", "https://discord.gg/xHgUpRkh24", 5, "error")
				end
			end, 990)
			t1.value13 = value82.UI.Window
			color39 = UDim.new(0, 16)
			color38 = ColorSequence.new
			t1.value21 = Color3
			t1.value15 = t1.value13.EditOpenButton
			t1.value21 = t1.value21.fromHex("FFFFFF")
			t1.value20 = color38(t1.value21, Color3.fromHex("000000"))
			t1.value15(t1.value13, {
				Title = "AOTR",
				Icon = "rbxassetid://79791092079055",
				CornerRadius = color39,
				StrokeThickness = 2,
				OnlyMobile = false,
				Enabled = true,
				Draggable = true,
				Color = t1.value20
			})
			t1.value13 = value82.UI.Window
			color39 = Color3.fromHex
			t1.value15 = t1.value13.Tag
			t1.value18 = color39("FFFFFF")
			t1.value15(t1.value13, {
				Title = "v1.2.1",
				Color = t1.value18
			})
			t1.value13 = value82.UI.Window
			t1.value18 = Color3.fromHex("FFFFFF")
			t1.value13:Tag({
				Title = "Attack on Titan: Revolution",
				Color = t1.value18
			})
			t1.value13 = value82.UI.Window

			local value132 = t1.value13

			task.spawn(function()
				task.wait(0.5)

				local function v1958()
					value132:Close()
				end

				pcall(v1958)
			end)
			value132:Divider()

			local v1959 = value132:Tab({
				Title = "Settings",
				Icon = "settings"
			})

			pcall(function()
				v1959:Select()
			end)
			t1.value16 = v1959:Section({
				Title = "Movement Settings",
				Box = true,
				TextXAlignment = "Left",
				TextSize = 15,
				Opened = true
			})
			t1.value16.Slider(t1.value16, {
				Title = "Hover Height",
				Desc = "Height above titan",
				Flag = "HoverHeight",
				Step = 1,
				Value = {
					Min = 100,
					Max = 800,
					Default = 200
				},
				Callback = function(p191)
					value82.Config.HoverHeight = p191
				end
			})
			t1.value16.Slider(t1.value16, {
				Title = "Hover Speed",
				Desc = "Studs/sec toward titan",
				Flag = "HoverSpeed",
				Step = 10,
				Value = {
					Min = 250,
					Max = 2000,
					Default = 500
				},
				Callback = function(p192)
					value82.Config.HoverSpeed = p192
				end
			})
			t1.value16.Slider(t1.value16, {
				Title = "Wait Before Farming",
				Desc = "Delay before start",
				Flag = "WaitBeforeFarm",
				Step = 1,
				Value = {
					Min = 5,
					Max = 60,
					Default = 5
				},
				Callback = function(p193)
					value82.Config.WaitBeforeFarm = p193
				end
			})
			v1959:Divider()
			color39 = v1959:Section({
				Title = "Safety Timers (Use it as safe as possible)",
				Box = true,
				TextXAlignment = "Left",
				TextSize = 15,
				Opened = true
			})
			color38 = color39.Slider

			function t1.value1(p194)
				value82.Config.MissionSafetyTimer = p194
			end

			color38(color39, {
				Title = "Mission Safety Timer",
				Desc = "Min mission seconds before leaving",
				Flag = "MissionSafetyTimer",
				Step = 10,
				Value = {
					Min = 40,
					Max = 600,
					Default = 120
				},
				Callback = t1.value1
			})
			color38 = color39.Slider

			function t1.value1(p195)
				value82.Config.RaidSafetyTimer = p195
			end

			color38(color39, {
				Title = "Raid Safety Timer",
				Desc = "Min raid seconds before leaving",
				Flag = "RaidSafetyTimer",
				Step = 10,
				Value = {
					Min = 60,
					Max = 900,
					Default = 300
				},
				Callback = t1.value1
			})
			v1959:Divider()
			t1.value17 = v1959:Section({
				Title = "Auto Lobby",
				Box = true,
				TextXAlignment = "Left",
				TextSize = 15,
				Opened = true
			})
			t1.value17.Toggle(t1.value17, {
				Title = "Auto Back to Lobby",
				Desc = "Leave to lobby after X games",
				Flag = "AutoLobby",
				Value = false,
				Callback = function(p196)
					value82.Config.AutoLobby = p196
				end
			})
			t1.value17.Slider(t1.value17, {
				Title = "Back to Lobby After",
				Desc = "Missions/raids before returning",
				Flag = "AutoLobbyAfter",
				Step = 1,
				Value = {
					Min = 1,
					Max = 50,
					Default = 10
				},
				Callback = function(p197)
					value82.Config.AutoLobbyAfter = p197
				end
			})
			v1959:Divider()
			color39 = v1959:Section({
				Title = "Solo Only",
				Box = true,
				TextXAlignment = "Left",
				TextSize = 15,
				Opened = true
			})
			color38 = color39.Toggle

			function t1.value1(p198)
				value82.Config.SoloOnly = p198

				if p198 then
					value82.SoloOnly.Setup()
				else
					value82.Connection.disconnect("SoloOnly")
				end
			end

			color38(color39, {
				Title = "Solo Only",
				Desc = "Auto leave if another player joins while farming",
				Flag = "SoloOnly",
				Value = false,
				Callback = t1.value1
			})
			v1959:Divider()
			t1.value18 = v1959:Section({
				Title = "Visual",
				Box = true,
				TextXAlignment = "Left",
				TextSize = 15,
				Opened = true
			})
			color39 = t1.value18.Toggle
			color38 = {
				Title = "Remove Fog",
				Desc = "Turn off fog (in-game)",
				Flag = "RemoveFog",
				Value = value82.Config.RemoveFog,
				Callback = function(p199)
					value82.Config.RemoveFog = p199

					if not (not p199 or isInGame()) then
						return
					end

					value82.Perf.setFog(p199)
				end
			}
			color39(t1.value18, color38)
			v1959:Divider()
			color39 = v1959:Section({
				Title = "Safety & Utilities",
				Box = true,
				TextXAlignment = "Left",
				TextSize = 15,
				Opened = true
			})
			color39.Button(color39, {
				Title = "Shadow Ban Check",
				Desc = "Check for hidden bans",
				Callback = function()
					local v1960, banned = value82.DB.checkShadowBan()

					if v1960 == "SHADOW_BANNED" then
						notify("Shadow Ban", banned and "Banned: " .. banned or "Ban flag detected!", 6, "skull")
					elseif v1960 == "SAFE" then
						notify("Shadow Ban", "You are safe :)", 3, "ghost")

						return
					elseif v1960 == "UNKNOWN" then
						notify("Shadow Ban", "Failed to check.", 6, "info")

						return
					else
						notify("Shadow Ban", "Unable to check.", 3, "x-circle")

						return
					end
				end
			})
			color39.Button(color39, {
				Title = "Return To Lobby",
				Desc = "Go to lobby (rejoins if already there)",
				Callback = function()
					local PlaceId = game.PlaceId

					if PlaceId == value82.PLACE.MainMenu then
						value82.Actor.invoke("Functions", "Teleport", {
							argsExpr = "\"Lobby\"",
							mapExpr = "out = true",
							timeout = 5
						})
					elseif PlaceId == value82.PLACE.Lobby then
						value82.Actor.invoke("Functions", "Teleport", {
							argsExpr = "\"Lobby\"",
							mapExpr = "out = true",
							timeout = 5
						})

						return
					else
						value82.Actor.send("Functions", "Teleport")

						return
					end
				end
			})
			color39.Button(color39, {
				Title = "Return To Main Menu",
				Desc = "Teleport to Main Menu",
				Callback = function()
					game:GetService("TeleportService"):Teleport(value82.PLACE.MainMenu, t2.value2.LocalPlayer)
				end
			})
			color39 = value132:Tab({
				Title = "Farming",
				Icon = "crosshair"
			})
			color38 = color39:Section({
				Title = "Auto Farm",
				Box = true,
				TextXAlignment = "Left",
				TextSize = 15,
				Opened = true
			})
			value82.UI.paragraphs.farm = color38:Paragraph({
				Title = "Farm Status",
				Desc = "Idle not farming"
			})

			function value82.UI.refreshFarmStatus()
				local farm = value82.UI.paragraphs.farm

				if farm then
					if value82.Runtime.farming then
						local v1964 = tick() - value82.Stats.FarmStartTime
						local v1965 = math.floor(v1964)
						local setParagraph = value82.UI.setParagraph
						local format = string.format
						local v1968 = v1965 / 60

						setParagraph(farm, format("Time: %dm %ds | Missions: %d | Raids: %d | Gold: %d | EXP: %d", math.floor(v1968), v1965 % 60, value82.Stats.MissionsCompleted, value82.Stats.RaidsCompleted, value82.Stats.GoldCollected, value82.Stats.ExpCollected), "Farm Status  ●  RUNNING")

						return
					else
						value82.UI.setParagraph(farm, "Not farming", "Farm Status  ○  IDLE")

						return
					end
				end
			end
			function t1.value20(p200)
				if p200 then
					value82.Farm.start()
				else
					value82.Farm.stop()
				end

				value82.UI.refreshFarmStatus()
			end

			color38:Toggle({
				Title = "Toggle Auto Farm",
				Desc = "Start/stop farming",
				Flag = "AutoFarm",
				Callback = t1.value20
			})
			color37 = color38.Dropdown
			t1.value20 = { "Open Both Chest in Raid", "Auto Execute" }

			function t1.value3(p201)
				local t87 = {}

				if type(p201) ~= "table" then
					value82.Config.OpenBothChests = t87["Open Both Chest in Raid"] == true
					value82.Config.AutoExecute = t87["Auto Execute"] == true
					value82.applyAutoExecute()

					return
				end

				for k, v in pairs(p201) do
					local v1972 = type(k) == "number" and v and v or k
					local v1973

					if type(v1972) == "string" then
						v1973 = v ~= false
					else
						v1973 = false
					end

					if v1973 then
						t87[v1972] = true
					end
				end

				value82.Config.OpenBothChests = t87["Open Both Chest in Raid"] == true
				value82.Config.AutoExecute = t87["Auto Execute"] == true
				value82.applyAutoExecute()
			end

			color37(color38, {
				Title = "Farm Settings",
				Desc = "Apply Settings to ur Current Farm",
				Flag = "FarmSettings",
				Values = t1.value20,
				Multi = true,
				AllowNone = true,
				Value = {},
				Callback = t1.value3
			})
			color39:Divider()
			color38 = color39:Section({
				Title = "Combat Features",
				Box = true,
				TextXAlignment = "Left",
				TextSize = 15,
				Opened = true
			})
			t1.value19 = color38.Toggle
			t1.value19(color38, {
				Title = "Auto Grab Escape",
				Desc = "Auto slash escape",
				Flag = "AutoGrabEscape",
				Value = true,
				Callback = function(p202)
					value82.Config.AutoGrabEscape = p202

					if p202 then
						if value82.Conn.Escape then
							return
						else
							value82.Features.initEscape()
							value82.Features.setupEscape()

							return
						end
					end

					value82.Connection.disconnect("Escape")
				end
			})
			t1.value19 = color38.Toggle
			t1.value19(color38, {
				Title = "Auto Reload Blades",
				Desc = "Reload when blade breaks",
				Flag = "AutoReload",
				Value = true,
				Callback = function(p203)
					value82.Config.AutoReload = p203

					if p203 then
						value82.Tasks.reload:start()

						return
					end

					if value82.Config.AutoFullReload then
						return
					end

					v617()
				end
			})
			t1.value19 = color38.Toggle
			t1.value19(color38, {
				Title = "Auto Full Reload",
				Desc = "Full reload when empty",
				Flag = "AutoFullReload",
				Value = true,
				Callback = function(p204)
					value82.Config.AutoFullReload = p204

					if p204 then
						value82.Tasks.reload:start()

						return
					end

					if value82.Config.AutoReload then
						return
					end

					v617()
				end
			})
			t1.value19 = color38.Toggle
			color37 = {
				Title = "Infinite Spear",
				Desc = "Fire even when spear count is 0 (no reload needed)",
				Flag = "InfiniteSpear",
				Value = value82.Config.InfiniteSpear,
				Callback = function(p205)
					value82.Config.InfiniteSpear = p205
				end
			}
			t1.value19(color38, color37)
			color37 = value82.Config.AutoUseSkills
			t1.value19 = color38.Toggle
			t1.value19(color38, {
				Title = "Auto Use Skills",
				Desc = "Human form: auto-cast equipped hotbar skills when a titan is in range",
				Flag = "AutoUseSkills",
				Value = color37,
				Callback = function(p206)
					value82.Config.AutoUseSkills = p206

					if p206 then
						p206 = isInGame()
					end

					if not p206 then
						return
					end

					task.spawn(function()
						value82.DataCopy.fetch(true)
					end)
				end
			})
			color39:Divider()
			t1.value19 = color39:Section({
				Title = "Multi-Hit Settings (Use it as Safe as Possible)",
				Box = true,
				TextXAlignment = "Left",
				TextSize = 15,
				Opened = true
			})
			color38 = value82.Config
			color37 = t1.value19.Toggle
			t1.value21 = color38.MultiHitEnabled

			function t1.value22(p207)
				value82.Config.MultiHitEnabled = p207
			end

			color37(t1.value19, {
				Title = "Multi Hit",
				Desc = "Hit multiple titans per swing",
				Flag = "MultiHitEnabled",
				Value = t1.value21,
				Callback = t1.value22
			})
			t1.value6 = value82
			color38 = t1.value19.Slider
			t1.value8 = t1.value6.Config.MultiHit
			t1.value22 = {
				Min = 1,
				Max = 10,
				Default = t1.value8 or 3
			}
			color38(t1.value19, {
				Title = "Multi Hit Amount",
				Desc = "Titans hit per swing (1 = single)",
				Flag = "MultiHit",
				Step = 1,
				Value = t1.value22,
				Callback = function(p208)
					local Config = value82.Config
					local v1975 = tonumber(p208) or 1

					Config.MultiHit = math.max(1, v1975)
				end
			})
			color38 = t1.value19.Slider
			t1.value8 = value82.Config.MultiHitRadius
			t1.value22 = {
				Min = 50,
				Max = 1000,
				Default = t1.value8 or 250
			}
			color38(t1.value19, {
				Title = "Multi Hit Radius",
				Desc = "Max distance (studs) of extra titans from the main target",
				Flag = "MultiHitRadius",
				Step = 25,
				Value = t1.value22,
				Callback = function(p209)
					local Config = value82.Config
					local v1977 = tonumber(p209) or 250

					Config.MultiHitRadius = math.max(50, v1977)
				end
			})
			color38 = t1.value19.Slider
			t1.value8 = value82.Config.BossBurst
			t1.value22 = {
				Min = 1,
				Max = 5,
				Default = t1.value8 or 5
			}
			color38(t1.value19, {
				Title = "Boss Burst",
				Desc = "Hits bursted at a raid boss\'s nape per swing",
				Flag = "BossBurst",
				Step = 1,
				Value = t1.value22,
				Callback = function(p210)
					local Config = value82.Config
					local v1979 = tonumber(p210) or 5

					Config.BossBurst = math.clamp(v1979, 1, 10)
				end
			})
			color39:Divider()
			color39 = color39:Section({
				Title = "Misc",
				Box = true,
				TextXAlignment = "Left",
				TextSize = 15,
				Opened = true
			})
			color39.Toggle(color39, {
				Title = "Nape Extender",
				Desc = "Expand ALL titan hitboxes",
				Flag = "NapeExtender",
				Callback = function(p211)
					value82.Config.NapeExtender = p211

					if p211 then
						value82.Nape.applyAll()

						if value82.Conn.NapeMonitor then
							return
						else
							value82.Nape.startMonitor()

							return
						end
					end

					value82.Nape.removeAll()
					value82.Connection.disconnect("NapeMonitor")
					value82.Connection.disconnect("NapeMonitorRemoved")
				end
			})
			color39.Toggle(color39, {
				Title = "Titan ESP",
				Desc = "Show titans through walls",
				Flag = "TitanESP",
				Value = false,
				Callback = function(p212)
					value82.Config.TitanESP = p212

					if p212 then
						value82.Features.updateESP()
					else
						value82.Features.clearESP()
					end
				end
			})
			color39 = value132:Tab({
				Title = "Misc",
				Icon = "layers"
			})
			color38 = color39:Section({
				Title = "Auto Die at Streak x",
				Box = true,
				TextXAlignment = "Left",
				TextSize = 15,
				Opened = true
			})
			color38.Toggle(color38, {
				Title = "Auto Die at Streak",
				Desc = "Kill self when kill streak reaches the threshold",
				Flag = "AutoDie",
				Value = true,
				Callback = function(p213)
					value82.Config.AutoDie = p213

					local farming

					if p213 then
						farming = value82.Runtime.farming
					else
						farming = p213
					end

					if farming then
						value82.Tasks.streakWatch:start()

						return
					end

					if p213 then
						return
					end

					value82.Tasks.streakWatch:stop()
				end
			})
			color38.Slider(color38, {
				Title = "Die at Streak",
				Desc = "Kill streak threshold to trigger auto die",
				Flag = "AutoDieStreak",
				Step = 100,
				Value = {
					Min = 100,
					Max = 10000,
					Default = 1000
				},
				Callback = function(p214)
					local Config = value82.Config
					local v1982 = tonumber(p214) or 50

					Config.AutoDieStreak = math.max(1, v1982)
				end
			})
			color39:Divider()
			color38 = color39:Section({
				Title = "Inventory & Equipment",
				Box = true,
				TextXAlignment = "Left",
				TextSize = 15,
				Opened = true
			})
			t1.value8 = value82.Mission.PERKS_RARITIES

			function t1.value6(p215)
				local deletePerksRarities = {}

				if type(p215) ~= "table" then
					value82.Config.DeletePerksRarities = deletePerksRarities

					return
				end

				local v1984, v1985, v1986 = ipairs(p215)

				while true do
					local v1987

					v1986, v1987 = v1984(v1985, v1986)

					if not v1986 then
						break
					end

					deletePerksRarities[#deletePerksRarities + 1] = v1987
				end

				for k, v in pairs(p215) do
					local v1990

					if type(k) == "string" then
						if v1990 then
							v1990 = not table.find(deletePerksRarities, k)
						end
					else
						v1990 = false
					end

					if v1990 then
						deletePerksRarities[#deletePerksRarities + 1] = k
					end
				end

				value82.Config.DeletePerksRarities = deletePerksRarities
			end

			color38:Dropdown({
				Title = "Select Rarity",
				Desc = "Auto Delete Perks of this rarity",
				Flag = "SellPerksRarity",
				Value = {},
				Multi = true,
				AllowNone = true,
				Values = t1.value8,
				Callback = t1.value6
			})
			color37 = color38.Toggle

			function t1.value3(p216)
				value82.Config.AutoDeletePerks = p216
				value82.Lobby.sched.deletePerks = p216

				if not p216 then
					value82.UI.saveConfig()

					return
				end

				local autoDeletePerks = value82.Tasks.autoDeletePerks

				if value82.Lobby.restoring or (not value5() or autoDeletePerks:isRunning()) then
					value82.UI.saveConfig()

					return
				end

				t2.value7("IndependentLayer: start " .. autoDeletePerks.name)
				autoDeletePerks:start()
				value82.UI.saveConfig()
			end

			color37(color38, {
				Title = "Auto Delete Perks",
				Desc = "Automatically delete perks by rarity",
				Flag = "AutoSellPerks",
				Value = false,
				Callback = t1.value3
			})
			color39:Divider()
			color38 = color39:Section({
				Title = "Cosmetic Crates",
				Box = true,
				TextXAlignment = "Left",
				TextSize = 15,
				Opened = true
			})
			t1.value1 = color38.Dropdown
			color37 = {
				Title = "Chest Type",
				Desc = "Cosmetic crate type(s) to auto-open",
				Flag = "OpenCrateTypes",
				Value = {},
				Multi = true,
				AllowNone = true,
				Values = value82.Inventory.CRATE_TYPES,
				Callback = function(p217)
					local openCrateTypes = {}

					if type(p217) ~= "table" then
						value82.Config.OpenCrateTypes = openCrateTypes

						return
					end

					local v1993, v1994, v1995 = ipairs(p217)

					while true do
						local v1996

						v1995, v1996 = v1993(v1994, v1995)

						if not v1995 then
							break
						end

						openCrateTypes[#openCrateTypes + 1] = v1996
					end

					for k, v in pairs(p217) do
						local v1999

						if type(k) == "string" then
							if v1999 then
								v1999 = not table.find(openCrateTypes, k)
							end
						else
							v1999 = false
						end

						if v1999 then
							openCrateTypes[#openCrateTypes + 1] = k
						end
					end

					value82.Config.OpenCrateTypes = openCrateTypes
				end
			}
			t1.value1(color38, color37)
			t1.value1 = color38.Toggle
			t1.value1(color38, {
				Title = "Auto Open Chest",
				Desc = "Open all selected cosmetic crates in the lobby",
				Flag = "AutoOpenCrates",
				Value = false,
				Callback = function(p218)
					value82.Config.AutoOpenCrates = p218
					value82.Lobby.sched.openCrates = p218

					if not p218 then
						value82.UI.saveConfig()

						return
					end

					local autoOpenCrates = value82.Tasks.autoOpenCrates

					if value82.Lobby.restoring or (not value5() or autoOpenCrates:isRunning()) then
						value82.UI.saveConfig()

						return
					end

					t2.value7("IndependentLayer: start " .. autoOpenCrates.name)
					autoOpenCrates:start()
					value82.UI.saveConfig()
				end
			})
			color39:Divider()
			t1.value1 = color39:Section({
				Title = "Achievements",
				Box = true,
				TextXAlignment = "Left",
				TextSize = 15,
				Opened = true
			})
			t1.value1.Toggle(t1.value1, {
				Title = "Auto Claim Achievements",
				Desc = "Claim all completed achievements in the lobby",
				Flag = "AutoClaimAchievements",
				Value = false,
				Callback = function(p219)
					value82.Config.AutoClaimAchievements = p219
					value82.Lobby.sched.claimAchievements = p219

					if not p219 then
						value82.UI.saveConfig()

						return
					end

					local autoClaimAchievements = value82.Tasks.autoClaimAchievements

					if value82.Lobby.restoring or (not value5() or autoClaimAchievements:isRunning()) then
						value82.UI.saveConfig()

						return
					end

					t2.value7("IndependentLayer: start " .. autoClaimAchievements.name)
					autoClaimAchievements:start()
					value82.UI.saveConfig()
				end
			})
			t1.value20 = value132:Tab({
				Title = "Webhook",
				Icon = "bell"
			})
			color39 = t1.value20:Section({
				Title = "Stats Webhook",
				Box = true,
				TextXAlignment = "Left",
				TextSize = 15,
				Opened = true
			})
			color38 = color39.Input

			function t1.value10(p220)
				value82.StatsWebhook.webhook = type(p220) == "string" and (p220:match("^%s*(.-)%s*$") or "") or ""
			end

			color38(color39, {
				Title = "Stats Webhook URL",
				Desc = "Monitors ALL stats auto-sends a report each run (win/fail) + level/prestige/shadowban alerts",
				Flag = "StatsWebhook",
				InputIcon = "bell",
				Placeholder = "https://discord.com/api/webhooks/...",
				Value = "",
				Callback = t1.value10
			})
			t1.value20:Divider()
			color39 = t1.value20:Section({
				Title = "Family Webhook",
				Box = true,
				TextXAlignment = "Left",
				TextSize = 15,
				Opened = true
			})
			t1.value21 = color39.Input
			t1.value21(color39, {
				Title = "Family Webhook URL",
				Desc = "Paste Discord webhook URL notifies you when the target family is found",
				Flag = "FamilyWebhook",
				InputIcon = "bell",
				Placeholder = "https://discord.com/api/webhooks/...",
				Value = "",
				Callback = function(p221)
					value82.Family.webhook = type(p221) == "string" and (p221:match("^%s*(.-)%s*$") or "") or ""
				end
			})
			t1.value21 = value132:Tab({
				Title = "Stats",
				Icon = "chart-spline"
			}):Section({
				Title = "Lifetime Stats",
				Box = true,
				TextXAlignment = "Left",
				TextSize = 15,
				Opened = true
			})

			local value21 = t1.value21

			function t1.value21(p222, p223)
				local v2003 = value21
				local Paragraph = v2003.Paragraph
				local v2005 = value82.Stats[p223] or 0
				local v2006 = Paragraph(v2003, {
					Title = p222,
					Desc = tostring(v2005)
				})

				value82.UI.statsUI[p223] = v2006
			end

			t1.value21("Missions Completed", "MissionsCompleted")
			t1.value21("Raids Completed", "RaidsCompleted")
			t1.value21("Gold Collected", "GoldCollected")
			t1.value21("Gems Collected", "GemsCollected")
			t1.value21("Canes Collected", "CanesCollected")
			t1.value21("EXP Collected", "ExpCollected")
			t1.value21("Prestige Scrolls Collected", "PrestigeScrolls")
			t1.value21("Epic Perks Collected", "EpicPerksCollected")
			t1.value21("Legendary Perks Collected", "LegendaryPerks")
			t1.value21("Mythical Perks Collected", "MythicPerks")
			t1.value21("Titan Serums Collected", "TitanSerums")
			t1.value21("Titan Shards Collected", "TitanShards")
			t1.value21("Item Drops Collected", "ItemDrops")
			value21:Button({
				Title = "Reset Lifetime Stats",
				Desc = "Delete all lifetime stats",
				Callback = function()
					for k in pairs(value82.UI.statsUI) do
						value82.Stats[k] = 0
						value82.UI.setParagraph(value82.UI.statsUI[k], "0")
					end

					value82.DB.save()
					notify("Stats", "Lifetime stats reset.", 3, "refresh-cw")
				end
			})
			color39 = value132:Section({
				Title = "Lobby",
				Icon = "map",
				Opened = false
			})
			color38 = color39:Tab({
				Title = "Mission",
				Icon = "flag"
			})
			value82.UI.paragraphs.mission = color38:Paragraph({
				Title = "Status",
				Desc = "Idle."
			})
			color38:Divider()
			color37 = color38:Section({
				Title = "Session Settings",
				Box = true,
				TextXAlignment = "Left",
				TextSize = 15,
				Opened = true
			})
			t1.value12 = (function()
				local t88 = {}

				for _, map in ipairs(value82.Mission.MAPS) do
					t88[#t88 + 1] = map.name
				end

				return t88
			end)()
			color37:Dropdown({
				Title = "Map",
				Desc = "Mission map",
				Flag = "Map",
				Value = "Shiganshina",
				Values = t1.value12,
				Callback = function(p224)
					value82.Lobby.missionMap = value82.Mission.asStr(p224)

					if value82.Lobby.restoring then
						return
					end

					local v2011 = value82.Mission.objectivesFor(p224)
					local objective = value82.UI.dropdowns.objective

					if not objective then
						return
					end

					pcall(function()
						objective:Refresh(v2011)
					end)

					if not table.find(v2011, value82.Lobby.missionObjective) then
						value82.Lobby.missionObjective = v2011[1]
						value82.UI.selectDropdown(objective, v2011[1])

						return
					end

					value82.UI.selectDropdown(objective, value82.Lobby.missionObjective)
				end
			})
			t1.value3 = value82.UI.dropdowns
			color36 = {
				Title = "Objective",
				Desc = "Objective type",
				Flag = "Objective",
				Values = value82.Mission.ALL_OBJECTIVES,
				Value = "Skirmish",
				Callback = function(p225)
					value82.Lobby.missionObjective = value82.Mission.asStr(p225)
				end
			}
			color36 = color37.Dropdown(color37, color36)
			t1.value3.objective = color36
			t1.value3 = value82.UI.dropdowns
			color36 = {
				Title = "Difficulty",
				Desc = "Session difficulty",
				Flag = "Difficulty",
				Values = value82.Mission.DIFFICULTIES,
				Value = "Normal",
				Callback = function(p226)
					value82.Lobby.missionDifficulty = value82.Mission.asStr(p226)
				end
			}
			color37 = color37.Dropdown(color37, color36)
			t1.value3.difficulty = color37
			color38:Divider()
			t1.value3 = color38:Section({
				Title = "Modifiers",
				Box = true,
				TextXAlignment = "Left",
				TextSize = 15,
				Opened = true
			})
			color37 = t1.value3.Dropdown
			color36 = value82.Mission.MODIFIERS
			t1.value12 = {}

			function t1.value24(p227)
				local missionModifiers = {}

				if type(p227) ~= "table" then
					value82.Lobby.missionModifiers = missionModifiers

					return
				end

				local v2014, v2015, v2016 = ipairs(p227)

				while true do
					local v2017

					v2016, v2017 = v2014(v2015, v2016)

					if not v2016 then
						break
					end

					missionModifiers[#missionModifiers + 1] = v2017
				end

				for _, modifier in ipairs(value82.Mission.MODIFIERS) do
					local v2020 = not table.find(missionModifiers, modifier)

					if v2020 then
						v2020 = p227[modifier]
					end

					if v2020 then
						missionModifiers[#missionModifiers + 1] = modifier
					end
				end

				value82.Lobby.missionModifiers = missionModifiers
			end

			color37(t1.value3, {
				Title = "Active Modifiers",
				Desc = "Applied after creation",
				Flag = "MissionModifiers",
				Values = color36,
				Value = t1.value12,
				Multi = true,
				AllowNone = true,
				Callback = t1.value24
			})
			color38:Divider()
			color37 = color38:Section({
				Title = "Auto Create",
				Box = true,
				TextXAlignment = "Left",
				TextSize = 15,
				Opened = true
			})
			color37.Toggle(color37, {
				Title = "Boosted Only",
				Desc = "Only when map has active boost",
				Flag = "MissionBoostedOnly",
				Value = false,
				Callback = function(p228)
					value82.Lobby.autoCreate.boosted = p228
				end
			})
			color37.Toggle(color37, {
				Title = "Auto Create Session",
				Desc = "Automatically create and run missions",
				Flag = "AutoMission",
				Value = false,
				Callback = function(p229)
					value82.Lobby.sched.mission = p229

					local autoCreate

					if not p229 then
						if p229 then
							autoCreate = value82.Tasks.autoCreate

							if value82.Lobby.restoring or (not value5() or autoCreate:isRunning()) then
								value82.UI.saveConfig()

								return
							end

							t2.value7("IndependentLayer: start " .. autoCreate.name)
							autoCreate:start()
						else
							value82.Tasks.autoCreate:stop()
						end

						value82.UI.saveConfig()

						return
					end

					p229 = value5()

					if p229 then
						autoCreate = value82.Tasks.autoCreate

						if value82.Lobby.restoring or (not value5() or autoCreate:isRunning()) then
							value82.UI.saveConfig()

							return
						end

						t2.value7("IndependentLayer: start " .. autoCreate.name)
						autoCreate:start()
					else
						value82.Tasks.autoCreate:stop()
					end

					value82.UI.saveConfig()
				end
			})
			color37.Button(color37, {
				Title = "Create Once Now",
				Desc = "Single session immediately (mission only)",
				Callback = function()
					if value5() then
						task.spawn(value82.Mission.createStartOnce)
					end
				end
			})
			color38:Divider()
			color38 = color38:Section({
				Title = "Boost Info",
				Box = true,
				TextXAlignment = "Left",
				TextSize = 15,
				Opened = true
			})
			value82.UI.paragraphs.boost = color38:Paragraph({
				Title = "Boosted Map",
				Desc = "No active boost"
			})
			color38 = function()
				local attribute = workspace:GetAttribute("Boosted_Map")
				local attribute2 = workspace:GetAttribute("Boosted_Timer") or 0

				if attribute then
					local setParagraph = value82.UI.setParagraph
					local boost = value82.UI.paragraphs.boost
					local format = string.format
					local v2027 = attribute2 / 60

					setParagraph(boost, attribute .. " " .. format("%02d:%02d", math.floor(v2027), attribute2 % 60) .. " left")
				else
					value82.UI.setParagraph(value82.UI.paragraphs.boost, "No active boost")
				end
			end
			color38()
			value82.Connection.add("BoostMap", workspace:GetAttributeChangedSignal("Boosted_Map"):Connect(color38))
			value82.Connection.add("BoostTimer", workspace:GetAttributeChangedSignal("Boosted_Timer"):Connect(color38))
			t1.value8 = color39:Tab({
				Title = "Raid",
				Icon = "shield"
			})
			value82.UI.paragraphs.raid = t1.value8:Paragraph({
				Title = "Status",
				Desc = "Idle."
			})
			t1.value8:Divider()
			color38 = t1.value8:Section({
				Title = "Session Settings",
				Box = true,
				TextXAlignment = "Left",
				TextSize = 15,
				Opened = true
			})
			color37 = value82.Raid.OBJECTIVES
			t1.value6 = color38.Dropdown
			t1.value6(color38, {
				Title = "Objective",
				Desc = "Boss titan",
				Flag = "RaidObjective",
				Value = "Attack Titan",
				Values = color37,
				Callback = function(p230)
					value82.Lobby.raidObjective = value82.Mission.asStr(p230)

					if value82.Lobby.raidObjective ~= "Colossal Titan" then
						return
					end

					value82.Lobby.raidDifficulty = "Aberrant"
					value82.UI.selectDropdown(value82.UI.dropdowns.raidDifficulty, "Aberrant")
				end
			})
			t1.value6 = value82.UI.dropdowns
			t1.value10 = color38:Dropdown({
				Title = "Difficulty",
				Desc = "Hard / Severe / Aberrant (Colossal: Aberrant only)",
				Flag = "RaidDifficulty",
				Value = "Aberrant",
				Values = value82.Raid.DIFFICULTIES,
				Callback = function(p231)
					local v2028 = value82.Mission.asStr(p231)
					local v2029

					if value82.Lobby.raidObjective == "Colossal Titan" then
						v2029 = v2028 ~= "Aberrant"
					else
						v2029 = false
					end

					if v2029 then
						value82.UI.selectDropdown(value82.UI.dropdowns.raidDifficulty, "Aberrant")
						notify("Raid", "Colossal Titan requires Aberrant difficulty.", 3, "alert-triangle")
					else
						value82.Lobby.raidDifficulty = v2028
					end
				end
			})
			t1.value6.raidDifficulty = t1.value10
			t1.value8:Divider()
			t1.value6 = t1.value8:Section({
				Title = "Modifiers",
				Box = true,
				TextXAlignment = "Left",
				TextSize = 15,
				Opened = true
			})
			color38 = t1.value6.Dropdown
			color37 = value82.Raid.MODIFIERS
			t1.value24 = {}
			color38(t1.value6, {
				Title = "Active Modifiers",
				Desc = "Applied after creation",
				Flag = "RaidModifiers",
				Values = color37,
				Value = t1.value24,
				Multi = true,
				AllowNone = true,
				Callback = function(p232)
					local raidModifiers = {}

					if type(p232) ~= "table" then
						value82.Lobby.raidModifiers = raidModifiers

						return
					end

					local v2031, v2032, v2033 = ipairs(p232)

					while true do
						local v2034

						v2033, v2034 = v2031(v2032, v2033)

						if not v2033 then
							break
						end

						raidModifiers[#raidModifiers + 1] = v2034
					end

					for _, modifier in ipairs(value82.Raid.MODIFIERS) do
						local v2037 = not table.find(raidModifiers, modifier)

						if v2037 then
							v2037 = p232[modifier]
						end

						if v2037 then
							raidModifiers[#raidModifiers + 1] = modifier
						end
					end

					value82.Lobby.raidModifiers = raidModifiers
				end
			})
			t1.value8:Divider()
			color38 = t1.value8:Section({
				Title = "Auto Create",
				Box = true,
				TextXAlignment = "Left",
				TextSize = 15,
				Opened = true
			})
			color38:Toggle({
				Title = "Auto Create Session",
				Desc = "Automatically create and run raid sessions",
				Flag = "AutoRaid",
				Value = false,
				Callback = function(p233)
					value82.Lobby.sched.raid = p233

					local autoRaid

					if not p233 then
						if p233 then
							autoRaid = value82.Tasks.autoRaid

							if value82.Lobby.restoring or (not value5() or autoRaid:isRunning()) then
								value82.UI.saveConfig()

								return
							end

							t2.value7("IndependentLayer: start " .. autoRaid.name)
							autoRaid:start()
						else
							value82.Tasks.autoRaid:stop()
						end

						value82.UI.saveConfig()

						return
					end

					p233 = value5()

					if p233 then
						autoRaid = value82.Tasks.autoRaid

						if value82.Lobby.restoring or (not value5() or autoRaid:isRunning()) then
							value82.UI.saveConfig()

							return
						end

						t2.value7("IndependentLayer: start " .. autoRaid.name)
						autoRaid:start()
					else
						value82.Tasks.autoRaid:stop()
					end

					value82.UI.saveConfig()
				end
			})
			t1.value10 = color38.Button
			t1.value10(color38, {
				Title = "Create Once Now",
				Desc = "Single raid session immediately",
				Callback = function()
					if value5() then
						task.spawn(value82.Raid.createStartOnce)
					end
				end
			})
			t1.value10 = color39:Tab({
				Title = "Wave",
				Icon = "waves"
			})
			value82.UI.paragraphs.wave = t1.value10:Paragraph({
				Title = "Status",
				Desc = "Idle."
			})
			t1.value10:Divider()
			color38 = t1.value10:Section({
				Title = "Kill Priority",
				Box = true,
				TextXAlignment = "Left",
				TextSize = 15,
				Opened = true
			})
			color38.Toggle(color38, {
				Title = "Kill Bosses First",
				Desc = "Prioritize boss titans (named titans) in waves",
				Flag = "WaveKillBosses",
				Value = true,
				Callback = function(p234)
					value82.Config.WaveKillBosses = p234
				end
			})
			t1.value10:Divider()
			color38 = t1.value10:Section({
				Title = "Gear Upgrades",
				Box = true,
				TextXAlignment = "Left",
				TextSize = 15,
				Opened = true
			})
			color37 = color38.Toggle

			function t1.value26(p235)
				value82.Config.WaveAutoUpgradeGear = p235
			end

			color37(color38, {
				Title = "Auto Upgrade Gear",
				Desc = "Auto-upgrade all ODM/TS gear stats with gold each Skip vote",
				Flag = "WaveAutoUpgradeGear",
				Value = false,
				Callback = t1.value26
			})
			t1.value10:Divider()
			color38 = t1.value10:Section({
				Title = "Base Upgrades",
				Box = true,
				TextXAlignment = "Left",
				TextSize = 15,
				Opened = true
			})
			t1.value12 = color38.Toggle
			t1.value12(color38, {
				Title = "Auto Buy Upgrades",
				Desc = "Auto-buy selected base upgrades each Skip vote",
				Flag = "WaveAutoBuyUpgrades",
				Value = false,
				Callback = function(p236)
					value82.Config.WaveAutoBuyUpgrades = p236
				end
			})
			t1.value12 = color38.Dropdown
			color37 = {
				Title = "Buy Upgrades",
				Desc = "Upgrades to buy each wave vote (empty = none)",
				Flag = "WaveSelectedUpgrades",
				Values = value82.Wave.UPGRADES,
				Value = {},
				Multi = true,
				AllowNone = true,
				Callback = function(p237)
					local waveSelectedUpgrades = {}

					if type(p237) ~= "table" then
						value82.Config.WaveSelectedUpgrades = waveSelectedUpgrades

						return
					end

					for _, v in ipairs(p237) do
						waveSelectedUpgrades[#waveSelectedUpgrades + 1] = v
					end

					value82.Config.WaveSelectedUpgrades = waveSelectedUpgrades
				end
			}
			t1.value12(color38, color37)
			t1.value10:Divider()
			t1.value12 = t1.value10:Section({
				Title = "Voting",
				Box = true,
				TextXAlignment = "Left",
				TextSize = 15,
				Opened = true
			})
			t1.value12:Toggle({
				Title = "Auto Vote",
				Desc = "Auto vote to proceed/skip each wave",
				Flag = "WaveAutoVote",
				Value = true,
				Callback = function(p238)
					value82.Config.WaveAutoVote = p238
				end
			})
			t1.value10:Divider()
			color38 = t1.value10:Section({
				Title = "Auto Create",
				Box = true,
				TextXAlignment = "Left",
				TextSize = 15,
				Opened = true
			})
			t1.value23 = color38.Toggle
			t1.value23(color38, {
				Title = "Return to Lobby After",
				Desc = "Leave to lobby when wave session ends",
				Flag = "WaveReturnLobby",
				Value = false,
				Callback = function(p239)
					value82.Config.WaveReturnLobby = p239
				end
			})
			color38:Slider({
				Title = "Wave Threshold",
				Desc = "Die at this wave number to end session (0 = disabled)",
				Flag = "WaveThreshold",
				Step = 1,
				Value = {
					Min = 0,
					Max = 50,
					Default = 0
				},
				Callback = function(p240)
					local Config = value82.Config
					local v2043 = tonumber(p240) or 0

					Config.WaveThreshold = math.max(0, v2043)
				end
			})
			t1.value23 = color38.Toggle
			t1.value23(color38, {
				Title = "Auto Create Session",
				Desc = "Automatically create and run wave sessions",
				Flag = "AutoWave",
				Value = false,
				Callback = function(p241)
					value82.Lobby.sched.wave = p241

					local autoWave

					if not p241 then
						if p241 then
							autoWave = value82.Tasks.autoWave

							if value82.Lobby.restoring or (not value5() or autoWave:isRunning()) then
								value82.UI.saveConfig()

								return
							end

							t2.value7("IndependentLayer: start " .. autoWave.name)
							autoWave:start()
						else
							value82.Tasks.autoWave:stop()
						end

						value82.UI.saveConfig()

						return
					end

					p241 = value5()

					if p241 then
						autoWave = value82.Tasks.autoWave

						if value82.Lobby.restoring or (not value5() or autoWave:isRunning()) then
							value82.UI.saveConfig()

							return
						end

						t2.value7("IndependentLayer: start " .. autoWave.name)
						autoWave:start()
					else
						value82.Tasks.autoWave:stop()
					end

					value82.UI.saveConfig()
				end
			})
			t1.value23 = color38.Button
			t1.value23(color38, {
				Title = "Create Once Now",
				Desc = "Single wave session immediately",
				Callback = function()
					if value5() then
						task.spawn(value82.Wave.createStartOnce)
					end
				end
			})
			color39 = color39:Tab({
				Title = "Character Slots",
				Icon = "users"
			}):Section({
				Title = "Character Slot Settings",
				Box = true,
				TextXAlignment = "Left",
				TextSize = 15,
				Opened = true
			})
			color39.Dropdown(color39, {
				Title = "Active Slot",
				Desc = "Character slot to select on the Main Menu",
				Flag = "CharSlots",
				Values = { "A", "B", "C" },
				Value = "A",
				Multi = false,
				AllowNone = false,
				Callback = function(p242)
					local v2045 = type(p242) == "string" and p242 and p242 or (type(p242) == "table" and next(p242) or "A")

					value82.Lobby.charSlots = { v2045 }
					value82.Runtime.charSlotIndex = 1
				end
			})
			color39.Toggle(color39, {
				Title = "Auto Select Character",
				Desc = "Select slot and go to Lobby (Main Menu only)",
				Flag = "AutoSelectChar",
				Value = false,
				Callback = function(p243)
					if game.PlaceId == value82.PLACE.MainMenu then
						if p243 then
							value82.Tasks.autoSelectChar:start()

							return
						else
							value82.Tasks.autoSelectChar:stop()

							return
						end
					end
				end
			})
			color39 = value132:Section({
				Title = "Automization",
				Icon = "refresh-ccw",
				Opened = false
			})
			t1.value24 = color39:Tab({
				Title = "Titan Mastery",
				Icon = "swords"
			}):Section({
				Title = "Titan Mastery",
				Box = true,
				TextXAlignment = "Left",
				TextSize = 15,
				Opened = true
			})
			t1.value24:Paragraph({
				Title = "How it works",
				Desc = "Set up your titan serum + 5 shifter skills in the LOBBY first. In-game, enable Auto Farm, then enable this. It shifts into your titan, rotates all 5 skills + M1-punches to grind mastery XP, ejects naturally when the awakening bar empties, refills via blade farm, then re-shifts."
			})
			t1.value27 = value82.Config.AutoTitanMastery

			function t1.value28(p244)
				value82.Config.AutoTitanMastery = p244
				t2.value7("TitanMastery: toggle =", p244, "farming =", value82.Runtime.farming)

				if p244 then
					if value82.Runtime.farming then
						value82.Runtime.titanShifted = false
						value82.Tasks.titanMastery:start()
						t2.value7("TitanMastery: task started via toggle")

						return
					else
						notify("Auto Titan Mastery", "Enable Auto Farm first titan mode only runs while farming.", 5, "info")

						return
					end
				else
					value82.Tasks.titanMastery:stop()
					value82.Runtime.titanShifted = false
					t2.value7("TitanMastery: task stopped via toggle")
				end
			end

			t1.value24:Toggle({
				Title = "Auto Titan Mastery",
				Desc = "Requires Auto Farm ON. Grinds titan skill mastery XP while farming.",
				Flag = "AutoTitanMastery",
				Value = t1.value27,
				Callback = t1.value28
			})
			color38 = color39:Tab({
				Title = "Family",
				Icon = "zap"
			})
			t1.value25 = value82.UI.paragraphs
			t1.value26 = color38:Paragraph({
				Title = "Status",
				Desc = "Idle."
			})
			t1.value25.family = t1.value26
			color38:Divider()
			t1.value25 = color38:Section({
				Title = "Target Family (This only works if you opened family UI in customization)",
				Box = true,
				TextXAlignment = "Left",
				TextSize = 15,
				Opened = true
			})
			t1.value14 = value82.Family.EPIC
			t1.value27 = {}
			color38 = t1.value25.Dropdown

			function t1.value24(p245)
				value82.Lobby.family.epics = v1773(p245)
				value82.Family.updateTargets()
			end

			color38(t1.value25, {
				Title = "Epic Families",
				Values = t1.value14,
				Value = t1.value27,
				Multi = true,
				AllowNone = true,
				Flag = "TargetEpics",
				Callback = t1.value24
			})
			color38 = t1.value25.Dropdown
			t1.value14 = value82.Family.LEGEND
			t1.value27 = {}

			function t1.value24(p246)
				value82.Lobby.family.legends = v1773(p246)
				value82.Family.updateTargets()
			end

			color38(t1.value25, {
				Title = "Legendary Families",
				Values = t1.value14,
				Value = t1.value27,
				Multi = true,
				AllowNone = true,
				Flag = "TargetLegends",
				Callback = t1.value24
			})
			t1.value14 = value82.Family.MYTHIC
			t1.value27 = {}
			color38 = t1.value25.Dropdown

			function t1.value24(p247)
				value82.Lobby.family.mythics = v1773(p247)
				value82.Family.updateTargets()
			end

			color38(t1.value25, {
				Title = "Mythic Families",
				Values = t1.value14,
				Value = t1.value27,
				Multi = true,
				AllowNone = true,
				Flag = "TargetMythics",
				Callback = t1.value24
			})
			t1.value25.Toggle(t1.value25, {
				Title = "Auto Store",
				Desc = "Store the found family then keep rolling for more",
				Flag = "FamilyAutoStore",
				Value = false,
				Callback = function(p248)
					value82.Family.autoStore = p248
				end
			})
			color38 = t1.value25.Toggle

			function t1.value28(p249)
				if p249 then
					value82.Tasks.familySpin:start()
				else
					value82.Tasks.familySpin:stop()
					t2.value1.GuiService.SelectedObject = nil
					value4("[||] Stopped.")
				end
			end

			color38(t1.value25, {
				Title = "Auto Spin",
				Desc = "Spin until target found",
				Flag = "AutoSpin",
				Callback = t1.value28
			})
			color38 = color39:Tab({
				Title = "Gear",
				Icon = "sword"
			})
			t1.value26 = value82.UI.paragraphs
			color37 = color38:Paragraph({
				Title = "Auto Upgrade Gear Status",
				Desc = "Idle."
			})
			t1.value26.gear = color37
			color38:Divider()
			t1.value26 = color38:Section({
				Title = "Upgrade Settings",
				Box = true,
				TextXAlignment = "Left",
				TextSize = 15,
				Opened = true
			})
			t1.value28 = { "Blades", "Spears" }
			color37 = t1.value26.Dropdown

			function t1.value24(p250)
				value82.Lobby.autoUpgrade.weapon = p250
			end

			color37(t1.value26, {
				Title = "Weapon",
				Desc = "Weapon to upgrade (This Decide ur Farm Weapon)",
				Values = t1.value28,
				Value = "Blades",
				Flag = "Weapon",
				Callback = t1.value24
			})
			color38:Divider()
			color38 = color38:Section({
				Title = "Control",
				Box = true,
				TextXAlignment = "Left",
				TextSize = 15,
				Opened = true
			})
			color38.Toggle(color38, {
				Title = "Auto Upgrade Gear",
				Desc = "Automatically upgrade gear in the lobby",
				Flag = "AutoUpgradeGears",
				Value = false,
				Callback = function(p251)
					value82.Lobby.sched.gear = p251

					local autoUpgrade

					if not p251 then
						if p251 then
							autoUpgrade = value82.Tasks.autoUpgrade

							if value82.Lobby.restoring or (not value5() or autoUpgrade:isRunning()) then
								value82.UI.saveConfig()

								return
							end

							t2.value7("IndependentLayer: start " .. autoUpgrade.name)
							autoUpgrade:start()
						else
							value82.Tasks.autoUpgrade:stop()
						end

						value82.UI.saveConfig()

						return
					end

					p251 = value5()

					if p251 then
						autoUpgrade = value82.Tasks.autoUpgrade

						if value82.Lobby.restoring or (not value5() or autoUpgrade:isRunning()) then
							value82.UI.saveConfig()

							return
						end

						t2.value7("IndependentLayer: start " .. autoUpgrade.name)
						autoUpgrade:start()
					else
						value82.Tasks.autoUpgrade:stop()
					end

					value82.UI.saveConfig()
				end
			})
			color38 = color39:Tab({
				Title = "Skill Upgrade",
				Icon = "zap"
			})
			value82.UI.paragraphs.skill = color38:Paragraph({
				Title = "Auto Skill Upgrade Status",
				Desc = "Idle. Enable below to start unlocking skill nodes."
			})
			color38:Divider()
			color37 = color38:Section({
				Title = "Skill Paths",
				Box = true,
				TextXAlignment = "Left",
				TextSize = 15,
				Opened = true
			})
			t1.value14 = color37.Dropdown
			t1.value14(color37, {
				Title = "Offense Path",
				Desc = "Auto Skill Upgrade: Offense branch",
				Values = { "Offense → Damage", "Offense → Crit DMG" },
				Value = "Offense → Damage",
				Flag = "AutoSkillOffensePath",
				Callback = function(p252)
					value82.Lobby.autoSkill.offense = p252
				end
			})
			t1.value14 = color37.Dropdown
			t1.value14(color37, {
				Title = "Defense Path",
				Desc = "Auto Skill Upgrade: Defense branch",
				Values = { "Defense → Health", "Defense → Tank" },
				Value = "Defense → Tank",
				Flag = "AutoSkillDefensePath",
				Callback = function(p253)
					value82.Lobby.autoSkill.defense = p253
				end
			})
			color37:Dropdown({
				Title = "Support Path",
				Desc = "Auto Skill Upgrade: Support branch",
				Values = { "Support → Regen", "Support → Injury" },
				Value = "Support → Injury",
				Flag = "AutoSkillSupportPath",
				Callback = function(p254)
					value82.Lobby.autoSkill.support = p254
				end
			})
			color38:Divider()
			t1.value14 = color38:Section({
				Title = "Upgrade Strategy",
				Box = true,
				TextXAlignment = "Left",
				TextSize = 15,
				Opened = true
			})
			t1.value14.Dropdown(t1.value14, {
				Title = "Strategy",
				Desc = "Focus = one full path at a time. Balanced = rotate nodes.",
				Values = {
					"Focus Offense First",
					"Focus Defense First",
					"Focus Support First",
					"Balanced"
				},
				Value = "Focus Offense First",
				Flag = "Strategy",
				Callback = function(p255)
					value82.Lobby.autoSkill.strategy = p255
				end
			})
			color38:Divider()
			color37 = color38:Section({
				Title = "Perk Slots",
				Box = true,
				TextXAlignment = "Left",
				TextSize = 15,
				Opened = true
			})
			t1.value27 = color37.Dropdown
			t1.value27(color37, {
				Title = "Perk Slot Priority",
				Desc = "Unlock these perk slots FIRST. Empty = skip.",
				Values = { "Offense", "Defense", "Support" },
				Value = {},
				Multi = true,
				AllowNone = true,
				Flag = "AutoSkillPerkCategories",
				Callback = function(p256)
					local perkOrder = {}

					for _, v in ipairs({ "Offense", "Defense", "Support" }) do
						local v2050 = false

						if type(p256) == "table" then
							for _, v2 in ipairs(p256) do
								if v2 == v then
									v2050 = true

									break
								end
							end

							local v2053 = not v2050

							if v2053 then
								v2053 = p256[v]
							end

							if v2053 then
								v2050 = true
							end
						end

						if v2050 then
							perkOrder[#perkOrder + 1] = v
						end
					end

					value82.Lobby.autoSkill.perkOrder = perkOrder
				end
			})
			color38:Divider()
			t1.value27 = color38:Section({
				Title = "Auto Skill Upgrade",
				Box = true,
				TextXAlignment = "Left",
				TextSize = 15,
				Opened = true
			})
			t1.value27.Toggle(t1.value27, {
				Title = "Auto Skill Upgrade",
				Desc = "Automatically upgrade skills in the lobby",
				Flag = "AutoUpgradeSkills",
				Value = false,
				Callback = function(p257)
					value82.Lobby.sched.skill = p257

					local autoSkill

					if not p257 then
						if p257 then
							autoSkill = value82.Tasks.autoSkill

							if value82.Lobby.restoring or (not value5() or autoSkill:isRunning()) then
								value82.UI.saveConfig()

								return
							end

							t2.value7("IndependentLayer: start " .. autoSkill.name)
							autoSkill:start()
						else
							value82.Tasks.autoSkill:stop()
						end

						value82.UI.saveConfig()

						return
					end

					p257 = value5()

					if p257 then
						autoSkill = value82.Tasks.autoSkill

						if value82.Lobby.restoring or (not value5() or autoSkill:isRunning()) then
							value82.UI.saveConfig()

							return
						end

						t2.value7("IndependentLayer: start " .. autoSkill.name)
						autoSkill:start()
					else
						value82.Tasks.autoSkill:stop()
					end

					value82.UI.saveConfig()
				end
			})
			color38 = color39:Tab({
				Title = "Thunder Spear",
				Icon = "antenna"
			})
			t1.value28 = value82.UI.paragraphs
			color37 = color38:Paragraph({
				Title = "Thunder Spear Questline",
				Desc = "Auto-runs the Spear quests in order. Open the Regiment quest panel once if progress can\'t be read."
			})
			t1.value28.thunder = color37
			color38:Divider()
			t1.value28 = color38:Section({
				Title = "Quest Progress",
				Box = true,
				TextXAlignment = "Left",
				TextSize = 15,
				Opened = true
			})

			local v2055 = t1.value28:Paragraph({
				Title = "Progress",
				Desc = "Press Refresh (shows last-known if panel unavailable)."
			})

			local function v2056(p258, p259)
				local t89 = {}

				for _, quest in ipairs(value82.Thunder.QUESTS) do
					local v2060 = value82.Thunder.missionDone(quest, p258)

					t89[#t89 + 1] = (v2060 and "✓ " or v2060 or "• ") .. quest.name .. ":"

					for _, tag in ipairs(quest.tags) do
						local v2063 = p258[tag]

						if v2063 then
							v2063 = v2063.claimed and "✓ claimed" or (v2063.locked and "locked" or v2063.current .. "/" .. v2063.target)
						end

						t89[#t89 + 1] = "    " .. tag .. ": " .. (v2063 or "?")
					end
				end

				if not p259 then
					value82.UI.setParagraph(v2055, table.concat(t89, "\n"))

					return
				end

				t89[#t89 + 1] = "(cached open the quest panel for live data)"
				value82.UI.setParagraph(v2055, table.concat(t89, "\n"))
			end
			local function v2064()
				task.spawn(function()
					local v2065 = value82.Thunder.readProgress()

					if next(v2065) then
						if next(v2065) then
							v2056(v2065, false)
						elseif next(value82.Lobby.questCache or {}) then
							v2056(value82.Lobby.questCache, true)

							return
						else
							value82.UI.setParagraph(v2055, "No data yet open the Regiment Spear quest panel once.")

							return
						end

						return
					end

					v2065 = value82.Thunder.openPanelAndRead(4)

					if next(v2065) then
						v2056(v2065, false)
					elseif next(value82.Lobby.questCache or {}) then
						v2056(value82.Lobby.questCache, true)

						return
					else
						value82.UI.setParagraph(v2055, "No data yet open the Regiment Spear quest panel once.")

						return
					end
				end)
			end

			t1.value28:Button({
				Title = "Refresh Progress",
				Desc = "Read quest progress (live from panel, else last-known)",
				Callback = v2064
			})
			color38 = color38:Section({
				Title = "Control",
				Box = true,
				TextXAlignment = "Left",
				TextSize = 15,
				Opened = true
			})
			color38.Toggle(color38, {
				Title = "Auto Thunder Quest",
				Desc = "Auto-run the Spear questline in order, looping each return to lobby",
				Flag = "AutoThunder",
				Value = false,
				Callback = function(p260)
					if p260 then
						value82.Lobby.thunderMode = true
						value82.Lobby.thunderRan = {}

						if isInGame() then
							v1070("In game farming the current objective...")
							value82.Thunder.beginFarming()

							return
						else
							v2064()
							value82.Tasks.thunder:start()

							return
						end
					end

					value82.Lobby.thunderMode = false
					value82.Tasks.thunder:stop()

					local function v2066()
						t2.value1.GuiService.SelectedObject = nil
					end

					value82.Thunder.endFarming()
					pcall(v2066)
					v1070("Idle.")
				end
			})
			color39 = color39:Tab({
				Title = "Prestige",
				Icon = "award"
			})
			t1.value24 = color39:Section({
				Title = "Auto Prestige (Lobby only)",
				Box = true,
				TextXAlignment = "Left",
				TextSize = 15,
				Opened = true
			})
			value82.UI.paragraphs.prestige = t1.value24:Paragraph({
				Title = "Prestige Status",
				Desc = "Idle. Set a Min Gold per tier (0 = prestige immediately), then enable Auto Prestige."
			})
			color39:Divider()

			for i = 1, 5 do
				color36 = color39:Section({
					Title = "Prestige " .. i - 1 .. " → " .. i,
					Box = true,
					TextXAlignment = "Left",
					TextSize = 15,
					Opened = true
				})
				color35 = "PrestigeGold" .. i
				AddTheme = value82.Config.PrestigeGold[i] or 0
				color35 = {
					Title = "Min Gold",
					Desc = "Wait until Gold reaches this before prestiging. Empty/0 = prestige immediately when eligible.",
					Flag = color35,
					InputIcon = "coins",
					Type = "Input",
					Placeholder = "e.g. 5000000  (0 = immediate)",
					Value = tostring(AddTheme),
					Callback = function(p261)
						local v2068 = tostring(p261 or ""):gsub("[%s,]", "")
						local PrestigeGold = value82.Config.PrestigeGold
						local v2070 = i
						local v2071 = tonumber(v2068) or 0

						PrestigeGold[v2070] = math.max(0, v2071)
					end
				}
				color36.Input(color36, color35)
				color35 = {
					Title = "Boost",
					Desc = "Boost to pick at this tier",
					Flag = "PrestigeBoost" .. i,
					Value = value82.Config.PrestigeBoost[i] or "Gold",
					Values = { "Luck", "EXP", "Gold" },
					Callback = function(p262)
						value82.Config.PrestigeBoost[i] = value82.Mission.asStr(p262)
					end
				}
				color36.Dropdown(color36, color35)
			end

			color39:Divider()
			color39 = color39:Section({
				Title = "Control",
				Box = true,
				TextXAlignment = "Left",
				TextSize = 15,
				Opened = true
			})
			color39.Toggle(color39, {
				Title = "Auto Prestige",
				Desc = "Rebirth automatically when eligible + Gold gate met",
				Flag = "AutoPrestige",
				Value = value82.Config.AutoPrestige,
				Callback = function(p263)
					value82.Config.AutoPrestige = p263
					value82.Lobby.sched.prestige = p263

					local autoPrestige

					if not p263 then
						if p263 then
							autoPrestige = value82.Tasks.autoPrestige

							if value82.Lobby.restoring or (not value5() or autoPrestige:isRunning()) then
								value82.UI.saveConfig()

								return
							end

							t2.value7("IndependentLayer: start " .. autoPrestige.name)
							autoPrestige:start()
						else
							value82.Tasks.autoPrestige:stop()
						end

						value82.UI.saveConfig()

						return
					end

					p263 = value5()

					if p263 then
						autoPrestige = value82.Tasks.autoPrestige

						if value82.Lobby.restoring or (not value5() or autoPrestige:isRunning()) then
							value82.UI.saveConfig()

							return
						end

						t2.value7("IndependentLayer: start " .. autoPrestige.name)
						autoPrestige:start()
					else
						value82.Tasks.autoPrestige:stop()
					end

					value82.UI.saveConfig()
				end
			})
			color39 = value82.UI.Window:Section({
				Title = "Configuration",
				Icon = "wrench",
				Opened = false
			}):Tab({
				Title = "Configuration",
				Icon = "settings"
			})

			local v2073 = color39:Paragraph({
				Title = "Config Manager",
				Desc = "Create named presets of your current settings."
			})

			local function v2074(p264)
				value82.UI.setParagraph(v2073, p264)
			end

			color39:Divider()
			color38 = color39:Section({
				Title = "Preset Manager",
				Box = true,
				TextXAlignment = "Left",
				TextSize = 15,
				Opened = true
			})
			color38.Input(color38, {
				Title = "Preset Name",
				Desc = "Type a name to create or reference an existing preset.",
				Flag = "ConfigNameInput",
				InputIcon = "pencil",
				Placeholder = "e.g. raid_aberrant",
				Value = "",
				Callback = function(p265)
					value82.ConfigManager._selectedName = p265 and p265:match("^%s*(.-)%s*$") or ""
				end
			})

			local function v2075()
				return value82.ConfigManager.list()
			end

			color37 = {
				Title = "Saved Presets",
				Desc = "Select a saved preset to load or delete.",
				Flag = "ConfigList",
				Values = v2075(),
				Value = "",
				AllowNone = true,
				Callback = function(p266)
					local loaded = type(p266) == "string" and p266 and p266 or ""

					value82.ConfigManager._selectedName = loaded

					local function v2077()
						local Flags = value82.UI.Window.Flags

						if Flags then
							Flags = value82.UI.Window.Flags.ConfigNameInput
						end

						if not Flags then
							return
						end

						Flags:Set(loaded)
					end

					pcall(v2077)

					if loaded == "" then
						return
					end

					local v2079, loadFailed = value82.ConfigManager.load(loaded)

					if v2079 then
						notify("Config", "Preset \'" .. loaded .. "\' loaded.", 3, "check")
						v2074("Loaded: " .. loaded)

						return
					end

					notify("Config", "Load failed: " .. loadFailed, 4, "x-circle")
					v2074("Error: " .. loadFailed)
				end
			}

			local v2081 = color38.Dropdown(color38, color37)

			color38.Button(color38, {
				Title = "Save Preset",
				Desc = "Save current settings under the typed name.",
				Callback = function()
					local _selectedName = value82.ConfigManager._selectedName
					local v2083, saveFailed = value82.ConfigManager.save(_selectedName)

					if not v2083 then
						notify("Config", "Save failed: " .. saveFailed, 4, "x-circle")
						v2074("Error: " .. saveFailed)

						return
					end

					notify("Config", "Preset \'" .. _selectedName .. "\' saved.", 3, "check")
					v2074("Saved: " .. _selectedName)

					local v2085 = v2075()

					local function v2086()
						v2081:Refresh(v2085)
					end

					pcall(v2086)
				end
			})
			color38.Button(color38, {
				Title = "Load Preset",
				Desc = "Apply the selected preset to all settings.",
				Callback = function()
					local _selectedName = value82.ConfigManager._selectedName
					local t90 = { value82.ConfigManager.load(_selectedName) }
					local loadFailed = t90[2]

					if t90[1] then
						notify("Config", "Preset \'" .. _selectedName .. "\' loaded.", 3, "check")
						v2074("Loaded: " .. _selectedName)
					else
						notify("Config", "Load failed: " .. loadFailed, 4, "x-circle")
						v2074("Error: " .. loadFailed)
					end
				end
			})
			color38.Button(color38, {
				Title = "Reset to Defaults",
				Desc = "Restore all settings to their default values.",
				Callback = function()
					value82.ConfigManager.reset()
					notify("Config", "All settings reset to defaults.", 3, "refresh-cw")
					v2074("Reset to defaults.")
				end
			})
			color38.Button(color38, {
				Title = "Delete Preset",
				Desc = "Permanently remove the selected preset.",
				Callback = function()
					local _selectedName = value82.ConfigManager._selectedName
					local t91 = { value82.ConfigManager.delete(_selectedName) }
					local deleteFailed = t91[2]

					if not t91[1] then
						notify("Config", "Delete failed: " .. deleteFailed, 4, "x-circle")
						v2074("Error: " .. deleteFailed)

						return
					end

					notify("Config", "Preset \'" .. _selectedName .. "\' deleted.", 3, "trash-2")
					v2074("Deleted: " .. _selectedName)
					value82.ConfigManager._selectedName = ""

					local function v2093()
						local Flags = value82.UI.Window.Flags

						if Flags then
							Flags = value82.UI.Window.Flags.ConfigNameInput
						end

						if not Flags then
							return
						end

						Flags:Set("")
					end

					pcall(v2093)

					local v2095 = v2075()

					local function v2096()
						v2081:Refresh(v2095)
					end

					pcall(v2096)
				end
			})
			color39:Divider()
			color39 = color39:Section({
				Title = "Appearance",
				Box = true,
				TextXAlignment = "Left",
				TextSize = 15,
				Opened = true
			})
			color39.Dropdown(color39, {
				Title = "Theme",
				Desc = "Change the UI color theme.",
				Values = color310,
				Value = "Dark",
				Flag = "ThemeSettings",
				Callback = function(p267)
					t2.value8:SetTheme(p267)
				end
			})
			value132:Divider()
			value82.UI.ConfigManager = value132.ConfigManager
			color310 = t2.value3.Name .. "_config"
			value82.UI.config = value82.UI.ConfigManager:CreateConfig(color310)
			value82.Lobby.restoring = true
			pcall(function()
				value82.UI.config:Load()
			end)
			value82.Lobby.missionMap = value82.Mission.asStr(value82.Lobby.missionMap)
			value82.Lobby.missionObjective = value82.Mission.asStr(value82.Lobby.missionObjective)

			local v2097 = value82.Mission.objectivesFor(value82.Lobby.missionMap)

			color310 = value82.Lobby.missionObjective

			local objective = value82.UI.dropdowns.objective

			if objective then
				pcall(function()
					objective:Refresh(v2097)
				end)

				if color310 == "" then
					color39 = false
				else
					color39 = table.find(v2097, color310)
				end

				if color39 then
					value82.UI.selectDropdown(objective, color310)
				else
					value82.Lobby.missionObjective = v2097[1]
					value82.UI.selectDropdown(objective, v2097[1])
				end
			end

			color310 = t2.value7
			color39 = value82.Lobby.missionMap
			color39 = tostring(color39)
			color38 = value82.Lobby.missionObjective
			color310("Config reconcile: map=" .. color39 .. " objective=" .. tostring(color38))

			for i = 1, 5 do
				pcall(function()
					local Flags = value132.Flags

					if Flags then
						Flags = value132.Flags["PrestigeGold" .. i]
					end

					if Flags then
						Flags:Set(tostring(value82.Config.PrestigeGold[i] or 0))
					end

					local Flags2 = value132.Flags

					if Flags2 then
						Flags2 = value132.Flags["PrestigeBoost" .. i]
					end

					if not Flags2 then
						return
					end

					Flags2:Set(value82.Config.PrestigeBoost[i] or "Gold")
				end)
			end

			local function onClose()
				if value82.Lobby.teleporting then
					return
				end

				local function v2103()
					if not value82.UI.config then
						return
					end

					value82.UI.config:Save()
				end

				pcall(v2103)
			end

			value82.Lobby.restoring = false
			pcall(function()
				value82.Connection.add("Teleport", t2.value3.OnTeleport:Connect(function(p268)
					local TeleportState = Enum.TeleportState

					if not ((p268 == TeleportState.RequestedFromServer or p268 == TeleportState.Started) and true or p268 == TeleportState.InProgress) then
						if p268 ~= TeleportState.Failed then
							return
						end

						value82.Lobby.teleporting = false

						return
					end

					if value82.Lobby.teleporting then
						value82.Lobby.teleporting = true

						return
					end

					local function v2105()
						if not value82.UI.config then
							return
						end

						value82.UI.config:Save()
					end

					pcall(v2105)
					value82.DB.save()
					value82.Lobby.teleporting = true
				end))
			end)
			pcall(function()
				local OnClose = value132.OnClose

				if type(OnClose) == "function" then
					value132:OnClose(onClose)
				else
					value132.OnClose = onClose
				end
			end)
			pcall(function()
				local OnDestroy = value132.OnDestroy

				if type(OnDestroy) == "function" then
					value132:OnDestroy(onClose)
				else
					value132.OnDestroy = onClose
				end
			end)
			value82.DB.load()

			for k, v in pairs(value82.UI.statsUI) do
				color36 = value82.UI.setParagraph
				k = value82.Stats[k] or 0
				color36(v, (tostring(k)))
			end

			if next(value82.Lobby.questCache or {}) then
				v2056(value82.Lobby.questCache, true)
			end

			task.spawn(function()
				value82.DataCopy.fetch(true)

				local v2110 = value82.Stats.potential and not value82.ExtConfig

				if v2110 then
					v2110 = value82.ExtConfig.Difficulty ~= nil
				end

				if v2110 then
					local v2111 = value82.DataCopy.highestDifficulty(value82.Stats.potential)

					value82.Lobby.missionDifficulty = v2111
					value82.UI.selectDropdown(value82.UI.dropdowns.difficulty, v2111)
					t2.value7("Difficulty set from live fetch:", v2111, "(potential=" .. value82.Stats.potential .. ")")
				end

				if not value82.LOBBY_PLACE_IDS[game.PlaceId] then
					return
				end

				local attribute = t2.value3:GetAttribute("Blacklisted")
				local attribute2 = t2.value3:GetAttribute("Exploiter")

				if attribute == true and true or attribute2 == true then
					value82.Stats.shadowBan = true
				end

				value82.StatsWebhook.checkEvents()
			end)
			value82.Connection.add("Ancestry", t2.value3.AncestryChanged:Connect(function()
				if t2.value3.Parent then
					return
				end

				value82.DB.save()
				onClose()
			end))
			value82.Connection.add("PerfReapply", t2.value3.CharacterAdded:Connect(function()
				if not value82.Config.RemoveFog then
					return
				end

				value82.Perf._origAtmoDensity = nil
				task.wait(0.5)
				value82.Perf.applyAll()
			end))
			value82.Runtime.rejoining = false
			value82.Connection.add("AutoRejoin", t2.value1.GuiService.ErrorMessageChanged:Connect(function(p269)
				if not p269 or p269 == "" then
					return
				end

				if value82.Runtime.rejoining then
					return
				end

				value82.Runtime.rejoining = true
				t2.value7("AutoRejoin: error detected —", p269)
				task.spawn(function()
					for i = 1, 6 do
						local ok = pcall(function()
							t2.value1.Teleport:Teleport(value82.PLACE.MainMenu, t2.value3)
						end)

						t2.value7(string.format("AutoRejoin: teleport attempt %d/%d (ok=%s)", i, 6, (tostring(ok))))
						task.wait(3)

						if game.PlaceId == value82.PLACE.MainMenu then
							value82.Runtime.rejoining = false

							return
						end
					end

					value82.Runtime.rejoining = false
				end)
			end))

			local function v2116()
				if workspace:GetAttribute("Rewarded") or workspace:GetAttribute("Force_End") then
					return
				end

				value82.Runtime.rewardedTick = 0

				if not isInGame() then
					return
				end

				value82.Runtime.sessionStartTick = tick()
				t2.value7("RoundWatch: new round — watchdog re-armed")
			end

			value82.Connection.add("Rewarded", workspace:GetAttributeChangedSignal("Rewarded"):Connect(function()
				if workspace:GetAttribute("Rewarded") then
					value82.Reward.onRewarded()
				else
					v2116()
				end
			end))
			value82.Connection.add("ForceEnd", workspace:GetAttributeChangedSignal("Force_End"):Connect(function()
				if workspace:GetAttribute("Force_End") == true then
					value82.Runtime.rewardedTick = tick()
					value82.Reward.onFailed()
				else
					v2116()
				end
			end))
			value82.Connection.add("RewardUIWatch", task.spawn(function()
				local v2117 = false

				while true do
					task.wait(0.5)

					local farming = value82.Runtime.farming

					if farming then
						farming = isInGame()
					end

					local Visible

					if farming then
						local v2120 = value82.Util.safeIndex(t2.value4, "Interface", "Rewards")

						Visible = v2120 and v2120.Visible or false

						local v2121

						if Visible then
							v2121 = not (v2117 or workspace:GetAttribute("Rewarded"))

							if v2121 then
								v2121 = not workspace:GetAttribute("Force_End")
							end
						else
							v2121 = Visible
						end

						if v2121 then
							task.wait(0.6)

							local farming2 = value82.Runtime.farming

							if farming2 then
								farming2 = isInGame()

								if farming2 then
									farming2 = not (workspace:GetAttribute("Rewarded") or workspace:GetAttribute("Force_End"))

									if farming2 then
										farming2 = (value82.Util.safeIndex(t2.value4, "Interface", "Rewards") or {}).Visible
									end
								end
							end

							if farming2 then
								t2.value7("RewardUIWatch: Rewards UI visible without Rewarded/Force_End — handling as fail")
								value82.Runtime.rewardedTick = tick()
								value82.Reward.onFailed()
							end
						end
					else
						Visible = false
					end

					v2117 = Visible
				end
			end))
			value82.Connection.add("FarmStatusLoop", task.spawn(function()
				while true do
					repeat
						task.wait(5)
					until value82.Runtime.farming

					value82.UI.refreshFarmStatus()

					local v2123 = workspace:GetAttribute("Type") == "Waves" and 3600 or 420
					local v2124 = isInGame()

					local function v2125(p270)
						value82.Farm.stop()
						value82.Runtime.sessionStartTick = 0
						value82.Runtime.rewardedTick = 0
						task.delay(0.5, function()
							t2.value7("StuckLeave: teleporting to lobby (" .. p270 .. ")")

							if value82.Farm.leaveToLobby(30) then
								return
							end

							notify("Auto Farm", "StuckLeave: couldn\'t leave try manually.", 5, "alert-triangle")
						end)
					end

					if v2124 then
						v2124 = value82.Runtime.sessionStartTick == 0
					end

					if v2124 then
						value82.Runtime.sessionStartTick = tick()
						t2.value7("StuckWatch: stamped missing sessionStartTick (mid-game start)")
					end

					local v2126 = isInGame()

					if v2126 then
						v2126 = value82.Runtime.sessionStartTick > 0
					end

					if v2126 then
						if value82.Runtime.rewardedTick > 0 then
							if tick() - value82.Runtime.rewardedTick > 120 then
								t2.value7("StuckLeave: stuck on results/chest screen forcing lobby")
								notify("Auto Farm", "Stuck on results screen going back to lobby.", 5, "alert-triangle")
								v2125("post-reward")
							end
						else
							local v2127 = tick() - value82.Runtime.sessionStartTick

							if v2123 < v2127 then
								local value7 = t2.value7
								local v2129 = v2127 / 60

								value7("StuckLeave: pre-reward stuck", math.floor(v2129), "min — forcing lobby")

								local v2130 = notify
								local format = string.format
								local v2132 = v2127 / 60

								v2130("Auto Farm", format("Stuck %dm going back to lobby.", (math.floor(v2132))), 5, "alert-triangle")
								v2125("pre-reward")
							end
						end
					end
				end
			end))

			local function v2133()
				local v2134 = not isInGame()

				if v2134 then
					v2134 = value82.Runtime.farming or (value82.Tasks.reload:isRunning() or value82.Conn.Escape)
				end

				if not v2134 then
					return
				end

				notify("Auto Farm", "Stopped not in game area.", 4, "bell")

				if value82.Runtime.farming then
					value82.Farm.stop()

					local function v2135()
						local Flags = value132.Flags

						if Flags then
							Flags = value132.Flags.AutoFarm
						end

						if not Flags then
							return
						end

						Flags:Set(false)
					end

					pcall(v2135)
				end

				v617()
				value82.Connection.disconnect("Escape")
				value82.Connection.disconnect("NapeMonitor")
				value82.Connection.disconnect("NapeMonitorRemoved")
				value82.UI.refreshFarmStatus()
			end

			value82.Connection.add("LobbyMonitor", task.defer(function()
				local v2137 = isInGame()

				while true do
					task.wait(2)
					v2133()

					local v2138 = isInGame()
					local thunderMode

					if v2138 then
						thunderMode = value82.Lobby.thunderMode

						if thunderMode then
							thunderMode = not v2137
						end
					else
						thunderMode = v2138
					end

					if thunderMode then
						value82.Thunder.beginFarming()
					end

					if not v2137 and v2138 then
						value82.Runtime.sessionStartTick = tick()
						value82.Runtime.rewardedTick = 0
						t2.value7("LobbyMonitor: entered game, sessionStartTick reset")
						value82.RewardHook.reset()
						task.spawn(function()
							value82.DataCopy.fetch(true)
							t2.value7("LobbyMonitor: join-fetch done")
							value82.StatsWebhook.checkEvents()
						end)
					end

					if v2137 then
						v2137 = not v2138
					end

					if v2137 then
						task.spawn(function()
							value82.DataCopy.fetch(true)
							value82.DB.save()
							t2.value7("LobbyMonitor: leave-fetch done, DB saved")
							value82.StatsWebhook.checkEvents()
						end)

						local DB = value82.DB

						if DB then
							DB = value82.DB.save
						end

						if DB then
							value82.DB.save()
						end

						local potential = value82.Stats.potential
						local v2142

						if potential then
							v2142 = not value82.Lobby.questOverride

							if v2142 then
								v2142 = not (value82.Lobby.thunderMode or value82.ExtConfig)

								if v2142 then
									v2142 = value82.ExtConfig.Difficulty ~= nil
								end
							end
						else
							v2142 = potential
						end

						if v2142 then
							local v2143 = value82.DataCopy.highestDifficulty(potential)

							if v2143 ~= value82.Lobby.missionDifficulty then
								value82.Lobby.missionDifficulty = v2143
								value82.UI.selectDropdown(value82.UI.dropdowns.difficulty, v2143)
							end
						end

						task.spawn(function()
							value6(60)

							if value82.Lobby.thunderMode then
								value82.Tasks.thunder:start()

								return
							end

							if not value82.Lobby.schedActive() then
								return
							end

							value83()
						end)
						v2137 = v2138
					else
						v2137 = v2138
					end
				end
			end))
			value82.RewardHook.start()

			if value82.ExtConfig then
				local function v2144(p271)
					local config = value82.UI.config
					local v2146

					if config then
						local Elements = config.Elements

						if type(Elements) == "table" then
							v2146 = config.Elements[p271]
						else
							v2146 = false
						end
					else
						v2146 = config
					end

					if v2146 then
						return config.Elements[p271]
					elseif value132 then
						local PendingFlags = value132.PendingFlags
						local v2149

						if type(PendingFlags) == "table" then
							v2149 = value132.PendingFlags[p271]
						else
							v2149 = false
						end

						if v2149 then
							return value132.PendingFlags[p271]
						else
							local Flags = value132.Flags
							local v2151

							if type(Flags) == "table" then
								v2151 = value132.Flags[p271]
							else
								v2151 = false
							end

							if v2151 then
								return value132.Flags[p271]
							else
								return nil
							end
						end
					else
						return nil
					end
				end

				local t92 = {}

				color310 = function(p272)
					if t92[p272] then
						return
					end

					local v2153 = value82.ExtConfig[p272]

					if v2153 == nil then
						return
					end

					t92[p272] = true

					local v2154 = v2144(p272)

					if not v2154 then
						t2.value7("ExtConfig: no control for flag", p272)

						return
					end

					local v2155 = v2154.__type == "Dropdown"

					if not v2155 then
						local Select = v2154.Select

						v2155 = type(Select) == "function"

						if v2155 then
							local Set = v2154.Set

							v2155 = type(Set) ~= "function"
						end
					end

					if v2155 then
						local Select = v2154.Select

						v2155 = type(Select) == "function"
					end

					local ok, result

					if v2155 then
						ok, result = pcall(function()
							v2154:Select(v2153)
						end)
					else
						local Set = v2154.Set

						if type(Set) == "function" then
							ok, result = pcall(function()
								v2154:Set(v2153)
							end)
						else
							local Select = v2154.Select

							if type(Select) ~= "function" then
								t2.value7("ExtConfig: control", p272, "has no Set/Select")

								return
							end

							ok, result = pcall(function()
								v2154:Select(v2153)
							end)
						end
					end

					if ok then
						t2.value7("ExtConfig: applied", p272)
					else
						t2.value7("ExtConfig: apply(" .. p272 .. ") failed:", result)
					end
				end
				color310("Map")
				color310("Objective")
				color310("Difficulty")

				for k in pairs(value82.ExtConfig) do
					color310(k)
				end

				t2.value7("ExtConfig applied")
			end

			task.spawn(function()
				local getconnections_ = getconnections or get_signal_cons

				if getconnections_ then
					for _, v in pairs(getconnections_(t2.value3.Idled)) do
						if v.Disable then
							v:Disable()
						elseif v.Disconnect then
							v:Disconnect()
						end
					end

					return
				end

				local cloneref_ = cloneref and cloneref(game:GetService("VirtualUser")) or game:GetService("VirtualUser")

				t2.value3.Idled:Connect(function()
					cloneref_:CaptureController()
					cloneref_:ClickButton2(unpack_({ Vector2.new() }))
				end)
			end)
			t2.value7("mainV4 loaded. inGame =", isInGame())

			if isInGame() then
				return
			end

			task.spawn(function()
				task.wait(5)
				value6(60)
				value83()
			end)
		else
			pcall(function()
				game:GetService("StarterGui"):SetCore("SendNotification", {
					Title = "MahmutHub Error",
					Text = "Failed to load UI (network?). Try executing again.",
					Duration = 10
				})
			end)
		end
	end
end
