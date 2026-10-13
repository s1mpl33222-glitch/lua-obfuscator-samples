-- This file was generated at discord.gg/syncrypt

local t2, u4, info, _pcall, _tostring, _type, find, byte, concat, v20, HttpGet, _loadstring, format, sub, v29, u30, v33, u35, v195, u274, u311, u375, u382, v399, v406, v412, v416

do
	local char, random, gsub, match, u31, u208, u209, u271, u387
	local v1 = nil
	local _rawget, _getrawmetatable, clock, HttpService, t8, t10, t18, t19, v345, v346

	do
		local function v2(...)
			local t1 = { ... }

			t1.n = select("#", ...)

			return t1
		end

		t2 = {}
		t2.__index = t2
		u4 = nil
		_rawget = rawget
		_getrawmetatable = getrawmetatable
		info = debug.info

		do
			local wait, t3, t5, t6, u48, u49, u181, u182, u183, u215, u216, u217, u218, u219, u220, u222, u223, u225, u226, u228, u229, u231, u233, n6, n7, t13, u249, u251, u256, u258, u262, mt, _getfenv, _rawequal, u267, pcall2, u269, type2
			local t7, t11, t12, u234, t14, n8, v247, t16, u282, u283, u284

			do
				local getupvalue = debug.getupvalue
				local getconstant = debug.getconstant
				local getproto = debug.getproto

				wait = task.wait
				_pcall = pcall
				_tostring = tostring
				_type = type
				clock = os.clock
				find = string.find
				byte = string.byte
				char = string.char
				concat = table.concat
				v20 = bit32 and bit32.bxor
				HttpGet = game.HttpGet
				_loadstring = loadstring
				random = math.random
				format = string.format
				sub = string.sub
				gsub = string.gsub
				match = string.match

				do
					local _request = request

					v29 = typeof(request) == "function" and request or nil
				end

				u30 = v29 and debug.info(v29, "s") or nil
				u31 = false

				do
					local u32 = _tostring

					function v33(p1, p2)
						if not u31 then
							u31 = true
							warn(("[WareGuard] %s: %s"):format(p1, (u32(p2))))

							local LocalPlayer = game.Players.LocalPlayer

							if LocalPlayer then
								LocalPlayer:Kick("WareGuard Security")
							end

							return
						end
					end
				end

				do
					local u34 = _pcall

					function u35()
						local _script = script

						script = nil

						if _script then
							_script.Parent = nil
						end

						getfenv().script = nil

						local v480, v481 = u34(getfenv, 0)

						if v480 and v481 then
							v481.script = nil
						end

						local v482, v483 = u34(getfenv, 1)

						if v482 and v483 then
							v483.script = nil
						end
					end
				end

				t3 = {}

				do
					local t4 = {
						rawget = rawget,
						rawset = rawset,
						rawequal = rawequal,
						rawlen = rawlen,
						setmetatable = setmetatable,
						getmetatable = getmetatable,
						type = type,
						tostring = tostring,
						tonumber = tonumber,
						pairs = pairs,
						ipairs = ipairs,
						next = next,
						select = select,
						unpack = unpack,
						pcall = pcall,
						xpcall = xpcall,
						error = error,
						assert = assert,
						load = load,
						loadstring = loadstring,
					}

					for k, v in pairs(t4) do
						t3[#t3 + 1] = {
							k,
							v,
						}
					end
				end

				t5 = {}

				do
					local wait2 = task.wait
					local spawn = task.spawn
					local defer = task.defer

					t5[1] = wait2
					t5[2] = spawn
					t5[3] = defer
					t6 = {}

					local format2 = string.format
					local len = string.len

					t6[1] = format2
					t6[2] = len

					local u47 = info

					function u48()
						return u47(2, "f")
					end
				end

				u49 = nil

				do
					local v58

					do
						local v50, v51 = _pcall(u48)

						if v50 then
							u49 = v51
						end

						t7 = {}

						local u53 = _type
						local u54 = info
						local u55 = _pcall
						local u56 = getupvalue
						local u57 = t7

						function v58(p3, p4)
							if p4 and u53(p4) == "function" then
								local v486 = u54(p4, "s")
								local n1 = 0
								local n2 = 1

								while n2 <= 30 and u55(u56, p4, n2) do
									n1 = n2
									n2 = n2 + 1
								end

								u57[#u57 + 1] = {
									p3,
									p4,
									v486,
									n1,
								}
							end
						end
					end

					do
						local v59 = false

						if typeof(hookfunction) == "function" then
							v59 = hookfunction
						end

						v58("hookfunction", v59)

						local v61 = false

						if typeof(hookmetamethod) == "function" then
							v61 = hookmetamethod
						end

						v58("hookmetamethod", v61)

						local v63 = false

						if typeof(newcclosure) == "function" then
							v63 = newcclosure
						end

						v58("newcclosure", v63)

						local v65 = false

						if typeof(clonefunction) == "function" then
							v65 = clonefunction
						end

						v58("clonefunction", v65)
					end

					do
						local v67 = false

						if typeof(replaceclosure) == "function" then
							v67 = replaceclosure
						end

						v58("replaceclosure", v67)
						v58("getrawmetatable", getrawmetatable)

						local v69 = false

						if typeof(setrawmetatable) == "function" then
							v69 = setrawmetatable
						end

						v58("setrawmetatable", v69)

						local v71 = false

						if typeof(setreadonly) == "function" then
							v71 = setreadonly
						end

						v58("setreadonly", v71)

						local v73 = false

						if typeof(isreadonly) == "function" then
							v73 = isreadonly
						end

						v58("isreadonly", v73)
					end

					do
						local v75 = false

						if typeof(makewriteable) == "function" then
							v75 = makewriteable
						end

						v58("makewriteable", v75)

						local v77 = false

						if typeof(makereadonly) == "function" then
							v77 = makereadonly
						end

						v58("makereadonly", v77)

						local v79 = false

						if typeof(checkcaller) == "function" then
							v79 = checkcaller
						end

						v58("checkcaller", v79)

						local v81 = false

						if typeof(iscclosure) == "function" then
							v81 = iscclosure
						end

						v58("iscclosure", v81)
					end

					do
						local v83 = false

						if typeof(islclosure) == "function" then
							v83 = islclosure
						end

						v58("islclosure", v83)

						local v85 = false

						if typeof(isexecutorclosure) == "function" then
							v85 = isexecutorclosure
						end

						v58("isexecutorclosure", v85)

						local v87 = false

						if typeof(cloneref) == "function" then
							v87 = cloneref
						end

						v58("cloneref", v87)

						local v89 = false

						if typeof(compareinstances) == "function" then
							v89 = compareinstances
						end

						v58("compareinstances", v89)
						v58("pcall", pcall)
						v58("require", require)
						v58("typeof", typeof)
						v58("type", type)

						local v91 = false

						if typeof(loadstring) == "function" then
							v91 = loadstring
						end

						v58("loadstring", v91)
					end

					do
						local v93 = false

						if typeof(decompile) == "function" then
							v93 = decompile
						end

						v58("decompile", v93)

						local v95 = false

						if typeof(disassemble) == "function" then
							v95 = disassemble
						end

						v58("disassemble", v95)

						local v97 = false

						if typeof(getscriptbytecode) == "function" then
							v97 = getscriptbytecode
						end

						v58("getscriptbytecode", v97)

						local v99 = false

						if typeof(getscriptclosure) == "function" then
							v99 = getscriptclosure
						end

						v58("getscriptclosure", v99)

						local v101 = false

						if typeof(getscripthash) == "function" then
							v101 = getscripthash
						end

						v58("getscripthash", v101)
					end

					do
						local v103 = false

						if typeof(saveinstance) == "function" then
							v103 = saveinstance
						end

						v58("saveinstance", v103)

						local v105 = false

						if typeof(getgenv) == "function" then
							v105 = getgenv
						end

						v58("getgenv", v105)

						local v107 = false

						if typeof(getrenv) == "function" then
							v107 = getrenv
						end

						v58("getrenv", v107)

						local v109 = false

						if typeof(getreg) == "function" then
							v109 = getreg
						end

						v58("getreg", v109)

						local v111 = false

						if typeof(getsenv) == "function" then
							v111 = getsenv
						end

						v58("getsenv", v111)
					end

					do
						local v113 = false

						if typeof(getmenv) == "function" then
							v113 = getmenv
						end

						v58("getmenv", v113)

						local v115 = false

						if typeof(getconnections) == "function" then
							v115 = getconnections
						end

						v58("getconnections", v115)

						local v117 = false

						if typeof(getgc) == "function" then
							v117 = getgc
						end

						v58("getgc", v117)

						local v119 = false

						if typeof(setfenv) == "function" then
							v119 = setfenv
						end

						v58("setfenv", v119)

						local v121 = false

						if typeof(getfenv) == "function" then
							v121 = getfenv
						end

						v58("getfenv", v121)

						local v123 = false

						if typeof(getscripts) == "function" then
							v123 = getscripts
						end

						v58("getscripts", v123)
					end

					do
						local v125 = false

						if typeof(getrunningscripts) == "function" then
							v125 = getrunningscripts
						end

						v58("getrunningscripts", v125)

						local v127 = false

						if typeof(getloadedmodules) == "function" then
							v127 = getloadedmodules
						end

						v58("getloadedmodules", v127)

						local v129 = false

						if typeof(getinstances) == "function" then
							v129 = getinstances
						end

						v58("getinstances", v129)

						local v131 = false

						if typeof(getnilinstances) == "function" then
							v131 = getnilinstances
						end

						v58("getnilinstances", v131)

						local v133 = false

						if typeof(setthreadidentity) == "function" then
							v133 = setthreadidentity
						end

						v58("setthreadidentity", v133)

						local v135 = false

						if typeof(getthreadidentity) == "function" then
							v135 = getthreadidentity
						end

						v58("getthreadidentity", v135)
					end

					do
						local v137 = false

						if typeof(setidentity) == "function" then
							v137 = setidentity
						end

						v58("setidentity", v137)

						local v139 = false

						if typeof(getidentity) == "function" then
							v139 = getidentity
						end

						v58("getidentity", v139)

						local v141 = false

						if typeof(getnamecallmethod) == "function" then
							v141 = getnamecallmethod
						end

						v58("getnamecallmethod", v141)

						local v143 = false

						if typeof(setnamecallmethod) == "function" then
							v143 = setnamecallmethod
						end

						v58("setnamecallmethod", v143)

						local v145 = false

						if typeof(fireclickdetector) == "function" then
							v145 = fireclickdetector
						end

						v58("fireclickdetector", v145)

						local v147 = false

						if typeof(firesignal) == "function" then
							v147 = firesignal
						end

						v58("firesignal", v147)
					end

					do
						local v149 = false

						if typeof(firetouchinterest) == "function" then
							v149 = firetouchinterest
						end

						v58("firetouchinterest", v149)

						local v151 = false

						if typeof(fireproximityprompt) == "function" then
							v151 = fireproximityprompt
						end

						v58("fireproximityprompt", v151)

						local v153 = false

						if typeof(sethiddenproperty) == "function" then
							v153 = sethiddenproperty
						end

						v58("sethiddenproperty", v153)

						local v155 = false

						if typeof(gethiddenproperty) == "function" then
							v155 = gethiddenproperty
						end

						v58("gethiddenproperty", v155)

						local v157 = false

						if typeof(setscriptable) == "function" then
							v157 = setscriptable
						end

						v58("setscriptable", v157)

						local v159 = false
						local _request = request

						if typeof(request) == "function" then
							v159 = request
						end

						v58("request", v159)

						local v161 = false

						if typeof(http_request) == "function" then
							v161 = http_request
						end

						v58("http_request", v161)
					end

					do
						local v163 = false

						if typeof(setclipboard) == "function" then
							v163 = setclipboard
						end

						v58("setclipboard", v163)

						local v165 = false

						if typeof(writefile) == "function" then
							v165 = writefile
						end

						v58("writefile", v165)

						local v167 = false

						if typeof(readfile) == "function" then
							v167 = readfile
						end

						v58("readfile", v167)
						v58("debug.setupvalue", debug.setupvalue)

						local v169 = false
						local setconstant = debug.setconstant

						if typeof(setconstant) == "function" then
							v169 = debug.setconstant
						end

						v58("debug.setconstant", v169)

						local v171 = false
						local setmetatable2 = debug.setmetatable

						if typeof(setmetatable2) == "function" then
							v171 = debug.setmetatable
						end

						v58("debug.setmetatable", v171)

						local v173 = false
						local getregistry = debug.getregistry

						if typeof(getregistry) == "function" then
							v173 = debug.getregistry
						end

						v58("debug.getregistry", v173)

						local v175 = false
						local getinfo = debug.getinfo

						if typeof(getinfo) == "function" then
							v175 = debug.getinfo
						end

						v58("debug.getinfo", v175)
					end

					local v177 = false

					if typeof(identifyexecutor) == "function" then
						v177 = identifyexecutor
					end

					v58("identifyexecutor", v177)

					local v179 = false

					if typeof(getexecutorname) == "function" then
						v179 = getexecutorname
					end

					v58("getexecutorname", v179)
					u181 = nil
					u182 = nil
					u183 = nil

					local _xpcall = xpcall
					local u185 = info

					xpcall(function()
						return game.__
					end, function()
						u181 = u185(2, "f")
					end)
					local u187 = info

					xpcall(function()
						game.__ = 10
					end, function()
						u182 = u187(2, "f")
					end)
					local u189 = info

					xpcall(function()
						game:__()
					end, function()
						u183 = u189(2, "f")
					end)

					local u190 = _type
					local u191 = info
					local u192 = _pcall
					local u193 = getupvalue
					local u194 = getproto

					function v195(p5)
						if u190(p5) == "function" then
							if u191(p5, "s") == "[C]" then
								local n3 = 1

								while n3 <= 5 do
									local v491, v492 = u192(u193, p5, n3)

									if not v491 then
										break
									end

									if v492 ~= nil and u190(v492) == "function" then
										return true
									end

									n3 = n3 + 1
								end

								local v493, v494 = u192(u194, p5, 1)

								return v493 and v494 ~= nil
							end

							return false
						end

						return false
					end
				end

				HttpService = game:GetService("HttpService")
				t8 = {}

				do
					local t9 = {
						"HttpGet",
						"HttpGetAsync",
						"HttpPost",
						"HttpPostAsync",
						"GetObjects",
						"RequestAsync",
						"JSONEncode",
						"JSONDecode",
						"GenerateGUID",
						"UrlEncode",
					}

					for _, v in pairs(t9) do
						local v203, v204

						do
							local u201 = HttpService
							local u202 = v

							v203, v204 = _pcall(function()
								return u201[u202]
							end)
						end

						if v203 and v204 and _type(v204) == "function" then
							local v205 = info(v204, "s")
							local n4 = 0
							local n5 = 1

							while n5 <= 10 and _pcall(getupvalue, v204, n5) do
								n4 = n5
								n5 = n5 + 1
							end

							t8[#t8 + 1] = {
								v,
								v204,
								v205,
								n4,
							}
						end
					end

					u208 = nil
					u209 = nil

					local v210 = _getrawmetatable(game)

					if v210 then
						local v211 = _rawget(v210, "__namecall")

						if v211 then
							u208 = v211
							u209 = info(v211, "s")
						end
					end

					t10 = {
						"HttpSpy",
						"httpspy",
						"HTTPSpy",
						"http_spy",
						"HttpLogger",
						"httplogger",
						"HttpLog",
						"httplog",
						"spy_logs",
						"SpyLogs",
						"http_logs",
						"HttpLogs",
						"simplespy",
						"SimpleSpy",
						"SimpleSpySource",
					}
					t11 = {
						"pcall",
						"require",
						"type",
						"typeof",
						"getrawmetatable",
						"setreadonly",
					}
					t12 = {
						"__index",
						"__newindex",
						"__namecall",
					}
					u215 = nil
					u216 = nil
					u217 = nil
					u218 = nil
					u219 = nil

					function u220()
						return game.__
					end

					local u221 = info

					function u222()
						u217 = u221(2, "f")
					end
					function u223()
						game.__ = 10
					end

					local u224 = info

					function u225()
						u218 = u224(2, "f")
					end
					function u226()
						game:__()
					end

					local u227 = info

					function u228()
						u219 = u227(2, "f")
					end

					u229 = nil

					local u230 = _rawget

					function u231()
						local v497

						if u230(u229, "CodeGen") == nil then
							if u230(u229, "ReturnValue") == nil then
								v497 = false

								if u230(u229, "LogId") == nil then
									return false
								end
							end
						end

						v497 = u230(u229, "Url") ~= nil

						return v497
					end

					local u232 = _rawget

					function u233()
						local v500 = false

						if u232(u229, "selected") ~= nil then
							v500 = false

							if u232(u229, "logs") ~= nil then
								v500 = u232(u229, "autoblock") ~= nil
							end
						end

						return v500
					end

					u234 = _rawget
					n6 = 0
					n7 = 0

					local RunService = game:GetService("RunService")

					t13 = {}
					t14 = {
						true,
						true,
						true,
					}
					n8 = 3

					for i = 1, n8 do
						local Heartbeat = RunService.Heartbeat
						local u244 = t14
						local u245 = i

						t13[i] = Heartbeat:Connect(function()
							u244[u245] = true
						end)
					end

					local _ = "WG_CANARY_" .. tostring({}):sub(8)

					v247 = newproxy(true)

					local u248 = n8

					function u249()
						return u248
					end

					local u250 = v247

					function u251()
						return u250
					end

					local t15 = {}
					local v253, v254 = _pcall(getupvalue, v33, 1)

					if v253 then
						t15[#t15 + 1] = {
							v33,
							1,
							v254,
						}
					end
				end

				t16 = {
					verified = true,
					hwid = "WG_DECOY",
					expiry = 999999,
				}

				function u256()
					return true
				end

				local u257 = t16

				function u258()
					return u257.verified and u257.hwid == "WG_DECOY"
				end
				u262 = getfenv(0)

				mt = getmetatable(u262)
				_getfenv = getfenv
				_rawequal = rawequal
				u267 = _rawget(u262, "pcall")
				pcall2 = u262.pcall
				u269 = _rawget(u262, "type")
				type2 = u262.type
				u271 = nil

				local loadstring2 = u262.loadstring

				if loadstring2 and _type(loadstring2) == "function" then
					u271 = info(loadstring2, "s")
				end

				local u273 = t2

				function u274()
					local self = setmetatable({}, u273)

					self._baseline = {
						index = nil,
						newindex = nil,
						namecall = nil,
					}
					self._ref = {
						index = nil,
						newindex = nil,
						namecall = nil,
					}
					self._expected = {
						index = nil,
						newindex = nil,
						namecall = nil,
					}
					self._running = false

					return self
				end

				local u275 = v33

				function t2._onDetect(_, p7, p8)
					u275("MetaGuard", p7 .. " detected via " .. (p8 or "unknown"))
				end

				local u276 = _getrawmetatable
				local u277 = _rawget
				local u278 = info
				local u279 = _pcall
				local u280 = _tostring
				local u281 = getupvalue

				function t2._init(p9)
					local v514 = u276(game)

					p9._baseline.index = u277(v514, "__index")
					p9._baseline.newindex = u277(v514, "__newindex")
					p9._baseline.namecall = u277(v514, "__namecall")

					local _xpcall = xpcall
					local u516 = p9

					xpcall(function()
						return game.__
					end, function()
						u516._ref.index = u278(2, "f")
					end)
					local u518 = p9

					xpcall(function()
						game.__ = 10
					end, function()
						u518._ref.newindex = u278(2, "f")
					end)
					local u520 = p9

					xpcall(function()
						game:__()
					end, function()
						u520._ref.namecall = u278(2, "f")
					end)

					local _, v522 = u279(p9._ref.index, 123)
					local _, v524 = u279(p9._ref.newindex, 123)
					local _, v526 = u279(p9._ref.namecall, 123)

					p9._expected.index = u280(v522)
					p9._expected.newindex = u280(v524)
					p9._expected.namecall = u280(v526)

					local function v527(p10)
						if p10 ~= nil then
							if u278(p10, "s") == "[C]" then
								local v795, v796 = u279(u281, p10, 1)

								return v795 and v796 ~= nil
							end

							return true
						end

						return false
					end

					if v527(p9._baseline.index) then
						p9:_onDetect("__index", "getrawmetatable")
					end

					if v527(p9._baseline.newindex) then
						p9:_onDetect("__newindex", "getrawmetatable")
					end

					if v527(p9._baseline.namecall) then
						p9:_onDetect("__namecall", "getrawmetatable")
					end

					return p9
				end

				u282 = getconstant
				u283 = getupvalue
				u284 = getproto
			end

			local u285 = info
			local u286 = v33
			local u287 = _getrawmetatable
			local u288 = _rawget
			local u289 = _pcall
			local u290 = clock

			local function u291()
				return getfenv(0)[u215]
			end

			local u292 = t7
			local u293 = t12
			local u294 = v195
			local u295 = t11
			local u296 = HttpService
			local u297 = t8

			local function u298()
				return u216[u215]
			end

			local u299 = _type
			local u300 = t10

			local function u301()
				return getgenv and getgenv()
			end

			local u302 = _tostring
			local u303 = t14

			local function u304()
				return 3735928559
			end

			local u305 = n8
			local u306 = v247
			local u307 = t16
			local u308 = wait

			local function u309()
				local v504 = false

				if u234(u229, "OnRequest") ~= nil then
					v504 = true

					if u234(u229, "Enabled") == nil then
						v504 = u234(u229, "Requests") ~= nil
					end
				end

				return v504
			end

			local u310 = find

			function u311(p11)
				local n9 = 0
				local spawn = task.spawn
				local u531 = p11

				spawn(function()
					local n10 = 0
					local g826 = nil
					local g842 = nil
					local g856 = nil
					local g870 = nil
					local g878 = nil
					local g884 = nil
					local g892 = nil
					local g900 = nil
					local g907 = nil
					local g915 = nil

					while true do
						task.wait()

						if u31 then
							break
						end

						n10 = n10 + 1

						if debug.getconstant ~= u282 or debug.getupvalue ~= u283 or debug.getproto ~= u284 or debug.info ~= u285 then
							u286("AntiDecompile", "debug library tampered")

							return
						end

						if u531._running then
							local v798 = u287(game)
							local v799 = u288(v798, "__index")
							local v800 = u288(v798, "__newindex")
							local v801 = u288(v798, "__namecall")

							if v799 ~= u531._baseline.index then
								u531:_onDetect("__index", "getrawmetatable")
							end

							if v800 ~= u531._baseline.newindex then
								u531:_onDetect("__newindex", "getrawmetatable")
							end

							if v801 ~= u531._baseline.namecall then
								u531:_onDetect("__namecall", "getrawmetatable")
							end
						end

						if u49 then
							local v802, v803 = u289(u48)

							if v802 and v803 ~= u49 then
								u286("AntiHookfunction", "pcall caller fingerprint changed")

								return
							end
						end

						if not t13[1].Connected then
							u286("AntiGetconnections", "sentinel connection #" .. 1 .. " disconnected")

							return
						end

						if not t13[2].Connected then
							u286("AntiGetconnections", "sentinel connection #" .. 2 .. " disconnected")

							return
						end

						if not t13[3].Connected then
							u286("AntiGetconnections", "sentinel connection #" .. 3 .. " disconnected")

							return
						end

						local v804 = u290()
						local n11 = 0

						repeat
							local g806

							repeat
								repeat
									repeat
										repeat
											repeat
												repeat
													repeat
														repeat
															g806 = false

															while n11 < 18 and not (u290() - v804 > 0.001) do
																n11 = n11 + 1
																n9 = n9 % 18 + 1

																if n9 ~= 1 then
																	if n9 ~= 2 then
																		if n9 ~= 3 then
																			if n9 ~= 4 then
																				if n9 ~= 5 then
																					if n9 ~= 6 then
																						if n9 ~= 7 then
																							if n9 ~= 8 then
																								if n9 ~= 9 then
																									if n9 ~= 10 then
																										if n9 ~= 11 then
																											if n9 ~= 12 then
																												if n9 ~= 13 then
																													if n9 ~= 14 then
																														if n9 ~= 15 then
																															if n9 ~= 16 then
																																if n9 ~= 17 then
																																	if n9 == 18 then
																																		local v807 = getfenv(0)

																																		if
																																			getmetatable(v807)
																																			~= mt
																																		then
																																			u286(
																																				"AntiEnvProxy",
																																				"environment metatable changed (proxy detected)"
																																			)

																																			return
																																		end

																																		local v808 =
																																			u288(v807, "pcall")
																																		local pcall3 =
																																			v807.pcall

																																		if
																																			v808 ~= u267
																																			or pcall3
																																				~= pcall2
																																		then
																																			u286(
																																				"AntiEnvProxy",
																																				"env pcall access pattern changed"
																																			)

																																			return
																																		end

																																		local v810 =
																																			u288(v807, "type")
																																		local type3 = v807.type

																																		if
																																			v810 ~= u269
																																			or type3
																																				~= type2
																																		then
																																			u286(
																																				"AntiEnvProxy",
																																				"env type access pattern changed"
																																			)

																																			return
																																		end

																																		if
																																			getfenv ~= _getfenv
																																		then
																																			u286(
																																				"AntiEnvProxy",
																																				"getfenv function replaced"
																																			)

																																			return
																																		end

																																		if
																																			not _rawequal(
																																				v807,
																																				u262
																																			)
																																		then
																																			u286(
																																				"AntiEnvProxy",
																																				"environment table swapped (setfenv attack)"
																																			)

																																			return
																																		end

																																		local loadstring3 =
																																			v807.loadstring

																																		if
																																			loadstring3
																																			and u299(
																																				loadstring3
																																			) == "function"
																																			and u271
																																			and u285(
																																					loadstring3,
																																					"s"
																																				)
																																				~= u271
																																		then
																																			u286(
																																				"AntiEnvProxy",
																																				"loadstring source changed"
																																			)

																																			return
																																		end
																																	end
																																else
																																	if
																																		u307.verified
																																			~= true
																																		or u307.hwid ~= "WG_DECOY"
																																		or u307.expiry
																																			~= 999999
																																	then
																																		u286(
																																			"AntiGcAbuse",
																																			"decoy table modified (getgc attack)"
																																		)

																																		return
																																	end

																																	if not u256() then
																																		u286(
																																			"AntiGcAbuse",
																																			"decoy verify function tampered"
																																		)

																																		return
																																	end

																																	if not u258() then
																																		u286(
																																			"AntiGcAbuse",
																																			"decoy HWID function tampered"
																																		)

																																		return
																																	end
																																end
																															else
																																if u304() ~= 3735928559 then
																																	u286(
																																		"AntiUpvalueTamper",
																																		"canary1 value modified"
																																	)

																																	return
																																end

																																if u249() ~= u305 then
																																	u286(
																																		"AntiUpvalueTamper",
																																		"canary2 value modified"
																																	)

																																	return
																																end

																																if u251() ~= u306 then
																																	u286(
																																		"AntiUpvalueTamper",
																																		"canary3 userdata replaced"
																																	)

																																	return
																																end

																																local setupvalue =
																																	debug.setupvalue

																																if
																																	setupvalue
																																	and u285(
																																			setupvalue,
																																			"s"
																																		)
																																		~= "[C]"
																																then
																																	u286(
																																		"AntiUpvalueTamper",
																																		"debug.setupvalue is not C closure"
																																	)

																																	return
																																end

																																local setconstant =
																																	debug.setconstant

																																if
																																	setconstant
																																	and u299(setconstant) == "function"
																																	and u285(
																																			setconstant,
																																			"s"
																																		)
																																		~= "[C]"
																																then
																																	u286(
																																		"AntiUpvalueTamper",
																																		"debug.setconstant is not C closure"
																																	)

																																	return
																																end
																															end
																														else
																															local getconnections2 =
																																getfenv(0).getconnections

																															if
																																getconnections2
																																and u299(getconnections2) == "function"
																																and u294(getconnections2)
																															then
																																u286(
																																	"AntiGetconnections",
																																	"getconnections is fake C closure"
																																)

																																return
																															end

																															if n10 > 180 then
																																if not u303[1] then
																																	u286(
																																		"AntiGetconnections",
																																		"sentinel #"
																																			.. 1
																																			.. " stopped firing"
																																	)

																																	return
																																end

																																u303[1] = false

																																if not u303[2] then
																																	u286(
																																		"AntiGetconnections",
																																		"sentinel #"
																																			.. 2
																																			.. " stopped firing"
																																	)

																																	return
																																end

																																u303[2] = false

																																if not u303[3] then
																																	u286(
																																		"AntiGetconnections",
																																		"sentinel #"
																																			.. 3
																																			.. " stopped firing"
																																	)

																																	return
																																end

																																u303[3] = false
																															end
																														end
																													else
																														local v817 = getfenv(0)

																														for _ = 1, 3 do
																															if #u292 == 0 then
																																break
																															end

																															n6 = n6 + 1

																															if n6 > #u292 then
																																n6 = 1
																															end

																															local v819 = u292[n6]
																															local v820 = v817[v819[1]]

																															if
																																v820 ~= nil
																																and v820 == v819[2]
																															then
																																local n12 = 0
																																local n13 = 1

																																while
																																	n13 <= 30
																																	and u289(u283, v820, n13)
																																do
																																	n12 = n13
																																	n13 = n13 + 1
																																end

																																if n12 ~= v819[4] then
																																	u286(
																																		"AntiHookfunction",
																																		v819[1]
																																			.. " upvalue count changed"
																																	)

																																	return
																																end
																															end
																														end

																														u216 = u296

																														local n14 = 1
																														local n15 = 1
																														local n16 = 1

																														repeat
																															if not g826 and not (n16 > 0) then
																																if n15 <= n14 then
																																	g826 = true
																																end
																															elseif g826 or n14 <= n15 then
																																g826 = false

																																while #u297 ~= 0 do
																																	n7 = n7 + 1

																																	if n7 > #u297 then
																																		n7 = 1
																																	end

																																	local v827 = u297[n7]

																																	u215 = v827[1]

																																	local v828, v829 =
																																		u289(u298)

																																	if
																																		v828
																																		and v829
																																		and u299(v829)
																																			== "function"
																																	then
																																		local n17 = 0
																																		local n18 = 1

																																		while
																																			n18 <= 10
																																			and u289(
																																				u283,
																																				v829,
																																				n18
																																			)
																																		do
																																			n17 = n18
																																			n18 = n18 + 1
																																		end

																																		if n17 ~= v827[4] then
																																			u286(
																																				"AntiHttpSpy",
																																				v827[1]
																																					.. " upvalue count changed"
																																			)

																																			return
																																		end
																																	end

																																	n14 = n14 + n16

																																	if not (n16 > 0) then
																																		if not (n15 <= n14) then
																																			break
																																		end
																																	elseif not (n14 <= n15) then
																																		break
																																	end
																																end
																															end
																														until not g826
																													end
																												elseif u531._running then
																													local _, v833 = u289(u531._ref.index, 123)

																													if u302(v833) ~= u531._expected.index then
																														u531:_onDetect(
																															"__index",
																															"hookmetamethod"
																														)
																													end

																													local _, v835 =
																														u289(u531._ref.newindex, 123)

																													if
																														u302(v835) ~= u531._expected.newindex
																													then
																														u531:_onDetect(
																															"__newindex",
																															"hookmetamethod"
																														)
																													end

																													local _, v837 =
																														u289(u531._ref.namecall, 123)

																													if
																														u302(v837) ~= u531._expected.namecall
																													then
																														u531:_onDetect(
																															"__namecall",
																															"hookmetamethod"
																														)
																													end
																												end
																											elseif u531._running then
																												local v838 = u287(game)
																												local n19 = 1
																												local n20 = 3
																												local n21 = 1

																												repeat
																													if not g842 and not (n21 > 0) then
																														if n20 <= n19 then
																															g842 = true
																														end
																													elseif g842 or n19 <= n20 then
																														g842 = false

																														repeat
																															while true do
																																local v843 = u293[n19]
																																local v844 = u288(v838, v843)

																																if v844 ~= nil then
																																	if
																																		u285(v844, "s") ~= "[C]"
																																	then
																																		u531:_onDetect(
																																			u293[n19],
																																			"non-C handler"
																																		)
																																	end

																																	local v845, v846 =
																																		u289(u283, v844, 1)

																																	if v845 and v846 ~= nil then
																																		u531:_onDetect(
																																			u293[n19],
																																			"handler has upvalue"
																																		)
																																	end
																																end

																																n19 = n19 + n21

																																if n21 > 0 then
																																	break
																																end

																																if not (n20 <= n19) then
																																	g806 = true
																																end

																																if g806 then
																																	break
																																end
																															end

																															if g806 then
																																break
																															end
																														until not (n19 <= n20)
																													end

																													if g806 then
																														break
																													end
																												until not g842
																											end
																										else
																											local v847 = getfenv(0)

																											for i = 1, #u300 do
																												local v850 = u300[i]

																												if u288(v847, v850) ~= nil then
																													u286(
																														"AntiHttpSpy",
																														"suspicious global: " .. u300[i]
																													)

																													return
																												end
																											end

																											local v851, v852 = u289(u301)

																											if v851 and v852 and u299(v852) == "table" then
																												local n22 = 1
																												local v854 = #u300
																												local n23 = 1

																												repeat
																													if not g856 and not (n23 > 0) then
																														if v854 <= n22 then
																															g856 = true
																														end
																													elseif g856 or n22 <= v854 then
																														g856 = false

																														repeat
																															while true do
																																local v857, v858 =
																																	u289(u288, v852, u300[n22])

																																if v857 and v858 ~= nil then
																																	u286(
																																		"AntiHttpSpy",
																																		"getgenv global: "
																																			.. u300[n22]
																																	)

																																	return
																																end

																																n22 = n22 + n23

																																if n23 > 0 then
																																	break
																																end

																																if not (v854 <= n22) then
																																	g806 = true
																																end

																																if g806 then
																																	break
																																end
																															end

																															if g806 then
																																break
																															end
																														until not (n22 <= v854)
																													end
																												until not g856
																											end
																										end
																									else
																										u216 = u296

																										local v859 = #u297 / 2

																										for i = math.ceil(v859) + 1, #u297 do
																											local v861 = u297[i]

																											u215 = v861[1]

																											local v862, v863 = u289(u298)

																											if v862 and v863 and u299(v863) == "function" then
																												if u285(v863, "s") ~= v861[3] then
																													u286(
																														"AntiHttpSpy",
																														v861[1] .. " source changed"
																													)

																													return
																												end

																												if u294(v863) then
																													u286(
																														"AntiHttpSpy",
																														v861[1] .. " fake C detected"
																													)

																													return
																												end
																											end
																										end

																										if u208 then
																											local v864 = u287(game)

																											if v864 then
																												local v865 = u288(v864, "__namecall")

																												if v865 and v865 ~= u208 then
																													u286(
																														"AntiHttpSpy",
																														"__namecall handler changed"
																													)

																													return
																												end
																											end
																										end
																									end
																								else
																									u216 = u296

																									local v866 = #u297 / 2
																									local n24 = 1
																									local v868 = math.ceil(v866)
																									local n25 = 1

																									repeat
																										if not g870 and not (n25 > 0) then
																											if v868 <= n24 then
																												g870 = true
																											end
																										elseif g870 or n24 <= v868 then
																											g870 = false

																											repeat
																												while true do
																													local v871 = u297[n24]

																													u215 = v871[1]

																													local v872, v873 = u289(u298)

																													if
																														v872
																														and v873
																														and u299(v873) == "function"
																													then
																														if u285(v873, "s") ~= v871[3] then
																															u286(
																																"AntiHttpSpy",
																																v871[1] .. " source changed"
																															)

																															return
																														end

																														if u294(v873) then
																															u286(
																																"AntiHttpSpy",
																																v871[1] .. " fake C detected"
																															)

																															return
																														end
																													end

																													n24 = n24 + n25

																													if n25 > 0 then
																														break
																													end

																													if not (v868 <= n24) then
																														g806 = true
																													end

																													if g806 then
																														break
																													end
																												end

																												if g806 then
																													break
																												end
																											until not (n24 <= v868)
																										end
																									until not g870
																								end
																							else
																								local v874 = getfenv(0)
																								local n26 = 1
																								local v876 = #u295
																								local n27 = 1

																								repeat
																									if not g878 and not (n27 > 0) then
																										if v876 <= n26 then
																											g878 = true
																										end
																									elseif g878 or n26 <= v876 then
																										g878 = false

																										repeat
																											while true do
																												local v879 = v874[u295[n26]]

																												if v879 and u294(v879) then
																													u286(
																														"AntiNewcclosure",
																														u295[n26] .. " fake C"
																													)

																													return
																												end

																												n26 = n26 + n27

																												if n27 > 0 then
																													break
																												end

																												if not (v876 <= n26) then
																													g806 = true
																												end

																												if g806 then
																													break
																												end
																											end

																											if g806 then
																												break
																											end
																										until not (n26 <= v876)
																									end
																								until not g878
																							end
																						else
																							local v880 = u287(game)

																							if v880 then
																								local n28 = 1
																								local n29 = 3
																								local n30 = 1

																								repeat
																									if not g884 and not (n30 > 0) then
																										if n29 <= n28 then
																											g884 = true
																										end
																									elseif g884 or n28 <= n29 then
																										g884 = false

																										repeat
																											while true do
																												local v885 = u293[n28]
																												local v886 = u288(v880, v885)

																												if u294(v886) then
																													u286(
																														"AntiNewcclosure",
																														u293[n28] .. " fake C"
																													)

																													return
																												end

																												n28 = n28 + n30

																												if n30 > 0 then
																													break
																												end

																												if not (n29 <= n28) then
																													g806 = true
																												end

																												if g806 then
																													break
																												end
																											end

																											if g806 then
																												break
																											end
																										until not (n28 <= n29)
																									end
																								until not g884
																							end
																						end
																					else
																						u217 = nil
																						u218 = nil
																						u219 = nil
																						xpcall(u220, u222)
																						xpcall(u223, u225)
																						xpcall(u226, u228)

																						if u181 and nil ~= u181 then
																							u286("AntiNewcclosure", "__index caller FP changed")

																							return
																						end

																						if u182 and u218 ~= u182 then
																							u286("AntiNewcclosure", "__newindex caller FP changed")

																							return
																						end

																						if u183 and u219 ~= u183 then
																							u286("AntiNewcclosure", "__namecall caller FP changed")

																							return
																						end
																					end
																				else
																					local v887 = getfenv(0)
																					local v888 = #u292 / 2
																					local v889 = math.ceil(v888) + 1
																					local v890 = #u292
																					local n31 = 1

																					repeat
																						if not g892 and not (n31 > 0) then
																							if v890 <= v889 then
																								g892 = true
																							end
																						elseif g892 or v889 <= v890 then
																							g892 = false

																							repeat
																								while true do
																									local v893 = u292[v889]
																									local v894 = v887[v893[1]]

																									if v894 ~= nil then
																										if v894 ~= v893[2] then
																											u286("AntiHookfunction", v893[1] .. " ref swapped")

																											return
																										end

																										if u285(v894, "s") ~= v893[3] then
																											u286(
																												"AntiHookfunction",
																												v893[1] .. " source changed"
																											)

																											return
																										end
																									end

																									v889 = v889 + n31

																									if n31 > 0 then
																										break
																									end

																									if not (v890 <= v889) then
																										g806 = true
																									end

																									if g806 then
																										break
																									end
																								end

																								if g806 then
																									break
																								end
																							until not (v889 <= v890)
																						end
																					until not g892
																				end
																			else
																				local v895 = getfenv(0)
																				local v896 = #u292 / 2
																				local n32 = 1
																				local v898 = math.ceil(v896)
																				local n33 = 1

																				repeat
																					if not g900 and not (n33 > 0) then
																						if v898 <= n32 then
																							g900 = true
																						end
																					elseif g900 or n32 <= v898 then
																						g900 = false

																						repeat
																							while true do
																								local v901 = u292[n32]
																								local v902 = v895[v901[1]]

																								if v902 ~= nil then
																									if v902 ~= v901[2] then
																										u286("AntiHookfunction", v901[1] .. " ref swapped")

																										return
																									end

																									if u285(v902, "s") ~= v901[3] then
																										u286("AntiHookfunction", v901[1] .. " source changed")

																										return
																									end
																								end

																								n32 = n32 + n33

																								if n33 > 0 then
																									break
																								end

																								if not (v898 <= n32) then
																									g806 = true
																								end

																								if g806 then
																									break
																								end
																							end

																							if g806 then
																								break
																							end
																						until not (n32 <= v898)
																					end
																				until not g900
																			end
																		else
																			if task.wait ~= t5[1] or task.spawn ~= t5[2] or task.defer ~= t5[3] then
																				u286("MemoryTamper", "task library tampered")

																				return
																			end

																			if string.format ~= t6[1] or string.len ~= t6[2] then
																				u286("MemoryTamper", "string library tampered")

																				return
																			end
																		end
																	else
																		local v903 = #t3 / 2
																		local v904 = math.ceil(v903) + 1
																		local v905 = #t3
																		local n34 = 1

																		repeat
																			if not g907 and not (n34 > 0) then
																				if v905 <= v904 then
																					g907 = true
																				end
																			elseif g907 or v904 <= v905 then
																				g907 = false

																				repeat
																					while true do
																						local v908 = t3[v904]

																						u215 = v908[1]

																						local v909, v910 = u289(u291)

																						if v909 and v910 ~= v908[2] then
																							u286("MemoryTamper", "global." .. v908[1] .. " tampered")

																							return
																						end

																						v904 = v904 + n34

																						if n34 > 0 then
																							break
																						end

																						if not (v905 <= v904) then
																							g806 = true
																						end

																						if g806 then
																							break
																						end
																					end

																					if g806 then
																						break
																					end
																				until not (v904 <= v905)
																			end
																		until not g907
																	end
																else
																	local v911 = #t3 / 2
																	local n35 = 1
																	local v913 = math.ceil(v911)
																	local n36 = 1

																	repeat
																		if not g915 and not (n36 > 0) then
																			if v913 <= n35 then
																				g915 = true
																			end
																		elseif g915 or n35 <= v913 then
																			g915 = false

																			repeat
																				while true do
																					local v916 = t3[n35]

																					u215 = v916[1]

																					local v917, v918 = u289(u291)

																					if v917 and v918 ~= v916[2] then
																						u286("MemoryTamper", "global." .. v916[1] .. " tampered")

																						return
																					end

																					n35 = n35 + n36

																					if n36 > 0 then
																						break
																					end

																					if not (v913 <= n35) then
																						g806 = true
																					end

																					if g806 then
																						break
																					end
																				end

																				if g806 then
																					break
																				end
																			until not (n35 <= v913)
																		end
																	until not g915
																end

																if g806 then
																	break
																end

																if g806 then
																	break
																end

																if g806 then
																	break
																end

																if g806 then
																	break
																end

																if g806 then
																	break
																end

																if g806 then
																	break
																end

																if g806 then
																	break
																end

																if g806 then
																	break
																end

																if g806 then
																	break
																end
															end
														until not g806
													until not g806
												until not g806
											until not g806
										until not g806
									until not g806
								until not g806
							until not g806
						until not g806
					end
				end)
				task.spawn(function()
					while true do
						u308(8)

						if u31 then
							break
						end

						local v919, v920 = u289(function()
							return getgc and getgc(true)
						end)

						if v919 and v920 then
							local v921 = #v920
							local n37 = 1

							while n37 <= v921 do
								if u31 then
									return
								end

								local v923 = n37 + 80 - 1

								if v921 < v923 then
									v923 = v921
								end

								for i = n37, v923 do
									local v925 = v920[i]

									if u299(v925) ~= "table" then
										if u299(v925) == "function" then
											local v926, v927 = u289(u285, v925, "s")

											if v926 and v927 and u299(v927) == "string" then
												local v928, v929 = u289(u310, v927, "HttpSpy")

												if v928 and v929 then
													u286("AntiHttpSpy", "HTTPSpy closure in GC")

													return
												end

												local v930, v931 = u289(u310, v927, "SimpleSpy")

												if v930 and v931 then
													u286("AntiHttpSpy", "SimpleSpy closure in GC")

													return
												end
											end
										end
									else
										u229 = v925

										local v932, v933 = u289(u231)

										if v932 and v933 then
											u286("AntiHttpSpy", "spy log in GC")

											return
										end

										local v934, v935 = u289(u233)

										if v934 and v935 then
											u286("AntiHttpSpy", "SimpleSpy in GC")

											return
										end

										local v936, v937 = u289(u309)

										if v936 and v937 then
											u286("AntiHttpSpy", "HttpSpy in GC")

											return
										end
									end
								end

								n37 = v923 + 1

								if n37 <= v921 then
									task.wait()
								end
							end
						end
					end
				end)
			end
		end

		t18 = {}
		t19 = {}

		local v314 = _tostring({})
		local v315 = v2(tick())
		local _ = v314 .. _tostring(unpack(v315, 1, v315.n))
		local v331 = v2(newproxy())

		v345 = _tostring(unpack(v331, 1, v331.n))
		v346 = v2(math.random(100000, 999999))
	end

	local v361 = v345 .. _tostring(unpack(v346, 1, v346.n))

	for i = 1, #v1 do
		t18[i] = byte(v1, i)
	end

	for i = 1, #v361 do
		t19[i] = byte(v361, i)
	end
	local u366 = byte(v1, 1) + byte(v361, 1)
	local u367 = newproxy(true)
	local u368 = info(HttpGet, "s")

	local u369 = t18
	local u370 = v20
	local u371 = byte
	local u372 = t19
	local u373 = char
	local u374 = concat

	function u375(p12)
		local function v533(...)
			local t20 = { ... }

			t20.n = select("#", ...)

			return t20
		end

		local t21 = {}
		local v535 = #u369

		for i = 1, #p12 do
			t21[i] = u370(u371(p12, i), u369[(i - 1) % v535 + 1])
		end

		local t22 = {}

		for i = 1, #t21 do
			t22[i] = (t21[i] + u366 + i) % 256
		end

		local t23 = {}
		local v542 = #u372

		for i = 1, #t22 do
			local v545 = v533(u370(t22[i], u372[(i - 1) % v542 + 1]))

			t23[i] = u373(unpack(v545, 1, v545.n))
		end

		local v553 = v533(u374(t23))

		return unpack(v553, 1, v553.n)
	end

	local u376 = t19
	local u377 = v20
	local u378 = byte
	local u379 = t18
	local u380 = char
	local u381 = concat

	function u382(p13)
		local function v555(...)
			local t24 = { ... }

			t24.n = select("#", ...)

			return t24
		end

		local v556 = #u376
		local t25 = {}

		for i = 1, #p13 do
			t25[i] = u377(u378(p13, i), u376[(i - 1) % v556 + 1])
		end

		local t26 = {}

		for i = 1, #t25 do
			t26[i] = (t25[i] - u366 - i) % 256
		end

		local t27 = {}
		local v564 = #u379

		for i = 1, #t26 do
			local v567 = v555(u377(t26[i], v564 > 0 and u379[(i - 1) % v564 + 1] or 0))

			t27[i] = u380(unpack(v567, 1, v567.n))
		end

		local v575 = v555(u381(t27))

		return unpack(v575, 1, v575.n)
	end

	local u383 = v33
	local u384 = info
	local u385 = HttpGet
	local u386 = v195

	function u387()
		if u367 ~= nil then
			if u384(u385, "s") == u368 then
				if not u386(u385) then
					return true
				end

				u383("LinkProtect", "httpGet is fake C closure")

				return false
			end

			u383("LinkProtect", "httpGet source changed")

			return false
		end

		u383("LinkProtect", "httpGet canary destroyed")

		return false
	end

	local u388 = _getrawmetatable
	local u389 = _rawget
	local u390 = v33
	local u391 = info
	local u392 = v195
	local u393 = t8
	local u394 = _pcall
	local u395 = HttpService
	local u396 = _type
	local u397 = t10
	local u398 = _loadstring

	function v399()
		if not u31 then
			if u387() then
				local v576 = u388(game)

				if v576 then
					local v577 = u389(v576, "__namecall")

					if v577 then
						if u208 and v577 ~= u208 then
							u390("LinkProtect", "__namecall replaced")

							return false
						end

						if u209 and u391(v577, "s") ~= u209 then
							u390("LinkProtect", "__namecall source changed")

							return false
						end

						if u392(v577) then
							u390("LinkProtect", "__namecall fake C")

							return false
						end
					end

					local v578 = u389(v576, "__index")

					if v578 and u392(v578) then
						u390("LinkProtect", "__index fake C")

						return false
					end
				end

				for i = 1, #u393 do
					local v580 = u393[i]
					local u582 = v580
					local v583, v584 = u394(function()
						return u395[u582[1]]
					end)

					if v583 and v584 and u396(v584) == "function" then
						if u391(v584, "s") ~= v580[3] then
							u390("LinkProtect", v580[1] .. " source changed")

							return false
						end

						if u392(v584) then
							u390("LinkProtect", v580[1] .. " fake C detected")

							return false
						end
					end
				end

				local v585 = getfenv(0)

				for i = 1, #u397 do
					local v588 = u397[i]

					if u389(v585, v588) ~= nil then
						u390("LinkProtect", "spy active: " .. u397[i])

						return false
					end
				end

				local v589, v590 = u394(function()
					return getgenv and getgenv()
				end)

				if v589 and v590 and u396(v590) == "table" then
					for i = 1, #u397 do
						local v593, v594 = u394(u389, v590, u397[i])

						if v593 and v594 ~= nil then
							u390("LinkProtect", "getgenv spy: " .. u397[i])

							return false
						end
					end
				end

				if not u398 or not u271 or u391(u398, "s") == u271 then
					return true
				end

				u390("LinkProtect", "loadstring tampered")

				return false
			end

			return false
		end

		return false
	end

	local u400 = _type
	local u401 = _tostring
	local u402 = byte
	local u403 = char
	local u404 = format
	local u405 = concat

	function v406(p14)
		if u400(p14) ~= "string" then
			p14 = u401(p14)
		end

		local t28 = {}

		for i = 1, #p14 do
			local v598 = u402(p14, i)

			if
				(not (v598 >= 65) or not (v598 <= 90))
				and (not (v598 >= 97) or not (v598 <= 122))
				and ((not (v598 >= 48) or not (v598 <= 57)) and v598 ~= 45 and v598 ~= 46 and v598 ~= 95 and v598 ~= 126)
			then
				t28[#t28 + 1] = u404("%%%02X", v598)
			else
				t28[#t28 + 1] = u403(v598)
			end
		end

		return u405(t28)
	end

	local u407 = random
	local u408 = char
	local u409 = clock
	local u410 = _tostring
	local u411 = concat

	function v412()
		local function v599(...)
			local t29 = { ... }

			t29.n = select("#", ...)

			return t29
		end

		local t30 = {}

		for i = 1, 24 do
			local v603 = u407(65, 90) + (i % 2 == 0 and 32 or 0)

			t30[i] = u408(v603)
		end

		local v604 = v599(u409())

		t30[25] = u410(unpack(v604, 1, v604.n))

		local v612 = v599(u411(t30))

		return unpack(v612, 1, v612.n)
	end

	local u413 = _type
	local u414 = sub
	local u415 = gsub

	function v416(p15)
		if u413(p15) == "string" then
			local u614 = match(p15, "^%s*(.-)%s*$") or (p15 or false)

			if u414(u614, 1, 1) == "{" then
				local t31 = {}
				local v617 = #u614
				local n38 = 2
				local u619 = v617

				local function v620()
					while n38 <= u619 do
						local v944 = u414(u614, n38, n38)

						if v944 ~= " " and v944 ~= "\t" and v944 ~= "\n" and v944 ~= "\r" then
							return
						end

						n38 = n38 + 1
					end
				end

				local u621 = v617

				local function v622()
					if u414(u614, n38, n38) == '"' then
						n38 = n38 + 1

						local v948 = n38

						while n38 <= u621 do
							local v952 = u414(u614, n38, n38)

							if v952 ~= "\\" then
								if v952 == '"' then
									local v954 = n38 - 1
									local v955 = u414(u614, v948, v954)

									n38 = n38 + 1

									local v956 = u415(v955, "\\n", "\n")
									local v957 = u415(v956, "\\t", "\t")
									local v958 = u415(v957, '\\"', '"')

									return (u415(v958, "\\\\", "\\"))
								end

								n38 = n38 + 1
							else
								n38 = n38 + 2
							end
						end

						return nil
					end

					return nil
				end

				while v617 >= n38 do
					v620()

					if v617 < n38 then
						break
					end

					if u414(u614, n38, n38) == "}" then
						break
					end

					if u414(u614, n38, n38) == "," then
						n38 = n38 + 1
						v620()
					end

					if u414(u614, n38, n38) == "}" then
						break
					end

					local v632 = v622()

					if not v632 then
						break
					end

					v620()

					if u414(u614, n38, n38) ~= ":" then
						break
					end

					n38 = n38 + 1
					v620()

					if u414(u614, n38, n38) ~= '"' then
						local v639 = n38 + 3

						if u414(u614, n38, v639) ~= "true" then
							local v642 = n38 + 4

							if u414(u614, n38, v642) ~= "false" then
								local v645 = n38 + 3

								if u414(u614, n38, v645) ~= "null" then
									local v651 = match(u414(u614, n38), "^([%-]?%d+%.?%d*)")

									if not v651 then
										break
									end

									t31[v632] = tonumber(v651)
									n38 = n38 + #v651
								else
									n38 = n38 + 4
								end
							else
								t31[v632] = false
								n38 = n38 + 5
							end
						else
							t31[v632] = true
							n38 = n38 + 4
						end
					else
						t31[v632] = v622()
					end
				end

				if next(t31) then
					return t31
				end

				return nil
			end

			return nil
		end

		return nil
	end
end

local u417 = v29
local u418 = info
local u419 = v33
local u420 = v195

local function u421()
	if u417 then
		if u418(u417, "s") == u30 then
			if not u420(u417) then
				return true
			end

			u419("LinkProtect", "request is fake C")

			return false
		end

		u419("LinkProtect", "request source changed")

		return false
	end

	return false
end

function t2.protect(p16)
	if not u4 then
		u4 = u274()
		u35()
		u4:_init()
		u4._running = true
		u311(u4)
	end

	return p16
end

local u422 = v399
local u423 = _pcall
local u424 = HttpGet
local u425 = _tostring

function t2.secureGet(p17)
	if not u4 then
		error("[WareGuard] call protect() first")
	end

	if u422() then
		local v654, v655 = u423(u424, game, p17)

		if v654 then
			return v655
		end

		warn("[WareGuard] secureGet error: " .. u425(v655))

		return nil
	end

	return nil
end

local t32 = {}

for i = 1, 64 do
	t32[sub("ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz0123456789+/", i, i)] = i - 1
end
local u445 = t2
local u446 = _loadstring
local u447 = _tostring

function t2.secureLoad(p23)
	local v754 = u445.secureGet(p23)

	if v754 then
		local v755, v756 = u446(v754)

		if v755 then
			return v755()
		end

		warn("[WareGuard] compile error: " .. u447(v756))

		return nil
	end

	return nil
end

local u448 = format
local u449 = v20
local u450 = byte
local u451 = concat

local function v452(p24, p25, p26, p27)
	local v761 = nil
	local _ = p24 .. "|" .. p25 .. "|" .. p26
	local t35 = {}
	local v764 = #p27

	for i = 1, #v761 do
		local v769 = u450(v761, i)
		local v770 = (i - 1) % v764 + 1

		t35[i] = u448("%02x", u449(v769, u450(p27, v770)))
	end

	return u451(t35)
end

local u453 = v399
local u454 = v412
local u455 = v452
local u456 = v406
local u457 = _pcall
local u458 = HttpGet
local u459 = _type
local u460 = v416
local u461 = v33

function t2.secureValidateKey(p28)
	if not u4 then
		error("[WareGuard] call protect() first")
	end

	if u453() then
		local v772 = u454()
		local v773 = u455(v772, p28.hwid, p28.key, p28.apiKey)
		local v774 = p28.apiUrl
			.. "?action=validate_key"
			.. "&api_key="
			.. u456(p28.apiKey)
			.. "&key="
			.. u456(p28.key)
			.. "&hwid="
			.. u456(p28.hwid)
			.. "&nonce="
			.. u456(v772)
			.. "&mac="
			.. u456(v773)
		local v775, v776 = u457(u458, game, v774)

		if v775 and v776 and u459(v776) == "string" then
			local v777 = u460(v776)

			if v777 then
				if not v777.valid or v772 == v777.nonce then
					return v777
				end

				u461("LinkProtect", "Validation spoof detected (nonce mismatch)")

				return nil
			end

			warn("[WareGuard] secureValidateKey: invalid response")

			return nil
		end

		warn("[WareGuard] secureValidateKey: request failed")

		return nil
	end

	return nil
end

local u462 = v399
local u463 = v412
local u464 = v452
local u465 = v406
local u466 = _pcall
local u467 = v29
local u468 = v416
local u469 = v33

function t2.secureValidateKeyPOST(p29)
	if not u4 then
		error("[WareGuard] call protect() first")
	end

	if u462() then
		if u421() then
			local v779 = u463()
			local v780 = u464(v779, p29.hwid, p29.key, p29.apiKey)
			local v781 = "action=validate_key"
				.. "&api_key="
				.. u465(p29.apiKey)
				.. "&key="
				.. u465(p29.key)
				.. "&hwid="
				.. u465(p29.hwid)
				.. "&nonce="
				.. u465(v779)
				.. "&mac="
				.. u465(v780)
			local v782, v783 = u466(u467, {
				Url = p29.apiUrl,
				Method = "POST",
				Headers = {
					["Content-Type"] = "application/x-www-form-urlencoded",
				},
				Body = v781,
			})

			if v782 and v783 then
				local v784 = v783.Body or v783.body
				local v785 = u468(v784)

				if v785 then
					if not v785.valid or v779 == v785.nonce then
						return v785
					end

					u469("LinkProtect", "Validation spoof detected (nonce mismatch)")

					return nil
				end

				warn("[WareGuard] secureValidateKeyPOST: invalid response")

				return nil
			end

			warn("[WareGuard] secureValidateKeyPOST: request failed")

			return nil
		end

		return nil
	end

	return nil
end

local u470 = _tostring
local u471 = _type
local u472 = find
local u473 = v406
local u474 = t2

function t2.protectLinks(p30)
	local t36 = {}

	for k, v in pairs(p30) do
		t36[k] = {
			Ids = v.Ids,
			_blob = u375(v.Link),
			_loaded = false,
		}
		v.Link = nil
	end

	for k in pairs(p30) do
		p30[k] = nil
	end

	local t37 = {}
	local u792 = t36

	function t37.load(_, p32, p33)
		local v977 = u792[p32]

		if v977 then
			if not v977._loaded then
				local v978 = u382(v977._blob)

				if p33 and u471(p33) == "string" and #p33 > 0 then
					local _ = v978 .. (u472(v978, "?") and "&" or "?") .. "session=" .. u473(p33)
				end

				local v980 = u474.secureLoad(v978)

				if v980 ~= nil then
					v977._blob = nil
					v977._loaded = true
				end

				return v980
			end

			warn("[WareGuard] script already loaded (one-shot)")

			return nil
		end

		warn("[WareGuard] script not found: " .. u470(p32))

		return nil
	end

	local u793 = t36

	function t37.matchGame(_, p35)
		for k, v in pairs(u793) do
			for _, v3 in pairs(v.Ids) do
				if v3 == p35 then
					return k
				end
			end
		end

		return nil
	end
	function t37.autoLoad(p36, p37)
		local v989 = p36:matchGame(game.PlaceId)

		if v989 then
			return p36:load(v989, p37)
		end

		return nil
	end

	return t37
end

return t2
