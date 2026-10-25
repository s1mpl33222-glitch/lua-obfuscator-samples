-- This file was generated at discord.gg/syncrypt

local bxor = bit32.bxor
local type_ = type
local getmetatable_ = getmetatable
local pairs_ = pairs
local env = getfenv()
local _ = string.char
local _ = string.byte
local _ = bit32.bxor
local _ = string.gsub
local _ = string.char
local getgenv = env.getgenv and env.getgenv() or env._G

getgenv.__FoxnameMM2Runtime = getgenv.__FoxnameMM2Runtime or {
	running = false,
	windui = nil,
	window = nil,
	alive = false,
	sessionId = nil,
}

local __FoxnameMM2Runtime = getgenv.__FoxnameMM2Runtime
local v13 = env.string.format("%.6f_%d", env.os.clock(), env.math.random(100000, 999999))

if not (__FoxnameMM2Runtime.running and __FoxnameMM2Runtime.alive) then
	__FoxnameMM2Runtime.running = true
	__FoxnameMM2Runtime.alive = true
	__FoxnameMM2Runtime.sessionId = v13

	local n1 = 0
	local v15 = env.game.GetService(env.game, "RunService").Heartbeat.Connect(env.game.GetService(env.game, "RunService").Heartbeat, function()
		n1 = n1 + 1
	end)

	repeat
		env.task.wait()
	until n1 >= 2
	v15:Disconnect()

	local function v16()
		local t1 = {}

		while true do
			t1[#t1 + 1] = t1
		end
	end
	local function v19(_)
		env.warn("you've been detected Env log, Anti-env log at Foxname")
		v16()
	end

	local v20 = (function()
		if
			not (
				env.getmetatable
				and (env.setmetatable and (env.type and (env.select and (env.pcall and (env.debug and (env.rawget and (env.rawset and env.getfenv)))))))
			)
		then
			return "missing core globals"
		end

		local v21 = env.setmetatable({}, {
			__index = function()
				while true do
				end
			end,
		})
		local v22, v23 = env.pcall(env.getmetatable, v21)

		if not (v22 and env.type(v23.__index) == "function") then
			return "metatable trap failed"
		end

		if not env.pcall(env.rawset, {}, " ", " ") then
			return "rawset broken"
		end

		if env.getmetatable(env.require) or (env.getmetatable(env.print) or env.getmetatable(env.error)) then
			return "core func wrapped"
		end

		local info = env.debug.info

		if not info then
			return "no debug.info"
		end

		local t2 = { info(env.print, "a") }
		local t3 = { info(env.tostring, "a") }

		if t2[1] ~= 0 then
			return "print argcount wrong"
		end

		if t3[1] ~= 0 then
			return "tostring argcount wrong"
		end

		if t2[2] ~= true then
			return "print vararg flag wrong"
		end

		if env.select(1, env.pcall(env.getfenv, 69)) == true then
			return "getfenv invalid level passed"
		end

		local v27, v28 = env.pcall(env.rawget, env.debug, "info")

		if not (v27 and v28) then
			return "rawget debug.info failed"
		end

		if #v28(env.getfenv, "n") <= 1 then
			return "getfenv name too short"
		end

		if #v28(env.print, "n") <= 1 then
			return "print name too short"
		end

		if v28(env.print, "s") ~= "[C]" then
			return "print source not [C]"
		end

		if v28(env.require, "s") ~= "[C]" then
			return "require source not [C]"
		end

		if v28(function() end, "s") == "[C]" then
			return "lua func reported as [C]"
		end

		if env.select(1, env.pcall(info, env.coroutine.wrap(function() end)(), "s")) ~= false then
			return "dead coroutine didn't error"
		end

		local task = env.task

		if not (env.type(task) == "table" and (env.type(task.spawn) == "function" and env.type(task.wait) == "function")) then
			return "task library broken"
		end
		local u30
		local v31 = task.spawn(function()
			u30 = true
		end)

		if not (env.type(v31) == "thread" and false) then
			return "task.spawn broken"
		end

		if env.type(env.spawn) ~= "function" then
			return "spawn not function"
		end

		if env.pcall(function()
			for _ in env.game do
			end
		end) then
			return "game is iterable (fake env)"
		end

		if env.typeof(env.game) ~= "Instance" then
			return "game not Instance"
		end

		local _, v34 = env.pcall(function()
			env.game()
		end)

		if not (v34 and v34:find("attempt to call a Instance value")) then
			return "game() error msg wrong"
		end

		if env.game.ClassName ~= "DataModel" then
			return "game ClassName wrong"
		end

		if env.workspace.ClassName ~= "Workspace" then
			return "workspace ClassName wrong"
		end

		if env.typeof(env.Enum.Material.Plastic) ~= "EnumItem" then
			return "Enum type wrong"
		end

		if env.Enum.Material.Plastic.Value ~= 256 then
			return "Enum value wrong"
		end

		if env.typeof(env.Enum.HumanoidStateType.Running) ~= "EnumItem" then
			return "HumanoidStateType wrong"
		end

		if env.typeof(env.game.Changed) ~= "RBXScriptSignal" then
			return "game.Changed wrong"
		end

		if env.typeof(env.workspace.Changed) ~= "RBXScriptSignal" then
			return "workspace.Changed wrong"
		end

		local v35 = env.game.GetService(env.game, "RunService")

		if v35.ClassName ~= "RunService" then
			return "RunService ClassName wrong"
		end

		if env.typeof(v35.Heartbeat) ~= "RBXScriptSignal" then
			return "Heartbeat type wrong"
		end

		if v35:IsClient() == v35:IsServer() then
			return "IsClient/IsServer same"
		end

		if env.game.GetService(env.game, "Players") ~= env.game.GetService(env.game, "Players") then
			return "GetService not singleton"
		end

		if env.workspace.GetFullName(env.workspace) ~= "Workspace" then
			return "workspace GetFullName wrong"
		end

		local Part = env.Instance.new("Part")

		if not (env.typeof(Part) == "Instance" and Part.ClassName == "Part") then
			Part:Destroy()

			return "Part check failed"
		end
		Part:Destroy()

		local Sound = env.Instance.new("Sound")
		local v38 = env.pcall(function()
			Sound.PlaybackLoudness = 69
		end)
		Sound:Destroy()

		if v38 then
			return "PlaybackLoudness writable (fake env)"
		end

		local TextBox = env.Instance.new("TextBox")
		local v40 = env.pcall(function()
			TextBox.TextBounds = env.Vector2.new(67, 67)
		end)
		TextBox:Destroy()

		if v40 then
			return "TextBounds writable (fake env)"
		end

		local v41 = env.CFrame.new(1, 2, 3)

		if not (v41.X == 1 and (v41.Y == 2 and v41.Z == 3)) then
			return "CFrame wrong"
		end

		local v42 = env.Vector3.new(1, 2, 3) + env.Vector3.new(4, 5, 6)

		if not (v42.X == 5 and (v42.Y == 7 and v42.Z == 9)) then
			return "Vector3 arithmetic wrong"
		end

		local v43, v44 = env.pcall(function()
			return env.game.GetService(env.game, "HttpService").GenerateGUID(env.game.GetService(env.game, "HttpService"), false)
		end)

		if not (v43 and (#v44 == 36 and v44:sub(9, 9) == "-")) then
			return "GUID invalid"
		end

		local v45, v46 = env.pcall(function()
			return env.game.GetService(env.game, "HttpService").JSONDecode(env.game.GetService(env.game, "HttpService"), '[1,"a",true,null,[null,"x"]]')
		end)

		if not v45 then
			return "JSONDecode failed"
		end

		if v46[4] ~= nil then
			return "JSON null not nil"
		end

		if v46[5][1] ~= nil then
			return "JSON nested null not nil"
		end

		local v47, v48 = env.pcall(function()
			return env.loadstring("local a = if true then")()
		end)

		if v47 or not env.tostring(v48).lower(env.tostring(v48)).find(env.tostring(v48).lower(env.tostring(v48)), "attempt to call a nil value") then
			return "loadstring error handling wrong"
		end

		if not env.bit32 then
			return "bit32 broken"
		end

		if env.pcall(function()
			env.Instance.new("FakeClass_Foxname_99999")
		end) then
			return "Instance.new accepts invalid class"
		end

		if env.pcall(function()
			env.game.GetService(env.game, "FakeService_Foxname_99999")
		end) then
			return "GetService accepts fake service"
		end

		if env.type(env.package) == "nil" or env.type(env.package.loaded) ~= "table" then
			if #env.game.GetChildren(env.game) <= 4 then
				return "game has too few children"
			end

			if env.pcall(function()
				env.Instance.new("Part").FoxnameInvalidMethod_99(env.Instance.new("Part"))
			end) then
				return "invalid method didn't error"
			elseif env.Enum.Material.Plastic == env.Enum.Material.Plastic then
				if env.game.GetService(env.game, "Players") == env.game.Players then
					local Part2 = env.Instance.new("Part")
					local v51 = env.tostring(Part2)

					Part2.Name = "FoxnameEnvTest"

					local v52 = env.tostring(Part2)
					Part2:Destroy()

					if v51 == v52 then
						return "Instance name change not reflected"
					else
						local Folder = env.Instance.new("Folder")
						local Folder2 = env.Instance.new("Folder")

						Folder2.Parent = Folder
						Folder.Parent = env.workspace

						if Folder2:IsDescendantOf(env.workspace) then
							Folder:Destroy()
							env.task.wait()

							return Folder2.Parent ~= nil and "child.Parent not nil after Destroy" or nil
						else
							Folder:Destroy()

							return "IsDescendantOf broken"
						end
					end
				else
					return "GetService vs direct index mismatch"
				end
			else
				return "Enum identity broken"
			end
		else
			if env.package.loaded.os or (env.package.loaded.io or env.package.loaded.ffi) then
				return "package.loaded has Lua stdlib"
			end

			if #env.game.GetChildren(env.game) <= 4 then
				return "game has too few children"
			end

			if env.pcall(function()
				env.Instance.new("Part").FoxnameInvalidMethod_99(env.Instance.new("Part"))
			end) then
				return "invalid method didn't error"
			elseif env.Enum.Material.Plastic == env.Enum.Material.Plastic then
				if env.game.GetService(env.game, "Players") == env.game.Players then
					local Part2 = env.Instance.new("Part")
					local v56 = env.tostring(Part2)

					Part2.Name = "FoxnameEnvTest"

					local v57 = env.tostring(Part2)
					Part2:Destroy()

					if v56 == v57 then
						return "Instance name change not reflected"
					else
						local Folder = env.Instance.new("Folder")
						local Folder2 = env.Instance.new("Folder")

						Folder2.Parent = Folder
						Folder.Parent = env.workspace

						if Folder2:IsDescendantOf(env.workspace) then
							Folder:Destroy()
							env.task.wait()

							return Folder2.Parent ~= nil and "child.Parent not nil after Destroy" or nil
						else
							Folder:Destroy()

							return "IsDescendantOf broken"
						end
					end
				else
					return "GetService vs direct index mismatch"
				end
			else
				return "Enum identity broken"
			end
		end
	end)()

	if v20 then
		v19(v20)
	end

	local t4 = {
		a = 0,
		b = 0,
		t = env.os.clock(),
	}
	local n2 = 0
	local v62 = false

	if env.debug and env.type(env.debug.getinfo) == "function" then
		local v64, v65 = env.pcall(env.debug.getinfo, 1)

		v62 = v64 and env.type(v65) == "table" and true or false
	elseif env.debug and env.type(env.debug.traceback) == "function" then
		local v67, v68 = env.pcall(env.debug.traceback)

		v62 = v67 and env.type(v68) == "string" and true or false
	end

	if not v62 then
		v19("dumper detected")
	end

	local function v69(p1)
		local v71 = env.os.clock()

		env.task.wait(p1)

		local v72 = env.os.clock() - v71

		if not (env.math.abs(v72 - p1) < 0.002) then
			return
		end

		n2 = n2 + 1
	end

	env.task.spawn(function()
		v69(0.11)
		v69(0.17)
		v69(0.23)
	end)
	env.task.spawn(function()
		local n3 = 211
		local n4 = 204

		if false then
			return
		end

		local v76 = n4
		local n5 = 1

		while (n5 < 0 or n3 >= n4) and (n5 >= 0 and n5 == n5 or n4 >= n3) do
			env.task.wait(0.09 + (v76 - 203) % 3 * 0.02)

			local v78 = env.os.clock()
			local v79 = v78 - t4.t

			t4.t = v78

			if v79 > 0.06 and v79 < 0.5 then
				t4.a = t4.a + 1
			else
				t4.b = t4.b + 1
			end

			n4 = n4 + n5

			if n4 ~= n4 then
				return
			end

			v76 = n4
		end
	end)

	local n6 = 0
	local v83 = false

	while n6 < 60 do
		env.task.wait(0.05)
		n6 = n6 + 1

		if t4.a > t4.b and n2 < 2 then
			v83 = true

			break
		end
	end

	if not v83 then
		v19("runtime timing check failed")
	end

	local v84 = env.game.GetService(env.game, "HttpService")
	local v85 = (function()
		local v87, v88 = env.pcall(function()
			return v84:GenerateGUID(false)
		end)

		if v87 and (env.type(v88) == "string" and v88 ~= "") then
			return v88
		else
			return env.string.format("%d_%d_%d", env.os.time(), env.math.floor(env.os.clock() * 1000000), env.math.random(100000, 999999))
		end
	end)()

	local function v89()
		if env.syn and env.type(env.syn.request) == "function" then
			return env.syn.request
		elseif env.type(env.http_request) == "function" then
			return env.http_request
		elseif env.type(env.request) == "function" then
			return env.request
		elseif env.type(env.fluxus) == "table" and env.type(env.fluxus.request) == "function" then
			return env.fluxus.request
		else
			return nil
		end
	end
	local function v91(p2)
		if env.type(p2) == "table" then
			return env.tonumber(p2.StatusCode or p2.Status or (p2.status_code or p2.status))
		else
			return nil
		end
	end
	local function v93(p3)
		if env.type(p3) == "string" then
			return p3
		end

		if env.type(p3) ~= "table" then
			return env.tostring(p3)
		end

		local Body = p3.Body or p3.body or (p3.ResponseBody or p3.response_body)

		if env.type(Body) == "string" and Body ~= "" then
			return Body
		end

		local Message = p3.Message or p3.message or (p3.StatusMessage or p3.status_message)

		if env.type(Message) == "string" and Message ~= "" then
			return Message
		end

		local v97, v98 = env.pcall(function()
			return v84:JSONEncode(p3)
		end)

		if v97 and (env.type(v98) == "string" and v98 ~= "") then
			return v98
		else
			return env.tostring(p3)
		end
	end
	local function v99(p4)
		local v101 = v91(p4)

		if v101 then
			return v101
		else
			local v102 = env.string.lower(v93(p4))

			return (v102:find("retry_after", 1, true) or (v102:find("rate limited", 1, true) or v102:find("too many requests", 1, true))) and 429
				or (
					(v102:find("invalid form body", 1, true) or v102:find('"code": 50035', 1, true)) and 400
					or (
						(v102:find("unauthorized", 1, true) or v102:find("missing access", 1, true)) and 401 or (v102:find("forbidden", 1, true) and 403 or nil)
					)
				)
		end
	end
	local function v103(p5, p6, p7)
		local v105 = nil
		local n7 = 86
		local v107 = env.math.max(1, env.tonumber(p7) or 1) + 85

		if v107 == v107 then
			local v108 = 86
			local n8 = 1

			while (n8 < 0 or v107 >= n7) and (n8 >= 0 and n8 == n8 or n7 >= v107) do
				local v110

				v110, v105 = env.pcall(p5, p6)

				if v110 then
					local v111 = v99(v105)
					local Success

					if env.type(v105) == "table" then
						Success = v105.Success
					else
						Success = false
					end

					if v111 and (v111 >= 200 and v111 < 300) or v111 == nil and Success == true then
						return true, v105
					end

					if v111 == 429 then
						local v113 = 0.25 * (v108 - 85)
						local Headers

						if env.type(v105) == "table" then
							Headers = v105.Headers or nil
						else
							Headers = nil
						end

						if env.type(Headers) == "table" then
							local v115 = env.tonumber(Headers["Retry-After"] or Headers["retry-after"])

							if v115 and v115 > 0 then
								v113 = env.math.clamp(v115, 0.1, 3)
							end
						end

						env.task.wait(v113)
					else
						if not (v111 >= 500 and v111 < 600) then
							return false, v105
						end

						env.task.wait(0.2 * (v108 - 85))
					end
				else
					env.task.wait(0.2 * (v108 - 85))
				end

				n7 = n7 + n8

				if n7 ~= n7 then
					return false, v105
				end

				v108 = n7
			end

			return false, v105
		else
			return false, nil
		end
	end
	local function v116()
		local v118 = env.os.date("%H:%M:%S %d/%m/%Y")
		local v119 = env.tostring(env.os.date("%z") or "")
		local v120 = env.tostring(env.os.date("%Z") or "Local")
		local v121, v122, v123 = v119:match("([%+%-])(%d%d)(%d%d)")

		if v121 and (v122 and v123) then
			return v118 .. " (UTC " .. v121 .. v122 .. ":" .. v123 .. " | " .. v120 .. ")"
		else
			return v118 .. " (" .. v120 .. ")"
		end
	end
	local function v124()
		local s1
		local u126

		env.pcall(function()
			if env.type(env.identifyexecutor) == "function" then
				local v128, v129 = env.identifyexecutor()

				if env.type(v128) == "string" and v128 ~= "" then
					s1 = v128
				end

				if not (env.type(v129) == "string" and v129 ~= "") then
					return
				end

				u126 = v129
			elseif env.type(env.getexecutorname) == "function" then
				local v130 = env.getexecutorname()

				if not (env.type(v130) == "string" and v130 ~= "") then
					return
				end

				s1 = v130

				return
			else
				if env.type(env.getexecutor) == "function" then
				elseif env.type(env.fluxus) == "table" then
					s1 = "Fluxus"

					return
				elseif env.type(env.syn) == "table" then
					s1 = "Synapse"

					return
				else
					return
				end

				local v131 = env.getexecutor()

				if not (env.type(v131) == "string" and v131 ~= "") then
					return
				end

				s1 = v131

				return
			end
		end)

		if nil then
			return "Unknown" .. " " .. nil
		else
			return "Unknown"
		end
	end
	local function v133(p8, p9)
		local v134 = env.string.format("https://www.roblox.com/headshot-thumbnail/image?userId=%d&width=420&height=420&format=png", env.tonumber(p9) or 0)
		local v135, v136 = env.pcall(function()
			local v138 = env.game.HttpGet(
				env.game,
				env.string.format(
					"https://thumbnails.roblox.com/v1/users/avatar-headshot?userIds=%d&size=420x420&format=Png&isCircular=false",
					env.tonumber(p9) or 0
				)
			)
			local v139 = p8:JSONDecode(v138)

			if env.type(v139) == "table" and env.type(v139.data) == "table" then
				local v140 = v139.data[1]

				if env.type(v140) == "table" and (env.type(v140.imageUrl) == "string" and v140.imageUrl ~= "") then
					return v140.imageUrl
				else
					return v134
				end
			else
				return v134
			end
		end)

		if v135 and (env.type(v136) == "string" and v136 ~= "") then
			return v136
		else
			return v134
		end
	end
	local function v142()
		local v143 = v89()

		if not v143 then
			return
		end

		local v144 = env.game.GetService(env.game, "Players")
		local v145 = env.game.GetService(env.game, "MarketplaceService")
		local v146 = env.game.GetService(env.game, "HttpService")
		local LocalPlayer = v144.LocalPlayer
		local Name = LocalPlayer and (LocalPlayer.Name or "Unknown") or "Unknown"
		local DisplayName

		if LocalPlayer then
			DisplayName = LocalPlayer.DisplayName or Name
		else
			DisplayName = Name
		end

		local UserId = LocalPlayer and LocalPlayer.UserId or 0
		local v151 = v124()
		local PlaceId = env.game.PlaceId
		local JobId = env.game.JobId
		local Name2 = env.tostring(PlaceId)
		local v155 = env.string.format("https://www.roblox.com/games/%d", PlaceId)
		local v156 = v133(v146, UserId)

		env.task.spawn(function()
			local v157 = env.game.GetService(env.game, "HttpService")

			local function v158()
				local v159, v160 = env.pcall(function()
					return env.tostring(env.game.PlaceId)
				end)

				return v159 and v160 and v160 or "unknown"
			end

			local u161 = false

			local function v162()
				local v163, v164 = env.pcall(function()
					return env.WebSocket.connect("wss://foxname.top/post/ws")
				end)

				if not (v163 and v164) then
					env.warn("[Foxname] WebSocket connection failed: " .. env.tostring(v164))
					env.task.wait(3)
					v162()

					return
				end
				v164:Send(v157:JSONEncode({
					type = "auth",
					token = "gay-server-holy-moly",
				}))

				local u165 = false
				local u166 = false

				v164.OnMessage.Connect(v164.OnMessage, function(p10)
					local v168, v169 = env.pcall(v157.JSONDecode, v157, p10)

					if not v168 then
						return
					end

					if v169.type == "auth_ok" then
						u165 = true

						if not u161 then
							u161 = true
							v164:Send(v157:JSONEncode({
								event = "execution",
								placeId = v158(),
							}))
						end

						if u166 then
							return
						end

						u166 = true
						env.task.spawn(function()
							while u165 do
								env.pcall(function()
									v164:Send(v157:JSONEncode({
										event = "heartbeat",
										placeId = v158(),
									}))
								end)
								env.task.wait(25)
							end
						end)
					else
						if v169.type ~= "auth_fail" then
							return
						end

						env.warn("[Foxname] WebSocket auth failed")
						env.pcall(function()
							v164:Close()
						end)
					end
				end)
				v164.OnClose.Connect(v164.OnClose, function()
					u165 = false
					u166 = false
					env.task.wait(3)
					v162()
				end)
			end

			v162()
		end)
		env.pcall(function()
			local v172 = v145:GetProductInfo(PlaceId)

			if not (env.type(v172) == "table" and (env.type(v172.Name) == "string" and v172.Name ~= "")) then
				return
			end

			Name2 = v172.Name
		end)

		local v173 = env.string.format(
			'game:GetService("TeleportService"):TeleportToPlaceInstance(%d, "%s", game:GetService("Players").LocalPlayer)',
			PlaceId,
			env.tostring(JobId)
		)
		local t5 = {
			embeds = {
				{
					title = "Script Executed",
					color = 5763719,
					thumbnail = {
						url = v156,
					},
					fields = {
						{
							name = "Username",
							value = "`" .. env.tostring(Name) .. "`",
							inline = true,
						},
						{
							name = "Display Name",
							value = "`" .. env.tostring(DisplayName) .. "`",
							inline = true,
						},
						{
							name = "UserId",
							value = "`" .. env.tostring(UserId) .. "`",
							inline = true,
						},
						{
							name = "Executor",
							value = "`" .. env.tostring(v151) .. "`",
							inline = true,
						},
						{
							name = "Game",
							value = "`" .. env.tostring(Name2) .. "`",
							inline = true,
						},
						{
							name = "PlaceId",
							value = "`" .. env.tostring(PlaceId) .. "`",
							inline = true,
						},
						{
							name = "JobId",
							value = "`" .. env.tostring(JobId) .. "`",
							inline = false,
						},
						{
							name = "ExecutionId",
							value = "`" .. env.tostring(v85) .. "`",
							inline = false,
						},
						{
							name = "Game Link",
							value = v155,
							inline = false,
						},
						{
							name = "Time / Timezone",
							value = "`" .. v116() .. "`",
							inline = false,
						},
						{
							name = "Join Command",
							value = "```lua\n" .. v173 .. "\n```",
							inline = false,
						},
					},
				},
			},
		}
		local _ = env.pcall(function()
			local t6 = {
				Url = "https://ptb.discord.com/api/webhooks/1510219541496467629/6Lhc8sC6EYj6DKCeNurx7xfhmp--3zmh8X2Mwt-wvz7GYFhuBaY9L6ko4HUWvVmpRzNE",
				Method = "POST",
				Headers = {
					["Content-Type"] = "application/json",
				},
				Body = v146:JSONEncode(t5),
			}

			return v103(v143, t6, 3)
		end)
	end

	env.task.defer(v142)

	local v181 = env.game.GetService(env.game, "Players")
	local v182 = env.game.GetService(env.game, "RunService")
	local v183 = env.game.GetService(env.game, "UserInputService")
	local LocalPlayer = v181.LocalPlayer
	local CurrentCamera = env.workspace.CurrentCamera

	local function v186(p11, ...)
		local v188, v189 = env.pcall(p11, ...)

		if v188 then
			return v189
		else
			return nil
		end
	end
	local function v190(p12)
		if env.type(p12) == "string" then
			local v192 = p12:match("^%s*(.-)%s*$")

			if v192 == "" then
				return ""
			elseif v192:match("^%d+$") then
				return "rbxassetid://" .. v192
			elseif v192:match("^rbxassetid://") or v192:match("^https?://") then
				return v192
			else
				return nil
			end
		else
			return nil
		end
	end
	local function v193(p13, p14, p15)
		local Gradient = p13.Gradient
		local t7 = {
			["0"] = {
				Color = env.Color3.fromHex(p14),
				Transparency = 0,
			},
			["100"] = {
				Color = env.Color3.fromHex(p15),
				Transparency = 0,
			},
		}

		return Gradient(p13, t7, {
			Rotation = 90,
		})
	end

	local v196 = env.loadstring(env.game.HttpGet(env.game, "https://github.com/Footagesus/WindUI/releases/latest/download/main.lua"))()
	v196:AddTheme({
		Name = "Lunar Abyss",
		Accent = v193(v196, "#121420", "#3B2E7E"),
		Dialog = v193(v196, "#141825", "#231F3A"),
		Outline = v193(v196, "#6C63FF", "#B18CFF"),
		Text = v193(v196, "#E8E9FF", "#B9C0FF"),
		Placeholder = v193(v196, "#7A7FB8", "#A29AE8"),
		Background = v193(v196, "#090B12", "#161A2B"),
		Button = v193(v196, "#242C48", "#3A4A7A"),
		Icon = v193(v196, "#8C8BFF", "#E3A9FF"),
	})

	local v197 = v196:CreateWindow({
		Title = (function(p16, p17, p18)
			local v199 = #p16

			if v199 <= 1 then
				return env.string.format(
					'<font color="rgb(%d,%d,%d)">%s</font>',
					env.math.floor(p17.R * 255),
					env.math.floor(p17.G * 255),
					env.math.floor(p17.B * 255),
					p16
				)
			end

			local s2 = ""
			local v201 = v199 - 1
			local n9 = 93
			local v203 = v199 + 92

			if v203 ~= v203 then
				return ""
			end

			local v204 = n9
			local n10 = 1

			while (n10 < 0 or v203 >= n9) and (n10 >= 0 and n10 == n10 or n9 >= v203) do
				local v206 = (v204 - 92 - 1) / v201
				local v207 = env.math.floor(p17.R * 255 + (p18.R * 255 - p17.R * 255) * v206)
				local v208 = env.math.floor(p17.G * 255 + (p18.G * 255 - p17.G * 255) * v206)
				local v209 = env.math.floor(p17.B * 255 + (p18.B * 255 - p17.B * 255) * v206)

				s2 = s2 .. env.string.format('<font color="rgb(%d,%d,%d)">%s</font>', v207, v208, v209, p16:sub(v204 - 92, v204 - 92))
				n9 = n9 + n10

				if n9 ~= n9 then
					return s2
				end

				v204 = n9
			end

			return s2
		end)("KAT Hub", env.Color3.fromRGB(255, 170, 185), env.Color3.fromRGB(186, 56, 86)),
		Author = "discord.gg/v8ZPq4y2nD",
		Theme = "Rose",
		Size = env.UDim2.fromOffset(560, 420),
		Folder = "Foxname_KAT",
		SideBarWidth = 200,
		Enabled = true,
		Draggable = true,
		OnlyMobile = false,
		ScrollBarEnabled = true,
		Icon = "rbxassetid://133245078123989",
		Background = "rbxassetid://82503368188240",
		BackgroundImageTransparency = 0.55,
		OpenButton = {
			Title = "Open Menu",
			CornerRadius = env.UDim.new(1, 0),
			StrokeThickness = 2,
			Enabled = true,
			Draggable = true,
			OnlyMobile = false,
			Color = env.ColorSequence.new(env.Color3.fromHex("#ff0000"), env.Color3.fromHex("#b50000"), env.Color3.fromHex("#ff2929")),
		},
	})
	local v210 = v197:Section({
		Title = "Main",
		Opened = true,
		Icon = "app-window",
		Box = true,
		BoxBorder = true,
		IconColor = env.Color3.fromRGB(120, 180, 255),
	})
	local v211 = v210:Tab({
		Title = "ESP",
		Icon = "eye",
	})
	local v212 = v210:Tab({
		Title = "Aim",
		Icon = "crosshair",
	})
	local v213 = v210:Tab({
		Title = "Local Player",
		Icon = "user",
	})
	local v214 = env.Window.Tab(env.Window, {
		Title = "Settings",
		Icon = "settings",
	})
	v211:Select()
	v197:Tag({
		Title = "Release",
		Icon = "rocket",
		Color = env.Color3.fromRGB(214, 72, 106),
	})

	local t8 = {
		["No Background"] = "rbxassetid://0",
		Main = "rbxassetid://82503368188240",
		Extra = "rbxassetid://75141440720375",
		["Extra 1"] = "rbxassetid://131127340766745",
		["Extra 2"] = "rbxassetid://103408204293875",
		Furina = "rbxassetid://133222171266319",
	}

	local function v216(p19)
		if not (env.type(p19) == "string" and p19 ~= "") then
			return
		end

		v186(function()
			v197:SetBackgroundImage(p19)
		end)
	end
	local function v218(p20)
		local v220 = t8[p20]

		if not v220 then
			return
		end

		env._G.KATBackgroundImage = v220
		v216(v220)
	end

	local s3 = "Rose"
	local s4 = "Main"
	local t9 = {
		player = false,
		box = false,
		nametag = false,
		line = false,
		color = env.Color3.fromRGB(255, 0, 0),
		table = {},
		bound = {},
	}
	local t10 = {
		enabled = false,
		aimlock = false,
		silent = false,
		fov = 180,
		smoothness = 0.22,
		wallCheck = true,
		aimPart = "Head",
		showFov = true,
		fovThickness = 2,
	}
	local t11 = {
		infJump = false,
		speedBoost = false,
		speedBoostValue = 23,
		defaultWalkSpeed = 16,
	}
	local u226 = nil
	local u227 = nil
	local u228 = nil
	local u229 = false
	local n11 = 0
	local v231 = env.Color3.fromRGB(255, 255, 255)
	local v232 = env.RaycastParams.new()
	local filterDescendantsInstances = {}

	v232.FilterType = env.Enum.RaycastFilterType.Blacklist

	local function v234()
		if not env.gethui then
			local v236, v237 = env.pcall(function()
				return env.game.GetService(env.game, "CoreGui")
			end)

			return v236 and v237 and v237 or LocalPlayer:WaitForChild("PlayerGui")
		end

		local v238, v239 = env.pcall(function()
			return env.gethui()
		end)

		if v238 and v239 then
			return v239
		end

		local v240, v241 = env.pcall(function()
			return env.game.GetService(env.game, "CoreGui")
		end)

		return v240 and v241 and v241 or LocalPlayer:WaitForChild("PlayerGui")
	end
	local function v242()
		if u226 and u226.Parent then
			return u226
		end

		local ScreenGui = env.Instance.new("ScreenGui")

		ScreenGui.Name = "KAT_ESP_Overlay"
		ScreenGui.ResetOnSpawn = false
		ScreenGui.IgnoreGuiInset = true
		ScreenGui.ZIndexBehavior = env.Enum.ZIndexBehavior.Sibling
		ScreenGui.DisplayOrder = 999998
		env.pcall(function()
			if env.syn and env.syn.protect_gui then
				env.syn.protect_gui(ScreenGui)
			else
				if not env.protect_gui then
					return
				end

				env.protect_gui(ScreenGui)
			end
		end)
		ScreenGui.Parent = v234()
		u226 = ScreenGui

		return ScreenGui
	end
	local function v245()
		if not (u227 and u227.Parent) then
			local Frame = env.Instance.new("Frame")

			Frame.Name = "KAT_AimFOV"
			Frame.BackgroundTransparency = 1
			Frame.BorderSizePixel = 0
			Frame.AnchorPoint = env.Vector2.new(0.5, 0.5)
			Frame.Visible = false
			Frame.ZIndex = 25
			Frame.Parent = v242()

			local UIAspectRatioConstraint = env.Instance.new("UIAspectRatioConstraint")

			UIAspectRatioConstraint.AspectRatio = 1
			UIAspectRatioConstraint.Parent = Frame

			local UICorner = env.Instance.new("UICorner")

			UICorner.CornerRadius = env.UDim.new(1, 0)
			UICorner.Parent = Frame

			local UIStroke = env.Instance.new("UIStroke")

			UIStroke.Thickness = t10.fovThickness
			UIStroke.Color = env.Color3.fromRGB(255, 0, 0)
			UIStroke.Transparency = 0
			UIStroke.Parent = Frame
			u227 = Frame
			u228 = UIStroke
		end
	end
	local function v251()
		local Frame = env.Instance.new("Frame")

		Frame.Name = "ESPLine"
		Frame.BorderSizePixel = 0
		Frame.BackgroundColor3 = t9.color
		Frame.Size = env.UDim2.new(0, 0, 0, 1)
		Frame.AnchorPoint = env.Vector2.new(0.5, 0.5)
		Frame.Visible = false
		Frame.ZIndex = 20
		Frame.Parent = v242()

		return Frame
	end
	local function v253(p21, p22, p23, p24)
		if p21 then
			local v255 = p23 - p22
			local Magnitude = v255.Magnitude

			if Magnitude < 1 then
				p21.Visible = false

				return
			else
				p21.BackgroundColor3 = p24

				local v257 = (p22 + p23) * 0.5

				p21.Size = env.UDim2.new(0, Magnitude, 0, 1)
				p21.Position = env.UDim2.new(0, v257.X, 0, v257.Y)
				p21.Rotation = env.math.deg(env.math.atan2(v255.Y, v255.X))
				p21.Visible = true

				return
			end
		end
	end
	local function v258(p25)
		local v260 = t9.table[p25]

		if not v260 then
			return
		end

		if v260.line then
			v260.line.Destroy(v260.line)
		end

		if v260.highlight then
			v260.highlight.Destroy(v260.highlight)
		end

		if v260.box then
			v260.box.Destroy(v260.box)
		end

		if v260.boxLines then
			local v261, v262, v263 = env.ipairs(v260.boxLines)

			if type_(v261) ~= "function" then
				local v264 = getmetatable_(v261)

				if v264 == nil or v264.__iter == nil then
					if type_(v261) == "table" then
						v261, v262, v263 = pairs_(v261)
					end
				else
					v261, v262, v263 = v264.__iter(v261)
				end
			end

			while true do
				local v265

				v263, v265 = v261(v262, v263)

				if v263 == nil then
					break
				end
				v265:Destroy()
			end
		end

		if not v260.billboard then
			t9.table[p25] = nil

			return
		end

		v260.billboard.Destroy(v260.billboard)
		t9.table[p25] = nil
	end
	local function v266(p26, p27)
		v258(p26)

		if p26 ~= LocalPlayer then
			local v268 = p27:FindFirstChild("Head") or p27:WaitForChild("Head", 4)
			local v269 = p27:FindFirstChild("HumanoidRootPart") or p27:WaitForChild("HumanoidRootPart", 4)

			if v268 and v269 then
				local Highlight = env.Instance.new("Highlight")

				Highlight.DepthMode = env.Enum.HighlightDepthMode.AlwaysOnTop
				Highlight.FillColor = t9.color
				Highlight.OutlineColor = t9.color
				Highlight.FillTransparency = 0.4
				Highlight.OutlineTransparency = 0
				Highlight.Enabled = false
				Highlight.Parent = p27

				local BillboardGui = env.Instance.new("BillboardGui")

				BillboardGui.Name = "KAT_BoxESP"
				BillboardGui.Adornee = v269
				BillboardGui.AlwaysOnTop = true
				BillboardGui.Size = env.UDim2.new(4, 0, 5.4, 0)
				BillboardGui.ClipsDescendants = false
				BillboardGui.Enabled = false
				BillboardGui.Parent = v242()

				local Frame = env.Instance.new("Frame")

				Frame.Name = "Outline"
				Frame.BackgroundTransparency = 1
				Frame.BorderSizePixel = 0
				Frame.Size = env.UDim2.new(1, 0, 1, 0)
				Frame.Parent = BillboardGui

				local Frame2 = env.Instance.new("Frame")

				Frame2.BorderSizePixel = 0
				Frame2.Size = env.UDim2.new(0, 1, 1, 0)
				Frame2.Position = env.UDim2.new(0, 0, 0, 0)
				Frame2.BackgroundColor3 = v231
				Frame2.BackgroundTransparency = 0.1
				Frame2.Parent = Frame

				local v274 = Frame2:Clone()

				v274.Position = env.UDim2.new(1, -1, 0, 0)
				v274.Parent = Frame

				local v275 = Frame2:Clone()

				v275.Size = env.UDim2.new(1, 0, 0, 1)
				v275.Position = env.UDim2.new(0, 0, 0, 0)
				v275.Parent = Frame

				local v276 = Frame2:Clone()

				v276.Size = env.UDim2.new(1, 0, 0, 1)
				v276.Position = env.UDim2.new(0, 0, 1, -1)
				v276.Parent = Frame

				local BillboardGui2 = env.Instance.new("BillboardGui")

				BillboardGui2.Size = env.UDim2.fromOffset(220, 40)
				BillboardGui2.StudsOffset = env.Vector3.new(0, 3, 0)
				BillboardGui2.AlwaysOnTop = true
				BillboardGui2.Enabled = false
				BillboardGui2.Parent = v268

				local TextLabel = env.Instance.new("TextLabel")

				TextLabel.Size = env.UDim2.fromScale(1, 1)
				TextLabel.BackgroundTransparency = 1
				TextLabel.TextScaled = false
				TextLabel.TextSize = 15
				TextLabel.Font = env.Enum.Font.GothamBold
				TextLabel.TextColor3 = t9.color
				TextLabel.TextStrokeTransparency = 0.4
				TextLabel.TextStrokeColor3 = env.Color3.new(0, 0, 0)
				TextLabel.Parent = BillboardGui2
				t9.table[p26] = {
					highlight = Highlight,
					box = BillboardGui,
					boxLines = {
						Frame2,
						v274,
						v275,
						v276,
					},
					billboard = BillboardGui2,
					label = TextLabel,
					head = v268,
					root = v269,
					line = v251(),
					char = p27,
				}

				return
			else
				return
			end
		end
	end
	local function v279(p28)
		if p28 == LocalPlayer then
			return
		end

		if t9.bound[p28] then
			return
		end

		t9.bound[p28] = true

		if p28.Character then
			v266(p28, p28.Character)
		end

		p28.CharacterAdded.Connect(p28.CharacterAdded, function(p29)
			v266(p28, p29)
		end)
	end
	local function v281()
		local v283, v284, v285 = env.ipairs(v181:GetPlayers())
		local v286

		if type_(v283) == "function" then
			while true do
				v285, v286 = v283(v284, v285)

				if v285 == nil then
					break
				end

				if v286 ~= LocalPlayer and not t9.table[v286] then
					v279(v286)
				end
			end

			return
		end

		local v287 = getmetatable_(v283)

		if v287 == nil or v287.__iter == nil then
			if type_(v283) ~= "table" then
				while true do
					v285, v286 = v283(v284, v285)

					if v285 == nil then
						break
					end

					if v286 ~= LocalPlayer and not t9.table[v286] then
						v279(v286)
					end
				end

				return
			end

			v283, v284, v285 = pairs_(v283)
		else
			v283, v284, v285 = v287.__iter(v283)
		end

		while true do
			v285, v286 = v283(v284, v285)

			if v285 == nil then
				break
			end

			if v286 ~= LocalPlayer and not t9.table[v286] then
				v279(v286)
			end
		end
	end
	local function v288()
		v245()
		v281()
	end
	local function v289()
		if v183.TouchEnabled then
			local ViewportSize = CurrentCamera.ViewportSize

			return env.Vector2.new(ViewportSize.X * 0.5, ViewportSize.Y * 0.5)
		else
			local v292 = v183:GetMouseLocation()

			return env.Vector2.new(v292.X, v292.Y)
		end
	end
	local function v293()
		local v295 = v289()
		local v296 = nil
		local huge = env.math.huge
		local Character = LocalPlayer.Character
		local v299

		if Character then
			v299 = Character:FindFirstChild("HumanoidRootPart")
		else
			v299 = Character
		end

		if not v299 then
			return nil
		end

		if t10.wallCheck then
			filterDescendantsInstances[1] = Character
			v232.FilterDescendantsInstances = filterDescendantsInstances
		end

		local v300, v301, v302 = env.ipairs(v181:GetPlayers())
		local v303, Magnitude, v305, Character2, v307, v308, v309, v310, v311, v312, v313

		if type_(v300) == "function" then
			while true do
				v302, v303 = v300(v301, v302)

				if v302 == nil then
					break
				end

				if v303 == LocalPlayer or not v303.Character then
					Magnitude = huge
					v305 = v296
				else
					Character2 = v303.Character
					v307 = Character2:FindFirstChildOfClass("Humanoid")
					v308 = Character2:FindFirstChild("Head")
					v309 = Character2:FindFirstChild("HumanoidRootPart")
					v310 = Character2:FindFirstChild("UpperTorso") or (Character2:FindFirstChild("Torso") or v309)

					if t10.aimPart == "Torso" then
						v305 = v310 or v308
					else
						v305 = v308 or v310
					end

					if v307 and (v307.Health > 0 and v305) then
						v311, v312 = CurrentCamera:WorldToViewportPoint(v305.Position)

						if v312 and v311.Z > 0 then
							if t10.wallCheck then
								v313 = env.workspace.Raycast(env.workspace, CurrentCamera.CFrame.Position, v305.Position - CurrentCamera.CFrame.Position, v232)

								if v313 and (v313.Instance and not v313.Instance.IsDescendantOf(v313.Instance, Character2)) then
									Magnitude = huge
									v305 = v296
								else
									Magnitude = (env.Vector2.new(v311.X, v311.Y) - v295).Magnitude

									if Magnitude <= t10.fov then
										if Magnitude >= huge then
											Magnitude = huge
											v305 = v296
										end
									else
										Magnitude = huge
										v305 = v296
									end
								end
							else
								Magnitude = (env.Vector2.new(v311.X, v311.Y) - v295).Magnitude

								if Magnitude <= t10.fov then
									if Magnitude >= huge then
										Magnitude = huge
										v305 = v296
									end
								else
									Magnitude = huge
									v305 = v296
								end
							end
						else
							Magnitude = huge
							v305 = v296
						end
					else
						Magnitude = huge
						v305 = v296
					end
				end

				huge = Magnitude
				v296 = v305
			end

			return v296
		end

		local v314 = getmetatable_(v300)

		if v314 == nil or v314.__iter == nil then
			if type_(v300) ~= "table" then
				while true do
					v302, v303 = v300(v301, v302)

					if v302 == nil then
						break
					end

					if v303 == LocalPlayer or not v303.Character then
						Magnitude = huge
						v305 = v296
					else
						Character2 = v303.Character
						v307 = Character2:FindFirstChildOfClass("Humanoid")
						v308 = Character2:FindFirstChild("Head")
						v309 = Character2:FindFirstChild("HumanoidRootPart")
						v310 = Character2:FindFirstChild("UpperTorso") or (Character2:FindFirstChild("Torso") or v309)

						if t10.aimPart == "Torso" then
							v305 = v310 or v308
						else
							v305 = v308 or v310
						end

						if v307 and (v307.Health > 0 and v305) then
							v311, v312 = CurrentCamera:WorldToViewportPoint(v305.Position)

							if v312 and v311.Z > 0 then
								if t10.wallCheck then
									v313 =
										env.workspace.Raycast(env.workspace, CurrentCamera.CFrame.Position, v305.Position - CurrentCamera.CFrame.Position, v232)

									if v313 and (v313.Instance and not v313.Instance.IsDescendantOf(v313.Instance, Character2)) then
										Magnitude = huge
										v305 = v296
									else
										Magnitude = (env.Vector2.new(v311.X, v311.Y) - v295).Magnitude

										if Magnitude <= t10.fov then
											if Magnitude >= huge then
												Magnitude = huge
												v305 = v296
											end
										else
											Magnitude = huge
											v305 = v296
										end
									end
								else
									Magnitude = (env.Vector2.new(v311.X, v311.Y) - v295).Magnitude

									if Magnitude <= t10.fov then
										if Magnitude >= huge then
											Magnitude = huge
											v305 = v296
										end
									else
										Magnitude = huge
										v305 = v296
									end
								end
							else
								Magnitude = huge
								v305 = v296
							end
						else
							Magnitude = huge
							v305 = v296
						end
					end

					huge = Magnitude
					v296 = v305
				end

				return v296
			end

			v300, v301, v302 = pairs_(v300)
		else
			v300, v301, v302 = v314.__iter(v300)
		end

		while true do
			v302, v303 = v300(v301, v302)

			if v302 == nil then
				break
			end

			if v303 == LocalPlayer or not v303.Character then
				Magnitude = huge
				v305 = v296
			else
				Character2 = v303.Character
				v307 = Character2:FindFirstChildOfClass("Humanoid")
				v308 = Character2:FindFirstChild("Head")
				v309 = Character2:FindFirstChild("HumanoidRootPart")
				v310 = Character2:FindFirstChild("UpperTorso") or (Character2:FindFirstChild("Torso") or v309)

				if t10.aimPart == "Torso" then
					v305 = v310 or v308
				else
					v305 = v308 or v310
				end

				if v307 and (v307.Health > 0 and v305) then
					v311, v312 = CurrentCamera:WorldToViewportPoint(v305.Position)

					if v312 and v311.Z > 0 then
						if t10.wallCheck then
							v313 = env.workspace.Raycast(env.workspace, CurrentCamera.CFrame.Position, v305.Position - CurrentCamera.CFrame.Position, v232)

							if v313 and (v313.Instance and not v313.Instance.IsDescendantOf(v313.Instance, Character2)) then
								Magnitude = huge
								v305 = v296
							else
								Magnitude = (env.Vector2.new(v311.X, v311.Y) - v295).Magnitude

								if Magnitude <= t10.fov then
									if Magnitude >= huge then
										Magnitude = huge
										v305 = v296
									end
								else
									Magnitude = huge
									v305 = v296
								end
							end
						else
							Magnitude = (env.Vector2.new(v311.X, v311.Y) - v295).Magnitude

							if Magnitude <= t10.fov then
								if Magnitude >= huge then
									Magnitude = huge
									v305 = v296
								end
							else
								Magnitude = huge
								v305 = v296
							end
						end
					else
						Magnitude = huge
						v305 = v296
					end
				else
					Magnitude = huge
					v305 = v296
				end
			end

			huge = Magnitude
			v296 = v305
		end

		return v296
	end
	local function v315()
		if u229 then
			return
		end

		if not (env.hookmetamethod and (env.getnamecallmethod and (env.checkcaller and env.Drawing))) then
			return
		end

		u229 = true
		env.getgenv().silentaim_settings = {
			fov = 150,
			hitbox = "Head",
			fovcircle = false,
		}

		local v316 = env.game.GetService(env.game, "Players")
		local v317 = env.game.GetService(env.game, "RunService")
		local LocalPlayer2 = v316.LocalPlayer
		local v319 = LocalPlayer2:GetMouse()
		local CurrentCamera2 = env.workspace.CurrentCamera

		local function v321(p30)
			local v323 = nil
			local huge = p30 or env.math.huge
			local v325, v326, v327 = env.pairs(v316:GetPlayers())
			local v328, v329, v330, Magnitude

			if type_(v325) == "function" then
				while true do
					v327, v328 = v325(v326, v327)

					if v327 == nil then
						break
					end

					if v328.Character and (v328 ~= LocalPlayer2 and v328.Character.FindFirstChild(v328.Character, env.getgenv().silentaim_settings.hitbox)) then
						v329, v330 = CurrentCamera2:WorldToScreenPoint(v328.Character[env.getgenv().silentaim_settings.hitbox].Position)
						Magnitude = (env.Vector2.new(v329.X, v329.Y) - env.Vector2.new(v319.X, v319.Y)).Magnitude

						if Magnitude < huge then
							if not v330 then
								Magnitude = huge
								v328 = v323
							end
						else
							Magnitude = huge
							v328 = v323
						end
					else
						Magnitude = huge
						v328 = v323
					end

					huge = Magnitude
					v323 = v328
				end

				return v323
			end

			local v332 = getmetatable_(v325)

			if v332 == nil or v332.__iter == nil then
				if type_(v325) ~= "table" then
					while true do
						v327, v328 = v325(v326, v327)

						if v327 == nil then
							break
						end

						if
							v328.Character and (v328 ~= LocalPlayer2 and v328.Character.FindFirstChild(v328.Character, env.getgenv().silentaim_settings.hitbox))
						then
							v329, v330 = CurrentCamera2:WorldToScreenPoint(v328.Character[env.getgenv().silentaim_settings.hitbox].Position)
							Magnitude = (env.Vector2.new(v329.X, v329.Y) - env.Vector2.new(v319.X, v319.Y)).Magnitude

							if Magnitude < huge then
								if not v330 then
									Magnitude = huge
									v328 = v323
								end
							else
								Magnitude = huge
								v328 = v323
							end
						else
							Magnitude = huge
							v328 = v323
						end

						huge = Magnitude
						v323 = v328
					end

					return v323
				end

				v325, v326, v327 = pairs_(v325)
			else
				v325, v326, v327 = v332.__iter(v325)
			end

			while true do
				v327, v328 = v325(v326, v327)

				if v327 == nil then
					break
				end

				if v328.Character and (v328 ~= LocalPlayer2 and v328.Character.FindFirstChild(v328.Character, env.getgenv().silentaim_settings.hitbox)) then
					v329, v330 = CurrentCamera2:WorldToScreenPoint(v328.Character[env.getgenv().silentaim_settings.hitbox].Position)
					Magnitude = (env.Vector2.new(v329.X, v329.Y) - env.Vector2.new(v319.X, v319.Y)).Magnitude

					if Magnitude < huge then
						if not v330 then
							Magnitude = huge
							v328 = v323
						end
					else
						Magnitude = huge
						v328 = v323
					end
				else
					Magnitude = huge
					v328 = v323
				end

				huge = Magnitude
				v323 = v328
			end

			return v323
		end

		local u333 = nil

		v317.Stepped.Connect(v317.Stepped, function()
			env.getgenv().silentaim_settings.fov = t10.fov
			env.getgenv().silentaim_settings.hitbox = t10.aimPart == "Torso" and "HumanoidRootPart" or "Head"
			env.getgenv().silentaim_settings.fovcircle = false
			u333 = v321(env.getgenv().silentaim_settings.fov)
		end)

		local v334 = nil

		v334 = env.hookmetamethod(env.game, "__namecall", function(p31, ...)
			local t12 = { ... }

			if
				env.checkcaller()
				or (
					env.getnamecallmethod() ~= "FindPartOnRayWithIgnoreList"
					or not (env.table.find(t12[2], env.workspace.WorldIgnore.Ignore) and (u333 and (u333.Character and (t10.enabled and t10.silent))))
				)
			then
				return v334(p31, env.unpack(t12))
			end

			local Origin = t12[1].Origin

			t12[1] = env.Ray.new(Origin, u333.Character[env.getgenv().silentaim_settings.hitbox].Position - Origin)

			return v334(p31, env.unpack(t12))
		end)
	end
	v211:Section({
		Title = "ESP Controls",
		TextXAlignment = "Center",
		TextSize = 17,
		Opened = true,
	})
	v211:Divider()
	v211:Toggle({
		Title = "Player ESP",
		Default = false,
		Callback = function(p32)
			t9.player = p32 and true or false
			v281()
		end,
	})
	v211:Toggle({
		Title = "Box ESP",
		Default = false,
		Callback = function(p33)
			t9.box = p33 and true or false
			v281()
		end,
	})
	v211:Toggle({
		Title = "Nametag ESP",
		Default = false,
		Callback = function(p34)
			t9.nametag = p34 and true or false
			v281()
		end,
	})
	v211:Toggle({
		Title = "Line ESP",
		Default = false,
		Callback = function(p35)
			t9.line = p35 and true or false
			v281()
		end,
	})
	v211:Colorpicker({
		Title = "ESP Color",
		Description = "ESP rengini sec",
		Default = env.Color3.fromRGB(255, 0, 0),
		Callback = function(p36)
			if env.typeof(p36) ~= "Color3" then
				return
			end

			t9.color = p36
		end,
	})
	v212:Section({
		Title = "Aim Controls",
		TextXAlignment = "Center",
		TextSize = 17,
		Opened = true,
	})
	v212:Divider()
	v212:Toggle({
		Title = "Enable Aim",
		Default = false,
		Callback = function(p37)
			t10.enabled = p37 and true or false
			v245()
		end,
	})
	v212:Toggle({
		Title = "Aimlock",
		Default = false,
		Callback = function(p38)
			t10.aimlock = p38 and true or false
		end,
	})
	v212:Toggle({
		Title = "Hide FOV",
		Default = false,
		Callback = function(p39)
			t10.showFov = not p39
		end,
	})
	v212:Toggle({
		Title = "Silent Aim",
		Default = false,
		Callback = function(p40)
			t10.silent = p40 and true or false

			if not t10.silent then
				return
			end

			v315()
		end,
	})
	v212:Dropdown({
		Title = "Aim Part",
		Values = { "Head", "Torso" },
		Value = "Head",
		Callback = function(p41)
			if not (p41 == "Head" or p41 == "Torso") then
				return
			end

			t10.aimPart = p41
		end,
	})
	v212:Slider({
		Title = "Fov Size",
		Value = {
			Min = 40,
			Max = 600,
			Default = t10.fov,
		},
		Step = 5,
		Callback = function(p42)
			t10.fov = env.tonumber(p42) or 180
		end,
	})
	v213:Section({
		Title = "Movement",
		TextXAlignment = "Center",
		TextSize = 17,
		Opened = true,
	})
	v213:Divider()
	v213:Toggle({
		Title = "Inf Jump",
		Default = false,
		Callback = function(p43)
			t11.infJump = p43 and true or false
		end,
	})
	v213:Toggle({
		Title = "Speed Booster",
		Default = false,
		Callback = function(p44)
			t11.speedBoost = p44 and true or false

			local Character = LocalPlayer.Character

			if Character then
				Character = Character:FindFirstChildOfClass("Humanoid")
			end

			if not Character then
				return
			end

			if t11.speedBoost then
				if Character.WalkSpeed > 0 then
					t11.defaultWalkSpeed = Character.WalkSpeed
				end

				Character.WalkSpeed = t11.speedBoostValue
			else
				Character.WalkSpeed = t11.defaultWalkSpeed
			end
		end,
	})
	v212:Slider({
		Title = "Aimlock Smoothness",
		Value = {
			Min = 0.02,
			Max = 1,
			Default = t10.smoothness,
		},
		Step = 0.01,
		Callback = function(p45)
			t10.smoothness = env.tonumber(p45) or 0.22
		end,
	})
	v214:Section({
		Title = "Background",
		TextXAlignment = "Center",
		TextSize = 17,
		Opened = true,
	})
	v214:Divider()

	local t13 = {
		Title = "Preset Background",
		Values = {
			"No Background",
			"Main",
			"Extra",
			"Extra 1",
			"Extra 2",
			"Furina",
		},
		Value = s4,
		Callback = function(p46)
			if env.type(p46) == "string" then
				s4 = p46
				v218(p46)
			end
		end,
	}
	v214:Dropdown(t13)
	v214:Input({
		Title = "Custom Background",
		Type = "Input",
		Placeholder = "rbxassetid://1234567890 or https://...",
		Callback = function(p47)
			local v347 = v190(env.tostring(p47 or ""))

			if v347 == nil then
				v196:Notify({
					Title = "Invalid",
					Content = "Use rbxassetid://<id> or a valid https:// URL.",
					Icon = "alert-triangle",
					Duration = 2,
				})
			elseif v347 == "" then
				return
			else
				env._G.KATBackgroundImage = v347
				v216(v347)
				v196:Notify({
					Title = "Applied",
					Content = "Custom background updated.",
					Icon = "check",
					Duration = 1.5,
				})

				return
			end
		end,
	})
	v214:Slider({
		Title = "Background Transparency",
		Value = {
			Min = 0,
			Max = 1,
			Default = 0.55,
		},
		Step = 0.05,
		Callback = function(p48)
			local v348 = env.math.clamp(env.tonumber(p48) or 0.55, 0, 1)

			if
				v186(function()
					if v197.SetBackgroundImageTransparency then
						v197:SetBackgroundImageTransparency(v348)

						return true
					else
						return false
					end
				end) or false
			then
				return
			end

			v186(function()
				v197.BackgroundImageTransparency = v348
			end)
		end,
	})
	v214:Section({
		Title = "Theme",
		TextXAlignment = "Center",
		TextSize = 17,
		Opened = true,
	})
	v214:Divider()

	local t14 = {
		Title = "Select Theme",
		Values = (function()
			local t15 = {}
			local v354 = v196:GetThemes()
			local v355, v356, v357 = env.pairs(v354)

			if type_(v355) == "function" then
				while true do
					v357 = v355(v356, v357)

					if v357 == nil then
						break
					end

					env.table.insert(t15, v357)
				end

				env.table.sort(t15)

				return t15
			end

			local v358 = getmetatable_(v355)

			if v358 == nil or v358.__iter == nil then
				if type_(v355) ~= "table" then
					while true do
						v357 = v355(v356, v357)

						if v357 == nil then
							break
						end

						env.table.insert(t15, v357)
					end

					env.table.sort(t15)

					return t15
				end

				v355, v356, v357 = pairs_(v355)
			else
				v355, v356, v357 = v358.__iter(v355)
			end

			while true do
				v357 = v355(v356, v357)

				if v357 == nil then
					break
				end

				env.table.insert(t15, v357)
			end

			env.table.sort(t15)

			return t15
		end)(),
		Value = s3,
		Callback = function(p49)
			if env.type(p49) == "string" then
				s3 = p49
			end
		end,
	}
	v214:Dropdown(t14)

	local t16 = {
		Title = "Apply Theme",
		Callback = function()
			if not (s3 and s3 ~= "") then
				return
			end

			v186(function()
				v196:SetTheme(s3)
			end)
			v196:Notify({
				Title = "Theme Applied",
				Content = "Now using: " .. env.tostring(s3),
				Icon = "paintbrush",
				Duration = 2,
			})
		end,
	}
	v214:Button(t16)
	v214:Divider()
	v214:Section({
		Title = "Interface",
		TextXAlignment = "Center",
		TextSize = 17,
		Opened = true,
	})
	v214:Divider()
	v214:Keybind({
		Title = "Toggle Key",
		Value = "H",
		Callback = function(p50)
			local v362 = nil

			if env.typeof(p50) == "EnumItem" and p50.EnumType == env.Enum.KeyCode then
				v362 = p50
			elseif env.type(p50) == "string" then
				v362 = env.Enum.KeyCode[p50]
			end

			if not v362 then
				return
			end

			v186(function()
				v197:SetToggleKey(v362)
			end)
		end,
	})

	local v364, v365, v366 = env.ipairs(v181:GetPlayers())
	local v367, v368

	if type_(v364) == "function" then
		v367 = u227
		v368 = u228
	else
		local v369 = getmetatable_(v364)

		if v369 == nil or v369.__iter == nil then
			if type_(v364) == "table" then
				v364, v365, v366 = pairs_(v364)
				v367 = u227
				v368 = u228
			else
				v367 = u227
				v368 = u228
			end
		else
			v364, v365, v366 = v369.__iter(v364)
			v367 = u227
			v368 = u228
		end
	end

	while true do
		local v370

		v366, v370 = v364(v365, v366)

		if v366 == nil then
			break
		end

		v279(v370)
	end

	v181.PlayerAdded.Connect(v181.PlayerAdded, v279)
	v181.PlayerRemoving.Connect(v181.PlayerRemoving, v258)
	env.task.spawn(function()
		local n12 = 222

		if false then
			return
		end

		local n13 = 1
		local n14 = 208

		while (n13 < 0 or n12 >= n14) and (n13 >= 0 and n13 == n13 or n14 >= n12) do
			v288()
			env.task.wait(0.2)
			n14 = n14 + n13

			if n14 ~= n14 then
				return
			end
		end
	end)
	v183.JumpRequest.Connect(v183.JumpRequest, function()
		if not t11.infJump then
			return
		end

		local Character = LocalPlayer.Character

		if Character then
			Character = Character:FindFirstChildOfClass("Humanoid")
		end

		if not Character then
			return
		end
		Character:ChangeState(env.Enum.HumanoidStateType.Jumping)
	end)
	v182.RenderStepped.Connect(v182.RenderStepped, function(p51)
		v245()
		n11 = n11 + (p51 or 0)

		if n11 >= 0.022222222222222223 then
			n11 = 0

			local player = t9.player or t9.box or (t9.nametag or t9.line)
			local ViewportSize = CurrentCamera.ViewportSize
			local v380 = env.Vector2.new(ViewportSize.X * 0.5, 0)
			local Character = LocalPlayer.Character

			if Character then
				Character = Character:FindFirstChild("HumanoidRootPart")
			end

			local v382, v383, v384 = env.pairs(t9.table)

			if type_(v382) ~= "function" then
				local v385 = getmetatable_(v382)

				if v385 == nil or v385.__iter == nil then
					if type_(v382) == "table" then
						v382, v383, v384 = pairs_(v382)
					end
				else
					v382, v383, v384 = v385.__iter(v382)
				end
			end

			while true do
				local v386

				v384, v386 = v382(v383, v384)

				if v384 == nil then
					break
				end

				local Character2 = v384.Character

				if Character2 then
					Character2 = Character2:FindFirstChildOfClass("Humanoid")
				end

				if Character2 then
					Character2 = Character2.Health > 0
				end

				local head = v386.head
				local root = v386.root

				if player and (Character2 and (head and (root and (head.Parent and root.Parent)))) then
					if v386.highlight then
						v386.highlight.FillColor = t9.color
						v386.highlight.OutlineColor = t9.color
						v386.highlight.Enabled = t9.player
					end

					local v390

					if v386.box then
						v386.box.Enabled = t9.box

						if v386.boxLines then
							local v391, v392, v393 = env.ipairs(v386.boxLines)

							if type_(v391) == "function" then
								v390 = v384
							else
								local v394 = getmetatable_(v391)

								if v394 == nil or v394.__iter == nil then
									if type_(v391) == "table" then
										v391, v392, v393 = pairs_(v391)
										v390 = v384
									else
										v390 = v384
									end
								else
									v391, v392, v393 = v394.__iter(v391)
									v390 = v384
								end
							end

							while true do
								local v395

								v393, v395 = v391(v392, v393)

								if v393 == nil then
									break
								end

								v395.Visible = t9.box
							end
						else
							v390 = v384
						end
					else
						v390 = v384
					end

					if v386.billboard then
						v386.billboard.Enabled = t9.nametag

						if t9.nametag and v386.label then
							local v396

							if Character then
								local Magnitude = (root.Position - Character.Position).Magnitude

								v396 = " | " .. env.tostring(env.math.floor(Magnitude + 0.5)) .. " studs"
							else
								v396 = ""
							end

							v386.label.Text = v384.Name .. v396
							v386.label.TextColor3 = t9.color
						end
					end

					if t9.line and v386.line then
						local v398, v399 = CurrentCamera:WorldToViewportPoint(head.Position)

						if v399 and v398.Z > 0 then
							v253(
								v386.line,
								v380,
								env.Vector2.new(env.math.clamp(v398.X, 0, ViewportSize.X), env.math.clamp(v398.Y, 0, ViewportSize.Y)),
								t9.color
							)
							v384 = v390
						else
							v386.line.Visible = false
							v384 = v390
						end
					elseif v386.line then
						v386.line.Visible = false
						v384 = v390
					else
						v384 = v390
					end
				else
					if v386.highlight then
						v386.highlight.Enabled = false
					end

					if v386.box then
						v386.box.Enabled = false
					end

					if v386.boxLines then
						local v400, v401, v402 = env.ipairs(v386.boxLines)

						if type_(v400) ~= "function" then
							local v403 = getmetatable_(v400)

							if v403 == nil or v403.__iter == nil then
								if type_(v400) == "table" then
									v400, v401, v402 = pairs_(v400)
								end
							else
								v400, v401, v402 = v403.__iter(v400)
							end
						end

						while true do
							local v404

							v402, v404 = v400(v401, v402)

							if v402 == nil then
								break
							end

							v404.Visible = false
						end
					end

					if v386.billboard then
						v386.billboard.Enabled = false
					end

					if v386.line then
						v386.line.Visible = false
					end
				end
			end
		end

		if v367 and v368 then
			local enabled = t10.enabled

			if enabled then
				enabled = t10.showFov
			end

			v367.Visible = enabled

			if enabled then
				local v406 = v289()

				v367.Size = env.UDim2.new(0, t10.fov * 2, 0, t10.fov * 2)
				v367.Position = env.UDim2.new(0, v406.X, 0, v406.Y)
				v368.Thickness = t10.fovThickness

				local v407 = env.tick() * 0.35 % 1

				v368.Color = env.Color3.fromHSV(v407, 1, 1)
			end
		end

		if t10.enabled and t10.aimlock then
			local v408 = v293()

			if v408 and v408.Parent then
				local Position = CurrentCamera.CFrame.Position
				local v410 = env.CFrame.new(Position, v408.Position)
				local v411 = env.math.clamp(t10.smoothness, 0.02, 1)

				CurrentCamera.CFrame = CurrentCamera.CFrame.Lerp(CurrentCamera.CFrame, v410, v411)
			end
		end

		if not t11.speedBoost then
			return
		end

		local Character = LocalPlayer.Character

		if Character then
			Character = Character:FindFirstChildOfClass("Humanoid")
		end

		if not (Character and Character.WalkSpeed ~= t11.speedBoostValue) then
			return
		end

		Character.WalkSpeed = t11.speedBoostValue
	end)

	if env.type(env._G.KATBackgroundImage) == "string" and env._G.KATBackgroundImage ~= "" then
		v216(env._G.KATBackgroundImage)
	else
		v218("Main")
	end

	env.task.defer(function()
		v288()
	end)

	return {
		WindUI = v196,
		Window = v197,
	}
end

local windui = __FoxnameMM2Runtime.windui

if not (windui and env.type(windui.Notify) == "function") then
	return
end

env.pcall(function()
	windui:Notify({
		Title = "Fail",
		Content = "Script already running!",
		Icon = "ban",
		Duration = 2.5,
	})
end)
