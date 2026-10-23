-- Detected obfuscation: Luraph v15
-- Local names are inferred from use (the original names are not in bytecode)

local flag, tbl, tbl2, tbl3, Workspace, Players, ReplicatedStorage, localPlayer, v, fn
local fn2, fn3, v2, tbl4, handlers, tbl5, tbl6

do
	local HttpService = game:GetService("HttpService")
	local n = 0

	pcall(function()
		if game.PlaceId ~= 99567941238278 then
			local data = nil

			local ok, result = pcall(function()
				return game:HttpGet("https://platinstudio.xyz/raw/InkVersion")
			end)

			if ok and result then
				pcall(function()
					data = HttpService:JSONDecode(result)
				end)
			end

			if not data or not data.LastCheckedVersion then
				local ok2, result2 = pcall(function()
					return game:HttpGet("https://raw.githubusercontent.com/platinww/UwU/refs/heads/main/UI/InkVersion.json")
				end)

				if ok2 and result2 then
					pcall(function()
						data = HttpService:JSONDecode(result2)
					end)
				end
			end

			if data and data.LastCheckedVersion then
				n = tonumber(data.LastCheckedVersion) or 0
			end
		end
	end)

	flag = false

	if game.PlaceId ~= 99567941238278 then
		if n < game.PlaceVersion then
			flag = true
		end
	end

	if not game:IsLoaded() then
		game.Loaded:Wait()
	end

	tbl = {}
	tbl2 = {}
	tbl3 = {}
	local flag2 = false

	pcall(function()
		local request_ = request or http_request or syn and syn.request or fluxus and fluxus.request

		if request_ then
			local v3 = request_({ Url = "https://platinstudio.xyz/raw/InkScriptVersion", Method = "GET" })

			if v3 and v3.Success and v3.Body then
				local str = v3.Body:gsub("%s+", "")

				if str ~= "" then
					if (tonumber(("v1.8"):match("%d+%.?%d*")) or 0) < (tonumber(str:match("%d+%.?%d*")) or 0) then
						flag2 = true
					end
				end
			end
		end
	end)

	if flag2 then
		local Players2 = game:GetService("Players")

		while not Players2.LocalPlayer do
			task.wait(0.1)
		end

		Players2.LocalPlayer:Kick("Outdated Script Version\nIf You Believe This Is Mistake discord.gg/larpstudios")
		return
	end

	Workspace = game:GetService("Workspace")
	Players = game:GetService("Players")
	ReplicatedStorage = game:GetService("ReplicatedStorage")
	localPlayer = Players.LocalPlayer
	local lib = nil

	pcall(function()
		lib = loadstring(game:HttpGet("https://raw.githubusercontent.com/BocusLuke/UI/main/STX/Module.Lua"))()
	end)

	v = nil

	local function fn4()
		local response = nil

		pcall(function()
			response = game:HttpGet("https://raw.githubusercontent.com/platinww/CrustyMain/refs/heads/main/universal/ftgs.lua")
		end)

		if not response or response == "" or response:match("404: Not Found") then
			local request_ = request or http_request or syn and syn.request or fluxus and fluxus.request

			if request_ then
				pcall(function()
					local v3 = request_({
						Url = "https://raw.githubusercontent.com/platinww/CrustyMain/refs/heads/main/universal/ftgs.lua",
						Method = "GET",
					})

					if v3 and v3.Success and v3.Body and v3.Body ~= "" and not v3.Body:match("404: Not Found") then
						response = v3.Body
					end
				end)
			end
		end

		if response and response ~= "" then
			response = response:gsub("local j=\"https://platinstudio.xyz/raw/WindIcons\"", "local j=\"https://raw.githubusercontent.com/eeeiqjjj/icon.github.io/refs/heads/main/lucide.lua\"")
			response = response:gsub("if u==false or not l then return nil end", "if u==false or not l then return setmetatable({Url=\"\",ImageRectOffset=Vector2.zero,ImageRectSize=Vector2.zero},{__index=function(t,k)if k==1 then return \"\" elseif k==2 then return{ImageRectPosition=Vector2.zero,ImageRectSize=Vector2.zero}end end}) end")
			response = response:gsub("if not%%(ok and data%%)then return nil end", "if not(ok and data)then return setmetatable({Url=\"\",ImageRectOffset=Vector2.zero,ImageRectSize=Vector2.zero},{__index=function(t,k)if k==1 then return \"\" elseif k==2 then return{ImageRectPosition=Vector2.zero,ImageRectSize=Vector2.zero}end end}) end")
			local chunk = loadstring(response)

			if chunk then
				v = chunk()
			end
		end
	end

	fn4()

	local function fn5(arg)
		if not isfile or not isfile(arg) then
			return nil
		end
		local getcustomasset_ = getcustomasset or getsynasset or getgenv and (getgenv().getcustomasset or getgenv().getsynasset)

		if not getcustomasset_ and Fluxus and Fluxus.getcustomasset then
			getcustomasset_ = Fluxus.getcustomasset
		end

		if not getcustomasset_ and Krnl and Krnl.getcustomasset then
			getcustomasset_ = Krnl.getcustomasset
		end

		if getcustomasset_ then
			local tbl7 = {}
			local str = arg:gsub("^LarpHub/", "")
			local gsub = arg.gsub
			tbl7[1] = arg
			tbl7[2] = "/" .. arg
			tbl7[3] = str

			do
				local values = table.pack(gsub(arg, "/", "\\"))
				table.move(values, 1, values.n, 4, tbl7)
			end

			for _, v3 in ipairs(tbl7) do
				local ok, result = pcall(getcustomasset_, v3)
				if ok and result and typeof(result) == "string" and #result > 0 then
					return result
				end
			end
		end

		return nil
	end

	fn = function()
		local str = "https://raw.githubusercontent.com/platinww/UwU/main/UI/1351575.jpg"

		pcall(function()
			if isfolder and not isfolder("LarpHub") then
				makefolder("LarpHub")
			end

			if isfolder and not isfolder("LarpHub/assets") then
				makefolder("LarpHub/assets")
			end

			if isfile and isfile("LarpHub/assets/furina_v3.jpg") and readfile then
				local jpg = readfile("LarpHub/assets/furina_v3.jpg")

				if not jpg or #jpg == 0 then
					if delfile then
						pcall(delfile, "LarpHub/assets/furina_v3.jpg")
					end
				end
			end

			if isfile and not isfile("LarpHub/assets/furina_v3.jpg") and writefile then
				local body = nil
				local request_ = syn and syn.request
				local request_2

				if request_ then
					request_2 = request_
				else
					request_2 = http and http.request
				end

				local v3 = request_2 or request or http_request

				if v3 then
					pcall(function()
						local v4 = v3({ Url = str, Method = "GET" })

						if v4 and v4.Body and #v4.Body > 0 then
							body = v4.Body
						end
					end)
				end

				if not body or #body == 0 then
					pcall(function()
						body = game:HttpGet("https://raw.githubusercontent.com/platinww/UwU/main/UI/1351575.jpg")
					end)
				end

				if body and #body > 0 then
					writefile("LarpHub/assets/furina_v3.jpg", body)
				end
			end
		end)

		local jpg = fn5("LarpHub/assets/furina_v3.jpg")
		if jpg then
			return jpg
		end
		return nil
	end

	fn2 = function(arg)
		pcall(function()
			if not Window or not Window.UIElements or not Window.UIElements.Main then
				return
			end
			local main = Window.UIElements.Main
			local background = main:FindFirstChild("Background") or main

			pcall(function()
				main.ClipsDescendants = true
			end)

			if background and background:IsA("GuiObject") then
				pcall(function()
					background.ClipsDescendants = true
				end)
			end

			local furinaBgImage = background:FindFirstChild("FurinaBgImage")

			if arg then
				tbl.CurrentThemeName = "Furina Genshin"

				if ruzAnimConn then
					pcall(function()
						ruzAnimConn:Disconnect()
					end)

					ruzAnimConn = nil
				end

				if ruzAnimContainer then
					ruzAnimContainer.Visible = false
				end

				local v3 = fn()

				if not v3 then
					if Window and Window.SetBackgroundImage then
						pcall(function()
							Window:SetBackgroundImage("https://raw.githubusercontent.com/platinww/UwU/main/UI/1351575.jpg")
						end)
					end

					return
				end

				if not furinaBgImage then
					local imageLabel = Instance.new("ImageLabel")
					imageLabel.Name = "FurinaBgImage"
					imageLabel.Size = UDim2.new(1, 0, 1, 0)
					imageLabel.BackgroundTransparency = 1
					imageLabel.ScaleType = Enum.ScaleType.Crop
					imageLabel.ZIndex = 1
					imageLabel.ClipsDescendants = true
					imageLabel.Parent = background
					local uiCorner = Instance.new("UICorner")
					uiCorner.CornerRadius = UDim.new(0, 14)
					uiCorner.Parent = imageLabel
					furinaBgImage = imageLabel
				end

				furinaBgImage.Image = v3
				furinaBgImage.ImageTransparency = 0.5
				furinaBgImage.Visible = true
			else
				if furinaBgImage then
					furinaBgImage.Visible = false
					furinaBgImage.ImageTransparency = 1
				end

				if Window and Window.SetBackgroundImage then
					pcall(function()
						Window:SetBackgroundImage("")
					end)
				end
			end
		end)
	end

	local function fn6()
		local tbl7 = {}

		for match in string.gmatch("105945183689611,73508806663574,83283298046358,113495722420896,85233175572488,84182427140137,82748240649010,78860722288350,107102184635871,110898142671973,87214876397205,105203852440305,77883961484206,126623799590012,91474097079161,98718280245015,111062272133769,115821861998676,93835883876713,139649089665559,120828318960070,95338628841935,103472871155130,83657465787527,83248372739128,108358366652302,133868382220444,117812340355702,117241804955035,108163503726037,80566164738816,103177066435636,138962144446694,97387232349806,129535956026017,72327307619918,131254893672022,79431882611558,94376809664056,74712223703220,77428452195163,110731410878599,124548391472962,130015890944015,138326939239140,116483591755654,114461166826754,111178696015355,139416771716998,94742387386496,88691793193268,90662783635950,124115768167703,99726551474718,126558729644213,71614607188785,79827586059759,109284281035617,107966387870698,102579779688372,112156033802069,71932817449388,76075949487982,104604376173895,107781389641490,96366395614242,98579554681024,109105194031256,118274206899943,121262391909235,108978040611308,92301420719698,130675383145258,109936892767664,126023221721433", "%d+") do
			table.insert(tbl7, tonumber(match))
		end

		return tbl7
	end

	local v3 = fn6()
	local frame = nil
	local tbl7 = {}
	local connection = nil

	fn3 = function(arg)
		pcall(function()
			if not Window or not Window.UIElements or not Window.UIElements.Main then
				return
			end
			local main = Window.UIElements.Main
			local background = main:FindFirstChild("Background") or main

			pcall(function()
				main.ClipsDescendants = true
			end)

			if background and background:IsA("GuiObject") then
				pcall(function()
					background.ClipsDescendants = true
				end)
			end

			if arg then
				tbl.CurrentThemeName = "Closing Eyes"
				local furinaBgImage = background:FindFirstChild("FurinaBgImage")

				if furinaBgImage then
					furinaBgImage.Visible = false
					furinaBgImage.ImageTransparency = 1
				end

				if Window and Window.SetBackgroundImage then
					pcall(function()
						Window:SetBackgroundImage("")
					end)
				end

				if not frame then
					frame = Instance.new("Frame")
					frame.Name = "AnimatedBackgroundContainer"
					frame.Size = UDim2.fromScale(1, 1)
					frame.BackgroundTransparency = 1
					frame.ClipsDescendants = true
					frame.ZIndex = 0
					frame.Parent = background
					local uiCorner = Instance.new("UICorner")
					uiCorner.CornerRadius = UDim.new(0, 14)
					uiCorner.Parent = frame

					for i, v4 in ipairs(v3) do
						local imageLabel = Instance.new("ImageLabel")
						imageLabel.Size = UDim2.fromScale(1, 1)
						imageLabel.BackgroundTransparency = 1
						imageLabel.ScaleType = Enum.ScaleType.Crop
						imageLabel.Image = "rbxassetid://" .. tostring(v4)
						imageLabel.Visible = false
						imageLabel.ZIndex = 0
						imageLabel.Parent = frame
						local uiCorner2 = Instance.new("UICorner")
						uiCorner2.CornerRadius = UDim.new(0, 14)
						uiCorner2.Parent = imageLabel
						tbl7[i] = imageLabel
					end

					task.spawn(function()
						local ContentProvider = game:GetService("ContentProvider")

						pcall(function()
							ContentProvider:PreloadAsync(tbl7)
						end)
					end)
				end

				frame.Visible = not Window.Closed

				if not connection and #tbl7 > 0 then
					local n2 = 1
					tbl7[n2].Visible = true
					local n3 = 0.04
					local n4 = 0

					connection = game:GetService("RunService").RenderStepped:Connect(function(deltaTime)
						n4 += deltaTime

						if n4 >= n3 then
							n4 %= n3

							if tbl7[n2] then
								tbl7[n2].Visible = false
							end

							n2 = n2 % #tbl7 + 1

							if tbl7[n2] then
								tbl7[n2].Visible = true
							end
						end
					end)
				end
			else
				if connection then
					pcall(function()
						connection:Disconnect()
					end)

					connection = nil
				end

				if frame then
					frame.Visible = false
				end
			end
		end)
	end

	pcall(function()
		if v and v.AddTheme then
			v:AddTheme({
				Name = "Cyberpunk",
				Accent = Color3.fromHex("#ff0055"),
				Dialog = Color3.fromHex("#0f1123"),
				Outline = Color3.fromHex("#00f0ff"),
				Text = Color3.fromHex("#ffffff"),
				Placeholder = Color3.fromHex("#00f0ff"),
				Background = Color3.fromHex("#080914"),
				Button = Color3.fromHex("#1a0033"),
				Icon = Color3.fromHex("#00f0ff"),
				Toggle = Color3.fromHex("#ff0055"),
				Checkbox = Color3.fromHex("#00f0ff"),
			})

			v:AddTheme({
				Name = "Dracula",
				Accent = Color3.fromHex("#bd93f9"),
				Dialog = Color3.fromHex("#21222c"),
				Outline = Color3.fromHex("#ff79c6"),
				Text = Color3.fromHex("#f8f8f2"),
				Placeholder = Color3.fromHex("#8be9fd"),
				Background = Color3.fromHex("#282a36"),
				Button = Color3.fromHex("#44475a"),
				Icon = Color3.fromHex("#8be9fd"),
				Toggle = Color3.fromHex("#50fa7b"),
				Checkbox = Color3.fromHex("#bd93f9"),
			})

			v:AddTheme({
				Name = "Tokyo Night",
				Accent = Color3.fromHex("#7aa2f7"),
				Dialog = Color3.fromHex("#16161e"),
				Outline = Color3.fromHex("#7dcfff"),
				Text = Color3.fromHex("#c0caf5"),
				Placeholder = Color3.fromHex("#bb9af7"),
				Background = Color3.fromHex("#1a1b26"),
				Button = Color3.fromHex("#24283b"),
				Icon = Color3.fromHex("#bb9af7"),
				Toggle = Color3.fromHex("#9ece6a"),
				Checkbox = Color3.fromHex("#7aa2f7"),
			})

			v:AddTheme({
				Name = "Vaporwave",
				Accent = Color3.fromHex("#ff71ce"),
				Dialog = Color3.fromHex("#20003b"),
				Outline = Color3.fromHex("#05ffa1"),
				Text = Color3.fromHex("#fffbfe"),
				Placeholder = Color3.fromHex("#01cdfe"),
				Background = Color3.fromHex("#18002e"),
				Button = Color3.fromHex("#2d0059"),
				Icon = Color3.fromHex("#01cdfe"),
				Toggle = Color3.fromHex("#05ffa1"),
				Checkbox = Color3.fromHex("#ff71ce"),
			})

			v:AddTheme({
				Name = "Onyx Gold",
				Accent = Color3.fromHex("#ffd700"),
				Dialog = Color3.fromHex("#141414"),
				Outline = Color3.fromHex("#ffd700"),
				Text = Color3.fromHex("#ffffff"),
				Placeholder = Color3.fromHex("#f3c623"),
				Background = Color3.fromHex("#0d0d0d"),
				Button = Color3.fromHex("#222222"),
				Icon = Color3.fromHex("#f3c623"),
				Toggle = Color3.fromHex("#ffd700"),
				Checkbox = Color3.fromHex("#ffd700"),
			})

			v:AddTheme({
				Name = "Blood Moon",
				Accent = Color3.fromHex("#ff0000"),
				Dialog = Color3.fromHex("#1e0505"),
				Outline = Color3.fromHex("#ff1a1a"),
				Text = Color3.fromHex("#ffffff"),
				Placeholder = Color3.fromHex("#ff4d4d"),
				Background = Color3.fromHex("#120303"),
				Button = Color3.fromHex("#330000"),
				Icon = Color3.fromHex("#ff4d4d"),
				Toggle = Color3.fromHex("#ff0000"),
				Checkbox = Color3.fromHex("#ff0000"),
			})

			v:AddTheme({
				Name = "Closing Eyes",
				Accent = v.Gradient and v:Gradient({
					["0"] = { Color = Color3.fromHex("#ffffff"), Transparency = 0 },
					["100"] = { Color = Color3.fromHex("#312d84"), Transparency = 0 },
				}, { Rotation = 0 }) or Color3.fromHex("#312d84"),
				Dialog = Color3.fromHex("#ffffff"),
				Outline = Color3.fromHex("#ffffff"),
				Text = Color3.fromHex("#ffffff"),
				Placeholder = Color3.fromHex("#c0c0c0"),
				Background = Color3.fromHex("#181438"),
				Button = Color3.fromHex("#3b378a"),
				Icon = Color3.fromHex("#ffffff"),
				Toggle = Color3.fromHex("#3b378a"),
				Checkbox = Color3.fromHex("#3b378a"),
				TabBackground = Color3.fromHex("#ffffff"),
				ElementBackground = Color3.fromHex("#ffffff"),
			})

			v:AddTheme({
				Name = "Furina Genshin",
				Accent = Color3.fromHex("#00f0ff"),
				Dialog = Color3.fromHex("#0b0f19"),
				Outline = Color3.fromHex("#00f0ff"),
				Text = Color3.fromHex("#ffffff"),
				Placeholder = Color3.fromHex("#70d6ff"),
				Background = Color3.fromHex("#090d16"),
				Button = Color3.fromHex("#121a29"),
				Icon = Color3.fromHex("#00f0ff"),
				Toggle = Color3.fromHex("#00f0ff"),
				Checkbox = Color3.fromHex("#00f0ff"),
			})
		end
	end)

	local str = "Dark"

	pcall(function()
		if isfile and isfile("LarpHub/default_theme.txt") and readfile then
			local txt = readfile("LarpHub/default_theme.txt")

			if txt and txt ~= "" and v and v.Themes and v.Themes[txt] then
				str = txt
			end
		end
	end)

	if not v then
		return
	end
	local color = Color3.fromHex

	v2 = v:CreateWindow({
		Title = "Larp Hub | Ink Game",
		Icon = "bird",
		Folder = "LarpHub",
		ToggleKey = Enum.KeyCode.G,
		Size = UDim2.fromOffset(650, 480),
		Transparent = false,
		Background = "",
		Theme = str,
		Author = "discord.gg/larpstudios",
		User = {
			Enabled = true,
			Callback = function()
			end,
			Anonymous = false,
		},
		OpenButton = {
			Title = "Larp Hub",
			CornerRadius = UDim.new(1, 0),
			StrokeThickness = 3,
			Enabled = true,
			Draggable = true,
			OnlyMobile = false,
			Scale = 0.5,
			Color = ColorSequence.new(Color3.fromHex("#A5B4FC"), color("#FFFFFF")),
		},
	})

	task.defer(function()
		if str == "Furina Genshin" then
			fn2(true)
		elseif str == "Closing Eyes" then
			fn3(true)
		end
	end)

	pcall(function()
		if v2 then
			local TweenService = game:GetService("TweenService")
			local onOpenCallback = v2.OnOpenCallback

			v2.OnOpenCallback = function(...)
				if onOpenCallback then
					pcall(onOpenCallback, ...)
				end

				pcall(function()
					local main = v2.UIElements and v2.UIElements.Main
					local background = main and (main:FindFirstChild("Background") or main)
					local currentThemeName = tbl.CurrentThemeName or v and v.GetCurrentTheme and v:GetCurrentTheme() or str or "Dark"
					local flag3 = currentThemeName == "Furina Genshin"
					local visible = currentThemeName == "Closing Eyes"
					local furinaBgImage = background and background:FindFirstChild("FurinaBgImage")

					if furinaBgImage then
						if flag3 then
							furinaBgImage.Visible = true
							TweenService:Create(furinaBgImage, TweenInfo.new(0.2, Enum.EasingStyle.Quint, Enum.EasingDirection.Out), { ImageTransparency = 0.5 }):Play()
						else
							furinaBgImage.Visible = false
							furinaBgImage.ImageTransparency = 1
						end
					end

					background = background and background:FindFirstChild("AnimatedBackgroundContainer")

					if background then
						background.Visible = visible
					end
				end)
			end

			local onCloseCallback = v2.OnCloseCallback

			v2.OnCloseCallback = function(...)
				if onCloseCallback then
					pcall(onCloseCallback, ...)
				end

				pcall(function()
					local main = v2.UIElements and v2.UIElements.Main
					local background = main and (main:FindFirstChild("Background") or main)
					local furinaBgImage = background and background:FindFirstChild("FurinaBgImage")

					if furinaBgImage and furinaBgImage.Visible then
						TweenService:Create(furinaBgImage, TweenInfo.new(0.15, Enum.EasingStyle.Quint, Enum.EasingDirection.InOut), { ImageTransparency = 1 }):Play()
					end

					background = background and background:FindFirstChild("AnimatedBackgroundContainer")

					if background then
						background.Visible = false
					end
				end)
			end
		end
	end)

	tbl4 = {}
	handlers = {}

	local function fn7(arg)
		if not arg or arg._wrapped then
			return arg
		end
		arg._wrapped = true
		local toggle = arg.Toggle

		if toggle then
			arg.Toggle = function(arg2, arg3)
				local title = arg3.Flag or arg3.Title
				local callback = arg3.Callback

				if title then
					arg3.Callback = function(arg4)
						tbl[title] = arg4

						if callback then
							pcall(callback, arg4)
						end
					end
				end

				local v4 = toggle(arg2, arg3)

				if title then
					tbl4[title] = v4

					if arg3.Callback then
						handlers[title] = arg3.Callback
					end
				end

				return v4
			end
		end

		local slider = arg.Slider

		if slider then
			arg.Slider = function(arg2, arg3)
				local title = arg3.Flag or arg3.Title
				local callback = arg3.Callback

				if title then
					arg3.Callback = function(arg4)
						local default = type(arg4) == "table" and (arg4.Value or arg4.Default) or tonumber(arg4)

						if default then
							tbl[title] = default
						end

						if callback then
							pcall(callback, arg4)
						end
					end
				end

				local v4 = slider(arg2, arg3)

				if title then
					tbl4[title] = v4

					if arg3.Callback then
						handlers[title] = arg3.Callback
					end
				end

				return v4
			end
		end

		local dropdown = arg.Dropdown

		if dropdown then
			arg.Dropdown = function(arg2, arg3)
				local title = arg3.Flag or arg3.Title
				local callback = arg3.Callback

				if title then
					arg3.Callback = function(arg4)
						tbl[title] = arg4

						if callback then
							pcall(callback, arg4)
						end
					end
				end

				local v4 = dropdown(arg2, arg3)

				if title then
					tbl4[title] = v4

					if arg3.Callback then
						handlers[title] = arg3.Callback
					end
				end

				return v4
			end
		end

		local keybind = arg.Keybind

		if keybind then
			arg.Keybind = function(arg2, arg3)
				local title = arg3.Flag or arg3.Title
				local callback = arg3.Callback

				if title then
					arg3.Callback = function(arg4)
						tbl[title] = arg4

						if callback then
							pcall(callback, arg4)
						end
					end
				end

				local v4 = keybind(arg2, arg3)

				if title then
					tbl4[title] = v4

					if arg3.Callback then
						handlers[title] = arg3.Callback
					end
				end

				return v4
			end
		end

		return arg
	end

	local tab = v2.Tab

	v2.Tab = function(arg, arg2)
		local v4 = tab(arg, arg2)
		local section = v4.Section

		if section then
			v4.Section = function(arg3, arg4)
				local v5 = section(arg3, arg4)
				return fn7(v5)
			end
		end

		return v4
	end

	tbl5 = {
		RLGL = v2:Tab({ Title = "Red Light Green Light", Icon = "traffic-cone" }),
		Dalgona = v2:Tab({ Title = "Dalgona & Pentathlon", Icon = "cookie" }),
		LightsOut = v2:Tab({ Title = "Lights Out", Icon = "moon" }),
		HSTOW = v2:Tab({ Title = "Hide And Seek & Tug Of War", Icon = "eye" }),
		MingleGlass = v2:Tab({ Title = "Jump Rope & Glass Bridge", Icon = "swords" }),
		Mingle = v2:Tab({ Title = "Mingle", Icon = "users" }),
		Rebel = v2:Tab({ Title = "Rebel", Icon = "target" }),
		Sky = v2:Tab({ Title = "Sky & Squid Game", Icon = "cloud" }),
		Guard = v2:Tab({ Title = "Guard Mode", Icon = "shield" }),
		Combat = v2:Tab({ Title = "Combat", Icon = "swords" }),
		Tools = v2:Tab({ Title = "Tools", Icon = "wrench" }),
		Utilities = v2:Tab({ Title = "Utilities", Icon = "wrench" }),
		Visual = v2:Tab({ Title = "Visual", Icon = "eye" }),
		UISettings = v2:Tab({ Title = "UI Settings", Icon = "settings" }),
	}

	tbl6 = {
		InfoBox = tbl5.UISettings:Section({ Opened = true, Title = "| Larp Hub Information", Icon = "info" }),
	}

	local infoBox = tbl6.InfoBox

	if game.PlaceId ~= 99567941238278 then
		infoBox:Divider()

		infoBox:Paragraph({
			Title = "Game Version",
			Desc = "<font color=\"#A5B4FC\"><b>" .. tostring(game.PlaceVersion) .. "</b></font>",
		})

		infoBox:Divider()

		infoBox:Paragraph({
			Title = "Last Checked",
			Desc = "<font color=\"#A5B4FC\"><b>" .. tostring(n) .. "</b></font>",
		})

		if flag then
			infoBox:Space()
			infoBox:Divider()

			infoBox:Paragraph({
				Title = "<font color=\"#F87171\"><b>WARNING</b></font>",
				Desc = "<font color=\"#FCCCA7\">Game Version Change Detected Features may be patched.</font>",
			})
		end
	end

	infoBox:Space()
	infoBox:Section({ Opened = true, Title = "<font color=\"#FBBF24\"><b>Latest Update Logs:</b></font>" })
	local str2 = "Failed to fetch logs..."

	pcall(function()
		local request_ = request or http_request or syn and syn.request

		if request_ then
			local v4 = request_({ Url = "https://platinstudio.xyz/raw/UpdateLogs", Method = "GET" })

			if not v4 or not v4.Success or not v4.Body or v4.StatusCode ~= 200 then
				v4 = request_({
					Url = "https://raw.githubusercontent.com/platinww/UwU/refs/heads/main/UI/LastUpdateLog",
					Method = "GET",
				})
			end

			if v4 and v4.Success and v4.Body then
				local str3 = ""

				for match in tostring(v4.Body):gmatch("[^\r\n]+") do
					local str4 = match:gsub("%*%*", "")

					if str4:match("^%s*%-") then
						str3 ..= "<font color=\"#A5B4FC\">></font> <font color=\"#F3F4F6\">" .. str4:gsub("^%s*%-%s*", "") .. "</font>\n"
					end
				end

				if str3 ~= "" then
					str2 = str3:gsub("\n$", "")
				else
					str2 = "<font color=\"#9CA3AF\">No recent updates found.</font>"
				end
			end
		end
	end)

	infoBox:Divider()
	infoBox:Paragraph({ Title = "Latest Update Logs:", Desc = str2 })
end

local fn4

do
	local value = nil
	local n = 0

	local function fn5()
		if tick() - n < 0.5 then
			return value
		end
		n = tick()
		local values = Workspace:FindFirstChild("Values")
		values = values and values:FindFirstChild("CurrentGame")

		if values and values.Value ~= "" then
			value = values.Value
		else
			value = nil
		end

		return value
	end

	fn4 = function(arg)
		return fn5() == arg
	end
end

local fn5
local str = "rbxassetid://4590657391"

pcall(function()
	if not isfolder("LarpStudios") then
		makefolder("LarpStudios")
	end

	if not isfile("LarpStudios/notify.wav") then
		local response = game:HttpGet("https://github.com/platinww/UwU/raw/refs/heads/main/UI/notify.wav")
		writefile("LarpStudios/notify.wav", response)
	end

	if getcustomasset then
		str = getcustomasset("LarpStudios/notify.wav")
	end
end)

fn5 = function(arg, arg2)
	v:Notify({ Title = arg or "Larp Hub", Content = arg2, Duration = 4 })

	pcall(function()
		local sound = Instance.new("Sound")
		local v3 = str
		local soundId

		if str then
			soundId = v3
		else
			soundId = "rbxassetid://4590657391"
		end

		sound.SoundId = soundId
		sound.Volume = 2
		sound.Parent = game:GetService("SoundService")
		sound:Play()
		game:GetService("Debris"):AddItem(sound, 3)
	end)
end

local fn6

local tbl7 = {
	w = 87,
	a = 65,
	s = 83,
	d = 68,
	space = 32,
	e = 69,
	q = 81,
	f = 70,
	r = 82,
	t = 84,
	y = 89,
	x = 88,
	c = 67,
	v = 86,
	b = 66,
	g = 71,
	h = 72,
	z = 90,
	["1"] = 49,
	["2"] = 50,
	["3"] = 51,
	["4"] = 52,
	["5"] = 53,
	["6"] = 54,
	["7"] = 55,
	["8"] = 56,
	["9"] = 57,
	["0"] = 48,
}

fn6 = function(arg)
	if type(keypress) == "function" and type(keyrelease) == "function" then
		local v3 = tbl7[string.lower(tostring(arg))]

		if v3 then
			keypress(v3)
			task.wait(0.05)
			keyrelease(v3)
			return true
		end
	end

	return false
end

local fn7
local HBGQTE = nil

fn7 = function()
	if not HBGQTE then
		pcall(function()
			local modules = game:GetService("ReplicatedStorage"):WaitForChild("Modules", 5)

			if modules then
				HBGQTE = require(modules:WaitForChild("HBGQTE", 5))
			end
		end)
	end

	return HBGQTE
end

local guid
guid = nil

task.spawn(function()
	pcall(function()
		local modules = game:GetService("ReplicatedStorage"):WaitForChild("Modules", 5)

		if modules then
			local games = modules:WaitForChild("Games", 5)

			if games then
				local PentathlonClient = require(games:WaitForChild("PentathlonClient", 5))

				if PentathlonClient and type(PentathlonClient) == "table" then
					local runServerGame = PentathlonClient.RunServerGame

					if runServerGame then
						PentathlonClient.RunServerGame = function(arg, arg2, ...)
							if arg and arg.GUID then
								guid = arg.GUID
							end

							local v3 = table.pack(...)
							local v4 = runServerGame
							v3.n = 3 + v3.n - 1
							table.move(v3, 1, v3.n, 3, v3)
							v3[1] = arg
							v3[2] = arg2
							return v4(table.unpack(v3, 1, v3.n))
						end
					end

					local addActiveGame = PentathlonClient.AddActiveGame

					if addActiveGame then
						PentathlonClient.AddActiveGame = function(arg)
							if arg and arg.GUID then
								guid = arg.GUID
							end

							return addActiveGame(arg)
						end
					end
				end
			end
		end
	end)
end)

local fn8

fn8 = function(arg, arg2)
	if not guid then
		return false
	end
	local pentathlonRemote = game:GetService("ReplicatedStorage"):FindFirstChild("Remotes") and game:GetService("ReplicatedStorage").Remotes:FindFirstChild("PentathlonRemote")

	if pentathlonRemote then
		if arg2 then
			pentathlonRemote:FireServer(guid, arg, arg2)
		else
			pentathlonRemote:FireServer(guid, arg)
		end

		return true
	end

	return false
end

local fn9

fn9 = function(arg)
	local character = localPlayer.Character
	if not character or not character:FindFirstChild("HumanoidRootPart") then
		return
	end
	local humanoidRootPart = character.HumanoidRootPart
	humanoidRootPart.Velocity = Vector3.zero
	humanoidRootPart.RotVelocity = Vector3.zero
	humanoidRootPart.Anchored = true
	character:PivotTo(arg)
	task.wait()
	humanoidRootPart.Velocity = Vector3.zero
	humanoidRootPart.Anchored = false
end

tbl3.lastTPTime = 0
tbl6.RLGLBox = tbl5.RLGL:Section({ Opened = true, Title = "| Red Light Green Light", Icon = "hand" })

tbl6.RLGLBox:Button({
	Title = "TP To End",
	Callback = function()
		local lastTPTime = tbl3.lastTPTime

		if tick() - lastTPTime < 10 then
			local lastTPTime2 = tbl3.lastTPTime
			fn5(" Cooldown", "Please wait " .. math.ceil(10 - tick() - lastTPTime2) .. "s before teleporting again.")
			return
		end

		if fn4("RedLightGreenLight") then
			fn9(CFrame.new(-45, 1025, 137))
			tbl3.lastTPTime = tick()
		else
			fn5(nil, "Red Light Green Light is not currently running.")
		end
	end,
})

tbl6.RLGLBox:Button({
	Title = "TP To Start",
	Callback = function()
		local lastTPTime = tbl3.lastTPTime

		if tick() - lastTPTime < 10 then
			local lastTPTime2 = tbl3.lastTPTime
			fn5(" Cooldown", "Please wait " .. math.ceil(10 - tick() - lastTPTime2) .. "s before teleporting again.")
			return
		end

		if fn4("RedLightGreenLight") then
			fn9(CFrame.new(-49, 1023, -540))
			tbl3.lastTPTime = tick()
		else
			fn5(nil, "Red Light Green Light is not currently running.")
		end
	end,
})

tbl6.RLGLBox:Button({
	Title = "Remove Injury",
	Callback = function()
		if not fn4("RedLightGreenLight") then
			fn5(nil, "Red Light Green Light is not currently running.")
			return
		end

		if not localPlayer then
			return
		end
		local character = localPlayer.Character
		if not character then
			return
		end
		local humanoid = character:FindFirstChild("Humanoid")
		local humanoidRootPart = character:FindFirstChild("HumanoidRootPart")
		if not (humanoid and humanoidRootPart) then
			return
		end
		local torso = character:FindFirstChild("Torso") or character:FindFirstChild("UpperTorso")
		humanoid.PlatformStand = false
		humanoid:ChangeState(Enum.HumanoidStateType.GettingUp)
		humanoid:SetStateEnabled(Enum.HumanoidStateType.Freefall, true)
		humanoid:SetStateEnabled(Enum.HumanoidStateType.FallingDown, false)
		humanoid:SetStateEnabled(Enum.HumanoidStateType.Jumping, true)

		for _, v3 in pairs({
			Enum.HumanoidStateType.FallingDown,
			Enum.HumanoidStateType.Seated,
			Enum.HumanoidStateType.Swimming,
			Enum.HumanoidStateType.Flying,
			Enum.HumanoidStateType.StrafingNoPhysics,
			Enum.HumanoidStateType.Ragdoll,
		}) do
			humanoid:SetStateEnabled(v3, false)
		end

		for _, child in pairs(humanoidRootPart:GetChildren()) do
			if child:IsA("BallSocketConstraint") or child.Name:match("^CacheAttachment") then
				child:Destroy()
			end
		end

		if torso then
			for _, v3 in pairs({ "Left Hip", "Left Shoulder", "Neck", "Right Hip", "Right Shoulder" }) do
				local v4 = torso:FindFirstChild(v3)

				if v4 and v4:IsA("Motor6D") and not v4.Part0 then
					v4.Part0 = torso
				end
			end
		end

		for _, child in pairs(character:GetChildren()) do
			if child:IsA("BasePart") and child:FindFirstChild("BoneCustom") then
				child.BoneCustom:Destroy()
			end
		end

		for _, v3 in pairs({ "Ragdoll", "Stun", "RotateDisabled", "RagdollWakeupImmunity", "Injured" }) do
			local v4 = character:FindFirstChild(v3)

			if v4 then
				v4:Destroy()
			end
		end

		local effects = Workspace:FindFirstChild("Effects")

		if effects then
			local localRagdolls = effects:FindFirstChild("LocalRagdolls")

			if localRagdolls then
				local v3 = localRagdolls:FindFirstChild(localPlayer.Name)

				if v3 then
					v3:Destroy()
				end
			end
		end

		if character:GetAttribute("Injured") then
			character:SetAttribute("Injured", false)
		end
	end,
})

tbl6.RLGLBox:Button({
	Title = "Anti Crawl",
	Callback = function()
		if not fn4("RedLightGreenLight") then
			fn5(nil, "Red Light Green Light is not currently running.")
			return
		end
		fn5(nil, "Anti Crawl Enabled")

		task.spawn(function()
			while fn4("RedLightGreenLight") do
				local character = localPlayer.Character

				if character and character:FindFirstChild("Crawling") then
					character.Crawling:Destroy()
				end

				task.wait(0.25)
			end
		end)
	end,
})

do
	local function fn10(arg)
		local character = localPlayer.Character

		if character then
			local humanoid = character:FindFirstChild("Humanoid")

			if humanoid then
				humanoid.WalkSpeed = arg and 16 or 0
				humanoid.JumpPower = arg and 50 or 0
			end

			local humanoidRootPart = character:FindFirstChild("HumanoidRootPart")

			if humanoidRootPart and not arg then
				humanoidRootPart.Velocity = Vector3.zero
			end
		end
	end

	local function fn11(arg, arg2, arg3)
		local n = math.min(arg2.X, arg3.X)
		local n2 = math.max(arg2.X, arg3.X)
		local n3 = math.min(arg2.Z, arg3.Z)
		local n4 = math.max(arg2.Z, arg3.Z)
		return arg.X >= n and arg.X <= n2 and arg.Z >= n3 and arg.Z <= n4
	end

	local function fn12()
		local character = localPlayer.Character
		if not character or not character:FindFirstChild("HumanoidRootPart") then
			return false
		end
		local position = character.HumanoidRootPart.Position
		local v3 = fn11(position, Vector3.new(-216, 0, 83), Vector3.new(103, 0, 168))
		local v4 = fn11(position, Vector3.new(103, 0, 168), Vector3.new(116, 0, 82))
		local v5 = fn11(position, Vector3.new(115, 0, -578), Vector3.new(-215, 0, -516))
		return v3 or v4 or v5
	end

	local str2 = "rbxassetid://88400194373338"
	tbl.autoStopEnabled = false
	tbl2.freezeThread = nil
	local flag2 = false

	tbl6.RLGLBox:Toggle({
		Title = "Freeze On Red Light",
		Default = false,
		Callback = function(autoStopEnabled)
			tbl.autoStopEnabled = autoStopEnabled

			if tbl.autoStopEnabled then
				if tbl2.freezeThread then
					return
				end
				tbl2.freezeThread = true

				task.spawn(function()
					while tbl2.freezeThread and tbl.autoStopEnabled do
						if not fn4("RedLightGreenLight") then
							if flag2 then
								fn10(true)
								flag2 = false
							end
						else
							local playerGui = localPlayer:FindFirstChild("PlayerGui")
							local flag3 = false

							if playerGui then
								local impactFrames = playerGui:FindFirstChild("ImpactFrames")
								flag3 = false

								if impactFrames then
									local trafficLightEmpty = impactFrames:FindFirstChild("TrafficLightEmpty")
									trafficLightEmpty = trafficLightEmpty and trafficLightEmpty.Image == str2
									flag3 = false

									if trafficLightEmpty then
										flag3 = true
									end
								end
							end

							if flag3 and not fn12() then
								if not flag2 then
									fn10(false)
									flag2 = true
								end

								local character = localPlayer.Character

								if character then
									local humanoid = character:FindFirstChild("Humanoid")

									if humanoid then
										humanoid.WalkSpeed = 0
										humanoid.JumpPower = 0
									end

									local humanoidRootPart = character:FindFirstChild("HumanoidRootPart")

									if humanoidRootPart then
										humanoidRootPart.Velocity = Vector3.zero
									end
								end
							elseif flag2 then
								fn10(true)
								flag2 = false
							end
						end

						task.wait(0.1)
					end

					tbl2.freezeThread = nil

					if flag2 then
						fn10(true)
						flag2 = false
					end
				end)
			end
		end,
	})
