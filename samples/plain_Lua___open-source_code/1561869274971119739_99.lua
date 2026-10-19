--[[
	WARNING: Heads up! This script has not been verified by ScriptBlox. Use at your own risk!
]]
-- ===== X8 KEY SYSTEM (copied from script 1) =====
-- The key must be activated before the 99 Nights script continues.
do
    	local X8_API = "https://api.x8stuff.lol"
    	local X8_GAME_ID = tostring(game.GameId)
    	local X8_HTTP_SERVICE = game:GetService("HttpService")
    	local X8_PLAYERS = game:GetService("Players")
    	local X8_LOCAL_PLAYER = X8_PLAYERS.LocalPlayer
    	local X8_HTTP = syn and syn.request or http and http.request or http_request or request
    	local X8_KEY_SESSION = nil
    	local X8_KEY_OK = false
    	local X8_CACHE_FILE = "x8_99nights_key.json"
    	local X8_CACHE_TTL = 24 * 60 * 60

    	local function x8LoadCachedKey()
    		if type(isfile) ~= "function" or type(readfile) ~= "function" then
    			return nil
    		end
    		local ok, raw = pcall(readfile, X8_CACHE_FILE)
    		if not ok or type(raw) ~= "string" or raw == "" then
    			return nil
    		end
    		local data
    		local decoded = pcall(function()
    			data = X8_HTTP_SERVICE:JSONDecode(raw)
    		end)
    		if not decoded or type(data) ~= "table" or type(data.key) ~= "string" or data.key == "" or tonumber(data.savedAt) == nil then
    			return nil
    		end
    		if os.time() - tonumber(data.savedAt) > X8_CACHE_TTL then
    			if type(delfile) == "function" then pcall(delfile, X8_CACHE_FILE) end
    			return nil
    		end
    		return data.key
    	end

    	local function x8SaveCachedKey(key)
    		if type(writefile) ~= "function" then
    			return
    		end
    		local ok, raw = pcall(function()
    			return X8_HTTP_SERVICE:JSONEncode({ key = key, savedAt = os.time() })
    		end)
    		if ok and type(raw) == "string" then
    			pcall(writefile, X8_CACHE_FILE, raw)
    		end
    	end

    	local function x8ClearCachedKey()
    		if type(delfile) == "function" then pcall(delfile, X8_CACHE_FILE) end
    	end

    	local function x8DeviceId()
    		local ok, result = pcall(function()
    			return game:GetService("RbxAnalyticsService"):GetClientId()
    		end)
    		if ok and type(result) == "string" and result ~= "" then
    			return result
    		end
    		local env = typeof(getgenv) == "function" and getgenv() or _G
    		local hwid = type(env.gethwid) == "function" and env.gethwid or nil
    		if hwid then
    			local ok2, result2 = pcall(hwid)
    			if ok2 and type(result2) == "string" and result2 ~= "" then
    				return result2
    			end
    		end
    		return string.format("roblox:%s:%s", tostring(X8_LOCAL_PLAYER and X8_LOCAL_PLAYER.UserId or "0"), X8_GAME_ID)
    	end

    	local function x8Request(path, payload)
    		if type(X8_HTTP) ~= "function" then
    			return nil, "This executor does not provide an HTTP request function."
    		end
    		local ok, response = pcall(function()
    			return X8_HTTP({
    				Url = X8_API .. path,
    				Method = "POST",
    				Headers = { ["Content-Type"] = "application/json" },
    				Body = X8_HTTP_SERVICE:JSONEncode(payload),
    			})
    		end)
    		if not ok or type(response) ~= "table" then
    			return nil, "Could not reach the x8 key server."
    		end
    		local body = response.Body
    		if type(body) ~= "string" or body == "" then
    			return nil, "The x8 key server returned an empty response."
    		end
    		local decoded
    		local ok2 = pcall(function()
    			decoded = X8_HTTP_SERVICE:JSONDecode(body)
    		end)
    		if not ok2 or type(decoded) ~= "table" then
    			return nil, "The x8 key server returned an invalid response."
    		end
    		return decoded, tonumber(response.StatusCode) or 0
    	end

    	local function x8GuiParent()
    		if type(gethui) == "function" then
    			local ok, result = pcall(gethui)
    			if ok and typeof(result) == "Instance" then
    				return result
    			end
    		end
    		return game:GetService("CoreGui")
    	end

    	local function x8Prompt()
    		local parent = x8GuiParent()
    		local old = parent:FindFirstChild("X899NightsKeySystem")
    		if old then old:Destroy() end

    		local gui = Instance.new("ScreenGui")
    		gui.Name = "X899NightsKeySystem"
    		gui.ResetOnSpawn = false
    		gui.IgnoreGuiInset = true
    		gui.Parent = parent

    		local frame = Instance.new("Frame")
    		frame.Size = UDim2.fromOffset(410, 215)
    		frame.Position = UDim2.new(0.5, -205, 0.5, -108)
    		frame.BackgroundColor3 = Color3.fromRGB(15, 18, 24)
    		frame.BorderSizePixel = 0
    		frame.Parent = gui
    		Instance.new("UICorner", frame).CornerRadius = UDim.new(0, 12)

    		local title = Instance.new("TextLabel")
    		title.BackgroundTransparency = 1
    		title.Size = UDim2.new(1, -32, 0, 34)
    		title.Position = UDim2.fromOffset(16, 14)
    		title.Font = Enum.Font.GothamBold
    		title.TextSize = 22
    		title.TextColor3 = Color3.fromRGB(255, 255, 255)
    		title.Text = "X8   99 Nights in the Forest"
    		title.TextXAlignment = Enum.TextXAlignment.Left
    		title.Parent = frame

    		local sub = Instance.new("TextLabel")
    		sub.BackgroundTransparency = 1
    		sub.Size = UDim2.new(1, -32, 0, 43)
    		sub.Position = UDim2.fromOffset(16, 47)
    		sub.Font = Enum.Font.Gotham
    		sub.TextSize = 13
    		sub.TextColor3 = Color3.fromRGB(175, 180, 190)
    		sub.Text = "Enter your x8 key to continue. Generate one with /generate-key ? 99 Nights in the Forest."
    		sub.TextWrapped = true
    		sub.TextXAlignment = Enum.TextXAlignment.Left
    		sub.Parent = frame

    		local box = Instance.new("TextBox")
    		box.Size = UDim2.new(1, -32, 0, 40)
    		box.Position = UDim2.fromOffset(16, 94)
    		box.BackgroundColor3 = Color3.fromRGB(25, 29, 38)
    		box.BorderSizePixel = 0
    		box.Font = Enum.Font.Code
    		box.TextSize = 14
    		box.TextColor3 = Color3.fromRGB(245, 245, 245)
    		box.PlaceholderColor3 = Color3.fromRGB(105, 110, 120)
    		box.PlaceholderText = "Paste your key here"
    		box.ClearTextOnFocus = false
    		box.Text = tostring((typeof(getgenv) == "function" and getgenv().X899NightsKey) or "")
    		box.Parent = frame
    		Instance.new("UICorner", box).CornerRadius = UDim.new(0, 8)

    		local status = Instance.new("TextLabel")
    		status.BackgroundTransparency = 1
    		status.Size = UDim2.new(1, -152, 0, 34)
    		status.Position = UDim2.fromOffset(16, 143)
    		status.Font = Enum.Font.Gotham
    		status.TextSize = 12
    		status.TextColor3 = Color3.fromRGB(255, 120, 120)
    		status.TextWrapped = true
    		status.TextXAlignment = Enum.TextXAlignment.Left
    		status.Text = ""
    		status.Parent = frame

    		local button = Instance.new("TextButton")
    		button.Size = UDim2.fromOffset(120, 38)
    		button.Position = UDim2.new(1, -136, 1, -52)
    		button.BackgroundColor3 = Color3.fromRGB(124, 58, 237)
    		button.BorderSizePixel = 0
    		button.Font = Enum.Font.GothamBold
    		button.TextSize = 14
    		button.TextColor3 = Color3.fromRGB(255, 255, 255)
    		button.Text = "Activate"
    		button.Parent = frame
    		Instance.new("UICorner", button).CornerRadius = UDim.new(0, 8)

    		local closed = false
    		local function activate()
    			if closed then return end
    			local key = tostring(box.Text or ""):match("^%s*(.-)%s*$")
    			if key == "" then
    				status.Text = "Enter a key first."
    				return
    			end
    			button.Active = false
    			button.AutoButtonColor = false
    			button.Text = "Checking..."
    			status.Text = ""
    			local result, code = x8Request("/v1/activate", {
    				key = key,
    				deviceId = x8DeviceId(),
    				gameId = X8_GAME_ID,
    			})
    			if result and result.ok and result.status == "ACTIVE" then
    				local env = typeof(getgenv) == "function" and getgenv() or _G
    				env.X899NightsKey = key
    				x8SaveCachedKey(key)
    				X8_KEY_SESSION = result.sessionToken or result.token or result.session_token
    				X8_KEY_OK = true
    				status.TextColor3 = Color3.fromRGB(110, 240, 160)
    				status.Text = "Key accepted. Loading..."
    				task.wait(0.4)
    				closed = true
    				gui:Destroy()
    				return
    			end
    			status.TextColor3 = Color3.fromRGB(255, 120, 120)
    			status.Text = tostring(result and (result.message or result.code) or "Key server unavailable.")
    			button.Active = true
    			button.AutoButtonColor = true
    			button.Text = "Activate"
    		end

    		button.MouseButton1Click:Connect(activate)
    		box.FocusLost:Connect(function(enterPressed)
    			if enterPressed then activate() end
    		end)

    		return gui
    	end

    	local env = typeof(getgenv) == "function" and getgenv() or _G
    	local cachedKey = x8LoadCachedKey()
    	if not cachedKey and (type(isfile) ~= "function" or type(readfile) ~= "function") then
    		cachedKey = tostring(env.X899NightsKey or ""):match("^%s*(.-)%s*$")
    	end
    	if cachedKey ~= "" and cachedKey ~= nil then
    		local result = x8Request("/v1/activate", {
    			key = cachedKey,
    			deviceId = x8DeviceId(),
    			gameId = X8_GAME_ID,
    		})
    		if result and result.ok and result.status == "ACTIVE" then
    			env.X899NightsKey = cachedKey
    			x8SaveCachedKey(cachedKey)
    			X8_KEY_SESSION = result.sessionToken or result.token or result.session_token
    			X8_KEY_OK = true
    		else
    			x8ClearCachedKey()
    			env.X899NightsKey = nil
    		end
    	end

    	if not X8_KEY_OK then
    		x8Prompt()
    		repeat task.wait(0.1) until X8_KEY_OK or not x8GuiParent():FindFirstChild("X899NightsKeySystem")
    	end
    	if not X8_KEY_OK then
    		error("X8 99 Nights key activation was cancelled.", 0)
    	end

    	if X8_KEY_SESSION then
    		task.spawn(function()
    			while X8_KEY_OK do
    				task.wait(300)
    				if not X8_KEY_OK then break end
    				local result = x8Request("/v1/validate", {
    					sessionToken = X8_KEY_SESSION,
    					deviceId = x8DeviceId(),
    					gameId = X8_GAME_ID,
    				})
    				if not (result and result.ok and result.status == "ACTIVE") then
    					X8_KEY_OK = false
    					x8ClearCachedKey()
    					pcall(function()
    						env.X899NightsKey = nil
    						game:GetService("StarterGui"):SetCore("SendNotification", {
    							Title = "X8 Key",
    						Text = "Your 99 Nights key is no longer active.",
    							Duration = 6,
    						})
    					end)
    					break
    				end
    			end
    		end)
    	end
