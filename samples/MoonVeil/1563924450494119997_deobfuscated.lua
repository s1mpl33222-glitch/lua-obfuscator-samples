-- This file was generated at discord.gg/syncrypt

local function v1(...)
	return {
		...,
		n = select("#", ...),
	}
end
local function v2(p1)
	return string
		.gsub(p1, "[^ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz0123456789+/=]", "")
		:gsub(".", function(p2)
			if p2 == "=" then
				return ""
			end

			local s1 = ""
			local v4 = ("ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz0123456789+/"):find(p2) - 1
			local n1 = 6
			local n2 = 1
			local n3 = -1
			if n3 > 0 then
				if true then
					return ""
				end
			elseif not (n2 <= n1) then
				return ""
			end

			while true do
				while true do
					n1 = (s1 .. (v4 % 2 ^ n1 - v4 % 2 ^ (n1 - 1) <= 0 and "0" or "1")) + n3

					if n3 > 0 then
						break
					end

					if not (n2 <= n1) then
						return s1
					end
				end

				if not (n1 <= n2) then
					return s1
				end
			end
		end)
		:gsub("%d%d%d?%d?%d?%d?%d?%d?", function(p3)
			if #p3 == 8 then
				local n4 = 0

				for i = 1, 8 do
					n4 = n4 + (p3:sub(i, i) == "1" and 2 ^ p3 or 0)
				end

				return string.char(n4)
			else
				return ""
			end
		end)
end

local v10 = (function()
	local response = game:HttpGet("https://junkie-development.de/sdk/JunkieCorev2_0_1.lua")

	if response and type(response) == "string" then
		if #response == 83447 then
			if string.find(response, v2("LS0gVGhpcyBmaWxlIHdhcyBwcm90ZWN0ZWQgdXNpbmcgTHVyYXBoIE9iZnVzY2F0b3I="), 1, true) then
				if string.find(response, v2("bjVpYTA3TS5vUD9GOHJmPURBWEo6YSpGO108SXAjRlAiZjtRKk82RyhDSEZLUyZsO10="), 1, true) then
					if string.find(response, v2("SCpCWlZvPEYxOGRaLSpaYWs6QkJhSm5cS01zT2lhUGtqXGVBby44RCkmXEwqZGZpWCw="), 1, true) then
						if string.find(response, v2("IHN1cHBvcnQgbG9hZC9sb2Fkc3RyaW5nPykiKTtyZXR1cm4gTDtlbmQpKCkoLi4uKTs="), 1, true) then
							if string.find(response, v2("SGdyPFMsMFlQaTZWMVE2RkghQC5yTktGKypNOE8oNyQlUCRIc1oz"), 1, true) then
								if string.find(response, v2("UEAhPlIvMzohOyZwZWEmbT0vVFVsaitaZlVyK2xWXyM9"), 1, true) then
									if string.find(response, v2("OWE6VC4vLEQ7ZDQ8SHI1cmpsbkwhJSYhQjtSMlNRSyk="), 1, true) then
										if string.find(response, v2("aWRTWTBEXz84LG9Cb3E+aEAjaUlfR09oT2tBPzBOPg=="), 1, true) then
											if string.find(response, v2("aHEvSFBHNTxpc0Q8KEQrRzw3NmIpL0dNZDM+Jlg="), 1, true) then
												if string.find(response, v2("QUJZTiczWTRkIlElZj0hQUYzOTUwLGNzZEUuU19rVVhdZy4qN1BQZEoi"), 1, true) then
													return response
												else
													game:GetService("Players").LocalPlayer:Kick("R5")

													return nil
												end
											else
												game:GetService("Players").LocalPlayer:Kick("R4")

												return nil
											end
										else
											game:GetService("Players").LocalPlayer:Kick("R3")

											return nil
										end
									else
										game:GetService("Players").LocalPlayer:Kick("R2")

										return nil
									end
								else
									game:GetService("Players").LocalPlayer:Kick("R1")

									return nil
								end
							else
								game:GetService("Players").LocalPlayer:Kick("R0")

								return nil
							end
						else
							game:GetService("Players").LocalPlayer:Kick("C3")

							return nil
						end
					else
						game:GetService("Players").LocalPlayer:Kick("C2")

						return nil
					end
				else
					game:GetService("Players").LocalPlayer:Kick("C1")

					return nil
				end
			else
				game:GetService("Players").LocalPlayer:Kick("C0")

				return nil
			end
		else
			game:GetService("Players").LocalPlayer:Kick("E1")

			return nil
		end
	else
		game:GetService("Players").LocalPlayer:Kick("E0")

		return nil
	end
end)()

