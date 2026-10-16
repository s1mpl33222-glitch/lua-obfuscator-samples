--=====================================================================
-- NAPOLEON HUB
-- Feito por: equipe unk
--=====================================================================

local loadstringFn = loadstring or load
if not table.clear then
	table.clear = function(t) for k in pairs(t) do t[k] = nil end end
end
local tickFn = tick or os.clock

local RUN_ID = tostring(tickFn()) .. tostring(math.random(1000, 9999))
if type(_G.NapoleonCleanup) == "function" then pcall(_G.NapoleonCleanup) end
_G.NapoleonRunId = RUN_ID
local function Alive() return _G.NapoleonRunId == RUN_ID end

local function httpGet(url)
	local ok, res = pcall(function() return game:HttpGet(url) end)
	if not ok then error("Falha HTTP: " .. url) end
	return res
end

local WINDUI_URL = "https://github.com/Footagesus/WindUI/releases/latest/download/main.lua"

local NAPOLEON_IMG
do
	local ok = pcall(function()
		local url = "https://tr.rbxcdn.com/180DAY-c6af2404d410dd3273a96997d7f6a6d4/420/420/Decal/Webp/noFilter"
		local fileName = "napoleon_bg_v1.png"

		if isfile and isfile(fileName) then
			if getcustomasset then
				NAPOLEON_IMG = getcustomasset(fileName)
			end
		end

		if not NAPOLEON_IMG then
			local data = game:HttpGet(url)
			if writefile then
				writefile(fileName, data)
			end
			if getcustomasset then
				NAPOLEON_IMG = getcustomasset(fileName)
			end
		end
	end)

	if not ok or not NAPOLEON_IMG then
		NAPOLEON_IMG = "rbxassetid://6031091004"
	end
end

local WindUI
local function LoadWindUI()
	local src = httpGet(WINDUI_URL)
	local fn = loadstringFn(src)
	if not fn then error("loadstring nil para WindUI") end
	return fn()
end

WindUI = LoadWindUI()

local Players             = game:GetService("Players")
local RunService          = game:GetService("RunService")
local UserInputService    = game:GetService("UserInputService")
local GuiService          = game:GetService("GuiService")
local TweenService        = game:GetService("TweenService")
local ReplicatedStorage   = game:GetService("ReplicatedStorage")
local VirtualInputManager = game:GetService("VirtualInputManager")
local Workspace           = game:GetService("Workspace")
local Lighting            = game:GetService("Lighting")
local CoreGui             = game:GetService("CoreGui")
local HttpService         = game:GetService("HttpService")

local Player    = Players.LocalPlayer
local PlayerGui = Player:WaitForChild("PlayerGui")

pcall(function()
	local parents = { CoreGui, PlayerGui }
	pcall(function() local h = gethui and gethui() if h then table.insert(parents, h) end end)
	for _, p in ipairs(parents) do
		pcall(function()
			for _, g in ipairs(p:GetChildren()) do
				if g.Name == "NapoleonLoading" then g:Destroy() end
			end
		end)
	end
	for _, n in ipairs({ "NapoleonKeyBlur", "NapoleonLoadBlur" }) do
		local b = Lighting:FindFirstChild(n)
		if b then b:Destroy() end
	end
	local pf = Workspace:FindFirstChild("NapoleonHubPredict")
	if pf then pf:Destroy() end
	local pf2 = Workspace:FindFirstChild("NapoleonClientPredict")
	if pf2 then pf2:Destroy() end
end)

local IS_MOBILE = UserInputService.TouchEnabled and not UserInputService.KeyboardEnabled

local function GetViewport()
	local v = Vector2.new(1280, 720)
	pcall(function() v = Workspace.CurrentCamera.ViewportSize end)
	return v
end

local function FitSize(w, h)
	local vp = GetViewport()
	return UDim2.fromOffset(
		math.floor(math.clamp(w, 300, math.max(300, vp.X * 0.92))),
		math.floor(math.clamp(h, 220, math.max(220, vp.Y * 0.85)))
	)
end

local FPS = 60
local FpsConn
FpsConn = RunService.Heartbeat:Connect(function(dt)
	if not Alive() then FpsConn:Disconnect() return end
	if dt > 0 then FPS = FPS + ((1 / dt) - FPS) * 0.05 end
end)

local function GetPing()
	local ok, v = pcall(function()
		return math.floor(game:GetService("Stats").Network.ServerStatsItem["Data Ping"]:GetValue())
	end)
	return ok and v or 0
end

local function RemoveBlur()
	pcall(function()
		local b = Lighting:FindFirstChild("NapoleonKeyBlur")
		if b then b:Destroy() end
	end)
end

local function AddKeyBlur()
	RemoveBlur()
	pcall(function()
		local b = Instance.new("BlurEffect")
		b.Name = "NapoleonKeyBlur"
		b.Size = 0
		b.Parent = Lighting
		TweenService:Create(b, TweenInfo.new(0.6), { Size = 20 }):Play()
	end)
end

local function ApplyTheme(lib)
	pcall(function()
		lib:AddTheme({
			Name = "Napoleon",
			Accent = lib:Gradient({
				["0"]   = { Color = Color3.fromHex("#f3e1ae"), Transparency = 0 },
				["50"]  = { Color = Color3.fromHex("#cfae63"), Transparency = 0 },
				["100"] = { Color = Color3.fromHex("#7a5e28"), Transparency = 0 },
			}, { Rotation = 90 }),
			Dialog = Color3.fromHex("#0b0907"),
			Outline = Color3.fromHex("#cfae63"),
			Text = Color3.fromHex("#f7edd8"),
			Placeholder = Color3.fromHex("#8a7a5c"),
			Button = lib:Gradient({
				["0"]   = { Color = Color3.fromHex("#2c2519"), Transparency = 0 },
				["100"] = { Color = Color3.fromHex("#16120d"), Transparency = 0 },
			}, { Rotation = 90 }),
			Icon = Color3.fromHex("#e0c27a"),
			Toggle = Color3.fromHex("#d9b96a"),
			Slider = Color3.fromHex("#c9a961"),
			Checkbox = Color3.fromHex("#d9b96a"),
			SliderIcon = Color3.fromHex("#f3e1ae"),
			Primary = Color3.fromHex("#d9b96a"),
			Background = lib:Gradient({
				["0"]   = { Color = Color3.fromHex("#080604"), Transparency = 0.1 },
				["100"] = { Color = Color3.fromHex("#1b150e"), Transparency = 0.1 },
			}, { Rotation = 125 }),
			PanelBackground = Color3.fromHex("#100d09"),
			PanelBackgroundTransparency = 0.18,
			LabelBackground = Color3.fromHex("#000000"),
			LabelBackgroundTransparency = 0.7,
			ElementBackground = Color3.fromHex("#1d1912"),
			ElementBackgroundTransparency = 0.2,
		})
		lib:SetTheme("Napoleon")
	end)
end

ApplyTheme(WindUI)

local function ApplyKeyTheme(lib)
	pcall(function()
		lib:AddTheme({
			Name = "NapoleonKeys",
			Accent = lib:Gradient({
				["0"]   = { Color = Color3.fromHex("#f9ecc0"), Transparency = 0 },
				["50"]  = { Color = Color3.fromHex("#cfae63"), Transparency = 0 },
				["100"] = { Color = Color3.fromHex("#6b5224"), Transparency = 0 },
			}, { Rotation = 90 }),
			Dialog = Color3.fromHex("#070503"),
			Outline = Color3.fromHex("#cfae63"),
			Text = Color3.fromHex("#f7edd8"),
			Placeholder = Color3.fromHex("#8a7a5c"),
			Button = lib:Gradient({
				["0"]   = { Color = Color3.fromHex("#2e2718"), Transparency = 0 },
				["100"] = { Color = Color3.fromHex("#15110c"), Transparency = 0 },
			}, { Rotation = 90 }),
			Icon = Color3.fromHex("#f3e1ae"),
			Toggle = Color3.fromHex("#d9b96a"),
			Slider = Color3.fromHex("#c9a961"),
			Checkbox = Color3.fromHex("#d9b96a"),
			SliderIcon = Color3.fromHex("#f3e1ae"),
			Primary = Color3.fromHex("#d9b96a"),
			Background = lib:Gradient({
				["0"]   = { Color = Color3.fromHex("#050403"), Transparency = 0.08 },
				["100"] = { Color = Color3.fromHex("#1c1610"), Transparency = 0.08 },
			}, { Rotation = 135 }),
			PanelBackground = Color3.fromHex("#0e0c09"),
			PanelBackgroundTransparency = 0.18,
			LabelBackground = Color3.fromHex("#000000"),
			LabelBackgroundTransparency = 0.65,
			ElementBackground = Color3.fromHex("#1a1610"),
			ElementBackgroundTransparency = 0.18,
		})
		lib:SetTheme("NapoleonKeys")
	end)
end

local function CallFirst(obj, names, data)
	if not obj then return nil end
	for _, m in ipairs(names) do
		if type(obj[m]) == "function" then
			local ok, res = pcall(obj[m], obj, data)
			if ok then return res or true end
		end
	end
	return nil
end

local function AddTag(window, data)       return CallFirst(window, { "Tag", "CreateTag", "AddTag" }, data) end
local function AddTab(window, data)       return CallFirst(window, { "Tab", "AddTab", "CreateTab" }, data) end
local function AddSection(tab, data)      return CallFirst(tab, { "Section", "AddSection", "CreateSection" }, data) end
local function AddParagraph(tab, data)    return CallFirst(tab, { "Paragraph", "AddParagraph", "CreateParagraph" }, data) end
local function AddButton(tab, data)       return CallFirst(tab, { "Button", "AddButton", "CreateButton" }, data) end
local function AddToggle(tab, data)       return CallFirst(tab, { "Toggle", "AddToggle", "CreateToggle" }, data) end
local function AddSlider(tab, data)       return CallFirst(tab, { "Slider", "AddSlider", "CreateSlider" }, data) end
local function AddDropdown(tab, data)     return CallFirst(tab, { "Dropdown", "AddDropdown", "CreateDropdown" }, data) end
local function AddInput(tab, data)        return CallFirst(tab, { "Input", "AddInput", "CreateInput", "TextBox" }, data) end

local function SetParagraph(paragraph, title, desc)
	if not paragraph or paragraph == true then return end
	pcall(function() paragraph:SetTitle(title) end)
	pcall(function() paragraph:SetDesc(desc) end)
end

local function Notify(data)
	if not WindUI then return end
	if type(WindUI.Notify) == "function" then
		pcall(function() WindUI:Notify(data) end)
	elseif WindUI.Notification and type(WindUI.Notification) == "function" then
		pcall(function() WindUI:Notification(data) end)
	end
end

local ImperialFX = { Osc = {}, Spin = {}, Pulse = {} }
local function RegisterOscGrad(g)  table.insert(ImperialFX.Osc, g)  end
local function RegisterSpinGrad(g) table.insert(ImperialFX.Spin, g) end
local function RegisterPulse(s)    table.insert(ImperialFX.Pulse, s) end

task.spawn(function()
	while Alive() do
		local t = tickFn()
		for i = #ImperialFX.Osc, 1, -1 do
			local g = ImperialFX.Osc[i]
			if g and g.Parent then pcall(function() g.Rotation = 90 + 18 * math.sin(t * 1.6) end)
			else table.remove(ImperialFX.Osc, i) end
		end
		for i = #ImperialFX.Spin, 1, -1 do
			local g = ImperialFX.Spin[i]
			if g and g.Parent then pcall(function() g.Rotation = (t * 25) % 360 end)
			else table.remove(ImperialFX.Spin, i) end
		end
		for i = #ImperialFX.Pulse, 1, -1 do
			local s = ImperialFX.Pulse[i]
			if s and s.Parent then pcall(function() s.Transparency = 0.45 + 0.2 * math.sin(t * 2.2) end)
			else table.remove(ImperialFX.Pulse, i) end
		end
		task.wait()
	end
end)

local ImperialStyler = { Attached = {} }

local function SafeFont(...)
	local ok, f = pcall(Font.new, ...)
	if ok then return f end
	return nil
end