end

-- Self-contained UI replacement. The old external lib.lua was returning nil,
-- which caused: attempt to index nil with 'CreateInterface'.
local lib = {}

-- Neon pink / purple theme
local NEON_PINK = Color3.fromRGB(255, 0, 170)
local NEON_PURPLE = Color3.fromRGB(175, 0, 255)
local BG = Color3.fromRGB(16, 10, 22)
local PANEL = Color3.fromRGB(24, 14, 32)
local PANEL_2 = Color3.fromRGB(34, 18, 45)
local TEXT = Color3.fromRGB(245, 235, 250)
local MUTED = Color3.fromRGB(185, 155, 195)

function lib:CreateInterface(title, subtitle, discord, position, theme)
    local guiParent = (gethui and gethui()) or game:GetService("CoreGui")
    local old = guiParent:FindFirstChild("Nights99FixedUI")
    if old then old:Destroy() end

    local gui = Instance.new("ScreenGui")
    gui.Name = "Nights99FixedUI"
    gui.ResetOnSpawn = false
    gui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
    gui.Parent = guiParent

    local window = Instance.new("Frame")
    window.Size = UDim2.fromOffset(720, 500)
    window.Position = UDim2.new(0, 20, 0.5, -250)
    window.BackgroundColor3 = BG
    window.BorderSizePixel = 0
    window.Parent = gui

    local windowStroke = Instance.new("UIStroke")
    windowStroke.Color = NEON_PINK
    windowStroke.Thickness = 1.5
    windowStroke.Transparency = 0.2
    windowStroke.Parent = window

    local corner = Instance.new("UICorner")
    corner.CornerRadius = UDim.new(0, 8)
    corner.Parent = window

    local titleLabel = Instance.new("TextLabel")
    titleLabel.BackgroundTransparency = 1
    titleLabel.Position = UDim2.fromOffset(82, 10)
    titleLabel.Size = UDim2.new(1, -98, 0, 28)
    titleLabel.Font = Enum.Font.GothamBold
    titleLabel.Text = tostring(title)
    titleLabel.TextColor3 = TEXT
    titleLabel.TextSize = 20
    titleLabel.TextXAlignment = Enum.TextXAlignment.Left
    titleLabel.Parent = window

    local subLabel = Instance.new("TextLabel")
    subLabel.BackgroundTransparency = 1
    subLabel.Position = UDim2.fromOffset(82, 38)
    subLabel.Size = UDim2.new(1, -98, 0, 18)
    subLabel.Font = Enum.Font.Gotham
    subLabel.Text = "made by Lucious"
    subLabel.TextColor3 = MUTED
    subLabel.TextSize = 12
    subLabel.TextXAlignment = Enum.TextXAlignment.Left
    subLabel.Parent = window

    local brand = Instance.new("TextLabel")
    brand.Name = "X8Brand"
    brand.Position = UDim2.fromOffset(16, 10)
    brand.Size = UDim2.fromOffset(52, 42)
    brand.BackgroundColor3 = Color3.fromRGB(32, 8, 42)
    brand.BackgroundTransparency = 0.05
    brand.BorderSizePixel = 0
    brand.Font = Enum.Font.Gotham
    brand.Text = "x8"
    brand.TextColor3 = NEON_PINK
    brand.TextSize = 16
    brand.TextStrokeColor3 = NEON_PURPLE
    brand.TextStrokeTransparency = 1
    brand.ZIndex = 11
    brand.Parent = window

    local brandCorner = Instance.new("UICorner")
    brandCorner.CornerRadius = UDim.new(0, 8)
    brandCorner.Parent = brand

    local brandStroke = Instance.new("UIStroke")
    brandStroke.Color = NEON_PINK
    brandStroke.Thickness = 1.5
    brandStroke.Transparency = 0.05
    brandStroke.Parent = brand

    -- Separate x8 mobile button for opening/closing the menu.
    local mobileButton = Instance.new("TextButton")
    mobileButton.Name = "X8MobileButton"
    mobileButton.Size = UDim2.fromOffset(48, 42)
    mobileButton.Position = UDim2.new(0, 10, 0.5, -21)
    mobileButton.BackgroundColor3 = Color3.fromRGB(32, 8, 42)
    mobileButton.BackgroundTransparency = 0.05
    mobileButton.BorderSizePixel = 0
    mobileButton.AutoButtonColor = false
    mobileButton.Font = Enum.Font.Gotham
    mobileButton.Text = "x8"
    mobileButton.TextColor3 = NEON_PINK
    mobileButton.TextSize = 16
    mobileButton.TextStrokeTransparency = 1
    mobileButton.ZIndex = 100
    mobileButton.Parent = gui

    local mobileCorner = Instance.new("UICorner")
    mobileCorner.CornerRadius = UDim.new(0, 8)
    mobileCorner.Parent = mobileButton

    local mobileStroke = Instance.new("UIStroke")
    mobileStroke.Color = NEON_PINK
    mobileStroke.Thickness = 1.5
    mobileStroke.Transparency = 0.05
    mobileStroke.Parent = mobileButton

    mobileButton.Activated:Connect(function()
        window.Visible = not window.Visible
    end)

    -- Draggable header
    local dragArea = Instance.new("TextButton")
    dragArea.Name = "DragArea"
    dragArea.BackgroundTransparency = 1
    dragArea.BorderSizePixel = 0
    dragArea.Text = ""
    dragArea.AutoButtonColor = false
    dragArea.Position = UDim2.fromOffset(0, 0)
    dragArea.Size = UDim2.new(1, 0, 0, 62)
    dragArea.ZIndex = 10
    dragArea.Parent = window

    local UserInputService = game:GetService("UserInputService")
    local dragging = false
    local dragStart
    local startPosition

    dragArea.InputBegan:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1
            or input.UserInputType == Enum.UserInputType.Touch then
            dragging = true
            dragStart = input.Position
            startPosition = window.Position

            input.Changed:Connect(function()
                if input.UserInputState == Enum.UserInputState.End then
                    dragging = false
                end
            end)
        end
    end)

    UserInputService.InputChanged:Connect(function(input)
        if dragging and (input.UserInputType == Enum.UserInputType.MouseMovement
            or input.UserInputType == Enum.UserInputType.Touch) then
            local delta = input.Position - dragStart
            window.Position = UDim2.new(
                startPosition.X.Scale,
                startPosition.X.Offset + delta.X,
                startPosition.Y.Scale,
                startPosition.Y.Offset + delta.Y
            )
        end
    end)

    -- Press K to open/close the UI.
    UserInputService.InputBegan:Connect(function(input, gameProcessed)
        if gameProcessed then return end
        if input.KeyCode == Enum.KeyCode.K then
            window.Visible = not window.Visible
        end
    end)

    local tabs = Instance.new("ScrollingFrame")
    tabs.Position = UDim2.fromOffset(12, 68)
    tabs.Size = UDim2.new(0, 145, 1, -80)
    tabs.BackgroundColor3 = PANEL
    tabs.BorderSizePixel = 0
    tabs.ScrollBarThickness = 3
    tabs.CanvasSize = UDim2.new()
    tabs.Parent = window

    local tabList = Instance.new("UIListLayout")
    tabList.Padding = UDim.new(0, 5)
    tabList.Parent = tabs

    local content = Instance.new("Frame")
    content.Position = UDim2.fromOffset(167, 68)
    content.Size = UDim2.new(1, -179, 1, -80)
    content.BackgroundTransparency = 1
    content.Parent = window

    local interface = {}
    local firstTab = true

    function interface:CreateTab(tabName, tabDescription, icon, selected)
        local tabButton = Instance.new("TextButton")
        tabButton.Size = UDim2.new(1, -8, 0, 34)
        tabButton.BackgroundColor3 = PANEL_2
        tabButton.BorderSizePixel = 0
        tabButton.Font = Enum.Font.GothamSemibold
        tabButton.Text = "  " .. tostring(tabName)
        tabButton.TextColor3 = TEXT
        tabButton.TextSize = 13
        tabButton.TextXAlignment = Enum.TextXAlignment.Left
        tabButton.Parent = tabs

        local tabStroke = Instance.new("UIStroke")
        tabStroke.Color = NEON_PINK
        tabStroke.Thickness = 1
        tabStroke.Transparency = 0.72
        tabStroke.Parent = tabButton

        local page = Instance.new("ScrollingFrame")
        page.Name = tostring(tabName) .. "Page"
        page.Size = UDim2.fromScale(1,1)
        page.BackgroundTransparency = 1
        page.BorderSizePixel = 0
        page.ScrollBarThickness = 4
        page.CanvasSize = UDim2.new()
        page.Visible = false
        page.Parent = content

        local list = Instance.new("UIListLayout")
        list.Padding = UDim.new(0, 7)
        list.SortOrder = Enum.SortOrder.LayoutOrder
        list.Parent = page

        local pad = Instance.new("UIPadding")
        pad.PaddingRight = UDim.new(0, 8)
        pad.PaddingBottom = UDim.new(0, 8)
        pad.Parent = page

        local function updateCanvas()
            page.CanvasSize = UDim2.new(0,0,0,list.AbsoluteContentSize.Y + 12)
        end
        list:GetPropertyChangedSignal("AbsoluteContentSize"):Connect(updateCanvas)

        local tab = {}
        local order = 0
        local function nextOrder() order = order + 1 return order end

        local function makeLabel(text, height)
            local l = Instance.new("TextLabel")
            l.Size = UDim2.new(1, -8, 0, height or 30)
            l.BackgroundColor3 = PANEL
            l.BorderSizePixel = 0
            l.Font = Enum.Font.Gotham
            l.Text = tostring(text or "")
            l.TextColor3 = TEXT
            l.TextSize = 13
            l.TextWrapped = true
            l.TextXAlignment = Enum.TextXAlignment.Left
            l.LayoutOrder = nextOrder()
            l.Parent = page
            return l
        end

        function tab:CreateComment(text)
            local frame = makeLabel("", 34)
            local commentContent = Instance.new("TextLabel")
            commentContent.Name = "commentcontent"
            commentContent.BackgroundTransparency = 1
            commentContent.Size = UDim2.fromScale(1,1)
            commentContent.Font = Enum.Font.Gotham
            commentContent.Text = tostring(text or "")
            commentContent.TextColor3 = TEXT
            commentContent.TextSize = 13
            commentContent.TextWrapped = true
            commentContent.TextXAlignment = Enum.TextXAlignment.Left
            commentContent.Parent = frame
            return frame
        end

        function tab:CreateCheckbox(label, callback)
            local b = Instance.new("TextButton")
            b.Size = UDim2.new(1, -8, 0, 36)
            b.BackgroundColor3 = PANEL_2
            b.BorderSizePixel = 0
            b.Font = Enum.Font.Gotham
            b.Text = "  [ ]  " .. tostring(label)
            b.TextColor3 = TEXT
            b.TextSize = 13
            b.TextXAlignment = Enum.TextXAlignment.Left
            b.LayoutOrder = nextOrder()
            b.Parent = page
            local state = false
            b.MouseButton1Click:Connect(function()
                state = not state
                b.Text = "  " .. (state and "[x]  " or "[ ]  ") .. tostring(label)
                if callback then
                    task.spawn(function()
                        local ok, err = pcall(callback, state)
                        if not ok then warn("Checkbox error:", err) end
                    end)
                end
            end)
            return b
        end

        function tab:CreateSlider(label, maxValue, defaultValue, callback)
            local holder = Instance.new("Frame")
            holder.Size = UDim2.new(1, -8, 0, 58)
            holder.BackgroundColor3 = PANEL_2
            holder.BorderSizePixel = 0
            holder.LayoutOrder = nextOrder()
            holder.Parent = page

            local text = Instance.new("TextLabel")
            text.BackgroundTransparency = 1
            text.Position = UDim2.fromOffset(8, 4)
            text.Size = UDim2.new(1, -16, 0, 20)
            text.Font = Enum.Font.Gotham
            text.TextColor3 = TEXT
            text.TextSize = 13
            text.TextXAlignment = Enum.TextXAlignment.Left
            text.Text = tostring(label) .. ": " .. tostring(defaultValue)
            text.Parent = holder

            local box = Instance.new("TextBox")
            box.Position = UDim2.new(1, -105, 0, 27)
            box.Size = UDim2.fromOffset(95, 24)
            box.BackgroundColor3 = Color3.fromRGB(24,24,30)
            box.BorderSizePixel = 0
            box.Font = Enum.Font.Gotham
            box.TextColor3 = TEXT
            box.TextSize = 12
            box.Text = tostring(defaultValue)
            box.ClearTextOnFocus = false
            box.Parent = holder
            box.FocusLost:Connect(function()
                local value = tonumber(box.Text) or tonumber(defaultValue) or 0
                value = math.clamp(value, 0, tonumber(maxValue) or value)
                box.Text = tostring(value)
                text.Text = tostring(label) .. ": " .. tostring(value)
                if callback then task.spawn(callback, value) end
            end)
            return holder
        end

        function tab:CreateDropDown(label)
            local holder = Instance.new("Frame")
            holder.Size = UDim2.new(1, -8, 0, 36)
            holder.BackgroundColor3 = PANEL
            holder.BorderSizePixel = 0
            holder.ClipsDescendants = false
            holder.LayoutOrder = nextOrder()
            holder.Parent = page

            local header = Instance.new("TextButton")
            header.Size = UDim2.new(1,0,0,36)
            header.BackgroundColor3 = PANEL_2
            header.BorderSizePixel = 0
            header.Font = Enum.Font.GothamSemibold
            header.Text = "  " .. tostring(label) .. "  ?"
            header.TextColor3 = TEXT
            header.TextSize = 13
            header.TextXAlignment = Enum.TextXAlignment.Left
            header.Parent = holder

            local list = Instance.new("Frame")
            list.Position = UDim2.fromOffset(0, 36)
            list.Size = UDim2.new(1,0,0,0)
            list.BackgroundTransparency = 1
            list.Visible = false
            list.Parent = holder

            local layout = Instance.new("UIListLayout")
            layout.Padding = UDim.new(0, 3)
            layout.Parent = list

            local dropdown = {}
            local open = false

            local function addControl(name, callback, checkbox)
                local b = Instance.new("TextButton")
                b.Size = UDim2.new(1, -8, 0, 30)
                b.BackgroundColor3 = PANEL_2
                b.BorderSizePixel = 0
                b.Font = Enum.Font.Gotham
                b.Text = checkbox and ("  [ ]  " .. tostring(name)) or ("  " .. tostring(name))
                b.TextColor3 = TEXT
                b.TextSize = 12
                b.TextXAlignment = Enum.TextXAlignment.Left
                b.Parent = list
                local state = false
                b.MouseButton1Click:Connect(function()
                    if checkbox then
                        state = not state
                        b.Text = "  " .. (state and "[x]  " or "[ ]  ") .. tostring(name)
                        if callback then task.spawn(callback, state) end
                    else
                        if callback then task.spawn(callback) end
                    end
                end)
                return b
            end

            function dropdown:AddButton(name, callback)
                addControl(name, callback, false)
                list.Size = UDim2.new(1,0,0,layout.AbsoluteContentSize.Y)
                if open then holder.Size = UDim2.new(1,-8,0,36 + layout.AbsoluteContentSize.Y) end
            end

            function dropdown:AddCheckbox(name, callback)
                addControl(name, callback, true)
                list.Size = UDim2.new(1,0,0,layout.AbsoluteContentSize.Y)
                if open then holder.Size = UDim2.new(1,-8,0,36 + layout.AbsoluteContentSize.Y) end
            end

            header.MouseButton1Click:Connect(function()
                open = not open
                list.Visible = open
                holder.Size = UDim2.new(1,-8,0, open and (36 + layout.AbsoluteContentSize.Y) or 36)
                header.Text = "  " .. tostring(label) .. (open and "  ?" or "  ?")
            end)

            return dropdown
        end

        local function selectTab()
            for _, child in ipairs(content:GetChildren()) do
                if child:IsA("ScrollingFrame") then child.Visible = false end
            end
            page.Visible = true
            for _, child in ipairs(tabs:GetChildren()) do
                if child:IsA("TextButton") then child.BackgroundColor3 = PANEL_2 end
            end
            tabButton.BackgroundColor3 = NEON_PINK
        end

        tabButton.MouseButton1Click:Connect(selectTab)
        if firstTab or selected then
            firstTab = false
            task.defer(selectTab)
        end
        task.defer(function() tabs.CanvasSize = UDim2.new(0,0,0,tabList.AbsoluteContentSize.Y + 8) end)
        return tab
    end

    return interface
