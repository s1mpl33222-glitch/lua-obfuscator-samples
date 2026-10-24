-- This file was generated at discord.gg/syncrypt

local unpack_ = unpack or table.unpack
local createFrame = nil

if getgenv().iCollectPro_PS99Spawner_Kill then
	task.spawn(pcall, getgenv().iCollectPro_PS99Spawner_Kill)
end

local ipairs_ = ipairs
local gethui_ = gethui

if gethui_ then
	gethui_ = gethui()
end

for _, v in ipairs_({ gethui_, game:GetService("CoreGui"), game:GetService("Players").LocalPlayer:FindFirstChild("PlayerGui") }) do
	if v then
		for _, child in ipairs(v:GetChildren()) do
			if child.Name == "iCollectPro_PS99Spawner" then
				child:Destroy()
			end
		end
	end
end

local Players = game:GetService("Players")
local game_ = game

game_ = game_.GetService(game_, "UserInputService")

local t1 = {
	value1 = game:GetService("TweenService")
}
local game_2 = game

t1.value2 = game_2.GetService(game_2, "HttpService")
t1.value3 = Players.LocalPlayer
Players = game
Players = Players.GetService(Players, "ReplicatedStorage")
Players = Players.WaitForChild(Players, "Library")
t1.value4 = require(Players.Directory)
t1.value5 = require(Players.Items.PetItem)
t1.value6 = require(Players.Client.InventoryCmds)
t1.value7 = require(Players.Client.PlayerPet)
t1.value8 = require(Players.Client.Network)
t1.value9 = require(Players.Client.Save)
t1.value10 = require(Players.Client.MapCmds)
t1.value11 = require(Players.Client.ZoneCmds)
t1.value12 = require(Players.Client.CurrencyCmds)
t1.value13 = require(Players.Client.UpgradeCmds)
t1.value14 = require(Players.Client.EnchantCmds)
t1.value15 = require(Players.Balancing)
t1.value16 = require(Players.Util.RanksUtil)
t1.value17 = require(Players.Util.WorldsUtil)
t1.value18 = require(Players.Client.EggCmds)
t1.value19 = require(Players.Client.RebirthCmds)
t1.value20 = require(Players.Client.RankCmds)
t1.value21 = require(Players.Client.PetCmds)
t1.value22 = t1.value5.Directory
t1.value23 = {
	BG = Color3.fromRGB(20, 12, 34),
	SURF = Color3.fromRGB(28, 16, 46),
	SURF2 = Color3.fromRGB(48, 26, 76),
	HOVER = Color3.fromRGB(62, 34, 96),
	TEXT = Color3.fromRGB(240, 232, 255),
	DIM = Color3.fromRGB(155, 120, 200),
	ACCENT = Color3.fromRGB(168, 85, 247),
	STROKE = Color3.fromRGB(150, 70, 230),
	GREEN1 = Color3.fromRGB(18, 88, 58),
	GREEN2 = Color3.fromRGB(21, 120, 76),
	GREEN_STROKE = Color3.fromRGB(60, 185, 120),
	ON_TEXT = Color3.fromRGB(232, 255, 240),
	OFF_BG = Color3.fromRGB(48, 26, 74),
	OFF_TEXT = Color3.fromRGB(140, 110, 180),
	RED = Color3.fromRGB(255, 110, 130),
	GREEN = Color3.fromRGB(110, 235, 160),
	YELLOW = Color3.fromRGB(255, 205, 90)
}
t1.value24 = {
	248,
	69,
	95,
	115,
	181,
	140,
	226,
	232,
	212,
	115,
	8,
	16,
	33,
	29,
	40,
	108,
	17,
	136,
	144
}
t1.value25 = {
	dmg = {
		196,
		141,
		162,
		178,
		230,
		183,
		102,
		14,
		19,
		36,
		81,
		58,
		99,
		52,
		75,
		187,
		217,
		166,
		191,
		218,
		126,
		120,
		169,
		223,
		174,
		98,
		254
	},
	oc = {
		209,
		141,
		159,
		196,
		181,
		118,
		71,
		20,
		19,
		18,
		102,
		79
	},
	ol = {
		209,
		141,
		159,
		196,
		181,
		118,
		71,
		17,
		26,
		29,
		87,
		77,
		107
	},
	zp = {
		220,
		138,
		171,
		182,
		238,
		181,
		86,
		7,
		31,
		38,
		87,
		93,
		107,
		35,
		71,
		200,
		202,
		202,
		187,
		236,
		119
	},
	fg = {
		212,
		128,
		161,
		182,
		224,
		195,
		36,
		232,
		32,
		22,
		87,
		10,
		62,
		60,
		56,
		202
	},
	rr = {
		212,
		124,
		171,
		188,
		238,
		181,
		71,
		14,
		15,
		26,
		95,
		60,
		92,
		74,
		51,
		200,
		203
	},
	ep = {
		199,
		130,
		164,
		196,
		218,
		168,
		105,
		19,
		35,
		22,
		101,
		94,
		71,
		72,
		68,
		185,
		207,
		195,
		205,
		222
	},
	ps = {
		199,
		140,
		178,
		186,
		235,
		169,
		112,
		17,
		34,
		36,
		63,
		75,
		90,
		59,
		59,
		196,
		204,
		193,
		172,
		222,
		131,
		169,
		173,
		229,
		193,
		75,
		14,
		23,
		11,
		81,
		66,
		97,
		47
	},
	fp = {
		200,
		138,
		175,
		182,
		241,
		187,
		118,
		242,
		15,
		20,
		93,
		93,
		49,
		243,
		21,
		194,
		200,
		203,
		199,
		153,
		88,
		166,
		173,
		215
	},
	pet = { 210, 128, 177 },
	sm = {
		213,
		144,
		173,
		182,
		237,
		118,
		81,
		3,
		21,
		31,
		87,
		94
	},
	ih = {
		201,
		135,
		172,
		179,
		220,
		194,
		77,
		16,
		33,
		37,
		83,
		88,
		107,
		27,
		51,
		202,
		202,
		202
	}
}
t1.value26 = {
	61,
	93,
	140,
	109,
	162,
	188,
	163,
	18,
	206,
	223,
	72,
	254,
	51,
	29,
	46,
	105,
	74,
	136,
	126,
	164,
	193,
	207
}

function t1.value27(p1)
	local t2 = {}

	for i, v in ipairs(p1 or t1.value24) do
		t2[i] = string.char((v - 17 * i) * 171 % 256)
	end

	return table.concat(t2)
end

t1.value28 = nil
t1.value29 = nil
t1.value30 = ""

function t1.value31()
	local value28 = t1.value28
	local value29 = t1.value29
	local Parent

	if value29 then
		if value29.Parent == value28 then
			Parent = value28.Parent
		else
			Parent = false
		end

		if Parent then
			Parent = value29.Visible

			if Parent then
				Parent = value29.TextTransparency < 0.5

				if Parent then
					if value29.TextSize >= 8 then
						Parent = value29.Text == t1.value27(t1.value26)
					else
						Parent = false
					end
				end
			end
		end
	else
		Parent = value29
	end

	if not Parent then
		return ""
	end

	local Parent2

	if value28 then
		Parent2 = value28.Parent

		if Parent2 then
			Parent2 = value28.Visible

			if Parent2 then
				Parent2 = value28.TextTransparency < 0.5

				if Parent2 then
					if value28.TextSize >= 8 then
						Parent2 = value28:IsDescendantOf(game)
					else
						Parent2 = false
					end
				end
			end
		end
	else
		Parent2 = value28
	end

	if not Parent2 then
		return ""
	end

	local ScreenGui = value28:FindFirstAncestorWhichIsA("ScreenGui")

	if ScreenGui then
	elseif ScreenGui then
		return value28.Text
	else
		return ""
	end

	ScreenGui = ScreenGui.Enabled

	if ScreenGui then
		return value28.Text
	else
		return ""
	end
end

t1.value32 = {}

function t1.value33(p2)
	local value30 = t1.value30
	local v22 = t1.value32[p2]
	local v23

	if v22 then
		v23 = v22.s == value30
	else
		v23 = v22
	end

	if v23 then
		return v22.v
	end

	local v24 = #value30
	local n1 = 1
	local v26 = n1 < 0
	local v27 = 1 - n1
	local v28 = v24
	local t3 = {}
	local n2 = 0

	while true do
		local v31 = not v26

		v27 = v27 + n1

		if v31 then
			v31 = v27 <= v24
		end

		if not (v26 and v24 <= v27 and true or v31) then
			for i, v in ipairs(p2) do
				local v34 = v28 > 0

				if v34 then
					v34 = value30:byte((i - 1) % v28 + 1)
				end

				local v35 = (v - (v34 or 0) * 7 - i * 13 - n2) % 256

				t3[i] = string.char(v35)
			end

			local v36 = table.concat(t3)

			t1.value32[p2] = {
				s = value30,
				v = v36
			}

			return v36
		end

		n2 = (n2 * 31 + value30:byte(v27) * v27) % 256
	end
end

t1.value34 = true
t1.value35 = {}
t1.value36 = nil

