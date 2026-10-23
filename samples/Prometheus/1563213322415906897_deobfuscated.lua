-- This file was generated at discord.gg/syncrypt

local game_ = game
local t1 = {
	value2 = "GetService",
	value4 = 18063688655067
}

t1.value2 = game_:GetService("TweenService")

local t2 = {
	value1 = t1.value2,
	value2 = game:GetService("UserInputService")
}

game:GetService("RunService")
game:GetService("Stats")
t1.value8 = 22367117977775
t1.value3 = "game"
t1.value6 = "\27$\150\0054\'\17\184\31o*"

local game_2 = game

t1.value3 = "GetService"
t1.value7 = "r\134\218\1\250\157\173\21"
t1.value3 = game_2:GetService("HttpService")
t2.value3 = t1.value3

local Lighting = game:GetService("Lighting")

t1.value8 = "\154\205Bs\157\143\29\238q!n}Y\163\172D!"
t1.value5 = "game"
t1.value5 = game:GetService("ReplicatedStorage")
t2.value4 = t1.value5
t2.value5 = game:GetService("Players")
t2.value6 = t2.value5.LocalPlayer

local v6, v7, v8 = ipairs(Lighting:GetChildren())

t1.value6 = v6
t1.value7 = v7
t1.value8 = v8

while true do
	local v9, v10 = t1.value6(t1.value7, t1.value8)

	t1.value8 = v9
	t1.value10 = v10

	if not t1.value8 then
		break
	end

	t1.value12 = t1.value1
	t1.value11 = t1.value10:IsA("BlurEffect") or t1.value10:IsA("DepthOfFieldEffect")

	local value12 = t1.value12
	local value11 = t1.value11

	t1.value1 = value12
	t1.value9 = value11

	if t1.value11 then
		t1.value9 = not t1.value10.Name:lower():find("aim")
	end

	if t1.value9 then
		t1.value10.Enabled = false
	end
end

t2.value7 = nil

function t1.value8()
	t2.value7 = require(t2.value4:WaitForChild("GameManager", 5))
end

t1.value7 = "pcall"
t2.value7 = nil
pcall(t1.value8)
t1.value7 = t2.value4:FindFirstChild("Remotes")

local value7 = t1.value7

t1.value8 = t1.value1

if t1.value7 then
	value7 = t1.value7:FindFirstChild("PlayerCharacter")
end

t2.value8 = value7

local value72 = t1.value7

if t1.value7 then
	value72 = t1.value7:FindFirstChild("WeaponInventory")
end

if value72 then
	value72:FindFirstChild("Request_SetSelectedCosmetic")
end

t1.value16 = 21555347826485
t1.value17 = 30964894578771

local value8 = t1.value8

t1.value14 = 18047204221139
t1.value1 = value8
t1.value18 = 3027820971393
t1.value19 = 18446715576717
t1.value20 = 6762923478093
t1.value24 = 22431876212941
t1.value25 = 34226478399041
t1.value25 = 9968251441697
t1.value11 = {
	"Default",
	"Bloodluster",
	"Champion",
	"Christmas",
	"DarkMatter",
	"DeepBlue",
	"Flaming",
	"Oathbreaker"
}
t1.value22 = 31367903967502
t1.value16 = "Pb\167\160\22\246\17"
t1.value26 = 7955419631224
t1.value24 = 27088934891846
t1.value21 = 18533191344566
t1.value24 = ":\"E\189\'\133\132 \23"
t1.value19 = 14081792760221
t1.value19 = 28419280057265
t1.value13 = {
	"Default",
	"BronzeViper",
	"Celestial",
	"Magma",
	"Oathbreaker"
}
t1.value21 = 12401025635982
t1.value22 = 32335369419473
t1.value27 = 23335222979186
t1.value19 = "\18\206\217;\16Edt\23\19\171"
t1.value29 = "c\19q\135r]U"
t1.value14 = {
	"Default",
	"BronzeViper",
	"Christmas",
	"CrimsonFangs",
	"DarkMatter",
	"Draconic",
	"Golden",
	"Oathbreaker"
}
t1.value19 = 31322275133689
t1.value24 = "\249@\251\155\188l\236>"
t1.value22 = "\245\158Q,v\255i\252-"
t1.value18 = 29939078395509
t1.value25 = 34151152451102
t1.value20 = 18033234960589
t1.value31 = "\235G\17\221\195\248\1951"
t1.value21 = {
	"Default",
	"Bloodluster",
	"Golden",
	"Magma",
	"Oathbreaker"
}
t1.value20 = "\205\18ն/\1380M\246\160"
t1.value32 = 22517252810997
t1.value19 = {
	"Default",
	"DarkMatter",
	"Iceborn",
	"Oathbreaker",
	"Viper"
}
t1.value33 = 31905327020553
t1.value34 = "B\184\185;\131\25\150\5|K\156Q\141\178\144\196"
t1.value20 = 32786031344547
t1.value27 = "mv\129\239O\160\172"
t1.value30 = "m\168\134h|\242\214"
t1.value25 = {
	"Default",
	"Butterfly",
	"Draconic",
	"Oathbreaker",
	"Scorchflower"
}
t1.value36 = "\217w5\\\11$o"
t1.value27 = "]\229\188]\205I\r"
t2.value9 = {
	Katana = t1.value11,
	Kusarigama = t1.value13,
	Daggers = t1.value14,
	Naginata = {
		"Default",
		"Christmas",
		"DarkMatter",
		"DeepBlue",
		"Oathbreaker",
		"SerpentSlayer"
	},
	Gauntlets = t1.value21,
	Warhammer = t1.value19,
	CurvedBlades = t1.value25,
	BoStaff = {
		"Default",
		"Bloodluster",
		"DeepBlue",
		"Void"
	}
}
t1.value14 = "\220[\250$,6"
t1.value21 = 31432747448621
t1.value22 = 33652734901558
t1.value19 = 24160049556466
t1.value25 = 20710933472684
t1.value21 = "\179~F\16,\152b\'\241"
t1.value32 = 15728595786908
t1.value22 = "\143\170*Y\183\246\0227\219fmx9\136\2520\135W\141nm"
t1.value9 = {
	"Katana",
	"Kusarigama",
	"Daggers",
	"Naginata",
	"Gauntlets",
	"Warhammer",
	"CurvedBlades",
	"BoStaff"
}
t1.value19 = 22556018239751
t1.value25 = 15198009793445
pcall(function()
	local WeaponModulesShared = t2.value4:FindFirstChild("WeaponModulesShared")

	if not WeaponModulesShared then
		return
	end

	for _, child in ipairs(WeaponModulesShared:GetChildren()) do
		local isModuleScript = child:IsA("ModuleScript")

		if isModuleScript then
			isModuleScript = child.Name ~= "BaseWeapon"
		end

		if isModuleScript then
			local ok, result = pcall(require, child)

			if ok then
				if result then
					ok = result.WeaponInfo

					if ok then
						ok = result.WeaponInfo.Cosmetics
					end
				else
					ok = result
				end
			end

			if ok then
				local t3 = {}

				for k in pairs(result.WeaponInfo.Cosmetics) do
					table.insert(t3, k)
				end

				table.sort(t3)
				t2.value9[child.Name] = t3
			end
		end
	end
end)
t1.value27 = "x\29\170\207E\172Թ9:dKп\233\30\169\189"
t1.value18 = "H\134\252\232\2178.r\2492\181"
t1.value17 = "\20\249<\t\193x`\1754\7\206\2\179/\17681\147"
t1.value11 = {
	AutoParry = false,
	AutoDodge = false,
	LegitMode = true,
	AlwaysDefendUltimates = true,
	ParryChance = 100,
	DodgeChance = 100,
	ParryNotifications = true,
	ParryFlash = true,
	AutoUltimate = false,
	UltimateNearTarget = true,
	UltimateDistance = 12,
	UltimateFacingOnly = true,
	UnlockAllCosmetics = true,
	AutoApplyCosmetics = true,
	AutoSaveConfig = true,
	UIScale = 100,
	ToggleKey = Enum.KeyCode.RightControl
}
t1.value16 = 26756843401387
t1.value21 = "\149\250\249\u{AD}\246\19\154\146B\198"
t2.value10 = t1.value11
t1.value25 = "8\134g\233*\239"
t1.value19 = "\148\30N\246d#)\172;+\203d\212Zg\221~"
t1.value24 = 34647868997382
t1.value26 = 27917757379272
t1.value38 = 21890541529041
t1.value15 = {}
t1.value23 = "㸷\2\211\221+"
t1.value22 = 32897528167383
t1.value27 = 10349847630547
t1.value37 = "\130\152\132\134\140"
t1.value30 = 20564860888424
t1.value28 = 2622284235973
t1.value20 = 12971195226008
t1.value18 = "\246\252\185\4$DP\5\135"
t1.value32 = 25760185806555
t1.value39 = 23006354336217
t1.value30 = "I\142v\1590\134b\141i\1Zd\240"
t1.value16 = {
	Katana = "Oathbreaker",
	Kusarigama = "Celestial",
	Daggers = "CrimsonFangs",
	Naginata = "SerpentSlayer",
	Gauntlets = "Magma",
	Warhammer = "Iceborn",
	CurvedBlades = "Scorchflower",
	BoStaff = "Void"
}
t2.value11 = {
	handler = nil,
	connections = t1.value15,
	equippedCosmetics = t1.value16,
	isScriptDestroyed = false,
	lastUltimateTrigger = 0
}

function t1.value20(p1)
	if not p1 then
		return true
	end

	local PhysicsComponent = p1.PhysicsComponent

	if PhysicsComponent then
		PhysicsComponent = p1.PhysicsComponent.IsGrounded
	end

	if not PhysicsComponent then
		return true
	end

	local ok, result = pcall(function()
		return p1.PhysicsComponent:IsGrounded()
	end)

	if ok then
		return result
	else
		return true
	end
end

t2.value12 = "XZ HUB CONFIG"
t1.value24 = 28070023508751
t1.value16 = "\209\rz\18\159\220n\203k\223n\247U\230\154\17V\186#𫣛{\143\251:#"
t1.value21 = "oV\137\234>\141vٽ3\"\253+e\192"
t1.value34 = "task"

function t1.value27()
	for _, connection in ipairs(t2.value11.connections) do
		pcall(function()
			connection:Disconnect()
		end)
	end

	table.clear(t2.value11.connections)
end

t2.value13 = "XZ HUB CONFIG/DuelingGrounds"
t2.value14 = "Dueling Grounds"
t2.value15 = 9051406594
t2.value16 = "default"

function t1.value21()
	local function v29()
		local makefolder_ = makefolder

		if typeof(makefolder_) ~= "function" then
			return
		end

		local isfolder_ = isfolder

		if typeof(isfolder_) == "function" then
			if isfolder(t2.value12) then
				if isfolder(t2.value13) then
					return
				else
					makefolder(t2.value13)

					return
				end
			end

			makefolder(t2.value12)

			if isfolder(t2.value13) then
				return
			else
				makefolder(t2.value13)

				return
			end
		else
			makefolder(t2.value12)
			makefolder(t2.value13)
		end
	end

	pcall(v29)
end

t2.value17 = nil

function t1.value19(p2)
	local value16 = p2 or (t2.value16 or "default")

	local function v33()
		t2.value17()

		local v34 = t2.value13 .. "/" .. value16 .. ".json"
		local t4 = {
			Game = t2.value14,
			GameId = t2.value15,
			PlaceId = game.PlaceId,
			ConfigName = value16,
			LastSaved = os.time(),
			Settings = {
				AutoParry = t2.value10.AutoParry,
				AutoDodge = t2.value10.AutoDodge,
				LegitMode = t2.value10.LegitMode,
				AlwaysDefendUltimates = t2.value10.AlwaysDefendUltimates,
				ParryChance = t2.value10.ParryChance,
				DodgeChance = t2.value10.DodgeChance,
				ParryFlash = t2.value10.ParryFlash,
				AutoUltimate = t2.value10.AutoUltimate,
				UltimateNearTarget = t2.value10.UltimateNearTarget,
				UltimateDistance = t2.value10.UltimateDistance,
				UltimateFacingOnly = t2.value10.UltimateFacingOnly,
				UnlockAllCosmetics = t2.value10.UnlockAllCosmetics,
				AutoApplyCosmetics = t2.value10.AutoApplyCosmetics,
				AutoSaveConfig = t2.value10.AutoSaveConfig,
				UIScale = t2.value10.UIScale,
				ToggleKey = t2.value10.ToggleKey.Name
			},
			Cosmetics = t2.value11.equippedCosmetics
		}
		local writefile_ = writefile

		if typeof(writefile_) ~= "function" then
			return
		end

		writefile(v34, t2.value3:JSONEncode(t4))
	end

	pcall(v33)
end

t2.value17 = t1.value21

function t1.value24()
	t2.value17()

	local v37 = nil

	local function v38()
		local listfiles_ = listfiles

		if typeof(listfiles_) ~= "function" then
			return
		end

		local v40 = listfiles(t2.value13)

		for _, v in ipairs(v40) do
			local v43

			if v:sub(-5):lower() == ".json" then
				v43 = isfile(v)
			else
				v43 = false
			end

			if v43 then
				local ok, result = pcall(readfile, v)

				if ok and result then
					local ok2, result2 = pcall(function()
						return t2.value3:JSONDecode(result)
					end)

					if ok2 then
						ok2 = type(result2) == "table"
					end

					if ok2 and (result2.Game == t2.value14 or result2.GameId == t2.value15) then
						local match = v:match("([^/\\]+)%.json$") or v
						local v49 = v37

						table.insert(v49, match)
					end
				end
			end
		end
	end

	v37 = {}
	pcall(v38)

	if #v37 ~= 0 then
		table.sort(v37)

		return v37
	end

	local v50 = v37

	table.insert(v50, "default")
	table.sort(v37)

	return v37
end
function t1.value22(p3)
	local value16 = p3 or (t2.value16 or "default")
	local u52 = nil

	local function v53()
		local v54 = t2.value13 .. "/" .. value16 .. ".json"
		local isfile_ = isfile
		local v56 = typeof(isfile_) == "function"

		if v56 then
			v56 = isfile(v54)

			if v56 then
				local readfile_ = readfile

				v56 = typeof(readfile_) == "function"
			end
		end

		if not v56 then
			return
		end

		local v58 = readfile(v54)
		local data = t2.value3:JSONDecode(v58)
		local v60

		if data then
			v60 = type(data) == "table"
		else
			v60 = data
		end

		if not v60 then
			return
		end

		local v61

		if data.Game == t2.value14 then
			v61 = false
		else
			v61 = data.GameId ~= t2.value15
		end

		if v61 then
			return
		end

		local Settings = data.Settings

		if Settings then
			local Settings2 = data.Settings

			Settings = type(Settings2) == "table"
		end

		if Settings then
			for k, setting in pairs(data.Settings) do
				local v66 = k == "ToggleKey"

				if v66 then
					v66 = type(setting) == "string"

					if v66 then
						v66 = Enum.KeyCode[setting]
					end
				end

				if v66 then
					t2.value10.ToggleKey = Enum.KeyCode[setting]
				else
					local v67

					if t2.value10[k] == nil then
						v67 = false
					else
						local kind = type(setting)
						local v69 = t2.value10[k]

						v67 = kind == type(v69)
					end

					if v67 then
						t2.value10[k] = setting
					end
				end
			end
		end

		local Cosmetics = data.Cosmetics

		if Cosmetics then
			local Cosmetics2 = data.Cosmetics

			Cosmetics = type(Cosmetics2) == "table"
		end

		if Cosmetics then
			for k, cosmetic in pairs(data.Cosmetics) do
				local v74 = t2.value11.equippedCosmetics[k] ~= nil

				if v74 then
					v74 = type(cosmetic) == "string"
				end

				if v74 then
					t2.value11.equippedCosmetics[k] = cosmetic
				end
			end
		end

		u52 = true
	end

	u52 = false
	pcall(v53)

	return u52
end

t2.value18 = t1.value24
t2.value19 = t1.value19
t2.value20 = t1.value22

