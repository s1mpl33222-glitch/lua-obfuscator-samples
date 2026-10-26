-- This file was generated at discord.gg/syncrypt

local t1 = {
	value1 = "3.0.0",
	value2 = "https://sdkapi-public.luarmor.net/library.lua",
	value3 = "https://api.luarmor.net/files/v4/loaders/",
	value4 = "https://api.luarmor.net/files/v3/loaders/"
}
local t2 = {
	{ "LINKVERTISE", "https://ads.luarmor.net/get_key?for=SolsRnglinkvertise-OvJoIJjAfVmj" },
	{ "LOOTLABS", "https://ads.luarmor.net/get_key?for=SolsRngLootlabs-XSbyjfwrEQkQ" }
}

t1.value5 = {
	lite = {
		label = "Sol\'s RNG - Lite",
		short = "Lite",
		script = "868dfff5946732c54bd61960e8aa0fd5",
		key = true,
		keyFile = "XT-HUB/key_sols_lite.txt",
		links = t2,
		desc = "Recommended for farming. Fastest updates, most stable. Needs a strong executor."
	},
	main = {
		label = "Sol\'s RNG - Main",
		short = "Main",
		script = "ba3c21615e99f676108aca3f08d9456a",
		key = true,
		keyFile = "XT-HUB/key_sols_main.txt",
		links = t2,
		desc = "Works on every executor. Fast and smooth, fewer features than Lite."
	},
	steal_an_egg = {
		label = "Steal An Egg",
		short = "EGG",
		script = "f9fd872e9ba378bf843690e9eec983f3",
		desc = "Keyless. Loads automatically in Steal An Egg."
	},
	anime_mysterious = {
		label = "Anime Mysterious",
		short = "MYSTERY",
		script = "81cdfb42882e51308614b01cac764a00",
		desc = "Keyless. Loads automatically in Anime Mysterious."
	},
	anime_adventures = {
		label = "Anime Adventures",
		short = "AA",
		script = "89fe29c39989b1dc87ec35c15b7a3dff",
		desc = "Keyless. Loads automatically in Anime Adventures."
	}
}

local t3 = {
	"lite",
	"main",
	"steal_an_egg",
	"anime_mysterious",
	"anime_adventures"
}
local t4 = {
	[3183403065] = { "anime_adventures" },
	[5361032378] = { "lite", "main" },
	[10116272705] = { "anime_mysterious" },
	[10563114921] = { "steal_an_egg" }
}

t1.value6 = {
	lastVersion = "XT-HUB/pref_game.txt"
}
t1.value7 = {
	KEY_INCORRECT = true,
	KEY_INVALID = true,
	KEY_EXPIRED = true,
	KEY_BANNED = true
}
t1.value8 = {
	TIME_ERROR = true,
	UNKNOWN_ERROR = true,
	SECURITY_ERROR = true
}
t1.value9 = {
	KEY_INCORRECT = "Key not found. Check it, or get a new key below.",
	KEY_INVALID = "That is not a valid key. Copy the full 32-letter key.",
	KEY_EXPIRED = "This key has expired. Get a new key below.",
	KEY_BANNED = "This key has been blacklisted.",
	KEY_HWID_LOCKED = "This key is locked to another device. Reset your HWID in our Discord (/resethwid), then try again.",
	SCRIPT_ID_INCORRECT = "This script is unavailable right now. Please report it to XT-HUB.",
	SCRIPT_ID_INVALID = "This script is unavailable right now. Please report it to XT-HUB.",
	INVALID_EXECUTOR = "Luarmor does not support this executor.",
	SECURITY_ERROR = "Luarmor blocked the request (security check). Try again, or switch network.",
	TIME_ERROR = "Your device clock is wrong. Turn on automatic date & time, then retry.",
	UNKNOWN_ERROR = "Luarmor is restarting or having an outage. Retry in a moment."
}

if not game:IsLoaded() then
	game.Loaded:Wait()
end

local Players = game:GetService("Players")

t1.value10 = game:GetService("HttpService")
t1.value11 = game:GetService("TweenService")

local UserInputService = game:GetService("UserInputService")

t1.value12 = Players.LocalPlayer

while not t1.value12 do
	task.wait(0.2)
	t1.value12 = Players.LocalPlayer
end

local genv

if type(getgenv) == "function" then
	genv = getgenv()
else
	genv = false
end

t1.value13 = genv or _G

local env

if type(getfenv) == "function" then
	env = getfenv()
else
	env = false
end

t1.value14 = env or _G
t1.value15 = os.clock()

function t1.value16(p1)
	local v9 = nil

	for i, part in ipairs(string.split(p1, ".")) do
		if i == 1 then
			v9 = t1.value13[part]

			if v9 == nil then
				v9 = t1.value14[part]
			end
		else
			if type(v9) ~= "table" then
				return nil
			end

			v9 = v9[part]
		end

		if v9 == nil then
			return nil
		end
	end

	return v9
end
function t1.value17(...)
	for _, v in ipairs({ ... }) do
		local ok, result = pcall(t1.value16, v)

		if ok then
			ok = type(result) == "function"
		end

		if ok then
			return result
		end
	end

	return nil
end

t1.value18 = {
	request = t1.value17("request", "http_request", "syn.request", "http.request", "fluxus.request"),
	readfile = t1.value17("readfile"),
	writefile = t1.value17("writefile"),
	isfile = t1.value17("isfile"),
	delfile = t1.value17("delfile"),
	isfolder = t1.value17("isfolder"),
	makefolder = t1.value17("makefolder"),
	clipboard = t1.value17("setclipboard", "toclipboard", "set_clipboard", "Clipboard.set", "syn.write_clipboard"),
	gethui = t1.value17("gethui", "get_hidden_gui"),
	protectGui = t1.value17("syn.protect_gui", "protectgui"),
	identify = t1.value17("identifyexecutor", "getexecutorname"),
	loadstring = t1.value17("loadstring")
}
t1.value19 = nil
t1.value19 = "Unknown executor"
pcall(function()
	if not t1.value18.identify then
		return
	end

	local v16, v17 = t1.value18.identify()

	if not v16 then
		return
	end

	local v18 = tostring(v16)

	if v17 then
		v17 = " " .. tostring(v17)
	end

	t1.value19 = v18 .. v17 or ""
end)

local value13 = t1.value13
local __XTLDR_RUN = t1.value13.__XTLDR_RUN

value13.__XTLDR_RUN = (tonumber(__XTLDR_RUN) or 0) + 1
t1.value20 = t1.value13.__XTLDR_RUN
t1.value21 = {
	build = t1.value1,
	executor = t1.value19,
	log = {}
}
t1.value13.__XTLDR = t1.value21