end

local int = lib:CreateInterface("99 Nights in the Forest","made by Lucious","https://discord.gg/ZNTHTWx7KE","bottom left","royal")
local main = int:CreateTab("Main","main functions/script utilities","default",true)
local autofarmss = int:CreateTab("Auto","auto farm utilities (OP)","op")
local itemtp = int:CreateTab("Item TP/ESP","bring items to you","item")
local gametp = int:CreateTab("Game TP","goto in-game locations","info")
local charactertp = int:CreateTab("Mob TP","bring mobs to you","npc")
local plr = int:CreateTab("Player","modify your localplayer","player")
local vis = int:CreateTab("Visuals","modify autoyour visuals","visuals")
local misc = int:CreateTab("Misc","miscellaneous","misc")
local Players = game:GetService("Players")
local LocalPlayer = Players.LocalPlayer
local RunService = game:GetService("RunService")


-- === Main Configurations === 

local Players = game:GetService("Players")
local player = Players.LocalPlayer

-- Safe zone setup: 9 baseplates in a grid
local safezoneBaseplates = {}
local baseplateSize = Vector3.new(2048, 1, 2048)
local baseY = 100
local centerPos = Vector3.new(0, baseY, 0) -- original center

for dx = -1, 1 do
    for dz = -1, 1 do
        local pos = centerPos + Vector3.new(dx * baseplateSize.X, 0, dz * baseplateSize.Z)
        local baseplate = Instance.new("Part")
        baseplate.Name = "SafeZoneBaseplate"
        baseplate.Size = baseplateSize
        baseplate.Position = pos
        baseplate.Anchored = true
        baseplate.CanCollide = true
        baseplate.Transparency = 1
        baseplate.Color = Color3.fromRGB(255, 255, 255)
        baseplate.Parent = workspace
        table.insert(safezoneBaseplates, baseplate)
    end