local FONT_TITLE = SafeFont(Enum.Font.Bodoni, Enum.FontWeight.Bold, Enum.FontStyle.Normal)
	or SafeFont("rbxasset://fonts/families/Bodoni.json", Enum.FontWeight.Bold, Enum.FontStyle.Normal)
local FONT_BIG   = SafeFont("rbxasset://fonts/families/BuilderSans.json", Enum.FontWeight.SemiBold, Enum.FontStyle.Normal)
local FONT_BODY  = SafeFont("rbxasset://fonts/families/BuilderSans.json", Enum.FontWeight.Medium, Enum.FontStyle.Normal)
local FONT_TAG   = SafeFont("rbxasset://fonts/families/RomanAntique.json", Enum.FontWeight.Regular, Enum.FontStyle.Normal)

local function ApplyFont(obj, face, legacyEnum)
	if face then
		local ok = pcall(function() obj.FontFace = face end)
		if ok then return end
	end
	if legacyEnum then
		pcall(function() obj.Font = legacyEnum end)
	end
end

local IMPERIAL_GOLD_HI  = Color3.fromHex("#f9ecc0")
local IMPERIAL_GOLD_MID = Color3.fromHex("#d9b96a")
local IMPERIAL_GOLD_LO  = Color3.fromHex("#8a6a2f")

local function IsWindUiGui(gui)
	return gui:IsA("ScreenGui") and (gui.Name == "WindUI" or gui.Name:find("WindUI") ~= nil)
end

local function GetGuiParents()
	local parents = { CoreGui, PlayerGui }
	pcall(function()
		local h = gethui and gethui()
		if h then table.insert(parents, h) end
	end)
	return parents
end

local function StyleElement(obj)
	pcall(function()
		if not (obj:IsA("TextLabel") or obj:IsA("TextButton") or obj:IsA("TextBox")) then return end

		local txt = tostring(obj.Text or "")
		local lowerName = string.lower(obj.Name or "")

		if txt:find("NAPOLEON HUB") then
			ApplyFont(obj, FONT_TITLE, Enum.Font.Bodoni)
			if obj.TextSize < 19 then obj.TextSize = 20 end
			obj.TextColor3 = IMPERIAL_GOLD_HI

			if not obj:FindFirstChild("ImperialTitleGrad") then
				local grad = Instance.new("UIGradient")
				grad.Name = "ImperialTitleGrad"
				grad.Color = ColorSequence.new({
					ColorSequenceKeypoint.new(0,    IMPERIAL_GOLD_HI),
					ColorSequenceKeypoint.new(0.55, IMPERIAL_GOLD_MID),
					ColorSequenceKeypoint.new(1,    IMPERIAL_GOLD_LO),
				})
				grad.Rotation = 90
				grad.Parent = obj
				RegisterOscGrad(grad)
			end

			if not obj:FindFirstChild("ImperialTitleStroke") then
				local stroke = Instance.new("UIStroke")
				stroke.Name = "ImperialTitleStroke"
				stroke.Color = Color3.fromHex("#3a2c12")
				stroke.Transparency = 0.25
				stroke.Thickness = 1
				stroke.ApplyStrokeMode = Enum.ApplyStrokeMode.Contextual
				stroke.Parent = obj
			end
			return
		end

		if lowerName:find("tag") or (obj.Parent and string.lower(obj.Parent.Name or ""):find("tag")) then
			ApplyFont(obj, FONT_TAG, Enum.Font.Antique)
			return
		end

		if (obj.TextSize or 14) >= 17 then
			ApplyFont(obj, FONT_BIG, Enum.Font.GothamBold)
		else
			ApplyFont(obj, FONT_BODY, Enum.Font.Gotham)
		end
	end)
end

task.spawn(function()
	while Alive() do
		for gui in pairs(ImperialStyler.Attached) do
			if not gui or not gui.Parent then ImperialStyler.Attached[gui] = nil end
		end

		for _, parent in ipairs(GetGuiParents()) do
			pcall(function()
				for _, gui in ipairs(parent:GetChildren()) do
					if IsWindUiGui(gui) and not ImperialStyler.Attached[gui] then
						ImperialStyler.Attached[gui] = true
						for _, d in ipairs(gui:GetDescendants()) do StyleElement(d) end
						gui.DescendantAdded:Connect(function(d)
							task.defer(function() StyleElement(d) end)
						end)
					end
				end
			end)
		end
		task.wait(2)
	end
end)

local NapoleonUserCards = {}
local NapoleonThumb = nil

task.spawn(function()
	local ok, thumb = pcall(function()
		return Players:GetUserThumbnailAsync(Player.UserId, Enum.ThumbnailType.HeadShot, Enum.ThumbnailSize.Size150x150)
	end)
	if ok and thumb then
		NapoleonThumb = thumb
		for _, card in ipairs(NapoleonUserCards) do
			pcall(function()
				local av = card:FindFirstChild("Avatar")
				if av then av.Image = thumb end
			end)
		end
	end
end)

local function GetLargestWindowFrame(gui)
	local vp = Vector2.new(1920, 1080)
	pcall(function() vp = Workspace.CurrentCamera.ViewportSize end)
	local root, bestArea = nil, 0
	for _, obj in ipairs(gui:GetDescendants()) do
		if (obj:IsA("Frame") or obj:IsA("CanvasGroup")) and obj.Visible then
			local abs = obj.AbsoluteSize
			if abs.X >= 300 and abs.Y >= 250 and abs.X <= vp.X * .95 and abs.Y <= vp.Y * .95 then
				local area = abs.X * abs.Y
				if area > bestArea then bestArea = area root = obj end
			end
		end
	end
	return root
end

local function AddUserCard(gui)
	if #NapoleonUserCards > 0 then return end
	local root = GetLargestWindowFrame(gui)
	if not root then return end
	if root.AbsoluteSize.X < 600 then return end
	if root:FindFirstChild("NapoleonUserCard") then return end

	local glow = root:FindFirstChild("ImperialWindowGlow")
	if not glow then
		glow = Instance.new("UIStroke")
		glow.Name = "ImperialWindowGlow"
		glow.Color = Color3.fromHex("#e8d5a0")
		glow.Thickness = 1.5
		glow.Transparency = 0.55
		glow.ApplyStrokeMode = Enum.ApplyStrokeMode.Border
		glow.Parent = root
		local gg = Instance.new("UIGradient")
		gg.Color = ColorSequence.new({
			ColorSequenceKeypoint.new(0,   Color3.fromHex("#7a5e28")),
			ColorSequenceKeypoint.new(0.5, Color3.fromHex("#f9ecc0")),
			ColorSequenceKeypoint.new(1,   Color3.fromHex("#7a5e28")),
		})
		gg.Parent = glow
		RegisterSpinGrad(gg)
		RegisterPulse(glow)
	end

	local card = Instance.new("Frame")
	card.Name = "NapoleonUserCard"
	card.AnchorPoint = Vector2.new(0, 1)
	card.Position = UDim2.new(0, 14, 1, -14)
	card.Size = UDim2.new(0, 168, 0, 56)
	card.BackgroundColor3 = Color3.fromHex("#12100c")
	card.BackgroundTransparency = 0.12
	card.ZIndex = 60
	card.Parent = root

	local cc = Instance.new("UICorner")
	cc.CornerRadius = UDim.new(0, 10)
	cc.Parent = card

	local st = Instance.new("UIStroke")
	st.Color = Color3.fromHex("#c9a961")
	st.Thickness = 1
	st.Transparency = 0.35
	st.Parent = card

	local bgGrad = Instance.new("UIGradient")
	bgGrad.Color = ColorSequence.new({
		ColorSequenceKeypoint.new(0, Color3.fromHex("#221c12")),
		ColorSequenceKeypoint.new(1, Color3.fromHex("#0b0906")),
	})
	bgGrad.Rotation = 90
	bgGrad.Parent = card

	local avatar = Instance.new("ImageLabel")
	avatar.Name = "Avatar"
	avatar.Size = UDim2.new(0, 34, 0, 34)
	avatar.Position = UDim2.new(0, 6, 0.5, 0)
	avatar.AnchorPoint = Vector2.new(0, 0.5)
	avatar.BackgroundColor3 = Color3.fromHex("#0a0806")
	avatar.BackgroundTransparency = 0
	avatar.Image = NapoleonThumb or "rbxassetid://6031091004"
	avatar.ScaleType = Enum.ScaleType.Crop
	avatar.ZIndex = 61
	avatar.Parent = card

	local ac = Instance.new("UICorner")
	ac.CornerRadius = UDim.new(1, 0)
	ac.Parent = avatar

	local ast = Instance.new("UIStroke")
	ast.Color = Color3.fromHex("#e8d5a0")
	ast.Thickness = 1.5
	ast.Transparency = 0.15
	ast.Parent = avatar

	local dot = Instance.new("Frame")
	dot.Name = "OnlineDot"
	dot.Size = UDim2.new(0, 10, 0, 10)
	dot.Position = UDim2.new(1, -4, 1, -4)
	dot.AnchorPoint = Vector2.new(0.5, 0.5)
	dot.BackgroundColor3 = Color3.fromRGB(90, 220, 120)
	dot.BorderSizePixel = 0
	dot.ZIndex = 63
	dot.Parent = avatar

	local dc = Instance.new("UICorner")
	dc.CornerRadius = UDim.new(1, 0)
	dc.Parent = dot

	local dst = Instance.new("UIStroke")
	dst.Color = Color3.fromHex("#0b0906")
	dst.Thickness = 1.5
	dst.Parent = dot

	local nameLbl = Instance.new("TextLabel")
	nameLbl.Name = "DisplayName"
	nameLbl.Size = UDim2.new(1, -52, 0, 18)
	nameLbl.Position = UDim2.new(0, 46, 0, 8)
	nameLbl.BackgroundTransparency = 1
	nameLbl.Text = tostring(Player.DisplayName)
	nameLbl.TextColor3 = Color3.fromHex("#e8d5a0")
	nameLbl.TextSize = 13
	nameLbl.Font = Enum.Font.GothamBold
	nameLbl.TextXAlignment = Enum.TextXAlignment.Left
	nameLbl.TextTruncate = Enum.TextTruncate.AtEnd
	nameLbl.ZIndex = 61
	nameLbl.Parent = card

	local userLbl = Instance.new("TextLabel")
	userLbl.Name = "Username"
	userLbl.Size = UDim2.new(1, -52, 0, 14)
	userLbl.Position = UDim2.new(0, 46, 0, 27)
	userLbl.BackgroundTransparency = 1
	userLbl.Text = "@" .. tostring(Player.Name)
	userLbl.TextColor3 = Color3.fromHex("#8a7a5c")
	userLbl.TextSize = 11
	userLbl.Font = Enum.Font.Gotham
	userLbl.TextXAlignment = Enum.TextXAlignment.Left
	userLbl.TextTruncate = Enum.TextTruncate.AtEnd
	userLbl.ZIndex = 61
	userLbl.Parent = card

	local crown = Instance.new("ImageLabel")
	crown.Name = "Crown"
	crown.Size = UDim2.new(0, 16, 0, 16)
	crown.Position = UDim2.new(1, -22, 0.5, 0)
	crown.AnchorPoint = Vector2.new(0, 0.5)
	crown.BackgroundTransparency = 1
	crown.Image = "rbxassetid://6031091004"
	crown.ImageColor3 = Color3.fromHex("#c9a961")
	crown.ZIndex = 61
	crown.Parent = card

	table.insert(NapoleonUserCards, card)
end

task.spawn(function()
	while Alive() do
		for _, parent in ipairs(GetGuiParents()) do
			pcall(function()
				for _, gui in ipairs(parent:GetChildren()) do
					if IsWindUiGui(gui) then
						local r = GetLargestWindowFrame(gui)
						if r and r.AbsoluteSize.X < 600 then
							local c = r:FindFirstChild("NapoleonUserCard")
							if c then c:Destroy() end
						end
						AddUserCard(gui)
					end
				end
			end)
		end

		for i = #NapoleonUserCards, 1, -1 do
			if not NapoleonUserCards[i] or not NapoleonUserCards[i].Parent then
				table.remove(NapoleonUserCards, i)
			end
		end

		task.wait(1)
	end
end)

