if getgenv().sportsclub_ff3_bypass_loaded then
	return
end
getgenv().sportsclub_ff3_bypass_loaded = true

local game = cloneref(game)

repeat task.wait() until game:IsLoaded()

do
	local Players = cloneref(game:GetService("Players"))
	local ReplicatedStorage = cloneref(game:GetService("ReplicatedStorage"))
	local RunService = cloneref(game:GetService("RunService"))
	local LocalPlayer = cloneref(Players.LocalPlayer)
	local find_first_child = game.FindFirstChild
	local wait_for_child = game.WaitForChild
	local setstackhidden_fn = setstackhidden or setstack_hidden or sethiddenstack
	local function hide_stack(fn)
		if type(setstackhidden_fn) == "function" and type(fn) == "function" then
			pcall(setstackhidden_fn, fn, true)
		end
	end
	if type(setstackhidden_fn) == "function" and type(hookfunction) == "function" then
		pcall(setstackhidden_fn, hookfunction, true)
	end
	if type(setstackhidden_fn) == "function" and type(hookmetamethod) == "function" then
		pcall(setstackhidden_fn, hookmetamethod, true)
	end

	local ac = {
		failed = 0,
		success = 0,
		hooked = 0,
		service_rename = true,
		character_sound_event = true,
	}
	local remotes = nil
	local flags_folder = nil
	local is_practice = false
	local client_main = nil

	do
	local remotes_folder = wait_for_child(ReplicatedStorage, "Remotes", 15)
	if not remotes_folder then
		warn("[sportsclub] Remotes folder missing — aborting load")
		getgenv().ff3_bypass_abort = true
		return
	end
	flags_folder = find_first_child(ReplicatedStorage, "Flags")
	if not flags_folder then
		flags_folder = wait_for_child(ReplicatedStorage, "Flags", 2)
	end
	remotes = {
		folder = remotes_folder,
		character_sound_event = find_first_child(remotes_folder, "CharacterSoundEvent"),
		admin_re = find_first_child(remotes_folder, "AdminRE"),
		admin_rf = find_first_child(remotes_folder, "AdminRF"),
		admin_prompt_rf = find_first_child(remotes_folder, "AdminPromptRF"),
		give_me_admin = find_first_child(remotes_folder, "GiveMeAdmin"),
		make_me_global = find_first_child(remotes_folder, "MakeMeGlobal"),
		captain_decision = find_first_child(remotes_folder, "CaptainDecision"),
		local_player_data_store = find_first_child(remotes_folder, "LocalPlayerDataStore"),
		stats_transfer = find_first_child(remotes_folder, "StatsTransfer"),
		empty = find_first_child(remotes_folder, ""),
	}
	is_practice = flags_folder == nil
		or game.PlaceId == 81310542478972
	local player_scripts = find_first_child(LocalPlayer, "PlayerScripts")
		or LocalPlayer:FindFirstChildOfClass("PlayerScripts")
		or LocalPlayer:WaitForChild("PlayerScripts", 5)
	client_main = player_scripts and find_first_child(player_scripts, "ClientMain")
end

