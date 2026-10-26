-- RoScripts executor probe v11. Source: https://roscripts.io/probe
-- It lists the functions and libraries this executor has and how they
-- behave, prints that list to the console, then sends it to
-- https://roscripts.io/api/probe. Its only network requests go to roscripts.io
-- and to roscripts-tls.fly.dev, RoScripts' TLS check, which reads the
-- executor's TLS handshake and closes the connection.
-- It does not read your cookie, username, user id or files, and it changes
-- nothing in the game. For gethwid() and other ids it keeps only the type
-- and length, never the value.

local VERSION = "v11"
local TOP = table.pack(...)
local QUIET = false
local URL = "https://roscripts.io/api/probe"
local ECHO = URL .. "/echo"
local _, Http = pcall(function() return game:GetService("HttpService") end)
local REPORT = {}
local N = 0
local function clean(s)
	if utf8.len(s) then return s end
	return (s:gsub("[\128-\255]", "?"))
end
local function out(s)
	s = clean(tostring(s))
	table.insert(REPORT, s)
	N = N + 1
	if QUIET then return end
	if #s <= 180 then print("RSP " .. N .. " " .. s) return end
	for i = 1, #s, 180 do print("RSP " .. N .. "." .. math.floor(i / 180) + 1 .. " " .. s:sub(i, i + 179)) end
end
local function str(v)
	if type(v) == "number" then return string.format("%.17g", v) end
	return tostring(v)
end
local function j(...) local t = table.pack(...) for i = 1, t.n do t[i] = str(t[i]) end return table.concat(t, ",") end
local function try(name, f)
	local ok, r = pcall(f)
	out(name .. " " .. (ok and tostring(r) or ("ERR " .. tostring(r))))
	if QUIET then pcall(task.wait) end
end
local function sig(f)
	if type(f) ~= "function" then return typeof(f) end
	local ok, a, va = pcall(debug.info, f, "a")
	local kind = (iscclosure and iscclosure(f)) and "C" or "L"
	if islclosure and islclosure(f) == (kind == "C") then kind = kind .. "?" end
	return kind .. tostring(ok and a or "?") .. (va and "v" or "")
