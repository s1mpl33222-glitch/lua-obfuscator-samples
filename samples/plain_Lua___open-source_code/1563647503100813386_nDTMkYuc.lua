if getgenv().sportsclub_street_life_remastered_ac_bypassed then
	return getgenv().sportsclub_street_life_remastered_ac_bypass
end

local game = cloneref(game)
repeat
	task.wait()
until game:IsLoaded()

local Players = cloneref(game:GetService("Players"))
local ReplicatedStorage = cloneref(game:GetService("ReplicatedStorage"))
local RunService = cloneref(game:GetService("RunService"))
local Workspace = cloneref(game:GetService("Workspace"))
local LogService = cloneref(game:GetService("LogService"))
local StarterPlayer = cloneref(game:GetService("StarterPlayer"))
local LocalPlayer = cloneref(Players.LocalPlayer or Players.PlayerAdded:Wait())

local pcall = pcall
local type = type
local typeof = typeof
local tostring = tostring
local string_find = string.find

local wrap = (type(newcclosure) == "function" and newcclosure) or function(f)
	return f
end

local setstackhidden_fn = setstackhidden or setstack_hidden or sethiddenstack
local function hide(fn)
	if type(setstackhidden_fn) == "function" and type(fn) == "function" then
		pcall(setstackhidden_fn, fn, true)
	end
	return fn
end

if type(setstackhidden_fn) == "function" then
	if type(hookfunction) == "function" then
		pcall(setstackhidden_fn, hookfunction, true)
	end
	if type(hookmetamethod) == "function" then
		pcall(setstackhidden_fn, hookmetamethod, true)
	end
end

local Api = {
	ready = false,
	killed = 0,
	keepalive = false,
	token = "123-456-789",
}

getgenv().sportsclub_street_life_remastered_ac_bypass = Api
getgenv().sportsclub_street_life_remastered_ac_bypassed = true

local rt = {
	namecall_hooked = false,
	newindex_hooked = false,
	fps_hooked = false,
	fireserver_hooked = false,
	watch_conn = nil,
}

local function is_weather(inst)
	if typeof(inst) ~= "Instance" then
		return false
	end
	if inst.Name ~= "WeatherSystem" then
		return false
	end
	return inst.ClassName == "LocalScript" or inst.ClassName == "Script" or inst.ClassName == "ModuleScript"
end

local function soft_kill(inst)
	if not is_weather(inst) then
		return false
	end
	pcall(function()
		inst.Disabled = true
	end)
	if type(disablescript) == "function" then
		pcall(disablescript, inst)
	end
	return true
end

local function scan_container(root)
	if typeof(root) ~= "Instance" then
		return 0
	end
	local n = 0
	if soft_kill(root) then
		n = n + 1
	end
	local kids = root:GetDescendants()
	for index = 1, #kids do
		if soft_kill(kids[index]) then
			n = n + 1
		end
	end
	return n
end

local function conn_source(conn)
	local ok, fn = pcall(function()
		return conn.Function
	end)
	if not ok or type(fn) ~= "function" or type(debug.info) ~= "function" then
		return ""
	end
	local ok2, src = pcall(debug.info, fn, "s")
	if not ok2 then
		return ""
	end
	return tostring(src or "")
end

local function disable_weather_connections()
	if type(getconnections) ~= "function" then
		return
	end
	local signals = {
		LogService.MessageOut,
		RunService.Heartbeat,
		RunService.Stepped,
		RunService.RenderStepped,
		Players.PlayerAdded,
		LocalPlayer.CharacterAdded,
	}
	for index = 1, #signals do
		local signal = signals[index]
		if signal ~= nil then
			local ok, list = pcall(getconnections, signal)
			if ok and type(list) == "table" then
				for c = 1, #list do
					local conn = list[c]
					if string_find(conn_source(conn), "WeatherSystem", 1, true) then
						pcall(function()
							if type(conn.Disable) == "function" then
								conn:Disable()
							elseif type(conn.Disconnect) == "function" then
								conn:Disconnect()
							end
						end)
					end
				end
			end
		end
	end
end

local function block_report(a1, a2)
	return a1 == "SaveSettings" and a2 ~= "Update"
end