do
		if getgenv().ff3_bypass_ready then

	elseif getgenv().bypass_loaded then
		ac.failed = ac.failed + 1
		warn("[sportsclub] ff3 bypass: already loaded elsewhere without ready flag")
	else
	getgenv().bypass_loaded = true

	local players = Players
	local replicated_storage = ReplicatedStorage
	local run_service = RunService
	local script_context = cloneref(game:GetService("ScriptContext"))

	local is_setup = false
	local bypass_ready = false
	local bypass_state = true

	local local_player = LocalPlayer
	local remotes_folder = remotes and remotes.folder
		or replicated_storage:WaitForChild("Remotes")
	local target_remote = remotes and remotes.character_sound_event
		or remotes_folder:WaitForChild("CharacterSoundEvent")

	local shuffle_function
	local handshake_function

	local function fail(message)
		ac.failed = ac.failed + 1
		warn("[sportsclub] ff3 bypass: " .. tostring(message))
	end

	for index, value in next, getgc() do
		if type(value) == "function" and islclosure(value) then
			local ok, err = pcall(function()
				local script_info = getrenv().debug.info(value, "s")
				if not script_info or not string.find(script_info, "PlayerModule") then
					return
				end
				local constants = getconstants(value)
				if table.find(constants, 90001) then
					shuffle_function = value
				end
			end)
			if not ok then
				warn("[-] failed to process gc function:", err)
			end
		end
	end

	if not shuffle_function then
		fail("failed to retrieve shuffle function.")
	else
		for _, value in next, getgc() do
			if type(value) ~= "function" or not islclosure(value) then
				continue
			end
			local ok_src, src = pcall(getrenv().debug.info, value, "s")
			if not ok_src or not src or not string.find(src, "PlayerModule") then
				continue
			end
			local ok_upvs, upvs = pcall(getupvalues, value)
			if not ok_upvs or not upvs then
				continue
			end
			local has_secondary_remote = false
			local has_add_shuffle = false
			for _, uv in next, upvs do
				local ok_t, t = pcall(typeof, uv)
				if not ok_t then
					continue
				end
				if t == "Instance" then
					local ok_cls, cls = pcall(function()
						return uv.ClassName
					end)
					if ok_cls and cls == "RemoteEvent" and uv ~= target_remote then
						has_secondary_remote = true
					end
				elseif t == "function" and islclosure(uv) then
					local ok_c, consts = pcall(getconstants, uv)
					if ok_c and consts and table.find(consts, 90001) then
						has_add_shuffle = true
					end
				end
				if has_secondary_remote and has_add_shuffle then
					break
				end
			end
			if has_secondary_remote and has_add_shuffle then
				handshake_function = value
				break
			end
		end

		if not handshake_function then
			fail("failed to retrieve handshake function via getgc.")
		else
			local content_uri = nil
			do
				local ok_c, consts = pcall(getconstants, handshake_function)
				if ok_c and consts then
					for _, c in next, consts do
						if type(c) == "string" and #c > 5 and string.byte(c, 1) == 240 then
							content_uri = c
							break
						end
					end
				end
			end

			local handshake_upvalues = getupvalues(handshake_function)
			local ac_long_string = nil
			local secondary_shuffle = nil
			local secondary_remote = nil
			local pass_table = nil
			local fail_table_a = nil
			local fail_table_b = nil

			local hs_large = {}
			local hs_small = {}
			local remote_events = {}

			for index, value in next, handshake_upvalues do
				local ok, t = pcall(typeof, value)
				if not ok then
					continue
				end
				if t == "string" then
					if #value > 1000000 and not ac_long_string then
						ac_long_string = value
					end
				elseif t == "Instance" then
					local ok2, cls = pcall(function()
						return value.ClassName
					end)
					if ok2 and cls == "RemoteEvent" and value ~= target_remote then
						table.insert(remote_events, value)
					end
				elseif t == "function" and islclosure(value) then
					if value ~= shuffle_function then
						local ok_c, consts = pcall(getconstants, value)
						if ok_c and consts and table.find(consts, 90001) and not secondary_shuffle then
							secondary_shuffle = value
						end
					end
				elseif t == "table" then
					local ok_mt, mt = pcall(getrawmetatable, value)
					if not ok_mt or type(mt) ~= "table" then
						continue
					end
					local ok_fn, call_fn = pcall(rawget, mt, "__call")
					if not ok_fn or type(call_fn) ~= "function" then
						continue
					end
					local ok_cc, call_consts = pcall(getconstants, call_fn)
					if not ok_cc or not call_consts or not table.find(call_consts, 90001) then
						continue
					end
					local ok_in, inner = pcall(rawget, value, 1)
					if not ok_in or type(inner) ~= "table" then
						continue
					end
					local ok_19, val19 = pcall(rawget, inner, 19)
					if not ok_19 or type(val19) ~= "number" then
						continue
					end
					if val19 >= 1000000 then
						table.insert(hs_large, { index = index, tbl = value })
					else
						table.insert(hs_small, { index = index, tbl = value })
					end
				end
			end

			for index, connection in next, getconnections(script_context.Error) do
				connection:Disable()
			end

			secondary_remote = remote_events[1]
			pass_table = hs_large[1] and hs_large[1].tbl
			fail_table_a = hs_small[1] and hs_small[1].tbl
			fail_table_b = hs_small[2] and hs_small[2].tbl

			if not content_uri then
				fail("failed to retrieve marker string from constants.")
			elseif not secondary_remote then
				fail("failed to retrieve secondary remote.")
			elseif not secondary_shuffle then
				fail("failed to retrieve secondary shuffle (f41/TransformAdd).")
			elseif not pass_table or not fail_table_a or not fail_table_b then
				fail("failed to retrieve HS tables.")
			elseif not ac_long_string then
				fail("failed to retrieve AC pad string.")
			else
				local old_sub = nil
				local sub_hook
				sub_hook = function(...)
					local n = select("#", ...)
					if n < 1 then
						return old_sub(...)
					end
					local arguments = { ... }
					local a2, a3 = arguments[2], arguments[3]
					if type(checkcaller) == "function" and not checkcaller() then
						if typeof(a2) == "number" and a2 == -3 and typeof(a3) == "number" and a3 == -3 then
							return "i"
						end
						if typeof(a2) == "number" and a2 == -1 then
							return " "
						end
					end
					return old_sub(...)
				end
				old_sub = hookfunction(getrenv().string.sub, sub_hook)
				hide_stack(sub_hook)

				local clean_sequences = {
					{ 1750, 1750, 1655, 1761, 1888, 1767 },
					{ 1645, 1765, 1623, 1714, 1881, 1656 },
					{ 1650, 1749, 1853, 1741, 1761, 1856 },
				}

				local primary_shuffle = nil
				local shuffle_hook
				shuffle_hook = function(...)
					local arguments = { ... }
					if typeof(arguments) == "table" and rawlen(arguments) >= 9 then
						local p3 = arguments[3]
						local p4 = arguments[4]
						local p5 = arguments[5]
						local p7 = arguments[7]
						local p8 = arguments[8]
						local p9 = arguments[9]
						if typeof(p3) == "number"
							and typeof(p4) == "number"
							and typeof(p5) == "number"
							and typeof(p7) == "number"
							and typeof(p8) == "number"
							and typeof(p9) == "number"
						then
							for _, seq in next, clean_sequences do
								if p3 == seq[1]
									and p4 == seq[2]
									and p5 == seq[3]
									and p7 == seq[4]
									and p8 == seq[5]
									and p9 == seq[6]
								then
									return primary_shuffle(...)
								end
							end
							return task.wait(9e9)
						end
					end
					return primary_shuffle(...)
				end
				primary_shuffle = hookfunction(shuffle_function, shuffle_hook)
				hide_stack(shuffle_hook)

				local killed = 0
				local dummy_event = Instance.new("BindableEvent").Event

				for index, value in next, getgc() do
					if type(value) == "function" and islclosure(value) then
						local ok, err = pcall(function()
							local script_info = getrenv().debug.info(value, "s")
							if not script_info or not string.find(script_info, "PlayerModule") then
								return
							end
							local upvalues = getupvalues(value)
							if not upvalues then
								return
							end
							for i, upvalue in next, upvalues do
								if typeof(upvalue) == "RBXScriptSignal" then
									local is_run_service_event = upvalue == run_service.Heartbeat
										or upvalue == run_service.RenderStepped
										or upvalue == run_service.Stepped
									if is_run_service_event then
										local setupvalue_fn = debug and debug.setupvalue or setupvalue
										setupvalue_fn(value, i, dummy_event)
										killed = killed + 1
									end
								end
							end
						end)
						if not ok then
							warn("[-] failed to process gc function:", err)
						end
					end
				end

				local pinned_v35 = 0
				for _, value in next, getgc() do
					if type(value) ~= "function" or not islclosure(value) then
						continue
					end
					local ok_src, src = pcall(getrenv().debug.info, value, "s")
					if not ok_src or not src or not string.find(src, "PlayerModule") then
						continue
					end
					local ok_upvs, upvs = pcall(getupvalues, value)
					if not ok_upvs or not upvs then
						continue
					end
					for i, uv in next, upvs do
						if typeof(uv) == "boolean" and uv == false then
							local has_remote_in_closure = false
							for _, uv2 in next, upvs do
								local ok2, t2 = pcall(typeof, uv2)
								if ok2 and t2 == "Instance" then
									local ok3, cls = pcall(function()
										return uv2.ClassName
									end)
									if ok3 and (cls == "RemoteEvent" or cls == "RemoteFunction") then
										has_remote_in_closure = true
										break
									end
								end
							end
							if has_remote_in_closure then
								pcall(function()
									local setup = debug and debug.setupvalue or setupvalue
									setup(value, i, true)
									pinned_v35 = pinned_v35 + 1
								end)
							end
						end
					end
				end

				local function fire_handshake()
					task.wait()

					shuffle_function(ac_long_string, pass_table, 1750, 1750, 1655, ac_long_string, 1761, 1888, 1767)
					shuffle_function(ac_long_string, pass_table, 1645, 1765, 1623, ac_long_string, 1714, 1881, 1656)

					secondary_remote.Name = target_remote.Name
					secondary_remote:fireServer(
						content_uri,
						secondary_shuffle(ac_long_string, bypass_state and fail_table_a or fail_table_b, 1767, 1676, 1854, ac_long_string, 1689, 1775, 1776),
						nil
					)

					target_remote:fireServer(
						content_uri,
						shuffle_function(ac_long_string, bypass_state and pass_table or fail_table_a, 1750, 1750, 1655, ac_long_string, 1761, 1888, 1767),
						nil
					)

					shuffle_function(ac_long_string, pass_table, 1650, 1749, 1853, ac_long_string, 1741, 1761, 1856)

					secondary_remote.Name = ""
					bypass_ready = true
				end

				local old_handshake = nil
				local handshake_hook
				handshake_hook = function(identifier, new_state, new_vals, ...)
					if not is_setup then
						return old_handshake(identifier, new_state, new_vals, ...)
					end

					if typeof(identifier) ~= "string" or identifier ~= content_uri then
						return
					end

					if type(new_vals) == "table" and pass_table then
						local inner = rawget(pass_table, 1)
						if type(inner) == "table" then
							for i = 1, #new_vals do
								rawset(inner, i + 1, new_vals[i])
							end
						end
					end

					fire_handshake()
				end
				old_handshake = hookfunction(handshake_function, handshake_hook)
				hide_stack(handshake_hook)

				is_setup = true
				ac.success = ac.success + 1
				ac.character_sound_event = true
				ac.hooked = killed
				remotes.character_sound_event = target_remote
				remotes.empty = secondary_remote
				getgenv().ff3_bypass_ready = true
			end
		end
	end
	end
	end

	getgenv().ff3_init = {
		remotes = remotes,
		flags = flags_folder,
		is_practice = is_practice,
		client_main = client_main,
		ac = ac,
	}

end