local NapoleonBgs = {}
local NapoleonBgThread = nil

local function RefreshNapoleonBgs()
	for i = #NapoleonBgs, 1, -1 do
		local holder = NapoleonBgs[i]
		if holder and holder.Parent then
			local img = holder:FindFirstChild("NapoleonImg")
			if img then
				img.ImageTransparency = 0.55
				img.ImageColor3 = Color3.fromRGB(255, 240, 210)
			end
		else
			table.remove(NapoleonBgs, i)
		end
	end
end

local function ApplyNapoleonBackground()
	if NapoleonBgThread then
		pcall(task.cancel, NapoleonBgThread)
		NapoleonBgThread = nil
	end

	NapoleonBgThread = task.spawn(function()
		local function GetParents()
			local parents = {}
			pcall(function() table.insert(parents, CoreGui) end)
			pcall(function() table.insert(parents, PlayerGui) end)
			pcall(function()
				local h = gethui and gethui()
				if h then table.insert(parents, h) end
			end)
			return parents
		end

		local function Decorate(gui)
			if not gui or not gui.Parent then return end

			local vp = Vector2.new(1920, 1080)
			pcall(function() vp = Workspace.CurrentCamera.ViewportSize end)

			local windowRoot, bestArea = nil, 0
			for _, obj in ipairs(gui:GetDescendants()) do
				if (obj:IsA("Frame") or obj:IsA("CanvasGroup")) and obj.Visible then
					local abs = obj.AbsoluteSize
					local pos = obj.AbsolutePosition
					if abs.X >= 400 and abs.Y >= 300
						and abs.X <= vp.X * 0.95 and abs.Y <= vp.Y * 0.95
						and pos.X >= 0 and pos.Y >= 0 then
						local area = abs.X * abs.Y
						if area > bestArea then
							bestArea = area
							windowRoot = obj
						end
					end
				end
			end
			if not windowRoot then return end

			local rootPos = windowRoot.AbsolutePosition
			local panel, panelArea = nil, 0
			for _, obj in ipairs(windowRoot:GetDescendants()) do
				if (obj:IsA("Frame") or obj:IsA("CanvasGroup") or obj:IsA("ScrollingFrame")) and obj.Visible then
					local pos = obj.AbsolutePosition
					local abs = obj.AbsoluteSize
					if pos.X >= rootPos.X + 100 and abs.X >= 200 and abs.Y >= 150
						and abs.X <= vp.X * 0.95 and abs.Y <= vp.Y * 0.95 then
						local area = abs.X * abs.Y
						if area > panelArea then
							panelArea = area
							panel = obj
						end
					end
				end
			end

			local container = panel or windowRoot
			pcall(function() container.ClipsDescendants = true end)

			for _, h in ipairs(container:GetChildren()) do
				if h.Name == "NapoleonWatermark" then return end
			end

			local holder = Instance.new("Frame")
			holder.Name = "NapoleonWatermark"
			holder.BackgroundTransparency = 1
			holder.Size = UDim2.fromScale(1, 1)
			holder.Position = UDim2.fromScale(0, 0)
			holder.ZIndex = 0
			holder.ClipsDescendants = true
			holder.Parent = container

			local corner = Instance.new("UICorner")
			corner.CornerRadius = UDim.new(0, 8)
			corner.Parent = holder

			local img = Instance.new("ImageLabel")
			img.Name = "NapoleonImg"
			img.Image = NAPOLEON_IMG
			img.ImageTransparency = 0.55
			img.ImageColor3 = Color3.fromRGB(255, 240, 210)
			img.BackgroundTransparency = 1
			img.Size = UDim2.fromScale(1, 1)
			img.Position = UDim2.fromScale(0, 0)
			img.ZIndex = 0
			img.ScaleType = Enum.ScaleType.Fit
			img.Parent = holder

			local grad = Instance.new("UIGradient")
			grad.Transparency = NumberSequence.new({
				NumberSequenceKeypoint.new(0, 0.05),
				NumberSequenceKeypoint.new(0.5, 0.35),
				NumberSequenceKeypoint.new(1, 0.65),
			})
			grad.Rotation = 90
			grad.Parent = img

			local grad2 = Instance.new("UIGradient")
			grad2.Transparency = NumberSequence.new({
				NumberSequenceKeypoint.new(0, 0.55),
				NumberSequenceKeypoint.new(0.25, 1),
				NumberSequenceKeypoint.new(1, 1),
			})
			grad2.Rotation = 0
			grad2.Parent = img

			table.insert(NapoleonBgs, holder)
			RefreshNapoleonBgs()
		end

		while Alive() do
			for _, parent in ipairs(GetParents()) do
				pcall(function()
					for _, gui in ipairs(parent:GetChildren()) do
						if IsWindUiGui(gui) then
							Decorate(gui)
						end
					end
				end)
			end
			task.wait(1)
		end
	end)
end

local Character, Humanoid, Root
local function UpdateCharacter(char)
	Character = char
	Humanoid = char:WaitForChild("Humanoid", 5)
	Root = char:WaitForChild("HumanoidRootPart", 5)
end
UpdateCharacter(Player.Character or Player.CharacterAdded:Wait())
Player.CharacterAdded:Connect(function(char)
	task.wait(.2)
	UpdateCharacter(char)
end)

local function ClearWindUI()
	for _, parent in ipairs(GetGuiParents()) do
		pcall(function()
			for _, gui in ipairs(parent:GetChildren()) do
				if IsWindUiGui(gui) then
					pcall(function()
						local old = gui:FindFirstChild("NapoleonWatermark", true)
						if old then old:Destroy() end
						local card = gui:FindFirstChild("NapoleonUserCard", true)
						if card then card:Destroy() end
					end)
					gui:Destroy()
				end
			end
		end)
	end
	table.clear(NapoleonBgs)
	table.clear(NapoleonUserCards)
end

local function FreshWindUI(themeName)
	ClearWindUI()
	task.wait(0.3)
	WindUI = LoadWindUI()
	ApplyTheme(WindUI)
	if themeName == "NapoleonKeys" then
		ApplyKeyTheme(WindUI)
		pcall(function() WindUI:SetTheme("NapoleonKeys") end)
	end
end

local LoadingGui, LoadingDone, LoadingConn = nil, false, nil
local LoadingState = { Target = 0, Shown = 0, Step = 0 }

local LOADING_STEPS = {
	{ at = 0,   msg = "Preparando o Imperio..." },
	{ at = 20,  msg = "Carregando modulos..." },
	{ at = 45,  msg = "Afiando as espadas..." },
	{ at = 70,  msg = "Posicionando as tropas..." },
	{ at = 90,  msg = "Coroando o General..." },
	{ at = 100, msg = "Imperio pronto!" },
}

local LOADING_TIPS = {
	"Dica: aperte K para abrir e fechar o hub.",
	"Dica: ajuste a distancia de defesa na aba Defesa.",
	"Dica: use Trajetoria para ver a previsao da bola.",
	"Dica: entre no Discord para novidades e keys.",
}

local function Tw(obj, t, props, style, dir)
	local tw = TweenService:Create(
		obj,
		TweenInfo.new(t, style or Enum.EasingStyle.Quad, dir or Enum.EasingDirection.Out),
		props
	)
	tw:Play()
	return tw
end

local function SetLoadingTarget(p)
	LoadingState.Target = math.max(LoadingState.Target, math.min(p, 100))
end