end

tbl.autoTPEndEnabled = false
tbl2.autoTPEndThread = nil

tbl6.RLGLBox:Toggle({
	Title = "Auto TP End Last Second",
	Default = false,
	Callback = function(autoTPEndEnabled)
		tbl.autoTPEndEnabled = autoTPEndEnabled

		if tbl.autoTPEndEnabled then
			if tbl2.autoTPEndThread then
				return
			end
			tbl2.autoTPEndThread = true

			task.spawn(function()
				while tbl2.autoTPEndThread and tbl.autoTPEndEnabled do
					if fn4("RedLightGreenLight") then
						local attribute = workspace:GetAttribute("CurrentGameTime")

						if attribute then
							if attribute <= 3 and attribute > 0 then
								local character = localPlayer.Character
								character = character and character:FindFirstChild("HumanoidRootPart")
								local flag2 = true

								if character then
									local position = character.Position

									local function fn10(arg, arg2, arg3)
										return arg.X >= math.min(arg2.X, arg3.X) and arg.X <= math.max(arg2.X, arg3.X) and arg.Z >= math.min(arg2.Z, arg3.Z) and arg.Z <= math.max(arg2.Z, arg3.Z)
									end

									local flag3 = (fn10(position, Vector3.new(115, 1023, 84), Vector3.new(103, 1023, 168)) or fn10(position, Vector3.new(103, 1023, 168), Vector3.new(-216, 1023, 83))) and math.abs(position.Y - 1023) < 100
									flag2 = true

									if flag3 then
										flag2 = false
									end
								end

								if flag2 then
									fn5(nil, "Last 3 Second Left Teleporting End")
									fn9(CFrame.new(-45, 1025, 137))
								end

								task.wait(5)
							end
						end
					end

					task.wait(1)
				end

				tbl2.autoTPEndThread = nil
			end)
		end
	end,
})

tbl.espRolesEnabled = false
local tbl8
tbl8 = {}
local tbl9
tbl9 = {}
local fn10

do
	local function fn11(arg)
		if not tbl.espRolesEnabled then
			return
		end

		if arg == localPlayer then
			return
		end
		local character = arg.Character
		if not character then
			return
		end

		if tbl8[arg] then
			tbl8[arg]:Destroy()
			tbl8[arg] = nil
		end

		local attribute = arg:GetAttribute("IsHider")
		local attribute2 = arg:GetAttribute("IsHunter")
		if not attribute and not attribute2 then
			return
		end
		local highlight = Instance.new("Highlight")
		highlight.FillTransparency = 0.4
		highlight.OutlineTransparency = 0

		if attribute then
			highlight.FillColor = Color3.fromRGB(50, 255, 50)
			highlight.OutlineColor = Color3.fromRGB(30, 200, 30)
		elseif attribute2 then
			highlight.FillColor = Color3.fromRGB(255, 50, 50)
			highlight.OutlineColor = Color3.fromRGB(200, 30, 30)
		end

		highlight.Adornee = character
		highlight.Parent = character
		tbl8[arg] = highlight
	end

	fn10 = function()
		for _, v3 in pairs(tbl9) do
			if v3 and v3.Connected then
				v3:Disconnect()
			end
		end

		table.clear(tbl9)

		for _, v3 in pairs(tbl8) do
			if v3 and v3.Parent then
				v3:Destroy()
			end
		end

		table.clear(tbl8)
	end

	local function fn12(arg)
		if arg == localPlayer then
			return
		end

		table.insert(tbl9, arg:GetAttributeChangedSignal("IsHider"):Connect(function()
			if tbl.espRolesEnabled then
				fn11(arg)
			end
		end))

		table.insert(tbl9, arg:GetAttributeChangedSignal("IsHunter"):Connect(function()
			if tbl.espRolesEnabled then
				fn11(arg)
			end
		end))

		table.insert(tbl9, arg.CharacterAdded:Connect(function()
			task.wait(0.5)

			if tbl.espRolesEnabled then
				fn11(arg)
			end
		end))

		fn11(arg)
	end

	tbl6.HSTOWBox = tbl5.HSTOW:Section({ Opened = true, Title = "| Hide And Seek", Icon = "search" })

	tbl6.HSTOWBox:Button({
		Title = "Auto Escape",
		Callback = function()
			if not fn4("HideAndSeek") then
				fn5(nil, "Hide And Seek is not active")
				return
			end
			local character = localPlayer.Character

			if character and character:FindFirstChild("HumanoidRootPart") then
				fn9(CFrame.new(199, 54, -88))
				fn5(" Escaped", "Teleported to safe zone")
			end
		end,
	})

	tbl.autoGetKeysEnabled = false
	tbl2.autoGetKeysThread = nil

	tbl6.HSTOWBox:Toggle({
		Title = "Auto Get Missing Keys",
		Default = false,
		Callback = function(autoGetKeysEnabled)
			tbl.autoGetKeysEnabled = autoGetKeysEnabled

			if tbl.autoGetKeysEnabled then
				if tbl2.autoGetKeysThread then
					return
				end
				tbl2.autoGetKeysThread = true

				task.spawn(function()
					local tbl10 = { "Circle", "Square", "Triangle" }

					while tbl.autoGetKeysEnabled and tbl2.autoGetKeysThread do
						if fn4("HideAndSeek") then
							local currentKeys = localPlayer:FindFirstChild("CurrentKeys")

							if currentKeys then
								local tbl11 = {}

								for _, child in ipairs(currentKeys:GetChildren()) do
									tbl11[child.Name] = true
								end

								local tbl12 = {}

								for _, v3 in ipairs(tbl10) do
									if not tbl11[v3] then
										tbl12[v3] = true
									end
								end

								local effects = workspace:FindFirstChild("Effects")

								if effects then
									for _, child in ipairs(effects:GetChildren()) do
										if string.sub(child.Name, 1, 10) == "DroppedKey" then
											if tbl12[string.sub(child.Name, 11)] then
												local character = localPlayer.Character
												character = character and character:FindFirstChild("HumanoidRootPart")

												if character then
													local pivot = child:IsA("Model") and child:GetPivot() or child.CFrame
													local cFrame = character.CFrame
													character.CFrame = pivot
													task.wait(0.1)
													character.CFrame = cFrame
													break
												end
											end
										end
									end
								end
							end
						end

						task.wait(0.1)
					end

					tbl2.autoGetKeysThread = nil
				end)
			else
				tbl2.autoGetKeysThread = nil
			end
		end,
	})

	tbl.tugOfWarAutoPullEnabled = false
	tbl.tugOfWarPullHelperEnabled = false
	tbl2.tugOfWarAutoPullThread = nil
	local flag2 = false

	local function fn13(arg, arg2)
		return math.abs((arg - arg2 + 180) % 360 - 180)
	end

	local function fn14()
		fn6("space")
	end

	local function fn15()
		if flag2 then
			return
		end
		flag2 = true
		local playerGui = localPlayer:FindFirstChild("PlayerGui")
		if not playerGui then
			flag2 = false
			return
		end
		local tugOfWarUIV2 = playerGui:WaitForChild("TugOfWarUIV2", 5)
		if not tugOfWarUIV2 then
			flag2 = false
			return
		end
		local tugofWarRemake = tugOfWarUIV2:FindFirstChild("TugofWarRemake")
		if not tugofWarRemake then
			flag2 = false
			return
		end
		local circleBase = tugofWarRemake:FindFirstChild("CircleBase")
		if not circleBase then
			flag2 = false
			return
		end

		while true do
			if tbl.tugOfWarAutoPullEnabled or tbl.tugOfWarPullHelperEnabled then
				local attribute = nil

				pcall(function()
					attribute = localPlayer:GetAttribute("TugOfWarPhase")
				end)

				if attribute == "QTE" then
					break
				else
					task.wait(0.1)
					continue
				end
			end

			break
		end

		if not (tbl.tugOfWarAutoPullEnabled or tbl.tugOfWarPullHelperEnabled) then
			flag2 = false
			return
		end

		if not circleBase.Visible then
			local now = tick()

			while (tbl.tugOfWarAutoPullEnabled or tbl.tugOfWarPullHelperEnabled) and not circleBase.Visible and tick() - now < 10 do
				task.wait(0.1)
			end
		end

		if not (tbl.tugOfWarAutoPullEnabled or tbl.tugOfWarPullHelperEnabled) then
			flag2 = false
			return
		end
		local arrow = circleBase:FindFirstChild("Arrow")
		if not arrow then
			flag2 = false
			return
		end
		local medium = circleBase:FindFirstChild("Medium")

		if not medium then
			medium = circleBase:FindFirstChild("Small") or circleBase:FindFirstChild("Large")
		end

		if not medium then
			flag2 = false
			return
		end
		local attribute = localPlayer:GetAttribute("TugOfWarStrategy") or "Standard"
		local n

		if attribute == "Stall" then
			n = 14
		else
			n = 18.2
		end

		tbl3.lastPressTime = 0
		local n2 = 0.12
		local flag3 = false
		local connection = nil
		local connection2 = nil

		local function fn16()
			if connection then
				connection:Disconnect()
				connection = nil
			end

			if connection2 then
				connection2:Disconnect()
				connection2 = nil
			end

			flag2 = false
		end

		connection2 = localPlayer.ChildAdded:Connect(function(child)
			if child.Name == "QTEOver" then
				fn16()
			end
		end)

		connection = game:GetService("RunService").RenderStepped:Connect(function()
			if not arrow or not arrow.Parent or not circleBase.Visible then
				fn16()
				return
			end

			if not (tbl.tugOfWarAutoPullEnabled or tbl.tugOfWarPullHelperEnabled) then
				fn16()
				return
			end

			if not fn4("TugOfWar") then
				fn16()
				return
			end
			local rotation = arrow.Rotation % 360
			local flag4 = fn13(medium.Rotation % 360, rotation) <= n

			if tbl.tugOfWarPullHelperEnabled then
				medium.Rotation = rotation
				flag4 = true
			end

			if tbl.tugOfWarAutoPullEnabled then
				if tbl.tugOfWarPullHelperEnabled then
					local lastPressTime = tbl3.lastPressTime

					if tick() - lastPressTime > 0.25 then
						fn14()
						tbl3.lastPressTime = tick()
					end
				else
					local flag5 = flag4 and not flag3

					if flag5 then
						local lastPressTime = tbl3.lastPressTime
						flag5 = tick() - lastPressTime > n2
					end

					if flag5 then
						fn14()
						tbl3.lastPressTime = tick()
					end
				end
			end

			flag3 = flag4
		end)

		task.spawn(function()
			while flag2 and (tbl.tugOfWarAutoPullEnabled or tbl.tugOfWarPullHelperEnabled) and fn4("TugOfWar") do
				task.wait(1)
			end

			fn16()
		end)
	end

	tbl.killHidersEnabled = false
	tbl2.killThread = nil

	local function fn16()
		local character = localPlayer.Character
		if not character then
			return nil
		end
		local backpack = localPlayer:FindFirstChild("Backpack")
		local tool = character:FindFirstChildOfClass("Tool")
		if tool then
			return tool
		end

		if backpack then
			for _, child in pairs(backpack:GetChildren()) do
				if child:IsA("Tool") then
					child.Parent = character
					task.wait(0.1)
					return child
				end
			end
		end

		return nil
	end

	local function fn17()
		local character = localPlayer.Character
		if not character or not character:FindFirstChild("HumanoidRootPart") then
			return nil
		end
		local position = character.HumanoidRootPart.Position
		local huge = math.huge
		local v3 = nil

		for _, player in pairs(Players:GetPlayers()) do
			if player ~= localPlayer and player:GetAttribute("IsHider") then
				local character2 = player.Character

				if character2 then
					local humanoid = character2:FindFirstChild("Humanoid")
					local humanoidRootPart = character2:FindFirstChild("HumanoidRootPart")

					if humanoid and humanoidRootPart and humanoid.Health > 0 then
						local magnitude = (humanoidRootPart.Position - position).Magnitude

						if magnitude < huge then
							huge = magnitude
							v3 = player
						end
					end
				end
			end
		end

		return v3
	end

	tbl6.HSTOWBox:Toggle({
		Title = "Auto Kill Hiders",
		Default = false,
		Callback = function(killHidersEnabled)
			tbl.killHidersEnabled = killHidersEnabled

			if tbl.killHidersEnabled then
				if not localPlayer:GetAttribute("IsHunter") then
					fn5(" Not Hunter", "You are not a Hunter.")
					tbl.killHidersEnabled = false
					return
				end

				tbl2.killThread = nil
				task.wait(0.2)
				tbl2.killThread = true

				task.spawn(function()
					local cFrame = localPlayer.Character and localPlayer.Character:FindFirstChild("HumanoidRootPart") and localPlayer.Character.HumanoidRootPart.CFrame
					local flag3 = false

					while true do
						if tbl2.killThread and tbl.killHidersEnabled then
							if not fn4("HideAndSeek") then
								task.wait(1)
								task.wait(0.1)
								continue
							elseif not localPlayer:GetAttribute("IsHunter") then
								tbl.killHidersEnabled = false
								tbl2.killThread = nil
								break
							else
								local v3 = fn17()

								if not v3 then
									if cFrame and not flag3 then
										local character = localPlayer.Character
										character = character and character:FindFirstChild("HumanoidRootPart")

										if character then
											character.CFrame = cFrame
											flag3 = true
										end
									end

									task.wait(0.5)
								else
									local character = v3.Character
									local humanoid = character and character:FindFirstChild("Humanoid")
									local humanoidRootPart = character and character:FindFirstChild("HumanoidRootPart")

									while true do
										character = tbl2.killThread and tbl.killHidersEnabled and character and humanoid and humanoidRootPart
										local flag4 = character and humanoid.Health > 0
										flag3 = false

										if flag4 then
											if fn4("HideAndSeek") then
												local character2 = localPlayer.Character
												local humanoidRootPart2 = character2 and character2:FindFirstChild("HumanoidRootPart")
												local humanoid2 = character2 and character2:FindFirstChild("Humanoid")

												if not (not humanoidRootPart2 or not humanoid2) then
													local n = 0

													pcall(function()
														n = game:GetService("Stats").Network.ServerStatsItem["Data Ping"]:GetValue() / 1000
													end)

													humanoidRootPart2.CFrame = (humanoidRootPart.CFrame + humanoidRootPart.AssemblyLinearVelocity * n) * CFrame.new(0, 0, 3)
													humanoidRootPart2.AssemblyLinearVelocity = Vector3.zero
													local v4 = fn16()

													if v4 then
														if v4.Parent ~= character2 then
															v4.Parent = character2
														end

														pcall(function()
															v4:Activate()
														end)
													end

													task.wait(0.05)
													character = v3.Character
													humanoid = character and character:FindFirstChild("Humanoid")
													humanoidRootPart = character and character:FindFirstChild("HumanoidRootPart")
													continue
												end
											end
										end

										break
									end
								end

								task.wait(0.1)
								continue
							end
						end

						break
					end

					tbl2.killThread = nil
				end)
			else
				tbl2.killThread = nil
			end
		end,
	})

	tbl.infiniteStaminaEnabled = false
	tbl2.infiniteStaminaThread = nil

	tbl6.HSTOWBox:Toggle({
		Title = "Infinite Stamina",
		Default = false,
		Callback = function(infiniteStaminaEnabled)
			tbl.infiniteStaminaEnabled = infiniteStaminaEnabled

			if tbl.infiniteStaminaEnabled then
				if tbl2.infiniteStaminaThread then
					return
				end

				tbl2.infiniteStaminaThread = game:GetService("RunService").RenderStepped:Connect(function()
					if fn4("HideAndSeek") then
						local character = localPlayer.Character

						if character then
							local staminaVal = character:FindFirstChild("StaminaVal")

							if staminaVal and staminaVal:IsA("NumberValue") then
								staminaVal.Value = 100
							end
						end
					end
				end)
			elseif tbl2.infiniteStaminaThread then
				tbl2.infiniteStaminaThread:Disconnect()
				tbl2.infiniteStaminaThread = nil
			end
		end,
	})

	tbl.balloonESPEnabled = false
	tbl.autoPopBalloonsEnabled = false
	local tbl10 = {}
	local tbl11 = {}

	local function fn18()
		if fn4("RedLightGreenLight") then
			local playerGui = localPlayer:FindFirstChild("PlayerGui")

			if playerGui then
				local impactFrames = playerGui:FindFirstChild("ImpactFrames")

				if impactFrames then
					local trafficLightEmpty = impactFrames:FindFirstChild("TrafficLightEmpty")
					if trafficLightEmpty and trafficLightEmpty.Image == "rbxassetid://88400194373338" then
						return true
					end
				end
			end
		end

		return false
	end

	local function fn19(arg)
		if fn18() then
			return
		end
		local character = localPlayer.Character
		character = character and character:FindFirstChild("HumanoidRootPart")
		if not character then
			return
		end
		local parent = arg.Parent
		if not parent then
			return
		end
		local cFrame = character.CFrame
		character.CFrame = parent.CFrame
		task.wait(0.2)

		pcall(function()
			if fireproximityprompt then
				fireproximityprompt(arg, 1)
				fireproximityprompt(arg, 0)
			end
		end)

		local parent2 = parent.Parent
		local n = 0

		while true do
			if parent2 and parent2.Parent and n < 2 then
				if not fn18() then
					task.wait(0.1)
					n += 0.1
					continue
				end
			end

			break
		end

		local character2 = localPlayer.Character
		character2 = character2 and character2:FindFirstChild("HumanoidRootPart")

		if character2 then
			character2.CFrame = cFrame
		end
	end

	local function fn20(arg)
		local parent = arg.Parent
		if not parent then
			return
		end
		local parent2 = parent.Parent
		if not parent2 then
			return
		end

		if tbl11[arg] then
			return
		end
		local highlight = Instance.new("Highlight")
		highlight.Name = "BalloonHighlight"
		highlight.FillColor = Color3.fromRGB(255, 105, 180)
		highlight.FillTransparency = 0.5
		highlight.OutlineColor = Color3.fromRGB(255, 255, 255)
		highlight.DepthMode = Enum.HighlightDepthMode.AlwaysOnTop
		highlight.Parent = parent2
		tbl11[arg] = highlight
	end

	local function fn21(arg)
		if tbl11[arg] then
			tbl11[arg]:Destroy()
			tbl11[arg] = nil
		end
	end

	local function fn22(descendant)
		if descendant:IsA("ProximityPrompt") and descendant.Name == "BalloonProximityPrompt" then
			tbl10[descendant] = true

			if tbl.balloonESPEnabled then
				fn20(descendant)
			end
		end
	end

	for _, descendant in pairs(workspace:GetDescendants()) do
		fn22(descendant)
	end

	workspace.DescendantAdded:Connect(fn22)

	workspace.DescendantRemoving:Connect(function(descendant)
		if tbl10[descendant] then
			tbl10[descendant] = nil
			fn21(descendant)
		end
	end)

	task.spawn(function()
		while true do
			task.wait(0.5)

			if tbl.autoPopBalloonsEnabled and fn4("HideAndSeek") then
				for k in pairs(tbl10) do
					if fn18() then
						break
					end

					if k and k.Parent and k.Enabled then
						local character = localPlayer.Character
						character = character and character:FindFirstChild("HumanoidRootPart")
						local parent = k.Parent

						if character and parent then
							if not (math.abs(character.Position.Y - parent.Position.Y) <= 20) then
								continue
							end
							fn19(k)
							continue
						end

						continue
					end

					if not k or not k.Parent then
						tbl10[k] = nil
						fn21(k)
					end
				end
			end
		end
	end)

	tbl6.GameToolsBox = tbl5.Tools:Section({ Opened = true, Title = "| Game Tools", Icon = "hammer" })

	tbl6.HSTOWBox:Toggle({
		Title = "Balloon Pop Farm",
		Default = false,
		Callback = function(autoPopBalloonsEnabled)
			tbl.autoPopBalloonsEnabled = autoPopBalloonsEnabled
		end,
	})

	tbl.hideAndSeekAutoQTEEnabled = false
	tbl2.hideAndSeekQTEThread = nil

	tbl6.HSTOWBox:Toggle({
		Title = "Auto QTE Event",
		Default = false,
		Callback = function(hideAndSeekAutoQTEEnabled)
			tbl.hideAndSeekAutoQTEEnabled = hideAndSeekAutoQTEEnabled

			if tbl.hideAndSeekAutoQTEEnabled and not tbl2.hideAndSeekQTEThread then
				tbl2.hideAndSeekQTEThread = task.spawn(function()
					local tbl12 = {}

					while tbl.hideAndSeekAutoQTEEnabled do
						if fn4("HideAndSeek") then
							local v3 = fn7()

							if v3 and v3.ActiveButtons then
								for k, activeButton in pairs(v3.ActiveButtons) do
									activeButton = not tbl12[k] and activeButton

									if activeButton then
										tbl12[k] = true

										if tbl.hideAndSeekAutoQTEEnabled and fn4("HideAndSeek") and v3.ActiveButtons and v3.ActiveButtons[k] then
											pcall(function()
												v3.Pressed(false, v3.ActiveButtons[k])
											end)
										end
									end
								end

								for k in pairs(tbl12) do
									if not v3.ActiveButtons[k] then
										tbl12[k] = nil
									end
								end
							end
						else
							table.clear(tbl12)
						end

						task.wait()
					end

					tbl2.hideAndSeekQTEThread = nil
				end)
			end
		end,
	})

	tbl6.HSTOWBox:Toggle({
		Title = "Anti Spike",
		Default = false,
		Callback = function(antiSpikeEnabled)
			_G.AntiSpikeEnabled = antiSpikeEnabled

			if antiSpikeEnabled then
				if not _G.AntiSpikeThread then
					_G.AntiSpikeThread = true

					task.spawn(function()
						_G.CreatedSpikePlatforms = _G.CreatedSpikePlatforms or {}

						local function fn23(arg)
							if not arg or not arg.Parent or arg.Name == "SafeSpikePlatform" then
								return
							end
							local v3 = string.lower(arg.Name)

							if string.find(v3, "spike") or string.find(v3, "kill") or string.find(v3, "trap") or string.find(v3, "hazard") then
								if _G.CreatedSpikePlatforms[arg] then
									return
								end

								local function fn24(arg2, arg3)
									local part = Instance.new("Part")
									part.Name = "SafeSpikePlatform"
									part.Size = Vector3.new(arg3.X + 1, 0.5, arg3.Z + 1)
									part.CFrame = arg2 * CFrame.new(0, arg3.Y / 2 + 2.5, 0)
									part.Anchored = true
									part.CanCollide = true
									part.CanTouch = false
									part.Transparency = 1
									part.Material = Enum.Material.SmoothPlastic
									part.Parent = workspace
									_G.CreatedSpikePlatforms[arg] = part
									local connection = nil

									connection = arg.Destroying:Connect(function()
										if part and part.Parent then
											part:Destroy()
										end

										_G.CreatedSpikePlatforms[arg] = nil

										if connection then
											connection:Disconnect()
										end
									end)
								end

								if arg:IsA("BasePart") then
									fn24(arg.CFrame, arg.Size)
								elseif arg:IsA("Model") then
									local boundingBox, v4 = arg:GetBoundingBox()

									if v4.Magnitude > 0 then
										fn24(boundingBox, v4)
									end
								end
							end
						end

						local function fn24()
							local hideAndSeekMap = workspace:FindFirstChild("HideAndSeekMap") or workspace
							local n = 0

							for _, descendant in ipairs(hideAndSeekMap:GetDescendants()) do
								if _G.AntiSpikeThread then
									fn23(descendant)
									n += 1

									if n % 500 == 0 then
										task.wait()
									end

									continue
								end

								break
							end
						end

						local connection = workspace.DescendantAdded:Connect(function(descendant)
							if _G.AntiSpikeEnabled and fn4("HideAndSeek") then
								fn23(descendant)
							end
						end)

						local flag3 = false

						while _G.AntiSpikeThread do
							local HideAndSeek = _G.AntiSpikeEnabled and fn4("HideAndSeek")

							if HideAndSeek and not flag3 then
								fn24()
							else
								flag3 = not HideAndSeek and flag3

								if flag3 then
									if _G.CreatedSpikePlatforms then
										for _, createdSpikePlatform in pairs(_G.CreatedSpikePlatforms) do
											if createdSpikePlatform and createdSpikePlatform.Parent then
												createdSpikePlatform:Destroy()
											end
										end

										table.clear(_G.CreatedSpikePlatforms)
									end
								end
							end

							task.wait(1)
							flag3 = HideAndSeek
						end

						connection:Disconnect()
					end)
				end
			else
				_G.AntiSpikeThread = false

				if _G.CreatedSpikePlatforms then
					for _, createdSpikePlatform in pairs(_G.CreatedSpikePlatforms) do
						if createdSpikePlatform and createdSpikePlatform.Parent then
							createdSpikePlatform:Destroy()
						end
					end

					table.clear(_G.CreatedSpikePlatforms)
				end
			end
		end,
	})

	tbl.autoDodgeEnabled = false
	local tbl12 = {}

	local tbl13 = {
		"105341857343164",
		"88451099342711",
		"79649041083405",
		"73242877658272",
		"114928327045353",
		"135690448001690",
		"103355259844069",
		"125906547773381",
		"121147456137931",
		"96924216250322",
		"116839849594540",
		"104041807075625",
		"83057176809194",
		"103318207627541",
		"121473077508383",
		"94215646393565",
		"81533666958052",
	}

	local function fn23()
		for _, v3 in ipairs(tbl12) do
			if v3 then
				v3:Disconnect()
			end
		end

		table.clear(tbl12)
	end

	local n = 0

	local function fn24(arg, arg2)
		if not tbl.autoDodgeEnabled or not fn4("HideAndSeek") then
			return
		end

		if tick() - n < 0.8 then
			return
		end

		if not arg.Animation then
			return
		end
		local animationId = arg.Animation.AnimationId
		local flag3 = false

		for _, v3 in ipairs(tbl13) do
			if string.find(animationId, v3, 1, true) then
				flag3 = true
				break
			end
		end

		if flag3 then
			local character = localPlayer.Character
			local humanoidRootPart = character and character:FindFirstChild("HumanoidRootPart")

			if humanoidRootPart and arg2 then
				local magnitude = (humanoidRootPart.Position - arg2.Position).Magnitude
				local magnitude2 = (humanoidRootPart.Position + humanoidRootPart.Velocity * 0.7 - arg2.Position + arg2.Velocity * 0.7).Magnitude
				local n2 = magnitude - magnitude2
				local v3 = arg2.CFrame.LookVector:Dot((humanoidRootPart.Position - arg2.Position).Unit)
				local humanoid = arg2.Parent and arg2.Parent:FindFirstChild("Humanoid")
				local n3 = 10

				if humanoid then
					local animator = humanoid:FindFirstChild("Animator")

					if animator then
						for _, v4 in ipairs(animator:GetPlayingAnimationTracks()) do
							if v4.Animation then
								local animationId2 = v4.Animation.AnimationId

								if string.find(animationId2, "76367328603905") then
									n3 = 20
									break
								elseif string.find(animationId2, "71214385249268") then
									n3 = 14
									break
								end
							end
						end
					end
				end

				if math.abs(humanoidRootPart.Position.Y - arg2.Position.Y) > 12 then
					return
				end
				local flag4 = false

				if magnitude <= 10 then
					flag4 = true
				end

				if not flag4 and magnitude2 <= n3 and n2 > -3 then
					flag4 = true
				end

				if not flag4 and magnitude <= 20 and n2 > 2 then
					flag4 = true
				end

				if flag4 then
					if n2 < -8 and magnitude > 8 then
						flag4 = false
					end

					if magnitude > 14 and v3 < -0.4 then
						flag4 = false
					end
				end

				if not flag4 then
					return
				end
				local raycastParams = RaycastParams.new()
				raycastParams.FilterDescendantsInstances = { character, arg2.Parent }
				raycastParams.FilterType = Enum.RaycastFilterType.Exclude
				local hit = Workspace:Raycast(humanoidRootPart.Position, arg2.Position - humanoidRootPart.Position, raycastParams)
				hit = hit and hit.Instance
				local flag5 = true

				if hit then
					flag5 = false
				end

				if flag4 and flag5 then
					local dodge = localPlayer.Backpack:FindFirstChild("DODGE!") or character:FindFirstChild("DODGE!")

					if dodge then
						pcall(function()
							local tbl14 = { dodge }
							local tbl15 = { buffer.create(0), tbl14 }
							game:GetService("ReplicatedStorage"):WaitForChild("Remotes"):WaitForChild("UsedTool"):FireServer(unpack(tbl15))
							local playerGui = localPlayer:FindFirstChild("PlayerGui")
							local str2 = nil

							if playerGui then
								str2 = nil

								for _, descendant in ipairs(playerGui:GetDescendants()) do
									if (descendant:IsA("TextLabel") or descendant:IsA("TextButton")) and descendant.Text == "DODGE!" then
										if descendant.Parent then
											for _, child in ipairs(descendant.Parent:GetChildren()) do
												if child ~= descendant and (child:IsA("TextLabel") or child:IsA("TextButton")) then
													local v4 = string.upper(tostring(child.Text))
													if tonumber(v4) or v4 == "E" or v4 == "T" or v4 == "Y" then
														str2 = tostring(child.Text)
														break
													end
												end
											end
										end

										if not str2 then
											continue
										end
									else
										continue
									end

									break
								end
							end

							if not str2 then
								local backpack = localPlayer:FindFirstChild("Backpack")

								if backpack then
									local n4 = 1

									for _, child in ipairs(backpack:GetChildren()) do
										if child:IsA("Tool") then
											if child.Name == "DODGE!" then
												str2 = tostring(n4)
												break
											else
												n4 += 1
											end
										end
									end
								end
							end

							if str2 then
								n = tick()
								fn6(tostring(str2))
								task.wait(0.05)
								fn6(tostring(str2))
							end
						end)
					end
				end
			end
		end
	end

	local function fn25(player)
		if player == localPlayer then
			return
		end

		local function fn26(character)
			task.wait(0.5)
			if not player:GetAttribute("IsHunter") then
				return
			end
			local humanoid = character:FindFirstChild("Humanoid")
			local humanoidRootPart = character:FindFirstChild("HumanoidRootPart")

			if humanoid and humanoidRootPart then
				local animator = humanoid:FindFirstChild("Animator")

				if animator then
					local connection = animator.AnimationPlayed:Connect(function(arg)
						fn24(arg, humanoidRootPart)
					end)

					table.insert(tbl12, connection)
				end
			end
		end

		if player.Character then
			task.spawn(fn26, player.Character)
		end

		table.insert(tbl12, player.CharacterAdded:Connect(fn26))

		table.insert(tbl12, player:GetAttributeChangedSignal("IsHunter"):Connect(function()
			if player.Character then
				task.spawn(fn26, player.Character)
			end
		end))
	end

	tbl6.HSTOWBox:Toggle({
		Title = "Auto Dodge",
		Default = false,
		Callback = function(autoDodgeEnabled)
			tbl.autoDodgeEnabled = autoDodgeEnabled
			fn23()

			if tbl.autoDodgeEnabled then
				for _, player in ipairs(Players:GetPlayers()) do
					fn25(player)
				end

				table.insert(tbl12, Players.PlayerAdded:Connect(fn25))
			end
		end,
	})

	tbl6.HSTOWBox:Toggle({
		Title = "ESP Roles",
		Default = false,
		Callback = function(espRolesEnabled)
			tbl.espRolesEnabled = espRolesEnabled

			if tbl.espRolesEnabled then
				fn10()

				for _, player in pairs(Players:GetPlayers()) do
					fn12(player)
				end

				table.insert(tbl9, Players.PlayerAdded:Connect(function(player)
					task.wait(1)

					if tbl.espRolesEnabled then
						fn12(player)
					end
				end))

				table.insert(tbl9, Players.PlayerRemoving:Connect(function(player)
					if tbl8[player] then
						tbl8[player]:Destroy()
						tbl8[player] = nil
					end
				end))
			else
				fn10()
			end
		end,
	})

	tbl.espExitDoorsEnabled = false
	tbl2.espExitDoorsThread = nil
	local tbl14 = {}

	local function fn26()
		for _, v3 in pairs(tbl14) do
			if v3 then
				v3:Destroy()
			end
		end

		table.clear(tbl14)
	end

	tbl6.HSTOWBox:Toggle({
		Title = "ESP Exit Doors",
		Default = false,
		Callback = function(espExitDoorsEnabled)
			tbl.espExitDoorsEnabled = espExitDoorsEnabled

			if tbl.espExitDoorsEnabled then
				if tbl2.espExitDoorsThread then
					return
				end
				tbl2.espExitDoorsThread = true

				task.spawn(function()
					while tbl.espExitDoorsEnabled and tbl2.espExitDoorsThread do
						if fn4("HideAndSeek") then
							local hideAndSeekMap = workspace:FindFirstChild("HideAndSeekMap")
							hideAndSeekMap = hideAndSeekMap and hideAndSeekMap:FindFirstChild("NEWFIXEDDOORS")
							hideAndSeekMap = hideAndSeekMap and hideAndSeekMap:FindFirstChild("Floor1")
							hideAndSeekMap = hideAndSeekMap and hideAndSeekMap:FindFirstChild("EXITDOORS")

							if hideAndSeekMap then
								for _, child in ipairs(hideAndSeekMap:GetChildren()) do
									if child.Name == "EXITDOOR" and not child:FindFirstChild("DoorESP") then
										local highlight = Instance.new("Highlight")
										highlight.Name = "DoorESP"
										highlight.FillColor = Color3.new(1, 0, 0)
										highlight.OutlineColor = Color3.new(1, 0, 0)
										highlight.FillTransparency = 0.5
										highlight.OutlineTransparency = 0
										highlight.Parent = child
										table.insert(tbl14, highlight)
									end
								end
							end
						else
							fn26()
						end

						task.wait(1.5)
					end

					fn26()
					tbl2.espExitDoorsThread = nil
				end)
			else
				fn26()
				tbl2.espExitDoorsThread = nil
			end
		end,
	})

	tbl.espKeysEnabled = false
	tbl2.espKeysThread = nil
	local tbl15 = {}

	local function fn27()
		for _, v3 in pairs(tbl15) do
			if v3 then
				v3:Destroy()
			end
		end

		table.clear(tbl15)
	end

	tbl6.HSTOWBox:Toggle({
		Title = "ESP Keys",
		Default = false,
		Callback = function(espKeysEnabled)
			tbl.espKeysEnabled = espKeysEnabled

			if tbl.espKeysEnabled then
				if tbl2.espKeysThread then
					return
				end
				tbl2.espKeysThread = true

				task.spawn(function()
					while tbl.espKeysEnabled and tbl2.espKeysThread do
						if fn4("HideAndSeek") then
							local effects = workspace:FindFirstChild("Effects")

							if effects then
								for _, child in ipairs(effects:GetChildren()) do
									if string.sub(child.Name, 1, 10) == "DroppedKey" and not child:FindFirstChild("KeyESP") then
										local str2 = string.sub(child.Name, 11)
										local text = "Key"

										if str2 ~= "" then
											text = "Key " .. str2
										end

										local billboardGui = Instance.new("BillboardGui")
										billboardGui.Name = "KeyESP"
										billboardGui.AlwaysOnTop = true
										billboardGui.Size = UDim2.new(0, 100, 0, 30)
										billboardGui.StudsOffset = Vector3.new(0, 1.5, 0)
										local textLabel = Instance.new("TextLabel")
										textLabel.Size = UDim2.new(1, 0, 1, 0)
										textLabel.BackgroundTransparency = 1
										textLabel.Text = text
										textLabel.TextColor3 = Color3.new(1, 1, 0)
										textLabel.TextStrokeTransparency = 0
										textLabel.TextSize = 14
										textLabel.Font = Enum.Font.GothamBold
										textLabel.Parent = billboardGui
										billboardGui.Parent = child
										table.insert(tbl15, billboardGui)
									end
								end
							end
						else
							fn27()
						end

						task.wait(1.5)
					end

					fn27()
					tbl2.espKeysThread = nil
				end)
			else
				fn27()
				tbl2.espKeysThread = nil
			end
		end,
	})

	tbl6.HSTOWBox:Space()

	local function fn28()
		if tbl.tugOfWarAutoPullEnabled or tbl.tugOfWarPullHelperEnabled then
			if tbl2.tugOfWarAutoPullThread then
				return
			end
			tbl2.tugOfWarAutoPullThread = true

			task.spawn(function()
				while tbl.tugOfWarAutoPullEnabled or tbl.tugOfWarPullHelperEnabled do
					if fn4("TugOfWar") then
						pcall(fn15)
					end

					task.wait(1)
				end

				tbl2.tugOfWarAutoPullThread = nil
			end)
		else
			tbl2.tugOfWarAutoPullThread = nil
		end
	end

	tbl6.TugBox = tbl5.HSTOW:Section({ Opened = true, Title = "| Tug Of War", Icon = "anchor" })

	tbl6.TugBox:Toggle({
		Title = "Auto Pull",
		Default = false,
		Callback = function(tugOfWarAutoPullEnabled)
			tbl.tugOfWarAutoPullEnabled = tugOfWarAutoPullEnabled
			fn28()
		end,
	})

	tbl6.TugBox:Toggle({
		Title = "Pull Helper",
		Default = false,
		Callback = function(tugOfWarPullHelperEnabled)
			tbl.tugOfWarPullHelperEnabled = tugOfWarPullHelperEnabled
			fn28()
		end,
	})
end

tbl.autoQTEEnabled = false

