-- This file was generated at discord.gg/syncrypt

local t1 = {}
local unpack_ = unpack or table.unpack

if not game:IsLoaded() then
	t1.value1 = tick()

	local value1 = t1.value1

	function t1.value2()
		while true do
			local v5 = not game:IsLoaded()

			if v5 then
				v5 = tick() - value1 < 20
			end

			if not v5 then
				return
			end

			task.wait(0.2)
		end
	end

	pcall(t1.value2)
end

local t2 = {
	value1 = {
		RENDER = {
			Name = "Server 1",
			Url = "https://justbot-cpjk.onrender.com",
			IsDefault = true
		},
		SUPABASE = {
			Name = "Server 2 (Recommended for RU users)",
			Url = "https://pijzgwkoowrmwligzily.supabase.co/functions/v1/hyper-handler",
			IsDefault = false
		}
	},
	value2 = {
		TG_LINK = "https://t.me/hubhubhubhubhubhubhub_bot",
		WORKINK_GATEWAY = "https://justbot-cpjk.onrender.com/workink/start?userId=",
		FOLDER = "HubHubHub_Configs",
		FILE = "KeyAuth_Session.json",
		HOURS = 24,
		MASTER_KEY = "Ilovebananasfuckthatsreallycoolthingandmaybethebestthingever"
	},
	value3 = {
		Players = game:GetService("Players"),
		HttpService = game:GetService("HttpService"),
		TweenService = game:GetService("TweenService"),
		UserInputService = game:GetService("UserInputService"),
		RbxAnalyticsService = game:GetService("RbxAnalyticsService"),
		MarketplaceService = game:GetService("MarketplaceService")
	}
}
local LocalPlayer = t2.value3.Players.LocalPlayer or t2.value3.Players.PlayerAdded:Wait()

t2.value4 = nil
t2.value5 = LocalPlayer

function t2.value6()
	local GameId = game.GameId or 0
	local u8 = tostring(GameId)

	if not (u8 == "0" or u8 == "") then
		return u8
	end

	pcall(function()
		local productInfo = t2.value3.MarketplaceService:GetProductInfo(game.PlaceId)
		local UniverseId

		if productInfo then
			UniverseId = productInfo.UniverseId
		else
			UniverseId = productInfo
		end

		if not UniverseId then
			return
		end

		local UniverseId2 = productInfo.UniverseId

		u8 = tostring(UniverseId2)
	end)

	return u8
end