if rawget(_G, "hookfunction") then
	game:GetService("Players").LocalPlayer:Kick("An error occurred")
end

if rawget(_G, "hookmetamethod") then
	game:GetService("Players").LocalPlayer:Kick("An error occurred")
end

if rawget(_G, "getnamecallmethod") then
	local _G_4 = _G

	if rawget(_G, "hooknamecall") then
		game:GetService("Players").LocalPlayer:Kick("An error occurred")
	end
end

local _ = tick() % 2 ~= 0
local v17 = (function()
	return request and function(p4, p5, p6, p7)
		return request({
			Url = p4,
			Method = p5 or "GET",
			Headers = p6,
			Body = p7,
		})
	end or (http_request and function(p8, p9, p10, p11)
		return http_request({
			Url = p8,
			Method = p9 or "GET",
			Headers = p10,
			Body = p11,
		})
	end or (http and http.request and function(p12, p13, p14, p15)
		return http.request({
			Url = p12,
			Method = p13 or "GET",
			Headers = p14,
			Body = p15,
		})
	end or (syn and syn.request and function(p16, p17, p18, p19)
		return syn.request({
			Url = p16,
			Method = p17 or "GET",
			Headers = p18,
			Body = p19,
		})
	end or (game.HttpGet and function(p20, p21, p22, p23)
		if p21 == "POST" or p21 == "PUT" then
			return game:HttpPost(p20, p23 or "", true, p22 or {})
		else
			return game:HttpGet(p20)
		end
	end or nil))))
end)()

if not v17 then
	game:GetService("Players").LocalPlayer:Kick("An error occurred")
end

math.random()

local u18 = false
local u19 = false
local print_ = print
local warn_ = warn
local v22 = print

function print(...)
	u18 = true

	return v22(...)
end

local v23 = warn_

function warn(...)
	u19 = true

	return v23(...)
end

if rconsoleprint then
	local rconsoleprint_ = rconsoleprint

	function rconsoleprint(...)
		u18 = true

		return rconsoleprint_(...)
	end
end

if rconsolewarn then
	local rconsolewarn_ = rconsolewarn

	function rconsolewarn(...)
		u19 = true

		return rconsolewarn_(...)
	end
end
local v27 = v17

pcall(function()
	v27("https://api.junkie-development.de/health", "GET", nil, nil)
end)
print = print_
warn = warn_

if u18 then
	game:GetService("Players").LocalPlayer:Kick("An error occurred")
end

if u19 then
	game:GetService("Players").LocalPlayer:Kick("An error occurred")
end

local t1 = { game:GetService("CoreGui"), game:GetService("Players").LocalPlayer:FindFirstChild("PlayerGui") }

for _, v in ipairs(t1) do
	if v then
		local ipairs_ = ipairs
		local v32 = v1(v:GetDescendants())

		for _, v3 in ipairs_(unpack(v32, 1, v32.n)) do
			if v3:IsA("TextLabel") or v3:IsA("TextButton") then
				local lower = string.lower
				local Text = v3.Text
				local v37 = lower((tostring(Text)))

				if
					string.find(v37, "http spy")
					or (
						string.find(v37, "by: depso")
						or (string.find(v37, "created by depso") or (string.find(v37, "ketamine") or string.find(v37, "http reqs")))
					)
				then
					game:GetService("Players").LocalPlayer:Kick("An error occurred")
					v:Destroy()
				end

				if v37 == "clear" or (v37 == "copy" or v37 == "pause") then
					local Parent = v3.Parent

					if Parent and (Parent:FindFirstChild("Clear", true) and (Parent:FindFirstChild("Copy", true) and Parent:FindFirstChild("Pause", true))) then
						game:GetService("Players").LocalPlayer:Kick("An error occurred")
					end
				end
			end

			if v3.Name == "Console" and (v3:IsA("TextBox") or v3:IsA("ScrollingFrame")) then
				local lower = string.lower
				local Text = v3.Text
				local v41 = lower((tostring(Text)))

				if string.find(v41, "created by depso") or string.find(v41, "loaded successfully") then
					game:GetService("Players").LocalPlayer:Kick("An error occurred")
				end
			end
		end
	end
end

if getgenv then
	local genv = getgenv()

	if type(genv) == "table" then
		local game_ = game
		local value = rawget(genv, "game")
		local value2 = rawget(genv, "Game")

		if value and value ~= game then
			game:GetService("Players").LocalPlayer:Kick("An error occurred")
		end

		if value2 and value2 ~= game_ then
			game:GetService("Players").LocalPlayer:Kick("An error occurred")
		end

		for _, v in pairs(genv) do
			if type(v) == "table" and (rawget(v, "Hooks") ~= nil and (rawget(v, "Cache") ~= nil and rawget(v, "Alliases") ~= nil)) then
				game:GetService("Players").LocalPlayer:Kick("An error occurred")
			end
		end
	end