local function ShowLoading()
	pcall(function()
		if LoadingConn then LoadingConn:Disconnect() LoadingConn = nil end
		if LoadingGui then LoadingGui:Destroy() end
	end)
	LoadingDone = false
	LoadingState.Target, LoadingState.Shown, LoadingState.Step = 0, 0, 0
	LoadingState.Mul, LoadingState.MulTarget = 0.92, 1
	for _, p in ipairs(GetGuiParents()) do
		pcall(function()
			for _, g in ipairs(p:GetChildren()) do
				if g.Name == "NapoleonLoading" then g:Destroy() end
			end
		end)
	end

	local parent = PlayerGui
	pcall(function()
		local h = gethui and gethui()
		if h then parent = h end
	end)

	local GOLD_HI  = Color3.fromHex("#f9ecc0")
	local GOLD_MID = Color3.fromHex("#c9a961")
	local GOLD_LO  = Color3.fromHex("#7a5e28")

	pcall(function()
		local old = Lighting:FindFirstChild("NapoleonLoadBlur")
		if old then old:Destroy() end
		local b = Instance.new("BlurEffect")
		b.Name = "NapoleonLoadBlur"
		b.Size = 0
		b.Parent = Lighting
		Tw(b, 0.6, { Size = 16 })
	end)

	local gui = Instance.new("ScreenGui")
	gui.Name = "NapoleonLoading"
	gui.IgnoreGuiInset = true
	gui.DisplayOrder = 999
	pcall(function() gui.ScreenInsets = Enum.ScreenInsets.None end)
	gui.ResetOnSpawn = false
	gui.Parent = parent
	LoadingGui = gui

	local root = Instance.new("CanvasGroup")
	root.Name = "Root"
	root.Size = UDim2.fromScale(1, 1)
	root.BackgroundColor3 = Color3.fromHex("#070605")
	root.BorderSizePixel = 0
	root.GroupTransparency = 1
	root.Parent = gui

	local rootGrad = Instance.new("UIGradient")
	rootGrad.Color = ColorSequence.new({
		ColorSequenceKeypoint.new(0, Color3.fromHex("#050403")),
		ColorSequenceKeypoint.new(0.5, Color3.fromHex("#15100a")),
		ColorSequenceKeypoint.new(1, Color3.fromHex("#050403")),
	})
	rootGrad.Rotation = 125
	rootGrad.Parent = root

	for _, top in ipairs({ true, false }) do
		local v = Instance.new("Frame")
		v.Size = UDim2.new(1, 0, 0.3, 0)
		v.Position = top and UDim2.fromScale(0, 0) or UDim2.fromScale(0, 0.7)
		v.BackgroundColor3 = Color3.new(0, 0, 0)
		v.BorderSizePixel = 0
		v.ZIndex = 2
		v.Parent = root
		local g = Instance.new("UIGradient")
		g.Rotation = top and 90 or 270
		g.Transparency = NumberSequence.new({
			NumberSequenceKeypoint.new(0, 0.1),
			NumberSequenceKeypoint.new(1, 1),
		})
		g.Parent = v
	end

	local particles = {}
	for i = 1, 28 do
		local p = Instance.new("Frame")
		local size = math.random(2, 5)
		p.Size = UDim2.fromOffset(size, size)
		p.BackgroundColor3 = (i % 2 == 0) and GOLD_HI or GOLD_MID
		p.BorderSizePixel = 0
		p.ZIndex = 1
		p.Parent = root
		local c = Instance.new("UICorner")
		c.CornerRadius = UDim.new(1, 0)
		c.Parent = p
		particles[i] = {
			f = p,
			x = math.random(),
			y = math.random(),
			speed = 0.02 + math.random() * 0.05,
			phase = math.random() * 6.28,
			base = 0.35 + math.random() * 0.4,
		}
	end

	local center = Instance.new("Frame")
	center.Name = "Center"
	center.Size = UDim2.fromOffset(440, 340)
	center.Position = UDim2.fromScale(0.5, 0.5)
	center.AnchorPoint = Vector2.new(0.5, 0.5)
	center.BackgroundTransparency = 1
	center.ZIndex = 5
	center.Parent = root

	local scale = Instance.new("UIScale")
	scale.Scale = 1
	scale.Parent = center

	local function MakeRing(size, thickness, trans)
		local ring = Instance.new("Frame")
		ring.Size = UDim2.fromOffset(size, size)
		ring.Position = UDim2.new(0.5, 0, 0, 70)
		ring.AnchorPoint = Vector2.new(0.5, 0.5)
		ring.BackgroundTransparency = 1
		ring.ZIndex = 5
		ring.Parent = center
		local rc = Instance.new("UICorner")
		rc.CornerRadius = UDim.new(1, 0)
		rc.Parent = ring
		local rs = Instance.new("UIStroke")
		rs.Color = GOLD_HI
		rs.Thickness = thickness
		rs.Transparency = trans
		rs.Parent = ring
		local rg = Instance.new("UIGradient")
		rg.Transparency = NumberSequence.new({
			NumberSequenceKeypoint.new(0, 0),
			NumberSequenceKeypoint.new(0.6, 0),
			NumberSequenceKeypoint.new(0.601, 1),
			NumberSequenceKeypoint.new(1, 1),
		})
		rg.Parent = rs
		return ring, rg, rs
	end
	local ring1, ring1g = MakeRing(124, 2.5, 0)
	local ring2, ring2g = MakeRing(100, 1.5, 0.25)

	local emblem = Instance.new("TextLabel")
	emblem.Size = UDim2.fromOffset(80, 80)
	emblem.Position = UDim2.new(0.5, 0, 0, 70)
	emblem.AnchorPoint = Vector2.new(0.5, 0.5)
	emblem.BackgroundTransparency = 1
	emblem.Text = "N"
	emblem.Font = Enum.Font.Bodoni
	emblem.TextSize = 54
	emblem.TextColor3 = GOLD_HI
	emblem.TextTransparency = 1
	emblem.ZIndex = 6
	emblem.Parent = center
	local emblemGrad = Instance.new("UIGradient")
	emblemGrad.Color = ColorSequence.new({
		ColorSequenceKeypoint.new(0, GOLD_HI),
		ColorSequenceKeypoint.new(1, GOLD_LO),
	})
	emblemGrad.Rotation = 90
	emblemGrad.Parent = emblem

	local titleHolder = Instance.new("Frame")
	titleHolder.Size = UDim2.new(1, 0, 0, 40)
	titleHolder.Position = UDim2.new(0, 0, 0, 150)
	titleHolder.BackgroundTransparency = 1
	titleHolder.ZIndex = 5
	titleHolder.Parent = center
	local tl = Instance.new("UIListLayout")
	tl.FillDirection = Enum.FillDirection.Horizontal
	tl.HorizontalAlignment = Enum.HorizontalAlignment.Center
	tl.VerticalAlignment = Enum.VerticalAlignment.Center
	tl.Padding = UDim.new(0, 2)
	tl.SortOrder = Enum.SortOrder.LayoutOrder
	tl.Parent = titleHolder

	local word = "NAPOLEON HUB"
	for i = 1, #word do
		local ch = word:sub(i, i)
		local l = Instance.new("TextLabel")
		l.LayoutOrder = i
		l.BackgroundTransparency = 1
		if ch == " " then
			l.Size = UDim2.fromOffset(14, 40)
			l.Text = ""
		else
			l.AutomaticSize = Enum.AutomaticSize.X
			l.Size = UDim2.fromOffset(0, 40)
			l.Text = ch
		end
		l.Font = Enum.Font.Bodoni
		l.TextSize = 30
		l.TextColor3 = GOLD_HI
		l.TextTransparency = 1
		l.ZIndex = 6
		l.Parent = titleHolder
		local lg = Instance.new("UIGradient")
		lg.Color = ColorSequence.new({
			ColorSequenceKeypoint.new(0, GOLD_HI),
			ColorSequenceKeypoint.new(0.6, GOLD_MID),
			ColorSequenceKeypoint.new(1, GOLD_LO),
		})
		lg.Rotation = 90
		lg.Parent = l
		task.delay(0.3 + i * 0.05, function()
			if l and l.Parent then Tw(l, 0.45, { TextTransparency = 0 }) end
		end)
	end

	local sub = Instance.new("TextLabel")
	sub.Size = UDim2.new(1, 0, 0, 16)
	sub.Position = UDim2.new(0, 0, 0, 190)
	sub.BackgroundTransparency = 1
	sub.Text = "IMPERIO DO GOL - V3"
	sub.Font = Enum.Font.Gotham
	sub.TextSize = 11
	sub.TextColor3 = Color3.fromHex("#8a7a5c")
	sub.TextTransparency = 1
	sub.ZIndex = 6
	sub.Parent = center

	local status = Instance.new("TextLabel")
	status.Name = "Status"
	status.Size = UDim2.new(1, 0, 0, 18)
	status.Position = UDim2.new(0, 0, 0, 228)
	status.BackgroundTransparency = 1
	status.Text = LOADING_STEPS[1].msg
	status.Font = Enum.Font.GothamMedium
	status.TextSize = 13
	status.TextColor3 = Color3.fromHex("#d9c9a0")
	status.ZIndex = 6
	status.Parent = center

	local barBg = Instance.new("Frame")
	barBg.Size = UDim2.new(1, -80, 0, 6)
	barBg.Position = UDim2.new(0, 40, 0, 258)
	barBg.BackgroundColor3 = Color3.fromHex("#1a1610")
	barBg.BorderSizePixel = 0
	barBg.ZIndex = 6
	barBg.Parent = center
	local bbc = Instance.new("UICorner")
	bbc.CornerRadius = UDim.new(1, 0)
	bbc.Parent = barBg
	local bbs = Instance.new("UIStroke")
	bbs.Color = GOLD_MID
	bbs.Transparency = 0.7
	bbs.Parent = barBg

	local fill = Instance.new("Frame")
	fill.Size = UDim2.new(0, 0, 1, 0)
	fill.BackgroundColor3 = GOLD_MID
	fill.BorderSizePixel = 0
	fill.ZIndex = 7
	fill.Parent = barBg
	local fc = Instance.new("UICorner")
	fc.CornerRadius = UDim.new(1, 0)
	fc.Parent = fill
	local fillGrad = Instance.new("UIGradient")
	fillGrad.Color = ColorSequence.new({
		ColorSequenceKeypoint.new(0, GOLD_LO),
		ColorSequenceKeypoint.new(0.5, GOLD_HI),
		ColorSequenceKeypoint.new(1, GOLD_MID),
	})
	fillGrad.Parent = fill

	local pct = Instance.new("TextLabel")
	pct.Size = UDim2.new(1, 0, 0, 16)
	pct.Position = UDim2.new(0, 0, 0, 274)
	pct.BackgroundTransparency = 1
	pct.Text = "0%"
	pct.Font = Enum.Font.GothamBold
	pct.TextSize = 12
	pct.TextColor3 = GOLD_MID
	pct.ZIndex = 6
	pct.Parent = center

	local tip = Instance.new("TextLabel")
	tip.Size = UDim2.new(1, 0, 0, 16)
	tip.Position = UDim2.new(0, 0, 0, 308)
	tip.BackgroundTransparency = 1
	tip.Text = LOADING_TIPS[1]
	tip.Font = Enum.Font.Gotham
	tip.TextSize = 11
	tip.TextColor3 = Color3.fromHex("#8a7a5c")
	tip.ZIndex = 6
	tip.Parent = center

	Tw(root, 0.5, { GroupTransparency = 0 })
	Tw(emblem, 0.6, { TextTransparency = 0 })
	Tw(sub, 0.8, { TextTransparency = 0 })

	task.spawn(function()
		local i = 1
		while gui.Parent and not LoadingDone do
			task.wait(2.2)
			if LoadingDone or not tip.Parent then break end
			i = i % #LOADING_TIPS + 1
			Tw(tip, 0.2, { TextTransparency = 1 })
			task.wait(0.22)
			tip.Text = LOADING_TIPS[i]
			Tw(tip, 0.2, { TextTransparency = 0 })
		end
	end)

	local function SetStatus(msg)
		task.spawn(function()
			if not status.Parent then return end
			Tw(status, 0.12, { TextTransparency = 1 })
			task.wait(0.13)
			status.Text = msg
			Tw(status, 0.15, { TextTransparency = 0 })
		end)
	end

	LoadingConn = RunService.RenderStepped:Connect(function(dt)
		local t = tickFn()

		local vp = GetViewport()
		local base = math.clamp(math.min(vp.X / 520, vp.Y / 400), 0.55, 1.25)
		LoadingState.Mul = LoadingState.Mul + (LoadingState.MulTarget - LoadingState.Mul) * math.min(1, dt * 7)
		scale.Scale = base * LoadingState.Mul

		if not LoadingDone and LoadingState.Target < 92 then
			LoadingState.Target = math.min(92, LoadingState.Target + dt * 9 * (1 - LoadingState.Target / 100))
		end
		LoadingState.Shown = LoadingState.Shown + (LoadingState.Target - LoadingState.Shown) * math.min(1, dt * 5)

		local shown = LoadingState.Shown
		fill.Size = UDim2.new(shown / 100, 0, 1, 0)
		pct.Text = math.floor(shown + 0.5) .. "%"
		fillGrad.Offset = Vector2.new(((t * 0.8) % 2) - 1, 0)

		local idx = 1
		for i, s in ipairs(LOADING_STEPS) do
			if shown >= s.at - 0.5 then idx = i end
		end
		if idx ~= LoadingState.Step then
			LoadingState.Step = idx
			SetStatus(LOADING_STEPS[idx].msg)
		end

		ring1g.Rotation = (t * 140) % 360
		ring2g.Rotation = 360 - ((t * 90) % 360)
		emblem.TextSize = 54 + math.sin(t * 2.4) * 2

		for _, p in ipairs(particles) do
			p.y = p.y - p.speed * dt
			if p.y < -0.05 then
				p.y = 1.05
				p.x = math.random()
			end
			p.f.Position = UDim2.fromScale(p.x + math.sin(t * 0.8 + p.phase) * 0.012, p.y)
			p.f.BackgroundTransparency = 1 - p.base * (0.6 + 0.4 * math.sin(t * 2 + p.phase))
		end
	end)
end

local function HideLoading()
	LoadingDone = true
	LoadingState.Target = 100
	local gui = LoadingGui
	if not gui or not gui.Parent then return end

	local t0 = tickFn()
	while LoadingState.Shown < 99.4 and tickFn() - t0 < 1.5 do task.wait() end
	task.wait(0.35)

	local root = gui:FindFirstChild("Root")
	local center = root and root:FindFirstChild("Center")
	local scale = center and center:FindFirstChildOfClass("UIScale")

	if root then Tw(root, 0.6, { GroupTransparency = 1 }) end
	LoadingState.MulTarget = 1.1
	pcall(function()
		local b = Lighting:FindFirstChild("NapoleonLoadBlur")
		if b then
			Tw(b, 0.6, { Size = 0 })
			task.delay(0.7, function() if b then b:Destroy() end end)
		end
	end)

	task.wait(0.65)
	if LoadingConn then LoadingConn:Disconnect() LoadingConn = nil end
	pcall(function() gui:Destroy() end)
	LoadingGui = nil
end

local function PolishWindow(win)
	if not win then return end
	pcall(function()
		win:EditOpenButton({
			Title = "NAPOLEON",
			Icon = "crown",
			CornerRadius = UDim.new(0, 16),
			StrokeThickness = 2,
			Color = ColorSequence.new(
				Color3.fromHex("#f9ecc0"),
				Color3.fromHex("#7a5e28")
			),
			OnlyMobile = false,
			Enabled = true,
			Draggable = true,
		})
	end)
end

local VALID_KEYS   = { ["unk acess"] = true, ["NAPOLEON-7815953992"] = true }
local SAVE_FILE    = "napoleon_key.txt"
local SAVE_TIME    = "napoleon_key_time.txt"
local KEY_DURATION = 24 * 60 * 60

local function Now()
	return os.time and os.time() or math.floor(tickFn())
end

local function CheckKey(key) return VALID_KEYS[key] == true end

local function SaveKeyTime()
	if writefile then pcall(writefile, SAVE_TIME, tostring(Now())) end
end

local function GetKeyTime()
	if not isfile or not readfile then return nil end
	local ok, timeStr = pcall(readfile, SAVE_TIME)
	if ok and timeStr then return tonumber(timeStr) end
	return nil
end

local function IsKeyExpired()
	local savedTime = GetKeyTime()
	if not savedTime then return true end
	return (Now() - savedTime) >= KEY_DURATION
end

local function GetRemainingTime()
	local savedTime = GetKeyTime()
	if not savedTime then return 0 end
	return math.max(0, KEY_DURATION - (Now() - savedTime))
end