t2.value7 = (function()
	local getexecutor_ = nil
	local u13 = nil

	local function v14()
		if identifyexecutor then
			local v15, v16 = identifyexecutor()

			getexecutor_ = v15
			u13 = v16

			return
		end

		if getexecutorname then
			local v17, v18 = getexecutorname()

			getexecutor_ = v17
			u13 = v18

			return
		end

		if not getexecutor then
			return
		end

		getexecutor_ = getexecutor
	end

	pcall(v14)

	if not getexecutor_ or (getexecutor_ == "" or getexecutor_ == "Unknown") then
		pcall(function()
			local getgenv_ = getgenv

			if getgenv_ then
				getgenv_ = getgenv()
			end

			local _G_ = getgenv_ or (_G or {})
			local syn_ = syn

			if not syn_ then
				if syn_ then
					getexecutor_ = "Synapse Z"
				elseif delta or _G_.delta then
					getexecutor_ = "Delta"

					return
				elseif fluxus or _G_.fluxus then
					getexecutor_ = "Fluxus"

					return
				elseif codex or _G_.codex then
					getexecutor_ = "Codex"

					return
				elseif arceus or _G_.arceus then
					getexecutor_ = "Arceus X"

					return
				elseif hydrogen or _G_.hydrogen then
					getexecutor_ = "Hydrogen"

					return
				elseif _G_.WAVE_LOADED or WAVE_LOADED then
					getexecutor_ = "Wave"

					return
				elseif _G_.SOLARA_LOADED or SOLARA_LOADED then
					getexecutor_ = "Solara"

					return
				elseif _G_.ELECTRON_LOADED or ELECTRON_LOADED then
					getexecutor_ = "Electron"

					return
				elseif _G_.CELERY_LOADED or CELERY_LOADED then
					getexecutor_ = "Celery"

					return
				elseif KRNL_LOADED then
					getexecutor_ = "Krnl"

					return
				elseif is_sirhurt_closure then
					getexecutor_ = "SirHurt"

					return
				elseif Cryptic then
					getexecutor_ = "Cryptic"

					return
				elseif Cubix then
					getexecutor_ = "Cubix"

					return
				elseif VegaX then
					getexecutor_ = "Vega X"

					return
				else
					getexecutor_ = "Custom / Mobile"

					return
				end

				return
			end

			syn_ = syn.request

			if syn_ then
				getexecutor_ = "Synapse Z"
			elseif delta or _G_.delta then
				getexecutor_ = "Delta"

				return
			elseif fluxus or _G_.fluxus then
				getexecutor_ = "Fluxus"

				return
			elseif codex or _G_.codex then
				getexecutor_ = "Codex"

				return
			elseif arceus or _G_.arceus then
				getexecutor_ = "Arceus X"

				return
			elseif hydrogen or _G_.hydrogen then
				getexecutor_ = "Hydrogen"

				return
			elseif _G_.WAVE_LOADED or WAVE_LOADED then
				getexecutor_ = "Wave"

				return
			elseif _G_.SOLARA_LOADED or SOLARA_LOADED then
				getexecutor_ = "Solara"

				return
			elseif _G_.ELECTRON_LOADED or ELECTRON_LOADED then
				getexecutor_ = "Electron"

				return
			elseif _G_.CELERY_LOADED or CELERY_LOADED then
				getexecutor_ = "Celery"

				return
			elseif KRNL_LOADED then
				getexecutor_ = "Krnl"

				return
			elseif is_sirhurt_closure then
				getexecutor_ = "SirHurt"

				return
			elseif Cryptic then
				getexecutor_ = "Cryptic"

				return
			elseif Cubix then
				getexecutor_ = "Cubix"

				return
			elseif VegaX then
				getexecutor_ = "Vega X"

				return
			else
				getexecutor_ = "Custom / Mobile"

				return
			end
		end)
	end

	local v22 = tostring(getexecutor_ or "Unknown Executor")
	local v23 = u13

	if v23 then
		v23 = tostring(u13) ~= ""

		if v23 then
			v23 = not v22:find(tostring(u13))
		end
	end

	if not v23 then
		return v22
	end

	v22 = v22 .. " " .. tostring(u13)

	return v22
end)()

function t2.value8(p1)
	if p1 then
		local v24 = tostring(p1)

		return v24.gsub(v24, "[%s\r\n\t]", "")
	else
		return ""
	end
end
function t2.value9(p2)
	pcall(function()
		if setclipboard then
			setclipboard(p2)

			return
		end

		if toclipboard then
			toclipboard(p2)

			return
		end

		local Clipboard_ = Clipboard

		if Clipboard_ then
			Clipboard_ = Clipboard.set
		end

		if not Clipboard_ then
			return
		end

		Clipboard.set(p2)
	end)
end
function t2.value10()
	local u26 = nil

	local function v27()
		if getclipboard then
			u26 = getclipboard()

			return
		end

		local Clipboard_ = Clipboard

		if Clipboard_ then
			Clipboard_ = Clipboard.get
		end

		if not Clipboard_ then
			return
		end

		u26 = Clipboard.get()
	end

	u26 = ""
	pcall(v27)

	return tostring(u26 or "")
