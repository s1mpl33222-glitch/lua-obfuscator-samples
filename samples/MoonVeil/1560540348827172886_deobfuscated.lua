-- This file was generated at discord.gg/syncrypt

local function v1(...)
	local t1 = { ... }

	t1.n = select("#", ...)

	return t1
end

game:GetService("HttpService")

local RbxAnalyticsService = game:GetService("RbxAnalyticsService")
local Players = game:GetService("Players")
local u5 = Players

local function v6()
	local v52 = getgenv and getgenv() or _G
	local t2 = {
		"HttpSpy",
		"HTTPSpy",
		"httpspy",
		"__httpspy",
		"__httpSpy",
		"requestSpy",
		"RequestSpy",
		"SimpleSpy",
	}

	for _, v in ipairs(t2) do
		local ok, result = pcall(rawget, v52, v)

		if ok and result ~= nil then
			local LocalPlayer = u5.LocalPlayer

			if not LocalPlayer then
				error("HTTP spy detected")
			else
				LocalPlayer:Kick("HTTP spy detected")
			end
		end
	end
end

local u7 = Players

local function v8(p1, p2)
	local v63 = p1.Headers or (p1.headers or {})
	local v64 = string.lower(p2)

	for k, v in pairs(v63) do
		if v64 == string.lower((tostring(k))) then
			return (tostring(v))
		end
	end

	return nil
end

local u9 = Players

v6()

local v10 = (function()
	local v59 = getgenv and getgenv() or _G

	if not syn or not syn.request then
		if not http or not http.request then
			if not request then
				if not v59 or not v59.request then
					local LocalPlayer = u7.LocalPlayer

					if not LocalPlayer then
						error("Unsupported executor")

						return
					end

					LocalPlayer:Kick("Unsupported executor")

					return
				end

				return v59.request
			end

			return request
		end

		return http.request
	end

	return syn.request
end)()
local v11 = v1(RbxAnalyticsService:GetClientId())
local str = tostring(unpack(v11, 1, v11.n))
local t3 = {
	Url = ("https://universalloader.capsov.workers.dev/"):gsub("/+$", "") .. "/api/v1?key=kjhfJKSGDFHJGsyudftyuYSDUIFYTsudfghjsdvhjfghjDSGJK",
	Method = "GET",
}
local t4 = {
	hwid = str,
}
local PlaceId = game.PlaceId

t4["roblox-place-id"] = tostring(PlaceId)

local v30 = game.JobId or ""

t4["roblox-session-id"] = tostring(v30)
t3.Headers = t4

local v31 = v10(t3)
local v32 = v31 and (v31.StatusCode or (v31.Status or v31.status_code))

if v31 and tonumber(v32) == 200 then
	local v33 = v31.Body or ""
	local str2 = tostring(v33)
	local v35 = v8(v31, "x-payload-proof")
	local v36 = v8(v31, "x-payload-key")

	if not v35 or not v36 then
		local LocalPlayer = Players.LocalPlayer

		if not LocalPlayer then
			error("Missing integrity headers")
		else
			LocalPlayer:Kick("Missing integrity headers")
		end
	end

	local v38 = v8(v31, "x-payload-expected-proof")

	if not v38 then
		local LocalPlayer = Players.LocalPlayer

		if not LocalPlayer then
			error("Missing expected proof")
		else
			LocalPlayer:Kick("Missing expected proof")
		end
	end

	if string.lower(v35) ~= string.lower(v38) then
		local LocalPlayer = Players.LocalPlayer

		if not LocalPlayer then
			error("Payload proof mismatch")
		else
			LocalPlayer:Kick("Payload proof mismatch")
		end
	end

	v6()

	local v41 = (function(p3, p4)
		if type(p3) ~= "string" or #p3 % 2 ~= 0 then
			local LocalPlayer = u9.LocalPlayer

			if not LocalPlayer then
				error("Invalid payload format")
			else
				LocalPlayer:Kick("Invalid payload format")
			end
		end

		if type(p4) ~= "string" or #p4 % 2 ~= 0 then
			local LocalPlayer = u9.LocalPlayer

			if not LocalPlayer then
				error("Invalid key format")
			else
				LocalPlayer:Kick("Invalid key format")
			end
		end

		local v72 = #p4 / 2
		local t5 = {}
		local n1 = 0

		for i = 1, #p3, 2 do
			local v77 = p3:sub(i, i + 1)
			local num = tonumber(v77, 16)
			local v79 = n1 % v72 * 2 + 1
			local v80 = p4:sub(v79, v79 + 1)
			local num2 = tonumber(v80, 16)
			local v82 = #t5 + 1
			local v83 = bit32.bxor(num, num2)

			t5[v82] = string.char(v83)
			n1 = n1 + 1
		end

		return table.concat(t5)
	end)(str2, v36)
	local v42 = loadstring or load

	if not v42 then
		local LocalPlayer = Players.LocalPlayer

		if not LocalPlayer then
			error("loadstring unavailable")
		else
			LocalPlayer:Kick("loadstring unavailable")
		end
	end

	local v44, v45 = v42(v41)

	if not v44 then
		local v46 = "Load error: " .. tostring(v45)
		local LocalPlayer = Players.LocalPlayer

		if not LocalPlayer then
			error(v46)
		else
			LocalPlayer:Kick(v46)
		end
	end

	local v48 = v1(v44())

	return unpack(v48, 1, v48.n)
end

warn("Loader fetch failed:", v32)