local function FormatTime(seconds)
	seconds = math.floor(seconds)
	local h = math.floor(seconds / 3600)
	local m = math.floor((seconds % 3600) / 60)
	local s = seconds % 60
	return string.format("%02d:%02d:%02d", h, m, s)
end

local function HasValidKey()
	if not isfile or not readfile then return false end
	local ok, key = pcall(readfile, SAVE_FILE)
	if not ok or not key or not CheckKey(key) then return false end
	if IsKeyExpired() then return false end
	return true
end

local function ClearSavedKey()
	pcall(function()
		if delfile then
			if isfile and isfile(SAVE_FILE) then delfile(SAVE_FILE) end
			if isfile and isfile(SAVE_TIME) then delfile(SAVE_TIME) end
		end
	end)
end

local Cfg = {
	AutoDive = false, AutoCatch = false, Mode = "Legit",
	DiveRange = 25, CatchRange = 6,
	MinSpeed = 0, MaxSpeed = 200,
	Predict = true, PredictTime = .40,
	DiveCooldown = 0, CatchCooldown = 0.2,
	HighThreshold = 1.4, SideThreshold = 1.6,
	Theme = "Napoleon",
	DiveLead = 0.35,
	ReachActive = false,
	OrbVisual = 10,
	HitboxSize = 1,
}

local CFG_FILE = "napoleon_cfg.json"
local SAVEABLE = { "Mode", "DiveRange", "CatchRange", "MinSpeed", "MaxSpeed", "Predict", "PredictTime",
	"DiveCooldown", "CatchCooldown", "HighThreshold", "SideThreshold", "Theme", "DiveLead",
	"OrbVisual", "HitboxSize" }
pcall(function()
	if isfile and readfile and isfile(CFG_FILE) then
		local data = HttpService:JSONDecode(readfile(CFG_FILE))
		for _, k in ipairs(SAVEABLE) do
			if data[k] ~= nil and type(data[k]) == type(Cfg[k]) then Cfg[k] = data[k] end
		end
	end
end)

local SaveQueued = false
local function SaveCfg()
	if SaveQueued or not writefile then return end
	SaveQueued = true
	task.delay(1, function()
		SaveQueued = false
		pcall(function()
			local out = {}
			for _, k in ipairs(SAVEABLE) do out[k] = Cfg[k] end
			writefile(CFG_FILE, HttpService:JSONEncode(out))
		end)
	end)
end
local function SetCfg(k, v) Cfg[k] = v SaveCfg() end

local LastDive, LastCatch, KickBlockedUntil, CatchBlockedUntil = 0, 0, 0, 0
local BallControlled = false
local HasCaughtThisTurn = false
local Connection
local BallDetectionConnection = nil
local GKNames = {"High Dive Left","High Dive Right","Dive Left","Dive Right","High Catch","Low Catch","Front Dive","Reflex"}
local Buttons = {}

local OriginalFieldColors = {}
local FieldColors = {
	["Preto"]        = Color3.fromRGB(20, 20, 20),
	["Azul"]         = Color3.fromRGB(0, 102, 255),
	["Ciano"]        = Color3.fromRGB(0, 255, 255),
	["Verde"]        = Color3.fromRGB(34, 177, 76),
	["Verde Escuro"] = Color3.fromRGB(0, 80, 0),
}

local function IsFieldPart(obj)
	if not obj or not obj:IsA("BasePart") then return false end
	local name = obj.Name:lower()
	if name:find("line") or name:find("linha") or name:find("net") or name:find("rede")
		or name:find("goal") or name:find("trave") or name:find("wall") or name:find("parede") then
		return false
	end
	if obj.Color.R > 0.8 and obj.Color.G > 0.8 and obj.Color.B > 0.8 then return false end
	if name:find("grass") or name:find("pitch") or name:find("field") or name:find("grama")
		or name:find("gramado") or name:find("campo") then
		return true
	end
	if obj.Material == Enum.Material.Grass then return true end
	return false
end

local function SetFieldColor(color3)
	for _, obj in ipairs(Workspace:GetDescendants()) do
		if IsFieldPart(obj) then
			if not OriginalFieldColors[obj] then
				OriginalFieldColors[obj] = obj.Color
			end
			obj.Color = color3
		end
	end
end

local function RestoreFieldColor()
	for obj, color in pairs(OriginalFieldColors) do
		if obj and obj.Parent then obj.Color = color end
	end
	table.clear(OriginalFieldColors)
end

local PredictFolder = Instance.new("Folder")
PredictFolder.Name = "NapoleonClientPredict"
PredictFolder.Parent = Workspace
local PredictParts = {}
local LandingPart

local function ClearPredict()
	for i = #PredictParts, 1, -1 do
		local p = PredictParts[i]
		if p and p.Parent then p:Destroy() end
	end
	table.clear(PredictParts)
	if LandingPart then
		LandingPart:Destroy()
		LandingPart = nil
	end
end

local function CreateLine(a, b)
	local distance = (b - a).Magnitude
	if distance <= .01 then return end
	local p = Instance.new("Part")
	p.Name = "PredictLine"
	p.Anchored = true
	p.CanCollide = false
	p.CanTouch = false
	p.CanQuery = false
	p.Material = Enum.Material.Neon
	p.Color = Color3.fromRGB(0, 255, 255)
	p.Size = Vector3.new(.08, .08, distance)
	p.CFrame = CFrame.lookAt((a + b) / 2, b)
	p.Parent = PredictFolder
	table.insert(PredictParts, p)
end

local function CreateLanding(pos)
	if LandingPart then LandingPart:Destroy() end
	LandingPart = Instance.new("Part")
	LandingPart.Name = "LandingPoint"
	LandingPart.Shape = Enum.PartType.Ball
	LandingPart.Size = Vector3.new(.5, .5, .5)
	LandingPart.Anchored = true
	LandingPart.CanCollide = false
	LandingPart.CanTouch = false
	LandingPart.CanQuery = false
	LandingPart.Material = Enum.Material.Neon
	LandingPart.Color = Color3.fromRGB(0, 255, 255)
	LandingPart.Position = pos + Vector3.new(0, .15, 0)
	LandingPart.Parent = PredictFolder
end

local function IsBall(obj)
	if not obj or not obj:IsA("BasePart") then return false end
	if obj.Anchored then return false end
	if Character and obj:IsDescendantOf(Character) then return false end
	local model = obj:FindFirstAncestorOfClass("Model")
	if model and model:FindFirstChildOfClass("Humanoid") then return false end
	local name = obj.Name:lower()
	if name ~= "ball" and name ~= "bola" and name ~= "tps" and name ~= "football" then return false end
	return obj.Size.X >= .4 and obj.Size.X <= 8
end

local function GetBall()
	if not Root then return nil end
	local closest
	local distance = math.huge
	for _, obj in ipairs(Workspace:GetDescendants()) do
		if IsBall(obj) then
			local d = (obj.Position - Root.Position).Magnitude
			if d < distance then
				distance = d
				closest = obj
			end
		end
	end
	return closest
end

local function HighlightBall(ball)
	if not ball then return end
	local highlight = ball:FindFirstChild("NapoleonBallHighlight")
	if not highlight then
		highlight = Instance.new("Highlight")
		highlight.Name = "NapoleonBallHighlight"
		highlight.Adornee = ball
		highlight.FillColor = Color3.fromRGB(255, 0, 0)
		highlight.OutlineColor = Color3.fromRGB(255, 0, 0)
		highlight.FillTransparency = 0.4
		highlight.OutlineTransparency = 0
		highlight.Parent = ball
	end
	task.delay(10, function()
		if highlight and highlight.Parent then
			highlight:Destroy()
		end
	end)
end

local function UpdatePredict()
	if not Cfg.Predict then
		ClearPredict()
		return
	end
	local ball = GetBall()
	if not ball then
		ClearPredict()
		return
	end
	local velocity = ball.AssemblyLinearVelocity
	if velocity.Magnitude < Cfg.MinSpeed then
		ClearPredict()
		return
	end
	ClearPredict()
	local previous = ball.Position
	local gravity = Vector3.new(0, -Workspace.Gravity * 0.95, 0)
	local params = RaycastParams.new()
	params.FilterType = Enum.RaycastFilterType.Exclude
	params.FilterDescendantsInstances = {Character, ball, PredictFolder}
	local step = 0.025
	local maxSteps = math.floor(Cfg.PredictTime / step)
	for i = 1, maxSteps do
		local t = i * step
		local nextPos = ball.Position + (velocity * t) + (0.5 * gravity * (t * t))
		local result = Workspace:Raycast(previous, nextPos - previous, params)
		if result then
			CreateLine(previous, result.Position)
			CreateLanding(result.Position)
			break
		end
		CreateLine(previous, nextPos)
		previous = nextPos
	end
end

local function ScanButtons()
	table.clear(Buttons)
	if not PlayerGui then return end
	for _, obj in ipairs(PlayerGui:GetDescendants()) do
		if obj:IsA("TextButton") or obj:IsA("ImageButton") then
			local text = ""
			pcall(function() text = obj.Text end)
			for _, name in ipairs(GKNames) do
				if text:lower() == name:lower() or obj.Name:lower() == name:lower() then
					Buttons[name] = obj
					break
				end
			end
		end
	end
end

local function FindButton(name)
	local button = Buttons[name]
	if button and button.Parent then return button end
	ScanButtons()
	return Buttons[name]
end

local function Press(name)
	local button = FindButton(name)
	if not button then return false end
	local success = false
	if typeof(firesignal) == "function" then
		success = pcall(function()
			firesignal(button.Activated)
			firesignal(button.MouseButton1Click)
			pcall(function()
				firesignal(button.MouseButton1Down)
				firesignal(button.MouseButton1Up)
			end)
		end)
	end
	if not success then
		local pos = button.AbsolutePosition + (button.AbsoluteSize / 2)
		local inset = GuiService:GetGuiInset()
		VirtualInputManager:SendMouseButtonEvent(pos.X, pos.Y + inset.Y, 0, true, game, 0)
		VirtualInputManager:SendMouseButtonEvent(pos.X, pos.Y + inset.Y, 0, false, game, 0)
	end
	return true
end

local function Jump()
	if not Humanoid then return end
	pcall(function()
		Humanoid.Jump = true
		Humanoid:ChangeState(Enum.HumanoidStateType.Jumping)
	end)
end

local CatchRemote
pcall(function()
	CatchRemote = ReplicatedStorage:FindFirstChild("CatchBall", true)
end)

local function FireCatch(ball)
	if not CatchRemote then return end
	pcall(function()
		if CatchRemote:IsA("RemoteEvent") then
			CatchRemote:FireServer(ball)
		elseif CatchRemote:IsA("RemoteFunction") then
			CatchRemote:InvokeServer(ball)
		end
	end)
end

local function CheckBallControl()
	local ball = GetBall()
	if not ball or not Root then
		BallControlled = false
		return
	end
	local distance = (ball.Position - Root.Position).Magnitude
	local speed = ball.AssemblyLinearVelocity.Magnitude
	BallControlled = distance < 3.0 and speed < 4
	if distance > 6.0 then
		HasCaughtThisTurn = false
	end
end

local function BlockCatch(time)
	CatchBlockedUntil = math.max(CatchBlockedUntil, tickFn() + (time or .5))
end

local function CatchBlocked()
	return tickFn() < CatchBlockedUntil
end