end
function t2.value11()
	local ok, result = pcall(function()
		local gethui_ = gethui

		if not gethui_ then
			return gethui_
		end

		gethui_ = gethui()

		return gethui_
	end)

	if ok and result then
		return result
	end

	local ok2, result2 = pcall(function()
		return game:GetService("CoreGui")
	end)

	if ok2 then
	elseif ok2 then
		return result2
	else
		return t2.value5:WaitForChild("PlayerGui", 10) or t2.value5:FindFirstChild("PlayerGui")
	end

	if result2 then
		ok2 = pcall(function()
			Instance.new("Folder", result2):Destroy()
		end)
	else
		ok2 = result2
	end

	if ok2 then
		return result2
	else
		return t2.value5:WaitForChild("PlayerGui", 10) or t2.value5:FindFirstChild("PlayerGui")
	end
end
function t2.value12(p3, p4, p5)
	local instance = Instance.new(p3)
	local v35, v36, v37 = pairs(p4 or {})

	while true do
		local v38

		v37, v38 = v35(v36, v37)

		if not v37 then
			break
		end

		instance[v37] = v38
	end

	if not p5 then
		return instance
	end

	for _, v in ipairs(p5) do
		v.Parent = instance
	end

	return instance
end
function t2.value13(p6, p7)
	return t2.value12("UICorner", {
		CornerRadius = UDim.new(0, p6 or 8),
		Parent = p7
	})
end
function t2.value14(p8, p9, p10)
	return t2.value12("UIStroke", {
		Color = p8 or Color3.fromRGB(55, 55, 65),
		Thickness = p9 or 1,
		Parent = p10
	})
end
function t2.value15(p11, p12)
	local v41 = p12 or p11
	local u42 = false
	local u43 = nil
	local Position = nil
	local Position2 = nil

	p11.InputBegan:Connect(function(input)
		if not (input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch) then
			return
		end

		u42 = true
		Position = input.Position
		Position2 = v41.Position
	end)
	t2.value3.UserInputService.InputEnded:Connect(function(input)
		if not (input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch) then
			return
		end

		u42 = false
	end)
	p11.InputChanged:Connect(function(input)
		if not (input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch) then
			return
		end

		u43 = input
	end)
	t2.value3.UserInputService.InputChanged:Connect(function(input)
		local v46 = u42

		if v46 then
			v46 = input == u43
		end

		if not v46 then
			return
		end

		local v47 = input.Position - Position

		v41.Position = UDim2.new(Position2.X.Scale, Position2.X.Offset + v47.X, Position2.Y.Scale, Position2.Y.Offset + v47.Y)
	end)
end
function t2.value16()
	local s1 = "UNKNOWN"

	pcall(function()
		if gethwid then
			s1 = gethwid()

			return
		end

		local RbxAnalyticsService = t2.value3.RbxAnalyticsService

		if RbxAnalyticsService then
			RbxAnalyticsService = t2.value3.RbxAnalyticsService.GetClientId
		end

		if not RbxAnalyticsService then
			return
		end

		s1 = t2.value3.RbxAnalyticsService:GetClientId()
	end)

	local v50 = s1

	return tostring(v50)
end
function t2.value17(p13, p14, p15, p16)
	local v51 = os.time() / 60
	local v52 = math.floor(v51) + (p16 or 0)
	local v53 = tostring(p13) .. "::" .. tostring(p14) .. "::" .. tostring(v52) .. "::" .. tostring(p15)
	local n1 = 5381

	for i = 1, #v53 do
		n1 = (n1 * 33 + v53:byte(i)) % 2147483647
	end

	return tostring(n1)
end
function t2.value18()
	local syn_ = syn

	if syn_ then
		syn_ = syn.request
	end

	if syn_ then
		return syn_
	end

	syn_ = request

	if syn_ then
		return syn_
	end

	syn_ = http_request

	if syn_ then
		return syn_
	end

	syn_ = http

	if not syn_ then
		return syn_
	end

	syn_ = http.request

	return syn_
end

