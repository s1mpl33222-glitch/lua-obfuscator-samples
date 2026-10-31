-- This file was generated at discord.gg/syncrypt

local t1 = {}
local unpack_ = unpack or table.unpack

if not LPH_OBFUSCATED then
	getgenv().LPH_NO_VIRTUALIZE = function(p1)
		return p1
	end
	getgenv().LPH_JIT = function(p2)
		return p2
	end
	getgenv().LPH_ENCSTR = function(p3)
		return p3
	end
	getgenv().LPH_ENCNUM = function(p4)
		return p4
	end
	getgenv().LPH_CRASH = function()
		while true do

		end
	end
	getgenv().LPH_OBFUSCATED = false
end

local islclosure_ = islclosure

if islclosure_ then
	islclosure_ = islclosure(game.HttpGet)
end

if islclosure_ then
	LPH_CRASH()
end

local t2 = {
	value1 = game:GetService("HttpService"),
	value2 = nil,
	value3 = 0,
	value4 = LPH_ENCSTR("ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz0123456789+/")
}

function t2.value5(p5)
	return (p5:gsub(".", function(p6)
		local s1 = ""
		local v6 = p6.byte(p6)
		local v7 = s1

		for i = 8, 1, -1 do
			s1 = v7 .. (v6 % 2 ^ i - v6 % 2 ^ (i - 1) > 0 and "1" or false or "0")
			v7 = s1
		end

		return v7
	end) .. "0000"):gsub("%d%d%d?%d?%d?%d?", function(p7)
		if #p7 < 6 then
			return ""
		else
			local n1 = 0

			for i = 1, 6 do
				n1 = n1 + (p7.sub(p7, i, i) == "1" and (2 ^ (6 - i) or 0) or 0)
			end

			local value4 = t2.value4
			local v12 = n1 + 1
			local v13 = n1 + 1

			return value4.sub(value4, v12, v13)
		end
	end) .. ({ "", "==", "=" })[#p5 % 3 + 1]
end
function t2.value6(p8)
	return string.gsub(p8, "[^" .. t2.value4 .. "=]", ""):gsub(".", function(p9)
		if p9 == "=" then
			return ""
		else
			local v14 = t2.value4:find(p9) - 1
			local s2 = ""
			local s3 = ""

			for i = 6, 1, -1 do
				s2 = s3 .. (v14 % 2 ^ i - v14 % 2 ^ (i - 1) > 0 and "1" or false or "0")
				s3 = s2
			end

			return s3
		end
	end):gsub("%d%d%d?%d?%d?%d?%d?%d?", function(p10)
		if #p10 == 8 then
			local n2 = 0

			for i = 1, 8 do
				n2 = n2 + (p10:sub(i, i) == "1" and (2 ^ (8 - i) or 0) or 0)
			end

			return string.char(n2)
		else
			return ""
		end
	end)
end

t2.value7 = nil

local ok, value7 = pcall(function()
	return t2.value1:GenerateGUID(false)
end)

if ok and value7 then
	t2.value7 = value7
else
	local v22 = LPH_ENCSTR("ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz0123456789")

	t2.value7 = ""

	for _ = 1, 32 do
		t1.value1 = math.random(1, #v22)
		t2.value7 = t2.value7 .. v22:sub(t1.value1, t1.value1)
	end
end

local function v24(p11)
	local v25 = nil

	local function v26()
		return t2.value1:Base64Encode(v25)
	end

	v25 = p11

	local ok2, result = pcall(v26)

	if ok2 then
	elseif ok2 then
		return result
	else
		return t2.value5(v25)
	end

	if result then
		ok2 = result ~= ""
	else
		ok2 = result
	end

	if ok2 then
		return result
	else
		return t2.value5(v25)
	end
end

function t2.value8(p12)
	local function v29()
		return t2.value1:Base64Decode(p12)
	end

	local ok2, result = pcall(v29)

	if ok2 then
	elseif ok2 then
		return result
	else
		return t2.value6(p12)
	end

	if result then
		ok2 = result ~= ""
	else
		ok2 = result
	end

	if ok2 then
		return result
	else
		return t2.value6(p12)
	end
end

local _ = game:GetService("Players").LocalPlayer

t2.value9 = nil

function t2.value9()
	local function v33()
		if identifyexecutor then
			local identifyexecutor_ = identifyexecutor
			local pos = tostring(identifyexecutor_()):lower():find(unpack_({ LPH_ENCSTR("delta") }))

			if pos then
				pos = delta

				if pos then
					pos = delta.gethwid
				end
			end

			if pos then
				return delta.gethwid()
			end
		end

		local getgenv_ = getgenv

		if getgenv_ then
			local HWID = getgenv().HWID

			getgenv_ = type(HWID) == "string"
		end

		if getgenv_ then
			return getgenv().HWID
		end

		local syn_ = syn

		if syn_ then
			syn_ = syn.gethwid
		end

		if syn_ then
			return syn.gethwid()
		end

		if get_hwid then
			return get_hwid()
		end

		if gethwid then
			return gethwid()
		end

		local txt = LPH_ENCSTR("weretools_sys_id.txt")
		local isfile_ = isfile
		local v41, v42, v43, random

		if isfile_ then
		elseif isfile_ then
			if isfile(txt) then
				v41 = readfile(txt)

				if v41 then
					v42 = #v41 > 10
				else
					v42 = v41
				end

				if v42 then
					return v41
				else
					v43 = "wt_uid_" .. game:GetService("HttpService"):GenerateGUID(false):gsub("-", "")
					writefile(txt, v43)

					return v43
				end
			else
				v43 = "wt_uid_" .. game:GetService("HttpService"):GenerateGUID(false):gsub("-", "")
				writefile(txt, v43)

				return v43
			end
		else
			random = math.random

			return "session_uid_" .. tostring(random(1000000, 9999999))
		end

		isfile_ = readfile

		if isfile_ then
		elseif isfile_ then
			if isfile(txt) then
				v41 = readfile(txt)

				if v41 then
					v42 = #v41 > 10
				else
					v42 = v41
				end

				if v42 then
					return v41
				else
					v43 = "wt_uid_" .. game:GetService("HttpService"):GenerateGUID(false):gsub("-", "")
					writefile(txt, v43)

					return v43
				end
			else
				v43 = "wt_uid_" .. game:GetService("HttpService"):GenerateGUID(false):gsub("-", "")
				writefile(txt, v43)

				return v43
			end
		else
			random = math.random

			return "session_uid_" .. tostring(random(1000000, 9999999))
		end

		isfile_ = writefile

		if isfile_ then
			if isfile(txt) then
				v41 = readfile(txt)

				if v41 then
					v42 = #v41 > 10
				else
					v42 = v41
				end

				if v42 then
					return v41
				else
					v43 = "wt_uid_" .. game:GetService("HttpService"):GenerateGUID(false):gsub("-", "")
					writefile(txt, v43)

					return v43
				end
			else
				v43 = "wt_uid_" .. game:GetService("HttpService"):GenerateGUID(false):gsub("-", "")
				writefile(txt, v43)

				return v43
			end
		else
			random = math.random

			return "session_uid_" .. tostring(random(1000000, 9999999))
		end
	end

	local ok2, result = pcall(v33)

	return not (ok2 and result) and "unknown" or tostring(result)
end

local function v47()
	local txt = isfile("weretools_key.txt")

	if not txt then
		return txt or ""
	end

	txt = t2.value8(readfile("weretools_key.txt"))

	return txt or ""
end

function t2.value10()
	if not isfile("weretools_key.txt") then
		return
	end

	delfile("weretools_key.txt")
end

t2.value11 = nil

function t2.value11(p13)
	return p13:find(unpack_({ LPH_ENCSTR("^FISHBOT%-LIFETIME") })) and "Lifetime" or (p13:find(LPH_ENCSTR("^FISHBOT%-TRIAL")) and "Trial" or (p13:find(unpack_({ LPH_ENCSTR("^FISHBOT%-PREMIUM") })) and "Premium" or (p13:find(LPH_ENCSTR("^WERETOOLS%-LIFETIME")) and "Lifetime" or (p13:find(unpack_({ LPH_ENCSTR("^WERETOOLS%-TRIAL") })) and "Trial" or (p13:find(LPH_ENCSTR("^WERETOOLS%-PREMIUM")) and "Premium" or "Unknown")))))
end

t2.value12 = nil

function t2.value12(p14, p15, p16, p17)
	local v49 = t2.value11(p14)

	if v49 == "Unknown" then
		p17(false, "Invalid key format.")

		return
	end

	local auth = LPH_ENCSTR("https://weretool.xyz/api/v1/executor/auth")
	local format = string.format
	local value1 = t2.value1
	local v53 = format("%s?key=%s&hwid=%s&place_id=%s", auth, value1.UrlEncode(value1, p14), t2.value1:UrlEncode(p15), t2.value1:UrlEncode(unpack_({ (tostring(p16)) })))
	local v54 = nil

	local function v55()
		return LPH_NO_VIRTUALIZE(function()
			return game:HttpGet(v54)
		end)()
	end

	v54 = v53

	local ok2, result = pcall(v55)

	if ok2 then
		ok2 = result
	end

	if not ok2 then
		p17(false, "Connection Failed or Invalid Key")

		return
	end

	if result:sub(1, 1) ~= "{" then
		v77 = #result > 50

		if not v77 then
			if v77 then
				p17(true, result)
			else
				p17(false, "Connection Failed or Invalid Key")
			end

			return
		end

		v77 = not result:find(LPH_ENCSTR("\"error\":"))

		if v77 then
			p17(true, result)
		else
			p17(false, "Connection Failed or Invalid Key")
		end

		return
	end

	local function v58()
		return t2.value1:JSONDecode(result)
	end

	local ok3, result2 = pcall(v58)

	if not (ok3 and result2) then
		v77 = #result > 50

		if not v77 then
			if v77 then
				p17(true, result)
			else
				p17(false, "Connection Failed or Invalid Key")
			end

			return
		end

		v77 = not result:find(LPH_ENCSTR("\"error\":"))

		if v77 then
			p17(true, result)
		else
			p17(false, "Connection Failed or Invalid Key")
		end

		return
	end

	if result2.success then
		t2.value2 = result2.session_token

		if result2.expires_at then
			v76 = t2.value2 or "" .. t2.value7 .. p14
			result2._validationProof = t2.value5(v76)
			result2.keyType = result2.key_type or v49
			p17(true, result2)

			return
		end

		local _ = os.time() + 3600
		local value2 = t2.value2 or "" .. t2.value7 .. p14

		result2._validationProof = t2.value5(value2)
		result2.keyType = result2.key_type or v49
		p17(true, result2)

		return
	end

	if result2.error then
		p17(false, result2.message or "Key Invalid")

		return
	end

	local v63 = #result > 50

	if not v63 then
		if v63 then
			p17(true, result)
		else
			p17(false, "Connection Failed or Invalid Key")
		end

		return
	end

	v63 = not result:find(LPH_ENCSTR("\"error\":"))

	if v63 then
		p17(true, result)
	else
		p17(false, "Connection Failed or Invalid Key")
	end
end

return {
	_req_01 = t2.value12,
	_sec_02 = function(p18)
		if not t2.value2 or t2.value2 == "" then
			return true
		end

		local txt = isfile("weretools_key.txt")

		if txt then
			txt = t2.value8(readfile("weretools_key.txt"))
		end

		local value2 = t2.value2 or "" .. (t2.value7 or ("" .. (txt or "") or ""))

		local function v66()
			return t2.value1:Base64Encode(value2)
		end

		local ok2, result = pcall(v66)

		return p18 == (ok2 and result and result or t2.value5(value2))
	end,
	_sec_03 = function()
		if not t2.value2 or t2.value2 == "" then
			return true, "Loader Mode", {}
		end

		if os.time() > t2.value3 then
			return false, "Session expired"
		end

		local v69 = t2.value9()
		local validateSession = LPH_ENCSTR("https://weretool.xyz/api/v1/validate_session")
		local v71 = t2.value1:UrlEncode(t2.value2)
		local v72 = t2.value1:UrlEncode(v69)
		local v73 = nil

		local function v74()
			return game:HttpGet(v73)
		end

		v73 = validateSession .. "?token=" .. v71 .. "&hwid=" .. v72

		local ok2, result = pcall(v74)

		if ok2 then
			ok2 = result
		end

		if not ok2 then
			return false, "Connection failed."
		end

		local function v78()
			return t2.value1:JSONDecode(result)
		end

		local ok3, result2 = pcall(v78)

		if not (ok3 and result2) then
			return false, "Connection failed."
		end

		local success = result2.success

		if success then
			success = result2.valid
		end

		if not success then
			return false, result2.message or "Validation failed"
		end

		if not result2.expires_at then
			return true, result2.key_type, result2
		end

		local _ = result2.expires_at

		return true, result2.key_type, result2
	end,
	_io_r = v47,
	_io_w = function(p19)
		writefile("weretools_key.txt", v24(p19))
	end,
	_io_d = t2.value10,
	_sys_id = t2.value9,
	_exec = function(p20, p21, _)
		local LPH_OBFUSCATED_ = LPH_OBFUSCATED

		if LPH_OBFUSCATED_ then
			LPH_OBFUSCATED_ = not isfile("weretools_key.txt")
		end

		if LPH_OBFUSCATED_ then
			if not p21 then
				return false
			end

			p21("Key Not Found")

			return false
		end

		local v83 = v47()

		if v83 ~= "" then
			local v84 = t2.value9()
			local PlaceId = game.PlaceId

			local function v86(p22, p23)
				if p22 then
					if type(p23) == "string" then
					elseif type(p23) == "table" and p20 then
						p20(p23)

						return
					else
						return
					end

					if not p20 then
						return
					end

					p20(p23)
				else
					t2.value10()

					if not p21 then
						return
					end

					p21(type(p23) == "string" and p23 and p23 or "Key expired")
				end
			end

			t2.value12(v83, v84, PlaceId, v86)

			return true
		end

		if not p21 then
			return false
		end

		p21("No saved key")

		return false
	end,
	_token = function()
		return t2.value2
	end,
	_type = t2.value11
}
