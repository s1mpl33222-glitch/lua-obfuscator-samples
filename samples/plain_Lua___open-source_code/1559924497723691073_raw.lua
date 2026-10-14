local n25 = 3238
local n26 = 1420
local flag2 = true
local flag3 = true
do
do
do
do
do
do
do
do

								do
									local v87

									do
										if _G.oxy then
											return
										end
										_G.oxy = true

										cloneref = cloneref or function(arg)
											local v88 = 8192
											if true then
												return arg
											end

											while true do
											end
										end

										do
											local v88 = cloneref
											new = Instance.new
											tweenInfo = TweenInfo.new
											udim = UDim.new
											udim2 = UDim2.new
											udim22 = UDim2.fromOffset
											vector2 = Vector2.new
											vector = Vector3.new
											cframe = CFrame.new
											color = Color3.fromRGB
											format = string.format
											clamp = math.clamp
											floor2 = math.floor
											max = math.max
											min = math.min
											asin = math.asin
											rad = math.rad
											random2 = math.random
											bxor = bit32.bxor
											clear = table.clear
											concat = table.concat
											create = table.create
											find = table.find
											insert = table.insert
											byte = string.byte
											char2 = string.char
											spawn_ = task.spawn
											delay = task.delay
											defer = task.defer
											wait_ = task.wait
											v74 = pcall
											v75 = tostring
											v76 = type
											v77 = unpack
											v78 = tick
											genv = getgenv()
											v79 = v88(game:GetService("ReplicatedStorage"))
											v80 = v88(game:GetService("UserInputService"))
											v87 = v88(game:GetService("HttpService"))
											local v89 = v88(game:GetService("RunService"))
											v81 = v88(game:GetService("TweenService"))
											v82 = v88(game:GetService("Players"))
											v83 = v88(game:GetService("Debris"))
											local v90 = v88(game:GetService("Stats"))
											v84 = v88(game:GetService("Workspace"))
											create2 = v81.Create

											repeat
												wait_()
											until game:IsLoaded()

											localPlayer = v82.LocalPlayer
											name = localPlayer.Name
											currentCamera = v84.CurrentCamera

											v84:GetPropertyChangedSignal("CurrentCamera"):Connect(function()
												currentCamera = v84.CurrentCamera
											end)

											remotes = v79:WaitForChild("Remotes", 10)
											packages = v79.Packages
											controllers = v79.Controllers
											balls = v84.Balls
											alive = v84.Alive
											runtime = v84.Runtime
											dataPing = v90.Network.ServerStatsItem["Data Ping"]
											heartbeat = v89.Heartbeat
											preSimulation = v89.PreSimulation
											postSimulation = v89.PostSimulation
										end
									end

									tbl18 = {
										parry_connections = {},
										fire_sword_connections = {},
										play_parry = nil,
										sword_fn = nil,
									}

									if remotes and v76(getconnections) == "function" then
										do
											local parrySuccessAll = remotes:WaitForChild("ParrySuccessAll", 10)

											if parrySuccessAll then
												local v88, v89 = v74(getconnections, parrySuccessAll.OnClientEvent)

												if v88 and v76(v89) == "table" then
													for _, v90 in v89, nil, nil do
														do
															local v91, v92 = v74(function()
																return v90.Function
															end)

															if v91 and v76(v92) == "function" then
																insert(tbl18.parry_connections, v90)
																tbl18.play_parry = v92
															end
														end
													end
												end
											end
										end

										local v88 = remotes:WaitForChild("FireSwordInfo", 10)

										if v88 then
											local v89, v90 = v74(getconnections, v88.OnClientEvent)

											if v89 and v76(v90) == "table" then
												for _, v91 in v90, nil, nil do
													local v92, v93 = v74(function()
														return v91.Function
													end)

													if v92 and v76(v93) == "function" then
														insert(tbl18.fire_sword_connections, v91)
														tbl18.sword_fn = v93
													end
												end
											end
										end
									end

									tbl19 = { folder = "oxy" }
									tbl19.storage_ok = v76(readfile) == "function" and v76(writefile) == "function"
									tbl19.last_saved = {}
									tbl19.has_saved = false

									tbl19.defaults = {
										accuracy = 100,
										spam_threshold = 3,
										curve_keybind = false,
										manual_notify = false,
										curve_notify = false,
										curve_method = "camera",
										manual_spam = "E",
										mobile_triggerbot_button = false,
										mobile_manual_spam_button = false,
										ability_esp = false,
										auto_parry = false,
										ball_debug = false,
										auto_spam = false,
										random_target = false,
										unlock_all = false,
										last_equipped_sword = "",
										last_equipped_explosion = "",
										favorite_swords = {},
										favorite_explosions = {},
										deleted_swords = {},
										deleted_explosions = {},
										fflag_profile = "default",
										fflag_json = "",
										fflag_auto_load = false,
									}

									tbl19.path = tbl19.folder .. "/config.json"
									tbl19.fflag_folder = tbl19.folder .. "/fflags"

									tbl19.trim = function(arg)
										return v75(arg or ""):match("^%s*(.-)%s*$")
									end

									tbl19.ensure_folder = function()
										local v88 = "function"
										if v76(makefolder) ~= v88 then
											return
										end
										local v89 = "function"
										local flag14 = false

										if v76(isfolder) == v89 then
											local v90
											v90, flag14 = v74(isfolder, tbl19.folder)
											flag14 = v90 and flag14
										end

										if not flag14 then
											v74(makefolder, tbl19.folder)
										end
									end

									tbl19.ensure_fflag_folder = function()
										tbl19.ensure_folder()
										if v76(makefolder) ~= "function" then
											return
										end
										local v88 = "function"
										local flag14 = false

										if v76(isfolder) == v88 then
											local v89
											v89, flag14 = v74(isfolder, tbl19.fflag_folder)
											flag14 = v89 and flag14
										end

										if not flag14 then
											v74(makefolder, tbl19.fflag_folder)
										end
									end

									tbl19.copy = function(arg)
										local v88 = "table"
										if v76(arg) ~= v88 then
											return arg
										end
										local tbl23 = {}

										for k, v89 in arg, nil, nil do
											tbl23[k] = tbl19.copy(v89)
										end

										return tbl23
									end

									tbl19.equal = function(arg, arg2)
										if arg == arg2 then
											return true
										end
										local v88 = "table"
										if v76(arg) ~= v88 or v76(arg2) ~= "table" then
											return false
										end

										for k, v89 in arg, nil, nil do
											local v90 = "table"

											if v76(v89) == v90 then
												if not tbl19.equal(v89, arg2[k]) then
													return false
												end
												continue
											end

											if arg2[k] ~= v89 then
												return false
											end
										end

										for k in arg2, nil, nil do
											if arg[k] == nil then
												return false
											end
										end

										return true
									end

									tbl19.valid_key = function(arg)
										if v76(arg) ~= "string" then
											return false
										end

										local v88, v89 = v74(function()
											return Enum.KeyCode[arg]
										end)

										return v88 and v89 ~= nil
									end

									tbl20 = { "camera", "dot", "backwards", "slow", "random" }

									tbl19.normalize = function(arg)
										local tbl23 = {}

										for k, v88 in tbl19.defaults, nil, nil do
											local flag14 = v76(arg) == "table" and arg[k] or nil
											local v89 = "table"

											if v76(v88) == v89 then
												tbl23[k] = v76(flag14) == "table" and tbl19.copy(flag14) or tbl19.copy(v88)
											else
												tbl23[k] = v76(flag14) == v76(v88) and flag14 or v88
											end
										end

										tbl23.accuracy = clamp(floor2(tbl23.accuracy + 0.5), 1, 100)
										tbl23.spam_threshold = clamp(floor2(tbl23.spam_threshold + 0.5), 1, 3)

										if not find(tbl20, tbl23.curve_method) then
											tbl23.curve_method = tbl19.defaults.curve_method
										end

										if not tbl19.valid_key(tbl23.manual_spam) then
											tbl23.manual_spam = tbl19.defaults.manual_spam
										end

										tbl23.fflag_profile = tbl19.trim(tbl23.fflag_profile)

										if tbl23.fflag_profile == "" then
											tbl23.fflag_profile = tbl19.defaults.fflag_profile
										end

										return tbl23
									end

									do
										local data = nil

										if tbl19.storage_ok then
											tbl19.ensure_folder()

											v74(function()
												data = v87:JSONDecode(readfile(tbl19.path))
											end)
										end

										_G.config = tbl19.normalize(data)
									end

									config = _G.config

									tbl19.changed = function()
										if not tbl19.has_saved then
											return true
										end

										for k in tbl19.defaults, nil, nil do
											local v88 = tbl19.last_saved[k]
											local v89 = config[k]

											if v76(v88) == "table" or v76(v89) == "table" then
												if not tbl19.equal(v88, v89) then
													return true
												end
												continue
											end

											if v88 ~= v89 then
												return true
											end
										end

										return false
									end

									tbl19.save = function()
										if not (not tbl19.storage_ok or not tbl19.changed()) then
											local tbl23 = {}

											for k, v88 in tbl19.defaults, nil, nil do
												local v89 = config[k]

												if v76(v88) == "table" then
													tbl23[k] = v76(v89) == "table" and tbl19.copy(v89) or tbl19.copy(v88)
												else
													tbl23[k] = v76(v89) == v76(v88) and v89 or v88
												end
											end

											local v88, v89 = v74(function()
												return v87:JSONEncode(tbl23)
											end)

											if not v88 then
												return
											end
											tbl19.ensure_folder()
											if not v74(writefile, tbl19.path, v89) then
												return
											end

											for k in tbl19.defaults, nil, nil do
												local v90 = tbl23[k]
												tbl19.last_saved[k] = v76(v90) == "table" and tbl19.copy(v90) or v90
											end

											tbl19.has_saved = true
											return
										end

										if not (n25 <= 3227) then
											return
										end

										while true do
										end
									end

									tbl10 = {
										dropdown = nil,
										path = function(arg)
											local v88 = tbl19.trim(arg)
											if v88 == "" then
												return nil, "profile name is empty"
											end
											local str7 = v88:gsub("[<>:\"/\\|%?%*%c]", "_"):sub(1, 64)
											return tbl19.fflag_folder .. "/" .. str7 .. ".json", nil, str7
										end,
										decode = function(arg)
											if v76(arg) ~= "string" or tbl19.trim(arg) == "" then
												return nil, "fflags json is empty"
											end

											local v88, v89 = v74(function()
												return v87:JSONDecode(arg)
											end)

											if not v88 or v76(v89) ~= "table" then
												return nil, "invalid fflags json"
											end
											local tbl23 = {}
											local v90 = 0

											for k, v91 in v89, nil, nil do
												local v92 = "string"
												if v76(k) ~= v92 or tbl19.trim(k) == "" then
													return nil, "every fflag needs a valid string name"
												end
												local v93 = "string"
												if v76(v91) ~= v93 and v76(v91) ~= "number" and v76(v91) ~= "boolean" then
													return nil, "fflag values must be strings, numbers, or booleans"
												end
												tbl23[k] = v75(v91)
												v90 += 1
											end

											if v90 == 0 then
												return nil, "fflags json has no flags"
											end
											return tbl23, nil, v90
										end,
										apply = function(arg)
											if v76(setfflag) ~= "function" then
												return false, "setfflag is unavailable in this executor"
											end
											local v88, v89, v90 = tbl10.decode(arg)
											if not v88 then
												return false, v89
											end
											local tbl23 = {}

											for k, v91 in v88, nil, nil do
												if not v74(setfflag, k, v91) then
													insert(tbl23, k)
												end
											end

											if #tbl23 > 0 then
												table.sort(tbl23)
												return false, format("failed to apply %d/%d fflags: %s", #tbl23, v90, concat(tbl23, ", "))
											end
											return true, format("applied %d fflags", v90)
										end,
										save_profile = function(arg, arg2)
											if not tbl19.storage_ok then
												return false, "file storage is unavailable"
											end
											local v88, v89 = tbl10.decode(arg2)

											if not v88 then
												if true then
													return false, v89
												end

												while true do
												end
											end

											local v90, v91, v92 = tbl10.path(arg)
											if not v90 then
												return false, v91
											end

											local v93, v94 = v74(function()
												return v87:JSONEncode(v88)
											end)

											if not v93 then
												return false, "could not encode the fflags profile"
											end
											tbl19.ensure_fflag_folder()
											if not v74(writefile, v90, v94) then
												return false, "could not save the fflags profile"
											end
											return true, v94, v92
										end,
										load_profile = function(arg)
											if not tbl19.storage_ok then
												return false, "file storage is unavailable"
											end
											local v88, v89 = tbl10.path(arg)
											if not v88 then
												return false, v89
											end
											local v90, v91 = v74(readfile, v88)
											if not v90 or v76(v91) ~= "string" then
												return false, "fflags profile was not found"
											end
											local v92, v93 = tbl10.decode(v91)
											if not v92 then
												return false, v93
											end
											return true, v91
										end,
										list = function()
											local v88 = "function"
											if v76(listfiles) ~= v88 then
												return nil, "listfiles is unavailable in this executor"
											end
											tbl19.ensure_fflag_folder()
											local v89, v90 = v74(listfiles, tbl19.fflag_folder)
											if not v89 or v76(v90) ~= "table" then
												return nil, "could not list the fflags profiles"
											end
											local tbl23 = {}
											local tbl24 = {}

											for _, v91 in v90, nil, nil do
												local match = v75(v91):gsub("\\", "/"):match("([^/]+)%.json$")

												if match and not tbl24[match] then
													tbl24[match] = true
													insert(tbl23, match)
												end
											end

											table.sort(tbl23, function(arg, arg2)
												return arg:lower() < arg2:lower()
											end)

											return tbl23
										end,
										delete = function(arg)
											if v76(delfile) ~= "function" then
												return false, "delfile is unavailable in this executor"
											end
											local v88, v89 = tbl10.path(arg)
											if not v88 then
												return false, v89
											end

											if not v74(delfile, v88) then
												return false, "could not delete the fflags profile"
											end
											return true
										end,
									}
								end
							end

							tbl22 = nil

							if config.fflag_auto_load then
								local v87

								do
									local fflagJson = config.fflag_json
									local v88
									v88, v87 = tbl10.load_profile(config.fflag_profile)

									if v88 then
										config.fflag_json = v87
									else
										v87 = fflagJson
									end
								end

								local v88, v89 = tbl10.apply(v87)
								tbl22 = { ok = v88, message = v89 }
							end

							tbl19.save()

							spawn_(function()
								while _G.oxy do
									wait_(1)
									tbl19.save()
								end
							end)

							lib = loadstring(game:HttpGet("https://raw.githubusercontent.com/riqegopeek/NeverLose/refs/heads/main/src/interface.luau"))()
							lib:Theme("white")

							do
								local oxy = lib:AddWindow("oxy", "oxy")
								local combat = oxy:AddTab("combat", "rbxassetid://10734951847")
								local visual2 = oxy:AddTab("visual", "rbxassetid://10723346959")
								local misc2 = oxy:AddTab("misc", "rbxassetid://10709797985")
								v86 = oxy:AddTab("fflags", "rbxassetid://10723364435")
								v85 = combat:AddSection("parry", "left")
								curve = combat:AddSection("curve", "right")
								spam = combat:AddSection("spam", "left")
								hotkeys = combat:AddSection("hotkeys", "right")
								visual = visual2:AddSection("visual", "left")
								misc = misc2:AddSection("misc", "left")
							end
						end

						local profile, v87, v88, v89

						do
							do
								profile = v86:AddSection("profile", "left")
								v87 = v86:AddSection("fflags json", "right")

								do
									local v90 = lib:Notification()

									tbl21 = { notify = function(arg, arg2)
										v90:Notify("info", arg2.title, arg2.content, arg2.duration)
									end }
								end
							end

							fn26 = function(arg, arg2)
								local v90 = new(arg)

								for k, v91 in arg2, nil, nil do
									if k ~= "Parent" then
										v90[k] = v91
									end
								end

								v90.Parent = arg2.Parent
								return v90
							end

							do
								local function fn27(arg)
									for _, v90 in arg, nil, nil do
										if v76(v90) == "function" then
											local v91, v92 = v74(debug.getupvalues, v90)

											if v91 then
												for _, v93 in v92, nil, nil do
													if typeof(v93) == "Instance" and v93:IsA("Frame") and v93.Name == "Section" then
														return v93
													end
												end
											end
										end
									end

									return nil
								end

								local function fn28(arg, arg2, arg3, arg4, arg5, arg6)
									local v90 = fn27(arg)
									assert(v90, "could not resolve the section frame for an input")
									local n31 = arg5 and 142 or 52
									local n32 = arg5 and 120 or 30

									local Frame = fn26("Frame", {
										Name = "Input",
										BackgroundTransparency = 1,
										BorderSizePixel = 0,
										Size = udim2(0.9, 0, 0, n31),
										ZIndex = 5,
										Parent = v90,
									})

									fn26("TextLabel", {
										Name = "LabelText",
										BackgroundTransparency = 1,
										BorderSizePixel = 0,
										Size = udim2(1, 0, 0, 17),
										ZIndex = 6,
										Font = Enum.Font.SourceSansSemibold,
										Text = arg2,
										TextColor3 = color(255, 255, 255),
										TextSize = 14,
										TextTransparency = 0.3,
										TextXAlignment = Enum.TextXAlignment.Left,
										Parent = Frame,
									})

									local v91 = fn26("TextBox", {
										Name = "TextBox",
										BackgroundColor3 = color(13, 13, 13),
										BorderSizePixel = 0,
										Position = udim2(0, 0, 0, 21),
										Size = udim2(1, 0, 0, n32),
										ZIndex = 6,
										ClearTextOnFocus = false,
										Font = Enum.Font.Code,
										MultiLine = arg5,
										PlaceholderColor3 = color(130, 130, 130),
										PlaceholderText = arg3,
										Text = v75(arg4 or ""),
										TextColor3 = color(255, 255, 255),
										TextSize = arg5 and 12 or 14,
										TextTransparency = 0.1,
										TextWrapped = arg5,
										TextXAlignment = Enum.TextXAlignment.Left,
										TextYAlignment = arg5 and Enum.TextYAlignment.Top or Enum.TextYAlignment.Center,
										Parent = Frame,
									})

									local UIPadding = fn26("UIPadding", { Parent = v91 })
									UIPadding.PaddingLeft = udim(0, 8)
									UIPadding.PaddingRight = udim(0, 8)
									UIPadding.PaddingTop = udim(0, arg5 and 6 or 0)
									UIPadding.PaddingBottom = udim(0, arg5 and 6 or 0)
									fn26("UICorner", { CornerRadius = udim(0, 3), Parent = v91 })

									local UIStroke = fn26("UIStroke", {
										ApplyStrokeMode = Enum.ApplyStrokeMode.Border,
										Color = color(50, 50, 50),
										Thickness = 1,
										Parent = v91,
									})

									v91.Focused:Connect(function()
										create2(v81, UIStroke, tweenInfo(0.15), { Color = color(255, 255, 255) }):Play()
									end)

									v91.FocusLost:Connect(function()
										create2(v81, UIStroke, tweenInfo(0.1), { Color = color(50, 50, 50) }):Play()
										arg6(v91.Text)
									end)

									return {
										get = function()
											return v91.Text
										end,
										set = function(arg7, arg8, arg9)
											v91.Text = v75(arg8 or "")

											if arg9 then
												arg6(v91.Text)
											end
										end,
									}
								end

								tbl10.notify_result = function(arg, arg2)
									tbl21:notify({ title = arg and "fflags" or "fflags error", content = arg2, duration = arg and 4 or 6 })
								end

								tbl10.is_option = function(arg)
									return v76(arg) == "string" and arg ~= "(no saved profiles)" and arg ~= "(profile listing unavailable)"
								end

								tbl10.options = function()
									local v90, v91 = tbl10.list()
									if not v90 then
										return { "(profile listing unavailable)" }, v91
									end

									if #v90 == 0 then
										return { "(no saved profiles)" }
									end
									return v90
								end

								v88 = fn28(profile, "profile name", "default", config.fflag_profile, false, function(arg)
									config.fflag_profile = tbl19.trim(arg)
								end)

								v89 = fn28(v87, "fflags json", "{\"DFIntTaskSchedulerTargetFps\":\"240\"}", config.fflag_json, true, function(fflagJson)
									config.fflag_json = fflagJson
								end)
							end
						end

						do
							tbl10.load_into_editor = function(arg)
								local v90, v91, v92 = tbl10.path(arg)
								if not v92 then
									return false, v91
								end
								local v93, v94 = tbl10.load_profile(v92)
								if not v93 then
									return false, v94
								end
								config.fflag_profile = v92
								config.fflag_json = v94
								v88:set(v92, false)
								v89:set(v94, false)
								tbl19.save()
								return true, v92
							end

							tbl10.refresh_dropdown = function(arg)
								local v90 = tbl10.options()
								tbl10.dropdown:Refresh(v90)
								tbl10.dropdown:Value(find(v90, arg) and arg or v90[1])
							end

							do
								local v90, v91 = tbl10.options()

								tbl10.dropdown = profile:AddDropdown("saved profiles", v90, find(v90, config.fflag_profile) and config.fflag_profile or v90[1], function(arg)
									if not tbl10.is_option(arg) then
										return
									end
									local v92, v93 = tbl10.load_into_editor(arg)

									if not v92 then
										tbl10.notify_result(false, v93)
									end
								end)

								if v91 then
									defer(function()
										tbl10.notify_result(false, v91)
									end)
								end
							end
						end

						profile:AddButton("save profile", function()
							local get = v89.get
							local v90, v91, v92 = tbl10.save_profile(tbl19.trim(v88:get()), get(v89))

							if v90 then
								config.fflag_profile = v92
								config.fflag_json = v91
								v88:set(v92, false)
								v89:set(v91, false)
								tbl19.save()
								tbl10.refresh_dropdown(v92)
								tbl10.notify_result(true, format("saved profile '%s'", v92))
							else
								tbl10.notify_result(false, v91)
							end
						end)

						profile:AddButton("load profile", function()
							local loadIntoEditor = tbl10.load_into_editor
							local v90 = table.pack(tbl19.trim(v88:get()))
							v90.n = 1 + v90.n - 1
							table.move(v90, 1, v90.n, 1, v90)
							local v91, v92 = loadIntoEditor(table.unpack(v90, 1, v90.n))

							if v91 then
								if true then
									tbl10.refresh_dropdown(v92)
									tbl10.notify_result(true, format("loaded profile '%s'", v92))
								else
									while true do
									end
								end
							else
								tbl10.notify_result(false, v92)
							end
						end)

						do
							local v90 = profile:AddToggle("auto load", config.fflag_auto_load, function(fflagAutoLoad)
								config.fflag_auto_load = fflagAutoLoad
								tbl19.save()
							end)

							profile:AddButton("set selected as auto load", function()
								local v91 = tbl10.dropdown:Get()
								if not tbl10.is_option(v91) then
									tbl10.notify_result(false, "select a saved profile first")
									return
								end
								local v92, v93 = tbl10.load_into_editor(v91)
								if not v92 then
									tbl10.notify_result(false, v93)
									return
								end
								v90:Value(true)
								tbl10.notify_result(true, format("auto load set to '%s'", v93))
							end)

							profile:AddButton("delete selected profile", function()
								local v91 = tbl10.dropdown:Get()
								if not tbl10.is_option(v91) then
									tbl10.notify_result(false, "select a saved profile first")
									return
								end
								local v92, v93 = tbl10.delete(v91)
								if not v92 then
									tbl10.notify_result(false, v93)
									return
								end

								if config.fflag_profile == v91 then
									config.fflag_profile = tbl19.defaults.fflag_profile
									config.fflag_json = ""
									v88:set(tbl19.defaults.fflag_profile, false)
									v89:set("", false)
									v90:Value(false)
								end

								tbl10.refresh_dropdown()
								tbl19.save()
								tbl10.notify_result(true, format("deleted profile '%s'", v91))
							end)
						end

						v87:AddLabel("format: {\"FFlagName\":\"value\"}")

						v87:AddButton("apply fflags", function()
							config.fflag_profile = tbl19.trim(v88:get())
							config.fflag_json = v89:get()
							tbl19.save()
							local v90, v91 = tbl10.apply(config.fflag_json)
							tbl10.notify_result(v90, v91)
						end)

						if tbl22 then
							defer(function()
								tbl10.notify_result(tbl22.ok, tbl22.message)
							end)
						end
					end

					local tbl22, tbl23, touchEnabled, keyboardEnabled, gamepadEnabled, tbl24, tbl25, tbl26

					do
						local tbl27, tbl28, tbl29, tbl30, fn27

						do
							local tbl31

							do
								tbl22 = {}
								tbl27 = { current = nil, visited = {} }
								tbl28 = { methods = tbl20, dropdown = nil, syncing = false }

								tbl29 = {
									active = nil,
									cache = {},
									tracks = {},
									api = nil,
									generation = 0,
									last_spam = 0,
									cancel_delay = 0.12,
									cancel_fraction = 0.35,
								}

								tbl30 = { count = 0, first_signal = nil }

								v74(function()
									tbl29.api = require(v79.Shared.SwordAPI)
								end)

								localPlayer.CharacterAdded:Connect(function()
									clear(tbl29.tracks)
									tbl29.active = nil
									tbl29.generation = tbl29.generation + 1
									tbl29.last_spam = 0
								end)

								tbl23 = {
									state = {
										AerodynamicTime = v78(),
										LastWarping = v78(),
										LerpRadians = 0,
										Curving = v78(),
									},
									positions = {},
									replicator = nil,
								}

								fn27 = function(arg, arg2, arg3)
									return arg + (arg2 - arg) * arg3
								end

								tbl31 = { captured = {}, hooked = {}, originals = {}, token_fn = nil }

								for _, v86 in getgc(true) do
									if v76(v86) ~= "function" or not debug.info(v86, "s"):find("PRY", 1, true) then
										continue
									else
										for _, v87 in debug.getupvalues(v86) do
											local v88 = "function"

											if v76(v87) == v88 then
												print("found.")
												tbl31.token_fn = v87
												break
											end
										end

										if not tbl31.token_fn then
											continue
										end
									end

									break
								end

								tbl31.tokenize = function(arg)
									local v86 = 100
									local v87 = v75(floor2(v84:GetServerTimeNow() * v86))
									local v88 = tbl31.token_fn(arg, "TIME")
									local v89 = create(#v87)

									for i = 1, #v87 do
										local v90 = 256
										v89[i] = char2(bxor((byte(v87, i) + i) % v90, byte(v88, (i - 1) % #v88 + 1)))
									end

									return concat(v89)
								end

								tbl31.unhook = function()
									for k, v86 in tbl31.originals, nil, nil do
										v74(function()
											setreadonly(k, false)
											k.__index = v86
											setreadonly(k, true)
										end)
									end

									clear(tbl31.hooked)
									clear(tbl31.originals)
								end

								tbl31.valid_args = function(arg)
									return #arg == 8 and v76(arg[2]) == "string" and v76(arg[3]) == "string" and v76(arg[4]) == "number" and typeof(arg[5]) == "CFrame" and v76(arg[6]) == "table" and v76(arg[7]) == "table" and v76(arg[8]) == "boolean"
								end

								tbl31.hook = function(arg)
									if next(tbl31.captured) ~= nil then
										return
									end
									local v86 = getrawmetatable(arg)
									if tbl31.hooked[v86] then
										return
									end
									tbl31.hooked[v86] = true
									setreadonly(v86, false)
									local index = v86.__index
									tbl31.originals[v86] = index

									v86.__index = function(arg2, arg3)
										if arg3 == "FireServer" and arg2:IsA("RemoteEvent") or arg3 == "InvokeServer" and arg2:IsA("RemoteFunction") then
											return function(arg4, ...)
												local tbl32 = { ... }

												if tbl31.valid_args(tbl32) then
													tbl31.captured[arg2] = tbl32
													tbl31.unhook()
												end

												return index(arg2, arg3)(arg4, v77(tbl32))
											end
										end

										return index(arg2, arg3)
									end

									setreadonly(v86, true)
								end

								for _, v86 in v79:GetDescendants() do
									if v86:IsA("RemoteEvent") or v86:IsA("RemoteFunction") then
										tbl31.hook(v86)
									end
								end

								tbl23.get = function()
									for _, v86 in balls:GetChildren() do
										if v86:GetAttribute("realBall") then
											return v86
										end
									end

									return nil
								end

								tbl23.get_all = function()
									local tbl32 = {}

									for _, v86 in balls:GetChildren() do
										if v86:GetAttribute("realBall") then
											insert(tbl32, v86)
										end
									end

									return tbl32
								end

								do
									local net = v79:FindFirstChild("Packages") and v79.Packages:FindFirstChild("_Index") and v79.Packages._Index:FindFirstChild("sleitnick_net@0.1.0") and v79.Packages._Index["sleitnick_net@0.1.0"]:FindFirstChild("net")

									if net then
										if n25 <= 3223 then
											while true do
											end
										else
											for _, v86 in net:GetChildren() do
												if v86:IsA("UnreliableRemoteEvent") and v86.Name ~= "URE/ReplicateBallPosition" then
													tbl23.replicator = v86
													break
												end
											end
										end
									end
								end
							end

							if tbl23.replicator then
								tbl23.replicator.OnClientEvent:Connect(function(arg, arg2)
									if arg and arg.Parent == balls and arg:GetAttribute("realBall") == true then
										tbl23.positions[arg] = arg2
									end
								end)
							end

							tbl23.position = function(arg)
								local v86 = arg or tbl23.get()
								if v86 then
									return tbl23.positions[v86] or v86.Position
								end
								return Vector3.zero
							end

							tbl27.pick_random = function()
								local tbl32 = {}

								for _, v86 in alive:GetChildren() do
									if v86.Name ~= name and v86.PrimaryPart then
										insert(tbl32, v86)
									end
								end

								if #tbl32 == 0 then
									tbl27.current = nil
									return
								end

								if #tbl32 == 1 then
									tbl27.current = tbl32[1]
									return
								end
								local tbl33 = {}

								for _, v86 in tbl32, nil, nil do
									if not tbl27.visited[v86.Name] then
										insert(tbl33, v86)
									end
								end

								if #tbl33 == 0 then
									tbl27.visited = {}

									for _, v86 in tbl32, nil, nil do
										if not tbl27.current or v86.Name ~= tbl27.current.Name then
											insert(tbl33, v86)
										end
									end

									if #tbl33 == 0 then
										tbl33 = tbl32
									end
								end

								local v86 = tbl33[random2(1, #tbl33)]
								tbl27.visited[v86.Name] = true
								tbl27.current = v86
							end

							touchEnabled = v80.TouchEnabled

							do
								local mouseEnabled = v80.MouseEnabled
								keyboardEnabled = v80.KeyboardEnabled
								gamepadEnabled = v80.GamepadEnabled

								tbl27.by_mouse = function()
									local tbl32 = {}

									for _, v86 in alive:GetChildren() do
										if v86.Name ~= name and v86.PrimaryPart then
											insert(tbl32, v86)
										end
									end

									if #tbl32 == 0 then
										tbl27.current = nil
										return nil
									end
									local currentCamera2 = currentCamera or v84.CurrentCamera
									local cFrame = currentCamera2.CFrame
									local position = cFrame.Position
									local lookVector = cFrame.LookVector
									local direction

									if mouseEnabled then
										local mouseLocation = v80:GetMouseLocation()
										direction = currentCamera2:ScreenPointToRay(mouseLocation.X, mouseLocation.Y).Direction
									else
										local viewportSize = currentCamera2.ViewportSize
										direction = currentCamera2:ViewportPointToRay(viewportSize.X * 0.5, viewportSize.Y * 0.5).Direction
									end

									local n31 = -math.huge
									local v86 = nil

									for _, v87 in tbl32, nil, nil do
										local n32 = v87.PrimaryPart.Position - position

										if n32.Magnitude > 0 then
											local unit = n32.Unit

											if lookVector:Dot(unit) > 0 then
												local v88 = direction:Dot(unit)

												if n31 < v88 then
													n31 = v88
													v86 = v87
												end
											end
										end
									end

									v86 = v86 or tbl32[1]
									tbl27.current = v86
									return v86
								end

								tbl27.closest = function()
									if config.random_target then
										if not tbl27.current then
											tbl27.pick_random()
										end

										return tbl27.current
									end

									return tbl27.by_mouse()
								end

								tbl28.get_cframe = function()
									local cFrame = (currentCamera or v84.CurrentCamera).CFrame
									local character = localPlayer.Character
									local humanoidRootPart = character and character:FindFirstChild("HumanoidRootPart")
									if not humanoidRootPart then
										return cFrame
									end
									local position = tbl27.current and tbl27.current.PrimaryPart and tbl27.current.PrimaryPart.Position or humanoidRootPart.Position + cFrame.LookVector * 1000
									local unit = (position - humanoidRootPart.Position).Unit
									local curveMethod = config.curve_method
									if curveMethod == "dot" then
										return CFrame.lookAt(humanoidRootPart.Position, position + vector(0, 1.75, 0))
									end

									if curveMethod == "backwards" then
										return cframe(humanoidRootPart.Position, humanoidRootPart.Position + -unit * 1000)
									end

									if curveMethod == "slow" then
										return cframe(humanoidRootPart.Position, humanoidRootPart.Position + vector(0, -350, 0))
									end

									if curveMethod == "random" then
										local position2 = humanoidRootPart.Position
										local v86 = 1000
										return cframe(position2, position + vector(random2(-1000, 1000), random2(-350, 1000), random2(-1000, v86)))
									end

									return cFrame
								end

								tbl28.sync_dropdown = function(arg)
									tbl28.syncing = true
									tbl28.dropdown:Value(arg)
									tbl28.syncing = false
								end

								tbl29.find = function(arg)
									local grabParry = arg:FindFirstChild("GrabParry") or arg:FindFirstChild("Parry") or arg:FindFirstChild("Grab")
									if grabParry then
										return grabParry
									end
									local base = arg:FindFirstChild("Base")
									if base then
										return base:FindFirstChild("GrabParry") or base:FindFirstChild("Parry") or base:FindFirstChild("Grab")
									end
									return nil
								end

								tbl29.resolve = function(arg, arg2)
									if not arg2 then
										return nil
									end

									if tbl29.cache[arg2] and tbl29.cache[arg2].Parent then
										return tbl29.cache[arg2]
									end
									local v86 = v79:FindFirstChild("Shared")
									if not v86 then
										return nil
									end
									local swords = v86:FindFirstChild("ReplicatedInstances")
									swords = swords and swords:FindFirstChild("Swords")
									local v87 = swords and swords:FindFirstChild("GetSword")
									local v88 = nil

									if v87 then
										v74(function()
											v88 = v87:Invoke(arg2)
										end)
									end

									local animationType = v88 and v88.AnimationType or "Single"
									local swordType = v88 and v88.SwordType or "Single"

									if tbl29.api and v76(tbl29.api.GetAnimations) == "function" then
										local v89, v90 = v74(function()
											return tbl29.api:GetAnimations(arg, { "Parry", "GrabParry" }, animationType, swordType)
										end)

										if v89 and v76(v90) == "table" and v90[1] then
											tbl29.cache[arg2] = v90[1]
											return v90[1]
										end
									end

									local swordAPI = v86:FindFirstChild("SwordAPI")

									if swordAPI then
										swordAPI = swordAPI:FindFirstChild("Collection") or swordAPI
									end

									if swordAPI then
										local v89 = swordAPI:FindFirstChild(animationType)

										if v89 then
											local v90 = tbl29.find(v89)
											if v90 then
												tbl29.cache[arg2] = v90
												return v90
											end
										end

										local default = swordAPI:FindFirstChild("Default")

										if default then
											local v90 = tbl29.find(default)
											if v90 then
												tbl29.cache[arg2] = v90
												return v90
											end
										end
									end

									return nil
								end

								tbl29.grab = function(arg)
									local character = localPlayer.Character
									if not character then
										return false
									end
									local v86 = character:FindFirstChildOfClass("Humanoid")
									local animator = v86 and v86:FindFirstChildOfClass("Animator")
									if not v86 or not animator then
										return false
									end
									local swordAnimations

									if genv and genv.skinChangerEnabled and genv.swordAnimations then
										swordAnimations = genv.swordAnimations
									else
										swordAnimations = character:GetAttribute("CurrentlyEquippedSword") or "Base Sword"
									end

									local v87 = tbl29.resolve(character, swordAnimations)
									if not v87 then
										return false
									end
									local tbl32 = tbl29.tracks[animator]

									if not tbl32 then
										tbl32 = {}
										tbl29.tracks[animator] = tbl32
									end

									local v88 = tbl32[v87]

									if not v88 or not v88.Parent or v88.Parent ~= animator then
										local v89

										v89, v88 = v74(function()
											return animator:LoadAnimation(v87)
										end)

										if not v89 or not v88 then
											return false
										end

										for k, v90 in v87:GetAttributes() do
											v88:SetAttribute(k, v90)
										end

										v88:SetAttribute("GrabParry", true)
										v88.Priority = Enum.AnimationPriority.Action4
										tbl32[v87] = v88
									end

									if arg then
										local v89 = v78()

										if v89 - tbl29.last_spam < tbl29.cancel_delay then
											local flag14 = false

											if tbl29.active then
												v74(function()
													flag14 = tbl29.active.IsPlaying
												end)
											end

											if flag14 then
												character:SetAttribute("ParryTime", max(character:GetAttribute("ParryTime") or 0, tbl29.active.Length ~= 0 and tbl29.active.Length or 1))
												return true
											end
										end

										tbl29.last_spam = v89
									else
										tbl29.last_spam = 0
									end

									tbl29.generation = tbl29.generation + 1
									local generation = tbl29.generation

									for _, v89 in animator:GetPlayingAnimationTracks() do
										if v89:GetAttribute("GrabParry") or v89:GetAttribute("Parry") or v89:GetAttribute("SuccessParry") then
											v74(v89.Stop, v89, v89:GetAttribute("StopFadeTime") or 0.05)
										end
									end

									local attribute = v87:GetAttribute("PlayFadeTime") or 0.05
									local attribute2 = v87:GetAttribute("PlayWeight") or 1
									local attribute3 = v87:GetAttribute("PlaySpeed") or 1
									v88.TimePosition = 0
									v88:Play(attribute, attribute2, attribute3)
									tbl29.active = v88
									character:SetAttribute("ParryTime", max(character:GetAttribute("ParryTime") or 0, v88.Length ~= 0 and (v88.Length - v88.TimePosition) * attribute3 or 1))

									if arg then
										local cancelDelay = tbl29.cancel_delay
										local length = v88.Length or 0
										local n31

										if not (length > 0) then
											n31 = cancelDelay
										else
											n31 = min(cancelDelay, length * tbl29.cancel_fraction)
										end

										if n31 < 0.05 then
											n31 = 0.05
										end

										local v89 = v88
										local attribute4 = v87:GetAttribute("StopFadeTime") or 0.05

										delay(n31, function()
											if generation ~= tbl29.generation or tbl29.active ~= v89 then
												return
											end
											v74(v89.Stop, v89, attribute4)
										end)
									end

									return true
								end

								tbl30.fire = function(arg)
									local currentCamera2 = currentCamera or v84.CurrentCamera

									if not config.random_target then
										local v86 = 4096

										if true then
											tbl27.by_mouse()
										else
											while true do
											end
										end
									end

									local v86 = tbl28.get_cframe()
									local primaryPart = tbl27.current and tbl27.current.PrimaryPart
									local tbl32

									if primaryPart then
										local v87 = currentCamera2:WorldToViewportPoint(primaryPart.Position)
										tbl32 = { v87.X, v87.Y }
									elseif mouseEnabled then
										local mouseLocation = v80:GetMouseLocation()
										tbl32 = { mouseLocation.X, mouseLocation.Y }
									else
										local viewportSize = currentCamera2.ViewportSize
										tbl32 = { viewportSize.X * 0.5, viewportSize.Y * 0.5 }
									end

									local tbl33 = {}

									for _, v87 in alive:GetChildren() do
										local primaryPart2 = v87.PrimaryPart

										if primaryPart2 then
											local v88 = currentCamera2:WorldToScreenPoint(primaryPart2.Position)

											if v88 and v88.Z > 0 then
												tbl33[v87.Name] = v88
											end
										end
									end

									if next(tbl31.captured) == nil then
										if not tbl30.first_signal then
											tbl30.first_signal = require(packages.Signal).new()
											tbl30.first_signal:Connect(require(controllers["SwordsController \12"].PRY))
										end

										tbl30.first_signal:Fire(0.5, v86, tbl33, tbl32, false)

										if arg then
											tbl29.grab(true)
										end
									else
										tbl29.grab(arg)

										for k, v87 in tbl31.captured, nil, nil do
											local tbl34 = {}
											local v88 = v87[1]
											local v89 = v87[2]
											local v90 = tbl31.tokenize(v87[2])
											local v91 = 0.5
											tbl34[1] = v88
											tbl34[2] = v89
											tbl34[3] = v90
											tbl34[4] = v91
											tbl34[5] = v86
											tbl34[6] = tbl33
											tbl34[7] = tbl32
											tbl34[8] = false

											if k:IsA("RemoteEvent") then
												k:FireServer(v77(tbl34))
											elseif k:IsA("RemoteFunction") then
												k:InvokeServer(v77(tbl34))
											end
										end
									end

									if tbl30.count > 7 then
										return false
									end
									tbl30.count = tbl30.count + 1

									delay(0.5, function()
										if tbl30.count > 0 then
											tbl30.count = tbl30.count - 1
										end
									end)
								end
							end
						end

						tbl24 = {
							distance = 0,
							last_auto = 0,
							manual_on = false,
							manual_key = Enum.KeyCode.E,
							mobile_button = nil,
						}

						do
							local tbl31 = { debounce = false, until_at = 0, accuracy = 1.5 }
							tbl25 = { labels = {} }
							tbl26 = { on = false, busy = false, key = Enum.KeyCode.T, button = nil }

							tbl23.curved = function(arg)
								local v86 = arg or tbl23.get()

								if v86 then
									local zoomies = v86:FindFirstChild("zoomies")
									if not zoomies then
										return false
									end
									local v87 = v78()
									local value = dataPing:GetValue()
									local vectorVelocity = zoomies.VectorVelocity
									local unit = vectorVelocity.Unit
									local position = localPlayer.Character.PrimaryPart.Position
									local v88 = tbl23.position(v86)
									local unit2 = (position - v88).Unit
									local v89 = unit2:Dot(unit)
									local magnitude = vectorVelocity.Magnitude
									local v90 = min(magnitude / 100, 40)
									local n31 = v89 - unit2:Dot((unit - vectorVelocity).Unit)
									local magnitude2 = (position - v88).Magnitude
									local n32 = 0.5 - value / 1000
									local n33 = magnitude2 / magnitude - value / 1000
									local n34 = 15 - min(magnitude2 / 1000, 15) + v90
									local v91 = 0.8
									tbl23.state.LerpRadians = fn27(tbl23.state.LerpRadians, rad(asin(clamp(v89, -1, 1))), v91)

									if magnitude > 100 and n33 > value / 10 then
										n34 = max(n34 - 15, 15)
									end

									if magnitude2 < n34 then
										return false
									end

									if n31 < n32 then
										return true
									end

									if tbl23.state.LerpRadians < 0.018 then
										tbl23.state.LastWarping = v87
									end

									if v87 - tbl23.state.LastWarping < n33 / 1.5 then
										return true
									end

									if v87 - tbl23.state.Curving < n33 / 1.5 then
										return true
									end
									return v89 < n32
								end

								if not (n25 >= 3245) then
									return false
								end

								while true do
								end
							end

							tbl23.props = function()
								local v86 = tbl23.get()
								local vector3 = Vector3.zero
								local unit = (localPlayer.Character.PrimaryPart.Position - tbl23.position(v86)).Unit

								return {
									Velocity = vector3,
									Direction = unit,
									Distance = (localPlayer.Character.PrimaryPart.Position - tbl23.position(v86)).Magnitude,
									Dot = unit:Dot(vector3.Unit),
								}
							end

							tbl27.props = function()
								local current = tbl27.current or tbl27.closest()
								if not current or not current.PrimaryPart then
									return false
								end
								local position = localPlayer.Character.PrimaryPart.Position

								return {
									velocity = current.PrimaryPart.Velocity,
									direction = (position - current.PrimaryPart.Position).Unit,
									distance = (position - current.PrimaryPart.Position).Magnitude,
								}
							end

							tbl24.perform = function(arg)
								local v86 = tbl23.get()
								local current = tbl27.current or tbl27.closest()
								if not v86 then
									return false
								end

								if not current or not current.PrimaryPart then
									return false
								end
								local assemblyLinearVelocity = v86.AssemblyLinearVelocity
								local magnitude = assemblyLinearVelocity.Magnitude
								local v87 = (localPlayer.Character.PrimaryPart.Position - tbl23.position(v86)).Unit:Dot(assemblyLinearVelocity.Unit)
								local v88 = localPlayer:DistanceFromCharacter(current.PrimaryPart.Position)
								local n31 = arg.Ping + min(magnitude / 6, 95)
								if arg.Entity_Properties.distance > n31 then
									return tbl24.distance
								end

								if n31 < arg.Ball_Properties.Distance then
									return tbl24.distance
								end

								if n31 < v88 then
									return tbl24.distance
								end
								tbl24.distance = n31 - clamp(v87, -1, 0) * (5 - min(magnitude / 5, 5))
								return tbl24.distance
							end

							tbl23.bind = function(arg)
								spawn_(function()
									if not arg:GetAttribute("realBall") and not arg:WaitForChild("zoomies", 3) then
										return
									end

									arg:GetAttributeChangedSignal("target"):Connect(function()
										tbl31.debounce = false
										tbl31.until_at = 0

										if config.random_target then
											tbl27.pick_random()
										end
									end)
								end)
							end

							balls.ChildAdded:Connect(function()
								if config.random_target then
									tbl27.pick_random()
								end
							end)

							balls.ChildAdded:Connect(tbl23.bind)

							for _, v86 in balls:GetChildren() do
								tbl23.bind(v86)
							end

							tbl25.init = function()
								local function fn28(arg)
									local character = arg.Character

									while not character or not character.Parent do
										wait_()
										character = arg.Character
									end

									local head = character:WaitForChild("Head")

									local BillboardGui = fn26("BillboardGui", {
										Adornee = head,
										Size = udim2(0, 200, 0, 50),
										StudsOffset = vector(0, 3, 0),
										AlwaysOnTop = true,
										Parent = head,
									})

									local TextLabel = fn26("TextLabel", {
										Size = udim2(1, 0, 1, 0),
										TextColor3 = color(255, 255, 255),
										TextSize = 10,
										TextWrapped = false,
										BackgroundTransparency = 1,
										TextXAlignment = Enum.TextXAlignment.Center,
										TextYAlignment = Enum.TextYAlignment.Center,
										Parent = BillboardGui,
									})

									tbl25.labels[arg] = TextLabel
									local humanoid = character:FindFirstChild("Humanoid")

									if humanoid then
										humanoid.DisplayDistanceType = Enum.HumanoidDisplayDistanceType.None
									end

									local function fn29()
										local attribute = arg:GetAttribute("EquippedAbility")
										TextLabel.Text = attribute and arg.DisplayName .. " [" .. attribute .. "]" or arg.DisplayName
										TextLabel.Visible = config.ability_esp or false
									end

									fn29()
									local connection = arg:GetAttributeChangedSignal("EquippedAbility"):Connect(fn29)
									local connection2 = nil

									connection2 = heartbeat:Connect(function()
										if not character or not character.Parent then
											connection2:Disconnect()

											if connection then
												connection:Disconnect()
											end

											BillboardGui:Destroy()
											tbl25.labels[arg] = nil
											return
										end

										TextLabel.Visible = config.ability_esp or false
									end)
								end

								for _, v86 in v82:GetPlayers() do
									if v86 ~= localPlayer then
										v86.CharacterAdded:Connect(function()
											fn28(v86)
										end)

										fn28(v86)
									end
								end

								v82.PlayerAdded:Connect(function(player)
									player.CharacterAdded:Connect(function()
										fn28(player)
									end)
								end)
							end

							tbl25.init()

							tbl31.check = function()
								if tbl26.busy then
									return
								end
								local character = localPlayer.Character
								character = character and character.PrimaryPart
								if not character then
									return
								end
								local v86 = v78()
								if tbl31.debounce or v86 < tbl31.until_at then
									return
								end
								local position = character.Position
								local v87 = clamp(dataPing:GetValue() / 10 / 10, 5, 17)
								local attribute = tbl23.get()
								attribute = attribute and attribute:GetAttribute("target")
								local tornado = runtime:FindFirstChild("Tornado")
								local attribute2 = tornado and (tornado:GetAttribute("TornadoTime") or 1)
								local position2 = tbl23.position
								local curved = tbl23.curved

								for _, v88 in tbl23.get_all() do
									if not v88 then
										return
									end
									local v89 = v88:FindFirstChild("zoomies")
									if not v89 then
										return
									end
									local attribute3 = v88:GetAttribute("target")
									local magnitude = v89.VectorVelocity.Magnitude
									local magnitude2 = (position - position2(v88)).Magnitude
									local v90 = 0.002
									local accuracy = tbl31.accuracy
									local n31 = (2.4 + min(max(magnitude - 9.5, 0), 650) * v90) * accuracy

									if v88:FindFirstChild("AeroDynamicSlashVFX") then
										v83:AddItem(v88.AeroDynamicSlashVFX, 0)
										tbl23.state.AerodynamicTime = v86
									end

									if tornado and v86 - tbl23.state.AerodynamicTime < attribute2 + 0.314159 then
										return
									end

									if attribute == name and curved(v88) then
										return
									end

									if attribute3 == name and magnitude2 <= v87 + max(magnitude / n31, 9.5) and tbl31.accuracy * 0.8 then
										tbl30.fire()
										tbl31.debounce = true
										tbl31.until_at = v86 + 1
									end
								end
							end

							tbl31.set = function(autoParry)
								config.auto_parry = autoParry

								if autoParry then
									tbl22.auto_parry = postSimulation:Connect(tbl31.check)
								elseif tbl22.auto_parry then
									tbl22.auto_parry:Disconnect()
									tbl22.auto_parry = nil
								end
							end

							v85:AddToggle("auto parry", config.auto_parry or false, tbl31.set)

							remotes.ParrySuccessAll.OnClientEvent:Connect(function(arg, arg2)
								if arg2.Parent and arg2.Parent ~= localPlayer.Character and arg2.Parent.Parent ~= alive then
									return
								end
								tbl27.closest()
								if not tbl27.current or not tbl27.current.PrimaryPart then
									return
								end
								local v86 = tbl23.get()
								if not v86 then
									return
								end
								local position = localPlayer.Character.PrimaryPart.Position
								local magnitude = (position - tbl27.current.PrimaryPart.Position).Magnitude
								local n31 = position - tbl23.position(v86)
								local magnitude2 = n31.Magnitude
								local v87 = n31.Unit:Dot(v86.AssemblyLinearVelocity.Unit)
								local v88 = tbl23.curved()

								if magnitude < 15 and magnitude2 < 15 and v87 > -0.25 and v88 then
									tbl30.fire()
								end
							end)

							remotes.ParrySuccess.OnClientEvent:Connect(function()
								local character = localPlayer.Character
								if not character or not character:IsDescendantOf(v84) then
									return
								end
								local humanoid = character:FindFirstChildOfClass("Humanoid")
								humanoid = humanoid and humanoid:FindFirstChildOfClass("Animator")
								if not humanoid then
									return
								end
								tbl29.generation = tbl29.generation + 1
								tbl29.last_spam = 0

								for _, v86 in humanoid:GetPlayingAnimationTracks() do
									if v86:GetAttribute("GrabParry") or v86:GetAttribute("Parry") then
										v86:Stop(v86:GetAttribute("StopFadeTime"))
									end
								end
							end)

							balls.ChildAdded:Connect(function()
								tbl31.debounce = false
								tbl31.until_at = 0
							end)

							balls.ChildRemoved:Connect(function(child)
								tbl23.positions[child] = nil
								tbl30.count = 0
								tbl31.debounce = false
								tbl31.until_at = 0
								tbl27.current = nil
								tbl27.visited = {}

								if tbl22.target_change then
									tbl22.target_change:Disconnect()
									tbl22.target_change = nil
								end
							end)

							remotes.ParrySuccessAll.OnClientEvent:Connect(function(arg, arg2)
								local position = localPlayer.Character.PrimaryPart.Position
								local v86 = tbl23.get()
								if not v86 then
									return
								end
								local zoomies = v86:FindFirstChild("zoomies")
								if not zoomies then
									return
								end
								local magnitude = zoomies.VectorVelocity.Magnitude
								local magnitude2 = (position - tbl23.position(v86)).Magnitude
								local value = dataPing:GetValue()
								local n31 = magnitude2 / magnitude - value / 1000
								local n32 = 15 - min(magnitude2 / 1000, 15) + min(magnitude / 100, 40)

								if magnitude > 100 and n31 > value / 10 then
									n32 = max(n32 - 15, 15)
								end

								if arg2 ~= localPlayer.Character.PrimaryPart and magnitude2 > n32 then
									tbl23.state.Curving = v78()
								end
							end)

							v85:AddSlider("accuracy", 1, 100, config.accuracy or 100, function(accuracy)
								tbl31.accuracy = (accuracy - 1) * 0.015151515151515152
								config.accuracy = accuracy
							end)

							tbl31.accuracy = (config.accuracy - 1) * 0.015151515151515152
						end

						v85:AddToggle("random target", config.random_target or false, function(randomTarget)
							spawn_(function()
								config.random_target = randomTarget
								tbl27.current = nil
								tbl27.visited = {}

								if randomTarget then
									tbl27.pick_random()
								end
							end)
						end)

						tbl28.hotkeys = {
							[Enum.KeyCode.One] = "camera",
							[Enum.KeyCode.Two] = "dot",
							[Enum.KeyCode.Three] = "backwards",
							[Enum.KeyCode.Four] = "slow",
							[Enum.KeyCode.Five] = "random",
						}

						tbl28.dropdown = curve:AddDropdown("curve method", { "camera", "dot", "backwards", "slow", "random" }, config.curve_method or "camera", function(curveMethod)
							local syncing = tbl28.syncing

							spawn_(function()
								local v86 = syncing
								local flag14

								if syncing then
									flag14 = v86
								else
									flag14 = config.curve_method == curveMethod
								end

								if flag14 then
									if config.curve_notify and not syncing then
										tbl21:notify({ title = "curve method", content = "already " .. curveMethod, duration = 3 })
									end

									return
								end

								config.curve_method = curveMethod

								if config.curve_notify then
									tbl21:notify({ title = "curve method", content = "curve method is now " .. curveMethod, duration = 3 })
								end
							end)
						end)

						v80.InputBegan:Connect(function(input, gameProcessed)
							if gameProcessed or not config.curve_keybind then
								return
							end
							local v86 = tbl28.hotkeys[input.KeyCode]
							if not v86 then
								return
							end

							if config.curve_method == v86 then
								if config.curve_notify then
									tbl21:notify({ title = "curve method", content = ("already ") .. v86, duration = 3 })
								end

								return
							end

							config.curve_method = v86
							tbl28.sync_dropdown(v86)

							if config.curve_notify then
								tbl21:notify({ title = "curve method", content = "curve method is now " .. v86, duration = 3 })
							end
						end)

						hotkeys:AddToggle("hotkey curve", config.curve_keybind or false, function(curveKeybind)
							spawn_(function()
								config.curve_keybind = curveKeybind
							end)
						end)

						hotkeys:AddToggle("hotkey notify", config.curve_notify or false, function(curveNotify)
							spawn_(function()
								config.curve_notify = curveNotify
							end)
						end)

						tbl26.fire = function(arg)
							if tbl26.busy then
								return
							end
							tbl26.busy = true
							tbl30.fire()

							arg:GetAttributeChangedSignal("target"):Once(function()
								tbl26.busy = false
							end)

							local v86 = v78()

							spawn_(function()
								while true do
									preSimulation:Wait()
									if not (v78() - v86 >= 1 or not tbl26.busy) then
										continue
									end
									break
								end

								tbl26.busy = false
							end)
						end

						tbl26.update_button = function()
							if tbl26.button then
								tbl26.button.Text = tbl26.on and "triggerbot [on]" or "triggerbot [off]"
							end
						end

						tbl26.set = function(arg)
							local on = arg == true
							if tbl26.on == on then
								tbl26.update_button()
								return
							end
							tbl26.on = on
							_G.triggerbot = on
							tbl21:notify({ title = "triggerbot", content = on and "on" or "off", duration = 2 })

							if on then
								tbl22.triggerbot = preSimulation:Connect(function()
									local v86 = tbl23.get()

									if v86 and v86:GetAttribute("target") == name then
										tbl26.fire(v86)
									end
								end)
							elseif tbl22.triggerbot then
								tbl22.triggerbot:Disconnect()
								tbl22.triggerbot = nil
							end

							tbl26.update_button()
						end

						if touchEnabled then
							hotkeys:AddToggle("triggerbot button", config.mobile_triggerbot_button or false, function(mobileTriggerbotButton)
								config.mobile_triggerbot_button = mobileTriggerbotButton

								if tbl26.button then
									tbl26.button.Visible = mobileTriggerbotButton
								end

								if not mobileTriggerbotButton then
									tbl26.set(false)
								end
							end)
						end

						tbl24.auto_check = function()
							local v86 = tbl23.get()
							if not v86 then
								return
							end

							if not v86:FindFirstChild("zoomies") then
								return
							end
							tbl27.closest()
							if not tbl27.current or not tbl27.current.PrimaryPart then
								return
							end
							local v87 = v78()
							local v88 = 1
							local v89 = 16

							local v90 = tbl24.perform({
								Ball_Properties = tbl23.props(),
								Entity_Properties = tbl27.props(),
								Ping = clamp(dataPing:GetValue() / 10, v88, v89),
							})

							local character = localPlayer.Character
							local primaryPart = character and character.PrimaryPart
							if not primaryPart then
								return
							end
							local magnitude = (primaryPart.Position - tbl23.position(v86)).Magnitude
							local attribute = v86:GetAttribute("target")
							if not attribute then
								return
							end
							local v91 = localPlayer:DistanceFromCharacter(tbl27.current.PrimaryPart.Position)
							if v91 > v90 or magnitude > v90 then
								return
							end

							if character:GetAttribute("Pulsed") then
								return
							end

							if attribute == name and v91 > 30 and magnitude > 30 then
								return
							end

							if magnitude <= v90 and tbl30.count > config.spam_threshold and v87 - tbl24.last_auto >= 0.001 then
								tbl24.last_auto = v87
								tbl30.fire(true)
							end
						end

						tbl24.set_auto = function(autoSpam)
							config.auto_spam = autoSpam

							if autoSpam then
								tbl22.auto_spam = preSimulation:Connect(tbl24.auto_check)
							elseif tbl22.auto_spam then
								tbl22.auto_spam:Disconnect()
								tbl22.auto_spam = nil
							end
						end

						spam:AddToggle("auto spam", config.auto_spam or false, tbl24.set_auto)

						spam:AddSlider("threshold", 1, 3, config.spam_threshold or 3, function(arg)
							spawn_(function()
								if true then
									config.spam_threshold = tonumber(arg)
								else
									while true do
									end
								end
							end)
						end)

						v80.InputBegan:Connect(function(input, gameProcessed)
							if gameProcessed then
								return
							end

							if input.KeyCode == Enum.KeyCode.E then
								_G.manual_spam = not _G.manual_spam
							end
						end)

						if v76(config.manual_spam) == "string" and Enum.KeyCode[config.manual_spam] then
							tbl24.manual_key = Enum.KeyCode[config.manual_spam]
						end

						tbl24.update_button = function()
							if tbl24.mobile_button then
								tbl24.mobile_button.Text = tbl24.manual_on and "manual spam [on]" or "manual spam [off]"
							end
						end

						tbl24.set_manual = function(arg)
							local manualOn = arg == true
							if tbl24.manual_on == manualOn then
								tbl24.update_button()
								return
							end
							tbl24.manual_on = manualOn

							if tbl22.manual_spam then
								tbl22.manual_spam:Disconnect()
								tbl22.manual_spam = nil
							end

							if manualOn then
								local v86 = 0

								tbl22.manual_spam = preSimulation:Connect(function()
									local v87 = v78()
									if v87 - v86 < 0.001 then
										return
									end
									v86 = v87
									tbl30.fire(true)
								end)
							end

							tbl24.update_button()

							if config.manual_notify then
								tbl21:notify({ title = "manual spam", content = manualOn and "on" or "off", duration = 4 })
							end
						end
					end

					do
						if touchEnabled then
							hotkeys:AddToggle("manual spam button", config.mobile_manual_spam_button or false, function(mobileManualSpamButton)
								config.mobile_manual_spam_button = mobileManualSpamButton

								if tbl24.mobile_button then
									tbl24.mobile_button.Visible = mobileManualSpamButton
								end

								if not mobileManualSpamButton then
									tbl24.set_manual(false)
								end
							end)
						end

						do
							local flag14 = false

							local function fn27()
								if flag14 or not keyboardEnabled and not gamepadEnabled then
									return
								end
								flag14 = true

								hotkeys:AddKeybind("triggerbot", tbl26.key, function(key)
									if key ~= tbl26.key then
										tbl26.key = key
									end
								end)

								hotkeys:AddKeybind("manual spam", tbl24.manual_key, function(manualKey)
									if manualKey ~= tbl24.manual_key then
										tbl24.manual_key = manualKey
										config.manual_spam = manualKey.Name
									end
								end)
							end

							fn27()

							v80.GamepadConnected:Connect(function()
								gamepadEnabled = true
								fn27()
							end)

							v80:GetPropertyChangedSignal("KeyboardEnabled"):Connect(function()
								keyboardEnabled = v80.KeyboardEnabled
								fn27()
							end)

							v80:GetPropertyChangedSignal("GamepadEnabled"):Connect(function()
								gamepadEnabled = v80.GamepadEnabled
								fn27()
							end)
						end
					end

					do
						v80.InputBegan:Connect(function(input, gameProcessed)
							if gameProcessed then
								return
							end

							if input.KeyCode == tbl26.key then
								tbl26.set(not tbl26.on)
							end

							if input.KeyCode == tbl24.manual_key then
								tbl24.set_manual(not tbl24.manual_on)
							end
						end)

						if touchEnabled then
							do
								local ScreenGui = fn26("ScreenGui", {
									Name = "oxy_mobile",
									ResetOnSpawn = false,
									IgnoreGuiInset = true,
									DisplayOrder = 50,
									Parent = localPlayer:WaitForChild("PlayerGui"),
								})

								local function fn27(arg, arg2, arg3)
									local v86 = fn26("TextButton", {
										Name = arg,
										AnchorPoint = vector2(1, 0.5),
										Position = arg2,
										Size = udim22(130, 44),
										BackgroundColor3 = color(22, 22, 22),
										BorderSizePixel = 0,
										AutoButtonColor = false,
										FontFace = Font.new("rbxasset://fonts/families/GothamSSm.json", Enum.FontWeight.SemiBold, Enum.FontStyle.Normal),
										TextColor3 = color(255, 255, 255),
										TextSize = 16,
										TextWrapped = false,
										ZIndex = 2,
										Parent = ScreenGui,
									})

									fn26("UICorner", { CornerRadius = udim(0, 8), Parent = v86 })

									fn26("UIStroke", {
										Color = color(35, 35, 35),
										Thickness = 1,
										ApplyStrokeMode = Enum.ApplyStrokeMode.Border,
										Parent = v86,
									})

									local flag14 = false
									local flag15 = false
									local v87 = nil
									local position = nil
									local position2 = nil

									v86.InputBegan:Connect(function(input)
										local userInputType = input.UserInputType
										if userInputType ~= Enum.UserInputType.Touch and userInputType ~= Enum.UserInputType.MouseButton1 then
											return
										end
										flag14 = true
										flag15 = false
										v87 = input
										position = input.Position
										position2 = v86.Position
									end)

									v80.InputChanged:Connect(function(input)
										if not flag14 or input ~= v87 and input.UserInputType ~= Enum.UserInputType.MouseMovement then
											return
										end
										local n31 = input.Position - position

										if not (n26 > 1424) then
											if n31.Magnitude > 4 then
												flag15 = true
											end

											v86.Position = udim2(position2.X.Scale, position2.X.Offset + n31.X, position2.Y.Scale, position2.Y.Offset + n31.Y)
											return
										end

										while true do
										end
									end)

									v80.InputEnded:Connect(function(input)
										if input == v87 then
											flag14 = false
											v87 = nil
										end
									end)

									v86.MouseButton1Click:Connect(function()
										if flag15 then
											flag15 = false
											return
										end
										arg3()
										v86.BackgroundColor3 = color(40, 40, 40)
										create2(v81, v86, tweenInfo(0.2), { BackgroundColor3 = color(22, 22, 22) }):Play()
									end)

									return v86
								end

								tbl26.button = fn27("Triggerbot", udim2(1, -280, 0.5, 0), function()
									tbl26.set(not tbl26.on)
								end)

								tbl26.button.Visible = config.mobile_triggerbot_button

								tbl24.mobile_button = fn27("ManualSpam", udim2(1, -140, 0.5, 0), function()
									tbl24.set_manual(not tbl24.manual_on)
								end)
							end

							tbl24.mobile_button.Visible = config.mobile_manual_spam_button
							tbl26.update_button()
							tbl24.update_button()
						end

						spam:AddToggle("manual notify", config.manual_notify or false, function(manualNotify)
							config.manual_notify = manualNotify
						end)

						visual:AddToggle("ability esp", config.ability_esp or false, function(abilityEsp)
							config.ability_esp = abilityEsp

							for k, v86 in tbl25.labels, nil, nil do
								if v86 and v86.Parent then
									local attribute = k:GetAttribute("EquippedAbility")
									v86.Text = attribute and k.DisplayName .. " [" .. attribute .. "]" or k.DisplayName
									v86.Visible = abilityEsp
								end
							end
						end)

						do
							local tbl27 = {
								enabled = config.unlock_all or false,
								ready = false,
								shop_controller = nil,
								shop_api = nil,
								shop = nil,
								swords = nil,
								sword_fn = tbl18.sword_fn,
								selected_sword = nil,
								original_sword = nil,
								explosion_module = nil,
								explosion_original = nil,
								explosion_hooked = false,
								selected_explosion = nil,
							}

							tbl27.unlock_originals = setmetatable({}, { __mode = "k" })
							tbl27.unlocked = {}
							tbl27.shadow_connections = setmetatable({}, { __mode = "k" })
							tbl27.page_connections = {}
							tbl27.refresh_generation = {}
							tbl27.modern_originals = setmetatable({}, { __mode = "k" })
							tbl27.modern_tag = "oxy_unlock_all"
							tbl27.original_set_equipped = nil
							tbl27.original_buy_fns = {}
							tbl27.parry_connections = tbl18.parry_connections
							tbl27.fire_connections = tbl18.fire_sword_connections
							tbl27.play_parry = tbl18.play_parry
							tbl27.chroma_bound = false
							tbl27.character_connection = nil
							tbl27.added_connection = nil
							tbl27.sword_attr_connection = nil

							local function fn27(arg, arg2)
								v74(function()
									if arg2 then
										arg:Enable()
									else
										arg:Disable()
									end
								end)
							end

							tbl27.set_sword_override = function(arg, arg2)
								for _, v86 in arg.parry_connections, nil, nil do
									fn27(v86, not arg2)
								end

								for _, v86 in arg.fire_connections, nil, nil do
									fn27(v86, not arg2)
								end
							end

							tbl27.apply_chroma = function(arg, arg2, arg3)
								local colorConfig = arg3.ColorConfig or arg3.TweenColorConfig
								local flag14 = not colorConfig
								local pos

								if flag14 then
									pos = arg3.Name:find("Chroma") or arg3.Name:find("Rainbow")
								else
									pos = flag14
								end

								if pos then
									colorConfig = "Chroma"
								end

								if colorConfig then
									arg2:SetAttribute("ColorConfig", colorConfig)
									arg2:AddTag("TweenColor")
								end
							end

							tbl27.slot_fav_visual = function(arg, arg2, arg3)
								if not arg3 or not arg3:IsA("GuiObject") then
									return
								end
								local attribute = arg3:GetAttribute("Name")
								if not attribute or attribute == "" then
									return
								end
								local v86 = arg:is_fav(arg2, attribute)
								local favorited = arg3:FindFirstChild("Favorited")

								if favorited and favorited:IsA("ImageLabel") then
									favorited.Visible = v86

									if v86 then
										favorited.Image = "rbxassetid://15697987058"
									end
								end

								local shadow = arg3:FindFirstChild("Shadow")

								if shadow and arg.unlocked[arg2] then
									shadow.Enabled = false
								end
							end

							tbl27.native_fav_map = function(arg)
								if arg.native_map then
									return arg.native_map
								end

								if not arg.shop_controller or v76(arg.shop_controller._inventoryPages) ~= "table" then
									return nil
								end

								for _, v86 in arg.shop_controller._inventoryPages, nil, nil do
									if v76(v86) ~= "table" or v76(v86.MarkDirty) ~= "function" then
										continue
									end
									local v87, v88 = v74(debug.getupvalues, v86.MarkDirty)
									if not v87 or v76(v88) ~= "table" then
										continue
									end

									for _, v89 in v88, nil, nil do
										if v76(v89) ~= "function" then
											continue
										end
										local v90, v91 = v74(debug.getupvalues, v89)
										if not v90 or v76(v91) ~= "table" then
											continue
										end

										for _, v92 in v91, nil, nil do
											if v76(v92) ~= "function" then
												continue
											end
											local v93, v94 = v74(debug.getupvalues, v92)
											if not v93 or v76(v94) ~= "table" then
												continue
											end

											for _, v95 in v94, nil, nil do
												if v76(v95) == "table" and v95.Sword ~= nil and v95.Explosion ~= nil and not v95._virtualItems then
													arg.native_map = v95
													return v95
												end
											end
										end
									end
								end

								return nil
							end

							tbl27.sync_fav_map = function(arg, arg2)
								local v86 = arg:native_fav_map()
								if not v86 then
									return
								end
								local v87 = v86[arg2]
								if v76(v87) ~= "table" then
									return
								end
								local favoriteSwords = arg2 == "Sword" and config.favorite_swords or arg2 == "Explosion" and config.favorite_explosions or {}

								for k in v87, nil, nil do
									if not favoriteSwords[k] then
										v87[k] = nil
									end
								end

								for k, v88 in favoriteSwords, nil, nil do
									v88 = v88 and true
									v87[k] = v88 or nil
								end
							end

							tbl27.is_fav = function(arg, arg2, arg3)
								if arg2 == "Sword" then
									return config.favorite_swords and config.favorite_swords[arg3] == true
								end

								if arg2 == "Explosion" then
									if false then
										while true do
										end
									end

									return config.favorite_explosions and config.favorite_explosions[arg3] == true
								end

								return false
							end

							tbl27.is_deleted = function(arg, arg2, arg3)
								if arg2 == "Sword" then
									return config.deleted_swords and config.deleted_swords[arg3] == true
								end

								if arg2 == "Explosion" then
									return config.deleted_explosions and config.deleted_explosions[arg3] == true
								end
								return false
							end

							tbl27.refresh_shop_item = function(arg, arg2, arg3, arg4)
								local shopController = arg.shop_controller and arg.shop_controller._virtualItems[arg2]
								local shopController2 = arg.shop_controller and arg.shop_controller._inventoryPages[arg2]

								if v76(shopController) == "table" then
									for _, v86 in shopController, nil, nil do
										if v86.Name == arg3 then
											v86.Section = arg4 and "Owned" or "Unowned"

											if v86.OwnsItem and v76(v86.OwnsItem.Set) == "function" then
												v74(v86.OwnsItem.Set, v86.OwnsItem, arg4)
											end

											if not arg4 then
												v86.IsFavorited = false
												v86.Name_ = (v86.Name_ or v86.Name):gsub("^#", "")
												v86.LayoutOrder = v86.OriginalLayoutOrder or v86.LayoutOrder or 0
											end

											if shopController2 and shopController2.MarkDirty then
												shopController2.MarkDirty(v86, false, true)
											end

											break
										end
									end
								end

								if shopController2 and shopController2.MarkDirty then
									shopController2.MarkDirty(nil, true, true)
								end
							end

							tbl27.delete_item = function(arg, arg2, arg3)
								if arg2 == "Sword" then
									config.deleted_swords = config.deleted_swords or {}
									config.deleted_swords[arg3] = true

									if config.favorite_swords then
										config.favorite_swords[arg3] = nil
									end

									if arg.selected_sword == arg3 then
										arg:restore_sword()
									end
								elseif arg2 == "Explosion" then
									config.deleted_explosions = config.deleted_explosions or {}
									config.deleted_explosions[arg3] = true

									if config.favorite_explosions then
										config.favorite_explosions[arg3] = nil
									end

									if arg.selected_explosion == arg3 then
										arg.selected_explosion = nil
									end
								end

								v74(tbl19.save)
								arg:sync_fav_map(arg2)

								if arg.shop_controller then
									arg:refresh_shop_item(arg2, arg3, false)
								end

								arg:refresh_selected()
								if not flag3 then
									return
								end
							end

							tbl27.undelete_item = function(arg, arg2, arg3)
								if arg2 == "Sword" and config.deleted_swords then
									config.deleted_swords[arg3] = nil
								elseif arg2 == "Explosion" and config.deleted_explosions then
									config.deleted_explosions[arg3] = nil
								end

								v74(tbl19.save)
								arg:sync_fav_map(arg2)

								if arg.shop_controller then
									arg:refresh_shop_item(arg2, arg3, true)
								end

								arg:refresh_selected()
							end

							tbl27.toggle_fav = function(arg, arg2, arg3)
								if arg:is_deleted(arg2, arg3) then
									return
								end

								if arg2 == "Sword" then
									config.favorite_swords = config.favorite_swords or {}
									config.favorite_swords[arg3] = config.favorite_swords[arg3] and nil or true
								elseif arg2 == "Explosion" then
									config.favorite_explosions = config.favorite_explosions or {}
									config.favorite_explosions[arg3] = config.favorite_explosions[arg3] and nil or true
								end

								v74(tbl19.save)
								arg:sync_fav_map(arg2)
								local virtualItems = arg.shop_controller and arg.shop_controller._virtualItems and arg.shop_controller._virtualItems[arg2]
								local inventoryPages = arg.shop_controller and arg.shop_controller._inventoryPages and arg.shop_controller._inventoryPages[arg2]
								local v86 = arg:is_fav(arg2, arg3)

								if v76(virtualItems) == "table" then
									for _, v87 in virtualItems, nil, nil do
										if v87.Name == arg3 then
											v87.IsFavorited = v86

											if v87.OwnsItem and v76(v87.OwnsItem.Set) == "function" then
												v74(v87.OwnsItem.Set, v87.OwnsItem, true)
											end

											local originalLayoutOrder = v87.OriginalLayoutOrder or v87.LayoutOrder or 0
											v87.OriginalLayoutOrder = originalLayoutOrder

											if v86 then
												v87.LayoutOrder = originalLayoutOrder - 1000
												v87.Name_ = "#" .. (v87.Name_ or v87.Name):gsub("^#", "")
											else
												v87.LayoutOrder = originalLayoutOrder
												v87.Name_ = (v87.Name_ or v87.Name):gsub("^#", "")
											end

											break
										end
									end
								end

								if inventoryPages and inventoryPages.MarkDirty then
									inventoryPages.MarkDirty(nil, true, true)
								end

								arg:refresh_selected()
							end

							tbl27.refresh_favs = function(arg, arg2)
								if not arg.shop_controller then
									return
								end
								arg:sync_fav_map(arg2)
								local v86 = arg.shop_controller._virtualItems[arg2]
								local v87 = arg.shop_controller._inventoryPages[arg2]
								if v76(v86) ~= "table" then
									return
								end

								for _, v88 in v86, nil, nil do
									local v89 = arg:is_fav(arg2, v88.Name)
									v88.IsFavorited = v89
									local ownsItem = v88.OwnsItem

									if ownsItem then
										local v90 = "function"
										ownsItem = v76(v88.OwnsItem.Set) == v90
									end

									if ownsItem then
										v74(v88.OwnsItem.Set, v88.OwnsItem, true)
									end

									local originalLayoutOrder = v88.OriginalLayoutOrder or v88.LayoutOrder or 0
									v88.OriginalLayoutOrder = originalLayoutOrder

									if v89 then
										v88.LayoutOrder = originalLayoutOrder - 1000
										v88.Name_ = "#" .. (v88.Name_ or v88.Name):gsub("^#", "")
									else
										v88.LayoutOrder = originalLayoutOrder
										v88.Name_ = (v88.Name_ or v88.Name):gsub("^#", "")
									end
								end

								if v87 and v87.MarkDirty then
									v87.MarkDirty(nil, true, true)
								end
							end

							tbl27.equip_sword = function(arg, arg2, arg3)
								if not arg.swords then
									return false
								end
								local flag14 = not arg3

								if flag14 and arg:is_deleted("Sword", arg2) then
									arg:undelete_item("Sword", arg2)
								end

								local sword = arg.swords:GetSword(arg2)
								if not sword then
									return false
								end
								local character = localPlayer.Character
								if not character then
									return false
								end

								if flag14 and not arg.original_sword then
									arg.original_sword = localPlayer:GetAttribute("CurrentlyEquippedSword") or character:GetAttribute("CurrentlyEquippedSword")
								end

								if arg3 then
									arg.selected_sword = nil
								else
									arg.selected_sword = sword.Name
									config.last_equipped_sword = sword.Name
									arg:set_sword_override(true)
								end

								localPlayer:SetAttribute("CurrentlyEquippedSword", sword.Name)
								character:SetAttribute("CurrentlyEquippedSword", sword.Name)

								v74(function()
									local equipSwordTo = arg.swords.EquipSwordTo

									for k, v86 in debug.getupvalues(equipSwordTo) do
										if v86 == true then
											debug.setupvalue(equipSwordTo, k, false)
											break
										end
									end

									if not (n26 >= 1437) then
										return
									end

									while true do
									end
								end)

								if not v74(function()
									arg.swords:EquipSwordTo(character, sword.Name)
								end) then
									return false
								end
								local v86 = character:FindFirstChild(sword.Name)

								if v86 then
									if true then
										arg:apply_chroma(v86, sword)
									else
										while true do
										end
									end
								end

								if arg.sword_fn then
									v74(arg.sword_fn, sword.Name)
								end

								return true
							end

							tbl27.restore_sword = function(arg)
								if arg.original_sword and arg.original_sword ~= "" then
									arg:equip_sword(arg.original_sword, true)
								else
									arg.selected_sword = nil
								end

								arg.original_sword = nil
								arg:set_sword_override(false)
							end

							tbl27.ensure_explosion_wrap = function(arg)
								if arg.explosion_hooked or not arg.explosion_module then
									return
								end
								arg.explosion_hooked = true
								arg.explosion_original = arg.explosion_module.PlayExplosion

								arg.explosion_module.PlayExplosion = function(arg2, arg3, arg4, arg5, arg6, arg7, arg8)
									if tbl27.enabled and tbl27.selected_explosion and tbl27.selected_explosion ~= "" and arg8 and arg7 == localPlayer.Character then
										arg3 = tbl27.selected_explosion
									end

									return tbl27.explosion_original(arg2, arg3, arg4, arg5, arg6, arg7, arg8)
								end
							end

							tbl27.equip_explosion = function(arg, selectedExplosion)
								if arg:is_deleted("Explosion", selectedExplosion) then
									arg:undelete_item("Explosion", selectedExplosion)
								end

								arg.selected_explosion = selectedExplosion
								config.last_equipped_explosion = selectedExplosion
								arg:ensure_explosion_wrap()
								return true
							end

							tbl27.bind_shadow = function(arg, arg2, arg3)
								if arg.shadow_connections[arg3] then
									return
								end

								local function fn28()
									if arg.unlocked[arg2] and arg3.Parent and arg3.Enabled then
										arg3.Enabled = false
									end
								end

								arg.shadow_connections[arg3] = arg3:GetPropertyChangedSignal("Enabled"):Connect(fn28)
								fn28()
							end

							tbl27.refresh_visuals = function(arg, arg2)
								if arg.shop_controller then
									local v86 = arg.shop_controller._inventoryPages[arg2]
									local v87 = arg.shop_controller._virtualItems[arg2]
									local flag14 = not v86 or not v86.Scroll

									if not flag14 then
										local v88 = "table"
										flag14 = v76(v87) ~= v88
									end

									if flag14 then
										return
									end

									if not arg.page_connections[arg2] and v86.ScrollingFrame then
										arg.page_connections[arg2] = v86.ScrollingFrame.DescendantAdded:Connect(function(descendant)
											if descendant:IsA("GuiObject") then
												defer(function()
													arg:slot_fav_visual(arg2, descendant)
													local shadow = descendant:FindFirstChild("Shadow") or descendant.Name == "Shadow" and descendant

													if shadow and arg.unlocked[arg2] then
														arg:bind_shadow(arg2, shadow)
													end
												end)
											end
										end)
									end

									defer(function()
										for _, v88 in v87, nil, nil do
											local v89, v90 = v74(v86.Scroll.GetRenderedSlot, v88)

											if v89 and v90 then
												arg:slot_fav_visual(arg2, v90)
												local shadow = v90:FindFirstChild("Shadow")

												if shadow then
													if arg.unlocked[arg2] then
														arg:bind_shadow(arg2, shadow)
													else
														shadow.Enabled = not v88.OwnsItem:Get()
													end
												end
											end
										end
									end)

									return
								end

								if not (n25 <= 3230) then
									return
								end

								while true do
								end
							end

							tbl27.set_category_unlock = function(arg, arg2, arg3)
								if not arg.shop_controller then
									return
								end

								if arg3 then
									if n26 > 1425 then
										while true do
										end
									else
										arg:sync_fav_map(arg2)
									end
								end

								local v86 = arg.shop_controller._virtualItems[arg2]
								local v87 = arg.shop_controller._inventoryPages[arg2]
								if v76(v86) ~= "table" then
									return
								end

								if v87 and v87.BeginBatch then
									v87.BeginBatch()
								end

								if arg3 then
									arg.unlocked[arg2] = true
									local tbl28 = {}

									for _, v88 in v86, nil, nil do
										if v88.InventoryKey then
											tbl28[v88.Name] = true
										end
									end

									for _, v88 in v86, nil, nil do
										if not arg.unlock_originals[v88] then
											arg.unlock_originals[v88] = {
												Section = v88.Section,
												ForceHide = v88.ForceHide,
												OriginalLayoutOrder = v88.OriginalLayoutOrder or v88.LayoutOrder,
											}
										end

										local v89 = arg:is_deleted(arg2, v88.Name)
										local v90 = v89 and "Unowned" or "Owned"
										local flag14 = false

										if v88.Section ~= v90 then
											v88.Section = v90
											flag14 = true
										end

										if v88.OwnsItem and v76(v88.OwnsItem.Set) == "function" then
											v74(v88.OwnsItem.Set, v88.OwnsItem, not v89)
										end

										local isFavorited = not v89 and arg:is_fav(arg2, v88.Name)
										v88.IsFavorited = isFavorited
										local originalLayoutOrder = v88.OriginalLayoutOrder or v88.LayoutOrder or 0
										v88.OriginalLayoutOrder = originalLayoutOrder
										local layoutOrder = originalLayoutOrder - (isFavorited and 1000 or 0)

										if v88.LayoutOrder ~= layoutOrder then
											v88.LayoutOrder = layoutOrder
											flag14 = true
										end

										if isFavorited then
											local name2 = "#" .. (v88.Name_ or v88.Name):gsub("^#", "")

											if v88.Name_ ~= name2 then
												v88.OriginalName_ = v88.OriginalName_ or v88.Name_
												v88.Name_ = name2
												flag14 = true
											end
										else
											local name2 = (v88.Name_ or v88.Name):gsub("^#", "")

											if v88.Name_ ~= name2 then
												v88.Name_ = name2
												flag14 = true
											end
										end

										local forceHide = not v88.InventoryKey and tbl28[v88.Name] or false

										if v88.ForceHide ~= forceHide then
											v88.ForceHide = forceHide
											flag14 = true
										end

										if flag14 and v87 and v87.MarkDirty then
											v87.MarkDirty(v88, false, true)
										end
									end
								else
									arg.unlocked[arg2] = nil

									for _, v88 in v86, nil, nil do
										local v89 = arg.unlock_originals[v88]

										if v89 then
											local flag14 = false

											if v88.Section ~= v89.Section then
												v88.Section = v89.Section
												flag14 = true
											end

											if v88.ForceHide ~= v89.ForceHide then
												v88.ForceHide = v89.ForceHide
												flag14 = true
											end

											if flag14 and v87 and v87.MarkDirty then
												v87.MarkDirty(v88, false, true)
											end

											arg.unlock_originals[v88] = nil
										end
									end
								end

								if v87 and v87.MarkDirty then
									v87.MarkDirty(nil, true, true)
								end

								if v87 and v87.EndBatch then
									v87.EndBatch()
								end

								arg:refresh_visuals(arg2)
							end

							tbl27.expected_size = function(arg, arg2)
								local n31

								if arg2 == "Sword" and arg.swords then
									local v86, v87 = v74(function()
										return arg.swords:GetCollection()
									end)

									local flag14 = v86 and v76(v87) == "table"
									n31 = 0

									if flag14 then
										for k in v87, nil, nil do
											n31 += 1
										end
									end
								else
									n31 = 0

									if arg2 == "Explosion" then
										local misc2 = v79:FindFirstChild("Misc")
										misc2 = misc2 and misc2:FindFirstChild("DataExplosions")

										if misc2 then
											for _, v86 in misc2:GetChildren() do
												if not v86:GetAttribute("Hidden") then
													n31 += 1
												end
											end
										end
									end
								end

								return n31
							end

							tbl27.schedule_refresh = function(arg, arg2)
								arg.refresh_generation[arg2] = (arg.refresh_generation[arg2] or 0) + 1
								local v86 = arg.refresh_generation[arg2]

								if v76(arg.shop_controller._loadInventoryPage) == "function" then
									v74(arg.shop_controller._loadInventoryPage, arg2)
								end

								spawn_(function()
									local v87 = arg:expected_size(arg2)
									local n31 = -1
									local n32 = 0

									for i = 1, 120 do
										heartbeat:Wait()
										if not arg.enabled or not arg.unlocked[arg2] or arg.refresh_generation[arg2] ~= v86 then
											return
										end
										local v88 = arg.shop_controller._virtualItems[arg2]
										local n33 = 0

										if v76(v88) == "table" then
											for _, v89 in v88, nil, nil do
												if not v89.InventoryKey then
													n33 += 1
												end
											end
										end

										if n33 == n31 and n33 > 0 then
											n32 += 1
										else
											n32 = 0
											n31 = n33
										end

										if v87 > 0 and n33 >= v87 or v87 == 0 and n32 >= 5 then
											heartbeat:Wait()
											arg:set_category_unlock(arg2, true)
											return
										end
									end

									if arg.enabled and arg.unlocked[arg2] and arg.refresh_generation[arg2] == v86 then
										arg:set_category_unlock(arg2, true)
									end
								end)
							end

							tbl27.refresh_selected = function(arg)
								if not arg.shop_controller or not arg.shop then
									return
								end
								local selectedItem = arg.shop_controller._selectedItem
								if not selectedItem then
									return
								end
								local buyButton = arg.shop.Holder.InfoBG:FindFirstChild("BuyButton")
								local favorite = arg.shop.Holder:FindFirstChild("Favorite")
								local delete = arg.shop.Holder.InfoBG:FindFirstChild("Delete")

								if arg.enabled and arg.unlocked[selectedItem.type] and (selectedItem.type == "Sword" or selectedItem.type == "Explosion") then
									local virtualItems = arg.shop_controller._virtualItems and arg.shop_controller._virtualItems[selectedItem.type]
									local v86 = nil

									if virtualItems then
										v86 = arg.shop_controller._virtualItems[selectedItem.type][selectedItem.key or selectedItem.name]
									end

									if arg:is_deleted(selectedItem.type, selectedItem.name) or v86 and v86.Section == "Unowned" then
										if buyButton then
											buyButton.Visible = false
										end

										if favorite then
											favorite.Visible = false
										end

										if delete then
											delete.Visible = true
										end
									else
										if buyButton then
											buyButton.Visible = true

											if buyButton:FindFirstChild("PriceTag") and buyButton.PriceTag:FindFirstChild("TextLabel") then
												buyButton.PriceTag.TextLabel.Visible = true
												buyButton.PriceTag.TextLabel.Text = "Equip"
											end

											if buyButton:FindFirstChild("PriceTag") and buyButton.PriceTag:FindFirstChild("Price") then
												buyButton.PriceTag.Price.Visible = false
											end
										end

										if favorite then
											favorite.Visible = true
											local v87 = arg:is_fav(selectedItem.type, selectedItem.name)
											favorite.Image = v87 and "rbxassetid://15697987058" or "rbxassetid://15697981750"
											favorite.HoverImage = v87 and "rbxassetid://15697983062" or "rbxassetid://15697987058"
										end

										if delete then
											delete.Visible = true
										end
									end
								end
							end

							tbl27.set_modern_unlock = function(arg, arg2, arg3)
								local shopApi = arg.shop_api
								local ownedBases = shopApi and shopApi.OwnedBases and shopApi.OwnedBases[arg2]
								if v76(ownedBases) ~= "table" then
									return
								end

								for k, v86 in ownedBases, nil, nil do
									local v87, v88 = v74(shopApi.ParseItemKey, shopApi, arg2, { Name = k })
									v87 = v87 and v88
									local ownedCopies = nil

									if v87 then
										local flag14, v89 = v74(shopApi.GetItemData, shopApi, arg2, v88)
										flag14 = flag14 and v76(v89) == "table"
										ownedCopies = nil

										if flag14 then
											ownedCopies = v89.OwnedCopies
										end
									end

									local flag14 = arg3 and ownedCopies and v76(ownedCopies.Get) == "function"

									if flag14 then
										local v89 = "function"
										flag14 = v76(ownedCopies.Set) == v89
									end

									if flag14 then
										if not arg.modern_originals[ownedCopies] then
											local v89, v90 = v74(ownedCopies.Get, ownedCopies)

											if v89 then
												arg.modern_originals[ownedCopies] = { Value = v90 }
											end
										end

										local v89, v90 = v74(ownedCopies.Get, ownedCopies)

										if v89 and (v76(v90) ~= "number" or v90 < 1) then
											v74(ownedCopies.Set, ownedCopies, 1)
										end
									end

									if v86 and v76(v86.SetTag) == "function" then
										v74(v86.SetTag, v86, arg.modern_tag, arg3 and true or nil)
									end

									if not arg3 and ownedCopies then
										local v89 = arg.modern_originals[ownedCopies]

										if v89 and v76(ownedCopies.Set) == "function" then
											local state = v86 and v86.State
											local flag15 = state and v76(state.Get) == "function"
											local flag16 = false

											if flag15 then
												local v90, v91 = v74(state.Get, state)
												flag16 = v90 and v91 == true
											end

											if not flag16 then
												v74(ownedCopies.Set, ownedCopies, v89.Value)
											end

											arg.modern_originals[ownedCopies] = nil
										end
									end
								end
							end

							tbl27.hook_modern_shop = function(arg)
								local shopApi = arg.shop_api
								if not shopApi or arg.original_set_equipped then
									return
								end

								if v76(shopApi.SetEquipped) ~= "function" then
									return
								end
								arg.original_set_equipped = shopApi.SetEquipped

								shopApi.SetEquipped = function(arg2, ...)
									local tbl28 = { ... }
									local itemType = tbl28[1]
									local name2 = tbl28[2]

									if v76(itemType) == "table" then
										name2 = itemType.Name
										itemType = itemType.ItemType
									elseif v76(name2) == "table" then
										name2 = name2.Name
									end

									local ownedBases = shopApi.OwnedBases
									local v86 = "table"
									local flag14 = v76(ownedBases) == v86 and ownedBases[itemType]
									local flag15 = v76(flag14) == "table" and flag14[name2] ~= nil
									local enabled = tbl27.enabled
									local flag16

									if enabled then
										flag16 = flag15 or itemType == "Sword" or itemType == "Explosion"
									else
										flag16 = enabled
									end

									if flag16 then
										local flag17 = itemType == "Sword"
										local pos

										if flag17 then
											pos = flag17
										else
											pos = v75(itemType):lower():find("sword")
										end

										if pos and tbl27:equip_sword(name2, false) then
											return true
										end
										local flag18 = itemType == "Explosion"

										if not flag18 then
											flag18 = v75(itemType):lower():find("explosion")
										end

										if flag18 then
											return tbl27:equip_explosion(name2)
										end
									end

									return tbl27.original_set_equipped(arg2, v77(tbl28))
								end
							end

							tbl27.hook_shop = function(arg)
								local shop = localPlayer:WaitForChild("PlayerGui"):FindFirstChild("Shop")
								local holder = shop and shop:FindFirstChild("Holder")
								local infoBG = holder and holder:FindFirstChild("InfoBG")
								local buyButton = infoBG and infoBG:FindFirstChild("BuyButton")
								if not shop or not buyButton then
									return false
								end
								arg.shop = shop

								for _, v86 in getconnections(buyButton.Activated) do
									if v86 and v86.Function then
										insert(arg.original_buy_fns, v86.Function)
										v86:Disable()
									end
								end

								holder = holder and holder:FindFirstChild("Favorite")

								if holder then
									for _, v86 in getconnections(holder.Activated) do
										if v86 and v86.Function then
											v86:Disable()
										end
									end

									holder.Activated:Connect(function()
										local selectedItem = arg.shop_controller and arg.shop_controller._selectedItem

										if selectedItem and arg.enabled and (selectedItem.type == "Sword" or selectedItem.type == "Explosion") then
											arg:toggle_fav(selectedItem.type, selectedItem.name)
										end
									end)
								end

								infoBG = infoBG and infoBG:FindFirstChild("Delete")

								if infoBG then
									for _, v86 in getconnections(infoBG.Activated) do
										if v86 and v86.Function then
											v86:Disable()
										end
									end

									infoBG.Activated:Connect(function()
										local selectedItem = arg.shop_controller and arg.shop_controller._selectedItem
										local flag14 = not selectedItem or not arg.enabled
										local flag15

										if flag14 then
											flag15 = flag14
										else
											flag15 = selectedItem.type ~= "Sword" and selectedItem.type ~= "Explosion"
										end

										if flag15 then
											return
										end

										if arg:is_deleted(selectedItem.type, selectedItem.name) then
											arg:undelete_item(selectedItem.type, selectedItem.name)
										else
											arg:delete_item(selectedItem.type, selectedItem.name)
										end
									end)
								end

								game:GetService("GuiService"):GetPropertyChangedSignal("SelectedObject"):Connect(function()
									if not arg.enabled or not arg.shop or not arg.shop.Enabled then
										return
									end

									defer(function()
										arg:refresh_selected()
									end)
								end)

								v80.InputBegan:Connect(function(input, gameProcessed)
									if true then
										if gameProcessed or not arg.enabled or not arg.shop or not arg.shop.Enabled or input.UserInputType ~= Enum.UserInputType.Gamepad1 then
											return
										end
										local selectedItem = arg.shop_controller and arg.shop_controller._selectedItem
										if not selectedItem then
											return
										end

										if input.KeyCode == Enum.KeyCode.ButtonY then
											if selectedItem.type == "Sword" or selectedItem.type == "Explosion" then
												arg:toggle_fav(selectedItem.type, selectedItem.name)
											end
										elseif input.KeyCode == Enum.KeyCode.ButtonX then
											if selectedItem.type == "Sword" or selectedItem.type == "Explosion" then
												if arg:is_deleted(selectedItem.type, selectedItem.name) then
													arg:undelete_item(selectedItem.type, selectedItem.name)
												else
													arg:delete_item(selectedItem.type, selectedItem.name)
												end
											end
										elseif input.KeyCode == Enum.KeyCode.ButtonA then
											local infoBG2 = arg.shop and arg.shop:FindFirstChild("Holder") and arg.shop.Holder:FindFirstChild("InfoBG")
											infoBG2 = infoBG2 and infoBG2:FindFirstChild("BuyButton")

											if selectedItem.type == "Sword" then
												arg:equip_sword(selectedItem.name, false)

												if infoBG2 and infoBG2:FindFirstChild("PriceTag") and infoBG2.PriceTag:FindFirstChild("TextLabel") then
													infoBG2.PriceTag.TextLabel.Text = "Equipped"
												end
											elseif selectedItem.type == "Explosion" then
												arg:equip_explosion(selectedItem.name)

												if infoBG2 and infoBG2:FindFirstChild("PriceTag") and infoBG2.PriceTag:FindFirstChild("TextLabel") then
													infoBG2.PriceTag.TextLabel.Text = "Equipped"
												end
											end
										end
									else
										while true do
										end
									end
								end)

								arg.shop_controller.itemSelected:Connect(function(arg2)
									if arg2 and arg.unlocked[arg2.type] then
										arg:set_category_unlock(arg2.type, true)
									end

									defer(function()
										arg:refresh_selected()
									end)
								end)

								buyButton.Activated:Connect(function()
									local selectedItem = arg.shop_controller._selectedItem
									if not selectedItem then
										return
									end

									if arg.enabled and arg.unlocked[selectedItem.type] then
										if arg:is_deleted(selectedItem.type, selectedItem.name) then
											arg:undelete_item(selectedItem.type, selectedItem.name)
										end

										if selectedItem.type == "Sword" then
											if arg:equip_sword(selectedItem.name, false) then
												buyButton.PriceTag.TextLabel.Text = "Equipped"
											end

											return
										end

										if selectedItem.type == "Explosion" then
											arg:equip_explosion(selectedItem.name)
											buyButton.PriceTag.TextLabel.Text = "Equipped"
											return
										end
									end

									for _, v86 in arg.original_buy_fns, nil, nil do
										spawn_(v86)
									end
								end)

								local function fn28()
									if not arg.shop.Enabled or not arg.enabled then
										return
									end

									for _, v86 in { "Sword", "Explosion" }, nil, nil do
										if arg.unlocked[v86] then
											arg:schedule_refresh(v86)
										end
									end
								end

								arg.shop:GetPropertyChangedSignal("Enabled"):Connect(function()
									if arg.shop.Enabled then
										defer(fn28)
									end
								end)

								if arg.shop.Enabled then
									defer(fn28)
								end

								return true
							end

							tbl27.hook_sword_fx = function(arg)
								local shared = v79:FindFirstChild("Shared")
								shared = shared and shared:FindFirstChild("ReplicatedInstances")
								shared = shared and shared:FindFirstChild("Swords")

								if shared then
									local v86, v87 = v74(require, shared)

									if v86 then
										arg.swords = v87
									end
								end

								local remotes2 = v79:FindFirstChild("Remotes")
								remotes2 = remotes2 and remotes2:FindFirstChild("ParrySuccessAll")

								if remotes2 then
									remotes2.OnClientEvent:Connect(function(...)
										if not arg.enabled or not arg.selected_sword or not arg.play_parry then
											return
										end
										local tbl28 = { ... }
										local sword = arg.swords and arg.swords:GetSword(arg.selected_sword)

										if sword and tbl28[4] and v75(tbl28[4]) == name then
											tbl28[1] = sword.SlashName
											tbl28[3] = sword.Name
										end

										return arg.play_parry(v77(tbl28))
									end)
								end
							end

							tbl27.setup_character = function(arg, arg2)
								if arg.character_connection then
									v74(function()
										arg.character_connection:Disconnect()
									end)

									arg.character_connection = nil
								end

								if not arg2 then
									return
								end

								if arg.enabled and config.last_equipped_sword and config.last_equipped_sword ~= "" then
									defer(function()
										if not flag3 then
											return
										end

										if arg.enabled and config.last_equipped_sword ~= "" then
											arg:equip_sword(config.last_equipped_sword, false)
										end
									end)
								end

								local function fn28(child)
									if not arg.enabled or not child:IsA("Model") or not arg.swords or not arg.selected_sword then
										return
									end
									local sword = arg.swords:GetSword(child.Name)
									if not sword then
										return
									end

									if child.Name ~= arg.selected_sword then
										local selectedSword = arg.selected_sword

										defer(function()
											if arg.enabled and arg.selected_sword == selectedSword then
												arg:equip_sword(selectedSword, false)
											end
										end)
									else
										arg:apply_chroma(child, sword)

										if arg.sword_fn then
											defer(function()
												if arg.enabled and arg.selected_sword == child.Name then
													if true then
														v74(arg.sword_fn, child.Name)
													else
														while true do
														end
													end
												end
											end)
										end
									end
								end

								arg.character_connection = arg2.ChildAdded:Connect(fn28)

								for _, v86 in arg2:GetChildren() do
									fn28(v86)
								end
							end

							tbl27.hook_chroma = function(arg)
								if arg.chroma_bound then
									return
								end
								arg.chroma_bound = true

								arg.added_connection = localPlayer.CharacterAdded:Connect(function(character)
									arg:setup_character(character)
								end)

								if localPlayer.Character then
									defer(function()
										arg:setup_character(localPlayer.Character)
									end)
								end

								arg.sword_attr_connection = localPlayer:GetAttributeChangedSignal("CurrentlyEquippedSword"):Connect(function()
									local selectedSword = arg.selected_sword
									if not arg.enabled or not selectedSword or localPlayer:GetAttribute("CurrentlyEquippedSword") == selectedSword then
										return
									end
									localPlayer:SetAttribute("CurrentlyEquippedSword", selectedSword)

									if localPlayer.Character then
										localPlayer.Character:SetAttribute("CurrentlyEquippedSword", selectedSword)
									end

									if arg.sword_fn then
										v74(arg.sword_fn, selectedSword)
									end
								end)
							end

							tbl27.initialize = function(arg)
								local v86 = v79.Controllers:FindFirstChild("UI")
								local shopController = v86 and v86:FindFirstChild("ShopController")
								local v87 = v86 and v86:FindFirstChild("ShopControllerAPI")
								local v88, v89 = v74(require, shopController)
								local v90, v91 = v74(require, v87)
								local flag14 = not v88

								if not flag14 then
									local v92 = "table"
									flag14 = v76(v89) ~= v92
								end

								if flag14 then
									v89 = nil
								end

								if not v90 or v76(v91) ~= "table" then
									v91 = nil
								end

								if not v89 and not v91 then
									warn("[oxy] unlock all: failed to load shop controllers")
									return
								end
								arg.shop_controller = v89
								arg.shop_api = v91
								arg:hook_sword_fx()
								arg:hook_chroma()

								v74(function()
									arg.explosion_module = require(v79.Controllers.VFXController)
								end)

								arg:ensure_explosion_wrap()

								if arg.shop_controller then
									arg:hook_shop()
								end

								if arg.shop_api then
									arg:hook_modern_shop()
								end

								arg.ready = true
								arg:set_enabled(arg.enabled)

								if arg.enabled and config.last_equipped_sword and config.last_equipped_sword ~= "" then
									defer(function()
										if arg.enabled and config.last_equipped_sword ~= "" then
											arg:equip_sword(config.last_equipped_sword, false)
										end
									end)
								end

								if arg.enabled and config.last_equipped_explosion and config.last_equipped_explosion ~= "" then
									defer(function()
										if arg.enabled and config.last_equipped_explosion ~= "" then
											arg:equip_explosion(config.last_equipped_explosion)
										end
									end)
								end
							end

							tbl27.set_enabled = function(arg, arg2)
								arg.enabled = arg2 == true
								if not arg.ready then
									return
								end

								for _, v86 in { "Sword", "Explosion" }, nil, nil do
									if arg.enabled then
										if arg.shop_controller then
											arg:set_category_unlock(v86, true)
											arg:schedule_refresh(v86)
										end

										arg:set_modern_unlock(v86, true)
									else
										if arg.shop_controller then
											arg.refresh_generation[v86] = (arg.refresh_generation[v86] or 0) + 1
											arg:set_category_unlock(v86, false)
										end

										arg:set_modern_unlock(v86, false)
									end
								end

								if not arg.enabled then
									arg:restore_sword()
									arg.selected_explosion = nil
								else
									arg:refresh_selected()
								end
							end

							spawn_(function()
								tbl27:initialize()
							end)

							misc:AddToggle("unlock all", config.unlock_all or false, function(unlockAll)
								config.unlock_all = unlockAll
								tbl27:set_enabled(unlockAll)
							end)
						end
					end

					do
						local ScreenGui = nil

						misc:AddToggle("ball stats", config.ball_debug or false, function(ballDebug)
							config.ball_debug = ballDebug

							if ballDebug then
								ScreenGui = fn26("ScreenGui", { Parent = localPlayer:WaitForChild("PlayerGui"), ResetOnSpawn = false })

								local TextLabel = fn26("TextLabel", {
									Size = udim2(0.2, 0, 0.05, 0),
									Position = udim2(0.7, 0, 0.1, 0),
									TextSize = 26,
									BackgroundTransparency = 1,
									TextColor3 = Color3.new(1, 1, 1),
									Font = Enum.Font.Fantasy,
									Text = "waiting...",
									Parent = ScreenGui,
								})

								local tbl27 = {}

								tbl22.ball_stats = heartbeat:Connect(function()
									local v86 = tbl23.get_all()
									if not flag2 then
										return
									end

									if #v86 == 0 then
										TextLabel.Text = "waiting..."
										TextLabel.TextColor3 = Color3.new(1, 1, 1)
										return
									end

									local tbl28 = {}

									for _, v87 in v86, nil, nil do
										tbl28[v87] = true
									end

									for k in tbl27, nil, nil do
										if not tbl28[k] then
											tbl27[k] = nil
										end
									end

									local n31 = 0
									local v87 = nil

									for _, v88 in v86, nil, nil do
										local v89 = v88:FindFirstChild("zoomies")

										if v89 then
											local v90 = max(tbl27[v88] or 0, v89.VectorVelocity.Magnitude)
											tbl27[v88] = v90

											if v90 > n31 then
												n31 = v90
												v87 = v88
											end
										end
									end

									if v87 then
										local flag14 = n31 >= 2200
										TextLabel.Text = format("ball velocity: %.0f", n31) .. (flag14 and " (LIMIT!)" or "")
										TextLabel.TextColor3 = flag14 and Color3.new(1, 0, 0) or Color3.new(1, 1, 1)
									else
										TextLabel.Text = "waiting..."
										TextLabel.TextColor3 = Color3.new(1, 1, 1)
									end
								end)
							else
								if tbl22.ball_stats then
									tbl22.ball_stats:Disconnect()
									tbl22.ball_stats = nil
								end

								if ScreenGui then
									ScreenGui:Destroy()
									ScreenGui = nil
								end
							end
						end)
					end

					return
				end

				while true do
				end
			end
		end
	end
end