local function v57(p17, p18, p19)
	local v58 = t2.value18()

	if not v58 then
		return
	end

	local HttpService = t2.value3.HttpService
	local UserId = t2.value5.UserId
	local json = HttpService:JSONEncode({
		type = "telemetry",
		userId = tostring(UserId),
		executor = t2.value7,
		gameId = t2.value6(),
		loadTime = tostring(p17),
		status = p18 or "success"
	})

	task.spawn(function()
		local pos = p19:find("onrender.com")

		if pos then
			pos = p19 .. "/telemetry"
		end

		local v63 = pos or p19

		local function v64()
			v58({
				Url = v63,
				Method = "POST",
				Headers = {
					["Content-Type"] = "application/json"
				},
				Body = json,
				Timeout = 10
			})
		end

		pcall(v64)
	end)
end

t2.value19 = nil

function t2.value19(p20)
	if type(p20) ~= "table" then
		return nil
	end

	local Body = p20.Body

	if Body == nil or Body == "" then
		return nil
	end

	if type(Body) == "table" then
		return Body
	end

	local ok, result = pcall(function()
		return t2.value3.HttpService:JSONDecode(Body)
	end)

	if ok then
	elseif ok then
		return result
	else
		return nil
	end

	ok = type(result) == "table"

	if ok then
		return result
	else
		return nil
	end
end
function t2.value20(p21, p22)
	local v68 = t2.value18()

	if not v68 then
		return nil
	end

	local HttpService = t2.value3.HttpService
	local v70 = tostring(p21)
	local UserId = t2.value5.UserId
	local v72 = tostring(UserId)
	local JSONEncode = HttpService.JSONEncode
	local v74 = t2.value16()
	local value7 = t2.value7
	local v76 = t2.value6()
	local PlaceId = game.PlaceId or 0
	local v78 = JSONEncode(HttpService, {
		key = v70,
		userId = v72,
		hwid = v74,
		executor = value7,
		gameId = v76,
		placeId = tostring(PlaceId)
	})
	local RENDER = t2.value1[p22 or "RENDER"] or t2.value1.RENDER
	local v80 = RENDER == t2.value1.RENDER

	if v80 then
		v80 = t2.value1.SUPABASE
	end

	local RENDER2 = v80 or t2.value1.RENDER
	local t3 = { RENDER.Url, RENDER2.Url }
	local time = os.time
	local nocache = tostring(time()) .. "_" .. tostring(math.random(1000, 9999))
	local v85 = nil

	for _, v in ipairs(t3) do
		local u88 = nil
		local v89 = (v.find(v, "%?") and "&" or "?") .. "nocache=" .. nocache
		local v90 = nil

		local function v91()
			u88 = v68({
				Url = v90,
				Method = "POST",
				Headers = {
					["Content-Type"] = "application/json",
					["X-Auth-Security"] = "DoorsHubSecureClient-v1",
					["Cache-Control"] = "no-cache, no-store, must-revalidate",
					Pragma = "no-cache"
				},
				Body = v78,
				Timeout = 20
			})
		end

		v90 = v .. v89

		local ok = pcall(v91)

		if ok then
			ok = type(u88) == "table"

			if ok then
				ok = u88.StatusCode
			end
		end

		if ok then
			v85 = {
				statusCode = u88.StatusCode,
				data = t2.value19(u88),
				serverUsed = v
			}

			if u88.StatusCode == 200 or (u88.StatusCode == 403 or (u88.StatusCode == 429 or u88.StatusCode == 404)) then
				return v85
			end
		end
	end

	return v85
end

t2.value4 = false