do
	local thread = nil
	tbl6.MingleBox = tbl5.Mingle:Section({ Opened = true, Title = "| Mingle", Icon = "users" })
	local connection = nil
	local connection2 = nil

	local function fn11(arg)
		local mingleMap = workspace:FindFirstChild("MingleMap")
		mingleMap = mingleMap and mingleMap:FindFirstChild("AllMingleDoors")
		if not mingleMap then
			return
		end

		for _, child in pairs(mingleMap:GetChildren()) do
			local union = child:FindFirstChild("Union")

			if union then
				union.CanCollide = not arg
				union.Transparency = arg and 0.4 or 0
			end

			local doorHandle = child:FindFirstChild("DoorHandle")

			if doorHandle then
				doorHandle.CanCollide = not arg
			end

			local doorHandleOtherSide = child:FindFirstChild("DoorHandleOtherSide")

			if doorHandleOtherSide then
				doorHandleOtherSide.CanCollide = not arg
			end
		end
	end

	tbl6.MingleBox:Toggle({
		Title = "Noclip Doors",
		Default = false,
		Callback = function(arg)
			if connection then
				pcall(function()
					connection:Disconnect()
				end)

				connection = nil
			end

			if connection2 then
				pcall(function()
					connection2:Disconnect()
				end)

				connection2 = nil
			end

			if arg then
				if fn4("Mingle") then
					fn11(true)
				end

				connection2 = localPlayer.CharacterAdded:Connect(function()
					task.wait(0.3)

					if fn4("Mingle") then
						fn11(true)
					end
				end)

				local n = 0

				connection = RunService.Heartbeat:Connect(function()
					if not fn4("Mingle") then
						return
					end
					local now = tick()
					if now - n < 1 then
						return
					end
					n = now
					fn11(true)
				end)
			else
				fn11(false)
			end
		end,
	})

	local connection3 = nil
	local flag2 = false

	local function fn12()
		local character = localPlayer.Character
		character = character and character:FindFirstChild("HumanoidRootPart")
		local mingleMap = workspace:FindFirstChild("MingleMap")
		mingleMap = mingleMap and mingleMap:FindFirstChild("AllMingleDoors")
		if not character or not mingleMap then
			return nil
		end
		local position = character.Position

		for _, child in pairs(mingleMap:GetChildren()) do
			local insideRoomRayCheck = child:FindFirstChild("InsideRoomRayCheck")

			if insideRoomRayCheck then
				local v3 = insideRoomRayCheck.CFrame:PointToObjectSpace(position)
				if math.abs(v3.X) <= 10 and math.abs(v3.Z) <= 12 and math.abs(v3.Y) <= 10 then
					return child
				end
			end
		end

		return nil
	end

	local function fn13(arg)
		if not arg or flag2 then
			return
		end
		flag2 = true
		local doorHandleOtherSide = arg:FindFirstChild("DoorHandleOtherSide") or arg:FindFirstChild("DoorHandle")
		local closeDoorPrompt = doorHandleOtherSide and doorHandleOtherSide:FindFirstChild("CloseDoorPrompt")

		if closeDoorPrompt and fireproximityprompt then
			pcall(function()
				closeDoorPrompt.HoldDuration = 0
				closeDoorPrompt.RequiresLineOfSight = false
				closeDoorPrompt.MaxActivationDistance = 9999
				fireproximityprompt(closeDoorPrompt, 0)
			end)
		end

		local openOrCloseBD = arg:FindFirstChild("OpenOrCloseBD")

		if openOrCloseBD and openOrCloseBD:IsA("BindableEvent") then
			pcall(function()
				openOrCloseBD:Fire("Close")
			end)
		end

		task.delay(4, function()
			flag2 = false
		end)
	end

	tbl6.MingleBox:Toggle({
		Title = "Auto Close Door",
		Default = false,
		Callback = function(arg)
			if connection3 then
				pcall(function()
					connection3:Disconnect()
				end)

				connection3 = nil
			end

			flag2 = false

			if arg then
				local n = 0

				connection3 = RunService.Heartbeat:Connect(function()
					if not fn4("Mingle") then
						return
					end
					local now = tick()
					if now - n < 0.2 then
						return
					end
					n = now
					local playerGui = localPlayer:FindFirstChild("PlayerGui")
					playerGui = playerGui and playerGui:FindFirstChild("OtherUIHolder")
					playerGui = playerGui and playerGui:FindFirstChild("Mingle")

					if playerGui and playerGui.Visible then
						local playersNeeded = playerGui:FindFirstChild("PlayersNeeded")

						if playersNeeded and playersNeeded.Text ~= "" then
							if string.find(string.lower(playersNeeded.Text), "safe") then
								local v3 = fn12()

								if v3 then
									fn13(v3)
								end
							end
						end
					end
				end)
			end
		end,
	})

	tbl6.MingleBox:Toggle({
		Title = "Auto QTE Event",
		Default = false,
		Callback = function(autoQTEEnabled)
			tbl.autoQTEEnabled = autoQTEEnabled

			if tbl.autoQTEEnabled and not thread then
				thread = task.spawn(function()
					local tbl10 = {}

					while tbl.autoQTEEnabled do
						if fn4("Mingle") then
							local v3 = fn7()

							if v3 and v3.ActiveButtons then
								for k, activeButton in pairs(v3.ActiveButtons) do
									activeButton = not tbl10[k] and activeButton

									if activeButton then
										tbl10[k] = true

										if tbl.autoQTEEnabled and fn4("Mingle") and v3.ActiveButtons and v3.ActiveButtons[k] then
											pcall(function()
												v3.Pressed(false, v3.ActiveButtons[k])
											end)
										end
									end
								end

								for k in pairs(tbl10) do
									if not v3.ActiveButtons[k] then
										tbl10[k] = nil
									end
								end
							end
						else
							table.clear(tbl10)
						end

						task.wait()
					end

					thread = nil
				end)
			end
		end,
	})
end

tbl.antiChokeEnabled = false

do
	local tbl10 = {}

	local function fn11()
		local playerGui = localPlayer:FindFirstChild("PlayerGui")
		if not playerGui then
			return false
		end
		local otherUIHolder = playerGui:FindFirstChild("OtherUIHolder")
		if not otherUIHolder then
			return false
		end
		local mingle = otherUIHolder:FindFirstChild("Mingle")
		if not mingle then
			return false
		end
		local playersInRoom = mingle:FindFirstChild("PlayersInRoom")

		if playersInRoom and playersInRoom:IsA("TextLabel") then
			local v3, v4 = string.match(playersInRoom.Text, "(%d+)%/(%d+)")
			if v3 and v4 then
				return tonumber(v3) > tonumber(v4)
			end
		end

		return false
	end

	local function fn12(arg)
		for _, v3 in pairs(tbl10) do
			if v3 then
				v3:Disconnect()
			end
		end

		table.clear(tbl10)
		local humanoid = arg:WaitForChild("Humanoid", 5)
		if not humanoid then
			return
		end
		local animator = humanoid:WaitForChild("Animator", 5)
		if not animator then
			return
		end

		table.insert(tbl10, animator.AnimationPlayed:Connect(function(arg2)
			if tbl.antiChokeEnabled and fn4("Mingle") then
				if string.find(arg2.Animation and arg2.Animation.AnimationId or "", "71318091779666") then
					if fn11() then
						local humanoidRootPart = arg:FindFirstChild("HumanoidRootPart")

						if humanoidRootPart then
							local cFrame = humanoidRootPart.CFrame
							local flag2 = false
							local flag3 = false
							local connection = nil

							connection = arg2.Stopped:Connect(function()
								flag2 = true

								if flag3 and humanoidRootPart then
									humanoidRootPart.CFrame = cFrame
									fn5(" Auto Kick", "Choke Finished Teleporting Back")
								end

								if connection then
									connection:Disconnect()
								end
							end)

							if not flag2 and humanoidRootPart then
								flag3 = true
								humanoidRootPart.CFrame = CFrame.new(199, 54, -88)
								fn5(" Grab Teleport", "Teleported away from the grab")
							end
						end
					end
				end
			end
		end))
	end

	tbl6.MingleBox:Toggle({
		Title = "Grab Teleport",
		Default = false,
		Callback = function(antiChokeEnabled)
			tbl.antiChokeEnabled = antiChokeEnabled

			if tbl.antiChokeEnabled then
				if localPlayer.Character then
					fn12(localPlayer.Character)
				end
			else
				for _, v3 in pairs(tbl10) do
					if v3 then
						v3:Disconnect()
					end
				end

				table.clear(tbl10)
			end
		end,
	})

	localPlayer.CharacterAdded:Connect(function(character)
		if tbl.antiChokeEnabled then
			fn12(character)
		end
	end)
end

tbl.mingleAntiSlowEnabled = false
local connection = nil

tbl6.MingleBox:Toggle({
	Title = "Anti Slow",
	Default = false,
	Callback = function(mingleAntiSlowEnabled)
		tbl.mingleAntiSlowEnabled = mingleAntiSlowEnabled

		if tbl.mingleAntiSlowEnabled then
			if connection then
				return
			end
			local tbl10 = { "Freeze", "Slowed", "Action", "LightAction", "NoAttack" }
			local tbl11 = { "Stun", "Freeze", "Slowed", "Action", "Ragdoll" }

			connection = game:GetService("RunService").Heartbeat:Connect(function()
				if not fn4("Mingle") then
					return
				end

				if shared.IsInCutscene then
					shared.IsInCutscene = nil
				end

				pcall(function()
					local playerScripts = localPlayer:FindFirstChild("PlayerScripts")

					if playerScripts then
						local playerModule = playerScripts:FindFirstChild("PlayerModule")

						if playerModule then
							local controls = require(playerModule):GetControls()

							if controls and controls.Enable then
								controls:Enable(true)
							end
						end
					end
				end)

				local character = localPlayer.Character
				if not character then
					return
				end
				local humanoid = character:FindFirstChildOfClass("Humanoid")
				local humanoidRootPart = character:FindFirstChild("HumanoidRootPart")

				for _, v3 in ipairs(tbl10) do
					if character:GetAttribute(v3) ~= nil then
						character:SetAttribute(v3, nil)
					end

					if humanoid and humanoid:GetAttribute(v3) ~= nil then
						humanoid:SetAttribute(v3, nil)
					end
				end

				if humanoidRootPart and humanoidRootPart.Anchored then
					humanoidRootPart.Anchored = false
				end

				if humanoid then
					local StarterPlayer = game:GetService("StarterPlayer")
					local characterWalkSpeed = StarterPlayer.CharacterWalkSpeed or 16
					local characterJumpPower = StarterPlayer.CharacterJumpPower or 50

					if humanoid.WalkSpeed < characterWalkSpeed then
						humanoid.WalkSpeed = characterWalkSpeed
					end

					if humanoid.JumpPower < characterJumpPower then
						humanoid.JumpPower = characterJumpPower
					end

					if humanoid.PlatformStand then
						humanoid.PlatformStand = false
					end
				end

				for _, v3 in ipairs(tbl11) do
					local v4 = character:FindFirstChild(v3)

					if v4 then
						v4:Destroy()
					end
				end
			end)
		elseif connection then
			connection:Disconnect()
			connection = nil
		end
	end,
})

tbl6.MingleBox:Toggle({
	Title = "LG Power Hold",
	Default = false,
	Callback = function(arg)
		if arg then
			local Players2 = game:GetService("Players")
			local RunService_ = game:GetService("RunService")
			local TweenService = game:GetService("TweenService")
			local Debris = game:GetService("Debris")
			local localPlayer2 = Players2.LocalPlayer

			if _G.LG_PowerHold_Cleanup then
				pcall(function()
					_G.LG_PowerHold_Cleanup()
				end)

				_G.LG_PowerHold_Cleanup = nil
			end

			local str2 = "103062305177426"
			local str3 = "71318091779666"
			local animation = Instance.new("Animation")
			animation.AnimationId = "rbxassetid://85743982894847"
			local animation2 = Instance.new("Animation")
			animation2.AnimationId = "rbxassetid://134716595236712"
			local animation3 = Instance.new("Animation")
			animation3.AnimationId = "rbxassetid://82142761681917"
			local soundId = "rbxassetid://133186567809675"
			local soundId2 = "rbxassetid://107968065093924"
			local soundId3 = "rbxassetid://221711200"
			local lightningGodGrab = nil

			pcall(function()
				lightningGodGrab = game:GetService("ReplicatedStorage").Effects.SetupParts.CustomEffectsFolders.LightningGodGrab
			end)

			local tbl10 = {}
			local tbl11 = {}
			local connection2 = nil
			local flag2 = false
			local v3 = nil
			local tbl12 = {}
			local connection3 = nil
			local connection4 = nil

			local function fn11()
				for _, v4 in pairs(tbl10) do
					pcall(function()
						if v4 and v4.Parent then
							v4:Destroy()
						end
					end)
				end

				tbl10 = {}
				tbl12 = {}
			end

			local function fn12()
				if not flag2 then
					return
				end
				flag2 = false

				for _, v4 in pairs(tbl11) do
					pcall(function()
						v4:Stop(0.2)
					end)
				end

				tbl11 = {}

				if connection2 then
					connection2:Disconnect()
					connection2 = nil
				end

				fn11()
				local humanoidRootPart = localPlayer2.Character and localPlayer2.Character:FindFirstChild("HumanoidRootPart")

				if humanoidRootPart then
					local sound = Instance.new("Sound")
					sound.SoundId = soundId3
					sound.Volume = 3
					sound.Parent = humanoidRootPart
					sound:Play()
					Debris:AddItem(sound, 3)
				end

				if v3 then
					local humanoidRootPart2 = v3:FindFirstChild("HumanoidRootPart")

					if humanoidRootPart2 then
						humanoidRootPart2.AssemblyLinearVelocity = Vector3.zero
					end
				end

				v3 = nil
			end

			_G.LG_PowerHold_Cleanup = function()
				if connection3 then
					connection3:Disconnect()
					connection3 = nil
				end

				if connection4 then
					connection4:Disconnect()
					connection4 = nil
				end

				if flag2 then
					flag2 = false

					if connection2 then
						connection2:Disconnect()
					end

					for _, v4 in pairs(tbl11) do
						pcall(function()
							v4:Stop(0)
						end)
					end

					fn11()
				end

				local character = localPlayer2.Character

				if character then
					local humanoid = character:FindFirstChild("Humanoid")
					humanoid = humanoid and humanoid:FindFirstChild("Animator")

					if humanoid then
						for _, v4 in pairs(humanoid:GetPlayingAnimationTracks()) do
							pcall(function()
								v4:AdjustWeight(1)
							end)
						end
					end
				end
			end

			local function fn13()
				local character = localPlayer2.Character
				if not character then
					return nil
				end
				local humanoidRootPart = character:FindFirstChild("HumanoidRootPart")
				if not humanoidRootPart then
					return nil
				end
				local v4 = nil
				local n = 50

				local function fn14(arg2)
					if arg2 and arg2 ~= character then
						local humanoidRootPart2 = arg2:FindFirstChild("HumanoidRootPart")
						local humanoid = arg2:FindFirstChildOfClass("Humanoid")

						if humanoidRootPart2 and humanoid and humanoid.Health > 0 then
							local animator = humanoid:FindFirstChildOfClass("Animator")
							local flag3 = false

							if animator then
								for _, v5 in pairs(animator:GetPlayingAnimationTracks()) do
									if ((v5.Animation and v5.Animation.AnimationId or ""):match("%d+") or "") == "111638343378220" then
										flag3 = true
										break
									end
								end
							end

							if not flag3 then
								local magnitude = (humanoidRootPart2.Position - humanoidRootPart.Position).Magnitude

								if magnitude < n then
									n = magnitude
									v4 = arg2
								end
							end
						end
					end
				end

				for _, player in pairs(Players2:GetPlayers()) do
					fn14(player.Character)
				end

				local live = workspace:FindFirstChild("Live") or workspace:FindFirstChild("Characters")

				if live then
					for _, child in pairs(live:GetChildren()) do
						fn14(child)
					end
				else
					for _, child in pairs(workspace:GetChildren()) do
						if child:IsA("Model") and child:FindFirstChildOfClass("Humanoid") then
							fn14(child)
						end
					end
				end

				return v4
			end

			local function fn14(arg2, parent)
				if not lightningGodGrab then
					return
				end
				local leftArm = arg2:FindFirstChild("Left Arm")
				local head = parent:FindFirstChild("Head")
				local tbl13 = {}

				for _, v4 in pairs({ "Torso", "Head", "Right Arm", "Left Arm", "Left Leg", "Right Leg" }) do
					local v5 = parent:FindFirstChild(v4)

					if v5 then
						table.insert(tbl13, v5)
					end
				end

				if leftArm then
					local sound = Instance.new("Sound")
					sound.SoundId = soundId2
					sound.Volume = 2
					sound.Parent = leftArm
					sound:Play()
					table.insert(tbl10, sound)
					tbl12[sound] = true
				end

				task.delay(0.17, function()
					if not flag2 then
						return
					end
					local lighting = lightningGodGrab:FindFirstChild("Lighting")

					if lighting and head then
						local clone = lighting:Clone()
						clone.Parent = head
						clone.Brightness = 45
						clone.Enabled = true
						table.insert(tbl10, clone)
						Debris:AddItem(clone, 1.97)
						TweenService:Create(clone, TweenInfo.new(0.08), { Brightness = 2 }):Play()

						task.delay(1.71, function()
							if clone and clone.Parent then
								clone.Brightness = 45
								TweenService:Create(clone, TweenInfo.new(0.12), { Brightness = 2 }):Play()
							end
						end)
					end

					local rightArm = lightningGodGrab:FindFirstChild("Right Arm")

					if rightArm and leftArm then
						local burstEmit = rightArm:FindFirstChild("BurstEmit")

						if burstEmit then
							local clone = burstEmit:Clone()
							clone.Parent = leftArm
							clone.Enabled = true
							table.insert(tbl10, clone)
							Debris:AddItem(clone, 0.5)
						end
					end
				end)

				task.delay(0.22, function()
					if not flag2 then
						return
					end

					for _, v4 in pairs(tbl13) do
						for i = 1, 3 do
							local v5 = lightningGodGrab:FindFirstChild("ToonLightning" .. i)

							if v5 then
								local clone = v5:Clone()
								clone.Parent = v4
								clone.Enabled = true
								table.insert(tbl10, clone)
								Debris:AddItem(clone, 2.22)

								task.delay(1.82, function()
									if clone and clone.Parent then
										clone.Enabled = false
									end
								end)
							end
						end

						local glow = lightningGodGrab:FindFirstChild("Glow")

						if glow then
							local clone = glow:Clone()
							clone.Parent = v4
							clone.Enabled = true
							table.insert(tbl10, clone)
							Debris:AddItem(clone, 2.22)

							task.delay(1.82, function()
								if clone and clone.Parent then
									clone.Enabled = false
								end
							end)
						end
					end

					local rightArm = lightningGodGrab:FindFirstChild("Right Arm")

					if rightArm and leftArm then
						for i = 1, 2 do
							local v4 = rightArm:FindFirstChild("ArmLightning" .. i)

							if v4 then
								local clone = v4:Clone()
								clone.Parent = leftArm
								clone.Enabled = true
								table.insert(tbl10, clone)
								Debris:AddItem(clone, 2.07)

								task.delay(1.82, function()
									if clone and clone.Parent then
										clone.Enabled = false
									end
								end)
							end
						end
					end
				end)

				for _, v4 in pairs({ 0.25, 0.48, 0.72, 0.95, 1.18, 1.42, 1.65, 1.88 }) do
					task.delay(v4, function()
						if not flag2 or not parent.Parent then
							return
						end
						local highlight = Instance.new("Highlight")
						highlight.DepthMode = Enum.HighlightDepthMode.Occluded
						highlight.FillTransparency = 0
						highlight.OutlineTransparency = 1
						highlight.FillColor = Color3.fromRGB(0, 0, 0)
						highlight.Parent = parent
						table.insert(tbl10, highlight)
						Debris:AddItem(highlight, 0.09)

						task.spawn(function()
							highlight.Enabled = true
							highlight.FillColor = Color3.new(0, 0, 0)
							task.wait(0.03)

							if highlight.Parent then
								highlight.FillColor = Color3.new(1, 1, 1)
							end

							task.wait(0.04)

							if highlight.Parent then
								highlight.FillColor = Color3.new(0, 0, 0)
							end
						end)
					end)
				end
			end

			local function fn15(arg2)
				if not arg2 then
					return
				end

				for _, descendant in pairs(arg2:GetDescendants()) do
					if descendant:IsA("Sound") and descendant.IsPlaying then
						if not tbl12[descendant] then
							local match = descendant.SoundId:match("%d+") or ""

							if match == "115899725081193" or match == "110658412036715" then
								descendant.Volume = 0
							elseif flag2 then
								descendant.Volume = 0
							end
						end
					end
				end
			end

			local function fn16()
				if connection3 then
					connection3:Disconnect()
				end

				local character = localPlayer2.Character
				if not character then
					return
				end
				local humanoid = character:WaitForChild("Humanoid", 10)
				if not humanoid then
					return
				end
				local animator = humanoid:WaitForChild("Animator", 10)
				if not animator then
					return
				end

				connection3 = animator.AnimationPlayed:Connect(function(arg2)
					if not arg2 or not arg2.Animation then
						return
					end
					local match = (arg2.Animation.AnimationId or ""):match("%d+") or ""

					if match == str2 then
						pcall(function()
							arg2:AdjustWeight(0.001)
						end)

						local v4 = animator:LoadAnimation(animation)
						v4.Priority = Enum.AnimationPriority.Action4
						v4:Play()
						v4:AdjustSpeed(0.85)

						if not flag2 then
							table.insert(tbl11, v4)
						end

						local humanoidRootPart = character:FindFirstChild("HumanoidRootPart")

						if humanoidRootPart then
							local sound = Instance.new("Sound")
							sound.SoundId = soundId
							sound.Volume = 2
							sound.Parent = humanoidRootPart
							sound:Play()
							table.insert(tbl10, sound)
							tbl12[sound] = true
							Debris:AddItem(sound, 3)
						end

						task.spawn(function()
							for i = 1, 10 do
								fn15(character)
								task.wait(0.1)
							end
						end)
					elseif match == str3 then
						pcall(function()
							arg2:AdjustWeight(0.001)
						end)

						arg2.Stopped:Connect(function()
							if flag2 then
								fn12()
							end
						end)

						local v4 = fn13()

						if not v4 then
							local v5 = animator:LoadAnimation(animation2)
							v5.Priority = Enum.AnimationPriority.Action4
							v5.Looped = true
							v5:Play()
							table.insert(tbl11, v5)
							return
						end

						if flag2 then
							fn12()
						end

						flag2 = true
						v3 = v4
						local v5 = animator:LoadAnimation(animation2)
						v5.Priority = Enum.AnimationPriority.Action4
						v5.Looped = true
						v5:Play()
						table.insert(tbl11, v5)
						local humanoid2 = v4:FindFirstChildOfClass("Humanoid")
						local animator2 = humanoid2 and humanoid2:FindFirstChildOfClass("Animator")

						if animator2 then
							local v6 = animator2:LoadAnimation(animation3)
							v6.Priority = Enum.AnimationPriority.Action4
							v6.Looped = true
							v6:Play()
							table.insert(tbl11, v6)
						end

						fn14(character, v4)

						connection2 = RunService_.RenderStepped:Connect(function()
							if not v4.Parent or not character.Parent then
								fn12()
								return
							end
							local humanoidRootPart = character:FindFirstChild("HumanoidRootPart")
							local humanoidRootPart2 = v4:FindFirstChild("HumanoidRootPart") or v4:FindFirstChild("Torso")
							if not humanoidRootPart or not humanoidRootPart2 then
								fn12()
								return
							end

							for _, v6 in pairs(animator:GetPlayingAnimationTracks()) do
								local match2 = (v6.Animation and v6.Animation.AnimationId or ""):match("%d+") or ""

								if match2 == str2 or match2 == str3 then
									pcall(function()
										v6:AdjustWeight(0.001)
									end)
								end
							end

							if animator2 then
								for _, v6 in pairs(animator2:GetPlayingAnimationTracks()) do
									if ((v6.Animation and v6.Animation.AnimationId or ""):match("%d+") or "") ~= "82142761681917" and v6.Priority.Value >= Enum.AnimationPriority.Action.Value then
										pcall(function()
											v6:AdjustWeight(0.001)
										end)
									end
								end
							end

							fn15(character)
							fn15(v4)
							humanoidRootPart2.CFrame = humanoidRootPart.CFrame * CFrame.new(0, 1, -3.5) * CFrame.Angles(0, 3.1415926535897931, 0)
						end)
					end
				end)
			end

			if localPlayer2.Character then
				task.spawn(fn16)
			end

			connection4 = localPlayer2.CharacterAdded:Connect(function()
				flag2 = false
				v3 = nil
				tbl11 = {}
				task.spawn(fn16)
			end)
		elseif _G.LG_PowerHold_Cleanup then
			pcall(function()
				_G.LG_PowerHold_Cleanup()
			end)

			_G.LG_PowerHold_Cleanup = nil
		end
	end,
})

tbl.autoShootEnabled = false
tbl2.autoShootThread = nil

do
	local function fn11()
		local character = localPlayer.Character
		character = character and character:FindFirstChild("HumanoidRootPart")
		if not character then
			return nil, nil
		end
		local live = workspace:FindFirstChild("Live")
		local huge = math.huge
		local v3 = nil

		if live then
			v3 = nil

			for _, child in pairs(live:GetChildren()) do
				if child.Name:match("Rebel") or child.Name:match("Guard") then
					local humanoidRootPart = child:FindFirstChild("HumanoidRootPart")
					local humanoid = child:FindFirstChild("Humanoid")

					if humanoidRootPart and humanoid and humanoid.Health > 0 then
						local magnitude = (character.Position - humanoidRootPart.Position).Magnitude

						if magnitude < huge then
							huge = magnitude
							v3 = child
						end
					end
				end
			end
		end

		for _, player in ipairs(Players:GetPlayers()) do
			if player ~= localPlayer and player:GetAttribute("IsGuard") == true then
				local character2 = player.Character

				if character2 then
					local humanoidRootPart = character2:FindFirstChild("HumanoidRootPart")
					local humanoid = character2:FindFirstChild("Humanoid")

					if humanoidRootPart and humanoid and humanoid.Health > 0 then
						local magnitude = (character.Position - humanoidRootPart.Position).Magnitude

						if magnitude < huge then
							huge = magnitude
							v3 = character2
						end
					end
				end
			end
		end

		return v3, v3 and v3:FindFirstChild("HumanoidRootPart")
	end

	local function fn12()
		local character = localPlayer.Character
		if not character then
			return nil
		end
		local tool = character:FindFirstChildOfClass("Tool")
		local gunScript

		if tool then
			gunScript = tool:FindFirstChild("GunScript") or tool:FindFirstChild("Client") or tool.Name == "MP5" or tool.Name == "Revolver"
		else
			gunScript = tool
		end

		if gunScript then
			return tool
		end
		local backpack = localPlayer:FindFirstChild("Backpack")

		if backpack then
			for _, child in pairs(backpack:GetChildren()) do
				if child.Name == "MP5" or child.Name == "Revolver" or child:FindFirstChild("GunScript") then
					child.Parent = character
					task.wait(0.1)
					return child
				end
			end
		end

		return nil
	end

	tbl6.RebelBox = tbl5.Rebel:Section({ Opened = true, Title = "| Rebel", Icon = "target" })

	tbl6.RebelBox:Toggle({
		Title = "Auto Shoot",
		Locked = true,
		Default = false,
		Callback = function(autoShootEnabled)
			tbl.autoShootEnabled = autoShootEnabled

			if tbl.autoShootEnabled then
				if tbl2.autoShootThread then
					return
				end
				tbl2.autoShootThread = true

				task.spawn(function()
					while tbl.autoShootEnabled and tbl2.autoShootThread do
						local v3 = fn12()

						if v3 then
							local v4, v5 = fn11()

							if v4 and v5 then
								local tbl10 = {
									v3,
									{
										ClientRayNormal = Vector3.new(0.707164, 0, -0.707049),
										FiredGun = true,
										bulletCF = CFrame.new(-221, 191, 269, 0.108, 0.141, 0.983, 0, 0.989, -0.142, -0.994, 0.015, 0.107),
										ClientRayInstance = v5,
										SecondaryHitTargets = {},
										ClientRayPosition = v5.Position,
										HitTargets = { [v4.Name] = "Head" },
										bulletSizeC = Vector3.new(0.01, 0.01, 48.3),
										NoMuzzleFX = false,
										FirePosition = v5.Position + Vector3.new(0, 1, 0),
									},
								}

								pcall(function()
									game:GetService("ReplicatedStorage").Remotes.FiredGunClient:FireServer(unpack(tbl10))
									task.wait(0.05)
									game:GetService("ReplicatedStorage").Remotes.FiredGunClient:FireServer(v3, { ReloadingGun = true })
								end)
							end
						end

						task.wait(0.15)
					end

					tbl2.autoShootThread = nil
				end)
			end
		end,
	})
end

tbl.aimHelperEnabled = false
local fn11
local flag2 = false

fn11 = function()
	if flag2 then
		return
	end
	flag2 = true

	pcall(function()
		local GunFunctions = require(ReplicatedStorage:WaitForChild("Modules"):WaitForChild("GunFunctions"))
		local firedGun = GunFunctions.FiredGun

		GunFunctions.FiredGun = function(arg, arg2, arg3, ...)
			if not tbl.silentAimEnabled or arg ~= localPlayer.Character then
				return firedGun(arg, arg2, arg3, ...)
			end
			arg3 = arg3 or {}
			local humanoidRootPart = arg and arg:FindFirstChild("HumanoidRootPart")
			if not humanoidRootPart then
				return firedGun(arg, arg2, arg3, ...)
			end
			local position = humanoidRootPart.Position

			pcall(function()
				local attribute = arg:GetAttribute("HoldingWeapon")

				if attribute then
					local v3 = arg:FindFirstChild(attribute)

					if v3 then
						local fireFrom = v3:FindFirstChild("FireFrom")

						if fireFrom then
							position = fireFrom.Position
						end
					end
				end
			end)

			local attribute = localPlayer:GetAttribute("IsGuard")
			local live = workspace:FindFirstChild("Live")
			local v3 = nil

			if live then
				local huge = math.huge
				v3 = nil

				for _, child in pairs(live:GetChildren()) do
					if child ~= arg then
						if not child:FindFirstChild("Dead") then
							if not child:FindFirstChild("IFrame") then
								local humanoid = child:FindFirstChild("Humanoid")

								if not (humanoid and humanoid.Health <= 0) then
									local head = child:FindFirstChild("Head") or child:FindFirstChild("HumanoidRootPart") or child:FindFirstChildWhichIsA("BasePart", true)

									if head then
										local humanoidRootPart2 = child:FindFirstChild("HumanoidRootPart")
										local flag3

										if child:FindFirstChild("Enemy") or string.match(string.lower(child.Name), "peabert") then
											flag3 = true
										elseif attribute then
											local guardCanKill = child:FindFirstChild("GuardCanKill") or humanoidRootPart2 and humanoidRootPart2:FindFirstChild("GuardCanKillLockOn")
											flag3 = false

											if guardCanKill then
												flag3 = true
											end
										else
											local playerFromCharacter = Players:GetPlayerFromCharacter(child)
											local attribute2 = playerFromCharacter and playerFromCharacter ~= localPlayer and playerFromCharacter:GetAttribute("IsGuard") or child.Name:match("Rebel") or child.Name:match("Guard") or child:FindFirstChild("PlayerCanKill") or child:FindFirstChild("TypeOfGuard")
											flag3 = false

											if attribute2 then
												flag3 = true
											end
										end

										local typeOfGuard = attribute and child:FindFirstChild("TypeOfGuard")

										if typeOfGuard then
											typeOfGuard = not (humanoidRootPart2 and humanoidRootPart2:FindFirstChild("GuardCanKillLockOn"))
										end

										if typeOfGuard and not child:FindFirstChild("GuardCanKill") then
											flag3 = false
										end

										if flag3 then
											local magnitude = (head.Position - position).Magnitude

											if magnitude < huge and magnitude < 1000 then
												huge = magnitude
												v3 = head
											end
										end
									end
								end
							end
						end
					end
				end
			end

			if v3 then
				local position2 = v3.Position
				arg3.CustomFireFrom = true
				arg3.spread = 0
				arg2 = position2
			end

			return firedGun(arg, arg2, arg3, ...)
		end
	end)
end

tbl6.RebelBox:Toggle({
	Title = "Silent Aim",
	Default = false,
	Callback = function(silentAimEnabled)
		tbl.silentAimEnabled = silentAimEnabled

		if silentAimEnabled then
			fn11()
		end
	end,
})

do
	local flag3 = false
	local getBuffs = nil

	local function fn12()
		if flag3 then
			return
		end
		flag3 = true

		pcall(function()
			local modules = game:GetService("ReplicatedStorage"):FindFirstChild("Modules")
			modules = modules and modules:FindFirstChild("GunFunctions")

			if modules then
				local module = require(modules)

				if module and module.GetBuffs then
					getBuffs = module.GetBuffs

					module.GetBuffs = function(...)
						local tbl10 = getBuffs(...)

						if type(tbl10) ~= "table" then
							tbl10 = {}
						end

						local tbl11 = {}

						for k, v3 in pairs(tbl10) do
							tbl11[k] = v3
						end

						if tbl.noRecoilSpreadEnabled then
							tbl11.RecoilDiv = 999999
						end

						if tbl.rapidFireEnabled then
							tbl11.FireRateMult = 9999
						end

						return tbl11
					end
				end
			end
		end)
	end

	tbl6.RebelBox:Toggle({
		Title = "No Recoil & Spread",
		Default = false,
		Callback = function(noRecoilSpreadEnabled)
			tbl.noRecoilSpreadEnabled = noRecoilSpreadEnabled

			if noRecoilSpreadEnabled then
				fn12()
			end
		end,
	})

	tbl6.RebelBox:Toggle({
		Title = "Rapid Fire",
		Default = false,
		Callback = function(rapidFireEnabled)
			tbl.rapidFireEnabled = rapidFireEnabled

			if rapidFireEnabled then
				fn12()
			end
		end,
	})
end

local connection2 = nil

tbl6.RebelBox:Toggle({
	Title = "Infinite Ammo",
	Default = false,
	Callback = function(infiniteAmmoRebelEnabled)
		tbl.infiniteAmmoRebelEnabled = infiniteAmmoRebelEnabled

		if infiniteAmmoRebelEnabled then
			if not connection2 then
				connection2 = game:GetService("RunService").RenderStepped:Connect(function()
					if not tbl.infiniteAmmoRebelEnabled then
						return
					end

					pcall(function()
						local character = localPlayer.Character
						if not character then
							return
						end
						local tool = character:FindFirstChildOfClass("Tool")

						if tool then
							local infoClient = tool:FindFirstChild("InfoClient") or tool:FindFirstChild("Info")

							if infoClient then
								local bullets = infoClient:FindFirstChild("Bullets")
								local maxBullets = tool:FindFirstChild("MaxBullets") or tool:FindFirstChild("MagSize")

								if bullets then
									maxBullets = maxBullets and maxBullets.Value or 999

									if bullets.Value < maxBullets then
										bullets.Value = maxBullets
									end
								end
							end
						end
					end)
				end)
			end
		elseif connection2 then
			pcall(function()
				connection2:Disconnect()
			end)

			connection2 = nil
		end
	end,
})

tbl.skyAntiFallEnabled = false
tbl2.skyAntiFallThread = nil
tbl6.SkyBox = tbl5.Sky:Section({ Opened = true, Title = "| Sky Squid Game", Icon = "cloud" })

tbl6.SkyBox:Toggle({
	Title = "Sky Squid Game Anti Fall",
	Default = false,
	Callback = function(skyAntiFallEnabled)
		tbl.skyAntiFallEnabled = skyAntiFallEnabled

		if tbl.skyAntiFallEnabled then
			if tbl2.skyAntiFallThread then
				return
			end
			tbl2.skyAntiFallThread = true

			task.spawn(function()
				while tbl2.skyAntiFallThread and tbl.skyAntiFallEnabled do
					if fn4("SkySquidGame") or fn4("SquidGame") then
						if not workspace:FindFirstChild("SkyAntiFallPlatform") then
							local vector = Vector3.new(91, 957, 251)
							local vector2 = Vector3.new(-70, 958, -107)
							local n = (Vector3.new(91, 957, 251) + Vector3.new(-70, 958, -107)) / 2
							local n2 = math.abs(vector.X - vector2.X)
							local n3 = math.abs(vector.Z - vector2.Z)
							local part = Instance.new("Part")
							part.Name = "SkyAntiFallPlatform"
							part.Size = Vector3.new(n2 + 30, 1, n3 + 30)
							part.Position = Vector3.new(n.X, n.Y + 4, n.Z)
							part.Anchored = true
							part.Transparency = 0.5
							part.Color = Color3.fromRGB(0, 255, 0)
							part.Material = Enum.Material.ForceField
							part.Parent = workspace
						end
					else
						local skyAntiFallPlatform = workspace:FindFirstChild("SkyAntiFallPlatform")

						if skyAntiFallPlatform then
							skyAntiFallPlatform:Destroy()
						end
					end

					task.wait(1)
				end

				local skyAntiFallPlatform = workspace:FindFirstChild("SkyAntiFallPlatform")

				if skyAntiFallPlatform then
					skyAntiFallPlatform:Destroy()
				end

				tbl2.skyAntiFallThread = nil
			end)
		end
	end,
})

tbl.fakeHitboxSquidEnabled = false
tbl.skyAutoQTEEnabled = false
tbl2.skyQTEThread = nil
tbl.antiFreezeFightEnabled = false
local connection3 = nil

tbl6.SkyBox:Toggle({
	Title = "Anti Freeze While Fight",
	Default = false,
	Callback = function(antiFreezeFightEnabled)
		tbl.antiFreezeFightEnabled = antiFreezeFightEnabled

		if tbl.antiFreezeFightEnabled then
			if connection3 then
				return
			end
			local tbl10 = { "Freeze", "Slowed", "Action", "LightAction", "NoAttack" }
			local tbl11 = { "Stun", "Freeze", "Slowed", "Action", "Ragdoll" }

			connection3 = game:GetService("RunService").Heartbeat:Connect(function()
				if not (fn4("SkySquidGame") or fn4("SquidGame")) then
					return
				end

				if shared.IsInCutscene then
					shared.IsInCutscene = nil
				end

				pcall(function()
					local playerScripts = localPlayer:FindFirstChild("PlayerScripts")

					if playerScripts then
						local playerModule = playerScripts:FindFirstChild("PlayerModule")

						if playerModule then
							local controls = require(playerModule):GetControls()

							if controls and controls.Enable then
								controls:Enable(true)
							end
						end
					end
				end)

				local character = localPlayer.Character
				if not character then
					return
				end
				local humanoid = character:FindFirstChildOfClass("Humanoid")
				local humanoidRootPart = character:FindFirstChild("HumanoidRootPart")

				for _, v3 in ipairs(tbl10) do
					if character:GetAttribute(v3) ~= nil then
						character:SetAttribute(v3, nil)
					end

					if humanoid and humanoid:GetAttribute(v3) ~= nil then
						humanoid:SetAttribute(v3, nil)
					end
				end

				if humanoidRootPart and humanoidRootPart.Anchored then
					humanoidRootPart.Anchored = false
				end

				if humanoid then
					local StarterPlayer = game:GetService("StarterPlayer")
					local characterWalkSpeed = StarterPlayer.CharacterWalkSpeed or 16
					local characterJumpPower = StarterPlayer.CharacterJumpPower or 50

					if humanoid.WalkSpeed < characterWalkSpeed then
						humanoid.WalkSpeed = characterWalkSpeed
					end

					if humanoid.JumpPower < characterJumpPower then
						humanoid.JumpPower = characterJumpPower
					end

					if humanoid.PlatformStand then
						humanoid.PlatformStand = false
					end
				end

				for _, v3 in ipairs(tbl11) do
					local v4 = character:FindFirstChild(v3)

					if v4 then
						v4:Destroy()
					end
				end
			end)
		elseif connection3 then
			connection3:Disconnect()
			connection3 = nil
		end
	end,
})