local function v75()
	if not t2.value10.AutoSaveConfig then
		return
	end

	t2.value19(t2.value16)
end

t2.value17()
t2.value20(t2.value16)

function t2.value21(p4)
	if not p4 or typeof(p4) ~= "table" then
		return false
	end

	if p4.triggerUltimate or (p4.isUltimate or p4.IsUltimate) then
		return true
	end

	local sourceModule = p4.sourceModule

	if sourceModule then
		local Name

		if typeof(sourceModule) == "Instance" then
			Name = sourceModule.Name
		else
			Name = false
		end

		local v78 = Name or tostring(sourceModule)

		if v78:find("Ultimate") or (v78:find("Special") or v78:find("Critical")) then
			return true
		end

		local ok, result = pcall(require, sourceModule)

		if ok then
			ok = type(result) == "table"
		end

		if ok then
			if result.IsUltimate or (result.isUltimate or result.IsSpecial) then
				return true
			end

			local impacts = result.impacts

			if impacts then
				local impacts2 = result.impacts

				impacts = type(impacts2) == "table"
			end

			if impacts then
				local sourceImpactN = p4.sourceImpactN or 1
				local v84 = result.impacts[sourceImpactN]
				local impactInfo

				if v84 then
					impactInfo = v84.impactInfo
				else
					impactInfo = v84
				end

				if impactInfo then
					local impactInfo2 = v84.impactInfo
					local superArmorDamage = impactInfo2.superArmorDamage

					if superArmorDamage then
						superArmorDamage = impactInfo2.superArmorDamage >= 100
					end

					if superArmorDamage then
						return true
					end

					local impactResults = impactInfo2.impactResults
					local GetHit

					if impactResults then
						GetHit = impactResults.GetHit

						if GetHit then
							GetHit = impactResults.GetHit.triggerUltimate
						end
					else
						GetHit = impactResults
					end

					if GetHit then
						return true
					end
				end
			end
		end
	end

	local superArmorDamage = p4.superArmorDamage

	if not superArmorDamage then
		return superArmorDamage and true or false
	end

	superArmorDamage = p4.superArmorDamage >= 100

	return superArmorDamage and true or false
end

t2.value22 = nil

function t1.value18()
	local v91 = t2.value22()

	if not v91 then
		return false
	end

	if v91.EquippedWeapon ~= nil then
		return true
	end

	local Character = t2.value6.Character

	if Character then
		Character = Character:GetAttribute("EquippedWeapon") ~= nil
	end

	if Character then
		return true
	end

	if not v91.WeaponToHandler then
		return false
	end

	local pairs_ = pairs

	for _, v in pairs_(v91.WeaponToHandler) do
		if v then
			local IsHolding = v.IsHolding or v.IsEquipped
		end

		if v then
			return true
		end
	end

	return false
end
function t2.value22()
	if t2.value11.handler then
		return t2.value11.handler
	end

	local Character = t2.value6.Character

	if not (Character and t2.value7) then
		return nil
	end

	local ok, result = pcall(function()
		return t2.value7:GetController("CharacterController")
	end)

	if not (ok and result) then
		return nil
	end

	local ok2, handler = pcall(function()
		return result:GetCharacterHandler(Character)
	end)

	if ok2 and handler then
		t2.value11.handler = handler

		return t2.value11.handler
	else
		return nil
	end
end

t2.value23 = t1.value18
t2.value24 = t1.value20

function t1.value30()
	local v102 = t2.value22()

	if not (v102 and v102.ActionManager) then
		return false
	end

	local ActionManager = v102.ActionManager

	if v102.IsDodging then
		return false
	end

	local Character = t2.value6.Character

	if not Character then
		return false
	end

	local Humanoid = Character:FindFirstChildOfClass("Humanoid")

	if not Humanoid or Humanoid.Health <= 0 then
		return false
	end

	if not t2.value24(v102) then
		return false
	end

	if v102.IsStaggered then
		return false
	end

	local _dodgeStamina = ActionManager._dodgeStamina
	local CurrentAction, ActionType

	if _dodgeStamina then
	elseif _dodgeStamina then
		return false
	elseif ActionManager.CurrentMiniStun then
		return false
	else
		CurrentAction = ActionManager.CurrentAction

		if CurrentAction then
			ActionType = CurrentAction.ActionType

			if ActionType == "BasicAttack" or (ActionType == "HeavyAttack" or (ActionType == "LightAttack" or (ActionType == "CriticalStrike" or (ActionType == "Ultimate" and true or ActionType == "UltimateAbility")))) then
				return false
			elseif CurrentAction.Recovering then
				return false
			elseif ActionType == "Stagger" or (ActionType == "Jump" or (ActionType == "Dodge" or (ActionType == "Intro" and true or ActionType == "Death"))) then
				return false
			else
				return true
			end
		else
			return true
		end
	end

	_dodgeStamina = ActionManager._dodgeStamina <= 0

	if _dodgeStamina then
		return false
	elseif ActionManager.CurrentMiniStun then
		return false
	else
		CurrentAction = ActionManager.CurrentAction

		if CurrentAction then
			ActionType = CurrentAction.ActionType

			if ActionType == "BasicAttack" or (ActionType == "HeavyAttack" or (ActionType == "LightAttack" or (ActionType == "CriticalStrike" or (ActionType == "Ultimate" and true or ActionType == "UltimateAbility")))) then
				return false
			elseif CurrentAction.Recovering then
				return false
			elseif ActionType == "Stagger" or (ActionType == "Jump" or (ActionType == "Dodge" or (ActionType == "Intro" and true or ActionType == "Death"))) then
				return false
			else
				return true
			end
		else
			return true
		end
	end
end
function t1.value32()
	local v109 = t2.value22()

	if not v109 then
		return false
	end

	if not t2.value23() then
		return false
	end

	if v109.CanPerformUltimate then
		local ok, result = pcall(function()
			return v109:CanPerformUltimate()
		end)

		if ok then
			ok = not result
		end

		if ok then
			return false
		end
	else
		local OriginalModel = v109.OriginalModel or t2.value6.Character

		if OriginalModel then
			OriginalModel = OriginalModel:GetAttribute("UltimateEnergy")
		end

		if (OriginalModel or 0) < 100 then
			return false
		end
	end

	local ActionManager = v109.ActionManager
	local CurrentAction

	if ActionManager then
		CurrentAction = ActionManager.CurrentAction
	else
		CurrentAction = ActionManager
	end

	if CurrentAction then
		local ActionType = ActionManager.CurrentAction.ActionType

		if ActionType == "Ultimate" and true or ActionType == "UltimateAbility" then
			return false
		end
	end

	if v109.IsStaggered then
		return false
	end

	v109._desiredQueuedAction = "Ultimate"
	v109._desiredQueuedActionDuration = 0.33333333333333

	local TryQueueBasicAttack

	if ActionManager then
		TryQueueBasicAttack = ActionManager.TryQueueBasicAttack
	else
		TryQueueBasicAttack = ActionManager
	end

	if TryQueueBasicAttack then
		pcall(function()
			ActionManager:TryQueueBasicAttack("Ultimate")
		end)
	end

	local function v117()
		local VirtualInputManager = game:GetService("VirtualInputManager")
		local R = Enum.KeyCode.R

		local function v120()
			local controller = require(t2.value4.GameManager):GetController("PlayerKeybindsController")
			local Keybinds

			if controller then
				Keybinds = controller.Keybinds

				if Keybinds then
					Keybinds = controller.Keybinds.UltimateAbility
				end
			else
				Keybinds = controller
			end

			if not Keybinds then
				return
			end

			local KeyboardBinding = controller.Keybinds.UltimateAbility.KeyboardBinding
			local v124

			if KeyboardBinding then
				v124 = Enum.KeyCode[KeyboardBinding]
			else
				v124 = KeyboardBinding
			end

			if not v124 then
				return
			end

			R = Enum.KeyCode[KeyboardBinding]
		end

		pcall(v120)
		VirtualInputManager:SendKeyEvent(true, R, false, game)
		task.delay(0.05, function()
			VirtualInputManager:SendKeyEvent(false, R, false, game)
		end)
	end

	pcall(v117)
	t2.value11.lastUltimateTrigger = tick()

	return true
end

t2.value25 = t1.value27

function t2.value26()
	local v125 = t2.value22()

	if v125 and v125.ActionManager then
		local ActionManager = v125.ActionManager

		if t2.value23() then
			if v125.IsParrying or (v125.IsBlocking or ActionManager.BlockAction ~= nil) then
				return false
			else
				local Character = t2.value6.Character

				if Character then
					local Humanoid = Character:FindFirstChildOfClass("Humanoid")

					if not Humanoid or Humanoid.Health <= 0 then
						return false
					elseif t2.value24(v125) then
						if ActionManager._blockCooldown and ActionManager._blockCooldown > 0 and true or ActionManager.IsSwappingWeapon then
							return false
						elseif v125.IsDodging or v125.IsStaggered then
							return false
						else
							local CurrentAction = ActionManager.CurrentAction

							if CurrentAction then
								local ActionType = CurrentAction.ActionType

								if ActionType == "BasicAttack" or (ActionType == "HeavyAttack" or (ActionType == "LightAttack" or (ActionType == "CriticalStrike" or (ActionType == "Ultimate" and true or ActionType == "UltimateAbility")))) then
									return false
								elseif CurrentAction.Recovering then
									return false
								elseif ActionType == "Stagger" or (ActionType == "Jump" or (ActionType == "Dodge" or (ActionType == "Intro" and true or ActionType == "Death"))) then
									return false
								elseif CurrentAction.ParallelBlockAllowed or CurrentAction.CanParry then
									return true
								else
									return false
								end
							else
								return true
							end
						end
					else
						return false
					end
				else
					return false
				end
			end
		else
			return false
		end
	else
		return false
	end
end

t2.value27 = t1.value30

function t2.value28()
	local v131 = t2.value22()

	if not (v131 and v131.ActionManager) then
		return
	end

	if not t2.value23() then
		return
	end

	if v131.IsParrying or v131.IsBlocking then
		return
	end

	local LegitMode = t2.value10.LegitMode

	if LegitMode then
		LegitMode = not t2.value26()
	end

	if LegitMode then
		return
	end

	local _blockInputQueue = v131._blockInputQueue

	if type(_blockInputQueue) == "table" then
		table.clear(_blockInputQueue)
		table.insert(_blockInputQueue, {
			state = true
		})
	end

	v131.IsParrying = true
	task.delay(0.14, function()
		local v134 = t2.value22()

		if v134 and v134.ActionManager then
			local BlockAction = v134.ActionManager.BlockAction

			if BlockAction then
				BlockAction._wantsToRelease = true

				return
			else
				v134.IsParrying = false

				return
			end
		end
	end)
end
function t2.value29()
	local v136 = t2.value22()

	if not (v136 and v136.ActionManager) then
		return
	end

	if v136.IsDodging then
		return
	end

	local LegitMode = t2.value10.LegitMode

	if LegitMode then
		LegitMode = not t2.value27()
	end

	if LegitMode then
		return
	end

	v136.IsDodging = true
	v136._desiredDodge = 0.2667

	local function v138()
		local v139 = t2.value22()

		if not v139 then
			return
		end

		if not v139.IsDodging then
			return
		end

		v139.IsDodging = nil
	end

	task.delay(0.35, v138)
end
function t1.value17()
	t2.value25()

	local value82 = t2.value8

	if value82 then
		value82 = t2.value8:FindFirstChild("Update")

		if value82 then
			value82 = t2.value8.Update:FindFirstChild("RegisterImpact")
		end
	end

	if value82 then
		local OnClientEvent = t2.value8.Update.RegisterImpact.OnClientEvent
		local v142 = OnClientEvent.Connect(OnClientEvent, function(_, p5)
			if not (t2.value10.AutoParry or (t2.value10.AutoDodge or t2.value10.AlwaysDefendUltimates)) then
				return
			end

			local AlwaysDefendUltimates = t2.value21(p5)
			local AutoParry = t2.value23()

			if AlwaysDefendUltimates then
				AlwaysDefendUltimates = t2.value10.AlwaysDefendUltimates
			end

			if AlwaysDefendUltimates then
				local AutoParry2

				if AutoParry then
					AutoParry2 = t2.value10.AutoParry

					if AutoParry2 then
						AutoParry2 = not t2.value10.LegitMode or t2.value26()
					end
				else
					AutoParry2 = AutoParry
				end

				if AutoParry2 then
					t2.value28()

					local AutoDodge = t2.value10.AutoDodge

					if AutoDodge then
					elseif AutoDodge then
						t2.value29()

						return
					else
						return
					end

					AutoDodge = not t2.value10.LegitMode or t2.value27()

					if AutoDodge then
						t2.value29()

						return
					else
						return
					end
				else
					local AutoDodge = t2.value10.AutoDodge

					if AutoDodge then
					elseif AutoDodge then
						t2.value29()

						return
					elseif t2.value10.LegitMode then
						return
					elseif AutoParry then
						t2.value28()

						return
					else
						t2.value29()

						return
					end

					AutoDodge = not t2.value10.LegitMode or t2.value27()

					if AutoDodge then
						t2.value29()

						return
					elseif t2.value10.LegitMode then
						return
					elseif AutoParry then
						t2.value28()

						return
					else
						t2.value29()

						return
					end
				end
			else
				local v148 = false

				if AutoParry then
					AutoParry = t2.value10.AutoParry

					if AutoParry then
						AutoParry = math.random(1, 100) <= t2.value10.ParryChance
					end
				end

				if AutoParry and (not t2.value10.LegitMode or t2.value26()) then
					t2.value28()
					v148 = true
				end

				local AutoDodge = t2.value10.AutoDodge

				if AutoDodge then
					AutoDodge = not v148

					if AutoDodge then
						AutoDodge = math.random(1, 100) <= t2.value10.DodgeChance
					end
				end

				if not (AutoDodge and (not t2.value10.LegitMode or t2.value27())) then
					return
				end

				t2.value29()
			end
		end)
		local connections = t2.value11.connections

		table.insert(connections, v142)
	end

	local v151 = t2.value22()
	local Parried

	if v151 then
		Parried = v151.Parried
	else
		Parried = v151
	end

	if not Parried then
		return
	end

	local function v153()
		if not t2.value10.ParryFlash then
			return
		end

		local ScreenGui = Instance.new("ScreenGui")

		ScreenGui.Name = "XZParryFlash"
		ScreenGui.IgnoreGuiInset = true
		ScreenGui.ResetOnSpawn = false
		pcall(function()
			local v155 = ScreenGui
			local gethui_ = gethui
			local hui

			if typeof(gethui_) == "function" then
				hui = gethui()
			else
				hui = false
			end

			v155.Parent = hui or CoreGui
		end)

		local Frame = Instance.new("Frame")

		Frame.Size = UDim2.fromScale(1, 1)
		Frame.BackgroundColor3 = Color3.fromRGB(255, 200, 60)
		Frame.BackgroundTransparency = 0.9
		Frame.Parent = ScreenGui

		local value1 = t2.value1
		local tweenInfo = TweenInfo.new(0.25, Enum.EasingStyle.Quad, Enum.EasingDirection.Out)
		local v161 = value1.Create(value1, Frame, tweenInfo, {
			BackgroundTransparency = 1
		})

		v161:Play()
		v161.Completed:Once(function()
			ScreenGui:Destroy()
		end)
	end

	local connection = v151.Parried:Connect(v153)
	local connections = t2.value11.connections

	table.insert(connections, connection)
end

t2.value30 = t1.value32
t2.value31 = t1.value17
t1.value17 = task.spawn

