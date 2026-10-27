-- This file was generated at discord.gg/syncrypt

local unpack_ = unpack or table.unpack
local t2 = {
	value1 = "https://www.youtube.com/@RansbloxScript",
	value2 = "https://ransblox.net"
}

if _G.PHONEEMPIRE_Unload then
	pcall(_G.PHONEEMPIRE_Unload)
end

pcall(function()
	setclipboard(t2.value1)
end)

local ok, value2 = pcall(function()
	return loadstring(game:HttpGet("https://raw.githubusercontent.com/YTRANSBLOX/RANSBLOX-SCRIPT/refs/heads/main/maingui.lua"))()
end)
local t1 = {
	value2 = value2
}

t2.value3 = t1.value2
t1.value2 = not (ok and t2.value3)

if t1.value2 then
	return
end

local t3 = {
	value1 = {}
}

function t1.value2(p1, p2)
	local connection = p1:Connect(p2)
	local value1 = t3.value1

	table.insert(value1, connection)

	return connection
end

t1.value3 = game:GetService("ReplicatedStorage"):WaitForChild("PhoneTycoon", 10)

if not t1.value3 then
	t2.value3:Notify({
		Title = "Phone Empire",
		Content = "Phone Tycoon not found. This script only works in Phone Tycoon.",
		Icon = "x",
		Duration = 5
	})

	return
end

t1.value4 = require(t1.value3:WaitForChild("Config"))

local t4 = {
	value1 = t1.value4
}

t1.value4 = require
t1.value4 = t1.value4(t1.value3:WaitForChild("Economy"))
t4.value2 = t1.value4
t1.value4 = t1.value3:WaitForChild("Remotes")
t1.value3 = t1.value4:WaitForChild("State")
t1.value5 = t1.value4.WaitForChild
t1.value5 = t1.value5(t1.value4, "Action")
t4.value3 = t1.value5
t4.value4 = 3
t4.value5 = 160
t4.value6 = 0
t4.value7 = 60
t4.value8 = 60
t4.value9 = 1.25
t4.value10 = t4.value1.START_YEAR or 2007

local Production = t4.value1.Production

if Production then
	Production = t4.value1.Production.MIN_ORDER
end

t1.value5 = Production or 100
t4.value11 = t1.value5
t4.value12 = true
t4.value13 = true
t4.value14 = false
t4.value15 = true
t4.value16 = "Running..."
t4.value17 = false

function t4.value18() end
function t4.value19() end

t4.value20 = {}
t4.value21 = {}
t4.value22 = false
t4.value23 = 0
t4.value24 = nil
t4.value25 = nil
t4.value26 = {}
t4.value27 = {}
t4.value28 = {}
t1.value4 = os.clock()
t4.value29 = {
	n = 0,
	profit = 0,
	t0 = t1.value4,
	cash0 = nil
}
t1.value3 = t1.value3.OnClientEvent

function t1.value4(p3)
	return p3 == nil and true or t4.value21[p3] == true
end

t1.value2(t1.value3, function(p4)
	if type(p4) == "table" then
		local pairs_ = pairs

		for k, v in pairs_(p4) do
			pairs_ = t4.value20
			pairs_[k] = v
		end

		local researched = p4.researched

		if type(researched) == "table" then
			pairs_ = p4.researched
			t4.value21 = pairs_
		end

		local dev = t4.value20.dev
		local v16 = type(dev) == "table"

		if v16 then
			local design = dev.design

			if type(design) == "table" then
				local daysTotal = dev.daysTotal

				v16 = tonumber(daysTotal)
			else
				v16 = false
			end
		end

		if not v16 then
			return
		end

		t4.value28[dev.design.device or "phone"] = dev.daysTotal
	end
end)
t4.value30 = nil

function t1.value6(p5)
	local n1 = 0

	for _ in pairs(p5 or {}) do
		n1 = n1 + 1
	end

	return n1
end
function t1.value7(p6)
	local v21 = math.floor(tonumber(p6) or 0)
	local v22 = v21 < 0

	if not v22 then
		v28 = tostring(v21):reverse():gsub("(%d%d%d)", "%1,"):reverse()

		return (v22 and "-$" or v22 or "$") .. v28.gsub(v28, "^,", "")
	end

	v21 = -v21

	local v23 = tostring(v21):reverse():gsub("(%d%d%d)", "%1,"):reverse()

	return (v22 and "-$" or v22 or "$") .. v23.gsub(v23, "^,", "")
end
function t1.value5(p7)
	local v24

	if type(p7) == "table" then
		local specs = p7.specs

		v24 = type(specs) == "table"
	else
		v24 = false
	end

	return v24
end
function t1.value3(p8)
	if type(p8) == "table" then
		local t5 = {}

		for k, v in pairs(p8) do
			t5[k] = t4.value30(v)
		end

		return t5
	else
		return p8
	end
end
function t1.value2(p9)
	return p9.device or "phone"
end

t4.value30 = t1.value3
t4.value31 = t1.value6
t4.value32 = t1.value7
t4.value33 = t1.value4

