--[[

  /$$$$$$  /$$       /$$$$$$  /$$$$$$  /$$$$$$$$ /$$$$$$$ 
 /$$__  $$| $$      |_  $$_/ /$$__  $$| $$_____/| $$__  $$
| $$  \__/| $$        | $$  | $$  \__/| $$      | $$  \ $$
|  $$$$$$ | $$        | $$  | $$      | $$$$$   | $$  | $$
 \____  $$| $$        | $$  | $$      | $$__/   | $$  | $$
 /$$  \ $$| $$        | $$  | $$    $$| $$      | $$  | $$
|  $$$$$$/| $$$$$$$$ /$$$$$$|  $$$$$$/| $$$$$$$$| $$$$$$$/
 \______/ |________/|______/ \______/ |________/|_______/

              [ LEAKED BY SLICED ]
            [ discord.gg/pubmethod ]

]]
local sliced85, sliced86, localPlayer, sliced87, net, sliced88, sliced89, sliced90, keyboardEnabled, flag18
local slicedfn29, sliced91, tbl18, max, flag19, sliced92, flag20, autoRedeem, autoType, manual
local flag21, thread, slicedn32, slicedn33, listenKey, g, str7, tbl19, sliced93, sliced94
local flag22, autoListen, sliced95, sliced96, slicedfn30, slicedfn31, slicedfn32, slicedfn33, slicedfn34, slicedfn35
local slicedfn36, slicedfn37, slicedfn38, slicedfn39, slicedfn40, slicedfn41, tbl20, tbl21, gothamMedium, gothamBold
local gothamBlack, slicedfn42, slicedfn43, slicedfn44, slicedfn45, slicedfn46, slicedfn47, slicedfn48, slicedfn49, ScreenGui
local Main, Frame, Rag, sliced97, sliced98, slicedn34, sliced99, slicedfn50, TextBox, sliced100
local clear, redeem, slicedfn51, listen, Frame2, Frame3, TextButton, sliced101, sliced102, sliced103
local sliced104, sliced105, sliced106, start, sliced107, sliced108
do  -- LEAKED BY SLICED | discord.gg/pubmethod
	local visible, showKeybinds, slicedfn52, Settings, Frame4, Frame5, words
	do
		local tbl22, Frame6
		do
			do
				local sliced109
				do
					do
						local getupvalues_, getconnections_, setupvalue_  -- LEAKED BY SLICED | discord.gg/pubmethod
						do
							do
								local writeClipboard
								do
									do
										local slicedfn53 = cloneref or function(arg)
											return arg
										end
										local sliced110 = slicedfn53(game:GetService("Players"))
										sliced85 = slicedfn53(game:GetService("ReplicatedStorage"))  -- LEAKED BY SLICED | discord.gg/pubmethod
										sliced86 = slicedfn53(game:GetService("UserInputService"))
										sliced109 = slicedfn53(game:GetService("TweenService"))
										localPlayer = sliced110.LocalPlayer
										sliced87 = localPlayer:WaitForChild("PlayerGui")
										net = sliced85:WaitForChild("Packages"):WaitForChild("Net")
										sliced88 = slicedfn53(game:GetService("RunService"))
									end
									do
										sliced89 = localPlayer
										sliced90 = sliced87  -- LEAKED BY SLICED | discord.gg/pubmethod
										getupvalues_ = debug and debug.getupvalues or getupvalues
										do
											local sliced110 = getconnections
											if sliced110 then
												getconnections_ = sliced110
											else
												getconnections_ = debug and debug.getconnections
											end
										end  -- LEAKED BY SLICED | discord.gg/pubmethod
									end
									setupvalue_ = debug and debug.setupvalue or setupvalue
									do
										local sliced110 = setclipboard or toclipboard
										if sliced110 then
											writeClipboard = sliced110
										else
											writeClipboard = syn and syn.write_clipboard
										end
									end  -- LEAKED BY SLICED | discord.gg/pubmethod
								end
								do
									keyboardEnabled = sliced86.KeyboardEnabled
									flag18 = sliced86.TouchEnabled and not keyboardEnabled
									slicedfn29 = function()
										if not flag18 then
											return 1
										end
										local currentCamera = workspace.CurrentCamera  -- LEAKED BY SLICED | discord.gg/pubmethod
										currentCamera = currentCamera and currentCamera.ViewportSize.Y or 600
										local uiSize = _G.__RdmCfgStr and _G.__RdmCfgStr("uiSize", "MEDIUM") or "MEDIUM"
										local slicedn35 = uiSize == "BIG" and 1.15 or uiSize == "SMALL" and 0.8 or 1
										return math.clamp(currentCamera * 0.88 / 548, 0.5, 1.3) * slicedn35
									end
									sliced91 = slicedfn29()
									do
										local tbl23 = {}
										if readfile and isfile then
											local ok, result = pcall(function()  -- LEAKED BY SLICED | discord.gg/pubmethod
												if isfile("redeemer_settings.txt") then
													return readfile("redeemer_settings.txt")
												end
											end)
											if ok and type(result) == "string" then
												for match in result:gmatch("[^\n]+") do
													local match2, sliced110 = match:match("^(%w+)=(.*)$")
													if match2 then
														tbl23[match2] = sliced110  -- LEAKED BY SLICED | discord.gg/pubmethod
													end
												end
											end
										end
										_G.__RdmCfgBool = function(arg, arg2)
											local sliced110 = tbl23[arg]
											if sliced110 == "1" then
												return true
											end
											if sliced110 == "0" then  -- LEAKED BY SLICED | discord.gg/pubmethod
												return false
											end
											return arg2
										end
										_G.__RdmCfgStr = function(arg, arg2)
											local sliced110 = tbl23[arg]
											local sliced111 = "string"
											return type(sliced110) == sliced111 and sliced110 ~= "" and sliced110 or arg2
										end
										_G.__RdmCfgSet = function(arg, arg2)  -- LEAKED BY SLICED | discord.gg/pubmethod
											tbl23[arg] = type(arg2) == "boolean" and (arg2 and "1" or "0") or tostring(arg2)
											if not writefile then
												return
											end
											local tbl24 = {}
											for k, sliced110 in pairs(tbl23) do
												tbl24[#tbl24 + 1] = k .. "=" .. tostring(sliced110)
											end
											table.sort(tbl24)  -- LEAKED BY SLICED | discord.gg/pubmethod
											pcall(writefile, "redeemer_settings.txt", table.concat(tbl24, "\n"))
										end
									end
								end
								do
									tbl18 = {
										listenKey = Enum.KeyCode.F,
										maxFeed = 36,
									}
									tbl22 = { MAX = 0.15 }  -- LEAKED BY SLICED | discord.gg/pubmethod
									max = tbl22[_G.__RdmCfgStr("speed", "MAX")] or tbl22.MAX
									flag19 = _G.__RdmCfgBool("wordMode", false)
									sliced92 = 0.5
									flag20 = false
									autoRedeem = _G.__RdmCfgBool("autoRedeem", true)
									autoType = _G.__RdmCfgBool("autoType", true)
									manual = _G.__RdmCfgBool("manual", false)
									flag21 = false
									thread = nil  -- LEAKED BY SLICED | discord.gg/pubmethod
									slicedn32 = 0
									slicedn33 = 1
									listenKey = tbl18.listenKey
									g = Enum.KeyCode.G
									str7 = nil
									tbl19 = {}
									sliced93 = nil
									sliced94 = nil
									flag22 = false
									autoListen = _G.__RdmCfgBool("autoListen", true)  -- LEAKED BY SLICED | discord.gg/pubmethod
									sliced95 = _G.__RdmCfgBool("spamOnListen", true)
									showKeybinds = _G.__RdmCfgBool("showKeybinds", keyboardEnabled)
									sliced96 = _G.__RdmCfgBool("ignoreSystem", true)
									_G.__RdmDuo = _G.__RdmCfgBool("duo", false)
									_G.__SabClassifyDrop = function(arg)
										local str8 = tostring(arg or "")
										local str9 = str8:lower()
										local tbl23 = {}
										for match in str8:gmatch("[%w']+") do  -- LEAKED BY SLICED | discord.gg/pubmethod
											tbl23[#tbl23 + 1] = match
										end
										local slicedn35 = #tbl23
										if slicedn35 == 0 then
											return nil
										end
										local str10 = " " .. str9:gsub("[^%w]", " ") .. " "
										if str9:find("?", 1, true) then
											return "riddle"
										end  -- LEAKED BY SLICED | discord.gg/pubmethod
										for _, sliced110 in ipairs({
											" what ",
											" how ",
											" which ",
											" whose ",
											" when ",
											" who ",
											" whats ",
											" where ",  -- LEAKED BY SLICED | discord.gg/pubmethod
											" why ",
											" guess ",
											" riddle ",
											" answer ",
										}) do
											if str10:find(sliced110, 1, true) then
												return "riddle"
											end
										end
										if str10:find(" my ", 1, true) then  -- LEAKED BY SLICED | discord.gg/pubmethod
											return "riddle"
										end
										local flag23 = slicedn35 >= 2
										local pos
										if flag23 then
											pos = str10:find(" plus ", 1, true) or str9:find("+", 1, true)
										else
											pos = flag23
										end
										if pos then  -- LEAKED BY SLICED | discord.gg/pubmethod
											return "riddle"
										end
										if slicedn35 >= 4 and str10:find(" and ", 1, true) then
											return "riddle"
										end
										if str9:find("code", 1, true) then
											return "code"
										end
										for _, sliced110 in ipairs({ " redeem ", " type ", " enter ", " claim " }) do  -- LEAKED BY SLICED | discord.gg/pubmethod
											if str10:find(sliced110, 1, true) then
												return "code"
											end
										end
										if slicedn35 >= 7 then
											return "riddle"
										end
										if slicedn35 == 1 then
											return "code"  -- LEAKED BY SLICED | discord.gg/pubmethod
										end
										if slicedn35 <= 3 then
											local sliced110 = 0
											for _, sliced111 in ipairs(tbl23) do
												if #sliced111 >= 3 and (sliced111 == sliced111:upper() and sliced111:match("%a") or sliced111:match("%d")) then
													sliced110 += 1
												end
											end
											if sliced110 == slicedn35 then
												return "code"  -- LEAKED BY SLICED | discord.gg/pubmethod
											end
										end
										return nil
									end
									slicedfn30 = nil
									slicedfn52 = nil
									slicedfn31 = nil
									slicedfn32 = nil
									slicedfn33 = function(arg)  -- LEAKED BY SLICED | discord.gg/pubmethod
										if type(arg) ~= "string" then
											return tostring(arg)
										end
										return (arg:gsub("<[^>]->", ""))
									end
									slicedfn34 = function(arg)
										return (arg or ""):gsub("^%s+", ""):gsub("%s+$", "")
									end
									slicedfn35 = function(arg)  -- LEAKED BY SLICED | discord.gg/pubmethod
										if not writeClipboard then
											return false
										end
										return (pcall(writeClipboard, arg))
									end
									slicedfn36 = function(arg)
										local tbl23 = {}
										for match in arg:gmatch("[%w_]+") do
											tbl23[#tbl23 + 1] = match
										end  -- LEAKED BY SLICED | discord.gg/pubmethod
										return tbl23
									end
									slicedfn37 = function(arg)
										local sliced110 = nil
										for match in arg:gmatch("[%w_]+") do
											if #match >= 4 and match:match("%a") and (match:match("%u") or match:match("%d")) then
												sliced110 = match
											end
										end  -- LEAKED BY SLICED | discord.gg/pubmethod
										if sliced110 then
											return sliced110
										end
										for match in arg:gmatch("[%w_]+") do
											if #match >= 4 then
												return match
											end
										end
									end
									do
										local tbl23 = {
											leads = {
												"use",
												"using",
												"redeem",
												"type",
												"enter",
												"claim",
												"with",  -- LEAKED BY SLICED | discord.gg/pubmethod
												"grab",
												"got",
												"here is",
												"heres",
												"here's",
												"there is",
												"theres",
												"there's",
											},
											articles = {  -- LEAKED BY SLICED | discord.gg/pubmethod
												"",
												"the%s+",
												"a%s+",
												"an%s+",
												"this%s+",
												"your%s+",
												"new%s+",
											},
											patterns = {
												"code%s+is",  -- LEAKED BY SLICED | discord.gg/pubmethod
												"codes?%s+are",
												"code%s+for",
												"code%s+to%s+use",
												"code%s*[:%-]",
												"new%s+code",
												"free%s+code",
												"secret%s+code",
												"working%s+code",
												"another%s+code",
											},  -- LEAKED BY SLICED | discord.gg/pubmethod
										}
										for _, lead in ipairs(tbl23.leads) do
											local str8 = lead:gsub("%s+", "%%s+")
											for _, article in ipairs(tbl23.articles) do
												tbl23.patterns[#tbl23.patterns + 1] = str8 .. "%s+" .. article .. "code"
											end
										end
										tbl23.names = { "sammy" }
										local function slicedfn53(arg)  -- LEAKED BY SLICED | discord.gg/pubmethod
											for match, match2 in arg:gmatch("()([%w_]+)") do
												if #match2 >= 4 and match2:match("%a") and (match2:match("%u") or match2:match("%d")) then
													return arg:sub(match)
												end
											end
										end
										slicedfn38 = function(arg)
											local str8 = arg:lower()
											local sliced110 = nil  -- LEAKED BY SLICED | discord.gg/pubmethod
											local sliced111 = nil
											local function slicedfn54(arg2, arg3, arg4)
												local slicedn35 = 1
												while true do
													local ok, result, result2 = pcall(string.find, str8, arg2, slicedn35, arg3)
													if not (not ok or not result) then
														if not sliced110 or result2 > sliced110 then
															sliced110 = result2
															sliced111 = arg4
														end  -- LEAKED BY SLICED | discord.gg/pubmethod
														slicedn35 = result2 + 1
														continue
													end
													break
												end
											end
											for _, pattern in ipairs(tbl23.patterns) do
												slicedfn54(pattern, false, false)
											end  -- LEAKED BY SLICED | discord.gg/pubmethod
											if str8:find("code") then
												for _, name in ipairs(tbl23.names) do
													local sliced112 = true
													slicedfn54(name:lower(), sliced112, true)
												end
											end
											if not sliced110 then
												return nil
											end
											local str9 = arg:sub(sliced110 + 1)  -- LEAKED BY SLICED | discord.gg/pubmethod
											local sliced112 = slicedfn53(str9)
											if sliced111 then
												return sliced112
											end
											return sliced112 or ""
										end
									end
								end
							end  -- LEAKED BY SLICED | discord.gg/pubmethod
							do
								local function slicedfn53(arg)
									if not getupvalues_ then
										return {}
									end
									local ok, result = pcall(getupvalues_, arg)
									local tbl23 = {}
									if ok and result then
										for _, sliced110 in pairs(result) do
											if typeof(sliced110) == "Instance" and (sliced110:IsA("RemoteEvent") or sliced110:IsA("RemoteFunction") or sliced110:IsA("UnreliableRemoteEvent")) and sliced110.Parent == net then  -- LEAKED BY SLICED | discord.gg/pubmethod
												table.insert(tbl23, sliced110)
											end
										end
									end
									return tbl23
								end
								slicedfn39 = function()
									local ok, result = pcall(function()
										return require(sliced85.Controllers:FindFirstChild("NotificationController", true))  -- LEAKED BY SLICED | discord.gg/pubmethod
									end)
									if ok then
										local sliced110 = "table"
										ok = type(result) == sliced110
									end
									if ok then
										local sliced110 = "function"
										ok = type(result.Start) == sliced110
									end
									if ok then
										return slicedfn53(result.Start)[1]
									end
								end
							end
						end
						do
							local slicedfn53, slicedfn54
							do
								slicedfn53 = function()  -- LEAKED BY SLICED | discord.gg/pubmethod
									local codes = sliced87:FindFirstChild("Codes")
									if not codes then
										return nil
									end
									local sliced110 = (codes:FindFirstChild("Codes") or codes):FindFirstChild("Main")
									sliced110 = sliced110 and sliced110:FindFirstChild("TextBox")
									if sliced110 and sliced110:IsA("TextBox") then
										return sliced110
									end  -- LEAKED BY SLICED | discord.gg/pubmethod
									for _, descendant in ipairs(codes:GetDescendants()) do
										if descendant:IsA("TextBox") then
											return descendant
										end
									end
								end
								do
									local function slicedfn55()
										local codes = sliced87:FindFirstChild("Codes")
										if not codes then  -- LEAKED BY SLICED | discord.gg/pubmethod
											return nil
										end
										local codes2 = codes:FindFirstChild("Codes") or codes
										local confirm = (codes2:FindFirstChild("Main") or codes2):FindFirstChild("Confirm")
										if confirm and (confirm:IsA("ImageButton") or confirm:IsA("TextButton")) then
											return confirm
										end
										local sliced110 = nil
										for _, descendant in ipairs(codes:GetDescendants()) do  -- LEAKED BY SLICED | discord.gg/pubmethod
											if descendant:IsA("ImageButton") or descendant:IsA("TextButton") then
												local str8 = descendant.Name:lower()
												if str8:find("confirm") or str8:find("submit") or str8:find("redeem") or str8:find("enter") then
													return descendant
												end
												sliced110 = sliced110 or descendant
											end
										end
										return sliced110
									end  -- LEAKED BY SLICED | discord.gg/pubmethod
									local slicedfn56 = nil
									slicedfn56 = function(arg, arg2)
										if not (arg and setupvalue_ and getupvalues_) then
											return
										end
										arg2 = arg2 or 1
										local ok, result = pcall(getupvalues_, arg)
										if ok and type(result) == "table" then
											for k, sliced110 in pairs(result) do  -- LEAKED BY SLICED | discord.gg/pubmethod
												local sliced111 = "boolean"
												if type(sliced110) == sliced111 then
													pcall(setupvalue_, arg, k, false)
												else
													local sliced112 = "function"
													if type(sliced110) == sliced112 and arg2 > 0 then
														slicedfn56(sliced110, arg2 - 1)
													end
												end
											end  -- LEAKED BY SLICED | discord.gg/pubmethod
										end
									end
									local function slicedfn57(arg, ...)
										if not getconnections_ then
											return false
										end
										local ok, result = pcall(getconnections_, arg)
										local flag23 = not ok
										if not flag23 then  -- LEAKED BY SLICED | discord.gg/pubmethod
											local sliced110 = "table"
											flag23 = type(result) ~= sliced110
										end
										if flag23 or #result == 0 then
											return false
										end
										local sliced110 = table.pack(...)
										local sliced111, sliced112, sliced113 = ipairs(result)
										local flag24 = false  -- LEAKED BY SLICED | discord.gg/pubmethod
										for _, sliced114 in sliced111, sliced112, sliced113 do
											if sliced114.Enabled ~= false then
												local function_ = nil
												pcall(function()
													function_ = sliced114.Function
												end)
												slicedfn56(function_)
												local ok2
												if function_ then
													ok2 = pcall(task.spawn, function_, table.unpack(sliced110, 1, sliced110.n))  -- LEAKED BY SLICED | discord.gg/pubmethod
												else
													ok2 = pcall(function()
														sliced114:Fire(table.unpack(sliced110, 1, sliced110.n))
													end)
												end
												flag24 = flag24 or ok2
											end
										end
										return flag24  -- LEAKED BY SLICED | discord.gg/pubmethod
									end
									slicedfn40 = function(text)
										if type(text) ~= "string" or text == "" then
											return
										end
										local sliced110 = slicedfn53()
										if not sliced110 then
											return
										end  -- LEAKED BY SLICED | discord.gg/pubmethod
										pcall(function()
											if sliced110.Text ~= text then
												sliced110.Text = text
											end
										end)
									end
									slicedfn54 = function(text)
										if not getconnections_ then
											return false, "no getconnections"
										end  -- LEAKED BY SLICED | discord.gg/pubmethod
										local sliced110 = slicedfn53()
										if not sliced110 then
											return false, "code box not found"
										end
										pcall(function()
											sliced110.Text = text
											sliced110.Active = true
											sliced110.Selectable = true
										end)
										local sliced111 = slicedfn55()  -- LEAKED BY SLICED | discord.gg/pubmethod
										local flag23 = false
										if sliced111 then
											local flag24 = slicedfn57(sliced111.MouseButton1Click)
											flag24 = flag24 or false
											flag23 = slicedfn57(sliced111.Activated) or flag24
										end
										if not flag23 then
											flag23 = slicedfn57(sliced110.FocusLost, true) or flag23
										end  -- LEAKED BY SLICED | discord.gg/pubmethod
										return flag23, flag23 and "submitted" or "no submit control"
									end
								end
							end
							do
								local function slicedfn55(text)
									local sliced110 = slicedfn53()
									if not sliced110 then
										return false, "code box not found"
									end  -- LEAKED BY SLICED | discord.gg/pubmethod
									if not pcall(function()
										sliced110.Text = text
										sliced110:CaptureFocus()
									end) then
										return false, "focus failed"
									end
									task.wait(0.1)
									local ok = pcall(function()
										sliced110:ReleaseFocus(true)
									end)  -- LEAKED BY SLICED | discord.gg/pubmethod
									return ok, ok and "submitted" or "release failed"
								end
								slicedfn41 = function(arg)
									local sliced110, sliced111 = slicedfn54(arg)
									if sliced110 then
										return true, sliced111
									end
									if getconnections_ then
										return false, sliced111
									end  -- LEAKED BY SLICED | discord.gg/pubmethod
									return slicedfn55(arg)
								end
							end
						end
					end
					tbl20 = {
						ready = false,
						why = "EventController unavailable",
						IsBlocked = function()  -- LEAKED BY SLICED | discord.gg/pubmethod
							return false
						end,
					}
					do
						local function slicedfn53(arg)
							local sliced110 = sliced85:FindFirstChild("Controllers")
							sliced110 = sliced110 and sliced110:FindFirstChild(arg, true)
							if not (sliced110 and sliced110:IsA("ModuleScript")) then
								return nil
							end  -- LEAKED BY SLICED | discord.gg/pubmethod
							local ok, result = pcall(require, sliced110)
							if ok and type(result) == "table" then
								return result
							end
						end
						local EventController = slicedfn53("EventController")
						local EffectController = slicedfn53("EffectController")
						local flag23 = EventController and type(EventController.Events) == "table"
						if flag23 then  -- LEAKED BY SLICED | discord.gg/pubmethod
							local sliced110 = "function"
							flag23 = type(EventController.Execute) == sliced110
						end
						if not flag23 then
							tbl20.why = "EventController missing Events/Execute"
						else
							local brainrotEventTool, sliced110, slicedfn54, slicedfn55, slicedfn56, slicedfn57, slicedfn58
							do
								do  -- LEAKED BY SLICED | discord.gg/pubmethod
									brainrotEventTool = _G.__BrainrotEventTool
									if not brainrotEventTool then
										brainrotEventTool = {}
										_G.__BrainrotEventTool = brainrotEventTool
									end
									brainrotEventTool.origExecute = brainrotEventTool.origExecute or EventController.Execute
									brainrotEventTool.origGetActive = brainrotEventTool.origGetActive or EventController.GetActiveEvents
									if EffectController then
										brainrotEventTool.origRun = brainrotEventTool.origRun or EffectController.Run
									end  -- LEAKED BY SLICED | discord.gg/pubmethod
									brainrotEventTool.fakes = brainrotEventTool.fakes or {}
									brainrotEventTool.capture = brainrotEventTool.capture or {}
									brainrotEventTool.spawned = brainrotEventTool.spawned or {}
									brainrotEventTool.clearedAttrs = brainrotEventTool.clearedAttrs or {}
									brainrotEventTool.stashed = brainrotEventTool.stashed or {}
									if brainrotEventTool.blocked == nil then
										brainrotEventTool.blocked = false
									end
									tbl20.S = brainrotEventTool  -- LEAKED BY SLICED | discord.gg/pubmethod
									tbl20.IsBlocked = function()
										return brainrotEventTool.blocked and true or false
									end
									sliced110 = nil
									do
										local getupvalue_ = debug and debug.getupvalue
										if getupvalue_ then
											local ok, result = pcall(getupvalue_, brainrotEventTool.origExecute, 5)
											if ok and type(result) == "table" then  -- LEAKED BY SLICED | discord.gg/pubmethod
												sliced110 = result
											end
										end
									end
								end
								if not brainrotEventTool.shimmed then
									EventController.GetActiveEvents = function(arg)
										local tbl23 = {}
										if not brainrotEventTool.blocked then
											local ok, result = pcall(brainrotEventTool.origGetActive, arg)  -- LEAKED BY SLICED | discord.gg/pubmethod
											if ok and type(result) == "table" then
												for _, sliced112 in pairs(result) do
													tbl23[#tbl23 + 1] = sliced112
												end
											end
										end
										for _, fake in pairs(brainrotEventTool.fakes) do
											tbl23[#tbl23 + 1] = fake
										end  -- LEAKED BY SLICED | discord.gg/pubmethod
										return tbl23
									end
									brainrotEventTool.shimmed = true
								end
								slicedfn54 = function()
									local sliced111 = slicedfn53("LightingController")
									if sliced111 and type(sliced111.Update) == "function" then
										pcall(function()
											sliced111:Update()  -- LEAKED BY SLICED | discord.gg/pubmethod
										end)
									end
									local SoundController = slicedfn53("SoundController")
									local flag24
									if SoundController then
										local sliced112 = "function"
										flag24 = type(SoundController.UpdateOST) == sliced112
									else
										flag24 = SoundController
									end  -- LEAKED BY SLICED | discord.gg/pubmethod
									if flag24 then
										pcall(function()
											SoundController:UpdateOST()
										end)
									end
								end
								slicedfn55 = function(arg)
									return arg:IsA("Sky") or arg:IsA("Atmosphere") or arg:IsA("Clouds") or arg:IsA("PostEffect")
								end
								slicedfn56 = function()  -- LEAKED BY SLICED | discord.gg/pubmethod
									local flag24 = EffectController
									if EffectController then
										local sliced111 = "table"
										flag24 = type(EffectController.ActiveEffects) == sliced111
									end
									if not flag24 then
										return 0
									end
									local tbl23 = {}
									for k in pairs(EffectController.ActiveEffects) do  -- LEAKED BY SLICED | discord.gg/pubmethod
										tbl23[#tbl23 + 1] = k
									end
									for _, sliced111 in ipairs(tbl23) do
										local sliced112 = "table"
										local flag25 = type(EffectController.Effects) == sliced112 and EffectController.Effects[sliced111] or nil
										EffectController.ActiveEffects[sliced111] = nil
										if type(flag25) == "table" then
											local sliced113 = "function"
											if type(flag25.OnUpdate) == sliced113 then  -- LEAKED BY SLICED | discord.gg/pubmethod
												pcall(function()
													flag25:OnUpdate()
												end)
											end
											if type(flag25.OnStop) == "function" then
												pcall(function()
													flag25:OnStop()
												end)
											end
										end
									end
									return #tbl23
								end
								do
									local tbl23 = {
										EventsLoaded = true,
										NextCrystalEvent = true,
										CrystalEventLastTime = true,
										SantaMerchantStockId = true,  -- LEAKED BY SLICED | discord.gg/pubmethod
										SantaMerchantNextStockId = true,
										FuseMachineLuck = true,
										FuseMachineLuckTimer = true,
									}
									local tbl24 = {
										"AyMiGatitoEvent",
										"ChicleteiraBicicleteiraEvent",
										"EasterEvent",
										"ExtinctEvent",
										"IndonesiaEvent",  -- LEAKED BY SLICED | discord.gg/pubmethod
										"MeowlEvent",
										"MexicoEvent",
										"RipMyGrannyEvent",
										"SkibidiEvent",
										"StPatricksEvent",
										"StrawberryEvent",
										"TrickOrTreatEvent",
										"ValentinesEvent",
										"YinYangEvent",
										"WitchingHourEvent",  -- LEAKED BY SLICED | discord.gg/pubmethod
									}
									local tbl25 = {
										"Lighting",
										"WallRecolor",
										"Atmosphere",
									}
									slicedfn57 = function()
										if not (EffectController and type(EffectController.Effects) == "table") then
											return
										end  -- LEAKED BY SLICED | discord.gg/pubmethod
										for _, sliced111 in ipairs(tbl25) do
											local sliced112 = EffectController.Effects[sliced111]
											local flag24
											if sliced112 then
												local sliced113 = "function"
												flag24 = type(sliced112.OnUpdate) == sliced113
											else
												flag24 = sliced112
											end
											if flag24 then
												pcall(function()
													sliced112:OnUpdate()
												end)
											end
										end
									end
									slicedfn58 = function()
										local tbl26 = {}
										for _, sliced111 in ipairs(tbl24) do  -- LEAKED BY SLICED | discord.gg/pubmethod
											tbl26[sliced111] = true
										end
										local sliced111 = 0
										for k, sliced112 in pairs(sliced85:GetAttributes()) do
											local sliced113 = "string"
											local flag24 = type(k) == sliced113 and sliced112 == true and not tbl23[k]
											local pos
											if flag24 then
												pos = tbl26[k] or k:find("Event") or k:find("Phase") or k:find("Hour")  -- LEAKED BY SLICED | discord.gg/pubmethod
											else
												pos = flag24
											end
											if pos then
												pcall(function()
													sliced85:SetAttribute(k, nil)
												end)
												brainrotEventTool.clearedAttrs[k] = true
												sliced111 += 1
											end  -- LEAKED BY SLICED | discord.gg/pubmethod
										end
										slicedfn57()
										return sliced111
									end
								end
							end
							do
								local function slicedfn59()
									local slicedn35 = 0
									for k in pairs(brainrotEventTool.clearedAttrs) do  -- LEAKED BY SLICED | discord.gg/pubmethod
										pcall(function()
											sliced85:SetAttribute(k, true)
										end)
										slicedn35 += 1
									end
									table.clear(brainrotEventTool.clearedAttrs)
									slicedfn57()
									return slicedn35
								end  -- LEAKED BY SLICED | discord.gg/pubmethod
								local function slicedfn60()
									local slicedn35 = 0
									for _, descendant in ipairs(workspace:GetDescendants()) do
										if descendant:IsA("Sound") and descendant.Playing and descendant.Looped then
											pcall(function()
												descendant:Stop()
											end)
											slicedn35 += 1
										end
									end  -- LEAKED BY SLICED | discord.gg/pubmethod
									return slicedn35
								end
								local function slicedfn61()
									local slicedn35 = 0
									for k, sliced111 in pairs(brainrotEventTool.stashed) do
										if typeof(k) == "Instance" then
											pcall(function()
												k.Parent = sliced111
											end)  -- LEAKED BY SLICED | discord.gg/pubmethod
											slicedn35 += 1
										end
										brainrotEventTool.stashed[k] = nil
									end
									return slicedn35
								end
								local function slicedfn62()
									local effects = _G.Effects
									if type(effects) == "table" and type(effects.Block) == "function" and type(effects.Unblock) == "function" then
										return effects  -- LEAKED BY SLICED | discord.gg/pubmethod
									end
								end
								tbl20.Block = function()
									local sliced111 = slicedfn62()
									if sliced111 then
										sliced111.Block()
										brainrotEventTool.blocked = true
										return true, "blocked (effects panel)"
									end  -- LEAKED BY SLICED | discord.gg/pubmethod
									local slicedn35 = 0
									for k, event in pairs(EventController.Events) do
										if type(event) == "table" and rawget(event, "Active") then
											if not (type(EventController.Cancel) == "function" and pcall(function()
												return EventController:Cancel(k)
											end)) then
												rawset(event, "Active", false)
												rawset(event, "__started", false)
											end  -- LEAKED BY SLICED | discord.gg/pubmethod
											slicedn35 += 1
										end
									end
									local sliced112 = slicedfn56()
									for k, sliced113 in pairs(brainrotEventTool.capture) do
										local flag24 = type(sliced113) == "table"
										if flag24 then
											local sliced114 = "table"
											flag24 = type(sliced113.caught) == sliced114
										end  -- LEAKED BY SLICED | discord.gg/pubmethod
										if flag24 then
											for k2 in pairs(sliced113.caught) do
												local sliced114 = "Instance"
												if typeof(k2) == sliced114 and k2.Parent and not slicedfn55(k2) then
													pcall(function()
														k2:Destroy()
													end)
												end
											end  -- LEAKED BY SLICED | discord.gg/pubmethod
										end
										brainrotEventTool.capture[k] = nil
									end
									table.clear(brainrotEventTool.spawned)
									table.clear(brainrotEventTool.fakes)
									if sliced110 then
										for k, sliced113 in pairs(sliced110) do
											local sliced114 = "table"
											if type(sliced113) == sliced114 then
												for _, sliced115 in ipairs(sliced113) do  -- LEAKED BY SLICED | discord.gg/pubmethod
													if typeof(sliced115) == "Instance" and not slicedfn55(sliced115) then
														pcall(function()
															sliced115:Destroy()
														end)
													end
												end
											end
											sliced110[k] = nil
										end  -- LEAKED BY SLICED | discord.gg/pubmethod
									end
									EventController.Execute = function()
										return false
									end
									if EffectController then
										EffectController.Run = function()
											return false, false
										end
									end
									brainrotEventTool.blocked = true  -- LEAKED BY SLICED | discord.gg/pubmethod
									slicedfn54()
									slicedfn58()
									local sliced113 = slicedfn60()
									return true, ("blocked %d event(s), %d fx, %d sound(s)"):format(slicedn35, sliced112, sliced113)
								end
								tbl20.Unblock = function()
									local sliced111 = slicedfn62()
									if sliced111 then
										sliced111.Unblock()  -- LEAKED BY SLICED | discord.gg/pubmethod
										brainrotEventTool.blocked = false
										return true, "unblocked (effects panel)"
									end
									EventController.Execute = brainrotEventTool.origExecute
									if EffectController and brainrotEventTool.origRun then
										EffectController.Run = brainrotEventTool.origRun
									end
									brainrotEventTool.blocked = false
									local sliced112 = slicedfn59()  -- LEAKED BY SLICED | discord.gg/pubmethod
									local sliced113 = slicedfn61()
									slicedfn54()
									return true, ("unblocked - %d flag(s), %d model(s) restored"):format(sliced112, sliced113)
								end
							end
							tbl20.ready = true
							tbl20.why = nil
						end
					end
				end  -- LEAKED BY SLICED | discord.gg/pubmethod
				local sliced110
				do
					do
						tbl21 = {
							bg = Color3.fromRGB(6, 6, 10),
							panel = Color3.fromRGB(16, 15, 21),
							panel2 = Color3.fromRGB(32, 28, 42),
							line = Color3.fromRGB(42, 35, 52),
							acc = Color3.fromRGB(235, 90, 175),
							acc2 = Color3.fromRGB(160, 50, 110),  -- LEAKED BY SLICED | discord.gg/pubmethod
							accHi = Color3.fromRGB(255, 130, 210),
							txt = Color3.fromRGB(240, 240, 255),
							sub = Color3.fromRGB(160, 175, 195),
							ok = Color3.fromRGB(55, 195, 105),
							err = Color3.fromRGB(205, 50, 50),
							warn = Color3.fromRGB(255, 215, 0),
							input = Color3.fromRGB(11, 10, 15),
							dark = Color3.fromRGB(6, 6, 9),
						}
						gothamMedium = Enum.Font.GothamMedium
						gothamBold = Enum.Font.GothamBold
						gothamBlack = Enum.Font.GothamBlack
						slicedfn42 = function(arg, arg2, parent)
							local instance = Instance.new(arg)
							local sliced111 = pairs
							local tbl23 = arg2 or {}
							for k, sliced112 in sliced111(tbl23) do
								instance[k] = sliced112
							end  -- LEAKED BY SLICED | discord.gg/pubmethod
							if parent then
								instance.Parent = parent
							end
							return instance
						end
						slicedfn43 = function(arg, arg2)
							slicedfn42("UICorner", { CornerRadius = UDim.new(0, arg2 or 8) }, arg)
						end
						slicedfn44 = function(arg, arg2, arg3, arg4)  -- LEAKED BY SLICED | discord.gg/pubmethod
							return slicedfn42("UIStroke", { Color = arg2 or tbl21.line, Thickness = arg3 or 1, Transparency = arg4 or 0 }, arg)
						end
						slicedfn45 = function(arg, arg2, arg3, arg4)
							sliced109:Create(arg, TweenInfo.new(arg2, arg4 or Enum.EasingStyle.Quad), arg3):Play()
						end
						do
							local function slicedfn53(arg, arg2, arg3, arg4)
								return slicedfn42("UIGradient", { Color = ColorSequence.new(arg2, arg3), Rotation = arg4 or 90 }, arg)
							end
							slicedfn46 = function(arg, arg2, arg3, arg4, arg5, arg6)  -- LEAKED BY SLICED | discord.gg/pubmethod
								return slicedfn42("TextLabel", {
									BackgroundTransparency = 1,
									Text = arg,
									Font = arg4 or gothamMedium,
									TextSize = arg2 or 12,
									TextColor3 = arg3 or tbl21.txt,
									TextXAlignment = arg5 or Enum.TextXAlignment.Left,
									}, arg6)
							end  -- LEAKED BY SLICED | discord.gg/pubmethod
							local function slicedfn54(arg, arg2)
								local flag23 = nil
								local sliced111 = nil
								local sliced112 = nil
								arg.InputBegan:Connect(function(input)
									if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
										local position = input.Position
										local position2 = arg2.Position
										flag23 = true
										sliced111 = position  -- LEAKED BY SLICED | discord.gg/pubmethod
										sliced112 = position2
										input.Changed:Connect(function()
											if input.UserInputState == Enum.UserInputState.End then
												flag23 = false
											end
										end)
									end
								end)
								sliced86.InputChanged:Connect(function(input)  -- LEAKED BY SLICED | discord.gg/pubmethod
									if flag23 and (input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch) then
										local slicedn35 = input.Position - sliced111
										arg2.Position = UDim2.new(sliced112.X.Scale, sliced112.X.Offset + slicedn35.X, sliced112.Y.Scale, sliced112.Y.Offset + slicedn35.Y)
									end
								end)
							end
							slicedfn47 = function(arg, arg2, arg3, arg4)
								local sliced111 = slicedfn42("Frame", {
									Name = arg,
									Size = UDim2.fromOffset(arg2, arg3),  -- LEAKED BY SLICED | discord.gg/pubmethod
									BackgroundColor3 = tbl21.bg,
									BorderSizePixel = 0,
									Active = true,
									ClipsDescendants = true,
								})
								slicedfn43(sliced111, 14)
								slicedfn53(sliced111, Color3.fromRGB(20, 15, 21), Color3.fromRGB(6, 6, 10), 90)
								slicedfn44(sliced111, tbl21.acc, 1.5, 0.45)
								if flag18 then
									slicedfn42("UIScale", { Name = "WinScale", Scale = sliced91 }, sliced111)  -- LEAKED BY SLICED | discord.gg/pubmethod
								end
								local Frame7 = slicedfn42("Frame", { Size = UDim2.new(1, 0, 0, 44), BackgroundColor3 = tbl21.panel, BorderSizePixel = 0 }, sliced111)
								slicedfn43(Frame7, 14)
								slicedfn42("Frame", {
									Size = UDim2.new(1, 0, 0, 14),
									Position = UDim2.new(0, 0, 1, -14),
									BackgroundColor3 = tbl21.panel,
									BorderSizePixel = 0,
									}, Frame7)  -- LEAKED BY SLICED | discord.gg/pubmethod
								local ImageLabel = slicedfn42("ImageLabel", {
									Size = UDim2.fromOffset(24, 24),
									Position = UDim2.new(0, 12, 0.5, -12),
									BackgroundColor3 = tbl21.panel2,
									BorderSizePixel = 0,
									Image = "rbxthumb://type=Asset&id=124491981850461&w=150&h=150",
									}, Frame7)
								slicedfn43(ImageLabel, 12)
								slicedfn44(ImageLabel, tbl21.acc, 1.5, 0.2)
								local sliced112 = slicedfn46(arg4, 14, tbl21.txt, gothamBlack, Enum.TextXAlignment.Left, Frame7)  -- LEAKED BY SLICED | discord.gg/pubmethod
								sliced112.Size = UDim2.new(1, -80, 1, 0)
								sliced112.Position = UDim2.fromOffset(44, 0)
								slicedfn54(Frame7, sliced111)
								return sliced111, Frame7, ImageLabel, sliced112
							end
							slicedfn48 = function(arg, arg2)
								local TextButton2 = slicedfn42("TextButton", {
									BackgroundColor3 = tbl21.panel2,
									Text = arg,  -- LEAKED BY SLICED | discord.gg/pubmethod
									Font = gothamBold,
									TextSize = 12,
									TextColor3 = tbl21.txt,
									AutoButtonColor = false,
									BorderSizePixel = 0,
									}, arg2)
								slicedfn43(TextButton2, 8)
								local sliced111 = slicedfn44(TextButton2, tbl21.line, 1, 0.2)
								TextButton2.MouseEnter:Connect(function()  -- LEAKED BY SLICED | discord.gg/pubmethod
									slicedfn45(TextButton2, 0.12, { BackgroundColor3 = tbl21.panel })
									slicedfn45(sliced111, 0.12, { Color = tbl21.acc, Transparency = 0 })
								end)
								TextButton2.MouseLeave:Connect(function()
									slicedfn45(TextButton2, 0.12, { BackgroundColor3 = tbl21.panel2 })
									slicedfn45(sliced111, 0.12, { Color = tbl21.line, Transparency = 0.2 })
								end)
								return TextButton2
							end
							slicedfn49 = function(arg, arg2)  -- LEAKED BY SLICED | discord.gg/pubmethod
								local TextButton2 = slicedfn42("TextButton", {
									BackgroundColor3 = tbl21.acc,
									Text = arg,
									Font = gothamBlack,
									TextSize = 13,
									TextColor3 = Color3.fromRGB(255, 255, 255),
									AutoButtonColor = false,
									BorderSizePixel = 0,
									}, arg2)
								slicedfn43(TextButton2, 8)
								slicedfn53(TextButton2, tbl21.acc, tbl21.acc2, 90)
								TextButton2.MouseEnter:Connect(function()
									slicedfn45(TextButton2, 0.12, { BackgroundColor3 = tbl21.accHi })
								end)
								TextButton2.MouseLeave:Connect(function()
									slicedfn45(TextButton2, 0.12, { BackgroundColor3 = tbl21.acc })
								end)
								return TextButton2
							end  -- LEAKED BY SLICED | discord.gg/pubmethod
						end
					end
					do
						local hui = gethui and gethui() or sliced87
						local traced = hui:FindFirstChild("Traced")
						if traced then
							traced:Destroy()
						end
						ScreenGui = slicedfn42("ScreenGui", {  -- LEAKED BY SLICED | discord.gg/pubmethod
							Name = "Traced",
							ResetOnSpawn = false,
							ZIndexBehavior = Enum.ZIndexBehavior.Sibling,
							DisplayOrder = 250,
							}, hui)
					end
					do
						local sliced111, sliced112
						Main, sliced110, sliced111, sliced112 = slicedfn47("Main", 316, 548, "TRACED")
						Main.Position = UDim2.new(1, -340, 0.5, -274)  -- LEAKED BY SLICED | discord.gg/pubmethod
						if flag18 then
							Main.Position = UDim2.new(1, -math.floor(316 * sliced91) - 8, 0.5, -math.floor(548 * sliced91 / 2))
						end
						Main.Parent = ScreenGui
						sliced112.Size = UDim2.new(1, -262, 1, 0)
					end
				end
				do
					slicedfn43(slicedfn42("ImageLabel", {  -- LEAKED BY SLICED | discord.gg/pubmethod
						Name = "CityBg",
						Size = UDim2.new(1, 0, 1, 0),
						BackgroundTransparency = 1,
						BorderSizePixel = 0,
						ZIndex = 0,
						Image = "rbxthumb://type=Asset&id=96519310989847&w=420&h=420",
						ImageTransparency = 0.5,
						ImageColor3 = Color3.fromRGB(200, 160, 180),
						ScaleType = Enum.ScaleType.Crop,
						}, Main), 14)  -- LEAKED BY SLICED | discord.gg/pubmethod
					do
						local Frame7 = slicedfn42("Frame", {
							Name = "LeavesLayer",
							Size = UDim2.new(1, 0, 1, 0),
							BackgroundTransparency = 1,
							BorderSizePixel = 0,
							ZIndex = 0,
							ClipsDescendants = true,
							}, Main)
						slicedfn43(Frame7, 14)  -- LEAKED BY SLICED | discord.gg/pubmethod
						local tbl23 = {}
						local color = Color3.fromRGB(255, 205, 225)
						local color2 = Color3.fromRGB(255, 175, 195)
						local color3 = Color3.fromRGB(245, 135, 185)
						local color4 = Color3.fromRGB(255, 220, 235)
						local color5 = Color3.fromRGB
						local sliced111 = 160
						tbl23[1] = color
						tbl23[2] = color2  -- LEAKED BY SLICED | discord.gg/pubmethod
						tbl23[3] = color3
						tbl23[4] = color4
						do
							local values = table.pack(color5(230, 110, sliced111))
							table.move(values, 1, values.n, 5, tbl23)
						end
						for i = 1, 18 do
							task.spawn(function()
								task.wait(math.random() * 2.5)
								while Frame7.Parent do  -- LEAKED BY SLICED | discord.gg/pubmethod
									local slicedn35 = math.random(5, 8)
									local slicedn36 = slicedn35 + math.random(2, 4)
									local slicedn37 = math.random()
									local sliced112 = 0.3
									local Frame8 = slicedfn42("Frame", {
										Size = UDim2.new(0, slicedn35, 0, slicedn36),
										AnchorPoint = Vector2.new(0.5, 0.5),
										Position = UDim2.new(slicedn37, 0, 0, -slicedn36),
										BackgroundColor3 = tbl23[math.random(#tbl23)],  -- LEAKED BY SLICED | discord.gg/pubmethod
										BackgroundTransparency = 0.15 + math.random() * sliced112,
										BorderSizePixel = 0,
										ZIndex = 0,
										Rotation = math.random(0, 359),
										}, Frame7)
									slicedfn42("UICorner", { CornerRadius = UDim.new(1, 0) }, Frame8)
									local new = NumberSequenceKeypoint.new
									slicedfn42("UIGradient", {
										Rotation = math.random(0, 359),
										Transparency = NumberSequence.new({ NumberSequenceKeypoint.new(0, 0), new(1, 0.55) }),  -- LEAKED BY SLICED | discord.gg/pubmethod
										}, Frame8)
									local slicedn38 = 4 + math.random() * 2.6
									local sliced113 = 0.3
									local slicedn39 = (math.random() - 0.5) * sliced113
									local slicedn40 = math.random(180, 540)
									local slicedn41 = math.random() < 0.5 and -1 or 1
									sliced109:Create(Frame8, TweenInfo.new(slicedn38, Enum.EasingStyle.Linear), { Position = UDim2.new(slicedn37 + slicedn39, 0, 1, slicedn36 * 2), Rotation = Frame8.Rotation + slicedn40 * slicedn41 }):Play()
									task.wait(slicedn38)
									if Frame8 and Frame8.Parent then  -- LEAKED BY SLICED | discord.gg/pubmethod
										Frame8:Destroy()
									end
									task.wait(math.random() * 0.5)
								end
							end)
						end
					end
				end
				do
					Frame = slicedfn42("Frame", {  -- LEAKED BY SLICED | discord.gg/pubmethod
						Size = UDim2.fromOffset(8, 8),
						Position = UDim2.new(1, -212, 0.5, -4),
						BackgroundColor3 = tbl21.sub,
						BorderSizePixel = 0,
						Visible = false,
						}, sliced110)
					slicedfn43(Frame, 4)
					Rag = slicedfn48("Rag", sliced110)
					Rag.Size = UDim2.fromOffset(38, 22)
					Rag.Position = UDim2.new(1, -200, 0.5, -11)  -- LEAKED BY SLICED | discord.gg/pubmethod
					Rag.TextSize = 10
					sliced97 = slicedfn48("Test", sliced110)
					sliced97.Size = UDim2.fromOffset(38, 22)
					sliced97.Position = UDim2.new(1, -157, 0.5, -11)
					sliced97.TextSize = 10
					sliced98 = slicedfn48("FEED", sliced110)
					sliced98.Size = UDim2.fromOffset(38, 22)
					sliced98.Position = UDim2.new(1, -114, 0.5, -11)
					sliced98.TextSize = 10
					Settings = slicedfn48("Settings", sliced110)  -- LEAKED BY SLICED | discord.gg/pubmethod
					Settings.Size = UDim2.fromOffset(38, 22)
					Settings.Position = UDim2.new(1, -71, 0.5, -11)
					Settings.TextSize = 8
					do
						local sliced111 = slicedfn48("", sliced110)
						sliced111.Size = UDim2.fromOffset(22, 22)
						sliced111.Position = UDim2.new(1, -28, 0.5, -11)
						slicedfn43(slicedfn42("Frame", {
							Size = UDim2.fromOffset(10, 2),
							Position = UDim2.new(0.5, -5, 0.5, -1),  -- LEAKED BY SLICED | discord.gg/pubmethod
							BackgroundColor3 = tbl21.txt,
							BorderSizePixel = 0,
							}, sliced111), 1)
						local sliced112 = slicedfn42("Frame", {
							Size = UDim2.fromOffset(2, 10),
							Position = UDim2.new(0.5, -1, 0.5, -5),
							BackgroundColor3 = tbl21.txt,
							BorderSizePixel = 0,
							Visible = false,
							}, sliced111)  -- LEAKED BY SLICED | discord.gg/pubmethod
						slicedfn43(sliced112, 1)
						slicedn34 = 548
						visible = false
						sliced111.MouseButton1Click:Connect(function()
							visible = not visible
							sliced112.Visible = visible
							slicedfn45(Main, 0.25, { Size = UDim2.fromOffset(316, visible and 179 or slicedn34) })
						end)
					end  -- LEAKED BY SLICED | discord.gg/pubmethod
				end
			end
			Frame6 = slicedfn42("Frame", {
				Size = UDim2.new(1, -20, 1, -54),
				Position = UDim2.fromOffset(10, 48),
				BackgroundTransparency = 1,
				}, Main)
			slicedfn42("UIListLayout", {
				Padding = UDim.new(0, 5),
				SortOrder = Enum.SortOrder.LayoutOrder,  -- LEAKED BY SLICED | discord.gg/pubmethod
				}, Frame6)
			do
				local Frame7 = slicedfn42("Frame", {
					Size = UDim2.new(1, 0, 0, 32),
					BackgroundColor3 = tbl21.panel,
					BorderSizePixel = 0,
					LayoutOrder = 1,
					}, Frame6)
				slicedfn43(Frame7, 9)  -- LEAKED BY SLICED | discord.gg/pubmethod
				slicedfn44(Frame7, tbl21.line, 1, 0.3)
				local Frame8 = slicedfn42("Frame", {
					Size = UDim2.fromOffset(8, 8),
					Position = UDim2.new(0, 12, 0.5, -4),
					BackgroundColor3 = tbl21.sub,
					BorderSizePixel = 0,
					}, Frame7)
				slicedfn43(Frame8, 4)
				sliced99 = slicedfn46("starting...", 12, tbl21.txt, gothamBold, Enum.TextXAlignment.Left, Frame7)
				sliced99.Size = UDim2.new(1, -32, 1, 0)  -- LEAKED BY SLICED | discord.gg/pubmethod
				sliced99.Position = UDim2.fromOffset(28, 0)
				sliced99.TextTruncate = Enum.TextTruncate.AtEnd
				slicedfn50 = function(text, arg)
					sliced99.Text = text
					local ok = arg == "ok" and tbl21.ok or arg == "err" and tbl21.err or arg == "busy" and tbl21.acc or arg == "wait" and tbl21.warn or tbl21.txt
					sliced99.TextColor3 = ok
					Frame8.BackgroundColor3 = ok
				end
			end
		end  -- LEAKED BY SLICED | discord.gg/pubmethod
		do
			do
				do
					do
						local sliced109 = slicedfn42("Frame", {
							Size = UDim2.new(1, 0, 0, 50),
							BackgroundColor3 = tbl21.panel,
							BorderSizePixel = 0,
							LayoutOrder = 2,
							}, Frame6)  -- LEAKED BY SLICED | discord.gg/pubmethod
						slicedfn43(sliced109, 9)
						slicedfn44(sliced109, tbl21.line, 1, 0.3)
						local sliced110 = slicedfn46("CODE", 9, tbl21.acc, gothamBlack, Enum.TextXAlignment.Left, sliced109)
						sliced110.Size = UDim2.new(1, -16, 0, 11)
						sliced110.Position = UDim2.fromOffset(11, 5)
						TextBox = slicedfn42("TextBox", {
							Size = UDim2.new(1, -18, 0, 26),
							Position = UDim2.fromOffset(9, 18),
							BackgroundColor3 = tbl21.input,  -- LEAKED BY SLICED | discord.gg/pubmethod
							Text = "",
							PlaceholderText = "type or snipe a code...",
							PlaceholderColor3 = tbl21.sub,
							Font = gothamBlack,
							TextSize = 14,
							TextColor3 = tbl21.txt,
							ClearTextOnFocus = false,
							BorderSizePixel = 0,
							TextXAlignment = Enum.TextXAlignment.Left,
							}, sliced109)  -- LEAKED BY SLICED | discord.gg/pubmethod
					end
					do
						slicedfn43(TextBox, 7)
						do
							local sliced109 = slicedfn44(TextBox, tbl21.line, 1.2, 0.25)
							slicedfn42("UIPadding", {
								PaddingLeft = UDim.new(0, 9),
								PaddingRight = UDim.new(0, 9),
								}, TextBox)  -- LEAKED BY SLICED | discord.gg/pubmethod
							TextBox.Focused:Connect(function()
								slicedfn45(sliced109, 0.12, { Color = tbl21.acc, Transparency = 0 })
							end)
							TextBox.FocusLost:Connect(function()
								slicedfn45(sliced109, 0.12, { Color = tbl21.line, Transparency = 0.25 })
							end)
						end
					end
					do  -- LEAKED BY SLICED | discord.gg/pubmethod
						local sliced109 = slicedfn42("Frame", {
							Size = UDim2.new(1, 0, 0, 33),
							BackgroundTransparency = 1,
							LayoutOrder = 3,
							}, Frame6)
						slicedfn42("UIListLayout", {
							FillDirection = Enum.FillDirection.Horizontal,
							Padding = UDim.new(0, 6),
							SortOrder = Enum.SortOrder.LayoutOrder,
							}, sliced109)  -- LEAKED BY SLICED | discord.gg/pubmethod
						sliced100 = slicedfn48("COPY", sliced109)
						sliced100.Size = UDim2.new(0.33333333333333331, -4, 1, 0)
						sliced100.LayoutOrder = 1
						clear = slicedfn48("CLEAR", sliced109)
						clear.Size = UDim2.new(0.33333333333333331, -4, 1, 0)
						clear.LayoutOrder = 2
						redeem = slicedfn49("REDEEM", sliced109)
					end
				end
				do  -- LEAKED BY SLICED | discord.gg/pubmethod
					local slicedfn53
					do
						redeem.Size = UDim2.new(0.33333333333333331, -4, 1, 0)
						redeem.LayoutOrder = 3
						redeem.TextColor3 = Color3.fromRGB(0, 0, 0)
						slicedfn51 = function(arg, arg2, arg3, arg4, arg5)
							local Frame7 = slicedfn42("Frame", {
								Size = UDim2.new(1, 0, 0, 31),
								BackgroundColor3 = tbl21.panel,
								BorderSizePixel = 0,  -- LEAKED BY SLICED | discord.gg/pubmethod
								LayoutOrder = arg2,
								}, arg)
							slicedfn43(Frame7, 8)
							slicedfn44(Frame7, tbl21.line, 1, 0.3)
							local sliced109 = slicedfn46(arg3, 11, tbl21.sub, gothamBold, Enum.TextXAlignment.Left, Frame7)
							sliced109.Size = UDim2.new(1, -56, 1, 0)
							sliced109.Position = UDim2.fromOffset(12, 0)
							sliced109.TextTruncate = Enum.TextTruncate.AtEnd
							local Frame8 = slicedfn42("Frame", {  -- LEAKED BY SLICED | discord.gg/pubmethod
								Size = UDim2.fromOffset(36, 18),
								Position = UDim2.new(1, -44, 0.5, -9),
								BackgroundColor3 = tbl21.line,
								BorderSizePixel = 0,
								}, Frame7)
							slicedfn43(Frame8, 9)
							local Frame9 = slicedfn42("Frame", {
								Size = UDim2.fromOffset(14, 14),
								Position = UDim2.new(0, 2, 0.5, -7),
								BackgroundColor3 = tbl21.txt,  -- LEAKED BY SLICED | discord.gg/pubmethod
								BorderSizePixel = 0,
								}, Frame8)
							slicedfn43(Frame9, 7)
							local sliced110 = slicedfn42("TextButton", { Size = UDim2.fromScale(1, 1), BackgroundTransparency = 1, Text = "" }, Frame7)
							local flag23 = arg4
							local function slicedfn54()
								slicedfn45(Frame8, 0.16, { BackgroundColor3 = flag23 and tbl21.acc or tbl21.line })
								slicedfn45(Frame9, 0.16, { Position = UDim2.new(0, flag23 and 20 or 2, 0.5, -7) }, Enum.EasingStyle.Back)
								slicedfn45(sliced109, 0.16, { TextColor3 = flag23 and tbl21.txt or tbl21.sub })  -- LEAKED BY SLICED | discord.gg/pubmethod
							end
							slicedfn54()
							sliced110.MouseButton1Click:Connect(function()
								flag23 = not flag23
								slicedfn54()
								if arg5 then
									arg5(flag23)
								end
							end)  -- LEAKED BY SLICED | discord.gg/pubmethod
							return Frame7
						end
						slicedfn53 = function(arg, arg2, arg3, arg4)
							return slicedfn51(Frame6, arg, arg2, arg3, arg4)
						end
						do
							local Frame7 = slicedfn42("Frame", {
								Size = UDim2.new(1, 0, 0, 31),
								BackgroundColor3 = tbl21.panel,
								BorderSizePixel = 0,  -- LEAKED BY SLICED | discord.gg/pubmethod
								LayoutOrder = 4,
								}, Frame6)
							slicedfn43(Frame7, 8)
							slicedfn44(Frame7, tbl21.line, 1, 0.3)
							listen = slicedfn46("LISTEN", 11, tbl21.sub, gothamBold, Enum.TextXAlignment.Left, Frame7)
							listen.Size = UDim2.new(1, -56, 1, 0)
							listen.Position = UDim2.fromOffset(12, 0)
							Frame2 = slicedfn42("Frame", {
								Size = UDim2.fromOffset(36, 18),  -- LEAKED BY SLICED | discord.gg/pubmethod
								Position = UDim2.new(1, -44, 0.5, -9),
								BackgroundColor3 = tbl21.line,
								BorderSizePixel = 0,
								}, Frame7)
							slicedfn43(Frame2, 9)
							Frame3 = slicedfn42("Frame", {
								Size = UDim2.fromOffset(14, 14),
								Position = UDim2.new(0, 2, 0.5, -7),
								BackgroundColor3 = tbl21.txt,
								BorderSizePixel = 0,  -- LEAKED BY SLICED | discord.gg/pubmethod
								}, Frame2)
							slicedfn43(Frame3, 7)
							TextButton = slicedfn42("TextButton", {
								Size = UDim2.fromScale(1, 1),
								BackgroundTransparency = 1,
								Text = "",
								}, Frame7)
						end
					end  -- LEAKED BY SLICED | discord.gg/pubmethod
					do
						Frame5 = slicedfn42("Frame", {
							Size = UDim2.new(1, 0, 0, 31),
							BackgroundColor3 = tbl21.panel,
							BorderSizePixel = 0,
							LayoutOrder = 5,
							}, Frame6)
						slicedfn43(Frame5, 8)
						slicedfn44(Frame5, tbl21.line, 1, 0.3)  -- LEAKED BY SLICED | discord.gg/pubmethod
						do
							local sliced109 = slicedfn46("LISTEN KEY", 11, tbl21.sub, gothamBold, Enum.TextXAlignment.Left, Frame5)
							sliced109.Size = UDim2.new(1, -100, 1, 0)
							sliced109.Position = UDim2.fromOffset(12, 0)
						end
					end
					sliced101 = slicedfn48(listenKey and listenKey.Name or "-", Frame5)
					sliced101.Size = UDim2.fromOffset(46, 24)
					sliced101.Position = UDim2.new(1, -84, 0.5, -12)
					sliced101.TextSize = 11  -- LEAKED BY SLICED | discord.gg/pubmethod
					sliced102 = slicedfn48("X", Frame5)
					sliced102.Size = UDim2.fromOffset(24, 24)
					sliced102.Position = UDim2.new(1, -32, 0.5, -12)
					sliced102.TextSize = 12
					Frame4 = slicedfn42("Frame", {
						Size = UDim2.new(1, 0, 0, 31),
						BackgroundColor3 = tbl21.panel,
						BorderSizePixel = 0,
						LayoutOrder = 6,
						}, Frame6)  -- LEAKED BY SLICED | discord.gg/pubmethod
					slicedfn43(Frame4, 8)
					slicedfn44(Frame4, tbl21.line, 1, 0.3)
					do
						local sliced109 = slicedfn46("REDEEM KEY", 11, tbl21.sub, gothamBold, Enum.TextXAlignment.Left, Frame4)
						sliced109.Size = UDim2.new(1, -100, 1, 0)
						sliced109.Position = UDim2.fromOffset(12, 0)
					end
					sliced103 = slicedfn48(g and g.Name or "-", Frame4)
					sliced103.Size = UDim2.fromOffset(46, 24)  -- LEAKED BY SLICED | discord.gg/pubmethod
					sliced103.Position = UDim2.new(1, -84, 0.5, -12)
					sliced103.TextSize = 11
					sliced104 = slicedfn48("X", Frame4)
					sliced104.Size = UDim2.fromOffset(24, 24)
					sliced104.Position = UDim2.new(1, -32, 0.5, -12)
					sliced104.TextSize = 12
					slicedfn53(7, "AUTO REDEEM", autoRedeem, function(arg)
						autoRedeem = arg
						_G.__RdmCfgSet("autoRedeem", arg)
					end)  -- LEAKED BY SLICED | discord.gg/pubmethod
					slicedfn53(8, "AUTO TYPE", autoType, function(arg)
						autoType = arg
						_G.__RdmCfgSet("autoType", arg)
					end)
					slicedfn53(9, "MANUAL", manual, function(arg)
						manual = arg
						tbl19 = {}
						slicedfn52()
					end)  -- LEAKED BY SLICED | discord.gg/pubmethod
				end
				do
					local function slicedfn53(arg, arg2, arg3, arg4, arg5)
						local Frame7 = slicedfn42("Frame", {
							Size = UDim2.new(1, 0, 0, 31),
							BackgroundColor3 = tbl21.panel,
							BorderSizePixel = 0,
							LayoutOrder = arg,
							}, Frame6)
						slicedfn43(Frame7, 8)
						slicedfn44(Frame7, tbl21.line, 1, 0.3)
						local sliced109 = slicedfn46(arg2, 11, tbl21.sub, gothamBold, Enum.TextXAlignment.Left, Frame7)
						sliced109.Size = UDim2.fromOffset(56, 31)
						sliced109.Position = UDim2.fromOffset(11, 0)
						local sliced110 = slicedfn42("Frame", {
							Size = UDim2.fromOffset(168, 23),
							Position = UDim2.new(1, -177, 0.5, -11.5),
							BackgroundColor3 = tbl21.input,
							BorderSizePixel = 0,  -- LEAKED BY SLICED | discord.gg/pubmethod
							}, Frame7)
						slicedfn43(sliced110, 7)
						local tbl23 = {}
						local function slicedfn54(arg6)
							for k, sliced111 in pairs(tbl23) do
								local flag23 = k == arg6
								slicedfn45(sliced111, 0.12, { BackgroundColor3 = flag23 and tbl21.acc or tbl21.input })
								sliced111.TextColor3 = flag23 and Color3.fromRGB(255, 255, 255) or tbl21.sub
							end
							if arg5 then
								arg5(arg6)
							end
						end
						for i, sliced111 in ipairs(arg3) do
							local flag23 = type(sliced111) == "table" and sliced111[1] or sliced111
							local flag24 = type(sliced111) == "table" and sliced111[2] or sliced111
							local TextButton2 = slicedfn42("TextButton", {
								Size = UDim2.new(1 / #arg3, -2, 1, -2),
								Position = UDim2.new((i - 1) / #arg3, 1, 0, 1),  -- LEAKED BY SLICED | discord.gg/pubmethod
								BackgroundColor3 = tbl21.input,
								Text = flag24,
								Font = gothamBold,
								TextSize = flag24:find("\n") and 8 or 10,
								TextColor3 = tbl21.sub,
								AutoButtonColor = false,
								BorderSizePixel = 0,
								}, sliced110)
							slicedfn43(TextButton2, 6)
							tbl23[flag23] = TextButton2  -- LEAKED BY SLICED | discord.gg/pubmethod
							TextButton2.MouseButton1Click:Connect(function()
								slicedfn54(flag23)
							end)
						end
						slicedfn54(arg4)
						return Frame7, slicedfn54
					end
					words = slicedfn53(11, "WORDS", { "1", "2", "3", "4" }, tostring(slicedn33), function(arg)
						slicedn33 = tonumber(arg) or 1
						tbl19 = {}  -- LEAKED BY SLICED | discord.gg/pubmethod
						if flag20 and not manual then
							slicedfn50(("listening... 0/%d"):format(slicedn33), "wait")
						end
					end)
					local Frame7 = slicedfn42("Frame", {
						Size = UDim2.new(1, 0, 0, 31),
						BackgroundColor3 = tbl21.panel,
						BorderSizePixel = 0,
						LayoutOrder = 12,  -- LEAKED BY SLICED | discord.gg/pubmethod
						}, Frame6)
					slicedfn43(Frame7, 8)
					sliced105 = slicedfn44(Frame7, tbl21.line, 1, 0.3)
					sliced106 = slicedfn46("SPAM", 11, tbl21.sub, gothamBold, Enum.TextXAlignment.Left, Frame7)
					sliced106.Size = UDim2.new(1, -94, 1, 0)
					sliced106.Position = UDim2.fromOffset(11, 0)
					start = slicedfn48("START", Frame7)
					start.Size = UDim2.fromOffset(70, 24)
					start.Position = UDim2.new(1, -78, 0.5, -12)
					start.TextSize = 11
					sliced107 = slicedfn42("Frame", {
						Size = UDim2.fromOffset(7, 7),
						Position = UDim2.new(0, 9, 0.5, -3.5),
						BackgroundColor3 = tbl21.line,
						BorderSizePixel = 0,
						}, start)
					slicedfn43(sliced107, 4)
					slicedfn53(13, "SPEED", { "MAX", { "WORD", "EVERY\nWORD" } }, _G.__RdmCfgBool("wordMode", false) and "WORD" or "MAX", function(arg)
						flag19 = arg == "WORD"  -- LEAKED BY SLICED | discord.gg/pubmethod
						if not flag19 then
							max = tbl22[arg] or tbl22.MAX
						end
						_G.__RdmCfgSet("speed", arg)
						_G.__RdmCfgSet("wordMode", flag19)
					end)
				end
			end
			do
				local Frame7  -- LEAKED BY SLICED | discord.gg/pubmethod
				do
					do
						do
							local sliced109 = nil
							for _, descendant in ipairs(Frame6:GetDescendants()) do
								if descendant:IsA("TextButton") and descendant.Text == "EVERY\nWORD" then
									sliced109 = descendant
									break
								else
									sliced109 = nil  -- LEAKED BY SLICED | discord.gg/pubmethod
								end
							end
							if sliced109 then
								slicedfn42("TextLabel", {
									Size = UDim2.fromOffset(64, 8),
									AnchorPoint = Vector2.new(0.5, 1),
									Position = UDim2.new(0.5, 0, 0, -1),
									BackgroundTransparency = 1,
									TextColor3 = tbl21.warn,  -- LEAKED BY SLICED | discord.gg/pubmethod
									TextTransparency = 0.35,
									Font = gothamBlack,
									TextSize = 8,
									Text = "RISKY",
									ZIndex = 3,
									}, sliced109)
							end
						end
					end
					Frame7 = slicedfn42("Frame", {  -- LEAKED BY SLICED | discord.gg/pubmethod
						Size = UDim2.new(1, 0, 0, 31),
						BackgroundColor3 = tbl21.panel,
						BorderSizePixel = 0,
						LayoutOrder = 14,
						}, Frame6)
					slicedfn43(Frame7, 8)
					slicedfn44(Frame7, tbl21.line, 1, 0.3)
					do
						local events = slicedfn46("EVENTS", 11, tbl21.sub, gothamBold, Enum.TextXAlignment.Left, Frame7)  -- LEAKED BY SLICED | discord.gg/pubmethod
						events.Size = UDim2.new(1, -104, 1, 0)
						events.Position = UDim2.fromOffset(11, 0)
					end
				end
				local blockAll = slicedfn48("BLOCK ALL", Frame7)
				blockAll.Size = UDim2.fromOffset(88, 24)
				blockAll.Position = UDim2.new(1, -97, 0.5, -12)
				blockAll.TextSize = 10
				local flag23 = false
				local sliced109 = nil  -- LEAKED BY SLICED | discord.gg/pubmethod
				local str8 = nil
				local str9 = nil
				local slicedn35 = 0
				local function slicedfn53()
					local flag24 = os.clock() < slicedn35
					local str10 = tostring(tbl20.ready) .. tostring(flag24)
					if str10 == sliced109 then
						return
					end  -- LEAKED BY SLICED | discord.gg/pubmethod
					sliced109 = str10
					blockAll.Text = flag24 and "BLOCKED" or "BLOCK ALL"
					blockAll.TextColor3 = not tbl20.ready and tbl21.sub or flag24 and tbl21.ok or tbl21.txt
				end
				blockAll.MouseButton1Click:Connect(function()
					if flag23 then
						return
					end
					if not tbl20.ready then
						local sliced110 = "err"  -- LEAKED BY SLICED | discord.gg/pubmethod
						slicedfn50("events: " .. tostring(tbl20.why), sliced110)
						return
					end
					flag23 = true
					slicedfn50("blocking events...", "busy")
					task.spawn(function()
						local ok, result, result2 = pcall(tbl20.Block)
						if ok and result then
							result2 = result2 or "blocked"  -- LEAKED BY SLICED | discord.gg/pubmethod
							str8 = result2
							str9 = "ok"
						else
							str8 = "events: " .. tostring(result2 or result)
							str9 = "err"
						end
						flag23 = false
					end)
				end)
				task.spawn(function()  -- LEAKED BY SLICED | discord.gg/pubmethod
					while Frame7.Parent do
						if str8 then
							local sliced110 = str8
							local sliced111 = str9
							str8 = nil
							str9 = nil
							if sliced111 == "ok" then
								slicedn35 = os.clock() + 1
							end
							pcall(slicedfn50, sliced110, sliced111)  -- LEAKED BY SLICED | discord.gg/pubmethod
						end
						pcall(slicedfn53)
						task.wait(0.2)
					end
				end)
				slicedfn53()
			end
		end
	end  -- LEAKED BY SLICED | discord.gg/pubmethod
	do
		local slicedfn53, Settings2
		do
			do
				do
					local slicedn35 = 548
					local slicedn36 = 36
					local tbl22 = {}
					local tbl23 = {}
					local slicedn37 = 0  -- LEAKED BY SLICED | discord.gg/pubmethod
					local function slicedfn54(arg, arg2, arg3)
						local flag23 = tbl22[arg]
						if flag23 == nil then
							flag23 = true
						end
						if flag23 == arg2 then
							return
						end
						tbl22[arg] = arg2
						local slicedn38 = (tbl23[arg] or 0) + 1  -- LEAKED BY SLICED | discord.gg/pubmethod
						tbl23[arg] = slicedn38
						slicedn37 = math.max(0, slicedn37 + (arg2 and -1 or 1))
						slicedn34 = slicedn35 - slicedn37 * slicedn36
						if not visible then
							if arg3 then
								Main.Size = UDim2.fromOffset(316, slicedn34)
							else
								slicedfn45(Main, 0.2, { Size = UDim2.fromOffset(316, slicedn34) }, Enum.EasingStyle.Quart)
							end  -- LEAKED BY SLICED | discord.gg/pubmethod
						end
						arg.ClipsDescendants = true
						if arg2 then
							arg.Visible = true
							if arg3 then
								arg.Size = UDim2.new(1, 0, 0, 31)
								arg.ClipsDescendants = false
								return
							end
							arg.Size = UDim2.new(1, 0, 0, 0)  -- LEAKED BY SLICED | discord.gg/pubmethod
							slicedfn45(arg, 0.2, { Size = UDim2.new(1, 0, 0, 31) }, Enum.EasingStyle.Quart)
							task.delay(0.22, function()
								if tbl23[arg] == slicedn38 then
									arg.ClipsDescendants = false
								end
							end)
						elseif arg3 then
							arg.Size = UDim2.new(1, 0, 0, 0)
							arg.Visible = false
							return  -- LEAKED BY SLICED | discord.gg/pubmethod
						else
							slicedfn45(arg, 0.2, { Size = UDim2.new(1, 0, 0, 0) }, Enum.EasingStyle.Quart)
							task.delay(0.22, function()
								if tbl23[arg] == slicedn38 then
									arg.Visible = false
								end
							end)
						end
					end
					slicedfn52 = function(arg)  -- LEAKED BY SLICED | discord.gg/pubmethod
						slicedfn54(words, not manual, arg)
					end
					slicedfn53 = function(arg)
						slicedfn54(Frame5, showKeybinds, arg)
						slicedfn54(Frame4, showKeybinds, arg)
					end
				end
			end
			do  -- LEAKED BY SLICED | discord.gg/pubmethod
				local sliced109
				Settings2, sliced109 = slicedfn47("Settings", 300, flag18 and 316 or 280, "SETTINGS")
				Settings2.Visible = false
				Settings2.Parent = ScreenGui
				local sliced110 = slicedfn48("X", sliced109)
				sliced110.Size = UDim2.fromOffset(22, 22)
				sliced110.Position = UDim2.new(1, -28, 0.5, -11)
				sliced110.TextSize = 12
				sliced110.MouseButton1Click:Connect(function()  -- LEAKED BY SLICED | discord.gg/pubmethod
					Settings2.Visible = false
				end)
			end
		end
		local Frame6
		do
			Frame6 = slicedfn42("Frame", {
				Size = UDim2.new(1, -20, 1, -60),
				Position = UDim2.fromOffset(10, 50),
				BackgroundTransparency = 1,  -- LEAKED BY SLICED | discord.gg/pubmethod
				BorderSizePixel = 0,
				}, Settings2)
			slicedfn42("UIListLayout", {
				Padding = UDim.new(0, 5),
				SortOrder = Enum.SortOrder.LayoutOrder,
				}, Frame6)
			slicedfn51(Frame6, 1, "AUTO LISTEN", autoListen, function(arg)
				autoListen = arg
				_G.__RdmCfgSet("autoListen", arg)  -- LEAKED BY SLICED | discord.gg/pubmethod
			end)
			slicedfn51(Frame6, 2, "SPAM ON LISTEN", sliced95, function(arg)
				sliced95 = arg
				_G.__RdmCfgSet("spamOnListen", arg)
			end)
			slicedfn51(Frame6, 3, "SHOW KEYBINDS", showKeybinds, function(arg)
				showKeybinds = arg
				slicedfn53()
				_G.__RdmCfgSet("showKeybinds", arg)
			end)  -- LEAKED BY SLICED | discord.gg/pubmethod
			slicedfn51(Frame6, 4, "IGNORE SYSTEM PHRASES", sliced96, function(arg)
				sliced96 = arg
				_G.__RdmCfgSet("ignoreSystem", arg)
			end)
			do
				local sliced109 = slicedfn51(Frame6, 6, "DUO MODE (WITH RIDDLER)", _G.__RdmDuo, function(rdmDuo)
					_G.__RdmDuo = rdmDuo
					_G.__RdmCfgSet("duo", rdmDuo)
					if _G.__SabDuoSync then  -- LEAKED BY SLICED | discord.gg/pubmethod
						_G.__SabDuoSync()
					end
					return
				end)
				local sliced110 = slicedfn46("0/2", 10, tbl21.sub, gothamBold, Enum.TextXAlignment.Right, sliced109)
				sliced110.Size = UDim2.fromOffset(50, 31)
				sliced110.Position = UDim2.new(1, -84, 0, 0)
				for _, child in ipairs(sliced109:GetChildren()) do
					if child:IsA("TextLabel") and child ~= sliced110 then
						child.Size = UDim2.new(1, -100, 1, 0)  -- LEAKED BY SLICED | discord.gg/pubmethod
					end
				end
				local function redeemer()
					local slicedn35 = (_G.__RiddlerDuo and 1 or 0) + (_G.__RdmDuo and 1 or 0)
					sliced110.Text = slicedn35 .. "/2"
					sliced110.TextColor3 = slicedn35 == 2 and tbl21.acc or slicedn35 == 1 and (tbl21.warn or tbl21.sub) or tbl21.sub
				end
				redeemer()
				_G.__SabDuoRefresh = _G.__SabDuoRefresh or {}
				_G.__SabDuoRefresh.redeemer = redeemer  -- LEAKED BY SLICED | discord.gg/pubmethod
				_G.__SabDuoSync = function()
					local sliced111 = pairs
					local sabDuoRefresh = _G.__SabDuoRefresh or {}
					for _, sliced112 in sliced111(sabDuoRefresh) do
						pcall(sliced112)
					end
				end
				_G.__SabDuoSync()
				task.spawn(function()  -- LEAKED BY SLICED | discord.gg/pubmethod
					while sliced109.Parent do
						redeemer()
						task.wait(1)
					end
				end)
			end
		end
		do
			local Frame7
			do  -- LEAKED BY SLICED | discord.gg/pubmethod
				if flag18 then
					local Frame8
					do
						local Frame9 = slicedfn42("Frame", {
							Size = UDim2.new(1, 0, 0, 31),
							BackgroundColor3 = tbl21.panel,
							BorderSizePixel = 0,
							LayoutOrder = 5,
							}, Frame6)
						slicedfn43(Frame9, 8)  -- LEAKED BY SLICED | discord.gg/pubmethod
						slicedfn44(Frame9, tbl21.line, 1, 0.3)
						local uiSize = slicedfn46("UI SIZE", 11, tbl21.sub, gothamBold, Enum.TextXAlignment.Left, Frame9)
						uiSize.Size = UDim2.fromOffset(70, 31)
						uiSize.Position = UDim2.fromOffset(11, 0)
						Frame8 = slicedfn42("Frame", {
							Size = UDim2.fromOffset(168, 23),
							Position = UDim2.new(1, -177, 0.5, -11.5),
							BackgroundColor3 = tbl21.input,
							BorderSizePixel = 0,
							}, Frame9)  -- LEAKED BY SLICED | discord.gg/pubmethod
					end
					slicedfn43(Frame8, 7)
					do
						local tbl22 = {}
						local function slicedfn54(arg, arg2)
							for k, sliced109 in pairs(tbl22) do
								local flag23 = k == arg
								slicedfn45(sliced109, 0.12, { BackgroundColor3 = flag23 and tbl21.acc or tbl21.input })
								sliced109.TextColor3 = flag23 and Color3.fromRGB(255, 255, 255) or tbl21.sub  -- LEAKED BY SLICED | discord.gg/pubmethod
							end
							if arg2 then
								return
							end
							_G.__RdmCfgSet("uiSize", arg)
							if tbl18.refit then
								tbl18.refit()
							end
						end
						local tbl23 = { "BIG", "MEDIUM", "SMALL" }  -- LEAKED BY SLICED | discord.gg/pubmethod
						for i, sliced109 in ipairs(tbl23) do
							local TextButton2 = slicedfn42("TextButton", {
								Size = UDim2.new(1 / #tbl23, -2, 1, -2),
								Position = UDim2.new((i - 1) / #tbl23, 1, 0, 1),
								BackgroundColor3 = tbl21.input,
								Text = sliced109,
								Font = gothamBold,
								TextSize = 9,
								TextColor3 = tbl21.sub,  -- LEAKED BY SLICED | discord.gg/pubmethod
								AutoButtonColor = false,
								BorderSizePixel = 0,
								}, Frame8)
							slicedfn43(TextButton2, 6)
							tbl22[sliced109] = TextButton2
							TextButton2.MouseButton1Click:Connect(function()
								slicedfn54(sliced109)
							end)
						end  -- LEAKED BY SLICED | discord.gg/pubmethod
						slicedfn54(_G.__RdmCfgStr("uiSize", "MEDIUM"), true)
					end
				end
				Frame7 = slicedfn42("Frame", {
					Size = UDim2.new(1, 0, 0, 31),
					BackgroundColor3 = tbl21.panel,
					BorderSizePixel = 0,
					LayoutOrder = 6,
					}, Frame6)
				slicedfn43(Frame7, 8)  -- LEAKED BY SLICED | discord.gg/pubmethod
				slicedfn44(Frame7, tbl21.line, 1, 0.3)
				do
					local autoBuy = slicedfn46("AUTO BUY", 11, tbl21.sub, gothamBold, Enum.TextXAlignment.Left, Frame7)
					autoBuy.Size = UDim2.new(1, -70, 1, 0)
					autoBuy.Position = UDim2.fromOffset(12, 0)
				end
			end
			local open = slicedfn48("OPEN", Frame7)
			open.Size = UDim2.fromOffset(52, 22)  -- LEAKED BY SLICED | discord.gg/pubmethod
			open.Position = UDim2.new(1, -60, 0.5, -11)
			open.TextSize = 10
			open.MouseButton1Click:Connect(function()
				Settings2.Visible = false
				if slicedfn31 then
					slicedfn31()
				end
			end)
		end
		do
			local function slicedfn54()
				if flag18 then
					Settings2.Position = UDim2.new(0.5, -math.floor(Settings2.AbsoluteSize.X / 2), 0.5, -math.floor(Settings2.AbsoluteSize.Y / 2))
				else
					local position = Main.Position
					Settings2.Position = UDim2.new(position.X.Scale, position.X.Offset - Settings2.AbsoluteSize.X - 10, position.Y.Scale, position.Y.Offset)
				end
				Settings2.Visible = true
			end  -- LEAKED BY SLICED | discord.gg/pubmethod
			sliced108 = slicedfn54
			Settings.MouseButton1Click:Connect(function()
				if not Settings2.Visible then
					slicedfn54()
					return
				end
				Settings2.Visible = false
			end)
		end  -- LEAKED BY SLICED | discord.gg/pubmethod
		slicedfn53(true)
	end
	slicedfn52(true)
end
local Frame4, slicedfn52, slicedfn53, tbl22
do
	do
		do
			local Feed, sliced109, sliced110
			do  -- LEAKED BY SLICED | discord.gg/pubmethod
				do
					local sliced111
					Feed, sliced111 = slicedfn47("Feed", 300, 320, "LIVE FEED")
					Feed.Visible = false
					Feed.Parent = ScreenGui
					Frame4 = slicedfn42("Frame", {
						Size = UDim2.fromOffset(8, 8),
						Position = UDim2.new(1, -176, 0.5, -4),
						BackgroundColor3 = tbl21.sub,
						BorderSizePixel = 0,  -- LEAKED BY SLICED | discord.gg/pubmethod
						}, sliced111)
					slicedfn43(Frame4, 4)
					sliced109 = slicedfn46("0 caught", 10, tbl21.sub, gothamBold, Enum.TextXAlignment.Right, sliced111)
					sliced109.Size = UDim2.fromOffset(80, 44)
					sliced109.Position = UDim2.new(1, -166, 0, 0)
					sliced110 = slicedfn48("CLEAR", sliced111)
					sliced110.Size = UDim2.fromOffset(40, 22)
					sliced110.Position = UDim2.new(1, -82, 0.5, -11)
					sliced110.TextSize = 10  -- LEAKED BY SLICED | discord.gg/pubmethod
					local sliced112 = slicedfn48("X", sliced111)
					sliced112.Size = UDim2.fromOffset(22, 22)
					sliced112.Position = UDim2.new(1, -32, 0.5, -11)
					sliced112.TextSize = 12
					sliced112.MouseButton1Click:Connect(function()
						Feed.Visible = false
					end)
				end
			end
			local ScrollingFrame = slicedfn42("ScrollingFrame", {  -- LEAKED BY SLICED | discord.gg/pubmethod
				Size = UDim2.new(1, -18, 1, -56),
				Position = UDim2.fromOffset(11, 50),
				BackgroundTransparency = 1,
				BorderSizePixel = 0,
				ScrollBarThickness = 3,
				ScrollBarImageColor3 = tbl21.acc,
				ScrollBarImageTransparency = 0.3,
				CanvasSize = UDim2.new(),
				AutomaticCanvasSize = Enum.AutomaticSize.Y,
				ScrollingDirection = Enum.ScrollingDirection.Y,  -- LEAKED BY SLICED | discord.gg/pubmethod
				}, Feed)
			slicedfn42("UIListLayout", {
				Padding = UDim.new(0, 6),
				SortOrder = Enum.SortOrder.LayoutOrder,
				}, ScrollingFrame)
			local sliced111 = slicedfn46("waiting for announcements...", 11, tbl21.sub, gothamMedium, Enum.TextXAlignment.Center, ScrollingFrame)
			sliced111.Size = UDim2.new(1, 0, 0, 34)
			sliced111.LayoutOrder = 999
			local tbl23 = {}  -- LEAKED BY SLICED | discord.gg/pubmethod
			local slicedn35 = 0
			slicedfn52 = nil
			local function slicedfn54()
				if flag18 then
					Feed.Position = UDim2.new(0.5, -math.floor(Feed.AbsoluteSize.X / 2), 0.5, -math.floor(Feed.AbsoluteSize.Y / 2))
				else
					local position = Main.Position
					Feed.Position = UDim2.new(position.X.Scale, position.X.Offset - Feed.AbsoluteSize.X - 10, position.Y.Scale, position.Y.Offset)
				end  -- LEAKED BY SLICED | discord.gg/pubmethod
				Feed.Visible = true
			end
			slicedfn53 = function(arg, arg2)
				if sliced111 then
					sliced111:Destroy()
					sliced111 = nil
				end
				slicedn35 += 1
				sliced109.Text = slicedn35 .. " caught"
				local Frame5 = slicedfn42("Frame", {  -- LEAKED BY SLICED | discord.gg/pubmethod
					Size = UDim2.new(1, -4, 0, 0),
					AutomaticSize = Enum.AutomaticSize.Y,
					BackgroundColor3 = tbl21.panel,
					BorderSizePixel = 0,
					LayoutOrder = -slicedn35,
					}, ScrollingFrame)
				slicedfn43(Frame5, 9)
				slicedfn44(Frame5, arg2 and tbl21.acc or tbl21.line, 1, arg2 and 0.3 or 0.5)
				slicedfn42("UIPadding", {  -- LEAKED BY SLICED | discord.gg/pubmethod
					PaddingTop = UDim.new(0, 8),
					PaddingBottom = UDim.new(0, 8),
					PaddingLeft = UDim.new(0, 10),
					PaddingRight = UDim.new(0, 10),
					}, Frame5)
				slicedfn42("UIListLayout", { Padding = UDim.new(0, 5), SortOrder = Enum.SortOrder.LayoutOrder }, Frame5)
				local sliced112 = slicedfn42("Frame", { Size = UDim2.new(1, 0, 0, 12), BackgroundTransparency = 1, LayoutOrder = 1 }, Frame5)
				slicedfn43(slicedfn42("Frame", {
					Size = UDim2.fromOffset(6, 6),
					Position = UDim2.new(0, 0, 0.5, -3),  -- LEAKED BY SLICED | discord.gg/pubmethod
					BackgroundColor3 = arg2 and tbl21.acc or tbl21.sub,
					BorderSizePixel = 0,
					}, sliced112), 3)
				slicedfn46("NOTIFY", 8, tbl21.acc, gothamBlack, Enum.TextXAlignment.Left, sliced112).Position = UDim2.fromOffset(12, 0)
				local sub = tbl21.sub
				local right = Enum.TextXAlignment.Right
				local sliced113 = slicedfn46(os.date("%H:%M:%S"), 8, sub, gothamMedium, right, sliced112)
				sliced113.Size = UDim2.new(0, 60, 1, 0)
				sliced113.Position = UDim2.new(1, -60, 0, 0)  -- LEAKED BY SLICED | discord.gg/pubmethod
				local sliced114 = slicedfn46(arg, 10, tbl21.txt, gothamMedium, Enum.TextXAlignment.Left, Frame5)
				sliced114.Size = UDim2.new(1, 0, 0, 0)
				sliced114.AutomaticSize = Enum.AutomaticSize.Y
				sliced114.TextWrapped = true
				sliced114.LayoutOrder = 2
				if arg2 then
					local Frame6 = slicedfn42("Frame", {
						Size = UDim2.new(1, 0, 0, 24),
						BackgroundTransparency = 1,
						LayoutOrder = 3,  -- LEAKED BY SLICED | discord.gg/pubmethod
						}, Frame5)
					local TextLabel = slicedfn42("TextLabel", {
						Size = UDim2.new(0.5, -3, 1, 0),
						BackgroundColor3 = tbl21.input,
						Text = arg2,
						Font = gothamBlack,
						TextSize = 12,
						TextColor3 = tbl21.acc,
						BorderSizePixel = 0,  -- LEAKED BY SLICED | discord.gg/pubmethod
						}, Frame6)
					slicedfn43(TextLabel, 6)
					slicedfn44(TextLabel, tbl21.acc, 1, 0.4)
					local copy = slicedfn48("COPY", Frame6)
					copy.Size = UDim2.new(0.22, -3, 1, 0)
					copy.Position = UDim2.new(0.52, 3, 0, 0)
					copy.TextSize = 9
					copy.MouseButton1Click:Connect(function()
						copy.Text = slicedfn35(arg2) and "OK" or "ERR"
						task.delay(0.7, function()
							if copy.Parent then
								copy.Text = "COPY"
							end
						end)
					end)
					local sliced115 = slicedfn49("USE", Frame6)
					sliced115.Size = UDim2.new(0.26, -3, 1, 0)
					sliced115.Position = UDim2.new(0.74, 3, 0, 0)
					sliced115.TextSize = 10  -- LEAKED BY SLICED | discord.gg/pubmethod
					sliced115.MouseButton1Click:Connect(function()
						sliced115.Text = "..."
						slicedfn52(arg2)
						sliced115.Text = "USE"
					end)
				end
				table.insert(tbl23, Frame5)
				if #tbl23 > tbl18.maxFeed then
					local sliced115 = table.remove(tbl23, 1)  -- LEAKED BY SLICED | discord.gg/pubmethod
					if sliced115 then
						sliced115:Destroy()
					end
				end
			end
			sliced110.MouseButton1Click:Connect(function()
				for _, sliced112 in ipairs(tbl23) do
					sliced112:Destroy()
				end
				tbl23 = {}  -- LEAKED BY SLICED | discord.gg/pubmethod
				slicedn35 = 0
				sliced109.Text = "0 caught"
				if not sliced111 then
					sliced111 = slicedfn46("waiting for announcements...", 11, tbl21.sub, gothamMedium, Enum.TextXAlignment.Center, ScrollingFrame)
					sliced111.Size = UDim2.new(1, 0, 0, 34)
					sliced111.LayoutOrder = 999
				end
			end)
			sliced98.MouseButton1Click:Connect(function()  -- LEAKED BY SLICED | discord.gg/pubmethod
				if Feed.Visible then
					Feed.Visible = false
					return
				end
				slicedfn54()
			end)
		end
		do
			local sliced109, sliced110, TextBox2
			do  -- LEAKED BY SLICED | discord.gg/pubmethod
				do
					local sliced111
					sliced109, sliced111 = slicedfn47("Test", 300, 178, "FAKE NOTIFY")
					sliced109.Visible = false
					sliced109.Parent = ScreenGui
					local sliced112 = slicedfn48("X", sliced111)
					sliced112.Size = UDim2.fromOffset(22, 22)
					sliced112.Position = UDim2.new(1, -28, 0.5, -11)
					sliced112.TextSize = 12
					sliced112.MouseButton1Click:Connect(function()  -- LEAKED BY SLICED | discord.gg/pubmethod
						sliced109.Visible = false
					end)
				end
				do
					sliced110 = slicedfn42("Frame", {
						Size = UDim2.new(1, -24, 1, -58),
						Position = UDim2.fromOffset(12, 50),
						BackgroundTransparency = 1,
						}, sliced109)
					slicedfn42("UIListLayout", {  -- LEAKED BY SLICED | discord.gg/pubmethod
						Padding = UDim.new(0, 8),
						SortOrder = Enum.SortOrder.LayoutOrder,
						}, sliced110)
					do
						local Frame5 = slicedfn42("Frame", {
							Size = UDim2.new(1, 0, 0, 54),
							BackgroundColor3 = tbl21.panel,
							BorderSizePixel = 0,
							LayoutOrder = 1,  -- LEAKED BY SLICED | discord.gg/pubmethod
							}, sliced110)
						slicedfn43(Frame5, 9)
						slicedfn44(Frame5, tbl21.line, 1, 0.3)
						local message = slicedfn46("MESSAGE", 9, tbl21.acc, gothamBlack, Enum.TextXAlignment.Left, Frame5)
						message.Size = UDim2.new(1, -16, 0, 12)
						message.Position = UDim2.fromOffset(11, 6)
						TextBox2 = slicedfn42("TextBox", {
							Size = UDim2.new(1, -18, 0, 26),
							Position = UDim2.fromOffset(9, 20),
							BackgroundColor3 = tbl21.input,  -- LEAKED BY SLICED | discord.gg/pubmethod
							Text = "",
							PlaceholderText = "type a fake announcement...",
							PlaceholderColor3 = tbl21.sub,
							Font = gothamBlack,
							TextSize = 12,
							TextColor3 = tbl21.txt,
							ClearTextOnFocus = false,
							BorderSizePixel = 0,
							TextXAlignment = Enum.TextXAlignment.Left,
							}, Frame5)  -- LEAKED BY SLICED | discord.gg/pubmethod
					end
				end
				slicedfn43(TextBox2, 7)
				do
					local sliced111 = slicedfn44(TextBox2, tbl21.line, 1.2, 0.25)
					slicedfn42("UIPadding", {
						PaddingLeft = UDim.new(0, 9),
						PaddingRight = UDim.new(0, 9),
						}, TextBox2)  -- LEAKED BY SLICED | discord.gg/pubmethod
					TextBox2.Focused:Connect(function()
						slicedfn45(sliced111, 0.12, { Color = tbl21.acc, Transparency = 0 })
					end)
					TextBox2.FocusLost:Connect(function()
						slicedfn45(sliced111, 0.12, { Color = tbl21.line, Transparency = 0.25 })
					end)
				end
			end
			local testCode, send  -- LEAKED BY SLICED | discord.gg/pubmethod
			do
				local sliced111 = slicedfn42("Frame", {
					Size = UDim2.new(1, 0, 0, 34),
					BackgroundTransparency = 1,
					LayoutOrder = 2,
					}, sliced110)
				testCode = slicedfn48("TEST CODE", sliced111)
				testCode.Size = UDim2.new(0.4, -4, 1, 0)
				send = slicedfn49("SEND", sliced111)
			end  -- LEAKED BY SLICED | discord.gg/pubmethod
			send.Size = UDim2.new(0.6, -4, 1, 0)
			send.Position = UDim2.new(0.4, 4, 0, 0)
			do
				local sliced111 = slicedfn46("", 10, tbl21.sub, gothamMedium, Enum.TextXAlignment.Left, sliced110)
				sliced111.Size = UDim2.new(1, -4, 0, 14)
				sliced111.LayoutOrder = 3
				local function slicedfn54(arg)
					local localTest = slicedfn34(arg)
					if localTest == "" then  -- LEAKED BY SLICED | discord.gg/pubmethod
						sliced111.Text = "nothing to send"
						sliced111.TextColor3 = tbl21.err
						return
					end
					if not (sliced94 and not flag22 and typeof(firesignal) == "function") then
						local ok = pcall(slicedfn30, localTest, nil, nil, "Top", 2678001507)
						sliced111.Text = ok and "local test: " .. localTest or "handler error"
						sliced111.TextColor3 = ok and tbl21.ok or tbl21.err
						return  -- LEAKED BY SLICED | discord.gg/pubmethod
					end
					local ok = pcall(firesignal, sliced94.OnClientEvent, localTest, nil, nil, "Top", 2678001507)
					sliced111.Text = ok and "fired: " .. localTest or "firesignal failed"
					sliced111.TextColor3 = ok and tbl21.ok or tbl21.err
					return
				end
				send.MouseButton1Click:Connect(function()
					slicedfn54(TextBox2.Text)
					TextBox2.Text = ""
					TextBox2:CaptureFocus()  -- LEAKED BY SLICED | discord.gg/pubmethod
				end)
				TextBox2.FocusLost:Connect(function(enterPressed)
					if enterPressed then
						slicedfn54(TextBox2.Text)
						TextBox2.Text = ""
						TextBox2:CaptureFocus()
					end
				end)
				testCode.MouseButton1Click:Connect(function()
					slicedfn54("TESTCODE" .. tostring(math.random(1000, 9999)))  -- LEAKED BY SLICED | discord.gg/pubmethod
				end)
			end
			sliced97.MouseButton1Click:Connect(function()
				if sliced109.Visible then
					sliced109.Visible = false
					return
				end
				if flag18 then
					sliced109.Position = UDim2.new(0.5, -math.floor(sliced109.AbsoluteSize.X / 2), 0.5, -math.floor(sliced109.AbsoluteSize.Y / 2))
				else  -- LEAKED BY SLICED | discord.gg/pubmethod
					local position = Main.Position
					sliced109.Position = UDim2.new(position.X.Scale, position.X.Offset - sliced109.AbsoluteSize.X - 10, position.Y.Scale, position.Y.Offset + Main.AbsoluteSize.Y - sliced109.AbsoluteSize.Y)
				end
				sliced109.Visible = true
			end)
		end
	end
	do
		local slicedfn54, slicedfn55, slicedfn56, slicedfn57, slicedfn58, slicedfn59, slicedfn60, slicedfn61, slicedfn62, slicedfn63  -- LEAKED BY SLICED | discord.gg/pubmethod
		local slicedfn64
		do
			do
				if _G.__AntiRagdollToggleCleanup then
					pcall(_G.__AntiRagdollToggleCleanup)
				end
				tbl22 = {
					Enabled = false,
					Connections = {},
					Welds = {},  -- LEAKED BY SLICED | discord.gg/pubmethod
					LastPosition = nil,
					JumpPauseUntil = 0,
					JumpPauseDuration = 0.6,
					KnockbackThreshold = 35,
					MaxUpwardVelocity = 60,
					MaxHorizontalVelocity = 12,
					MaxFrameDisplacement = 10,
				}
				do  -- LEAKED BY SLICED | discord.gg/pubmethod
					local tbl23 = {
						"ragdoll",
						"knock",
						"launch",
						"stun",
						"fall",
						"down",
						"flop",
						"trip",
						"push",  -- LEAKED BY SLICED | discord.gg/pubmethod
						"shove",
						"blast",
						"force",
					}
					local tbl24 = {
						"BodyVelocity",
						"BodyPosition",
						"BodyGyro",
						"BodyForce",
						"BodyAngularVelocity",  -- LEAKED BY SLICED | discord.gg/pubmethod
						"RocketPropulsion",
						"BodyThrust",
						"LinearVelocity",
						"AngularVelocity",
						"VectorForce",
						"Torque",
					}
					slicedfn54 = function(arg)
						for _, sliced109 in ipairs(tbl24) do  -- LEAKED BY SLICED | discord.gg/pubmethod
							if arg:IsA(sliced109) then
								return true
							end
						end
						return false
					end
					slicedfn55 = function(arg)
						local str8 = arg:lower()
						for _, sliced109 in ipairs(tbl23) do
							if str8:find(sliced109) then  -- LEAKED BY SLICED | discord.gg/pubmethod
								return true
							end
						end
						return false
					end
				end
			end
			slicedfn56 = function()
				local character = sliced89.Character  -- LEAKED BY SLICED | discord.gg/pubmethod
				if character then
					local humanoid = character:FindFirstChildOfClass("Humanoid")
					local humanoidRootPart = character:FindFirstChild("HumanoidRootPart")
					local animator = humanoid and humanoid:FindFirstChildOfClass("Animator")
					if humanoid and humanoidRootPart and animator then
						return character, humanoid, humanoidRootPart, animator
					end
					return
				end
			end  -- LEAKED BY SLICED | discord.gg/pubmethod
			slicedfn57 = function(arg)
				local jumpPauseUntil = tbl22.JumpPauseUntil
				if tick() < jumpPauseUntil then
					return true
				end
				if arg then
					local state = arg:GetState()
					if state == Enum.HumanoidStateType.Jumping or state == Enum.HumanoidStateType.Freefall then
						return true  -- LEAKED BY SLICED | discord.gg/pubmethod
					end
				end
				return false
			end
			slicedfn58 = function()
				for _, weld in ipairs(tbl22.Welds) do
					pcall(function()
						weld:Destroy()
					end)  -- LEAKED BY SLICED | discord.gg/pubmethod
				end
				tbl22.Welds = {}
			end
			slicedfn59 = function(arg, part0)
				if not arg or not part0 then
					return
				end
				slicedfn58()
				for _, descendant in ipairs(arg:GetDescendants()) do
					if descendant:IsA("BasePart") and descendant ~= part0 then  -- LEAKED BY SLICED | discord.gg/pubmethod
						local instance = Instance.new("WeldConstraint")
						instance.Name = "AntiRagdollWeld"
						instance.Part0 = part0
						instance.Part1 = descendant
						instance.Parent = part0
						table.insert(tbl22.Welds, instance)
					end
				end
			end
			slicedfn60 = function(arg, arg2)  -- LEAKED BY SLICED | discord.gg/pubmethod
				pcall(function()
					arg:SetStateEnabled(Enum.HumanoidStateType.Ragdoll, arg2)
					arg:SetStateEnabled(Enum.HumanoidStateType.Physics, arg2)
					arg:SetStateEnabled(Enum.HumanoidStateType.FallingDown, arg2)
					arg:SetStateEnabled(Enum.HumanoidStateType.PlatformStanding, arg2)
				end)
			end
			slicedfn61 = function(arg, arg2)
				if not arg then  -- LEAKED BY SLICED | discord.gg/pubmethod
					return
				end
				for _, descendant in ipairs(arg:GetDescendants()) do
					if descendant:IsA("BallSocketConstraint") or descendant:IsA("HingeConstraint") or descendant:IsA("RopeConstraint") or descendant:IsA("RodConstraint") then
						pcall(function()
							descendant:Destroy()
						end)
					elseif slicedfn54(descendant) then
						local parent = descendant.Parent
						local name = parent and parent.Name or ""  -- LEAKED BY SLICED | discord.gg/pubmethod
						if parent == arg2 or slicedfn55(descendant.Name) or slicedfn55(name) then
							pcall(function()
								descendant:Destroy()
							end)
						end
					end
				end
			end
			slicedfn62 = function(arg)
				if not arg then  -- LEAKED BY SLICED | discord.gg/pubmethod
					return
				end
				for _, descendant in ipairs(arg:GetDescendants()) do
					if descendant:IsA("Motor6D") then
						descendant.Enabled = true
					end
				end
			end
			do
				local function slicedfn65(arg, arg2)  -- LEAKED BY SLICED | discord.gg/pubmethod
					if not arg then
						return
					end
					for _, descendant in ipairs(arg:GetDescendants()) do
						if descendant:IsA("BasePart") then
							if descendant == arg2 then
								descendant.CanCollide = false
								descendant.Massless = false
								pcall(function()  -- LEAKED BY SLICED | discord.gg/pubmethod
									descendant.CustomPhysicalProperties = PhysicalProperties.new(50, 0.3, 0.5, 100, 100)
								end)
							else
								descendant.CanCollide = false
								descendant.Massless = true
							end
						end
					end
				end
				slicedfn63 = function(arg)
					pcall(function()
						if arg:CanSetNetworkOwnership() then
							arg:SetNetworkOwner(sliced89)
						end
					end)
				end
				slicedfn64 = function(arg, cameraSubject, arg2)
					if not (not arg or not cameraSubject or cameraSubject.Health <= 0) then
						cameraSubject.PlatformStand = false  -- LEAKED BY SLICED | discord.gg/pubmethod
						cameraSubject.Sit = false
						cameraSubject.AutoRotate = true
						cameraSubject.BreakJointsOnDeath = false
						cameraSubject.RequiresNeck = false
						if cameraSubject.WalkSpeed < 1 then
							cameraSubject.WalkSpeed = 16
						end
						if cameraSubject.JumpPower < 1 and cameraSubject.JumpHeight < 1 then
							cameraSubject.JumpPower = 50  -- LEAKED BY SLICED | discord.gg/pubmethod
						end
						slicedfn62(arg)
						slicedfn65(arg, arg2)
						local currentCamera = workspace.CurrentCamera
						if currentCamera and currentCamera.CameraSubject ~= cameraSubject then
							currentCamera.CameraSubject = cameraSubject
						end
						return
					end
				end  -- LEAKED BY SLICED | discord.gg/pubmethod
			end
		end
		local slicedfn65, slicedfn66
		do
			do
				local function slicedfn67(arg)
					local currentCamera = workspace.CurrentCamera
					currentCamera = currentCamera and currentCamera.CFrame.LookVector or arg.CFrame.LookVector
					local vector = Vector3.new(currentCamera.X, 0, currentCamera.Z)
					if vector.Magnitude < 0.05 then  -- LEAKED BY SLICED | discord.gg/pubmethod
						local lookVector = arg.CFrame.LookVector
						vector = Vector3.new(lookVector.X, 0, lookVector.Z)
					end
					if vector.Magnitude < 0.05 then
						return Vector3.new(0, 0, -1)
					end
					return vector.Unit
				end
				slicedfn65 = function(arg)
					local assemblyLinearVelocity = arg.AssemblyLinearVelocity  -- LEAKED BY SLICED | discord.gg/pubmethod
					arg.AssemblyAngularVelocity = Vector3.zero
					local z = assemblyLinearVelocity.Z
					arg.AssemblyLinearVelocity = Vector3.new(math.clamp(assemblyLinearVelocity.X, -tbl22.MaxHorizontalVelocity, tbl22.MaxHorizontalVelocity), math.clamp(assemblyLinearVelocity.Y, -50, tbl22.MaxUpwardVelocity), math.clamp(z, -tbl22.MaxHorizontalVelocity, tbl22.MaxHorizontalVelocity))
				end
				slicedfn66 = function(arg, arg2, arg3, arg4)
					if not arg or not arg2 or not arg3 or arg2.Health <= 0 then
						return
					end
					slicedfn64(arg, arg2, arg3)
					local sliced109 = slicedfn67(arg3)  -- LEAKED BY SLICED | discord.gg/pubmethod
					if not slicedfn57(arg2) then
						slicedfn65(arg3)
					end
					arg3.CFrame = arg3.CFrame:Lerp(CFrame.lookAt(arg3.Position, arg3.Position + sliced109), arg4 and 1 or 0.5)
					arg2.PlatformStand = false
					arg2.Sit = false
					arg2:ChangeState(Enum.HumanoidStateType.GettingUp)
					task.defer(function()
						if arg2.Parent and arg2.Health > 0 then  -- LEAKED BY SLICED | discord.gg/pubmethod
							arg2:ChangeState(Enum.HumanoidStateType.Running)
						end
					end)
				end
			end
		end
		do
			local function slicedfn67(arg)
				if not arg then
					return  -- LEAKED BY SLICED | discord.gg/pubmethod
				end
				for _, sliced109 in ipairs(arg:GetPlayingAnimationTracks()) do
					if slicedfn55(sliced109.Animation and sliced109.Animation.Name or "") then
						sliced109:Stop(0)
					end
				end
			end
			local function slicedfn68(arg, arg2, arg3, arg4)
				if not arg or not arg2 or arg2.Health <= 0 then  -- LEAKED BY SLICED | discord.gg/pubmethod
					return
				end
				slicedfn61(arg, arg3)
				slicedfn64(arg, arg2, arg3)
				slicedfn67(arg4)
				slicedfn63(arg3)
				pcall(function()
					local playerModule = sliced89.PlayerScripts:FindFirstChild("PlayerModule")
					if playerModule then
						local controls = require(playerModule):GetControls()  -- LEAKED BY SLICED | discord.gg/pubmethod
						if controls then
							controls:Enable()
						end
					end
				end)
			end
			tbl22.Disable = function(arg)
				arg.Enabled = false
				arg.LastPosition = nil
				arg.JumpPauseUntil = 0  -- LEAKED BY SLICED | discord.gg/pubmethod
				for _, connection in ipairs(arg.Connections) do
					pcall(function()
						connection:Disconnect()
					end)
				end
				arg.Connections = {}
				slicedfn58()
				local _, sliced109 = slicedfn56()
				if sliced109 then  -- LEAKED BY SLICED | discord.gg/pubmethod
					slicedfn60(sliced109, true)
				end
			end
			tbl22.Enable = function(arg)
				if arg.Enabled then
					return
				end
				arg.Enabled = true
				local sliced109, sliced110, sliced111, sliced112 = slicedfn56()
				if not sliced109 then  -- LEAKED BY SLICED | discord.gg/pubmethod
					arg.Enabled = false
					return
				end
				slicedfn68(sliced109, sliced110, sliced111, sliced112)
				slicedfn60(sliced110, false)
				slicedfn66(sliced109, sliced110, sliced111, true)
				slicedfn59(sliced109, sliced111)
				arg.LastPosition = sliced111.Position
				table.insert(arg.Connections, sliced86.JumpRequest:Connect(function()  -- LEAKED BY SLICED | discord.gg/pubmethod
					if not arg.Enabled then
						return
					end
					local jumpPauseDuration = arg.JumpPauseDuration
					arg.JumpPauseUntil = tick() + jumpPauseDuration
				end))
				table.insert(arg.Connections, sliced86.InputBegan:Connect(function(input, gameProcessed)
					if not arg.Enabled or gameProcessed then
						return
					end  -- LEAKED BY SLICED | discord.gg/pubmethod
					if input.KeyCode == Enum.KeyCode.Space or input.KeyCode == Enum.KeyCode.ButtonA then
						local jumpPauseDuration = arg.JumpPauseDuration
						arg.JumpPauseUntil = tick() + jumpPauseDuration
					end
				end))
				table.insert(arg.Connections, sliced88.Stepped:Connect(function()
					if not arg.Enabled then
						return
					end  -- LEAKED BY SLICED | discord.gg/pubmethod
					local sliced113, sliced114, sliced115 = slicedfn56()
					if not sliced113 or sliced114.Health <= 0 then
						return
					end
					if not slicedfn57(sliced114) then
						slicedfn65(sliced115)
					end
					slicedfn63(sliced115)
				end))
				table.insert(arg.Connections, sliced88.Heartbeat:Connect(function()  -- LEAKED BY SLICED | discord.gg/pubmethod
					if not arg.Enabled then
						return
					end
					local sliced113, sliced114, sliced115, sliced116 = slicedfn56()
					if not sliced113 or sliced114.Health <= 0 then
						return
					end
					slicedfn60(sliced114, false)
					slicedfn64(sliced113, sliced114, sliced115)
					slicedfn61(sliced113, sliced115)  -- LEAKED BY SLICED | discord.gg/pubmethod
					local sliced117 = slicedfn57(sliced114)
					local state = sliced114:GetState()
					local flag23 = state == Enum.HumanoidStateType.Ragdoll or state == Enum.HumanoidStateType.Physics or state == Enum.HumanoidStateType.FallingDown or state == Enum.HumanoidStateType.PlatformStanding or state == Enum.HumanoidStateType.Seated
					local flag24 = sliced115.CFrame.UpVector.Y < 0.85
					if flag23 or flag24 then
						slicedfn66(sliced113, sliced114, sliced115, flag24 and sliced115.CFrame.UpVector.Y < 0.5)
						slicedfn67(sliced116)
					end
					if sliced117 then  -- LEAKED BY SLICED | discord.gg/pubmethod
						arg.LastPosition = sliced115.Position
						return
					end
					if arg.LastPosition then
						local slicedn35 = sliced115.Position - arg.LastPosition
						local vector = Vector3.new(slicedn35.X, 0, slicedn35.Z)
						if arg.MaxFrameDisplacement < vector.Magnitude then
							local slicedn36 = arg.LastPosition + vector.Unit * arg.MaxFrameDisplacement
							sliced115.CFrame = CFrame.new(slicedn36.X, sliced115.Position.Y, slicedn36.Z) * (sliced115.CFrame - sliced115.Position)
							sliced115.AssemblyLinearVelocity = Vector3.zero  -- LEAKED BY SLICED | discord.gg/pubmethod
							sliced115.AssemblyAngularVelocity = Vector3.zero
						end
					end
					arg.LastPosition = sliced115.Position
					if arg.KnockbackThreshold < sliced115.AssemblyLinearVelocity.Magnitude then
						sliced115.AssemblyLinearVelocity = Vector3.zero
						sliced115.AssemblyAngularVelocity = Vector3.zero
						slicedfn68(sliced113, sliced114, sliced115, sliced116)
					else  -- LEAKED BY SLICED | discord.gg/pubmethod
						slicedfn65(sliced115)
					end
				end))
				table.insert(arg.Connections, sliced110.StateChanged:Connect(function(old, new)
					if not arg.Enabled then
						return
					end
					if ({
						[Enum.HumanoidStateType.Ragdoll] = true,
						[Enum.HumanoidStateType.Physics] = true,  -- LEAKED BY SLICED | discord.gg/pubmethod
						[Enum.HumanoidStateType.FallingDown] = true,
						[Enum.HumanoidStateType.PlatformStanding] = true,
					})[new] then
						sliced110.PlatformStand = false
						sliced110.Sit = false
						sliced110:ChangeState(Enum.HumanoidStateType.GettingUp)
						sliced110:ChangeState(Enum.HumanoidStateType.Running)
						local sliced113, sliced114, sliced115, sliced116 = slicedfn56()
						if sliced113 then  -- LEAKED BY SLICED | discord.gg/pubmethod
							slicedfn68(sliced113, sliced114, sliced115, sliced116)
							slicedfn66(sliced113, sliced114, sliced115, true)
						end
					end
				end))
				table.insert(arg.Connections, sliced109.DescendantAdded:Connect(function(descendant)
					if not arg.Enabled then
						return
					end
					if descendant:IsA("Motor6D") then  -- LEAKED BY SLICED | discord.gg/pubmethod
						descendant.Enabled = true
						return
					end
					if descendant:IsA("BasePart") then
						task.wait()
						local sliced113, sliced114, sliced115 = slicedfn56()
						if sliced113 and sliced115 and descendant ~= sliced115 and descendant.Parent then
							local weldConstraint = Instance.new("WeldConstraint")
							weldConstraint.Name = "AntiRagdollWeld"  -- LEAKED BY SLICED | discord.gg/pubmethod
							weldConstraint.Part0 = sliced115
							weldConstraint.Part1 = descendant
							weldConstraint.Parent = sliced115
							table.insert(tbl22.Welds, weldConstraint)
						end
						return
					end
					if descendant:IsA("BallSocketConstraint") or descendant:IsA("HingeConstraint") or descendant:IsA("RopeConstraint") or descendant:IsA("RodConstraint") then
						task.wait()
						pcall(function()  -- LEAKED BY SLICED | discord.gg/pubmethod
							descendant:Destroy()
						end)
						return
					end
					if slicedfn54(descendant) then
						local sliced113, sliced114, sliced115 = slicedfn56()
						local name = descendant.Parent and descendant.Parent.Name or ""
						local flag23 = descendant.Parent == sliced115
						local sliced116 = slicedfn55(descendant.Name) or slicedfn55(name)  -- LEAKED BY SLICED | discord.gg/pubmethod
						if flag23 or sliced116 then
							task.wait()
							pcall(function()
								descendant:Destroy()
							end)
						end
					end
				end))
				table.insert(arg.Connections, sliced109.DescendantRemoving:Connect(function(descendant)  -- LEAKED BY SLICED | discord.gg/pubmethod
					if not arg.Enabled then
						return
					end
					if descendant:IsA("Motor6D") then
						task.defer(function()
							local character = sliced89.Character
							if character then
								slicedfn62(character)
							end
						end)  -- LEAKED BY SLICED | discord.gg/pubmethod
					end
				end))
				table.insert(arg.Connections, sliced89.CharacterAdded:Connect(function()
					task.wait(1)
					if arg.Enabled then
						arg:Disable()
						arg:Enable()
					end
				end))  -- LEAKED BY SLICED | discord.gg/pubmethod
			end
		end
	end
end
local slicedfn54
do
	do
		local AntiRagdoll
		do
			do  -- LEAKED BY SLICED | discord.gg/pubmethod
				do
					local function slicedfn55()
						local ragCountdownBillboard = sliced90:FindFirstChild("RagCountdownBillboard")
						if ragCountdownBillboard then
							ragCountdownBillboard:Destroy()
						end
					end
					slicedfn55()
					tbl22.Disable = function(arg)  -- LEAKED BY SLICED | discord.gg/pubmethod
						arg.Enabled = false
						arg.ResetCooldown = 0
						slicedfn55()
						if arg.V2Connection then
							arg.V2Connection:Disconnect()
							arg.V2Connection = nil
						end
					end
				end  -- LEAKED BY SLICED | discord.gg/pubmethod
			end
			tbl22.Enable = function(arg)
				if arg.V2Connection then
					return
				end
				arg.Enabled = true
				arg.ResetCooldown = 0
				arg.V2Connection = sliced88.Heartbeat:Connect(function()
					if not arg.Enabled then
						return  -- LEAKED BY SLICED | discord.gg/pubmethod
					end
					local character = sliced89.Character
					if not character then
						return
					end
					local humanoid = character:FindFirstChildOfClass("Humanoid")
					local humanoidRootPart = character:FindFirstChild("HumanoidRootPart")
					if not humanoid or not humanoidRootPart or humanoid.Health <= 0 then
						return
					end  -- LEAKED BY SLICED | discord.gg/pubmethod
					local state = humanoid:GetState()
					local now2 = tick()
					if state == Enum.HumanoidStateType.Physics or state == Enum.HumanoidStateType.Ragdoll or state == Enum.HumanoidStateType.FallingDown then
						if now2 - arg.ResetCooldown > 0.15 then
							arg.ResetCooldown = now2
							pcall(function()
								humanoid:ChangeState(Enum.HumanoidStateType.GettingUp)
								humanoidRootPart.Velocity = Vector3.zero
								humanoidRootPart.RotVelocity = Vector3.zero
								humanoidRootPart.AssemblyLinearVelocity = Vector3.zero  -- LEAKED BY SLICED | discord.gg/pubmethod
								humanoidRootPart.AssemblyAngularVelocity = Vector3.zero
								for _, descendant in ipairs(character:GetDescendants()) do
									if descendant:IsA("Motor6D") then
										descendant.Enabled = true
									end
									if descendant:IsA("Weld") then
										descendant.Enabled = true
									end
								end  -- LEAKED BY SLICED | discord.gg/pubmethod
								workspace.CurrentCamera.CameraSubject = humanoid
								local playerModule = sliced89.PlayerScripts:FindFirstChild("PlayerModule")
								playerModule = playerModule and playerModule:FindFirstChild("ControlModule")
								if playerModule then
									local module = require(playerModule)
									if module and module.Enable then
										module:Enable()
									end
								end
								humanoid.AutoRotate = true  -- LEAKED BY SLICED | discord.gg/pubmethod
								humanoid.PlatformStand = false
								humanoid.Sit = false
							end)
						end
					end
				end)
			end
			_G.__AntiRagdollToggleCleanup = function()
				pcall(function()  -- LEAKED BY SLICED | discord.gg/pubmethod
					tbl22:Disable()
				end)
			end
			do
				local sliced109
				AntiRagdoll, sliced109 = slicedfn47("AntiRagdoll", 260, 180, "ANTI RAGDOLL")
				AntiRagdoll.Visible = false
				AntiRagdoll.Parent = ScreenGui
				local sliced110 = slicedfn48("X", sliced109)
				sliced110.Size = UDim2.fromOffset(22, 22)  -- LEAKED BY SLICED | discord.gg/pubmethod
				sliced110.Position = UDim2.new(1, -28, 0.5, -11)
				sliced110.TextSize = 12
				sliced110.MouseButton1Click:Connect(function()
					AntiRagdoll.Visible = false
				end)
			end
		end
		local Frame5, Frame6, sliced109
		do
			Frame5 = slicedfn42("Frame", {  -- LEAKED BY SLICED | discord.gg/pubmethod
				Size = UDim2.new(1, -24, 1, -58),
				Position = UDim2.fromOffset(12, 50),
				BackgroundTransparency = 1,
				}, AntiRagdoll)
			slicedfn42("UIListLayout", {
				Padding = UDim.new(0, 8),
				SortOrder = Enum.SortOrder.LayoutOrder,
				}, Frame5)
			do
				local Frame7 = slicedfn42("Frame", {  -- LEAKED BY SLICED | discord.gg/pubmethod
					Size = UDim2.new(1, 0, 0, 38),
					BackgroundColor3 = tbl21.panel,
					BorderSizePixel = 0,
					LayoutOrder = 1,
					}, Frame5)
				slicedfn43(Frame7, 9)
				slicedfn44(Frame7, tbl21.line, 1, 0.3)
				Frame6 = slicedfn42("Frame", {
					Size = UDim2.fromOffset(8, 8),
					Position = UDim2.new(0, 12, 0.5, -4),  -- LEAKED BY SLICED | discord.gg/pubmethod
					BackgroundColor3 = tbl21.err,
					BorderSizePixel = 0,
					}, Frame7)
				slicedfn43(Frame6, 4)
				sliced109 = slicedfn46("disabled", 12, tbl21.txt, gothamBold, Enum.TextXAlignment.Left, Frame7)
			end
		end
		local enable
		do  -- LEAKED BY SLICED | discord.gg/pubmethod
			sliced109.Size = UDim2.new(1, -32, 1, 0)
			sliced109.Position = UDim2.fromOffset(28, 0)
			enable = slicedfn49("ENABLE", Frame5)
			enable.Size = UDim2.new(1, 0, 0, 36)
			enable.LayoutOrder = 2
			enable.TextColor3 = Color3.fromRGB(0, 0, 0)
			do
				local sliced110 = slicedfn46("rigidifies your character and strips ragdoll forces / states", 10, tbl21.sub, gothamMedium, Enum.TextXAlignment.Left, Frame5)
				sliced110.Size = UDim2.new(1, 0, 0, 30)
				sliced110.LayoutOrder = 3  -- LEAKED BY SLICED | discord.gg/pubmethod
				sliced110.TextWrapped = true
			end
		end
		do
			local function slicedfn55()
				local enabled = tbl22.Enabled
				sliced109.Text = enabled and "enabled - staying upright" or "disabled"
				sliced109.TextColor3 = enabled and tbl21.ok or tbl21.sub
				Frame6.BackgroundColor3 = enabled and tbl21.ok or tbl21.err
				enable.Text = enabled and "DISABLE" or "ENABLE"  -- LEAKED BY SLICED | discord.gg/pubmethod
				Rag.TextColor3 = enabled and tbl21.acc or tbl21.txt
			end
			enable.MouseButton1Click:Connect(function()
				if tbl22.Enabled then
					tbl22:Disable()
				else
					tbl22:Enable()
				end
				slicedfn55()  -- LEAKED BY SLICED | discord.gg/pubmethod
			end)
			Rag.MouseButton1Click:Connect(function()
				if AntiRagdoll.Visible then
					AntiRagdoll.Visible = false
					return
				end
				if flag18 then
					AntiRagdoll.Position = UDim2.new(0.5, -math.floor(AntiRagdoll.AbsoluteSize.X / 2), 0.5, -math.floor(AntiRagdoll.AbsoluteSize.Y / 2))
				else  -- LEAKED BY SLICED | discord.gg/pubmethod
					local position = Main.Position
					AntiRagdoll.Position = UDim2.new(position.X.Scale, position.X.Offset - AntiRagdoll.AbsoluteSize.X - 10, position.Y.Scale, position.Y.Offset + 96)
				end
				AntiRagdoll.Visible = true
			end)
			sliced89.CharacterAdded:Connect(function()
				task.wait(1)
				slicedfn55()
			end)
			slicedfn55()  -- LEAKED BY SLICED | discord.gg/pubmethod
		end
	end
	do
		local function slicedfn55()
			local tbl23 = { Enabled = false }
			local tbl24 = {}
			local tbl25 = { animals = nil, game = nil, mutations = nil, traits = nil, tried = false }
			local function slicedfn56(arg, arg2)
				local getupvalue_ = debug and debug.getupvalue or getupvalue  -- LEAKED BY SLICED | discord.gg/pubmethod
				local sliced109, sliced110 = getupvalue_(arg, arg2)
				return sliced110 ~= nil and sliced110 or sliced109
			end
			local function slicedfn57(arg, arg2)
				for _, sliced109 in pairs(arg) do
					if type(sliced109) == "table" and tonumber(rawget(sliced109, arg2)) ~= nil then
						return true
					end
				end
				return false  -- LEAKED BY SLICED | discord.gg/pubmethod
			end
			local function slicedfn58()
				if tbl25.tried then
					return
				end
				tbl25.tried = true
				local ok, result = pcall(require, sliced85:FindFirstChild("Shared") and sliced85.Shared:FindFirstChild("Animals"))
				if ok then
					local sliced109 = "table"  -- LEAKED BY SLICED | discord.gg/pubmethod
					ok = type(result) == sliced109
				end
				local value = ok and rawget(result, "GetGeneration") or nil
				if type(value) ~= "function" then
					return
				end
				for i = 1, 20 do
					local ok2, game_ = pcall(slicedfn56, value, i)
					if ok2 and type(game_) == "table" then  -- LEAKED BY SLICED | discord.gg/pubmethod
						local value2 = rawget(game_, "Game")
						if not tbl25.game and type(value2) == "table" and tonumber(rawget(value2, "AnimalGanerationModifier")) then
							tbl25.game = game_
						elseif not tbl25.traits and slicedfn57(game_, "MultiplierModifier") then
							tbl25.traits = game_
						elseif not tbl25.mutations and slicedfn57(game_, "Modifier") then
							tbl25.mutations = game_
						elseif not tbl25.animals and (slicedfn57(game_, "Generation") or slicedfn57(game_, "Price")) then
							tbl25.animals = game_
						end  -- LEAKED BY SLICED | discord.gg/pubmethod
					end
				end
			end
			local function slicedfn59(arg, arg2, arg3)
				local value = tbl25.animals and rawget(tbl25.animals, arg)
				if type(value) ~= "table" then
					return nil, nil
				end
				local num = tonumber(rawget(value, "Generation"))  -- LEAKED BY SLICED | discord.gg/pubmethod
				if not num then
					local game_ = tbl25.game
					if game_ then
						game_ = tonumber(rawget(rawget(tbl25.game, "Game") or {}, "AnimalGanerationModifier"))
					end
					game_ = game_ or 0
					num = (tonumber(rawget(value, "Price")) or 0) * game_
				end
				local mutations = arg2 and tbl25.mutations
				local slicedn35 = 1  -- LEAKED BY SLICED | discord.gg/pubmethod
				if mutations then
					local value2 = rawget(tbl25.mutations, arg2)
					if type(value2) == "table" then
						slicedn35 = 1 + (tonumber(rawget(value2, "Modifier")) or 0)
					end
				end
				local traits = type(arg3) == "table" and tbl25.traits
				local flag23 = false
				if traits then  -- LEAKED BY SLICED | discord.gg/pubmethod
					for _, sliced109 in ipairs(arg3) do
						if sliced109 == "Sleepy" then
							flag23 = true
						else
							local value2 = rawget(tbl25.traits, sliced109)
							if type(value2) == "table" then
								slicedn35 += tonumber(rawget(value2, "MultiplierModifier")) or 0
							end
						end  -- LEAKED BY SLICED | discord.gg/pubmethod
					end
				end
				local slicedn36 = num * slicedn35
				local slicedn37
				if flag23 then
					slicedn37 = slicedn36 * 0.5
				else
					slicedn37 = slicedn36
				end
				return math.round(slicedn37), value  -- LEAKED BY SLICED | discord.gg/pubmethod
			end
			local tbl26 = {}
			local function slicedfn60(child)
				if child:IsA("Model") and child:GetAttribute("Index") ~= nil then
					tbl26[child] = true
				end
			end
			local tbl27 = {}
			local slicedfn61 = nil  -- LEAKED BY SLICED | discord.gg/pubmethod
			local slicedfn62 = nil
			local function slicedfn63()
				for _, sliced109 in ipairs(tbl27) do
					pcall(function()
						sliced109:Disconnect()
					end)
				end
				tbl27 = {}
				tbl26 = {}  -- LEAKED BY SLICED | discord.gg/pubmethod
				if slicedfn62 then
					pcall(slicedfn62)
				end
			end
			local function slicedfn64()
				if #tbl27 > 0 then
					return
				end
				slicedfn58()
				for _, child in ipairs(workspace:GetChildren()) do  -- LEAKED BY SLICED | discord.gg/pubmethod
					slicedfn60(child)
				end
				tbl27[#tbl27 + 1] = workspace.ChildAdded:Connect(slicedfn60)
				tbl27[#tbl27 + 1] = workspace.ChildRemoved:Connect(function(child)
					tbl26[child] = nil
				end)
				tbl27[#tbl27 + 1] = sliced88.Heartbeat:Connect(function(deltaTime)
					if slicedfn61 then
						slicedfn61(deltaTime)
					end  -- LEAKED BY SLICED | discord.gg/pubmethod
				end)
			end
			local function slicedfn65(arg)
				local primaryPart = arg.PrimaryPart or arg:FindFirstChildWhichIsA("BasePart")
				if not primaryPart then
					return nil
				end
				local sliced109 = primaryPart:FindFirstChildOfClass("Attachment")
				sliced109 = sliced109 and sliced109:FindFirstChildOfClass("ProximityPrompt")  -- LEAKED BY SLICED | discord.gg/pubmethod
				if sliced109 and sliced109.Enabled and sliced109.ActionText == "Purchase" then
					return sliced109, primaryPart
				end
				return nil
			end
			local function slicedfn66()
				local character = localPlayer.Character
				character = character and character:FindFirstChild("HumanoidRootPart")
				if not character then
					return nil, nil, math.huge  -- LEAKED BY SLICED | discord.gg/pubmethod
				end
				local huge = math.huge
				local sliced109 = nil
				local sliced110 = nil
				for k in pairs(tbl26) do
					if k.Parent == workspace then
						local sliced111, sliced112 = slicedfn65(k)
						if sliced111 then
							local magnitude = (character.Position - sliced112.Position).Magnitude  -- LEAKED BY SLICED | discord.gg/pubmethod
							if magnitude < huge then
								huge = magnitude
								sliced109 = k
								sliced110 = sliced111
							end
						end
					else
						tbl26[k] = nil
					end
				end  -- LEAKED BY SLICED | discord.gg/pubmethod
				return sliced109, sliced110, huge
			end
			local function slicedfn67(arg)
				local num = tonumber(arg)
				if not num then
					return tostring(arg or "---")
				end
				local slicedn35 = math.abs(num)
				for _, sliced109 in ipairs({ { 1000000000000, "T" }, { 1000000000, "B" }, { 1000000, "M" }, { 1000, "K" } }) do  -- LEAKED BY SLICED | discord.gg/pubmethod
					if sliced109[1] <= slicedn35 then
						local slicedn36 = num / sliced109[1]
						return string.format(slicedn36 >= 100 and "%.0f%s" or "%.1f%s", slicedn36, sliced109[2])
					end
				end
				if num % 1 == 0 then
					return tostring(math.floor(num))
				end
				return string.format("%.1f", num)
			end  -- LEAKED BY SLICED | discord.gg/pubmethod
			local function slicedfn68(arg)
				if not arg or not arg.Parent or not arg.Enabled then
					return false, "prompt gone"
				end
				local sliced109 = "function"
				if type(fireproximityprompt) == sliced109 then
					local ok = pcall(fireproximityprompt, arg)
					return ok, ok and nil or "fire failed"
				end  -- LEAKED BY SLICED | discord.gg/pubmethod
				local ok = pcall(function()
					arg:InputHoldBegin()
					local sliced110 = 0.05
					task.wait(math.max(arg.HoldDuration, 0.05) + sliced110)
					arg:InputHoldEnd()
				end)
				return ok, ok and nil or "hold failed"
			end
			local AutoBuy, sliced109 = slicedfn47("AutoBuy", 300, 306, "AUTO BUY")  -- LEAKED BY SLICED | discord.gg/pubmethod
			AutoBuy.Visible = false
			AutoBuy.Parent = ScreenGui
			local sliced110 = slicedfn48("X", sliced109)
			sliced110.Size = UDim2.fromOffset(22, 22)
			sliced110.Position = UDim2.new(1, -28, 0.5, -11)
			sliced110.TextSize = 12
			sliced110.MouseButton1Click:Connect(function()
				AutoBuy.Visible = false
				if sliced108 then
					sliced108()  -- LEAKED BY SLICED | discord.gg/pubmethod
				end
			end)
			local Frame5 = slicedfn42("Frame", {
				Size = UDim2.new(1, -24, 1, -58),
				Position = UDim2.fromOffset(12, 50),
				BackgroundTransparency = 1,
				}, AutoBuy)
			slicedfn42("UIListLayout", { Padding = UDim.new(0, 6), SortOrder = Enum.SortOrder.LayoutOrder }, Frame5)
			local Frame6 = slicedfn42("Frame", {  -- LEAKED BY SLICED | discord.gg/pubmethod
				Size = UDim2.new(1, 0, 0, 32),
				BackgroundColor3 = tbl21.panel,
				BorderSizePixel = 0,
				LayoutOrder = 1,
				}, Frame5)
			slicedfn43(Frame6, 9)
			slicedfn44(Frame6, tbl21.line, 1, 0.3)
			local Frame7 = slicedfn42("Frame", {
				Size = UDim2.fromOffset(8, 8),  -- LEAKED BY SLICED | discord.gg/pubmethod
				Position = UDim2.new(0, 12, 0.5, -4),
				BackgroundColor3 = tbl21.line,
				BorderSizePixel = 0,
				}, Frame6)
			slicedfn43(Frame7, 4)
			local sliced111 = slicedfn46("idle", 12, tbl21.sub, gothamBold, Enum.TextXAlignment.Left, Frame6)
			sliced111.Size = UDim2.new(1, -32, 1, 0)
			sliced111.Position = UDim2.fromOffset(28, 0)
			sliced111.TextTruncate = Enum.TextTruncate.AtEnd
			local function slicedfn69(text, arg)  -- LEAKED BY SLICED | discord.gg/pubmethod
				sliced111.Text = text
				local ok = arg == "ok" and tbl21.ok or arg == "err" and tbl21.err or arg == "busy" and tbl21.acc or arg == "wait" and tbl21.warn or tbl21.sub
				sliced111.TextColor3 = ok
				Frame7.BackgroundColor3 = ok
			end
			slicedfn51(Frame5, 2, "AUTO BUY", false, function(enabled)
				tbl23.Enabled = enabled
				if enabled then
					slicedfn64()  -- LEAKED BY SLICED | discord.gg/pubmethod
				else
					slicedfn63()
				end
				if not enabled then
					slicedfn69("idle", nil)
				else
					slicedfn69("armed - looking for a buy...", "wait")
				end
			end)
			local nearestBuyable = slicedfn46("NEAREST BUYABLE", 9, tbl21.acc, gothamBlack, Enum.TextXAlignment.Left, Frame5)  -- LEAKED BY SLICED | discord.gg/pubmethod
			nearestBuyable.Size = UDim2.new(1, 0, 0, 14)
			nearestBuyable.LayoutOrder = 3
			local function slicedfn70(layoutOrder, arg, arg2, arg3)
				local sliced112 = slicedfn46(arg, 11, arg2 or tbl21.sub, gothamBold, Enum.TextXAlignment.Left, Frame5)
				sliced112.Size = UDim2.new(1, 0, 0, arg3 or 16)
				sliced112.LayoutOrder = layoutOrder
				sliced112.TextTruncate = Enum.TextTruncate.AtEnd
				return sliced112
			end  -- LEAKED BY SLICED | discord.gg/pubmethod
			local sliced112 = slicedfn70(4, "Name: ---", tbl21.txt)
			local sliced113 = slicedfn70(5, "Income: --- /sec", tbl21.acc)
			local sliced114 = slicedfn70(6, "Rarity: ---")
			local sliced115 = slicedfn70(7, "Mutation: ---")
			local sliced116 = slicedfn70(8, "Traits: ---", tbl21.sub, 30)
			sliced116.TextWrapped = true
			sliced116.TextYAlignment = Enum.TextYAlignment.Top
			local sliced117 = slicedfn70(9, "Distance: ---", tbl21.sub, 14)
			sliced117.TextSize = 9
			slicedfn62 = function()  -- LEAKED BY SLICED | discord.gg/pubmethod
				sliced112.Text = "Name: ---"
				sliced113.Text = "Income: --- /sec"
				sliced114.Text = "Rarity: ---"
				sliced115.Text = "Mutation: ---"
				sliced116.Text = "Traits: ---"
				sliced117.Text = "Distance: ---"
			end
			local function slicedfn71(arg, arg2, arg3)
				if not (arg and arg2) then  -- LEAKED BY SLICED | discord.gg/pubmethod
					slicedfn62()
					return
				end
				local attribute = arg:GetAttribute("Index")
				local attribute2 = arg:GetAttribute("Mutation")
				local attribute3 = arg:GetAttribute("Traits")
				local sliced118 = "string"
				local tbl28
				if type(attribute3) == sliced118 and attribute3 ~= "" then
					tbl28 = { attribute3 }  -- LEAKED BY SLICED | discord.gg/pubmethod
				else
					tbl28 = attribute3
				end
				local sliced119, sliced120 = slicedfn59(attribute, attribute2, tbl28)
				local value = sliced120 and rawget(sliced120, "Price")
				sliced112.Text = "Name: " .. tostring(sliced120 and rawget(sliced120, "DisplayName") or attribute or arg2.ObjectText or "---") .. (value and " ($" .. slicedfn67(value) .. ")" or "")
				sliced113.Text = "Income: " .. slicedfn67(sliced119) .. " /sec"
				sliced114.Text = "Rarity: " .. tostring(sliced120 and rawget(sliced120, "Rarity") or "---")
				sliced115.Text = "Mutation: " .. tostring(attribute2 or "---")  -- LEAKED BY SLICED | discord.gg/pubmethod
				sliced116.Text = "Traits: " .. (type(tbl28) == "table" and #tbl28 > 0 and table.concat(tbl28, ", ") or "---")
				sliced117.Text = string.format("Distance: %.1f studs", arg3)
			end
			local sliced118 = nil
			local sliced119 = 0
			local sliced120 = 0
			local flag23 = false
			slicedfn61 = function(arg)
				if not tbl23.Enabled then
					if flag23 then  -- LEAKED BY SLICED | discord.gg/pubmethod
						slicedfn62()
						flag23 = false
					end
					return
				end
				sliced120 += arg
				if sliced120 < 0.2 then
					return
				end  -- LEAKED BY SLICED | discord.gg/pubmethod
				sliced120 = 0
				local sliced121, sliced122, sliced123 = slicedfn66()
				slicedfn71(sliced121, sliced122, sliced123)
				flag23 = sliced122 ~= nil
				if sliced122 then
					if sliced123 > (sliced122.MaxActivationDistance or 10) + 2 then
						slicedfn69("move closer to buy", "wait")
						return
					end
					if sliced122 ~= sliced118 or os.clock() - sliced119 >= 1.2 then  -- LEAKED BY SLICED | discord.gg/pubmethod
						local now2 = os.clock()
						sliced118 = sliced122
						sliced119 = now2
						slicedfn69("buying...", "busy")
						task.spawn(function()
							local sliced124, sliced125 = slicedfn68(sliced122)
							if sliced124 then
								slicedfn69("bought!", "ok")
							elseif tbl23.Enabled then
								slicedfn69(sliced125 or "buy failed", "err")  -- LEAKED BY SLICED | discord.gg/pubmethod
							end
						end)
					end
					return
				end
				slicedfn69("no buy prompt in range", "wait")
			end
			slicedfn31 = function()
				if flag18 then
					local sliced121 = 0.5  -- LEAKED BY SLICED | discord.gg/pubmethod
					AutoBuy.Position = UDim2.new(0.5, -math.floor(AutoBuy.AbsoluteSize.X / 2), sliced121, -math.floor(AutoBuy.AbsoluteSize.Y / 2))
				else
					local position = Main.Position
					AutoBuy.Position = UDim2.new(position.X.Scale, position.X.Offset - AutoBuy.AbsoluteSize.X - 10, position.Y.Scale, position.Y.Offset)
				end
				AutoBuy.Visible = true
			end
			slicedfn32 = function()
				tbl23.Enabled = false  -- LEAKED BY SLICED | discord.gg/pubmethod
				slicedfn63()
				for _, sliced121 in ipairs(tbl24) do
					pcall(function()
						sliced121:Disconnect()
					end)
				end
				tbl24 = {}
			end
		end
		slicedfn55()  -- LEAKED BY SLICED | discord.gg/pubmethod
	end
	do
		local str8, slicedn35
		do
			str8 = ""
			slicedn35 = 0
			do
				local function slicedfn55(descendant)
					task.defer(function()  -- LEAKED BY SLICED | discord.gg/pubmethod
						if not descendant.Parent then
							return
						end
						local descendants = descendant:IsA("TextLabel") and { descendant } or descendant:GetDescendants()
						for _, descendant2 in ipairs(descendants) do
							if descendant2:IsA("TextLabel") and descendant2.Text ~= "" then
								local str9 = slicedfn33(descendant2.Text):lower()
								local now2 = os.clock()
								str8 = str9
								slicedn35 = now2  -- LEAKED BY SLICED | discord.gg/pubmethod
								return
							end
						end
					end)
				end
				local function slicedfn56(arg)
					if not arg then
						return
					end  -- LEAKED BY SLICED | discord.gg/pubmethod
					arg.DescendantAdded:Connect(slicedfn55)
					for _, descendant in ipairs(arg:GetDescendants()) do
						if descendant:IsA("TextLabel") then
							descendant:GetPropertyChangedSignal("Text"):Connect(function()
								if descendant.Text ~= "" then
									local str9 = slicedfn33(descendant.Text):lower()
									local now2 = os.clock()
									str8 = str9
									slicedn35 = now2
								end  -- LEAKED BY SLICED | discord.gg/pubmethod
							end)
						end
					end
				end
				slicedfn56(sliced87:FindFirstChild("Notification"))
				slicedfn56(sliced87:FindFirstChild("Notifications"))
				slicedfn56(sliced87:FindFirstChild("Announcement"))
			end
		end  -- LEAKED BY SLICED | discord.gg/pubmethod
		do
			local tbl23 = {
				"base is full",
				"sold out",
				"out of stock",
				"already redeemed",
				"already used",
				"code redeemed",
				"you have already",
			}  -- LEAKED BY SLICED | discord.gg/pubmethod
			slicedfn54 = function(arg)
				if slicedn35 <= (arg or 0) then
					return nil
				end
				if os.clock() - slicedn35 > 3 then
					return nil
				end
				for _, sliced109 in ipairs(tbl23) do
					if str8:find(sliced109, 1, true) then  -- LEAKED BY SLICED | discord.gg/pubmethod
						return sliced109
					end
				end
			end
		end
	end
end
local slicedfn55, slicedfn56, slicedfn57, slicedfn58, slicedfn59, slicedfn60, slicedfn61, slicedfn62, slicedfn63, slicedfn64
do  -- LEAKED BY SLICED | discord.gg/pubmethod
	do
		slicedfn55 = function(arg, arg2)
			local sliced109 = slicedfn34(arg)
			if sliced109 == "" then
				slicedfn50("nothing to redeem", "err")
				return false, false
			end
			arg2 = arg2 and arg2 .. " " or ""
			slicedfn50(("%sredeeming: %s"):format(arg2, sliced109), "busy")
			local sliced110, sliced111 = slicedfn41(sliced109)  -- LEAKED BY SLICED | discord.gg/pubmethod
			local flag23 = sliced110 and type(sliced111) == "table"
			if flag23 and (sliced111.success or sliced111.Success) and true then
				slicedfn50(("%sredeemed: %s"):format(arg2, sliced109), "ok")
			elseif flag23 then
				slicedfn50(("%srejected: %s"):format(arg2, sliced109), "err")
			elseif sliced110 then
				slicedfn50(("%ssent: %s"):format(arg2, sliced109), "busy")
			else
				slicedfn50(("%sfailed to send: %s"):format(arg2, sliced109), "err")  -- LEAKED BY SLICED | discord.gg/pubmethod
			end
			return sliced110, flag23
		end
		slicedfn52 = function(text)
			TextBox.Text = text
			slicedfn55(text)
		end
		do
			local slicedfn65 = nil
			local function slicedfn66(arg)  -- LEAKED BY SLICED | discord.gg/pubmethod
				local sliced109 = slicedfn34(arg or "")
				if sliced109 == "" then
					return false
				end
				slicedn32 += 1
				local sliced110, sliced111 = slicedfn55(sliced109)
				if sliced110 and sliced111 then
					local sliced112 = "ok"
					slicedfn50(("spam %d - redeemed: %s"):format(slicedn32, sliced109), sliced112)  -- LEAKED BY SLICED | discord.gg/pubmethod
				elseif sliced110 then
					slicedfn50(("spam %d - sent: %s"):format(slicedn32, sliced109), "busy")
				else
					slicedfn50(("spam %d - failed: %s"):format(slicedn32, sliced109), "err")
				end
				return sliced110
			end
			slicedfn56 = function(arg)
				if flag21 and flag20 and flag19 then
					slicedfn66(arg)  -- LEAKED BY SLICED | discord.gg/pubmethod
				end
			end
			local function slicedfn67()
				while flag21 and flag20 do
					if flag19 then
						if slicedn32 == 0 then
							slicedfn50("spam - redeem on every word", "wait")
						end
						task.wait(0.1)  -- LEAKED BY SLICED | discord.gg/pubmethod
					else
						if slicedfn34(TextBox.Text) == "" then
							slicedfn50("spam - waiting for a code...", "wait")
						else
							slicedfn66(TextBox.Text)
						end
						task.wait(max)
					end
				end  -- LEAKED BY SLICED | discord.gg/pubmethod
				if flag21 then
					slicedfn65(false)
				end
			end
			slicedfn65 = function(arg)
				if arg and not flag20 then
					slicedfn50("turn LISTEN on first", "err")
					return
				end
				if arg == flag21 then  -- LEAKED BY SLICED | discord.gg/pubmethod
					return
				end
				flag21 = arg
				start.Text = arg and "STOP" or "START"
				start.TextColor3 = arg and tbl21.acc or tbl21.txt
				slicedfn45(sliced107, 0.16, { BackgroundColor3 = arg and tbl21.acc or tbl21.line })
				slicedfn45(sliced106, 0.16, { TextColor3 = arg and tbl21.txt or tbl21.sub })
				slicedfn45(sliced105, 0.16, { Color = arg and tbl21.acc or tbl21.line, Transparency = arg and 0.15 or 0.3 })
				if arg then  -- LEAKED BY SLICED | discord.gg/pubmethod
					slicedn32 = 0
					thread = task.spawn(slicedfn67)
				else
					thread = nil
					if flag20 then
						slicedfn50("spam stopped", "wait")
					end
				end
			end
			start.MouseButton1Click:Connect(function()  -- LEAKED BY SLICED | discord.gg/pubmethod
				slicedfn65(not flag21)
			end)
			redeem.MouseButton1Click:Connect(function()
				redeem.Text = "..."
				slicedfn55(TextBox.Text)
				redeem.Text = "REDEEM"
			end)
			TextBox.FocusLost:Connect(function(enterPressed)
				if enterPressed then  -- LEAKED BY SLICED | discord.gg/pubmethod
					slicedfn55(TextBox.Text)
				end
			end)
			sliced100.MouseButton1Click:Connect(function()
				local copied = slicedfn34(TextBox.Text)
				if copied == "" then
					slicedfn50("nothing to copy", "err")
					return
				end
				local sliced109 = slicedfn35(copied)  -- LEAKED BY SLICED | discord.gg/pubmethod
				slicedfn50(sliced109 and "copied: " .. copied or "copy failed", sliced109 and "ok" or "err")
			end)
			clear.MouseButton1Click:Connect(function()
				TextBox.Text = ""
				sliced93 = nil
				tbl19 = {}
				slicedfn50(flag20 and "listening... (cleared)" or "cleared", flag20 and "wait" or "idle")
			end)
			slicedfn57 = function(text)
				sliced93 = text  -- LEAKED BY SLICED | discord.gg/pubmethod
				TextBox.Text = text
			end
			slicedfn58 = function()
				if not (not keyboardEnabled or not listenKey) then
					return "press " .. listenKey.Name .. " to fire"
				end
				return "tap LISTEN to fire"
			end
			slicedfn59 = function()  -- LEAKED BY SLICED | discord.gg/pubmethod
				if not keyboardEnabled then
					return "idle - tap LISTEN to start"
				end
				return listenKey and "idle - press " .. listenKey.Name .. " to listen" or "idle - no listen key bound"
			end
			slicedfn60 = function(arg)
				flag20 = arg
				if not arg and flag21 then
					slicedfn65(false)
				end  -- LEAKED BY SLICED | discord.gg/pubmethod
				slicedfn45(Frame2, 0.16, { BackgroundColor3 = arg and tbl21.acc or tbl21.line })
				slicedfn45(Frame3, 0.16, { Position = UDim2.new(0, arg and 20 or 2, 0.5, -7) }, Enum.EasingStyle.Back)
				slicedfn45(listen, 0.16, { TextColor3 = arg and tbl21.txt or tbl21.sub })
				if arg then
					tbl19 = {}
					if sliced95 and not flag21 then
						if sliced93 and TextBox.Text == sliced93 then
							slicedfn57("")
						end
						slicedfn65(true)  -- LEAKED BY SLICED | discord.gg/pubmethod
					end
					if manual then
						slicedfn50("listening... " .. slicedfn58(), "wait")
					else
						local sliced109 = "wait"
						slicedfn50(("listening... 0/%d"):format(slicedn33), sliced109)
					end
				else
					slicedfn50(slicedfn59(), "idle")  -- LEAKED BY SLICED | discord.gg/pubmethod
				end
			end
		end
	end
	do
		slicedfn61 = function(arg)
			if autoType then
				slicedfn57(arg)
			end
			if autoRedeem then  -- LEAKED BY SLICED | discord.gg/pubmethod
				slicedfn55(arg, "[FULL]")
			else
				slicedfn50("captured: " .. arg .. " (auto-redeem off)", "ok")
			end
		end
		slicedfn62 = function(arg)
			local sliced109 = slicedfn34(arg or "")
			if sliced109 == "" then
				return  -- LEAKED BY SLICED | discord.gg/pubmethod
			end
			local now2 = os.clock()
			task.spawn(function()
				for i = 1, 3 do
					task.wait(sliced92)
					local sliced110 = slicedfn54(now2)
					if sliced110 then
						local sliced111 = "wait"
						slicedfn50(("%s - stopped retrying"):format(sliced110), sliced111)
						break  -- LEAKED BY SLICED | discord.gg/pubmethod
					else
						slicedn32 += 1
						local sliced111, sliced112 = slicedfn55(sliced109, "[FULL]")
						slicedfn50(("confirm %d/%d - %s%s"):format(i, 3, sliced111 and "sent: " or "retry: ", sliced109), sliced111 and "ok" or "busy")
						if not (sliced111 and sliced112) then
							continue
						end
					end
					break  -- LEAKED BY SLICED | discord.gg/pubmethod
				end
			end)
		end
		do
			local function slicedfn65()
				local str8 = table.concat(tbl19)
				local sliced109 = flag21
				slicedfn60(false)
				if str8 ~= "" then
					slicedfn61(str8)  -- LEAKED BY SLICED | discord.gg/pubmethod
					if sliced109 then
						slicedfn62(str8)
					end
				end
			end
			slicedfn63 = function()
				if flag20 then
					if manual then
						slicedfn65()  -- LEAKED BY SLICED | discord.gg/pubmethod
					else
						slicedfn60(false)
					end
				else
					slicedfn60(true)
				end
			end
		end
	end
	TextButton.MouseButton1Click:Connect(slicedfn63)  -- LEAKED BY SLICED | discord.gg/pubmethod
	sliced101.MouseButton1Click:Connect(function()
		str7 = "listen"
		sliced101.Text = "..."
		sliced101.TextColor3 = tbl21.warn
	end)
	sliced102.MouseButton1Click:Connect(function()
		listenKey = nil
		str7 = nil
		sliced101.Text = "-"  -- LEAKED BY SLICED | discord.gg/pubmethod
		sliced101.TextColor3 = tbl21.txt
		if not flag20 then
			slicedfn50(slicedfn59(), "idle")
		end
	end)
	sliced103.MouseButton1Click:Connect(function()
		str7 = "redeem"
		sliced103.Text = "..."
		sliced103.TextColor3 = tbl21.warn
	end)  -- LEAKED BY SLICED | discord.gg/pubmethod
	sliced104.MouseButton1Click:Connect(function()
		g = nil
		str7 = nil
		sliced103.Text = "-"
		sliced103.TextColor3 = tbl21.txt
	end)
	TextBox:GetPropertyChangedSignal("Text"):Connect(function()
		if flag20 and TextBox.Text ~= sliced93 then
			tbl19 = {}
		end  -- LEAKED BY SLICED | discord.gg/pubmethod
	end)
	tbl18.positions = {
		Top = true,
		Bottom = true,
		Center = true,
		Middle = true,
		Left = true,
		Right = true,
		TopRight = true,
		TopLeft = true,  -- LEAKED BY SLICED | discord.gg/pubmethod
		BottomRight = true,
		BottomLeft = true,
	}
	do
		local function slicedfn65(arg)
			return slicedfn33(tostring(arg or "")):lower():gsub("[^%w]", "")
		end
		local tbl23 = {
			phrases = {
				"code is",  -- LEAKED BY SLICED | discord.gg/pubmethod
				"use code",
				"font color",
				"fontcolour",
				"fontcolor",
				"font colour",
				"sammy has activated bubblegum machine",
				"sammy activated 2x luck",
				"sammy activated 6x luck",
				"sammy activated 8x luck",
				"sammy activated 10x luck",  -- LEAKED BY SLICED | discord.gg/pubmethod
				"sammy activated 12x luck",
				"sammy activated 15x luck",
				"sammy activated 20x luck",
				"sammy activated 25x luck",
				"sammy activated 30x luck",
				"sammy activated 35x luck",
				"sammy activated",
				"coins shop",
				"brainrot trader",
				"robux shop",  -- LEAKED BY SLICED | discord.gg/pubmethod
				"robuxshop",
				"spin wheel",
				"spinwheel",
				"trade plaza",
				"tradeplaza",
				"event has started",
				"eventhasstarted",
				"allowfriends",
				"setcreatorid",
				"to buy this",  -- LEAKED BY SLICED | discord.gg/pubmethod
				"tobuythis",
				"your base is already locked",
				"your base is full",
				"request failed",
				"you locked your base for",
				"you got a free spin",
				"broke into your base",
				"someone is stealing",
				"trade has been completed",
				"tradehasbeencompleted",  -- LEAKED BY SLICED | discord.gg/pubmethod
				"event has been activated",
				"has been activated",
				"has activated",
				"base is already locked",
				"you locked your base",
				"you have locked your base",
				"locked your base",
				"brainrot express has arrived",
				"brainrot express has arrv",
				"brainrot express leaving in",  -- LEAKED BY SLICED | discord.gg/pubmethod
			},
			prefixes = { "sammy:", "spydersammy:" },
			compact = {},
		}
		local tbl24 = {}
		for _, phrase in ipairs(tbl23.phrases) do
			local sliced109 = slicedfn65(phrase)
			if sliced109 ~= "" and not tbl24[sliced109] then
				tbl24[sliced109] = true  -- LEAKED BY SLICED | discord.gg/pubmethod
				tbl23.compact[#tbl23.compact + 1] = { phrase = phrase, compact = sliced109 }
			end
		end
		slicedfn64 = function(arg)
			if not sliced96 or not flag20 then
				return false
			end
			local str8 = slicedfn33(tostring(arg or "")):lower()
			local str9 = str8:gsub("%s+", "")
			for _, prefixe in ipairs(tbl23.prefixes) do
				if str9:find(prefixe, 1, true) then
					return true, prefixe
				end
			end
			local sliced109 = slicedfn65(str8)
			for _, sliced110 in ipairs(tbl23.compact) do
				if sliced109:find(sliced110.compact, 1, true) then
					return true, sliced110.phrase
				end  -- LEAKED BY SLICED | discord.gg/pubmethod
			end
			return false
		end
	end
end
do
	do
		local function slicedfn65(...)
			local sliced109 = table.pack(...)  -- LEAKED BY SLICED | discord.gg/pubmethod
			if sliced109.n == 0 or typeof(sliced109[1]) ~= "string" then
				return false
			end
			if sliced96 then
				return sliced109[4] == "Top"
			end
			for i = 2, sliced109.n do
				local sliced110 = sliced109[i]
				if typeof(sliced110) == "string" and (sliced110:find("Sounds%.") or sliced110:find("rbxassetid") or tbl18.positions[sliced110]) then
					return true  -- LEAKED BY SLICED | discord.gg/pubmethod
				end
			end
			return false
		end
		slicedfn30 = function(...)
			local sliced109 = table.pack(...)
			if not slicedfn65(...) then
				return
			end  -- LEAKED BY SLICED | discord.gg/pubmethod
			local sliced110 = slicedfn33(tostring(sliced109[1] or ""))
			if sliced110 ~= "" then
				if slicedfn64(sliced110) then
					return
				end
				if _G.__RdmDuo and _G.__RiddlerDuo then
					local sliced111 = _G.__SabClassifyDrop(sliced110)
					if sliced111 == "riddle" then
						_G.__SabDropClaim = { text = sliced110, kind = "riddle", at = os.clock() }
						slicedfn50("riddle - left to the AI riddler", "wait")  -- LEAKED BY SLICED | discord.gg/pubmethod
						slicedfn53(sliced110, nil)
						return
					end
					if sliced111 == "code" then
						_G.__SabDropClaim = { text = sliced110, kind = "code", at = os.clock() }
					end
				end
				local sliced111 = slicedfn37(sliced110)
				local sliced112  -- LEAKED BY SLICED | discord.gg/pubmethod
				if autoListen and not flag20 then
					sliced112 = slicedfn38(sliced110)
					if sliced112 then
						slicedfn60(true)
						if sliced112 == "" then
							slicedfn50("trigger heard - waiting for the code...", "busy")
							slicedfn53(sliced110, sliced111)
							return
						end  -- LEAKED BY SLICED | discord.gg/pubmethod
					else
						sliced112 = sliced110
					end
				else
					sliced112 = sliced110
				end
				if flag20 then
					for _, sliced113 in ipairs(slicedfn36(sliced112)) do
						tbl19[#tbl19 + 1] = sliced113
						if flag19 and flag21 then  -- LEAKED BY SLICED | discord.gg/pubmethod
							if manual then
								slicedfn56(table.concat(tbl19))
							else
								local tbl23 = {}
								for i = 1, math.min(#tbl19, slicedn33) do
									tbl23[i] = tbl19[i]
								end
								slicedfn56(table.concat(tbl23))
							end  -- LEAKED BY SLICED | discord.gg/pubmethod
						end
					end
					if manual then
						local str8 = table.concat(tbl19)
						slicedfn57(str8)
						slicedfn40(str8)
						local sliced113 = "wait"
						slicedfn50(("listening... %d words - %s"):format(#tbl19, slicedfn58()), sliced113)
					else
						local sliced113 = slicedn33  -- LEAKED BY SLICED | discord.gg/pubmethod
						local tbl23 = {}
						for i = 1, math.min(#tbl19, sliced113) do
							tbl23[i] = tbl19[i]
						end
						local str8 = table.concat(tbl23)
						slicedfn57(str8)
						slicedfn40(str8)
						if sliced113 <= #tbl19 then
							local sliced114 = flag21  -- LEAKED BY SLICED | discord.gg/pubmethod
							tbl19 = {}
							slicedfn60(false)
							slicedfn61(str8)
							if sliced114 then
								slicedfn62(str8)
								sliced111 = str8
							else
								sliced111 = str8
							end
						else  -- LEAKED BY SLICED | discord.gg/pubmethod
							slicedfn50(("listening... %d/%d"):format(#tbl19, sliced113), "wait")
						end
					end
				end
				slicedfn53(sliced110, sliced111)
				return
			end
		end
	end  -- LEAKED BY SLICED | discord.gg/pubmethod
end
if getgenv and getgenv().StopTraced then
	pcall(getgenv().StopTraced)
end
do
	local tbl23 = {}
	local sliced109 = nil
	local slicedn35 = 0
	local function slicedfn65(...)  -- LEAKED BY SLICED | discord.gg/pubmethod
		local sliced110 = table.pack(...)
		local str8 = tostring(...)
		local now2 = os.clock()
		if str8 == sliced109 and now2 - slicedn35 < 0.25 then
			return
		end
		sliced109 = str8
		slicedn35 = now2
		pcall(slicedfn30, table.unpack(sliced110, 1, sliced110.n))
	end  -- LEAKED BY SLICED | discord.gg/pubmethod
	sliced94 = slicedfn39()
	if sliced94 then
		Frame.BackgroundColor3 = tbl21.ok
		Frame4.BackgroundColor3 = tbl21.ok
		tbl23[#tbl23 + 1] = sliced94.OnClientEvent:Connect(slicedfn65)
	else
		do
			local slicedn36 = 0
			for _, child in ipairs(net:GetChildren()) do  -- LEAKED BY SLICED | discord.gg/pubmethod
				if child:IsA("RemoteEvent") or child:IsA("UnreliableRemoteEvent") then
					slicedn36 += 1
					tbl23[#tbl23 + 1] = child.OnClientEvent:Connect(slicedfn65)
					if not (slicedn36 >= 400) then
						continue
					end
				else
					continue
				end
				break  -- LEAKED BY SLICED | discord.gg/pubmethod
			end
			tbl23[#tbl23 + 1] = net.ChildAdded:Connect(function(child)
				if child:IsA("RemoteEvent") or child:IsA("UnreliableRemoteEvent") then
					tbl23[#tbl23 + 1] = child.OnClientEvent:Connect(slicedfn65)
				end
			end)
			flag22 = slicedn36 > 0
		end
		local warn_ = flag22 and tbl21.warn or tbl21.err  -- LEAKED BY SLICED | discord.gg/pubmethod
		Frame.BackgroundColor3 = warn_
		Frame4.BackgroundColor3 = warn_
	end
	if flag18 then
		local currentCamera = workspace.CurrentCamera
		local function refit()
			sliced91 = slicedfn29()
			for _, descendant in ipairs(ScreenGui:GetDescendants()) do
				if descendant:IsA("UIScale") and descendant.Name == "WinScale" then
					descendant.Scale = sliced91  -- LEAKED BY SLICED | discord.gg/pubmethod
				end
			end
			Main.Position = UDim2.new(1, -math.floor(316 * sliced91) - 8, 0.5, -math.floor(slicedn34 * sliced91 / 2))
		end
		if currentCamera then
			currentCamera:GetPropertyChangedSignal("ViewportSize"):Connect(refit)
		end
		tbl18.refit = refit
		refit()
	end  -- LEAKED BY SLICED | discord.gg/pubmethod
	sliced86.InputBegan:Connect(function(input, gameProcessed)
		local userInputType = input.UserInputType
		if not (userInputType == Enum.UserInputType.Keyboard or userInputType == Enum.UserInputType.Gamepad1) then
			if str7 and userInputType == Enum.UserInputType.Touch then
				local rebinding = str7
				str7 = nil
				if rebinding == "listen" then
					sliced101.Text = listenKey and listenKey.Name or "-"
					sliced101.TextColor3 = tbl21.txt  -- LEAKED BY SLICED | discord.gg/pubmethod
				else
					sliced103.Text = g and g.Name or "-"
					sliced103.TextColor3 = tbl21.txt
				end
			end
			return
		end
		if str7 == "listen" then
			str7 = nil
			if input.KeyCode ~= Enum.KeyCode.Escape then  -- LEAKED BY SLICED | discord.gg/pubmethod
				listenKey = input.KeyCode
			end
			sliced101.Text = listenKey and listenKey.Name or "-"
			sliced101.TextColor3 = tbl21.txt
			if not flag20 then
				slicedfn50(slicedfn59(), "idle")
			end
			return
		end
		if str7 == "redeem" then  -- LEAKED BY SLICED | discord.gg/pubmethod
			str7 = nil
			if input.KeyCode ~= Enum.KeyCode.Escape then
				g = input.KeyCode
			end
			sliced103.Text = g and g.Name or "-"
			sliced103.TextColor3 = tbl21.txt
			return
		end
		if gameProcessed then
			return  -- LEAKED BY SLICED | discord.gg/pubmethod
		end
		if listenKey and input.KeyCode == listenKey then
			slicedfn63()
		end
		if g and input.KeyCode == g then
			slicedfn55(TextBox.Text)
		end
	end)
	if getgenv then  -- LEAKED BY SLICED | discord.gg/pubmethod
		getgenv().TracedAnnounce = function(...)
			slicedfn30(...)
		end
		getgenv().TracedStatus = function()
			return sliced99.Text
		end
		getgenv().StopTraced = function()
			flag21 = false
			flag20 = false
			pcall(function()  -- LEAKED BY SLICED | discord.gg/pubmethod
				tbl22:Disable()
			end)
			if slicedfn32 then
				pcall(slicedfn32)
			end
			for _, sliced110 in ipairs(tbl23) do
				pcall(function()
					sliced110:Disconnect()
				end)  -- LEAKED BY SLICED | discord.gg/pubmethod
			end
			tbl23 = {}
			if ScreenGui then
				ScreenGui:Destroy()
			end
		end
		getgenv().TracedUnblockEvents = function()
			if not tbl20.ready then
				return false, tbl20.why  -- LEAKED BY SLICED | discord.gg/pubmethod
			end
			return tbl20.Unblock()
		end
	end
end
slicedfn60(false)
if sliced94 or flag22 then
	slicedfn50(keyboardEnabled and (listenKey and "ready - press " .. listenKey.Name .. " to listen" or "ready - no listen key bound") or "ready - tap LISTEN to start", "idle")
else
	slicedfn50("notify remote not found", "err")  -- LEAKED BY SLICED | discord.gg/pubmethod
end