local function getService(name)
	local svc = game:GetService(name)
	return cloneref and cloneref(svc) or svc
end

local function callSafely(func, ...)
	if type(func) ~= "function" then return nil end
	local ok, result = pcall(func, ...)
	if not ok then return nil end
	return result
end

local Players          = getService("Players")
local HttpService      = getService("HttpService")
local CoreGui          = getService("CoreGui")
local UserInputService = getService("UserInputService")

local SCRIPT_ID    = "sid_2j8441zuhmqe"
local API_BASE     = "https://developer.sirius.menu"
local GATE_URL     = "https://gate.sirius.menu"
local CACHE_FILE   = "SiriusGateway/" .. SCRIPT_ID .. ".key"

local function sha256(msg)
	local band, bxor, bnot = bit32.band, bit32.bxor, bit32.bnot
	local rshift, lshift, rrotate = bit32.rshift, bit32.lshift, bit32.rrotate
	local K = {
		0x428a2f98, 0x71374491, 0xb5c0fbcf, 0xe9b5dba5,
		0x3956c25b, 0x59f111f1, 0x923f82a4, 0xab1c5ed5,
		0xd807aa98, 0x12835b01, 0x243185be, 0x550c7dc3,
		0x72be5d74, 0x80deb1fe, 0x9bdc06a7, 0xc19bf174,
		0xe49b69c1, 0xefbe4786, 0x0fc19dc6, 0x240ca1cc,
		0x2de92c6f, 0x4a7484aa, 0x5cb0a9dc, 0x76f988da,
		0x983e5152, 0xa831c66d, 0xb00327c8, 0xbf597fc7,
		0xc6e00bf3, 0xd5a79147, 0x06ca6351, 0x14292967,
		0x27b70a85, 0x2e1b2138, 0x4d2c6dfc, 0x53380d13,
		0x650a7354, 0x766a0abb, 0x81c2c92e, 0x92722c85,
		0xa2bfe8a1, 0xa81a664b, 0xc24b8b70, 0xc76c51a3,
		0xd192e819, 0xd6990624, 0xf40e3585, 0x106aa070,
		0x19a4c116, 0x1e376c08, 0x2748774c, 0x34b0bcb5,
		0x391c0cb3, 0x4ed8aa4a, 0x5b9cca4f, 0x682e6ff3,
		0x748f82ee, 0x78a5636f, 0x84c87814, 0x8cc70208,
		0x90befffa, 0xa4506ceb, 0xbef9a3f7, 0xc67178f2,
	}
	local function preprocess(m)
		local len = #m
		local bits = len * 8
		m = m .. "\128"
		while (#m % 64) ~= 56 do m = m .. "\0" end
		m = m .. string.char(0, 0, 0, 0, band(rshift(bits, 24), 0xFF), band(rshift(bits, 16), 0xFF), band(rshift(bits, 8), 0xFF), band(bits, 0xFF))
		return m
	end
	msg = preprocess(msg)
	local h0, h1, h2, h3 = 0x6a09e667, 0xbb67ae85, 0x3c6ef372, 0xa54ff53a
	local h4, h5, h6, h7 = 0x510e527f, 0x9b05688c, 0x1f83d9ab, 0x5be0cd19
	for i = 1, #msg, 64 do
		local w = {}
		for j = 1, 16 do
			local off = i + (j - 1) * 4
			w[j] = lshift(string.byte(msg, off), 24) + lshift(string.byte(msg, off+1), 16) + lshift(string.byte(msg, off+2), 8) + string.byte(msg, off+3)
		end
		for j = 17, 64 do
			local s0 = bxor(rrotate(w[j-15], 7), rrotate(w[j-15], 18), rshift(w[j-15], 3))
			local s1 = bxor(rrotate(w[j-2], 17), rrotate(w[j-2], 19), rshift(w[j-2], 10))
			w[j] = band(w[j-16] + s0 + w[j-7] + s1, 0xFFFFFFFF)
		end
		local a, b, c, d, e, f, g, h = h0, h1, h2, h3, h4, h5, h6, h7
		for j = 1, 64 do
			local S1 = bxor(rrotate(e, 6), rrotate(e, 11), rrotate(e, 25))
			local ch = bxor(band(e, f), band(bnot(e), g))
			local t1 = band(h + S1 + ch + K[j] + w[j], 0xFFFFFFFF)
			local S0 = bxor(rrotate(a, 2), rrotate(a, 13), rrotate(a, 22))
			local maj = bxor(band(a, b), band(a, c), band(b, c))
			local t2 = band(S0 + maj, 0xFFFFFFFF)
			h, g, f, e, d, c, b, a = g, f, e, band(d + t1, 0xFFFFFFFF), c, b, a, band(t1 + t2, 0xFFFFFFFF)
		end
		h0 = band(h0 + a, 0xFFFFFFFF); h1 = band(h1 + b, 0xFFFFFFFF)
		h2 = band(h2 + c, 0xFFFFFFFF); h3 = band(h3 + d, 0xFFFFFFFF)
		h4 = band(h4 + e, 0xFFFFFFFF); h5 = band(h5 + f, 0xFFFFFFFF)
		h6 = band(h6 + g, 0xFFFFFFFF); h7 = band(h7 + h, 0xFFFFFFFF)
	end
	return string.format("%08x%08x%08x%08x%08x%08x%08x%08x", h0, h1, h2, h3, h4, h5, h6, h7)
end

local httpRequest = (syn and syn.request)
	or (fluxus and fluxus.request)
	or (http and http.request)
	or http_request
	or request

if not httpRequest then warn("[Sirius Gateway] No HTTP request function found") return end

local hasFilesystem = type(writefile) == "function"
	and type(readfile) == "function"
	and type(isfile) == "function"
	and type(isfolder) == "function"
	and type(makefolder) == "function"

local function ensureFolder(path)
	if not hasFilesystem then return end
	if not callSafely(isfolder, path) then
		callSafely(makefolder, path)
	end
end

local function readCachedKey()
	if not hasFilesystem then return nil end
	if not callSafely(isfile, CACHE_FILE) then return nil end
	local data = callSafely(readfile, CACHE_FILE)
	if type(data) ~= "string" or #data == 0 then return nil end
	local pipe = string.find(data, "|", 1, true)
	if pipe then return string.sub(data, 1, pipe - 1) end
	return data
end

local function cacheKey(key)
	if not hasFilesystem then return end
	ensureFolder("SiriusGateway")
	callSafely(writefile, CACHE_FILE, key)
end

local function clearCachedKey()
	if not hasFilesystem then return end
	if not callSafely(isfile, CACHE_FILE) then return end
	if type(delfile) == "function" then
		callSafely(delfile, CACHE_FILE)
	else
		-- delfile isn't in the hasFilesystem probe and some executors omit it.
		-- Overwrite with empty instead — readCachedKey treats a 0-length file as
		-- nil, so a rejected/expired key can't get stuck on disk and re-fail forever.
		callSafely(writefile, CACHE_FILE, "")
	end
end

local function getUserHash()
	local ok, uid = pcall(function() return Players.LocalPlayer.UserId end)
	if ok and uid and uid ~= 0 then return sha256("sirius_analytics:" .. tostring(uid)) end
	return nil
end

local function validateKey(key, userHash)
	local ok, response = pcall(function()
		return httpRequest({
			Url = API_BASE .. "/api/keys/validate",
			Method = "POST",
			Headers = { ["Content-Type"] = "application/json" },
			Body = HttpService:JSONEncode({ key = key, user_hash = userHash, script_id = SCRIPT_ID }),
		})
	end)
	if not ok or not response then return nil, "Network error" end
	local decodeOk, data = pcall(function() return HttpService:JSONDecode(response.Body) end)
	if not decodeOk or not data then return nil, "Invalid response" end
	return data, nil
end

local function createKeyUI(callback)
	local keySystem = Instance.new("ScreenGui")
	keySystem.Name = "SiriusGateway"
	keySystem.Parent = gethui and gethui() or CoreGui
	keySystem.ResetOnSpawn = false
	keySystem.ScreenInsets = Enum.ScreenInsets.DeviceSafeInsets
	keySystem.ZIndexBehavior = Enum.ZIndexBehavior.Sibling

	local frame = Instance.new("Frame")
	frame.Name = "Frame"
	frame.AnchorPoint = Vector2.new(0.5, 0.5)
	frame.BackgroundColor3 = Color3.new(1, 1, 1)
	frame.BorderSizePixel = 0
	frame.Position = UDim2.fromScale(0.5, 0.5)
	frame.Size = UDim2.fromOffset(300, 160)

	local frameCorner = Instance.new("UICorner")
	frameCorner.CornerRadius = UDim.new(0, 15)
	frameCorner.Parent = frame

	local frameGradient = Instance.new("UIGradient")
	frameGradient.Color = ColorSequence.new({
		ColorSequenceKeypoint.new(0, Color3.fromRGB(45, 140, 203)),
		ColorSequenceKeypoint.new(1, Color3.new()),
	})
	frameGradient.Offset = Vector2.new(0, -0.7)
	frameGradient.Rotation = 45
	frameGradient.Parent = frame

	local frameStroke = Instance.new("UIStroke")
	frameStroke.BorderStrokePosition = Enum.BorderStrokePosition.Center
	frameStroke.Color = Color3.new(1, 1, 1)
	local strokeGradient = Instance.new("UIGradient")
	strokeGradient.Color = ColorSequence.new({
		ColorSequenceKeypoint.new(0, Color3.fromRGB(104, 191, 255)),
		ColorSequenceKeypoint.new(1, Color3.new()),
	})
	strokeGradient.Offset = Vector2.new(0, -0.7)
	strokeGradient.Rotation = 45
	strokeGradient.Parent = frameStroke
	frameStroke.Parent = frame

	local title = Instance.new("TextLabel")
	title.AnchorPoint = Vector2.new(0.5, 0)
	title.BackgroundTransparency = 1
	title.FontFace = Font.new("rbxassetid://12187365364", Enum.FontWeight.SemiBold, Enum.FontStyle.Normal)
	title.Position = UDim2.new(0.5, 0, 0, 20)
	title.Size = UDim2.new(1, -40, 0, 18)
	title.Text = "Key System"
	title.TextColor3 = Color3.new(1, 1, 1)
	title.TextSize = 18
	title.TextXAlignment = Enum.TextXAlignment.Left
	title.Parent = frame

	local subtitle = Instance.new("TextLabel")
	subtitle.AnchorPoint = Vector2.new(0.5, 0)
	subtitle.BackgroundTransparency = 1
	subtitle.FontFace = Font.new("rbxassetid://12187365364", Enum.FontWeight.Medium, Enum.FontStyle.Normal)
	subtitle.Position = UDim2.new(0.5, 0, 0, 41)
	subtitle.Size = UDim2.new(1, -40, 0, 12)
	subtitle.Text = "Enter your key below to proceed."
	subtitle.TextColor3 = Color3.new(1, 1, 1)
	subtitle.TextSize = 12
	subtitle.TextTransparency = 0.5
	subtitle.TextXAlignment = Enum.TextXAlignment.Left
	subtitle.Parent = frame

	local defaultSubtitle = subtitle.Text
	local function setError(msg)
		subtitle.Text = msg
		subtitle.TextColor3 = Color3.fromRGB(255, 120, 120)
		subtitle.TextTransparency = 0
	end
	local function clearError()
		subtitle.Text = defaultSubtitle
		subtitle.TextColor3 = Color3.new(1, 1, 1)
		subtitle.TextTransparency = 0.5
	end

	local inputFrame = Instance.new("Frame")
	inputFrame.AnchorPoint = Vector2.new(0, 0.5)
	inputFrame.BackgroundColor3 = Color3.new(1, 1, 1)
	inputFrame.BackgroundTransparency = 0.9
	inputFrame.BorderSizePixel = 0
	inputFrame.Position = UDim2.new(0, 20, 0.5, 5)
	inputFrame.Size = UDim2.new(1, -40, 0, 35)

	local inputCorner = Instance.new("UICorner")
	inputCorner.CornerRadius = UDim.new(1, 0)
	inputCorner.Parent = inputFrame

	local inputStroke = Instance.new("UIStroke")
	inputStroke.BorderStrokePosition = Enum.BorderStrokePosition.Center
	inputStroke.Color = Color3.new(1, 1, 1)
	inputStroke.Transparency = 0.9
	inputStroke.Parent = inputFrame

	local input = Instance.new("TextBox")
	input.AnchorPoint = Vector2.new(0.5, 0.5)
	input.BackgroundTransparency = 1
	input.ClearTextOnFocus = false
	input.FontFace = Font.new("rbxassetid://12187365364", Enum.FontWeight.Medium, Enum.FontStyle.Normal)
	input.PlaceholderColor3 = Color3.fromRGB(200, 200, 200)
	input.PlaceholderText = "sk_..."
	input.Position = UDim2.fromScale(0.5, 0.5)
	input.Size = UDim2.new(1, -24, 1, 0)
	input.Text = ""
	input.TextColor3 = Color3.fromRGB(250, 250, 250)
	input.TextSize = 14
	input.TextXAlignment = Enum.TextXAlignment.Left
	input.Parent = inputFrame
	inputFrame.Parent = frame

	local buttonRow = Instance.new("Frame")
	buttonRow.AnchorPoint = Vector2.new(1, 1)
	buttonRow.BackgroundTransparency = 1
	buttonRow.Position = UDim2.new(1, -10, 1, -10)
	buttonRow.Size = UDim2.new(1, -20, 0, 34)

	local listLayout = Instance.new("UIListLayout")
	listLayout.FillDirection = Enum.FillDirection.Horizontal
	listLayout.HorizontalAlignment = Enum.HorizontalAlignment.Right
	listLayout.Padding = UDim.new(0, 5)
	listLayout.SortOrder = Enum.SortOrder.LayoutOrder
	listLayout.VerticalAlignment = Enum.VerticalAlignment.Center
	listLayout.Parent = buttonRow

	local getKey = Instance.new("TextButton")
	getKey.AutomaticSize = Enum.AutomaticSize.X
	getKey.BackgroundTransparency = 1
	getKey.FontFace = Font.new("rbxassetid://12187365364")
	getKey.Size = UDim2.fromOffset(50, 16)
	getKey.Text = "Get Key"
	getKey.TextColor3 = Color3.new(1, 1, 1)
	getKey.TextSize = 13
	getKey.TextTransparency = 0.2
	getKey.AutoButtonColor = false
	getKey.Parent = buttonRow

	local submit = Instance.new("TextButton")
	submit.AutoButtonColor = false
	submit.BackgroundColor3 = Color3.new(1, 1, 1)
	submit.BackgroundTransparency = 0.9
	submit.FontFace = Font.new("rbxassetid://12187365364", Enum.FontWeight.Medium, Enum.FontStyle.Normal)
	submit.LayoutOrder = 1
	submit.Size = UDim2.fromOffset(80, 34)
	submit.Text = "Submit"
	submit.TextColor3 = Color3.new(1, 1, 1)
	submit.TextSize = 15

	local submitCorner = Instance.new("UICorner")
	submitCorner.CornerRadius = UDim.new(1, 0)
	submitCorner.Parent = submit

	local submitStroke = Instance.new("UIStroke")
	submitStroke.ApplyStrokeMode = Enum.ApplyStrokeMode.Border
	submitStroke.BorderStrokePosition = Enum.BorderStrokePosition.Center
	submitStroke.Color = Color3.new(1, 1, 1)
	submitStroke.Transparency = 0.9
	submitStroke.Parent = submit
	submit.Parent = buttonRow
	buttonRow.Parent = frame

	frame.Parent = keySystem

	local submitting = false
	submit.MouseButton1Click:Connect(function()
		if submitting then return end
		local key = input.Text:gsub("%s+", "")
		if key == "" then setError("Please enter a key") return end
		submitting = true
		submit.Text = "Validating..."
		submit.BackgroundTransparency = 0.8
		clearError()
		callback(key, setError, function()
			submitting = false
			submit.Text = "Submit"
			submit.BackgroundTransparency = 0.9
		end, keySystem)
	end)

	getKey.MouseButton1Click:Connect(function()
		callSafely(setclipboard, GATE_URL .. "/" .. SCRIPT_ID)
		getKey.Text = "Copied!"
		task.delay(2, function() pcall(function() getKey.Text = "Get Key" end) end)
	end)

	local dragging, dragInput, dragStart, startPos
	frame.InputBegan:Connect(function(inp)
		if inp.UserInputType == Enum.UserInputType.MouseButton1 or inp.UserInputType == Enum.UserInputType.Touch then
			dragging = true
			dragStart = inp.Position
			startPos = frame.Position
			inp.Changed:Connect(function()
				if inp.UserInputState == Enum.UserInputState.End then dragging = false end
			end)
		end
	end)
	frame.InputChanged:Connect(function(inp)
		if inp.UserInputType == Enum.UserInputType.MouseMovement or inp.UserInputType == Enum.UserInputType.Touch then
			dragInput = inp
		end
	end)
	UserInputService.InputChanged:Connect(function(inp)
		if inp == dragInput and dragging then
			local delta = inp.Position - dragStart
			frame.Position = UDim2.new(startPos.X.Scale, startPos.X.Offset + delta.X, startPos.Y.Scale, startPos.Y.Offset + delta.Y)
		end
	end)

	return keySystem
end

local userHash = getUserHash()

-- Expose per-request values to the loadstring'd script so the Enhanced
-- Protection bootstrap (compiled into the obfuscated bundle) can read them.
-- Patching getgenv() to lie doesn't help the attacker: fake values cause
-- the heartbeat to fail/401, which kicks them anyway.
local function exposeSiriusContext(key)
	if not getgenv then return end
	local g = getgenv()
	g.Sirius = g.Sirius or {}
	g.Sirius._Key = key
	g.Sirius._UserHash = userHash
	g.Sirius._ScriptId = SCRIPT_ID
end

-- Opt-in analytics injection. Server-side, validate.ts returns
-- result.analytics_inject = true ONLY when the project owner's
-- gateway_analytics_enabled flag is set (default 0, owner-toggleable
-- in the admin panel). For every other request — i.e. the vast
-- majority — this is a no-op and the gateway behaves identically to
-- pre-feature production.
--
-- When enabled, we loadstring the same Rayfield reporter that
-- Rayfield itself uses (no separate "lite" build), fire
-- window_created tagged with the script_id, and set
-- __SIRIUS_GATEWAY_INJECT_FIRED so a Rayfield-bundled user script
-- doesn't double-fire from inside its own loadstring. pcall'd so a
-- reporter exception never breaks the user's script.
local REPORTER_URL = "https://raw.githubusercontent.com/SiriusSoftwareLtd/Rayfield/refs/heads/main/reporter.lua"

local function tryInjectAnalytics(result)
	if not result or not result.analytics_inject then return end
	-- The product token rides on the signed validate response (the server only
	-- includes it when the owner opted in) — it's never embedded in this shell.
	local token = result.analytics_token
	if type(token) ~= "string" or token == "" then return end
	-- Set the dedup marker FIRST, unconditionally, BEFORE we touch the
	-- network or loadstring the reporter. The intent of the marker is
	-- "the gateway took responsibility for window_created on this
	-- execution" — if anything below fails (network drop, loadstring
	-- failure, reporter raises), the user's bundled Rayfield must still
	-- skip its own windowCreated. Otherwise a partial failure produces a
	-- double-fire attributed to the wrong product token.
	if getgenv then getgenv().__SIRIUS_GATEWAY_INJECT_FIRED = true end
	pcall(function()
		local fetchOk, fetchResult = pcall(function()
			return game:HttpGet(REPORTER_URL)
		end)
		if not fetchOk or type(fetchResult) ~= "string" or #fetchResult == 0 then return end
		local fn, loadErr = loadstring(fetchResult)
		if not fn then warn("[Sirius Gateway] reporter load error:", loadErr) return end
		local Analytics = fn()
		if type(Analytics) ~= "table" or type(Analytics.new) ~= "function" then return end
		local reporter = Analytics.new({
			url          = "https://rayfield-collect.sirius-software-ltd.workers.dev",
			token        = token,
			product_name = "sirius-gateway",
			category     = "Script",
		})
		-- has_key_system is derived from the validate result: keyless projects
		-- get false, every other path (cached key, keyed UI flow) gets true.
		-- Hardcoding false was corrupting double1 in AE for every key-gated
		-- script that went through the gateway-injected reporter path.
		reporter:windowCreated({
			script_id         = SCRIPT_ID,
			interface_version = "sirius-gateway-v1",
			has_key_system    = not result.keyless,
		})
	end)