local function AnalyzeDive()
	if BallControlled then return nil end
	local ball = GetBall()
	if not ball or not Root then return nil end
	local velocity = ball.AssemblyLinearVelocity
	local speed = velocity.Magnitude
	local ballPos = ball.Position
	local rootPos = Root.Position
	local distance = (ballPos - rootPos).Magnitude
	if distance < 1.0 or distance > Cfg.DiveRange then return nil end
	if speed < Cfg.MinSpeed or speed > Cfg.MaxSpeed then return nil end
	local camera = Workspace.CurrentCamera
	if not camera then return nil end
	local camCFrame = camera.CFrame
	local rightVec = Vector3.new(camCFrame.RightVector.X, 0, camCFrame.RightVector.Z).Unit
	local timeToReach = math.clamp(distance / math.max(speed, 1), 0.05, Cfg.PredictTime)
	local gravity = Vector3.new(0, -Workspace.Gravity, 0)
	local predictedPos = ballPos + (velocity * timeToReach) + (0.5 * gravity * (timeToReach * timeToReach))
	if speed > 6 then
		local ballToPlayer = (rootPos - ballPos).Unit
		local ballDir = velocity.Unit
		if ballDir:Dot(ballToPlayer) < -0.2 then return nil end
	end
	local relVector = predictedPos - rootPos
	local sideDistance = relVector:Dot(rightVec)
	local relHeight = math.max(ballPos.Y - rootPos.Y, predictedPos.Y - rootPos.Y)
	local absSide = math.abs(sideDistance)
	local high = relHeight >= Cfg.HighThreshold
	local sideName = sideDistance < 0 and "Left" or "Right"
	local action = nil
	local jump = false
	if absSide < Cfg.SideThreshold and distance <= 7 then
		if relHeight >= 0.2 then
			action = "High Catch"
		else
			action = "Low Catch"
		end
	elseif distance < 7 and speed > 35 and absSide >= Cfg.SideThreshold then
		action = "Reflex"
	elseif absSide < Cfg.SideThreshold then
		if high then
			if distance > 12 then return nil end
			action = "High Catch"
		else
			action = "Front Dive"
		end
	else
		if high then
			action = "High Dive " .. sideName
		else
			action = "Dive " .. sideName
		end
	end
	return {
		Action = action,
		Jump = jump,
		Distance = distance,
		Speed = speed,
		Ball = ball
	}
end

local function ExecuteDive()
	if Cfg.DiveCooldown > 0 and (tickFn() - LastDive < Cfg.DiveCooldown) then
		return
	end
	local info = AnalyzeDive()
	if not info or not info.Action then return end
	LastDive = tickFn()
	local isSideDive = info.Action:find("Left") or info.Action:find("Right")
	if Cfg.Mode == "Blatant" and isSideDive and info.Ball and Root then
		Root.CFrame = CFrame.new(info.Ball.Position) * (Root.CFrame - Root.CFrame.Position)
		Root.AssemblyLinearVelocity = Vector3.zero
		Root.AssemblyAngularVelocity = Vector3.zero
		FireCatch(info.Ball)
		if typeof(firetouchinterest) == "function" then
			pcall(function()
				firetouchinterest(Root, info.Ball, 0)
				firetouchinterest(Root, info.Ball, 1)
			end)
		end
	else
		if info.Jump then Jump() end
		if info.Action == "Reflex" then BlockCatch(.4) end
		Press(info.Action)
	end
end

local function BallIncoming(ball)
	if not ball or not Root then return false end
	local velocity = ball.AssemblyLinearVelocity
	local speed = velocity.Magnitude
	if speed <= 8 then return true end
	local toMe = (Root.Position - ball.Position).Unit
	return velocity.Unit:Dot(toMe) > -0.1
end

local function DoCatch(ball)
	if BallControlled or HasCaughtThisTurn then return end
	if not ball or not Root then return end
	if tickFn() - LastCatch < Cfg.CatchCooldown then return end
	LastCatch = tickFn()
	HasCaughtThisTurn = true
	local localPos = Root.CFrame:PointToObjectSpace(ball.Position)
	local relY = localPos.Y
	if relY >= 1.2 then
		Press("High Catch")
	elseif relY >= -0.5 and relY < 1.2 then
		if ball.AssemblyLinearVelocity.Magnitude > 30 then
			if not Press("Reflex") then
				Press("High Catch")
			end
		else
			Press("High Catch")
		end
	else
		Press("Low Catch")
	end
	FireCatch(ball)
	if typeof(firetouchinterest) == "function" then
		pcall(function()
			firetouchinterest(Root, ball, 0)
			firetouchinterest(Root, ball, 1)
		end)
	end
end

local function MarkKick()
	KickBlockedUntil = tickFn() + 1.5
	if Cfg.AutoCatch then BlockCatch(.4) end
end

local function HookTool(tool)
	if not tool or not tool:IsA("Tool") then return end
	local name = tool.Name:lower()
	if name:find("kick") or name:find("shoot") or name:find("ball") or name:find("glove") or name:find("chute") or name:find("luva") then
		pcall(function()
			tool.Activated:Connect(MarkKick)
			tool.Equipped:Connect(MarkKick)
			tool.Unequipped:Connect(MarkKick)
		end)
	end
end

local function HookTools(container)
	if not container then return end
	for _, obj in ipairs(container:GetChildren()) do HookTool(obj) end
	container.ChildAdded:Connect(function(obj)
		task.wait(.1)
		HookTool(obj)
	end)
end

HookTools(Player:FindFirstChild("Backpack"))
Player.CharacterAdded:Connect(function(char)
	task.wait(.5)
	HookTools(Player:FindFirstChild("Backpack"))
	for _, obj in ipairs(char:GetChildren()) do HookTool(obj) end
	char.ChildAdded:Connect(function(obj)
		task.wait(.1)
		HookTool(obj)
	end)
end)

local function ApplyBigFoot()
	if not Character then return end
	local limbNames = {"Right Foot", "Left Foot", "Right Lower Leg", "Left Lower Leg", "RightLeg", "LeftLeg"}
	local multiplier = 1 + (Cfg.HitboxSize - 1) * 0.8
	for _, limbName in ipairs(limbNames) do
		local limb = Character:FindFirstChild(limbName)
		if limb and limb:IsA("BasePart") then
			if Cfg.ReachActive then
				if not limb:FindFirstChild("OriginalLimbSize") then
					local orig = Instance.new("Vector3Value")
					orig.Name = "OriginalLimbSize"
					orig.Value = limb.Size
					orig.Parent = limb
				end
				local origSize = limb:FindFirstChild("OriginalLimbSize").Value
				limb.Size = origSize * multiplier
				limb.CanCollide = false
			else
				if limb:FindFirstChild("OriginalLimbSize") then
					limb.Size = limb:FindFirstChild("OriginalLimbSize").Value
				end
			end
		end
	end
end

local function UpdateReachOrb()
	if not Root or not Character then return end
	if not Cfg.ReachActive then
		ApplyBigFoot()
		local oldOrb = Root:FindFirstChild("GKReachOrb")
		if oldOrb then oldOrb:Destroy() end
		return
	end
	ApplyBigFoot()
	local orb = Root:FindFirstChild("GKReachOrb")
	if not orb then
		orb = Instance.new("SelectionSphere")
		orb.Name = "GKReachOrb"
		orb.Color3 = Color3.fromRGB(0, 255, 0)
		orb.Adornee = Root
		orb.Parent = Root
	end
	orb.Transparency = (10 - Cfg.OrbVisual) / 10
end

local function Start()
	if Connection then return end
	Connection = RunService.Heartbeat:Connect(function()
		UpdatePredict()
		CheckBallControl()

		if Cfg.ReachActive and not BallControlled then
			local ball = GetBall()
			if ball then
				local dist = (ball.Position - Root.Position).Magnitude
				local reachRange = 4 + (Cfg.HitboxSize * 2.5)
				if dist <= reachRange then
					if typeof(firetouchinterest) == "function" then
						pcall(function()
							firetouchinterest(Root, ball, 0)
							firetouchinterest(Root, ball, 1)
						end)
					end
				end
			end
		end

		if not Cfg.AutoDive and not Cfg.AutoCatch then return end
		if not Root or not Root.Parent or not Humanoid or Humanoid.Health <= 0 then return end

		local ball = GetBall()
		if not ball then return end
		local diveInfo = AnalyzeDive()

		if Cfg.AutoCatch and Cfg.AutoDive and diveInfo and not BallControlled and not HasCaughtThisTurn and not CatchBlocked() then
			local distance = (ball.Position - Root.Position).Magnitude
			if distance <= Cfg.CatchRange and BallIncoming(ball) then
				DoCatch(ball)
				return
			end
		end

		if not Cfg.AutoDive or BallControlled then return end
		if tickFn() < KickBlockedUntil then return end
		if Cfg.DiveCooldown > 0 and (tickFn() - LastDive < Cfg.DiveCooldown) then
			return
		end

		if diveInfo and diveInfo.Action then
			ExecuteDive()
		end
	end)
end

local function Stop()
	if Connection then
		Connection:Disconnect()
		Connection = nil
	end
	ClearPredict()
end

ScanButtons()
task.spawn(function() while Alive() and task.wait(2) do ScanButtons() end end)

local SkyState = {Orig = nil, Atmos = nil, Clouds = nil, Post = {}}

local function ForceSky(assetId)
	for _, obj in pairs(Workspace:GetDescendants()) do
		if obj:IsA("BasePart") or obj:IsA("Model") then
			local n = string.lower(obj.Name)
			if (string.find(n, "sky") or string.find(n, "dome") or string.find(n, "ceu") or string.find(n, "atmosphere"))
				and not string.find(n, "napoleon") then
				pcall(function() obj:Destroy() end)
			end
		end
	end
	for _, child in pairs(Lighting:GetChildren()) do
		if child:IsA("Sky") then
			if not SkyState.Orig then SkyState.Orig = child:Clone() end
			child:Destroy()
		elseif child:IsA("Atmosphere") then
			if not SkyState.Atmos then SkyState.Atmos = child:Clone() end
			child:Destroy()
		elseif child:IsA("Clouds") then
			if not SkyState.Clouds then SkyState.Clouds = child:Clone() end
			child:Destroy()
		elseif child:IsA("PostEffect") and child.Name ~= "NapoleonKeyBlur" and child.Name ~= "NapoleonLoadBlur" then
			table.insert(SkyState.Post, child:Clone())
			child:Destroy()
		end
	end
	local loaded = false
	pcall(function()
		local objects = game:GetObjects("rbxassetid://" .. tostring(assetId))
		for _, v in pairs(objects) do
			if v:IsA("Sky") then v.Name = "NapoleonSky" v.Parent = Lighting loaded = true end
		end
	end)
	if not loaded then
		local s = Instance.new("Sky")
		s.Name = "NapoleonSky"
		local url = "rbxassetid://" .. tostring(assetId)
		s.SkyboxBk = url s.SkyboxDn = url s.SkyboxFt = url
		s.SkyboxLf = url s.SkyboxRt = url s.SkyboxUp = url
		s.Parent = Lighting
	end
end

local function RestaurarSky()
	for _, child in pairs(Lighting:GetChildren()) do
		if child:IsA("Sky") or child.Name == "NapoleonSky" then child:Destroy() end
	end
	if SkyState.Orig   then local c = SkyState.Orig:Clone()   c.Parent = Lighting SkyState.Orig   = nil end
	if SkyState.Atmos  then local c = SkyState.Atmos:Clone()  c.Parent = Lighting SkyState.Atmos  = nil end
	if SkyState.Clouds then local c = SkyState.Clouds:Clone() c.Parent = Lighting SkyState.Clouds = nil end
	for _, e in ipairs(SkyState.Post) do if e then e:Clone().Parent = Lighting end end
	SkyState.Post = {}
end

local KeyWindow = nil
local KeyShowing = false
local ShowKeySystem