tbl6.SkyBox:Toggle({
	Title = "Auto QTE Event",
	Default = false,
	Callback = function(skyAutoQTEEnabled)
		tbl.skyAutoQTEEnabled = skyAutoQTEEnabled

		if tbl.skyAutoQTEEnabled and not tbl2.skyQTEThread then
			tbl2.skyQTEThread = task.spawn(function()
				local tbl10 = {}

				while tbl.skyAutoQTEEnabled do
					if fn4("SkySquidGame") or fn4("SquidGame") then
						local v3 = fn7()

						if v3 and v3.ActiveButtons then
							for k, activeButton in pairs(v3.ActiveButtons) do
								activeButton = not tbl10[k] and activeButton

								if activeButton then
									tbl10[k] = true

									if tbl.skyAutoQTEEnabled and (fn4("SkySquidGame") or fn4("SquidGame")) and v3.ActiveButtons and v3.ActiveButtons[k] then
										pcall(function()
											v3.Pressed(false, v3.ActiveButtons[k])
										end)
									end
								end
							end

							for k in pairs(tbl10) do
								if not v3.ActiveButtons[k] then
									tbl10[k] = nil
								end
							end
						end
					else
						table.clear(tbl10)
					end

					task.wait()
				end

				tbl2.skyQTEThread = nil
			end)
		end
	end,
})

tbl.throwPoleAimEnabled = false

do
	local tbl10 = {}
	local flag3 = false

	local function fn12()
		local character = localPlayer.Character
		character = character and character:FindFirstChild("HumanoidRootPart")
		if not character then
			return nil
		end
		local huge = math.huge
		local v3 = nil

		for _, player in pairs(Players:GetPlayers()) do
			if player ~= localPlayer and player.Character then
				local humanoidRootPart = player.Character:FindFirstChild("HumanoidRootPart")
				local humanoid = player.Character:FindFirstChild("Humanoid")

				if humanoidRootPart and humanoid and humanoid.Health > 0 then
					local magnitude = (humanoidRootPart.Position - character.Position).Magnitude

					if magnitude < huge then
						huge = magnitude
						v3 = humanoidRootPart
					end
				end
			end
		end

		return v3
	end

	local function fn13()
		local character = localPlayer.Character
		if not character then
			return
		end
		local humanoid = character:FindFirstChild("Humanoid")
		if not humanoid then
			return
		end
		local animator = humanoid:FindFirstChildOfClass("Animator")
		if not animator then
			return
		end

		local connection4 = animator.AnimationPlayed:Connect(function(arg)
			if not tbl.throwPoleAimEnabled then
				return
			end

			if arg.Animation and arg.Animation.AnimationId and string.find(tostring(arg.Animation.AnimationId), "112950478995075") then
				flag3 = true
				local humanoid2 = character:FindFirstChild("Humanoid")

				if humanoid2 then
					humanoid2.AutoRotate = false
				end

				arg.Stopped:Once(function()
					flag3 = false
					local humanoid3 = localPlayer.Character and localPlayer.Character:FindFirstChild("Humanoid")

					if humanoid3 then
						humanoid3.AutoRotate = true
					end
				end)
			end
		end)

		table.insert(tbl10, connection4)
	end

	tbl6.SkyBox:Toggle({
		Title = "Throw Pole AIM",
		Default = false,
		Callback = function(throwPoleAimEnabled)
			tbl.throwPoleAimEnabled = throwPoleAimEnabled

			if tbl.throwPoleAimEnabled then
				fn13()

				local connection4 = localPlayer.CharacterAdded:Connect(function()
					task.wait(0.5)

					if tbl.throwPoleAimEnabled then
						fn13()
					end
				end)

				table.insert(tbl10, connection4)

				local connection5 = game:GetService("RunService").Heartbeat:Connect(function()
					if not tbl.throwPoleAimEnabled or not flag3 then
						return
					end

					if not (fn4("SkySquidGame") or fn4("SquidGame")) then
						return
					end
					local character = localPlayer.Character
					character = character and character:FindFirstChild("HumanoidRootPart")
					if not character then
						return
					end
					local v3 = fn12()

					if v3 then
						character.CFrame = CFrame.lookAt(character.Position, Vector3.new(v3.Position.X, character.Position.Y, v3.Position.Z))
					end
				end)

				table.insert(tbl10, connection5)
			else
				flag3 = false

				for _, v3 in pairs(tbl10) do
					pcall(function()
						v3:Disconnect()
					end)
				end

				table.clear(tbl10)
			end
		end,
	})
end

tbl6.SkyBox:Space()
tbl.squidKillAuraEnabled = false
tbl2.squidKillAuraThread = nil
tbl6.SquidGameBox = tbl5.Sky:Section({ Opened = true, Title = "| Squid Game", Icon = "skull" })

tbl6.SquidGameBox:Toggle({
	Title = "Kill Aura",
	Default = false,
	Callback = function(squidKillAuraEnabled)
		tbl.squidKillAuraEnabled = squidKillAuraEnabled

		if tbl.squidKillAuraEnabled then
			if tbl2.squidKillAuraThread then
				return
			end
			tbl2.squidKillAuraThread = true

			task.spawn(function()
				local tbl10 = { ["96924216250322"] = true, ["116839849594540"] = true, ["123072675259257"] = true }

				while tbl2.squidKillAuraThread and tbl.squidKillAuraEnabled do
					if fn4("SquidGame") then
						local character = localPlayer.Character

						if character and character:FindFirstChild("Humanoid") and character:FindFirstChild("HumanoidRootPart") and character.Humanoid.Health > 0 then
							local humanoidRootPart = character.HumanoidRootPart
							local fists = localPlayer.Backpack:FindFirstChild("Fists")

							if fists then
								character.Humanoid:EquipTool(fists)
							end

							local fists2 = character:FindFirstChild("Fists")

							if fists2 then
								fists2:Activate()
							end

							local v3 = ipairs
							local Players2 = game:GetService("Players")
							local n = 300
							local v4 = nil

							for _, player in v3(Players2:GetPlayers()) do
								if player ~= localPlayer and player.Character and player.Character:FindFirstChild("HumanoidRootPart") and player.Character:FindFirstChild("Humanoid") and player.Character.Humanoid.Health > 0 then
									local magnitude = (player.Character.HumanoidRootPart.Position - humanoidRootPart.Position).Magnitude

									if magnitude < n then
										n = magnitude
										v4 = player
									end
								end
							end

							if v4 and v4.Character then
								local character2 = v4.Character
								local humanoidRootPart2 = character2:FindFirstChild("HumanoidRootPart")
								local humanoid = character2:FindFirstChild("Humanoid")

								if humanoidRootPart2 and humanoid then
									local animator = humanoid:FindFirstChildOfClass("Animator")
									animator = animator and animator:GetPlayingAnimationTracks() or humanoid:GetPlayingAnimationTracks()
									local flag3 = false

									for _, v5 in ipairs(animator) do
										if v5.Animation and v5.Animation.AnimationId then
											local v6 = string.match(v5.Animation.AnimationId, "%d+")

											if v6 and tbl10[v6] then
												if v5.Length == 0 or v5.Length - v5.TimePosition > 0.5 then
													flag3 = true
													break
												end
											end
										end
									end

									if flag3 then
										humanoidRootPart.CFrame = humanoidRootPart2.CFrame * CFrame.new(0, -30, 0)
									else
										humanoidRootPart.CFrame = humanoidRootPart2.CFrame * CFrame.new(0, 0, 3)
									end
								end
							end
						end

						game:GetService("RunService").Heartbeat:Wait()
					else
						task.wait(1)
					end
				end

				tbl2.squidKillAuraThread = nil
			end)
		else
			tbl2.squidKillAuraThread = nil
		end
	end,
})

do
	local flag3 = false
	local flag4 = false
	local tbl10 = {}
	local tbl11 = {}
	local thread = nil
	local PhysicsService = game:GetService("PhysicsService")

	pcall(function()
		PhysicsService:RegisterCollisionGroup("LocalPlayerOnly")
		PhysicsService:RegisterCollisionGroup("FakeGlass")
		PhysicsService:CollisionGroupSetCollidable("FakeGlass", "Default", false)
		PhysicsService:CollisionGroupSetCollidable("FakeGlass", "LocalPlayerOnly", true)
	end)

	local function fn12(adornee)
		if not adornee:IsA("Model") or not adornee.PrimaryPart then
			return
		end
		local primaryPart = adornee.PrimaryPart
		local attribute = primaryPart:GetAttribute("exploitingisevil")

		if flag3 and not tbl10[adornee] then
			local highlight = Instance.new("Highlight")
			highlight.FillTransparency = 0.5
			highlight.OutlineTransparency = 0
			highlight.OutlineColor = Color3.new(1, 1, 1)

			if attribute then
				highlight.FillColor = Color3.fromRGB(255, 50, 50)
				highlight.Name = "BreakableHighlight"
			else
				highlight.FillColor = Color3.fromRGB(50, 255, 50)
				highlight.Name = "SafeHighlight"
			end

			highlight.Adornee = adornee
			highlight.Parent = adornee
			tbl10[adornee] = highlight
		end

		local v3 = flag4

		if not flag4 then
			attribute = v3
		end

		if attribute and not tbl11[adornee] then
			local part = Instance.new("Part")
			part.Size = primaryPart.Size
			part.CFrame = primaryPart.CFrame * CFrame.new(0, 1, 0)
			part.Anchored = true
			part.CanCollide = true
			part.Transparency = 0.5
			part.Color = Color3.fromRGB(50, 255, 50)
			part.Material = Enum.Material.Glass

			pcall(function()
				part.CollisionGroup = "FakeGlass"
			end)

			part.Parent = Workspace
			tbl11[adornee] = part
		end
	end

	local function fn13()
		for _, v3 in pairs(tbl10) do
			if v3 and v3.Parent then
				v3:Destroy()
			end
		end

		table.clear(tbl10)

		for _, v3 in pairs(tbl11) do
			if v3 and v3.Parent then
				v3:Destroy()
			end
		end

		table.clear(tbl11)
	end

	local function fn14()
		if thread then
			return
		end

		thread = task.spawn(function()
			while flag3 or flag4 do
				if Workspace:GetAttribute("GLASSBRIDGEOVER") then
					fn13()
				end

				local character = localPlayer.Character

				if character then
					local humanoid = character:FindFirstChild("Humanoid")

					if humanoid and humanoid.Health <= 0 then
						fn13()
					end
				end

				local glassBridge = Workspace:FindFirstChild("GlassBridge")

				if glassBridge then
					local glassHolder = glassBridge:FindFirstChild("GlassHolder")

					if glassHolder then
						for _, child in ipairs(glassHolder:GetChildren()) do
							for _, child2 in ipairs(child:GetChildren()) do
								fn12(child2)
							end
						end
					end
				end

				task.wait(2)
			end

			thread = nil
		end)
	end

	tbl6.MingleGlassBox = tbl5.MingleGlass:Section({ Opened = true, Title = "| Glass Bridge", Icon = "footprints" })

	tbl6.MingleGlassBox:Toggle({
		Title = "Glass Bridge ESP",
		Default = false,
		Callback = function(arg)
			flag3 = arg

			if flag3 then
				fn14()
			else
				fn13()
			end
		end,
	})

	local connection4 = nil

	tbl6.MingleGlassBox:Toggle({
		Title = "Fake Safe Glass",
		Default = false,
		Callback = function(arg)
			flag4 = arg

			if flag4 then
				local function fn15(character)
					task.spawn(function()
						task.wait(0.5)

						for _, descendant in ipairs(character:GetDescendants()) do
							if descendant:IsA("BasePart") then
								pcall(function()
									descendant.CollisionGroup = "LocalPlayerOnly"
								end)
							end
						end
					end)
				end

				if localPlayer.Character then
					fn15(localPlayer.Character)
				end

				connection4 = localPlayer.CharacterAdded:Connect(fn15)
				fn14()
			else
				if connection4 then
					connection4:Disconnect()
					connection4 = nil
				end

				fn13()
			end
		end,
	})
end

tbl3.lastGlassTPTime = 0

tbl6.MingleGlassBox:Button({
	Title = "TP To Start",
	Callback = function()
		local lastGlassTPTime = tbl3.lastGlassTPTime

		if tick() - lastGlassTPTime < 10 then
			local lastGlassTPTime2 = tbl3.lastGlassTPTime
			fn5(" Cooldown", "Please wait " .. math.ceil(10 - tick() - lastGlassTPTime2) .. "s before teleporting again.")
			return
		end

		if fn4("GlassBridge") then
			fn9(CFrame.new(36, 521, -1533))
			tbl3.lastGlassTPTime = tick()
		else
			fn5(nil, "Glass Bridge is not currently running.")
		end
	end,
})

tbl6.MingleGlassBox:Button({
	Title = "TP To End",
	Callback = function()
		local lastGlassTPTime = tbl3.lastGlassTPTime

		if tick() - lastGlassTPTime < 10 then
			local lastGlassTPTime2 = tbl3.lastGlassTPTime
			fn5(" Cooldown", "Please wait " .. math.ceil(10 - tick() - lastGlassTPTime2) .. "s before teleporting again.")
			return
		end

		if fn4("GlassBridge") then
			fn9(CFrame.new(-204, 521, -1536))
			tbl3.lastGlassTPTime = tick()
		else
			fn5(nil, "Glass Bridge is not currently running.")
		end
	end,
})

tbl6.MingleGlassBox:Space()
tbl3.lastRopeTPTime = 0
tbl6.JumpBox = tbl5.MingleGlass:Section({ Opened = true, Title = "| Jump Rope", Icon = "activity" })

tbl6.JumpBox:Button({
	Title = "Rope TP To Start",
	Callback = function()
		local lastRopeTPTime = tbl3.lastRopeTPTime

		if tick() - lastRopeTPTime < 10 then
			local lastRopeTPTime2 = tbl3.lastRopeTPTime
			fn5(" Cooldown", "Please wait " .. math.ceil(10 - tick() - lastRopeTPTime2) .. "s")
			return
		end

		if fn4("JumpRope") then
			fn9(CFrame.new(616, 197, 921))
			tbl3.lastRopeTPTime = tick()
		else
			fn5(nil, "Jump Rope is not running.")
		end
	end,
})

tbl6.JumpBox:Button({
	Title = "Rope TP To End",
	Callback = function()
		local lastRopeTPTime = tbl3.lastRopeTPTime

		if tick() - lastRopeTPTime < 10 then
			local lastRopeTPTime2 = tbl3.lastRopeTPTime
			fn5(" Cooldown", "Please wait " .. math.ceil(10 - tick() - lastRopeTPTime2) .. "s")
			return
		end

		if fn4("JumpRope") then
			fn9(CFrame.new(734, 197, 921))
			tbl3.lastRopeTPTime = tick()
		else
			fn5(nil, "Jump Rope is not running.")
		end
	end,
})

tbl6.JumpBox:Button({
	Title = "Delete Rope",
	Callback = function()
		if fn4("JumpRope") then
			local effects = Workspace:FindFirstChild("Effects")

			if effects then
				local rope = effects:FindFirstChild("rope")

				if rope then
					rope:Destroy()
					fn5(" Success", "Rope deleted")
				else
					fn5(" Not Found", "Rope not found in Effects.")
				end
			else
				fn5(" Not Found", "Effects folder not found.")
			end
		else
			fn5(nil, "Jump Rope is not running.")
		end
	end,
})

do
	local flag3 = false
	local part = nil

	local function fn12()
		if flag3 and fn4("JumpRope") then
			if not part or not part.Parent then
				part = Instance.new("Part")
				part.Name = "AntiFallPlatform"
				part.Size = Vector3.new(131, 3, 100)
				part.CFrame = CFrame.new(675.5, 192.5, 920)
				part.Anchored = true
				part.CanCollide = true
				part.Transparency = 0.5
				part.Material = Enum.Material.ForceField
				part.BrickColor = BrickColor.new("Bright green")
				part.Parent = Workspace
			end
		elseif part then
			part:Destroy()
			part = nil
		end
	end

	tbl6.JumpBox:Toggle({
		Title = "Anti Fall",
		Default = false,
		Callback = function(arg)
			flag3 = arg
			fn12()
		end,
	})

	task.spawn(function()
		while true do
			if flag3 then
				fn12()
			elseif not flag3 and part then
				part:Destroy()
				part = nil
			end

			task.wait(1)
		end
	end)
end

tbl6.DalgonaBox = tbl5.Dalgona:Section({ Opened = true, Title = "| Dalgona", Icon = "cookie" })

tbl6.DalgonaBox:Button({
	Title = "Auto Complete Dalgona",
	Callback = function()
		if not fn4("Dalgona") then
			fn5(nil, "Dalgona is not currently running.")
			return
		end

		task.spawn(function()
			local v3 = localPlayer
			local currentCamera = workspace.CurrentCamera
			local TweenService = game:GetService("TweenService")
			local RunService_ = game:GetService("RunService")
			local UserInputService_ = game:GetService("UserInputService")

			local function createFolder(parent, name, arg)
				local folder = Instance.new("Folder")
				folder.Name = name
				folder.Parent = parent

				if arg then
					task.delay(arg, function()
						if folder and folder.Parent then
							folder:Destroy()
						end
					end)
				end

				return folder
			end

			local function fn12(arg)
				for _, descendant in pairs(arg:GetDescendants()) do
					if descendant:IsA("BasePart") and descendant.Name ~= "HumanoidRootPart" then
						descendant.Transparency = 1
					end
				end
			end

			local function fn13(arg)
				for _, descendant in pairs(arg:GetDescendants()) do
					if descendant:IsA("BasePart") and descendant.Name ~= "HumanoidRootPart" then
						descendant.Transparency = 0
						descendant.LocalTransparencyModifier = 0
					end
				end

				for _, child in pairs(arg:GetChildren()) do
					if child:IsA("Accessory") then
						local handle = child:FindFirstChild("Handle")

						if handle and handle.Transparency >= 0.99 then
							handle.Transparency = 0
						end
					end
				end
			end

			local function fn14()
				for _, player in pairs(Players:GetPlayers()) do
					if player.Character then
						fn13(player.Character)
					end
				end
			end

			local function fn15()
				local character = v3.Character
				local humanoidRootPart = character and character:FindFirstChild("HumanoidRootPart")
				local humanoid = character and character:FindFirstChild("Humanoid")
				local playerGui = v3:FindFirstChild("PlayerGui")
				local debrisBD = v3:FindFirstChild("DebrisBD")
				local effects = workspace:FindFirstChild("Effects")
				local impactFrames = playerGui and playerGui:FindFirstChild("ImpactFrames")
				if not (character and humanoidRootPart and humanoid) then
					return
				end
				local fieldOfView = currentCamera.FieldOfView
				local v4 = nil
				local v5 = nil
				local v6 = nil
				local v7 = nil

				if effects then
					for _, child in pairs(effects:GetChildren()) do
						if child:IsA("Model") and child.Name:match("Outline$") then
							v5 = child
						elseif child:IsA("Model") and not child.Name:match("Outline$") and child.Name ~= "Pick" and child.Name ~= "RedDot" then
							v4 = child
						elseif child.Name == "Pick" then
							v6 = child
						elseif child.Name == "RedDot" then
							v7 = child
						end
					end
				end

				local progressBar = impactFrames and impactFrames:FindFirstChild("ProgressBar")
				local pickModel = nil

				if impactFrames then
					for _, child in pairs(impactFrames:GetChildren()) do
						if child:IsA("ViewportFrame") and child:FindFirstChild("PickModel") then
							pickModel = child.PickModel
							break
						end
					end
				end

				local dalgonatemprempte = ReplicatedStorage:WaitForChild("Remotes"):WaitForChild("DALGONATEMPREMPTE")
				local flag3 = true
				local connection4 = nil

				task.spawn(function()
					createFolder(v3, "RecentGameStartedMessage", 0.01)

					if v4 and v4:FindFirstChild("shape") then
						local tbl10 = { Position = v4.shape.Position + Vector3.new(0, 0.5, 0) }
						TweenService:Create(v4.shape, TweenInfo.new(2, Enum.EasingStyle.Quad), tbl10):Play()
					end

					if v4 then
						for _, child in pairs(v4:GetChildren()) do
							if child.Name == "DalgonaClickPart" and child:IsA("BasePart") then
								TweenService:Create(child, TweenInfo.new(2, Enum.EasingStyle.Quad), { Transparency = 1 }):Play()
							end
						end
					end

					if v6 and v6.Parent then
						for _, descendant in pairs(v6:GetDescendants()) do
							if descendant:IsA("BasePart") then
								pcall(function()
									TweenService:Create(descendant, TweenInfo.new(2, Enum.EasingStyle.Quad), { Transparency = 1 }):Play()
								end)
							end
						end
					end

					if v7 and v7.Parent then
						for _, descendant in pairs(v7:GetDescendants()) do
							if descendant:IsA("BasePart") then
								pcall(function()
									TweenService:Create(descendant, TweenInfo.new(2, Enum.EasingStyle.Quad), { Transparency = 1 }):Play()
								end)
							end
						end
					end

					if pickModel then
						for _, descendant in pairs(pickModel:GetDescendants()) do
							if descendant:IsA("BasePart") then
								TweenService:Create(descendant, TweenInfo.new(2, Enum.EasingStyle.Quad), { Transparency = 1 }):Play()
							end
						end
					end

					if humanoidRootPart then
						TweenService:Create(currentCamera, TweenInfo.new(2, Enum.EasingStyle.Quad), {
							CFrame = humanoidRootPart.CFrame * CFrame.new(0.0841674805, 8.45438766, 6.69675446, 0.999918401, -0.00898250192, 0.00907994807, 3.31699681e-08, 0.710912943, 0.703280032, -0.0127722733, -0.703222632, 0.710854948),
						}):Play()
					end

					fn12(character)
					dalgonatemprempte:FireServer({ Success = true })
					task.wait(2)

					for _, v8 in pairs({ v4, v5, v6, v7, progressBar }) do
						if v8 and v8.Parent then
							v8:Destroy()
						end
					end

					UserInputService_.MouseIconEnabled = true

					if playerGui and playerGui:FindFirstChild("Hotbar") and playerGui.Hotbar:FindFirstChild("Backpack") then
						TweenService:Create(playerGui.Hotbar.Backpack, TweenInfo.new(1.5, Enum.EasingStyle.Circular, Enum.EasingDirection.InOut), { Position = UDim2.new(0, 0, 0, 0) }):Play()
					end

					if progressBar then
						if debrisBD then
							debrisBD:Fire(progressBar, 2)
						end

						TweenService:Create(progressBar, TweenInfo.new(1.5, Enum.EasingStyle.Circular, Enum.EasingDirection.InOut), { Position = UDim2.new(progressBar.Position.X.Scale, 0, progressBar.Position.Y.Scale + 1, 0) }):Play()
					end

					task.wait(0.5)
					flag3 = false

					if playerGui then
						local dalgonaUI = playerGui:FindFirstChild("DalgonaUI")

						if dalgonaUI then
							dalgonaUI:Destroy()
						end

						local impactFrames2 = playerGui:FindFirstChild("ImpactFrames")

						if impactFrames2 then
							local viewportFrameLighter = impactFrames2:FindFirstChild("ViewportFrameLighter")

							if viewportFrameLighter and viewportFrameLighter:FindFirstChild("WorldModel") and viewportFrameLighter.WorldModel:FindFirstChild("Lighter") then
								viewportFrameLighter.WorldModel.Lighter:Destroy()
							end
						end
					end

					currentCamera.CameraType = Enum.CameraType.Custom

					if humanoid then
						currentCamera.CameraSubject = humanoid
					end

					currentCamera.FieldOfView = fieldOfView or 70
				end)

				connection4 = RunService_.RenderStepped:Connect(function()
					if not flag3 then
						connection4:Disconnect()
						return
					end

					if currentCamera.CameraType == Enum.CameraType.Scriptable then
						currentCamera.CameraType = Enum.CameraType.Custom
					end

					if humanoid and currentCamera.CameraSubject ~= humanoid then
						currentCamera.CameraSubject = humanoid
					end
				end)
			end

			local function fn16()
				if v3.Character and v3.Character:FindFirstChild("Remotes") then
					local remotes = v3.Character:FindFirstChild("Remotes")

					pcall(function()
						remotes.Disabled = true
					end)

					task.wait(0.5)

					pcall(function()
						remotes.Disabled = false
					end)
				end
			end

			local dalgonatemprempte = ReplicatedStorage:WaitForChild("Remotes"):FindFirstChild("DALGONATEMPREMPTE")
			if not dalgonatemprempte then
				return
			end
			dalgonatemprempte:FireServer({ Completed = true })
			dalgonatemprempte:FireServer({ Success = true })
			fn15()
			fn16()

			task.spawn(function()
				repeat
					task.wait(1)
					fn14()
				until not ReplicatedStorage:WaitForChild("Remotes"):FindFirstChild("DALGONATEMPREMPTE")

				fn5(nil, "Dalgona Completed")

				task.spawn(function()
					local n = tick() + 10

					while tick() < n do
						local playerGui = localPlayer:FindFirstChild("PlayerGui")

						if playerGui then
							local dalgonaUI = playerGui:FindFirstChild("DalgonaUI")

							if dalgonaUI then
								dalgonaUI:Destroy()
							end
						end

						task.wait(0.5)
					end
				end)
			end)
		end)
	end,
})

do
	local connection4 = nil
	local tbl10 = {}

	local function fn12()
		local effects = workspace:FindFirstChild("Effects")

		if effects then
			for _, child in pairs(effects:GetChildren()) do
				if child:IsA("Model") and string.match(child.Name, "Outline$") then
					return child
				end
			end
		end

		for _, child in pairs(workspace:GetChildren()) do
			if child:IsA("Model") and string.match(child.Name, "Outline$") then
				return child
			end
		end

		return nil
	end

	local function fn13()
		for k, v3 in pairs(tbl10) do
			if k and k.Parent then
				pcall(function()
					k.Position = v3.Position
					k.Transparency = v3.Transparency
				end)
			end
		end

		table.clear(tbl10)
	end

	tbl6.DalgonaBox:Toggle({
		Title = "One Click Complete",
		Default = false,
		Callback = function(oneClickDalgonaEnabled)
			tbl.oneClickDalgonaEnabled = oneClickDalgonaEnabled

			if oneClickDalgonaEnabled then
				if not connection4 then
					connection4 = game:GetService("RunService").RenderStepped:Connect(function()
						if not tbl.oneClickDalgonaEnabled then
							return
						end

						if not fn4("Dalgona") then
							if next(tbl10) then
								fn13()
							end

							return
						end

						pcall(function()
							local mouse = localPlayer:GetMouse()
							if not mouse or not mouse.Hit then
								return
							end
							local v3 = fn12()

							if v3 then
								local position = mouse.Hit.Position

								for _, child in ipairs(v3:GetChildren()) do
									if child:IsA("BasePart") and not child:GetAttribute("Done") then
										if not tbl10[child] then
											tbl10[child] = { Position = child.Position, Transparency = child.Transparency }
										end

										child.Position = position
										child.Transparency = 1
									end
								end
							end
						end)
					end)
				end
			else
				if connection4 then
					pcall(function()
						connection4:Disconnect()
					end)

					connection4 = nil
				end

				fn13()
			end
		end,
	})
end

tbl6.DalgonaBox:Toggle({
	Title = "Free Lighter",
	Default = false,
	Callback = function(arg)
		if arg then
			localPlayer:SetAttribute("HasLighter", true)
		else
			localPlayer:SetAttribute("HasLighter", nil)
		end
	end,
})

tbl.autoRelaxEnabled = false
local thread = nil

tbl6.DalgonaBox:Toggle({
	Title = "Auto Relax",
	Default = false,
	Callback = function(autoRelaxEnabled)
		tbl.autoRelaxEnabled = autoRelaxEnabled

		if tbl.autoRelaxEnabled and not thread then
			thread = task.spawn(function()
				tbl3.lastRelaxTime = 0

				while tbl.autoRelaxEnabled do
					if fn4("Dalgona") then
						local flag3 = getStressLevel() > 0

						if flag3 then
							local lastRelaxTime = tbl3.lastRelaxTime
							flag3 = tick() - lastRelaxTime >= 2.1
						end

						if flag3 then
							fn6("q")
							tbl3.lastRelaxTime = tick()
						end
					end

					task.wait(1)
				end

				thread = nil
			end)
		end
	end,
})

tbl.dalgonaQteEnabled = false
tbl2.dalgonaQteThread = nil

tbl6.DalgonaBox:Toggle({
	Title = "Auto QTE Event (Dalgona)",
	Default = false,
	Callback = function(dalgonaQteEnabled)
		tbl.dalgonaQteEnabled = dalgonaQteEnabled

		if tbl.dalgonaQteEnabled and not tbl2.dalgonaQteThread then
			tbl2.dalgonaQteThread = task.spawn(function()
				local tbl10 = {}

				while tbl.dalgonaQteEnabled do
					if fn4("Dalgona") then
						local v3 = fn7()

						if v3 and v3.ActiveButtons then
							for k, activeButton in pairs(v3.ActiveButtons) do
								activeButton = not tbl10[k] and activeButton

								if activeButton then
									tbl10[k] = true

									task.delay(0.01, function()
										if tbl.dalgonaQteEnabled and fn4("Dalgona") and v3.ActiveButtons and v3.ActiveButtons[k] then
											pcall(function()
												v3.Pressed(false, v3.ActiveButtons[k])
											end)
										end
									end)
								end
							end

							for k in pairs(tbl10) do
								if not v3.ActiveButtons[k] then
									tbl10[k] = nil
								end
							end
						end
					else
						table.clear(tbl10)
					end

					task.wait(0.05)
				end

				tbl2.dalgonaQteThread = nil
			end)
		end
	end,
})

tbl6.PentathlonBox = tbl5.Dalgona:Section({ Opened = true, Title = "| Pentathlon", Icon = "swords" })

tbl6.PentathlonBox:Button({
	Title = "Auto Complete Ddakji",
	Callback = function()
		if not guid then
			fn5(nil, "Pentathlon is not currently running.")
			return
		end
		local currentCamera = Workspace.CurrentCamera
		local n = currentCamera.CFrame.Position + currentCamera.CFrame.LookVector * 10
		local viewportSize = currentCamera.ViewportSize
		local v3 = currentCamera:ViewportPointToRay(viewportSize.X * 0.5, viewportSize.Y * 0.5)
		local raycastParams = RaycastParams.new()
		raycastParams.FilterType = Enum.RaycastFilterType.Include
		local pentathlonMap = Workspace:FindFirstChild("PentathlonMap")
		raycastParams.FilterDescendantsInstances = pentathlonMap and { pentathlonMap } or {}
		local hit = Workspace:Raycast(v3.Origin, v3.Direction * 500, raycastParams)

		if hit and hit.Position then
			n = hit.Position
		end

		if fn8("Thrown", { Power = 1, Position = n }) then
			fn5("Pentathlon", "Ddakji Completed")
		else
			fn5(" Error", "Wait for game to start")
		end
	end,
})

tbl6.PentathlonBox:Button({
	Title = "Auto Complete Flying Stone",
	Callback = function()
		if not guid then
			fn5(nil, "Pentathlon is not currently running.")
			return
		end
		local character = localPlayer.Character
		character = character and character:FindFirstChild("HumanoidRootPart")

		if character then
			local lookVector = nil

			for _, descendant in ipairs(Workspace:GetDescendants()) do
				if descendant.Name == "Target" and descendant:IsA("BasePart") then
					lookVector = descendant
					break
				else
					lookVector = nil
				end
			end

			local n = character.Position + Vector3.new(0, 1.5, 0)

			if lookVector then
				lookVector = CFrame.lookAt(character.Position, lookVector.Position, Vector3.new(0, 1, 0)).LookVector
			end

			if not lookVector then
				lookVector = Vector3.new(0, 0, 1)
			end

			if fn8("Thrown", { Direction = lookVector, ThrowPower = "Perfect", Origin = n }) then
				fn5("Pentathlon", "Flying Stone Completed")
			else
				fn5(" Error", "Wait for game to start")
			end
		end
	end,
})

tbl6.PentathlonBox:Button({
	Title = "Auto Gonggi (Spam This)",
	Callback = function()
		if not guid then
			fn5(nil, "Pentathlon is not currently running.")
			return
		end

		task.spawn(function()
			pcall(function()
				fn8("Thrown", {})
			end)

			for _, v3 in ipairs({
				"YTriangle",
				"RCircle",
				"Square",
				"GTriangle",
				"BCircle",
				"BSquare",
				"BTriangle",
				"BStar",
				"BUmbrella",
				"YCircle",
				"YSquare",
				"YStar",
				"YUmbrella",
				"RTriangle",
				"RSquare",
				"RStar",
				"RUmbrella",
				"GCircle",
				"GSquare",
				"GStar",
				"GUmbrella",
				"Triangle",
				"Circle",
				"Star",
				"Umbrella",
			}) do
				pcall(function()
					fn8("GotPiece", { Name = v3 })
				end)
			end

			pcall(function()
				fn8("Catch", {})
			end)

			pcall(function()
				fn8("Caught", {})
			end)

			local flag3 = false

			pcall(function()
				flag3 = fn8("TimeSlowFinish", {})
			end)

			if flag3 then
				fn5("Pentathlon", "Gonggi Part Got Completed")
			else
				fn5(" Error", "Check if game started")
			end
		end)
	end,
})

tbl6.PentathlonBox:Button({
	Title = "Auto Complete Spinning Top",
	Callback = function()
		if not guid then
			fn5(nil, "Pentathlon is not currently running.")
			return
		end

		task.spawn(function()
			fn8("Tied", {})
			task.wait(0.01)

			if fn8("Thrown", {}) then
				fn5("Pentathlon", "Spinning Top Completed")
			else
				fn5(" Error", "Wait for game to start")
			end
		end)
	end,
})

tbl6.PentathlonBox:Button({
	Title = "Auto Complete Jegi",
	Callback = function()
		if not guid then
			fn5(nil, "Pentathlon is not currently running.")
			return
		end

		task.spawn(function()
			local flag3 = false

			for i = 1, 6 do
				flag3 = fn8("Kick", { Lose = false })
				task.wait(0.01)
			end

			if flag3 then
				fn5("Pentathlon", "Jegi Completed")
			else
				fn5(" Error", "Wait for game to start")
			end
		end)
	end,
})

