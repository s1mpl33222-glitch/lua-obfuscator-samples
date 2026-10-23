-- deobf by 2qnlura

local cFrameNew = CFrame.new

if not (function(p1)
	local v2 = p1 or {}
	local TITLE = v2.TITLE or "TSUO HUB"
	local SUBTITLE = v2.SUBTITLE or ""
	local VERSION = v2.VERSION or ""
	local SLUG = v2.SLUG or "Tsuo Hub"
	local API_BASE = v2.API_BASE or "https://tsuoblox.com/api/script-keys"
	local DISCORD = v2.DISCORD or "https://discord.gg/tsuo"
	local LOGO = v2.LOGO or "rbxthumb://type=Asset&id=90690292624964&w=420&h=420"
	local KEY_FILE = v2.KEY_FILE or "TsuoHub_Key"
	local BUILD = v2.BUILD or SUBTITLE

	if type(getgenv) == "function" and getgenv().TSUO_KEY_BYPASS == true then
		return true
	end

	local Players = game:GetService("Players")
	local HttpService = game:GetService("HttpService")
	local LocalPlayer = Players.LocalPlayer

	if not LocalPlayer then
		repeat
			task.wait()
		until Players.LocalPlayer

		LocalPlayer = Players.LocalPlayer
	end

	local s1 = "en"

	pcall(function()
		if tostring(game:GetService("LocalizationService").RobloxLocaleId):sub(1, 2) == "pt" then
			s1 = "pt"
		end
	end)

	if type(getgenv) == "function" and getgenv().TSUO_LANG then
		s1 = tostring(getgenv().TSUO_LANG) == "pt" and "pt" or "en"
	end

	local function v16(p2, p3)
		return p3 or p2
	end
	local function v17()
		if type(gethwid) == "function" then
			local ok, result = pcall(gethwid)

			if ok and type(result) == "string" and #result > 0 then
				return result
			end
		end

		return tostring(LocalPlayer.UserId)
	end

	local v20 = v17()
	local v21 = tostring(LocalPlayer.UserId)
	local v22 = SLUG:gsub(" ", "%%20")

	local function v23(p4)
		local ok
		local result

		if syn and syn.request then
			ok, result = pcall(syn.request, p4)
		elseif request then
			ok, result = pcall(request, p4)
		elseif http_request then
			ok, result = pcall(http_request, p4)
		elseif http and http.request then
			ok, result = pcall(http.request, p4)
		end

		return ok and result and result.Body or nil
	end
	local function v26(p5)
		local v27 = v23({
			Url = p5,
			Method = "GET"
		})

		if not v27 then
			local function v28()
				local ok, result = pcall(function()
					return game:HttpGet(p5, true)
				end)
				local v31 = ok and result

				return v31 or nil
			end

			v27 = v28()
		end

		return v27
	end
	local function v32(p6, p7)
		local function v33()
			return HttpService:JSONEncode(p7)
		end

		local ok, result = pcall(v33)

		if ok then
			return v23({
				Url = p6,
				Method = "POST",
				Headers = {
					["Content-Type"] = "application/json"
				},
				Body = result
			})
		end

		return nil
	end
	local function v36()
		local v37 = v26(API_BASE .. "/check?hwid=" .. v20 .. "&legacyHwid=" .. v21 .. "&scriptSlug=" .. v22)

		if not v37 then
			return false
		end

		local ok, result = pcall(HttpService.JSONDecode, HttpService, v37)

		return ok and result and result.valid == true or false
	end

	local u40 = false

	local function v41(p8)
		if u40 then
			return
		end

		u40 = true
		task.spawn(function()
			pcall(function()
				local UserInputService = game:GetService("UserInputService")
				local s2 = "Unknown"

				pcall(function()
					if type(identifyexecutor) == "function" then
						s2 = tostring(identifyexecutor())
					end
				end)

				local s3 = "en-us"

				pcall(function()
					s3 = game:GetService("LocalizationService").RobloxLocaleId
				end)

				local Name

				pcall(function()
					Name = game:GetService("MarketplaceService"):GetProductInfo(game.PlaceId).Name
				end)
				v32(API_BASE .. "/execution", {
					hwid = v20,
					legacyHwid = v21,
					scriptSlug = SLUG,
					script = BUILD,
					key = p8,
					executor = s2,
					device = UserInputService.TouchEnabled and not UserInputService.KeyboardEnabled and "Mobile" or "PC",
					placeId = tostring(game.PlaceId),
					jobId = game.JobId,
					gameName = Name,
					premium = LocalPlayer.MembershipType == Enum.MembershipType.Premium,
					locale = s3,
					username = LocalPlayer.Name,
					userId = tostring(LocalPlayer.UserId)
				})
			end)
		end)
	end

	local color3 = Color3.fromRGB(110, 50, 230)
	local color32 = Color3.fromRGB(150, 95, 250)
	local color33 = Color3.fromRGB(20, 15, 30)
	local color34 = Color3.fromRGB(30, 21, 46)
	local color35 = Color3.fromRGB(28, 21, 40)
	local color36 = Color3.fromRGB(238, 233, 248)
	local color37 = Color3.fromRGB(158, 148, 178)

	local function v53(p9, p10)
		local instance = Instance.new(p9)

		for k, v in pairs(p10) do
			instance[k] = v
		end

		return instance
	end
	local function v57(p11, p12)
		v53("UICorner", {
			CornerRadius = UDim.new(0, p12 or 8),
			Parent = p11
		})
	end
	local function v58(p13, p14, p15, p16)
		return v53("UIStroke", {
			Color = p14 or color3,
			Thickness = p15 or 1,
			Transparency = p16 or 0.4,
			Parent = p13
		})
	end
	local function v59(p17, p18, p19, p20)
		return v53("UIGradient", {
			Color = ColorSequence.new(p18, p19),
			Rotation = p20 or 90,
			Parent = p17
		})
	end

	local ScreenGui = v53("ScreenGui", {
		Name = "TsuoKeyUI",
		ResetOnSpawn = false,
		IgnoreGuiInset = true,
		DisplayOrder = 100000,
		ZIndexBehavior = Enum.ZIndexBehavior.Sibling
	})

	if not pcall(function()
		ScreenGui.Parent = gethui()
	end) and not pcall(function()
		ScreenGui.Parent = game:GetService("CoreGui")
	end) then
		pcall(function()
			ScreenGui.Parent = LocalPlayer:WaitForChild("PlayerGui")
		end)
	end

	v53("Frame", {
		Size = UDim2.fromScale(1, 1),
		BackgroundColor3 = Color3.fromRGB(0, 0, 0),
		BackgroundTransparency = 0.45,
		BorderSizePixel = 0,
		Parent = ScreenGui
	})

	local Frame = v53("Frame", {
		AnchorPoint = Vector2.new(0.5, 0.5),
		Position = UDim2.fromScale(0.5, 0.5),
		Size = UDim2.fromOffset(460, 300),
		BackgroundColor3 = color33,
		BorderSizePixel = 0,
		Visible = true,
		Parent = ScreenGui
	})

	v57(Frame, 18)
	v58(Frame, color3, 1.5, 0.25)
	v59(Frame, color34, color33, 90)
	v53("ImageLabel", {
		BackgroundTransparency = 1,
		Image = LOGO,
		Size = UDim2.fromOffset(96, 96),
		Position = UDim2.new(0.5, -48, 0, 26),
		Parent = Frame
	})
	v53("TextLabel", {
		BackgroundTransparency = 1,
		Position = UDim2.new(0, 0, 0, 128),
		Size = UDim2.new(1, 0, 0, 26),
		Font = Enum.Font.GothamBold,
		Text = TITLE,
		TextSize = 20,
		TextColor3 = color36,
		Parent = Frame
	})
	v53("TextLabel", {
		BackgroundTransparency = 1,
		Position = UDim2.new(0, 0, 0, 152),
		Size = UDim2.new(1, 0, 0, 18),
		Font = Enum.Font.Gotham,
		Text = SUBTITLE,
		TextSize = 13,
		TextColor3 = color32,
		Parent = Frame
	})

	local TextLabel = v53("TextLabel", {
		BackgroundTransparency = 1,
		Position = UDim2.new(0, 20, 0, 176),
		Size = UDim2.new(1, -40, 0, 20),
		Font = Enum.Font.Gotham,
		Text = v16("Preparando o hub...", "Preparing your hub..."),
		TextSize = 13,
		TextColor3 = color37,
		TextWrapped = true,
		Parent = Frame
	})
	local Frame2 = v53("Frame", {
		AnchorPoint = Vector2.new(0.5, 0),
		Position = UDim2.new(0.5, 0, 0, 214),
		Size = UDim2.new(0.82, 0, 0, 10),
		BackgroundColor3 = color35,
		BorderSizePixel = 0,
		Parent = Frame
	})

	v57(Frame2, 6)
	v58(Frame2, color3, 1, 0.6)

	local Frame3 = v53("Frame", {
		Size = UDim2.new(0.04, 0, 1, 0),
		BackgroundColor3 = color3,
		BorderSizePixel = 0,
		Parent = Frame2
	})

	v57(Frame3, 6)
	v59(Frame3, color32, color3, 0)
	v53("TextLabel", {
		BackgroundTransparency = 1,
		Position = UDim2.new(0, 0, 1, -30),
		Size = UDim2.new(1, 0, 0, 18),
		Font = Enum.Font.Gotham,
		Text = VERSION,
		TextSize = 11,
		TextColor3 = color37,
		Parent = Frame
	})

	local Frame4 = v53("Frame", {
		AnchorPoint = Vector2.new(0.5, 0.5),
		Position = UDim2.fromScale(0.5, 0.5),
		Size = UDim2.fromOffset(380, 400),
		BackgroundColor3 = color33,
		BorderSizePixel = 0,
		Visible = false,
		Parent = ScreenGui
	})

	v57(Frame4, 16)
	v58(Frame4, color3, 1.5, 0.25)
	v59(Frame4, color34, color33, 90)
	v53("ImageLabel", {
		BackgroundTransparency = 1,
		Image = LOGO,
		Size = UDim2.fromOffset(72, 72),
		Position = UDim2.new(0.5, -36, 0, 20),
		Parent = Frame4
	})
	v53("TextLabel", {
		BackgroundTransparency = 1,
		Position = UDim2.new(0, 0, 0, 96),
		Size = UDim2.new(1, 0, 0, 24),
		Font = Enum.Font.GothamBold,
		Text = v16("PEGAR SUA KEY", "GET YOUR KEY"),
		TextSize = 18,
		TextColor3 = color36,
		Parent = Frame4
	})
	v53("TextLabel", {
		BackgroundTransparency = 1,
		Position = UDim2.new(0, 20, 0, 120),
		Size = UDim2.new(1, -40, 0, 32),
		Font = Enum.Font.Gotham,
		Text = v16("Cole sua key abaixo e clique em Enviar. Nao tem key? Pegue no nosso Discord.", "Paste your key below and click Submit. No key? Get one in our Discord."),
		TextSize = 12,
		TextColor3 = color37,
		TextWrapped = true,
		Parent = Frame4
	})

	local Frame5 = v53("Frame", {
		AnchorPoint = Vector2.new(0.5, 0),
		Position = UDim2.new(0.5, 0, 0, 156),
		Size = UDim2.new(0.86, 0, 0, 42),
		BackgroundColor3 = color35,
		BorderSizePixel = 0,
		Parent = Frame4
	})

	v57(Frame5, 8)
	v58(Frame5, color3, 1, 0.4)

	local TextBox = v53("TextBox", {
		AnchorPoint = Vector2.new(0.5, 0.5),
		Position = UDim2.fromScale(0.5, 0.5),
		Size = UDim2.new(1, -20, 1, -10),
		BackgroundTransparency = 1,
		Font = Enum.Font.Gotham,
		Text = "",
		PlaceholderText = v16("Cole a key aqui...", "Paste key here..."),
		PlaceholderColor3 = color37,
		TextColor3 = color36,
		TextSize = 14,
		ClearTextOnFocus = false,
		Parent = Frame5
	})
	local TextLabel2 = v53("TextLabel", {
		BackgroundTransparency = 1,
		Position = UDim2.new(0, 20, 0, 204),
		Size = UDim2.new(1, -40, 0, 32),
		Font = Enum.Font.Gotham,
		Text = "",
		TextSize = 12,
		TextColor3 = Color3.fromRGB(255, 120, 140),
		TextWrapped = true,
		TextYAlignment = Enum.TextYAlignment.Top,
		Parent = Frame4
	})

	local function v69(p21, p22, p23, p24)
		local v70 = v53
		local s4 = "TextButton"
		local v72 = v70(s4, {
			AnchorPoint = Vector2.new(0.5, 0),
			Position = UDim2.new(0.5, 0, 0, p21),
			Size = UDim2.new(0.86, 0, 0, p22),
			BackgroundColor3 = p24 and color3 or color35,
			AutoButtonColor = false,
			BorderSizePixel = 0,
			Font = Enum.Font.GothamMedium,
			Text = p23,
			TextSize = 14,
			TextColor3 = color36,
			Parent = Frame4
		})

		v57(v72, 8)

		local v73 = v58(v72, color3, 1, p24 and 0.7 or 0.4)

		v72.MouseEnter:Connect(function()
			local v74 = p24 and color32

			v72.BackgroundColor3 = v74 or color3
			v73.Transparency = 0
		end)
		v72.MouseLeave:Connect(function()
			v72.BackgroundColor3 = p24 and color3 or color35
			v73.Transparency = p24 and 0.7 or 0.4
		end)

		return v72
	end

	local v75 = v69(242, 40, v16("ENVIAR KEY", "SUBMIT KEY"), true)
	local v76 = v69(290, 34, v16("PEGAR KEY (Discord)", "GET KEY (Discord)"), false)
	local v77 = v69(330, 30, v16("FECHAR", "CLOSE"), false)

	local function v78(p25)
		local function v79()
			TextLabel.Text = tostring(p25 or "")
		end

		pcall(v79)
	end
	local function v80(p26)
		local v81 = math.clamp(tonumber(p26) or 0, 0, 1)

		pcall(function()
			Frame3:TweenSize(UDim2.new(v81, 0, 1, 0), Enum.EasingDirection.Out, Enum.EasingStyle.Quad, 0.35, true)
		end)
	end
	local function v82(p27)
		pcall(function()
			TextLabel2.TextColor3 = Color3.fromRGB(255, 120, 140)
			TextLabel2.Text = tostring(p27 or "")
		end)
	end
	local function v83(p28)
		pcall(function()
			TextLabel2.TextColor3 = color37
			TextLabel2.Text = tostring(p28 or "")
		end)
	end
	local function v84()
		pcall(function()
			Frame.Visible = true
			Frame4.Visible = false
		end)
	end
	local function v85()
		pcall(function()
			Frame.Visible = false
			Frame4.Visible = true
		end)
	end
	local function v86()
		pcall(function()
			ScreenGui:Destroy()
		end)
	end

	v78(v16("Conectando aos servidores Tsuo...", "Connecting to Tsuo servers..."))
	v80(0.18)

	local u87 = false
	local u88 = false

	task.spawn(function()
		u88 = v36()
		u87 = true
	end)
	v78(v16("Autenticando sua key...", "Authenticating your key..."))
	v80(0.42)

	local now = tick()

	while not u87 and tick() - now < 4 do
		task.wait(0.1)
	end

	if u87 and u88 then
		v41(nil)
		v78(v16("Key valida! Abrindo o hub...", "Key valid! Opening the hub..."))
		v80(1)
		task.wait(0.35)
		v86()

		return true
	end

	local u90 = false
	local u91 = false
	local u92 = false

	local function v93(p29)
		local v94 = tostring(p29 or ""):gsub("%s+", ""):upper()

		if v94 == "" then
			v82(v16("Digite sua key primeiro.", "Enter your key first."))

			return
		end

		u92 = true
		v83(v16("Verificando...", "Verifying..."))

		local n1 = 0
		local v96

		repeat
			n1 += 1
			v96 = v32(API_BASE .. "/validate", {
				key = v94,
				hwid = v20,
				legacyHwid = v21,
				scriptSlug = SLUG
			})

			if not v96 and n1 < 3 then
				task.wait(1.5)
			end
		until v96 or n1 >= 3

		if not v96 then
			u92 = false
			v82(v16("Erro de conexao. Cheque a internet e tente de novo.", "Network error. Check your connection and try again."))

			return
		end

		local ok, result = pcall(HttpService.JSONDecode, HttpService, v96)

		if ok and result and result.success then
			pcall(function()
				if type(writefile) == "function" then
					writefile(KEY_FILE, v94)
				end
			end)
			v41(v94)
			v84()
			v78(v16("Key valida! Abrindo o hub...", "Key valid! Opening the hub..."))
			v80(1)
			u91 = true
			u90 = true

			return
		end

		u92 = false

		if (ok and result and result.code or nil) == "not_registered" then
			v82(v16("Sua key nao esta registrada ainda. Abra tsuoblox.com/account, faca login, registre esta key em 'Minhas Keys' e tente de novo.", "Your key isn't registered yet. Open tsuoblox.com/account, sign in, register this key under 'My Keys', then try again."))
		else
			v82(ok and result and result.message or v16("Key invalida.", "Invalid key."))
		end
	end
	local function v99(p30)
		if u92 or u90 then
			return
		end

		local ok, result = pcall(v93, p30)

		if not ok then
			u92 = false
			warn("[TSUO KEY] erro na validacao: " .. tostring(result))

			local validationError = tostring(result):gsub("^.-:%d+:%s*", "")

			if #validationError > 90 then
				validationError = validationError:sub(1, 90) .. "..."
			end

			v82("Validation error: " .. validationError)
		end
	end

	v75.MouseButton1Click:Connect(function()
		task.spawn(v99, TextBox.Text)
	end)
	TextBox.FocusLost:Connect(function(enterPressed)
		if enterPressed then
			task.spawn(v99, TextBox.Text)
		end
	end)
	v76.MouseButton1Click:Connect(function()
		pcall(function()
			if type(setclipboard) == "function" then
				setclipboard(DISCORD)
			end
		end)
		v83(v16("Link do Discord copiado! Abra no navegador: " .. DISCORD, "Discord link copied! Open it in your browser: " .. DISCORD))
	end)
	v77.MouseButton1Click:Connect(function()
		u91 = false
		u90 = true
	end)
	v85()
	v83(v16("Cole sua key e clique em Enviar.", "Paste your key and click Submit."))
	pcall(function()
		if type(isfile) == "function" and isfile(KEY_FILE) and type(readfile) == "function" then
			local v103 = readfile(KEY_FILE)

			if type(v103) == "string" and #v103 > 3 then
				TextBox.Text = v103:gsub("%s+", "")
			end
		end
	end)

	if TextBox.Text ~= "" then
		task.spawn(function()
			task.wait(0.5)
			v99(TextBox.Text)
		end)
	end

	local now2 = tick()

	while not u90 and tick() - now2 < 600 do
		task.wait(0.2)
	end

	task.wait(0.35)
	v86()

	return u91
end)({
	SUBTITLE = "PVP King",
	SLUG = "Tsuo Hub",
	BUILD = "Tsuo PVP King",
	VERSION = "v2.1"
}) then
	return
end

if type(_G.__PVPKING_UNLOAD) == "function" then
	pcall(_G.__PVPKING_UNLOAD)
end

_G.__PVPKING_GEN = (_G.__PVPKING_GEN or 0) + 1
task.wait(0.15)

local function v105(p31)
	local service = game:GetService(p31)

	if type(cloneref) == "function" then
		local ok, result = pcall(cloneref, service)

		if ok and result then
			return result
		end
	end

	return service
end

local Players = v105("Players")
local RunService = v105("RunService")
local UserInputService = v105("UserInputService")
local Workspace = v105("Workspace")
local ReplicatedStorage = v105("ReplicatedStorage")
local TweenService = v105("TweenService")
local VirtualInputManager = v105("VirtualInputManager")
local LocalPlayer = Players.LocalPlayer

LocalPlayer:GetMouse()

local t1 = {}