ShowKeySystem = function()
	if KeyShowing then return end
	KeyShowing = true
	if KeyWindow then pcall(function() KeyWindow:Destroy() end) KeyWindow = nil end
	FreshWindUI("NapoleonKeys")
	AddKeyBlur()
	task.wait(0.4)

	KeyWindow = WindUI:CreateWindow({
		Title = "NAPOLEON HUB",
		Author = "Sistema Imperial de Key",
		Size = FitSize(480, 420),
		Theme = "NapoleonKeys",
		HasOutline = true,
		Transparent = false,
	})

	AddTag(KeyWindow, { Title = "Imperio Napoleon", Icon = "crown", Color = Color3.fromHex("#c9a961"), Radius = 6 })
	PolishWindow(KeyWindow)

	local KeyTab = AddTab(KeyWindow, { Title = "Key", Icon = "lucide:key", IconShape = "Square", Border = true })
	if not KeyTab then KeyShowing = false return end

	AddSection(KeyTab, { Title = "Bem-vindo, General" })

	AddParagraph(KeyTab, {
		Title = "Acesso ao Imperio",
		Desc = "Insira sua key imperial para desbloquear o hub.\nCada key fica ativa por 24 horas.\n\ndiscord.gg/fTKM4ubCw",
	})

	local StatusLabel = AddParagraph(KeyTab, {
		Title = "Status",
		Desc = "Aguardando sua key...",
	})

	local enteredKey = ""
	local busy = false

	local function ValidateAndOpen(key)
		if busy then return end
		key = tostring(key or "")
		key = key:gsub("^%s+", "")
		key = key:gsub("%s+$", "")

		if CheckKey(key) then
			busy = true
			if writefile then
				pcall(writefile, SAVE_FILE, key)
				SaveKeyTime()
			end

			SetParagraph(StatusLabel, "Key Valida", "Bem-vindo ao Imperio, General! Abrindo o hub...")
			Notify({ Title = "Key Valida", Content = "Bem-vindo ao Imperio, General!", Duration = 3, Icon = "crown" })

			RemoveBlur()

			task.spawn(function()
				task.wait(0.4)
				pcall(function()
					if KeyWindow then
						KeyWindow:Destroy()
						KeyWindow = nil
					end
				end)
				KeyShowing = false
				ShowLoading()
				task.wait(0.5)
				pcall(function()
					if _G.NapoleonLoadHub then _G.NapoleonLoadHub() end
				end)
				task.wait(0.4)
				HideLoading()
			end)
		else
			SetParagraph(StatusLabel, "Key Invalida", "Verifique e tente novamente. Pegue sua key no Discord.")
			Notify({ Title = "Key Invalida", Content = "Verifique e tente novamente.", Duration = 4, Icon = "x" })
		end
	end

	AddSection(KeyTab, { Title = "Autenticacao" })

	AddInput(KeyTab, {
		Title = "Sua Key",
		Desc = "Cole a key de acesso aqui:",
		Value = "",
		Placeholder = "Cole sua key imperial aqui...",
		Callback = function(v) enteredKey = v end,
	})

	AddButton(KeyTab, {
		Title = "Verificar e Entrar",
		Desc = "Valida sua key e abre o hub",
		Icon = "lucide:check-circle",
		Callback = function() ValidateAndOpen(enteredKey) end,
	})

	AddButton(KeyTab, {
		Title = "Copiar link do Discord",
		Desc = "Copia o convite para a area de transferencia",
		Icon = "lucide:copy",
		Callback = function()
			local ok = false
			if setclipboard then ok = pcall(setclipboard, "discord.gg/fTKM4ubCw") end
			Notify({
				Title = "Discord",
				Content = ok and "Link copiado!" or "discord.gg/fTKM4ubCw",
				Duration = 3,
				Icon = ok and "check" or "info",
			})
		end,
	})

	AddSection(KeyTab, { Title = "Informacoes" })

	AddParagraph(KeyTab, {
		Title = "Duracao",
		Desc = "Sua key e valida por 24 horas apos a validacao.\nDepois disso, pegue uma nova no Discord.",
	})

	AddParagraph(KeyTab, {
		Title = "Creditos",
		Desc = "Feito por: equipe unk\nDiscord: discord.gg/fTKM4ubCw",
	})

	ApplyNapoleonBackground()
end

local MainWindow = nil
local TimerThread = nil
local TimerStop = false
local Expiring = false
local HotkeyConn = nil