do
	local tbl10 = {}

	local function fn12()
		tbl10 = {}

		for _, player in pairs(Players:GetPlayers()) do
			if player ~= localPlayer then
				table.insert(tbl10, player.Name)
			end
		end
	end

	fn12()
	tbl.espPowersEnabled = false
	local tbl11 = {}
	local tbl12 = {}

	local function fn13(arg)
		if not arg or not arg.Character then
			return
		end
		local head = arg.Character:FindFirstChild("Head")
		local attribute = arg:GetAttribute("_EquippedPower")

		if tbl.espPowersEnabled and head and attribute and attribute ~= "" and attribute ~= "None" and attribute ~= "Yok" then
			local text = tostring(attribute)
			local v3 = tbl12[arg]

			if not v3 then
				local billboardGui = Instance.new("BillboardGui")
				billboardGui.Name = "PowerESP"
				billboardGui.AlwaysOnTop = false
				billboardGui.Size = UDim2.new(0, 100, 0, 20)
				billboardGui.StudsOffset = Vector3.new(0, 1.5, 0)
				local textLabel = Instance.new("TextLabel")
				textLabel.BackgroundTransparency = 1
				textLabel.Size = UDim2.new(1, 0, 1, 0)
				textLabel.Text = text
				textLabel.TextColor3 = Color3.new(1, 1, 1)
				textLabel.Font = Enum.Font.Arcade
				textLabel.TextSize = 10
				textLabel.TextStrokeTransparency = 0.5
				textLabel.Parent = billboardGui
				billboardGui.Parent = head
				tbl12[arg] = billboardGui
			else
				if v3.Parent ~= head then
					v3.Parent = head
				end

				local textLabel = v3:FindFirstChildOfClass("TextLabel")

				if textLabel then
					textLabel.Text = text
				end
			end
		elseif tbl12[arg] then
			tbl12[arg]:Destroy()
			tbl12[arg] = nil
		end
	end

	local function fn14(arg)
		if tbl11[arg] then
			tbl11[arg]:Disconnect()
			tbl11[arg] = nil
		end

		tbl11[arg] = arg:GetAttributeChangedSignal("_EquippedPower"):Connect(function()
			fn13(arg)
		end)

		tbl11[arg.Name .. "_char"] = arg.CharacterAdded:Connect(function()
			task.wait(1)

			if tbl.espPowersEnabled then
				fn13(arg)
			end
		end)

		fn13(arg)
	end

	local function fn15()
		for _, v3 in pairs(tbl11) do
			v3:Disconnect()
		end

		table.clear(tbl11)

		for _, v3 in pairs(tbl12) do
			if v3 then
				v3:Destroy()
			end
		end

		table.clear(tbl12)
	end

	tbl3.lastUtilitiesTPTime = 0

	local function fn16(parent, arg)
		local attachment = Instance.new("Attachment")
		attachment.Parent = parent

		if arg then
			attachment.WorldCFrame = CFrame.lookAt(parent.Position, parent.Position + arg)
		end

		local particleEmitter = Instance.new("ParticleEmitter")
		particleEmitter.Acceleration = Vector3.zero
		particleEmitter.Brightness = 0
		local new = ColorSequenceKeypoint.new
		local color = Color3.fromRGB
		particleEmitter.Color = ColorSequence.new({ ColorSequenceKeypoint.new(0, Color3.fromRGB(0, 0, 0)), new(1, color(0, 0, 0)) })
		particleEmitter.Drag = 15
		particleEmitter.EmissionDirection = Enum.NormalId.Front
		particleEmitter.Enabled = false
		particleEmitter.FlipbookFramerate = NumberRange.new(1, 1)
		particleEmitter.FlipbookLayout = Enum.ParticleFlipbookLayout.None
		particleEmitter.FlipbookMode = Enum.ParticleFlipbookMode.Loop
		particleEmitter.Lifetime = NumberRange.new(0.075, 0.17)
		particleEmitter.LightEmission = -3
		particleEmitter.LightInfluence = 0
		particleEmitter.LockedToPart = true
		particleEmitter.Orientation = Enum.ParticleOrientation.VelocityParallel
		particleEmitter.Rate = 75
		particleEmitter.RotSpeed = NumberRange.new(0, 0)
		particleEmitter.Rotation = NumberRange.new(90, 90)
		particleEmitter.Shape = Enum.ParticleEmitterShape.Box
		particleEmitter.ShapeInOut = Enum.ParticleEmitterShapeInOut.Outward
		particleEmitter.ShapePartial = 1
		particleEmitter.ShapeStyle = Enum.ParticleEmitterShapeStyle.Volume
		local numberSequence = NumberSequence.new
		local tbl13 = {}
		local v3 = NumberSequenceKeypoint.new(0, 0, 0)
		local v4 = NumberSequenceKeypoint.new(0.09322, 3.9975, 0.19326)
		local v5 = NumberSequenceKeypoint.new(0.191525, 2.34, 0.172813)
		local v6 = NumberSequenceKeypoint.new(0.29661, 3.75375, 0.164267)
		local v7 = NumberSequenceKeypoint.new(0.410169, 2.29125, 0.149997)
		local v8 = NumberSequenceKeypoint.new(0.605085, 4.24125, 0.141698)
		local new2 = NumberSequenceKeypoint.new
		tbl13[1] = v3
		tbl13[2] = v4
		tbl13[3] = v5
		tbl13[4] = v6
		tbl13[5] = v7
		tbl13[6] = v8

		do
			local values = table.pack(new2(1, 0, 0))
			table.move(values, 1, values.n, 7, tbl13)
		end

		particleEmitter.Size = numberSequence(tbl13)
		particleEmitter.Speed = NumberRange.new(39, 156)
		particleEmitter.SpreadAngle = Vector2.new(0, 0)
		local new3 = NumberSequenceKeypoint.new
		particleEmitter.Squash = NumberSequence.new({ NumberSequenceKeypoint.new(0, 2, 0), new3(1, 2, 0) })
		particleEmitter.Texture = "rbxassetid://15431126240"
		particleEmitter.TimeScale = 1
		local new4 = NumberSequenceKeypoint.new
		particleEmitter.Transparency = NumberSequence.new({ NumberSequenceKeypoint.new(0, 0, 0), new4(1, 0, 0) })
		particleEmitter.VelocityInheritance = 0
		particleEmitter.ZOffset = 0
		particleEmitter.Parent = attachment
		local particleEmitter2 = Instance.new("ParticleEmitter")
		particleEmitter2.Acceleration = Vector3.zero
		particleEmitter2.Brightness = 15
		local new5 = ColorSequenceKeypoint.new
		local color2 = Color3.fromRGB
		particleEmitter2.Color = ColorSequence.new({ ColorSequenceKeypoint.new(0, Color3.fromRGB(0, 0, 0)), new5(1, color2(0, 0, 0)) })
		particleEmitter2.Drag = 10
		particleEmitter2.EmissionDirection = Enum.NormalId.Front
		particleEmitter2.Enabled = false
		particleEmitter2.FlipbookFramerate = NumberRange.new(10, 30)
		particleEmitter2.FlipbookLayout = Enum.ParticleFlipbookLayout.Grid4x4
		particleEmitter2.FlipbookMode = Enum.ParticleFlipbookMode.OneShot
		particleEmitter2.Lifetime = NumberRange.new(0.1, 0.15)
		particleEmitter2.LightEmission = -3
		particleEmitter2.LightInfluence = 0
		particleEmitter2.LockedToPart = false
		particleEmitter2.Orientation = Enum.ParticleOrientation.VelocityParallel
		particleEmitter2.Rate = 20
		particleEmitter2.RotSpeed = NumberRange.new(0, 0)
		particleEmitter2.Rotation = NumberRange.new(-90, -90)
		particleEmitter2.Shape = Enum.ParticleEmitterShape.Box
		particleEmitter2.ShapeInOut = Enum.ParticleEmitterShapeInOut.Outward
		particleEmitter2.ShapePartial = 0
		particleEmitter2.ShapeStyle = Enum.ParticleEmitterShapeStyle.Volume
		local numberSequence2 = NumberSequence.new
		local tbl14 = {}
		local v9 = NumberSequenceKeypoint.new(0, 5.964361, 0)
		local v10 = NumberSequenceKeypoint.new(0.088764, 7.571077, 0.138019)
		local new6 = NumberSequenceKeypoint.new
		tbl14[1] = v9
		tbl14[2] = v10

		do
			local values = table.pack(new6(1, 6.3973, 0))
			table.move(values, 1, values.n, 3, tbl14)
		end

		particleEmitter2.Size = numberSequence2(tbl14)
		particleEmitter2.Speed = NumberRange.new(13.801883, 207.028244)
		particleEmitter2.SpreadAngle = Vector2.new(0, 0)
		local numberSequence3 = NumberSequence.new
		local tbl15 = {}
		local v11 = NumberSequenceKeypoint.new(0, 0, 0)
		local v12 = NumberSequenceKeypoint.new(0.107093, 1.125, 0)
		local v13 = NumberSequenceKeypoint.new(0.404729, 0.8625, 0)
		local new7 = NumberSequenceKeypoint.new
		tbl15[1] = v11
		tbl15[2] = v12
		tbl15[3] = v13

		do
			local values = table.pack(new7(1, 3, 0))
			table.move(values, 1, values.n, 4, tbl15)
		end

		particleEmitter2.Squash = numberSequence3(tbl15)
		particleEmitter2.Texture = "rbxassetid://13127698536"
		particleEmitter2.TimeScale = 1
		local new8 = NumberSequenceKeypoint.new
		particleEmitter2.Transparency = NumberSequence.new({ NumberSequenceKeypoint.new(0, 0, 0), new8(1, 0, 0) })
		particleEmitter2.VelocityInheritance = 0
		particleEmitter2.ZOffset = 0
		particleEmitter2.Parent = attachment
		local particleEmitter3 = Instance.new("ParticleEmitter")
		particleEmitter3.Acceleration = Vector3.zero
		particleEmitter3.Brightness = 10
		local new9 = ColorSequenceKeypoint.new
		local color3 = Color3.fromRGB
		particleEmitter3.Color = ColorSequence.new({ ColorSequenceKeypoint.new(0, Color3.fromRGB(0, 0, 0)), new9(1, color3(0, 0, 0)) })
		particleEmitter3.Drag = 44.962558746337891
		particleEmitter3.EmissionDirection = Enum.NormalId.Top
		particleEmitter3.Enabled = false
		particleEmitter3.FlipbookFramerate = NumberRange.new(4.4928, 4.4928)
		particleEmitter3.FlipbookLayout = Enum.ParticleFlipbookLayout.Grid4x4
		particleEmitter3.FlipbookMode = Enum.ParticleFlipbookMode.OneShot
		particleEmitter3.Lifetime = NumberRange.new(0.173611, 0.289352)
		particleEmitter3.LightEmission = -3
		particleEmitter3.LightInfluence = 0
		particleEmitter3.LockedToPart = false
		particleEmitter3.Orientation = Enum.ParticleOrientation.VelocityParallel
		particleEmitter3.Rate = 5
		particleEmitter3.RotSpeed = NumberRange.new(0, 0)
		particleEmitter3.Rotation = NumberRange.new(-90, -90)
		particleEmitter3.Shape = Enum.ParticleEmitterShape.Box
		particleEmitter3.ShapeInOut = Enum.ParticleEmitterShapeInOut.Outward
		particleEmitter3.ShapePartial = 1
		particleEmitter3.ShapeStyle = Enum.ParticleEmitterShapeStyle.Volume
		local numberSequence4 = NumberSequence.new
		local tbl16 = {}
		local v14 = NumberSequenceKeypoint.new(0, 0, 0)
		local v15 = NumberSequenceKeypoint.new(0.156977, 2.330051, 0)
		local new10 = NumberSequenceKeypoint.new
		tbl16[1] = v14
		tbl16[2] = v15

		do
			local values = table.pack(new10(1, 0, 0))
			table.move(values, 1, values.n, 3, tbl16)
		end

		particleEmitter3.Size = numberSequence4(tbl16)
		particleEmitter3.Speed = NumberRange.new(20, 150)
		particleEmitter3.SpreadAngle = Vector2.new(360, 360)
		local new11 = NumberSequenceKeypoint.new
		particleEmitter3.Squash = NumberSequence.new({ NumberSequenceKeypoint.new(0, 1.5, 0), new11(1, 1.5, 0) })
		particleEmitter3.Texture = "rbxassetid://14005913529"
		particleEmitter3.TimeScale = 1
		local new12 = NumberSequenceKeypoint.new
		particleEmitter3.Transparency = NumberSequence.new({ NumberSequenceKeypoint.new(0, 0, 0), new12(1, 0, 0) })
		particleEmitter3.VelocityInheritance = 0
		particleEmitter3.ZOffset = 1
		particleEmitter3.Parent = attachment
		local particleEmitter4 = Instance.new("ParticleEmitter")
		particleEmitter4.Acceleration = Vector3.zero
		particleEmitter4.Brightness = 50
		local new13 = ColorSequenceKeypoint.new
		local color4 = Color3.fromRGB
		particleEmitter4.Color = ColorSequence.new({ ColorSequenceKeypoint.new(0, Color3.fromRGB(0, 0, 0)), new13(1, color4(0, 0, 0)) })
		particleEmitter4.Drag = 0
		particleEmitter4.EmissionDirection = Enum.NormalId.Right
		particleEmitter4.Enabled = false
		particleEmitter4.FlipbookFramerate = NumberRange.new(43.200001, 43.200001)
		particleEmitter4.FlipbookLayout = Enum.ParticleFlipbookLayout.Grid4x4
		particleEmitter4.FlipbookMode = Enum.ParticleFlipbookMode.OneShot
		particleEmitter4.Lifetime = NumberRange.new(0.231481, 0.289352)
		particleEmitter4.LightEmission = -3
		particleEmitter4.LightInfluence = 0
		particleEmitter4.LockedToPart = true
		particleEmitter4.Orientation = Enum.ParticleOrientation.VelocityPerpendicular
		particleEmitter4.Rate = 5
		particleEmitter4.RotSpeed = NumberRange.new(0, 0)
		particleEmitter4.Rotation = NumberRange.new(-360, 360)
		particleEmitter4.Shape = Enum.ParticleEmitterShape.Box
		particleEmitter4.ShapeInOut = Enum.ParticleEmitterShapeInOut.Outward
		particleEmitter4.ShapePartial = 1
		particleEmitter4.ShapeStyle = Enum.ParticleEmitterShapeStyle.Volume
		local numberSequence5 = NumberSequence.new
		local tbl17 = {}
		local v16 = NumberSequenceKeypoint.new(0, 0, 0)
		local v17 = NumberSequenceKeypoint.new(0.121127, 8.226562, 1.21875)
		local v18 = NumberSequenceKeypoint.new(0.204225, 9.2625, 0.4875)
		local v19 = NumberSequenceKeypoint.new(0.329577, 9.079687, 0.670313)
		local v20 = NumberSequenceKeypoint.new(0.405634, 9.018751, 0.73125)
		local v21 = NumberSequenceKeypoint.new(0.5, 8.775, 0.975)
		local v22 = NumberSequenceKeypoint.new(0.61831, 9.199818, 0.550182)
		local v23 = NumberSequenceKeypoint.new(0.702817, 9.140625, 0.609375)
		local v24 = NumberSequenceKeypoint.new(0.805634, 9.140625, 0.609375)
		local v25 = NumberSequenceKeypoint.new(0.9, 8.957812, 0.792188)
		local new14 = NumberSequenceKeypoint.new
		tbl17[1] = v16
		tbl17[2] = v17
		tbl17[3] = v18
		tbl17[4] = v19
		tbl17[5] = v20
		tbl17[6] = v21
		tbl17[7] = v22
		tbl17[8] = v23
		tbl17[9] = v24
		tbl17[10] = v25

		do
			local values = table.pack(new14(1, 9.75, 0))
			table.move(values, 1, values.n, 11, tbl17)
		end

		particleEmitter4.Size = numberSequence5(tbl17)
		particleEmitter4.Speed = NumberRange.new(0.007821, 0.007821)
		particleEmitter4.SpreadAngle = Vector2.new(1, 1)
		local new15 = NumberSequenceKeypoint.new
		particleEmitter4.Squash = NumberSequence.new({ NumberSequenceKeypoint.new(0, 0, 0), new15(1, 0, 0) })
		particleEmitter4.Texture = "rbxassetid://17888919056"
		particleEmitter4.TimeScale = 1
		local numberSequence6 = NumberSequence.new
		local tbl18 = {}
		local v26 = NumberSequenceKeypoint.new(0, 1, 0)
		local v27 = NumberSequenceKeypoint.new(0.150873, 0.252381, 0)
		local v28 = NumberSequenceKeypoint.new(0.236908, 0.16875, 0)
		local v29 = NumberSequenceKeypoint.new(0.332918, 0.152381, 0)
		local v30 = NumberSequenceKeypoint.new(0.607232, 0.171429, 0)
		local v31 = NumberSequenceKeypoint.new(0.704489, 0.233333, 0)
		local v32 = NumberSequenceKeypoint.new(0.798005, 0.166667, 0)
		local new16 = NumberSequenceKeypoint.new
		tbl18[1] = v26
		tbl18[2] = v27
		tbl18[3] = v28
		tbl18[4] = v29
		tbl18[5] = v30
		tbl18[6] = v31
		tbl18[7] = v32

		do
			local values = table.pack(new16(1, 0, 0))
			table.move(values, 1, values.n, 8, tbl18)
		end

		particleEmitter4.Transparency = numberSequence6(tbl18)
		particleEmitter4.VelocityInheritance = 0
		particleEmitter4.ZOffset = 0.60000002384185791
		particleEmitter4.Parent = attachment
		local particleEmitter5 = Instance.new("ParticleEmitter")
		particleEmitter5.Acceleration = Vector3.zero
		particleEmitter5.Brightness = 50
		local new17 = ColorSequenceKeypoint.new
		local color5 = Color3.fromRGB
		particleEmitter5.Color = ColorSequence.new({ ColorSequenceKeypoint.new(0, Color3.fromRGB(0, 0, 0)), new17(1, color5(0, 0, 0)) })
		particleEmitter5.Drag = 0
		particleEmitter5.EmissionDirection = Enum.NormalId.Front
		particleEmitter5.Enabled = false
		particleEmitter5.FlipbookFramerate = NumberRange.new(1.05, 1.05)
		particleEmitter5.FlipbookLayout = Enum.ParticleFlipbookLayout.Grid4x4
		particleEmitter5.FlipbookMode = Enum.ParticleFlipbookMode.OneShot
		particleEmitter5.Lifetime = NumberRange.new(0.285714, 0.666667)
		particleEmitter5.LightEmission = -3
		particleEmitter5.LightInfluence = 0.15000000596046448
		particleEmitter5.LockedToPart = false
		particleEmitter5.Orientation = Enum.ParticleOrientation.VelocityPerpendicular
		particleEmitter5.Rate = 5
		particleEmitter5.RotSpeed = NumberRange.new(0, 0)
		particleEmitter5.Rotation = NumberRange.new(-360, 360)
		particleEmitter5.Shape = Enum.ParticleEmitterShape.Box
		particleEmitter5.ShapeInOut = Enum.ParticleEmitterShapeInOut.Outward
		particleEmitter5.ShapePartial = 1
		particleEmitter5.ShapeStyle = Enum.ParticleEmitterShapeStyle.Volume
		local numberSequence7 = NumberSequence.new
		local tbl19 = {}
		local v33 = NumberSequenceKeypoint.new(0, 0, 2.410325)
		local v34 = NumberSequenceKeypoint.new(0.1, 3.77373, 2.410325)
		local v35 = NumberSequenceKeypoint.new(0.2, 5.592422, 2.410325)
		local v36 = NumberSequenceKeypoint.new(0.3, 6.880312, 2.410325)
		local v37 = NumberSequenceKeypoint.new(0.4, 7.878638, 2.410325)
		local v38 = NumberSequenceKeypoint.new(0.5, 8.683578, 2.410325)
		local v39 = NumberSequenceKeypoint.new(0.6, 9.34392, 2.410325)
		local v40 = NumberSequenceKeypoint.new(0.7, 9.886753, 2.410325)
		local v41 = NumberSequenceKeypoint.new(0.8, 10.325925, 2.410325)
		local v42 = NumberSequenceKeypoint.new(0.9, 10.661847, 2.410325)
		local new18 = NumberSequenceKeypoint.new
		tbl19[1] = v33
		tbl19[2] = v34
		tbl19[3] = v35
		tbl19[4] = v36
		tbl19[5] = v37
		tbl19[6] = v38
		tbl19[7] = v39
		tbl19[8] = v40
		tbl19[9] = v41
		tbl19[10] = v42

		do
			local values = table.pack(new18(1, 10.846463, 2.410325))
			table.move(values, 1, values.n, 11, tbl19)
		end

		particleEmitter5.Size = numberSequence7(tbl19)
		particleEmitter5.Speed = NumberRange.new(0.01645, 0.01645)
		particleEmitter5.SpreadAngle = Vector2.new(20, 20)
		local new19 = NumberSequenceKeypoint.new
		particleEmitter5.Squash = NumberSequence.new({ NumberSequenceKeypoint.new(0, 0, 0), new19(1, 0, 0) })
		particleEmitter5.Texture = "http://www.roblox.com/asset/?id=14695179076"
		particleEmitter5.TimeScale = 1
		local new20 = NumberSequenceKeypoint.new
		particleEmitter5.Transparency = NumberSequence.new({ NumberSequenceKeypoint.new(0, 0, 0), new20(1, 0, 0) })
		particleEmitter5.VelocityInheritance = 0
		particleEmitter5.ZOffset = 0.10000000149011612
		particleEmitter5.Parent = attachment
		local particleEmitter6 = Instance.new("ParticleEmitter")
		particleEmitter6.Acceleration = Vector3.new(0, 0, 150)
		particleEmitter6.Brightness = 100
		local new21 = ColorSequenceKeypoint.new
		local color6 = Color3.fromRGB
		particleEmitter6.Color = ColorSequence.new({ ColorSequenceKeypoint.new(0, Color3.fromRGB(0, 0, 0)), new21(1, color6(0, 0, 0)) })
		particleEmitter6.Drag = 7.5997705459594727
		particleEmitter6.EmissionDirection = Enum.NormalId.Top
		particleEmitter6.Enabled = false
		particleEmitter6.FlipbookFramerate = NumberRange.new(0.870608, 0.870608)
		particleEmitter6.FlipbookLayout = Enum.ParticleFlipbookLayout.None
		particleEmitter6.FlipbookMode = Enum.ParticleFlipbookMode.OneShot
		particleEmitter6.Lifetime = NumberRange.new(0.25, 1.666667)
		particleEmitter6.LightEmission = -3
		particleEmitter6.LightInfluence = 0
		particleEmitter6.LockedToPart = false
		particleEmitter6.Orientation = Enum.ParticleOrientation.VelocityParallel
		particleEmitter6.Rate = 5
		particleEmitter6.RotSpeed = NumberRange.new(0, 0)
		particleEmitter6.Rotation = NumberRange.new(90, 90)
		particleEmitter6.Shape = Enum.ParticleEmitterShape.Box
		particleEmitter6.ShapeInOut = Enum.ParticleEmitterShapeInOut.Outward
		particleEmitter6.ShapePartial = 1
		particleEmitter6.ShapeStyle = Enum.ParticleEmitterShapeStyle.Volume
		local numberSequence8 = NumberSequence.new
		local tbl20 = {}
		local v43 = NumberSequenceKeypoint.new(0, 0, 0)
		local v44 = NumberSequenceKeypoint.new(0.028523, 0.572566, 0.240108)
		local v45 = NumberSequenceKeypoint.new(0.041946, 0.166229, 0.110819)
		local v46 = NumberSequenceKeypoint.new(0.125839, 0, 0)
		local v47 = NumberSequenceKeypoint.new(0.16443, 0.387867, 0.103414)
		local v48 = NumberSequenceKeypoint.new(0.193792, 0, 0)
		local v49 = NumberSequenceKeypoint.new(0.234899, 0.572566, 0.096872)
		local v50 = NumberSequenceKeypoint.new(0.266779, 0, 0)
		local v51 = NumberSequenceKeypoint.new(0.318792, 0.683385, 0.088375)
		local v52 = NumberSequenceKeypoint.new(0.384228, 0.535626, 0.080539)
		local v53 = NumberSequenceKeypoint.new(0.397651, 0.295518, 0.078783)
		local v54 = NumberSequenceKeypoint.new(0.463087, 0.092349, 0.073309)
		local v55 = NumberSequenceKeypoint.new(0.524329, 1.015843, 0.069895)
		local v56 = NumberSequenceKeypoint.new(0.562081, 0.313988, 0.067676)
		local v57 = NumberSequenceKeypoint.new(0.640101, 0.461747, 0.058212)
		local v58 = NumberSequenceKeypoint.new(0.751678, 0.129289, 0.043693)
		local v59 = NumberSequenceKeypoint.new(0.813758, 0.05541, 0.033779)
		local v60 = NumberSequenceKeypoint.new(0.856544, 0.350927, 0.026718)
		local v61 = NumberSequenceKeypoint.new(0.886745, 0.110819, 0.021405)
		local new22 = NumberSequenceKeypoint.new
		tbl20[1] = v43
		tbl20[2] = v44
		tbl20[3] = v45
		tbl20[4] = v46
		tbl20[5] = v47
		tbl20[6] = v48
		tbl20[7] = v49
		tbl20[8] = v50
		tbl20[9] = v51
		tbl20[10] = v52
		tbl20[11] = v53
		tbl20[12] = v54
		tbl20[13] = v55
		tbl20[14] = v56
		tbl20[15] = v57
		tbl20[16] = v58
		tbl20[17] = v59
		tbl20[18] = v60
		tbl20[19] = v61

		do
			local values = table.pack(new22(1, 0, 0))
			table.move(values, 1, values.n, 20, tbl20)
		end

		particleEmitter6.Size = numberSequence8(tbl20)
		particleEmitter6.Speed = NumberRange.new(37.104637, 111.313934)
		particleEmitter6.SpreadAngle = Vector2.new(200, 200)
		local new23 = NumberSequenceKeypoint.new
		particleEmitter6.Squash = NumberSequence.new({ NumberSequenceKeypoint.new(0, 1, 0), new23(1, 1, 0.549618) })
		particleEmitter6.Texture = "rbxassetid://14045123768"
		particleEmitter6.TimeScale = 1
		local new24 = NumberSequenceKeypoint.new
		particleEmitter6.Transparency = NumberSequence.new({ NumberSequenceKeypoint.new(0, 0, 0), new24(1, 0, 0) })
		particleEmitter6.VelocityInheritance = 0
		particleEmitter6.ZOffset = 2
		particleEmitter6.Parent = attachment
		particleEmitter:Emit(particleEmitter.Rate)
		particleEmitter2:Emit(particleEmitter2.Rate)
		particleEmitter3:Emit(particleEmitter3.Rate)
		particleEmitter4:Emit(particleEmitter4.Rate)
		particleEmitter5:Emit(particleEmitter5.Rate)
		particleEmitter6:Emit(particleEmitter6.Rate)

		task.delay(1.7, function()
			attachment:Destroy()
		end)
	end

	tbl.customPhantomEnabled = false
	local flag3 = nil
	local clone = nil
	local n = 2
	local flag4 = false
	local TweenService = game:GetService("TweenService")
	game:GetService("UserInputService")
	local n2 = 1

	task.spawn(function()
		pcall(function()
			if not isfolder("LarpInk") then
				makefolder("LarpInk")
			end

			if not isfile("LarpInk/1.mp3") then
				writefile("LarpInk/1.mp3", game:HttpGet("https://github.com/platinww/UwU/raw/refs/heads/main/UI/1.mp3"))
			end

			if not isfile("LarpInk/2.mp3") then
				writefile("LarpInk/2.mp3", game:HttpGet("https://github.com/platinww/UwU/raw/refs/heads/main/UI/2.mp3"))
			end
		end)
	end)

	local function fn17(arg)
		if arg then
			if flag3 then
				fn5(nil, "Phantom Step is already activated!")
				return
			end
			tbl.customPhantomEnabled = true
			n = 2
			fn5(nil, "Phantom Step Activated PC Keybind Q")
			flag3 = true

			local function fn18()
				if n > 0 and not flag4 then
					local character = localPlayer.Character
					local humanoidRootPart = character and character:FindFirstChild("HumanoidRootPart")

					if humanoidRootPart then
						local humanoid = character:FindFirstChild("Humanoid")
						if humanoid and humanoid.Health <= 0 then
							return
						end
						local v3, v4, v5 = ipairs(humanoidRootPart:GetConnectedParts(true))
						local flag5 = false

						for _, v6 in v3, v4, v5 do
							local model = v6:FindFirstAncestorOfClass("Model")
							if model and model ~= character and game:GetService("Players"):GetPlayerFromCharacter(model) then
								flag5 = true
								break
							end
						end

						local tbl13 = {
							["rbxassetid://95966876052605"] = true,
							["rbxassetid://96909201344123"] = true,
							["rbxassetid://103036184572721"] = true,
							["rbxassetid://92750801694745"] = true,
							["rbxassetid://79058658453400"] = true,
							["rbxassetid://71410568064809"] = true,
							["rbxassetid://135421881374988"] = true,
							["rbxassetid://128174895245172"] = true,
							["rbxassetid://90903084043782"] = true,
							["rbxassetid://134977807883018"] = true,
							["rbxassetid://99725739479024"] = true,
							["rbxassetid://86955193235427"] = true,
							["rbxassetid://76720621720056"] = true,
							["rbxassetid://115446895197171"] = true,
						}

						if not flag5 and humanoid then
							local animator = humanoid:FindFirstChildOfClass("Animator")

							if animator then
								for _, v6 in ipairs(animator:GetPlayingAnimationTracks()) do
									if v6.Animation then
										local animationId = v6.Animation.AnimationId
										local str2 = v6.Animation.Name:lower()
										if tbl13[animationId] or animationId:lower():match("carry") or str2:match("carry") or str2:match("carried") then
											flag5 = true
											break
										end
									end
								end
							end
						end

						if flag5 then
							return
						end

						if fn4("TugOfWar") then
							return
						end
						n -= 1
						flag4 = true

						task.delay(0.2, function()
							flag4 = false
						end)

						task.delay(1.5, function()
							if n < 2 then
								n += 1
							end
						end)

						local cFrame = humanoidRootPart.CFrame
						local humanoid2 = character:FindFirstChild("Humanoid")
						local moveDirection

						if humanoid2 and humanoid2.MoveDirection.Magnitude > 0.1 then
							moveDirection = humanoid2.MoveDirection
						else
							moveDirection = cFrame.LookVector
						end

						local raycastParams = RaycastParams.new()
						local filterDescendantsInstances = { character }
						local v6 = ipairs
						local Players2 = game:GetService("Players")

						for _, player in v6(Players2:GetPlayers()) do
							if player ~= localPlayer and player.Character then
								table.insert(filterDescendantsInstances, player.Character)
							end
						end

						raycastParams.FilterDescendantsInstances = filterDescendantsInstances
						raycastParams.FilterType = Enum.RaycastFilterType.Exclude
						local position = cFrame.Position
						local n3 = 11
						local position2 = nil

						for i = 1, 15 do
							local hit = workspace:Raycast(position, moveDirection * n3, raycastParams)
							position2 = nil

							if hit then
								if hit.Instance.CanCollide then
									position2 = hit.Position
									break
								else
									table.insert(filterDescendantsInstances, hit.Instance)
									raycastParams.FilterDescendantsInstances = filterDescendantsInstances
									n3 -= (hit.Position - position).Magnitude
									position = hit.Position + moveDirection * 0.01
									position2 = nil
									if not (n3 <= 0) then
										position2 = nil
										continue
									end
								end
							end

							break
						end

						local n4 = 11

						if position2 then
							n4 = math.max(0, (position2 - cFrame.Position).Magnitude - 1.5)
						end

						local n5 = cFrame + moveDirection * math.max(0, n4)
						fn16(humanoidRootPart, moveDirection)
						local screenGui = Instance.new("ScreenGui")
						screenGui.IgnoreGuiInset = true

						pcall(function()
							screenGui.Parent = game:GetService("CoreGui")
						end)

						if not screenGui.Parent then
							screenGui.Parent = localPlayer:WaitForChild("PlayerGui")
						end

						local imageLabel = Instance.new("ImageLabel")
						imageLabel.Size = UDim2.new(1, 0, 1, 0)
						imageLabel.BackgroundTransparency = 1
						imageLabel.Image = "rbxassetid://17464258529"
						imageLabel.ImageColor3 = Color3.new(0, 0, 0)
						imageLabel.ImageTransparency = 1
						imageLabel.Parent = screenGui
						TweenService:Create(imageLabel, TweenInfo.new(0.05, Enum.EasingStyle.Sine), { ImageTransparency = 0.2 }):Play()
						local currentCamera = workspace.CurrentCamera
						local n6 = 70
						TweenService:Create(currentCamera, TweenInfo.new(0.05, Enum.EasingStyle.Sine, Enum.EasingDirection.Out), { FieldOfView = n6 + 15 }):Play()
						local sound = Instance.new("Sound")

						if n == 0 then
							if n2 == 2 then
								sound.SoundId = getcustomasset("LarpInk/1.mp3")
								n2 = 1
							else
								sound.SoundId = getcustomasset("LarpInk/2.mp3")
								n2 = 2
							end
						elseif math.random(1, 100) <= 30 then
							sound.SoundId = getcustomasset("LarpInk/2.mp3")
							n2 = 2
						else
							sound.SoundId = getcustomasset("LarpInk/1.mp3")
							n2 = 1
						end

						sound.Volume = 2
						sound.Parent = game:GetService("SoundService")
						sound:Play()

						sound.Ended:Connect(function()
							sound:Destroy()
						end)

						local tbl14 = {}

						for _, descendant in ipairs(character:GetDescendants()) do
							if descendant:IsA("BasePart") and descendant.Name ~= "HumanoidRootPart" and descendant.Transparency < 1 then
								tbl14[descendant] = descendant.Transparency
								descendant.Transparency = 1
							elseif descendant:IsA("Decal") and descendant.Transparency < 1 then
								tbl14[descendant] = descendant.Transparency
								descendant.Transparency = 1
							end
						end

						TweenService:Create(humanoidRootPart, TweenInfo.new(0.12, Enum.EasingStyle.Sine, Enum.EasingDirection.Out), { CFrame = n5 }):Play()

						task.delay(0.12, function()
							for k, v7 in pairs(tbl14) do
								if k and k.Parent then
									k.Transparency = v7
								end
							end

							fn16(humanoidRootPart, moveDirection)
							local tween = TweenService:Create(imageLabel, TweenInfo.new(0.8, Enum.EasingStyle.Sine, Enum.EasingDirection.Out), { ImageTransparency = 1 })
							tween:Play()

							tween.Completed:Connect(function()
								screenGui:Destroy()
							end)

							local tbl15 = { FieldOfView = n6 }
							TweenService:Create(currentCamera, TweenInfo.new(0.45, Enum.EasingStyle.Sine, Enum.EasingDirection.Out), tbl15):Play()
						end)
					end
				end
			end

			game:GetService("ContextActionService"):BindActionAtPriority("CustomPhantomStep_Q", function(arg2, arg3)
				if arg3 == Enum.UserInputState.Begin then
					fn18()
				end

				return Enum.ContextActionResult.Sink
			end, false, Enum.ContextActionPriority.High.Value + 100, Enum.KeyCode.Q)

			local playerGui = localPlayer:FindFirstChild("PlayerGui")

			if playerGui then
				local mobileSupport = playerGui:FindFirstChild("MobileSupport")

				if mobileSupport then
					local customPhantomBtn = mobileSupport:FindFirstChild("CustomPhantomBtn")

					if customPhantomBtn then
						customPhantomBtn:Destroy()
					end

					local rollButton = mobileSupport:FindFirstChild("RollButton")

					if rollButton and game:GetService("UserInputService").TouchEnabled then
						clone = rollButton:Clone()
						clone.Name = "CustomPhantomBtn"
						clone.Visible = true
						clone.Parent = mobileSupport

						clone.InputBegan:Connect(function(input)
							if input.UserInputType == Enum.UserInputType.Touch or input.UserInputType == Enum.UserInputType.MouseButton1 then
								local imageLabelBaseHOLDING = clone:FindFirstChild("ImageLabelBaseHOLDING")

								if imageLabelBaseHOLDING then
									imageLabelBaseHOLDING.Visible = true
								end

								fn18()
							end
						end)

						clone.InputEnded:Connect(function(input)
							if input.UserInputType == Enum.UserInputType.Touch or input.UserInputType == Enum.UserInputType.MouseButton1 then
								local imageLabelBaseHOLDING = clone:FindFirstChild("ImageLabelBaseHOLDING")

								if imageLabelBaseHOLDING then
									imageLabelBaseHOLDING.Visible = false
								end
							end
						end)

						rollButton.Visible = false
					end
				end
			end
		elseif flag3 then
			game:GetService("ContextActionService"):UnbindAction("CustomPhantomStep_Q")

			if clone then
				clone:Destroy()
			end

			flag3 = nil
			tbl.customPhantomEnabled = false
			fn5(nil, "Phantom Step Deactivated")
		end
	end

	tbl6.TeleportBox = tbl5.Utilities:Section({ Opened = true, Title = "| Teleport", Icon = "navigation" })
	tbl6.UtilitiesBox = tbl5.Utilities:Section({ Opened = true, Title = "| Utilities", Icon = "wrench" })

	tbl6.UtilitiesBox:Toggle({
		Title = "Free Phantom Step",
		Default = false,
		Callback = function(arg)
			if fn17 then
				fn17(arg)
			end
		end,
	})

	local str2 = ""

	tbl6.TeleportBox:Button({
		Title = "Refresh Player List",
		Callback = function()
			fn12()

			if tpDropdown then
				tpDropdown:Refresh(tbl10)
			end
		end,
	})

	tbl6.TeleportBox:Dropdown({
		Callback = function(arg)
			str2 = arg
		end,
		Values = tbl10,
		Default = 1,
		Multi = false,
		Title = "Select Player",
	})

	tbl6.TeleportBox:Button({
		Title = "Teleport to Player",
		Callback = function()
			fn12()
			local v3 = str2
			if not v3 or v3 == "" then
				fn5(" Error", "Select a player first")
				return
			end
			local v4 = Players:FindFirstChild(v3)

			if v4 and v4.Character and v4.Character:FindFirstChild("HumanoidRootPart") then
				fn9(v4.Character.HumanoidRootPart.CFrame * CFrame.new(0, 0, 3))
				fn5(" Teleported", "Teleported to " .. v3)
			else
				fn5(" Error", "Player not found or has no character")
			end
		end,
	})

	tbl6.TeleportBox:Button({
		Title = "Teleport 100 Stud Up",
		Callback = function()
			local lastUtilitiesTPTime = tbl3.lastUtilitiesTPTime

			if tick() - lastUtilitiesTPTime < 10 then
				local lastUtilitiesTPTime2 = tbl3.lastUtilitiesTPTime
				fn5(nil, "Please wait before teleporting again (" .. math.ceil(10 - tick() - lastUtilitiesTPTime2) .. "s)")
				return
			end

			local character = localPlayer.Character

			if character and character:FindFirstChild("HumanoidRootPart") then
				character.HumanoidRootPart.CFrame = character.HumanoidRootPart.CFrame * CFrame.new(0, 100, 0)
				tbl3.lastUtilitiesTPTime = tick()
				fn5(nil, "Successfully Teleported 100 Stud Up")
			end
		end,
	})

	tbl6.TeleportBox:Button({
		Title = "Teleport 50 Stud Down",
		Callback = function()
			local lastUtilitiesTPTime = tbl3.lastUtilitiesTPTime

			if tick() - lastUtilitiesTPTime < 10 then
				local lastUtilitiesTPTime2 = tbl3.lastUtilitiesTPTime
				fn5(nil, "Please wait before teleporting again (" .. math.ceil(10 - tick() - lastUtilitiesTPTime2) .. "s)")
				return
			end

			local character = localPlayer.Character

			if character and character:FindFirstChild("HumanoidRootPart") then
				character.HumanoidRootPart.CFrame = character.HumanoidRootPart.CFrame * CFrame.new(0, -50, 0)
				tbl3.lastUtilitiesTPTime = tick()
				fn5(nil, "Successfully Teleported 50 Stud Down")
			end
		end,
	})

	tbl.allGamesAutoQTEEnabled = false
	tbl2.allGamesQTEThread = nil

	tbl6.GameToolsBox:Toggle({
		Title = "Auto QTE Event (All Games)",
		Default = false,
		Callback = function(allGamesAutoQTEEnabled)
			tbl.allGamesAutoQTEEnabled = allGamesAutoQTEEnabled

			if tbl.allGamesAutoQTEEnabled and not tbl2.allGamesQTEThread then
				tbl2.allGamesQTEThread = task.spawn(function()
					local tbl13 = {}

					while tbl.allGamesAutoQTEEnabled do
						local v3 = fn7()

						if v3 and v3.ActiveButtons then
							for k, activeButton in pairs(v3.ActiveButtons) do
								activeButton = not tbl13[k] and activeButton

								if activeButton then
									tbl13[k] = true

									if tbl.allGamesAutoQTEEnabled and v3.ActiveButtons and v3.ActiveButtons[k] then
										pcall(function()
											v3.Pressed(false, v3.ActiveButtons[k])
										end)
									end
								end
							end

							for k in pairs(tbl13) do
								if not v3.ActiveButtons[k] then
									tbl13[k] = nil
								end
							end
						else
							table.clear(tbl13)
						end

						task.wait()
					end

					tbl2.allGamesQTEThread = nil
				end)
			elseif not tbl.allGamesAutoQTEEnabled then
				tbl2.allGamesQTEThread = nil
			end
		end,
	})

	tbl6.GameToolsBox:Toggle({
		Title = "ESP Powers",
		Default = false,
		Callback = function(espPowersEnabled)
			tbl.espPowersEnabled = espPowersEnabled

			if espPowersEnabled then
				for _, player in ipairs(Players:GetPlayers()) do
					if player ~= localPlayer then
						fn14(player)
					end
				end

				tbl11._PlayerAdded = Players.PlayerAdded:Connect(function(player)
					if tbl.espPowersEnabled then
						fn14(player)
					end
				end)
			else
				fn15()
			end
		end,
	})
end

tbl.peabertESPEnabled = false

do
	local tbl10 = {}
	local tbl11 = {}

	local function fn12(parent)
		if not parent or not parent.Parent then
			return
		end

		if tbl11[parent] then
			return
		end
		local highlight = Instance.new("Highlight")
		highlight.Name = "PeabertHighlight"
		highlight.FillColor = Color3.fromRGB(0, 255, 0)
		highlight.FillTransparency = 0.5
		highlight.OutlineColor = Color3.fromRGB(255, 255, 255)
		highlight.DepthMode = Enum.HighlightDepthMode.AlwaysOnTop
		highlight.Parent = parent
		tbl11[parent] = highlight
	end

	local function fn13(arg)
		if tbl11[arg] then
			tbl11[arg]:Destroy()
			tbl11[arg] = nil
		end
	end

	local function fn14(arg)
		return arg:IsA("Model") and string.find(arg.Name, "FREEPEABERT")
	end

	local function fn15(descendant)
		if fn14(descendant) then
			tbl10[descendant] = true

			if tbl.peabertESPEnabled then
				fn12(descendant)
			end
		end
	end

	for _, descendant in pairs(workspace:GetDescendants()) do
		fn15(descendant)
	end

	workspace.DescendantAdded:Connect(fn15)

	workspace.DescendantRemoving:Connect(function(descendant)
		if tbl10[descendant] then
			tbl10[descendant] = nil
			fn13(descendant)
		end
	end)

	tbl6.GameToolsBox:Toggle({
		Title = "Peaberts ESP",
		Default = false,
		Callback = function(peabertESPEnabled)
			tbl.peabertESPEnabled = peabertESPEnabled

			if tbl.peabertESPEnabled then
				for k in pairs(tbl10) do
					if k and k.Parent then
						fn12(k)
					end
				end
			else
				for k in pairs(tbl10) do
					fn13(k)
				end
			end
		end,
	})

	local n = 0

	tbl6.GameToolsBox:Button({
		Title = "TP To Peabert",
		Callback = function()
			if tick() - n < 10 then
				fn5(" Cooldown", string.format("Wait %.1fs", 10 - tick() - n))
				return
			end
			local character = localPlayer.Character
			local humanoidRootPart = character and character:FindFirstChild("HumanoidRootPart")
			if not humanoidRootPart then
				return
			end
			local huge = math.huge
			local v3 = nil

			for k in pairs(tbl10) do
				if k and k.Parent then
					local basePart = k:FindFirstChildWhichIsA("BasePart", true)

					if basePart then
						local magnitude = (humanoidRootPart.Position - basePart.Position).Magnitude

						if magnitude < huge then
							huge = magnitude
							v3 = basePart
						end
					end
				end
			end

			if v3 then
				fn9(v3.CFrame * CFrame.new(0, 0, 3))
				n = tick()
				fn5(" Teleported", "Teleported to Peabert!")
			else
				fn5(" Error", "No Peaberts found on map!")
			end
		end,
	})