end

local function executeSource(result)
	tryInjectAnalytics(result)
	local fn, loadErr = loadstring(result.source)
	if fn then fn() else warn("[Sirius Gateway] Script load error:", loadErr) end
end

local cachedKey = readCachedKey()
if cachedKey then
	local result = validateKey(cachedKey, userHash)
	if result and result.valid and result.source then
		exposeSiriusContext(cachedKey)
		executeSource(result)
		return
	end
	-- Maintenance is a TEMPORARY server state (validate returns
	-- {valid=false, maintenance=true}), NOT a key rejection. Keep the cached key
	-- so the user isn't forced back through the ad gate once maintenance lifts,
	-- and stop here rather than showing the key UI.
	if result and result.maintenance then
		warn("[Sirius Gateway] " .. (result.message or "Script is under maintenance"))
		return
	end
	-- Only drop the cached key when the SERVER explicitly rejected it (invalid/
	-- expired/revoked). A nil result means a transient network error (validateKey
	-- returns nil,err) — wiping the key there would force a valid user back
	-- through the whole ad-gate flow over a momentary blip.
	if result and result.valid == false then
		clearCachedKey()
	end
end

-- Keyless probe: if the dev has the key system disabled, the server returns
-- the source directly without needing a key. Avoids showing the key UI for
-- projects where no key is required.
do
	local result = validateKey("", userHash)
	if result and result.valid and result.keyless and result.source then
		-- Keyless = no per-user key context. The bootstrap (if it was compiled
		-- in) sees nil _Key, returns early, no-op. Intentional.
		exposeSiriusContext(nil)
		executeSource(result)
		return
	end
end

createKeyUI(function(key, setError, resetUI, gui)
	local result, err = validateKey(key, userHash)
	if not result then setError(err or "Network error") resetUI() return end
	if result.maintenance then setError(result.message or "Script is under maintenance") resetUI() return end if not result.valid then setError(result.error or "Invalid key") resetUI() return end
	if not result.source then setError("No script uploaded for this project") resetUI() return end
	cacheKey(key)
	pcall(function() gui:Destroy() end)
	exposeSiriusContext(key)
	executeSource(result)
end)