function t1.value34()
	while true do
		if t2.value11.isScriptDestroyed then
			return
		end

		task.wait(0.08)

		local AutoUltimate = t2.value10.AutoUltimate

		if AutoUltimate then
			AutoUltimate = tick() - t2.value11.lastUltimateTrigger > 1.8
		end

		if AutoUltimate then
			local v165 = t2.value22()
			local v166

			if v165 then
				v166 = t2.value23()
			else
				v166 = v165
			end

			if v166 then
				local v167 = false
				local v168

				if v165.CanPerformUltimate then
					v167 = pcall

					local v169, v170 = v167(function()
						return v165:CanPerformUltimate()
					end)

					v168 = v169 and v170
				else
					local OriginalModel = v165.OriginalModel or t2.value6.Character

					if (OriginalModel and OriginalModel:GetAttribute("UltimateEnergy") or 0) >= 100 then
						v168 = true
					else
						v168 = false
					end
				end

				if v168 then
					local Character = t2.value6.Character
					local Humanoid

					if Character then
						Humanoid = Character:FindFirstChildOfClass("Humanoid")
					else
						Humanoid = Character
					end

					if Character then
						Character = Character:FindFirstChild("HumanoidRootPart") or Character.PrimaryPart
					end

					if Humanoid then
						Humanoid = Humanoid.Health > 0
					end

					local ActionManager = v165.ActionManager

					if ActionManager then
						ActionManager = ActionManager.CurrentAction
					end

					if ActionManager then
						ActionManager = ActionManager.ActionType == "Ultimate" or ActionManager.ActionType == "UltimateAbility"
					end

					local v175 = not ActionManager
					local v176 = not v165.IsStaggered

					if Humanoid then
						if v175 then
							v175 = v176 and Character
						end
					else
						v175 = Humanoid
					end

					if v175 then
						local v177

						if t2.value10.UltimateNearTarget then
							local Position = Character.Position
							local LookVector = Character.CFrame.LookVector

							v177 = false

							for _, player in ipairs(t2.value5:GetPlayers()) do
								local v182 = player ~= t2.value6

								if v182 then
									v182 = player.Character

									if v182 then
										v182 = player.Character:FindFirstChild("HumanoidRootPart")
									end
								end

								if v182 then
									local HumanoidRootPart = player.Character.HumanoidRootPart
									local Humanoid2 = player.Character:FindFirstChildOfClass("Humanoid")

									if Humanoid2 then
										Humanoid2 = Humanoid2.Health > 0
									end

									if Humanoid2 then
										local v185 = HumanoidRootPart.Position - Position

										if v185.Magnitude <= (t2.value10.UltimateDistance or 12) and (not t2.value10.UltimateFacingOnly or LookVector:Dot(v185.Unit) >= 0.17) then
											v177 = true

											break
										end
									end
								end
							end
						else
							v177 = true
						end

						if v177 then
							t2.value30()
						end
					end
				end
			end
		end
	end
end

t1.value17(t1.value34)
t2.value32 = nil
t2.value33 = nil

function t1.value26(p6)
	local Character = t2.value6.Character

	if not Character then
		return
	end

	local function v187(p7)
		if not p7 then
			return
		end

		local v188 = p7:FindFirstChild(p6) or p7

		for _, descendant in ipairs(v188:GetDescendants()) do
			if descendant:IsA("ParticleEmitter") or (descendant:IsA("Trail") or (descendant:IsA("Beam") or (descendant:IsA("PointLight") or descendant:IsA("Highlight")))) then
				pcall(function()
					descendant.Enabled = false
					descendant:Destroy()
				end)
			end
		end
	end

	v187(Character:FindFirstChild("MountedWeapons"))
	v187(Character:FindFirstChild("Weapons"))

	local Humanoid = Character:FindFirstChildOfClass("Humanoid")

	if Humanoid then
		Humanoid = Humanoid:FindFirstChildOfClass("Animator")
	end

	if not Humanoid then
		return
	end

	local GetPlayingAnimationTracks = Humanoid.GetPlayingAnimationTracks

	for _, v in ipairs(GetPlayingAnimationTracks(Humanoid)) do
		local Animation = v.Animation
		local v196 = Animation and Animation.Name:lower() or ""
		local pos = v196:find("ult")

		if not pos then
			pos = v196.find(v196, "special")

			if not pos then
				pos = v196:find("attack")

				if not pos then
					if p6 then
						local lower = p6.lower

						pos = v196.find(v196, lower(p6))
					else
						pos = p6
					end
				end
			end
		end

		if pos then
			pcall(function()
				v:Stop(0.05)
			end)
		end
	end
end

t2.value32 = t1.value26

function t1.value34(p8, p9)
	if not (p8 and p9) then
		return
	end

	t2.value11.equippedCosmetics[p8] = p9
	t2.value32(p8)
	pcall(function()
		local controller = t2.value7 and t2.value7:GetController("WeaponInventoryController")

		if not controller then
			return
		end

		controller.WeaponToSelectedCosmetic[p8] = p9

		if not controller.WeaponCosmeticChanged then
			return
		end

		controller.WeaponCosmeticChanged:Fire(p8, p9)
	end)

	local Character = t2.value6.Character

	if Character then
		local MountedWeapons = Character:FindFirstChild("MountedWeapons")
		local v202 = MountedWeapons and MountedWeapons:FindFirstChild(p8)

		if v202 then
			v202:SetAttribute("CurrentCosmetic", p9)
		end
	end

	local function v203()
		local v204 = t2.value22()
		local WeaponToHandler

		if v204 then
			WeaponToHandler = v204.WeaponToHandler

			if WeaponToHandler then
				WeaponToHandler = v204.WeaponToHandler[p8]
			end
		else
			WeaponToHandler = v204
		end

		if not WeaponToHandler then
			return
		end

		local v206 = v204.WeaponToHandler[p8]
		local CurrentCosmeticInstance = v206.CurrentCosmeticInstance

		if CurrentCosmeticInstance then
			local CurrentCosmeticInstance2 = v206.CurrentCosmeticInstance

			CurrentCosmeticInstance = typeof(CurrentCosmeticInstance2) == "Instance"
		end

		if CurrentCosmeticInstance then
			pcall(function()
				v206.CurrentCosmeticInstance:Destroy()
			end)
		end

		local CosmeticModel = v206.CosmeticModel

		if CosmeticModel then
			local CosmeticModel2 = v206.CosmeticModel

			CosmeticModel = typeof(CosmeticModel2) == "Instance"
		end

		if CosmeticModel then
			pcall(function()
				v206.CosmeticModel:Destroy()
			end)
		end

		v206:SetCosmetic(p9)
	end

	pcall(v203)

	if not t2.value10.AutoSaveConfig then
		return
	end

	t2.value19(t2.value16)
end

t2.value34 = nil

function t1.value28()
	local n1 = 0

	local function v212()
		if not t2.value7 then
			return
		end

		local controller = t2.value7:GetController("WeaponInventoryController")
		local WeaponModulesShared = t2.value4:FindFirstChild("WeaponModulesShared")

		if not (controller and WeaponModulesShared) then
			return
		end

		for _, child in ipairs(WeaponModulesShared:GetChildren()) do
			local isModuleScript = child:IsA("ModuleScript")

			if isModuleScript then
				isModuleScript = child.Name ~= "BaseWeapon"
			end

			if isModuleScript then
				local ok, result = pcall(require, child)

				if ok then
					if result then
						ok = result.WeaponInfo

						if ok then
							ok = result.WeaponInfo.Cosmetics
						end
					else
						ok = result
					end
				end

				if ok then
					if not controller.WeaponToUnlockedCosmetics[child.Name] then
						controller.WeaponToUnlockedCosmetics[child.Name] = {}
					end

					for k in pairs(result.WeaponInfo.Cosmetics) do
						controller.WeaponToUnlockedCosmetics[child.Name][k] = true
						n1 = n1 + 1
					end

					controller.UnlockedWeapons[child.Name] = true
				end
			end
		end

		function controller.IsCosmeticUnlocked(_, _, _)
			return true
		end
		function controller.IsWeaponUnlocked(_, _)
			return true
		end
	end

	pcall(v212)

	local function v221()
		if not t2.value7 then
			return
		end

		local controller = t2.value7:GetController("IntroInventoryController")

		if not controller then
			return
		end

		function controller.IsIntroUnlocked(_, _)
			return true
		end
	end

	pcall(v221)
	pcall(function()
		if not t2.value7 then
			return
		end

		local controller = t2.value7:GetController("SequenceInventoryController")
		local Kinds

		if controller then
			Kinds = controller.Kinds
		else
			Kinds = controller
		end

		if not Kinds then
			return
		end

		for _, kind in pairs(controller.Kinds) do
			function kind.IsUnlocked(_, _)
				return true
			end
		end
	end)

	return n1
end

t2.value34 = t1.value34

function t2.value35()
	local Character = t2.value6.Character

	if not Character then
		return
	end

	local MountedWeapons = Character:FindFirstChild("MountedWeapons")

	for k, equippedCosmetic in pairs(t2.value11.equippedCosmetics) do
		t2.value32(k)

		local v231 = MountedWeapons and MountedWeapons:FindFirstChild(k)

		if v231 then
			v231:SetAttribute("CurrentCosmetic", equippedCosmetic)
		end

		local function v232()
			local v233 = t2.value22()
			local WeaponToHandler

			if v233 then
				WeaponToHandler = v233.WeaponToHandler

				if WeaponToHandler then
					WeaponToHandler = v233.WeaponToHandler[k]
				end
			else
				WeaponToHandler = v233
			end

			if not WeaponToHandler then
				return
			end

			local v235 = v233.WeaponToHandler[k]
			local CurrentCosmeticInstance = v235.CurrentCosmeticInstance

			if CurrentCosmeticInstance then
				local CurrentCosmeticInstance2 = v235.CurrentCosmeticInstance

				CurrentCosmeticInstance = typeof(CurrentCosmeticInstance2) == "Instance"
			end

			if CurrentCosmeticInstance then
				pcall(function()
					v235.CurrentCosmeticInstance:Destroy()
				end)
			end

			local CosmeticModel = v235.CosmeticModel

			if CosmeticModel then
				local CosmeticModel2 = v235.CosmeticModel

				CosmeticModel = typeof(CosmeticModel2) == "Instance"
			end

			if CosmeticModel then
				pcall(function()
					v235.CosmeticModel:Destroy()
				end)
			end

			v235:SetCosmetic(equippedCosmetic)
		end

		pcall(v232)
	end
end

t2.value36 = t1.value28

function t2.value37(p10)
	if not p10 then
		return
	end

	task.spawn(function()
		local MountedWeapons = p10:WaitForChild("MountedWeapons", 8)

		if not MountedWeapons then
			return
		end

		local function v241(p11)
			local v242 = t2.value11.equippedCosmetics[p11.Name]

			if not v242 then
				return
			end

			t2.value32(p11.Name)
			p11:SetAttribute("CurrentCosmetic", v242)

			local function v243()
				local v244 = t2.value22()
				local WeaponToHandler

				if v244 then
					WeaponToHandler = v244.WeaponToHandler

					if WeaponToHandler then
						WeaponToHandler = v244.WeaponToHandler[p11.Name]
					end
				else
					WeaponToHandler = v244
				end

				if not WeaponToHandler then
					return
				end

				local v246 = v244.WeaponToHandler[p11.Name]
				local CurrentCosmeticInstance = v246.CurrentCosmeticInstance

				if CurrentCosmeticInstance then
					local CurrentCosmeticInstance2 = v246.CurrentCosmeticInstance

					CurrentCosmeticInstance = typeof(CurrentCosmeticInstance2) == "Instance"
				end

				if CurrentCosmeticInstance then
					pcall(function()
						v246.CurrentCosmeticInstance:Destroy()
					end)
				end

				local CosmeticModel = v246.CosmeticModel

				if CosmeticModel then
					local CosmeticModel2 = v246.CosmeticModel

					CosmeticModel = typeof(CosmeticModel2) == "Instance"
				end

				if CosmeticModel then
					pcall(function()
						v246.CosmeticModel:Destroy()
					end)
				end

				v246:SetCosmetic(v242)
			end

			pcall(v243)
		end

		local GetChildren = MountedWeapons.GetChildren

		for _, v in ipairs(GetChildren(MountedWeapons)) do
			v241(v)
		end

		local connection = MountedWeapons.ChildAdded:Connect(function(child)
			task.wait(0.05)
			v241(child)
			task.wait(0.2)
			v241(child)
		end)
		local connections = t2.value11.connections

		table.insert(connections, connection)
	end)
end

t2.value33 = false
pcall(function()
	local hookmetamethod_ = hookmetamethod
	local v257

	if typeof(hookmetamethod_) == "function" then
		v257 = not t2.value33
	else
		v257 = false
	end

	if not v257 then
		return
	end

	local v258 = nil

	v258 = hookmetamethod(game, "__namecall", function(p12, ...)
		local v259 = getnamecallmethod()
		local t5 = { ... }
		local v261 = not checkcaller()

		if v261 then
			v261 = v259 == "FireServer"

			if v261 then
				if p12 then
					v261 = p12.Name == "Request_SetSelectedCosmetic"
				else
					v261 = p12
				end
			end
		end

		if not v261 then
			return v258(p12, ...)
		end

		local v262 = t5[1]
		local v263 = t5[2]
		local v264 = type(v262) == "string"

		if v264 then
			v264 = type(v263) == "string"
		end

		if not v264 then
			return v258(p12, ...)
		end

		task.spawn(function()
			t2.value34(v262, v263)
		end)

		return v258(p12, ...)
	end)
	t2.value33 = true
end)
t2.value38 = {}
t2.value38.__index = t2.value38

function t2.value39(p13)
	local v265 = type(p13) == "string"

	if v265 then
		v265 = p13:find("rbxassetid://")
	end

	if v265 then
		return "rbxthumb://type=Asset&id=" .. p13:match("%d+") .. "&w=150&h=150"
	end

	local v266 = type(p13) == "number"

	if v266 then
		if v266 then
			return "rbxthumb://type=Asset&id=" .. tostring(p13) .. "&w=150&h=150"
		else
			return p13
		end
	end

	if type(p13) == "string" then
		v266 = tonumber(p13)
	else
		v266 = false
	end

	if v266 then
		return "rbxthumb://type=Asset&id=" .. tostring(p13) .. "&w=150&h=150"
	else
		return p13
	end
end
function t2.value40(p14, p15)
	local UICorner = Instance.new("UICorner")

	UICorner.CornerRadius = UDim.new(0, p15 or 10)
	UICorner.Parent = p14

	return UICorner
end

local color3 = Color3.fromRGB

t1.value36 = 10
t1.value33 = 12
t2.value41 = color3(10, t1.value36, t1.value33)
t2.value42 = Color3.fromRGB(24, 24, 29)

local color32 = Color3.fromRGB

t1.value23 = 22
t1.value33 = 18
t1.value36 = color32(t1.value33, 18, t1.value23)
t2.value43 = t1.value36
t1.value33 = Color3.fromRGB(255, 45, 55)
t2.value44 = t1.value33
t1.value33 = Color3.fromRGB
t1.value38 = 20
t1.value23 = 175
t1.value39 = "\132\\\234\23d\\\21"
t2.value45 = t1.value33(t1.value23, t1.value38, 28)
t1.value23 = Color3.fromRGB(25, 8, 10)
t2.value46 = t1.value23
t1.value38 = Color3.fromRGB(250, 250, 250)
t2.value47 = t1.value38
t1.value38 = Color3.fromRGB
t1.value29 = 135
t1.value39 = 142
t2.value48 = t1.value38(t1.value29, 135, t1.value39)
t1.value29 = Color3.fromRGB(45, 45, 54)
t2.value49 = t1.value29

