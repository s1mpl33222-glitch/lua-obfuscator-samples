-- TYR SCRIPTS LOADER - OPERATION DOOM
-- Open-source router. Protected scripts still validate script_key again.


	local Players = game:GetService("Players")
	local HttpService = game:GetService("HttpService")
	local CoreGui = game:GetService("CoreGui")
	local localPlayer = Players.LocalPlayer
	local playerGui = localPlayer and localPlayer:WaitForChild("PlayerGui")
	local saveFolder = "Tyr Scripts"
	local saveFile = saveFolder .. "/luarmor_premium.key"
	local TYR_KEY_CHECK_SCRIPT_ID = "b13e6b4d8d5fdd59622f52c5a6bc3912"
	local TYR_KEY_CHECK_LIBRARY_URL = "https://sdkapi-public.luarmor.net/library.lua"
	local TYR_PREMIUM_SCRIPT_ID = "dc6bc47896ccf56f847dd04383016e7f"
	local TYR_FREE_SCRIPT_ID = "51f2550d27b3bdbbb34a8b3adf74e0e6"
	
		-- Used only by the pre-auth key checker so invalid keys do not let
	-- Luarmor continue and kick the player. This is the 32-char script id
	-- from the Luarmor loader URL / script page.
		
	local done = false

	local function safeGetGenv()
		local ok, env = pcall(function()
			return getgenv and getgenv() or nil
		end)
		if ok and type(env) == "table" then
			return env
		end
		return nil
	end

	local function getExistingScriptKey()
		local key
		pcall(function() key = rawget(_G, "script_key") end)
		if type(key) == "string" and key:gsub("%s+", "") ~= "" then return key end
		local env = safeGetGenv()
		if env then
			key = rawget(env, "script_key")
			if type(key) == "string" and key:gsub("%s+", "") ~= "" then return key end
		end
		pcall(function()
			local fenv = getfenv and getfenv() or nil
			if type(fenv) == "table" then key = rawget(fenv, "script_key") end
		end)
		if type(key) == "string" and key:gsub("%s+", "") ~= "" then return key end
		return nil
	end

	-- Always show the key GUI. Saved/existing keys only prefill the input;
	-- they do not auto-run or auto-validate on startup.
	pcall(function() _G.script_key = nil end)
	local envForReset = safeGetGenv()
	if envForReset then envForReset.script_key = nil end
	pcall(function() script_key = nil end)

	local function ensureSaveFolder()
		pcall(function()
			if type(makefolder) == "function" and (type(isfolder) ~= "function" or not isfolder(saveFolder)) then
				makefolder(saveFolder)
			end
		end)
	end

	local function saveKeyToDisk(key)
		ensureSaveFolder()
		pcall(function()
			if type(writefile) == "function" then
				writefile(saveFile, tostring(key or ""))
			end
		end)
	end

	local function loadKeyFromDisk()
		local key = ""
		pcall(function()
			if type(isfile) == "function" and type(readfile) == "function" and isfile(saveFile) then
				key = tostring(readfile(saveFile) or "")
			elseif type(listfiles) == "function" and type(isfolder) == "function" and isfolder(saveFolder) then
				for _, file in ipairs(listfiles(saveFolder)) do
					if tostring(file):sub(-4) == ".key" and type(readfile) == "function" then
						key = tostring(readfile(file) or "")
						break
					end
				end
			end
		end)
		return key
	end

	local function parentGui(gui)
		local parented = false
		pcall(function()
			if type(gethui) == "function" then
				gui.Parent = gethui()
				parented = true
			end
		end)
		if not parented then
			pcall(function()
				gui.Parent = CoreGui
				parented = true
			end)
		end
		if not parented and playerGui then
			gui.Parent = playerGui
		end
	end

	pcall(function()
		local old = playerGui and playerGui:FindFirstChild("TyrKeyGui")
		if old then old:Destroy() end
	end)
	pcall(function()
		local old = CoreGui:FindFirstChild("TyrKeyGui")
		if old then old:Destroy() end
	end)
	pcall(function()
		if type(gethui) == "function" then
			local old = gethui():FindFirstChild("TyrKeyGui")
			if old then old:Destroy() end
		end
	end)

	local keyGui = Instance.new("ScreenGui")
	keyGui.Name = "TyrKeyGui"
	keyGui.ResetOnSpawn = false
	keyGui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
	parentGui(keyGui)

	local frame = Instance.new("Frame")
	frame.Name = "Main"
	frame.Size = UDim2.new(0, 420, 0, 220)
	frame.Position = UDim2.new(0.5, -210, 0.5, -110)
	frame.BackgroundColor3 = Color3.fromRGB(12, 12, 16)
	frame.BackgroundTransparency = 0.02
	frame.BorderSizePixel = 0
	frame.Parent = keyGui

	local frameCorner = Instance.new("UICorner")
	frameCorner.CornerRadius = UDim.new(0, 14)
	frameCorner.Parent = frame

	local framePadding = Instance.new("UIPadding")
	framePadding.PaddingTop = UDim.new(0, 14)
	framePadding.PaddingBottom = UDim.new(0, 12)
	framePadding.PaddingLeft = UDim.new(0, 14)
	framePadding.PaddingRight = UDim.new(0, 14)
	framePadding.Parent = frame

	local titleLabel = Instance.new("TextLabel")
	titleLabel.Name = "Title"
	titleLabel.Position = UDim2.new(0, 0, 0, 0)
	titleLabel.Size = UDim2.new(0, 160, 0, 24)
	titleLabel.BackgroundTransparency = 1
	titleLabel.Text = "Tyr Scripts"
	titleLabel.TextColor3 = Color3.fromRGB(245, 245, 245)
	titleLabel.TextXAlignment = Enum.TextXAlignment.Left
	titleLabel.TextYAlignment = Enum.TextYAlignment.Center
	titleLabel.TextSize = 24
	titleLabel.Font = Enum.Font.GothamBold
	titleLabel.Parent = frame

	local subtitleLabel = Instance.new("TextLabel")
	subtitleLabel.Name = "Subtitle"
	subtitleLabel.Position = UDim2.new(0, 0, 0, 24)
	subtitleLabel.Size = UDim2.new(0, 180, 0, 18)
	subtitleLabel.BackgroundTransparency = 1
	subtitleLabel.Text = "Key Validation"
	subtitleLabel.TextColor3 = Color3.fromRGB(180, 180, 190)
	subtitleLabel.TextXAlignment = Enum.TextXAlignment.Left
	subtitleLabel.TextYAlignment = Enum.TextYAlignment.Center
	subtitleLabel.TextSize = 14
	subtitleLabel.Font = Enum.Font.Gotham
	subtitleLabel.Parent = frame

	local discordBtn = Instance.new("TextButton")
	discordBtn.Name = "DiscordButton"
	discordBtn.AnchorPoint = Vector2.new(1, 0)
	discordBtn.Position = UDim2.new(1, 0, 0, 2)
	discordBtn.Size = UDim2.new(0, 34, 0, 34)
	discordBtn.BackgroundColor3 = Color3.fromRGB(34, 34, 40)
	discordBtn.BackgroundTransparency = 0.08
	discordBtn.BorderSizePixel = 0
	discordBtn.Text = "?"
	discordBtn.TextColor3 = Color3.fromRGB(235, 235, 235)
	discordBtn.TextSize = 18
	discordBtn.Font = Enum.Font.GothamBold
	discordBtn.Parent = frame

	local discordBtnCorner = Instance.new("UICorner")
	discordBtnCorner.CornerRadius = UDim.new(1, 0)
	discordBtnCorner.Parent = discordBtn

	local discordHint = Instance.new("TextLabel")
	discordHint.Name = "DiscordHint"
	discordHint.AnchorPoint = Vector2.new(1, 0)
	discordHint.Position = UDim2.new(1, -42, 0, 7)
	discordHint.Size = UDim2.new(0, 120, 0, 24)
	discordHint.BackgroundColor3 = Color3.fromRGB(30, 30, 36)
	discordHint.BackgroundTransparency = 0.05
	discordHint.BorderSizePixel = 0
	discordHint.Visible = false
	discordHint.Text = "Copy Discord"
	discordHint.TextColor3 = Color3.fromRGB(235, 235, 235)
	discordHint.TextSize = 13
	discordHint.Font = Enum.Font.Gotham
	discordHint.Parent = frame

	local discordHintCorner = Instance.new("UICorner")
	discordHintCorner.CornerRadius = UDim.new(0, 8)
	discordHintCorner.Parent = discordHint

	local keyInput = Instance.new("TextBox")
	keyInput.Name = "KeyBox"
	keyInput.Position = UDim2.new(0, 0, 0, 60)
	keyInput.Size = UDim2.new(1, 0, 0, 40)
	keyInput.BackgroundColor3 = Color3.fromRGB(28, 28, 34)
	keyInput.BackgroundTransparency = 0.06
	keyInput.BorderSizePixel = 0
	keyInput.ClearTextOnFocus = false
	keyInput.PlaceholderText = "Enter Key"
	keyInput.Text = loadKeyFromDisk()
	keyInput.TextColor3 = Color3.fromRGB(245, 245, 245)
	keyInput.PlaceholderColor3 = Color3.fromRGB(130, 130, 140)
	keyInput.TextXAlignment = Enum.TextXAlignment.Left
	keyInput.TextYAlignment = Enum.TextYAlignment.Center
	keyInput.TextTruncate = Enum.TextTruncate.AtEnd
	keyInput.ClipsDescendants = true
	keyInput.Font = Enum.Font.Gotham
	keyInput.TextSize = 17
	keyInput.Parent = frame

	local keyInputCorner = Instance.new("UICorner")
	keyInputCorner.CornerRadius = UDim.new(0, 10)
	keyInputCorner.Parent = keyInput

	local keyInputPadding = Instance.new("UIPadding")
	keyInputPadding.PaddingLeft = UDim.new(0, 12)
	keyInputPadding.PaddingRight = UDim.new(0, 12)
	keyInputPadding.Parent = keyInput

	local statusLabel = Instance.new("TextLabel")
	statusLabel.Name = "Status"
	statusLabel.Position = UDim2.new(0, 0, 0, 112)
	statusLabel.Size = UDim2.new(1, 0, 0, 20)
	statusLabel.BackgroundTransparency = 1
	statusLabel.Text = ""
	statusLabel.TextColor3 = Color3.fromRGB(210, 210, 215)
	statusLabel.TextSize = 15
	statusLabel.Font = Enum.Font.Gotham
	statusLabel.TextXAlignment = Enum.TextXAlignment.Left
	statusLabel.TextYAlignment = Enum.TextYAlignment.Center
	statusLabel.TextTruncate = Enum.TextTruncate.AtEnd
	statusLabel.ClipsDescendants = true
	statusLabel.Parent = frame

	local btnRow = Instance.new("Frame")
	btnRow.Name = "ButtonHolder"
	btnRow.Position = UDim2.new(0, 0, 1, -44)
	btnRow.Size = UDim2.new(1, 0, 0, 36)
	btnRow.BackgroundTransparency = 1
	btnRow.Parent = frame

	local btnLayout = Instance.new("UIListLayout")
	btnLayout.FillDirection = Enum.FillDirection.Horizontal
	btnLayout.HorizontalAlignment = Enum.HorizontalAlignment.Center
	btnLayout.VerticalAlignment = Enum.VerticalAlignment.Center
	btnLayout.Padding = UDim.new(0, 10)
	btnLayout.Parent = btnRow

	local function makeKeyGuiButton(text, width, bg, fg)
		local btn = Instance.new("TextButton")
		btn.Size = UDim2.new(0, width, 1, 0)
		btn.BackgroundColor3 = bg
		btn.BackgroundTransparency = 0.03
		btn.BorderSizePixel = 0
		btn.Text = text
		btn.TextColor3 = fg
		btn.Font = Enum.Font.GothamBold
		btn.TextSize = 16
		btn.AutoButtonColor = true
		btn.Parent = btnRow
		local c = Instance.new("UICorner")
		c.CornerRadius = UDim.new(0, 10)
		c.Parent = btn
		return btn
	end

	local exitBtn = makeKeyGuiButton("Exit", 86, Color3.fromRGB(38, 38, 44), Color3.fromRGB(245, 245, 245))
	local getKeyBtn = makeKeyGuiButton("Get Key", 110, Color3.fromRGB(38, 38, 44), Color3.fromRGB(245, 245, 245))
	local enterBtn = makeKeyGuiButton("Enter", 110, Color3.fromRGB(150, 150, 160), Color3.fromRGB(255, 255, 255))

	local function setStatus(msg, color)
		statusLabel.Text = msg or ""
		statusLabel.TextColor3 = color or Color3.fromRGB(210, 210, 215)
	end

	local function copyText(text)
		if type(setclipboard) == "function" then
			setclipboard(text)
			return true
		end
		return false
	end

	local keyCheckBusy = false

	local function noteIsPremium(note)
		note = tostring(note or ""):lower()
		return note:match("^%s*premium%s*%-") ~= nil
	end

	local function loadKeyApi()
		local chunk, loadErr = loadstring(game:HttpGet(TYR_KEY_CHECK_LIBRARY_URL))
		if not chunk then return nil, "Key checker compile failed: " .. tostring(loadErr) end
		local ok, api = pcall(chunk)
		if not ok or type(api) ~= "table" then return nil, "Key checker failed to load" end
		api.script_id = TYR_KEY_CHECK_SCRIPT_ID
		return api
	end

	local function setScriptKeyGlobals(key)
		script_key = key
		pcall(function() _G.script_key = key end)
		local env = safeGetGenv()
		if env then env.script_key = key end
	end

	local function loadRoutedScript(api, scriptId)
		api.script_id = scriptId
		api.load_script()
	end

	local function submitKey()
		if keyCheckBusy then return end
		local key = tostring(keyInput.Text or ""):gsub("^%s+", ""):gsub("%s+$", "")
		if key == "" then
			setStatus("Please enter a key.", Color3.fromRGB(255,185,120))
			return
		end
	
		keyCheckBusy = true
		setStatus("Checking key...", Color3.fromRGB(140,225,150))

		local api, apiErr = loadKeyApi()
		if not api then
			setStatus(apiErr or "Key checker failed.", Color3.fromRGB(255,130,130))
			keyCheckBusy = false
			return
		end

		local ok, status = pcall(function()
			return api.check_key(key)
		end)
		if not ok or type(status) ~= "table" then
			setStatus("Key check failed.", Color3.fromRGB(255,130,130))
			keyCheckBusy = false
			return
		end
		if status.code ~= "KEY_VALID" then
			setStatus(tostring(status.message or status.code or "Key is invalid."), Color3.fromRGB(255,130,130))
			keyCheckBusy = false
			return
		end
	
		local tier = noteIsPremium(status.data and status.data.note) and "premium" or "free"
		local targetScriptId = (tier == "premium") and TYR_PREMIUM_SCRIPT_ID or TYR_FREE_SCRIPT_ID
		saveKeyToDisk(key)
		setScriptKeyGlobals(key)
		setStatus("Loading " .. tier .. " script...", Color3.fromRGB(140,225,150))
		task.wait(0.25)
	
		done = true
		pcall(function()
			keyGui:Destroy()
		end)
	
		loadRoutedScript(api, targetScriptId)
	end