end
local function describe(v)
	if type(v) ~= "string" then return typeof(v) end
	local bare = v:gsub("[%-{}]", "")
	local kind = bare == "" and "empty"
		or bare:match("^%d+$") and "digits"
		or bare:match("^%x+$") and (bare:match("%u") and (bare:match("%l") and "hex mixed" or "hex upper") or "hex lower")
		or bare:match("^[%w_]+$") and "alnum"
		or "text"
	local layout = v:find("[%-{}]") and (" " .. v:gsub("[^%-{}]+", function(s) return tostring(#s) end)) or ""
	return "string len=" .. #v .. " " .. kind .. layout
end

out("probe " .. VERSION)
if QUIET then out("mode auto") end
try("id", function() return j(identifyexecutor()) end)
try("env", function()
	return j(getgenv() == getfenv(0), getfenv(0) == getfenv(1), typeof(getmetatable(getfenv(0))), getrenv() == getgenv(), _G == getgenv()._G)
end)

for _, lib in ipairs({ "bit32", "buffer", "coroutine", "debug", "math", "string", "table", "task", "utf8", "os" }) do
	try("lib " .. lib, function()
		local t = getfenv(0)[lib]
		if type(t) ~= "table" then return "not a table: " .. typeof(t) end
		local names = {}
		for k in pairs(t) do table.insert(names, tostring(k)) end
		table.sort(names)
		for i, k in ipairs(names) do names[i] = k .. ":" .. sig(t[k]) end
		return #names .. " frozen=" .. tostring(table.isfrozen(t)) .. " mt=" .. typeof(getmetatable(t)) .. " " .. table.concat(names, " ")
	end)
end

try("globals", function()
	local list = {}
	for _, n in ipairs({ "type", "typeof", "tostring", "tonumber", "getfenv", "setfenv", "getmetatable", "setmetatable", "pcall",
		"xpcall", "assert", "error", "select", "next", "pairs", "ipairs", "unpack", "rawget", "rawset", "rawequal", "rawlen",
		"loadstring", "newproxy", "gcinfo", "require", "print", "warn", "tick", "time", "wait", "delay", "spawn",
		"islclosure", "iscclosure", "identifyexecutor", "Enum", "game", "workspace", "Instance", "Vector2", "Vector3",
		"UDim", "UDim2", "CFrame", "Random", "Path2DControlPoint", "task", "debug" }) do
		local v = getfenv(0)[n]
		table.insert(list, n .. ":" .. (type(v) == "function" and sig(v) or typeof(v)))
	end
	return table.concat(list, " ")
end)

local function val(name, make)
	try("val " .. name, function()
		local v = make()
		local mt = getmetatable(v)
		local raw = getrawmetatable and getrawmetatable(v)
		local rk = {}
		if type(raw) == "table" then for k in pairs(raw) do table.insert(rk, tostring(k)) end table.sort(rk) end
		return j(typeof(v), type(v), (tostring(v):gsub("0x%x+", "ADDR")), typeof(mt), type(mt) == "string" and mt or "", table.concat(rk, "/"))
	end)
end
val("game", function() return game end)
val("workspace", function() return workspace end)
val("Enum", function() return Enum end)
val("Enum.KeyCode", function() return Enum.KeyCode end)
val("KeyCode.A", function() return Enum.KeyCode.A end)
val("Vector2", function() return Vector2.new(1, 2) end)
val("Vector3", function() return Vector3.new(1, 2, 3) end)
val("UDim", function() return UDim.new(0.5, 3) end)
val("UDim2", function() return UDim2.new(0.5, 3, 0.25, 7) end)
val("CFrame", function() return CFrame.new(1, 2, 3) end)
val("Random", function() return Random.new(1) end)
val("Path2DControlPoint", function() return Path2DControlPoint.new() end)
val("signal", function() return game.ChildAdded end)
val("Instance.new", function() return Instance.new("Folder") end)
try("libs on values", function()
	return j(typeof(Vector2), typeof(Vector3.new), sig(Vector3.new), sig(UDim2.new), sig(Instance.new), sig(Random.new), sig(CFrame.new),
		sig(game.GetService), sig(game.FindFirstChild), sig(game.ChildAdded.Connect), table.isfrozen(Vector3), table.isfrozen(Instance))
end)

try("err index", function() return j(pcall(function() return game.NotAMember end)) end)
try("err new", function() return j(pcall(Instance.new, "NotAClass")) end)
try("err v3", function() return j(pcall(Vector3.new, "x")) end)
try("err call", function() return j(pcall(function() return game.GetService() end)) end)
try("err enum", function() return j(pcall(function() return Enum.KeyCode.NotAKey end)) end)
try("err set", function() local f = Instance.new("Folder") return j(pcall(function() f.Name = {} end)) end)
try("err math", function() return j(pcall(function() return Vector3.new() + 1 end)) end)

try("ls count", function() return select("#", loadstring("return 1")) end)
try("ls src", function() return debug.info(loadstring("return function() end")(), "s") end)
try("ls err", function() return j(loadstring("x=", "Luraph")) end)
try("ls junk", function() return j(loadstring("\27LuaP"), loadstring("61930")) end)
try("getfenv(100)", function() return j(pcall(getfenv, 100)) end)
try("setfenv(100)", function() return j(pcall(setfenv, 100, {})) end)
try("tostring traps", function()
	local hit = {}
	local function bait(n) return setmetatable({}, { __tostring = function() table.insert(hit, n) if QUIET then error("", 0) end return "x" end }) end
	pcall(loadstring, bait("loadstring")) pcall(type, bait("type")) pcall(typeof, bait("typeof")) if not QUIET then pcall(warn, bait("warn")) end
	pcall(error, bait("error")) pcall(assert, false, bait("assert")) pcall(select, bait("select"))
	return (#hit > 0 and table.concat(hit, " ") or "none") .. (QUIET and " (warn not run)" or "")
end)
try("getinfo(print)", function() local i = debug.getinfo(print) return j(i.what, i.source, i.short_src, i.numparams, i.is_vararg, i.nups, i.currentline, i.linedefined, i.name) end)
try("getinfo(fn)", function() local i = debug.getinfo(function(a, b) end) return j(i.what, i.numparams, i.is_vararg, i.nups, i.currentline == i.linedefined, i.name) end)
try("getinfo(1)", function() local i = debug.getinfo(1) return j(i.what, i.currentline ~= nil, i.name, i.func ~= nil) end)
try("info levels", function() local function me() return debug.info(1, "f") == me, debug.info(0, "n"), debug.info(2, "s") ~= nil end return j(me()) end)
try("mt", function() local mt = getrawmetatable(game) return j(debug.getmetatable(game) == mt, typeof(getmetatable(game)), getmetatable(game), isreadonly(mt), sig(mt.__index), sig(mt.__namecall)) end)
try("newc", function()
	local c = newcclosure(function(a) end)
	return j(sig(c), isexecutorclosure(c), debug.info(c, "s"), debug.info(c, "l"), #debug.getupvalues(c), newcclosure(print) == print)
end)
try("newc err", function() return j(pcall(newcclosure(function() error("boom") end))) end)
try("newc err2", function() return j(pcall(newcclosure(function() local x = nil return x.y end))) end)
try("closures", function()
	local lf = function() end
	return j(isexecutorclosure(print), isexecutorclosure(lf), isexecutorclosure(getgenv), isexecutorclosure(loadstring("return 1")), islclosure(coroutine.wrap(lf)))
end)
try("hash", function() return j(#getfunctionhash(function() end), getfunctionhash(function() end) == getfunctionhash(function() end), getfunctionhash(function() end) == getfunctionhash(function(...) end)) end)
try("hash C", function() return j(pcall(getfunctionhash, print)) end)
try("hook lua", function()
	local function target() return "a" end
	local old = hookfunction(target, function() return "b" end)
	return j(target(), old(), isfunctionhooked and isfunctionhooked(target))
end)
try("hook C", function()
	local target = newcclosure(function() return "a" end)
	local old = hookfunction(target, function() return "hooked" end)
	local now = target()
	hookfunction(target, old)
	return j(now, target(), sig(old))
end)
try("conns", function()
	local e = Instance.new("BindableEvent")
	e.Event:Connect(function() end)
	local c = getconnections(e.Event)[1]
	return j(#getconnections(e.Event), c and typeof(c.Function), c and c.Enabled, c and c.ForeignState, c and c.LuaConnection, c and typeof(c.Thread))
end)
try("cloneref", function() local c = cloneref(game) return j(c == game, rawequal(c, game), typeof(c)) end)
try("gethui", function() local h = gethui() return j(typeof(h), h.ClassName, h.Name, h.Parent and h.Parent.ClassName) end)
try("game", function() local R = game:GetService("RunService") return j(R:IsStudio(), R:IsClient(), R:IsServer(), #game.JobId, version(), _VERSION) end)
try("screen", function() return j(workspace.CurrentCamera.ViewportSize, game:GetService("GuiService"):GetGuiInset()) end)
try("threads", function() return j(getthreadidentity and getthreadidentity(), checkcaller and checkcaller(), coroutine.isyieldable(), typeof(coroutine.running())) end)

try("genv", function()
	local names = {}
	for k, v in pairs(getgenv()) do
		if type(k) == "string" and (type(v) == "function" or type(v) == "table") and not rawequal(getrenv()[k], v) then table.insert(names, k) end
	end
	table.sort(names)
	for i, k in ipairs(names) do
		local v = getgenv()[k]
		if type(v) == "table" then
			local n = 0 for _ in pairs(v) do n = n + 1 end
			names[i] = k .. ":table" .. n
		else
			names[i] = k .. ":" .. sig(v)
		end
	end
	return #names .. " " .. table.concat(names, " ")
end)
local KNOWN = "FireProximityPrompt FireTouchInterest GetObjects HttpGet HttpGetAsync HttpPost HttpPostAsync HttpRequest Require addqueuescript addteleportscript append_file append_file_async appendfile appendfileasync badd base64_decode base64_encode base64decode base64encode bdiv bmul bsub bswap c_fire_signal cacheinvalidate cachereplace can_signal_replicate canreplicatesignal cansignalreplicate cfiresignal check_caller check_calling_script check_closure check_parallel checkcaller checkclosure checkparallel clear_draw_cache clear_drawing_cache clear_queue_on_teleport clear_teleport_queue clear_tp_queue cleardrawcache cleardrawingcache clearqueue_on_teleport clearqueueonteleport clearqueuescript clearteleportqueue clearteleportscript cleartpqueue clone_function clone_ref clone_reference clonefunc clonefunction cloneinstance cloneref clonereference compare_function compare_functions compare_instances comparefunction comparefunctionhash comparefunctions compareinstances compile connect console_clear console_create console_destroy console_err console_hide console_info console_input console_name console_print console_set_title console_show console_warn consoleclear consolecreate consoledestroy consoleerr consoleerror consolehide consoleinfo consoleinput consoleinputasync consolename consoleprint consolesettitle consoleshow consolewarn consolewrite create_comm_channel create_communication_channel createcommchannel createcommunicationchannel createfolder createrenderobj createrenderobject decompile decompilefunction decrypt defersignal del_file del_folder deletefile deletefolder delfile delfolder detour_function detourclosure detourfunc detourfunction developerlogfunctioncall dgetfenv disableconnection disablesignal disassemble disassemblefunction do_file do_file_async dofile dofileasync dump_string dumpbytecode dumpfunctionbytecode dumpstring emulateJJSploit emulateSolara emulateWave enableconnection enablesignal encodebase64 encrypt filexist filter_gc filtergc fire_click_detector fire_proximity_prompt fire_signal fire_touch_interest fireclickdetector fireconnection firedetector fireproximityprompt firesignal firetouchinterest firetouchtransmitter fixorion fixorionlib folderexist fpsunlock fpsunlocker fullgc gcstart gcstop generatebytes generatekey get_actor_from_state get_actor_from_thread get_actor_states get_actor_threads get_actors get_all_threads get_callback_function get_callback_member get_callback_thread get_callback_value get_calling_script get_callstack get_comm_channel get_communication_channel get_connection get_connection_function get_connection_thread get_connections get_constant get_constants get_cpu_usage get_current_actor get_custom_asset get_deleted_actors get_destroyed_actors get_event_member get_executor_identity get_executor_name get_executor_version get_fflag get_filter get_fps_cap get_function_bytecode get_function_hash get_game_state get_gc get_gc_objects get_genv get_hidden_gui get_hidden_properties get_hidden_property get_hidden_ui get_hiddenproperty get_hui get_hwid get_identity get_info get_instance_address get_instances get_loaded_modules get_lua_state get_menv get_metafield get_modules get_namecall get_namecall_method get_namecallmethod get_nil_instances get_original_thread get_pid get_process_identifier get_properties get_proto get_protos get_raw_metatable get_reg get_registry get_render_property get_render_stepped_list get_renderstepped_list get_renv get_roblox_version get_running_scripts get_script_bytecode get_script_closure get_script_from_thread get_script_func get_script_function get_script_globals get_script_hash get_script_thread get_scripts get_senv get_signal_arguments get_signal_arguments_info get_signal_cons get_signal_whitelist get_stack get_state_env get_syn_asset get_tenv get_thread_capabilities get_thread_context get_thread_identity get_upvalue get_upvalues get_user_identifier getactorfromstate getactorfromthread getactors getactorstate getactorstates getactorthread getactorthreads getallactors getallthreads getasset getbspval getcallbackfunction getcallbackmember getcallbackthread getcallbackvalue getcaller getcallingscript getcallstack getcbvalue getclipboard getcommchannel getcommunicationchannel getconnection getconnectionfunction getconnections getconnectionthread getcons getconst getconstant getconstants getconsts getcontext getcpuusage getcurrentactor getcurrentline getcurrentthread getcustomasset getdeletedactors getdestroyedactors geteventmember getexecutorname getexecutorversion getfastflag getfastflagtype getfflag getfflagtype getfilter getflag getfpscap getfuncinfo getfunctionbytecode getfunctionhash getfunctioninfo getfunctionref getfunctionreference getfunctionscript getfunctionthread getgamestate getgarbagecollector getgc getgenv getgenv_access gethiddengui gethiddenprop gethiddenproperties gethiddenproperty gethiddenprops gethiddenui gethui gethwid getidentity getinfo getinstanceaddress getinstancecache getinstancelist getinstances getinstructions getloadedmodules getluastate getmenv getmetafield getmoduleenv getmodules getmodulesenv getmousepos getnamecall getnamecallmethod getnetworkowner getnilinstances getobjects getpcd getpcdprop getpid getprocessidentifier getproperties getprops getproto getprotos getproximitypromptduration getrawmetatable getrbxversion getreg getregistry getrenderproperty getrenderstepcallbacks getrendersteppedlist getrenv getreplicatesignalarguments getrobloxenv getrunningscripts getsafeenv getscriptable getscriptbytecode getscriptcaller getscriptclosure getscriptenv getscriptenvironment getscriptfromfunction getscriptfromthread getscriptfunc getscriptfunction getscriptglobal getscriptglobals getscripthash getscripts getscriptsource getscriptsthatrun getscriptthread getsenv getsignalargs getsignalargsinfo getsignalarguments getsignalargumentsinfo getsignals getsignalwhitelist getsimradius getsimulationradius getspecialinfo getstack getstateenv getsynasset getteleportqueue gettenv getthreadcapabilities getthreadcaps getthreadcontext getthreadenv getthreadfromactor getthreadfromfunction getthreadidentity getthreadobject getthreads gettreg getupval getupvals getupvalue getupvalues gfindidx glooperror has_metafield has_metatable hash hasmetafield hasmetatable hmac hook_func hook_function hook_meta_method hook_metamethod hook_proto hook_signal hookclosure hookfunc hookfunction hookmetafunction hookmetamethod hookproto hooksignal http_get http_post http_request httpget httppost httprequest identify_executor identifyexecutor identityexecutor info invalidate isXclosure is_c_closure is_cclosure is_connection_enabled is_delta_closure is_executor_closure is_executor_state is_executor_thread is_exploit_function is_file is_folder is_func_hooked is_function_hooked is_game_active is_game_script_connection is_hidden_stack is_hooked is_isaeva_caller is_krnl_closure is_l_closure is_lclosure is_lua_connection is_luau is_modulescript_loaded is_network_owner is_new_c_closure is_opium_closure is_opiumware_closure is_our_closure is_our_function is_our_thread is_parallel is_protected is_proto_hooked is_protosmasher_closure is_rbx_active is_read_only is_readonly is_render_obj is_scriptable is_signal_hooked is_stack_hidden is_synapse_function is_un_touched is_untouched is_valid_level is_waiting_connection is_window_active is_write_able iscache iscached iscachedinstance iscacheinstance iscclosure isclosurehooked isconnectionenabled iscustomcclosure isdeltafunction isdir isefunction isexecthread isexecutorclosure isexecutorfunction isexecutorstate isexecutorthread isexploitclosure isexploitfunction isfile isfocused isfolder isfunchooked isfunctionhooked isgameactive isgamescriptconnection ishiddenproperty ishiddenstack ishooked islclosure isluaclosure isluaconnection isluau isnetworkowner isnewcclosure isopiumwareclosure isourclosure isourfunction isourthread isownthread isparallel isprotected isprotohooked isrbxactive isreadonly isrenderobj isrenderobject isrobloxactive isscriptable issignalhooked issignalreplicate issignalreplicateable isstackhidden issynapsefunction issynapsethread isuntouched isvalidlevel isvolcanofunction iswaitingconnection iswindowactive iswritable iswriteable key_click key_press key_release key_tap keyclick keyclick_mac keyclickmac keypress keypress_mac keypressmac keyrelease keyrelease_mac keyreleasemac keytap keytap_mac keytapmac leftpress leftrelease list_files listfiles load load_file load_file_async load_string loadcustomasset loadfile loadfileasync lz4_compress lz4_decompress lz4compress lz4decompress make_folder make_read_only make_readonly make_writable make_write_able make_writeable makeallprotosinactive makedir makefolder makeprotoinactive makereadonly makewritable makewriteable message_box messagebox messageboxasync mouse1_click mouse1_press mouse1_release mouse1click mouse1press mouse1release mouse2_click mouse2_press mouse2_release mouse2click mouse2press mouse2release mouse_1_click mouse_1_press mouse_1_release mouse_2_click mouse_2_press mouse_2_release mouse_move_abs mouse_move_rel mouse_scroll mousemove mousemoveabs mousemoverel mousescroll new_c_closure new_cclosure new_l_closure new_lclosure newcclosure newcfunction newlclosure newlfunction oldMagnitude oldNc on_actor_added onactoradded open_file_dialog open_files_dialog open_folder_dialog openfiledialog openfilesdialog openfolderdialog overridemalicious printconsole printdeveloperlog printf queue_on_teleport queue_on_tp queueonteleport queueontp queueteleport queueteleportscript r_base64_decode r_base64_encode random randomstring rconsole_clear rconsole_create rconsole_destroy rconsole_err rconsole_hidden rconsole_hide rconsole_info rconsole_input rconsole_name rconsole_print rconsole_set_title rconsole_show rconsole_toggle rconsole_warn rconsoleclear rconsolecreate rconsoledestroy rconsoleerr rconsoleerror rconsolehidden rconsolehide rconsoleinfo rconsoleinput rconsoleinputasync rconsolename rconsoleprint rconsolereset rconsolesettitle rconsoleshow rconsoletoggle rconsoletop rconsolewarn rconsolewrite read_file read_file_async readbinarystring readbinarystringpropertyvalue readbspval readfile readfileasync replace replace_closure replaceclosure replacefunc replacefunction replacemetamethod replicate_signal replicateevent replicatesignal request restore_closure restore_func restore_function restore_proto restore_signal restoreclosure restorefunc restorefunction restoreproto restoresignal rightpress rightrelease rol ror rprintconsole run_on_actor run_on_actor_thread run_on_thread runfile runonactor runonactorthread runonthread save_file_dialog save_instance save_place savefiledialog savegame saveinstance saveplace secure_call securecall secureerror secureinfo secureprint securewarn set_callback_function set_callback_member set_callback_value set_clipboard set_connection_enabled set_constant set_fflag set_fps_cap set_hidden_property set_hidden_stack set_hiddenproperty set_identity set_namecall set_namecall_method set_namecallmethod set_raw_metatable set_rbx_clipboard set_read_only set_readonly set_render_property set_scriptable set_stack set_stack_hidden set_thread_capabilities set_thread_context set_thread_identity set_un_touched set_untouched set_upvalue setaddr setallprotosinactive setcallbackfunction setcallbackmember setcallbackthread setcallbackvalue setcallstack setclipboard setconnectionenabled setconst setconstant setconsts setfastflag setfflag setflag setfps setfpscap setfpslimit setfpsmax sethiddenprop sethiddenproperty sethiddenstack setidentity setinfo setinternalfflag setname setnamecall setnamecallmethod setnetworkowner setpropertyable setprotoinactive setproximitypromptduration setrawmetatable setrbxclipboard setreadonly setrenderproperty setsafeenv setscriptable setsimradius setsimulationradius setstack setstackhidden setthreadcapabilities setthreadcaps setthreadcontext setthreadidentity setuntouched setupval setupvals setupvalue sirhurt_create_secure_function sirhurt_hub_scrun sirhurt_run_secure sirhurt_run_secure_code sirhurt_run_secure_code_rload sirhurt_secure_code sirhurt_secure_code_rload spoofscripthwid syncustomasset to_clipboard tobit toclipboard tohex tramp_call trampcall trampoline_call trampolinecall unhookfunction unlockfps valid_level validlevel whatexecutor write_custom_asset write_file write_file_async write_syn_asset writecustomasset writefile writefileasync writesynasset wsconnect zstd_compress zstd_decompress zstdcompress zstddecompress"
try("has", function()
	local env, names = getfenv(0), {}
	for k in string.gmatch(KNOWN, "%S+") do
		local ok, v = pcall(function() return env[k] end)
		if ok and (type(v) == "function" or type(v) == "table") then table.insert(names, k) end
	end
	return #names .. " " .. table.concat(names, " ")
end)
for _, lib in ipairs({ "crypt", "cache", "debug", "drawing", "Drawing", "http", "syn", "fluxus", "WebSocket" }) do
	try("xlib " .. lib, function()
		local t = getgenv()[lib]
		if type(t) ~= "table" then return typeof(t) end
		local names = {}
		for k, v in pairs(t) do table.insert(names, tostring(k) .. ":" .. sig(v)) end
		table.sort(names)
		return #names .. " " .. table.concat(names, " ")
	end)
end

local ROBLOX = {}
for n in ("assert error getmetatable setmetatable ipairs pairs next pcall xpcall print select tonumber tostring type typeof unpack rawequal rawget rawset rawlen gcinfo newproxy collectgarbage getfenv setfenv require loadstring _G _VERSION string math table os debug bit32 coroutine utf8 buffer vector game Game workspace Workspace script plugin shared settings UserSettings tick time wait delay spawn elapsedTime ElapsedTime warn task Wait Delay Spawn Version Enum Instance stats Stats version printidentity ypcall Axes BrickColor CFrame CatalogSearchParams Color3 ColorSequence ColorSequenceKeypoint Content DateTime DockWidgetPluginGuiInfo Faces FloatCurveKey Font NumberRange NumberSequence NumberSequenceKeypoint OverlapParams Path2DControlPoint PathWaypoint PhysicalProperties Random Ray RaycastParams Rect Region3 Region3int16 RotationCurveKey SecurityCapabilities SharedTable TweenInfo UDim UDim2 ValueCurveKey Vector2 Vector2int16 Vector3 Vector3int16"):gmatch("%S+") do ROBLOX[n] = true end

try("tables", function()
	local env = getgenv and getgenv() or getfenv(0)
	local names = {}
	for k in pairs(env) do if type(k) == "string" then table.insert(names, k) end end
	pcall(function() for k in pairs(getfenv(0)) do if type(k) == "string" and env[k] == nil then table.insert(names, k) end end end)
	table.sort(names)
	local extra, tables, consts = {}, 0, {}
	for _, k in ipairs(names) do
		local v = env[k] ~= nil and env[k] or getfenv(0)[k]
		if not ROBLOX[k] then
			if type(v) == "function" or type(v) == "table" or type(v) == "userdata" then
				table.insert(extra, k .. ":" .. sig(v))
			else
				local prefix = k:match("^(%a+_)") or k:match("^(%u%l+)") or k
				consts[prefix] = (consts[prefix] or 0) + 1
			end
		end
		local lib = true
		if QUIET and type(v) == "table" then for _, mv in pairs(v) do if type(mv) ~= "function" and type(mv) ~= "table" then lib = false break end end end
		if type(v) == "table" and lib and k ~= "_G" and k ~= "shared" and not ROBLOX[k] then
			local m = {}
			for mk, mv in pairs(v) do table.insert(m, tostring(mk) .. ":" .. sig(mv)) end
			table.sort(m)
			out("table " .. k .. " " .. #m .. " " .. table.concat(m, " "))
			tables = tables + 1
		end
	end
	out("notroblox " .. #extra .. " " .. table.concat(extra, " "))
	local cl = {}
	for pfx, n in pairs(consts) do table.insert(cl, pfx .. "*" .. n) end
	table.sort(cl)
	out("constants " .. #cl .. " " .. table.concat(cl, " "))
	return tables .. " tables"
end)

try("hwid", function() return sig(gethwid) .. " " .. describe(gethwid()) end)
try("names", function() return j(identifyexecutor()) .. " | " .. tostring(getexecutorname and getexecutorname()) end)
try("ids", function() return describe(game.JobId) .. " | " .. describe(game:GetService("RbxAnalyticsService"):GetClientId()) end)
try("locale", function() return j(game:GetService("LocalizationService").RobloxLocaleId, game:GetService("LocalizationService").SystemLocaleId) end)
try("clock", function() return j(os.clock() > 0, math.floor(time()) >= 0, os.time() - tick() < 2, typeof(DateTime.now())) end)

local A = Random.new(1430471439)
try("random methods", function() return j(A.NextUnitVector == A.NextUnitVector, A.NextInteger == A.NextInteger, A.NextNumber == A.NextNumber, A.Shuffle == A.Shuffle, A.Clone == A.Clone) end)
try("random clone", function()
	local B = Random.new(223593360)
	local C = B:Clone()
	local seq = { typeof(C), C == B, rawequal(C, B) }
	local function add(...) for _, v in ipairs({ ... }) do table.insert(seq, v) end end
	add(B:NextInteger(438, 712))
	add(C:NextNumber())
	add(B:NextInteger(189, 839))
	add(C:NextInteger(750, 955), C:NextInteger(505, 1407), C:NextInteger(848, 1004))
	add(B:NextNumber(), B:NextNumber(), B:NextNumber())
	add(C:NextNumber(), C:NextInteger(718, 1293))
	add(B:NextInteger(967, 1744), B:NextInteger(38, 929), B:NextNumber())
	add(C:NextInteger(497, 828))
	add(Random.new(223593360):NextNumber())
	return j(table.unpack(seq))
end)
try("random tostring", function() return j(tostring(A), typeof(A), A.NextInteger == Random.new(2).NextInteger) end)

try("enum FromValue", function() local E = Enum.HumanoidCollisionType return j(E:FromValue(0), E:FromValue(1), E:FromValue(2), E:FromValue(99)) end)
try("enum FromName", function() local E = Enum.HumanoidCollisionType return j(E:FromName("OuterBox"), E:FromName("Nope")) end)
try("enum item", function()
	local E = Enum.HumanoidCollisionType
	local i = E.OuterBox
	return j(i.Value, i:IsA("HumanoidCollisionType"), i:IsA("Material"), i.EnumType == E, tostring(i.EnumType), i.Name)
end)
try("enum methods", function() local E = Enum.HumanoidCollisionType return j(E.FromName == E.FromName, E.FromValue == Enum.Material.FromValue, E.OuterBox.IsA == E.OuterBox.IsA) end)

local function fp(tag, get)
	try("fp " .. tag, function()
		local o = get()
		local s1, s2 = o.AttributeChanged, o.AttributeChanged
		local c = o.ChildRemoved:Connect(function() end)
		local before = c.Connected
		c:Disconnect()
		return j(typeof(o), o.Parent and o.Parent.ClassName, o.Name, tostring(o), o.ClassName, s1 == s2, rawequal(s1, s2), s1.Connect == s2.Connect,
			o.ChildRemoved.Connect == s1.Connect, before, c.Connected, tostring(s1), tostring(c))
	end)
end
fp("game", function() return game end)
fp("workspace", function() return workspace end)
fp("http", function() return game:GetService("HttpService") end)
fp("run", function() return game:GetService("RunService") end)
fp("folder", function() return Instance.new("Folder") end)

try("child removed", function()
	local P = Instance.new("Folder")
	local fired = {}
	P.ChildRemoved:Connect(function(c) table.insert(fired, c.Name) end)
	local K = Instance.new("Folder")
	K.Name = "138620"
	K.Parent = P
	local found = P:WaitForChild("138620", 1) == K
	K:Destroy()
	local now = #fired
	task.wait()
	return j(found, now, #fired, fired[1] == "138620", K.Parent)
end)
try("set parent after destroy", function()
	local P = Instance.new("Folder")
	local K = Instance.new("Folder")
	K.Name = "138620"
	K.Parent = P
	K:Destroy()
	return j(pcall(function() K.Parent = P end))
end)
try("dot GetChildren", function() return j(pcall(function() return game:GetService("RunService").GetChildren() end)) end)
try("dot identity", function() local rs = game:GetService("RunService") return j(rs.IsServer == rs.IsServer, rs.IsStudio == rs.IsClient, rs.IsServer == game.IsA) end)

try("request fns", function()
	return j(typeof(request), typeof(http_request), syn and typeof(syn.request), http and typeof(http.request), fluxus and typeof(fluxus.request))
end)

local req = (syn and syn.request) or (http and http.request) or http_request or (fluxus and fluxus.request) or request
local callable = type(req) == "function" or typeof(req) == "function" or type(req) == "table" or type(req) == "userdata"
local function waitFor(f, secs)
	local done, ok, res = false, false, nil
	task.spawn(function() ok, res = pcall(f) done = true end)
	local t = os.clock()
	while not done and os.clock() - t < secs do task.wait(0.1) end
	if not done then error("timed out", 0) end
	if not ok then error(res, 0) end
	return res
end
local function echo(label, f)
	try("echo " .. label, function()
		local res = waitFor(f, 10)
		local reply = type(res) == "table" and (res.Body or res.body) or res
		local d = Http:JSONDecode(reply)
		local keys = {}
		if type(res) == "table" then for k in pairs(res) do table.insert(keys, tostring(k)) end table.sort(keys) end
		return j(d.method, d.bodyLength, table.concat(keys, "/")) .. " " .. Http:JSONEncode(d.wire)
	end)
end
echo("httpget", function() return game:HttpGet(ECHO .. "?via=httpget") end)
if callable then
	echo("request get", function() return req({ Url = ECHO .. "?via=get", Method = "GET" }) end)
	echo("request post", function() return req({ Url = ECHO .. "?via=post", Method = "POST", Body = "x" }) end)
	echo("request json", function() return req({ Url = ECHO .. "?via=json", Method = "POST", Body = "{}", Headers = { ["Content-Type"] = "application/json" } }) end)
end
local function shape(v) return (tostring(v):gsub("0x%x+", "0xH"):gsub("%x%x%x%x%x%x%x%x+", "H")) end
try("x10 top", function() return j(TOP.n, TOP.n > 0 and typeof(TOP[1]) or "none") end)
try("x10 setfenv C", function() return j(pcall(setfenv, print, {})) end)
try("x10 getfenv", function() return j(getfenv(print) == getfenv(0), pcall(getfenv, -1)) .. " | " .. j(pcall(getfenv, "x")) end)
try("x10 ls names", function()
	local r = {}
	for _, n in ipairs({ "sha256", "=x", "@x", "" }) do
		local f = loadstring("error('e')", n)
		table.insert(r, f and tostring(select(2, pcall(f))) or "nil")
	end
	return table.concat(r, " | ")
end)
try("x10 ls src", function()
	local r = {}
	for _, n in ipairs({ "sha256", "=x", "@x" }) do table.insert(r, tostring(debug.info(loadstring("return function() end", n)(), "s"))) end
	return table.concat(r, " | ")
end)
try("x10 ls bad", function() return j(pcall(loadstring, nil)) .. " | " .. j(pcall(loadstring, 5)) .. " | " .. select("#", loadstring("x=")) end)
try("x10 info C", function() return j(debug.info(print, "slnaf")) end)
try("x10 info lvl", function()
	local function a() return j(debug.info(1, "sln")) .. " / " .. j(debug.info(2, "sl")) end
	return a() .. " / " .. j(pcall(debug.info, 0, "s")) .. " / " .. j(pcall(debug.info, print, "z"))
end)
try("x10 closures", function()
	local lf = function() end
	local function k(f) return j(iscclosure and iscclosure(f), islclosure and islclosure(f), isexecutorclosure and isexecutorclosure(f)) end
	local nc = newcclosure and newcclosure(lf)
	return table.concat({ k(print), k(game.GetService), k(loadstring), k(getgenv), nc and k(nc) or "nil", k(coroutine.wrap(lf)), k(task.spawn) }, " | ")
end)
try("x10 tostring", function()
	return table.concat({ shape(print), shape(function() end), shape(coroutine.create(function() end)), shape({}), shape(newproxy()) }, " | ")
end)
try("x10 numbers", function()
	return table.concat({ tostring(1 / 0), tostring(-1 / 0), tostring(0 / 0), tostring(-0), string.format("%.14g", 0.1), tostring(2 ^ 53), tostring(1e300 * 10) }, " | ")
end)
try("x10 errors", function()
	local function lvl2() error("x", 2) end
	local function call() lvl2() end
	return table.concat({ tostring(select(2, pcall(error))), tostring(select(2, pcall(error, nil))), typeof(select(2, pcall(error, {}))),
		tostring(select(2, pcall(call))), tostring(select(2, pcall(error, "y", 0))) }, " | ")
end)
try("x10 traceback", function() return shape((debug.traceback("m", 1):gsub("\n", "\\n")):sub(1, 240)) end)
try("x10 co", function() return j(coroutine.isyieldable(), shape(coroutine.running()), select("#", coroutine.running())) end)
try("x10 gc", function() return j(type(gcinfo()), (pcall(collectgarbage, "count"))) end)
try("x10 tls", function()
	local TLS = "https://roscripts-tls.fly.dev/"
	local a = pcall(waitFor, function() return game:HttpGet(TLS .. "h") end, 8)
	local b = callable and pcall(waitFor, function() return req({ Url = TLS .. "r", Method = "GET" }) end, 8)
	return j(a, b)
end)
out("done")

local text = table.concat(REPORT, "\n")
local name, ver = "", ""
pcall(function() local a, b = identifyexecutor() name, ver = tostring(a or ""), tostring(b or "") end)
local function q(s)
	local esc = { ['"'] = '\\"', ["\\"] = "\\\\", ["\n"] = "\\n", ["\r"] = "\\r", ["\t"] = "\\t" }
	return '"' .. clean(s):gsub('[%c"\\]', function(c) return esc[c] or string.format("\\u%04x", c:byte()) end) .. '"'
end
local function byHand()
	local l = {}
	for i, s in ipairs(REPORT) do l[i] = q(s) end
	return '{"probe":' .. q(VERSION) .. ',"executor":{"name":' .. q(name) .. ',"version":' .. q(ver) .. '},"lines":[' .. table.concat(l, ",") .. "]}"
end
local okBody, body = pcall(function() return Http:JSONEncode({ probe = VERSION, executor = { name = name, version = ver }, lines = REPORT }) end)
if not okBody or type(body) ~= "string" then body = byHand() end

local okPost, httpPost = pcall(function() return game.HttpPost end)
httpPost = okPost and httpPost
local sent, status, id = false, "no request function", nil
local function finish(f)
	local done, ok, res = false, false, nil
	task.spawn(function() ok, res = pcall(f) done = true end)
	local t = os.clock()
	while not done and os.clock() - t < 20 do task.wait(0.1) end
	if not done then status = "timed out" return end
	if not ok then status = "error " .. tostring(res) return end
	local reply = res
	if type(res) == "table" then
		local code = tonumber(res.StatusCode or res.statusCode or res.Status)
		status = "status " .. tostring(code or (res.Success and "ok" or "unknown"))
		sent = (code and code >= 200 and code < 300) or (code == nil and res.Success == true)
		reply = res.Body or res.body
	elseif type(res) == "string" then
		status = "reply"
		sent = res:find('"ok":true', 1, true) ~= nil
	end
	if type(reply) == "string" then id = reply:match('"id":"([%w_]+)"') end
end
if not QUIET then print("RSP sending " .. #body .. " bytes to " .. URL) end
if callable then
	finish(function() return req({ Url = URL, Method = "POST", Headers = { ["Content-Type"] = "application/json" }, Body = body }) end)
elseif httpPost then
	finish(function() return game:HttpPost(URL, body, "application/json") end)
end
if QUIET then
	return
elseif sent then
	print("RSP sent, " .. status .. (id and (", report " .. id) or ""))
else
	local copied = pcall(setclipboard, text)
	print("RSP not sent (" .. status .. "). " .. (copied and "The report is on your clipboard: paste it to us." or "Screenshot the RSP lines and send them to us."))
end
