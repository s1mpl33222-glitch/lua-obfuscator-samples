if type(getnilinstances) == "function" then
	pcall(function()
		for _, v in ipairs(getnilinstances()) do
			local ok, result = pcall(function()
				local flag = v.ClassName == "Folder"
				if flag then
					return v:GetAttribute("SAE_NEW_SESSION") == true
				end
				return flag
			end)

			if ok and result then
				pcall(function()
					v:Destroy()
				end)
			end
		end
	end)
end

local folder
folder = Instance.new("Folder")
folder.Name = "s" .. tostring(math.random(100000, 999999))
folder:SetAttribute("SAE_NEW_SESSION", true)
local tbl
tbl = { Name = "S2r Hub", Version = "0.1.0", Stage = "core", PlaceId = 107778070777162 }

do
end

tbl.MappedAt = 559
tbl.StartedAt = os.time()
tbl.Alive = true
tbl.ST = {}
tbl.CFG = {}
tbl.SV = {}
tbl.LOG = {}
tbl.FS = {}
tbl.NET = {}
tbl.PLR = {}
tbl.TASK = {}
tbl.UTIL = {}
tbl.UIX = {}
tbl.FLAG = { TeleportStealPremium = true, AdminAbuse = false }
tbl.Token = folder

do
	local flag = type(getgenv) == "function"

	if flag then
		flag = getgenv()
	end

	local tbl2 = flag or {}

	local tbl3 = {
		"hookfunction",
		"hookmetamethod",
		"getconnections",
		"getgc",
		"getrawmetatable",
		"firetouchinterest",
		"newcclosure",
		"getnamecallmethod",
		"checkcaller",
		"getcallingscript",
		"HttpGet",
		"request",
	}

	local iscclosure = tbl2.iscclosure
	local isfunctionhooked = tbl2.isfunctionhooked
	local tbl4 = {}

	for _, v in ipairs(tbl3) do
		tbl4[v] = tbl2[v]
	end

	local function fn(arg)
		if type(arg) ~= "function" then
			return false
		end

		if type(iscclosure) == "function" then
			local ok, result = pcall(iscclosure, arg)
			if ok and result == false then
				return true
			end
		end

		if type(isfunctionhooked) == "function" then
			local ok, result = pcall(isfunctionhooked, arg)
			if ok and result == true then
				return true
			end
		end

		return false
	end

	local function fn2()
		if tbl2.__SenaDevNoTamper ~= true then
			for _, v in ipairs(tbl3) do
				local v2 = tbl2[v]
				if v2 ~= tbl4[v] then
					return "api:" .. v
				end

				if fn(v2) then
					return "api:" .. v
				end
			end

			local getrawmetatable = tbl4.getrawmetatable

			if type(getrawmetatable) == "function" then
				local ok, result = pcall(getrawmetatable, game)

				if ok and type(result) == "table" then
					for _, v in ipairs({ "__namecall", "__index", "__newindex" }) do
						if fn(rawget(result, v)) then
							return "mt:" .. v
						end
					end
				end
			end

			local remoteEvent = Instance.new("RemoteEvent")
			local remoteFunction = Instance.new("RemoteFunction")
			local str

			if fn(remoteEvent.FireServer) then
				str = "remote:FireServer"
			else
				str = nil

				if fn(remoteFunction.InvokeServer) then
					str = "remote:InvokeServer"
				end
			end

			remoteEvent:Destroy()
			remoteFunction:Destroy()
			return str
		end

		return nil
	end

	local function fn3(tamperRejoin)
		if tbl.TamperRejoin then
			return
		end
		tbl.TamperRejoin = tamperRejoin
		warn("[SAE] tamper detected (" .. tostring(tamperRejoin) .. ") - rejoining")
		local TeleportService = game:GetService("TeleportService")
		local localPlayer = game:GetService("Players").LocalPlayer

		pcall(function()
			TeleportService:TeleportToPlaceInstance(game.PlaceId, game.JobId, localPlayer)
		end)

		task.delay(5, function()
			pcall(function()
				TeleportService:Teleport(game.PlaceId, localPlayer)
			end)
		end)
	end

	local ok, result = pcall(fn2)

	if ok and result then
		fn3(result)
	end

	task.spawn(function()
		local result2

		while true do
			if not tbl.Alive or folder.Parent ~= nil then
				return
			else
				task.wait(3)
				local ok2
				ok2, result2 = pcall(fn2)
				if ok2 and result2 then
					break
				end
			end
		end

		fn3(result2)
	end)
end

local bindableFunction = Instance.new("BindableFunction")
bindableFunction.Name = "status"

bindableFunction.OnInvoke = function()
	local loops = 0

	for k in pairs(tbl.TASK.Loops) do
		loops += 1
	end

	local tbl2 = {
		alive = tbl.Alive == true,
		version = tbl.Version,
		executor = tostring(tbl.ST.Executor),
		uptime = os.time() - tbl.StartedAt,
		mounted = tbl.UIX.Mounted == true,
		page = tostring(tbl.UIX.ActivePage),
		minimized = tbl.UIX.Minimized == true,
	}

	local scaleMode

	if tbl.UIX.IsMobile then
		scaleMode = tbl.UIX.IsMobile() and "mobile" or "desktop"
	else
		scaleMode = "?"
	end

	tbl2.scaleMode = scaleMode
	tbl2.scale = tbl.UIX.CurrentScale or 0
	tbl2.loops = loops
	return tbl2
end

bindableFunction.Parent = folder

folder.Destroying:Connect(function()
	if tbl.Alive then
		tbl.Destroy("superseded")
		return
	end
end)

do
	local sv = tbl.SV

	local function fn(arg)
		return arg
	end

	local kind = type(cloneref)
	local v

	if kind ~= "function" then
		v = fn
	else
		v = if pcall(cloneref, game) then cloneref else fn
	end

	sv.ref = v

	local function fn2(arg)
		local ok, result = pcall(game.GetService, game, arg)

		if ok then
			if result then
				return v(result)
			end
			return nil
		end

		return nil
	end

	sv.Players = fn2("Players")
	sv.ReplicatedStorage = fn2("ReplicatedStorage")
	sv.RunService = fn2("RunService")
	sv.UserInputService = fn2("UserInputService")
	sv.Lighting = fn2("Lighting")
	sv.TweenService = fn2("TweenService")
	sv.HttpService = fn2("HttpService")
	sv.GuiService = fn2("GuiService")
	sv.TeleportService = fn2("TeleportService")
end

do
	local log = tbl.LOG
	log.Enabled = true
	log.Console = false
	log.History = {}
	log.MaxLines = 300

	local function fn(arg, arg2, arg3)
		local v = tostring
		local str = ("[%s][%s] %s: %s"):format(os.date("%H:%M:%S"), arg, arg2, v(arg3))
		local history = log.History
		history[#history + 1] = str
		if not (log.MaxLines < #history) then
			return str
		end
		table.remove(history, 1)
		return str
	end

	log.OpenConsole = function()
		if log.Console then
			return
		end

		if type(rconsoleshow) ~= "function" then
			return
		end
		pcall(rconsoleshow)
		pcall(rconsoleclear)
		log.Console = true
	end

	log.info = function(arg, arg2)
		local info = fn("INFO", arg, arg2)
		if log.Enabled and log.Console and rconsoleprint then
			pcall(rconsoleprint, info .. "\n")
			return
		end
	end

	log.warn = function(arg, arg2)
		local warn_ = fn("WARN", arg, arg2)

		if log.Enabled then
			if log.Console and rconsolewarn then
				pcall(rconsolewarn, warn_ .. "\n")
			end

			warn(warn_)
			return
		end
	end

	log.err = function(arg, arg2)
		local fail = fn("FAIL", arg, arg2)

		if log.Enabled then
			if log.Console and rconsoleerr then
				pcall(rconsoleerr, fail .. "\n")
			end

			warn(fail)
			return
		end
	end
end

do
	local index = {}
	index.__index = index
	tbl.UTIL.Trove = index

	index.new = function(arg)
		return setmetatable({ _label = arg or "trove", _items = {} }, index)
	end

	index.Add = function(arg, arg2, arg3)
		if arg2 ~= nil then
			arg._items[#arg._items + 1] = { obj = arg2, how = arg3 }
			return arg2
		end
		return arg2
	end

	index.Connect = function(arg, arg2, arg3)
		if arg2 and type(arg2.Connect) == "function" then
			return arg:Add(arg2:Connect(arg3), "Disconnect")
		end
		tbl.LOG.warn(arg._label, "Connect: signal is not connectable")
		return nil
	end

	index.Spawn = function(arg, arg2, ...)
		return arg:Add(task.spawn(arg2, ...), "__thread")
	end

	index.Delay = function(arg, arg2, arg3, ...)
		return arg:Add(task.delay(arg2, arg3, ...), "__thread")
	end

	local function fn(arg)
		local obj = arg.obj
		local how = arg.how
		local kind = typeof(obj)
		if how == "__thread" or kind == "thread" then
			pcall(task.cancel, obj)
			return
		end

		if kind ~= "RBXScriptConnection" then
			if kind ~= "Instance" then
				if kind ~= "function" then
					if kind ~= "table" then
						if how and type(obj) == "userdata" then
							pcall(function()
								obj[how](obj)
							end)

							return
						end

						return
					end

					local str

					if how then
						str = how
					elseif type(obj.Remove) ~= "function" then
						if type(obj.Destroy) ~= "function" then
							if type(obj.Clean) ~= "function" then
								return
							end
							str = "Clean"
						else
							str = "Destroy"
						end
					else
						str = "Remove"
					end

					if type(obj[str]) ~= "function" then
						return
					end

					pcall(function()
						obj[str](obj)
					end)

					return
				end

				pcall(obj)
				return
			end

			pcall(function()
				obj:Destroy()
			end)

			return
		end

		pcall(function()
			obj:Disconnect()
		end)
	end

	index.Clean = function(arg)
		local items = arg._items
		arg._items = {}

		for i = #items, 1, -1 do
			fn(items[i])
		end
	end

	index.Destroy = index.Clean
	tbl.ST.Trove = index.new("session")
end

do
	local fs = tbl.FS
	fs.Root = "SAE_New"
	fs.ConfigDir = "SAE_New/config"
	fs.LogDir = "SAE_New/logs"
	fs.Ready = false

	local function fn(arg)
		local ok, result = pcall(isfolder, arg)
		if ok and result then
			return result
		end
		return false
	end

	fs.EnsureFolder = function(arg)
		local v = string.split(arg, "/")
		local v2 = nil

		for _, v3 in ipairs(v) do
			if v3 ~= "" then
				v2 = if v2 then v2 .. "/" .. v3 else v3
				if fn(v2) then
					continue
				end
				local ok, result = pcall(makefolder, v2)
				if ok then
					continue
				end
				tbl.LOG.err("FS.EnsureFolder", ("%s: %s"):format(v2, tostring(result)))
				return false
			end
		end

		return true
	end

	fs.Init = function()
		local v = fs.EnsureFolder(fs.ConfigDir) and fs.EnsureFolder(fs.LogDir)
		fs.Ready = v
		if v then
			return v
		end
		tbl.LOG.err("FS.Init", "workspace folders unavailable — config will not persist")
		return v
	end

	fs.Exists = function(arg)
		local ok, result = pcall(isfile, arg)
		if ok and result then
			return result
		end
		return false
	end

	fs.Read = function(arg)
		if fs.Exists(arg) then
			local ok, result = pcall(readfile, arg)
			if ok then
				return result
			end
			tbl.LOG.err("FS.Read", ("%s: %s"):format(arg, tostring(result)))
			return nil
		end

		return nil
	end

	fs.Write = function(arg, arg2)
		if not fs.Ready then
			fs.Init()
		end

		local ok, result = pcall(writefile, arg, arg2)
		if ok then
			return true
		end
		tbl.LOG.err("FS.Write", ("%s: %s"):format(arg, tostring(result)))
		return false
	end

	fs.Delete = function(arg)
		if fs.Exists(arg) then
			local ok, result = pcall(delfile, arg)
			if ok then
				return true
			end
			tbl.LOG.err("FS.Delete", ("%s: %s"):format(arg, tostring(result)))
			return false
		end

		return true
	end

	fs.ReadJSON = function(arg)
		local v = fs.Read(arg)
		if not v then
			return nil
		end

		if v ~= "" then
			local ok, result = pcall(function()
				return tbl.SV.HttpService:JSONDecode(v)
			end)

			if ok then
				return result
			end
			tbl.LOG.warn("FS.ReadJSON", ("%s is corrupt, ignoring"):format(arg))
			return nil
		end

		return nil
	end

	fs.WriteJSON = function(arg, arg2)
		local ok, result = pcall(function()
			return tbl.SV.HttpService:JSONEncode(arg2)
		end)

		if ok then
			return fs.Write(arg, result)
		end
		tbl.LOG.err("FS.WriteJSON", ("encode failed for %s: %s"):format(arg, tostring(result)))
		return false
	end
end

do
	local cfg = tbl.CFG
	cfg.Path = tbl.FS.ConfigDir .. "/settings.json"
	cfg.Schema = 1
	cfg.SaveDelay = 1.25
	cfg.Data = { __schema = 1, Flags = {} }
	local flag = false

	local function fn(arg, arg2)
		local data = cfg.Data
		local v = string.split(arg, ".")

		for i = 1, #v - 1 do
			local v2 = v[i]

			if type(data[v2]) ~= "table" then
				if not arg2 then
					return nil, nil
				end
				data[v2] = {}
			end

			data = data[v2]
		end

		return data, v[#v]
	end

	cfg.Get = function(arg, arg2)
		local v, v2 = fn(arg, false)

		if v then
			local v3 = v[v2]
			if v3 ~= nil then
				return v3
			end
			return arg2
		end

		return arg2
	end

	cfg.Set = function(arg, arg2, arg3)
		local v, v2 = fn(arg, true)

		if v then
			v[v2] = arg2
			if arg3 then
				return true
			end
			cfg.QueueSave()
			return true
		end

		return false
	end

	cfg.Save = function()
		flag = false
		cfg.Data.__schema = cfg.Schema
		cfg.Data.__saved = os.time()
		return tbl.FS.WriteJSON(cfg.Path, cfg.Data)
	end

	cfg.QueueSave = function()
		if flag then
			return
		end
		flag = true

		tbl.ST.Trove:Delay(cfg.SaveDelay, function()
			if tbl.Alive then
				cfg.Save()
				return
			end
		end)
	end

	cfg.Load = function()
		local v = tbl.FS.ReadJSON(cfg.Path)
		if type(v) ~= "table" then
			tbl.LOG.info("CFG.Load", "no saved config, starting from defaults")
			return false
		end

		if v.__schema ~= cfg.Schema then
			tbl.LOG.warn("CFG.Load", ("schema %s != %s, discarding old config"):format(tostring(v.__schema), tostring(cfg.Schema)))
			return false
		end
		cfg.Data = v

		if type(cfg.Data.Flags) ~= "table" then
			cfg.Data.Flags = {}
		end

		local n = 0

		for k in pairs(cfg.Data) do
			if type(k) == "string" and k:sub(1, 4) == "Sec_" then
				n += 1
			end
		end

		if n > 0 then
			for k in pairs(cfg.Data) do
				if type(k) == "string" and k:sub(1, 4) == "Sec_" then
					cfg.Data[k] = nil
				end
			end

			cfg.QueueSave()
		end

		tbl.LOG.info("CFG.Load", "config restored")
		return true
	end

	cfg.Reset = function()
		cfg.Data = { __schema = cfg.Schema, Flags = {} }
		cfg.Save()
		tbl.LOG.info("CFG.Reset", "config cleared")
	end
end

do
	local net = tbl.NET
	net.Folder = nil
	net.Index = {}
	local tbl2 = {}

	local function fn(arg)
		local v, v2, v3 = string.match(arg.Name, "^(R[EF])/([^/]+)/(.+)$")

		if v then
			local tbl3 = net.Index[v2]

			if not tbl3 then
				tbl3 = {}
				net.Index[v2] = tbl3
			end

			tbl3[v3] = arg
			return true
		end

		return false
	end

	net.Init = function()
		local packages = tbl.SV.ReplicatedStorage:FindFirstChild("Packages")
		net.Folder = packages and packages:FindFirstChild("Networking") or nil

		if net.Folder then
			net.Index = {}
			local n = 0

			for _, child in ipairs(net.Folder:GetChildren()) do
				if fn(child) then
					n += 1
				end
			end

			local trove = tbl.ST.Trove
			local v = trove
			local connect = trove.Connect

			local function fn2(arg)
				fn(arg)
			end

			connect(v, net.Folder.ChildAdded, fn2)
			local n2 = 0

			for k in pairs(net.Index) do
				n2 += 1
			end

			tbl.LOG.info("NET.Init", ("indexed %d remotes across %d namespaces"):format(n, n2))
			return true
		end

		tbl.LOG.err("NET.Init", "ReplicatedStorage.Packages.Networking not found — game layout changed")
		return false
	end

	net.Get = function(arg, arg2)
		local str = arg .. "/" .. arg2
		local v = tbl2[str]
		if v and v.Parent then
			return v, v.ClassName
		end
		local v2 = net.Index[arg]
		local v3 = nil

		if type(v2) == "table" and typeof(v2[arg2]) == "Instance" then
			v3 = v2[arg2]
		end

		if not v3 and net.Folder then
			v3 = net.Folder:FindFirstChild("RE/" .. str) or net.Folder:FindFirstChild("RF/" .. str)
		end

		if v3 then
			tbl2[str] = v3
			return v3, v3.ClassName
		end
		tbl.LOG.warn("NET.Get", ("%s not found — namespace or name renamed?"):format(str))
		return nil, nil
	end

	net.Fire = function(arg, arg2, ...)
		local v, v2 = net.Get(arg, arg2)

		if v then
			if v2 ~= "RemoteEvent" and v2 ~= "UnreliableRemoteEvent" then
				tbl.LOG.warn("NET.Fire", ("%s/%s is a %s — use NET.Invoke"):format(arg, arg2, tostring(v2)))
				return false
			end
			local ok, result = pcall(v.FireServer, v, ...)
			if ok then
				return true
			end
			tbl.LOG.err("NET.Fire", ("%s/%s: %s"):format(arg, arg2, tostring(result)))
			return false
		end

		return false
	end

	net.Invoke = function(arg, arg2, ...)
		local v, v2 = net.Get(arg, arg2)

		if v then
			if v2 ~= "RemoteFunction" then
				tbl.LOG.warn("NET.Invoke", ("%s/%s is a %s — use NET.Fire"):format(arg, arg2, tostring(v2)))
				return false, nil
			end
			local ok, result = pcall(v.InvokeServer, v, ...)
			if ok then
				return true, result
			end
			tbl.LOG.err("NET.Invoke", ("%s/%s: %s"):format(arg, arg2, tostring(result)))
			return false, nil
		end

		return false, nil
	end

	local function on(arg, arg2, arg3)
		local v, v2 = net.Get(arg, arg2)

		if v then
			if v2 ~= "RemoteEvent" and v2 ~= "UnreliableRemoteEvent" then
				tbl.LOG.warn("NET.On", ("%s/%s is a %s"):format(arg, arg2, tostring(v2)))
				return nil
			end
			return tbl.ST.Trove:Connect(v.OnClientEvent, arg3)
		end

		return nil
	end

	net.On = on

	net.List = function(arg)
		local tbl3 = {}
		local v = net.Index[arg]
		if type(v) ~= "table" then
			return tbl3
		end

		for k, v2 in pairs(v) do
			tbl3[#tbl3 + 1] = { Name = k, Class = typeof(v2) == "Instance" and v2.ClassName or typeof(v2) }
		end

		table.sort(tbl3, function(arg2, arg3)
			return arg2.Name < arg3.Name
		end)

		return tbl3
	end
end

do
	local plr = tbl.PLR
	plr.Player = tbl.SV.Players.LocalPlayer
	local player = plr.Player

	if player then
		local player2 = plr.Player
		player = player2.Name
	end

	plr.Name = player or "?"
	plr.UserId = plr.Player and plr.Player.UserId or 0
	plr.Char = nil
	plr.Hum = nil
	plr.HRP = nil
	plr.OnRespawn = {}

	local function fn(char)
		plr.Char = char
		plr.Hum = char:FindFirstChildOfClass("Humanoid") or char:WaitForChild("Humanoid", 8)
		plr.HRP = char:FindFirstChild("HumanoidRootPart") or char:WaitForChild("HumanoidRootPart", 8)

		for k in pairs(plr.OnRespawn) do
			task.spawn(function()
				local ok, result = pcall(k, char)
				if ok then
					return
				end
				tbl.LOG.err("PLR.OnRespawn", result)
			end)
		end
	end

	plr.Init = function()
		if plr.Player then
			if plr.Player.Character then
				fn(plr.Player.Character)
			end

			tbl.ST.Trove:Connect(plr.Player.CharacterAdded, fn)
			return true
		end

		tbl.LOG.err("PLR.Init", "LocalPlayer is nil")
		return false
	end

	plr.Alive = function()
		local flag = plr.Char ~= nil

		if flag then
			flag = plr.HRP ~= nil

			if flag then
				flag = plr.HRP.Parent ~= nil

				if flag then
					flag = plr.Hum ~= nil
					if flag then
						return plr.Hum.Health > 0
					end
				end
			end
		end

		return flag
	end

	plr.Wait = function(arg)
		local n = os.clock() + (arg or 10)

		while true do
			if not (os.clock() < n) then
				tbl.LOG.warn("PLR.Wait", "timed out waiting for a living character")
				return nil
			else
				if plr.Alive() then
					break
				end
				task.wait(0.1)
			end
		end

		return plr.Char
	end

	plr.Position = function()
		if plr.HRP then
			local position = plr.HRP.Position
			if position then
				return position
			end
		end

		return nil
	end
end

local task_ = tbl.TASK
task_.Loops = {}

task_.Stop = function(arg)
	local v = task_.Loops[arg]
	if not v then
		return false
	end
	v.running = false

	if v.conn then
		pcall(function()
			v.conn:Disconnect()
		end)
	end

	if v.thread then
		pcall(task.cancel, v.thread)
	end

	task_.Loops[arg] = nil
	return true
end

task_.Running = function(arg)
	local v = task_.Loops[arg]
	local flag = v ~= nil
	if flag then
		return v.running == true
	end
	return flag
end

task_.StopAll = function()
	for k in pairs(task_.Loops) do
		task_.Stop(k)
	end
end

tbl.UTIL.clock = function(arg)
	local n = math.max(0, math.floor(tonumber(arg) or 0))
	local n2 = math.floor(n / 3600)
	local n3 = math.floor(n % 3600 / 60)
	local n4 = n % 60
	if not (n2 > 0) then
		return ("%02d:%02d"):format(n3, n4)
	end
	return ("%d:%02d:%02d"):format(n2, n3, n4)
end

tbl.Destroy = function(arg)
	if tbl.Alive then
		tbl.Alive = false

		if type(tbl.UIX.Destroy) == "function" then
			pcall(tbl.UIX.Destroy)
		end

		tbl.TASK.StopAll()
		pcall(tbl.CFG.Save)
		tbl.ST.Trove:Clean()
		tbl.LOG.info("SAE.Destroy", "session closed (" .. tostring(arg or "manual") .. ")")

		pcall(function()
			folder:Destroy()
		end)

		return
	end
end

tbl.LOG.info("boot", ("%s v%s (%s) — place %d, mapped at v%d"):format(tbl.Name, tbl.Version, tbl.Stage, tbl.PlaceId, tbl.MappedAt))
local executor = "unknown"

pcall(function()
	executor = identifyexecutor()
end)

tbl.ST.Executor = executor
tbl.LOG.info("boot", "executor: " .. tostring(executor))

if game.PlaceId ~= tbl.PlaceId then
	tbl.LOG.warn("boot", ("place %d is not Steal An Egg (%d) — running anyway, paths may not resolve"):format(game.PlaceId, tbl.PlaceId))
end

if game.PlaceVersion ~= tbl.MappedAt then
	tbl.LOG.warn("boot", ("place version %d, mapped against %d — egg remotes, map positions or claim rules may have changed"):format(game.PlaceVersion, tbl.MappedAt))
end

tbl.FS.Init()
tbl.CFG.Load()
tbl.PLR.Init()
tbl.NET.Init()

if tbl.PLR.Player then
	tbl.ST.Trove:Connect(tbl.SV.Players.PlayerRemoving, function(arg)
		if arg ~= tbl.PLR.Player then
			return
		end
		tbl.Destroy("player removing")
	end)
end

tbl.ST.Booted = true
tbl.LOG.info("boot", "core ready — SAE.UIX is free for the UI layer")
local steal
steal = {}
tbl.STEAL = steal
steal.MAX_SPEED = 1100
steal.STRIP = Vector3.new(515, 74, -362.8)
steal.GATE_X = 552
steal.GATE_STEP = Vector3.new(556, 68, -330)
steal.GATE_IN = Vector3.new(540, 68, -330)
steal.GATE_OUT = Vector3.new(556, 68, -330)
steal.GATE_BAWAH = -50
steal.ARRIVE = 50
steal.STEP = { CAP = 45, MIN = 20, MAX = 45, UP = 0.5, ROLLBACK = 40 }
steal.HEADROOM = 1.35
steal.SPEED_PCT = 85
steal.SPEED_PERGI = nil
steal.INSTANT = { on = false, LAJU = 3000, PAKSA_LAJU = true }

steal.INSTANT.BoostLaju = function()
	if tbl.FLAG.AdminAbuse then
		if steal.INSTANT.on and steal.INSTANT.PAKSA_LAJU then
			return steal.INSTANT.LAJU
		end
		return nil
	end

	return nil
end

steal.PLAFON_MARGIN = 0.92

steal.PlafonGerak = function()
	local localPlayer = tbl.SV.Players.LocalPlayer
	local character = localPlayer and localPlayer.Character
	local humanoid = character and character:FindFirstChildOfClass("Humanoid")
	local walkSpeed = humanoid and humanoid.WalkSpeed or 0
	if not (walkSpeed <= 0) then
		return walkSpeed * 5 * steal.PLAFON_MARGIN
	end
	return steal.MAX_SPEED
end

steal.SpeedCap = function()
	local v = steal.INSTANT.BoostLaju()
	if v then
		return v
	end
	return math.max(1, math.min(steal.MAX_SPEED, steal.PlafonGerak()))
end

-- Safe at every stage of player progression: a new player's cap may be below
-- the speed requested by the movement routines. math.clamp requires min <= max.
steal.SafeSpeed = function(desired, requestedMin)
	local cap = steal.SpeedCap()
	local low = math.min(math.max(0, tonumber(requestedMin) or 0), cap)
	return math.clamp(tonumber(desired) or low, low, cap)
end

steal.StepCap = function(arg)
	local v = steal.INSTANT.BoostLaju()
	if v then
		return v
	end
	local max = math.max
	local cap = steal.STEP.CAP
	if arg then
		return max(cap, arg)
	end
	return max(cap, 0)
end

do
	steal.ORDER = {}
	local order = steal.ORDER
	order.AKTIF = true
	order.sekarang = nil
	order.mulaiAt = 0
	order.Status = "idle"

	order.DEFAULT_PRIORITIES = {
		auto_steal = 1,
		auto_scramble_lab = 2,
		auto_shooting_star = 3,
		auto_race_rally = 4,
		auto_wisp_event = 5,
	}

	order.PRIORITAS = {}

	for k, defaultPriority in pairs(order.DEFAULT_PRIORITIES) do
		order.PRIORITAS[k] = defaultPriority
	end

	order.BATAS = {
		auto_steal = 180,
		auto_scramble_lab = 300,
		auto_shooting_star = 180,
		auto_race_rally = 420,
		auto_wisp_event = 420,
	}

	order.BATAS_BAWAAN = 240
	order.TUGAS = {}
	order.URUT = {}

	local function urutUlang()
		table.clear(order.URUT)

		for k in pairs(order.TUGAS) do
			order.URUT[#order.URUT + 1] = k
		end

		table.sort(order.URUT, function(arg, arg2)
			local n = order.PRIORITAS[arg] or 99
			local n2 = order.PRIORITAS[arg2] or 99
			if n ~= n2 then
				return n < n2
			end
			return arg < arg2
		end)
	end

	order.UrutUlang = urutUlang

	order.Daftar = function(arg, arg2)
		if type(arg) ~= "string" then
			return false
		end

		if type(arg2) ~= "table" then
			return false
		end
		order.TUGAS[arg] = arg2

		if order.PRIORITAS[arg] == nil then
			order.PRIORITAS[arg] = 99
		end

		urutUlang()
		return true
	end

	order.SetPrioritas = function(arg, arg2)
		if order.TUGAS[arg] ~= nil then
			order.PRIORITAS[arg] = tonumber(arg2) or 99
			urutUlang()
			return true
		end

		return false
	end

	local function fn(arg, arg2)
		if type(arg) ~= "function" then
			return arg2
		end
		local ok, result = pcall(arg)
		if ok then
			return result
		end
		return arg2
	end

	order.POTONG_SIKLUS = true
	order.malamLalu = nil

	order.Malam = function()
		local ok, result = pcall(function()
			return require(tbl.SV.ReplicatedStorage.Shared.Util.AreaEggCycle)
		end)

		if ok then
			if type(result) ~= "table" then
				return nil
			end

			if type(result.IsNightPhase) ~= "function" then
				return nil
			end
			local ok2, result2 = pcall(result.IsNightPhase, workspace:GetServerTimeNow())

			if ok2 then
				if type(result2) ~= "boolean" then
					return nil
				end
				return result2
			end

			return nil
		end

		return nil
	end

	order.Giliran = function(arg)
		if order.AKTIF then
			return order.sekarang == arg
		end
		return true
	end

	local function nganggur()
		return order.sekarang == nil
	end

	order.Nganggur = nganggur

	order.Langkah = function()
		if order.AKTIF then
			local v = order.Malam()
			local flag = false

			if v ~= nil then
				if order.malamLalu ~= nil then
					if v == true and order.malamLalu == false then
						flag = true
					end
				else
					order.malamLalu = v
				end

				order.malamLalu = v
			end

			local sekarang = order.sekarang

			if sekarang then
				local v2 = order.TUGAS[sekarang]
				local n = os.clock() - order.mulaiAt
				local batasBawaan = order.BATAS[sekarang] or order.BATAS_BAWAAN

				if v2 and fn(v2.Nyala, true) == false then
					tbl.LOG.info("ORDER", ("%s dimatikan - giliran dilepas di %.0fs"):format(sekarang, n))
					order.sekarang = nil
				end

				if v2 and order.sekarang and flag and order.POTONG_SIKLUS then
					if fn(v2.BolehPotong, true) ~= false then
						tbl.LOG.info("ORDER", ("malam mulai - %s dipotong di %.0fs"):format(sekarang, n))
						order.sekarang = nil
					else
						tbl.LOG.info("ORDER", ("malam mulai - %s menolak dipotong"):format(sekarang))
					end
				end

				local n2 = order.PRIORITAS[sekarang] or 99
				local v3 = nil

				if v2 and order.sekarang then
					for _, v4 in ipairs(order.URUT) do
						if not (n2 <= (order.PRIORITAS[v4] or 99)) then
							local v5 = order.TUGAS[v4]
							if v5 and fn(v5.Nyala, true) ~= false and fn(v5.Siap, false) then
								v3 = v4
								break
							end
							continue
						end

						break
					end
				end

				if v3 then
					if fn(v2.BolehPotong, true) ~= false then
						tbl.LOG.info("ORDER", ("%s (prio %d) memotong %s (prio %d) di %.0fs"):format(v3, order.PRIORITAS[v3] or 99, sekarang, n2, n))
						order.sekarang = nil
					else
						order.Status = ("running %s (%.0fs) - %s menunggu"):format(v2.label or sekarang, n, v3)
					end
				end

				if v2 then
					if order.sekarang ~= nil then
						if not (batasBawaan < n) then
							if not fn(v2.Selesai, true) then
								order.Status = ("running %s (%.0fs)"):format(v2.label or sekarang, n)
								return
							end
							tbl.LOG.info("ORDER", ("task %s selesai (%.1fs)"):format(sekarang, n))
							order.sekarang = nil
						else
							tbl.LOG.warn("ORDER", ("task %s melewati plafon %ds - giliran dilepas paksa"):format(sekarang, batasBawaan))
							order.sekarang = nil
						end
					end
				else
					order.sekarang = nil
				end
			end

			for _, v2 in ipairs(order.URUT) do
				local v3 = order.TUGAS[v2]

				if v3 and fn(v3.Nyala, true) ~= false and fn(v3.Siap, false) then
					local v4 = order
					local v5 = order
					local now = os.clock()
					v4.sekarang = v2
					v5.mulaiAt = now
					order.Status = ("start %s"):format(v3.label or v2)
					tbl.LOG.info("ORDER", ("giliran -> %s (prio %d)"):format(v2, order.PRIORITAS[v2] or 99))
					return
				end
			end

			order.sekarang = nil
			order.Status = "idle - no task ready"
			return
		end

		local v = order
		order.sekarang = nil
		v.Status = "arbiter off"
	end

	order.Potret = function()
		local tbl2 = {}

		for _, v in ipairs(order.URUT) do
			local v2 = order.TUGAS[v]

			tbl2[#tbl2 + 1] = {
				id = v,
				label = v2 and v2.label or v,
				prio = order.PRIORITAS[v] or 99,
				siap = fn(v2 and v2.Siap, false) and true or false,
				aktif = order.sekarang == v,
				nyala = fn(v2 and v2.Nyala, true) ~= false,
			}
		end

		return {
			aktif = order.AKTIF,
			sekarang = order.sekarang,
			umur = if order.sekarang then os.clock() - order.mulaiAt else 0,
			status = order.Status,
			tugas = tbl2,
		}
	end

	order.DENYUT = 0.25

	task.spawn(function()
		while tbl.Alive do
			pcall(order.Langkah)
			task.wait(order.DENYUT)
		end
	end)

	tbl.ST.Trove:Add(function()
		order.sekarang = nil
	end)
end

steal.Instant = function(arg)
	if tbl.FLAG.AdminAbuse then
		steal.INSTANT.on = arg and true or false
		tbl.LOG.warn("INSTANT", steal.INSTANT.on and ("Instant Steal NYALA -- method diganti: TP ke telur > angkat > TP ke safe zone%s"):format(steal.INSTANT.PAKSA_LAJU and (", laju dipaksa %d stud/detik"):format(steal.INSTANT.LAJU) or "") or "Instant Steal mati -- kembali ke method normal (ruangan/boost/ritual)")

		if steal.INSTANT.on and tbl.UIX and tbl.UIX.Pita then
			tbl.UIX.Pita("Instant Steal only works during an Admin Abuse event. Turn it off when there is no Admin Abuse - outside the event no egg will be picked up and the forced speed can get you killed.", 7)
		end

		return steal.INSTANT.on
	end

	steal.INSTANT.on = false
	return false
end

steal.Running = false
steal.pulang = false
steal.tulisAt = 0
steal.Activity = "idle"
steal.Claims = 0
steal.Fails = 0
local runService
runService = tbl.SV.RunService
local localPlayer
localPlayer = tbl.SV.Players.LocalPlayer
local v
v = workspace
local str
str = tostring(localPlayer.UserId)
local fn

do
	local v2 = nil
	local humanoidRootPart = nil
	local humanoid = nil

	fn = function()
		local character = localPlayer.Character

		if character ~= v2 or not humanoidRootPart or not humanoidRootPart.Parent or not humanoid or not humanoid.Parent then
			v2 = character
			humanoidRootPart = character and character:FindFirstChild("HumanoidRootPart")
			humanoid = character and character:FindFirstChildOfClass("Humanoid")
		end

		return humanoidRootPart, humanoid, v2
	end
end

local fn2

fn2 = function()
	return (fn())
end

local fn3

fn3 = function()
	local v2
	v2, v2 = fn()
	return v2
end

local fn4

fn4 = function(activity)
	steal.Activity = activity
end

steal.Kabar = function()
	local cte = steal.AA and steal.AA.CTE
	if cte and cte.on and cte.Status ~= "Off" and cte.Status ~= "waiting for event" and cte.Status ~= "waiting for Auto Steal" then
		return "Capture The Egg: " .. cte.Status
	end
	local scr = steal.SCR
	if scr and (scr.sesi or scr.balik) and scr.Status and scr.Status ~= "Idle" then
		return "Dr. Scramble: " .. scr.Status
	end
	local activity = steal.Activity
	if activity and activity ~= "" and activity ~= "idle" then
		return activity
	end

	if scr and scr.on and scr.Status and scr.Status ~= "Idle" then
		return "Dr. Scramble: " .. scr.Status
	end
	return "idle"
end

steal.SAMPLE_FIELDS = {
	"CandidateGroundedSample",
	"LastConfirmedGroundSample",
	"LastGameplayTrustedSample",
	"LastGoodSample",
	"LastObservedSample",
	"LastSample",
	"LastValidatedGroundedSample",
	"LastValidatedSample",
}

do
	local tbl2 = { State = nil, NextSearchAt = 0, Conn = nil, Patched = 0 }

	local function fn5(arg, arg2)
		if type(getgc) ~= "function" then
			return nil
		end
		local ok, result = pcall(getgc, true)

		if ok then
			if type(result) ~= "table" then
				return nil
			end

			for _, v2 in ipairs(result) do
				if type(v2) == "table" and rawget(v2, "Player") == localPlayer and rawget(v2, "Character") == localPlayer.Character and rawget(v2, "Humanoid") == arg and rawget(v2, "RootPart") == arg2 and type(rawget(v2, "SampleHistory")) == "table" and type(rawget(v2, "Evidence")) == "table" then
					return v2
				end
			end

			return
		end

		return nil
	end

	local function fn6(arg, arg2, arg3, arg4)
		if type(arg) ~= "table" then
			return 0
		end
		rawset(arg, "WalkSpeed", arg2)
		rawset(arg, "IsSupported", true)

		if arg3 then
			rawset(arg, "CFrame", arg3)
			rawset(arg, "Position", arg4)
			rawset(arg, "LinearVelocity", Vector3.zero)
			rawset(arg, "AngularVelocity", Vector3.zero)
			return 1
		end

		return 1
	end

	local function fn7(arg, arg2)
		local value = rawget(arg, "RootPart")
		local cFrame, position

		if value and value.Parent then
			cFrame = value.CFrame

			if cFrame then
				position = cFrame.Position or nil
			else
				cFrame = nil
				position = nil
			end
		else
			cFrame = nil
			position = nil
		end

		local sample = 0

		for _, sampleField in ipairs(steal.SAMPLE_FIELDS) do
			sample += fn6(rawget(arg, sampleField), arg2, cFrame, position)
		end

		local value2 = rawget(arg, "SampleHistory")

		if type(value2) == "table" then
			for _, v2 in pairs(value2) do
				sample += fn6(v2, arg2, cFrame, position)
			end
		end

		local value3 = rawget(arg, "SafeGroundCheckpoints")

		if type(value3) == "table" then
			for _, v2 in pairs(value3) do
				sample += fn6(v2, arg2, cFrame, position)
			end
		end

		local value4 = rawget(arg, "LastVerticalSegmentDecision")
		local n = 0

		if type(value4) == "table" then
			value4.Excess = 0
			value4.Ratio = 0
			value4.Displacement = 0
			value4.Decision = "Reachable"
			value4.Reliable = true
			value4.CorrectionStarted = false
			n = 1

			if position then
				local y = position.Y
				value4.CurrentY = position.Y
				value4.PreviousY = y
			end
		end

		local value5 = rawget(arg, "LastVerticalTrajectoryDecision")

		if type(value5) == "table" then
			n += 1
			value5.Active = false
			value5.Evidence = 0
			value5.EvidenceEventCount = 0
			value5.AirborneDuration = 0
			value5.ConsecutiveInvalidWindows = 0
			value5.LandingCandidate = false
			value5.MeaningfulDescent = false
			value5.CorrectionStarted = false
			value5.PrimaryEvidenceSource = "None"

			if position then
				local y = position.Y
				value5.PeakY = position.Y
				value5.CurrentY = y
			end
		end

		if position then
			rawset(arg, "HighestYSinceGround", position.Y)
		end

		rawset(arg, "AirbornePhase", nil)
		local value6 = rawget(arg, "Evidence")

		if type(value6) == "table" then
			value6.Speed = 0
			value6.Teleport = 0
			value6.Flight = 0
			n += 1
		end

		rawset(arg, "IsSupportedNow", true)
		rawset(arg, "MovementMode", "Grounded")
		rawset(arg, "WasMeaningfullyFalling", false)
		rawset(arg, "ValidationLocked", false)
		rawset(arg, "FirstSuspiciousAt", nil)

		if rawget(arg, "ThreatLevel") ~= "Trusted" then
			rawset(arg, "ThreatLevel", "Trusted")
		end

		tbl2.Patched = sample + n + 5
		tbl2.Mon = rawget(arg, "MonitorRunning") == true
		tbl2.Hist = rawget(arg, "HistoryCount") or -1
		tbl2.Sample = sample
	end

	steal.SpoofStart = function()
		if tbl2.Conn then
			return
		end
		tbl2.Speed = steal.Speed() * steal.HEADROOM
		tbl2.NextSpeedAt = 0

		local function fn8()
			local v2, v3, v4 = fn()

			if v2 then
				if v3 then
					local state = tbl2.State

					if type(state) ~= "table" or rawget(state, "RootPart") ~= v2 or rawget(state, "Humanoid") ~= v3 or rawget(state, "Character") ~= v4 then
						if os.clock() < tbl2.NextSearchAt then
							return
						end
						tbl2.NextSearchAt = os.clock() + 0.2
						tbl2.State = fn5(v3, v2)
					end

					if tbl2.State then
						local now = os.clock()

						if tbl2.NextSpeedAt <= now then
							tbl2.NextSpeedAt = now + 0.25
							tbl2.Speed = steal.Speed() * steal.HEADROOM
						end

						fn7(tbl2.State, tbl2.Speed)
						return
					end

					return
				end

				return
			end
		end

		tbl2.Conn = runService.PreSimulation:Connect(fn8)
		tbl2.Conn2 = runService.PostSimulation:Connect(fn8)
	end

	steal.SpoofStop = function()
		if tbl2.Conn2 then
			pcall(function()
				tbl2.Conn2:Disconnect()
			end)

			tbl2.Conn2 = nil
		end

		if tbl2.Conn then
			pcall(function()
				tbl2.Conn:Disconnect()
			end)

			tbl2.Conn = nil
		end

		tbl2.State = nil
		tbl2.NextSearchAt = 0
		local v2 = tbl2
		local v3 = tbl2
		tbl2.Patched = 0
		v2.Sample = 0
		v3.Hist = -1
		tbl2.Mon = false
	end

	steal.SpoofPatched = function()
		return tbl2.Patched
	end

	steal.SpoofInfo = function()
		return {
			Nempel = tbl2.Conn ~= nil,
			State = tbl2.State ~= nil,
			Patched = tbl2.Patched,
			Sample = tbl2.Sample or 0,
			Monitor = tbl2.Mon == true,
			Hist = tbl2.Hist or -1,
		}
	end
end

do
end

do
	local tbl2 = {
		Inst = nil,
		Pre = nil,
		Post = nil,
		Paksa = false,
		Lompat = false,
		Kunci = 0,
		Owner = tostring(math.random(100000, 1000000)),
	}

	local function fn5()
		for _, child in ipairs(v:GetChildren()) do
			if child:IsA("BasePart") and child.Name == "__SAEHoverPad" and child ~= tbl2.Inst then
				pcall(function()
					child:Destroy()
				end)
			end
		end
	end

	local n = 0.4
	local n2 = 30
	local n3 = 12
	local n4 = 0.05
	local n5 = 3
	local n6 = 20
	local n7 = 2
	local raycastParams = RaycastParams.new()
	raycastParams.FilterType = Enum.RaycastFilterType.Exclude
	raycastParams.RespectCanCollide = true

	local function fn6(arg, arg2)
		raycastParams.FilterDescendantsInstances = { localPlayer.Character, tbl2.Inst }
		return v:Raycast(arg.Position, Vector3.new(0, -(arg2 + n5), 0), raycastParams) ~= nil
	end

	local function fn7()
		if tbl2.Inst then
			if tbl2.Inst.Parent then
				local v2, v3 = fn()

				if v2 then
					if v3 then
						local position = v2.Position
						local v4 = if v3.RigType ~= Enum.HumanoidRigType.R15 then v2.Size.Y * 0.5 + 2 else v2.Size.Y * 0.5 + math.max(v3.HipHeight, 0.5)
						local n8 = position.Y - v4 - 0.55

						if tbl2.Paksa then
							local v5 = tbl2
							tbl2.Paksa = false
							v5.Lompat = false
						else
							local y = v2.AssemblyLinearVelocity.Y
							local flag = os.clock() - (steal.tulisAt or 0) <= n4

							if not tbl2.Lompat and not flag and (v3:GetState() == Enum.HumanoidStateType.Jumping or math.abs(y) > 12) then
								local v5 = tbl2
								local y2 = tbl2.Inst.Position.Y
								tbl2.Lompat = true
								v5.Kunci = y2
							end

							if tbl2.Lompat then
								if not (n8 - tbl2.Kunci > 30) then
									if flag then
										tbl2.Lompat = false
									elseif math.abs(n8 - tbl2.Kunci) <= n and math.abs(y) <= 12 and fn6(v2, v4) then
										tbl2.Lompat = false
									elseif not (n8 < tbl2.Kunci - n) and fn6(v2, v4) then
										n8 = tbl2.Kunci
									elseif not (math.abs(y) <= 2) then
										n8 -= 20
									elseif fn6(v2, v4) then
										tbl2.Lompat = false
									else
										n8 -= 20
									end
								else
									tbl2.Lompat = false
								end
							end
						end

						tbl2.Inst.CFrame = CFrame.new(position.X, n8, position.Z)
						return true
					end

					return false
				end

				return false
			end

			return false
		end

		return false
	end

	steal.Pad = function()
		return tbl2.Inst
	end

	steal.PadStart = function()
		if not tbl2.Inst or not tbl2.Inst.Parent then
			fn5()
			local part = Instance.new("Part")
			part.Name = "__SAEHoverPad"
			part.Anchored = true
			part.CanCollide = true
			part.CanQuery = true
			part.CanTouch = false
			part.CastShadow = false
			part.Transparency = 1
			part.Material = Enum.Material.SmoothPlastic
			part.CustomPhysicalProperties = PhysicalProperties.new(0.7, 2, 0, 100, 1)
			part.Size = Vector3.new(8, 1, 8)
			tbl2.Inst = part
			part.Parent = v
			tbl2.Paksa = true
		end

		tbl2.Paksa = true
		fn7()

		local function fn8()
			if tbl.Alive then
				return true
			end
			local v2 = pcall
			local padStop = steal.PadStop
			v2(padStop)
			return false
		end

		if not tbl2.Pre then
			local v2 = tbl2
			local preSimulation = runService.PreSimulation
			local v3 = preSimulation
			local connect = preSimulation.Connect

			local function fn9()
				if fn8() then
					if fn7() then
						return
					end
					steal.PadStart()
					return
				end
			end

			v2.Pre = connect(v3, fn9)
		end

		if tbl2.Post then
			return
		end
		local postSimulation = runService.PostSimulation
		local v2 = postSimulation
		local connect = postSimulation.Connect

		local function fn9()
			if fn8() then
				fn7()
				return
			end
		end

		tbl2.Post = connect(v2, fn9)
	end

	steal.PadStop = function()
		if tbl2.Pre then
			pcall(function()
				tbl2.Pre:Disconnect()
			end)

			tbl2.Pre = nil
		end

		if tbl2.Post then
			pcall(function()
				tbl2.Post:Disconnect()
			end)

			tbl2.Post = nil
		end

		if tbl2.Inst then
			pcall(function()
				tbl2.Inst:Destroy()
			end)

			tbl2.Inst = nil
		end

		fn5()
	end
end

tbl.ST.Trove:Add(function()
	pcall(steal.PadStop)
end)

local cap
cap = steal.STEP.CAP
local n
n = 0
steal.FPS_ADAPT = true
steal.FPS_BASIS = 60
steal.FPS_MAKS = 4

steal.FrameTarget = function(arg)
	if steal.FPS_ADAPT then
		return math.floor((tonumber(arg) or 0) * steal.FPS_BASIS + 0.5)
	end
	return 0
end

steal.Gerak = function()
	if steal.Running then
		return true
	end

	if steal.pulang then
		return true
	end

	if steal.rampok then
		return true
	end
	local scr = steal.SCR

	if scr then
		if scr.on then
			return true
		end

		if scr.sesi then
			return true
		end

		if scr.balik then
			return true
		end
	end

	if steal.RACE and steal.RACE.on then
		return true
	end

	if steal.WISP then
		local kejar = steal.WISP.kejar
		if kejar then
			return kejar
		end
	end

	return false
end

steal.RideLift = function()
	local ride = steal.RIDE

	if ride then
		if ride.mount then
			if ride.mount.Parent then
				local lift = ride.lift
				if lift then
					return lift
				end
				return 0
			end

			return 0
		end

		return 0
	end

	return 0
end

steal.RidePakai = function()
	local ride = steal.RIDE

	if ride then
		local pakai = ride.pakai
		if pakai then
			return pakai
		end
	end

	return 0
end

steal.Tulis = function(arg, cFrame, arg2)
	local n2 = arg2 and steal.RideLift() or 0
	local v2 = steal.RidePakai()
	local v3 = if v2 < n2 then math.min(n2, v2 + 90 * math.clamp(os.clock() - (steal.tulisAt or 0), 0, 0.1)) else n2

	if steal.RIDE then
		steal.RIDE.pakai = v3
	end

	if v3 > 0 then
		cFrame += Vector3.new(0, v3, 0)
	end

	arg.CFrame = cFrame
	arg.AssemblyLinearVelocity = Vector3.zero
	arg.AssemblyAngularVelocity = Vector3.zero
	steal.tulisAt = os.clock()
	steal.tulisPos = cFrame.Position
end

steal.STYLE = {}
steal.STYLE.TINGGI = 60
steal.STYLE.MIN = 120
steal.STYLE.NAIK = 900
steal.STYLE.TURUN_AWAL = 260
steal.STYLE.TURUN_KALI = 4
steal.STYLE.MET_TINGGI = 200
steal.STYLE.MET_LAJU = 0.5
steal.STYLE.MET_BAGI = 0.6
steal.STYLE.MET_SISA = 0.92
steal.STYLE.MET_MIN_H = 40
steal.STYLE.TEGAK = { "Fly", "Meteor" }

steal.STYLE.Dipilih = function()
	local stealStyle = tbl.UIX and tbl.UIX.STEAL and tbl.UIX.STEAL.StealStyle
	if stealStyle and stealStyle.Has then
		return stealStyle
	end
	return nil
end

steal.STYLE.GayaTegak = function()
	local v2 = steal.STYLE.Dipilih()

	if v2 then
		for _, v3 in ipairs(steal.STYLE.TEGAK) do
			if v2.Has(v3) then
				return v3
			end
		end

		return nil
	end

	return nil
end

steal.STYLE.GayaSamping = function()
	local v2 = steal.STYLE.Dipilih()

	if v2 then
		for _, v3 in ipairs(steal.STYLE.SAMPING) do
			if v2.Has(v3) then
				return v3
			end
		end

		return nil
	end

	return nil
end

steal.STYLE.Rapikan = function(arg, arg2)
	local v2 = nil
	local v3 = nil

	if arg2 ~= "Normal" then
		for _, v4 in ipairs(arg) do
			if table.find(steal.STYLE.TEGAK, v4) then
				if v2 ~= nil then
					if v4 == arg2 then
						v2 = v4
					end
				else
					v2 = v4
				end
			elseif table.find(steal.STYLE.SAMPING, v4) then
				if v3 ~= nil then
					if v4 == arg2 then
						v3 = v4
					end
				else
					v3 = v4
				end
			end
		end
	end

	local tbl2 = {}

	if v2 then
		tbl2[#tbl2 + 1] = v2
	end

	if v3 then
		tbl2[#tbl2 + 1] = v3
	end

	if #tbl2 == 0 then
		tbl2 = { "Normal" }
	end

	table.sort(tbl2)

	if #tbl2 == #arg then
		local flag = true

		for i, v4 in ipairs(tbl2) do
			if v4 ~= arg[i] then
				flag = false
				break
			end
		end

		if flag then
			return
		end
	end

	local v4 = steal.STYLE.Dipilih()
	if v4 and v4.Set then
		v4.Set(tbl2)
		return
	end
end

steal.STYLE.ZIG_AMP = 60
steal.STYLE.ZIG_GEL = 400
steal.STYLE.ZIG_MARGIN = 18
steal.STYLE.CHAOS = { AMP_MIN = 25, AMP_MAX = 60, GEL_MIN = 220, GEL_MAX = 600, LERENG_MAX = 0.94 }
steal.Acak = Random.new()

do
	local function bidang()
		if steal.STYLE.bidang then
			return steal.STYLE.bidang
		end
		local bidang2 = {}
		local world = v:FindFirstChild("World") or v:FindFirstChild("__OBJECTS")
		local areas = world and world:FindFirstChild("Areas")
		local eggCarryBounds = areas and areas:FindFirstChild("EggCarryBounds")

		for _, v2 in ipairs(eggCarryBounds and eggCarryBounds:GetChildren() or {}) do
			if v2:IsA("BasePart") then
				local position = v2.Position
				local size = v2.Size
				bidang2[#bidang2 + 1] = { x = position.X, hx = size.X / 2, z = position.Z, hz = size.Z / 2 }
			end
		end

		if not (#bidang2 > 0) then
			return bidang2
		end
		steal.STYLE.bidang = bidang2
		return bidang2
	end

	local style = steal.STYLE
	style.Bidang = bidang
end

steal.STYLE.Koridor = function(arg)
	for _, v2 in ipairs(steal.STYLE.Bidang()) do
		if math.abs(arg.X - v2.x) <= v2.hx and math.abs(arg.Z - v2.z) <= v2.hz then
			return v2.z, v2.hz
		end
	end
end

steal.STYLE.SAMPING = { "Zig Zag", "Spiral S", "Chaos" }

steal.STYLE.Zig = function(arg, arg2)
	local v2 = steal.STYLE.GayaSamping()
	if steal.STYLE.darat then
		return 0, 0, 0, 1, 0, "segitiga"
	end

	if v2 then
		local zigAmp, zigGel, str2, n2

		if v2 ~= "Chaos" then
			zigAmp = steal.STYLE.ZIG_AMP
			zigGel = steal.STYLE.ZIG_GEL
			str2 = v2 ~= "Spiral S" and "segitiga" or "sinus"
			n2 = 0
		else
			local chaos = steal.STYLE.CHAOS
			local acak = steal.Acak
			zigGel = acak:NextInteger(chaos.GEL_MIN, chaos.GEL_MAX)
			str2 = acak:NextInteger(1, 2) ~= 1 and "sinus" or "segitiga"
			n2 = acak:NextInteger(1, 2) ~= 1 and 0.5 or 0
			zigAmp = math.min(acak:NextInteger(chaos.AMP_MIN, chaos.AMP_MAX), chaos.LERENG_MAX * zigGel / steal.STYLE.Lereng(str2))
		end

		if not (arg < zigGel / 2) then
			local v3, v4 = steal.STYLE.Koridor(arg2)

			if v3 then
				local n3 = math.max(0, v4 - steal.STYLE.ZIG_MARGIN)
				local n4 = math.min(zigAmp, n3)
				if not (n4 < 8) then
					return n4, v3, n3, zigGel, n2, str2
				end
				return 0, 0, 0, 1, 0, str2
			end

			return 0, 0, 0, 1, 0, str2
		end

		return 0, 0, 0, 1, 0, str2
	end

	return 0, 0, 0, 1, 0, "segitiga"
end

steal.STYLE.Gelombang = function(arg, arg2)
	if arg2 ~= "sinus" then
		local n2 = arg - math.floor(arg)

		if not (n2 < 0.25) then
			if not (n2 < 0.75) then
				return 4 * n2 - 4
			end
			return 2 - 4 * n2
		end

		return 4 * n2
	end

	return math.sin(6.2831853071795862 * arg)
end

local function lereng(arg)
	if arg ~= "sinus" then
		return 4
	end
	return 6.2831853071795862
end

steal.STYLE.Lereng = lereng
steal.STYLE.darat = false

steal.STYLE.Rencana = function(arg, arg2, arg3)
	if steal.STYLE.darat then
		return 0, math.huge, arg2
	end

	if not (arg < steal.STYLE.MIN) then
		local v2 = steal.STYLE.GayaTegak()

		if v2 ~= "Fly" then
			if v2 ~= "Meteor" then
				return 0, math.huge, arg2
			end

			if arg3 then
				return 0, math.huge, arg2
			end
			local n2 = v.Gravity * steal.STYLE.TURUN_KALI
			local turunAwal = steal.STYLE.TURUN_AWAL
			local n3 = arg2 * steal.STYLE.MET_LAJU
			local n4 = arg * steal.STYLE.MET_BAGI / math.max(n3, 1)
			local n5 = math.min(steal.STYLE.MET_TINGGI, turunAwal * n4 + n2 * n4 * n4 / 2)
			if not (n5 < steal.STYLE.MET_MIN_H) then
				return n5, math.max(0, arg - n3 * (-turunAwal + math.sqrt(turunAwal * turunAwal + 2 * n2 * n5)) / n2 * steal.STYLE.MET_SISA), n3
			end
			return 0, math.huge, arg2
		end

		return steal.STYLE.TINGGI, math.huge, arg2
	end

	return 0, math.huge, arg2
end

local flag = false

steal.Gerbang = function(arg, arg2)
	if flag then
		return
	end
	local v2 = fn2()

	if v2 then
		if not (v2.Position.Y < steal.GATE_BAWAH) then
			if arg.Y < steal.GATE_BAWAH then
				return
			end
			local flag2 = v2.Position.X <= steal.GATE_X

			if flag2 ~= (arg.X <= steal.GATE_X) then
				flag = true
				local gateOut = flag2 and steal.GATE_OUT or steal.GATE_IN
				local v3 = steal.Glide(flag2 and steal.GATE_IN or steal.GATE_OUT, 20, nil, arg2) and steal.Glide(gateOut, 20, nil, arg2)

				if flag2 and v3 then
					steal.EnterGameplay()
				end

				flag = false
				return v3
			end

			return
		end

		return
	end
end

steal.Glide = function(arg, arg2, arg3, arg4)
	if fn2() then
		local v2 = fn3()

		if typeof(arg) ~= "CFrame" or not arg then
			arg = CFrame.new(arg)
		end

		if steal.Gerbang(arg.Position, arg4) ~= false then
			if steal.TM and steal.TM.NaikPasti and steal.TM.NaikPasti() then
				if not steal.TM.DoffPasti(3) then
					tbl.LOG.warn("TREADMILL", "glide DITAHAN - treadmill tidak mau melepas")
					return false
				end
				tbl.LOG.info("TREADMILL", "turun sebelum glide")
			end

			local v3 = fn2()
			if not v3 or not v3.Parent then
				return false
			end
			n += 1
			local v4 = n
			local n2 = v3.CFrame - Vector3.new(0, steal.RidePakai(), 0)
			local magnitude = (arg.Position - n2.Position).Magnitude

			if not (magnitude < 0.1) then
				local n3 = math.max(v2 and v2.WalkSpeed or 16, 16)
				local n4 = steal.SafeSpeed(steal.Speed(), n3)
				local v5, v6, v7 = steal.STYLE.Rencana(magnitude, n4, arg4 ~= nil)
				local n5 = 0
				local turunAwal = steal.STYLE.TURUN_AWAL
				local n6, v8, v9, v10, v11, v12 = steal.STYLE.Zig(magnitude, n2.Position)
				local vector = Vector3.zero

				if n6 > 0 then
					local n7 = arg.Position - n2.Position
					local vector2 = Vector3.new(n7.X, 0, n7.Z)

					if not (vector2.Magnitude > 1) then
						n6 = 0
						vector = Vector3.zero
					else
						local unit = vector2.Unit
						vector = Vector3.new(-unit.Z, 0, unit.X)
					end
				end

				local v13 = steal.StepCap()
				local n7 = os.clock() + (arg2 or 40)

				local function fn5(arg5)
					if not (n5 <= 0) then
						local n8 = v.Gravity * steal.STYLE.TURUN_KALI
						local v14 = turunAwal

						while true do
							if not (n5 > 0) then
								return
							else
								local result = runService.Heartbeat:Wait()
								local v15 = fn2()

								if v15 then
									if v15.Parent then
										v14 += n8 * result
										n5 = math.max(0, n5 - v14 * result)
										steal.Tulis(v15, arg5 + Vector3.new(0, n5, 0), true)
										continue
									end

									return
								end

								break
							end
						end

						return
					end
				end

				local function fn6()
					local v14 = fn2()

					if v14 and n5 > 0 then
						local v15 = table.pack(CFrame.new(v14.Position.X, v14.Position.Y - n5, v14.Position.Z))
						fn5(table.unpack(v15, 1, v15.n))
						return false
					end

					return false
				end

				while v5 > 0 and n5 < v5 do
					local result = runService.Heartbeat:Wait()
					if n ~= v4 or not tbl.Alive then
						return (fn6())
					end

					if steal.Gerak() then
						local v14 = fn2()

						if v14 then
							if v14.Parent then
								n5 = math.min(v5, n5 + steal.STYLE.NAIK * result)
								steal.Tulis(v14, n2 + Vector3.new(0, n5, 0), true)
								continue
							end

							return (fn6())
						end

						return (fn6())
					end

					return (fn6())
				end

				local now = os.clock()
				local n8 = 0
				local position = nil
				local now2 = nil
				local flag2 = false

				if magnitude > 0 then
					local exitTo = nil

					while true do
						if n ~= v4 or not tbl.Alive then
							exitTo = 1
							break
						else
							if steal.Gerak() then
								if steal.GATE_X < arg.Position.X and steal.NightApproaching and steal.NightApproaching(3) then
									exitTo = 2
									break
								end
								local result = runService.Heartbeat:Wait()
								local v14 = fn2()

								if v14 then
									if v14.Parent then
										if not (n7 < os.clock()) then
											if position and steal.STEP.ROLLBACK < (v14.Position - position).Magnitude then
												n2 = v14.CFrame - Vector3.new(0, steal.RidePakai(), 0)
												magnitude = (arg.Position - n2.Position).Magnitude
												n8 = 0
												if magnitude < 0.1 then
													exitTo = 6
													break
												end
											end

											if arg4 and v14.Position.X > steal.GATE_X and steal.WATCH.GRACE < os.clock() - now then
												if steal.IsHolding(arg4) then
													now2 = nil
												else
													now2 = now2 or os.clock()

													if steal.WATCH.LOST < os.clock() - now2 then
														if os.clock() - steal.ManualDropAt < steal.WATCH.MANUAL then
															exitTo = 7
															break
														end
														v14.AssemblyLinearVelocity = Vector3.zero
														v14.AssemblyAngularVelocity = Vector3.zero
														fn4("egg dropped - re-grabbing")
														local v15 = fn2()

														if v15 and n5 > 0 then
															fn5(CFrame.new(v15.Position.X, v15.Position.Y - n5, v15.Position.Z))
														end

														arg4 = steal.RecoverDropped(arg4)
														if not arg4 then
															exitTo = 8
															break
														end
														v14 = fn2()
														if not v14 then
															exitTo = 9
															break
														end

														if not v14.Parent then
															exitTo = 10
															break
														end
														n2 = v14.CFrame - Vector3.new(0, steal.RidePakai(), 0)
														magnitude = (arg.Position - n2.Position).Magnitude
														now = os.clock()
														steal.Regrabs = steal.Regrabs + 1
														n8 = 0
														now2 = nil
														if magnitude < 0.1 then
															exitTo = 11
															break
														end
													end
												end
											end

											local n9 = 1

											if n6 > 0 then
												local n10 = n6 * steal.STYLE.Lereng(v12) / v10
												n9 = math.sqrt(1 + n10 * n10)
											end

											local flag3 = n8 >= v6
											local v15 = flag3 and v7 or n4

											if n5 > 0 and flag3 then
												turunAwal += v.Gravity * steal.STYLE.TURUN_KALI * result
												n5 = math.max(0, n5 - turunAwal * result)
											end

											n8 = math.min(magnitude, n8 + math.min(v15 * result, v13) / n9)
											local v16 = n2:Lerp(arg, n8 / magnitude)

											if n5 > 0 then
												v16 += Vector3.new(0, n5, 0)
											end

											if n6 > 0 then
												local n10 = v16.Position + vector * n6 * steal.STYLE.Gelombang(n8 / v10 + v11, v12)
												v16 += Vector3.new(n10.X - v16.Position.X, 0, math.clamp(n10.Z, v8 - v9, v8 + v9) - v16.Position.Z)
											end

											steal.Tulis(v14, v16, true)
											position = v14.Position

											if arg3 and not flag2 and magnitude - n8 <= 28 then
												local v17 = arg3

												local function fn7()
													local EggWorld = tbl.NET.Get("EggWorld", "AskFieldEggCarry")
													if EggWorld then
														pcall(EggWorld.InvokeServer, EggWorld, { Uid = v17 })
														return
													end
												end

												task.spawn(fn7)
												flag2 = true
											end

											if not (n8 < magnitude) then
												exitTo = 6
												break
											end
											continue
										end

										exitTo = 5
										break
									end

									exitTo = 4
									break
								end

								exitTo = 3
								break
							end

							break
						end
					end

					if exitTo == 1 then
						return (fn6())
					end

					if exitTo == 2 then
						return (fn6())
					end

					if exitTo == 3 then
						return (fn6())
					end

					if exitTo == 4 then
						return (fn6())
					end

					if exitTo == 5 then
						return (fn6())
					end

					if exitTo ~= 6 then
						if exitTo == 7 then
							tbl.LOG.info("STEAL", "drop manual - tidak dipungut ulang")
							return (fn6())
						end

						if exitTo == 8 then
							return (fn6())
						end

						if exitTo == 9 then
							return false
						end

						if exitTo == 10 then
							return false
						end

						if exitTo ~= 11 then
							return (fn6())
						end
					end
				end

				if n ~= v4 then
					return false
				end
				fn5(arg)
				cap = math.min(steal.STEP.MAX, cap + steal.STEP.UP)
				local v14 = fn2()
				if v14 then
					steal.Tulis(v14, arg, true)
					return true
				end
				return true
			end

			steal.Tulis(v3, arg, true)
			return true
		end

		return false
	end

	return false
end

steal.GlideRetry = function(arg, arg2, arg3, arg4, arg5)
	for i = 1, arg3 or 3 do
		if steal.Glide(arg, arg2, arg4, arg5) then
			return true
		end

		if tbl.Alive then
			if steal.Gerak() then
				task.wait(0.15)
				continue
			end
			return false
		end

		return false
	end

	return false
end

local fn5, fn6, fn7, fn8, fn9, v2, v3, asset, fn10, rarityIdOf
local weightKgOf, fn11, valueOf

do
	steal.SPEED_FIX = nil

	steal.Speed = function()
		if steal.SPEED_FIX then
			return steal.SPEED_FIX
		end
		local v4 = steal.INSTANT.BoostLaju()
		if v4 then
			return v4
		end
		local speedPct = steal.SPEED_PCT
		local autoStealSpeed = tbl.UIX and tbl.UIX.STEAL and tbl.UIX.STEAL.AutoStealSpeed

		if autoStealSpeed and autoStealSpeed.Get then
			speedPct = tonumber(autoStealSpeed.Get()) or steal.SPEED_PCT
		end

		return steal.SafeSpeed(steal.MAX_SPEED * speedPct / 100, 120)
	end

	local function fn12(arg, arg2)
		local uix = tbl.UIX and tbl.UIX[arg]
		local v4 = uix and uix[arg2]
		if not v4 or not v4.Get or v4.Has then
			return nil
		end
		local v5 = v4.Get()

		if v5 ~= nil then
			if v5 ~= "" then
				if v5 ~= "All (none)" then
					if v5 ~= "None" then
						return v5
					end
					return nil
				end

				return nil
			end

			return nil
		end

		return nil
	end

	local function fn13(arg, arg2)
		local uix = tbl.UIX and tbl.UIX[arg]
		local v4 = uix and uix[arg2]
		if v4 and v4.Any and v4.Has and v4.Any() then
			return function(arg3)
				return v4.Has(arg3)
			end
		end
		return nil
	end

	local tbl2 = { k = 1000, m = 1000000, b = 1e9, t = 1e12, q = 1e15 }

	steal.Num = function(arg)
		if type(arg) ~= "number" then
			local str2 = tostring(arg or ""):lower():gsub("[%s,%$]", "")
			local str3, v4 = str2:gsub("%.", "")

			if not (v4 > 1) then
				if str2 == "" then
					return 0
				end
			else
				str2 = str2:gsub("%.", "")
				if str2 == "" then
					return 0
				end
			end

			local match, v5 = str2:match("^(%-?%d*%.?%d+)([kmbtq]?)a?$")
			if match then
				return (tonumber(match) or 0) * (tbl2[v5] or 1)
			end
			local num = tonumber(str2)
			if num then
				return num
			end
			return 0
		end

		return arg
	end

	steal.Duit = function(arg)
		local n2 = tonumber(arg) or 0

		if not (n2 >= 1e12) then
			if not (n2 >= 1e9) then
				if not (n2 >= 1000000) then
					if not (n2 >= 1000) then
						return ("$%d"):format(n2)
					end
					return ("$%.1fK"):format(n2 / 1000)
				end

				return ("$%.2fM"):format(n2 / 1000000)
			end

			return ("$%.2fB"):format(n2 / 1e9)
		end

		return ("$%.2fT"):format(n2 / 1e12)
	end

	steal.Filters = function()
		local saringanQuest = steal.WISP and steal.WISP.SaringanQuest and steal.WISP.SaringanQuest()
		if saringanQuest then
			return saringanQuest
		end
		local filter = tbl.UIX and tbl.UIX.FILTER
		local minEggKG = filter and filter.MinEggKG
		local n2 = 0

		if minEggKG and minEggKG.Get then
			n2 = steal.Num(minEggKG.Get())
		end

		local minEggValue = filter and filter.MinEggValue
		local n3 = 0

		if minEggValue and minEggValue.Get then
			n3 = steal.Num(minEggValue.Get())
		end

		return {
			Pet = fn13("FILTER", "PetNames"),
			Area = fn13("FILTER", "Areas"),
			Rarity = fn13("FILTER", "Rarities"),
			Priority = fn12("FILTER", "Priority") or "Rarity",
			MinKG = n2,
			MinValue = n3,
			Teleport = steal.TSOn(),
		}
	end

	-- Accept list-form and UID-keyed record maps. Never modify the game's own cache.
	steal.NormalizeEggRecords = function(snapshot)
		if type(snapshot) ~= "table" then return nil end
		local source = type(snapshot.Records) == "table" and snapshot.Records or snapshot
		local normalized = {}
		for key, rec in pairs(source) do
			if type(rec) == "table" and rec.State ~= nil then
				local uid = rec.Uid
				if uid == nil and type(key) == "string" then uid = key end
				if uid ~= nil then
					if rec.Uid == nil then
						local copy = table.clone(rec)
						copy.Uid = uid
						rec = copy
					end
					normalized[tostring(uid)] = rec
				end
			end
		end
		return normalized
	end

	-- A failed/empty remote request must not run once for every Heartbeat caller.
	steal.SnapshotLastError = nil
	steal.SnapshotCache = {}
	local snapshotNextAt = 0
	fn5 = function(force)
		local now = os.clock()
		if not force and now < snapshotNextAt then return steal.SnapshotCache end
		snapshotNextAt = now + 1.5
		local ok, snapshot = tbl.NET.Invoke("EggWorld", "AskFieldEggSnapshot")
		if ok then
			local records = steal.NormalizeEggRecords(snapshot)
			if records then
				steal.SnapshotCache = records
				steal.SnapshotLastError = nil
				return records
			end
			steal.SnapshotLastError = "snapshot did not contain recognized egg records"
		else
			steal.SnapshotLastError = "EggWorld/AskFieldEggSnapshot unavailable or rejected"
		end
		return steal.SnapshotCache
	end

	fn6 = function()
		for _, v4 in pairs(fn5()) do
			if tostring(v4.CarrierUserId) == str then
				return tostring(v4.Uid)
			end
		end
	end

	fn7 = function(arg, arg2)
		-- Game versions may render slots as a Part, Model or nested container.
		-- Never read PrimaryPart on a BasePart (it is not a BasePart property).
		for _, containerName in ipairs({ "AreaEggSlotsClient", "PlacedEggRenders" }) do
			local container = v:FindFirstChild(containerName)
			local object = container and (container:FindFirstChild(arg) or container:FindFirstChild(arg, true))
			if object then
				local part = nil
				if object:IsA("BasePart") then
					part = object
				else
					local hitbox = object:FindFirstChild("Hitbox", true)
					if hitbox and hitbox:IsA("BasePart") then
						part = hitbox
					elseif object:IsA("Model") then
						part = object.PrimaryPart or object:FindFirstChildWhichIsA("BasePart", true)
					else
						part = object:FindFirstChildWhichIsA("BasePart", true)
					end
				end
				if part then return part.Position end
			end
		end
		return arg2
	end

	fn8 = function(arg, arg2, arg3)
		local huge = math.huge
		local v4 = nil
		local huge2 = math.huge
		local v5 = nil

		for _, v6 in pairs(fn5()) do
			if typeof(v6.BottomCFrame) == "CFrame" and tostring(v6.State) == "Slot" then
				if tostring(v6.Uid):find(str, 1, true) then
					continue
				end
				local str2 = tostring(v6.Uid)
				local magnitude = (v6.BottomCFrame.Position - arg).Magnitude
				if not (magnitude < 14) then
					continue
				end

				if arg3 and str2 == arg3 then
					return str2
				end

				if arg2 then
					if tostring(v6.AssetCategory) ~= arg2 then
						if magnitude < huge2 then
							huge2 = magnitude
							v5 = str2
						end
					elseif magnitude < huge then
						huge = magnitude
						v4 = str2
					end
				elseif magnitude < huge2 then
					huge2 = magnitude
					v5 = str2
				end
			end
		end

		if v4 then
			return v4
		end

		if not arg2 and v5 then
			return v5
		end
		return nil
	end

	fn9 = function(arg)
		if arg then
			local ok, result = pcall(require, arg)
			if ok and result then
				return result
			end
			return nil
		end

		return nil
	end

	local data = tbl.SV.ReplicatedStorage:FindFirstChild("Data")
	local v4

	if data then
		v2 = fn9(data:FindFirstChild("Assets"))
		v4 = fn9(data:FindFirstChild("Rarity")) or fn9(data:FindFirstChild("Rarities"))
		v3 = fn9(data:FindFirstChild("Areas"))
	else
		v2 = data
		v4 = data
		v3 = data
	end

	local v5 = fn9(tbl.SV.ReplicatedStorage:FindFirstChild("Shared") and tbl.SV.ReplicatedStorage.Shared:FindFirstChild("Modules") and tbl.SV.ReplicatedStorage.Shared.Modules:FindFirstChild("Mutations"))

	asset = function(arg)
		if v2 and v2.Directory then
			local v6 = v2.Directory[arg]
			if v6 then
				return v6
			end
		end

		return nil
	end

	steal.AssetIcon = function(arg)
		local str2 = tostring(arg or "")

		if str2 ~= "" then
			local v6 = asset(str2)

			if not v6 and v2 and v2.Directory then
				for _, v7 in pairs(v2.Directory) do
					if type(v7) == "table" and tostring(v7.DisplayName) == str2 then
						v6 = v7
						break
					end
				end
			end

			if v6 then
				return (tostring(v6.Icon or ""))
			end
			return ""
		end

		return ""
	end

	local function fn14(arg)
		if type(arg) ~= "table" then
			return nil
		end
		local value = rawget(arg, "Rank")

		if type(value) ~= "number" then
			value = rawget(arg, "RarityNumber")
		end

		if type(value) == "number" and value then
			return value
		end
		return nil
	end

	fn10 = function(arg)
		local v6 = asset(arg)
		if not v6 then
			return 0
		end

		local ok, result = pcall(function()
			return fn14(v6.Rarity)
		end)

		if ok and result then
			return result
		end
		return 0
	end

	rarityIdOf = function(arg)
		local v6 = asset(arg)
		if not v6 then
			return "?"
		end

		local ok, result = pcall(function()
			return v6.Rarity._id
		end)

		if ok then
			return (tostring(result))
		end
		return "?"
	end

	weightKgOf = function(arg)
		local str2 = tostring(arg.AssetCategory)
		local n2 = tonumber(arg.AssetScale) or 1
		local v6 = asset(str2)
		if v6 and type(v6.ModelWeight) == "number" then
			return v6.ModelWeight * math.max(n2, 0) ^ 3
		end
		return n2
	end

	steal.BIGVPS = {
		URL = "http://143.14.13.87:8080/api/big-egg",
		MIN_KG = 10000000,
		siklus = nil,
		kirim = {},
		PERIODE = 300,
	}

	steal.BIGVPS.Siklus = function()
		local serverTimeNow = v:GetServerTimeNow()

		local ok, result = pcall(function()
			return require(tbl.SV.ReplicatedStorage.Shared.Util.AreaEggCycle)
		end)

		if ok and type(result) == "table" and type(result.ActivePeriodIndexAt) == "function" then
			local ok2, result2 = pcall(result.ActivePeriodIndexAt, serverTimeNow)
			if ok2 and tonumber(result2) then
				return math.floor(tonumber(result2))
			end
		end

		return math.floor(serverTimeNow / steal.BIGVPS.PERIODE)
	end

	local function fn15(arg)
		local n2 = math.abs(arg)

		if not (n2 >= 1e15) then
			if n2 >= 1e12 then
				return ("%.2fT KG"):format(arg / 1e12)
			end
		elseif n2 == n2 then
			return ("%.2fQa KG"):format(arg / 1e15)
		end

		if not (n2 >= 1e9) then
			if not (n2 >= 1000000) then
				if not (n2 >= 1000) then
					return ("%d KG"):format(math.floor(arg))
				end
				return ("%.2fK KG"):format(arg / 1000)
			end

			return ("%.2fM KG"):format(arg / 1000000)
		end

		return ("%.2fB KG"):format(arg / 1e9)
	end

	steal.BIGVPS.Lapor = function()
		local v6 = steal.BIGVPS.Siklus()

		if steal.BIGVPS.siklus ~= v6 then
			local n2 = 0
			local ok, result = pcall(steal.FieldRecords)

			if ok then
				if type(result) ~= "table" then
					return
				end
				local v7 = nil

				for _, v8 in pairs(result) do
					local ok2, result2 = pcall(weightKgOf, v8)

					if ok2 and type(result2) == "number" and result2 > n2 then
						n2 = result2
						v7 = v8
					end
				end

				if v7 then
					if not (steal.BIGVPS.MIN_KG <= n2) then
						return
					end
					local str2 = tostring(v7.Uid or "")
					local str3 = str2 .. "|" .. tostring(game.JobId)
					if steal.BIGVPS.kirim[str3] then
						return
					end
					steal.BIGVPS.siklus = v6
					steal.BIGVPS.kirim[str3] = true
					local str4 = tostring(v7.AssetCategory or "Unknown")
					local v8 = asset(str4)
					local v9, v10 = steal.AreaDi(typeof(v7.BottomCFrame) == "CFrame" and v7.BottomCFrame.Position or typeof(v7.BoundsCFrame) == "CFrame" and v7.BoundsCFrame.Position or Vector3.zero)
					local v11 = tostring
					local areaId = v7.AreaId
					local areaId2

					if areaId then
						areaId2 = areaId
					elseif v8 then
						local area = v8.Area

						if area then
							areaId2 = area
						else
							areaId2 = v8.AreaId or v10 or "Unknown"
						end
					else
						areaId2 = v10 or "Unknown"
					end

					local v12 = v11(areaId2)
					local v13 = tostring
					local id

					if v8 and v8.Rarity then
						id = v8.Rarity._id or v8.Rarity.Rank or "Unknown"
					else
						id = "Unknown"
					end

					local v14 = v13(id)
					local ok2, result2 = pcall(steal.ValueOf, v7)

					if not ok2 or type(result2) ~= "number" or not (result2 > 0) or not result2 then
						result2 = nil
					end

					local v15, v16, v17 = pairs(type(v7.Mutations) == "table" and v7.Mutations or {})
					local n3 = 0

					for _, v18 in v15, v16, v17 do
						if v18 and tostring(v18) ~= "None" and tostring(v18) ~= "" then
							n3 += 1
						end
					end

					local tbl3 = {
						event = "BIG_EGG_DISCOVERED",
						placeId = game.PlaceId,
						jobId = game.JobId,
						serverPlayers = #tbl.SV.Players:GetPlayers(),
						timestamp = os.time(),
						isoTime = os.date("!%Y-%m-%dT%H:%M:%SZ"),
					}

					tbl3.egg = {
						name = str4,
						weightKg = n2,
						weightFormatted = fn15(n2),
						area = string.upper(v12),
						rarity = v14,
						scale = tonumber(v7.AssetScale) or 1,
						uid = str2,
						value = result2,
						valueFormatted = if result2 then steal.Duit(result2) .. "/s" else nil,
						mutations = n3,
					}

					tbl3.joinScript = ("game:GetService('TeleportService'):TeleportToPlaceInstance(%d, %q, game.Players.LocalPlayer)"):format(game.PlaceId, game.JobId)

					local function fn16()
						local request_ = request or http_request or syn and syn.request
						if type(request_) ~= "function" then
							tbl.LOG.warn("BIGVPS", "executor tidak punya request()")
							return
						end

						local function fn17()
							return tbl.SV.HttpService:JSONEncode(tbl3)
						end

						local ok3, result3 = pcall(fn17)

						if ok3 then
							local ok4, result4 = pcall(request_, {
								Url = steal.BIGVPS.URL,
								Method = "POST",
								Headers = { ["Content-Type"] = "application/json" },
								Body = result3,
							})

							local statusCode

							if ok4 and result4 then
								statusCode = result4.StatusCode or result4.Status or nil
							else
								statusCode = nil
							end

							if statusCode ~= 200 and statusCode ~= 201 and statusCode ~= 204 then
								steal.BIGVPS.siklus = nil
								steal.BIGVPS.kirim[str3] = nil
								tbl.LOG.warn("BIGVPS", "gagal kirim: " .. tostring(statusCode or "no response"))
								return
							end

							tbl.LOG.info("BIGVPS", ("terkirim: %s %s di %s (siklus %d)"):format(str4, fn15(n2), v12, v6))
							return
						end

						tbl.LOG.warn("BIGVPS", "gagal encode: " .. tostring(result3))
					end

					task.spawn(fn16)
					return
				end

				return
			end

			return
		end
	end

	fn11 = function(arg)
		if type(arg) ~= "table" then
			return 0
		end
		local n2 = 0

		for _, v6 in pairs(arg) do
			local str2 = tostring(v6)

			if v6 and str2 ~= "None" and str2 ~= "" then
				n2 += 1
			end
		end

		return n2
	end

	local function fn16(arg)
		if v5 then
			if arg then
				if steal.mutFn == nil then
					steal.mutFn = false

					for _, v6 in ipairs({ "EarningsFor", "GetTotalMutationsEarningMulti" }) do
						if type(v5[v6]) ~= "function" then
							continue
						end
						steal.mutFn = v5[v6]
						break
					end
				end

				if steal.mutFn then
					local ok, result = pcall(steal.mutFn, arg)
					if ok and type(result) == "number" and result then
						return result
					end
					return 1
				end

				return 1
			end

			return 1
		end

		return 1
	end

	valueOf = function(arg)
		local earn = steal.INV and steal.INV.Earn and steal.INV.Earn()

		if earn then
			local ok, result = pcall(earn.RatePerSecond, {
				Category = arg.AssetCategory,
				Scale = tonumber(arg.AssetScale) or 1,
				Mutations = arg.Mutations or {},
			})

			if ok and type(result) == "number" and result > 0 then
				return result
			end
		end

		local v6 = asset(tostring(arg.AssetCategory))
		local n2 = 0

		if v6 then
			local function fn17()
				return v6.EarningRate
			end

			local ok, result = pcall(fn17)

			if ok and type(result) == "number" then
				n2 = result
			end
		end

		return n2 * fn16(arg.Mutations) * (tonumber(arg.AssetScale) or 1)
	end

	steal.HIDDEN_RARITIES = {
		Superior = true,
		Exotic = true,
		Exclusive = true,
		Mythical = true,
		Limited = true,
		BrainrotGod = true,
		Rainbow = true,
		LightDark = true,
		Titan = true,
		Transcendent = true,
	}

	steal.RarityList = function()
		local tbl3 = {}
		local tbl4 = {}
		local v6 = v4
		local rarities

		if v4 then
			rarities = v4.Rarities or v4
		else
			rarities = v6
		end

		if rarities then
			pcall(function()
				for _, rarity in pairs(rarities) do
					local v7 = fn14(rarity)

					if type(rarity) == "table" and rarity._id and v7 and not tbl4[rarity._id] then
						local str2 = tostring(rarity._id)
						local flag2 = false

						for k in pairs(steal.HIDDEN_RARITIES) do
							if str2:lower() ~= k:lower() then
								continue
							end
							flag2 = true
							break
						end

						if not flag2 then
							tbl4[rarity._id] = true
							tbl3[#tbl3 + 1] = { v7, str2 }
						end
					end
				end
			end)
		end

		table.sort(tbl3, function(arg, arg2)
			return arg[1] > arg2[1]
		end)

		local tbl5 = {}

		for _, v7 in ipairs(tbl3) do
			tbl5[#tbl5 + 1] = v7[2]
		end

		if #tbl5 ~= 0 then
			return tbl5
		end

		return {
			"LightDark",
			"Titan",
			"Divine",
			"Eternal",
			"Secret",
			"Cosmic",
			"Mythic",
			"Legendary",
			"Epic",
			"Rare",
			"SuperRare",
			"Uncommon",
			"Celestial",
			"Basic",
			"Common",
		}
	end

	steal.AREA_ORDER = {
		["Enchanted Forest"] = 0,
		["Titan Temple"] = 1,
		["Cherry Blossom"] = 2,
		Sakura = 2,
		["Light Dark"] = 3,
		Cosmic = 4,
		Prehistoric = 5,
		["Abyss Ocean"] = 6,
		Volcano = 7,
		Snow = 8,
		Jungle = 9,
		Desert = 10,
		Lake = 11,
		Forest = 12,
	}

	steal.Dunia = function()
		local duniaCache = steal.duniaCache
		if duniaCache and duniaCache.Parent then
			return duniaCache
		end
		steal.duniaCache = nil

		for _, v6 in ipairs({ "World", "__OBJECTS" }) do
			local v7 = v:FindFirstChild(v6)
			if v7 then
				steal.duniaCache = v7
				return v7
			end
		end

		return nil
	end

	steal.Areas = function()
		local areasCache = steal.areasCache
		if areasCache and areasCache.Parent then
			return areasCache
		end
		steal.areasCache = nil
		local v6 = steal.Dunia()
		local areas = v6 and v6:FindFirstChild("Areas")
		if areas then
			steal.areasCache = areas
			return areas
		end
		return nil
	end

	steal.AreaSpots = function()
		local tbl3 = {}
		local v6 = steal.Areas()
		local guardAreas = v6 and v6:FindFirstChild("GuardAreas")

		for _, v7 in ipairs(guardAreas and guardAreas:GetChildren() or {}) do
			local bounds = v7:FindFirstChild("Bounds")

			if bounds and bounds:IsA("BasePart") then
				tbl3[#tbl3 + 1] = { name = v7.Name, pos = bounds.Position + Vector3.new(0, 4, 0), size = bounds.Size }
			end
		end

		return tbl3
	end

	steal.AreaX = function()
		local tbl3 = {}

		for _, v6 in ipairs(steal.AreaSpots()) do
			tbl3[v6.name] = v6.pos.X
		end

		return tbl3
	end

	steal.AreaList = function()
		local tbl3 = {}
		local tbl4 = {}
		local v6 = v3
		local directory

		if v3 then
			directory = v3.Directory or v3
		else
			directory = v6
		end

		if type(directory) == "table" then
			pcall(function()
				for k, v7 in pairs(directory) do
					local name = type(v7) == "table" and (v7.Name or v7._id or v7.Title) or tostring(k)

					if not tbl4[name] and not steal.AREA_HARAM[name] then
						tbl4[name] = true
						tbl3[#tbl3 + 1] = name
					end
				end
			end)
		end

		if #tbl3 == 0 then
			for _, v7 in pairs(fn5()) do
				local str2 = tostring(v7.AreaId)

				if str2 ~= "nil" and not tbl4[str2] and not steal.AREA_HARAM[str2] then
					tbl4[str2] = true
					tbl3[#tbl3 + 1] = str2
				end
			end
		end

		local v7 = steal.AreaX()

		table.sort(tbl3, function(arg, arg2)
			local v8 = v7[arg]
			local v9 = v7[arg2]

			if v8 then
				if v9 and v8 ~= v9 then
					return v8 > v9
				end

				if not v9 then
					return true
				end
			end

			if v9 and not v8 then
				return false
			end
			local n2 = steal.AREA_ORDER[arg] or 99
			local n3 = steal.AREA_ORDER[arg2] or 99
			if n2 ~= n3 then
				return n2 < n3
			end
			return arg < arg2
		end)

		return tbl3
	end

	local function saveData()
		local ok, result = pcall(function()
			return require(tbl.SV.ReplicatedStorage.Shared.Save)
		end)

		if ok then
			if type(result) ~= "table" then
				return nil
			end

			for _, v6 in ipairs({ "Get", "ReadUnguarded", "Peek" }) do
				if type(result[v6]) ~= "function" then
					continue
				end
				local ok2, result2 = pcall(result[v6])
				if ok2 and type(result2) == "table" and type(result2.EggInventory) == "table" then
					return result2
				end
			end

			return
		end

		return nil
	end

	steal.SaveData = saveData

	steal.RIFT = {
		state = nil,
		at = 0,
		stok = {},
		stokAt = 0,
		medan = "--",
		medanAda = false,
		jalan = {},
		Prioritas = false,
		BannerPilih = {},
	}

	steal.RIFT.Tarik = function(arg)
		if not arg and steal.RIFT.state and os.clock() - steal.RIFT.at < 30 then
			return steal.RIFT.state
		end
		local Rift, v6 = tbl.NET.Invoke("Rift", "AskState")

		if Rift and type(v6) == "table" then
			steal.RIFT.state = v6
			steal.RIFT.at = os.clock()
			steal.RIFT.stokAt = 0
			table.clear(steal.RIFT.jalan)
		end

		return steal.RIFT.state
	end

	steal.RIFT.Sisa = function()
		local state = steal.RIFT.state
		if state then
			return math.max(0, (tonumber(state.SecondsUntilRotation) or 0) - os.clock() - steal.RIFT.at)
		end
		return 0
	end

	steal.RIFT.Segar = function()
		if not (os.clock() - steal.RIFT.stokAt < 1) then
			local state = steal.RIFT.state
			local stok = {}
			local tbl3 = {}

			if state and type(state.Requirements) == "table" then
				local v6 = steal.SaveData()

				for _, requirement in ipairs(state.Requirements) do
					local str2 = tostring(requirement):lower()
					local v7 = tbl3[str2]

					if v7 then
						v7.butuh = v7.butuh + 1
					else
						local n2 = 0

						for _, v8 in pairs(v6 and v6.Inventory or {}) do
							if type(v8) == "table" and v8.IsFavorite ~= true and v8.InFuse ~= true and tostring(v8.Category or ""):lower() == str2 then
								n2 += 1
							end
						end

						local n3 = 0
						local n4 = 0

						for _, v8 in pairs(v6 and v6.EggInventory or {}) do
							if type(v8) == "table" and tostring(v8.AssetCategory or ""):lower() == str2 then
								n3 += 1

								if v8.Placement == nil then
									n4 += 1
								end
							end
						end

						local tbl4 = {
							nama = tostring(requirement),
							kunci = str2,
							butuh = 1,
							pet = n2,
							telur = n3,
							bebas = n4,
						}

						tbl3[str2] = tbl4
						stok[#stok + 1] = tbl4
					end
				end
			end

			local rift = steal.RIFT
			local rift2 = steal.RIFT
			local now = os.clock()
			rift.stok = stok
			rift2.stokAt = now
			return stok
		end

		return steal.RIFT.stok
	end

	steal.RIFT.Banners = function()
		steal.RIFT.Tarik(false)
		local tbl3 = {}

		for _, v6 in ipairs(steal.RIFT.state and steal.RIFT.state.BannerOdds or {}) do
			if v6.Id then
				tbl3[#tbl3 + 1] = tostring(v6.Id)
			end
		end

		table.sort(tbl3)
		return tbl3
	end

	steal.RIFT.BannerOk = function()
		if next(steal.RIFT.BannerPilih) ~= nil then
			local state = steal.RIFT.state

			if state then
				if state.BannerId then
					return steal.RIFT.BannerPilih[tostring(state.BannerId)] == true
				end
				return true
			end

			return true
		end

		return true
	end

	steal.RIFT.Lapangan = function()
		local tbl3 = {}
		local tbl4 = {}

		for _, v6 in ipairs(steal.RIFT.stok) do
			local tbl5 = { nama = v6.nama, n = 0, area = {}, ada = {} }
			tbl4[v6.kunci] = tbl5
			tbl3[#tbl3 + 1] = tbl5
		end

		if #tbl3 > 0 then
			for _, v6 in pairs(steal.FieldRecords()) do
				if tostring(v6.State) == "Slot" then
					local v7 = tbl4[tostring(v6.AssetCategory or ""):lower()]

					if v7 then
						v7.n = v7.n + 1
						local str2 = tostring(v6.AreaId or "?")

						if not v7.ada[str2] then
							v7.ada[str2] = true
							v7.area[#v7.area + 1] = str2
						end
					end
				end
			end
		end

		local tbl5 = {}
		local medanAda = false

		for _, v6 in ipairs(tbl3) do
			if not (v6.n > 0) then
				tbl5[#tbl5 + 1] = ("%s 0"):format(v6.nama)
			else
				table.sort(v6.area)
				tbl5[#tbl5 + 1] = ("%s %d in %s"):format(v6.nama, v6.n, table.concat(v6.area, "/"))
				medanAda = true
			end
		end

		steal.RIFT.medan = not (#tbl5 > 0) and "--" or table.concat(tbl5, "  |  ")
		steal.RIFT.medanAda = medanAda
	end

	steal.RIFT.Butuh = function(arg)
		if arg then
			if steal.RIFT.BannerOk() then
				local str2 = tostring(arg):lower()

				for _, v6 in ipairs(steal.RIFT.stok) do
					if v6.kunci ~= str2 then
						continue
					end
					local n2 = steal.RIFT.jalan[str2] or 0
					return (v6.bebas or 0) + (os.clock() < n2 and 1 or 0) < v6.butuh
				end

				return false
			end

			return false
		end

		return false
	end

	steal.RIFT.Resep = function(arg)
		if arg then
			local str2 = tostring(arg):lower()

			for _, v6 in ipairs(steal.RIFT.stok) do
				if v6.kunci == str2 then
					return true
				end
			end

			return false
		end

		return false
	end

	steal.RIFT.Kejar = function(arg)
		if arg then
			steal.RIFT.jalan[tostring(arg):lower()] = os.clock() + 300
			return
		end
	end

	tbl.NET.On("Rift", "BannerRotated", function()
		steal.RIFT.Tarik(true)
	end)

	steal.LAB = {
		on = false,
		status = "Off",
		siap = 0,
		total = 3,
		kurang = "None",
		BannerPilih = {},
		POLL = 0.5,
		TUNGGU_TUKAR = 8,
		ENDAP_REVEAL = 0.8,
		DEKAT = 7,
	}

	local lab = steal.LAB
	local lab2 = steal.LAB
	local lab3 = steal.LAB
	steal.LAB.state = nil
	lab.at = 0
	lab2.stok = {}
	lab3.stokAt = 0

	steal.LAB.Tarik = function(arg)
		local n2 = os.clock() - steal.LAB.at

		if not arg and steal.LAB.state and n2 < 30 then
			if steal.LAB.Sisa() > 0 then
				return steal.LAB.state
			end

			if n2 < 2 then
				return steal.LAB.state
			end
		end

		local ScrambleTradeIn, v6 = tbl.NET.Invoke("ScrambleTradeIn", "AskState")

		if ScrambleTradeIn and type(v6) == "table" then
			steal.LAB.state = v6
			steal.LAB.at = os.clock()
			steal.LAB.stokAt = 0
		end

		return steal.LAB.state
	end

	steal.LAB.Sisa = function()
		local state = steal.LAB.state
		if state then
			return math.max(0, (tonumber(state.SecondsUntilRotation) or 0) - os.clock() - steal.LAB.at)
		end
		return 0
	end

	steal.LAB.Banners = function()
		steal.LAB.Tarik(false)
		local tbl3 = {}

		for _, v6 in ipairs(steal.LAB.state and steal.LAB.state.BannerOdds or {}) do
			if v6.Id then
				tbl3[#tbl3 + 1] = tostring(v6.Id)
			end
		end

		table.sort(tbl3)
		return tbl3
	end

	steal.LAB.RAMAL = { at = 0, rot = nil, now = nil, nowAt = nil, daftar = {} }
	steal.LAB.RAMAL_SEGAR = 20
	steal.LAB.RAMAL_N = 5

	steal.LAB.Ramal = function()
		local ramal = steal.LAB.RAMAL
		if ramal.at > 0 and os.clock() - ramal.at < steal.LAB.RAMAL_SEGAR then
			return ramal
		end
		ramal.at = os.clock()

		task.spawn(function()
			pcall(function()
				local ScrambleTradeIn = require(game:GetService("ReplicatedStorage").Data.ScrambleTradeIn)
				local v6 = ScrambleTradeIn.RotationSeconds()
				local v7 = ScrambleTradeIn.CurrentPeriod()

				local function fn17(arg)
					local v8

					if ScrambleTradeIn.GetBannerDisplayName then
						v8 = ScrambleTradeIn.GetBannerDisplayName(arg) or arg
					else
						v8 = arg
					end

					local chasePetId = ScrambleTradeIn.ChasePetId and ScrambleTradeIn.ChasePetId(arg) or nil
					local n2 = nil

					if chasePetId and ScrambleTradeIn.GetPetWeight then
						local v9 = ScrambleTradeIn.GetPetWeight(arg, chasePetId)
						local getBanner = ScrambleTradeIn.GetBanner and ScrambleTradeIn.GetBanner(arg)
						local v10, v11, v12 = pairs(getBanner and getBanner.Pets or {})
						local n3 = 0

						for _, v13 in v10, v11, v12 do
							n3 += tonumber(v13.Weight) or 0
						end

						if v9 and n3 > 0 then
							n2 = v9 / n3 * 100
						end
					end

					local str2 = tostring(v8)
					if chasePetId then
						return str2, tostring(chasePetId), n2
					end
					return str2, nil, n2
				end

				local daftar = {}

				for i = 1, steal.LAB.RAMAL_N do
					local n2 = v7 + i
					local str2 = tostring(ScrambleTradeIn.BannerIdForPeriod(n2))
					local v8, v9, v10 = fn17(str2)
					daftar[i] = { id = str2, disp = v8, chase = v9, pct = v10, at = n2 * v6 }
				end

				local v8 = select
				local v9, v10, v11 = fn17(tostring(ScrambleTradeIn.CurrentBannerId()))
				local v12 = v8(1, v9, v10, v11)
				local v13 = ramal
				local v14 = ramal
				local v15 = ramal
				ramal.rot = v6
				v13.now = v12
				v14.nowAt = (v7 + 1) * v6
				v15.daftar = daftar
			end)
		end)

		return ramal
	end

	steal.LAB.Pilihan = function()
		local labBannerPilih = tbl.UIX and tbl.UIX.SCR and tbl.UIX.SCR.LabBannerPilih

		if labBannerPilih and type(labBannerPilih.Get) == "function" then
			local ok, result = pcall(labBannerPilih.Get)
			if ok and type(result) == "table" then
				return result
			end
		end

		local bannerPilih = steal.LAB.BannerPilih
		if bannerPilih then
			return bannerPilih
		end
		return {}
	end

	steal.LAB.BannerOk = function()
		local v6 = steal.LAB.Pilihan()
		local flag2 = false

		for _, v7 in pairs(v6) do
			if v7 then
				flag2 = true
				break
			end
		end

		if flag2 then
			local state = steal.LAB.state
			local flag3 = state ~= nil
			if flag3 then
				return v6[tostring(state.BannerId)] == true
			end
			return flag3
		end

		return true
	end

	local function segar()
		if os.clock() - steal.LAB.stokAt < 1 then
			return steal.LAB.stok
		end
		local state = steal.LAB.state
		local stok = {}
		local tbl3 = {}

		if state and type(state.Requirements) == "table" then
			local v6 = steal.SaveData()

			for _, requirement in ipairs(state.Requirements) do
				local str2 = tostring(requirement):lower()
				local v7 = tbl3[str2]

				if v7 then
					v7.butuh = v7.butuh + 1
				else
					local n2 = 0

					for _, v8 in pairs(v6 and v6.EggInventory or {}) do
						if type(v8) == "table" and v8.Placement == nil and tostring(v8.AssetCategory or ""):lower() == str2 then
							n2 += 1
						end
					end

					local tbl4 = { nama = tostring(requirement), kunci = str2, butuh = 1, bebas = n2 }
					tbl3[str2] = tbl4
					stok[#stok + 1] = tbl4
				end
			end
		end

		local lab4 = steal.LAB
		local lab5 = steal.LAB
		local now = os.clock()
		lab4.stok = stok
		lab5.stokAt = now
		return stok
	end

	steal.LAB.Segar = segar

	steal.LAB.Butuh = function(arg)
		if arg then
			if steal.LAB.BannerOk() then
				local str2 = tostring(arg):lower()

				for _, v6 in ipairs(steal.LAB.Segar()) do
					if v6.kunci ~= str2 then
						continue
					end
					local n2 = steal.RIFT.jalan[str2] or 0
					return v6.bebas + (os.clock() < n2 and 1 or 0) < v6.butuh
				end

				return false
			end

			return false
		end

		return false
	end

	local function kabar(arg)
		local status = tostring(arg or "Idle")
		if steal.LAB.status ~= status then
			steal.LAB.status = status
			return
		end
	end

	steal.LAB.Kabar = kabar

	steal.LAB.Mesin = function()
		local world = v:FindFirstChild("World") or v:FindFirstChild("__OBJECTS")
		local machines = world and world:FindFirstChild("Machines")
		local riftMachine = machines and machines:FindFirstChild("RiftMachine")
		local machine = riftMachine and riftMachine:FindFirstChild("Machine")
		if machine and machine:IsA("BasePart") then
			return machine
		end
		return nil
	end

	steal.LAB.TelurBebas = function()
		local v6 = steal.SaveData()
		local tbl3 = {}

		for k, v7 in pairs(v6 and v6.EggInventory or {}) do
			if type(k) == "string" and type(v7) == "table" and v7.Placement == nil and type(v7.AssetCategory) == "string" then
				tbl3[#tbl3 + 1] = { uid = k, cat = v7.AssetCategory }
			end
		end

		table.sort(tbl3, function(arg, arg2)
			return arg.uid < arg2.uid
		end)

		return tbl3
	end

	steal.LAB.Pilih = function(arg)
		local tbl3 = {}

		for _, v6 in ipairs(steal.LAB.TelurBebas()) do
			local str2 = tostring(v6.cat)
			tbl3[str2] = tbl3[str2] or {}
			table.insert(tbl3[str2], v6)
		end

		local tbl4 = {}
		local tbl5 = {}
		local tbl6 = {}

		for i, v6 in ipairs(arg) do
			local v7 = nil

			for _, v8 in ipairs(tbl3[tostring(v6)] or {}) do
				if tbl4[v8.uid] then
					continue
				end
				v7 = v8
				break
			end

			if v7 then
				tbl4[v7.uid] = true
				tbl5[i] = v7
			else
				tbl6[#tbl6 + 1] = tostring(v6)
			end
		end

		return tbl5, tbl6
	end

	steal.LAB.KeMesin = function()
		local v6 = steal.LAB.Mesin()

		if v6 then
			local v7 = fn2()

			if v7 then
				local n2 = v6.Position + Vector3.new(0, 4, 5)

				if not ((v7.Position - n2).Magnitude <= steal.LAB.DEKAT) then
					steal.LAB.Kabar("walking to Laboratory machine")
					if steal.GlideRetry(n2, 25, 3) then
						return true, "travel failed"
					end
					return false, "travel failed"
				end

				return true
			end

			return false, "no character"
		end

		return false, "machine unavailable"
	end

	steal.LAB.Reveal = function()
		steal.LAB.Kabar("finishing reward reveal")
		task.wait(steal.LAB.ENDAP_REVEAL)
		if tbl.NET.Invoke("ScrambleTradeIn", "AskFinishReveal") then
			return true
		end
		return false
	end

	steal.LAB.Tukar = function(arg, arg2)
		local tbl3 = {}

		for i = 1, #arg do
			if arg2[i] then
				tbl3[#tbl3 + 1] = arg2[i].uid
				continue
			end
			return false, "requirements incomplete"
		end

		local v6, v7 = steal.LAB.KeMesin()

		if v6 then
			local v8 = steal.LAB.Tarik(true)
			if type(v8) ~= "table" then
				return false, "state unavailable"
			end

			if steal.LAB.BannerOk() then
				local requirements = type(v8.Requirements) == "table" and v8.Requirements or {}

				for i, v9 in ipairs(arg) do
					if tostring(requirements[i]) ~= tostring(v9) then
						return false, "requirements rotated"
					end
				end

				local v9 = steal.SaveData()

				for i, v10 in ipairs(tbl3) do
					local eggInventory = v9 and v9.EggInventory and v9.EggInventory[v10]
					if type(eggInventory) ~= "table" then
						return false, "required egg changed"
					end

					if eggInventory.Placement ~= nil then
						return false, "required egg changed"
					end

					if tostring(eggInventory.AssetCategory) ~= tostring(arg[i]) then
						return false, "required egg changed"
					end
				end

				steal.LAB.Kabar("trading 3 eggs")
				local ScrambleTradeIn = tbl.NET.Get("ScrambleTradeIn", "AskTradeIn")

				if ScrambleTradeIn then
					local v10 = table.pack(pcall(ScrambleTradeIn.InvokeServer, ScrambleTradeIn, tbl3))

					if v10[1] then
						if v10[2] ~= true then
							return false, tostring(v10[3] or v10[2] or "trade rejected")
						end
						local n2 = os.clock() + steal.LAB.TUNGGU_TUKAR

						while os.clock() < n2 do
							if steal.LAB.on then
								local v11 = steal.SaveData()
								local flag2 = true

								for _, v12 in ipairs(tbl3) do
									if v11 and v11.EggInventory and v11.EggInventory[v12] ~= nil then
										flag2 = false
										break
									end
								end

								if flag2 then
									break
								end
								task.wait(0.1)
								continue
							end

							break
						end

						local v11 = steal.SaveData()

						for _, v12 in ipairs(tbl3) do
							if v11 and v11.EggInventory and v11.EggInventory[v12] ~= nil then
								return false, "trade confirmation timed out"
							end
						end

						steal.LAB.Reveal()
						return true
					end

					return false, tostring(v10[2])
				end

				return false, "AskTradeIn remote missing"
			end

			return false, ("banner rotated to %s - not a target"):format(tostring(v8.BannerId))
		end

		return false, v7
	end

	steal.LAB.Amati = function()
		local tbl3 = { bisa = false }
		local lab4 = steal.LAB
		steal.LAB.siap = 0
		lab4.pending = false
		local v6 = steal.LAB.Tarik(false)
		if type(v6) ~= "table" then
			tbl3.kabar = "state unavailable"
			return tbl3
		end
		tbl3.st = v6

		if v6.Unlocked ~= false then
			if v6.PendingReward then
				steal.LAB.pending = true
				tbl3.pending = true
				return tbl3
			end

			if steal.LAB.BannerOk() then
				local requirements = type(v6.Requirements) == "table" and v6.Requirements or {}
				steal.LAB.total = #requirements
				if #requirements ~= 3 then
					tbl3.kabar = "waiting for 3 requirements"
					return tbl3
				end
				local v7, v8 = steal.LAB.Pilih(requirements)
				steal.LAB.siap = #requirements - #v8
				steal.LAB.kurang = not (#v8 > 0) and "None" or table.concat(v8, ", ")
				tbl3.req = requirements
				tbl3.pilih = v7
				tbl3.kurang = v8
				tbl3.bisa = true
				return tbl3
			end

			tbl3.kabar = ("waiting for target banner (now %s)"):format(tostring(v6.BannerId or "?"))
			return tbl3
		end

		tbl3.kabar = ("Laboratory locked - needs %s speed"):format(steal.Num and steal.Num(tonumber(v6.UnlockSpeedPower) or 0) or tostring(v6.UnlockSpeedPower))
		tbl3.terkunci = true
		return tbl3
	end

	steal.LAB.Langkah = function()
		local v6 = steal.LAB.Amati()
		if v6.pending then
			steal.LAB.Reveal()
			return steal.LAB.POLL
		end

		if v6.bisa then
			local req = v6.req
			local pilih = v6.pilih

			if not (#v6.kurang > 0) then
				local v7, v8 = steal.LAB.Tukar(req, pilih)
				steal.LAB.Kabar(v7 and "trade complete" or "trade: " .. tostring(v8))
				return steal.LAB.POLL
			end

			steal.LAB.Kabar(("need %s"):format(steal.LAB.kurang))
			return 1
		end

		steal.LAB.Kabar(v6.kabar or "waiting")
		if v6.terkunci then
			return 2
		end
		return 1
	end

	steal.LAB.Start = function()
		if steal.LAB.on then
			return
		end
		steal.LAB.on = true

		task.spawn(function()
			while steal.LAB.on do
				if tbl.Alive then
					local str2, n2

					if steal.HeldUid() then
						str2 = "carrying egg"
						pcall(steal.LAB.Amati)
						steal.LAB.Kabar("waiting - " .. str2)
						n2 = 1
					elseif steal.ORDER.Giliran("auto_scramble_lab") then
						local ok, result = pcall(steal.LAB.Langkah)

						if ok then
							n2 = result or 1
						else
							tbl.LOG.warn("LAB", tostring(result))
							steal.LAB.Kabar("runtime error - retrying")
							n2 = 1
						end
					else
						str2 = tostring(steal.ORDER.Status)
						pcall(steal.LAB.Amati)
						steal.LAB.Kabar("waiting - " .. str2)
						n2 = 1
						task.wait(n2)
						continue
					end

					task.wait(n2)
					continue
				end

				break
			end

			steal.LAB.on = false
			steal.LAB.Kabar("Off")
		end)
	end

	steal.LAB.Stop = function()
		steal.LAB.on = false
		steal.LAB.Kabar("Off")
	end

	tbl.ST.Trove:Add(steal.LAB.Stop)

	steal.PetList = function()
		if steal._petL then
			return steal._petL
		end
		local petL = {}
		local tbl3 = {}
		local v6 = v3
		local directory

		if v3 then
			directory = v3.Directory or v3
		else
			directory = v6
		end

		if type(directory) == "table" and v2 and v2.Directory then
			pcall(function()
				for _, v7 in ipairs(steal.AreaList()) do
					local v8 = directory[v7]

					if type(v8) == "table" and v8.DropTable then
						local tbl4 = {}

						for _, v9 in ipairs(v8.DropTable) do
							local v10 = v9[1]

							if type(v10) == "string" and v10 ~= "" and not tbl3[v10] then
								tbl3[v10] = true
								tbl4[#tbl4 + 1] = v10
							end
						end

						if #tbl4 > 0 then
							table.sort(tbl4)
							petL[#petL + 1] = { header = v7 }

							for _, v9 in ipairs(tbl4) do
								petL[#petL + 1] = v9
							end
						end
					end
				end
			end)
		end

		if #petL ~= 0 then
			steal._petL = petL
			return petL
		end

		for _, v7 in pairs(fn5()) do
			local str2 = tostring(v7.AssetCategory)

			if str2 ~= "nil" and not tbl3[str2] then
				tbl3[str2] = true
				petL[#petL + 1] = str2
			end
		end

		table.sort(petL)
		return petL
	end

	steal.PRIORITIES = { "Rarity", "Value", "Farthest", "Closest", "Size", "Mutations", "Random" }

	steal.Sort = function(arg, arg2)
		local function fn17(arg3, arg4)
			local sort = table.sort

			local function fn18(arg5, arg6)
				local v6 = arg3(arg5)
				local v7 = arg3(arg6)

				if v6 ~= v7 then
					if arg4 then
						return v6 > v7
					end
					return v6 < v7
				end

				return arg5.dist < arg6.dist
			end

			sort(arg, fn18)
		end

		if arg2 ~= "Closest" then
			if arg2 ~= "Farthest" then
				if arg2 ~= "Rarity" then
					if arg2 ~= "Value" then
						if arg2 ~= "Size" then
							if arg2 ~= "Mutations" then
								for i = #arg, 2, -1 do
									local n2 = math.random(i)
									local v6 = arg[i]
									arg[i] = arg[n2]
									arg[n2] = v6
								end

								return
							end

							fn17(function(arg3)
								return fn11(arg3.rec.Mutations)
							end, true)

							return
						end

						fn17(function(arg3)
							return weightKgOf(arg3.rec)
						end, true)

						return
					end

					fn17(function(arg3)
						return valueOf(arg3.rec)
					end, true)

					return
				end

				fn17(function(arg3)
					return fn10(arg3.name)
				end, true)

				return
			end

			fn17(function(arg3)
				return arg3.dist
			end, true)

			return
		end

		fn17(function(arg3)
			return arg3.dist
		end, false)
	end

	steal.RarityIdOf = rarityIdOf
	steal.WeightKgOf = weightKgOf
	steal.ValueOf = valueOf
	steal.Asset = asset

	steal.BahanButuh = function(arg)
		if steal.LAB and steal.LAB.Butuh and steal.LAB.Butuh(arg) then
			return true
		end
		local flag2 = steal.RIFT.state ~= nil
		if flag2 then
			return (steal.RIFT.Butuh(arg))
		end
		return flag2
	end

	steal.Candidates = function(arg)
		local v6 = steal.Filters()
		local v7 = fn2()
		local position = v7 and v7.Position or Vector3.zero
		local tbl3 = {}
		local tbl4 = {}
		local prioritas = steal.RIFT.Prioritas

		if prioritas then
			steal.LAB.Tarik(false)
			steal.LAB.Segar()

			if steal.RIFT.state then
				steal.RIFT.Segar()
			end
		end

		-- Keep target discovery consistent with NoMatch/Roam. Previously the
		-- normal steal cycle ONLY read the remote snapshot; when that was empty
		-- Auto Steal appeared enabled but never found a target.
		local currentRecords = steal.FieldRecords()
		local function collect(records)
		for _, v8 in pairs(records) do
			if type(v8) == "table" and tostring(v8.State) == "Slot" and v8.Uid ~= nil
				and not tostring(v8.Uid):find(str, 1, true) then
				local position = if typeof(v8.BottomCFrame) == "CFrame" then v8.BottomCFrame.Position
					else fn7(tostring(v8.Uid), nil)
				if not position then continue end
				local str2 = tostring(v8.AreaId)
				local str3 = tostring(v8.AssetCategory)
				local uid = steal.AA and steal.AA.CTE and steal.AA.CTE.Uid and steal.AA.CTE.Uid()
				local flag2 = not steal.AREA_HARAM[str2] and not (uid and tostring(v8.Uid) == uid)
				local flag3 = flag2 and (not v6.Area or v6.Area(str2))

				if v6.Pet and not v6.Pet(str3) then
					flag3 = false
				end

				if v6.Rarity and not v6.Rarity(steal.RarityIdOf(str3)) then
					flag3 = false
				end

				if v6.MinKG > 0 and steal.WeightKgOf(v8) < v6.MinKG then
					flag3 = false
				end

				local minValue = v6.MinValue

				if minValue and minValue > 0 and steal.ValueOf(v8) < v6.MinValue then
					flag3 = false
				end

				local v9

				if flag3 then
					v9 = flag3
				else
					if not prioritas then
						continue
					end

					if not flag2 then
						continue
					end
					v9 = steal.BahanButuh(str3)
				end

				if v9 then
					local tbl5 = {
						uid = tostring(v8.Uid),
						name = str3,
						area = str2,
						rec = v8,
						pos = position,
						dist = (position - (v7 and v7.Position or Vector3.zero)).Magnitude,
					}

					if flag3 then
						tbl3[#tbl3 + 1] = tbl5
					else
						tbl4[#tbl4 + 1] = tbl5
					end
				end
			end
		end
		end
		collect(currentRecords)
		if #tbl3 == 0 and #tbl4 == 0 then
			-- Only when the normal client scan found NO valid targets.
			-- fn5() has a cooldown; this does not hammer the remote each frame.
			local serverRecords = fn5()
			if serverRecords and next(serverRecords) then
				collect(serverRecords)
			end
		end

		if #tbl3 == 0 and #tbl4 > 0 then
			steal.Sort(tbl4, v6.Priority)
			return tbl4
		end
		steal.Sort(tbl3, v6.Priority)

		if prioritas then
			local tbl5 = {}
			local tbl6 = {}

			for _, v8 in ipairs(tbl3) do
				local v9 = if steal.RIFT.Butuh(v8.name) then tbl5 else tbl6
				v9[#v9 + 1] = v8
			end

			if #tbl5 > 0 then
				table.move(tbl6, 1, #tbl6, #tbl5 + 1, tbl5)
				return tbl5
			end
		end

		return tbl3
	end

	steal.AtStrip = function(arg)
		local n2 = os.clock() + (arg or 0.3)

		while steal.Running do
			if not (os.clock() < n2) then
				break
			end
			runService.Heartbeat:Wait()
		end

		local v6 = fn2()
		if v6 then
			return (v6.Position - steal.STRIP).Magnitude <= steal.ARRIVE, v6.Position
		end
		return v6, v6
	end

	steal.ViaStrip = function()
		for i = 1, 4 do
			local n2 = os.clock() + 0.2

			while steal.Running and os.clock() < n2 do
				local v6 = fn2()

				if v6 then
					v6.CFrame = CFrame.new(steal.STRIP.X, v6.Position.Y, steal.STRIP.Z)
					v6.AssemblyLinearVelocity = Vector3.zero
					runService.Heartbeat:Wait()
					continue
				end

				return false
			end

			if steal.AtStrip(0.3) then
				return true
			end
		end

		return false
	end

	steal.EnterGameplay = function()
		local v6 = fn2()

		if v6 then
			if not (steal.GATE_X <= v6.Position.X) then
				local n2 = os.clock() + 0.25

				while true do
					if not steal.Gerak() or not (os.clock() < n2) then
						return true
					else
						local v7 = fn2()

						if v7 then
							steal.Tulis(v7, CFrame.new(steal.GATE_STEP), true)
							runService.Heartbeat:Wait()
							continue
						end

						break
					end
				end

				return false
			end

			return true
		end

		return false
	end

	local function fn17()
		local client = tbl.SV.ReplicatedStorage:FindFirstChild("Client")
		local eggState = client and client:FindFirstChild("EggState")

		if eggState then
			local ok, result = pcall(require, eggState)
			if ok and result then
				return result
			end
			return nil
		end

		return nil
	end

	steal.EggSt = fn17()
	steal.PlotSt = fn9(tbl.SV.ReplicatedStorage:FindFirstChild("Client") and tbl.SV.ReplicatedStorage.Client:FindFirstChild("PlotState"))
	steal.plotCache = {}

	steal.PlotOf = function(arg)
		local v6 = arg or localPlayer
		local v7 = steal.plotCache[v6.UserId]
		if v7 and v7.Parent then
			return v7
		end
		steal.plotCache[v6.UserId] = nil
		local plotSt = steal.PlotSt

		if plotSt and plotSt.ResolvePlot then
			local ok, result = pcall(plotSt.ResolvePlot, v6)
			local centerPoint = ok and type(result) == "table" and result.CenterPoint
			if centerPoint then
				steal.plotCache[v6.UserId] = centerPoint
				return centerPoint
			end
		end

		if v6 ~= localPlayer then
			return nil
		end
		local plots = v:FindFirstChild("Plots")

		if plots then
			local displayName = localPlayer.DisplayName or localPlayer.Name

			for _, child in ipairs(plots:GetChildren()) do
				local plotSign = child:FindFirstChild("PlotSign", true)

				if plotSign then
					for _, descendant in ipairs(plotSign:GetDescendants()) do
						if descendant:IsA("TextLabel") and (descendant.Text == displayName or descendant.Text == localPlayer.Name) then
							local centerPoint = child:FindFirstChild("CenterPoint", true)
							if centerPoint then
								steal.plotCache[v6.UserId] = centerPoint
								return centerPoint
							end
						end
					end
				end
			end

			return
		end

		return nil
	end

	steal.WATCH = { GRACE = 0.5, LOST = 0.35, MANUAL = 2.5, RECOVER = 4 }
	steal.ManualDropAt = 0
	steal.Regrabs = 0

	steal.FieldRecords = function()
		local records = nil
		local eggSt = steal.EggSt
		if eggSt and type(eggSt.ReadFieldEggs) == "function" then
			local ok, snapshot = pcall(eggSt.ReadFieldEggs)
			if ok then records = steal.NormalizeEggRecords(snapshot) end
		end
		if records and next(records) then
			-- Client data is normally freshest. When it has no available eggs,
			-- cross-check the throttled server snapshot instead of staying idle.
			for _, rec in pairs(records) do
				if tostring(rec.State) == "Slot" or tostring(rec.State) == "Dropped" then
					return records
				end
			end
			local server = fn5()
			if next(server) then return server end
			return records
		end
		return fn5()
	end

	steal.IsHolding = function(arg)
		if arg then
			for _, v6 in pairs(steal.FieldRecords()) do
				if tostring(v6.Uid) ~= arg then
					continue
				end
				local flag2 = tostring(v6.State) == "Carried"
				if flag2 then
					return tostring(v6.CarrierUserId) == str
				end
				return flag2
			end

			return false
		end

		return false
	end

	steal.AREA_HARAM = { Forest = true }

	steal.AreaOf = function(arg)
		if arg then
			for _, v6 in pairs(steal.FieldRecords()) do
				if tostring(v6.Uid) == tostring(arg) then
					return tostring(v6.AreaId)
				end
			end

			return
		end

		return nil
	end

	steal.HeldUid = function()
		for _, v6 in pairs(steal.FieldRecords()) do
			if tostring(v6.State) == "Carried" and tostring(v6.CarrierUserId) == str then
				return tostring(v6.Uid)
			end
		end
	end

	steal.UidNear = function(arg)
		local str2 = nil

		for _, v6 in pairs(steal.FieldRecords()) do
			if typeof(v6.BottomCFrame) == "CFrame" and (v6.BottomCFrame.Position - arg).Magnitude < 18 then
				local str3 = tostring(v6.State)

				if str3 ~= "Dropped" then
					if str3 == "Slot" then
						str2 = str2 or tostring(v6.Uid)
					end

					continue
				end

				return tostring(v6.Uid)
			end
		end

		return str2
	end

	steal.WatchStart = function()
		if steal.DropListening then
			return
		end

		local ok, result = pcall(function()
			return require(tbl.SV.ReplicatedStorage.Client.GUI).DropHeldEgg()
		end)

		local button = ok and result and result:FindFirstChild("Button", true)

		if button and button:IsA("GuiButton") then
			steal.DropListening = true

			tbl.ST.Trove:Connect(button.Activated, function()
				steal.ManualDropAt = os.clock()
			end)

			return
		end

		tbl.LOG.warn("STEAL", "tombol drop tidak ketemu - penjaga drop manual mati")
	end

	steal.Hop = function(arg, arg2, arg3)
		local v6 = fn2()

		if v6 then
			local v7 = nil

			if arg3 then
				n += 1
				v7 = n
			end

			local n2 = v6.CFrame - Vector3.new(0, steal.RidePakai(), 0)
			local cframe = CFrame.new(arg)
			local magnitude = (arg - n2.Position).Magnitude

			if not (magnitude < 0.1) then
				local n3 = steal.SafeSpeed(steal.Speed(), 120)
				local n4 = os.clock() + (arg2 or 3)
				local n5 = 0
				local position = nil

				if magnitude > 0 then
					local exitTo = nil

					while true do
						if not (os.clock() < n4) then
							exitTo = 1
							break
						else
							local result = runService.Heartbeat:Wait()
							if v7 and n ~= v7 then
								exitTo = 2
								break
							end
							local v8 = fn2()

							if v8 then
								if v8.Parent then
									if position and steal.STEP.ROLLBACK < (v8.Position - position).Magnitude then
										n2 = v8.CFrame - Vector3.new(0, steal.RidePakai(), 0)
										magnitude = (arg - n2.Position).Magnitude
										n5 = 0
										if magnitude < 0.1 then
											exitTo = 1
											break
										end
									end

									n5 = math.min(magnitude, n5 + math.min(n3 * result, steal.StepCap()))
									steal.Tulis(v8, n2:Lerp(cframe, n5 / magnitude), true)
									position = v8.Position
									if not (n5 < magnitude) then
										exitTo = 1
										break
									end
									continue
								end

								exitTo = 3
								break
							end

							break
						end
					end

					if exitTo ~= 1 then
						if exitTo == 2 then
							return false
						end

						if exitTo == 3 then
							return false
						end
						return false
					end
				end

				if v7 and n ~= v7 then
					return false
				end
				local v8 = fn2()
				if v8 then
					steal.Tulis(v8, cframe, true)
					return true
				end
				return true
			end

			return true
		end

		return false
	end

	steal.RecoverDropped = function(arg)
		if arg then
			local v6 = fn6()
			if v6 then
				return v6
			end

			if steal.EggSt and steal.EggSt.SyncFieldEggs then
				pcall(steal.EggSt.SyncFieldEggs)
			end

			local v7 = nil

			for _, v8 in pairs(steal.FieldRecords()) do
				if tostring(v8.Uid) ~= arg then
					continue
				end
				v7 = v8
				break
			end

			if v7 and tostring(v7.State) == "Claimed" then
				tbl.LOG.warn("STEAL", "telur keburu di-claim orang lain")
				return false
			end
			local position = nil

			if v7 and typeof(v7.BottomCFrame) == "CFrame" then
				position = v7.BottomCFrame.Position
			end

			local position2 = fn7(arg, position)

			if not position2 then
				local v8 = fn2()
				position2 = v8 and v8.Position
			end

			if position2 then
				if not v7 then
					arg = steal.UidNear(position2) or arg
				end

				local n2 = position2 + Vector3.new(0, 2.5, 0)

				if steal.Hop(n2, 4) then
					local EggWorld = tbl.NET.Get("EggWorld", "AskFieldEggCarry")

					if EggWorld then
						local n3 = os.clock() + steal.WATCH.RECOVER
						local str2 = "?"

						while true do
							if not steal.Running or not (os.clock() < n3) then
								tbl.LOG.warn("STEAL", "pungut ulang gagal: " .. str2:sub(1, 60))
								return false
							else
								local v8 = fn2()

								if v8 then
									steal.Tulis(v8, CFrame.new(n2), false)
									local v9 = table.pack(pcall(EggWorld.InvokeServer, EggWorld, { Uid = arg }))
									local v10 = fn2()

									if v10 then
										steal.Tulis(v10, CFrame.new(n2), false)
									end

									if v9[1] and v9[2] == true then
										return arg
									end
									str2 = tostring(v9[3] or v9[2])
									if str2:find("Already carrying") then
										return arg
									end

									if str2:find("not found") then
										local v11 = steal.UidNear(position2)

										if v11 and v11 ~= arg then
											arg = v11
										end
									end

									runService.Heartbeat:Wait()
									continue
								end

								break
							end
						end

						return false
					end

					return false
				end

				return false
			end

			return false
		end

		return false
	end

	steal.TP = { on = false, Enabled = true }

	steal.TP.CharHidden = function(arg)
		for _, v6 in ipairs({ "hideCx", "addCx" }) do
			local v7 = steal.TP[v6]

			if v7 then
				local v8 = pcall

				local function fn18()
					v7:Disconnect()
				end

				v8(fn18)
				steal.TP[v6] = nil
			end
		end

		local character = localPlayer.Character

		if character then
			if arg then
				local tbl3 = {}
				local tbl4 = {}
				local tbl5 = {}

				local function fn18(descendant)
					if descendant:IsA("BasePart") then
						tbl3[#tbl3 + 1] = descendant
						return
					end

					if descendant:IsA("Decal") then
						tbl4[#tbl4 + 1] = descendant
						return
					end

					if descendant:IsA("ParticleEmitter") then
						tbl5[#tbl5 + 1] = descendant
						return
					end

					if descendant:IsA("Trail") then
						tbl5[#tbl5 + 1] = descendant
						return
					end

					if descendant:IsA("Beam") then
						tbl5[#tbl5 + 1] = descendant
						return
					end

					if descendant:IsA("Highlight") then
						tbl5[#tbl5 + 1] = descendant
						return
					end

					if descendant:IsA("BillboardGui") then
						tbl5[#tbl5 + 1] = descendant
						return
					end
				end

				local v6 = nil

				local function fn19(arg2)
					v6 = arg2
					tbl3 = {}
					tbl4 = {}
					tbl5 = {}

					for _, descendant in ipairs(arg2:GetDescendants()) do
						fn18(descendant)
					end

					if steal.TP.addCx then
						pcall(function()
							steal.TP.addCx:Disconnect()
						end)
					end

					steal.TP.addCx = arg2.DescendantAdded:Connect(fn18)
				end

				fn19(character)

				local function fn20()
					local character2 = localPlayer.Character

					if character2 then
						if character2 ~= v6 then
							fn19(character2)
						end

						for i = 1, #tbl3 do
							tbl3[i].LocalTransparencyModifier = 1
						end

						for i = 1, #tbl4 do
							tbl4[i].Transparency = 1
						end

						for i = 1, #tbl5 do
							tbl5[i].Enabled = false
						end

						return
					end
				end

				steal.TP.hideCx = runService.RenderStepped:Connect(fn20)
				return
			end

			for _, descendant in ipairs(character:GetDescendants()) do
				if descendant:IsA("BasePart") then
					descendant.LocalTransparencyModifier = 0
				elseif descendant:IsA("Decal") then
					descendant.Transparency = 0
				elseif descendant:IsA("ParticleEmitter") then
					descendant.Enabled = true
				elseif descendant:IsA("Trail") then
					descendant.Enabled = true
				elseif descendant:IsA("Beam") then
					descendant.Enabled = true
				elseif descendant:IsA("Highlight") then
					descendant.Enabled = true
				elseif descendant:IsA("BillboardGui") then
					descendant.Enabled = true
				end
			end

			return
		end
	end

	steal.TP.NameTag = function(arg)
		local humanoid = arg and arg:FindFirstChildOfClass("Humanoid")

		if humanoid then
			humanoid.DisplayName = localPlayer.DisplayName or localPlayer.Name
			humanoid.DisplayDistanceType = Enum.HumanoidDisplayDistanceType.Subject
			humanoid.NameDisplayDistance = 200
			humanoid.HealthDisplayType = Enum.HumanoidHealthDisplayType.AlwaysOff
			return
		end
	end

	steal.TP.RealName = function(arg)
		local v6 = fn3()
		if not v6 then
			return
		end

		if steal.TP.ddt == nil then
			steal.TP.ddt = v6.DisplayDistanceType
		end

		pcall(function()
			local v7 = v6
			local ddt

			if arg then
				ddt = steal.TP.ddt or Enum.HumanoidDisplayDistanceType.Viewer or Enum.HumanoidDisplayDistanceType.None
			else
				ddt = Enum.HumanoidDisplayDistanceType.None
				v7.DisplayDistanceType = ddt
				return
			end

			v7.DisplayDistanceType = ddt
		end)

		if arg then
			steal.TP.ddt = nil
			return
		end
	end

	steal.TP.KUNCI_KAMERA = false

	steal.TP.CamLock = function(cFrame)
		local currentCamera = v.CurrentCamera

		if currentCamera then
			if steal.TP.camType == nil then
				steal.TP.camType = currentCamera.CameraType
				steal.TP.camSubj = currentCamera.CameraSubject
			end

			if steal.TP.camCx then
				local function fn18()
					steal.TP.camCx:Disconnect()
				end

				pcall(fn18)
			end

			if steal.TP.KUNCI_KAMERA then
				currentCamera.CameraType = Enum.CameraType.Scriptable
				currentCamera.CFrame = cFrame
				local tp = steal.TP
				local renderStepped = runService.RenderStepped
				local v6 = renderStepped
				local connect = renderStepped.Connect

				local function fn18()
					if not steal.TP.on or not steal.TP.Alive or not steal.TP.Alive() then
						steal.TP.Clear()
						return
					end
					local currentCamera2 = v.CurrentCamera

					if currentCamera2 then
						if currentCamera2.CameraType ~= Enum.CameraType.Scriptable then
							currentCamera2.CameraType = Enum.CameraType.Scriptable
						end

						currentCamera2.CFrame = cFrame
						return
					end
				end

				tp.camCx = connect(v6, fn18)
				return
			end

			local function fn18()
				local decoy = steal.TP.decoy

				if decoy then
					if decoy.Parent then
						local humanoid = decoy:FindFirstChildOfClass("Humanoid")

						if not humanoid then
							if decoy:IsA("Model") then
								humanoid = decoy.PrimaryPart
								if humanoid then
									return humanoid
								end
							end

							return (decoy:FindFirstChild("HumanoidRootPart"))
						end

						return humanoid
					end

					return nil
				end

				return nil
			end

			currentCamera.CameraType = Enum.CameraType.Custom
			local v6 = fn18()

			if v6 then
				currentCamera.CameraSubject = v6
			end

			local heartbeat = runService.Heartbeat
			local v7 = heartbeat
			local connect = heartbeat.Connect

			local function fn19()
				if not steal.TP.on or not steal.TP.Alive or not steal.TP.Alive() then
					steal.TP.Clear()
					return
				end
				local currentCamera2 = v.CurrentCamera
				local v8 = fn18()
				if not currentCamera2 or not v8 then
					return
				end

				if currentCamera2.CameraSubject ~= v8 then
					currentCamera2.CameraType = Enum.CameraType.Custom
					currentCamera2.CameraSubject = v8
					return
				end
			end

			steal.TP.camCx = connect(v7, fn19)
			return
		end
	end

	steal.TP.Clear = function()
		if steal.TP.KedutHenti then
			steal.TP.KedutHenti()
		end

		steal.TP.on = false
		pcall(steal.TP.CharHidden, false)
		pcall(steal.TP.RealName, true)

		for _, v6 in ipairs({ "camCx", "hideCx", "addCx" }) do
			local v7 = steal.TP[v6]

			if v7 then
				local function fn18()
					v7:Disconnect()
				end

				pcall(fn18)
				steal.TP[v6] = nil
			end
		end

		if steal.TP.decoy then
			local function fn18()
				steal.TP.decoy:Destroy()
			end

			pcall(fn18)
			steal.TP.decoy = nil
		end

		local function fn18()
			local currentCamera = v.CurrentCamera

			if currentCamera then
				local v6 = fn3()
				local camType

				if steal.TP.camType and steal.TP.camType ~= Enum.CameraType.Scriptable then
					camType = steal.TP.camType or Enum.CameraType.Custom
				else
					camType = Enum.CameraType.Custom
					currentCamera.CameraType = camType
					currentCamera.CameraSubject = v6 or steal.TP.camSubj
					return
				end

				currentCamera.CameraType = camType
				currentCamera.CameraSubject = v6 or steal.TP.camSubj
				return
			end
		end

		pcall(fn18)
		local tp = steal.TP
		local tp2 = steal.TP
		steal.TP.camType = nil
		tp.camSubj = nil
		tp2.Alive = nil
	end

	steal.TP.Clone = function(arg, arg2)
		local character = localPlayer.Character
		if not character or not arg then
			return nil
		end
		local clone = nil

		local function fn18()
			local archivable = character.Archivable
			character.Archivable = true
			clone = character:Clone()
			character.Archivable = archivable
		end

		pcall(fn18)
		if not clone then
			return nil
		end

		if not arg2 then
			for _, child in ipairs(clone:GetChildren()) do
				if child:IsA("Tool") then
					child:Destroy()
				end
			end
		end

		for _, descendant in ipairs(clone:GetDescendants()) do
			if descendant:IsA("BasePart") then
				descendant.Anchored = true
				descendant.CanCollide = false
				descendant.CanTouch = false
				descendant.CanQuery = false
				descendant.LocalTransparencyModifier = 0
			elseif descendant:IsA("Script") then
				descendant:Destroy()
			elseif descendant:IsA("LocalScript") then
				descendant:Destroy()
			end
		end

		steal.TP.NameTag(clone)
		clone.Name = "__saeDecoy"
		clone.Parent = v
		clone:PivotTo(arg)

		local function fn19()
			for i = 1, 6 do
				task.wait(0.1)

				if clone then
					if clone.Parent then
						for _, descendant in ipairs(clone:GetDescendants()) do
							if descendant:IsA("BasePart") then
								descendant.CanCollide = false
								descendant.CanQuery = false
								descendant.CanTouch = false
							end
						end

						continue
					end

					return
				end

				return
			end
		end

		task.spawn(fn19)
		return clone
	end

	steal.TP.Setup = function(arg, arg2)
		steal.TP.Clear()
		steal.TP.on = true

		local function alive()
			return steal.Running
		end

		steal.TP.Alive = alive
		local position = arg and arg.Position or steal.STRIP
		local v6 = steal.TP.Clone(CFrame.new(position, position + Vector3.new(0, 0, -1)), false)

		if v6 then
			steal.TP.decoy = v6
			steal.TP.RealName(false)
		end

		local strip = arg2 or steal.STRIP
		steal.TP.CamLock(CFrame.lookAt(strip + Vector3.new(-16.42, 3.6, 0.39), strip + Vector3.new(10, -1.2, -0.2)))
	end

	local function eggProp(parent, arg, arg2)
		if parent and parent.Parent then
			pcall(function()
				local saeDecoyEgg = parent:FindFirstChild("__saeDecoyEgg")

				if saeDecoyEgg then
					saeDecoyEgg:Destroy()
				end

				local character = localPlayer.Character
				local tool = character and character:FindFirstChildOfClass("Tool")
				local rightHand = parent:FindFirstChild("RightHand")
				local rightHand2 = character and character:FindFirstChild("RightHand")
				local flag2 = false

				if tool and rightHand and rightHand2 then
					local clone = tool:Clone()
					clone.Name = "__saeDecoyEgg"
					local handle = clone:FindFirstChild("Handle")

					if handle then
						clone.Parent = parent

						for _, descendant in ipairs(clone:GetDescendants()) do
							if descendant:IsA("BasePart") then
								descendant.Anchored = true
								descendant.CanCollide = false
								descendant.CanTouch = false
								descendant.CanQuery = false
								descendant.LocalTransparencyModifier = 0
							end
						end

						handle.CFrame = rightHand.CFrame * rightHand2.CFrame:ToObjectSpace(handle.CFrame)

						for _, descendant in ipairs(clone:GetDescendants()) do
							if descendant:IsA("BasePart") and descendant ~= handle then
								local v6 = tool:FindFirstChild(descendant.Name, true)

								if v6 and v6:IsA("BasePart") then
									descendant.CFrame = rightHand.CFrame * rightHand2.CFrame:ToObjectSpace(v6.CFrame)
								end
							end
						end

						flag2 = true
					end
				end

				if not flag2 and arg then
					local assets = tbl.SV.ReplicatedStorage:FindFirstChild("Assets")
					local models = assets and assets:FindFirstChild("Models")
					local eggs = models and models:FindFirstChild("Eggs")
					local v6 = eggs and eggs:FindFirstChild(tostring(arg))

					if v6 then
						local clone = v6:Clone()
						clone.Name = "__saeDecoyEgg"
						local primaryPart = clone.PrimaryPart or clone:FindFirstChildWhichIsA("BasePart")
						local upperTorso = parent:FindFirstChild("UpperTorso") or parent:FindFirstChild("HumanoidRootPart")

						if primaryPart and upperTorso then
							for _, descendant in ipairs(clone:GetDescendants()) do
								if descendant:IsA("BasePart") then
									descendant.Anchored = true
									descendant.CanCollide = false
									descendant.CanTouch = false
									descendant.CanQuery = false
									descendant.LocalTransparencyModifier = 0
								end
							end

							local num = tonumber(arg2)

							if num and num > 0 and num < 5 then
								local function fn18()
									clone:ScaleTo(num)
								end

								pcall(fn18)
							end

							clone:PivotTo(upperTorso.CFrame * CFrame.new(1.245, 2.217, -2.103))
							clone.Parent = parent
						else
							clone:Destroy()
						end

						return
					end
				end
			end)

			return
		end
	end

	steal.TP.EggProp = eggProp
	steal.TP.KEDUT = { token = 0, AMP = 0.14, PUTAR = 3.5, JEDA = 0.055 }

	steal.TP.KedutHenti = function()
		steal.TP.KEDUT.token = steal.TP.KEDUT.token + 1
	end

	steal.TP.KedutMulai = function()
		local decoy = steal.TP.decoy

		if decoy then
			if decoy.Parent then
				steal.TP.KEDUT.token = steal.TP.KEDUT.token + 1
				local token = steal.TP.KEDUT.token
				steal.TP.KEDUT.aktif = token
				local pivot = decoy:GetPivot()
				local kedut = steal.TP.KEDUT

				task.spawn(function()
					while kedut.token == token do
						local decoy2 = steal.TP.decoy

						if decoy2 then
							if decoy2.Parent then
								local n2 = (math.random() - 0.5) * 2 * kedut.AMP
								local n3 = (math.random() - 0.5) * 2 * kedut.AMP
								local n4 = (math.random() - 0.5) * 2 * kedut.AMP * 0.5
								local v6 = math.rad((math.random() - 0.5) * 2 * kedut.PUTAR)

								local function fn18()
									decoy2:PivotTo(pivot * CFrame.new(n2, n4, n3) * CFrame.Angles(0, v6, 0))
								end

								pcall(fn18)
								task.wait(kedut.JEDA)
								continue
							end

							break
						end

						break
					end

					if kedut.aktif ~= token then
						return
					end
					kedut.aktif = nil
					local decoy2 = steal.TP.decoy

					if decoy2 and decoy2.Parent then
						local function fn18()
							decoy2:PivotTo(pivot)
						end

						pcall(fn18)
					end
				end)

				return
			end

			return
		end
	end

	steal.TP.Carry = function(arg, arg2)
		steal.TP.KedutHenti()

		if steal.TP.on then
			pcall(steal.TP.CharHidden, true)
			local decoy = steal.TP.decoy
			if not decoy or not decoy.Parent then
				return
			end

			pcall(function()
				local humanoid = decoy:FindFirstChildOfClass("Humanoid")

				if humanoid then
					local animator = humanoid:FindFirstChildOfClass("Animator") or Instance.new("Animator", humanoid)

					for _, v6 in ipairs({ "rbxassetid://507766388", "rbxassetid://507768375" }) do
						pcall(function()
							local animation = Instance.new("Animation")
							animation.AnimationId = v6
							local v7 = animator:LoadAnimation(animation)
							v7.Priority = v6:find("766388") and Enum.AnimationPriority.Idle or Enum.AnimationPriority.Action
							v7.Looped = true
							v7:Play(0.1, 1, 1)
						end)
					end

					return
				end
			end)

			steal.TP.EggProp(decoy, arg, arg2)
			local primaryPart = decoy.PrimaryPart or decoy:FindFirstChild("HumanoidRootPart")

			if primaryPart then
				local position = primaryPart.Position
				steal.TP.CamLock(CFrame.lookAt(position + Vector3.new(-8.5, 2.2, 3.8), position + Vector3.new(0, 1.3, -0.6)))
				return
			end

			return
		end
	end

	tbl.ST.Trove:Add(steal.TP.Clear)
	steal.GOD = { on = false }
	local n2 = 8
	local n3 = 6
	local n4 = 0.1
	local n5 = 0.25
	local n6 = 1

	local function fn18(descendant)
		if descendant:IsA("Motor6D") then
			steal.GOD.motors[#steal.GOD.motors + 1] = descendant
			return
		end

		if descendant:IsA("BallSocketConstraint") or descendant:IsA("HingeConstraint") then
			steal.GOD.cons[#steal.GOD.cons + 1] = descendant
			return
		end
	end

	local function fn19(char)
		steal.GOD.char = char
		steal.GOD.motors = {}
		steal.GOD.cons = {}

		for _, descendant in ipairs(char:GetDescendants()) do
			fn18(descendant)
		end

		if steal.GOD.addCx then
			pcall(function()
				steal.GOD.addCx:Disconnect()
			end)
		end

		steal.GOD.addCx = char.DescendantAdded:Connect(fn18)
	end

	local raycastParams = RaycastParams.new()
	raycastParams.FilterType = Enum.RaycastFilterType.Exclude
	raycastParams.RespectCanCollide = true

	steal.GOD.DiUdara = function(arg, arg2, arg3)
		local v6 = steal.Pad()
		local v7 = raycastParams
		local filterDescendantsInstances

		if v6 then
			filterDescendantsInstances = { arg3, v6 }
		else
			filterDescendantsInstances = { arg3 }
		end

		v7.FilterDescendantsInstances = filterDescendantsInstances
		local n7 = arg.Position.Y - arg.Size.Y * 0.5 + math.max(arg2.HipHeight, 0.5)
		local hit = v:Raycast(arg.Position, Vector3.new(0, -(n3 + 30), 0), raycastParams)
		if hit then
			return n7 - hit.Position.Y > n3
		end
		return true
	end

	steal.GOD.Suspend = function(arg)
		steal.GOD.SuspendUntil = os.clock() + (arg or 3)
	end

	steal.GOD.Bat = function()
		local bat = steal.GOD.bat
		if bat and bat.Parent and bat:GetAttribute("IsBat") == true then
			return bat
		end
		steal.GOD.bat = nil
		local character = localPlayer.Character
		local humanoid = character and character:FindFirstChildOfClass("Humanoid")

		for _, v6 in ipairs({ character, localPlayer:FindFirstChild("Backpack") }) do
			for _, v7 in ipairs(v6 and v6:GetChildren() or {}) do
				if v7:IsA("Tool") and v7:GetAttribute("IsBat") == true then
					if v6 ~= character and humanoid then
						pcall(function()
							humanoid:EquipTool(v7)
						end)
					end

					steal.GOD.bat = v7
					return v7
				end
			end
		end
	end

	steal.GOD.Range = function()
		local cfg = steal.GOD.cfg
		local n7 = cfg and tonumber(cfg.Range) or 15
		local n8 = 1

		if cfg and type(cfg.GetHitboxScalar) == "function" then
			local ok, result = pcall(cfg.GetHitboxScalar)

			if ok and type(result) == "number" and result > 0 then
				n8 = result
			end
		end

		return n7 * n8
	end

	steal.GOD.Ayun = function(arg)
		local v6 = steal.GOD.Bat()

		if v6 then
			if v6:GetAttribute("CooldownActive") ~= true then
				steal.GOD.Seq = (steal.GOD.Seq or 0) + 1
				local str2 = ("%d:%d:%d"):format(localPlayer.UserId, steal.GOD.Seq, math.floor(v:GetServerTimeNow() * 1000))
				local BatSwing = tbl.NET.Get("BatSwing", "Trigger")

				if BatSwing then
					pcall(BatSwing.FireServer, BatSwing, arg, str2)
					steal.GOD.Swings = (steal.GOD.Swings or 0) + 1
					return true, steal.GOD.CD
				end

				return false, 1
			end

			local n7 = (tonumber(v6:GetAttribute("CooldownEndTime")) or 0) - v:GetServerTimeNow()
			if not (n7 > 0) then
				return false, 0.05
			end
			return false, (math.min(n7, 1))
		end

		return false, 1
	end

	steal.GOD.Swing = function(arg, arg2)
		local v6 = steal.GOD.Range()
		local v7 = nil
		local humanoidRootPart

		for _, player in ipairs(tbl.SV.Players:GetPlayers()) do
			if player ~= localPlayer then
				local character = player.Character

				if character then
					humanoidRootPart = character:FindFirstChild("HumanoidRootPart")
					character = character:FindFirstChildOfClass("Humanoid")
					if not humanoidRootPart then
						continue
					end
				end

				if character and character.Health > 0 then
					local magnitude = (humanoidRootPart.Position - arg.Position).Magnitude

					if magnitude <= v6 then
						v6 = magnitude
						v7 = player
					end
				end
			end
		end

		if v7 then
			local v8, v9 = steal.GOD.Ayun(v7)
			steal.GOD.NextSwing = arg2 + v9
			return
		end

		steal.GOD.NextSwing = arg2 + 0.25
	end

	steal.GOD.Start = function()
		if steal.GOD.Conn then
			steal.GOD.on = true
			return
		end
		steal.GOD.on = true
		local god = steal.GOD
		local god2 = steal.GOD
		steal.GOD.NextHeavy = 0
		god.NextLock = 0
		god2.Until = 0
		local god3 = steal.GOD
		steal.GOD.SuspendUntil = 0
		god3.HeldUid = nil
		local god4 = steal.GOD
		steal.GOD.motors = {}
		god4.cons = {}
		local god5 = steal.GOD
		local god6 = steal.GOD
		local god7 = steal.GOD
		steal.GOD.NextSwing = 0
		god5.Seq = 0
		god6.Swings = 0
		god7.bat = nil
		local shared = tbl.SV.ReplicatedStorage:FindFirstChild("Shared")
		local modules = shared and shared:FindFirstChild("Modules")
		local batController = modules and modules:FindFirstChild("BatController")
		local config = batController and batController:FindFirstChild("Config")

		if config then
			local ok, cfg = pcall(require, config)
			local god8 = steal.GOD

			if not ok or not cfg then
				cfg = nil
			end

			god8.cfg = cfg
		end

		steal.GOD.CD = 0.6
		local flags = shared and shared:FindFirstChild("Flags")
		local gameplayBalance = flags and flags:FindFirstChild("GameplayBalance")

		if gameplayBalance then
			local ok, result = pcall(require, gameplayBalance)
			local cd = ok and result and result.BatClient and tonumber(result.BatClient.CLIENT_COOLDOWN)

			if cd and cd > 0 then
				steal.GOD.CD = cd
			end
		end

		tbl.LOG.info("GOD", ("bat: jangkauan %d stud, cooldown %.2f dtk"):format(math.floor(steal.GOD.Range()), steal.GOD.CD))
		local god8 = steal.GOD
		local preSimulation = runService.PreSimulation
		local v6 = preSimulation
		local connect = preSimulation.Connect

		local function fn20()
			if steal.GOD.on then
				local v7, v8, v9 = fn()

				if v7 then
					if v8 then
						if v9 then
							if not (v8.Health <= 0) then
								if not (v7.Position.X <= steal.GATE_X) then
									local now = os.clock()

									if not (now < steal.GOD.SuspendUntil) then
										local flag2 = false

										if v8.Sit then
											v8.Sit = false
											flag2 = true
										end

										if v8.PlatformStand then
											v8.PlatformStand = false
											flag2 = true
										end

										local state = v8:GetState()

										if state == Enum.HumanoidStateType.Physics or state == Enum.HumanoidStateType.Ragdoll or state == Enum.HumanoidStateType.FallingDown then
											v8:ChangeState(Enum.HumanoidStateType.Running)
											flag2 = true
										end

										if state ~= Enum.HumanoidStateType.Jumping and state ~= Enum.HumanoidStateType.Freefall and state ~= Enum.HumanoidStateType.Landed then
											local assemblyLinearVelocity = v7.AssemblyLinearVelocity

											if math.abs(assemblyLinearVelocity.Y) > 8 and not steal.GOD.DiUdara(v7, v8, v9) then
												v7.AssemblyLinearVelocity = Vector3.new(assemblyLinearVelocity.X, 0, assemblyLinearVelocity.Z)
												flag2 = true
											end
										end

										if flag2 then
											steal.GOD.Until = now + 1
										end

										if steal.GOD.NextLock <= now then
											steal.GOD.NextLock = now + n5
											local v10 = steal.HeldUid()

											if v10 then
												steal.GOD.HeldUid = v10
											elseif steal.GOD.HeldUid then
												if not (now - steal.ManualDropAt < steal.WATCH.MANUAL) then
													local heldUid = steal.GOD.HeldUid
													local EggWorld = tbl.NET.Get("EggWorld", "AskFieldEggCarry")

													if EggWorld then
														local function fn21()
															pcall(EggWorld.InvokeServer, EggWorld, { Uid = heldUid })
														end

														task.spawn(fn21)
													end
												else
													steal.GOD.HeldUid = nil
												end
											end
										end

										if steal.GOD.NextSwing <= now then
											steal.GOD.Swing(v7, now)
										end

										if not (steal.GOD.Until <= now) then
											if not (now < steal.GOD.NextHeavy) then
												steal.GOD.NextHeavy = now + n4

												if steal.GOD.char ~= v9 then
													fn19(v9)
												end

												local motors = steal.GOD.motors

												while true do
													local v10

													if I_1 <= 0 then
														if not (N_1 >= C_1) then
															break
														end
														v10 = N_1
													else
														if not (N_1 <= C_1) then
															break
														end
														v10 = N_1
													end

													local v11 = motors[v10]

													if v11.Parent and not v11.Enabled then
														v11.Enabled = true
													end
												end

												local cons = steal.GOD.cons

												while true do
													local v10

													if I_1 <= 0 then
														if not (N_1 >= C_1) then
															break
														end
														v10 = N_1
													else
														if not (N_1 <= C_1) then
															break
														end
														v10 = N_1
													end

													local v11 = cons[v10]

													if v11.Parent and v11.Enabled then
														v11.Enabled = false
													end
												end

												for _, v10 in ipairs(v8:GetPlayingAnimationTracks()) do
													if (v10.Animation and v10.Animation.AnimationId or ""):find("122257458498464") then
														v10:Stop(0)
													elseif v10.Name == "Animation1" then
														v10:Stop(0)
													end
												end

												if v9:GetAttribute("IsTrapped") ~= true then
													return
												end

												local function fn21()
													v9:SetAttribute("IsTrapped", false)
												end

												pcall(fn21)
												return
											end

											return
										end

										return
									end

									return
								end

								return
							end

							return
						end

						return
					end

					return
				end

				return
			end
		end

		god8.Conn = connect(v6, fn20)
	end

	steal.GOD.Stop = function()
		steal.GOD.on = false

		if steal.GOD.Conn then
			local function fn20()
				steal.GOD.Conn:Disconnect()
			end

			pcall(fn20)
			steal.GOD.Conn = nil
		end

		if steal.GOD.addCx then
			local v6 = pcall

			local function fn20()
				steal.GOD.addCx:Disconnect()
			end

			v6(fn20)
			steal.GOD.addCx = nil
		end

		local god = steal.GOD
		local god2 = steal.GOD
		local god3 = steal.GOD
		steal.GOD.char = nil
		god.motors = nil
		god2.cons = nil
		god3.HeldUid = nil
		local god4 = steal.GOD
		steal.GOD.bat = nil
		god4.cfg = nil
	end

	steal.AHG = { on = false, Fired = 0, LastTicks = 0 }
	steal.AHG.HOLD = 0.7
	steal.AHG.POLL = 0.04

	steal.AHG.Decoy = function()
		if steal.TP.on then
			return false
		end
		local v6 = fn2()

		if v6 then
			local cFrame = v6.CFrame
			local v7 = steal.TP.Clone(cFrame, true)

			if v7 then
				steal.TP.decoy = v7
				steal.TP.on = true

				local function alive()
					return steal.AHG.on
				end

				steal.TP.Alive = alive
				steal.TP.RealName(false)
				pcall(steal.TP.CharHidden, true)
				local v8 = steal.HeldUid()

				if v8 then
					for _, v9 in pairs(steal.FieldRecords()) do
						if tostring(v9.Uid) ~= v8 then
							continue
						end
						steal.TP.EggProp(v7, tostring(v9.AssetCategory), tonumber(v9.AssetScale))
						break
					end
				end

				local position = cFrame.Position
				steal.TP.CamLock(CFrame.lookAt(position + Vector3.new(-8.5, 2.2, 3.8), position + Vector3.new(0, 1.3, -0.6)))
				return true
			end

			return false
		end

		return false
	end

	steal.AHG.Burst = function()
		local v6 = steal.AHG.Decoy()
		local cframe = CFrame.new(steal.STRIP)
		local n7 = os.clock() + steal.AHG.HOLD
		local n8 = 0

		while os.clock() < n7 do
			local v7 = fn2()

			if v7 then
				if v7.Parent then
					steal.Tulis(v7, cframe, false)
					n8 += 1
					runService.Heartbeat:Wait()
					continue
				end

				break
			end

			break
		end

		if v6 then
			steal.TP.Clear()
			return n8
		end
		return n8
	end

	steal.AHG.Start = function()
		if steal.AHG.on then
			return
		end
		steal.AHG.on = true
		tbl.LOG.info("AHG", ("aktif - tahan %d ms"):format(steal.AHG.HOLD * 1000))

		task.spawn(function()
			local flag2 = false

			while steal.AHG.on do
				if tbl.Alive then
					local flag3 = steal.HeldUid() ~= nil

					if flag3 and not flag2 then
						steal.AHG.Fired = steal.AHG.Fired + 1
						local ok, result = pcall(steal.AHG.Burst)
						steal.AHG.LastTicks = ok and result or 0
					end

					task.wait(steal.AHG.POLL)
					flag2 = flag3
					continue
				end

				break
			end

			steal.AHG.on = false
		end)
	end

	local function stop()
		if steal.AHG.on then
			steal.AHG.on = false
			tbl.LOG.info("AHG", ("berhenti - %d burst"):format(steal.AHG.Fired))
			return
		end
	end

	steal.AHG.Stop = stop
	tbl.ST.Trove:Add(steal.GOD.Stop)
	steal.TM = { on = false, Gained = 0, LastGain = 0 }
	steal.TM.POLL = 1
	steal.TM.STALE = 3.5
	steal.TM.NEAR = 6

	local function pad()
		local pad2 = steal.TM.pad
		if pad2 and pad2.Parent then
			return pad2
		end
		steal.TM.pad = nil
		local plots = v:FindFirstChild("Plots")

		if plots then
			local displayName = localPlayer.DisplayName or localPlayer.Name

			for _, child in ipairs(plots:GetChildren()) do
				local plotSign = child:FindFirstChild("PlotSign", true)

				if plotSign then
					for _, descendant in ipairs(plotSign:GetDescendants()) do
						if descendant:IsA("TextLabel") and (descendant.Text == displayName or descendant.Text == localPlayer.Name) then
							local treadmillBottom = child:FindFirstChild("TreadmillBottom", true)
							if treadmillBottom then
								steal.TM.pad = treadmillBottom
								return treadmillBottom
							end
						end
					end
				end
			end

			return
		end

		return nil
	end

	steal.TM.Pad = pad

	steal.TM.Naik = function()
		return os.clock() - steal.TM.LastGain < steal.TM.STALE
	end

	steal.TM.Pantau = function()
		if steal.TM.cx then
			return true
		end
		local Treadmill = tbl.NET.Get("Treadmill", "SpeedGained")

		if Treadmill then
			steal.TM.cx = Treadmill.OnClientEvent:Connect(function(arg)
				steal.TM.LastGain = os.clock()
				steal.TM.Gained = steal.TM.Gained + (tonumber(arg) or 0)
			end)

			tbl.ST.Trove:Add(function()
				if steal.TM.cx then
					pcall(function()
						steal.TM.cx:Disconnect()
					end)

					steal.TM.cx = nil
					return
				end
			end)

			local Treadmill2 = tbl.NET.Get("Treadmill", "AssignedBeltShifted")

			if Treadmill2 then
				steal.TM.bx = Treadmill2.OnClientEvent:Connect(function(belt)
					steal.TM.belt = belt
					steal.TM.beltAt = os.clock()
				end)

				tbl.ST.Trove:Add(function()
					if steal.TM.bx then
						pcall(function()
							steal.TM.bx:Disconnect()
						end)

						steal.TM.bx = nil
						return
					end
				end)

				return true
			end

			return true
		end

		return false
	end

	task.spawn(function()
		for i = 1, 20 do
			if steal.TM.Pantau() then
				return
			end
			task.wait(0.5)
		end

		tbl.LOG.warn("TREADMILL", "SpeedGained tidak ketemu - deteksi naik jatuh ke Anchored + jarak pad")
	end)

	steal.TM.NaikPasti = function()
		if steal.TM.belt ~= nil then
			return true, "belt " .. tostring(steal.TM.belt)
		end

		if steal.TM.Naik() then
			return true, "denyut SpeedGained"
		end
		local v6 = fn2()

		if v6 then
			if v6.Anchored then
				local v7 = steal.TM.Pad()

				if v7 then
					if not ((v6.Position - v7.Position + Vector3.new(0, 3.5, 0)).Magnitude < steal.TM.NEAR) then
						return false
					end
					return true, "Anchored + di atas pad"
				end

				return false
			end

			return false
		end

		return false
	end

	steal.TM.Tick = function()
		local v6 = steal.TM.Pad()

		if v6 then
			local v7 = fn2()

			if v7 then
				local n7 = v6.Position + Vector3.new(0, 3.5, 0)
				local magnitude = (v7.Position - n7).Magnitude
				local v8 = steal.TM.Naik()
				if magnitude < steal.TM.NEAR and v8 then
					return
				end

				if steal.TM.NEAR <= magnitude and not steal.Hop(n7, 4, true) then
					return
				end
				local v9 = fn2()

				if v9 then
					if not (steal.TM.NEAR <= (v9.Position - n7).Magnitude) then
						local Treadmill = tbl.NET.Get("Treadmill", "AskWearStill")

						if Treadmill then
							local v10 = table.pack(pcall(Treadmill.InvokeServer, Treadmill))
							if v10[1] and v10[2] == true then
								steal.TM.LastGain = os.clock()
								return
							end
							tbl.LOG.warn("TREADMILL", "naik ditolak: " .. tostring(v10[3] or v10[2]))
							return
						end

						return
					end

					return
				end

				return
			end

			return
		end
	end

	steal.TM.Start = function()
		if steal.TM.on then
			return
		end
		steal.TM.on = true
		local tm = steal.TM
		steal.TM.Gained = 0
		tm.LastGain = 0
		steal.TM.Pantau()

		task.spawn(function()
			while steal.TM.on do
				if tbl.Alive then
					local sekarang = steal.ORDER and steal.ORDER.sekarang
					local str2

					if steal.Running then
						str2 = "Auto Steal jalan"

						if not steal.TM.warned then
							steal.TM.warned = true

							if not steal.PLACE or not steal.PLACE.sibuk then
								steal.TM.Doff()
							end

							tbl.LOG.warn("TREADMILL", str2 .. " - treadmill menunggu")
						end
					elseif sekarang and sekarang ~= "auto_steal" then
						local v6 = steal.ORDER.TUGAS[sekarang]
						str2 = (v6 and v6.label or sekarang) .. " jalan"

						if not steal.TM.warned then
							steal.TM.warned = true

							if not steal.PLACE or not steal.PLACE.sibuk then
								steal.TM.Doff()
							end

							tbl.LOG.warn("TREADMILL", str2 .. " - treadmill menunggu")
						end
					elseif steal.SCR.sesi then
						str2 = "Dr. Scramble jalan"

						if not steal.TM.warned then
							steal.TM.warned = true

							if not steal.PLACE or not steal.PLACE.sibuk then
								steal.TM.Doff()
							end

							tbl.LOG.warn("TREADMILL", str2 .. " - treadmill menunggu")
						end
					elseif steal.SCR.Siap() then
						str2 = "Dr. Scramble jalan"

						if not steal.TM.warned then
							steal.TM.warned = true

							if not steal.PLACE or not steal.PLACE.sibuk then
								steal.TM.Doff()
							end

							tbl.LOG.warn("TREADMILL", str2 .. " - treadmill menunggu")
						end
					elseif steal.PLACE and steal.PLACE.sibuk then
						str2 = "Auto Place jalan"

						if not steal.TM.warned then
							steal.TM.warned = true

							if not steal.PLACE or not steal.PLACE.sibuk then
								steal.TM.Doff()
							end

							tbl.LOG.warn("TREADMILL", str2 .. " - treadmill menunggu")
						end
					else
						steal.TM.warned = nil
						steal.TM.Tick()
					end

					task.wait(steal.TM.POLL)
					continue
				end

				break
			end

			steal.TM.on = false
		end)

		tbl.LOG.info("TREADMILL", "aktif")
	end

	steal.TM.Doff = function()
		local Treadmill, v6 = tbl.NET.Get("Treadmill", "AskDoff")

		if Treadmill then
			if v6 ~= "RemoteFunction" then
				pcall(Treadmill.FireServer, Treadmill)
				steal.TM.LastGain = 0
				return true
			end

			local v7 = table.pack(pcall(Treadmill.InvokeServer, Treadmill))
			steal.TM.LastGain = 0
			local v8 = v7[1]
			if v8 then
				return v7[2] ~= false
			end
			return v8
		end

		return false
	end

	steal.TM.DoffPasti = function(arg)
		local n7 = arg or 3

		for i = 1, n7 do
			steal.TM.Doff()
			local now = os.clock()
			local exitTo = nil

			while true do
				if not (os.clock() - now < 1.6) then
					exitTo = 1
					break
				else
					local flag2 = steal.TM.belt == nil
					local flag3 = steal.TM.LastGain == 0 or os.clock() - steal.TM.LastGain >= 1.2
					if flag2 and flag3 then
						break
					end
					runService.Heartbeat:Wait()
				end
			end

			if exitTo == 1 then
				tbl.LOG.warn("TREADMILL", ("masih terpasang sesudah Doff (%d/%d) -- diulang [belt=%s denyut=%.2fs]"):format(i, n7, tostring(steal.TM.belt), if steal.TM.LastGain > 0 then os.clock() - steal.TM.LastGain else -1))
				continue
			end
			return true, true
		end

		tbl.LOG.err("TREADMILL", ("gagal turun sesudah %d percobaan"):format(n7))
		return false, true
	end

	steal.TM.BolehKeluar = function(arg)
		local x

		if arg ~= nil then
			x = typeof(arg) == "CFrame" and arg.Position.X or arg.X
		end

		if x and x <= steal.GATE_X then
			return true
		end
		local v6, v7 = steal.TM.NaikPasti()

		if v6 then
			if steal.TM.DoffPasti(3) then
				return true
			end
			tbl.LOG.warn("TREADMILL", ("keberangkatan DITAHAN di safe zone - masih terpasang (%s)"):format(tostring(v7 or "denyut SpeedGained")))
			fn4("still mounted on treadmill - holding in safe zone")
			return false
		end

		return true
	end

	steal.TM.Stop = function()
		if steal.TM.on then
			steal.TM.on = false
			steal.TM.Doff()
			tbl.LOG.info("TREADMILL", ("berhenti - total %d speed power"):format(steal.TM.Gained))
			return
		end
	end

	tbl.ST.Trove:Add(steal.AHG.Stop)
	steal.IC = { on = false, Grabs = 0 }
	steal.IC.POLL = 0.1
	steal.IC.RANGE = 36
	steal.IC.GAP = 0.35
	local ic = steal.IC
	local rarities = { Divine = true }
	rarities.Eternal = true
	rarities.Secret = true
	rarities.Cosmic = true
	ic.RARITIES = rarities
end

steal.IC.Tick = function()
	if steal.Running then
		return
	end

	if steal.pulang then
		return
	end

	if steal.rampok then
		return
	end

	if steal.HeldUid() then
		return
	end
	local now = os.clock()
	local nextTry = steal.IC.NextTry

	if nextTry then
		if now < nextTry then
			return
		end
	elseif now < 0 then
		return
	end

	local v4 = fn2()

	if v4 then
		local position = v4.Position
		local str2 = nil
		local v5 = nil

		for _, v6 in pairs(steal.FieldRecords()) do
			local str3 = tostring(v6.State)

			if str3 == "Slot" or str3 == "Dropped" then
				local bottomCFrame = v6.BottomCFrame or v6.BoundsCFrame

				if typeof(bottomCFrame) == "CFrame" then
					local magnitude = (bottomCFrame.Position - position).Magnitude

					if magnitude <= steal.IC.RANGE and (not v5 or magnitude < v5) and steal.IC.RARITIES[steal.RarityIdOf(tostring(v6.AssetCategory))] then
						str2 = tostring(v6.Uid)
						v5 = magnitude
					end
				end
			end
		end

		if not str2 then
			return
		end
		steal.IC.NextTry = now + steal.IC.GAP
		local EggWorld = tbl.NET.Get("EggWorld", "AskFieldEggCarry")
		if not EggWorld then
			return
		end

		local function fn12()
			local v6 = table.pack(pcall(EggWorld.InvokeServer, EggWorld, { Uid = str2 }))

			if v6[1] and v6[2] == true then
				steal.IC.Grabs = steal.IC.Grabs + 1
				tbl.LOG.info("IC", ("telur terangkat pada %d stud"):format(math.floor(v5)))
				return
			end
		end

		task.spawn(fn12)
		return
	end
end

steal.IC.Start = function()
	if steal.IC.on then
		return
	end
	steal.IC.on = true
	steal.IC.NextTry = 0
	tbl.LOG.info("IC", ("aktif - telur langka dalam %d stud diangkat otomatis"):format(steal.IC.RANGE))

	task.spawn(function()
		while steal.IC.on do
			if tbl.Alive then
				steal.IC.Tick()
				task.wait(steal.IC.POLL)
				continue
			end

			break
		end

		steal.IC.on = false
	end)
end

steal.IC.Stop = function()
	if steal.IC.on then
		steal.IC.on = false
		tbl.LOG.info("IC", ("berhenti - %d telur terangkat"):format(steal.IC.Grabs))
		return
	end
end

tbl.ST.Trove:Add(steal.TM.Stop)
tbl.ST.Trove:Add(steal.IC.Stop)

steal.Carry = function(arg, arg2, arg3, arg4)
	local EggWorld = tbl.NET.Get("EggWorld", "AskFieldEggCarry")

	if EggWorld then
		local function fn12()
			local v4 = fn2()
			if v4 then
				steal.Tulis(v4, CFrame.new(arg2), false)
				return v4
			end
			return nil
		end

		local now = os.clock()
		local v4 = steal.FrameTarget(0.37)
		local n2 = now + 0.37 * (steal.FPS_MAKS or 4)
		local n3 = 0
		local flag2 = false

		while steal.Running do
			local now2 = os.clock()

			if (not (now2 - now >= 0.37) or not (v4 <= n3)) and not (n2 <= now2) then
				if fn12() then
					n3 += 1

					if not flag2 and os.clock() - now >= 0.1 then
						local tbl2 = { Uid = arg }
						local match = arg:match("Forest:(Slot_%d+)")

						if match then
							tbl2.FirstAreaSlotKey = "Forest:" .. match
						end

						local v5 = table.pack(pcall(EggWorld.InvokeServer, EggWorld, tbl2))
						fn12()
						flag2 = true
						if v5[1] and v5[2] == true then
							return true, arg
						end
					end

					runService.Heartbeat:Wait()
					continue
				end

				return false
			end

			break
		end

		local n4 = os.clock() + (arg3 or 6)
		local now2 = os.clock()
		local n5 = 0
		local str2 = "?"

		while true do
			if not steal.Running or not (os.clock() < n4) then
				tbl.LOG.warn("STEAL", ("carry gagal setelah %d percobaan: %s"):format(n5, str2:sub(1, 60)))
				return false, arg
			else
				if fn12() then
					local tbl2 = { Uid = arg }
					local match = arg:match("Forest:(Slot_%d+)")

					if match then
						tbl2.FirstAreaSlotKey = "Forest:" .. match
					end

					n5 += 1
					local v5 = table.pack(pcall(EggWorld.InvokeServer, EggWorld, tbl2))
					fn12()
					if v5[1] and v5[2] == true then
						return true, arg
					end
					str2 = tostring(v5[3] or v5[2])
					if str2:find("Already carrying") then
						return true, arg
					end

					if str2:find("not found") and os.clock() - now2 > 0.5 then
						now2 = os.clock()
						local v6 = fn8(arg2, arg4, arg)
						fn12()
						arg = v6 or arg
					end

					runService.Heartbeat:Wait()
					continue
				end

				break
			end
		end

		return false
	end

	return false
end

steal.FS_ULANG = 0.06
steal.FS_T = { n = 0 }

do
	local function fn12()
		local v4 = steal.Areas()
		local guardAreas = v4 and v4:FindFirstChild("GuardAreas")
		local forest = guardAreas and guardAreas:FindFirstChild("Forest")
		local guard = forest and (forest:FindFirstChild("Guard") or forest:FindFirstChild("ForestGuardAuthored"))

		if guard then
			local humanoidRootPart = guard:FindFirstChild("HumanoidRootPart") or guard:IsA("Model") and guard.PrimaryPart or guard:FindFirstChild("Collider")
			local collider = guard:FindFirstChild("Collider")
			if collider then
				return humanoidRootPart, collider
			end
			return humanoidRootPart, humanoidRootPart
		end

		return nil, nil
	end

	local tbl2 = nil

	local function fn13(arg)
		if not tbl2 then
			tbl2 = {}

			for i, v4 in ipairs(steal.RarityList()) do
				tbl2[v4] = i
			end
		end

		local v4 = tbl2[steal.RarityIdOf(arg)]
		if v4 then
			return v4
		end
		return 0
	end

	local function fn14()
		local v4 = fn12()
		local position = v4 and v4.Position
		local v5 = nil
		local str2 = nil
		local v6 = nil

		for _, v7 in pairs(steal.FieldRecords()) do
			if tostring(v7.AreaId) == "Forest" and tostring(v7.State) == "Slot" and typeof(v7.BottomCFrame) == "CFrame" then
				local position2 = v7.BottomCFrame.Position
				local n2 = -(position and (position2 - position).Magnitude or 0) + fn13(tostring(v7.AssetCategory)) * 100

				if not v5 or n2 > v5 then
					str2 = tostring(v7.Uid)
					v5 = n2
					v6 = position2
				end
			end
		end

		return str2, v6
	end

	local function fn15()
		local v4 = fn3()

		if v4 then
			local function fn16()
				v4:UnequipTools()
			end

			pcall(fn16)
		end

		local now = os.clock()

		local function fn16(arg, arg2)
			steal.FS_T[arg] = math.floor((os.clock() - arg2) * 1000)
			return os.clock()
		end

		steal.FS_T = { n = (steal.FS_T and steal.FS_T.n or 0) + 1 }
		local v5, v6 = fn14()
		if not v5 then
			return false
		end
		local vector = fn7(v5, v6) or Vector3.new(597.18, 68.08, -324.37)
		local umpan = fn16("umpan", now)

		if steal.GlideRetry(vector, 15, 3) then
			local terbang = fn16("terbang", umpan)

			if steal.Carry(v5, vector, 4) then
				local angkat = fn16("angkat", terbang)
				local now2 = os.clock()
				local v7, v8 = fn12()
				if not v7 or not v8 then
					return false
				end

				if fn2() then
					steal.GOD.Suspend(3)
					local kena = false
					local tbl3 = {}
					local now3 = nil

					local function fn17()
						if not kena then
							now3 = os.clock()
						end

						kena = true
					end

					local v9 = fn3()

					if v9 then
						tbl3[#tbl3 + 1] = v9.StateChanged:Connect(function(old, new)
							if new ~= Enum.HumanoidStateType.Ragdoll then
								if new ~= Enum.HumanoidStateType.FallingDown then
									if new ~= Enum.HumanoidStateType.PlatformStanding then
										return
									end
									fn17()
									return
								end

								fn17()
								return
							end

							fn17()
						end)

						local n2 = #tbl3 + 1

						local function fn18()
							if v9.PlatformStand then
								fn17()
								return
							end
						end

						tbl3[n2] = v9:GetPropertyChangedSignal("PlatformStand"):Connect(fn18)
					end

					pcall(function()
						local packages = tbl.SV.ReplicatedStorage:FindFirstChild("Packages")
						local networking = packages and packages:FindFirstChild("Networking")
						local reRigSyncRefresh = networking and networking:FindFirstChild("RE/RigSync/Refresh")
						if reRigSyncRefresh then
							tbl3[#tbl3 + 1] = reRigSyncRefresh.OnClientEvent:Connect(fn17)
							return
						end
					end)

					local function fn18()
						for _, v10 in ipairs(tbl3) do
							local function fn19()
								v10:Disconnect()
							end

							pcall(fn19)
						end

						table.clear(tbl3)
					end

					local function fn19()
						local v10 = fn2()

						if v10 then
							if v8.Parent then
								steal.Tulis(v10, CFrame.new(v7.Position + Vector3.new(0, 0.8, 0)), false)
								v10.AssemblyLinearVelocity = Vector3.zero
								v10.AssemblyAngularVelocity = Vector3.zero

								if firetouchinterest then
									local function fn20()
										firetouchinterest(v10, v8, 0)
										firetouchinterest(v10, v8, 1)
									end

									pcall(fn20)
								end

								tbl.NET.Fire("GuardPatrol", "ForestStrike", { EggUid = v5, GuardCFrame = v7.CFrame })
								return
							end

							return
						end
					end

					local now4 = os.clock()
					steal.FS_T.sebab = "timeout"
					steal.FS_T.break_ms = nil
					steal.FS_T.setup_ms = math.floor((now4 - now2) * 1000)
					fn19()
					local now5 = os.clock()
					local n2 = os.clock() + steal.FS_ULANG
					local n3 = 0
					local flag2 = false
					local lepasSendiri

					while true do
						lepasSendiri = false

						if steal.Running then
							if not (os.clock() - now5 < 1.2) then
								break
							end

							if steal.FS_KENA_CEPAT and kena then
								steal.FS_T.sebab = "kena"
								steal.FS_T.break_ms = math.floor((os.clock() - now4) * 1000)
								break
							end

							if steal.HeldUid() ~= v5 then
								if n3 <= os.clock() then
									n3 = os.clock() + 0.15
									flag2 = fn6() ~= v5
								end

								if flag2 then
									steal.FS_T.lepas_ms = math.floor((os.clock() - now4) * 1000)
									steal.FS_T.sebab = "lepas"
									steal.FS_T.break_ms = steal.FS_T.lepas_ms
									lepasSendiri = true
									break
								end
							end

							if not kena and os.clock() >= n2 then
								n2 = os.clock() + steal.FS_ULANG
								fn19()
							end

							runService.Heartbeat:Wait()
						else
							break
						end
					end

					fn18()
					local pukul = fn16("pukul", angkat)
					steal.FS_T.lepas_sendiri = lepasSendiri
					steal.FS_T.kena = kena
					steal.FS_T.kena_ms = if now3 then math.floor((now3 - now4) * 1000) else nil

					if not lepasSendiri then
						local EggWorld = tbl.NET.Get("EggWorld", "AskFieldEggDrop")

						if EggWorld then
							pcall(EggWorld.InvokeServer, EggWorld, { Reason = "PlayerRequest" })
						end

						if not kena then
							task.wait(0.1)
						end

						pukul = fn16("jatuhkan", pukul)
					end

					local now6 = os.clock()

					while os.clock() - now6 < 0.4 do
						local v10 = fn3()

						if v10 then
							local state = v10:GetState()
							if v10.PlatformStand or state == Enum.HumanoidStateType.Ragdoll or state == Enum.HumanoidStateType.FallingDown or state == Enum.HumanoidStateType.PlatformStanding then
								runService.Heartbeat:Wait()
								continue
							end
							break
						end

						break
					end

					local reda = fn16("reda", pukul)
					local v10 = fn2()
					v4 = fn3()

					if v10 then
						v10.Anchored = false
						v10.AssemblyLinearVelocity = Vector3.zero
					end

					if v4 then
						v4.PlatformStand = false
						v4.Sit = false

						pcall(function()
							v4:SetStateEnabled(Enum.HumanoidStateType.GettingUp, true)
							v4:ChangeState(Enum.HumanoidStateType.Running)
						end)
					end

					pcall(function()
						local playerGui = localPlayer:FindFirstChild("PlayerGui")

						if playerGui then
							for _, descendant in ipairs(playerGui:GetDescendants()) do
								if descendant:IsA("ImageLabel") and descendant.Name:find("Vignette") and descendant.ImageTransparency < 0.99 then
									descendant.ImageTransparency = 1
								end
							end

							return
						end
					end)

					fn16("pulih", reda)

					if not reda then
						local jatuhkan = fn16("jatuhkan", reda)
						local now7 = os.clock()

						while os.clock() - now7 < 0.4 do
							local v11 = fn3()

							if v11 then
								local state = v11:GetState()
								if v11.PlatformStand or state == Enum.HumanoidStateType.Ragdoll or state == Enum.HumanoidStateType.FallingDown or state == Enum.HumanoidStateType.PlatformStanding then
									runService.Heartbeat:Wait()
									continue
								end
								break
							end

							break
						end

						local reda2 = fn16("reda", jatuhkan)
						local v11 = fn2()
						v4 = fn3()

						if v11 then
							v11.Anchored = false
							v11.AssemblyLinearVelocity = Vector3.zero
						end

						if v4 then
							v4.PlatformStand = false
							v4.Sit = false

							pcall(function()
								v4:SetStateEnabled(Enum.HumanoidStateType.GettingUp, true)
								v4:ChangeState(Enum.HumanoidStateType.Running)
							end)
						end

						pcall(function()
							local playerGui = localPlayer:FindFirstChild("PlayerGui")

							if playerGui then
								for _, descendant in ipairs(playerGui:GetDescendants()) do
									if descendant:IsA("ImageLabel") and descendant.Name:find("Vignette") and descendant.ImageTransparency < 0.99 then
										descendant.ImageTransparency = 1
									end
								end

								return
							end
						end)

						fn16("pulih", reda2)

						if not reda2 then
							local jatuhkan2 = fn16("jatuhkan", reda2)
							local now8 = os.clock()

							while os.clock() - now8 < 0.4 do
								local v12 = fn3()

								if v12 then
									local state = v12:GetState()
									if v12.PlatformStand or state == Enum.HumanoidStateType.Ragdoll or state == Enum.HumanoidStateType.FallingDown or state == Enum.HumanoidStateType.PlatformStanding then
										runService.Heartbeat:Wait()
										continue
									end
									break
								end

								break
							end

							local reda3 = fn16("reda", jatuhkan2)
							local v12 = fn2()
							v4 = fn3()

							if v12 then
								v12.Anchored = false
								v12.AssemblyLinearVelocity = Vector3.zero
							end

							if v4 then
								v4.PlatformStand = false
								v4.Sit = false

								pcall(function()
									v4:SetStateEnabled(Enum.HumanoidStateType.GettingUp, true)
									v4:ChangeState(Enum.HumanoidStateType.Running)
								end)
							end

							pcall(function()
								local playerGui = localPlayer:FindFirstChild("PlayerGui")

								if playerGui then
									for _, descendant in ipairs(playerGui:GetDescendants()) do
										if descendant:IsA("ImageLabel") and descendant.Name:find("Vignette") and descendant.ImageTransparency < 0.99 then
											descendant.ImageTransparency = 1
										end
									end

									return
								end
							end)

							fn16("pulih", reda3)

							if not reda3 then
								local jatuhkan3 = fn16("jatuhkan", reda3)
								local now9 = os.clock()

								while os.clock() - now9 < 0.4 do
									local v13 = fn3()

									if v13 then
										local state = v13:GetState()
										if v13.PlatformStand or state == Enum.HumanoidStateType.Ragdoll or state == Enum.HumanoidStateType.FallingDown or state == Enum.HumanoidStateType.PlatformStanding then
											runService.Heartbeat:Wait()
											continue
										end
										break
									end

									break
								end

								local reda4 = fn16("reda", jatuhkan3)
								local v13 = fn2()
								v4 = fn3()

								if v13 then
									v13.Anchored = false
									v13.AssemblyLinearVelocity = Vector3.zero
								end

								if v4 then
									v4.PlatformStand = false
									v4.Sit = false

									pcall(function()
										v4:SetStateEnabled(Enum.HumanoidStateType.GettingUp, true)
										v4:ChangeState(Enum.HumanoidStateType.Running)
									end)
								end

								local v14 = pcall

								while true do
									v14(function()
										local playerGui = localPlayer:FindFirstChild("PlayerGui")

										if playerGui then
											for _, descendant in ipairs(playerGui:GetDescendants()) do
												if descendant:IsA("ImageLabel") and descendant.Name:find("Vignette") and descendant.ImageTransparency < 0.99 then
													descendant.ImageTransparency = 1
												end
											end

											return
										end
									end)

									fn16("pulih", reda4)

									if not reda4 then
										local jatuhkan4 = fn16("jatuhkan", reda4)
										local now10 = os.clock()

										while os.clock() - now10 < 0.4 do
											local v15 = fn3()

											if v15 then
												local state = v15:GetState()
												if v15.PlatformStand or state == Enum.HumanoidStateType.Ragdoll or state == Enum.HumanoidStateType.FallingDown or state == Enum.HumanoidStateType.PlatformStanding then
													runService.Heartbeat:Wait()
													continue
												end
												break
											end

											break
										end

										reda4 = fn16("reda", jatuhkan4)
										local v15 = fn2()
										v4 = fn3()

										if v15 then
											v15.Anchored = false
											v15.AssemblyLinearVelocity = Vector3.zero
										end

										if v4 then
											v4.PlatformStand = false
											v4.Sit = false

											pcall(function()
												v4:SetStateEnabled(Enum.HumanoidStateType.GettingUp, true)
												v4:ChangeState(Enum.HumanoidStateType.Running)
											end)
										end

										v14 = pcall
									else
										break
									end
								end
							end
						end
					end

					tbl.LOG.warn("FOREST", "ForestStrike did not complete; retry next cycle")
					return false
				end

				return false
			end

			return false
		end

		return false
	end

	steal.FS_MAKS = 3
	steal.FS_KENA_CEPAT = true

	steal.ForestStrike = function()
		for i = 1, steal.FS_MAKS do
			local v4, v5 = fn15()

			if v4 and v5 then
				if not (i > 1) then
					return true
				end
				tbl.LOG.info("STEAL", ("forest strike sah di percobaan ke-%d"):format(i))
				return true
			end

			if steal.Running then
				if v4 then
					tbl.LOG.warn("STEAL", ("forest strike %d/%d: guard tidak kena, telur dijatuhkan paksa -- setoran akan ditolak, diulang"):format(i, steal.FS_MAKS))
					task.wait(0.2)
					continue
				end

				return false
			end

			return false
		end

		return false
	end
end

local fn12

fn12 = function()
	local v4 = steal.SaveData()
	if type(v4) ~= "table" then
		return nil
	end

	if type(v4.EggInventory) ~= "table" then
		return nil
	end
	local n2 = 0

	for k in pairs(v4.EggInventory) do
		n2 += 1
	end

	return n2
end

local fn13

fn13 = function()
	local tbl2 = {}
	local v4 = steal.SaveData()
	if type(v4) ~= "table" or type(v4.EggInventory) ~= "table" then
		return tbl2
	end

	for k in pairs(v4.EggInventory) do
		tbl2[tostring(k)] = true
	end

	return tbl2
end

steal.PEN = { Placed = 0, Failed = 0 }
steal.PEN.JARAK = 5
steal.PEN.CELAH = 3
steal.PEN.TEPI = 2.5
steal.PEN.Y = -0.5
steal.PEN.DEKAT = 28
steal.PEN.COBA = 12

steal.PEN.On = function()
	local autoPlacePen = tbl.UIX and tbl.UIX.STEAL and tbl.UIX.STEAL.AutoPlacePen
	if autoPlacePen and autoPlacePen.Get and autoPlacePen.Get() then
		return true
	end
	return false
end

steal.PEN.Center = function()
	return steal.PlotOf(localPlayer)
end

steal.PEN.Area = function(arg)
	local area = steal.PEN.area
	if area and area.Parent then
		return area
	end
	steal.PEN.area = nil
	local plotSt = steal.PlotSt

	if plotSt and plotSt.ResolvePlot then
		local ok, result = pcall(plotSt.ResolvePlot, localPlayer)
		local petArea = ok and type(result) == "table" and result.PetArea
		if typeof(petArea) == "Instance" and petArea:IsA("BasePart") then
			steal.PEN.area = petArea
			return petArea
		end
	end

	local petArea = arg and arg.Parent and arg.Parent:FindFirstChild("PetArea", true)
	if petArea and petArea:IsA("BasePart") then
		steal.PEN.area = petArea
		return petArea
	end
end

steal.PEN.Slots = function(arg, arg2)
	local slotKunci = tostring(arg.CFrame) .. "|" .. tostring(arg2.CFrame) .. "|" .. tostring(arg2.Size)
	if steal.PEN.slots and steal.PEN.slotKunci == slotKunci then
		return steal.PEN.slots
	end
	local n2 = arg2.Size / 2
	local huge = math.huge
	local n3 = -math.huge
	local huge2 = math.huge
	local n4 = -math.huge

	for _, v4 in ipairs({ -1, 1 }) do
		for _, v5 in ipairs({ -1, 1 }) do
			local v6 = arg.CFrame:PointToObjectSpace(arg2.CFrame:PointToWorldSpace(Vector3.new(v4 * n2.X, 0, v5 * n2.Z)))
			huge = math.min(huge, v6.X)
			n3 = math.max(n3, v6.X)
			huge2 = math.min(huge2, v6.Z)
			n4 = math.max(n4, v6.Z)
		end
	end

	local jarak = steal.PEN.JARAK
	local tepi = steal.PEN.TEPI
	local n5 = math.max(1, math.floor((n3 - huge - 2 * tepi) / jarak) + 1)
	local n6 = math.max(1, math.floor((n4 - huge2 - 2 * tepi) / jarak) + 1)
	local n7 = (huge + n3) / 2 - (n5 - 1) * jarak / 2
	local n8 = huge2 + tepi
	local n9 = 1

	if math.abs(n4) < math.abs(huge2) then
		n8 = n4 - tepi
		n9 = -1
	end

	local slots = {}

	for i = 0, n6 - 1 do
		local n10 = n8 + n9 * i * jarak

		for i2 = 0, n5 - 1 do
			slots[#slots + 1] = Vector3.new(n7 + i2 * jarak, steal.PEN.Y, n10)
		end
	end

	local pen = steal.PEN
	steal.PEN.slots = slots
	pen.slotKunci = slotKunci
	return slots
end

steal.PEN.Terisi = function()
	local tbl2 = {}

	for _, v4 in pairs(steal.OwnEggs()) do
		local placement = type(v4) == "table" and v4.Placement
		local localCFrame = type(placement) == "table" and placement.LocalCFrame

		if typeof(localCFrame) == "CFrame" then
			tbl2[#tbl2 + 1] = localCFrame.Position
		end
	end

	return tbl2
end

steal.PEN.Bebas = function(arg, arg2)
	local celah = steal.PEN.CELAH
	local v4 = arg2

	for _, v5 in ipairs(v4) do
		local n2 = v5.X - arg.X
		local n3 = v5.Z - arg.Z
		if n2 * n2 + n3 * n3 < celah * celah then
			return false
		end
	end

	return true
end

steal.PEN.Approach = function(arg, arg2)
	local v4 = fn2()

	if v4 then
		local n2 = v4.Position.X - arg.X
		local n3 = v4.Position.Z - arg.Z
		local v5 = math.sqrt(n2 * n2 + n3 * n3)

		if arg2 then
			if v5 <= arg2 then
				return
			end
		elseif v5 <= steal.PEN.DEKAT then
			return
		end

		return steal.Hop(arg + Vector3.new(0, 4, 0), 5, true)
	end
end

steal.PEN.gagalAt = {}
steal.PEN.remAt = 0

do
	steal.PEN.REM_UID = 60
	steal.PEN.REM_ALL = 120

	steal.PEN.Place = function(arg)
		local now = os.clock()
		if now < steal.PEN.remAt then
			return false, "rem tanam aktif"
		end

		if not (now < (steal.PEN.gagalAt[arg] or 0)) then
			local v4 = steal.PEN.Center()

			if v4 then
				if fn2() then
					local eggSt = steal.EggSt
					if not eggSt or not eggSt.PlantEgg then
						return false, "EggState.PlantEgg missing"
					end
					local v5 = steal.PEN.Area(v4)

					if v5 then
						local v6 = steal.PEN.Slots(v4, v5)
						local v7 = steal.PEN.Terisi()
						local n2 = 0

						local function fn14(arg2)
							n2 += 1
							local v8 = table.pack(pcall(eggSt.PlantEgg, arg, CFrame.new(arg2)))
							if v8[1] and v8[2] == true then
								return true
							end
							return false, tostring(v8[3] or v8[2])
						end

						local str2 = "tidak ada slot kosong"

						for _, v8 in ipairs(v6) do
							if steal.PEN.Bebas(v8, v7) then
								if not (steal.PEN.COBA <= n2) then
									local v9 = v4.CFrame:PointToWorldSpace(v8)

									if steal.PEN.Approach(v9) ~= false then
										local v10
										v10, str2 = fn14(v8)

										if not v10 and str2:find("closer") then
											if steal.PEN.Approach(v9, 6) == false then
												steal.PEN.gagalAt[arg] = os.clock() + steal.PEN.REM_UID
												return false, "perjalanan ke pen dibatalkan"
											end
											local v11
											v11, str2 = fn14(v8)
											if v11 then
												steal.PEN.Placed = steal.PEN.Placed + 1
												return true
											end
										end

										if v10 then
											steal.PEN.Placed = steal.PEN.Placed + 1
											return true
										end

										if str2:find("already placed") then
											return true
										end

										if str2:find("too close") then
											v7[#v7 + 1] = v8
											continue
										end

										if str2:find("closer") then
											v7[#v7 + 1] = v8
											continue
										end
										break
									end

									steal.PEN.gagalAt[arg] = os.clock() + steal.PEN.REM_UID
									return false, "perjalanan ke pen dibatalkan"
								end

								str2 = ("%d slot dicoba, semua ditolak"):format(n2)
								break
							end
						end

						steal.PEN.Failed = steal.PEN.Failed + 1
						steal.PEN.gagalAt[arg] = os.clock() + steal.PEN.REM_UID

						if str2:find("kosong") or str2:find("full") or str2:find("space") or str2:find("limit") or str2:find("max") then
							steal.PEN.remAt = os.clock() + steal.PEN.REM_ALL
							tbl.LOG.warn("PEN", ("pen tidak menerima telur (%s) - tanam direm %ds"):format(str2, steal.PEN.REM_ALL))
							return false, str2
						end

						return false, str2
					end

					return false, "PetArea not found"
				end

				return false, "no character"
			end

			return false, "own plot not found"
		end

		return false, "telur ini direm"
	end

	steal.PEN.PlaceNew = function(arg)
		local tbl2 = {}

		for k in pairs(fn13()) do
			if not arg[k] then
				tbl2[#tbl2 + 1] = k
			end
		end

		local n2 = 0

		for _, v4 in ipairs(tbl2) do
			local v5, v6 = steal.PEN.Place(v4)

			if v5 then
				n2 += 1
			else
				local v7 = tostring
				tbl.LOG.warn("PEN", ("gagal menanam %s: %s"):format(v4:sub(1, 8), v7(v6)))
			end
		end

		return n2, #tbl2
	end

	steal.OwnerEggs = function(arg)
		local eggSt = steal.EggSt

		if eggSt then
			if eggSt.ReadOwnerEggs then
				local ok, result = pcall(eggSt.ReadOwnerEggs, arg)

				if ok then
					if type(result) ~= "table" then
						return {}
					end
					local records = result.Records
					if records then
						return records
					end
					return result
				end

				return {}
			end

			return {}
		end

		return {}
	end

	steal.OwnEggs = function()
		return steal.OwnerEggs(localPlayer.UserId)
	end

	steal.Unplaced = function(arg)
		local tbl2 = {}

		for k, v4 in pairs(steal.OwnEggs()) do
			if type(v4) == "table" and v4.Placement == nil then
				local assetCategory = v4.AssetCategory
				local str2 = tostring(assetCategory)

				if arg then
					assetCategory = arg(str2)
				end

				if assetCategory then
					tbl2[#tbl2 + 1] = tostring(k)
				end
			end
		end

		return tbl2
	end

	steal.IDLE = { at = 0, val = false, TTL = 0.5 }

	steal.Senggang = function()
		if steal.HeldUid() then
			return false
		end

		if steal.TM.NaikPasti() then
			return false
		end

		if steal.Running or steal.TM.on then
			return steal.NoMatch()
		end
		return true
	end

	steal.NoMatch = function()
		if steal.Running then
			local now = os.clock()

			if not (now - steal.IDLE.at < steal.IDLE.TTL) then
				local ok, result = pcall(function()
					return #steal.Candidates(true)
				end)

				if not ok then
					if not steal.IDLE.errorAt or now - steal.IDLE.errorAt > 15 then
						steal.IDLE.errorAt = now
						tbl.LOG.warn("AutoSteal.Scan", "egg scan error: " .. tostring(result))
					end
				end
				local val = ok and result == 0
				local idle = steal.IDLE
				steal.IDLE.at = now
				idle.val = val
				return val
			end

			return steal.IDLE.val
		end

		return true
	end

	steal.CandidateReasons = function()
		local stats = {
			slots = 0, own = 0, forest = 0, event = 0, noPosition = 0,
			area = 0, pet = 0, rarity = 0, kg = 0, value = 0, accepted = 0,
		}
		local filters = steal.Filters()
		local eventUid = steal.AA and steal.AA.CTE and steal.AA.CTE.Uid and steal.AA.CTE.Uid()
		for _, rec in pairs(steal.FieldRecords()) do
			if type(rec) == "table" and tostring(rec.State) == "Slot" then
				stats.slots += 1
				local uid = tostring(rec.Uid or "")
				local area = tostring(rec.AreaId or "")
				local name = tostring(rec.AssetCategory or "")
				if uid == "" or uid:find(str, 1, true) then
					stats.own += 1
				elseif steal.AREA_HARAM[area] then
					stats.forest += 1
				elseif eventUid and uid == tostring(eventUid) then
					stats.event += 1
				elseif typeof(rec.BottomCFrame) ~= "CFrame" and not fn7(uid, nil) then
					stats.noPosition += 1
				elseif filters.Area and not filters.Area(area) then
					stats.area += 1
				elseif filters.Pet and not filters.Pet(name) then
					stats.pet += 1
				elseif filters.Rarity and not filters.Rarity(steal.RarityIdOf(name)) then
					stats.rarity += 1
				elseif filters.MinKG > 0 and steal.WeightKgOf(rec) < filters.MinKG then
					stats.kg += 1
				elseif filters.MinValue > 0 and steal.ValueOf(rec) < filters.MinValue then
					stats.value += 1
				else
					stats.accepted += 1
				end
			end
		end
		return stats
	end

	steal.DiagnoseAutoSteal = function()
		local report = {
			running = steal.Running == true,
			placeValid = game.PlaceId == tbl.PlaceId,
			mappedVersion = tbl.MappedAt,
			currentVersion = game.PlaceVersion,
			activity = tostring(steal.Activity or "idle"),
			order = tostring(steal.ORDER and steal.ORDER.Status or "unknown"),
		}
		local ok, records = pcall(steal.FieldRecords)
		report.records = 0
		report.slots = 0
		report.forest = 0
		report.missingPositions = 0
		report.remoteError = steal.SnapshotLastError
		report.lastCycleError = steal.LastCycleError
		report.lastCycleErrorAt = steal.LastCycleErrorAt
		report.lastCycleErrorCount = steal.LastCycleErrorCount or 0
		report.speedCap = steal.SpeedCap()
		report.speed = select(2, pcall(steal.Speed))
		report.teleportAllowed = steal.TSBoleh()
		report.teleportEnabled = steal.TSOn()
		local carry = tbl.NET.Get("EggWorld", "AskFieldEggCarry")
		report.carryRemote = carry ~= nil and carry:IsA("RemoteFunction")
		if ok and type(records) == "table" then
			for _, rec in pairs(records) do
				if type(rec) == "table" and rec.Uid ~= nil then
					report.records += 1
					if tostring(rec.State) == "Slot" then
						report.slots += 1
						if tostring(rec.AreaId) == "Forest" then report.forest += 1 end
						if typeof(rec.BottomCFrame) ~= "CFrame" and not fn7(tostring(rec.Uid), nil) then
							report.missingPositions += 1
						end
					end
				end
			end
		else
			report.error = "Egg records unavailable: " .. tostring(records)
		end
		local found, candidates = pcall(steal.Candidates, true)
		report.eligible = found and type(candidates) == "table" and #candidates or -1
		if not found then report.error = "Candidate scan: " .. tostring(candidates) end
		local counted, reasons = pcall(steal.CandidateReasons)
		report.exclusions = counted and reasons or nil
		if not counted then report.error = "Egg filter diagnosis: " .. tostring(reasons) end
		if not report.placeValid then
			report.hint = "Script targets a different Roblox place"
		elseif report.error then
			report.hint = "Check the error in the executor console"
		elseif report.lastCycleError and report.lastCycleErrorAt and os.clock() - report.lastCycleErrorAt < 10 then
			report.hint = "Recent cycle error: " .. tostring(report.lastCycleError)
		elseif not report.carryRemote then
			report.hint = "Carry remote missing or renamed; game client API may have changed"
		elseif report.records == 0 then
			report.hint = "No egg records; EggState/snapshot may have changed"
		elseif report.slots == 0 then
			report.hint = "No available eggs in slots right now"
		elseif report.eligible == 0 and report.slots == report.forest then
			report.hint = "Only Forest eggs found; the original script intentionally excludes Forest"
		elseif report.eligible == 0 and report.missingPositions > 0 then
			report.hint = "Egg coordinates missing; game's egg data/renders may have changed"
		elseif report.eligible == 0 then
			local reasons = report.exclusions
			if reasons then
				local filtered = (reasons.area or 0) + (reasons.pet or 0) + (reasons.rarity or 0)
					+ (reasons.kg or 0) + (reasons.value or 0)
				if filtered > 0 then
					report.hint = ("%d eggs blocked by filters; tap Reset Auto Steal Filters"):format(filtered)
				elseif reasons.noPosition > 0 then
					report.hint = ("%d eggs lack usable coordinates in this game version"):format(reasons.noPosition)
				elseif reasons.forest > 0 then
					report.hint = ("%d Forest eggs excluded for safe-zone delivery"):format(reasons.forest)
				else
					report.hint = "No eligible egg currently available; see reason counts"
				end
			else
				report.hint = "Check filters, excluded areas, and server snapshot"
			end
		elseif report.running then
			report.hint = "Targets found; inspect status if movement or claiming fails"
		else
			report.hint = "Turn on Auto Steal Eggs"
		end
		return report
	end

	steal.HATCH = { on = false, Done = 0 }
	steal.HATCH.POLL = 2

	steal.HATCH.Tick = function()
		if steal.Senggang() then
			local eggSt = steal.EggSt

			if eggSt then
				if eggSt.IsReadyToHatch then
					if eggSt.BeginHatch then
						if eggSt.FinishHatch then
							for k in pairs(steal.OwnEggs()) do
								if steal.HATCH.on then
									local ok, result = pcall(eggSt.IsReadyToHatch, k)

									if ok and result then
										local ok2, result2 = pcall(eggSt.BeginHatch, k)

										if ok2 and result2 ~= false then
											pcall(eggSt.FinishHatch, k)
											steal.HATCH.Done = steal.HATCH.Done + 1
										end
									end

									continue
								end

								return
							end

							return
						end

						return
					end

					return
				end

				return
			end

			return
		end
	end

	steal.HATCH.Start = function()
		if steal.HATCH.on then
			return
		end
		steal.HATCH.on = true
		tbl.LOG.info("HATCH", "aktif")

		task.spawn(function()
			while steal.HATCH.on do
				if tbl.Alive then
					steal.HATCH.Tick()
					task.wait(steal.HATCH.POLL)
					continue
				end

				break
			end

			steal.HATCH.on = false
		end)
	end

	steal.HATCH.Stop = function()
		if steal.HATCH.on then
			steal.HATCH.on = false
			tbl.LOG.info("HATCH", ("berhenti - %d telur menetas"):format(steal.HATCH.Done))
			return
		end
	end

	steal.PLACE = { on = false, Placed = 0, gagalRuntun = 0 }
	steal.PLACE.POLL = 3

	steal.PLACE.ModeAll = function()
		local autoPlaceAllEgg = tbl.UIX and tbl.UIX.EGGS and tbl.UIX.EGGS.AutoPlaceAllEgg
		if autoPlaceAllEgg and autoPlaceAllEgg.Get and autoPlaceAllEgg.Get() then
			return true
		end
		return false
	end

	steal.PLACE.ModeSelected = function()
		local autoPlaceSelected = tbl.UIX and tbl.UIX.EGGS and tbl.UIX.EGGS.AutoPlaceSelected
		if autoPlaceSelected and autoPlaceSelected.Get and autoPlaceSelected.Get() then
			return true
		end
		return false
	end

	steal.PLACE.ModeRarity = function()
		local autoPlaceRarity = tbl.UIX and tbl.UIX.EGGS and tbl.UIX.EGGS.AutoPlaceRarity
		if autoPlaceRarity and autoPlaceRarity.Get and autoPlaceRarity.Get() then
			return true
		end
		return false
	end

	steal.PLACE.rarCache = {}

	steal.PLACE.RarityDari = function(arg)
		local v4 = steal.PLACE.rarCache[arg]
		if v4 ~= nil then
			return v4
		end
		local v5 = asset(arg)
		local v6 = tostring
		local id, v7

		if v5 and v5.Rarity then
			id = v5.Rarity._id or v5.Rarity.Rank or "Unknown"
		else
			id = "Unknown"
			v7 = v6(id)
			steal.PLACE.rarCache[arg] = v7
			return v7
		end

		v7 = v6(id)
		steal.PLACE.rarCache[arg] = v7
		return v7
	end

	steal.PLACE.ModeRift = function()
		if steal.RIFT.Prioritas then
			return true
		end
		return false
	end

	steal.DiSafeZone = function()
		local v4 = fn2()

		if v4 then
			local position = v4.Position

			if not (steal.GATE_X < position.X) then
				if not (position.Y <= steal.GATE_BAWAH) then
					return not (steal.RUANG and steal.RUANG.DiDalam and steal.RUANG.DiDalam())
				end
				return false
			end

			return false
		end

		return false
	end

	steal.PLACE.Boleh = function()
		if steal.DiSafeZone() then
			if steal.Running and not steal.NoMatch() then
				return false
			end
			return true
		end

		return false
	end

	steal.PLACE.Tick = function()
		local now = os.clock()

		if not (now < steal.PEN.remAt) then
			if steal.PLACE.Boleh() then
				local fn14 = nil

				if not steal.PLACE.ModeAll() then
					local petNamesAutoPlace = tbl.UIX and tbl.UIX.EGGS and tbl.UIX.EGGS.PetNamesAutoPlace
					local flag2 = steal.PLACE.ModeSelected() and petNamesAutoPlace and petNamesAutoPlace.Any and petNamesAutoPlace.Has and petNamesAutoPlace.Any() and true or false
					local rarityAutoPlace = tbl.UIX and tbl.UIX.EGGS and tbl.UIX.EGGS.RarityAutoPlace
					local flag3 = steal.PLACE.ModeRarity() and rarityAutoPlace and rarityAutoPlace.Any and rarityAutoPlace.Has and rarityAutoPlace.Any() and true or false
					local v4 = steal.PLACE.ModeRift()
					if not flag2 and not flag3 and not v4 then
						return
					end

					fn14 = function(arg)
						if flag2 and petNamesAutoPlace.Has(arg) then
							return true
						end
						local v5 = flag3
						if v5 and rarityAutoPlace.Has(steal.PLACE.RarityDari(arg)) then
							return true
						end

						if v4 then
							local v6 = steal.RIFT.Resep(arg)
							if v6 then
								return v6
							end
						end

						return false
					end
				end

				local tbl2 = {}

				for _, v4 in ipairs(steal.Unplaced(fn14)) do
					local v5 = steal.PEN.gagalAt[v4]

					if v5 then
						if not (v5 <= now) then
							continue
						end
					elseif not (now >= 0) then
						continue
					end

					tbl2[#tbl2 + 1] = v4
				end

				if #tbl2 ~= 0 then
					if steal.HeldUid() then
						return
					end
					steal.PLACE.sibuk = true
					local v4 = pcall

					local function fn15()
						if steal.TM.NaikPasti() then
							steal.TM.DoffPasti(2)
						end

						steal.PLACE.Batch(tbl2)
					end

					local v5, v6 = v4(fn15)
					steal.PLACE.sibuk = false
					if v5 then
						return
					end
					tbl.LOG.warn("PLACE", "batch: " .. tostring(v6))
					return
				end

				return
			end

			return
		end
	end

	steal.PLACE.Batch = function(arg)
		for _, v4 in ipairs(arg) do
			if steal.PLACE.on then
				if steal.PLACE.Boleh() then
					local v5, v6 = steal.PEN.Place(v4)

					if v5 then
						steal.PLACE.Placed = steal.PLACE.Placed + 1
						steal.PLACE.gagalRuntun = 0
						continue
					end

					steal.PLACE.gagalRuntun = (steal.PLACE.gagalRuntun or 0) + 1
					if not (steal.PLACE.gagalRuntun >= 3) then
						return
					end
					steal.PEN.remAt = os.clock() + 300
					steal.PLACE.gagalRuntun = 0
					tbl.LOG.warn("PLACE", ("tanam gagal 3x beruntun (%s) - berhenti 300 detik"):format(tostring(v6)))
					return
				end

				return
			end

			return
		end
	end

	steal.PLACE.Start = function()
		if steal.PLACE.on then
			return
		end
		steal.PLACE.on = true
		tbl.LOG.info("PLACE", "aktif")

		task.spawn(function()
			while steal.PLACE.on do
				if tbl.Alive then
					steal.PLACE.Tick()
					task.wait(steal.PLACE.POLL)
					continue
				end

				break
			end

			steal.PLACE.on = false
		end)
	end

	steal.PLACE.Sync = function()
		if steal.PLACE.ModeAll() or steal.PLACE.ModeSelected() or steal.PLACE.ModeRarity() or steal.PLACE.ModeRift() then
			steal.PLACE.Start()
			return
		end

		if steal.PLACE.on then
			steal.PLACE.on = false
			tbl.LOG.info("PLACE", ("berhenti - %d telur ditanam"):format(steal.PLACE.Placed))
			return
		end
	end

	local sell = {}
	sell.Eggs = 0
	sell.Pets = 0
	sell.Busy = false
	steal.SELL = sell
end

steal.SELL.PACE = 0.12
steal.SELL.PET_BACKOFF = 8
steal.SELL.POLL = 5
local fn14

do
	local function fn15(arg, arg2, arg3)
		return { AssetCategory = arg, AssetScale = tonumber(arg2) or 1, Mutations = arg3 }
	end

	local function fn16(arg)
		local sell = tbl.UIX and tbl.UIX.SELL and tbl.UIX.SELL[arg]

		if sell then
			if sell.Get then
				return steal.Num(sell.Get())
			end
			return 0
		end

		return 0
	end

	local function fn17(arg, arg2, arg3)
		if arg2 <= 0 and arg3 <= 0 then
			return false
		end

		if arg2 > 0 then
			local v4 = steal.ValueOf(arg)
			if type(v4) ~= "number" then
				return false
			end

			if not (v4 > 0) then
				return false
			end

			if arg2 <= v4 then
				return false
			end
		end

		if arg3 > 0 then
			local v4 = steal.WeightKgOf(arg)
			if type(v4) ~= "number" then
				return false
			end

			if not (v4 > 0) then
				return false
			end

			if arg3 <= v4 then
				return false
			end
		end

		return true
	end

	steal.SELL.EggTargets = function()
		local EggValue = fn16("EggValue")
		local EggKG = fn16("EggKG")
		local tbl2 = {}

		for k, v4 in pairs(steal.OwnEggs()) do
			if type(v4) == "table" and v4.Placement == nil and fn17(fn15(tostring(v4.AssetCategory), v4.AssetScale, v4.Mutations), EggValue, EggKG) then
				tbl2[#tbl2 + 1] = tostring(k)
			end
		end

		return tbl2
	end

	steal.SELL.Aman = function(arg)
		if steal.HeldUid() then
			return false
		end

		if arg then
			return true
		end
		return steal.Senggang()
	end

	steal.SELL.SellEggs = function(arg)
		local EggWorld = tbl.NET.Get("EggWorld", "AskWearTool")
		local PetSatchel = tbl.NET.Get("PetSatchel", "SellPet")

		if EggWorld then
			if PetSatchel then
				local n2 = 0

				for _, v4 in ipairs(steal.SELL.EggTargets()) do
					if steal.SELL.Busy then
						if steal.SELL.Aman(arg) then
							if pcall(EggWorld.InvokeServer, EggWorld, v4) then
								pcall(PetSatchel.FireServer, PetSatchel, { v4 })
								n2 += 1
							end

							task.wait(steal.SELL.PACE)
							continue
						end

						break
					end

					break
				end

				steal.SELL.Eggs = steal.SELL.Eggs + n2
				return n2
			end

			return 0, "remote jual telur tidak ada"
		end

		return 0, "remote jual telur tidak ada"
	end

	fn14 = function()
		local ok, result = pcall(function()
			return require(tbl.SV.ReplicatedStorage.Shared.Save)
		end)

		if ok then
			if type(result) ~= "table" then
				return {}
			end

			for _, v4 in ipairs({ "Get", "ReadUnguarded", "Peek" }) do
				if type(result[v4]) ~= "function" then
					continue
				end
				local ok2, result2 = pcall(result[v4])

				if ok2 and type(result2) == "table" then
					local inventory = result2.Inventory
					if inventory then
						return inventory
					end
					return {}
				end
			end

			return {}
		end

		return {}
	end

	steal.SELL.PetSplit = function()
		local PetValue = fn16("PetValue")
		local PetKG = fn16("PetKG")
		local petNames = tbl.UIX and tbl.UIX.SELL and tbl.UIX.SELL.PetNames
		local fn18 = nil

		if petNames and petNames.Any and petNames.Has and petNames.Any() then
			fn18 = function(arg, arg2)
				return petNames.Has(arg2)
			end
		end

		local tbl2 = {}
		local tbl3 = {}

		for k, v4 in pairs(fn14()) do
			if type(v4) == "table" then
				local tbl4 = { uid = tostring(k), fav = v4.IsFavorite == true }
				local str2 = tostring(v4.Category)
				local v5 = fn15(str2, v4.Scale, v4.Mutations)

				if v4.InFuse ~= true and (not fn18 or fn18(439910052, str2)) then
					if fn17(v5, PetValue, PetKG) then
						tbl2[#tbl2 + 1] = tbl4
					else
						tbl3[#tbl3 + 1] = tbl4
					end
				else
					tbl3[#tbl3 + 1] = tbl4
				end
			end
		end

		return tbl2, tbl3
	end

	steal.SELL.SellPets = function()
		local now = os.clock()
		local nextPet = steal.SELL.NextPet

		if nextPet then
			if now < nextPet then
				return 0, "menunggu jeda"
			end
		elseif now < 0 then
			return 0, "menunggu jeda"
		end

		local v4, v5 = steal.SELL.PetSplit()

		if #v4 ~= 0 then
			local PetSatchel = tbl.NET.Get("PetSatchel", "WriteFavourite")
			local PetSatchel2 = tbl.NET.Get("PetSatchel", "SellEveryPet")

			if PetSatchel then
				if PetSatchel2 then
					local tbl2 = {}

					for _, v6 in ipairs(v5) do
						if not v6.fav then
							pcall(PetSatchel.FireServer, PetSatchel, v6.uid, true)
							tbl2[#tbl2 + 1] = v6.uid
							task.wait(0.03)
						end
					end

					task.wait(0.4)
					local v6, v7 = steal.SELL.PetSplit()
					local flag2 = true

					for _, v8 in ipairs(v7) do
						if v8.fav then
							continue
						end
						flag2 = false
						break
					end

					if flag2 then
						pcall(PetSatchel2.FireServer, PetSatchel2)
						task.wait(0.5)

						for _, v8 in ipairs(tbl2) do
							pcall(PetSatchel.FireServer, PetSatchel, v8, false)
							task.wait(0.03)
						end

						steal.SELL.NextPet = os.clock() + steal.SELL.PET_BACKOFF
						steal.SELL.Pets = steal.SELL.Pets + #v4
						return #v4
					end

					for _, v8 in ipairs(tbl2) do
						pcall(PetSatchel.FireServer, PetSatchel, v8, false)
						task.wait(0.03)
					end

					tbl.LOG.warn("SELL", "dibatalkan - ada pet simpanan yang belum ter-favorite")
					return 0, "penjaga membatalkan"
				end

				return 0, "remote jual pet tidak ada"
			end

			return 0, "remote jual pet tidak ada"
		end

		return 0
	end

	steal.SELL.Bag = function()
		local n2 = 0
		local n3 = 0

		for _, v4 in pairs(steal.OwnEggs()) do
			if type(v4) == "table" and v4.Placement == nil then
				n2 += 1
				n3 += steal.ValueOf(fn15(tostring(v4.AssetCategory), v4.AssetScale, v4.Mutations))
			end
		end

		local n4 = 0
		local n5 = 0

		for _, v4 in pairs(fn14()) do
			if type(v4) == "table" then
				n4 += 1
				n5 += steal.ValueOf(fn15(tostring(v4.Category), v4.Scale, v4.Mutations))
			end
		end

		return n2, n3, n4, n5
	end
end

steal.SELL.Once = function(arg, arg2, arg3)
	if steal.SELL.Busy then
		return
	end
	steal.SELL.Busy = true
	local n2 = 0

	if arg then
		n2 = steal.SELL.SellEggs(arg3)
	end

	local n3 = 0

	if arg2 then
		n3 = steal.SELL.SellPets()
	end

	steal.SELL.Busy = false
	tbl.LOG.info("SELL", ("terjual %d telur, %d pet"):format(n2 or 0, n3 or 0))
	return n2, n3
end

steal.SELL.AutoOn = function(arg)
	local sell = tbl.UIX and tbl.UIX.SELL and tbl.UIX.SELL[arg]
	if sell and sell.Get and sell.Get() then
		return true
	end
	return false
end

steal.SELL.AutoSync = function()
	if steal.SELL.AutoOn("AutoEgg") or steal.SELL.AutoOn("AutoPet") then
		if not steal.SELL.auto then
			steal.SELL.auto = true
			tbl.LOG.info("SELL", "auto-sell aktif")

			local function fn15()
				while steal.SELL.auto do
					if tbl.Alive then
						steal.SELL.Once(steal.SELL.AutoOn("AutoEgg"), steal.SELL.AutoOn("AutoPet"))
						task.wait(steal.SELL.POLL)
						continue
					end

					break
				end

				steal.SELL.auto = false
			end

			task.spawn(fn15)
			return
		end
	elseif steal.SELL.auto then
		steal.SELL.auto = false
		tbl.LOG.info("SELL", ("auto-sell berhenti - total %d telur, %d pet"):format(steal.SELL.Eggs, steal.SELL.Pets))
		return
	end
end

tbl.ST.Trove:Add(steal.HATCH.Stop)

tbl.ST.Trove:Add(function()
	steal.SELL.auto = false
end)

do
end

tbl.ST.Trove:Add(function()
	steal.PLACE.on = false
end)

tbl.ST.Trove:Add(function()
	steal.PROMPT.On()
end)

tbl.ST.Trove:Add(function()
	steal.BANNER.On()
end)

tbl.ST.Trove:Add(function()
	steal.SEMBUNYI.Lepas()
end)

tbl.ST.Trove:Add(function()
	for _, child in ipairs(v:GetChildren()) do
		if child:IsA("BasePart") and child.Name:match("^__MTPad") then
			pcall(function()
				child:Destroy()
			end)
		end
	end
end)

tbl.ST.Trove:Add(function()
	steal.POPUP.On()
end)

steal.MUT = { on = false, Status = "idle", Jadi = 0, Dipakai = 0, Tolak = 0 }
steal.MUT.POLL = 1.5

do
	steal.MUT.DEKAT = 18

	steal.MUT.Punya = function()
		local tbl2 = {}

		for _, v4 in ipairs({ localPlayer.Character, localPlayer:FindFirstChild("Backpack") }) do
			for _, v5 in ipairs(v4 and v4:GetChildren() or {}) do
				if v5:IsA("Tool") and v5:GetAttribute("ItemType") == "MutationConsumable" then
					tbl2[#tbl2 + 1] = {
						id = tostring(v5:GetAttribute("MutationId") or "?"),
						tool = v5,
						sisa = tonumber(v5:GetAttribute("Uses")) or 0,
						nama = v5.Name:gsub("%s*%[X%d+%]%s*$", ""),
					}
				end
			end
		end

		local sort = table.sort

		local function fn15(arg, arg2)
			return arg.id < arg2.id
		end

		sort(tbl2, fn15)
		return tbl2
	end

	steal.MUT.rinciCache = {}

	steal.MUT.Rinci = function(arg)
		local v4 = steal.MUT.rinciCache[arg]
		if v4 then
			return v4
		end

		local tbl2 = {
			id = arg,
			label = arg,
			ikon = "",
			skala = 1,
			pct = 10,
			warna = Color3.new(0.78431373834609985, 0.78431373834609985, 0.82352942228317261),
		}

		pcall(function()
			local v5 = fn9(tbl.SV.ReplicatedStorage.Shared.Modules.Mutations.Catalog)
			local v6 = v5 and v5[arg]

			if v6 then
				tbl2.label = tostring(v6.Label or arg)
				tbl2.skala = tonumber(v6.EarningsScalar) or 1

				if typeof(v6.Tint) == "Color3" then
					tbl2.warna = v6.Tint
				end

				if v6.IconAssetId then
					tbl2.ikon = "rbxassetid://" .. tostring(v6.IconAssetId)
					return
				end

				if v6.EggIcon then
					tbl2.ikon = tostring(v6.EggIcon)
					return
				end
			end
		end)

		if arg == "Enchanted" then
			pcall(function()
				local v5 = fn9(tbl.SV.ReplicatedStorage.Shared.Modules.ButterflyCatalog)

				if v5 then
					if v5.Icons and v5.Icons.Essence then
						tbl2.ikon = tostring(v5.Icons.Essence)
					end

					if v5.EssenceName then
						tbl2.label = tostring(v5.EssenceName)
						return
					end
				end
			end)
		end

		pcall(function()
			local flag2 = arg == "Scrambled" and fn9(tbl.SV.ReplicatedStorage.Shared.Flags.ScrambleMutationFlags) or fn9(tbl.SV.ReplicatedStorage.Shared.Flags.BossMasteryFlags)
			local successPercent = flag2 and (flag2.SuccessPercent or flag2.MutationConsumableSuccessPercent)
			if successPercent and successPercent.Get then
				tbl2.pct = tonumber(successPercent:Get()) or tbl2.pct
				return
			end
		end)

		steal.MUT.rinciCache[arg] = tbl2
		return tbl2
	end

	steal.MUT.Telur = function()
		local tbl2 = {}

		for k, v4 in pairs(steal.OwnEggs()) do
			if type(v4) == "table" and v4.Placement ~= nil then
				local tbl3 = {}

				for _, v5 in pairs(type(v4.Mutations) == "table" and v4.Mutations or {}) do
					local str2 = tostring(v5)

					if v5 and str2 ~= "None" and str2 ~= "" then
						tbl3[#tbl3 + 1] = str2
					end
				end

				local str2 = tostring(v4.AssetCategory or "Egg")
				local ok, result = pcall(steal.WeightKgOf, v4)
				local ok2, result2 = pcall(steal.ValueOf, v4)

				tbl2[#tbl2 + 1] = {
					uid = tostring(k),
					cat = str2,
					skala = tonumber(v4.AssetScale) or 1,
					mutasi = tbl3,
					rarity = steal.PLACE.RarityDari(str2),
					kg = ok and type(result) == "number" and result or nil,
					nilai = ok2 and type(result2) == "number" and result2 > 0 and result2 or nil,
				}
			end
		end

		local function fn15(arg, arg2)
			if #arg.mutasi ~= #arg2.mutasi then
				return #arg.mutasi < #arg2.mutasi
			end
			return arg.cat < arg2.cat
		end

		table.sort(tbl2, fn15)
		return tbl2
	end

	steal.MUT.Pilihan = function()
		local mutJenis = tbl.UIX and tbl.UIX.MUTASI and tbl.UIX.MUTASI.MutJenis
		local value

		if mutJenis and mutJenis.Get then
			value = select(2, pcall(mutJenis.Get)) or nil
		else
			value = nil
		end

		local tbl2 = {}
		if type(value) ~= "table" then
			return tbl2
		end

		for k, v4 in pairs(value) do
			if v4 then
				tbl2[tostring(k)] = true
			end
		end

		return tbl2
	end

	steal.MUT.TelurPilihan = function()
		local mutTelur = tbl.UIX and tbl.UIX.MUTASI and tbl.UIX.MUTASI.MutTelur
		local value

		if mutTelur and mutTelur.Get then
			value = select(2, pcall(mutTelur.Get)) or nil
		else
			value = nil
		end

		local tbl2 = {}
		if type(value) ~= "table" then
			return tbl2
		end

		for k, v4 in pairs(value) do
			if v4 then
				tbl2[tostring(k)] = true
			end
		end

		return tbl2
	end

	steal.MUT.Pakai = function(arg, arg2)
		local humanoid = localPlayer.Character and localPlayer.Character:FindFirstChildOfClass("Humanoid")
		if not humanoid then
			return false, "no character"
		end

		if arg.tool then
			if arg.tool.Parent then
				if arg.tool.Parent ~= localPlayer.Character then
					local function fn15()
						humanoid:EquipTool(arg.tool)
					end

					pcall(fn15)
					runService.Heartbeat:Wait()
					runService.Heartbeat:Wait()
				end

				local BossMastery = tbl.NET.Get("BossMastery", "AskUseMutationConsumable")

				if BossMastery then
					local v4 = table.pack(pcall(BossMastery.InvokeServer, BossMastery, arg2))

					if v4[1] then
						local v5 = v4[2]
						if type(v5) ~= "table" then
							return false, "balasan tidak terbaca"
						end

						if v5.Success then
							return true, nil, v5.Mutated == true, tostring(v5.MutationId or arg.id)
						end
						return false, tostring(v5.Message or "ditolak")
					end

					return false, tostring(v4[2])
				end

				return false, "remote AskUseMutationConsumable tidak ada"
			end

			return false, "consumable hilang"
		end

		return false, "consumable hilang"
	end

	steal.MUT.Tick = function()
		if steal.HeldUid() then
			steal.MUT.Status = "waiting - carrying an egg"
			return
		end
		local v4 = steal.MUT.Pilihan()
		local flag2 = next(v4) ~= nil
		local tbl2 = {}
		local n2 = 979568

		for _, v5 in ipairs(steal.MUT.Punya()) do
			if flag2 then
				n2 = v4[v5.id]
			end

			if n2 then
				n2 = v5.sisa

				if n2 > 0 then
					n2 = #tbl2 + 1
					tbl2[n2] = v5
				end
			end
		end

		if #tbl2 ~= 0 then
			local v5 = steal.MUT.TelurPilihan()
			local flag3 = next(v5) ~= nil
			local v6 = nil

			for _, v7 in ipairs(steal.MUT.Telur()) do
				if flag3 then
					if v5[v7.uid] then
						v6 = v7
						break
					end

					if v5[v7.cat] then
						v6 = v7
						break
					end
					continue
				end

				v6 = v7
				break
			end

			if v6 then
				local v7 = tbl2[1]
				local v8 = steal.MUT.Rinci(v7.id)
				steal.MUT.Status = ("using %s on %s"):format(v8.label, v6.cat)
				local v9, v10, v11, v12 = steal.MUT.Pakai(v7, v6.uid)

				if v9 then
					steal.MUT.Dipakai = steal.MUT.Dipakai + 1

					if v11 then
						steal.MUT.Jadi = steal.MUT.Jadi + 1
						steal.MUT.Status = ("%s applied to %s!"):format(tostring(v12), v6.cat)
						tbl.LOG.info("MUT", ("%s JADI di %s"):format(tostring(v12), v6.cat))

						if tbl.UIX and tbl.UIX.Pita then
							tbl.UIX.Pita(("Mutation %s applied to %s!"):format(tostring(v12), v6.cat), 4)
						end

						return
					end

					steal.MUT.Status = ("no mutation this time (%d%% chance)"):format(v8.pct)
					return
				end

				steal.MUT.Tolak = steal.MUT.Tolak + 1
				steal.MUT.Status = "rejected: " .. tostring(v10)
				tbl.LOG.warn("MUT", "ditolak: " .. tostring(v10))
				return
			end

			steal.MUT.Status = flag3 and "no planted egg matches the selection" or "no planted egg"
			return
		end

		steal.MUT.Status = flag2 and "no consumable of the chosen type" or "no mutation consumable left"
	end

	steal.MUT.Start = function()
		if steal.MUT.on then
			return
		end
		steal.MUT.on = true
		tbl.LOG.info("MUT", "auto mutation aktif")

		task.spawn(function()
			while steal.MUT.on do
				if tbl.Alive then
					local ok, result = pcall(steal.MUT.Tick)

					if not ok then
						tbl.LOG.warn("MUT", tostring(result))
					end

					task.wait(steal.MUT.POLL)
					continue
				end

				break
			end

			steal.MUT.on = false
		end)
	end

	steal.MUT.Stop = function()
		if steal.MUT.on then
			steal.MUT.on = false
			steal.MUT.Status = "idle"
			tbl.LOG.info("MUT", ("berhenti - %d dipakai, %d jadi, %d ditolak"):format(steal.MUT.Dipakai, steal.MUT.Jadi, steal.MUT.Tolak))
			return
		end
	end

	tbl.ST.Trove:Add(function()
		steal.MUT.on = false
	end)

	local esp = {}
	esp.on = false
	esp.Cards = {}
	steal.ESP = esp
end

steal.ESP.POLL = 2.5
steal.ESP.LIFT = Vector3.new(0, 3, 0)

steal.ESP.WARNA = {
	Eternal = { Color3.new(1, 0.11764705926179886, 0.94117647409439087), Color3.new(0, 0, 0) },
	Secret = {
		Color3.new(0.13725490868091583, 0.13725490868091583, 0.15686275064945221),
		Color3.new(0.94117647409439087, 0.94117647409439087, 0.98039215803146362),
	},
	Divine = { Color3.new(1, 0.92156863212585449, 0.078431375324726105), Color3.new(0, 0, 0) },
}

steal.ESP.PUTIH = { Color3.new(1, 1, 1), Color3.new(0, 0, 0) }

do
	local function fn15(arg, arg2)
		local esp = tbl.UIX and tbl.UIX.ESP and tbl.UIX.ESP[arg]

		if esp then
			if esp.Get then
				local v4 = esp.Get()
				if v4 ~= nil then
					return v4
				end
				return arg2
			end

			return arg2
		end

		return arg2
	end

	steal.ESP.Bin = function()
		local currentCamera = v.CurrentCamera

		if currentCamera then
			local bin = steal.ESP.bin
			if bin and bin.Parent == currentCamera then
				return bin
			end
			local folder2 = Instance.new("Folder")
			folder2.Name = "f" .. tostring(math.random(100000, 999999))
			folder2.Parent = currentCamera
			steal.ESP.bin = folder2
			return folder2
		end

		return nil
	end

	steal.ESP.Info = function(arg)
		local str2 = tostring(arg.AssetCategory)
		local v4 = steal.Asset(str2)
		local v5 = steal.RarityIdOf(str2)

		if v4 then
			str2 = tostring(v4.DisplayName)
		end

		if v5 ~= "?" and v5 ~= "Common" and not str2:lower():find(v5:lower(), 1, true) then
			str2 = v5 .. " " .. str2
		end

		for _, v6 in pairs(type(arg.Mutations) == "table" and arg.Mutations or {}) do
			local str3 = tostring(v6)
			if str3 ~= "" and str3 ~= "None" then
				str2 ..= " [" .. str3 .. "]"
				break
			end
		end

		if v4 then
			return str2, tostring(v4.Icon or ""), v5
		end
		return str2, "", v5
	end

	steal.ESP.Paint = function(arg)
		local punyaIkon = fn15("ShowIcon", true) and arg.punyaIkon
		local ShowRarity = fn15("ShowRarity", true)
		local ShowRate = fn15("ShowRate", true)
		local v4 = punyaIkon or ShowRarity or ShowRate
		arg.bb.Enabled = v4

		if v4 then
			local n2, n3

			if ShowRarity then
				if ShowRate then
					if punyaIkon then
						n2 = 195
						n3 = 54
					else
						n2 = 150
						n3 = 54
					end
				else
					n2 = punyaIkon and 175 or 140
					n3 = 32
				end
			elseif ShowRate then
				n2 = punyaIkon and 160 or 110
				n3 = 30
			else
				n2 = 44
				n3 = 44
			end

			arg.bb.Size = UDim2.fromOffset(n2, n3)
			arg.ikon.Visible = punyaIkon
			arg.kolom.Visible = ShowRarity or ShowRate
			arg.kolom.Size = UDim2.new(1, punyaIkon and -50 or 0, 1, 0)
			arg.nama.Visible = ShowRarity
			arg.laju.Visible = ShowRate
			return
		end
	end

	steal.ESP.Card = function(adornee, arg)
		local v4, v5, v6 = steal.ESP.Info(arg)
		local billboardGui = Instance.new("BillboardGui")
		billboardGui.Adornee = adornee
		billboardGui.Size = UDim2.new(0, 195, 0, 54)
		billboardGui.StudsOffsetWorldSpace = Vector3.new(0, 3.2, 0)
		billboardGui.AlwaysOnTop = true
		billboardGui.MaxDistance = tonumber(fn15("MaxDist", 600)) or 600
		billboardGui.ResetOnSpawn = false
		billboardGui.Parent = adornee
		local frame = Instance.new("Frame")
		frame.Size = UDim2.new(1, 0, 1, 0)
		frame.BackgroundColor3 = Color3.new(0.047058824449777603, 0.062745101749897, 0.094117648899555206)
		frame.BackgroundTransparency = 0.22
		frame.BorderSizePixel = 0
		frame.Parent = billboardGui
		local uiCorner = Instance.new("UICorner")
		uiCorner.CornerRadius = UDim.new(0, 8)
		uiCorner.Parent = frame
		local uiStroke = Instance.new("UIStroke")
		uiStroke.Color = Color3.new(0.17647059261798859, 0.23529411852359772, 0.3333333432674408)
		uiStroke.Thickness = 1.2
		uiStroke.Parent = frame
		local uiPadding = Instance.new("UIPadding")
		uiPadding.PaddingLeft = UDim.new(0, 6)
		uiPadding.PaddingRight = UDim.new(0, 8)
		uiPadding.PaddingTop = UDim.new(0, 5)
		uiPadding.PaddingBottom = UDim.new(0, 5)
		uiPadding.Parent = frame
		local uiListLayout = Instance.new("UIListLayout")
		uiListLayout.FillDirection = Enum.FillDirection.Horizontal
		uiListLayout.VerticalAlignment = Enum.VerticalAlignment.Center
		uiListLayout.Padding = UDim.new(0, 8)
		uiListLayout.Parent = frame
		local frame2 = Instance.new("Frame")
		frame2.Size = UDim2.new(0, 42, 0, 42)
		frame2.BackgroundColor3 = Color3.new(0.070588238537311554, 0.094117648899555206, 0.14117647707462311)
		frame2.BorderSizePixel = 0
		frame2.Parent = frame
		local uiCorner2 = Instance.new("UICorner")
		uiCorner2.CornerRadius = UDim.new(0, 6)
		uiCorner2.Parent = frame2
		local imageLabel = Instance.new("ImageLabel")
		imageLabel.Size = UDim2.new(1, 0, 1, 0)
		imageLabel.BackgroundTransparency = 1
		imageLabel.ScaleType = Enum.ScaleType.Fit
		imageLabel.Image = v5
		imageLabel.Parent = frame2
		local frame3 = Instance.new("Frame")
		frame3.Size = UDim2.new(1, -50, 1, 0)
		frame3.BackgroundTransparency = 1
		frame3.Parent = frame
		local uiListLayout2 = Instance.new("UIListLayout")
		uiListLayout2.FillDirection = Enum.FillDirection.Vertical
		uiListLayout2.VerticalAlignment = Enum.VerticalAlignment.Center
		uiListLayout2.Padding = UDim.new(0, 2)
		uiListLayout2.Parent = frame3
		local putih = steal.ESP.WARNA[v6] or steal.ESP.PUTIH
		local textLabel = Instance.new("TextLabel")
		textLabel.Size = UDim2.new(1, 0, 0, 18)
		textLabel.BackgroundTransparency = 1
		textLabel.FontFace = Font.fromEnum(Enum.Font.GothamBold)
		textLabel.TextSize = 13.5
		textLabel.TextXAlignment = Enum.TextXAlignment.Left
		textLabel.TextTruncate = Enum.TextTruncate.AtEnd
		textLabel.TextColor3 = putih[1]
		textLabel.Text = v4
		textLabel.Parent = frame3
		local uiStroke2 = Instance.new("UIStroke")
		uiStroke2.Color = putih[2]
		uiStroke2.Thickness = 1
		uiStroke2.Parent = textLabel
		local textLabel2 = Instance.new("TextLabel")
		textLabel2.Size = UDim2.new(1, 0, 0, 15)
		textLabel2.BackgroundTransparency = 1
		textLabel2.FontFace = Font.fromEnum(Enum.Font.GothamBold)
		textLabel2.TextSize = 13
		textLabel2.TextXAlignment = Enum.TextXAlignment.Left
		textLabel2.TextColor3 = Color3.new(0.47058823704719543, 0.94117647409439087, 0.62745100259780884)
		textLabel2.Text = steal.Duit(steal.ValueOf(arg)) .. "/sec"
		textLabel2.Parent = frame3
		local uiStroke3 = Instance.new("UIStroke")
		uiStroke3.Color = Color3.new(0, 0, 0)
		uiStroke3.Thickness = 1
		uiStroke3.Parent = textLabel2
		local tbl2 = { part = adornee, bb = billboardGui, ikon = frame2, kolom = frame3, nama = textLabel, laju = textLabel2, punyaIkon = v5 ~= "" }
		steal.ESP.Paint(tbl2)
		return tbl2
	end

	local function fn16(parent, arg, cFrame, arg2, maxDistance)
		local v4 = steal.ESP.Cards[arg]

		if v4 and v4.part.Parent then
			v4.part.CFrame = cFrame
			v4.bb.MaxDistance = maxDistance
			v4.laju.Text = steal.Duit(steal.ValueOf(arg2)) .. "/sec"
			return
		end

		local part = Instance.new("Part")
		part.Size = Vector3.new(1.5, 1.5, 1.5)
		part.Transparency = 1
		part.Anchored = true
		part.CanCollide = false
		part.CanQuery = false
		part.CanTouch = false
		part.CFrame = cFrame
		part.Parent = parent
		steal.ESP.Cards[arg] = steal.ESP.Card(part, arg2)
	end

	steal.ESP.Sync = function()
		if steal.ESP.on then
			local v4 = steal.ESP.Bin()

			if v4 then
				local MyPen = fn15("MyPen", false)
				local OtherPen = fn15("OtherPen", false)
				local n2 = tonumber(fn15("MaxDist", 600)) or 600
				local tbl2 = {}
				local placedEggRenders = v:FindFirstChild("PlacedEggRenders")

				for _, player in ipairs(tbl.SV.Players:GetPlayers()) do
					local flag2 = player.UserId == localPlayer.UserId

					if not flag2 or not MyPen then
						if flag2 then
							continue
						end

						if not OtherPen then
							continue
						end
					end

					local v5 = steal.PlotOf(player)

					if v5 then
						for k, v6 in pairs(steal.OwnerEggs(player.UserId)) do
							if type(v6) == "table" then
								local placement = v6.Placement

								if placement and typeof(placement.LocalCFrame) == "CFrame" then
									local str2 = tostring(player.UserId) .. "_" .. tostring(k)
									tbl2[str2] = true
									local n3 = v5.CFrame * placement.LocalCFrame + steal.ESP.LIFT
									local v7 = placedEggRenders and placedEggRenders:FindFirstChild(str2)
									local hitbox = v7 and (v7:FindFirstChild("Hitbox") or v7.PrimaryPart)

									if hitbox then
										n3 = CFrame.new(hitbox.Position + Vector3.new(0, hitbox.Size.Y * 0.5 + 1.5, 0))
									end

									fn16(v4, str2, n3, v6, n2)
								end
							end
						end
					end
				end

				if fn15("AreaEgg", false) then
					local areaEggSlotsClient = v:FindFirstChild("AreaEggSlotsClient")
					local areaRarity = tbl.UIX and tbl.UIX.ESP and tbl.UIX.ESP.AreaRarity
					local has

					if areaRarity and areaRarity.Any and areaRarity.Has and areaRarity.Any() then
						has = areaRarity.Has or nil
					else
						has = nil
					end

					for _, v5 in pairs(steal.FieldRecords()) do
						if tostring(v5.State) == "Slot" and typeof(v5.BottomCFrame) == "CFrame" and (not has or has(steal.RarityIdOf(tostring(v5.AssetCategory)))) then
							local str2 = tostring(v5.Uid)
							local str3 = "area_" .. str2
							tbl2[str3] = true
							local n3 = v5.BottomCFrame + steal.ESP.LIFT
							local v6 = areaEggSlotsClient and areaEggSlotsClient:FindFirstChild(str2)
							local hitbox = v6 and (v6:FindFirstChild("Hitbox") or v6.PrimaryPart)

							if hitbox then
								n3 = CFrame.new(hitbox.Position + Vector3.new(0, hitbox.Size.Y * 0.5 + 1.5, 0))
							end

							fn16(v4, str3, n3, v5, n2)
						end
					end
				end

				for k, card in pairs(steal.ESP.Cards) do
					if not tbl2[k] then
						local function fn17()
							card.part:Destroy()
						end

						pcall(fn17)
						steal.ESP.Cards[k] = nil
					end
				end

				return
			end

			return
		end
	end

	steal.ESP.Repaint = function()
		local maxDistance = tonumber(fn15("MaxDist", 600)) or 600

		for _, card in pairs(steal.ESP.Cards) do
			if card.bb.Parent then
				card.bb.MaxDistance = maxDistance
				steal.ESP.Paint(card)
			end
		end
	end

	steal.ESP.Start = function()
		if steal.ESP.on then
			return
		end
		steal.ESP.on = true
		tbl.LOG.info("ESP", "aktif")

		task.spawn(function()
			while steal.ESP.on do
				if tbl.Alive then
					steal.ESP.Sync()
					task.wait(steal.ESP.POLL)
					continue
				end

				break
			end

			steal.ESP.on = false
		end)
	end

	steal.ESP.Stop = function()
		if not steal.ESP.on and not steal.ESP.bin then
			return
		end
		steal.ESP.on = false
		table.clear(steal.ESP.Cards)

		if steal.ESP.bin then
			pcall(function()
				steal.ESP.bin:Destroy()
			end)

			steal.ESP.bin = nil
		end

		tbl.LOG.info("ESP", "berhenti")
	end

	steal.ESP.Apply = function()
		if not fn15("MyPen", false) and not fn15("OtherPen", false) and not fn15("AreaEgg", false) then
			steal.ESP.Stop()
			return
		end

		if steal.ESP.on then
			steal.ESP.Sync()
			steal.ESP.Repaint()
			return
		end

		steal.ESP.Start()
	end
end

tbl.ST.Trove:Add(steal.ESP.Stop)

steal.Roam = function()
	fn4(steal.TM.on and "waiting for eligible eggs - treadmill" or "waiting for eligible eggs (check filters)")

	while steal.Running do
		if steal.ORDER.Giliran("auto_steal") or steal.ORDER.Nganggur() then
			if steal.WallStandby() then
				if not steal.Running then
					return {}
				end
				fn4(steal.TM.on and "wall open - focusing treadmill" or "wall open")
			end

			if #steal.Candidates(true) > 0 then
				local v4 = steal.Candidates()

				if #v4 > 0 then
					fn4(("egg match found - %d candidate(s)"):format(#v4))
					if steal.TM.on or steal.TM.NaikPasti() then
						steal.TM.DoffPasti(3)
						return v4
					end
					return v4
				end
			end

			if steal.SCR.Siap() and os.clock() >= (steal.SCR.jedaSesi or 0) then
				local function fn15()
					local running = steal.Running
					local flag2 = not running
					if running then
						return #steal.Candidates(true) > 0
					end
					return flag2
				end

				steal.SCR.Sesi(fn15)
				steal.SCR.jedaSesi = os.clock() + 8

				if #steal.Candidates(true) > 0 then
					local v4 = steal.Candidates()

					if #v4 > 0 then
						fn4(("egg match found - %d candidate(s)"):format(#v4))
						if steal.TM.on or steal.TM.NaikPasti() then
							steal.TM.DoffPasti(3)
							return v4
						end
						return v4
					end
				end
			elseif steal.TM.on then
				steal.TM.Tick()
			end

			task.wait(0.5)
			continue
		end

		fn4("waiting for turn")
		task.wait(0.5)
	end

	return {}
end

steal.WallPart = function()
	local wallPart = steal.wallPart
	if wallPart and wallPart.Parent then
		return wallPart
	end
	steal.wallPart = nil
	local v4 = steal.Areas()
	local wallStartVisual = v4 and v4:FindFirstChild("WallStartVisual")
	if wallStartVisual and wallStartVisual:IsA("BasePart") then
		steal.wallPart = wallStartVisual
		return wallStartVisual
	end
end

steal.WallSealed = function()
	local v4 = steal.Areas()
	local wallStartCollision = v4 and v4:FindFirstChild("WallStartCollision")

	if wallStartCollision and wallStartCollision:IsA("BasePart") then
		if wallStartCollision.CanCollide then
			return true
		end
		return false
	end

	local v5 = steal.WallPart()
	if v5 and v5.Size.Y > 1 then
		return true
	end

	if steal.wallMod == nil then
		local client = tbl.SV.ReplicatedStorage:FindFirstChild("Client")
		local areaEggResetWall = client and client:FindFirstChild("AreaEggResetWall")
		local flag2 = false
		local wallMod = nil

		if areaEggResetWall then
			flag2, wallMod = pcall(require, areaEggResetWall)
		end

		local v6 = steal

		if not flag2 or not wallMod then
			wallMod = false
		end

		v6.wallMod = wallMod
	end

	local wallMod = steal.wallMod

	if wallMod and wallMod.IsSealed then
		local ok, result = pcall(wallMod.IsSealed)
		if ok and result == true then
			return true
		end
	end

	return false
end

steal.ResetMod = function()
	if steal.resetMod ~= nil then
		if steal.resetMod ~= false then
			local resetMod = steal.resetMod
			if resetMod then
				return resetMod
			end
		end

		return nil
	end

	local replicatedStorage = tbl.SV.ReplicatedStorage
	local areaEggCycle

	if replicatedStorage:FindFirstChild("Shared") then
		local library

		if replicatedStorage.Shared:FindFirstChild("Util") then
			areaEggCycle = replicatedStorage.Shared.Util:FindFirstChild("AreaEggCycle")

			if not areaEggCycle then
				if replicatedStorage:FindFirstChild("Library") then
					library = replicatedStorage.Library

					if library:FindFirstChild("Util") then
						areaEggCycle = replicatedStorage.Library.Util:FindFirstChild("AreaEggResetTimeUtil") or replicatedStorage:FindFirstChild("AreaEggCycle", true) or replicatedStorage:FindFirstChild("AreaEggResetTimeUtil", true)
					else
						areaEggCycle = replicatedStorage:FindFirstChild("AreaEggCycle", true) or replicatedStorage:FindFirstChild("AreaEggResetTimeUtil", true)
					end
				else
					areaEggCycle = replicatedStorage:FindFirstChild("AreaEggCycle", true) or replicatedStorage:FindFirstChild("AreaEggResetTimeUtil", true)
				end
			end
		elseif replicatedStorage:FindFirstChild("Library") then
			library = replicatedStorage.Library

			if library:FindFirstChild("Util") then
				areaEggCycle = replicatedStorage.Library.Util:FindFirstChild("AreaEggResetTimeUtil") or replicatedStorage:FindFirstChild("AreaEggCycle", true) or replicatedStorage:FindFirstChild("AreaEggResetTimeUtil", true)
			else
				areaEggCycle = replicatedStorage:FindFirstChild("AreaEggCycle", true) or replicatedStorage:FindFirstChild("AreaEggResetTimeUtil", true)
			end
		else
			areaEggCycle = replicatedStorage:FindFirstChild("AreaEggCycle", true) or replicatedStorage:FindFirstChild("AreaEggResetTimeUtil", true)
		end
	elseif replicatedStorage:FindFirstChild("Library") then
		if replicatedStorage.Library:FindFirstChild("Util") then
			areaEggCycle = replicatedStorage.Library.Util:FindFirstChild("AreaEggResetTimeUtil") or replicatedStorage:FindFirstChild("AreaEggCycle", true) or replicatedStorage:FindFirstChild("AreaEggResetTimeUtil", true)
		else
			areaEggCycle = replicatedStorage:FindFirstChild("AreaEggCycle", true) or replicatedStorage:FindFirstChild("AreaEggResetTimeUtil", true)
		end
	else
		areaEggCycle = replicatedStorage:FindFirstChild("AreaEggCycle", true) or replicatedStorage:FindFirstChild("AreaEggResetTimeUtil", true)
	end

	local flag2 = false
	local result = nil

	if areaEggCycle then
		flag2, result = pcall(require, areaEggCycle)
	end

	steal.resetMod = flag2 and type(result) == "table" and result or false
	if flag2 and type(result) == "table" and result then
		return result
	end
	return nil
end

steal.NightApproaching = function(arg)
	local n2 = arg or 3
	if steal.WallSealed() then
		return true
	end
	local v4 = steal.Areas()
	local wallStartCollision = v4 and v4:FindFirstChild("WallStartCollision")
	if wallStartCollision and wallStartCollision:IsA("BasePart") and wallStartCollision.CanCollide then
		return true
	end
	local v5 = steal.ResetMod()

	if v5 then
		local serverTimeNow = workspace:GetServerTimeNow()
		local result

		if type(v5.IsNightPhase) == "function" then
			local ok
			ok, result = pcall(v5.IsNightPhase, serverTimeNow)
			if ok and type(result) == "boolean" and result then
				return true
			end
		elseif type(v5.IsNight) == "function" then
			local ok
			ok, result = pcall(v5.IsNight, serverTimeNow)

			if ok and type(result) == "boolean" then
				if result then
					return true
				end

				if result then
					return true
				end
			end
		end

		local n3 = nil

		if type(v5.SecondsUntilPhaseEnd) == "function" then
			local ok, result2 = pcall(v5.SecondsUntilPhaseEnd, serverTimeNow)

			if ok and type(result2) == "number" then
				n3 = result2
			end
		end

		if n3 == nil and type(v5.GetPhaseTimeLeft) == "function" then
			local ok, result2 = pcall(v5.GetPhaseTimeLeft, serverTimeNow)

			if ok and type(result2) == "number" then
				n3 = result2
			end
		end

		if n3 == nil and type(v5.NextResetTime) == "function" then
			local ok, result2 = pcall(v5.NextResetTime, serverTimeNow)

			if ok and type(result2) == "number" then
				n3 = math.max(0, result2 - serverTimeNow)
			end
		end

		if n3 == nil and type(v5.GetNextResetAt) == "function" then
			local ok, result2 = pcall(v5.GetNextResetAt, serverTimeNow)

			if ok and type(result2) == "number" then
				n3 = math.max(0, result2 - serverTimeNow)
				if n3 == nil then
					return false
				end
			elseif n3 == nil then
				return false
			end
		elseif n3 ~= nil then
			if not (n3 <= n2) then
				return false
			else
				return true
			end
		else
			return false
		end

		if n3 <= n2 then
			return true
		end
	end

	return false
end

steal.WallStandby = function()
	if steal.NightApproaching(3) then
		if steal.TM.on or steal.TM.NaikPasti() then
			steal.TM.DoffPasti(2)
		end

		fn4("night approaching / reset active - standing by in safe zone")
		local v4 = fn2()

		if v4 and steal.GATE_X < v4.Position.X then
			fn4("retreating to safe zone before night")
			pcall(steal.GlideRetry, steal.STRIP, 35, 3)
		end

		local flag2 = false

		while true do
			local running = steal.Running or steal.SCR and steal.SCR.Aktif and steal.SCR.Aktif()

			if not running then
				if not steal.WISP then
					break
				end

				if not steal.WISP.Sibuk then
					break
				end
				running = steal.WISP.Sibuk()
			end

			if running then
				if steal.NightApproaching(0) then
					if tbl.Alive then
						local v5 = fn2()

						if v5 then
							local position = v5.Position

							if not (steal.GATE_X < position.X) then
								if (Vector2.new(position.X, position.Z) - Vector2.new(steal.STRIP.X, steal.STRIP.Z)).Magnitude > 4 then
									v5.CFrame = CFrame.new(steal.STRIP.X, position.Y, steal.STRIP.Z)
									v5.AssemblyLinearVelocity = Vector3.zero
								end
							else
								pcall(steal.Glide, steal.STRIP, 35)
							end
						end

						task.wait(0.3)
						flag2 = true
						continue
					end

					break
				end

				break
			end

			break
		end

		return flag2
	end

	return false
end

steal.Deposit = function(arg, arg2)
	local v4 = arg2 or fn12()

	if steal.GlideRetry(steal.STRIP, 45, 4, nil, arg) then
		local n2 = os.clock() + 0.4
		local n3 = 0

		while steal.Running or steal.rampok do
			if not (os.clock() < n2) then
				break
			end
			local v5 = fn2()

			if v5 then
				v5.CFrame = CFrame.new(steal.STRIP.X, v5.Position.Y, steal.STRIP.Z)
				v5.AssemblyLinearVelocity = Vector3.zero
				steal.tulisAt = os.clock()
			end

			runService.Heartbeat:Wait()
			n3 += 1

			if n3 % 3 == 0 and v4 then
				local v6 = fn12()
				if not v6 or not (v4 < v6) then
					continue
				end
				break
			end
		end

		steal.TP.Clear()
		local v5 = fn12()
		local now = os.clock()

		if v4 then
			while v5 do
				if not (v5 <= v4) then
					break
				end

				if not (os.clock() - now < 3) then
					break
				end
				task.wait(0.25)
				v5 = fn12()
			end

			if v5 and v4 < v5 then
				return true
			end
		end

		return false
	end

	return false, "failed to get home"
end

steal.STASH = {
	Jatuh = 0,
	PER_ROW = 10,
	MAX_ROWS = 5,
	SPACING = 4,
	BaseX = 592.02,
	BaseY = 70.7,
	BaseZ = -355.72,
}

steal.STASH.GetBasePos = function()
	local StagingX = tbl.CFG and tbl.CFG.Get and tbl.CFG.Get("StagingX", steal.STASH.BaseX)
	local StagingY = tbl.CFG and tbl.CFG.Get and tbl.CFG.Get("StagingY", steal.STASH.BaseY)
	local StagingZ = tbl.CFG and tbl.CFG.Get and tbl.CFG.Get("StagingZ", steal.STASH.BaseZ)
	local vector = Vector3.new
	local baseX = tonumber(StagingX) or steal.STASH.BaseX
	local baseY = tonumber(StagingY) or steal.STASH.BaseY
	local num = tonumber(StagingZ)
	if num then
		return vector(baseX, baseY, num)
	end
	return vector(baseX, baseY, steal.STASH.BaseZ)
end

steal.STASH.SetStagingHere = function()
	local v4 = fn2()

	if v4 then
		local position = v4.Position

		if tbl.CFG and tbl.CFG.Set then
			tbl.CFG.Set("StagingX", position.X)
			tbl.CFG.Set("StagingY", position.Y)
			tbl.CFG.Set("StagingZ", position.Z)
		end

		steal.STASH.Jatuh = 0
		tbl.LOG.info("STASH", ("titik timbun diubah ke (%.1f, %.1f, %.1f)"):format(position.X, position.Y, position.Z))

		if tbl.UIX and tbl.UIX.Pita then
			tbl.UIX.Pita("Staging spot set to current position! (0/50)", 3)
		end

		return true
	end

	return false
end

steal.STASH.GetDropPos = function()
	local v4 = steal.STASH.GetBasePos()
	local perRow = steal.STASH.PER_ROW
	local n2 = (steal.STASH.Jatuh or 0) % perRow * steal.STASH.MAX_ROWS
	local n3 = math.floor(n2 / perRow)
	local spacing = steal.STASH.SPACING
	return Vector3.new(v4.X + n2 % perRow * spacing, v4.Y, v4.Z - n3 * spacing)
end

steal.STASH.On = function()
	local dropBeforeSafe = tbl.UIX and tbl.UIX.HELP and tbl.UIX.HELP.DropBeforeSafe
	if dropBeforeSafe and dropBeforeSafe.Get and dropBeforeSafe.Get() then
		return true
	end
	return false
end

steal.STASH.Drop = function()
	local EggWorld = tbl.NET.Get("EggWorld", "AskFieldEggDrop")

	if EggWorld then
		steal.ManualDropAt = os.clock()
		local ok = pcall(EggWorld.InvokeServer, EggWorld, { Reason = "PlayerRequest" })

		if ok then
			steal.STASH.Jatuh = steal.STASH.Jatuh + 1
			tbl.LOG.info("STASH", ("telur dijatuhkan di grid slot #%d (total %d)"):format((steal.STASH.Jatuh - 1) % steal.STASH.PER_ROW * steal.STASH.MAX_ROWS + 1, steal.STASH.Jatuh))
			return ok
		end

		return ok
	end

	return false
end

steal.STASH.Leg = function(arg)
	local n2 = steal.STASH.PER_ROW * steal.STASH.MAX_ROWS
	fn4(("dropping egg before safe zone [grid %d/%d]"):format((steal.STASH.Jatuh or 0) % n2 + 1, n2))

	if steal.GlideRetry(steal.STASH.GetDropPos(), 25, 4, nil, arg) then
		task.wait(0.1)
		local v4 = steal.STASH.Drop(arg)
		task.wait(0.3)
		if v4 then
			return "egg dropped before safe zone"
		end
		return "failed to drop egg"
	end

	return "failed to reach drop point"
end

steal.STASH.Deliver = function()
	local EggWorld, v4 = tbl.NET.Invoke("EggWorld", "AskFieldEggSnapshot")
	local records

	if EggWorld and type(v4) == "table" and type(v4.Records) == "table" then
		records = v4.Records or {}
	else
		records = {}
	end

	local v5 = steal.STASH.GetBasePos()
	local tbl2 = {}

	for _, record in ipairs(records) do
		if record.State == "Dropped" and not tostring(record.Uid):find("^FirstArea") then
			local v6 = fn7(record.Uid, record.BottomCFrame and record.BottomCFrame.Position)

			if v6 then
				local magnitude = (v6 - v5).Magnitude

				if magnitude and magnitude <= 65 then
					tbl2[#tbl2 + 1] = { uid = record.Uid, pos = v6, name = record.AssetCategory }
				end
			end
		end
	end

	if #tbl2 == 0 then
		for _, record in ipairs(records) do
			if record.State == "Dropped" and not tostring(record.Uid):find("^FirstArea") then
				local v6 = fn7(record.Uid, record.BottomCFrame and record.BottomCFrame.Position)

				if v6 then
					tbl2[#tbl2 + 1] = { uid = record.Uid, pos = v6, name = record.AssetCategory }
				end
			end
		end
	end

	if #tbl2 ~= 0 then
		if tbl.UIX and tbl.UIX.Pita then
			tbl.UIX.Pita(("Delivering %d stashed eggs..."):format(#tbl2), 3)
		end

		for _, v6 in ipairs(tbl2) do
			if not steal.Running then
				if not tbl.ST then
					break
				end

				if not tbl.ST.Booted then
					break
				end
			end

			fn4(("delivering stashed %s"):format(tostring(v6.name or "egg")))
			steal.GlideRetry(v6.pos, 25, 3)
			task.wait(0.1)
			local v7, v8 = steal.Carry(v6.uid, v6.pos, 5, v6.name)

			if v7 then
				steal.Deposit(v8 or v6.uid)
			end
		end

		steal.STASH.Jatuh = 0
		if tbl.UIX and tbl.UIX.Pita then
			tbl.UIX.Pita("Stash delivery complete!", 3)
			return
		end
		return
	end

	if tbl.UIX and tbl.UIX.Pita then
		tbl.UIX.Pita("No dropped eggs found near staging area", 3)
		return
	end
end

steal.BuangHaram = function()
	local v4 = steal.HeldUid()

	if v4 then
		local v5 = steal.AreaOf(v4)

		if v5 then
			if steal.AREA_HARAM[v5] then
				fn4(("dropping %s egg - never carried to safe zone"):format(v5))
				steal.STASH.Drop(v4)
				task.wait(0.3)
				return true
			end

			return false
		end

		return false
	end

	return false
end

steal.MT = { NAIK = 45, TURUN = 140, TIBA = 8, DEKAT = 6, pad = nil, cx = nil, lantai = 0, ikut = true }

do
	local function fn15(arg, arg2)
		return arg.Size.Y * 0.5 + math.max(arg2.HipHeight, 0.5)
	end

	steal.MT.Mulai = function()
		local mt = steal.MT
		if mt.pad and mt.pad.Parent then
			return mt.pad
		end
		local v4, v5 = fn()

		if v4 then
			if v5 then
				for _, child in ipairs(v:GetChildren()) do
					if child:IsA("BasePart") and child.Name:find("__MTPad", 1, true) then
						local function fn16()
							child:Destroy()
						end

						pcall(fn16)
					end
				end

				local part = Instance.new("Part")
				part.Name = "__MTPad" .. tostring(math.random(1000, 9999))
				part.Anchored = true
				part.CanCollide = true
				part.CanQuery = true
				part.CanTouch = false
				part.CastShadow = false
				part.Transparency = 1
				part.Material = Enum.Material.SmoothPlastic
				part.CustomPhysicalProperties = PhysicalProperties.new(0.7, 2, 0, 100, 1)
				part.Size = Vector3.new(28, 1, 28)
				mt.lantai = v4.Position.Y - fn15(v4, v5) - 0.55
				part.CFrame = CFrame.new(v4.Position.X, mt.lantai, v4.Position.Z)
				part.Parent = v
				mt.pad = part
				mt.ikut = true
				if mt.cx then
					return part
				end
				local raycastParams = RaycastParams.new()
				raycastParams.FilterType = Enum.RaycastFilterType.Exclude
				local postSimulation = runService.PostSimulation
				local connect = postSimulation.Connect

				local function fn16()
					local v6, v7 = fn()

					if v6 then
						if v7 then
							if mt.pad then
								if mt.pad.Parent then
									if mt.ikut then
										raycastParams.FilterDescendantsInstances = { localPlayer.Character, mt.pad, steal.Pad() }
										local n2 = v6.Position.Y - fn15(v6, v7)
										local hit = v:Raycast(Vector3.new(v6.Position.X, n2 + 2, v6.Position.Z), Vector3.new(0, -14, 0), raycastParams)

										if hit then
											mt.lantai = hit.Position.Y - 0.5
										else
											mt.lantai = math.min(mt.lantai, n2 - 0.55)
										end
									end

									mt.pad.CFrame = CFrame.new(v6.Position.X, mt.lantai, v6.Position.Z)
									return
								end

								return
							end

							return
						end

						return
					end
				end

				mt.cx = connect(postSimulation, fn16)
				local trove = tbl.ST.Trove
				local v6 = trove
				local add = trove.Add

				local function fn17()
					pcall(steal.MT.Henti)
				end

				add(v6, fn17)
				return part
			end

			return nil
		end

		return nil
	end

	steal.MT.Henti = function()
		local mt = steal.MT

		if mt.cx then
			pcall(function()
				mt.cx:Disconnect()
			end)

			mt.cx = nil
		end

		if mt.pad then
			pcall(function()
				mt.pad:Destroy()
			end)

			mt.pad = nil
		end

		mt.ikut = false
	end

	steal.MT.Angkat = function(arg, arg2)
		local mt = steal.MT

		if steal.MT.Mulai() then
			mt.ikut = false
			local v4 = fn2()

			if v4 then
				local y = v4.Position.Y
				local now = os.clock()

				while true do
					local n2 = os.clock() - now

					if arg2 then
						if not (n2 < arg2) then
							break
						end
					elseif not (n2 < 4) then
						break
					end

					local result = runService.Heartbeat:Wait()
					local v5 = fn2()

					if v5 then
						if not (arg <= v5.Position.Y - y) then
							mt.lantai = mt.lantai + mt.NAIK * result
							continue
						end
						break
					end

					break
				end

				local v5 = fn2()
				if v5 then
					return v5.Position.Y - y
				end
				return 0
			end

			return 0
		end

		return 0
	end

	local function darat(arg)
		local mt = steal.MT

		if mt.pad then
			if mt.pad.Parent then
				mt.ikut = false
				local raycastParams = RaycastParams.new()
				raycastParams.FilterType = Enum.RaycastFilterType.Exclude
				raycastParams.FilterDescendantsInstances = { localPlayer.Character, mt.pad, steal.Pad() }

				local function fn16()
					local v4 = fn2()

					if v4 then
						local hit = v:Raycast(v4.Position, Vector3.new(0, -900, 0), raycastParams)

						if hit then
							local y = hit.Position.Y
							if y then
								return y
							end
						end

						return nil
					end

					return nil
				end

				local v4 = fn16()
				local now = os.clock()

				if v4 then
					mt.lantai = v4 - 3

					while true do
						local n2 = os.clock() - now

						if arg then
							if not (n2 < arg) then
								break
							end
						elseif not (n2 < 5) then
							break
						end

						runService.Heartbeat:Wait()
						local v5, v6 = fn()

						if v5 then
							if v6 then
								if v6.FloorMaterial ~= Enum.Material.Air then
									break
								end
								local v7 = fn16()

								if v7 then
									mt.lantai = v7 - 3
								end

								continue
							end

							break
						end

						break
					end
				else
					while true do
						local n2 = os.clock() - now

						if arg then
							if not (n2 < arg) then
								break
							end
						elseif not (n2 < 5) then
							break
						end

						local result = runService.Heartbeat:Wait()
						local v5 = fn2()

						if v5 then
							local n3 = fn16() or v5.Position.Y - 5
							if not (mt.lantai <= n3 + 0.6) then
								mt.lantai = math.max(n3 + 0.5, mt.lantai - mt.TURUN * result)
								continue
							end
							break
						end

						break
					end
				end

				mt.ikut = true
				return
			end

			return
		end
	end

	steal.MT.Darat = darat

	steal.MT.KeTinggi = function(arg, arg2)
		local mt = steal.MT

		if steal.MT.Mulai() then
			mt.ikut = false
			local now = os.clock()

			while true do
				local n2 = os.clock() - now

				if arg2 then
					if not (n2 < arg2) then
						return
					end
				elseif not (n2 < 4) then
					return
				end

				local result = runService.Heartbeat:Wait()
				local v4, v5 = fn()

				if v4 and v5 then
					local n3 = arg - fn15(v4, v5) - 0.55 - mt.lantai
					if not (math.abs(n3) <= 0.35) then
						mt.lantai = mt.lantai + (if n3 > 0 then math.min(n3, mt.NAIK * result) else math.max(n3, -mt.TURUN * result))
						continue
					end
					break
				end

				return
			end

			return
		end
	end

	steal.MT.Jalan = function(arg, arg2, arg3, arg4)
		local mt = steal.MT

		if steal.MT.Mulai() then
			if typeof(arg) == "CFrame" then
				arg = arg.Position or arg
			end

			mt.ikut = true
			local now = os.clock()
			local n2 = arg2 or 45
			local now2 = os.clock()
			local flag2 = false
			local huge = math.huge
			local n3 = 0
			local n4 = 0

			while true do
				if not (os.clock() - now < n2) then
					steal.MT.Darat(3)
					return false
				else
					runService.Heartbeat:Wait()
					if not tbl.Alive or not steal.Gerak() then
						steal.MT.Darat(3)
						return false
					end
					local v4, v5 = fn()

					if v4 then
						if v5 then
							if not (v5.Health > 0) then
								return false
							end
							local position = v4.Position
							local magnitude = (Vector3.new(position.X, 0, position.Z) - Vector3.new(arg.X, 0, arg.Z)).Magnitude

							if not (magnitude <= mt.TIBA) then
								if arg4 and steal.HeldUid() ~= arg4 then
									steal.MT.Darat(3)
									return false
								end

								if arg3 and not flag2 and magnitude <= 28 then
									local v6 = arg3

									local function fn16()
										local EggWorld = tbl.NET.Get("EggWorld", "AskFieldEggCarry")
										if EggWorld then
											pcall(EggWorld.InvokeServer, EggWorld, { Uid = v6 })
											return
										end
									end

									task.spawn(fn16)
									flag2 = true
								end

								if magnitude < huge - 2 then
									now2 = os.clock()
									huge = magnitude
								end

								if os.clock() - now2 > 0.6 and n3 < 4 then
									n3 += 1
									steal.MT.Angkat(45, 2)
									mt.ikut = true
									now2 = os.clock()
								end

								if n4 <= os.clock() then
									n4 = os.clock() + 0.25
									v5:MoveTo(Vector3.new(arg.X, position.Y, arg.Z))
								end

								continue
							end

							steal.MT.Darat(3)
							return true
						end

						return false
					end

					break
				end
			end

			return false
		end

		return false
	end

	steal.MT.Rapat = function(arg, arg2)
		local mt = steal.MT
		steal.MT.KeTinggi(arg.Y + 2.5, 3)
		mt.ikut = true
		local now = os.clock()
		local huge = math.huge
		local n2 = 0

		while true do
			local n3 = os.clock() - now

			if arg2 then
				if not (n3 < arg2) then
					return huge
				end
			elseif not (n3 < 3) then
				return huge
			end

			runService.Heartbeat:Wait()
			local v4, v5 = fn()

			if v4 then
				if v5 then
					huge = (v4.Position - arg).Magnitude

					if not (huge <= mt.DEKAT) then
						if n2 <= os.clock() then
							n2 = os.clock() + 0.25
							v5:MoveTo(Vector3.new(arg.X, v4.Position.Y, arg.Z))
						end

						continue
					end

					return huge
				end

				return -1
			end

			break
		end

		return -1
	end

	steal.MT.Pegang = function(arg)
		for _, v4 in pairs(steal.FieldRecords()) do
			if tostring(v4.Uid) ~= arg then
				continue
			end
			local flag2 = tostring(v4.State) == "Carried"
			if flag2 then
				return tonumber(v4.CarrierUserId) == localPlayer.UserId
			end
			return flag2
		end

		return false
	end

	steal.RUANG = {}
	steal.RUANG.TENANG = 0.45
	steal.RUANG.DEKAT = 6
	steal.RUANG.T = {}
	steal.RUANG.LANGIT = 10000
	steal.RUANG.MAKS = 4
	steal.RUANG.ULANG = 0.25
	steal.RUANG.ENDAP = 1.5
	steal.RUANG.GRACE = 2

	steal.RUANG.Portal = function()
		local basePart

		pcall(function()
			local world = v:FindFirstChild("World")
			local build = world and world:FindFirstChild("Build")
			local fuseBiomeLanePortals = build and build:FindFirstChild("FuseBiomeLanePortals")
			if fuseBiomeLanePortals then
				basePart = fuseBiomeLanePortals:FindFirstChildWhichIsA("BasePart", true)
				return
			end
		end)

		return basePart
	end

	local function pintu()
		local exitPart

		pcall(function()
			local world = v:FindFirstChild("World")
			local build = world and world:FindFirstChild("Build")
			local fuseBiomeZone = build and build:FindFirstChild("FuseBiomeZone")

			if fuseBiomeZone then
				exitPart = fuseBiomeZone:FindFirstChild("ExitPart")
			end

			if exitPart and not exitPart:IsA("BasePart") then
				exitPart = nil
				return
			end
		end)

		return exitPart
	end

	steal.RUANG.Pintu = pintu
end

steal.RUANG.DiDalam = function()
	local v4 = fn2()
	local flag2 = v4 ~= nil
	if flag2 then
		return v4.Position.Y > steal.RUANG.LANGIT
	end
	return flag2
end

local fn15
local n2 = 0

fn15 = function()
	if steal.Running then
		return
	end
	n2 += 1
	local v4 = n2

	task.delay(steal.RUANG.GRACE, function()
		if v4 ~= n2 or steal.Running then
			return
		end
		steal.SpoofStop()
	end)
end

local fn16

do
	local function fn17(arg, arg2)
		if firetouchinterest then
			pcall(function()
				firetouchinterest(arg, arg2, 0)
				firetouchinterest(arg, arg2, 1)
			end)

			return
		end
	end

	local function fn18(arg, arg2)
		local ruang = steal.RUANG

		local function fn19()
			local v4 = fn2()

			if v4 then
				if arg2 then
					return v4.Position.Y > ruang.LANGIT
				end
				return v4.Position.Y < ruang.LANGIT
			end

			return false
		end

		if fn19() then
			return true
		end
		local cframe = CFrame.new(arg.Position)
		local n3 = os.clock() + ruang.MAKS
		local now = os.clock()
		local tembak = 0
		local n4 = 0

		while os.clock() < n3 and tbl.Alive and steal.Running do
			local v4 = fn2()

			if v4 and v4.Parent then
				if fn19() then
					ruang.T.pin = math.floor((os.clock() - now) * 1000)
					ruang.T.tembak = tembak
					return true
				end

				steal.Tulis(v4, cframe, false)

				if n4 <= os.clock() then
					n4 = os.clock() + ruang.ULANG
					tembak += 1
					fn17(v4, arg)
				end

				runService.Heartbeat:Wait()
				continue
			end

			break
		end

		ruang.T.pinGagal = math.floor((os.clock() - now) * 1000)
		ruang.T.tembak = tembak
		local now2 = os.clock()

		while true do
			if not (os.clock() - now2 < 1.2) or not tbl.Alive or not steal.Running then
				return (fn19())
			else
				if fn19() then
					break
				end
				task.wait(0.05)
			end
		end

		return true
	end

	steal.JAUH = {}

	fn16 = function(arg)
		return tostring(arg):lower():gsub("%s", "")
	end

	steal.AreaDi = function(arg)
		if arg then
			local v4 = steal.Areas()
			local guardAreas = v4 and v4:FindFirstChild("GuardAreas")

			if guardAreas then
				for _, child in ipairs(guardAreas:GetChildren()) do
					local bounds = child:FindFirstChild("Bounds")

					if bounds and bounds:IsA("BasePart") then
						local v5 = bounds.CFrame:PointToObjectSpace(arg)
						local n3 = bounds.Size * 0.5
						if math.abs(v5.X) <= n3.X and math.abs(v5.Z) <= n3.Z then
							return fn16(child.Name), child.Name
						end
					end
				end

				return nil
			end

			return nil
		end

		return nil
	end

	steal.JAUH.TITIK = Vector3.new(596.94, 70.7, -322.84)
	steal.JAUH.DECOY = true

	steal.JAUH.DecoyOn = function()
		if steal.JAUH.DECOY then
			if steal.TP then
				if steal.TP.Enabled then
					if steal.FLOW and steal.FLOW.PakaiMT and steal.FLOW.PakaiMT() then
						return false
					end

					if steal.FLOW and steal.FLOW.samar then
						return true
					end
					return steal.TSOn()
				end

				return false
			end

			return false
		end

		return false
	end

	steal.JAUH.FADE = false

	steal.JAUH.Fade = function(enabled)
		if steal.JAUH.FADE then
			return
		end

		pcall(function()
			local fade = localPlayer.PlayerGui:FindFirstChild("Fade")
			if fade then
				fade.Enabled = enabled
				return
			end
		end)
	end

	steal.SEMBUNYI = {
		SAKLAR = true,
		on = false,
		at = 0,
		SEGAR = 2,
		tok = 0,
		TAHAN = 7,
		part = {},
		kaca = {},
		fx = {},
	}

	local function fn19()
		local world = v:FindFirstChild("World")
		local build = world and world:FindFirstChild("Build")
		if build then
			return (build:FindFirstChild("FuseBiomeZone"))
		end
		return build
	end

	steal.SEMBUNYI.Pasang = function()
		local sembunyi = steal.SEMBUNYI
		if sembunyi.on and os.clock() - sembunyi.at < sembunyi.SEGAR then
			return
		end
		local v4 = fn19()

		if v4 then
			sembunyi.at = os.clock()
			sembunyi.tok = sembunyi.tok + 1

			for _, descendant in ipairs(v4:GetDescendants()) do
				if descendant:IsA("BasePart") then
					if sembunyi.part[descendant] == nil then
						sembunyi.part[descendant] = descendant.LocalTransparencyModifier
					end

					descendant.LocalTransparencyModifier = 1
				elseif descendant:IsA("Decal") or descendant:IsA("Texture") then
					if sembunyi.kaca[descendant] == nil then
						sembunyi.kaca[descendant] = descendant.Transparency
					end

					descendant.Transparency = 1
				elseif descendant:IsA("ParticleEmitter") or descendant:IsA("Trail") or descendant:IsA("Beam") or descendant:IsA("Sparkles") or descendant:IsA("Fire") or descendant:IsA("Smoke") or descendant:IsA("Light") or descendant:IsA("Highlight") or descendant:IsA("BillboardGui") or descendant:IsA("SurfaceGui") then
					if sembunyi.fx[descendant] == nil then
						sembunyi.fx[descendant] = descendant.Enabled
					end

					descendant.Enabled = false
				end
			end

			sembunyi.on = true
			return
		end
	end

	steal.SEMBUNYI.LepasNanti = function(arg)
		local sembunyi = steal.SEMBUNYI

		if sembunyi.on then
			sembunyi.tok = sembunyi.tok + 1
			local tok = sembunyi.tok

			task.delay(arg or sembunyi.TAHAN, function()
				if sembunyi.tok ~= tok then
					return
				end
				sembunyi.Lepas()
			end)

			return
		end
	end

	steal.SEMBUNYI.Lepas = function()
		local sembunyi = steal.SEMBUNYI

		if sembunyi.on then
			sembunyi.on = false

			for k, v4 in pairs(sembunyi.part) do
				if k.Parent then
					pcall(function()
						k.LocalTransparencyModifier = v4
					end)
				end
			end

			for k, v4 in pairs(sembunyi.kaca) do
				if k.Parent then
					pcall(function()
						k.Transparency = v4
					end)
				end
			end

			for k, v4 in pairs(sembunyi.fx) do
				if k.Parent then
					pcall(function()
						k.Enabled = v4
					end)
				end
			end

			table.clear(sembunyi.part)
			table.clear(sembunyi.kaca)
			table.clear(sembunyi.fx)
			sembunyi.at = 0
			return
		end
	end

	steal.JAUH.DECOY_DIAM = 1
	steal.TAHAN_ATAS = 14
	steal.RUANG.BOOST = true
	steal.RUANG.BOOST_DIAM = 0.3
	steal.RUANG.BOOST_JEDA = 0.35
	steal.RUANG.BOOST_DEKAT = 40
	steal.RUANG.GUARD = { on = false, tukar = {}, SUMBER = { "ContentCatalog", "ObbyAntiTP" } }

	local function fn20(arg)
		if arg then
			local ok, result = pcall(debug.info, arg, "s")

			if ok then
				local str2 = tostring(result)

				for _, v4 in ipairs(steal.RUANG.GUARD.SUMBER) do
					if str2:find(v4, 1, true) then
						return true
					end
				end

				return false
			end

			return false
		end

		return false
	end

	steal.RUANG.GuardPasang = function()
		local guard = steal.RUANG.GUARD

		if not (#guard.tukar > 0) then
			local RigSync = tbl.NET.Get("RigSync", "Refresh")

			if RigSync then
				if RigSync:IsA("RemoteEvent") then
					if type(getconnections) ~= "function" then
						return 0
					end

					for _, v4 in ipairs(getconnections(RigSync.OnClientEvent)) do
						if fn20(v4.Function) then
							local function_ = v4.Function
							local v5 = pcall

							local function fn21()
								v4:Disable()
							end

							v5(fn21)
							local onClientEvent = RigSync.OnClientEvent
							local v6 = onClientEvent
							local connect = onClientEvent.Connect

							local function fn22(arg, ...)
								if guard.on and type(arg) == "string" then
									local ok, result = pcall(function()
										return tbl.SV.HttpService:JSONDecode(arg)
									end)

									if ok then
										local arguments = type(result) == "table" and result.Arguments
										if type(result) == "table" and result.Action == "Relocate" and type(arguments) == "table" and type(arguments[2]) == "number" and arguments[2] < steal.RUANG.LANGIT then
											guard.dibuang = (guard.dibuang or 0) + 1
											return
										end
									end
								end

								function_(arg, ...)
							end

							guard.tukar[#guard.tukar + 1] = { c = v4, terus = connect(v6, fn22) }
						end
					end

					guard.on = true
					guard.dibuang = 0
					return #guard.tukar
				end

				return 0
			end

			return 0
		end

		guard.on = true
		return #guard.tukar
	end

	steal.RUANG.GuardLepas = function()
		local guard = steal.RUANG.GUARD
		guard.on = false

		for _, v4 in ipairs(guard.tukar) do
			pcall(function()
				v4.terus:Disconnect()
			end)

			pcall(function()
				v4.c:Enable()
			end)
		end

		table.clear(guard.tukar)
	end

	tbl.ST.Trove:Add(function()
		pcall(steal.RUANG.GuardLepas)
	end)

	steal.RUANG.Boost = function(arg)
		if typeof(arg) ~= "Vector3" then
			return false
		end
		local ruang = steal.RUANG
		ruang.T = {}
		local v4 = ruang.GuardPasang()
		ruang.T.guard = v4

		if v4 == 0 then
			tbl.LOG.warn("RUANG", "penjaga lagback tidak terpasang - listener tidak ketemu")
		end

		local function fn21()
			steal.SpoofStart()
			steal.PadStart()
			runService.PreSimulation:Wait()
			runService.PreSimulation:Wait()
			local v5 = fn2()
			local humanoid = localPlayer.Character and localPlayer.Character:FindFirstChildOfClass("Humanoid")

			if v5 then
				if not humanoid then
					error("no character")
				end
			else
				error("no character")
			end

			humanoid.PlatformStand = true
			steal.Tulis(v5, CFrame.new(arg), false)
			runService.PreSimulation:Wait()
			humanoid.PlatformStand = false
			steal.FLOW.Tahan(arg, ruang.BOOST_DIAM, steal.FrameTarget(ruang.BOOST_DIAM))
		end

		if pcall(fn21) then
			local v5 = steal.RUANG.MasukJauh()
			ruang.T.masuk = v5 and 1 or 0
			ruang.GuardLepas()

			if v5 then
				local v6 = steal.RUANG.Keluar()
				ruang.T.keluar = v6 and 1 or 0

				if v6 then
					local v7 = fn2()
					local magnitude = v7 and ((v7.Position - arg) * Vector3.new(1, 0, 1)).Magnitude or 1e9
					ruang.T.jarak = math.floor(magnitude)
					ruang.T.jalur = "boost"
					return magnitude <= ruang.BOOST_DEKAT, magnitude
				end

				return false
			end

			return false
		end

		ruang.GuardLepas()
		return false
	end

	local function masuk()
		local v4 = steal.RUANG.Portal()

		if v4 then
			local ruang = steal.RUANG
			ruang.T = {}
			steal.SpoofStart()
			local now = os.clock()
			runService.PreSimulation:Wait()
			runService.PreSimulation:Wait()
			ruang.T.tunggu = math.floor((os.clock() - now) * 1000)
			local cframe = CFrame.new(v4.Position)
			local n3 = os.clock() + ruang.ENDAP
			local now2 = os.clock()
			local flag2

			while true do
				flag2 = false

				if not (os.clock() < n3) then
					break
				else
					if tbl.Alive then
						if steal.Running then
							local v5 = fn2()

							if v5 then
								if v5.Parent then
									if not (ruang.LANGIT < v5.Position.Y) then
										steal.Tulis(v5, cframe, false)
										runService.Heartbeat:Wait()
										continue
									end

									flag2 = true
									break
								end

								break
							end

							break
						end

						break
					end

					break
				end
			end

			ruang.T.endap = math.floor((os.clock() - now2) * 1000)
			local flag3

			if flag2 then
				ruang.T.jalur = "berdiri"
				flag3 = true
			else
				ruang.T.jalur = "tembak"
				flag3 = fn18(v4, true)
			end

			ruang.T.spoof = steal.SpoofPatched()
			fn15()
			return flag3
		end

		return false
	end

	local ruang = steal.RUANG
	ruang.Masuk = masuk

	steal.RUANG.MasukJauh = function()
		local v4 = steal.RUANG.Portal()

		if v4 then
			local ruang2 = steal.RUANG
			local n3 = os.clock() + 6
			local tembak = 0
			local n4 = 0

			while os.clock() < n3 and tbl.Alive and steal.Running do
				local v5 = fn2()

				if v5 and v5.Parent then
					if not (ruang2.LANGIT < v5.Position.Y) then
						if n4 <= os.clock() then
							n4 = os.clock() + ruang2.ULANG
							tembak += 1
							fn17(v5, v4)
						end

						runService.Heartbeat:Wait()
						continue
					end

					ruang2.T.tembak = tembak
					return true
				end

				break
			end

			ruang2.T.tembak = tembak
			local v5 = fn2()
			local flag2 = v5 ~= nil
			if flag2 then
				return v5.Position.Y > ruang2.LANGIT
			end
			return flag2
		end

		return false
	end

	steal.RUANG.Keluar = function()
		local v4 = steal.RUANG.Pintu()

		if v4 then
			steal.RUANG.T = {}
			steal.SpoofStart()
			local v5 = fn18(v4, false)
			steal.RUANG.T.spoof = steal.SpoofPatched()
			fn15()
			return v5
		end

		return false
	end
end

steal.POPUP = { NAMA = { "GetMoreSpeedOnHit" }, conn = {}, mati = {} }

steal.POPUP.Tekan = function(arg)
	if not arg or not arg:IsA("ScreenGui") then
		return
	end

	if steal.POPUP.mati[arg] then
		return
	end

	steal.POPUP.mati[arg] = arg:GetPropertyChangedSignal("Enabled"):Connect(function()
		if arg.Enabled then
			arg.Enabled = false
			return
		end
	end)

	arg.Enabled = false
end

steal.POPUP.Off = function()
	local playerGui = localPlayer:FindFirstChild("PlayerGui")

	if playerGui then
		for _, v4 in ipairs(steal.POPUP.NAMA) do
			steal.POPUP.Tekan(playerGui:FindFirstChild(v4))
		end

		if #steal.POPUP.conn ~= 0 then
			return
		end

		steal.POPUP.conn[1] = playerGui.ChildAdded:Connect(function(child)
			for _, v4 in ipairs(steal.POPUP.NAMA) do
				if child.Name == v4 then
					steal.POPUP.Tekan(child)
				end
			end
		end)

		return
	end
end

steal.POPUP.On = function()
	for _, v4 in ipairs(steal.POPUP.conn) do
		pcall(function()
			v4:Disconnect()
		end)
	end

	table.clear(steal.POPUP.conn)

	for k, v4 in pairs(steal.POPUP.mati) do
		pcall(function()
			v4:Disconnect()
		end)

		if k.Parent then
			pcall(function()
				k.Enabled = true
			end)
		end
	end

	table.clear(steal.POPUP.mati)
end

steal.POPUP.Off()
steal.BANNER = { pos = nil, conn = {}, DEKAT = 300 }

steal.BANNER.Gui = function()
	local playerGui = localPlayer:FindFirstChild("PlayerGui")
	if playerGui then
		return (playerGui:FindFirstChild("AreaGui"))
	end
	return playerGui
end

steal.BANNER.Nilai = function(arg)
	if arg then
		if arg.Enabled then
			local pos = steal.BANNER.pos

			if pos then
				local v4 = fn2()

				if v4 then
					if not (steal.BANNER.DEKAT < (v4.Position - pos).Magnitude) then
						return
					end
					arg.Enabled = false
					return
				end

				arg.Enabled = false
				return
			end

			arg.Enabled = false
			return
		end

		return
	end
end

steal.BANNER.Off = function()
	if not (#steal.BANNER.conn > 0) then
		local v4 = steal.BANNER.Gui()
		if not v4 then
			return
		end
		local conn = steal.BANNER.conn
		local n3 = #steal.BANNER.conn + 1
		local signal = v4:GetPropertyChangedSignal("Enabled")

		local function fn17()
			steal.BANNER.Nilai(v4)
		end

		conn[n3] = signal:Connect(fn17)
		local main = v4:FindFirstChild("Main", true)

		if main then
			local conn2 = steal.BANNER.conn
			local n4 = #steal.BANNER.conn + 1
			local signal2 = main:GetPropertyChangedSignal("Text")

			local function fn18()
				steal.BANNER.Nilai(v4)
			end

			conn2[n4] = signal2:Connect(fn18)
		end

		steal.BANNER.Nilai(v4)
		return
	end
end

steal.BANNER.On = function()
	for _, v4 in ipairs(steal.BANNER.conn) do
		pcall(function()
			v4:Disconnect()
		end)
	end

	table.clear(steal.BANNER.conn)
	steal.BANNER.pos = nil
end

steal.PROMPT = { mati = {}, conn = nil }

steal.PROMPT.Colong = function(arg)
	local isProximityPrompt = arg:IsA("ProximityPrompt")
	if isProximityPrompt then
		return tostring(arg.ActionText) == "Steal"
	end
	return isProximityPrompt
end

steal.PROMPT.Wadah = function()
	local smartPromptPart = v:FindFirstChild("SmartPromptPart")
	if smartPromptPart then
		return smartPromptPart
	end
	return v:FindFirstChild("SmartPromptPart", true)
end

local function fn17(descendant)
	if steal.PROMPT.Colong(descendant) then
		if steal.PROMPT.mati[descendant] then
			return
		end

		steal.PROMPT.mati[descendant] = descendant:GetPropertyChangedSignal("Enabled"):Connect(function()
			if descendant.Enabled then
				descendant.Enabled = false
				return
			end
		end)

		descendant.Enabled = false
		return
	end
end

steal.PROMPT.Off = function()
	local v4 = steal.PROMPT.Wadah()

	if v4 then
		for _, descendant in ipairs(v4:GetDescendants()) do
			fn17(descendant)
		end

		if steal.PROMPT.conn then
			return
		end
		steal.PROMPT.conn = v4.DescendantAdded:Connect(fn17)
		return
	end
end

steal.PROMPT.On = function()
	if steal.PROMPT.conn then
		pcall(function()
			steal.PROMPT.conn:Disconnect()
		end)

		steal.PROMPT.conn = nil
	end

	for k, v4 in pairs(steal.PROMPT.mati) do
		pcall(function()
			v4:Disconnect()
		end)

		if k.Parent then
			pcall(function()
				k.Enabled = true
			end)
		end
	end

	table.clear(steal.PROMPT.mati)
end

steal.TAP = { on = false, asli = {}, conn = nil }

steal.TAP.Bawaan = function()
	local tbl2 = {}
	local n3 = 0
	local v4 = nil

	for _, descendant in ipairs(v:GetDescendants()) do
		if steal.PROMPT.Colong(descendant) then
			local holdDuration = descendant.HoldDuration

			if holdDuration and holdDuration > 0 then
				tbl2[holdDuration] = (tbl2[holdDuration] or 0) + 1

				if n3 < tbl2[holdDuration] then
					n3 = tbl2[holdDuration]
					v4 = holdDuration
				end
			end
		end
	end

	return v4
end

local function fn18(arg)
	if steal.PROMPT.Colong(arg) then
		if steal.TAP.asli[arg] then
			return
		end
		local holdDuration = arg.HoldDuration

		if holdDuration then
			if holdDuration <= 0 then
				holdDuration = steal.TAP.bawaan
			end
		else
			holdDuration = steal.TAP.bawaan
		end

		steal.TAP.asli[arg] = {
			hold = holdDuration,
			cx = arg:GetPropertyChangedSignal("HoldDuration"):Connect(function()
				if steal.TAP.on then
					if arg.HoldDuration ~= 0 then
						arg.HoldDuration = 0
						return
					end
					return
				end
			end),
		}

		arg.HoldDuration = 0
		return
	end
end

steal.TAP.Start = function()
	if steal.TAP.on then
		return
	end
	steal.TAP.bawaan = steal.TAP.Bawaan() or 1.2
	steal.TAP.on = true

	for _, descendant in ipairs(v:GetDescendants()) do
		fn18(descendant)
	end

	if not steal.TAP.conn then
		local descendantAdded = v.DescendantAdded
		local v4 = descendantAdded
		local connect = descendantAdded.Connect

		local function fn19(arg)
			if arg:IsA("ProximityPrompt") then
				task.defer(function()
					if steal.TAP.on and arg.Parent then
						fn18(arg)
						return
					end
				end)

				return
			end
		end

		steal.TAP.conn = connect(v4, fn19)
	end

	local n3 = 0

	for k in pairs(steal.TAP.asli) do
		n3 += 1
	end

	tbl.LOG.info("TAP", ("aktif - %d prompt colong jadi sekali tekan"):format(n3))
end

steal.TAP.Stop = function()
	if steal.TAP.on then
		steal.TAP.on = false

		if steal.TAP.conn then
			pcall(function()
				steal.TAP.conn:Disconnect()
			end)

			steal.TAP.conn = nil
		end

		for k, v4 in pairs(steal.TAP.asli) do
			pcall(function()
				v4.cx:Disconnect()
			end)

			if k.Parent then
				pcall(function()
					k.HoldDuration = v4.hold
				end)
			end
		end

		table.clear(steal.TAP.asli)
		tbl.LOG.info("TAP", "berhenti - tahanan prompt dikembalikan")
		return
	end
end

steal.TAP.Sync = function()
	local oneTapSteal = tbl.UIX and tbl.UIX.STEAL and tbl.UIX.STEAL.OneTapSteal
	if oneTapSteal and oneTapSteal.Get and oneTapSteal.Get() then
		steal.TAP.Start()
		return
	end
	steal.TAP.Stop()
end

tbl.ST.Trove:Add(function()
	pcall(steal.TAP.Stop)
end)

do
	local invis = {}
	invis.on = false
	invis.sibuk = false
	invis.bangun = false
	invis.minta = false
	invis.cx = {}
	invis.Terpasang = 0
	steal.INVIS = invis
end

steal.INVIS.HIP = 999
steal.INVIS.ULANG = 8
steal.INVIS.JAGA = 60
steal.INVIS.POLL = 0.25

do
	local function fn19()
		return localPlayer.Character
	end

	local function fn20(arg)
		if arg then
			local humanoid = arg:FindFirstChildOfClass("Humanoid")
			if humanoid then
				return humanoid
			end
		end

		return nil
	end

	steal.INVIS.Aktif = function(arg)
		local v4 = arg or fn19()
		local flag2 = v4 ~= nil
		if flag2 then
			return v4:GetAttribute("InvisApplied") == true
		end
		return flag2
	end

	steal.INVIS.Boleh = function()
		if steal.Running then
			return false, "steal engine busy"
		end

		if steal.pulang then
			return false, "steal engine busy"
		end

		if steal.rampok then
			return false, "steal engine busy"
		end

		if steal.HeldUid() then
			return false, "carrying an egg"
		end

		if steal.TM.NaikPasti() then
			return false, "on the treadmill"
		end
		return true
	end

	local function fn21(arg)
		local packages = tbl.SV.ReplicatedStorage:FindFirstChild("Packages")
		local networking = packages and packages:FindFirstChild("Networking")

		if networking then
			local v4 = networking:FindFirstChild(arg)
			if v4 then
				return v4
			end
		end

		return nil
	end

	local function fn22(arg)
		local AskRigWipe = fn21("RE/RigSync/AskRigWipe")
		if AskRigWipe and AskRigWipe:IsA("RemoteEvent") then
			pcall(AskRigWipe.FireServer, AskRigWipe, arg)
			return
		end
	end

	local function fn23(arg)
		local backpack = localPlayer:FindFirstChildOfClass("Backpack")
		local v4 = fn20(arg)

		if v4 then
			pcall(v4.UnequipTools, v4)
		end

		if backpack then
			for _, child in ipairs(arg:GetChildren()) do
				if child:IsA("Tool") then
					pcall(function()
						child.Parent = backpack
					end)
				end
			end
		end

		for i = 1, 3 do
			runService.Heartbeat:Wait()
		end
	end

	steal.INVIS.Bunuh = function(arg)
		local v4 = fn20(arg)
		if not arg or not v4 then
			return false
		end
		fn23(arg)
		local Treadmill = tbl.NET.Get("Treadmill", "AskDoff")

		if Treadmill then
			for i = 1, 2 do
				pcall(Treadmill.InvokeServer, Treadmill)
			end
		end

		pcall(function()
			v4:SetStateEnabled(Enum.HumanoidStateType.Dead, true)
			v4.BreakJointsOnDeath = true
			v4.RequiresNeck = true
			v4.Health = 0
		end)

		pcall(function()
			v4:ChangeState(Enum.HumanoidStateType.Dead)
		end)

		pcall(function()
			arg:BreakJoints()
		end)

		fn22(arg)
		return true
	end

	steal.INVIS.Rakit = function(parent)
		local v4 = fn20(parent)
		local n3 = os.clock() + 10

		while os.clock() < n3 do
			if steal.INVIS.on then
				if parent.Parent then
					v4 = v4 or fn20(parent)
					if not v4 or not parent:FindFirstChild("HumanoidRootPart") or not parent:FindFirstChild("Head") then
						task.wait()
						continue
					end
					break
				end

				break
			end

			break
		end

		local humanoidRootPart = parent:FindFirstChild("HumanoidRootPart")

		if steal.INVIS.on then
			if v4 then
				if humanoidRootPart then
					if parent:FindFirstChild("Head") then
						task.wait(0.05)

						if steal.INVIS.on then
							if parent.Parent then
								for i = 1, 2 do
									pcall(v4.UnequipTools, v4)
								end

								if type(replicatesignal) == "function" then
									for i = 1, 2 do
										pcall(replicatesignal, v4.ServerBreakJoints)
									end
								end

								local hipHeight = v4.HipHeight

								pcall(function()
									v4.HipHeight = steal.INVIS.HIP
								end)

								for _, child in ipairs(parent:GetChildren()) do
									if child:IsA("Accessory") then
										pcall(function()
											child.Parent = nil
										end)
									elseif child:IsA("BasePart") and child ~= humanoidRootPart then
										pcall(function()
											child.Parent = nil
										end)

										continue
									end
								end

								task.wait(0.12)

								local function fn24()
									local function fn25()
										v4.HipHeight = hipHeight
									end

									pcall(fn25)

									for _, child in ipairs(parent:GetChildren()) do
										if child:IsA("Humanoid") and child.HipHeight ~= hipHeight then
											local function fn26()
												child.HipHeight = hipHeight
											end

											pcall(fn26)
										end
									end
								end

								if parent.Parent ~= nil then
									local motor6D = Instance.new("Motor6D")
									local cframe = CFrame.new(1.2, 0, 0)
									local cframe2 = CFrame.new()
									motor6D.Name = "RightWrist"
									motor6D.C0 = cframe
									motor6D.C1 = cframe2
									motor6D.Part0 = humanoidRootPart
									motor6D.Parent = humanoidRootPart
									local part = Instance.new("Part")
									part.Name = "RightHand"
									part.Size = Vector3.new(0.2, 0.2, 0.2)
									part.Transparency = 1
									part.CanCollide = false
									part.CanTouch = false
									part.CanQuery = false
									part.Massless = true
									part.CFrame = humanoidRootPart.CFrame * motor6D.C0
									motor6D.Part1 = part
									part.Parent = parent

									pcall(function()
										humanoidRootPart.CanCollide = false
									end)

									fn24()
									parent:SetAttribute("InvisApplied", true)
									steal.INVIS.Terpasang = steal.INVIS.Terpasang + 1

									local function fn25()
										if humanoidRootPart.Parent then
											pcall(function()
												humanoidRootPart.CanCollide = true
											end)

											return
										end
									end

									task.delay(0.2, fn25)

									local function fn26(child)
										if child:IsA("Humanoid") then
											task.defer(function()
												if child.HipHeight ~= hipHeight then
													pcall(function()
														child.HipHeight = hipHeight
													end)

													return
												end
											end)

											return
										end
									end

									local connection = parent.ChildAdded:Connect(fn26)
									local v5 = nil
									local ancestryChanged = parent.AncestryChanged
									local v6 = ancestryChanged
									local connect = ancestryChanged.Connect

									local function fn27(arg, arg2)
										if arg2 == nil then
											pcall(function()
												connection:Disconnect()
											end)

											pcall(function()
												v5:Disconnect()
											end)

											return
										end
									end

									v5 = connect(v6, fn27)
									return true
								end

								fn24()
								return false
							end

							return false
						end

						return false
					end

					return false
				end

				return false
			end

			return false
		end

		return false
	end

	steal.INVIS.Terapkan = function()
		if steal.INVIS.sibuk then
			return
		end
		steal.INVIS.sibuk = true

		while steal.INVIS.on do
			if steal.INVIS.Boleh() then
				break
			end
			task.wait(0.2)
		end

		local v4 = fn19()

		if steal.INVIS.on and v4 and fn20(v4) then
			steal.INVIS.minta = false
			fn4("going invisible")
			steal.INVIS.Bunuh(v4)
			local n3 = os.clock() + steal.INVIS.JAGA
			local n4 = os.clock() + steal.INVIS.ULANG

			while steal.INVIS.on do
				if not (os.clock() < n3) then
					break
				end

				if localPlayer.Character ~= v4 then
					break
				end

				if n4 <= os.clock() then
					n4 = os.clock() + steal.INVIS.ULANG
					fn22(v4)
				end

				task.wait(0.05)
			end

			task.wait(0.1)

			while steal.INVIS.on do
				if steal.INVIS.bangun then
					task.wait(0.05)
					continue
				end
				break
			end
		end

		steal.INVIS.sibuk = false
	end

	steal.INVIS.Start = function()
		if steal.INVIS.on then
			return
		end
		steal.INVIS.on = true
		steal.INVIS.minta = true
		tbl.LOG.warn("INVIS", "aktif - karakter akan mati sekali untuk membuang rig")
		local n3 = #steal.INVIS.cx + 1
		local characterAdded = localPlayer.CharacterAdded
		local v4 = characterAdded
		local connect = characterAdded.Connect

		local function fn24(arg)
			if steal.INVIS.on then
				steal.INVIS.bangun = true

				task.spawn(function()
					pcall(steal.INVIS.Rakit, arg)
					steal.INVIS.bangun = false
				end)

				return
			end
		end

		steal.INVIS.cx[n3] = connect(v4, fn24)
		local cx = steal.INVIS.cx
		local n4 = #steal.INVIS.cx + 1
		local heartbeat = runService.Heartbeat
		local v5 = heartbeat
		local connect2 = heartbeat.Connect

		local function fn25()
			local v6 = fn19()

			if v6 then
				if steal.INVIS.Aktif(v6) then
					local rightHand = v6:FindFirstChild("RightHand")
					local tool = v6:FindFirstChildWhichIsA("Tool")
					local handle = tool and tool:FindFirstChild("Handle")
					if not rightHand or not handle then
						return
					end

					if handle:IsA("BasePart") then
						local cframe = CFrame.new()

						for _, child in ipairs(rightHand:GetChildren()) do
							if child:IsA("JointInstance") and child.Name == "RightGrip" and child.Part1 == handle then
								cframe = child.C0 * child.C1:Inverse()

								if child.Enabled then
									child.Enabled = false
								end
							end
						end

						pcall(function()
							handle.CFrame = rightHand.CFrame * cframe
							handle.AssemblyLinearVelocity = Vector3.zero
							handle.AssemblyAngularVelocity = Vector3.zero
						end)

						return
					end

					return
				end

				return
			end
		end

		cx[n4] = connect2(v5, fn25)
		local n5 = #steal.INVIS.cx + 1
		local heartbeat2 = runService.Heartbeat
		local v6 = heartbeat2
		local connect3 = heartbeat2.Connect

		local function fn26()
			local v7 = fn19()
			local v8 = fn20(v7)
			local humanoidRootPart = v7 and v7:FindFirstChild("HumanoidRootPart")
			if not v8 or not humanoidRootPart then
				return
			end

			if not (v8.Health > 0) then
				return
			end

			if steal.INVIS.Aktif(v7) and not steal.Running and not steal.pulang and not steal.rampok and not v8.Sit and not v8.PlatformStand then
				if v8.AutoRotate then
					pcall(function()
						v8.AutoRotate = false
					end)
				end

				local moveDirection = v8.MoveDirection
				local vector = Vector3.new(moveDirection.X, 0, moveDirection.Z)
				if not (vector.Magnitude > 0.01) then
					return
				end

				pcall(function()
					humanoidRootPart.CFrame = CFrame.lookAt(humanoidRootPart.Position, humanoidRootPart.Position + vector.Unit)
				end)

				return
			end

			if v8.AutoRotate then
				return
			end

			pcall(function()
				v8.AutoRotate = true
			end)
		end

		steal.INVIS.cx[n5] = connect3(v6, fn26)

		task.spawn(function()
			while steal.INVIS.on do
				if tbl.Alive then
					local v7 = fn19()
					local v8 = fn20(v7)

					if not steal.INVIS.sibuk and not steal.INVIS.bangun and v7 and v8 and v8.Health > 0 and (steal.INVIS.minta or not steal.INVIS.Aktif(v7)) then
						pcall(steal.INVIS.Terapkan)
					end

					task.wait(steal.INVIS.POLL)
					continue
				end

				break
			end
		end)
	end

	steal.INVIS.Stop = function()
		steal.INVIS.on = false
		steal.INVIS.minta = false

		for _, v4 in ipairs(steal.INVIS.cx) do
			pcall(function()
				v4:Disconnect()
			end)
		end

		table.clear(steal.INVIS.cx)
		local v4 = fn19()
		local v5 = fn20(v4)

		if v5 then
			pcall(function()
				v5.AutoRotate = true
			end)
		end

		if not v4 or not steal.INVIS.Aktif(v4) then
			return
		end

		pcall(function()
			v4:SetAttribute("InvisApplied", nil)
		end)

		tbl.LOG.warn("INVIS", "berhenti - respawn untuk mengembalikan badan")

		if v5 then
			pcall(function()
				v5.Health = 0
			end)

			pcall(function()
				v5:ChangeState(Enum.HumanoidStateType.Dead)
			end)

			return
		end
	end

	steal.INVIS.lahir = os.clock()
	steal.INVIS.JEDA_AMAN = 8

	steal.INVIS.Sync = function()
		local invisible = tbl.UIX and tbl.UIX.STEAL and tbl.UIX.STEAL.Invisible
		if not invisible or not invisible.Get or not invisible.Get() then
			steal.INVIS.Stop()
			return
		end

		if not (os.clock() - steal.INVIS.lahir < steal.INVIS.JEDA_AMAN) then
			steal.INVIS.Start()
			return
		end
		tbl.LOG.warn("INVIS", "nyala-sendiri saat boot DITOLAK - nyalakan manual")

		if invisible.Set then
			pcall(invisible.Set, invisible, false, true)
		end

		steal.INVIS.on = false
	end

	tbl.ST.Trove:Add(function()
		pcall(steal.INVIS.Stop)
	end)

	steal.JAUH.Tutup = function(arg)
		steal.JAUH.Fade(false)

		if arg and arg.pos then
			steal.BANNER.pos = arg.pos
		end

		if steal.JAUH.DecoyOn() then
			if steal.TP and steal.TP.on then
				return
			end

			if arg then
				if arg.pos then
					local n3 = arg.pos + Vector3.new(0, 2.5, 0)
					steal.TP.Setup(CFrame.new(n3), n3)

					steal.TP.Alive = function()
						return steal.Running
					end

					pcall(steal.TP.CharHidden, true)
					return
				end

				return
			end

			return
		end
	end

	steal.JAUH.Buka = function()
		steal.JAUH.Fade(true)
		if steal.TP and steal.TP.on then
			steal.TP.Clear()
			return
		end
	end

	steal.FLOW = {}
	steal.FLOW.SAMAR = { PENUTUP = "Volcano" }
	steal.FLOW.samar = false

	steal.FLOW.TitikArea = function(arg)
		local v4 = steal.Areas()
		local guardAreas = v4 and v4:FindFirstChild("GuardAreas")
		local v5 = guardAreas and guardAreas:FindFirstChild(arg)
		local bounds = v5 and v5:FindFirstChild("Bounds")

		if bounds then
			if bounds:IsA("BasePart") then
				return bounds.Position + Vector3.new(0, 4, 0)
			end
			return nil
		end

		return nil
	end

	steal.FLOW.RUANGAN = {
		lightdark = true,
		titantemple = true,
		enchantedforest = true,
		cherryblossom = true,
		cosmic = true,
		prehistoric = true,
		abyssocean = true,
		volcano = true,
		snow = true,
		jungle = true,
		desert = true,
		lake = true,
	}

	local flow = steal.FLOW
	local areas = {}
	areas.lightdark = true
	areas.titantemple = true
	areas.cherryblossom = true
	areas.cosmic = true
	areas.prehistoric = true
	areas.abyssocean = true
	areas.volcano = true
	areas.snow = true
	areas.jungle = true
	areas.desert = true
	areas.lake = true
	areas.enchantedforest = true
	flow.AREAS = areas

	steal.FLOW.Bisa = function(arg)
		local flag2 = arg ~= nil
		if flag2 then
			return steal.FLOW.AREAS[fn16(arg.area)] == true
		end
		return flag2
	end

	steal.FLOW.LAJU = 5000
	steal.FLOW.PERGI_LAMBAT = 700
	steal.FLOW.ATAS = 14
end

steal.FLOW.BERDIRI = 2.5
steal.FLOW.ANGKAT_MAKS = 3.5
steal.FLOW.ULANG_MAKS = 3
steal.FLOW.ULANG_COBA = 3
steal.FLOW.ULANG_JEDA = 0.6
steal.FLOW.ULANG_LONGGAR = 1.2
steal.FLOW.MAMPIR = true
steal.FLOW.MAMPIR_DIAM = 0.2
steal.FLOW.TM_MAMPIR = true
steal.FLOW.TM_PASANG = 0.4
steal.FLOW.TM_MAMPIR_BOOST = true
steal.FLOW.TM_DIAM = 1
steal.FLOW.SETTLE_MAKS = 3
steal.FLOW.DROP_TAHAN = 1.5
steal.FLOW.RELAY_BOOST = Vector3.new(554.071, 70.276, -395.573)
steal.FLOW.RELAY_SETTLE = 0.3

steal.FLOW.MilikAutoSteal = function()
	local autoStealEggs = tbl.UIX and tbl.UIX.STEAL and tbl.UIX.STEAL.AutoStealEggs
	if autoStealEggs and autoStealEggs.Get and autoStealEggs.Get() then
		return true
	end
	return false
end

steal.FLOW.PakaiMT = function()
	local v4 = steal.FLOW.MilikAutoSteal()
	if v4 then
		return steal.Metode() == "MoveTo"
	end
	return v4
end

steal.FLOW.PERGI_AREA = { cherryblossom = 5000 }

steal.FLOW.LajuPergi = function(arg)
	if steal.FLOW.MilikAutoSteal() then
		if arg then
			local v4 = steal.FLOW.PERGI_AREA[fn16(arg)]
			if v4 then
				return v4
			end
		end

		return steal.FLOW.PERGI_LAMBAT
	end

	return steal.FLOW.LAJU
end

steal.FLOW.RUANG_MOVETO = {}
steal.FLOW.RUANG_TAHAN = { enchantedforest = 0, titantemple = 0 }
steal.FLOW.RUANG_DIAM = 0.5
steal.FLOW.LANGKAH = 335.512
steal.FLOW.DWELL = 0.105
steal.FLOW.NAIK = 42

steal.FLOW.Bertahap = function(arg)
	local v4 = fn2()

	if v4 then
		local position = v4.Position

		if typeof(arg) == "CFrame" then
			arg = arg.Position or arg
		end

		local vector = Vector3.new(arg.X - position.X, 0, arg.Z - position.Z)
		local n3 = math.max(1, math.ceil(vector.Magnitude / steal.FLOW.LANGKAH))
		local unit = vector.Magnitude > 0.01 and vector.Unit or Vector3.new(0, 0, -1)
		local n4 = math.max(position.Y, arg.Y) + steal.FLOW.NAIK
		local now = os.clock()

		for i = 1, math.min(n3, 100) do
			if not (os.clock() - now >= 12) then
				if steal.Running then
					local n5 = position + vector * i / n3
					local vector2 = Vector3.new(n5.X, n4, n5.Z)
					local cframe = CFrame.lookAt(vector2, vector2 + unit)
					local n6 = os.clock() + steal.FLOW.DWELL
					local exitTo = nil

					while true do
						local v5 = fn2()

						if v5 then
							if v5.Parent then
								steal.Tulis(v5, cframe, false)
								runService.Heartbeat:Wait()
								if not (n6 <= os.clock()) then
									continue
								end
								exitTo = 1
								break
							end

							break
						else
							break
						end
					end

					if exitTo == 1 then
						continue
					end
					break
				end

				break
			end

			break
		end

		local v5 = fn2()

		if v5 then
			steal.Tulis(v5, CFrame.new(arg), false)
		end

		task.wait(steal.FLOW.DWELL)
		local v6 = fn2()
		local flag2 = v6 ~= nil
		if flag2 then
			return (v6.Position - arg).Magnitude <= 12
		end
		return flag2
	end

	return false
end

steal.METODE = { PILIHAN = { "Glide", "MoveTo" }, wanti = false }

steal.Metode = function()
	local stealMethod = tbl.UIX and tbl.UIX.STEAL and tbl.UIX.STEAL.StealMethod
	local v4

	if stealMethod and stealMethod.Get then
		v4 = stealMethod.Get() or nil
	else
		v4 = nil
	end

	if type(v4) ~= "table" then
		if v4 ~= "MoveTo" then
			return "Glide"
		end
	elseif v4.key ~= "MoveTo" then
		return "Glide"
	end

	if steal.FLOW and steal.FLOW.MoveTo then
		return "MoveTo"
	end

	if steal.METODE.wanti then
		return "Glide"
	end
	steal.METODE.wanti = true
	tbl.LOG.warn("FLOW", "Steal Method MoveTo belum terpasang - dipakai Glide")
	return "Glide"
end

steal.FLOW.MoveTo = function(arg)
	return steal.MT.Jalan(arg, 45)
end

steal.FLOW.Pindah = function(arg, arg2)
	if steal.TM.BolehKeluar(arg) then
		if steal.FLOW.PakaiMT() then
			return steal.FLOW.MoveTo(arg, arg2)
		end
		return steal.FLOW.Glide(arg, arg2)
	end

	return false
end

steal.FLOW.Pulang = function(arg)
	return steal.FLOW.Glide(arg)
end

steal.tabrakMati = {}

steal.PulihTabrak = function()
	for k in pairs(steal.tabrakMati) do
		if k and k.Parent then
			pcall(function()
				k.CanCollide = true
			end)
		end
	end

	table.clear(steal.tabrakMati)
end

steal.FLOW.Glide = function(arg, arg2)
	if steal.TM.BolehKeluar(arg) then
		local character = localPlayer.Character
		local v4 = fn2()

		if character then
			if v4 then
				local position = v4.Position

				if typeof(arg) == "CFrame" then
					arg = arg.Position or arg
				end

				local n3 = math.clamp((arg - position).Magnitude / (arg2 or steal.FLOW.LAJU), 0.05, 20)
				local tabrakMati = steal.tabrakMati
				local now = os.clock()

				while os.clock() - now < n3 do
					if steal.Running then
						local character2 = localPlayer.Character

						if character2 then
							if character2.Parent then
								local n4 = math.clamp((os.clock() - now) / n3, 0, 1)
								local v5 = position:Lerp(arg, n4)
								local humanoidRootPart = character2:FindFirstChild("HumanoidRootPart")

								if humanoidRootPart then
									humanoidRootPart.AssemblyLinearVelocity = Vector3.zero
									humanoidRootPart.AssemblyAngularVelocity = Vector3.zero
								end

								for _, descendant in ipairs(character2:GetDescendants()) do
									if descendant:IsA("BasePart") and descendant.CanCollide then
										tabrakMati[descendant] = true
										descendant.CanCollide = false
									end
								end

								character2:PivotTo(CFrame.new(v5, arg))
								runService.Heartbeat:Wait()
								continue
							end

							break
						end

						break
					end

					break
				end

				local character2 = localPlayer.Character

				if character2 and character2.Parent then
					character2:PivotTo(CFrame.new(arg))
				end

				steal.PulihTabrak()
				local v5 = fn2()
				local flag2 = v5 ~= nil
				if flag2 then
					return (v5.Position - arg).Magnitude <= 12
				end
				return flag2
			end

			return false
		end

		return false
	end

	return false
end

steal.FLOW.Tahan = function(arg, arg2, arg3)
	local cframe = CFrame.new(arg)
	local now = os.clock()
	local n3 = now + arg2
	local n4 = arg3 or 0
	local v4 = if n4 > 0 then now + arg2 * (steal.FPS_MAKS or 4) else n3
	local n5 = 0

	while steal.Gerak() do
		local now2 = os.clock()
		if n3 <= now2 and n4 <= n5 then
			return true
		end

		if not (v4 <= now2) then
			local v5 = fn2()

			if v5 then
				if v5.Parent then
					steal.Tulis(v5, cframe, false)
					n5 += 1
					runService.Heartbeat:Wait()
					continue
				end

				return false
			end

			return false
		end

		break
	end

	return true
end

steal.FLOW.UidDekat = function(arg, arg2, arg3, arg4)
	local tbl2 = nil

	for _, v4 in pairs(steal.FieldRecords()) do
		if tostring(v4.AssetCategory) == arg2 and (not arg4 or tostring(v4.State) == arg4) then
			local bottomCFrame = v4.BottomCFrame or v4.BoundsCFrame

			if typeof(bottomCFrame) == "CFrame" then
				local magnitude = (bottomCFrame.Position - arg).Magnitude

				if magnitude < (arg3 or 30) and (not tbl2 or magnitude < tbl2.d) then
					tbl2 = { d = magnitude, uid = tostring(v4.Uid), pos = bottomCFrame.Position }
				end
			end
		end
	end

	if tbl2 then
		return tbl2.uid, tbl2.pos
	end
	return tbl2, tbl2
end

steal.FLOW.SIBUK_MAKS = 60
local fn19

do
	steal.FLOW.sibukAt = 0

	steal.FLOW.Sibuk = function()
		local sibukAt = steal.FLOW.sibukAt
		local flag2 = sibukAt > 0
		if flag2 then
			return os.clock() - sibukAt < steal.FLOW.SIBUK_MAKS
		end
		return flag2
	end

	steal.FLOW.REGRAB_MAKS = 3
	steal.FLOW.REGRAB_CEK = 1.2
	steal.FLOW.REGRAB_JALUR = 250
	steal.FLOW.REGRAB_FOREST = 90

	local function fn20(arg, arg2, arg3)
		local n3 = arg3 - arg2
		local v4 = n3:Dot(n3)
		if not (v4 < 1e-06) then
			return (arg - arg2 + n3 * math.clamp((arg - arg2):Dot(n3) / v4, 0, 1)).Magnitude
		end
		return (arg - arg2).Magnitude
	end

	steal.FLOW.JatuhDiJalan = function(arg, arg2, arg3)
		local v4 = nil
		local str2 = nil
		local v5 = nil

		for _, v6 in pairs(steal.FieldRecords()) do
			if tostring(v6.State) == "Dropped" and tostring(v6.AssetCategory) == arg and typeof(v6.BottomCFrame) == "CFrame" then
				local position = v6.BottomCFrame.Position

				if steal.FLOW.REGRAB_FOREST < (position - arg3).Magnitude then
					local v7 = fn20(position, arg2, arg3)

					if v7 <= steal.FLOW.REGRAB_JALUR and (not v4 or v7 < v4) then
						str2 = tostring(v6.Uid)
						v4 = v7
						v5 = position
					end
				end
			end
		end

		return str2, v5
	end

	steal.FLOW.CekBawa = function(arg, arg2, arg3, arg4)
		local n3 = os.clock() + steal.FLOW.REGRAB_CEK

		while true do
			if not (os.clock() < n3) or not steal.Running then
				return "aman"
			else
				local v4, v5 = steal.FLOW.JatuhDiJalan(arg, arg3, arg4)
				if v4 then
					return "jatuh", v4, v5
				end

				if arg2 and steal.IsHolding(arg2) then
					return "aman"
				end

				if steal.HeldUid() then
					break
				end
				local v6 = fn2()

				if v6 then
					steal.Tulis(v6, CFrame.new(arg4), false)
				end

				runService.Heartbeat:Wait()
			end
		end

		return "aman"
	end

	steal.FLOW.PungutLagi = function(arg, arg2, arg3)
		local EggWorld = tbl.NET.Get("EggWorld", "AskFieldEggCarry")

		if EggWorld then
			local n3 = arg3 + Vector3.new(0, steal.FLOW.BERDIRI, 0)
			steal.FLOW.Glide(n3)
			steal.FLOW.Tahan(n3, 0.1)
			local n4 = os.clock() + steal.FLOW.ANGKAT_MAKS
			local n5 = 0
			local v4 = nil

			while os.clock() < n4 and steal.Running do
				n5 += 1
				local v5 = table.pack(pcall(EggWorld.InvokeServer, EggWorld, { Uid = arg2 }))
				if v5[1] and v5[2] == true then
					tbl.LOG.info("FLOW", ("pungut ulang %s: diterima di tembakan %d"):format(arg, n5))
					return arg2
				end
				v4 = if v5[1] then tostring(v5[3] or v5[2]) else "galat: " .. tostring(v5[2])
				steal.EnterGameplay()
				steal.FLOW.Tahan(n3, 0.08)
				arg2 = steal.FLOW.UidDekat(arg3, arg, 30) or arg2
			end

			if steal.IsHolding(arg2) then
				tbl.LOG.info("FLOW", ("pungut ulang %s: record Carried oleh kita"):format(arg))
				return arg2
			end
			tbl.LOG.warn("FLOW", ("pungut ulang %s ditolak %dx - alasan terakhir: %s"):format(arg, n5, tostring(v4)))
			return nil
		end

		return nil
	end

	steal.FLOW.Ambil = function(arg)
		steal.FLOW.sibukAt = os.clock()
		steal.JAUH.Tutup(arg)
		local v4 = steal.FLOW.PakaiMT()

		local function fn21()
			steal.FLOW.sibukAt = 0
			steal.FLOW.samar = false
			steal.JAUH.Buka()
			return nil
		end

		local EggWorld = tbl.NET.Get("EggWorld", "AskFieldEggCarry")
		local EggWorld2 = tbl.NET.Get("EggWorld", "AskFieldEggDrop")

		if EggWorld then
			if EggWorld2 then
				local n3 = arg.pos + Vector3.new(0, steal.FLOW.BERDIRI, 0)
				local n4 = arg.pos + Vector3.new(0, steal.FLOW.ATAS, 0)
				local flag2 = steal.FLOW.RUANGAN[fn16(arg.area)] == true

				if steal.SEMBUNYI.SAKLAR then
					if flag2 then
						steal.SEMBUNYI.Pasang()
					else
						steal.SEMBUNYI.Lepas()
					end
				end

				local flag3

				if flag2 then
					local enabled = steal.JAUH.DECOY and steal.TP.Enabled and steal.FLOW.MilikAutoSteal() and steal.FLOW.TitikArea(steal.FLOW.SAMAR.PENUTUP)

					if enabled then
						fn4(("gliding to %s"):format(steal.FLOW.SAMAR.PENUTUP))
						steal.FLOW.Pindah(enabled, steal.FLOW.LajuPergi())
					end

					steal.FLOW.samar = true
					pcall(steal.TP.Clear)
					pcall(steal.TP.Setup, CFrame.new(n3), n3)
					pcall(steal.TP.CharHidden, true)
					pcall(steal.TP.KedutMulai)
					fn4(("heuristic for %s (%s)"):format(arg.name, arg.area))

					if steal.RUANG.BOOST and not v4 then
						fn4(("boost steal to %s in %s"):format(arg.name, arg.area))
						local v5, v6 = steal.RUANG.Boost(n3)

						if v5 then
							fn4(("landed %.0f studs from %s"):format(v6 or 0, arg.name))
							flag3 = true
						else
							tbl.LOG.warn("RUANG", ("boost gagal (jarak %s) - mundur ke alur lama"):format(tostring(if v6 then math.floor(v6) else "?")))
							flag3 = false
							if steal.RUANG.DiDalam() and not steal.RUANG.Keluar() then
								steal.MT.Darat(3)
								return (fn21())
							end
						end
					else
						if not steal.RUANG.Masuk() then
							steal.MT.Darat(3)
							return (fn21())
						end

						if not steal.RUANG.Keluar() then
							steal.MT.Darat(3)
							return (fn21())
						end

						if steal.FLOW.RUANG_DIAM > 0 then
							local v5 = fn2()

							if v5 then
								fn4("settling at light dark")
								steal.FLOW.Tahan(v5.Position, steal.FLOW.RUANG_DIAM)
							end
						end

						flag3 = false
					end
				else
					flag3 = false

					if not v4 then
						fn4(("forest strike before %s (%s)"):format(arg.name, arg.area))
						if not steal.ForestStrike() then
							return (fn21())
						end
					end
				end

				local function fn22()
					if v4 then
						return
					end
					local autoStealEggs = tbl.UIX and tbl.UIX.STEAL and tbl.UIX.STEAL.AutoStealEggs

					if autoStealEggs and autoStealEggs.Get and autoStealEggs.Get() then
						steal.FLOW.samar = true
					end

					if steal.FLOW.samar and (not steal.TP.on or not steal.TP.decoy or not steal.TP.decoy.Parent) then
						pcall(steal.TP.Setup, CFrame.new(n3), n3)
						pcall(steal.TP.CharHidden, true)
						pcall(steal.TP.KedutMulai)
						return
					end
				end

				fn4(("%s to %s in %s"):format(v4 and "walking" or "flying", arg.name, arg.area))

				if flag3 then
					fn4(("at %s in %s"):format(arg.name, arg.area))
				elseif flag2 and steal.FLOW.RUANG_MOVETO[fn16(arg.area)] then
					fn4(("stealing %s in %s"):format(arg.name, arg.area))
					steal.MT.Jalan(n4, 45)
					steal.MT.Darat(2)
				else
					steal.FLOW.Pindah(n4, steal.FLOW.LajuPergi(arg.area))
				end

				steal.EnterGameplay()
				local boostJeda = flag2 and steal.FLOW.RUANG_TAHAN[fn16(arg.area)] or nil

				if flag3 then
					boostJeda = steal.RUANG.BOOST_JEDA
				end

				local flag4 = not v4

				if flag4 then
					if flag2 then
						if boostJeda then
							fn4(("stealing %.1fs before carry"):format(boostJeda))
							fn22()
							steal.FLOW.Tahan(n4, boostJeda, steal.FrameTarget(boostJeda))
						end
					else
						boostJeda = boostJeda or steal.Tahan(arg.area)
						fn4(("stealing %.1fs before carry"):format(boostJeda))
						fn22()
						steal.FLOW.Tahan(n4, boostJeda, steal.FrameTarget(boostJeda))
					end
				end

				fn4(("stealing %s"):format(arg.name))
				local uid = steal.FLOW.UidDekat(arg.pos, arg.name, 30) or arg.uid
				local v5

				if v4 then
					local pos = arg.pos
					v5 = nil

					for i = 1, 3 do
						if steal.Running then
							steal.MT.Rapat(pos, 3)
							local v6, v7 = steal.FLOW.UidDekat(pos, arg.name, 30, "Slot")

							if v6 then
								pos = v7
								uid = v6
							end

							local tbl2 = { Uid = uid }
							local match = uid:match("Forest:(Slot_%d+)")

							if match then
								tbl2.FirstAreaSlotKey = "Forest:" .. match
							end

							pcall(EggWorld.InvokeServer, EggWorld, tbl2)
							local now = os.clock()
							local exitTo = nil

							while os.clock() - now < 0.5 do
								runService.Heartbeat:Wait()
								if steal.MT.Pegang(uid) then
									exitTo = 1
									break
								end

								if steal.HeldUid() ~= uid then
									continue
								end
								exitTo = 2
								break
							end

							if exitTo == 1 then
								v5 = uid
								break
							end

							if exitTo == 2 then
								v5 = uid
								break
							end
							continue
						end

						break
					end

					steal.MT.Darat(2)
				else
					steal.FLOW.Tahan(n3, 0.1)
					local n5 = os.clock() + steal.FLOW.ANGKAT_MAKS

					while true do
						v5 = nil

						if not (os.clock() < n5) then
							break
						else
							if steal.Running then
								local v6 = table.pack(pcall(EggWorld.InvokeServer, EggWorld, { Uid = uid }))
								if v6[1] and v6[2] == true then
									v5 = uid
									break
								end
								steal.EnterGameplay()
								steal.FLOW.Tahan(n3, 0.08)
								uid = steal.FLOW.UidDekat(arg.pos, arg.name, 30) or uid
								continue
							end

							break
						end
					end
				end

				if not v5 then
					v5 = steal.HeldUid()
					if not v5 then
						return (fn21())
					end
				end

				if flag4 then
					local autoStealEggs = tbl.UIX and tbl.UIX.STEAL and tbl.UIX.STEAL.AutoStealEggs

					if autoStealEggs and autoStealEggs.Get and autoStealEggs.Get() then
						steal.FLOW.samar = true
					end
				end

				if steal.FLOW.samar then
					if not steal.TP.on or not steal.TP.decoy or not steal.TP.decoy.Parent then
						pcall(steal.TP.Setup, CFrame.new(n3), n3)
					end

					pcall(steal.TP.Carry, arg.name, arg.rec and arg.rec.AssetScale)
				elseif steal.TP and steal.TP.on then
					pcall(steal.TP.Carry, arg.name, arg.rec and arg.rec.AssetScale)
				end

				local relayBoost = flag3 and steal.FLOW.RELAY_BOOST or steal.JAUH.TITIK
				fn4("flying home")
				steal.FLOW.Pulang(relayBoost)
				local pos = arg.pos

				for i = 1, steal.FLOW.REGRAB_MAKS + 1 do
					local v6, v7, v8 = steal.FLOW.CekBawa(arg.name, v5, pos, relayBoost)
					if v6 ~= "jatuh" then
						break
					end

					if not (steal.FLOW.REGRAB_MAKS < i) then
						fn4(("egg dropped mid-flight - re-grabbing %s"):format(arg.name))
						tbl.LOG.info("FLOW", ("%s jatuh di jalan (%.0f, %.0f) - pungut ulang %d/%d"):format(arg.name, v8.X, v8.Z, i, steal.FLOW.REGRAB_MAKS))
						v5 = steal.FLOW.PungutLagi(arg.name, v7, v8)

						if v5 then
							fn4("flying home")
							steal.FLOW.Pulang(relayBoost)
							pos = v8
							continue
						end

						tbl.LOG.warn("FLOW", ("%s gagal dipungut ulang - putaran dilepas"):format(arg.name))
						return (fn21())
					end

					tbl.LOG.warn("FLOW", ("%s jatuh lagi sesudah %d pungut ulang - putaran dilepas"):format(arg.name, steal.FLOW.REGRAB_MAKS))
					return (fn21())
				end

				fn4("settling at forest")

				if flag3 then
					steal.FLOW.Tahan(relayBoost, steal.FLOW.RELAY_SETTLE)
				else
					local n5 = os.clock() + steal.FLOW.SETTLE_MAKS
					local now = nil

					while os.clock() < n5 do
						if steal.Running then
							local v6 = fn2()

							if v6 then
								if v6.Parent then
									if not (steal.RUANG.DEKAT < (v6.Position - relayBoost).Magnitude) then
										if now then
											if steal.RUANG.TENANG <= os.clock() - now then
												break
											end
										else
											now = os.clock()
										end
									else
										now = nil
									end

									steal.Tulis(v6, CFrame.new(relayBoost), false)
									runService.Heartbeat:Wait()
									continue
								end

								break
							end

							break
						end

						break
					end
				end

				pcall(steal.TP.CharHidden, false)
				steal.JAUH.Fade(true)
				fn4("dropping egg at forest")
				steal.ManualDropAt = os.clock()
				local flow = steal.FLOW
				steal.FLOW.dropUid = nil
				flow.dropPos = nil
				pcall(EggWorld2.InvokeServer, EggWorld2, { Reason = "PlayerRequest" })
				local n5 = os.clock() + steal.FLOW.DROP_TAHAN

				while os.clock() < n5 do
					if steal.Running then
						local v6 = fn2()

						if v6 then
							steal.Tulis(v6, CFrame.new(relayBoost), false)
						end

						local v7, v8 = steal.FLOW.UidDekat(relayBoost, arg.name, 90, "Dropped")

						if v7 then
							local flow2 = steal.FLOW
							steal.FLOW.dropUid = v7
							flow2.dropPos = v8
							break
						end

						runService.Heartbeat:Wait()
						continue
					end

					break
				end

				if steal.FLOW.TM_MAMPIR and (not flag3 or steal.FLOW.TM_MAMPIR_BOOST) then
					local v6 = steal.TM.Pad()

					if v6 then
						fn4("treadmill pulse before re-steal")
						steal.FLOW.Glide(v6.Position + Vector3.new(0, 3.5, 0))
						local Treadmill = tbl.NET.Get("Treadmill", "AskWearStill")
						local n6 = os.clock() + steal.FLOW.TM_PASANG

						if Treadmill then
							while os.clock() < n6 do
								if steal.Running then
									local v7 = table.pack(pcall(Treadmill.InvokeServer, Treadmill))
									if v7[1] and v7[2] == true then
										task.wait(steal.FLOW.TM_DIAM)
										break
									end

									if tostring(v7[3] or v7[2] or ""):find("Already") then
										task.wait(steal.FLOW.TM_DIAM)
										break
									end
									task.wait(0.03)
									continue
								end

								break
							end
						end

						local Treadmill2 = tbl.NET.Get("Treadmill", "AskDoff")

						if Treadmill2 then
							pcall(Treadmill2.InvokeServer, Treadmill2)
						end

						steal.TM.LastGain = 0
					elseif steal.FLOW.MAMPIR then
						fn4("clearing boundary at safe zone")
						steal.FLOW.Glide(steal.STRIP)
						steal.FLOW.Tahan(steal.STRIP, steal.FLOW.MAMPIR_DIAM)
					end
				elseif steal.FLOW.MAMPIR then
					fn4("clearing boundary at safe zone")
					steal.FLOW.Glide(steal.STRIP)
					steal.FLOW.Tahan(steal.STRIP, steal.FLOW.MAMPIR_DIAM)
				end

				fn4("picking up dropped egg")
				local v6 = nil

				for i = 1, steal.FLOW.ULANG_COBA do
					if steal.Running then
						local v7 = steal.HeldUid()
						if v7 then
							v6 = v7
							break
						end
						local now = os.clock()
						local n6 = now + steal.FLOW.ULANG_MAKS
						local dropUid = nil
						local dropPos = nil

						while os.clock() < n6 do
							if steal.Running then
								dropUid, dropPos = steal.FLOW.UidDekat(relayBoost, arg.name, 90, "Dropped")
								if dropUid then
									break
								end

								if i > 1 or os.clock() - now >= steal.FLOW.ULANG_LONGGAR then
									dropUid, dropPos = steal.FLOW.UidDekat(relayBoost, arg.name, 90)
									if dropUid then
										break
									end
								end

								task.wait(0.05)
								continue
							end

							break
						end

						if not dropUid then
							dropUid = steal.FLOW.dropUid
							dropPos = steal.FLOW.dropPos
						end

						if dropUid and dropPos then
							local n7 = dropPos + Vector3.new(0, steal.FLOW.BERDIRI, 0)
							steal.FLOW.Glide(n7)
							fn4(("re-stealing %s (try %d/%d)"):format(arg.name, i, steal.FLOW.ULANG_COBA))
							local n8 = os.clock() + steal.FLOW.ULANG_MAKS

							while os.clock() < n8 do
								if steal.Running then
									local v8 = table.pack(pcall(EggWorld.InvokeServer, EggWorld, { Uid = dropUid }))
									if v8[1] and v8[2] == true then
										v6 = dropUid
										break
									end

									if steal.HeldUid() ~= dropUid then
										steal.FLOW.Tahan(n7, 0.06)
										dropUid = steal.FLOW.UidDekat(dropPos, arg.name, 30) or dropUid
										continue
									end

									v6 = dropUid
									break
								end

								break
							end
						else
							tbl.LOG.warn("FLOW", ("tidak ada sasaran angkat-ulang (percobaan %d/%d)"):format(i, steal.FLOW.ULANG_COBA))
						end

						if v6 then
							break
						end
						local n7 = 0

						for k in pairs(steal.FieldRecords()) do
							n7 += 1
						end

						if n7 ~= 0 then
							if not steal.FLOW.UidDekat(relayBoost, arg.name, 90) then
								tbl.LOG.warn("FLOW", "telur hilang dari titik drop - kemungkinan diambil pemain lain")
								break
							end
						else
							tbl.LOG.warn("FLOW", "snapshot lapangan kosong - belum tentu hilang, percobaan diteruskan")
						end

						task.wait(steal.FLOW.ULANG_JEDA)
						continue
					end

					break
				end

				if v6 and steal.TP and steal.TP.on then
					pcall(steal.TP.Carry, arg.name, arg.rec and arg.rec.AssetScale)
				end

				steal.JAUH.Fade(true)
				if v6 then
					steal.FLOW.sibukAt = 0
					return v6
				end
				local str2 = "tidak ada di snapshot"

				for _, v7 in pairs(steal.FieldRecords()) do
					if tostring(v7.Uid) ~= tostring(v5) then
						continue
					end
					local bottomCFrame = v7.BottomCFrame or v7.BoundsCFrame
					str2 = ("state=%s area=%s jarak-ke-forest=%s"):format(tostring(v7.State), tostring(v7.AreaId), typeof(bottomCFrame) == "CFrame" and ("%.0f"):format((bottomCFrame.Position - relayBoost).Magnitude) or "?")
					break
				end

				local v7 = fn2()
				tbl.LOG.warn("FLOW", ("angkat-ulang gagal | telur %s: %s | kita di %s"):format(tostring(arg.name), str2, v7 and ("%.0f,%.0f,%.0f"):format(v7.Position.X, v7.Position.Y, v7.Position.Z) or "?"))
				return (fn21())
			end

			return (fn21())
		end

		return (fn21())
	end

	steal.TAHAN_BAWAAN = 8

	steal.TAHAN = {
		desert = 3,
		jungle = 3.5,
		snow = 3.5,
		volcano = 3.5,
		abyssocean = 8,
		prehistoric = 8,
		cosmic = 8,
		cherryblossom = 11.5,
		titantemple = 14,
		lightdark = 14,
		enchantedforest = 14,
	}

	steal.Tahan = function(arg)
		local v4 = steal.TAHAN[fn16(arg)]
		if v4 then
			return v4
		end
		return steal.TAHAN_BAWAAN
	end

	steal.PulangSiklus = function(arg)
		if steal.pulang then
			return false
		end

		if steal.HeldUid() then
			return false
		end
		local ok, result = pcall(steal.PulangTeleport, arg)
		steal.pulang = false

		if ok then
			local v4 = fn2()
			local flag2 = v4 ~= nil
			if flag2 then
				return (v4.Position - steal.STRIP).Magnitude <= steal.ARRIVE
			end
			return flag2
		end

		tbl.LOG.warn("STEAL", "teleport pulang gagal: " .. tostring(result))
		return false
	end

	steal.INSTANT.T = {}
	steal.INSTANT.Skip = {}

	steal.INSTANT.Dilewati = function(arg)
		local v4 = steal.INSTANT.Skip[arg]

		if v4 then
			if not (v4 <= os.clock()) then
				return true
			end
			steal.INSTANT.Skip[arg] = nil
			return false
		end

		return false
	end

	steal.INSTANT.ANGKAT_BATAS = 3
	steal.INSTANT.ASK = 0.1
	steal.INSTANT.DEKAT = 4

	steal.INSTANT.Angkat = function(arg, arg2)
		local EggWorld = tbl.NET.Get("EggWorld", "AskFieldEggCarry")
		if not EggWorld then
			return false, nil, "remote AskFieldEggCarry tidak ada", 0
		end
		local cframe = CFrame.new(arg2)
		local n3 = os.clock() + steal.INSTANT.ANGKAT_BATAS
		local n4 = 0
		local n5 = 0

		while steal.Running and os.clock() < n3 do
			if steal.HeldUid() ~= arg then
				local flag2 = false

				for _, v4 in pairs(steal.FieldRecords()) do
					if tostring(v4.Uid) ~= arg then
						continue
					end
					local str2 = tostring(v4.State)
					flag2 = str2 == "Slot" or str2 == "Dropped"
					break
				end

				if flag2 then
					local v4 = fn2()

					if v4 then
						if v4.Parent then
							if steal.INSTANT.DEKAT < (v4.Position - arg2).Magnitude then
								steal.Tulis(v4, cframe, false)
							end

							if n5 <= os.clock() then
								n5 = os.clock() + steal.INSTANT.ASK
								n4 += 1
								local tbl2 = { Uid = arg }
								local match = arg:match("Forest:(Slot_%d+)")

								if match then
									tbl2.FirstAreaSlotKey = "Forest:" .. match
								end

								local function fn21()
									pcall(EggWorld.InvokeServer, EggWorld, tbl2)
								end

								task.spawn(fn21)
							end

							runService.Heartbeat:Wait()
							continue
						end

						return false, nil, "tanpa rig", n4
					end

					return false, nil, "tanpa rig", n4
				end

				return false, nil, "telur sudah tidak tersedia", n4
			end

			return true, arg, "ok", n4
		end

		if steal.HeldUid() ~= arg then
			return false, nil, "carry ditolak sampai batas waktu", n4
		end
		return true, arg, "ok", n4
	end

	steal.INSTANT.PULANG_BATAS = 4

	steal.INSTANT.Antar = function(arg)
		local function fn21()
			for _, v4 in pairs(steal.FieldRecords()) do
				if tostring(v4.Uid) == arg then
					return tostring(v4.State) == "Claimed"
				end
			end

			return true
		end

		local cframe = CFrame.new(steal.STRIP)
		local n3 = os.clock() + steal.INSTANT.PULANG_BATAS

		while steal.Running and os.clock() < n3 do
			if fn21() then
				return true
			end

			if steal.HeldUid() ~= arg then
				break
			end
			local v4 = fn2()

			if v4 and v4.Parent then
				if steal.INSTANT.DEKAT < (v4.Position - steal.STRIP).Magnitude then
					steal.Tulis(v4, cframe, false)
				end

				runService.Heartbeat:Wait()
				continue
			end

			break
		end

		return (fn21())
	end

	steal.INSTANT.Ambil = function(arg)
		local t = {}
		steal.INSTANT.T = t
		local n3 = arg.pos + Vector3.new(0, 2.5, 0)
		n += 1
		steal.SpoofStart()
		steal.PadStart()
		runService.PreSimulation:Wait()
		runService.PreSimulation:Wait()
		local v4 = fn2()

		if v4 then
			if v4.Parent then
				local now = os.clock()
				fn4(("instant: teleport to %s in %s"):format(arg.name, arg.area))
				steal.Tulis(v4, CFrame.new(n3), false)
				runService.PreSimulation:Wait()
				local v5 = fn2()
				t.jarak = if v5 then math.floor((v5.Position - n3).Magnitude) else -1
				t.tp = math.floor((os.clock() - now) * 1000)
				local uid = fn8(n3, arg.name, arg.uid) or arg.uid
				fn4(("instant: carrying %s"):format(arg.name))
				local now2 = os.clock()
				local v6, v7, v8, v9 = steal.INSTANT.Angkat(uid, n3)
				t.angkat = math.floor((os.clock() - now2) * 1000)
				local ok = v6 and 1 or 0
				t.ask = v9
				t.alasan = v8
				t.ok = ok

				if v6 then
					fn4("instant: teleport back to safe zone")
					local now3 = os.clock()
					local v10 = steal.INSTANT.Antar(v7 or uid)
					local pulang = math.floor((os.clock() - now3) * 1000)
					local setor = v10 and 1 or 0
					t.pulang = pulang
					t.setor = setor

					if not v10 then
						tbl.LOG.warn("INSTANT", ("setoran tidak terkonfirmasi dalam %d ms"):format(t.pulang))
						if not v7 then
							return uid
						end
					end

					if v7 then
						return v7
					end
					return uid
				end

				tbl.LOG.warn("INSTANT", ("angkat GAGAL %d tembakan dalam %d ms - %s"):format(v9, t.angkat, tostring(v8)))
				steal.INSTANT.Skip[uid] = os.clock() + 10
				return nil
			end

			t.galat = "tanpa rig"
			return nil
		end

		t.galat = "tanpa rig"
		return nil
	end

	steal.KUNCI = {
		ON = true,
		RADIUS_NEST = 15,
		MAKS_COBA = 5,
		MAKS_TUNGGU = 30,
		LEWATI_DETIK = 90,
		t = nil,
		lewati = {},
	}

	local kunci = steal.KUNCI

	local function fn21(arg, arg2, arg3)
		return ("%s|%s|%d|%d"):format(tostring(arg), tostring(arg2), math.floor(arg3.X / 10 + 0.5), math.floor(arg3.Z / 10 + 0.5))
	end

	local function fn22(arg, arg2, arg3, arg4, arg5)
		if arg2 and tostring(arg2) == arg.uid then
			return true
		end
		local flag2 = arg3 == arg.name

		if flag2 then
			flag2 = arg4 == arg.area

			if flag2 then
				flag2 = arg5 ~= nil
				if flag2 then
					return (arg5 - arg.pos).Magnitude <= kunci.RADIUS_NEST
				end
			end
		end

		return flag2
	end

	kunci.Cocok = function(arg)
		local flag2 = kunci.t ~= nil
		if flag2 then
			return (fn22(kunci.t, arg.uid, arg.name, arg.area, arg.pos))
		end
		return flag2
	end

	kunci.Dilewati = function(arg)
		local v4 = kunci.lewati[fn21(arg.name, arg.area, arg.pos)]
		local flag2 = v4 ~= nil
		if flag2 then
			return os.clock() < v4
		end
		return flag2
	end

	kunci.Lepas = function(arg, arg2)
		local t = kunci.t

		if t then
			if arg2 then
				kunci.lewati[fn21(t.name, t.area, t.pos)] = os.clock() + kunci.LEWATI_DETIK
			end

			kunci.t = nil
			tbl.LOG.info("KUNCI", ("lepas %s (%s) - %s"):format(t.name, t.area, tostring(arg)))
			return
		end
	end

	kunci.Pasang = function(arg)
		if kunci.ON then
			if kunci.t and kunci.Cocok(arg) then
				kunci.t.uid = arg.uid
				kunci.t.tungguSejak = nil
				kunci.t.dicobaAt = os.clock()
				return
			end

			kunci.t = {
				uid = arg.uid,
				name = arg.name,
				area = arg.area,
				pos = arg.pos,
				sejak = os.clock(),
				coba = 0,
				dicobaAt = os.clock(),
			}

			tbl.LOG.info("KUNCI", ("kunci %s (%s)"):format(arg.name, arg.area))
			return
		end
	end

	kunci.Gagal = function(arg)
		local t = kunci.t

		if t then
			t.coba = t.coba + 1
			tbl.LOG.info("KUNCI", ("%s gagal %d/%d - %s"):format(t.name, t.coba, kunci.MAKS_COBA, tostring(arg)))
			if t.coba >= kunci.MAKS_COBA then
				kunci.Lepas(("gagal %d kali"):format(t.coba), true)
				return
			end
			return
		end
	end

	local function fn23(arg)
		local ok, result = pcall(steal.FieldRecords)

		if ok then
			if type(result) ~= "table" then
				return nil
			end
			local flag2 = false
			local v4 = nil
			local v5 = nil

			for _, v6 in pairs(result) do
				local str2 = tostring(v6.State)

				if str2 ~= "Claimed" then
					if tostring(v6.Uid):find(str, 1, true) then
						continue
					end

					if tostring(v6.Uid) ~= arg.uid then
						if tostring(v6.AssetCategory) == arg.name and tostring(v6.AreaId) == arg.area then
							if str2 ~= "Slot" then
								if v4 then
									if str2 == "Dropped" and v4 ~= "Dropped" then
										v4 = str2
										v5 = v6
									end
								else
									v4 = str2
									v5 = v6
								end
							elseif typeof(v6.BottomCFrame) == "CFrame" and (v6.BottomCFrame.Position - arg.pos).Magnitude <= kunci.RADIUS_NEST then
								flag2 = true
							end
						end

						continue
					end

					return str2, v6
				end
			end

			if v4 then
				return v4, v5
			end

			if flag2 then
				return "Slot"
			end
			return nil
		end

		return nil
	end

	local function fn24(arg)
		local position = typeof(arg.BottomCFrame) == "CFrame" and arg.BottomCFrame.Position or fn7(tostring(arg.Uid), nil)

		if position then
			local v4 = fn2()

			return {
				uid = tostring(arg.Uid),
				name = tostring(arg.AssetCategory),
				area = tostring(arg.AreaId),
				rec = arg,
				pos = position,
				dist = v4 and (position - v4.Position).Magnitude or 0,
				jatuh = true,
			}
		end

		return nil
	end

	kunci.Saring = function(arg)
		if kunci.ON then
			local tbl2

			if next(kunci.lewati) ~= nil then
				local now = os.clock()
				tbl2 = {}

				for _, v4 in ipairs(arg) do
					if not kunci.Dilewati(v4) then
						tbl2[#tbl2 + 1] = v4
					end
				end

				for k, v4 in pairs(kunci.lewati) do
					if v4 <= now then
						kunci.lewati[k] = nil
					end
				end
			else
				tbl2 = arg
			end

			local t = kunci.t

			if t then
				for _, v4 in ipairs(tbl2) do
					if fn22(t, v4.uid, v4.name, v4.area, v4.pos) then
						t.tungguSejak = nil
						return { v4 }, "nest"
					end
				end

				local v4, v5 = fn23(t)

				if v4 == "Dropped" and v5 then
					local v6 = fn24(v5)

					if v6 then
						t.uid = v6.uid
						t.tungguSejak = nil
						return { v6 }, "jatuh"
					end
				end

				if v4 ~= nil then
					if v4 ~= "Slot" then
						t.tungguSejak = t.tungguSejak or os.clock()
						if not (kunci.MAKS_TUNGGU < os.clock() - t.tungguSejak) then
							return {}, "tunggu", v4
						end
						kunci.Lepas(("di luar nest > %ds (%s)"):format(kunci.MAKS_TUNGGU, v4), true)
						return tbl2, "bebas"
					end

					kunci.Lepas("tidak lolos filter lagi")
					return tbl2, "bebas"
				end

				kunci.Lepas("sudah tidak ada di lapangan")
				return tbl2, "bebas"
			end

			return tbl2, "bebas"
		end

		return arg, "bebas"
	end

	steal.Cycle = function()
		if not steal.ORDER.Giliran("auto_steal") and not steal.ORDER.Nganggur() then
			fn4("waiting for turn")
			task.wait(0.5)
			return "waiting for turn"
		end

		steal.BuangHaram()
		pcall(steal.BIGVPS.Lapor)
		-- Do not repeatedly push the player toward the safe zone when no
		-- usable egg target exists. The next cycle checks again automatically.
		if not steal.HeldUid() and #steal.Candidates(true) == 0 then
			fn4("waiting for eligible eggs - open Check Auto Steal")
			task.wait(1)
			return "waiting for eligible eggs"
		end
		local v4 = fn2()
		local flag2 = not v4 or steal.RUANG.DiDalam() or (v4.Position - steal.STRIP).Magnitude > steal.ARRIVE
		local flag3 = not flag2

		if not flag2 then
			flag3 = steal.setorAt

			if flag3 then
				flag3 = os.clock() - steal.setorAt < 3
			end
		end

		local segar = steal.MATI and steal.MATI.segar

		if steal.MATI then
			steal.MATI.segar = false
		end

		if segar then
			fn4("restarting right after respawn")
			pcall(steal.SpoofStart)
			pcall(steal.PadStart)
		elseif flag3 then
			fn4("chaining from last deposit")
		else
			if flag2 then
				local returning = steal.PulangSiklus("returning")

				if not returning then
					fn4("heading to safe zone")
					if not steal.GlideRetry(steal.STRIP, 25, 3) then
						return "failed to reach strip"
					end
				end
			else
				fn4("heading to safe zone")
				if not steal.GlideRetry(steal.STRIP, 25, 3) then
					return "failed to reach strip"
				end
			end

			if not steal.ViaStrip() then
				return "safe zone not verified"
			end
		end

		if steal.WallStandby() and not steal.Running then
			return "stopped while wall was up"
		end
		local v5 = steal.Candidates()
		local v6, v7, v8 = steal.KUNCI.Saring(v5)

		if v7 == "tunggu" then
			fn4(("waiting for %s (%s)"):format(steal.KUNCI.t and steal.KUNCI.t.name or "target", tostring(v8 or "out of nest")))

			while steal.Running and v7 == "tunggu" do
				if not steal.ORDER.Giliran("auto_steal") and not steal.ORDER.Nganggur() then
					return "waiting for turn"
				end

				if steal.NightApproaching and steal.NightApproaching(3) then
					steal.KUNCI.Lepas("malam - telur lapangan direset")
					return "aborted: night approaching"
				end
				task.wait(0.5)
				local v9
				v9, v7 = steal.KUNCI.Saring(steal.Candidates(true))
			end

			if not steal.Running then
				return "stopped"
			end
			v6, v7 = steal.KUNCI.Saring(steal.Candidates())
			if v7 == "tunggu" then
				return "locked target still out of nest"
			end
		end

		if v7 == "jatuh" and v6[1] then
			fn4(("chasing dropped %s"):format(v6[1].name))
			tbl.LOG.info("KUNCI", ("%s tergeletak di %.0f, %.0f - dikejar ke sana"):format(v6[1].name, v6[1].pos.X, v6[1].pos.Z))
		end

		if #v6 == 0 then
			local v9 = steal.Roam()
			if #v9 == 0 then
				return steal.Running and "no eligible eggs after free roam" or "auto steal stopped while waiting"
			end
			v6 = steal.KUNCI.Saring(v9)
			if #v6 == 0 then
				return "locked target not available"
			end
		end

		if (steal.TM.on or steal.TM.NaikPasti()) and not steal.TM.DoffPasti(3) then
			return "still mounted on treadmill"
		end
		local v9 = fn12()
		local v10 = steal.PEN.On() and fn13() or nil
		local flag4 = false
		local v11 = nil
		local rec = nil
		local area = nil

		for i, v12 in ipairs(v6) do
			if steal.Running then
				if not (i > 5) then
					if steal.KUNCI.ON then
						if flag4 then
							break
						end

						if not steal.INSTANT.on or not tbl.FLAG.AdminAbuse or not steal.INSTANT.Dilewati(tostring(v12.uid)) then
							steal.KUNCI.Pasang(v12)
							flag4 = true
						end
					end

					local n3 = v12.pos + Vector3.new(0, 2.5, 0)
					steal.BANNER.pos = v12.pos

					if steal.JAUH.DecoyOn() and not steal.TP.on and not steal.FLOW.PakaiMT() then
						steal.TP.Setup(CFrame.new(n3), n3)
					end

					if steal.INSTANT.on and tbl.FLAG.AdminAbuse then
						if steal.INSTANT.Dilewati(tostring(v12.uid)) then
							continue
						end
						v11 = steal.INSTANT.Ambil(v12)

						if v11 then
							rec = v12.rec
							area = v12.area
							steal.RIFT.Kejar(v12.name)
							break
						end

						if steal.TP then
							if steal.TP.on then
								pcall(steal.TP.Clear)
								v11 = nil
							else
								v11 = nil
							end
						else
							v11 = nil
						end

						continue
					end

					if steal.FLOW.Bisa(v12) then
						v11 = steal.FLOW.Ambil(v12)

						if v11 then
							rec = v12.rec
							area = v12.area
							steal.RIFT.Kejar(v12.name)
							break
						end

						if steal.TP then
							if steal.TP.on then
								pcall(steal.TP.Clear)
								v11 = nil
							else
								v11 = nil
							end
						else
							v11 = nil
						end

						continue
					end

					if steal.NightApproaching and steal.NightApproaching(3) then
						fn4("night approaching - aborting steal cycle")

						if steal.TP and steal.TP.on then
							pcall(steal.TP.Clear)
						end

						steal.WallStandby()
						return "aborted: night approaching"
					end

					local name = v12.name
					fn4(("forest strike before %s (%s)"):format(name, v12.area))
					local v13 = fn2()

					if i > 1 or not v13 or (v13.Position - steal.STRIP).Magnitude > steal.ARRIVE then
						name = 3
						steal.GlideRetry(steal.STRIP, 30, name)
						if not steal.ViaStrip() then
							break
						end
					end

					if steal.ForestStrike() then
						local uid = fn8(v12.pos, v12.name, v12.uid) or v12.uid
						pcall(steal.CAM.Mulai)
						fn4(("gliding to %s in %s"):format(v12.name, v12.area))
						local v14 = steal

						if not steal.INSTANT.on then
							name = steal.SPEED_PERGI
						end

						v14.SPEED_FIX = name or nil
						local ok, result = pcall(steal.GlideRetry, n3, 45, 4, uid)
						steal.SPEED_FIX = nil

						if ok and result then
							steal.EnterGameplay()
							fn4(("stealing %s"):format(v12.name))
							local v15, v16 = steal.Carry(uid, n3, 8, v12.name)

							if v15 then
								v11 = v16 or uid
								rec = v12.rec
								area = v12.area

								if steal.TP and steal.TP.on then
									pcall(steal.TP.Carry, v12.name, v12.rec and v12.rec.AssetScale)
								end

								steal.RIFT.Kejar(v12.name)
								break
							end
						end
					end

					if steal.TP then
						if steal.TP.on then
							pcall(steal.TP.Clear)
							v11 = nil
						else
							v11 = nil
						end
					else
						v11 = nil
					end

					continue
				end

				break
			end

			return "stopped"
		end

		if v11 then
			if steal.STASH.On() then
				steal.TP.Clear()
				steal.KUNCI.Lepas("dijatuhkan ke stash")
				return steal.STASH.Leg(v11)
			end

			if steal.BuangHaram() then
				steal.Fails = steal.Fails + 1
				steal.KUNCI.Lepas("telur area terlarang")
				return "dropped forbidden-area egg instead of claiming"
			end

			fn4("running back to safe zone")
			local v12, v13 = steal.Deposit(v11, v9)

			if steal.FLOW then
				steal.FLOW.samar = false
			end

			if steal.TP and steal.TP.on then
				pcall(steal.TP.Clear)
			end

			if v13 then
				steal.Fails = steal.Fails + 1
				steal.KUNCI.Gagal("setor gagal: " .. tostring(v13))
				return v13
			end

			if v12 then
				steal.Claims = steal.Claims + 1
				steal.KUNCI.Lepas("tersetor")
				steal.setorAt = os.clock()

				if rec then
					pcall(steal.WH.Setor, rec, area)
					pcall(steal.AFKM.Catat, rec, area)
				end

				if v10 then
					local v14, v15 = steal.PEN.PlaceNew(v10)

					if v15 > 0 then
						fn4(("placing %d/%d egg(s) to pen"):format(v14, v15))
						tbl.LOG.info("PEN", ("tertanam %d dari %d telur baru"):format(v14, v15))
					end

					return "egg claimed"
				end

				if steal.RIFT.Prioritas then
					local n3 = 0

					for _, v14 in ipairs(steal.Unplaced(steal.RIFT.Resep)) do
						if steal.PEN.Place(v14) then
							n3 += 1
						end
					end

					if n3 > 0 then
						fn4(("planting %d rift recipe egg(s)"):format(n3))
						tbl.LOG.info("RIFT", ("%d telur resep ditanam"):format(n3))
					end

					return "egg claimed"
				end

				return "egg claimed"
			end

			steal.Fails = steal.Fails + 1
			steal.KUNCI.Gagal("telur tidak tersetor")
			return "egg not claimed"
		end

		if steal.TP and steal.TP.on then
			pcall(steal.TP.Clear)
		end

		steal.Fails = steal.Fails + 1

		if steal.KUNCI.ON and steal.KUNCI.t then
			steal.KUNCI.Gagal("steal gagal")
		end

		if steal.Running then
			if steal.KUNCI.t then
				fn4(("steal failed - retrying %s"):format(steal.KUNCI.t.name))
			else
				fn4("all candidates failed - returning to retry")
			end

			steal.PulangSiklus("retry")
		end

		if steal.KUNCI.t then
			return "locked target failed - retrying"
		end
		return "all candidates failed"
	end

	steal.BOOST = {
		on = false,
		simpan = {},
		emitter = {},
		mesh = {},
		tekstur = {},
		kulit = {},
		warnaP = {},
		warnaC = {},
		warnaM = {},
		permP = {},
		permV = {},
		texP = {},
		texC = {},
	}

	steal.BOOST.ABU = Color3.new(0.38823530077934265, 0.37254902720451355, 0.38431373238563538)
	steal.BOOST.TILE_MIN = 8
	steal.BOOST.TEX_BURUK = { ["6905003203"] = true, ["6372755229"] = true }
	steal.BOOST.CAP = 240
	steal.BOOST.CHUNK = 300
	local boost = steal.BOOST
	boost.PENANDA = { SeparationLine = true, TreadmillBottom = true, EggPoint = true }

	steal.BOOST.AMAN = {
		AreaEggSlotsClient = true,
		PlacedEggRenders = true,
		ClientRenderedAssets = true,
		__ClientTreadmillRenders = true,
		Camera = true,
		Terrain = true,
		__SAE_SafeZoneLogo = true,
	}

	steal.BOOST.Abukan = function(arg)
		if arg.Material == Enum.Material.SmoothPlastic and arg.Color == steal.BOOST.ABU then
			return
		end
		local n3 = #steal.BOOST.warnaP + 1
		steal.BOOST.warnaP[n3] = arg
		steal.BOOST.warnaC[n3] = arg.Color
		steal.BOOST.warnaM[n3] = arg.Material
		arg.Color = steal.BOOST.ABU
		arg.Material = Enum.Material.SmoothPlastic
		steal.BOOST.Ratakan(arg)
	end

	local tbl2 = { "TopSurface", "BottomSurface", "LeftSurface", "RightSurface", "FrontSurface", "BackSurface" }
	local smooth = Enum.SurfaceType.Smooth

	steal.BOOST.Ratakan = function(arg)
		local tbl3 = nil

		for i = 1, 6 do
			local v4 = tbl2[i]

			if arg[v4] ~= smooth then
				tbl3 = tbl3 or {}
				tbl3[i] = arg[v4]
				arg[v4] = smooth
			end
		end

		if tbl3 then
			local n3 = #steal.BOOST.permP + 1
			steal.BOOST.permP[n3] = arg
			steal.BOOST.permV[n3] = tbl3
			return
		end
	end

	steal.BOOST.Apply = function()
		steal.BOOST.on = true
		pcall(setfpscap, steal.BOOST.CAP)
		local lighting = tbl.SV.Lighting
		local simpan = steal.BOOST.simpan

		if not simpan.done then
			simpan.done = true
			simpan.shadow = lighting.GlobalShadows
			simpan.fog = lighting.FogEnd
			simpan.cap = type(getfpscap) == "function" and select(2, pcall(getfpscap)) or nil

			local function fn25()
				simpan.mutu = UserSettings():GetService("UserGameSettings").SavedQualityLevel
			end

			pcall(fn25)
		end

		local function fn25()
			UserSettings():GetService("UserGameSettings").SavedQualityLevel = Enum.SavedQualitySetting.QualityLevel1
		end

		pcall(fn25)

		local function fn26()
			lighting.GlobalShadows = false
			lighting.FogEnd = 9e9
		end

		pcall(fn26)

		for _, descendant in ipairs(lighting:GetDescendants()) do
			if descendant:IsA("PostEffect") and descendant.Enabled then
				descendant.Enabled = false
				steal.BOOST.emitter[#steal.BOOST.emitter + 1] = descendant
			end
		end

		local terrain = v:FindFirstChildOfClass("Terrain")

		if terrain then
			local v4 = pcall

			local function fn27()
				if simpan.air == nil then
					simpan.air = {
						terrain.WaterWaveSize,
						terrain.WaterWaveSpeed,
						terrain.WaterReflectance,
						terrain.WaterTransparency,
						terrain.Decoration,
					}
				end

				local v5 = terrain
				terrain.WaterWaveSize = 0
				v5.WaterWaveSpeed = 0
				local v6 = terrain
				terrain.WaterReflectance = 0
				v6.WaterTransparency = 1
				terrain.Decoration = false
			end

			v4(fn27)
		end

		task.spawn(function()
			local character = localPlayer.Character
			local n3 = 0

			for _, child in ipairs(v:GetChildren()) do
				if steal.BOOST.on and not steal.BOOST.AMAN[child.Name] and child ~= character and child ~= v.CurrentCamera then
					if child:IsA("BasePart") then
						steal.BOOST.Abukan(child)
						child.CastShadow = false
					end

					for _, descendant in ipairs(child:GetDescendants()) do
						if steal.BOOST.on then
							if descendant:IsA("MeshPart") then
								steal.BOOST.Abukan(descendant)

								if descendant.RenderFidelity ~= Enum.RenderFidelity.Performance then
									steal.BOOST.mesh[#steal.BOOST.mesh + 1] = { descendant, descendant.RenderFidelity }
									descendant.RenderFidelity = Enum.RenderFidelity.Performance
								end

								descendant.CastShadow = false
							elseif descendant:IsA("BasePart") then
								descendant.CastShadow = false
								steal.BOOST.Abukan(descendant)
							elseif descendant:IsA("ParticleEmitter") or descendant:IsA("Trail") or descendant:IsA("Beam") or descendant:IsA("Smoke") or descendant:IsA("Fire") or descendant:IsA("Sparkles") then
								if descendant.Enabled then
									descendant.Enabled = false
									steal.BOOST.emitter[#steal.BOOST.emitter + 1] = descendant
								end
							elseif descendant:IsA("Texture") then
								local match = tostring(descendant.Texture):match("%d+") or ""

								if descendant.StudsPerTileU < steal.BOOST.TILE_MIN or steal.BOOST.TEX_BURUK[match] then
									if descendant.Transparency < 1 then
										steal.BOOST.tekstur[#steal.BOOST.tekstur + 1] = { descendant, descendant.Transparency }
										descendant.Transparency = 1
									end
								else
									local n4 = #steal.BOOST.texP + 1
									steal.BOOST.texP[n4] = descendant
									steal.BOOST.texC[n4] = descendant.Color3
									descendant.Color3 = steal.BOOST.ABU

									if descendant.Transparency >= 1 then
										descendant.Transparency = 0
									end
								end
							elseif descendant:IsA("Decal") then
								local name = descendant.Parent and descendant.Parent.Name or ""

								if descendant.Transparency < 1 and not steal.BOOST.PENANDA[name] then
									steal.BOOST.tekstur[#steal.BOOST.tekstur + 1] = { descendant, descendant.Transparency }
									descendant.Transparency = 1
								end
							elseif descendant:IsA("SurfaceAppearance") then
								steal.BOOST.kulit[#steal.BOOST.kulit + 1] = { descendant, descendant.Parent }
								descendant.Parent = nil
							end

							n3 += 1

							if n3 % steal.BOOST.CHUNK == 0 then
								task.wait()
							end

							continue
						end

						return
					end
				end
			end

			tbl.LOG.info("FPS", ("boost: %d instance, %d emitter, %d mesh, %d tekstur, %d PBR, %d warna"):format(n3, #steal.BOOST.emitter, #steal.BOOST.mesh, #steal.BOOST.tekstur, #steal.BOOST.kulit, #steal.BOOST.warnaP) .. (" %d texture"):format(#steal.BOOST.texP))
		end)
	end

	steal.BOOST.Restore = function()
		if steal.BOOST.on then
			steal.BOOST.on = false
			local simpan = steal.BOOST.simpan

			if simpan.cap then
				pcall(setfpscap, simpan.cap)
			end

			if simpan.mutu then
				pcall(function()
					UserSettings():GetService("UserGameSettings").SavedQualityLevel = simpan.mutu
				end)
			end

			local lighting = tbl.SV.Lighting

			if simpan.done then
				local function fn25()
					lighting.GlobalShadows = simpan.shadow
					lighting.FogEnd = simpan.fog
				end

				pcall(fn25)
			end

			local terrain = v:FindFirstChildOfClass("Terrain")

			if terrain and simpan.air then
				pcall(function()
					local v4 = terrain
					local v5 = simpan.air[2]
					terrain.WaterWaveSize = simpan.air[1]
					v4.WaterWaveSpeed = v5
					local v6 = terrain
					local v7 = simpan.air[4]
					terrain.WaterReflectance = simpan.air[3]
					v6.WaterTransparency = v7
					terrain.Decoration = simpan.air[5]
				end)
			end

			for _, v4 in ipairs(steal.BOOST.emitter) do
				if v4.Parent then
					local v5 = pcall

					local function fn25()
						v4.Enabled = true
					end

					v5(fn25)
				end
			end

			steal.BOOST.emitter = {}

			for _, v4 in ipairs(steal.BOOST.mesh) do
				if v4[1].Parent then
					pcall(function()
						v4[1].RenderFidelity = v4[2]
					end)
				end
			end

			steal.BOOST.mesh = {}

			for _, v4 in ipairs(steal.BOOST.tekstur) do
				if v4[1].Parent then
					local function fn25()
						v4[1].Transparency = v4[2]
					end

					pcall(fn25)
				end
			end

			steal.BOOST.tekstur = {}

			for _, v4 in ipairs(steal.BOOST.kulit) do
				if v4[2] and v4[2].Parent then
					local function fn25()
						v4[1].Parent = v4[2]
					end

					pcall(fn25)
				end
			end

			steal.BOOST.kulit = {}
			local texP = steal.BOOST.texP
			local texC = steal.BOOST.texC

			for i = 1, #texP do
				local v4 = texP[i]

				if v4 and v4.Parent then
					pcall(function()
						v4.Color3 = texC[i]
					end)
				end
			end

			local boost2 = steal.BOOST
			steal.BOOST.texP = {}
			boost2.texC = {}
			local warnaP = steal.BOOST.warnaP
			local warnaC = steal.BOOST.warnaC
			local warnaM = steal.BOOST.warnaM

			for i = 1, #warnaP do
				local v4 = warnaP[i]

				if v4 and v4.Parent then
					pcall(function()
						v4.Color = warnaC[i]
						v4.Material = warnaM[i]
					end)
				end
			end

			local boost3 = steal.BOOST
			local boost4 = steal.BOOST
			steal.BOOST.warnaP = {}
			boost3.warnaC = {}
			boost4.warnaM = {}
			local permP = steal.BOOST.permP
			local permV = steal.BOOST.permV

			for i = 1, #permP do
				local v4 = permP[i]
				local v5 = permV[i]

				if v4 and v4.Parent and v5 then
					pcall(function()
						while true do
							local v6

							if I_1 <= 0 then
								if not (N_1 >= C_1) then
									break
								end
								v6 = N_1
							else
								if not (N_1 <= C_1) then
									break
								end
								v6 = N_1
							end

							if v5[v6] then
								v4[tbl2[v6]] = v5[v6]
							end
						end
					end)
				end
			end

			local boost5 = steal.BOOST
			steal.BOOST.permP = {}
			boost5.permV = {}
			return
		end
	end

	steal.BOOST.Sync = function()
		local boost2 = tbl.UIX and tbl.UIX.FPS and tbl.UIX.FPS.Boost
		if boost2 and boost2.Get and boost2.Get() then
			steal.BOOST.Apply()
			return
		end
		steal.BOOST.Restore()
	end

	steal.HIDE = { on = false, cx = {}, Dibuang = 0 }
	steal.HIDE.FOLDER = { "ClientRenderedAssets", "PlacedEggRenders" }

	steal.HIDE.Punyaku = function(arg)
		local attribute = arg:GetAttribute("OwnerUserId")
		if attribute ~= nil then
			return tostring(attribute) == str
		end
		return tostring(arg.Name):sub(1, #str + 1) == str .. "_"
	end

	steal.HIDE.Buang = function(arg)
		if not arg or not arg.Parent then
			return
		end

		if steal.HIDE.Punyaku(arg) then
			return
		end

		if pcall(function()
			arg:Destroy()
		end) then
			steal.HIDE.Dibuang = steal.HIDE.Dibuang + 1
			return
		end
	end

	steal.HIDE.Sweep = function()
		for _, v4 in ipairs(steal.HIDE.FOLDER) do
			local v5 = v:FindFirstChild(v4)

			for _, v6 in ipairs(v5 and v5:GetChildren() or {}) do
				steal.HIDE.Buang(v6)
			end
		end
	end

	steal.HIDE.Start = function()
		if steal.HIDE.on then
			return
		end
		steal.HIDE.on = true

		for _, v4 in ipairs(steal.HIDE.FOLDER) do
			local v5 = v:FindFirstChild(v4)

			if v5 then
				steal.HIDE.cx[#steal.HIDE.cx + 1] = v5.ChildAdded:Connect(function(child)
					if steal.HIDE.on then
						steal.HIDE.Buang(child)
						return
					end
				end)
			end
		end

		steal.HIDE.Sweep()
		tbl.LOG.info("FPS", ("buang visual orang lain: %d dihapus"):format(steal.HIDE.Dibuang))
	end

	local function stop()
		if steal.HIDE.on then
			steal.HIDE.on = false

			for _, v4 in ipairs(steal.HIDE.cx) do
				pcall(function()
					v4:Disconnect()
				end)
			end

			steal.HIDE.cx = {}
			tbl.LOG.info("FPS", "buang visual orang lain berhenti")
			return
		end
	end

	steal.HIDE.Stop = stop

	steal.HIDE.Sync = function()
		local deleteOthers = tbl.UIX and tbl.UIX.FPS and tbl.UIX.FPS.DeleteOthers
		if deleteOthers and deleteOthers.Get and deleteOthers.Get() then
			steal.HIDE.Start()
			return
		end
		steal.HIDE.Stop()
	end

	tbl.ST.Trove:Add(steal.BOOST.Restore)
	tbl.ST.Trove:Add(steal.HIDE.Stop)
	steal.HOP = { All = {}, Cursor = { "" }, Blok = 1, Page = 1, Solo = 0, More = false, busy = false }
	steal.HOP.LIMIT = 100
	steal.HOP.PER = 8
	steal.HOP.JEDA_API = 6
	steal.HOP.JEDA_429 = 8
	steal.HOP.reqAkhir = 0
	steal.HOP.JEDA = 4
	steal.HOP.JEDA_BANJIR = 12
	steal.HOP.MAKS_COBA = 5
	steal.HOP.BOOT_URL = "https://raw.githubusercontent.com/neptunus48/asdas/refs/heads/main/omak.lua"

	steal.HOP.Req = function(arg)
		local request_ = request or http_request or syn and syn.request
		if type(request_) ~= "function" then
			return nil, "executor has no request()"
		end
		local str2 = ("https://games.roblox.com/v1/games/%d/servers/Public?sortOrder=Asc&limit=%d"):format(tbl.PlaceId, steal.HOP.LIMIT)

		if arg and arg ~= "" then
			str2 ..= "&cursor=" .. arg
		end

		local n3 = steal.HOP.JEDA_API - os.clock() - (steal.HOP.reqAkhir or 0)

		if n3 > 0 then
			steal.HOP.Kabar(("Cooling down %ds (Roblox API limit)"):format(math.ceil(n3)))
			task.wait(n3)
		end

		steal.HOP.reqAkhir = os.clock()
		local ok, result = pcall(request_, { Url = str2, Method = "GET" })

		if ok then
			if type(result) ~= "table" then
				return nil, "request failed"
			end

			if result.Body then
				if tonumber(result.StatusCode) ~= 429 then
					local httpService = tbl.SV.HttpService
					local ok2, result2 = pcall(httpService.JSONDecode, httpService, result.Body)
					if ok2 and type(result2) == "table" and type(result2.data) == "table" then
						return result2
					end
					return nil, ("balasan tidak terbaca (HTTP %s)"):format(tostring(result.StatusCode))
				end

				steal.HOP.reqAkhir = os.clock() + steal.HOP.JEDA_429
				return nil, "RATE"
			end

			return nil, "request failed"
		end

		return nil, "request failed"
	end

	steal.HOP.Kabar = function(text)
		local uix = tbl.UIX
		local pageLabel = uix and uix.HOP and uix.HOP.PageLabel

		if pageLabel then
			pcall(function()
				pageLabel.Text = text
			end)

			return
		end
	end

	local function load(arg)
		if steal.HOP.busy then
			return
		end
		steal.HOP.busy = true
		local n3 = math.max(1, math.ceil(#steal.HOP.All / steal.HOP.PER))

		if arg == "next" and steal.HOP.Page < n3 then
			local hop = steal.HOP
			local page = steal.HOP.Page
			hop.Page = page + 1
			steal.HOP.busy = false
			steal.HOP.Render()
			return
		end

		if arg == "prev" and steal.HOP.Page > 1 then
			steal.HOP.Page = steal.HOP.Page - 1
			steal.HOP.busy = false
			steal.HOP.Render()
			return
		end

		local blok = steal.HOP.Blok
		local blok2

		if arg ~= "refresh" then
			if arg == "next" and steal.HOP.More then
				blok2 = blok + 1
			else
				if arg ~= "prev" or not (blok > 1) then
					steal.HOP.busy = false
					steal.HOP.Kabar(#steal.HOP.All ~= 0 and "End of list" or "No servers loaded - press Refresh")
					return
				end

				blok2 = blok - 1
			end
		else
			steal.HOP.Cursor = { "" }
			blok2 = 1
		end

		steal.HOP.Kabar("Loading servers...")
		local v4, v5 = steal.HOP.Req(steal.HOP.Cursor[blok2] or "")

		if v4 then
			local str2 = tostring(game.JobId)
			local all = {}
			local solo = 0

			for _, v6 in ipairs(v4.data) do
				local n4 = tonumber(v6.playing) or 0
				local n5 = tonumber(v6.maxPlayers) or 0

				if tostring(v6.id) ~= str2 then
					if n5 > 0 then
						if not (n4 < n5) then
							continue
						end
					elseif not (n4 < 7) then
						continue
					end

					if n4 == 1 then
						solo += 1
					end

					all[#all + 1] = {
						id = tostring(v6.id),
						main = tonumber(v6.playing) or 0,
						max = tonumber(v6.maxPlayers) or 0,
						ping = tonumber(v6.ping) or 0,
						fps = tonumber(v6.fps) or 0,
					}
				end
			end

			local function fn25(arg2)
				local kind = type(arg2)
				if kind == "number" and arg2 > 0 and arg2 < 2000 and arg2 then
					return arg2
				end
				return 999
			end

			local function fn26(arg2, arg3)
				if arg2.main ~= arg3.main then
					return arg2.main < arg3.main
				end
				return fn25(arg2.ping) < fn25(arg3.ping)
			end

			table.sort(all, fn26)
			local hop = steal.HOP
			local hop2 = steal.HOP
			steal.HOP.All = all
			hop.Solo = solo
			hop2.Blok = blok2
			steal.HOP.Page = arg ~= "prev" and 1 or math.max(1, math.ceil(#all / steal.HOP.PER))
			steal.HOP.More = v4.nextPageCursor ~= nil and v4.nextPageCursor ~= ""

			if steal.HOP.More then
				steal.HOP.Cursor[blok2 + 1] = tostring(v4.nextPageCursor)
			end

			steal.HOP.busy = false
			steal.HOP.Render()
			return
		end

		steal.HOP.busy = false

		if v5 ~= "RATE" then
			steal.HOP.Kabar("Failed: " .. tostring(v5))
			tbl.LOG.warn("HOP", "gagal ambil daftar server: " .. tostring(v5))
			return
		end

		steal.HOP.Kabar(("Roblox API busy - retrying in %ds"):format(steal.HOP.JEDA_429))
		tbl.LOG.warn("HOP", "HTTP 429 dari daftar server - coba ulang terjadwal")

		local function fn25()
			if steal.HOP.busy then
				return
			end
			steal.HOP.Load(arg)
		end

		task.delay(steal.HOP.JEDA_429, fn25)
	end

	steal.HOP.Load = load

	steal.HOP.Render = function()
		local uix = tbl.UIX
		local listHost = uix and uix.HOP and uix.HOP.ListHost

		if listHost then
			for _, child in ipairs(listHost:GetChildren()) do
				if child:IsA("Frame") then
					child:Destroy()
				end
			end

			local per = steal.HOP.PER
			local n3 = (steal.HOP.Page - 1) * per
			local n4 = math.max(1, math.ceil(#steal.HOP.All / per))

			for i = 1, per do
				local v4 = steal.HOP.All[n3 + i]
				if not v4 then
					break
				end
				local serverRow = uix.ServerRow

				local tbl3 = {
					title = ("%s #%d • %d/%d"):format(v4.main == 1 and "Solo Server" or "Server", n3 + i, v4.main, v4.max),
					sub = ("host %d ms • %.1f FPS • ID %s"):format(v4.ping, v4.fps, v4.id:sub(1, 8)),
				}

				local function fn25()
					steal.HOP.Go(v4.id)
				end

				serverRow(listHost, i, tbl3, fn25)
			end

			if #steal.HOP.All == 0 then
				steal.HOP.Kabar("No servers found")
				return
			end
			steal.HOP.Kabar(("Page %d / %d%s (%d Solo)"):format(steal.HOP.Page, n4, steal.HOP.More and "+" or "", steal.HOP.Solo))
			return
		end
	end

	local hop = steal.HOP
	steal.HOP.calon = {}
	hop.idx = 0

	local tbl3 = {
		[Enum.TeleportResult.Failure] = "server refused the join",
		[Enum.TeleportResult.GameNotFound] = "server no longer exists",
		[Enum.TeleportResult.GameEnded] = "server already shut down",
		[Enum.TeleportResult.GameFull] = "server is full",
		[Enum.TeleportResult.Unauthorized] = "not allowed to join that server",
		[Enum.TeleportResult.Flooded] = "too many teleport attempts",
		[Enum.TeleportResult.IsTeleporting] = "a teleport is already running",
	}

	steal.HOP.Jaga = function()
		if steal.HOP.cx then
			return
		end
		local TeleportService = game:FindService("TeleportService")

		if TeleportService then
			steal.HOP.cx = tbl.ST.Trove:Connect(TeleportService.TeleportInitFailed, function(arg, arg2, arg3)
				if arg ~= localPlayer then
					return
				end

				if steal.HOP.pindah then
					local name = typeof(arg2) == "EnumItem" and arg2.Name or tostring(arg2)
					local v4 = tbl3[arg2] or (if arg3 and tostring(arg3) ~= "" then tostring(arg3) else "unknown")
					tbl.LOG.warn("HOP", ("calon %d/%d ditolak: %s - %s"):format(steal.HOP.idx, #steal.HOP.calon, name, v4))
					steal.HOP.Kabar(("Hop failed: %s"):format(v4))
					local jedaBanjir = arg2 == Enum.TeleportResult.Flooded and steal.HOP.JEDA_BANJIR or steal.HOP.JEDA

					local function fn25()
						if steal.HOP.pindah then
							steal.HOP.Lanjut()
							return
						end
					end

					task.delay(jedaBanjir, fn25)
					return
				end
			end)

			return
		end
	end

	steal.HOP.Lanjut = function()
		local TeleportService = game:FindService("TeleportService")
		if not TeleportService then
			steal.HOP.pindah = false
			return
		end
		steal.HOP.idx = steal.HOP.idx + 1
		local v4 = steal.HOP.calon[steal.HOP.idx]

		if not v4 then
			steal.HOP.pindah = false
			tbl.LOG.warn("HOP", "semua calon menolak - teleport biasa")
			steal.HOP.Kabar("All candidates refused - joining any server")

			local function fn25()
				TeleportService:Teleport(tbl.PlaceId, localPlayer)
			end

			pcall(fn25)
			return
		end

		tbl.LOG.warn("HOP", ("pindah ke server %s (calon %d/%d)"):format(v4:sub(1, 8), steal.HOP.idx, #steal.HOP.calon))

		local function fn25()
			TeleportService:TeleportToPlaceInstance(tbl.PlaceId, v4, localPlayer)
		end

		pcall(fn25)
	end

	steal.HOP.Go = function(arg, arg2)
		if game:FindService("TeleportService") then
			if steal.HOP.pindah then
				return false
			end
			local str2 = tostring(game.JobId)
			local v4 = if arg then tostring(arg) else nil

			if v4 ~= str2 then
				local calon = {}

				if v4 then
					calon[1] = v4
				end

				for _, v5 in ipairs(steal.HOP.All) do
					if not (steal.HOP.MAKS_COBA <= #calon) then
						if v5.id ~= str2 and v5.id ~= v4 then
							calon[#calon + 1] = v5.id
						end

						continue
					end

					break
				end

				if #calon ~= 0 then
					local hop2 = steal.HOP
					local hop3 = steal.HOP
					steal.HOP.calon = calon
					hop2.idx = 0
					hop3.pindah = true
					steal.HOP.Jaga()
					steal.HOP.Arm(arg2)

					local function fn25()
						steal.HOP.pindah = false
					end

					task.delay(#calon * steal.HOP.JEDA_BANJIR + 20, fn25)
					steal.HOP.Lanjut()
					return true
				end

				tbl.LOG.warn("HOP", "tidak ada server lain")
				return false
			end

			tbl.LOG.warn("HOP", "itu server yang sedang dimainkan")
			return false
		end

		tbl.LOG.warn("HOP", "TeleportService tidak ada")
		return false
	end

	steal.HOP.Emptiest = function(arg)
		if #steal.HOP.All == 0 then
			steal.HOP.Load("refresh")
		end

		if #steal.HOP.All ~= 0 then
			return steal.HOP.Go(steal.HOP.All[1].id, arg)
		end

		if not steal.HOP.busy then
			steal.HOP.Kabar("No other server available")
		end

		tbl.LOG.warn("HOP", "tidak ada server lain")
		return false
	end

	steal.HOP.AutoOn = function()
		local autoExec = tbl.UIX and tbl.UIX.HOP and tbl.UIX.HOP.AutoExec
		if not autoExec or not autoExec.Get then
			return (tbl.CFG and tbl.CFG.Get and tbl.CFG.Get("AutoExecute", false)) == true
		end

		if autoExec.Get() then
			return true
		end
		return false
	end

	steal.HOP.SetClosed = function()
		pcall(function()
			local str2 = tbl.FS.Root .. "/_closed.flag"
			if type(isfile) == "function" and type(delfile) == "function" and isfile(str2) then
				delfile(str2)
				return
			end
		end)
	end

	steal.HOP.Arm = function(arg)
		if not arg and not steal.HOP.AutoOn() then
			return false
		end
		local queueOnTeleport = queueonteleport or queue_on_teleport or syn and syn.queue_on_teleport or fluxus and fluxus.queue_on_teleport
		if type(queueOnTeleport) ~= "function" then
			tbl.LOG.warn("HOP", "eksekutor tanpa queueonteleport")
			return false
		end

		local str2 = ([[task.spawn(function()
    pcall(function()
        if not game:IsLoaded() then
            game.Loaded:Wait()
        end
    end)
    task.wait(2)

    local url = %q
    local src = nil
    for _ = 1, 5 do
        local ok, res = pcall(function() return game:HttpGet(url) end)
        if ok and type(res) == "string" and #res > 1000 then
            src = res
            break
        end
        task.wait(1.5)
    end

    if not src then
        warn("[SAE] auto execute: gagal mengambil script dari GitHub")
        return
    end

    local ok, err = pcall(function() loadstring(src, "=SAE_New")() end)
    if not ok then
        warn("[SAE] auto execute gagal: " .. tostring(err))
    end
end)
]]):format(steal.HOP.BOOT_URL)

		local ok = pcall(queueOnTeleport, str2)
		if ok then
			tbl.LOG.info("HOP", "auto execute dititipkan (GitHub pure)")
			return ok
		end
		return ok
	end

	steal.WH = {
		Antre = {},
		Kirim = 0,
		Gagal = 0,
		seen = {},
		thumb = {},
		busy = false,
		on = false,
		PESAN = "-",
	}

	steal.WH.PENGIRIM = "S2r Hub"
	steal.WH.LOGO = ""
	steal.WH.FLAG_V2 = 32768
	steal.WH.JEDA = 0.6
	steal.WH.TICK = 5
	steal.WH.LUPA = 300

	local tbl4 = {
		"^https://discord%.com/api/webhooks/%d+/.+",
		"^https://canary%.discord%.com/api/webhooks/%d+/.+",
		"^https://ptb%.discord%.com/api/webhooks/%d+/.+",
		"^https://discordapp%.com/api/webhooks/%d+/.+",
	}

	steal.WH.Sah = function(arg)
		if type(arg) ~= "string" then
			return false
		end

		if not (#arg < 40) then
			if not (#arg > 2000) then
				for _, v4 in ipairs(tbl4) do
					if arg:match(v4) then
						return true
					end
				end

				return false
			end

			return false
		end

		return false
	end

	fn19 = function(arg, arg2)
		local webhook = tbl.UIX and tbl.UIX.WEBHOOK and tbl.UIX.WEBHOOK[arg]

		if webhook then
			if webhook.Get then
				local v4 = webhook.Get()
				if v4 ~= nil then
					return v4
				end
				return arg2
			end

			return arg2
		end

		return arg2
	end

	steal.WH.Url = function()
		local match = tostring(fn19("URL", "") or ""):match("^%s*(.-)%s*$")
		if steal.WH.Sah(match) and match then
			return match
		end
		return nil
	end

	local function nyala()
		local flag2 = steal.WH.Url() ~= nil
		if flag2 then
			return fn19("Enable", false) == true
		end
		return flag2
	end

	steal.WH.Nyala = nyala
end

steal.WH.LolosRarity = function(arg, arg2)
	local webhook = tbl.UIX and tbl.UIX.WEBHOOK and tbl.UIX.WEBHOOK[arg]

	if webhook then
		if webhook.Any then
			if webhook.Has then
				if webhook.Any() then
					if webhook.Has(arg2) then
						return true
					end
					return false
				end

				return true
			end

			return true
		end

		return true
	end

	return true
end

do
	local function fn20()
		local v4 = request

		if not v4 then
			v4 = http_request

			if not v4 then
				v4 = syn
				if v4 then
					return syn.request
				end
			end
		end

		return v4
	end

	local function fn21(arg)
		if type(arg) == "table" then
			local num = tonumber(arg.StatusCode or arg.Status or arg.status_code)
			if num then
				return num
			end
		end

		return nil
	end

	local function fn22(arg)
		if type(arg) ~= "table" then
			return ""
		end
		return (tostring(arg.Body or arg.body or ""))
	end

	steal.WH.Opsi = function(arg)
		return arg .. (arg:find("?", 1, true) and "&" or "?") .. "with_components=true&wait=true"
	end

	steal.WH.Submit = function(arg, arg2)
		local v4 = fn20()
		if type(v4) ~= "function" then
			return false, "executor has no request()"
		end
		local json = tbl.SV.HttpService:JSONEncode(arg2)

		for i = 1, 3 do
			local ok, result = pcall(v4, {
				Url = steal.WH.Opsi(arg),
				Method = "POST",
				Headers = { ["Content-Type"] = "application/json" },
				Body = json,
			})

			if ok then
				local v5 = fn21(result)
				if v5 and v5 >= 200 and v5 < 300 then
					return true
				end

				if v5 ~= 429 or not (i < 3) then
					return false, ("Discord menolak (HTTP %s)"):format(tostring(v5 or "?"))
				end

				local function fn23()
					return tbl.SV.HttpService:JSONDecode(fn22(result))
				end

				local ok2, result2 = pcall(fn23)
				task.wait(math.clamp(ok2 and type(result2) == "table" and tonumber(result2.retry_after) or 1, 0.5, 10))
				continue
			end

			return false, "HTTP request failed"
		end

		return false, "still rate limited after 3 attempts"
	end

	local function fn23(arg)
		return { type = 10, content = arg }
	end

	local function fn24()
		return { type = 14, divider = true, spacing = 1 }
	end

	local function fn25(arg, arg2)
		return { type = 11, media = { url = arg }, description = arg2, spoiler = false }
	end

	local function fn26(arg, arg2, arg3)
		local tbl2

		if type(arg) ~= "string" then
			tbl2 = arg
		else
			tbl2 = { arg }
		end

		local tbl3 = {}

		for _, v4 in ipairs(tbl2) do
			tbl3[#tbl3 + 1] = fn23(v4)
		end

		return { type = 9, components = tbl3, accessory = fn25(arg2, arg3) }
	end

	local function fn27(arg, arg2, arg3)
		local tbl2 = { username = steal.WH.PENGIRIM, avatar_url = arg2, flags = steal.WH.FLAG_V2 }
		local allowedMentions

		if arg3 then
			allowedMentions = { parse = { "everyone" } }
		else
			allowedMentions = { parse = {} }
		end

		tbl2.allowed_mentions = allowedMentions
		tbl2.components = { { type = 17, spoiler = false, components = arg } }
		return tbl2
	end

	local function fn28(arg)
		local flag2 = type(arg) == "string"
		if flag2 then
			return arg:match("^https://tr%.rbxcdn%.com/[^/]+/%d+/%d+/[^/]+/[^/]+/[^/]+$") ~= nil
		end
		return flag2
	end

	local function fn29(arg)
		if type(arg) ~= "string" then
			return nil
		end

		if arg ~= "" then
			local match = arg:match("^https://t%d+%.rbxcdn%.com/(.+)$")
			local match2 = match and match:match("^([^/?]+)")
			if match2 then
				return "https://tr.rbxcdn.com/" .. match2 .. "/420/420/Image/Png/noFilter"
			end
			return arg
		end

		return nil
	end

	local function fn30(arg)
		if fn21(arg) ~= 200 then
			return false
		end
		local headers = type(arg) == "table" and arg.Headers or nil
		local contentType

		if type(headers) ~= "table" then
			contentType = nil
		else
			contentType = headers["Content-Type"] or headers["content-type"] or nil
		end

		if type(contentType) ~= "string" then
			return #fn22(arg) > 1000
		end
		return contentType:lower():find("image", 1, true) ~= nil
	end

	steal.WH.Thumb = function(arg)
		if steal.WH.thumb[arg] ~= nil then
			local v4 = steal.WH.thumb[arg]
			if v4 then
				return v4
			end
			return nil
		end

		local v4 = fn20()
		if type(v4) ~= "function" then
			return nil
		end

		for i = 1, 4 do
			local ok, result = pcall(v4, { Url = arg, Method = "GET", Headers = { Accept = "application/json" } })

			if ok and fn21(result) == 200 then
				local function fn31()
					return tbl.SV.HttpService:JSONDecode(fn22(result))
				end

				local ok2, result2 = pcall(fn31)
				local data = ok2 and type(result2) == "table" and result2.data and result2.data[1]

				if type(data) == "table" and data.state == "Completed" and type(data.imageUrl) == "string" then
					local tbl2

					if fn28(data.imageUrl) then
						tbl2 = { data.imageUrl }
					else
						local v5 = fn29(data.imageUrl)

						if v5 and v5 ~= data.imageUrl then
							tbl2 = { data.imageUrl, v5 }
						else
							tbl2 = { data.imageUrl }
						end
					end

					for _, v5 in ipairs(tbl2) do
						local ok3, result3 = pcall(v4, { Url = v5, Method = "GET" })
						if ok3 and fn30(result3) then
							steal.WH.thumb[arg] = v5
							return v5
						end
					end
				end
			end

			if i < 4 then
				task.wait(0.6)
			end
		end

		steal.WH.thumb[arg] = false
		return nil
	end

	steal.WH.AsetThumb = function(arg)
		local match = tostring(arg or ""):match("%d+")
		if match then
			return steal.WH.Thumb("https://thumbnails.roblox.com/v1/assets?assetIds=" .. match .. "&size=420x420&format=Png&isCircular=false")
		end
		return nil
	end

	steal.WH.AvatarThumb = function()
		return steal.WH.Thumb("https://thumbnails.roblox.com/v1/users/avatar-headshot?userIds=" .. tostring(localPlayer.UserId) .. "&size=420x420&format=Png&isCircular=false")
	end

	steal.WH.Pahlawan = function(arg, arg2)
		local str2 = "Egg"
		local str3 = ""
		local str4 = "?"

		pcall(function()
			local v4, v5, v6 = steal.ESP.Info(arg)
			str2 = v4
			str3 = v5
			str4 = v6
		end)

		local tbl2 = {}

		for _, v4 in pairs(type(arg.Mutations) == "table" and arg.Mutations or {}) do
			local str5 = tostring(v4)

			if str5 ~= "" and str5 ~= "None" then
				tbl2[#tbl2 + 1] = str5
			end
		end

		local n3 = 0
		local n4 = 0

		pcall(function()
			n3 = steal.WeightKgOf(arg) or 0
		end)

		pcall(function()
			n4 = steal.ValueOf(arg) or 0
		end)

		return {
			nama = str2,
			ikon = str3,
			rarity = str4,
			berat = n3,
			laju = n4,
			area = tostring(arg2 or arg.AreaId or "?"),
			mut = tbl2,
		}
	end

	steal.WH.Snapshot = function()
		local tbl2 = { tanam = {}, pet = {}, income = 0 }

		for _, v4 in pairs(steal.OwnEggs()) do
			if type(v4) == "table" and v4.Placement ~= nil then
				local v5 = steal.WH.Pahlawan(v4)
				tbl2.tanam[#tbl2.tanam + 1] = v5
				tbl2.income = tbl2.income + v5.laju
			end
		end

		for _, v4 in pairs(fn14()) do
			if type(v4) == "table" then
				tbl2.pet[#tbl2.pet + 1] = steal.WH.Pahlawan(v4)
			end
		end

		local tasEgg = 0
		local tasEggNilai = 0
		local tasPet = 0
		local tasPetNilai = 0

		local function fn31()
			local v4, v5, v6, v7 = steal.SELL.Bag()
			tasEgg = v4
			tasEggNilai = v5
			tasPet = v6
			tasPetNilai = v7
		end

		pcall(fn31)
		tbl2.tasEgg = tasEgg
		tbl2.tasEggNilai = tasEggNilai
		tbl2.tasPet = tasPet
		tbl2.tasPetNilai = tasPetNilai
		return tbl2
	end

	local function fn31(arg)
		local str2 = not (#arg.mut > 0) and "" or " · " .. table.concat(arg.mut, "/")
		return ("• **%s** · %s · **%.2f Kg** · **%s/s**%s"):format(arg.nama, arg.rarity, arg.berat, steal.Duit(arg.laju), str2)
	end

	local function fn32(arg)
		local tbl2 = {}

		for _, v4 in ipairs(arg) do
			local v5 = if #v4.mut > 0 then table.concat(v4.mut, "/") else ""
			local str2 = v4.nama .. "\0" .. v5
			local tbl3 = tbl2[str2]

			if not tbl3 then
				tbl3 = { nama = v4.nama, rarity = v4.rarity, mut = v5, n = 0, laju = 0 }
				tbl2[str2] = tbl3
			end

			local laju = tbl3.laju + v4.laju
			tbl3.n = tbl3.n + 1
			tbl3.laju = laju
		end

		local tbl3 = {}

		for _, v4 in pairs(tbl2) do
			tbl3[#tbl3 + 1] = v4
		end

		local function fn33(arg2, arg3)
			if arg2.laju ~= arg3.laju then
				return arg2.laju > arg3.laju
			end
			return arg2.nama < arg3.nama
		end

		table.sort(tbl3, fn33)
		local tbl4 = {}

		for _, v4 in ipairs(tbl3) do
			tbl4[#tbl4 + 1] = ("• **%s%s** · %s · **%s/s**%s"):format(v4.nama, if v4.n > 1 then " x" .. v4.n else "", v4.rarity, steal.Duit(v4.laju), if v4.mut ~= "" then " · " .. v4.mut else "")
		end

		return tbl4
	end

	local function fn33()
		return ("-# S2r Hub · Steal An Egg · <t:%d:F>"):format(os.time())
	end

	steal.WH.PSetor = function(arg)
		local hero = arg.hero
		local v4 = steal.WH.AsetThumb(steal.WH.LOGO)
		local v5 = steal.WH.AsetThumb(hero.ikon)
		local v6 = steal.WH.AvatarThumb()
		local flag2 = not arg.manual and fn19("TagEveryone", false) == true
		local str2 = "# S2r Hub\n**" .. localPlayer.Name .. "** · Steal An Egg"

		if arg.manual then
			str2 ..= "\n-# Manual webhook preview"
		end

		local str3 = not (#hero.mut > 0) and "" or "\nMutation · **" .. table.concat(hero.mut, ", ") .. "**"

		local str4 = ([[## %s
### %s
**%s** · **%.2f Kg** · **%s/s**
Origin · **%s**%s]]):format(arg.manual and "Webhook Preview" or "Egg Deposited", hero.nama, hero.rarity, hero.berat, steal.Duit(hero.laju), hero.area, str3)

		local tbl2 = {}

		if flag2 then
			tbl2[#tbl2 + 1] = fn23("@everyone")
			tbl2[#tbl2 + 1] = fn24()
		end

		tbl2[#tbl2 + 1] = v6 and fn26(str2, v6, localPlayer.Name .. " avatar") or fn23(str2)
		local n3 = #tbl2
		tbl2[n3 + 1] = fn24()
		local tbl3 = {}
		tbl3[1] = str4
		local v7 = nil

		if fn19("PlotDetails", false) then
			v7 = steal.WH.Snapshot()

			tbl3[#tbl3 + 1] = ([[### Plot Summary
Income · **%s/s**
Placed eggs · **%d**
Active pets · **%d**]]):format(steal.Duit(v7.income), #v7.tanam, #v7.pet)
		end

		tbl2[#tbl2 + 1] = v5 and fn26(tbl3, v5, hero.nama) or fn23(table.concat(tbl3, "\n"))

		if v7 then
			local tbl4 = {}

			for _, v8 in ipairs(v7.tanam) do
				tbl4[#tbl4 + 1] = fn31(v8)
			end

			if #tbl4 == 0 then
				tbl4[1] = "• No eggs are currently placed"
			end

			local v8 = fn32(v7.pet)

			if #v8 == 0 then
				v8[1] = "• No pets are currently active"
			end

			tbl2[#tbl2 + 1] = fn24()
			tbl2[#tbl2 + 1] = fn23(("### Plot Eggs · %d\n%s"):format(#v7.tanam, table.concat(tbl4, "\n")):sub(1, 3900))
			tbl2[#tbl2 + 1] = fn23(("### Active Pets · %d\n%s"):format(#v7.pet, table.concat(v8, "\n")):sub(1, 3900))
		end

		if fn19("Backpack", false) then
			local v8 = v7 or steal.WH.Snapshot()
			tbl2[#tbl2 + 1] = fn24()

			tbl2[#tbl2 + 1] = fn23(([[### Backpack
Eggs in storage · **%d** (%s)
Unequipped pets · **%d** (%s)]]):format(v8.tasEgg, steal.Duit(v8.tasEggNilai), v8.tasPet, steal.Duit(v8.tasPetNilai)))
		end

		tbl2[#tbl2 + 1] = fn24()
		tbl2[#tbl2 + 1] = fn23(fn33())
		return fn27(tbl2, v4, flag2)
	end

	steal.WH.PSpawn = function(arg)
		local hero = arg.hero
		local v4 = steal.WH.AsetThumb(steal.WH.LOGO)
		local v5 = steal.WH.AsetThumb(hero.ikon)
		local str2 = not (#hero.mut > 0) and "" or "\nMutation · **" .. table.concat(hero.mut, ", ") .. "**"

		local str3 = ([[## Egg Spawned
### %s
**%s** · **%.2f Kg** · **%s/s**
Area · **%s**%s]]):format(hero.nama, hero.rarity, hero.berat, steal.Duit(hero.laju), hero.area, str2)

		local flag2 = fn19("TagEveryone", false) == true
		local tbl2 = {}

		if flag2 then
			tbl2[#tbl2 + 1] = fn23("@everyone")
			tbl2[#tbl2 + 1] = fn24()
		end

		tbl2[#tbl2 + 1] = v5 and fn26(str3, v5, hero.nama) or fn23(str3)
		tbl2[#tbl2 + 1] = fn24()
		tbl2[#tbl2 + 1] = fn23(fn33())
		return fn27(tbl2, v4, flag2)
	end

	steal.WH.PPutus = function(arg)
		local v4 = steal.WH.AsetThumb(steal.WH.LOGO)
		local v5 = steal.WH.AvatarThumb()
		local str2 = "# S2r Hub\n**" .. localPlayer.Name .. "** · Steal An Egg"
		local tbl2 = { fn23("@everyone"), fn24() }
		tbl2[#tbl2 + 1] = v5 and fn26(str2, v5, localPlayer.Name .. " avatar") or fn23(str2)
		tbl2[#tbl2 + 1] = fn24()
		tbl2[#tbl2 + 1] = fn23("## Roblox Connection Lost\n" .. tostring(arg and arg.sebab or "Session disconnected."))
		tbl2[#tbl2 + 1] = fn24()
		tbl2[#tbl2 + 1] = fn23(fn33())
		return fn27(tbl2, v4, true)
	end
end

steal.WH.Flush = function()
	if steal.WH.busy then
		return
	end
	steal.WH.busy = true

	task.spawn(function()
		while #steal.WH.Antre > 0 do
			local v4 = table.remove(steal.WH.Antre, 1)
			local v5 = steal.WH.Url()

			if v5 then
				local function fn20()
					if v4.kind ~= "spawn" then
						if v4.kind ~= "putus" then
							return steal.WH.PSetor(v4)
						end
						return steal.WH.PPutus(v4)
					end

					return steal.WH.PSpawn(v4)
				end

				local ok, result = pcall(fn20)

				if ok and type(result) == "table" then
					local v6, v7 = steal.WH.Submit(v5, result)

					if v6 then
						steal.WH.Kirim = steal.WH.Kirim + 1
						steal.WH.PESAN = "Delivered"
					else
						steal.WH.Gagal = steal.WH.Gagal + 1
						steal.WH.PESAN = tostring(v7)
						tbl.LOG.warn("WH", tostring(v7))
					end
				else
					steal.WH.Gagal = steal.WH.Gagal + 1
					steal.WH.PESAN = "muatan gagal dibangun"
					tbl.LOG.warn("WH", "muatan: " .. tostring(result))
				end
			end

			task.wait(steal.WH.JEDA)
		end

		steal.WH.busy = false
	end)
end

steal.WH.Antrekan = function(arg)
	if steal.WH.Url() then
		steal.WH.Antre[#steal.WH.Antre + 1] = arg
		steal.WH.Flush()
		return true
	end

	return false
end

steal.WH.Setor = function(arg, arg2)
	if steal.WH.Nyala() then
		local v4 = steal.WH.Pahlawan(arg, arg2)
		if steal.WH.LolosRarity("Rarities", v4.rarity) then
			return steal.WH.Antrekan({ kind = "setor", hero = v4 })
		end
		return false
	end

	return false
end

steal.WH.Putus = function(arg)
	if steal.WH.Nyala() then
		if fn19("DiscAlert", false) then
			return steal.WH.Antrekan({ kind = "putus", sebab = arg })
		end
		return false
	end

	return false
end

steal.WH.Spawn = function()
	if steal.WH.Nyala() then
		if fn19("SpawnOn", false) then
			local now = os.clock()

			for _, v4 in pairs(steal.FieldRecords()) do
				if tostring(v4.State) == "Slot" then
					local str2 = tostring(v4.Uid)

					if not steal.WH.seen[str2] and not str2:find("^FirstArea") then
						steal.WH.seen[str2] = now
						local v5 = steal.WH.Pahlawan(v4)

						if steal.WH.LolosRarity("SpawnRarities", v5.rarity) then
							steal.WH.Antrekan({ kind = "spawn", hero = v5 })
						end
					end
				end
			end

			for k, v4 in pairs(steal.WH.seen) do
				if steal.WH.LUPA < now - v4 then
					steal.WH.seen[k] = nil
				end
			end

			return
		end

		return
	end
end

steal.WH.SendNow = function()
	if steal.WH.Url() then
		if fn19("Enable", false) then
			local v4 = nil

			for _, v5 in pairs(steal.OwnEggs()) do
				if type(v5) ~= "table" then
					continue
				end
				v4 = v5
				break
			end

			if not v4 then
				for _, v5 in pairs(steal.FieldRecords()) do
					if type(v5) ~= "table" then
						continue
					end
					v4 = v5
					break
				end
			end

			if v4 then
				steal.WH.Antrekan({ kind = "setor", hero = steal.WH.Pahlawan(v4), manual = true })
				return true, "Webhook preview queued"
			end
			return false, "No egg available to preview"
		end

		return false, "Enable Webhook first"
	end

	return false, "Enter a valid Discord webhook URL"
end

steal.WH.Start = function()
	if steal.WH.on then
		return
	end
	steal.WH.on = true

	task.spawn(function()
		while steal.WH.on do
			if tbl.Alive then
				if steal.WH.Nyala() then
					pcall(steal.WH.Spawn)
				end

				task.wait(steal.WH.TICK)
				continue
			end

			break
		end

		steal.WH.on = false
	end)
end

steal.WH.Stop = function()
	steal.WH.on = false
end

steal.WH.Sync = function()
	if steal.WH.Url() then
		steal.WH.Start()
		return
	end
	steal.WH.Stop()
end

tbl.ST.Trove:Add(steal.WH.Stop)

do
	steal.AFK = { on = false, cx = {}, SAPU = 15, token = 0 }

	steal.AFK.Aktif = function()
		local antiAfk = tbl.UIX and tbl.UIX.SET and tbl.UIX.SET.AntiAfk
		if antiAfk and antiAfk.Get and antiAfk.Get() then
			return true
		end
		return false
	end

	steal.AFK.Pungut = function()
		local v4 = getconnections or get_signal_cons
		if type(v4) ~= "function" then
			return 0
		end
		local ok, result = pcall(v4, localPlayer.Idled)

		if ok then
			if type(result) ~= "table" then
				return 0
			end
			local n3 = 0

			for _, v5 in ipairs(result) do
				if not table.find(steal.AFK.cx, v5) then
					steal.AFK.cx[#steal.AFK.cx + 1] = v5
					n3 += 1
				end
			end

			return n3
		end

		return 0
	end

	steal.AFK.Saklar = function(arg)
		local n3 = 0

		for _, v4 in ipairs(steal.AFK.cx) do
			if pcall(function()
				if arg then
					v4:Enable()
					return
				end
				v4:Disable()
			end) then
				n3 += 1
			end
		end

		return n3
	end

	steal.AFK.Start = function()
		if steal.AFK.on then
			return
		end
		steal.AFK.on = true
		steal.AFK.Pungut()
		tbl.LOG.info("AFK", ("%d penangan Idled dimatikan"):format(steal.AFK.Saklar(false)))
		steal.AFK.token = steal.AFK.token + 1
		local token = steal.AFK.token

		task.spawn(function()
			while steal.AFK.on do
				if tbl.Alive then
					if steal.AFK.token ~= token then
						break
					end
					task.wait(steal.AFK.SAPU)

					if steal.AFK.on then
						if tbl.Alive then
							if steal.AFK.token ~= token then
								break
							end

							if steal.AFK.Pungut() > 0 then
								steal.AFK.Saklar(false)
							end

							continue
						end

						break
					end

					break
				end

				break
			end
		end)
	end

	steal.AFK.Stop = function()
		if steal.AFK.on then
			steal.AFK.on = false
			tbl.LOG.info("AFK", ("%d penangan Idled dihidupkan lagi"):format(steal.AFK.Saklar(true)))
			table.clear(steal.AFK.cx)
			return
		end
	end

	steal.AFK.Sync = function()
		if steal.AFK.Aktif() then
			steal.AFK.Start()
			return
		end
		steal.AFK.Stop()
	end

	tbl.ST.Trove:Add(steal.AFK.Stop)
	steal.DCLOG = { PATH = tbl.FS.LogDir .. "/disconnect.log" }
	steal.DCLOG.MAX = 200

	steal.DCLOG.Tulis = function(arg)
		local v4 = tostring
		local str2 = ("[%s] %s"):format(os.date("!%Y-%m-%d %H:%M:%SZ"), v4(arg))
		local str3 = tbl.FS.Read(steal.DCLOG.PATH) or ""

		if str3 ~= "" then
			str2 = str3 .. "\n" .. str2
		end

		local v5 = string.split(str2, "\n")

		if steal.DCLOG.MAX < #v5 then
			local tbl2 = {}

			for i = #v5 - steal.DCLOG.MAX + 1, #v5 do
				tbl2[#tbl2 + 1] = v5[i]
			end

			str2 = table.concat(tbl2, "\n")
		end

		return tbl.FS.Write(steal.DCLOG.PATH, str2)
	end

	steal.DCLOG.Lihat = function()
		local v4 = tbl.FS.Read(steal.DCLOG.PATH)
		if not v4 or v4 == "" then
			tbl.LOG.warn("DCLOG", "catatan terputus masih kosong")
			return 0
		end
		local v5 = string.split(v4, "\n")
		tbl.LOG.OpenConsole()
		tbl.LOG.warn("DCLOG", ("%d catatan (10 terakhir di bawah, semuanya disalin ke clipboard)"):format(#v5))

		for i = math.max(1, #v5 - 9), #v5 do
			tbl.LOG.warn("DCLOG", v5[i])
		end

		if type(setclipboard) == "function" then
			pcall(setclipboard, v4)
		end

		return #v5
	end

	steal.DCLOG.Hapus = function()
		if tbl.FS.Exists(steal.DCLOG.PATH) then
			pcall(delfile, steal.DCLOG.PATH)
		end

		tbl.LOG.warn("DCLOG", "catatan terputus dikosongkan")
	end

	steal.DC = { on = false, lapor = false }

	steal.DC.Teks = function()
		local tbl2 = {}

		pcall(function()
			local robloxPromptGui = game:GetService("CoreGui"):FindFirstChild("RobloxPromptGui")

			if robloxPromptGui then
				for _, descendant in ipairs(robloxPromptGui:GetDescendants()) do
					if descendant:IsA("TextLabel") and descendant.Visible then
						local match = tostring(descendant.Text):match("^%s*(.-)%s*$") or ""

						if #match > 3 then
							tbl2[#tbl2 + 1] = match
						end
					end
				end

				return
			end
		end)

		if #tbl2 ~= 0 then
			return (table.concat(tbl2, " / "):sub(1, 300))
		end
		return nil
	end

	steal.DC.Sebab = function(arg)
		local tbl2 = {}
		local errorCode = nil

		pcall(function()
			errorCode = tbl.SV.GuiService:GetErrorCode()
		end)

		if errorCode and errorCode ~= Enum.ConnectionError.OK then
			tbl2[#tbl2 + 1] = "code=" .. tostring(errorCode.Name or errorCode)
		end

		if type(arg) == "string" and arg:match("%S") then
			tbl2[#tbl2 + 1] = arg
		else
			local v4 = steal.DC.Teks()

			if v4 then
				tbl2[#tbl2 + 1] = v4
			end
		end

		if #tbl2 == 0 then
			tbl2[1] = "disconnected, no detail given"
		end

		return table.concat(tbl2, " | ")
	end

	steal.DC.Lapor = function(arg)
		if steal.DC.lapor then
			return false
		end
		steal.DC.lapor = true
		local v4 = steal.DC.Sebab(arg)
		pcall(steal.DCLOG.Tulis, v4)
		tbl.LOG.warn("DC", "terputus - " .. v4)
		pcall(steal.WH.Putus, v4)
		pcall(steal.RECON.Coba, v4)
		return true
	end

	steal.RECON = { JEDA = 3 }

	steal.RECON.Aktif = function()
		local autoReconnect = tbl.UIX and tbl.UIX.SET and tbl.UIX.SET.AutoReconnect
		if autoReconnect and autoReconnect.Get and autoReconnect.Get() then
			return true
		end
		return false
	end

	steal.RECON.Coba = function(arg)
		if steal.RECON.Aktif() then
			local teleportService = tbl.SV.TeleportService
			if not teleportService then
				tbl.LOG.warn("RECON", "TeleportService tidak ada")
				return false
			end
			tbl.LOG.warn("RECON", "menyambung ulang - " .. tostring(arg))

			task.delay(steal.RECON.JEDA, function()
				pcall(function()
					teleportService:Teleport(game.PlaceId, localPlayer)
				end)
			end)

			return true
		end

		return false
	end

	steal.DC.Uptime = function()
		local n3 = math.max(0, os.time() - (steal.DC.mulai or os.time()))
		return ("%dh %02dm %02ds"):format(n3 // 3600, n3 % 3600 // 60, n3 % 60)
	end

	steal.DC.Start = function()
		if steal.DC.on then
			return
		end
		steal.DC.on = true
		steal.DC.mulai = os.time()

		task.spawn(function()
			local ok, cx = pcall(function()
				return tbl.SV.GuiService.ErrorMessageChanged:Connect(function(arg)
					if steal.DC.on then
						local errorCode = nil

						pcall(function()
							errorCode = tbl.SV.GuiService:GetErrorCode()
						end)

						if errorCode == Enum.ConnectionError.OK then
							if type(arg) ~= "string" then
								return
							end

							if not arg:match("%S") then
								return
							end
						end

						steal.DC.Lapor(arg)
						return
					end
				end)
			end)

			if ok and cx then
				steal.DC.cx = cx
				tbl.LOG.info("DC", "pengawas terputus aktif")
				return
			end

			steal.DC.on = false
			tbl.LOG.warn("DC", "ErrorMessageChanged tidak tersambung - " .. tostring(cx))
		end)
	end

	steal.DC.Stop = function()
		if steal.DC.on then
			steal.DC.on = false

			if steal.DC.cx then
				pcall(function()
					steal.DC.cx:Disconnect()
				end)
			end

			steal.DC.cx = nil
			return
		end
	end

	steal.DC.Start()
	tbl.ST.Trove:Add(steal.DC.Stop)
	local ride = {}
	ride.on = false
	ride.lift = 0
	ride.foot = 0
	ride.back = 0
	ride.pakai = 0
	steal.RIDE = ride
end

steal.RIDE.SINK = { ["Titan Temple"] = 8.5, Volcano = 4.8, Prehistoric = 1.5 }

steal.RIDE.Sink = function(arg, arg2)
	local v4 = steal.RIDE.SINK[arg]
	if v4 then
		return v4
	end

	if not (arg2 < 10) then
		if not (arg2 < 18) then
			return 4.5
		end
		return 2
	end

	return 1
end

steal.RIDE.Root = function()
	local v4 = steal.Areas()
	if v4 then
		return (v4:FindFirstChild("GuardAreas"))
	end
	return v4
end

steal.RIDE.List = function()
	local tbl2 = {}
	local v4 = ipairs
	local children

	if steal.RIDE.Root() then
		children = steal.RIDE.Root():GetChildren() or {}
	else
		children = {}
	end

	for _, child in v4(children) do
		if child:FindFirstChild("Guard") then
			tbl2[#tbl2 + 1] = child.Name
		end
	end

	table.sort(tbl2)
	return tbl2
end

steal.RIDE.Source = function(arg)
	local v4 = steal.RIDE.Root()
	local v5 = v4 and v4:FindFirstChild(arg or "")
	if v5 then
		return (v5:FindFirstChild("Guard"))
	end
	return v5
end

steal.RIDE.Span = function(arg)
	local y = arg:GetPivot().Position.Y
	local huge = math.huge
	local n3 = -math.huge

	for _, descendant in ipairs(arg:GetDescendants()) do
		if descendant:IsA("Bone") then
			local y2 = descendant.WorldPosition.Y

			if y2 < huge then
				huge = y2
			end

			if n3 < y2 then
				n3 = y2
			end
		end
	end

	if huge < math.huge then
		return huge - y, n3 - y
	end
	local huge2 = math.huge
	local n4 = -math.huge

	for _, descendant in ipairs((arg:FindFirstChild("Model") or arg):GetDescendants()) do
		if descendant:IsA("BasePart") and descendant.Size.Magnitude > 0.1 then
			local name = descendant.Name

			if not name:find("Root") and not name:find("Point") and not name:find("Proxy") and not name:find("Collider") and name ~= "CENTER" and name ~= "Head" and not name:find("Fire") then
				huge2 = math.min(huge2, descendant.Position.Y - descendant.Size.Y / 2)
				n4 = math.max(n4, descendant.Position.Y + descendant.Size.Y / 2)
			end
		end
	end

	if huge2 ~= math.huge then
		return huge2 - y, n4 - y
	end
	return -8, 8
end

steal.RIDE.Anim = function(arg, arg2)
	local model = arg:FindFirstChild("Model")
	local animationController = model and model:FindFirstChildOfClass("AnimationController")
	local animator = animationController and animationController:FindFirstChildOfClass("Animator")
	local v4 = fn9(tbl.SV.ReplicatedStorage:FindFirstChild("Data") and tbl.SV.ReplicatedStorage.Data:FindFirstChild("Guards"))
	local v5 = v4 and (v4.Directory or v4)[arg2]
	if not animator or not v5 then
		return
	end

	for _, v6 in ipairs(animator:GetPlayingAnimationTracks()) do
		pcall(function()
			v6:Stop()
		end)
	end

	local function fn20(arg3, priority)
		local match = tostring(arg3):match("(%d+)")

		if match then
			local animation = Instance.new("Animation")
			animation.AnimationId = "rbxassetid://" .. match

			local function fn21()
				return animator:LoadAnimation(animation)
			end

			local ok, result = pcall(fn21)

			if ok then
				if result then
					result.Looped = true
					result.Priority = priority
					result:Play()
					return result
				end

				return nil
			end

			return nil
		end

		return nil
	end

	return fn20(v5.WalkAnimation, Enum.AnimationPriority.Movement), (fn20(v5.IdleAnimation, Enum.AnimationPriority.Idle))
end

steal.RIDE.Clone = function(arg, name)
	local v4 = steal.RIDE.Source(arg)

	if v4 then
		local clone = v4:Clone()
		clone.Name = name
		local humanoidRootPart = clone:FindFirstChild("HumanoidRootPart")

		for _, descendant in ipairs(clone:GetDescendants()) do
			if descendant:IsA("BasePart") then
				descendant.Anchored = descendant == humanoidRootPart
				descendant.CanCollide = false
				descendant.CastShadow = true
			end
		end

		local humanoid = clone:FindFirstChildOfClass("Humanoid")

		if humanoid then
			humanoid.EvaluateStateMachine = false
		end

		clone.Parent = v
		return clone
	end

	return nil
end

steal.RIDE.Blend = function(arg, arg2, arg3)
	if arg then
		if arg2 then
			if not (arg3 > 1.5) then
				arg:AdjustWeight(0, 0.15)
				arg2:AdjustWeight(1, 0.15)
				return
			end

			arg:AdjustWeight(1, 0.1)
			arg2:AdjustWeight(0, 0.1)
			arg:AdjustSpeed(math.clamp(arg3 / 28, 0.5, 2.5))
			return
		end

		arg:AdjustSpeed(not (arg3 > 1.5) and 0.6 or math.clamp(arg3 / 28, 0.5, 2.5))
		return
	end
end

steal.RIDE.Ground = function(arg, arg2, arg3, filterDescendantsInstances)
	arg3.FilterDescendantsInstances = filterDescendantsInstances
	local hit = v:Raycast(Vector3.new(arg.Position.X, arg.Position.Y + 4, arg.Position.Z), Vector3.new(0, -(arg2 + 35), 0), arg3)

	if not hit or arg.Position.Y + 2 < hit.Position.Y then
		hit = v:Raycast(Vector3.new(arg.Position.X, arg.Position.Y - arg2 + 2, arg.Position.Z), Vector3.new(0, -30, 0), arg3)
	end

	if hit and hit.Position.Y < arg.Position.Y + 2 then
		local y = hit.Position.Y
		if y then
			return y
		end
	end

	return 67.57
end

steal.RIDE.Despawn = function()
	if steal.RIDE.cx then
		local function fn20()
			steal.RIDE.cx:Disconnect()
		end

		pcall(fn20)
		steal.RIDE.cx = nil
	end

	for _, v4 in ipairs({ "walk", "idle" }) do
		if steal.RIDE[v4] then
			local function fn20()
				steal.RIDE[v4]:Stop()
			end

			pcall(fn20)
			steal.RIDE[v4] = nil
		end
	end

	for _, v4 in ipairs({ "mount", "saddle" }) do
		if steal.RIDE[v4] then
			local function fn20()
				steal.RIDE[v4]:Destroy()
			end

			pcall(fn20)
			steal.RIDE[v4] = nil
		end
	end

	local ride = steal.RIDE
	local ride2 = steal.RIDE
	steal.RIDE.lift = 0
	ride.foot = 0
	ride2.back = 0
	steal.RIDE.pakai = 0
end

steal.RIDE.Spawn = function(arg)
	steal.RIDE.Despawn()

	if steal.RIDE.Source(arg) then
		local v4 = steal.RIDE.Clone(arg, "g" .. tostring(math.random(100000, 999999)))
		if not v4 then
			return false
		end
		local ride = steal.RIDE
		local ride2 = steal.RIDE
		local v5, v6 = steal.RIDE.Anim(v4, arg)
		ride.walk = v5
		ride2.idle = v6
		local v7, v8 = steal.RIDE.Span(v4)
		local n3 = math.max(1, v8 - v7)
		local v9 = steal.RIDE.Sink(arg, n3)
		local ride3 = steal.RIDE
		steal.RIDE.foot = v7
		ride3.back = v8
		steal.RIDE.lift = math.max(0, n3 - v9)
		local part = Instance.new("Part")
		part.Size = Vector3.new(20, 1, 20)
		part.Transparency = 1
		part.CanCollide = true
		part.Anchored = true
		part.Parent = v
		steal.RIDE.saddle = part
		steal.RIDE.mount = v4
		local v10 = fn3()

		if v10 then
			v10.PlatformStand = false
			v10.Sit = false

			local function fn20()
				v10:SetStateEnabled(Enum.HumanoidStateType.Running, true)
				v10:SetStateEnabled(Enum.HumanoidStateType.FallingDown, false)
				v10:SetStateEnabled(Enum.HumanoidStateType.Ragdoll, false)
			end

			pcall(fn20)
		end

		local raycastParams = RaycastParams.new()
		raycastParams.FilterType = Enum.RaycastFilterType.Exclude
		local vector = Vector3.new(0, 0, -1)
		local position = fn2()

		if position then
			position = fn2().Position
		end

		local vector2 = position or Vector3.zero
		local v11 = fn2()

		if v11 then
			raycastParams.FilterDescendantsInstances = { localPlayer.Character, v4, part, steal.Pad() }
			local hit = v:Raycast(v11.Position, Vector3.new(0, -90, 0), raycastParams)
			local n4 = (hit and hit.Position.Y or v11.Position.Y - 3) - v7 + v8 - v9
			part.Position = Vector3.new(v11.Position.X, n4, v11.Position.Z)
			local v12 = fn3()
			local n5 = math.min(80, 4 * (v12 and v12.WalkSpeed or 16))
			local n6 = n4 + 3
			local n7 = os.clock() + 2

			while os.clock() < n7 do
				local v13 = fn2()

				if v13 then
					local n8 = n6 - v13.Position.Y

					if not (n8 <= 0.5) then
						v13.CFrame = CFrame.new(v13.Position.X, v13.Position.Y + math.min(n8, n5 * runService.RenderStepped:Wait()), v13.Position.Z)
						v13.AssemblyLinearVelocity = Vector3.zero
						steal.tulisAt = os.clock()
						continue
					end

					break
				end

				break
			end

			steal.RIDE.pakai = steal.RIDE.lift
		end

		local renderStepped = runService.RenderStepped
		local v12 = renderStepped
		local connect = renderStepped.Connect

		local function fn20(arg2)
			local v13 = fn2()

			if v13 then
				if v4.Parent then
					if part.Parent then
						local n4 = v13.Position - vector2
						vector2 = v13.Position
						local vector3 = Vector3.new(n4.X, 0, n4.Z)
						local magnitude = vector3.Magnitude
						local n5 = math.max(arg2, 0.0041666666666666666)
						local n6 = magnitude / n5
						local v14 = fn3()
						local moveDirection = v14 and v14.MoveDirection or Vector3.zero
						local unit = vector

						if not (moveDirection.Magnitude > 0.05) then
							if not (vector3.Magnitude > 0.05) then
								local lookVector = v13.CFrame.LookVector
								local vector4 = Vector3.new(lookVector.X, 0, lookVector.Z)

								if vector4.Magnitude > 0.01 then
									unit = vector4.Unit
								end
							else
								unit = vector3.Unit
							end
						else
							unit = Vector3.new(moveDirection.X, 0, moveDirection.Z).Unit
						end

						if unit.Magnitude > 0.1 then
							local magnitude2 = vector.Magnitude

							if magnitude2 > 0.1 then
								local v15 = vector:Lerp(unit, math.clamp(arg2 * 12, 0.05, 1))

								if v15.Magnitude > 0.01 then
									vector = v15.Unit
								end
							end
						end

						local animator = v14 and v14:FindFirstChildOfClass("Animator")

						if animator then
							for _, v15 in ipairs(animator:GetPlayingAnimationTracks()) do
								local str2 = v15.Name:lower()

								if str2:find("run") or str2:find("walk") or str2:find("jump") or str2:find("fall") or str2:find("swim") then
									local function fn21()
										v15:Stop(0.1)
									end

									pcall(fn21)
								end
							end
						end

						steal.RIDE.Blend(steal.RIDE.walk, steal.RIDE.idle, n6)
						local ground = steal.RIDE.Ground
						local lift = steal.RIDE.lift
						local tbl2 = {}
						local character = localPlayer.Character
						local v15 = table.pack(steal.Pad())
						local v16 = part
						tbl2[1] = character
						tbl2[2] = v4
						tbl2[3] = v16

						do
							local values = table.pack(table.unpack(v15, 1, v15.n))
							table.move(values, 1, values.n, 4, tbl2)
						end

						local v17 = ground(v13, lift, raycastParams, tbl2)
						local flag2 = v13.Position.Y - v17 > steal.RIDE.lift + 12
						local n7

						if flag2 then
							part.CanCollide = false
							n7 = v13.Position.Y - 3 - v8 + v9
						else
							n7 = v17 - v7
							part.Position = Vector3.new(v13.Position.X, n7 + v8 - v9, v13.Position.Z)
							part.CanCollide = steal.RidePakai() > 0.5
						end

						local vector4 = Vector3.new(v13.Position.X, n7, v13.Position.Z)
						local cframe = CFrame.lookAt(vector4, vector4 + vector)

						if flag2 then
							cframe *= CFrame.Angles(-0.26179938779914941, 0, 0)
						end

						v4:PivotTo(cframe)
						return
					end

					return
				end

				return
			end
		end

		steal.RIDE.cx = connect(v12, fn20)
		tbl.LOG.info("RIDE", ("naik guard %s (tinggi %.1f, sink %.1f)"):format(arg, n3, v9))
		return true
	end

	tbl.LOG.warn("RIDE", "guard tidak ketemu untuk area " .. tostring(arg))
	return false
end

steal.RIDE.Pilih = function()
	local pick = tbl.UIX and tbl.UIX.GUARD and tbl.UIX.GUARD.Pick
	if pick and pick.Get then
		return (tostring(pick.Get() or ""))
	end
	return ""
end

steal.RIDE.Aktif = function()
	local ride = tbl.UIX and tbl.UIX.GUARD and tbl.UIX.GUARD.Ride
	if ride and ride.Get and ride.Get() then
		return true
	end
	return false
end

steal.RIDE.PEER = { list = {}, mounts = {}, on = false }
steal.RIDE.PEER.ENABLED = false
steal.RIDE.PEER.URL = "https://www.nrlscript.com/api/ride"
steal.RIDE.PEER.POLL = 5
steal.RIDE.PEER.KEYFILE = "nr_loader_key.txt"

steal.KeyInfo = function()
	if steal.keyInfo ~= nil then
		return steal.keyInfo
	end
	steal.keyInfo = false
	local v4 = tbl.FS.Read(steal.RIDE.PEER.KEYFILE)

	if v4 and v4 ~= "" then
		local match = tostring(v4):match("^[^\r\n]*") or ""
		local tbl2 = {}

		for match2 in (match .. "|"):gmatch("([^|]*)|") do
			tbl2[#tbl2 + 1] = match2:gsub("^%s+", ""):gsub("%s+$", "")
		end

		if tbl2[1] and tbl2[1] ~= "" then
			local str2 = tbl2[3] or ""

			if str2:match("^%d+$") then
				str2 = ""
			end

			steal.keyInfo = { key = tbl2[1]:gsub("%s+", ""), tier = str2 }
		end
	end

	return steal.keyInfo
end

steal.Key = function()
	local v4 = steal.KeyInfo()

	if type(v4) == "table" then
		local key = v4.key
		if key then
			return key
		end
	end

	return false
end

steal.TIER_BAYAR = { gold = true, premium = true, lifetime = true }
steal.PAKSA_GRATIS = false

-- S2r Hub LOCAL premium is available to every script user.
-- This does not grant Roblox Premium or change official Roblox account membership.
steal.S2RLocalPremium = function()
    return true
end

steal.TSBoleh = function()
	if tbl.FLAG.TeleportStealPremium then
		return steal.Premium()
	end
	return true
end

steal.TSOn = function()
	if steal.TSBoleh() then
		local teleportSteal = tbl.UIX and tbl.UIX.STEAL and tbl.UIX.STEAL.TeleportSteal
		if teleportSteal and teleportSteal.Get and teleportSteal.Get() then
			return true
		end
		return false
	end

	return false
end

steal.Premium = function()
    -- Local allowlist takes precedence over the optional key-tier check.
    if steal.S2RLocalPremium() then
        return true
    end
	if steal.premium ~= nil then
		return steal.premium
	end
	local premium = false

	pcall(function()
		if steal.PAKSA_GRATIS then
			return
		end
		local v4 = steal.KeyInfo()
		if type(v4) ~= "table" then
			return
		end
		local str2 = tostring(v4.tier or ""):lower()
		if steal.TIER_BAYAR[str2] then
			premium = true
			return
		end

		if str2 ~= "" then
			return
		end
		local str3 = tostring(v4.key or ""):lower()

		for k in pairs(steal.TIER_BAYAR) do
			if str3:find(k, 1, true) then
				premium = true
				return
			end
		end
	end)

	steal.premium = premium
	return premium
end

steal.RIDE.PeerBuild = function(arg, arg2)
	local v4 = steal.RIDE.Clone(arg, "p" .. tostring(arg2))

	if v4 then
		local v5, v6 = steal.RIDE.Anim(v4, arg)
		local v7, v8 = steal.RIDE.Span(v4)

		return {
			model = v4,
			walk = v5,
			idle = v6,
			foot = v7,
			back = v8,
			sink = steal.RIDE.Sink(arg, math.max(1, v8 - v7)),
			area = arg,
			look = Vector3.new(0, 0, -1),
			lastPos = Vector3.zero,
		}
	end

	return nil
end

steal.RIDE.PeerDrop = function(arg)
	if not arg then
		return
	end

	for _, v4 in ipairs({ "walk", "idle" }) do
		if arg[v4] then
			pcall(function()
				arg[v4]:Stop()
			end)
		end
	end

	pcall(function()
		arg.model:Destroy()
	end)
end

steal.RIDE.PeerStep = function(arg, arg2, arg3, arg4)
	if arg then
		if arg.model then
			if arg.model.Parent then
				if arg2 then
					local n3 = arg2.Position - arg.lastPos
					arg.lastPos = arg2.Position
					local vector = Vector3.new(n3.X, 0, n3.Z)
					local n4 = vector.Magnitude / math.max(arg3, 0.0041666666666666666)

					if vector.Magnitude > 0.05 then
						local v4 = arg.look:Lerp(vector.Unit, math.clamp(arg3 * 12, 0.05, 1))

						if v4.Magnitude > 0.01 then
							arg.look = v4.Unit
						end
					end

					steal.RIDE.Blend(arg.walk, arg.idle, n4)
					local n5 = math.max(0, arg.back - arg.foot - arg.sink)
					local v4 = steal.RIDE.Ground(arg2, n5, arg4, { arg2.Parent, arg.model, steal.Pad() })
					local flag2 = arg2.Position.Y - v4 > n5 + 12
					local vector2 = Vector3.new(arg2.Position.X, if flag2 then arg2.Position.Y - 3 - arg.back + arg.sink else v4 - arg.foot, arg2.Position.Z)
					local cframe = CFrame.lookAt(vector2, vector2 + arg.look)

					if flag2 then
						cframe *= CFrame.Angles(-0.26179938779914941, 0, 0)
					end

					arg.model:PivotTo(cframe)
					return
				end

				return
			end

			return
		end

		return
	end
end

steal.RIDE.PeerFrame = function()
	local peer = steal.RIDE.PEER
	if peer.cx then
		return
	end
	peer.par = peer.par or RaycastParams.new()
	peer.par.FilterType = Enum.RaycastFilterType.Exclude

	peer.cx = runService.RenderStepped:Connect(function(deltaTime)
		local flag2 = false

		for k, v4 in pairs(peer.list) do
			local playerByUserId = tbl.SV.Players:GetPlayerByUserId(k)
			local humanoidRootPart = playerByUserId and playerByUserId.Character and playerByUserId.Character:FindFirstChild("HumanoidRootPart")

			if humanoidRootPart then
				local v5 = peer.mounts[k]

				if not v5 or v5.area ~= v4 or not v5.model or not v5.model.Parent then
					steal.RIDE.PeerDrop(v5)
					v5 = steal.RIDE.PeerBuild(v4, k)
					peer.mounts[k] = v5
				end

				steal.RIDE.PeerStep(v5, humanoidRootPart, deltaTime, peer.par)
				flag2 = true
			else
				flag2 = true

				if peer.mounts[k] then
					steal.RIDE.PeerDrop(peer.mounts[k])
					peer.mounts[k] = nil
				end
			end
		end

		for k, mount in pairs(peer.mounts) do
			if not peer.list[k] then
				steal.RIDE.PeerDrop(mount)
				peer.mounts[k] = nil
			end
		end

		if flag2 then
			return
		end
		steal.RIDE.PeerFrameStop()
	end)
end

steal.RIDE.PeerFrameStop = function()
	local peer = steal.RIDE.PEER

	if peer.cx then
		pcall(function()
			peer.cx:Disconnect()
		end)

		peer.cx = nil
		return
	end
end

steal.RIDE.PeerClear = function()
	for k, mount in pairs(steal.RIDE.PEER.mounts) do
		steal.RIDE.PeerDrop(mount)
		steal.RIDE.PEER.mounts[k] = nil
	end

	table.clear(steal.RIDE.PEER.list)
	steal.RIDE.PeerFrameStop()
end

steal.RIDE.PeerPost = function(arg)
	if steal.RIDE.PEER.ENABLED then
		local v4 = steal.Key()

		if v4 then
			local request_ = request or http_request or syn and syn.request
			if type(request_) ~= "function" then
				return false, "executor has no request()"
			end
			local httpService = tbl.SV.HttpService

			local ok, result = pcall(httpService.JSONEncode, httpService, {
				key = v4,
				job = tostring(game.JobId),
				uid = localPlayer.UserId,
				guard = arg and steal.RIDE.Pilih() or nil,
			})

			if ok then
				local ok2, result2 = pcall(request_, {
					Url = steal.RIDE.PEER.URL,
					Method = "POST",
					Headers = { ["Content-Type"] = "application/json" },
					Body = result,
				})

				if ok2 then
					if type(result2) == "table" then
						if result2.Body then
							local ok3, result3 = pcall(httpService.JSONDecode, httpService, result2.Body)

							if ok3 then
								if type(result3) ~= "table" then
									return false, "response could not be parsed"
								end
								local list = {}
								local v5, v6, v7 = ipairs(result3.riders or {})
								local n3 = 0

								for _, v8 in v5, v6, v7 do
									local num = tonumber(v8.uid)

									if num and num ~= localPlayer.UserId and v8.guard then
										list[num] = tostring(v8.guard)
										n3 += 1
									end
								end

								steal.RIDE.PEER.list = list
								if not (n3 > 0) then
									return true, n3
								end
								steal.RIDE.PeerFrame()
								return true, n3
							end

							return false, "response could not be parsed"
						end

						return false, "request failed"
					end

					return false, "request failed"
				end

				return false, "request failed"
			end

			return false, "failed to build request body"
		end

		return false, "nr_loader_key.txt missing"
	end

	return false, "peer sync dimatikan"
end

steal.RIDE.PeerStart = function()
	local peer = steal.RIDE.PEER

	if peer.ENABLED then
		if peer.on then
			return
		end

		if steal.Key() then
			peer.on = true
			tbl.LOG.info("RIDE", "peer sync aktif")

			task.spawn(function()
				while peer.on do
					if tbl.Alive then
						steal.RIDE.PeerPost(true)
						task.wait(peer.POLL)
						continue
					end

					break
				end

				peer.on = false
			end)

			return
		end

		tbl.LOG.warn("RIDE", "peer sync mati: " .. peer.KEYFILE .. " tidak ada di workspace")
		return
	end
end

steal.RIDE.PeerStop = function()
	local peer = steal.RIDE.PEER

	if peer.on then
		peer.on = false

		task.spawn(function()
			steal.RIDE.PeerPost(false)
		end)

		steal.RIDE.PeerClear()
		tbl.LOG.info("RIDE", "peer sync berhenti")
		return
	end

	steal.RIDE.PeerClear()
end

steal.RIDE.Sync = function()
	if steal.RIDE.Aktif() then
		local v4 = steal.RIDE.Pilih()

		if v4 ~= "" then
			steal.RIDE.Spawn(v4)
		end

		steal.RIDE.PeerStart()
		return
	end

	steal.RIDE.Despawn()
	steal.RIDE.PeerStop()
end

steal.RIDE.Preview = function(text)
	local guard = tbl.UIX and tbl.UIX.GUARD
	local viewport = guard and guard.Viewport

	if viewport then
		for _, child in ipairs(viewport:GetChildren()) do
			if child:IsA("Model") then
				child:Destroy()
			end
		end

		local v4 = steal.RIDE.Source(text)

		if v4 then
			local clone = v4:Clone()

			for _, v5 in ipairs({ "Collider", "CENTER", "HeadProxy", "EggPoint", "HumanoidRootPart" }) do
				local v6 = clone:FindFirstChild(v5, true)

				if v6 then
					local function fn20()
						v6:Destroy()
					end

					pcall(fn20)
				end
			end

			local humanoid = clone:FindFirstChildOfClass("Humanoid")

			if humanoid then
				local function fn20()
					humanoid:Destroy()
				end

				pcall(fn20)
			end

			for _, descendant in ipairs(clone:GetDescendants()) do
				if descendant:IsA("BasePart") then
					if not (math.min(descendant.Size.X, descendant.Size.Y, descendant.Size.Z) < 0.05) then
						descendant.Anchored = true
						descendant.CanCollide = false
					else
						local function fn20()
							descendant:Destroy()
						end

						pcall(fn20)
					end
				end
			end

			clone:PivotTo(CFrame.new())
			clone.Parent = viewport
			local boundingBox, v5 = clone:GetBoundingBox()
			local position = boundingBox.Position
			local n3 = math.max(v5.Y * 1.5, v5.X * 0.5, v5.Z * 0.5) + 3

			if viewport.CurrentCamera then
				viewport.CurrentCamera.CFrame = CFrame.lookAt(position + (Vector3.new(0.7, 0.3, -0.9)).Unit * n3, position)
			end

			if guard.Placeholder then
				guard.Placeholder.Visible = false
			end

			if guard.NameLabel then
				guard.NameLabel.Text = text
				return true
			end
			return true
		end

		if guard.Placeholder then
			guard.Placeholder.Visible = true
			return false
		end
		return false
	end

	return false
end

tbl.ST.Trove:Add(steal.RIDE.Despawn)
tbl.ST.Trove:Add(steal.RIDE.PeerStop)
steal.FUSE = { Pool = {}, Owned = {}, Scanned = 0 }
steal.FUSE.RELAY = "https://relay.nrlscript.com"
steal.FUSE.KEY_ALT = "NRL-WDVH3JTZ6J"
steal.FUSE.LIMIT = 20
steal.FUSE.net = { online = false, reason = "belum dicoba" }

steal.FUSE.Censor = function(arg)
	local str2 = tostring(arg or "")

	if str2 ~= "" then
		local n3 = #str2

		if not (n3 <= 2) then
			if not (n3 <= 4) then
				return str2:sub(1, 2) .. string.rep("*", n3 - 4) .. str2:sub(-2)
			end
			return str2:sub(1, 1) .. string.rep("*", n3 - 2) .. str2:sub(-1)
		end

		return str2
	end

	return "Anonymous"
end

steal.FUSE.Call = function(arg, arg2, arg3, arg4)
	task.spawn(function()
		local function fn20(reason)
			steal.FUSE.net.online = false
			steal.FUSE.net.reason = reason
			if arg4 then
				pcall(arg4, nil, reason)
				return
			end
		end

		local request_ = request or http_request or syn and syn.request
		if type(request_) ~= "function" then
			fn20("executor has no request()")
			return
		end
		local httpService = tbl.SV.HttpService
		local n3 = 236052221

		local function fn21(arg5)
			local tbl2 = { key = arg5, hwid = tostring(gethwid and gethwid() or ""), name = localPlayer.Name }
			local tbl3 = {}

			for k, v4 in pairs(tbl2) do
				tbl3[k] = v4
			end

			for k, v4 in pairs(arg3 or {}) do
				tbl3[k] = v4
			end

			if arg ~= "GET" then
				local ok, body = pcall(httpService.JSONEncode, httpService, tbl3)
				local tbl4 = { Url = steal.FUSE.RELAY .. arg2 }

				if n3 + 503541125 == 506479930 then
					tbl4.Method = "POST"
					tbl4.Headers = { ["Content-Type"] = "application/json", Accept = "application/json" }

					if not ok or not body then
						body = "{}"
					end

					tbl4.Body = body
					local ok2, result = pcall(request_, tbl4)
					if not ok2 then
						return nil, 0
					end

					if type(result) == "table" then
						local n4 = tonumber(result.StatusCode or result.Status) or 0
						local data = nil

						local function fn22()
							data = httpService:JSONDecode(tostring(result.Body or ""))
						end

						pcall(fn22)
						return type(data) == "table" and data or nil, n4, tostring(result.Body or "")
					end
				end

				return nil, 0
			end

			local tbl4 = {}

			for k, v4 in pairs(tbl3) do
				tbl4[#tbl4 + 1] = k .. "=" .. httpService:UrlEncode(tostring(v4))
			end

			local tbl5 = { Url = steal.FUSE.RELAY .. arg2 .. "?" .. table.concat(tbl4, "&") }
			tbl.LOG.warn("FUSE", "Relay request path unsupported; declining the request")
			return nil, 0
		end

		local keyAlt = steal.Key() or steal.FUSE.KEY_ALT
		n3 = 2938805
		local v4, v5 = fn21(keyAlt)

		if v5 == 401 and keyAlt ~= steal.FUSE.KEY_ALT then
			v4, v5 = fn21(steal.FUSE.KEY_ALT)
		end

		if v5 ~= 0 then
			if v5 ~= 404 then
				if v4 then
					if not (v5 >= 400) then
						steal.FUSE.net.online = true
						steal.FUSE.net.reason = "ok"
						if arg4 then
							pcall(arg4, v4, nil)
							return
						end
						return
					end

					fn20(tostring(v4.error or "HTTP " .. v5))
					return
				end

				fn20(("balasan bukan JSON (HTTP %d)"):format(v5))
				return
			end

			fn20("route " .. arg2 .. " belum ada di relay (404)")
			return
		end

		fn20("relay tidak terjangkau")
	end)
end

steal.FUSE.ServerCap = function()
	return ("%d/%d"):format(#tbl.SV.Players:GetPlayers(), tbl.SV.Players.MaxPlayers)
end

steal.KOTOR = {
	URL = "https://raw.githubusercontent.com/unclebitcoin100x-bot/waduhek/refs/heads/main/badwords.lua",
	mod = nil,
	AMBANG = 2,
	GANTI = "#####",
	COBA = 3,
	JEDA = 5,
}

steal.KOTOR.Muat = function()
	while true do
		local v4

		if I_1 <= 0 then
			if not (N_1 >= C_1) then
				break
			end
			v4 = N_1
		else
			if not (N_1 <= C_1) then
				break
			end
			v4 = N_1
		end

		local request_ = request or http_request or syn and syn.request
		if type(request_) ~= "function" then
			tbl.LOG.warn("KOTOR", "executor tidak punya request()")
			return
		end
		local ok, result = pcall(request_, { Url = steal.KOTOR.URL, Method = "GET" })
		local body = ok and result and (result.Body or result.body)

		if body and #body > 0 then
			local chunk, v5 = loadstring(body, "badwords")

			if chunk then
				local ok2, mod = pcall(chunk)

				if ok2 and type(mod) == "table" and type(mod.Sensor) == "function" then
					steal.KOTOR.mod = mod
					tbl.LOG.info("KOTOR", ("daftar kata dimuat (%d byte)"):format(#body))
					return
				end

				tbl.LOG.warn("KOTOR", "isi bukan modul penyaring: " .. tostring(mod))
			else
				tbl.LOG.warn("KOTOR", "gagal dikompilasi: " .. tostring(v5))
			end
		end

		if v4 < steal.KOTOR.COBA then
			task.wait(steal.KOTOR.JEDA)
		end
	end

	tbl.LOG.warn("KOTOR", "daftar kata tidak bisa ditarik - chat jalan tanpa sensor")
end

steal.KOTOR.Sensor = function(arg)
	local mod = steal.KOTOR.mod

	if mod then
		local ok, result = pcall(mod.Sensor, arg, steal.KOTOR.AMBANG, "\1")

		if ok then
			if type(result) ~= "string" then
				return arg
			end
			local str2 = result:gsub("\1+", steal.KOTOR.GANTI)
			local ok2, result2 = pcall(mod.Periksa, str2, steal.KOTOR.AMBANG)
			if ok2 and result2 and result2 > 0 then
				return steal.KOTOR.GANTI
			end
			return str2
		end

		return arg
	end

	return arg
end

task.spawn(steal.KOTOR.Muat)
steal.CHAT = { Room = "GLOBAL", Msgs = {}, Since = {}, on = false, step = 1 }
steal.CHAT.ROOMS = { "GLOBAL", "GLOBAL_EN" }
steal.CHAT.SIMPAN = 60
steal.CHAT.PANJANG = 180
steal.CHAT.TANGGA = { 2, 4, 8, 15, 25 }
steal.CHAT.JEDA_TUTUP = 40
steal.CHAT.OnNew = nil
steal.CHAT.SFX_SIAR = "139746569667955"
steal.CHAT.siarSeen = {}
steal.CHAT.SIAR_UMUR = 90
steal.CHAT.MAKS_BUKA = 8

local function jeda()
	local tangga = steal.CHAT.TANGGA
	return math.min(tangga[math.clamp(steal.CHAT.step, 1, #tangga)], steal.CHAT.MAKS_BUKA)
end

steal.CHAT.Jeda = jeda

steal.CHAT.Reset = function()
	steal.CHAT.step = 1
end

steal.CHAT.Mundur = function()
	steal.CHAT.step = math.min(steal.CHAT.step + 1, #steal.CHAT.TANGGA)
end

steal.CHAT.Kamar = function(arg)
	local flag2 = arg == "GLOBAL"
	if flag2 then
		return flag2
	end
	return arg == "GLOBAL_EN"
end

steal.CHAT.UidCache = {}
steal.CHAT.UidJalan = {}

steal.CHAT.Uid = function(arg, arg2)
	local str2 = tostring(arg or "")

	if str2 ~= "" then
		local v4 = steal.CHAT.UidCache[str2]
		if v4 then
			return v4
		end
		local v5 = tbl.SV.Players:FindFirstChild(str2)
		if v5 then
			steal.CHAT.UidCache[str2] = v5.UserId
			return v5.UserId
		end

		if steal.CHAT.UidJalan[str2] then
			return nil
		end
		steal.CHAT.UidJalan[str2] = true

		task.spawn(function()
			local ok, result = pcall(function()
				return tbl.SV.Players:GetUserIdFromNameAsync(str2)
			end)

			steal.CHAT.UidJalan[str2] = nil
			steal.CHAT.UidCache[str2] = ok and tonumber(result) or 0
			if ok and tonumber(result) and arg2 then
				pcall(arg2, tonumber(result))
				return
			end
		end)

		return nil
	end

	return nil
end

steal.CHAT.Baca = function(arg)
	local str2 = tostring(arg or "")
	local flag2 = str2:match("%[PREM:1%]") ~= nil
	local match = str2:match("%[FN:([^%]]+)%]")
	local match2, v4 = str2:match("%[SRV:([^:]+):([^%]]+)%]")
	return str2:gsub("%s*%[SRV:[^%]]+%]%s*", ""):gsub("%s*%[FN:[^%]]+%]%s*", ""):gsub("%s*%[PREM:[^%]]+%]%s*", ""):gsub("^%s+", ""):gsub("%s+$", ""), flag2, match, match2, v4
end

steal.CHAT.Wire = function(arg)
	return ("%s [FN:%s] [SRV:%s:%s]"):format(arg, steal.CHAT.NamaSamaran(), steal.FUSE.ServerCap(), tostring(game.JobId))
end

steal.CHAT.Simpan = function(arg, arg2)
	local tbl2 = steal.CHAT.Msgs[arg]

	if not tbl2 then
		tbl2 = {}
		steal.CHAT.Msgs[arg] = tbl2
	end

	local n3 = 0

	for _, v4 in ipairs(arg2) do
		local n4 = tonumber(v4.at) or 0
		local v5 = steal.CHAT.Since[arg]

		if v5 then
			if v5 < n4 then
				steal.CHAT.Since[arg] = n4
			end
		elseif n4 > 0 then
			steal.CHAT.Since[arg] = n4
		end

		local v6, v7, v8, v9, v10 = steal.CHAT.Baca(v4.text)
		local v11, v12, v13 = steal.MOD.Tangani(v4, v6)

		if v13 and v13 ~= "" then
			n3 += 1
			tbl2[#tbl2 + 1] = { from = "SYSTEM", teks = v13, at = n4, sistem = true }
		elseif v6 ~= "" and not v11 then
			local match = v6:match("^%[BROADCAST%]%s*(.+)$")
			local str2 = tostring(steal.CHAT.NamaSamaran() or ""):lower()
			local flag2 = str2 ~= ""

			if flag2 then
				flag2 = tostring(v4.from or ""):lower() == str2
			end

			n3 += 1

			tbl2[#tbl2 + 1] = {
				from = tostring(v4.from or "?"),
				teks = steal.KOTOR.Sensor(match or v6),
				at = n4,
				siar = match ~= nil,
				prem = v7,
				fn = v8,
				cap = v9,
				job = v10,
				dibisu = v12,
			}

			if match and not flag2 and os.time() - n4 <= steal.CHAT.SIAR_UMUR then
				local str3 = ("%s|%d"):format(tostring(v4.from or "?"), n4)

				if not steal.CHAT.siarSeen[str3] then
					steal.CHAT.siarSeen[str3] = true

					steal.Banner({
						teks = ("<font color=\"#FF453A\"><b>[BROADCAST] </b></font><font color=\"#FFE066\"><b>%s</b></font>: %s"):format(steal.CHAT.NamaTampil(v4.from), match),
						detik = 10,
						sfx = steal.CHAT.SFX_SIAR,
						volume = 0.9,
						unik = "SAE_SIAR_" .. str3,
					})
				end
			end
		end
	end

	while steal.CHAT.SIMPAN < #tbl2 do
		table.remove(tbl2, 1)
	end

	return n3
end

steal.CHAT.Fetch = function(arg)
	if steal.CHAT.tarik and os.clock() - (steal.CHAT.tarikAt or 0) < 30 then
		if arg then
			arg(0, "sedang menarik")
			return
		end
		return
	end

	local chat = steal.CHAT
	local chat2 = steal.CHAT
	local now = os.clock()
	chat.tarik = true
	chat2.tarikAt = now
	local room = steal.CHAT.Room
	local n3 = steal.CHAT.Since[room] or 0
	local tbl2, str2

	if steal.CHAT.Kamar(room) then
		tbl2 = { name = room, since = n3 }
		str2 = "/api/fuse/chat/inbox"
	else
		tbl2 = { with = room, since = n3 }
		str2 = "/api/fuse/chat/poll"
	end

	local function fn20(arg2, arg3)
		steal.CHAT.tarik = false

		if not arg3 and arg2 then
			local v4 = steal.CHAT.Simpan(room, arg2.msgs or {})

			if not (v4 > 0) then
				steal.CHAT.Mundur()
			else
				steal.CHAT.Reset()

				if steal.CHAT.OnNew then
					local ok, result = pcall(steal.CHAT.OnNew, v4)

					if not ok then
						tbl.LOG.warn("CHAT", "gagal menggambar: " .. tostring(result))
					end
				end
			end

			if arg then
				arg(v4, nil)
				return
			end
			return
		end

		if tostring(arg3):find("rate_limited") then
			steal.CHAT.step = #steal.CHAT.TANGGA
		end

		steal.CHAT.lastErr = tostring(arg3)
		tbl.LOG.warn("CHAT", "gagal ambil " .. room .. ": " .. tostring(arg3))
		if arg then
			arg(0, arg3)
			return
		end
	end

	steal.FUSE.Call("GET", str2, tbl2, fn20)
end

steal.CHAT.Send = function(arg, arg2, arg3)
	local str2 = tostring(arg or ""):gsub("^%s+", ""):gsub("%s+$", "")

	if str2 ~= "" then
		if steal.CHAT.PANJANG < #str2 then
			str2 = str2:sub(1, steal.CHAT.PANJANG)
		end

		local str3 = steal.KOTOR.Sensor(str2)

		if steal.MOD.SayaBisu() then
			local n3 = math.max(0, steal.MOD.sayaSampai - os.time())
			tbl.LOG.warn("CHAT", ("kamu dibisukan, sisa %d detik"):format(n3))
			if arg2 then
				arg2("dibisukan")
				return false
			end
			return false
		end

		local rooms

		if arg3 then
			str3 = "[BROADCAST] " .. str3
			rooms = steal.CHAT.ROOMS or { steal.CHAT.Room }
		else
			rooms = { steal.CHAT.Room }
		end

		local n3 = #rooms
		local v4 = nil

		for _, room in ipairs(rooms) do
			local call = steal.FUSE.Call

			local tbl2 = {
				to = room,
				text = steal.CHAT.Wire(str3),
				server = steal.FUSE.ServerCap(),
				jobId = tostring(game.JobId),
				uid = localPlayer.UserId,
			}

			local function fn20(arg4, arg5)
				v4 = v4 or arg5
				n3 -= 1

				if not (n3 > 0) then
					steal.CHAT.Reset()

					if not v4 then
						task.delay(0.3, function()
							steal.CHAT.Fetch()
						end)
					end

					if arg2 then
						arg2(v4)
						return
					end
					return
				end
			end

			call("POST", "/api/fuse/chat/send", tbl2, fn20)
		end

		return true
	end

	return false
end

steal.CHAT.Open = function(room)
	steal.CHAT.Room = room
	steal.CHAT.Reset()
	if steal.CHAT.Msgs[room] then
		return
	end
	steal.CHAT.Fetch()
end

steal.CHAT.Terlihat = function()
	local chatWin = tbl.UIX and tbl.UIX.ChatWin
	if chatWin and chatWin.Visible then
		return true
	end
	return false
end

steal.CHAT.Start = function()
	if steal.CHAT.on then
		return
	end
	steal.CHAT.on = true

	task.spawn(function()
		task.wait(steal.CHAT.TANGGA[1])
		local now = os.clock()

		while steal.CHAT.on do
			if tbl.Alive then
				if steal.CHAT.Terlihat() then
					now = os.clock()
					steal.CHAT.Fetch()
					task.wait(steal.CHAT.Jeda())
				else
					steal.CHAT.step = #steal.CHAT.TANGGA

					if steal.CHAT.JEDA_TUTUP <= os.clock() - now then
						now = os.clock()
						steal.CHAT.Fetch()
					end

					task.wait(5)
				end

				continue
			end

			break
		end

		steal.CHAT.on = false
	end)

	tbl.LOG.info("CHAT", "pengawas aktif")
end

steal.CHAT.Stop = function()
	if steal.CHAT.on then
		steal.CHAT.on = false
		tbl.LOG.info("CHAT", "pengawas berhenti")
		return
	end
end

tbl.ST.Trove:Add(steal.CHAT.Stop)
steal.CHAT.OWNER = { id = 3992573098, nama = "rdkvfx", alias = "nasi", tampil = "Nasi" }
steal.CHAT.MOD = { id = 10058545327, nama = "xcasamaru", alias = "sleketep", tampil = "Sleketep" }

local function fn20(arg, arg2, arg3)
	if arg3 and tonumber(arg3) == arg.id then
		return true
	end
	local str2 = tostring(arg2 or ""):lower()
	local flag2 = str2 ~= ""

	if flag2 then
		flag2 = str2 == arg.nama
		if not flag2 then
			return str2 == arg.alias
		end
	end

	return flag2
end

steal.CHAT.Staf = function(arg, arg2)
	if fn20(steal.CHAT.OWNER, arg, arg2) then
		return "owner"
	end

	if fn20(steal.CHAT.MOD, arg, arg2) then
		return "mod"
	end
	return nil
end

steal.CHAT.NamaTampil = function(arg, arg2)
	if steal.CHAT.Staf(arg) ~= "owner" then
		if arg2 then
			return arg2
		end
		return (tostring(arg or "?"))
	end

	return "Owner"
end

local chat
chat = steal.CHAT
local lucu
lucu = {}
lucu[1] = "Bejo"
lucu[2] = "Budi"
lucu[3] = "Adul"
lucu[4] = "Kiwil"
lucu[5] = "Komeng"
lucu[6] = "Jule"
lucu[7] = "Anto"
lucu[8] = "Samsudi"
lucu[9] = "Udin"
lucu[10] = "Ucok"
lucu[11] = "Tejo"
lucu[12] = "Jupri"
lucu[13] = "Tarjo"
lucu[14] = "Parto"
lucu[15] = "Maman"
lucu[16] = "Asep"
lucu[17] = "Bambang"
lucu[18] = "Jajang"
lucu[19] = "Tukul"
lucu[20] = "Slamet"
lucu[21] = "Wawan"
lucu[22] = "Dadang"
lucu[23] = "Sugiono"
lucu[24] = "Paijo"
lucu[25] = "Untung"
lucu[26] = "Basuki"
lucu[27] = "Mukidi"
lucu[28] = "Cecep"
lucu[29] = "Tarno"
lucu[30] = "Sukiman"
lucu[31] = "Gatot"
lucu[32] = "Diding"
lucu[33] = "Entis"
lucu[34] = "Onyod"
lucu[35] = "Kadir"
lucu[36] = "Doyok"
lucu[37] = "Jarwo"
lucu[38] = "Sapri"
lucu[39] = "Bono"
lucu[40] = "Giman"
chat.LUCU = lucu

steal.CHAT.KEREN = {
	"Justin",
	"Mark",
	"Nicholas",
	"Alexander",
	"Christian",
	"Edward",
	"William",
	"Sebastian",
	"Dominic",
	"Adrian",
}

steal.CHAT.NamaSamaran = function()
	if steal.CHAT.samaran then
		return steal.CHAT.samaran
	end
	local v4 = steal.CHAT.Staf(localPlayer.Name, localPlayer.UserId)

	if v4 == "owner" then
		steal.CHAT.samaran = steal.CHAT.OWNER.tampil
	elseif v4 ~= "mod" then
		local keren = math.random(1, 100) <= 7 and steal.CHAT.KEREN or steal.CHAT.LUCU
		steal.CHAT.samaran = keren[math.random(1, #keren)]
	else
		steal.CHAT.samaran = steal.CHAT.MOD.tampil
	end

	return steal.CHAT.samaran
end

steal.TAG = { cx = {}, pasang = {} }

steal.TAG.WARNA = {
	owner = { Color3.new(1, 0.84313726425170898, 0.23529411852359772), "👑 OWNER" },
	mod = { Color3.new(0.31372550129890442, 0.7450980544090271, 1), "🛡 MOD" },
}

steal.TAG.Pasang = function(arg, arg2)
	local v4 = steal.CHAT.Staf(arg.Name, arg.UserId)
	if not v4 then
		return
	end
	local character = arg2 or arg.Character
	if not character then
		return
	end

	task.spawn(function()
		local head = character:FindFirstChild("Head") or character:WaitForChild("Head", 10)

		if head then
			if head.Parent then
				local v5 = steal.TAG.pasang[arg.UserId]

				if v5 and v5.Parent then
					v5:Destroy()
				end

				local v6 = steal.TAG.WARNA[v4][1]
				local v7 = steal.TAG.WARNA[v4][2]
				local billboardGui = Instance.new("BillboardGui")
				billboardGui.Name = "t" .. tostring(math.random(100000, 999999))
				billboardGui.Adornee = head
				billboardGui.Size = UDim2.new(0, 120, 0, 26)
				billboardGui.StudsOffsetWorldSpace = Vector3.new(0, 3.2, 0)
				billboardGui.AlwaysOnTop = true
				billboardGui.MaxDistance = 250
				billboardGui.ResetOnSpawn = false
				billboardGui.Parent = head
				local frame = Instance.new("Frame")
				frame.Size = UDim2.new(1, 0, 1, 0)
				frame.BackgroundColor3 = Color3.new(0.054901961237192154, 0.047058824449777603, 0.078431375324726105)
				frame.BackgroundTransparency = 0.15
				frame.BorderSizePixel = 0
				frame.Parent = billboardGui
				local uiCorner = Instance.new("UICorner")
				uiCorner.CornerRadius = UDim.new(1, 0)
				uiCorner.Parent = frame
				local uiStroke = Instance.new("UIStroke")
				uiStroke.Color = v6
				uiStroke.Thickness = 1.4
				uiStroke.Parent = frame
				local textLabel = Instance.new("TextLabel")
				textLabel.Size = UDim2.new(1, 0, 1, 0)
				textLabel.BackgroundTransparency = 1
				textLabel.FontFace = Font.fromEnum(Enum.Font.GothamBold)
				textLabel.TextSize = 13
				textLabel.TextColor3 = v6
				textLabel.Text = v7
				textLabel.Parent = frame
				steal.TAG.pasang[arg.UserId] = billboardGui
				return
			end

			return
		end
	end)
end

steal.TAG.Start = function()
	if steal.TAG.on then
		return
	end
	steal.TAG.on = true
	local players = tbl.SV.Players

	for _, player in ipairs(players:GetPlayers()) do
		steal.TAG.Pasang(player)
		local n3 = #steal.TAG.cx + 1
		local characterAdded = player.CharacterAdded
		local v4 = characterAdded
		local connect = characterAdded.Connect

		local function fn21(arg)
			steal.TAG.Pasang(player, arg)
		end

		steal.TAG.cx[n3] = connect(v4, fn21)
	end

	local n3 = #steal.TAG.cx + 1
	local playerAdded = players.PlayerAdded
	local v4 = playerAdded
	local connect = playerAdded.Connect

	local function fn21(arg)
		steal.TAG.Pasang(arg)

		steal.TAG.cx[#steal.TAG.cx + 1] = arg.CharacterAdded:Connect(function(character)
			steal.TAG.Pasang(arg, character)
		end)
	end

	steal.TAG.cx[n3] = connect(v4, fn21)
end

steal.TAG.Stop = function()
	if steal.TAG.on then
		steal.TAG.on = false

		for _, v4 in ipairs(steal.TAG.cx) do
			pcall(function()
				v4:Disconnect()
			end)
		end

		steal.TAG.cx = {}

		for k, v4 in pairs(steal.TAG.pasang) do
			pcall(function()
				v4:Destroy()
			end)

			steal.TAG.pasang[k] = nil
		end

		return
	end
end

tbl.ST.Trove:Add(steal.TAG.Stop)
steal.MOD = { bisu = {}, bisuUid = {}, sayaSampai = 0 }
steal.MOD.FILE = tbl.FS.Root .. "/mute.txt"

do
	local mod = steal.MOD

	local prank = {
		Divine = {
			pre = "A ",
			inti = "Divine ArchAngel Egg",
			pos = " spawned in Angels 👼 !",
			warna = Color3.new(0.9843137264251709, 1, 0),
			warnaTeks = Color3.new(0.9843137264251709, 1, 0),
			sfx = "96311503946691",
		},
		Eternal = {
			pre = "An ",
			inti = "Eternal Pegasus Egg",
			pos = " spawned in Light Dark ☯️ !",
			warna = Color3.new(1, 0.11764705926179886, 0.94117647409439087),
			warnaTeks = Color3.new(1, 0.11764705926179886, 0.94117647409439087),
			sfx = "1839901345",
		},
	}

	local secret = { pre = "A ", inti = "Secret Pure Jelly Fish Egg" }
	secret.pos = " spawned in Light Dark ☯️ !"
	secret.warna = Color3.new(0.86274510622024536, 0.86274510622024536, 0.88235294818878174)
	secret.warnaTeks = Color3.new(0.18039216101169586, 0.18039216101169586, 0.18039216101169586)
	secret.sfx = "98703439190720"
	prank.Secret = secret
	mod.PRANK = prank

	steal.MOD.PRANK_URUT = {
		{ kode = "Divine", nama = "Divine ArchAngel Egg", zona = "Angels Zone" },
		{ kode = "Eternal", nama = "Eternal Pegasus Egg", zona = "Light Dark Zone" },
		{ kode = "Secret", nama = "Secret Pure Jelly Fish", zona = "Light Dark Zone" },
	}

	steal.MOD.DURASI = { 5, 10, 15, 30, 60, 120 }

	steal.MOD.Staf = function()
		return steal.CHAT.Staf(localPlayer.Name, localPlayer.UserId)
	end

	steal.MOD.Bisu = function(arg, arg2)
		local now = os.time()
		local str2 = tostring(arg or ""):lower()

		if str2 ~= "" then
			local v4 = steal.MOD.bisu[str2]

			if v4 then
				if now < v4 then
					return true
				end
			elseif now < 0 then
				return true
			end
		end

		local str3 = tostring(arg2 or "")

		if str3 ~= "" then
			local v4 = steal.MOD.bisuUid[str3]

			if v4 then
				if now < v4 then
					return true
				end
			elseif now < 0 then
				return true
			end

			return false
		end

		return false
	end

	steal.MOD.SayaBisu = function()
		return steal.MOD.sayaSampai > os.time()
	end

	steal.MOD.Muat = function()
		local v4 = tbl.FS.Read(steal.MOD.FILE)
		steal.MOD.sayaSampai = tonumber(v4) or 0
	end

	steal.MOD.SimpanBisu = function(sayaSampai)
		steal.MOD.sayaSampai = sayaSampai
		tbl.FS.Write(steal.MOD.FILE, tostring(sayaSampai))
	end

	steal.MOD.Terap = function(arg, arg2, arg3)
		local str2 = tostring(arg or ""):lower()

		if str2 ~= "" then
			steal.MOD.bisu[str2] = arg3
		end

		local str3 = tostring(arg2 or "")

		if str3 ~= "" and str3 ~= "0" then
			steal.MOD.bisuUid[str3] = arg3
		end

		if str2 ~= localPlayer.Name:lower() then
			if str3 == "" then
				return false
			end

			if str3 ~= tostring(localPlayer.UserId) then
				return false
			end
		end

		steal.MOD.SimpanBisu(arg3)
		return true
	end

	steal.Banner = function(arg)
		local fn21

		if arg.sfx then
			fn21 = function()
				local sound = Instance.new("Sound")
				sound.SoundId = "rbxassetid://" .. arg.sfx
				sound.Volume = arg.volume or 1
				sound.Parent = game:FindService("SoundService")
				sound:Play()
				game:GetService("Debris"):AddItem(sound, 8)
			end
		else
			fn21 = nil
		end

		if pcall(function()
			require(tbl.SV.ReplicatedStorage.Client.Notifications.Message).Top({ Message = arg.teks, Time = arg.detik or 6, WrapText = true }, { PreventDuplicateText = arg.unik ~= nil or nil, OnAppear = fn21 })
		end) then
			return true
		end

		local ok, result = pcall(function()
			local replicatedStorage = tbl.SV.ReplicatedStorage
			local Lanes = require(replicatedStorage.Client.Notifications.Lanes)
			local clone = replicatedStorage.Assets.UI.Notifs.MsgNotif:Clone()
			local plate = clone:FindFirstChild("Plate")
			local body = plate and plate:FindFirstChild("Body")

			if not body then
				error("MsgNotif.Plate.Body hilang", 0)
			end

			body.Text = arg.teks
			local preText = plate:FindFirstChild("PreText")

			if preText then
				preText.Visible = false
			end

			local icon = plate:FindFirstChild("Icon")

			if icon then
				icon.Visible = false
			end

			Lanes.Schedule({ Lane = "Banner", Frame = clone, Seconds = arg.detik or 6, UniqueKey = arg.unik, OnShown = fn21 })
		end)

		if ok then
			return ok
		end
		tbl.LOG.warn("UI", "banner gagal: " .. tostring(result))
		return ok
	end

	steal.CEK = {
		{ "remote", "Packages.Networking", nil, true },
		{ "Save", "Shared.Save", nil, true },
		{ "Assets", "Data.Assets", "Directory", true },
		{ "Areas", "Data.Areas" },
		{ "penghasilan", "Shared.Util.AssetEarnings", "RatePerSecond" },
		{ "fusion", "Shared.Flags.ShrineFusionFlags", "Recipes" },
		{ "GUI", "Client.GUI", "DropHeldEgg" },
		{ "Tabs", "Client.Tabs", "Toggle" },
	}

	steal.Temukan = function()
		local replicatedStorage = tbl.SV.ReplicatedStorage
		local tbl2 = {}
		local tbl3 = {}

		for _, v4 in ipairs(steal.CEK) do
			local v5 = replicatedStorage

			for match in v4[2]:gmatch("[^%.]+") do
				v5 = v5 and v5:FindFirstChild(match)
			end

			local flag2 = v5 ~= nil

			if flag2 and v4[3] then
				local ok, result = pcall(require, v5)
				flag2 = ok and type(result) == "table"
				if (not flag2 or result[v4[3]] ~= nil) and flag2 then
					continue
				end
			elseif flag2 then
				continue
			end

			local v6 = if v4[3] then v4[1] .. "." .. v4[3] else v4[1]
			tbl2[#tbl2 + 1] = v6

			if v4[4] then
				tbl3[#tbl3 + 1] = v6
			end
		end

		local client = replicatedStorage:FindFirstChild("Client")
		local notifications = client and client:FindFirstChild("Notifications")

		if notifications then
			if notifications:FindFirstChild("Message") or notifications:FindFirstChild("Lanes") then
				return tbl2, tbl3
			end
			tbl2[#tbl2 + 1] = "banner"
			return tbl2, tbl3
		end

		tbl2[#tbl2 + 1] = "banner"
		return tbl2, tbl3
	end

	steal.CekGame = function()
		local v4 = steal.Temukan()

		if #v4 ~= 0 then
			tbl.LOG.warn("CEK", ("place v%d: %d jalur game HILANG -> %s"):format(game.PlaceVersion, #v4, table.concat(v4, ", ")))

			if tbl.UIX then
				if tbl.UIX.Pita then
					pcall(tbl.UIX.Pita, "Game update: " .. table.concat(v4, ", "), 10)
				end

				return v4
			end

			return v4
		end

		tbl.LOG.warn("CEK", ("place v%d: semua jalur game utuh"):format(game.PlaceVersion))
		return v4
	end

	task.spawn(function()
		task.wait(4)
		pcall(steal.CekGame)
	end)

	steal.MOD.Banner = function(arg)
		local v4 = steal.MOD.PRANK[arg]

		if v4 then
			return steal.Banner({
				teks = ("%s<font color=\"#%s\">%s</font>%s"):format(v4.pre, v4.warnaTeks:ToHex(), v4.inti, v4.pos),
				detik = 6,
				sfx = v4.sfx,
				volume = 2.5,
			})
		end

		return false
	end

	steal.MOD.Siar = function(arg, arg2)
		local n3 = 0
		local v4

		for _, room in ipairs(steal.CHAT.ROOMS) do
			steal.FUSE.Call("POST", "/api/fuse/chat/send", {
				to = room,
				text = arg,
				server = steal.FUSE.ServerCap(),
				jobId = tostring(game.JobId),
				uid = localPlayer.UserId,
			}, function(arg3, arg4)
				n3 += 1
				v4 = v4 or arg4
				if n3 == #steal.CHAT.ROOMS and arg2 then
					arg2(v4)
					return
				end
			end)
		end
	end

	steal.MOD.KirimPrank = function(arg, arg2, arg3, arg4)
		if steal.MOD.Staf() then
			if steal.MOD.PRANK[arg] then
				if tostring(arg2):lower() == localPlayer.Name:lower() then
					steal.MOD.Banner(arg)
				end

				local v4 = tostring

				steal.MOD.Siar(("[PRANK:%s:%s:%s]"):format(arg, tostring(arg2), v4(arg3 or "")), function(arg5)
					steal.MOD.Tanda(("Prank %s dikirim ke %s -- banner muncul di layar dia begitu kliennya menarik kamar (15 dtk kalau chatnya kebuka, sampai 40 dtk kalau tertutup)"):format(arg, steal.FUSE.Censor(arg2)), arg5)
					if arg4 then
						arg4(arg5)
						return
					end
				end)

				return true
			end

			if arg4 then
				arg4("tier tidak dikenal")
				return false
			end
			return false
		end

		if arg4 then
			arg4("bukan staf")
			return false
		end
		return false
	end

	steal.MOD.KirimBisu = function(arg, arg2, arg3, arg4)
		if steal.MOD.Staf() then
			local n3 = tonumber(arg3) or 10
			local n4 = os.time() + n3 * 60
			steal.MOD.Terap(arg, arg2, n4)
			local v4 = tostring

			steal.MOD.Siar(("User %s dibisukan %d menit [MUTE:%s:%s:%d:%d]"):format(steal.FUSE.Censor(arg), n3, tostring(arg), v4(arg2 or ""), n3, n4), function(arg5)
				steal.MOD.Tanda(("%s dibisukan %d menit"):format(steal.FUSE.Censor(arg), n3), arg5)
				if arg4 then
					arg4(arg5)
					return
				end
			end)

			return true
		end

		if arg4 then
			arg4("bukan staf")
			return false
		end
		return false
	end

	steal.MOD.KirimBuka = function(arg, arg2, arg3)
		if steal.MOD.Staf() then
			steal.MOD.Terap(arg, arg2, 0)
			local v4 = tostring

			steal.MOD.Siar(("Bisu %s dibuka [UNMUTE:%s:%s]"):format(steal.FUSE.Censor(arg), tostring(arg), v4(arg2 or "")), function(arg4)
				steal.MOD.Tanda(("Bisu %s dibuka"):format(steal.FUSE.Censor(arg)), arg4)
				if arg3 then
					arg3(arg4)
					return
				end
			end)

			return true
		end

		if arg3 then
			arg3("bukan staf")
			return false
		end
		return false
	end

	steal.MOD.Tangani = function(arg, arg2)
		local str2 = tostring(arg.from or "")
		local flag2 = steal.CHAT.Staf(str2) ~= nil
		local match, v4, v5 = arg2:match("%[PRANK:([^:]*):([^:]*):([^%]]*)%]")

		if match then
			if flag2 then
				if tostring(v4):lower() ~= localPlayer.Name:lower() then
					if v5 == "" then
						return true
					end

					if v5 == "0" then
						return true
					end

					if v5 ~= tostring(localPlayer.UserId) then
						return true
					end
				end

				steal.MOD.Banner(match)
				return true
			end

			return true
		end

		local match2, v6, v7, v8 = arg2:match("%[MUTE:([^:]*):([^:]*):(%d+):(%d+)%]")

		if match2 then
			if flag2 then
				if steal.MOD.Terap(match2, v6, tonumber(v8) or os.time() + (tonumber(v7) or 10) * 60) then
					tbl.LOG.warn("MOD", ("kamu dibisukan %s menit"):format(tostring(v7)))
				end

				local match3 = arg2:match("^(.-)%s*%[MUTE:")
				if match3 then
					return true, false, match3
				end
				return true, false, ""
			end

			return true
		end

		local match3, v9 = arg2:match("%[UNMUTE:([^:]*):([^%]]*)%]")

		if match3 then
			if flag2 then
				if steal.MOD.Terap(match3, v9, 0) then
					tbl.LOG.warn("MOD", "bisu kamu dibuka")
				end

				local match4 = arg2:match("^(.-)%s*%[UNMUTE:")
				if match4 then
					return true, false, match4
				end
				return true, false, ""
			end

			return true
		end

		if arg2:match("%[VOTE_MUTE_START:") then
			return true
		end

		if arg2:match("%[VOTE_MUTE_CAST:") then
			return true
		end

		if arg2:match("^%[SYSTEM") then
			return true
		end

		if not steal.MOD.Bisu(str2, steal.CHAT.UidCache[str2]) or flag2 then
			return false
		end

		if steal.MOD.Staf() then
			return false, true
		end
		return true
	end

	steal.MOD.Sistem = function(arg)
		local v4 = steal.CHAT.Msgs[steal.CHAT.Room]

		if v4 then
			v4[#v4 + 1] = { from = "SYSTEM", teks = arg, at = os.time(), sistem = true }

			while steal.CHAT.SIMPAN < #v4 do
				table.remove(v4, 1)
			end

			if steal.CHAT.OnNew then
				pcall(steal.CHAT.OnNew, 1)
				return
			end
			return
		end
	end

	steal.MOD.Tanda = function(arg, arg2)
		local sistem = steal.MOD.Sistem

		if arg2 then
			arg ..= " GAGAL: " .. tostring(arg2)
		end

		sistem(arg)
	end

	steal.MOD.Muat()
	local scr = { on = false, balik = false }
	scr.AutoHit = false
	scr.AutoParts = false
	scr.Tier = "All"
	scr.Status = "Idle"
	scr.Drones = 0
	scr.Samples = 0
	scr.Parts = 0
	scr.snap = nil
	scr.snapAt = 0
	scr.ambil = {}
	scr.conn = nil
	scr.pulang = nil
	scr.AutoBuy = false
	scr.BeliPilih = {}
	scr.Dibeli = 0
	scr.beliJalan = false
	scr.beliNext = 0
	scr.jedaSesi = 0
	scr.sesi = false
	steal.SCR = scr
end

steal.SCR.Aktif = function()
	local on = steal.SCR.on
	if on then
		return on
	end
	return steal.SCR.sesi
end

steal.SCR.TIERS = {
	{ kode = "All", label = "All Drones (Any)" },
	{ kode = "AugmentedDrone", label = "Drone 3 - Augmented (10 HP)" },
	{ kode = "ReactorDrone", label = "Drone 2 - Reactor (5 HP)" },
	{ kode = "ScrapDrone", label = "Drone 1 - Scrap (3 HP)" },
}

steal.SCR.Snapshot = function(arg)
	local now = os.clock()
	if not arg and steal.SCR.snap and now - steal.SCR.snapAt < 5 then
		return steal.SCR.snap
	end
	local Scramble = tbl.NET.Get("Scramble", "Request")
	if not Scramble then
		return steal.SCR.snap
	end

	local function fn21()
		return Scramble:InvokeServer("Snapshot")
	end

	local ok, snap = pcall(fn21)

	if ok then
		if type(snap) ~= "table" then
			return steal.SCR.snap
		end
		local scr = steal.SCR
		steal.SCR.snap = snap
		scr.snapAt = now
		local state = snap.State
		if type(state) ~= "table" then
			return snap
		end
		steal.SCR.Samples = tonumber(state.Samples) or 0
		steal.SCR.Parts = tonumber(state.TotalParts) or 0
		return snap
	end

	return steal.SCR.snap
end

steal.SCR.SIKLUS = 1800
steal.SCR.DURASI = 300

steal.SCR.Jendela = function()
	local serverTimeNow = v:GetServerTimeNow()
	local n3 = math.floor(serverTimeNow / steal.SCR.SIKLUS)
	local n4 = n3 * steal.SCR.SIKLUS
	local n5 = n4 + steal.SCR.DURASI
	local n6 = (n3 + 1) * steal.SCR.SIKLUS
	local flag2 = n4 <= serverTimeNow and serverTimeNow < n5 or v:GetAttribute("ScrambleOutbreakActive") == true
	local max = math.max
	local floor = math.floor

	if not flag2 then
		n5 = n6
	end

	return flag2, max(0, floor(n5 - serverTimeNow))
end

steal.SCR.DroneServer = function()
	local num = tonumber(v:GetAttribute("ScrambleActiveDrones"))
	if num then
		return num
	end
	return 0
end

steal.SCR.tierCache = {}

steal.SCR.TierDrone = function(arg, arg2)
	local name

	if arg then
		local attribute = arg:GetAttribute("ScrambleDroneId")

		if attribute then
			name = attribute
		else
			name = arg.Name or "?"
		end
	else
		name = "?"
	end

	local v4 = steal.SCR.tierCache[name]
	if v4 then
		return v4
	end

	local function fn21(arg3)
		steal.SCR.tierCache[name] = arg3
		return arg3
	end

	local attribute = arg and arg:GetAttribute("ScrambleTier") or arg2 and arg2:GetAttribute("ScrambleTier")
	local attribute2

	if type(attribute) ~= "string" then
		attribute2 = arg and arg:GetAttribute("TemplateSource")
	else
		if attribute ~= "" then
			if attribute:find("Augmented") then
				return (fn21("AugmentedDrone"))
			end

			if attribute:find("Reactor") then
				return (fn21("ReactorDrone"))
			end

			if attribute:find("Scrap") then
				return (fn21("ScrapDrone"))
			end
		end

		attribute2 = arg and arg and arg:GetAttribute("TemplateSource")
	end

	if type(attribute2) == "string" and attribute2 ~= "" then
		if attribute2:find("Augmented") then
			return (fn21("AugmentedDrone"))
		end

		if attribute2:find("Drone 3") then
			return (fn21("AugmentedDrone"))
		end

		if attribute2:find("Drone3") then
			return (fn21("AugmentedDrone"))
		end

		if attribute2:find("Reactor") then
			return (fn21("ReactorDrone"))
		end

		if attribute2:find("Drone 2") then
			return (fn21("ReactorDrone"))
		end

		if attribute2:find("Drone2") then
			return (fn21("ReactorDrone"))
		end

		if attribute2:find("Scrap") or attribute2:find("Drone 1") then
			return (fn21("ScrapDrone"))
		end

		if attribute2:find("Drone1") then
			return (fn21("ScrapDrone"))
		end
	end

	local num = tonumber(arg2 and arg2:GetAttribute("MaxHealth")) or tonumber(arg and arg:GetAttribute("MaxHealth"))

	if num then
		if num >= 8 then
			return (fn21("AugmentedDrone"))
		end

		if num >= 4 then
			return (fn21("ReactorDrone"))
		end

		if num > 0 then
			return (fn21("ScrapDrone"))
		end
	end

	if arg2 and arg2:IsA("BasePart") then
		local x = arg2.Size.X
		if x > 13 then
			return (fn21("AugmentedDrone"))
		end

		if x > 10 then
			return (fn21("ReactorDrone"))
		end

		if x > 2 then
			return (fn21("ScrapDrone"))
		end
	end

	local num2 = tonumber(arg2 and arg2:GetAttribute("Health"))

	if num2 then
		if num2 >= 8 then
			return (fn21("AugmentedDrone"))
		end

		if num2 >= 4 then
			return (fn21("ReactorDrone"))
		end
	end

	return (fn21("ScrapDrone"))
end

steal.SCR.DroneList = function(arg)
	local tbl2 = {}
	local scrambleLocalVisuals = v:FindFirstChild("ScrambleLocalVisuals")

	if scrambleLocalVisuals then
		local tier = arg and "All" or steal.SCR.Tier

		for _, child in ipairs(scrambleLocalVisuals:GetChildren()) do
			if child:GetAttribute("ScrambleDroneId") or child.Name:find("PersonalDrone", 1, true) then
				local hitbox = child:FindFirstChild("Hitbox")

				if hitbox and hitbox:IsA("BasePart") then
					local attribute = hitbox:GetAttribute("Health")

					if attribute ~= nil then
						if type(attribute) ~= "number" then
							continue
						end

						if not (attribute > 0) then
							continue
						end
					end

					local v4 = steal.SCR.TierDrone(child, hitbox)

					if tier == "All" or v4 == tier then
						tbl2[#tbl2 + 1] = { hb = hitbox, tier = v4, hp = tonumber(attribute) or 0, pos = hitbox.Position }
					end
				end
			end
		end

		return tbl2
	end

	return tbl2
end

steal.SCR.Terdekat = function(arg)
	local v4 = fn2()

	if v4 then
		local huge = math.huge
		local v5 = nil

		for _, v6 in ipairs(arg or steal.SCR.DroneList()) do
			local magnitude = (v6.pos - v4.Position).Magnitude

			if magnitude < huge then
				huge = magnitude
				v5 = v6
			end
		end

		return v5, huge
	end

	return nil
end

steal.SCR.PungutMulai = function()
	if steal.SCR.conn then
		return
	end
	local Scramble = tbl.NET.Get("Scramble", "Drops")

	if Scramble then
		steal.SCR.conn = Scramble.OnClientEvent:Connect(function(arg)
			if type(arg) ~= "table" then
				return
			end
			local tbl2 = {}

			for k in pairs(arg) do
				if not steal.SCR.ambil[k] then
					steal.SCR.ambil[k] = true
					tbl2[#tbl2 + 1] = k
				end
			end

			if #tbl2 ~= 0 then
				task.delay(0.1, function()
					tbl.NET.Fire("Scramble", "Collect", tbl2)
				end)

				return
			end
		end)

		return
	end
end

steal.SCR.PungutBagian = function()
	local drScrambleEvent = v:FindFirstChild("DrScrambleEvent")

	if drScrambleEvent then
		local n3 = 0

		for _, v4 in ipairs({ "LostPart1", "LostPart2" }) do
			if steal.SCR.Aktif() then
				local v5 = drScrambleEvent:FindFirstChild(v4)

				for _, v6 in ipairs(v5 and v5:GetDescendants() or {}) do
					if v6:IsA("ProximityPrompt") and v6.Enabled then
						local parent = v6.Parent
						local position = parent and parent:IsA("BasePart") and parent.Position or v5:GetPivot().Position
						steal.SCR.Status = "heading to " .. v4

						if steal.Glide(position + Vector3.new(0, 3, 0), 25) then
							task.wait(0.25)

							if steal.SCR.Prompt(v6) then
								n3 += 1
							end

							task.wait(0.35)
						end

						break
					end
				end

				continue
			end

			break
		end

		return n3
	end

	return 0
end

steal.SCR.Putaran = function()
	if steal.NightApproaching and steal.NightApproaching(3) then
		return
	end

	if not fn2() then
		return
	end
	steal.SCR.Snapshot()
	local v4 = steal.SCR.DroneList()
	steal.SCR.Drones = #v4

	if #v4 ~= 0 then
		local v5 = steal.SCR.Terdekat(v4)

		if v5 then
			steal.SCR.Status = ("engaging %s (%d HP)"):format(v5.tier, v5.hp)

			if steal.Glide(v5.hb.Position + Vector3.new(0, 2.5, 3.5), 12) then
				local n3 = os.clock() + 8

				while steal.SCR.Aktif() and v5.hb.Parent and os.clock() < n3 do
					local attribute = v5.hb:GetAttribute("Health")
					if type(attribute) == "number" and attribute <= 0 then
						return
					end
					local v6 = fn2()

					if v6 then
						local n4 = v5.hb.Position + Vector3.new(0, 2.5, 3.5)

						if not ((v6.Position - n4).Magnitude > 18) then
							steal.Tulis(v6, CFrame.new(n4, v5.hb.Position), false)
						elseif not steal.Glide(n4, 8) then
							break
						end

						local v7, v8 = steal.GOD.Ayun(nil)
						task.wait(math.max(v8, 0.1))
						continue
					end

					break
				end

				return
			end

			return
		end

		return
	end

	if not steal.SCR.Jendela() then
		steal.SCR.Status = "outside outbreak window"
		return
	end
	local n3 = #steal.SCR.DroneList(true)
	if n3 > 0 then
		steal.SCR.Status = "no drone matches selected tier"
		return
	end
	local flag2 = n3 >= 1

	while true do
		flag2("HOP", table.unpack(nil, 1, (nil).n))
	end
end

steal.SCR.Toko = function()
	local v4 = steal.SCR.Snapshot()
	local tbl2 = {}

	for _, v5 in pairs(v4 and v4.Shop or {}) do
		if type(v5) == "table" and v5.Id then
			tbl2[#tbl2 + 1] = v5
		end
	end

	table.sort(tbl2, function(arg, arg2)
		return (tonumber(arg.Price) or 0) < (tonumber(arg2.Price) or 0)
	end)

	return tbl2
end

steal.SCR.SudahBeli = function(arg)
	local v4 = steal.SCR.Snapshot()
	local state = v4 and v4.State
	local shopPurchases = state and state.ShopPurchases and state.ShopPurchases[arg]
	if type(shopPurchases) ~= "table" then
		return 0
	end

	if tostring(shopPurchases.Period or "") ~= tostring(v4 and v4.ShopPeriod or "") then
		return 0
	end
	local num = tonumber(shopPurchases.Count)
	if num then
		return num
	end
	return 0
end

steal.SCR.Beli = function(arg)
	local v4 = steal.SCR.Snapshot(true)
	if not v4 or not v4.State then
		return false, "snapshot kosong"
	end
	local v5 = nil

	for _, v6 in pairs(v4.Shop or {}) do
		if type(v6) == "table" and v6.Id == arg then
			v5 = v6
		end
	end

	if not v5 then
		return false, "not on the shelf"
	end
	local num = tonumber(v5.PurchaseLimit)
	if num and num <= steal.SCR.SudahBeli(arg) then
		return false, "batas beli tercapai"
	end
	local n3 = tonumber(v5.Price) or 0
	local num2 = tonumber(v4.State.Samples)

	if num2 then
		if num2 < n3 then
			return false, "not enough samples"
		end
	elseif n3 > 0 then
		return false, "not enough samples"
	end

	local Scramble = tbl.NET.Get("Scramble", "Request")
	if not Scramble then
		return false, "remote hilang"
	end

	local function fn21()
		return Scramble:InvokeServer("Shop", arg, { Quote = v5.Quote, Sequence = v4.State.ShopSequence })
	end

	local ok, result = pcall(fn21)

	if ok then
		if type(result) == "table" and result.Ok == true then
			steal.SCR.snapAt = 0
			steal.SCR.Dibeli = steal.SCR.Dibeli + 1
			return true, tostring(v5.Label or arg)
		end

		if type(result) ~= "table" then
			return false, "ditolak"
		end
		return false, (tostring(result.Reason))
	end

	return false, tostring(result)
end

steal.SCR.PutaranBeli = function()
	if steal.SCR.beliJalan then
		return
	end
	steal.SCR.beliJalan = true

	for _, v4 in ipairs(steal.SCR.Toko()) do
		if steal.SCR.on then
			if steal.SCR.AutoBuy then
				if steal.SCR.BeliPilih[v4.Id] then
					local v5, v6 = steal.SCR.Beli(v4.Id)

					if v5 then
						tbl.LOG.info("SCR", ("beli %s (-%s sampel)"):format(v6, tostring(v4.Price)))
						task.wait(0.45)
					elseif v6 ~= "not enough samples" and v6 ~= "batas beli tercapai" then
						local v7 = tostring
						tbl.LOG.warn("SCR", ("beli %s gagal: %s"):format(tostring(v4.Id), v7(v6)))
					end
				end

				continue
			end

			break
		end

		break
	end

	steal.SCR.beliJalan = false
end

do
	steal.SCR.AREA = "Abyss"

	steal.SCR.TitikArea = function()
		local str2 = steal.SCR.AREA:lower()

		for _, v4 in ipairs(steal.AreaSpots()) do
			if tostring(v4.name):lower():find(str2, 1, true) then
				return v4.pos
			end
		end

		return nil
	end

	local function siap()
		if steal.SCR.AutoHit then
			if steal.SCR.sesi then
				return false
			end

			if steal.NightApproaching and steal.NightApproaching(3) then
				return false
			end

			if steal.SCR.Jendela() then
				return steal.SCR.DroneServer() > 0
			end
			return false
		end

		return false
	end

	steal.SCR.Siap = siap

	steal.SCR.Sesi = function(arg)
		if steal.SCR.sesi then
			return
		end
		local v4 = steal.SCR.TitikArea()

		if v4 then
			if steal.TM.on or steal.TM.NaikPasti() then
				steal.TM.DoffPasti(3)
			end

			steal.SCR.sesi = true
			table.clear(steal.SCR.ambil)
			steal.SCR.PungutMulai()
			steal.SCR.Status = "heading to " .. steal.SCR.AREA
			fn4("no egg match - hunting Dr. Scramble drones")
			steal.Glide(v4, 45)

			while steal.SCR.sesi do
				if tbl.Alive then
					if not arg or not arg() then
						if steal.SCR.AutoHit then
							if steal.SCR.Jendela() then
								if steal.NightApproaching and steal.NightApproaching(3) then
									fn4("night approaching - aborting drone session")
									break
								end
								local ok, result = pcall(steal.SCR.Putaran)

								if not ok then
									tbl.LOG.warn("SCR", "putaran: " .. tostring(result))
								end

								task.wait(0.15)
								continue
							end

							break
						end

						break
					end

					break
				end

				break
			end

			steal.SCR.sesi = false

			if steal.SCR.conn then
				steal.SCR.conn:Disconnect()
				steal.SCR.conn = nil
			end

			steal.SCR.balik = true
			steal.SCR.Status = "returning to safe zone"
			fn4("drone session done - returning to safe zone")
			pcall(steal.Glide, steal.STRIP, 45)
			steal.SCR.balik = false
			steal.SCR.Status = "Idle"
			return
		end

		tbl.LOG.warn("SCR", ("area %s tidak ketemu di dunia"):format(steal.SCR.AREA))
	end

	steal.SCR.Prompt = function(arg)
		if not arg or not arg:IsA("ProximityPrompt") then
			return false
		end

		if arg.Enabled then
			local n3 = tonumber(arg.HoldDuration) or 0
			local flag2 = false

			pcall(function()
				arg:InputHoldBegin()
				task.wait(not (n3 > 0) and 0.05 or n3 + 0.15)
				arg:InputHoldEnd()
				flag2 = true
			end)

			pcall(function()
				if typeof(fireproximityprompt) ~= "function" then
					return
				end
				fireproximityprompt(arg, not (n3 > 0) and 0 or n3 + 0.15)
				flag2 = true
			end)

			return flag2
		end

		return false
	end

	steal.SCR.MULUT_GUA = Vector3.new(2125.7, 70.7, -295.4)
	steal.SCR.DALAM_LAB = Vector3.new(2125, -127.5, -339.6)
	steal.SCR.BAWAH_TANAH = -50

	steal.SCR.TitikLab = function()
		local drScrambleEvent = v:FindFirstChild("DrScrambleEvent")

		for _, v4 in ipairs({ "EscapedExperiment", "Brock" }) do
			local v5 = drScrambleEvent and drScrambleEvent:FindFirstChild(v4)

			if v5 then
				local ok, result = pcall(function()
					return v5:GetPivot()
				end)

				if ok then
					return result.Position
				end
			end
		end

		return steal.SCR.DALAM_LAB
	end

	steal.SCR.Pergi = function(arg, arg2)
		if arg then
			if steal.SCR.balik then
				return false
			end
			steal.SCR.balik = true
			local flag2 = not steal.Running and not steal.SCR.on

			if flag2 then
				steal.SpoofStart()
			end

			steal.SCR.Status = "heading to " .. arg2
			local v4 = steal.Glide(arg + Vector3.new(0, 4, 0), 30)

			if flag2 then
				steal.SpoofStop()
			end

			steal.SCR.balik = false
			steal.SCR.Status = if v4 then "arrived at " .. arg2 else "failed to reach " .. arg2
			return v4
		end

		tbl.LOG.warn("SCR", arg2 .. ": modelnya belum ter-stream di server ini")
		return false
	end

	steal.SCR.KeLab = function()
		if steal.SCR.balik then
			return false
		end
		local v4 = fn2()

		if v4 then
			steal.SCR.balik = true
			local flag2 = not steal.Running and not steal.SCR.on

			if flag2 then
				steal.SpoofStart()
			end

			local function fn21(arg, status)
				if flag2 then
					steal.SpoofStop()
				end

				steal.SCR.balik = false
				steal.SCR.Status = status
				return arg
			end

			if not (v4.Position.Y < steal.SCR.BAWAH_TANAH) then
				steal.SCR.Status = "heading to cave entrance"

				if steal.Glide(steal.SCR.MULUT_GUA, 35) then
					local v5 = steal.Dunia()
					local secretZones = v5 and v5:FindFirstChild("SecretZones")
					local cave = secretZones and secretZones:FindFirstChild("Cave")
					local teleporter = cave and cave:FindFirstChild("Teleporter")
					local entry = teleporter and teleporter:FindFirstChild("Entry")

					if entry then
						if entry:IsA("BasePart") then
							steal.Glide(entry.Position + Vector3.new(0, 3, 0), 12)
						end

						local proximityPrompt = entry:FindFirstChildWhichIsA("ProximityPrompt", true)

						if proximityPrompt then
							if proximityPrompt.Enabled then
								steal.SCR.Status = "entering cave"
								steal.SCR.Prompt(proximityPrompt)
								local n3 = os.clock() + 1.5

								while os.clock() < n3 do
									local v6 = fn2()
									if not v6 or not (v6.Position.Y < steal.SCR.BAWAH_TANAH) then
										task.wait(0.1)
										continue
									end
									break
								end

								local v6 = fn2()

								if v6 then
									if not (v6.Position.Y < steal.SCR.BAWAH_TANAH) then
										return (fn21(false, "cave prompt fired but did not descend"))
									end
									steal.SCR.Status = "inside cave - heading to lab"
									steal.Glide(steal.SCR.TitikLab(), 25)
									steal.SCR.Sapa()
									return (fn21(true, "arrived at lab"))
								end

								return (fn21(false, "cave prompt fired but did not descend"))
							end

							return (fn21(false, "cave prompt disabled"))
						end

						return (fn21(false, "cave prompt disabled"))
					end

					return (fn21(false, "cave teleporter not found"))
				end

				return (fn21(false, "failed to reach cave entrance"))
			end

			steal.SCR.Status = "already in cave - heading to lab"
			steal.Glide(steal.SCR.TitikLab(), 25)
			steal.SCR.Sapa()
			return (fn21(true, "arrived at lab"))
		end

		return false
	end

	steal.SCR.Sapa = function()
		local drScrambleEvent = v:FindFirstChild("DrScrambleEvent")
		local escapedExperiment = drScrambleEvent and drScrambleEvent:FindFirstChild("EscapedExperiment")

		for _, v4 in ipairs(escapedExperiment and escapedExperiment:GetDescendants() or {}) do
			if v4:IsA("ProximityPrompt") and v4.Enabled then
				return steal.SCR.Prompt(v4)
			end
		end

		return false
	end

	steal.SCR.Vault = function()
		if pcall(function()
			require(tbl.SV.ReplicatedStorage.Client.Tabs).Toggle("StolenVaultEvent")
		end) then
			return true
		end
		local playerGui = localPlayer:FindFirstChild("PlayerGui")
		local stolenVaultEventUI = playerGui and playerGui:FindFirstChild("StolenVaultEventUI")
		if stolenVaultEventUI then
			stolenVaultEventUI.Enabled = not stolenVaultEventUI.Enabled
			return true
		end
		tbl.LOG.warn("SCR", "panel Experiment Vault tidak ketemu")
		return false
	end

	steal.SCR.Start = function()
		if steal.SCR.on then
			return
		end
		steal.SCR.on = true
		table.clear(steal.SCR.ambil)
		local v4 = fn2()
		steal.SCR.pulang = v4 and v4.CFrame or nil
		steal.SpoofStart()
		steal.SCR.PungutMulai()
		tbl.LOG.info("SCR", "Dr. Scramble aktif")
		steal.SCR.beliNext = 0

		task.spawn(function()
			local flag2 = false

			while steal.SCR.on do
				if tbl.Alive then
					if steal.SCR.AutoBuy and steal.SCR.beliNext <= os.clock() then
						steal.SCR.beliNext = os.clock() + 10
						local ok, result = pcall(steal.SCR.PutaranBeli)

						if not ok then
							tbl.LOG.warn("SCR", "sapuan toko: " .. tostring(result))
						end
					end

					if steal.Running then
						steal.SCR.Snapshot()
						steal.SCR.Drones = #steal.SCR.DroneList()
						steal.SCR.Status = "standing by - auto steal owns movement"
					elseif steal.NightApproaching and steal.NightApproaching(3) then
						local v5 = fn2()

						if v5 and steal.GATE_X < v5.Position.X then
							fn4("night approaching - retreating to safe zone")
							pcall(steal.GlideRetry, steal.STRIP, 35, 3)
						end

						steal.SCR.Status = "standing by in safe zone - night / reset active"
						steal.WallStandby()
					elseif steal.SCR.AutoParts and not flag2 then
						local ok, result = pcall(steal.SCR.PungutBagian)
						flag2 = true

						if not ok then
							tbl.LOG.warn("SCR", "quest parts: " .. tostring(result))
						end
					elseif steal.SCR.AutoHit and steal.SCR.Siap() then
						local ok, result = pcall(steal.SCR.Sesi, nil)

						if not ok then
							tbl.LOG.warn("SCR", "sesi: " .. tostring(result))
						end
					elseif steal.SCR.AutoHit then
						local ok, result = pcall(steal.SCR.Putaran)

						if not ok then
							tbl.LOG.warn("SCR", "putaran: " .. tostring(result))
						end
					else
						steal.SCR.Snapshot()
						steal.SCR.Drones = #steal.SCR.DroneList()
						steal.SCR.Status = steal.SCR.Jendela() and "standing by - outbreak open" or "standing by"
					end

					task.wait(0.15)
					continue
				end

				break
			end

			local pulang = steal.SCR.pulang

			if pulang and not steal.Running then
				steal.SCR.balik = true
				steal.SCR.Status = "returning to start point"
				pcall(steal.Glide, pulang.Position, 25)
				steal.SCR.balik = false
			end

			if not steal.Running then
				steal.SpoofStop()
			end

			steal.SCR.Status = "Idle"
			tbl.LOG.info("SCR", "Dr. Scramble berhenti")
		end)
	end

	steal.SCR.Sync = function()
		if steal.SCR.AutoHit or steal.SCR.AutoParts or steal.SCR.AutoBuy then
			steal.SCR.Start()
			return
		end
		steal.SCR.Stop()
	end

	steal.SCR.Stop = function()
		if steal.SCR.on then
			steal.SCR.on = false

			if steal.SCR.conn then
				steal.SCR.conn:Disconnect()
				steal.SCR.conn = nil
				return
			end

			return
		end
	end

	tbl.ST.Trove:Add(steal.SCR.Stop)
	steal.INV = { fn = false, earn = nil, cari = 0 }
	steal.INV.POLL = 0.5

	steal.INV.Earn = function()
		if steal.INV.earn ~= nil then
			return steal.INV.earn
		end
		steal.INV.earn = false
		local shared = tbl.SV.ReplicatedStorage:FindFirstChild("Shared")
		local util = shared and shared:FindFirstChild("Util")
		local assetEarnings = util and util:FindFirstChild("AssetEarnings")

		if assetEarnings then
			local ok, earn = pcall(require, assetEarnings)

			if ok and type(earn) == "table" and type(earn.RatePerSecond) == "function" then
				steal.INV.earn = earn
			end
		end

		return steal.INV.earn
	end

	steal.INV.Peta = function()
		if steal.INV.fn then
			local ok, result = pcall(debug.getupvalues, steal.INV.fn)
			if ok and type(result) == "table" then
				return result[1], result[2]
			end
			steal.INV.fn = false
		end

		if os.clock() < steal.INV.cari then
			return nil
		end
		steal.INV.cari = os.clock() + 10
		if type(getgc) ~= "function" then
			return nil
		end

		if type(debug) ~= "table" then
			return nil
		end

		if type(debug.getupvalues) ~= "function" then
			return nil
		end
		local v4 = nil
		local v5 = pcall

		local function fn21()
			for _, v6 in ipairs(getgc(false)) do
				if type(v6) == "function" and islclosure and islclosure(v6) then
					local ok, result = pcall(debug.getinfo, v6)
					if ok and type(result) == "table" and result.name == "getRegisteredBackpackSlot" then
						v4 = v6
						return
					end
				end
			end
		end

		v5(fn21)
		if not v4 then
			return nil
		end
		steal.INV.fn = v4
		local ok, result = pcall(debug.getupvalues, v4)
		if ok and type(result) == "table" then
			return result[1], result[2]
		end
		return nil
	end

	steal.INV.Uang = function(arg)
		local n3 = tonumber(arg) or 0

		if not (n3 <= 0) then
			if not (n3 >= 1e12) then
				if not (n3 >= 1e9) then
					if not (n3 >= 1000000) then
						if not (n3 >= 1000) then
							return ("$%d/s"):format(math.floor(n3))
						end
						return ("$%.1fK/s"):format(n3 / 1000)
					end

					return ("$%.1fM/s"):format(n3 / 1000000)
				end

				return ("$%.1fB/s"):format(n3 / 1e9)
			end

			return ("$%.1fT/s"):format(n3 / 1e12)
		end

		return "$0/s"
	end

	steal.INV.TAG = "SAE_Rate"

	local function createTextLabel(parent, name, size, position, textSize)
		local v4 = parent:FindFirstChild(name)
		if v4 then
			return v4
		end
		local textLabel = Instance.new("TextLabel")
		textLabel.Name = name
		textLabel.Size = size
		textLabel.Position = position
		textLabel.BackgroundColor3 = Color3.new(0.047058824449777603, 0.047058824449777603, 0.058823529630899429)
		textLabel.BackgroundTransparency = 0.12
		textLabel.TextColor3 = Color3.new(1, 0.81568628549575806, 0.36078432202339172)
		textLabel.TextSize = textSize
		textLabel.Font = Enum.Font.GothamBold
		textLabel.TextScaled = false
		textLabel.ZIndex = 30
		textLabel.AutoLocalize = false
		local uiCorner = Instance.new("UICorner")
		uiCorner.CornerRadius = UDim.new(0, 5)
		uiCorner.Parent = textLabel
		local uiStroke = Instance.new("UIStroke")
		uiStroke.Color = Color3.new(1, 0.81568628549575806, 0.36078432202339172)
		uiStroke.Thickness = 1
		uiStroke.ApplyStrokeMode = Enum.ApplyStrokeMode.Border
		uiStroke.Parent = textLabel
		textLabel.Parent = parent
		return textLabel
	end

	steal.INV.Tick = function()
		local playerGui = localPlayer:FindFirstChild("PlayerGui")
		local backpackGui = playerGui and playerGui:FindFirstChild("BackpackGui")
		local backpack = backpackGui and backpackGui:FindFirstChild("Backpack")
		local main = backpack and backpack:FindFirstChild("Main")
		local inventory = main and main:FindFirstChild("Inventory")

		if inventory then
			if inventory.Visible then
				if inventory:FindFirstChild("ScrollingFrame") then
					local v4 = steal.INV.Earn()
					if not v4 then
						return
					end
					local v5, v6 = steal.INV.Peta()

					if v5 then
						local v7 = steal.SaveData()
						local inventory2 = v7 and v7.Inventory or {}
						local eggInventory = v7 and v7.EggInventory or {}
						local n3 = 0

						local function fn21(arg, arg2)
							if type(arg) ~= "table" then
								return
							end

							if arg2 then
								local frame = arg.Frame
								if typeof(frame) ~= "Instance" then
									return
								end

								if frame:IsA("GuiObject") then
									local ok, result = pcall(v4.RatePerSecond, arg2)
									local num = ok and tonumber(result)

									if num then
										n3 += num
										createTextLabel(frame, steal.INV.TAG, UDim2.new(1, -10, 0, 15), UDim2.new(0, 5, 0, 3), 12).Text = steal.INV.Uang(num)
										return
									end

									return
								end

								return
							end
						end

						for k, v8 in pairs(v5) do
							fn21(v8, inventory2[k])
						end

						for k, v8 in pairs(v6) do
							local v9 = eggInventory[k]

							if type(v9) == "table" then
								fn21(v8, {
									Category = v9.AssetCategory or v9.Category,
									Scale = v9.AssetScale or v9.Scale or 1,
									Mutations = v9.Mutations or {},
								})
							end
						end

						createTextLabel(inventory, "SAE_Total", UDim2.new(0, 190, 0, 26), UDim2.new(0.5, -95, 0, 8), 15).Text = "TOTAL  " .. steal.INV.Uang(n3)
						return
					end

					return
				end

				return
			end

			return
		end
	end

	steal.IDX = { nama = {}, drop = {}, siap = false }
	steal.IDX.POLL = 1.5
	steal.IDX.MERAH = Color3.new(1, 0.17647059261798859, 0.17647059261798859)

	local function cache()
		if steal.IDX.siap then
			return
		end
		steal.IDX.siap = true
		local data = tbl.SV.ReplicatedStorage:FindFirstChild("Data")

		pcall(function()
			for k, v4 in pairs(require(data.Assets).Directory) do
				if type(v4) == "table" then
					local displayName = v4.DisplayName or v4.Name

					if displayName then
						if v4.Icon then
							steal.IDX.nama[v4.Icon] = displayName
						end

						steal.IDX.nama[k] = displayName
					end
				end
			end
		end)

		pcall(function()
			for k, v4 in pairs(require(data.Areas).Directory) do
				if type(v4) == "table" and type(v4.DropTable) == "table" then
					local tbl2 = {}

					for i, v5 in ipairs(v4.DropTable) do
						if type(v5) == "table" and v5[1] then
							tbl2[i] = steal.IDX.nama[v5[1]] or tostring(v5[1])
						end
					end

					steal.IDX.drop[k] = tbl2
				end
			end
		end)
	end

	steal.IDX.Cache = cache

	steal.IDX.Buka = function(arg, arg2)
		if arg then
			if arg:IsA("GuiObject") then
				if arg.Visible then
					local textLabel = arg:FindFirstChildWhichIsA("TextLabel", true)

					if textLabel then
						if textLabel.Text ~= "???" and arg:GetAttribute("SAE_Buka") then
							return
						end
						local icon = arg:FindFirstChild("Icon") or arg:FindFirstChildWhichIsA("ImageLabel", true)
						if (not icon or not (icon.ImageColor3.R < 0.1) or not (icon.ImageColor3.G < 0.1) or not (icon.ImageColor3.B < 0.1)) and textLabel.Text ~= "???" then
							arg:SetAttribute("SAE_Buka", true)
							return
						end
						local text = icon and icon.Image and icon.Image ~= "" and steal.IDX.nama[icon.Image]

						if not text and arg2 and steal.IDX.drop[arg2] then
							local num = tonumber(tostring(arg.Name):match("%d+"))
							text = num and steal.IDX.drop[arg2][num]
						end

						if text then
							if textLabel.Text ~= text then
								textLabel.Text = text
							end

							textLabel.TextColor3 = steal.IDX.MERAH
							textLabel.TextStrokeColor3 = Color3.new(0, 0, 0)
							textLabel.TextStrokeTransparency = 0
							arg:SetAttribute("SAE_Buka", true)
							return
						end

						return
					end

					return
				end

				return
			end

			return
		end
	end

	steal.IDX.Tick = function()
		local playerGui = localPlayer:FindFirstChild("PlayerGui")
		local index = playerGui and playerGui:FindFirstChild("Index")

		if index then
			if index.Enabled then
				local frame = index:FindFirstChild("Frame")

				if frame then
					if frame.Visible then
						local list = frame:FindFirstChild("List")
						local scrollingFrame = list and list:FindFirstChild("ScrollingFrame")

						if scrollingFrame then
							steal.IDX.Cache()

							for _, child in ipairs(scrollingFrame:GetChildren()) do
								if child:IsA("GuiObject") and child.Visible and child.Name ~= "EmptyBottom" and child.Name ~= "Section" then
									local pets = child:FindFirstChild("Pets")

									if pets then
										for _, child2 in ipairs(pets:GetChildren()) do
											steal.IDX.Buka(child2, child.Name)
										end
									end
								end
							end

							return
						end

						return
					end

					return
				end

				return
			end

			return
		end
	end

	task.spawn(function()
		local n3 = 0

		while tbl.Alive do
			local ok, result = pcall(steal.INV.Tick)

			if not ok then
				tbl.LOG.warn("INV", "overlay tas: " .. tostring(result))
			end

			if n3 <= os.clock() then
				n3 = os.clock() + steal.IDX.POLL
				local ok2, result2 = pcall(steal.IDX.Tick)

				if not ok2 then
					tbl.LOG.warn("IDX", "pet index: " .. tostring(result2))
				end
			end

			task.wait(steal.INV.POLL)
		end
	end)

	tbl.ST.Trove:Add(function()
		local playerGui = localPlayer:FindFirstChild("PlayerGui")
		local backpackGui = playerGui and playerGui:FindFirstChild("BackpackGui")

		if backpackGui then
			for _, descendant in ipairs(backpackGui:GetDescendants()) do
				if descendant.Name == steal.INV.TAG or descendant.Name == "SAE_Total" then
					pcall(function()
						descendant:Destroy()
					end)
				end
			end

			return
		end
	end)

	steal.MON = {
		URL = "https://www.nrlscript.com/api/monitor",
		JEDA = 60,
		CAP = 250,
		TUNDA = 4,
		ikon = {},
		coba = {},
		avatar = nil,
		lama = nil,
		baru = {},
		bilang = false,
	}

	steal.MON.Req = function()
		local request_ = request or http_request or syn and syn.request
		if type(request_) == "function" and request_ then
			return request_
		end
		return nil
	end

	steal.MON.Hex = function(arg)
		if typeof(arg) ~= "Color3" then
			return nil
		end
		return ("#%02X%02X%02X"):format(math.floor(arg.R * 255 + 0.5), math.floor(arg.G * 255 + 0.5), math.floor(arg.B * 255 + 0.5))
	end

	steal.MON.ER = function()
		if steal.MON.er ~= nil then
			return steal.MON.er
		end
		steal.MON.er = false

		for _, descendant in ipairs(tbl.SV.ReplicatedStorage:GetDescendants()) do
			if descendant:IsA("ModuleScript") and descendant.Name == "EggRecords" then
				local ok, er = pcall(require, descendant)

				if ok and type(er) == "table" then
					steal.MON.er = er
				end

				break
			end
		end

		return steal.MON.er
	end

	steal.MON.Ikon = function(arg)
		local v4 = steal.MON.Req()

		if v4 then
			local httpService = tbl.SV.HttpService

			for _, v5 in ipairs(arg) do
				steal.MON.coba[v5] = (steal.MON.coba[v5] or 0) + 1
			end

			for i = 1, #arg, 100 do
				local tbl2 = {}

				for i2 = i, math.min(i + 99, #arg) do
					tbl2[#tbl2 + 1] = arg[i2]
				end

				local ok, result = pcall(v4, {
					Url = "https://thumbnails.roblox.com/v1/assets?assetIds=" .. table.concat(tbl2, ",") .. "&size=150x150&format=Png",
					Method = "GET",
				})

				local body = ok and result and (result.Body or result.body)

				if body then
					local v5 = pcall

					local function fn21()
						for _, v6 in ipairs((httpService:JSONDecode(body) or {}).data or {}) do
							local str2 = tostring(v6.targetId)

							if v6.state == "Completed" and type(v6.imageUrl) == "string" then
								steal.MON.ikon[str2] = v6.imageUrl
							elseif v6.state ~= "Pending" then
								steal.MON.ikon[str2] = false
							end
						end
					end

					v5(fn21)
				end
			end

			return
		end
	end

	steal.MON.Avatar = function()
		if steal.MON.avatar ~= nil then
			return
		end
		local v4 = steal.MON.Req()
		if not v4 then
			return
		end

		pcall(function()
			local v5 = v4({
				Url = "https://thumbnails.roblox.com/v1/users/avatar-headshot?userIds=" .. localPlayer.UserId .. "&size=150x150&format=Png",
				Method = "GET",
			})

			local body = v5 and (v5.Body or v5.body)

			if body then
				local v6 = ((tbl.SV.HttpService:JSONDecode(body) or {}).data or {})[1]
				if v6 and v6.state == "Completed" and type(v6.imageUrl) == "string" then
					steal.MON.avatar = v6.imageUrl
					return
				end
				return
			end
		end)
	end

	steal.MON.Telur = function(arg, arg2, arg3)
		if type(arg2) ~= "table" then
			return nil
		end

		if arg2.AssetCategory then
			local v4 = asset(tostring(arg2.AssetCategory))
			local v5 = steal.MON.ER()
			local v6 = steal.INV.Earn()
			local n3 = 0

			if v6 then
				local ok, result = pcall(v6.RatePerSecond, { Category = arg2.AssetCategory, Scale = arg2.AssetScale or 1, Mutations = arg2.Mutations or {} })

				if ok and type(result) == "number" then
					n3 = result
				end
			end

			local n4 = 0
			local str2 = nil

			if v5 then
				local ok, result = pcall(v5.SellPrice, arg2)

				if ok and type(result) == "number" then
					n4 = math.floor(result)
				end

				local ok2, result2 = pcall(v5.DisplayName, arg2)

				if ok2 and result2 then
					str2 = tostring(result2)
				end
			end

			local str3 = nil

			if v4 and type(v4.Rarity) == "table" then
				str3 = tostring(v4.Rarity.DisplayName or v4.Rarity._id or "")

				if arg3 and str3 ~= "" and arg3[str3] == nil then
					arg3[str3] = steal.MON.Hex(v4.Rarity.Color) or false
				end
			end

			local mut = {}

			if type(arg2.Mutations) == "table" then
				while true do
					local v7

					if I_1 <= 0 then
						if not (N_1 >= C_1) then
							break
						end
						v7 = N_1
					else
						if not (N_1 <= C_1) then
							break
						end
						v7 = N_1
					end

					local v8 = arg2.Mutations[v7]

					if v8 and tostring(v8) ~= "None" then
						mut[#mut + 1] = tostring(v8)
					end
				end
			end

			local tbl2 = {
				uid = tostring(arg),
				cat = arg2.AssetCategory,
				name = v4 and v4.DisplayName or tostring(arg2.AssetCategory),
				egg = str2,
				rar = str3,
				income = math.floor(n3 + 0.5),
				kg = math.floor(weightKgOf(arg2) * 100 + 0.5) / 100,
				sell = n4,
			}

			if not (#mut > 0) then
				mut = nil
			end

			tbl2.mut = mut
			return tbl2
		end

		return nil
	end

	steal.MON.Snapshot = function()
		local v4 = steal.SaveData()
		if type(v4) ~= "table" then
			return nil
		end
		local v5 = steal.INV.Earn()
		local tbl2 = {}

		if type(v4.EquippedAssets) == "table" then
			for k, equippedAsset in pairs(v4.EquippedAssets) do
				if type(k) == "string" then
					tbl2[k] = true
				end

				if type(equippedAsset) == "string" then
					tbl2[equippedAsset] = true
				end

				if type(equippedAsset) == "table" and equippedAsset.UID then
					tbl2[equippedAsset.UID] = true
				end
			end
		end

		local tbl3 = {}

		local function fn21(arg)
			if arg then
				if tbl3[arg] ~= nil then
					return
				end
				local v6 = asset(tostring(arg))
				local v7 = tbl3
				local match

				if v6 and v6.Icon then
					match = tostring(v6.Icon):match("(%d+)") or false
				else
					match = false
					v7[arg] = match
					return
				end

				v7[arg] = match
				return
			end
		end

		for _, v6 in pairs(v4.Inventory or {}) do
			if type(v6) == "table" then
				fn21(v6.Category)
			end
		end

		for _, v6 in pairs(v4.EggInventory or {}) do
			if type(v6) == "table" then
				fn21(v6.AssetCategory)
			end
		end

		local tbl4 = {}
		local tbl5 = {}

		for _, v6 in pairs(tbl3) do
			if v6 and steal.MON.ikon[v6] == nil then
				local v7 = steal.MON.coba[v6]

				if v7 then
					if v7 < 3 and not tbl5[v6] then
						tbl5[v6] = true
						tbl4[#tbl4 + 1] = v6
					end
				elseif not tbl5[v6] then
					tbl5[v6] = true
					tbl4[#tbl4 + 1] = v6
				end
			end
		end

		if #tbl4 > 0 then
			pcall(steal.MON.Ikon, tbl4)
		end

		local n3 = 0

		for k in pairs(v4.Inventory or {}) do
			n3 += 1
		end

		local n4 = 0

		for k in pairs(v4.EggInventory or {}) do
			n4 += 1
		end

		local pets = {}
		local tbl6 = {}
		local n5 = 0

		for k, v6 in pairs(v4.Inventory or {}) do
			if type(v6) == "table" and v6.Category then
				local v7 = asset(tostring(v6.Category))
				local n6 = 0

				if v5 then
					local ok, result = pcall(v5.RatePerSecond, v6)

					if ok and type(result) == "number" then
						n6 = result
					end
				end

				n5 += n6
				local str2 = nil

				if v7 and type(v7.Rarity) == "table" then
					str2 = tostring(v7.Rarity.DisplayName or v7.Rarity._id or "")

					if str2 ~= "" and tbl6[str2] == nil then
						tbl6[str2] = steal.MON.Hex(v7.Rarity.Color) or false
					end
				end

				local mut = {}

				if type(v6.Mutations) == "table" then
					while true do
						local v8

						if I_2 <= 0 then
							if not (N_2 >= C_2) then
								break
							end
							v8 = N_2
						else
							if not (N_2 <= C_2) then
								break
							end
							v8 = N_2
						end

						local v9 = v6.Mutations[v8]

						if v9 and tostring(v9) ~= "None" then
							mut[#mut + 1] = tostring(v9)
						end
					end
				end

				local n7 = #pets + 1

				local tbl7 = {
					uid = tostring(k),
					cat = v6.Category,
					name = v7 and v7.DisplayName or tostring(v6.Category),
					rar = str2,
					income = math.floor(n6 + 0.5),
					kg = math.floor(weightKgOf({ AssetCategory = v6.Category, AssetScale = v6.Scale or 1 }) * 100 + 0.5) / 100,
					equipped = tbl2[k] == true or nil,
				}

				if not (#mut > 0) then
					mut = nil
				end

				tbl7.mut = mut
				pets[n7] = tbl7
			end
		end

		local function fn22(arg, arg2)
			return (arg.income or 0) > (arg2.income or 0)
		end

		table.sort(pets, fn22)

		for i = #pets, steal.MON.CAP + 1, -1 do
			pets[i] = nil
		end

		local eggs = {}

		for k, v6 in pairs(v4.EggInventory or {}) do
			local v7 = steal.MON.Telur(k, v6, tbl6)

			if v7 then
				eggs[#eggs + 1] = v7
			end
		end

		local function fn23(arg, arg2)
			return (arg.income or 0) > (arg2.income or 0)
		end

		table.sort(eggs, fn23)

		for i = #eggs, steal.MON.CAP + 1, -1 do
			eggs[i] = nil
		end

		if steal.MON.lama ~= nil then
			local tbl7 = {}
			local v6, v7, v8 = pairs(v4.EggInventory or {})

			for k, v9 in v6, v7, v8 do
				if not steal.MON.lama[k] then
					steal.MON.lama[k] = true
					local v10 = steal.MON.Telur(k, v9, tbl6)

					if v10 then
						v10.ts = os.time()
						tbl7[#tbl7 + 1] = v10
					end
				end
			end

			for i = #tbl7, 1, -1 do
				table.insert(steal.MON.baru, 1, tbl7[i])
			end

			for i = #steal.MON.baru, 13, -1 do
				steal.MON.baru[i] = nil
			end
		else
			steal.MON.lama = {}

			for k in pairs(v4.EggInventory or {}) do
				steal.MON.lama[k] = true
			end
		end

		steal.MON.Avatar()
		local rarcolors = {}

		for k, v6 in pairs(tbl6) do
			if v6 then
				rarcolors[k] = v6
			end
		end

		local icons = {}
		local iconids = {}

		for k, v6 in pairs(tbl3) do
			if v6 then
				if type(steal.MON.ikon[v6]) ~= "string" then
					iconids[k] = v6
				else
					icons[k] = steal.MON.ikon[v6]
				end
			end
		end

		local tbl7 = {
			player = localPlayer.DisplayName or localPlayer.Name,
			userId = localPlayer.UserId,
			avatar = steal.MON.avatar or nil,
			money = v4.Money or 0,
			income = n5,
			speed = v4.SpeedPower or 0,
			totalPets = n3,
			totalEggs = n4,
			rebirth = v4.Rebirth or 0,
		}

		if not next(rarcolors) then
			rarcolors = nil
		end

		tbl7.rarcolors = rarcolors

		if not next(icons) then
			icons = nil
		end

		tbl7.icons = icons

		if not next(iconids) then
			iconids = nil
		end

		tbl7.iconids = iconids
		tbl7.pets = pets

		if not next(eggs) then
			eggs = nil
		end

		tbl7.eggs = eggs
		tbl7.recent = next(steal.MON.baru) and steal.MON.baru or nil
		return tbl7
	end

	steal.MON.Push = function()
		local v4 = steal.MON.Req()

		if v4 then
			local v5 = steal.Key()
			if not v5 then
				return
			end

			if v5 ~= "" then
				local v6 = steal.MON.Snapshot()
				if not v6 then
					return
				end
				local v7 = pcall

				local function fn21()
					return tbl.SV.HttpService:JSONEncode({ key = v5, game = "sae", data = v6 })
				end

				local v8, v9 = v7(fn21)

				if v8 then
					if type(v9) ~= "string" then
						return
					end

					if not steal.MON.bilang then
						steal.MON.bilang = true
						tbl.LOG.warn("MONITOR", ("mengirim inventory -> nrlscript.com/monitor (kunci %s...)"):format(tostring(v5):sub(1, 8)))
					end

					pcall(v4, {
						Url = steal.MON.URL,
						Method = "POST",
						Headers = { ["Content-Type"] = "application/json" },
						Body = v9,
					})

					return
				end

				return
			end

			return
		end
	end

	task.spawn(function()
		task.wait(steal.MON.TUNDA)

		while tbl.Alive do
			local ok, result = pcall(steal.MON.Push)

			if not ok then
				tbl.LOG.warn("MONITOR", "kiriman gagal: " .. tostring(result))
			end

			task.wait(steal.MON.JEDA)
		end
	end)

	steal.LOGO = { NAMA = "__SAE_SafeZoneLogo", pad = nil }
	local logo = steal.LOGO
	logo.UKURAN = 28

	steal.LOGO.Tanah = function(arg, arg2, arg3)
		local hit = v:Raycast(Vector3.new(arg, steal.STRIP.Y + 26, arg2), Vector3.new(0, -70, 0), arg3)

		if hit then
			local y = hit.Position.Y
			if y then
				return y
			end
		end

		return nil
	end

	steal.LOGO.Pasang = function()
		steal.LOGO.Buang()
		local raycastParams = RaycastParams.new()
		raycastParams.FilterType = Enum.RaycastFilterType.Exclude
		raycastParams.FilterDescendantsInstances = { localPlayer.Character, steal.Pad() }
		local n3 = steal.LOGO.UKURAN / 2
		local huge = math.huge

		for _, v4 in ipairs({
			{ 0, 0 },
			{ n3, n3 },
			{ -n3, n3 },
			{ n3, -n3 },
			{ -n3, -n3 },
			{ n3, 0 },
			{ -n3, 0 },
			{ 0, n3 },
			{ 0, -n3 },
		}) do
			local v5 = steal.LOGO.Tanah(steal.STRIP.X + v4[1], steal.STRIP.Z + v4[2], raycastParams)

			if v5 and v5 < huge then
				huge = v5
			end
		end

		if huge == math.huge then
			huge = 67.576
		end

		local part = Instance.new("Part")
		part.Name = steal.LOGO.NAMA
		part.Size = Vector3.new(steal.LOGO.UKURAN, 0.02, steal.LOGO.UKURAN)
		part.CFrame = CFrame.new(steal.STRIP.X, huge + 0.01, steal.STRIP.Z) * CFrame.Angles(0, 1.5707963267948966, 0)
		part.Anchored = true
		part.CanCollide = false
		part.CanQuery = false
		part.CanTouch = false
		part.CastShadow = false
		part.Material = Enum.Material.SmoothPlastic
		part.Transparency = 1
		part.Parent = v
		local decal = Instance.new("Decal")
		decal.Name = "SAE_Logo"
		decal.Face = Enum.NormalId.Top
		local LogoNRL

		if tbl.UIX and tbl.UIX.Icon then
			LogoNRL = tbl.UIX.Icon("LogoNRL") or "rbxassetid://124947058155926"
		else
			LogoNRL = "rbxassetid://124947058155926"
			decal.Texture = LogoNRL
			decal.Parent = part
			steal.LOGO.pad = part
			return part
		end

		decal.Texture = LogoNRL
		decal.Parent = part
		steal.LOGO.pad = part
		return part
	end

	steal.LOGO.Buang = function()
		if steal.LOGO.pad then
			pcall(function()
				steal.LOGO.pad:Destroy()
			end)
		end

		steal.LOGO.pad = nil
		local v4 = v:FindFirstChild(steal.LOGO.NAMA)

		if v4 then
			repeat
				pcall(function()
					v4:Destroy()
				end)

				v4 = v:FindFirstChild(steal.LOGO.NAMA)
			until not v4
		end
	end
end

tbl.ST.Trove:Add(steal.LOGO.Buang)

task.spawn(function()
	runService.Heartbeat:Wait()
	local ok, result = pcall(steal.LOGO.Pasang)
	if ok then
		return
	end
	tbl.LOG.warn("LOGO", "pad safe zone: " .. tostring(result))
end)

steal.FLOAT = { cx = {} }

steal.FLOAT.Pasang = function()
	for _, v4 in ipairs(steal.FLOAT.cx) do
		pcall(function()
			v4:Disconnect()
		end)
	end

	table.clear(steal.FLOAT.cx)
	local character = localPlayer.Character

	if character then
		for _, v4 in ipairs({ "UpperTorso", "LowerTorso", "Torso" }) do
			local v5 = character:FindFirstChild(v4)

			if v5 and v5:IsA("BasePart") then
				v5.CanCollide = true

				steal.FLOAT.cx[#steal.FLOAT.cx + 1] = v5:GetPropertyChangedSignal("CanCollide"):Connect(function()
					if v5.CanCollide then
						return
					end
					v5.CanCollide = true
				end)
			end
		end

		return
	end
end

steal.FLOAT.Start = function()
	steal.FLOAT.Pasang()

	tbl.ST.Trove:Connect(localPlayer.CharacterAdded, function()
		task.wait(1)
		steal.FLOAT.Pasang()
	end)

	tbl.ST.Trove:Add(function()
		for _, v4 in ipairs(steal.FLOAT.cx) do
			pcall(function()
				v4:Disconnect()
			end)
		end

		table.clear(steal.FLOAT.cx)
	end)

	tbl.LOG.info("FLOAT", "tabrakan torso dijaga")
end

steal.FLOAT.Start()

task.spawn(function()
	local character = localPlayer.Character or localPlayer.CharacterAdded:Wait()
	local v4 = pcall

	local function fn21()
		character:WaitForChild("HumanoidRootPart", 5)
	end

	v4(fn21)

	while tbl.Alive do
		local v5 = fn2()
		local v6 = steal.Pad()

		if steal.Gerak() then
			if v5 and v5.Parent and (not v6 or not v6.Parent) then
				steal.SpoofStart()
				steal.PadStart()
			end
		elseif v6 and v6.Parent then
			if steal.AA then
				if steal.AA.CTE then
					if not steal.AA.CTE.on then
						pcall(steal.PadStop)
					end
				else
					pcall(steal.PadStop)
				end
			else
				pcall(steal.PadStop)
			end
		end

		task.wait(1)
	end
end)

tbl.ST.Trove:Connect(localPlayer.CharacterAdded, function(siapChar)
	local v4 = pcall

	local function fn21()
		siapChar:WaitForChild("HumanoidRootPart", 5)
	end

	v4(fn21)
	task.wait(0.6)
	pcall(steal.MT.Henti)
	steal.SpoofStop()
	steal.SpoofStart()
	runService.PreSimulation:Wait()
	runService.PreSimulation:Wait()

	if steal.MATI then
		local mati = steal.MATI
		local mati2 = steal.MATI
		local now = os.clock()
		mati.siapChar = siapChar
		mati2.siapAt = now
	end

	if steal.Running then
		steal.WatchStart()
	end

	local v5 = steal.SpoofInfo()
	tbl.LOG.info("SPOOF", ("dipasang ulang sesudah respawn — nempel=%s %d tulisan (sample %d, monitor AC %s)%s"):format(tostring(v5.Nempel), v5.Patched, v5.Sample, v5.Monitor and "jalan" or "tidur", steal.Running and " + pad" or ""))
end)

steal.CAM = {}
steal.CAM.DETIK = 1
steal.CAM.MATA = Vector3.new(-26, 6, 0)
steal.CAM.BIDIK = Vector3.new(0, 2.5, 0)

steal.CAM.Titik = function()
	if steal.tulisPos then
		local tulisAt = steal.tulisAt or 0
		local sejak = steal.CAM.sejak

		if sejak then
			if not (sejak <= tulisAt) then
				return steal.CAM.bibit
			end
		elseif not (tulisAt >= 0) then
			return steal.CAM.bibit
		end

		return steal.tulisPos
	end

	return steal.CAM.bibit
end

steal.CAM.Lepas = function()
	if steal.CAM.cx then
		pcall(function()
			steal.CAM.cx:Disconnect()
		end)

		steal.CAM.cx = nil
	end

	pcall(function()
		local currentCamera = v.CurrentCamera

		if currentCamera then
			local jenis

			if steal.CAM.jenis and steal.CAM.jenis ~= Enum.CameraType.Scriptable then
				jenis = steal.CAM.jenis or Enum.CameraType.Custom
			else
				jenis = Enum.CameraType.Custom
				currentCamera.CameraType = jenis
				currentCamera.CameraSubject = fn3() or steal.CAM.subjek
				return
			end

			currentCamera.CameraType = jenis
			currentCamera.CameraSubject = fn3() or steal.CAM.subjek
			return
		end
	end)

	local cam = steal.CAM
	steal.CAM.jenis = nil
	cam.subjek = nil
	local cam2 = steal.CAM
	steal.CAM.bibit = nil
	cam2.mata = nil
end

tbl.ST.Trove:Add(steal.CAM.Lepas)

steal.CAM.Mulai = function()
	local v4 = fn2()
	local currentCamera = v.CurrentCamera

	if v4 then
		if currentCamera then
			if steal.TP and steal.TP.on then
				return
			end
			steal.CAM.bibit = v4.Position
			steal.CAM.mata = steal.CAM.bibit + steal.CAM.MATA
			steal.CAM.sejak = os.clock()
			steal.CAM.sampai = steal.CAM.sejak + steal.CAM.DETIK
			if steal.CAM.cx then
				return
			end
			steal.CAM.jenis = currentCamera.CameraType
			steal.CAM.subjek = currentCamera.CameraSubject
			currentCamera.CameraType = Enum.CameraType.Scriptable
			local cam = steal.CAM
			local renderStepped = runService.RenderStepped
			local v5 = renderStepped
			local connect = renderStepped.Connect

			local function fn21()
				local currentCamera2 = v.CurrentCamera
				local v6 = steal.CAM.Titik()
				if steal.CAM.sampai <= os.clock() or not steal.Running or not tbl.Alive or not currentCamera2 or not v6 or steal.TP and steal.TP.on then
					steal.CAM.Lepas()
					return
				end

				if currentCamera2.CameraType ~= Enum.CameraType.Scriptable then
					currentCamera2.CameraType = Enum.CameraType.Scriptable
				end

				local n3 = v6 + steal.CAM.BIDIK
				if not ((n3 - steal.CAM.mata).Magnitude < 1) then
					currentCamera2.CFrame = CFrame.lookAt(steal.CAM.mata, n3)
					return
				end
			end

			cam.cx = connect(v5, fn21)
			return
		end

		return
	end
end

steal.MATI = { gen = 0, at = 0, asal = nil, RESPAWN_MAKS = 15, siapChar = nil, segar = false, jumlah = 0 }

do
	local mati = steal.MATI
	local connection = nil

	local function fn21(asal)
		mati.gen = mati.gen + 1
		mati.at = os.clock()
		mati.asal = asal
	end

	local function fn22(arg)
		if connection then
			pcall(function()
				connection:Disconnect()
			end)

			connection = nil
		end

		local humanoid = arg and (arg:FindFirstChildOfClass("Humanoid") or arg:WaitForChild("Humanoid", 10))

		if humanoid then
			connection = humanoid.Died:Connect(function()
				fn21("Died")
			end)

			return
		end
	end

	tbl.ST.Trove:Connect(localPlayer.CharacterAdded, fn22)

	tbl.ST.Trove:Connect(localPlayer.CharacterRemoving, function()
		fn21("CharacterRemoving")
	end)

	tbl.ST.Trove:Add(function()
		if connection then
			pcall(function()
				connection:Disconnect()
			end)

			connection = nil
			return
		end
	end)

	if localPlayer.Character then
		task.spawn(fn22, localPlayer.Character)
	end

	mati.Bersihkan = function()
		pcall(steal.TP.Clear)

		if steal.FLOW then
			steal.FLOW.samar = false
			steal.FLOW.sibukAt = 0
		end

		steal.SPEED_FIX = nil
		pcall(steal.JAUH.Buka)
		pcall(steal.JAUH.Fade, true)
		pcall(steal.RUANG.GuardLepas)
		pcall(steal.CAM.Lepas)
		pcall(steal.MT.Henti)
		pcall(steal.TRAIL.Pulih)
		steal.pulang = false
	end

	mati.SIAP_CADANGAN = 0.8

	mati.TungguHidup = function()
		local n3 = os.clock() + mati.RESPAWN_MAKS
		local now = nil

		while steal.Running do
			if tbl.Alive then
				if not (os.clock() < n3) then
					break
				end
				local character = localPlayer.Character
				local humanoid, humanoidRootPart

				if character then
					humanoid = character:FindFirstChildOfClass("Humanoid")
					humanoidRootPart = character:FindFirstChild("HumanoidRootPart")
				else
					humanoid = character
					humanoidRootPart = character
				end

				if humanoid and humanoidRootPart and humanoid.Health > 0 and humanoidRootPart:IsDescendantOf(workspace) then
					if mati.siapChar == character then
						break
					end
					now = now or os.clock()
					if mati.SIAP_CADANGAN <= os.clock() - now then
						break
					end
				end

				runService.Heartbeat:Wait()
				continue
			end

			break
		end

		mati.segar = true
	end
end

steal.Start = function()
	if steal.Running then
		return
	end
	steal.RunGeneration = (steal.RunGeneration or 0) + 1
	local myGeneration = steal.RunGeneration
	steal.Running = true
	steal.STYLE.darat = false
	for _, step in ipairs({
		{ "SpoofStart", steal.SpoofStart },
		{ "PadStart", steal.PadStart },
		{ "WatchStart", steal.WatchStart },
		{ "PromptOff", steal.PROMPT.Off },
		{ "BannerOff", steal.BANNER.Off },
	}) do
		local ok, err = pcall(step[2])
		if not ok then tbl.LOG.warn("AutoSteal.Start", step[1] .. ": " .. tostring(err)) end
	end
	local speedOk, currentSpeed = pcall(steal.Speed)
	tbl.LOG.info("STEAL", ("start | speed=%s | candidates scan available"):format(speedOk and tostring(currentSpeed) or "unavailable"))
	local v4 = nil

	task.spawn(function()
		while steal.Running and steal.RunGeneration == myGeneration do
			if tbl.Alive then
				local gen = steal.MATI.gen
				local now = os.clock()
				local flag2 = false
				local v5 = nil
				local v6 = nil

				local function fn21()
					local ok, result = xpcall(steal.Cycle, function(err)
						local message = tostring(err)
						if debug and type(debug.traceback) == "function" then
							local traced, stack = pcall(debug.traceback, message, 2)
							if traced and type(stack) == "string" then return stack end
						end
						return message
					end)
					v5 = ok
					v6 = result
					flag2 = true
				end

				local thread = task.spawn(fn21)

				while not flag2 do
					if steal.RunGeneration ~= myGeneration then break end
					if steal.Running then
						if tbl.Alive then
							if steal.MATI.gen == gen then
								runService.Heartbeat:Wait()
								continue
							end
							break
						end

						break
					end

					break
				end

				if not flag2 and (not steal.Running or not tbl.Alive or steal.RunGeneration ~= myGeneration) then
					pcall(task.cancel, thread)
					break
				elseif not flag2 and steal.MATI.gen ~= gen then
					local ok = pcall(task.cancel, thread)
					steal.MATI.Bersihkan()
					steal.MATI.jumlah = steal.MATI.jumlah + 1
					steal.Fails = steal.Fails + 1
					local kunci = steal.KUNCI

					if kunci.t and now <= (kunci.t.dicobaAt or 0) then
						kunci.Gagal("mati")
					end

					tbl.LOG.warn("STEAL", ("mati (%s) - putaran dibuang%s, ulang dari awal%s"):format(tostring(steal.MATI.asal), ok and "" or " (utas TIDAK bisa dibatalkan)", if kunci.t then " untuk " .. kunci.t.name else ""))
					fn4("died - restarting steal from the beginning")
					v4 = nil
					steal.MATI.TungguHidup()
				else
					while not flag2 and steal.RunGeneration == myGeneration do
						runService.Heartbeat:Wait()
					end
					if steal.RunGeneration ~= myGeneration then
						pcall(task.cancel, thread)
						break
					end

					pcall(steal.TP.Clear)

					if not v5 then
						local err = tostring(v6)
						steal.LastCycleErrorCount = (steal.LastCycleErrorCount or 0) + 1
						steal.LastCycleErrorAt = os.clock()
						steal.LastCycleError = err
						-- Avoid repeatedly flooding the log when the same game API is broken.
						if err ~= steal.LastLoggedCycleError or not steal.LastLoggedCycleErrorAt
							or os.clock() - steal.LastLoggedCycleErrorAt >= 15 then
							tbl.LOG.err("STEAL.Cycle", err)
							steal.LastLoggedCycleError = err
							steal.LastLoggedCycleErrorAt = os.clock()
						end
						fn4("cycle error - see Auto Steal Error Details")
						if not steal.LastErrorToastAt or os.clock() - steal.LastErrorToastAt > 25 then
							steal.LastErrorToastAt = os.clock()
							if tbl.UIX and tbl.UIX.Pita then
								pcall(tbl.UIX.Pita, "Auto Steal cycle failed. Read Error Details below Check Auto Steal.", 5)
							end
						end
						v4 = nil
						-- Gradually back off repeated exceptions instead of hammering the server.
						task.wait(math.min(5, 1 + math.floor(steal.LastCycleErrorCount / 3)))
					else
						-- Keep the last exception available for diagnosis, even after a retry succeeds.
						fn4(v6)
						local str2 = ("%s|%d|%d"):format(tostring(v6), steal.Claims, steal.Fails)

						if str2 ~= v4 then
							v4 = str2
							tbl.LOG.info("STEAL", ("putaran: %s (berhasil %d / gagal %d)"):format(tostring(v6), steal.Claims, steal.Fails))
						end

						local n3, n4

						if v6 == "tidak ada telur cocok" then
							n3 = 2
							n4 = n3 or v6 == "egg claimed" and 0.05
						else
							n3 = v6 == "waiting for turn"

							if n3 then
								n4 = 1
							else
								n4 = n3 or v6 == "egg claimed" and 0.05
								task.wait(n4 or 0.4)
								continue
							end
						end

						task.wait(n4 or 0.4)
					end
				end

				continue
			end

			break
		end

		-- An older runner must never clean up the latest session after a
		-- quick OFF/ON toggle or switch between auto and teleport modes.
		if steal.RunGeneration ~= myGeneration then return end
		pcall(steal.TP.Clear)
		steal.PadStop()
		pcall(steal.Pulang)
		steal.SpoofStop()
		pcall(steal.MT.Henti)
		fn4("idle")
	end)
end

steal.Pulang = function()
	if steal.pulang then
		return
	end
	local v4 = fn2()

	if v4 then
		if not steal.RUANG.DiDalam() and v4.Position.X <= steal.GATE_X and steal.GATE_BAWAH < v4.Position.Y then
			return
		end
		steal.pulang = true
		fn4("auto steal stopped - returning to safe zone")
		steal.PulangTeleport("stopped")
		return
	end
end

steal.PulangTeleport = function(arg)
	local str2 = tostring(arg or "stopped")
	steal.pulang = true
	n += 1
	pcall(steal.TRAIL.Mati)
	pcall(steal.MT.Henti)
	steal.SpoofStart()
	steal.PadStart()
	runService.PreSimulation:Wait()
	runService.PreSimulation:Wait()
	steal.JAUH.Fade(false)
	fn4(str2 .. (steal.RUANG.DiDalam() and " - leaving fuse room" or " - teleporting to safe zone"))
	steal.FLOW.Tahan(steal.STRIP, 0.6)
	local sekarang = steal.ORDER and steal.ORDER.sekarang
	local flag2 = sekarang and sekarang ~= "auto_steal"

	if str2 == "stopped" and not steal.RUANG.DiDalam() and not flag2 then
		fn4(str2 .. " - treadmill round")
		local v4 = steal.TM.Pad()

		if v4 then
			steal.FLOW.Tahan(v4.Position + Vector3.new(0, 3.5, 0), 0.25)
			local Treadmill = tbl.NET.Get("Treadmill", "AskWearStill")
			local flag3 = false
			local n3 = os.clock() + 0.6

			while Treadmill do
				if not (os.clock() < n3) then
					break
				end
				local v5 = table.pack(pcall(Treadmill.InvokeServer, Treadmill))
				if v5[1] and v5[2] == true then
					flag3 = true
					break
				end
				task.wait(0.05)
			end

			tbl.LOG.info("STEAL", ("ronde treadmill (%s): naik=%s"):format(str2, tostring(flag3)))

			if flag3 then
				task.wait(0.25)
			end

			local Treadmill2 = tbl.NET.Get("Treadmill", "AskDoff")

			if Treadmill2 then
				pcall(Treadmill2.InvokeServer, Treadmill2)
			end

			steal.TM.LastGain = 0
		end
	end

	fn4(str2 .. " - standing by at safe zone")
	steal.FLOW.Tahan(steal.STRIP, 0.6)
	steal.JAUH.Fade(true)
	pcall(steal.TRAIL.Pulih)
	steal.pulang = false
end

steal.TRAIL = { simpan = nil, kunci = false, cx = {} }

steal.TRAIL.Mati = function()
	local character = localPlayer.Character

	if character then
		local simpan = steal.TRAIL.simpan

		if not simpan then
			simpan = {}

			for _, descendant in ipairs(character:GetDescendants()) do
				if descendant:IsA("Trail") and descendant.Enabled then
					simpan[#simpan + 1] = descendant
				end
			end

			steal.TRAIL.simpan = simpan
		end

		steal.TRAIL.kunci = true

		for _, v4 in ipairs(simpan) do
			if v4 and v4.Parent then
				pcall(function()
					v4.Enabled = false
				end)

				if not steal.TRAIL.cx[v4] then
					steal.TRAIL.cx[v4] = v4:GetPropertyChangedSignal("Enabled"):Connect(function()
						if steal.TRAIL.kunci and v4.Enabled then
							pcall(function()
								v4.Enabled = false
							end)

							return
						end
					end)
				end
			end
		end

		return
	end
end

steal.TRAIL.Pulih = function()
	steal.TRAIL.kunci = false

	for k, v4 in pairs(steal.TRAIL.cx) do
		pcall(function()
			v4:Disconnect()
		end)

		steal.TRAIL.cx[k] = nil
	end

	local simpan = steal.TRAIL.simpan

	if simpan then
		steal.TRAIL.simpan = nil

		for _, v4 in ipairs(simpan) do
			if v4 and v4.Parent then
				pcall(function()
					v4.Enabled = true
				end)
			end
		end

		return
	end
end

tbl.ST.Trove:Add(function()
	pcall(steal.TRAIL.Pulih)
end)

steal.Stop = function()
	if steal.Running then
		steal.RunGeneration = (steal.RunGeneration or 0) + 1
		steal.Running = false
		steal.KUNCI.Lepas("auto steal dimatikan")
		table.clear(steal.KUNCI.lewati)
		steal.STYLE.darat = true
		pcall(steal.TP.Clear)
		pcall(steal.TRAIL.Mati)
		pcall(steal.PulihTabrak)
		pcall(steal.PROMPT.On)
		pcall(steal.BANNER.On)
		pcall(steal.SEMBUNYI.LepasNanti)

		if steal.SCR then
			steal.SCR.sesi = false
		end

		tbl.LOG.info("STEAL", ("berhenti — berhasil %d, gagal %d"):format(steal.Claims, steal.Fails))
		return
	end
end

local afkm = { on = false, mulai = 0, telur = {}, MAKS = 150 }
afkm.mati3d = false
steal.AFKM = afkm

steal.AFKM.Catat = function(arg, arg2)
	local ok, result = pcall(steal.WH.Pahlawan, arg, arg2)

	if ok then
		if type(result) ~= "table" then
			return
		end
		result.jam = os.time()
		local telur = steal.AFKM.telur
		table.insert(telur, 1, result)

		for i = #telur, steal.AFKM.MAKS + 1, -1 do
			telur[i] = nil
		end

		return
	end
end

steal.AFKM.Ringkas = function()
	local n3 = 0
	local n4 = 0

	for _, v4 in ipairs(steal.AFKM.telur) do
		n3 += tonumber(v4.laju) or 0
		n4 += tonumber(v4.berat) or 0
	end

	local v4 = if steal.AFKM.on then os.time() - steal.AFKM.mulai else 0
	local n5 = v4 / 3600

	return {
		detik = v4,
		klaim = steal.Claims or 0,
		gagal = steal.Fails or 0,
		telur = #steal.AFKM.telur,
		laju = n3,
		berat = n4,
		perJam = not (n5 > 0.0028) and 0 or #steal.AFKM.telur / n5,
	}
end

steal.AFKM.Waktu = function(arg)
	local n3 = math.max(0, math.floor(tonumber(arg) or 0))
	return ("%02d:%02d:%02d"):format(n3 // 3600, n3 % 3600 // 60, n3 % 60)
end

steal.AFKM.Render = function(arg)
	local runService2 = tbl.SV.RunService
	if type(runService2.Set3dRenderingEnabled) ~= "function" then
		return false, "API not available"
	end

	local ok, result = pcall(function()
		runService2:Set3dRenderingEnabled(arg and true or false)
	end)

	if ok then
		steal.AFKM.mati3d = not arg
		return true
	end
	return false, tostring(result)
end

steal.AFKM.Start = function()
	if steal.AFKM.on then
		return true
	end
	steal.AFKM.on = true
	steal.AFKM.mulai = os.time()
	if steal.AFKM.mati3d then
		pcall(steal.AFKM.Render, true)
		return true
	end
	return true
end

steal.AFKM.Stop = function()
	if steal.AFKM.on then
		steal.AFKM.on = false
		pcall(steal.AFKM.Render, true)
		return
	end
end

tbl.ST.Trove:Add(function()
	pcall(steal.AFKM.Render, true)
end)

steal.ATRAP = { on = false, Buang = 0, Lolos = 0, Riwayat = {}, MAKS = 40, cx = {} }

do
	local atrap = steal.ATRAP
	local tbl2 = { PlayerTrap = true, BearTrap = true, Trap = true }

	local function fn21(arg)
		if arg:IsA("BasePart") then
			local name = arg.Name

			if name:find("Trap", 1, true) then
				if tbl2[name] then
					return true
				end
				local hitbox = arg:FindFirstChild("Hitbox")
				local flag2 = hitbox ~= nil
				if flag2 then
					return (hitbox:IsA("BasePart"))
				end
				return flag2
			end

			return false
		end

		return false
	end

	local function fn22(descendant)
		if atrap.on then
			if descendant then
				if descendant.Parent then
					if fn21(descendant) then
						local attribute = descendant:GetAttribute("Owner")
						if attribute ~= nil and tostring(attribute) == tbl.PLR.Name then
							atrap.Lolos = atrap.Lolos + 1
							return false
						end
						local position = descendant.Position

						local function fn23()
							descendant:Destroy()
						end

						if pcall(fn23) then
							atrap.Buang = atrap.Buang + 1
							table.insert(atrap.Riwayat, 1, position)

							for i = #atrap.Riwayat, atrap.MAKS + 1, -1 do
								atrap.Riwayat[i] = nil
							end

							tbl.LOG.warn("ATRAP", ("trap %s (pemilik %s) dihapus di %.0f, %.0f, %.0f -- total %d"):format(descendant.Name, tostring(attribute), position.X, position.Y, position.Z, atrap.Buang))
							return true
						end

						return false
					end

					return false
				end

				return false
			end

			return false
		end

		return false
	end

	local function fn23(arg)
		if arg then
			atrap.cx[#atrap.cx + 1] = arg.DescendantAdded:Connect(fn22)

			for _, descendant in ipairs(arg:GetDescendants()) do
				fn22(descendant)
			end

			return
		end
	end

	atrap.Start = function()
		if atrap.on then
			return true
		end
		atrap.on = true
		fn23(workspace:FindFirstChild("Transient"))
		fn23(workspace:FindFirstChild("__DEBRIS"))

		for _, child in ipairs(workspace:GetChildren()) do
			fn22(child)
		end

		local n3 = #atrap.cx + 1
		local childAdded = workspace.ChildAdded
		local v4 = childAdded
		local connect = childAdded.Connect

		local function fn24(arg)
			if arg.Name ~= "Transient" then
				if arg.Name ~= "__DEBRIS" then
					fn22(arg)
					return
				end
				fn23(arg)
				return
			end

			fn23(arg)
		end

		atrap.cx[n3] = connect(v4, fn24)

		local function fn25(character)
			if not character then
				return
			end

			local function fn26()
				if character:GetAttribute("IsTrapped") ~= true then
					return
				end

				pcall(function()
					character:SetAttribute("IsTrapped", false)
				end)

				local humanoid = character:FindFirstChildOfClass("Humanoid")
				local humanoidRootPart = character:FindFirstChild("HumanoidRootPart") or character.PrimaryPart

				if humanoid then
					pcall(function()
						humanoid.PlatformStand = false
						humanoid.AutoRotate = true
						if humanoid.JumpHeight ~= 0 then
							return
						end
						humanoid.JumpHeight = 7.2
					end)
				end

				if humanoidRootPart then
					pcall(function()
						humanoidRootPart.Anchored = false
					end)

					return
				end
			end

			fn26(true)
			local cx = atrap.cx
			local cx2 = atrap.cx

			cx[#cx2 + 1] = character:GetAttributeChangedSignal("IsTrapped"):Connect(function()
				fn26(false)
			end)
		end

		fn25(tbl.PLR.Char)
		atrap.cx[#atrap.cx + 1] = tbl.PLR.Player.CharacterAdded:Connect(fn25)
		tbl.LOG.info("ATRAP", ("anti-trap aktif -- %d koneksi, sapuan awal buang %d / lewati %d"):format(#atrap.cx, atrap.Buang, atrap.Lolos))
		return true
	end

	atrap.Stop = function()
		atrap.on = false

		for _, v4 in ipairs(atrap.cx) do
			pcall(function()
				v4:Disconnect()
			end)
		end

		atrap.cx = {}
	end

	local function fn24()
		local ok, result = pcall(atrap.Start)
		if ok then
			return
		end
		tbl.LOG.err("ATRAP", tostring(result))
	end

	task.defer(fn24)

	tbl.ST.Trove:Add(function()
		pcall(atrap.Stop)
	end)
end

steal.RAMPOK = {
	on = false,
	Status = "idle",
	Diambil = 0,
	Coba = 0,
	target = nil,
	cx = {},
	hitam = {},
	pendengar = {},
}

do
	local tbl2 = { 1.1, 0.2, 0.7, 1.4, 0.45 }
	local n3 = 1245
	local n4 = 16
	local n5 = 5
	local n6 = 12
	local n7 = 120
	local n8 = 20
	local n9 = 1
	local v4 = nil
	local n10 = 0

	steal.RAMPOK.Dengar = function(arg)
		steal.RAMPOK.pendengar[#steal.RAMPOK.pendengar + 1] = arg
	end

	local function kabar(status)
		if steal.RAMPOK.Status ~= status then
			steal.RAMPOK.Status = status

			for _, v5 in ipairs(steal.RAMPOK.pendengar) do
				pcall(v5, status)
			end

			return
		end
	end

	steal.RAMPOK.Kabar = kabar

	steal.RAMPOK.Pembawa = function()
		local tbl3 = {}
		local now = os.clock()

		for _, v5 in pairs(steal.FieldRecords()) do
			local str2 = tostring(v5.Uid)

			if tostring(v5.State) == "Carried" then
				local v6 = steal.RAMPOK.hitam[str2]

				if v6 then
					if not (v6 <= now) then
						continue
					end
				elseif not (now >= 0) then
					continue
				end

				local num = tonumber(v5.CarrierUserId)

				if num and num ~= localPlayer.UserId then
					local playerByUserId = tbl.SV.Players:GetPlayerByUserId(num)
					local humanoidRootPart = playerByUserId and playerByUserId.Character and playerByUserId.Character:FindFirstChild("HumanoidRootPart")

					if playerByUserId and humanoidRootPart then
						tbl3[#tbl3 + 1] = { rec = v5, uid = str2, player = playerByUserId, root = humanoidRootPart }
					end
				end
			end
		end

		return tbl3
	end

	steal.RAMPOK.Daftar = function()
		local tbl3 = {}

		for _, v5 in ipairs(steal.RAMPOK.Pembawa()) do
			tbl3[v5.player] = v5
		end

		local v5 = fn2()
		local position = v5 and v5.Position
		local tbl4 = {}

		for _, player in ipairs(tbl.SV.Players:GetPlayers()) do
			if player ~= localPlayer then
				local humanoidRootPart = player.Character and player.Character:FindFirstChild("HumanoidRootPart")
				local v6 = tbl3[player]
				local v7 = if humanoidRootPart and position then math.floor((humanoidRootPart.Position - position).Magnitude + 0.5) else nil
				local str2

				if v6 and v6.rec.AreaId then
					str2 = tostring(v6.rec.AreaId)
				else
					str2 = "Offline"

					if humanoidRootPart then
						str2 = humanoidRootPart.Position.X <= steal.GATE_X and "Safe Zone" or "Field"
					end
				end

				local str3 = nil
				local v8 = nil
				local flag2 = nil

				if v6 then
					str3 = tostring(v6.rec.AssetCategory or "Egg")
					v8 = steal.PLACE.RarityDari(str3)
					local ok, result = pcall(steal.ValueOf, v6.rec)
					flag2 = ok and type(result) == "number" and result > 0 and result or nil
				end

				tbl4[#tbl4 + 1] = {
					player = player,
					nama = tostring(player.DisplayName or player.Name),
					user = tostring(player.Name),
					bawa = v6 ~= nil,
					uid = v6 and v6.uid or nil,
					telur = str3,
					rarity = v8,
					nilai = flag2,
					dimana = str2,
					jarak = v7,
					bisa = v6 ~= nil and humanoidRootPart ~= nil and humanoidRootPart.Position.X > steal.GATE_X + n7 and player:GetAttribute("InBossArena") ~= true,
				}
			end
		end

		local sort = table.sort

		local function fn21(arg, arg2)
			if arg.bawa ~= arg2.bawa then
				return arg.bawa
			end
			return (arg.jarak or 1e9) < (arg2.jarak or 1e9)
		end

		sort(tbl4, fn21)
		return tbl4
	end

	local function fn21(arg)
		local bottomCFrame = arg.BottomCFrame or arg.BoundsCFrame
		if typeof(bottomCFrame) ~= "CFrame" then
			return false
		end
		local n11 = bottomCFrame.Position + Vector3.new(0, 2.5, 0)
		local v5 = steal.FLOW.UidDekat(bottomCFrame.Position, tostring(arg.AssetCategory), 30)
		local uid = v5 and v5.uid or tostring(arg.Uid)
		if steal.Carry(uid, n11, 8, tostring(arg.AssetCategory)) then
			return true, uid
		end
		return false, uid
	end

	steal.RAMPOK.Henti = function()
		steal.RAMPOK.minta = true
	end

	steal.RAMPOK.Kejar = function(target)
		if steal.RAMPOK.on then
			return false, "a chase is already running"
		end
		local v5 = nil

		for _, v6 in ipairs(steal.RAMPOK.Pembawa()) do
			if v6.player ~= target then
				continue
			end
			v5 = v6
			break
		end

		if not v5 then
			return false, "not carrying an egg"
		end

		if not (v5.root.Position.X <= steal.GATE_X + n7) then
			local rampok = steal.RAMPOK
			steal.RAMPOK.on = true
			rampok.minta = false
			steal.RAMPOK.target = target
			steal.RAMPOK.Coba = steal.RAMPOK.Coba + 1
			local spawn = task.spawn

			local function fn22()
				local ok, result = pcall(steal.RAMPOK.Jalan, v5)

				if not ok then
					tbl.LOG.err("RAMPOK", tostring(result))
				end

				local rampok2 = steal.RAMPOK
				steal.RAMPOK.on = false
				rampok2.target = nil
				steal.rampok = false
				kabar("idle")
			end

			spawn(fn22)
			return true
		end

		return false, "too close to their safe zone"
	end

	steal.RAMPOK.Jalan = function(arg)
		local uid = arg.uid
		local player = arg.player
		local str2 = tostring(player.DisplayName or player.Name)
		steal.rampok = true
		n += 1
		local v5 = n
		local running = steal.Running
		steal.SpoofStart()
		steal.PadStart()

		if steal.TM.NaikPasti() then
			steal.TM.DoffPasti(2)
		end

		local v6 = steal.GOD.Bat()
		local now = os.clock()
		local n11 = now + 16
		local n12 = 0.1

		local function fn22()
			n12 = math.clamp(localPlayer:GetNetworkPing() or 0.1, 0.03, 0.6)
		end

		pcall(fn22)
		local n13 = math.clamp(0.14 + n12, 0.14, 0.35)
		n9 = v4 or n9 or 1
		n10 = 0
		local attribute = player:GetAttribute("RagdollEndTime") or false
		local tbl3 = {}
		kabar(("chasing %s"):format(str2))
		fn4(("chasing %s"):format(str2))
		local v7 = nil
		local v8 = nil
		local v9 = nil
		local vector = Vector3.zero
		local v10 = nil
		local str3 = "could not catch them"

		if os.clock() < n11 then
			local result = runService.PreSimulation:Wait()

			if steal.RAMPOK.minta then
				str3 = "stopped"
			elseif n ~= v5 then
				str3 = "another mover took over"
			else
				local v11 = nil

				for _, v12 in pairs(steal.FieldRecords()) do
					if tostring(v12.Uid) ~= uid then
						continue
					end
					v11 = v12
					break
				end

				if v11 then
					local exitTo

					repeat
						local str4 = tostring(v11.State)
						exitTo = nil

						while true do
							if v11 and str4 ~= "Slot" and str4 ~= "GuardCarried" then
								if str4 ~= "Claimed" then
									if str4 == "Carried" and tostring(v11.CarrierUserId) == tostring(localPlayer.UserId) then
										exitTo = 3
										break
									end

									if str4 ~= "Dropped" then
										local v12 = fn2()
										local humanoid = v12 and localPlayer.Character and localPlayer.Character:FindFirstChildOfClass("Humanoid")

										if v12 and humanoid and humanoid.Health > 0 then
											local num = tonumber(v11.CarrierUserId)

											if num and num ~= player.UserId then
												local playerByUserId = tbl.SV.Players:GetPlayerByUserId(num)
												if not playerByUserId then
													exitTo = 6
													break
												end
												str2 = tostring(playerByUserId.DisplayName or playerByUserId.Name)
												attribute = playerByUserId:GetAttribute("RagdollEndTime") or false
												table.clear(tbl3)
												kabar(("chasing %s"):format(str2))
												v7 = nil
												v8 = nil
												player = playerByUserId
											end

											if player.Character then
												local humanoidRootPart = player.Character:FindFirstChild("HumanoidRootPart")

												if humanoidRootPart then
													if not (humanoidRootPart.Position.X <= steal.GATE_X) then
														local now2 = os.clock()
														tbl3[#tbl3 + 1] = { t = now2, p = humanoidRootPart.Position }

														while #tbl3 > 2 do
															if now2 - tbl3[1].t > 0.4 then
																table.remove(tbl3, 1)
																continue
															end
															break
														end

														local assemblyLinearVelocity = humanoidRootPart.AssemblyLinearVelocity

														if not (Vector3.new(assemblyLinearVelocity.X, 0, assemblyLinearVelocity.Z).Magnitude > 8) then
															if #tbl3 >= 2 and now2 - tbl3[1].t > 0.15 then
																vector = (humanoidRootPart.Position - tbl3[1].p) / (now2 - tbl3[1].t)
															end
														else
															vector = assemblyLinearVelocity
														end

														local vector2 = Vector3.new(vector.X, 0, vector.Z)
														local magnitude = vector2.Magnitude
														local unit

														if not (magnitude > 6) then
															local lookVector = humanoidRootPart.CFrame.LookVector
															local vector3 = Vector3.new(lookVector.X, 0, lookVector.Z)
															unit = vector3.Magnitude > 0.05 and vector3.Unit or Vector3.new(-1, 0, 0)
														else
															unit = vector2.Unit
														end

														local n14 = humanoidRootPart.Position + unit * math.clamp((tbl2[n9] or 1) * magnitude * n13, 3, 60)

														if n14.X < steal.GATE_X + 5 then
															n14 = Vector3.new(steal.GATE_X + 5, n14.Y, n14.Z)
														end

														local vector3 = Vector3.new(humanoidRootPart.Position.X, n14.Y, humanoidRootPart.Position.Z)

														if (vector3 - n14).Magnitude < 0.5 then
															vector3 = n14 - unit
														end

														local cframe = CFrame.lookAt(n14, vector3)
														local n15 = n14 - v12.Position
														local magnitude2 = n15.Magnitude
														local n16 = math.min(steal.Speed() * math.min(result, 0.05), steal.StepCap())

														if not (n16 < magnitude2) then
															steal.Tulis(v12, cframe, false)
														else
															steal.Tulis(v12, CFrame.new(v12.Position + n15.Unit * n16) * cframe.Rotation, false)
														end

														local n17 = magnitude * result * 1.5

														if not (magnitude2 <= 5 + n17) then
															if 12 + n17 < magnitude2 and v7 then
																kabar(("chasing %s"):format(str2))
																v7 = nil
															end
														else
															v7 = v7 or now2
															kabar(humanoidRootPart.Position.X <= 1245 and ("hitting %s"):format(str2) or ("chasing %s"):format(str2))
														end

														local attribute2 = player:GetAttribute("RagdollEndTime") or false

														if attribute2 ~= attribute then
															v4 = n9
															n10 = 0
															v8 = nil
															attribute = attribute2
															v9 = now2
														end

														if not v6 or v6.Parent ~= localPlayer.Character then
															v6 = steal.GOD.Bat()
														end

														local n18 = v6 and tonumber(v6:GetAttribute("CooldownEndTime")) or 0

														if v8 and now2 - v8 > 0.9 then
															if n18 ~= v10 then
																n10 += 1

																if n10 >= 2 then
																	n10 = 0
																	n9 = n9 % #tbl2 + 1
																	v7 = nil
																end
															end

															v8 = nil
														end

														if v6 and v6.Parent == localPlayer.Character and v7 and n13 + 0.05 <= now2 - v7 and humanoidRootPart.Position.X <= 1245 and steal.GOD.Ayun(player) and not v8 then
															v8 = now2
															v10 = n18
														end

														if not (os.clock() < n11) then
															break
														end
														result = runService.PreSimulation:Wait()
														if steal.RAMPOK.minta then
															exitTo = 9
															break
														end

														if n ~= v5 then
															exitTo = 10
															break
														end
														v11 = nil

														for _, v13 in pairs(steal.FieldRecords()) do
															if tostring(v13.Uid) ~= uid then
																continue
															end
															v11 = v13
															break
														end

														if v11 then
															exitTo = 11
															break
														end
														str4 = v11
														continue
													end

													exitTo = 8
													break
												end

												exitTo = 7
												break
											end

											exitTo = 7
											break
										end

										exitTo = 5
										break
									end

									exitTo = 4
									break
								end

								exitTo = 2
								break
							else
								exitTo = 1
								break
							end
						end

						if exitTo == 1 then
							str3 = "egg reset"
							break
						end

						if exitTo == 2 then
							str3 = "they banked it"
							break
						end

						if exitTo == 3 then
							str3 = "taken"
							break
						end

						if exitTo == 4 then
							local now2 = os.clock()
							local flag2 = (player:GetAttribute("RagdollEndTime") or false) ~= attribute

							if v7 ~= nil then
								if (not v8 or not (now2 - v8 <= 1)) and (not v9 or not (now2 - v9 <= 1.5)) then
									if flag2 then
										if v8 then
											if now2 - v8 <= 1 then
												v4 = n9
											end
										elseif v8 and now2 - v8 <= 1 then
											v4 = n9
										end
									end
								elseif v8 and now2 - v8 <= 1 then
									v4 = n9
								end
							end

							kabar(("grabbing the egg from %s"):format(str2))
							str3 = fn21(v11) and "taken" or "someone else grabbed it"
							break
						end

						if exitTo == 5 then
							str3 = "character died"
							break
						end

						if exitTo == 6 then
							str3 = "taken by another player"
							break
						end

						if exitTo == 7 then
							str3 = "lost sight of them"
							break
						end

						if exitTo == 8 then
							str3 = "they banked it"
							break
						end

						if exitTo == 9 then
							str3 = "stopped"
							break
						end

						if exitTo == 10 then
							str3 = "another mover took over"
							break
						end
					until exitTo ~= 11
				else
					str3 = "egg reset"
				end
			end
		end

		n += 1

		if str3 ~= "taken" then
			steal.RAMPOK.hitam[uid] = os.clock() + 20
			tbl.LOG.warn("RAMPOK", ("%s: %s"):format(str2, str3))

			if not steal.Running and not steal.DiSafeZone() then
				steal.rampok = false
				pcall(steal.PulangSiklus, "raid")
			end
		else
			steal.RAMPOK.Diambil = steal.RAMPOK.Diambil + 1
			local format = ("banking the egg from %s").format
			kabar(format("banking the egg from %s", str2))
			fn4("banking stolen egg")
			str3 = steal.Deposit(uid) and "taken and banked" or "taken but not banked"
			tbl.LOG.info("RAMPOK", ("%s: %s"):format(str2, str3))
		end

		if not running and not steal.Running then
			steal.SpoofStop()
			steal.PadStop()
		end

		steal.rampok = false
		kabar(str3)
		fn4("idle")
		return str3
	end
end

tbl.ST.Trove:Add(function()
	steal.RAMPOK.minta = true
	steal.rampok = false
end)

steal.AA = {}

do
	local aa = steal.AA
	local esp = { on = false, kartu = {} }
	esp.bin = nil
	esp.POLL = 2
	esp.JARAK = 1500
	esp.RAR = { Divine = true, Eternal = true, Secret = true, Cosmic = true }

	esp.WARNA = {
		Divine = Color3.new(1, 0.84313726425170898, 0),
		Eternal = Color3.new(1, 0.23529411852359772, 0.23529411852359772),
		Secret = Color3.new(0.76470589637756348, 0.21568627655506134, 1),
		Cosmic = Color3.new(0, 0.94117647409439087, 1),
	}

	aa.ESP = esp

	local function fn21()
		local esp2 = steal.AA.ESP
		local currentCamera = v.CurrentCamera

		if currentCamera then
			if esp2.bin and esp2.bin.Parent == currentCamera then
				return esp2.bin
			end
			local folder2 = Instance.new("Folder")
			folder2.Name = "f" .. tostring(math.random(100000, 999999))
			folder2.Parent = currentCamera
			esp2.bin = folder2
			return folder2
		end

		return nil
	end

	local function fn22(arg, arg2, color)
		local v4 = steal.ESP.Info(arg2)
		local v5 = fn21()

		if v5 then
			local part = Instance.new("Part")
			part.Size = Vector3.new(0.2, 0.2, 0.2)
			part.Transparency = 1
			part.Anchored = true
			part.CanCollide = false
			part.CanQuery = false
			part.CanTouch = false
			part.CFrame = CFrame.new(arg + Vector3.new(0, 3, 0))
			part.Parent = v5
			local billboardGui = Instance.new("BillboardGui")
			billboardGui.Adornee = part
			billboardGui.Size = UDim2.new(0, 190, 0, 40)
			billboardGui.AlwaysOnTop = true
			billboardGui.MaxDistance = steal.AA.ESP.JARAK
			billboardGui.ResetOnSpawn = false
			billboardGui.Parent = part
			local frame = Instance.new("Frame")
			frame.Size = UDim2.new(1, 0, 1, 0)
			frame.BackgroundColor3 = Color3.new(0.047058824449777603, 0.062745101749897, 0.094117648899555206)
			frame.BackgroundTransparency = 0.25
			frame.BorderSizePixel = 0
			frame.Parent = billboardGui
			local uiCorner = Instance.new("UICorner")
			uiCorner.CornerRadius = UDim.new(0, 8)
			uiCorner.Parent = frame
			local uiStroke = Instance.new("UIStroke")
			uiStroke.Color = color
			uiStroke.Thickness = 1.4
			uiStroke.Parent = frame
			local textLabel = Instance.new("TextLabel")
			textLabel.Size = UDim2.new(1, -10, 0, 20)
			textLabel.Position = UDim2.new(0, 5, 0, 2)
			textLabel.BackgroundTransparency = 1
			textLabel.Font = Enum.Font.GothamBold
			textLabel.TextSize = 13
			textLabel.TextColor3 = color
			textLabel.TextTruncate = Enum.TextTruncate.AtEnd
			textLabel.Text = v4
			textLabel.Parent = frame
			local textLabel2 = Instance.new("TextLabel")
			textLabel2.Name = "Jarak"
			textLabel2.Size = UDim2.new(1, -10, 0, 14)
			textLabel2.Position = UDim2.new(0, 5, 0, 22)
			textLabel2.BackgroundTransparency = 1
			textLabel2.Font = Enum.Font.Gotham
			textLabel2.TextSize = 11
			textLabel2.TextColor3 = Color3.new(0.7450980544090271, 0.78431373834609985, 0.84313726425170898)
			textLabel2.Text = ""
			textLabel2.Parent = frame
			return { patok = part, jarak = textLabel2 }
		end

		return nil
	end

	steal.AA.ESP.Denyut = function()
		local esp2 = steal.AA.ESP

		if esp2.on then
			local v4 = fn2()
			local position = v4 and v4.Position or Vector3.zero
			local tbl2 = {}

			for _, v5 in pairs(steal.FieldRecords()) do
				if tostring(v5.State) == "Slot" and not tostring(v5.Uid):find(str, 1, true) and typeof(v5.BottomCFrame) == "CFrame" then
					local v6 = steal.RarityIdOf(tostring(v5.AssetCategory))

					if esp2.RAR[v6] then
						local position2 = v5.BottomCFrame.Position

						if (position2 - position).Magnitude <= esp2.JARAK then
							local str2 = tostring(v5.Uid)
							tbl2[str2] = true
							local v7 = esp2.kartu[str2]

							if not v7 or not v7.patok or not v7.patok.Parent then
								v7 = fn22(position2, v5, esp2.WARNA[v6] or Color3.new(1, 1, 1))
								esp2.kartu[str2] = v7
							end

							if v7 then
								v7.jarak.Text = ("%s  -  %d stud"):format(v6, math.floor((position2 - position).Magnitude))
							end
						end
					end
				end
			end

			for k, v5 in pairs(esp2.kartu) do
				if not tbl2[k] then
					if v5 and v5.patok then
						local function fn23()
							v5.patok:Destroy()
						end

						pcall(fn23)
					end

					esp2.kartu[k] = nil
				end
			end

			return
		end
	end

	steal.AA.ESP.Start = function()
		if tbl.FLAG.AdminAbuse then
			local esp2 = steal.AA.ESP
			if esp2.on then
				return true
			end
			esp2.on = true

			task.spawn(function()
				while esp2.on do
					if tbl.Alive then
						local ok, result = pcall(steal.AA.ESP.Denyut)

						if not ok then
							tbl.LOG.warn("AA.ESP", tostring(result))
						end

						task.wait(esp2.POLL)
						continue
					end

					break
				end
			end)

			tbl.LOG.info("AA.ESP", "rare egg ESP aktif")
			return true
		end

		return false
	end

	steal.AA.ESP.Stop = function()
		local esp2 = steal.AA.ESP
		if not esp2.on and not esp2.bin then
			return
		end
		esp2.on = false
		table.clear(esp2.kartu)

		if esp2.bin then
			pcall(function()
				esp2.bin:Destroy()
			end)

			esp2.bin = nil
			return
		end
	end

	local aa2 = steal.AA
	local ring = { on = false, cx = {}, wave = nil }
	ring.zona = "LightDark"
	ring.ring = {}
	ring.power = {}
	ring.LAJU = 280
	ring.SERAP = 38
	ring.Kutip = 0
	ring.Status = "idle"
	aa2.RING = ring

	local function fn23(arg)
		return tbl.NET.Get("LightVsDarkness", arg)
	end

	local function fn24()
		local attribute = localPlayer:GetAttribute("LvdTeam")
		if type(attribute) == "string" and attribute ~= "" then
			return
		end
		tbl.NET.Fire("LightVsDarkness", "AskSelectTeam", "Random")
	end

	local n3 = 0

	local function fn25()
		if not (os.clock() < n3) then
			n3 = os.clock() + 3.5

			for i = 1, 3 do
				tbl.NET.Fire("LightVsDarkness", "AskClaimMilestone", i)
			end

			return
		end
	end

	steal.AA.RING.Segar = function()
		local ring2 = steal.AA.RING
		local FetchRings = fn23("FetchRings")

		if FetchRings then
			local v4 = table.pack(pcall(FetchRings.InvokeServer, FetchRings))

			if v4[1] then
				if type(v4[2]) ~= "number" then
					return false
				end
				ring2.wave = v4[2]

				if type(v4[3]) == "string" then
					ring2.zona = v4[3]
				end

				if type(v4[4]) == "table" then
					ring2.ring = v4[4]
				end

				if type(v4[5]) ~= "table" then
					return true
				end
				ring2.power = v4[5]
				return true
			end

			return false
		end

		return false
	end

	local function fn26(arg)
		local ring2 = steal.AA.RING

		for k, v4 in pairs(ring2.power) do
			if type(v4) == "table" and v4.X and v4.Y and v4.Z then
				return Vector3.new(v4.X, v4.Y, v4.Z), "PowerUp", k
			end
		end

		local n4 = -math.huge
		local v4 = nil
		local v5 = nil

		for k, v6 in pairs(ring2.ring) do
			if type(v6) == "table" and v6.X and v6.Y and v6.Z then
				local vector = Vector3.new(v6.X, v6.Y, v6.Z)
				local n5 = (tonumber(v6.Rarity) or 1) * 350 - (vector - arg).Magnitude

				if n4 < n5 then
					n4 = n5
					v4 = k
					v5 = vector
				end
			end
		end

		if v4 then
			return v5, "Ring", v4
		end
		local lightVsDarknessRings = v:FindFirstChild("LightVsDarknessRings")

		if lightVsDarknessRings then
			local huge = math.huge
			local position = nil
			local name = nil

			for _, child in ipairs(lightVsDarknessRings:GetChildren()) do
				if child:IsA("BasePart") then
					local magnitude = (child.Position - arg).Magnitude

					if magnitude < huge then
						position = child.Position
						name = child.Name
						huge = magnitude
					end
				end
			end

			if position then
				return position, "Ring", name
			end
		end

		return nil
	end

	local function fn27(arg, arg2)
		local ring2 = steal.AA.RING

		if ring2.wave then
			if arg ~= "PowerUp" then
				tbl.NET.Fire("LightVsDarkness", "AskCollectRing", ring2.wave, ring2.zona, arg2)
				ring2.ring[arg2] = nil
			else
				tbl.NET.Fire("LightVsDarkness", "AskCollectPowerUp", ring2.wave, arg2)
				ring2.power[arg2] = nil
			end

			ring2.Kutip = ring2.Kutip + 1
			return
		end
	end

	steal.AA.RING.Start = function()
		if tbl.FLAG.AdminAbuse then
			local ring2 = steal.AA.RING
			if ring2.on then
				return true
			end
			ring2.on = true
			ring2.Kutip = 0
			steal.SpoofStart()

			for _, v4 in ipairs({ "RingsSpawned", "RingRespawned", "PowerUpsDropped", "PowerUpsSky" }) do
				local function fn28(wave, zona, arg, arg2)
					if type(wave) == "number" then
						ring2.wave = wave
					end

					if type(zona) == "string" then
						ring2.zona = zona
					end

					if type(arg) == "table" then
						for k, v5 in pairs(arg) do
							ring2.ring[k] = v5
						end
					end

					if type(arg2) ~= "table" then
						return
					end

					for k, v5 in pairs(arg2) do
						ring2.power[k] = v5
					end
				end

				local LightVsDarkness = tbl.NET.On("LightVsDarkness", v4, fn28)

				if LightVsDarkness then
					ring2.cx[#ring2.cx + 1] = LightVsDarkness
				end
			end

			for _, v4 in ipairs({ "RingsCleared", "PowerUpsCleared" }) do
				local function fn28()
					table.clear(ring2.ring)
					table.clear(ring2.power)
				end

				local LightVsDarkness = tbl.NET.On("LightVsDarkness", v4, fn28)

				if LightVsDarkness then
					ring2.cx[#ring2.cx + 1] = LightVsDarkness
				end
			end

			local function fn28()
				fn24()
				steal.AA.RING.Segar()

				while ring2.on do
					if tbl.Alive then
						if steal.Gerak() then
							ring2.Status = "waiting for steal engine"
							task.wait(0.5)
						else
							local v4, v5 = fn()

							if v4 and v5 and v5.Health > 0 then
								fn24()
								fn25()
								local v6, v7, v8 = fn26(v4.Position)

								if v6 then
									ring2.Status = ("heading to %s"):format(v7:lower())
									local now = os.clock()

									while ring2.on do
										if tbl.Alive then
											if os.clock() - now < 8 then
												local v9 = fn2()

												if v9 then
													if steal.Gerak() then
														break
													end
													local magnitude = (v6 - v9.Position).Magnitude

													if magnitude <= ring2.SERAP then
														fn27(v7, v8)
													end

													if not (magnitude <= 8) then
														local n4 = math.min(magnitude, ring2.LAJU * math.min(runService.Heartbeat:Wait(), 0.1))
														local unit = (v6 - v9.Position).Unit
														local n5 = v9.Position + unit * n4
														steal.Tulis(v9, CFrame.new(n5, n5 + unit), false)
														continue
													end

													break
												end

												break
											end

											break
										end

										break
									end

									fn27(v7, v8)
								else
									ring2.Status = "no ring - refreshing"
									steal.AA.RING.Segar()
									task.wait(1.5)
								end
							else
								ring2.Status = "waiting for character"
								task.wait(0.5)
							end
						end

						continue
					end

					break
				end

				ring2.Status = "idle"
				if steal.Running then
					return
				end
				steal.SpoofStop()
			end

			task.spawn(fn28)
			tbl.LOG.info("AA.RING", "auto collect rings aktif")
			return true
		end

		return false
	end

	steal.AA.RING.Stop = function()
		local ring2 = steal.AA.RING

		if ring2.on then
			ring2.on = false

			for _, v4 in ipairs(ring2.cx) do
				pcall(function()
					v4:Disconnect()
				end)
			end

			ring2.cx = {}
			table.clear(ring2.ring)
			table.clear(ring2.power)
			local v4 = fn2()
			if v4 then
				v4.AssemblyLinearVelocity = Vector3.zero
				return
			end
			return
		end
	end

	steal.AA.CTE = {
		on = false,
		Status = "Off",
		Sasaran = "--",
		TINGGI = 45,
		TANAH = 71,
		cx = {},
		Ambil = 0,
		Ayun = 0,
	}

	local str2 = nil

	local function fn28()
		if str2 then
			return str2
		end
		str2 = "Event_CaptureTheEggUid"
		local data = tbl.SV.ReplicatedStorage:FindFirstChild("Data")
		local captureTheEgg = data and data:FindFirstChild("CaptureTheEgg")

		if captureTheEgg then
			local ok, result = pcall(require, captureTheEgg)

			if ok and type(result) == "table" and type(result.EggUidAttribute) == "string" then
				str2 = result.EggUidAttribute
			end
		end

		return str2
	end

	local function aktif()
		local attribute = v:GetAttribute(fn28())
		local flag2 = v:GetAttribute("Event_CaptureTheEgg") == true

		if not flag2 then
			flag2 = v:GetAttribute("Event_CaptureTheEggGameplay") == true

			if not flag2 then
				flag2 = attribute ~= nil
				if flag2 then
					return tostring(attribute) ~= ""
				end
			end
		end

		return flag2
	end

	local cte = steal.AA.CTE
	cte.Aktif = aktif

	steal.AA.CTE.Uid = function()
		local attribute = v:GetAttribute(fn28())

		if attribute ~= nil then
			if tostring(attribute) ~= "" then
				return tostring(attribute)
			end
			return nil
		end

		return nil
	end

	steal.AA.CTE.Rec = function(arg)
		if arg then
			for _, v4 in pairs(steal.FieldRecords()) do
				if tostring(v4.Uid) == arg then
					return v4
				end
			end

			return nil
		end

		return nil
	end

	local function fn29(arg)
		local v4 = steal.HeldUid()

		if v4 then
			if arg then
				return v4 == arg
			end
			return true
		end

		return false
	end

	steal.AA.CTE.Start = function()
		if tbl.FLAG.AdminAbuse then
			local cte2 = steal.AA.CTE
			if cte2.on then
				return true
			end
			cte2.on = true
			cte2.Status = "waiting for event"
			steal.SpoofStart()

			for _, v4 in ipairs({ "Event_CaptureTheEgg", "Event_CaptureTheEggGameplay", fn28() }) do
				cte2.cx[#cte2.cx + 1] = v:GetAttributeChangedSignal(v4):Connect(function()
					if cte2.on and cte2.Aktif() then
						cte2.Status = "event started"
						return
					end
				end)
			end

			task.spawn(function()
				local n4

				while cte2.on do
					if tbl.Alive then
						if cte2.Aktif() then
							if steal.Gerak() then
								cte2.Status = "waiting for Auto Steal"
								task.wait(0.4)
							else
								local v4, v5 = fn()

								if v4 and v5 and v5.Health > 0 then
									local v6 = cte2.Uid()

									if fn29(v6) then
										cte2.Status = "holding egg - hovering"
										cte2.Sasaran = ("+%d stud"):format(cte2.TINGGI)
										local vector = Vector3.new(v4.Position.X, math.max(v4.Position.Y, cte2.TANAH) + cte2.TINGGI, v4.Position.Z)
										steal.PadStart()
										local now = os.clock()

										while cte2.on do
											if tbl.Alive then
												if os.clock() - now < 0.5 then
													local v7 = fn2()

													if v7 then
														if steal.Gerak() then
															break
														end
														steal.Tulis(v7, CFrame.new(vector), false)
														runService.Heartbeat:Wait()
														continue
													end

													break
												end

												break
											end

											break
										end
									else
										if steal.Pad() then
											pcall(steal.PadStop)
										end

										local v7 = cte2.Rec(v6)
										local num = v7 and tonumber(v7.CarrierUserId)

										if num and num ~= localPlayer.UserId then
											local playerByUserId = tbl.SV.Players:GetPlayerByUserId(num)
											local character = playerByUserId and playerByUserId.Character
											local humanoidRootPart = character and character:FindFirstChild("HumanoidRootPart")

											if humanoidRootPart then
												cte2.Status = "chasing carrier"
												cte2.Sasaran = playerByUserId.DisplayName or playerByUserId.Name
												local magnitude = (humanoidRootPart.Position - v4.Position).Magnitude

												if not (steal.GOD.Range() * 0.6 < magnitude) then
													steal.Tulis(v4, CFrame.new(humanoidRootPart.Position + Vector3.new(0, 2, 0), humanoidRootPart.Position), false)
													local v8, v9 = steal.GOD.Ayun(playerByUserId)

													if v8 then
														cte2.Ayun = cte2.Ayun + 1
													end

													task.wait(v9 or steal.GOD.CD or 0.6)
												else
													steal.GlideRetry(humanoidRootPart.Position + Vector3.new(0, 2, 0), 8, 1)
												end
											else
												cte2.Status = "carrier respawning"
												cte2.Sasaran = playerByUserId and playerByUserId.Name or tostring(num)
												task.wait(0.3)
											end
										else
											cte2.Status = "securing egg"

											if v7 and typeof(v7.BottomCFrame) == "CFrame" then
												n4 = v7.BottomCFrame.Position + Vector3.new(0, 3, 0)
											else
												local captureTheEggSpawn = v:FindFirstChild("CaptureTheEggSpawn", true) or v:FindFirstChild("AdminAbuseEggSpawn", true)

												if captureTheEggSpawn and captureTheEggSpawn:IsA("BasePart") then
													n4 = captureTheEggSpawn.Position + Vector3.new(0, 3, 0)
													cte2.Sasaran = ("%d, %d, %d"):format(n4.X, n4.Y, n4.Z)

													if not ((n4 - v4.Position).Magnitude > 8) then
														if v6 then
															if steal.Carry(v6, n4, 4) then
																cte2.Ambil = cte2.Ambil + 1
																tbl.LOG.warn("CTE", "telur event terangkat")
															end
														else
															task.wait(0.3)
														end
													else
														steal.GlideRetry(n4, 20, 2)
													end
												else
													cte2.Sasaran = "egg position unknown"
													task.wait(0.5)
												end

												continue
											end

											cte2.Sasaran = ("%d, %d, %d"):format(n4.X, n4.Y, n4.Z)

											if not ((n4 - v4.Position).Magnitude > 8) then
												if v6 then
													if steal.Carry(v6, n4, 4) then
														cte2.Ambil = cte2.Ambil + 1
														tbl.LOG.warn("CTE", "telur event terangkat")
														continue
													else
														continue
													end
												else
													task.wait(0.3)
													continue
												end
											else
												steal.GlideRetry(n4, 20, 2)
												continue
											end
										end
									end
								else
									cte2.Status = "waiting for character"
									task.wait(0.5)
								end
							end
						else
							cte2.Status = "waiting for event"
							cte2.Sasaran = "--"
							task.wait(1)
						end

						continue
					end

					break
				end

				cte2.Status = "Off"
				cte2.Sasaran = "--"
				if steal.Running then
					return
				end

				if steal.Pad() then
					pcall(steal.PadStop)
				end

				steal.SpoofStop()
			end)

			tbl.LOG.info("CTE", "auto capture the egg aktif")
			return true
		end

		return false
	end
end

steal.AA.CTE.Stop = function()
	local cte = steal.AA.CTE

	if cte.on then
		cte.on = false

		for _, v4 in ipairs(cte.cx) do
			pcall(function()
				v4:Disconnect()
			end)
		end

		cte.cx = {}
		cte.Status = "Off"
		cte.Sasaran = "--"
		return
	end
end

if not tbl.FLAG.AdminAbuse then
	steal.INSTANT.on = false
	pcall(steal.AA.ESP.Stop)
	pcall(steal.AA.RING.Stop)
	pcall(steal.AA.CTE.Stop)
	tbl.LOG.info("AA", "AdminAbuse=false -- mesin Admin Abuse dipadamkan")
end

tbl.ST.Trove:Add(function()
	pcall(steal.AA.ESP.Stop)
	pcall(steal.AA.RING.Stop)
	pcall(steal.AA.CTE.Stop)
end)

steal.RACE = {}
local race
race = steal.RACE
race.on = false
race.LAJU_BALAP = 260
race.SAMPAI = 18
race.ATAS = 3
race.SIKLUS = 1800
race.LAP_BAWAAN = 3
race.SABAR_LAP = 180
race.BERKAS = "SAE_New/race_jadwal.txt"
race.Status = "idle"
race.Fase = nil
race.Terakhir = nil
local collectionService
collectionService = tbl.SV.CollectionService or game:GetService("CollectionService")

race.Track = function()
	local raceTrack = v:FindFirstChild("RaceTrack")
	if raceTrack then
		return raceTrack
	end
	return collectionService:GetTagged("RaceTrack")[1]
end

race.Ada = function()
	return race.Track() ~= nil
end

race.LineUp = function()
	local v4 = race.Track()
	if v4 then
		return (v4:FindFirstChild("PlayerLineUpArea"))
	end
	return v4
end

do
	local v4 = nil
	local n3 = 0

	race.Jalur = function()
		if v4 and os.clock() - n3 < 30 then
			return v4
		end
		local v5 = race.Track()
		local attachmentTrack = v5 and v5:FindFirstChild("AttachmentTrack")

		if attachmentTrack then
			local tbl2 = {}

			for _, child in ipairs(attachmentTrack:GetChildren()) do
				local num = tonumber(child.Name)

				if num and child:IsA("Attachment") then
					tbl2[#tbl2 + 1] = { n = num, pos = child.WorldPosition }
				end
			end

			if #tbl2 ~= 0 then
				table.sort(tbl2, function(arg, arg2)
					return arg.n < arg2.n
				end)

				local now = os.clock()
				v4 = tbl2
				n3 = now
				return tbl2
			end

			return nil
		end

		return nil
	end
end

race.Laps = function()
	local heatKita = race.HeatKita and race.HeatKita()
	local num, v4

	if heatKita then
		num = tonumber(heatKita:GetAttribute("RaceLaps"))

		if not num then
			v4 = race.Track()
			num = v4 and tonumber(v4:GetAttribute("RaceLaps"))
		end
	else
		v4 = race.Track()
		num = v4 and tonumber(v4:GetAttribute("RaceLaps"))
	end

	if num then
		return (math.max(1, math.floor(num)))
	end
	return race.LAP_BAWAAN
end

race.Ikut = function()
	if localPlayer:GetAttribute("RaceId") ~= nil then
		if localPlayer:GetAttribute("RaceFinishPlace") ~= nil then
			return false
		end
		local fase = race.Fase

		if fase ~= nil then
			if fase ~= "Results" then
				return true
			end
			return false
		end

		return false
	end

	return false
end

do
	local function fn21()
		pcall(function()
			if type(writefile) ~= "function" then
				return
			end
			writefile(race.BERKAS, tostring(race.Terakhir or 0))
		end)
	end

	local function fn22()
		local v4 = pcall

		local function fn23()
			if type(isfile) ~= "function" then
				return
			end

			if isfile(race.BERKAS) then
				local terakhir = tonumber(readfile(race.BERKAS))
				if terakhir and terakhir > 0 then
					race.Terakhir = terakhir
					return
				end
				return
			end
		end

		v4(fn23)
	end

	fn22()
	local RaceRallySchedule = nil
	local RaceRallyFlags = nil
	local replicatedStorage = tbl.SV.ReplicatedStorage

	pcall(function()
		RaceRallySchedule = require(replicatedStorage.Shared.Util.RaceRallySchedule)
	end)

	pcall(function()
		RaceRallyFlags = require(replicatedStorage.Shared.Flags.RaceRallyFlags)
	end)

	race.Sch = RaceRallySchedule
	race.Flg = RaceRallyFlags

	local function bendera(arg, arg2)
		if RaceRallyFlags then
			if RaceRallyFlags[arg] then
				local ok, result = pcall(function()
					return RaceRallyFlags[arg]:Get()
				end)

				if ok then
					if result then
						return result
					end
					return arg2
				end

				return arg2
			end

			return arg2
		end

		return arg2
	end

	race.Bendera = bendera

	race.Terjadwal = function()
		if RaceRallySchedule then
			local ok, result = pcall(RaceRallySchedule.IsScheduled)
			if ok and result then
				return result
			end
			return nil
		end

		return nil
	end

	race.Jadwal = function()
		if RaceRallySchedule then
			local now = os.time()
			local ok, result, result2 = pcall(RaceRallySchedule.NextOpening, now)

			if ok then
				if type(result) ~= "number" then
					return nil
				end
				return result - now, (result2 or result) - now
			end

			return nil
		end

		return nil
	end

	race.JendelaBuka = function()
		local v4, v5 = race.Jadwal()

		if v4 then
			if v4 <= 0 and v5 and v5 > 0 then
				return v5
			end
			return nil
		end

		return nil
	end

	race.Berikut = function()
		if race.Fase and race.Fase ~= "" then
			return 0
		end
		local v4 = race.Jadwal()
		if v4 then
			return math.max(0, v4)
		end

		if race.Terakhir then
			return race.SIKLUS - (os.time() - race.Terakhir) % race.SIKLUS
		end
		return nil
	end

	race.Speed = function()
		local leaderstats = localPlayer:FindFirstChild("leaderstats")
		local speed = leaderstats and leaderstats:FindFirstChild("Speed")

		if speed then
			local num = tonumber(speed.Value)
			if num then
				return num
			end
		end

		return nil
	end

	race.Boleh = function()
		local n3 = tonumber(bendera("SpeedPowerRequirement", 2500000)) or 2500000
		local v4 = race.Speed()
		if v4 then
			return v4 >= n3, n3, v4
		end
		return nil, n3
	end

	race.Jam = function(arg)
		if arg ~= nil then
			local n3 = math.max(0, math.floor(arg))
			return ("%dm %02ds"):format(n3 // 60, n3 % 60)
		end
		return "unknown"
	end

	local tbl2 = {}
	local tbl3 = {}

	local function fn23()
		for _, v4 in ipairs(tbl2) do
			pcall(function()
				v4:Disconnect()
			end)
		end

		tbl2 = {}
	end

	local function turunkanFase()
		local v4 = workspace
		local localPlayer2 = tbl.SV.Players.LocalPlayer
		local attribute = v4:GetAttribute("RaceRallyWindow")
		if localPlayer2:GetAttribute("RaceFinishPlace") ~= nil then
			return "Results"
		end

		if v4:GetAttribute("RaceRallyRunning") ~= true then
			return nil
		end

		if localPlayer2:GetAttribute("RaceId") ~= nil then
			local mountCtl = race.mountCtl or select(2, pcall(race.MountCtl))

			if mountCtl and mountCtl.IsHeld then
				local ok, result = pcall(mountCtl.IsHeld, mountCtl)

				if ok and type(result) == "boolean" then
					if result ~= false then
						if attribute ~= nil then
							if race.pernahRacing ~= attribute then
								return "Joining"
							end
							return "Racing"
						end

						return "Joining"
					end

					race.pernahRacing = attribute
					return "Racing"
				end
			end

			return "Joining"
		end

		if attribute ~= nil and race.windowSelesai == attribute then
			return nil
		end

		if race.PortalHitbox() ~= nil then
			return "Joining"
		end
		return nil
	end

	race.TurunkanFase = turunkanFase

	race.HeatKita = function()
		local v4 = race.Track()
		local raceHeats = v4 and v4:FindFirstChild("RaceHeats")

		if raceHeats then
			local attribute = localPlayer:GetAttribute("RaceHeat")
			if attribute ~= nil then
				return raceHeats:FindFirstChild(tostring(attribute))
			end
			return nil
		end

		return nil
	end

	local function fn24()
		local attribute = v:GetAttribute("RaceRallyWindow")

		if attribute ~= nil then
			if localPlayer:GetAttribute("RaceId") ~= nil then
				race.windowIkut = attribute
				return
			end

			if race.windowIkut ~= nil then
				if attribute ~= race.windowIkut then
					return
				end

				if race.windowSelesai ~= attribute then
					race.windowSelesai = attribute
					tbl.LOG.info("RACE", ("ronde di jendela %s sudah dijalani - tidak mendaftar lagi"):format(tostring(attribute)))
					return
				end

				return
			end

			return
		end
	end

	local function bacaFase()
		fn24()
		local v4 = race.HeatKita()
		local fase = nil

		if v4 then
			local attribute = v4:GetAttribute("RacePhase")

			if attribute ~= nil and tostring(attribute) ~= "" then
				fase = tostring(attribute)
			end
		end

		if fase == nil then
			local v5 = race.Track()
			local attribute = v5 and v5:GetAttribute("RacePhase")
			fase = if attribute ~= nil and tostring(attribute) ~= "" then tostring(attribute) else nil
		end

		if fase == nil then
			local ok, result = pcall(turunkanFase)

			if ok then
				fase = result
			end
		end

		if fase ~= race.Fase then
			race.Fase = fase

			if fase then
				race.Terakhir = os.time()
				fn21()
				tbl.LOG.info("RACE", "fase -> " .. fase)
				if tbl.UIX and tbl.UIX.Pita and fase == "Joining" then
					tbl.UIX.Pita("Race Rally is open - joining phase has started.", 6)
					return fase
				end
				return fase
			end

			tbl.LOG.info("RACE", "balapan selesai")
			return fase
		end

		return fase
	end

	race.BacaFase = bacaFase

	race.LastRacedWindow = function()
		local ok, result = pcall(require, tbl.SV.ReplicatedStorage.Shared.Save)

		if ok then
			local ok2, result2 = pcall(result.Peek, localPlayer)

			if ok2 then
				if type(result2) ~= "table" then
					return nil
				end
				local fn25

				fn25 = function(arg, arg2)
					if type(arg) ~= "table" then
						return nil
					end

					for k, v4 in pairs(arg) do
						if tostring(k) ~= "LastRacedWindow" then
							if type(v4) ~= "table" then
								continue
							end
							local v5 = fn25(v4, arg2 + 1)
							if v5 ~= nil then
								return v5
							end
							continue
						end

						return v4
					end
				end

				return fn25(result2, 1)
			end

			return nil
		end

		return nil
	end

	local function rondeLewat()
		local attribute = workspace:GetAttribute("RaceRallyWindow")
		if attribute ~= nil then
			return race.windowSelesai == attribute
		end
		return false
	end

	race.RondeLewat = rondeLewat
	race.JEJAK = "SAE_New/logs/race_jejak.log"
	local n3 = 0

	race.Catat = function(arg)
		n3 += 1

		if not (n3 > 400) then
			pcall(function()
				if type(appendfile) ~= "function" then
					return
				end
				local v4 = tostring
				local str2 = ("[%s] %s\n"):format(os.date("!%H:%M:%S"), v4(arg))
				if type(isfile) == "function" and not isfile(race.JEJAK) and type(writefile) == "function" then
					writefile(race.JEJAK, str2)
					return
				end
				appendfile(race.JEJAK, str2)
			end)

			return
		end
	end

	tbl3[#tbl3 + 1] = v.DescendantAdded:Connect(function(descendant)
		if descendant.Name ~= "RaceRallyPortal" then
			return
		end
		local v4 = race
		race.portalCache = descendant
		v4.portalCacheAt = 0

		task.defer(function()
			local v5 = race.Track()
			race.Catat(("PORTAL LAHIR | fase=%s | mesin.on=%s | ikut=%s"):format(tostring(v5 and v5:GetAttribute("RacePhase")), tostring(race.on), tostring(race.Ikut())))
		end)
	end)

	tbl3[#tbl3 + 1] = v.DescendantRemoving:Connect(function(descendant)
		if descendant.Name ~= "RaceRallyPortal" then
			return
		end
		race.Catat(("PORTAL HILANG | fase=%s | ikut=%s"):format(tostring(race.Fase), tostring(race.Ikut())))
	end)

	race.PasangSinyal = function()
		fn23()
		local v4 = race.Track()

		if v4 then
			for _, v5 in ipairs({ "RacePhase", "RaceJoinEndsAt", "RaceGoAt", "RaceEndsAt" }) do
				tbl2[#tbl2 + 1] = v4:GetAttributeChangedSignal(v5):Connect(bacaFase)
			end

			bacaFase()
			return true
		end

		return false
	end

	tbl3[#tbl3 + 1] = v.ChildAdded:Connect(function(child)
		if child.Name ~= "RaceTrack" then
			return
		end
		task.wait(0.2)
		race.PasangSinyal()
	end)

	for _, v4 in ipairs({ "RaceRallyRunning", "RaceRallyJoinEndsAt" }) do
		tbl3[#tbl3 + 1] = v:GetAttributeChangedSignal(v4):Connect(function()
			pcall(bacaFase)
		end)
	end

	for _, v4 in ipairs({ "RaceId", "RaceFinishPlace" }) do
		tbl3[#tbl3 + 1] = localPlayer:GetAttributeChangedSignal(v4):Connect(function()
			pcall(bacaFase)
		end)
	end

	task.spawn(function()
		while tbl.Alive do
			local flag2 = false

			if race.on then
				flag2 = pcall(bacaFase) and race.HeatKita() ~= nil
			end

			task.wait(flag2 and 0.4 or 2)
		end
	end)

	race.PasangSinyal()

	tbl.ST.Trove:Add(function()
		race.on = false
		fn23()

		for _, v4 in ipairs(tbl3) do
			pcall(function()
				v4:Disconnect()
			end)
		end

		tbl3 = {}
	end)

	race.KLAIM_MAKS = 45
end

race.klaimAt = 0

race.Klaim = function()
	race.klaimAt = os.clock()
end

race.Lepas = function()
	race.klaimAt = 0
end

race.Aktif = function()
	if race.Fase ~= nil then
		return true
	end
	return race.PortalHitbox() ~= nil
end

race.Punya = function()
	if race.on then
		if race.Ikut() then
			return true
		end
		local klaimAt = race.klaimAt
		local flag2 = klaimAt > 0
		if flag2 then
			return os.clock() - klaimAt < race.KLAIM_MAKS
		end
		return flag2
	end

	return false
end

race.Sibuk = function()
	if race.on then
		if race.Aktif() then
			if race.Punya() then
				return true
			end
			return race.PortalHitbox() ~= nil
		end

		return false
	end

	return false
end

race.MODE = "Rail"
race.RAIL_SKALA = 2
race.LAJU_RAIL = 140
race.LAJU_MIN = 60
race.LAJU_MAKS = 155
race.RAIL_TINGGI = 2.5
race.ANTI_STUN = true
race.RAIL_MACET = 1.2
race.RAIL_DEKAT = 150
race.RAIL_TALI_DETIK = 0.3
race.RAIL_TALI_MIN = 60

race.Tali = function()
	return math.max(race.RAIL_TALI_MIN, (tonumber(race.railLaju) or tonumber(race.LAJU_RAIL) or 270) * race.RAIL_TALI_DETIK)
end

race.PULANG_MAKS = 20
race.finisAt = nil
race.GAGAL_MAKS = 3
race.gagalWindow = nil
race.gagalBeruntun = 0
race.RAIL_LOMPAT = 90
race.LAJU_PORTAL = 250

race.Path = function()
	local v4 = race.Track()
	local attachmentTrack = v4 and v4:FindFirstChild("AttachmentTrack")

	if attachmentTrack then
		if not race.path then
			local ok, result = pcall(require, tbl.SV.ReplicatedStorage.Shared.Modules.RaceTrackPath)
			if not ok then
				return nil
			end
			local ok2, path = pcall(result.new, attachmentTrack)
			local v5 = race

			if not ok2 or not path then
				path = nil
			end

			v5.path = path
		end

		return race.path
	end

	race.path = nil
	return nil
end

local fn21

do
	fn21 = function(arg, arg2)
		local v4, v5, v6 = ipairs(arg.Points or {})
		local huge = math.huge
		local n3 = 0

		for k, v7 in v4, v5, v6 do
			local magnitude = (v7 - arg2).Magnitude

			if magnitude < huge then
				n3 = arg.Starts and arg.Starts[k]

				if n3 then
					huge = magnitude
				else
					n3 = 0
					huge = magnitude
				end
			end
		end

		return n3
	end

	race.MountCtl = function()
		local mountCtl = race.mountCtl
		if mountCtl and typeof(mountCtl.Drive) == "Instance" and mountCtl.Drive.Parent then
			return mountCtl
		end
		race.mountCtl = nil
		if type(filtergc) ~= "function" then
			return nil
		end
		local ok, result = pcall(filtergc, "table", { Keys = { "Holds", "Drive", "Align", "Push", "Heading", "TravelDirection" } }, false)

		if ok and type(result) == "table" then
			for _, candidate in ipairs(result) do
				if type(candidate) == "table" and typeof(candidate.Drive) == "Instance" and candidate.Drive.Parent then
					race.mountCtl = candidate
					return candidate
				end
			end
		end

		return race.mountCtl
	end

	local function skywhaleAktif()
		local ok, result = pcall(require, tbl.SV.ReplicatedStorage.Data.RacePowerUps)
		local attributes

		if ok and type(result) == "table" then
			attributes = result.Attributes or {}
		else
			attributes = {}
		end

		local attribute = localPlayer:GetAttribute(attributes.Effect or "RacePowerUpEffect")
		local attribute2 = localPlayer:GetAttribute(attributes.EffectEndsAt or "RacePowerUpEffectEndsAt")
		local flag2 = attribute == "Skywhale"

		if flag2 then
			local kind = type(attribute2)

			if attribute ~= "0" then
				flag2 = kind == "number"
				if not flag2 then
					return flag2
				end
			end

			return workspace:GetServerTimeNow() < attribute2 + 0.5
		end

		return flag2
	end

	race.SkywhaleAktif = skywhaleAktif
end

race.RailStep = function(arg, arg2)
	local v4 = race.Path()
	local root = arg.Rig and arg.Rig.Root
	if not v4 or not root then
		return
	end

	if arg.IsHeld and arg:IsHeld() then
		arg.Override = nil
		local v5 = race
		local v6 = race
		race.railDist = nil
		v5.railAcu = nil
		v6.railAcuAt = nil
		return
	end

	local ok, result = pcall(require, tbl.SV.ReplicatedStorage.Shared.Flags.MountRaceFlags)
	local n3 = 135

	if ok and result and result.TopSpeed then
		local function fn22()
			return result.TopSpeed:Get()
		end

		local ok2, result2 = pcall(fn22)

		if ok2 and tonumber(result2) then
			n3 = tonumber(result2)
		end
	end

	if not race.railDist then
		local function fn22(arg3)
			local ok2, result2 = pcall(v4.FrameAt, v4, arg3)

			if ok2 then
				if result2 then
					return (result2.Position - root.Position).Magnitude
				end
				return math.huge
			end

			return math.huge
		end

		local n4 = v4.Length * 0.5
		local ok2, result2 = pcall(v4.Project, v4, root.Position, n4, n4, n4)
		local v5 = nil

		if ok2 and type(result2) == "number" then
			v5 = result2
		end

		local v6 = fn21(v4, root.Position)

		if v5 and not (fn22(v6) < fn22(v5)) then
			v6 = v5
		end

		if not v6 then
			race.Status = "waiting to land on track"
			return
		end

		if race.RAIL_DEKAT < fn22(v6) then
			race.Status = "waiting to land on track"
			return
		end
		race.railDist = v6 % v4.Length
		race.railLaju = math.max(tonumber(arg.Speed) or 0, n3 * 0.5)
	end

	if not ((v4:FrameAt(race.railDist).Position - root.Position).Magnitude > 45) then
		race.railAcu = race.railAcu or race.railDist

		if not (race.railAcu + 10 < race.railDist) then
			race.railAcuAt = race.railAcuAt or os.clock()

			if race.RAIL_MACET < os.clock() - race.railAcuAt then
				local function fn22(arg3)
					if v4.Respawnable then
						if v4.Locate then
							if v4.Count then
								local ok2, result2 = pcall(v4.Locate, v4, arg3)

								if ok2 then
									if result2 then
										if v4.Respawnable[result2] then
											return nil
										end
										local n4 = math.floor(arg3 / v4.Length) * v4.Length

										for i = 1, v4.Count do
											result2 += 1

											if v4.Count < result2 then
												n4 += v4.Length
												result2 = 1
											end

											if v4.Respawnable[result2] then
												return n4 + v4.Starts[result2] + 5
											end
										end

										return nil
									end

									return nil
								end

								return nil
							end

							return nil
						end

						return nil
					end

					return nil
				end

				local railDist = race.railAcu + race.RAIL_LOMPAT
				local v5 = fn22(railDist)

				if v5 and race.railDist < v5 then
					tbl.LOG.warn("RACE", ("petak terlarang di d=%d - dilewati ke d=%d"):format(math.floor(railDist), math.floor(v5)))
					race.railDist = v5
				else
					local ok2, result2, result3 = pcall(v4.RespawnAt, v4, railDist)

					if ok2 then
						local railDist2 = tonumber(result3)

						if railDist2 then
							if typeof(result2) ~= "CFrame" then
								race.railDist = railDist
							elseif not (race.railDist < railDist2) then
								race.railDist = railDist
							else
								race.railDist = railDist2
							end
						else
							race.railDist = railDist
						end
					else
						race.railDist = railDist
					end
				end

				local v6 = race
				local v7 = race
				local railDist2 = race.railDist
				local now = os.clock()
				v6.railAcu = railDist2
				v7.railAcuAt = now
				local v8 = v4:FrameAt(race.railDist)
				root.CFrame = CFrame.new(v8.Position + v8.UpVector * race.RAIL_TINGGI)
				root.AssemblyLinearVelocity = Vector3.zero
				root.AssemblyAngularVelocity = Vector3.zero
				race.railLewat = (race.railLewat or 0) + 1
				tbl.LOG.warn("RACE", ("rail tertahan di d=%d - diseberangkan %d stud (%d kali)"):format(math.floor(race.railDist - race.RAIL_LOMPAT), race.RAIL_LOMPAT, race.railLewat))
			end
		else
			local v5 = race
			local v6 = race
			local railDist = race.railDist
			local now = os.clock()
			v5.railAcu = railDist
			v6.railAcuAt = now
		end

		local n4

		if tonumber(race.LAJU_RAIL) then
			n4 = math.max(0.25, race.LAJU_RAIL / math.max(n3, 1))
		else
			n4 = race.railSkala or race.RAIL_SKALA
		end

		local v5 = if os.clock() < (tonumber(arg.BoostUntil) or 0) then math.max(n4, tonumber(arg.BoostScale) or 1) else n4
		race.railLaju = race.railLaju + (n3 * v5 - race.railLaju) * math.min(1, arg2 * 1.5)
		local n5 = race.railLaju * arg2

		if n5 > 0 then
			local railDist = race.railDist + n5
			local v6 = v4:FrameAt(railDist)

			if (v6.Position + v6.UpVector * race.RAIL_TINGGI - root.Position).Magnitude <= race.Tali() then
				race.railDist = railDist
			end
		end

		local v6 = v4:FrameAt(race.railDist)
		local v7 = v4:FrameAt(race.railDist + 20)
		local upVector = v6.UpVector
		local n6 = v6.Position + upVector * race.RAIL_TINGGI
		local n7 = v7.Position + upVector * race.RAIL_TINGGI - n6
		local unit = n7.Magnitude > 0.001 and n7.Unit or v6.LookVector
		root.AssemblyLinearVelocity = unit * race.railLaju + (n6 - root.Position) * 9
		root.AssemblyAngularVelocity = Vector3.zero
		arg.Drive.Enabled = false
		arg.Push.Force = Vector3.new(0, 1, 0) * root.AssemblyMass * workspace.Gravity
		arg.Align.CFrame = CFrame.lookAt(Vector3.zero, unit, upVector)
		root.CFrame = CFrame.new(root.Position) * arg.Align.CFrame
		arg.Up = upVector
		arg.Heading = unit
		arg.TravelDirection = unit
		arg.Speed = race.railLaju
		arg.Grounded = false
		arg.AirSeconds = 0
		arg.Launched = true
		local attribute = localPlayer:GetAttribute("RaceBoardPlace")
		race.Status = ("racing - rail x%.2f, %d studs/s, lap %s%s"):format(v5, math.floor(race.railLaju), tostring(localPlayer:GetAttribute("RaceLap")), if attribute then ", place " .. tostring(attribute) else "")
		return
	end

	tbl.LOG.warn("RACE", "rail state incomplete; skipping unsafe rail override")
	return false
end

race.RailOverride = function(arg, arg2)
	local ok, result = pcall(race.RailStep, arg, arg2)
	if ok then
		return
	end
	arg.Override = nil
	tbl.LOG.warn("RACE", "rail galat: " .. tostring(result))
end

race.Watch = function()
	local v4 = race.MountCtl()

	if v4 then
		local flag2 = race.MODE == "Rail"
		local override = v4.Override

		if override ~= nil and override ~= race.RailOverride then
			if not race.SkywhaleAktif() and race.ANTI_STUN then
				v4.Override = nil
				v4.Heading = race.headingAkhir or v4.Heading
				v4.TravelDirection = race.headingAkhir or v4.TravelDirection
				v4.Speed = math.max(tonumber(race.lajuAkhir) or 0, tonumber(v4.Speed) or 0)
				race.stunDitahan = (race.stunDitahan or 0) + 1
			end

			race.railDist = nil
			return
		end

		if flag2 then
			if override == nil and (not v4.IsHeld or not v4:IsHeld()) then
				v4.Override = race.RailOverride
			end
		elseif override == race.RailOverride then
			v4.Override = nil
		end

		local v5 = race
		local speed = v4.Speed
		local heading = v4.Heading
		race.lajuAkhir = speed
		v5.headingAkhir = heading
		return
	end
end

race.RailLepas = function()
	local mountCtl = race.mountCtl

	if mountCtl and mountCtl.Override == race.RailOverride then
		pcall(function()
			mountCtl.Override = nil
		end)
	end

	local v4 = race
	local v5 = race
	race.mountCtl = nil
	v4.railDist = nil
	v5.path = nil
end

race.AutoEquip = false
race.AutoBeli = false
race.AutoGoal = false
race.BeliPilih = {}
race.SisaToken = 0
race.ShopStatus = "idle"

race.RR = function()
	if race.rrCache then
		return race.rrCache
	end
	local ok, rrCache = pcall(require, tbl.SV.ReplicatedStorage.Data.RaceRally)
	local v4 = race

	if not ok or not rrCache then
		rrCache = nil
	end

	v4.rrCache = rrCache
	return race.rrCache
end

race.Profil = function()
	local ok, result = pcall(require, tbl.SV.ReplicatedStorage.Shared.Save)

	if ok then
		local ok2, result2 = pcall(result.Peek, localPlayer)
		if ok2 and type(result2) == "table" then
			return result2
		end
		return nil
	end

	return nil
end

race.RaceProfil = function()
	local v4 = race.Profil()
	local raceRally = v4 and v4.RaceRally
	if type(raceRally) == "table" and raceRally then
		return raceRally
	end
	return nil
end

local function fn22(arg, arg2)
	if type(arg) ~= "table" then
		return false
	end

	for _, v4 in ipairs(arg) do
		if v4 == arg2 then
			return true
		end
	end

	return arg[arg2] ~= nil
end

race.Token = function()
	local v4 = race.RaceProfil()

	if v4 then
		local num = tonumber(v4.Tokens)
		if num then
			return num
		end
	end

	return 0
end

race.RacerTerbaik = function()
	local v4 = race.RR()
	local v5 = race.RaceProfil()

	if v4 then
		if v5 then
			local defaultRacer = v4.DefaultRacer
			local ok, result = pcall(v4.OrderedRacers)

			if ok then
				local n3 = -math.huge

				for _, v6 in ipairs(result) do
					local flag2 = v6.Id == v4.DefaultRacer or fn22(v5.Racers, v6.Id)
					local n4 = tonumber(v6.Config and v6.Config.Order) or -math.huge

					if flag2 and n3 < n4 then
						defaultRacer = v6.Id
						n3 = n4
					end
				end

				return defaultRacer
			end

			return defaultRacer
		end

		return nil
	end

	return nil
end

race.EquipTerbaik = function()
	local v4 = race.RR()
	local v5 = race.RaceProfil()

	if v4 then
		if v5 then
			local equippedRacer = v4.ResolveRacer and select(2, pcall(v4.ResolveRacer, tostring(v5.EquippedRacer or ""), v5.Racers or {})) or v5.EquippedRacer
			local v6 = race.RacerTerbaik()
			if not v6 then
				return false, "sudah memakai yang terbaik"
			end

			if v6 ~= equippedRacer then
				local RaceRally = tbl.NET.Get("RaceRally", "AskEquipRacer")
				if not RaceRally then
					return false, "remote AskEquipRacer tidak ada"
				end

				local function fn23()
					return RaceRally:InvokeServer(v6)
				end

				local ok, result, result2 = pcall(fn23)
				if not ok or result == false then
					return false, tostring(result2 or result)
				end
				local displayName

				if v4.Racers then
					if v4.Racers[v6] then
						displayName = v4.Racers[v6].DisplayName or v6
					else
						displayName = v6
					end
				else
					displayName = v6
				end

				race.ShopStatus = "equipped " .. tostring(displayName)
				return true
			end

			return false, "sudah memakai yang terbaik"
		end

		return false, "data RaceRally belum siap"
	end

	return false, "data RaceRally belum siap"
end

race.KlaimGoal = function()
	local v4 = race.RR()
	local v5 = race.RaceProfil()
	if not v4 or not v5 then
		return false, "data RaceRally belum siap"
	end
	local RaceRally = tbl.NET.Get("RaceRally", "AskClaimMilestone")
	if not RaceRally then
		return false, "remote AskClaimMilestone tidak ada"
	end
	local n3 = tonumber(v5.Wins) or 0
	local ok, result = pcall(v4.OrderedMilestones)

	if ok and type(result) == "table" then
		for _, v6 in ipairs(result) do
			local num = tonumber(v6.Config and v6.Config.Wins)
			local fn23, ok2, result2, result3

			if num then
				if num <= n3 and not fn22(v5.Milestones, v6.Id) then
					fn23 = function()
						return RaceRally:InvokeServer(v6.Id)
					end

					ok2, result2, result3 = pcall(fn23)
					if ok2 and result2 ~= false then
						race.ShopStatus = "claimed goal " .. tostring(v6.Id)
						return true
					end
					return false, tostring(result3 or result2)
				end
			elseif n3 >= math.huge then
				if fn22(v5.Milestones, v6.Id) then
					continue
				else
					fn23 = function()
						return RaceRally:InvokeServer(v6.Id)
					end

					ok2, result2, result3 = pcall(fn23)

					if ok2 and result2 ~= false then
						race.ShopStatus = "claimed goal " .. tostring(v6.Id)
						return true
					else
						return false, tostring(result3 or result2)
					end
				end
			end
		end
	end

	if v4.RepeatsEarned then
		local ok2, result2 = pcall(v4.RepeatsEarned, n3)

		if ok2 then
			local n4 = tonumber(result2) or 0

			if (tonumber(v5.Repeats) or 0) < n4 then
				local function fn23()
					return RaceRally:InvokeServer(v4.RepeatId)
				end

				local ok3, result3 = pcall(fn23)
				if ok3 and result3 ~= false then
					race.ShopStatus = "claimed repeat reward"
					return true
				end
				return false, "tidak ada goal yang bisa diklaim"
			end
		end
	end

	return false, "tidak ada goal yang bisa diklaim"
end

race.Offers = function()
	local v4 = race.RR()

	if v4 then
		local ok, result = pcall(v4.OrderedOffers)

		if ok then
			if type(result) ~= "table" then
				return {}
			end
			local tbl2 = {}

			for _, v5 in ipairs(result) do
				tbl2[#tbl2 + 1] = {
					id = v5.Id,
					harga = tonumber(v5.Config and v5.Config.Price) or 0,
					batas = tonumber(v5.Config and v5.Config.Limit) or 0,
					ikon = race.IkonOffer(v5),
				}
			end

			return tbl2
		end

		return {}
	end

	return {}
end

race.IKON_REWARD = {
	SpeedBoost = "rbxassetid://128234882192727",
	CashBooster = "rbxassetid://81227277352414",
	TreadmillBoost = "rbxassetid://116351329433541",
	MutationConsumable = "rbxassetid://85288683002868",
}

race.IkonOffer = function(arg)
	local reward = arg.Config and arg.Config.Reward
	local v4 = race.IKON_REWARD[type(reward) ~= "table" and "" or tostring(reward.Kind or "")]
	if v4 then
		return v4
	end
	local v5 = race.RR()
	if v5 then
		return (tostring(v5.CurrencyIcon))
	end
	return ""
end

race.BELI_JEDA = 30
race.beliTolak = {}

race.Beli = function()
	local v4 = race.RR()
	local v5 = race.RaceProfil()

	if v4 then
		if v5 then
			if #race.BeliPilih ~= 0 then
				local RaceRally = tbl.NET.Get("RaceRally", "AskBuy")
				if not RaceRally then
					return false, "remote AskBuy tidak ada"
				end
				local n3 = tonumber(v5.Tokens) or 0
				local serverTimeNow = v:GetServerTimeNow()
				local ok, result = pcall(v4.OrderedOffers)

				if ok then
					local autoBuy = nil

					for _, v6 in ipairs(result) do
						if table.find(race.BeliPilih, v6.Id) and (race.beliTolak[v6.Id] or 0) <= os.clock() then
							local config = v6.Config or {}
							local n4 = 0

							if v4.PurchasedCount then
								local ok2, result2 = pcall(v4.PurchasedCount, v5.Purchases and v5.Purchases[v6.Id], config, serverTimeNow)
								n4 = ok2 and tonumber(result2) or 0
							end

							local flag2 = (tonumber(config.Limit) or 0) > 0 and n4 >= config.Limit
							local huge = tonumber(config.Price) or math.huge
							if flag2 then
								autoBuy = autoBuy or tostring(v6.Id) .. " sold out until restock"
								continue
							end

							if not (n3 - huge < race.SisaToken) then
								local v7 = pcall

								local function fn23()
									return RaceRally:InvokeServer(v6.Id)
								end

								local v8, v9, v10 = v7(fn23)
								if v8 and v9 ~= false then
									race.ShopStatus = "bought " .. tostring(v6.Id)
									return true
								end
								race.beliTolak[v6.Id] = os.clock() + race.BELI_JEDA
								local v11 = tostring
								autoBuy = ("%s refused: %s"):format(tostring(v6.Id), v11(v8 and (v10 or v9) or v9))
								tbl.LOG.warn("RACE", "auto buy " .. autoBuy)
								continue
							end

							autoBuy = autoBuy or "not enough trophies for " .. tostring(v6.Id)
						end
					end

					if autoBuy then
						race.ShopStatus = "auto buy: " .. autoBuy
						return false, autoBuy
					end
					return false, "tidak ada yang bisa dibeli sekarang"
				end

				return false, "daftar offer tidak terbaca"
			end

			race.ShopStatus = "auto buy: no shop item selected"
			return false, "belum ada offer yang dipilih"
		end

		return false, "data RaceRally belum siap"
	end

	return false, "data RaceRally belum siap"
end

race.ShopStart = function()
	if race.shopOn then
		return false
	end
	race.shopOn = true

	task.spawn(function()
		while race.shopOn do
			if tbl.Alive then
				if race.AutoGoal then
					pcall(race.KlaimGoal)
				end

				if race.AutoEquip then
					pcall(race.EquipTerbaik)
				end

				if race.AutoBeli then
					pcall(race.Beli)
				end

				if not race.AutoGoal and not race.AutoEquip and not race.AutoBeli then
					race.ShopStatus = "idle"
				end

				task.wait(3)
				continue
			end

			break
		end

		race.shopOn = false
	end)

	return true
end

race.ShopSync = function()
	if race.AutoGoal then
		race.ShopStart()
		return
	end

	if race.AutoEquip then
		race.ShopStart()
		return
	end

	if race.AutoBeli then
		race.ShopStart()
		return
	end
end

tbl.ST.Trove:Add(function()
	race.shopOn = false
end)

race.Mount = function()
	for _, v4 in ipairs(collectionService:GetTagged("RaceMount")) do
		local ok, result = pcall(function()
			local character = v4:IsDescendantOf(v)

			if character then
				character = localPlayer.Character

				if character then
					character = v4:FindFirstChild(localPlayer.Name, true) ~= nil

					if not character then
						character = v4.Parent
						if character then
							return v4.Parent == localPlayer.Character
						end
					end
				end
			end

			return character
		end)

		if ok and result then
			return v4
		end
	end

	return nil
end

do
	local function rootGerak()
		local v4 = race.Mount()

		if v4 then
			local root

			if v4:IsA("BasePart") then
				root = v4
			else
				root = v4:FindFirstChild("Root") or v4:FindFirstChild("HumanoidRootPart") or v4:IsA("Model") and v4.PrimaryPart
			end

			if root then
				return root
			end
		end

		return fn2()
	end

	race.RootGerak = rootGerak

	local function fn23(arg, arg2, arg3, arg4)
		local v4 = rootGerak()

		if v4 then
			if v4.Parent then
				local position = v4.Position
				local n3 = arg - position
				local magnitude = n3.Magnitude

				if not (magnitude < 0.05) then
					local n4 = math.min(magnitude, arg2 * arg3)
					local n5 = position + n3.Unit * n4
					local v5 = arg4 or n3
					steal.Tulis(v4, v5.Magnitude > 0.01 and CFrame.lookAt(n5, n5 + v5.Unit) or CFrame.new(n5), false)
					return false, magnitude - n4
				end

				return true, 0
			end

			return false, 1e9
		end

		return false, 1e9
	end

	race.PORTAL_TTL = 2
	race.portalCache = nil
	race.portalCacheAt = 0

	race.Portal = function()
		local portalCache = race.portalCache

		if portalCache then
			if portalCache.Parent then
				return portalCache
			end
			race.portalCache = nil
		end

		local now = os.clock()

		if not (now - race.portalCacheAt < race.PORTAL_TTL) then
			race.portalCacheAt = now
			local world = v:FindFirstChild("World")
			local raceRallyPortal = world and world:FindFirstChild("RaceRallyPortal")
			if raceRallyPortal then
				race.portalCache = raceRallyPortal
				return raceRallyPortal
			end
			return raceRallyPortal
		end

		return nil
	end

	race.PortalHitbox = function()
		local v4 = race.Portal()
		if v4 then
			return v4:FindFirstChild("Hitbox", true)
		end
		return nil
	end

	race.LewatPortal = function()
		local v4 = race.PortalHitbox()

		if v4 then
			if steal.TM.on or steal.TM.NaikPasti() then
				race.Status = "leaving the treadmill"
				if not steal.TM.DoffPasti(3) then
					return false, "gagal turun dari treadmill"
				end
			end

			local v5 = fn2()

			if not v5 or (v5.Position - steal.STRIP).Magnitude > steal.ARRIVE then
				race.Status = "heading to safe zone first"

				if not steal.PulangSiklus("race: via safe zone") and not steal.GlideRetry(steal.STRIP, 25, 3) then
					tbl.LOG.warn("RACE", "tidak sampai strip - tetap berangkat ke portal")
				end
			end

			if not steal.ViaStrip() then
				tbl.LOG.warn("RACE", "safe zone tidak terverifikasi - tetap berangkat ke portal")
			end

			steal.PadStart()
			steal.SpoofStart()
			runService.PreSimulation:Wait()
			runService.PreSimulation:Wait()
			race.Status = "heading to the race portal"
			local position = v4.Position
			local n3 = os.clock() + 25
			local exitTo = nil

			while true do
				if os.clock() < n3 and race.on and tbl.Alive then
					race.Klaim()
					local v6 = fn2()

					if v6 then
						if v6.Parent then
							local n4 = position - v6.Position
							local magnitude = n4.Magnitude

							if not (magnitude <= 6) then
								local result = runService.Heartbeat:Wait()
								steal.Tulis(v6, CFrame.new(v6.Position + n4.Unit * math.min(magnitude, math.min(steal.SpeedCap(), race.LAJU_PORTAL) * result)), false)
								continue
							end

							exitTo = 1
							break
						end

						exitTo = 2
						break
					end

					break
				else
					exitTo = 1
					break
				end
			end

			if exitTo == 1 then
				race.Status = "entering the portal"
				local proximityPrompt = race.Portal() and race.Portal():FindFirstChildWhichIsA("ProximityPrompt", true)

				if proximityPrompt then
					local function fn24()
						proximityPrompt.HoldDuration = 0
					end

					pcall(fn24)
					pcall(fireproximityprompt, proximityPrompt)
				end

				task.wait(0.25)
				local v6 = fn2()

				if v6 then
					pcall(firetouchinterest, v6, v4, 0)
					task.wait(0.1)
					pcall(firetouchinterest, v6, v4, 1)
				end

				local n4 = os.clock() + 5

				while os.clock() < n4 and race.on do
					if race.Ikut() then
						race.gagalBeruntun = 0
						return true
					end
					runService.Heartbeat:Wait()
				end

				local attribute = workspace:GetAttribute("RaceRallyWindow")

				if attribute ~= nil then
					if race.gagalWindow ~= attribute then
						local v7 = race
						race.gagalWindow = attribute
						v7.gagalBeruntun = 0
					end

					race.gagalBeruntun = (race.gagalBeruntun or 0) + 1

					if race.GAGAL_MAKS <= race.gagalBeruntun then
						race.windowSelesai = attribute
						tbl.LOG.warn("RACE", ("%d kali gagal masuk portal di jendela %s - berhenti mencoba ronde ini"):format(race.gagalBeruntun, tostring(attribute)))
					end
				end

				return race.Ikut(), "portal disentuh tapi RaceId tidak datang"
			end

			if exitTo == 2 then
				return false, "tanpa rig"
			end
			return false, "tanpa rig"
		end

		return false, "portal belum muncul"
	end

	local function fn24(arg, arg2)
		local v4 = nil
		local v5 = nil

		for i, v6 in ipairs(arg) do
			local magnitude = (v6.pos - arg2).Magnitude

			if v4 then
				if magnitude < v4 then
					v4 = magnitude
					v5 = i
				end
			else
				v4 = magnitude
				v5 = i
			end
		end

		if v5 then
			return v5
		end
		return 1
	end

	race.Finis = function()
		return localPlayer:GetAttribute("RaceFinishPlace") ~= nil
	end

	race.JAUH_LINTASAN = 150
	race.ANTAR_JEDA = 3
	race.antarAt = 0

	race.KeLintasan = function()
		if not (os.clock() - (race.antarAt or 0) < race.ANTAR_JEDA) then
			race.antarAt = os.clock()
			local v4 = race.Path()
			local character = localPlayer.Character
			local humanoidRootPart = character and character:FindFirstChild("HumanoidRootPart")

			if v4 then
				if humanoidRootPart then
					local n3 = fn21(v4, humanoidRootPart.Position) % v4.Length
					local v5 = v4:FrameAt(n3)
					local n4 = v5.Position + v5.UpVector * race.RAIL_TINGGI
					local magnitude = (n4 - humanoidRootPart.Position).Magnitude

					if not (magnitude <= race.JAUH_LINTASAN) then
						tbl.LOG.warn("RACE", ("di luar lintasan %d stud - diantar balik ke d=%d"):format(math.floor(magnitude), math.floor(n3)))
						race.Status = ("off track %d studs - returning to the line"):format(math.floor(magnitude))
						local n5 = math.max(200, (steal.PlafonGerak and select(2, pcall(steal.PlafonGerak)) or 800) * 0.55)
						local n6 = os.clock() + 12

						while os.clock() < n6 do
							if race.on then
								if tbl.Alive then
									if localPlayer.Character then
										local humanoidRootPart2 = localPlayer.Character:FindFirstChild("HumanoidRootPart")

										if humanoidRootPart2 then
											local n7 = n4 - humanoidRootPart2.Position

											if not (n7.Magnitude <= n5) then
												steal.Tulis(humanoidRootPart2, CFrame.new(humanoidRootPart2.Position + n7.Unit * n5), false)
												runService.PreSimulation:Wait()
												continue
											end

											steal.Tulis(humanoidRootPart2, CFrame.new(n4), false)
											break
										end

										break
									end

									break
								end

								break
							end

							break
						end

						local humanoidRootPart2 = localPlayer.Character and localPlayer.Character:FindFirstChild("HumanoidRootPart")
						local magnitude2 = humanoidRootPart2 and (n4 - humanoidRootPart2.Position).Magnitude or -1
						tbl.LOG.info("RACE", ("antar selesai - sisa %d stud"):format(math.floor(magnitude2)))
						local flag2 = magnitude2 >= 0
						if flag2 then
							return magnitude2 <= race.JAUH_LINTASAN
						end
						return flag2
					end

					return false
				end

				return false
			end

			return false
		end

		return false
	end

	race.JALUR = { raceIdLama = nil, path = nil, jarak = 0, siap = false, tLama = 0 }
	race.JALUR_ANGKAT = 4

	local function fn25(arg)
		pcall(function()
			local MountRaceFlags = require(tbl.SV.ReplicatedStorage.Shared.Flags.MountRaceFlags)

			if MountRaceFlags.TopSpeed and MountRaceFlags.TopSpeed.Value then
				MountRaceFlags.TopSpeed.Value = math.max(135, arg + 10)
			end

			if MountRaceFlags.AccelSeconds and MountRaceFlags.AccelSeconds.Value then
				MountRaceFlags.AccelSeconds.Value = 0.1
			end

			if MountRaceFlags.AirFallSeconds and MountRaceFlags.AirFallSeconds.Value then
				MountRaceFlags.AirFallSeconds.Value = 9999
				return
			end
		end)
	end

	local function fn26(arg)
		for _, child in ipairs(arg:GetChildren()) do
			if child.Attachment0 and child.Attachment0.Name == "MountDrive" then
				if child:IsA("LinearVelocity") then
					if child.MaxForce > 0 then
						child:SetAttribute("__SavedMaxForce", child.MaxForce)
						child.MaxForce = 0
					end
				elseif child:IsA("AlignOrientation") then
					if child.MaxTorque > 0 then
						child:SetAttribute("__SavedMaxTorque", child.MaxTorque)
						child.MaxTorque = 0
					end
				elseif child:IsA("VectorForce") then
					child.Force = Vector3.zero
				end
			end
		end
	end

	race.JalurStep = function()
		local attribute = localPlayer:GetAttribute("RaceId")

		if attribute then
			local v4 = race.Track()

			if v4 then
				local character = localPlayer.Character
				local humanoidRootPart = character and character:FindFirstChild("HumanoidRootPart")

				if humanoidRootPart then
					local n3 = math.clamp(tonumber(race.LAJU_RAIL) or 200, 10, 2000)
					fn25(n3)
					local jalur = race.JALUR

					if jalur.raceIdLama ~= attribute then
						jalur.path = nil
						jalur.jarak = 0
						jalur.siap = false
						local now = os.clock()
						jalur.raceIdLama = attribute
						jalur.tLama = now
						local attachmentTrack = v4:FindFirstChild("AttachmentTrack")
						if not attachmentTrack then
							return
						end
						local ok, result = pcall(require, tbl.SV.ReplicatedStorage.Shared.Modules.RaceTrackPath)

						if ok and result then
							local ok2, path = pcall(result.new, attachmentTrack)

							if ok2 and path and type(path.Length) == "number" and path.Length > 0 then
								jalur.path = path
							end
						end

						if not jalur.path then
							return
						end
					end

					local path = jalur.path
					if not path then
						return
					end
					local now = os.clock()
					local n4 = math.min(now - (jalur.tLama or now), 0.1)
					jalur.tLama = now
					if n4 <= 0 then
						return
					end
					local position = humanoidRootPart.Position

					if jalur.siap then
						jalur.jarak = jalur.jarak + n3 * n4
						local ok, result = pcall(path.FrameAt, path, jalur.jarak)

						if ok then
							if result then
								local function fn27()
									local v5, v6 = path:Project(position, jalur.jarak, 50, 100)
									if type(v5) == "number" and type(v6) == "number" and v6 < 15 then
										jalur.jarak = jalur.jarak * 0.85 + v5 * 0.15
										return
									end
								end

								pcall(fn27)
								local n5 = result * CFrame.new(0, race.JALUR_ANGKAT, 0)
								humanoidRootPart.CFrame = humanoidRootPart.CFrame:Lerp(n5, math.abs(n5.UpVector.Y) < 0.7 and 0.95 or 0.75)
								humanoidRootPart.AssemblyLinearVelocity = n5.LookVector * n3
								humanoidRootPart.AssemblyAngularVelocity = Vector3.zero
								fn26(humanoidRootPart)
								local v5 = race
								local format = ("racing - path %d studs/s, lap %s").format
								local n6 = math.floor(n3)
								local v6 = table.pack(tostring(localPlayer:GetAttribute("RaceLap")))
								v6.n = 3 + v6.n - 1
								table.move(v6, 1, v6.n, 3, v6)
								v6[1] = "racing - path %d studs/s, lap %s"
								v6[2] = n6
								v5.Status = format(table.unpack(v6, 1, v6.n))
								return
							end

							return
						end

						return
					end

					local function fn27()
						local n5 = path.Length / 2
						local v5, v6 = path:Project(position, n5, n5, n5)
						if type(v5) == "number" and type(v6) == "number" and v6 < 50 then
							jalur.jarak = v5
							return
						end
						local v7 = path:Project(position, 0, 0, path.Length)
						if type(v7) ~= "number" then
							return
						end
						jalur.jarak = v7
					end

					pcall(fn27)
					jalur.siap = true
					jalur.tLama = now
					return
				end

				return
			end

			return
		end
	end

	race.BalapRail = function()
		if race.MODE ~= "Rail" then
			return nil
		end

		if race.Path() then
			local v4 = race
			local v5 = race
			local railSkala = race.RAIL_SKALA
			race.railDist = nil
			v4.railSkala = railSkala
			v5.stunDitahan = 0
			local now = os.clock()
			local flag2 = false

			while true do
				if not race.on or not tbl.Alive or race.Fase ~= "Racing" then
					race.RailLepas()
					return true
				else
					if race.Finis() then
						local v6 = race
						local format = ("finished - place %s").format
						local v7 = table.pack(tostring(localPlayer:GetAttribute("RaceFinishPlace")))
						v7.n = 2 + v7.n - 1
						table.move(v7, 1, v7.n, 2, v7)
						v7[1] = "finished - place %s"
						v6.Status = format(table.unpack(v7, 1, v7.n))
						race.RailLepas()
						return true
					end

					race.Klaim()
					local character = localPlayer.Character
					local humanoid, v6

					if character then
						humanoid = character:FindFirstChildOfClass("Humanoid")
						v6 = humanoid
					else
						humanoid = character
						v6 = character
					end

					if v6 and character:FindFirstChild("RaceMount") then
						local function fn27()
							if not humanoid:GetStateEnabled(Enum.HumanoidStateType.PlatformStanding) then
								humanoid:SetStateEnabled(Enum.HumanoidStateType.PlatformStanding, true)
							end

							if humanoid.PlatformStand then
								return
							end
							humanoid.PlatformStand = true
						end

						pcall(fn27)
						local mountCtl = race.mountCtl

						if mountCtl and mountCtl.Override ~= nil then
							local function fn28()
								mountCtl.Override = nil
							end

							pcall(fn28)
						end

						pcall(race.JalurStep)
						flag2 = true
					end

					if not flag2 and os.clock() - now > 8 then
						break
					end
					runService.Heartbeat:Wait()
				end
			end

			return nil, "RaceMount tidak muncul"
		end

		return nil, "modul RaceTrackPath / AttachmentTrack tidak ada"
	end

	race.Balap = function()
		local v4, v5 = race.BalapRail()
		if v4 ~= nil then
			return v4, v5
		end

		if v5 then
			tbl.LOG.warn("RACE", "rail dilewati: " .. tostring(v5))
		end

		local v6 = race.Jalur()

		if v6 then
			local v7 = race.Laps()
			local v8 = race.Track()
			local finishLine = v8 and v8:FindFirstChild("FinishLine")
			local v9 = rootGerak()
			local n3 = v9 and fn24(v6, v9.Position) or 1
			local now = os.clock()
			local now2 = os.clock()
			local n4 = 1
			local v10 = nil
			local n5 = 0

			while true do
				if not race.on or not tbl.Alive then
					return false, "dihentikan"
				else
					if race.Fase ~= "Racing" then
						return true
					end

					if race.Finis() then
						local v11 = race
						local format = ("finished - place %s").format
						local v12 = table.pack(tostring(localPlayer:GetAttribute("RaceFinishPlace")))
						v12.n = 2 + v12.n - 1
						table.move(v12, 1, v12.n, 2, v12)
						v12[1] = "finished - place %s"
						v11.Status = format(table.unpack(v12, 1, v12.n))
						return true
					end

					if not (race.SABAR_LAP < os.clock() - now) then
						race.Klaim()
						local result = runService.Heartbeat:Wait()
						local n6, v11

						if n4 > v7 and finishLine then
							n6 = finishLine.Position + Vector3.new(0, race.ATAS, 0)
							race.Status = ("racing - crossing the finish line"):format()
							v11 = nil
						else
							local v12 = v6[n3]
							if not v12 then
								return false, "dihentikan"
							end
							local v13 = v6[n3 % #v6 + 1]
							n6 = v12.pos + Vector3.new(0, race.ATAS, 0)
							v11 = if v13 then v13.pos - v12.pos else nil
							race.Status = ("racing - lap %d/%d, wp %d/%d"):format(n4, v7, n3, #v6)
						end

						local v12, v13 = fn23(n6, race.LAJU_BALAP, result, v11)

						if v10 == nil or v13 < v10 - 2 then
							now2 = os.clock()
							v10 = v13
						elseif not (os.clock() - now2 > 1.2) then
							if v13 <= race.SAMPAI then
								if not (v7 < n4) then
									n3 += 1

									if #v6 < n3 then
										n4 += 1
										now = os.clock()
										n3 = 1
									end

									now2 = os.clock()
									v10 = nil
								else
									race.Status = "at the finish line - waiting for the server"
								end
							end
						else
							local v14 = rootGerak()

							if v14 then
								local function fn27()
									v14.AssemblyLinearVelocity = Vector3.zero
									v14.AssemblyAngularVelocity = Vector3.zero
								end

								pcall(fn27)
							end

							n5 += 1
							tbl.LOG.warn("RACE", ("tertahan di wp %d - dilewati (%d kali lap ini)"):format(n3, n5))
							n3 += 1

							if #v6 < n3 then
								n4 += 1
								now = os.clock()
								n3 = 1
							end

							now2 = os.clock()

							if n5 % 4 == 0 then
								local v15 = rootGerak()

								if v15 then
									steal.Tulis(v15, CFrame.new(v15.Position + Vector3.new(0, 25, 0)), false)
									tbl.LOG.warn("RACE", "tertahan beruntun - diangkat 25 stud")
								end
							end

							v10 = nil
						end

						continue
					end

					break
				end
			end

			return false, ("lap %d tidak selesai dalam %ds"):format(n4, race.SABAR_LAP)
		end

		return false, "AttachmentTrack tidak ketemu"
	end
end

race.PULANG_OTOMATIS = true
race.DIAM_FINIS = 8

race.Pulang = function()
	if race.PULANG_OTOMATIS then
		local n3 = tonumber(race.DIAM_FINIS) or 0

		if n3 > 0 then
			local n4 = os.clock() + n3
			race.Status = "finished - holding at the finish line"

			while os.clock() < n4 do
				if race.on then
					if tbl.Alive then
						if localPlayer:GetAttribute("RaceFinishPlace") ~= nil then
							break
						end

						if workspace:GetAttribute("RaceRallyRunning") ~= true then
							break
						end
						task.wait(0.25)
						continue
					end

					break
				end

				break
			end

			local info = tbl.LOG.info
			local format = ("diam %.1f detik di titik finis - place=%s").format
			local n5 = n3 - math.max(0, n4 - os.clock())
			local v4 = table.pack(tostring(localPlayer:GetAttribute("RaceFinishPlace")))
			v4.n = 3 + v4.n - 1
			table.move(v4, 1, v4.n, 3, v4)
			v4[1] = "diam %.1f detik di titik finis - place=%s"
			v4[2] = n5
			info("RACE", format(table.unpack(v4, 1, v4.n)))
		end

		local attribute = localPlayer:GetAttribute("RaceFinishPlace")
		race.Status = attribute and ("finished P%s - returning home"):format(tostring(attribute)) or "race over - returning home"

		if tbl.UIX and tbl.UIX.Pita and attribute then
			tbl.UIX.Pita(("Race finished - you placed #%s. Returning home."):format(tostring(attribute)), 6)
		end

		race.Klaim()
		local ok, result = pcall(steal.PulangTeleport, "race: back to safe zone")
		steal.pulang = false
		race.Lepas()
		if ok then
			race.Status = "idle"
			return true
		end
		tbl.LOG.warn("RACE", "pulang gagal: " .. tostring(result))
		race.Status = "idle"
		return false
	end

	return false
end

race.Start = function()
	if race.on then
		return false
	end

	if not race.Ada() then
		tbl.LOG.info("RACE", "RaceTrack belum ada - menunggu, bukan menolak")
	end

	race.on = true

	task.spawn(function()
		local ok, result = pcall(function()
			while race.on do
				if tbl.Alive then
					local fase = race.Fase

					if race.Ikut() and fase == "Racing" then
						local v4, v5 = race.Balap()

						if not v4 then
							tbl.LOG.warn("RACE", "balap berhenti: " .. tostring(v5))
						end

						while race.on and race.Fase == "Racing" do
							task.wait(1)
						end

						race.Pulang()
					elseif race.Ikut() then
						race.Status = "registered - waiting on the grid"
						task.wait(0.5)
					elseif race.PortalHitbox() then
						if steal.ORDER.Giliran("auto_race_rally") then
							local v4, v5 = race.LewatPortal()

							if not v4 then
								race.Status = "portal entry failed - " .. tostring(v5)
								tbl.LOG.warn("RACE", "portal: " .. tostring(v5))
								task.wait(2)
							end
						else
							race.Status = "waiting for turn - " .. tostring(steal.ORDER.Status)
							task.wait(1)
						end
					else
						if fase then
							race.Status = ("race running without us (%s) - waiting it out"):format(fase)
						else
							local v4 = race.Berikut()
							race.Status = if v4 then "waiting - next race in " .. race.Jam(v4) else "waiting for next race"
						end

						task.wait(2)
					end

					continue
				end

				break
			end
		end)

		race.on = false
		race.Status = "idle"
		if ok then
			return
		end
		tbl.LOG.err("RACE", tostring(result))
	end)

	return true
end

race.Stop = function()
	race.on = false
	race.Status = "idle"
	pcall(race.RailLepas)
	race.Lepas()
	pcall(steal.SpoofStop)
end

steal.STAR = {}

do
	local star = steal.STAR
	star.on = false
	star.muatan = nil
	star.sibuk = false
	star.Status = "waiting for a star"
	star.tangkap = 0
	star.JANGKAU = 12
	star.PULANG = true

	local function flag2(arg, arg2)
		local ok, result = pcall(require, tbl.SV.ReplicatedStorage.Shared.Flags.ShootingStarFlags)

		if ok then
			if type(result) ~= "table" then
				return arg2
			end
			local v4 = result[arg]
			if type(v4) ~= "table" then
				return arg2
			end

			if type(v4.Get) ~= "function" then
				return arg2
			end

			local ok2, result2 = pcall(function()
				return v4:Get()
			end)

			if ok2 and result2 ~= nil then
				return result2
			end
			return arg2
		end

		return arg2
	end

	star.Flag = flag2

	local function fn23()
		return v:GetServerTimeNow()
	end

	local function fn24(arg)
		if typeof(arg) ~= "Vector3" then
			if typeof(arg) ~= "CFrame" then
				if type(arg) == "table" then
					local num = tonumber(arg.X or arg[1])
					local num2 = tonumber(arg.Y or arg[2])
					local num3 = tonumber(arg.Z or arg[3])
					if num and num2 and num3 then
						return Vector3.new(num, num2, num3)
					end
				end

				return nil
			end

			return arg.Position
		end

		return arg
	end

	star.Posisi = function()
		local muatan = star.muatan

		if muatan then
			local leg = muatan.Leg

			if type(leg) == "table" then
				local v4 = fn24(leg.From)
				local v5 = fn24(leg.To)
				if v4 and v5 then
					local n3 = (tonumber(leg.ArriveAt) or 0) - (tonumber(leg.StartAt) or 0)
					return v4:Lerp(v5, not (n3 > 0) and 1 or math.clamp((fn23() - leg.StartAt) / n3, 0, 1))
				end
			end

			if muatan.Landing then
				local v4 = fn24(muatan.Landing)
				if v4 then
					return v4
				end
			end

			return nil
		end

		return nil
	end

	star.Ada = function()
		local muatan = star.muatan

		if muatan then
			if tonumber(muatan.ExpiresAt) and muatan.ExpiresAt <= fn23() then
				star.muatan = nil
				return false
			end
			return true
		end

		return false
	end

	star.Mendarat = function()
		local muatan = star.muatan
		local flag3 = muatan ~= nil
		if flag3 then
			return fn23() >= (tonumber(muatan.LandAt) or 0) + 1.5
		end
		return flag3
	end

	star.Sibuk = function()
		local on = star.on

		if on then
			on = star.sibuk
			if on then
				return (star.Ada())
			end
		end

		return on
	end

	local function fn25(arg)
		star.Status = tostring(arg)
		tbl.LOG.info("STAR", star.Status)
	end

	star.Tangkap = function()
		if star.sibuk then
			return
		end

		if star.on then
			if star.Ada() then
				if star.Mendarat() then
					if steal.ORDER.Giliran("auto_shooting_star") then
						if steal.pulang then
							return
						end

						if steal.rampok then
							return
						end
						star.sibuk = true

						task.spawn(function()
							local ok, result = pcall(function()
								local muatan = star.muatan

								if muatan then
									local id = muatan.Id
									local n3 = tonumber(muatan.HoldSeconds) or tonumber(flag2("HoldSeconds", 1.6)) or 1.6

									local function fn26()
										local on = star.on
										local flag3 = not on

										if on then
											local muatan2 = star.muatan
											flag3 = not muatan2

											if muatan2 then
												flag3 = star.muatan.Id ~= id
												if not flag3 then
													return not star.Ada()
												end
											end
										end

										return flag3
									end

									local ShootingStar = tbl.NET.Get("ShootingStar", "Hold")
									local ShootingStar2 = tbl.NET.Get("ShootingStar", "Catch")
									if not ShootingStar or not ShootingStar2 then
										fn25("ShootingStar remotes missing")
										return
									end

									for i = 1, 6 do
										if fn26() then
											break
										end
										fn25(("chasing the star (try %d)"):format(i))
										local v4 = star.Posisi()

										if v4 then
											if steal.GlideRetry(v4, star.JANGKAU, 3) then
												if fn26() then
													break
												end
												fn25("holding the star")

												local function fn27()
													ShootingStar:FireServer(id, true)
												end

												pcall(fn27)
												local n4 = os.clock() + n3 + 0.15
												local exitTo = nil

												while true do
													if not (os.clock() < n4) then
														exitTo = 1
														break
													else
														if fn26() then
															exitTo = 2
															break
														end
														local v5 = fn2()
														local v6 = star.Posisi()

														if v5 and v6 then
															if not ((Vector3.new(v6.X, v5.Position.Y, v6.Z) - v5.Position).Magnitude > 16) then
																steal.Tulis(v5, CFrame.new(v6 + Vector3.new(0, 3, 0)), false)
																task.wait(0.1)
																continue
															end

															exitTo = 4
															break
														end

														exitTo = 3
														break
													end
												end

												if exitTo == 1 then
													local function fn28()
														ShootingStar2:FireServer(id)
													end

													pcall(fn28)
													local n5 = os.clock() + 2

													while os.clock() < n5 do
														if star.muatan then
															if star.muatan.Id == id then
																task.wait(0.1)
																continue
															end
															break
														end

														break
													end

													if not star.muatan then
														break
													end

													if star.muatan.Id ~= id then
														break
													end
												else
													if exitTo ~= 2 and exitTo ~= 3 and exitTo == 4 then
													end

													local v5 = pcall

													local function fn28()
														ShootingStar:FireServer(id, false)
													end

													v5(fn28)
												end

												task.wait(0.4)
												continue
											end

											break
										end

										break
									end

									if star.PULANG and not star.muatan then
										fn25("returning home")
										local ok, result = pcall(steal.PulangTeleport, "star: back to safe zone")
										steal.pulang = false
										if not ok then
											tbl.LOG.warn("STAR", "pulang gagal: " .. tostring(result))
											return
										end
									end

									return
								end
							end)

							star.sibuk = false

							if not ok then
								tbl.LOG.warn("STAR", tostring(result))
							end

							if star.Ada() then
								return
							end
							fn25("waiting for a star")
						end)

						return
					end

					return
				end

				return
			end

			return
		end
	end

	local tbl2 = {}

	local function fn26(arg, arg2)
		local ShootingStar = tbl.NET.Get("ShootingStar", arg)
		if ShootingStar and ShootingStar.OnClientEvent then
			tbl2[#tbl2 + 1] = ShootingStar.OnClientEvent:Connect(arg2)
			return
		end
	end

	fn26("Fall", function(muatan)
		if type(muatan) ~= "table" then
			return
		end

		if muatan.Id ~= nil then
			if tonumber(muatan.ExpiresAt) and muatan.ExpiresAt <= fn23() then
				return
			end
			local flag3 = not star.muatan or star.muatan.Id ~= muatan.Id
			star.muatan = muatan

			if flag3 then
				fn25("star falling in " .. tostring(flag2("LandAreaId", "Cosmic")))

				if tbl.UIX then
					if tbl.UIX.Pita then
						local pita = tbl.UIX.Pita
						local format = ("A shooting star is falling in %s!").format
						local v4 = table.pack(tostring(flag2("LandAreaId", "Cosmic")))
						v4.n = 2 + v4.n - 1
						table.move(v4, 1, v4.n, 2, v4)
						v4[1] = "A shooting star is falling in %s!"
						pita(format(table.unpack(v4, 1, v4.n)), 8)
					end

					return
				end
			end

			return
		end
	end)

	fn26("Wander", function(arg, leg, arg2)
		if star.muatan and star.muatan.Id == arg and type(leg) == "table" then
			star.muatan.Leg = leg
			star.muatan.Noticed = arg2 == true
			return
		end
	end)

	fn26("Claimed", function(arg)
		if star.muatan and (arg == nil or star.muatan.Id == arg) then
			star.muatan = nil
			fn25("star was caught")
			return
		end
	end)

	fn26("Expired", function(arg)
		if star.muatan and (arg == nil or star.muatan.Id == arg) then
			star.muatan = nil
			fn25("star went home before anyone caught it")
			return
		end
	end)

	fn26("Celebrate", function(arg, arg2, arg3, arg4)
		if arg == localPlayer then
			star.tangkap = star.tangkap + 1
			fn25("you caught the star!")

			if tbl.UIX and tbl.UIX.Pita then
				local v4 = tostring
				tbl.UIX.Pita(("Caught the star! (%s x%s)"):format(tostring(arg2), v4(arg4 or 1)), 8)
				return
			end
		end
	end)

	task.spawn(function()
		local ShootingStar = tbl.NET.Get("ShootingStar", "AskState")
		if not ShootingStar or not ShootingStar.InvokeServer then
			return
		end

		local ok, muatan = pcall(function()
			return ShootingStar:InvokeServer()
		end)

		if not ok or type(muatan) ~= "table" then
			return
		end

		if muatan.Id ~= nil then
			star.muatan = muatan
			fn25("star already falling (recovered on load)")
			return
		end
	end)

	star.Start = function()
		if star.on then
			return false
		end
		star.on = true
		fn25(star.Ada() and "star active" or "waiting for a star")

		task.spawn(function()
			while star.on do
				if tbl.Alive then
					if star.Ada() and star.Mendarat() then
						star.Tangkap()
					end

					task.wait(1)
					continue
				end

				break
			end

			star.on = false
		end)

		return true
	end

	star.Stop = function()
		star.on = false
		star.Status = "idle"
	end

	tbl.ST.Trove:Add(function()
		star.on = false

		for _, v4 in ipairs(tbl2) do
			pcall(function()
				v4:Disconnect()
			end)
		end

		tbl2 = {}
	end)
end

local bolehCoba, fn23, opt

do
	local wisp = {
		Status = "idle",
		S = {},
		Cards = {},
		bin = nil,
		kejar = false,
		LastSwing = 0,
		StatusLast = "idle",
		StatusAt = 0,
		STATUS_TTL = 6,
		Ulang = {},
		ULANG = 5,
		on = false,
		TIER = { "Green", "Blue", "Purple", "Golden" },
	}

	local urut = { Green = 1, Blue = 2, Purple = 3 }
	urut.Golden = 4
	wisp.URUT = urut

	wisp.WARNA = {
		Green = Color3.new(0.28235295414924622, 0.83921569585800171, 0.37647059559822083),
		Blue = Color3.new(0.25098040699958801, 0.54901963472366333, 1),
		Purple = Color3.new(0.69019609689712524, 0.32941177487373352, 1),
		Golden = Color3.new(1, 0.78431373834609985, 0.19607843458652496),
	}

	wisp.POLL = 0.2
	steal.WISP = wisp

	bolehCoba = function(arg)
		return (steal.WISP.Ulang[arg] or 0) <= os.clock()
	end

	fn23 = function(arg)
		steal.WISP.Ulang[arg] = os.clock() + steal.WISP.ULANG
	end

	steal.WISP.BolehCoba = bolehCoba

	local tbl2 = {
		AutoNet = true,
		AutoCatch = true,
		Chase = true,
		ESP = true,
		AutoTrade = true,
		AutoCraft = true,
	}

	steal.WISP.BloomTerkunci = function()
		return steal.WISP.S.unlocked ~= true
	end

	opt = function(arg, arg2, arg3)
		if not arg3 and tbl2[arg] and steal.WISP.BloomTerkunci() then
			return false
		end
		local wisp2 = tbl.UIX and tbl.UIX.WISP
		local v4 = wisp2 and wisp2[arg]

		if v4 then
			local ok, result = pcall(v4.Get)

			if ok then
				if result ~= nil then
					return result
				end
				return arg2
			end

			return arg2
		end

		return arg2
	end

	steal.WISP.Opt = opt

	steal.WISP.Mod = function()
		local wisp2 = steal.WISP
		if wisp2.M then
			return wisp2.M
		end
		local replicatedStorage = tbl.SV.ReplicatedStorage

		local function fn24(arg, ...)
			for _, v4 in ipairs({ ... }) do
				if arg then
					arg = arg:FindFirstChild(v4)
					continue
				end
				return nil
			end

			return arg
		end

		local function fn25(arg)
			if arg then
				local ok, result = pcall(require, arg)
				if ok and result then
					return result
				end
				return nil
			end

			return nil
		end

		local m = {}
		local data = fn24(replicatedStorage, "Data", "WispQuests")
		m.Quests = fn25(data)
		local shared = fn24(replicatedStorage, "Shared", "Modules", "WispProgression")
		m.Progres = fn25(shared)
		local shared2 = fn24(replicatedStorage, "Shared", "Modules", "ButterflyCatalog")
		m.Katalog = fn25(shared2)
		local shared3 = fn24(replicatedStorage, "Shared", "Flags", "ButterflyFlags")
		m.Flags = fn25(shared3)
		local shared4 = fn24(replicatedStorage, "Shared", "Save")
		m.Save = fn25(shared4)
		local controllers = fn24(replicatedStorage, "Controllers", "Game", "AdminAbuseClientController", "Events", "ButterflyBloom", "Swarm")
		m.Swarm = fn25(controllers)
		m.Stages = fn24(replicatedStorage, "Assets", "UI", "WispStages")
		if m.Quests and m.Katalog and m.Save then
			wisp2.M = m
			return m
		end
		tbl.LOG.err("WISP", "modul game tidak lengkap - tata letak game berubah")
		return nil
	end

	steal.WISP.Flag = function(arg, arg2)
		local v4 = steal.WISP.Mod()
		local flags = v4 and v4.Flags and v4.Flags[arg]
		if not flags then
			return arg2
		end

		local ok, result = pcall(function()
			return flags:Get()
		end)

		if ok then
			if result ~= nil then
				return result
			end
			return arg2
		end

		return arg2
	end

	steal.WISP.Sisa = function()
		local v4 = steal.WISP.Mod()
		local attribute = v:GetAttribute(v4 and v4.Katalog.EndsAtAttribute or "ButterflyBloomEndsAt")
		if typeof(attribute) ~= "number" then
			return 0
		end
		return math.max(0, attribute - v:GetServerTimeNow())
	end

	steal.WISP.Berikut = function()
		local n3 = tonumber(steal.WISP.Flag("IntervalSeconds", 1800)) or 1800
		local n4 = tonumber(steal.WISP.Flag("OffsetSeconds", 900)) or 900
		local num = tonumber(steal.WISP.Flag("DurationSeconds", 300))

		if num then
			if n3 <= 0 then
				return nil
			end
		else
			num = 300
			if n3 <= 0 then
				return nil
			end
		end

		local serverTimeNow = v:GetServerTimeNow()
		local v4 = steal.WISP.Mod()
		local attribute = v:GetAttribute(v4 and v4.Katalog.EndsAtAttribute or "ButterflyBloomEndsAt")
		local v5 = if typeof(attribute) ~= "number" then math.floor((serverTimeNow - n4) / n3) * n3 + n4 else attribute - num
		local n5 = 0

		if v5 <= serverTimeNow then
			while true do
				v5 += n3
				n5 += 1

				if not (v5 <= serverTimeNow) then
					break
				elseif not (n5 < 64) then
					break
				end
			end
		end

		if not (v5 <= serverTimeNow) then
			return v5 - serverTimeNow
		end
		return nil
	end

	steal.WISP.Root = function()
		local character = localPlayer.Character

		if character then
			local humanoidRootPart = character:FindFirstChild("HumanoidRootPart")
			if humanoidRootPart then
				return humanoidRootPart
			end
		end

		return nil
	end

	steal.WISP.BUKTI_WAJIB = true

	steal.WISP.Snapshot = function()
		local wisp2 = steal.WISP
		local v4 = steal.WISP.Mod()

		if v4 then
			local s = wisp2.S
			s.sisa = steal.WISP.Sisa()
			s.bloomOn = steal.WISP.Flag("Enabled", true) ~= false
			s.hidup = 0

			if v4.Swarm and v4.Swarm.Count then
				local ok, hidup = pcall(v4.Swarm.Count)

				if ok and type(hidup) == "number" then
					s.hidup = hidup
				end
			end

			s.kupu = 0
			local butterflyBloomSwarm = v:FindFirstChild("ButterflyBloomSwarm", true)

			if butterflyBloomSwarm then
				for i in ipairs(butterflyBloomSwarm:GetChildren()) do
					s.kupu = s.kupu + 1
				end
			end

			local aktif = s.sisa > 0
			local flag2 = s.kupu > 0 or s.hidup > 0

			if steal.WISP.BUKTI_WAJIB ~= false then
				s.aktif = aktif and flag2
			else
				s.aktif = aktif
			end

			if aktif then
				if flag2 then
					wisp2.__wartaKosong = nil
				elseif not wisp2.__wartaKosong then
					wisp2.__wartaKosong = true
					tbl.LOG.info("WISP", "jendela jadwal buka tapi nol kupu-kupu - tidak berangkat (jadwal ditebak, bukan dari server)")
				end
			else
				wisp2.__wartaKosong = nil
			end

			if wisp2.pulangPending and not steal.WISP.DiLuarRumah() then
				wisp2.pulangPending = nil
				wisp2.pulangAt = nil
				wisp2.pergiUntukBloom = nil
			end

			s.menuju = not s.aktif and steal.WISP.Berikut() or nil
			local ok, result = pcall(v4.Save.Peek)
			local butterflies

			if ok and result then
				butterflies = result.Butterflies
			else
				result = nil
				butterflies = result
			end

			s.jaring = (butterflies and butterflies.NetClaimed) == true
			local v5 = if v4.Katalog.NetToolName then tostring(v4.Katalog.NetToolName) else "Butterfly Net"
			s.namaTool = v5
			local character = localPlayer.Character
			local backpack = localPlayer:FindFirstChild("Backpack")
			s.pegang = (character and character:FindFirstChild(v5)) ~= nil
			s.toolDiTas = (backpack and backpack:FindFirstChild(v5)) ~= nil
			s.counts = s.counts or {}

			for _, v6 in ipairs(wisp2.TIER) do
				s.counts[v6] = butterflies and butterflies.Counts and tonumber(butterflies.Counts[v6]) or 0
			end

			s.essence = butterflies and tonumber(butterflies.Essence) or 0
			s.ditangkap = butterflies and tonumber(butterflies.TotalCaught) or 0

			if not s.ikon then
				local ikon = {}
				local warnaTier = {}
				local namaTier = {}

				for _, v6 in ipairs(wisp2.TIER) do
					local tiers = v4.Katalog.Tiers and v4.Katalog.Tiers[v6]
					ikon[v6] = if tiers then tostring(tiers.Icon) else ""
					local str2

					if tiers then
						if typeof(tiers.Color) == "Color3" then
							warnaTier[v6] = tiers.Color
						end

						str2 = tostring(tiers.DisplayName)
					else
						str2 = v6
					end

					namaTier[v6] = str2:gsub("%s*Butterfly$", "")
				end

				s.ikon = ikon
				s.warnaTier = warnaTier
				s.namaTier = namaTier
			end

			if not s.biayaTukar then
				local biayaTukar = {}
				local resep = {}

				for i = 1, 3 do
					local v6 = wisp2.TIER[i]
					biayaTukar[v6] = tonumber(steal.WISP.Flag(("%sTo%sCost"):format(v6, wisp2.TIER[i + 1]), 0)) or 0
				end

				for _, v6 in ipairs(wisp2.TIER) do
					resep[v6] = tonumber(steal.WISP.Flag("Essence" .. v6, 0)) or 0
				end

				s.biayaTukar = biayaTukar
				s.resep = resep
			end

			s.tukarSiap = steal.WISP.AdaYangBisaDitukar()
			s.resepSiap = steal.WISP.ResepLengkap()
			local wispCompanion = result and result.WispCompanion
			s.accepted = (wispCompanion and wispCompanion.Accepted) == true
			s.unlocked = (wispCompanion and wispCompanion.Unlocked) == true
			s.stage = wispCompanion and tonumber(wispCompanion.Stage) or 1
			s.tahap = tonumber(v4.Quests.StageCount) or 4
			s.wessence = wispCompanion and tonumber(wispCompanion.Essence) or 0
			local list = v4.Quests.List or {}
			local v6 = list[s.stage]
			s.qid = if v6 then tostring(v6.Id) else nil
			s.quest = if v6 then tostring(v6.Title) else "-"
			s.target = v6 and tonumber(v6.Target) or 0
			local progres

			if v6 and wispCompanion and wispCompanion.Progress then
				progres = tonumber(wispCompanion.Progress[v6.Id]) or 0
			else
				progres = 0
			end

			s.progres = progres
			local quests = {}
			local str2, tbl3

			for i, v7 in ipairs(list) do
				local exitTo = nil

				while true do
					str2 = tostring(v7.Id)
					tbl3 = { id = str2, judul = tostring(v7.Title), target = tonumber(v7.Target) or 0 }

					if wispCompanion and wispCompanion.Progress then
						tbl3.progres = tonumber(wispCompanion.Progress[str2]) or 0
						if wispCompanion.Claimed then
							exitTo = 1
							break
						end
						tbl3.selesai = false
						tbl3.kini = i == s.stage
						tbl3.kunci = i > s.stage
						quests[i] = tbl3
						local v8 = table.pack(N_1())

						if v8[1] then
							i = v8[2]
							v7 = v8[3]
							continue
						end

						exitTo = 2
						break
					else
						break
					end
				end

				local claimed

				if exitTo == 1 then
					claimed = wispCompanion.Claimed[str2]
				else
					if exitTo == 2 then
						break
					end
					tbl3.progres = 0
					claimed = wispCompanion and wispCompanion.Claimed and wispCompanion.Claimed[str2]
				end

				tbl3.selesai = claimed and true or false
				tbl3.kini = i == s.stage
				tbl3.kunci = i > s.stage
				quests[i] = tbl3
			end

			s.quests = quests
			s.klaimbisa = false
			s.siapPulang = false

			if v4.Progres and wispCompanion then
				local ok2, result2 = pcall(v4.Progres.HasClaimable, wispCompanion)
				s.klaimbisa = ok2 and result2 == true
				local ok3, result3 = pcall(v4.Progres.IsReady, wispCompanion)
				s.siapPulang = ok3 and result3 == true
			end

			s.speed = result and tonumber(result.SpeedPower) or 0
			s.butuh = tonumber(v4.Quests.RequiredSpeedPower) or 0
			local build = v:FindFirstChild("World") and v.World:FindFirstChild("Build")
			s.zona = build and build:GetAttribute("EnchantedForestZoneRevealed") == true
			s.bolehKetemu = not s.accepted and not s.unlocked and s.speed >= s.butuh and s.zona
			return
		end
	end

	steal.WISP.Minta = function(arg, arg2, ...)
		local v4 = tbl.NET.Get(arg, arg2)

		if v4 then
			local v5 = table.pack(pcall(v4.InvokeServer, v4, ...))

			if v5[1] then
				local v6 = v5[3]
				local flag2 = v5[2] == true
				if type(v6) == "string" and v6 then
					return flag2, v6
				end
				return flag2, nil
			end

			return false, tostring(v5[2])
		end

		return false, ("%s.%s: remote not found"):format(arg, arg2)
	end

	steal.WISP.AmbilJaring = function()
		return steal.WISP.Minta("Butterflies", "AskClaimNet")
	end

	local function pasangJaring()
		local namaTool = steal.WISP.S.namaTool or "Butterfly Net"
		local character = localPlayer.Character
		local humanoid = character and character:FindFirstChildOfClass("Humanoid")
		local backpack = localPlayer:FindFirstChild("Backpack")
		local v4 = backpack and backpack:FindFirstChild(namaTool)
		if not humanoid or not v4 then
			return false
		end

		local ok = pcall(function()
			humanoid:EquipTool(v4)
		end)

		if ok then
			return character:FindFirstChild(namaTool) ~= nil
		end
		return ok
	end

	local wisp2 = steal.WISP
	wisp2.PasangJaring = pasangJaring

	steal.WISP.Ayun = function(arg)
		return steal.WISP.Minta("Butterflies", "AskSwing", arg)
	end

	local function tukar(arg)
		return steal.WISP.Minta("Butterflies", "AskTradeUp", arg)
	end

	steal.WISP.Tukar = tukar

	steal.WISP.Lebur = function()
		return steal.WISP.Minta("Butterflies", "AskCraftEssence")
	end

	steal.WISP.Terima = function()
		return steal.WISP.Minta("WispCompanion", "Request", "Accept")
	end

	steal.WISP.KlaimQuest = function(arg)
		return steal.WISP.Minta("WispCompanion", "Request", "Claim", arg)
	end

	steal.WISP.MulaiPulang = function()
		return steal.WISP.Minta("WispCompanion", "Request", "BeginReturn")
	end

	steal.WISP.Pulangkan = function()
		return steal.WISP.Minta("WispCompanion", "Request", "Return")
	end

	local function fn24()
		local wisp3 = tbl.UIX and tbl.UIX.WISP
		local tiers = wisp3 and wisp3.Tiers

		if tiers then
			if tiers.List then
				local ok, result = pcall(tiers.List)

				if ok then
					if type(result) ~= "table" then
						return nil
					end

					if #result ~= 0 then
						local tbl3 = {}

						for _, v4 in ipairs(result) do
							tbl3[tostring(v4)] = true
						end

						return tbl3
					end

					return nil
				end

				return nil
			end

			return nil
		end

		return nil
	end

	local function daftar()
		local butterflyBloomSwarm = v:FindFirstChild("ButterflyBloomSwarm")

		if butterflyBloomSwarm then
			local tbl3 = {}

			for _, child in ipairs(butterflyBloomSwarm:GetChildren()) do
				local name = child.Name

				if steal.WISP.URUT[name] then
					local position

					if child:IsA("BasePart") then
						position = child.Position
					else
						position = nil

						if child:IsA("Model") then
							position = child.PrimaryPart and child.PrimaryPart.Position or child:GetPivot().Position
						end
					end

					if position then
						tbl3[#tbl3 + 1] = { Position = position, Tier = name, model = child }
					end
				end
			end

			if #tbl3 ~= 0 then
				return tbl3
			end
			return nil
		end

		return nil
	end

	steal.WISP.Daftar = daftar

	steal.WISP.EntriDi = function(arg)
		local v4 = steal.WISP.Mod()

		if v4 then
			if v4.Swarm then
				if v4.Swarm.Nearest then
					local ok, result = pcall(v4.Swarm.Nearest, arg, Vector3.new(0, 0, -1), 4)
					if ok and result and result.Flight and result.Flight.Id then
						return result
					end
					return nil
				end

				return nil
			end

			return nil
		end

		return nil
	end

	steal.WISP.Sasaran = function(arg)
		local wisp3 = steal.WISP
		local n3 = tonumber(steal.WISP.Flag("NetReach", 14)) or 14
		local v4 = fn24()
		local v5 = steal.WISP.Daftar()

		if v5 then
			local v6 = nil
			local v7 = nil

			for _, v8 in ipairs(v5) do
				local magnitude = (v8.Position - arg).Magnitude

				if magnitude <= n3 and (not v4 or v4[v8.Tier]) then
					local n4 = (wisp3.URUT[v8.Tier] or 0) * 1000 - magnitude

					if v6 then
						if v6 < n4 then
							v6 = n4
							v7 = v8
						end
					else
						v6 = n4
						v7 = v8
					end
				end
			end

			if v7 then
				return steal.WISP.EntriDi(v7.Position)
			end
			return nil
		end

		local v6 = steal.WISP.Mod()
		local v7 = steal.WISP.Root()

		if v6 then
			if v6.Swarm then
				if v6.Swarm.Nearest then
					if v7 then
						local ok, result = pcall(v6.Swarm.Nearest, arg, v7.CFrame.LookVector, n3)
						if ok and result then
							return result
						end
						return nil
					end

					return nil
				end

				return nil
			end

			return nil
		end

		return nil
	end

	steal.WISP.KEJAR_JANGKAU = 600

	steal.WISP.Terjauh = function(arg)
		local v4 = steal.WISP.Daftar()

		if v4 then
			local v5 = fn24()
			local v6 = nil
			local v7 = nil
			local n3

			for _, v8 in ipairs(v4) do
				if v5 then
					n3 = v5[v8.Tier]
				end

				if n3 then
					n3 = (steal.WISP.URUT[v8.Tier] or 0) * 1000 - (v8.Position - arg).Magnitude

					if v6 then
						if v6 < n3 then
							v6 = n3
							v7 = v8
						end
					else
						v6 = n3
						v7 = v8
					end
				end
			end

			return v7
		end

		return nil
	end
end

steal.WISP.GAYA_PILIHAN = { "Default", "Zigzag", "Orbit", "Stay", "Spiral" }
steal.WISP.GAYA = "Default"
steal.WISP.GAYA_RADIUS = 26
steal.WISP.GAYA_LAJU = 2.2
steal.WISP.GAYA_LANGKAH = 0.35
steal.WISP.gayaFase = 0

steal.WISP.PusatKupu = function()
	local v4 = steal.WISP.Daftar()

	if type(v4) == "table" and #v4 > 0 then
		local vector = Vector3.new()
		local n3 = 0

		for _, v5 in ipairs(v4) do
			if typeof(v5.Position) == "Vector3" then
				vector += v5.Position
				n3 += 1
			end
		end

		if n3 > 0 then
			return vector / n3
		end
	end

	return steal.WISP.TitikKupu()
end

steal.WISP.GayaStep = function()
	local wisp = steal.WISP
	local str2 = tostring(wisp.GAYA or "Default")

	if str2 ~= "Default" then
		if str2 ~= "Stay" then
			local v4 = wisp.PusatKupu()
			local v5 = wisp.Root()

			if v4 then
				if v5 then
					local n3 = tonumber(wisp.GAYA_LANGKAH) or 0.35
					wisp.gayaFase = (wisp.gayaFase or 0) + (tonumber(wisp.GAYA_LAJU) or 2.2) * n3
					local n4 = tonumber(wisp.GAYA_RADIUS) or 26

					if str2 ~= "Zigzag" then
						if str2 == "Spiral" then
							n4 *= 0.35 + 0.65 * (0.5 + 0.5 * math.sin(wisp.gayaFase * 0.5))
						end

						local n5 = math.cos(wisp.gayaFase) * n4
						return (nil)(nil, nil --[[ constant not decoded ]])
					end

					local n5 = 1

					if math.floor(wisp.gayaFase) % 2 ~= 0 then
						n5 = -1
					end

					local n6 = v4 + Vector3.new(n5 * n4, 0, math.sin(wisp.gayaFase) * n4 * 0.5)
					wisp.kejar = true
					pcall(steal.MT.Jalan, n6, n3)
					wisp.kejar = false
					return true
				end

				return false
			end

			return false
		end

		return false
	end

	return false
end

steal.WISP.HOVER = 6
steal.WISP.HOVER_LAJU = 2

steal.WISP.Melayang = function(arg)
	local mt = steal.MT

	if arg then
		local num = tonumber(steal.WISP.HOVER)

		if num then
			if not (num <= 0) then
				local v4 = steal.WISP.Root()

				if v4 then
					if steal.MT.Mulai() then
						local raycastParams = RaycastParams.new()
						raycastParams.FilterType = Enum.RaycastFilterType.Exclude
						raycastParams.FilterDescendantsInstances = { localPlayer.Character, mt.pad, steal.Pad() }
						local hit = v:Raycast(v4.Position + Vector3.new(0, 4, 0), Vector3.new(0, -80, 0), raycastParams)

						if hit then
							mt.ikut = false
							local n3 = hit.Position.Y - 0.5 + steal.WISP.HOVER
							local n4 = tonumber(steal.WISP.HOVER_LAJU) or 2
							mt.lantai = mt.lantai + math.clamp(n3 - mt.lantai, -n4, n4)
							return
						end

						return
					end

					return
				end

				return
			end

			return
		end

		return
	end

	if mt.pad and mt.pad.Parent then
		mt.ikut = true
		return
	end
end

do
end

steal.WISP.QUEST = { ULANG = 4, tanamAt = 0, tetasAt = 0 }

local function kategoriEnchanted()
	local wisp = steal.WISP
	if wisp.katEnch then
		return wisp.katEnch
	end
	local katEnch = {}

	if pcall(function()
		local Areas = require(tbl.SV.ReplicatedStorage.Data.Areas)
		local directory = Areas and (Areas.Directory or Areas)
		local enchantedForest = directory and directory["Enchanted Forest"]

		for _, v4 in ipairs(enchantedForest and enchantedForest.DropTable or {}) do
			if type(v4) == "table" and type(v4[1]) == "string" then
				katEnch[v4[1]] = true
			end
		end
	end) then
		if next(katEnch) ~= nil then
			wisp.katEnch = katEnch
			return katEnch
		end
		return nil
	end

	return nil
end

steal.WISP.KategoriEnchanted = kategoriEnchanted

steal.WISP.QuestButuhTelur = function()
	local s = steal.WISP.S

	if steal.WISP.on then
		if opt("AutoQuest", false) then
			if s.accepted then
				if s.unlocked then
					return nil
				end

				if s.klaimbisa then
					return nil
				end
				local n3 = tonumber(s.progres) or 0
				local num = tonumber(s.target)

				if num then
					if num <= n3 then
						return nil
					end
				elseif n3 >= 0 then
					return nil
				end

				return s.qid
			end

			return nil
		end

		return nil
	end

	return nil
end

steal.WISP.SaringanQuest = function()
	local v4 = steal.WISP.QuestButuhTelur()

	if v4 then
		if v4 == "forest_eggs" or v4 == "forest_fusion" then
			return {
				Area = function(arg)
					return tostring(arg) == "Enchanted Forest"
				end,
				Priority = "Closest",
				MinKG = 0,
				MinValue = 0,
				Teleport = steal.TSOn(),
			}
		end

		if v4 ~= "eternal_egg" then
			return nil
		end

		return {
			Rarity = function(arg)
				return tostring(arg) == "Eternal"
			end,
			Priority = "Closest",
			MinKG = 0,
			MinValue = 0,
			Teleport = steal.TSOn(),
		}
	end

	return nil
end

do
	local function fn24()
		local v4 = steal.WISP.KategoriEnchanted()

		if v4 then
			local tbl2 = {}
			local tbl3 = {}
			local eggSt = steal.EggSt

			for k, v5 in pairs(steal.OwnEggs and steal.OwnEggs() or {}) do
				if type(v5) == "table" and v4[tostring(v5.AssetCategory)] then
					if type(v5) == "table" and v5.Placement == nil then
						tbl2[#tbl2 + 1] = tostring(k)
					end

					if eggSt and eggSt.IsReadyToHatch then
						local ok, result = pcall(eggSt.IsReadyToHatch, k)

						if ok and result then
							tbl3[#tbl3 + 1] = tostring(k)
						end
					end
				end
			end

			table.sort(tbl2)
			table.sort(tbl3)
			return tbl2, tbl3
		end

		return {}, {}
	end

	steal.WISP.PetEnchanted = function()
		local v4 = steal.WISP.KategoriEnchanted()
		if not v4 then
			return {}
		end
		local tbl2 = {}

		pcall(function()
			local Save = require(tbl.SV.ReplicatedStorage.Shared.Save)
			local peek = Save.Peek and Save.Peek()

			if peek then
				local tbl3 = {}

				for _, v5 in pairs(peek.EquippedAssets or {}) do
					tbl3[tostring(v5)] = true
				end

				for _, v5 in ipairs({ "FusionSlots", "PrivateFusionSlots", "VIPFusionSlots" }) do
					for _, v6 in ipairs(peek[v5] or {}) do
						tbl3[tostring(v6)] = true
					end
				end

				for k, v5 in pairs(peek.Inventory or {}) do
					local str2 = tostring(k)

					if type(v5) == "table" and not tbl3[str2] then
						local str3 = tostring(v5.Category or v5.AssetCategory or "")
						local flag2 = v5.InFuse == true or v5.IsFavorite == true or v5.Favorite == true

						if str3 ~= "" and v4[str3] and not flag2 then
							tbl2[str3] = tbl2[str3] or {}
							table.insert(tbl2[str3], str2)
						end
					end
				end

				return
			end
		end)

		for _, v5 in pairs(tbl2) do
			table.sort(v5)
		end

		return tbl2
	end

	steal.WISP.TigaSejenis = function()
		local v4 = steal.WISP.KategoriEnchanted()
		if not v4 then
			return nil
		end
		local tbl2 = {}

		if pcall(function()
			local Save = require(tbl.SV.ReplicatedStorage.Shared.Save)
			local peek = Save.Peek and Save.Peek() or nil

			for _, v5 in pairs(peek and peek.Inventory or {}) do
				if type(v5) == "table" then
					local str2 = tostring(v5.Category or v5.AssetCategory or "")

					if str2 ~= "" and v4[str2] then
						tbl2[str2] = (tbl2[str2] or 0) + 1
					end
				end
			end
		end) then
			for k, v5 in pairs(tbl2) do
				if not (v5 >= 3) then
					continue
				end
				local v6 = steal.WISP.PetEnchanted()[k]
				if v6 and #v6 >= 3 then
					return k, v5, { v6[1], v6[2], v6[3] }
				end
			end

			return nil
		end

		return nil
	end

	steal.WISP.FUSE_DEKAT = 6

	steal.WISP.TitikFuse = function()
		local world = v:FindFirstChild("World")
		local machines = world and world:FindFirstChild("Machines")
		local fuseMachine = machines and machines:FindFirstChild("FuseMachine")
		local machine = fuseMachine and fuseMachine:FindFirstChild("Machine")

		if machine and machine:IsA("BasePart") then
			local position = machine.Position
			if position then
				return position
			end
		end

		return nil
	end

	steal.WISP.FUSE_COBA = { "\0NIL", "Fusion", 1, "Public", "Default" }
	steal.WISP.FuseJalur = nil

	local function fn25(arg, arg2)
		if arg2 ~= "\0NIL" then
			return steal.WISP.Minta("Fusery", "LoadPet", arg, arg2)
		end
		return steal.WISP.Minta("Fusery", "LoadPet", arg)
	end

	steal.WISP.MuatPet = function(arg)
		if steal.WISP.FuseJalur ~= nil then
			return fn25(arg, steal.WISP.FuseJalur)
		end
		local v4 = nil

		for _, v5 in ipairs(steal.WISP.FUSE_COBA) do
			local v6
			v6, v4 = fn25(arg, v5)

			if v6 then
				steal.WISP.FuseJalur = v5
				tbl.LOG.info("WISP", "jalur Fusery = " .. tostring(v5))
				return true
			end
		end

		if v4 then
			return false, v4
		end
		return false, "every fuse lane refused"
	end

	steal.WISP.LepasPet = function(arg)
		for _, v4 in ipairs(arg or {}) do
			pcall(steal.WISP.Minta, "Fusery", "EjectPet", v4)
		end
	end

	steal.WISP.Fuse = function()
		local wisp = steal.WISP
		if wisp.sibukFuse then
			return false, "a fuse is already running"
		end
		local v4, v5, v6 = steal.WISP.TigaSejenis()
		if not v4 or not v6 then
			return false, "need 3 of one Enchanted Forest pet"
		end

		if #v6 ~= 3 then
			return false, "need 3 of one Enchanted Forest pet"
		end

		if steal.WISP.BolehGerak() then
			local v7 = steal.WISP.TitikFuse()
			if not v7 then
				return false, "FuseMachine not found"
			end
			wisp.sibukFuse = true
			wisp.sibuk = true
			wisp.kejar = true
			local speedFix = steal.SPEED_FIX
			steal.SPEED_FIX = steal.WISP.LAJU_PORTAL
			local tbl2 = {}
			local v8 = pcall

			local function fn26()
				local v9 = steal.WISP.Root()

				if not v9 or (v9.Position - v7).Magnitude > steal.WISP.FUSE_DEKAT then
					wisp.Status = "heading to the Fuse Machine"
					if not steal.Glide(v7 + Vector3.new(0, 3, 0), 20) then
						return "could not reach the Fuse Machine"
					end
				end

				wisp.Status = "loading 3 " .. v4

				for _, v10 in ipairs(v6) do
					local v11, v12 = steal.WISP.MuatPet(v10)

					if v11 then
						tbl2[#tbl2 + 1] = v10
						task.wait(0.1)
						continue
					end

					return "load: " .. tostring(v12 or "refused")
				end

				pcall(steal.WISP.Minta, "Fusery", "ConfirmBriefing")
				wisp.Status = "fusing " .. v4
				local Fusery, v10 = steal.WISP.Minta("Fusery", "BeginFuse")

				if Fusery then
					tbl2 = {}
					task.wait(0.4)
					local Fusery2, v11 = steal.WISP.Minta("Fusery", "FinishReveal")
					if Fusery2 then
						return nil
					end
					return "reveal: " .. tostring(v11 or "refused")
				end

				return "fuse: " .. tostring(v10 or "refused")
			end

			local v9, fuse = v8(fn26)
			steal.SPEED_FIX = speedFix
			wisp.kejar = false
			wisp.sibuk = false
			wisp.sibukFuse = false

			if #tbl2 > 0 then
				steal.WISP.LepasPet(tbl2)
			end

			if v9 then
				if fuse then
					wisp.Status = "fuse: " .. fuse
					return false, fuse
				end
				wisp.Status = "fused " .. v4
				return true, v4
			end

			return false, tostring(fuse)
		end

		return false, "steal engine is busy"
	end

	steal.WISP.QuestFusion = function()
		local quest = steal.WISP.QUEST
		local now = os.clock()
		local v4, v5 = steal.WISP.TigaSejenis()

		if v4 then
			if not ((quest.fuseAt or 0) <= now) then
				return
			end
			quest.fuseAt = now + quest.ULANG
			local v6, v7 = steal.WISP.Fuse()

			if not v6 then
				steal.WISP.Status = ("quest 2: %d %s - %s"):format(v5, v4, tostring(v7))
			end

			return
		end

		local v6, v7 = fn24()

		if #v7 > 0 and quest.tetasAt <= now then
			quest.tetasAt = now + quest.ULANG
			local eggSt = steal.EggSt

			if eggSt and eggSt.BeginHatch and eggSt.FinishHatch then
				local v8 = v7[1]
				local ok, result = pcall(eggSt.BeginHatch, v8)

				if ok and result ~= false then
					pcall(eggSt.FinishHatch, v8)
				end

				steal.WISP.Status = "quest 2: hatching enchanted egg"
				return
			end
		end

		if not (#v6 > 0) or not (quest.tanamAt <= now) then
			steal.WISP.Status = ("quest 2: %d unplaced, %d hatchable - need 3 of one kind"):format(#v6, #v7)
			return
		end
		quest.tanamAt = now + quest.ULANG
		local ok, result = pcall(steal.PEN.PlaceNew)
		steal.WISP.Status = ok and result and result > 0 and "quest 2: placing enchanted eggs to pen" or "quest 2: pen full or placing refused"
	end
end

local function bolehGerak()
	if steal.ORDER.Giliran("auto_wisp_event") then
		if steal.pulang then
			return false
		end

		if steal.HeldUid and steal.HeldUid() then
			return false
		end

		if steal.NightApproaching and steal.NightApproaching(0) then
			return false
		end
		return true
	end

	return false
end

steal.WISP.BolehGerak = bolehGerak

steal.WISP.Sibuk = function()
	local wisp = steal.WISP
	if wisp.sibuk then
		return true
	end

	if wisp.sibukTukar then
		return true
	end

	if wisp.kejar then
		return true
	end

	if wisp.on then
		if steal.WISP.BolehGerak() then
			local s = wisp.S
			if opt("AutoNet", false) and not s.jaring then
				return true
			end

			if opt("AutoCatch", false) and s.aktif then
				return true
			end

			if not s.aktif then
				if opt("AutoTrade", false) and s.tukarSiap then
					return true
				end

				if opt("AutoCraft", false) and s.resepSiap then
					return true
				end
			end

			return false
		end

		return false
	end

	return false
end

steal.WISP.AyunSekali = function()
	local wisp = steal.WISP
	local n3 = tonumber(steal.WISP.Flag("SwingCooldownSeconds", 0.45)) or 0.45
	local now = os.clock()
	if now - wisp.LastSwing < n3 then
		return false, "cooldown"
	end
	local v4 = steal.WISP.Root()

	if v4 then
		local v5 = steal.WISP.Sasaran(v4.Position)
		local id = v5 and v5.Flight and v5.Flight.Id

		if id then
			wisp.LastSwing = now
			local str2 = tostring(v5.Flight.Tier)
			local v6, v7 = steal.WISP.Ayun(id)
			wisp.Status = if v6 then "caught " .. str2 else "swing missed: " .. (v7 or str2)
			return v6
		end

		return false, "notarget"
	end

	return false, "nochar"
end

steal.WISP.Bin = function()
	local wisp = steal.WISP
	if wisp.bin and wisp.bin.Parent then
		return wisp.bin
	end
	local currentCamera = v.CurrentCamera

	if currentCamera then
		local folder2 = Instance.new("Folder")
		folder2.Name = "__WispESP"
		folder2.Parent = currentCamera
		wisp.bin = folder2
		return folder2
	end

	return nil
end

steal.WISP.ESPSync = function()
	local wisp = steal.WISP
	local v4 = steal.WISP.Bin()

	if v4 then
		local v5 = steal.WISP.Daftar()
		local v6 = steal.WISP.Root()
		local tbl2 = {}

		for _, v7 in ipairs(v5 or {}) do
			local str2 = v7.Flight and tostring(v7.Flight.Id)
			local str3 = v7.Flight and tostring(v7.Flight.Tier)

			if str2 and str3 then
				tbl2[str2] = true
				local tbl3 = wisp.Cards[str2]

				if not tbl3 or not tbl3.part.Parent then
					local part = Instance.new("Part")
					part.Name = "W_" .. str2
					part.Size = Vector3.new(0.2, 0.2, 0.2)
					part.Anchored = true
					part.CanCollide = false
					part.CanQuery = false
					part.CanTouch = false
					part.Transparency = 1
					part.Parent = v4
					local billboardGui = Instance.new("BillboardGui")
					billboardGui.Name = "W_" .. str2
					billboardGui.Adornee = part
					billboardGui.Size = UDim2.new(0, 120, 0, 20)
					billboardGui.StudsOffsetWorldSpace = Vector3.new(0, 1.6, 0)
					billboardGui.AlwaysOnTop = true
					billboardGui.LightInfluence = 0
					billboardGui.MaxDistance = 260
					billboardGui.Parent = part
					local textLabel = Instance.new("TextLabel")
					textLabel.Name = "T"
					textLabel.Size = UDim2.new(1, 0, 1, 0)
					textLabel.BackgroundTransparency = 1
					textLabel.Font = Enum.Font.GothamBold
					textLabel.TextSize = 13
					textLabel.TextStrokeTransparency = 0.35
					textLabel.Parent = billboardGui
					tbl3 = { part = part, gui = billboardGui, label = textLabel }
					wisp.Cards[str2] = tbl3
				end

				tbl3.part.CFrame = CFrame.new(v7.Position)
				tbl3.label.TextColor3 = wisp.WARNA[str3] or Color3.new(1, 1, 1)
				tbl3.label.Text = v6 and ("%s  %dm"):format(str3, math.floor((v7.Position - v6.Position).Magnitude)) or str3
			end
		end

		for k, card in pairs(wisp.Cards) do
			if not tbl2[k] then
				local function fn24()
					card.part:Destroy()
				end

				pcall(fn24)
				wisp.Cards[k] = nil
			end
		end

		return
	end
end

steal.WISP.ESPBersih = function()
	local wisp = steal.WISP

	for k, card in pairs(wisp.Cards) do
		pcall(function()
			card.part:Destroy()
		end)

		wisp.Cards[k] = nil
	end

	if wisp.bin then
		pcall(function()
			wisp.bin:Destroy()
		end)

		wisp.bin = nil
		return
	end
end

steal.WISP.CFG_RESEP = "WispTradeRecipe"

steal.WISP.ResepPilihan = function()
	local v4 = tbl.CFG.Get(steal.WISP.CFG_RESEP, "")
	if type(v4) ~= "string" then
		return nil
	end

	if v4 ~= "" then
		return v4
	end
	return nil
end

steal.WISP.TukarSemua = function()
	local s = steal.WISP.S
	local v4 = steal.WISP.ResepPilihan()
	local n3 = 0

	for i = 3, 1, -1 do
		local tier = steal.WISP.TIER
		local v5 = tier[i]

		if v4 then
			tier = v5 == v4
		end

		if tier then
			local n4 = tonumber(steal.WISP.Flag(("%sTo%sCost"):format(v5, steal.WISP.TIER[i + 1]), 0)) or 0
			local n5 = tonumber(s.counts and s.counts[v5]) or 0

			while n4 > 0 and n5 >= n4 do
				if steal.WISP.Tukar(v5) then
					n3 += 1
					n5 -= n4
					task.wait(0.12)
					continue
				end

				break
			end
		end
	end

	return n3
end

steal.WISP.PaksaTampak = function()
	local v4 = steal.WISP.Mod()

	if v4 then
		local world = v:FindFirstChild("World")
		local build = world and world:FindFirstChild("Build")
		local enchantedForestZone = build and build:FindFirstChild("EnchantedForestZone")
		local wispSpawn = enchantedForestZone and enchantedForestZone:FindFirstChild("WispSpawn")

		if wispSpawn then
			if wispSpawn:IsA("BasePart") then
				local n1 = v4.Stages and v4.Stages:FindFirstChild("1")

				if n1 then
					local transient = v:FindFirstChild("Transient")
					local wispLihat = transient and transient:FindFirstChild("__WispLihat")

					if wispLihat then
						wispLihat:Destroy()
					end

					local clone = n1:Clone()
					clone.Name = "__WispLihat"
					local boundingBox, v5 = clone:GetBoundingBox()
					local n3

					if v4.Quests.CompanionHeights then
						n3 = v4.Quests.CompanionHeights[1] or 2.1
					else
						n3 = 2.1
					end

					if v5.Y > 0 then
						local function fn24()
							clone:ScaleTo(clone:GetScale() * n3 / v5.Y)
						end

						pcall(fn24)
					end

					for _, descendant in ipairs(clone:GetDescendants()) do
						if descendant:IsA("BasePart") then
							descendant.Anchored = true
							descendant.CanCollide = false
							descendant.CanTouch = false
							descendant.CanQuery = false
						end
					end

					clone:PivotTo(wispSpawn.CFrame * CFrame.new(0, (tonumber(v4.Quests.SpawnHoverHeight) or 1.5) + wispSpawn.Size.Y * 0.5, 0))
					clone.Parent = transient or v
					return true, tostring(wispSpawn.Position)
				end

				return false, "Assets.UI.WispStages.1 missing"
			end

			return false, "WispSpawn not found in the map"
		end

		return false, "WispSpawn not found in the map"
	end

	return false, "game modules missing"
end

steal.WISP.TitikSpawn = function()
	local world = v:FindFirstChild("World")
	local build = world and world:FindFirstChild("Build")
	local enchantedForestZone = build and build:FindFirstChild("EnchantedForestZone")
	local wispSpawn = enchantedForestZone and enchantedForestZone:FindFirstChild("WispSpawn")

	if wispSpawn and wispSpawn:IsA("BasePart") then
		local position = wispSpawn.Position
		if position then
			return position
		end
	end

	return nil
end

steal.WISP.POS = {
	PINTU = Vector3.new(6868.9, 75, -309),
	STAND = Vector3.new(6000.2, 17003.05, 15699.5),
	KELUAR = Vector3.new(5832.5, 17016, 15699.4),
}

steal.WISP.POHON_Y = 16000
steal.WISP.LAJU_PORTAL = 250

steal.WISP.DiPohon = function()
	if localPlayer:GetAttribute("InEnchantedTree") ~= true then
		local v4 = steal.WISP.Root()
		local flag2 = v4 ~= nil
		if flag2 then
			return v4.Position.Y > steal.WISP.POHON_Y
		end
		return flag2
	end

	return true
end

local function fn24(arg, ...)
	for _, v4 in ipairs({ ... }) do
		if arg then
			arg = arg:FindFirstChild(v4)
			continue
		end
		return nil
	end

	if arg then
		if arg:IsA("ProximityPrompt") then
			return arg
		end
		local proximityPrompt = arg:FindFirstChildWhichIsA("ProximityPrompt", true)
		if proximityPrompt then
			return proximityPrompt
		end
	end

	return nil
end

steal.WISP.PromptPintu = function()
	local world = v:FindFirstChild("World")
	local enchantedTreeInterior = fn24(world and world:FindFirstChild("Build"), "EnchantedTreeInterior", "Markers", "EnterTrigger", "EnchantedTreeEntrance", "EnchantedTreePrompt")
	if enchantedTreeInterior then
		return enchantedTreeInterior
	end

	for _, descendant in ipairs(v:GetDescendants()) do
		if descendant:IsA("ProximityPrompt") and descendant.Name == "EnchantedTreePrompt" then
			return descendant
		end
	end

	return nil
end

steal.WISP.PromptJaring = function()
	local world = v:FindFirstChild("World")
	return fn24(world and world:FindFirstChild("Machines"), "ButterflyStation", "NetStand", "Anchor", "ProximityPrompt")
end

steal.WISP.MasukPohon = function()
	if steal.WISP.DiPohon() then
		return nil
	end
	steal.WISP.Status = "heading to the enchanted tree"
	local v4 = steal.WISP.PromptPintu()
	local parent = v4 and v4.Parent
	local worldPosition

	if parent and parent:IsA("Attachment") then
		worldPosition = parent.WorldPosition or steal.WISP.POS.PINTU
	else
		worldPosition = steal.WISP.POS.PINTU
	end

	steal.SpoofStart()
	steal.PadStart()
	runService.PreSimulation:Wait()
	runService.PreSimulation:Wait()
	steal.FLOW.Tahan(worldPosition + Vector3.new(0, 3, 0), 0.6)
	local v5 = steal.WISP.Root()

	if v5 then
		if not ((v5.Position - worldPosition).Magnitude > 10) then
			if v4 then
				if v4.Enabled then
					steal.WISP.Status = "entering the tree"
					steal.SCR.Prompt(v4)
					local n3 = os.clock() + 2.5

					while os.clock() < n3 do
						if steal.WISP.DiPohon() then
							break
						end
						task.wait(0.05)
					end

					if steal.WISP.DiPohon() then
						return nil
					end
					return "entering the tree failed"
				end

				return "tree prompt not available"
			end

			return "tree prompt not available"
		end

		return "could not reach the tree entrance"
	end

	return "could not reach the tree entrance"
end

steal.WISP.TitikKupu = function()
	return steal.FLOW.TitikArea("Enchanted Forest")
end

steal.WISP.DiAreaKupu = function()
	local v4 = steal.WISP.Root()
	local v5 = steal.WISP.TitikKupu()

	if v4 then
		if v5 then
			return Vector2.new(v4.Position.X - v5.X, v4.Position.Z - v5.Z).Magnitude <= steal.WISP.AREA_DEKAT
		end
		return false
	end

	return false
end

steal.WISP.AREA_DEKAT = 400

steal.WISP.KeAreaKupu = function()
	local wisp = steal.WISP
	if steal.WISP.DiAreaKupu() then
		return true
	end

	if wisp.sibuk then
		return false, "busy"
	end
	local v4 = steal.WISP.TitikKupu()

	if v4 then
		wisp.sibuk = true
		wisp.kejar = true
		local speedFix = steal.SPEED_FIX
		steal.SPEED_FIX = steal.WISP.LAJU_PORTAL
		wisp.Status = "heading to the enchanted forest"
		local ok, result = pcall(steal.Glide, v4 + Vector3.new(0, 4, 0), 45)
		steal.SPEED_FIX = speedFix
		wisp.kejar = false
		wisp.sibuk = false

		if ok then
			if result then
				wisp.pergiUntukBloom = true
				return true
			end
			return false, "could not reach the enchanted forest"
		end

		return false, tostring(result)
	end

	return false, "enchanted forest bounds not found"
end

steal.WISP.KeStasiun = function()
	local pos = steal.WISP.POS
	local v4 = steal.WISP.Root()

	if v4 then
		if not ((v4.Position - pos.STAND).Magnitude <= 10) then
			local v5 = steal.WISP.MasukPohon()
			if v5 then
				return false, v5
			end
			steal.WISP.Status = "heading to the net stand"
			if steal.Glide(pos.STAND + Vector3.new(0, 3, 0), 12) then
				return true
			end
			return false, "could not reach the net stand"
		end

		return true
	end

	return false, "no character"
end

steal.WISP.KePohon = function()
	local wisp = steal.WISP
	if steal.WISP.DiPohon() then
		return true
	end

	if wisp.sibuk then
		return false, "another trip is running"
	end

	if steal.WISP.BolehGerak() then
		wisp.sibuk = true
		wisp.kejar = true
		local speedFix = steal.SPEED_FIX
		steal.SPEED_FIX = steal.WISP.LAJU_PORTAL
		local ok, result = pcall(steal.WISP.MasukPohon)
		steal.SPEED_FIX = speedFix
		wisp.kejar = false
		wisp.sibuk = false

		if ok then
			if result then
				return false, result
			end
			wisp.Status = "at the enchanted tree"
			return true
		end

		return false, tostring(result)
	end

	return false, "steal engine is busy"
end

steal.WISP.TitikMesin = function(arg)
	local world = v:FindFirstChild("World")
	local machines = world and world:FindFirstChild("Machines")
	local butterflyStation = machines and machines:FindFirstChild("ButterflyStation")
	local v4 = butterflyStation and butterflyStation:FindFirstChild(arg)
	local anchor = v4 and v4:FindFirstChild("Anchor")
	if anchor and anchor:IsA("BasePart") then
		return anchor.Position
	end
	return nil
end

steal.WISP.KeMesin = function(arg)
	local wisp = steal.WISP
	local v4 = steal.WISP.TitikMesin(arg)
	if not v4 then
		return false, arg .. " not found"
	end
	local v5 = steal.WISP.Root()
	if v5 and (v5.Position - v4).Magnitude <= 10 then
		return true
	end

	if wisp.sibuk then
		return false, "another trip is running"
	end

	if steal.WISP.BolehGerak() then
		wisp.sibuk = true
		wisp.kejar = true
		local speedFix = steal.SPEED_FIX
		steal.SPEED_FIX = steal.WISP.LAJU_PORTAL

		local function fn25()
			local v6 = steal.WISP.MasukPohon()
			if v6 then
				return v6
			end
			wisp.Status = "heading to the " .. arg
			if steal.Glide(v4 + Vector3.new(0, 3, 0), 12) then
				return nil
			end
			return "could not reach the " .. arg
		end

		local ok, result = pcall(fn25)
		steal.SPEED_FIX = speedFix
		wisp.kejar = false
		wisp.sibuk = false

		if ok then
			if result then
				return false, result
			end
			return true
		end

		return false, tostring(result)
	end

	return false, "steal engine is busy"
end

steal.WISP.ResepLengkap = function()
	local counts = steal.WISP.S.counts or {}

	for _, v4 in ipairs(steal.WISP.TIER) do
		local n3 = tonumber(steal.WISP.Flag("Essence" .. v4, 0)) or 0
		if not (n3 > 0) then
			continue
		end
		local num = tonumber(counts[v4])

		if num then
			if not (num < n3) then
				continue
			end
			return false, v4
		end

		if n3 > 0 then
			return false, v4
		end
	end

	return true
end

steal.WISP.AdaYangBisaDitukar = function()
	local counts = steal.WISP.S.counts or {}
	local v4 = steal.WISP.ResepPilihan()

	for i = 1, 3 do
		local tier = steal.WISP.TIER
		local v5 = tier[i]

		if v4 then
			tier = v5 == v4
		end

		if tier then
			local n3 = tonumber(steal.WISP.Flag(("%sTo%sCost"):format(v5, steal.WISP.TIER[i + 1]), 0)) or 0
			if not (n3 > 0) then
				continue
			end
			local num = tonumber(counts[v5])

			if num then
				if not (n3 <= num) then
					continue
				end
				return true
			end

			if not (n3 <= 0) then
				continue
			end
			return true
		end
	end

	return false
end

steal.WISP.TukarSatu = function(arg)
	local wisp = steal.WISP
	if wisp.sibukTukar then
		return false, "a trade is already running"
	end
	local v4 = wisp.URUT[arg]
	if not v4 or v4 >= 4 then
		return false, "no recipe for " .. tostring(arg)
	end
	local v5 = (wisp.S.namaTier or {})[arg] or arg
	local n3 = tonumber(steal.WISP.Flag(("%sTo%sCost"):format(arg, wisp.TIER[v4 + 1]), 0)) or 0
	local num = tonumber((wisp.S.counts or {})[arg])

	if num then
		if n3 <= 0 then
			return false, "recipe cost unknown"
		end
	else
		num = 0
		if n3 <= 0 then
			return false, "recipe cost unknown"
		end
	end

	if not (num < n3) then
		wisp.sibukTukar = true

		local function fn25()
			local ButterflyMachine, v6 = steal.WISP.KeMesin("ButterflyMachine")

			if ButterflyMachine then
				wisp.Status = "trading up " .. v5
				local v7, v8 = steal.WISP.Tukar(arg)
				if v7 then
					return 1
				end

				if v8 then
					return v8
				end
				return "the machine refused the trade"
			end

			if v6 then
				return v6
			end
			return "could not reach the machine"
		end

		local ok, result = pcall(fn25)
		wisp.sibukTukar = false

		if ok then
			if type(result) ~= "string" then
				return true, result
			end
			return false, result
		end

		return false, tostring(result)
	end

	return false, ("need %d %s, have %d"):format(n3, v5, num)
end

steal.WISP.TukarOtomatis = function()
	if steal.WISP.AdaYangBisaDitukar() then
		local ButterflyMachine, v4 = steal.WISP.KeMesin("ButterflyMachine")
		if ButterflyMachine then
			steal.WISP.Status = "trading up"
			return true, steal.WISP.TukarSemua()
		end
		return false, v4
	end

	return false, "nothing to trade up"
end

steal.WISP.LeburOtomatis = function()
	local v4, v5 = steal.WISP.ResepLengkap()

	if v4 then
		local MutationShrine, v6 = steal.WISP.KeMesin("MutationShrine")
		if MutationShrine then
			steal.WISP.Status = "crafting essence"
			return steal.WISP.Lebur()
		end
		return false, v6
	end

	return false, "need more " .. tostring(v5)
end

steal.WISP.RUMAH_RADIUS = 120

steal.WISP.DiLuarRumah = function()
	local v4 = steal.WISP.Root()
	if v4 then
		return (v4.Position - steal.STRIP).Magnitude > steal.WISP.RUMAH_RADIUS
	end
	return false
end

steal.WISP.PULANG_MAKS = 45
steal.WISP.pulangAt = nil

steal.WISP.KeSafeZone = function()
	local wisp = steal.WISP
	if wisp.sibuk then
		return false, "another trip is running"
	end

	if steal.WISP.BolehGerak() then
		wisp.sibuk = true
		wisp.Status = "returning to the safe zone"
		local ok, result = pcall(steal.Pulang)
		wisp.sibuk = false

		if ok then
			local v4 = steal.WISP.Root()

			if v4 then
				if not ((v4.Position - steal.STRIP).Magnitude > 25) then
					wisp.Status = "at the safe zone"
					return true
				end
				return false, "did not reach the safe zone"
			end

			return false, "no character"
		end

		return false, tostring(result)
	end

	return false, "steal engine is busy"
end

steal.WISP.KeluarPohon = function()
	if steal.WISP.DiPohon() then
		steal.WISP.Status = "leaving the tree"
		steal.Glide(steal.WISP.POS.KELUAR + Vector3.new(0, 3, 0), 12)
		local n3 = os.clock() + 3

		while os.clock() < n3 do
			if steal.WISP.DiPohon() then
				task.wait(0.05)
				continue
			end
			break
		end

		return not steal.WISP.DiPohon()
	end

	return true
end

steal.WISP.JaringOtomatis = function()
	local wisp = steal.WISP
	if wisp.sibuk then
		return false, "busy"
	end
	wisp.sibuk = true
	wisp.kejar = true
	local speedFix = steal.SPEED_FIX
	steal.SPEED_FIX = steal.WISP.LAJU_PORTAL

	local ok, net = pcall(function()
		local v4, v5 = steal.WISP.KeStasiun()

		if v4 then
			wisp.Status = "claiming the net"
			local v6 = steal.WISP.PromptJaring()

			if v6 and v6.Enabled then
				steal.SCR.Prompt(v6)
				local n3 = os.clock() + 2
				local exitTo = nil

				while true do
					if not (os.clock() < n3) then
						exitTo = 1
						break
					else
						steal.WISP.Snapshot()
						if wisp.S.jaring then
							break
						end
						task.wait(0.1)
					end
				end

				if exitTo ~= 1 then
					return nil
				end
			end

			local v7, v8 = steal.WISP.AmbilJaring()
			if v7 then
				return nil
			end

			if v8 then
				return v8
			end
			return "refused"
		end

		if v5 then
			return v5
		end
		return "could not reach the station"
	end)

	if not ok then
		net = tostring(net)
	end

	pcall(steal.WISP.KeluarPohon)
	steal.SPEED_FIX = speedFix
	wisp.kejar = false
	wisp.sibuk = false
	if net then
		wisp.Status = "net: " .. net
		return false, net
	end
	wisp.Status = "net claimed"
	return true
end

steal.WISP.Start = function()
	local wisp = steal.WISP
	if wisp.on then
		return
	end
	wisp.on = true
	tbl.LOG.info("WISP", "mesin event hidup")

	task.spawn(function()
		while wisp.on do
			if tbl.Alive then
				local ok, result = pcall(function()
					steal.WISP.Snapshot()
					local s = wisp.S

					if opt("AutoNet", false) and not s.jaring then
						if steal.WISP.BolehGerak() then
							if bolehCoba("net") and not steal.WISP.JaringOtomatis() then
								fn23("net")
							end
						else
							wisp.Status = "net: waiting for the steal engine"
						end
					end

					local status = "AutoCatch"

					if opt(status, false) and s.aktif and not steal.WISP.DiAreaKupu() and steal.WISP.BolehGerak() and bolehCoba("area") then
						local v4
						v4, status = steal.WISP.KeAreaKupu()

						if not v4 then
							fn23("area")
							local v5 = wisp
							status = "area: " .. tostring(status or "failed")
							v5.Status = status
						end
					end

					if not s.aktif then
						status = not wisp.sibuk
					end

					if status and wisp.pergiUntukBloom and bolehCoba("pulang") then
						wisp.pulangPending = true

						if steal.WISP.BolehGerak() then
							local v4, v5 = steal.WISP.KeSafeZone()

							if v4 then
								wisp.pulangPending = nil
								tbl.LOG.info("WISP", "bloom habis - sudah pulang ke safe zone")
							else
								fn23("pulang")
								wisp.Status = "pulang: " .. tostring(v5 or "failed")
							end
						end
					elseif not steal.WISP.DiLuarRumah() then
						local v4 = wisp
						wisp.pulangPending = nil
						v4.pulangAt = nil
					end

					if opt("AutoCatch", false) and s.aktif and s.jaring and not s.pegang and s.toolDiTas and steal.WISP.PasangJaring() then
						s.pegang = true
						wisp.Status = "net equipped"
					end

					if opt("AutoCatch", false) and s.aktif and s.pegang then
						local v4, v5 = steal.WISP.AyunSekali()

						if v5 ~= "notarget" then
							steal.WISP.Melayang(true)
						end

						local str2 = tostring(steal.WISP.GAYA or "Default")
						local flag2 = false

						if opt("AutoCatch", false) and s.aktif and str2 ~= "Default" and str2 ~= "Stay" and steal.WISP.DiAreaKupu() and steal.WISP.BolehGerak() then
							if steal.TM.NaikPasti and steal.TM.NaikPasti() then
								pcall(steal.TM.DoffPasti, 3)
							end

							if steal.WISP.GayaStep() then
								flag2 = true
								wisp.Status = ("catching (%s)"):format(str2)
							end
						end

						if not v4 and v5 == "notarget" and str2 ~= "Stay" and not flag2 and opt("Chase", false) and steal.WISP.BolehGerak() then
							local flag3

							if steal.TM.NaikPasti() then
								if steal.TM.DoffPasti(3) then
									tbl.LOG.info("WISP", "turun dari treadmill sebelum mengejar")
									flag3 = steal.WISP.Root()
								else
									wisp.Status = "still on the treadmill - chase held"
									tbl.LOG.warn("WISP", "pengejaran DITAHAN - treadmill tidak mau melepas")
									flag3 = false
								end
							else
								flag3 = steal.WISP.Root()
							end

							local v6 = flag3 and steal.WISP.Terjauh(flag3.Position)

							if v6 then
								wisp.kejar = true
								wisp.Status = "chasing " .. tostring(v6.Flight and v6.Flight.Tier)
								pcall(steal.MT.Jalan, v6.Position, 1.5)
								wisp.kejar = false
								pcall(steal.MT.Henti)
							end
						end
					end

					if not opt("AutoCatch", false) or not s.aktif then
						steal.WISP.Melayang(false)
					end

					if opt("ESP", false) then
						steal.WISP.ESPSync()
					elseif next(wisp.Cards) then
						steal.WISP.ESPBersih()
					end

					if not s.aktif then
						if opt("AutoTrade", false) and steal.WISP.AdaYangBisaDitukar() and steal.WISP.BolehGerak() and bolehCoba("tukar") then
							local v4, v5 = steal.WISP.TukarOtomatis()

							if v4 then
								wisp.Status = ("traded up %d time(s)"):format(tonumber(v5) or 0)
							else
								fn23("tukar")
								wisp.Status = "trade: " .. tostring(v5)
							end
						end

						if opt("AutoCraft", false) and steal.WISP.BolehGerak() and bolehCoba("lebur") then
							local v4, v5 = steal.WISP.LeburOtomatis()

							if v4 then
								wisp.Status = "essence crafted"
							else
								fn23("lebur")
								wisp.Status = "craft: " .. tostring(v5)
							end
						end
					end

					if opt("AutoQuest", false) and s.accepted and not s.unlocked then
						if s.klaimbisa and s.qid and bolehCoba("quest") then
							local v4, v5 = steal.WISP.KlaimQuest(s.qid)
							wisp.Status = if v4 then "quest claimed: " .. s.qid else "claim: " .. (v5 or "refused")

							if not v4 then
								fn23("quest")
							end
						elseif s.qid == "forest_fusion" and (tonumber(s.progres) or 0) < (tonumber(s.target) or 0) then
							steal.WISP.QuestFusion()
						elseif steal.WISP.QuestButuhTelur() then
							wisp.Status = ("quest %d/%d: %s (%d/%d)"):format(tonumber(s.stage) or 1, tonumber(s.tahap) or 4, tostring(s.quest), tonumber(s.progres) or 0, tonumber(s.target) or 0)
						end
					end

					if wisp.Status ~= "idle" then
						if wisp.Status ~= wisp.StatusLast then
							local v4 = wisp
							local v5 = wisp
							local status2 = wisp.Status
							local now = os.clock()
							v4.StatusLast = status2
							v5.StatusAt = now
							return
						end

						if wisp.STATUS_TTL < os.clock() - wisp.StatusAt then
							local v4 = wisp
							wisp.Status = "idle"
							v4.StatusLast = "idle"
							return
						end
					end
				end)

				if not ok then
					tbl.LOG.err("WISP.loop", result)
				end

				task.wait(wisp.POLL)
				continue
			end

			break
		end

		wisp.on = false
		wisp.kejar = false
	end)
end

steal.WISP.Stop = function()
	local wisp = steal.WISP
	wisp.on = false
	wisp.kejar = false
	wisp.sibuk = false
	wisp.Status = "idle"
	pcall(steal.WISP.ESPBersih)
end

tbl.ST.Trove:Add(function()
	pcall(steal.WISP.Stop)
	local transient = v:FindFirstChild("Transient")
	local wispLihat = transient and transient:FindFirstChild("__WispLihat")

	if wispLihat then
		pcall(function()
			wispLihat:Destroy()
		end)

		return
	end
end)

do
	local steal2 = tbl.STEAL
	local order = steal2.ORDER
	local daftar = order.Daftar
	local tbl2 = {}
	tbl2.label = "Auto Steal"

	tbl2.Nyala = function()
		return steal2.Running == true
	end

	tbl2.BolehPotong = function()
		return steal2.HeldUid() == nil
	end

	tbl2.Siap = function()
		if steal2.Running then
			if steal2.NightApproaching and steal2.NightApproaching(3) then
				return true
			end
			return not steal2.NoMatch()
		end

		return false
	end

	tbl2.Selesai = function()
		if steal2.Running then
			if steal2.HeldUid() then
				return false
			end

			if steal2.FLOW and steal2.FLOW.Sibuk and steal2.FLOW.Sibuk() then
				return false
			end

			if steal2.NightApproaching and steal2.NightApproaching(3) then
				return false
			end
			return steal2.NoMatch()
		end

		return true
	end

	daftar("auto_steal", tbl2)

	order.Daftar("auto_scramble_lab", {
		label = "Dr. Scramble Lab",
		Nyala = function()
			return (steal2.LAB and steal2.LAB.on) == true
		end,
		Siap = function()
			local lab = steal2.LAB

			if lab then
				if lab.on then
					if lab.pending then
						return true
					end
					local n3 = tonumber(lab.total) or 0
					local n4 = tonumber(lab.siap) or 0
					local flag2 = n3 > 0
					if flag2 then
						return n4 >= n3
					end
					return flag2
				end

				return false
			end

			return false
		end,
		Selesai = function()
			local lab = steal2.LAB

			if lab then
				if lab.on then
					if lab.pending then
						return false
					end
					local n3 = tonumber(lab.total) or 0
					local n4 = tonumber(lab.siap) or 0
					return not (n3 > 0 and n4 >= n3)
				end

				return true
			end

			return true
		end,
	})

	order.Daftar("auto_shooting_star", {
		label = "Shooting Star",
		Nyala = function()
			return (steal2.STAR and steal2.STAR.on) == true
		end,
		Siap = function()
			local star = steal2.STAR
			if star and star.on and star.Ada() then
				return true
			end
			return false
		end,
		Selesai = function()
			local star = steal2.STAR

			if star then
				if star.on then
					if star.sibuk then
						return false
					end
					return not star.Ada()
				end

				return true
			end

			return true
		end,
	})

	local daftar2 = order.Daftar
	local tbl3 = { label = "Race Rally" }

	tbl3.Nyala = function()
		return (steal2.RACE and steal2.RACE.on) == true
	end

	tbl3.Siap = function()
		local race2 = steal2.RACE

		if race2 then
			if race2.on then
				if race2.Ikut() then
					return true
				end

				if race2.RondeLewat and race2.RondeLewat() then
					return false
				end
				return race2.PortalHitbox() ~= nil
			end

			return false
		end

		return false
	end

	tbl3.Selesai = function()
		local race2 = steal2.RACE

		if race2 then
			if race2.on then
				if race2.Ikut() then
					return false
				end

				if race2.RondeLewat and race2.RondeLewat() then
					return true
				end

				if race2.PortalHitbox() ~= nil then
					return false
				end
				local str2 = tostring(race2.Status or "")

				if str2 ~= "idle" then
					if str2:find("waiting") ~= nil then
						race2.finisAt = nil
						return true
					end
					race2.finisAt = race2.finisAt or os.clock()
					if not (race2.PULANG_MAKS < os.clock() - race2.finisAt) then
						return false
					end
					tbl.LOG.warn("RACE", ("sudah finis %ds tapi belum pulang (status %q) - giliran dilepas"):format(race2.PULANG_MAKS, str2))
					race2.finisAt = nil
					return true
				end

				race2.finisAt = nil
				return true
			end

			return true
		end

		return true
	end

	tbl3.BolehPotong = function()
		local race2 = steal2.RACE

		if race2 then
			if race2.on then
				return not race2.Ikut()
			end
			return true
		end

		return true
	end

	daftar2("auto_race_rally", tbl3)

	local function fn25()
		local wisp = steal2.WISP
		local s = wisp.S or {}
		if s.aktif then
			return false
		end

		local bolehCoba2 = type(wisp.BolehCoba) == "function" and wisp.BolehCoba or function()
			return true
		end

		if wisp.Opt("AutoTrade", false) and s.tukarSiap and bolehCoba2("tukar") then
			return true
		end

		if wisp.Opt("AutoCraft", false) and s.resepSiap and bolehCoba2("lebur") then
			return true
		end
		return false
	end

	local function fn26()
		local wisp = steal2.WISP

		if wisp then
			if wisp.on then
				if type(wisp.Opt) ~= "function" then
					return false
				end
				local flag2 = wisp.Opt("AutoCatch", false) == true

				if not flag2 then
					flag2 = wisp.Opt("AutoTrade", false) == true
					if not flag2 then
						return wisp.Opt("AutoCraft", false) == true
					end
				end

				return flag2
			end

			return false
		end

		return false
	end

	order.Daftar("auto_wisp_event", {
		label = "Wisp Event",
		Nyala = fn26,
		Siap = function()
			if fn26() then
				local wisp = steal2.WISP
				if fn25() then
					return true
				end

				if wisp.Opt("AutoCatch", false) ~= true then
					if wisp.pergiUntukBloom and wisp.pulangPending then
						return true
					end
					return false
				end

				if wisp.pergiUntukBloom and wisp.pulangPending then
					return true
				end
				local s = wisp.S or {}
				local flag2 = (tonumber(s.sisa) or 0) > 0
				if flag2 then
					return flag2
				end
				return (tonumber(s.hidup) or 0) > 0
			end

			return false
		end,
		Selesai = function()
			local wisp = steal2.WISP

			if fn26() then
				if wisp.kejar then
					return false
				end

				if wisp.sibuk then
					return false
				end

				if wisp.sibukTukar then
					return false
				end
				local s = wisp.S or {}

				if wisp.Opt("AutoCatch", false) == true then
					local num = tonumber(s.sisa)
					if num and num > 0 then
						return false
					end
					local num2 = tonumber(s.hidup)
					if num2 and num2 > 0 then
						return false
					end
				end

				if wisp.pergiUntukBloom and wisp.pulangPending then
					wisp.pulangAt = wisp.pulangAt or os.clock()
					local n3 = os.clock() - wisp.pulangAt
					local pulangMaks = wisp.PULANG_MAKS

					if pulangMaks then
						if n3 <= pulangMaks then
							return false
						end
					elseif n3 <= 45 then
						return false
					end

					tbl.LOG.warn("WISP", ("%ds belum sampai safe zone - giliran dilepas"):format(wisp.PULANG_MAKS or 45))
					wisp.pulangPending = nil
					wisp.pulangAt = nil
					wisp.pergiUntukBloom = nil
					return true
				end

				wisp.pulangAt = nil
				if fn25() then
					return false
				end

				if wisp.Opt("AutoCatch", false) ~= true then
					return true
				end
				return (tonumber(s.hidup) or 0) <= 0
			end

			return true
		end,
	})

	tbl.LOG.info("ORDER", ("%d task terdaftar"):format(#order.URUT))
end

local uix
uix = tbl.UIX
uix.LIB_URL = "https://raw.githubusercontent.com/JualNasiRendang/ui/refs/heads/main/BlackUILib.lua"
uix.LIB_CACHE = tbl.FS.Root .. "/BlackUILib.lua"

-- S2r Hub design system: charcoal / deep-black surfaces and violet accents.
-- The source library creates GUI objects while it loads, so patch its palette
-- BEFORE executing it. Editing lib.Theme afterwards would not recolor objects
-- that were already created.
uix.BRAND = "S2r Hub"
uix.INTRO = "gg.s2rhub by khay"
uix.CREDITS = "Own by Zen and Khay"
uix.DESCRIPTION = "Zen own this, Khay own this"
uix.DISCORD = "https://discord.gg/j3mpKNuU3"
uix.THEME_SOURCE = [=[local Theme = {
    Background    = Color3.fromRGB(8, 7, 14),
    Window        = Color3.fromRGB(12, 9, 21),
    TopBar        = Color3.fromRGB(21, 13, 36),
    Sidebar       = Color3.fromRGB(15, 11, 26),
    Card          = Color3.fromRGB(25, 19, 39),
    Control       = Color3.fromRGB(29, 20, 46),
    CardHover     = Color3.fromRGB(37, 27, 57),
    CardActive    = Color3.fromRGB(55, 32, 89),
    Border        = Color3.fromRGB(58, 39, 87),
    BorderLight   = Color3.fromRGB(98, 65, 143),
    Text          = Color3.fromRGB(246, 241, 255),
    SubText       = Color3.fromRGB(176, 160, 198),
    TextSecondary = Color3.fromRGB(176, 160, 198),
    TextDisabled  = Color3.fromRGB(115, 99, 137),
    Accent        = Color3.fromRGB(174, 98, 255),
    AccentDim     = Color3.fromRGB(58, 32, 91),
    Money         = Color3.fromRGB(85, 222, 156),
    Online        = Color3.fromRGB(85, 222, 156),
    Success       = Color3.fromRGB(85, 222, 156),
    Danger        = Color3.fromRGB(255, 97, 126),
}]=]


-- Standalone branded loader: visible while the upstream GUI library is being fetched.
-- All content is authored here, so the credits do not depend on the vendor's intro.
uix.LoadingPanel = nil
uix.LoadingStartedAt = 0

uix.ShowLoading = function()
    uix.LoadingStartedAt = os.clock()
    local ok, err = pcall(function()
        if uix.LoadingPanel and uix.LoadingPanel.Parent then
            uix.LoadingPanel:Destroy()
        end
        local player = tbl.PLR.Player
        local playerGui = player and (player:FindFirstChildOfClass("PlayerGui") or player:WaitForChild("PlayerGui", 5))
        if not playerGui then return end

        local function create(kind, props, parent)
            local object = Instance.new(kind)
            for property, value in pairs(props) do object[property] = value end
            object.Parent = parent
            return object
        end
        local white = Color3.fromRGB(246, 240, 255)
        local muted = Color3.fromRGB(170, 155, 193)
        local violet = Color3.fromRGB(174, 98, 255)
        local gui = create("ScreenGui", {
            Name = "S2rHubBrandedLoading",
            ResetOnSpawn = false,
            IgnoreGuiInset = true,
            DisplayOrder = 100000,
            ZIndexBehavior = Enum.ZIndexBehavior.Sibling,
        }, playerGui)
        uix.LoadingPanel = gui

        local scrim = create("Frame", {
            Name = "Backdrop", Size = UDim2.fromScale(1, 1),
            BackgroundColor3 = Color3.fromRGB(6, 5, 12), BorderSizePixel = 0,
        }, gui)
        create("UIGradient", {
            Rotation = 110,
            Color = ColorSequence.new({
                ColorSequenceKeypoint.new(0, Color3.fromRGB(11, 7, 22)),
                ColorSequenceKeypoint.new(0.5, Color3.fromRGB(18, 11, 34)),
                ColorSequenceKeypoint.new(1, Color3.fromRGB(7, 6, 13)),
            }),
        }, scrim)

        local card = create("Frame", {
            Name = "CreditsCard", AnchorPoint = Vector2.new(0.5, 0.5),
            Position = UDim2.fromScale(0.5, 0.5),
            Size = UDim2.new(0.90, 0, 0, 425),
            BackgroundColor3 = Color3.fromRGB(17, 12, 30), BorderSizePixel = 0,
        }, scrim)
        create("UISizeConstraint", {MaxSize = Vector2.new(470, 425), MinSize = Vector2.new(275, 350)}, card)
        create("UICorner", {CornerRadius = UDim.new(0, 17)}, card)
        create("UIStroke", {Color = Color3.fromRGB(91, 54, 132), Thickness = 1.4, Transparency = 0.16}, card)
        create("UIGradient", {
            Rotation = 90,
            Color = ColorSequence.new({
                ColorSequenceKeypoint.new(0, Color3.fromRGB(29, 17, 50)),
                ColorSequenceKeypoint.new(0.42, Color3.fromRGB(17, 12, 30)),
                ColorSequenceKeypoint.new(1, Color3.fromRGB(12, 10, 21)),
            }),
        }, card)
        create("Frame", {Name = "VioletTrim", Size = UDim2.new(1, 0, 0, 3),
            BackgroundColor3 = violet, BorderSizePixel = 0}, card)

        local mark = create("Frame", {Name = "BrandMark", Position = UDim2.fromOffset(26, 28),
            Size = UDim2.fromOffset(56, 56), BackgroundColor3 = Color3.fromRGB(63, 32, 102),
            BorderSizePixel = 0}, card)
        create("UICorner", {CornerRadius = UDim.new(0, 14)}, mark)
        create("UIStroke", {Color = violet, Thickness = 1.4, Transparency = 0.15}, mark)
        create("TextLabel", {Size = UDim2.fromScale(1, 1), BackgroundTransparency = 1,
            Text = "S2", Font = Enum.Font.GothamBlack, TextSize = 23,
            TextColor3 = white}, mark)

        local title = create("TextLabel", {
            Name = "Title", Position = UDim2.new(0, 96, 0, 31),
            Size = UDim2.new(1, -113, 0, 33), BackgroundTransparency = 1,
            Text = "S2r Hub", Font = Enum.Font.GothamBold,
            TextSize = 25, TextColor3 = white,
            TextXAlignment = Enum.TextXAlignment.Left,
        }, card)
        create("TextLabel", {
            Name = "CreatorCredit", Position = UDim2.new(0, 98, 0, 66),
            Size = UDim2.new(1, -113, 0, 17), BackgroundTransparency = 1,
            Text = "OWN BY ZEN AND KHAY", Font = Enum.Font.GothamMedium,
            TextSize = 11, TextColor3 = violet,
            TextXAlignment = Enum.TextXAlignment.Left,
        }, card)
        create("Frame", {Position = UDim2.new(0, 26, 0, 105),
            Size = UDim2.new(1, -52, 0, 1), BackgroundColor3 = Color3.fromRGB(61, 44, 82),
            BorderSizePixel = 0}, card)

        create("TextLabel", {Name = "AboutHeading", Position = UDim2.new(0, 26, 0, 123),
            Size = UDim2.new(1, -52, 0, 22), BackgroundTransparency = 1,
            Text = "ABOUT THE HUB", Font = Enum.Font.GothamBold,
            TextSize = 12, TextColor3 = violet,
            TextXAlignment = Enum.TextXAlignment.Left}, card)
        create("TextLabel", {Name = "Description", Position = UDim2.new(0, 26, 0, 149),
            Size = UDim2.new(1, -52, 0, 54), BackgroundTransparency = 1,
            Text = uix.DESCRIPTION,
            TextWrapped = true, TextYAlignment = Enum.TextYAlignment.Top,
            Font = Enum.Font.Gotham, TextSize = 12,
            TextColor3 = muted, TextXAlignment = Enum.TextXAlignment.Left}, card)

        local function ownerTag(label, xOffset)
            local pill = create("Frame", {Position = UDim2.new(xOffset, xOffset == 0 and 26 or 5, 0, 216),
                Size = UDim2.new(0.5, -31, 0, 31),
                BackgroundColor3 = Color3.fromRGB(40, 26, 62), BorderSizePixel = 0}, card)
            create("UICorner", {CornerRadius = UDim.new(0, 8)}, pill)
            create("UIStroke", {Color = Color3.fromRGB(91, 57, 128), Thickness = 1, Transparency = 0.20}, pill)
            create("TextLabel", {Size = UDim2.fromScale(1, 1), BackgroundTransparency = 1,
                Text = label .. "  ·  OWNER", Font = Enum.Font.GothamBold,
                TextScaled = true, TextColor3 = white}, pill)
            create("UITextSizeConstraint", {MinTextSize = 9, MaxTextSize = 12}, pill:FindFirstChildOfClass("TextLabel"))
        end
        ownerTag("ZEN", 0)
        ownerTag("KHAY", 0.5)

        create("TextLabel", {Name = "DiscordHeading", Position = UDim2.new(0, 26, 0, 272),
            Size = UDim2.new(1, -52, 0, 18), BackgroundTransparency = 1,
            Text = "DISCORD COMMUNITY", Font = Enum.Font.GothamBold,
            TextSize = 11, TextColor3 = violet,
            TextXAlignment = Enum.TextXAlignment.Left}, card)
        local discordButton = create("TextButton", {Name = "DiscordInvite",
            Position = UDim2.new(0, 26, 0, 296), Size = UDim2.new(1, -52, 0, 39),
            BackgroundColor3 = Color3.fromRGB(44, 27, 70), AutoButtonColor = true,
            BorderSizePixel = 0, Text = uix.DISCORD,
            Font = Enum.Font.GothamBold, TextSize = 12, TextScaled = true,
            TextColor3 = white}, card)
        create("UITextSizeConstraint", {MinTextSize = 9, MaxTextSize = 12}, discordButton)
        create("UICorner", {CornerRadius = UDim.new(0, 9)}, discordButton)
        create("UIStroke", {Color = violet, Thickness = 1, Transparency = 0.35}, discordButton)
        discordButton.MouseButton1Click:Connect(function()
            if type(setclipboard) == "function" then
                pcall(setclipboard, uix.DISCORD)
                discordButton.Text = "Invite copied!  " .. uix.DISCORD
            end
        end)

        local track = create("Frame", {Position = UDim2.new(0, 26, 0, 359),
            Size = UDim2.new(1, -52, 0, 5), BackgroundColor3 = Color3.fromRGB(53, 37, 74),
            BorderSizePixel = 0}, card)
        create("UICorner", {CornerRadius = UDim.new(1, 0)}, track)
        local fill = create("Frame", {Size = UDim2.fromScale(0.10, 1),
            BackgroundColor3 = violet, BorderSizePixel = 0}, track)
        create("UICorner", {CornerRadius = UDim.new(1, 0)}, fill)
        create("TextLabel", {Name = "LoadingStatus", Position = UDim2.new(0, 26, 0, 377),
            Size = UDim2.new(1, -52, 0, 20), BackgroundTransparency = 1,
            Text = "Loading S2r Hub...", Font = Enum.Font.GothamMedium,
            TextSize = 11, TextColor3 = muted,
            TextXAlignment = Enum.TextXAlignment.Center}, card)
        local tween = game:GetService("TweenService")
        tween:Create(fill, TweenInfo.new(3, Enum.EasingStyle.Quint, Enum.EasingDirection.Out),
            {Size = UDim2.fromScale(0.93, 1)}):Play()
    end)
    if not ok then
        tbl.LOG.warn("UIX.Loading", tostring(err))
    end
end

uix.HideLoading = function()
    local gui = uix.LoadingPanel
    if not gui then return end
    local remain = 2.6 - (os.clock() - uix.LoadingStartedAt)
    if remain > 0 then task.wait(remain) end
    if gui.Parent then
        local card = gui:FindFirstChild("Backdrop") and gui.Backdrop:FindFirstChild("CreditsCard")
        if card then
            local label = card:FindFirstChild("LoadingStatus")
            if label then label.Text = "S2r Hub is ready" end
        end
        task.wait(0.22)
        gui:Destroy()
    end
    if uix.LoadingPanel == gui then uix.LoadingPanel = nil end
end

uix.PatchLibrarySource = function(src)
    -- Rename labels inside the downloaded/cached library as well.
    local oldBrand = "Nasi" .. " Rendang"
    src = src:gsub(oldBrand .. " %- nrlscript%.com", uix.BRAND)
    src = src:gsub(oldBrand, uix.BRAND)

    -- The upstream library renders a separate introductory announcement BEFORE
    -- opening the main window. Rebrand that intro at source-construction time.
    src = src:gsub('title%s*=%s*"TRACK YOUR INVENTORY ON OUR WEBSITE FREE!"', 'title = "' .. uix.INTRO .. '"', 1)
    src = src:gsub('Text%s*=%s*"ANNOUNCEMENT"', 'Text = "' .. uix.INTRO .. '"', 1)
    src = src:gsub('linkPrefix%s*=%s*"visit : "', 'linkPrefix = "Discord: "', 1)
    src = src:gsub('url%s*=%s*"www%.nrlscript%.com/monitor"', 'url = "discord.gg/j3mpKNuU3"', 1)
    src = src:gsub('linkSuffix%s*=%s*"[^"]*"', 'linkSuffix = " | Own by Zen and Khay"', 1)
    src = src:gsub('buttonText%s*=%s*"Enter Script"', 'buttonText = "Open S2r Hub"', 1)
    -- Replace the vendor Discord footer with the requested Zen/Khay community invite.
    src = src:gsub('addFooterLink%(Icons%.Discord, "Discord", "discord%.gg/nasirendanglua", "https://discord%.gg/nasirendanglua"%)',
        'addFooterLink(Icons.Discord, "Discord", "discord.gg/j3mpKNuU3", "https://discord.gg/j3mpKNuU3")', 1)
    src = src:gsub('local keyTitleText = "nrlscript"',
        'local keyTitleText = "S2r Hub Premium"', 1)
    -- Intro colors, independent of the parent window's theme.
    src = src:gsub('TextColor3 = Color3.fromRGB%(255, 215, 95%)', 'TextColor3 = Theme.Accent', 1)
    src = src:gsub('TextColor3 = Color3.fromRGB%(130, 210, 255%)', 'TextColor3 = Theme.Accent', 1)
    src = src:gsub('BackgroundColor3 = Color3.fromRGB%(245, 245, 245%)', 'BackgroundColor3 = Theme.Accent', 1)
    src = src:gsub('TextColor3 = Color3.fromRGB%(15, 15, 20%)', 'TextColor3 = Color3.fromRGB(22, 11, 34)', 1)
    -- Replace the announcement logo with a small violet S2 mark.
    src = src:gsub('new%("ImageLabel", { Parent = AnnounceTopBar, Size = UDim2.fromOffset%(20, 20%), BackgroundTransparency = 1, Image = Icons.Logo, ImageColor3 = Theme.Text, LayoutOrder = 1 }%)',
        'new("TextLabel", { Parent = AnnounceTopBar, Size = UDim2.fromOffset(24, 24), BackgroundColor3 = Theme.AccentDim, Font = FONT_BOLD, Text = "S2", TextSize = 13, TextColor3 = Theme.Accent, LayoutOrder = 1 }, { corner(6), stroke(Theme.Accent, 1) })', 1)
    -- Remove the old brand logo. A custom violet S2 monogram is drawn below.
    src = src:gsub('Logo%s*=%s*"rbxassetid://124947058155926"', 'Logo = ""')
    -- Recolor initial GUI construction rather than merely swapping the theme table later.
    local paletteCount
    src, paletteCount = src:gsub("local Theme%s*=%s*%b{}", function()
        return uix.THEME_SOURCE
    end, 1)
    if paletteCount == 0 then
        tbl.LOG.warn("S2rHub.UI", "theme signature changed; using fallback colors")
    end
    -- Accent-color the tab marker and selected sidebar row.
    src = src:gsub("BackgroundColor3 = Theme.Text, BorderSizePixel = 0, ZIndex = 25", "BackgroundColor3 = Theme.Accent, BorderSizePixel = 0, ZIndex = 25", 1)
    src = src:gsub("BackgroundColor3 = Color3.fromRGB%(22, 22, 28%)", "BackgroundColor3 = Theme.CardActive", 1)
    return src
end

uix.Decorate = function(lib)
    if not lib or not lib.Window or not lib.ScreenGui then
        return
    end
    local accent = Color3.fromRGB(174, 98, 255)
    local panel = lib.Window
    local windowStroke = panel:FindFirstChildOfClass("UIStroke")
    if windowStroke then
        windowStroke.Color = Color3.fromRGB(107, 63, 156)
        windowStroke.Thickness = 1.35
        windowStroke.Transparency = 0.18
    end
    local windowCorner = panel:FindFirstChildOfClass("UICorner")
    if windowCorner then
        windowCorner.CornerRadius = UDim.new(0, 16)
    end

    -- Subtle gradient on the header, preserving all drag/tab/button interactions.
    local topbar = panel:FindFirstChild("TopBar")
    if topbar then
        local headerGradient = Instance.new("UIGradient")
        headerGradient.Name = "S2rHeaderGradient"
        headerGradient.Rotation = 10
        headerGradient.Color = ColorSequence.new({
            ColorSequenceKeypoint.new(0, Color3.fromRGB(40, 23, 67)),
            ColorSequenceKeypoint.new(1, Color3.fromRGB(16, 11, 28)),
        })
        headerGradient.Parent = topbar

        local underline = Instance.new("Frame")
        underline.Name = "S2rVioletLine"
        underline.Size = UDim2.new(1, 0, 0, 2)
        underline.Position = UDim2.new(0, 0, 1, -2)
        underline.BorderSizePixel = 0
        underline.BackgroundColor3 = accent
        underline.BackgroundTransparency = 0.28
        underline.ZIndex = 22
        underline.Parent = topbar

        -- Replace the old brand icon with a custom, asset-free mini logo.
        for _, element in ipairs(topbar:GetChildren()) do
            if element:IsA("ImageLabel") and element.Position.X.Offset == 14 then
                element.Visible = false
            elseif element:IsA("TextLabel") and element.Text:find("S2r Hub", 1, true) then
                element.Text = "S2r Hub"
                element.TextColor3 = Color3.fromRGB(251, 248, 255)
                element.TextSize = 15
            end
        end
        local logo = Instance.new("Frame")
        logo.Name = "S2rMark"
        logo.Size = UDim2.fromOffset(28, 28)
        logo.Position = UDim2.new(0, 14, 0.5, -14)
        logo.BorderSizePixel = 0
        logo.BackgroundColor3 = Color3.fromRGB(93, 47, 146)
        logo.ZIndex = 23
        logo.Parent = topbar
        local round = Instance.new("UICorner")
        round.CornerRadius = UDim.new(0, 8)
        round.Parent = logo
        local border = Instance.new("UIStroke")
        border.Color = accent
        border.Transparency = 0.25
        border.Thickness = 1
        border.Parent = logo
        local glyph = Instance.new("TextLabel")
        glyph.Name = "S2"
        glyph.Size = UDim2.fromScale(1, 1)
        glyph.BackgroundTransparency = 1
        glyph.Font = Enum.Font.GothamBold
        glyph.Text = "S2"
        glyph.TextSize = 13
        glyph.TextColor3 = Color3.fromRGB(255, 255, 255)
        glyph.ZIndex = 24
        glyph.Parent = logo
    end

    -- Rebrand the compact launcher, too. No changes to its click/drag behavior.
    local bubble = lib.ScreenGui:FindFirstChild("FloatingToggle")
    if bubble then
        for _, node in ipairs(bubble:GetChildren()) do
            if node:IsA("ImageLabel") then
                node.Visible = false
            end
        end
        bubble.BackgroundColor3 = Color3.fromRGB(37, 22, 58)
        local bubbleStroke = bubble:FindFirstChildOfClass("UIStroke")
        if bubbleStroke then
            bubbleStroke.Color = accent
            bubbleStroke.Transparency = 0.1
            bubbleStroke.Thickness = 1.5
        end
        local label = Instance.new("TextLabel")
        label.Name = "S2rBubbleMark"
        label.Size = UDim2.fromScale(1, 1)
        label.BackgroundTransparency = 1
        label.Font = Enum.Font.GothamBold
        label.Text = "S2"
        label.TextSize = 17
        label.TextColor3 = Color3.fromRGB(237, 211, 255)
        label.ZIndex = 302
        label.Parent = bubble
    end

    -- Ensure the announcement heading also uses the requested intro text.
    local announcement = lib.ScreenGui:FindFirstChild("AnnouncementModal")
    if announcement then
        for _, element in ipairs(announcement:GetDescendants()) do
            if element:IsA("TextLabel") and (element.Text == "ANNOUNCEMENT" or element.Text == "TRACK YOUR INVENTORY ON OUR WEBSITE FREE!") then
                element.Text = uix.INTRO
                element.TextColor3 = accent
            end
        end
    end

    -- Catch any additional user-facing branding in the external library.
    for _, element in ipairs(lib.ScreenGui:GetDescendants()) do
        if element:IsA("TextLabel") or element:IsA("TextButton") then
            if element.Text:lower():find(("nasi" .. " rendang"), 1, true) then
                element.Text = element.Text:gsub("Nasi" .. " Rendang", uix.BRAND)
            end
        end
    end
end

uix.Lib = function()
	if uix.lib then
		return uix.lib
	end
    uix.ShowLoading()
	local v4 = nil

	for i = 1, 3 do
		local function fn25()
			return game:HttpGet(uix.LIB_URL)
		end

		local ok, result = pcall(fn25)
		if ok and type(result) == "string" and #result > 500 then
			v4 = result
			break
		end
		task.wait(1)
	end

	if v4 then
		local function fn25()
			tbl.FS.Write(uix.LIB_CACHE, v4)
		end

		pcall(fn25)
	else
		v4 = tbl.FS.Read(uix.LIB_CACHE)

		if v4 then
			tbl.LOG.warn("UIX", "pustaka dari salinan lokal (ambil dari URL gagal)")
		end
	end

	if not v4 then
        uix.HideLoading()
		tbl.LOG.err("UIX", "BlackUILib tidak bisa diambil")
		return nil
	end

	local function fn25()
		return loadstring(uix.PatchLibrarySource(v4), "=S2rHubUILib")()
	end

	local ok, lib = pcall(fn25)
	if ok and type(lib) == "table" then
		uix.lib = lib
		pcall(uix.Decorate, lib)
        uix.HideLoading()
		return lib
	end
    uix.HideLoading()
	tbl.LOG.err("UIX", "BlackUILib gagal dimuat: " .. tostring(lib))
	return nil
end

do
	local function fn25(arg, arg2)
		return "Flags." .. (arg2 or arg):gsub("[^%w]", "")
	end

	uix.REG = {}

	local function fn26(arg, arg2, arg3)
		uix.REG[#uix.REG + 1] = { Key = arg, Default = arg2, Pulih = arg3 }
	end

	uix.Section = function(arg, arg2, arg3, arg4)
		local lib = uix.lib
		local v4 = lib.createSection(arg, arg2, arg3)
		if not v4 or not arg then
			return v4
		end

		if arg4 then
			return v4
		end
		local v5 = nil

		for _, child in ipairs(arg:GetChildren()) do
			if child ~= v4 then
				if child:IsA("Frame") then
					if child.LayoutOrder ~= arg3 then
						v5 = nil
						continue
					end
					local textLabel = child:FindFirstChildOfClass("TextLabel")

					if textLabel then
						if textLabel.Text ~= arg2 then
							v5 = nil
							continue
						end
						v5 = child
						break
					end

					v5 = nil
					continue
				end

				v5 = nil
				continue
			end

			v5 = nil
		end

		if v5 then
			local flag2 = true

			local TextLabel = lib.new("TextLabel", {
				Parent = v5,
				Name = "Chevron",
				Size = UDim2.new(0, 18, 0, 18),
				Position = UDim2.new(1, -18, 0.5, -9),
				BackgroundTransparency = 1,
				Font = lib.FONT_BOLD,
				TextSize = 14,
				TextColor3 = lib.Theme.TextSecondary,
				Text = "v",
				ZIndex = 14,
			})

			local TextButton = lib.new("TextButton", {
				Parent = v5,
				Name = "Fold",
				Size = UDim2.new(1, 0, 1, 0),
				BackgroundTransparency = 1,
				Text = "",
				AutoButtonColor = false,
				ZIndex = 15,
			})

			local function fn27(arg5)
				local n3 = 1

				while arg5 do
					if arg5 ~= game then
						local uiScale = arg5:FindFirstChildOfClass("UIScale")

						if uiScale and uiScale.Scale > 0 then
							n3 *= uiScale.Scale
						end

						arg5 = arg5.Parent
						continue
					end

					break
				end

				if not (n3 > 0) then
					return 1
				end
				return n3
			end

			local uiListLayout = v4:FindFirstChildOfClass("UIListLayout")
			local uiPadding = v4:FindFirstChildOfClass("UIPadding")

			local function fn28()
				local n3

				if uiListLayout then
					n3 = uiListLayout.AbsoluteContentSize.Y / fn27(v4)

					if uiPadding then
						n3 = n3 + uiPadding.PaddingTop.Offset + uiPadding.PaddingBottom.Offset
					end
				else
					n3 = v4.AbsoluteSize.Y / fn27(v4)
				end

				return math.max(0, math.floor(n3 + 0.5))
			end

			local tweenService = tbl.SV.TweenService
			local tweenInfo = TweenInfo.new
			local quad = Enum.EasingStyle.Quad
			local out = Enum.EasingDirection.Out
			local v6 = tweenInfo(0.18, quad, out)
			local n3 = 0

			local function fn29()
				n3 += 1
				local v7 = n3

				local function fn30()
					if n3 ~= v7 then
						return
					end
					v4.ClipsDescendants = false
					v4.AutomaticSize = Enum.AutomaticSize.Y

					if flag2 then
						v4.Visible = false
						v4.Size = UDim2.new(1, 0, 0, 0)
						return
					end
				end

				tweenService:Create(TextLabel, v6, { Rotation = flag2 and -90 or 0 }):Play()
				v4.AutomaticSize = Enum.AutomaticSize.Y
				v4.Size = UDim2.new(1, 0, 0, 0)
				v4.ClipsDescendants = false
				v4.Visible = not flag2
				TextLabel.Rotation = flag2 and -90 or 0
			end

			fn29(false)
			local mouseButton1Click = TextButton.MouseButton1Click
			local v7 = mouseButton1Click
			local connect = mouseButton1Click.Connect

			local function fn30()
				flag2 = not flag2
				fn29(true)
			end

			connect(v7, fn30)
			return v4
		end

		return v4
	end

	uix.Toggle = function(arg, arg2, arg3, arg4, arg5, arg6)
		local lib = uix.lib
		local v4 = fn25(arg2, arg6)
		local flag2 = tbl.CFG.Get(v4, arg4 and true or false) and true or false

		local v5 = lib.toggleRow(arg, arg2, arg3, function(arg7)
			tbl.CFG.Set(v4, arg7 and true or false)

			if arg5 then
				local ok, result = pcall(arg5, arg7)
				if not ok then
					tbl.LOG.err("Toggle." .. arg2, result)
					return
				end
			end
		end, flag2)

		local tbl2 = {
			Label = arg2,
			Get = v5.Get,
			Set = function(arg7, arg8)
				local flag3 = arg7 and true or false
				v5.Set(flag3)
				tbl.CFG.Set(v4, flag3)

				if not arg8 and arg5 then
					local ok, result = pcall(arg5, flag3)
					if not ok then
						tbl.LOG.err("Toggle.Set." .. arg2, result)
						return
					end
				end
			end,
			Sync = function()
				if v5.Get() and arg5 then
					local ok, result = pcall(arg5, true)

					if not ok then
						tbl.LOG.err("Toggle.Sync." .. arg2, result)
					end
				end

				return v5.Get()
			end,
		}

		fn26(v4, arg4 and true or false, function()
			local flag3 = arg4 and true or false

			if v5.Get() then
				if true ~= flag3 then
					tbl2.Set(flag3)
					return
				end
			elseif false ~= flag3 then
				tbl2.Set(flag3)
				return
			end

			tbl.CFG.Set(v4, flag3)
		end)

		return tbl2
	end

	uix.ToggleSatu = function(arg, arg2, arg3)
		return (uix.ToggleDual(arg, arg2, arg3, nil))
	end

	uix.ToggleDual = function(arg, arg2, arg3, arg4)
		local function fn27(arg5)
			if not arg5 then
				return nil
			end
			local v4 = fn25(arg5.label, arg5.key)
			arg5._key = v4
			arg5._state = tbl.CFG.Get(v4, arg5.default and true or false) and true or false
			arg5._kunci = arg5.locked and not uix.Bayar()

			if arg5._kunci then
				arg5._state = false
			end

			local function fn28(arg6)
				if arg5._kunci then
					if arg6 then
						uix.TolakKunci(arg5.label)

						task.defer(function()
							pcall(arg5._matikan)
						end)

						return
					end

					return
				end

				tbl.CFG.Set(v4, arg6 and true or false)

				if arg5.onChange then
					local ok, result = pcall(arg5.onChange, arg6)
					if not ok then
						tbl.LOG.err("Toggle." .. arg5.label, result)
						return
					end
				end
			end

			return { label = arg5.label, initial = arg5._state, onChange = fn28 }
		end

		local toggleDual = uix.lib.toggleDual
		local v4 = fn27(arg3)
		local v5 = fn27(arg4)
		local v6 = toggleDual(arg, arg2, v4, v5)

		if not arg4 and v6.Row then
			for _, child in ipairs(v6.Row:GetChildren()) do
				if child:IsA("Frame") then
					child.Size = UDim2.new(1, 0, 1, 0)
					local textButton = child:FindFirstChildOfClass("TextButton")

					if textButton then
						textButton.Position = UDim2.new(1, -34, 0.5, -8)
					end
				end
			end
		end

		if arg3 then
			arg3._matikan = function()
				v6.c1.Set(false)
			end
		end

		if arg4 then
			arg4._matikan = function()
				v6.c2.Set(false)
			end
		end

		local function fn28(arg5, arg6)
			if not arg5 or not arg6 then
				return nil
			end

			local function fn29()
				if arg5._kunci then
					return true
				end
				return false
			end

			local function fn30()
				local kunci = arg5._kunci
				local flag2 = not kunci
				if kunci then
					return flag2
				end
				return (arg6.Get())
			end

			local function fn31(arg7, arg8)
				local flag2 = arg7 and true or false
				arg6.Set(flag2)
				tbl.CFG.Set(arg5._key, flag2)

				if not arg8 and arg5.onChange then
					local ok, result = pcall(arg5.onChange, flag2)
					if not ok then
						tbl.LOG.err("Toggle.Set." .. arg5.label, result)
						return
					end
				end
			end

			local tbl2 = {
				Label = arg5.label,
				Kunci = fn29, -- report whether this setting is premium-locked
				Get = fn30, -- read-only getter; do NOT call the setter
				Set = fn31,
				Sync = function()
					if arg6.Get() and arg5.onChange then
						local ok, result = pcall(arg5.onChange, true)

						if not ok then
							tbl.LOG.err("Toggle.Sync." .. arg5.label, result)
						end
					end

					return arg6.Get()
				end,
			}

			local key = arg5._key
			local flag2 = arg5.default and true or false

			local function fn32()
				local flag3 = arg5.default and true or false

				if arg6.Get() then
					if true ~= flag3 then
						tbl2.Set(flag3)
						return
					end
				elseif false ~= flag3 then
					tbl2.Set(flag3)
					return
				end

				tbl.CFG.Set(arg5._key, flag3)
			end

			fn26(key, flag2, fn32)
			return tbl2
		end

		return fn28(arg3, v6.c1), (fn28(arg4, v6.c2))
	end

	uix.Slider = function(arg, arg2, arg3, arg4, arg5, arg6, arg7, arg8, arg9)
		local lib = uix.lib
		local v4 = fn25(arg2, arg9)

		local v5 = lib.sliderRow(arg, arg2, arg3, arg4, arg5, tonumber(tbl.CFG.Get(v4, arg6)) or arg6, function(arg10)
			tbl.CFG.Set(v4, arg10)
			if arg7 then
				pcall(arg7, arg10)
				return
			end
		end, arg8)

		fn26(v4, arg6, function()
			if tonumber(v5.Get()) ~= arg6 then
				v5.Set(arg6)

				if arg7 then
					pcall(arg7, arg6)
				end
			end

			tbl.CFG.Set(v4, arg6)
		end)

		return { Get = v5.Get, Set = v5.Set }
	end

	uix.Input = function(arg, arg2, arg3, arg4, arg5, arg6, arg7)
		local lib = uix.lib
		local v4 = fn25(arg2, arg7)

		local v5 = lib.inputRow(arg, arg2, arg3, tbl.CFG.Get(v4, arg4), arg5, function(arg8)
			tbl.CFG.Set(v4, arg8)
			if arg6 then
				pcall(arg6, arg8)
				return
			end
		end)

		fn26(v4, arg4, function()
			if v5.Get() ~= arg4 then
				v5.Set(arg4)

				if arg6 then
					pcall(arg6, arg4)
				end
			end

			tbl.CFG.Set(v4, arg4)
		end)

		return { Get = v5.Get, Set = v5.Set }
	end

	uix.Dropdown = function(arg, arg2, arg3, arg4, arg5, arg6, arg7, arg8)
		local lib = uix.lib
		local v4 = fn25(arg2, arg7)

		local v5 = lib.dropdownSingle(arg, arg2, arg3, function()
			local tbl2 = {}

			for _, v5 in ipairs(arg4) do
				if type(v5) == "string" and v5 ~= "" then
					tbl2[#tbl2 + 1] = { key = v5, label = v5 }
				elseif type(v5) == "number" then
					local str2 = tostring(v5)
					tbl2[#tbl2 + 1] = { key = str2, label = str2 }
				end
			end

			return tbl2
		end, function(arg9)
			if type(arg9) == "table" then
				arg9 = arg9.key or arg9
			end

			tbl.CFG.Set(v4, arg9)
			if arg6 then
				pcall(arg6, arg9)
				return
			end
		end, tbl.CFG.Get(v4, arg5), false, arg8)

		fn26(v4, arg5, function()
			if v5.Get() ~= arg5 then
				v5.Set(arg5, arg5)

				if arg6 then
					pcall(arg6, arg5)
				end
			end

			tbl.CFG.Set(v4, arg5)
		end)

		return {
			Get = v5.Get,
			Set = function(arg9)
				v5.Set(arg9, arg9)
			end,
		}
	end

	uix.DropdownMulti = function(arg, arg2, arg3, arg4, arg5, arg6, arg7)
		local lib = uix.lib
		local v4 = fn25(arg2, arg6)
		local tbl2 = {}
		local v5 = tbl.CFG.Get(v4, nil)
		local tbl3

		if type(v5) ~= "string" then
			tbl3 = v5
		else
			tbl3 = { v5 }
		end

		if type(tbl3) == "table" then
			for _, v6 in ipairs(tbl3) do
				local str2 = tostring(v6)

				if not str2:match("^table: 0x%x+$") then
					tbl2[str2] = true
				end
			end
		end

		local function fn27()
			local tbl4 = {}

			for k, v6 in pairs(tbl2) do
				if v6 then
					tbl4[#tbl4 + 1] = k
				end
			end

			table.sort(tbl4)
			return tbl4
		end

		local v6 = lib.dropdownMulti(arg, arg2, arg3, function()
			local tbl4 = {}

			for _, v6 in ipairs(arg4) do
				if type(v6) == "string" and v6 ~= "" then
					tbl4[#tbl4 + 1] = { key = v6, label = v6 }
				elseif type(v6) ~= "number" then
					if type(v6) == "table" then
						if type(v6.header) == "string" and v6.header ~= "" then
							tbl4[#tbl4 + 1] = { header = v6.header }
						else
							local key = v6.key or v6[1]

							if type(key) == "string" and key ~= "" then
								tbl4[#tbl4 + 1] = { key = key, label = tostring(v6.label or v6[2] or key) }
							end
						end
					end
				else
					local str2 = tostring(v6)
					tbl4[#tbl4 + 1] = { key = str2, label = str2 }
				end
			end

			return tbl4
		end, tbl2, function()
			tbl.CFG.Set(v4, fn27())
			if arg5 then
				pcall(arg5, tbl2, fn27())
				return
			end
		end, false, arg7)

		fn26(v4, {}, function()
			local flag2 = false

			for _, v7 in pairs(tbl2) do
				if v7 then
					flag2 = true
					break
				end
			end

			for k in pairs(tbl2) do
				tbl2[k] = nil
			end

			tbl.CFG.Set(v4, {})

			if v6 and v6.Update then
				pcall(v6.Update)
			end

			if flag2 and arg5 then
				pcall(arg5, tbl2, {})
				return
			end
		end)

		return {
			Get = function()
				return tbl2
			end,
			List = fn27,
			Has = function(arg8)
				return tbl2[tostring(arg8)] == true
			end,
			Any = function()
				for _, v7 in pairs(tbl2) do
					if v7 then
						return true
					end
				end

				return false
			end,
			Set = function(arg8)
				for k in pairs(tbl2) do
					tbl2[k] = nil
				end

				for _, v7 in ipairs(arg8 or {}) do
					tbl2[tostring(v7)] = true
				end

				tbl.CFG.Set(v4, fn27())
				if v6 and v6.Update then
					pcall(v6.Update)
					return
				end
			end,
		}
	end
end

local function resetConfig()
	for _, v4 in ipairs({ "TeleportSteal", "AutoStealEggs" }) do
		if uix.STEAL then
			local v5 = uix.STEAL[v4]

			if v5 and v5.Get and v5.Get() then
				pcall(v5.Set, false)
			end
		end
	end

	task.wait(0.2)
	tbl.CFG.Data = { __schema = tbl.CFG.Schema, Flags = {} }
	local n3 = 0
	local n4 = 0

	for _, v4 in ipairs(uix.REG) do
		local ok, result = pcall(v4.Pulih)

		if ok then
			n3 += 1
		else
			n4 += 1
			tbl.LOG.err("Reset." .. tostring(v4.Key), result)
		end
	end

	for _, v4 in ipairs({ "_closed.flag", "noui.flag" }) do
		local function fn25()
			local str2 = tbl.FS.Root .. "/" .. v4
			if tbl.FS.Exists(str2) then
				delfile(str2)
				return
			end
		end

		pcall(fn25)
	end

	tbl.CFG.Save()
	tbl.LOG.warn("RESET", ("config dikembalikan ke bawaan -- %d kontrol%s"):format(n3, not (n4 > 0) and "" or ", " .. n4 .. " GAGAL"))
	pcall(uix.Pita, ("Config reset - %d controls restored"):format(n3), 3)
	return n3, n4
end

uix.ResetConfig = resetConfig

uix.IsMobile = function()
	local ok, result = pcall(function()
		local touchEnabled = tbl.SV.UserInputService.TouchEnabled
		if touchEnabled then
			return not tbl.SV.UserInputService.KeyboardEnabled
		end
		return touchEnabled
	end)

	if ok and result then
		return result
	end
	return false
end

uix.UKURAN = { MARGIN = 0.05, CEIL_PC = 1, CEIL_HP = 2.1, FLOOR = 0.25, SISA_BAWAH = 44 }
uix.KACA = 0.07

uix.PasKaca = function(arg)
	local lib = uix.lib
	local window = lib and lib.Window
	if not window or not window.Parent then
		tbl.LOG.warn("UIX.PasKaca", "Window tidak ada - transparansi dilewati")
		return false
	end
	uix.KACA = math.clamp(tonumber(arg) or uix.KACA or 0, 0, 0.95)

	local function fn25()
		if window.Parent then
			if window.BackgroundTransparency < uix.KACA then
				window.BackgroundTransparency = uix.KACA
			end

			for _, v4 in ipairs({ "TopBar", "Sidebar" }) do
				local v5 = window:FindFirstChild(v4)

				if v5 and v5:IsA("GuiObject") and v5.BackgroundTransparency < uix.KACA then
					v5.BackgroundTransparency = uix.KACA
				end
			end

			return
		end
	end

	fn25()

	if uix._kacaCx then
		pcall(function()
			uix._kacaCx:Disconnect()
		end)
	end

	local n3 = 0

	uix._kacaCx = tbl.ST.Trove:Connect(window:GetPropertyChangedSignal("BackgroundTransparency"), function()
		n3 += 1
		local v4 = n3

		task.delay(0.3, function()
			if n3 ~= v4 then
				return
			end
			fn25()
		end)
	end)

	return true
end

uix.PasUkuran = function()
	local lib = uix.lib
	local window = lib and lib.Window
	if not window or not window.Parent then
		tbl.LOG.warn("UIX.PasUkuran", "Window tidak ada - ukuran dilewati")
		return false
	end
	local uiScale = window:FindFirstChildOfClass("UIScale")
	if not uiScale then
		tbl.LOG.warn("UIX.PasUkuran", "UIScale jendela tidak ketemu")
		return false
	end
	local ukuran = uix.UKURAN

	local function fn25()
		local offset = window.Size.X.Offset
		local offset2 = window.Size.Y.Offset

		if not (offset <= 0) then
			if not (offset2 <= 0) then
				local currentCamera = workspace.CurrentCamera
				local viewportSize = currentCamera and currentCamera.ViewportSize or Vector2.new(1280, 720)

				if not (viewportSize.X < 1) then
					if not (viewportSize.Y < 1) then
						local n3 = 1 - 2 * ukuran.MARGIN
						local n4 = math.min(viewportSize.X * n3 / offset, math.min(viewportSize.Y * n3, viewportSize.Y - 2 * ukuran.SISA_BAWAH) / offset2)
						local clamp = math.clamp
						local floor = ukuran.FLOOR

						if uix.IsMobile() then
							local ceilHp = ukuran.CEIL_HP
							if ceilHp then
								return clamp(n4, floor, ceilHp)
							end
						end

						return clamp(n4, floor, ukuran.CEIL_PC or 1)
					end

					return nil
				end

				return nil
			end

			return nil
		end

		return nil
	end

	local function fn26()
		local v4 = fn25()

		if v4 then
			if not (math.abs(uiScale.Scale - v4) < 0.001) then
				local v5 = uiScale
				v5.Scale = v4
				uiScale:SetAttribute("TargetScale", v4)
				return
			end

			return
		end
	end

	fn26()
	window.Position = UDim2.new(0.5, 0, 0.5, 0)
	tbl.ST.Trove:Connect(uiScale:GetPropertyChangedSignal("Scale"), fn26)
	tbl.ST.Trove:Connect(window:GetPropertyChangedSignal("Size"), fn26)

	local function fn27()
		local currentCamera = workspace.CurrentCamera
		if currentCamera then
			tbl.ST.Trove:Connect(currentCamera:GetPropertyChangedSignal("ViewportSize"), fn26)
			return
		end
	end

	fn27()

	local function fn28()
		fn27()
		task.defer(fn26)
	end

	tbl.ST.Trove:Connect(workspace:GetPropertyChangedSignal("CurrentCamera"), fn28)
	return true
end

uix.ICON = {
	Steal = "rbxassetid://129870722044860",
	Sell = "rbxassetid://105448686912619",
	Scramble = "rbxassetid://98847011195862",
	BigEgg = "rbxassetid://133293109122451",
	Pets = "rbxassetid://135539341404221",
	ESP = "rbxassetid://10723415766",
	Help = "rbxassetid://126528849145048",
	FPS = "rbxassetid://123623357851005",
	Hop = "rbxassetid://135306776138575",
	Discord = "rbxassetid://103385895626663",
	Settings = "rbxassetid://105075600358691",
	Order = "rbxassetid://132534369464516",
	Admin = "rbxassetid://106517676648790",
	Wisp = "rbxassetid://78063392769484",
	Mutation = "rbxassetid://134710848063255",
	Events = "rbxassetid://132534369464516",
	Race = "rbxassetid://82857133407630",
	Star = "rbxassetid://14960943986",
}

uix.ICON_RECT = { Wisp = { Vector2.new(0, 0), Vector2.new(214, 175) } }

uix.IkonRect = function(arg, arg2)
	local v4 = arg2 and uix.ICON_RECT[arg2]

	if arg then
		if v4 then
			local icon = arg:FindFirstChild("Icon")

			if icon then
				if icon:IsA("ImageLabel") or icon:IsA("ImageButton") then
					icon.ImageRectOffset = v4[1]
					icon.ImageRectSize = v4[2]
					icon.ScaleType = Enum.ScaleType.Fit
					return
				end

				return
			end

			return
		end

		return
	end
end

uix.Icon = function(arg)
	local v4 = uix.ICON[arg]
	if v4 then
		return v4
	end
	local lib = uix.lib

	if lib then
		local icons

		if lib.Icons then
			icons = lib.Icons[arg]
			if icons then
				return icons
			end
		end

		icons = lib.Icons
		if icons then
			return lib.Icons.General
		end
		return icons
	end

	return lib
end

uix.Pita = function(arg, arg2)
	local lib = uix.lib

	if lib then
		if lib.showToast then
			local str2 = tostring(arg or "")
			if str2 ~= "" then
				pcall(lib.showToast, str2, tonumber(arg2) or 5)
				return
			end
			return
		end

		return
	end
end

uix.Destroy = function()
	local lib = uix.lib

	if lib and lib.destroyPanel then
		pcall(lib.destroyPanel)
	end

	uix.Mounted = false
end

uix.BuildToast = function(arg)
	local screenGui = arg.ScreenGui

	if screenGui then
		local tweenService = tbl.SV.TweenService

		local function fn25(arg2, arg3, arg4, arg5, arg6)
			local tweenInfo = TweenInfo.new(arg3, arg5 or Enum.EasingStyle.Quart, arg6 or Enum.EasingDirection.Out)
			local v4 = pcall

			local v5, v6 = v4(function()
				return tweenService:Create(arg2, tweenInfo, arg4)
			end)

			if v5 and v6 then
				v6:Play()
				return
			end
		end

		local Frame = arg.new("Frame", {
			Parent = screenGui,
			Name = "LiveEngine",
			AnchorPoint = Vector2.new(0.5, 0),
			Position = UDim2.new(0.5, 0, 0, -45),
			Size = UDim2.new(0, 360, 0, 32),
			BackgroundColor3 = Color3.fromRGB(20, 13, 34),
			BackgroundTransparency = 1,
			BorderSizePixel = 0,
			Visible = false,
			ZIndex = 250,
		}, { arg.corner(8) })

		local UIStroke = arg.new("UIStroke", {
			Parent = Frame,
			Thickness = 1,
			Color = Color3.fromRGB(97, 61, 142),
			Transparency = 1,
		})

		local Frame2 = arg.new("Frame", {
			Parent = Frame,
			Name = "Dot",
			Size = UDim2.new(0, 8, 0, 8),
			Position = UDim2.new(0, 12, 0.5, -4),
			BackgroundColor3 = Color3.fromRGB(174, 98, 255),
			BackgroundTransparency = 1,
			BorderSizePixel = 0,
			ZIndex = 251,
		}, { arg.corner(4) })

		local TextLabel = arg.new("TextLabel", {
			Parent = Frame,
			Name = "Kabar",
			Size = UDim2.new(1, -125, 1, 0),
			Position = UDim2.new(0, 28, 0, 0),
			BackgroundTransparency = 1,
			Font = arg.FONT,
			TextSize = 12,
			TextColor3 = Color3.new(0.96078431606292725, 0.98039215803146362, 1),
			TextTransparency = 1,
			TextXAlignment = Enum.TextXAlignment.Left,
			TextTruncate = Enum.TextTruncate.AtEnd,
			Text = "idle",
			ZIndex = 251,
		})

		local TextLabel2 = arg.new("TextLabel", {
			Parent = Frame,
			Name = "Badge",
			Size = UDim2.new(0, 85, 1, 0),
			Position = UDim2.new(1, -97, 0, 0),
			BackgroundTransparency = 1,
			Font = arg.FONT_BOLD,
			TextSize = 9,
			TextColor3 = Color3.fromRGB(194, 153, 255),
			TextTransparency = 1,
			TextXAlignment = Enum.TextXAlignment.Right,
			Text = "LIVE ENGINE",
			ZIndex = 251,
		})

		local TextButton = arg.new("TextButton", {
			Parent = Frame,
			Name = "Dismiss",
			Size = UDim2.new(1, 0, 1, 0),
			BackgroundTransparency = 1,
			AutoButtonColor = false,
			Text = "",
			ZIndex = 252,
		})

		local n3 = 0
		local flag2 = false

		local function fn26()
			if flag2 then
				flag2 = false
				n3 += 1
				fn25(Frame, 0.28, { Position = UDim2.new(0.5, 0, 0, -45), BackgroundTransparency = 1 }, Enum.EasingStyle.Quad, Enum.EasingDirection.In)
				fn25(UIStroke, 0.28, { Transparency = 1 }, Enum.EasingStyle.Quad, Enum.EasingDirection.In)
				fn25(Frame2, 0.28, { BackgroundTransparency = 1 })
				fn25(TextLabel, 0.28, { TextTransparency = 1 })
				fn25(TextLabel2, 0.28, { TextTransparency = 1 })

				local function fn27()
					if Frame.Parent then
						Frame.Visible = false
						return
					end
				end

				task.delay(0.3, fn27)
				return
			end
		end

		tbl.ST.Trove:Connect(TextButton.MouseButton1Click, fn26)

		local function pita(arg2, arg3)
			if arg2 ~= "" then
				if arg2 ~= "idle" then
					n3 += 1
					local v4 = n3
					TextLabel.Text = tostring(arg2)
					Frame.Visible = true

					if flag2 then
						fn25(Frame2, 0.12, { BackgroundColor3 = Color3.new(1, 1, 1) })

						local function fn27()
							if flag2 and Frame2.Parent then
								fn25(Frame2, 0.18, { BackgroundColor3 = Color3.new(0.62745100259780884, 0.88235294818878174, 1) })
								return
							end
						end

						task.delay(0.12, fn27)
					else
						flag2 = true
						Frame.Position = UDim2.new(0.5, 0, 0, -45)
						Frame.BackgroundTransparency = 1
						UIStroke.Transparency = 1
						Frame2.BackgroundTransparency = 1
						TextLabel.TextTransparency = 1
						TextLabel2.TextTransparency = 1
						fn25(Frame, 0.32, { Position = UDim2.new(0.5, 0, 0, 16), BackgroundTransparency = 0.1 })
						fn25(UIStroke, 0.32, { Transparency = 0 })
						fn25(Frame2, 0.32, { BackgroundTransparency = 0 })
						fn25(TextLabel, 0.32, { TextTransparency = 0 })
						fn25(TextLabel2, 0.32, { TextTransparency = 0 })
					end

					local delay = task.delay

					local function fn27()
						if n3 == v4 and flag2 then
							fn26()
							return
						end
					end

					delay(arg3 or 5, fn27)
					return
				end

				return
			end
		end

		uix.Pita = pita
		uix.Toast = Frame
		local spawn = task.spawn

		local function fn27()
			local v4 = nil

			while tbl.Alive do
				if Frame.Parent then
					local ok, result = pcall(tbl.STEAL.Kabar)
					local v5 = if ok then tostring(result or "idle") else "idle"

					if v5 ~= v4 then
						pita(v5, 5)
						v4 = v5
					end

					task.wait(0.25)
					continue
				end

				return
			end
		end

		spawn(fn27)
		return
	end
end

uix.Bayar = function()
	local ok, result = pcall(tbl.STEAL.Premium)
	if ok and result then
		return result
	end
	return false
end

uix.TolakKunci = function(arg)
	uix.Pita((arg or "This feature") .. " needs Gold, Premium or Lifetime.", 4)
end

uix.STATS = { fps = nil, ms = nil }

uix.BuildStats = function(arg)
	local pillLabel = arg.PillLabel
	local window = arg.Window
	if not pillLabel or not window then
		return
	end
	local theme = arg.Theme
	local v4 = nil

	for _, child in ipairs(pillLabel.Parent:GetChildren()) do
		if child:IsA("Frame") and child.Size == UDim2.new(0, 6, 0, 6) then
			v4 = child
			break
		end
	end

	local success = theme.Success or Color3.new(0.18823529779911041, 0.81960785388946533, 0.34509804844856262)
	local danger = theme.Danger or Color3.new(1, 0.27058824896812439, 0.22745098173618317)
	local new = arg.new

	local tbl2 = {
		Parent = window,
		Name = "PingWarning",
		Size = UDim2.new(0, 250, 0, 40),
		AnchorPoint = Vector2.new(1, 0),
		Position = UDim2.new(1, -14, 0, 56),
		BackgroundColor3 = theme.Card,
		BackgroundTransparency = 0.05,
		BorderSizePixel = 0,
		Visible = false,
		ZIndex = 60,
	}

	local tbl3 = {}
	local v5 = arg.corner(8)
	local new2 = arg.new
	tbl3[1] = v5

	do
		local values = table.pack(new2("UIPadding", {
		PaddingTop = UDim.new(0, 6),
		PaddingBottom = UDim.new(0, 6),
		PaddingLeft = UDim.new(0, 10),
		PaddingRight = UDim.new(0, 10),
	}))

		table.move(values, 1, values.n, 2, tbl3)
	end

	local Frame = new("Frame", tbl2, tbl3)
	local UIStroke = arg.new("UIStroke", { Parent = Frame, Thickness = 1.2, Color = danger })

	local TextLabel = arg.new("TextLabel", {
		Parent = Frame,
		Name = "Msg",
		Size = UDim2.new(1, 0, 1, 0),
		BackgroundTransparency = 1,
		Font = arg.FONT,
		TextSize = 11,
		TextColor3 = danger,
		TextWrapped = true,
		Text = "High latency detected - stealing may be less reliable while ping stays elevated.",
		ZIndex = 61,
	})

	local n3 = 0
	local trove = tbl.ST.Trove
	local connect = trove.Connect

	local function fn25()
		n3 += 1
	end

	connect(trove, tbl.SV.RunService.RenderStepped, fn25)

	local function fn26()
		return game:FindService("Stats")
	end

	local value = select(2, pcall(fn26))

	task.spawn(function()
		local now = os.clock()

		while tbl.Alive do
			task.wait(0.5)

			if pillLabel.Parent then
				local n4 = os.clock() - now
				local v6 = n3
				now = os.clock()
				n3 = 0
				local v7 = if n4 > 0 then math.floor(v6 / n4 + 0.5) else 0

				local function fn27()
					return value.Network.ServerStatsItem["Data Ping"]:GetValue()
				end

				local ok, result = pcall(fn27)
				local v8 = if ok and type(result) == "number" and result > 0 then math.floor(result + 0.5) else nil
				local stats = uix.STATS
				uix.STATS.fps = v7
				stats.ms = v8
				local myPing = uix.HOP and uix.HOP.MyPing

				if myPing and myPing.Parent then
					myPing.Text = v8 and ("Your ping: %d ms"):format(v8) or "Your ping: -- ms"
				end

				if window.Visible then
					pillLabel.Text = ("%d stolen  •  %d FPS  •  %s"):format(tbl.STEAL.Claims or 0, v7, if v8 then v8 .. " ms" else "-- ms")
					local color

					if v7 < 30 or v8 and v8 > 150 then
						color = danger
					elseif not (v7 < 50) then
						color = success

						if v8 then
							color = success

							if v8 > 80 then
								color = Color3.new(1, 0.7450980544090271, 0.31372550129890442)
							end
						end
					else
						color = Color3.new(1, 0.7450980544090271, 0.31372550129890442)
					end

					if v4 then
						v4.BackgroundColor3 = color
					end

					if v8 then
						-- ~80 ms in the recording triggered a misleading red lag warning.
						if v8 <= 180 then
							Frame.Visible = false
						else
								local severe = v8 > 300
							UIStroke.Color = if severe then danger else Color3.new(1, 0.7450980544090271, 0.31372550129890442)
							TextLabel.TextColor3 = if severe then danger else Color3.new(1, 0.7450980544090271, 0.31372550129890442)
							Frame.Visible = true
						end
					else
						Frame.Visible = false
					end
				else
					Frame.Visible = false
				end

				continue
			end

			return
		end
	end)
end

uix.TrimTopBar = function(arg)
	local topBar = arg.Window and arg.Window:FindFirstChild("TopBar")

	if topBar then
		local flag2 = false

		for _, child in ipairs(topBar:GetChildren()) do
			if child:IsA("Frame") then
				local n3 = 0
				local n4 = 0

				for _, descendant in ipairs(child:GetDescendants()) do
					if descendant:IsA("TextButton") or descendant:IsA("ImageButton") then
						if descendant.Size ~= UDim2.new(0, 32, 0, 32) then
							n4 += 1
						else
							n3 += 1
						end
					end
				end

				if n3 == 3 and n4 == 0 then
					child.Visible = false
					flag2 = true
				end
			end
		end

		if not flag2 then
			tbl.LOG.warn("UIX", "menu ikon bilah atas tidak ketemu - bentuknya berubah")
		end

		local v4 = nil

		for _, descendant in ipairs(topBar:GetDescendants()) do
			if descendant:IsA("TextButton") and tostring(descendant.Text) == "[ ]" then
				v4 = descendant
				break
			end
		end

		if v4 then
			for _, v5 in ipairs(getconnections(v4.MouseButton1Click)) do
				local function fn25()
					v5:Disable()
				end

				pcall(fn25)
			end

			local mouseButton1Click = v4.MouseButton1Click
			local v5 = mouseButton1Click
			local connect = mouseButton1Click.Connect

			local function fn25()
				local fullSize = uix.SET and uix.SET.FullSize

				if fullSize then
					local v6 = fullSize.Get()
					fullSize.Set(not v6)
					uix.Pita(v6 and "Display: Compact" or "Display: Full Size (PC)", 3)
					return
				end

				uix.Pita("Display toggle not ready", 3)
			end

			connect(v5, fn25)
			return flag2
		end

		tbl.LOG.warn("UIX", "tombol [ ] tidak ketemu - pintasan Full Size dilewati")
		return flag2
	end
end

do
	local function buildAfk(arg)
		local screenGui = arg.ScreenGui
		if not screenGui then
			return
		end
		local theme = arg.Theme
		local afk = {}
		uix.AFK = afk
		local color = Color3.new(1, 0.78431373834609985, 0.27450981736183167)
		local new = arg.new

		local tbl2 = {
			Parent = screenGui,
			Name = "AfkLauncher",
			Size = UDim2.new(0, 132, 0, 28),
			AnchorPoint = Vector2.new(0, 0),
			BackgroundColor3 = theme.Card,
			AutoButtonColor = false,
			Font = arg.FONT_BOLD,
			TextSize = 12,
			TextColor3 = theme.Text,
			Text = "AFK Mode",
			ZIndex = 300,
		}

		local tbl3 = {}
		local v4 = arg.corner(8)
		local stroke = arg.stroke
		local border = theme.Border
		tbl3[1] = v4

		do
			local values = table.pack(stroke(border, 1))
			table.move(values, 1, values.n, 2, tbl3)
		end

		local TextButton = new("TextButton", tbl2, tbl3)

		local function fn25()
			local window = arg.Window

			if window then
				if window.Parent then
					local absolutePosition = screenGui.AbsolutePosition
					local absolutePosition2 = window.AbsolutePosition
					local absoluteSize = window.AbsoluteSize
					local n3 = absolutePosition2.X - absolutePosition.X
					local n4 = absolutePosition2.Y - absolutePosition.Y + absoluteSize.Y + 8
					local currentCamera = workspace.CurrentCamera
					local viewportSize = currentCamera and currentCamera.ViewportSize

					if viewportSize and viewportSize.Y > 1 then
						local n5 = viewportSize.Y - 28 - 4

						if n5 < n4 then
							local n6 = absolutePosition2.Y - absolutePosition.Y - 28 - 8
							n4 = if n6 >= 4 then n6 else math.clamp(n4, 4, n5)
						end
					end

					TextButton.Position = UDim2.fromOffset(n3, n4)
					TextButton.Size = UDim2.fromOffset(math.max(110, math.floor(absoluteSize.X * 0.23)), 28)
					return
				end

				return
			end
		end

		fn25()
		tbl.ST.Trove:Connect(arg.Window:GetPropertyChangedSignal("AbsolutePosition"), fn25)
		tbl.ST.Trove:Connect(arg.Window:GetPropertyChangedSignal("AbsoluteSize"), fn25)

		local Frame = arg.new("Frame", {
			Parent = screenGui,
			Name = "AfkScreen",
			Size = UDim2.new(1, 0, 1, 240),
			Position = UDim2.new(0, 0, 0, 0),
			BackgroundColor3 = Color3.new(0, 0, 0),
			BorderSizePixel = 0,
			Visible = false,
			Active = true,
			ZIndex = 900,
		})

		local Frame2 = arg.new("Frame", {
			Parent = Frame,
			Name = "Isi",
			Size = UDim2.new(1, 0, 1, 0),
			BackgroundTransparency = 1,
			ZIndex = 901,
		})

		local UIScale = arg.new("UIScale", { Parent = Frame2, Scale = 1 })

		local Frame3 = arg.new("Frame", {
			Parent = Frame2,
			Name = "Tengah",
			Size = UDim2.new(1, -48, 1, 0),
			Position = UDim2.new(0.5, 0, 0, 0),
			AnchorPoint = Vector2.new(0.5, 0),
			BackgroundTransparency = 1,
			ZIndex = 901,
		})

		local function fn26()
			local viewportSize = workspace.CurrentCamera and workspace.CurrentCamera.ViewportSize

			if viewportSize then
				if not (viewportSize.Y < 1) then
					local n3 = math.max(0, -Frame.AbsolutePosition.Y)
					Frame2.Position = UDim2.fromOffset(0, n3)
					UIScale.Scale = math.clamp(math.min(viewportSize.X / 1500, (viewportSize.Y - n3) / 850), 0.55, 1)
					local scale = UIScale.Scale
					Frame2.Size = UDim2.fromOffset(viewportSize.X / scale, math.max(200, (viewportSize.Y - n3) / scale))
					Frame3.Size = UDim2.new(0, math.min(1180, viewportSize.X / scale - 48), 1, 0)
					return
				end

				return
			end
		end

		if workspace.CurrentCamera then
			tbl.ST.Trove:Connect(workspace.CurrentCamera:GetPropertyChangedSignal("ViewportSize"), fn26)
		end

		local TextLabel = arg.new("TextLabel", {
			Parent = Frame3,
			Name = "Judul",
			Size = UDim2.new(1, 0, 0, 26),
			Position = UDim2.new(0, 0, 0, 52),
			BackgroundTransparency = 1,
			Font = arg.FONT_BOLD,
			TextSize = 20,
			TextColor3 = color,
			TextXAlignment = Enum.TextXAlignment.Left,
			Text = "AFK MODE",
			ZIndex = 901,
		})

		local TextLabel2 = arg.new("TextLabel", {
			Parent = Frame3,
			Name = "Jam",
			Size = UDim2.new(0, 260, 0, 40),
			Position = UDim2.new(0, 0, 0, 78),
			BackgroundTransparency = 1,
			Font = arg.FONT_BOLD,
			TextSize = 34,
			TextColor3 = Color3.new(0.94117647409439087, 0.96078431606292725, 1),
			TextXAlignment = Enum.TextXAlignment.Left,
			Text = "00:00:00",
			ZIndex = 901,
		})

		local TextLabel3 = arg.new("TextLabel", {
			Parent = Frame3,
			Name = "Mesin",
			Size = UDim2.new(0, 320, 0, 40),
			Position = UDim2.new(1, 0, 0, 78),
			AnchorPoint = Vector2.new(1, 0),
			BackgroundTransparency = 1,
			Font = arg.FONT_BOLD,
			TextSize = 20,
			TextColor3 = Color3.new(0.58823531866073608, 0.86274510622024536, 0.62745100259780884),
			TextXAlignment = Enum.TextXAlignment.Right,
			Text = "-- FPS   •   -- ms",
			ZIndex = 902,
		})

		local TextLabel4 = arg.new("TextLabel", {
			Parent = Frame3,
			Name = "Sub",
			Size = UDim2.new(1, -340, 0, 16),
			Position = UDim2.new(0, 0, 0, 120),
			BackgroundTransparency = 1,
			Font = arg.FONT,
			TextSize = 12,
			TextColor3 = Color3.new(0.58823531866073608, 0.60784316062927246, 0.66666668653488159),
			TextXAlignment = Enum.TextXAlignment.Left,
			Text = "",
			ZIndex = 901,
		})

		local TextButton2 = arg.new("TextButton", {
			Parent = Frame3,
			Name = "Exit",
			Size = UDim2.new(0, 104, 0, 30),
			Position = UDim2.new(1, 0, 1, -50),
			AnchorPoint = Vector2.new(1, 1),
			BackgroundColor3 = Color3.new(0.58823531866073608, 0.17647059261798859, 0.17647059261798859),
			AutoButtonColor = false,
			Font = arg.FONT_BOLD,
			TextSize = 12,
			TextColor3 = Color3.new(1, 1, 1),
			Text = "Exit AFK",
			ZIndex = 902,
		}, { arg.corner(8) })

		local TextLabel5 = arg.new("TextLabel", {
			Parent = Frame3,
			Name = "Alarm",
			Size = UDim2.new(1, 0, 0, 26),
			Position = UDim2.new(0, 0, 0, 142),
			BackgroundColor3 = Color3.new(0.22745098173618317, 0.086274512112140656, 0.078431375324726105),
			BorderSizePixel = 0,
			Font = arg.FONT_BOLD,
			TextSize = 13,
			TextColor3 = Color3.new(1, 0.47058823704719543, 0.4117647111415863),
			Text = "",
			Visible = false,
			ZIndex = 901,
		}, { arg.corner(6) })

		local function fn27(arg2, arg3, arg4)
			local Frame4 = arg.new("Frame", {
				Parent = Frame3,
				Name = arg4,
				Size = UDim2.new(arg3, -16, 1, -290),
				Position = UDim2.new(arg2, 16, 0, 178),
				BackgroundTransparency = 1,
				ZIndex = 901,
			})

			arg.new("TextLabel", {
				Parent = Frame4,
				Name = "Head",
				Size = UDim2.new(1, 0, 0, 18),
				BackgroundTransparency = 1,
				Font = arg.FONT_BOLD,
				TextSize = 12,
				TextColor3 = color,
				TextXAlignment = Enum.TextXAlignment.Left,
				Text = arg4,
				ZIndex = 902,
			})

			return Frame4, (arg.new("ScrollingFrame", {
				Parent = Frame4,
				Name = "List",
				Size = UDim2.new(1, 0, 1, -24),
				Position = UDim2.new(0, 0, 0, 24),
				BackgroundTransparency = 1,
				BorderSizePixel = 0,
				ScrollBarThickness = 3,
				CanvasSize = UDim2.new(),
				AutomaticCanvasSize = Enum.AutomaticSize.Y,
				ZIndex = 902,
			}, { arg.new("UIListLayout", { Padding = UDim.new(0, 4), SortOrder = Enum.SortOrder.LayoutOrder }) }))
		end

		local eggsStolenThisSession, v5 = fn27(0, 0.62, "EGGS STOLEN THIS SESSION")
		local activeFeatures, v6 = fn27(0.62, 0.38, "ACTIVE FEATURES")

		local TextLabel6 = arg.new("TextLabel", {
			Parent = Frame3,
			Name = "Kaki",
			Size = UDim2.new(1, -130, 0, 16),
			Position = UDim2.new(0, 0, 1, -66),
			BackgroundTransparency = 1,
			Font = arg.FONT,
			TextSize = 12,
			TextColor3 = Color3.new(0.58823531866073608, 0.60784316062927246, 0.66666668653488159),
			TextXAlignment = Enum.TextXAlignment.Left,
			Text = "",
			ZIndex = 901,
		})

		local duit = tbl.STEAL.Duit
		local n3 = -1

		local function fn28()
			while true do
				(nil)[nil] = "HOP"
				;(nil).HOP = 3
			end
		end

		local tbl4 = { "STEAL", "SELL", "SCR", "RIFT", "ESP", "GUARD", "HELP", "FPS", "HOP", "WEBHOOK", "SET" }
		local str2 = ""

		local function fn29()
			local tbl5 = {}

			for _, v7 in ipairs(tbl4) do
				local v8 = uix[v7]

				if type(v8) == "table" then
					for _, v9 in pairs(v8) do
						if type(v9) == "table" and v9.Label and type(v9.Get) == "function" then
							local ok, result = pcall(v9.Get)

							if ok and result == true then
								tbl5[#tbl5 + 1] = v9.Label
							end
						end
					end
				end
			end

			table.sort(tbl5)
			local str3 = table.concat(tbl5, "|")

			if str3 ~= str2 then
				str2 = str3
				local v7 = ipairs

				for _, child in v7(v6:GetChildren()) do
					if child:IsA("GuiObject") then
						child:Destroy()
					end
				end

				if #tbl5 == 0 then
					tbl5[1] = "Nothing is enabled."
				end

				for i, v8 in ipairs(tbl5) do
					arg.new("TextLabel", {
						Parent = v6,
						LayoutOrder = i,
						Size = UDim2.new(1, -6, 0, 17),
						BackgroundTransparency = 1,
						Font = arg.FONT,
						TextSize = 12,
						TextColor3 = Color3.new(0.58823531866073608, 0.86274510622024536, 0.62745100259780884),
						TextXAlignment = Enum.TextXAlignment.Left,
						TextTruncate = Enum.TextTruncate.AtEnd,
						Text = "•  " .. v8,
						ZIndex = 903,
					})
				end

				return
			end
		end

		task.spawn(function()
			while tbl.Alive do
				if Frame.Visible then
					local ok, result = pcall(function()
						local v7 = tbl.STEAL.AFKM.Ringkas()
						TextLabel2.Text = tbl.STEAL.AFKM.Waktu(v7.detik)
						TextLabel6.Text = ("Delivered %d  •  Failed %d  •  %.1f eggs/hour  •  Total %s/s  •  %.2f KG"):format(v7.klaim, v7.gagal, v7.perJam, duit(v7.laju), v7.berat)
						TextLabel4.Text = tostring(tbl.STEAL.Kabar())
						local stats = uix.STATS or {}
						local fps = stats.fps
						local ms = stats.ms
						TextLabel3.Text = ("%s   •   %s"):format(if fps then fps .. " FPS" else "-- FPS", if ms then ms .. " ms" else "-- ms")
						local v8 = TextLabel3
						local color2

						if (not fps or not (fps < 30)) and (not ms or not (ms > 150)) then
							color2 = if (not fps or not (fps < 50)) and (not ms or not (ms > 80)) then Color3.new(0.58823531866073608, 0.86274510622024536, 0.62745100259780884) else Color3.new(1, 0.7450980544090271, 0.31372550129890442)
						else
							color2 = Color3.new(1, 0.47058823704719543, 0.4117647111415863)
						end

						v8.TextColor3 = color2
						fn28(tbl.STEAL.AFKM.telur)
						fn29()
						local dc = tbl.STEAL.DC

						if dc and dc.lapor then
							TextLabel5.Text = "  DISCONNECTED - the session has ended."
							TextLabel5.Visible = true
							return
						end
					end)

					if not ok then
						tbl.LOG.warn("AFKM", "detak layar: " .. tostring(result))
					end
				end

				task.wait(1)
			end
		end)

		local function buka()
			tbl.STEAL.AFKM.Start()
			n3 = -1
			str2 = ""
			TextLabel5.Visible = false
			TextLabel.Text = "AFK MODE"
			TextLabel4.Text = ""
			Frame.Visible = true
			fn26()
		end

		local function tutup()
			tbl.STEAL.AFKM.Stop()
			Frame.Visible = false
		end

		tbl.ST.Trove:Connect(TextButton.MouseButton1Click, buka)
		tbl.ST.Trove:Connect(TextButton2.MouseButton1Click, tutup)
		afk.Buka = buka
		afk.Tutup = tutup
		afk.Layar = Frame
		afk.Pill = TextButton
	end

	uix.BuildAfk = buildAfk
end

uix.Gate = function()
	local v4, v5 = tbl.STEAL.Temukan()

	if #v5 ~= 0 then
		local v6 = uix.Lib()

		if v6 and v6.showCenterModalWarning then
			local v7 = pcall
			local showCenterModalWarning = v6.showCenterModalWarning

			local tbl2 = {
				Title = "Incompatible Server",
				Text = ("This build is missing %d part%s the script needs: %s. Move to another server to continue."):format(#v5, #v5 ~= 1 and "s" or "", table.concat(v5, ", ")),
				Button = "Move Server",
			}

			local function callback()
				task.spawn(function()
					pcall(tbl.STEAL.HOP.Emptiest, true)
				end)
			end

			tbl2.Callback = callback
			v7(showCenterModalWarning, tbl2)
		end

		tbl.LOG.warn("GATE", ("panel ditahan - %d jalur wajib hilang: %s"):format(#v5, table.concat(v5, ", ")))
		return false
	end

	return true
end

uix.Mounted = false

do
	uix.Pages = {}
	local nav = {}
	local tbl2 = { id = "events", label = "Events" }
	tbl2.icon = "Events"
	nav[1] = { id = "admin", label = "Admin Abuse", icon = "Admin", sorot = true, saklar = "AdminAbuse" }
	nav[2] = { id = "steal", label = "Steal", icon = "Steal" }
	nav[3] = { id = "sell", label = "Sell Eggs & Pets", icon = "Sell" }
	nav[4] = { id = "mutation", label = "Egg Mutation", icon = "Mutation" }
	nav[5] = tbl2
	nav[6] = { id = "order", label = "Task Order", icon = "Order" }
	nav[7] = { id = "bigegg", label = "Big Egg", icon = "BigEgg" }
	nav[8] = { id = "rideguard", label = "Ride Guard", icon = "Pets" }
	nav[9] = { id = "esp", label = "Egg ESP", icon = "ESP" }
	nav[10] = { id = "fps", label = "FPS Boost", icon = "FPS" }
	nav[11] = { id = "hop", label = "Server Hop", icon = "Hop" }
	nav[12] = { id = "webhook", label = "Webhook", icon = "Discord" }
	nav[13] = { id = "settings", label = "Settings", icon = "Settings" }
	uix.NAV = nav
end

uix.Mount = function()
	if uix.Mounted then
		return
	end
	uix.REG = {}
	local v4 = uix.Lib()

	if v4 then
		local tbl2 = {}

		for _, v5 in ipairs(uix.NAV) do
			if v5.saklar ~= nil then
				if tbl.FLAG[v5.saklar] then
					tbl2[#tbl2 + 1] = v5
				end
			else
				tbl2[#tbl2 + 1] = v5
			end
		end

		for i, v5 in ipairs(tbl2) do
			uix.Pages[v5.id] = v4.makePage(v5.id)
			local v6 = v4.navItem(v5.label, v5.id, i, uix.Icon(v5.icon))
			pcall(uix.IkonRect, v6, v5.icon)

			if v5.sorot then
				pcall(uix.SorotNav, v6)
			end
		end

		local stealPageOk, stealPageErr = pcall(uix.BuildSteal, v4, uix.Pages.steal)
		if not stealPageOk then
			tbl.LOG.err("UIX.page.steal", tostring(stealPageErr))
		end

		for _, v5 in ipairs({
			{ "sell", uix.BuildSell },
			{ "mutation", uix.BuildMutation },
			{ "esp", uix.BuildESP },
			{ "rideguard", uix.BuildGuard },
			{ "hop", uix.BuildHop },
			{ "webhook", uix.BuildWebhook },
			{ "fps", uix.BuildFPS },
			{ "bigegg", uix.BuildBigEgg },
			{ "settings", uix.BuildSettings },
			{ "admin", uix.BuildAdmin },
			{ "events", uix.BuildEvents },
			{ "order", uix.BuildOrder },
		}) do
			if uix.Pages[v5[1]] then
				local ok, result = pcall(v5[2], v4, uix.Pages[v5[1]])

				if not ok then
					tbl.LOG.err("UIX.page." .. v5[1], result)
				end
			end
		end

		local ok, result = pcall(uix.BuildChat, v4)

		if not ok then
			tbl.LOG.err("UIX.chat", result)
		end

		local ok2, result2 = pcall(uix.BuildToast, v4)

		if not ok2 then
			tbl.LOG.err("UIX.toast", result2)
		end

		local ok3, result3 = pcall(uix.BuildStats, v4)

		if not ok3 then
			tbl.LOG.err("UIX.stats", result3)
		end

		pcall(uix.TrimTopBar, v4)
		local ok4, result4 = pcall(uix.BuildAfk, v4)

		if not ok4 then
			tbl.LOG.err("UIX.afk", result4)
		end

		local Page = tbl.CFG.Get("UI.Page", "steal")

		if not uix.Pages[Page] then
			Page = "steal"
		end

		pcall(v4.switchPage, Page)

		local function fn25()
			task.wait(0.5)

			local function fn26(arg, arg2)
				local v5 = uix[arg]
				local v6 = arg2

				for _, v7 in ipairs(v6) do
					if v5 then
						local v8 = v5[v7]

						if v8 and v8.Sync then
							local ok5, result5 = pcall(v8.Sync)

							if not ok5 then
								tbl.LOG.err("Sync." .. arg .. "." .. v7, result5)
							end
						end
					end
				end
			end

			local teleportSteal = uix.STEAL.TeleportSteal
			local autoStealEggs = uix.STEAL.AutoStealEggs
			local antiHitGuard = uix.STEAL.AntiHitGuard

			if teleportSteal then
				if autoStealEggs and teleportSteal.Get() and autoStealEggs.Get() then
					autoStealEggs.Set(false, true)
				end

				if teleportSteal.Get() then
					if antiHitGuard and antiHitGuard.Get() then
						antiHitGuard.Set(false, true)
					end
				elseif autoStealEggs and autoStealEggs.Get() and antiHitGuard and antiHitGuard.Get() then
					antiHitGuard.Set(false, true)
				end
			elseif autoStealEggs and autoStealEggs.Get() and antiHitGuard and antiHitGuard.Get() then
				antiHitGuard.Set(false, true)
			end

			fn26("STEAL", { "RealGodmode", "AntiHitGuard", "AutoTreadmill", "InstantCarry", "OneTapSteal" })
			fn26("EGGS", { "AutoHatchReady", "AutoPlaceAllEgg", "AutoPlaceSelected", "AutoPlaceRarity" })
			fn26("SELL", { "AutoEgg", "AutoPet" })
			fn26("MUTASI", { "MutAuto" })
			fn26("ESP", { "MyPen", "OtherPen", "AreaEgg" })
			fn26("FPS", { "Boost", "DeleteOthers" })
			local tbl3 = {}
			tbl3[1] = "AntiAfk"
			fn26("SET", tbl3)
			fn26("GUARD", { "Ride" })
			fn26("AA", { "Instant", "Capture", "Esp", "Ring" })
			local autoExec = uix.HOP and uix.HOP.AutoExec

			if autoExec then
				if autoExec.Sync then
					pcall(autoExec.Sync)
				end

				if autoExec.Get and autoExec.Get() then
					pcall(tbl.STEAL.HOP.SetClosed, false)
					pcall(tbl.STEAL.HOP.Arm)
				else
					pcall(tbl.STEAL.HOP.SetClosed, true)
				end
			else
				pcall(tbl.STEAL.HOP.SetClosed, true)
				pcall(tbl.STEAL.WH.Sync)
				fn26("SCR", { "Buy", "LabEgg", "LabAuto" })
				fn26("RACE", { "Auto", "Goal", "Equip", "Beli" })
				fn26("STAR", { "Auto" })
				fn26("STEAL", { "TeleportSteal", "AutoStealEggs" })
				return
			end

			pcall(tbl.STEAL.WH.Sync)
			fn26("SCR", { "Buy", "LabEgg", "LabAuto" })
			fn26("RACE", { "Auto", "Goal", "Equip", "Beli" })
			fn26("STAR", { "Auto" })
			fn26("STEAL", { "TeleportSteal", "AutoStealEggs" })
		end

		task.spawn(fn25)
		pcall(tbl.STEAL.TAG.Start)
		pcall(uix.PasUkuran)
		pcall(uix.PasKaca)
		uix.Mounted = true
		tbl.LOG.warn("UIX", "panel Black UI terpasang")
		return
	end

	tbl.LOG.err("UIX", "panel tidak dipasang - pustaka tidak ada")
end

uix.EVENT_TAB = {
	{ id = "race", label = "Race Events", icon = "Race", build = { "BuildRace", "BuildStar" } },
	{ id = "wisp", label = "Wisp Event", icon = "Wisp", build = { "BuildWisp" } },
	{ id = "scramble", label = "Dr. Scramble", icon = "Scramble", build = { "BuildScramble" } },
}

uix.BuildOrder = function(arg, arg2)
	uix.ORDER = {}
	local order = uix.ORDER
	local n3 = 0

	local function fn25()
		n3 += 1
		return n3
	end

	local function fn26()
		local v4 = tbl
		return v4.STEAL.ORDER
	end

	local function fn27()
		local tbl2 = {}

		for _, v4 in ipairs(fn26().URUT) do
			tbl2[#tbl2 + 1] = v4
		end

		tbl.CFG.Set("TaskOrderPrioritas", tbl2)
	end

	pcall(function()
		local TaskOrderPrioritas = tbl.CFG.Get("TaskOrderPrioritas", nil)
		if type(TaskOrderPrioritas) ~= "table" then
			return
		end
		local v4 = fn26()
		local n4 = 1

		for _, TaskOrderPriorita in ipairs(TaskOrderPrioritas) do
			if v4.TUGAS[TaskOrderPriorita] then
				v4.SetPrioritas(TaskOrderPriorita, n4)
				n4 += 1
			end
		end

		for _, v5 in ipairs(v4.URUT) do
			local v6, v7, v8 = ipairs(TaskOrderPrioritas)
			local flag2 = false

			for _, v9 in v6, v7, v8 do
				if v9 ~= v5 then
					continue
				end
				flag2 = true
				break
			end

			if not flag2 then
				v4.SetPrioritas(v5, n4)
				n4 += 1
			end
		end
	end)

	uix.Section(arg2, "Task Order", fn25(), true)
	local textRow = arg.textRow
	local v4 = fn25()
	order.Info = textRow(arg2, "Arbiter: -", v4)
	fn26().AKTIF = true
	uix.Section(arg2, "Order", fn25(), true)

	local function fn28(arg3, arg4)
		local v5 = fn26()
		local label = v5.URUT[arg3]

		if label then
			local n4 = arg3 + arg4

			if n4 < 1 or #v5.URUT < n4 then
				local v6 = v5.TUGAS[label]
				local pita = uix.Pita
				local str2 = "%s is already %s."
				local format = ("%s is already %s.").format

				if v6 then
					label = v6.label or label
				end

				pita(format(str2, label, arg4 < 0 and "first" or "last"), 3)
				return
			end

			local v6 = v5.URUT[n4]
			v5.SetPrioritas(label, n4)
			v5.SetPrioritas(v6, arg3)

			for i, v7 in ipairs(v5.URUT) do
				v5.SetPrioritas(v7, i)
			end

			fn27()
			return
		end
	end

	local textRow2 = arg.textRow
	local v5 = fn25()
	local v6 = textRow2(arg2, "", v5)
	local parent

	if v6 then
		parent = v6.Parent

		pcall(function()
			v6:Destroy()
		end)
	else
		parent = v6
	end

	order.Baris = {}

	if parent then
		local theme = arg.Theme

		for i = 1, #fn26().URUT do
			local frame = Instance.new("Frame")
			frame.Name = ("Baris%d"):format(i)
			frame.BackgroundTransparency = 1
			frame.Size = UDim2.new(1, 0, 0, 26)
			frame.LayoutOrder = fn25()
			frame.Parent = parent

			local function createTextButton(arg3, text, arg4)
				local textButton = Instance.new("TextButton")
				textButton.Name = "Turun"
				textButton.Size = UDim2.new(0, 18, 0, 18)
				textButton.Position = UDim2.new(0, arg3, 0.5, -9)
				textButton.BackgroundColor3 = Color3.fromRGB(42, 29, 65)
				textButton.BackgroundTransparency = 0.25
				textButton.BorderSizePixel = 0
				textButton.Text = text
				textButton.TextSize = 11
				textButton.Font = Enum.Font.GothamBold
				textButton.TextColor3 = Color3.new(0.80392158031463623, 0.84313726425170898, 0.90196079015731812)
				textButton.AutoButtonColor = true
				textButton.Parent = frame
				local uiCorner = Instance.new("UICorner")
				uiCorner.CornerRadius = UDim.new(0, 5)
				uiCorner.Parent = textButton
				local trove = tbl.ST.Trove
				local v7 = trove
				local connect = trove.Connect

				local function fn29()
					fn28(i, arg4)
				end

				connect(v7, textButton.MouseButton1Click, fn29)
				return textButton
			end

			createTextButton(0, "▲", -1)
			createTextButton(22, "▼", 1)
			local textLabel = Instance.new("TextLabel")
			textLabel.Name = "Nama"
			textLabel.BackgroundTransparency = 1
			textLabel.Position = UDim2.new(0, 48, 0, 0)
			textLabel.Size = UDim2.new(0.5, -48, 1, 0)
			textLabel.Font = Enum.Font.Gotham
			textLabel.TextSize = 14
			textLabel.TextXAlignment = Enum.TextXAlignment.Left
			textLabel.TextTruncate = Enum.TextTruncate.AtEnd
			textLabel.TextColor3 = theme and theme.TextSecondary or Color3.new(0.66666668653488159, 0.70588237047195435, 0.76470589637756348)
			textLabel.Text = ("%d. -"):format(i)
			textLabel.Parent = frame
			local textLabel2 = Instance.new("TextLabel")
			textLabel2.Name = "Status"
			textLabel2.BackgroundTransparency = 1
			textLabel2.Position = UDim2.new(0.5, 0, 0, 0)
			textLabel2.Size = UDim2.new(0.5, 0, 1, 0)
			textLabel2.Font = Enum.Font.Gotham
			textLabel2.TextSize = 13
			textLabel2.TextXAlignment = Enum.TextXAlignment.Right
			textLabel2.TextTruncate = Enum.TextTruncate.AtEnd
			textLabel2.TextColor3 = theme and theme.TextSecondary or Color3.new(0.66666668653488159, 0.70588237047195435, 0.76470589637756348)
			textLabel2.Text = "-"
			textLabel2.Parent = frame
			order.Baris[i] = { teks = textLabel, stat = textLabel2, frame = frame }
		end
	else
		tbl.LOG.warn("UIX.order", "kartu section tidak ketemu - panah dilewati")

		for i = 1, #fn26().URUT do
			local baris = order.Baris
			local tbl2 = {}
			local textRow3 = arg.textRow
			local str2 = ("%d. -"):format(i)
			local v7 = fn25()
			tbl2.teks = textRow3(arg2, str2, v7)
			baris[i] = tbl2
		end
	end

	local function fn29()
		local v7 = fn26()

		for k, defaultPriority in pairs(v7.DEFAULT_PRIORITIES) do
			v7.SetPrioritas(k, defaultPriority)
		end

		for i, v8 in ipairs(v7.URUT) do
			v7.SetPrioritas(v8, i)
		end

		fn27()
		uix.Pita("Task order reset to default.", 3)
	end

	arg.buttonRow(arg2, "Reset To Default Order", fn25(), fn29)

	task.spawn(function()
		while tbl.Alive do
			if arg2.Visible then
				pcall(function()
					local v7 = fn26().Potret()
					order.Info.Text = v7.aktif and ("Arbiter: %s"):format(tostring(v7.status)) or "Arbiter OFF - every feature runs ungated"
					order.Info.TextColor3 = v7.aktif and arg.Theme.TextSecondary or Color3.new(0.92156863212585449, 0.66666668653488159, 0.29411765933036804)

					for i, bari in ipairs(order.Baris) do
						local teks = bari.teks
						local v8 = v7.tugas[i]

						if v8 then
							local text, color

							if v8.aktif then
								text = ("RUNNING  %.0fs"):format(v7.umur)
								color = Color3.new(0.35294118523597717, 0.84313726425170898, 0.47058823704719543)
							elseif v8.siap then
								text = "ready - waiting its turn"
								color = Color3.new(0.92156863212585449, 0.66666668653488159, 0.29411765933036804)
							else
								color = arg.Theme.TextSecondary
								text = "nothing to do"
							end

							if bari.stat then
								teks.Text = ("%d.  %s"):format(i, v8.label)
								bari.stat.Text = text
								bari.stat.TextColor3 = color
								teks.Font = v8.nyala and Enum.Font.GothamBold or Enum.Font.Gotham
								teks.TextColor3 = v8.nyala and (arg.Theme.Text or Color3.new(1, 1, 1)) or arg.Theme.TextSecondary
							else
								teks.Text = ("%d.  %-18s %s"):format(i, v8.label, text)
								teks.TextColor3 = color
							end
						else
							teks.Text = ("%d. -"):format(i)

							if bari.stat then
								bari.stat.Text = ""
							end
						end
					end
				end)
			end

			task.wait(1)
		end
	end)
end

uix.BuildEvents = function(arg, parent)
	uix.EV = { tab = {}, milik = {}, aktif = nil }
	local ev = uix.EV
	local theme = arg.Theme
	local frame = Instance.new("Frame")
	frame.Name = "EventTabs"
	frame.BackgroundTransparency = 1
	frame.Size = UDim2.new(1, 0, 0, 38)
	frame.LayoutOrder = 0
	frame.Parent = parent
	local uiListLayout = Instance.new("UIListLayout")
	uiListLayout.FillDirection = Enum.FillDirection.Horizontal
	uiListLayout.Padding = UDim.new(0, 6)
	uiListLayout.SortOrder = Enum.SortOrder.LayoutOrder
	uiListLayout.VerticalAlignment = Enum.VerticalAlignment.Center
	uiListLayout.Parent = frame
	local n3 = 231133369

	local function pilih(aktif)
		if ev.aktif ~= aktif then
			ev.aktif = aktif
			local v4 = pairs
			local v5 = ev

			if n3 == 445091007 then
				for k, v6 in v4(v5.milik) do
					local visible = k == aktif

					for _, v7 in ipairs(v6) do
						if v7.Parent then
							v7.Visible = visible
						end
					end
				end

				if parent:IsA("ScrollingFrame") then
					parent.CanvasPosition = Vector2.zero
				end

				local v6 = pairs

				if n3 ~= 445091007 then
					n3 = bit32.bxor(n3, 3518342931)
				end

				for k, v7 in v6(ev.tab) do
					local visible = k == aktif
					v7.BackgroundColor3 = visible and theme.CardActive or theme.Card
					v7.BackgroundTransparency = visible and 0 or 0.45
					local label = v7:FindFirstChild("Label")

					if label then
						label.TextColor3 = visible and theme.Text or theme.TextSecondary
					end

					local icon = v7:FindFirstChild("Icon")

					if icon then
						icon.ImageTransparency = visible and 0 or 0.45
					end

					local aktif2 = v7:FindFirstChild("Aktif")

					if aktif2 then
						aktif2.Visible = visible
					end
				end

				return
			end
		end
	end

	n3 = bit32.bxor(n3, 390159366)
	ev.Pilih = pilih

	for i, v4 in ipairs(uix.EVENT_TAB) do
		local textButton = Instance.new("TextButton")
		textButton.Name = v4.id
		textButton.Text = ""
		textButton.AutoButtonColor = false
		textButton.BorderSizePixel = 0
		textButton.BackgroundColor3 = theme.Card
		textButton.BackgroundTransparency = 0.35
		textButton.Size = UDim2.new(0, 132, 1, -6)
		textButton.LayoutOrder = i
		textButton.Parent = frame
		arg.corner(textButton, 8)
		local imageLabel = Instance.new("ImageLabel")
		imageLabel.Name = "Icon"
		imageLabel.BackgroundTransparency = 1
		imageLabel.Size = UDim2.new(0, 18, 0, 18)
		imageLabel.Position = UDim2.new(0, 10, 0.5, -9)
		imageLabel.Image = uix.Icon(v4.icon)
		imageLabel.Parent = textButton
		uix.IkonRect(textButton, v4.icon)
		local textLabel = Instance.new("TextLabel")
		textLabel.Name = "Label"
		textLabel.BackgroundTransparency = 1
		textLabel.Text = v4.label
		textLabel.Font = arg.FONT
		textLabel.TextSize = 13
		textLabel.TextXAlignment = Enum.TextXAlignment.Left
		textLabel.TextColor3 = theme.TextSecondary
		textLabel.Position = UDim2.new(0, 34, 0, 0)
		textLabel.Size = UDim2.new(1, -40, 1, 0)
		textLabel.Parent = textButton
		local frame2 = Instance.new("Frame")
		frame2.Name = "Aktif"
		frame2.BorderSizePixel = 0
		frame2.BackgroundColor3 = Color3.new(0.94117647409439087, 0.76470589637756348, 0.37254902720451355)
		frame2.Size = UDim2.new(1, -20, 0, 2)
		frame2.Position = UDim2.new(0, 10, 1, -4)
		frame2.Visible = false
		frame2.Parent = textButton
		arg.corner(frame2, 1)
		local mouseButton1Click = textButton.MouseButton1Click
		local v5 = mouseButton1Click
		local connect = mouseButton1Click.Connect

		local function fn25()
			pilih(v4.id)
		end

		connect(v5, fn25)
		ev.tab[v4.id] = textButton
	end

	local function fn25()
		local tbl2 = {}

		for _, child in ipairs(parent:GetChildren()) do
			tbl2[child] = true
		end

		return tbl2
	end

	for _, v4 in ipairs(uix.EVENT_TAB) do
		local v5 = fn25()
		local tbl2 = {}

		for i, v6 in ipairs(v4.build) do
			local v7 = uix[v6]

			if type(v7) == "function" then
				local tbl3 = {}

				for _, child in ipairs(parent:GetChildren()) do
					tbl3[child] = true
				end

				local ok, result = pcall(v7, arg, parent)

				if ok and i > 1 then
					local n4 = (i - 1) * 1000

					for _, child in ipairs(parent:GetChildren()) do
						if not tbl3[child] and child:IsA("GuiObject") then
							child.LayoutOrder = child.LayoutOrder + n4
						end
					end
				elseif not ok then
					tbl.LOG.err("UIX", ("%s gagal dibangun: %s"):format(v6, tostring(result)))
					local textLabel = Instance.new("TextLabel")
					textLabel.BackgroundTransparency = 1
					textLabel.Size = UDim2.new(1, 0, 0, 28)
					textLabel.Font = arg.FONT
					textLabel.TextSize = 13
					textLabel.TextColor3 = Color3.new(0.92156863212585449, 0.66666668653488159, 0.29411765933036804)
					textLabel.Text = v6 .. " failed to load - see console"
					textLabel.Parent = parent
				end
			end
		end

		for _, child in ipairs(parent:GetChildren()) do
			if not v5[child] and child:IsA("GuiObject") and child ~= frame then
				tbl2[#tbl2 + 1] = child
			end
		end

		ev.milik[v4.id] = tbl2
	end

	ev.aktif = nil
	pilih(uix.EVENT_TAB[1].id)
end

uix.BuildStar = function(arg, arg2)
	uix.STAR = {}
	local star = uix.STAR
	local n3 = 0

	local function fn25()
		n3 += 1
		return n3
	end

	local function fn26()
		local steal2 = tbl.STEAL
		return steal2.STAR
	end

	uix.Section(arg2, "Shooting Star", fn25(), true)
	local textRow = arg.textRow
	local v4 = fn25()
	star.Info = textRow(arg2, "Star: -", v4)
	local textRow2 = arg.textRow
	local v5 = fn25()
	star.Status = textRow2(arg2, "Status: idle", v5)

	local function fn27(arg3)
		local v6 = fn26()
		if arg3 then
			v6.Start()
			return
		end
		v6.Stop()
	end

	star.Auto = uix.Toggle(arg2, "Auto Catch Star", fn25(), false, fn27, "StarAutoCatch")

	star.Pulang = uix.Toggle(arg2, "Return Home After Catch", fn25(), true, function(arg3)
		fn26().PULANG = arg3 and true or false
	end, "StarReturnHome")

	fn26().PULANG = star.Pulang.Get and star.Pulang.Get() or true

	task.spawn(function()
		while tbl.Alive do
			if arg2.Visible then
				pcall(function()
					local v6 = fn26()

					if v6.Ada() then
						local v7 = v6.Posisi()
						local character = tbl.SV.Players.LocalPlayer.Character
						local humanoidRootPart = character and character:FindFirstChild("HumanoidRootPart")
						local v8 = if v7 and humanoidRootPart then math.floor((v7 - humanoidRootPart.Position).Magnitude) else -1
						star.Info.Text = ("Star: %s%s"):format(v6.Mendarat() and "LANDED" or "falling", v8 >= 0 and ("   |   %d studs away"):format(v8) or "")
						star.Info.TextColor3 = Color3.new(0.35294118523597717, 0.84313726425170898, 0.47058823704719543)
					else
						star.Info.Text = ("No star right now - spawns in %s, %.2f%% per cycle, lives 2-5 min"):format(tostring(v6.Flag("LandAreaId", "Cosmic")), (tonumber(v6.Flag("SpawnChancePerCycle", 0.0005)) or 0) * 100)
						star.Info.TextColor3 = arg.Theme.TextSecondary
					end

					star.Status.Text = ("Status: %s   |   caught this session: %d"):format(tostring(v6.Status), v6.tangkap or 0)
				end)
			end

			task.wait(1)
		end
	end)
end

local function buildRace(arg, arg2)
	uix.RACE = {}
	local race2 = uix.RACE
	local n3 = 0

	local function fn25()
		n3 += 1
		return n3
	end

	local function fn26()
		return tbl.STEAL.RACE
	end

	uix.Section(arg2, "Race Rally", fn25(), true)
	local textRow = arg.textRow
	local v4 = fn25()
	race2.Jadwal = textRow(arg2, "Next race: unknown", v4)
	local textRow2 = arg.textRow
	local v5 = fn25()
	race2.Fase = textRow2(arg2, "Phase: --", v5)
	local textRow3 = arg.textRow
	local v6 = fn25()
	race2.Posisi = textRow3(arg2, "Status: idle", v6)

	local function fn27(arg3)
		local v7 = fn26()
		if arg3 then
			v7.Start()
			return
		end
		v7.Stop()
	end

	race2.Auto = uix.Toggle(arg2, "Auto Race", fn25(), false, fn27, "RaceAuto")

	race2.Laju = uix.Slider(arg2, "Race Speed", fn25(), fn26().LAJU_MIN, fn26().LAJU_MAKS, fn26().LAJU_RAIL, function(arg3)
		fn26().LAJU_RAIL = tonumber(arg3) or 270
	end, " studs/s", "RaceSpeed")

	fn26().LAJU_RAIL = tonumber(race2.Laju.Get()) or fn26().LAJU_RAIL
	uix.Section(arg2, "Rewards & Shop", fn25(), true)
	local textRow4 = arg.textRow
	local v7 = fn25()
	race2.Shop = textRow4(arg2, "Trophies: -  |  wins: -  |  racer: -", v7)

	race2.Goal = uix.Toggle(arg2, "Auto Claim Goals", fn25(), false, function(arg3)
		local v8 = fn26()
		v8.AutoGoal = arg3 and true or false
		v8.ShopSync()
	end, "RaceAutoGoal")

	local function fn28(arg3)
		local v8 = fn26()
		v8.AutoEquip = arg3 and true or false
		v8.ShopSync()
	end

	race2.Equip = uix.Toggle(arg2, "Auto Equip Best Racer", fn25(), false, fn28, "RaceAutoEquip")
	local tbl2 = {}

	local function fn29()
		table.clear(tbl2)

		for _, v8 in ipairs(fn26().Offers()) do
			tbl2[#tbl2 + 1] = { key = tostring(v8.id), label = ("%s  (%d)"):format(v8.id, v8.harga) }
		end

		return #tbl2
	end

	fn29()

	local function fn30(arg3)
		local str2 = tostring(arg3)
		return (str2:gsub("%s+%(%d+%)$", ""))
	end

	local function fn31(arg3)
		local beliPilih = {}
		local tbl3 = {}
		local v8 = ipairs

		for _, v9 in v8(arg3 or {}) do
			local v10 = fn30(v9)

			if v10 ~= "" and not tbl3[v10] then
				tbl3[v10] = true
				beliPilih[#beliPilih + 1] = v10
			end
		end

		fn26().BeliPilih = beliPilih
	end

	race2.BeliPilih = uix.DropdownMulti(arg2, "Shop Items To Buy", fn25(), tbl2, function(arg3, arg4)
		fn31(arg4)
	end, "RaceBuyOffers")

	fn31(race2.BeliPilih.Get())

	if #tbl2 == 0 then
		task.spawn(function()
			for i = 1, 30 do
				task.wait(2)

				if tbl.Alive then
					if not (fn29() > 0) then
						continue
					end
					tbl.LOG.info("RACE", ("daftar toko terisi belakangan: %d offer"):format(#tbl2))
					return
				end

				return
			end
		end)
	end

	race2.Beli = uix.Toggle(arg2, "Auto Buy Racing Event", fn25(), false, function(arg3)
		local v8 = fn26()
		v8.AutoBeli = arg3 and true or false
		v8.ShopSync()
	end, "RaceAutoBuy")

	task.spawn(function()
		while tbl.Alive do
			if arg2.Visible then
				pcall(function()
					local v8 = fn26()
					local v9 = v8.Berikut()
					local n4 = tonumber(v8.Bendera("ScheduleIntervalSeconds", 1800)) or 1800
					local n5 = tonumber(v8.Bendera("JoinSeconds", 60)) or 60
					local v10 = v8.JendelaBuka()

					if v8.Fase then
						race2.Jadwal.Text = ("Race is LIVE right now - phase %s"):format(tostring(v8.Fase))
						race2.Jadwal.TextColor3 = Color3.new(0.35294118523597717, 0.84313726425170898, 0.47058823704719543)
					elseif v10 then
						race2.Jadwal.Text = ("JOIN WINDOW OPEN - %s left to join"):format(v8.Jam(v10))
						race2.Jadwal.TextColor3 = Color3.new(0.35294118523597717, 0.84313726425170898, 0.47058823704719543)
					elseif v9 then
						race2.Jadwal.Text = ("Next race in %s   (every %d min, %ds to join)"):format(v8.Jam(v9), math.floor(n4 / 60), n5)
						race2.Jadwal.TextColor3 = arg.Theme.TextSecondary
					else
						race2.Jadwal.Text = "Next race: unknown - game schedule module not found"
						race2.Jadwal.TextColor3 = Color3.new(0.92156863212585449, 0.66666668653488159, 0.29411765933036804)
					end

					local v11, v12, v13 = v8.Boleh()
					local str2

					if v11 ~= nil then
						str2 = v11 and "eligible" or ("NOT eligible - need %s speed, you have %s"):format(tostring(math.floor(v12)), tostring(math.floor(v13 or 0)))
					else
						str2 = ("Speed ?/%s"):format(uix.Ringkas and uix.Ringkas(v12) or tostring(v12))
					end

					race2.Fase.Text = ("Phase: %s   |   Laps: %d   |   Joined: %s   |   %s"):format(tostring(v8.Fase or "none"), v8.Laps(), v8.Ikut() and "yes" or "no", str2)
					race2.Fase.TextColor3 = if v11 ~= false then arg.Theme.TextSecondary else Color3.new(0.92156863212585449, 0.66666668653488159, 0.29411765933036804)
					local localPlayer2 = tbl.SV.Players.LocalPlayer
					local attribute = localPlayer2:GetAttribute("RacePlace")
					local attribute2 = localPlayer2:GetAttribute("RaceLap")
					local posisi = race2.Posisi
					local str3 = "Status: %s%s"
					local format = ("Status: %s%s").format
					local str4 = tostring(v8.Status)
					local str5

					if attribute then
						local v14 = tostring
						str5 = ("   |   Place %s, lap %s"):format(tostring(attribute), v14(attribute2)) or ""
					else
						str5 = ""
					end

					posisi.Text = format(str3, str4, str5)

					if race2.Shop then
						local v14 = v8.RaceProfil()

						if v14 then
							race2.Shop.Text = ("Trophies: %s  |  wins: %s  |  racer: %s  |  %s"):format(tostring(v14.Tokens or 0), tostring(v14.Wins or 0), tostring(v14.EquippedRacer or "-"), tostring(v8.ShopStatus))
							race2.Shop.TextColor3 = arg.Theme.TextSecondary
							return
						end

						race2.Shop.Text = "Race profile not loaded yet"
						race2.Shop.TextColor3 = Color3.new(0.92156863212585449, 0.66666668653488159, 0.29411765933036804)
						return
					end
				end)
			end

			task.wait(1)
		end
	end)
end

uix.BuildRace = buildRace

uix.BuildAdmin = function(arg, arg2)
	uix.AA = {}
	local aa = uix.AA
	local n3 = 0

	local function fn25()
		n3 += 1
		return n3
	end

	local function fn26()
		local v4 = tbl
		return v4.STEAL.AA
	end

	local section = uix.Section
	local v4 = fn25()
	section(arg2, "Admin Abuse & Exploits", v4)
	local textRow = arg.textRow
	local v5 = fn25()
	aa.AAWarn = textRow(arg2, "Only works during an Admin Abuse event. Outside the event no egg will be picked up and the forced speed can get you killed.", v5)

	local function fn27()
		aa.AAWarn.TextColor3 = Color3.new(0.92156863212585449, 0.66666668653488159, 0.29411765933036804)
	end

	pcall(fn27)

	aa.Instant = uix.Toggle(arg2, "Instant Steal", fn25(), false, function(arg3)
		tbl.STEAL.Instant(arg3)
	end, "AAInstantSteal")

	aa.Capture = uix.Toggle(arg2, "Auto Capture The Egg", fn25(), false, function(arg3)
		local v6 = fn26()
		if arg3 then
			v6.CTE.Start()
			return
		end
		v6.CTE.Stop()
	end, "AACaptureEgg")

	local section2 = uix.Section
	local v6 = fn25()
	section2(arg2, "Visual ESP", v6)

	local function fn28(arg3)
		local rar = {}

		for k, v7 in pairs(arg3 or {}) do
			if v7 then
				rar[tostring(k)] = true
			end
		end

		fn26().ESP.RAR = rar
	end

	aa.EspRar = uix.DropdownMulti(arg2, "ESP Rarities", fn25(), tbl.STEAL.RarityList(), fn28, "AAEspRarity")

	if not aa.EspRar.Any() then
		aa.EspRar.Set({ "Divine", "Eternal", "Secret", "Cosmic" })
	end

	fn28(aa.EspRar.Get())

	aa.EspDist = uix.Slider(arg2, "Rare ESP Distance", fn25(), 200, 5000, 1500, function(jarak)
		fn26().ESP.JARAK = jarak
	end, " stud", "AAEspDist")

	fn26().ESP.JARAK = aa.EspDist.Get()

	local function fn29(arg3)
		local v7 = fn26()
		if arg3 then
			v7.ESP.Start()
			return
		end
		v7.ESP.Stop()
	end

	aa.Esp = uix.Toggle(arg2, "Rare Egg ESP", fn25(), false, fn29, "AARareEggESP")
	local section3 = uix.Section
	local v7 = fn25()
	section3(arg2, "Light vs Darkness", v7)

	local function fn30(arg3)
		local v8 = fn26()
		if arg3 then
			v8.RING.Start()
			return
		end
		v8.RING.Stop()
	end

	aa.Ring = uix.Toggle(arg2, "Auto Collect Rings", fn25(), false, fn30, "AAAutoRings")
end

uix.SorotNav = function(parent)
	if parent then
		for _, v4 in ipairs({ "Label", "Icon" }) do
			local v5 = parent:FindFirstChild(v4)

			if v5 then
				local uiGradient = Instance.new("UIGradient")
				uiGradient.Color = ColorSequence.new(Color3.new(0.94117647409439087, 0.76470589637756348, 0.37254902720451355))
				uiGradient.Parent = v5
			end
		end

		local uiStroke = Instance.new("UIStroke")
		uiStroke.Color = Color3.new(0.94117647409439087, 0.76470589637756348, 0.37254902720451355)
		uiStroke.Thickness = 1
		uiStroke.Transparency = 0.45
		uiStroke.Parent = parent
		local frame = Instance.new("Frame")
		frame.Name = "Sorot"
		frame.Size = UDim2.new(0, 3, 0.62000000476837158, 0)
		frame.Position = UDim2.new(0, 0, 0.18999999761581421, 0)
		frame.BorderSizePixel = 0
		frame.BackgroundColor3 = Color3.new(0.94117647409439087, 0.76470589637756348, 0.37254902720451355)
		frame.ZIndex = 17
		frame.Parent = parent
		local uiCorner = Instance.new("UICorner")
		uiCorner.CornerRadius = UDim.new(0, 2)
		uiCorner.Parent = frame
		return
	end
end

uix.BuildSteal = function(arg, arg2)
	local v4 = uix
	local v5 = uix
	uix.STEAL = {}
	v4.FILTER = {}
	v5.EGGS = {}
	local steal2 = uix.STEAL
	local filter = uix.FILTER
	local eggs = uix.EGGS
	local n3 = 0

	local function fn25()
		n3 += 1
		return n3
	end

	local section = uix.Section
	local v6 = fn25()
	section(arg2, "Auto Steal", v6)

	steal2.TeleportSteal = uix.ToggleSatu(arg2, fn25(), {
		label = "Teleport Steal",
		key = "TeleportSteal",
		locked = tbl.FLAG.TeleportStealPremium,
		onChange = function(arg3)
			if arg3 then
				if tbl.STEAL.TSBoleh() then
					local antiHitGuard = uix.STEAL.AntiHitGuard

					if antiHitGuard and antiHitGuard.Get() then
						antiHitGuard.Set(false, true)
						tbl.STEAL.AHG.Stop()
					end

					local autoStealEggs = uix.STEAL.AutoStealEggs

					if autoStealEggs and autoStealEggs.Get() then
						autoStealEggs.Set(false, true)
					end

					tbl.STEAL.Start()
					return
				end

				local teleportSteal = uix.STEAL.TeleportSteal

				if teleportSteal then
					teleportSteal.Set(false, true)
				end

				tbl.LOG.warn("STEAL", "Teleport Steal khusus Gold / Premium / Lifetime")
				return
			end

			tbl.STEAL.Stop()
		end,
	})

	steal2.AutoStealEggs = uix.Toggle(arg2, "Auto Steal Eggs", fn25(), false, function(arg3)
		if arg3 then
			local antiHitGuard = uix.STEAL.AntiHitGuard

			if antiHitGuard and antiHitGuard.Get() then
				antiHitGuard.Set(false, true)
				tbl.STEAL.AHG.Stop()
			end

			local teleportSteal = uix.STEAL.TeleportSteal

			if teleportSteal and teleportSteal.Get() then
				teleportSteal.Set(false, true)
			end

			tbl.STEAL.Start()
			return
		end

		tbl.STEAL.Stop()
	end, "AutoStealEggs")

	-- Diagnostic controls remain available even if movement/claiming breaks.
	local status = arg.textRow(arg2, "Auto Steal Status: Idle", fn25())
	local errorRows = {}
	for i = 1, 5 do
		errorRows[i] = arg.textRow(arg2, if i == 1 then "Error Details: none captured" else "", fn25())
	end
	local function showCycleError()
		local raw = tostring(tbl.STEAL.LastCycleError or "No cycle exception captured yet. Re-enable Auto Steal and try again.")
		local compact = raw:gsub("[\r\n\t]+", " | ")
		for i, label in ipairs(errorRows) do
			if label and label.Parent then
				local startAt = (i - 1) * 62 + 1
				local chunk = compact:sub(startAt, startAt + 61)
				label.Text = if i == 1 then "Error Details: " .. (chunk ~= "" and chunk or "none") else chunk
			end
		end
	end
	arg.buttonRow(arg2, "Copy Full Auto Steal Error", fn25(), function()
		local info = tbl.STEAL.DiagnoseAutoSteal()
		local report = ("S2r Hub Auto Steal | running=%s | place=%s | mapped=%s | current=%s | eggs=%s | slots=%s | eligible=%s | carry=%s | activity=%s | order=%s | errors=%s | last error:\n%s")
			:format(tostring(info.running), tostring(info.placeValid), tostring(info.mappedVersion), tostring(info.currentVersion),
				tostring(info.records), tostring(info.slots), tostring(info.eligible), tostring(info.carryRemote),
				tostring(info.activity), tostring(info.order), tostring(info.lastCycleErrorCount), tostring(info.lastCycleError))
			report = report .. ("\nTeleport Steal: allowed=%s, enabled=%s, current player=%s")
			:format(tostring(info.teleportAllowed), tostring(info.teleportEnabled), tostring(tbl.PLR and tbl.PLR.Name or "unknown"))
		local reasons = info.exclusions
		if reasons then
			report = report .. ("\nScan reasons: own=%s forest=%s event=%s no-position=%s area=%s pet=%s rarity=%s KG=%s value=%s accepted=%s")
				:format(tostring(reasons.own), tostring(reasons.forest), tostring(reasons.event),
					tostring(reasons.noPosition), tostring(reasons.area), tostring(reasons.pet),
					tostring(reasons.rarity), tostring(reasons.kg), tostring(reasons.value), tostring(reasons.accepted))
		end
		local copied = type(setclipboard) == "function" and pcall(setclipboard, report)
		if not copied and type(toclipboard) == "function" then copied = pcall(toclipboard, report) end
		pcall(uix.Pita, copied and "Full error copied. Paste it into chat." or "Clipboard unavailable. Screenshot the Error Details rows.", 6)
	end)
	arg.buttonRow(arg2, "Check Auto Steal", fn25(), function()
		local info = tbl.STEAL.DiagnoseAutoSteal()
		local message = ("Auto Steal: %s | eggs %d, slots %d, eligible %d | TP %s/%s | %s")
			:format(info.running and "ON" or "OFF", info.records, info.slots, info.eligible,
				info.teleportAllowed and "allowed" or "locked", info.teleportEnabled and "on" or "off", info.hint)
		tbl.LOG.warn("S2rHub.Diagnose", message .. " | " .. tostring(info.error or "no scan error") .. " | " .. info.order
			.. " | speed=" .. tostring(info.speed) .. "/" .. tostring(info.speedCap)
			.. " | Forest=" .. tostring(info.forest) .. " | missing position=" .. tostring(info.missingPositions)
			.. " | reasons=" .. (info.exclusions and tbl.SV.HttpService:JSONEncode(info.exclusions) or "none")
			.. " | carry remote=" .. tostring(info.carryRemote)
			.. " | remote=" .. tostring(info.remoteError) .. " | cycle=" .. tostring(info.lastCycleError))
		pcall(uix.Pita, message, 8)
		if status then status.Text = message end
		showCycleError()
	end)
	task.spawn(function()
		local previousError = nil
		while tbl.Alive and status and status.Parent do
			local currentError = tbl.STEAL.LastCycleError
			if currentError ~= previousError then
				showCycleError()
				previousError = currentError
			end
			-- Informational monitor only. Toggle onChange and startup Sync own the
			-- engine lifecycle. A stale GUI read must never stop a live steal run.
			local toggle = tbl.UIX and tbl.UIX.STEAL and tbl.UIX.STEAL.AutoStealEggs
			local desired = toggle and toggle.Get and toggle.Get()
			local activity = tostring(tbl.STEAL.Activity or "idle")
			if tbl.STEAL.Running then
				local mode = tbl.STEAL.TSOn() and "TELEPORT" or "AUTO"
				status.Text = ("%s: RUNNING | %s | claimed %d | failed %d")
					:format(mode, activity, tbl.STEAL.Claims or 0, tbl.STEAL.Fails or 0)
			elseif desired then
				status.Text = "Auto Steal: requested ON, engine stopped — try toggling OFF/ON"
			else
				status.Text = "Auto Steal: OFF"
			end
			task.wait(2)
		end
	end)

	steal2.RealGodmode = uix.Toggle(arg2, "Real Godmode (Aura Bat, Anti Ragdoll)", fn25(), false, function(arg3)
		if arg3 then
			tbl.STEAL.GOD.Start()
			return
		end
		tbl.STEAL.GOD.Stop()
	end, "RealGodmode")

	steal2.AutoPlacePen = uix.Toggle(arg2, "Auto Place to Pen", fn25(), false, nil, "AutoPlacePen")

	steal2.AutoTreadmill = uix.Toggle(arg2, "Auto Treadmill", fn25(), false, function(arg3)
		if arg3 then
			tbl.STEAL.TM.Start()
			return
		end
		tbl.STEAL.TM.Stop()
	end, "AutoTreadmill")

	steal2.StealMethod = uix.Dropdown(arg2, "Steal Method", fn25(), tbl.STEAL.METODE.PILIHAN, tbl.STEAL.METODE.PILIHAN[1], nil, "StealMethod")
	steal2.AutoStealSpeed = uix.Slider(arg2, "Auto Steal Speed", fn25(), 10, 100, 90, nil, "%", "AutoStealSpeed")
	local section2 = uix.Section
	local v7 = fn25()
	section2(arg2, "Filter Tools", v7)
	filter.PetNames = uix.DropdownMulti(arg2, "Pet Names", fn25(), tbl.STEAL.PetList(), nil, "PetNames")
	filter.Areas = uix.DropdownMulti(arg2, "Areas", fn25(), tbl.STEAL.AreaList(), nil, "Areas")
	filter.Rarities = uix.DropdownMulti(arg2, "Rarities", fn25(), tbl.STEAL.RarityList(), nil, "Rarities")
	filter.Priority = uix.Dropdown(arg2, "Priority", fn25(), { "Rarity", "Value", "Size", "Closest", "Farthest" }, "Rarity", nil, "Priority")
	filter.MinEggValue = uix.Input(arg2, "Min Value (ex: 1M/1B)", fn25(), "0", "0", nil, "MinEggValue")
	filter.MinEggKG = uix.Input(arg2, "Min Egg KG (0 = off)", fn25(), "0", "0", nil, "MinEggKG")
	arg.buttonRow(arg2, "Reset Auto Steal Filters", fn25(), function()
		for _, key in ipairs({ "PetNames", "Areas", "Rarities" }) do
			local control = filter[key]
			if control and control.Set then control.Set({}) end
		end
		for _, key in ipairs({ "MinEggValue", "MinEggKG" }) do
			local control = filter[key]
			if control and control.Set then control.Set("0") end
		end
		pcall(uix.Pita, "Auto Steal filters cleared. All permitted areas and egg types now qualify.", 5)
	end)
	local section3 = uix.Section
	local v8 = fn25()
	section3(arg2, "Steal Tools", v8)

	steal2.AntiHitGuard = uix.Toggle(arg2, "Anti Hit Guard", fn25(), false, function(arg3)
		if arg3 then
			local flag2 = false

			for _, v9 in ipairs({ "TeleportSteal", "AutoStealEggs" }) do
				local v10 = uix.STEAL[v9]

				if v10 and v10.Get() then
					v10.Set(false, true)
					flag2 = true
				end
			end

			if flag2 then
				tbl.STEAL.Stop()
			end

			tbl.STEAL.AHG.Start()
			return
		end

		tbl.STEAL.AHG.Stop()
	end, "AntiHitGuard")

	steal2.InstantCarry = uix.Toggle(arg2, "Instant Carry Rare Egg (Manual Steal)", fn25(), false, function(arg3)
		if arg3 then
			tbl.STEAL.IC.Start()
			return
		end
		tbl.STEAL.IC.Stop()
	end, "InstantCarry")

	steal2.OneTapSteal = uix.Toggle(arg2, "One Tap Steal (No Hold)", fn25(), false, function()
		tbl.STEAL.TAP.Sync()
	end, "OneTapSteal")

	tbl.CFG.Set("InvisibleRig", false)

	steal2.Invisible = uix.Toggle(arg2, "Invisible Mode", fn25(), false, function()
		tbl.STEAL.INVIS.Sync()
	end, "InvisibleRig")

	local section4 = uix.Section
	local v9 = fn25()
	local stealFromSpecificPlayer = section4(arg2, "Steal From Specific Player", v9)
	local textRow = arg.textRow
	local v10 = fn25()
	steal2.RampokStatus = textRow(arg2, "Idle.", v10)

	local Frame = arg.new("Frame", {
		Parent = stealFromSpecificPlayer or arg2,
		Name = "PlayerList",
		Size = UDim2.new(1, 0, 0, 0),
		AutomaticSize = Enum.AutomaticSize.Y,
		BackgroundTransparency = 1,
		LayoutOrder = 999,
	}, { arg.new("UIListLayout", { Padding = UDim.new(0, 6), SortOrder = Enum.SortOrder.LayoutOrder }) })

	local v11 = nil
	local color = Color3.new(0.43137255311012268, 0.86274510622024536, 0.50980395078659058)
	local color2 = Color3.new(1, 0.78431373834609985, 0.27450981736183167)

	local function fn26(arg3)
		if steal2.RampokStatus and steal2.RampokStatus.Parent then
			local rampokStatus = steal2.RampokStatus
			local str2 = tostring(arg3 or "idle"):sub(1, 1)
			local v12 = tostring
			local str3 = arg3 or "idle"
			rampokStatus.Text = str2:upper() .. v12(str3):sub(2) .. "."
			return
		end
	end

	tbl.STEAL.RAMPOK.Dengar(fn26)
	local tbl2 = {}

	local function fn27(arg3)
		if Frame:IsDescendantOf(game) then
			if Frame.Visible then
				local parent = Frame.Parent
				if parent and not parent.Visible then
					return
				end

				for _, child in ipairs(Frame:GetChildren()) do
					if child:IsA("GuiObject") then
						child:Destroy()
					end
				end

				table.clear(tbl2)
				local n4 = 0

				for _, v12 in ipairs(arg3) do
					if v12.bawa then
						n4 += 1
					end
				end

				local new = arg.new

				new("TextLabel", {
					Parent = Frame,
					LayoutOrder = 0,
					Size = UDim2.new(1, 0, 0, 15),
					BackgroundTransparency = 1,
					Font = arg.FONT_BOLD,
					TextSize = 11,
					TextColor3 = if n4 > 0 then Color3.new(0.43137255311012268, 0.86274510622024536, 0.50980395078659058) else arg.Theme.TextSecondary,
					TextXAlignment = Enum.TextXAlignment.Left,
					Text = ("%d players%s"):format(#arg3, n4 > 0 and ("  •  %d carrying an egg"):format(n4) or ""),
				})

				if #arg3 ~= 0 then
					local rampok = tbl.STEAL.RAMPOK

					for i, v12 in ipairs(arg3) do
						local new2 = arg.new

						local tbl3 = {
							Parent = Frame,
							LayoutOrder = i,
							Size = UDim2.new(1, 0, 0, v12.bawa and 58 or 44),
							BackgroundColor3 = if v12.bawa then Color3.new(0.086274512112140656, 0.10196078568696976, 0.086274512112140656) else arg.Theme.Card,
							BorderSizePixel = 0,
						}

						local tbl4 = {}
						local v13 = arg.corner(8)
						local new3 = arg.new

						local tbl5 = {
							Thickness = 1,
							Color = if v12.bawa then Color3.new(0.43137255311012268, 0.86274510622024536, 0.50980395078659058) else arg.Theme.Border,
							Transparency = v12.bawa and 0.45 or 0,
						}

						local v14 = table.pack(new3("UIStroke", tbl5))
						tbl4[1] = v13

						do
							local values = table.pack(table.unpack(v14, 1, v14.n))
							table.move(values, 1, values.n, 2, tbl4)
						end

						local Frame2 = new2("Frame", tbl3, tbl4)

						arg.new("TextLabel", {
							Parent = Frame2,
							Name = "Nama",
							BackgroundTransparency = 1,
							Size = UDim2.new(1, -92, 0, 16),
							Position = UDim2.new(0, 10, 0, 6),
							Font = arg.FONT_BOLD,
							TextSize = 13,
							TextColor3 = if v12.bawa then Color3.new(0.43137255311012268, 0.86274510622024536, 0.50980395078659058) else arg.Theme.Text,
							TextXAlignment = Enum.TextXAlignment.Left,
							TextTruncate = Enum.TextTruncate.AtEnd,
							Text = v12.nama,
						})

						arg.new("TextLabel", {
							Parent = Frame2,
							Name = "Sub",
							BackgroundTransparency = 1,
							Size = UDim2.new(1, -92, 0, 13),
							Position = UDim2.new(0, 10, 0, 23),
							Font = arg.FONT,
							TextSize = 11,
							TextColor3 = arg.Theme.TextSecondary,
							TextXAlignment = Enum.TextXAlignment.Left,
							TextTruncate = Enum.TextTruncate.AtEnd,
							Text = ("@%s  •  %s%s"):format(v12.user, v12.dimana, v12.jarak and ("  •  %d studs"):format(v12.jarak) or ""),
						})

						if v12.bawa then
							arg.new("TextLabel", {
								Parent = Frame2,
								Name = "Telur",
								BackgroundTransparency = 1,
								Size = UDim2.new(1, -92, 0, 14),
								Position = UDim2.new(0, 10, 0, 38),
								Font = arg.FONT_BOLD,
								TextSize = 11,
								TextColor3 = color2,
								TextXAlignment = Enum.TextXAlignment.Left,
								TextTruncate = Enum.TextTruncate.AtEnd,
								Text = ("%s  •  %s%s"):format(tostring(v12.telur), tostring(v12.rarity), if v12.nilai then "  •  " .. tbl.STEAL.Duit(v12.nilai) .. "/s" else ""),
							})
						end

						local new4 = arg.new

						local tbl6 = {
							Parent = Frame2,
							Name = "Btn",
							Size = UDim2.new(0, 72, 0, 26),
							Position = UDim2.new(1, -82, 0.5, -13),
							AnchorPoint = Vector2.new(0, 0.5),
							BackgroundColor3 = arg.Theme.CardHover,
							AutoButtonColor = false,
							Font = arg.FONT_BOLD,
							TextSize = 12,
							TextColor3 = arg.Theme.Text,
							Text = "Steal",
						}

						local tbl7 = {}
						local v15 = arg.corner(6)
						local stroke = arg.stroke
						local border = arg.Theme.Border
						tbl7[1] = v15

						do
							local values = table.pack(stroke(border, 1))
							table.move(values, 1, values.n, 2, tbl7)
						end

						local TextButton = new4("TextButton", tbl6, tbl7)
						tbl2[v12.player] = TextButton

						if rampok.on then
							TextButton.Text = rampok.target == v12.player and "Chasing" or "Busy"
							TextButton.TextColor3 = if rampok.target == v12.player then Color3.new(0.43137255311012268, 0.86274510622024536, 0.50980395078659058) else arg.Theme.TextSecondary
						elseif v12.bawa then
							if v12.bisa then
								TextButton.TextColor3 = color
								local mouseButton1Click = TextButton.MouseButton1Click
								local v16 = mouseButton1Click
								local connect = mouseButton1Click.Connect

								local function fn28()
									local v17, v18 = tbl.STEAL.RAMPOK.Kejar(v12.player)
									if v17 then
										return
									end
									TextButton.Text = "No Egg"
									TextButton.TextColor3 = Color3.new(1, 0.47058823704719543, 0.4117647111415863)

									if uix.Pita then
										uix.Pita(("Cannot steal from %s: %s"):format(v12.nama, tostring(v18)), 4)
									end

									task.delay(1.6, function()
										if TextButton.Parent then
											TextButton.Text = "Steal"
											TextButton.TextColor3 = color
											return
										end
									end)
								end

								connect(v16, fn28)
							else
								TextButton.Text = "Too Close"
								TextButton.TextColor3 = arg.Theme.TextSecondary
							end
						else
							TextButton.Text = "No Egg"
							TextButton.TextColor3 = arg.Theme.TextSecondary
						end
					end

					return
				end

				arg.new("TextLabel", {
					Parent = Frame,
					LayoutOrder = 1,
					Size = UDim2.new(1, 0, 0, 18),
					BackgroundTransparency = 1,
					Font = arg.FONT,
					TextSize = 12,
					TextColor3 = arg.Theme.TextSecondary,
					TextXAlignment = Enum.TextXAlignment.Left,
					Text = "Nobody else is in this server.",
				})

				return
			end

			return
		end
	end

	arg.buttonRow(arg2, "Stop Chase", fn25(), function()
		tbl.STEAL.RAMPOK.Henti()
		if uix.Pita then
			uix.Pita("Chase stopped.", 3)
			return
		end
	end)

	task.spawn(function()
		while tbl.Alive do
			if Frame.Parent then
				if arg2.Visible then
					local v12 = nil
					local flag2 = false
					local spawn = task.spawn

					local function fn28()
						local ok, result = pcall(tbl.STEAL.RAMPOK.Daftar)

						if not ok or not result then
							result = nil
						end

						v12 = result
						flag2 = true
					end

					spawn(fn28)
					local n4 = os.clock() + 2

					while not flag2 do
						if os.clock() < n4 then
							task.wait()
							continue
						end
						break
					end

					if v12 then
						local tbl3 = {}

						for _, v13 in ipairs(v12) do
							tbl3[#tbl3 + 1] = ("%s|%s|%s|%s|%s"):format(v13.user, tostring(v13.bawa), tostring(v13.telur), tostring(v13.bisa), tostring(v13.jarak))
						end

						tbl3[#tbl3 + 1] = tostring(tbl.STEAL.RAMPOK.on)
						tbl3[#tbl3 + 1] = tostring(tbl.STEAL.RAMPOK.target)
						local str2 = table.concat(tbl3, ";")

						if str2 ~= v11 then
							v11 = str2
							pcall(fn27, v12)
						end
					end
				end

				task.wait(2)
				continue
			end

			break
		end
	end)

	uix.HELP = {}
	local section5 = uix.Section
	local v12 = fn25()
	section5(arg2, "Help Player", v12)
	uix.HELP.DropBeforeSafe = uix.Toggle(arg2, "Drop Egg Before Safe Zone", fn25(), false, nil, "DropEggBeforeSafeZone")
	local section6 = uix.Section
	local v13 = fn25()
	section6(arg2, "Automation & Egg Management", v13)

	eggs.PetNamesAutoPlace = uix.DropdownMulti(arg2, "Pet Names (Auto Place)", fn25(), tbl.STEAL.PetList(), function()
		tbl.STEAL.PLACE.Sync()
	end, "PlacePetNames")

	eggs.AutoHatchReady = uix.ToggleSatu(arg2, fn25(), {
		label = "Auto Hatch Ready",
		key = "AutoHatchReady",
		onChange = function(arg3)
			if arg3 then
				tbl.STEAL.HATCH.Start()
				return
			end
			tbl.STEAL.HATCH.Stop()
		end,
	})

	local toggleSatu = uix.ToggleSatu
	local v14 = fn25()
	local tbl3 = { label = "Auto Place All Egg", key = "AutoPlaceAllEgg" }

	local function onChange()
		tbl.STEAL.PLACE.Sync()
	end

	tbl3.onChange = onChange
	eggs.AutoPlaceAllEgg = toggleSatu(arg2, v14, tbl3)

	eggs.AutoPlaceSelected = uix.Toggle(arg2, "Auto Place Selected (By Pet Names Filter)", fn25(), false, function()
		tbl.STEAL.PLACE.Sync()
	end, "AutoPlaceSelected")

	eggs.RarityAutoPlace = uix.DropdownMulti(arg2, "Rarity (Auto Place)", fn25(), tbl.STEAL.RarityList(), function()
		tbl.STEAL.PLACE.Sync()
	end, "PlaceRarities")

	eggs.AutoPlaceRarity = uix.Toggle(arg2, "Auto Place Selected (By Rarity Filter)", fn25(), false, function()
		tbl.STEAL.PLACE.Sync()
	end, "AutoPlaceRarity")
end

uix.BuildSell = function(arg, arg2)
	uix.SELL = {}
	local sell = uix.SELL
	local n3 = 0

	local function fn25()
		n3 += 1
		return n3
	end

	local section = uix.Section
	local v4 = fn25()
	section(arg2, "Sell Egg Filter", v4)
	sell.EggValue = uix.Input(arg2, "Sell Below Value (cth 100M, 0=off)", fn25(), "", "cth 100M", nil, "SellEggValue")
	sell.EggKG = uix.Input(arg2, "Sell Below KG (0=off)", fn25(), "0", "0", nil, "SellEggKG")

	local function fn26()
		tbl.STEAL.SELL.AutoSync()
	end

	sell.AutoEgg = uix.Toggle(arg2, "Auto Sell Egg", fn25(), false, fn26, "AutoSellEgg")

	local function fn27()
		task.spawn(tbl.STEAL.SELL.Once, true, false, true)
	end

	arg.buttonRow(arg2, "Sell Eggs Now", fn25(), fn27)
	local section2 = uix.Section
	local v5 = fn25()
	section2(arg2, "Sell Pet Filter", v5)
	sell.PetNames = uix.DropdownMulti(arg2, "Pet Names (per area)", fn25(), tbl.STEAL.PetList(), nil, "SellPetNames")
	sell.PetValue = uix.Input(arg2, "Sell Below Value (cth 100M, 0=off)", fn25(), "", "cth 100M", nil, "SellPetValue")
	sell.PetKG = uix.Input(arg2, "Sell Below KG (0=off)", fn25(), "0", "0", nil, "SellPetKG")

	local function fn28()
		tbl.STEAL.SELL.AutoSync()
	end

	sell.AutoPet = uix.Toggle(arg2, "Auto Sell Pet", fn25(), false, fn28, "AutoSellPet")

	arg.buttonRow(arg2, "Sell Pets Now", fn25(), function()
		task.spawn(tbl.STEAL.SELL.Once, false, true, true)
	end)

	local section3 = uix.Section
	local v6 = fn25()
	section3(arg2, "Bag Inventory & Live Value", v6)
	local textRow = arg.textRow
	local v7 = fn25()
	sell.BagValue = textRow(arg2, "Total Bag Value: $0", v7)
	local textRow2 = arg.textRow
	local v8 = fn25()
	sell.BagCount = textRow2(arg2, "Total Items in Bag: 0", v8)
	local textRow3 = arg.textRow
	local v9 = fn25()
	sell.BagBreakdown = textRow3(arg2, "-", v9)
	local duit = tbl.STEAL.Duit

	local function fn29()
		local ok, result, result2, result3, result4 = pcall(tbl.STEAL.SELL.Bag)

		if ok then
			if result then
				sell.BagValue.Text = "Total Bag Value: " .. duit(result2 + result4)
				sell.BagCount.Text = ("Total Items in Bag: %d"):format(result + result3)
				sell.BagBreakdown.Text = ("%d Eggs (%s)  •  %d Pets (%s)"):format(result, duit(result2), result3, duit(result4))
				return
			end

			return
		end
	end

	local function fn30()
		task.spawn(fn29)
	end

	arg.buttonRow(arg2, "Refresh Bag Value", fn25(), fn30)

	task.spawn(function()
		while tbl.Alive do
			if arg2.Visible then
				fn29()
			end

			task.wait(3)
		end
	end)
end

uix.BuildMutation = function(arg, arg2)
	uix.MUTASI = {}
	local mutasi = uix.MUTASI
	local n3 = 0

	local function fn25()
		n3 += 1
		return n3
	end

	uix.Section(arg2, "Egg Mutation", fn25(), true)
	local textRow = arg.textRow
	local v4 = fn25()
	mutasi.MutStatus = textRow(arg2, "Idle.", v4)
	local tbl2 = {}
	local tbl3 = {}

	local function fn26()
		local tbl4 = {}

		for k, v5 in pairs(tbl2) do
			if v5 then
				tbl4[#tbl4 + 1] = k
			end
		end

		local sort = table.sort
		sort(tbl4)
		tbl.CFG.Set("MutJenis", tbl4)
	end

	local function fn27()
		local tbl4 = {}

		for k, v5 in pairs(tbl3) do
			if v5 then
				tbl4[#tbl4 + 1] = k
			end
		end

		table.sort(tbl4)
		tbl.CFG.Set("MutTelur", tbl4)
	end

	for _, v5 in ipairs(tbl.CFG.Get("MutJenis", {}) or {}) do
		tbl2[tostring(v5)] = true
	end

	for _, v5 in ipairs(tbl.CFG.Get("MutTelur", {}) or {}) do
		tbl3[tostring(v5)] = true
	end

	mutasi.MutJenis = { Get = function()
		return tbl2
	end }

	local function fn28()
		return tbl3
	end

	mutasi.MutTelur = { Get = fn28 }
	local textSecondary = arg.Theme.TextSecondary

	local function fn29(arg3)
		local n4 = tonumber(arg3) or 0
		local n5 = math.abs(n4)

		if not (n5 >= 1e12) then
			if not (n5 >= 1e9) then
				if n5 > 1e9 or n5 >= 1000000 then
					return ("%.2fM KG"):format(n4 / 1000000)
				end

				if not (n5 >= 1000) then
					return ("%.2f KG"):format(n4)
				end
				return ("%.2fK KG"):format(n4 / 1000)
			end

			return ("%.2fB KG"):format(n4 / 1e9)
		end

		return ("%.2fT KG"):format(n4 / 1e12)
	end

	local Frame = arg.new("Frame", {
		Parent = arg2,
		Name = "MutTypes",
		Size = UDim2.new(1, 0, 0, 0),
		AutomaticSize = Enum.AutomaticSize.Y,
		BackgroundTransparency = 1,
		LayoutOrder = fn25(),
	}, {
		arg.new("UIGridLayout", {
			CellSize = UDim2.new(0.25, -6, 0, 108),
			CellPadding = UDim2.new(0, 8, 0, 8),
			SortOrder = Enum.SortOrder.LayoutOrder,
			FillDirectionMaxCells = 4,
		}),
	})

	local n4 = 191551262

	local function fn30()
		local tbl4 = {}
		local tbl5 = {}
		local tbl6 = {}
		local flag2 = n4 ~= 265423629
		local punya, n5

		if flag2 then
			flag2 = ipairs
			punya = tbl.STEAL.MUT.Punya
			n5 = n4 + 475960967
		end

		if n5 == 334271576 then
			n4 = bit32.bxor(n4, 1295584799)
		end

		for _, v5 in flag2(punya()) do
			tbl4[v5.id] = (tbl4[v5.id] or 0) + v5.sisa

			if not tbl6[v5.id] then
				tbl6[v5.id] = true
				tbl5[#tbl5 + 1] = v5.id
			end
		end

		local tbl7 = {}

		pcall(function()
			for k, v5 in pairs(require(tbl.SV.ReplicatedStorage.Shared.Modules.Mutations.Catalog)) do
				if (tonumber(v5.RollWeight) or 0) == 0 and not tbl6[k] then
					tbl7[#tbl7 + 1] = k
				end
			end
		end)

		table.sort(tbl7, function(arg3, arg4)
			local v5 = tbl.STEAL.MUT.Rinci(arg3)
			local v6 = tbl.STEAL.MUT.Rinci(arg4)
			if v5.skala ~= v6.skala then
				return v5.skala > v6.skala
			end
			return arg3 < arg4
		end)

		for _, v5 in ipairs(tbl7) do
			tbl5[#tbl5 + 1] = v5
		end

		return tbl5, tbl4
	end

	local n5 = 129193966
	n4 = 36520499
	local fn31

	fn31 = function()
		if n5 + 287782100 == 198826566 then
			while true do
				local v5 = table.pack(N_0())

				if v5[1] then
					local v6 = v5[3]
					local exitTo = nil

					while true do
						if v6:IsA("GuiObject") then
							v6:Destroy()
							local v7 = table.pack(N_0())
							if v7[1] then
								v6 = v7[3]
								continue
							end
							break
						else
							exitTo = 1
							break
						end
					end

					if exitTo ~= 1 then
						break
					end
				else
					break
				end
			end

			tbl.LOG.warn("UI", "mutation panel refresh used fallback")
		end

		local str2

		for _, child in ipairs(Frame:GetChildren()) do
			str2 = "GuiObject"

			if child:IsA(str2) then
				child:Destroy()
			end
		end

		local v5, v6 = fn30()
		local n6 = 3215275507
		local flag2 = n5 + 210624531 ~= 468320577

		if flag2 then
			local exitTo2, tbl4, v7, n7, flag3

			repeat
				local backgroundTransparency = 0.4
				exitTo2 = nil

				while true do
					tbl4.BackgroundTransparency = backgroundTransparency
					local Frame2 = flag2("Frame", tbl4, { arg.corner(8) })

					if v7.ikon ~= "" then
						local new = arg.new
						local tbl5 = {}
						tbl5.Parent = Frame2
						tbl5.Size = UDim2.new(1, -6, 1, -6)
						tbl5.Position = UDim2.new(0, 3, 0, 3)
						tbl5.BackgroundTransparency = 1
						tbl5.Image = v7.ikon
						tbl5.ScaleType = Enum.ScaleType.Fit
						tbl5.ImageTransparency = n7 > 0 and 0 or 0.45
						new("ImageLabel", tbl5)
					end

					if flag3 then
						arg.new("TextLabel", {
							Parent = n6,
							BackgroundTransparency = 1,
							Size = UDim2.new(0, 16, 0, 16),
							Position = UDim2.new(1, -18, 0, 4),
							Font = arg.FONT_BOLD,
							TextSize = 14,
							TextColor3 = v7.warna,
							Text = "✓",
						})
					end

					local new = arg.new

					local tbl5 = {
						Parent = n6,
						BackgroundTransparency = 1,
						Size = UDim2.new(1, -10, 0, 15),
						Position = UDim2.new(0, 5, 0, 50),
						Font = arg.FONT_BOLD,
						TextSize = 12,
						TextColor3 = flag3 and v7.warna or arg.Theme.Text,
						TextXAlignment = Enum.TextXAlignment.Center,
						TextTruncate = Enum.TextTruncate.AtEnd,
						Text = v7.label,
					}

					new("TextLabel", tbl5)

					arg.new("TextLabel", {
						Parent = n6,
						BackgroundTransparency = 1,
						Size = UDim2.new(1, -10, 0, 13),
						Position = UDim2.new(0, 5, 0, 66),
						Font = arg.FONT,
						TextSize = 11,
						TextColor3 = textSecondary,
						TextXAlignment = Enum.TextXAlignment.Center,
						Text = ("x%.2f  •  %d%%"):format(v7.skala, v7.pct),
					})

					arg.new("TextLabel", {
						Parent = n6,
						BackgroundTransparency = 1,
						Size = UDim2.new(1, -10, 0, 13),
						Position = UDim2.new(0, 5, 0, 82),
						Font = arg.FONT_BOLD,
						TextSize = 11,
						TextColor3 = if n7 > 0 then Color3.new(0.43137255311012268, 0.86274510622024536, 0.50980395078659058) else Color3.new(0.58823531866073608, 0.43137255311012268, 0.43137255311012268),
						TextXAlignment = Enum.TextXAlignment.Center,
						Text = n7 > 0 and ("own %d"):format(n7) or "none",
					})

					local mouseButton1Click = n6.MouseButton1Click
					local v8 = mouseButton1Click
					local connect = mouseButton1Click.Connect

					local function fn32()
						local v9 = tbl2
						local v10 = str2
						local flag4 = not flag3

						if flag3 then
							flag4 = nil
						end

						v9[v10] = flag4
						fn26()
						fn31()
					end

					connect(v8, fn32)
					local v9 = table.pack(N_0())

					if v9[1] then
						local v10 = v9[2]
						str2 = v9[3]
						v7 = tbl.STEAL.MUT.Rinci(str2)
						n7 = v6[str2] or 0
						flag3 = tbl2[str2] == true
						local new2 = arg.new

						local tbl6 = {
							Parent = Frame,
							LayoutOrder = v10,
							BackgroundColor3 = if flag3 then Color3.new(0.094117648899555206, 0.12549020349979401, 0.10196078568696976) else arg.Theme.Card,
							BackgroundTransparency = (n7 > 0 or flag3) and 0 or 0.35,
							BorderSizePixel = 0,
							AutoButtonColor = false,
							Text = "",
						}

						local tbl7 = {}
						local v11 = arg.corner(8)
						local new3 = arg.new

						local tbl8 = {
							Thickness = flag3 and 1.6 or 1,
							Color = flag3 and v7.warna or arg.Theme.Border,
							Transparency = flag3 and 0 or 0.45,
						}

						local v12 = table.pack(new3("UIStroke", tbl8))
						tbl7[1] = v11

						do
							local values = table.pack(table.unpack(v12, 1, v12.n))
							table.move(values, 1, values.n, 2, tbl7)
						end

						n6 = new2("TextButton", tbl6, tbl7)
						flag2 = arg.new

						tbl4 = {
							Parent = n6,
							Name = "Icon",
							Size = UDim2.new(0, 38, 0, 38),
							Position = UDim2.new(0.5, -19, 0, 8),
							BackgroundColor3 = arg.Theme.CardHover,
							BorderSizePixel = 0,
						}

						if n7 > 0 then
							backgroundTransparency = 0
							continue
						end
						exitTo2 = 1
						break
					end

					break
				end
			until exitTo2 ~= 1

			tbl.LOG.warn("UI", "mutation panel entry used fallback")
		end

		for i, v7 in ipairs(v5) do
			local v8 = tbl.STEAL.MUT.Rinci(v7)
			local n7 = v6[v7] or 0
			local flag3 = tbl2[v7] == true
			local new = arg.new

			local tbl4 = {
				Parent = Frame,
				LayoutOrder = i,
				BackgroundColor3 = if flag3 then Color3.new(0.094117648899555206, 0.12549020349979401, 0.10196078568696976) else arg.Theme.Card,
				BackgroundTransparency = (n7 > 0 or flag3) and 0 or 0.35,
				BorderSizePixel = 0,
				AutoButtonColor = false,
				Text = "",
			}

			local tbl5 = {}
			local v9 = arg.corner(8)
			local new2 = arg.new

			local tbl6 = {
				Thickness = flag3 and 1.6 or 1,
				Color = flag3 and v8.warna or arg.Theme.Border,
				Transparency = flag3 and 0 or 0.45,
			}

			local v10 = table.pack(new2("UIStroke", tbl6))
			tbl5[1] = v9

			do
				local values = table.pack(table.unpack(v10, 1, v10.n))
				table.move(values, 1, values.n, 2, tbl5)
			end

			local TextButton = new("TextButton", tbl4, tbl5)

			local Frame2 = arg.new("Frame", {
				Parent = TextButton,
				Name = "Icon",
				Size = UDim2.new(0, 38, 0, 38),
				Position = UDim2.new(0.5, -19, 0, 8),
				BackgroundColor3 = arg.Theme.CardHover,
				BorderSizePixel = 0,
				BackgroundTransparency = n7 > 0 and 0 or 0.4,
			}, { arg.corner(8) })

			if v8.ikon ~= "" then
				local new3 = arg.new
				local tbl7 = {}
				tbl7.Parent = Frame2
				tbl7.Size = UDim2.new(1, -6, 1, -6)
				tbl7.Position = UDim2.new(0, 3, 0, 3)
				tbl7.BackgroundTransparency = 1
				tbl7.Image = v8.ikon
				tbl7.ScaleType = Enum.ScaleType.Fit
				tbl7.ImageTransparency = n7 > 0 and 0 or 0.45
				new3("ImageLabel", tbl7)
			end

			if flag3 then
				arg.new("TextLabel", {
					Parent = TextButton,
					BackgroundTransparency = 1,
					Size = UDim2.new(0, 16, 0, 16),
					Position = UDim2.new(1, -18, 0, 4),
					Font = arg.FONT_BOLD,
					TextSize = 14,
					TextColor3 = v8.warna,
					Text = "✓",
				})
			end

			local new3 = arg.new

			local tbl7 = {
				Parent = TextButton,
				BackgroundTransparency = 1,
				Size = UDim2.new(1, -10, 0, 15),
				Position = UDim2.new(0, 5, 0, 50),
				Font = arg.FONT_BOLD,
				TextSize = 12,
				TextColor3 = flag3 and v8.warna or arg.Theme.Text,
				TextXAlignment = Enum.TextXAlignment.Center,
				TextTruncate = Enum.TextTruncate.AtEnd,
				Text = v8.label,
			}

			new3("TextLabel", tbl7)

			arg.new("TextLabel", {
				Parent = TextButton,
				BackgroundTransparency = 1,
				Size = UDim2.new(1, -10, 0, 13),
				Position = UDim2.new(0, 5, 0, 66),
				Font = arg.FONT,
				TextSize = 11,
				TextColor3 = textSecondary,
				TextXAlignment = Enum.TextXAlignment.Center,
				Text = ("x%.2f  •  %d%%"):format(v8.skala, v8.pct),
			})

			arg.new("TextLabel", {
				Parent = TextButton,
				BackgroundTransparency = 1,
				Size = UDim2.new(1, -10, 0, 13),
				Position = UDim2.new(0, 5, 0, 82),
				Font = arg.FONT_BOLD,
				TextSize = 11,
				TextColor3 = if n7 > 0 then Color3.new(0.43137255311012268, 0.86274510622024536, 0.50980395078659058) else Color3.new(0.58823531866073608, 0.43137255311012268, 0.43137255311012268),
				TextXAlignment = Enum.TextXAlignment.Center,
				Text = n7 > 0 and ("own %d"):format(n7) or "none",
			})

			local mouseButton1Click = TextButton.MouseButton1Click
			local v11 = mouseButton1Click
			local connect = mouseButton1Click.Connect

			local function fn32()
				local v12 = tbl2
				local v13 = v7
				local flag4 = not flag3

				if flag3 then
					flag4 = nil
				end

				v12[v13] = flag4
				fn26()
				fn31()
			end

			connect(v11, fn32)
		end

		local flag3 = next(tbl2) ~= nil

		if mutasi.MutNote then
			if mutasi.MutNote.Parent then
				mutasi.MutNote.Text = flag3 and "Only the selected type will be used." or "Nothing selected • every consumable you own will be used."
				local mutNote = mutasi.MutNote
				local color

				if flag3 then
					color = textSecondary or Color3.new(0.43137255311012268, 0.86274510622024536, 0.50980395078659058)
				else
					color = Color3.new(0.43137255311012268, 0.86274510622024536, 0.50980395078659058)
					mutNote.TextColor3 = color
					return
				end

				mutNote.TextColor3 = color
				return
			end

			return
		end
	end

	mutasi.MutNote = arg.new("TextLabel", {
		Parent = arg2,
		Name = "MutNote",
		Size = UDim2.new(1, 0, 0, 16),
		BackgroundTransparency = 1,
		Font = arg.FONT,
		TextSize = 11,
		TextColor3 = Color3.new(0.43137255311012268, 0.86274510622024536, 0.50980395078659058),
		TextXAlignment = Enum.TextXAlignment.Left,
		LayoutOrder = fn25(),
		Text = "",
	})

	local new = arg.new
	local n6 = 1994324816

	local tbl4 = {
		Parent = arg2,
		Name = "MutEggs",
		Size = UDim2.new(1, 0, 0, 0),
		AutomaticSize = Enum.AutomaticSize.Y,
		BackgroundTransparency = 1,
		LayoutOrder = fn25(),
	}

	n5 = bit32.bxor(n5, 149911232)
	local Frame2 = new("Frame", tbl4, { arg.new("UIListLayout", { Padding = UDim.new(0, 4), SortOrder = Enum.SortOrder.LayoutOrder }) })
	local v5 = nil

	n6 = function(arg3)
		for _, child in ipairs(Frame2:GetChildren()) do
			if child:IsA("GuiObject") then
				child:Destroy()
			end
		end

		arg.new("TextLabel", {
			Parent = Frame2,
			LayoutOrder = 1,
			Size = UDim2.new(1, 0, 0, 16),
			BackgroundTransparency = 1,
			Font = arg.FONT_BOLD,
			TextSize = 11,
			TextColor3 = textSecondary,
			TextXAlignment = Enum.TextXAlignment.Left,
			Text = ("PLANTED EGGS  (%d)  •  none selected = all"):format(#arg3),
		})

		if #arg3 ~= 0 then
			for i, v6 in ipairs(arg3) do
				local flag2 = tbl3[v6.uid] == true
				local new2 = arg.new

				local tbl5 = {
					Parent = Frame2,
					LayoutOrder = i + 1,
					Size = UDim2.new(1, 0, 0, 44),
					BackgroundColor3 = if flag2 then Color3.new(0.094117648899555206, 0.12549020349979401, 0.10196078568696976) else arg.Theme.Card,
					BorderSizePixel = 0,
				}

				local tbl6 = {}
				local v7 = arg.corner(6)
				local new3 = arg.new

				local tbl7 = {
					Thickness = 1,
					Color = if flag2 then Color3.new(0.43137255311012268, 0.86274510622024536, 0.50980395078659058) else arg.Theme.Border,
					Transparency = flag2 and 0 or 0.4,
				}

				local v8 = table.pack(new3("UIStroke", tbl7))
				tbl6[1] = v7

				do
					local values = table.pack(table.unpack(v8, 1, v8.n))
					table.move(values, 1, values.n, 2, tbl6)
				end

				local Frame3 = new2("Frame", tbl5, tbl6)

				local Frame4 = arg.new("Frame", {
					Parent = Frame3,
					Size = UDim2.new(0, 32, 0, 32),
					Position = UDim2.new(0, 8, 0.5, -16),
					BackgroundColor3 = arg.Theme.CardHover,
					BorderSizePixel = 0,
				}, { arg.corner(6) })

				local v9 = tbl.STEAL.AssetIcon(v6.cat)

				if v9 ~= "" then
					local new4 = arg.new
					local tbl8 = { Parent = Frame4 }
					tbl8.Size = UDim2.new(1, -4, 1, -4)
					tbl8.Position = UDim2.new(0, 2, 0, 2)
					tbl8.BackgroundTransparency = 1
					tbl8.Image = v9
					tbl8.ScaleType = Enum.ScaleType.Fit
					new4("ImageLabel", tbl8)
				end

				arg.new("TextLabel", {
					Parent = Frame3,
					BackgroundTransparency = 1,
					Size = UDim2.new(1, -215, 0, 15),
					Position = UDim2.new(0, 48, 0, 5),
					Font = arg.FONT_BOLD,
					TextSize = 12,
					TextColor3 = if flag2 then Color3.new(0.43137255311012268, 0.86274510622024536, 0.50980395078659058) else arg.Theme.Text,
					TextXAlignment = Enum.TextXAlignment.Left,
					TextTruncate = Enum.TextTruncate.AtEnd,
					Text = v6.cat,
				})

				if v6.nilai then
					arg.new("TextLabel", {
						Parent = Frame3,
						Name = "Nilai",
						BackgroundTransparency = 1,
						Size = UDim2.new(0, 96, 0, 15),
						Position = UDim2.new(1, -174, 0, 5),
						Font = arg.FONT_BOLD,
						TextSize = 11,
						TextColor3 = Color3.new(0.43137255311012268, 0.86274510622024536, 0.50980395078659058),
						TextXAlignment = Enum.TextXAlignment.Right,
						Text = tbl.STEAL.Duit(v6.nilai) .. "/s",
					})
				end

				local tbl8 = { v6.rarity }

				if v6.kg then
					tbl8[#tbl8 + 1] = fn29(v6.kg)
				end

				if #v6.mutasi > 0 then
					tbl8[#tbl8 + 1] = table.concat(v6.mutasi, ", ")
				end

				local new4 = arg.new
				local tbl9 = { Parent = Frame3 }
				tbl9.Name = "Sub"
				tbl9.BackgroundTransparency = 1
				tbl9.Size = UDim2.new(1, -130, 0, 13)
				tbl9.Position = UDim2.new(0, 48, 0, 23)
				tbl9.Font = arg.FONT
				tbl9.TextSize = 10
				tbl9.TextColor3 = if #v6.mutasi > 0 then Color3.new(1, 0.78431373834609985, 0.27450981736183167) else textSecondary
				tbl9.TextXAlignment = Enum.TextXAlignment.Left
				tbl9.TextTruncate = Enum.TextTruncate.AtEnd
				local concat = table.concat
				tbl9.Text = concat(tbl8, "  •  ")
				new4("TextLabel", tbl9)
				local new5 = arg.new

				local tbl10 = {
					Parent = Frame3,
					Size = UDim2.new(0, 64, 0, 22),
					Position = UDim2.new(1, -74, 0.5, -11),
					BackgroundColor3 = arg.Theme.CardHover,
					AutoButtonColor = false,
					Font = arg.FONT_BOLD,
					TextSize = 10,
					TextColor3 = if flag2 then Color3.new(0.43137255311012268, 0.86274510622024536, 0.50980395078659058) else arg.Theme.Text,
					Text = flag2 and "PICKED" or "Pick",
				}

				local tbl11 = {}
				local v10 = arg.corner(5)
				local stroke = arg.stroke
				local v11 = if flag2 then Color3.new(0.43137255311012268, 0.86274510622024536, 0.50980395078659058) else arg.Theme.Border
				local v12 = table.pack(stroke(v11, 1))
				tbl11[1] = v10

				do
					local values = table.pack(table.unpack(v12, 1, v12.n))
					table.move(values, 1, values.n, 2, tbl11)
				end

				local mouseButton1Click = new5("TextButton", tbl10, tbl11).MouseButton1Click
				local v13 = mouseButton1Click
				local connect = mouseButton1Click.Connect

				local function fn32()
					local v14 = tbl3
					local uid = v6.uid
					local flag3 = not flag2

					if flag2 then
						flag3 = nil
					end

					v14[uid] = flag3
					fn27()
					v5 = nil
					n6(arg3)
				end

				connect(v13, fn32)
			end

			return
		end

		arg.new("TextLabel", {
			Parent = Frame2,
			LayoutOrder = 2,
			Size = UDim2.new(1, 0, 0, 18),
			BackgroundTransparency = 1,
			Font = arg.FONT,
			TextSize = 12,
			TextColor3 = textSecondary,
			TextXAlignment = Enum.TextXAlignment.Left,
			Text = "No eggs planted in your pen yet.",
		})
	end

	mutasi.MutAuto = uix.Toggle(arg2, "Auto Mutation", fn25(), false, function(arg3)
		if arg3 then
			tbl.STEAL.MUT.Start()
			return
		end
		tbl.STEAL.MUT.Stop()
	end, "AutoMutation")

	arg.buttonRow(arg2, "Use One Now", fn25(), function()
		task.spawn(function()
			local ok, result = pcall(tbl.STEAL.MUT.Tick)
			if ok then
				return
			end
			tbl.LOG.warn("MUT", tostring(result))
		end)
	end)

	task.spawn(function()
		local n7 = 0

		while tbl.Alive do
			if Frame2.Parent then
				if arg2.Visible then
					pcall(function()
						local v6 = tbl.STEAL.MUT.Telur()
						local tbl5 = {}

						for _, v7 in ipairs(v6) do
							tbl5[#tbl5 + 1] = v7.uid .. ":" .. tostring(#v7.mutasi) .. ":" .. tostring(tbl3[v7.uid] == true)
						end

						local str2 = table.concat(tbl5, "|")

						if str2 ~= v5 then
							v5 = str2
							n6(v6)
						end

						if os.clock() - n7 > 4 then
							n7 = os.clock()
							fn31()
						end

						local mut = tbl.STEAL.MUT
						mutasi.MutStatus.Text = ("%s  •  used %d, applied %d, rejected %d"):format(tostring(mut.Status or "idle"), mut.Dipakai, mut.Jadi, mut.Tolak)
					end)
				end

				task.wait(2)
				continue
			end

			break
		end
	end)

	fn31()

	task.spawn(function()
		local ok, result = pcall(tbl.STEAL.MUT.Telur)
		if ok and result then
			pcall(n6, result)
			return
		end
	end)
end

uix.BuildWisp = function(arg, arg2)
	uix.WISP = {}
	local wisp = uix.WISP
	local n3 = 0

	local function fn25()
		n3 += 1
		return n3
	end

	local wisp2 = tbl.STEAL.WISP
	local tbl2 = { "Green", "Blue", "Purple", "Golden" }

	local function fn26(arg3)
		local n4 = tonumber(arg3) or 0

		if not (n4 >= 1e12) then
			if not (n4 >= 1e9) then
				if not (n4 >= 1000000) then
					if not (n4 >= 1000) then
						return tostring(math.floor(n4))
					end
					return ("%.1fK"):format(n4 / 1000)
				end

				return ("%.2fM"):format(n4 / 1000000)
			end

			return ("%.2fB"):format(n4 / 1e9)
		end

		return ("%.2fT"):format(n4 / 1e12)
	end

	local function fn27(arg3, arg4, arg5, ...)
		local v4 = table.pack(...)

		return function()
			task.spawn(function()
				local v5, v6 = arg5(table.unpack(v4, 1, v4.n))
				local pita = uix.Pita
				local str2 = "%s: %s"
				local format = ("%s: %s").format
				local str3

				if v5 then
					str3 = "OK"
				else
					str3 = v6 or "refused"
				end

				pita(format(str2, arg4, str3), 5)
				if v5 then
					return
				end
				tbl.LOG.warn("WISP", arg4 .. " - " .. tostring(v6))
			end)
		end
	end

	local tbl3 = {
		en = {
			cek = "Checking eligibility...",
			selesai_j = "EVENT COMPLETE",
			selesai_i = "The wisp is home and the Enchanted Tree is unlocked.",
			ikut_j = "JOINED  -  STAGE %d / %d",
			ikut_siap = "All three quests are done. Return the wisp to unlock the tree.",
			ikut_i = "Current quest: %s  (%d / %d)%s",
			ikut_klaim = "  -  ready to claim",
			tolak_j = "NOT ELIGIBLE",
			tolak_zona = "The Enchanted Forest zone has not been revealed on this server yet.",
			tolak_speed = "SpeedPower %s of %s required  -  short %s. The wisp will not spawn until this is met.",
			siap_j = "ELIGIBLE  -  YOU CAN JOIN",
			siap_i = "SpeedPower %s of %s. The Baby Wisp spawns in the Enchanted Forest - walk to it and use the prompt.",
		},
		id = {
			cek = "Mengecek kelayakan...",
			selesai_j = "EVENT SELESAI",
			selesai_i = "Wisp sudah pulang dan Enchanted Tree sudah terbuka.",
			ikut_j = "IKUT  -  TAHAP %d / %d",
			ikut_siap = "Ketiga quest sudah selesai. Pulangkan Wisp untuk membuka pohonnya.",
			ikut_i = "Quest sekarang: %s  (%d / %d)%s",
			ikut_klaim = "  -  siap diklaim",
			tolak_j = "BELUM MEMENUHI SYARAT",
			tolak_zona = "Zona Enchanted Forest belum terbuka di server ini.",
			tolak_speed = "Butuh SpeedPower %s dari %s  -  kurang %s. Wisp tidak akan muncul sebelum ini terpenuhi.",
			siap_j = "MEMENUHI SYARAT  -  BISA IKUT",
			siap_i = "SpeedPower %s dari %s. Baby Wisp muncul di Enchanted Forest - datangi dan tekan prompt-nya.",
		},
		["pt-br"] = {
			cek = "Verificando elegibilidade...",
			selesai_j = "EVENTO CONCLUÍDO",
			selesai_i = "O wisp voltou para casa e a Enchanted Tree está desbloqueada.",
			ikut_j = "PARTICIPANDO  -  ETAPA %d / %d",
			ikut_siap = "As três missões foram concluídas. Devolva o wisp para desbloquear a árvore.",
			ikut_i = "Missão atual: %s  (%d / %d)%s",
			ikut_klaim = "  -  pronto para resgatar",
			tolak_j = "NÃO ELEGÍVEL",
			tolak_zona = "A zona Enchanted Forest ainda não foi revelada neste servidor.",
			tolak_speed = "É preciso SpeedPower %s de %s  -  faltam %s. O wisp não aparece até isso ser atingido.",
			siap_j = "ELEGÍVEL  -  VOCÊ PODE PARTICIPAR",
			siap_i = "SpeedPower %s de %s. O Baby Wisp aparece na Enchanted Forest - vá até ele e use o prompt.",
		},
		es = {
			cek = "Comprobando elegibilidad...",
			selesai_j = "EVENTO COMPLETADO",
			selesai_i = "El wisp ya está en casa y el Enchanted Tree está desbloqueado.",
			ikut_j = "PARTICIPANDO  -  ETAPA %d / %d",
			ikut_siap = "Las tres misiones están completas. Devuelve el wisp para desbloquear el árbol.",
			ikut_i = "Misión actual: %s  (%d / %d)%s",
			ikut_klaim = "  -  listo para reclamar",
			tolak_j = "NO ELEGIBLE",
			tolak_zona = "La zona Enchanted Forest aún no se ha revelado en este servidor.",
			tolak_speed = "Se requiere SpeedPower %s de %s  -  faltan %s. El wisp no aparecerá hasta cumplirlo.",
			siap_j = "ELEGIBLE  -  PUEDES PARTICIPAR",
			siap_i = "SpeedPower %s de %s. El Baby Wisp aparece en Enchanted Forest - ve hacia él y usa el aviso.",
		},
		ru = {
			cek = "Проверка доступа...",
			selesai_j = "СОБЫТИЕ ЗАВЕРШЕНО",
			selesai_i = "Висп дома, Enchanted Tree открыто.",
			ikut_j = "УЧАСТИЕ  -  ЭТАП %d / %d",
			ikut_siap = "Все три задания выполнены. Верните виспа, чтобы открыть дерево.",
			ikut_i = "Текущее задание: %s  (%d / %d)%s",
			ikut_klaim = "  -  можно забрать",
			tolak_j = "НЕТ ДОСТУПА",
			tolak_zona = "Зона Enchanted Forest ещё не открыта на этом сервере.",
			tolak_speed = "Нужен SpeedPower %s из %s  -  не хватает %s. Висп не появится, пока это не выполнено.",
			siap_j = "ДОСТУП ОТКРЫТ  -  МОЖНО УЧАСТВОВАТЬ",
			siap_i = "SpeedPower %s из %s. Baby Wisp появляется в Enchanted Forest - подойдите и нажмите подсказку.",
		},
		th = {
			cek = "กำลังตรวจสอบสิทธิ์...",
			selesai_j = "กิจกรรมเสร็จสิ้น",
			selesai_i = "วิสป์กลับบ้านแล้ว และ Enchanted Tree ปลดล็อกแล้ว",
			ikut_j = "เข้าร่วมแล้ว  -  ด่าน %d / %d",
			ikut_siap = "ภารกิจทั้งสามเสร็จแล้ว ส่งวิสป์กลับเพื่อปลดล็อกต้นไม้",
			ikut_i = "ภารกิจปัจจุบัน: %s  (%d / %d)%s",
			ikut_klaim = "  -  พร้อมรับรางวัล",
			tolak_j = "ยังไม่ผ่านเงื่อนไข",
			tolak_zona = "โซน Enchanted Forest ยังไม่เปิดในเซิร์ฟเวอร์นี้",
			tolak_speed = "ต้องมี SpeedPower %s จาก %s  -  ขาดอีก %s วิสป์จะไม่ปรากฏจนกว่าจะถึงเกณฑ์",
			siap_j = "ผ่านเงื่อนไข  -  เข้าร่วมได้",
			siap_i = "SpeedPower %s จาก %s Baby Wisp จะปรากฏใน Enchanted Forest - เดินไปหาแล้วกดพรอมต์",
		},
		vi = {
			cek = "Đang kiểm tra điều kiện...",
			selesai_j = "SỰ KIỆN HOÀN TẤT",
			selesai_i = "Wisp đã về nhà và Enchanted Tree đã mở khóa.",
			ikut_j = "ĐÃ THAM GIA  -  CHẶNG %d / %d",
			ikut_siap = "Cả ba nhiệm vụ đã xong. Trả Wisp về để mở khóa cây.",
			ikut_i = "Nhiệm vụ hiện tại: %s  (%d / %d)%s",
			ikut_klaim = "  -  có thể nhận",
			tolak_j = "CHƯA ĐỦ ĐIỀU KIỆN",
			tolak_zona = "Khu Enchanted Forest chưa mở trên máy chủ này.",
			tolak_speed = "Cần SpeedPower %s trên %s  -  còn thiếu %s. Wisp sẽ không xuất hiện cho tới khi đạt.",
			siap_j = "ĐỦ ĐIỀU KIỆN  -  CÓ THỂ THAM GIA",
			siap_i = "SpeedPower %s trên %s. Baby Wisp xuất hiện ở Enchanted Forest - đi tới và dùng prompt.",
		},
		tr = {
			cek = "Uygunluk kontrol ediliyor...",
			selesai_j = "ETKİNLİK TAMAMLANDI",
			selesai_i = "Wisp evine döndü ve Enchanted Tree açıldı.",
			ikut_j = "KATILDIN  -  AŞAMA %d / %d",
			ikut_siap = "Üç görev de bitti. Ağacı açmak için wisp'i geri götür.",
			ikut_i = "Güncel görev: %s  (%d / %d)%s",
			ikut_klaim = "  -  alınmaya hazır",
			tolak_j = "UYGUN DEĞİL",
			tolak_zona = "Enchanted Forest bölgesi bu sunucuda henüz açılmadı.",
			tolak_speed = "%s / %s SpeedPower gerekli  -  %s eksik. Bu sağlanana kadar wisp çıkmaz.",
			siap_j = "UYGUN  -  KATILABİLİRSİN",
			siap_i = "SpeedPower %s / %s. Baby Wisp Enchanted Forest'ta çıkar - yanına git ve prompt'u kullan.",
		},
		fr = {
			cek = "Vérification de l'éligibilité...",
			selesai_j = "ÉVÉNEMENT TERMINÉ",
			selesai_i = "Le wisp est rentré et l'Enchanted Tree est débloqué.",
			ikut_j = "INSCRIT  -  ÉTAPE %d / %d",
			ikut_siap = "Les trois quêtes sont terminées. Ramenez le wisp pour débloquer l'arbre.",
			ikut_i = "Quête actuelle : %s  (%d / %d)%s",
			ikut_klaim = "  -  prêt à réclamer",
			tolak_j = "NON ÉLIGIBLE",
			tolak_zona = "La zone Enchanted Forest n'est pas encore révélée sur ce serveur.",
			tolak_speed = "SpeedPower %s sur %s requis  -  il manque %s. Le wisp n'apparaîtra pas avant.",
			siap_j = "ÉLIGIBLE  -  VOUS POUVEZ PARTICIPER",
			siap_i = "SpeedPower %s sur %s. Le Baby Wisp apparaît dans l'Enchanted Forest - allez-y et utilisez l'invite.",
		},
		de = {
			cek = "Berechtigung wird geprüft...",
			selesai_j = "EVENT ABGESCHLOSSEN",
			selesai_i = "Der Wisp ist zu Hause und der Enchanted Tree ist freigeschaltet.",
			ikut_j = "TEILGENOMMEN  -  STUFE %d / %d",
			ikut_siap = "Alle drei Quests sind erledigt. Bring den Wisp zurück, um den Baum freizuschalten.",
			ikut_i = "Aktuelle Quest: %s  (%d / %d)%s",
			ikut_klaim = "  -  abholbereit",
			tolak_j = "NICHT BERECHTIGT",
			tolak_zona = "Die Enchanted-Forest-Zone ist auf diesem Server noch nicht freigeschaltet.",
			tolak_speed = "SpeedPower %s von %s nötig  -  es fehlen %s. Der Wisp erscheint erst danach.",
			siap_j = "BERECHTIGT  -  DU KANNST MITMACHEN",
			siap_i = "SpeedPower %s von %s. Der Baby Wisp erscheint im Enchanted Forest - geh hin und nutze die Eingabeaufforderung.",
		},
		ja = {
			cek = "参加条件を確認中...",
			selesai_j = "イベント完了",
			selesai_i = "ウィスプは家に帰り、Enchanted Tree が解放されました。",
			ikut_j = "参加中  -  ステージ %d / %d",
			ikut_siap = "3つのクエストがすべて完了しました。ウィスプを返すとツリーが解放されます。",
			ikut_i = "現在のクエスト: %s  (%d / %d)%s",
			ikut_klaim = "  -  受け取り可能",
			tolak_j = "参加条件を満たしていません",
			tolak_zona = "このサーバーでは Enchanted Forest がまだ開放されていません。",
			tolak_speed = "SpeedPower %s / %s が必要  -  あと %s 足りません。満たすまでウィスプは出現しません。",
			siap_j = "参加可能",
			siap_i = "SpeedPower %s / %s。Baby Wisp は Enchanted Forest に出現します - 近づいてプロンプトを押してください。",
		},
		ko = {
			cek = "참가 자격 확인 중...",
			selesai_j = "이벤트 완료",
			selesai_i = "위습이 집으로 돌아갔고 Enchanted Tree가 열렸습니다.",
			ikut_j = "참가 중  -  단계 %d / %d",
			ikut_siap = "세 가지 퀘스트를 모두 완료했습니다. 위습을 돌려보내 나무를 여세요.",
			ikut_i = "현재 퀘스트: %s  (%d / %d)%s",
			ikut_klaim = "  -  수령 가능",
			tolak_j = "참가 자격 없음",
			tolak_zona = "이 서버에서는 Enchanted Forest가 아직 열리지 않았습니다.",
			tolak_speed = "SpeedPower %s / %s 필요  -  %s 부족합니다. 조건을 채워야 위습이 나타납니다.",
			siap_j = "참가 가능",
			siap_i = "SpeedPower %s / %s. Baby Wisp는 Enchanted Forest에 나타납니다 - 가까이 가서 프롬프트를 누르세요.",
		},
		["zh-hans"] = {
			cek = "正在检查参加资格...",
			selesai_j = "活动已完成",
			selesai_i = "微光已归家，Enchanted Tree 已解锁。",
			ikut_j = "已参加  -  阶段 %d / %d",
			ikut_siap = "三个任务已全部完成。送回微光即可解锁这棵树。",
			ikut_i = "当前任务：%s  (%d / %d)%s",
			ikut_klaim = "  -  可领取",
			tolak_j = "不符合条件",
			tolak_zona = "本服务器尚未开放 Enchanted Forest 区域。",
			tolak_speed = "需要 SpeedPower %s / %s  -  还差 %s。未达成前微光不会出现。",
			siap_j = "符合条件  -  可以参加",
			siap_i = "SpeedPower %s / %s。Baby Wisp 会出现在 Enchanted Forest - 走过去并按下提示。",
		},
		["zh-hant"] = {
			cek = "正在檢查參加資格...",
			selesai_j = "活動已完成",
			selesai_i = "微光已歸家，Enchanted Tree 已解鎖。",
			ikut_j = "已參加  -  階段 %d / %d",
			ikut_siap = "三個任務已全部完成。送回微光即可解鎖這棵樹。",
			ikut_i = "目前任務：%s  (%d / %d)%s",
			ikut_klaim = "  -  可領取",
			tolak_j = "不符合條件",
			tolak_zona = "本伺服器尚未開放 Enchanted Forest 區域。",
			tolak_speed = "需要 SpeedPower %s / %s  -  還差 %s。未達成前微光不會出現。",
			siap_j = "符合條件  -  可以參加",
			siap_i = "SpeedPower %s / %s。Baby Wisp 會出現在 Enchanted Forest - 走過去並按下提示。",
		},
		pl = {
			cek = "Sprawdzanie kwalifikacji...",
			selesai_j = "WYDARZENIE UKOŃCZONE",
			selesai_i = "Wisp wrócił do domu, a Enchanted Tree jest odblokowane.",
			ikut_j = "DOŁĄCZONO  -  ETAP %d / %d",
			ikut_siap = "Wszystkie trzy zadania ukończone. Odprowadź wispa, aby odblokować drzewo.",
			ikut_i = "Aktualne zadanie: %s  (%d / %d)%s",
			ikut_klaim = "  -  gotowe do odebrania",
			tolak_j = "BRAK KWALIFIKACJI",
			tolak_zona = "Strefa Enchanted Forest nie została jeszcze odsłonięta na tym serwerze.",
			tolak_speed = "Wymagane SpeedPower %s z %s  -  brakuje %s. Wisp się nie pojawi, dopóki tego nie spełnisz.",
			siap_j = "KWALIFIKUJESZ SIĘ  -  MOŻESZ DOŁĄCZYĆ",
			siap_i = "SpeedPower %s z %s. Baby Wisp pojawia się w Enchanted Forest - podejdź i użyj podpowiedzi.",
		},
		it = {
			cek = "Verifica dei requisiti...",
			selesai_j = "EVENTO COMPLETATO",
			selesai_i = "Il wisp è tornato a casa e l'Enchanted Tree è sbloccato.",
			ikut_j = "PARTECIPI  -  FASE %d / %d",
			ikut_siap = "Tutte e tre le missioni sono completate. Riporta il wisp per sbloccare l'albero.",
			ikut_i = "Missione attuale: %s  (%d / %d)%s",
			ikut_klaim = "  -  pronto da riscuotere",
			tolak_j = "NON IDONEO",
			tolak_zona = "La zona Enchanted Forest non è ancora stata rivelata su questo server.",
			tolak_speed = "Serve SpeedPower %s su %s  -  mancano %s. Il wisp non comparirà finché non lo raggiungi.",
			siap_j = "IDONEO  -  PUOI PARTECIPARE",
			siap_i = "SpeedPower %s su %s. Il Baby Wisp compare nell'Enchanted Forest - raggiungilo e usa il prompt.",
		},
	}

	tbl3["zh-cn"] = tbl3["zh-hans"]
	tbl3.zh = tbl3["zh-hans"]
	tbl3["zh-tw"] = tbl3["zh-hant"]
	tbl3.pt = tbl3["pt-br"]
	tbl3.ms = tbl3.id
	local str2 = "en"

	local function fn28()
		local ok, result = pcall(game.GetService, game, "LocalizationService")

		if ok then
			if not result then
				return
			end
			local robloxLocaleId = nil

			pcall(function()
				robloxLocaleId = result.RobloxLocaleId
			end)

			if type(robloxLocaleId) ~= "string" or robloxLocaleId == "" then
				pcall(function()
					robloxLocaleId = result.SystemLocaleId
				end)
			end

			if type(robloxLocaleId) ~= "string" then
				return
			end
			robloxLocaleId = robloxLocaleId:lower()
			if tbl3[robloxLocaleId] then
				str2 = robloxLocaleId
				return
			end
			local match = robloxLocaleId:match("^(%a+)")

			if not match or not tbl3[match] then
				match = "en"
			end

			str2 = match
			return
		end
	end

	fn28()

	pcall(function()
		tbl.ST.Trove:Connect(game:GetService("LocalizationService"):GetPropertyChangedSignal("RobloxLocaleId"), fn28)
	end)

	local function fn29(arg3)
		local v4 = (tbl3[str2] or tbl3.en)[arg3]

		if not v4 then
			v4 = tbl3.en[arg3]
			if not v4 then
				return arg3
			end
		end

		return v4
	end

	local tbl4 = {
		Siap = Color3.new(0.35294118523597717, 0.84313726425170898, 0.47058823704719543),
		Ikut = Color3.new(0.35294118523597717, 0.66666668653488159, 1),
		Selesai = Color3.new(0.94117647409439087, 0.76470589637756348, 0.37254902720451355),
		Tolak = Color3.new(0.92156863212585449, 0.37254902720451355, 0.37254902720451355),
	}

	local new = arg.new

	local tbl5 = {
		Parent = arg2,
		Name = "WispBanner",
		Size = UDim2.new(1, 0, 0, 0),
		AutomaticSize = Enum.AutomaticSize.Y,
		BackgroundColor3 = arg.Theme.Card,
		BorderSizePixel = 0,
		LayoutOrder = fn25(),
	}

	local tbl6 = {}
	local v4 = arg.corner(8)

	local UIPadding = arg.new("UIPadding", {
		PaddingTop = UDim.new(0, 12),
		PaddingBottom = UDim.new(0, 12),
		PaddingLeft = UDim.new(0, 14),
		PaddingRight = UDim.new(0, 12),
	})

	local new2 = arg.new
	local tbl7 = { Padding = UDim.new(0, 6), SortOrder = Enum.SortOrder.LayoutOrder }
	tbl6[1] = v4
	tbl6[2] = UIPadding

	do
		local values = table.pack(new2("UIListLayout", tbl7))
		table.move(values, 1, values.n, 3, tbl6)
	end

	wisp.Ban = new("Frame", tbl5, tbl6)
	wisp.BanGaris = arg.new("UIStroke", { Parent = wisp.Ban, Thickness = 1, Color = arg.Theme.Border })

	wisp.BanJudul = arg.new("TextLabel", {
		Parent = wisp.Ban,
		Name = "Title",
		Size = UDim2.new(1, 0, 0, 21),
		BackgroundTransparency = 1,
		Font = arg.FONT_BOLD,
		TextSize = 17,
		TextColor3 = arg.Theme.Text,
		TextXAlignment = Enum.TextXAlignment.Left,
		Text = fn29("cek"),
		LayoutOrder = 1,
	})

	wisp.BanIsi = arg.new("TextLabel", {
		Parent = wisp.Ban,
		Name = "Sub",
		Size = UDim2.new(1, 0, 0, 0),
		AutomaticSize = Enum.AutomaticSize.Y,
		BackgroundTransparency = 1,
		Font = arg.FONT,
		TextSize = 14,
		TextColor3 = arg.Theme.TextSecondary,
		TextWrapped = true,
		TextXAlignment = Enum.TextXAlignment.Left,
		Text = "-",
		LayoutOrder = 2,
	})

	local section = uix.Section
	local v5 = fn25()
	local wispQuest = section(arg2, "Wisp Quest", v5)
	local textRow = arg.textRow
	local v6 = fn25()
	wisp.Stage = textRow(arg2, "Stage: -", v6)

	wisp.QuestHost = arg.new("Frame", {
		Parent = wispQuest,
		Name = "QuestList",
		Size = UDim2.new(1, 0, 0, 0),
		AutomaticSize = Enum.AutomaticSize.Y,
		BackgroundTransparency = 1,
		LayoutOrder = fn25(),
	}, { arg.new("UIListLayout", { Padding = UDim.new(0, 5), SortOrder = Enum.SortOrder.LayoutOrder }) })

	wisp.QuestRows = {}

	local tbl8 = {
		selesai = Color3.new(0.35294118523597717, 0.84313726425170898, 0.47058823704719543),
		kunci = Color3.new(0.47058823704719543, 0.49411764740943909, 0.54117649793624878),
	}

	wisp.AutoQuest = uix.Toggle(arg2, "Auto Quest", fn25(), false, nil, "WispAutoQuest")

	arg.buttonRow(arg2, "Fuse 3 Enchanted Pets", fn25(), function()
		task.spawn(function()
			local v7, v8 = wisp2.Fuse()
			uix.Pita(if v7 then "Fused 3 " .. tostring(v8) else "Fuse: " .. tostring(v8 or "failed"), 6)
		end)
	end)

	local section2 = uix.Section
	local v7 = fn25()
	local butterflyBloom = section2(arg2, "Butterfly Bloom", v7)
	local textRow2 = arg.textRow
	local v8 = fn25()
	wisp.Window = textRow2(arg2, "Bloom: -", v8)
	local textRow3 = arg.textRow
	local v9 = fn25()
	wisp.Jaring = textRow3(arg2, "-", v9)

	wisp.StokHost = arg.new("Frame", {
		Parent = butterflyBloom,
		Name = "ButterflyStock",
		Size = UDim2.new(1, 0, 0, 24),
		BackgroundTransparency = 1,
		LayoutOrder = fn25(),
	})

	wisp.StokSel = {}

	for i, v10 in ipairs({ "Green", "Blue", "Purple", "Golden" }) do
		local Frame = arg.new("Frame", {
			Parent = wisp.StokHost,
			Name = v10,
			Size = UDim2.new(0, 56, 1, 0),
			Position = UDim2.new(0, 56 * (i - 1), 0, 0),
			BackgroundTransparency = 1,
		})

		wisp.StokSel[v10] = {
			ikon = arg.new("ImageLabel", {
				Parent = Frame,
				Name = "Icon",
				Size = UDim2.new(0, 20, 0, 20),
				Position = UDim2.new(0, 0, 0.5, -10),
				BackgroundTransparency = 1,
				ScaleType = Enum.ScaleType.Fit,
				Image = "",
			}),
			cacah = arg.new("TextLabel", {
				Parent = Frame,
				Name = "N",
				Size = UDim2.new(1, -25, 1, 0),
				Position = UDim2.new(0, 25, 0, 0),
				BackgroundTransparency = 1,
				Font = arg.FONT_BOLD,
				TextSize = 14.5,
				TextColor3 = arg.Theme.TextSecondary,
				TextXAlignment = Enum.TextXAlignment.Left,
				Text = "0",
			}),
		}
	end

	local textRow4 = arg.textRow
	local v10 = fn25()
	wisp.Essence = textRow4(arg2, "Essence: 0  |  Caught: 0", v10)
	local textRow5 = arg.textRow
	local v11 = fn25()
	wisp.State = textRow5(arg2, "Status: idle", v11)
	wisp.AutoNet = uix.ToggleSatu(arg2, fn25(), { label = "Auto Claim Net", key = "WispAutoNet" })
	wisp.ESP = uix.ToggleSatu(arg2, fn25(), { label = "Butterfly ESP", key = "WispESP" })
	wisp.AutoCatch = uix.ToggleSatu(arg2, fn25(), { label = "Auto Catch", key = "WispAutoCatch" })
	wisp.Chase = uix.ToggleSatu(arg2, fn25(), { label = "Auto Chase Butterflies", key = "WispChase" })

	wisp.Gaya = uix.Dropdown(arg2, "Catch Style", fn25(), wisp2.GAYA_PILIHAN, wisp2.GAYA_PILIHAN[1], function(arg3)
		wisp2.GAYA = tostring(arg3 or "Default")
	end, "WispCatchStyle")

	local v12 = tostring
	local gaya

	if wisp.Gaya and wisp.Gaya.Get then
		gaya = wisp.Gaya.Get() or wisp2.GAYA or "Default"
	else
		gaya = wisp2.GAYA or "Default"
	end

	wisp2.GAYA = v12(gaya)
	wisp.Tiers = uix.DropdownMulti(arg2, "Catch Tiers (empty = all)", fn25(), { "Green", "Blue", "Purple", "Golden" }, nil, "WispTiers")

	local function fn30()
		task.spawn(function()
			local v13, v14 = wisp2.KePohon()
			uix.Pita(v13 and "Arrived at the Enchanted Tree" or "Tree: " .. tostring(v14 or "failed"), 5)
		end)
	end

	arg.buttonRow(arg2, "Go to Enchanted Tree", fn25(), fn30)

	arg.buttonRow(arg2, "Go Back to Safe Zone", fn25(), function()
		task.spawn(function()
			local v13, v14 = wisp2.KeSafeZone()
			uix.Pita(v13 and "Back at the safe zone" or "Safe zone: " .. tostring(v14 or "failed"), 5)
		end)
	end)

	local section3 = uix.Section
	local v13 = fn25()
	local v14 = section3(arg2, "Trade & Craft", v13)
	wisp.ResepSel = {}

	local Frame = arg.new("Frame", {
		Parent = v14,
		Name = "TradeRecipe",
		Size = UDim2.new(1, 0, 0, 34),
		BackgroundTransparency = 1,
		LayoutOrder = fn25(),
	})

	for i, v15 in ipairs({ { "Green", "Blue" }, { "Blue", "Purple" }, { "Purple", "Golden" } }) do
		local v16 = v15[1]
		local v17 = v15[2]

		local TextButton = arg.new("TextButton", {
			Parent = Frame,
			Name = v16,
			Size = UDim2.new(0.3333333432674408, -6, 1, 0),
			Position = UDim2.new((i - 1) / 3, 3, 0, 0),
			BackgroundColor3 = arg.Theme.CardHover,
			AutoButtonColor = false,
			Text = "",
			BorderSizePixel = 0,
		}, { arg.corner(8) })

		local UIStroke = arg.new("UIStroke", { Parent = TextButton, Thickness = 1, Color = arg.Theme.Border })

		local ImageLabel = arg.new("ImageLabel", {
			Parent = TextButton,
			Name = "A",
			Size = UDim2.new(0, 22, 0, 22),
			Position = UDim2.new(0, 8, 0.5, -11),
			BackgroundTransparency = 1,
			ScaleType = Enum.ScaleType.Fit,
			Image = "",
		})

		local TextLabel = arg.new("TextLabel", {
			Parent = TextButton,
			Name = "N",
			Size = UDim2.new(1, -68, 1, 0),
			Position = UDim2.new(0, 34, 0, 0),
			BackgroundTransparency = 1,
			Font = arg.FONT_BOLD,
			TextSize = 13,
			TextColor3 = arg.Theme.Text,
			Text = "-",
		})

		wisp.ResepSel[i] = {
			dari = v16,
			ke = v17,
			tombol = TextButton,
			garis = UIStroke,
			a = ImageLabel,
			b = arg.new("ImageLabel", {
				Parent = TextButton,
				Name = "B",
				Size = UDim2.new(0, 22, 0, 22),
				Position = UDim2.new(1, -30, 0.5, -11),
				BackgroundTransparency = 1,
				ScaleType = Enum.ScaleType.Fit,
				Image = "",
			}),
			teks = TextLabel,
		}

		local mouseButton1Click = TextButton.MouseButton1Click
		local v18 = mouseButton1Click
		local connect = mouseButton1Click.Connect

		local function fn31()
			tbl.CFG.Set(wisp2.CFG_RESEP, v16)

			task.spawn(function()
				local v19, v20 = wisp2.TukarSatu(v16)
				uix.Pita(v19 and ("Trade Up: %d x"):format(tonumber(v20) or 0) or "Trade Up: " .. tostring(v20), 5)
			end)
		end

		connect(v18, fn31)
	end

	wisp.EMAS_RESEP = Color3.new(0.94117647409439087, 0.76470589637756348, 0.37254902720451355)
	local textRow6 = arg.textRow
	local v15 = fn25()
	wisp.BarisTukar = textRow6(arg2, "Trade Up: -", v15)
	local textRow7 = arg.textRow
	local v16 = fn25()
	wisp.BarisResep = textRow7(arg2, "Essence: -", v16)
	wisp.AutoTrade = uix.Toggle(arg2, "Auto Trade Up (after bloom)", fn25(), false, nil, "WispAutoTrade")
	wisp.AutoCraft = uix.Toggle(arg2, "Auto Craft Essence (after bloom)", fn25(), false, nil, "WispAutoCraft")

	arg.buttonRow(arg2, "Trade Up Now", fn25(), function()
		task.spawn(function()
			local v17, v18 = wisp2.TukarOtomatis()
			uix.Pita(v17 and ("Trade Up: %d trade(s)"):format(tonumber(v18) or 0) or "Trade Up: " .. tostring(v18), 5)
		end)
	end)

	arg.buttonRow(arg2, "Craft Essence", fn25(), function()
		task.spawn(function()
			local v17, v18 = wisp2.LeburOtomatis()
			uix.Pita(v17 and "Enchanted Essence crafted" or "Craft: " .. tostring(v18 or "refused"), 5)
		end)
	end)

	local buttonRow = arg.buttonRow
	local v17 = fn25()
	local claimNet = fn27(530676, "Claim Net", wisp2.AmbilJaring)
	buttonRow(arg2, "Claim Butterfly Net", v17, claimNet)
	wisp2.Start()

	task.spawn(function()
		while tbl.Alive do
			if arg2.Visible then
				local ok, result = pcall(function()
					local s = wisp2.S
					local n4 = math.max(0, math.floor(tonumber(s.sisa) or 0))

					if s.aktif then
						wisp.Window.Text = ("Bloom: ACTIVE - ends in %dm %ds  |  %d flying"):format(n4 // 60, n4 % 60, tonumber(s.hidup) or 0)
					elseif s.bloomOn ~= false then
						if tonumber(s.menuju) then
							local n5 = math.max(0, math.floor(s.menuju))
							wisp.Window.Text = ("Bloom: next in %dm %ds"):format(n5 // 60, n5 % 60)
						else
							wisp.Window.Text = "Bloom: not running"
						end
					else
						wisp.Window.Text = "Bloom: disabled on this server"
					end

					local counts = s.counts or {}

					if s.unlocked ~= true then
						for _, v18 in ipairs({ "AutoNet", "AutoCatch", "Chase", "ESP", "AutoTrade", "AutoCraft" }) do
							local v19 = wisp[v18]

							local function fn31()
								local v20 = v19
								if v19 then
									return (v19.Get())
								end
								return v20
							end

							local ok, result = pcall(fn31)

							if ok and result then
								pcall(v19.Set, false, true)
							end
						end

						wisp.Jaring.Text = "Locked - finish all 3 Wisp quests and return the Wisp first"
						wisp.Jaring.TextColor3 = Color3.new(0.94117647409439087, 0.76470589637756348, 0.37254902720451355)
					elseif s.jaring then
						if s.pegang then
							wisp.Jaring.Text = "Butterfly Net: equipped"
							wisp.Jaring.TextColor3 = arg.Theme.TextSecondary
						else
							wisp.Jaring.Text = "Butterfly Net: not equipped"
							wisp.Jaring.TextColor3 = Color3.new(0.94117647409439087, 0.76470589637756348, 0.37254902720451355)
						end
					else
						wisp.Jaring.Text = "You don't have the Butterfly Net"
						wisp.Jaring.TextColor3 = Color3.new(0.92156863212585449, 0.37254902720451355, 0.37254902720451355)
					end

					for k, v18 in pairs(wisp.StokSel) do
						if v18.ikon.Image == "" then
							local ikon = s.ikon and s.ikon[k]

							if ikon and ikon ~= "" then
								v18.ikon.Image = ikon
							end
						end

						local n5 = tonumber(counts[k]) or 0
						v18.cacah.Text = tostring(n5)
						v18.cacah.TextColor3 = n5 > 0 and s.warnaTier and s.warnaTier[k] or arg.Theme.TextSecondary
					end

					wisp.Essence.Text = ("Essence: %d  |  Caught: %d"):format(tonumber(s.essence) or 0, tonumber(s.ditangkap) or 0)
					local namaTier = s.namaTier or {}
					local biayaTukar = s.biayaTukar

					if biayaTukar then
						local tbl9 = {}

						for i = 1, 3 do
							local v18 = tbl2[i]
							tbl9[#tbl9 + 1] = ("%d/%d %s"):format(tonumber(counts[v18]) or 0, biayaTukar[v18] or 0, namaTier[v18] or v18)
						end

						local str3 = tostring(tbl.CFG.Get(wisp2.CFG_RESEP, ""))

						for _, v18 in ipairs(wisp.ResepSel or {}) do
							if v18.a.Image == "" and s.ikon then
								v18.a.Image = s.ikon[v18.dari] or ""
								v18.b.Image = s.ikon[v18.ke] or ""
							end

							local n5 = (s.biayaTukar or {})[v18.dari] or 0
							v18.teks.Text = ("%d %s 1"):format(n5, "→")
							local flag2 = str3 == v18.dari
							v18.garis.Color = flag2 and wisp.EMAS_RESEP or arg.Theme.Border
							v18.garis.Thickness = flag2 and 2 or 1
							v18.teks.TextColor3 = if (tonumber(counts[v18.dari]) or 0) >= n5 and n5 > 0 then Color3.new(0.35294118523597717, 0.84313726425170898, 0.47058823704719543) else arg.Theme.Text
						end

						wisp.BarisTukar.Text = "Trade Up:  " .. table.concat(tbl9, "   ")
						wisp.BarisTukar.TextColor3 = if s.tukarSiap then Color3.new(0.35294118523597717, 0.84313726425170898, 0.47058823704719543) else arg.Theme.TextSecondary
					end

					local resep = s.resep

					if resep then
						local tbl9 = {}

						for _, v18 in ipairs(tbl2) do
							tbl9[#tbl9 + 1] = ("%d/%d %s"):format(tonumber(counts[v18]) or 0, resep[v18] or 0, namaTier[v18] or v18)
						end

						wisp.BarisResep.Text = "Essence:  " .. table.concat(tbl9, "   ")
						wisp.BarisResep.TextColor3 = if s.resepSiap then Color3.new(0.35294118523597717, 0.84313726425170898, 0.47058823704719543) else arg.Theme.TextSecondary
					end

					wisp.State.Text = "Status: " .. tostring(wisp2.Status)
					local n5 = tonumber(s.speed) or 0
					local n6 = tonumber(s.butuh) or 0
					local selesai, selesaiJ, selesaiI

					if s.unlocked then
						selesai = tbl4.Selesai
						selesaiJ = fn29("selesai_j")
						selesaiI = fn29("selesai_i")
					elseif s.accepted then
						selesai = tbl4.Ikut
						selesaiJ = fn29("ikut_j"):format(tonumber(s.stage) or 1, tonumber(s.tahap) or 4)
						selesaiI = s.siapPulang and fn29("ikut_siap") or fn29("ikut_i"):format(tostring(s.quest), tonumber(s.progres) or 0, tonumber(s.target) or 0, s.klaimbisa and fn29("ikut_klaim") or "")
					elseif s.zona then
						if not (n5 < n6) then
							selesai = tbl4.Siap
							selesaiJ = fn29("siap_j")
							selesaiI = fn29("siap_i"):format(fn26(n5), fn26(n6))
						else
							selesai = tbl4.Tolak
							selesaiJ = fn29("tolak_j")
							selesaiI = fn29("tolak_speed"):format(fn26(n5), fn26(n6), fn26(math.max(0, n6 - n5)))
						end
					else
						selesai = tbl4.Tolak
						selesaiJ = fn29("tolak_j")
						selesaiI = fn29("tolak_zona")
					end

					wisp.BanGaris.Color = selesai
					wisp.BanJudul.Text = selesaiJ
					wisp.BanJudul.TextColor3 = selesai
					wisp.BanIsi.Text = selesaiI
					wisp.Stage.Text = ("Stage: %d / %d  |  wisp essence: %d%s"):format(tonumber(s.stage) or 1, tonumber(s.tahap) or 4, tonumber(s.wessence) or 0, s.siapPulang and "  |  READY TO RETURN" or "")

					for i, v18 in ipairs(s.quests or {}) do
						local tbl9 = wisp.QuestRows[i]

						if not tbl9 then
							local Frame2 = arg.new("Frame", {
								Parent = wisp.QuestHost,
								Name = "Q" .. i,
								Size = UDim2.new(1, 0, 0, 24),
								BackgroundTransparency = 1,
								LayoutOrder = i,
							})

							tbl9 = {
								judul = arg.new("TextLabel", {
									Parent = Frame2,
									Name = "T",
									Size = UDim2.new(1, -74, 1, 0),
									BackgroundTransparency = 1,
									Font = arg.FONT,
									TextSize = 14.5,
									TextXAlignment = Enum.TextXAlignment.Left,
									TextYAlignment = Enum.TextYAlignment.Center,
									TextTruncate = Enum.TextTruncate.AtEnd,
									Text = "",
								}),
								cacah = arg.new("TextLabel", {
									Parent = Frame2,
									Name = "N",
									Size = UDim2.new(0, 70, 1, 0),
									Position = UDim2.new(1, -70, 0, 0),
									BackgroundTransparency = 1,
									Font = arg.FONT,
									TextSize = 14.5,
									TextXAlignment = Enum.TextXAlignment.Right,
									TextYAlignment = Enum.TextYAlignment.Center,
									Text = "",
								}),
							}

							wisp.QuestRows[i] = tbl9
						end

						local text = arg.Theme.Text

						if v18.selesai then
							text = tbl8.selesai
						elseif v18.kunci then
							text = tbl8.kunci
						end

						tbl9.judul.Text = ("%d.  %s"):format(i, tostring(v18.judul))
						tbl9.judul.Font = v18.kini and arg.FONT_BOLD or arg.FONT
						tbl9.judul.TextColor3 = text
						tbl9.cacah.Text = v18.kunci and "-" or ("%d / %d"):format(tonumber(v18.progres) or 0, tonumber(v18.target) or 0)
						tbl9.cacah.TextColor3 = text
					end
				end)

				if not ok then
					tbl.LOG.err("UIX.wisp.detak", result)
				end
			end

			task.wait(1)
		end
	end)
end

uix.BuildScramble = function(arg, arg2)
	uix.SCR = {}
	local scr = uix.SCR
	local n3 = 0

	local function fn25()
		n3 += 1
		return n3
	end

	uix.Section(arg2, "Predict Laboratory", fn25(), true)
	local textRow = arg.textRow
	local v4 = fn25()
	scr.LabNow = textRow(arg2, "Now: -", v4)
	scr.LabList = {}

	for i = 1, tbl.STEAL.LAB.RAMAL_N do
		local labList = scr.LabList
		local textRow2 = arg.textRow
		local str2 = ("#%d  -"):format(i)
		local v5 = fn25()
		labList[i] = textRow2(arg2, str2, v5)
	end

	local section = uix.Section
	local v5 = fn25()
	section(arg2, "Dr. Scramble Laboratory", v5)
	local textRow2 = arg.textRow
	local v6 = fn25()
	scr.LabBanner = textRow2(arg2, "Banner: -", v6)
	local textRow3 = arg.textRow
	local v7 = fn25()
	scr.LabReq = textRow3(arg2, "Requirements: -", v7)
	local textRow4 = arg.textRow
	local v8 = fn25()
	scr.LabBahan = textRow4(arg2, "Eggs: -", v8)
	local toggleSatu = uix.ToggleSatu
	local v9 = fn25()
	local tbl2 = { label = "Auto Steal Lab Eggs", key = "LabEgg" }

	local function onChange(arg3)
		tbl.STEAL.RIFT.Prioritas = arg3 and true or false
		if arg3 then
			task.spawn(tbl.STEAL.LAB.Tarik, true)
			return
		end
	end

	tbl2.onChange = onChange
	scr.LabEgg = toggleSatu(arg2, v9, tbl2)

	scr.LabAuto = uix.ToggleSatu(arg2, fn25(), {
		label = "Auto Trade-In Laboratory",
		key = "LabAuto",
		onChange = function(arg3)
			if arg3 then
				tbl.STEAL.LAB.Start()
				return
			end
			tbl.STEAL.LAB.Stop()
		end,
	})

	scr.LabBannerPilih = uix.DropdownMulti(arg2, "Target Banner (none = any)", fn25(), tbl.STEAL.LAB.Banners() or {}, function(arg3, arg4)
		local bannerPilih = {}

		for _, v10 in ipairs(arg4 or {}) do
			bannerPilih[v10] = true
		end

		tbl.STEAL.LAB.BannerPilih = bannerPilih
	end, "LabBanners")

	local section2 = uix.Section
	local v10 = fn25()
	section2(arg2, "Experiment Shop", v10)
	local tbl3 = {}
	local tbl4 = {}

	local function fn26()
		local ok, result = pcall(tbl.STEAL.SCR.Toko)

		if ok then
			if type(result) == "table" then
				for i = #tbl3, 1, -1 do
					tbl3[i] = nil
				end

				table.clear(tbl4)

				for _, v11 in ipairs(result) do
					local str2 = ("%s  (%s)"):format(tostring(v11.Label or v11.Id), tostring(v11.Price))
					tbl3[#tbl3 + 1] = str2
					tbl4[str2] = v11.Id
				end

				return #tbl3
			end

			return 0
		end

		return 0
	end

	fn26()

	local function fn27()
		local beliPilih = {}

		for _, v11 in ipairs(scr.Items and scr.Items.List() or {}) do
			local v12 = tbl4[v11]

			if v12 then
				beliPilih[v12] = true
			end
		end

		tbl.STEAL.SCR.BeliPilih = beliPilih
	end

	scr.Items = uix.DropdownMulti(arg2, "Items to Auto Buy", fn25(), tbl3, fn27, "ScrBuyItems")
	fn27()

	scr.Buy = uix.Toggle(arg2, "Auto Buy Experiment Shop Items", fn25(), false, function(arg3)
		tbl.STEAL.SCR.AutoBuy = arg3 and true or false
		fn27()
		tbl.STEAL.SCR.Sync()
	end, "ScrAutoBuy")

	tbl.ST.Trove:Connect(arg2:GetPropertyChangedSignal("Visible"), function()
		if arg2.Visible then
			fn26()
			return
		end
	end)

	arg.buttonRow(arg2, "Open Experiment Vault", fn25(), function()
		tbl.STEAL.SCR.Vault()
	end)

	task.spawn(function()
		while tbl.Alive do
			if arg2.Visible then
				local ok, result = pcall(function()
					local scr2 = tbl.STEAL.SCR
					scr2.Snapshot()
					scr2.Drones = #scr2.DroneList()
					local v11 = tbl.STEAL.LAB.Ramal()

					if v11.now and v11.nowAt then
						local serverTimeNow = workspace:GetServerTimeNow()
						local n4 = math.max(0, math.floor(v11.nowAt - serverTimeNow))
						scr.LabNow.Text = ("Now: %s  |  rotates in %dm %ds  |  every %dm"):format(v11.now, n4 // 60, n4 % 60, math.floor((v11.rot or 3600) / 60))

						for i, v12 in ipairs(scr.LabList) do
							local v13 = v11.daftar[i]

							if v13 then
								local v14 = os.date("%I:%M %p", math.floor(v13.at))
								local str2 = tostring(v14):gsub("^0", "")
								local n5 = math.max(0, math.floor(v13.at - serverTimeNow))
								v12.Text = ("#%d%s  %s  -  %s  -  %s  -  Chase %s %s"):format(i, i == 1 and " NEXT" or "", v13.disp, str2, n5 >= 3600 and ("in %dh %dm"):format(n5 // 3600, n5 % 3600 // 60) or ("in %dm"):format(n5 // 60), tostring(v13.chase or "?"), v13.pct and ("%.2f%%"):format(v13.pct) or "")
							else
								v12.Text = ("#%d  -"):format(i)
							end
						end
					end

					local lab = tbl.STEAL.LAB
					local v12 = lab.Tarik(false)
					local labBanner = scr.LabBanner
					local str2 = "Banner: %s%s"
					local format = ("Banner: %s%s").format
					local v13 = tostring
					local bannerDisplayName

					if v12 then
						bannerDisplayName = v12.BannerDisplayName or v12.BannerId or "-"
					else
						bannerDisplayName = "-"
					end

					labBanner.Text = format(str2, v13(bannerDisplayName), if v12 then " - rotates in " .. math.floor(lab.Sisa()) .. "s" else "")
					scr.LabReq.Text = ("Requirements: %d/%d ready  |  missing: %s  |  %s"):format(lab.siap, lab.total, tostring(lab.kurang), tostring(lab.status))
					local tbl5 = {}

					for _, v14 in ipairs(lab.Segar()) do
						tbl5[#tbl5 + 1] = ("%s %d/%d"):format(v14.nama, v14.bebas or 0, v14.butuh)
					end

					scr.LabBahan.Text = "Eggs: " .. (not (#tbl5 > 0) and "-" or table.concat(tbl5, "  |  "))
				end)

				if not ok then
					tbl.LOG.warn("SCR", "detak status: " .. tostring(result))
				end
			end

			task.wait(1)
		end
	end)
end

uix.BuildESP = function(arg, arg2)
	uix.ESP = {}
	local esp = uix.ESP
	local n3 = 0

	local function fn25()
		n3 += 1
		return n3
	end

	local function fn26()
		local steal2 = tbl.STEAL
		steal2.ESP.Apply()
	end

	local section = uix.Section
	local v4 = fn25()
	section(arg2, "Pen Eggs", v4)
	esp.MyPen = uix.ToggleSatu(arg2, fn25(), { label = "My Pen", key = "EspPenMine", onChange = fn26 })
	esp.OtherPen = uix.ToggleSatu(arg2, fn25(), { label = "Other Players", key = "EspPenOthers", onChange = fn26 })
	local section2 = uix.Section
	local v5 = fn25()
	section2(arg2, "Area Eggs", v5)
	esp.AreaEgg = uix.ToggleSatu(arg2, fn25(), { label = "Area Egg ESP", key = "EspAreaEggs", onChange = fn26 })

	local function fn27()
		task.spawn(function()
			pcall(tbl.STEAL.ESP.Sync)
			pcall(tbl.STEAL.ESP.Repaint)
		end)
	end

	esp.AreaRarity = uix.DropdownMulti(arg2, "Rarity Filter (none = all)", fn25(), tbl.STEAL.RarityList(), fn27, "EspAreaRarity")
	local section3 = uix.Section
	local v6 = fn25()
	section3(arg2, "Display", v6)
	esp.ShowIcon = uix.ToggleSatu(arg2, fn25(), { label = "Show Pet Icon", default = true, key = "EspShowIcon", onChange = fn26 })
	esp.ShowRate = uix.ToggleSatu(arg2, fn25(), { label = "Show Rate (/sec)", default = true, key = "EspShowRate", onChange = fn26 })
	esp.ShowRarity = uix.Toggle(arg2, "Show Rarity & Pet Name", fn25(), true, fn26, "EspShowRarity")
	esp.MaxDist = uix.Slider(arg2, "Max ESP Distance", fn25(), 50, 2000, 600, fn26, " stud")
end

uix.BuildGuard = function(arg, arg2)
	uix.GUARD = {}
	local guard = uix.GUARD
	local n3 = 0

	local function fn25()
		n3 += 1
		return n3
	end

	uix.Section(arg2, "Ride Guard", fn25(), true)
	local list = tbl.STEAL.RIDE.List and tbl.STEAL.RIDE.List() or {}
	local tbl2

	if #list ~= 0 then
		tbl2 = list
	else
		tbl2 = { "Cherry Blossom" }
	end

	local function fn26(arg3)
		if guard.onPick then
			pcall(guard.onPick, arg3)
			return
		end
	end

	local v4 = uix.Dropdown(arg2, "Guard", fn25(), tbl2, tbl2[1], fn26, "GuardPick")
	local pick = { Get = v4.Get, Set = v4.Set }

	local function setCallback(onPick)
		guard.onPick = onPick
	end

	pick.SetCallback = setCallback

	pick.Refill = function(arg3)
		if type(arg3) ~= "table" then
			return
		end

		for i = #tbl2, 1, -1 do
			tbl2[i] = nil
		end

		for i, v5 in ipairs(arg3) do
			tbl2[i] = v5
		end
	end

	guard.Pick = pick

	local function fn27()
		tbl.STEAL.RIDE.Sync()
	end

	guard.Ride = uix.Toggle(arg2, "Ride Guard", fn25(), false, fn27, "RideGuard")
	local new = arg.new

	local tbl3 = {
		Parent = arg2,
		Name = "GuardPreview",
		Size = UDim2.new(1, 0, 0, 190),
		LayoutOrder = fn25(),
		BackgroundColor3 = arg.Theme.Card,
		BorderSizePixel = 0,
	}

	local tbl4 = {}
	local v5 = arg.corner(10)
	local stroke = arg.stroke
	local border = arg.Theme.Border
	tbl4[1] = v5

	do
		local values = table.pack(stroke(border, 1, 0.6))
		table.move(values, 1, values.n, 2, tbl4)
	end

	local Frame = new("Frame", tbl3, tbl4)

	local ViewportFrame = arg.new("ViewportFrame", {
		Parent = Frame,
		Name = "Preview",
		Size = UDim2.new(1, -12, 1, -34),
		Position = UDim2.new(0, 6, 0, 6),
		BackgroundTransparency = 1,
		Ambient = Color3.new(0.7450980544090271, 0.7450980544090271, 0.78431373834609985),
		LightColor = Color3.new(1, 1, 1),
	})

	ViewportFrame.CurrentCamera = arg.new("Camera", { Parent = ViewportFrame })

	local TextLabel = arg.new("TextLabel", {
		Parent = ViewportFrame,
		Name = "Placeholder",
		Size = UDim2.new(1, 0, 1, 0),
		BackgroundTransparency = 1,
		Font = arg.FONT,
		TextSize = 13,
		TextColor3 = arg.Theme.TextSecondary,
		Text = "No guard model loaded",
	})

	local TextLabel2 = arg.new("TextLabel", {
		Parent = Frame,
		Name = "GuardName",
		Size = UDim2.new(1, -12, 0, 20),
		Position = UDim2.new(0, 6, 1, -26),
		BackgroundTransparency = 1,
		Font = arg.FONT_BOLD,
		TextSize = 14,
		TextColor3 = arg.Theme.Text,
		Text = tostring(v4.Get() or tbl2[1]),
	})

	guard.Viewport = ViewportFrame
	guard.NameLabel = TextLabel2
	guard.Placeholder = TextLabel

	guard.Pick.SetCallback(function(arg3)
		TextLabel2.Text = tostring(arg3)
		pcall(tbl.STEAL.RIDE.Preview, arg3)
		if tbl.STEAL.RIDE.Aktif and tbl.STEAL.RIDE.Aktif() then
			pcall(tbl.STEAL.RIDE.Spawn, arg3)
			return
		end
	end)

	local flag2 = false
	local trove = tbl.ST.Trove
	local v6 = trove
	local connect = trove.Connect

	local function fn28()
		if arg2.Visible then
			local v7 = tbl.STEAL.RIDE.List()

			if #v7 > 0 then
				guard.Pick.Refill(v7)
			end

			if not flag2 and #v7 > 0 then
				flag2 = true
				pcall(tbl.STEAL.RIDE.Preview, guard.Pick.Get())
				return
			end

			return
		end
	end

	connect(v6, arg2:GetPropertyChangedSignal("Visible"), fn28)
end

uix.ServerRow = function(arg, arg2, arg3, arg4)
	local lib = uix.lib
	local new = lib.new

	local tbl2 = {
		Parent = arg,
		Name = "srv" .. tostring(arg2),
		Size = UDim2.new(1, 0, 0, 44),
		LayoutOrder = arg2,
		BackgroundColor3 = lib.Theme.Card,
		BackgroundTransparency = 0.3,
		BorderSizePixel = 0,
	}

	local tbl3 = {}
	local v4 = lib.corner(8)
	local stroke = lib.stroke
	local border = lib.Theme.Border
	tbl3[1] = v4

	do
		local values = table.pack(stroke(border, 1, 0.6))
		table.move(values, 1, values.n, 2, tbl3)
	end

	local Frame = new("Frame", tbl2, tbl3)

	lib.new("ImageLabel", {
		Parent = Frame,
		Name = "Thumb",
		Image = ("rbxthumb://type=GameIcon&id=%d&w=150&h=150"):format(game.GameId),
		Size = UDim2.new(0, 30, 0, 30),
		Position = UDim2.new(0, 8, 0.5, 0),
		AnchorPoint = Vector2.new(0, 0.5),
		BackgroundColor3 = lib.Theme.CardHover,
		BackgroundTransparency = 0,
	}, { lib.corner(6) })

	local new2 = lib.new

	local tbl4 = {
		Parent = Frame,
		Name = "Title",
		Text = tostring(arg3 and arg3.title or "Server"),
		Font = lib.FONT_BOLD,
		TextSize = 14,
		TextColor3 = lib.Theme.Text,
		BackgroundTransparency = 1,
		TextXAlignment = Enum.TextXAlignment.Left,
		TextTruncate = Enum.TextTruncate.AtEnd,
	}

	tbl4.Size = UDim2.new(1, -140, 0, 15)
	tbl4.Position = UDim2.new(0, 46, 0.5, -15)
	new2("TextLabel", tbl4)

	lib.new("TextLabel", {
		Parent = Frame,
		Name = "Sub",
		Text = tostring(arg3 and arg3.sub or ""),
		Font = lib.FONT,
		TextSize = 12,
		TextColor3 = lib.Theme.TextSecondary,
		BackgroundTransparency = 1,
		TextXAlignment = Enum.TextXAlignment.Left,
		TextTruncate = Enum.TextTruncate.AtEnd,
		Size = UDim2.new(1, -140, 0, 13),
		Position = UDim2.new(0, 46, 0.5, 2),
	})

	local new3 = lib.new

	local tbl5 = {
		Parent = Frame,
		Name = "Hop",
		Size = UDim2.new(0, 62, 0, 26),
		Position = UDim2.new(1, -10, 0.5, 0),
		AnchorPoint = Vector2.new(1, 0.5),
		BackgroundColor3 = lib.Theme.CardHover,
		AutoButtonColor = false,
		Font = lib.FONT_BOLD,
		TextSize = 13,
		TextColor3 = lib.Theme.Text,
		Text = "Hop",
	}

	local tbl6 = {}
	local v5 = lib.corner(6)
	local stroke2 = lib.stroke
	local borderLight = lib.Theme.BorderLight
	tbl6[1] = v5

	do
		local values = table.pack(stroke2(borderLight, 1, 0.4))
		table.move(values, 1, values.n, 2, tbl6)
	end

	local mouseButton1Click = new3("TextButton", tbl5, tbl6).MouseButton1Click
	local v6 = mouseButton1Click
	local connect = mouseButton1Click.Connect

	local function fn25()
		if arg4 then
			task.spawn(arg4)
			return
		end
	end

	connect(v6, fn25)
	return Frame
end

uix.BuildHop = function(arg, arg2)
	uix.HOP = {}
	local hop = uix.HOP
	local n3 = 0

	local function fn25()
		n3 += 1
		return n3
	end

	uix.Section(arg2, "Auto Execute", fn25(), true)

	local function fn26(arg3)
		tbl.STEAL.HOP.SetClosed(not arg3)
		if arg3 then
			tbl.STEAL.HOP.Arm()
			return
		end
	end

	hop.AutoExec = uix.Toggle(arg2, "Auto Execute", fn25(), false, fn26, "AutoExecute")
	uix.Section(arg2, "Hop Server", fn25(), true)

	arg.buttonRow(arg2, "Hop Now (Emptiest Server)", fn25(), function()
		task.spawn(tbl.STEAL.HOP.Emptiest)
	end)

	local textRow = arg.textRow
	local v4 = fn25()
	hop.MyPing = textRow(arg2, "Your ping: -- ms", v4)

	hop.ListHost = arg.new("Frame", {
		Parent = arg2,
		Name = "ServerList",
		Size = UDim2.new(1, 0, 0, 0),
		AutomaticSize = Enum.AutomaticSize.Y,
		BackgroundTransparency = 1,
		LayoutOrder = fn25(),
	}, { arg.new("UIListLayout", { Padding = UDim.new(0, 6), SortOrder = Enum.SortOrder.LayoutOrder }) })

	local textRow2 = arg.textRow
	local v5 = fn25()
	hop.PageLabel = textRow2(arg2, "Page 1 / 1", v5)

	local function fn27(arg3)
		arg.buttonRow(arg3, "Prev", 1, function()
			task.spawn(tbl.STEAL.HOP.Load, "prev")
		end)
	end

	local function fn28(arg3)
		arg.buttonRow(arg3, "Next", 1, function()
			task.spawn(tbl.STEAL.HOP.Load, "next")
		end)
	end

	arg.dualRow(arg2, fn25(), fn27, fn28)
	local buttonRow = arg.buttonRow
	local v6 = fn25()

	local function fn29()
		task.spawn(tbl.STEAL.HOP.Load, "refresh")
	end

	buttonRow(arg2, "Refresh Server List", v6, fn29)
	local flag2 = false
	local trove = tbl.ST.Trove
	local v7 = trove
	local connect = trove.Connect

	local function fn30()
		if arg2.Visible then
			if flag2 then
				return
			end
			flag2 = true
			task.spawn(tbl.STEAL.HOP.Load, "refresh")
			return
		end
	end

	connect(v7, arg2:GetPropertyChangedSignal("Visible"), fn30)
end

uix.BuildWebhook = function(arg, arg2)
	uix.WEBHOOK = {}
	local webhook = uix.WEBHOOK
	local n3 = 0

	local function fn25()
		n3 += 1
		return n3
	end

	uix.Section(arg2, "Destination", fn25(), true)

	local function fn26()
		tbl.STEAL.WH.Sync()
	end

	webhook.URL = uix.Input(arg2, "Webhook URL", fn25(), "", "https://discord.com/api/webhooks/...", fn26, "WebhookURL")
	local toggle = uix.Toggle
	local v4 = fn25()

	local function fn27()
		tbl.STEAL.WH.Sync()
	end

	webhook.Enable = toggle(arg2, "Enable Webhook", v4, false, fn27, "WebhookEnable")
	local v5 = tbl.STEAL.RarityList()
	local section = uix.Section
	local v6 = fn25()
	section(arg2, "Egg Deposited", v6)
	webhook.Rarities = uix.DropdownMulti(arg2, "Rarities (empty = all)", fn25(), v5, nil, "WebhookRarities")
	webhook.PlotDetails = uix.ToggleSatu(arg2, fn25(), { label = "Include Plot Details", key = "WebhookPlotDetails" })
	webhook.Backpack = uix.ToggleSatu(arg2, fn25(), { label = "Include Backpack", key = "WebhookBackpack" })
	webhook.TagEveryone = uix.Toggle(arg2, "Tag @everyone", fn25(), false, nil, "WebhookTagEveryone")
	local section2 = uix.Section
	local v7 = fn25()
	section2(arg2, "Egg Spawned", v7)
	webhook.SpawnOn = uix.Toggle(arg2, "Spawn Announcement", fn25(), false, nil, "WebhookSpawnOn")
	webhook.SpawnRarities = uix.DropdownMulti(arg2, "Spawn Rarities (empty = all)", fn25(), v5, nil, "WebhookSpawnRarities")
	local section3 = uix.Section
	local v8 = fn25()
	section3(arg2, "Connection", v8)
	webhook.DiscAlert = uix.Toggle(arg2, "Disconnect Alert", fn25(), false, nil, "WebhookDiscAlert")
	local section4 = uix.Section
	local v9 = fn25()
	section4(arg2, "Manual Actions", v9)

	local function fn28()
		task.spawn(function()
			local v10, v11 = tbl.STEAL.WH.SendNow()
			uix.Pita(tostring(v11), 4)
			if v10 then
				return
			end
			tbl.LOG.warn("WH", tostring(v11))
		end)
	end

	arg.buttonRow(arg2, "Send Webhook Preview", fn25(), fn28)
end

uix.BuildFPS = function(arg, arg2)
	uix.FPS = {}
	local fps = uix.FPS
	local n3 = 0

	local function fn25()
		n3 += 1
		return n3
	end

	local section = uix.Section
	local v4 = fn25()
	section(arg2, "Engine Performance", v4)

	fps.Boost = uix.Toggle(arg2, "FPS Boost", fn25(), false, function()
		tbl.STEAL.BOOST.Sync()
	end, "FpsBoost")

	arg.buttonRow(arg2, "Re-apply Boost Now", fn25(), function()
		tbl.STEAL.BOOST.Apply()
		if tbl.STEAL.HIDE.on then
			tbl.STEAL.HIDE.Sweep()
			return
		end
	end)

	local section2 = uix.Section
	local v5 = fn25()
	section2(arg2, "Visual & Clean Up", v5)

	fps.DeleteOthers = uix.Toggle(arg2, "Hide Other Players", fn25(), false, function()
		tbl.STEAL.HIDE.Sync()
	end, "HideOthers")
end

uix.BIGEGG_URL = "http://143.14.13.87:8080/api/big-egg"
uix.BIGEGG_UMUR = 300
uix.BIGEGG_NOTIF = 10000000

uix.BuildBigEgg = function(arg, arg2)
	uix.BIGEGG = {}
	local bigegg = uix.BIGEGG
	local n3 = 0

	local function fn25()
		n3 += 1
		return n3
	end

	uix.Section(arg2, "Active Big Eggs (5-Min Lifespan)", fn25(), true)
	local textRow = arg.textRow
	local v4 = fn25()
	bigegg.Status = textRow(arg2, "Not fetched yet.", v4)

	bigegg.Kunci = arg.new("TextLabel", {
		Parent = bigegg.Status.Parent,
		Name = "LockNote",
		Size = UDim2.new(1, 0, 0, 16),
		BackgroundTransparency = 1,
		Font = arg.FONT_BOLD,
		TextSize = 12,
		TextColor3 = Color3.new(1, 0.78431373834609985, 0.27450981736183167),
		TextXAlignment = Enum.TextXAlignment.Left,
		TextTruncate = Enum.TextTruncate.AtEnd,
		Visible = false,
		LayoutOrder = fn25(),
		Text = "Only for Premium Member - Gold, Premium or Lifetime key.",
	})

	local function syncKunci()
		bigegg.Kunci.Visible = not uix.Bayar()
	end

	bigegg.SyncKunci = syncKunci
	bigegg.SyncKunci()

	arg.buttonRow(arg2, "Refresh", fn25(), function()
		task.spawn(function()
			pcall(bigegg.Refresh)
		end)
	end)

	local Frame = arg.new("Frame", {
		Parent = arg2,
		Name = "EggList",
		Size = UDim2.new(1, 0, 0, 0),
		AutomaticSize = Enum.AutomaticSize.Y,
		BackgroundTransparency = 1,
		LayoutOrder = fn25(),
	}, { arg.new("UIListLayout", { Padding = UDim.new(0, 6), SortOrder = Enum.SortOrder.LayoutOrder }) })

	local color = Color3.new(1, 0.78431373834609985, 0.27450981736183167)

	local function fn26(arg3)
		local num = tonumber(arg3.weightKg)
		if num then
			return num
		end
		local num2 = tbl.STEAL.Num
		local str2 = tostring(arg3.weightFormatted or ""):gsub("[Kk][Gg]%s*$", "")
		return num2(str2)
	end

	bigegg.nilaiCache = {}

	bigegg.Nilai = function(arg3)
		local flag2 = false

		task.spawn(function()
			pcall(function()
				local earn = tbl.STEAL.INV and tbl.STEAL.INV.Earn and tbl.STEAL.INV.Earn()

				for _, v5 in ipairs(arg3) do
					local egg = v5.egg or {}
					local nilai = tonumber(egg.value)

					if nilai and nilai > 0 then
						v5._nilai = nilai
						v5._kira = false
					elseif earn and egg.name then
						local str2 = tostring(egg.name) .. "|" .. tostring(egg.scale)
						local nilai2 = bigegg.nilaiCache[str2]

						if nilai2 == nil then
							local ok, result = pcall(earn.RatePerSecond, { Category = tostring(egg.name), Scale = tonumber(egg.scale) or 1, Mutations = {} })
							nilai2 = ok and type(result) == "number" and result > 0 and result or false
							bigegg.nilaiCache[str2] = nilai2
						end

						if nilai2 then
							v5._nilai = nilai2
							v5._kira = true
						end
					end
				end
			end)

			flag2 = true
		end)

		local n4 = os.clock() + 2

		while not flag2 do
			if not (os.clock() < n4) then
				break
			end
			task.wait()
		end

		local n5 = 0

		for k in pairs(bigegg.nilaiCache) do
			n5 += 1
		end

		if not (n5 > 500) then
			return
		end
		bigegg.nilaiCache = {}
	end

	local color2 = Color3.new(0.43137255311012268, 0.86274510622024536, 0.50980395078659058)

	local function draw(arg3)
		for _, child in ipairs(Frame:GetChildren()) do
			if child:IsA("GuiObject") then
				child:Destroy()
			end
		end

		for i, v5 in ipairs(arg3) do
			local egg = v5.egg or {}
			local flag2 = fn26(egg) >= 10000000
			local new = arg.new

			local tbl2 = {
				Parent = Frame,
				LayoutOrder = i,
				Size = UDim2.new(1, 0, 0, 64),
				BackgroundColor3 = if flag2 then Color3.new(0.14901961386203766, 0.12549020349979401, 0.062745101749897) else arg.Theme.Card,
			}

			local tbl3 = {}
			local v6 = arg.corner(8)
			local new2 = arg.new

			local tbl4 = {
				Thickness = flag2 and 1.4 or 1,
				Color = if flag2 then Color3.new(1, 0.78431373834609985, 0.27450981736183167) else arg.Theme.Border,
				Transparency = flag2 and 0.15 or 0,
			}

			local v7 = table.pack(new2("UIStroke", tbl4))
			tbl3[1] = v6

			do
				local values = table.pack(table.unpack(v7, 1, v7.n))
				table.move(values, 1, values.n, 2, tbl3)
			end

			local Frame2 = new("Frame", tbl2, tbl3)
			local v8 = tbl.STEAL.AssetIcon(egg.name)

			local Frame3 = arg.new("Frame", {
				Parent = Frame2,
				Name = "Icon",
				Size = UDim2.new(0, 46, 0, 46),
				Position = UDim2.new(0, 9, 0.5, -23),
				BackgroundColor3 = arg.Theme.CardHover,
				BorderSizePixel = 0,
			}, { arg.corner(8) })

			if v8 ~= "" then
				local tbl5 = {
					Parent = Frame3,
					Name = "Pet",
					Size = UDim2.new(1, -6, 1, -6),
					Position = UDim2.new(0, 3, 0, 3),
					BackgroundTransparency = 1,
					Image = v8,
					ScaleType = Enum.ScaleType.Fit,
				}

				arg.new("ImageLabel", tbl5)
			end

			if flag2 then
				arg.new("TextLabel", {
					Parent = Frame3,
					Name = "Star",
					Size = UDim2.new(0, 18, 0, 18),
					Position = UDim2.new(1, -11, 0, -7),
					BackgroundTransparency = 1,
					Font = arg.FONT_BOLD,
					TextSize = 16,
					TextColor3 = color,
					Text = "★",
					ZIndex = 3,
				})
			end

			arg.new("TextLabel", {
				Parent = Frame2,
				Name = "Nama",
				BackgroundTransparency = 1,
				Size = UDim2.new(1, -143, 0, 16),
				Position = UDim2.new(0, 65, 0, 7),
				Font = arg.FONT_BOLD,
				TextSize = 13,
				TextColor3 = if flag2 then Color3.new(1, 0.78431373834609985, 0.27450981736183167) else arg.Theme.Text,
				TextXAlignment = Enum.TextXAlignment.Left,
				TextTruncate = Enum.TextTruncate.AtEnd,
				Text = tostring(egg.name or "Big Egg"),
			})

			local new3 = arg.new

			local tbl5 = {
				Parent = Frame2,
				Name = "Berat",
				BackgroundTransparency = 1,
				Size = UDim2.new(1, -143, 0, 20),
				Position = UDim2.new(0, 65, 0, 23),
				Font = arg.FONT_BOLD,
				TextSize = 18,
			}

			local color3

			if flag2 then
				color3 = Color3.new(1, 0.78431373834609985, 0.27450981736183167)
			else
				color3 = arg.Theme.Text
			end

			tbl5.TextColor3 = color3
			tbl5.TextXAlignment = Enum.TextXAlignment.Left
			tbl5.Text = tostring(egg.weightFormatted or "?")
			new3("TextLabel", tbl5)

			if v5._nilai then
				arg.new("TextLabel", {
					Parent = Frame2,
					Name = "Harga",
					BackgroundTransparency = 1,
					Size = UDim2.new(1, -143, 0, 20),
					Position = UDim2.new(0, 65, 0, 23),
					Font = arg.FONT_BOLD,
					TextSize = 14,
					TextColor3 = color2,
					TextXAlignment = Enum.TextXAlignment.Right,
					Text = (v5._kira and "~" or "") .. tbl.STEAL.Duit(v5._nilai) .. "/s" .. (not v5._kira and (tonumber(egg.mutations) or 0) > 0 and ("  (%d mut)"):format(tonumber(egg.mutations)) or ""),
				})
			end

			arg.new("TextLabel", {
				Parent = Frame2,
				Name = "Sub",
				BackgroundTransparency = 1,
				Size = UDim2.new(1, -143, 0, 14),
				Position = UDim2.new(0, 65, 0, 44),
				Font = arg.FONT,
				TextSize = 11,
				TextColor3 = arg.Theme.TextSecondary,
				TextXAlignment = Enum.TextXAlignment.Left,
				TextTruncate = Enum.TextTruncate.AtEnd,
				Text = ("%s  •  %s  •  %d players"):format(tostring(egg.rarity or "?"), tostring(egg.area or "?"), tonumber(v5.serverPlayers) or 0),
			})

			local str2 = tostring(v5.jobId or "")
			local new4 = arg.new

			local tbl6 = {
				Parent = Frame2,
				Size = UDim2.new(0, 62, 0, 26),
				Position = UDim2.new(1, -72, 0.5, -13),
				BackgroundColor3 = arg.Theme.CardHover,
				AutoButtonColor = false,
				Font = arg.FONT_BOLD,
				TextSize = 12,
				TextColor3 = arg.Theme.Text,
				Text = "Join",
			}

			local tbl7 = {}
			local v9 = arg.corner(6)
			local stroke = arg.stroke
			local border = arg.Theme.Border
			tbl7[1] = v9

			do
				local values = table.pack(stroke(border, 1))
				table.move(values, 1, values.n, 2, tbl7)
			end

			local TextButton = new4("TextButton", tbl6, tbl7)

			if uix.Bayar() then
				if str2 == "" or str2 == tostring(game.JobId) then
					TextButton.Text = "Here"
					TextButton.TextColor3 = arg.Theme.TextSecondary
				else
					local mouseButton1Click = TextButton.MouseButton1Click
					local v10 = mouseButton1Click
					local connect = mouseButton1Click.Connect

					local function fn27()
						task.spawn(tbl.STEAL.HOP.Go, str2)
					end

					connect(v10, fn27)
				end
			else
				TextButton.Text = "Locked"
				TextButton.TextColor3 = arg.Theme.TextSecondary
				local mouseButton1Click = TextButton.MouseButton1Click
				local v10 = mouseButton1Click
				local connect = mouseButton1Click.Connect

				local function fn27()
					uix.TolakKunci("Joining a Big Egg server")
				end

				connect(v10, fn27)
			end
		end
	end

	bigegg.Draw = draw
	bigegg.dilapor = {}

	bigegg.Lapor = function(arg3)
		local now = os.time()

		for k, v5 in pairs(bigegg.dilapor) do
			if uix.BIGEGG_UMUR < now - v5 then
				bigegg.dilapor[k] = nil
			end
		end

		local n4 = 0
		local tbl2 = nil

		for _, v5 in ipairs(arg3) do
			local egg = v5.egg or {}
			local v6 = fn26(egg)

			if uix.BIGEGG_NOTIF <= v6 then
				local str2 = ("%s|%s"):format(tostring(v5.jobId or "?"), tostring(v5.timestamp or "?"))

				if not bigegg.dilapor[str2] then
					bigegg.dilapor[str2] = now
					n4 += 1

					if tbl2 then
						if tbl2.kg < v6 then
							tbl2 = { kg = v6, e = egg }
						end
					else
						tbl2 = { kg = v6, e = egg }
					end
				end
			end
		end

		if tbl2 then
			if uix.Pita then
				uix.Pita(("Big Egg: %s %s in %s%s"):format(tostring(tbl2.e.name or "?"), tostring(tbl2.e.weightFormatted or "?"), tostring(tbl2.e.area or "?"), n4 > 1 and ("  (+%d more)"):format(n4 - 1) or ""), 8)
				return
			end
			return
		end
	end

	local function refresh()
		local request_ = request or http_request or syn and syn.request
		if type(request_) ~= "function" then
			bigegg.Status.Text = "Executor has no request()"
			return
		end
		local v5 = pcall
		local tbl2 = {}
		local bigeggUrl = uix.BIGEGG_URL
		tbl2.Url = bigeggUrl
		tbl2.Method = "GET"
		local v6, v7 = v5(request_, tbl2)
		local body = v6 and v7 and (v7.Body or v7.body)
		if not body then
			bigegg.Status.Text = "Server not responding"
			return
		end

		local function fn27()
			return tbl.SV.HttpService:JSONDecode(body)
		end

		local ok, result = pcall(fn27)

		if ok then
			if type(result) ~= "table" then
				bigegg.Status.Text = "Unreadable response"
				return
			end
			local tbl3 = {}

			if type(result[1]) ~= "table" then
				if type(result.data) ~= "table" then
					if type(result.eggs) ~= "table" then
						if result.egg then
							result = { result }
						else
							result = tbl3
						end
					else
						result = result.eggs
					end
				else
					result = result.data
				end
			end

			local now = os.time()
			local tbl4 = {}

			for _, v8 in ipairs(result) do
				if type(v8) == "table" and now - (tonumber(v8.timestamp) or 0) <= uix.BIGEGG_UMUR then
					tbl4[#tbl4 + 1] = v8
				end
			end

			local function fn28(arg3, arg4)
				return (tonumber(arg3.timestamp) or 0) > (tonumber(arg4.timestamp) or 0)
			end

			table.sort(tbl4, fn28)
			bigegg.SyncKunci()
			pcall(bigegg.Nilai, tbl4)
			bigegg.Draw(tbl4)
			bigegg.Lapor(tbl4)
			local status = bigegg.Status
			local text

			if #tbl4 ~= 0 then
				text = ("%d active Big Egg%s."):format(#tbl4, #tbl4 ~= 1 and "s" or "")
			else
				text = "No active Big Egg."
			end

			status.Text = text
			return
		end

		bigegg.Status.Text = "Unreadable response"
	end

	bigegg.Refresh = refresh
	bigegg.POLL = 5

	task.spawn(function()
		task.wait(3)

		while tbl.Alive do
			if bigegg.Status then
				if bigegg.Status.Parent then
					pcall(bigegg.Refresh)
					task.wait(bigegg.POLL)
					continue
				end

				break
			end

			break
		end
	end)
end

uix.BuildSettings = function(arg, arg2)
	uix.SET = {}
	local set = uix.SET
	local n3 = 0

	local function fn25()
		n3 += 1
		return n3
	end

	local section = uix.Section
	local v4 = fn25()
	section(arg2, "Display", v4)

	set.FullSize = uix.Toggle(arg2, "Display Full Size (PC)", fn25(), true, function(arg3)
		pcall(arg.setWindowMode, arg3)
	end, "DisplayFullSizePC")

	local section2 = uix.Section
	local v5 = fn25()
	section2(arg2, "Anti-AFK Protection", v5)

	local function fn26()
		tbl.STEAL.AFK.Sync()
	end

	set.AntiAfk = uix.ToggleSatu(arg2, fn25(), { label = "Anti AFK", default = true, key = "AntiAfk", onChange = fn26 })
	set.AutoReconnect = uix.ToggleSatu(arg2, fn25(), { label = "Auto Reconnect", key = "AutoReconnect" })
	local section3 = uix.Section
	local v6 = fn25()
	section3(arg2, "Disconnect Log", v6)

	local function fn27()
		tbl.STEAL.DCLOG.Lihat()
	end

	arg.buttonRow(arg2, "View Disconnect Log", fn25(), fn27)

	arg.buttonRow(arg2, "Clear Log", fn25(), function()
		tbl.STEAL.DCLOG.Hapus()
	end)

	local section4 = uix.Section
	local v7 = fn25()
	section4(arg2, "Configuration", v7)

	local function fn28()
		tbl.LOG.warn("SET", tbl.CFG.Save() and "config saved" or "config save FAILED")
	end

	arg.buttonRow(arg2, "Save Settings Config", fn25(), fn28)
	local flag2 = false
	local buttonRow = arg.buttonRow
	local v8 = fn25()

	local function fn29()
		if flag2 then
			flag2 = false

			task.spawn(function()
				local v9, v10 = uix.ResetConfig()

				if v10 and v10 > 0 then
					tbl.LOG.warn("RESET", ("%d kontrol gagal dipulihkan"):format(v10))
				end

				tbl.LOG.warn("RESET", ("selesai - %d kontrol"):format(v9))
			end)

			return
		end

		flag2 = true
		uix.Pita("Tap Reset again within 5s to confirm", 5)

		task.delay(5, function()
			flag2 = false
			uix.Pita("Reset cancelled", 2)
		end)
	end

	buttonRow(arg2, "Reset Config to Default", v8, fn29)
end

uix.BuildChat = function(arg)
	local screenGui = arg.ScreenGui
	local theme = arg.Theme
	local new = arg.new

	local tbl2 = {
		Parent = screenGui,
		Name = "ChatWindow",
		Size = UDim2.new(0, 300, 0, 350),
		Position = UDim2.new(0.5, 0, 0.5, 0),
		AnchorPoint = Vector2.new(0.5, 0.5),
		BackgroundColor3 = theme.Window,
		Visible = false,
		Active = true,
		ZIndex = 400,
	}

	local tbl3 = {}
	local v4 = arg.corner(12)
	local stroke = arg.stroke
	local border = theme.Border
	tbl3[1] = v4

	do
		local values = table.pack(stroke(border, 1))
		table.move(values, 1, values.n, 2, tbl3)
	end

	local Frame = new("Frame", tbl2, tbl3)
	uix.ChatWin = Frame

	arg.new("TextLabel", {
		Parent = Frame,
		BackgroundTransparency = 1,
		Size = UDim2.new(1, -70, 0, 34),
		Position = UDim2.new(0, 14, 0, 6),
		Font = arg.FONT_BOLD,
		TextSize = 14,
		TextColor3 = theme.Text,
		TextXAlignment = Enum.TextXAlignment.Left,
		ZIndex = 401,
		Text = "Global Chat",
	})

	local function fn25(arg2, arg3, arg4)
		local TextButton = arg.new("TextButton", {
			Parent = Frame,
			Size = UDim2.new(0, 24, 0, 24),
			Position = UDim2.new(1, arg3, 0, 11),
			BackgroundTransparency = 1,
			AutoButtonColor = false,
			Font = arg.FONT_BOLD,
			TextSize = 14,
			TextColor3 = theme.TextSecondary,
			Text = arg2,
			ZIndex = 402,
		})

		TextButton.MouseButton1Click:Connect(arg4)
		return TextButton
	end

	local ScrollingFrame = arg.new("ScrollingFrame", {
		Parent = Frame,
		Name = "Feed",
		Size = UDim2.new(1, -20, 1, -94),
		Position = UDim2.new(0, 10, 0, 42),
		BackgroundTransparency = 1,
		BorderSizePixel = 0,
		CanvasSize = UDim2.new(0, 0, 0, 0),
		AutomaticCanvasSize = Enum.AutomaticSize.Y,
		ScrollingDirection = Enum.ScrollingDirection.Y,
		ScrollBarThickness = 3,
		ScrollBarImageColor3 = theme.Border,
		ZIndex = 401,
	}, { arg.new("UIListLayout", { Padding = UDim.new(0, 5), SortOrder = Enum.SortOrder.LayoutOrder }) })

	local new2 = arg.new

	local tbl4 = {
		Parent = Frame,
		Name = "Input",
		Size = UDim2.new(1, -86, 0, 30),
		Position = UDim2.new(0, 10, 1, -40),
		BackgroundColor3 = theme.Card,
		BorderSizePixel = 0,
		ClearTextOnFocus = false,
		Font = arg.FONT,
		TextSize = 12,
		TextColor3 = theme.Text,
		PlaceholderText = "Type a message...",
		PlaceholderColor3 = theme.TextSecondary,
		Text = "",
		TextXAlignment = Enum.TextXAlignment.Left,
		ZIndex = 401,
	}

	local tbl5 = {}
	local v5 = arg.corner(8)
	local v6 = arg.stroke(theme.Border, 1)
	local new3 = arg.new
	tbl5[1] = v5
	tbl5[2] = v6

	do
		local values = table.pack(new3("UIPadding", { PaddingLeft = UDim.new(0, 8) }))
		table.move(values, 1, values.n, 3, tbl5)
	end

	local TextBox = new2("TextBox", tbl4, tbl5)
	local accent = theme.Accent or Color3.new(0.27450981736183167, 0.43137255311012268, 1)
	local new4 = arg.new

	local tbl6 = {
		Parent = Frame,
		Name = "Send",
		Size = UDim2.new(0, 66, 0, 30),
		Position = UDim2.new(1, -76, 1, -40),
		BackgroundColor3 = accent,
		AutoButtonColor = false,
		Font = arg.FONT_BOLD,
		TextSize = 12,
		TextColor3 = if accent.R * 0.299 + accent.G * 0.587 + accent.B * 0.114 > 0.6 then Color3.new(0.078431375324726105, 0.078431375324726105, 0.094117648899555206) else Color3.new(1, 1, 1),
	}

	tbl6.Text = "Send"
	tbl6.ZIndex = 401
	local TextButton = new4("TextButton", tbl6, { arg.corner(8) })

	local function fn26(arg2, arg3)
		tbl.CFG.Set(arg2, ("%g,%g,%g,%g"):format(arg3.X.Scale, arg3.X.Offset, arg3.Y.Scale, arg3.Y.Offset))
	end

	local function fn27(arg2, arg3)
		local absolutePosition = screenGui.AbsolutePosition
		local absoluteSize = screenGui.AbsoluteSize
		local absoluteSize2 = arg2.AbsoluteSize
		local anchorPoint = arg2.AnchorPoint
		if absoluteSize.X < 1 then
			return arg3
		end

		if not (absoluteSize2.X < 1) then
			local n3 = absolutePosition.X + arg3.X.Scale * absoluteSize.X + arg3.X.Offset - anchorPoint.X * absoluteSize2.X
			local n4 = absolutePosition.Y + arg3.Y.Scale * absoluteSize.Y + arg3.Y.Offset - anchorPoint.Y * absoluteSize2.Y
			return UDim2.new(arg3.X.Scale, arg3.X.Offset + math.clamp(n3, absolutePosition.X, absolutePosition.X + absoluteSize.X - math.min(absoluteSize2.X, 120)) - n3, arg3.Y.Scale, arg3.Y.Offset + math.clamp(n4, absolutePosition.Y, absolutePosition.Y + absoluteSize.Y - 40) - n4)
		end

		return arg3
	end

	local function fn28(arg2, arg3)
		local match, v7, v8, v9 = tostring(tbl.CFG.Get(arg2, "") or ""):match("^(-?[%d%.e+-]+),(-?[%d%.e+-]+),(-?[%d%.e+-]+),(-?[%d%.e+-]+)$")

		if match then
			arg3.Position = UDim2.new(tonumber(match) or 0, tonumber(v7) or 0, tonumber(v8) or 0, tonumber(v9) or 0)
			arg3.Position = fn27(arg3, arg3.Position)
			return
		end
	end

	local function fn29(arg2, arg3, arg4)
		local flag2 = false
		local v7 = nil
		local trove = tbl.ST.Trove
		local v8 = trove
		local connect = trove.Connect
		local v9

		local function fn30(arg5)
			if arg5.UserInputType ~= Enum.UserInputType.MouseButton1 and arg5.UserInputType ~= Enum.UserInputType.Touch then
				return
			end
			local position = arg5.Position
			local position2 = arg3.Position
			flag2 = true
			v7 = position
			v9 = position2
		end

		connect(v8, arg2.InputBegan, fn30)

		local function fn31(arg5)
			if flag2 then
				local userInputType = arg5.UserInputType
				local userInputType2 = Enum.UserInputType
				if userInputType ~= userInputType2.MouseButton1 and arg5.UserInputType ~= Enum.UserInputType.Touch then
					return
				end
				flag2 = false
				fn26(arg4, arg3.Position)
				return
			end
		end

		tbl.ST.Trove:Connect(arg2.InputEnded, fn31)
		tbl.ST.Trove:Connect(tbl.SV.UserInputService.InputEnded, fn31)
		local trove2 = tbl.ST.Trove
		local v10 = trove2
		local connect2 = trove2.Connect

		local function fn32(arg5)
			if flag2 then
				if v7 then
					if arg5.UserInputType ~= Enum.UserInputType.MouseMovement and arg5.UserInputType ~= Enum.UserInputType.Touch then
						return
					end
					local n3 = arg5.Position - v7
					arg3.Position = fn27(arg3, UDim2.new(v9.X.Scale, v9.X.Offset + n3.X, v9.Y.Scale, v9.Y.Offset + n3.Y))
					return
				end

				return
			end
		end

		connect2(v10, tbl.SV.UserInputService.InputChanged, fn32)
	end

	local new5 = arg.new
	local tbl7 = { Parent = Frame }
	tbl7.Name = "DragHandle"
	tbl7.Size = UDim2.new(1, 0, 0, 40)
	tbl7.Position = UDim2.new(0, 0, 0, 0)
	tbl7.BackgroundTransparency = 1
	tbl7.Active = true
	tbl7.ZIndex = 400
	fn29(new5("Frame", tbl7), Frame, "UI.ChatWinPos")
	fn28("UI.ChatWinPos", Frame)
	local userInputService = tbl.SV.UserInputService
	local n3 = 260
	local n4 = 240

	if not userInputService.TouchEnabled or userInputService.KeyboardEnabled then
		local n5 = tonumber(tbl.CFG.Get("UI.ChatW", 0)) or 0
		local num = tonumber(tbl.CFG.Get("UI.ChatH", 0))

		if num and n3 <= n5 and n4 <= num then
			Frame.Size = UDim2.fromOffset(math.min(n5, 560), math.min(num, 760))
		end

		local v7 = nil
		local vector2 = nil
		local absoluteSize = nil
		local vector22 = nil

		local function fn30(arg2, arg3)
			local viewportSize = workspace.CurrentCamera.ViewportSize
			local n6 = math.clamp(absoluteSize.X + arg2, 260, math.min(560, math.max(260, viewportSize.X - 40)))
			local n7 = math.clamp(absoluteSize.Y + arg3, 240, math.min(760, math.max(240, viewportSize.Y - 40)))
			Frame.Size = UDim2.fromOffset(n6, n7)
			Frame.Position = UDim2.fromOffset(vector22.X + (n6 - absoluteSize.X) / 2, vector22.Y + (n7 - absoluteSize.Y) / 2)
			return n6, n7
		end

		tbl.ST.Trove:Connect(arg.new("TextButton", {
			Parent = Frame,
			Name = "Resize",
			Size = UDim2.new(0, 16, 0, 16),
			Position = UDim2.new(1, -4, 1, -4),
			AnchorPoint = Vector2.new(1, 1),
			BackgroundTransparency = 1,
			AutoButtonColor = false,
			Font = arg.FONT_BOLD,
			TextSize = 14,
			TextColor3 = theme.TextSecondary,
			Text = "◢",
			ZIndex = 403,
		}).InputBegan, function(arg2)
			if arg2.UserInputType ~= Enum.UserInputType.MouseButton1 then
				return
			end
			v7 = arg2
			vector2 = Vector2.new(arg2.Position.X, arg2.Position.Y)
			absoluteSize = Frame.AbsoluteSize
			local absolutePosition = Frame.AbsolutePosition
			local absolutePosition2 = screenGui.AbsolutePosition
			vector22 = Vector2.new(absolutePosition.X - absolutePosition2.X + absoluteSize.X / 2, absolutePosition.Y - absolutePosition2.Y + absoluteSize.Y / 2)
		end)

		local trove = tbl.ST.Trove
		local v8 = trove
		local connect = trove.Connect

		local function fn31(arg2)
			if v7 then
				if arg2.UserInputType ~= Enum.UserInputType.MouseMovement then
					return
				end
				fn30(arg2.Position.X - vector2.X, arg2.Position.Y - vector2.Y)
				return
			end
		end

		connect(v8, userInputService.InputChanged, fn31)

		tbl.ST.Trove:Connect(userInputService.InputEnded, function(arg2)
			if v7 then
				if arg2.UserInputType ~= Enum.UserInputType.MouseButton1 then
					return
				end
				v7 = nil
				tbl.CFG.Set("UI.ChatW", math.floor(Frame.AbsoluteSize.X))
				tbl.CFG.Set("UI.ChatH", math.floor(Frame.AbsoluteSize.Y))
				return
			end
		end)
	end

	local tbl8 = {}

	local function fn30()
		local room = tbl.STEAL.CHAT.Room

		for k, v7 in pairs(tbl8) do
			local flag2 = k == room
			v7.TextColor3 = flag2 and theme.Text or theme.TextSecondary
			v7.BackgroundColor3 = flag2 and theme.CardHover or theme.Card
			v7.BackgroundTransparency = flag2 and 0 or 0.55
		end
	end

	for i, v7 in ipairs({ { "ID", "GLOBAL" }, { "EN", "GLOBAL_EN" } }) do
		local TextButton2 = arg.new("TextButton", {
			Parent = Frame,
			Name = "Tab" .. v7[1],
			Size = UDim2.new(0, 34, 0, 20),
			Position = UDim2.new(0, 118 + (i - 1) * 38, 0, 13),
			BackgroundColor3 = theme.Card,
			AutoButtonColor = false,
			Font = arg.FONT_BOLD,
			TextSize = 11,
			TextColor3 = theme.TextSecondary,
			Text = v7[1],
			ZIndex = 402,
		}, { arg.corner(6) })

		tbl8[v7[2]] = TextButton2

		TextButton2.MouseButton1Click:Connect(function()
			tbl.STEAL.CHAT.Open(v7[2])
			fn30()
			if uix.CHAT_Gambar then
				uix.CHAT_Gambar()
				return
			end
		end)
	end

	fn30()

	local Frame2 = arg.new("Frame", {
		Parent = Frame,
		Name = "StaffBar",
		Size = UDim2.new(1, -20, 0, 26),
		Position = UDim2.new(0, 10, 1, -74),
		BackgroundTransparency = 1,
		Visible = false,
		ZIndex = 401,
	})

	local flag2 = false
	local new6 = arg.new

	local tbl9 = {
		Parent = Frame2,
		Name = "Broadcast",
		Size = UDim2.new(0, 74, 1, 0),
		BackgroundColor3 = theme.Card,
		BackgroundTransparency = 0.4,
		AutoButtonColor = false,
		Font = arg.FONT_BOLD,
		TextSize = 11,
		TextColor3 = theme.TextSecondary,
		Text = "Normal",
		ZIndex = 402,
	}

	local tbl10 = {}
	local v7 = arg.corner(6)
	local stroke2 = arg.stroke
	local border2 = theme.Border
	tbl10[1] = v7

	do
		local values = table.pack(stroke2(border2, 1, 0.5))
		table.move(values, 1, values.n, 2, tbl10)
	end

	local TextButton2 = new6("TextButton", tbl9, tbl10)

	local function fn31()
		TextButton2.Text = flag2 and "ALERT" or "Normal"
		TextButton2.BackgroundColor3 = if flag2 then Color3.new(0.70588237047195435, 0.18823529779911041, 0.16470588743686676) else theme.Card
		TextButton2.TextColor3 = if flag2 then Color3.new(1, 0.92156863212585449, 0.92156863212585449) else theme.TextSecondary
		TextBox.PlaceholderText = flag2 and "Urgent announcement to ALL rooms..." or "Type a message..."
	end

	TextButton2.MouseButton1Click:Connect(function()
		flag2 = not flag2
		fn31()
	end)

	local flag3 = false

	local function fn32()
		if flag3 then
			return
		end
		flag3 = true

		task.delay(0.35, function()
			flag3 = false
			if Frame.Visible and uix.CHAT_Gambar then
				uix.CHAT_Gambar()
				return
			end
		end)
	end

	local new7 = arg.new

	local tbl11 = {
		Parent = Frame,
		Name = "ModPanel",
		Size = UDim2.new(1, -24, 0, 150),
		Position = UDim2.new(0, 12, 0, 40),
		BackgroundColor3 = theme.Card,
		Visible = false,
		ZIndex = 470,
	}

	local tbl12 = {}
	local v8 = arg.corner(10)
	local stroke3 = arg.stroke
	local border3 = theme.Border
	tbl12[1] = v8

	do
		local values = table.pack(stroke3(border3, 1))
		table.move(values, 1, values.n, 2, tbl12)
	end

	local Frame3 = new7("Frame", tbl11, tbl12)

	local TextLabel = arg.new("TextLabel", {
		Parent = Frame3,
		Name = "Title",
		BackgroundTransparency = 1,
		Size = UDim2.new(1, -60, 0, 18),
		Position = UDim2.new(0, 12, 0, 8),
		Font = arg.FONT_BOLD,
		TextSize = 12,
		TextColor3 = theme.Text,
		TextXAlignment = Enum.TextXAlignment.Left,
		Text = "",
		ZIndex = 471,
	})

	local TextLabel2 = arg.new("TextLabel", {
		Parent = Frame3,
		Name = "Info",
		BackgroundTransparency = 1,
		Size = UDim2.new(1, -24, 0, 14),
		Position = UDim2.new(0, 12, 0, 26),
		Font = arg.FONT,
		TextSize = 10,
		TextColor3 = theme.TextSecondary,
		TextXAlignment = Enum.TextXAlignment.Left,
		TextTruncate = Enum.TextTruncate.AtEnd,
		Text = "",
		ZIndex = 471,
	})

	local TextButton3 = arg.new("TextButton", {
		Parent = Frame3,
		Name = "Close",
		Size = UDim2.new(0, 22, 0, 22),
		Position = UDim2.new(1, -30, 0, 6),
		BackgroundTransparency = 1,
		AutoButtonColor = false,
		Font = arg.FONT_BOLD,
		TextSize = 14,
		TextColor3 = theme.TextSecondary,
		Text = "×",
		ZIndex = 471,
	})

	local Frame4 = arg.new("Frame", {
		Parent = Frame3,
		Name = "Body",
		Size = UDim2.new(1, -24, 1, -56),
		Position = UDim2.new(0, 12, 0, 46),
		BackgroundTransparency = 1,
		ZIndex = 471,
	})

	local function fn33()
		Frame3.Visible = false
	end

	TextButton3.MouseButton1Click:Connect(fn33)

	local function fn34(text, arg2, textColor3, arg3)
		for _, child in ipairs(Frame4:GetChildren()) do
			if child:IsA("GuiObject") then
				child:Destroy()
			end
		end

		TextLabel.Text = text
		TextLabel.TextColor3 = textColor3
		TextLabel2.Text = "Player: " .. tostring(arg3)
		Frame3.Size = UDim2.new(1, -24, 0, arg2)
		Frame3.Visible = true
		return Frame4
	end

	local function fn35(arg2, arg3)
		local new8 = arg.new

		local tbl13 = {
			Parent = arg2,
			Size = arg3.size,
			Position = arg3.pos,
			BackgroundColor3 = arg3.bg or theme.CardHover,
			AutoButtonColor = false,
			Font = arg.FONT_BOLD,
			TextSize = arg3.kecil and 10 or 11,
			TextColor3 = arg3.warna or theme.Text,
			Text = arg3.teks,
			ZIndex = 472,
		}

		local tbl14 = {}
		local v9 = arg.corner(6)
		local tepi = arg3.tepi and arg.stroke(arg3.tepi, 1, 0.2) or nil
		tbl14[1] = v9
		tbl14[2] = tepi
		local TextButton4 = new8("TextButton", tbl13, tbl14)
		local mouseButton1Click = TextButton4.MouseButton1Click
		local v10 = mouseButton1Click
		local connect = mouseButton1Click.Connect

		local function fn36()
			pcall(arg3.fn)
			fn33()
		end

		connect(v10, fn36)
		return TextButton4
	end

	local function fn36(arg2, arg3)
		local durasi = tbl.STEAL.MOD.DURASI or { 5, 10, 15, 30, 60, 120 }
		local v9 = math.ceil(#durasi / 3)
		local muteUser = fn34("Mute User", 76 + v9 * 30 + 34, Color3.new(0.86274510622024536, 0.27450981736183167, 0.27450981736183167), tbl.STEAL.FUSE.Censor(arg2))

		for i, v10 in ipairs(durasi) do
			local tbl13 = {
				size = UDim2.new(0.3333333432674408, -6, 0, 26),
				pos = UDim2.new((i - 1) % 3 / 3, 3, 0, math.floor((i - 1) / 3) * 30),
				bg = if v10 == 15 then Color3.new(0.58823531866073608, 0.17647059261798859, 0.17647059261798859) else theme.CardHover,
				teks = v10 .. "m",
			}

			local function fn37()
				tbl.STEAL.MOD.KirimBisu(arg2, arg3, v10)
			end

			tbl13.fn = fn37
			fn35(muteUser, tbl13)
		end

		local new8 = arg.new

		local tbl13 = {
			Parent = tengah,
			Name = "Custom",
			Size = UDim2.new(1, -76, 0, 26),
			Position = UDim2.new(0, 3, 0, v9 * 30 + 6),
			BackgroundColor3 = theme.CardHover,
			BorderSizePixel = 0,
			ClearTextOnFocus = false,
			Font = arg.FONT,
			TextSize = 11,
			TextColor3 = theme.Text,
			PlaceholderText = "Other, e.g. 45",
			PlaceholderColor3 = theme.TextSecondary,
			Text = "",
			TextXAlignment = Enum.TextXAlignment.Left,
			ZIndex = 472,
		}

		local tbl14 = {}
		local v10 = arg.corner(6)
		local new9 = arg.new
		tbl14[1] = v10

		do
			local values = table.pack(new9("UIPadding", { PaddingLeft = UDim.new(0, 7) }))
			table.move(values, 1, values.n, 2, tbl14)
		end

		local TextBox2 = new8("TextBox", tbl13, tbl14)

		local function fn37()
			local num = tonumber(TextBox2.Text)
			if num and not (num <= 0) then
				tbl.STEAL.MOD.KirimBisu(arg2, arg3, num)
				return
			end
			uix.Pita("Minutes must be a number above 0", 3)
		end

		fn35(muteUser, {
			size = UDim2.new(0, 66, 0, 26),
			pos = UDim2.new(1, -69, 0, v9 * 30 + 6),
			bg = Color3.new(0.58823531866073608, 0.17647059261798859, 0.17647059261798859),
			teks = "Mute",
			fn = fn37,
		})
	end

	local function fn37(arg2, arg3)
		local prankUrut = tbl.STEAL.MOD.PRANK_URUT or {}
		local fakeEggSpawnPrank = fn34("Fake Egg Spawn Prank", 56 + #prankUrut * 40 + 8, Color3.new(0.64705884456634521, 0.47058823704719543, 0.88235294818878174), tbl.STEAL.FUSE.Censor(arg2))

		for i, v9 in ipairs(prankUrut) do
			local v10 = tbl.STEAL.MOD.PRANK[v9.kode]

			local tbl13 = {
				size = UDim2.new(1, 0, 0, 34),
				pos = UDim2.new(0, 0, 0, (i - 1) * 40),
				bg = theme.CardHover,
				tepi = v10 and v10.warna or nil,
				warna = v10 and v10.warna or theme.Text,
				teks = v9.nama .. "   ·   " .. v9.zona,
				kecil = true,
			}

			local function fn38()
				tbl.STEAL.MOD.KirimPrank(v9.kode, arg2, arg3)
			end

			tbl13.fn = fn38
			fn35(fakeEggSpawnPrank, tbl13)
		end
	end

	local function fn38()
		local ok, result = pcall(tbl.STEAL.MOD.Staf)

		if not ok then
			result = nil
		end

		TextButton2.Visible = result == "owner"

		if not TextButton2.Visible and flag2 then
			flag2 = false
			fn31()
		end

		Frame2.Visible = result and true or false
		ScrollingFrame.Size = if Frame2.Visible then UDim2.new(1, -20, 1, -124) else UDim2.new(1, -20, 1, -94)
	end

	tbl.ST.Trove:Connect(Frame:GetPropertyChangedSignal("Visible"), function()
		if Frame.Visible then
			fn30()
			fn38()
			return
		end
	end)

	fn38()
	local new8 = arg.new

	local tbl13 = {
		Parent = screenGui,
		Name = "ChatLauncher",
		Size = UDim2.new(0, 118, 0, 32),
		Position = UDim2.new(0.5, 0, 1, -70),
		AnchorPoint = Vector2.new(0.5, 0.5),
		BackgroundColor3 = theme.Card,
		AutoButtonColor = false,
		Font = arg.FONT,
		TextSize = 12,
		TextColor3 = theme.Text,
		Text = "Let's Chat!",
		Active = true,
		ZIndex = 399,
	}

	local tbl14 = {}
	local v9 = arg.corner(16)
	local stroke4 = arg.stroke
	local border4 = theme.Border
	tbl14[1] = v9

	do
		local values = table.pack(stroke4(border4, 1))
		table.move(values, 1, values.n, 2, tbl14)
	end

	local TextButton4 = new8("TextButton", tbl13, tbl14)
	uix.ChatPill = TextButton4

	local TextLabel3 = arg.new("TextLabel", {
		Parent = TextButton4,
		Name = "Unread",
		Size = UDim2.new(0, 18, 0, 18),
		Position = UDim2.new(1, -6, 0, -4),
		AnchorPoint = Vector2.new(0.5, 0.5),
		BackgroundColor3 = Color3.new(0.86274510622024536, 0.27450981736183167, 0.27450981736183167),
		Visible = false,
		Font = arg.FONT_BOLD,
		TextSize = 11,
		TextColor3 = Color3.new(1, 1, 1),
		Text = "",
		ZIndex = 400,
	}, { arg.corner(9) })

	local n5 = 0
	local visible = tbl.CFG.Get("Flags.ChatOn", false) == true

	local function fn39()
		TextLabel3.Visible = visible and n5 > 0 and not Frame.Visible
		TextLabel3.Text = n5 > 99 and "99+" or tostring(n5)
	end

	local function chatGambar()
		for _, child in ipairs(ScrollingFrame:GetChildren()) do
			if child:IsA("GuiObject") then
				child:Destroy()
			end
		end

		local tbl15 = tbl.STEAL.CHAT.Msgs[tbl.STEAL.CHAT.Room] or {}

		for i = math.max(1, #tbl15 - 40), #tbl15 do
			local v10 = tbl15[i]
			local new9 = arg.new

			local tbl16 = {
				Parent = ScrollingFrame,
				LayoutOrder = i,
				Size = UDim2.new(1, -4, 0, 0),
				AutomaticSize = Enum.AutomaticSize.Y,
				BackgroundColor3 = theme.Card,
				ZIndex = 402,
			}

			local tbl17 = {}
			local v11 = arg.corner(8)

			local UIPadding = arg.new("UIPadding", {
				PaddingTop = UDim.new(0, 5),
				PaddingBottom = UDim.new(0, 5),
				PaddingLeft = UDim.new(0, 8),
				PaddingRight = UDim.new(0, 8),
			})

			local new10 = arg.new
			local tbl18 = { Padding = UDim.new(0, 2), SortOrder = Enum.SortOrder.LayoutOrder }
			tbl17[1] = v11
			tbl17[2] = UIPadding

			do
				local values = table.pack(new10("UIListLayout", tbl18))
				table.move(values, 1, values.n, 3, tbl17)
			end

			local Frame5 = new9("Frame", tbl16, tbl17)

			if v10.sistem then
				arg.new("TextLabel", {
					Parent = Frame5,
					LayoutOrder = 1,
					Size = UDim2.new(1, 0, 0, 0),
					AutomaticSize = Enum.AutomaticSize.Y,
					BackgroundTransparency = 1,
					Font = arg.FONT,
					TextSize = 11,
					TextColor3 = theme.TextSecondary,
					TextWrapped = true,
					TextXAlignment = Enum.TextXAlignment.Left,
					ZIndex = 403,
					Text = tostring(v10.teks or ""),
				})
			else
				local v12 = tbl.STEAL.CHAT.Staf(v10.from)
				local flag4 = v10.from == tbl.PLR.Name
				local text = tbl.STEAL.CHAT.NamaTampil(v10.from, v10.fn or tbl.STEAL.FUSE.Censor(v10.from))

				if v12 ~= "owner" then
					if v12 == "mod" then
						text = "🛡 [Mod] " .. text
					end
				else
					text = "👑 " .. text
				end

				if v10.siar then
					text = "[BROADCAST] " .. text
				end

				local v13 = nil
				local v14 = tbl.STEAL.MOD.Staf()

				if v14 then
					v13 = tbl.STEAL.CHAT.Uid(v10.from, fn32)

					if v12 ~= "owner" then
						text ..= "  (" .. (if v13 and v13 > 0 then tostring(v13) else "...") .. ")"
					end
				end

				local color

				if v10.siar then
					color = Color3.new(0.22745098173618317, 0.086274512112140656, 0.078431375324726105)
				else
					color = v12 == "owner" and Color3.new(0.18039216101169586, 0.14901961386203766, 0.062745101749897)
				end

				Frame5.BackgroundColor3 = color or v12 == "mod" and Color3.new(0.062745101749897, 0.12549020349979401, 0.18039216101169586) or theme.Card

				if v10.siar then
					arg.new("UIStroke", {
						Parent = Frame5,
						Thickness = 1.2,
						Transparency = 0.1,
						Color = Color3.new(1, 0.27058824896812439, 0.22745098173618317),
					})
				elseif v12 then
					arg.new("UIStroke", {
						Parent = Frame5,
						Thickness = 1,
						Transparency = 0.2,
						Color = if v12 == "owner" then Color3.new(0.87843137979507446, 0.70196080207824707, 0.25490197539329529) else Color3.new(0.31372550129890442, 0.7450980544090271, 1),
					})
				end

				local new11 = arg.new

				local tbl19 = {
					Parent = Frame5,
					LayoutOrder = 1,
					Size = UDim2.new(1, 0, 0, 14),
					BackgroundTransparency = 1,
					Font = arg.FONT_BOLD,
					TextSize = 11,
				}

				local color2

				if v10.siar then
					color2 = Color3.new(1, 0.47058823704719543, 0.4117647111415863)
				else
					color2 = v12 == "owner" and Color3.new(0.87843137979507446, 0.70196080207824707, 0.25490197539329529)
				end

				tbl19.TextColor3 = color2 or v12 == "mod" and Color3.new(0.31372550129890442, 0.7450980544090271, 1) or flag4 and theme.Accent or theme.TextSecondary
				tbl19.TextXAlignment = Enum.TextXAlignment.Left
				tbl19.ZIndex = 403
				tbl19.Text = text
				new11("TextLabel", tbl19)

				arg.new("TextLabel", {
					Parent = Frame5,
					LayoutOrder = 2,
					Size = UDim2.new(1, 0, 0, 0),
					AutomaticSize = Enum.AutomaticSize.Y,
					BackgroundTransparency = 1,
					Font = arg.FONT,
					TextSize = 12,
					TextColor3 = v10.dibisu and theme.TextSecondary or theme.Text,
					TextWrapped = true,
					TextXAlignment = Enum.TextXAlignment.Left,
					ZIndex = 403,
					Text = if v10.dibisu then "[muted] " .. tostring(v10.teks or "") else tostring(v10.teks or ""),
				})

				if v14 and not (flag4 or v12) then
					local Frame6 = arg.new("Frame", {
						Parent = Frame5,
						Name = "Actions",
						LayoutOrder = 3,
						Size = UDim2.new(1, 0, 0, 18),
						BackgroundTransparency = 1,
						ZIndex = 403,
					}, {
						arg.new("UIListLayout", {
							Padding = UDim.new(0, 6),
							FillDirection = Enum.FillDirection.Horizontal,
							SortOrder = Enum.SortOrder.LayoutOrder,
						}),
					})

					local function fn40(arg2, arg3, arg4, arg5)
						local TextButton5 = arg.new("TextButton", {
							Parent = Frame6,
							Size = UDim2.new(0, 50, 1, 0),
							BackgroundColor3 = arg3,
							AutoButtonColor = false,
							Font = arg.FONT_BOLD,
							TextSize = 10,
							TextColor3 = theme.Text,
							Text = arg2,
							LayoutOrder = arg4,
							ZIndex = 404,
						}, { arg.corner(5) })

						TextButton5.MouseButton1Click:Connect(arg5)
						return TextButton5
					end

					if v10.dibisu then
						local function fn41()
							tbl.STEAL.MOD.KirimBuka(v10.from, v13)
						end

						fn40("Unmute", Color3.new(0.15686275064945221, 0.27450981736183167, 0.17647059261798859), 0, fn41)
					end

					local function fn41()
						fn36(v10.from, v13)
					end

					fn40("Mute", Color3.new(0.31372550129890442, 0.15686275064945221, 0.15686275064945221), 2, fn41)

					local function fn42()
						fn37(v10.from, v13)
					end

					fn40("Prank", Color3.new(0.18823529779911041, 0.098039217293262482, 0.23529411852359772), 3, fn42)
				end
			end
		end

		ScrollingFrame.CanvasPosition = Vector2.new(0, 1000000)
	end

	uix.CHAT_Gambar = chatGambar

	uix.CHAT_Baru = function(arg2)
		if Frame.Visible then
			chatGambar()
		else
			n5 += arg2 or 1
		end

		fn39()
	end

	tbl.STEAL.CHAT.OnNew = uix.CHAT_Baru

	local function chatBuka(arg2)
		if visible then
			if arg2 then
				tbl.STEAL.CHAT.Open(arg2)
			end

			Frame.Visible = true
			n5 = 0
			fn39()
			chatGambar()
			tbl.STEAL.CHAT.Start()
			return
		end
	end

	uix.CHAT_Buka = chatBuka

	local function fn40()
		Frame.Visible = false
		fn39()
	end

	fn25("–", -66, fn40)
	fn25("×", -34, fn40)
	local new9 = arg.new

	local tbl15 = {
		Parent = screenGui,
		Name = "ChatSwitch",
		Size = UDim2.new(0, 118, 0, 22),
		Position = UDim2.new(0.5, 0, 1, -100),
		AnchorPoint = Vector2.new(0.5, 0.5),
		BackgroundColor3 = theme.Card,
		AutoButtonColor = false,
		Font = arg.FONT,
		TextSize = 11,
		Text = "",
		Active = true,
		ZIndex = 399,
	}

	local tbl16 = {}
	local v10 = arg.corner(11)
	local stroke5 = arg.stroke
	local border5 = theme.Border
	tbl16[1] = v10

	do
		local values = table.pack(stroke5(border5, 1))
		table.move(values, 1, values.n, 2, tbl16)
	end

	local TextButton5 = new9("TextButton", tbl15, tbl16)

	local function fn41()
		TextButton5.Text = visible and "Chat: ON" or "Chat: OFF"
		local v11 = TextButton5
		local online

		if visible then
			online = theme.Online or Color3.new(0.31372550129890442, 0.78431373834609985, 0.47058823704719543)
		else
			online = theme.TextSecondary
		end

		v11.TextColor3 = online
		TextButton4.Visible = visible

		if not visible then
			Frame.Visible = false
		end

		fn39()
	end

	local function fn42()
		TextButton5.Position = TextButton4.Position + UDim2.new(0, 0, 0, -30)
	end

	fn42()
	tbl.ST.Trove:Connect(TextButton4:GetPropertyChangedSignal("Position"), fn42)

	tbl.ST.Trove:Connect(TextButton5.MouseButton1Click, function()
		visible = not visible
		tbl.CFG.Set("Flags.ChatOn", visible)
		fn41()
		tbl.STEAL.CHAT.Start()
	end)

	local absolutePosition = nil

	tbl.ST.Trove:Connect(TextButton4.InputBegan, function(arg2)
		if arg2.UserInputType ~= Enum.UserInputType.MouseButton1 then
			if arg2.UserInputType ~= Enum.UserInputType.Touch then
				return
			end
			absolutePosition = TextButton4.AbsolutePosition
			return
		end

		absolutePosition = TextButton4.AbsolutePosition
	end)

	fn29(TextButton4, TextButton4, "UI.ChatPillPos")
	fn28("UI.ChatPillPos", TextButton4)
	fn42()

	tbl.ST.Trove:Connect(TextButton4.MouseButton1Click, function()
		if absolutePosition then
			local magnitude = (TextButton4.AbsolutePosition - absolutePosition).Magnitude
			absolutePosition = nil
			if magnitude > 3 then
				return
			end
		end

		if Frame.Visible then
			fn40()
			return
		end
		chatBuka(tbl.STEAL.CHAT.Room)
	end)

	local function fn43()
		if tbl.STEAL.CHAT.Send(TextBox.Text, nil, flag2) then
			TextBox.Text = ""

			if flag2 then
				flag2 = false
				fn31()
				return
			end

			return
		end
	end

	tbl.ST.Trove:Connect(TextButton.MouseButton1Click, fn43)

	tbl.ST.Trove:Connect(TextBox.FocusLost, function(arg2)
		if arg2 then
			fn43()
			return
		end
	end)

	fn41()
	tbl.STEAL.CHAT.Start()
end

local flag2 = false

pcall(function()
	flag2 = isfile(tbl.FS.Root .. "/noui.flag") == true
end)

if not flag2 then
	if tbl.UIX.Gate() then
		tbl.UIX.Mount()
	end
else
	tbl.LOG.info("boot", "noui.flag present -- core only, UI not mounted")
end

return tbl