end

local connection4 = nil

tbl6.GameToolsBox:Toggle({
	Title = "Infinite Jump",
	Default = false,
	Callback = function(arg)
		if arg then
			if connection4 then
				return
			end

			connection4 = UserInputService.JumpRequest:Connect(function()
				local character = localPlayer.Character

				if character then
					local humanoid = character:FindFirstChildWhichIsA("Humanoid")

					if humanoid then
						humanoid:ChangeState(Enum.HumanoidStateType.Jumping)
					end
				end
			end)
		elseif connection4 then
			connection4:Disconnect()
			connection4 = nil
		end
	end,
})

tbl6.PowerOptionsBox = tbl5.Visual:Section({ Opened = true, Title = "| Power Options", Icon = "zap" })

tbl6.PowerOptionsBox:Toggle({
	Title = "Visual Ultra Instinct",
	Default = false,
	Callback = function(arg)
		if arg then
			pcall(function()
				if getgenv and getgenv()._UI_CLEANUP then
					getgenv()._UI_CLEANUP()
				end
			end)

			local Players2 = game:GetService("Players")
			game:GetService("TweenService")
			game:GetService("Debris")
			game:GetService("UserInputService")
			game:GetService("RunService")
			local ReplicatedStorage2 = game:GetService("ReplicatedStorage")
			local localPlayer2 = Players2.LocalPlayer
			local SharedFunctions = nil
			local Effects = nil
			local UIDodgeCLIENTEFFECTS = nil

			pcall(function()
				SharedFunctions = require(ReplicatedStorage2.Modules.SharedFunctions)
				Effects = require(ReplicatedStorage2.Modules.Effects)
				UIDodgeCLIENTEFFECTS = require(ReplicatedStorage2.Modules.AbilityEffectsModules.UIDodgeCLIENTEFFECTS)
			end)

			local tbl10 = {
				"rbxassetid://109819027147829",
				"rbxassetid://92129593029820",
				"rbxassetid://119518089922771",
				"rbxassetid://133278063201532",
				"rbxassetid://114251651938052",
			}

			local tbl11 = {
				"rbxassetid://117886505329162",
				"rbxassetid://72808867502440",
				"rbxassetid://94169703055500",
				"rbxassetid://94537387793682",
				"rbxassetid://82454268128485",
			}

			local n = 1
			local flag3 = false
			local value = 10
			local n2 = 10
			local tbl12 = {}
			local flag4 = true
			local intValue = Instance.new("IntValue")
			intValue.Value = value
			intValue:SetAttribute("MaxDodges", 10)

			local function fn12(parent)
				tbl12 = {}
				local animator = parent:FindFirstChildOfClass("Animator")

				if not animator then
					animator = Instance.new("Animator")
					animator.Parent = parent
				end

				for _, v3 in ipairs(tbl11) do
					local animation = Instance.new("Animation")
					animation.AnimationId = v3
					local v4 = animator:LoadAnimation(animation)
					v4.Priority = Enum.AnimationPriority.Action4
					table.insert(tbl12, v4)
				end
			end

			local function fn13(arg2)
				if not arg2 then
					return
				end

				for _, descendant in ipairs(arg2:GetDescendants()) do
					if descendant:IsA("ParticleEmitter") or descendant:IsA("Highlight") then
						if descendant.Name:find("UI_") or descendant.Name:find("Permanent_") or descendant.Name == "Highlight" then
							pcall(function()
								descendant:Destroy()
							end)
						end
					elseif descendant:IsA("Attachment") and (descendant.Name:find("UI_") or descendant.Name:find("Permanent_")) then
						pcall(function()
							descendant:Destroy()
						end)
					end
				end
			end

			local function fn14()
				pcall(function()
					intValue.Value = value

					if Effects and Effects.UltraInstinctDisplayDodge then
						Effects.UltraInstinctDisplayDodge({ Obj = intValue })
					end
				end)
			end

			local function fn15(arg2)
				if not arg2 then
					return
				end
				local humanoidRootPart = arg2:FindFirstChild("HumanoidRootPart")
				if not humanoidRootPart then
					return
				end

				if SharedFunctions and SharedFunctions.PlaySound then
					pcall(function()
						SharedFunctions.PlaySound(humanoidRootPart, "rbxassetid://121690585734302", 7)
					end)
				end

				if UIDodgeCLIENTEFFECTS then
					pcall(function()
						UIDodgeCLIENTEFFECTS({ ModuleName = "UIDodge", Character = arg2, initial = true })
					end)
				end

				pcall(function()
					local uiDodge = ReplicatedStorage2.Effects.SetupParts.CustomEffectsFolders:FindFirstChild("UIDodge")

					if uiDodge then
						for _, v3 in ipairs({ "Torso", "Head", "Left Arm", "Right Arm", "Left Leg", "Right Leg" }) do
							local v4 = arg2:FindFirstChild(v3)
							local v5 = uiDodge:FindFirstChild(v3)

							if v4 and v5 then
								for _, child in ipairs(v5:GetChildren()) do
									if child:IsA("ParticleEmitter") then
										local clone = child:Clone()
										clone.Parent = v4
										clone:Emit(clone:GetAttribute("EmitCount") or 15)

										task.delay(2.5, function()
											if clone and clone.Parent then
												clone:Destroy()
											end
										end)
									end
								end
							end
						end
					end
				end)
			end

			local function fn16()
				local character = localPlayer2.Character
				if not character then
					return
				end
				local humanoid = character:FindFirstChildOfClass("Humanoid")
				local humanoidRootPart = character:FindFirstChild("HumanoidRootPart")
				if not humanoid or not humanoidRootPart or humanoid.Health <= 0 then
					return
				end

				if flag3 then
					return
				end
				flag3 = true
				local v3 = n
				n = n % #tbl11 + 1

				if value > 0 then
					value -= 1
				else
					value = n2
				end

				fn14()

				pcall(function()
					local str2 = tbl10[v3] or "rbxassetid://109819027147829"

					if SharedFunctions and SharedFunctions.PlaySound then
						SharedFunctions.PlaySound(humanoidRootPart, str2, 7)
					end
				end)

				if #tbl12 == 0 then
					fn12(humanoid)
				end

				local v4 = tbl12[v3]

				if v4 then
					v4:Play(0.01, 1, 1.45)
				end

				if UIDodgeCLIENTEFFECTS then
					pcall(function()
						UIDodgeCLIENTEFFECTS({ ModuleName = "UIDodge", Character = character, dodgenumber = v3 })
					end)
				end

				local moveDirection = humanoid.MoveDirection

				if moveDirection.Magnitude < 0.1 then
					moveDirection = -humanoidRootPart.CFrame.LookVector
				end

				local n3 = moveDirection * 68 + Vector3.new(0, 4, 0)
				humanoidRootPart.AssemblyLinearVelocity = Vector3.new(n3.X, humanoidRootPart.AssemblyLinearVelocity.Y, n3.Z)

				task.delay(0.25, function()
					flag3 = false
				end)
			end

			local function fn17()
				local backpack = localPlayer2:FindFirstChild("Backpack")
				if not backpack then
					return
				end
				local ultraInstinct = backpack:FindFirstChild("Ultra Instinct") or localPlayer2.Character and localPlayer2.Character:FindFirstChild("Ultra Instinct")

				if ultraInstinct then
					pcall(function()
						ultraInstinct:Destroy()
					end)
				end

				local tool = Instance.new("Tool")
				tool.Name = "Ultra Instinct"
				tool.RequiresHandle = false
				tool.CanBeDropped = false
				tool.ToolTip = "Ultra Instinct"

				tool.Equipped:Connect(function()
					if localPlayer2.Character then
						fn15(localPlayer2.Character)
						fn16()
					end
				end)

				tool.Activated:Connect(function()
					fn16()
				end)

				tool.Parent = backpack

				task.spawn(function()
					local playerGui = localPlayer2:FindFirstChild("PlayerGui")
					playerGui = playerGui and playerGui:FindFirstChild("Hotbar")

					if playerGui then
						for _, descendant in ipairs(playerGui:GetDescendants()) do
							if descendant:IsA("TextButton") then
								local toolName = descendant:FindFirstChild("ToolName", true)

								if toolName and toolName.Text == "Ultra Instinct" then
									descendant.MouseButton1Click:Connect(function()
										if localPlayer2.Character then
											fn15(localPlayer2.Character)
										end

										fn16()
									end)
								end
							end
						end
					end
				end)
			end

			if localPlayer2.Character then
				fn13(localPlayer2.Character)
				local humanoid = localPlayer2.Character:FindFirstChildOfClass("Humanoid")

				if humanoid then
					fn12(humanoid)
				end

				fn15(localPlayer2.Character)
			end

			fn17()
			fn14()

			task.spawn(function()
				local n3 = 0

				while flag4 do
					task.wait(0.5)
					n3 += 0.5

					if n3 >= 4.5 then
						n3 = 0

						if value < n2 then
							value += 1
							fn14()
						end
					end
				end
			end)

			local connection5 = localPlayer2.CharacterAdded:Connect(function(character)
				fn13(character)
				local humanoid = character:WaitForChild("Humanoid", 5)

				if humanoid then
					fn12(humanoid)
				end

				task.wait(0.5)
				fn15(character)
				fn17()
				fn14()
			end)

			getgenv()._UI_CLEANUP = function()
				flag4 = false

				pcall(function()
					connection5:Disconnect()
				end)

				if localPlayer2.Character then
					fn13(localPlayer2.Character)
				end

				local backpack = localPlayer2:FindFirstChild("Backpack")

				if backpack then
					local ultraInstinct = backpack:FindFirstChild("Ultra Instinct")

					if ultraInstinct then
						pcall(function()
							ultraInstinct:Destroy()
						end)
					end
				end

				if localPlayer2.Character then
					local ultraInstinct = localPlayer2.Character:FindFirstChild("Ultra Instinct")

					if ultraInstinct then
						pcall(function()
							ultraInstinct:Destroy()
						end)
					end
				end

				pcall(function()
					intValue:Destroy()
				end)
			end
		else
			pcall(function()
				if getgenv and getgenv()._UI_CLEANUP then
					getgenv()._UI_CLEANUP()
					getgenv()._UI_CLEANUP = nil
				end
			end)
		end
	end,
})

tbl6.PowerOptionsBox:Toggle({
	Title = "Lightning God Awakening",
	Default = false,
	Callback = function(arg)
		if arg then
			pcall(function()
				if getgenv and getgenv()._LightningGodCleaner then
					pcall(getgenv()._LightningGodCleaner)
				end
			end)

			local Players2 = game:GetService("Players")
			local ReplicatedStorage2 = game:GetService("ReplicatedStorage")
			local TweenService = game:GetService("TweenService")
			local UserInputService_ = game:GetService("UserInputService")
			local RunService_ = game:GetService("RunService")
			local localPlayer2 = Players2.LocalPlayer
			local currentCamera = workspace.CurrentCamera
			local flag3 = false
			local v3 = nil
			local v4 = nil
			local connection5 = nil

			local function fn12()
				flag3 = false

				if connection5 then
					pcall(function()
						connection5:Disconnect()
					end)

					connection5 = nil
				end

				if currentCamera then
					currentCamera.CameraType = Enum.CameraType.Custom
					currentCamera.FieldOfView = 70
				end

				if v3 then
					pcall(function()
						v3:Stop(0.2)
					end)

					v3 = nil
				end

				if v4 then
					pcall(function()
						v4:Destroy()
					end)

					v4 = nil
				end

				local character = localPlayer2.Character

				if character then
					local humanoidRootPart = character:FindFirstChild("HumanoidRootPart")

					if humanoidRootPart then
						humanoidRootPart.Anchored = false
					end

					local humanoid = character:FindFirstChild("Humanoid")

					if humanoid then
						humanoid.AutoRotate = true
					end

					for _, child in ipairs(character:GetChildren()) do
						if child.Name == "LightningGodInterrupt" or child.Name:find("LightningGod") or child.Name == "eyes" or child.Name == "LingeringAura" then
							pcall(function()
								child:Destroy()
							end)
						end
					end
				end
			end

			local function fn13(arg2)
				local lightningAwakening = ReplicatedStorage2:FindFirstChild("CustomCameraModules") and ReplicatedStorage2.CustomCameraModules:FindFirstChild("LightningAwakening")
				if not lightningAwakening then
					return
				end
				local v5 = nil

				pcall(function()
					v5 = require(lightningAwakening)()
				end)

				if not v5 or not v5.Frames or not v5.FOV then
					return
				end
				local frames = v5.Frames
				local fov = v5.FOV
				local n = #frames
				currentCamera.CameraType = Enum.CameraType.Scriptable
				local n2 = 1

				if connection5 then
					connection5:Disconnect()
					connection5 = nil
				end

				connection5 = RunService_.RenderStepped:Connect(function(deltaTime)
					if not flag3 or not arg2 or not arg2.Parent then
						if connection5 then
							connection5:Disconnect()
							connection5 = nil
						end

						currentCamera.CameraType = Enum.CameraType.Custom
						currentCamera.FieldOfView = 70
						return
					end

					n2 += deltaTime * 60
					local n3 = math.floor(n2)

					if n < n3 then
						if connection5 then
							connection5:Disconnect()
							connection5 = nil
						end

						currentCamera.CameraType = Enum.CameraType.Custom
						TweenService:Create(currentCamera, TweenInfo.new(0.3, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), { FieldOfView = 70 }):Play()
						return
					end

					local v6 = frames[n3]
					local v7 = fov[n3]

					if v6 then
						local cframe = CFrame.new(v6[1], v6[2], v6[3], v6[4], v6[5], v6[6], v6[7], v6[8], v6[9], v6[10], v6[11], v6[12])
						currentCamera.CFrame = arg2.CFrame * CFrame.new(0, 1.2, 0) * cframe

						if v7 then
							currentCamera.FieldOfView = v7
						end
					end
				end)
			end

			local function fn14()
				if flag3 then
					return
				end
				local character = localPlayer2.Character
				if not character or not character.Parent then
					return
				end
				local humanoid = character:FindFirstChild("Humanoid")
				local humanoidRootPart = character:FindFirstChild("HumanoidRootPart")
				local animator = humanoid:FindFirstChild("Animator")
				if not humanoid or not humanoidRootPart or not animator or humanoid.Health <= 0 then
					return
				end
				fn12()
				flag3 = true
				humanoid.Health = humanoid.MaxHealth
				humanoidRootPart.Anchored = true
				humanoid.AutoRotate = false
				local lightningGodAwakening = ReplicatedStorage2:FindFirstChild("Animations") and ReplicatedStorage2.Animations:FindFirstChild("Abilities") and ReplicatedStorage2.Animations.Abilities:FindFirstChild("LightningGodAwakening")

				if lightningGodAwakening then
					v3 = animator:LoadAnimation(lightningGodAwakening)
					v3.Priority = Enum.AnimationPriority.Action4
					v3:Play(0.1)
				end

				fn13(humanoidRootPart)
				local folder = Instance.new("Folder")
				folder.Name = "LightningGodInterrupt"
				folder.Parent = character
				v4 = folder
				local lightninggodawakeningclienteffec = ReplicatedStorage2:FindFirstChild("Modules") and ReplicatedStorage2.Modules:FindFirstChild("AbilityEffectsModules") and ReplicatedStorage2.Modules.AbilityEffectsModules:FindFirstChild("LIGHTNINGGODAWAKENINGCLIENTEFFECTS")
				local length = v3 and v3.Length or 4.3

				if lightninggodawakeningclienteffec then
					local module = require(lightninggodawakeningclienteffec)

					task.spawn(function()
						module({
							ModuleName = "LIGHTNINGGODAWAKENING",
							Character = character,
							InterruptedFolder = folder,
							TimeLength = length,
						})
					end)
				end

				task.delay(length, function()
					if not flag3 then
						return
					end
					fn12()
				end)
			end

			local function fn15()
				local backpack = localPlayer2:FindFirstChild("Backpack")
				if not backpack then
					return
				end

				for _, child in ipairs(backpack:GetChildren()) do
					if child.Name == "Awakening" or child.Name == "⚡ Lightning God Awakening" or child.Name == "Lightning God Awakening" then
						child:Destroy()
					end
				end

				local character = localPlayer2.Character

				if character then
					for _, child in ipairs(character:GetChildren()) do
						if child:IsA("Tool") and (child.Name == "Awakening" or child.Name == "⚡ Lightning God Awakening" or child.Name == "Lightning God Awakening") then
							child:Destroy()
						end
					end
				end

				local tool = Instance.new("Tool")
				tool.Name = "Awakening"
				tool.RequiresHandle = false
				tool.CanBeDropped = false

				tool.Equipped:Connect(function()
					fn14()
				end)

				tool.Activated:Connect(function()
					fn14()
				end)

				tool.Parent = backpack
			end

			local connection6 = UserInputService_.InputBegan:Connect(function(input, gameProcessed)
				if gameProcessed then
					return
				end

				if input.KeyCode == Enum.KeyCode.G then
					fn14()
				end
			end)

			local connection7 = localPlayer2.CharacterAdded:Connect(function()
				task.wait(0.5)
				fn12()
				fn15()
			end)

			local playerGui = localPlayer2:FindFirstChild("PlayerGui")

			if playerGui then
				for _, v5 in ipairs({
					"LightningAwakeningGui",
					"LightningGodGui",
					"SoundDumpGui",
					"CodeDumpGui",
					"DeepSoundDumpGui",
				}) do
					local v6 = playerGui:FindFirstChild(v5)

					if v6 then
						v6:Destroy()
					end
				end
			end

			if localPlayer2.Character then
				fn15()
			end

			getgenv()._LightningGodCleaner = function()
				pcall(fn12)

				pcall(function()
					connection6:Disconnect()
				end)

				pcall(function()
					connection7:Disconnect()
				end)

				pcall(function()
					local backpack = localPlayer2:FindFirstChild("Backpack")

					if backpack then
						for _, child in ipairs(backpack:GetChildren()) do
							if child.Name == "Awakening" or child.Name == "⚡ Lightning God Awakening" or child.Name == "Lightning God Awakening" then
								child:Destroy()
							end
						end
					end
				end)

				pcall(function()
					local playerGui2 = localPlayer2:FindFirstChild("PlayerGui")

					if playerGui2 then
						for _, v5 in ipairs({
							"LightningAwakeningGui",
							"LightningGodGui",
							"SoundDumpGui",
							"CodeDumpGui",
							"DeepSoundDumpGui",
						}) do
							local v6 = playerGui2:FindFirstChild(v5)

							if v6 then
								v6:Destroy()
							end
						end
					end
				end)
			end
		else
			pcall(function()
				if getgenv and getgenv()._LightningGodCleaner then
					pcall(getgenv()._LightningGodCleaner)
					getgenv()._LightningGodCleaner = nil
				end
			end)
		end
	end,
})

tbl6.VisualGamepassBox = tbl5.Visual:Section({ Opened = true, Title = "| Gamepass Options", Icon = "credit-card" })

local function fn12(arg, arg2, arg3)
	local connection5 = nil

	tbl6.VisualGamepassBox:Toggle({
		Title = arg2,
		Default = false,
		Callback = function(arg4)
			if arg4 then
				localPlayer:SetAttribute(arg3, true)

				connection5 = localPlayer:GetAttributeChangedSignal(arg3):Connect(function()
					if not localPlayer:GetAttribute(arg3) then
						localPlayer:SetAttribute(arg3, true)
					end
				end)
			else
				if connection5 then
					connection5:Disconnect()
				end

				localPlayer:SetAttribute(arg3, nil)
			end
		end,
	})
end

fn12("VisualVIP", " Unlock VIP", "__OwnsVIPGamepass")
fn12("VisualLighter", " Unlock Lighter", "HasLighter")
fn12("Visual2X", " Unlock 2X Count", "__Owns2XVoteGamepass")
fn12("VisualGuard", " Unlock Guard Perm", "__OwnsPermGuard")
fn12("VisualGlass", " Unlock Glass Vision", "__OwnsGlassManufacturerVision")
fn12("VisualPSPlus", " Unlock PS Plus", "__OwnsPSPlus")
fn12("VisualEmotes", " Unlock Emote Pages", "__OwnsEmotePages")
_G.UniformColorValue = Color3.fromRGB(255, 255, 255)
tbl6.VisualClientBox = tbl5.Visual:Section({ Opened = true, Title = "| Client Options", Icon = "monitor" })
tbl6.CombatBox = tbl5.Combat:Section({ Opened = true, Title = "| Combat Features", Icon = "crosshair" })

do
	local tbl10 = { Enabled = false, Speed = 32, Connection = nil, BodyVelocity = nil }
	local v3 = nil
	local connection5 = nil
	local str2 = "112693580156198"
	local n = 0

	local function fn13(arg)
		pcall(function()
			if v3 then
				v3:Stop(0)
				v3:AdjustWeight(0)
				v3:Destroy()
				v3 = nil
			end
		end)

		if not arg then
			return
		end
		local animator = arg:FindFirstChildOfClass("Animator")

		if animator then
			pcall(function()
				for _, v4 in ipairs(animator:GetPlayingAnimationTracks()) do
					if tostring(v4.Animation and v4.Animation.AnimationId or ""):find("112693580156198") then
						v4:Stop(0)
						v4:AdjustWeight(0)
						v4:Destroy()
					end
				end
			end)
		end

		pcall(function()
			for _, v4 in ipairs(arg:GetPlayingAnimationTracks()) do
				if tostring(v4.Animation and v4.Animation.AnimationId or ""):find("112693580156198") then
					v4:Stop(0)
					v4:AdjustWeight(0)
					v4:Destroy()
				end
			end
		end)
	end

	local function fn14(arg)
		if not arg or not tbl10.Enabled or n > 0 then
			return
		end
		local animator = arg:FindFirstChildOfClass("Animator")
		if not animator then
			return
		end

		pcall(function()
			if not v3 or v3.Parent ~= animator then
				local animation = Instance.new("Animation")
				animation.AnimationId = "rbxassetid://" .. str2
				v3 = animator:LoadAnimation(animation)
				v3.Priority = Enum.AnimationPriority.Core
				v3.Looped = true
			end

			if not v3.IsPlaying and n == 0 then
				v3:Play(0.15)
				v3.Looped = true
			end
		end)
	end

	local fn15 = nil

	fn15 = function(arg)
		if arg then
			if tbl10.Enabled then
				return
			end
			tbl10.Enabled = true
			n = 0
			local character = localPlayer.Character
			if not character then
				return
			end
			local humanoid = character:FindFirstChildOfClass("Humanoid")
			local humanoidRootPart = character:FindFirstChild("HumanoidRootPart")
			if not (humanoid and humanoidRootPart) then
				return
			end
			humanoid.UseJumpPower = false
			humanoid.AutoRotate = false
			humanoid.PlatformStand = true

			if tbl10.BodyVelocity then
				pcall(function()
					tbl10.BodyVelocity:Destroy()
				end)

				tbl10.BodyVelocity = nil
			end

			local bodyVelocity = Instance.new("BodyVelocity")
			bodyVelocity.Name = "FlyBodyVelocity"
			bodyVelocity.MaxForce = Vector3.new(40000, 40000, 40000)
			bodyVelocity.Velocity = Vector3.zero
			bodyVelocity.Parent = humanoidRootPart
			tbl10.BodyVelocity = bodyVelocity
			local animator = humanoid:FindFirstChildOfClass("Animator")

			if animator then
				pcall(function()
					for _, v4 in ipairs(animator:GetPlayingAnimationTracks()) do
						local flag3 = not tostring(v4.Animation and v4.Animation.AnimationId or ""):find("112693580156198")

						if flag3 then
							flag3 = v4.Priority == Enum.AnimationPriority.Action or v4.Priority == Enum.AnimationPriority.Action2 or v4.Priority == Enum.AnimationPriority.Action3 or v4.Priority == Enum.AnimationPriority.Action4
						end

						if flag3 then
							n += 1
						end
					end
				end)

				fn14(humanoid)

				if connection5 then
					pcall(function()
						connection5:Disconnect()
					end)

					connection5 = nil
				end

				connection5 = animator.AnimationPlayed:Connect(function(arg2)
					if not tbl10.Enabled then
						return
					end

					if not tostring(arg2.Animation and arg2.Animation.AnimationId or ""):find("112693580156198") then
						n += 1

						if v3 and v3.IsPlaying then
							pcall(function()
								v3:Stop(0.05)
							end)
						end

						local connection6 = nil

						connection6 = arg2.Stopped:Connect(function()
							if connection6 then
								pcall(function()
									connection6:Disconnect()
								end)
							end

							n = math.max(0, n - 1)

							if tbl10.Enabled and n == 0 and humanoid and humanoid.Health > 0 then
								fn14(humanoid)
							end
						end)
					end
				end)
			end

			local RunService_ = game:GetService("RunService")
			local UserInputService_ = game:GetService("UserInputService")

			tbl10.Connection = RunService_.Heartbeat:Connect(function()
				if not tbl10.Enabled or not character or not character.Parent then
					fn15(false)
					return
				end
				humanoidRootPart = character:FindFirstChild("HumanoidRootPart")
				humanoid = character:FindFirstChildOfClass("Humanoid")
				if not humanoidRootPart or not bodyVelocity or not humanoid or humanoid.Health <= 0 then
					fn15(false)
					return
				end
				local currentCamera = workspace.CurrentCamera
				if not currentCamera then
					return
				end
				local cFrame = currentCamera.CFrame
				local lookVector = cFrame.LookVector
				local rightVector = cFrame.RightVector
				local upVector = cFrame.UpVector
				local vector = Vector3.zero
				local flag3 = false

				if UserInputService_:IsKeyDown(Enum.KeyCode.W) then
					vector = Vector3.zero + lookVector
					flag3 = true
				end

				if UserInputService_:IsKeyDown(Enum.KeyCode.S) then
					vector -= lookVector
					flag3 = true
				end

				if UserInputService_:IsKeyDown(Enum.KeyCode.A) then
					vector -= rightVector
					flag3 = true
				end

				if UserInputService_:IsKeyDown(Enum.KeyCode.D) then
					vector += rightVector
					flag3 = true
				end

				if UserInputService_:IsKeyDown(Enum.KeyCode.Space) then
					vector += upVector
					flag3 = true
				end

				local flag4

				if not flag3 then
					local moveDirection = humanoid.MoveDirection

					if not (moveDirection.Magnitude > 0.1) then
						flag4 = flag3
					else
						vector = lookVector * moveDirection.Z + rightVector * moveDirection.X + upVector * moveDirection.Y
						flag4 = true
					end
				else
					flag4 = flag3
				end

				if flag4 and vector.Magnitude > 0 then
					bodyVelocity.Velocity = vector.Unit * tbl10.Speed
				else
					bodyVelocity.Velocity = Vector3.zero
				end
			end)
		else
			if not tbl10.Enabled then
				return
			end
			tbl10.Enabled = false
			n = 0

			if tbl10.Connection then
				pcall(function()
					tbl10.Connection:Disconnect()
				end)

				tbl10.Connection = nil
			end

			if connection5 then
				pcall(function()
					connection5:Disconnect()
				end)

				connection5 = nil
			end

			if tbl10.BodyVelocity then
				pcall(function()
					tbl10.BodyVelocity:Destroy()
				end)

				tbl10.BodyVelocity = nil
			end

			local character = localPlayer.Character

			if character then
				local humanoid = character:FindFirstChildOfClass("Humanoid")

				if humanoid then
					fn13(humanoid)

					pcall(function()
						humanoid.UseJumpPower = true
						humanoid.AutoRotate = true
						humanoid.PlatformStand = false
						humanoid:ChangeState(Enum.HumanoidStateType.GettingUp)
					end)

					task.defer(function()
						pcall(function()
							if humanoid and humanoid.Health > 0 then
								humanoid:ChangeState(Enum.HumanoidStateType.Running)
							end
						end)
					end)
				end

				local humanoidRootPart = character:FindFirstChild("HumanoidRootPart")

				if humanoidRootPart then
					pcall(function()
						humanoidRootPart.AssemblyLinearVelocity = Vector3.zero
					end)
				end

				local animate = character:FindFirstChild("Animate")

				if animate and animate:IsA("LocalScript") then
					pcall(function()
						animate.Disabled = true

						task.delay(0.05, function()
							pcall(function()
								animate.Disabled = false
							end)
						end)
					end)
				end
			end
		end
	end

	local v4 = nil
	local u = Enum.KeyCode.U

	tbl6.CombatBox:Keybind({
		Title = "Fly Keybind",
		Value = "U",
		Default = "U",
		Callback = function(arg)
			if arg then
				if typeof(arg) == "EnumItem" then
					u = arg
				elseif typeof(arg) == "string" and Enum.KeyCode[arg] then
					u = Enum.KeyCode[arg]
				end
			end
		end,
	})

	game:GetService("UserInputService").InputBegan:Connect(function(input, gameProcessed)
		if gameProcessed then
			return
		end

		if input.KeyCode == u and u ~= Enum.KeyCode.Unknown then
			if v4 and v4.Set then
				v4:Set(not tbl10.Enabled)
			else
				fn15(not tbl10.Enabled)
			end
		end
	end)

	v4 = tbl6.CombatBox:Toggle({
		Title = "Fly",
		Default = false,
		Callback = function(arg)
			fn15(arg)
		end,
	})
end

do
	local flag3 = false
	local connection5 = nil
	local tbl10 = { "Action", "LightAction", "HeavyAction", "Slowed", "NoAttack", "Stun", "Freeze", "Attacking" }
	local tbl11 = { "Action", "LightAction", "Slowed", "Stun", "Freeze", "Ragdoll" }

	tbl6.CombatBox:Toggle({
		Title = "Anti Slow",
		Default = false,
		Callback = function(arg)
			flag3 = arg

			if arg then
				if connection5 then
					return
				end

				connection5 = game:GetService("RunService").Heartbeat:Connect(function()
					if not flag3 then
						return
					end

					pcall(function()
						if shared then
							shared.WalkSpeedChangeTick = nil

							if shared.IsInCutscene then
								shared.IsInCutscene = nil
							end
						end

						local playerScripts = localPlayer:FindFirstChild("PlayerScripts")

						if playerScripts then
							local playerModule = playerScripts:FindFirstChild("PlayerModule")

							if playerModule then
								local controls = require(playerModule):GetControls()

								if controls and controls.Enable then
									controls:Enable(true)
								end
							end
						end

						local character = localPlayer.Character
						if not character then
							return
						end
						local humanoid = character:FindFirstChildOfClass("Humanoid")
						character:FindFirstChild("HumanoidRootPart")

						for _, v3 in ipairs(tbl10) do
							if character:GetAttribute(v3) ~= nil then
								character:SetAttribute(v3, nil)
							end

							if humanoid and humanoid:GetAttribute(v3) ~= nil then
								humanoid:SetAttribute(v3, nil)
							end
						end

						if humanoid then
							local StarterPlayer = game:GetService("StarterPlayer")
							local characterWalkSpeed = StarterPlayer.CharacterWalkSpeed or 16
							local characterJumpPower = StarterPlayer.CharacterJumpPower or 50

							if humanoid.WalkSpeed < characterWalkSpeed then
								humanoid.WalkSpeed = characterWalkSpeed
							end

							if humanoid.JumpPower < characterJumpPower then
								humanoid.JumpPower = characterJumpPower
							end

							if humanoid.PlatformStand then
								humanoid.PlatformStand = false
							end
						end

						for _, v3 in ipairs(tbl11) do
							local v4 = character:FindFirstChild(v3)

							if v4 then
								v4:Destroy()
							end
						end
					end)
				end)
			elseif connection5 then
				pcall(function()
					connection5:Disconnect()
				end)

				connection5 = nil
			end
		end,
	})
end

local function fn13()
	local humanoidRootPart = localPlayer.Character and localPlayer.Character:FindFirstChild("HumanoidRootPart")
	if not humanoidRootPart then
		return nil
	end
	local huge = math.huge
	local v3 = nil

	for _, player in ipairs(Players:GetPlayers()) do
		if player ~= localPlayer and player.Character then
			local humanoidRootPart2 = player.Character:FindFirstChild("HumanoidRootPart")
			local humanoid = player.Character:FindFirstChild("Humanoid")

			if humanoidRootPart2 and humanoid and humanoid.Health > 0 then
				local magnitude = (humanoidRootPart.Position - humanoidRootPart2.Position).Magnitude

				if magnitude < huge then
					huge = magnitude
					v3 = player
				end
			end
		end
	end

	return v3
end

tbl6.CombatBox:Toggle({
	Title = "CamLock (Auto Games)",
	Default = false,
	Callback = function(camLockEnabled)
		_G.CamLockEnabled = camLockEnabled

		if camLockEnabled then
			if not _G.CamLockSearchThread then
				_G.CamLockSearchThread = true

				task.spawn(function()
					while _G.CamLockSearchThread do
						if (fn4("LightsOut") or fn4("Mingle") or fn4("SkySquidGame") or fn4("SquidGame") or fn4("LastDinner")) and _G.CamLockEnabled then
							camLockClosestPlayer = fn13()
						else
							camLockClosestPlayer = nil
						end

						task.wait(0.2)
					end
				end)
			end

			if not _G.CamLockBound then
				_G.CamLockBound = true

				game:GetService("RunService"):BindToRenderStep("UwUCamLock", Enum.RenderPriority.Camera.Value + 1, function()
					if _G.CamLockEnabled and camLockClosestPlayer and camLockClosestPlayer.Character then
						local humanoidRootPart = camLockClosestPlayer.Character:FindFirstChild("HumanoidRootPart")
						local currentCamera = workspace.CurrentCamera

						if humanoidRootPart and currentCamera then
							currentCamera.CFrame = CFrame.new(currentCamera.CFrame.Position, humanoidRootPart.Position)
						end
					end
				end)
			end
		else
			_G.CamLockSearchThread = false

			if _G.CamLockBound then
				game:GetService("RunService"):UnbindFromRenderStep("UwUCamLock")
				_G.CamLockBound = false
			end

			camLockClosestPlayer = nil
		end
	end,
})

do
	local flag3 = false

	local function fn14(arg)
		if arg.PacketId == 27 then
			local asBuffer = arg.AsBuffer

			if buffer and buffer.writeu32 then
				buffer.writeu32(asBuffer, 1, 4294967295)
				arg:SetData(asBuffer)
			end
		end
	end

	tbl6.CombatBox:Toggle({
		Title = "Desync",
		Locked = true,
		Default = false,
		Callback = function(arg)
			if not pcall(function()
				return raknet and raknet.add_send_hook
			end) then
				fn5("Combat", "Unsupported Executor")
				return
			end

			if arg then
				if not flag3 then
					pcall(function()
						raknet.add_send_hook(fn14)
						flag3 = true
					end)
				end
			elseif flag3 then
				pcall(function()
					raknet.remove_send_hook(fn14)
					flag3 = false
				end)
			end
		end,
	})
end

tbl6.VisualClientBox:Toggle({
	Title = "Set Uniform Skin",
	Default = false,
	Callback = function(setUniformSkinEnabled)
		_G.SetUniformSkinEnabled = setUniformSkinEnabled
		localPlayer:SetAttribute("ClothingColorToggle", setUniformSkinEnabled)

		if setUniformSkinEnabled and _G.UniformColorValue then
			localPlayer:SetAttribute("ClothingColor", _G.UniformColorValue)
		end
	end,
})

tbl6.VisualClientBox:Colorpicker({
	Default = Color3.fromRGB(255, 255, 255),
	Title = "Uniform Skin Color",
	Callback = function(uniformColorValue)
		_G.UniformColorValue = uniformColorValue

		if _G.SetUniformSkinEnabled then
			localPlayer:SetAttribute("ClothingColor", _G.UniformColorValue)
		end
	end,
})

_G.CustomPlayerNumber = 456
_G.CustomPlayerNumberEnabled = false

tbl6.VisualClientBox:Input({
	Default = "456",
	Numeric = true,
	Finished = false,
	Title = "Custom Player Number",
	Tooltip = "Change your overhead/chat number (e.g. 456)",
	Callback = function(arg)
		_G.CustomPlayerNumber = tonumber(arg) or 456
	end,
})

tbl6.VisualClientBox:Toggle({
	Title = "Enable Custom Tag",
	Default = false,
	Callback = function(customPlayerNumberEnabled)
		_G.CustomPlayerNumberEnabled = customPlayerNumberEnabled

		if customPlayerNumberEnabled then
			task.spawn(function()
				while _G.CustomPlayerNumberEnabled do
					local playerTagValue = localPlayer:FindFirstChild("PlayerTagValue")
					local customPlayerNumber = _G.CustomPlayerNumber or 456
					local text = tostring(customPlayerNumber)

					if string.len(text) < 3 then
						text = string.rep("0", 3 - string.len(text)) .. text
					end

					if playerTagValue and playerTagValue.Value ~= customPlayerNumber then
						playerTagValue.Value = customPlayerNumber
					end

					local character = localPlayer.Character

					if character then
						for _, descendant in ipairs(character:GetDescendants()) do
							if descendant:IsA("TextLabel") and descendant.Parent:IsA("SurfaceGui") then
								descendant.Text = text
							end
						end
					end

					task.wait(0.5)
				end
			end)
		end
	end,
})

_G.CustomWinsValue = 100
_G.CustomWinsEnabled = false

tbl6.VisualClientBox:Input({
	Default = "100",
	Numeric = true,
	Finished = false,
	Title = "Custom Wins",
	Tooltip = "Change your visual total wins",
	Callback = function(arg)
		_G.CustomWinsValue = tonumber(arg) or 100
	end,
})

tbl6.VisualClientBox:Toggle({
	Title = "Enable Custom Wins",
	Default = false,
	Callback = function(customWinsEnabled)
		_G.CustomWinsEnabled = customWinsEnabled

		if customWinsEnabled then
			task.spawn(function()
				while _G.CustomWinsEnabled do
					local customWinsValue = _G.CustomWinsValue

					if localPlayer:GetAttribute("_GameWins") ~= customWinsValue then
						localPlayer:SetAttribute("_GameWins", _G.CustomWinsValue)
					end

					task.wait(0.5)
				end
			end)
		end
	end,
})