local function hook_change_setting()
	local remotes = ReplicatedStorage:FindFirstChild("Remotes")
	local remote = remotes and remotes:FindFirstChild("ChangeSetting")
	if typeof(remote) ~= "Instance" then
		return false
	end

	pcall(function()
		remote.OnClientEvent:Connect(function(token)
			if type(token) == "string" and token ~= "" then
				Api.token = token
			end
		end)
	end)

	if type(hookfunction) == "function" and rt.fireserver_hooked ~= true then
		local fire = remote.FireServer
		if type(fire) == "function" then
			rt.fireserver_hooked = true
			local old_fire
			local ok_hook = pcall(function()
				old_fire = hookfunction(fire, hide(wrap(function(self, a1, a2, a3, ...)
					if self == remote and block_report(a1, a2) then
						return
					end
					return old_fire(self, a1, a2, a3, ...)
				end)))
			end)
			if not ok_hook then
				rt.fireserver_hooked = false
			end
		end
	end

	if type(hookmetamethod) == "function" and type(getnamecallmethod) == "function" and rt.namecall_hooked ~= true then
		rt.namecall_hooked = true
		local old
		old = hookmetamethod(game, "__namecall", hide(wrap(function(self, ...)
			local method = getnamecallmethod()
			if method == "FireServer" and typeof(self) == "Instance" and self.Name == "ChangeSetting" then
				local a1, a2 = ...
				if block_report(a1, a2) then
					return
				end
			end
			if method == "FindService" then
				local name = ...
				if name == "EncodingService" or name == "MessagingService" or name == "UGCValidationService" then
					return nil
				end
			end
			if method == "Destroy" and typeof(self) == "Instance" then
				if self.Name == "Map" and self.Parent == Workspace then
					return
				end
			end
			if method == "GetRealPhysicsFPS" then
				local fps = old(self, ...)
				if type(fps) == "number" and fps > 68 then
					return 60
				end
				return fps
			end
			return old(self, ...)
		end)))
	end

	if type(hookmetamethod) == "function" and rt.newindex_hooked ~= true then
		rt.newindex_hooked = true
		local old
		old = hookmetamethod(game, "__newindex", hide(wrap(function(self, key, value)
			if self == LocalPlayer and key == "Parent" and value == nil then
				return
			end
			return old(self, key, value)
		end)))
	end

	if type(hookfunction) == "function" and rt.fps_hooked ~= true then
		local get_fps = Workspace.GetRealPhysicsFPS
		if type(get_fps) == "function" then
			rt.fps_hooked = true
			pcall(function()
				local old_fps
				old_fps = hookfunction(get_fps, hide(wrap(function(self, ...)
					local fps = old_fps(self, ...)
					if type(fps) == "number" and fps > 68 then
						return 60
					end
					return fps
				end)))
			end)
		end
	end

	return true
end

local function start_keepalive()
	if Api.keepalive == true then
		return
	end
	Api.keepalive = true
	task.spawn(function()
		while Api.keepalive == true do
			task.wait(4)
			local remotes = ReplicatedStorage:FindFirstChild("Remotes")
			local remote = remotes and remotes:FindFirstChild("ChangeSetting")
			if typeof(remote) == "Instance" then
				pcall(function()
					remote:FireServer("SaveSettings", "Update", Api.token or "123-456-789")
				end)
			end
		end
	end)
end

local function run()
	hook_change_setting()
	local killed = 0
	local ps = LocalPlayer:FindFirstChild("PlayerScripts")
	killed = killed + scan_container(ps)
	killed = killed + scan_container(StarterPlayer:FindFirstChild("StarterPlayerScripts"))
	if type(getnilinstances) == "function" then
		local ok, nils = pcall(getnilinstances)
		if ok and type(nils) == "table" then
			for index = 1, #nils do
				if soft_kill(nils[index]) then
					killed = killed + 1
				end
			end
		end
	end
	disable_weather_connections()
	start_keepalive()
	if typeof(ps) == "Instance" and rt.watch_conn == nil then
		rt.watch_conn = ps.ChildAdded:Connect(function(child)
			if is_weather(child) then
				task.defer(function()
					soft_kill(child)
					disable_weather_connections()
				end)
			end
		end)
		ps.DescendantAdded:Connect(function(inst)
			if is_weather(inst) then
				task.defer(function()
					soft_kill(inst)
					disable_weather_connections()
				end)
			end
		end)
	end
	Api.killed = killed
	Api.ready = true
	return killed
end

run()
task.defer(function()
	run()
	task.wait(1)
	run()
end)

return Api