function t1.value3(p10)
	local t6 = {}

	for _, v in pairs(t4.value1.Options[p10] or {}) do
		if t4.value33(v.research) then
			t6[#t6 + 1] = v
		end
	end

	table.sort(t6, function(p11, p12)
		return p11.tier > p12.tier
	end)

	return t6
end

t4.value34 = t1.value3

local function v32()
	local t7 = {}

	for _, chassi in pairs(t4.value1.Chassis) do
		if t4.value33(chassi.research) then
			t7[#t7 + 1] = chassi
		end
	end

	table.sort(t7, function(p13, p14)
		return p13.index > p14.index
	end)

	return t7
end

t4.value35 = t1.value5
t4.value36 = nil

function t1.value3(p15)
	local pairs_ = pairs
	local t8 = {}

	for k, v in pairs_(t4.value20.phones or {}) do
		local v40 = type(v) == "table"

		if v40 then
			v40 = t4.value35(v.design)

			if v40 then
				v40 = p15 == nil or t4.value36(v.design) == p15
			end
		end

		if v40 then
			pairs_ = #t8 + 1
			t8[pairs_] = {
				k = k,
				d = v.design
			}
		end
	end

	table.sort(t8, function(p16, p17)
		local v41 = tonumber(p16.k)
		local k = p17.k
		local v43 = tonumber(k)

		if v41 and v43 then
			return v43 < v41
		else
			local k2 = p16.k
			local v45 = tostring(k2)
			local k3 = p17.k

			return tostring(k3) < v45
		end
	end)

	return t8
end

t4.value36 = t1.value2
t4.value37 = t1.value3

function t4.value38()
	return t4.value37(nil)
end

t4.value39 = {
	"cash",
	"money",
	"balance",
	"funds"
}
t1.value2 = {
	"day",
	"days",
	"gameDay",
	"date",
	"time"
}

function t1.value4(p18)
	local ok2, result = pcall(t4.value2.device, p18)

	if not ok2 then
		return not ok2 and 0 or result.value
	end

	if type(result) == "table" then
		local value = result.value

		ok2 = tonumber(value)
	else
		ok2 = false
	end

	return not ok2 and 0 or result.value
end

t4.value40 = t1.value2

function t1.value2(p19)
	for _, v in ipairs(p19) do
		local v52 = t4.value20[v]

		if type(v52) == "number" then
			return v52, v
		end
	end
end

t4.value41 = t1.value2

function t1.value3()
	return t4.value41(t4.value39)
end
function t1.value5()
	local v53 = t4.value41(t4.value40)

	if not v53 then
		return nil
	end

	local ok2, result = pcall(t4.value2.year, v53)

	if ok2 then
	elseif ok2 then
		return result
	else
		return nil
	end

	ok2 = type(result) == "number"

	if ok2 then
	elseif ok2 then
		return result
	else
		return nil
	end

	if t4.value10 <= result then
		ok2 = result <= t4.value10 + 60
	else
		ok2 = false
	end

	if ok2 then
		return result
	else
		return nil
	end
end
function t1.value2(p20)
	local ok2, result = pcall(t4.value2.device, p20)

	if ok2 then
	elseif ok2 then
		return tostring(result.name)
	else
		return p20
	end

	if type(result) == "table" then
		ok2 = result.name
	else
		ok2 = false
	end

	if ok2 then
		return tostring(result.name)
	else
		return p20
	end
end

t4.value42 = t1.value3

function t1.value3(p21)
	local ok2, result = pcall(t4.value2.usesChassis, p21)

	if ok2 then
		return result == true
	else
		return p21 == "phone" or (p21 == "tablet" and true or p21 == "foldable")
	end
end

t4.value43 = t1.value5
t4.value44 = t1.value4

function t1.value5()
	local t9 = {}
	local t10 = {}

	local function v62(p22)
		local v63

		if type(p22) == "string" then
			v63 = not t10[p22]
		else
			v63 = false
		end

		if not v63 then
			return
		end

		t10[p22] = true
		t9[#t9 + 1] = p22
	end

	local DeviceOrder = t4.value1.DeviceOrder

	if type(DeviceOrder) == "table" then
		local ipairs_ = ipairs

		for _, v in ipairs_(DeviceOrder) do
			local id

			if type(v) == "table" then
				id = v.id
			else
				id = false
			end

			ipairs_ = v62(id or v)
		end
	end

	if #t9 == 0 then
		for k in pairs(t4.value1.Devices or {}) do
			v62(k)
		end
	end

	v62("phone")

	local function v70(p23, p24)
		local v71 = t4.value44(p23)
		local v72 = t4.value44(p24)

		if v71 == v72 then
			return p23 < p24
		else
			return v72 < v71
		end
	end

	table.sort(t9, v70)

	return t9
end

t4.value45 = t1.value2
t4.value46 = t1.value3
t4.value47 = t1.value5
t1.value7 = {
	"iFon",
	"Samsong",
	"Xiaomay",
	"Oppa",
	"Vivo-vivo",
	"Realmeh",
	"Nokiyah",
	"Huaweh",
	"Pixelz",
	"Sonyc"
}
t1.value2 = 23058715322865
t1.value6 = {
	"Galaksi Lipat",
	"Razor-ish",
	"Oppa Fold",
	"Huaweh Lipet"
}
t1.value2 = {
	"Apel Wotch",
	"Gamin-gamin",
	"Fitbet",
	"Galaksi Wotch"
}
t1.value4 = {
	"AirPot",
	"Buds-buds",
	"Sonyc Buds",
	"Galaksi Bads"
}
t1.value3 = 5443858401766
t1.value5 = {
	"MacBuk",
	"ThinkPed",
	"Azus Zenbuk",
	"Acerr",
	"Lenopo Book"
}
t1.value3 = "\247b\235\241\26"
t1.value3 = {
	"DJI-Jie",
	"Mavik",
	"Drone-drone",
	"Terbang Pro"
}
t4.value48 = {
	phone = t1.value7,
	tablet = {
		"iPed",
		"Galaksi Tab",
		"Lenopo",
		"Xiaomay Pad",
		"Huaweh Pad",
		"Surfais",
		"Fire-fire"
	},
	foldable = t1.value6,
	watch = t1.value2,
	earbuds = t1.value4,
	laptop = t1.value5,
	headset = {
		"Bose-bose",
		"Sennheiser-ish",
		"JBL-lah",
		"Headset Sultan"
	},
	drone = t1.value3,
	contacts = { "Lensa-lensa", "iLens", "Softlens Pro" }
}
t1.value3 = 33225239264367
t1.value4 = 13781374818577
t1.value4 = "\196C4"
t1.value5 = {
	"Gadget-gadget",
	"Alat-alat",
	"Barang Sultan",
	"Teknologi-ish"
}
t1.value2 = 9203187519677
t4.value49 = t1.value5
t1.value5 = {
	"Pro",
	"Max",
	"Ultra",
	"Plus",
	"Mini",
	"Lite",
	"Air",
	"Neo",
	"Prime",
	"Turbo"
}

function t1.value3(p25)
	return math.random(1, (math.max(1, p25)))
end

t4.value50 = t1.value5

function t1.value4(p26)
	local COPY_START = t4.value1.COPY_START or 0.7
	local COPY_FULL = t4.value1.COPY_FULL or 0.95

	return math.clamp((p26 - COPY_START) / (COPY_FULL - COPY_START), 0, 1)
end
function t1.value2(p27)
	return (t4.value1.SIMILAR_CRITIC_PENALTY or 1.5) * p27, (1 - (t4.value1.SIMILAR_SALES_MULT or 0.3)) * p27
end

t1.value5 = {}
t4.value51 = nil

function t1.value6(p28)
	local value49 = t4.value48[p28] or t4.value49

	for _ = 1, 30 do
		local v77 = value49[math.random(#value49)] .. " " .. t4.value50[math.random(#t4.value50)] .. " " .. math.random(2, 99)

		if not t4.value51[v77] then
			t4.value51[v77] = true

			return v77
		end
	end

	return value49[1] .. " " .. math.random(100, 999)
end

t4.value51 = t1.value5
t4.value52 = t1.value6

function t1.value6(p29, p30)
	local ok2, result = pcall(t4.value2.similarity, p29, p30)

	if not ok2 then
		return not ok2 and 0 or result
	end

	ok2 = type(result) == "number"

	return not ok2 and 0 or result
end

t4.value53 = t1.value6
t4.value54 = t1.value4
t4.value55 = t1.value2

function t1.value4(p31)
	local pcall_ = pcall
	local ok2, _, result, result2 = pcall_(t4.value2.copyTarget, t4.value20, p31)
	local v85, v86, v87, v88, v89, v90, v91, launchDay, v93, launchDay2, v95, v96, launchDay3

	if ok2 then
	elseif ok2 then
		return result2, tonumber(result) or 0
	else
		v85 = t4.value41(t4.value40)
		v86, v87, v88 = pairs(t4.value20.phones or {})
		v89 = nil

		while true do
			v88, v90 = v86(v87, v88)

			if not v88 then
				break
			end

			v91 = type(v90) == "table"

			if v91 then
				v91 = t4.value35(v90.design)

				if v91 then
					v91 = t4.value36(v90.design) == t4.value36(p31)

					if v91 then
						v91 = not v89

						if not v91 then
							launchDay = v90.launchDay
							v93 = tonumber(launchDay) or 0
							launchDay2 = v89.launchDay
							v91 = (tonumber(launchDay2) or 0) < v93
						end
					end
				end
			end

			if not v91 then
				v90 = v89
			end

			v89 = v90
		end

		v95 = not v89

		if v95 then
			v85 = v95
		else
			if v85 then
			elseif v85 then
				return 0, 0
			else
				v96 = t4.value53(p31, v89.design)

				return t4.value54(v96), v96
			end

			launchDay3 = v89.launchDay
			v85 = v85 - (tonumber(launchDay3) or 0) >= (t4.value1.SIMILAR_DAYS or 360)
		end

		if v85 then
			return 0, 0
		else
			v96 = t4.value53(p31, v89.design)

			return t4.value54(v96), v96
		end
	end

	ok2 = type(result2) == "number"

	if ok2 then
		return result2, tonumber(result) or 0
	else
		v85 = t4.value41(t4.value40)
		v86, v87, v88 = pairs(t4.value20.phones or {})
		v89 = nil

		while true do
			v88, v90 = v86(v87, v88)

			if not v88 then
				break
			end

			v91 = type(v90) == "table"

			if v91 then
				v91 = t4.value35(v90.design)

				if v91 then
					v91 = t4.value36(v90.design) == t4.value36(p31)

					if v91 then
						v91 = not v89

						if not v91 then
							launchDay = v90.launchDay
							v93 = tonumber(launchDay) or 0
							launchDay2 = v89.launchDay
							v91 = (tonumber(launchDay2) or 0) < v93
						end
					end
				end
			end

			if not v91 then
				v90 = v89
			end

			v89 = v90
		end

		v95 = not v89

		if v95 then
			v85 = v95
		else
			if v85 then
			elseif v85 then
				return 0, 0
			else
				v96 = t4.value53(p31, v89.design)

				return t4.value54(v96), v96
			end

			launchDay3 = v89.launchDay
			v85 = v85 - (tonumber(launchDay3) or 0) >= (t4.value1.SIMILAR_DAYS or 360)
		end

		if v85 then
			return 0, 0
		else
			v96 = t4.value53(p31, v89.design)

			return t4.value54(v96), v96
		end
	end
end

local function v98(p32)
	local v99, v100 = t4.value55(p32)

	return string.format("critics -%.1f, sales -%d%%", v99, (math.floor(v100 * 100 + 0.5)))
end

function t1.value2(p33)
	local v101 = tostring(p33 or ""):lower()

	for _, v in ipairs({
		"cash",
		"afford",
		"money",
		"enough",
		"fund",
		"broke",
		"pay"
	}) do
		if v101:find(v, 1, true) then
			return true
		end
	end

	return false
end

t4.value56 = t1.value4
t4.value57 = nil

function t1.value5(p34)
	p34.color = t4.value57(t4.value1.FREE_COLORS or 9)
	p34.camStyle = t4.value57(t4.value31(t4.value1.CamStyles))
	p34.caseStyle = t4.value57(t4.value31(t4.value1.CaseStyles))

	return p34
end
function t1.value4(p35)
	if p35 == "phone" then
		return true
	end

	local ok2, result = pcall(t4.value2.deviceUnlocked, p35, t4.value21, t4.value43() or math.huge)

	if not ok2 then
		return ok2 and true or #t4.value37(p35) > 0
	end

	ok2 = result == true

	return ok2 and true or #t4.value37(p35) > 0
end

t4.value57 = t1.value3
t4.value58 = t1.value5
t4.value59 = t1.value4
t1.value4 = {
	"screenW",
	"screenH",
	"bezel",
	"corner",
	"portX",
	"selfieX",
	"selfieY",
	"buttonY",
	"buttonSide"
}

function t1.value3(p36)
	local ok2, result = pcall(t4.value2.catsFor, p36)

	if ok2 then
	elseif ok2 then
		return result
	else
		return t4.value1.Categories
	end

	if type(result) == "table" then
		ok2 = next(result)
	else
		ok2 = false
	end

	if ok2 then
		return result
	else
		return t4.value1.Categories
	end
end

t4.value60 = t1.value4

function t1.value4(p37)
	local dev = t4.value20.dev

	if dev then
		dev = t4.value35(t4.value20.dev.design)

		if dev then
			dev = t4.value36(t4.value20.dev.design) == p37
		end
	end

	if dev then
		return t4.value20.dev.design
	end

	local v109 = t4.value37(p37)

	if v109[1] then
		return v109[1].d
	end

	local ok2, result = pcall(t4.value2.defaultDesign, p37)

	if ok2 then
		ok2 = type(result) == "table"
	end

	if not ok2 then
		return nil
	end

	local v112 = t4.value30(result)

	v112.device = p37

	if t4.value46(p37) then
	elseif t4.value35(v112) then
		return v112
	else
		return nil
	end

	local v113 = t4.value37("phone")[1]

	if v113 then
	elseif t4.value35(v112) then
		return v112
	else
		return nil
	end

	for _, v in ipairs(t4.value60) do
		if v112[v] == nil then
			v112[v] = v113.d[v]
		end
	end

	if t4.value35(v112) then
		return v112
	else
		return nil
	end
end

t4.value61 = t1.value4
t4.value62 = t1.value3

function t1.value3(p38, p39)
	local ok2, result = pcall(t4.value2.launchCost, p38, p39)
	local LAUNCH_COST

	if ok2 then
	elseif ok2 then
		return result
	else
		LAUNCH_COST = t4.value1.LAUNCH_COST and t4.value1.LAUNCH_COST[p38] or 30000

		return math.floor(LAUNCH_COST * (t4.value1.LAUNCH_COST_GROWTH or 1.11) ^ (p39 - t4.value10))
	end

	ok2 = type(result) == "number"

	if ok2 then
		return result
	else
		LAUNCH_COST = t4.value1.LAUNCH_COST and t4.value1.LAUNCH_COST[p38] or 30000

		return math.floor(LAUNCH_COST * (t4.value1.LAUNCH_COST_GROWTH or 1.11) ^ (p39 - t4.value10))
	end
end
function t1.value5(p40, p41)
	local v119 = t4.value30(p40.specs or {})

	for _, v in pairs(t4.value62(p41)) do
		local id

		if type(v) == "table" then
			id = v.id or v
		else
			id = v
		end

		local needs

		if type(v) == "table" then
			needs = v.needs
		else
			needs = false
		end

		local v124

		if type(id) == "string" then
			v124 = not needs
		else
			v124 = false
		end

		if v124 then
			local v125 = t4.value34(id)

			if v125[1] then
				v119[id] = v125[1].id
			end
		end
	end

	return v119
end
function t1.value4(p42)
	local function v126(p43)
		local pairs_ = pairs
		local v128, v129, v130 = pairs_(t4.value20.phones or {})
		local t11 = {}

		while true do
			local v132

			v130, v132 = v128(v129, v130)

			if not v130 then
				break
			end

			local v133 = type(v132) == "table"

			if v133 then
				local critic = v132.critic

				v133 = tonumber(critic)

				if v133 then
					local launchDay = v132.launchDay

					v133 = tonumber(launchDay)
				end
			end

			if v133 then
				local device = v132.device

				if not device then
					local device2

					if type(v132.design) == "table" then
						device2 = v132.design.device
					else
						device2 = false
					end

					device = device2 or "phone"
				end

				if p43 == nil and true or device == p43 then
					pairs_ = #t11 + 1
					t11[pairs_] = v132
				end
			end
		end

		if #t11 == 0 then
			return nil
		end

		table.sort(t11, function(p44, p45)
			local launchDay = p44.launchDay
			local v139 = tonumber(launchDay)
			local launchDay2 = p45.launchDay

			return tonumber(launchDay2) < v139
		end)

		local v141 = #t11
		local v142 = math.min(v141, 3)
		local n2 = 0

		for i = 1, v142 do
			local critic = t11[i].critic

			n2 = n2 + tonumber(critic)
		end

		return n2 / v142
	end

	return v126(p42) or (v126(nil) or 7.5)
end

t4.value63 = t1.value5

function t1.value6(p46, p47)
	local ok2, result = pcall(t4.value2.unitCost, p46, p47, t4.value20.effects)

	if ok2 then
		ok2 = type(result) == "number"
	end

	if ok2 then
		return result
	end

	local ok3, result2 = pcall(t4.value2.unitCost, p46, p47)

	if ok3 then
	elseif ok3 then
		return result2
	else
		return nil
	end

	ok3 = type(result2) == "number"

	if ok3 then
		return result2
	else
		return nil
	end
end
function t1.value5(p48)
	local v150 = t4.value28[p48]

	if v150 then
		return math.ceil(v150 * t4.value9)
	else
		return t4.value8
	end
end

local function v151(p49, p50)
	local v152 = t4.value30(p49)

	v152.device = p50

	local v153

	if t4.value46(p50) then
		local v154 = v32()

		if not v154[1] then
			return nil
		end

		v153 = v154[1]
		v152.chassis = v153.id
	else
		v153 = nil
	end

	v152.specs = t4.value63(p49, p50)
	v152.name = t4.value52(p50)

	return t4.value58(v152), v153
end

t4.value64 = t1.value3
t4.value65 = t1.value6
t4.value66 = nil

function t1.value3(p51, p52, p53)
	local v155 = t4.value64(p51, p53)
	local n3 = 0
	local value65 = t4.value65
	local n4 = 0
	local v159 = value65(p52, p53)

	if v159 then
		local pcall_ = pcall
		local ok2

		ok2, value65 = pcall_(t4.value2.orderCost, v159, t4.value11)

		if ok2 then
			ok2 = type(value65) == "number"
		end

		if ok2 then
			n3 = value65
		else
			value65 = pcall_
		end
	end

	local ok2, result = pcall(t4.value2.devDailyCost, p52, p53, v159)
	local v164

	if ok2 then
		v164 = type(result) == "number"
	else
		v164 = ok2
	end

	if not v164 then
		ok2, result = pcall(t4.value2.devDailyCost, p52, p53)
	end

	if ok2 then
		ok2 = type(result) == "number"
	end

	if not ok2 then
		return v155 + n3 + n4
	end

	n4 = result * t4.value66(p51)

	return v155 + n3 + n4
end

t4.value66 = t1.value5
t4.value67 = t1.value3
t4.value68 = 0.9
t4.value69 = t1.value4

function t1.value3(p54)
	local v165 = t4.value43()
	local value41 = t4.value41
	local v167 = value41(t4.value40)
	local v168

	if v167 then
		value41 = pcall

		local v169

		v169, v168 = value41(t4.value2.year, v167 + t4.value66(p54))

		if v169 then
			v169 = type(v168) == "number"
		end

		if v169 then
			value41 = v168
		else
			v168 = v165
		end
	else
		v168 = v165
	end

	if not v168 then
		return nil
	end

	local v170 = t4.value69(p54)
	local ok2, result = pcall(t4.value2.valuePrice, v170, v168, p54)

	if ok2 then
	elseif ok2 then
		return result
	else
		return nil
	end

	if type(result) == "number" then
		ok2 = result > 0
	else
		ok2 = false
	end

	if ok2 then
		return result
	else
		return nil
	end
end

t4.value70 = t1.value3

function t1.value3(p55, p56)
	local v173 = t4.value70(p55)

	if v173 then
	elseif t4.value26[p55] then
		return t4.value26[p55]
	else
		for k, v in pairs(t4.value26) do
			local v176 = t4.value44(p55)
			local v177 = t4.value44(k)
			local v178

			if v176 > 0 then
				v178 = v177 > 0
			else
				v178 = false
			end

			if v178 then
				return math.max(1, math.floor(v * v176 / v177))
			end
		end

		return t4.value5
	end

	local v179 = v173 * t4.value68
	local v180 = t4.value43()

	if not (p56 and v180) then
		return math.max(1, math.floor(v179 + 0.5))
	end

	local v181 = t4.value65(p56, v180)

	if not v181 then
		return math.max(1, math.floor(v179 + 0.5))
	end

	local v182 = v181 * 1.5

	v179 = math.max(v179, v182)

	return math.max(1, math.floor(v179 + 0.5))
end

t4.value71 = nil

function t1.value4(p57, p58)
	local dev = t4.value20.dev
	local design, v185

	if not dev then
		if dev then
			design = t4.value20.dev.design
		else
			design = t4.value61(p57)
		end

		if design then
			v185 = t4.value65(design, p58)

			if v185 then
				return t4.value71(p57, design) - v185, design
			else
				return nil
			end
		else
			return nil
		end
	end

	dev = t4.value35(t4.value20.dev.design)

	if not dev then
		if dev then
			design = t4.value20.dev.design
		else
			design = t4.value61(p57)
		end

		if design then
			v185 = t4.value65(design, p58)

			if v185 then
				return t4.value71(p57, design) - v185, design
			else
				return nil
			end
		else
			return nil
		end
	end

	dev = t4.value36(t4.value20.dev.design) == p57

	if dev then
		design = t4.value20.dev.design
	else
		design = t4.value61(p57)
	end

	if design then
		v185 = t4.value65(design, p58)

		if v185 then
			return t4.value71(p57, design) - v185, design
		else
			return nil
		end
	else
		return nil
	end
end

t4.value71 = t1.value3

function t1.value3()
	if t4.value22 then
		if not (#t4.value38() > t4.value23) then
			return false, "Developing your device..."
		end
	else
	end

	if t4.value24 and (#t4.value38() <= t4.value24.count and os.clock() - t4.value24.t <= 15) then
		return false, "Waiting for your last device to show up..."
	end

	if next(t4.value21) == nil then
		return false, "Loading your game data..."
	end

	local v186 = t4.value38()
	local v187 = t4.value42()
	local v188 = t4.value43()
	local v189

	if v187 == nil then
		v189 = false
	else
		v189 = v188 ~= nil
	end

	local v190, v191, v192 = ipairs(t4.value47())
	local v193 = nil
	local v194 = nil
	local t12 = {}
	local n5 = 0
	local n6 = 0
	local v198 = nil
	local v199 = nil

	while true do
		local v200

		v192, v200 = v190(v191, v192)

		local v201

		if not v192 then
			v201 = v199

			break
		end

		local v202 = t4.value59(v200)

		if v202 then
			v202 = (t4.value27[v200] or 0) <= os.clock()
		end

		if v202 then
			local v203 = t4.value61(v200)

			if v203 then
				local v204, v205 = v151(v203, v200)

				if v204 then
					local v206 = true

					if v189 then
						n5 = n5 + 1
						v201 = t4.value67(v200, v204, v188)

						if v187 < v201 then
							v206 = false
							t12[#t12 + 1] = t4.value45(v200) .. " needs " .. t4.value32(v201)

							if not v199 or v201 < v199 then
								v198 = t4.value45(v200)
							else
								v201 = v199
							end
						else
							n6 = n6 + 1
							v201 = v199
						end
					else
						v201 = v199
					end

					if v206 then
						local v207, v208 = t4.value56(v204)

						if v207 <= t4.value6 then
							v194 = {
								dv = v200,
								design = v204,
								chassis = v205,
								cp = v207,
								s = v208
							}

							break
						end

						if not v193 or v207 < v193.cp then
							v193 = {
								dv = v200,
								cp = v207,
								s = v208
							}
						end
					end
				else
					v201 = v199
				end
			else
				v201 = v199
			end
		else
			v201 = v199
		end

		v199 = v201
	end

	local v209 = v189 and "" or v189 or " (cash check unavailable)"

	if not v194 then
		if v189 then
			if n5 > 0 then
				v189 = n6 == 0
			else
				v189 = false
			end
		end

		if v189 then
			if t4.value17 then
				return false, string.format("You\'re broke! You have %s, but the cheapest device (%s) needs %s. Waiting for income...", t4.value32(v187), v198, t4.value32(v250))
			end

			t2.value3:Notify({
				Title = "You\'re broke!",
				Content = "You can\'t afford to launch any device right now. Auto Build will continue when you have enough cash.",
				Icon = "x",
				Duration = 6
			})

			return false, string.format("You\'re broke! You have %s, but the cheapest device (%s) needs %s. Waiting for income...", t4.value32(v187), v198, t4.value32(v250))
		else
			if v193 then
				local format = string.format
				local v211 = t4.value45(v193.dv)
				local v212 = v193.s * 100 + 0.5

				v262 = format("Waiting for new research. Closest: %s is %d%% same tech (%s).", v211, math.floor(v212), v98(v193.cp))
			else
				v262 = "Waiting for new research so your next device isn\'t too similar to your last one."
			end

			if not (#t12 > 0) then
				return false, v262 .. v209
			end

			local v213 = v262 .. " (" .. table.concat(t12, "; ") .. ")"

			return false, v213 .. v209
		end
	end

	local v214 = t4.value71(v194.dv, v194.design)
	local v215 = nil

	local function v216()
		return t4.value3:InvokeServer("startDev", v194.design, v215)
	end

	v215 = v214

	local ok2, result = pcall(v216)

	if ok2 then
		if type(result) == "table" then
			ok2 = result.ok
		else
			ok2 = false
		end
	end

	if ok2 then
		local _ = #v186

		t4.value25 = v194.dv

		local format = string.format
		local v221 = t4.value45(v194.dv)
		local name = v194.design.name
		local v223 = format("Building %s \"%s\" (price %s)", v221, tostring(name), t4.value32(v215))

		if v194.cp > 0 then
			local cp = v194.cp
			local v225, v226 = t4.value55(cp)

			v223 = v223 .. " | " .. string.format("critics -%.1f, sales -%d%%", v225, (math.floor(v226 * 100 + 0.5)))
		end

		if not (#t12 > 0) then
			return true, v223 .. v209
		end

		v223 = v223 .. " | skipped: " .. table.concat(t12, "; ")

		return true, v223 .. v209
	else
		t4.value27[v194.dv] = os.clock() + t4.value7

		if type(result) ~= "table" then
			v275 = tostring(result)

			return false, string.format("Couldn\'t start %s: %s", t4.value45(v194.dv), v275) .. v209
		end

		result = result.msg or result

		local v227 = tostring(result)

		return false, string.format("Couldn\'t start %s: %s", t4.value45(v194.dv), v227) .. v209
	end
end
function t1.value5(p59, p60)
	local cost = p59.cost
	local v229 = tonumber(cost) or 0

	if v229 <= 0 then
		return 0
	else
		local v230 = p60 or t4.value10 - t4.value10

		return math.floor(v229 * (t4.value1.MARKETING_GROWTH or 1.18) ^ v230 + 0.5)
	end
end

t4.value72 = "best"
t4.value73 = 1.05
t4.value74 = 16

local function v231()
	local t13 = {}

	for _, v in ipairs(t4.value1.Marketing or {}) do
		local id

		if type(v) == "table" then
			id = v.id
		else
			id = false
		end

		if id then
			t13[#t13 + 1] = v
		end
	end

	table.sort(t13, function(p61, p62)
		local v236 = tonumber(p61.hype) or 1
		local v237 = tonumber(p62.hype) or 1

		if v236 == v237 then
			local id = p61.id
			local v239 = tostring(id)
			local id2 = p62.id

			return v239 < tostring(id2)
		else
			return v237 < v236
		end
	end)

	return t13
end

t4.value75 = t1.value5
t4.value76 = t1.value2

function t4.value77()
	local function v241()
		return t4.value3:InvokeServer("forecast")
	end

	local ok2, result = pcall(v241)
	local weekly, v245, coverage, v247

	if not ok2 then
		if ok2 then
			weekly = result.data.weekly
			v245 = tonumber(weekly)
			coverage = result.data.coverage
			v247 = tonumber(coverage)

			if v245 and v247 then
				return v245, v247
			else
				return
			end
		end

		return
	end

	ok2 = type(result) == "table"

	if not ok2 then
		if ok2 then
			weekly = result.data.weekly
			v245 = tonumber(weekly)
			coverage = result.data.coverage
			v247 = tonumber(coverage)

			if v245 and v247 then
				return v245, v247
			else
				return
			end
		end

		return
	end

	ok2 = result.ok

	if not ok2 then
		if ok2 then
			weekly = result.data.weekly
			v245 = tonumber(weekly)
			coverage = result.data.coverage
			v247 = tonumber(coverage)

			if v245 and v247 then
				return v245, v247
			else
				return
			end
		end

		return
	end

	local data = result.data

	ok2 = type(data) == "table"

	if ok2 then
		weekly = result.data.weekly
		v245 = tonumber(weekly)
		coverage = result.data.coverage
		v247 = tonumber(coverage)

		if v245 and v247 then
			return v245, v247
		else
			return
		end
	end
end

t4.value78 = t1.value4

local function v249(p63)
	local v251 = t4.value43()
	local v252 = t4.value42()
	local v253 = v231()
	local t14 = {
		id = "none",
		name = "No marketing"
	}
	local v254, v255 = t4.value77()
	local v256, v257

	if v251 then
		v256, v257 = t4.value78(p63, v251)
	else
		v256 = nil
		v257 = nil
	end

	local function v258(p64)
		local v259 = v254
		local v260, hype, v263

		if v259 then
		elseif v259 then
			v260 = v254 * v255
			hype = p64.hype
			v263 = v251

			return v260 * ((tonumber(hype) or 1) - 1) * v256 * t4.value74 - t4.value75(p64, v263)
		else
			return nil
		end

		v259 = v255

		if v259 then
		elseif v259 then
			v260 = v254 * v255
			hype = p64.hype
			v263 = v251

			return v260 * ((tonumber(hype) or 1) - 1) * v256 * t4.value74 - t4.value75(p64, v263)
		else
			return nil
		end

		v259 = v256

		if v259 then
		elseif v259 then
			v260 = v254 * v255
			hype = p64.hype
			v263 = v251

			return v260 * ((tonumber(hype) or 1) - 1) * v256 * t4.value74 - t4.value75(p64, v263)
		else
			return nil
		end

		v259 = v251

		if v259 then
			v260 = v254 * v255
			hype = p64.hype
			v263 = v251

			return v260 * ((tonumber(hype) or 1) - 1) * v256 * t4.value74 - t4.value75(p64, v263)
		else
			return nil
		end
	end
	local function v264(p65, p66)
		if (tonumber(p65.cost) or 0) <= 0 then
			return true
		end

		local v265 = not v252

		if v265 then
			v265 = v251
		end

		if v265 then
			return false
		end

		local v266 = t4.value64(p63, v251)
		local v267 = v251
		local v268 = t4.value75(p65, v267)
		local value73 = t4.value73
		local v269 = (v266 + v268) * value73

		if p66 then
			p66 = v257
		end

		if not p66 then
			return v269 <= v252
		end

		v269 = v269 + t4.value67(p63, v257, v251)

		return v269 <= v252
	end

	if t4.value72 == "best" then
		local v270, v271, v272 = ipairs(v253)
		local v273 = nil
		local v274 = nil

		while true do
			local v276

			v272, v276 = v270(v271, v272)

			if not v272 then
				break
			end

			local cost = v276.cost
			local v277

			if (tonumber(cost) or 0) > 0 then
				v277 = v264(v276, true)
			else
				v277 = false
			end

			local v278

			if v277 then
				v278 = v258(v276)

				local v279

				if v278 then
					v279 = v278 > 0

					if v279 then
						v279 = not v273 or v273 < v278
					end
				else
					v279 = v278
				end

				if not v279 then
					v276 = v274
					v278 = v273
				end
			else
				v276 = v274
				v278 = v273
			end

			v274 = v276
			v273 = v278
		end

		return v274 and { v274, t14 } or { t14 }
	else
		local v280 = false
		local t15 = {}

		for _, v in ipairs(v253) do
			v280 = v.id == t4.value72 and true or v280

			local v284

			if v280 then
				v284 = v264(v, false)
			else
				v284 = v280
			end

			if v284 then
				t15[#t15 + 1] = v
			end
		end

		if not (#t15 == 0 and true or t15[#t15].id ~= "none") then
			return t15
		end

		t15[#t15 + 1] = t14

		return t15
	end
end

function t4.value79()
	local v285, v286, v287 = ipairs(unpack_({ v249(t4.value25 or "phone") }))
	local v288 = nil
	local v289 = nil

	while true do
		local v290

		v287, v290 = v285(v286, v287)

		if not v287 then
			break
		end

		local function v291()
			return t4.value3:InvokeServer("launch", v290.id)
		end

		local ok2, result = pcall(v291)

		v289 = ok2 and result or tostring(result)

		if ok2 then
			if type(result) == "table" then
				ok2 = result.ok
			else
				ok2 = false
			end
		end

		if ok2 then
			v288 = v290

			break
		end

		local msg

		if type(v289) == "table" then
			msg = v289.msg
		else
			msg = false
		end

		if not t4.value76(msg or v289) then
			break
		end
	end

	if v288 then
		local data = v289.data

		if type(data) ~= "table" then
			v363 = #t4.value38()
			os.clock()
			v364 = v288.name or v288.id

			return true, "Launched! (" .. tostring(v364) .. ")"
		end

		local data2 = v289.data
		local marketingCost = data2.marketingCost
		local v298 = tonumber(marketingCost) or 0
		local valuePrice = data2.valuePrice

		if tonumber(valuePrice) then
			local value26 = t4.value26
			local value25 = t4.value25 or "phone"
			local valuePrice2 = data2.valuePrice

			value26[value25] = math.floor(valuePrice2)
		end

		local value29 = t4.value29
		local s1 = "n"

		value29[s1] = value29[s1] + 1

		local value292 = t4.value29
		local s2 = "profit"
		local launchProfit = data2.launchProfit
		local v308 = (tonumber(launchProfit) or 0) - v298

		value292[s2] = value292[s2] + v308
		t4.value19()

		local v309 = #t4.value38()

		os.clock()

		local name = v288.name or v288.id

		return true, "Launched! (" .. tostring(name) .. ")"
	else
		local v311 = false
		local tostring_ = tostring

		if type(v289) ~= "table" then
			return v311, tostring_(v289)
		end

		v289 = v289.msg or v289

		return v311, tostring_(v289)
	end
end

t4.value80 = nil
t4.value80 = t1.value3

function t4.value81()
	if t4.value14 then
		return
	end

	if t4.value29.cash0 == nil then
		t4.value29.cash0 = t4.value42()
	end

	local v313, v314 = t4.value80()
	local v315 = not v313

	t4.value16 = v314

	if v315 then
		v315 = t4.value15
	end

	if not v315 then
		t4.value18(t4.value16)

		return
	end

	local v316, v317 = t4.value79()

	if not v316 then
		t4.value18(t4.value16)

		return
	end

	t4.value16 = v317
	t4.value18(t4.value16)
end

local spawn = task.spawn

function t1.value2()
	while t4.value12 do
		task.wait(t4.value4)

		if t4.value13 then
			pcall(t4.value81)
		end
	end
end

spawn(t1.value2)
t4.value82 = 3
t4.value83 = 30
t4.value84 = 20
t4.value85 = 10
t4.value86 = true
t4.value87 = false
t4.value88 = "Most expensive first"
t4.value89 = {}

function t4.value90()
	local v319 = t4.value43()
	local pairs_ = pairs
	local t16 = {}

	for k, v in pairs_(t4.value1.ResearchById or {}) do
		local v324 = type(v) == "table"

		if v324 then
			v324 = t4.value21[k] ~= true

			if v324 then
				v324 = (t4.value89[k] or 0) <= os.clock()

				if v324 then
					if v319 == nil then
						v324 = true
					else
						local year = v.year

						v324 = (tonumber(year) or 0) <= v319
					end
				end
			end
		end

		if v324 then
			pairs_ = pairs

			local v326, v327, v328 = pairs_(v.requires or {})
			local v329 = true

			while true do
				local v330

				v328, v330 = v326(v327, v328)

				if not v328 then
					break
				end

				if t4.value21[v330] ~= true then
					v329 = false
					pairs_ = false

					break
				end
			end

			if v329 then
				t16[#t16 + 1] = {
					id = k,
					r = v
				}
			end
		end
	end

	table.sort(t16, function(p67, p68)
		local v331 = tonumber(p67.r.cost) or 0
		local cost = p68.r.cost
		local v333 = tonumber(cost) or 0
		local tier = p67.r.tier
		local v335 = tonumber(tier) or 0
		local v336 = tonumber(p68.r.tier) or 0
		local id, v338, id2

		if t4.value88 == "Cheapest first" then
			if v331 == v333 then
				if v335 == v336 then
					id = p67.id
					v338 = tostring(id)
					id2 = p68.id

					return v338 < tostring(id2)
				else
					return v335 < v336
				end
			else
				return v331 < v333
			end
		elseif v331 == v333 then
			if v335 == v336 then
				id = p67.id
				v338 = tostring(id)
				id2 = p68.id

				return v338 < tostring(id2)
			else
				return v336 < v335
			end
		else
			return v333 < v331
		end
	end)

	return t16
end

local function v340()
	if t4.value87 then
		return
	end

	if next(t4.value21) == nil then
		return
	end

	local MULTI_RESEARCH_SLOTS = t4.value1.MULTI_RESEARCH_SLOTS or 1
	local n7 = 0
	local n8 = 0

	for _, v in ipairs(t4.value90()) do
		if t4.value85 <= n7 and true or MULTI_RESEARCH_SLOTS <= n8 then
			return
		end

		n7 = n7 + 1

		local function v346()
			return t4.value3:InvokeServer("research", v.id)
		end

		local ok2, result = pcall(v346)

		if ok2 then
			ok2 = result == true

			if not ok2 then
				if type(result) == "table" then
					ok2 = result.ok == true
				else
					ok2 = false
				end
			end
		end

		if ok2 then
			n8 = n8 + 1
			t4.value89[v.id] = os.clock() + t4.value83
		else
			t4.value89[v.id] = os.clock() + t4.value84
		end

		task.wait(0.3)
	end
end

task.spawn(function()
	while t4.value12 do
		task.wait(t4.value82)

		if t4.value86 then
			pcall(v340)
		end
	end
end)
t4.value91 = 5
t4.value92 = false
t4.value93 = false
t4.value94 = "Cheapest first"

function t4.value95() end

t4.value96 = {
	na = true
}
t4.value97 = {
	"latam",
	"mea",
	"eu",
	"asia"
}
t4.value98 = nil

function t1.value2()
	local t17 = {}

	for _, v in ipairs(t4.value97) do
		if not t4.value96[v] then
			local v352 = t4.value1.RegionById[v]

			if v352 then
				local v353 = t4.value98(v, v352.cost)

				t17[#t17 + 1] = {
					id = v,
					name = v352.name,
					share = v352.share,
					cost = v353
				}
			end
		end
	end

	table.sort(t17, function(p69, p70)
		if t4.value94 == "Best value first" then
			local share = p69.share
			local cost = p69.cost
			local v356 = share / math.max(cost, 1)
			local share2 = p70.share
			local cost2 = p70.cost
			local v359 = share2 / math.max(cost2, 1)

			if v356 == v359 then
				return p69.id < p70.id
			else
				return v359 < v356
			end
		elseif p69.cost == p70.cost then
			return p69.id < p70.id
		else
			return p69.cost < p70.cost
		end
	end)

	return t17
end
function t4.value98(p71, p72)
	local t18 = { function()
			return t4.value2.regionCost(p71)
		end, function()
			return t4.value2.regionCost(p71, t4.value31(t4.value96))
		end }

	for _, v in ipairs(t18) do
		local ok2, result = pcall(v)

		if ok2 then
			if type(result) == "number" then
				ok2 = result > 0
			else
				ok2 = false
			end
		end

		if ok2 then
			return result
		end
	end

	return p72
end

t4.value99 = t1.value2

function t4.value100()
	if t4.value93 then
		return
	end

	local v365 = t4.value99()

	if #v365 == 0 then
		t4.value95("All available regions unlocked!")

		return
	end

	local v366 = t4.value42()
	local v367, v368, v369 = ipairs(v365)
	local v370 = nil

	while true do
		local v371

		v369, v371 = v367(v368, v369)

		if not v369 then
			v371 = v370

			break
		end

		local v372

		if v366 then
			v372 = v371.cost <= v366
		else
			v372 = v366
		end

		if v372 then
			break
		end
	end

	if not v_u_428 then
		local v373 = v365[1]

		t4.value95(string.format("Saving up for %s (%s)", v373.name, t4.value32(v373.cost)))

		return
	end

	local function v374()
		return t4.value3:InvokeServer("expand", v_u_428.id)
	end

	local ok2, result = pcall(v374)
	local value95, format, name, v380, value3, tostring_, msg, v384

	if not ok2 then
		if ok2 then
			t4.value96[v_u_428.id] = true
			value95 = t4.value95
			format = string.format
			name = v_u_428.name
			v380 = v_u_428.share * 100 + 0.5
			value95(format("Expanded into %s! (+%d%% of buyers)", name, (math.floor(v380))))
			value3 = t2.value3
			value3.Notify(value3, {
				Title = "Auto Expand",
				Content = "Expanded into " .. v_u_428.name .. "!",
				Icon = "globe",
				Duration = 3
			})
		else
			tostring_ = tostring

			if type(result) == "table" then
				msg = result.msg
			else
				msg = false
			end

			v384 = tostring_(msg or result)

			if v384:lower():find("already") or v384:lower():find("own") then
				t4.value96[v_u_428.id] = true
				t4.value95("Already own " .. v_u_428.name .. ", skipping it from now on.")
			else
				t4.value95(string.format("Couldn\'t expand into %s: %s", v_u_428.name, v384))
			end
		end

		return
	end

	if type(result) == "table" then
		ok2 = result.ok
	else
		ok2 = false
	end

	if ok2 then
		t4.value96[v_u_428.id] = true
		value95 = t4.value95
		format = string.format
		name = v_u_428.name
		v380 = v_u_428.share * 100 + 0.5
		value95(format("Expanded into %s! (+%d%% of buyers)", name, (math.floor(v380))))
		value3 = t2.value3
		value3.Notify(value3, {
			Title = "Auto Expand",
			Content = "Expanded into " .. v_u_428.name .. "!",
			Icon = "globe",
			Duration = 3
		})
	else
		tostring_ = tostring

		if type(result) == "table" then
			msg = result.msg
		else
			msg = false
		end

		v384 = tostring_(msg or result)

		if v384:lower():find("already") or v384:lower():find("own") then
			t4.value96[v_u_428.id] = true
			t4.value95("Already own " .. v_u_428.name .. ", skipping it from now on.")
		else
			t4.value95(string.format("Couldn\'t expand into %s: %s", v_u_428.name, v384))
		end
	end
end

local spawn2 = task.spawn

function t1.value2()
	while t4.value12 do
		task.wait(t4.value91)

		if t4.value92 then
			pcall(t4.value100)
		end
	end
end

spawn2(t1.value2)
t4.value101 = 5
t4.value102 = false
t4.value103 = false

function t1.value2() end

t4.value104 = t1.value2
t4.value105 = nil

local function v386()
	if t4.value103 then
		return
	end

	local function v387()
		return t4.value3:InvokeServer("upgradeOffice")
	end

	local ok2, result = pcall(v387)

	if ok2 then
		if type(result) == "table" then
			ok2 = result.ok
		else
			ok2 = false
		end
	end

	if not ok2 then
		local tostring_ = tostring
		local msg

		if type(result) == "table" then
			msg = result.msg
		else
			msg = false
		end

		local notReadyYet = tostring_(msg or result)

		t4.value104("Not ready yet: " .. notReadyYet)

		return
	end

	local function v393()
		t4.value105:Set(false, false)
	end

	t4.value102 = false
	pcall(v393)
	t4.value104("Requirements met! Go tap \"Move in\" yourself to place your furniture.")
	t2.value3:Notify({
		Title = "Auto Office",
		Content = "Your next office is ready — tap Move in to place your furniture!",
		Icon = "building",
		Duration = 6
	})
end

task.spawn(function()
	while t4.value12 do
		task.wait(t4.value101)

		if t4.value102 then
			pcall(v386)
		end
	end
end)

local function v394(...)
	for _, v in ipairs({ ... }) do
		local ok2, result = pcall(t2.value3.Creator.Icon, v)

		if ok2 and result then
			return v
		end
	end

	return "info"
end

t1.value2 = t2.value3

local color3 = Color3.fromHex("#FF8200")

t1.value7 = Color3
t1.value3 = 15430521478161
t1.value3 = "Vհ\143m\5\136"
t1.value7 = t1.value7.fromHex("#0B0B0D")
t1.value4 = Color3.fromHex("#F5F5F5")
t1.value3 = Color3.fromHex("#27272A")

local color32 = Color3.fromHex("#FFB066")
local color33 = Color3.fromHex("#EA6F00")

t1.value5 = Color3.fromHex("#FF8200")

local color34 = Color3.fromHex("#1F1F23")
local value3 = t2.value3
local t19 = {
	["0"] = {
		Color = Color3.fromHex("#1C1006"),
		Transparency = 0
	},
	["100"] = {
		Color = Color3.fromHex("#0B0B0D"),
		Transparency = 0
	}
}
local v405 = value3.Gradient(value3, t19, {
	Rotation = 135
})
local color35 = Color3.fromHex("#000000")

t1.value6 = Color3.fromHex("#FFFFFF")

local color36 = Color3.fromHex("#FF9F40")
local color37 = Color3.fromHex("#FF8200")
local color38 = Color3.fromHex("#FF8200")
local color39 = Color3.fromHex("#18181B")
local color310 = Color3.fromHex("#F5F5F5")
local color311 = Color3.fromHex("#FF8200")
local color312 = Color3.fromHex("#161618")

t1.value8 = Color3.fromHex("#F5F5F5")
t1.value9 = Color3.fromHex("#A8A29E")
t1.value10 = Color3.fromHex("#FF8200")
t1.value11 = Color3.fromHex("#FF8200")
t1.value12 = Color3.fromHex("#2A2A2E")
t1.value13 = Color3.fromHex("#FF8200")
t1.value14 = Color3

local AddTheme = t1.value2.AddTheme

t1.value14 = t1.value14.fromHex("#FFFFFF")
AddTheme(t1.value2, {
	Name = "RansBlox",
	Accent = color3,
	Background = t1.value7,
	BackgroundTransparency = 0.02,
	Text = t1.value4,
	Outline = t1.value3,
	Placeholder = color32,
	Button = color33,
	Icon = t1.value5,
	Hover = color34,
	WindowBackground = v405,
	WindowShadow = color35,
	WindowTopbarTitle = t1.value6,
	WindowTopbarAuthor = color36,
	WindowTopbarIcon = color37,
	WindowTopbarButtonIcon = color38,
	TabBackground = color39,
	TabTitle = color310,
	TabIcon = color311,
	ElementBackground = color312,
	ElementTitle = t1.value8,
	ElementDesc = t1.value9,
	ElementIcon = t1.value10,
	Toggle = t1.value11,
	ToggleBar = t1.value12,
	Slider = t1.value13,
	SliderThumb = t1.value14
})
t1.value2 = t2.value3
t1.value5 = 487875543267
t1.value3 = 16249824271758
t1.value3 = UDim2.fromOffset(560, 360)
t1.value4 = {
	Enabled = true
}

local uDim = UDim.new(1, 0)

t1.value5 = ColorSequence.new(Color3.fromHex("#FF9A1F"), Color3.fromHex("#FF6A00"))

local t20 = {
	Title = "Phone Empire",
	CornerRadius = uDim,
	StrokeThickness = 3,
	Enabled = true,
	Draggable = true,
	OnlyMobile = false,
	Scale = 0.5,
	Color = t1.value5
}
local KeyCode = Enum.KeyCode
local CreateWindow = t1.value2.CreateWindow

t1.value6 = KeyCode.RightControl
t4.value106 = CreateWindow(t1.value2, {
	Title = "Ransblox Scripts",
	Author = "Phone Empire",
	Icon = "youtube",
	Theme = "RansBlox",
	NewElements = true,
	Folder = "Phone Empire",
	Size = t1.value3,
	Radius = 20,
	ElementsRadius = 16,
	ShadowTransparency = 0.6,
	User = t1.value4,
	Topbar = {
		Height = 44,
		ButtonsType = "Mac"
	},
	HideSearchBar = false,
	OpenButton = t20,
	ToggleKey = t1.value6
})

local value106 = t4.value106

t1.value3 = "Lx\t\164\127\228\175"
t1.value2 = "Tag"
t1.value7 = Color3

local Tag = value106.Tag

t1.value3 = 28477199070156
t1.value2 = Tag
t1.value7 = t1.value7.fromHex("#FF8200")
t1.value2(value106, {
	Title = "v1.0",
	Icon = "youtube",
	Color = t1.value7,
	Border = true
})

local value1062 = t4.value106

t1.value5 = "\172\191\183~*{gj\186,\0"
t1.value3 = 5533625403920
t1.value7 = Color3.fromHex
t1.value2 = value1062.Tag
t1.value6 = t1.value7("#22C55E")
t1.value3 = "m\177S[&f"
t1.value3 = 2042533118903
t1.value2(value1062, {
	Title = "FREE",
	Icon = "badge-check",
	Color = t1.value6,
	Border = true
})
t1.value4 = t4.value106
t1.value6 = v394("house", "home")
t1.value3 = Color3
t1.value2 = t1.value4.Tab
t1.value3 = t1.value3.fromHex("#FF8200")
t1.value2 = t1.value2(t1.value4, {
	Title = "Home",
	Icon = t1.value6,
	IconColor = t1.value3,
	IconShape = "Circle"
})

local t21 = {
	Home = t1.value2
}

t1.value4 = t4.value106
t1.value5 = "\165>|\230"
t1.value3 = "\137\191OO\1548k7\174\205"
t1.value6 = v394("smartphone", "house")
t1.value3 = 22292284598412
t1.value3 = "\231\193a\131\233Ȋ\229e"
t1.value3 = Color3.fromHex("#FF8200")

local Tab = t1.value4.Tab
local value5 = {
	Title = "Main",
	Icon = t1.value6,
	IconColor = t1.value3,
	IconShape = "Circle"
}

t1.value2 = Tab
t1.value5 = value5
t1.value2 = t1.value2(t1.value4, t1.value5)
t21.Auto = t1.value2
t1.value4 = t4.value106
t1.value3 = "\192\223\207lm"
t1.value2 = "Tab"
t1.value6 = v394("globe", "info")

local Tab2 = t1.value4.Tab

t1.value3 = 15598599363679
t1.value2 = Tab2
t1.value3 = Color3.fromHex("#FF8200")
t1.value2 = t1.value2(t1.value4, {
	Title = "Growth",
	Icon = t1.value6,
	IconColor = t1.value3,
	IconShape = "Circle"
})
t21.Expand = t1.value2
t1.value4 = t4.value106
t1.value5 = "Oݞo\149X*U\r\212?\189\f"
t1.value3 = 24051121875903
t1.value6 = v394("flask-conical", "info")
t1.value3 = Color3.fromHex("#FF8200")
t1.value2 = t1.value4:Tab({
	Title = "Auto Research",
	Icon = t1.value6,
	IconColor = t1.value3,
	IconShape = "Circle"
})
t21.Research = t1.value2
t1.value4 = t4.value106
t1.value6 = v394("info")
t1.value5 = Color3.fromHex
t1.value2 = t1.value4.Tab
t1.value3 = t1.value5("#FF8200")

local value52 = {
	Title = "Misc",
	Icon = t1.value6,
	IconColor = t1.value3,
	IconShape = "Circle"
}

t1.value3 = 33832066858378
t1.value5 = value52
t1.value2 = t1.value2(t1.value4, t1.value5)
t21.Misc = t1.value2

function t1.value5(p73)
	if type(p73) ~= "table" then
		return tostring(p73)
	end

	p73 = p73.Title or (p73.Name or p73[1])

	return tostring(p73)
end
function t1.value4(p74, p75, p76)
	return p74:Section({
		Title = p75,
		Icon = v394(p76),
		Box = true,
		BoxBorder = true,
		Opened = true
	})
end
function t1.value3(p77, p78)
	local v427 = nil

	local function v428()
		setclipboard(v427)
	end

	v427 = p78
	pcall(v428)
	t2.value3:Notify({
		Title = p77,
		Content = "Link copied to clipboard!",
		Icon = "check",
		Duration = 2
	})
end
function t1.value2(p79, p80, p81)
	return p79:Section({
		Title = p80,
		Icon = v394(p81),
		Box = true,
		BoxBorder = true,
		Opened = false
	})
end

t4.value107 = t1.value5
t4.value108 = t1.value3
t1.value4(t21.Home, "Ransblox Scripts", "user"):Paragraph({
	Title = "Welcome!",
	Desc = "I make Roblox script showcases on YouTube and run a free script hub. New scripts drop on the channel and the website, so subscribe to catch them first."
})

local v429 = t1.value4(t21.Home, "100% Free Script", "shield-check")

t1.value5 = v429.Paragraph
t1.value7 = {
	Title = "This script is free",
	Desc = "No key system, no payments, no subscription. It was never sold and it never will be."
}
t1.value3 = "\231\231\245\22\241"
t1.value5(v429, t1.value7)
t1.value3 = 8420351299409
t1.value7 = {
	Title = "Found a version with a key? It\'s a scam",
	Desc = "If someone is asking you for a key, money, or to complete tasks to use this script, you\'re looking at a fake copy. Don\'t pay, don\'t enter your info. Only trust the official links below."
}
v429:Paragraph(t1.value7)
t1.value3 = "F\7\179T\14 \245\215\253\\\202Ʊ\175"
t1.value7 = t1.value4(t21.Home, "Official Links", "link"):Group()
t1.value6 = t1.value7.Button

function t1.value5()
	t4.value108("YouTube", t2.value1)
end

t1.value6(t1.value7, {
	Title = "YouTube",
	Desc = "Ransblox Scripts - subscribe for more scripts",
	Icon = "youtube",
	Color = "Red",
	Callback = t1.value5
})
t1.value6 = t1.value7.Button
t1.value6(t1.value7, {
	Title = "Website",
	Desc = "ransblox.net - script hub & request page",
	Icon = "globe",
	Callback = function()
		t4.value108("Website", t2.value2)
	end
})
t1.value6 = t1.value2(t21.Auto, "Auto Build", "cpu")

function t1.value4(p82)
	if not p82 then
		t4.value18(p82 and "Running..." or p82 or "Stopped")

		return
	end

	t4.value27 = {}

	local value29 = t4.value29
	local value292 = t4.value29
	local value293 = t4.value29
	local now = os.clock()

	value29.n = 0
	value292.profit = 0
	value293.t0 = now
	t4.value29.cash0 = t4.value42()
	t4.value19()
	t4.value18(p82 and "Running..." or p82 or "Stopped")
end

t1.value6:Toggle({
	Title = "Auto Build",
	Desc = "Builds the best device you can afford, using the best parts you own.",
	Value = true,
	Callback = t1.value4
})
t1.value5 = t1.value6.Toggle

function t1.value4(p83)
	t4.value15 = p83
end

t1.value5(t1.value6, {
	Title = "Auto Launch",
	Desc = "Launches your device as soon as it\'s finished.",
	Value = true,
	Callback = t1.value4
})
t1.value3 = {
	name = "Always Fresh",
	label = "Always Fresh (no penalty)",
	copy = 0
}
t1.value4 = {
	name = "Balanced",
	label = "Balanced",
	copy = 0.15
}
t4.value109 = {
	t1.value3,
	t1.value4,
	{
		name = "Fast",
		label = "Fast (builds sooner)",
		copy = 0.4
	}
}
t1.value5 = {}
t1.value4 = ipairs

local value109 = t4.value109

for _, v in t1.value4(value109) do
	t1.value3 = #t1.value5 + 1

	local label = v.label

	t1.value5[t1.value3] = label
end

local v438, v439 = t4.value55(t4.value109[2].copy)

t1.value4 = v438
t1.value3 = v439

local v440, v441 = t4.value55(t4.value109[3].copy)

t1.value4 = v440
t1.value6 = v441
t1.value4 = t1.value2(t21.Auto, "Build Strategy", "target")

local format = string.format
local v443 = t1.value3 * 100 + 0.5
local v444 = math.floor(v443)
local v445 = t1.value6 * 100 + 0.5
local v446 = format("Always Fresh: only builds when your device is clearly different from your last one, so there is no similarity penalty, but you wait for new research. Balanced: builds sooner and accepts up to %d%% fewer sales on similar devices. Fast: builds as soon as you can afford it and accepts up to %d%% fewer sales on similar devices.", v444, (math.floor(v445)))

t1.value6 = t4.value109[1]
t1.value3 = t1.value4.Dropdown

local label = t1.value6.label

function t1.value6(p84)
	local v448 = t4.value107(p84)

	for _, v in ipairs(t4.value109) do
		if v448 == v.label or v448:find(v.name, 1, true) then
			local _ = v.copy

			return
		end
	end
end

t1.value3(t1.value4, {
	Title = "Build Strategy",
	Flag = "Strategy",
	Desc = v446,
	Values = t1.value5,
	Value = label,
	Callback = t1.value6
})
t1.value4 = {
	name = "Balanced",
	label = "Balanced (97% of fair price)",
	f = 0.97
}
t4.value110 = {
	{
		name = "Safe",
		label = "Safe (90% of fair price)",
		f = 0.9
	},
	t1.value4,
	{
		name = "Greedy",
		label = "Greedy (105%, risky)",
		f = 1.05
	}
}
t1.value4 = ipairs
t1.value3 = {}

local value110 = t4.value110

for _, v in t1.value4(value110) do
	local v455 = #t1.value3 + 1
	local label2 = v.label

	t1.value3[v455] = label2
end

t1.value4 = t1.value2(t21.Auto, "Pricing", "tag")
t1.value5 = t1.value4.Dropdown

local label2 = t4.value110[1].label

t1.value5(t1.value4, {
	Title = "Pricing",
	Flag = "Pricing",
	Desc = "Sets your price from the game\'s own fair price, using the critic scores of your recent launches. Charging much more than the fair price (around 110% and up) makes sales fade much faster, and charging far less adds few extra buyers. Safe leaves room if the critic score comes in lower than expected; Greedy can cross the 110% line when that happens.",
	Values = t1.value3,
	Value = label2,
	Callback = function(p85)
		local v458 = t4.value107(p85)

		for _, v in ipairs(t4.value110) do
			if v458 == v.label and true or v458:find(v.name, 1, true) then
				local _ = v.f

				return
			end
		end
	end
})
t1.value4 = {}
t4.value111 = {}
t1.value5 = ipairs

local Marketing = t4.value1.Marketing or {}

for _, v in t1.value5(Marketing) do
	local id

	if type(v) == "table" then
		id = v.id
	else
		id = false
	end

	if id then
		local cost = v.cost
		local value6

		if (tonumber(cost) or 0) <= 0 then
			local value1 = t1.value1
			local name = v.name or v.id

			t1.value6 = tostring(name)
			value6 = t1.value6
			t1.value1 = value1
		else
			t1.value6 = string.format

			local name = v.name or v.id

			t1.value3 = tostring(name)

			local value62 = t1.value6
			local value32 = t1.value3
			local hype = v.hype or 1

			value6 = value62("%s (%s× buyers)", value32, (tostring(hype)))
		end

		t1.value6 = t4.value111

		local v474 = #t4.value111 + 1

		t1.value3 = v.id

		local t22 = {
			label = value6,
			id = t1.value3
		}

		t1.value6[v474] = t22
		t1.value6 = #t1.value4 + 1
		t1.value4[t1.value6] = value6
	end
end

if #t4.value111 == 0 then
	t1.value5 = t4.value111
	t1.value5[1] = {
		label = "No marketing",
		id = "none"
	}
	t1.value4[1] = "No marketing"
end

t4.value111[#t4.value111 + 1] = {
	label = "Smart (only if it pays off)",
	id = "best"
}
t1.value4[#t1.value4 + 1] = "Smart (only if it pays off)"

local v476 = t1.value2(t21.Auto, "Marketing", "megaphone")

function t1.value3(p86)
	local v477 = t4.value107(p86)
	local v478, v479, v480 = ipairs(t4.value111)

	while true do
		local v481

		v480, v481 = v478(v479, v480)

		if not v480 then
			break
		end

		if v477 == v481.label then
			local _ = v481.id

			return
		end
	end
end

v476.Dropdown(v476, {
	Title = "Marketing",
	Flag = "Marketing",
	Desc = "Ad campaign used on every launch. More hype = more buyers, but it costs a lot and the price grows every year. Smart only buys an ad when the extra sales should earn its cost back, and keeps enough cash for your next device. If you can\'t afford your pick, a cheaper one is used automatically.",
	Values = t1.value4,
	Value = "Smart (only if it pays off)",
	Callback = t1.value3
})
t4.value112 = {
	{
		label = "Careful (8 weeks)",
		w = 8
	},
	{
		label = "Normal (16 weeks)",
		w = 16
	},
	{
		label = "Bold (30 weeks)",
		w = 30
	}
}

local t23 = {}

for _, v in ipairs(t4.value112) do
	t1.value3 = #t23 + 1

	local label3 = v.label

	t23[t1.value3] = label3
end

t1.value3 = t4.value112[2]
v476.Dropdown(v476, {
	Title = "Ad Payback Window",
	Desc = "Smart marketing only buys an ad if the extra sales earn its cost back within this many weeks. Longer = more ads.",
	Values = t23,
	Value = t1.value3.label,
	Callback = function(p87)
		local v487 = t4.value107(p87)

		for _, v in ipairs(t4.value112) do
			if v487 == v.label then
				local _ = v.w

				return
			end
		end
	end
})

local v491 = t1.value2(t21.Auto, "Status", "activity")
local Paragraph = v491.Paragraph

t1.value6 = {
	Title = "Status",
	Desc = t4.value16
}
t4.value113 = Paragraph(v491, t1.value6)
t4.value114 = v491:Paragraph({
	Title = "Live",
	Desc = "Cash: -- | Year: --"
})
t4.value115 = v491.Paragraph(v491, {
	Title = "Stats",
	Desc = "No launches yet."
})

function t1.value3()
	local v493

	if t4.value29.n > 0 then
		local v494 = (os.clock() - t4.value29.t0) / 60
		local v495 = math.max(v494, 0.1)

		v493 = string.format("Launches: %d | Net profit: %s | %s/min", t4.value29.n, t4.value32(t4.value29.profit), t4.value32(t4.value29.profit / v495))

		local v496 = t4.value42()
		local cash0

		if v496 then
			cash0 = t4.value29.cash0
		else
			cash0 = v496
		end

		if cash0 then
			v493 = v493 .. string.format(" | Cash change: %s/min", t4.value32((v496 - t4.value29.cash0) / v495))
		end
	else
		v493 = "No launches yet."
	end

	pcall(function()
		t4.value115:SetDesc(v493)
	end)
end
function t4.value18(p88)
	local v498 = nil

	local function v499()
		t4.value113:SetDesc(v498)
	end

	v498 = p88
	pcall(v499)
end

t4.value19 = t1.value3
task.spawn(function()
	while t4.value12 do
		task.wait(2)

		local v500 = t4.value42()
		local v501 = t4.value43()
		local format2 = string.format
		local s3 = "Cash: %s | Year: %s"

		if v500 then
			v500 = t4.value32(v500)
		end

		local v504 = v500 or "--"

		if v501 then
			v501 = tostring(v501)
		end

		local v505 = format2(s3, v504, v501 or "--")

		pcall(function()
			t4.value114:SetDesc(v505)
		end)
	end
end)

local v506 = t1.value2(t21.Expand, "Auto Expand", "globe")

t1.value3 = v506.Toggle

function t1.value8(p89)
	t4.value95(p89 and "Running..." or p89 or "Stopped")
end

t1.value3(v506, {
	Title = "Auto Expand",
	Desc = "Expands into new regions as soon as you can afford it, so you can sell to more buyers.",
	Value = false,
	Callback = t1.value8
})

local Dropdown = v506.Dropdown

t1.value10 = 15445602966552
t1.value3 = Dropdown

function t1.value9(p90)
	t4.value94 = t4.value107(p90)
end

t1.value3(v506, {
	Title = "Priority",
	Desc = "Cheapest first expands into whichever region costs the least right now. Best value first expands into whichever gives you the most buyer share per dollar spent.",
	Values = { "Cheapest first", "Best value first" },
	Value = "Cheapest first",
	Callback = t1.value9
})
t1.value3 = v506:Paragraph({
	Title = "Status",
	Desc = "Ready"
})
t4.value116 = t1.value3

function t4.value95(p91)
	pcall(function()
		t4.value116:SetDesc(p91)
	end)
end

t1.value3 = t1.value2(t21.Expand, "Auto Office Upgrade", "building")

local Toggle = t1.value3.Toggle

function t1.value1(p92)
	t4.value104(p92 and "Running..." or p92 or "Stopped")
end

t4.value105 = Toggle(t1.value3, {
	Title = "Auto Office Upgrade",
	Desc = "Checks if you meet the next office\'s requirements (devices launched, sales, cash) and notifies you to tap Move in yourself — it won\'t place your furniture for you.",
	Value = false,
	Callback = t1.value1
})
t1.value1 = t1.value3:Paragraph({
	Title = "Status",
	Desc = "Ready"
})
t4.value117 = t1.value1

function t4.value104(p93)
	local function v509()
		t4.value117:SetDesc(p93)
	end

	pcall(v509)
end

t1.value1 = t1.value2(t21.Research, "Auto Research", "flask-conical")

function t1.value3(p94)
	t4.value86 = p94

	if not p94 then
		return
	end

	t4.value89 = {}
end

local value53 = {
	Title = "Auto Research",
	Desc = "Keeps researching new tech for you, as many at once as the game allows.",
	Value = true,
	Callback = t1.value3
}
local Toggle2 = t1.value1.Toggle

t1.value5 = value53
Toggle2(t1.value1, t1.value5)
t1.value3 = { "Most expensive first", "Cheapest first" }

local Dropdown2 = t1.value1.Dropdown

function t1.value4(p95)
	t4.value107(p95):find("Cheapest")
end

Dropdown2(t1.value1, {
	Title = "Priority",
	Desc = "Most expensive first goes for the priciest tech you can afford, across all categories. Cheapest first unlocks lots of small stuff fast.",
	Values = t1.value3,
	Value = "Most expensive first",
	Callback = t1.value4
})

local v513 = t1.value2(t21.Misc, "Interface", "palette")

t1.value5 = v513.Toggle

function t1.value12(p96)
	t4.value106:ToggleTransparency(p96)
end

t1.value5(v513, {
	Title = "Glass Mode",
	Desc = "Makes the window slightly transparent",
	Value = false,
	Callback = t1.value12
})
t1.value5 = v513.Slider
t1.value12 = {
	Min = 0.7,
	Max = 1.2,
	Default = 1
}

function t1.value13(p97)
	t4.value106:SetUIScale(p97)
end

t1.value5(v513, {
	Title = "UI Scale",
	Desc = "Lower it if the GUI is too big on mobile",
	Step = 0.05,
	Value = t1.value12,
	Callback = t1.value13
})
t1.value5 = v513.Keybind

function t1.value12(p98)
	local ok2, result = pcall(function()
		return Enum.KeyCode[p98]
	end)

	if not (ok2 and result) then
		return
	end

	t4.value106:Toggle()
end

t1.value5(v513, {
	Title = "Toggle GUI",
	Desc = "Key to show/hide the window",
	Value = "RightControl",
	Callback = t1.value12
})
t1.value5 = t1.value2(t21.Misc, "Config", "save")
t1.value8 = t1.value5:Paragraph({
	Title = "Auto-save",
	Desc = "Strategy, Pricing and Marketing are saved automatically whenever you change them, and loaded back next time you join."
})
t4.value118 = t1.value8
t1.value8 = t1.value5:Group()
t1.value9 = t1.value8.Button

function t1.value1()
	if not t4.value106.CurrentConfig then
		return
	end

	local function v516()
		t4.value106.CurrentConfig:Save()
	end

	if pcall(v516) then
		t2.value3:Notify({
			Title = "Config",
			Content = "Settings saved!",
			Icon = "check",
			Duration = 2
		})
		pcall(function()
			t4.value118:SetDesc("Last saved just now.")
		end)

		return
	end

	t2.value3:Notify({
		Title = "Config",
		Content = "Couldn\'t save settings.",
		Icon = "x",
		Duration = 3
	})
end

t1.value9(t1.value8, {
	Title = "Save Now",
	Desc = "Save your current settings",
	Icon = "save",
	Callback = t1.value1
})

function t1.value1()
	if not t4.value106.CurrentConfig then
		return
	end

	local function v517()
		t4.value106.CurrentConfig:Load()
	end

	if pcall(v517) then
		t2.value3:Notify({
			Title = "Config",
			Content = "Settings loaded!",
			Icon = "check",
			Duration = 2
		})

		return
	end

	t2.value3:Notify({
		Title = "Config",
		Content = "No saved settings found.",
		Icon = "x",
		Duration = 3
	})
end

local value1 = {
	Title = "Load Saved",
	Desc = "Load your last saved settings",
	Icon = "upload",
	Callback = t1.value1
}
local Button = t1.value8.Button

t1.value1 = value1
t1.value9 = Button
t1.value9(t1.value8, t1.value1)

function t1.value9()
	if _G.PHONEEMPIRE_Unloaded == t4.value106 then
		return
	end

	_G.PHONEEMPIRE_Unloaded = t4.value106

	for _, v in ipairs(t3.value1) do
		pcall(function()
			v:Disconnect()
		end)
	end

	local function v522()
		t4.value106:Destroy()
	end

	pcall(v522)
	_G.PHONEEMPIRE_Unload = nil
end

t1.value1 = _G
t1.value1.PHONEEMPIRE_Unload = t1.value9
t1.value1 = t1.value2(t21.Misc, "Script", "power")
t1.value3 = {
	Title = "Unload Script",
	Desc = "Removes the GUI and stops everything",
	Icon = "x",
	Callback = t1.value9
}
t1.value10 = "Button"
t1.value1:Button(t1.value3)
t21.Misc:Paragraph({
	Title = "Phone Empire",
	Desc = "Made by Ransblox Scripts • v1.0"
})

local Folder = t4.value106.Folder

if Folder then
	Folder = t4.value106.ConfigManager
end

t1.value10 = Folder

if not t1.value10 then
	return
end

t4.value106.ConfigManager:CreateConfig("default", true)