function t1.value36()
	local value30 = t1.value30

	if value30 == "" or (#value30 ~= #t1.value24 and true or value30 ~= t1.value27()) then
		return false
	else
		local n3 = 0

		for i = 1, #value30 do
			n3 = (n3 * 31 + value30:byte(i) * i) % 256
		end

		return n3 == t1.value24[7] - 136
	end
end
function t1.value37(p3)
	return function(...)
		if t1.value36() then
			return p3(...)
		end
	end
end

t1.value38 = "iCollectPro_PS99.json"
t1.value39 = {
	tap = false,
	collect = false,
	hatch = false,
	areas = false,
	bestzone = false,
	upgrades = false,
	slots = false,
	rebirth = false,
	gifts = false,
	ranks = false,
	lowlag = false,
	afk = true
}
pcall(function()
	local isfile_ = isfile

	if isfile_ then
		isfile_ = isfile(t1.value38)
	end

	if not isfile_ then
		return
	end

	local pairs_ = pairs
	local value2 = t1.value2
	local t4 = { readfile(t1.value38) }

	for k, v in pairs_(value2.JSONDecode(value2, unpack_(t4))) do
		local v46

		if t1.value39[k] == nil then
			v46 = false
		else
			v46 = type(v) == "boolean"
		end

		if v46 then
			t1.value39[k] = v
		end
	end
end)
t1.value40 = {
	pet = nil,
	variant = 0,
	shiny = false,
	amount = 1,
	follow = true
}
t1.value41 = 12
t1.value42 = {}
t1.value43 = {}
game_2 = {
	"Gargantuan",
	"Titanic",
	"Huge",
	"Secret",
	"Exclusive",
	"Celestial",
	"Superior",
	"Divine",
	"Exotic",
	"Mythical",
	"Legendary",
	"Epic",
	"Rare",
	"Basic"
}
t1.value44 = {}

local t5 = {
	[0] = "NORMAL",
	[1] = "GOLDEN",
	[2] = "RAINBOW"
}

local function v48(p4, p5)
	local connection = p4:Connect(t1.value37(p5))

	t1.value35[#t1.value35 + 1] = connection

	return connection
end

for _, v in ipairs(game_2) do
	t1.value44[v] = {
		pets = {},
		color = t1.value23.TEXT
	}
end

t1.value44.Gargantuan.color = t1.value23.YELLOW
t1.value44.Titanic.color = t1.value23.YELLOW
t1.value44.Huge.color = t1.value23.ACCENT

local v52, v53

v52, gethui_, v53 = pairs(t1.value22)

while true do
	local v54

	v53, v54 = v52(gethui_, v53)

	if not v53 then
		break
	end

	if type(v54) == "table" then
		ipairs_ = not v54.hidden
	else
		ipairs_ = false
	end

	if ipairs_ then
		if v54.gargantuan then
			ipairs_ = "Gargantuan"
		elseif v54.titanic then
			ipairs_ = "Titanic"
		elseif v54.huge then
			ipairs_ = "Huge"
		elseif v54.secret then
			ipairs_ = "Secret"
		elseif v54.exclusiveLevel then
			ipairs_ = "Exclusive"
		else
			ipairs_, v311 = pcall(function()
				local rarity = v54.rarity

				if rarity then
					return rarity
				end

				local v56 = v53

				rarity = t1.value5(v56):GetRarity()

				return rarity
			end)

			if ipairs_ then
				if v311 then
					ipairs_ = v311.DisplayName
				else
					ipairs_ = v311
				end
			end

			ipairs_ = ipairs_ or "Basic"
			v110 = t1.value44[ipairs_]

			if v110 then
				if v311 then
					v110 = v311.Color
				else
					v110 = v311
				end
			end

			if v110 then
				t1.value44[ipairs_].color = v311.Color
			end
		end

		if not t1.value44[ipairs_] then
			t1.value44[ipairs_] = {
				pets = {},
				color = t1.value23.TEXT
			}
			table.insert(game_2, ipairs_)
		end

		v110 = t1.value44[ipairs_].pets
		table.insert(v110, v53)
	end
end

for _, v in pairs(t1.value44) do
	table.sort(v.pets)
end

for i = #game_2, 1, -1 do
	if #t1.value44[game_2[i]].pets == 0 then
		table.remove(game_2, i)
	end
end

function t1.value45()
	return t1.value2:GenerateGUID(false):gsub("-", ""):lower()
end
function t1.value46()
	task.spawn(pcall, t1.value7.UpdatePlayerPlacements, t1.value3)
end
function t1.value47(p6, p7)
	local v60, v61, v62 = pairs(t1.value43)
	local n4 = 0

	while true do
		v62 = v60(v61, v62)

		if not v62 then
			break
		end

		n4 = n4 + 1
	end

	if t1.value41 <= n4 then
		return
	end

	local Character = t1.value3.Character

	if not Character then
		return
	end

	local v65 = t1.value5(p7.id)
	local pt = p7.pt

	v65.SetType(v65, pt or 0)
	v65:SetShiny(p7.sh == true)
	v65:SetUID(p6)

	local v67 = "fake_" .. p6
	local ok, result = pcall(t1.value7.new, v67, v65, t1.value3)

	if not (ok and result) then
		return
	end

	function result.SetTarget(p8, p9)
		p8.target = p9
		task.spawn(pcall, p8.cpet.SetTarget, p8.cpet, p9)
	end

	t1.value43[v67] = result
	task.spawn(pcall, result.SetTargetWithoutNetworking, result, Character)
end
function t1.value48(p10, p11, p12, p13)
	local v70 = t1.value6.Container()

	if not v70 then
		return false, "INVENTORY NOT LOADED"
	end

	local t6 = {
		id = p10
	}

	if p11 ~= 0 then
		t6.pt = p11
	end

	if p12 then
		t6.sh = true
	end

	local v72 = t1.value5(p10)
	local IsStackable = v72.IsStackable

	if IsStackable then
		IsStackable = v72:IsStackable()
	end

	local t7 = {}
	local t8 = {}

	if IsStackable then
		local v76 = t1.value45()
		local v77 = table.clone(t6)

		if p13 > 1 then
			v77._am = p13
		end

		t7[v76] = v77
		t8[#t8 + 1] = { v76, v77 }
	else
		for _ = 1, p13 do
			local v79 = t1.value45()

			t7[v79] = table.clone(t6)

			local t9 = { v79, t7[v79] }

			t8[#t8 + 1] = t9
		end
	end

	local function v81()
		local v82 = v70
		local t10 = {
			set = {
				[t1.value33(t1.value25.pet)] = t7
			}
		}

		v82.ApplyPacket(v82, t10)
	end

	local ok, result = pcall(v81)

	if not ok then
		return false, "FAILED: " .. tostring(result)
	end

	if not t1.value5:Get(t8[1][1]) then
		return false, "FAILED"
	end

	for _, v in ipairs(t8) do
		t1.value42[#t1.value42 + 1] = v[1]
	end

	if not t1.value40.follow then
		return true
	end

	task.spawn(function()
		for _, v in ipairs(t8) do
			local pcall_ = pcall
			local v91 = v[1]
			local v92 = v[2]

			pcall_(t1.value47, v91, v92)
		end

		t1.value46()
	end)

	return true
end
function t1.value49()
	for k, v in pairs(t1.value43) do
		pcall(v.Cleanup, v)
		t1.value43[k] = nil
	end

	local v95 = t1.value6.Container()
	local v96

	if v95 then
		v96 = #t1.value42 > 0
	else
		v96 = v95
	end

	if not v96 then
		table.clear(t1.value42)
		t1.value46()

		return
	end

	local function v97()
		v95:ApplyPacket({
			del = t1.value42
		})
	end

	pcall(v97)
	table.clear(t1.value42)
	t1.value46()
end

local connection = t1.value3.CharacterAdded:Connect(t1.value37(function(p14)
	task.wait(1)

	for _, v in pairs(t1.value43) do
		task.spawn(pcall, v.SetTargetWithoutNetworking, v, p14)
	end

	t1.value46()
end))

t1.value35[#t1.value35 + 1] = connection
t1.value50 = {
	coins = nil,
	rate = 0,
	taps = 0,
	orbs = 0,
	areas = 0,
	upgrades = 0,
	gifts = 0,
	ranks = 0,
	hatches = 0,
	rebirths = 0,
	slots = 0,
	hatchNote = ""
}

function t1.value51()
	local Character = t1.value3.Character

	if Character then
		Character = Character:FindFirstChild("HumanoidRootPart")
	end

	if not Character then
		return Character
	end

	Character = Character.Position

	return Character
end
function t1.value52()
	local __THINGS = workspace:FindFirstChild("__THINGS")

	if __THINGS then
		__THINGS = workspace.__THINGS:FindFirstChild("Breakables")
	end

	local v103 = t1.value51()

	if not (__THINGS and v103) then
		return {}
	end

	local v104 = t1.value10.GetCurrentZone()
	local t11 = {}

	for _, child in ipairs(__THINGS:GetChildren()) do
		local isModel = child:IsA("Model")

		if isModel then
			isModel = child:GetAttribute("ParentID") == v104
		end

		if isModel then
			local attribute = child:GetAttribute("BreakableUID")

			if attribute then
				t11[#t11 + 1] = {
					uid = attribute,
					model = child,
					dist = (child:GetPivot().Position - v103).Magnitude
				}
			end
		end
	end

	table.sort(t11, function(p15, p16)
		return p15.dist < p16.dist
	end)

	return t11
end
function t1.value53()
	local v111 = t1.value14.GetPower("Swift Taps")
	local v112

	if type(v111) == "number" then
		v112 = v111 > 0
	else
		v112 = false
	end

	return not v112 and 8 or math.min(8 * (1 + v111 / 100), 16)
end

t1.value54 = math.huge
t1.value55 = 30
task.spawn(function()
	local value55 = t1.value55
	local n5 = 0
	local n6 = 0
	local t12 = {}

	while t1.value34 do
		local tap = t1.value39.tap

		if tap then
			tap = t1.value36()
		end

		if tap then
			local function v117()
				local now = os.clock()

				if now - n5 > 5 then
					local value552 = t1.value55
					local value53 = t1.value53

					value55 = math.max(value552, value53())
					n5 = now
				end

				local value54

				if not (now - n6 > 0.25) then
					v134 = 0

					for _, v in ipairs(t12) do
						if v.model.Parent then
							t1.value8.UnreliableFire(t1.value33(t1.value25.dmg), v.uid)
							value54 = t1.value54
							v134 = v134 + 1

							if value54 <= v134 then
								v137 = t1.value50
								v138 = "taps"
								v137[v138] = v137[v138] + v134
								t1.value50.targets = #t12

								return
							end
						end
					end

					v137 = t1.value50
					v138 = "taps"
					v137[v138] = v137[v138] + v134
					t1.value50.targets = #t12

					return
				end

				t12 = t1.value52()
				n6 = now

				local n7 = 0

				for _, v in ipairs(t12) do
					if v.model.Parent then
						t1.value8.UnreliableFire(t1.value33(t1.value25.dmg), v.uid)
						value54 = t1.value54
						n7 = n7 + 1

						if value54 <= n7 then
							v137 = t1.value50
							v138 = "taps"
							v137[v138] = v137[v138] + n7
							t1.value50.targets = #t12

							return
						end
					end
				end

				local value50 = t1.value50
				local s1 = "taps"

				value50[s1] = value50[s1] + n7
				t1.value50.targets = #t12
			end

			pcall(v117)
			task.wait(1 / value55)
		else
			task.wait(0.25)
		end
	end
end)
t1.value56 = t1.value14.GetPower

function t1.value14.GetPower(p17, ...)
	local v129 = p17 == t1.value33(t1.value25.sm)

	if v129 then
		v129 = t1.value39.collect

		if v129 then
			v129 = t1.value34

			if v129 then
				v129 = t1.value36()
			end
		end
	end

	if not v129 then
		return t1.value56(p17, ...)
	end

	local ok, result = pcall(t1.value56, p17, ...)
	local max = math.max

	if not ok then
		return max(ok or 0, 1)
	end

	ok = tonumber(result)

	return max(ok or 0, 1)
end

t1.value57 = nil

function t1.value58()
	if t1.value14.GetPower == t1.value56 then
		return
	end

	t1.value14.GetPower = t1.value56
end

t1.value59 = nil

function t1.value57(p18)
	local Map = workspace:FindFirstChild("Map")

	if Map then
		Map = workspace.Map:FindFirstChild(unpack_({ tostring(p18.ZoneFolder) }))
	end

	if not Map then
		return
	end

	local INTERACT = Map:FindFirstChild("INTERACT")
	local BREAKABLE_SPAWNS

	if INTERACT then
		BREAKABLE_SPAWNS = INTERACT:FindFirstChild("BREAKABLE_SPAWNS")
	else
		BREAKABLE_SPAWNS = INTERACT
	end

	if INTERACT then
		INTERACT = INTERACT:FindFirstChild("BREAK_ZONES")
	end

	if BREAKABLE_SPAWNS then
		BREAKABLE_SPAWNS = BREAKABLE_SPAWNS:FindFirstChild("Main") or BREAKABLE_SPAWNS:FindFirstChildWhichIsA("BasePart")
	end

	if BREAKABLE_SPAWNS then
		INTERACT = BREAKABLE_SPAWNS
	elseif INTERACT then
		INTERACT = INTERACT:FindFirstChildWhichIsA("BasePart")
	end

	local PERSISTENT = Map:FindFirstChild("PERSISTENT")

	if PERSISTENT then
		PERSISTENT = Map.PERSISTENT:FindFirstChild("Teleport")
	end

	local Character = t1.value3.Character
	local isBasePart

	if not Character then
		if Character and (INTERACT or PERSISTENT) then
			if INTERACT then
				isBasePart = INTERACT:IsA("BasePart")
			else
				isBasePart = INTERACT
			end

			if isBasePart then
				Character.CFrame = CFrame.new(INTERACT.Position + Vector3.new(0, INTERACT.Size.Y / 2 + 4, 0))
			else
				Character.CFrame = PERSISTENT.CFrame + Vector3.new(0, 4, 0)
			end

			t1.value50.zone = p18._id
		end

		return
	end

	Character = Character:FindFirstChild("HumanoidRootPart")

	if Character and (INTERACT or PERSISTENT) then
		if INTERACT then
			isBasePart = INTERACT:IsA("BasePart")
		else
			isBasePart = INTERACT
		end

		if isBasePart then
			Character.CFrame = CFrame.new(INTERACT.Position + Vector3.new(0, INTERACT.Size.Y / 2 + 4, 0))
		else
			Character.CFrame = PERSISTENT.CFrame + Vector3.new(0, 4, 0)
		end

		t1.value50.zone = p18._id
	end
end
function t1.value60()
	local _, v140 = t1.value11.GetMaxOwnedZone()

	if v140 and v140._id then
		if t1.value10.GetCurrentZone() == v140._id then
			return
		else
			t1.value57(v140)

			return
		end
	end
end
function t1.value61(p19)
	local pairs_ = pairs

	for _, zone in pairs_(t1.value4.Zones) do
		local v144 = type(zone) == "table"

		if v144 then
			v144 = zone.ZoneNumber == p19

			if v144 then
				v144 = (zone.WorldNumber or 1) == (t1.value17.GetWorldNumber() or 1)
			end
		end

		if v144 then
			return zone
		end
	end
end

t1.value62 = {}
v52 = function()
	if t1.value59 then
		return
	end

	local function v145()
		local function v146(p20)
			if not t1.value39.collect or type(p20) ~= "table" then
				return
			end

			local v147, v148, v149 = ipairs(p20)
			local t13 = {}

			while true do
				local v151

				v149, v151 = v147(v148, v149)

				if not v149 then
					break
				end

				if v151.id then
					t13[#t13 + 1] = v151.id
				end
			end

			if #t13 == 0 then
				return
			end

			local value50 = t1.value50
			local s2 = "orbs"

			value50[s2] = value50[s2] + #t13
			task.delay(1, function()
				local value34 = t1.value34

				if value34 then
					value34 = t1.value39.collect
				end

				if not value34 then
					return
				end

				pcall(t1.value8.Fire, t1.value33(t1.value25.ol), t13)
			end)
		end

		t1.value59 = t1.value8.Fired(t1.value33(t1.value25.oc)):Connect(t1.value37(v146))
	end

	pcall(v145)
end

for _, egg in pairs(t1.value4.Eggs) do
	ipairs_ = type(egg) == "table"

	if ipairs_ then
		ipairs_ = egg.eggNumber

		if ipairs_ then
			ipairs_ = (egg.worldNumber or 1) == (t1.value17.GetWorldNumber() or 1)
		end
	end

	if ipairs_ then
		t1.value62[egg.eggNumber] = egg
	end
end

function t1.value63(p21)
	local __THINGS = workspace:FindFirstChild("__THINGS")

	if __THINGS then
		for _, v in ipairs({ "ZoneEggs", "Eggs" }) do
			local Main = __THINGS:FindFirstChild(v)

			if Main then
				Main = __THINGS[v]:FindFirstChild("Main")
			end

			if Main then
				Main = Main:FindFirstChild(p21 .. " - Egg Capsule")
			end

			if Main then
				return Main
			end
		end

		return nil
	else
		return nil
	end
end

local function v161()
	local v162 = t1.value9.Get()
	local v163 = nil

	for _ = v162 and v162.MaximumAvailableEgg or 1, 1, -1 do
		local v165 = t1.value62[v163]

		if v165 then
			local function v166()
				return t1.value12.CanAfford(v165.currency, t1.value15.CalcEggPrice(v165))
			end

			local ok, result = pcall(v166)

			if ok and result then
				return {
					number = v163,
					egg = v165,
					capsule = t1.value63(nil)
				}
			end
		end
	end

	return nil
end

t1.value64 = nil

function t1.value65(p22)
	local Character = t1.value3.Character

	if Character then
		Character = Character:FindFirstChild("HumanoidRootPart")
	end

	if not Character then
		return
	end

	local Center = p22.capsule:FindFirstChild("Center") or p22.capsule.PrimaryPart

	if not Center then
		v184 = Center or p22.capsule:GetPivot().Position
		Character.CFrame = CFrame.new(v184 + Vector3.new(0, 3, 8), v184)

		return
	end

	Center = Center.Position

	local Position = Center or p22.capsule:GetPivot().Position

	Character.CFrame = CFrame.new(Position + Vector3.new(0, 3, 8), Position)
end
function t1.value66(p23)
	local Magnitude = t1.value51()

	if not Magnitude then
		return Magnitude or math.huge
	end

	Magnitude = (p23.capsule:GetPivot().Position - Magnitude).Magnitude

	return Magnitude or math.huge
end

t1.value64 = nil

function t1.value67(p24)
	if p24 then
		workspace:SetAttribute(t1.value33(t1.value25.ih), true)

		return
	end

	if workspace:GetAttribute(t1.value33(t1.value25.ih)) == t1.value64 then
		return
	end

	workspace:SetAttribute(t1.value33(t1.value25.ih), t1.value64)
end
function t1.value68()
	local v173 = v161()

	if not v173 then
		t1.value50.hatchNote = "CAN\'T AFFORD ANY UNLOCKED EGG"

		return
	end

	local Character = t1.value3.Character

	if Character then
		Character = Character:FindFirstChild("HumanoidRootPart")
	end

	if not Character then
		return
	end

	local CFrame_ = Character.CFrame
	local v176 = false

	if not v173.capsule then
		local value61 = t1.value61
		local zoneNumber = v173.egg.zoneNumber or 0
		local v179 = value61((math.floor(zoneNumber)))

		if v179 then
			t1.value57(v179)
			v176 = true
		end

		local v180 = os.clock() + 3

		repeat
			task.wait(0.2)
			v173.capsule = t1.value63(v173.number)
		until v173.capsule or v180 < os.clock()

		if not v173.capsule then
			Character.CFrame = CFrame_
			t1.value50.hatchNote = "COULDN\'T LOAD " .. v173.egg._id:upper()

			return
		end
	end

	if t1.value66(v173) > 25 then
		t1.value65(v173)
		task.wait(0.35)
		v176 = true
	end

	local v181 = t1.value15.CalcEggPrice(v173.egg)
	local v182 = t1.value18.GetMaxHatch(v173.egg._id) or 1
	local v183 = math.max(1, v182)

	while true do
		if true then
			local v185

			if v183 > 1 then
				v185 = not t1.value12.CanAfford(v173.egg.currency, v181 * v183)
			else
				v185 = false
			end
		end

		if not v199 then
			local v186, v187 = t1.value8.Invoke(t1.value33(t1.value25.ep), v173.egg._id, v183)

			if v176 then
				v176 = Character.Parent
			end

			local value50, s3

			if v176 then
			elseif v186 then
				value50 = t1.value50
				s3 = "hatches"
				value50[s3] = value50[s3] + v183
				t1.value50.hatchNote = string.format("HATCHED %dx %s", v183, v173.egg._id:upper())

				return
			else
				t1.value50.hatchNote = tostring(v187 or "HATCH FAILED"):upper()

				return
			end

			Character.CFrame = CFrame_

			if v186 then
				value50 = t1.value50
				s3 = "hatches"
				value50[s3] = value50[s3] + v183
				t1.value50.hatchNote = string.format("HATCHED %dx %s", v183, v173.egg._id:upper())

				return
			else
				t1.value50.hatchNote = tostring(v187 or "HATCH FAILED"):upper()

				return
			end
		end

		v183 = v183 - 1
	end
end
function t1.value69()
	local _, v190 = t1.value11.GetNextZone()

	if not (v190 and v190.Currency) then
		return
	end

	if not (t1.value12.CanAfford(v190.Currency, t1.value15.CalcGatePrice(v190)) and t1.value8.Invoke(t1.value33(t1.value25.zp), v190._id)) then
		return
	end

	local value50 = t1.value50
	local s4 = "areas"

	value50[s4] = value50[s4] + 1
end
function t1.value70()
	for _, v in pairs(t1.value13.All()) do
		if t1.value13.CanInteractWith(v.UpgradeID, v.ZoneID) then
			local v195 = t1.value4.Upgrades[v.UpgradeID]
			local v196

			if v195 then
				v196 = v195.TierCosts[v.UpgradeTier]
			else
				v196 = v195
			end

			if v195 then
				v195 = v195.TierCurrencies[v.UpgradeTier]
			end

			if v196 then
				if v195 then
					v195 = v196 <= t1.value12.Get(v195._id)
				end
			else
				v195 = v196
			end

			if v195 and t1.value13.Purchase(v.UpgradeID, v.ZoneID) then
				local value50 = t1.value50
				local s5 = "upgrades"

				value50[s5] = value50[s5] + 1
			end
		end
	end
end

connection = require(Players.Client.ForeverPackCmds)
t1.value71 = nil
t1.value71 = connection

function t1.value72()
	local Default = t1.value71.GetState("Default")
	local Slots

	if Default then
		Slots = Default.Slots

		if Slots then
			Slots = Default.Slots[(Default.Slot or 0) + 1]
		end
	else
		Slots = Default
	end

	if Slots then
		Slots = Slots.Free or not Slots.Price
	end

	if not (Slots and t1.value8.Invoke(t1.value33(t1.value25.fp), "Default")) then
		return
	end

	local value50 = t1.value50
	local s6 = "gifts"

	value50[s6] = value50[s6] + 1
end

local function v203()
	pcall(t1.value72)

	local v204 = t1.value9.Get()

	if v204 and v204.FreeGiftsRedeemed then
		for _, freeGift in pairs(t1.value4.FreeGifts) do
			local v207

			if freeGift.WaitTime <= (v204.FreeGiftsTime or 0) then
				v207 = not table.find(v204.FreeGiftsRedeemed, freeGift.Id)
			else
				v207 = false
			end

			if v207 and t1.value8.Invoke(t1.value33(t1.value25.fg), freeGift.Id) then
				local value50 = t1.value50
				local s7 = "gifts"

				value50[s7] = value50[s7] + 1
			end
		end
	end
end

function t1.value73()
	local v210 = nil
	local v211 = t1.value9.Get()

	if v211 and v211.RedeemedRankRewards then
		local v212 = t1.value4.Ranks[t1.value16.RankIDFromNumber(v211.Rank)]

		if v212 and v212.Rewards then
			for i, reward in ipairs(v212.Rewards) do
				v210 = v210 + reward.StarsRequired

				local v215

				if v210 <= v211.RankStars then
					v215 = v211.RedeemedRankRewards[tostring(i)] == nil
				else
					v215 = false
				end

				if v215 then
					t1.value8.Fire(t1.value33(t1.value25.rr), i)

					local value50 = t1.value50
					local s8 = "ranks"

					value50[s8] = value50[s8] + 1
				end
			end

			return
		else
			return
		end
	end
end
function t1.value74()
	local v218 = t1.value19.GetNextRebirth()

	if type(v218) ~= "table" and true or not v218.RebirthNumber then
		return
	end

	local _, v220 = t1.value11.GetMaxOwnedZone()

	if not ((v220 and ((v220.ZoneNumber or 0) >= v218.ZoneNumberRequired and true or math.huge) or v220) and t1.value19.Rebirth(v218.RebirthNumber)) then
		return
	end

	local value50 = t1.value50
	local s9 = "rebirths"

	value50[s9] = value50[s9] + 1
end
function t1.value75()
	if not t1.value21.IsAutoEquipEnabled() then
		t1.value21.ToggleAutoEquip()
	end

	local v223 = t1.value9.Get()

	if not v223 then
		return
	end

	local v224 = (v223.PetSlotsPurchased or 0) + 1

	if (t1.value20.GetMaxPurchasableEquipSlots() or 0) < v224 then
		return
	end

	local Diamonds = t1.value15.CalcPetSlotPrice(v224)

	if Diamonds then
		Diamonds = t1.value12.CanAfford("Diamonds", Diamonds)
	end

	if not (Diamonds and t1.value8.Invoke(t1.value33(t1.value25.ps), v224)) then
		return
	end

	local value50 = t1.value50
	local s10 = "slots"

	value50[s10] = value50[s10] + 1
end

t1.value76 = nil
t1.value76 = nil

function t1.value77(p25)
	local Lighting = game:GetService("Lighting")
	local v229

	if p25 then
		v229 = not t1.value76
	else
		v229 = p25
	end

	if v229 then
		local function v230()
			t1.value76.quality = settings().Rendering.QualityLevel
		end

		t1.value76 = {
			shadows = Lighting.GlobalShadows,
			effects = {}
		}
		pcall(v230)
		Lighting.GlobalShadows = false

		for _, child in ipairs(Lighting.GetChildren(Lighting)) do
			local isPostEffect = child:IsA("PostEffect")

			if isPostEffect then
				isPostEffect = child.Enabled
			end

			if isPostEffect then
				child.Enabled = false

				local effects = t1.value76.effects

				table.insert(effects, child)
			end
		end

		pcall(function()
			settings().Rendering.QualityLevel = Enum.QualityLevel.Level01
		end)

		return
	end

	local v235 = not p25

	if v235 then
		v235 = t1.value76
	end

	if not v235 then
		return
	end

	Lighting.GlobalShadows = t1.value76.shadows

	local v236, v237, v238 = ipairs(t1.value76.effects)

	while true do
		local v239

		v238, v239 = v236(v237, v238)

		if not v238 then
			break
		end

		if v239.Parent then
			v239.Enabled = true
		end
	end

	if t1.value76.quality then
		local function v240()
			settings().Rendering.QualityLevel = t1.value76.quality
		end

		pcall(v240)
	end

	t1.value76 = nil
end

connection = game:GetService("VirtualInputManager")
t1.value78 = nil
t1.value78 = connection

function t1.value79()
	t1.value78:SendKeyEvent(true, Enum.KeyCode.F15, false, game)
	t1.value78:SendKeyEvent(false, Enum.KeyCode.F15, false, game)
end

connection = t1.value3.Idled:Connect(t1.value37(function()
	if not t1.value39.afk then
		return
	end

	task.spawn(pcall, t1.value79)
end))
t1.value35[#t1.value35 + 1] = connection
task.spawn(function()
	local t14 = {}

	local function v242(p26, p27)
		if t1.value36() then
			if p27 <= os.clock() - (t14[p26] or 0) then
				t14[p26] = os.clock()

				return true
			else
				return false
			end
		else
			return false
		end
	end

	local t15 = {}

	while t1.value34 do
		local pcall_ = pcall
		local value67 = t1.value67
		local hatch = t1.value39.hatch

		if hatch then
			hatch = t1.value36()
		end

		pcall_(value67, hatch)

		local hatch2 = t1.value39.hatch

		if hatch2 then
			local v248 = (t1.value18.ComputeDebounce() or 2.5) + 0.1

			hatch2 = v242("hatch", (math.max(2.6, v248)))
		end

		if hatch2 then
			pcall(t1.value68)
		end

		local areas = t1.value39.areas

		if areas then
			areas = v242("areas", 3)
		end

		if areas then
			pcall(t1.value69)
		end

		local bestzone = t1.value39.bestzone

		if bestzone then
			bestzone = v242("bestzone", 2)
		end

		if bestzone then
			pcall(t1.value60)
		end

		local upgrades = t1.value39.upgrades

		if upgrades then
			upgrades = v242("upgrades", 5)
		end

		if upgrades then
			pcall(t1.value70)
		end

		local slots = t1.value39.slots

		if slots then
			slots = v242("slots", 6)
		end

		if slots then
			pcall(t1.value75)
		end

		local rebirth = t1.value39.rebirth

		if rebirth then
			rebirth = v242("rebirth", 8)
		end

		if rebirth then
			pcall(t1.value74)
		end

		local pcall_2 = pcall
		local value77 = t1.value77
		local lowlag = t1.value39.lowlag

		if lowlag then
			lowlag = t1.value36()
		end

		pcall_2(value77, lowlag)

		local gifts = t1.value39.gifts

		if gifts then
			gifts = v242("gifts", 20)
		end

		if gifts then
			pcall(v203)
		end

		local ranks = t1.value39.ranks

		if ranks then
			ranks = v242("ranks", 20)
		end

		if ranks then
			pcall(t1.value73)
		end

		local afk = t1.value39.afk

		if afk then
			afk = v242("afk", 60)
		end

		if afk then
			pcall(t1.value79)
		end

		if v242("coins", 2) then
			local function v260()
				local Coins = t1.value12.Get("Coins")

				t1.value50.coins = Coins
				table.insert(t15, { os.clock(), Coins })

				while #t15 > 30 do
					table.remove(t15, 1)
				end

				local v262 = t15[1]
				local v263 = os.clock() - v262[1]

				if not (v263 > 0) then
					return
				end

				local value50 = t1.value50
				local v265 = (Coins - v262[2]) / v263 * 60

				value50.rate = math.max(0, v265)
			end

			pcall(v260)
		end

		task.wait(0.5)
	end
end)
game:GetService("TextService")
connection = game:GetService("RunService")
t1.value80 = TweenInfo.new(0.14, Enum.EasingStyle.Quint, Enum.EasingDirection.Out)

function t1.value81(p28, p29, p30, p31)
	local UIStroke = Instance.new("UIStroke")

	UIStroke.Color = p29
	UIStroke.Thickness = p30 or 1
	UIStroke.Transparency = p31 or 0
	UIStroke.ApplyStrokeMode = Enum.ApplyStrokeMode.Border
	UIStroke.Parent = p28

	return UIStroke
end
function t1.value82(p32, p33, p34, p35)
	local UIGradient = Instance.new("UIGradient")

	UIGradient.Color = ColorSequence.new({ ColorSequenceKeypoint.new(0, p33), ColorSequenceKeypoint.new(1, p34) })
	UIGradient.Rotation = p35 or 0
	UIGradient.Parent = p32

	return UIGradient
end
function t1.value83(p36, p37, p38, p39, p40)
	local TextLabel = Instance.new("TextLabel")

	TextLabel.BackgroundTransparency = 1
	TextLabel.Text = p37
	TextLabel.TextSize = p38
	TextLabel.TextColor3 = p39 or t1.value23.TEXT
	TextLabel.Font = p40 or Enum.Font.GothamBold
	TextLabel.Parent = p36

	return TextLabel
end
function t1.value84(p41, p42, p43)
	t1.value1:Create(p41, p43 or t1.value80, p42):Play()
end
function t1.value85(p44)
	local v269 = tonumber(p44) or 0

	for _, v in ipairs({
		{ 1e21, "Sx" },
		{ 1e18, "Qi" },
		{ 1000000000000000, "Qa" },
		{ 1000000000000, "T" },
		{ 1000000000, "B" },
		{ 1000000, "M" },
		{ 1000, "K" }
	}) do
		if v[1] <= v269 then
			return string.format("%.1f%s", v269 / v[1], v[2])
		end
	end

	local v272 = math.floor(v269)

	return tostring(v272)
end
function t1.value86(p45)
	local UIScale = Instance.new("UIScale")

	UIScale.Parent = p45

	local function v274()
		t1.value84(UIScale, {
			Scale = 0.94
		})
	end

	local connection2 = p45.MouseButton1Down:Connect(t1.value37(v274))

	t1.value35[#t1.value35 + 1] = connection2

	local function v276()
		t1.value84(UIScale, {
			Scale = 1
		}, TweenInfo.new(0.25, Enum.EasingStyle.Back, Enum.EasingDirection.Out))
	end

	local connection3 = p45.MouseButton1Up:Connect(t1.value37(v276))

	t1.value35[#t1.value35 + 1] = connection3

	local connection4 = p45.MouseLeave:Connect(t1.value37(v276))

	t1.value35[#t1.value35 + 1] = connection4

	return UIScale
end

t1.value87 = Instance.new("ScreenGui")
t1.value87.Name = "iCollectPro_PS99Spawner"
t1.value87.ResetOnSpawn = false
t1.value87.IgnoreGuiInset = true
t1.value87.DisplayOrder = 999
t1.value87.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
pcall(function()
	local value87 = t1.value87
	local gethui_2 = gethui

	if not gethui_2 then
		value87.Parent = gethui_2 or game:GetService("CoreGui")

		return
	end

	gethui_2 = gethui()
	value87.Parent = gethui_2 or game:GetService("CoreGui")
end)

if not t1.value87.Parent then
	t1.value87.Parent = t1.value3:WaitForChild("PlayerGui")
end

t1.value88 = Instance.new("Frame")
t1.value88.Name = "SpawnerFrame"
t1.value88.AutomaticSize = Enum.AutomaticSize.Y
t1.value88.Size = UDim2.new(0, 440, 0, 0)
t1.value88.Position = UDim2.new(0, 20, 0.16, 0)
t1.value88.BackgroundColor3 = t1.value23.BG
t1.value88.BorderSizePixel = 0
t1.value88.Active = true
t1.value88.ZIndex = 100
t1.value88.Parent = t1.value87

local value88 = t1.value88

Players = Instance.new("UICorner")
Players.CornerRadius = UDim.new(0, 18)
Players.Parent = value88
t1.value81(t1.value88, t1.value23.STROKE, 1.2, 0.4)
value88 = Instance.new("UIPadding")
value88.PaddingBottom = UDim.new(0, 12)
value88.Parent = t1.value88
value88 = Instance.new("ImageLabel")
value88.AnchorPoint = Vector2.new(0.5, 0.5)
value88.Position = UDim2.new(0.5, 0, 0.5, 2)
value88.Size = UDim2.new(1, 24, 1, 24)
value88.BackgroundTransparency = 1
value88.Image = "rbxassetid://6014261993"
value88.ImageColor3 = Color3.new(0, 0, 0)
value88.ImageTransparency = 0.72
value88.ScaleType = Enum.ScaleType.Slice
value88.SliceCenter = Rect.new(49, 49, 450, 450)
value88.ZIndex = 99
value88.Parent = t1.value88
t1.value89 = Instance.new("Frame")
t1.value89.Size = UDim2.new(1, 0, 0, 38)
t1.value89.BackgroundTransparency = 1
t1.value89.ZIndex = 101
t1.value89.Parent = t1.value88
value88 = t1.value83(t1.value89, "PET SIM 99", 18, t1.value23.TEXT, Enum.Font.GothamBlack)
value88.Size = UDim2.new(1, -28, 0, 22)
value88.Position = UDim2.fromOffset(14, 8)
value88.TextXAlignment = Enum.TextXAlignment.Center
value88.ZIndex = 102
value88 = function(p46, p47)
	local TextButton = Instance.new("TextButton")

	TextButton.Size = UDim2.fromOffset(22, 22)
	TextButton.Position = UDim2.new(1, p47, 0, 8)
	TextButton.BackgroundTransparency = 1
	TextButton.Text = p46
	TextButton.TextColor3 = t1.value23.OFF_TEXT
	TextButton.TextSize = 13
	TextButton.Font = Enum.Font.GothamBold
	TextButton.AutoButtonColor = false
	TextButton.ZIndex = 103
	TextButton.Parent = t1.value89

	return TextButton
end
t1.value90 = value88("X", -32)
Players = t1.value90.MouseEnter:Connect(t1.value37(function()
	t1.value84(t1.value90, {
		TextColor3 = t1.value23.RED
	})
end))
t1.value35[#t1.value35 + 1] = Players
Players = t1.value90.MouseLeave:Connect(t1.value37(function()
	t1.value84(t1.value90, {
		TextColor3 = t1.value23.OFF_TEXT
	})
end))
t1.value35[#t1.value35 + 1] = Players
t1.value91 = value88("-", -56)
t1.value91.TextSize = 18
value88 = t1.value91.MouseEnter:Connect(t1.value37(function()
	t1.value84(t1.value91, {
		TextColor3 = t1.value23.TEXT
	})
end))
t1.value35[#t1.value35 + 1] = value88
value88 = t1.value91.MouseLeave:Connect(t1.value37(function()
	t1.value84(t1.value91, {
		TextColor3 = t1.value23.OFF_TEXT
	})
end))
t1.value35[#t1.value35 + 1] = value88
value88 = Instance.new("Frame")
value88.AnchorPoint = Vector2.new(0.5, 0)
value88.Position = UDim2.new(0.5, 0, 0, 34)
value88.Size = UDim2.new(0, 124, 0, 1)
value88.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
value88.BackgroundTransparency = 0.15
value88.BorderSizePixel = 0
value88.ZIndex = 101
value88.Parent = t1.value88
t1.value92 = Instance.new("Frame")
t1.value92.AutomaticSize = Enum.AutomaticSize.Y
t1.value92.Size = UDim2.new(1, -24, 0, 0)
t1.value92.Position = UDim2.fromOffset(12, 44)
t1.value92.BackgroundColor3 = t1.value23.SURF
t1.value92.BorderSizePixel = 0
t1.value92.ZIndex = 101
t1.value92.Parent = t1.value88
value88 = t1.value92
Players = Instance.new("UICorner")
Players.CornerRadius = UDim.new(0, 16)
Players.Parent = value88
t1.value81(t1.value92, t1.value23.STROKE, 1, 0.48)
value88 = Instance.new("Frame")
value88.AutomaticSize = Enum.AutomaticSize.Y
value88.Size = UDim2.new(1, -20, 0, 0)
value88.Position = UDim2.fromOffset(10, 10)
value88.BackgroundTransparency = 1
value88.ZIndex = 102
value88.Parent = t1.value92
Players = Instance.new("UIListLayout")
Players.Padding = UDim.new(0, 10)
Players.SortOrder = Enum.SortOrder.LayoutOrder
Players.Parent = value88
Players = Instance.new("UIPadding")
Players.PaddingBottom = UDim.new(0, 20)
Players.Parent = value88
t1.value93 = false
Players = t1.value91.MouseButton1Click:Connect(t1.value37(function()
	t1.value93 = not t1.value93
	t1.value92.Visible = not t1.value93
	t1.value91.Text = t1.value93 and "+" or "-"
end))
t1.value35[#t1.value35 + 1] = Players
t1.value94 = nil
t1.value95 = nil
t1.value96 = nil
Players = t1.value89.InputBegan:Connect(t1.value37(function(p48)
	if not (p48.UserInputType == Enum.UserInputType.MouseButton1 and true or p48.UserInputType == Enum.UserInputType.Touch) then
		return
	end

	local Position = p48.Position
	local Position2 = t1.value88.Position

	t1.value94 = true
	t1.value95 = Position
	t1.value96 = Position2
end))
t1.value35[#t1.value35 + 1] = Players
Players = game_.InputChanged:Connect(t1.value37(function(p49)
	local value94 = t1.value94

	if value94 then
		value94 = p49.UserInputType == Enum.UserInputType.MouseMovement and true or p49.UserInputType == Enum.UserInputType.Touch
	end

	if not value94 then
		return
	end

	local v286 = p49.Position - t1.value95

	t1.value88.Position = UDim2.new(t1.value96.X.Scale, t1.value96.X.Offset + v286.X, t1.value96.Y.Scale, t1.value96.Y.Offset + v286.Y)
end))
t1.value35[#t1.value35 + 1] = Players
Players = game_.InputEnded:Connect(t1.value37(function(p50)
	local _ = p50.UserInputType == Enum.UserInputType.MouseButton1 and true or p50.UserInputType == Enum.UserInputType.Touch
end))
t1.value35[#t1.value35 + 1] = Players
Players = function(p51, p52, p53, p54, p55)
	local Frame = Instance.new("Frame")

	Frame.Size = p53 or UDim2.new(1, 0, 0, 0)

	if not p53 then
		Frame.AutomaticSize = Enum.AutomaticSize.Y
	end

	Frame.BackgroundTransparency = 1
	Frame.LayoutOrder = p52
	Frame.ZIndex = 102
	Frame.Parent = p51

	local UIListLayout = Instance.new("UIListLayout")

	UIListLayout.Padding = UDim.new(0, p55 or 8)
	UIListLayout.SortOrder = Enum.SortOrder.LayoutOrder

	if not p54 then
		UIListLayout.Parent = Frame

		return Frame
	end

	UIListLayout.FillDirection = Enum.FillDirection.Horizontal
	UIListLayout.Parent = Frame

	return Frame
end

function t1.value97(p56, p57, p58, p59)
	local TextButton = Instance.new("TextButton")

	TextButton.AutoButtonColor = false
	TextButton.BackgroundColor3 = t1.value23.OFF_BG
	TextButton.BorderSizePixel = 0
	TextButton.Text = ""
	TextButton.LayoutOrder = p58 or 0
	TextButton.ZIndex = 104
	TextButton.Parent = p56

	local UICorner = Instance.new("UICorner")

	UICorner.CornerRadius = UDim.new(0, 9)
	UICorner.Parent = TextButton

	local v292 = t1.value81(TextButton, t1.value23.STROKE, 1, 0.55)
	local Frame = Instance.new("Frame")

	Frame.Size = UDim2.fromScale(1, 1)
	Frame.BackgroundTransparency = 1
	Frame.BorderSizePixel = 0
	Frame.ZIndex = 104
	Frame.Parent = TextButton

	local UICorner2 = Instance.new("UICorner")

	UICorner2.CornerRadius = UDim.new(0, 9)
	UICorner2.Parent = Frame
	t1.value82(Frame, t1.value23.GREEN1, t1.value23.GREEN2, 0)

	local v295 = t1.value83(TextButton, p57, p59 or 11, t1.value23.OFF_TEXT)

	v295.Size = UDim2.new(1, -12, 1, 0)
	v295.Position = UDim2.fromOffset(6, 0)
	v295.TextTruncate = Enum.TextTruncate.AtEnd
	v295.ZIndex = 105
	t1.value86(TextButton)

	local t16 = {
		button = TextButton,
		knob = Frame,
		stateLabel = v295,
		stroke = v292,
		on = false,
		set = function(p60)
			v_u_349.on = p60

			local value84 = t1.value84
			local v298 = TextButton
			local GREEN1

			if p60 then
				GREEN1 = t1.value23.GREEN1
			else
				GREEN1 = p60
			end

			value84(v298, {
				BackgroundColor3 = GREEN1 or t1.value23.OFF_BG
			})
			t1.value84(Frame, {
				BackgroundTransparency = p60 and 0 or 1
			})

			local value842 = t1.value84
			local v301 = v295
			local ON_TEXT

			if p60 then
				ON_TEXT = t1.value23.ON_TEXT
			else
				ON_TEXT = p60
			end

			value842(v301, {
				TextColor3 = ON_TEXT or t1.value23.OFF_TEXT
			})

			local value843 = t1.value84
			local v304 = v292
			local GREEN_STROKE

			if p60 then
				GREEN_STROKE = t1.value23.GREEN_STROKE
			else
				GREEN_STROKE = p60
			end

			value843(v304, {
				Color = GREEN_STROKE or t1.value23.STROKE,
				Transparency = p60 and 0.22 or 0.55
			})
		end
	}

	local function v306()
		if t16.on then
			return
		end

		t1.value84(TextButton, {
			BackgroundColor3 = t1.value23.HOVER
		})
	end

	local connection2 = TextButton.MouseEnter:Connect(t1.value37(v306))

	t1.value35[#t1.value35 + 1] = connection2

	local function v308()
		if t16.on then
			return
		end

		t1.value84(TextButton, {
			BackgroundColor3 = t1.value23.OFF_BG
		})
	end

	local connection3 = TextButton.MouseLeave:Connect(t1.value37(v308))

	t1.value35[#t1.value35 + 1] = connection3

	return t16
end

t1.value98 = {}
t1.value99 = nil

function t1.value99(p61)
	local Holder = t1.value22[p61]

	if Holder then
		Holder = Holder._script and Holder._script:FindFirstChild("Holder") or Holder._script
	end

	if not Holder then
		return nil
	end

	local Golden

	if t1.value40.variant == 1 then
		Golden = Holder:FindFirstChild("Golden")
	else
		Golden = false
	end

	local Pet = Golden or Holder:FindFirstChild("Pet")

	if not (Pet and Pet:IsA("BasePart")) then
		return nil
	end

	local ok, result = pcall(function()
		return Pet:Clone()
	end)

	if ok and result then
		local GetDescendants = result.GetDescendants
		local ipairs_2 = ipairs

		for _, v in ipairs_2(GetDescendants(result)) do
			if not (v:IsA("DataModelMesh") or (v:IsA("Decal") or v:IsA("SurfaceAppearance"))) then
				ipairs_2 = v:Destroy()
			end
		end

		return result
	else
		return nil
	end
end
function t1.value100(p62, p63, p64, p65)
	local ViewportFrame = Instance.new("ViewportFrame")

	ViewportFrame.BackgroundTransparency = 1
	ViewportFrame.Size = UDim2.fromOffset(p64, p64)
	ViewportFrame.Ambient = Color3.fromRGB(235, 230, 245)
	ViewportFrame.LightColor = Color3.new(1, 1, 1)
	ViewportFrame.LightDirection = Vector3.new(-0.4, -1, -0.7)
	ViewportFrame.ImageTransparency = 1
	ViewportFrame.ZIndex = 105
	ViewportFrame.Parent = p62

	local t17 = {
		vp = ViewportFrame,
		phase = p65 or 0,
		angle = p65 or 0,
		speed = 1
	}
	local v321 = t1.value99(p63)

	if v321 then
		v321.Anchored = true
		v321.CFrame = CFrame.new()
		v321.Parent = ViewportFrame

		local Camera = Instance.new("Camera")

		Camera.FieldOfView = 30

		local X = v321.Size.X
		local Y = v321.Size.Y
		local Z = v321.Size.Z
		local size = math.max(X, Y, Z)

		Camera.CFrame = CFrame.lookAt(Vector3.new(0, size * 0.5, size * 4), Vector3.zero)
		Camera.Parent = ViewportFrame
		ViewportFrame.CurrentCamera = Camera
		t17.model = v321
		t17.size = size
		t17.mesh = v321:FindFirstChildWhichIsA("SpecialMesh")
		t1.value98[ViewportFrame] = t17

		local function v327()
			t1.value98[ViewportFrame] = nil
		end

		local connection2 = ViewportFrame.Destroying:Connect(t1.value37(v327))

		t1.value35[#t1.value35 + 1] = connection2
	else
		local ImageLabel = Instance.new("ImageLabel")

		ImageLabel.BackgroundTransparency = 1
		ImageLabel.Size = UDim2.fromScale(1, 1)

		local s11 = "Image"
		local thumbnail = t1.value22[p63]

		if thumbnail then
			thumbnail = t1.value22[p63].thumbnail
		end

		ImageLabel[s11] = thumbnail or ""
		ImageLabel.ScaleType = Enum.ScaleType.Fit
		ImageLabel.ZIndex = 105
		ImageLabel.Parent = ViewportFrame
	end

	t1.value84(ViewportFrame, {
		ImageTransparency = 0
	}, TweenInfo.new(0.25))

	return t17
end

game_ = Players(value88, 0, UDim2.new(1, 0, 0, 30), true, 8)
t1.value101 = Players(value88, 1, nil, false, 10)
t1.value102 = Players(value88, 2, nil, false, 10)
t1.value103 = {}

function t1.value104(p66)
	t1.value101.Visible = p66 == "SPAWNER"
	t1.value102.Visible = p66 == "FARM"

	for k, v in pairs(t1.value103) do
		v.set(k == p66)
	end
end

createFrame = function(p67, p68, p69)
	local Frame = Instance.new("Frame")

	Frame.Size = p69
	Frame.BackgroundColor3 = t1.value23.SURF2
	Frame.BackgroundTransparency = 0.02
	Frame.BorderSizePixel = 0
	Frame.LayoutOrder = p68 or 0
	Frame.ZIndex = 103
	Frame.Parent = p67

	local UICorner = Instance.new("UICorner")

	UICorner.CornerRadius = UDim.new(0, 12)
	UICorner.Parent = Frame
	t1.value81(Frame, t1.value23.STROKE, 1, 0.52)

	return Frame
end

local function createTextBox(p70, p71, p72)
	local TextBox = Instance.new("TextBox")

	TextBox.BackgroundColor3 = t1.value23.OFF_BG
	TextBox.BorderSizePixel = 0
	TextBox.ClearTextOnFocus = false
	TextBox.PlaceholderText = p71
	TextBox.PlaceholderColor3 = t1.value23.OFF_TEXT
	TextBox.Text = ""
	TextBox.TextColor3 = t1.value23.TEXT
	TextBox.TextSize = 12
	TextBox.Font = Enum.Font.GothamBold
	TextBox.LayoutOrder = p72 or 0
	TextBox.ZIndex = 104
	TextBox.Parent = p70

	local UICorner = Instance.new("UICorner")

	UICorner.CornerRadius = UDim.new(0, 9)
	UICorner.Parent = TextBox

	local v339 = t1.value81(TextBox, t1.value23.STROKE, 1, 0.55)

	local function v340()
		t1.value84(v339, {
			Transparency = 0.1
		})
	end

	local connection2 = TextBox.Focused:Connect(t1.value37(v340))

	t1.value35[#t1.value35 + 1] = connection2

	local function v342()
		t1.value84(v339, {
			Transparency = 0.55
		})
	end

	local connection3 = TextBox.FocusLost:Connect(t1.value37(v342))

	t1.value35[#t1.value35 + 1] = connection3

	return TextBox
end
local function createTextButton(p73, p74, p75, p76)
	local TextButton = Instance.new("TextButton")

	TextButton.BackgroundColor3 = p76 and t1.value23.GREEN1 or t1.value23.OFF_BG
	TextButton.BorderSizePixel = 0
	TextButton.AutoButtonColor = false
	TextButton.Text = p74
	TextButton.TextColor3 = p76 and t1.value23.ON_TEXT or t1.value23.OFF_TEXT
	TextButton.TextSize = 13
	TextButton.Font = Enum.Font.GothamBlack
	TextButton.LayoutOrder = p75
	TextButton.ZIndex = 104
	TextButton.Parent = p73

	local UICorner = Instance.new("UICorner")

	UICorner.CornerRadius = UDim.new(0, 10)
	UICorner.Parent = TextButton

	local value81 = t1.value81
	local GREEN_STROKE

	if p76 then
		GREEN_STROKE = t1.value23.GREEN_STROKE
	else
		GREEN_STROKE = p76
	end

	local v349 = value81(TextButton, GREEN_STROKE or t1.value23.STROKE, 1, p76 and 0.22 or 0.52)

	if p76 then
		t1.value82(TextButton, Color3.new(1, 1, 1), Color3.fromRGB(200, 230, 210), 90)
	end

	t1.value86(TextButton)

	local function v350()
		t1.value84(v349, {
			Transparency = 0.05
		})
	end

	local connection2 = TextButton.MouseEnter:Connect(t1.value37(v350))

	t1.value35[#t1.value35 + 1] = connection2

	local function v352()
		t1.value84(v349, {
			Transparency = p76 and 0.22 or 0.52
		})
	end

	local connection3 = TextButton.MouseLeave:Connect(t1.value37(v352))

	t1.value35[#t1.value35 + 1] = connection3

	return TextButton
end

for i, v in ipairs({ "SPAWNER", "FARM" }) do
	i = t1.value97(game_, v, i, 13)
	i.button.Size = UDim2.new(0.5, -4, 1, 0)
	t1.value103[v] = i
	i = i.button.MouseButton1Click:Connect(t1.value37(function()
		t1.value104(v)
	end))
	t1.value35[#t1.value35 + 1] = i
end

local v356 = Players(t1.value101, 1, UDim2.new(1, 0, 0, 276), true, 10)

game_ = createFrame(v356, 1, UDim2.new(0, 128, 1, 0))
gethui_ = Instance.new("ScrollingFrame")
gethui_.Size = UDim2.fromScale(1, 1)
gethui_.BackgroundTransparency = 1
gethui_.BorderSizePixel = 0
gethui_.ScrollBarThickness = 2
gethui_.ScrollBarImageColor3 = t1.value23.ACCENT
gethui_.CanvasSize = UDim2.new()
gethui_.AutomaticCanvasSize = Enum.AutomaticSize.Y
gethui_.ZIndex = 104
gethui_.Parent = game_
game_ = Instance.new("UIListLayout")
game_.Padding = UDim.new(0, 4)
game_.SortOrder = Enum.SortOrder.LayoutOrder
game_.Parent = gethui_
game_ = Instance.new("UIPadding")
game_.PaddingTop = UDim.new(0, 6)
game_.PaddingBottom = UDim.new(0, 6)
game_.PaddingLeft = UDim.new(0, 6)
game_.PaddingRight = UDim.new(0, 6)
game_.Parent = gethui_
v356 = Players(v356, 2, UDim2.new(1, -138, 1, 0), false, 8)
t1.value105 = createTextBox(v356, "search in this rarity...", 1)
t1.value105.Size = UDim2.new(1, 0, 0, 28)
t1.value105.TextXAlignment = Enum.TextXAlignment.Left
game_ = Instance.new("UIPadding")
game_.PaddingLeft = UDim.new(0, 10)
game_.Parent = t1.value105
game_ = createFrame(v356, 2, UDim2.new(1, 0, 1, -64))
t1.value106 = Instance.new("ScrollingFrame")
t1.value106.Size = UDim2.fromScale(1, 1)
t1.value106.BackgroundTransparency = 1
t1.value106.BorderSizePixel = 0
t1.value106.ScrollBarThickness = 3
t1.value106.ScrollBarImageColor3 = t1.value23.ACCENT
t1.value106.CanvasSize = UDim2.new()
t1.value106.AutomaticCanvasSize = Enum.AutomaticSize.Y
t1.value106.ZIndex = 104
t1.value106.Parent = game_
game_ = Instance.new("UIGridLayout")
game_.CellSize = UDim2.fromOffset(56, 74)
game_.CellPadding = UDim2.fromOffset(5, 6)
game_.SortOrder = Enum.SortOrder.LayoutOrder
game_.HorizontalAlignment = Enum.HorizontalAlignment.Center
game_.Parent = t1.value106
game_ = Instance.new("UIPadding")
game_.PaddingTop = UDim.new(0, 8)
game_.PaddingBottom = UDim.new(0, 8)
game_.Parent = t1.value106
v356 = Players(v356, 3, UDim2.new(1, 0, 0, 20), true, 6)
game_ = t1.value97(v356, "<", 1, 12)
game_.button.Size = UDim2.fromOffset(36, 20)
t1.value107 = t1.value83(v356, "", 10, t1.value23.DIM)
t1.value107.Size = UDim2.new(1, -84, 1, 0)
t1.value107.LayoutOrder = 2
t1.value107.ZIndex = 104
v356 = t1.value97(v356, ">", 3, 12)
v356.button.Size = UDim2.fromOffset(36, 20)
ipairs_ = createFrame(t1.value101, 2, UDim2.new(1, 0, 0, 96))
t1.value108 = Instance.new("Frame")
t1.value108.Size = UDim2.fromOffset(80, 80)
t1.value108.Position = UDim2.fromOffset(8, 8)
t1.value108.BackgroundColor3 = t1.value23.SURF
t1.value108.BorderSizePixel = 0
t1.value108.ZIndex = 104
t1.value108.Parent = ipairs_

local value108 = t1.value108
local UICorner = Instance.new("UICorner")

UICorner.CornerRadius = UDim.new(0, 10)
UICorner.Parent = value108
t1.value109 = t1.value81(t1.value108, t1.value23.STROKE, 1, 0.55)
UICorner = Players(ipairs_, 0, UDim2.new(1, -104, 1, -16), false, 6)
UICorner.Position = UDim2.fromOffset(96, 8)
t1.value110 = t1.value83(UICorner, "PICK A PET", 13, t1.value23.YELLOW, Enum.Font.GothamBlack)
t1.value110.Size = UDim2.new(1, 0, 0, 16)
t1.value110.TextXAlignment = Enum.TextXAlignment.Left
t1.value110.TextTruncate = Enum.TextTruncate.AtEnd
t1.value110.LayoutOrder = 1
t1.value110.ZIndex = 105
value108 = Players(UICorner, 2, UDim2.new(1, 0, 0, 24), true, 5)
t1.value111 = {}

for i = 0, 2 do
	v419 = t5[i]
	v419 = t1.value97(value108, v419, i + 1, 10)
	v419.button.Size = UDim2.new(0.25, -4, 1, 0)
	t1.value111[i] = v419
end

t1.value112 = t1.value97(value108, "SHINY", 4, 10)
t1.value112.button.Size = UDim2.new(0.25, -4, 1, 0)

local clearAll = Players(UICorner, 3, UDim2.new(1, 0, 0, 30), true, 5)

t1.value113 = createTextBox(clearAll, "1", 1)
t1.value113.Text = "1"
t1.value113.Size = UDim2.new(0, 44, 1, 0)

local spawn = createTextButton(clearAll, "SPAWN", 2, true)

spawn.Size = UDim2.new(1, -128, 1, 0)
clearAll = createTextButton(clearAll, "CLEAR ALL", 3, false)
clearAll.TextSize = 11
clearAll.Size = UDim2.new(0, 74, 1, 0)
t1.value114 = t1.value83(t1.value101, "PICK A RARITY ON THE LEFT, THEN A PET", 10, t1.value23.DIM)
t1.value114.Size = UDim2.new(1, 0, 0, 12)
t1.value114.LayoutOrder = 3
t1.value114.ZIndex = 104

function t1.value115(p77, p78)
	t1.value114.Text = p77
	t1.value84(t1.value114, {
		TextColor3 = p78 or t1.value23.DIM
	})
end

t1.value116 = 16
t1.value117 = {
	category = game_2[1],
	page = 1,
	filtered = {}
}
t1.value118 = {}
t1.value119 = {}
t1.value120 = nil

function t1.value121(p79, p80)
	local value84 = t1.value84
	local stroke = p79.stroke
	local GREEN_STROKE

	if p80 then
		GREEN_STROKE = t1.value23.GREEN_STROKE
	else
		GREEN_STROKE = p80
	end

	value84(stroke, {
		Color = GREEN_STROKE or t1.value23.STROKE,
		Transparency = p80 and 0.05 or 0.6
	})

	local value842 = t1.value84
	local frame = p79.frame

	if not p80 then
		value842(frame, {
			BackgroundColor3 = p80 or t1.value23.SURF
		})

		return
	end

	p80 = t1.value23.GREEN1
	value842(frame, {
		BackgroundColor3 = p80 or t1.value23.SURF
	})
end
function t1.value122()
	if t1.value120 then
		t1.value120.vp:Destroy()
		t1.value120 = nil
	else
	end

	if t1.value40.pet then
		t1.value120 = t1.value100(t1.value108, t1.value40.pet, 80, 0)
		t1.value120.speed = 0.8
		t1.value110.Text = t1.value40.pet:upper()
		t1.value84(t1.value110, {
			TextColor3 = t1.value44[t1.value117.category] and t1.value23.GREEN or t1.value23.TEXT
		})
		t1.value84(t1.value109, {
			Color = t1.value23.GREEN_STROKE,
			Transparency = 0.2
		})
	end
end

t1.value123 = nil

function t1.value123()
	for _, v in pairs(t1.value119) do
		v.frame:Destroy()
	end

	table.clear(t1.value119)

	local v369 = #t1.value117.filtered / t1.value116
	local v370 = math.ceil(v369)
	local v371 = math.max(1, v370)
	local value117 = t1.value117
	local page = t1.value117.page

	value117.page = math.clamp(page, 1, v371)
	t1.value107.Text = string.format("%d / %d", t1.value117.page, v371)

	local v374 = (t1.value117.page - 1) * t1.value116 + 1
	local v375 = v374 + t1.value116 - 1
	local v376 = #t1.value117.filtered

	for i = v374, math.min(v375, v376) do
		local v378 = t1.value117.filtered[i]
		local TextButton = Instance.new("TextButton")

		TextButton.AutoButtonColor = false
		TextButton.BackgroundColor3 = t1.value23.SURF
		TextButton.BorderSizePixel = 0
		TextButton.Text = ""
		TextButton.LayoutOrder = i
		TextButton.ZIndex = 104
		TextButton.Parent = t1.value106

		local UICorner2 = Instance.new("UICorner")

		UICorner2.CornerRadius = UDim.new(0, 12)
		UICorner2.Parent = TextButton

		local v381 = t1.value81(TextButton, t1.value23.STROKE, 1, 0.6)
		local v382 = t1.value100(TextButton, v378, 50, i * 0.7)

		v382.vp.Position = UDim2.new(0.5, -25, 0, 2)

		local v383 = t1.value83(TextButton, v378:gsub("^Gargantuan ", ""):gsub("^Titanic ", ""):gsub("^Huge ", ""), 9, t1.value23.TEXT)

		v383.Size = UDim2.new(1, -6, 0, 20)
		v383.Position = UDim2.new(0, 3, 1, -21)
		v383.TextWrapped = true
		v383.TextTruncate = Enum.TextTruncate.AtEnd
		v383.ZIndex = 106

		local t18 = {
			frame = TextButton,
			stroke = v381,
			spin = v382
		}

		t1.value119[v378] = t18
		t1.value121(t18, t1.value40.pet == v378)

		local UIScale = Instance.new("UIScale")

		UIScale.Parent = TextButton

		local function v386()
			v382.speed = 3
			t1.value84(UIScale, {
				Scale = 1.06
			})

			if t1.value40.pet == v378 then
				t1.value115(v378:upper(), t1.value23.TEXT)

				return
			end

			t1.value84(TextButton, {
				BackgroundColor3 = t1.value23.HOVER
			})
			t1.value115(v378:upper(), t1.value23.TEXT)
		end

		TextButton.MouseEnter:Connect(t1.value37(v386))

		local function v387()
			v382.speed = 1
			t1.value84(UIScale, {
				Scale = 1
			})

			if t1.value40.pet == v378 then
				return
			end

			t1.value84(TextButton, {
				BackgroundColor3 = t1.value23.SURF
			})
		end

		TextButton.MouseLeave:Connect(unpack_({ t1.value37(v387) }))

		local MouseButton1Click = TextButton.MouseButton1Click
		local value37 = t1.value37

		local function v390()
			local pet = t1.value40.pet

			if pet then
				pet = t1.value119[t1.value40.pet]
			end

			t1.value40.pet = v378

			if not pet then
				t1.value121(t18, true)
				t1.value122()
				t1.value115("READY - HIT SPAWN", t1.value23.GREEN)

				return
			end

			t1.value121(pet, false)
			t1.value121(t18, true)
			t1.value122()
			t1.value115("READY - HIT SPAWN", t1.value23.GREEN)
		end

		MouseButton1Click.Connect(MouseButton1Click, unpack_({ value37(v390) }))
	end

	t1.value106.CanvasPosition = Vector2.zero
end
function t1.value124()
	local v392 = t1.value105.Text:lower()

	t1.value117.filtered = {}

	for _, pet in ipairs(t1.value44[t1.value117.category].pets) do
		if v392 == "" and true or pet:lower():find(v392, 1, true) then
			t1.value117.filtered[#t1.value117.filtered + 1] = pet
		end
	end

	t1.value117.page = 1
	t1.value123()
end
function t1.value125(p81)
	t1.value117.category = p81

	for k, v in pairs(t1.value118) do
		v.set(k == p81)
	end

	t1.value124()
end

for i, v in ipairs(game_2) do
	createTextButton = t1.value44[v]
	i = t1.value97(gethui_, v:upper(), i, 10)
	i.button.Size = UDim2.new(1, 0, 0, 26)
	i.stateLabel.TextXAlignment = Enum.TextXAlignment.Left
	i.stateLabel.Position = UDim2.fromOffset(14, 0)
	i.stateLabel.Size = UDim2.new(1, -46, 1, 0)
	createTextBox = t1.value83
	t5 = i.button
	Players = #createTextButton.pets
	createTextBox = createTextBox(t5, tostring(Players), 9, t1.value23.DIM)
	createTextBox.Size = UDim2.new(0, 30, 1, 0)
	createTextBox.Position = UDim2.new(1, -34, 0, 0)
	createTextBox.TextXAlignment = Enum.TextXAlignment.Right
	createTextBox.ZIndex = 105
	createTextBox = Instance.new("Frame")
	createTextBox.Size = UDim2.new(0, 3, 1, -10)
	createTextBox.Position = UDim2.fromOffset(6, 5)
	createTextBox.BackgroundColor3 = createTextButton.color
	createTextBox.BorderSizePixel = 0
	createTextBox.ZIndex = 106
	createTextBox.Parent = i.button
	createTextButton = Instance.new("UICorner")
	createTextButton.CornerRadius = UDim.new(0, 2)
	createTextButton.Parent = createTextBox
	t1.value118[v] = i
	i = i.button.MouseButton1Click:Connect(t1.value37(function()
		t1.value125(v)
	end))
	t1.value35[#t1.value35 + 1] = i
end

local signal = t1.value105:GetPropertyChangedSignal("Text")

UICorner = t1.value124
signal = signal:Connect(t1.value37(UICorner))
t1.value35[#t1.value35 + 1] = signal
signal = game_.button.MouseButton1Click:Connect(t1.value37(function()
	local value117 = t1.value117

	value117.page = value117.page - 1
	t1.value123()
end))
t1.value35[#t1.value35 + 1] = signal
v48(v356.button.MouseButton1Click, function()
	local value117 = t1.value117

	value117.page = value117.page + 1
	t1.value123()
end)

local function v402()
	for k, v in pairs(t1.value111) do
		v.set(k == t1.value40.variant)
	end
end

v402()

for k, v in pairs(t1.value111) do
	v = v.button.MouseButton1Click:Connect(t1.value37(function()
		t1.value40.variant = k
		v402()
		t1.value123()
		t1.value122()
	end))
	t1.value35[#t1.value35 + 1] = v
end

t1.value112.set(t1.value40.shiny)
signal = t1.value112.button.MouseButton1Click:Connect(t1.value37(function()
	t1.value40.shiny = not t1.value40.shiny
	t1.value112.set(t1.value40.shiny)
	t1.value123()
	t1.value122()
end))
t1.value35[#t1.value35 + 1] = signal
signal = t1.value113.FocusLost:Connect(t1.value37(function()
	local Text = t1.value113.Text
	local v408 = tonumber(Text) or 1
	local v409 = math.floor(v408)
	local amount = math.clamp(v409, 1, 100)

	t1.value40.amount = amount
	t1.value113.Text = tostring(amount)
end))
t1.value35[#t1.value35 + 1] = signal
spawn = spawn.MouseButton1Click:Connect(t1.value37(function()
	if not t1.value40.pet then
		t1.value115("PICK A PET FIRST", t1.value23.RED)

		return
	end

	local u411 = false
	local s12 = "FAILED"

	task.spawn(function()
		local ok, result, result2 = pcall(t1.value48, t1.value40.pet, t1.value40.variant, t1.value40.shiny, t1.value40.amount)

		if ok then
			u411 = result
			s12 = result2
		else
			s12 = tostring(result)
		end
	end)

	if u411 then
		t1.value115("SPAWNED " .. t1.value40.amount .. "x " .. t1.value40.pet:upper(), t1.value23.GREEN)

		if not t1.value120 then
			return
		end

		t1.value120.speed = 12
		task.delay(0.6, function()
			if not t1.value120 then
				return
			end

			t1.value120.speed = 0.8
		end)
	else
		t1.value115(s12, t1.value23.RED)
	end
end))
t1.value35[#t1.value35 + 1] = spawn
clearAll = clearAll.MouseButton1Click:Connect(t1.value37(function()
	task.spawn(pcall, t1.value49)
	t1.value115("CLEARED ALL SPAWNED PETS", t1.value23.YELLOW)
end))
t1.value35[#t1.value35 + 1] = clearAll
v48(connection.RenderStepped, function(p82)
	if not (t1.value93 or not t1.value101.Visible) then
		local now = os.clock()

		for _, v in pairs(t1.value98) do
			local s13 = "angle"
			local v420 = p82 * 0.35
			local speed = v.speed

			v[s13] = v[s13] + v420 * speed

			local v422 = now * 1.4 + v.phase
			local v423 = math.sin(v422) * v.size * 0.04

			v.model.CFrame = CFrame.new(0, v423, 0) * CFrame.Angles(0, v.angle, 0)

			if v.mesh then
				if t1.value40.variant == 2 then
					local color3 = Color3.fromHSV((now * 0.25 + v.phase * 0.1) % 1, 0.55, 1)

					v.mesh.VertexColor = Vector3.new(color3.R, color3.G, color3.B)
				elseif t1.value40.shiny then
					local v425 = now * 4 + v.phase
					local v426 = math.sin(v425) * 0.15 + 1

					v.mesh.VertexColor = Vector3.new(v426, v426, v426 * 1.1)
				end
			end
		end
	end
end)
t1.value126 = {
	{ "tap", "TAP AREA", "hits every coin pile" },
	{ "collect", "COIN MAGNET", "pulls every coin to you" },
	{ "areas", "BUY AREAS", "next area when affordable" },
	{ "bestzone", "MOVE AREA", "jumps to newest area" },
	{ "hatch", "AUTO HATCH", "best egg, instant open" },
	{ "upgrades", "UPGRADES", "buys area upgrades" },
	{ "slots", "PET SLOTS", "more pets + equip best" },
	{ "rebirth", "AUTO REBIRTH", "huge damage boosts" },
	{ "gifts", "FREE GIFTS", "claims timed gifts" },
	{ "ranks", "RANK REWARDS", "claims rank rewards" },
	{ "afk", "ANTI-AFK", "no idle kick" },
	{ "lowlag", "LOW LAG", "more FPS" }
}
clearAll = createFrame(t1.value102, 1, UDim2.new(1, 0, 0, 74))
t1.value127 = t1.value83(clearAll, "+0 COINS / MIN", 22, t1.value23.DIM, Enum.Font.GothamBlack)
t1.value127.Size = UDim2.new(1, 0, 0, 28)
t1.value127.Position = UDim2.fromOffset(0, 10)
t1.value127.ZIndex = 104
t1.value128 = t1.value83(clearAll, "", 11, t1.value23.TEXT)
t1.value128.Size = UDim2.new(1, 0, 0, 14)
t1.value128.Position = UDim2.fromOffset(0, 38)
t1.value128.ZIndex = 104
t1.value129 = t1.value83(clearAll, "", 10, t1.value23.DIM)
t1.value129.Size = UDim2.new(1, 0, 0, 12)
t1.value129.Position = UDim2.fromOffset(0, 55)
t1.value129.ZIndex = 104
t1.value130 = Instance.new("Frame")
t1.value130.AutomaticSize = Enum.AutomaticSize.Y
t1.value130.Size = UDim2.new(1, 0, 0, 0)
t1.value130.BackgroundTransparency = 1
t1.value130.LayoutOrder = 2
t1.value130.ZIndex = 103
t1.value130.Parent = t1.value102
clearAll = Instance.new("UIGridLayout")
clearAll.CellSize = UDim2.new(0.33333333333333, -6, 0, 44)
clearAll.CellPadding = UDim2.fromOffset(8, 8)
clearAll.SortOrder = Enum.SortOrder.LayoutOrder
clearAll.Parent = t1.value130
t1.value131 = nil
t1.value132 = {}

function t1.value133()
	local ipairs_2 = ipairs
	local v428 = true

	for _, v in ipairs_2(t1.value126) do
		if not t1.value39[v[1]] then
			v428 = false
			ipairs_2 = false
		end
	end

	t1.value131.set(v428)
	t1.value131.title.Text = v428 and "ALL ON" or "TURN ALL ON"
end

signal = function(p83, p84, p85)
	local v431 = t1.value97(t1.value130, "", p85, 12)

	v431.stateLabel.Visible = false

	local v432 = t1.value83(v431.button, p83, 12, t1.value23.OFF_TEXT, Enum.Font.GothamBlack)

	v432.Size = UDim2.new(1, -20, 0, 16)
	v432.Position = UDim2.fromOffset(10, 7)
	v432.TextXAlignment = Enum.TextXAlignment.Left
	v432.ZIndex = 105

	local v433 = t1.value83(v431.button, p84, 9, t1.value23.DIM)

	v433.Size = UDim2.new(1, -20, 0, 12)
	v433.Position = UDim2.fromOffset(10, 25)
	v433.TextXAlignment = Enum.TextXAlignment.Left
	v433.TextTruncate = Enum.TextTruncate.AtEnd
	v433.ZIndex = 105

	local set = v431.set

	function v431.set(p86)
		set(p86)

		local value84 = t1.value84
		local v436 = v432
		local ON_TEXT

		if p86 then
			ON_TEXT = t1.value23.ON_TEXT
		else
			ON_TEXT = p86
		end

		value84(v436, {
			TextColor3 = ON_TEXT or t1.value23.OFF_TEXT
		})
		t1.value84(v433, {
			TextColor3 = p86 and t1.value23.GREEN or t1.value23.DIM
		})
	end

	v431.title = v432

	return v431
end

for i, v in ipairs(t1.value126) do
	local v440 = v[1]
	local v441 = signal(v[2], v[3], i)

	v441.set(t1.value39[v440])
	t1.value132[v440] = v441
	i = v441.button.MouseButton1Click:Connect(t1.value37(function()
		local v442 = t1.value39[v440]

		t1.value39[v440] = not v442
		v441.set(t1.value39[v440])
		t1.value133()

		local function v443()
			if not writefile then
				return
			end

			local writefile_ = writefile
			local value2 = t1.value2
			local JSONEncode = value2.JSONEncode

			writefile_(t1.value38, JSONEncode(value2, t1.value39))
		end

		pcall(v443)
	end))
	t1.value35[#t1.value35 + 1] = i
end

t1.value131 = signal("TURN ALL ON", "every feature at once", #t1.value126 + 1)
clearAll = t1.value131.button.MouseButton1Click:Connect(t1.value37(function()
	local v447 = not t1.value131.on

	for _, v in ipairs(t1.value126) do
		local v450 = v[1]

		t1.value39[v450] = v447

		local v451 = v[1]

		t1.value132[v451].set(v447)
	end

	t1.value133()

	local function v452()
		if not writefile then
			return
		end

		local writefile_ = writefile
		local value2 = t1.value2
		local JSONEncode = value2.JSONEncode

		writefile_(t1.value38, JSONEncode(value2, t1.value39))
	end

	pcall(v452)
end))
t1.value35[#t1.value35 + 1] = clearAll
t1.value133()
t1.value134 = t1.value83(t1.value102, "", 10, t1.value23.YELLOW)
t1.value134.Size = UDim2.new(1, 0, 0, 12)
t1.value134.LayoutOrder = 3
t1.value134.ZIndex = 104
clearAll = t1.value83(value88, t1.value27(), 11, Color3.new(1, 1, 1), Enum.Font.GothamBlack)
clearAll.Size = UDim2.new(1, 0, 0, 16)
clearAll.LayoutOrder = 99
clearAll.ZIndex = 104
spawn = Instance.new("UIGradient")
spawn.Color = ColorSequence.new({
	ColorSequenceKeypoint.new(0, t1.value23.DIM),
	ColorSequenceKeypoint.new(0.35, t1.value23.ACCENT),
	ColorSequenceKeypoint.new(0.5, t1.value23.GREEN),
	ColorSequenceKeypoint.new(0.65, t1.value23.ACCENT),
	ColorSequenceKeypoint.new(1, t1.value23.DIM)
})
spawn.Offset = Vector2.new(-1, 0)
spawn.Parent = clearAll
signal = t1.value1
UICorner = TweenInfo.new(2.6, Enum.EasingStyle.Sine, Enum.EasingDirection.InOut, -1)
value108 = Vector2
signal.Create(signal, spawn, UICorner, {
	Offset = value108.new(1, 0)
}):Play()
spawn = Instance.new("UIScale")
spawn.Parent = clearAll
t1.value1:Create(spawn, TweenInfo.new(1.4, Enum.EasingStyle.Sine, Enum.EasingDirection.InOut, -1, true), {
	Scale = 1.06
}):Play()
spawn = t1.value83(value88, t1.value27(t1.value26), 10, t1.value23.ACCENT, Enum.Font.GothamBold)
spawn.Size = UDim2.new(1, 0, 0, 12)
spawn.LayoutOrder = 100
spawn.ZIndex = 104
signal = t1.value1
UICorner = TweenInfo.new(1.8, Enum.EasingStyle.Sine, Enum.EasingDirection.InOut, -1, true)
signal.Create(signal, spawn, UICorner, {
	TextColor3 = t1.value23.GREEN
}):Play()
t1.value29 = spawn
t1.value28 = clearAll
t1.value30 = t1.value31()
v52()
task.spawn(function()
	while t1.value34 do
		t1.value30 = t1.value31()
		t1.value127.Text = "+" .. t1.value85(t1.value50.rate) .. " COINS / MIN"

		local value84 = t1.value84
		local value127 = t1.value127
		local s14 = "TextColor3"
		local GREEN

		if t1.value50.rate > 0 then
			GREEN = t1.value23.GREEN
		else
			GREEN = false
		end

		value84(value127, {
			[s14] = GREEN or t1.value23.DIM
		})
		t1.value128.Text = "BALANCE  " .. t1.value85(t1.value50.coins)
		t1.value129.Text = string.format("TAPS %s  EGGS %s  AREAS %d  UPGRADES %d  SLOTS %d  REBIRTHS %d", t1.value85(t1.value50.taps), t1.value85(t1.value50.hatches), t1.value50.areas, t1.value50.upgrades, t1.value50.slots, t1.value50.rebirths)

		if t1.value39.hatch then
			t1.value134.Text = t1.value50.hatchNote
		elseif t1.value39.tap then
			t1.value134.Text = string.format("TAPPING %d PILES IN THIS AREA", t1.value50.targets or 0)
		else
			t1.value134.Text = ""
		end

		task.wait(1)
	end
end)
t1.value104("SPAWNER")
clearAll = game_2[1]
t1.value125(clearAll)
clearAll = function()
	getgenv().iCollectPro_PS99Spawner_Kill = nil

	local function v460()
		t1.value87:Destroy()
	end

	pcall(v460)

	for _, v in ipairs(t1.value35) do
		pcall(function()
			v:Disconnect()
		end)
	end

	table.clear(t1.value35)

	if not t1.value59 then
		pcall(t1.value58)
		pcall(t1.value67, false)
		pcall(t1.value77, false)
		task.spawn(pcall, t1.value49)

		return
	end

	pcall(function()
		t1.value59:Disconnect()
	end)
	pcall(t1.value58)
	pcall(t1.value67, false)
	pcall(t1.value77, false)
	task.spawn(pcall, t1.value49)
end
getgenv().iCollectPro_PS99Spawner_Kill = clearAll
clearAll = t1.value90.MouseButton1Click:Connect(t1.value37(clearAll))
t1.value35[#t1.value35 + 1] = clearAll