function t1.value22(p2)
	local v21 = string.format("[XT-HUB %s] %.1fs %s", t1.value1, os.clock() - t1.value15, p2)
	local log = t1.value21.log

	table.insert(log, v21)

	if not (#t1.value21.log > 80) then
		print(v21)

		return
	end

	table.remove(t1.value21.log, 1)
	print(v21)
end

for _, v in ipairs({
	{ "XTHUB_AuthExpire", nil },
	{ "XTHUB_KeyIsLifetime", false },
	{ "XTHUB_KeyExpiryKnown", false },
	{ "XTHUB_KeyExpiryState", "unknown" }
}) do
	pcall(function()
		local v25 = v[1]

		t1.value13[v25] = v[2]
	end)
	pcall(function()
		_G[v[1]] = v[2]
	end)
end

function t1.value23(p3, p4, ...)
	local v26 = table.pack(...)
	local t5 = {}

	task.spawn(function()
		local v28 = t5
		local pack = table.pack
		local pcall_ = pcall
		local v31 = p4
		local v32 = v26
		local v33 = v26.n

		v28.result = pack(pcall_(v31, table.unpack(v32, 1, v33)))
	end)

	local v34 = os.clock() + p3

	while not t5.result do
		if v34 <= os.clock() then
			return false, "timed out after " .. p3 .. "s"
		end

		task.wait(0.05)
	end

	return table.unpack(t5.result, 1, t5.result.n)
end
function t1.value24(p5)
	local v35

	if type(p5) == "string" then
		v35 = p5:match("^%s*<") ~= nil
	else
		v35 = false
	end

	return v35
end
function t1.value25(p6)
	local v36

	if type(p6) == "string" then
		v36 = p6:match("^%s*[%[{]") ~= nil
	else
		v36 = false
	end

	return v36
end
function t1.value26(p7)
	local v37 = tostring(p7)
	local v38 = v37:lower()

	if v38:find("ssl") or (v38:find("tls") or (v38:find("certificate") or v38:find("handshake"))) then
		return v37 .. " - update your executor and turn on automatic date & time."
	else
		return v37
	end
end
function t1.value27(p8, p9, p10, p11)
	local n1 = 1
	local v40 = n1 < 0
	local v41 = 1 - n1
	local v42 = p10
	local s1 = "no response"

	while true do
		v41 = n1 + v41

		local v44 = v41 <= p10

		if (not v40 or p10 > v41) and (v40 or not v44) then
			break
		end

		local v45, v46 = t1.value23(15, function()
			local ok, result = pcall(function()
				return game:HttpGet(p8)
			end)
			local v49

			if ok then
				if type(result) == "string" then
					v49 = result ~= ""
				else
					v49 = false
				end
			else
				v49 = ok
			end

			if v49 then
				return result
			end

			local request = p11

			if request then
				request = t1.value18.request
			end

			if not request then
				error(ok and "empty response" or ok or result, 0)

				return
			end

			local v51 = t1.value18.request({
				Url = p8,
				Method = "GET"
			})
			local v52 = type(v51) == "table"

			if not v52 then
				if v52 then
					return v51.Body
				else
					error(ok and "empty response" or ok or result, 0)
				end

				return
			end

			local Body = v51.Body

			if type(Body) == "string" then
				v52 = v51.Body ~= ""
			else
				v52 = false
			end

			if v52 then
				return v51.Body
			else
				error(ok and "empty response" or ok or result, 0)
			end
		end)
		local v54

		if v45 then
			v54 = not t1.value24(v46)
		else
			v54 = v45
		end

		if v54 then
			return v46
		end

		s1 = v45 and "server returned a web page instead of a script" or tostring(v46)
		t1.value22(p9 .. " attempt " .. v41 .. "/" .. v42 .. " failed: " .. s1)

		if v41 < v42 then
			task.wait(v41 * 0.75)
		end
	end

	return nil, t1.value26(s1)
end

t1.value28 = {}
t1.value29 = {}
t1.value30 = nil

function t1.value30(p12)
	return p12:match("^(https?://[^/]+/)")
end
function t1.value31(p13)
	if not t1.value18.request then
		error("this executor has no HTTP request function", 0)
	end

	local v55 = table.clone(p13)
	local Url = v55.Url
	local url = tostring(Url)
	local v58 = url:find("check_key?", 1, true) ~= nil
	local v59

	if v58 then
		v59 = t1.value30(url)
	else
		v59 = v58
	end

	local v60

	if v59 then
		v60 = t1.value29[v59]
	else
		v60 = v59
	end

	local ipairs_

	if v60 then
		ipairs_ = ipairs

		for _, v in ipairs_(t1.value28) do
			if not t1.value29[v] then
				url = v .. url:sub(#v59 + 1)
				v59 = v
				ipairs_ = url

				break
			end
		end

		v55.Url = url
	else
		ipairs_ = v58
	end

	local v64, v65 = t1.value23(v58 and 10 or 8, t1.value18.request, v55)
	local v66

	if v64 then
		if type(v65) == "table" then
			v66 = t1.value25(v65.Body)
		else
			v66 = false
		end
	else
		v66 = v64
	end

	if not v66 then
		if v59 then
			t1.value29[v59] = true
		end

		if v64 then
			local s2 = "bad reply (HTTP "
			local tostring_ = tostring
			local StatusCode

			if type(v65) == "table" then
				StatusCode = v65.StatusCode
			else
				StatusCode = false
			end

			v64 = s2 .. tostring_(StatusCode or "?") .. ")"
		end

		local v70 = v64 or tostring(v65)
		local value22 = t1.value22

		if not v58 then
			value22((v58 or "luarmor sync") .. " failed: " .. v70)
			error(v70, 0)

			return
		end

		v58 = "auth node " .. tostring(v59)
		value22((v58 or "luarmor sync") .. " failed: " .. v70)
		error(v70, 0)

		return
	end

	if v58 then
		return v65
	end

	local function v72()
		local data = t1.value10:JSONDecode(v65.Body)
		local v74

		if type(data.nodes) == "table" then
			v74 = #data.nodes > 0
		else
			v74 = false
		end

		if not v74 then
			return
		end

		local _ = data.nodes
	end

	pcall(v72)

	return v65
end

t1.value32 = nil
t1.value33 = nil

function t1.value34(p14)
	if not t1.value18.loadstring then
		return nil, "This executor has no loadstring."
	end

	if not t1.value18.request then
		return nil, "This executor has no HTTP request function, so the key can\'t be pre-checked."
	end

	local __XTLDR_SDK_SRC = t1.value13.__XTLDR_SDK_SRC

	if type(__XTLDR_SDK_SRC) ~= "string" then
		if p14 then
			p14("sdk")
		end

		local v77

		__XTLDR_SDK_SRC, v77 = t1.value27(t1.value2, "SDK download", 3, true)

		if not __XTLDR_SDK_SRC then
			return nil, "Couldn\'t download the Luarmor SDK: " .. v77
		end
	end

	local v78, v79 = t1.value18.loadstring(__XTLDR_SDK_SRC)

	if type(v78) ~= "function" then
		t1.value13.__XTLDR_SDK_SRC = nil

		return nil, "Luarmor SDK failed to compile: " .. tostring(v79)
	end

	local function v80()
		setfenv(v78, (setmetatable({
			syn = false,
			request = t1.value31,
			http_request = t1.value31
		}, {
			__index = function(_, p15)
				local v81 = t1.value13[p15]

				if v81 ~= nil then
					return v81
				end

				v81 = t1.value14[p15]

				return v81
			end
		})))
	end

	if pcall(v80) then
		v93, v94 = t1.value23(10, v78)

		if not v93 or v94 == nil then
			return nil, "Luarmor SDK failed to start: " .. tostring(v94)
		else
			t1.value13.__XTLDR_SDK_SRC = __XTLDR_SDK_SRC

			return v94
		end
	end

	t1.value22("setfenv unavailable; SDK runs without node failover")

	local v82, v83 = t1.value23(10, v78)

	if not v82 or v83 == nil then
		return nil, "Luarmor SDK failed to start: " .. tostring(v83)
	else
		t1.value13.__XTLDR_SDK_SRC = __XTLDR_SDK_SRC

		return v83
	end
end

t1.value35 = nil

function t1.value35(p16)
	if t1.value32 then
		return t1.value32
	else
		while t1.value33 do
			task.wait(0.05)
		end

		if t1.value32 then
			return t1.value32
		else
			local ok, result, result2 = pcall(t1.value34, p16)

			if ok then
				return result, result2
			else
				return nil, "Luarmor SDK error: " .. tostring(result)
			end
		end
	end
end
function t1.value36(p17, p18, p19)
	local v87, v88 = t1.value35(p19)

	if not v87 then
		return {
			kind = "retry",
			message = v88
		}
	end

	local t6 = {
		kind = "retry",
		message = "no reply from Luarmor"
	}

	for i = 1, 3 do
		local s3 = "verify"
		local v92

		if i > 1 then
			v92 = "retry " .. i .. "/3" or nil
		else
			v92 = nil
		end

		p19(s3, v92)

		local v95, v96 = t1.value23(25, function()
			v87.script_id = p17.script

			return v87.check_key(p18)
		end)

		if v95 then
			if type(v96) == "table" then
				local code = v96.code

				v95 = type(code) == "string"
			else
				v95 = false
			end
		end

		if v95 then
			t1.value22("check_key -> " .. v96.code)

			if v96.code == "KEY_VALID" then
				return {
					kind = "valid",
					code = v96.code
				}
			end

			local v97 = t1.value9[v96.code]

			if not v97 then
				local message = v96.message or v96.code

				v97 = tostring(message)
			end

			if not t1.value8[v96.code] then
				return {
					kind = "rejected",
					code = v96.code,
					message = v97
				}
			end

			t6 = {
				kind = "retry",
				code = v96.code,
				message = v97
			}
		else
			t1.value22("check_key attempt " .. i .. " failed: " .. tostring(v96))
			t6 = {
				kind = "retry",
				message = "Couldn\'t reach Luarmor: " .. t1.value26(v96)
			}
		end

		if i < 3 then
			task.wait(i * 0.75)
		end
	end

	return t6
end

t1.value37 = nil

function t1.value37(p20)
	return p20:gsub("[/\\]", "_")
end

local function v98(p21)
	for _, v in ipairs({ p21, t1.value37(p21) }) do
		local function v101()
			local isfile = t1.value18.isfile

			if isfile then
			elseif isfile then
				return nil
			else
				return t1.value18.readfile(v)
			end

			isfile = not t1.value18.isfile(v)

			if isfile then
				return nil
			else
				return t1.value18.readfile(v)
			end
		end

		local ok, result = pcall(v101)

		if ok then
			ok = type(result) == "string"
		end

		if ok then
			local match = result:match("^%s*(.-)%s*$")

			if match ~= "" then
				return match
			end
		end
	end

	return nil
end
local function v106(p22, p23)
	if not t1.value18.writefile then
		return
	end

	local function v107()
		local makefolder = t1.value18.makefolder

		if makefolder then
			local isfolder = t1.value18.isfolder

			if isfolder then
				isfolder = t1.value18.isfolder("XT-HUB")
			end

			makefolder = not isfolder
		end

		if not makefolder then
			return
		end

		t1.value18.makefolder("XT-HUB")
	end

	pcall(v107)

	if not (not pcall(t1.value18.writefile, p22, p23) or v98(p22) ~= p23) then
		return
	end

	pcall(t1.value18.writefile, t1.value37(p22), p23)
end

function t1.value38(p24)
	for _, v in ipairs({ p24, t1.value37(p24) }) do
		local function v112()
			local isfile = t1.value18.isfile

			if isfile then
				isfile = not t1.value18.isfile(v)
			end

			if isfile then
				return
			end

			if t1.value18.delfile then
				t1.value18.delfile(v)

				return
			end

			if not t1.value18.writefile then
				return
			end

			t1.value18.writefile(v, "")
		end

		pcall(v112)
	end
end
function t1.value39(p25)
	local v114 = tostring(p25 or "")

	return (v114:match("script_key%s*=%s*[\"\']([^\"\']+)[\"\']") or v114):gsub("[%s\"\';]", "")
end
function t1.value40(p26)
	local v115

	if #p26 == 32 then
		v115 = p26:match("^%a+$") ~= nil
	else
		v115 = false
	end

	return v115
end
function t1.value41(p27)
	local function v116()
		t1.value13.script_key = p27
	end

	pcall(v116)
	pcall(function()
		_G.script_key = p27
	end)

	local function v117()
		t1.value14.script_key = p27
	end

	pcall(v117)
end
function t1.value42(p28, p29)
	local keyFile = p28.keyFile

	if keyFile then
		keyFile = v98(p28.keyFile) == p29
	end

	if keyFile then
		t1.value38(p28.keyFile)
	end

	local function v119()
		local __XTLDR_SESSION = t1.value13.__XTLDR_SESSION
		local v121

		if type(__XTLDR_SESSION) == "table" then
			v121 = __XTLDR_SESSION.k == p29
		else
			v121 = false
		end

		if not v121 then
			return
		end

		t1.value13.__XTLDR_SESSION = nil
	end

	pcall(v119)

	for _, v in ipairs({ t1.value13, _G, t1.value14 }) do
		pcall(function()
			if v.script_key ~= p29 then
				return
			end

			v.script_key = nil
		end)
	end
end
function t1.value43()
	local Character = t1.value12.Character
	local v125 = Character ~= nil

	if not v125 then
		return v125
	end

	v125 = Character.Parent ~= nil

	if not v125 then
		return v125
	end

	if Character:FindFirstChildOfClass("Humanoid") == nil then
		v125 = false
	else
		v125 = Character.PrimaryPart or Character:FindFirstChild("HumanoidRootPart") ~= nil
	end

	return v125
end

t1.value44 = {
	steal_an_egg = function()
		local GameId = game.GameId

		if tonumber(GameId) ~= 10563114921 then
			return
		end

		local getgc = t1.value17("getgc")
		local getrawmetatable = t1.value17("getrawmetatable")

		if not (getgc and getrawmetatable) then
			return
		end

		local next_ = next
		local v130, key = getgc(true)
		local _ = next_

		while true do
			local v133

			key, v133 = next_(v130, key)

			if not key then
				return
			end

			if typeof(v133) == "table" and not getrawmetatable(v133) then
				local next_2 = next
				local v135 = v133
				local key2 = nil
				local v137 = false

				while true do
					local v138

					key2, v138 = next_2(v133, key2)

					if not key2 then
						break
					end

					if v138 == v135 then
						v137 = true

						break
					end
				end

				if v137 then
					local next_3 = next
					local v140 = v135
					local key3 = nil

					while true do
						local v142

						key3, v142 = next_3(v135, key3)

						if not key3 then
							break
						end

						local v143 = typeof(v142) == "number"

						if v143 then
							v143 = v142 >= 1

							if v143 then
								if v142 <= 3 then
									v143 = v140[v142] == nil
								else
									v143 = false
								end
							end
						end

						if v143 then
							setmetatable(v140, {
								__newindex = function() end
							})

							break
						end
					end
				end
			end
		end
	end
}

function t1.value45(p30, p31, p32, p33)
	local v144 = t1.value5[p30]

	if not t1.value18.loadstring then
		return false, "This executor has no loadstring."
	end

	local ok, result

	if t1.value43() then
		p32("download")
		v174, v175 = t1.value27(t1.value3 .. v144.script .. ".lua", "V4 loader", 3, false)

		if not v174 then
			t1.value22("V4 loader unavailable, trying V3")
			p32("download", "trying backup server")
			v174, v175 = t1.value27(t1.value4 .. v144.script .. ".lua", "V3 loader", 2, false)
		end

		if not v174 then
			return false, "Couldn\'t download the script: " .. v175
		end

		v176, v177 = t1.value18.loadstring(v174)

		if type(v176) ~= "function" then
			return false, "The script failed to compile: " .. tostring(v177)
		end

		if p33() then
			return false, "cancelled"
		end

		p32("start")

		if t1.value44[p30] then
			ok, result = pcall(t1.value44[p30])

			if not ok then
				t1.value22("pre-launch hook failed: " .. tostring(result))
			end
		end

		if not v144.key then
			t1.value13.__XTLDR_SESSION = {
				v = p30,
				k = v144.key and p31 or ""
			}
			v106(t1.value6.lastVersion, p30)
			t1.value22("starting " .. p30)

			if t1.value13.XTLDR_DRY_RUN then
				t1.value22("dry run - protected chunk not started")
			else
				task.spawn(v176)
			end

			return true
		end

		t1.value41(p31)
		t1.value13.__XTLDR_SESSION = {
			v = p30,
			k = v144.key and p31 or ""
		}
		v106(t1.value6.lastVersion, p30)
		t1.value22("starting " .. p30)

		if t1.value13.XTLDR_DRY_RUN then
			t1.value22("dry run - protected chunk not started")
		else
			task.spawn(v176)
		end

		return true
	end

	p32("character")

	local v147 = os.clock() + 10

	while true do
		local v148 = not t1.value43()

		if v148 then
			v148 = os.clock() < v147
		end

		if not v148 then
			break
		end

		task.wait(0.2)
	end

	p32("download")

	local v149, v150 = t1.value27(t1.value3 .. v144.script .. ".lua", "V4 loader", 3, false)

	if not v149 then
		t1.value22("V4 loader unavailable, trying V3")
		p32("download", "trying backup server")
		v149, v150 = t1.value27(t1.value4 .. v144.script .. ".lua", "V3 loader", 2, false)
	end

	if not v149 then
		return false, "Couldn\'t download the script: " .. v150
	end

	local v151, v152 = t1.value18.loadstring(v149)

	if type(v151) ~= "function" then
		return false, "The script failed to compile: " .. tostring(v152)
	end

	if p33() then
		return false, "cancelled"
	end

	p32("start")

	if t1.value44[p30] then
		ok, result = pcall(t1.value44[p30])

		if not ok then
			t1.value22("pre-launch hook failed: " .. tostring(result))
		end
	end

	if not v144.key then
		t1.value13.__XTLDR_SESSION = {
			v = p30,
			k = v144.key and p31 or ""
		}
		v106(t1.value6.lastVersion, p30)
		t1.value22("starting " .. p30)

		if t1.value13.XTLDR_DRY_RUN then
			t1.value22("dry run - protected chunk not started")
		else
			task.spawn(v151)
		end

		return true
	end

	t1.value41(p31)
	t1.value13.__XTLDR_SESSION = {
		v = p30,
		k = v144.key and p31 or ""
	}
	v106(t1.value6.lastVersion, p30)
	t1.value22("starting " .. p30)

	if t1.value13.XTLDR_DRY_RUN then
		t1.value22("dry run - protected chunk not started")
	else
		task.spawn(v151)
	end

	return true
end

local GameId = game.GameId

t1.value46 = t4[tonumber(GameId)] or t3
t1.value47 = {}

for _, v in ipairs(t1.value46) do
	t1.value47[v] = true
end

local value21 = t1.value21
local value212 = t1.value21
local GameId2 = game.GameId
local value46 = t1.value46

value21.gameId = GameId2
value212.allowed = value46

local v160 = t1.value46[1]
local v161 = v98(t1.value6.lastVersion)
local __XTLDR_SESSION = t1.value13.__XTLDR_SESSION
local v163

if type(__XTLDR_SESSION) == "table" then
	v163 = t1.value47[__XTLDR_SESSION.v]
else
	v163 = false
end

if v163 then
	v161 = __XTLDR_SESSION.v
else
	local v164

	if v161 then
		v164 = t1.value47[v161]
	else
		v164 = v161
	end

	if not v164 then
		v161 = v160
	end
end

function t1.value48(p34)
	local v165 = t1.value5[p34]

	if not v165.key then
		return ""
	end

	local v166, v167, v168 = ipairs({ t1.value13, _G, t1.value14 })
	local s4 = ""

	while true do
		local v170

		v168, v170 = v166(v167, v168)

		if not v168 then
			break
		end

		local ok, result = pcall(function()
			return v170.script_key
		end)

		if ok then
			if type(result) == "string" then
				ok = t1.value39(result) ~= ""
			else
				ok = false
			end
		end

		if ok then
			s4 = t1.value39(result)

			break
		end
	end

	if s4 ~= "" then
		return s4
	end

	local __XTLDR_SESSION2 = t1.value13.__XTLDR_SESSION
	local v178 = type(__XTLDR_SESSION2) == "table"

	if not v178 then
		return not v178 and (v98(v165.keyFile) or "") or __XTLDR_SESSION2.k
	end

	v178 = __XTLDR_SESSION2.v == p34

	if not v178 then
		return not v178 and (v98(v165.keyFile) or "") or __XTLDR_SESSION2.k
	end

	local k = __XTLDR_SESSION2.k

	if type(k) == "string" then
		v178 = __XTLDR_SESSION2.k ~= ""
	else
		v178 = false
	end

	return not v178 and (v98(v165.keyFile) or "") or __XTLDR_SESSION2.k
end

local RunService = game:GetService("RunService")

t1.value49 = {
	Backdrop = Color3.fromRGB(0, 0, 0),
	Bg = Color3.fromRGB(13, 13, 19),
	Card = Color3.fromRGB(21, 21, 31),
	Field = Color3.fromRGB(29, 29, 42),
	Hover = Color3.fromRGB(38, 38, 55),
	Stroke = Color3.fromRGB(42, 42, 60),
	Text = Color3.fromRGB(236, 236, 246),
	Dim = Color3.fromRGB(140, 140, 168),
	Faint = Color3.fromRGB(88, 88, 112),
	Accent = Color3.fromRGB(255, 106, 162),
	AccentHi = Color3.fromRGB(255, 132, 180),
	Good = Color3.fromRGB(110, 220, 150),
	Warn = Color3.fromRGB(240, 190, 80),
	Bad = Color3.fromRGB(245, 105, 105),
	White = Color3.new(1, 1, 1)
}
t1.value50 = {
	x = "rbxassetid://10747384394",
	checkCircle = "rbxassetid://10709790387",
	xCircle = "rbxassetid://10747383819",
	circle = "rbxassetid://10709798174",
	loader = "rbxassetid://10723433935",
	key = "rbxassetid://10723416652",
	refresh = "rbxassetid://10734933222",
	external = "rbxassetid://10723346684",
	back = "rbxassetid://10709768114",
	alert = "rbxassetid://10709753149",
	info = "rbxassetid://10723415903"
}
t1.value51 = {
	connect = "Connect",
	verify = "Check key",
	character = "Character",
	download = "Download",
	start = "Start"
}
t1.value52 = {
	connect = "Connecting to Luarmor",
	verify = "Checking your key with Luarmor",
	character = "Waiting for your character to spawn",
	download = "Downloading the script",
	start = "Starting XT-HUB"
}
t1.value53 = 520
task.spawn(function()
	local t7 = {}

	for _, v in pairs(t1.value50) do
		local ImageLabel = Instance.new("ImageLabel")

		ImageLabel.Image = v
		t7[#t7 + 1] = ImageLabel
	end

	pcall(function()
		game:GetService("ContentProvider"):PreloadAsync(t7)
	end)
end)
t1.value54 = {
	Bold = Font.fromEnum(Enum.Font.GothamBold),
	Med = Font.fromEnum(Enum.Font.GothamMedium),
	Body = Font.fromEnum(Enum.Font.Gotham)
}
t1.value55 = nil

function t1.value55(p35, p36)
	local instance = Instance.new(p35)
	local Parent = p36.Parent

	p36.Parent = nil

	if not instance:IsA("GuiBase2d") then
		for k, v in pairs(p36) do
			instance[k] = v
		end

		if not Parent then
			return instance
		end

		instance.Parent = Parent

		return instance
	end

	instance.AutoLocalize = false

	for k, v in pairs(p36) do
		instance[k] = v
	end

	if not Parent then
		return instance
	end

	instance.Parent = Parent

	return instance
end
function t1.value56(p37, p38, p39, p40, p41)
	local tween = t1.value11:Create(p37, TweenInfo.new(p39 or 0.18, p40 or Enum.EasingStyle.Quint, p41 or Enum.EasingDirection.Out), p38)

	tween:Play()

	return tween
end
function t1.value57(p42, p43)
	t1.value55("UICorner", {
		CornerRadius = UDim.new(0, p43),
		Parent = p42
	})
end

local function v188(p44, p45, p46, p47)
	local v189 = p47 or {}

	v189.Padding = UDim.new(0, p45)
	v189.SortOrder = Enum.SortOrder.LayoutOrder

	local s5 = "FillDirection"

	if not p46 then
		v189[s5] = p46 or Enum.FillDirection.Vertical
		v189.Parent = p44

		return t1.value55("UIListLayout", v189)
	end

	p46 = Enum.FillDirection.Horizontal
	v189[s5] = p46 or Enum.FillDirection.Vertical
	v189.Parent = p44

	return t1.value55("UIListLayout", v189)
end

function t1.value58(p48)
	p48.BackgroundTransparency = 1
	p48.TextXAlignment = p48.TextXAlignment or Enum.TextXAlignment.Left
	p48.FontFace = p48.FontFace or t1.value54.Body
	p48.TextColor3 = p48.TextColor3 or t1.value49.Text

	return t1.value55("TextLabel", p48)
end
function t1.value59(p49, p50, p51, p52, p53)
	local v191 = p53 or {}

	v191.Image = t1.value50[p50]
	v191.Size = UDim2.new(0, p51, 0, p51)
	v191.BackgroundTransparency = 1
	v191.ImageColor3 = p52
	v191.Parent = p49

	return t1.value55("ImageLabel", v191)
end

local function v192(p54, p55)
	p55.BackgroundTransparency = p55.BackgroundTransparency or (p55.BackgroundColor3 and 0 or 1)
	p55.BorderSizePixel = 0
	p55.Parent = p54

	return t1.value55("Frame", p55)
end

t1.value60 = nil

function t1.value60(p56)
	return p56.UserInputType == Enum.UserInputType.MouseButton1 and true or p56.UserInputType == Enum.UserInputType.Touch
end
function t1.value61(p57)
	local UIScale = t1.value55("UIScale", {
		Parent = p57
	})

	p57.InputBegan:Connect(function(input)
		if not t1.value60(input) then
			return
		end

		t1.value56(UIScale, {
			Scale = 0.97
		}, 0.08)
	end)
	p57.InputEnded:Connect(function(input)
		if not t1.value60(input) then
			return
		end

		t1.value56(UIScale, {
			Scale = 1
		}, 0.18)
	end)

	return p57
end

t1.value62 = {
	primary = {
		bg = t1.value49.Accent,
		hover = t1.value49.AccentHi,
		text = t1.value49.White,
		font = t1.value54.Bold,
		size = 14
	},
	soft = {
		bg = t1.value49.Field,
		hover = t1.value49.Hover,
		text = t1.value49.Text,
		font = t1.value54.Med,
		size = 13
	},
	text = {
		text = t1.value49.Dim,
		font = t1.value54.Med,
		size = 12
	}
}
t1.value63 = {
	error = {
		color = t1.value49.Bad,
		icon = "xCircle"
	},
	warn = {
		color = t1.value49.Warn,
		icon = "alert"
	},
	success = {
		color = t1.value49.Good,
		icon = "checkCircle"
	},
	info = {
		color = t1.value49.Dim,
		icon = "info"
	}
}

local function v194(p58, p59)
	local v195 = v192(p58, {
		Size = UDim2.new(1, 0, 0, 0),
		AutomaticSize = Enum.AutomaticSize.Y,
		LayoutOrder = p59,
		Visible = false
	})
	local v196 = t1.value59(v195, "info", 15, t1.value49.Dim)
	local v197 = t1.value58({
		Text = "",
		TextSize = 12,
		TextWrapped = true,
		TextYAlignment = Enum.TextYAlignment.Top,
		LineHeight = 1.15,
		Position = UDim2.new(0, 23, 0, 1),
		Size = UDim2.new(1, -23, 0, 0),
		AutomaticSize = Enum.AutomaticSize.Y,
		Parent = v195
	})
	local v199 = nil

	local function set(p60, p61)
		local v201 = t1.value63[p60]
		local v202 = v196
		local v203 = v196
		local color = v201.color
		local v205 = t1.value50[v201.icon]

		v202.ImageColor3 = color
		v203.Image = v205

		local v206 = v199
		local v207 = v199
		local Dim

		if p60 == "info" then
			Dim = t1.value49.Dim
		else
			Dim = false
		end

		local color2 = Dim or v201.color

		v206.Text = p61
		v207.TextColor3 = color2
		v195.Visible = true
	end

	v199 = v197

	local t8 = {
		set = set
	}

	function t8.hide()
		v195.Visible = false
	end

	return t8
end

local t9 = {
	LINKVERTISE = "Linkvertise",
	LOOTLABS = "Lootlabs"
}

local function v211(p62, p63)
	return t1.value55("UIStroke", {
		Color = p63,
		Thickness = 1,
		ApplyStrokeMode = Enum.ApplyStrokeMode.Border,
		Parent = p62
	})
end
local function v212(p64, p65, p66, p67, p68)
	t1.value55("UIPadding", {
		PaddingTop = UDim.new(0, p65),
		PaddingRight = UDim.new(0, p66 or p65),
		PaddingBottom = UDim.new(0, p67 or p65),
		PaddingLeft = UDim.new(0, p68 or (p66 or p65)),
		Parent = p64
	})
end
local function v213(p69, p70, p71, p72, p73)
	local v214 = p73 or {}
	local v215 = t1.value62[p70]

	v214.Text = ""
	v214.AutoButtonColor = false
	v214.BorderSizePixel = 0
	v214.BackgroundColor3 = v215.bg or t1.value49.Bg
	v214.BackgroundTransparency = v215.bg and 0 or 1
	v214.Parent = p69

	local TextButton = t1.value55("TextButton", v214)

	t1.value57(TextButton, 8)

	local v217 = v192(TextButton, {
		AnchorPoint = Vector2.new(0.5, 0.5),
		Position = UDim2.fromScale(0.5, 0.5),
		Size = UDim2.new(0, 0, 1, 0),
		AutomaticSize = Enum.AutomaticSize.X
	})

	v188(v217, 7, true, {
		VerticalAlignment = Enum.VerticalAlignment.Center
	})

	local v218

	if p72 then
		v218 = t1.value59(v217, p72, 15, v215.text, {
			LayoutOrder = 1
		}) or nil
	else
		v218 = nil
	end

	local v219 = t1.value58({
		Text = p71,
		FontFace = v215.font,
		TextSize = v215.size,
		TextColor3 = v215.text,
		Size = UDim2.new(0, 0, 1, 0),
		AutomaticSize = Enum.AutomaticSize.X,
		LayoutOrder = 2,
		Parent = v217
	})

	if v215.hover then
		TextButton.MouseEnter:Connect(function()
			t1.value56(TextButton, {
				BackgroundColor3 = v215.hover
			})
		end)
		TextButton.MouseLeave:Connect(function()
			t1.value56(TextButton, {
				BackgroundColor3 = v215.bg
			}, 0.32)
		end)
	else
		TextButton.MouseEnter:Connect(function()
			t1.value56(v219, {
				TextColor3 = t1.value49.Text
			})
		end)
		TextButton.MouseLeave:Connect(function()
			t1.value56(v219, {
				TextColor3 = v215.text
			}, 0.32)
		end)
	end

	t1.value61(TextButton)

	return {
		button = TextButton,
		label = v219,
		icon = v218
	}
end

for _, v in ipairs({ function()
		local gethui = t1.value18.gethui

		if not gethui then
			return gethui
		end

		gethui = t1.value18.gethui()

		return gethui
	end, function()
		return game:GetService("CoreGui")
	end, function()
		return t1.value12:FindFirstChildOfClass("PlayerGui")
	end }) do
	pcall(function()
		local v223 = v()
		local XTHUB_KeySystem

		if v223 then
			XTHUB_KeySystem = v223:FindFirstChild("XTHUB_KeySystem")
		else
			XTHUB_KeySystem = v223
		end

		while XTHUB_KeySystem do
			XTHUB_KeySystem:Destroy()
			XTHUB_KeySystem = v223:FindFirstChild("XTHUB_KeySystem")
		end
	end)
end

t1.value64 = t1.value55("ScreenGui", {
	Name = "XTHUB_KeySystem",
	ResetOnSpawn = false,
	IgnoreGuiInset = true,
	DisplayOrder = 10000,
	ZIndexBehavior = Enum.ZIndexBehavior.Sibling
})
pcall(function()
	if not t1.value18.protectGui then
		return
	end

	t1.value18.protectGui(t1.value64)
end)

if not (pcall(function()
	t1.value64.Parent = t1.value18.gethui()
end) and t1.value64.Parent or pcall(function()
	t1.value64.Parent = game:GetService("CoreGui")
end) and t1.value64.Parent) then
	t1.value64.Parent = t1.value12:WaitForChild("PlayerGui")
end

function t1.value65()
	local v225

	if t1.value13.__XTLDR_RUN == t1.value20 then
		v225 = t1.value64.Parent ~= nil
	else
		v225 = false
	end

	return v225
end

t1.value66 = v192(t1.value64, {
	Size = UDim2.fromScale(1, 1),
	BackgroundColor3 = t1.value49.Backdrop,
	BackgroundTransparency = 1
})
t1.value67 = v192(t1.value64, {
	Name = "Card",
	AnchorPoint = Vector2.new(0.5, 0.5),
	Position = UDim2.new(0.5, 0, 0.5, 14),
	Size = UDim2.new(0, t1.value53, 0, 0),
	AutomaticSize = Enum.AutomaticSize.Y,
	BackgroundColor3 = t1.value49.Bg
})
t1.value57(t1.value67, 12)
v211(t1.value67, t1.value49.Stroke)
t1.value68 = t1.value55("UIScale", {
	Parent = t1.value67
})
v212(t1.value67, 0, 22, 22, 22)
v188(t1.value67, 16)

local v226 = v192(t1.value67, {
	Size = UDim2.new(1, 0, 0, 56),
	LayoutOrder = 1
})

t1.value55("ImageLabel", {
	Name = "XTLogo",
	AnchorPoint = Vector2.new(0, 1),
	Position = UDim2.new(0, 0, 1, 0),
	Size = UDim2.new(0, 48, 0, 24),
	BackgroundTransparency = 1,
	Image = "rbxthumb://type=Asset&id=140715490410324&w=420&h=420",
	ImageRectOffset = Vector2.new(14, 112),
	ImageRectSize = Vector2.new(392, 196),
	ScaleType = Enum.ScaleType.Fit,
	Parent = v226
})
t1.value69 = t1.value58({
	Text = "",
	FontFace = t1.value54.Med,
	TextSize = 14,
	TextColor3 = t1.value49.Dim,
	TextTruncate = Enum.TextTruncate.AtEnd,
	AnchorPoint = Vector2.new(0, 1),
	Position = UDim2.new(0, 60, 1, -4),
	Size = UDim2.new(1, -104, 0, 16),
	Parent = v226
})
t1.value70 = t1.value55("TextButton", {
	AnchorPoint = Vector2.new(1, 1),
	Position = UDim2.new(1, 6, 1, 4),
	Size = UDim2.new(0, 32, 0, 32),
	BackgroundColor3 = t1.value49.Field,
	BackgroundTransparency = 1,
	BorderSizePixel = 0,
	Text = "",
	AutoButtonColor = false,
	Parent = v226
})
t1.value57(t1.value70, 8)
t1.value71 = t1.value59(t1.value70, "x", 16, t1.value49.Faint, {
	AnchorPoint = Vector2.new(0.5, 0.5),
	Position = UDim2.fromScale(0.5, 0.5)
})
t1.value61(t1.value70)
t1.value70.MouseEnter:Connect(function()
	t1.value56(t1.value70, {
		BackgroundTransparency = 0
	})
	t1.value56(t1.value71, {
		ImageColor3 = t1.value49.Text
	})
end)
t1.value70.MouseLeave:Connect(function()
	t1.value56(t1.value70, {
		BackgroundTransparency = 1
	}, 0.32)
	t1.value56(t1.value71, {
		ImageColor3 = t1.value49.Faint
	}, 0.32)
end)
t1.value72 = v192(t1.value67, {
	Size = UDim2.new(1, 0, 0, 0),
	AutomaticSize = Enum.AutomaticSize.Y,
	LayoutOrder = 2
})
v188(t1.value72, 12)
t1.value73 = {}

if #t1.value46 > 1 then
	local v227 = v192(t1.value72, {
		Size = UDim2.new(1, 0, 0, 38),
		BackgroundColor3 = t1.value49.Card,
		LayoutOrder = 1
	})

	t1.value57(v227, 9)
	v212(v227, 3)
	v188(v227, 3, true)

	for i, v in ipairs(t1.value46) do
		local TextButton = t1.value55("TextButton", {
			Size = UDim2.new(1 / #t1.value46, -3 * (#t1.value46 - 1) / #t1.value46, 1, 0),
			BackgroundColor3 = t1.value49.Hover,
			BackgroundTransparency = 1,
			BorderSizePixel = 0,
			AutoButtonColor = false,
			Text = "",
			LayoutOrder = i,
			Parent = v227
		})

		t1.value57(TextButton, 7)

		local v231 = t1.value58({
			Text = t1.value5[v].short,
			FontFace = t1.value54.Med,
			TextSize = 13,
			TextColor3 = t1.value49.Dim,
			TextXAlignment = Enum.TextXAlignment.Center,
			Size = UDim2.fromScale(1, 1),
			Parent = TextButton
		})
		local t10 = {
			button = TextButton,
			label = v231,
			selected = false
		}

		TextButton.MouseEnter:Connect(function()
			if t10.selected then
				return
			end

			t1.value56(v231, {
				TextColor3 = t1.value49.Text
			})
		end)
		TextButton.MouseLeave:Connect(function()
			if t10.selected then
				return
			end

			t1.value56(v231, {
				TextColor3 = t1.value49.Dim
			}, 0.32)
		end)
		t1.value73[v] = t10
	end
end

t1.value74 = t1.value58({
	Text = "",
	TextSize = 12,
	TextColor3 = t1.value49.Dim,
	TextWrapped = true,
	LineHeight = 1.15,
	Size = UDim2.new(1, 0, 0, 0),
	AutomaticSize = Enum.AutomaticSize.Y,
	LayoutOrder = 2,
	Parent = t1.value72
})

local v233 = v192(t1.value72, {
	Size = UDim2.new(1, 0, 0, 44),
	LayoutOrder = 3
})

t1.value75 = v192(v233, {
	Size = UDim2.new(1, -150, 1, 0),
	BackgroundColor3 = t1.value49.Field
})
t1.value57(t1.value75, 8)
t1.value76 = v211(t1.value75, t1.value49.Field)
t1.value77 = t1.value59(t1.value75, "key", 15, t1.value49.Faint, {
	AnchorPoint = Vector2.new(0, 0.5),
	Position = UDim2.new(0, 14, 0.5, 0)
})
t1.value78 = t1.value55("TextBox", {
	Position = UDim2.new(0, 38, 0, 0),
	Size = UDim2.new(1, -76, 1, 0),
	BackgroundTransparency = 1,
	Text = "",
	PlaceholderText = "Paste your key",
	PlaceholderColor3 = t1.value49.Faint,
	TextColor3 = t1.value49.Text,
	TextSize = 13,
	FontFace = t1.value54.Med,
	ClearTextOnFocus = false,
	TextXAlignment = Enum.TextXAlignment.Left,
	TextTruncate = Enum.TextTruncate.AtEnd,
	Parent = t1.value75
})
t1.value79 = t1.value55("TextButton", {
	AnchorPoint = Vector2.new(1, 0.5),
	Position = UDim2.new(1, -6, 0.5, 0),
	Size = UDim2.new(0, 30, 0, 30),
	BackgroundTransparency = 1,
	BorderSizePixel = 0,
	Text = "",
	AutoButtonColor = false,
	Visible = false,
	Parent = t1.value75
})
t1.value59(t1.value79, "x", 14, t1.value49.Faint, {
	AnchorPoint = Vector2.new(0.5, 0.5),
	Position = UDim2.fromScale(0.5, 0.5)
})
t1.value61(t1.value79)
t1.value80 = v213(v233, "primary", "", nil, {
	AnchorPoint = Vector2.new(1, 0),
	Position = UDim2.new(1, 0, 0, 0),
	Size = UDim2.new(0, 140, 1, 0)
})
t1.value81 = v194(t1.value72, 4)
t1.value82 = v192(t1.value72, {
	Size = UDim2.new(1, 0, 0, 40),
	LayoutOrder = 5
})
v188(t1.value82, 8, true)
t1.value83 = t1.value55("TextBox", {
	Size = UDim2.new(1, 0, 0, 0),
	AutomaticSize = Enum.AutomaticSize.Y,
	BackgroundColor3 = t1.value49.Card,
	BorderSizePixel = 0,
	Text = "",
	TextSize = 12,
	FontFace = t1.value54.Body,
	TextColor3 = t1.value49.Warn,
	TextWrapped = true,
	TextXAlignment = Enum.TextXAlignment.Left,
	ClearTextOnFocus = false,
	TextEditable = false,
	Visible = false,
	LayoutOrder = 6,
	Parent = t1.value72
})
t1.value57(t1.value83, 8)
v212(t1.value83, 10, 12)
t1.value84 = v192(t1.value67, {
	Size = UDim2.new(1, 0, 0, 0),
	AutomaticSize = Enum.AutomaticSize.Y,
	LayoutOrder = 3,
	Visible = false
})
v188(t1.value84, 14)

local v234 = v192(t1.value84, {
	Size = UDim2.new(1, 0, 0, 36),
	LayoutOrder = 1
})

t1.value85 = t1.value58({
	Text = "",
	FontFace = t1.value54.Bold,
	TextSize = 14,
	TextTruncate = Enum.TextTruncate.AtEnd,
	Size = UDim2.new(1, 0, 0, 18),
	Parent = v234
})
t1.value86 = t1.value58({
	Text = "",
	TextSize = 12,
	TextColor3 = t1.value49.Dim,
	TextTruncate = Enum.TextTruncate.AtEnd,
	Position = UDim2.new(0, 0, 0, 20),
	Size = UDim2.new(1, 0, 0, 16),
	Parent = v234
})
t1.value87 = v192(t1.value84, {
	Size = UDim2.new(1, 0, 0, 40),
	LayoutOrder = 2
})
t1.value88 = v194(t1.value84, 3)
t1.value89 = v192(t1.value84, {
	Size = UDim2.new(1, 0, 0, 42),
	LayoutOrder = 4,
	Visible = false
})
v188(t1.value89, 8, true)

local v235 = v213(t1.value89, "soft", "Back", "back", {
	Size = UDim2.new(0.35, -4, 1, 0),
	LayoutOrder = 1
})
local v236 = v213(t1.value89, "primary", "Try again", "refresh", {
	Size = UDim2.new(0.65, -4, 1, 0),
	LayoutOrder = 2
})

t1.value90 = v213(t1.value84, "text", "Skip the check and load anyway", nil, {
	Size = UDim2.new(1, 0, 0, 24),
	LayoutOrder = 5,
	Visible = false
})
t1.value90.label.TextColor3 = t1.value49.Warn
t1.value91 = v213(t1.value84, "text", "Cancel", nil, {
	Size = UDim2.new(1, 0, 0, 24),
	LayoutOrder = 6
})
t1.value92 = {
	version = v161,
	view = "form",
	busy = false,
	auto = false,
	token = 0,
	lastSkip = false,
	linkShown = false,
	steps = {},
	stepState = {},
	active = nil,
	detail = nil,
	closing = false
}
t1.value21.ui = t1.value92
t1.value93 = {}

function t1.value94()
	return t1.value5[t1.value92.version]
end
function t1.value95()
	local v237 = t1.value94()
	local visible = v237.key == true

	t1.value69.Text = v237.label

	local pairs_ = pairs

	for k, v in pairs_(t1.value73) do
		local selected = k == t1.value92.version

		v.selected = selected
		pairs_ = v.button
		pairs_.BackgroundTransparency = selected and 0 or 1
		v.label.TextColor3 = selected and t1.value49.Text or t1.value49.Dim
		v.label.FontFace = selected and t1.value54.Bold or t1.value54.Med
	end

	t1.value74.Text = v237.desc
	t1.value75.Visible = visible

	local button = t1.value80.button
	local uDim2

	if visible then
		uDim2 = UDim2.new(0, 140, 1, 0)
	else
		uDim2 = visible
	end

	button.Size = uDim2 or UDim2.new(1, 0, 1, 0)
	t1.value80.label.Text = visible and "Verify & load" or "Load"

	local value82 = t1.value82
	local visible2

	if visible then
		visible2 = v237.links ~= nil
	else
		visible2 = visible
	end

	value82.Visible = visible2
	t1.value83.Visible = t1.value92.linkShown and visible
end
function t1.value96(p74)
	t1.value92.view = p74
	t1.value72.Visible = p74 == "form"
	t1.value84.Visible = p74 == "progress"
end
function t1.value97(p75)
	t1.value56(t1.value76, {
		Color = p75
	})

	local function v247()
		if not t1.value65() then
			return
		end

		t1.value56(t1.value76, {
			Color = t1.value49.Field
		}, 0.32)
	end

	task.delay(1.6, v247)
end
function t1.value98(p76)
	return p76 < 10 and string.format("%.1fs", p76) or math.floor(p76) .. "s"
end

t1.value99 = {
	pending = {
		icon = "circle",
		color = t1.value49.Faint,
		text = t1.value49.Faint
	},
	active = {
		icon = "loader",
		color = t1.value49.Accent,
		text = t1.value49.Text
	},
	done = {
		icon = "checkCircle",
		color = t1.value49.Good,
		text = t1.value49.Dim
	},
	failed = {
		icon = "xCircle",
		color = t1.value49.Bad,
		text = t1.value49.Bad
	}
}

local function v248(p77, p78)
	local v249 = t1.value93[p77]
	local v250 = t1.value99[p78]
	local stepState = t1.value92.stepState

	v249.state = p78
	stepState[p77] = p78

	local icon = v249.icon
	local icon2 = v249.icon
	local icon3 = v249.icon
	local v255 = t1.value50[v250.icon]
	local color = v250.color

	icon.Image = v255
	icon2.ImageColor3 = color
	icon3.Rotation = 0
	v249.title.TextColor3 = v250.text

	if not v249.link then
		return
	end

	local link = v249.link
	local s6 = "BackgroundColor3"
	local Good

	if p78 == "done" then
		Good = t1.value49.Good
	else
		Good = false
	end

	link[s6] = Good or t1.value49.Stroke
end

function t1.value100(p79)
	local value87 = t1.value87

	value87.ClearAllChildren(value87)

	local value92 = t1.value92
	local value922 = t1.value92
	local value923 = t1.value92
	local value924 = t1.value92

	t1.value93 = {}
	value92.steps = p79
	value922.stepState = {}
	value923.active = nil
	value924.detail = nil

	local v265 = #p79

	for i, v in ipairs(p79) do
		local v268 = v192(t1.value87, {
			Position = UDim2.new((i - 1) / v265, 0, 0, 0),
			Size = UDim2.new(1 / v265, 0, 1, 0)
		})
		local value93 = t1.value93
		local s7 = "icon"
		local v271 = t1.value59(v268, "circle", 18, t1.value49.Faint, {
			AnchorPoint = Vector2.new(0.5, 0),
			Position = UDim2.new(0.5, 0, 0, 0)
		})
		local s8 = "title"
		local v273 = t1.value58({
			Text = t1.value51[v],
			TextSize = 11,
			TextXAlignment = Enum.TextXAlignment.Center,
			Position = UDim2.new(0, 0, 0, 24),
			Size = UDim2.new(1, 0, 0, 14),
			Parent = v268
		})
		local s9 = "link"
		local v275 = i < v265

		if v275 then
			v275 = v192(t1.value87, {
				Position = UDim2.new((i - 0.5) / v265, 16, 0, 8),
				Size = UDim2.new(1 / v265, -32, 0, 2),
				BackgroundColor3 = t1.value49.Stroke
			})
		end

		value93[v] = {
			[s7] = v271,
			[s8] = v273,
			[s9] = v275 or nil
		}
		v248(v, "pending")
	end
end
function t1.value101()
	local active = t1.value92.active

	if active then
		active = t1.value93[t1.value92.active]
	end

	if not active then
		return
	end

	local v277 = t1.value52[t1.value92.active]
	local detail = t1.value92.detail

	if detail then
		detail = " (" .. t1.value92.detail .. ")"
	end

	local text = v277 .. (detail or "") .. "..."
	local v280 = os.clock() - active.startedAt

	if not (v280 >= 2) then
		t1.value86.Text = text

		return
	end

	text = text .. "  " .. t1.value98(v280)
	t1.value86.Text = text
end
function t1.value102(p80, p81)
	local v281 = t1.value93[p80]

	if not v281 then
		return
	end

	local now = os.clock()

	for _, step in ipairs(t1.value92.steps) do
		if step == p80 then
			break
		end

		if t1.value93[step].state ~= "done" then
			v248(step, "done")
		end
	end

	if v281.state ~= "active" then
		v281.startedAt = now
	end

	local value92 = t1.value92
	local value922 = t1.value92

	value92.active = p80
	value922.detail = p81
	v248(p80, "active")
	t1.value86.TextColor3 = t1.value49.Dim
	t1.value101()

	local value22 = t1.value22
	local s10 = "stage: "

	if not p81 then
		value22(s10 .. (p80 .. p81 or ""))

		return
	end

	p81 = " (" .. p81 .. ")"
	value22(s10 .. (p80 .. p81 or ""))
end
function t1.value103()
	for _, step in ipairs(t1.value92.steps) do
		if t1.value93[step].state ~= "done" then
			v248(step, "done")
		end
	end

	t1.value92.active = nil

	local value86 = t1.value86
	local value862 = t1.value86
	local Good = t1.value49.Good

	value86.Text = "All done - enjoy!"
	value862.TextColor3 = Good
	t1.value91.button.Visible = false
end
function t1.value104(p82, p83)
	if not t1.value92.active then
		t1.value92.active = nil
		v366 = t1.value86
		v367 = t1.value86
		v368 = t1.value49.Bad
		v366.Text = "Something went wrong at this step"
		v367.TextColor3 = v368
		t1.value88.set("error", p82)
		t1.value92.lastError = p82
		t1.value91.button.Visible = false
		t1.value89.Visible = true
		t1.value90.button.Visible = p83

		return
	end

	v248(t1.value92.active, "failed")
	t1.value92.active = nil

	local value86 = t1.value86
	local value862 = t1.value86
	local Bad = t1.value49.Bad

	value86.Text = "Something went wrong at this step"
	value862.TextColor3 = Bad
	t1.value88.set("error", p82)
	t1.value92.lastError = p82
	t1.value91.button.Visible = false
	t1.value89.Visible = true
	t1.value90.button.Visible = p83
end
function t1.value105()
	local AbsoluteSize = t1.value64.AbsoluteSize

	if AbsoluteSize.X < 10 and true or AbsoluteSize.Y < 10 then
		return
	end

	local Scale = t1.value68.Scale
	local v299 = t1.value67.AbsoluteSize.Y / math.max(Scale, 0.01)
	local v300 = (AbsoluteSize.X - 24) / t1.value53
	local v301 = (AbsoluteSize.Y - 24) / math.max(v299, 1)
	local v302 = math.min(1, v300, v301)
	local scale = math.clamp(v302, 0.5, 1)
	local v304 = scale - Scale

	if not (math.abs(v304) > 0.01) then
		return
	end

	t1.value68.Scale = scale
end

t1.value64:GetPropertyChangedSignal("AbsoluteSize"):Connect(function()
	task.defer(t1.value105)
end)
t1.value67:GetPropertyChangedSignal("AbsoluteSize"):Connect(function()
	task.defer(t1.value105)
end)

local function v305()
	if t1.value92.closing then
		return
	end

	t1.value92.closing = true

	local value92 = t1.value92
	local s11 = "token"

	value92[s11] = value92[s11] + 1
	t1.value56(t1.value67, {
		Position = UDim2.new(0.5, 0, 0.5, 14)
	}, 0.16, Enum.EasingStyle.Quad, Enum.EasingDirection.In)
	t1.value56(t1.value66, {
		BackgroundTransparency = 1
	}, 0.16, Enum.EasingStyle.Quad, Enum.EasingDirection.In)
	t1.value56(t1.value68, {
		Scale = t1.value68.Scale * 0.96
	}, 0.16, Enum.EasingStyle.Quad, Enum.EasingDirection.In)
	task.delay(0.2, function()
		local function v308()
			t1.value64.Enabled = false
		end

		pcall(v308)

		local getthreadidentity = t1.value17("getthreadidentity", "get_thread_identity")
		local setthreadidentity = t1.value17("setthreadidentity", "set_thread_identity")
		local u311 = nil

		if getthreadidentity then
			pcall(function()
				u311 = getthreadidentity()
			end)
		end

		if setthreadidentity then
			pcall(setthreadidentity, 8)
		end

		local function v312()
			t1.value64:Destroy()
		end

		pcall(v312)

		local v313

		if setthreadidentity then
			v313 = u311 ~= nil
		else
			v313 = setthreadidentity
		end

		if not v313 then
			return
		end

		pcall(setthreadidentity, u311)
	end)
end

function t1.value106(p84, p85)
	if t1.value92.busy or t1.value92.closing then
		return
	end

	local v314 = t1.value94()
	local version = t1.value92.version
	local text

	if v314.key then
		text = t1.value39(t1.value78.Text)
		t1.value78.Text = text

		if text == "" then
			t1.value96("form")
			t1.value81.set("warn", "Paste your key first. No key yet? Get one with the buttons below.")
			t1.value97(t1.value49.Warn)

			return
		end
	else
		text = ""
	end

	local value92 = t1.value92
	local s12 = "token"

	value92[s12] = value92[s12] + 1

	local token = t1.value92.token
	local value922 = t1.value92
	local value923 = t1.value92
	local value924 = t1.value92

	value922.busy = true
	value923.auto = p84
	value924.lastSkip = p85

	local key = v314.key

	if key then
		key = not p85
	end

	t1.value100(key and {
		"connect",
		"verify",
		"character",
		"download",
		"start"
	} or key or { "character", "download", "start" })
	t1.value85.Text = (p84 and "Auto-loading " or "Loading ") .. v314.label
	t1.value88.hide()

	local value89 = t1.value89
	local button = t1.value90.button
	local button2 = t1.value91.button

	value89.Visible = false
	button.Visible = false
	button2.Visible = true
	t1.value81.hide()
	t1.value96("progress")

	local function v327(p86, p87)
		local v328

		if token == t1.value92.token then
			v328 = t1.value65()
		else
			v328 = false
		end

		if not v328 then
			return
		end

		t1.value102(p86, p87)
	end
	local function v329()
		return token ~= t1.value92.token and true or not t1.value65()
	end

	v327(t1.value92.steps[1])

	if p85 then
		t1.value22("user skipped the key pre-check")
	end

	task.spawn(function()
		local v330, v331

		if not key then
			v330, v331 = t1.value45(version, text, v327, v329)

			if v329() then
				return
			elseif v330 then
				t1.value103()
				task.delay(0.9, v305)

				return
			else
				t1.value92.busy = false
				t1.value104(v331, false)
				t1.value22("launch failed: " .. tostring(v331))

				return
			end
		end

		if not t1.value40(text) then
			t1.value22("key does not match the 32-letter format; checking anyway")
		end

		local v332 = text
		local v333 = v327
		local v334 = t1.value36(v314, v332, v333)

		if v329() then
			return
		end

		if v334.kind == "rejected" then
			t1.value92.busy = false

			if t1.value7[v334.code] then
				t1.value42(v314, text)
			end

			t1.value96("form")
			t1.value81.set(v334.code == "KEY_HWID_LOCKED" and "warn" or "error", v334.message)

			if v334.code:sub(1, 4) ~= "KEY_" then
				return
			end

			t1.value97(t1.value49.Bad)
		else
			if v334.kind == "retry" then
				t1.value92.busy = false
				t1.value104(v334.message .. "\nTry again, or skip the check - Luarmor still verifies your key when the script starts.", true)

				return
			end

			v106(v314.keyFile, text)
			t1.value56(t1.value76, {
				Color = t1.value49.Good
			})
			v330, v331 = t1.value45(version, text, v327, v329)

			if v329() then
				return
			elseif v330 then
				t1.value103()
				task.delay(0.9, v305)

				return
			else
				t1.value92.busy = false
				t1.value104(v331, false)
				t1.value22("launch failed: " .. tostring(v331))

				return
			end
		end
	end)
end

t1.value80.button.Activated:Connect(function()
	t1.value106(false, false)
end)
v236.button.Activated:Connect(function()
	t1.value106(false, t1.value92.lastSkip)
end)
t1.value90.button.Activated:Connect(function()
	t1.value106(false, true)
end)
v235.button.Activated:Connect(function()
	if t1.value92.busy then
		return
	end

	t1.value96("form")

	if not t1.value92.lastError then
		return
	end

	t1.value81.set("error", t1.value92.lastError)
end)
t1.value91.button.Activated:Connect(function()
	if t1.value92.busy then
		local value92 = t1.value92
		local s13 = "token"

		value92[s13] = value92[s13] + 1

		local value922 = t1.value92
		local value923 = t1.value92

		value922.busy = false
		value923.auto = false
		t1.value22("user cancelled")
		t1.value96("form")
		t1.value81.set("info", "Cancelled - nothing was loaded. Pick a version and try again.")
	end
end)

local function v339(p88)
	if t1.value92.busy or not t1.value47[p88] then
		return
	end

	t1.value92.version = p88
	t1.value92.linkShown = false
	t1.value78.Text = t1.value48(p88)
	t1.value81.hide()
	t1.value95()

	if not t1.value94().key then
		return
	end

	task.spawn(t1.value35)
end

for k, v in pairs(t1.value73) do
	v.button.Activated:Connect(function()
		v339(k)
	end)
end

t1.value70.Activated:Connect(v305)
t1.value79.Activated:Connect(function()
	t1.value78.Text = ""
	t1.value81.hide()
end)
t1.value78:GetPropertyChangedSignal("Text"):Connect(function()
	t1.value79.Visible = t1.value78.Text ~= ""
end)
t1.value78.Focused:Connect(function()
	t1.value56(t1.value76, {
		Color = t1.value49.Accent
	})
	t1.value56(t1.value77, {
		ImageColor3 = t1.value49.Accent
	})
end)
t1.value78.FocusLost:Connect(function(enterPressed)
	t1.value56(t1.value76, {
		Color = t1.value49.Field
	}, 0.32)
	t1.value56(t1.value77, {
		ImageColor3 = t1.value49.Faint
	}, 0.32)

	if not enterPressed then
		return
	end

	t1.value106(false, false)
end)

local links = t1.value94().links or t2

for i, link in ipairs(links) do
	local v345 = link[1]
	local v346 = link[2]
	local v347 = "Get key - " .. (t9[v345] or v345)
	local value82 = t1.value82
	local uDim2New = UDim2.new
	local v350 = #links
	local v351 = v213(value82, "soft", v347, "external", {
		Size = uDim2New(1 / #links, -8 * (#links - 1) / v350, 1, 0),
		LayoutOrder = i
	})

	v351.button.Activated:Connect(function()
		local v352

		if t1.value18.clipboard == nil then
			v352 = false
		else
			v352 = pcall(t1.value18.clipboard, v346)
		end

		t1.value83.Text = v346
		t1.value92.linkShown = not v352
		t1.value95()
		v351.label.Text = v352 and "Link copied" or v352 or "See the link below"

		local label = v351.label
		local Good

		if v352 then
			Good = t1.value49.Good
		else
			Good = v352
		end

		label.TextColor3 = Good or t1.value49.Warn
		t1.value81.set(v352 and "success" or v352 or "warn", v352 and "Link copied. Open it in your browser, finish the steps, then paste your key above." or "Couldn\'t copy. Long-press the link below to copy it, open it in your browser, then paste your key above.")

		local function v355()
			if t1.value65() then
				local label2 = v351.label
				local label3 = v351.label
				local v358 = v347
				local Text = t1.value49.Text

				label2.Text = v358
				label3.TextColor3 = Text
			end
		end

		task.delay(2, v355)
	end)
end

t1.value107 = nil
t1.value108 = nil
t1.value109 = nil
v226.InputBegan:Connect(function(input)
	if not t1.value60(input) then
		return
	end

	local Position = input.Position
	local Position2 = t1.value67.Position

	t1.value107 = input
	t1.value108 = Position
	t1.value109 = Position2
end)
UserInputService.InputChanged:Connect(function(input)
	if not t1.value107 then
		return
	end

	local v362

	if input == t1.value107 then
		v362 = true
	elseif t1.value107.UserInputType == Enum.UserInputType.MouseButton1 then
		v362 = input.UserInputType == Enum.UserInputType.MouseMovement
	else
		v362 = false
	end

	if not v362 then
		return
	end

	local v363 = input.Position - t1.value108

	t1.value67.Position = UDim2.new(t1.value109.X.Scale, t1.value109.X.Offset + v363.X, t1.value109.Y.Scale, t1.value109.Y.Offset + v363.Y)
end)
UserInputService.InputEnded:Connect(function(input)
	local _ = input == t1.value107 and true or input.UserInputType == Enum.UserInputType.MouseButton1
end)
t1.value110 = 0
t1.value111 = nil
t1.value111 = RunService.Heartbeat:Connect(function(dt)
	if not t1.value65() then
		t1.value111:Disconnect()

		return
	end

	local active = t1.value92.active
	local v369

	if not active then
		if active then
			active.icon.Rotation = os.clock() * 300 % 360
			v369 = t1
			v369.value110 = v369.value110 + dt

			if t1.value110 < 0.25 then
				return
			else
				t1.value101()

				return
			end
		end

		return
	end

	active = t1.value93[t1.value92.active]

	if active then
		active.icon.Rotation = os.clock() * 300 % 360
		v369 = t1
		v369.value110 = v369.value110 + dt

		if t1.value110 < 0.25 then
			return
		else
			t1.value101()

			return
		end
	end
end)
t1.value78.Text = t1.value48(t1.value92.version)
t1.value95()
task.defer(t1.value105)
t1.value56(t1.value66, {
	BackgroundTransparency = 0.35
}, 0.32)
t1.value56(t1.value67, {
	Position = UDim2.new(0.5, 0, 0.5, 0)
}, 0.32)

local value22 = t1.value22
local value19 = t1.value19
local GameId3 = game.GameId

value22("ui ready on " .. value19 .. " (game " .. tostring(GameId3) .. ", " .. #t1.value46 .. " version(s))")
task.defer(function()
	if t1.value94().key then
		if t1.value39(t1.value78.Text) == "" then
			task.spawn(t1.value35)

			return
		else
			t1.value106(true, false)

			return
		end
	elseif #t1.value46 == 1 then
		t1.value106(true, false)

		return
	else
		return
	end
end)