end

-- Checkbox to toggle visibility/collision for all baseplates
main:CreateCheckbox("Show Safe Zone", function(enabled)
    for _, baseplate in ipairs(safezoneBaseplates) do
        baseplate.Transparency = enabled and 0.8 or 1
        baseplate.CanCollide = enabled
    end
end)

-- Utility to convert "x, y, z" string to CFrame
local function stringToCFrame(str)
    local x, y, z = str:match("([^,]+),%s*([^,]+),%s*([^,]+)")
    return CFrame.new(tonumber(x), tonumber(y), tonumber(z))
end

-- Teleport function with optional tween duration
local function teleportToTarget(cf, duration)
    local char = game.Players.LocalPlayer.Character
    if not char then return end
    local hrp = char:FindFirstChild("HumanoidRootPart")
    if not hrp then return end

    if duration and duration > 0 then
        local ts = game:GetService("TweenService")
        local info = TweenInfo.new(duration, Enum.EasingStyle.Linear)
        local goal = { CFrame = cf }
        local tween = ts:Create(hrp, info, goal)
        tween:Play()
    else
        hrp.CFrame = cf
    end
end


local storyCoords = {
    { "[campsite] camp site", "0, 8, -0"},
    { "[safezone] safe zone", "0, 110, -0" }
}

local storyDropdown = gametp:CreateDropDown("Teleports")

-- Create dropdown for story teleports
for _, entry in ipairs(storyCoords) do
    local name, coord = entry[1], entry[2]
    storyDropdown:AddButton(name, function()
        teleportToTarget(stringToCFrame(coord), 0.1)
    end)
end


itemtp:CreateCheckbox("Item ESP", function(state)
    local itemFolder = workspace:FindFirstChild("Items")
    if not itemFolder then
        warn("workspace.Items folder not found")
        return
    end

    local itemNames = {
        ["Revolver"] = true, ["Oil Barrel"] = true, ["Chainsaw"] = true, ["Giant Sack"] = true, ["Bunny Foot"] = true,["MedKit"] = true, ["Alien Chest"] = true, ["Berry"] = true,
        ["Bolt"] = true, ["Broken Fan"] = true, ["Carrot"] = true, ["Coal"] = true,
        ["Coin Stack"] = true, ["Hologram Emitter"] = true, ["Item Chest"] = true,
        ["Laser Fence Blueprint"] = true, ["Log"] = true, ["Old Flashlight"] = true,
        ["Old Radio"] = true, ["Sheet Metal"] = true, ["Bandage"] = true, ["Rifle"] = true
    }

    local connections = {}

    local function createESP(model)
        if not model:IsA("Model") or not itemNames[model.Name] then return end
        if not model.PrimaryPart or model:FindFirstChild("ESP") then return end

        local billboard = Instance.new("BillboardGui")
        billboard.Name = "ESP"
        billboard.Size = UDim2.new(0, 100, 0, 30)
        billboard.Adornee = model.PrimaryPart
        billboard.AlwaysOnTop = true
        billboard.StudsOffset = Vector3.new(0, 3, 0)
	
	local customFont = Font.new("rbxassetid://16658246179", Enum.FontWeight.Regular, Enum.FontStyle.Normal)
	local label = Instance.new("TextLabel")
	
	label.Size = UDim2.new(1, 0, 1, 0)
	label.TextSize = 17
	label.BackgroundTransparency = 1
	label.TextColor3 = Color3.new(1, 1, 1)
	label.TextStrokeTransparency = 0.5
	label.TextScaled = false
	label.FontFace = customFont
	label.Text = model.Name
	
        label.Parent = billboard

        billboard.Parent = model
    end

    local function removeAllESP()
        for _, model in itemFolder:GetChildren() do
            local esp = model:FindFirstChild("ESP")
            if esp then esp:Destroy() end
        end
    end

    if state then
        -- Create ESPs for all current items
        for _, model in itemFolder:GetChildren() do
            createESP(model)
        end

        -- Add ESPs for any new items added
        local connection = itemFolder.ChildAdded:Connect(function(model)
            if model:IsA("Model") and itemNames[model.Name] then
                model:GetPropertyChangedSignal("PrimaryPart"):Wait()
                createESP(model)
            end
        end)

        table.insert(connections, connection)
    else
        -- Disable ESPs
        removeAllESP()

        -- Disconnect any listeners
        for _, conn in connections do
            if conn.Disconnect then conn:Disconnect() end
        end
        table.clear(connections)
    end
end)

-- tp to item


local Players = game:GetService("Players")
local localPlayer = Players.LocalPlayer

local itemFolder = workspace:WaitForChild("Items")

local itemNames = {
    "Revolver", "Medkit", "Alien Chest", "Berry", "Bolt", "Broken Fan",
    "Carrot", "Coal", "Coin Stack", "Hologram Emitter", "Item Chest",
    "Laser Fence Blueprint", "Log", "Old Flashlight", "Old Radio",
    "Sheet Metal", "Bandage", "Rifle"
}

local function getModelPart(model)
    if model.PrimaryPart then
        return model.PrimaryPart
    end
    for _, part in pairs(model:GetChildren()) do
        if part:IsA("BasePart") then
            return part
        end
    end
    return nil
end

local dropdown = itemtp:CreateDropDown("Teleport to Item")