local function v118(p32)
	t1[#t1 + 1] = p32

	return p32
end

if _G.__TSUO_Geracao == nil then
	_G.__TSUO_BF_GEN = _G.__PVPKING_GEN
end

local function v119()
	return _G.__PVPKING_GEN == _G.__PVPKING_GEN
end

_G.__TSUO_Escalona = _G.__TSUO_Escalona or function()
	task.wait(math.random() * 0.4)
end

local function v120(p33, p34)
	local connection = p33:Connect(p34)

	v118(connection)

	return connection
end

if not (workspace:FindFirstChild("Enemies") or workspace:FindFirstChild("Characters")) then
end

local v122 = game.PlaceId == 2753915549 or game.PlaceId == 85211729168715
local v123 = game.PlaceId == 4442272183 or game.PlaceId == 79091703265657
local v124 = game.PlaceId == 7449423635 or game.PlaceId == 100117331123089
local v125 = v122 and "SEA1" or v123 and "SEA2" or v124 and "SEA3" or ""
local tween
local u127
local n2 = 0
local n3 = 0
local u130 = false
local now = tick()
local n4 = 0
local t2 = {
	alvo = nil,
	dist = 0,
	seguidos = 0,
	janela = 0
}
local cFrame = cFrameNew(10641.0918, -1953.92981, 9825.07031)
local cFrame2 = cFrameNew(-16271.126, 25.5847301, 1371.98755)
local t3 = {
	SEA1 = function()
		local function v137(p35, ...)
			local v138 = _G.__TSUO_NoMapa(p35)

			for _, v in ipairs({ ... }) do
				if not v138 then
					return nil
				end

				v138 = v138:FindFirstChild(v)
			end

			return v138 and v138.Position or nil
		end

		return {
			FishmanSea1 = v137("TeleportSpawn", "EntrancePoint"),
			Sky2 = v137("SkyArea2", "PathwayHouse", "EntrancePoint"),
			Sky1 = v137("SkyArea1", "PathwayTemple", "ExitPoint")
		}
	end,
	SEA2 = function()
		return {
			CaFe = Vector3.new(-288, 305, 613),
			SwanRoom = Vector3.new(2284, 15, 897),
			GhostShip = (function()
				local GhostShipInterior = _G.__TSUO_NoMapa("GhostShipInterior")
				local TeleportSpawn = GhostShipInterior and GhostShipInterior:FindFirstChild("TeleportSpawn")

				return TeleportSpawn and TeleportSpawn.Position or nil
			end)()
		}
	end,
	SEA3 = function()
		return {
			Castle = Vector3.new(-5058, 314, -3155),
			Mansion = Vector3.new(-12463, 374, -7523)
		}
	end
}
local t4 = {}

if t3[v125] then
	local ok, result = pcall(t3[v125])

	if ok and type(result) == "table" then
		t4 = result
	end
end

Convert_To_CFrame = function(p36)
	local kind = typeof(p36)

	return kind == "Vector3" and cFrameNew(p36) or kind == "CFrame" and p36
end

local function v147(...)
	return ReplicatedStorage.Remotes.CommF_:InvokeServer(...)
end

local t5 = {
	destinosCache = nil,
	lidoEm = 0
}

_G.SubmarineMaxPrice = tonumber(_G.SubmarineMaxPrice) or 25000
t5.remote = function()
	for _, descendant in ipairs(ReplicatedStorage:GetDescendants()) do
		if descendant.Name == "RF/SubmarineTransportation" then
			return descendant
		end
	end

	return nil
end
t5.npc = function()
	local NPCs = workspace:FindFirstChild("NPCs")

	return NPCs and NPCs:FindFirstChild("Submarine Worker2") or nil
end
t5.ondeFicaAIlha = function()
	local _WorldOrigin = workspace:FindFirstChild("_WorldOrigin")
	local Locations = _WorldOrigin and _WorldOrigin:FindFirstChild("Locations")
	local SubmergedIsland = Locations and Locations:FindFirstChild("Submerged Island")

	if not SubmergedIsland then
		return nil
	end

	local ok, result = pcall(function()
		return SubmergedIsland:IsA("BasePart") and SubmergedIsland.Position or SubmergedIsland:GetPivot().Position
	end)

	return ok and result or nil
end
t5.preso = function()
	local HumanoidRootPart = LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("HumanoidRootPart")
	local v158 = t5.ondeFicaAIlha()

	if not HumanoidRootPart or not v158 then
		return false
	end

	if (HumanoidRootPart.Position - v158).Magnitude > 5000 then
		return false
	end

	return HumanoidRootPart.Position.Y < -1500
end
t5.destinos = function()
	if t5.destinosCache and tick() - t5.lidoEm < 120 then
		return t5.destinosCache
	end

	if not t5.buscando then
		t5.buscando = true
		task.spawn(function()
			local v159 = t5.remote()

			if v159 then
				local ok, destinosCache = pcall(function()
					return v159:InvokeServer("GetAvailableLocations")
				end)

				if ok and type(destinosCache) == "table" then
					local now2 = tick()

					t5.destinosCache = destinosCache
					t5.lidoEm = now2
				end
			end

			t5.buscando = false
		end)
	end

	return t5.destinosCache
end
t5.pontoDe = function(p37)
	local EndLocation = p37 and p37.EndLocation

	if EndLocation then
		return typeof(EndLocation) == "CFrame" and EndLocation.Position or EndLocation
	end

	return nil
end
t5.maisPerto = function(p38)
	local v164 = t5.destinos()

	if not v164 then
		return nil
	end

	local v165
	local huge = math.huge

	for _, v in pairs(v164) do
		if type(v) == "table" and v.Name then
			local v169 = t5.pontoDe(v)

			if v169 then
				local Magnitude = (v169 - p38).Magnitude

				if Magnitude < huge then
					huge = Magnitude
					v165 = v
				end
			end
		end
	end

	return v165, huge
end
t5.pontoConhecido = Vector3.new(11427.92, -2156.36, 9726.24)
t5.ondeEstaOWorker = nil
t5.viajar = function(p39)
	local v171 = t5.remote()
	local HumanoidRootPart = LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("HumanoidRootPart")

	if not v171 or not HumanoidRootPart then
		return false
	end

	local v173 = t5.npc()
	local HumanoidRootPart2 = v173 and (v173:FindFirstChild("HumanoidRootPart") or v173.PrimaryPart)

	if HumanoidRootPart2 then
		t5.ondeEstaOWorker = HumanoidRootPart2.CFrame
	elseif t5.ondeEstaOWorker or t5.pontoConhecido then
		HumanoidRootPart.CFrame = (t5.ondeEstaOWorker or cFrameNew(t5.pontoConhecido)) * cFrameNew(0, 0, 3)

		for i = 1, 20 do
			task.wait(0.25)

			local v176 = t5.npc()

			HumanoidRootPart2 = v176 and (v176:FindFirstChild("HumanoidRootPart") or v176.PrimaryPart)

			if HumanoidRootPart2 then
				break
			end
		end
	end

	if not HumanoidRootPart2 then
		return false
	end

	HumanoidRootPart.CFrame = HumanoidRootPart2.CFrame * cFrameNew(0, 0, 3)
	task.wait(1)

	local ok, result = pcall(function()
		return v171:InvokeServer("InitiateTeleport", p39)
	end)

	return ok and type(result) == "table"
end

local function v179()
	if tween then
		tween:Cancel()
		tween = nil
	end

	u130 = false
	u127 = nil
	_G.__TSUO_VOANDO = false
	pcall(function()
		local genv = getgenv()

		if genv then
			genv.TweenMonitor = false
		end
	end)
end

StopTween = function()
	v179()
end
CheckBackpack = function(p40)
	return LocalPlayer.Backpack:FindFirstChild(p40) or LocalPlayer.Character and LocalPlayer.Character:FindFirstChild(p40)
end
getdis = function(p41, p42)
	local HumanoidRootPart = LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("HumanoidRootPart")

	if not HumanoidRootPart then
		return 9e9
	end

	local Position = p42 or HumanoidRootPart.Position

	return (Vector3.new(p41.X, Position.Y, p41.Z) - Position).Magnitude
end
Distance = function(p43, p44, p45)
	local vector3 = Vector3.new(p43.X, p45 and 0 or p43.Y, p43.Z)

	if not p44 then
		local v184 = tick() + 8

		repeat
			task.wait(0.5)

			local HumanoidRootPart = LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("HumanoidRootPart")

			if HumanoidRootPart then
				p44 = HumanoidRootPart.Position
			end
		until p44 or v184 < tick()

		if not p44 then
			return math.huge
		end
	end

	return (vector3 - Vector3.new(p44.X, p45 and 0 or p44.Y, p44.Z)).Magnitude
end
Is_player_ready = function()
	local Character = LocalPlayer.Character

	return Character and Character:FindFirstChild("Humanoid") and Character:FindFirstChild("HumanoidRootPart") and Character.Humanoid.Health > 0
end
Is_raiding = function()
	local ok, result = pcall(function()
		if LocalPlayer:GetAttribute("IslandRaiding") == true then
			return true
		end

		local PlayerGui = LocalPlayer:FindFirstChild("PlayerGui")
		local Main = PlayerGui and PlayerGui:FindFirstChild("Main")
		local TopHUDList = Main and Main:FindFirstChild("TopHUDList")

		if not TopHUDList then
			return false
		end

		for _, v in ipairs({
			"RaidTimer",
			"PrehistoricRaidTimer"
		}) do
			local v194 = TopHUDList:FindFirstChild(v)

			if v194 and v194.Visible == true then
				return true
			end
		end

		return false
	end)

	return ok and result or StartingRaid == true
end
Check_raid_chip = function()
	local function v195(p46)
		for _, child in ipairs(p46:GetChildren()) do
			if not child:IsA("Tool") then
				continue
			end

			if child.Name:lower():find("microchip") then
				return true
			end
		end
	end

	return v195(LocalPlayer.Backpack) or v195(LocalPlayer.Character)
end
Check_fruit_inventory = function()
	local function v198(p47)
		for _, child in ipairs(p47:GetChildren()) do
			if child:IsA("Tool") and (child.ToolTip == "Blox Fruit" or child:GetAttribute("WeaponType") == "Demon Fruit") then
				return true
			end
		end
	end

	return v198(LocalPlayer.Backpack) or v198(LocalPlayer.Character)
end
checkmastery = function(p48, p49)
	local function v201(p50)
		local v202 = p50 and p50:FindFirstChild(p48)

		return v202 and v202:IsA("Tool") and v202:FindFirstChild("Level") and v202.Level.Value >= p49
	end

	return v201(LocalPlayer.Character) or v201(LocalPlayer.Backpack)
end

local function v203(p51)
	v179()
	PosMon = nil

	if not p51 then
		return
	end

	local HumanoidRootPart = p51:FindFirstChild("HumanoidRootPart")
	local BodyClip = HumanoidRootPart and HumanoidRootPart:FindFirstChild("BodyClip")

	if BodyClip then
		BodyClip:Destroy()
	end
end
local function v206(p52)
	v203(p52)

	local Humanoid = p52 and p52:FindFirstChildOfClass("Humanoid")

	if not Humanoid then
		Humanoid = p52 and p52:WaitForChild("Humanoid", 10)
	end

	if not Humanoid then
		return
	end

	v120(Humanoid.Died, function()
		v203(p52)
	end)
end

if LocalPlayer.Character then
	task.spawn(v206, LocalPlayer.Character)
end

local function v208(p53, p54)
	if type(_G.__TSUO_CharPronto) == "function" then
		return _G.__TSUO_CharPronto(p53, p54)
	end

	if not p53 then
		return nil
	end

	local v209 = tick() + (p54 or 15)

	while tick() < v209 do
		local Humanoid = p53:FindFirstChildOfClass("Humanoid")
		local HumanoidRootPart = p53:FindFirstChild("HumanoidRootPart")

		if Humanoid and HumanoidRootPart and Humanoid.Health > 0 and p53:IsDescendantOf(workspace) then
			task.wait()
			task.wait()

			return p53
		end

		task.wait(0.1)
	end

	return nil
end

v120(LocalPlayer.CharacterAdded, function(p55)
	if not v208(p55) then
		return
	end

	v206(p55)
end)
_G.__TSUO_RAROS = {
	"Hallow Essence",
	"Holy Torch",
	"God's Chalice",
	"Fist of Darkness",
	"Cursed Chalice",
	"Dragon Scale",
	"Magma Ore",
	"Scrap Metal",
	"Mystic Droplet",
	"Vampire Fang",
	"Conjured Cocoa",
	"Ectoplasm",
	"Bones",
	"Microchip",
	"Special Microchip"
}
_G.__TSUO_MOTIVO_RARO = nil
_G.__TSUO_SoNaMao = true

local t6 = {}

for _, v in ipairs({
	"TemRaro",
	"LocalDoBoss",
	"BossVale",
	"MinhaVez",
	"MovOcupado",
	"IrAte"
}) do
	t6[v] = _G["__TSUO_" .. v]
end

_G.__TSUO_TemRaro = function()
	local Character = LocalPlayer.Character
	local Backpack = LocalPlayer:FindFirstChild("Backpack")
	local v217 = _G.__TSUO_SoNaMao and { Character } or {
		Character,
		Backpack
	}

	for _, v in ipairs(v217) do
		local ipairs_ = ipairs
		local children = v and v:GetChildren() or {}

		for _, child in ipairs_(children) do
			if child:IsA("Tool") then
				for _, tsuoRaro in ipairs(_G.__TSUO_RAROS) do
					if child.Name == tsuoRaro then
						_G.__TSUO_MOTIVO_RARO = child.Name

						return true
					end
				end
			end
		end
	end

	_G.__TSUO_MOTIVO_RARO = nil

	return false
end

local function v226()
	local Character = LocalPlayer.Character
	local Humanoid = Character and Character:FindFirstChildOfClass("Humanoid")

	if not Character or not Humanoid then
		return
	end

	v203(Character)
	Humanoid.Sit = false
	Humanoid.Health = 0
	Humanoid:ChangeState(Enum.HumanoidStateType.Dead)
	task.delay(0.35, function()
		if LocalPlayer.Character == Character and Humanoid.Parent and Humanoid.Health <= 0 then
			pcall(function()
				Character:BreakJoints()
			end)
		end
	end)
end
local function v229(p56, p57)
	if not p56 then
		return
	end

	if p57 == false then
		local HumanoidRootPart = p56:FindFirstChild("HumanoidRootPart")

		if HumanoidRootPart then
			local AssemblyLinearVelocity = HumanoidRootPart.AssemblyLinearVelocity

			if math.abs(AssemblyLinearVelocity.X) + math.abs(AssemblyLinearVelocity.Y) + math.abs(AssemblyLinearVelocity.Z) < 3 and _G.__TSUO_VOANDO ~= true then
				_G.__TSUO_ParadoDesde = _G.__TSUO_ParadoDesde or tick()

				if tick() - _G.__TSUO_ParadoDesde > 1 then
					p57 = true
					_G.__TSUO_ChaoMantido = (_G.__TSUO_ChaoMantido or 0) + 1
				end
			else
				_G.__TSUO_ParadoDesde = nil
			end
		end
	end

	for _, descendant in ipairs(p56:GetDescendants()) do
		if descendant:IsA("BasePart") then
			descendant.CanCollide = p57
		end
	end
end

GetPortal = function(p58)
	local Position = typeof(p58) == "CFrame" and p58.Position or p58
	local vector3 = Vector3.zero
	local huge = math.huge
	local v237

	if t4 then
		for k, v in pairs(t4) do
			local Magnitude = (v - Position).Magnitude

			if Magnitude < huge then
				huge = Magnitude
				vector3 = v
				v237 = k
			end
		end
	end

	return vector3, v237
end
Check_Inventory = function(...)
	for _, v in pairs({ ... }) do
		if LocalPlayer.Backpack:FindFirstChild(v) then
			return true
		end

		if LocalPlayer.Character:FindFirstChild(v) then
			return true
		end
	end
end
old_tp = function(...)
	local v243 = Convert_To_CFrame(...)

	if not v243 or not Is_player_ready() then
		return
	end

	local Character = LocalPlayer.Character
	local HumanoidRootPart = Character and Character:FindFirstChild("HumanoidRootPart")
	local Humanoid = Character and Character:FindFirstChildOfClass("Humanoid")

	if not HumanoidRootPart or not Humanoid or Humanoid.Health <= 0 then
		return
	end

	local now2 = tick()
	local Position = v243.Position
	local Magnitude = (Position - HumanoidRootPart.Position).Magnitude

	now = now2

	if Magnitude >= 3000 and t5.preso() then
		_G.__TSUO_SubPorOldTp = (_G.__TSUO_SubPorOldTp or 0) + 1

		local v250, v251 = t5.maisPerto(Position)
		local huge = v250 and tonumber(v250.TransportationPrice) or math.huge
		local Beli = LocalPlayer:FindFirstChild("Data") and LocalPlayer.Data:FindFirstChild("Beli")

		if v250 and v251 < Magnitude and huge <= _G.SubmarineMaxPrice and Beli and huge <= Beli.Value and t5.viajar(v250.Name) then
			_G.__TSUO_SubOldTpDestino = string.format("%s (%s beli) as %s", tostring(v250.Name), tostring(huge), os.date("%H:%M:%S"))
			task.wait(3)

			return
		end
	end

	if u130 and tween and u127 and tween.PlaybackState == Enum.PlaybackState.Playing then
		if tick() - (n2 or 0) < (n3 or 0) + 1 and (u127.Position - Position).Magnitude < 10 then
			return
		end
	end

	if t2.alvo and (t2.alvo - Position).Magnitude < 300 and t2.dist - 200 <= Magnitude then
		n4 = now2 + 120
		t2.alvo = nil
	end

	_G.__TSUO_AtalhoMotivo = _G.__TSUO_AtalhoMotivo or {
		perto = 0,
		cooldown = 0,
		raid = 0,
		chip = 0,
		fruta = 0,
		item = 0,
		semPasta = 0,
		semSpawn = 0,
		longeDoAlvo = 0,
		naoCompensa = 0,
		recusado = 0,
		usou = 0,
		combate = 0
	}

	if Magnitude < 2000 then
		_G.__TSUO_AtalhoMotivo.perto += 1
	elseif now2 - n4 <= 15 then
		_G.__TSUO_AtalhoMotivo.cooldown += 1
	elseif _G.__TSUO_EmCombate and _G.__TSUO_EmCombate() then
		_G.__TSUO_AtalhoMotivo.combate = (_G.__TSUO_AtalhoMotivo.combate or 0) + 1
	elseif Is_raiding() then
		_G.__TSUO_AtalhoMotivo.raid += 1
	elseif Check_raid_chip() then
		_G.__TSUO_AtalhoMotivo.chip += 1
	elseif Check_fruit_inventory() then
		_G.__TSUO_AtalhoMotivo.fruta += 1
	elseif Check_Inventory("God's Chalice", "Red Key", "Apple", "Banana", "Pineapple", "Flower 1", "Flower 2", "Flower 3", "Sweet Chalice") then
		_G.__TSUO_AtalhoMotivo.item += 1
	end

	if Magnitude >= 2000 and now2 - n4 > 15 and (not _G.__TSUO_EmCombate or not _G.__TSUO_EmCombate()) and not Is_raiding() and not Check_raid_chip() and not Check_fruit_inventory() and not Check_Inventory("God's Chalice", "Red Key", "Apple", "Banana", "Pineapple", "Flower 1", "Flower 2", "Flower 3", "Sweet Chalice") then
		local _WorldOrigin = workspace:FindFirstChild("_WorldOrigin") or workspace:FindFirstChild("WorldOrigin")
		local PlayerSpawns = _WorldOrigin and _WorldOrigin:FindFirstChild("PlayerSpawns") and _WorldOrigin.PlayerSpawns:FindFirstChild(LocalPlayer.Team.Name)

		if not PlayerSpawns then
			local __TSUO_AtalhoMotivo = _G.__TSUO_AtalhoMotivo

			__TSUO_AtalhoMotivo.semPasta += 1
		end

		if PlayerSpawns then
			local function v257(p59, p60)
				return p59 < 2500 or p59 < p60 * 0.5
			end

			_G.__TSUO_SpawnRuim = _G.__TSUO_SpawnRuim or {}

			for k, v in pairs(_G.__TSUO_SpawnRuim) do
				if type(v) == "number" and tick() - v > 300 then
					_G.__TSUO_SpawnRuim[k] = nil
				end
			end

			local t7 = {}

			for _, child in ipairs(PlayerSpawns:GetChildren()) do
				if not _G.__TSUO_SpawnRuim[child.Name] then
					t7[#t7 + 1] = {
						child,
						(Position - child:GetPivot().Position).Magnitude
					}
				end
			end

			table.sort(t7, function(p61, p62)
				return p61[2] < p62[2]
			end)

			local v263
			local v264

			if t7[1] then
				v263 = t7[1][1]
				v264 = t7[1][2]
			end

			local __TSUO_AtalhoMotivo = _G.__TSUO_AtalhoMotivo

			if not v263 then
				__TSUO_AtalhoMotivo.semSpawn += 1
			elseif not v257(v264, Magnitude) then
				__TSUO_AtalhoMotivo.longeDoAlvo += 1
			elseif Magnitude - 1250 <= v264 then
				__TSUO_AtalhoMotivo.naoCompensa += 1
			end

			if v263 and _G.__TSUO_TemRaro and _G.__TSUO_TemRaro() then
				local __TSUO_AtalhoMotivo2 = _G.__TSUO_AtalhoMotivo

				__TSUO_AtalhoMotivo2.itemRaro = (__TSUO_AtalhoMotivo2.itemRaro or 0) + 1
				v263 = nil
			end

			if v263 and v257(v264, Magnitude) and v264 < Magnitude - 1250 then
				local Data = LocalPlayer:FindFirstChild("Data")
				local LastSpawnPoint = LocalPlayer:FindFirstChild("LastSpawnPoint") or Data and Data:FindFirstChild("LastSpawnPoint")

				if LastSpawnPoint then
					v179()

					local v269 = false

					for i = 1, 3 do
						pcall(v147, "SetLastSpawnPoint", v263.Name)

						local ok = pcall(function()
							return v147("SetSpawnPoint")
						end)

						if LastSpawnPoint.Value == v263.Name or ok then
							local Part = v263:FindFirstChild("Part")
							local Character2 = LocalPlayer.Character

							if Part and Character2 then
								pcall(function()
									Character2:PivotTo(Part.CFrame)
								end)
							end

							v226()
							v269 = true

							break
						else
							task.wait(0.2)
						end
					end

					local __TSUO_AtalhoMotivo2 = _G.__TSUO_AtalhoMotivo

					if v269 then
						__TSUO_AtalhoMotivo2.usou += 1
					else
						_G.__TSUO_SpawnRuim[v263.Name] = tick()
						__TSUO_AtalhoMotivo2.recusado += 1
					end

					n4 = v269 and tick() or tick() + 15

					if now2 - t2.janela > 90 then
						t2.seguidos = 0
						t2.janela = now2
					end

					if t2.dist > 0 and t2.dist - 500 <= Magnitude then
						t2.seguidos += 1

						if t2.seguidos >= 3 then
							n4 = now2 + 120
							t2.seguidos = 0
						end
					else
						t2.seguidos = 0
					end

					t2.alvo = Position
					t2.dist = Magnitude

					if v269 or LastSpawnPoint.Value == v263.Name then
						return
					end
				end
			end
		end
	end

	if u130 and u127 and (Position - u127.Position).Magnitude < 3 then
		return
	end

	v179()

	local v275 = v243.Y - HumanoidRootPart.Position.Y

	if math.abs(v275) > 1.5 then
		if math.abs(v275) <= 400 then
			HumanoidRootPart.CFrame = cFrameNew(HumanoidRootPart.Position.X, v243.Y, HumanoidRootPart.Position.Z)
		else
			local v276 = math.ceil(math.abs(v275) / 400)

			for i = 1, v276 do
				local HumanoidRootPart2 = LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("HumanoidRootPart")

				if not HumanoidRootPart2 then
					break
				end

				local Y = i == v276 and v243.Y

				if not Y then
					Y = HumanoidRootPart2.Position.Y + (v275 > 0 and 400 or -400)
				end

				HumanoidRootPart2.CFrame = cFrameNew(HumanoidRootPart2.Position.X, Y, HumanoidRootPart2.Position.Z)

				if i < v276 then
					task.wait(0.06)
				end
			end

			HumanoidRootPart = LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("HumanoidRootPart") or HumanoidRootPart
		end
	end

	if Magnitude < 15 then
		HumanoidRootPart.CFrame = v243 + Vector3.new(0, 3, 0)

		return
	end

	local v280 = math.clamp(tonumber(_G.TweenSpeed) or 300, 60, 300)

	u130 = true
	u127 = v243
	v229(Character, false)

	local v281 = (HumanoidRootPart.Position - v243.Position).Magnitude / v280

	n2 = tick()
	n3 = v281
	tween = TweenService:Create(HumanoidRootPart, TweenInfo.new(v281, Enum.EasingStyle.Linear), {
		CFrame = v243
	})
	tween:Play()
	_G.__TSUO_VOANDO = true

	local genv = getgenv()

	if not genv.TweenMonitor then
		genv.TweenMonitor = true
		task.spawn(function()
			_G.__TSUO_Escalona()

			while genv.TweenMonitor do
				local v283 = tween and tween.PlaybackState == Enum.PlaybackState.Playing

				if v283 then
					v283 = tick() - (n2 or 0) < (n3 or 0) + 2
				end

				if tick() - now > 2 and not v283 or not LocalPlayer.Character or not Humanoid or Humanoid.Health <= 0 then
					v179()

					if LocalPlayer.Character then
						v229(LocalPlayer.Character, true)
					end

					genv.TweenMonitor = false

					break
				end

				task.wait(0.3)
			end
		end)
	end
end
_G.__TSUO_MOV = _G.__TSUO_MOV or {
	dono = nil,
	ate = 0,
	nome = "-"
}
_G.__TSUO_BOSS_LOCAL = {
	{
		nome = "Darkbeard",
		cf = cFrameNew(3677.08203125, 62.751937866211, -3144.8332519531),
		tipo = "material"
	},
	{
		nome = "Don Swan",
		cf = cFrameNew(2286.2004394531, 15.177839279175, 863.8388671875),
		drops = { "Swan Glasses" },
		tipo = "accessory"
	},
	{
		nome = "Awakened Ice Admiral",
		cf = cFrameNew(5668.9780273438, 28.519989013672, -6483.3520507813),
		drops = { "Rengoku" },
		tipo = "weapon"
	},
	{
		nome = "Cursed Captain",
		cf = cFrameNew(916.928589, 181.092773, 33422),
		tipo = "material"
	},
	{
		nome = "Cake Queen",
		cf = cFrameNew(-709.3133, 381.6006, -11011.3965),
		tipo = "material"
	},
	{
		nome = "Beautiful Pirate",
		cf = cFrameNew(5283.6094, 22.5622, -110.7829),
		drops = { "Canvander" },
		tipo = "weapon"
	},
	{
		nome = "Captain Elephant",
		cf = cFrameNew(-13376.7578, 433.2869, -8071.3926),
		entrada = Vector3.new(-12471.169921875, 374.94024658203, -7551.677734375),
		drops = { "Twin Hooks" },
		tipo = "weapon",
		cacar = true
	},
	{
		nome = "Hydra Leader",
		cf = cFrameNew(5821.89794921875, 1019.0950927734375, -73.719230651855469),
		tipo = "weapon"
	},
	{
		nome = "Kilo Admiral",
		cf = cFrameNew(2764.2233886719, 432.46154785156, -7144.4580078125),
		tipo = "accessory"
	}
}
_G.__TSUO_LocalDoBoss = function(p63)
	for _, v in ipairs(_G.__TSUO_BOSS_LOCAL) do
		if v.nome == p63 then
			return v
		end
	end

	return nil
end
_G.__TSUO_BossVale = function(p64)
	local v286 = _G.__TSUO_LocalDoBoss(p64)

	if not v286 then
		return true
	end

	if not v286.drops then
		return true
	end

	for _, drop in ipairs(v286.drops) do
		if _G.__TSUO_QuantoTem then
			if _G.__TSUO_QuantoTem(drop) > 0 then
				return false
			end
		end
	end

	return true
end

local t8 = {
	safemode = 0,
	protect = 1,
	fruta = 3,
	ripindra = 4,
	elite = 5,
	factory = 6,
	boss = 7,
	reaper = 7,
	yama = 7,
	tushita = 7,
	raid = 10,
	lawkak = 11,
	race = 15,
	seatravel = 16,
	tplab = 18,
	chest = 19,
	tryluck = 19,
	sharkanchor = 19,
	seaentity = 20,
	ilha = 20,
	farm = 22
}

_G.__TSUO_PRIORIDADE = _G.__TSUO_PRIORIDADE or {}

for k, v in pairs(t8) do
	if _G.__TSUO_PRIORIDADE[k] == nil then
		_G.__TSUO_PRIORIDADE[k] = v
	end
end

local function v292(p65)
	local v293 = _G.__TSUO_PRIORIDADE[tostring(p65)]

	return v293 or _G.__TSUO_PRIORIDADE.farm or 22
end

if not _G.__TSUO_PegarMov then
	_G.__TSUO_PegarMov = function(p66, p67)
		if _G.__TSUO_MOV.dono and _G.__TSUO_MOV.dono ~= coroutine.running() and tick() < _G.__TSUO_MOV.ate then
			local v294 = v292(p66)

			if v292(_G.__TSUO_MOV.nome) <= v294 then
				return false
			end

			_G.__TSUO_MOV_ULTIMO = string.format("%s (andar %d) tomou de %s (andar %d)", tostring(p66), v292(p66), tostring(_G.__TSUO_MOV.nome), v292(_G.__TSUO_MOV.nome))
			pcall(function()
				if v179 then
					v179()
				end
			end)
		end

		_G.__TSUO_MOV = {
			dono = coroutine.running(),
			ate = tick() + (p67 or 30),
			nome = p66
		}

		return true
	end
	_G.__TSUO_LargarMov = function()
		if _G.__TSUO_MOV.dono == coroutine.running() then
			_G.__TSUO_MOV = {
				dono = nil,
				ate = 0,
				nome = "-"
			}
		end
	end
end

_G.__TSUO_MinhaVez = function(p68, p69)
	return _G.__TSUO_PegarMov(p68, p69 or 8)
end
_G.__TSUO_MovOcupado = function()
	return _G.__TSUO_MOV.dono ~= nil and _G.__TSUO_MOV.dono ~= coroutine.running() and tick() < _G.__TSUO_MOV.ate
end
_tp = function(p70, ...)
	if _G.SafeModeActive then
		v179()

		return
	end

	if _G.__TSUO_MOV.dono then
		if _G.__TSUO_MOV.dono ~= coroutine.running() and tick() < _G.__TSUO_MOV.ate then
			return
		end
	end

	local cFrame3 = typeof(p70) == "CFrame" and p70 or cFrameNew(p70)
	local HumanoidRootPart = LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("HumanoidRootPart")

	if not HumanoidRootPart then
		return
	end

	local Magnitude = (cFrame3.Position - HumanoidRootPart.Position).Magnitude

	if Magnitude < 100 then
		v179()
		v229(LocalPlayer.Character, true)
		HumanoidRootPart.CFrame = cFrame3 + Vector3.new(0, 3, 0)

		return
	end

	local v298 = u130 and u127 and (u127.Position - cFrame3.Position).Magnitude < 300

	if not _G.__TSUO_SemAtalho then
		if _G.__TSUO_SairDaSubmersa then
			pcall(_G.__TSUO_SairDaSubmersa, cFrame3.Position, Magnitude)
		end

		if _G.__TSUO_IrPelaCasa and not v298 then
			pcall(_G.__TSUO_IrPelaCasa, cFrame3.Position, Magnitude)
		end

		if _G.__TSUO_BypassIlha and not v298 then
			pcall(_G.__TSUO_BypassIlha, cFrame3.Position, Magnitude)
		end
	end

	local v299 = GetPortal(cFrame3)
	local v300 = false

	if v299 and v299 ~= Vector3.zero then
		v300 = (v299 - HumanoidRootPart.Position).Magnitude + (v299 - cFrame3.Position).Magnitude < Magnitude * 0.75
	end

	local v301 = not _G.__TSUO_SemAtalho and v299 and v299 ~= Vector3.zero and Magnitude >= 3000 and v300 and not v298

	if v301 then
		v301 = tick() - (_G.__TSUO_UltPortal or 0) > 8
	end

	_G.__TSUO_PortalRuim = _G.__TSUO_PortalRuim or {}

	local v302 = tostring(v299)

	if v301 then
		if tick() - (_G.__TSUO_PortalRuim[v302] or -1e9) < 900 then
			v301 = false
		end
	end

	if v301 then
		_G.__TSUO_UltPortal = tick()

		local Magnitude2 = (cFrame3.Position - HumanoidRootPart.Position).Magnitude

		v179()
		v147("requestEntrance", v299)
		task.wait(1)

		local HumanoidRootPart2 = LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("HumanoidRootPart")

		if not HumanoidRootPart2 then
			return
		end

		local Magnitude3 = (cFrame3.Position - HumanoidRootPart2.Position).Magnitude

		if Magnitude2 <= Magnitude3 then
			_G.__TSUO_PortalRuim[v302] = tick()
			_G.__TSUO_PortalMotivo = string.format("portal descartado: %d -> %d studs", math.floor(Magnitude2), math.floor(Magnitude3))
		end

		HumanoidRootPart = HumanoidRootPart2

		if Magnitude3 > 300 then
			return old_tp(cFrame3)
		end
	end

	if v124 and cFrame and getdis(cFrame3.Position, cFrame.Position) < 2000 and math.abs(cFrame.Y - HumanoidRootPart.Position.Y) > 1000 then
		local v306 = tick() + 25
		local n5 = 0
		local v308 = _G.MoonlightMovementAutomationActive() == true
		local v309 = _G.__TSUO_Geracao()

		repeat
			task.wait(0.15)

			if not v309() or v308 and not _G.MoonlightMovementAutomationActive() or _G.SafeModeActive or v306 < tick() then
				break
			end

			old_tp(cFrame2)

			if getdis(cFrame2) < 15 and tick() - n5 > 3 then
				n5 = tick()

				local Net = ReplicatedStorage.Modules.Net

				if Net:FindFirstChild("RF/SubmarineWorkerSpeak") then
					pcall(function()
						Net["RF/SubmarineWorkerSpeak"]:InvokeServer("AskKilledTikiBoss")
						task.wait(0.5)
						Net["RF/SubmarineWorkerSpeak"]:InvokeServer("TravelToSubmergedIsland")
					end)
				end
			end
		until getdis(cFrame3.Position) < 2000

		task.wait(0.6)
		pcall(function()
			local BodyClip = HumanoidRootPart:FindFirstChild("BodyClip")

			if BodyClip then
				BodyClip:Destroy()
			end
		end)
	end

	return old_tp(cFrame3, ...)
end
_G.__TSUO_IrAte = function(p71, p72, p73, p74)
	local cFrame3 = typeof(p71) == "CFrame" and p71 or typeof(p71) == "Vector3" and cFrameNew(p71) or nil

	if not cFrame3 then
		return false, "destino invalido"
	end

	local v313 = cFrame3 * cFrameNew(0, p73 or 36, 0)
	local v314 = p74 or "ilha"

	_G.__TSUO_IrAteCancelar = false

	local v315 = tick() + 90

	while tick() < v315 do
		if _G.__TSUO_IrAteCancelar then
			return false, "cancelado"
		end

		if _G.__TSUO_BF_GEN ~= _G.__TSUO_BF_GEN then
			return false, "hub recarregado"
		end

		if p72 and not p72() then
			return false, "cancelado"
		end

		local Character = LocalPlayer.Character
		local HumanoidRootPart = Character and Character:FindFirstChild("HumanoidRootPart")

		if not HumanoidRootPart then
			return false, "no character"
		end

		if (HumanoidRootPart.Position - v313.Position).Magnitude <= 60 then
			_G.__TSUO_LargarMov()

			return true, "chegou"
		end

		if not _G.__TSUO_MinhaVez(v314, 8) then
			_G.__TSUO_ViajandoAte = nil

			return false, "another feature took over"
		end

		_G.__TSUO_ViajandoAte = tick()
		_tp(v313)
		task.wait(0.5)
	end

	_G.__TSUO_LargarMov()

	return false, string.format("%.0f studs to go", (function()
		local HumanoidRootPart = LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("HumanoidRootPart")

		return HumanoidRootPart and (HumanoidRootPart.Position - v313.Position).Magnitude or -1
	end)())
end

local t9 = {
	Master = true,
	Aim = true,
	AimFovGraus = 120,
	FovModo = "Camera",
	AimMaxStuds = 400,
	AimPrever = false,
	AimSoVisivel = false,
	AimAlcanceModo = 1,
	AimNpc = false,
	Puxar = false,
	PuxarDistancia = 18,
	PuxarAltura = 4,
	SoTimeInimigo = true,
	PularZonaSegura = true,
	PularNivelBaixo = false,
	AimNaZonaSegura = false,
	AimVirar = true,
	AimAlvo = "Torso",
	EspMostrarPulados = true,
	MostrarFov = true,
	Esp = false,
	EspCaixa = true,
	EspNome = true,
	EspVida = true,
	EspDistancia = true,
	EspTracer = false,
	EspSeta = true,
	EspChams = false,
	EspSoVisivel = false,
	EspDist = 25000,
	EspFicha = true,
	EspArma = true,
	EspNivel = true,
	EspHaki = true,
	EspVidaTexto = true,
	EspAliado = true,
	EspZonaSegura = true,
	EspFruta = false,
	EspIlha = false,
	EspBau = false,
	EspMundoDist = 3000,
	EspCor = Color3.fromRGB(255, 64, 64),
	MiraSkill = true,
	MiraSkillAlcance = 1500,
	AimAltura = true,
	FastAttack = false,
	FastAttackAlcance = 100,
	FastAttackRitmo = 0.12,
	SkillAuto = false,
	SkillEspera = 1,
	SkillSoComAlvo = true,
	EquiparAuto = false,
	SkillZ = true,
	SkillX = true,
	SkillC = true,
	SkillV = false,
	SkillF = false,
	AntiStun = false,
	AutoBuso = false,
	AutoObs = false,
	AutoV3 = false,
	AutoV4 = false,
	StaminaInf = false,
	Velocidade = false,
	VelocidadeVal = 90,
	Pulo = false,
	PuloVal = 130,
	PuloInfinito = false,
	Dash = false,
	DashVal = 171,
	DashDistancia = 120,
	Spin = false,
	SpinVelocidade = 720,
	AndarNaAgua = false,
	SemColisao = false,
	TpAltura = 36
}
local u320
local u321
local s5 = "off"

local function v323(p75)
	local v324 = p75

	if type(p75) == "table" then
		return nil
	end

	if typeof(p75) ~= "Instance" then
		return nil
	end

	if not v324:IsA("Player") then
		return nil
	end

	local leaderstats = v324:FindFirstChild("leaderstats")
	local BountyHonor = leaderstats and leaderstats:FindFirstChild("Bounty/Honor")

	return BountyHonor and tonumber(BountyHonor.Value) or nil
end
local function v327(p76)
	if not p76 then
		return "none"
	end

	if typeof(p76) ~= "Instance" then
		return p76.nome or "?"
	end

	local DisplayName = p76.DisplayName or p76.Name
	local v329 = v323(p76)

	if v329 then
		_G.__TSUO_PVP_BOUNTY_DIZ = string.format("%s: %d bounty", DisplayName, v329)

		return string.format("%s (%d)", DisplayName, v329)
	end

	return DisplayName
end
local function v330(p77)
	if type(p77) == "table" and p77.char then
		return p77.char
	end

	return p77 and p77.Character
end
local function v331(p78)
	return p78 and p78:FindFirstChildOfClass("Humanoid")
end
local function v332(p79)
	local v333 = v331(p79)

	return v333 and v333.Health > 0 or false
end
local function v334(p80)
	return p80 and (p80:FindFirstChild("HumanoidRootPart") or p80:FindFirstChild("Torso") or p80:FindFirstChild("UpperTorso"))
end
local function v335()
	return v330(LocalPlayer)
end
local function v336()
	return v332(v335())
end

local SafeZones

local function v338()
	local PlayerGui = LocalPlayer:FindFirstChild("PlayerGui")
	local Main = PlayerGui and PlayerGui:FindFirstChild("Main")

	if not Main then
		return false
	end

	local BottomHUDList = Main:FindFirstChild("BottomHUDList")
	local SafeZone = BottomHUDList and BottomHUDList:FindFirstChild("SafeZone")

	if SafeZone and SafeZone.Visible then
		return true, "safe zone"
	end

	local PvpDisabled = Main:FindFirstChild("PvpDisabled")

	if PvpDisabled and PvpDisabled.Visible then
		return true, "died recently"
	end

	return false
end
local function v344(p81)
	if not p81 then
		return false
	end

	local HumanoidRootPart = p81:FindFirstChild("HumanoidRootPart")

	if not HumanoidRootPart then
		return false
	end

	local InSafeZone = p81:FindFirstChild("InSafeZone")

	if InSafeZone and InSafeZone.Value then
		return true
	end

	if p81:FindFirstChildOfClass("ForceField") then
		return true
	end

	if not SafeZones or not SafeZones.Parent then
		local _WorldOrigin = Workspace:FindFirstChild("_WorldOrigin")

		SafeZones = _WorldOrigin and _WorldOrigin:FindFirstChild("SafeZones")
	end

	if not SafeZones then
		return false
	end

	for _, child in ipairs(SafeZones:GetChildren()) do
		if child:IsA("BasePart") then
			local SpecialMesh = child:FindFirstChildOfClass("SpecialMesh")

			if (child.Position - HumanoidRootPart.Position).Magnitude <= (SpecialMesh and math.max(SpecialMesh.Scale.X, SpecialMesh.Scale.Y, SpecialMesh.Scale.Z) / 2 or 0) then
				return true
			end
		end
	end

	return false
end
local function v351(p82)
	local ok, result = pcall(function()
		return tonumber(p82.Data.Level.Value)
	end)

	return ok and result or nil
end
local function v354(p83)
	local Data = p83:FindFirstChild("Data")
	local CrewID = Data and Data:FindFirstChild("CrewID")
	local v357 = CrewID and tostring(CrewID.Value) or ""

	if v357 == "" or v357 == "nil" then
		return nil
	end

	return v357
end

local u358

local function v359()
	local Name = LocalPlayer.Team and LocalPlayer.Team.Name

	if Name then
		u358 = Name
	end

	return Name or u358
end
local function v361(p84)
	local v362 = v354(LocalPlayer)
	local v363 = v354(p84)

	if v362 and v363 and v362 == v363 then
		return true
	end

	if v359() == "Marines" then
		if (p84.Team and p84.Team.Name) == "Marines" then
			return true
		end
	end

	return false
end
local function v364(p85)
	if p85:GetAttribute("InSafeZone") == true then
		return true, "in safe zone"
	end

	if p85:GetAttribute("PvpDisabled") == true then
		return true, "pvp off"
	end

	return false
end
local function v365(p86)
	if p86 == LocalPlayer then
		return "you"
	end

	local v366 = v330(p86)

	if not v366 then
		return "no character"
	end

	local v367 = v331(v366)

	if not v367 or not (v367.Health > 0) then
		return "dead"
	end

	if not v334(v366) then
		return "no root"
	end

	if t9.SoTimeInimigo and v361(p86) then
		return "same crew"
	end

	if t9.PularZonaSegura and not t9.AimNaZonaSegura then
		local v368, v369 = v338()

		if v368 then
			return "your pvp is off (" .. tostring(v369) .. ")"
		end
	end

	if t9.PularZonaSegura then
		local v370, v371 = v364(p86)

		if v370 then
			return v371
		end

		if v344(v366) and not v344(v335()) then
			return "safe zone"
		end
	end

	if t9.PularNivelBaixo then
		local v372 = v351(LocalPlayer)
		local v373 = v351(p86)

		if v372 and v373 then
			if v373 < math.floor(v372 * 0.75) then
				return "low level"
			end
		end
	end

	return nil
end
local function v374(p87)
	return v365(p87) == nil
end
local function v375()
	return Workspace:FindFirstChild("Enemies") or Workspace:FindFirstChild("Characters")
end
local function v376()
	local t10 = {}
	local v378 = v375()

	if not v378 then
		return t10
	end

	for _, child in ipairs(v378:GetChildren()) do
		if child:IsA("Model") then
			local Humanoid = child:FindFirstChildOfClass("Humanoid")
			local HumanoidRootPart = child:FindFirstChild("HumanoidRootPart")

			if Humanoid and HumanoidRootPart and Humanoid.Health > 0 then
				t10[#t10 + 1] = {
					nome = child.Name,
					char = child
				}
			end
		end
	end

	return t10
end

local raycastParams = RaycastParams.new()

raycastParams.FilterType = Enum.RaycastFilterType.Exclude
raycastParams.IgnoreWater = true

local function v384(p88, p89, p90)
	raycastParams.FilterDescendantsInstances = {
		v335(),
		p89,
		p90
	}

	local Position = p90.CFrame.Position
	local v386 = p88 - Position

	if v386.Magnitude < 1 then
		return true
	end

	return Workspace:Raycast(Position, v386, raycastParams) == nil
end
local function v387()
	local mouseLocation = UserInputService:GetMouseLocation()

	return Vector2.new(mouseLocation.X, mouseLocation.Y)
end
local function v389(p91, p92, p93)
	if t9.AimAlvo == "Torso" then
		return p91:FindFirstChild("HumanoidRootPart") or p91:FindFirstChild("UpperTorso") or p91:FindFirstChild("Torso")
	end

	if t9.AimAlvo == "Head" then
		return p91:FindFirstChild("Head") or v334(p91)
	end

	local v390
	local huge = math.huge

	for _, child in ipairs(p91:GetChildren()) do
		if child:IsA("BasePart") and child.Transparency < 1 then
			local v394 = p92:WorldToViewportPoint(child.Position)

			if v394.Z > 0 then
				local v395 = v394.X - p93.X
				local v396 = v394.Y - p93.Y
				local v397 = v395 * v395 + v396 * v396

				if v397 < huge then
					huge = v397
					v390 = child
				end
			end
		end
	end

	return v390 or v334(p91)
end

local t11 = {
	alvo = nil,
	parte = nil,
	quando = 0
}

local function v399(p94, p95, p96, p97)
	local alvo = t11.alvo

	if alvo and alvo ~= p94 then
		local v401 = p97[alvo]

		if v401 and v401.Parent then
			local v402 = v330(alvo)

			if v402 and v402.Parent and v332(v402) then
				if not p96 or (v401.Position - (t11.origem or v401.Position)).Magnitude < p96 * 1.33 then
					p94 = alvo
					p95 = v401
				end
			end
		end
	end

	local now2 = os.clock()

	t11.alvo = p94
	t11.parte = p95
	t11.quando = now2

	return p94, p95
end
local function v404(p98, p99)
	local v405 = v334(v335())
	local Position = v405 and v405.Position or p98.CFrame.Position

	t11.origem = Position

	local t12 = {}

	if t9.AimAlcanceModo == 2 then
		local v408
		local v409
		local MiraSkillAlcance = t9.MiraSkillAlcance

		for _, player in ipairs(Players:GetPlayers()) do
			if v374(player) then
				local v413 = v389(v330(player), p98, p99)

				if v413 then
					local Magnitude = (v413.Position - Position).Magnitude

					if Magnitude <= t9.MiraSkillAlcance then
						t12[player] = v413
					end

					if Magnitude < MiraSkillAlcance then
						MiraSkillAlcance = Magnitude
						v408 = player
						v409 = v413
					end
				end
			end
		end

		if t9.AimNpc then
			for _, v in ipairs(v376()) do
				local v417 = v389(v.char, p98, p99)

				if v417 then
					local Magnitude = (v417.Position - Position).Magnitude

					if Magnitude <= t9.MiraSkillAlcance then
						t12[v] = v417
					end

					if Magnitude < MiraSkillAlcance then
						MiraSkillAlcance = Magnitude
						v408 = v
						v409 = v417
					end
				end
			end
		end

		return v399(v408, v409, MiraSkillAlcance, t12)
	end

	local v419 = (t9.AimFovGraus or 120) / 2
	local v420 = (t9.AimFovGraus or 120) >= 360
	local LookVector = p98.CFrame.LookVector
	local v422 = t9.FovModo == "Mouse"
	local n6 = 0

	if v422 then
		if v420 then
			n6 = math.huge
		else
			local v424 = math.rad((p98.FieldOfView or 70) / 2)

			n6 = math.tan(math.rad(math.min(t9.AimFovGraus or 120, 158) / 2)) / math.max(math.tan(v424), 0.001) * (p98.ViewportSize.Y / 2)
		end
	end

	local v425
	local v426
	local huge = math.huge
	local v428
	local v429
	local huge2 = math.huge

	for _, player in ipairs(Players:GetPlayers()) do
		if v374(player) then
			local v433 = v330(player)
			local v434 = v334(v433)

			if v434 and (v434.Position - Position).Magnitude <= t9.MiraSkillAlcance then
				local v435 = v389(v433, p98, p99)

				if v435 then
					local v436 = v435.Position - p98.CFrame.Position

					if v436.Magnitude > 0.1 then
						local v437

						if v422 then
							local v438 = p98:WorldToViewportPoint(v435.Position)

							if v438.Z > 0 then
								local v439 = v438.X - p99.X
								local v440 = v438.Y - p99.Y

								v437 = math.sqrt(v439 * v439 + v440 * v440) <= n6
							else
								v437 = false
							end
						else
							local v441 = math.deg(math.acos(math.clamp(LookVector:Dot(v436.Unit), -1, 1)))

							v437 = v420 or v441 <= v419
						end

						if v437 then
							local Magnitude = (v435.Position - Position).Magnitude
							local AimSoVisivel = (t9.AimSoVisivel or Magnitude < huge2) and v384(v435.Position, v433, p98) or false

							if not t9.AimSoVisivel or AimSoVisivel then
								t12[player] = v435
							end

							if AimSoVisivel and Magnitude < huge2 then
								huge2 = Magnitude
								v428 = player
								v429 = v435
							end

							if Magnitude < huge and (not t9.AimSoVisivel or AimSoVisivel) then
								huge = Magnitude
								v425 = player
								v426 = v435
							end
						end
					end
				end
			end
		end
	end

	if t9.AimNpc then
		for _, v in ipairs(v376()) do
			local v446 = v334(v.char)

			if v446 and (v446.Position - Position).Magnitude <= t9.MiraSkillAlcance then
				local v447 = v389(v.char, p98, p99)

				if v447 and p98:WorldToViewportPoint(v447.Position).Z > 0 then
					local Magnitude = (v447.Position - Position).Magnitude
					local AimSoVisivel = (t9.AimSoVisivel or Magnitude < huge2) and v384(v447.Position, v.char, p98) or false

					if not t9.AimSoVisivel or AimSoVisivel then
						t12[v] = v447
					end

					if AimSoVisivel and Magnitude < huge2 then
						huge2 = Magnitude
						v428 = v
						v429 = v447
					end

					if Magnitude < huge then
						if not t9.AimSoVisivel or AimSoVisivel then
							huge = Magnitude
							v425 = v
							v426 = v447
						end
					end
				end
			end
		end
	end

	if v428 then
		return v399(v428, v429, huge2, t12)
	end

	return v399(v425, v426, huge, t12)
end

local raycastParams2 = RaycastParams.new()

raycastParams2.FilterType = Enum.RaycastFilterType.Exclude

local function v451(p100)
	local HumanoidRootPart = p100 and p100:FindFirstChild("HumanoidRootPart")
	local Humanoid = p100 and p100:FindFirstChildOfClass("Humanoid")

	if HumanoidRootPart and Humanoid then
		return HumanoidRootPart.Size.Y * 0.5 + Humanoid.HipHeight
	end

	return 1.5
end
local function v454(p101, p102)
	raycastParams2.FilterDescendantsInstances = {
		v335(),
		p102
	}

	if Workspace:Raycast(p101 + Vector3.new(0, 0.1, 0), Vector3.new(0, -0.2, 0), raycastParams2) then
		return p101 + Vector3.new(0, math.min(3.5, v451(p102)), 0)
	end

	return p101
end
local function v455(p103, p104, p105)
	local Position = p103.Position

	if t9.AimPrever then
		local AssemblyLinearVelocity = p103.AssemblyLinearVelocity

		if AssemblyLinearVelocity and AssemblyLinearVelocity.Magnitude >= 1 then
			Position += AssemblyLinearVelocity * math.clamp((Position - p104).Magnitude / 100 * 0.06, 0, 0.45)
		end
	end

	if t9.AimAltura and p105 then
		local ok, result = pcall(v454, Position, p105)

		if ok and typeof(result) == "Vector3" then
			Position = result
		end
	end

	return Position
end

for k, v in pairs(t6) do
	if v ~= nil then
		_G["__TSUO_" .. k] = v
	end
end

local function v462()
	local v463 = v335()

	if not v463 then
		return nil
	end

	for _, child in ipairs(v463:GetChildren()) do
		if child:IsA("Tool") then
			return child
		end
	end

	return nil
end
local function v466()
	if not t9.Master or not t9.Aim then
		return nil
	end

	local CurrentCamera = Workspace.CurrentCamera

	if not CurrentCamera then
		return nil
	end

	local v468, v469 = v404(CurrentCamera, v387())

	if v468 then
		if v469 then
			local v470 = v334(v335())

			return v455(v469, v470 and v470.Position or CurrentCamera.CFrame.Position, v330(v468)), v468, v469
		end
	end

	return nil
end

local t13 = {}

v120(RunService.Heartbeat, function()
	if not v119() then
		return
	end

	local v472 = v335()

	if not v472 then
		return
	end

	for _, child in ipairs(v472:GetChildren()) do
		if child:IsA("Tool") then
			local Holding = child:FindFirstChild("Holding")

			if Holding and Holding.Value == true then
				t13[child] = t13[child] or os.clock()

				if os.clock() - t13[child] > 3 then
					Holding.Value = false
					t13[child] = nil
					_G.__TSUO_PVP_HOLDING_SOLTO = (_G.__TSUO_PVP_HOLDING_SOLTO or 0) + 1
				end
			elseif Holding then
				t13[child] = nil
			end
		end
	end
end)

do
	local function v476()
		local Mouse = ReplicatedStorage:FindFirstChild("Mouse")

		if not Mouse then
			return nil
		end

		local ok, result = pcall(require, Mouse)

		if ok and type(result) == "table" and result.Hit ~= nil then
			return result
		end

		return nil
	end

	local v480 = v476()
	local cFrame3 = CFrame.Angles(0, math.pi, 0)

	pcall(function()
		if LocalPlayer then
			LocalPlayer:SetAttribute("AAIM", nil)
		end
	end)

	local attribute
	local u483 = false

	local function v484(p106)
		if not LocalPlayer then
			return
		end

		if p106 and not u483 then
			attribute = LocalPlayer:GetAttribute("AAIM")
			pcall(function()
				LocalPlayer:SetAttribute("AAIM", true)
			end)
			u483 = true
		elseif not p106 and u483 then
			pcall(function()
				LocalPlayer:SetAttribute("AAIM", attribute)
			end)
			u483 = false
		end
	end

	local t14

	local function v486()
		local v487 = t14

		if v487 then
			if v487.parte then
				if v487.parte.Parent then
					if os.clock() - v487.quando > 0.5 then
						return nil
					end

					local CurrentCamera = Workspace.CurrentCamera

					if CurrentCamera then
						return cFrameNew(v487.parte.Position, CurrentCamera.CFrame.Position) * cFrame3
					end

					return nil
				end
			end
		end

		return nil
	end

	if v480 then
		local v489 = getmetatable(v480)
		local value = rawget(v480, "Hit")

		rawset(v480, "Hit", nil)
		pcall(setmetatable, v480, {
			__index = function(p107, p108)
				if p108 == "Hit" then
					return v486() or value
				end

				if v489 then
					local value2 = rawget(v489, "__index")

					if type(value2) == "function" then
						return value2(p107, p108)
					end

					if type(value2) == "table" then
						return value2[p108]
					end
				end

				return nil
			end,
			__newindex = function(p109, p110, p111)
				if p110 == "Hit" then
					value = p111

					return
				end

				rawset(p109, p110, p111)
			end
		})
		v118({
			Destroy = function()
				pcall(function()
					setmetatable(v480, v489)
					rawset(v480, "Hit", value)
				end)
			end
		})
	end

	local function v492()
	end

	local connection
	local u494
	local u495

	local function v496(p112)
		if connection then
			connection:Disconnect()
			connection = nil
		end

		if not p112 then
			return
		end

		local MousePos = p112:FindFirstChild("MousePos")

		if not MousePos then
			return
		end

		connection = MousePos:GetPropertyChangedSignal("Value"):Connect(function()
			local v498 = u494

			if v498 then
				if (MousePos.Value - v498).Magnitude > 0.05 then
					MousePos.Value = v498
				end

				return
			end
		end)
		v118({
			Destroy = function()
				if connection then
					connection:Disconnect()
					connection = nil
				end
			end
		})
	end

	local u499
	local t15 = {}

	local function v501(p113)
		if not p113 then
			return nil
		end

		local Name = p113.Name
		local v503 = t15[Name]

		if v503 ~= nil then
			return v503 or nil
		end

		local ok, result = pcall(function()
			local CombatUtil = require(ReplicatedStorage.Modules.CombatUtil)

			return CombatUtil:GetWeaponData(CombatUtil:GetWeaponName(p113) or Name)
		end)

		t15[Name] = ok and type(result) == "table" and result or false

		return t15[Name] or nil
	end
	local function v507(p114)
		local LocalEquippedWeaponPointer = p114 and p114:FindFirstChild("LocalEquippedWeaponPointer")
		local Value = LocalEquippedWeaponPointer and LocalEquippedWeaponPointer.Value

		if Value then
			local ShootAttachment1 = Value:FindFirstChild(Value:GetAttribute("CurrentShootAttachment") or "ShootAttachment", true) or Value:FindFirstChild("ShootAttachment1", true)

			if ShootAttachment1 then
				if ShootAttachment1:IsA("Attachment") then
					return ShootAttachment1.WorldPosition
				end

				if ShootAttachment1:IsA("BasePart") then
					return ShootAttachment1.Position
				end
			end
		end

		local v511 = v334(v335())

		return v511 and v511.Position or nil
	end

	local raycastParams3 = RaycastParams.new()

	raycastParams3.FilterType = Enum.RaycastFilterType.Exclude

	local t16 = {
		"UpperTorso",
		"Torso",
		"HumanoidRootPart",
		"Head",
		"LowerTorso",
		"RightUpperArm",
		"LeftUpperArm",
		"RightUpperLeg",
		"LeftUpperLeg",
		"RightHand",
		"LeftHand",
		"RightFoot",
		"LeftFoot"
	}

	local function v514(p115, p116)
		if not p115 or not p116 then
			return nil
		end

		local filterDescendantsInstances = { v335() }
		local Boats = Workspace:FindFirstChild("Boats")

		if Boats then
			filterDescendantsInstances[#filterDescendantsInstances + 1] = Boats
		end

		local _WorldOrigin = Workspace:FindFirstChild("_WorldOrigin")

		if _WorldOrigin then
			filterDescendantsInstances[#filterDescendantsInstances + 1] = _WorldOrigin
		end

		raycastParams3.FilterDescendantsInstances = filterDescendantsInstances

		for _, v in ipairs(t16) do
			local v520 = p115:FindFirstChild(v)

			if v520 and v520:IsA("BasePart") then
				local hit = Workspace:Raycast(p116, v520.Position - p116, raycastParams3)

				if not hit or not hit.Instance then
					continue
				end

				if hit.Instance:IsDescendantOf(p115) then
					return v520.Position
				end
			end
		end

		return nil
	end
	local function v522()
		local Controllers = ReplicatedStorage:FindFirstChild("Controllers")
		local CombatController = Controllers and Controllers:FindFirstChild("CombatController")
		local AimAssist = CombatController and CombatController:FindFirstChild("AimAssist")

		if not AimAssist then
			return nil
		end

		local ok, result = pcall(require, AimAssist)

		if ok and type(result) == "table" and type(result.getTargetInfo) == "function" then
			return result
		end

		return nil
	end

	local v528 = v522()

	if v528 then
		local getTargetInfo = v528.getTargetInfo

		v528.getTargetInfo = function(...)
			local v530 = u499

			if v530 then
				return {
					Part = {
						CFrame = cFrameNew(v530)
					}
				}
			end

			return getTargetInfo(...)
		end
		v118({
			Destroy = function()
				pcall(function()
					v528.getTargetInfo = getTargetInfo
				end)
			end
		})
	end

	local function v531(p117, p118)
		if not v480 then
			return false
		end

		if not Workspace.CurrentCamera then
			return false
		end

		v484(false)
		t14 = {
			parte = p118,
			quando = os.clock()
		}

		return true
	end

	local ok, result = pcall(function()
		return LocalPlayer:GetMouse()
	end)

	if ok and result then
		v120(result.Move, v492)
	end

	v120(RunService.RenderStepped, v492)
	v120(RunService.Heartbeat, v492)
	v120(UserInputService.InputBegan, function(p119, p120)
		if p120 then
			return
		end

		v492()
	end)
	v120(RunService.Stepped, function()
		if not v119() then
			return
		end

		u320 = nil
		u321 = nil

		if not t9.Master or not t9.Aim then
			s5 = "off"
			v484(false)
			u494 = nil
			u499 = nil

			return
		end

		if not v336() then
			s5 = "you are dead"
			u499 = nil

			return
		end

		local v534, v535, v536 = v466()

		if not v534 then
			s5 = "no target in FOV"
			u494 = nil
			u499 = nil

			return
		end

		u320 = v535
		u321 = v536
		u499 = nil
		s5 = "locked on " .. v327(v535)

		local v537 = v334(v335())
		local Magnitude = v537 and (v536.Position - v537.Position).Magnitude or math.huge

		if t9.MiraSkill and Magnitude <= t9.MiraSkillAlcance then
			v531(v534, v536)
		else
			v484(false)

			if t9.MiraSkillAlcance < Magnitude then
				s5 ..= string.format(" (skill aim off: %d studs away)", math.floor(Magnitude))
			end
		end

		local v539 = v462()

		if not v539 then
			s5 ..= " (no weapon in hand)"

			return
		end

		local v540 = v501(v539)

		if v540 and v540.WeaponType == "Gun" then
			local v541 = v507(v539)
			local Magnitude2 = v541 and (v536.Position - v541).Magnitude or math.huge

			if v540.Range and v540.Range < Magnitude2 then
				u499 = nil
				s5 ..= string.format(" (gun reaches %d studs, he is at %d)", v540.Range, math.floor(Magnitude2))
			elseif v540.ShootType == "Projectile" and v540.Speed and v540.Speed > 0 then
				local AssemblyLinearVelocity = v536.AssemblyLinearVelocity or Vector3.zero
				local v544 = math.clamp(Magnitude2 / v540.Speed, 0, 3)

				if v541 then
					v544 = math.clamp((v536.Position + AssemblyLinearVelocity * v544 - v541).Magnitude / v540.Speed, 0, 3)
				end

				u499 = v536.Position + AssemblyLinearVelocity * v544
			else
				local v545 = v514(v330(v535), v541)

				u499 = v545 or v536.Position

				if not v545 then
					s5 ..= " (no clear line -- something is in the way)"
				end
			end
		end

		local MousePos = v539:FindFirstChild("MousePos")

		if not MousePos then
			s5 ..= " (weapon has no MousePos)"

			return
		end

		u494 = v534

		if u495 ~= v539 then
			u495 = v539
			v496(v539)
		end

		pcall(function()
			MousePos.Value = v534
		end)
	end)
end

local n7 = 0

virarParaAlvo = function()
	if not t9.AimVirar then
		return
	end

	if not u320 or not u321 then
		return
	end

	local v548 = v334(v335())

	if not v548 then
		return
	end

	local Position = u321.Position
	local Position2 = v548.Position
	local vector3 = Vector3.new(Position.X, Position2.Y, Position.Z)

	if (vector3 - Position2).Magnitude < 0.5 then
		return
	end

	local now2 = os.clock()

	if now2 - n7 < 0.2 then
		return
	end

	if v548.CFrame.LookVector:Dot((vector3 - Position2).Unit) > 0.978 then
		return
	end

	n7 = now2
	pcall(function()
		v548.CFrame = CFrame.lookAt(Position2, vector3)
	end)
end

do
	local t17 = {
		[Enum.KeyCode.Z] = true,
		[Enum.KeyCode.X] = true,
		[Enum.KeyCode.C] = true,
		[Enum.KeyCode.V] = true,
		[Enum.KeyCode.F] = true
	}
	local n8 = 0

	v120(UserInputService.InputBegan, function(p121, p122)
		if p122 then
			return
		end

		if not t9.Master or not t9.Aim or not t9.AimVirar then
			return
		end

		local UserInputType = p121.UserInputType

		if not (UserInputType == Enum.UserInputType.MouseButton1 or UserInputType == Enum.UserInputType.Keyboard and t17[p121.KeyCode]) then
			return
		end

		n8 = os.clock() + 0.25
		virarParaAlvo()
	end)
	v120(RunService.RenderStepped, function()
		if os.clock() < n8 then
			virarParaAlvo()
		end
	end)
end

local TsuoPvpDraw = v105("CoreGui"):FindFirstChild("TsuoPvpDraw")

if TsuoPvpDraw then
	TsuoPvpDraw:Destroy()
end

local ScreenGui = Instance.new("ScreenGui")

ScreenGui.Name = "TsuoPvpDraw"
ScreenGui.ResetOnSpawn = false
ScreenGui.IgnoreGuiInset = true
ScreenGui.DisplayOrder = 999998

local v558 = false

if type(gethui) == "function" then
	v558 = pcall(function()
		ScreenGui.Parent = gethui()
	end)
end

if not v558 and type(protectgui) == "function" then
	pcall(protectgui, ScreenGui)
end

if not v558 then
	pcall(function()
		ScreenGui.Parent = v105("CoreGui")
	end)
end

v118(ScreenGui)

local t18 = {}

local function createTextLabel()
	local TextLabel = Instance.new("TextLabel")

	TextLabel.BackgroundTransparency = 1
	TextLabel.Font = Enum.Font.GothamBold
	TextLabel.TextSize = 12
	TextLabel.TextStrokeTransparency = 0.4
	TextLabel.Visible = false
	TextLabel.Parent = ScreenGui

	return TextLabel
end
local function v562()
	local t19 = {}
	local ok, result = pcall(function()
		return _G.__TSUO_FrutasNoMapa and _G.__TSUO_FrutasNoMapa() or nil
	end)

	if ok then
		if type(result) == "table" and #result > 0 then
			for _, v in ipairs(result) do
				local tool = typeof(v) == "Instance" and v or v.tool or v.obj

				if tool then
					t19[#t19 + 1] = {
						tool,
						tool.Name
					}
				end
			end

			return t19
		end
	end

	for _, child in ipairs(Workspace:GetChildren()) do
		if child:IsA("Tool") then
			local v571 = tostring(child.ToolTip or "")

			if v571 ~= "Blox Fruit" and v571 ~= "Demon Fruit" then
				if not child.Name:find("%-") then
					continue
				end
			end

			t19[#t19 + 1] = {
				child,
				child.Name
			}
		end
	end

	return t19
end
local function v572()
	local t20 = {}

	for _, child in ipairs(Workspace:GetChildren()) do
		if child.Name:find("Chest") then
			t20[#t20 + 1] = {
				child,
				child.Name
			}
		end
	end

	return t20
end
local function v576()
	local t21 = {}
	local _WorldOrigin = Workspace:FindFirstChild("_WorldOrigin")
	local Locations = _WorldOrigin and _WorldOrigin:FindFirstChild("Locations")

	if not Locations then
		return t21
	end

	local t22 = {}

	for _, child in ipairs(Locations:GetChildren()) do
		if not t22[child.Name] then
			t22[child.Name] = true
			t21[#t21 + 1] = {
				child,
				child.Name
			}
		end
	end

	return t21
end
local function v583(p123)
	if typeof(p123) ~= "Instance" then
		return nil
	end

	if p123:IsA("BasePart") then
		return p123.Position
	end

	if p123:IsA("Model") then
		local ok, result = pcall(function()
			return p123:GetPivot()
		end)

		if ok then
			return result.Position
		end
	end

	local BasePart = p123:FindFirstChildWhichIsA("BasePart", true)

	return BasePart and BasePart.Position or nil
end

local t23 = {
	passo = function(p124, p125)
		local t24 = {}

		if t9.EspFruta then
			for _, v in ipairs(v562()) do
				t24[#t24 + 1] = {
					v[1],
					v[2],
					Color3.fromRGB(255, 210, 80)
				}
			end
		end

		if t9.EspIlha then
			for _, v in ipairs(v576()) do
				t24[#t24 + 1] = {
					v[1],
					v[2],
					Color3.fromRGB(120, 220, 255)
				}
			end
		end

		if t9.EspBau then
			for _, v in ipairs(v572()) do
				t24[#t24 + 1] = {
					v[1],
					v[2],
					Color3.fromRGB(180, 255, 140)
				}
			end
		end

		local t25 = {}

		for _, v in ipairs(t24) do
			local v598 = v[1]
			local v599 = v[2]
			local v600 = v[3]
			local v601 = v583(v598)

			if v601 and v598.Parent then
				local Magnitude = (v601 - p125).Magnitude

				if Magnitude <= t9.EspMundoDist then
					local v603 = p124:WorldToViewportPoint(v601)

					if v603.Z > 0 then
						local v604 = t18[v598]

						if not v604 then
							v604 = createTextLabel()
							t18[v598] = v604
						end

						t25[v598] = true
						v604.Text = v599 .. "  " .. math.floor(Magnitude)
						v604.TextColor3 = v600
						v604.Position = UDim2.fromOffset(v603.X - 70, v603.Y - 8)
						v604.Size = UDim2.fromOffset(140, 16)
						v604.Visible = true
					end
				end
			end
		end

		for k, v in pairs(t18) do
			if not t25[k] then
				if k.Parent then
					v.Visible = false
				else
					pcall(function()
						v:Destroy()
					end)
					t18[k] = nil
				end
			end
		end
	end,
	limpar = function()
		for k, v in pairs(t18) do
			pcall(function()
				v:Destroy()
			end)
			t18[k] = nil
		end
	end
}

v118({
	Destroy = t23.limpar
})

local function createFrame()
	local Frame = Instance.new("Frame")

	Frame.BorderSizePixel = 0
	Frame.BackgroundColor3 = t9.EspCor
	Frame.Visible = false
	Frame.Parent = ScreenGui

	return Frame
end
local function createTextLabel2()
	local TextLabel = Instance.new("TextLabel")

	TextLabel.BackgroundTransparency = 1
	TextLabel.Font = Enum.Font.GothamBold
	TextLabel.TextSize = 12
	TextLabel.TextColor3 = Color3.new(1, 1, 1)
	TextLabel.TextStrokeTransparency = 0.35
	TextLabel.Visible = false
	TextLabel.Parent = ScreenGui

	return TextLabel
end

local Frame = Instance.new("Frame")

Frame.Name = "FovRing"
Frame.BackgroundTransparency = 1
Frame.BorderSizePixel = 0
Frame.AnchorPoint = Vector2.new(0.5, 0.5)
Frame.Visible = false
Frame.ZIndex = 3
Frame.Parent = ScreenGui

local UICorner = Instance.new("UICorner")

UICorner.CornerRadius = UDim.new(1, 0)
UICorner.Parent = Frame

local UIStroke = Instance.new("UIStroke")

UIStroke.Thickness = 1.5
UIStroke.Parent = Frame
v120(RunService.RenderStepped, function()
	if not v119() then
		return
	end

	if not t9.Master or not t9.MostrarFov then
		Frame.Visible = false

		return
	end

	local CurrentCamera = Workspace.CurrentCamera
	local ViewportSize = CurrentCamera and CurrentCamera.ViewportSize or Vector2.new(1920, 1080)
	local v618 = math.clamp(t9.AimFovGraus or 120, 1, 360)
	local v619 = math.min(ViewportSize.X, ViewportSize.Y) / 2 - 4
	local v620, v621

	if v618 >= 160 then
		v621 = v619
		v620 = true
	else
		local v622 = math.rad((CurrentCamera and CurrentCamera.FieldOfView or 70) / 2)
		local v623 = math.tan(math.rad(v618 / 2)) / math.max(math.tan(v622), 0.001) * (ViewportSize.Y / 2)

		v620 = v623 > v619
		v621 = math.clamp(v623, 12, v619)
	end

	Frame.Size = UDim2.fromOffset(v621 * 2, v621 * 2)

	if t9.FovModo == "Mouse" then
		local v624 = v387()

		Frame.Position = UDim2.fromOffset(math.clamp(v624.X, v621, ViewportSize.X - v621), math.clamp(v624.Y, v621, ViewportSize.Y - v621))
	else
		Frame.Position = UDim2.fromOffset(ViewportSize.X / 2, ViewportSize.Y / 2)
	end

	UIStroke.Color = u320 and t9.EspCor or Color3.fromRGB(150, 150, 160)
	UIStroke.Thickness = v620 and 3 or 1.5
	UIStroke.Transparency = u320 and (v620 and 0.35 or 0.1) or v620 and 0.7 or 0.55
	Frame.Visible = true
end)

local t26 = {}
local t27 = {
	"b1",
	"b2",
	"b3",
	"b4",
	"vidaFundo",
	"vidaBarra",
	"tracer",
	"nome",
	"dist",
	"seta",
	"ficha",
	"icone"
}

local function v627()
	local function createImageLabel()
		local ImageLabel = Instance.new("ImageLabel")

		ImageLabel.BackgroundTransparency = 1
		ImageLabel.Visible = false
		ImageLabel.Parent = ScreenGui

		return ImageLabel
	end

	local t28 = {
		b1 = createFrame(),
		b2 = createFrame(),
		b3 = createFrame(),
		b4 = createFrame(),
		vidaFundo = createFrame(),
		vidaBarra = createFrame(),
		tracer = createFrame(),
		nome = createTextLabel2(),
		dist = createTextLabel2(),
		seta = createTextLabel2(),
		ficha = createTextLabel2(),
		chams = nil,
		icone = createImageLabel()
	}

	t28.vidaFundo.BackgroundColor3 = Color3.fromRGB(0, 0, 0)
	t28.vidaFundo.BackgroundTransparency = 0.35
	t28.seta.Font = Enum.Font.GothamBlack
	t28.seta.TextSize = 18

	return t28
end
local function v631(p126)
	if not p126 then
		return
	end

	for _, v in ipairs(t27) do
		if p126[v] then
			p126[v].Visible = false
		end
	end

	if p126.chams then
		p126.chams.Enabled = false
	end
end
local function v634(p127)
	local v635 = t26[p127]

	if not v635 then
		return
	end

	for _, v in ipairs(t27) do
		if v635[v] then
			pcall(function()
				v635[v]:Destroy()
			end)
		end
	end

	if v635.chams then
		pcall(function()
			v635.chams:Destroy()
		end)
	end

	t26[p127] = nil
end

local color3 = Color3.fromRGB(130, 130, 140)
local t29 = {}

local function v640()
	local SpriteMap = ReplicatedStorage:FindFirstChild("SpriteMap")

	if not SpriteMap then
		return nil
	end

	local ok, result = pcall(require, SpriteMap)

	if ok and type(result) == "table" and type(result.All) == "table" then
		return result.All
	end

	return nil
end

local v644 = v640()

local function v645(p128)
	if not v644 or not p128 then
		return nil
	end

	local v646 = t29[p128]

	if v646 ~= nil then
		return v646 or nil
	end

	local v647

	for _, v in ipairs({
		"1",
		"",
		"2",
		"3"
	}) do
		local ok, result = pcall(function()
			return v644[p128 .. v]
		end)

		if ok and type(result) == "table" and result.Image and result.ImageRectSize then
			local ImageRectOffset = result.ImageRectOffset

			if not ImageRectOffset or ImageRectOffset.X ~= 768 or ImageRectOffset.Y ~= 864 then
				v647 = result

				break
			end
		end
	end

	t29[p128] = v647 or false

	return v647
end

local color32 = Color3.fromRGB(255, 64, 64)

local function v654(p129)
	if p129 then
		return color3
	end

	local EspCor = t9.EspCor

	if typeof(EspCor) ~= "Color3" then
		return color32
	end

	if EspCor.R * 0.299 + EspCor.G * 0.587 + EspCor.B * 0.114 < 0.12 then
		return color32
	end

	return EspCor
end
local function v656(p130, p131, p132, p133, p134, p135)
	p130.b1.Position = UDim2.fromOffset(p131, p132)
	p130.b1.Size = UDim2.fromOffset(p133, 1)
	p130.b2.Position = UDim2.fromOffset(p131, p132 + p134 - 1)
	p130.b2.Size = UDim2.fromOffset(p133, 1)
	p130.b3.Position = UDim2.fromOffset(p131, p132)
	p130.b3.Size = UDim2.fromOffset(1, p134)
	p130.b4.Position = UDim2.fromOffset(p131 + p133 - 1, p132)
	p130.b4.Size = UDim2.fromOffset(1, p134)

	for _, v in ipairs({
		p130.b1,
		p130.b2,
		p130.b3,
		p130.b4
	}) do
		v.BackgroundColor3 = p135 or t9.EspCor
		v.Visible = true
	end
end

v120(Players.PlayerRemoving, function(p136)
	if t26[p136] then
		v634(p136)
	end
end)

local n9 = 0

v120(RunService.RenderStepped, function(p137)
	if not v119() then
		return
	end

	n9 += p137

	if n9 < 0.016666666666666666 then
		return
	end

	n9 = 0

	if t9.Master then
		pcall(t23.passo, Workspace.CurrentCamera, v334(v335()) and v334(v335()).Position or Workspace.CurrentCamera.CFrame.Position)
	else
		pcall(t23.limpar)
	end

	if not t9.Master or not t9.Esp then
		for k in pairs(t26) do
			v631(t26[k])
		end

		return
	end

	local CurrentCamera = Workspace.CurrentCamera

	if not CurrentCamera then
		return
	end

	local v662 = v334(v335())
	local Position = v662

	Position = Position and v662.Position or CurrentCamera.CFrame.Position

	local ViewportSize = CurrentCamera.ViewportSize
	local v665 = ViewportSize.X / 2
	local v666 = ViewportSize.Y / 2
	local t30 = {}

	for _, player in ipairs(Players:GetPlayers()) do
		t30[player] = true
	end

	for k, v in pairs(t26) do
		if t30[k] and k.Parent then
			if v.corpo and v.corpo ~= v330(k) then
				v634(k)
			end
		else
			v634(k)
		end
	end

	for _, player in ipairs(Players:GetPlayers()) do
		if player ~= LocalPlayer then
			local v674 = v330(player)
			local v675 = v674 and v334(v674)
			local v676 = v674 and v331(v674)
			local v677 = t26[player]
			local v678 = v365(player)

			if v678 == "same crew" then
				if t9.Esp and t9.EspAliado and v674 and v675 and v676 and v676.Health > 0 then
					if not v677 then
						v677 = v627()
						t26[player] = v677
					end

					v677.corpo = v674
				end

				if v677 and t9.Esp and t9.EspAliado then
					v631(v677)

					local Head = v674:FindFirstChild("Head")
					local v680 = CurrentCamera:WorldToViewportPoint((Head and Head.Position or v675.Position) + Vector3.new(0, 2, 0))

					if v680.Z > 0 and (v675.Position - Position).Magnitude <= t9.EspDist then
						v677.nome.Text = (player.DisplayName or player.Name) .. "  [team]"
						v677.nome.TextColor3 = Color3.fromRGB(90, 170, 255)
						v677.nome.TextSize = 12
						v677.nome.Position = UDim2.fromOffset(v680.X - 70, v680.Y - 16)
						v677.nome.Size = UDim2.fromOffset(140, 14)
						v677.nome.Visible = true
					end
				elseif v677 then
					v631(v677)
				end
			elseif v678 and not t9.EspMostrarPulados then
				if v677 then
					v631(v677)
				end
			elseif v674 and v675 and v676 and v676.Health > 0 then
				local Magnitude = (v675.Position - Position).Magnitude

				if not t9.EspZonaSegura and v344(v674) then
					if v677 then
						v631(v677)
					end
				elseif t9.EspDist < Magnitude then
					if v677 then
						v631(v677)
					end
				else
					if not v677 then
						v677 = v627()
						t26[player] = v677
					end

					v677.corpo = v674
					v631(v677)

					if not t9.EspSoVisivel or v384(v675.Position, v674, CurrentCamera) then
						local Head = v674:FindFirstChild("Head")
						local v683 = CurrentCamera:WorldToViewportPoint((Head and Head.Position or v675.Position) + Vector3.new(0, 1.6, 0))
						local v684 = CurrentCamera:WorldToViewportPoint(v675.Position - Vector3.new(0, 3.2, 0))

						if v683.Z > 0 and v684.Z > 0 then
							local v685 = math.abs(v684.Y - v683.Y)
							local v686 = v685 * 0.62
							local v687 = v683.X - v686 / 2
							local Y = v683.Y
							local v689 = v654(v678)

							math.clamp(v685 / 120, 0.55, 1.35)

							local textSize = math.floor(math.clamp(v685 * 0.13, 10, 18))
							local v691 = math.floor(math.clamp(v685 * 0.34, 18, 44))

							if t9.EspCaixa then
								v656(v677, v687, Y, v686, v685, v689)
							end

							if t9.EspVida then
								local v692 = math.clamp(v676.Health / math.max(v676.MaxHealth, 1), 0, 1)

								v677.vidaFundo.Position = UDim2.fromOffset(v687 - 6, Y)
								v677.vidaFundo.Size = UDim2.fromOffset(3, v685)
								v677.vidaFundo.Visible = true
								v677.vidaBarra.Position = UDim2.fromOffset(v687 - 6, Y + v685 * (1 - v692))
								v677.vidaBarra.Size = UDim2.fromOffset(3, v685 * v692)
								v677.vidaBarra.BackgroundColor3 = Color3.fromRGB(255 * (1 - v692), 255 * v692, 60)
								v677.vidaBarra.Visible = true
							end

							if t9.EspNome then
								v677.nome.Text = (player.DisplayName or player.Name) .. (v678 and "  [" .. v678 .. "]" or "")
								v677.nome.TextColor3 = v689
								v677.nome.TextSize = textSize + 1
								v677.nome.Position = UDim2.fromOffset(v687 + v686 / 2 - 70, Y - (textSize + 6))
								v677.nome.Size = UDim2.fromOffset(140, textSize + 4)
								v677.nome.Visible = true
							end

							if t9.EspFicha then
								local t31 = {}

								if t9.EspVidaTexto then
									t31[#t31 + 1] = string.format("%d hp", v676.Health)
								end

								if t9.EspArma then
									local v694

									for _, child in ipairs(v674:GetChildren()) do
										if child:IsA("Tool") then
											v694 = child

											break
										end
									end

									t31[#t31 + 1] = v694 and v694.Name or "maos vazias"

									local v697 = v694 and v645(v694.Name)

									if v697 then
										v677.icone.Image = v697.Image
										v677.icone.ImageRectOffset = v697.ImageRectOffset
										v677.icone.ImageRectSize = v697.ImageRectSize
										v677.icone.Size = UDim2.fromOffset(v691, v691)
										v677.icone.Position = UDim2.fromOffset(v687 + v686 / 2 - v691 / 2, Y - (textSize + 8) - v691)
										v677.icone.Visible = true
									end
								end

								if t9.EspNivel then
									local ok, result = pcall(function()
										return player.Data.Level.Value
									end)

									if ok and result then
										t31[#t31 + 1] = "lv " .. tostring(result)
									end
								end

								if t9.EspHaki then
									local attribute = player:GetAttribute("KenActive")

									if attribute == nil then
										attribute = v674:GetAttribute("KenActive")
									end

									if attribute == true then
										t31[#t31 + 1] = "OBS"
									end
								end

								v677.ficha.Text = table.concat(t31, "  |  ")
								v677.ficha.TextColor3 = v678 and color3 or Color3.fromRGB(225, 225, 235)
								v677.ficha.TextSize = textSize
								v677.ficha.Position = UDim2.fromOffset(v687 + v686 / 2 - 100, Y + v685 + textSize + 4)
								v677.ficha.Size = UDim2.fromOffset(200, textSize + 2)
								v677.ficha.Visible = true
							end

							if t9.EspDistancia then
								v677.dist.Text = string.format("%d studs", Magnitude)
								v677.dist.TextColor3 = v678 and color3 or Color3.fromRGB(200, 200, 210)
								v677.dist.TextSize = textSize
								v677.dist.Position = UDim2.fromOffset(v687 + v686 / 2 - 60, Y + v685 + 2)
								v677.dist.Size = UDim2.fromOffset(120, 13)
								v677.dist.Visible = true
							end

							if t9.EspTracer then
								local Y2 = ViewportSize.Y
								local X = v683.X
								local Y3 = v684.Y
								local v704 = X - v665
								local v705 = Y3 - Y2

								v677.tracer.AnchorPoint = Vector2.new(0.5, 0.5)
								v677.tracer.Position = UDim2.fromOffset((v665 + X) / 2, (Y2 + Y3) / 2)
								v677.tracer.Size = UDim2.fromOffset(math.sqrt(v704 * v704 + v705 * v705), 1)
								v677.tracer.Rotation = math.deg(math.atan2(v705, v704))
								v677.tracer.BackgroundColor3 = v689
								v677.tracer.Visible = true
							end
						elseif t9.EspSeta then
							local v706 = CurrentCamera.CFrame:PointToObjectSpace(v675.Position)
							local v707 = math.atan2(v706.X, -v706.Z)
							local v708 = math.min(ViewportSize.X, ViewportSize.Y) * 0.32

							v677.seta.Text = "^"
							v677.seta.Rotation = math.deg(v707)
							v677.seta.TextColor3 = v654(v678)
							v677.seta.Position = UDim2.fromOffset(v665 + math.sin(v707) * v708 - 10, v666 - math.cos(v707) * v708 * 0.55 - 10)
							v677.seta.Size = UDim2.fromOffset(20, 20)
							v677.seta.Visible = true
						end

						if t9.EspChams then
							if not v677.chams then
								local ok, chams = pcall(Instance.new, "Highlight")

								if ok and chams then
									chams.Name = "TsuoPvpChams"
									chams.FillTransparency = 0.6
									chams.DepthMode = Enum.HighlightDepthMode.AlwaysOnTop
									chams.Parent = v674
									v677.chams = chams
								end
							end

							if v677.chams then
								local v711 = v654(v678)

								v677.chams.Adornee = v674
								v677.chams.FillColor = v711
								v677.chams.OutlineColor = v711
								v677.chams.Enabled = true
							end
						elseif v677.chams then
							v677.chams.Enabled = false
						end
					end
				end
			elseif v677 then
				v631(v677)
			end
		end
	end
end)

do
	local Net = ReplicatedStorage:FindFirstChild("Modules") and ReplicatedStorage.Modules:FindFirstChild("Net")
	local RERegisterAttack = Net and Net:FindFirstChild("RE/RegisterAttack")
	local RERegisterHit = Net and Net:FindFirstChild("RE/RegisterHit")
	local n10 = 0
	local n11 = 0

	local function v717()
		if tick() - n11 > 0.15 then
			n10 = 0
		end

		n10 += 1

		if n10 > 4 then
			n10 = 1
		end

		n11 = tick()

		return n10
	end
	local function v718(p138, p139)
		local Stun = p138:FindFirstChild("Stun")
		local Busy = p138:FindFirstChild("Busy")

		if p139.Sit then
			return true
		end

		if Stun and Stun.Value > 0 then
			return true
		end

		if Busy and Busy.Value then
			return true
		end

		return false
	end
	local function v721(p140, p141)
		local t32 = {}
		local v723 = v334(p140)

		if not v723 then
			return t32
		end

		for _, player in ipairs(Players:GetPlayers()) do
			if v374(player) then
				local v726 = v330(player)
				local v727 = v331(v726)
				local v728 = v334(v726)

				if v728 and v727 and (v728.Position - v723.Position).Magnitude <= p141 then
					t32[#t32 + 1] = {
						v727,
						v728
					}
				end
			end
		end

		return t32
	end

	task.spawn(function()
		_G.__TSUO_Escalona()

		while true do
			task.wait(t9.FastAttackRitmo)

			if not v119() then
				break
			end

			if t9.Master and t9.FastAttack and v336() and RERegisterAttack and RERegisterHit then
				local v729 = v335()
				local v730 = v331(v729)
				local v731

				if v729 then
					for _, child in ipairs(v729:GetChildren()) do
						if child:IsA("Tool") then
							v731 = child

							break
						end
					end
				end

				if v729 and v730 and v731 and not v718(v729, v730) then
					local v734 = v721(v729, t9.FastAttackAlcance)

					if v734[1] then
						_G.__TSUO_PVP_COMBO = v717()

						local v735 = tostring(LocalPlayer.UserId):sub(2, 4) .. tostring(coroutine.running()):sub(11, 15)

						pcall(function()
							RERegisterAttack:FireServer(0)
						end)
						pcall(function()
							RERegisterHit:FireServer(v734[1][2], v734, nil, v735)
						end)
						_G.__TSUO_PVP_HIT_DIZ = string.format("4 args, %d target(s), token %q", #v734, v735)
						_G.__TSUO_PVP_FA_GOLPES = (_G.__TSUO_PVP_FA_GOLPES or 0) + 1
					end
				end
			end
		end
	end)
end

v105("VirtualUser")

do
	local t33 = {}

	local function v737(p142)
		if t33.tool == p142 and t33.cds then
			return t33.cds
		end

		local Data = p142 and p142:FindFirstChild("Data")
		local ok, result = pcall(function()
			return Data and require(Data)
		end)

		t33.cds = ok and type(result) == "table" and type(result.Cooldown) == "table" and result.Cooldown or {}

		if next(t33.cds) == nil then
			t33.cds = {
				Z = 0,
				X = 0,
				C = 0,
				V = 0,
				F = 0
			}
		end

		t33.tool = p142

		return t33.cds
	end
end

local function v741(p143, p144)
	local ok, result = pcall(function()
		local Skills = LocalPlayer.PlayerGui.Main:FindFirstChild("Skills")

		if not Skills then
			return true
		end

		local v745 = Skills:FindFirstChild(p143.Name)

		if not v745 then
			return true
		end

		local v746 = v745:FindFirstChild(p144)

		if not v746 then
			return true
		end

		local Cooldown = v746:FindFirstChild("Cooldown")

		return not Cooldown or Cooldown.AbsoluteSize.X <= 0
	end)

	return ok and result ~= false
end
local function v748(p145, p146)
	pcall(function()
		local v749 = v334(v335())

		if not v749 then
			return
		end

		local v750 = (p146 or 0.1) + math.random(-20, 20) / 1000

		if v750 < 0.03 then
			v750 = 0.03
		end

		VirtualInputManager:SendKeyEvent(true, p145, false, v749)
		task.wait(v750)
		VirtualInputManager:SendKeyEvent(false, p145, false, v749)
	end)
end
local function v751(p147)
	local v752 = v335()
	local v753 = v331(v752)

	if not v752 or not v753 then
		return false
	end

	for _, child in ipairs(LocalPlayer.Backpack:GetChildren()) do
		if child:IsA("Tool") and (child.ToolTip == p147 or child.Name == p147) then
			pcall(function()
				v753:EquipTool(child)
			end)

			return true
		end
	end

	return false
end
local function v756()
	local v757 = v335()

	if v757 then
		for _, child in ipairs(v757:GetChildren()) do
			if child:IsA("Tool") then
				return child
			end
		end

		return nil
	end

	return nil
end

local n12 = 0

v120(RunService.RenderStepped, function()
	if not v119() then
		return
	end

	if not t9.Master or not t9.AntiStun then
		return
	end

	n12 += 1

	local v761 = v335()

	if not v761 then
		return
	end

	pcall(function()
		local Stun = v761:FindFirstChild("Stun")

		if Stun and n12 % 20 == 0 then
			Stun.Value = 0
		end

		local Busy = v761:FindFirstChild("Busy")

		if Busy and n12 % 15 == 0 then
			Busy.Value = false
		end
	end)
end)

do
	local n13 = 0
	local n14 = 0
	local n15 = 0

	task.spawn(function()
		_G.__TSUO_Escalona()

		while true do
			task.wait(0.5)

			if not v119() then
				break
			end

			if t9.Master and v336() then
				local v767 = v335()
				local CommE = ReplicatedStorage:FindFirstChild("Remotes") and ReplicatedStorage.Remotes:FindFirstChild("CommE")

				if t9.AutoBuso and not v767:FindFirstChild("HasBuso") and not v767:FindFirstChild("Buso") then
					pcall(function()
						v147("Buso")
					end)
				end

				if t9.AutoObs then
					local v769 = v767:FindFirstChild("KenDisabled") ~= nil
					local attribute = LocalPlayer:GetAttribute("KenActive")

					if attribute == nil then
						attribute = v767:GetAttribute("KenActive")
					end

					if not v769 and attribute ~= true and tick() - n13 > 3 then
						n13 = tick()
						pcall(function()
							VirtualInputManager:SendKeyEvent(true, Enum.KeyCode.E, false, game)
							task.wait(0.08)
							VirtualInputManager:SendKeyEvent(false, Enum.KeyCode.E, false, game)
						end)
					end
				end

				if t9.AutoV3 then
					if CommE and tick() - n14 >= 30 then
						n14 = tick()
						pcall(function()
							CommE:FireServer("ActivateAbility")
						end)
					end
				end

				if t9.AutoV4 then
					local RaceEnergy = v767:FindFirstChild("RaceEnergy")

					if RaceEnergy and RaceEnergy.Value >= 1 and tick() - n15 >= 3 then
						n15 = tick()
						pcall(function()
							VirtualInputManager:SendKeyEvent(true, Enum.KeyCode.Y, false, game)
							task.wait(0.05)
							VirtualInputManager:SendKeyEvent(false, Enum.KeyCode.Y, false, game)
						end)
					end
				end
			end
		end
	end)
end

local function v772()
	local v773 = v335()

	if not v773 then
		return nil
	end

	for _, child in ipairs(v773:GetChildren()) do
		if not child:IsA("IntConstrainedValue") and not child:IsA("NumberValue") and not child:IsA("IntValue") then
			continue
		end

		local v776 = child.Name:lower()

		if v776:find("energy") or v776:find("stamina") then
			return child
		end
	end

	return nil
end
local function v777()
	if not v119() then
		return
	end

	if not t9.Master then
		return
	end

	local v778 = v331(v335())

	if not v778 or not (v778.Health > 0) then
		return
	end

	if t9.Velocidade and math.abs(v778.WalkSpeed - t9.VelocidadeVal) > 0.5 then
		pcall(function()
			v778.WalkSpeed = t9.VelocidadeVal
		end)
	end

	if t9.Pulo then
		pcall(function()
			v778.UseJumpPower = true

			if math.abs(v778.JumpPower - t9.PuloVal) > 0.5 then
				v778.JumpPower = t9.PuloVal
			end
		end)
	end

	if t9.StaminaInf then
		local v779 = v772()

		if v779 then
			pcall(function()
				local MaxValue = v779.MaxValue

				if type(MaxValue) ~= "number" or MaxValue <= 0 then
					MaxValue = 999999
				end

				if v779.Value < MaxValue then
					v779.Value = MaxValue
				end
			end)
		end
	end
end

v120(RunService.Stepped, v777)
v120(RunService.Heartbeat, v777)
v120(RunService.RenderStepped, v777)

do
	local n16 = 0
	local tween2

	v120(UserInputService.InputBegan, function(p148, p149)
		if not v119() then
			return
		end

		if p149 then
			return
		end

		if not t9.Master or not t9.Dash or not v336() then
			return
		end

		if p148.KeyCode ~= Enum.KeyCode.Q then
			return
		end

		local now2 = os.clock()

		if now2 - n16 < 0.5 then
			return
		end

		n16 = now2

		local CurrentCamera = Workspace.CurrentCamera
		local v785 = v334(v335())

		if not CurrentCamera or not v785 then
			return
		end

		local LookVector = CurrentCamera.CFrame.LookVector
		local vector3 = Vector3.new(LookVector.X, 0, LookVector.Z)

		if vector3.Magnitude < 0.01 then
			return
		end

		local Unit = vector3.Unit
		local raycastParams3 = RaycastParams.new()

		raycastParams3.FilterType = Enum.RaycastFilterType.Exclude
		raycastParams3.FilterDescendantsInstances = {
			v335(),
			CurrentCamera
		}

		local DashDistancia = t9.DashDistancia
		local hit = Workspace:Raycast(v785.Position, Unit * DashDistancia, raycastParams3)

		if hit then
			DashDistancia = math.max(0, (hit.Position - v785.Position).Magnitude - 4)
		end

		if not (DashDistancia < 5) then
			task.spawn(function()
				task.wait(0.35)

				if not v119() then
					return
				end

				local v792 = v334(v335())

				if not v792 or not v336() then
					return
				end

				local DashDistancia2 = t9.DashDistancia
				local hit2 = Workspace:Raycast(v792.Position, Unit * DashDistancia2, raycastParams3)

				if hit2 then
					DashDistancia2 = math.max(0, (hit2.Position - v792.Position).Magnitude - 4)
				end

				if DashDistancia2 < 5 then
					return
				end

				local v795 = v792.Position + Unit * DashDistancia2
				local v796 = DashDistancia2 / math.max(t9.DashVal, 20)

				pcall(function()
					if tween2 then
						tween2:Cancel()
					end

					tween2 = TweenService:Create(v792, TweenInfo.new(v796, Enum.EasingStyle.Linear), {
						CFrame = cFrameNew(v795, v795 + Unit)
					})
					tween2:Play()
				end)
			end)

			return
		end
	end)
	v118({
		Destroy = function()
			pcall(function()
				if tween2 then
					tween2:Cancel()
				end
			end)
		end
	})
end

do
	local connection

	local function v798()
		if connection then
			pcall(function()
				connection:Disconnect()
			end)
			connection = nil
		end

		local v799 = v331(v335())

		if v799 then
			pcall(function()
				v799.AutoRotate = true
			end)
		end
	end

	v118({
		Destroy = v798
	})

	local function v800()
		v798()

		local n17 = 0

		connection = RunService.Heartbeat:Connect(function(dt)
			if not v119() then
				return
			end

			if t9.Master then
				if t9.Spin then
					local v802 = v335()
					local v803 = v334(v802)

					if not v803 then
						return
					end

					local v804 = v331(v802)

					if v804 then
						pcall(function()
							v804.AutoRotate = false
						end)
					end

					n17 = (n17 + math.rad(t9.SpinVelocidade) * dt) % 6.2831853071795862
					pcall(function()
						v803.CFrame = cFrameNew(v803.Position) * CFrame.Angles(0, n17, 0)
					end)

					return
				end
			end
		end)
		v118(connection)
	end

	_G.__PVPKING_SPIN = function(p150)
		if p150 then
			v800()
		else
			v798()
		end
	end
	v120(LocalPlayer.CharacterAdded, function()
		if t9.Spin then
			task.wait(0.2)
			v800()
		end
	end)
end

do
	local Part

	local function v806()
		if Part then
			pcall(function()
				Part:Destroy()
			end)
			Part = nil
		end
	end

	v118({
		Destroy = v806
	})
	v120(RunService.Heartbeat, function()
		if not v119() then
			return
		end

		if not t9.Master or not t9.AndarNaAgua or not v336() then
			v806()

			return
		end

		local v807 = v334(v335())

		if not v807 then
			v806()

			return
		end

		local Position = v807.Position

		if Position.Y > 8 or Position.Y < -30 then
			v806()

			return
		end

		if not Part then
			Part = Instance.new("Part")
			Part.Name = "TsuoPvpPiso"
			Part.Anchored = true
			Part.CanCollide = true
			Part.Size = Vector3.new(24, 1, 24)
			Part.Transparency = 1
			Part.Parent = Workspace
		end

		Part.CFrame = cFrameNew(Position.X, -3.2, Position.Z)
	end)
end

do
	local t34 = {}
	local u810 = false

	local function v811()
		for k, v in pairs(t34) do
			if k.Parent then
				pcall(function()
					k.CanCollide = v
				end)
			end
		end

		t34 = {}
	end

	v118({
		Destroy = v811
	})
	v120(RunService.Stepped, function()
		if not v119() then
			return
		end

		if not (t9.Master and t9.SemColisao and v336()) then
			if u810 then
				v811()
				u810 = false
			end

			return
		end

		u810 = true

		local v814 = v335()

		if not v814 then
			return
		end

		for _, descendant in ipairs(v814:GetDescendants()) do
			if descendant:IsA("BasePart") and descendant.CanCollide then
				if t34[descendant] == nil then
					t34[descendant] = descendant.CanCollide
				end

				pcall(function()
					descendant.CanCollide = false
				end)
			end
		end
	end)
end

local t35 = {
	listar = function()
		local t36 = {}
		local t37 = {}
		local _WorldOrigin = Workspace:FindFirstChild("_WorldOrigin")
		local Locations = _WorldOrigin and _WorldOrigin:FindFirstChild("Locations")

		if not Locations then
			return t36
		end

		for _, child in ipairs(Locations:GetChildren()) do
			if not t37[child.Name] then
				t37[child.Name] = true
				t36[#t36 + 1] = child.Name
			end
		end

		table.sort(t36)

		return t36
	end,
	posicao = function(p151)
		local _WorldOrigin = Workspace:FindFirstChild("_WorldOrigin")
		local Locations = _WorldOrigin and _WorldOrigin:FindFirstChild("Locations")

		if not Locations then
			return nil
		end

		local v826 = Locations:FindFirstChild(p151)

		if not v826 then
			return nil
		end

		if v826:IsA("BasePart") then
			return v826.Position
		end

		local BasePart = v826:FindFirstChildWhichIsA("BasePart", true)

		return BasePart and BasePart.Position or nil
	end
}
local t38

t38 = {
	matar = function()
		local v829 = v335()
		local v830 = v331(v829)

		if not v830 then
			return false
		end

		pcall(function()
			v830.Health = 0
		end)
		pcall(function()
			v830:ChangeState(Enum.HumanoidStateType.Dead)
		end)
		task.delay(0.3, function()
			local v831 = v335()

			if v831 then
				if v332(v831) then
					pcall(function()
						v831:BreakJoints()
					end)
				end
			end
		end)

		return true
	end,
	esperarRenascer = function(p152)
		local v832 = tick() + (p152 or 25)

		while tick() < v832 do
			if not v119() then
				return false
			end

			local v833 = v335()

			if v833 and v332(v833) and v334(v833) then
				task.wait(0.8)

				return true
			end

			task.wait(0.25)
		end

		return false
	end,
	ir = function(p153, p154)
		local v834 = t35.posicao(p153)

		if not v834 then
			return false, "island not found"
		end

		if not v336() then
			return false, "you are dead"
		end

		task.spawn(function()
			local function v835(p155, p156)
				if p154 then
					p154(p155, p156)
				end
			end

			v835("Traveling to " .. p153 .. "...", "info")

			local v836 = _G.__TSUO_IrAte(cFrameNew(v834), function()
				return v119()
			end, 120, "ilha")

			if not v119() then
				return
			end

			local v837 = v334(v335())
			local Magnitude = v837 and (v837.Position - v834).Magnitude or 99999

			if not v836 and Magnitude > 400 then
				v835(string.format("Could not get close enough (%.0f studs away).", Magnitude), "warning")

				return
			end

			v835("Saving spawn point here...", "info")

			local ok = pcall(function()
				v147("SetSpawnPoint")
			end)

			task.wait(1.2)

			if not ok then
				v835("The game refused to save the spawn point.", "error")

				return
			end

			v835("Dying to respawn past the barrier...", "warning")
			t38.matar()

			if not t38.esperarRenascer(30) then
				v835("Respawn did not come back in time.", "error")

				return
			end

			local v840 = v334(v335())
			local Magnitude2 = v840 and (v840.Position - v834).Magnitude or -1

			if Magnitude2 >= 0 and Magnitude2 < 600 then
				v835(string.format("Respawned at %s (%.0f studs).", p153, Magnitude2), "success")
			else
				v835(string.format("Respawned %.0f studs from %s -- the spawn did not stick.", Magnitude2, p153), "warning")
			end
		end)

		return true, "started"
	end
}

local ok, result = pcall(function()
	return game:HttpGet("https://raw.githubusercontent.com/Tsuo7/TsuoHub/refs/heads/main/tsuoui")
end)

if not ok or type(result) ~= "string" or #result < 1000 then
	warn("[PvpKing] could not download TSUO UI")

	return
end

local chunk = loadstring(result)

if not chunk then
	warn("[PvpKing] TSUO UI did not compile")

	return
end

local ok2, result2 = pcall(chunk)

if not ok2 or type(result2) ~= "table" then
	warn("[PvpKing] TSUO UI did not load")

	return
end

local v847 = result2:CreateWindow({
	Title = "TSUO PVP KING",
	SubTitle = "blox fruits",
	ToggleKey = Enum.KeyCode.RightShift,
	Theme = "Dark",
	Accent = Color3.fromRGB(190, 70, 255),
	AutoSave = "tsuo_pvpking"
})

local function v848(p157, p158, p159, p160)
	pcall(function()
		v847:Notify({
			Title = p157,
			Content = p158,
			Duration = p159 or 5,
			Kind = p160 or "info"
		})
	end)
end

local v849 = v847:AddTab({
	Title = "Combat",
	Icon = "crosshair"
})
local v850 = v847:AddTab({
	Title = "Visuals",
	Icon = "eye"
})
local v851 = v847:AddTab({
	Title = "Movement",
	Icon = "bolt"
})
local v852 = v847:AddTab({
	Title = "Teleport",
	Icon = "globe"
})
local v853 = v847:AddTab({
	Title = "Misc",
	Icon = "settings"
})
local v854 = v847:AddTab({
	Title = "Settings",
	Icon = "settings"
})

v849:AddSection("pvp")
v849:AddParagraph({
	Title = "What the switch does",
	Content = "It locks the enemy closest to your aim on screen, and makes your skills and your gun shots leave in his direction -- through the game's own aim assist, so it lands where the lock is and not where your cursor is. It does NOT attack for you: you press what you want, when you want. Your camera is never moved. Your body turns toward the lock only on the frame you strike -- the game already turns it on every M1, toward your cursor; this only fixes the direction, and melee M1 needs it to land."
})
v849:AddToggle("pvpAim", {
	Title = "PVP AIM",
	Icon = "crosshair",
	Description = "Skills and gun shots follow the locked enemy",
	Default = t9.Aim,
	Callback = function(p161)
		t9.Aim = p161
		t9.MiraSkill = p161
		t9.AimVirar = p161
		t9.SkillAuto = false
		t9.Puxar = false

		if not p161 then
			local LocalPlayer2 = Players.LocalPlayer

			if LocalPlayer2 then
				pcall(function()
					LocalPlayer2:SetAttribute("AAIM", nil)
				end)
			end
		end
	end
})
v849:AddDropdown("fovModo", {
	Title = "FOV follows",
	Icon = "eye",
	Description = "Camera: the cone starts where you look. Mouse: the circle walks with your pointer.",
	Values = {
		"Camera",
		"Mouse"
	},
	Default = t9.FovModo,
	Callback = function(p162)
		t9.FovModo = p162
	end
})
v849:AddSlider("aimFov", {
	Title = "Lock FOV",
	Suffix = " deg",
	Icon = "eye",
	Description = "360 locks anyone around you, even behind your back",
	Min = 5,
	Max = 360,
	Default = t9.AimFovGraus,
	Rounding = 0,
	Callback = function(p163)
		t9.AimFovGraus = p163
	end
})
v849:AddSlider("aimRange", {
	Title = "Range -- ignores anyone past this",
	Suffix = " studs",
	Icon = "crosshair",
	Min = 50,
	Max = 1500,
	Default = t9.MiraSkillAlcance,
	Rounding = 0,
	Callback = function(p164)
		t9.MiraSkillAlcance = p164
	end
})
v849:AddToggle("aimHeight", {
	Title = "Aim at the body, not the feet",
	Icon = "crosshair",
	Description = "Uses the game's own height fix: a point resting on the floor is raised to chest level",
	Default = t9.AimAltura,
	Callback = function(p165)
		t9.AimAltura = p165
	end
})
v849:AddToggle("aimSafe", {
	Title = "Aim while your PvP is off",
	Icon = "shield",
	Description = "The game itself says when it is off -- safe zone, or you died recently. Off: nobody is a target until PvP is back.",
	Default = t9.AimNaZonaSegura,
	Callback = function(p166)
		t9.AimNaZonaSegura = p166
	end
})
v849:AddToggle("fast", {
	Title = "Fast attack",
	Icon = "bolt",
	Description = "Hits without waiting for the animation, on enemies in range. Off by default.",
	Default = t9.FastAttack,
	Callback = function(p167)
		t9.FastAttack = p167
	end
})
v849:AddSlider("fastRange", {
	Title = "Fast attack range",
	Suffix = " studs",
	Icon = "bolt",
	Min = 20,
	Max = 250,
	Default = t9.FastAttackAlcance,
	Rounding = 0,
	Callback = function(p168)
		t9.FastAttackAlcance = p168
	end
})
v849:AddToggle("fovRing", {
	Title = "Show the lock circle",
	Icon = "eye",
	Description = "White = nothing locked. Purple = locked on someone.",
	Default = t9.MostrarFov,
	Callback = function(p169)
		t9.MostrarFov = p169
	end
})
v849:AddSection("haki and race")
v849:AddToggle("buso", {
	Title = "Keep Buso haki on",
	Icon = "shield",
	Default = t9.AutoBuso,
	Callback = function(p170)
		t9.AutoBuso = p170
	end
})
v849:AddToggle("obs", {
	Title = "Keep Observation on",
	Icon = "eye",
	Default = t9.AutoObs,
	Callback = function(p171)
		t9.AutoObs = p171
	end
})
v849:AddToggle("v3", {
	Title = "Auto race V3",
	Icon = "bolt",
	Default = t9.AutoV3,
	Callback = function(p172)
		t9.AutoV3 = p172
	end
})
v849:AddToggle("v4", {
	Title = "Auto race V4",
	Icon = "bolt",
	Default = t9.AutoV4,
	Callback = function(p173)
		t9.AutoV4 = p173
	end
})
v850:AddSection("enemies")
v850:AddToggle("esp", {
	Title = "Enemy ESP",
	Icon = "eye",
	Default = t9.Esp,
	Description = "Box, name, health, distance and what they are holding -- with the item icon from the game",
	Callback = function(p174)
		t9.Esp = p174
		t9.EspCaixa = p174
		t9.EspNome = p174
		t9.EspVida = p174
		t9.EspDistancia = p174
		t9.EspFicha = p174
		t9.EspArma = p174
		t9.EspNivel = p174
		t9.EspHaki = p174
		t9.EspVidaTexto = p174
	end
})
v850:AddSlider("espDist", {
	Title = "Draw distance",
	Suffix = " studs",
	Icon = "eye",
	Description = "Measured on a live server: enemies at 11.700 and 19.200 studs, so this goes high",
	Min = 500,
	Max = 50000,
	Default = t9.EspDist,
	Rounding = 0,
	Callback = function(p175)
		t9.EspDist = p175
	end
})
v850:AddToggle("espArrow", {
	Title = "Arrow for who is off screen",
	Icon = "eye",
	Default = t9.EspSeta,
	Callback = function(p176)
		t9.EspSeta = p176
	end
})
v850:AddToggle("espChams", {
	Title = "Paint their whole body",
	Icon = "eye",
	Default = t9.EspChams,
	Callback = function(p177)
		t9.EspChams = p177
	end
})
v850:AddColorPicker("espColor", {
	Title = "Enemy colour",
	Default = t9.EspCor,
	Callback = function(p178)
		t9.EspCor = p178
	end
})
v850:AddSection("who shows up")
v850:AddToggle("espSafe", {
	Title = "Players inside a safe zone",
	Icon = "shield",
	Description = "Turn off and the bubble crowd disappears -- you cannot hit them anyway",
	Default = t9.EspZonaSegura,
	Callback = function(p179)
		t9.EspZonaSegura = p179
	end
})
v850:AddToggle("espAliado", {
	Title = "Your crew (name only, blue)",
	Icon = "shield",
	Description = "So you can tell an ally apart from a bug: they never become a target",
	Default = t9.EspAliado,
	Callback = function(p180)
		t9.EspAliado = p180
	end
})
v850:AddSection("world")
v850:AddParagraph({
	Title = "Same marks the farm hub uses",
	Content = "Fruit on the ground, islands and chests, each with its own colour and the distance next to it. Just a label, no box: a box over a fruit lying on the floor helps nobody and fills the screen."
})
v850:AddToggle("espFruit", {
	Title = "Fruit ESP",
	Icon = "globe",
	Default = t9.EspFruta,
	Callback = function(p181)
		t9.EspFruta = p181
	end
})
v850:AddToggle("espIsland", {
	Title = "Island ESP",
	Icon = "globe",
	Default = t9.EspIlha,
	Callback = function(p182)
		t9.EspIlha = p182
	end
})
v850:AddToggle("espChest", {
	Title = "Chest ESP",
	Icon = "globe",
	Default = t9.EspBau,
	Callback = function(p183)
		t9.EspBau = p183
	end
})
v850:AddSlider("espWorldDist", {
	Title = "World ESP distance",
	Suffix = " studs",
	Icon = "globe",
	Min = 300,
	Max = 20000,
	Default = t9.EspMundoDist,
	Rounding = 0,
	Callback = function(p184)
		t9.EspMundoDist = p184
	end
})
v851:AddSection("moving")
v851:AddParagraph({
	Title = "About Mink speed",
	Content = "Mink is a RACE: what it gives you is a walk speed bonus. There is no remote to 'become Mink' without actually rerolling, and a reroll spends something that is yours -- so this writes the walk speed directly instead. Same result, nothing spent."
})
v851:AddToggle("speed", {
	Title = "Run faster",
	Icon = "bolt",
	Default = t9.Velocidade,
	Callback = function(p185)
		t9.Velocidade = p185

		if not p185 then
			local v856 = v331(v335())

			if v856 then
				pcall(function()
					v856.WalkSpeed = 16
				end)
			end
		end
	end
})
v851:AddSlider("speedVal", {
	Title = "How fast",
	Suffix = " ws",
	Icon = "bolt",
	Description = "16 is the game default. Above 150 is visible from far away",
	Min = 16,
	Max = 300,
	Default = t9.VelocidadeVal,
	Rounding = 0,
	Callback = function(p186)
		t9.VelocidadeVal = p186
	end
})
v851:AddToggle("jump", {
	Title = "Jump higher",
	Icon = "bolt",
	Default = t9.Pulo,
	Callback = function(p187)
		t9.Pulo = p187

		if not p187 then
			local v857 = v331(v335())

			if v857 then
				pcall(function()
					v857.JumpPower = 50
				end)
			end
		end
	end
})
v851:AddSlider("jumpVal", {
	Title = "How high",
	Icon = "bolt",
	Min = 50,
	Max = 400,
	Default = t9.PuloVal,
	Rounding = 0,
	Callback = function(p188)
		t9.PuloVal = p188
	end
})
v851:AddToggle("infJump", {
	Title = "Infinite jump",
	Icon = "bolt",
	Description = "Every press of jump works, in the air too",
	Default = t9.PuloInfinito,
	Callback = function(p189)
		t9.PuloInfinito = p189
	end
})

local n18 = 0

v120(UserInputService.JumpRequest, function()
	if not v119() then
		return
	end

	if not t9.Master or not t9.PuloInfinito or not v336() then
		return
	end

	local now2 = os.clock()

	if now2 - n18 < 0.08 then
		return
	end

	n18 = now2

	local v860 = v331(v335())

	if v860 then
		pcall(function()
			v860:ChangeState(Enum.HumanoidStateType.Jumping)
		end)
	end
end)
v851:AddToggle("dash", {
	Title = "Super dash (press Q)",
	Icon = "bolt",
	Description = "Same speed the game's own dash uses, held longer -- that is where the distance comes from",
	Default = t9.Dash,
	Callback = function(p190)
		t9.Dash = p190
	end
})
v851:AddSlider("dashVal", {
	Title = "Dash speed",
	Suffix = " studs/s",
	Icon = "bolt",
	Description = "171 is what the server accepts. Higher does not travel further -- it just gets refused.",
	Min = 80,
	Max = 250,
	Default = t9.DashVal,
	Rounding = 0,
	Callback = function(p191)
		t9.DashVal = p191
	end
})
v851:AddSlider("dashDist", {
	Title = "Dash distance",
	Suffix = " studs",
	Icon = "bolt",
	Description = "It stops early if there is a wall in the way -- the dash does not go through anything",
	Min = 20,
	Max = 400,
	Default = t9.DashDistancia,
	Rounding = 0,
	Callback = function(p192)
		t9.DashDistancia = p192
	end
})
v851:AddToggle("spin", {
	Title = "Spin your character",
	Icon = "bolt",
	Description = "Spins your body fast. Hard to hit, and it flings whoever touches you",
	Default = t9.Spin,
	Callback = function(p193)
		t9.Spin = p193

		if _G.__PVPKING_SPIN then
			_G.__PVPKING_SPIN(p193)
		end
	end
})
v851:AddSlider("spinSpeed", {
	Title = "Spin speed",
	Suffix = " deg/s",
	Icon = "bolt",
	Min = 90,
	Max = 2000,
	Default = t9.SpinVelocidade,
	Rounding = 0,
	Callback = function(p194)
		t9.SpinVelocidade = p194
	end
})
v851:AddParagraph({
	Title = "This is the spin from our Universal hub",
	Content = "Copied as is, including the one line that makes it work: AutoRotate off. In BloxStrike I had concluded a spin bot was impossible here -- I turned the root and the camera came with it, 46.9 degrees against 47.0. That conclusion was wrong. What dragged the body was the Humanoid re-aiming it at the camera every frame. With AutoRotate off the body spins and your camera stays where you left it."
})
v851:AddSection("extras")
v851:AddToggle("stamina", {
	Title = "Energy never runs out",
	Icon = "bolt",
	Description = "Keeps energy topped up so dash and geppo never run out",
	Default = t9.StaminaInf,
	Callback = function(p195)
		t9.StaminaInf = p195
	end
})
v851:AddToggle("water", {
	Title = "Walk on the sea",
	Icon = "globe",
	Description = "A platform of its own under you while you are over the sea",
	Default = t9.AndarNaAgua,
	Callback = function(p196)
		t9.AndarNaAgua = p196
	end
})
v851:AddToggle("noclip", {
	Title = "Walk through walls",
	Icon = "globe",
	Default = t9.SemColisao,
	Callback = function(p197)
		t9.SemColisao = p197
	end
})
v852:AddSection("travel controls")
v852:AddSection("islands")
v852:AddParagraph({
	Title = "This is our farm hub travel",
	Content = "Same engine the Blox Fruits hub uses: it routes through a PORTAL past 3.000 studs, yields to whatever else wants to move your body, and handles the submerged island. A hand written tween has none of that, which is why the first version of this file was thrown away."
})

do
	local v861 = t35.listar()

	if #v861 == 0 then
		v861 = { "(no island found)" }
	end

	local u862 = v861[1]
	local island = v852:AddDropdown("island", {
		Title = "Island",
		Icon = "globe",
		Description = "Read from the game itself, so updates show up on their own",
		Values = v861,
		Default = u862,
		Callback = function(p198)
			u862 = p198
		end
	})

	task.spawn(function()
		_G.__TSUO_Escalona()

		local v864 = #v861 .. "|" .. tostring(v861[1])

		while true do
			task.wait(3)

			if not v119() then
				break
			end

			local v865 = t35.listar()
			local v866 = #v865 .. "|" .. tostring(v865[1])

			if #v865 > 0 and v866 ~= v864 then
				v864 = v866
				pcall(function()
					if island and island.SetValues then
						island.SetValues(v865)
					end
				end)

				if not table.find(v865, u862) then
					u862 = v865[1]
				end

				v848("Teleport", "Island list updated for this sea (" .. #v865 .. ").", 4)
			end
		end
	end)

	local u867 = false
	local travel

	travel = v852:AddToggle("travel", {
		Title = "Travel to the island",
		Icon = "globe",
		Description = "Turn on to go, turn off to stop where you are",
		Default = false,
		Callback = function(p199)
			if not p199 then
				if u867 then
					_G.__TSUO_IrAteCancelar = true
					_G.__TSUO_IrAteCancelarEm = nil
					pcall(v179)
					pcall(function()
						if _G.__TSUO_LargarMov then
							_G.__TSUO_LargarMov()
						end
					end)
					v848("Travel", "Stopped.", 4)
				end

				return
			end

			if u867 then
				return
			end

			local v869 = t35.posicao(u862)

			if not v869 then
				v848("Travel", "Island not found.", 6, "error")
				pcall(function()
					if travel and travel.Set then
						travel.Set(false, true)
					end
				end)

				return
			end

			if not (v869.Y < -400) then
				v848("Travel", "Heading to " .. u862 .. ". Turn this off to stop.", 5)
				task.spawn(function()
					u867 = true

					local v870, v871 = _G.__TSUO_IrAte(cFrameNew(v869), function()
						return true
					end, t9.TpAltura, "ilha")

					u867 = false
					_G.__TSUO_IrAteCancelar = false
					v848("Travel", v870 and "Arrived at " .. u862 .. "." or tostring(v871), v870 and 5 or 8, v870 and "success" or "warning")
					pcall(function()
						if travel then
							if travel.Set then
								travel.Set(false, true)
							end
						end
					end)
				end)

				return
			end

			if u862 == "Submerged Island" then
				v848("Travel", "Underwater island -- going by the submarine, not by air.", 6)
				task.spawn(function()
					u867 = true

					local v872 = t5.viajar("Submerged Island")

					u867 = false
					v848("Travel", v872 and "Arrived." or "The submarine refused the trip.", v872 and 5 or 8, v872 and "success" or "warning")
					pcall(function()
						if travel and travel.Set then
							travel.Set(false, true)
						end
					end)
				end)

				return
			end

			v848("Travel", u862 .. " sits at " .. math.floor(v869.Y) .. " studs -- that is underwater or inside the map. Flying there drowns you, so I am not going.", 10, "warning")
			pcall(function()
				if travel and travel.Set then
					travel.Set(false, true)
				end
			end)
		end
	})
	v852:AddButton({
		Title = "Get in past the barrier",
		ButtonText = "Save spawn and die",
		Variant = "ghost",
		Description = "For islands with a level barrier: travels there, saves the spawn on the spot and dies, so you come back past the wall",
		Callback = function()
			local v873 = t38.ir(u862, function(p200, p201)
				v848("Bypass", p200, p201 == "info" and 5 or 8, p201)
			end)

			if not v873 then
				v848("Bypass", e_, 6, "error")
			end
		end
	})
end

v852:AddParagraph({
	Title = "Why the bypass kills you",
	Content = "SetLastSpawnPoint(name) does NOT move your respawn -- measured twice, once across all 16 islands of Sea 3 and again on this server: it returns ok and the value stays put, so it accepts the call and ignores the name. What does work is SetSpawnPoint() with no argument, which saves wherever the SERVER thinks you are. So the order has to be: travel first, save second, die last. Dying costs nothing in Blox Fruits -- no item and no fruit is lost."
})
v852:AddButton({
	Title = "Stop travel",
	ButtonText = "Cancel",
	Variant = "ghost",
	Callback = function()
		_G.__TSUO_IrAteCancelar = true
		pcall(function()
			if v179 then
				v179()
			end
		end)
		v848("Travel", "Cancelled.", 4, "warning")
	end
})
v852:AddSlider("tpHeight", {
	Title = "Stop this high above it",
	Suffix = " studs",
	Icon = "globe",
	Description = "How high above the island to stop. 36 is what the farm hub uses",
	Min = 6,
	Max = 400,
	Default = t9.TpAltura,
	Rounding = 0,
	Callback = function(p202)
		t9.TpAltura = p202
	end
})
v854:AddSection("general")
v854:AddToggle("master", {
	Title = "Master switch",
	Icon = "bolt",
	Description = "Turns everything off at once without losing your choices",
	Default = t9.Master,
	Callback = function(p203)
		t9.Master = p203
	end
})

do
	local color33 = Color3.fromRGB(190, 70, 255)

	local function v876(p204)
		if typeof(p204) ~= "Color3" then
			return color33
		end

		if p204.R * 0.299 + p204.G * 0.587 + p204.B * 0.114 < 0.15 then
			return color33
		end

		return p204
	end

	v854:AddColorPicker("uiColor", {
		Title = "Panel color",
		Default = color33,
		Callback = function(p205)
			local v877 = v876(p205)

			pcall(function()
				v847:SetAccent(v877)
			end)
		end
	})
end

v853:AddSection("faction")
v853:AddParagraph({
	Title = "How the game switches side",
	Content = "It is the same call the NPC makes: CommF_(\"SetTeam\", \"Pirates\" or \"Marines\"). Nothing else is touched -- no teleport, no respawn. The team only changes on the server, so the panel reads it back from Player.Team right after."
})

local u878 = LocalPlayer.Team and LocalPlayer.Team.Name == "Marines" and "Marines" or "Pirates"

v853:AddDropdown("team", {
	Title = "Side",
	Icon = "shield",
	Values = {
		"Pirates",
		"Marines"
	},
	Default = u878,
	Callback = function(p206)
		u878 = p206
	end
})
v853:AddButton({
	Title = "Switch side",
	ButtonText = "Apply",
	Callback = function()
		local Name = LocalPlayer.Team and LocalPlayer.Team.Name
		local CommF_ = ReplicatedStorage:FindFirstChild("Remotes") and ReplicatedStorage.Remotes:FindFirstChild("CommF_")

		if not CommF_ then
			v848("Faction", "CommF_ not found.", 6, "error")

			return
		end

		task.spawn(function()
			if not pcall(function()
				CommF_:InvokeServer("SetTeam2", u878)
			end) then
				v848("Faction", "The game refused the call.", 6, "error")

				return
			end

			local v881 = tick() + 5

			while true do
				if tick() < v881 then
					if (LocalPlayer.Team and LocalPlayer.Team.Name) == Name then
						task.wait(0.2)

						continue
					end

					break
				end

				break
			end

			local Name2 = LocalPlayer.Team and LocalPlayer.Team.Name

			if Name2 == u878 then
				v848("Faction", "You are " .. tostring(Name2) .. " now.", 5, "success")
			else
				v848("Faction", "Still " .. tostring(Name2) .. " -- the game did not accept the switch.", 8, "warning")
			end
		end)
	end
})
v854:AddSection("profiles")
v847:AddProfileManager(v854, {
	Section = "profiles"
})
v854:AddButton({
	Title = "Reset everything",
	ButtonText = "Back to default",
	Variant = "ghost",
	Description = "Erases the saved profile. Run the script again afterwards",
	Callback = function()
		pcall(function()
			if type(delfile) == "function" then
				if type(isfile) == "function" then
					local ipairs_ = ipairs
					local s6 = "tsuo_pvpking_meta.json"
					local activeProfile = v847:GetActiveProfile() or "Padrao"
					local t39 = {
						s6,
						"tsuo_pvpking_" .. activeProfile .. ".json"
					}

					for _, v in ipairs_(t39) do
						if isfile(v) then
							delfile(v)
						end
					end
				end
			end
		end)
		v848("Reset", "Profile erased. Run the script again.", 8, "warning")
	end
})
v854:AddParagraph({
	Title = "TSUO PVP KING 2.1",
	Content = "RightShift hides and shows the panel. No key system in this build yet. Nothing here fires an economy remote: it does not buy, sell or drop anything of yours."
})
task.defer(function()
	if type(isfile) ~= "function" then
		return
	end

	local HttpService = v105("HttpService")
	local s7 = "Padrao"

	pcall(function()
		local data = HttpService:JSONDecode(readfile("tsuo_pvpking_meta.json"))

		if type(data.active) == "string" then
			s7 = data.active
		end
	end)

	local v892 = "tsuo_pvpking_" .. s7 .. ".json"

	if not isfile(v892) then
		return
	end

	local ok3, result3 = pcall(function()
		return HttpService:JSONDecode(readfile(v892))
	end)

	if not ok3 or type(result3) ~= "table" then
		return
	end

	task.wait(0.6)
	pcall(function()
		local Options = v847.Options or {}

		for k, v in pairs(result3) do
			local v898 = Options[k]

			if v898 and v898.Set and v898.Get then
				local ok4, result4 = pcall(v898.Get)

				if ok4 and result4 == v then
					if type(v) == "number" then
						pcall(v898.Set, v + 1, true)

						local ok5, result5 = pcall(v898.Get)

						if ok5 and result5 == v then
							pcall(v898.Set, v - 1, true)
						end
					elseif type(v) == "boolean" then
						pcall(v898.Set, not v, true)
					end
				end
			end
		end

		v847:SetConfig(result3, false)
	end)
end)
_G.PVPKING = {
	cfg = function(p207, p208)
		if p208 == nil then
			return t9[p207]
		end

		t9[p207] = p208

		return t9[p207]
	end,
	estado = function()
		local v903 = v331(v335())
		local v904 = v772()
		local n19 = 0

		for _ in pairs(t26) do
			n19 += 1
		end

		local function v907()
			local t40 = {}

			for _, player in ipairs(Players:GetPlayers()) do
				if player ~= LocalPlayer then
					local v911 = v365(player) or "serve de alvo"

					t40[v911] = (t40[v911] or 0) + 1
				end
			end

			local t41 = {}

			for k, v in pairs(t40) do
				t41[#t41 + 1] = v .. " " .. k
			end

			table.sort(t41)

			return table.concat(t41, ", ")
		end

		return {
			versao = "2.1",
			vivo = v336(),
			aim = t9.Aim,
			aimInfo = s5,
			alvo = v327(u320),
			pulados = v907(),
			fovGraus = t9.AimFovGraus,
			esp = t9.Esp,
			espDist = t9.EspDist,
			desenhados = n19,
			ws = v903 and v903.WalkSpeed or -1,
			jp = v903 and v903.JumpPower or -1,
			energia = v904 and v904.Name .. "=" .. tostring(v904.Value) or "not found",
			ilhas = #t35.listar(),
			tp = type(_tp) == "function" and type(_G.__TSUO_IrAte) == "function"
		}
	end,
	ui = function(p209, p210)
		local v915 = (v847.Options or {})[p209]

		if not v915 then
			return "nao existe: " .. tostring(p209)
		end

		if p210 == nil then
			local ok3 = pcall(v915.Get)

			if ok3 then
				return A
			end

			return "erro no Get"
		end

		local ok3 = pcall(v915.Get)

		if ok3 and dZ == p210 then
			if type(p210) == "number" then
				pcall(v915.Set, p210 + 1, true)

				local ok4 = pcall(v915.Get)

				if ok4 and ah == p210 then
					pcall(v915.Set, p210 - 1, true)
				end
			elseif type(p210) == "boolean" then
				pcall(v915.Set, not p210, true)
			end
		end

		pcall(v915.Set, p210)

		local ok4 = pcall(v915.Get)

		if ok4 then
			return A
		end

		return "erro no Get"
	end,
	ids = function()
		local t42 = {}
		local Options = v847.Options or {}

		for k in pairs(Options) do
			t42[#t42 + 1] = k
		end

		table.sort(t42)

		return t42
	end,
	ir = function(p211)
		local v927 = t35.posicao(p211)

		if v927 then
			return _G.__TSUO_IrAte(cFrameNew(v927), function()
				return true
			end, t9.TpAltura, "ilha")
		end

		return false, "island not found"
	end
}
_G.__PVPKING_UNLOAD = function()
	_G.__PVPKING_GEN = (_G.__PVPKING_GEN or 0) + 1
	pcall(function()
		if v179 then
			v179()
		end
	end)
	_G.__TSUO_IrAteCancelar = true

	for _, v in ipairs(t1) do
		pcall(function()
			if typeof(v) == "RBXScriptConnection" then
				v:Disconnect()
			elseif typeof(v) == "Instance" then
				v:Destroy()
			elseif type(v) == "table" and type(v.Destroy) == "function" then
				v.Destroy()
			end
		end)
	end

	for _, child in ipairs(Workspace:GetChildren()) do
		if child.Name == "TsuoPvpPiso" then
			pcall(function()
				child:Destroy()
			end)
		end
	end

	for _, descendant in ipairs(Workspace:GetDescendants()) do
		if descendant.Name == "TsuoPvpChams" then
			pcall(function()
				descendant:Destroy()
			end)
		end
	end

	pcall(function()
		v847:Destroy()
	end)

	local v934 = v331(v330(LocalPlayer))

	if v934 then
		pcall(function()
			v934.WalkSpeed = 16
			v934.JumpPower = 50
		end)
	end

	_G.__PVPKING_UNLOAD = nil
	_G.PVPKING = nil
end
v848("TSUO PVP KING", "Loaded. RightShift hides and shows.", 6, "success")
pcall(function()
	local v935 = _G.__TSUO_BootT0 and (tick() - _G.__TSUO_BootT0) * 1000

	_G.__TSUO_Beacon("tsuopvpking", "2.1", v935 or nil)
end)

if not pcall(function()
	local Players2 = game:GetService("Players")
	local Workspace2 = game:GetService("Workspace")
	local HttpService = game:GetService("HttpService")
	local t44 = {
		API = "https://tsuoblox.com/api/notify/report",
		VARRER = 8,
		CARENCIA = 900,
		CARENCIA_MIRAGE = 300
	}
	local request_ = syn and syn.request or http and http.request or http_request or request or fluxus and fluxus.request

	local function v942()
		local s8 = ""

		if type(gethwid) == "function" then
			local ok3, result3 = pcall(gethwid)

			if ok3 and type(result3) == "string" then
				s8 = result3
			end
		end

		local s9 = ""

		pcall(function()
			s9 = tostring(Players2.LocalPlayer.UserId)
		end)

		if s8 == "" then
			s8 = s9
		end

		return {
			hwid = s8,
			uid = s9
		}
	end

	local v947 = v942()
	local t45 = {
		Kitsune = 8000000,
		Yeti = 5000000,
		Gas = 4000000,
		Control = 3200000,
		Venom = 3000000,
		Shadow = 2900000,
		Dough = 2800000,
		["T-Rex"] = 2700000,
		Mammoth = 2600000,
		Gravity = 2500000,
		Blizzard = 2400000,
		Pain = 2300000,
		Rumble = 2100000,
		Spirit = 3400000,
		Leopard = 5000000,
		Dragon = 3500000,
		Portal = 1800000,
		Phoenix = 1800000,
		Buddha = 1200000,
		Love = 1300000,
		Creation = 1000000,
		Spider = 1000000,
		Sound = 1000000,
		Quake = 1000000
	}
	local t46 = {
		{
			nome = "Greybeard",
			rotulo = "Greybeard (Barba Branca)"
		},
		{
			nome = "Saber Expert",
			rotulo = "Saber Expert"
		},
		{
			nome = "Darkbeard",
			rotulo = "Darkbeard (Barba Negra)"
		},
		{
			nome = "Cursed Captain",
			rotulo = "Cursed Captain (barco fantasma)"
		},
		{
			nome = "Tide Keeper",
			rotulo = "Tide Keeper"
		},
		{
			nome = "Awakened Ice Admiral",
			rotulo = "Awakened Ice Admiral"
		},
		{
			nome = "Dough King",
			rotulo = "Dough King"
		},
		{
			nome = "rip_indra",
			rotulo = "Rip Indra"
		},
		{
			nome = "rip_indra True Form",
			rotulo = "Rip Indra (True Form, raid)"
		},
		{
			nome = "Soul Reaper",
			rotulo = "Soul Reaper (a foice, castelo assombrado)"
		},
		{
			nome = "Kilo Admiral",
			rotulo = "Kilo Admiral"
		},
		{
			nome = "Captain Elephant",
			rotulo = "Captain Elephant"
		},
		{
			nome = "Beautiful Pirate",
			rotulo = "Beautiful Pirate"
		},
		{
			nome = "Tiki",
			rotulo = "Tiki (evento)"
		}
	}
	local t47 = {
		["snow white"] = true,
		["pure red"] = true,
		["winter sky"] = true,
		aquamarine = true,
		["light pink"] = true
	}

	local function v951(p212)
		if not p212 then
			return false
		end

		local Humanoid = p212:FindFirstChildOfClass("Humanoid")

		if Humanoid then
			return Humanoid.Health > 0
		end

		return true
	end
	local function v953(p213)
		local Enemies = Workspace2:FindFirstChild("Enemies")

		if Enemies and v951(Enemies:FindFirstChild(p213)) then
			return true
		end

		return v951(Workspace2:FindFirstChild(p213))
	end
	local function v955()
		local t48 = {}

		for _, child in ipairs(Workspace2:GetChildren()) do
			if child.Name:find("Fruit") and child:FindFirstChild("Handle") then
				local v959 = child.Name:gsub("%-.*", ""):gsub("%s*Fruit%s*", ""):gsub("^%s+", ""):gsub("%s+$", "")

				t48[#t48 + 1] = {
					nome = v959,
					valor = t45[v959]
				}
			end
		end

		return t48
	end
	local function v960()
		local t49 = {}

		for _, v in ipairs(t46) do
			if v953(v.nome) then
				t49[#t49 + 1] = {
					nome = v.rotulo
				}
			end
		end

		return t49
	end
	local function v964()
		local t50 = {}

		if v953("Core") then
			t50[#t50 + 1] = {
				nome = "Factory"
			}
		end

		local Map = Workspace2:FindFirstChild("Map")
		local BoatCastle = Map and Map:FindFirstChild("Boat Castle")
		local Summoner = BoatCastle and BoatCastle:FindFirstChild("Summoner")
		local Circle = Summoner and Summoner:FindFirstChild("Circle")

		if Circle and #Circle:GetChildren() > 0 then
			t50[#t50 + 1] = {
				nome = "Castle Raid"
			}
		end

		return t50
	end

	local t51 = {
		"Shizu",
		"Saishi",
		"Oroshi",
		"Shisui",
		"Saddi",
		"Wando"
	}
	local t52 = {
		Shisui = "Shizu",
		Saddi = "Saishi",
		Wando = "Oroshi"
	}
	local t53 = {
		interact = true,
		e = true,
		buy = true,
		press = true,
		talk = true,
		shop = true,
		close = true,
		cancel = true,
		yes = true,
		no = true,
		["legendary sword dealer"] = true,
		["sword dealer"] = true,
		dealer = true,
		["you found me!"] = true,
		["gone."] = true
	}

	local function v973()
		local LegendarySwordDealer = Workspace2:FindFirstChild("Legendary Sword Dealer", true) or Workspace2:FindFirstChild("Legendary Sword Dealer ", true)

		if not LegendarySwordDealer then
			return {}
		end

		local u975
		local t54 = {}

		pcall(function()
			for _, descendant in ipairs(LegendarySwordDealer:GetDescendants()) do
				if descendant:IsA("TextLabel") and descendant.Text and #descendant.Text > 1 then
					local Text = descendant.Text

					if not u975 then
						for _, v in ipairs(t51) do
							if Text:lower():find(v:lower(), 1, true) then
								u975 = t52[v] or v

								break
							end
						end
					end

					local v982 = Text:gsub("^%s+", ""):gsub("%s+$", "")

					if #v982 > 1 and not t53[v982:lower()] and #t54 < 6 then
						t54[#t54 + 1] = v982
					end
				end
			end
		end)

		if u975 then
			return { {
				nome = u975,
				detalhe = "A venda por $2.000.000 no vendedor de espadas"
			} }
		end

		local t55 = { {
			nome = "Legendary Sword Dealer",
			detalhe = #t54 > 0 and "Vendedor no servidor. Na tela: " .. table.concat(t54, ", ") or "Vendedor no servidor (nao consegui ler qual espada)"
		} }

		return t55
	end
	local function v984()
		local t56 = {}

		if not Workspace2:FindFirstChild("Barista Cousin", true) then
			return t56
		end

		pcall(function()
			local Remotes = game:GetService("ReplicatedStorage"):FindFirstChild("Remotes")
			local CommF_ = Remotes and Remotes:FindFirstChild("CommF_")

			if not CommF_ then
				return
			end

			local ok3, result3, result4 = pcall(function()
				return CommF_:InvokeServer("ColorsDealer", "1")
			end)

			if not ok3 or type(result3) ~= "string" or #result3 == 0 then
				return
			end

			if not ((tonumber(result4) or 0) >= 3 or t47[result3:lower()] == true) then
				return
			end

			t56[#t56 + 1] = {
				nome = result3,
				detalhe = "Cor lendaria no Barista Cousin. Ele fica 20 min e sai."
			}
		end)

		return t56
	end
	local function v991()
		local t57 = {}

		pcall(function()
			local _WorldOrigin = Workspace2:FindFirstChild("_WorldOrigin") or Workspace2:FindFirstChild("WorldOrigin")
			local Locations = _WorldOrigin and _WorldOrigin:FindFirstChild("Locations")
			local MirageIsland = Locations and Locations:FindFirstChild("Mirage Island")

			if not MirageIsland then
				local Map = Workspace2:FindFirstChild("Map")

				MirageIsland = Map and (Map:FindFirstChild("MysticIsland") or Map:FindFirstChild("Mystic Island"))
			end

			if MirageIsland then
				t57[#t57 + 1] = {
					nome = "Mirage Island",
					detalhe = "A ilha esta no mapa agora"
				}
			end
		end)

		return t57
	end
	local function v997()
		local t58 = {}

		pcall(function()
			local Lighting = game:GetService("Lighting")
			local FantasySky = Lighting:FindFirstChild("FantasySky") or Lighting:FindFirstChildOfClass("Sky")

			if not FantasySky then
				return
			end

			local v1001 = tostring(FantasySky.MoonTextureId or "")

			if (v1001:match("(%d+)$") or v1001:match("id=(%d+)")) == "9709149431" then
				t58[#t58 + 1] = {
					nome = "Full Moon",
					detalhe = "Lua cheia neste servidor agora"
				}
			end
		end)

		return t58
	end

	local t59 = {}

	local function v1003(p214)
		if #p214 == 0 or not request_ then
			return
		end

		task.spawn(function()
			pcall(request_, {
				Url = t44.API,
				Method = "POST",
				Headers = {
					["Content-Type"] = "application/json",
					["x-tsuo-hwid"] = v947.hwid,
					["x-tsuo-uid"] = v947.uid,
					["x-tsuo-hub"] = tostring(_G.__TSUO_HUB or "")
				},
				Body = HttpService:JSONEncode({
					jobId = game.JobId,
					placeId = game.PlaceId,
					players = #Players2:GetPlayers(),
					maxPlayers = Players2.MaxPlayers,
					events = p214
				})
			})
		end)
	end
	local function v1004()
		local t60 = {}

		local function v1006(p215, p216)
			for _, v in ipairs(p216) do
				local v1009 = p215 .. "/" .. tostring(v.nome)
				local now2 = tick()

				if not t59[v1009] or (p215 == "mirage" and t44.CARENCIA_MIRAGE or t44.CARENCIA) < now2 - t59[v1009] then
					t59[v1009] = now2
					t60[#t60 + 1] = {
						type = p215,
						name = v.nome,
						value = v.valor,
						detail = v.detalhe
					}
				end
			end
		end

		v1006("fruit", v955())
		v1006("boss", v960())
		v1006("event", v964())
		v1006("triple_swords", v973())
		v1006("haki_legend", v984())
		v1006("mirage", v991())
		v1006("full_moon", v997())
		v1003(t60)
	end

	local t43 = {
		ligar = function()
			if _G.__TSUO_NOTIFICADORES_ON then
				return false
			end

			_G.__TSUO_NOTIFICADORES_ON = true
			task.spawn(function()
				task.wait(10)

				while _G.__TSUO_NOTIFICADORES_ON do
					pcall(v1004)
					task.wait(t44.VARRER)
				end
			end)

			return true
		end,
		desligar = function()
			_G.__TSUO_NOTIFICADORES_ON = false
		end
	}

	t43.ligar()
end) then
	_G.__TSUO_NOTIFICADORES_ON = nil
end