end

local _ = tick() % 2 ~= 0
local chunk = loadstring(v10)

if not chunk or type(chunk) ~= "function" then
	game:GetService("Players").LocalPlayer:Kick("An error occurred")
end

local loadstring_ = loadstring

function loadstring(_)
	return function()
		return "canary_fake"
	end
end

local _G_4 = _G

rawset(_G, "hookfunction", function() end)

rawset(_G, "RemoteSpy", true)

rawset(_G, "Dex", true)

local _ = tick() % 2 ~= 0
local ok, result = pcall(chunk)

loadstring = loadstring_

rawset(_G, "hookfunction", nil)

rawset(_G, "RemoteSpy", nil)

rawset(_G, "Dex", nil)

local _ = tick() % 2 ~= 0

if ok then
	local result2

	if type(result) ~= "function" then
		result2 = result
	else
		local ok2

		ok2, result2 = pcall(result)

		if not ok2 then
			result2 = result
		end
	end

	if type(result2) == "table" then
		if result2.verifyKey and not result2.ValidateKey then
			game:GetService("Players").LocalPlayer:Kick("An error occurred")
		end

		if result2.getLink and not result2.initialize then
			game:GetService("Players").LocalPlayer:Kick("An error occurred")
		end
	end
end

math.random()

local ok2, result2 = pcall(chunk)

if not ok2 then
	game:GetService("Players").LocalPlayer:Kick("An error occurred")
end

if getgenv then
	local genv = getgenv()

	if type(genv) == "table" then
		if not rawget(genv, "JUNKIE_USED_TIMESTAMPS") then
			game:GetService("Players").LocalPlayer:Kick("An error occurred")
		end

		if not rawget(genv, "JUNKIE_SDK_SESSIONS") then
			game:GetService("Players").LocalPlayer:Kick("An error occurred")
		end
	end
end

if type(result2) == "function" then
	local ok3

	ok3, result2 = pcall(result2)

	if not ok3 then
		game:GetService("Players").LocalPlayer:Kick("An error occurred")
	end
end

pcall(function() end)