_G.NapoleonLoadHub = function()
	SetLoadingTarget(25)
	TimerStop = false
	Expiring = false
	if HotkeyConn then HotkeyConn:Disconnect() HotkeyConn = nil end
	local HotkeysOn = true
	local ExpireKey
	RemoveBlur()
	FreshWindUI("Napoleon")
	task.wait(0.4)
	SetLoadingTarget(45)

	MainWindow = WindUI:CreateWindow({
		Title = "NAPOLEON HUB",
		Author = "Feito por: equipe unk",
		Folder = "NapoleonHub",
		Size = FitSize(720, 500),
		Transparent = false,
		Theme = Cfg.Theme,
		SideBarWidth = IS_MOBILE and 150 or 200,
		HasOutline = true,
		Resizable = true,
		ToggleKey = Enum.KeyCode.K,
	})

	AddTag(MainWindow, { Title = "Imperio Napoleon", Icon = "crown", Color = Color3.fromHex("#c9a961"), Radius = 6 })
	AddTag(MainWindow, { Title = "discord.gg/fTKM4ubCw", Icon = "message-square-more", Color = Color3.fromHex("#a8916b"), Radius = 6 })

	PolishWindow(MainWindow)
	ApplyNapoleonBackground()
	SetLoadingTarget(60)

	local StatusTab = AddTab(MainWindow, { Title = "Status", Icon = "lucide:activity", IconShape = "Square", Border = true })

	AddSection(StatusTab, { Title = "Controles Rapidos" })

	local Toggles = {}
	local function Refresh()
		if Cfg.AutoDive or Cfg.AutoCatch or Cfg.Predict then Start() else Stop() end
	end
	local function PushToggle(key, v)
		local t = Toggles[key]
		if type(t) == "table" and type(t.Set) == "function" then pcall(function() t:Set(v) end) end
	end
	local function SetAutoDive(v)
		v = v and true or false
		if Cfg.AutoDive == v then return end
		Cfg.AutoDive = v
		Refresh()
		PushToggle("Dive", v)
		Notify({ Title = "Defesa Automatica", Content = v and "ATIVADA" or "DESATIVADA", Duration = 2, Icon = v and "check" or "x" })
	end
	local function SetAutoCatch(v)
		v = v and true or false
		if Cfg.AutoCatch == v then return end
		Cfg.AutoCatch = v
		Refresh()
		PushToggle("Catch", v)
		Notify({ Title = "Defesa de Bola", Content = v and "ATIVADA" or "DESATIVADA", Duration = 2, Icon = v and "check" or "x" })
	end
	local function SetPredict(v)
		v = v and true or false
		if Cfg.Predict == v then return end
		SetCfg("Predict", v)
		if not v then ClearPredict() end
		Refresh()
		PushToggle("Predict", v)
		Notify({ Title = "Trajetoria", Content = v and "ATIVADA" or "DESATIVADA", Duration = 2, Icon = v and "check" or "x" })
	end

	Toggles.Dive = AddToggle(StatusTab, {
		Title = "Defesa Automatica",
		Desc = "Dive automatico baseado na trajetoria da bola.  Atalho: F",
		Value = false,
		Callback = function(v) SetAutoDive(v) end,
	})
	Toggles.Catch = AddToggle(StatusTab, {
		Title = "Defesa de Bola",
		Desc = "Captura automatica das bolas proximas.  Atalho: G",
		Value = false,
		Callback = function(v) SetAutoCatch(v) end,
	})
	Toggles.Predict = AddToggle(StatusTab, {
		Title = "Linha de Trajetoria",
		Desc = "Mostra a trajetoria prevista da bola.",
		Value = Cfg.Predict,
		Callback = function(v) SetPredict(v) end,
	})
	Refresh()

	HotkeyConn = UserInputService.InputBegan:Connect(function(input, gp)
		if gp or not Alive() or not HotkeysOn then return end
		if input.KeyCode == Enum.KeyCode.F then
			SetAutoDive(not Cfg.AutoDive)
		elseif input.KeyCode == Enum.KeyCode.G then
			SetAutoCatch(not Cfg.AutoCatch)
		end
	end)

	AddSection(StatusTab, { Title = "Estado do Hub" })

	local StatusParagraph = AddParagraph(StatusTab, {
		Title = "Sistema",
		Desc = "Modo: Legit\nDefesa: Desligada\nCaptura: Desligada\nKey: Carregando...",
	})

	local BallStatusLabel = AddParagraph(StatusTab, {
		Title = "Bola",
		Desc = "Nenhuma bola detectada.",
	})

	AddButton(StatusTab, {
		Title = "Atualizar Status",
		Desc = "Forca atualizacao das informacoes",
		Icon = "lucide:refresh-cw",
		Callback = function()
			local ball = GetBall()
			local ballTxt = ball and ("Detectada a " .. math.floor((ball.Position - (Root and Root.Position or Vector3.zero)).Magnitude) .. " studs") or "Nenhuma bola detectada."
			SetParagraph(BallStatusLabel, "Bola", ballTxt)
			Notify({ Title = "Status", Content = "Atualizado!", Duration = 2, Icon = "check" })
		end,
	})

	AddSection(StatusTab, { Title = "Atalhos" })

	AddParagraph(StatusTab, {
		Title = "Teclas",
		Desc = "K - Abre/Fecha o Hub (PC)\nBotao dourado NAPOLEON - Abre/Fecha (celular)\nF - Defesa Automatica\nG - Defesa de Bola\n\nUse as abas a esquerda pra navegar.",
	})

	AddButton(StatusTab, {
		Title = "Resetar Key",
		Desc = "Apaga sua key salva e forca digitar de novo.",
		Icon = "lucide:trash-2",
		Callback = function()
			ClearSavedKey()
			Notify({ Title = "Key", Content = "Key apagada! Voltando para a tela de key...", Duration = 3, Icon = "trash" })
			task.delay(1.2, function() if ExpireKey then ExpireKey() end end)
		end,
	})

	local GKTab = AddTab(MainWindow, { Title = "Defesa", Icon = "lucide:shield", IconShape = "Square", Border = true })

	AddSection(GKTab, { Title = "Modo de Defesa" })
	AddDropdown(GKTab, {
		Title = "Estilo da Defesa",
		Desc = "Escolha entre Legit ou Blatant.",
		Multi = false,
		Value = Cfg.Mode,
		Values = { "Legit", "Blatant" },
		Callback = function(v)
			SetCfg("Mode", tostring(v))
			Notify({ Title = "Modo de Defesa", Content = "Definido: " .. tostring(v), Duration = 3, Icon = "info" })
		end,
	})

	AddSection(GKTab, { Title = "Distancia" })
	AddSlider(GKTab, { Title = "Distancia de Defesa", Desc = "Alcance maximo para dar dive.", Value = { Min = 10, Max = 60, Default = Cfg.DiveRange }, Step = 1, Callback = function(v) SetCfg("DiveRange", v) end })
	AddSlider(GKTab, { Title = "Distancia de Captura", Desc = "Alcance para capturar a bola.", Value = { Min = 3, Max = 20, Default = Cfg.CatchRange }, Step = 1, Callback = function(v) SetCfg("CatchRange", v) end })

	AddSection(GKTab, { Title = "Velocidade" })
	AddSlider(GKTab, { Title = "Velocidade Minima", Desc = "Velocidade minima da bola.", Value = { Min = 0, Max = 80, Default = Cfg.MinSpeed }, Step = 1, Callback = function(v) SetCfg("MinSpeed", v) end })
	AddSlider(GKTab, { Title = "Velocidade Maxima", Desc = "Velocidade maxima da bola.", Value = { Min = 60, Max = 200, Default = Cfg.MaxSpeed }, Step = 1, Callback = function(v) SetCfg("MaxSpeed", v) end })
	SetLoadingTarget(72)

	local PredictTab = AddTab(MainWindow, { Title = "Trajetoria", Icon = "lucide:crosshair", IconShape = "Square", Border = true })

	AddSection(PredictTab, { Title = "Previsao da Bola" })
	AddSlider(PredictTab, { Title = "Tempo de Previsao (ms)", Desc = "Quanto tempo da trajetoria mostrar.", Value = { Min = 100, Max = 800, Default = math.floor(Cfg.PredictTime * 1000 + 0.5) }, Step = 10, Callback = function(v) SetCfg("PredictTime", v / 1000) end })
	AddButton(PredictTab, {
		Title = "Apagar Trajetoria",
		Desc = "Limpa todas as linhas da tela.",
		Icon = "lucide:trash",
		Callback = function()
			ClearPredict()
			Notify({ Title = "Trajetoria", Content = "Linhas apagadas!", Duration = 3, Icon = "trash" })
		end,
	})

	local ReachTab = AddTab(MainWindow, { Title = "GK Reach", Icon = "lucide:mouse", IconShape = "Square", Border = true })

	AddSection(ReachTab, { Title = "Controle de Alcance (GK Reach)" })
	AddToggle(ReachTab, {
		Title = "Ativar Alcance",
		Desc = "Ativa a orb verde e o Big Foot nos pes do goleiro.",
		Value = false,
		Icon = "lucide:zap",
		Callback = function(v)
			Cfg.ReachActive = v and true or false
			UpdateReachOrb()
			if Cfg.ReachActive then Start() end
			Notify({ Title = "GK Reach", Content = Cfg.ReachActive and "Ativado!" or "Desativado!", Duration = 3, Icon = Cfg.ReachActive and "check" or "x" })
		end,
	})
	AddSlider(ReachTab, {
		Title = "Visual da Orb",
		Desc = "Ajusta a visibilidade da orb verde (1 = invisivel, 10 = total verde).",
		Value = { Min = 1, Max = 10, Default = Cfg.OrbVisual },
		Step = 1,
		Callback = function(v) Cfg.OrbVisual = v UpdateReachOrb() SaveCfg() end,
	})

	AddSection(ReachTab, { Title = "Controle de Big Foot" })
	AddSlider(ReachTab, {
		Title = "BIG FOOT / HITBOX",
		Desc = "Expande a hitbox dos pes e aumenta o alcance de toque da bola (1 a 10).",
		Value = { Min = 1, Max = 10, Default = Cfg.HitboxSize },
		Step = 1,
		Callback = function(v) Cfg.HitboxSize = v UpdateReachOrb() SaveCfg() end,
	})

	local FieldTab = AddTab(MainWindow, { Title = "Campo", Icon = "lucide:palette", IconShape = "Square", Border = true })

	AddSection(FieldTab, { Title = "Cor do Gramado" })
	AddDropdown(FieldTab, {
		Title = "Escolher Cor do Campo",
		Desc = "Altera apenas a cor do gramado/campo de futebol.",
		Multi = false,
		Value = "Verde",
		Values = { "Preto", "Azul", "Ciano", "Verde", "Verde Escuro" },
		Callback = function(v)
			local selectedColor = FieldColors[v]
			if selectedColor then
				SetFieldColor(selectedColor)
				Notify({ Title = "Campo", Content = "Cor do campo alterada para " .. v .. "!", Duration = 3, Icon = "check" })
			end
		end,
	})
	AddButton(FieldTab, {
		Title = "Restaurar Cor Original",
		Desc = "Volta a cor padrao do campo.",
		Icon = "lucide:rotate-ccw",
		Callback = function()
			RestoreFieldColor()
			Notify({ Title = "Campo", Content = "Cor original do campo restaurada!", Duration = 3, Icon = "check" })
		end,
	})

	local SkyTab = AddTab(MainWindow, { Title = "Sky", Icon = "lucide:cloud", IconShape = "Square", Border = true })

	AddSection(SkyTab, { Title = "Skies Disponiveis" })
	AddButton(SkyTab, { Title = "Green Sky",     Icon = "lucide:cloud", Callback = function() ForceSky("113859918879279") Notify({ Title = "Sky", Content = "Green Sky aplicado",     Duration = 3, Icon = "check" }) end })
	AddButton(SkyTab, { Title = "Pink Sky",      Icon = "lucide:cloud", Callback = function() ForceSky("96902346573845")  Notify({ Title = "Sky", Content = "Pink Sky aplicado",      Duration = 3, Icon = "check" }) end })
	AddButton(SkyTab, { Title = "Minecraft Sky", Icon = "lucide:cloud", Callback = function() ForceSky("96736589365838")  Notify({ Title = "Sky", Content = "Minecraft Sky aplicado", Duration = 3, Icon = "check" }) end })

	AddSection(SkyTab, { Title = "Restaurar" })
	AddButton(SkyTab, {
		Title = "Restaurar Sky Original",
		Desc = "Volta o ceu original do jogo.",
		Icon = "lucide:refresh-cw",
		Callback = function()
			RestaurarSky()
			Notify({ Title = "Sky", Content = "Sky restaurado", Duration = 3, Icon = "check" })
		end,
	})
	SetLoadingTarget(84)

	local ConfigTab = AddTab(MainWindow, { Title = "Ajustes", Icon = "lucide:settings", IconShape = "Square", Border = true })

	AddSection(ConfigTab, { Title = "Tempo de Resposta" })
	AddDropdown(ConfigTab, {
		Title = "Intervalo da Defesa",
		Desc = "Tempo entre dives (cooldown).",
		Multi = false,
		Value = (Cfg.DiveCooldown == 0) and "0 (Instantaneo)" or tostring(Cfg.DiveCooldown),
		Values = { "0 (Instantaneo)", "0.0001", "0.0005", "0.001", "0.005", "0.01", "0.02", "0.05" },
		Callback = function(v)
			SetCfg("DiveCooldown", (v == "0 (Instantaneo)") and 0 or (tonumber(v) or 0))
		end,
	})
	AddSlider(ConfigTab, { Title = "Intervalo da Captura", Desc = "Cooldown entre capturas.", Value = { Min = 0.1, Max = 3, Default = Cfg.CatchCooldown }, Step = 0.01, Callback = function(v) SetCfg("CatchCooldown", v) end })
	AddSlider(ConfigTab, { Title = "Antecedencia da Defesa (ms)", Desc = "Quanto tempo antes do impacto o dive e acionado.", Value = { Min = 150, Max = 1000, Default = math.floor(Cfg.DiveLead * 1000 + 0.5) }, Step = 10, Callback = function(v) SetCfg("DiveLead", v / 1000) end })

	AddSection(ConfigTab, { Title = "Sensibilidade" })
	AddSlider(ConfigTab, { Title = "Altura da Defesa Alta", Desc = "Ajusta a altura pra dive alto.", Value = { Min = 0.5, Max = 4, Default = Cfg.HighThreshold }, Step = 0.1, Callback = function(v) SetCfg("HighThreshold", v) end })
	AddSlider(ConfigTab, { Title = "Sensibilidade Lateral", Desc = "Ajusta o dive lateral.", Value = { Min = 1, Max = 4, Default = Cfg.SideThreshold }, Step = 0.1, Callback = function(v) SetCfg("SideThreshold", v) end })

	AddToggle(ConfigTab, {
		Title = "Atalhos de Teclado",
		Desc = "F = Defesa Automatica, G = Defesa de Bola.",
		Value = true,
		Callback = function(v) HotkeysOn = v end,
	})

	AddSection(ConfigTab, { Title = "Debug" })
	AddButton(ConfigTab, {
		Title = "Atualizar Sistema",
		Desc = "Re-escaneia os botoes e limpa predicoes.",
		Icon = "lucide:refresh-cw",
		Callback = function()
			ScanButtons()
			ClearPredict()
			Notify({ Title = "Debug", Content = "Atualizado", Duration = 3, Icon = "check" })
		end,
	})
	AddButton(ConfigTab, {
		Title = "Detectar Bola",
		Desc = "Destaca a bola por 10 segundos.",
		Icon = "lucide:crosshair",
		Callback = function()
			local currentBall = GetBall()
			if currentBall and Root then
				local dist = math.floor((currentBall.Position - Root.Position).Magnitude * 10) / 10
				Notify({ Title = "Bola Detectada", Content = "Bola: " .. currentBall.Name .. " (" .. dist .. " studs)", Duration = 4, Icon = "check" })
				HighlightBall(currentBall)
			else
				Notify({ Title = "Detectar Bola", Content = "Aguardando surgimento da bola...", Duration = 3, Icon = "info" })
			end
			if BallDetectionConnection then
				BallDetectionConnection:Disconnect()
				BallDetectionConnection = nil
			end
			BallDetectionConnection = Workspace.DescendantAdded:Connect(function(descendant)
				task.wait(0.1)
				if IsBall(descendant) then
					Notify({ Title = "Bola Detectada", Content = "Nova bola detectada e destacada.", Duration = 4, Icon = "check" })
					HighlightBall(descendant)
				end
			end)
		end,
	})
	SetLoadingTarget(92)

	local InfoTab = AddTab(MainWindow, { Title = "Creditos", Icon = "lucide:heart", IconShape = "Square", Border = true })

	AddSection(InfoTab, { Title = "Informacoes" })
	AddParagraph(InfoTab, {
		Title = "NAPOLEON HUB v3",
		Desc = "Feito por: equipe unk\nDiscord: discord.gg/fTKM4ubCw\n\nNovidades v3: GK Reach (orb + bigfoot), troca de cor do campo e card de conta.",
	})
	AddButton(InfoTab, {
		Title = "Copiar link do Discord",
		Desc = "Copia o convite para a area de transferencia",
		Icon = "lucide:copy",
		Callback = function()
			local ok = false
			if setclipboard then ok = pcall(setclipboard, "discord.gg/fTKM4ubCw") end
			Notify({
				Title = "Discord",
				Content = ok and "Link copiado!" or "discord.gg/fTKM4ubCw",
				Duration = 3,
				Icon = ok and "check" or "info",
			})
		end,
	})

	AddSection(InfoTab, { Title = "Agradecimentos" })
	AddParagraph(InfoTab, { Title = "Equipe", Desc = "unk" })

	ExpireKey = function()
		if Expiring then return end
		Expiring = true
		TimerStop = true
		if HotkeyConn then HotkeyConn:Disconnect() HotkeyConn = nil end
		Cfg.AutoDive, Cfg.AutoCatch = false, false
		pcall(Stop)
		ClearSavedKey()

		task.spawn(function()
			if MainWindow then
				pcall(function() MainWindow:Destroy() end)
				MainWindow = nil
			end
			task.wait(0.5)
			ShowKeySystem()
		end)
	end

	local tickN = 0
	TimerThread = task.spawn(function()
		while Alive() and not TimerStop do
			task.wait(1)
			if TimerStop or not Alive() then break end
			local remaining = GetRemainingTime()
			if remaining <= 0 then
				ExpireKey()
				break
			end
			local statusText = string.format(
				"Modo: %s\nDefesa: %s\nCaptura: %s\nKey: %s\nFPS: %d  |  Ping: %d ms",
				Cfg.Mode,
				Cfg.AutoDive and "Ligada" or "Desligada",
				Cfg.AutoCatch and "Ligada" or "Desligada",
				FormatTime(remaining),
				math.floor(FPS),
				GetPing()
			)
			SetParagraph(StatusParagraph, "Sistema", statusText)

			tickN = tickN + 1
			if tickN % 2 == 0 then
				pcall(function()
					local ball = GetBall()
					local txt = "Nenhuma bola detectada."
					if ball and Root then
						txt = string.format("Detectada a %d studs\nVelocidade: %d",
							math.floor((ball.Position - Root.Position).Magnitude),
							math.floor(ball.AssemblyLinearVelocity.Magnitude))
					end
					SetParagraph(BallStatusLabel, "Bola", txt)
				end)
			end
		end
	end)

	Player.CharacterAdded:Connect(function()
		task.wait(1)
		ScanButtons()
		ClearPredict()
	end)

	SetLoadingTarget(100)

	task.delay(1.2, function()
		Notify({
			Title = "NAPOLEON HUB v3",
			Content = "Bem-vindo! K para abrir/fechar. Card de conta adicionado.",
			Duration = 6,
			Icon = "crown",
		})
	end)
end

_G.NapoleonCleanup = function()
	_G.NapoleonRunId = nil
	TimerStop = true
	KeyShowing = false
	if HotkeyConn then pcall(function() HotkeyConn:Disconnect() end) HotkeyConn = nil end
	pcall(Stop)
	pcall(function() if LoadingConn then LoadingConn:Disconnect() LoadingConn = nil end end)
	pcall(function() if LoadingGui then LoadingGui:Destroy() LoadingGui = nil end end)
	pcall(ClearWindUI)
	pcall(function() PredictFolder:Destroy() end)
	pcall(RemoveBlur)
	pcall(RestoreFieldColor)
	pcall(function()
		local b = Lighting:FindFirstChild("NapoleonLoadBlur")
		if b then b:Destroy() end
	end)
	if NapoleonBgThread then pcall(task.cancel, NapoleonBgThread) NapoleonBgThread = nil end
end

if HasValidKey() then
	ShowLoading()
	task.wait(0.5)
	pcall(function() _G.NapoleonLoadHub() end)
	task.wait(0.4)
	HideLoading()
else
	ShowKeySystem()
end