_G.CustomWinStreakValue = 10
_G.CustomWinStreakEnabled = false

tbl6.VisualClientBox:Input({
	Default = "10",
	Numeric = true,
	Finished = false,
	Title = "Custom Win Streak",
	Tooltip = "Change your visual win streak",
	Callback = function(arg)
		_G.CustomWinStreakValue = tonumber(arg) or 10
	end,
})

tbl6.VisualClientBox:Toggle({
	Title = "Enable Custom Win Streak",
	Default = false,
	Callback = function(customWinStreakEnabled)
		_G.CustomWinStreakEnabled = customWinStreakEnabled

		if customWinStreakEnabled then
			task.spawn(function()
				while _G.CustomWinStreakEnabled do
					local customWinStreakValue = _G.CustomWinStreakValue

					if localPlayer:GetAttribute("_ConsecutiveWins") ~= customWinStreakValue then
						localPlayer:SetAttribute("_ConsecutiveWins", _G.CustomWinStreakValue)
					end

					task.wait(0.5)
				end
			end)
		end
	end,
})

do
	local tbl10 = {
		{
			Name = "Dream Journal",
			AnimId = "rbxassetid://117325441970867",
			SoundId = "rbxassetid://88476306353688",
			Volume = 10,
		},
		{
			Name = "Otsukare Summer",
			AnimId = "rbxassetid://134888005420629",
			SoundId = "rbxassetid://127332409398776",
			Volume = 3,
		},
		{
			Name = "Spite",
			AnimId = "rbxassetid://100382123964355",
			SoundId = "rbxassetid://90513005423910",
			Volume = 5,
		},
		{
			Name = "Posing Time",
			AnimId = "rbxassetid://89240795237958",
			SoundId = "rbxassetid://113259086406604",
			Volume = 5,
		},
		{
			Name = "Shuffle",
			AnimId = "rbxassetid://113121578988536",
			SoundId = "rbxassetid://127426881747595",
			Volume = 5,
		},
		{
			Name = "Yare Yare",
			AnimId = "rbxassetid://86642655479570",
			SoundId = "rbxassetid://128193072645447",
			Volume = 5,
		},
		{
			Name = "My Perfect Victory",
			AnimId = "rbxassetid://110501561372722",
			SoundId = "rbxassetid://104280886491008",
			Volume = 5,
		},
		{
			Name = "Fate Of Both Worlds",
			AnimId = "rbxassetid://114244682550258",
			SoundId = "rbxassetid://103081000050688",
			Volume = 5,
		},
		{
			Name = "Peanut of Butter House",
			AnimId = "rbxassetid://108074529570331",
			SoundId = "rbxassetid://95893903149232",
			Volume = 5,
		},
		{
			Name = "Cat Hands",
			AnimId = "rbxassetid://87331103640233",
			SoundId = "rbxassetid://126527049854337",
			Volume = 5,
		},
		{
			Name = "The System",
			AnimId = "rbxassetid://117978762262770",
			SoundId = "rbxassetid://73318799732606",
			Volume = 5,
		},
		{ Name = "Gear 5", AnimId = "rbxassetid://107815350238463", SoundId = nil, Volume = 5 },
		{
			Name = "Mingle Dance",
			AnimId = "rbxassetid://99559083669885",
			SoundId = "rbxassetid://89379201770587",
			Volume = 5,
		},
		{
			Name = "Metro Dance",
			AnimId = "rbxassetid://104701586795462",
			SoundId = "rbxassetid://95730226592096",
			Volume = 5,
		},
		{
			Name = "Funeral for the living",
			AnimId = "rbxassetid://123297701965318",
			SoundId = "rbxassetid://105930820096344",
			Volume = 5,
		},
		{
			Name = "Cartwheel",
			AnimId = "rbxassetid://131418698864660",
			SoundId = "rbxassetid://18911882091",
			Volume = 5,
		},
		{
			Name = "Lively Walk",
			AnimId = "rbxassetid://99556634315867",
			SoundId = "rbxassetid://16706317921",
			Volume = 5,
		},
		{
			Name = "Dance of nights",
			AnimId = "rbxassetid://100183800468181",
			SoundId = "rbxassetid://133365635431929",
			Volume = 5,
		},
		{
			Name = "Sonic run",
			AnimId = "rbxassetid://120151271879240",
			SoundId = "rbxassetid://131594734029433",
			Volume = 5,
		},
		{
			Name = "Khabilame",
			AnimId = "rbxassetid://133158883386630",
			SoundId = "rbxassetid://131852145461258",
			Volume = 5,
		},
		{
			Name = "Mii swing",
			AnimId = "rbxassetid://111293910946685",
			SoundId = "rbxassetid://121596432073446",
			Volume = 5,
		},
		{
			Name = "Jackpot",
			AnimId = "rbxassetid://90063856357375",
			SoundId = "rbxassetid://96528255406149",
			Volume = 5,
		},
		{
			Name = "Scuba",
			AnimId = "rbxassetid://125809050313880",
			SoundId = "rbxassetid://78439444151879",
			Volume = 5,
		},
		{
			Name = "Crying",
			AnimId = "rbxassetid://96313533433486",
			SoundId = "rbxassetid://18151791880",
			Volume = 5,
		},
		{
			Name = "Ogame",
			AnimId = "rbxassetid://117778295104747",
			SoundId = "rbxassetid://122457089809687",
			Volume = 5,
		},
		{
			Name = "Blue Shirt Kid",
			AnimId = "rbxassetid://83396620848313",
			SoundId = "rbxassetid://115875415839739",
			Volume = 5,
		},
		{ Name = "Zepelli", AnimId = "rbxassetid://135418027114658", SoundId = nil, Volume = 5 },
		{
			Name = "Woke Up The World",
			AnimId = "rbxassetid://130106286443990",
			SoundId = "rbxassetid://0275579621574",
			Volume = 5,
		},
		{
			Name = "Mask",
			AnimId = "rbxassetid://102176887169297",
			SoundId = "rbxassetid://97952595881264",
			Volume = 5,
		},
	}

	local v3 = nil
	local v4 = nil
	local flag3 = false
	local name = tbl10[1].Name

	local function fn14()
		if v3 then
			pcall(function()
				v3:Stop()
			end)

			v3 = nil
		end

		if v4 then
			pcall(function()
				v4:Stop()
			end)

			pcall(function()
				v4:Destroy()
			end)

			v4 = nil
		end

		flag3 = false
	end

	local function fn15(arg)
		fn14()
		local character = localPlayer.Character
		if not character then
			return
		end
		local humanoid = character:FindFirstChildOfClass("Humanoid")
		if not humanoid then
			return
		end
		local animation = Instance.new("Animation")
		animation.AnimationId = arg.AnimId
		v3 = humanoid:LoadAnimation(animation)
		v3:Play()

		if arg.SoundId then
			local sound = Instance.new("Sound")
			sound.SoundId = arg.SoundId
			sound.Volume = arg.Volume or 5
			sound.Looped = true
			sound.Parent = game:GetService("SoundService")
			sound:Play()
			v4 = sound
		end

		flag3 = true
		fn5("Emote", "Playing: " .. arg.Name)
	end

	local tbl11 = {}

	for _, v5 in ipairs(tbl10) do
		table.insert(tbl11, v5.Name)
	end

	tbl6.EmoteBox = tbl5.Visual:Section({ Opened = true, Title = "| Emote Player", Icon = "smile" })

	tbl6.EmoteBox:Dropdown({
		Title = "Select Emote",
		Values = tbl11,
		Default = tbl11[1],
		Callback = function(arg)
			name = arg
		end,
	})

	tbl6.EmoteBox:Button({
		Title = "Play Emote",
		Callback = function()
			for _, v5 in ipairs(tbl10) do
				if v5.Name == name then
					fn15(v5)
					break
				end
			end
		end,
	})

	tbl6.EmoteBox:Button({
		Title = "Stop Emote",
		Callback = function()
			fn14()
			fn5("Emote", "Stopped emote")
		end,
	})

	task.spawn(function()
		while task.wait(0.5) do
			if flag3 then
				local character = localPlayer.Character

				if character then
					local humanoid = character:FindFirstChildOfClass("Humanoid")

					if humanoid and humanoid.MoveDirection.Magnitude > 0 then
						fn14()
					end
				end
			end
		end
	end)
end

tbl6.RagebaitEmoteBox = tbl5.Visual:Section({ Opened = true, Title = "| Ragebait Emote", Icon = "flame" })

do
	local str2 = "Rage Emote 1"
	local v3 = nil
	local flag3 = false

	local function fn14()
		if v3 then
			pcall(function()
				v3:Stop(0.15)
				v3:Destroy()
			end)

			v3 = nil
		end

		flag3 = false
	end

	local function fn15(arg)
		fn14()
		local character = localPlayer.Character
		if not character then
			return
		end
		local humanoid = character:FindFirstChildOfClass("Humanoid")
		if not humanoid or humanoid.Health <= 0 then
			return
		end
		local animator = humanoid:FindFirstChildOfClass("Animator")
		if not animator then
			return
		end
		local animationId

		if arg == "Rage Emote 1" then
			animationId = "rbxassetid://83396620848313"
		elseif arg == "Rage Emote 2" then
			animationId = "rbxassetid://111293910946685"
		elseif arg == "Rage Emote 3" then
			animationId = "rbxassetid://129390844140095"
		else
			animationId = nil

			if arg == "Rage Emote 4" then
				animationId = "rbxassetid://72042024"
			end
		end

		if animationId then
			local animation = Instance.new("Animation")
			animation.AnimationId = animationId

			pcall(function()
				v3 = animator:LoadAnimation(animation)
				v3.Priority = Enum.AnimationPriority.Action4
				v3.Looped = true
				v3:Play(0.15)
				flag3 = true
			end)
		end
	end

	tbl6.RagebaitEmoteBox:Dropdown({
		Title = "Select Rage Emote",
		Values = { "Rage Emote 1", "Rage Emote 2", "Rage Emote 3", "Rage Emote 4" },
		Default = "Rage Emote 1",
		Callback = function(arg)
			str2 = arg

			if flag3 then
				fn15(str2)
			end
		end,
	})

	tbl6.RagebaitEmoteBox:Button({
		Title = "Start / Stop",
		Callback = function()
			if flag3 then
				fn14()
				fn5("Ragebait", "Emote stopped")
			else
				fn15(str2)
				fn5("Ragebait", "Playing " .. tostring(str2))
			end
		end,
	})

	localPlayer.CharacterAdded:Connect(function()
		fn14()
	end)
end

tbl.fpsBoosterEnabled = false

tbl6.GameToolsBox:Toggle({
	Title = "FPS Booster / Anti-Lag",
	Default = false,
	Callback = function(fpsBoosterEnabled)
		tbl.fpsBoosterEnabled = fpsBoosterEnabled
		local Lighting = game:GetService("Lighting")
		local terrain = workspace:FindFirstChildOfClass("Terrain")

		if tbl.fpsBoosterEnabled then
			if terrain then
				terrain.WaterWaveSize = 0
				terrain.WaterWaveSpeed = 0
				terrain.WaterReflectance = 0
				terrain.WaterTransparency = 0
			end

			Lighting.GlobalShadows = false
			Lighting.FogEnd = 9e9
			Lighting.Brightness = 1
			settings().Rendering.QualityLevel = "Level01"

			for _, descendant in pairs(workspace:GetDescendants()) do
				if descendant:IsA("Part") or descendant:IsA("Union") or descendant:IsA("CornerWedgePart") or descendant:IsA("TrussPart") then
					descendant.Material = "Plastic"
					descendant.Reflectance = 0
				elseif descendant:IsA("Decal") or descendant:IsA("Texture") and descendant.Name ~= "TOWDecal" then
					descendant.Transparency = 1
				elseif descendant:IsA("ParticleEmitter") or descendant:IsA("Trail") then
					descendant.Lifetime = NumberRange.new(0)
				elseif descendant:IsA("Explosion") then
					descendant.BlastPressure = 1
					descendant.BlastRadius = 1
				end
			end
		else
			if terrain then
				terrain.WaterWaveSize = 0.15
				terrain.WaterWaveSpeed = 10
				terrain.WaterReflectance = 1
				terrain.WaterTransparency = 1
			end

			Lighting.GlobalShadows = true
			settings().Rendering.QualityLevel = "Automatic"
		end
	end,
})

tbl2.autoVoteThread = false
tbl6.AutoVoteBox = tbl5.Tools:Section({ Opened = true, Title = "| Auto Vote", Icon = "check" })

tbl6.AutoVoteBox:Dropdown({
	Values = { "None", "Dalgona", "Pentathlon" },
	Default = 1,
	Multi = false,
	Title = "Vote 1: Dalgona/Pentathlon",
})

tbl6.AutoVoteBox:Dropdown({
	Values = { "None", "Hide And Seek", "Tug Of War" },
	Default = 1,
	Multi = false,
	Title = "Vote 2: Hide/Tug",
})

tbl6.AutoVoteBox:Dropdown({
	Values = { "None", "Jump Rope", "Glass Bridge" },
	Default = 1,
	Multi = false,
	Title = "Vote 3: Jump/Glass",
})

tbl6.AutoVoteBox:Dropdown({
	Values = { "None", "Continue", "Rebel" },
	Default = 1,
	Multi = false,
	Title = "Vote 4: Rebel/Continue",
})

tbl6.AutoVoteBox:Toggle({
	Title = "Enable Auto Vote",
	Default = false,
	Callback = function(autoVoteThread)
		tbl2.autoVoteThread = autoVoteThread

		if autoVoteThread then
			task.spawn(function()
				while tbl2.autoVoteThread do
					local ReplicatedStorage2 = game:GetService("ReplicatedStorage")

					if ReplicatedStorage2:FindFirstChild("Remotes") and ReplicatedStorage2.Remotes:FindFirstChild("ExtraTemporaryRemote") then
						local playerGui = localPlayer:WaitForChild("PlayerGui", 2)

						if playerGui then
							local votingToPickGames = playerGui:FindFirstChild("VotingToPickGames", true)
							local votingToEndGames = playerGui:FindFirstChild("VotingToEndGames", true)

							if votingToPickGames and votingToPickGames:FindFirstChild("VotingBoardLeft") and votingToPickGames:FindFirstChild("VotingBoardRight") and votingToPickGames.VotingBoardLeft.Visible then
								local attribute = votingToPickGames:GetAttribute("NewString")

								if attribute ~= "PentathlonOrDalgonaVote" then
									if attribute ~= "HideAndSeekOrTugOfWarVote" then
									end
								end

								if votingToPickGames:FindFirstChild("VotingBoardLeft") then
									votingToPickGames.VotingBoardLeft.Visible = false
								end

								if votingToPickGames:FindFirstChild("VotingBoardRight") then
									votingToPickGames.VotingBoardRight.Visible = false
								end
							end

							if votingToEndGames and votingToEndGames:FindFirstChild("VotingBoard") and votingToEndGames.VotingBoard.Visible then
								if votingToEndGames:FindFirstChild("VotingBoard") then
									votingToEndGames.VotingBoard.Visible = false
								end
							end
						end
					end

					task.wait(1)
				end
			end)
		end
	end,
})

--==================================================--
--         AUTO NEXT GAME (TOOLS TAB - NEW)          --
--==================================================--
tbl6.AutoNextGameBox = tbl5.Tools:Section({ Opened = true, Title = "| Auto Next Game", Icon = "skip-forward" })

do
	local TargetPos = Vector3.new(-214.3, 186.86, 242.64)
	local Radius = 80
	local RequiredTime = 3.4

	local AutoNextEnabled = false
	local AutoNextConn = nil
	local Timer = 0

	tbl6.AutoNextGameBox:Toggle({
		Title = "Auto Next Game",
		Default = false,
		Callback = function(autoNextEnabled)
			AutoNextEnabled = autoNextEnabled and true or false

			if AutoNextConn then
				AutoNextConn:Disconnect()
				AutoNextConn = nil
			end

			if AutoNextEnabled then
				Timer = 0
				fn5("Auto Next Game", "Auto Next Game Enabled")

				AutoNextConn = game:GetService("RunService").Heartbeat:Connect(function(deltaTime)
					if not AutoNextEnabled then
						return
					end

					local character = localPlayer.Character
					local position = character and character.PrimaryPart and character.PrimaryPart.Position

					if position and (position - TargetPos).Magnitude <= Radius then
						Timer += deltaTime

						if Timer >= RequiredTime then
							Timer = 0

							pcall(function()
								ReplicatedStorage:WaitForChild("Remotes"):WaitForChild("TemporaryReachedBindable"):FireServer()
							end)
						end
					else
						Timer = 0
					end
				end)
			else
				fn5("Auto Next Game", "Auto Next Game Disabled")
			end
		end,
	})
end
--==================================================--

do
	local flag3 = false
	tbl2.stealThread = nil

	local function fn14()
		local character = localPlayer.Character
		if character and character:FindFirstChild("Bandage") then
			return true
		end
		local backpack = localPlayer:FindFirstChild("Backpack")
		if backpack and backpack:FindFirstChild("Bandage") then
			return true
		end
		return false
	end

	local function fn15()
		local function fn16(arg)
			for _, child in ipairs(arg:GetChildren()) do
				if child.Name ~= "DroppedBandage" then
					continue
				end
				local primaryPart = child:IsA("Model") and (child.PrimaryPart or child:FindFirstChildWhichIsA("BasePart", true)) or child:IsA("BasePart") and child
				if primaryPart then
					return child, primaryPart
				end
			end

			return nil, nil
		end

		local v3, v4 = fn16(workspace)
		if v3 then
			return v3, v4
		end
		local effects = workspace:FindFirstChild("Effects")

		if effects then
			local v5, v6 = fn16(effects)
			if v5 then
				return v5, v6
			end
		end

		local live = workspace:FindFirstChild("Live")

		if live then
			local v5, v6 = fn16(live)
			if v5 then
				return v5, v6
			end
		end

		return nil, nil
	end

	local function fn16()
		if fn4("RedLightGreenLight") then
			local playerGui = localPlayer:FindFirstChild("PlayerGui")

			if playerGui then
				local impactFrames = playerGui:FindFirstChild("ImpactFrames")

				if impactFrames then
					local trafficLightEmpty = impactFrames:FindFirstChild("TrafficLightEmpty")
					if trafficLightEmpty and trafficLightEmpty.Image == "rbxassetid://88400194373338" then
						return true
					end
				end
			end
		end

		return false
	end

	tbl6.UtilitiesBox:Toggle({
		Title = "Auto Steal Bandages",
		Default = false,
		Callback = function(arg)
			flag3 = arg

			if flag3 then
				if tbl2.stealThread then
					return
				end
				tbl2.stealThread = true

				task.spawn(function()
					while flag3 and tbl2.stealThread do
						if not fn14() and not fn16() then
							local v3, v4 = fn15()

							if v3 and v4 then
								local character = localPlayer.Character
								local humanoidRootPart = character and character:FindFirstChild("HumanoidRootPart")

								if humanoidRootPart then
									local cFrame = humanoidRootPart.CFrame
									local cFrame2 = v4.CFrame
									humanoidRootPart.CFrame = cFrame2
									local n = 0

									while true do
										if flag3 and not fn14() and v3 and v3.Parent and n < 10 then
											if not fn16() then
												humanoidRootPart.CFrame = cFrame2

												if typeof(firetouchinterest) == "function" then
													pcall(function()
														firetouchinterest(humanoidRootPart, v4, 0)
														task.wait(0.05)
														firetouchinterest(humanoidRootPart, v4, 1)
													end)
												end

												task.wait(0.1)
												n += 1
												continue
											end
										end

										break
									end

									if character and character:FindFirstChild("HumanoidRootPart") then
										character.HumanoidRootPart.CFrame = cFrame
									end

									task.wait(0.5)
								end
							end
						end

						task.wait(0.5)
					end

					tbl2.stealThread = nil
				end)
			end
		end,
	})
end

do
	local walkSpeed = 14
	local jumpPower = 50
	local tbl10 = { "Left Hip", "Left Shoulder", "Neck", "Right Hip", "Right Shoulder" }

	local tbl11 = {
		"Ragdoll",
		"Stun",
		"RotateDisabled",
		"RagdollWakeupImmunity",
		"RagdollWakeupImmunityLess",
		"StopLoopTpFix",
		"TrueStun",
		"Waiting",
		"waitbeforecheckingforground",
	}

	local tbl12 = { "Ragdoll", "TrueStun", "Stun", "RotateDisabled", "Waiting" }

	local function fn14(arg)
		for _, v3 in ipairs(tbl11) do
			local v4 = arg:FindFirstChild(v3)

			if v4 then
				v4.Parent = nil
			end
		end
	end

	local function fn15(arg)
		local torso = arg:FindFirstChild("Torso")
		if not torso then
			return
		end

		for _, child in ipairs(torso:GetChildren()) do
			if child:IsA("BallSocketConstraint") and child.Name:match("^SocketConstraint") then
				child.Enabled = false
				child.Parent = nil
			end
		end

		for _, v3 in ipairs(tbl10) do
			local v4 = torso:FindFirstChild(v3)

			if v4 and v4:IsA("Motor6D") and not v4.Part0 then
				v4.Part0 = torso
			end
		end
	end

	local function fn16(arg)
		local humanoidRootPart = arg:FindFirstChild("HumanoidRootPart")
		if not humanoidRootPart then
			return
		end

		for _, child in ipairs(humanoidRootPart:GetChildren()) do
			if child.Name:match("^CacheAttachment") or child.Name:match("^SocketConstraint") then
				child.Parent = nil
			end
		end

		for _, child in ipairs(humanoidRootPart:GetChildren()) do
			if child:IsA("BodyVelocity") or child:IsA("BodyForce") or child:IsA("BodyPosition") then
				child.Parent = nil
			end
		end
	end

	local function fn17(arg)
		local humanoid = arg:FindFirstChildOfClass("Humanoid")
		if not humanoid then
			return
		end
		local humanoidRootPart = arg:FindFirstChild("HumanoidRootPart")
		fn14(arg)
		humanoid.PlatformStand = false
		humanoid.AutoRotate = true
		humanoid:SetStateEnabled(Enum.HumanoidStateType.Freefall, true)
		humanoid:SetStateEnabled(Enum.HumanoidStateType.Jumping, true)
		humanoid:SetStateEnabled(Enum.HumanoidStateType.Running, true)
		humanoid:SetStateEnabled(Enum.HumanoidStateType.GettingUp, true)
		humanoid:SetStateEnabled(Enum.HumanoidStateType.FallingDown, false)
		humanoid:SetStateEnabled(Enum.HumanoidStateType.Ragdoll, false)
		humanoid:SetStateEnabled(Enum.HumanoidStateType.PlatformStanding, false)
		humanoid:ChangeState(Enum.HumanoidStateType.GettingUp)

		if humanoidRootPart then
			humanoidRootPart.AssemblyLinearVelocity = Vector3.new(0, humanoidRootPart.AssemblyLinearVelocity.Y, 0)
		end

		fn15(arg)
		fn16(arg)
		humanoid.WalkSpeed = walkSpeed
		humanoid.JumpPower = jumpPower

		if shared then
			shared.WalkSpeedChangeTick = nil
		end

		task.delay(0.1, function()
			if humanoid and humanoid.Parent and humanoid.Health > 0 then
				humanoid:ChangeState(Enum.HumanoidStateType.GettingUp)
			end
		end)
	end

	tbl.antiPushEnabled = false
	local tbl13 = {}

	local function fn18()
		for _, v3 in ipairs(tbl13) do
			if v3 then
				v3:Disconnect()
			end
		end

		table.clear(tbl13)
	end

	local function fn19(arg)
		if not tbl.antiPushEnabled then
			return
		end
		fn18()
		local humanoid = arg:FindFirstChildOfClass("Humanoid")
		if not humanoid then
			return
		end
		local humanoidRootPart = arg:FindFirstChild("HumanoidRootPart")
		if not humanoidRootPart then
			return
		end
		local flag3 = false

		local connection5 = arg.ChildAdded:Connect(function(child)
			if flag3 or not tbl.antiPushEnabled then
				return
			end

			if typeof(child) == "Instance" then
				local name = child.Name

				for _, v3 in ipairs(tbl12) do
					if name == v3 then
						task.spawn(function()
							fn17(arg)
						end)

						break
					end
				end
			end
		end)

		table.insert(tbl13, connection5)

		local connection6 = RunService.Heartbeat:Connect(function()
			if not tbl.antiPushEnabled then
				fn18()
				return
			end

			if not arg or not arg.Parent then
				fn18()
				return
			end

			if not humanoid or not humanoid.Parent or humanoid.Health <= 0 then
				flag3 = true
				fn18()
				return
			end

			fn14(arg)

			if humanoid.PlatformStand then
				humanoid.PlatformStand = false
				humanoid:ChangeState(Enum.HumanoidStateType.GettingUp)
			end

			if humanoid.WalkSpeed <= 0 then
				humanoid.WalkSpeed = walkSpeed

				if shared then
					shared.WalkSpeedChangeTick = nil
				end
			end

			if humanoid.JumpPower <= 0 then
				humanoid.JumpPower = jumpPower
			end

			if not humanoid.AutoRotate then
				humanoid.AutoRotate = true
			end

			if not humanoid:GetStateEnabled(Enum.HumanoidStateType.Jumping) then
				humanoid:SetStateEnabled(Enum.HumanoidStateType.Jumping, true)
			end

			if not humanoid:GetStateEnabled(Enum.HumanoidStateType.Running) then
				humanoid:SetStateEnabled(Enum.HumanoidStateType.Running, true)
			end

			if not humanoid:GetStateEnabled(Enum.HumanoidStateType.GettingUp) then
				humanoid:SetStateEnabled(Enum.HumanoidStateType.GettingUp, true)
			end

			local torso = arg:FindFirstChild("Torso")

			if torso then
				local flag4 = false

				for _, child in ipairs(torso:GetChildren()) do
					if child:IsA("BallSocketConstraint") and child.Name:match("^SocketConstraint") and child.Enabled then
						flag4 = true
						break
					end
				end

				if flag4 then
					fn15(arg)
				end
			end

			if humanoidRootPart and humanoidRootPart.Parent then
				for _, child in ipairs(humanoidRootPart:GetChildren()) do
					if child:IsA("BodyVelocity") or child:IsA("BodyForce") then
						child.Parent = nil
					end
				end
			end
		end)

		table.insert(tbl13, connection6)
	end

	tbl6.UtilitiesBox:Toggle({
		Title = "Anti Push/Ragdoll",
		Default = false,
		Callback = function(antiPushEnabled)
			tbl.antiPushEnabled = antiPushEnabled

			if antiPushEnabled then
				if localPlayer.Character then
					fn19(localPlayer.Character)
				end

				local connection5 = localPlayer.CharacterAdded:Connect(function(character)
					task.wait(0.5)

					if tbl.antiPushEnabled then
						fn19(character)
					end
				end)

				table.insert(tbl13, connection5)
			else
				fn18()
			end
		end,
	})
end

game:GetService("UserInputService")
tbl.instantInteractEnabled = false
local connection5 = nil

tbl6.UtilitiesBox:Toggle({
	Title = "Instant Interact",
	Default = false,
	Callback = function(instantInteractEnabled)
		tbl.instantInteractEnabled = instantInteractEnabled

		if tbl.instantInteractEnabled then
			connection5 = game:GetService("ProximityPromptService").PromptButtonHoldBegan:Connect(function(prompt, player)
				if tbl.instantInteractEnabled and player == localPlayer then
					fireproximityprompt(prompt)
				end
			end)
		elseif connection5 then
			connection5:Disconnect()
			connection5 = nil
		end
	end,
})

tbl6.GameToolsBox:Toggle({
	Title = "Anti-AFK",
	Default = false,
	Callback = function(arg)
		if arg then
			if not getgenv().antiAfkConnection then
				local idled = localPlayer.Idled

				getgenv().antiAfkConnection = idled:Connect(function()
					local VirtualUser = game:GetService("VirtualUser")
					VirtualUser:CaptureController()
					VirtualUser:ClickButton2(Vector2.new())
				end)
			end
		elseif getgenv().antiAfkConnection then
			getgenv().antiAfkConnection:Disconnect()
			getgenv().antiAfkConnection = nil
		end
	end,
})

tbl6.GameToolsBox:Toggle({
	Title = "Bandage Helper",
	Default = false,
	Callback = function(arg)
		if arg then
			if _G.BandageHelperActive then
				return
			end
			_G.BandageHelperActive = true
			_G.BandageConns = {}
			local Players2 = game:GetService("Players")
			local RunService_ = game:GetService("RunService")
			local Lighting = game:GetService("Lighting")
			local StarterPlayer = game:GetService("StarterPlayer")
			local localPlayer2 = Players2.LocalPlayer
			local tbl10 = { "Freeze", "Slowed", "Action", "LightAction", "NoAttack" }
			local tbl11 = { "Stun", "Freeze", "Slowed", "Action", "LightAction", "Ragdoll", "NoAttack" }

			local tbl12 = {
				["HEALING WAVE 1"] = true,
				["HEALING WAVE 2"] = true,
				SPARKS = true,
				["STAR SPARKS"] = true,
				BandageModel = true,
				HealingOverlay = true,
				Blue = true,
				Green = true,
				VFX = true,
			}

			local function fn14(child)
				if not _G.BandageHelperActive then
					return
				end

				if child:IsA("ColorCorrectionEffect") then
					if child.TintColor.G > 0.6 and (child.TintColor.R < 0.5 or child.TintColor.B < 0.5) then
						child.TintColor = Color3.fromRGB(255, 255, 255)
					end

					if child.Name == "ColorSkill" or string.find(string.lower(child.Name), "heal") or string.find(string.lower(child.Name), "green") or string.find(string.lower(child.Name), "bandage") then
						child:Destroy()
					end
				elseif child:IsA("BloomEffect") or child:IsA("BlurEffect") then
					if string.find(string.lower(child.Name), "heal") or string.find(string.lower(child.Name), "bandage") then
						child:Destroy()
					end
				end
			end

			for _, child in ipairs(Lighting:GetChildren()) do
				fn14(child)
			end

			table.insert(_G.BandageConns, Lighting.ChildAdded:Connect(fn14))

			local function fn15(character)
				if not character or not _G.BandageHelperActive then
					return
				end
				local humanoid = character:WaitForChild("Humanoid", 5)
				character:WaitForChild("HumanoidRootPart", 5)
				if not humanoid then
					return
				end

				table.insert(_G.BandageConns, (humanoid:FindFirstChildOfClass("Animator") or humanoid).AnimationPlayed:Connect(function(arg2)
					if _G.BandageHelperActive and arg2.Animation and (string.find(arg2.Animation.AnimationId, "75334524397463") or arg2.Animation.Name and string.find(string.lower(arg2.Animation.Name), "bandage")) then
						arg2:Stop()
					end
				end))

				table.insert(_G.BandageConns, character.DescendantAdded:Connect(function(descendant)
					local bandageHelperActive = _G.BandageHelperActive
					local v3

					if bandageHelperActive then
						v3 = tbl12[descendant.Name] or string.find(string.lower(descendant.Name), "healing") or string.find(string.lower(descendant.Name), "bandage") or string.find(string.lower(descendant.Name), "sparks")
					else
						v3 = bandageHelperActive
					end

					if v3 then
						descendant:Destroy()
					end
				end))
			end

			if localPlayer2.Character then
				fn15(localPlayer2.Character)
			end

			table.insert(_G.BandageConns, localPlayer2.CharacterAdded:Connect(fn15))

			local function fn16(arg2)
				table.insert(_G.BandageConns, arg2.DescendantAdded:Connect(function(descendant)
					local bandageHelperActive = _G.BandageHelperActive

					if bandageHelperActive then
						bandageHelperActive = tbl12[descendant.Name] or string.find(string.lower(descendant.Name), "bandage") or string.find(string.lower(descendant.Name), "healing")
					end

					if bandageHelperActive and not descendant:IsA("Script") then
						descendant:Destroy()
					end
				end))
			end

			local playerGui = localPlayer2:FindFirstChildOfClass("PlayerGui")

			if playerGui then
				fn16(playerGui)
			else
				table.insert(_G.BandageConns, localPlayer2.ChildAdded:Connect(function(child)
					if _G.BandageHelperActive and child:IsA("PlayerGui") then
						fn16(child)
					end
				end))
			end

			table.insert(_G.BandageConns, RunService_.Heartbeat:Connect(function()
				if not _G.BandageHelperActive then
					return
				end

				if shared.IsInCutscene then
					shared.IsInCutscene = nil
				end

				local character = localPlayer2.Character
				if not character then
					return
				end
				local humanoid = character:FindFirstChildOfClass("Humanoid")
				local humanoidRootPart = character:FindFirstChild("HumanoidRootPart")

				for _, v3 in ipairs(tbl10) do
					if character:GetAttribute(v3) ~= nil then
						character:SetAttribute(v3, nil)
					end

					if humanoid and humanoid:GetAttribute(v3) ~= nil then
						humanoid:SetAttribute(v3, nil)
					end
				end

				for _, v3 in ipairs(tbl11) do
					local v4 = character:FindFirstChild(v3)

					if v4 then
						v4:Destroy()
					end
				end

				if humanoidRootPart and humanoidRootPart.Anchored then
					humanoidRootPart.Anchored = false
				end

				shared.WalkSpeedChangeTick = nil

				if humanoid then
					local characterWalkSpeed = StarterPlayer.CharacterWalkSpeed or 16
					local characterJumpPower = StarterPlayer.CharacterJumpPower or 50

					if humanoid.WalkSpeed < characterWalkSpeed then
						humanoid.WalkSpeed = characterWalkSpeed
					end

					if humanoid.JumpPower < characterJumpPower then
						humanoid.JumpPower = characterJumpPower
					end

					if humanoid.PlatformStand then
						humanoid.PlatformStand = false
					end
				end
			end))
		else
			_G.BandageHelperActive = false

			if _G.BandageConns then
				for _, bandageConn in ipairs(_G.BandageConns) do
					if bandageConn then
						bandageConn:Disconnect()
					end
				end

				table.clear(_G.BandageConns)
			end
		end
	end,
})

tbl.espLightsOutEnabled = false

do
	local flag3 = nil

	local function fn14()
		for _, player in pairs(Players:GetPlayers()) do
			if player ~= localPlayer and player.Character then
				local character = player.Character

				if not character:FindFirstChild("LightsOutESP") then
					local highlight = Instance.new("Highlight")
					highlight.Name = "LightsOutESP"
					highlight.FillTransparency = 0.5
					highlight.OutlineTransparency = 0
					highlight.FillColor = Color3.fromRGB(255, 0, 0)
					highlight.OutlineColor = Color3.fromRGB(200, 0, 0)
					highlight.Adornee = character
					highlight.Parent = character
				end
			end
		end
	end

	local function fn15()
		for _, player in pairs(Players:GetPlayers()) do
			if player.Character then
				local lightsOutESP = player.Character:FindFirstChild("LightsOutESP")

				if lightsOutESP then
					lightsOutESP:Destroy()
				end
			end
		end
	end

	tbl6.LightsOutBox = tbl5.LightsOut:Section({ Opened = true, Title = "| Lights Out", Icon = "moon" })

	tbl6.LightsOutBox:Button({
		Title = "TP To Roof",
		Callback = function()
			if fn4("LightsOut") then
				local character = localPlayer.Character
				character = character and character:FindFirstChild("HumanoidRootPart")

				if character then
					character.CFrame = CFrame.new(198, 145, -93)
					fn5("Lights Out", "Teleported to roof")
				end
			else
				fn5(nil, "Lights Out is not currently running.")
			end
		end,
	})

	tbl6.LightsOutBox:Toggle({
		Title = "ESP All",
		Default = false,
		Callback = function(espLightsOutEnabled)
			tbl.espLightsOutEnabled = espLightsOutEnabled

			if tbl.espLightsOutEnabled then
				if flag3 then
					return
				end
				flag3 = true

				task.spawn(function()
					while tbl.espLightsOutEnabled and flag3 do
						if fn4("LightsOut") then
							fn14()
						else
							fn15()
						end

						task.wait(2)
					end

					fn15()
					flag3 = nil
				end)
			else
				fn15()
			end
		end,
	})
end

tbl.dashAssistEnabled = false

do
	local tbl10 = {}
	local flag3 = false

	local function fn14()
		local character = localPlayer.Character
		if not character then
			return
		end
		local humanoid = character:FindFirstChild("Humanoid")
		if not humanoid then
			return
		end
		local animator = humanoid:FindFirstChildOfClass("Animator")
		if not animator then
			return
		end

		local connection6 = animator.AnimationPlayed:Connect(function(arg)
			if not tbl.dashAssistEnabled then
				return
			end

			if arg.Animation and string.find(tostring(arg.Animation.AnimationId), "99157505926076", 1, true) then
				flag3 = true
				local humanoid2 = character:FindFirstChild("Humanoid")

				if humanoid2 then
					humanoid2.AutoRotate = false
				end

				arg.Stopped:Once(function()
					flag3 = false
					local humanoid3 = localPlayer.Character and localPlayer.Character:FindFirstChild("Humanoid")

					if humanoid3 then
						humanoid3.AutoRotate = true
					end
				end)
			end
		end)

		table.insert(tbl10, connection6)
	end

	tbl6.LightsOutBox:Toggle({
		Title = "Dash Assist",
		Default = false,
		Callback = function(dashAssistEnabled)
			tbl.dashAssistEnabled = dashAssistEnabled

			if tbl.dashAssistEnabled then
				fn14()

				local connection6 = localPlayer.CharacterAdded:Connect(function()
					task.wait(0.5)

					if tbl.dashAssistEnabled then
						fn14()
					end
				end)

				table.insert(tbl10, connection6)

				local connection7 = game:GetService("RunService").Heartbeat:Connect(function()
					if not tbl.dashAssistEnabled or not flag3 then
						return
					end

					if not fn4("LightsOut") then
						return
					end
					local character = localPlayer.Character
					character = character and character:FindFirstChild("HumanoidRootPart")
					if not character then
						return
					end
					local huge = math.huge
					local v3 = nil

					for _, player in pairs(Players:GetPlayers()) do
						if player ~= localPlayer and player.Character and player.Character:FindFirstChild("HumanoidRootPart") and player.Character:FindFirstChild("Humanoid") and player.Character.Humanoid.Health > 0 then
							local magnitude = (player.Character.HumanoidRootPart.Position - character.Position).Magnitude

							if magnitude < huge then
								huge = magnitude
								v3 = player
							end
						end
					end

					if v3 and v3.Character and v3.Character:FindFirstChild("HumanoidRootPart") then
						local position = v3.Character.HumanoidRootPart.Position
						character.CFrame = CFrame.lookAt(character.Position, Vector3.new(position.X, character.Position.Y, position.Z))
					end
				end)

				table.insert(tbl10, connection7)
			else
				flag3 = false

				for _, v3 in pairs(tbl10) do
					pcall(function()
						v3:Disconnect()
					end)
				end

				table.clear(tbl10)
			end
		end,
	})
end

tbl.autoTPRoofUnder30Enabled = false
tbl2.autoTPRoofUnder30Thread = nil

