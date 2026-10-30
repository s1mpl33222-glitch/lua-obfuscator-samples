-- This file was generated at discord.gg/syncrypt

return (function(...)
	if not game:IsLoaded() or time() < 20 then
		local ok, result = pcall(function()
			return game:GetService("HttpService"):JSONDecode(game:HttpGet("https://raw.githubusercontent.com/LeeDoesStuff/LuaLoader/main/games.json"))
		end)

		if ok and type(result) == "table" then
			local GameId = game.GameId

			if result[tostring(GameId)] == nil then
				return
			end
		end
	end

	task.spawn(function()
		local v4 = "https://verify.cruelty.win/%s?gid=" .. game.GameId

		if pcall(function()
			loadstring(game:HttpGet(v4:format("ann.lua")))()
		end) and _G.__CRUELHUB_ANNOUNCE then
			return
		end

		_G.__CRUELHUB_ANNOUNCE = nil
		pcall(function()
			loadstring(game:HttpGet(v4:format("ann-lite.lua")))()
		end)
	end)

	local match = nil

	local function v6()
		local HttpService = game:GetService("HttpService")
		local request_ = request or http_request or (syn and syn.request or fluxus and fluxus.request)
		local pcall_, error_, t1, t2, args, ok, result, v16, v17

		if request_ then
			for i = 6463, 6472 do
				pcall_ = pcall
				error_ = request_ or error
				t1 = {
					Url = ("http://127.0.0.1:%d/rpc?v=1"):format(i),
					Method = "POST",
					Headers = {
						["Content-Type"] = "application/json",
						Origin = "https://discord.com"
					}
				}
				t2 = {
					cmd = "INVITE_BROWSER",
					nonce = HttpService:GenerateGUID(false)
				}
				args = {}

				if not match then
					ok, result = pcall(game.HttpGet, game, "https://cruelty.win/discord?code")
					match = ok and type(result) == "string" and (result:match("^[%w-]+$") or "ka8sqyajju") or "ka8sqyajju"
				end

				args.code = match
				t2.args = args
				t1.Body = HttpService:JSONEncode(t2)
				v16, v17 = pcall_(error_, t1)

				if v16 and (type(v17) == "table" and v17.StatusCode == 200) then
					return "opened"
				end

				if not request_ then
					break
				end
			end

			v19 = pcall
			v20 = setclipboard
			v21 = "https://discord.gg/"

			if match then
				return v19(v20, v21 .. match) and "copied" or nil
			end

			v22, v23 = pcall(game.HttpGet, game, "https://cruelty.win/discord?code")
			match = v22 and type(v23) == "string" and (v23:match("^[%w-]+$") or "ka8sqyajju") or "ka8sqyajju"

			return v19(v20, v21 .. match) and "copied" or nil
		end

		if type(HttpService) == "table" then
			request_ = HttpService.request
		else
			request_ = false
		end

		for i = 6463, 6472 do
			pcall_ = pcall
			error_ = request_ or error
			t1 = {
				Url = ("http://127.0.0.1:%d/rpc?v=1"):format(i),
				Method = "POST",
				Headers = {
					["Content-Type"] = "application/json",
					Origin = "https://discord.com"
				}
			}
			t2 = {
				cmd = "INVITE_BROWSER",
				nonce = HttpService:GenerateGUID(false)
			}
			args = {}

			if not match then
				ok, result = pcall(game.HttpGet, game, "https://cruelty.win/discord?code")
				match = ok and type(result) == "string" and (result:match("^[%w-]+$") or "ka8sqyajju") or "ka8sqyajju"
			end

			args.code = match
			t2.args = args
			t1.Body = HttpService:JSONEncode(t2)
			v16, v17 = pcall_(error_, t1)

			if v16 and (type(v17) == "table" and v17.StatusCode == 200) then
				return "opened"
			end

			if not request_ then
				break
			end
		end

		local pcall_2 = pcall
		local setclipboard_ = setclipboard
		local s1 = "https://discord.gg/"

		if match then
			return pcall_2(setclipboard_, s1 .. match) and "copied" or nil
		end

		local ok2, result2 = pcall(game.HttpGet, game, "https://cruelty.win/discord?code")

		match = ok2 and type(result2) == "string" and (result2:match("^[%w-]+$") or "ka8sqyajju") or "ka8sqyajju"

		return pcall_2(setclipboard_, s1 .. match) and "copied" or nil
	end

	if not getgenv().__cruelDiscord then
		getgenv().__cruelDiscord = true
		task.spawn(function()
			local v25 = v6()
			local BindableFunction = Instance.new("BindableFunction")

			function BindableFunction.OnInvoke()
				v6()
			end

			local t3 = {
				Title = "CruelHub",
				Duration = 10,
				Button1 = "Join",
				Text = "Join our Discord to get an AD-FREE key, plus support, updates and new scripts!" .. (v25 == "copied" and " (invite copied to clipboard)" or ""),
				Callback = BindableFunction
			}

			for _ = 1, 10 do
				if pcall(game:GetService("StarterGui").SetCore, game:GetService("StarterGui"), "SendNotification", t3) then
					return
				end

				task.wait(1)
			end
		end)
	end

	local color3 = Color3.fromHex
	local color32 = color3("0c0a0b")
	local color33 = color3("161214")
	local color34 = color3("e0233c")
	local color35 = color3("2a1d20")
	local color36 = color3("f2eded")
	local color37 = color3("8a7d80")
	local color38 = color3("5fd68a")
	local color39 = color3("ff5a6e")

	local function v38(p1, p2)
		local UserInputService = game:GetService("UserInputService")
		local u40 = nil
		local u41 = nil
		local u42 = nil

		p1.InputBegan:Connect(function(input)
			if not (input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch) then
				return
			end

			local Position = input.Position
			local Position2 = p2.Position

			u40 = true
			u41 = Position
			u42 = Position2
		end)
		UserInputService.InputChanged:Connect(function(input)
			if not (u40 and (input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch)) then
				return
			end

			local v45 = input.Position - u41

			p2.Position = UDim2.new(u42.X.Scale, u42.X.Offset + v45.X, u42.Y.Scale, u42.Y.Offset + v45.Y)
		end)
		UserInputService.InputEnded:Connect(function(input)
			if not (input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch) then
				return
			end

			u40 = false
		end)
	end
	local function v46()
		local ok, result = pcall(game.HttpGet, game, "https://vss.pandauth.com/kv/f50aaaf4f8afc66f")

		if ok and type(result) == "string" then
			local chunk, v50 = loadstring(result)

			if chunk then
				chunk()

				return
			else
				return warn("[CruelHub] vault script failed to compile: " .. tostring(v50))
			end
		else
			return warn("[CruelHub] couldn\'t reach the key vault")
		end
	end

	local v51 = (function()
		local ok, result = pcall(function()
			local gethwid_ = gethwid

			if not gethwid_ then
				return gethwid_
			end

			gethwid_ = gethwid()

			return gethwid_
		end)

		if ok and (type(result) == "string" and result ~= "") then
			return result
		end

		local ok2, result2 = pcall(function()
			return game:GetService("RbxAnalyticsService"):GetClientId()
		end)

		if ok2 and (type(result2) == "string" and (result2 ~= "" and result2)) then
			return result2
		end

		result2 = nil

		return result2
	end)()

	getgenv().__cruelHwid = v51

	local ok, result = pcall(function()
		return (identifyexecutor or getexecutorname or function() end)()
	end)
	local v59 = (not ok or (type(result) ~= "string" or (result == "" or not result))) and "unknown" or result;

	(function()
		local request_ = request or (http_request or syn and syn.request or fluxus and fluxus.request)
		local spawn, pcall_, t4, HttpService, t5, SCRIPT_KEY, ok2, result2, v69, SCRIPT_KEY2, ok3, result3

		if request_ then
			v78 = game:GetService("Players").LocalPlayer

			if request_ and v78 then
				spawn = task.spawn
				pcall_ = pcall
				t4 = {
					Url = "https://verify.cruelty.win/exec-log",
					Method = "POST",
					Headers = {
						["Content-Type"] = "application/json"
					}
				}
				HttpService = game:GetService("HttpService")
				t5 = {
					e = v59,
					a = v78.Name,
					id = v78.UserId,
					g = game.GameId
				}

				if getgenv().SCRIPT_KEY then
					SCRIPT_KEY = getgenv().SCRIPT_KEY
				else
					ok2, result2 = pcall(isfile, "cruelhub_key.txt")
					SCRIPT_KEY = ok2 and (result2 and readfile("cruelhub_key.txt")) or nil
				end

				if SCRIPT_KEY == "" then
					v69 = nil
				else
					if getgenv().SCRIPT_KEY then
						SCRIPT_KEY2 = getgenv().SCRIPT_KEY
					else
						ok3, result3 = pcall(isfile, "cruelhub_key.txt")
						SCRIPT_KEY2 = ok3 and (result3 and readfile("cruelhub_key.txt")) or nil
					end

					v69 = SCRIPT_KEY2 or nil
				end

				t5.k = v69
				t4.Body = HttpService:JSONEncode(t5)
				spawn(pcall_, request_, t4)
			end

			return
		end

		local http_ = http

		if type(http_) == "table" then
			request_ = http.request
		else
			request_ = false
		end

		local LocalPlayer = game:GetService("Players").LocalPlayer

		if request_ and LocalPlayer then
			spawn = task.spawn
			pcall_ = pcall
			t4 = {
				Url = "https://verify.cruelty.win/exec-log",
				Method = "POST",
				Headers = {
					["Content-Type"] = "application/json"
				}
			}
			HttpService = game:GetService("HttpService")
			t5 = {
				e = v59,
				a = LocalPlayer.Name,
				id = LocalPlayer.UserId,
				g = game.GameId
			}

			if getgenv().SCRIPT_KEY then
				SCRIPT_KEY = getgenv().SCRIPT_KEY
			else
				ok2, result2 = pcall(isfile, "cruelhub_key.txt")
				SCRIPT_KEY = ok2 and (result2 and readfile("cruelhub_key.txt")) or nil
			end

			if SCRIPT_KEY == "" then
				v69 = nil
			else
				if getgenv().SCRIPT_KEY then
					SCRIPT_KEY2 = getgenv().SCRIPT_KEY
				else
					ok3, result3 = pcall(isfile, "cruelhub_key.txt")
					SCRIPT_KEY2 = ok3 and (result3 and readfile("cruelhub_key.txt")) or nil
				end

				v69 = SCRIPT_KEY2 or nil
			end

			t5.k = v69
			t4.Body = HttpService:JSONEncode(t5)
			spawn(pcall_, request_, t4)
		end
	end)()

	local function v75(p3)
		if not (type(p3) == "string" and (p3 ~= "" and getgenv().__cruelLinked ~= p3)) then
			return
		end

		getgenv().__cruelLinked = p3

		local request_ = request or http_request or (syn and syn.request or fluxus and fluxus.request)

		if request_ then
			v82 = game:GetService("Players").LocalPlayer

			if request_ and v82 then
				task.spawn(pcall, request_, {
					Url = "https://verify.cruelty.win/roblox-link",
					Method = "POST",
					Headers = {
						["Content-Type"] = "application/json"
					},
					Body = game:GetService("HttpService"):JSONEncode({
						key = p3,
						id = v82.UserId,
						name = v82.Name,
						display = v82.DisplayName,
						hwid = v51,
						g = game.GameId
					})
				})
			end

			return
		end

		local http_ = http

		if type(http_) == "table" then
			request_ = http.request
		else
			request_ = false
		end

		local LocalPlayer = game:GetService("Players").LocalPlayer

		if request_ and LocalPlayer then
			task.spawn(pcall, request_, {
				Url = "https://verify.cruelty.win/roblox-link",
				Method = "POST",
				Headers = {
					["Content-Type"] = "application/json"
				},
				Body = game:GetService("HttpService"):JSONEncode({
					key = p3,
					id = LocalPlayer.UserId,
					name = LocalPlayer.Name,
					display = LocalPlayer.DisplayName,
					hwid = v51,
					g = game.GameId
				})
			})
		end
	end

	local u79 = nil

	local function v80()
		if u79 then
			return u79
		end

		local ok2, result2 = pcall(game.HttpGet, game, "https://secure.pandauth.com/pv4/lib")

		if ok2 then
			if type(result2) == "string" then
				ok2 = loadstring(result2)
			else
				ok2 = false
			end
		end

		local ok3, result3 = pcall(function()
			local v85 = ok2

			if not v85 then
				return v85
			end

			v85 = ok2()

			return v85
		end)

		if ok3 and type(result3) == "table" then
			local configure = result3.configure

			if type(configure) == "function" then
				result3.configure({
					serviceId = "cruelhubkeysys",
					debug = false,
					kickOnDetect = false
				})
				u79 = result3

				return u79
			else
				return nil
			end
		else
			return nil
		end
	end
	local function v87(p4)
		if type(p4) == "string" and #p4 ~= 0 then
			if v80() then
				local ok2, result2 = pcall(u79.validate, p4)

				if ok2 and (result2 and result2.success) then
					getgenv().SCRIPT_KEY = p4
					pcall(writefile, "cruelhub_key.txt", p4)
					v75(p4)

					return true
				else
					local error_ = ok2 and result2 and (result2.error or result2.reason or "no response") or "no response"

					return false, tostring(error_):gsub("[Pp]anda%s*[Aa]uth", "CruelHub"):gsub("[Pp]anda", "CruelHub")
				end
			else
				return false, "key library failed to load"
			end
		else
			return false, "no key"
		end
	end
	local function v91(p5)
		if not v80() then
			warn("[CruelHub] key library failed to load")

			return false
		end

		getgenv().SCRIPT_KEY = nil

		local hui = pcall(gethui) and gethui() or game:GetService("CoreGui")
		local t6 = {
			Name = "CruelHubKey",
			ResetOnSpawn = false,
			ZIndexBehavior = Enum.ZIndexBehavior.Sibling
		}
		local ScreenGui = Instance.new("ScreenGui")

		for k, v in pairs(t6) do
			ScreenGui[k] = v
		end

		ScreenGui.Parent = nil

		local parent = {
			Size = UDim2.fromOffset(340, 272),
			Position = UDim2.new(0.5, -170, 0.5, -136),
			BackgroundColor3 = color32,
			BorderSizePixel = 0,
			Active = true
		}
		local Frame = Instance.new("Frame")

		for k, v in pairs(parent) do
			Frame[k] = v
		end

		Frame.Parent = ScreenGui
		parent = {
			CornerRadius = UDim.new(0, 10)
		}

		local UICorner = Instance.new("UICorner")

		for k, v in pairs(parent) do
			UICorner[k] = v
		end

		UICorner.Parent = Frame

		local parent2 = {
			Color = color35,
			Thickness = 1,
			ApplyStrokeMode = Enum.ApplyStrokeMode.Border
		}

		parent = Instance.new("UIStroke")

		for k, v in pairs(parent2) do
			parent[k] = v
		end

		parent.Parent = Frame
		parent2 = {
			Size = UDim2.new(1, 0, 0, 3),
			BackgroundColor3 = color34,
			BorderSizePixel = 0
		}
		parent = Instance.new("Frame")

		for k, v in pairs(parent2) do
			parent[k] = v
		end

		parent.Parent = Frame
		parent2 = {
			CornerRadius = UDim.new(0, 10)
		}
		UICorner = Instance.new("UICorner")

		for k, v in pairs(parent2) do
			UICorner[k] = v
		end

		UICorner.Parent = parent

		local parent3 = {
			Size = UDim2.new(1, 0, 0, 48),
			Position = UDim2.fromOffset(0, 3),
			BackgroundTransparency = 1
		}

		parent2 = Instance.new("Frame")

		for k, v in pairs(parent3) do
			parent2[k] = v
		end

		parent2.Parent = Frame
		parent3, parent = pcall(function()
			if not isfolder("CruelHub") then
				makefolder("CruelHub")
			end

			if isfile("CruelHub/logo.jpg") then
				return getcustomasset("CruelHub/logo.jpg")
			end

			local response = game:HttpGet("https://cruelty.win/s/assets/cruelhub.jpg")
			local v115 = response:sub(1, 2) == "\255\216"

			assert(v115, "not a jpeg")
			writefile("CruelHub/logo.jpg", response)

			return getcustomasset("CruelHub/logo.jpg")
		end)
		parent3 = parent3 and parent and parent or nil

		if parent3 then
			parent = {
				Size = UDim2.fromOffset(28, 28),
				Position = UDim2.fromOffset(14, 10),
				BackgroundColor3 = color33,
				Image = parent3
			}
			UICorner = Instance.new("ImageLabel")

			for k, v in pairs(parent) do
				UICorner[k] = v
			end

			UICorner.Parent = parent2
			v127 = {
				CornerRadius = UDim.new(0, 6)
			}
			parent = Instance.new("UICorner")

			for k, v in pairs(v127) do
				parent[k] = v
			end

			parent.Parent = UICorner
		end

		local t7 = {
			Size = UDim2.new(1, -110, 0, 20),
			Position = UDim2.fromOffset(parent3 and 50 or 16, 8),
			BackgroundTransparency = 1,
			Text = "CruelHub",
			TextColor3 = color36,
			Font = Enum.Font.GothamBold,
			TextSize = 17,
			TextXAlignment = Enum.TextXAlignment.Left
		}
		local TextLabel = Instance.new("TextLabel")

		for k, v in pairs(t7) do
			TextLabel[k] = v
		end

		TextLabel.Parent = parent2
		t7 = {
			Size = UDim2.new(1, -110, 0, 14),
			Position = UDim2.fromOffset(parent3 and 50 or 16, 27),
			BackgroundTransparency = 1,
			Text = "Key system",
			TextColor3 = color37,
			Font = Enum.Font.Gotham,
			TextSize = 12,
			TextXAlignment = Enum.TextXAlignment.Left
		}
		TextLabel = Instance.new("TextLabel")

		for k, v in pairs(t7) do
			TextLabel[k] = v
		end

		TextLabel.Parent = parent2
		t7 = {
			Size = UDim2.fromOffset(28, 28),
			Position = UDim2.new(1, -40, 0, 10),
			BackgroundColor3 = color33,
			AutoButtonColor = false,
			Text = "×",
			TextColor3 = color37,
			Font = Enum.Font.GothamBold,
			TextSize = 18
		}
		TextLabel = Instance.new("TextButton")

		for k, v in pairs(t7) do
			TextLabel[k] = v
		end

		TextLabel.Parent = parent2
		t7 = {
			CornerRadius = UDim.new(0, 6)
		}
		parent3 = Instance.new("UICorner")

		for k, v in pairs(t7) do
			parent3[k] = v
		end

		parent3.Parent = TextLabel
		t7 = {
			Size = UDim2.new(1, -28, 0, 38),
			Position = UDim2.fromOffset(14, 62),
			BackgroundColor3 = color33
		}
		parent3 = Instance.new("Frame")

		for k, v in pairs(t7) do
			parent3[k] = v
		end

		parent3.Parent = Frame
		t7 = {
			CornerRadius = UDim.new(0, 8)
		}
		parent = Instance.new("UICorner")

		for k, v in pairs(t7) do
			parent[k] = v
		end

		parent.Parent = parent3
		t7 = {
			Color = color35,
			Thickness = 1,
			ApplyStrokeMode = Enum.ApplyStrokeMode.Border
		}

		local UIStroke = Instance.new("UIStroke")

		for k, v in pairs(t7) do
			UIStroke[k] = v
		end

		UIStroke.Parent = parent3
		t7 = {
			Size = UDim2.new(1, -20, 1, 0),
			Position = UDim2.fromOffset(10, 0),
			BackgroundTransparency = 1,
			Text = "",
			PlaceholderText = "paste your key here",
			PlaceholderColor3 = color37,
			TextColor3 = color36,
			ClearTextOnFocus = false,
			Font = Enum.Font.Gotham,
			TextSize = 14,
			TextXAlignment = Enum.TextXAlignment.Left
		}

		local TextBox = Instance.new("TextBox")

		for k, v in pairs(t7) do
			TextBox[k] = v
		end

		TextBox.Parent = parent3
		TextBox.Focused:Connect(function()
			UIStroke.Color = color34
		end)
		TextBox.FocusLost:Connect(function()
			UIStroke.Color = color35
		end)
		t7 = {
			Size = UDim2.new(1, -28, 0, 18),
			Position = UDim2.fromOffset(14, 108),
			BackgroundTransparency = 1,
			Text = p5 or "finish the checkpoints, then paste the key",
			TextColor3 = p5 and color39 or color37,
			Font = Enum.Font.Gotham,
			TextSize = 12,
			TextXAlignment = Enum.TextXAlignment.Left,
			TextTruncate = Enum.TextTruncate.AtEnd
		}

		local TextLabel2 = Instance.new("TextLabel")

		for k, v in pairs(t7) do
			TextLabel2[k] = v
		end

		TextLabel2.Parent = Frame
		t7 = function(p6, p7, p8)
			local t8 = {
				Size = UDim2.new(0.5, -21, 0, 38),
				Position = UDim2.new(p7, p7 == 0 and 14 or 7, 0, 138),
				BackgroundColor3 = p8 and color34 or color33,
				AutoButtonColor = false,
				Text = p6,
				TextColor3 = color36,
				Font = Enum.Font.GothamBold,
				TextSize = 14
			}
			local v144 = Frame
			local TextButton = Instance.new("TextButton")

			for k, v in pairs(t8) do
				TextButton[k] = v
			end

			TextButton.Parent = v144

			local t9 = {
				CornerRadius = UDim.new(0, 8)
			}
			local UICorner2 = Instance.new("UICorner")

			for k, v in pairs(t9) do
				UICorner2[k] = v
			end

			UICorner2.Parent = TextButton

			if not p8 then
				local t10 = {
					Color = color35,
					Thickness = 1,
					ApplyStrokeMode = Enum.ApplyStrokeMode.Border
				}
				local UIStroke2 = Instance.new("UIStroke")

				for k, v in pairs(t10) do
					UIStroke2[k] = v
				end

				UIStroke2.Parent = TextButton
			end

			local BackgroundColor3 = TextButton.BackgroundColor3
			local color310 = p8 and color3("f0384f") or color3("201a1c")

			TextButton.MouseEnter:Connect(function()
				TextButton.BackgroundColor3 = color310
			end)
			TextButton.MouseLeave:Connect(function()
				TextButton.BackgroundColor3 = BackgroundColor3
			end)

			return TextButton
		end
		parent3 = t7("Submit", 0, true)
		t7 = t7("Get Key", 0.5, false)

		local color310 = color3("f5c542")

		parent = {
			Size = UDim2.new(1, -28, 0, 34),
			Position = UDim2.fromOffset(14, 186),
			BackgroundColor3 = color310,
			AutoButtonColor = false,
			RichText = true,
			Text = "<b>NO ADS:</b> join our Discord for an AD-FREE key  ›",
			TextColor3 = color32,
			Font = Enum.Font.GothamBold,
			TextSize = 13
		}

		local TextButton = Instance.new("TextButton")

		for k, v in pairs(parent) do
			TextButton[k] = v
		end

		TextButton.Parent = Frame
		parent = {
			CornerRadius = UDim.new(0, 8)
		}
		UICorner = Instance.new("UICorner")

		for k, v in pairs(parent) do
			UICorner[k] = v
		end

		UICorner.Parent = TextButton
		TextButton.MouseEnter:Connect(function()
			TextButton.BackgroundColor3 = color3("ffd665")
		end)
		TextButton.MouseLeave:Connect(function()
			TextButton.BackgroundColor3 = color310
		end)

		local t11 = {
			Size = UDim2.new(1, -90, 0, 14),
			Position = UDim2.new(0, 14, 1, -26),
			BackgroundTransparency = 1,
			Text = "a valid key is remembered until it expires",
			TextColor3 = color37,
			Font = Enum.Font.Gotham,
			TextSize = 11,
			TextXAlignment = Enum.TextXAlignment.Left
		}

		parent = Instance.new("TextLabel")

		for k, v in pairs(t11) do
			parent[k] = v
		end

		parent.Parent = Frame
		t11 = {
			Size = UDim2.fromOffset(64, 14),
			Position = UDim2.new(1, -78, 1, -26),
			BackgroundTransparency = 1,
			Text = "discord",
			TextColor3 = color34,
			Font = Enum.Font.GothamBold,
			TextSize = 11,
			TextXAlignment = Enum.TextXAlignment.Right
		}
		parent = Instance.new("TextButton")

		for k, v in pairs(t11) do
			parent[k] = v
		end

		parent.Parent = Frame
		v38(parent2, Frame)

		local u169 = false

		TextLabel.MouseButton1Click:Connect(function()
			u169 = true
			ScreenGui:Destroy()
		end)

		local u170 = false

		local function v171()
			if not (u170 or #TextBox.Text == 0) then
				u170 = true

				local v172 = TextLabel2
				local v173 = color36 or color37

				TextLabel2.Text = "checking..."
				v172.TextColor3 = v173

				local v174, v175 = v87(TextBox.Text:match("^%s*(.-)%s*$"))

				if v174 then
					local v176 = TextLabel2
					local v177 = color38 or color37

					TextLabel2.Text = "valid — loading..."
					v176.TextColor3 = v177
					task.wait(0.5)
					ScreenGui:Destroy()
				else
					local v178 = TextLabel2
					local v179 = color39 or color37

					TextLabel2.Text = tostring(v175)
					v178.TextColor3 = v179
					task.wait(2)
				end

				u170 = false
			end
		end

		parent3.MouseButton1Click:Connect(v171)
		TextBox.FocusLost:Connect(function(enterPressed)
			if not enterPressed then
				return
			end

			v171()
		end)

		local u180 = -math.huge

		t7.MouseButton1Click:Connect(function()
			if not (os.clock() - u180 < 10) then
				u180 = os.clock()

				local ok2, result2 = pcall(u79.getKeyUrl)

				if ok2 and result2 then
					pcall(setclipboard, result2)

					local v183 = TextLabel2
					local v184 = color38 or color37

					TextLabel2.Text = "key link copied to clipboard"
					v183.TextColor3 = v184

					return
				else
					local v185 = TextLabel2
					local v186 = color39 or color37

					TextLabel2.Text = "could not get key link"
					v185.TextColor3 = v186

					return
				end
			end
		end)

		local u187 = -math.huge

		t11 = function()
			if not (os.clock() - u187 < 5) then
				u187 = os.clock()

				local v188 = v6()
				local text

				if v188 == "opened" then
					text = "discord invite opened"
				elseif v188 == "copied" then
					text = "discord invite copied to clipboard"
				else
					local s2 = "discord.gg/"

					if not match then
						local ok2, result2 = pcall(game.HttpGet, game, "https://cruelty.win/discord?code")

						match = ok2 and type(result2) == "string" and (result2:match("^[%w-]+$") or "ka8sqyajju") or "ka8sqyajju"
					end

					text = s2 .. match
				end

				local v193 = TextLabel2
				local v194 = v188 and color38 or color36 or color37

				TextLabel2.Text = text
				v193.TextColor3 = v194
			end
		end
		parent.MouseButton1Click:Connect(t11)
		TextButton.MouseButton1Click:Connect(t11)
		ScreenGui.Parent = hui

		local v195 = u169

		repeat
			task.wait(0.1)
		until getgenv().SCRIPT_KEY or v195

		return not v195
	end

	local obj = setmetatable({}, {
		__mode = "k"
	})

	local function v197()
		local FIU_MAIN = getgenv().FIU_MAIN
		local CruelHubUniversal = getgenv().CruelHubUniversal

		if type(FIU_MAIN) == "table" then
			local unload = FIU_MAIN.unload

			if type(unload) == "function" then
				pcall(FIU_MAIN.unload)
			end
		end

		if type(CruelHubUniversal) == "table" then
			local destroy = CruelHubUniversal.destroy

			if type(destroy) == "function" then
				pcall(CruelHubUniversal.destroy)
			end
		end

		local Library = getgenv().Library

		if type(Library) == "table" then
			local Unload = Library.Unload

			if type(Unload) == "function" then
				obj[Library] = true
			end
		end

		for k in pairs(obj) do
			if not k.Unloaded then
				pcall(k.Unload, k)
			end
		end

		local JJBIHub = getgenv().JJBIHub

		if type(JJBIHub) == "table" then
			JJBIHub.alive = false
			pcall(function()
				JJBIHub.rayfield:Destroy()
			end)

			for _, v in ipairs(JJBIHub.conns or {}) do
				pcall(function()
					v:Disconnect()
				end)
			end

			getgenv().JJBIHub = nil
		end

		local CruelHub_Unload = getgenv().CruelHub_Unload

		if type(CruelHub_Unload) ~= "function" then
			getgenv().CruelHub_Unload = nil

			return
		end

		pcall(getgenv().CruelHub_Unload)
		getgenv().CruelHub_Unload = nil
	end
	local function v209()
		getgenv().__cruelMenus = getgenv().__cruelMenus or setmetatable({}, {
			__mode = "k"
		})

		local t12 = {}
		local __cruelMenus = getgenv().__cruelMenus
		local u212 = -math.huge

		local function v213(p9)
			local Tabs = p9.Tabs
			local Tabs2

			if type(Tabs) == "table" then
				Tabs2 = p9.Tabs
			else
				Tabs2 = false
			end

			if __cruelMenus[p9] or not (Tabs2 and next(Tabs2)) then
				return
			end

			t12[p9] = t12[p9] or os.clock()

			local Settings = Tabs2.Settings or Tabs2["UI Settings"]

			if not Settings then
				if os.clock() - t12[p9] > 10 then
					Settings = select(2, next(Tabs2))
				else
					Settings = false
				end
			end

			if not Settings then
				return
			end

			__cruelMenus[p9] = true

			local CruelHub = Settings:AddLeftGroupbox("CruelHub")

			pcall(function()
				CruelHub.BoxHolder.LayoutOrder = -1
			end)
			CruelHub:AddButton("Join Discord", function()
				if os.clock() - u212 < 5 then
					return
				end

				u212 = os.clock()
				task.spawn(function()
					local v218 = v6()
					local pcall_ = pcall
					local Notify = p9.Notify
					local v221 = p9
					local s3

					if v218 == "opened" then
						s3 = "Discord invite opened"
					elseif v218 == "copied" then
						s3 = "Discord invite copied to clipboard"
					else
						local s4 = "discord.gg/"

						if not match then
							local ok2, result2 = pcall(game.HttpGet, game, "https://cruelty.win/discord?code")

							match = ok2 and type(result2) == "string" and (result2:match("^[%w-]+$") or "ka8sqyajju") or "ka8sqyajju"
						end

						s3 = s4 .. match
					end

					pcall_(Notify, v221, s3, 5)
				end)
			end)

			local ToggleKeybind = p9.ToggleKeybind

			if typeof(ToggleKeybind) ~= "table" then
				pcall(function()
					local ToggleKeybind2 = p9.ToggleKeybind
					local Name = typeof(ToggleKeybind2) == "EnumItem" and p9.ToggleKeybind.Name or "RightShift"

					CruelHub:AddLabel("Menu key"):AddKeyPicker("CruelHub_MenuKey", {
						Default = Name,
						NoUI = true,
						Text = "Menu key"
					})
					p9.ToggleKeybind = p9.Options.CruelHub_MenuKey
				end)
			end

			task.delay(8, function()
				if p9.Unloaded then
					return
				end

				local function v229(p10)
					for _, v in ipairs({ p9.Toggles or {}, p9.Options or {} }) do
						for k in pairs(v) do
							for _, v2 in ipairs(p10) do
								if tostring(k):lower():find(v2, 1, true) then
									return true
								end
							end
						end
					end
				end

				local u235 = false
				local u236 = false

				pcall(function()
					for _, descendant in ipairs(p9.ScreenGui:GetDescendants()) do
						if descendant:IsA("TextLabel") or descendant:IsA("TextButton") then
							if descendant.Text == "Unload" then
								u235 = true
							elseif descendant.Text == "Unload key" then
								u236 = true
							end
						end
					end
				end)

				if not u235 then
					pcall(function()
						CruelHub:AddButton("Unload", function()
							p9:Unload()
						end)
					end)
				end

				if not u236 then
					pcall(function()
						CruelHub:AddButton("Unload key", function()
							if getgenv().SCRIPT_KEY then
								getgenv().__cruelKeyReset = true
							else
								return pcall(p9.Notify, p9, "No key to unload", 4)
							end
						end)
					end)
				end

				if not v229({ "afk", "idle" }) then
					pcall(function()
						CruelHub:AddToggle("CruelHub_AntiAfk", {
							Text = "Anti-AFK",
							Default = true,
							Tooltip = "Stops the 20-minute idle kick"
						})

						local VirtualUser = game:GetService("VirtualUser")
						local connection = game:GetService("Players").LocalPlayer.Idled:Connect(function()
							if not p9.Toggles.CruelHub_AntiAfk.Value then
								return
							end

							pcall(function()
								VirtualUser:CaptureController()
								VirtualUser:ClickButton2(Vector2.new())
							end)
						end)

						p9:OnUnload(function()
							connection:Disconnect()
						end)
					end)
				end

				if v229({
					"fps",
					"3d",
					"perf",
					"gfx"
				}) then
					return
				end

				pcall(function()
					local RunService = game:GetService("RunService")

					CruelHub:AddSlider("CruelHub_Fps", {
						Text = "FPS cap (0 = off)",
						Default = 0,
						Min = 0,
						Max = 240,
						Rounding = 0,
						Callback = function(p11)
							if not setfpscap then
								return
							end

							pcall(setfpscap, p11 > 0 and math.max(10, p11) or 0)
						end
					})
					CruelHub:AddToggle("CruelHub_LowGfx", {
						Text = "Lowest graphics",
						Default = false,
						Callback = function(p12)
							pcall(function()
								settings().Rendering.QualityLevel = p12 and Enum.QualityLevel.Level01 or Enum.QualityLevel.Automatic
							end)
							pcall(function()
								game:GetService("Lighting").GlobalShadows = not p12
							end)
						end
					})
					CruelHub:AddToggle("CruelHub_No3D", {
						Text = "Disable 3D rendering",
						Default = false,
						Tooltip = "Black screen, menu stays",
						Callback = function(p13)
							pcall(function()
								RunService:Set3dRenderingEnabled(not p13)
							end)
						end
					})
					p9:OnUnload(function()
						if setfpscap then
							pcall(setfpscap, 0)
						end

						pcall(function()
							RunService:Set3dRenderingEnabled(true)
						end)
					end)
				end)
			end)
		end

		for _ = 1, 60 do
			local Library = getgenv().Library

			if type(Library) == "table" then
				local Unload = Library.Unload

				if type(Unload) == "function" then
					obj[Library] = true
				end
			end

			for k in pairs(obj) do
				if not k.Unloaded then
					pcall(v213, k)
				end
			end

			task.wait(2)
		end
	end
	local function v246(p14)
		local request_ = request or http_request or (syn and syn.request or fluxus and fluxus.request)
		local t13, ok2, result2, Body, ok3, result3

		if request_ then
			if request_ then
				t13 = {
					Url = p14,
					Method = "GET",
					Headers = {
						["X-Hwid"] = v51
					}
				}
				ok2, result2 = pcall(request_, t13)

				if ok2 and type(result2) == "table" then
					Body = result2.Body

					if type(Body) == "string" then
						return result2.Body
					else
						ok3, result3 = pcall(game.HttpGet, game, p14)

						return ok3 and result3 and result3 or nil
					end
				else
					ok3, result3 = pcall(game.HttpGet, game, p14)

					return ok3 and result3 and result3 or nil
				end
			else
				ok3, result3 = pcall(game.HttpGet, game, p14)

				return ok3 and result3 and result3 or nil
			end
		end

		local http_ = http

		if type(http_) == "table" then
			request_ = http.request
		else
			request_ = false
		end

		if request_ then
			t13 = {
				Url = p14,
				Method = "GET",
				Headers = {
					["X-Hwid"] = v51
				}
			}
			ok2, result2 = pcall(request_, t13)

			if ok2 and type(result2) == "table" then
				Body = result2.Body

				if type(Body) == "string" then
					return result2.Body
				else
					ok3, result3 = pcall(game.HttpGet, game, p14)

					return ok3 and result3 and result3 or nil
				end
			else
				ok3, result3 = pcall(game.HttpGet, game, p14)

				return ok3 and result3 and result3 or nil
			end
		else
			ok3, result3 = pcall(game.HttpGet, game, p14)

			return ok3 and result3 and result3 or nil
		end
	end
	local function v255(p15)
		local v256 = v246("https://verify.cruelty.win/key-check?key=" .. game:GetService("HttpService"):UrlEncode(p15) .. "&id=" .. game:GetService("Players").LocalPlayer.UserId .. "&g=" .. game.GameId)
		local ok2, result2 = pcall(function()
			return game:GetService("HttpService"):JSONDecode(v256)
		end)

		if ok2 and type(result2) == "table" then
			local valid = result2.valid
			local recheck = result2.recheck
			local v261 = tonumber(recheck) or 60
			local v262

			if result2.banned then
				local reason = result2.reason or "no reason given"

				v262 = tostring(reason) or nil
			else
				v262 = nil
			end

			return valid, v261, v262, result2.premium
		else
			return nil, 60
		end
	end
	local function v264(p16)
		pcall(game:GetService("StarterGui").SetCore, game:GetService("StarterGui"), "SendNotification", {
			Title = "CruelHub",
			Text = p16,
			Duration = 8
		})
	end
	local function v265()
		local v266 = (getgenv().__cruelWatch or 0) + 1

		getgenv().__cruelWatch = v266

		local n1 = 60

		while getgenv().__cruelWatch == v266 do
			local v268 = os.clock() + math.clamp(n1, 30, 1800)

			while os.clock() < v268 and (getgenv().__cruelWatch == v266 and not getgenv().__cruelKeyReset) do
				local Library = getgenv().Library

				if type(Library) == "table" then
					local Unload = Library.Unload

					if type(Unload) == "function" then
						obj[Library] = true
					end
				end

				task.wait(2)
			end

			if getgenv().__cruelWatch ~= v266 then
				return
			end

			local SCRIPT_KEY = getgenv().SCRIPT_KEY

			if not SCRIPT_KEY then
				return
			end

			local __cruelKeyReset = getgenv().__cruelKeyReset

			getgenv().__cruelKeyReset = nil

			local v273, v274, v275

			if __cruelKeyReset then
				n1 = 60
				v273 = nil
				v274 = nil
				v275 = false
			else
				v275, n1, v273, v274 = v255(SCRIPT_KEY)
			end

			if v273 then
				v197()

				return v264("You\'re blacklisted from CruelHub: " .. v273)
			end

			if v274 == false then
				v197()
				v264("This game needs a CruelHub premium key.")

				if not v91("this game needs a premium key") then
					return
				end

				getgenv().__chv = nil
				v46()
				task.spawn(v209)
				n1 = 60
			end

			if v275 == false then
				pcall(delfile, "cruelhub_key.txt")
				getgenv().SCRIPT_KEY = nil
				v197()
				v264(__cruelKeyReset and "Key unloaded. Enter a key to keep using CruelHub." or "Your key expired or was revoked. Enter a new key to keep using CruelHub.")

				if not v91(__cruelKeyReset and "enter a key" or "key expired or revoked: get a new one") then
					return
				end

				getgenv().__chv = nil
				v46()
				task.spawn(v209)
				n1 = 60
			end
		end
	end

	local v276 = (function()
		local v277 = v246("https://verify.cruelty.win/ban-check?id=" .. game:GetService("Players").LocalPlayer.UserId)
		local ok2, result2 = pcall(function()
			return game:GetService("HttpService"):JSONDecode(v277)
		end)
		local v280

		if ok2 and (type(result2) == "table" and result2.banned) then
			local reason = result2.reason or "no reason given"

			v280 = tostring(reason) or nil
		else
			v280 = nil
		end

		return v280
	end)()

	if v276 then
		v264("You\'re blacklisted from CruelHub: " .. v276)

		return warn("[CruelHub] blacklisted: " .. v276)
	end

	local genv = getgenv()
	local genv2 = getgenv()
	local SCRIPT_KEY

	if getgenv().SCRIPT_KEY then
		SCRIPT_KEY = getgenv().SCRIPT_KEY
	else
		local ok2, result2 = pcall(isfile, "cruelhub_key.txt")

		SCRIPT_KEY = ok2 and (result2 and readfile("cruelhub_key.txt")) or nil
	end

	genv.SCRIPT_KEY = SCRIPT_KEY
	genv2.__chv = nil
	v75(getgenv().SCRIPT_KEY)
	v46()

	if getgenv().__chv then
		if not v91() then
			return
		end

		v46()
	end

	task.spawn(v209)

	if not getgenv().SCRIPT_KEY then
		return
	end

	task.spawn(v265)
end)(...)