function t2.value21(p23, p24, p25, p26)
	task.spawn(function()
		local code = p24

		if code then
			code = p24.code
		end

		local function v94()
			local v95 = p25

			if v95 then
				v95 = not t2.value4
			end

			if not v95 then
				return
			end

			t2.value4 = true

			local v96 = v57
			local v97 = (tick() - p25) * 10

			v96(math.floor(v97) / 10, "failed", p26 or t2.value1.RENDER.Url)
		end

		if not code or code == "" then
			return v94()
		end

		local v98 = code:gsub("^\u{FEFF}", ""):gsub("^%s+", "")
		local chunk = loadstring(v98)

		if not chunk then
			return v94()
		end

		local v101 = p25

		if v101 then
			v101 = not t2.value4
		end

		if v101 then
			t2.value4 = true

			local v102 = v57
			local v103 = (tick() - p25) * 10

			v102(math.floor(v103) / 10, "success", p26 or t2.value1.RENDER.Url)
		end

		local authNamespace = p24.authNamespace or "DOORS_SECURE_AUTH"
		local t4 = {
			Token = t2.value17(p23, t2.value5.UserId, authNamespace, 0),
			UserId = t2.value5.UserId,
			Key = p23
		}

		getgenv()._HUBHUBHUB_AUTH_DISPATCH = function()
			getgenv()._HUBHUBHUB_AUTH_DISPATCH = nil

			return t4
		end
		getgenv()._DOORS_AUTH_DISPATCH = function()
			getgenv()._DOORS_AUTH_DISPATCH = nil

			return t4
		end
		task.spawn(chunk)
	end)
end