tbl6.LightsOutBox:Toggle({
	Title = "Auto TP Roof Health Under 30",
	Default = false,
	Callback = function(autoTPRoofUnder30Enabled)
		tbl.autoTPRoofUnder30Enabled = autoTPRoofUnder30Enabled

		if tbl.autoTPRoofUnder30Enabled then
			if tbl2.autoTPRoofUnder30Thread then
				return
			end
			tbl2.autoTPRoofUnder30Thread = true

			task.spawn(function()
				local flag3 = false

				while tbl2.autoTPRoofUnder30Thread and tbl.autoTPRoofUnder30Enabled do
					if fn4("LightsOut") then
						local character = localPlayer.Character
						local humanoid = character and character:FindFirstChild("Humanoid")
						character = character and character:FindFirstChild("HumanoidRootPart")

						if humanoid and character and humanoid.Health > 0 and humanoid.Health <= 30 then
							if not flag3 then
								character.CFrame = CFrame.new(198, 145, -93)
								flag3 = true
							end
						end
					else
						flag3 = false
					end

					task.wait(0.5)
				end

				tbl2.autoTPRoofUnder30Thread = nil
			end)
		end
	end,
})

tbl6.LightsOutBox:Toggle({
	Title = "Full Bright",
	Default = false,
	Callback = function(lightsOutFullBrightEnabled)
		_G.LightsOutFullBrightEnabled = lightsOutFullBrightEnabled

		if lightsOutFullBrightEnabled then
			if not _G.LightsOutFullBrightCacheThread then
				_G.LightsOutFullBrightCacheThread = true

				task.spawn(function()
					_G.CachedBrightObjects = {}

					local connection6 = workspace.DescendantAdded:Connect(function(descendant)
						if _G.LightsOutFullBrightEnabled and fn4("LightsOut") then
							local isLight = descendant:IsA("Light")
							local flag3

							if isLight then
								flag3 = isLight
							else
								flag3 = descendant:IsA("BasePart") and descendant.Name == "ChangeColorLightsOut"
							end

							if flag3 then
								table.insert(_G.CachedBrightObjects, descendant)
							end
						end
					end)

					local flag3 = false

					while _G.LightsOutFullBrightCacheThread do
						local LightsOut = _G.LightsOutFullBrightEnabled and fn4("LightsOut")

						if LightsOut and not flag3 then
							table.clear(_G.CachedBrightObjects)
							local lightsOutMap = workspace:FindFirstChild("LightsOutMap") or workspace
							local n = 0

							for _, descendant in ipairs(lightsOutMap:GetDescendants()) do
								if _G.LightsOutFullBrightCacheThread then
									if descendant:IsA("Light") or descendant:IsA("BasePart") and descendant.Name == "ChangeColorLightsOut" then
										table.insert(_G.CachedBrightObjects, descendant)
									end

									n += 1

									if n % 500 == 0 then
										task.wait()
									end

									continue
								end

								break
							end
						else
							flag3 = not LightsOut and flag3

							if flag3 then
								table.clear(_G.CachedBrightObjects)
							end
						end

						task.wait(2)
						flag3 = LightsOut
					end

					connection6:Disconnect()
				end)
			end

			if not _G.LightsOutFullBrightRenderThread then
				_G.LightsOutFullBrightRenderThread = game:GetService("RunService").RenderStepped:Connect(function()
					if _G.LightsOutFullBrightEnabled and fn4("LightsOut") then
						local Lighting = game:GetService("Lighting")
						Lighting.Ambient = Color3.fromRGB(150, 150, 150)
						Lighting.OutdoorAmbient = Color3.fromRGB(150, 150, 150)
						Lighting.Brightness = 1
						Lighting.ClockTime = 14
						local atmosphere = Lighting:FindFirstChildOfClass("Atmosphere")

						if atmosphere then
							atmosphere.Density = 0
						end

						local colorCorrectionEffect = Lighting:FindFirstChildOfClass("ColorCorrectionEffect")

						if colorCorrectionEffect then
							colorCorrectionEffect.TintColor = Color3.fromRGB(255, 255, 255)
							colorCorrectionEffect.Brightness = 0
							colorCorrectionEffect.Contrast = 0
							colorCorrectionEffect.Saturation = 0
						end

						if _G.CachedBrightObjects then
							for _, cachedBrightObject in ipairs(_G.CachedBrightObjects) do
								if cachedBrightObject and cachedBrightObject.Parent then
									if cachedBrightObject:IsA("Light") then
										cachedBrightObject.Enabled = true

										if cachedBrightObject.Color.G < 0.2 and cachedBrightObject.Color.B < 0.2 then
											cachedBrightObject.Color = Color3.fromRGB(255, 255, 255)
										end
									elseif cachedBrightObject:IsA("BasePart") then
										if cachedBrightObject.Color.G < 0.2 and cachedBrightObject.Color.B < 0.2 then
											cachedBrightObject.Color = Color3.fromRGB(255, 255, 255)
										end
									end
								end
							end
						end
					end
				end)
			end
		else
			_G.LightsOutFullBrightCacheThread = false

			if _G.LightsOutFullBrightRenderThread then
				_G.LightsOutFullBrightRenderThread:Disconnect()
				_G.LightsOutFullBrightRenderThread = nil
			end

			if _G.CachedBrightObjects then
				table.clear(_G.CachedBrightObjects)
			end
		end
	end,
})

--==================================================--
--         VAMPIRE VISION (LIGHTSOUT TAB - NEW)      --
--==================================================--
tbl6.LightsOutBox:Toggle({
	Title = "Vampire Vision",
	Default = false,
	Callback = function(vampireVisionEnabled)
		local Lighting = game:GetService("Lighting")
		local enabled = vampireVisionEnabled and true or false
		local vampireNightVision = Lighting:FindFirstChild("VampireNightVision")

		if enabled then
			if not vampireNightVision then
				local colorCorrectionEffect = Instance.new("ColorCorrectionEffect")
				colorCorrectionEffect.Name = "VampireNightVision"
				colorCorrectionEffect.Parent = Lighting
				vampireNightVision = colorCorrectionEffect
			end

			vampireNightVision.Brightness = 0.16
			vampireNightVision.Contrast = 0.06
			vampireNightVision.Saturation = -0.08
			vampireNightVision.TintColor = Color3.fromRGB(255, 236, 236)

			fn5("Vampire Vision", "Vampire Vision Enabled")
		elseif vampireNightVision then
			vampireNightVision:Destroy()
			fn5("Vampire Vision", "Vampire Vision Disabled")
		end
	end,
})
--==================================================--

tbl6.GuardBox = tbl5.Guard:Section({ Opened = true, Title = "| Guard Mode", Icon = "shield" })

tbl6.GuardBox:Button({
	Title = "Free Perm Guard",
	Callback = function()
		localPlayer:SetAttribute("__OwnsPermGuard", true)
		fn5(" Guard", "Free Perm Guard Activated")
	end,
})

--==================================================--
--              WON FARM (GUARD TAB)                 --
--==================================================--
do
	local ArcadeAutoFarmEnabled = false
	local ArcadeAutoFarmTask    = nil
	local ArcadeCurrentGame     = nil
	local ArcadeConsoleCache    = nil
	local ArcadeGameModule      = nil

	local function findConsole()
		if ArcadeConsoleCache and ArcadeConsoleCache.Parent then
			return ArcadeConsoleCache
		end
		ArcadeConsoleCache = nil

		local candidates = {
			Workspace:FindFirstChild("Arcade"),
			Workspace:FindFirstChild("Arcades"),
			Workspace:FindFirstChild("Map"),
			Workspace:FindFirstChild("Interactive"),
			Workspace:FindFirstChild("Objects"),
		}
		for _, folder in ipairs(candidates) do
			if folder then
				local found = folder:FindFirstChild("Screen", true)
				if found and found.Parent then
					local par = found.Parent
					if par:FindFirstChild("SurfaceGui") or found:FindFirstChild("SurfaceGui") then
						ArcadeConsoleCache = par
						return par
					end
				end
			end
		end

		for _, d in ipairs(Workspace:GetChildren()) do
			if d:IsA("Model") or d:IsA("Folder") then
				local s = d:FindFirstChild("Screen", true)
				if s and s:FindFirstChild("SurfaceGui") then
					ArcadeConsoleCache = s.Parent
					return ArcadeConsoleCache
				end
			end
		end
		return nil
	end

	local function runWinFarm()
		if not ArcadeGameModule then
			local ok, result = pcall(function()
				return require(ReplicatedStorage.Modules.PlayableArcadeGame)
			end)
			if not ok or not result then return end
			ArcadeGameModule = result
		end

		local console = findConsole()
		if not console then return end

		local char = localPlayer.Character
		if not char then return end
		local hrp = char:FindFirstChild("HumanoidRootPart")
		if not hrp then return end

		if ArcadeCurrentGame then
			pcall(function()
				ArcadeCurrentGame.Stopping = true
				ArcadeCurrentGame:Destroy()
			end)
			ArcadeCurrentGame = nil
		end

		local g = ArcadeGameModule.new(console, hrp)
		ArcadeCurrentGame = g
		g:start()

		local now = os.clock()
		while g.State ~= "Running" and os.clock() - now < 3 do
			if not ArcadeAutoFarmEnabled then
				pcall(function() g:Destroy() end)
				ArcadeCurrentGame = nil
				return
			end
			task.wait(0.1)
		end

		if not ArcadeAutoFarmEnabled then
			pcall(function() g:Destroy() end)
			ArcadeCurrentGame = nil
			return
		end

		if g.State ~= "Running" then
			pcall(function() g:Destroy() end)
			ArcadeCurrentGame = nil
			return
		end

		g.Score = 4499
		if g.ScoreLabel then
			g.ScoreLabel.Text = "Score: 4499"
		end
		table.clear(g.CalculateScore)
		for _ = 1, 99 do
			table.insert(g.CalculateScore, "Coin")
		end
		g:win("You Won! Congrats! :D")
	end

	local function toggleAutoFarm(enabled)
		enabled = enabled and true or false
		ArcadeAutoFarmEnabled = enabled

		if ArcadeAutoFarmTask then
			pcall(function() task.cancel(ArcadeAutoFarmTask) end)
			ArcadeAutoFarmTask = nil
		end

		if not enabled then
			if ArcadeCurrentGame then
				pcall(function()
					ArcadeCurrentGame.Stopping = true
					ArcadeCurrentGame:Destroy()
				end)
				ArcadeCurrentGame = nil
			end
			ArcadeConsoleCache = nil
			return true
		end

		ArcadeAutoFarmTask = task.spawn(function()
			while ArcadeAutoFarmEnabled do
				pcall(runWinFarm)
				if not ArcadeAutoFarmEnabled then break end
				task.wait(2)
			end
			ArcadeAutoFarmTask = nil
		end)
		return true
	end

	tbl6.GuardBox:Toggle({
		Title = "Won Farm",
		Default = false,
		Callback = function(enabled)
			toggleAutoFarm(enabled)
			if enabled then
				fn5(" Won Farm", "Won Farm Enabled")
			else
				fn5(" Won Farm", "Won Farm Disabled")
			end
		end,
	})
end
--==================================================--

tbl.guardQteEnabled = false
tbl2.guardQteThread = nil

tbl6.GuardBox:Toggle({
	Title = "Auto QTE Event (Guard)",
	Default = false,
	Callback = function(guardQteEnabled)
		tbl.guardQteEnabled = guardQteEnabled

		if tbl.guardQteEnabled and not tbl2.guardQteThread then
			tbl2.guardQteThread = task.spawn(function()
				local tbl10 = {}

				while tbl.guardQteEnabled do
					if localPlayer:GetAttribute("IsGuard") then
						local v3 = fn7()

						if v3 and v3.ActiveButtons then
							for k, activeButton in pairs(v3.ActiveButtons) do
								if not tbl10[k] and activeButton then
									tbl10[k] = true

									if tbl.guardQteEnabled and v3.ActiveButtons and v3.ActiveButtons[k] then
										pcall(function()
											v3.Pressed(false, v3.ActiveButtons[k])
										end)
									end
								end
							end

							for k in pairs(tbl10) do
								if not v3.ActiveButtons[k] then
									tbl10[k] = nil
								end
							end
						end
					else
						table.clear(tbl10)
					end

					task.wait()
				end

				tbl2.guardQteThread = nil
			end)
		end
	end,
})

tbl.autoKillRedArrowEnabled = false
tbl2.autoKillRedArrowThread = nil

local function fn14()
	local character = localPlayer.Character
	if not character then
		return nil
	end

	local tbl10 = {
		G3SG1 = true,
		["Glock 17"] = true,
		["Five Seven"] = true,
		["Colt M1911"] = true,
		Uzi = true,
		MP5K = true,
		["Thompson M1A1"] = true,
		["Colt Python 6"] = true,
		M4A1 = true,
		["FN Fal"] = true,
		HK416 = true,
		Deagle = true,
		P90 = true,
	}

	for _, child in ipairs(character:GetChildren()) do
		if tbl10[child.Name] then
			return child
		end
	end

	return nil
end

tbl6.GuardBox:Toggle({
	Title = "Auto Shoot",
	Locked = true,
	Default = false,
	Callback = function(autoKillRedArrowEnabled)
		tbl.autoKillRedArrowEnabled = autoKillRedArrowEnabled

		if tbl.autoKillRedArrowEnabled then
			if tbl2.autoKillRedArrowThread then
				return
			end
			tbl2.autoKillRedArrowThread = true

			task.spawn(function()
				while tbl.autoKillRedArrowEnabled and tbl2.autoKillRedArrowThread do
					local live = workspace:FindFirstChild("Live")
					local v3 = fn14()
					local character = localPlayer.Character
					local humanoidRootPart = character and character:FindFirstChild("HumanoidRootPart")

					if live and v3 and humanoidRootPart then
						for _, child in ipairs(live:GetChildren()) do
							if child:IsA("Model") then
								local humanoidRootPart2 = child:FindFirstChild("HumanoidRootPart")
								local humanoid = child:FindFirstChild("Humanoid")

								if humanoidRootPart2 and humanoid and humanoid.Health > 0 and child ~= character then
									local guardCanKillLockOn = humanoidRootPart2:FindFirstChild("GuardCanKillLockOn")
									local isBillboardGui = guardCanKillLockOn and guardCanKillLockOn:IsA("BillboardGui")
									local flag3 = false

									if isBillboardGui then
										flag3 = true
									end

									if flag3 then
										for _, player in pairs(Players:GetPlayers()) do
											if player.Character == child then
												break
											else
											end
										end

										local vector = Vector3.new

										local tbl10 = {
											v3,
											{
												ClientRayNormal = Vector3.new(0.707164, 0, -0.707049),
												FiredGun = true,
												bulletCF = CFrame.new(-221, 191, 269, 0.108, 0.141, 0.983, 0, 0.989, -0.142, -0.994, 0.015, 0.107),
												ClientRayInstance = humanoidRootPart2,
												SecondaryHitTargets = {},
												ClientRayPosition = humanoidRootPart2.Position,
												HitTargets = { [vector] = "Head" },
												bulletSizeC = Vector3.new(0.01, 0.01, 48.3),
												NoMuzzleFX = false,
												FirePosition = humanoidRootPart.Position + Vector3.new(0, 1.5, 0),
											},
										}

										pcall(function()
											game:GetService("ReplicatedStorage").Remotes.FiredGunClient:FireServer(unpack(tbl10))
											task.wait(0.05)
											game:GetService("ReplicatedStorage").Remotes.FiredGunClient:FireServer(v3, { ReloadingGun = true })
										end)
									end
								end
							end
						end
					end

					task.wait(0.15)
				end

				tbl2.autoKillRedArrowThread = nil
			end)
		end
	end,
})

tbl6.GuardBox:Toggle({
	Title = "Silent Aim",
	Default = false,
	Callback = function(silentAimEnabled)
		tbl.silentAimEnabled = silentAimEnabled

		if silentAimEnabled then
			fn11()
		end
	end,
})

local connection6 = nil

tbl6.GuardBox:Toggle({
	Title = "Infinite Ammo",
	Default = false,
	Callback = function(infiniteAmmoGuardEnabled)
		tbl.infiniteAmmoGuardEnabled = infiniteAmmoGuardEnabled

		if infiniteAmmoGuardEnabled then
			if not connection6 then
				connection6 = game:GetService("RunService").RenderStepped:Connect(function()
					if not tbl.infiniteAmmoGuardEnabled then
						return
					end

					pcall(function()
						local character = localPlayer.Character
						if not character then
							return
						end
						local tool = character:FindFirstChildOfClass("Tool")

						if tool then
							local infoClient = tool:FindFirstChild("InfoClient") or tool:FindFirstChild("Info")

							if infoClient then
								local bullets = infoClient:FindFirstChild("Bullets")
								local maxBullets = tool:FindFirstChild("MaxBullets") or tool:FindFirstChild("MagSize")

								if bullets then
									maxBullets = maxBullets and maxBullets.Value or 999

									if bullets.Value < maxBullets then
										bullets.Value = maxBullets
									end
								end
							end
						end
					end)
				end)
			end
		elseif connection6 then
			pcall(function()
				connection6:Disconnect()
			end)

			connection6 = nil
		end
	end,
})

tbl.autoShootAAEnabled = false
tbl2.autoShootAAThread = nil

local function fn15()
	local character = localPlayer.Character
	if not character then
		return nil
	end

	for _, v3 in pairs({
		"Colt M1911",
		"Uzi",
		"Five Seven",
		"MP5K",
		"Colt Python 6",
		"Deagle",
		"P90",
		"FN Fal",
		"M4A1",
		"HK416",
	}) do
		local v4 = character:FindFirstChild(v3)
		if v4 then
			return v4
		end
	end

	return nil
end

tbl3.lastAARLGLTPTime = 0
tbl6.AdminAbuseBox = tbl5.Tools:Section({ Opened = true, Title = "| Admin Abuse Tools", Icon = "terminal" })

tbl6.AdminAbuseBox:Button({
	Title = "RLGL TP Start",
	Callback = function()
		if not fn4("AdminAbuseRedLightGreenLight") then
			fn5(nil, "Admin Abuse RLGL is not currently running.")
			return
		end
		local lastAARLGLTPTime = tbl3.lastAARLGLTPTime

		if tick() - lastAARLGLTPTime < 10 then
			local lastAARLGLTPTime2 = tbl3.lastAARLGLTPTime
			fn5(nil, "Please wait before teleporting again (" .. math.ceil(10 - tick() - lastAARLGLTPTime2) .. "s)")
			return
		end

		fn9(CFrame.new(-1375, -30, 22))
		tbl3.lastAARLGLTPTime = tick()
		fn5(nil, "Teleported to Start")
	end,
})

tbl6.AdminAbuseBox:Button({
	Title = "RLGL TP End",
	Callback = function()
		if not fn4("AdminAbuseRedLightGreenLight") then
			fn5(nil, "Admin Abuse RLGL is not currently running.")
			return
		end
		local lastAARLGLTPTime = tbl3.lastAARLGLTPTime

		if tick() - lastAARLGLTPTime < 10 then
			local lastAARLGLTPTime2 = tbl3.lastAARLGLTPTime
			fn5(nil, "Please wait before teleporting again (" .. math.ceil(10 - tick() - lastAARLGLTPTime2) .. "s)")
			return
		end

		fn9(CFrame.new(-1361, -28, 701))
		tbl3.lastAARLGLTPTime = tick()
		fn5(nil, "Teleported to End")
	end,
})

tbl6.AdminAbuseBox:Toggle({
	Title = "Auto Shoot PBRS (AA)",
	Locked = true,
	Default = false,
	Callback = function(autoShootAAEnabled)
		tbl.autoShootAAEnabled = autoShootAAEnabled

		if tbl.autoShootAAEnabled then
			if tbl2.autoShootAAThread then
				return
			end
			tbl2.autoShootAAThread = true

			task.spawn(function()
				while tbl.autoShootAAEnabled and tbl2.autoShootAAThread do
					if fn15() and localPlayer.Character and localPlayer.Character:FindFirstChild("HumanoidRootPart") then
						local live = nil

						for _, child in pairs(workspace:GetChildren()) do
							if child:IsA("Model") or child:IsA("Folder") then
								live = child:FindFirstChild("Live")
								if not (live and live:IsA("Folder")) then
									live = nil
									continue
								end
							else
								live = nil
								continue
							end

							break
						end

						if not live then
							for _, descendant in pairs(workspace:GetDescendants()) do
								if descendant.Name == "Live" and descendant:IsA("Folder") then
									live = descendant
									break
								end
							end
						end

						if live then
							for _, child in pairs(live:GetChildren()) do
								if child:IsA("Model") and string.match(string.lower(child.Name), "peabert") then
									local basePart = child:FindFirstChildWhichIsA("BasePart", true)

									if basePart then
										local v3 = fn15()

										if v3 then
											local tbl10 = {
												v3,
												{
													ClientRayNormal = Vector3.new(0.707164, 0, -0.707049),
													FiredGun = true,
													bulletCF = CFrame.new(-221, 191, 269, 0.108, 0.141, 0.983, 0, 0.989, -0.142, -0.994, 0.015, 0.107),
													ClientRayInstance = basePart,
													SecondaryHitTargets = {},
													ClientRayPosition = basePart.Position,
													HitTargets = { [child.Name] = basePart.Name },
													bulletSizeC = Vector3.new(0.01, 0.01, 48.3),
													NoMuzzleFX = false,
													FirePosition = localPlayer.Character.HumanoidRootPart.Position,
												},
											}

											pcall(function()
												game:GetService("ReplicatedStorage"):WaitForChild("Remotes"):WaitForChild("FiredGunClient"):FireServer(unpack(tbl10))
												task.wait(0.05)
												game:GetService("ReplicatedStorage"):WaitForChild("Remotes"):WaitForChild("FiredGunClient"):FireServer(v3, { ReloadingGun = true })
											end)
										end
									end
								end
							end
						end
					end

					task.wait(0.15)
				end

				tbl2.autoShootAAThread = nil
			end)
		end
	end,
})

tbl6.AdminAbuseBox:Toggle({
	Title = "Silent Aim",
	Default = false,
	Callback = function(silentAimEnabled)
		tbl.silentAimEnabled = silentAimEnabled

		if silentAimEnabled then
			fn11()
		end
	end,
})

local flag3 = false

tbl5.UISettings:Section({ Opened = true, Title = "Menu" }):Toggle({
	Title = "Unlock Mouse When Menu Open",
	Default = false,
	Callback = function(unlockMouseWhileOpen)
		flag3 = unlockMouseWhileOpen

		if Library then
			Library.UnlockMouseWhileOpen = unlockMouseWhileOpen
		end

		if not unlockMouseWhileOpen and Library and Library.ScreenGui then
			for _, child in ipairs(Library.ScreenGui:GetChildren()) do
				if child:IsA("TextButton") and child.Size == UDim2.fromScale(0, 0) then
					child.Modal = false
				end
			end
		end
	end,
})

task.spawn(function()
	local RunService_ = game:GetService("RunService")
	local GuiService = game:GetService("GuiService")

	RunService_:BindToRenderStep("AggressiveMouseLock", Enum.RenderPriority.Last.Value + 2, function()
		if Library and not Library.Unloaded then
			local flag4 = false

			pcall(function()
				if type(Library.Toggled) == "boolean" then
					flag4 = not Library.Toggled
				elseif Library.MainGui then
					flag4 = not Library.MainGui.Enabled
				end
			end)

			if not GuiService.MenuIsOpen then
				if not flag4 and not flag3 then
					if Library.ScreenGui then
						for _, child in ipairs(Library.ScreenGui:GetChildren()) do
							if child:IsA("TextButton") and child.Size == UDim2.fromScale(0, 0) then
								child.Modal = false
							end
						end
					end
				end
			end
		end
	end)
end)

pcall(function()
end)

do
	local v3 = tbl5.UISettings:Section({ Opened = true, Title = "| Configuration", Icon = "settings" })

	local function fn16()
		pcall(function()
			local HttpService = game:GetService("HttpService")
			local tbl10 = {}

			for k, v4 in pairs(tbl) do
				if type(v4) == "boolean" or type(v4) == "number" or type(v4) == "string" then
					tbl10[k] = v4
				end
			end

			if v and v.GetCurrentTheme then
				pcall(function()
					tbl10.__CurrentTheme = v:GetCurrentTheme()
				end)
			end

			if tbl.DefaultTheme then
				tbl10.__DefaultTheme = tbl.DefaultTheme
			end

			if isfolder and not isfolder("LarpHub") then
				pcall(makefolder, "LarpHub")
			end

			if writefile then
				writefile("LarpHub/config.json", HttpService:JSONEncode(tbl10))
				fn5("Config", "Configuration saved successfully!")
			else
				fn5("Config", "Your executor does not support writefile!")
			end
		end)
	end

	local function fn17()
		pcall(function()
			local HttpService = game:GetService("HttpService")

			if isfile and isfile("LarpHub/config.json") and readfile then
				local json = readfile("LarpHub/config.json")
				local data = HttpService:JSONDecode(json)

				if data and type(data) == "table" then
					for k, v4 in pairs(data) do
						if k ~= "__CurrentTheme" and k ~= "__DefaultTheme" then
							tbl[k] = v4

							if tbl4[k] and tbl4[k].Set then
								pcall(function()
									tbl4[k]:Set(v4)
								end)
							elseif handlers[k] then
								pcall(function()
									handlers[k](v4)
								end)
							end
						end
					end

					local defaultTheme = data.__DefaultTheme or data.__CurrentTheme

					if defaultTheme and v and v.SetTheme then
						pcall(function()
							if v.Themes and v.Themes[defaultTheme] then
								v:SetTheme(defaultTheme)
							end

							if defaultTheme == "Furina Genshin" then
								fn2(true)
								fn3(false)
							elseif defaultTheme == "Closing Eyes" then
								fn2(false)
								fn3(true)
							else
								fn2(false)
								fn3(false)
							end
						end)
					end

					if updateCustomCursor then
						updateCustomCursor()
					end

					fn5("Config", "Configuration loaded successfully!")
				end
			else
				fn5("Config", "No saved config found!")
			end
		end)
	end

	v3:Button({
		Title = "Save Config",
		Callback = function()
			fn16()
		end,
	})

	v3:Button({
		Title = "Load Config",
		Callback = function()
			fn17()
		end,
	})

	v3:Toggle({
		Title = "Set Auto Load",
		Default = false,
		Callback = function(arg)
			pcall(function()
				if isfolder and not isfolder("LarpHub") then
					pcall(makefolder, "LarpHub")
				end

				if writefile then
					writefile("LarpHub/autoload.txt", arg and "true" or "false")
				end

				fn5("Config", "Auto load set to " .. tostring(arg))
			end)
		end,
	})

	v3:Keybind({
		Title = "UI Toggle Keybind",
		Default = "G",
		Callback = function(toggleKey)
			pcall(function()
				if typeof(toggleKey) == "string" then
					v2.ToggleKey = Enum.KeyCode[toggleKey]
				else
					v2.ToggleKey = toggleKey
				end
			end)
		end,
	})

	local v4 = tbl5.UISettings:Section({ Opened = true, Title = "| Theme Settings", Icon = "palette" })

	v4:Dropdown({
		Title = "Select Theme",
		Values = {
			"Dark",
			"Cyberpunk",
			"Dracula",
			"Tokyo Night",
			"Vaporwave",
			"Onyx Gold",
			"Blood Moon",
			"Rose",
			"Plant",
			"Red",
			"Indigo",
			"Sky",
			"Violet",
			"Amber",
			"Emerald",
			"Midnight",
			"Crimson",
			"Light",
			"Furina Genshin",
			"Closing Eyes",
		},
		Default = "Dark",
		Callback = function(currentThemeName)
			if not currentThemeName or type(currentThemeName) ~= "string" then
				return
			end
			tbl.CurrentThemeName = currentThemeName

			pcall(function()
				if v and v.Themes and v.Themes[currentThemeName] then
					v:SetTheme(currentThemeName)
				end

				if currentThemeName == "Furina Genshin" then
					fn2(true)
					fn3(false)
				elseif currentThemeName == "Closing Eyes" then
					fn2(false)
					fn3(true)
				else
					fn2(false)
					fn3(false)
				end
			end)
		end,
	})

	v4:Button({
		Title = "Set Current Theme as Default",
		Callback = function()
			pcall(function()
				local currentTheme = v and v.GetCurrentTheme and v:GetCurrentTheme() or "Dark"
				tbl.DefaultTheme = currentTheme

				if isfolder and not isfolder("LarpHub") then
					pcall(makefolder, "LarpHub")
				end

				if writefile then
					writefile("LarpHub/default_theme.txt", currentTheme)
				end

				fn5("Theme", "Default theme set to: " .. tostring(currentTheme))
			end)
		end,
	})

	pcall(function()
		if isfile and isfile("LarpHub/default_theme.txt") and readfile then
			local txt = readfile("LarpHub/default_theme.txt")

			if txt and txt ~= "" and v and v.SetTheme then
				if v and v.Themes and v.Themes[txt] then
					v:SetTheme(txt)
				end

				if txt == "Furina Genshin" then
					local v5 = fn()

					if v2 and v2.SetBackgroundImage then
						pcall(function()
							v2:SetBackgroundImage(v5)
						end)
					end
				elseif txt == "Closing Eyes" then
					fn3(true)
				end
			end
		end
	end)

	pcall(function()
		if isfile and isfile("LarpHub/autoload.txt") and readfile then
			if readfile("LarpHub/autoload.txt") == "true" then
				fn17()
			end
		end
	end)
end

do
	local v3 = tbl5.UISettings:Section({ Opened = true, Title = "Custom Cursor" })
	tbl.customCursorEnabled = true
	tbl.customCursorTextEnabled = true
	tbl.customCursorRGBEnabled = true
	local screenGui = nil
	local connection7 = nil

	local function fn16()
		task.spawn(function()
			if tbl.customCursorEnabled then
				if not screenGui then
					screenGui = Instance.new("ScreenGui")
					screenGui.Name = "LarpCustomCursor"
					screenGui.DisplayOrder = 99999
					screenGui.IgnoreGuiInset = true
					local imageLabel = Instance.new("ImageLabel")
					imageLabel.Name = "CursorImage"
					imageLabel.BackgroundTransparency = 1
					imageLabel.Image = "rbxassetid://10769687353"
					imageLabel.Size = UDim2.new(0, 32, 0, 32)
					imageLabel.AnchorPoint = Vector2.new(0.5, 0.5)
					imageLabel.Parent = screenGui
					local textLabel = Instance.new("TextLabel")
					textLabel.Name = "CursorText"
					textLabel.BackgroundTransparency = 1
					textLabel.Text = "Larp"
					textLabel.TextColor3 = Color3.fromRGB(255, 255, 255)
					textLabel.TextStrokeTransparency = 0
					textLabel.Font = Enum.Font.GothamBold
					textLabel.TextSize = 14
					textLabel.Size = UDim2.new(0, 100, 0, 20)
					textLabel.AnchorPoint = Vector2.new(0.5, 0)
					textLabel.Visible = tbl.customCursorTextEnabled
					textLabel.Parent = screenGui
					local CoreGui = game:GetService("CoreGui")

					local ok, parent = pcall(function()
						return gethui and gethui()
					end)

					local ok2, parent2 = pcall(function()
						return CoreGui.Name and CoreGui
					end)

					if ok and parent then
						screenGui.Parent = parent
					elseif ok2 and parent2 then
						screenGui.Parent = parent2
					else
						local localPlayer2 = game:GetService("Players").LocalPlayer

						if localPlayer2 then
							local playerGui = localPlayer2:FindFirstChild("PlayerGui")

							if playerGui then
								screenGui.Parent = playerGui
							else
								screenGui.Parent = localPlayer2:WaitForChild("PlayerGui", 10)
							end
						end
					end
				else
					if screenGui:FindFirstChild("CursorImage") then
						screenGui.CursorImage.Image = "rbxassetid://10769687353"
					end

					if screenGui:FindFirstChild("CursorText") then
						screenGui.CursorText.Visible = tbl.customCursorTextEnabled
					end
				end

				if not connection7 then
					local UserInputService_ = game:GetService("UserInputService")
					local RunService_ = game:GetService("RunService")
					UserInputService_.MouseIconEnabled = false

					connection7 = RunService_.RenderStepped:Connect(function()
						pcall(function()
							UserInputService_.MouseIconEnabled = false

							if screenGui then
								local mouseLocation = UserInputService_:GetMouseLocation()
								local cursorImage = screenGui:FindFirstChild("CursorImage")

								if cursorImage then
									cursorImage.Position = UDim2.new(0, mouseLocation.X, 0, mouseLocation.Y)
									cursorImage.Rotation = cursorImage.Rotation + 2.5

									if tbl.customCursorRGBEnabled then
										cursorImage.ImageColor3 = Color3.fromHSV(tick() % 5 / 5, 1, 1)
									else
										cursorImage.ImageColor3 = Color3.new(1, 1, 1)
									end
								end

								local cursorText = screenGui:FindFirstChild("CursorText")

								if cursorText then
									cursorText.Position = UDim2.new(0, mouseLocation.X, 0, mouseLocation.Y + 20)

									if tbl.customCursorRGBEnabled then
										cursorText.TextColor3 = Color3.fromHSV(tick() % 5 / 5, 1, 1)
									else
										cursorText.TextColor3 = Color3.new(1, 1, 1)
									end
								end
							end
						end)
					end)
				end
			else
				pcall(function()
					game:GetService("UserInputService").MouseIconEnabled = true
				end)

				if connection7 then
					connection7:Disconnect()
					connection7 = nil
				end

				if screenGui then
					screenGui:Destroy()
					screenGui = nil
				end
			end
		end)
	end

	v3:Toggle({
		Title = "Disable RGB Effect",
		Default = false,
		Callback = function(arg)
			tbl.customCursorRGBEnabled = not arg
		end,
	})

	v3:Toggle({
		Title = "Enable Custom Cursor",
		Default = true,
		Callback = function(customCursorEnabled)
			tbl.customCursorEnabled = customCursorEnabled
			fn16()
		end,
	})

	v3:Toggle({
		Title = "Under Cursor Text",
		Default = true,
		Callback = function(customCursorTextEnabled)
			tbl.customCursorTextEnabled = customCursorTextEnabled
			fn16()
		end,
	})

	fn16()
end

pcall(function()
	local fn16 = identifyexecutor or getexecutorname or syn and function()
		return "Synapse"
	end

	if fn16 then
		local str2 = tostring(fn16()):lower()

		if str2:find("xeno") or str2:find("solara") then
			task.spawn(function()
				task.wait(1.5)

				v:Notify({
					Title = "Unsupported Executor",
					Content = "Please Use Better Executors For Better Experince",
					Duration = 10,
				})
			end)
		end
	end
end)

pcall(function()
	if v and v.Notify then
		v:Notify({
			Title = "Larp Hub",
			Content = "Please Showcase My Script On Tiktok or Somewhere",
			Duration = 10,
		})
	end
end)

if flag then
	task.wait(1)

	pcall(function()
		if v and v.Notify then
			v:Notify({
				Title = "Warning",
				Content = "GAME VERSION CHANGE DETECTED. Some features may be patched.",
				Duration = 10,
			})
		end
	end)
end

task.spawn(function()
	local HttpService = game:GetService("HttpService")

	local function fn16(arg)
		return HttpService:UrlEncode(arg)
	end

	local v3 = fn16(game:GetService("Players").LocalPlayer.Name)
	local inkGame = fn16("Ink Game")

	while true do
		local str2 = "https://platinstudio.xyz" .. "/iwasactive?user=" .. v3 .. "&game=" .. inkGame

		pcall(function()
			game:HttpGetAsync(str2)
		end)

		task.wait(25)
	end
end)

task.spawn(function()
	local Players2 = game:GetService("Players")
	game:GetService("StarterGui")
	local Workspace2 = game:GetService("Workspace")

	if _G.PH_Detector_Cleanup then
		pcall(function()
			_G.PH_Detector_Cleanup()
		end)

		_G.PH_Detector_Cleanup = nil
	end

	local str2 = "71318091779666"
	local tbl10 = {}
	local tbl11 = {}

	local function fn16(arg)
		for _, descendant in pairs(arg:GetDescendants()) do
			if descendant:IsA("JointInstance") and descendant.Part1 and descendant.Part0 then
				local parent = descendant.Part1.Parent
				local parent2 = descendant.Part0.Parent
				if parent and parent:IsA("Model") and parent:FindFirstChild("Humanoid") and parent ~= arg then
					return parent
				end

				if parent2 and parent2:IsA("Model") and parent2:FindFirstChild("Humanoid") and parent2 ~= arg then
					return parent2
				end
			end
		end

		local humanoidRootPart = arg:FindFirstChild("HumanoidRootPart")
		if not humanoidRootPart then
			return nil
		end
		local n = 6

		local function fn17(arg2)
			if arg2 and arg2:IsA("Model") and arg2 ~= arg and arg2:FindFirstChild("Humanoid") and arg2:FindFirstChild("HumanoidRootPart") then
				if (arg2.HumanoidRootPart.Position - humanoidRootPart.Position).Magnitude < n then
					local humanoid = arg2:FindFirstChild("Humanoid")
					humanoid = humanoid and humanoid:FindFirstChild("Animator")

					if humanoid then
						for _, v3 in pairs(humanoid:GetPlayingAnimationTracks()) do
							if (v3.Animation and v3.Animation.AnimationId:match("%d+") or "") == "82142761681917" then
								return arg2
							end
						end
					end
				end
			end

			return nil
		end

		for _, player in pairs(Players2:GetPlayers()) do
			local v3 = fn17(player.Character)
			if v3 then
				return v3
			end
		end

		local live = Workspace2:FindFirstChild("Live") or Workspace2:FindFirstChild("Characters")

		if live then
			for _, child in pairs(live:GetChildren()) do
				local v3 = fn17(child)
				if v3 then
					return v3
				end
			end
		else
			for _, child in pairs(Workspace2:GetChildren()) do
				local v3 = fn17(child)
				if v3 then
					return v3
				end
			end
		end

		return nil
	end

	local function fn17(arg, arg2)
		if tbl10[arg] then
			return
		end
		tbl10[arg] = true

		local connection7 = arg.AnimationPlayed:Connect(function(arg3)
			if not arg3 or not arg3.Animation then
				return
			end

			if (arg3.Animation.AnimationId:match("%d+") or "") == str2 then
				task.delay(0.2, function()
					fn16(arg2)
				end)
			end
		end)

		table.insert(tbl11, connection7)
	end

	local function fn18(character)
		if character:IsA("Model") then
			local humanoid = character:WaitForChild("Humanoid", 3)

			if humanoid then
				local animator = humanoid:WaitForChild("Animator", 3)

				if animator then
					fn17(animator, character)
				end
			end
		end
	end

	_G.PH_Detector_Cleanup = function()
		for _, v3 in pairs(tbl11) do
			if v3 then
				v3:Disconnect()
			end
		end

		tbl11 = {}
		tbl10 = {}
	end

	for _, player in pairs(Players2:GetPlayers()) do
		if player.Character then
			task.spawn(fn18, player.Character)
		end

		local connection7 = player.CharacterAdded:Connect(fn18)
		table.insert(tbl11, connection7)
	end

	local connection7 = Players2.PlayerAdded:Connect(function(player)
		local connection7 = player.CharacterAdded:Connect(fn18)
		table.insert(tbl11, connection7)
	end)

	table.insert(tbl11, connection7)

	for _, child in pairs(Workspace2:GetChildren()) do
		task.spawn(fn18, child)
	end

	local connection8 = Workspace2.ChildAdded:Connect(fn18)
	table.insert(tbl11, connection8)
end)