function t1.value29(_, p16)
	local v270 = p16 or {}
	local Subtitle = v270.Subtitle or "Dueling Grounds"
	local ToggleKey = v270.ToggleKey or Enum.KeyCode.RightControl
	local t6 = {}
	local UIScale = t2.value10.UIScale

	if UIScale then
		UIScale = t2.value10.UIScale / 100
	end

	local t7 = {
		Tabs = t6,
		CurrentTabIndex = 1,
		IsUIOpen = true,
		IsAnimating = false,
		ScaleVal = UIScale or 1,
		ToggleKey = ToggleKey,
		SelectedBtn = nil
	}
	local hui = nil

	local function v277()
		local gethui_ = gethui

		hui = typeof(gethui_) == "function" and gethui() or CoreGui
	end

	pcall(v277)
	hui = hui or t2.value6:WaitForChild("PlayerGui")

	if hui:FindFirstChild("XZ_DG_Master") then
		hui.XZ_DG_Master:Destroy()
	end

	local ScreenGui = Instance.new("ScreenGui")

	ScreenGui.Name = "XZ_DG_Master"
	ScreenGui.ResetOnSpawn = false
	ScreenGui.Parent = hui
	t7.ScreenGui = ScreenGui

	local Frame = Instance.new("Frame")

	Frame.Name = "MainFrame"
	Frame.Size = UDim2.new(0, 740, 0, 540)
	Frame.Position = UDim2.new(0.5, 0, 0.5, 0)
	Frame.AnchorPoint = Vector2.new(0.5, 0.5)
	Frame.BackgroundColor3 = t2.value41
	Frame.BorderSizePixel = 0
	Frame.ClipsDescendants = true
	Frame.Parent = ScreenGui
	t2.value40(Frame, 10)
	t7.MainFrame = Frame

	local UIScale2 = Instance.new("UIScale")

	UIScale2.Scale = t7.ScaleVal
	UIScale2.Parent = Frame
	t7.UIScale = UIScale2

	local ImageButton = Instance.new("ImageButton")

	ImageButton.Size = UDim2.new(0, 42, 0, 42)
	ImageButton.Position = UDim2.new(0.04, 0, 0.22, 0)
	ImageButton.BackgroundColor3 = Color3.fromRGB(16, 16, 20)
	ImageButton.BorderSizePixel = 0
	ImageButton.AutoButtonColor = false
	ImageButton.Active = true
	ImageButton.ZIndex = 50
	ImageButton.Parent = ScreenGui
	t2.value40(ImageButton, 21)

	local UIStroke = Instance.new("UIStroke")

	UIStroke.Thickness = 1.2
	UIStroke.Color = Color3.fromRGB(65, 20, 24)
	UIStroke.Transparency = 0.2
	UIStroke.Parent = ImageButton

	local ImageLabel = Instance.new("ImageLabel")

	ImageLabel.Size = UDim2.new(0, 22, 0, 22)
	ImageLabel.Position = UDim2.new(0.5, 0, 0.5, 0)
	ImageLabel.AnchorPoint = Vector2.new(0.5, 0.5)
	ImageLabel.BackgroundTransparency = 1
	ImageLabel.Image = t2.value39("140277993260075")
	ImageLabel.ZIndex = 51
	ImageLabel.Parent = ImageButton

	local UIScale3 = Instance.new("UIScale")

	UIScale3.Scale = 1
	UIScale3.Parent = ImageButton

	local u286 = nil
	local u287 = nil
	local Position = nil
	local Position2 = nil
	local u290 = false

	ImageButton.InputBegan:Connect(function(input)
		if not (input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch) then
			return
		end

		u286 = true
		u290 = false
		Position = input.Position
		Position2 = ImageButton.Position
		t2.value1:Create(UIScale3, TweenInfo.new(0.12, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), {
			Scale = 0.88
		}):Play()
		input.Changed:Connect(function()
			if input.UserInputState ~= Enum.UserInputState.End then
				return
			end

			u286 = false
			t2.value1:Create(UIScale3, TweenInfo.new(0.2, Enum.EasingStyle.Back, Enum.EasingDirection.Out), {
				Scale = 1
			}):Play()
		end)
	end)
	ImageButton.InputChanged:Connect(function(input)
		if not (input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch) then
			return
		end

		u287 = input
	end)
	t2.value2.InputChanged:Connect(function(input)
		local v291

		if input == u287 then
			v291 = u286
		else
			v291 = false
		end

		if not v291 then
			return
		end

		local v292 = input.Position - Position

		if v292.Magnitude > 6 then
			u290 = true
		end

		ImageButton.Position = UDim2.new(Position2.X.Scale, Position2.X.Offset + v292.X, Position2.Y.Scale, Position2.Y.Offset + v292.Y)
	end)

	function t7.ToggleUI(p17, p18)
		if p17.IsAnimating or not ScreenGui.Parent then
			return
		end

		if p18 == nil then
			p18 = not p17.IsUIOpen
		end

		if p18 == p17.IsUIOpen then
			return
		end

		p17.IsAnimating = true

		if p18 then
			Frame.Visible = true
			p17.IsUIOpen = true
			UIScale2.Scale = p17.ScaleVal * 0.88

			local value1 = t2.value1
			local v294 = UIScale2
			local tweenInfo = TweenInfo.new(0.35, Enum.EasingStyle.Back, Enum.EasingDirection.Out)
			local t8 = {
				Scale = p17.ScaleVal
			}
			local v297 = value1.Create(value1, v294, tweenInfo, t8)

			v297:Play()
			v297.Completed:Connect(function()
				p17.IsAnimating = false
			end)
		else
			p17.IsUIOpen = false

			local value1 = t2.value1
			local v299 = UIScale2
			local tweenInfo = TweenInfo.new(0.22, Enum.EasingStyle.Quart, Enum.EasingDirection.In)
			local ScaleVal = p17.ScaleVal
			local v302 = value1.Create(value1, v299, tweenInfo, {
				Scale = ScaleVal * 0.88
			})

			v302:Play()

			local function v303()
				Frame.Visible = false
				p17.IsAnimating = false
			end

			v302.Completed:Connect(v303)
		end
	end

	ImageButton.MouseButton1Click:Connect(function()
		if u290 then
			return
		end

		t7:ToggleUI()
	end)
	t2.value2.InputBegan:Connect(function(input, gameProcessed)
		local v304 = not gameProcessed

		if v304 then
			v304 = input.KeyCode == t7.ToggleKey
		end

		if not v304 then
			return
		end

		t7:ToggleUI()
	end)

	local u305 = nil
	local u306 = nil
	local Position3 = nil
	local Position4 = nil

	Frame.InputBegan:Connect(function(input)
		if input.UserInputType ~= Enum.UserInputType.MouseButton1 then
			return
		end

		u305 = true
		Position3 = input.Position
		Position4 = Frame.Position
		input.Changed:Connect(function()
			if input.UserInputState ~= Enum.UserInputState.End then
				return
			end

			u305 = false
		end)
	end)
	Frame.InputChanged:Connect(function(input)
		if input.UserInputType ~= Enum.UserInputType.MouseMovement then
			return
		end

		u306 = input
	end)
	t2.value2.InputChanged:Connect(function(input)
		local v309

		if input == u306 then
			v309 = u305
		else
			v309 = false
		end

		if not v309 then
			return
		end

		local v310 = input.Position - Position3

		Frame.Position = UDim2.new(Position4.X.Scale, Position4.X.Offset + v310.X, Position4.Y.Scale, Position4.Y.Offset + v310.Y)
	end)

	local Frame2 = Instance.new("Frame")

	Frame2.Size = UDim2.new(0, 165, 1, 0)
	Frame2.BackgroundColor3 = t2.value41
	Frame2.BorderSizePixel = 0
	Frame2.Parent = Frame
	t2.value40(Frame2, 10)

	local Frame3 = Instance.new("Frame")

	Frame3.Size = UDim2.new(1, 0, 0, 56)
	Frame3.BackgroundTransparency = 1
	Frame3.Parent = Frame2

	local ImageLabel2 = Instance.new("ImageLabel")

	ImageLabel2.Size = UDim2.new(0, 32, 0, 32)
	ImageLabel2.Position = UDim2.new(0, 12, 0.5, -16)
	ImageLabel2.BackgroundTransparency = 1
	ImageLabel2.Image = t2.value39("140277993260075")
	ImageLabel2.Parent = Frame3

	local TextLabel = Instance.new("TextLabel")

	TextLabel.Size = UDim2.new(1, -52, 1, 0)
	TextLabel.Position = UDim2.new(0, 50, 0, 0)
	TextLabel.BackgroundTransparency = 1
	TextLabel.Text = "<font color=\'#FF2D37\'>XZ</font> <font color=\'#FFFFFF\'>HUB</font>"
	TextLabel.RichText = true
	TextLabel.Font = Enum.Font.GothamBold
	TextLabel.TextSize = 15
	TextLabel.TextXAlignment = Enum.TextXAlignment.Left
	TextLabel.Parent = Frame3

	local ScrollingFrame = Instance.new("ScrollingFrame")

	ScrollingFrame.Size = UDim2.new(1, 0, 1, -98)
	ScrollingFrame.Position = UDim2.new(0, 0, 0, 56)
	ScrollingFrame.BackgroundTransparency = 1
	ScrollingFrame.BorderSizePixel = 0
	ScrollingFrame.ScrollBarThickness = 0
	ScrollingFrame.CanvasSize = UDim2.new(0, 0, 0, 0)
	ScrollingFrame.AutomaticCanvasSize = Enum.AutomaticSize.Y
	ScrollingFrame.Parent = Frame2

	local UIListLayout = Instance.new("UIListLayout")

	UIListLayout.SortOrder = Enum.SortOrder.LayoutOrder
	UIListLayout.Padding = UDim.new(0, 4)
	UIListLayout.Parent = ScrollingFrame

	local UIPadding = Instance.new("UIPadding")

	UIPadding.PaddingTop = UDim.new(0, 4)
	UIPadding.PaddingLeft = UDim.new(0, 10)
	UIPadding.PaddingRight = UDim.new(0, 10)
	UIPadding.Parent = ScrollingFrame
	t7.SideList = ScrollingFrame

	local Frame4 = Instance.new("Frame")

	Frame4.Size = UDim2.new(1, -20, 0, 32)
	Frame4.Position = UDim2.new(0, 10, 1, -40)
	Frame4.BackgroundTransparency = 1
	Frame4.BorderSizePixel = 0
	Frame4.Parent = Frame2

	local ImageLabel3 = Instance.new("ImageLabel")

	ImageLabel3.Size = UDim2.new(0, 24, 0, 24)
	ImageLabel3.Position = UDim2.new(0, 2, 0.5, -12)
	ImageLabel3.BackgroundColor3 = Color3.fromRGB(20, 20, 24)
	ImageLabel3.BorderSizePixel = 0
	ImageLabel3.Parent = Frame4
	t2.value40(ImageLabel3, 12)
	task.spawn(function()
		local userThumbnailAsync, v321 = t2.value5:GetUserThumbnailAsync(t2.value6.UserId, Enum.ThumbnailType.HeadShot, Enum.ThumbnailSize.Size100x100)

		if not v321 then
			return
		end

		ImageLabel3.Image = userThumbnailAsync
	end)

	local TextLabel2 = Instance.new("TextLabel")

	TextLabel2.Size = UDim2.new(1, -36, 0, 14)
	TextLabel2.Position = UDim2.new(0, 32, 0, 2)
	TextLabel2.BackgroundTransparency = 1
	TextLabel2.Text = t2.value6.DisplayName
	TextLabel2.TextColor3 = t2.value47
	TextLabel2.Font = Enum.Font.GothamBold
	TextLabel2.TextSize = 10.5
	TextLabel2.TextTruncate = Enum.TextTruncate.AtEnd
	TextLabel2.TextXAlignment = Enum.TextXAlignment.Left
	TextLabel2.Parent = Frame4

	local TextLabel3 = Instance.new("TextLabel")

	TextLabel3.Size = UDim2.new(1, -36, 0, 12)
	TextLabel3.Position = UDim2.new(0, 32, 0, 16)
	TextLabel3.BackgroundTransparency = 1
	TextLabel3.Text = "@" .. t2.value6.Name
	TextLabel3.TextColor3 = t2.value48
	TextLabel3.Font = Enum.Font.Gotham
	TextLabel3.TextSize = 9
	TextLabel3.TextTruncate = Enum.TextTruncate.AtEnd
	TextLabel3.TextXAlignment = Enum.TextXAlignment.Left
	TextLabel3.Parent = Frame4

	local Frame5 = Instance.new("Frame")

	Frame5.Size = UDim2.new(1, -165, 0, 56)
	Frame5.Position = UDim2.new(0, 165, 0, 0)
	Frame5.BackgroundTransparency = 1
	Frame5.Parent = Frame

	local TextLabel4 = Instance.new("TextLabel")

	TextLabel4.Size = UDim2.new(1, -110, 1, 0)
	TextLabel4.Position = UDim2.new(0, 18, 0, 0)
	TextLabel4.BackgroundTransparency = 1
	TextLabel4.RichText = true
	TextLabel4.Text = "<font color=\'#FFFFFF\'><b>" .. Subtitle .. "</b></font>  <font color=\'#55555F\'>|</font>  <font color=\'#FF2D37\'>Combat</font>"
	TextLabel4.Font = Enum.Font.Gotham
	TextLabel4.TextSize = 13
	TextLabel4.TextXAlignment = Enum.TextXAlignment.Left
	TextLabel4.Parent = Frame5
	t7.TopTitle = TextLabel4
	t7.Subtitle = Subtitle

	local function createImageButton(p19, p20)
		local ImageButton2 = Instance.new("ImageButton")

		ImageButton2.Size = UDim2.new(0, 16, 0, 16)
		ImageButton2.Position = UDim2.new(1, p19, 0.5, -8)
		ImageButton2.BackgroundColor3 = Color3.fromRGB(24, 24, 28)
		ImageButton2.Image = t2.value39(p20)
		ImageButton2.ImageColor3 = t2.value48
		ImageButton2.BorderSizePixel = 0
		ImageButton2.ZIndex = 11
		ImageButton2.Parent = Frame5
		t2.value40(ImageButton2, 4)
		ImageButton2.MouseEnter:Connect(function()
			local value1 = t2.value1
			local v329 = ImageButton2
			local tweenInfo = TweenInfo.new(0.18)
			local color33 = Color3.fromRGB

			value1.Create(value1, v329, tweenInfo, {
				BackgroundColor3 = color33(34, 34, 40),
				ImageColor3 = t2.value47
			}):Play()
		end)
		ImageButton2.MouseLeave:Connect(function()
			t2.value1:Create(ImageButton2, TweenInfo.new(0.18), {
				BackgroundColor3 = Color3.fromRGB(24, 24, 28),
				ImageColor3 = t2.value48
			}):Play()
		end)

		return ImageButton2
	end

	createImageButton(-41, "10734896206").MouseButton1Click:Connect(function()
		t7:ToggleUI(false)
	end)

	local v332 = createImageButton(-20, "10747384394")

	v332.MouseEnter:Connect(function()
		local value1 = t2.value1
		local v334 = v332
		local tweenInfo = TweenInfo.new(0.18)
		local value45 = t2.value45

		value1.Create(value1, v334, tweenInfo, {
			BackgroundColor3 = value45,
			ImageColor3 = Color3.new(1, 1, 1)
		}):Play()
	end)
	v332.MouseLeave:Connect(function()
		t2.value1:Create(v332, TweenInfo.new(0.18), {
			BackgroundColor3 = Color3.fromRGB(24, 24, 28),
			ImageColor3 = t2.value48
		}):Play()
	end)
	v332.MouseButton1Click:Connect(function()
		t2.value11.isScriptDestroyed = true
		t2.value25()
		ScreenGui:Destroy()
	end)

	local Frame6 = Instance.new("Frame")

	Frame6.Size = UDim2.new(1, -180, 1, -66)
	Frame6.Position = UDim2.new(0, 173, 0, 56)
	Frame6.BackgroundTransparency = 1
	Frame6.BorderSizePixel = 0
	Frame6.ClipsDescendants = true
	Frame6.Parent = Frame

	local Frame7 = Instance.new("Frame")

	Frame7.Size = UDim2.new(1, 0, 1, 0)
	Frame7.Position = UDim2.new(0, 0, 0, 0)
	Frame7.BackgroundTransparency = 1
	Frame7.BorderSizePixel = 0
	Frame7.Parent = Frame6
	t7.PagesTrack = Frame7

	local value38 = t2.value38

	return setmetatable(t7, value38)
end

t2.value38.CreateWindow = t1.value29

function t2.value38.CreateCategory(p21, p22)
	local TextLabel = Instance.new("TextLabel")

	TextLabel.Size = UDim2.new(1, 0, 0, 22)
	TextLabel.BackgroundTransparency = 1
	TextLabel.Text = p22
	TextLabel.TextColor3 = t2.value48
	TextLabel.Font = Enum.Font.GothamBold
	TextLabel.TextSize = 11
	TextLabel.TextXAlignment = Enum.TextXAlignment.Left
	TextLabel.Parent = p21.SideList