exitBtn.MouseButton1Click:Connect(function()
	done = true
	pcall(function() keyGui:Destroy() end)
end)

	getKeyBtn.MouseButton1Click:Connect(function()
		local url = "https://ads.luarmor.net/get_key?for=Tyr_Scripts-lgYCBLmYNbSY"
		if copyText(url) then
			setStatus("Key URL copied to clipboard.", Color3.fromRGB(140, 225, 150))
		else
			setStatus("Clipboard not supported.", Color3.fromRGB(255, 130, 130))
		end
	end)

	discordBtn.MouseEnter:Connect(function() discordHint.Visible = true end)
	discordBtn.MouseLeave:Connect(function() discordHint.Visible = false end)
	discordBtn.MouseButton1Click:Connect(function()
		local invite = "https://discord.gg/H4zksyN8A"
		if copyText(invite) then
			setStatus("Discord invite copied to clipboard.", Color3.fromRGB(140, 225, 150))
		else
			setStatus("Clipboard not supported.", Color3.fromRGB(255, 130, 130))
		end
	end)

	enterBtn.MouseButton1Click:Connect(function() submitKey() end)
	keyInput.FocusLost:Connect(function(entered)
		if entered then submitKey() end
	end)
	pcall(function() keyInput:CaptureFocus() end)

	while not done do
		if task and task.wait then
			task.wait(0.05)
		else
			wait(0.05)
		end
	end