(function()
	local makefolder_ = makefolder

	if makefolder_ then
		makefolder_ = isfolder

		if makefolder_ then
			makefolder_ = not isfolder(t2.value2.FOLDER)
		end
	end

	if makefolder_ then
		pcall(makefolder, t2.value2.FOLDER)
	end

	local v107 = t2.value2.FOLDER .. "/" .. t2.value2.FILE
	local s2 = "RENDER"

	task.spawn(function()
		local isfile_ = isfile

		if isfile_ then
			isfile_ = isfile(v107)

			if isfile_ then
				isfile_ = readfile
			end
		end

		if isfile_ then
			local function v110()
				return t2.value3.HttpService:JSONDecode(unpack_({ readfile(v107) }))
			end

			local ok, result = pcall(v110)
			local v113

			if ok then
				v113 = type(result) == "table"

				if v113 then
					v113 = result.savedKey == t2.value2.MASTER_KEY
				end
			else
				v113 = ok
			end

			if v113 then
				pcall(delfile, v107)
			else
				if ok then
					ok = type(result) == "table"

					if ok then
						ok = result.timestamp

						if ok then
							ok = result.savedKey

							if ok then
								ok = os.time() - result.timestamp < t2.value2.HOURS * 3600
							end
						end
					end
				end

				if ok then
					local now = tick()
					local v115 = t2.value20(result.savedKey, s2)
					local v116

					if v115 then
						v116 = v115.statusCode == 200

						if v116 then
							v116 = v115.data

							if v116 then
								v116 = v115.data.ok

								if v116 then
									v116 = v115.data.code
								end
							end
						end
					else
						v116 = v115
					end

					if v116 then
						t2.value21(result.savedKey, v115.data, now, v115.serverUsed)

						return
					end
				end
			end
		end

		local ScreenGui = t2.value12("ScreenGui", {
			Name = "HubKey_BW",
			Parent = t2.value11(),
			ResetOnSpawn = false
		})
		local Frame = t2.value12("Frame", {
			Size = UDim2.new(0, 390, 0, 320),
			Position = UDim2.new(0.5, 0, 0.5, 0),
			AnchorPoint = Vector2.new(0.5, 0.5),
			BackgroundColor3 = Color3.fromRGB(16, 16, 20),
			Parent = ScreenGui
		}, {
			t2.value13(12),
			t2.value14(Color3.fromRGB(50, 50, 65), 1.5),
			t2.value12("TextLabel", {
				Size = UDim2.new(1, 0, 0, 38),
				BackgroundTransparency = 1,
				Text = "HUB SYSTEM — KEY",
				TextColor3 = Color3.fromRGB(255, 255, 255),
				Font = Enum.Font.GothamBlack,
				TextSize = 15
			}),
			t2.value12("TextButton", {
				Name = "CloseKeyBtn",
				Size = UDim2.new(0, 26, 0, 26),
				Position = UDim2.new(1, -34, 0, 6),
				BackgroundColor3 = Color3.fromRGB(24, 24, 30),
				Text = "X",
				TextColor3 = Color3.fromRGB(200, 200, 210),
				Font = Enum.Font.GothamBold,
				TextSize = 12
			}, { t2.value13(6), t2.value14(Color3.fromRGB(45, 45, 55)) })
		})

		Frame.CloseKeyBtn.MouseButton1Click:Connect(function()
			ScreenGui:Destroy()
		end)
		t2.value15(Frame)

		local UIScale = t2.value12("UIScale", {
			Parent = Frame
		})

		local function v120()
			local CurrentCamera = workspace.CurrentCamera

			if CurrentCamera then
				local ViewportSize = CurrentCamera.ViewportSize
				local n2 = 410
				local n3 = 340
				local scale

				if ViewportSize.X < n2 and true or ViewportSize.Y < n3 then
					local v126 = ViewportSize.X / n2
					local v127 = ViewportSize.Y / n3

					scale = math.clamp(math.min(v126, v127) * 0.94, 0.55, 1)
				else
					scale = 1
				end

				UIScale.Scale = scale
			end
		end

		v120()

		local CurrentCamera = workspace.CurrentCamera

		if CurrentCamera then
			CurrentCamera:GetPropertyChangedSignal("ViewportSize"):Connect(v120)
		end

		local Frame2 = t2.value12("Frame", {
			Size = UDim2.new(0.88, 0, 0, 28),
			Position = UDim2.new(0.06, 0, 0.13, 0),
			BackgroundTransparency = 1,
			Parent = Frame
		}, { t2.value12("UIListLayout", {
				FillDirection = Enum.FillDirection.Horizontal,
				Padding = UDim.new(0.03, 0),
				SortOrder = Enum.SortOrder.LayoutOrder,
				HorizontalAlignment = Enum.HorizontalAlignment.Center
			}) })
		local TextButton = t2.value12("TextButton", {
			Size = UDim2.new(0.48, 0, 1, 0),
			BackgroundColor3 = Color3.fromRGB(240, 240, 245),
			Text = "Server 1",
			TextColor3 = Color3.fromRGB(16, 16, 20),
			Font = Enum.Font.GothamBold,
			TextSize = 10,
			Parent = Frame2
		}, { t2.value13(6), t2.value14(Color3.fromRGB(60, 60, 75), 1) })
		local TextButton2 = t2.value12("TextButton", {
			Size = UDim2.new(0.48, 0, 1, 0),
			BackgroundColor3 = Color3.fromRGB(24, 24, 30),
			Text = "Server 2 (Rec. for RU)",
			TextColor3 = Color3.fromRGB(160, 160, 175),
			Font = Enum.Font.GothamBold,
			TextSize = 10,
			Parent = Frame2
		}, { t2.value13(6), t2.value14(Color3.fromRGB(45, 45, 55), 1) })
		local v132 = nil

		local function v133()
			local v134 = s2 == "RENDER"
			local v135 = TextButton
			local color3

			if v134 then
				color3 = Color3.fromRGB(240, 240, 245)
			else
				color3 = v134
			end

			v135.BackgroundColor3 = color3 or Color3.fromRGB(24, 24, 30)

			local v137 = TextButton
			local color32

			if v134 then
				color32 = Color3.fromRGB(16, 16, 20)
			else
				color32 = v134
			end

			v137.TextColor3 = color32 or Color3.fromRGB(160, 160, 175)

			local v139 = v132
			local backgroundColor3 = not v134

			if backgroundColor3 then
				backgroundColor3 = Color3.fromRGB(240, 240, 245)
			end

			v139.BackgroundColor3 = backgroundColor3 or Color3.fromRGB(24, 24, 30)

			local v141 = v132
			local textColor3 = not v134

			if not textColor3 then
				v141.TextColor3 = textColor3 or Color3.fromRGB(160, 160, 175)

				return
			end

			textColor3 = Color3.fromRGB(16, 16, 20)
			v141.TextColor3 = textColor3 or Color3.fromRGB(160, 160, 175)
		end

		v132 = TextButton2
		TextButton.MouseButton1Click:Connect(function()
			s2 = "RENDER"
			v133()
		end)
		v132.MouseButton1Click:Connect(function()
			s2 = "SUPABASE"
			v133()
		end)

		local TextBox = t2.value12("TextBox", {
			Size = UDim2.new(0.88, 0, 0, 36),
			Position = UDim2.new(0.06, 0, 0.25, 0),
			BackgroundColor3 = Color3.fromRGB(24, 24, 30),
			Text = "",
			PlaceholderText = "Enter Key...",
			TextColor3 = Color3.fromRGB(255, 255, 255),
			PlaceholderColor3 = Color3.fromRGB(120, 120, 135),
			Font = Enum.Font.GothamBold,
			TextSize = 13,
			ClearTextOnFocus = false,
			Parent = Frame
		}, { t2.value13(8), t2.value14(Color3.fromRGB(45, 45, 55)) })
		local Frame3 = t2.value12("Frame", {
			Size = UDim2.new(0.88, 0, 0, 34),
			Position = UDim2.new(0.06, 0, 0.42, 0),
			BackgroundTransparency = 1,
			Parent = Frame
		}, { t2.value12("UIListLayout", {
				FillDirection = Enum.FillDirection.Horizontal,
				Padding = UDim.new(0.04, 0),
				SortOrder = Enum.SortOrder.LayoutOrder,
				HorizontalAlignment = Enum.HorizontalAlignment.Center
			}) })
		local Frame4 = t2.value12("Frame", {
			Size = UDim2.new(0.88, 0, 0, 34),
			Position = UDim2.new(0.06, 0, 0.58, 0),
			BackgroundTransparency = 1,
			Parent = Frame
		}, { t2.value12("UIListLayout", {
				FillDirection = Enum.FillDirection.Horizontal,
				Padding = UDim.new(0.04, 0),
				SortOrder = Enum.SortOrder.LayoutOrder,
				HorizontalAlignment = Enum.HorizontalAlignment.Center
			}) })

		t2.value12("TextLabel", {
			Size = UDim2.new(1, -20, 0, 16),
			Position = UDim2.new(0, 10, 1, -22),
			BackgroundTransparency = 1,
			Text = "⚡ Инжектор: " .. t2.value7,
			TextColor3 = Color3.fromRGB(110, 110, 130),
			Font = Enum.Font.GothamMedium,
			TextSize = 10,
			TextXAlignment = Enum.TextXAlignment.Center,
			Parent = Frame
		})

		local function v146(p27, p28, p29, p30, p31)
			local value12 = t2.value12
			local uDim2 = p31 or UDim2.new(0.48, 0, 1, 0)
			local color3

			if p30 then
				color3 = Color3.fromRGB(240, 240, 245)
			else
				color3 = p30
			end

			local color32 = color3 or Color3.fromRGB(28, 28, 36)

			if not p30 then
				v182 = value12("TextButton", {
					Size = uDim2,
					BackgroundColor3 = color32,
					Text = p28,
					TextColor3 = p30 or Color3.fromRGB(255, 255, 255),
					Font = Enum.Font.GothamBold,
					TextSize = 11,
					Parent = p27
				}, { t2.value13(8), t2.value14(Color3.fromRGB(50, 50, 65), 1) })
				v182.MouseButton1Click:Connect(p29)

				return v182
			end

			p30 = Color3.fromRGB(16, 16, 20)

			local TextButton3 = value12("TextButton", {
				Size = uDim2,
				BackgroundColor3 = color32,
				Text = p28,
				TextColor3 = p30 or Color3.fromRGB(255, 255, 255),
				Font = Enum.Font.GothamBold,
				TextSize = 11,
				Parent = p27
			}, { t2.value13(8), t2.value14(Color3.fromRGB(50, 50, 65), 1) })

			TextButton3.MouseButton1Click:Connect(p29)

			return TextButton3
		end

		v146(Frame3, "Get TG (6ч)", function()
			t2.value9(t2.value2.TG_LINK)
			TextBox.PlaceholderText = "TG link copied!"
			task.wait(1.5)
			TextBox.PlaceholderText = "Enter Key..."
		end, false)
		v146(Frame3, "Work.ink (24ч)", function()
			local WORKINK_GATEWAY = t2.value2.WORKINK_GATEWAY
			local UserId = t2.value5.UserId
			local v154 = WORKINK_GATEWAY .. tostring(UserId)

			t2.value9(v154)
			TextBox.PlaceholderText = "Work.ink link copied!"
			task.wait(1.5)
			TextBox.PlaceholderText = "Enter Key..."
		end, false)
		v146(Frame4, "Paste", function()
			local v155 = t2.value10()

			if v155 == "" then
				return
			end

			TextBox.Text = t2.value8(v155)
		end, false)

		local n4 = 0
		local n5 = 0

		v146(Frame4, "Activate", function()
			local now = tick()

			if now < n5 then
				local v159 = n5 - now

				TextBox.PlaceholderText = "Подождите " .. math.ceil(v159) .. " сек..."

				return
			end

			local v160 = t2.value8(TextBox.Text)

			if v160 == "" then
				return
			end

			if now - 0 > 12 then
				n4 = 0
			end

			n4 = n4 + 1

			if n4 >= 3 then
				n5 = now + 10
				TextBox.Text = ""
				task.spawn(function()
					for i = 10, 1, -1 do
						TextBox.PlaceholderText = "Спам! Ждите " .. i .. " сек..."
						task.wait(1)
					end

					TextBox.PlaceholderText = "Enter Key..."
				end)
			else
				TextBox.PlaceholderText = "Checking (max 20s)..."
				TextBox.Text = ""
				task.spawn(function()
					local now2 = tick()
					local v163 = t2.value20(v160, s2)
					local v164 = (tick() - now2) * 10
					local v165 = math.floor(v164) / 10
					local statusCode

					if v163 then
						statusCode = v163.statusCode
					else
						statusCode = v163
					end

					local data

					if v163 then
						data = v163.data
					else
						data = v163
					end

					local v168 = statusCode == 200

					if v168 then
						if data then
							v168 = data.ok

							if v168 then
								v168 = data.code
							end
						else
							v168 = data
						end
					end

					if v168 then
						local v169 = data.isMaster == true or v160 == t2.value2.MASTER_KEY
						local writefile_ = writefile

						if writefile_ then
							writefile_ = not v169
						end

						if writefile_ then
							local v171 = v160

							pcall(writefile, v107, t2.value3.HttpService:JSONEncode({
								timestamp = os.time(),
								savedKey = v171
							}))
						end

						ScreenGui:Destroy()
						t2.value21(v160, data, now2, v163.serverUsed)
					elseif statusCode == 429 then
						TextBox.PlaceholderText = "Слишком часто! Ждите..."
						task.wait(2)

						if not (n5 <= tick()) then
							local v172 = n5 <= tick()

							return
						end

						TextBox.PlaceholderText = "Enter Key..."
					elseif statusCode == 403 then
						local v173 = TextBox
						local s3 = "PlaceholderText"

						if data then
							data = data.message
						end

						v173[s3] = data or "Invalid or Expired Key!"
						task.wait(1.5)

						if not (n5 <= tick()) then
							local v175 = n5 <= tick()

							return
						end

						TextBox.PlaceholderText = "Enter Key..."
					elseif statusCode == 404 then
						TextBox.PlaceholderText = "Для этой игры скрипта нет"
						task.wait(2)

						if not (n5 <= tick()) then
							local v176 = n5 <= tick()

							return
						end

						TextBox.PlaceholderText = "Enter Key..."
					else
						task.spawn(function()
							v57(v165, "timeout_or_fail", t2.value1[s2].Url)
						end)
						TextBox.PlaceholderText = "Timeout / Error (" .. v165 .. "s)!"
						task.wait(2.5)

						if not (n5 <= tick()) then
							local v177 = n5 <= tick()

							return
						end

						TextBox.PlaceholderText = "Enter Key..."
					end

					local v178 = n5 <= tick()
				end)
			end
		end, true)
	end)
end)()