end
function t1.value29(p23, p24, p25)
	local currentTabIndex = #p23.Tabs + 1
	local TextButton = Instance.new("TextButton")

	TextButton.Size = UDim2.new(1, 0, 0, 34)
	TextButton.BackgroundTransparency = 1
	TextButton.Text = ""
	TextButton.AutoButtonColor = false
	TextButton.BorderSizePixel = 0
	TextButton.Parent = p23.SideList

	local UIScale = Instance.new("UIScale")

	UIScale.Scale = 1
	UIScale.Parent = TextButton

	local Frame = Instance.new("Frame")

	Frame.Size = UDim2.new(1, 0, 1, 0)
	Frame.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
	Frame.BackgroundTransparency = 1
	Frame.ClipsDescendants = true
	Frame.BorderSizePixel = 0
	Frame.Parent = TextButton
	t2.value40(Frame, 6)

	local UIGradient = Instance.new("UIGradient")

	UIGradient.Color = ColorSequence.new({ ColorSequenceKeypoint.new(0, t2.value45), ColorSequenceKeypoint.new(0.45, Color3.fromRGB(115, 16, 20)), ColorSequenceKeypoint.new(1, t2.value46) })
	UIGradient.Offset = Vector2.new(-1, 0)
	UIGradient.Parent = Frame

	local Frame2 = Instance.new("Frame")

	Frame2.Size = UDim2.new(0, 3.5, 0, 0)
	Frame2.Position = UDim2.new(0, 3, 0.5, 0)
	Frame2.AnchorPoint = Vector2.new(0, 0.5)
	Frame2.BackgroundColor3 = t2.value44
	Frame2.BorderSizePixel = 0
	Frame2.ZIndex = 5
	Frame2.Parent = TextButton
	t2.value40(Frame2, 2)

	local ImageLabel = Instance.new("ImageLabel")

	ImageLabel.Size = UDim2.new(0, 17, 0, 17)
	ImageLabel.Position = UDim2.new(0, 14, 0.5, -8.5)
	ImageLabel.BackgroundTransparency = 1
	ImageLabel.Image = t2.value39(p25 or "10734975692")
	ImageLabel.ImageColor3 = t2.value44
	ImageLabel.BorderSizePixel = 0
	ImageLabel.ZIndex = 4
	ImageLabel.Parent = TextButton

	local TextLabel = Instance.new("TextLabel")

	TextLabel.Size = UDim2.new(1, -40, 1, 0)
	TextLabel.Position = UDim2.new(0, 38, 0, 0)
	TextLabel.BackgroundTransparency = 1
	TextLabel.Text = p24
	TextLabel.TextColor3 = t2.value48
	TextLabel.Font = Enum.Font.GothamMedium
	TextLabel.TextSize = 12
	TextLabel.TextXAlignment = Enum.TextXAlignment.Left
	TextLabel.ZIndex = 4
	TextLabel.Parent = TextButton

	local selectedBtn = {
		Btn = TextButton,
		Scale = UIScale,
		BgFrame = Frame,
		Gradient = UIGradient,
		Icon = ImageLabel,
		Text = TextLabel,
		Indicator = Frame2
	}
	local ScrollingFrame = Instance.new("ScrollingFrame")

	ScrollingFrame.Name = p24
	ScrollingFrame.Size = UDim2.new(1, 0, 1, 0)
	ScrollingFrame.Position = UDim2.new(currentTabIndex - 1, 0, 0, 0)
	ScrollingFrame.BackgroundTransparency = 1
	ScrollingFrame.BorderSizePixel = 0
	ScrollingFrame.ScrollBarThickness = 3
	ScrollingFrame.ScrollBarImageColor3 = Color3.fromRGB(45, 45, 55)
	ScrollingFrame.ScrollBarImageTransparency = 0.4
	ScrollingFrame.CanvasSize = UDim2.new(0, 0, 0, 0)
	ScrollingFrame.AutomaticCanvasSize = Enum.AutomaticSize.Y
	ScrollingFrame.ClipsDescendants = true
	ScrollingFrame.Parent = p23.PagesTrack

	local UIPadding = Instance.new("UIPadding")

	UIPadding.PaddingRight = UDim.new(0, 6)
	UIPadding.PaddingBottom = UDim.new(0, 20)
	UIPadding.Parent = ScrollingFrame

	local Frame3 = Instance.new("Frame")

	Frame3.Size = UDim2.new(0.485, 0, 0, 0)
	Frame3.AutomaticSize = Enum.AutomaticSize.Y
	Frame3.BackgroundTransparency = 1
	Frame3.Parent = ScrollingFrame

	local UIListLayout = Instance.new("UIListLayout")

	UIListLayout.SortOrder = Enum.SortOrder.LayoutOrder
	UIListLayout.Padding = UDim.new(0, 10)
	UIListLayout.Parent = Frame3

	local Frame4 = Instance.new("Frame")

	Frame4.Size = UDim2.new(0.485, 0, 0, 0)
	Frame4.Position = UDim2.new(0.515, 0, 0, 0)
	Frame4.AutomaticSize = Enum.AutomaticSize.Y
	Frame4.BackgroundTransparency = 1
	Frame4.Parent = ScrollingFrame
	rightLayout = Instance.new("UIListLayout")
	rightLayout.SortOrder = Enum.SortOrder.LayoutOrder
	rightLayout.Padding = UDim.new(0, 10)
	rightLayout.Parent = Frame4

	local t9 = {
		Name = p24,
		Index = currentTabIndex,
		ColLeft = Frame3,
		ColRight = Frame4,
		NextCol = "Left"
	}

	local function v356()
		if p23.CurrentTabIndex == currentTabIndex then
			return
		end

		local SelectedBtn = p23.SelectedBtn

		p23.CurrentTabIndex = currentTabIndex
		t2.value1:Create(p23.TopTitle, TweenInfo.new(0.1), {
			TextTransparency = 1
		}):Play()
		task.delay(0.1, function()
			p23.TopTitle.Text = "<font color=\'#FFFFFF\'><b>" .. p23.Subtitle .. "</b></font>  <font color=\'#55555F\'>|</font>  <font color=\'#FF2D37\'>" .. p24 .. "</font>"
			t2.value1:Create(p23.TopTitle, TweenInfo.new(0.2, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), {
				TextTransparency = 0
			}):Play()
		end)

		local v358

		if SelectedBtn then
			v358 = SelectedBtn ~= selectedBtn
		else
			v358 = SelectedBtn
		end

		if not v358 then
			p23.SelectedBtn = selectedBtn
			selectedBtn.BgFrame.BackgroundTransparency = 0
			v390 = t2.value1
			v391 = selectedBtn.Gradient
			v392 = TweenInfo.new(0.35, Enum.EasingStyle.Quart, Enum.EasingDirection.Out)
			v393 = Vector2
			v390.Create(v390, v391, v392, {
				Offset = v393.new(0, 0)
			}):Play()
			v394 = t2.value1
			v395 = selectedBtn.Indicator
			v396 = TweenInfo.new
			v397 = Enum.EasingStyle.Back
			v398 = Enum.EasingDirection
			v394.Create(v394, v395, v396(0.25, v397, v398.Out), {
				Size = UDim2.new(0, 3.5, 0.65, 0)
			}):Play()
			v399 = t2.value1
			v400 = selectedBtn.Text
			v401 = TweenInfo.new(0.2)
			v402 = Color3.new
			v399.Create(v399, v400, v401, {
				TextColor3 = v402(1, 1, 1)
			}):Play()
			v403 = t2.value1
			v404 = selectedBtn.Icon
			v405 = TweenInfo.new(0.2)
			v406 = Color3.new
			v403.Create(v403, v404, v405, {
				ImageColor3 = v406(1, 1, 1)
			}):Play()
			v407 = t2.value1
			v408 = p23.PagesTrack
			v409 = TweenInfo.new(0.35, Enum.EasingStyle.Quart, Enum.EasingDirection.Out)
			v410 = UDim2.new
			v411 = -(currentTabIndex - 1)
			v407.Create(v407, v408, v409, {
				Position = v410(v411, 0, 0, 0)
			}):Play()

			return
		end

		local value1 = t2.value1
		local Indicator = SelectedBtn.Indicator
		local TweenInfo_ = TweenInfo

		value1.Create(value1, Indicator, TweenInfo_.new(0.2), {
			Size = UDim2.new(0, 3.5, 0, 0)
		}):Play()
		t2.value1:Create(SelectedBtn.Text, TweenInfo.new(0.2), {
			TextColor3 = t2.value48
		}):Play()
		t2.value1:Create(SelectedBtn.Icon, TweenInfo.new(0.2), {
			ImageColor3 = t2.value44
		}):Play()

		local value12 = t2.value1
		local Gradient = SelectedBtn.Gradient
		local tweenInfo = TweenInfo.new(0.25, Enum.EasingStyle.Quart, Enum.EasingDirection.In)
		local vector2New = Vector2.new
		local v366 = value12.Create(value12, Gradient, tweenInfo, {
			Offset = vector2New(-1, 0)
		})

		v366:Play()
		v366.Completed:Connect(function()
			if p23.SelectedBtn == SelectedBtn then
				return
			end

			SelectedBtn.BgFrame.BackgroundTransparency = 1
		end)
		p23.SelectedBtn = selectedBtn
		selectedBtn.BgFrame.BackgroundTransparency = 0

		local value13 = t2.value1
		local Gradient2 = selectedBtn.Gradient
		local tweenInfo2 = TweenInfo.new(0.35, Enum.EasingStyle.Quart, Enum.EasingDirection.Out)
		local Vector2_ = Vector2

		value13.Create(value13, Gradient2, tweenInfo2, {
			Offset = Vector2_.new(0, 0)
		}):Play()

		local value14 = t2.value1
		local Indicator2 = selectedBtn.Indicator
		local tweenInfoNew = TweenInfo.new
		local Back = Enum.EasingStyle.Back
		local EasingDirection = Enum.EasingDirection

		value14.Create(value14, Indicator2, tweenInfoNew(0.25, Back, EasingDirection.Out), {
			Size = UDim2.new(0, 3.5, 0.65, 0)
		}):Play()

		local value15 = t2.value1
		local Text = selectedBtn.Text
		local tweenInfo3 = TweenInfo.new(0.2)
		local color3New = Color3.new

		value15.Create(value15, Text, tweenInfo3, {
			TextColor3 = color3New(1, 1, 1)
		}):Play()

		local value16 = t2.value1
		local Icon = selectedBtn.Icon
		local tweenInfo4 = TweenInfo.new(0.2)
		local color3New2 = Color3.new

		value16.Create(value16, Icon, tweenInfo4, {
			ImageColor3 = color3New2(1, 1, 1)
		}):Play()

		local value17 = t2.value1
		local PagesTrack = p23.PagesTrack
		local tweenInfo5 = TweenInfo.new(0.35, Enum.EasingStyle.Quart, Enum.EasingDirection.Out)
		local uDim2New = UDim2.new
		local v388 = -(currentTabIndex - 1)

		value17.Create(value17, PagesTrack, tweenInfo5, {
			Position = uDim2New(v388, 0, 0, 0)
		}):Play()
	end
	local function v389()
		if p23.SelectedBtn == selectedBtn then
			return
		end

		local value1 = t2.value1
		local v412 = TextLabel
		local tweenInfo = TweenInfo.new(0.15)
		local Color3_ = Color3

		value1.Create(value1, v412, tweenInfo, {
			TextColor3 = Color3_.fromRGB(220, 220, 225)
		}):Play()

		local value12 = t2.value1
		local v413 = ImageLabel
		local tweenInfo2 = TweenInfo.new(0.15)
		local Color3_2 = Color3

		value12.Create(value12, v413, tweenInfo2, {
			ImageColor3 = Color3_2.fromRGB(255, 120, 125)
		}):Play()
	end

	TextButton.MouseEnter:Connect(v389)

	local function v414()
		if p23.SelectedBtn == selectedBtn then
			return
		end

		t2.value1:Create(TextLabel, TweenInfo.new(0.15), {
			TextColor3 = t2.value48
		}):Play()

		local value1 = t2.value1
		local v415 = ImageLabel

		value1.Create(value1, v415, TweenInfo.new(0.15), {
			ImageColor3 = t2.value44
		}):Play()
	end

	TextButton.MouseLeave:Connect(v414)

	local function v416()
		t2.value1:Create(UIScale, TweenInfo.new(0.08), {
			Scale = 0.94
		}):Play()
	end

	TextButton.MouseButton1Down:Connect(v416)
	TextButton.MouseButton1Up:Connect(function()
		t2.value1:Create(UIScale, TweenInfo.new(0.24, Enum.EasingStyle.Back), {
			Scale = 1
		}):Play()
	end)
	TextButton.MouseButton1Click:Connect(function()
		UIScale.Scale = 0.94
		t2.value1:Create(UIScale, TweenInfo.new(0.28, Enum.EasingStyle.Back), {
			Scale = 1
		}):Play()
		v356()
	end)

	if currentTabIndex == 1 then
		p23.SelectedBtn = selectedBtn
		selectedBtn.BgFrame.BackgroundTransparency = 0
		selectedBtn.Gradient.Offset = Vector2.new(0, 0)
		selectedBtn.Indicator.Size = UDim2.new(0, 3.5, 0.65, 0)
		selectedBtn.Text.TextColor3 = Color3.new(1, 1, 1)
		selectedBtn.Icon.ImageColor3 = Color3.new(1, 1, 1)
		p23.TopTitle.Text = "<font color=\'#FFFFFF\'><b>" .. p23.Subtitle .. "</b></font>  <font color=\'#55555F\'>|</font>  <font color=\'#FF2D37\'>" .. p24 .. "</font>"
	end

	local Tabs = p23.Tabs

	table.insert(Tabs, t9)

	function t9.CreateSection(_, p26, p27, p28, p29)
		local ColRight

		if p29 == "Right" then
			ColRight = t9.ColRight
		elseif p29 == "Left" then
			ColRight = t9.ColLeft
		else
			local v417 = t9.NextCol == "Left"

			if v417 then
				v417 = t9.ColLeft
			end

			ColRight = v417 or t9.ColRight
			t9.NextCol = t9.NextCol == "Left" and "Right" or false or "Left"
		end

		local t10 = {
			CurrentHeight = 52
		}
		local Frame5 = Instance.new("Frame")

		Frame5.Size = UDim2.new(1, 0, 0, 46)
		Frame5.BackgroundTransparency = 1
		Frame5.ClipsDescendants = true
		Frame5.Parent = ColRight

		local Frame6 = Instance.new("Frame")

		Frame6.Size = UDim2.new(1, 0, 0, 46)
		Frame6.BackgroundColor3 = t2.value42
		Frame6.BorderSizePixel = 0
		Frame6.ZIndex = 4
		Frame6.Parent = Frame5
		t2.value40(Frame6, 8)

		local ImageLabel2 = Instance.new("ImageLabel")

		ImageLabel2.Size = UDim2.new(0, 20, 0, 20)
		ImageLabel2.Position = UDim2.new(0, 12, 0.5, -10)
		ImageLabel2.BackgroundTransparency = 1
		ImageLabel2.Image = t2.value39(p27 or "10723374641")
		ImageLabel2.ImageColor3 = t2.value44
		ImageLabel2.ZIndex = 5
		ImageLabel2.Parent = Frame6

		local TextLabel2 = Instance.new("TextLabel")

		TextLabel2.Size = UDim2.new(0.6, 0, 0, 18)
		TextLabel2.Position = UDim2.new(0, 38, 0, 8)
		TextLabel2.BackgroundTransparency = 1
		TextLabel2.Text = p26
		TextLabel2.TextColor3 = t2.value47
		TextLabel2.Font = Enum.Font.GothamBold
		TextLabel2.TextSize = 12
		TextLabel2.TextXAlignment = Enum.TextXAlignment.Left
		TextLabel2.ZIndex = 5
		TextLabel2.Parent = Frame6

		local TextLabel3 = Instance.new("TextLabel")

		TextLabel3.Size = UDim2.new(0.6, 0, 0, 14)
		TextLabel3.Position = UDim2.new(0, 38, 0, 24)
		TextLabel3.BackgroundTransparency = 1
		TextLabel3.Text = p28 or ""
		TextLabel3.TextColor3 = t2.value48
		TextLabel3.Font = Enum.Font.Gotham
		TextLabel3.TextSize = 9
		TextLabel3.TextXAlignment = Enum.TextXAlignment.Left
		TextLabel3.ZIndex = 5
		TextLabel3.Parent = Frame6

		local TextButton2 = Instance.new("TextButton")

		TextButton2.Size = UDim2.new(0, 32, 0, 16)
		TextButton2.Position = UDim2.new(1, -44, 0, 15)
		TextButton2.BackgroundColor3 = t2.value44
		TextButton2.Text = ""
		TextButton2.AutoButtonColor = false
		TextButton2.ZIndex = 5
		TextButton2.Parent = Frame6
		t2.value40(TextButton2, 8)

		local Frame7 = Instance.new("Frame")

		Frame7.Size = UDim2.new(0, 12, 0, 12)
		Frame7.Position = UDim2.new(1, -14, 0.5, -6)
		Frame7.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
		Frame7.ZIndex = 6
		Frame7.Parent = TextButton2
		t2.value40(Frame7, 6)

		local Frame8 = Instance.new("Frame")

		Frame8.Size = UDim2.new(1, 0, 0, 0)
		Frame8.Position = UDim2.new(0, 0, 0, 46)
		Frame8.BackgroundTransparency = 1
		Frame8.ClipsDescendants = true
		Frame8.Visible = true
		Frame8.Parent = Frame5

		local Frame9 = Instance.new("Frame")

		Frame9.Size = UDim2.new(1, 0, 1, 0)
		Frame9.BackgroundTransparency = 1
		Frame9.Parent = Frame8

		local u418 = nil

		local function v419()
			if not u418 then
				return
			end

			Frame5.Size = UDim2.new(1, 0, 0, t10.CurrentHeight)
			Frame8.Size = UDim2.new(1, 0, 0, t10.CurrentHeight - 46)
		end

		u418 = true

		local MouseButton1Click = TextButton2.MouseButton1Click

		MouseButton1Click.Connect(MouseButton1Click, function()
			u418 = not u418

			local value1 = t2.value1
			local v420 = Frame7
			local tweenInfo = TweenInfo.new(0.24, Enum.EasingStyle.Back)
			local uDim2 = u418

			if uDim2 then
				uDim2 = UDim2.new(1, -14, 0.5, -6)
			end

			local uDim22 = uDim2 or UDim2.new(0, 2, 0.5, -6)

			value1.Create(value1, v420, tweenInfo, {
				Position = uDim22
			}):Play()

			local value12 = t2.value1
			local v424 = TextButton2
			local tweenInfo2 = TweenInfo.new(0.24)
			local s1 = "BackgroundColor3"
			local value44 = u418

			if value44 then
				value44 = t2.value44
			end

			value12:Create(v424, tweenInfo2, {
				[s1] = value44 or Color3.fromRGB(36, 36, 42)
			}):Play()

			if u418 then
				Frame8.Visible = true

				local value13 = t2.value1
				local v429 = Frame5
				local tweenInfo3 = TweenInfo.new(0.32, Enum.EasingStyle.Quart)
				local UDim2_ = UDim2

				value13.Create(value13, v429, tweenInfo3, {
					Size = UDim2_.new(1, 0, 0, t10.CurrentHeight)
				}):Play()

				local value14 = t2.value1
				local v433 = Frame8
				local tweenInfo4 = TweenInfo.new(0.32, Enum.EasingStyle.Quart)
				local UDim2_2 = UDim2

				value14.Create(value14, v433, tweenInfo4, {
					Size = UDim2_2.new(1, 0, 0, t10.CurrentHeight - 46)
				}):Play()

				return
			end

			local value13 = t2.value1
			local v437 = Frame5
			local tweenInfo3 = TweenInfo.new(0.26, Enum.EasingStyle.Quart)
			local uDim2New = UDim2.new
			local v440 = value13.Create(value13, v437, tweenInfo3, {
				Size = uDim2New(1, 0, 0, 46)
			})
			local value14 = t2.value1
			local v442 = Frame8
			local tweenInfoNew = TweenInfo.new
			local EasingStyle = Enum.EasingStyle

			value14.Create(value14, v442, tweenInfoNew(0.26, EasingStyle.Quart), {
				Size = UDim2.new(1, 0, 0, 0)
			}):Play()
			v440:Play()

			local function v445()
				if u418 then
					return
				end

				Frame8.Visible = false
			end

			v440.Completed:Connect(v445)
		end)

		function t10.AddToggle(_, p30, p31, p32)
			local v446 = t10.CurrentHeight - 46

			t10.CurrentHeight = t10.CurrentHeight + 33
			v419()

			local Frame10 = Instance.new("Frame")

			Frame10.Size = UDim2.new(1, -12, 0, 28)
			Frame10.Position = UDim2.new(0, 6, 0, v446)
			Frame10.BackgroundTransparency = 1
			Frame10.ClipsDescendants = true
			Frame10.Parent = Frame9
			t2.value40(Frame10, 6)

			local Frame11 = Instance.new("Frame")
			local uDim2

			if p31 then
				uDim2 = UDim2.new(1, 0, 1, 0)
			else
				uDim2 = p31
			end

			Frame11.Size = uDim2 or UDim2.new(0, 0, 1, 0)
			Frame11.BackgroundColor3 = t2.value43
			Frame11.BorderSizePixel = 0
			Frame11.ZIndex = 1
			Frame11.Parent = Frame10
			t2.value40(Frame11, 6)

			local Frame12 = Instance.new("Frame")

			Frame12.Size = UDim2.new(0, 2, 0, 14)
			Frame12.Position = UDim2.new(0, 7, 0.5, -7)
			Frame12.BackgroundColor3 = p31 and t2.value44 or t2.value49
			Frame12.BorderSizePixel = 0
			Frame12.ZIndex = 2
			Frame12.Parent = Frame10
			t2.value40(Frame12, 2)

			local TextLabel4 = Instance.new("TextLabel")

			TextLabel4.Size = UDim2.new(0.75, 0, 1, 0)
			TextLabel4.Position = UDim2.new(0, 16, 0, 0)
			TextLabel4.BackgroundTransparency = 1
			TextLabel4.Text = p30
			TextLabel4.TextColor3 = p31 and t2.value47 or t2.value48
			TextLabel4.Font = Enum.Font.Gotham
			TextLabel4.TextSize = 11
			TextLabel4.TextXAlignment = Enum.TextXAlignment.Left
			TextLabel4.ZIndex = 2
			TextLabel4.Parent = Frame10

			local TextButton3 = Instance.new("TextButton")

			TextButton3.Size = UDim2.new(0, 16, 0, 16)
			TextButton3.Position = UDim2.new(1, -24, 0.5, -8)
			TextButton3.BackgroundColor3 = Color3.fromRGB(255, 255, 255)

			local n2 = 0

			TextButton3.BackgroundTransparency = p31 and n2 and n2 or 0.88
			TextButton3.Text = ""
			TextButton3.AutoButtonColor = false
			TextButton3.ZIndex = 3
			TextButton3.Parent = Frame10
			t2.value40(TextButton3, 4)

			local UIGradient2 = Instance.new("UIGradient")

			UIGradient2.Rotation = 45
			UIGradient2.Color = ColorSequence.new({ ColorSequenceKeypoint.new(0, Color3.fromRGB(255, 60, 75)), ColorSequenceKeypoint.new(0.55, Color3.fromRGB(215, 25, 38)), ColorSequenceKeypoint.new(1, Color3.fromRGB(150, 12, 22)) })
			UIGradient2.Parent = TextButton3

			local ImageLabel3 = Instance.new("ImageLabel")
			local uDim22

			if p31 then
				uDim22 = UDim2.new(0, 10, 0, 10)
			else
				uDim22 = p31
			end

			ImageLabel3.Size = uDim22 or UDim2.new(0, 4, 0, 4)
			ImageLabel3.Position = UDim2.new(0.5, 0, 0.5, 0)
			ImageLabel3.AnchorPoint = Vector2.new(0.5, 0.5)
			ImageLabel3.BackgroundTransparency = 1
			ImageLabel3.Image = t2.value39("10709790644")
			ImageLabel3.ImageTransparency = p31 and 0 or 1
			ImageLabel3.ZIndex = 4
			ImageLabel3.Parent = TextButton3

			local u457 = nil

			local function v458(p33, p34)
				u457 = p33

				if u457 then
					local value1 = t2.value1
					local v460 = Frame11
					local tweenInfo = TweenInfo.new(0.28, Enum.EasingStyle.Quart)
					local UDim2_ = UDim2

					value1.Create(value1, v460, tweenInfo, {
						Size = UDim2_.new(1, 0, 1, 0)
					}):Play()
					t2.value1:Create(TextButton3, TweenInfo.new(0.2), {
						BackgroundTransparency = 0
					}):Play()

					local value12 = t2.value1
					local v464 = ImageLabel3
					local tweenInfoNew = TweenInfo.new
					local EasingStyle = Enum.EasingStyle

					value12.Create(value12, v464, tweenInfoNew(0.25, EasingStyle.Back), {
						Size = UDim2.new(0, 10, 0, 10),
						ImageTransparency = 0
					}):Play()
					t2.value1:Create(Frame12, TweenInfo.new(0.2), {
						BackgroundColor3 = t2.value44
					}):Play()

					local value13 = t2.value1
					local v468 = TextLabel4
					local tweenInfo2 = TweenInfo.new(0.2)

					value13.Create(value13, v468, tweenInfo2, {
						TextColor3 = t2.value47
					}):Play()
				else
					local value1 = t2.value1
					local v471 = Frame11
					local tweenInfo = TweenInfo.new(0.24, Enum.EasingStyle.Quart)

					value1.Create(value1, v471, tweenInfo, {
						Size = UDim2.new(0, 0, 1, 0)
					}):Play()
					t2.value1:Create(TextButton3, TweenInfo.new(0.18), {
						BackgroundTransparency = 0.88
					}):Play()
					t2.value1:Create(ImageLabel3, TweenInfo.new(0.15), {
						Size = UDim2.new(0, 4, 0, 4),
						ImageTransparency = 1
					}):Play()
					t2.value1:Create(Frame12, TweenInfo.new(0.2), {
						BackgroundColor3 = t2.value49
					}):Play()

					local value12 = t2.value1
					local v474 = TextLabel4
					local tweenInfo2 = TweenInfo.new(0.2)

					value12.Create(value12, v474, tweenInfo2, {
						TextColor3 = t2.value48
					}):Play()
				end

				local v476 = p32

				if v476 then
					v476 = not p34
				end

				if not v476 then
					return
				end

				p32(u457)
			end

			u457 = p31
			TextButton3.MouseButton1Click:Connect(function()
				TextButton3.Size = UDim2.new(0, 13, 0, 13)
				TextButton3.Position = UDim2.new(1, -22.5, 0.5, -6.5)

				local value1 = t2.value1
				local v478 = TextButton3
				local tweenInfoNew = TweenInfo.new
				local EasingStyle = Enum.EasingStyle

				value1.Create(value1, v478, tweenInfoNew(0.24, EasingStyle.Back), {
					Size = UDim2.new(0, 16, 0, 16),
					Position = UDim2.new(1, -24, 0.5, -8)
				}):Play()
				v458(not u457, false)
			end)

			return {
				Set = function(_, p35, p36)
					v458(p35, p36)
				end,
				Get = function(_)
					return u457
				end
			}
		end
		function t10.AddSlider(_, p37, p38, p39, p40, p41, p42)
			local v481 = t10.CurrentHeight - 46

			t10.CurrentHeight = t10.CurrentHeight + 38
			v419()

			local Frame10 = Instance.new("Frame")

			Frame10.Size = UDim2.new(1, -12, 0, 32)
			Frame10.Position = UDim2.new(0, 6, 0, v481)
			Frame10.BackgroundColor3 = t2.value43
			Frame10.BorderSizePixel = 0
			Frame10.Parent = Frame9
			t2.value40(Frame10, 6)

			local TextLabel4 = Instance.new("TextLabel")

			TextLabel4.Size = UDim2.new(0.45, 0, 1, 0)
			TextLabel4.Position = UDim2.new(0, 10, 0, 0)
			TextLabel4.BackgroundTransparency = 1
			TextLabel4.Text = p37
			TextLabel4.TextColor3 = t2.value47
			TextLabel4.Font = Enum.Font.Gotham
			TextLabel4.TextSize = 10.5
			TextLabel4.TextXAlignment = Enum.TextXAlignment.Left
			TextLabel4.Parent = Frame10

			local TextLabel5 = Instance.new("TextLabel")

			TextLabel5.Size = UDim2.new(0, 40, 1, 0)
			TextLabel5.Position = UDim2.new(1, -48, 0, 0)
			TextLabel5.BackgroundTransparency = 1
			TextLabel5.Text = tostring(p40)
			TextLabel5.TextColor3 = t2.value44
			TextLabel5.Font = Enum.Font.GothamBold
			TextLabel5.TextSize = 10
			TextLabel5.TextXAlignment = Enum.TextXAlignment.Right
			TextLabel5.Parent = Frame10

			local TextButton3 = Instance.new("TextButton")

			TextButton3.Size = UDim2.new(0, 105, 0, 5)
			TextButton3.Position = UDim2.new(1, -158, 0.5, -2.5)
			TextButton3.BackgroundColor3 = Color3.fromRGB(28, 28, 36)
			TextButton3.BorderSizePixel = 0
			TextButton3.Text = ""
			TextButton3.AutoButtonColor = false
			TextButton3.Parent = Frame10
			t2.value40(TextButton3, 3)

			local v486 = (p40 - p38) / (p39 - p38)
			local v487 = math.clamp(v486, 0, 1)
			local Frame11 = Instance.new("Frame")

			Frame11.Size = UDim2.new(v487, 0, 1, 0)
			Frame11.BackgroundColor3 = t2.value44
			Frame11.BorderSizePixel = 0
			Frame11.Parent = TextButton3
			t2.value40(Frame11, 3)

			local Frame12 = Instance.new("Frame")

			Frame12.Size = UDim2.new(0, 11, 0, 11)
			Frame12.AnchorPoint = Vector2.new(0.5, 0.5)
			Frame12.Position = UDim2.new(v487, 0, 0.5, 0)
			Frame12.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
			Frame12.BorderSizePixel = 0
			Frame12.ZIndex = 5
			Frame12.Parent = TextButton3
			t2.value40(Frame12, 6)

			local u490 = nil
			local u491 = false
			local n3 = 0
			local u493 = v487

			local function v494(p43)
				local v495 = math.clamp(p43, 0, 1)

				u490 = v495

				local v496 = p38 + (p39 - p38) * v495
				local v497 = p41

				if v497 then
					v497 = p41 > 0
				end

				if v497 then
					local v498 = v496 / p41

					v496 = math.round(v498) * p41
				end

				local v499 = (v496 - p38) / (p39 - p38)

				Frame11.Size = UDim2.new(v499, 0, 1, 0)
				Frame12.Position = UDim2.new(v499, 0, 0.5, 0)
				TextLabel5.Text = tostring(v496)

				if not p42 then
					return
				end

				p42(v496)
			end

			u490 = v487
			TextButton3.InputBegan:Connect(function(input)
				if not (input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch) then
					return
				end

				u491 = true
				n3 = input.Position.X
				u493 = u490

				local v500 = p23.UIScale.Scale > 0

				if v500 then
					v500 = p23.UIScale.Scale
				end

				local v501 = 105 * (v500 or 1)
				local v502 = input.Position.X - TextButton3.AbsolutePosition.X

				if not (v501 > 0) then
					return
				end

				v494(v502 / v501)
				u493 = u490
			end)
			t2.value2.InputEnded:Connect(function(input)
				if not (input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch) then
					return
				end

				u491 = false
			end)
			t2.value2.InputChanged:Connect(function(input)
				local v503 = u491

				if v503 then
					v503 = input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch
				end

				if not v503 then
					return
				end

				local v504 = input.Position.X - n3
				local v505 = p23.UIScale.Scale > 0

				if v505 then
					v505 = p23.UIScale.Scale
				end

				local v506 = 105 * (v505 or 1)

				if not (v506 > 0) then
					return
				end

				v494(u493 + v504 / v506)
			end)

			return {
				Set = function(_, p44)
					local v507 = (p44 - p38) / (p39 - p38)

					v494((math.clamp(v507, 0, 1)))
				end
			}
		end
		function t10.AddDropdown(_, p45, p46, p47, p48)
			local v508 = t10.CurrentHeight - 46

			t10.CurrentHeight = t10.CurrentHeight + 36
			v419()

			local Frame10 = Instance.new("Frame")

			Frame10.Size = UDim2.new(1, -12, 0, 32)
			Frame10.Position = UDim2.new(0, 6, 0, v508)
			Frame10.BackgroundColor3 = t2.value43
			Frame10.BorderSizePixel = 0
			Frame10.ZIndex = 8
			Frame10.Parent = Frame9
			t2.value40(Frame10, 6)

			local TextLabel4 = Instance.new("TextLabel")

			TextLabel4.Size = UDim2.new(0, 80, 1, 0)
			TextLabel4.Position = UDim2.new(0, 10, 0, 0)
			TextLabel4.BackgroundTransparency = 1
			TextLabel4.Text = p45
			TextLabel4.TextColor3 = t2.value47
			TextLabel4.Font = Enum.Font.Gotham
			TextLabel4.TextSize = 11
			TextLabel4.TextXAlignment = Enum.TextXAlignment.Left
			TextLabel4.ZIndex = 8
			TextLabel4.Parent = Frame10

			if not p47 then
				if p46 then
					local v511 = p46[1]
				end

				p47 = v561 or ""
			end

			local u512 = p47
			local TextButton3 = Instance.new("TextButton")

			TextButton3.Size = UDim2.new(0, 125, 0, 22)
			TextButton3.Position = UDim2.new(1, -131, 0.5, -11)
			TextButton3.BackgroundColor3 = Color3.fromRGB(26, 26, 32)

			local v514 = u512

			TextButton3.Text = "  " .. tostring(v514)
			TextButton3.TextColor3 = t2.value47
			TextButton3.Font = Enum.Font.Gotham
			TextButton3.TextSize = 10
			TextButton3.TextXAlignment = Enum.TextXAlignment.Left
			TextButton3.AutoButtonColor = false
			TextButton3.ZIndex = 9
			TextButton3.Parent = Frame10
			t2.value40(TextButton3, 5)

			local ImageLabel3 = Instance.new("ImageLabel")

			ImageLabel3.Size = UDim2.new(0, 12, 0, 12)
			ImageLabel3.Position = UDim2.new(1, -16, 0.5, -6)
			ImageLabel3.BackgroundTransparency = 1
			ImageLabel3.Image = t2.value39("10709790948")
			ImageLabel3.ImageColor3 = t2.value48
			ImageLabel3.ZIndex = 10
			ImageLabel3.Parent = TextButton3

			local Frame11 = Instance.new("Frame")

			Frame11.Size = UDim2.new(0, 125, 0, 0)
			Frame11.Position = UDim2.new(1, -131, 0, 30)
			Frame11.BackgroundColor3 = Color3.fromRGB(20, 20, 24)
			Frame11.ClipsDescendants = true
			Frame11.Visible = false
			Frame11.ZIndex = 20
			Frame11.Parent = Frame10
			t2.value40(Frame11, 6)

			local ScrollingFrame2 = Instance.new("ScrollingFrame")

			ScrollingFrame2.Size = UDim2.new(1, 0, 1, 0)
			ScrollingFrame2.BackgroundTransparency = 1
			ScrollingFrame2.ScrollBarThickness = 3
			ScrollingFrame2.ScrollBarImageColor3 = t2.value44
			ScrollingFrame2.CanvasSize = UDim2.new(0, 0, 0, #p46 * 24)
			ScrollingFrame2.ZIndex = 21
			ScrollingFrame2.Parent = Frame11

			local UIListLayout2 = Instance.new("UIListLayout")

			UIListLayout2.SortOrder = Enum.SortOrder.LayoutOrder
			UIListLayout2.Padding = UDim.new(0, 2)

			local v519 = nil

			UIListLayout2.Parent = ScrollingFrame2

			local u520 = false

			v519 = function(p49)
				ScrollingFrame2:ClearAllChildren()

				local UIListLayout3 = Instance.new("UIListLayout")

				UIListLayout3.SortOrder = Enum.SortOrder.LayoutOrder
				UIListLayout3.Padding = UDim.new(0, 2)
				UIListLayout3.Parent = ScrollingFrame2
				ScrollingFrame2.CanvasSize = UDim2.new(0, 0, 0, #p49 * 24)

				for _, v in ipairs(p49) do
					local TextButton4 = Instance.new("TextButton")

					TextButton4.Size = UDim2.new(1, -6, 0, 22)

					local s2 = "BackgroundColor3"
					local v526 = v == u512

					if v526 then
						v526 = Color3.fromRGB(45, 18, 22)
					end

					TextButton4[s2] = v526 or Color3.fromRGB(24, 24, 28)
					TextButton4.BackgroundTransparency = v == u512 and 0 or 1
					TextButton4.Text = "  " .. v

					local s3 = "TextColor3"
					local value44

					if v == u512 then
						value44 = t2.value44
					else
						value44 = false
					end

					TextButton4[s3] = value44 or t2.value48

					local s4 = "Font"
					local v530 = v == u512

					if v530 then
						v530 = Enum.Font.GothamBold
					end

					TextButton4[s4] = v530 or Enum.Font.Gotham
					TextButton4.TextSize = 10
					TextButton4.TextXAlignment = Enum.TextXAlignment.Left
					TextButton4.AutoButtonColor = false
					TextButton4.ZIndex = 22
					TextButton4.Parent = ScrollingFrame2
					t2.value40(TextButton4, 4)

					local MouseButton1Click2 = TextButton4.MouseButton1Click

					MouseButton1Click2.Connect(MouseButton1Click2, function()
						u512 = v
						TextButton3.Text = "  " .. u512
						u520 = false
						t2.value1:Create(ImageLabel3, TweenInfo.new(0.2), {
							Rotation = 0
						}):Play()

						local value1 = t2.value1
						local v533 = Frame11
						local tweenInfo = TweenInfo.new(0.2, Enum.EasingStyle.Quart)
						local UDim2_ = UDim2
						local v536 = value1.Create(value1, v533, tweenInfo, {
							Size = UDim2_.new(0, 125, 0, 0)
						})

						v536:Play()

						local function v537()
							Frame11.Visible = false
						end

						v536.Completed:Connect(v537)
						t2.value1:Create(Frame5, TweenInfo.new(0.25, Enum.EasingStyle.Quart), {
							Size = UDim2.new(1, 0, 0, t10.CurrentHeight)
						}):Play()

						local value12 = t2.value1
						local v539 = Frame8
						local tweenInfo2 = TweenInfo.new(0.25, Enum.EasingStyle.Quart)
						local uDim2New = UDim2.new
						local v542 = t10.CurrentHeight - 46

						value12.Create(value12, v539, tweenInfo2, {
							Size = uDim2New(1, 0, 0, v542)
						}):Play()
						v519(p49)

						if not p48 then
							return
						end

						p48(u512)
					end)
				end
			end
			v519(p46)
			TextButton3.MouseButton1Click:Connect(function()
				u520 = not u520

				if u520 then
					Frame11.Visible = true
					t2.value1:Create(ImageLabel3, TweenInfo.new(0.25, Enum.EasingStyle.Back), {
						Rotation = 180
					}):Play()

					local value1 = t2.value1
					local v544 = Frame11
					local tweenInfo = TweenInfo.new(0.28, Enum.EasingStyle.Quart)
					local uDim2New = UDim2.new

					value1.Create(value1, v544, tweenInfo, {
						Size = uDim2New(0, 125, 0, 100)
					}):Play()

					local value12 = t2.value1
					local v548 = Frame5
					local tweenInfo2 = TweenInfo.new(0.28, Enum.EasingStyle.Quart)
					local uDim2New2 = UDim2.new
					local CurrentHeight = t10.CurrentHeight

					value12.Create(value12, v548, tweenInfo2, {
						Size = uDim2New2(1, 0, 0, CurrentHeight + 105)
					}):Play()

					local value13 = t2.value1
					local v553 = Frame8
					local tweenInfo3 = TweenInfo.new(0.28, Enum.EasingStyle.Quart)

					value13.Create(value13, v553, tweenInfo3, {
						Size = UDim2.new(1, 0, 0, t10.CurrentHeight - 46 + 105)
					}):Play()

					return
				end

				t2.value1:Create(ImageLabel3, TweenInfo.new(0.2), {
					Rotation = 0
				}):Play()

				local value1 = t2.value1
				local v556 = Frame11
				local tweenInfo = TweenInfo.new(0.2, Enum.EasingStyle.Quart)
				local UDim2_ = UDim2
				local v559 = value1.Create(value1, v556, tweenInfo, {
					Size = UDim2_.new(0, 125, 0, 0)
				})

				v559:Play()
				v559.Completed:Connect(function()
					Frame11.Visible = false
				end)

				local value12 = t2.value1
				local v562 = Frame5
				local tweenInfo2 = TweenInfo.new(0.25, Enum.EasingStyle.Quart)
				local t11 = {
					Size = UDim2.new(1, 0, 0, t10.CurrentHeight)
				}

				value12.Create(value12, v562, tweenInfo2, t11):Play()

				local value13 = t2.value1
				local v565 = Frame8
				local tweenInfoNew = TweenInfo.new
				local EasingStyle = Enum.EasingStyle

				value13.Create(value13, v565, tweenInfoNew(0.25, EasingStyle.Quart), {
					Size = UDim2.new(1, 0, 0, t10.CurrentHeight - 46)
				}):Play()
			end)

			return {
				Refresh = function(_, p50, p51)
					if not p51 then
						v620 = u512
						TextButton3.Text = "  " .. tostring(v620)
						v519(p50)

						return
					end

					u512 = p51

					local v568 = u512

					TextButton3.Text = "  " .. tostring(v568)
					v519(p50)
				end
			}
		end
		function t10.AddTextBox(_, p52, p53, p54, p55)
			local v569 = t10.CurrentHeight - 46

			t10.CurrentHeight = t10.CurrentHeight + 36
			v419()

			local Frame10 = Instance.new("Frame")

			Frame10.Size = UDim2.new(1, -12, 0, 32)
			Frame10.Position = UDim2.new(0, 6, 0, v569)
			Frame10.BackgroundColor3 = t2.value43
			Frame10.BorderSizePixel = 0
			Frame10.Parent = Frame9
			t2.value40(Frame10, 6)

			local TextLabel4 = Instance.new("TextLabel")

			TextLabel4.Size = UDim2.new(0.42, 0, 1, 0)
			TextLabel4.Position = UDim2.new(0, 10, 0, 0)
			TextLabel4.BackgroundTransparency = 1
			TextLabel4.Text = p52
			TextLabel4.TextColor3 = t2.value47
			TextLabel4.Font = Enum.Font.Gotham
			TextLabel4.TextSize = 11
			TextLabel4.TextXAlignment = Enum.TextXAlignment.Left
			TextLabel4.Parent = Frame10

			local TextBox = Instance.new("TextBox")

			TextBox.Size = UDim2.new(0, 125, 0, 22)
			TextBox.Position = UDim2.new(1, -131, 0.5, -11)
			TextBox.BackgroundColor3 = Color3.fromRGB(26, 26, 32)
			TextBox.PlaceholderText = p53 or "Enter text..."
			TextBox.PlaceholderColor3 = t2.value48
			TextBox.Text = p54 or ""
			TextBox.TextColor3 = t2.value47
			TextBox.Font = Enum.Font.Gotham
			TextBox.TextSize = 10
			TextBox.ClearTextOnFocus = false
			TextBox.ClipsDescendants = true
			TextBox.Parent = Frame10
			t2.value40(TextBox, 5)
			TextBox.FocusLost:Connect(function(enterPressed)
				if not p55 then
					return
				end

				p55(TextBox.Text, enterPressed)
			end)

			return {
				Set = function(_, p56)
					TextBox.Text = tostring(p56)
				end,
				Get = function(_)
					return TextBox.Text
				end
			}
		end
		function t10.AddButton(_, p57, p58)
			local v573 = t10.CurrentHeight - 46

			t10.CurrentHeight = t10.CurrentHeight + 34
			v419()

			local TextButton3 = Instance.new("TextButton")

			TextButton3.Size = UDim2.new(1, -12, 0, 28)
			TextButton3.Position = UDim2.new(0, 6, 0, v573)
			TextButton3.BackgroundColor3 = t2.value43
			TextButton3.BorderSizePixel = 0
			TextButton3.Text = p57
			TextButton3.TextColor3 = t2.value47
			TextButton3.Font = Enum.Font.GothamMedium
			TextButton3.TextSize = 11
			TextButton3.AutoButtonColor = false
			TextButton3.Parent = Frame9
			t2.value40(TextButton3, 6)

			local UIScale2 = Instance.new("UIScale")

			UIScale2.Scale = 1
			UIScale2.Parent = TextButton3
			TextButton3.MouseEnter:Connect(function()
				local value1 = t2.value1
				local v577 = TextButton3
				local tweenInfo = TweenInfo.new(0.15)
				local Color3_ = Color3

				value1.Create(value1, v577, tweenInfo, {
					BackgroundColor3 = Color3_.fromRGB(32, 32, 38),
					TextColor3 = t2.value44
				}):Play()
			end)
			TextButton3.MouseLeave:Connect(function()
				t2.value1:Create(TextButton3, TweenInfo.new(0.15), {
					BackgroundColor3 = t2.value43,
					TextColor3 = t2.value47
				}):Play()
			end)
			TextButton3.MouseButton1Down:Connect(function()
				local value1 = t2.value1
				local v581 = UIScale2
				local TweenInfo_ = TweenInfo

				value1.Create(value1, v581, TweenInfo_.new(0.08), {
					Scale = 0.95
				}):Play()
			end)
			TextButton3.MouseButton1Up:Connect(function()
				t2.value1:Create(UIScale2, TweenInfo.new(0.24, Enum.EasingStyle.Back), {
					Scale = 1
				}):Play()
			end)
			TextButton3.MouseButton1Click:Connect(function()
				if not p58 then
					return
				end

				p58()
			end)
		end
		function t10.AddKeybind(_, p59, p60, p61)
			local v583 = t10.CurrentHeight - 46

			t10.CurrentHeight = t10.CurrentHeight + 36
			v419()

			local Frame10 = Instance.new("Frame")

			Frame10.Size = UDim2.new(1, -12, 0, 32)
			Frame10.Position = UDim2.new(0, 6, 0, v583)
			Frame10.BackgroundColor3 = t2.value43
			Frame10.BorderSizePixel = 0
			Frame10.Parent = Frame9
			t2.value40(Frame10, 6)

			local TextLabel4 = Instance.new("TextLabel")

			TextLabel4.Size = UDim2.new(0.5, 0, 1, 0)
			TextLabel4.Position = UDim2.new(0, 10, 0, 0)
			TextLabel4.BackgroundTransparency = 1
			TextLabel4.Text = p59
			TextLabel4.TextColor3 = t2.value47
			TextLabel4.Font = Enum.Font.Gotham
			TextLabel4.TextSize = 11
			TextLabel4.TextXAlignment = Enum.TextXAlignment.Left
			TextLabel4.Parent = Frame10

			local TextButton3 = Instance.new("TextButton")

			TextButton3.Size = UDim2.new(0, 105, 0, 22)
			TextButton3.Position = UDim2.new(1, -113, 0.5, -11)
			TextButton3.BackgroundColor3 = Color3.fromRGB(26, 26, 32)
			TextButton3.Text = "[" .. p60.Name .. "]"
			TextButton3.TextColor3 = t2.value44
			TextButton3.Font = Enum.Font.GothamBold
			TextButton3.TextSize = 10
			TextButton3.AutoButtonColor = false
			TextButton3.Parent = Frame10
			t2.value40(TextButton3, 5)
			TextButton3.MouseButton1Click:Connect(function()
				TextButton3.Text = "... Press Key ..."
				TextButton3.TextColor3 = Color3.fromRGB(255, 200, 50)

				local connection = nil

				connection = t2.value2.InputBegan:Connect(function(input)
					local v588 = input.UserInputType == Enum.UserInputType.Keyboard

					if v588 then
						v588 = input.KeyCode ~= Enum.KeyCode.Unknown
					end

					if not v588 then
						return
					end

					TextButton3.Text = "[" .. input.KeyCode.Name .. "]"
					TextButton3.TextColor3 = t2.value44
					connection:Disconnect()

					if not p61 then
						return
					end

					p61(input.KeyCode)
				end)
			end)

			return {
				Set = function(_, p62)
					TextButton3.Text = "[" .. p62.Name .. "]"
				end
			}
		end

		return t10
	end

	return t9
end

t2.value38.CreateTab = t1.value29
t1.value29 = t2.value38

local CreateWindow = t1.value29.CreateWindow
local t12 = {
	Subtitle = "Dueling Grounds",
	ToggleKey = t2.value10.ToggleKey
}

t2.value50 = CreateWindow(t1.value29, t12)
t1.value31 = 3604090996366
t1.value40 = 13625945888969
t1.value35 = "-A\173s\129!\145"
t1.value40 = 30710366779356
t1.value31 = {}
t1.value41 = {}
t2.value51 = {
	Toggles = {},
	Sliders = t1.value41,
	Keybinds = t1.value31
}
t2.value50:CreateCategory("Combat")

local value50 = t2.value50

t1.value40 = 10814496314283
t1.value35 = "\20\252\184A\245$"

local Combat = value50:CreateTab("Combat", "10734975692")
local v593 = Combat:CreateSection("Auto Defense", "10734975692", "Parry & Dodge Core", "Left")
local Toggles = t2.value51.Toggles

t1.value31 = "Auto Parry"
t1.value40 = t2.value10
Toggles.AutoParry = v593:AddToggle(t1.value31, t1.value40.AutoParry, function(p63)
	t2.value10.AutoParry = p63
	v75()

	if t2.value10.AutoParry or (t2.value10.AutoDodge or t2.value10.AlwaysDefendUltimates) then
		t2.value31()
	else
		t2.value25()
	end
end)

local Toggles2 = t2.value51.Toggles

t1.value35 = t2.value10.LegitMode

function t1.value40(p64)
	t2.value10.LegitMode = p64

	if not t2.value10.AutoSaveConfig then
		return
	end

	t2.value19(t2.value16)
end

Toggles2.LegitMode = v593:AddToggle("Legit Mode (Strict Checks)", t1.value35, t1.value40)

local Toggles3 = t2.value51.Toggles

t1.value31 = "Auto Dodge"
t1.value35 = t2.value10.AutoDodge
Toggles3.AutoDodge = v593:AddToggle(t1.value31, t1.value35, function(p65)
	t2.value10.AutoDodge = p65

	if not t2.value10.AutoSaveConfig then
		if t2.value10.AutoParry or (t2.value10.AutoDodge or t2.value10.AlwaysDefendUltimates) then
			t2.value31()
		else
			t2.value25()
		end

		return
	end

	t2.value19(t2.value16)

	if t2.value10.AutoParry or (t2.value10.AutoDodge or t2.value10.AlwaysDefendUltimates) then
		t2.value31()
	else
		t2.value25()
	end
end)

local Toggles4 = t2.value51.Toggles

t1.value31 = "100% Defense on Ultimates"
t1.value40 = t2.value10
Toggles4.AlwaysDefendUltimates = v593:AddToggle(t1.value31, t1.value40.AlwaysDefendUltimates, function(p66)
	t2.value10.AlwaysDefendUltimates = p66

	if not t2.value10.AutoSaveConfig then
		if t2.value10.AutoParry or (t2.value10.AutoDodge or t2.value10.AlwaysDefendUltimates) then
			t2.value31()
		else
			t2.value25()
		end

		return
	end

	t2.value19(t2.value16)

	if t2.value10.AutoParry or (t2.value10.AutoDodge or t2.value10.AlwaysDefendUltimates) then
		t2.value31()
	else
		t2.value25()
	end
end)

local v598 = Combat:CreateSection("Defense Parameters", "10734950309", "Chance & Visuals", "Right")

t1.value41 = t2.value51.Sliders
t1.value35 = "Parry Chance (%)"
t1.value40 = 0

local value10 = t2.value10

t1.value41.ParryChance = v598:AddSlider(t1.value35, t1.value40, 100, value10.ParryChance, 1, function(p67)
	t2.value10.ParryChance = p67

	if not t2.value10.AutoSaveConfig then
		return
	end

	t2.value19(t2.value16)
end)
t1.value41 = t2.value51.Sliders
t1.value35 = "Dodge Chance (%)"

local DodgeChance = t2.value10.DodgeChance

t1.value41.DodgeChance = v598:AddSlider(t1.value35, 0, 100, DodgeChance, 1, function(p68)
	t2.value10.DodgeChance = p68

	if not t2.value10.AutoSaveConfig then
		return
	end

	t2.value19(t2.value16)
end)
t1.value41 = t2.value51.Toggles
t1.value35 = "Parry Flash Effect"

local value102 = t2.value10

t1.value41.ParryFlash = v598:AddToggle(t1.value35, value102.ParryFlash, function(p69)
	t2.value10.ParryFlash = p69

	if not t2.value10.AutoSaveConfig then
		return
	end

	t2.value19(t2.value16)
end)
t1.value41 = Combat:CreateSection("Ultimate Ability", "10734950309", "Close Range Automation", "Right")

local Toggles5 = t2.value51.Toggles

t1.value40 = "Auto Ultimate Ability"

local value103 = t2.value10

Toggles5.AutoUltimate = t1.value41:AddToggle(t1.value40, value103.AutoUltimate, function(p70)
	t2.value10.AutoUltimate = p70

	if not t2.value10.AutoSaveConfig then
		return
	end

	t2.value19(t2.value16)
end)

local Toggles6 = t2.value51.Toggles
local UltimateNearTarget = t2.value10.UltimateNearTarget

Toggles6.UltimateNearTarget = t1.value41:AddToggle("Only Near Opponent", UltimateNearTarget, function(p71)
	t2.value10.UltimateNearTarget = p71

	if not t2.value10.AutoSaveConfig then
		return
	end

	t2.value19(t2.value16)
end)
t2.value51.Toggles.UltimateFacingOnly = t1.value41:AddToggle("Must Face Opponent", t2.value10.UltimateFacingOnly, function(p72)
	t2.value10.UltimateFacingOnly = p72

	if not t2.value10.AutoSaveConfig then
		return
	end

	t2.value19(t2.value16)
end)

local Sliders = t2.value51.Sliders

t1.value40 = "Strike Range (Studs)"

local value104 = t2.value10

Sliders.UltimateDistance = t1.value41:AddSlider(t1.value40, 6, 25, value104.UltimateDistance, 1, function(p73)
	t2.value10.UltimateDistance = p73

	if not t2.value10.AutoSaveConfig then
		return
	end

	t2.value19(t2.value16)
end)
t1.value41:AddButton("Force Trigger Ultimate", function()
	t2.value30()
end)
t2.value50:CreateCategory("Customization")
t1.value31 = t2.value50:CreateTab("Cosmetics", "10709791437")
t2.value52 = "Katana"

local Katana = t2.value11.equippedCosmetics.Katana

if not Katana then
	t1.value43 = t2.value9

	local value1 = t1.value1

	t1.value42 = t1.value43.Katana

	local value42 = t1.value42

	if t1.value42 then
		value42 = t2.value9.Katana[1]
	end

	t1.value1 = value1
	Katana = value42 or "Default"
end

t2.value53 = Katana
t2.value54 = nil

local v611 = t1.value31:CreateSection("Weapon Skin Changer", "10709791437", "Equip Custom Skins", "Left")
local AddDropdown = v611.AddDropdown

function t1.value42(p74)
	t2.value52 = p74

	local v613 = t2.value9[p74] or { "Default" }

	t2.value53 = t2.value11.equippedCosmetics[p74] or (v613[1] or "Default")

	local value54 = t2.value54

	if value54 then
		value54 = t2.value54.Refresh
	end

	if not value54 then
		return
	end

	t2.value54:Refresh(v613, t2.value53)
end

AddDropdown(v611, "Weapon", t1.value9, t2.value52, t1.value42)

local v615 = t2.value9[t2.value52] or { "Default" }

function t1.value43(p75)
	t2.value53 = p75
end

t2.value54 = v611:AddDropdown("Skin", v615, t2.value53, t1.value43)
v611:AddButton("Equip Skin", function()
	t2.value34(t2.value52, t2.value53)
end)

local v616 = t1.value31:CreateSection("Inventory Unlocker", "10723374641", "Unlock All Skins", "Right")

t2.value51.Toggles.UnlockAllCosmetics = v616:AddToggle("Auto Unlock on Menu", t2.value10.UnlockAllCosmetics, function(p76)
	t2.value10.UnlockAllCosmetics = p76

	if t2.value10.AutoSaveConfig then
		t2.value19(t2.value16)
	end

	if not p76 then
		return
	end

	t2.value36()
end)

function t1.value43()
	t2.value36()
end

v616:AddButton("Force Unlock All", t1.value43)
v616:AddButton("Equip All Top Tier Skins", function()
	for k, v in pairs({
		Katana = "DarkMatter",
		Kusarigama = "Celestial",
		Daggers = "CrimsonFangs",
		Naginata = "SerpentSlayer",
		Gauntlets = "Magma",
		Warhammer = "Iceborn",
		CurvedBlades = "Scorchflower",
		BoStaff = "Void"
	}) do
		t2.value34(k, v)
	end
end)
t2.value51.Toggles.AutoApplyCosmetics = v616:AddToggle("Auto Re-apply on Spawn", t2.value10.AutoApplyCosmetics, function(p77)
	t2.value10.AutoApplyCosmetics = p77

	if not t2.value10.AutoSaveConfig then
		return
	end

	t2.value19(t2.value16)
end)
t2.value50:CreateCategory("Utilities")
t1.value42 = t2.value50:CreateTab("Settings", "10734950309")

local Configuration = t1.value42:CreateSection("Configuration", "10734950309", "Save & Load Configs", "Left")

t1.value43 = t2.value16 or "default"
t2.value55 = t1.value43
t1.value43 = Configuration.AddTextBox
t1.value43 = t1.value43(Configuration, "Config Name", "Enter name...", t2.value55, function(p78)
	local value55 = p78:gsub("[%c%p%s]", "_")

	if value55 == "" then
		return
	end

	t2.value55 = value55
end)
t2.value56 = t1.value43
t2.value57 = Configuration:AddDropdown("Select Config", t2.value18(), t2.value16, function(p79)
	t2.value16 = p79
	t2.value55 = p79

	local value56 = t2.value56

	if value56 then
		value56 = t2.value56.Set
	end

	if not value56 then
		return
	end

	t2.value56:Set(p79)
end)

function t2.value58()
	local v622, v623, v624 = pairs(t2.value51.Toggles)

	while true do
		local v625

		v624, v625 = v622(v623, v624)

		if not v624 then
			break
		end

		local v626

		if t2.value10[v624] == nil then
			v626 = false
		else
			v626 = v625.Set
		end

		if v626 then
			v625:Set(t2.value10[v624], true)
		end
	end

	for k, slider in pairs(t2.value51.Sliders) do
		local v629

		if t2.value10[k] == nil then
			v629 = false
		else
			v629 = slider.Set
		end

		if v629 then
			slider:Set(t2.value10[k])
		end
	end

	local ToggleKey = t2.value51.Keybinds.ToggleKey

	if ToggleKey then
		ToggleKey = t2.value51.Keybinds.ToggleKey.Set
	end

	if not ToggleKey then
		return
	end

	t2.value51.Keybinds.ToggleKey:Set(t2.value10.ToggleKey)
end

Configuration:AddButton("Save Config", function()
	local value55 = t2.value55
	local v632 = ((not value55 or value55:gsub("%s+", "") == "") and (t2.value16 or "default") or value55):gsub("[%c%p%s]", "_")
	local value16 = v632 == "" and "default" or v632

	t2.value16 = value16
	t2.value19(value16)

	local v634 = t2.value18()
	local value57 = t2.value57

	if value57 then
		value57 = t2.value57.Refresh
	end

	if value57 then
		t2.value57:Refresh(v634, t2.value16)
	end

	local value56 = t2.value56

	if value56 then
		value56 = t2.value56.Set
	end

	if not value56 then
		return
	end

	t2.value56:Set(t2.value16)
end)
Configuration:AddButton("Load Config", function()
	if not t2.value20(t2.value16) then
		return
	end

	if t2.value50.UIScale then
		t2.value50.ScaleVal = t2.value10.UIScale / 100
		t2.value50.UIScale.Scale = t2.value50.ScaleVal
	end

	t2.value50.ToggleKey = t2.value10.ToggleKey
	t2.value58()
	t2.value35()

	if t2.value10.AutoParry or (t2.value10.AutoDodge or t2.value10.AlwaysDefendUltimates) then
		t2.value25()
		t2.value31()

		return
	end

	t2.value25()
end)
Configuration:AddButton("Refresh Configs", function()
	local v637 = t2.value18()
	local value57 = t2.value57

	if value57 then
		value57 = t2.value57.Refresh
	end

	if not value57 then
		return
	end

	t2.value57:Refresh(v637, t2.value16)
end)
t2.value51.Toggles.AutoSaveConfig = Configuration:AddToggle("Auto Save Config", t2.value10.AutoSaveConfig, function(p80)
	t2.value10.AutoSaveConfig = p80

	if not p80 then
		return
	end

	t2.value19(t2.value16)
end)

local v639 = t1.value42:CreateSection("Interface & Keys", "10734950309", "Hub Configuration", "Right")

t2.value51.Keybinds.ToggleKey = v639:AddKeybind("Toggle UI Keybind", t2.value10.ToggleKey, function(p81)
	t2.value10.ToggleKey = p81
	t2.value50.ToggleKey = p81

	if not t2.value10.AutoSaveConfig then
		return
	end

	t2.value19(t2.value16)
end)
t2.value51.Sliders.UIScale = v639:AddSlider("UI Scale (%)", 70, 130, t2.value10.UIScale, 1, function(p82)
	t2.value10.UIScale = p82
	t2.value50.ScaleVal = p82 / 100

	if t2.value50.IsUIOpen then
		t2.value50.UIScale.Scale = t2.value50.ScaleVal
	end

	if not t2.value10.AutoSaveConfig then
		return
	end

	t2.value19(t2.value16)
end)
t1.value42:CreateSection("Unload", "10747384394", "Terminate Script", "Right"):AddButton("Unload Script", function()
	t2.value11.isScriptDestroyed = true
	t2.value25()

	if not t2.value50.ScreenGui then
		return
	end

	t2.value50.ScreenGui:Destroy()
end)
t2.value6.CharacterAdded:Connect(function(character)
	t2.value11.handler = nil
	task.wait(0.8)

	if t2.value10.AutoParry or (t2.value10.AutoDodge or t2.value10.AlwaysDefendUltimates) then
		t2.value25()
		t2.value31()
	end

	if not t2.value10.AutoApplyCosmetics then
		t2.value37(character)

		return
	end

	t2.value35()
	t2.value37(character)
end)

if t2.value6.Character then
	t2.value37(t2.value6.Character)

	if t2.value10.AutoParry or (t2.value10.AutoDodge or t2.value10.AlwaysDefendUltimates) then
		t2.value25()
		t2.value31()
	end
end

if t2.value10.UnlockAllCosmetics then
	t2.value36()
end

if not t2.value10.AutoApplyCosmetics then
	return
end

t2.value35()