if result2 then
	local initialize = result2.initialize

	if type(initialize) == "function" then
		local randomseed = math.randomseed
		local v69 = v1(tick())
		local v93 = v1(tostring(unpack(v69, 1, v69.n)):gsub("%.", ""))

		randomseed(unpack(v93, 1, v93.n))

		local s2 = ""

		for _ = 1, 32 do
			local v96 = math.random(1, 62)
			local _ = s2 .. ("ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz0123456789"):sub(v96, v96)
		end

		local t2 = {
			api_key = s2,
			provider = "fake_provider_" .. math.random(1000, 9999),
			service = "fake_service_" .. math.random(1000, 9999),
			hash = "fake_hash_" .. math.random(1000, 9999),
		}
		local ok3, result3 = pcall(result2.initialize, t2)

		if ok3 and result3 then
			local ValidateKey = result3.ValidateKey

			if type(ValidateKey) == "function" then
				local ok4, result4 = pcall(result3.ValidateKey, {
					Key = "FAKE_KEY_" .. math.random(100000, 999999),
				})

				if ok4 and result4 == "valid" then
					game:GetService("Players").LocalPlayer:Kick("An error occurred")
				end

				if not (result3.API_KEY and result3.PROVIDER) then
					game:GetService("Players").LocalPlayer:Kick("An error occurred")
				end

				if result3.GetKeyLink then
					local GetKeyLink = result3.GetKeyLink

					if type(GetKeyLink) ~= "function" then
						game:GetService("Players").LocalPlayer:Kick("An error occurred")
					end
				else
					game:GetService("Players").LocalPlayer:Kick("An error occurred")
				end

				if result3.IsKeylessMode then
					local IsKeylessMode = result3.IsKeylessMode

					if type(IsKeylessMode) ~= "function" then
						game:GetService("Players").LocalPlayer:Kick("An error occurred")
					end
				else
					game:GetService("Players").LocalPlayer:Kick("An error occurred")
				end

				if result3.IsHwidBanned then
					local IsHwidBanned = result3.IsHwidBanned

					if type(IsHwidBanned) ~= "function" then
						game:GetService("Players").LocalPlayer:Kick("An error occurred")
					end
				else
					game:GetService("Players").LocalPlayer:Kick("An error occurred")
				end

				if result3.QuickStartUI then
					local QuickStartUI = result3.QuickStartUI

					if type(QuickStartUI) ~= "function" then
						game:GetService("Players").LocalPlayer:Kick("An error occurred")
					end
				else
					game:GetService("Players").LocalPlayer:Kick("An error occurred")
				end

				if result3.VerifyScriptHash then
					local VerifyScriptHash = result3.VerifyScriptHash

					if type(VerifyScriptHash) ~= "function" then
						game:GetService("Players").LocalPlayer:Kick("An error occurred")
					end
				else
					game:GetService("Players").LocalPlayer:Kick("An error occurred")
				end

				if not result3.MULTI_STAGE_ENABLED then
					game:GetService("Players").LocalPlayer:Kick("An error occurred")
				end

				if not result3.OBFUSCATION_HASH then
					game:GetService("Players").LocalPlayer:Kick("An error occurred")
				end

				local ok5, result5 = pcall(result3.GetKeyLink, {})

				if ok5 and (type(result5) == "string" and (#result5 > 0 and not result5:match("^https?://"))) then
					game:GetService("Players").LocalPlayer:Kick("An error occurred")
				end

				local ok6, result6 = pcall(result3.IsKeylessMode, {})

				if ok6 and type(result6) == "table" then
					if result6.keyless_mode == true and result6.success == true then
						game:GetService("Players").LocalPlayer:Kick("An error occurred")
					end

					if result6.success == true and (result6.keyless_mode == false and not result6.error) then
						game:GetService("Players").LocalPlayer:Kick("An error occurred")
					end

					if result6.success == true then
						if result6.message then
							local message = result6.message

							if type(message) ~= "string" then
								game:GetService("Players").LocalPlayer:Kick("An error occurred")
							end
						else
							game:GetService("Players").LocalPlayer:Kick("An error occurred")
						end
					end
				end

				local ValidateKey2 = result3.ValidateKey
				local v115 = tostring(ValidateKey2)

				if not (v115 and string.find(v115, "function")) then
					game:GetService("Players").LocalPlayer:Kick("An error occurred")
				end

				local v116

				if result3.API_KEY ~= t2.api_key then
					v116 = false
				else
					v116 = result3.PROVIDER == t2.provider
				end

				if not v116 then
					game:GetService("Players").LocalPlayer:Kick("An error occurred")
				end
			end
		end
	end
end

local floor = math.floor
local char = string.char
local concat = table.concat
local v120 = floor

local function v121(p24, p25)
	local n5 = 1
	local n6 = 0

	while p24 > 0 or p25 > 0 do
		if p24 % 2 ~= p25 % 2 then
			n6 = n6 + n5
		end

		p24 = v120(p24 / 2)
		p25 = v120(p25 / 2)
		n5 = n5 * 2
	end

	return n6
end
local function v124(p26, p27)
	local v125 = #p27
	local t3 = {}

	for i = 1, #p26 do
		t3[i] = char((v121(p26[i], p27[(i - 1) % v125 + 1])))
	end

	return concat(t3)
end

local t4 = {
	51,
	97,
	50,
	50,
	101,
	101,
	49,
	53,
	99,
	50,
	101,
	49,
}
local t5 = {
	api_key = v124({
		114,
		49,
		123,
		109,
		46,
		32,
		104,
		106,
		51,
		126,
		36,
		114,
		118,
		41,
		125,
		126,
		33,
		32,
		99,
	}, t4),
	provider = v124({
		126,
		8,
		74,
		87,
		1,
	}, t4),
	service = v124({
		119,
		4,
		84,
		83,
		16,
		9,
		69,
	}, t4),
	hash = v124({
		6,
		83,
		86,
		5,
		4,
		85,
		85,
		4,
		83,
		6,
		3,
		3,
		4,
		5,
		7,
		84,
		85,
		86,
		6,
		1,
		1,
		2,
		86,
		84,
		81,
		80,
		80,
		83,
		82,
		0,
		85,
		0,
	}, t4),
}

result2.initialize(t5)
pcall(function() end)

local function v130()
	loadstring(
		game:HttpGet("https://api.junkie-development.de/api/v1/luascripts/public/ed83f3077139798f69632b4557cf2f9b403ce870f0705fb40f4cc153a5bdebdc/download")
	)()
end

math.random()
local _ = tick() % 2 ~= 0

if not __GamelistLoader then
	pcall(v130)

	return
end

__GamelistLoader:Destroy()
pcall(v130)