for _, itemName in ipairs(itemNames) do
    dropdown:AddButton("TP to " .. itemName, function()
        -- Find all models with this name inside Items folder
        local candidates = {}
        for _, model in pairs(itemFolder:GetChildren()) do
            if model:IsA("Model") and model.Name == itemName then
                local part = getModelPart(model)
                if part then
                    table.insert(candidates, part)
                end
            end
        end

        if #candidates == 0 then
            warn("No '" .. itemName .. "' found to teleport to.")
            return
        end

        -- Pick a random part and teleport
        local targetPart = candidates[math.random(1, #candidates)]
        local character = localPlayer.Character
        if character then
            local hrp = character:FindFirstChild("HumanoidRootPart")
            if hrp then
                hrp.CFrame = targetPart.CFrame + Vector3.new(0, 5, 0)
            end
        end
    end)
end



-- tp to item




-- tp item to you  

local Players = game:GetService("Players")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local player = Players.LocalPlayer
local character = player.Character or player.CharacterAdded:Wait()
local rootPart = character:WaitForChild("HumanoidRootPart")

local itemsFolder = workspace:WaitForChild("Items")
local remoteEvents = ReplicatedStorage:WaitForChild("RemoteEvents")

local possibleItems = {
    "Alien Chest",
    "Alpha Wolf Pelt",
    "Anvil Front",
    "Anvil Back",
    "Apple",
    "Bandage",
    "Bear Corpse",
    "Bear Pelt",
    "Berry",
    "Biofuel",
    "Bolt",
    "Broken Fan",
    "Bunny Foot",
    "Carrot",
    "Coal",
    "Coin Stack",
    "Cooked Morsel",
    "Cooked Steak",
    "Chainsaw",
    "Cultist",
    "Cultist Gem",
    "Flower",
    "Fuel Canister",
    "Hologram Emitter",
    "Item Chest",
    "Laser Fence Blueprint",
    "Leather Body",
    "Iron Body",
    "Thorn Body",
    "Log",
    "MedKit",
    "Morsel",
    "Old Flashlight",
    "Old Radio",
    "Good Sack",
    "Good Axe",
    "Raygun",
    "Giant Sack",
    "Strong Axe",
    "Oil Barrel",
    "Old Car Engine",
    "Rifle",
    "Rifle Ammo",
    "Revolver",
    "Revolver Ammo",
    "Sapling",
    "Sheet Metal",
    "Steak",
    "Wolf Pelt",
    "Gem of the Forest Fragment",
    "Tyre",
    "Washing Machine",
    "Broken Microwave"
}

local bringitemtoyou = itemtp:CreateDropDown("Teleport Item (Bulk):")
local sources = {
    itemsFolder,
    game:GetService("ReplicatedStorage"):WaitForChild("TempStorage")
}

local function teleportItem(itemName)
    local stackOffsetY = 2 -- Height between stacked items
    local count = 0

    for _, source in ipairs(sources) do
        for _, item in ipairs(source:GetChildren()) do
            if item.Name == itemName then
                local targetPart = nil

                if itemName == "Berry" then
                    targetPart = item:FindFirstChild("Handle")
                    if not targetPart then
                        for _, child in ipairs(item:GetDescendants()) do
                            if child:IsA("MeshPart") or child:IsA("Part") or child:IsA("UnionOperation") then
                                targetPart = child
                                break
                            end
                        end
                    end
                else
                    for _, child in ipairs(item:GetDescendants()) do
                        if child:IsA("MeshPart") or child:IsA("Part") then
                            targetPart = child
                            break
                        end
                    end
                end

                if targetPart then
                    remoteEvents.RequestStartDraggingItem:FireServer(item)

                    -- Stack vertically at player's position
                    local offset = Vector3.new(0, count * stackOffsetY, 0)
                    targetPart.CFrame = rootPart.CFrame + offset

                    remoteEvents.StopDraggingItem:FireServer(item)
                    print("Moved", itemName, ":", item:GetFullName())

                    count = count + 1
                else
                    warn(itemName .. " found, but no MeshPart or Part inside:", item:GetFullName())
                end
            end
        end
    end
end

for _, itemName in ipairs(possibleItems) do
    bringitemtoyou:AddButton(itemName, function()
        teleportItem(itemName)
    end)
end

-- tp item to you 

-- tp char to you

local Players = game:GetService("Players")
local ReplicatedStorage = game:GetService("ReplicatedStorage")

local player = Players.LocalPlayer
local character = player.Character or player.CharacterAdded:Wait()
local rootPart = character:WaitForChild("HumanoidRootPart")

local characterFolder = workspace:WaitForChild("Characters")

local remoteEvents = ReplicatedStorage:WaitForChild("RemoteEvents") -- if needed

-- List of character names to teleport (your tags)
local possibleCharacters = {
    "Alpha Wolf",
    "Bear",
    "Lost Child",
    "Lost Child2",
    "Lost Child3",
    "Lost Child4",
    "Wolf",
    "Bunny",
    "Cultist",
    "Alien"
}

local bringCharacterToYou = charactertp:CreateDropDown("Teleport Mob:")

-- Helper to find main part (similar to your getModelPart)
local function getMainPart(model)
    if model.PrimaryPart then
        return model.PrimaryPart
    end
    for _, part in ipairs(model:GetDescendants()) do
        if part:IsA("BasePart") then
            return part
        end
    end
    return nil
end

local function teleportCharacter(characterName)
    local stackOffsetY = 3
    local count = 0

    for _, model in ipairs(characterFolder:GetChildren()) do
        if model.Name == characterName then
            local mainPart = getMainPart(model)
            if mainPart and rootPart then
                -- Move the whole model so mainPart aligns above player, stacked
                local targetCFrame = rootPart.CFrame + Vector3.new(0, count * stackOffsetY, 0)
                -- Use SetPrimaryPartCFrame if PrimaryPart exists, else move mainPart directly
                if model.PrimaryPart then
                    model:SetPrimaryPartCFrame(targetCFrame)
                else
                    mainPart.CFrame = targetCFrame
                end
                count = count + 1
            else
                warn("No main part found for character:", model:GetFullName())
            end
        end
    end
end

for _, characterName in ipairs(possibleCharacters) do
    bringCharacterToYou:AddButton(characterName, function()
        teleportCharacter(characterName)
    end)
end


-- tp char to you 


-- === Player Sliders ===

-- JumpPower Slider
plr:CreateSlider("jumppower", 700, 50, function(value)
    local char = LocalPlayer.Character
    if char and char:FindFirstChild("Humanoid") then
        char.Humanoid.JumpPower = value
    end
end)

-- WalkSpeed Slider with Persistent Behavior
plr:CreateSlider("walkspeed", 700, 16, function(value)
    _G.HackedWalkSpeed = value

    local function applyWalkSpeed(humanoid)
        if humanoid then
            humanoid.WalkSpeed = _G.HackedWalkSpeed
            humanoid.Changed:Connect(function(property)
                if property == "WalkSpeed" and humanoid.WalkSpeed ~= _G.HackedWalkSpeed then
                    humanoid.WalkSpeed = _G.HackedWalkSpeed
                end
            end)
        end
    end

    if LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("Humanoid") then
        applyWalkSpeed(LocalPlayer.Character.Humanoid)
    end

    LocalPlayer.CharacterAdded:Connect(function(char)
        char:WaitForChild("Humanoid")
        applyWalkSpeed(char:FindFirstChild("Humanoid"))
    end)
end)

plr:CreateCheckbox("walkspeed toggle (50)",function(toggle)
    if toggle == true then 
    _G.HackedWalkSpeed = 50
        else
    _G.HackedWalkSpeed = 16
    end

    local function applyWalkSpeed(humanoid)
        if humanoid then
            humanoid.WalkSpeed = _G.HackedWalkSpeed
            humanoid.Changed:Connect(function(property)
                if property == "WalkSpeed" and humanoid.WalkSpeed ~= _G.HackedWalkSpeed then
                    humanoid.WalkSpeed = _G.HackedWalkSpeed
                end
            end)
        end
    end

    if LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("Humanoid") then
        applyWalkSpeed(LocalPlayer.Character.Humanoid)
    end

    LocalPlayer.CharacterAdded:Connect(function(char)
        char:WaitForChild("Humanoid")
        applyWalkSpeed(char:FindFirstChild("Humanoid"))
    end)
end)

--// SERVICES
local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local CoreGui = game:GetService("CoreGui")
local UserInputService = game:GetService("UserInputService")

local LocalPlayer = Players.LocalPlayer

--// CONFIG
local espTransparency = 0.4
local teamCheck = true

--// CUSTOM FONT
local customFont = Font.new("rbxassetid://16658246179", Enum.FontWeight.Regular, Enum.FontStyle.Normal)

--// STATE
local BillboardESPs = {}
local ChamsESPs = {}
local ESPConnections = {}

local ESPEnabled = false
local ChamsEnabled = false

--// HELPERS
local function round(num, decimals)
	return tonumber(string.format("%." .. (decimals or 0) .. "f", num))
end

local function getRoot(char)
	return char and char:FindFirstChild("HumanoidRootPart")
end

--// BILLBOARD ESP
local function createBillboardESP(plr)
	if BillboardESPs[plr] or plr == LocalPlayer then return end
	if not plr.Character or not plr.Character:FindFirstChild("Head") then return end

	local gui = Instance.new("BillboardGui")
	gui.Name = "Billboard_ESP"
	gui.Adornee = plr.Character.Head
	gui.Parent = plr.Character.Head
	gui.Size = UDim2.new(0, 100, 0, 40)
	gui.AlwaysOnTop = true
	gui.StudsOffset = Vector3.new(0, 2, 0)

	local label = Instance.new("TextLabel", gui)
	label.Size = UDim2.new(1, 0, 1, 0)
	label.BackgroundTransparency = 1
	label.TextColor3 = Color3.new(1, 1, 1)
	label.TextStrokeTransparency = 0.5
	label.TextScaled = true
	label.FontFace = customFont

	local conn
	conn = RunService.RenderStepped:Connect(function()
		if not plr.Character or not plr.Character:FindFirstChild("Humanoid") then
			gui:Destroy()
			if conn then conn:Disconnect() end
			BillboardESPs[plr] = nil
			ESPConnections[plr] = nil
			return
		end

		local hp = math.floor(plr.Character.Humanoid.Health / plr.Character.Humanoid.MaxHealth * 100)
		label.Text = plr.Name .. " | " .. hp .. "%"
	end)

	BillboardESPs[plr] = gui
	ESPConnections[plr] = conn
end

--// CHAMS ESP (BoxHandleAdornment)
local function createChamsESP(plr)
	if ChamsESPs[plr] or plr == LocalPlayer then return end
	if not plr.Character or not getRoot(plr.Character) then return end

	local folder = Instance.new("Folder")
	folder.Name = "Chams_ESP"
	folder.Parent = CoreGui
	ChamsESPs[plr] = folder

	for _, part in pairs(plr.Character:GetChildren()) do
		if part:IsA("BasePart") then
			local box = Instance.new("BoxHandleAdornment")
			box.Name = "Cham_" .. plr.Name
			box.Adornee = part
			box.AlwaysOnTop = true
			box.ZIndex = 10
			box.Size = part.Size
			box.Transparency = espTransparency
			box.Color = BrickColor.new(
				teamCheck and (plr.TeamColor == LocalPlayer.TeamColor and "Bright green" or "Bright red") or tostring(plr.TeamColor)
			)
			box.Parent = folder
		end
	end
end

--// CLEANUP FUNCTIONS
local function cleanupBillboardESP()
	for _, gui in pairs(BillboardESPs) do
		if gui then gui:Destroy() end
	end
	for _, conn in pairs(ESPConnections) do
		if conn then conn:Disconnect() end
	end
	BillboardESPs = {}
	ESPConnections = {}
end

local function cleanupChamsESP()
	for _, folder in pairs(ChamsESPs) do
		if folder then folder:Destroy() end
	end
	ChamsESPs = {}
end

--// INITIALIZATION HANDLER
local function handlePlayerESP(plr)
	if ESPEnabled then createBillboardESP(plr) end
	if ChamsEnabled then createChamsESP(plr) end

	plr.CharacterAdded:Connect(function()
		task.wait(1)
		if ESPEnabled then createBillboardESP(plr) end
		if ChamsEnabled then createChamsESP(plr) end
	end)
end

--// GUI TOGGLES (INTEGRATE INTO YOUR UI)
vis:CreateCheckbox("ESP", function(state)
	ESPEnabled = state
	if not state then
		cleanupBillboardESP()
	else
		for _, plr in pairs(Players:GetPlayers()) do
			if plr ~= LocalPlayer then
				createBillboardESP(plr)
			end
		end
	end
end)

vis:CreateCheckbox("Chams", function(state)
	ChamsEnabled = state
	if not state then
		cleanupChamsESP()
	else
		for _, plr in pairs(Players:GetPlayers()) do
			if plr ~= LocalPlayer then
				createChamsESP(plr)
			end
		end
	end
end)

--// INIT ON CURRENT PLAYERS
for _, plr in pairs(Players:GetPlayers()) do
	if plr ~= LocalPlayer then
		handlePlayerESP(plr)
	end
end

Players.PlayerAdded:Connect(function(plr)
	handlePlayerESP(plr)
end)

--// FOV CIRCLE
local FOVCircle = Drawing.new("Circle")
FOVCircle.Visible = false
FOVCircle.Color = Color3.fromRGB(255, 255, 255)
FOVCircle.Transparency = 1
FOVCircle.Thickness = 1
FOVCircle.Filled = false
FOVCircle.ZIndex = 2

local FOVRadius = 100

RunService.RenderStepped:Connect(function()
	if FOVCircle.Visible then
		FOVCircle.Radius = FOVRadius
		FOVCircle.Position = UserInputService:GetMouseLocation()
	end
end)

vis:CreateCheckbox("FOV Circle", function(state)
	FOVCircle.Visible = state
end)


-- extra scripts

local civDropdown2 = misc:CreateDropDown("Extra Scripts", function() end)

civDropdown2:AddButton("infinite yield",function()
    loadstring(game:HttpGet("https://raw.githubusercontent.com/EdgeIY/infiniteyield/master/source"))()
end)

civDropdown2:AddButton("emote gui",function()
    loadstring(game:HttpGet("https://raw.githubusercontent.com/dimension-sources/random-scripts-i-found/refs/heads/main/r6%20animations"))()
end)

civDropdown2:AddButton("anti afk",function()
    
    wait(0.5)local ba=Instance.new("ScreenGui")
local ca=Instance.new("TextLabel")local da=Instance.new("Frame")
local _b=Instance.new("TextLabel")local ab=Instance.new("TextLabel")ba.Parent=game.CoreGui
ba.ZIndexBehavior=Enum.ZIndexBehavior.Sibling;ca.Parent=ba;ca.Active=true
ca.BackgroundColor3=Color3.new(0.176471,0.176471,0.176471)ca.Draggable=true
ca.Position=UDim2.new(0.698610067,0,0.098096624,0)ca.Size=UDim2.new(0,370,0,52)
ca.Font=Enum.Font.SourceSansSemibold;ca.Text="anti afk"ca.TextColor3=Color3.new(0,1,1)
ca.TextSize=22;da.Parent=ca
da.BackgroundColor3=Color3.new(0.196078,0.196078,0.196078)da.Position=UDim2.new(0,0,1.0192306,0)
da.Size=UDim2.new(0,370,0,107)_b.Parent=da
_b.BackgroundColor3=Color3.new(0.176471,0.176471,0.176471)_b.Position=UDim2.new(0,0,0.800455689,0)
_b.Size=UDim2.new(0,370,0,21)_b.Font=Enum.Font.Arial;_b.Text="anti afk"
_b.TextColor3=Color3.new(0,1,1)_b.TextSize=20;ab.Parent=da
ab.BackgroundColor3=Color3.new(0.176471,0.176471,0.176471)ab.Position=UDim2.new(0,0,0.158377,0)
ab.Size=UDim2.new(0,370,0,44)ab.Font=Enum.Font.ArialBold;ab.Text="status: active"
ab.TextColor3=Color3.new(0,1,1)ab.TextSize=20;local bb=game:service'VirtualUser'
game:service'Players'.LocalPlayer.Idled:connect(function()
bb:CaptureController()bb:ClickButton2(Vector2.new())
ab.Text="roblox tried to kick you but failed to do so!"wait(2)ab.Text="status : active"end)

    
end)

civDropdown2:AddButton("turtle spy",function()
    loadstring(game:HttpGet("https://raw.githubusercontent.com/Turtle-Brand/Turtle-Spy/main/source.lua", true))()
end)

-- extra scripts


-- loop distance


local RunService = game:GetService("RunService")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local Players = game:GetService("Players")
local Workspace = game:GetService("Workspace")

local RemoteEvents = ReplicatedStorage:WaitForChild("RemoteEvents")
local player = Players.LocalPlayer

-- Original Kill Aura Variables
local killAuraToggle = false
local radius = 200

-- Infinite Range Kill Aura Variables
local infRangeKillAuraToggle = false
-- Script generated by TurtleSpy, made by Intrer#0421
-- Supported tools and their damage IDs

local toolsDamageIDs = {
    ["Old Axe"] = "1_8982038982",
    ["Good Axe"] = "112_8982038982",
    ["Strong Axe"] = "116_8982038982",
    ["Chainsaw"] = "647_8992824875",
    ["Spear"] = "196_8999010016"
    
}

-- Try to find any supported tool in inventory with damageID
local function getAnyToolWithDamageID()
    for toolName, damageID in pairs(toolsDamageIDs) do
        local tool = player.Inventory:FindFirstChild(toolName)
        if tool then
            return tool, damageID
        end
    end
    return nil, nil
end

-- Equip a given tool
local function equipTool(tool)
    if tool then
        RemoteEvents.EquipItemHandle:FireServer("FireAllClients", tool)
    end
end

-- Unequip a given tool
local function unequipTool(tool)
    if tool then
        RemoteEvents.UnequipItemHandle:FireServer("FireAllClients", tool)
    end
end

-- Original Kill Aura main loop (with radius)
local function killAuraLoop()
    while killAuraToggle do
        local character = player.Character or player.CharacterAdded:Wait()
        local hrp = character:FindFirstChild("HumanoidRootPart")
        if hrp then
            local tool, damageID = getAnyToolWithDamageID()
            if tool and damageID then
                equipTool(tool)

                for _, mob in ipairs(Workspace.Characters:GetChildren()) do
                    if mob:IsA("Model") then
                        local part = mob:FindFirstChildWhichIsA("BasePart")
                        if part and (part.Position - hrp.Position).Magnitude <= radius then
                            pcall(function()
                                RemoteEvents.ToolDamageObject:InvokeServer(
                                    mob,
                                    tool,
                                    damageID,
                                    CFrame.new(part.Position)
                                )
                            end)
                        end
                    end
                end

                task.wait(0.1)
            else
                warn("No supported tool found in inventory")
                task.wait(1)
            end
        else
            task.wait(0.5)
        end
    end
end

-- Helper: Get all models recursively in a folder
local function getAllModelsInFolder(folder)
    local models = {}
    for _, obj in ipairs(folder:GetDescendants()) do
        if obj:IsA("Model") then
            table.insert(models, obj)
        end
    end
    return models
end

-- Helper: Find any BasePart descendant of a model
local function findAnyBasePart(model)
    for _, descendant in ipairs(model:GetDescendants()) do
        if descendant:IsA("BasePart") then
            return descendant
        end
    end
    return nil
end

-- UI checkbox toggles
main:CreateCheckbox("Kill Aura", function(state)
    killAuraToggle = state
    if state then
        task.spawn(killAuraLoop)
    else
        local tool, _ = getAnyToolWithDamageID()
        unequipTool(tool)
    end
end)

main:CreateSlider("Kill Aura Radius", 500, 20, function(value)
    radius = math.clamp(value, 20, 500)
end)

-- loop distance



-- extra item automation

itemtp:CreateComment("remaining specific item teleports:")

local Players = game:GetService("Players")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local player = Players.LocalPlayer
local character = player.Character or player.CharacterAdded:Wait()
local rootPart = character:WaitForChild("HumanoidRootPart")

local itemsFolder = workspace:WaitForChild("Items")
local remoteEvents = ReplicatedStorage:WaitForChild("RemoteEvents")

local bracket = {
    weapons = {
        -- Removed Good Axe and Strong Axe
        "Laser Sword", "Raygun", "Kunai", "Katana", "Spear" -- moved to misc tools, but you wanted it here too?
    },
    minifoods = {
        "Apple", "Berry", "Carrot"
    },
    meat = {
        "Steak", "Cooked Steak", "Cooked Morsel" , "Morsel"
    },
    armor = {
        "Leather Body", "Iron Body", "Thorn Body"
    },
    ["guns/ammo"] = {
        "Rifle", "Revolver", "Raygun", "Tactical Shotgun", "Revolver Ammo", "Rifle Ammo"
    },
    materials = {
        "Log", "Coal", "Fuel Canister", "UFO Junk", "UFO Component", "Bandage", "MedKit",
        "Old Car Engine", "Broken Fan", "Old Microwave", "Old Radio", "Sheet Metal"
    },
    pelts = {
        "Alpha Wolf Pelt", "Bear Pelt", "Wolf Pelt", "Bunny Foot"
    },
    misc_tools = {  -- changed to misc_tools for consistency with no spaces
        "Good Sack", "Old Flashlight", "Old Radio", "Giant Sack", "Strong Flashlight", "Chainsaw"
    }
}

-- Finds the first suitable BasePart to teleport
local function findTeleportablePart(item)
    for _, descendant in ipairs(item:GetDescendants()) do
        if descendant:IsA("BasePart") then
            return descendant
        end
        if descendant:IsA("Model") then
            for _, sub in ipairs(descendant:GetDescendants()) do
                if sub:IsA("BasePart") then
                    return sub
                end
            end
        end
    end
    return nil
end

local function teleportItem(itemName)
    local stackOffsetY = 2 -- offset per stacked item
    local count = 0

    for _, item in ipairs(itemsFolder:GetChildren()) do
        if item.Name == itemName then
            local targetPart = findTeleportablePart(item)
            if targetPart then
                remoteEvents.RequestStartDraggingItem:FireServer(item)
                local offset = Vector3.new(0, count * stackOffsetY, 0)
                targetPart.CFrame = rootPart.CFrame + offset
                remoteEvents.StopDraggingItem:FireServer(item)

                print("Moved", itemName, ":", item:GetFullName())
                count = count + 1
            else
                warn("Couldn't find part for:", item:GetFullName())
            end
        end
    end
end

-- Create one dropdown per bracket
for groupName, itemList in pairs(bracket) do
    -- Make dropdown label nicer: replace underscores and slashes, capitalize words
    local label = groupName:gsub("_", " "):gsub("/", "/")
    label = label:gsub("(%a)([%w_']*)", function(first, rest)
        return first:upper() .. rest:lower()
    end)
    local dropdown = itemtp:CreateDropDown(label)
    for _, itemName in ipairs(itemList) do
        dropdown:AddButton(itemName, function()
            teleportItem(itemName)
        end)
    end
end

-- separation for the automation

-- auto 

-- === SERVICES ===
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local Players = game:GetService("Players")
local Workspace = game:GetService("Workspace")

-- === PLAYER REFERENCES ===
local player = Players.LocalPlayer
local character = player.Character or player.CharacterAdded:Wait()
local rootPart = character:WaitForChild("HumanoidRootPart")
local itemsFolder = Workspace:WaitForChild("Items")
local remoteEvents = ReplicatedStorage:WaitForChild("RemoteEvents")
local remoteConsume = remoteEvents:WaitForChild("RequestConsumeItem")

-- === POSITIONS ===
local campfireDropPos = Vector3.new(0, 19, 0)
local machineDropPos = Vector3.new(21, 16, -5)

-- === ITEM LISTS ===
local campfireFuelItems = {"Log", "Coal", "Fuel Canister", "Oil Barrel", "Biofuel"}
local autocookItems = {"Morsel", "Steak"}
local autoGrindItems = {"UFO Junk", "UFO Component", "Old Car Engine", "Broken Fan", "Old Microwave", "Bolt", "Log", "Cultist Gem", "Sheet Metal", "Old Radio","Tyre","Washing Machine", "Cultist Experiment", "Cultist Component", "Gem of the Forest Fragment", "Broken Microwave"}
local autoEatFoods = {"Cooked Steak", "Cooked Morsel", "Berry", "Carrot", "Apple"}
local biofuelItems = {"Carrot", "Cooked Morsel", "Morsel", "Steak", "Cooked Steak", "Log"}

-- === TOGGLES ===
local autoFuelEnabledItems = {}
local autoCookEnabledItems = {}
local autoGrindEnabledItems = {}
local autoEatEnabled = false
local autoBreakEnabled = false
local autoBiofuelEnabledItems = {}
local alwaysFeedEnabledItems = {}

-- === MOVE ITEM FUNCTION (STABLE) ===
local function moveItemToPos(item, position)
    if not item or not item:IsDescendantOf(workspace) then return end
    local part = item.PrimaryPart or item:FindFirstChildWhichIsA("BasePart") or item:FindFirstChild("Handle")
    if not part then return end

    if not item.PrimaryPart then
        pcall(function() item.PrimaryPart = part end)
    end

    pcall(function()
        remoteEvents.RequestStartDraggingItem:FireServer(item)
        task.wait(0.05)
        item:SetPrimaryPartCFrame(CFrame.new(position))
        task.wait(0.05)
        remoteEvents.StopDraggingItem:FireServer(item)
    end)
end

-- === UI INITIALIZATION ===
local autofarmss = autofarmss or main -- fallback if not already defined
local function createDropdownWithCheckboxes(title, itemList, enabledTable)
    local dropdown = autofarmss:CreateDropDown(title)
    for _, itemName in ipairs(itemList) do
        dropdown:AddCheckbox(itemName, function(checked)
            enabledTable[itemName] = checked
        end)
    end
    dropdown:AddCheckbox("Bulk (All)", function(checked)
        for _, itemName in ipairs(itemList) do
            enabledTable[itemName] = checked
        end
    end)
    return dropdown
end

createDropdownWithCheckboxes("Auto Feed Campfire (ignores HP)", campfireFuelItems, alwaysFeedEnabledItems)
createDropdownWithCheckboxes("Auto Feed Campfire (HP Based)", campfireFuelItems, autoFuelEnabledItems)
createDropdownWithCheckboxes("Auto Cook Food", autocookItems, autoCookEnabledItems)
createDropdownWithCheckboxes("Auto Machine Grind", autoGrindItems, autoGrindEnabledItems)
createDropdownWithCheckboxes("Auto Biofuel Processor", biofuelItems, autoBiofuelEnabledItems)

-- Auto Eat
local eatDropdown = autofarmss:CreateDropDown("Auto Eat (3 sec interval)")
eatDropdown:AddCheckbox("Enable Auto Eat", function(checked)
    autoEatEnabled = checked
end)

-- Auto Eat HP Based
local eatHPDropdown = autofarmss:CreateDropDown("Auto Eat (HP Bar Based)")
eatHPDropdown:AddCheckbox("Enable Auto Eat (HP Bar Based)", function(checked)
    autoEatHPEnabled = checked
end)


-- === BACKGROUND COROUTINES ===
coroutine.wrap(function() -- Always Feed Campfire
    while true do
        for itemName, enabled in pairs(alwaysFeedEnabledItems) do
            if enabled then
                for _, item in ipairs(itemsFolder:GetChildren()) do
                    if item.Name == itemName then
                        moveItemToPos(item, campfireDropPos)
                    end
                end
            end
        end
        task.wait(2)
    end
end)()

coroutine.wrap(function() -- HP-Based Feed
    local campfire = Workspace:WaitForChild("Map"):WaitForChild("Campground"):WaitForChild("MainFire")
    local fillFrame = campfire.Center.BillboardGui.Frame.Background.Fill
    while true do
        local healthPercent = fillFrame.Size.X.Scale
        if healthPercent < 0.7 then
            repeat
                for itemName, enabled in pairs(autoFuelEnabledItems) do
                    if enabled then
                        for _, item in ipairs(itemsFolder:GetChildren()) do
                            if item.Name == itemName then
                                moveItemToPos(item, campfireDropPos)
                            end
                        end
                    end
                end
                task.wait(0.5)
                healthPercent = fillFrame.Size.X.Scale
            until healthPercent >= 1
        end
        task.wait(2)
    end
end)()

coroutine.wrap(function() -- Auto Cook
    while true do
        for itemName, enabled in pairs(autoCookEnabledItems) do
            if enabled then
                for _, item in ipairs(itemsFolder:GetChildren()) do
                    if item.Name == itemName then
                        moveItemToPos(item, campfireDropPos)
                    end
                end
            end
        end
        task.wait(2.5)
    end
end)()

coroutine.wrap(function() -- Auto Grind
    while true do
        for itemName, enabled in pairs(autoGrindEnabledItems) do
            if enabled then
                for _, item in ipairs(itemsFolder:GetChildren()) do
                    if item.Name == itemName then
                        moveItemToPos(item, machineDropPos)
                    end
                end
            end
        end
        task.wait(2.5)
    end
end)()

coroutine.wrap(function() -- Auto Eat
    while true do
        if autoEatEnabled then
            local available = {}
            for _, item in ipairs(itemsFolder:GetChildren()) do
                if table.find(autoEatFoods, item.Name) then
                    table.insert(available, item)
                end
            end
            if #available > 0 then
                local food = available[math.random(1, #available)]
                pcall(function() remoteConsume:InvokeServer(food) end)
            end
        end
        task.wait(3)
    end
end)()

local player = game:GetService("Players").LocalPlayer
local hungerBar = player:WaitForChild("PlayerGui"):WaitForChild("Interface"):WaitForChild("StatBars"):WaitForChild("HungerBar"):WaitForChild("Bar")

coroutine.wrap(function() -- Auto Eat (HP Bar Based)
    while true do
        if autoEatHPEnabled then
            if hungerBar.Size.X.Scale <= 0.5 then
                repeat
                    local currentHunger = hungerBar.Size.X.Scale

                    local available = {}
                    for _, item in ipairs(itemsFolder:GetChildren()) do
                        if item.Name and table.find(autoEatFoods, item.Name) then
                            table.insert(available, item)
                            print("Found available food item: ", item.Name)
                        end
                    end

                    if #available > 0 then
                        local food = available[math.random(1, #available)]
                        if food then
                            pcall(function()
                                remoteConsume:InvokeServer(food)
                            end)
                        end
                    else
                        warn("No available food found in inventory.")
                        break -- Stop trying if no food
                    end

                    task.wait(1) -- Wait for GUI to reflect update

                until hungerBar.Size.X.Scale >= 0.99 or not autoEatHPEnabled
            end
        end
        task.wait(3)
    end
end)()



coroutine.wrap(function() -- Auto Biofuel
    local biofuelProcessorPos
    while true do
        if not biofuelProcessorPos then
            local processor = Workspace:FindFirstChild("Structures") and Workspace.Structures:FindFirstChild("Biofuel Processor")
            local part = processor and processor:FindFirstChild("Part")
            if part then
                biofuelProcessorPos = part.Position + Vector3.new(0, 5, 0)
            end
        end

        if biofuelProcessorPos then
            for itemName, enabled in pairs(autoBiofuelEnabledItems) do
                if enabled then
                    for _, item in ipairs(itemsFolder:GetChildren()) do
                        if item.Name == itemName then
                            moveItemToPos(item, biofuelProcessorPos)
                        end
                    end
                end
            end
        end
        task.wait(2)
    end
end)()

-- === TREE TELEPORT SYSTEM ===
local originalTreeCFrames = {}
local treesBrought = false

local function getAllSmallTrees()
    local trees = {}
    local function scan(folder)
        for _, obj in ipairs(folder:GetChildren()) do
            if obj:IsA("Model") and obj.Name == "Small Tree" then
                table.insert(trees, obj)
            end
        end
    end

    local map = Workspace:FindFirstChild("Map")
    if map then
        if map:FindFirstChild("Foliage") then scan(map.Foliage) end
        if map:FindFirstChild("Landmarks") then scan(map.Landmarks) end
    end
    return trees
end

local function findTrunk(tree)
    for _, part in ipairs(tree:GetDescendants()) do
        if part:IsA("BasePart") and part.Name == "Trunk" then return part end
    end
end

local function bringAllTrees()
    local target = CFrame.new(rootPart.Position + rootPart.CFrame.LookVector * 10)
    for _, tree in ipairs(getAllSmallTrees()) do
        local trunk = findTrunk(tree)
        if trunk then
            if not originalTreeCFrames[tree] then originalTreeCFrames[tree] = trunk.CFrame end
            tree.PrimaryPart = trunk
            trunk.Anchored = false
            trunk.CanCollide = false
            task.wait()
            tree:SetPrimaryPartCFrame(target + Vector3.new(math.random(-5,5), 0, math.random(-5,5)))
            trunk.Anchored = true
        end
    end
    treesBrought = true
end

local function restoreTrees()
    for tree, cframe in pairs(originalTreeCFrames) do
        local trunk = findTrunk(tree)
        if trunk then
            tree.PrimaryPart = trunk
            tree:SetPrimaryPartCFrame(cframe)
            trunk.Anchored = true
            trunk.CanCollide = true
        end
    end
    originalTreeCFrames = {}
    treesBrought = false
end

-- Tree toggle
local miscdropdown = autofarmss:CreateDropDown("Auto Misc Features")
miscdropdown:AddCheckbox("Auto Bring All Small Trees", function(checked)
    autoBreakEnabled = checked
    if checked and not treesBrought then
        bringAllTrees()
    elseif not checked and treesBrought then
        restoreTrees()
    end
end)


-- === AUTO STRONGHOLD ===

local strongholdRunning = true -- Always running

local function getStrongholdTimerLabel()
    return workspace:FindFirstChild("Map")
        and workspace.Map:FindFirstChild("Landmarks")
        and workspace.Map.Landmarks:FindFirstChild("Stronghold")
        and workspace.Map.Landmarks.Stronghold:FindFirstChild("Functional")
        and workspace.Map.Landmarks.Stronghold.Functional:FindFirstChild("Sign")
        and workspace.Map.Landmarks.Stronghold.Functional.Sign:FindFirstChild("SurfaceGui")
        and workspace.Map.Landmarks.Stronghold.Functional.Sign.SurfaceGui:FindFirstChild("Frame")
        and workspace.Map.Landmarks.Stronghold.Functional.Sign.SurfaceGui.Frame:FindFirstChild("Body")
end

local initialLabel = getStrongholdTimerLabel()
local initialText = "Stronghold Timer: " .. tostring(initialLabel and initialLabel.ContentText or "N/A")
local strongholdDropdown = main:CreateDropDown("Stronghold Clients")

local strongholdTimeChecker = main:CreateComment(initialText)

-- Coroutine to update timer text every second
coroutine.wrap(function()
    local lastTimerText = nil
    while strongholdRunning do
        local label = getStrongholdTimerLabel()
        local timerText = "Stronghold Timer: " .. tostring(label and label.ContentText or "N/A")

        if timerText ~= lastTimerText then
            if strongholdTimeChecker.SetText then
                strongholdTimeChecker:SetText(timerText)
            else
                local commentContent = strongholdTimeChecker:FindFirstChild("commentcontent")
                if commentContent then
                    commentContent.Text = timerText
                end
            end
            lastTimerText = timerText
        end

        task.wait(0.5) -- check every second
    end
end)()

strongholdDropdown:AddButton("Teleport to Stronghold", function()
    local targetPart = workspace:FindFirstChild("Map")
        and workspace.Map:FindFirstChild("Landmarks")
        and workspace.Map.Landmarks:FindFirstChild("Stronghold")
        and workspace.Map.Landmarks.Stronghold:FindFirstChild("Functional")
        and workspace.Map.Landmarks.Stronghold.Functional:FindFirstChild("EntryDoors")
        and workspace.Map.Landmarks.Stronghold.Functional.EntryDoors:FindFirstChild("DoorRight")
        and workspace.Map.Landmarks.Stronghold.Functional.EntryDoors.DoorRight:FindFirstChild("Model")

    if targetPart then
        local children = targetPart:GetChildren()
        local destination = children[5]

        if destination and destination:IsA("BasePart") then
            local hrp = game.Players.LocalPlayer.Character and game.Players.LocalPlayer.Character:FindFirstChild("HumanoidRootPart")
            if hrp then
                -- Offset slightly above the target to avoid clipping
                hrp.CFrame = destination.CFrame + Vector3.new(0, 5, 0)
                print("Teleported to Stronghold DoorRight Model child #5.")
            else
                warn("HumanoidRootPart not found!")
            end
        else
            warn("Child #5 is missing or not a BasePart!")
        end
    else
        warn("DoorRight.Model path not found!")
    end
end)



-- Teleport to Stronghold Diamond Chest button
strongholdDropdown:AddButton("Teleport to Diamond Chest", function()
    local items = workspace:FindFirstChild("Items")
    if not items then
        warn("Items folder not found!")
        return
    end

    local chest = items:FindFirstChild("Stronghold Diamond Chest")
    if not chest then
        warn("Stronghold Diamond Chest not found!")
        return
    end

    local chestLid = chest:FindFirstChild("ChestLid")
    if not chestLid then
        warn("ChestLid not found!")
        return
    end

    local diamondchest = chestLid:FindFirstChild("Meshes/diamondchest_Cube.002")
    if not diamondchest then
        warn("Diamond chest mesh not found!")
        return
    end

    local hrp = game.Players.LocalPlayer.Character and game.Players.LocalPlayer.Character:FindFirstChild("HumanoidRootPart")
    if hrp then
        hrp.CFrame = diamondchest.CFrame + Vector3.new(0, 5, 0)
    else
        warn("HumanoidRootPart not found!")
    end
end)

-- auto 

-- extra item automation