if _G.FVLV2Cleanup then
	_G.__FVLReloading = true
	pcall(_G.FVLV2Cleanup)
	_G.__FVLReloading = nil
end

do
	local ok, text = pcall(function()
		return identifyexecutor()
	end)

	ok = ok and type(text) == "string"
	local str1 = ""

	if not ok then
		text = str1
	end

	if text == "" then
		local ok2, result = pcall(function()
			return getexecutorname()
		end)

		if ok2 and type(result) == "string" then
			text = result
		end
	end

	text = text:match("^%s*(%a+)") or text
	local obj1 = text:lower()
	local flag1 = false

	for _, item in ipairs({ "solara", "xeno" }) do
		if obj1:find(item, 1, true) then
			flag1 = true
		end
	end

	if flag1 then
		local color = Color3.fromRGB(236, 236, 244)
		local color2 = Color3.fromRGB(168, 168, 184)
		local color3 = Color3.fromRGB(29, 29, 37)
		local color4 = Color3.fromRGB(158, 158, 174)
		local color5 = Color3.fromRGB(232, 232, 240)
		local color6 = Color3.fromRGB(22, 22, 28)
		local color7 = Color3.fromRGB(34, 197, 94)
		local hui = gethui and gethui() or game:GetService("CoreGui")
		local screenGui = Instance.new("ScreenGui")
		screenGui.Name = "FVLExecutorWarning"
		screenGui.IgnoreGuiInset = true
		screenGui.ResetOnSpawn = false
		screenGui.DisplayOrder = 2000000
		screenGui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
		screenGui.Parent = hui
		local frame = Instance.new("Frame")
		frame.Size = UDim2.fromScale(1, 1)
		frame.BackgroundColor3 = Color3.new(0, 0, 0)
		frame.BackgroundTransparency = 0.4
		frame.BorderSizePixel = 0
		frame.ZIndex = 1
		frame.Parent = screenGui
		local x = workspace.CurrentCamera and workspace.CurrentCamera.ViewportSize.X or 800
		local frame2 = Instance.new("Frame")
		frame2.AnchorPoint = Vector2.new(0.5, 0.5)
		frame2.Position = UDim2.fromScale(0.5, 0.5)
		frame2.Size = UDim2.fromOffset(math.min(440, math.max(300, x - 40)), 236)
		frame2.BackgroundColor3 = Color3.fromRGB(23, 23, 28)
		frame2.BorderSizePixel = 0
		frame2.ZIndex = 2
		frame2.Parent = screenGui
		Instance.new("UICorner", frame2).CornerRadius = UDim.new(0, 22)
		local uiGradient = Instance.new("UIGradient", frame2)
		uiGradient.Rotation = 90

		uiGradient.Color = ColorSequence.new({
			ColorSequenceKeypoint.new(0, Color3.fromRGB(30, 30, 36)),
			ColorSequenceKeypoint.new(1, Color3.fromRGB(16, 16, 20)),
		})

		local uiStroke = Instance.new("UIStroke", frame2)
		uiStroke.Color = color7
		uiStroke.Thickness = 1
		uiStroke.Transparency = 0.7
		local textLabel = Instance.new("TextLabel")
		textLabel.BackgroundTransparency = 1
		textLabel.Position = UDim2.new(0, 26, 0, 24)
		textLabel.Size = UDim2.new(1, -52, 0, 24)
		textLabel.Font = Enum.Font.GothamBold
		textLabel.TextSize = 18
		textLabel.TextXAlignment = Enum.TextXAlignment.Left
		textLabel.TextColor3 = color
		textLabel.Text = "Executor Warning"
		textLabel.ZIndex = 3
		textLabel.Parent = frame2
		local textLabel2 = Instance.new("TextLabel")
		textLabel2.BackgroundTransparency = 1
		textLabel2.Position = UDim2.new(0, 26, 0, 48)
		textLabel2.Size = UDim2.new(1, -52, 0, 18)
		textLabel2.Font = Enum.Font.Gotham
		textLabel2.TextSize = 12
		textLabel2.TextXAlignment = Enum.TextXAlignment.Left
		textLabel2.TextColor3 = color4
		textLabel2.Text = text
		textLabel2.ZIndex = 3
		textLabel2.Parent = frame2
		local textLabel3 = Instance.new("TextLabel")
		textLabel3.BackgroundTransparency = 1
		textLabel3.Position = UDim2.new(0, 26, 0, 78)
		textLabel3.Size = UDim2.new(1, -52, 0, 96)
		textLabel3.Font = Enum.Font.Gotham
		textLabel3.TextSize = 14
		textLabel3.TextWrapped = true
		textLabel3.LineHeight = 1.15
		textLabel3.TextXAlignment = Enum.TextXAlignment.Left
		textLabel3.TextYAlignment = Enum.TextYAlignment.Top
		textLabel3.TextColor3 = color2

		textLabel3.Text = "Seems like you are using " .. text .. [[. This executor might not support all features of the script, and may result in bigger glitches or bugs.

Please use a better executor next time.]]

		textLabel3.ZIndex = 3
		textLabel3.Parent = frame2
		local textButton = Instance.new("TextButton")
		textButton.AnchorPoint = Vector2.new(0.5, 1)
		textButton.Position = UDim2.new(0.5, 0, 1, -22)
		textButton.Size = UDim2.new(1, -52, 0, 38)
		textButton.BackgroundColor3 = color3
		textButton.BorderSizePixel = 0
		textButton.AutoButtonColor = false
		textButton.Font = Enum.Font.GothamBold
		textButton.TextSize = 13
		textButton.TextColor3 = color4
		textButton.Text = "Understood  (5)"
		textButton.ZIndex = 3
		textButton.Parent = frame2
		Instance.new("UICorner", textButton).CornerRadius = UDim.new(0, 12)
		local flag2 = false
		local flag3 = false

		task.spawn(function()
			for i = 5, 1, -1 do
				textButton.Text = "Understood  (" .. i .. ")"
				task.wait(1)
			end

			flag2 = true
			textButton.Text = "Understood"
			textButton.BackgroundColor3 = color5
			textButton.TextColor3 = color6
		end)

		local function func1()
			if not flag2 or flag3 then
				return
			end
			flag3 = true

			pcall(function()
				screenGui:Destroy()
			end)
		end

		textButton.MouseButton1Click:Connect(func1)
		textButton.TouchTap:Connect(func1)
		local n = 0

		while not flag3 and n < 120 do
			task.wait(0.2)
			n += 0.2
		end

		pcall(function()
			screenGui:Destroy()
		end)
	end
end


if _G.FVLV2 then
	local fvlV2 = _G.FVLV2
	local flag7 = false

	pcall(function()
		flag7 = not fvlV2.Destroyed and fvlV2.UIElements and fvlV2.UIElements.Main and fvlV2.UIElements.Main.Parent ~= nil
	end)

	if flag7 then
		pcall(function()
			fvlV2:Destroy()
		end)

		local now = os.clock()

		while true do
			task.wait(0.1)
			if not (fvlV2.Destroyed or os.clock() - now > 3) then
				continue
			end
			break
		end

		task.wait(0.7)
	end

	_G.FVLV2 = nil
end

_G.FVLV2Cleanup = nil

pcall(function()
	local func3 = ipairs
	local CoreGui_ = game:GetService("CoreGui")

	for _, child in func3(CoreGui_:GetChildren()) do
		if child.Name == "FVLESP" or child.Name:match("^FVL.+Button$") then
			child:Destroy()
		end
	end
end)

pcall(function()
	local hui = gethui and gethui() or game:GetService("CoreGui")

	for _, child in ipairs(hui:GetChildren()) do
		if child.Name == "WindUI" or child.Name:match("^WindUI/") then
			child:Destroy()
		end
	end
end)

local obj2

do
	local response = nil

	local function func4(param2)
		if makefolder and isfolder and not isfolder(param2) then
			pcall(makefolder, param2)
		end
	end

	if isfile and readfile and isfile("FVLV2/windui.lua") then
		local ok, result = pcall(readfile, "FVLV2/windui.lua")

		if ok and type(result) == "string" and #result > 100000 then
			response = result
		end
	end

	local flag8 = response ~= nil
	response = response or game:HttpGet("https://github.com/Footagesus/WindUI/releases/latest/download/main.lua")
	local chunk = loadstring(response)

	if not chunk and flag8 then
		response = game:HttpGet("https://github.com/Footagesus/WindUI/releases/latest/download/main.lua")
		chunk = loadstring(response)
		flag8 = false
	end

	if not flag8 and writefile then
		pcall(function()
			func4("FVLV2")
			writefile("FVLV2/windui.lua", response)
		end)
	end

	if writefile and isfile and not isfile("FVLV2/icons-main.lua") then
		pcall(function()
			local str2, flag9 = game:HttpGet("https://raw.githubusercontent.com/Footagesus/Icons/main/Main-v2.lua"):gsub("return game:HttpGet%(url%)", function()
				return [[do
    local _p = "FVLV2/icons/" .. url:gsub("%W", "_") .. ".txt"
    if isfile and readfile and isfile(_p) then
        local _o, _d = pcall(readfile, _p)
        if _o and type(_d) == "string" and #_d > 0 then return _d end
    end
    local _d = game:HttpGet(url)
    pcall(function()
        if makefolder and isfolder and not isfolder("FVLV2/icons") then makefolder("FVLV2/icons") end
        writefile(_p, _d)
    end)
    return _d
end]]
			end)

			if flag9 > 0 and loadstring(str2) then
				func4("FVLV2")
				writefile("FVLV2/icons-main.lua", str2)
			end
		end)
	end

	if isfile and isfile("FVLV2/icons-main.lua") then
		local str3, flag10 = response:gsub("game%.HttpGet and game:HttpGet%(%w+%)or %w+:GetAsync%(%w+%)", "readfile(\"" .. "FVLV2/icons-main.lua\")")

		if flag10 > 0 then
			chunk = loadstring(str3) or chunk
		end
	end

	obj2 = chunk()
end

obj2:AddTheme({
	Name = "F$VL",
	Background = obj2:Gradient({
		["0"] = { Color = Color3.fromHex("#0e1511"), Transparency = 0.12 },
		["100"] = { Color = Color3.fromHex("#0e1511"), Transparency = 0.12 },
	}, { Rotation = 90 }),
	Accent = obj2:Gradient({
		["0"] = { Color = Color3.fromHex("#0d2b18"), Transparency = 0 },
		["100"] = { Color = Color3.fromHex("#1e6b3c"), Transparency = 0 },
	}, { Rotation = 90 }),
	Dialog = Color3.fromHex("#101a13"),
	Outline = Color3.fromHex("#22c55e"),
	Text = Color3.fromHex("#ffffff"),
	Placeholder = Color3.fromHex("#8fae98"),
	Button = Color3.fromHex("#1f7a43"),
	Icon = Color3.fromHex("#4ade80"),
	Toggle = Color3.fromHex("#22c55e"),
	Slider = Color3.fromHex("#22c55e"),
	Checkbox = Color3.fromHex("#22c55e"),
	SliderIcon = Color3.fromHex("#14532d"),
	Primary = Color3.fromHex("#22c55e"),
	PanelBackground = Color3.fromHex("#22c55e"),
	PanelBackgroundTransparency = 0.94,
	LabelBackground = Color3.fromHex("#052e16"),
	LabelBackgroundTransparency = 0.8,
	ElementBackground = Color3.fromHex("#13211a"),
	ElementBackgroundTransparency = 0.3,
})

obj2:SetTheme("F$VL")
local obj3

do
	local value1 = obj2
	local createWindow = value1.CreateWindow

	local tbl2 = {
		Title = "F$VL",
		Icon = "rbxassetid://103877612231883",
		Author = "Murder Mystery 2",
		Folder = "FVLV2",
		Background = "rbxassetid://103877612231883",
		Size = UDim2.fromOffset(math.clamp((workspace.CurrentCamera and workspace.CurrentCamera.ViewportSize or Vector2.new(1920, 1080)).X - 24, 320, 850), math.clamp((workspace.CurrentCamera and workspace.CurrentCamera.ViewportSize or Vector2.new(1920, 1080)).Y - 24, 240, 560)),
	}

	tbl2.MinSize = Vector2.new(320, 240)
	tbl2.MaxSize = Vector2.new(850, 560)
	tbl2.HideSearchBar = false
	tbl2.Transparent = true
	tbl2.Theme = "F$VL"
	tbl2.Resizable = true
	tbl2.ToggleKey = nil
	tbl2.BackgroundImageTransparency = 0.35
	tbl2.Acrylic = false
	tbl2.ShadowTransparency = 0.3
	tbl2.Radius = 18
	tbl2.IconRadius = 1
	tbl2.IconSize = 27
	tbl2.SideBarWidth = 185
	tbl2.Topbar = { Height = 56, ButtonsType = "Default" }
	tbl2.User = { Enabled = false, Anonymous = false }
	obj3 = createWindow(value1, tbl2)
end

obj3:Tag({ Title = "@F$VL", Icon = "youtube", Color = Color3.fromHex("#ffffff"), Radius = 6 })

obj3:Tag({ Title = "Mobile & PC", Icon = "smartphone", Color = Color3.fromHex("#ffffff"), Radius = 6 })

task.spawn(function()
	local tbl3 = { ["Mobile & PC"] = true, ["@F$VL"] = true }
	local colorSequence = ColorSequence.new
	local value2 = ColorSequenceKeypoint.new(0, Color3.fromRGB(16, 34, 22))
	local value3 = ColorSequenceKeypoint.new(0.35, Color3.fromRGB(30, 64, 40))
	local value4 = ColorSequenceKeypoint.new(0.7, Color3.fromRGB(20, 42, 27))
	local new = ColorSequenceKeypoint.new
	local color = Color3.fromRGB
	local tbl4 = { value2, value3, value4 }

	do
		local values = table.pack(new(1, color(25, 52, 33)))
		table.move(values, 1, values.n, 4, tbl4)
	end

	local value5 = colorSequence(tbl4)
	local color2 = Color3.fromRGB(187, 247, 208)

	for i = 1, 120 do
		local n = 0

		pcall(function()
			for _, descendant in ipairs(obj3.UIElements.Main:GetDescendants()) do
				if descendant:IsA("TextLabel") and tbl3[descendant.Text] then
					local parent = descendant.Parent and descendant.Parent.Parent

					if parent and parent:IsA("ImageLabel") then
						if not parent:FindFirstChildWhichIsA("UIGradient") then
							local uiGradient = Instance.new("UIGradient")
							uiGradient.Rotation = 45
							uiGradient.Color = value5
							uiGradient.Parent = parent
						end

						for _, descendant2 in ipairs(parent:GetDescendants()) do
							if descendant2:IsA("TextLabel") then
								descendant2.TextColor3 = color2
							elseif descendant2:IsA("ImageLabel") and descendant2 ~= parent then
								descendant2.ImageColor3 = color2
							end
						end

						n += 1
					end
				end
			end
		end)

		local n2 = 0

		for k in pairs(tbl3) do
			n2 += 1
		end

		if n >= n2 then
			local list1 = {}

			pcall(function()
				for _, descendant in ipairs(obj3.UIElements.Main:GetDescendants()) do
					if descendant:IsA("TextLabel") and tbl3[descendant.Text] and descendant.Parent then
						local value6 = nil

						for _, child in ipairs(descendant.Parent:GetChildren()) do
							if child ~= descendant and child:IsA("GuiObject") then
								value6 = child
							end
						end

						if value6 then
							list1[#list1 + 1] = { lbl = descendant, icon = value6 }
						end
					end
				end
			end)

			local function func5(param3, param4)
				if param4 then
					local uiListLayout = param3.lbl.Parent and param3.lbl.Parent:FindFirstChildOfClass("UIListLayout")

					if uiListLayout then
						local parent = uiListLayout.Parent
						uiListLayout.Parent = nil
						RunService.RenderStepped:Wait()

						if parent.Parent then
							uiListLayout.Parent = parent
						end
					end

					return
				end

				local size = param3.icon.Size
				param3.icon.Size = UDim2.new(size.X.Scale, size.X.Offset + 1, size.Y.Scale, size.Y.Offset)
				RunService.RenderStepped:Wait()

				if param3.icon.Parent then
					param3.icon.Size = size
				end
			end

			local now = os.clock()
			local n3 = 0

			while _G.FVLV2 == obj3 and n3 < 40 do
				for _, item4 in ipairs(list1) do
					if item4.lbl.Parent and item4.icon.Parent and item4.icon.AbsoluteSize.X > 0 and item4.lbl.AbsoluteSize.X > 0 and item4.lbl.AbsolutePosition.X < item4.icon.AbsolutePosition.X + item4.icon.AbsoluteSize.X then
						n3 += 1
						pcall(func5, item4, n3 > 6)
					end
				end

				task.wait(os.clock() - now < 25 and 0.3 or 3)
			end

			return
		end

		RunService.RenderStepped:Wait()
	end
end)

obj3:SetBackgroundTransparency(0.4)

task.spawn(function()
	local RunService_ = game:GetService("RunService")

	for i = 1, 120 do
		local background = obj3.UIElements and obj3.UIElements.Main and obj3.UIElements.Main:FindFirstChild("Background")

		if background then
			local flag11 = false

			for _, child in ipairs(background:GetChildren()) do
				if child:IsA("ImageLabel") and child.Size == UDim2.new(1, 0, 1, 0) then
					child.ScaleType = Enum.ScaleType.Stretch
					flag11 = true
				end
			end

			if flag11 then
				return
			end
		end

		RunService_.RenderStepped:Wait()
	end
end)

task.spawn(function()
	local TweenService_ = game:GetService("TweenService")
	local RunService_ = game:GetService("RunService")

	local function func6()
		local main = obj3.UIElements and obj3.UIElements.Main
		if not main then
			return nil
		end
		local topbar = main:FindFirstChild("Topbar", true)

		for _, item5 in ipairs({ "Left", "Title", "Title" }) do
			topbar = topbar and topbar:FindFirstChild(item5)
		end

		if topbar and topbar:IsA("TextLabel") then
			return topbar
		end

		for _, descendant in ipairs(main:GetDescendants()) do
			if descendant:IsA("TextLabel") and descendant.Text == obj3.Title then
				return descendant
			end
		end

		return nil
	end

	local value7 = nil

	for i = 1, 120 do
		value7 = func6()
		if not value7 then
			RunService_.RenderStepped:Wait()
			continue
		end
		break
	end

	if not value7 or value7:FindFirstChild("FVLTitleSheen") then
		return
	end
	local uiGradient = value7:FindFirstChildWhichIsA("UIGradient")

	if uiGradient then
		uiGradient:Destroy()
	end

	local uiGradient2 = Instance.new("UIGradient")
	uiGradient2.Name = "FVLTitleSheen"
	uiGradient2.Rotation = 12
	local colorSequence = ColorSequence.new
	local value8 = ColorSequenceKeypoint.new(0, Color3.fromRGB(74, 222, 128))
	local value9 = ColorSequenceKeypoint.new(0.45, Color3.fromRGB(255, 255, 255))
	local value10 = ColorSequenceKeypoint.new(0.55, Color3.fromRGB(255, 255, 255))
	local new = ColorSequenceKeypoint.new
	local color = Color3.fromRGB
	local tbl5 = { value8, value9, value10 }

	do
		local values = table.pack(new(1, color(74, 222, 128)))
		table.move(values, 1, values.n, 4, tbl5)
	end

	uiGradient2.Color = colorSequence(tbl5)
	uiGradient2.Offset = Vector2.new(-0.55000001192092896, 0)
	uiGradient2.Parent = value7
	local uiStroke = Instance.new("UIStroke")
	uiStroke.Name = "FVLTitleGlow"
	uiStroke.Color = Color3.fromRGB(134, 239, 172)
	uiStroke.Thickness = 1.4
	uiStroke.Transparency = 0.82
	uiStroke.ApplyStrokeMode = Enum.ApplyStrokeMode.Contextual
	uiStroke.Parent = value7
	TweenService_:Create(uiGradient2, TweenInfo.new(2.6, Enum.EasingStyle.Sine, Enum.EasingDirection.InOut, -1, true), { Offset = Vector2.new(0.55000001192092896, 0) }):Play()
	TweenService_:Create(uiStroke, TweenInfo.new(1.7, Enum.EasingStyle.Sine, Enum.EasingDirection.InOut, -1, true), { Transparency = 0.42 }):Play()
end)

local color = Color3.fromHex

obj3:EditOpenButton({
	Title = "F$VL",
	Icon = "rbxassetid://103877612231883",
	CornerRadius = UDim.new(0, 16),
	StrokeThickness = 2,
	Color = ColorSequence.new(Color3.fromHex("#14532d"), color("#4ade80")),
	OnlyMobile = false,
	Enabled = true,
	Draggable = true,
})

_G.FVLV2 = obj3
local list2

list2 = {
	farmTargetTime = 0,
	shellsOn = false,
	shellsRunning = false,
	flingAllRunning = false,
	hudScale = 1,
	flingWhenDone = false,
	flingDoneFired = false,
	sawCoins = false,
	lastMap = nil,
	killWhenFull = false,
	killFired = false,
	el = {},
	conns = {},
	revealed = {},
	clipWas = {},
	farmClipWas = {},
	config = nil,
	hudBtns = {},
	hudPos = {},
	cfgSnapshot = nil,
	cfgWiped = false,
	hudDir = "WindUI/FVLV2/hud",
	hudFile = "WindUI/FVLV2/hud/autosave.json",
}

pcall(function()
	if makefolder and isfolder and not isfolder(list2.hudDir) then
		makefolder(list2.hudDir)
	end
end)

list2.sfxId = {
	error = 131039887376992,
	gun = 131390520971848,
	click = 139800881181209,
	toggle = 136108770017536,
}

list2.sfxVol = { error = 0.55, gun = 0.75, click = 0.65, toggle = 0.6 }
list2.sfxOn = { error = true, gun = true, click = true, toggle = true }
list2.sfxReady = false
list2.sfxQuiet = false
list2.sfx = {}

list2.playSfx = function(name)
	if not list2.sfxOn[name] then
		return
	end
	local str4 = list2.sfxId[name]
	if not str4 then
		return
	end

	pcall(function()
		local SoundService = game:GetService("SoundService")
		local fvlSFX = SoundService:FindFirstChild("FVLSFX")

		if not fvlSFX then
			fvlSFX = Instance.new("Folder")
			fvlSFX.Name = "FVLSFX"
			fvlSFX.Parent = SoundService
		end

		local sound = list2.sfx[name]

		if not sound or not sound.Parent then
			sound = fvlSFX:FindFirstChild(name) or Instance.new("Sound")
			sound.Name = name
			sound.SoundId = "rbxassetid://" .. str4
			sound.Volume = list2.sfxVol[name] or 0.5
			sound.Parent = fvlSFX
			list2.sfx[name] = sound
		end

		sound.TimePosition = 0
		sound:Play()
	end)
end

local tab = obj3.Tab

obj3.Tab = function(self, param5)
	local value11 = tab(self, param5)

	if type(value11) == "table" and type(value11.Toggle) == "function" then
		local toggle = value11.Toggle

		value11.Toggle = function(param6, param7)
			if type(param7) == "table" then
				local callback = param7.Callback

				param7.Callback = function(...)
					if list2.sfxReady and not list2.sfxQuiet then
						list2.playSfx("toggle")
					end

					if callback then
						return callback(...)
					end
				end
			end

			return toggle(param6, param7)
		end
	end

	return value11
end

list2.notifyReady = false
list2.realNotify = obj2.Notify

obj2.Notify = function(self, param8)
	if not list2.notifyReady then
		return
	end

	if type(param8) == "table" and (param8.Icon == "x" or param8.Icon == "clock") then
		list2.playSfx("error")
	end

	return list2.realNotify(self, param8)
end

list2.notifyNow = function(param9)
	return list2.realNotify(obj2, param9)
end

task.delay(4, function()
	list2.notifyReady = true
end)

task.delay(20, function()
	list2.sfxReady = true
end)

task.spawn(function()
	local CoreGui_ = game:GetService("CoreGui")

	local function func7(child)
		if not (child and child:IsA("GuiObject")) then
			return
		end

		task.spawn(function()
			local imageLabel = nil

			for i = 1, 60 do
				imageLabel = child:FindFirstChildWhichIsA("ImageLabel")
				if not (imageLabel or not child.Parent) then
					task.wait()
					continue
				end
				break
			end

			if not imageLabel or imageLabel:FindFirstChild("FVLToastRamp") then
				return
			end
			local uiGradient = Instance.new("UIGradient")
			uiGradient.Name = "FVLToastRamp"
			uiGradient.Rotation = 45

			uiGradient.Color = ColorSequence.new({
				ColorSequenceKeypoint.new(0, Color3.new(1, 1, 1)),
				ColorSequenceKeypoint.new(1, Color3.fromRGB(118, 118, 130)),
			})

			uiGradient.Parent = imageLabel
		end)
	end

	local windUINotifications = nil

	for i = 1, 900 do
		windUINotifications = CoreGui_:FindFirstChild("WindUI/Notifications", true)
		if not windUINotifications then
			task.wait(0.2)
			continue
		end
		break
	end

	if not windUINotifications then
		return
	end
	local frame = nil

	for i = 1, 900 do
		frame = windUINotifications:FindFirstChildWhichIsA("Frame")
		if not frame then
			task.wait(0.2)
			continue
		end
		break
	end

	if not frame then
		return
	end

	for _, child in ipairs(frame:GetChildren()) do
		func7(child)
	end

	frame.ChildAdded:Connect(func7)
end)

list2.findOpenPill = function()
	local windUI = (gethui and gethui() or game:GetService("CoreGui")):FindFirstChild("WindUI")
	windUI = windUI and windUI:FindFirstChild("Window")
	if not windUI then
		return nil, nil
	end
	local value12 = nil
	local value13 = nil

	for _, child in ipairs(windUI:GetChildren()) do
		if child:IsA("Frame") then
			if child:FindFirstChild("Main") then
				value12 = child
			elseif child:FindFirstChildWhichIsA("TextButton", true) then
				value13 = child
			end
		end
	end

	return value13, value12
end

list2.pinOpenPill = function()
	task.spawn(function()
		local value14 = nil
		local value15 = nil

		for i = 1, 200 do
			value14, value15 = list2.findOpenPill()
			if not (value14 and value15) then
				task.wait(0.05)
				continue
			end
			break
		end

		if not (value14 and value15) then
			return
		end

		local function func8()
			local visible = not value15.Visible

			if value14.Visible ~= visible then
				value14.Visible = visible
			end
		end

		func8()
		list2.conns[#list2.conns + 1] = value15:GetPropertyChangedSignal("Visible"):Connect(func8)
		list2.conns[#list2.conns + 1] = value14:GetPropertyChangedSignal("Visible"):Connect(func8)
	end)
end

list2.mouseAimPoint = function()
	local currentCamera = Workspace.CurrentCamera
	if not currentCamera then
		return nil
	end

	local ok, result = pcall(function()
		local mouseLocation = UserInputService:GetMouseLocation()
		local num1 = currentCamera:ViewportPointToRay(mouseLocation.X, mouseLocation.Y)
		local raycastParams = RaycastParams.new()
		raycastParams.FilterType = Enum.RaycastFilterType.Exclude
		raycastParams.FilterDescendantsInstances = { LocalPlayer.Character }
		local hit = Workspace:Raycast(num1.Origin, num1.Direction * 300, raycastParams)
		return hit and hit.Position or num1.Origin + num1.Direction * 300
	end)

	return ok and result or nil
end

list2.xrayWas = {}
list2.xrayOn = false

list2.setXray = function(xrayOn)
	list2.xrayOn = xrayOn

	if xrayOn then
		for _, descendant in ipairs(Workspace:GetDescendants()) do
			if descendant:IsA("BasePart") and descendant.Transparency < 0.5 then
				local model = descendant:FindFirstAncestorWhichIsA("Model")

				if not (model and Players:GetPlayerFromCharacter(model)) then
					if list2.xrayWas[descendant] == nil then
						list2.xrayWas[descendant] = descendant.Transparency
					end

					descendant.Transparency = 0.5
				end
			end
		end
	else
		for k, value16 in next, list2.xrayWas, nil do
			pcall(function()
				if k.Parent then
					k.Transparency = value16
				end
			end)
		end

		list2.xrayWas = {}
	end
end

list2.dropConns = function(list3)
	if type(list3) ~= "table" then
		return
	end

	for _, item6 in ipairs(list3) do
		pcall(function()
			item6:Disconnect()
		end)
	end

	for i = #list3, 1, -1 do
		list3[i] = nil
	end
end

list2.unreveal = function()
	for k, value17 in next, list2.revealed, nil do
		pcall(function()
			if k.Parent then
				k.Transparency = value17
			end
		end)
	end

	list2.revealed = {}
end

list2.reclip = function(tbl6)
	for k in next, tbl6, nil do
		pcall(function()
			if k.Parent then
				k.CanCollide = true
			end
		end)
	end

	for k in next, tbl6, nil do
		tbl6[k] = nil
	end
end

list2.CLIPBOARD_FNS = {
	"setclipboard",
	"toclipboard",
	"tosetclipboard",
	"set_clipboard",
	"write_clipboard",
	"setClipboard",
}

list2.copyText = function(param10)
	local genv = getgenv and getgenv() or _G

	for _, clipboardFn in ipairs(list2.CLIPBOARD_FNS) do
		local value19 = rawget(genv, clipboardFn)
		local result

		if type(value19) ~= "function" then
			local ok

			ok, result = pcall(function()
				return getfenv(0)[clipboardFn]
			end)

			if not (ok and type(result) == "function") then
				result = value19
			end
		else
			result = value19
		end

		if type(result) == "function" and pcall(result, param10) then
			return true
		end
	end

	local func9 = ipairs
	local tbl7 = { syn, "write_clipboard" }
	local tbl8 = { syn, "set_clipboard" }
	local tbl9 = { rawget(genv, "Clipboard"), "set" }
	local tbl10 = { rawget(genv, "Clipboard"), "Set" }
	local tbl11 = { tbl7, tbl8, tbl9, tbl10 }

	for _, value20 in func9(tbl11) do
		local first1 = value20[1]
		local second1 = value20[2]

		if type(first1) == "table" and type(rawget(first1, second1)) == "function" then
			if pcall(first1[second1], param10) then
				return true
			end
		end
	end

	return false
end

task.spawn(function()
	local RunService_ = game:GetService("RunService")

	for i = 1, 300 do
		local main = obj3.UIElements and obj3.UIElements.Main

		if main then
			if not list2.bgAsset then
				local background = main:FindFirstChild("Background")
				local func10 = ipairs
				local children = background and background:GetChildren() or {}

				for _, child in func10(children) do
					if child:IsA("ImageLabel") and child.Size == UDim2.new(1, 0, 1, 0) and tostring(child.Image) ~= "" then
						list2.bgAsset = child.Image
					end
				end
			end

			if not list2.markIcon then
				local topbar = main:FindFirstChild("Topbar", true)
				local func11 = ipairs
				topbar = topbar and topbar:GetDescendants() or {}

				for _, value21 in func11(topbar) do
					if value21:IsA("ImageLabel") and value21.Size == UDim2.new(1, 0, 1, 0) and tostring(value21.Image):find("rbxassetid", 1, true) then
						list2.markIcon = value21:Clone()
						break
					end
				end
			end

			if list2.bgAsset and list2.markIcon then
				return
			end
		end

		RunService_.RenderStepped:Wait()
	end
end)

list2.card = function(flag15)
	local tbl14 = flag15 or {}

	local function func12()
	end

	pcall(function()
		local hui = gethui and gethui() or CoreGui
		local fvlCard = hui:FindFirstChild("FVLCard")

		if fvlCard then
			fvlCard:Destroy()
		end

		local screenGui = Instance.new("ScreenGui")
		screenGui.Name = "FVLCard"
		screenGui.IgnoreGuiInset = true
		screenGui.ResetOnSpawn = false
		screenGui.DisplayOrder = 99999
		screenGui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
		screenGui.Parent = hui
		local TweenService_ = game:GetService("TweenService")
		local color2 = Color3.fromRGB(34, 197, 94)
		local color3 = Color3.fromRGB(158, 158, 174)
		local color4 = Color3.fromRGB(168, 168, 184)
		local color5 = Color3.fromRGB(29, 29, 37)
		local color6 = Color3.fromRGB(233, 233, 242)
		local color7 = Color3.fromRGB(232, 232, 240)
		local color8 = Color3.fromRGB(22, 22, 28)
		local color9 = Color3.fromRGB(236, 236, 244)
		local actions = tbl14.actions
		local flag16 = type(actions) == "table" and #actions > 0
		local n = flag16 and 194 or 144
		local textButton = Instance.new("TextButton")
		textButton.Size = UDim2.fromScale(1, 1)
		textButton.BackgroundColor3 = Color3.new(0, 0, 0)
		textButton.BackgroundTransparency = 1
		textButton.BorderSizePixel = 0
		textButton.AutoButtonColor = false
		textButton.Text = ""
		textButton.Parent = screenGui
		local frame = Instance.new("Frame")
		frame.AnchorPoint = Vector2.new(0.5, 0.5)
		frame.Position = UDim2.fromScale(0.5, 0.5)
		frame.Size = UDim2.fromOffset(math.min(440, math.max(300, (workspace.CurrentCamera and workspace.CurrentCamera.ViewportSize.X or 800) - 40)), n)
		frame.BackgroundColor3 = Color3.fromRGB(23, 23, 28)
		frame.BackgroundTransparency = 1
		frame.BorderSizePixel = 0
		frame.ClipsDescendants = true
		frame.Parent = screenGui
		Instance.new("UICorner", frame).CornerRadius = UDim.new(0, 22)
		local uiScale = Instance.new("UIScale", frame)
		uiScale.Scale = 0.96
		local uiGradient = Instance.new("UIGradient", frame)
		uiGradient.Rotation = 90
		local new = ColorSequenceKeypoint.new
		local color10 = Color3.fromRGB
		uiGradient.Color = ColorSequence.new({ ColorSequenceKeypoint.new(0, Color3.fromRGB(30, 30, 36)), new(1, color10(16, 16, 20)) })
		local uiStroke = Instance.new("UIStroke", frame)
		uiStroke.Color = color2
		uiStroke.Thickness = 1
		uiStroke.Transparency = 1
		local bgAsset2 = list2.bgAsset and list2.bgAsset ~= ""
		local imageLabel = nil

		if bgAsset2 then
			imageLabel = Instance.new("ImageLabel")
			imageLabel.Size = UDim2.fromScale(1, 1)
			imageLabel.BackgroundTransparency = 1
			imageLabel.Image = list2.bgAsset
			imageLabel.ScaleType = Enum.ScaleType.Crop
			imageLabel.ImageTransparency = 1
			imageLabel.ZIndex = 0
			imageLabel.Parent = frame
			Instance.new("UICorner", imageLabel).CornerRadius = UDim.new(0, 22)
		end

		local frame2 = Instance.new("Frame")
		frame2.Position = UDim2.fromOffset(22, 20)
		frame2.Size = UDim2.fromOffset(48, 48)
		frame2.BackgroundColor3 = Color3.fromRGB(38, 38, 48)
		frame2.BackgroundTransparency = 1
		frame2.BorderSizePixel = 0
		frame2.ZIndex = 1
		frame2.Parent = frame
		Instance.new("UICorner", frame2).CornerRadius = UDim.new(1, 0)
		local uiStroke2 = Instance.new("UIStroke", frame2)
		uiStroke2.Color = color2
		uiStroke2.Thickness = 1
		uiStroke2.Transparency = 1
		local clone

		if list2.markIcon then
			clone = list2.markIcon:Clone()
		else
			clone = Instance.new("ImageLabel")
			clone.Image = "rbxassetid://103877612231883"
		end

		clone.Name = "Mark"
		clone.AnchorPoint = Vector2.new(0.5, 0.5)
		clone.Position = UDim2.fromScale(0.5, 0.5)
		clone.Size = UDim2.fromOffset(26, 26)
		clone.BackgroundTransparency = 1
		clone.ImageColor3 = color6
		clone.ImageTransparency = 1
		clone.Visible = true
		clone.Parent = frame2
		local textLabel = Instance.new("TextLabel")
		textLabel.Position = UDim2.fromOffset(86, 22)
		textLabel.Size = UDim2.new(1, -108, 0, 26)
		textLabel.BackgroundTransparency = 1
		textLabel.Font = Enum.Font.GothamBold
		textLabel.TextSize = 22
		textLabel.TextXAlignment = Enum.TextXAlignment.Left
		textLabel.TextColor3 = Color3.fromRGB(255, 255, 255)
		textLabel.TextTransparency = 1
		textLabel.Text = tostring(tbl14.title or "F$VL")
		textLabel.ZIndex = 1
		textLabel.Parent = frame
		local uiGradient2 = Instance.new("UIGradient", textLabel)
		uiGradient2.Rotation = 10
		local colorSequence = ColorSequence.new
		local value22 = ColorSequenceKeypoint.new(0, Color3.fromRGB(74, 222, 128))
		local value23 = ColorSequenceKeypoint.new(0.42, Color3.fromRGB(255, 255, 255))
		local value24 = ColorSequenceKeypoint.new(0.58, Color3.fromRGB(255, 255, 255))
		local new2 = ColorSequenceKeypoint.new
		local color11 = Color3.fromRGB
		local tbl15 = { value22, value23, value24 }

		do
			local values = table.pack(new2(1, color11(74, 222, 128)))
			table.move(values, 1, values.n, 4, tbl15)
		end

		uiGradient2.Color = colorSequence(tbl15)
		local textLabel2 = Instance.new("TextLabel")
		textLabel2.Position = UDim2.fromOffset(86, 50)
		textLabel2.Size = UDim2.new(1, -108, 0, 18)
		textLabel2.BackgroundTransparency = 1
		textLabel2.Font = Enum.Font.Gotham
		textLabel2.TextSize = 14
		textLabel2.TextXAlignment = Enum.TextXAlignment.Left
		textLabel2.TextColor3 = color3
		textLabel2.TextTransparency = 1
		textLabel2.Text = tostring(tbl14.subtitle or "")
		textLabel2.ZIndex = 1
		textLabel2.Parent = frame
		local textLabel3 = Instance.new("TextLabel")
		textLabel3.Position = UDim2.fromOffset(22, 82)
		textLabel3.Size = UDim2.new(1, -44, 0, 42)
		textLabel3.BackgroundTransparency = 1
		textLabel3.Font = Enum.Font.Gotham
		textLabel3.TextSize = 15
		textLabel3.LineHeight = 1.25
		textLabel3.TextWrapped = true
		textLabel3.TextXAlignment = Enum.TextXAlignment.Left
		textLabel3.TextYAlignment = Enum.TextYAlignment.Top
		textLabel3.TextColor3 = color4
		textLabel3.TextTransparency = 1
		textLabel3.Text = tostring(tbl14.body or "")
		textLabel3.ZIndex = 1
		textLabel3.Parent = frame

		func12 = function()
			pcall(function()
				screenGui:Destroy()
			end)
		end

		local function func13(param11, callback1)
			local n2 = 0

			local function func14()
				local now = os.clock()
				if now - n2 < 0.25 then
					return
				end
				n2 = now
				callback1()
			end

			param11.MouseButton1Click:Connect(func14)
			param11.TouchTap:Connect(func14)
		end

		local tweenInfo = TweenInfo.new(0.12, Enum.EasingStyle.Quad)



		func13(textButton, func12)
		local tbl16 = {}

		if flag16 then
			local frame4 = Instance.new("Frame")
			frame4.AnchorPoint = Vector2.new(1, 0)
			frame4.Position = UDim2.new(1, -22, 0, 136)
			frame4.Size = UDim2.new(1, -44, 0, 38)
			frame4.BackgroundTransparency = 1
			frame4.ZIndex = 1
			frame4.Parent = frame
			local uiListLayout = Instance.new("UIListLayout", frame4)
			uiListLayout.FillDirection = Enum.FillDirection.Horizontal
			uiListLayout.HorizontalAlignment = Enum.HorizontalAlignment.Right
			uiListLayout.VerticalAlignment = Enum.VerticalAlignment.Center
			uiListLayout.Padding = UDim.new(0, 10)
			uiListLayout.SortOrder = Enum.SortOrder.LayoutOrder
			local n2 = #actions
			local offset = uiListLayout.Padding.Offset
			local n3 = 0

			for _, action in ipairs(actions) do
				n3 += action.flex or 1
			end

			for i, action in ipairs(actions) do
				local tint = action.tint or action.primary and color7 or Color3.fromRGB(34, 34, 42)
				local primary = action.primary and color8 or color9
				local textButton3 = Instance.new("TextButton")
				textButton3.LayoutOrder = i
				local n4 = (action.flex or 1) / n3
				textButton3.Size = action.width and UDim2.fromOffset(action.width, 36) or UDim2.new(n4, -offset * (n2 - 1) * n4, 0, 36)
				textButton3.BackgroundColor3 = tint
				textButton3.BackgroundTransparency = 1
				textButton3.BorderSizePixel = 0
				textButton3.AutoButtonColor = false
				textButton3.Font = Enum.Font.GothamMedium
				textButton3.TextSize = 15
				textButton3.TextColor3 = primary
				textButton3.TextTransparency = 1
				textButton3.Text = tostring(action.label or "")
				textButton3.Parent = frame4
				Instance.new("UICorner", textButton3).CornerRadius = UDim.new(0, 11)

				if not action.primary and not action.tint then
					local uiStroke4 = Instance.new("UIStroke", textButton3)
					uiStroke4.Color = color2
					uiStroke4.Thickness = 1
					uiStroke4.Transparency = 1
					table.insert(tbl16, { obj = uiStroke4, prop = "Transparency", to = 0.5 })
				end

				table.insert(tbl16, { obj = textButton3, prop = "BackgroundTransparency", to = 0 })
				table.insert(tbl16, { obj = textButton3, prop = "TextTransparency", to = 0 })
				local uiScale3 = Instance.new("UIScale", textButton3)

				textButton3.MouseButton1Down:Connect(function()
					TweenService_:Create(uiScale3, TweenInfo.new(0.07), { Scale = 0.96 }):Play()
				end)

				textButton3.MouseButton1Up:Connect(function()
					TweenService_:Create(uiScale3, TweenInfo.new(0.12), { Scale = 1 }):Play()
				end)

				local callback = action.callback

				func13(textButton3, function()
					TweenService_:Create(uiScale3, TweenInfo.new(0.12), { Scale = 1 }):Play()

					if action.closes ~= false then
						func12()
					end

					if callback then
						task.spawn(callback)
					end
				end)
			end
		end

		local tweenInfo2 = TweenInfo.new(0.24, Enum.EasingStyle.Quad, Enum.EasingDirection.Out)
		local tweenInfo3 = TweenInfo.new(0.34, Enum.EasingStyle.Quint, Enum.EasingDirection.Out)
		frame.Position = UDim2.fromScale(0.5, 0.52)
		TweenService_:Create(frame, tweenInfo3, { Position = UDim2.fromScale(0.5, 0.5) }):Play()
		TweenService_:Create(uiScale, tweenInfo3, { Scale = 1 }):Play()
		TweenService_:Create(textButton, tweenInfo2, { BackgroundTransparency = 0.5 }):Play()
		TweenService_:Create(frame, tweenInfo2, { BackgroundTransparency = 0 }):Play()
		TweenService_:Create(uiStroke, tweenInfo2, { Transparency = 0.42 }):Play()
		TweenService_:Create(frame2, tweenInfo2, { BackgroundTransparency = 0 }):Play()
		TweenService_:Create(uiStroke2, tweenInfo2, { Transparency = 0.42 }):Play()
		TweenService_:Create(clone, tweenInfo2, { ImageTransparency = 0 }):Play()
		TweenService_:Create(textLabel, tweenInfo2, { TextTransparency = 0 }):Play()
		TweenService_:Create(textLabel2, tweenInfo2, { TextTransparency = 0 }):Play()
		TweenService_:Create(textLabel3, tweenInfo2, { TextTransparency = 0 }):Play()

		if imageLabel then
			TweenService_:Create(imageLabel, tweenInfo2, { ImageTransparency = 0.84 }):Play()
		end

		for _, item7 in ipairs(tbl16) do
			TweenService_:Create(item7.obj, tweenInfo2, { [item7.prop] = item7.to }):Play()
		end

		local timeout = tbl14.timeout or 25

		if timeout > 0 then
			task.delay(timeout, function()
				func12()
			end)
		end
	end)

	return func12
end

list2.farewell = function()
	if _G.__FVLReloading then
		return
	end

	if list2.saidBye then
		return
	end
	list2.saidBye = true

	list2.card({
		title = "Bye bye!",
		subtitle = "Thanks for running F$VL",
		body = "See you next time.",
	})
end

list2.inLobbyNow = function()
	local localPlayer = game:GetService("Players").LocalPlayer
	localPlayer = localPlayer and localPlayer:FindFirstChild("PlayerGui")
	localPlayer = localPlayer and localPlayer:FindFirstChild("MainGUI")
	localPlayer = localPlayer and localPlayer:FindFirstChild("Game")
	if not localPlayer then
		return true
	end
	return localPlayer:FindFirstChild("Inventory") == nil
end

list2.coinFails = {}
list2.coinSkips = {}

list2.coinSkip = function(param12)
	local flag17 = list2.coinSkips[param12]
	if not flag17 then
		return false
	end

	if flag17 < tick() then
		list2.coinSkips[param12] = nil
		list2.coinFails[param12] = nil
		return false
	end

	return true
end

list2.coinFailed = function(param13)
	local n = (list2.coinFails[param13] or 0) + 1
	list2.coinFails[param13] = n

	if n >= 2 then
		list2.coinSkips[param13] = tick() + 20
	end
end

list2.coinReset = function()
	local value25 = list2
	list2.coinFails = {}
	value25.coinSkips = {}
end

pcall(function()
	if not (isfile and delfile) then
		return
	end

	if isfile("WindUI/FVLV2/config/fvl_hud.json") then
		if writefile and not isfile(list2.hudFile) then
			writefile(list2.hudFile, readfile("WindUI/FVLV2/config/fvl_hud.json"))
		end

		delfile("WindUI/FVLV2/config/fvl_hud.json")
	end

	if listfiles then
		for _, listfile in ipairs(listfiles("WindUI/FVLV2/config")) do
			local match = tostring(listfile):match("[^/\\]+$") or ""

			if match:match("^fvl_hud") then
				local match2 = match:match("^fvl_hud_(.+)%.json$")

				if match2 and writefile then
					pcall(function()
						writefile(list2.hudDir .. "/" .. match2 .. ".json", readfile(listfile))
					end)
				end

				pcall(function()
					delfile(listfile)
				end)
			end
		end
	end
end)

pcall(function()
	if isfile and isfile(list2.hudFile) then
		local data = game:GetService("HttpService"):JSONDecode(readfile(list2.hudFile))

		if type(data) == "table" then
			list2.hudPos = data
		end
	end
end)

pcall(function()
	list2.config = obj3.ConfigManager:CreateConfig("autosave")

	if list2.config and list2.config.SetAsCurrent then
		list2.config:SetAsCurrent()
	end
end)

Players = game:GetService("Players")
RunService = game:GetService("RunService")
Workspace = game:GetService("Workspace")
ReplicatedStorage = game:GetService("ReplicatedStorage")
CoreGui = game:GetService("CoreGui")
HttpService = game:GetService("HttpService")
CollectionService = game:GetService("CollectionService")
local localPlayer, flag18, flag19, flag20, flag21, flag22, obj4, func15, func16, func17
local func18, func19, func20, func21, func22

do
	local function func23(param14)
		pcall(function()
			CollectionService:AddTag(param14, "WeaponPassthrough")
		end)
	end

	localPlayer = Players.LocalPlayer

	espColors = {
		murderer = Color3.fromRGB(255, 0, 4),
		sheriff = Color3.fromRGB(0, 153, 255),
		innocent = Color3.fromRGB(0, 255, 8),
		gun = Color3.fromRGB(0, 153, 255),
		trap = Color3.fromHex("#A855F7"),
	}

	flag18 = false
	flag19 = false
	flag20 = false
	flag21 = false
	flag22 = false
	local value26 = nil
	local index = {}
	index.__index = index

	index.new = function()
		local obj = setmetatable({}, index)
		obj.ScreenGui = Instance.new("ScreenGui")
		obj.ScreenGui.Name = "FVLESP"
		obj.ScreenGui.IgnoreGuiInset = true
		obj.ScreenGui.ResetOnSpawn = false
		obj.ScreenGui.Parent = CoreGui
		obj.Groups = {}
		return obj
	end

	index.Add = function(self, adornee, param15)
		if not adornee then
			return
		end
		local highlight = Instance.new("Highlight")
		highlight.Name = "HL_" .. HttpService:GenerateGUID(false)
		highlight.Adornee = adornee
		highlight.FillColor = param15.Color
		highlight.OutlineColor = param15.Color
		highlight.FillTransparency = param15.FillTransparency
		highlight.OutlineTransparency = param15.OutlineTransparency
		highlight.DepthMode = Enum.HighlightDepthMode.AlwaysOnTop
		highlight.Parent = self.ScreenGui
		local flag23 = self.Groups[param15.GroupName]

		if not flag23 then
			flag23 = {}
			self.Groups[param15.GroupName] = flag23
		end

		table.insert(flag23, highlight)

		if param15.Label then
			local billboardGui = Instance.new("BillboardGui")
			billboardGui.Name = "LBL_" .. HttpService:GenerateGUID(false)
			billboardGui.Adornee = param15.LabelAdornee or adornee
			billboardGui.AlwaysOnTop = true
			billboardGui.Size = UDim2.new(0, 140, 0, 16)
			billboardGui.StudsOffset = Vector3.new(0, param15.LabelAdornee and 2.2 or 2, 0)

			if param15.LabelMaxDistance then
				billboardGui.MaxDistance = param15.LabelMaxDistance
			end

			billboardGui.Parent = self.ScreenGui
			local textLabel = Instance.new("TextLabel")
			textLabel.Size = UDim2.new(1, 0, 1, 0)
			textLabel.BackgroundTransparency = 1
			textLabel.Font = Enum.Font.FredokaOne
			textLabel.TextSize = 11
			textLabel.TextColor3 = param15.Color
			textLabel.Text = param15.Label
			textLabel.Parent = billboardGui
			local uiStroke = Instance.new("UIStroke")
			uiStroke.Thickness = 0.5
			uiStroke.Color = Color3.new(0, 0, 0)
			uiStroke.Parent = textLabel
			table.insert(flag23, billboardGui)
		end
	end

	index.RemoveGroup = function(self, param16)
		local flag24 = self.Groups[param16]
		if not flag24 then
			return
		end

		for _, item8 in ipairs(flag24) do
			item8.Adornee = nil
			item8:Destroy()
		end

		self.Groups[param16] = nil
	end

	index.Destroy = function(self)
		for k in pairs(self.Groups) do
			self:RemoveGroup(k)
		end

		if self.ScreenGui then
			self.ScreenGui:Destroy()
		end
	end

	obj4 = index.new()

	func15 = function()
		for _, player in ipairs(Players:GetPlayers()) do
			local backpack = player:FindFirstChildOfClass("Backpack")
			if backpack and backpack:FindFirstChild("Knife") then
				return player
			end
		end

		for _, player in ipairs(Players:GetPlayers()) do
			if player.Character and player.Character:FindFirstChild("Knife") then
				return player
			end
		end

		if value26 then
			for k, value27 in pairs(value26) do
				if value27.Role == "Murderer" and Players:FindFirstChild(k) then
					return Players:FindFirstChild(k)
				end
			end
		end

		return nil
	end

	func16 = function()
		for _, player in ipairs(Players:GetPlayers()) do
			local backpack = player:FindFirstChildOfClass("Backpack")
			if backpack and backpack:FindFirstChild("Gun") then
				return player
			end
		end

		for _, player in ipairs(Players:GetPlayers()) do
			if player.Character and player.Character:FindFirstChild("Gun") then
				return player
			end
		end

		if value26 then
			for k, value28 in pairs(value26) do
				if value28.Role == "Sheriff" and Players:FindFirstChild(k) then
					return Players:FindFirstChild(k)
				end
			end
		end

		return nil
	end

	local function func24(list4)
		for _, descendant in ipairs(list4:GetDescendants()) do
			if descendant:IsA("BasePart") and descendant.Name ~= "HumanoidRootPart" and descendant.Transparency >= 1 then
				func23(descendant)

				if list2.revealed[descendant] == nil then
					list2.revealed[descendant] = descendant.Transparency
				end

				descendant.Transparency = 0.9
			end
		end
	end

	ROLEBOX = { conns = {} }

	ROLEBOX.hide = function(obj)
		if not obj:IsA("BoxHandleAdornment") then
			return
		end
		obj.Visible = false

		table.insert(ROLEBOX.conns, obj:GetPropertyChangedSignal("Visible"):Connect(function()
			if obj.Visible then
				obj.Visible = false
			end
		end))
	end

	ROLEBOX.watch = function(obj)
		for _, descendant in ipairs(obj:GetDescendants()) do
			ROLEBOX.hide(descendant)
		end

		table.insert(ROLEBOX.conns, obj.DescendantAdded:Connect(ROLEBOX.hide))
	end

	ROLEBOX.start = function()
		for _, player in ipairs(Players:GetPlayers()) do
			if player.Character then
				ROLEBOX.watch(player.Character)
			end

			table.insert(ROLEBOX.conns, player.CharacterAdded:Connect(ROLEBOX.watch))
		end

		table.insert(ROLEBOX.conns, Players.PlayerAdded:Connect(function(player)
			table.insert(ROLEBOX.conns, player.CharacterAdded:Connect(ROLEBOX.watch))
		end))
	end

	ROLEBOX.stop = function()
		for _, conn in ipairs(ROLEBOX.conns) do
			pcall(function()
				conn:Disconnect()
			end)
		end

		ROLEBOX.conns = {}

		for _, player in ipairs(Players:GetPlayers()) do
			if player.Character then
				for _, descendant in ipairs(player.Character:GetDescendants()) do
					if descendant:IsA("BoxHandleAdornment") then
						descendant.Visible = true
					end
				end
			end
		end
	end

	ROLEBOX.start()

	func17 = function()
		return flag18 or flag19 or flag20
	end

	func18 = function()
		obj4:RemoveGroup("players")
		if not func17() then
			return
		end
		local n = 1

		if flag19 then
			n = 0.75
		end

		local n2 = 1

		if flag18 then
			n2 = 0.1
		end

		local result1 = func15()
		local result3 = func16()

		for _, player in ipairs(Players:GetPlayers()) do
			if player ~= localPlayer and player.Character then
				func24(player.Character)
				local innocent = espColors.innocent

				if player == result1 then
					innocent = espColors.murderer
				elseif player == result3 then
					innocent = espColors.sheriff
				end

				obj4:Add(player.Character, {
					Color = innocent,
					GroupName = "players",
					FillTransparency = n,
					OutlineTransparency = n2,
					Label = flag20 and player.DisplayName or nil,
					LabelAdornee = player.Character:FindFirstChild("Head"),
					LabelMaxDistance = 300,
				})
			end
		end
	end

	local function func25(param17)
		obj4:Add(param17, {
			Color = espColors.gun,
			GroupName = "gun",
			Label = "Gun",
			FillTransparency = 0.5,
			OutlineTransparency = 0,
		})
	end

	local function func26(param18)
		func23(param18)

		pcall(function()
			param18.Transparency = 0
		end)

		obj4:Add(param18, {
			Color = espColors.trap,
			GroupName = "trap",
			Label = "Trap",
			FillTransparency = 0.5,
			OutlineTransparency = 0,
		})
	end

	func19 = function()
		obj4:RemoveGroup("gun")
		if not flag21 then
			return
		end

		for _, descendant in ipairs(Workspace:GetDescendants()) do
			if descendant.Name == "GunDrop" and (descendant:IsA("BasePart") or descendant:IsA("Model")) then
				func25(descendant)
			end
		end
	end

	func20 = function()
		obj4:RemoveGroup("trap")
		if not flag22 then
			return
		end

		for _, descendant in ipairs(Workspace:GetDescendants()) do
			if descendant.Name == "Trap" and descendant.Parent and (descendant.Parent:IsA("Folder") or descendant.Parent:IsA("Model")) then
				func26(descendant)
			end
		end
	end

	local n = 0

	list2.espRecolourSoon = function()
		if not func17() then
			return
		end
		pcall(func18)

		for _, item9 in ipairs({ 0.1, 0.3, 0.6 }) do
			task.delay(item9, function()
				if func17() then
					pcall(func18)
				end
			end)
		end
	end

	pcall(function()
		list2.conns[#list2.conns + 1] = Workspace.DescendantAdded:Connect(function(descendant)
			if flag22 and descendant.Name == "Trap" and descendant.Parent and (descendant.Parent:IsA("Folder") or descendant.Parent:IsA("Model")) then
				func26(descendant)
			end

			if descendant.Name == "Gun" and descendant:IsA("Tool") then
				if descendant.Parent and Players:GetPlayerFromCharacter(descendant.Parent) then
					list2.espRecolourSoon()
				end
			end

			if descendant.Name == "GunDrop" and (descendant:IsA("BasePart") or descendant:IsA("Model")) then
				if flag21 then
					func25(descendant)
				end

				if tick() - n > 3 then
					n = tick()
					list2.playSfx("gun")

					obj2:Notify({
						Title = "Gun Dropped!",
						Content = "The sheriff died — the gun is on the floor.",
						Duration = 5,
						Icon = "crosshair",
					})
				end
			end
		end)

		list2.conns[#list2.conns + 1] = Workspace.DescendantRemoving:Connect(function(descendant)
			if flag21 and descendant.Name == "GunDrop" then
				task.defer(func19)
			end

			if flag22 and descendant.Name == "Trap" then
				task.defer(func20)
			end

			if descendant.Name == "GunDrop" then
				task.defer(list2.espRecolourSoon)
			end
		end)
	end)

	local flag25 = false

	func21 = function()
		if flag25 then
			return
		end
		flag25 = true

		task.spawn(function()
			while flag25 do
				task.wait(1)

				if func17() then
					pcall(func18)
				end
			end
		end)
	end

	func22 = function()
		flag25 = false
	end

	list2.tr = {
		lines = false,
		dist = false,
		arrows = false,
		parts = {},
		murd = nil,
		sher = nil,
		roleAt = 0,
		conn = nil,
	}

	list2.tr.any = function()
		return list2.tr.lines or list2.tr.dist or list2.tr.arrows
	end

	list2.tr.colorOf = function(flag26)
		if flag26 == list2.tr.murd then
			return espColors.murderer
		end

		if flag26 == list2.tr.sher then
			return espColors.sheriff
		end
		return espColors.innocent
	end

	list2.tr.slot = function(param19)
		local flag27 = list2.tr.parts[param19]
		if flag27 and flag27.line and flag27.line.Parent then
			return flag27
		end
		local screenGui = obj4 and obj4.ScreenGui
		if not screenGui or not screenGui.Parent then
			return nil
		end
		local tbl17 = { line = Instance.new("Frame") }
		tbl17.line.Name = "FVLTracer"
		tbl17.line.AnchorPoint = Vector2.new(0.5, 0.5)
		tbl17.line.BorderSizePixel = 0
		tbl17.line.Visible = false
		tbl17.line.ZIndex = 2
		tbl17.line.Parent = screenGui
		tbl17.lbl = Instance.new("TextLabel")
		tbl17.lbl.Name = "FVLDist"
		tbl17.lbl.AnchorPoint = Vector2.new(0.5, 0)
		tbl17.lbl.BackgroundTransparency = 1
		tbl17.lbl.Size = UDim2.fromOffset(90, 14)
		tbl17.lbl.Font = Enum.Font.FredokaOne
		tbl17.lbl.TextSize = 11
		tbl17.lbl.Visible = false
		tbl17.lbl.ZIndex = 3
		tbl17.lbl.Parent = screenGui
		local uiStroke = Instance.new("UIStroke")
		uiStroke.Thickness = 0.5
		uiStroke.Color = Color3.new(0, 0, 0)
		uiStroke.Parent = tbl17.lbl
		tbl17.arw = Instance.new("TextLabel")
		tbl17.arw.Name = "FVLArrow"
		tbl17.arw.AnchorPoint = Vector2.new(0.5, 0.5)
		tbl17.arw.BackgroundTransparency = 1
		tbl17.arw.Size = UDim2.fromOffset(28, 28)
		tbl17.arw.Font = Enum.Font.SourceSansBold
		tbl17.arw.TextSize = 24
		tbl17.arw.Text = utf8.char(9650)
		tbl17.arw.Visible = false
		tbl17.arw.ZIndex = 3
		tbl17.arw.Parent = screenGui
		local uiStroke2 = Instance.new("UIStroke")
		uiStroke2.Thickness = 1
		uiStroke2.Color = Color3.new(0, 0, 0)
		uiStroke2.Parent = tbl17.arw
		list2.tr.parts[param19] = tbl17
		return tbl17
	end

	list2.tr.drop = function(param20)
		local flag28 = list2.tr.parts[param20]
		if not flag28 then
			return
		end
		list2.tr.parts[param20] = nil

		for _, value29 in pairs(flag28) do
			pcall(function()
				value29:Destroy()
			end)
		end
	end

	list2.tr.step = function()
		local currentCamera = Workspace.CurrentCamera
		if not currentCamera then
			return
		end
		local viewportSize = currentCamera.ViewportSize
		if viewportSize.X < 1 or viewportSize.Y < 1 then
			return
		end
		local now = os.clock()

		if now - list2.tr.roleAt > 0.5 then
			list2.tr.roleAt = now
			list2.tr.murd = func15()
			list2.tr.sher = func16()

			for k in pairs(list2.tr.parts) do
				if k.Parent == nil then
					list2.tr.drop(k)
				end
			end
		end

		local character = localPlayer.Character
		character = character and character:FindFirstChild("HumanoidRootPart")
		local n2 = viewportSize.X * 0.5
		local y = viewportSize.Y
		local n3 = viewportSize.X * 0.5
		local n4 = viewportSize.Y * 0.5
		local n5 = math.min(viewportSize.X, viewportSize.Y) * 0.33
		local flag29 = list2.tr.any()

		for _, player in ipairs(Players:GetPlayers()) do
			local flag30 = list2.tr.parts[player]
			local character2 = player ~= localPlayer and player.Character or nil
			local humanoidRootPart = character2 and character2:FindFirstChild("HumanoidRootPart")
			character2 = character2 and character2:FindFirstChildOfClass("Humanoid")

			if flag29 and humanoidRootPart and character2 and character2.Health > 0 then
				flag30 = flag30 or list2.tr.slot(player)
			elseif flag30 then
				local lbl = flag30.lbl
				local arw = flag30.arw
				flag30.line.Visible = false
				lbl.Visible = false
				arw.Visible = false
				flag30 = nil
			end

			if flag30 then
				local value30 = list2.tr.colorOf(player)
				local value31, flag31 = currentCamera:WorldToViewportPoint(humanoidRootPart.Position)
				local flag32 = value31.Z <= 0
				flag31 = flag31 and not flag32

				if list2.tr.lines and flag31 then
					local n6 = value31.X - n2
					local n7 = value31.Y - y
					flag30.line.BackgroundColor3 = value30
					flag30.line.Size = UDim2.fromOffset(2, math.sqrt(n6 * n6 + n7 * n7))
					flag30.line.Position = UDim2.fromOffset(n2 + n6 * 0.5, y + n7 * 0.5)
					flag30.line.Rotation = math.deg(math.atan2(n7, n6)) - 90
					flag30.line.Visible = true
				else
					flag30.line.Visible = false
				end

				if list2.tr.dist and flag31 then
					local magnitude = character and (humanoidRootPart.Position - character.Position).Magnitude or (humanoidRootPart.Position - currentCamera.CFrame.Position).Magnitude
					local value32 = currentCamera:WorldToViewportPoint(humanoidRootPart.Position - Vector3.new(0, 3.2, 0))
					flag30.lbl.TextColor3 = value30
					flag30.lbl.Text = math.floor(magnitude + 0.5) .. "m"
					flag30.lbl.Position = UDim2.fromOffset(value32.X, value32.Y)
					flag30.lbl.Visible = true
				else
					flag30.lbl.Visible = false
				end

				if list2.tr.arrows and not flag31 then
					local n6 = value31.X - n3
					local n7 = value31.Y - n4

					if flag32 then
						n6 = -n6
						n7 = -n7
					end

					local n8 = math.sqrt(n6 * n6 + n7 * n7)

					if n8 < 1 then
						n6 = 0
						n7 = -1
						n8 = 1
					end

					flag30.arw.TextColor3 = value30
					flag30.arw.Position = UDim2.fromOffset(n3 + n6 / n8 * n5, n4 + n7 / n8 * n5)
					flag30.arw.Rotation = math.deg(math.atan2(n7, n6)) + 90
					flag30.arw.Visible = true
				else
					flag30.arw.Visible = false
				end
			end
		end
	end

	list2.tr.start = function()
		if list2.tr.conn then
			return
		end

		list2.tr.conn = RunService.RenderStepped:Connect(function()
			pcall(list2.tr.step)
		end)
	end

	list2.tr.stop = function()
		if list2.tr.conn then
			pcall(function()
				list2.tr.conn:Disconnect()
			end)

			list2.tr.conn = nil
		end

		for k in pairs(list2.tr.parts) do
			list2.tr.drop(k)
		end
	end

	list2.tr.sync = function()
		if list2.tr.any() then
			list2.tr.start()
		else
			list2.tr.stop()
		end
	end

	pcall(function()
		local remotes = ReplicatedStorage:FindFirstChild("Remotes")
		remotes = remotes and remotes:FindFirstChild("Gameplay")
		local playerDataChanged = remotes and remotes:FindFirstChild("PlayerDataChanged")

		if playerDataChanged and playerDataChanged:IsA("RemoteEvent") then
			list2.conns[#list2.conns + 1] = playerDataChanged.OnClientEvent:Connect(function(param21)
				value26 = param21

				if func17() then
					func18()
				end
			end)
		end
	end)
end

TeleportService = game:GetService("TeleportService")
local flag33, func27, flag34, func28, func29, func30, func31, func32, func33

do
	local placeId = game.PlaceId
	local jobId = game.JobId
	flag33 = false

	func27 = function(player2)
		if flag33 then
			obj2:Notify({
				Title = "Fling Active!",
				Content = "Wait for the current fling to finish!",
				Duration = 1.5,
				Icon = "clock",
			})

			return
		end

		if not player2 or not player2.Character then
			obj2:Notify({ Title = "Error!", Content = "Could not find that player!", Duration = 1.5, Icon = "x" })
			return
		end

		if not player2.Character:FindFirstChildOfClass("Humanoid") then
			return
		end
		local character = localPlayer.Character
		if not character then
			return
		end
		local humanoid = character:FindFirstChildOfClass("Humanoid")
		if not humanoid then
			return
		end
		local rootPart = humanoid.RootPart
		if not rootPart then
			return
		end
		flag33 = true
		local cFrame = rootPart.CFrame
		local fallenPartsDestroyHeight = Workspace.FallenPartsDestroyHeight
		local health = humanoid.Health
		local character2 = player2.Character
		local humanoid2 = character2:FindFirstChildOfClass("Humanoid")
		local rootPart2 = humanoid2 and humanoid2.RootPart
		local head = character2:FindFirstChild("Head")
		local accessory = character2:FindFirstChildOfClass("Accessory")
		accessory = accessory and accessory:FindFirstChild("Handle")
		if humanoid2 and humanoid2.Sit then
			flag33 = false
			return
		end

		if head then
			Workspace.CurrentCamera.CameraSubject = head
		elseif accessory then
			Workspace.CurrentCamera.CameraSubject = accessory
		elseif humanoid2 then
			Workspace.CurrentCamera.CameraSubject = humanoid2
		end

		local function func34(part2, num2, num3)
			rootPart.CFrame = CFrame.new(part2.Position) * num2 * num3

			pcall(function()
				character:SetPrimaryPartCFrame(CFrame.new(part2.Position) * num2 * num3)
			end)

			rootPart.Velocity = Vector3.new(90000000, 900000000, 90000000)
			rootPart.RotVelocity = Vector3.new(900000000, 900000000, 900000000)
		end

		local function func35(instance)
			local now = tick()
			local n = 0

			while true do
				if not (not rootPart or not humanoid2 or not flag33) then
					if instance.Velocity.Magnitude < 50 then
						n += 100
						local n2 = humanoid2.MoveDirection * instance.Velocity.Magnitude / 1.25
						local cframe = CFrame.Angles
						func34(instance, CFrame.new(0, 1.5, 0) + n2, cframe(math.rad(n), 0, 0))
						task.wait()
						local n3 = humanoid2.MoveDirection * instance.Velocity.Magnitude / 1.25
						local cframe2 = CFrame.Angles
						func34(instance, CFrame.new(0, -1.5, 0) + n3, cframe2(math.rad(n), 0, 0))
						task.wait()
						local n4 = humanoid2.MoveDirection * instance.Velocity.Magnitude / 1.25
						local cframe3 = CFrame.Angles
						func34(instance, CFrame.new(2.25, 1.5, -2.25) + n4, cframe3(math.rad(n), 0, 0))
						task.wait()
						local n5 = humanoid2.MoveDirection * instance.Velocity.Magnitude / 1.25
						local cframe4 = CFrame.Angles
						func34(instance, CFrame.new(-2.25, -1.5, 2.25) + n5, cframe4(math.rad(n), 0, 0))
						task.wait()
						local moveDirection = humanoid2.MoveDirection
						local cframe5 = CFrame.Angles
						func34(instance, CFrame.new(0, 1.5, 0) + moveDirection, cframe5(math.rad(n), 0, 0))
						task.wait()
						local moveDirection2 = humanoid2.MoveDirection
						local cframe6 = CFrame.Angles
						func34(instance, CFrame.new(0, -1.5, 0) + moveDirection2, cframe6(math.rad(n), 0, 0))
						task.wait()
					else
						local cframe = CFrame.Angles
						func34(instance, CFrame.new(0, 1.5, humanoid2.WalkSpeed), cframe(1.5707963267948966, 0, 0))
						task.wait()
						local cframe2 = CFrame.Angles
						func34(instance, CFrame.new(0, -1.5, -humanoid2.WalkSpeed), cframe2(0, 0, 0))
						task.wait()
						local cframe3 = CFrame.Angles
						func34(instance, CFrame.new(0, 1.5, humanoid2.WalkSpeed), cframe3(1.5707963267948966, 0, 0))
						task.wait()
						local cframe4 = CFrame.Angles
						func34(instance, CFrame.new(0, -1.5, 0), cframe4(1.5707963267948966, 0, 0))
						task.wait()
						local cframe5 = CFrame.Angles
						func34(instance, CFrame.new(0, -1.5, 0), cframe5(0, 0, 0))
						task.wait()
						local cframe6 = CFrame.Angles
						func34(instance, CFrame.new(0, -1.5, 0), cframe6(-1.5707963267948966, 0, 0))
						task.wait()
						local cframe7 = CFrame.Angles
						func34(instance, CFrame.new(0, -1.5, 0), cframe7(0, 0, 0))
						task.wait()
					end

					if not (instance.Velocity.Magnitude > 500 or instance.Parent ~= player2.Character or player2.Parent ~= Players or humanoid.Health <= 0 or humanoid.Health < health or humanoid2 and humanoid2.Sit or tick() > now + 2 or not flag33) then
						continue
					end
				end

				break
			end
		end

		Workspace.FallenPartsDestroyHeight = (0/0)
		local bodyVelocity = Instance.new("BodyVelocity")
		bodyVelocity.Name = "SkidFlingBV"
		bodyVelocity.Parent = rootPart
		bodyVelocity.Velocity = Vector3.zero
		bodyVelocity.MaxForce = Vector3.new(math.huge, math.huge, math.huge)
		humanoid:SetStateEnabled(Enum.HumanoidStateType.Seated, false)

		pcall(function()
			if rootPart2 and head then
				if (rootPart2.CFrame.p - head.CFrame.p).Magnitude <= 5 then
					func35(rootPart2)
				else
					func35(head)
				end
			elseif rootPart2 then
				func35(rootPart2)
			elseif head then
				func35(head)
			elseif accessory then
				func35(accessory)
			end
		end)

		bodyVelocity:Destroy()
		humanoid:SetStateEnabled(Enum.HumanoidStateType.Seated, true)
		Workspace.CurrentCamera.CameraSubject = humanoid

		if cFrame then
			pcall(function()
				for i = 1, 50 do
					rootPart.CFrame = cFrame * CFrame.new(0, 0.5, 0)

					pcall(function()
						character:SetPrimaryPartCFrame(cFrame * CFrame.new(0, 0.5, 0))
					end)

					humanoid:ChangeState("GettingUp")

					for _, child in ipairs(character:GetChildren()) do
						if child:IsA("BasePart") then
							child.Velocity = Vector3.zero
							child.RotVelocity = Vector3.zero
						end
					end

					task.wait()
					if not ((rootPart.Position - cFrame.p).Magnitude < 25) then
						continue
					end
					break
				end
			end)
		end

		Workspace.FallenPartsDestroyHeight = fallenPartsDestroyHeight
		flag33 = false

		if humanoid.Health <= 0 then
			obj2:Notify({
				Title = "Fling Backfired",
				Content = player2.Name .. " killed you mid-fling.",
				Duration = 3,
				Icon = "x",
			})
		elseif humanoid.Health < health then
			obj2:Notify({
				Title = "Flinged!",
				Content = "Flinged " .. player2.Name .. " - took a hit, bailed early.",
				Duration = 2,
				Icon = "flame",
			})
		else
			obj2:Notify({ Title = "Flinged!", Content = "Flinged " .. player2.Name .. "!", Duration = 1.5, Icon = "flame" })
		end
	end

	flag34 = false
	local flag35 = false

	func28 = function()
		return nil
	end

	func29 = function()
		if flag35 then
			return
		end
		flag35 = true

		task.spawn(function()
			while flag34 do
				task.wait(0.5)

				pcall(function()
					if not flag34 then
						return
					end

					if flag33 then
						return
					end
					local result4 = func28()
					if not result4 then
						return
					end
					local flag36 = Players:FindFirstChild(result4)

					if flag36 and flag36 ~= localPlayer and flag36.Character then
						func27(flag36)
					end
				end)

				if flag33 then
					while flag33 and flag34 do
						task.wait(0.2)
					end

					task.wait(1)
				end
			end

			flag35 = false
		end)
	end

	func30 = function()
		flag34 = false
	end

	func31 = function(player3, str6)
		player3 = player3 and player3.Character
		if not player3 or not player3:FindFirstChild("HumanoidRootPart") then
			obj2:Notify({ Title = "Error!", Content = "No " .. str6 .. " found!", Duration = 1.5, Icon = "x" })
			return
		end
		local character = localPlayer.Character
		if not character or not character:FindFirstChild("HumanoidRootPart") then
			return
		end
		character.HumanoidRootPart.Velocity = Vector3.zero
		character.HumanoidRootPart.CFrame = player3.HumanoidRootPart.CFrame * CFrame.new(0, 0, 3)
		obj2:Notify({ Title = "Teleported!", Content = "Teleported to " .. str6, Duration = 1.5, Icon = "check" })
	end

	local function func36(url4)
		local ok, result = pcall(function()
			if syn and syn.request then
				return HttpService:JSONDecode(syn.request({ Url = url4, Method = "GET" }).Body)
			end

			if http and http.request then
				return HttpService:JSONDecode(http.request({ Url = url4, Method = "GET" }).Body)
			end

			if request then
				return HttpService:JSONDecode(request({ Url = url4, Method = "GET" }).Body)
			end

			if httpget then
				return HttpService:JSONDecode(httpget(url4))
			end
			return HttpService:JSONDecode(game:HttpGet(url4))
		end)

		if ok then
			return result
		end
		return nil
	end

	func32 = function()
		obj2:Notify({ Title = "Server Hop", Content = "Teleporting to a new server...", Duration = 3, Icon = "loader" })
		task.wait(0.5)

		local ok, result = pcall(function()
			TeleportService:Teleport(placeId)
		end)

		if not ok then
			obj2:Notify({ Title = "Error!", Content = "Failed to hop: " .. tostring(result), Duration = 3, Icon = "x" })
		end
	end

	func33 = function()
		obj2:Notify({
			Title = "Smallest Server",
			Content = "Finding the emptiest server...",
			Duration = 3,
			Icon = "loader",
		})

		local tbl18 = {}
		local n = 0
		local str7 = ""

		while n < 5 do
			n += 1
			local url5 = "https://games.roblox.com/v1/games/" .. placeId .. "/servers/Public?sortOrder=Asc&limit=100"

			if str7 and str7 ~= "" then
				url5 ..= "&cursor=" .. str7
			end

			local flag37 = func36(url5)
			if not flag37 or not flag37.data then
				break
			end

			for _, item10 in ipairs(flag37.data) do
				if item10.id ~= jobId and item10.playing and item10.maxPlayers and item10.playing < item10.maxPlayers then
					table.insert(tbl18, item10)
				end
			end

			str7 = flag37.nextPageCursor
			if not str7 or str7 == "" then
				break
			end
		end

		if #tbl18 == 0 then
			obj2:Notify({
				Title = "No Servers!",
				Content = "No joinable servers found. Trying random hop...",
				Duration = 2,
				Icon = "x",
			})

			task.wait(1)

			pcall(function()
				TeleportService:Teleport(placeId)
			end)

			return
		end

		table.sort(tbl18, function(param22, param23)
			return param22.playing < param23.playing
		end)

		local first2 = tbl18[1]

		obj2:Notify({
			Title = "Joining!",
			Content = "Joining server with " .. first2.playing .. " players...",
			Duration = 2,
			Icon = "check",
		})

		task.wait(0.5)

		pcall(function()
			TeleportService:TeleportToPlaceInstance(placeId, first2.id)
		end)
	end

	list2.HOP_MIN_PLAYERS = 2
	list2.HOP_GRACE = 15
	list2.HOP_RETRY = 60
	list2.HOP_CONFIRM = 6
	list2.hopThread = nil
	list2.hopping = false

	list2.hopAttempt = function()
		obj2:Notify({
			Title = "Server Empty",
			Content = "Under " .. list2.HOP_MIN_PLAYERS .. " players here - hopping...",
			Duration = 4,
			Icon = "loader",
		})

		task.wait(0.5)

		if pcall(function()
			TeleportService:Teleport(placeId)
		end) then
			task.wait(list2.HOP_CONFIRM)
		end

		obj2:Notify({
			Title = "Matchmaking Refused",
			Content = "Picking from the server list...",
			Duration = 3,
			Icon = "x",
		})

		local value33 = nil
		local n = 0
		local str8 = ""

		while n < 4 do
			n += 1
			local url6 = "https://games.roblox.com/v1/games/" .. placeId .. "/servers/Public?sortOrder=Desc&limit=100"

			if str8 ~= "" then
				url6 ..= "&cursor=" .. str8
			end

			local flag38 = func36(url6)

			if not (not flag38 or not flag38.data) then
				for _, item11 in ipairs(flag38.data) do
					if item11.id ~= jobId and item11.playing and item11.maxPlayers and item11.playing < item11.maxPlayers then
						if not value33 or item11.playing > value33.playing then
							value33 = item11
						end
					end
				end

				str8 = flag38.nextPageCursor or ""
				if str8 ~= "" then
					continue
				end
			end

			break
		end

		if value33 then
			obj2:Notify({
				Title = "Hopping",
				Content = "Joining a server with " .. value33.playing .. " players...",
				Duration = 3,
				Icon = "check",
			})

			task.wait(0.5)

			if pcall(function()
				TeleportService:TeleportToPlaceInstance(placeId, value33.id)
			end) then
				task.wait(list2.HOP_CONFIRM)
			end
		end

		return false
	end
end

list2.populatedHop = function()
	if list2.hopping then
		return false
	end
	list2.hopping = true
	local ok, result = pcall(list2.hopAttempt)
	if ok and result then
		return true
	end
	list2.hopping = false

	obj2:Notify({
		Title = "Hop Failed",
		Content = ok and "The server would not let go. Trying again in a minute." or "Hop errored - trying again in a minute.",
		Duration = 4,
		Icon = "x",
	})

	return false
end

list2.stopFarmHopWatch = function()
	if list2.hopThread then
		pcall(task.cancel, list2.hopThread)
		list2.hopThread = nil
	end
end

list2.startFarmHopWatch = function()
	list2.stopFarmHopWatch()

	list2.hopThread = task.spawn(function()
		local n = 0

		while true do
			task.wait(3)
			if not list2.farmHopOn then
				n = 0
				continue
			end

			if not (#Players:GetPlayers() < list2.HOP_MIN_PLAYERS) then
				n = 0
				continue
			end
			n += 3
			if not (list2.HOP_GRACE <= n) then
				continue
			end
			local ok, result = pcall(list2.populatedHop)
			local flag39 = false

			if ok then
				flag39 = result and true or false
			end

			if not flag39 then
				task.wait(list2.HOP_RETRY)
				n = 0
				continue
			end

			break
		end
	end)
end

UserInputService = game:GetService("UserInputService")
list2.touches = {}

pcall(function()
	list2.conns[#list2.conns + 1] = UserInputService.InputBegan:Connect(function(input)
		if input.UserInputType == Enum.UserInputType.Touch then
			list2.touches[input] = true
		end
	end)
end)

list2.pointerHeld = function()
	for k in pairs(list2.touches) do
		if k.UserInputState == Enum.UserInputState.End or k.UserInputState == Enum.UserInputState.Cancel then
			list2.touches[k] = nil
		end
	end

	if next(list2.touches) then
		return true
	end
	local flag40 = false

	pcall(function()
		for _, item12 in ipairs(UserInputService:GetMouseButtonsPressed()) do
			if item12.UserInputType == Enum.UserInputType.MouseButton1 then
				flag40 = true
			end
		end
	end)

	return flag40
end

task.spawn(function()
	while _G.FVLV2 == obj3 do
		task.wait(0.25)

		if obj2.CurrentInput ~= nil and not list2.pointerHeld() then
			obj2.CurrentInput = nil
		end
	end
end)

local flag41
flag41 = false
local flag42, n, flag43, flag44, walkSpeed, jumpPower, func37, func38, func39, func40
local func41, func42, func43, func44, func45, func46

do
	local connection = nil
	flag42 = false
	local connection2 = nil
	local bodyVelocity = nil
	local bodyGyro = nil
	n = 50
	flag43 = false
	local connection3 = nil
	local n2 = 0
	flag44 = false
	local connection4 = nil
	walkSpeed = 16
	jumpPower = 50

	func37 = function(walkSpeed2)
		walkSpeed = walkSpeed2

		pcall(function()
			local humanoid = localPlayer.Character and localPlayer.Character:FindFirstChildOfClass("Humanoid")

			if humanoid then
				humanoid.WalkSpeed = walkSpeed2
			end
		end)
	end

	func38 = function(jumpPower2)
		jumpPower = jumpPower2

		pcall(function()
			local humanoid = localPlayer.Character and localPlayer.Character:FindFirstChildOfClass("Humanoid")

			if humanoid then
				humanoid.JumpPower = jumpPower2
				humanoid.UseJumpPower = true
			end
		end)
	end

	func39 = function()
		if connection then
			return
		end

		connection = RunService.Stepped:Connect(function()
			if not flag41 then
				return
			end

			pcall(function()
				local character = localPlayer.Character

				if character then
					for _, descendant in ipairs(character:GetDescendants()) do
						if descendant:IsA("BasePart") and descendant.CanCollide then
							if list2.clipWas[descendant] == nil then
								list2.clipWas[descendant] = true
							end

							descendant.CanCollide = false
						end
					end
				end
			end)
		end)
	end

	func40 = function()
		if connection then
			connection:Disconnect()
			connection = nil
		end

		list2.reclip(list2.clipWas)
	end

	func41 = function()
		if connection2 then
			return
		end
		local character = localPlayer.Character
		if not character then
			return
		end
		local humanoidRootPart = character:FindFirstChild("HumanoidRootPart")
		if not humanoidRootPart then
			return
		end
		local humanoid = character:FindFirstChildOfClass("Humanoid")
		if not humanoid then
			return
		end
		bodyVelocity = Instance.new("BodyVelocity")
		bodyVelocity.Name = "FlyVelocity"
		bodyVelocity.Velocity = Vector3.zero
		bodyVelocity.MaxForce = Vector3.new(math.huge, math.huge, math.huge)
		bodyVelocity.Parent = humanoidRootPart
		bodyGyro = Instance.new("BodyGyro")
		bodyGyro.Name = "FlyGyro"
		bodyGyro.P = 90000
		bodyGyro.MaxTorque = Vector3.new(9e9, 9e9, 9e9)
		bodyGyro.CFrame = humanoidRootPart.CFrame
		bodyGyro.Parent = humanoidRootPart
		humanoid.PlatformStand = true

		connection2 = RunService.Heartbeat:Connect(function()
			pcall(function()
				if not flag42 then
					return
				end
				local currentCamera = Workspace.CurrentCamera
				bodyGyro.CFrame = currentCamera.CFrame
				local obj5 = UserInputService
				local vector = Vector3.zero

				if obj5:IsKeyDown(Enum.KeyCode.W) then
					vector = Vector3.zero + currentCamera.CFrame.LookVector
				end

				if UserInputService:IsKeyDown(Enum.KeyCode.S) then
					vector -= currentCamera.CFrame.LookVector
				end

				if UserInputService:IsKeyDown(Enum.KeyCode.A) then
					vector -= currentCamera.CFrame.RightVector
				end

				if UserInputService:IsKeyDown(Enum.KeyCode.D) then
					vector += currentCamera.CFrame.RightVector
				end

				if UserInputService:IsKeyDown(Enum.KeyCode.Space) then
					vector += Vector3.new(0, 1, 0)
				end

				if UserInputService:IsKeyDown(Enum.KeyCode.LeftShift) then
					vector -= Vector3.new(0, 1, 0)
				end

				if vector.Magnitude > 0 then
					bodyVelocity.Velocity = vector.Unit * n
				else
					bodyVelocity.Velocity = Vector3.zero
				end
			end)
		end)
	end

	func42 = function()
		if connection2 then
			connection2:Disconnect()
			connection2 = nil
		end

		if bodyVelocity then
			bodyVelocity:Destroy()
			bodyVelocity = nil
		end

		if bodyGyro then
			bodyGyro:Destroy()
			bodyGyro = nil
		end

		pcall(function()
			local humanoid = localPlayer.Character and localPlayer.Character:FindFirstChildOfClass("Humanoid")

			if humanoid then
				humanoid.PlatformStand = false
			end
		end)
	end

	func43 = function()
		if connection3 then
			return
		end

		connection3 = UserInputService.JumpRequest:Connect(function()
			if not flag43 then
				return
			end
			local now = tick()
			if now - n2 < 0.15 then
				return
			end
			n2 = now

			pcall(function()
				local humanoid = localPlayer.Character and localPlayer.Character:FindFirstChildOfClass("Humanoid")
				local flag45

				if humanoid then
					local jumping = Enum.HumanoidStateType.Jumping
					flag45 = humanoid:GetState() ~= jumping
				else
					flag45 = humanoid
				end

				if flag45 then
					humanoid:ChangeState(Enum.HumanoidStateType.Jumping)
				end
			end)
		end)
	end

	func44 = function()
		if connection3 then
			connection3:Disconnect()
			connection3 = nil
		end
	end

	func45 = function()
		if connection4 then
			return
		end

		connection4 = RunService.Heartbeat:Connect(function()
			if not flag44 then
				return
			end

			pcall(function()
				local character = localPlayer.Character
				if not character then
					return
				end
				local humanoidRootPart = character:FindFirstChild("HumanoidRootPart")
				if not humanoidRootPart then
					return
				end

				for _, player in ipairs(Players:GetPlayers()) do
					if player ~= localPlayer and player.Character then
						for _, descendant in ipairs(player.Character:GetDescendants()) do
							if descendant:IsA("BasePart") and not descendant.Anchored and descendant.Velocity.Magnitude > 200 then
								if (descendant.Position - humanoidRootPart.Position).Magnitude < 30 then
									descendant.Velocity = Vector3.zero
									descendant.RotVelocity = Vector3.zero
									descendant.Anchored = true

									task.delay(0.3, function()
										if descendant and descendant.Parent then
											descendant.Anchored = false
										end
									end)
								end
							end
						end
					end
				end
			end)
		end)
	end

	func46 = function()
		if connection4 then
			connection4:Disconnect()
			connection4 = nil
		end
	end
end

list2.conns[#list2.conns + 1] = localPlayer.CharacterAdded:Connect(function(character)
	character:WaitForChild("Humanoid")
	task.wait(0.5)

	pcall(function()
		local humanoid = character:FindFirstChildOfClass("Humanoid")

		if humanoid then
			if walkSpeed ~= 16 then
				humanoid.WalkSpeed = walkSpeed
			end

			if jumpPower ~= 50 then
				humanoid.JumpPower = jumpPower
				humanoid.UseJumpPower = true
			end
		end
	end)

	if flag42 then
		pcall(func42)
		task.wait(0.2)
		pcall(func41)
	end

	if flag41 then
		pcall(func40)
		pcall(func39)
	end
end)

TweenService = game:GetService("TweenService")
VirtualUser = game:GetService("VirtualUser")
local obj6, n2, flag46, flag47, func47, func48, func49, func50, func51, func52
local func53

do
	local flag48 = false
	local flag49 = false
	obj6 = nil
	local value34 = nil
	local flag50 = false
	local tween = nil
	local value35 = nil
	local connection = nil
	n2 = 23
	local n3 = 0
	local value36 = nil
	flag46 = false
	local flag51 = false
	flag47 = false
	local connection2 = nil

	local function func54(instance2, flag52, flag53)
		local value37 = next
		local children, value38 = instance2:GetChildren()

		for _, value39 in value37, children, value38 do
			if value39.Name == flag52 and (not flag53 or value39.ClassName == flag53) then
				return value39
			end
		end
	end

	func47 = function(player4)
		if player4 and player4.Character then
			return func54(player4.Character, "HumanoidRootPart") or func54(player4.Character, "PrimaryPart")
		end
	end

	local function func55()
		local flag54 = func47(localPlayer)
		if not flag54 or not obj6 then
			return nil
		end
		local coinContainer = func54(obj6, "CoinContainer")
		if not coinContainer then
			return nil
		end
		local value40 = next
		local children, value41 = coinContainer:GetChildren()
		local huge = math.huge
		local value42 = nil

		for _, value43 in value40, children, value41 do
			if value43.Name == "Coin_Server" and not value43:GetAttribute("Collected") and not list2.coinSkip(value43) then
				local magnitude = (flag54.Position - value43.Position).Magnitude

				if magnitude < huge then
					huge = magnitude
					value42 = value43
				end
			end
		end

		return value42
	end

	local function func56()
		local roundTimerPart = Workspace:FindFirstChild("RoundTimerPart")
		if roundTimerPart then
			return tonumber(roundTimerPart:GetAttribute("Time")) or 0
		end
		return 0
	end

	local function func57()
		local ok, result = pcall(function()
			local container

			if not list2.inLobbyNow() then
				container = localPlayer.PlayerGui.MainGUI.Game.CoinBags.Container
			else
				container = localPlayer.PlayerGui.MainGUI.Lobby.Dock.CoinBags.Container
			end

			if not container then
				return 0
			end
			local value44 = next
			local children, value45 = container:GetChildren()
			local value46 = nil

			for _, value47 in value44, children, value45 do
				if value47:IsA("GuiObject") and value47:FindFirstChild("CurrencyFrame") then
					if value47.Visible then
						value46 = value47
						break
					elseif value47.Name == "Coin" and not value46 then
						value46 = value47
					end
				end
			end

			if not value46 then
				return 0
			end
			local full = value46:FindFirstChild("Full")
			if full and full.Visible then
				return 999
			end
			local currencyFrame = value46:FindFirstChild("CurrencyFrame")
			currencyFrame = currencyFrame and currencyFrame:FindFirstChild("Icon")
			currencyFrame = currencyFrame and currencyFrame:FindFirstChild("Coins")
			currencyFrame = currencyFrame and currencyFrame.Text
			if currencyFrame and (string.lower(currencyFrame):find("full") or string.lower(currencyFrame):find("max")) then
				return 999
			end
			return tonumber(currencyFrame) or 0
		end)

		if ok then
			return result
		end
		return 0
	end

	local function func58(param24)
		if param24 then
			if not connection then
				connection = RunService.Stepped:Connect(function()
					local character = localPlayer.Character

					if character then
						local value48 = next
						local descendants, value49 = character:GetDescendants()

						for _, value50 in value48, descendants, value49 do
							if value50:IsA("BasePart") and value50.CanCollide then
								if list2.farmClipWas[value50] == nil then
									list2.farmClipWas[value50] = true
								end

								value50.CanCollide = false
							end
						end
					end
				end)
			end
		else
			if connection then
				connection:Disconnect()
				connection = nil
			end

			list2.reclip(list2.farmClipWas)
		end
	end

	local function func59(param25)
		local upperTorso = localPlayer.Character and localPlayer.Character:FindFirstChild("UpperTorso")
		if not upperTorso then
			return
		end
		local odhAutoFarmBodyGyro = upperTorso:FindFirstChild("ODH Auto Farm BodyGyro")
		local odhAutoFarmBodyVelocity = upperTorso:FindFirstChild("ODH Auto Farm BodyVelocity")

		if param25 then
			odhAutoFarmBodyGyro = odhAutoFarmBodyGyro or odhAutoFarmBodyVelocity
			if odhAutoFarmBodyGyro then
				return
			end
			local flag55 = func47(localPlayer)
			if not flag55 then
				return
			end
			local humanoid = localPlayer.Character:FindFirstChild("Humanoid")
			if not humanoid then
				return
			end
			local cFrame = flag55.CFrame
			local cFrame2 = CFrame.new(cFrame.X, cFrame.Y, cFrame.Z) * CFrame.Angles(1.5707963267948966, 0, 1.5707963267948966)
			func58(true)
			local bodyGyro = Instance.new("BodyGyro")
			bodyGyro.Name = "ODH Auto Farm BodyGyro"
			bodyGyro.Parent = upperTorso
			bodyGyro.P = 90000
			bodyGyro.MaxTorque = Vector3.new(9e9, 9e9, 9e9)
			bodyGyro.CFrame = cFrame2
			local bodyVelocity = Instance.new("BodyVelocity")
			bodyVelocity.Name = "ODH Auto Farm BodyVelocity"
			bodyVelocity.Parent = upperTorso
			bodyVelocity.Velocity = Vector3.zero
			bodyVelocity.MaxForce = Vector3.new(9e9, 9e9, 9e9)
			flag55.CFrame = cFrame2
			humanoid.PlatformStand = true
		else
			local humanoid = localPlayer.Character and localPlayer.Character:FindFirstChild("Humanoid")

			if humanoid then
				if odhAutoFarmBodyGyro then
					odhAutoFarmBodyGyro:Destroy()
				end

				if odhAutoFarmBodyVelocity then
					odhAutoFarmBodyVelocity:Destroy()
				end

				humanoid.PlatformStand = false
				func58(false)
			end
		end
	end

	local function func60()
		if not obj6 then
			return
		end
		local value51 = next
		local children, value52 = obj6.Spawns:GetChildren()
		local value53 = nil

		for _, value54 in value51, children, value52 do
			if value54.Name == "Spawn" or value54.Name == "PlayerSpawn" or value54.Name == "SpawnLocation" then
				value53 = value54
			end
		end

		if not value53 then
			return
		end
		local cFrame = value53.CFrame
		local value55 = func47(localPlayer)

		if value55 then
			value55.Velocity = Vector3.zero
			value55.CFrame = CFrame.new(cFrame.X, cFrame.Y + 5, cFrame.Z)
		end
	end

	local function func61()
		pcall(function()
			local playerGui = localPlayer:FindFirstChild("PlayerGui")
			playerGui = playerGui and playerGui:FindFirstChild("MainGUI")
			playerGui = playerGui and playerGui:FindFirstChild("Game")

			if playerGui then
				value34 = not playerGui:FindFirstChild("Inventory")
			end
		end)

		local value56 = next
		local children, value57 = Workspace:GetChildren()

		for _, value58 in value56, children, value57 do
			if value58:FindFirstChild("CoinAreas") or value58:FindFirstChild("CoinContainer") then
				obj6 = value58
			end
		end

		flag50 = false
		tween = nil
		value35 = nil
	end

	local function func62()
		if flag50 then
			flag50 = false
			value35 = nil

			if localPlayer.Character then
				if tween then
					tween:Cancel()
					tween = nil
				end

				func59(false)

				if func56() > 0 and obj6 then
					func60()
				end
			end
		end
	end

	func48 = function()
		if flag48 then
			return
		end
		flag48 = true
		func61()

		task.spawn(function()
			while flag48 do
				task.wait(0.1)

				pcall(function()
					if not flag48 then
						return
					end

					if not localPlayer.Character then
						flag49 = false
					else
						local remotes = ReplicatedStorage:FindFirstChild("Remotes")
						local extras = remotes and remotes:FindFirstChild("Extras")
						local getPlayerData = extras and extras:FindFirstChild("GetPlayerData")

						if getPlayerData then
							local ok, result = pcall(function()
								return getPlayerData:InvokeServer()
							end)

							if ok and result then
								local entry1 = result[localPlayer.Name]

								if entry1 then
									entry1 = not entry1.Dead and not entry1.Killed
								end

								flag49 = entry1
							end
						end
					end

					local value59 = next
					local children, value60 = Workspace:GetChildren()

					for _, value61 in value59, children, value60 do
						if value61:FindFirstChild("CoinAreas") or value61:FindFirstChild("CoinContainer") then
							obj6 = value61
						end
					end

					if obj6 ~= list2.lastMap then
						list2.lastMap = obj6
						list2.sawCoins = false
						list2.flingDoneFired = false
						list2.killFired = false
						list2.coinReset()
					end

					local flag56 = func47(localPlayer)

					if flag49 and obj6 and flag56 and not list2.sawCoins and not func55() then
						if list2.hideUnderMap(flag56) then
							return
						end
					end

					if func56() > 0 then
						local result5 = func57()

						if (localPlayer:GetAttribute("Elite") and 50 or 40) <= result5 then
							func62()
							list2.finishFling()

							if list2.killWhenFull and not list2.killFired and func15() == localPlayer then
								list2.killFired = true

								task.spawn(function()
									pcall(killAll)
								end)
							end
						elseif flag49 and localPlayer.Character then
							local num4 = func47(localPlayer)
							local obj7 = num4 and func55()

							if num4 and obj7 then
								list2.sawCoins = true

								if obj7 ~= value35 or value35 and value35:GetAttribute("Collected") then
									value35 = obj7
									flag50 = true
									list2.farmTargetTime = tick()

									if tween then
										tween:Cancel()
										tween = nil
									end

									func59(true)
									local cFrame = obj7.CFrame
									local n4 = (num4.Position - obj7.Position).Magnitude / n2

									if n4 > 15 then
										n4 = 3
									end

									if n4 < 0.05 then
										n4 = 0.05
									end

									num4.Velocity = Vector3.zero

									tween = TweenService:Create(num4, TweenInfo.new(n4, Enum.EasingStyle.Linear), {
										CFrame = CFrame.new(cFrame.X, cFrame.Y - 3.5, cFrame.Z) * CFrame.Angles(1.5707963267948966, 0, 1.5707963267948966),
									})

									tween:Play()
									num4.Velocity = Vector3.zero
								else
									local magnitude = (num4.Position - obj7.Position).Magnitude

									if magnitude <= 6 and not obj7:GetAttribute("Collected") then
										obj7.CFrame = CFrame.new(num4.Position + Vector3.new(math.random(-80, 80) / 100, math.random(-50, 300) / 100, math.random(-80, 80) / 100))

										if (obj7.Position - num4.Position).Magnitude > 0.1 then
											num4.CFrame = num4.CFrame * CFrame.new(0, math.random(-20, 20) / 100, math.random(-20, 20) / 100)
										end

										if value36 ~= obj7 then
											value36 = obj7
											n3 = tick()
										end

										if tick() - n3 > 2 then
											value36 = nil
											n3 = 0
											value35 = nil
										end
									elseif magnitude > 6 then
										local farmTargetTime = list2.farmTargetTime

										if tick() - farmTargetTime > 4 then
											list2.coinFailed(obj7)
											value35 = nil
											value36 = nil
											n3 = 0
										end
									end
								end
							elseif num4 then
								if list2.sawCoins then
									func62()
									list2.finishFling()
								end
							end
						else
							func62()
						end
					else
						func62()
					end
				end)
			end
		end)
	end

	list2.inActiveRound = function()
		if list2.inLobbyNow() then
			return false
		end

		if not flag49 then
			return false
		end
		local value62 = next
		local children, value63 = Workspace:GetChildren()
		local value64 = nil

		for _, value65 in value62, children, value63 do
			if value65:FindFirstChild("CoinAreas") or value65:FindFirstChild("CoinContainer") then
				value64 = value65
			end
		end

		if not value64 then
			return false
		end
		local character = localPlayer.Character
		character = character and character:FindFirstChildOfClass("Humanoid")
		if not character or character.Health <= 0 then
			return false
		end
		obj6 = value64
		return true
	end

	list2.teleportHome = function()
		if not obj6 then
			return
		end
		local spawns = obj6:FindFirstChild("Spawns")
		if not spawns then
			return
		end
		local value66 = next
		local children, value67 = spawns:GetChildren()
		local value68 = nil
		local value69 = nil

		for _, value70 in value66, children, value67 do
			if value70:IsA("BasePart") then
				value68 = value68 or value70

				if value70.Name == "Spawn" or value70.Name == "PlayerSpawn" or value70.Name == "SpawnLocation" then
					value69 = value70
				end
			end
		end

		value69 = value69 or value68
		if not value69 then
			return
		end
		local flag57 = func47(localPlayer)
		if not flag57 then
			return
		end
		local humanoid = localPlayer.Character and localPlayer.Character:FindFirstChildOfClass("Humanoid")

		if humanoid then
			humanoid.PlatformStand = false
			humanoid:ChangeState(Enum.HumanoidStateType.GettingUp)
		end

		local cFrame = value69.CFrame
		flag57.Velocity = Vector3.zero
		flag57.RotVelocity = Vector3.zero
		flag57.CFrame = CFrame.new(cFrame.X, cFrame.Y + value69.Size.Y / 2 + 4, cFrame.Z)
	end

	func49 = function()
		flag48 = false

		if tween then
			pcall(function()
				tween:Cancel()
			end)

			tween = nil
		end

		pcall(function()
			func59(false)
		end)

		local flag58 = false

		pcall(function()
			if not (localPlayer.Character and func47(localPlayer)) then
				return
			end
			flag58 = list2.inActiveRound()

			if flag58 then
				list2.teleportHome()
			end
		end)

		task.spawn(function()
			task.wait(0.35)

			pcall(function()
				if tween then
					tween:Cancel()
					tween = nil
				end
			end)

			pcall(function()
				func59(false)
			end)

			local flag59 = false

			pcall(function()
				local character = localPlayer.Character
				if not character then
					return
				end
				local value71 = next
				local descendants, value72 = character:GetDescendants()

				for _, value73 in value71, descendants, value72 do
					if value73.Name == "ODH Auto Farm BodyGyro" or value73.Name == "ODH Auto Farm BodyVelocity" then
						value73:Destroy()
						flag59 = true
					end
				end

				local humanoid = character:FindFirstChildOfClass("Humanoid")

				if humanoid and humanoid.PlatformStand then
					humanoid.PlatformStand = false
					humanoid:ChangeState(Enum.HumanoidStateType.GettingUp)
					flag59 = true
				end
			end)

			if flag58 and flag59 then
				pcall(list2.teleportHome)
			end
		end)
	end

	list2.claimRewardPopup = function()
		local playerGui = localPlayer:FindFirstChild("PlayerGui")
		if not playerGui then
			return false
		end
		local claim = nil
		local crossPlatform = playerGui:FindFirstChild("CrossPlatform")
		local medium = crossPlatform and crossPlatform:FindFirstChild("NewItem") and crossPlatform.NewItem:FindFirstChild("Medium")

		if medium and medium.Visible then
			claim = medium:FindFirstChild("Container") and medium.Container:FindFirstChild("Claim")
		else
			medium = playerGui:FindFirstChild("MainGUI") and playerGui.MainGUI:FindFirstChild("Game")
			medium = medium and medium:FindFirstChild("NewItem")
			local visible = medium and medium.Visible
			local value74 = nil

			if visible then
				claim = medium:FindFirstChild("Container") and medium.Container:FindFirstChild("Claim")
			else
				medium = value74
			end
		end

		if not medium or not claim then
			return false
		end
		local amount = medium:FindFirstChild("Amount", true)
		local label = medium:FindFirstChild("Label", true)
		local icon = medium:FindFirstChild("Icon", true)
		local text = amount and amount.Text or nil
		local text2 = label and label.Text or nil
		local match = icon and tostring(icon.Image):match("%d+") or nil

		task.spawn(function()
			pcall(list2.whReward, text, text2, match)
		end)

		if getconnections then
			for _, item13 in ipairs({ "Activated", "MouseButton1Click" }) do
				local ok, result = pcall(getconnections, claim[item13])

				if ok and result and #result > 0 then
					for _, value75 in next, result, nil do
						pcall(function()
							value75:Fire()
						end)
					end

					return true
				end
			end
		end

		return (pcall(function()
			local VirtualInputManager = game:GetService("VirtualInputManager")
			local absolutePosition = claim.AbsolutePosition
			local absoluteSize = claim.AbsoluteSize
			local n4 = absolutePosition.X + absoluteSize.X / 2
			local n5 = absolutePosition.Y + absoluteSize.Y / 2 + 36
			VirtualInputManager:SendMouseButtonEvent(n4, n5, 0, true, game, 1)
			task.wait(0.05)
			VirtualInputManager:SendMouseButtonEvent(n4, n5, 0, false, game, 1)
		end))
	end

	list2.startShells = function()
		if list2.shellsRunning then
			return
		end
		list2.shellsRunning = true

		task.spawn(function()
			while list2.shellsOn do
				task.wait(0.5)
				pcall(list2.claimRewardPopup)
			end

			list2.shellsRunning = false
		end)
	end

	list2.stopShells = function()
		list2.shellsOn = false
	end

	list2.SBOX_DELAY = 1
	list2.CUR_NAME = { SummerKey2026 = "Shells" }

	list2.curName = function(param26)
		return list2.CUR_NAME[param26] or tostring(param26)
	end

	list2.BOX_CURRENCY = { Summer2026Box = "SummerKey2026" }

	list2.BOXES = {
		{ "Summer2026Box", "Summer Box '26" },
		{ "MysteryBox1", "Mystery Box #1" },
		{ "MysteryBox2", "Mystery Box #2" },
		{ "KnifeBox1", "Knife Box #1" },
		{ "KnifeBox2", "Knife Box #2" },
		{ "KnifeBox3", "Knife Box #3" },
		{ "KnifeBox4", "Knife Box #4" },
		{ "KnifeBox5", "Knife Box #5" },
		{ "GunBox1", "Gun Box #1" },
		{ "GunBox2", "Gun Box #2" },
		{ "GunBox3", "Gun Box #3" },
		{ "MLG Box", "Rainbow Box" },
	}

	list2.boxOn = {}
	list2.boxRunning = {}
	list2.boxWaiting = {}

	list2.boxPrice = function(param27)
		local str9 = list2.BOX_CURRENCY[param27] or "Coins"
		local ok, result = pcall(require, game:GetService("ReplicatedStorage").Database.Sync.NewShop)
		if not ok or type(result) ~= "table" then
			return str9, nil
		end
		local entry2 = result[param27]
		local price = type(entry2) == "table" and type(entry2.Price) == "table" and entry2.Price or nil
		return str9, price and tonumber(price[str9]) or nil
	end

	list2.boxImage = function(param28)
		local ok, result = pcall(require, game:GetService("ReplicatedStorage").Database.Sync.MysteryBox)
		if not ok or type(result) ~= "table" then
			return nil
		end
		local entry3 = result[param28]
		return type(entry3) == "table" and entry3.Image or nil
	end

	list2.boxFunds = function(param29)
		local tbl19 = list2.readOwned()
		if not tbl19 then
			return nil
		end
		return tonumber(tbl19[param29]) or 0
	end

	list2.openBox = function(payload)
		local remotes = game:GetService("ReplicatedStorage"):FindFirstChild("Remotes")
		remotes = remotes and remotes:FindFirstChild("Shop")
		remotes = remotes and remotes:FindFirstChild("OpenCrate")
		if not remotes then
			return nil, "the OpenCrate remote is gone"
		end
		local str10 = list2.BOX_CURRENCY[payload] or "Coins"

		local ok, result = pcall(function()
			return remotes:InvokeServer(payload, "MysteryBox", str10)
		end)

		if not ok then
			return nil, tostring(result)
		end
		return result
	end

	list2.startBox = function(param30, param31)
		if list2.boxRunning[param30] then
			return
		end
		list2.boxRunning[param30] = true

		task.spawn(function()
			local n4 = 0

			while list2.boxOn[param30] do
				local value76, num5 = list2.boxPrice(param30)
				local num6 = list2.boxFunds(value76)

				if num5 and num6 and num6 < num5 then
					if not list2.boxWaiting[param30] then
						list2.boxWaiting[param30] = true

						obj2:Notify({
							Title = param31,
							Content = "Waiting for " .. list2.comma(num5 - num6) .. " more " .. list2.curName(value76) .. ". It opens on its own once you can afford one.",
							Duration = 5,
							Icon = "clock",
						})
					end

					task.wait(5)
				else
					list2.boxWaiting[param30] = false
					local flag60, flag61 = list2.openBox(param30)

					if not flag60 then
						local flag62 = list2.boxFunds(value76)

						if num5 and flag62 and flag62 < num5 then
							task.wait(5)
						else
							list2.boxOn[param30] = false

							if list2.el.box and list2.el.box[param30] then
								list2.setToggle(list2.el.box[param30], false)
							end

							obj2:Notify({
								Title = param31,
								Content = (n4 > 0 and "Opened " .. n4 .. ", then stopped: " or "Nothing opened: ") .. (flag61 or "the server refused") .. ".",
								Duration = 6,
								Icon = "x",
							})

							break
						end
					else
						n4 += 1

						task.spawn(function()
							pcall(list2.whBox, flag60)
						end)

						task.wait(list2.SBOX_DELAY)
					end
				end
			end

			list2.boxRunning[param30] = false
			list2.boxWaiting[param30] = false
		end)
	end

	list2.stopBox = function(param32)
		list2.boxOn[param32] = false
	end

	_G.__FVLBuild = "gatestyle-38"
	_G.__FVLGen = (_G.__FVLGen or 0) + 1
	list2.gen = _G.__FVLGen

	list2.current = function()
		return list2.gen == _G.__FVLGen
	end

	list2.WH_URL = ""
	list2.whOn = false

	list2.whUrlNow = function()
		return (tostring(list2.WH_URL or ""):gsub("^%s+", ""):gsub("%s+$", ""))
	end

	list2.WH_HOSTS = { "discord.com", "discordapp.com", "canary.discord.com", "ptb.discord.com" }

	list2.whReady = function()
		if not list2.current() then
			return false
		end

		if not list2.whOn then
			return false
		end

		if list2.whBreak then
			return false
		end
		local obj8 = list2.whUrlNow()

		for _, whHost in ipairs(list2.WH_HOSTS) do
			if obj8:find("^https://" .. whHost:gsub("%.", "%%.") .. "/api/webhooks/") then
				return true
			end
		end

		return false
	end

	list2.COIN_ICON = "197012173"
	list2.CLR_LINE = 1
	list2.BANNER = "https://media.discordapp.net/attachments/1538692700096831508/1540857194465988689/onyxscripts.png?ex=6a8b7a96&is=6a8a2916&hm=adfd88f586dc9af0ec57345e6b06ae67e779e414c854e73beb378bff8444f74f&=&format=webp&quality=lossless&width=550&height=310"

	list2.comma = function(param33)
		local num7 = tonumber(param33)
		if num7 == nil then
			return "?"
		end
		local str11 = num7 < 0 and "-" or ""
		local func63 = tostring
		local packed1 = table.pack(math.floor(math.abs(num7)))
		return str11 .. func63(table.unpack(packed1, 1, packed1.n)):reverse():gsub("(%d%d%d)", "%1,"):reverse():gsub("^,", "")
	end

	list2.fld = function(param34, param35, flag63)
		return { name = param34, value = param35, inline = flag63 ~= false }
	end

	list2.avatarUrl = function()
		if list2.avatarCache ~= nil then
			return list2.avatarCache or nil
		end
		local localPlayer2 = game:GetService("Players").LocalPlayer

		local ok, result = pcall(function()
			return game:HttpGet("https://thumbnails.roblox.com/v1/users/avatar-headshot?userIds=" .. tostring(localPlayer2.UserId) .. "&size=150x150&format=Png&isCircular=false")
		end)

		local match = ok and type(result) == "string" and result:match("\"imageUrl\"%s*:%s*\"([^\"]+)\"") or nil
		list2.avatarCache = match or false
		return match
	end

	list2.markUrl = function()
		if list2.markCache then
			return list2.markCache
		end
		local match = list2.markIcon and tostring(list2.markIcon.Image):match("(%d+)")
		if not match then
			return nil
		end
		list2.markCache = list2.itemThumb(match) or nil
		return list2.markCache
	end

	list2.FARM_FLAGS = {
		{ "Toggle_Coin_Autofarm", "Coin Autofarm" },
		{ "Slider_Farm_Speed", "Farm Speed" },
		{ "Toggle_Discord_Sender", "Discord Sender" },
		{ "Toggle_Farm_Perf_Master", "Performance Mode" },
		{ "Toggle_Farm_Dead_Hop", "Hop When Server Dies" },
		{ "Toggle_Anti_AFK", "Anti-AFK" },
		{ "Toggle_Auto_Reset_When_Bag_Full", "Auto-Reset When Bag Full" },
		{ "Toggle_Auto_Claim_Shells", "Auto Claim Shells" },
		{ "Toggle_Auto_Summer_Box", "Auto Open Summer Box" },
		{ "Toggle_Fling_Murderer_When_Done", "Fling Murderer When Done" },
		{ "Toggle_Kill_All_When_Bag_Full", "Kill All When Bag Full" },
	}

	list2.flagText = function(flag64, param36)
		if flag64 == "Toggle_Discord_Sender" then
			return list2.whOn and "on" or "off"
		end

		if param36.__type == "Slider" then
			return type(param36.Value) == "table" and tostring(param36.Value.Default) or tostring(param36.Value)
		end
		return param36.Value == true and "on" or "off"
	end

	list2.settingsBlob = function()
		local elements = list2.config and list2.config.Elements
		if type(elements) ~= "table" then
			return "_unavailable_"
		end
		local list5 = {}
		local n4 = 0

		for _, farmFlag in ipairs(list2.FARM_FLAGS) do
			local value77 = elements[farmFlag[1]]

			if type(value77) == "table" then
				list5[#list5 + 1] = { farmFlag[2], list2.flagText(farmFlag[1], value77) }

				if n4 < #farmFlag[2] then
					n4 = #farmFlag[2]
				end
			end
		end

		if #list5 == 0 then
			return "_unavailable_"
		end
		local tbl20 = {}

		for _, item14 in ipairs(list5) do
			local n5 = #tbl20 + 1
			local second2 = item14[2]
			tbl20[n5] = item14[1] .. string.rep(" ", n4 - #item14[1] + 2) .. second2
		end

		local str12 = "```\n" .. table.concat(tbl20, "\n") .. "\n```"

		if #str12 > 1000 then
			str12 = str12:sub(1, 986) .. "\n...\n```"
		end

		return str12
	end

	list2.setState = function()
		local elements = list2.config and list2.config.Elements
		if type(elements) ~= "table" then
			return nil
		end
		local tbl21 = {}

		for _, farmFlag in ipairs(list2.FARM_FLAGS) do
			local value78 = elements[farmFlag[1]]

			if type(value78) == "table" then
				tbl21[farmFlag[1]] = list2.flagText(farmFlag[1], value78)
			end
		end

		return tbl21
	end

	list2.setDiff = function(tbl22, list6)
		if type(tbl22) ~= "table" or type(list6) ~= "table" then
			return {}
		end
		local tbl23 = {}

		for _, farmFlag in ipairs(list2.FARM_FLAGS) do
			tbl23[farmFlag[1]] = farmFlag[2]
		end

		local list7 = {}

		for k, value79 in pairs(list6) do
			if tbl22[k] ~= nil and tbl22[k] ~= value79 then
				list7[#list7 + 1] = "**" .. tostring(tbl23[k] or k) .. "**  " .. tostring(tbl22[k]) .. "  ->  **" .. tostring(value79) .. "**"
			end
		end

		table.sort(list7)
		return list7
	end

	list2.whSettings = function(list8)
		if not list2.whReady() then
			return false, "not sending"
		end
		local flag65 = list8 and #list8 > 0
		local str13 = "Autofarm settings changed."

		if flag65 then
			str13 = table.concat(list8, "\n")

			if #str13 > 3500 then
				str13 = str13:sub(1, 3480) .. "\n..."
			end
		end

		return list2.whPost({
			title = "Settings Changed",
			body = str13,
			thumb = list2.avatarUrl(),
			fields = { { name = "Autofarm Settings", value = list2.settingsBlob(), inline = false } },
		})
	end

	task.spawn(function()
		task.wait(15)
		list2.setSnap = list2.setState()

		while true do
			task.wait(3)

			if not list2.current() then
				break
			else
				local flag66 = list2.setState()

				if flag66 and list2.setSnap then
					if #list2.setDiff(list2.setSnap, flag66) > 0 then
						task.wait(3)
						local value80 = list2.setState() or flag66
						local list9 = list2.setDiff(list2.setSnap, value80)
						list2.setSnap = value80

						if #list9 > 0 and list2.whReady() then
							task.spawn(function()
								pcall(list2.whSettings, list9)
							end)
						end
					end
				elseif flag66 then
					list2.setSnap = flag66
				end
			end
		end
	end)

	list2.whHello = function()
		if list2.saidHello then
			return true, "already sent"
		end
		local localPlayer2 = game:GetService("Players").LocalPlayer
		list2.readCoins()
		list2.readShells()
		local whPost = list2.whPost

		local tbl24 = {
			title = "F$VL logger started",
			body = "Logging as **" .. localPlayer2.DisplayName .. "** since <t:" .. tostring(os.time()) .. ":f>.",
			thumb = list2.avatarUrl(),
			wait = true,
		}

		local pad3 = list2.pad3
		local value81 = list2.fld("User ID", "`" .. tostring(localPlayer2.UserId) .. "`")
		local Coins = list2.fld("Coins", "`" .. list2.comma(list2.coinsTotal) .. "`")
		local Shells = list2.fld("Shells", "`" .. list2.comma(list2.shellsLeft) .. "`")
		local fld = list2.fld
		local value82 = list2.settingsBlob()
		local tbl25 = { value81, Coins, Shells }

		do
			local values = table.pack(fld("Autofarm settings", value82, false))
			table.move(values, 1, values.n, 4, tbl25)
		end

		tbl24.fields = pad3(tbl25)
		local value83, value84 = whPost(tbl24)

		if value83 then
			list2.saidHello = true
		end

		return value83, value84
	end

	list2.whQ = {}
	list2.whQBusy = false
	list2.whSentN = 0
	list2.whDropped = 0
	list2.whLastErr = nil
	list2.whBreak = false

	list2.whSend = function(param37)
		local request_ = syn and syn.request or request or http_request or http and http.request
		if not request_ then
			return false, "no request function", nil
		end

		local ok, result = pcall(request_, {
			Url = list2.whUrlNow(),
			Method = "POST",
			Headers = { ["Content-Type"] = "application/json" },
			Body = param37,
		})

		if not ok then
			return false, "request failed", 5
		end
		local n4 = tonumber(type(result) == "table" and (result.StatusCode or result.Status) or nil) or 0
		if n4 == 204 or n4 == 200 or n4 == 0 and type(result) == "table" and result.Success == true then
			return true, tostring(n4), nil
		end

		if n4 == 429 then
			local flag67 = type(result) == "table"

			if flag67 then
				flag67 = tostring(result.Body or "")
			end

			return false, "429", math.min(60, (tonumber((flag67 or ""):match("\"retry_after\"%s*:%s*([%d%.]+)")) or 1) + 0.25)
		end

		if n4 >= 500 then
			return false, tostring(n4), 5
		end
		return false, tostring(n4), nil
	end

	list2.whPump = function()
		if list2.whQBusy then
			return
		end
		list2.whQBusy = true

		task.spawn(function()
			while #list2.whQ > 0 and list2.current() and not list2.whBreak do
				local value85 = list2.whQ[1]
				local value86, str14, value87 = list2.whSend(value85.body)

				if value86 then
					table.remove(list2.whQ, 1)
					list2.whSentN = list2.whSentN + 1
					list2.whLastErr = nil
					value85.ok = true
					value85.code = str14
					value85.done = true
					task.wait(0.35)
				elseif value87 then
					task.wait(value87)
				else
					table.remove(list2.whQ, 1)
					list2.whDropped = list2.whDropped + 1
					list2.whLastErr = str14
					value85.ok = false
					value85.code = str14
					value85.done = true

					if str14 == "401" or str14 == "403" or str14 == "404" then
						list2.whBreak = true

						obj2:Notify({
							Title = "Webhook Rejected",
							Content = "Discord answered " .. str14 .. ". The webhook was deleted or revoked, so sending has stopped. Paste a new one.",
							Duration = 10,
							Icon = "x",
						})
					end
				end
			end

			if list2.whBreak then
				for _, item15 in ipairs(list2.whQ) do
					item15.done = true
					item15.ok = false
					item15.code = "stopped"
				end

				list2.whDropped = list2.whDropped + #list2.whQ
				list2.whQ = {}
			end

			list2.whQBusy = false
		end)
	end

	list2.whPost = function(obj)
		if not list2.whReady() then
			return false, "no webhook set"
		end
		local localPlayer2 = game:GetService("Players").LocalPlayer

		local tbl26 = {
			title = obj.title,
			description = obj.body,
			color = list2.CLR_LINE,
			timestamp = os.date("!%Y-%m-%dT%H:%M:%SZ"),
			author = {
				name = localPlayer2.Name .. "  (" .. localPlayer2.DisplayName .. ")",
				url = "https://www.roblox.com/users/" .. tostring(localPlayer2.UserId) .. "/profile",
				icon_url = list2.avatarUrl(),
			},
			footer = { text = tostring(game.JobId), icon_url = list2.markUrl() },
		}

		if obj.thumb then
			tbl26.thumbnail = { url = obj.thumb }
		end

		if list2.BANNER ~= "" then
			tbl26.image = { url = list2.BANNER }
		end

		if obj.fields and #obj.fields > 0 then
			tbl26.fields = obj.fields
		end

		local tbl27 = {
			username = "F$VL",
			avatar_url = list2.markUrl(),
			allowed_mentions = { parse = {} },
			embeds = { tbl26 },
		}

		if obj.ping then
			tbl27.content = "@everyone"
			tbl27.allowed_mentions = { parse = { "everyone" } }
		end

		local ok, result = pcall(function()
			return game:GetService("HttpService"):JSONEncode(tbl27)
		end)

		if not ok then
			return false, "could not encode the payload"
		end
		local tbl28 = { body = result, done = false }

		if #list2.whQ >= 40 then
			local value88 = table.remove(list2.whQ, 1)
			value88.done = true
			value88.ok = false
			value88.code = "dropped"
			list2.whDropped = list2.whDropped + 1
		end

		list2.whQ[#list2.whQ + 1] = tbl28
		list2.whPump()
		if not obj.wait then
			return true, "queued"
		end
		local now = os.clock()

		while not tbl28.done and os.clock() - now < 25 do
			task.wait(0.1)
		end

		if not tbl28.done then
			return false, "no answer from Discord"
		end
		return tbl28.ok, tbl28.code
	end

	task.spawn(function()
		list2.avatarUrl()
		task.wait(4)
		list2.markUrl()
		list2.itemThumb(list2.COIN_ICON)
	end)

	list2.thumbCache = {}

	list2.itemThumb = function(flag68)
		if not flag68 then
			return nil
		end
		local str15 = tostring(flag68)
		if list2.thumbCache[str15] ~= nil then
			return list2.thumbCache[str15] or nil
		end
		local url7 = "https://thumbnails.roblox.com/v1/assets?assetIds=" .. str15 .. "&size=150x150&format=Png&isCircular=false"

		local ok, result = pcall(function()
			return game:HttpGet(url7)
		end)

		ok = ok and type(result) == "string" and result:match("\"imageUrl\"%s*:%s*\"([^\"]+)\"") or nil

		if ok and ok:find("PrivateImage", 1, true) then
			ok = nil
		end

		list2.thumbCache[str15] = ok or false
		return ok
	end

	list2.SHELL_IMG = "https://static.wikia.nocookie.net/murder-mystery-2/images/e/e5/Shells.png/revision/latest?cb=20260724145424"
	list2.ZWSP = utf8.char(8203)

	list2.pad3 = function(list10)
		local list11 = {}
		local list12 = {}

		for _, item16 in ipairs(list10) do
			if item16.inline then
				list11[#list11 + 1] = item16
			else
				list12[#list12 + 1] = item16
			end
		end

		while #list11 % 3 ~= 0 do
			list11[#list11 + 1] = { name = list2.ZWSP, value = list2.ZWSP, inline = true }
		end

		for _, item17 in ipairs(list12) do
			list11[#list11 + 1] = item17
		end

		return list11
	end

	list2.SHELL_KEY = "SummerKey2026"
	list2.SBOX_COST = 120
	list2.shellsLeft = nil
	list2.coinsTotal = nil

	list2.readOwned = function()
		local ok, result = pcall(require, game:GetService("ReplicatedStorage").Modules.ProfileData)
		if not ok or type(result) ~= "table" then
			return nil
		end
		local owned = result.Materials and result.Materials.Owned
		return type(owned) == "table" and owned or nil
	end

	list2.readXP = function()
		local ok, result = pcall(require, game:GetService("ReplicatedStorage").Modules.ProfileData)
		if not ok or type(result) ~= "table" then
			return nil
		end
		return tonumber(result.NewXP)
	end

	list2.readLevel = function()
		local flag69 = list2.readXP()
		if not flag69 then
			return nil
		end
		local ok, result = pcall(require, game:GetService("ReplicatedStorage").Modules.LevelModule)
		if not ok or type(result) ~= "table" or type(result.GetLevel) ~= "function" then
			return nil
		end
		local ok2, result2 = pcall(result.GetLevel, flag69)
		return ok2 and tonumber(result2) or nil
	end

	list2.readShells = function()
		local tbl29 = list2.readOwned()
		if not tbl29 then
			return nil
		end
		local shellsLeft = tonumber(tbl29[list2.SHELL_KEY]) or 0
		list2.shellsLeft = shellsLeft
		return shellsLeft
	end

	list2.readCoins = function()
		local flag70 = list2.readOwned()
		if not flag70 then
			return nil
		end
		local coinsTotal = tonumber(flag70.Coins) or 0
		list2.coinsTotal = coinsTotal
		return coinsTotal
	end

	list2.whBox = function(param38)
		if not list2.whReady() then
			return false, "no webhook set"
		end
		local ok, result = pcall(require, game:GetService("ReplicatedStorage").Database.Sync.Item)
		local flag71 = ok and type(result) == "table" and result[param38] or nil
		flag71 = type(flag71) == "table" and flag71 or {}
		list2.readShells()
		local str16 = tostring(flag71.ItemName or param38)
		local str17 = tostring(flag71.Rarity or "Unknown")
		local whPost = list2.whPost

		local tbl30 = {
			ping = str17:lower() == "godly",
			title = "Opened a Summer Box!",
			body = "Skin: **" .. str16 .. "**\n\n**Info:**",
			thumb = list2.itemThumb(flag71.ItemID),
		}

		local Rarity = list2.fld("Rarity", str17)
		local Cost = list2.fld("Cost", list2.comma(list2.SBOX_COST))
		local fld = list2.fld
		local comma = list2.comma
		local shellsLeft = list2.shellsLeft
		local fields = { Rarity, Cost }

		do
			local values = table.pack(fld("Shells left", comma(shellsLeft)))
			table.move(values, 1, values.n, 3, fields)
		end

		tbl30.fields = fields
		return whPost(tbl30)
	end

	list2.whReward = function(flag72, flag73, param39)
		if not list2.whReady() then
			return false, "no webhook set"
		end
		local str18 = tostring(flag72 or ""):gsub("^%s*[xX]%s*", "")
		local func64 = tonumber
		local str19 = str18:gsub("[^%d%.]", "")
		local str20 = func64(str19)

		if tostring(flag73 or "reward"):lower():find("shell", 1, true) then
			if not list2.readShells() and str20 and type(list2.shellsLeft) == "number" then
				list2.shellsLeft = list2.shellsLeft + str20
			end

			str20 = str20 and list2.comma(str20) or str18 ~= "" and str18 or "?"
			local list13 = {}
			local Received = list2.fld("Received", "+" .. str20 .. " Shells")
			local fld = list2.fld
			local str21 = list2.comma(list2.shellsLeft) .. " Shells"
			list13[1] = Received

			do
				local values = table.pack(fld("Balance", str21))
				table.move(values, 1, values.n, 2, list13)
			end

			if type(list2.shellsLeft) == "number" then
				local n4 = list2.SBOX_COST - list2.shellsLeft
				list13[#list13 + 1] = list2.fld("Next box", n4 > 0 and list2.comma(n4) .. " Shells left" or list2.comma(math.floor(list2.shellsLeft / list2.SBOX_COST)) .. " boxes ready")
			end

			return list2.whPost({
				title = utf8.char(128026) .. "  +" .. str20 .. " shells",
				thumb = list2.SHELL_IMG,
				fields = list2.pad3(list13),
			})
		end

		str20 = str20 and list2.comma(str20) or str18 ~= "" and str18 or nil
		local str22

		return list2.whPost({
			title = "Reward claimed",
			body = str20 and "Received **" .. str20 .. "** " .. str22 .. "." or "Received **" .. str22 .. "**.",
			thumb = list2.itemThumb(param39),
		})
	end

	list2.roundCoins = 0
	list2.roundBags = {}
	list2.roundRole = nil
	list2.roundEndRole = nil
	list2.roundStart = nil
	list2.roundLength = nil
	list2.roundMode = nil
	list2.roundWin = nil
	list2.roundDead = nil
	list2.roundId = nil
	list2.roundLive = false
	list2.roundLastT = nil

	list2.roundRoster = function()
		local ok, result = pcall(require, game:GetService("ReplicatedStorage").Modules.CurrentRoundClient)
		if not ok or type(result) ~= "table" then
			return nil
		end
		return type(result.PlayerData) == "table" and result.PlayerData or nil
	end

	list2.myRoundRec = function()
		local tbl31 = list2.roundRoster()
		return tbl31 and tbl31[localPlayer.Name] or nil
	end

	list2.ROLE_OK = {
		Innocent = true,
		Sheriff = true,
		Murderer = true,
		Hero = true,
		Survivor = true,
		Zombie = true,
		Freezer = true,
		Frozen = true,
		Assassin = true,
		Target = true,
	}

	list2.roleText = function()
		local roundRole2 = list2.roundRole and tostring(list2.roundRole) or nil
		local roundEndRole2 = list2.roundEndRole and tostring(list2.roundEndRole) or nil

		if roundRole2 and not list2.ROLE_OK[roundRole2] then
			roundRole2 ..= " (?)"
		end

		if roundEndRole2 and not list2.ROLE_OK[roundEndRole2] then
			roundEndRole2 ..= " (?)"
		end

		if roundRole2 and roundEndRole2 and roundRole2 ~= roundEndRole2 then
			return roundRole2 .. " -> " .. roundEndRole2
		end
		return roundEndRole2 or roundRole2 or "unknown"
	end

	list2.WIN_TEXT = {
		MurdererWin = "Murderer won",
		MurdererDied = "Innocents won",
		SheriffWin = "Sheriff won",
		HeroWin = "Hero won",
		InnocentWin = "Innocents won",
		MurdererLeft = "Murderer left",
		Time = "Time ran out",
		TimeRanOut = "Time ran out",
		Survivors = "Survivors won",
		Zombies = "Zombies won",
		Freezers = "Freezers won",
		Frozen = "Everyone frozen",
	}

	list2.roundSnapshot = function()
		local value89 = list2.myRoundRec()
		if type(value89) ~= "table" then
			return
		end

		if type(value89.Coins) == "number" then
			list2.roundCoinsAuth = value89.Coins
		end

		if value89.Role ~= nil then
			list2.roundEndRole = tostring(value89.Role)

			if list2.roundRole == nil then
				list2.roundRole = list2.roundEndRole
			end
		end

		if value89.Dead ~= nil then
			list2.roundDead = value89.Dead == true
		end
	end

	list2.whRound = function()
		if not list2.whReady() then
			return false, "not sending"
		end
		list2.readCoins()
		list2.readShells()
		local roundCoinsAuth = list2.roundCoinsAuth or list2.roundCoins or 0
		local n4

		if list2.roundLength and list2.roundLastT then
			n4 = math.max(0, math.floor(list2.roundLength - list2.roundLastT))
		else
			n4 = nil

			if list2.roundStart then
				local roundStart = list2.roundStart
				n4 = math.max(0, math.floor(os.clock() - roundStart))
			end
		end

		n4 = n4 and string.format("%dm %02ds", math.floor(n4 / 60), n4 % 60) or "?"
		local num8 = list2.readXP()
		local roundXP0 = num8 and list2.roundXP0
		local n5 = nil

		if roundXP0 then
			n5 = math.max(0, math.floor(num8 - list2.roundXP0))
		end

		local whPost = list2.whPost

		local tbl32 = {
			title = "Round Over.",
			thumb = list2.itemThumb(list2.COIN_ICON),
			body = "Collected: **+" .. list2.comma(roundCoinsAuth) .. "** Coins\n\n**Other Info:**",
		}

		local fields = {}
		local value90 = list2.fld("Coins Balance", list2.comma(list2.coinsTotal))
		local value91 = list2.fld("Played For", n4)
		local value92 = list2.fld("XP Gained", n5 and "+" .. list2.comma(n5) or "?")
		local value93 = list2.fld("Shell Balance", list2.comma(list2.shellsLeft))
		local Role = list2.fld("Role", list2.roleText())
		local fld = list2.fld
		local packed2 = table.pack(list2.comma(list2.readLevel()))
		packed2.n = 2 + packed2.n - 1
		table.move(packed2, 1, packed2.n, 2, packed2)
		packed2[1] = "Current Level"
		local packed3 = table.pack(fld(table.unpack(packed2, 1, packed2.n)))
		fields[1] = value90
		fields[2] = value91
		fields[3] = value92
		fields[4] = value93
		fields[5] = Role

		do
			local values = table.pack(table.unpack(packed3, 1, packed3.n))
			table.move(values, 1, values.n, 6, fields)
		end

		tbl32.fields = fields
		return whPost(tbl32)
	end

	list2.roundBegin = function(roundLength)
		list2.roundCoins = 0
		list2.roundCoinsAuth = nil
		list2.roundBags = {}
		list2.roundRole = nil
		list2.roundEndRole = nil
		list2.roundWin = nil
		list2.roundDead = nil
		list2.roundLength = roundLength
		list2.roundLastT = roundLength
		list2.roundXP0 = list2.readXP()
		list2.roundStart = os.clock()
		list2.roundLive = true
		list2.roundMode = workspace:GetAttribute("GameMode")

		if getrenv then
			local ok, result = pcall(function()
				return getrenv()._G
			end)

			if ok and type(result) == "table" then
				list2.roundId = result.LastRound
			end
		end

		list2.roundSnapshot()
	end

	list2.roundFinish = function()
		if not list2.roundLive then
			return
		end
		list2.roundLive = false
		list2.roundSnapshot()

		task.spawn(function()
			local now = os.clock()

			while os.clock() - now < 30 do
				local flag74 = (list2.readXP() or 0) ~= (list2.roundXP0 or 0)
				if not (list2.roundWin and flag74) then
					task.wait(0.25)
					continue
				end
				break
			end

			pcall(list2.whRound)
		end)
	end

	task.spawn(function()
		local ReplicatedStorage_ = game:GetService("ReplicatedStorage")
		local roundTimerPart = workspace:WaitForChild("RoundTimerPart", 30)

		if roundTimerPart then
			local num9 = tonumber(roundTimerPart:GetAttribute("Time"))
			local num10 = tonumber(roundTimerPart:GetAttribute("RoundLength"))

			if num9 and num9 > 0 then
				list2.roundBegin(num10)

				if num10 then
					list2.roundStart = os.clock() - math.max(0, num10 - num9)
				end
			end

			list2.conns[#list2.conns + 1] = roundTimerPart:GetAttributeChangedSignal("Time"):Connect(function()
				if not list2.current() then
					return
				end
				local roundLastT = tonumber(roundTimerPart:GetAttribute("Time"))
				if roundLastT == nil then
					return
				end

				if roundLastT > 0 then
					list2.roundLastT = roundLastT
				end

				if roundLastT > 0 and not list2.roundLive then
					list2.roundBegin(tonumber(roundTimerPart:GetAttribute("RoundLength")))
				elseif roundLastT <= 0 and list2.roundLive then
					list2.roundFinish()
				end
			end)
		end

		local remotes = ReplicatedStorage_:FindFirstChild("Remotes")
		remotes = remotes and remotes:FindFirstChild("Gameplay")
		if not remotes then
			return
		end
		local victoryScreen = remotes:FindFirstChild("VictoryScreen")

		if victoryScreen then
			list2.conns[#list2.conns + 1] = victoryScreen.OnClientEvent:Connect(function(param40, roundEndRole, roundWin)
				if not list2.current() then
					return
				end

				if type(roundWin) == "string" then
					list2.roundWin = roundWin
				end

				if type(roundEndRole) == "string" and roundEndRole ~= "" then
					list2.roundEndRole = roundEndRole
				end
			end)
		end

		local coinCollected = remotes:FindFirstChild("CoinCollected")

		if coinCollected then
			list2.conns[#list2.conns + 1] = coinCollected.OnClientEvent:Connect(function(flag75, param41)
				if not list2.current() then
					return
				end
				local num11 = tonumber(param41)

				if num11 then
					list2.roundBags[tostring(flag75 or "Coin")] = num11
					local roundCoins = 0

					for _, roundBag in pairs(list2.roundBags) do
						roundCoins += roundBag
					end

					list2.roundCoins = roundCoins
				end

				list2.roundSnapshot()
			end)
		end

		local playerDataChanged = remotes:FindFirstChild("PlayerDataChanged")

		if playerDataChanged then
			list2.conns[#list2.conns + 1] = playerDataChanged.OnClientEvent:Connect(function()
				if not list2.current() then
					return
				end
				list2.roundSnapshot()
			end)
		end
	end)

	list2.setToggle = function(tbl33, param42, param43)
		list2.sfxQuiet = true
		local flag76 = false

		pcall(function()
			if tbl33 then
				for _, item18 in ipairs({ "SetValue", "Set", "UpdateValue" }) do
					if type(tbl33[item18]) ~= "function" then
						continue
					end

					if pcall(function()
						tbl33[item18](tbl33, param42)
					end) then
						flag76 = true
						return
					end
				end
			end
		end)

		if not flag76 and param43 then
			pcall(param43, param42)
		end

		list2.sfxQuiet = false
		return flag76
	end

	list2.underMapDepth = 15

	list2.underMapCF = function()
		if not obj6 then
			return nil
		end
		local spawns = obj6:FindFirstChild("Spawns")
		local position = nil

		if spawns then
			local value94 = next
			local children, value95 = spawns:GetChildren()
			position = nil

			for _, value96 in value94, children, value95 do
				if value96:IsA("BasePart") then
					position = value96.Position
					break
				else
					position = nil
				end
			end
		end

		if not position then
			local ok, result = pcall(function()
				return obj6:GetPivot()
			end)

			if ok and result then
				position = result.Position
			end
		end

		if not position then
			return nil
		end
		return CFrame.new(position.X, position.Y - list2.underMapDepth, position.Z)
	end

	list2.hideUnderMap = function(obj)
		local num12 = list2.underMapCF()
		if not num12 then
			return false
		end
		func59(true)
		flag50 = true

		if (obj.Position - num12.Position).Magnitude > 5 then
			obj.Velocity = Vector3.zero
			obj.CFrame = num12
		end

		return true
	end

	list2.finishFling = function()
		if not list2.flingWhenDone then
			return
		end

		if list2.flingDoneFired then
			return
		end

		if flag33 then
			return
		end
		local roundCoinsAuth = list2.roundCoinsAuth or list2.roundCoins or 0
		if roundCoinsAuth <= 0 and func57() <= 0 then
			return
		end
		list2.finishEarned = roundCoinsAuth > 0 and roundCoinsAuth or func57()
		local result6 = func15()
		if not result6 or result6 == localPlayer or not result6.Character then
			return
		end
		list2.flingDoneFired = true

		task.spawn(function()
			if flag46 then
				local str23 = " coins. Resetting, then flinging " .. result6.Name .. "..."

				obj2:Notify({
					Title = "Farm Done!",
					Content = "Collected " .. list2.comma(list2.finishEarned) .. str23,
					Duration = 3,
					Icon = "flame",
				})

				local humanoid = localPlayer.Character and localPlayer.Character:FindFirstChildOfClass("Humanoid")

				if humanoid and humanoid.Health > 0 then
					humanoid.Health = 0
				end

				local now = tick()
				local flag77

				while true do
					task.wait(0.2)
					local character = localPlayer.Character
					local humanoid2 = character and character:FindFirstChildOfClass("Humanoid")
					flag77 = character ~= nil and humanoid2 ~= nil and humanoid2.Health > 0 and character:FindFirstChild("HumanoidRootPart") ~= nil
					if not (flag77 or tick() - now > 12) then
						continue
					end
					break
				end

				if not flag77 then
					return
				end
				task.wait(0.6)
				result6 = func15()
				if not result6 or result6 == localPlayer or not result6.Character then
					return
				end
			else
				local str24 = " coins. Flinging " .. result6.Name .. "..."

				obj2:Notify({
					Title = "Farm Done!",
					Content = "Collected " .. list2.comma(list2.finishEarned) .. str24,
					Duration = 2,
					Icon = "flame",
				})
			end

			pcall(func27, result6)
		end)
	end

	list2.diedMidRound = false

	list2.conns[#list2.conns + 1] = localPlayer.CharacterAdded:Connect(function(character)
		local humanoid = character:WaitForChild("Humanoid", 5)

		if humanoid then
			list2.conns[#list2.conns + 1] = humanoid.Died:Connect(function()
				local result7 = func15()
				list2.diedMidRound = result7 ~= nil and result7 ~= localPlayer
			end)
		end

		if not list2.diedMidRound then
			return
		end
		list2.diedMidRound = false
		if not list2.flingWhenDone then
			return
		end

		if list2.flingDoneFired then
			return
		end

		task.spawn(function()
			task.wait(1.2)
			if not list2.flingWhenDone or list2.flingDoneFired or flag33 then
				return
			end
			local result8 = func15()
			if not result8 or result8 == localPlayer or not result8.Character then
				return
			end
			list2.flingDoneFired = true

			obj2:Notify({
				Title = "Out Of The Round",
				Content = "Flinging " .. result8.Name .. "...",
				Duration = 3,
				Icon = "flame",
			})

			pcall(func27, result8)
		end)
	end)

	list2.flingAll = function()
		if list2.flingAllRunning then
			list2.flingAllRunning = false
			obj2:Notify({ Title = "Fling All Stopped!", Content = "Cancelled.", Duration = 2, Icon = "power-off" })
			return
		end

		local list14 = {}

		for _, player in ipairs(Players:GetPlayers()) do
			if player ~= localPlayer and player.Character then
				list14[#list14 + 1] = player
			end
		end

		if #list14 == 0 then
			obj2:Notify({ Title = "Fling All", Content = "Nobody to fling!", Duration = 2, Icon = "x" })
			return
		end
		list2.flingAllRunning = true

		task.spawn(function()
			obj2:Notify({ Title = "Fling All", Content = "Flinging " .. #list14 .. " players...", Duration = 2, Icon = "flame" })
			local n4 = 0

			for _, item19 in ipairs(list14) do
				if list2.flingAllRunning then
					if item19.Parent and item19.Character then
						pcall(func27, item19)
						local now = tick()

						while flag33 and list2.flingAllRunning and tick() - now < 12 do
							task.wait(0.1)
						end

						n4 += 1
					end

					continue
				end

				break
			end

			if list2.flingAllRunning then
				obj2:Notify({
					Title = "Fling All Done!",
					Content = "Flung " .. n4 .. " players.",
					Duration = 2,
					Icon = "check",
				})
			end

			list2.flingAllRunning = false
		end)
	end

	func50 = function()
		if flag51 then
			return
		end
		flag51 = true

		task.spawn(function()
			while flag46 do
				task.wait(1)

				pcall(function()
					if func57() >= 999 then
						local humanoid = localPlayer.Character and localPlayer.Character:FindFirstChildOfClass("Humanoid")

						if humanoid then
							humanoid.Health = 0
						end
					end
				end)
			end

			flag51 = false
		end)
	end

	func51 = function()
		flag46 = false
	end

	func52 = function()
		if connection2 then
			return
		end

		connection2 = localPlayer.Idled:Connect(function()
			if not flag47 then
				return
			end

			pcall(function()
				VirtualUser:CaptureController()
				VirtualUser:ClickButton2(Vector2.new())
			end)
		end)
	end

	func53 = function()
		if connection2 then
			connection2:Disconnect()
			connection2 = nil
		end
	end
end

local flag78
flag78 = false
list2.wallbang = false
list2.velTrack = {}
list2.aimLead = 0.16

list2.startVelTracker = function()
	if list2.velConn then
		return
	end

	list2.velConn = RunService.Heartbeat:Connect(function()
		local now = os.clock()

		for _, player in ipairs(Players:GetPlayers()) do
			local humanoidRootPart = player.Character and player.Character:FindFirstChild("HumanoidRootPart")

			if not humanoidRootPart then
				list2.velTrack[player] = nil
			else
				local num13 = list2.velTrack[player]

				if not num13 then
					list2.velTrack[player] = { p = humanoidRootPart.Position, t = now, v = Vector3.zero }
				elseif now - num13.t >= 0.03 then
					num13.v = (humanoidRootPart.Position - num13.p) / (now - num13.t)
					num13.p = humanoidRootPart.Position
					num13.t = now
				end
			end
		end
	end)
end

list2.stopVelTracker = function()
	if list2.velConn then
		pcall(function()
			list2.velConn:Disconnect()
		end)
	end

	list2.velConn = nil
	list2.velTrack = {}
end

list2.leadTime = function()
	local aimLead = tonumber(_G.__FVL_AIMLEAD) or list2.aimLead

	local ok, result = pcall(function()
		return game:GetService("Stats").Network.ServerStatsItem["Data Ping"]:GetValue() / 1000
	end)

	local flag79 = ok and type(result) == "number" and result > 0 and result < 1
	local n3 = 0.04

	if flag79 then
		n3 = result
	end

	return math.clamp(n3 + aimLead, 0, 0.3)
end

list2.aimAt = function(obj, part3)
	local humanoid = obj.Character and obj.Character:FindFirstChildOfClass("Humanoid")
	local n3

	if humanoid and humanoid.MoveDirection.Magnitude > 0.1 then
		n3 = humanoid.MoveDirection.Unit * humanoid.WalkSpeed
	else
		n3 = part3.AssemblyLinearVelocity or Vector3.zero

		if n3.Magnitude < 0.5 then
			local flag80 = list2.velTrack[obj]

			if flag80 and flag80.v.Magnitude >= 0.5 then
				n3 = flag80.v
			end
		end
	end

	if n3.Magnitude < 0.5 then
		return part3.Position
	end
	local num14 = list2.leadTime()
	local n4 = part3.Position + Vector3.new(n3.X, 0, n3.Z) * num14
	local n5 = n4 - part3.Position

	if n5.Magnitude > 8 then
		n4 = part3.Position + n5.Unit * 8
	end

	_G.__FVL_AIM = { aim = n4, targetPos = part3.Position, vel = n3, lead = num14, t = os.clock() }
	return n4
end

list2.startVelTracker()
local num15
num15 = nil
COOLDOWN = { Shoot = 3.2, Throw = 2 }
local connection, obj9, connection2, func65, func66, func67, func68, func69, func70, n3
local connection3, tbl34, func71, connection4, func72, tbl35, func73, num16, flag81, flag82
local func74, func75, func76, func77, num17, flag83

do
	local function func78(obj10)
		obj10 = obj10 and obj10:GetAttribute("ThrowSpeed")
		if type(obj10) == "number" and obj10 > 0 then
			return 2 * obj10
		end
		return COOLDOWN.Throw
	end

	local flag84 = false
	local flag85 = false
	connection = nil

	local function func79()
		local ok, result = pcall(function()
			return require(ReplicatedStorage:WaitForChild("ClientServices"):WaitForChild("WeaponService"))
		end)

		if not ok or type(result) ~= "table" or not result.GunFired then
			return nil
		end

		return result.GunFired.OnClientEvent:Connect(function(obj11)
			local character = localPlayer.Character
			if not character or typeof(obj11) ~= "Instance" then
				return
			end

			if not obj11:IsDescendantOf(character) then
				return
			end
			local shoot = COOLDOWN.Shoot
			flag84 = true

			if num15 then
				num15.startCooldown("Shoot", shoot, "SHOOT\nMURDERER")
			end

			task.spawn(function()
				task.wait(shoot)
				flag84 = false
			end)
		end)
	end

	obj9 = func79()

	local function func80()
		local character = localPlayer.Character
		local backpack = localPlayer:FindFirstChild("Backpack")
		return character and character:FindFirstChild("Knife") or backpack and backpack:FindFirstChild("Knife")
	end

	local function func81(flag86)
		flag86 = flag86 and flag86.Animation
		if not flag86 or flag86.Name ~= "ThrowKnife" then
			return
		end

		if flag85 then
			return
		end
		local value97 = func78(func80())
		flag85 = true

		if num15 then
			num15.startCooldown("Throw", value97, "THROW\nKNIFE")
		end

		task.spawn(function()
			task.wait(value97)
			flag85 = false
		end)
	end

	local function func82()
		if connection then
			pcall(function()
				connection:Disconnect()
			end)
		end

		connection = nil
		local character = localPlayer.Character
		character = character and character:FindFirstChildOfClass("Humanoid")
		character = character and character:FindFirstChildOfClass("Animator")
		if not character then
			return
		end
		connection = character.AnimationPlayed:Connect(func81)
	end

	func82()

	connection2 = localPlayer.CharacterAdded:Connect(function(character)
		character:WaitForChild("Humanoid")
		task.wait(0.3)
		func82()
	end)

	func65 = function(instance3, part4)
		if not instance3 or not part4 then
			return false
		end
		local raycastParams = RaycastParams.new()
		raycastParams.FilterType = Enum.RaycastFilterType.Exclude
		raycastParams.FilterDescendantsInstances = { localPlayer.Character }
		raycastParams.RespectCanCollide = true
		local tbl36 = {}

		for _, item20 in ipairs({ "HumanoidRootPart", "Head", "UpperTorso", "Torso", "LeftFoot", "RightFoot" }) do
			local value98 = instance3:FindFirstChild(item20)

			if value98 then
				table.insert(tbl36, value98.Position)
			end
		end

		if #tbl36 == 0 and instance3.PrimaryPart then
			table.insert(tbl36, instance3.PrimaryPart.Position)
		end

		for _, item21 in ipairs(tbl36) do
			local hit = workspace:Raycast(part4.Position, item21 - part4.Position, raycastParams)
			if not hit then
				return true
			end

			if hit.Instance and hit.Instance:IsDescendantOf(instance3) then
				return true
			end

			if hit.Instance and hit.Instance.Transparency > 0.5 then
				return true
			end

			if hit.Instance and hit.Instance.CanCollide == false then
				return true
			end
		end

		return false
	end

	local function func83(player5, num18, flag87)
		local character = player5.Character
		if not character then
			return nil
		end
		local upperTorso = character:FindFirstChild("UpperTorso") or character:FindFirstChild("HumanoidRootPart")
		if not upperTorso then
			return nil
		end
		local position = upperTorso.Position
		local assemblyLinearVelocity = upperTorso.AssemblyLinearVelocity or Vector3.new()
		local character2 = localPlayer.Character
		local upperTorso2

		if character2 then
			upperTorso2 = localPlayer.Character:FindFirstChild("UpperTorso") or localPlayer.Character:FindFirstChild("HumanoidRootPart")
		else
			upperTorso2 = character2
		end

		if not upperTorso2 then
			return position
		end
		local magnitude = (position - upperTorso2.Position).Magnitude
		if magnitude < 1 then
			return position
		end
		return position + assemblyLinearVelocity * math.min(magnitude / num18 * (flag87 or 1), 0.5)
	end

	func66 = function()
		local character = localPlayer.Character
		if not character then
			return nil
		end
		local humanoidRootPart = character:FindFirstChild("HumanoidRootPart")
		if not humanoidRootPart then
			return nil
		end
		local huge = math.huge
		local value99 = nil

		for _, player in ipairs(Players:GetPlayers()) do
			if player ~= localPlayer and player.Character then
				local humanoidRootPart2 = player.Character:FindFirstChild("HumanoidRootPart")

				if humanoidRootPart2 then
					local magnitude = (humanoidRootPart.Position - humanoidRootPart2.Position).Magnitude

					if magnitude < huge then
						huge = magnitude
						value99 = player
					end
				end
			end
		end

		return value99
	end

	func67 = function()
		if flag84 then
			return
		end
		flag84 = true

		local function func84(delay2)
			task.spawn(function()
				task.wait(delay2)
				flag84 = false
			end)
		end

		if func16() ~= localPlayer then
			func84(0.5)
			obj2:Notify({ Title = "Not Sheriff!", Content = "You don't have the gun.", Duration = 2, Icon = "x" })
			return
		end

		local result9 = func15()

		if not result9 or not result9.Character then
			obj2:Notify({ Title = "Error!", Content = "No murderer this round!", Duration = 2, Icon = "x" })
			func84(0.5)
			return
		end

		local humanoidRootPart = localPlayer.Character and localPlayer.Character:FindFirstChild("HumanoidRootPart")
		if not humanoidRootPart then
			func84(0.5)
			return
		end

		if flag78 and not list2.wallbang then
			if not func65(result9.Character, localPlayer.Character:FindFirstChild("RightHand") or humanoidRootPart) then
				obj2:Notify({
					Title = "Wall Detected!",
					Content = "Murderer is behind a wall. Turn off Wall Check to shoot through it.",
					Duration = 3,
					Icon = "shield",
				})

				func84(0.5)
				return
			end
		end

		local gun = localPlayer.Character and localPlayer.Character:FindFirstChild("Gun")

		if not gun then
			local backpack = localPlayer:FindFirstChild("Backpack")
			backpack = backpack and backpack:FindFirstChild("Gun")

			if backpack and localPlayer.Character then
				localPlayer.Character.Humanoid:EquipTool(backpack)
				task.wait(0.1)
				gun = localPlayer.Character:FindFirstChild("Gun")
			end

			if not gun then
				func84(0.5)
				return
			end
		end

		local shoot = gun:FindFirstChild("Shoot")
		if not shoot or not shoot:IsA("RemoteEvent") then
			func84(0.5)
			return
		end
		local gunRaycastAttachment = humanoidRootPart:FindFirstChild("GunRaycastAttachment")
		gunRaycastAttachment = gunRaycastAttachment and gunRaycastAttachment.WorldCFrame or CFrame.new(humanoidRootPart.Position)
		local humanoidRootPart2 = result9.Character:FindFirstChild("HumanoidRootPart")
		if not humanoidRootPart2 then
			func84(0.5)
			return
		end

		if (humanoidRootPart.Position - humanoidRootPart2.Position).Magnitude > 300 then
			obj2:Notify({ Title = "Too Far!", Content = "The gun only reaches 300 studs.", Duration = 2, Icon = "x" })
			func84(0.5)
			return
		end

		local wallbangAim = list2.aimAt(result9, humanoidRootPart2)

		if list2.wallbang then
			shoot:FireServer(CFrame.new(wallbangAim + Vector3.new(0, 1.5, 0)), CFrame.new(wallbangAim))
		else
			shoot:FireServer(gunRaycastAttachment, CFrame.new(wallbangAim))
		end

		func84(0.35)
	end

	func68 = function()
		if flag85 then
			return
		end
		flag85 = true

		local function func85(delay3)
			task.spawn(function()
				task.wait(delay3)
				flag85 = false
			end)
		end

		if func15() ~= localPlayer then
			obj2:Notify({ Title = "Not Murderer!", Content = "You don't have the knife.", Duration = 2, Icon = "x" })
			func85(0.5)
			return
		end

		local result10 = func66()

		if not result10 or not result10.Character then
			obj2:Notify({ Title = "Error!", Content = "No one nearby to throw at.", Duration = 2, Icon = "x" })
			func85(0.5)
			return
		end

		local rightHand = localPlayer.Character:FindFirstChild("RightHand") or localPlayer.Character:FindFirstChild("HumanoidRootPart")
		if not rightHand then
			func85(0.5)
			return
		end

		if flag78 and not func65(result10.Character, rightHand) then
			obj2:Notify({
				Title = "Wall Detected!",
				Content = result10.Name .. " is behind a wall.",
				Duration = 2,
				Icon = "shield",
			})

			func85(0.5)
			return
		end

		local knife = localPlayer.Character:FindFirstChild("Knife")

		if not knife then
			local backpack = localPlayer:FindFirstChild("Backpack")
			backpack = backpack and backpack:FindFirstChild("Knife")

			if backpack then
				localPlayer.Character.Humanoid:EquipTool(backpack)
				task.wait(0.1)
				knife = localPlayer.Character:FindFirstChild("Knife")
			end
		end

		if not knife then
			func85(0.5)
			return
		end
		local flag88 = func83(result10, 600, 0.95)
		if not flag88 then
			func85(0.5)
			return
		end
		local throw = knife:FindFirstChild("Throw") or knife:FindFirstChild("Events") and knife.Events:FindFirstChild("KnifeThrown")

		if throw and throw:IsA("RemoteEvent") then
			throw:FireServer(CFrame.new(rightHand.Position), CFrame.new(flag88))

			pcall(function()
				local humanoid = localPlayer.Character and localPlayer.Character:FindFirstChildOfClass("Humanoid")
				humanoid = humanoid and humanoid:FindFirstChildOfClass("Animator")
				local throwKnife = knife:FindFirstChild("ThrowKnife", true)

				if humanoid and throwKnife then
					humanoid:LoadAnimation(throwKnife):Play(0.1, 6, 1)
				end
			end)

			local value100 = func78(knife)

			if num15 then
				num15.startCooldown("Throw", value100, "THROW\nKNIFE")
			end

			func85(value100)
		else
			func85(0.5)
		end
	end

	local function func86()
		for _, descendant in ipairs(Workspace:GetDescendants()) do
			if descendant.Name == "GunDrop" and descendant.Parent then
				return descendant
			end
		end

		return nil
	end

	local function func87()
		local result11 = func86()
		if not result11 then
			return false, "nodrop"
		end
		local character = localPlayer.Character
		if not character then
			return false, "nochar"
		end
		local humanoidRootPart = character:FindFirstChild("HumanoidRootPart")
		if not humanoidRootPart then
			return false, "nochar"
		end
		local value101 = nil

		if result11:IsA("BasePart") and result11:FindFirstChild("TouchInterest") then
			value101 = result11
		end

		if not value101 then
			for _, descendant in ipairs(result11:GetDescendants()) do
				if descendant:IsA("BasePart") and descendant:FindFirstChild("TouchInterest") then
					value101 = descendant
					break
				end
			end
		end

		if not value101 then
			if result11:IsA("BasePart") then
				value101 = result11
			else
				for _, descendant in ipairs(result11:GetDescendants()) do
					if descendant:IsA("BasePart") then
						value101 = descendant
						break
					end
				end
			end
		end

		if not value101 then
			return false, "notouch"
		end

		for i = 1, 5 do
			pcall(function()
				firetouchinterest(humanoidRootPart, value101, 0)
				firetouchinterest(humanoidRootPart, value101, 1)
			end)

			task.wait(0.05)
			local backpack = localPlayer:FindFirstChildOfClass("Backpack")
			if character:FindFirstChild("Gun") or backpack and backpack:FindFirstChild("Gun") then
				return true
			end
		end

		local backpack = localPlayer:FindFirstChildOfClass("Backpack")
		if character:FindFirstChild("Gun") or backpack and backpack:FindFirstChild("Gun") then
			return true
		end
		return false, "refused"
	end

	local thread = nil

	func69 = function()
		if thread then
			pcall(task.cancel, thread)
			thread = nil
		end
	end

	func70 = function()
		func69()

		thread = task.spawn(function()
			while true do
				task.wait(0.12)
				local character = localPlayer.Character
				local backpack = localPlayer:FindFirstChildOfClass("Backpack")

				if not (character and character:FindFirstChild("Gun") or backpack and backpack:FindFirstChild("Gun")) then
					pcall(func87)
				end
			end
		end)
	end

	BOMB_COOLDOWN = 22
	n3 = 0
	connection3 = nil
	tbl34 = {}

	func71 = function()
		local now = tick()

		if now - n3 < BOMB_COOLDOWN then
			obj2:Notify({
				Title = "Cooldown",
				Content = string.format("Bomb jump on cooldown for %.1fs", BOMB_COOLDOWN - now - n3),
				Duration = 2,
				Icon = "clock",
			})

			return
		end

		pcall(function()
			local character = localPlayer.Character
			if not character then
				return
			end
			local humanoid = character:FindFirstChildOfClass("Humanoid")
			local humanoidRootPart = character:FindFirstChild("HumanoidRootPart")
			if not humanoid or not humanoidRootPart then
				return
			end
			local tool = character:FindFirstChildOfClass("Tool")
			local fakeBomb = character:FindFirstChild("FakeBomb")

			if not fakeBomb then
				fakeBomb = localPlayer:FindFirstChild("Backpack")
				fakeBomb = fakeBomb and fakeBomb:FindFirstChild("FakeBomb")

				if fakeBomb then
					humanoid:EquipTool(fakeBomb)
					task.wait(0.1)
					fakeBomb = character:FindFirstChild("FakeBomb")
				end
			end

			if not fakeBomb then
				local remotes = ReplicatedStorage:FindFirstChild("Remotes")
				local extras = remotes and remotes:FindFirstChild("Extras")
				extras = extras and extras:FindFirstChild("ReplicateToy")

				if extras then
					extras:InvokeServer("FakeBomb")
					task.wait(0.15)
					fakeBomb = character:FindFirstChild("FakeBomb")

					if not fakeBomb then
						local backpack = localPlayer:FindFirstChild("Backpack")

						if backpack and backpack:FindFirstChild("FakeBomb") then
							humanoid:EquipTool(backpack.FakeBomb)
							task.wait(0.1)
							fakeBomb = character:FindFirstChild("FakeBomb")
						end
					end
				end
			end

			if not fakeBomb then
				obj2:Notify({ Title = "No Bomb", Content = "Couldn't get the FakeBomb toy.", Duration = 2, Icon = "x" })
				return
			end
			humanoid:ChangeState(Enum.HumanoidStateType.Jumping)
			task.wait(0.05)
			local remote = fakeBomb:FindFirstChild("Remote")

			if remote then
				local position = humanoidRootPart.Position
				remote:FireServer(CFrame.new(position.X, position.Y - 3, position.Z), 50)
				n3 = tick()

				if num15 then
					num15.startCooldown("Bomb", BOMB_COOLDOWN, "BOMB\nJUMP")
				end
			end

			task.wait(0.1)
			humanoid:ChangeState(Enum.HumanoidStateType.Jumping)
			task.wait(0.1)
			humanoid:UnequipTools()

			if tool and tool ~= fakeBomb and tool.Name ~= "FakeBomb" then
				task.wait(0.1)

				if tool.Parent then
					pcall(function()
						humanoid:EquipTool(tool)
					end)
				end
			end
		end)
	end

	local function func88()
		n3 = 0

		if num15 then
			num15.clearCooldown("Bomb")
		end
	end

	local function func89(obj12)
		if connection3 then
			pcall(function()
				connection3:Disconnect()
			end)
		end

		connection3 = nil
		obj12 = obj12 and obj12:FindFirstChildOfClass("Humanoid")

		if obj12 then
			connection3 = obj12.Died:Connect(func88)
		end
	end

	func89(localPlayer.Character)

	connection4 = localPlayer.CharacterAdded:Connect(function(character)
		character:WaitForChild("Humanoid")
		func88()
		func89(character)
	end)

	local n4 = 4
	local n5 = 14
	local n6 = 0.2
	local flag89 = false
	local n7 = 0

	local function func90(part5, num19, param44, delay4)
		if UserInputService.MouseBehavior == Enum.MouseBehavior.LockCenter then
			RunService:BindToRenderStep("FVLWallFlick", Enum.RenderPriority.Camera.Value + 1, function()
				local humanoidRootPart = localPlayer.Character and localPlayer.Character:FindFirstChild("HumanoidRootPart")
				if not humanoidRootPart then
					return
				end
				local cframe = CFrame.Angles
				humanoidRootPart.CFrame = CFrame.lookAt(humanoidRootPart.Position, humanoidRootPart.Position + num19) * cframe(0, math.rad(param44), 0)
			end)

			task.wait(delay4)

			pcall(function()
				RunService:UnbindFromRenderStep("FVLWallFlick")
			end)

			pcall(function()
				part5.CFrame = CFrame.lookAt(part5.Position, part5.Position + num19)
			end)
		else
			local cframe = CFrame.lookAt(part5.Position, part5.Position + num19)

			pcall(function()
				part5.CFrame = cframe * CFrame.Angles(0, math.rad(param44), 0)
			end)

			task.wait(delay4)

			pcall(function()
				part5.CFrame = CFrame.lookAt(part5.Position, part5.Position + num19)
			end)
		end
	end

	local function func91(param45, part6)
		local raycastParams = RaycastParams.new()

		if not pcall(function()
			raycastParams.FilterType = Enum.RaycastFilterType.Exclude
		end) then
			raycastParams.FilterType = Enum.RaycastFilterType.Blacklist
		end

		raycastParams.FilterDescendantsInstances = { param45 }

		for _, item22 in ipairs({ part6.CFrame.LookVector, part6.CFrame.RightVector, -part6.CFrame.RightVector }) do
			local hit = Workspace:Raycast(part6.Position, item22 * n4, raycastParams)
			if hit and hit.Instance and hit.Instance.CanCollide then
				return hit
			end
		end

		return nil
	end

	func72 = function()
		local value102 = flag89
		local flag90

		if flag89 then
			flag90 = value102
		else
			flag90 = os.clock() - n7 < n6
		end

		if flag90 then
			return
		end
		local character = localPlayer.Character
		local humanoidRootPart = character and character:FindFirstChild("HumanoidRootPart")
		if not humanoidRootPart then
			return
		end

		if not func91(character, humanoidRootPart) then
			obj2:Notify({ Title = "No wall", Content = "Stand next to a wall first.", Duration = 1.5, Icon = "x" })
			return
		end
		flag89 = true

		task.spawn(function()
			local function func92()
				flag89 = false
				n7 = os.clock()
			end

			local character2 = localPlayer.Character
			local humanoidRootPart2 = character2 and character2:FindFirstChild("HumanoidRootPart")
			local humanoid = character2 and character2:FindFirstChildOfClass("Humanoid")
			if not humanoidRootPart2 or not humanoid then
				func92()
				return
			end
			local num20 = func91(character2, humanoidRootPart2)
			if not num20 then
				func92()
				return
			end
			local n8 = -num20.Normal
			local vector = Vector3.new(n8.X, 0, n8.Z)
			if vector.Magnitude < 0.05 then
				func92()
				return
			end
			local unit = vector.Unit

			local function func93()
				pcall(function()
					humanoidRootPart2.AssemblyLinearVelocity = Vector3.new(unit.X * n5, humanoidRootPart2.AssemblyLinearVelocity.Y, unit.Z * n5)
				end)

				humanoid.Jump = true

				pcall(function()
					humanoid:ChangeState(Enum.HumanoidStateType.Jumping)
				end)
			end

			func93()
			task.wait(0.12)
			func90(humanoidRootPart2, unit, 60, 0.08)
			task.wait(0.03)
			func93()
			func92()
		end)
	end

	num15 = { guis = {}, parts = {}, locked = false }

	ICONS = {
		crosshair = "rbxassetid://134242818164054",
		hand = "rbxassetid://130703864968637",
		sword = "rbxassetid://124448418211665",
		bomb = "http://www.roblox.com/Thumbs/Asset.ashx?format=png&width=250&height=250&assetId=342187115",
		target = "rbxassetid://87563802520297",
		climb = "rbxassetid://100467452364672",
		skull = "rbxassetid://137726256442333",
		plane = "rbxassetid://126985561580989",
		expand = "rbxassetid://137492887754537",
		ghost = "rbxassetid://113822048130017",
		badge = "rbxassetid://116620312917084",
		xray = "rbxassetid://340313896",
	}

	IS_MOBILE = UserInputService.TouchEnabled
	TILE_W = IS_MOBILE and 72 or 84
	TILE_H = TILE_W
	TILE_GAP = 10

	if IS_MOBILE then
		list2.hudScale = 0.7
	end

	COOLDOWN_GREY = Color3.fromRGB(72, 72, 80)

	local function func94(num21, num22)
		return Color3.new(num21.R + (1 - num21.R) * num22, num21.G + (1 - num21.G) * num22, num21.B + (1 - num21.B) * num22)
	end

	num15.bgRest = function()
		return 0.18
	end

	num15.bgHover = function()
		return 0.06
	end

	num15.plateT = function(param46, flag91)
		if param46 then
			flag91 = flag91 and 0.3 or 0.35
			return flag91
		end
		return flag91 and 0.7 or 0.82
	end

	num15.iconC = function(param47, flag92)
		return func94(param47, flag92 and 0.8 or 0.55)
	end

	num15.glyphC = function(obj, param48)
		if obj and obj.raw then
			return Color3.fromRGB(255, 255, 255)
		end
		return num15.iconC(obj and obj.accent, param48)
	end

	num15.labelC = function(param49)
		if param49 then
			return Color3.fromRGB(240, 240, 246)
		end
		return Color3.fromRGB(146, 146, 158)
	end

	num15.labelStrokeT = function()
		return 1
	end

	num15.iconPx = function(param50)
		local num23 = HUDIconSize and HUDIconSize[param50]
		if not num23 then
			return nil
		end
		return math.max(8, math.floor(num23 * TILE_H / 84 + 0.5))
	end

	num15.SLOT_PLATED = IS_MOBILE and 30 or 34
	num15.SLOT_PLAIN = IS_MOBILE and 22 or 25
	num15.SLOT_GAP = 6
	num15.GLYPH_MAX = num15.SLOT_PLAIN + 2 * (num15.SLOT_GAP - 1)

	num15.layout = function(obj, footer)
		local offset = obj.btn.Size.Y.Offset
		obj.footer = footer
		local n8 = 3 * (IS_MOBILE and 8 or 9)
		local slotPlain = num15.plateless() and num15.SLOT_PLAIN or num15.SLOT_PLATED
		local n9 = math.max(slotPlain, math.min(num15.iconPx(obj.name) or 0, num15.GLYPH_MAX))
		local n10 = slotPlain + num15.SLOT_GAP + (n8 + math.ceil((obj.lines or 2) * obj.label.TextSize * obj.label.LineHeight)) / 2
		local n11 = math.floor((offset - n10) / 2)
		local n12 = n11 + n10 - offset - footer - 3

		if n12 > 0 then
			n11 -= math.ceil(n12)
		end

		local n13 = math.max(2, n11)
		obj.plate.Position = UDim2.new(0.5, 0, 0, n13 + math.floor(slotPlain / 2))
		obj.label.AnchorPoint = Vector2.new(0.5, 0)
		obj.label.TextYAlignment = Enum.TextYAlignment.Center
		obj.label.Size = UDim2.new(1, -6, 0, n8)
		obj.label.Position = UDim2.new(0.5, 0, 0, n13 + slotPlain + num15.SLOT_GAP)

		if n9 < obj.icon.Size.Y.Offset then
			obj.icon.Size = UDim2.fromOffset(n9, n9)
		end
	end

	num15.create = function(name2, text, param51, color2, param52, param53)
		if num15.guis[name2] then
			return
		end
		local screenGui = Instance.new("ScreenGui")
		screenGui.Name = "FVL" .. name2 .. "Button"
		screenGui.ResetOnSpawn = false
		screenGui.IgnoreGuiInset = true
		screenGui.Parent = CoreGui
		local flag93 = IS_MOBILE
		local value103 = TILE_W
		local num24 = TILE_H
		local textButton = Instance.new("TextButton")
		textButton.Size = UDim2.new(0, value103, 0, num24)
		local tbl37 = list2.hudPos[name2]
		textButton.Position = tbl37 and UDim2.new(tbl37[1], tbl37[2], tbl37[3], tbl37[4]) or param51
		textButton.AnchorPoint = Vector2.new(0.5, 0.5)
		textButton.Text = ""
		textButton.BackgroundColor3 = Color3.fromRGB(10, 10, 13)
		textButton.BackgroundTransparency = num15.bgRest()
		textButton.BorderSizePixel = 0
		textButton.AutoButtonColor = false
		textButton.ZIndex = 2
		textButton.Name = name2 .. "Btn"
		textButton.Parent = screenGui
		Instance.new("UICorner", textButton).CornerRadius = UDim.new(0, 16)
		local uiScale = Instance.new("UIScale")
		uiScale.Scale = list2.hudScale or 1
		uiScale.Parent = textButton
		local uiStroke = Instance.new("UIStroke")
		uiStroke.Thickness = 1.5
		uiStroke.ApplyStrokeMode = Enum.ApplyStrokeMode.Border
		uiStroke.Color = color2
		uiStroke.Transparency = 0.15
		uiStroke.Parent = textButton
		local frame = Instance.new("Frame")
		frame.Name = "Plate"
		frame.Size = UDim2.new(0, num15.SLOT_PLATED, 0, num15.SLOT_PLATED)
		frame.Position = UDim2.new(0.5, 0, 0, math.floor(num24 * 0.36))
		frame.AnchorPoint = Vector2.new(0.5, 0.5)
		frame.BackgroundColor3 = color2
		frame.BackgroundTransparency = num15.plateT(false, false)
		frame.BorderSizePixel = 0
		frame.ZIndex = 3
		frame.Parent = textButton
		Instance.new("UICorner", frame).CornerRadius = UDim.new(0, 11)
		local uiStroke2 = Instance.new("UIStroke")
		uiStroke2.Thickness = 1
		uiStroke2.Color = color2
		uiStroke2.Transparency = 0.55
		uiStroke2.Parent = frame
		local imageLabel = Instance.new("ImageLabel")
		imageLabel.Name = "Icon"
		imageLabel.Size = UDim2.new(0, 23, 0, 23)
		imageLabel.Position = UDim2.new(0.5, 0, 0.5, 0)
		imageLabel.AnchorPoint = Vector2.new(0.5, 0.5)
		imageLabel.BackgroundTransparency = 1
		imageLabel.Image = ICONS[param52] or ""
		imageLabel.ImageColor3 = num15.iconC(color2, false)
		imageLabel.ZIndex = 5
		imageLabel.Parent = frame
		local textLabel = Instance.new("TextLabel")
		textLabel.Name = "Label"
		textLabel.Size = UDim2.new(1, -10, 0, 24)
		textLabel.Position = UDim2.new(0.5, 0, 1, -7)
		textLabel.AnchorPoint = Vector2.new(0.5, 1)
		textLabel.BackgroundTransparency = 1
		textLabel.Text = text
		textLabel.TextSize = flag93 and 9 or 10
		textLabel.Font = Enum.Font.GothamBold
		textLabel.TextColor3 = num15.labelC(false)
		textLabel.TextStrokeColor3 = Color3.fromRGB(0, 0, 0)
		textLabel.TextStrokeTransparency = num15.labelStrokeT()
		textLabel.TextWrapped = true
		textLabel.LineHeight = 1.1
		textLabel.ZIndex = 6
		textLabel.Parent = textButton
		local n8 = select(2, text:gsub("\n", "")) + 1

		if n8 >= 3 then
			frame.Size = UDim2.new(0, num15.SLOT_PLATED - 6, 0, num15.SLOT_PLATED - 6)
			imageLabel.Size = UDim2.new(0, 20, 0, 20)
			textLabel.TextSize = flag93 and 8 or 9
			textLabel.LineHeight = 1
		end

		local tbl38 = HUDIconArt and HUDIconArt[name2]

		if tbl38 then
			imageLabel.ImageRectOffset = Vector2.new(tbl38[1], tbl38[2])
			imageLabel.ImageRectSize = Vector2.new(tbl38[3], tbl38[3])
			imageLabel.ImageColor3 = Color3.fromRGB(255, 255, 255)
		end

		local value104 = num15.iconPx(name2)

		if value104 then
			imageLabel.Size = UDim2.new(0, value104, 0, value104)
			frame.ClipsDescendants = false
		end

		num15.parts[name2] = {
			btn = textButton,
			stroke = uiStroke,
			plate = frame,
			plateStroke = uiStroke2,
			icon = imageLabel,
			label = textLabel,
			accent = color2,
			active = false,
			scale = uiScale,
			lines = n8,
			raw = (HUDIconArt and HUDIconArt[name2]) ~= nil,
			name = name2,
		}

		num15.layout(num15.parts[name2], 0)
		pcall(num15.applyDesign, num15.parts[name2])

		local function func95(param54, param55, flag94)
			TweenService:Create(param54, TweenInfo.new(flag94 or 0.12, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), param55):Play()
		end

		textButton.MouseEnter:Connect(function()
			local flag95 = num15.parts[name2]
			func95(textButton, { BackgroundTransparency = num15.designHover() })
			if flag95 and flag95.cdUntil then
				return
			end

			if not num15.plateless() then
				func95(frame, { BackgroundTransparency = num15.plateT(flag95 and flag95.active, true) })
			end

			func95(textLabel, { TextColor3 = Color3.fromRGB(187, 247, 208) })
		end)

		textButton.MouseLeave:Connect(function()
			local flag96 = num15.parts[name2]
			func95(textButton, { BackgroundTransparency = num15.designRest() })
			if flag96 and flag96.cdUntil then
				return
			end

			if not num15.plateless() then
				func95(frame, { BackgroundTransparency = num15.plateT(flag96 and flag96.active, false) })
			end

			func95(textLabel, { TextColor3 = num15.labelC(flag96 and flag96.active) })
		end)

		local value105 = nil
		local value106 = nil
		local value107 = nil
		local position = nil
		local position2 = nil
		local n9 = 0

		local function func96()
			if value106 then
				return
			end
			local now = os.clock()
			if now - n9 < 0.2 then
				return
			end
			n9 = now
			list2.playSfx("click")
			local hudScale = list2.hudScale or 1
			func95(uiScale, { Scale = hudScale * 0.93 }, 0.06)

			task.delay(0.08, function()
				if uiScale.Parent then
					func95(uiScale, { Scale = hudScale }, 0.16)
				end
			end)

			task.spawn(param53)
		end

		textButton.MouseButton1Click:Connect(func96)
		textButton.TouchTap:Connect(func96)

		textButton.InputBegan:Connect(function(input)
			if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
				value105 = true
				value106 = false
				value107 = input
				position = textButton.Position
				position2 = input.Position
			end
		end)

		num15.parts[name2].dragConn = UserInputService.InputChanged:Connect(function(input)
			if not value105 or num15.locked or not textButton.Parent then
				return
			end

			if input.UserInputType ~= Enum.UserInputType.MouseMovement and input ~= value107 then
				return
			end
			local n10 = input.Position - position2

			if not value106 then
				if math.abs(n10.X) + math.abs(n10.Y) < 6 then
					return
				end
				value106 = true
			end

			textButton.Position = UDim2.new(position.X.Scale, position.X.Offset + n10.X, position.Y.Scale, position.Y.Offset + n10.Y)
		end)

		num15.parts[name2].endConn = UserInputService.InputEnded:Connect(function(input)
			if not value105 or input ~= value107 then
				return
			end
			value105 = false
			value107 = nil

			if value106 then
				local position3 = textButton.Position
				list2.hudPos[name2] = { position3.X.Scale, position3.X.Offset, position3.Y.Scale, position3.Y.Offset }
			end

			task.delay(0.05, function()
				value106 = false
			end)
		end)

		num15.guis[name2] = screenGui
		list2.hudBtns[name2] = textButton
		return textButton, textLabel
	end

	HUDOrder = { "Shoot", "Grab", "Aimbot", "Bomb", "Throw", "WallHop" }
	HUDOrder2 = { "KillAll", "KillSheriff", "Fly", "Noclip", "Xray" }
	tbl35 = {}

	local function func97(list15, param56)
		for i, item23 in ipairs(list15) do
			tbl35[item23] = UDim2.new(0.5, (i - (#list15 + 1) / 2) * (TILE_W + TILE_GAP), 0.25, param56)
		end
	end

	func97(HUDOrder, 0)
	func97(HUDOrder2, TILE_H + TILE_GAP)

	num15.relayout = function()
		local hudScale = list2.hudScale or 1

		local function func98(list16, num25)
			for i, item24 in ipairs(list16) do
				tbl35[item24] = UDim2.new(0.5, (i - (#list16 + 1) / 2) * (TILE_W + TILE_GAP) * hudScale, 0.25, num25 * hudScale)

				if not list2.hudPos[item24] then
					local flag97 = num15.parts[item24]

					if flag97 and flag97.btn then
						flag97.btn.Position = tbl35[item24]
					end
				end
			end
		end

		func98(HUDOrder, 0)
		func98(HUDOrder2, TILE_H + TILE_GAP)
	end

	HUDIcon = {
		Shoot = "crosshair",
		Grab = "hand",
		Throw = "sword",
		Bomb = "bomb",
		Aimbot = "target",
		WallHop = "climb",
		KillAll = "badge",
		Fly = "plane",
		Noclip = "ghost",
		KillSheriff = "skull",
		Xray = "xray",
	}

	HUDIconSize = { Xray = 34, Bomb = 48 }
	HUDIconArt = { Xray = { 165, 85, 250 }, Bomb = { 8, 24, 170 } }

	HUDAccent = {
		Shoot = Color3.fromHex("#257AF7"),
		Grab = Color3.fromHex("#10C550"),
		Throw = Color3.fromHex("#EF4444"),
		Bomb = Color3.fromHex("#F97316"),
		Aimbot = Color3.fromHex("#2DD4BF"),
		WallHop = Color3.fromHex("#A855F7"),
		KillAll = Color3.fromHex("#DC2626"),
		Fly = Color3.fromHex("#38BDF8"),
		Noclip = Color3.fromHex("#94A3B8"),
		KillSheriff = Color3.fromHex("#DC2626"),
		Xray = Color3.fromHex("#FACC15"),
	}

	func73 = function()
		local value108, flag98 = func87()
		if value108 then
			obj2:Notify({ Title = "Gun Grabbed!", Content = "Got the gun!", Duration = 1.5, Icon = "check" })
			return
		end
		local value109 = next
		local children, value110 = Workspace:GetChildren()
		local flag99 = false

		for _, value111 in value109, children, value110 do
			if value111:FindFirstChild("CoinAreas") or value111:FindFirstChild("CoinContainer") then
				flag99 = true
				break
			end
		end

		if flag98 == "nochar" then
			obj2:Notify({
				Title = "No Character",
				Content = "Nothing to grab with right now.",
				Duration = 2,
				Icon = "x",
			})
		elseif not flag99 then
			obj2:Notify({
				Title = "Not In A Round",
				Content = "The round is over, so the gun can't be picked up. Wait for the next one.",
				Duration = 3,
				Icon = "clock",
			})
		elseif flag98 == "nodrop" then
			obj2:Notify({
				Title = "No Gun Found!",
				Content = "No gun on the ground right now.",
				Duration = 1.5,
				Icon = "x",
			})
		else
			obj2:Notify({
				Title = "Couldn't Grab It",
				Content = "Found the gun but the pickup didn't land -- move closer and try again.",
				Duration = 2.5,
				Icon = "x",
			})
		end
	end

	num15.setActive = function(param57, active)
		local flag100 = num15.parts[param57]
		if not flag100 then
			return
		end
		flag100.active = active
		local designNow = num15.designNow and num15.designNow()
		if designNow and designNow.active then
			pcall(designNow.active, flag100, active)
			return
		end

		local function func99(param58, param59)
			TweenService:Create(param58, TweenInfo.new(0.18, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), param59):Play()
		end

		func99(flag100.stroke, { Transparency = active and 0 or 0.15 })
		func99(flag100.plate, { BackgroundTransparency = num15.plateT(active, false) })
		func99(flag100.plateStroke, { Transparency = active and 0.15 or 0.55 })
		func99(flag100.icon, { ImageColor3 = num15.glyphC(flag100, active) })
		func99(flag100.label, { TextColor3 = num15.labelC(active) })
	end

	num15.DESIGN = "Default Design"
	num15.DESIGN_LIST = { "Round Design", "Default Design" }
	num15.DESIGN_RENAMED = { Ring = "Round Design", ["Base Bar"] = "Default Design", ["New Style"] = "Default Design" }

	num15.snapDesign = function(obj)
		if obj.base then
			return
		end
		local uiCorner = obj.btn:FindFirstChildOfClass("UICorner")

		obj.base = {
			corner = uiCorner and uiCorner.CornerRadius or UDim.new(0, 16),
			body = obj.btn.BackgroundColor3,
			strokeThk = obj.stroke.Thickness,
			plateSize = obj.plate.Size,
			platePos = obj.plate.Position,
			iconSize = obj.icon.Size,
			labelPos = obj.label.Position,
			labelSize = obj.label.Size,
		}
	end

	num15.stopGlide = function(obj)
		if obj.glideT then
			obj.glideT:Cancel()
			obj.glideT = nil
		end

		if obj.arcT then
			obj.arcT:Cancel()
			obj.arcT = nil
		end
	end

	num15.setNow = function(flag101, param60)
		if not flag101 then
			return
		end
		TweenService:Create(flag101, TweenInfo.new(0.03, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), param60):Play()
	end

	num15.designNow = function()
		return num15.DESIGNS and num15.DESIGNS[num15.DESIGN] or nil
	end

	num15.designRest = function()
		local flag102 = num15.designNow()
		if flag102 and flag102.rest then
			return flag102.rest
		end
		return num15.bgRest()
	end

	num15.designHover = function()
		local flag103 = num15.designNow()
		if flag103 and flag103.hover then
			return flag103.hover
		end
		return num15.bgHover()
	end

	num15.plateless = function()
		local flag104 = num15.designNow()
		return flag104 ~= nil and flag104.plateless == true
	end

	num15.BAR_H = 4
	num15.BAR_DROP = 6
	num15.BAR_INSET = 13

	num15.buildBar = function(obj)
		if obj.track then
			return
		end
		local frame = Instance.new("Frame")
		frame.Name = "Track"
		frame.AnchorPoint = Vector2.new(0.5, 1)
		frame.Position = UDim2.new(0.5, 0, 1, -num15.BAR_DROP)
		frame.Size = UDim2.new(1, -num15.BAR_INSET * 2, 0, num15.BAR_H)
		frame.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
		frame.BackgroundTransparency = 0.86
		frame.BorderSizePixel = 0
		frame.ZIndex = 4
		frame.Parent = obj.btn
		Instance.new("UICorner", frame).CornerRadius = UDim.new(1, 0)
		local frame2 = Instance.new("Frame")
		frame2.Name = "Fill"
		frame2.AnchorPoint = Vector2.new(0, 0.5)
		frame2.Position = UDim2.new(0, 0, 0.5, 0)
		frame2.Size = UDim2.fromScale(0, 1)
		frame2.BackgroundColor3 = obj.accent
		frame2.BorderSizePixel = 0
		frame2.ZIndex = 5
		frame2.Parent = frame
		Instance.new("UICorner", frame2).CornerRadius = UDim.new(1, 0)
		obj.track = frame
		obj.fill = frame2
	end

	num15.RING_INSET = 5
	num15.RING_THICK = 3

	num15.buildRing = function(obj)
		if obj.ring then
			return
		end
		local n8 = obj.btn.Size.Y.Offset - num15.RING_INSET * 2 - num15.RING_THICK
		local frame = Instance.new("Frame")
		frame.Name = "Ring"
		frame.BackgroundTransparency = 1
		frame.Size = UDim2.fromScale(1, 1)
		frame.ZIndex = 4
		frame.Parent = obj.btn
		local frame2 = Instance.new("Frame")
		frame2.Name = "Track"
		frame2.AnchorPoint = Vector2.new(0.5, 0.5)
		frame2.Position = UDim2.fromScale(0.5, 0.5)
		frame2.Size = UDim2.fromOffset(n8, n8)
		frame2.BackgroundTransparency = 1
		frame2.ZIndex = 4
		frame2.Parent = frame
		Instance.new("UICorner", frame2).CornerRadius = UDim.new(1, 0)
		local uiStroke = Instance.new("UIStroke")
		uiStroke.Thickness = num15.RING_THICK
		uiStroke.Color = Color3.fromRGB(255, 255, 255)
		uiStroke.Transparency = 0.88
		uiStroke.ApplyStrokeMode = Enum.ApplyStrokeMode.Border
		uiStroke.Parent = frame2
		obj.arcs = {}

		for i, item25 in ipairs({ "Right", "Left" }) do
			local frame3 = Instance.new("Frame")
			frame3.Name = item25 .. "Mask"
			frame3.BackgroundTransparency = 1
			frame3.ClipsDescendants = true
			frame3.Size = UDim2.fromScale(0.5, 1)
			frame3.Position = UDim2.fromScale(item25 == "Right" and 0.5 or 0, 0)
			frame3.ZIndex = 5
			frame3.Parent = frame
			local frame4 = Instance.new("Frame")
			frame4.Name = "Arc"
			frame4.AnchorPoint = Vector2.new(0.5, 0.5)
			frame4.Position = UDim2.new(item25 == "Right" and 0 or 1, 0, 0.5, 0)
			frame4.Size = UDim2.fromOffset(n8, n8)
			frame4.BackgroundTransparency = 1
			frame4.ZIndex = 5
			frame4.Parent = frame3
			Instance.new("UICorner", frame4).CornerRadius = UDim.new(1, 0)
			local uiStroke2 = Instance.new("UIStroke")
			uiStroke2.Thickness = num15.RING_THICK
			uiStroke2.Color = obj.accent
			uiStroke2.ApplyStrokeMode = Enum.ApplyStrokeMode.Border
			uiStroke2.Parent = frame4
			local uiGradient = Instance.new("UIGradient")
			local numberSequence = NumberSequence.new
			local value112 = NumberSequenceKeypoint.new(0, 0)
			local value113 = NumberSequenceKeypoint.new(0.499, 0)
			local value114 = NumberSequenceKeypoint.new(0.5, 1)
			local new = NumberSequenceKeypoint.new
			local tbl39 = { value112, value113, value114 }

			do
				local values = table.pack(new(1, 1))
				table.move(values, 1, values.n, 4, tbl39)
			end

			uiGradient.Transparency = numberSequence(tbl39)
			uiGradient.Parent = uiStroke2
			obj.arcs[i] = uiGradient
		end

		obj.ringTrack = frame2
		obj.ring = frame
	end

	num15.setRing = function(obj, param61)
		if not obj.arcs then
			return
		end
		num15.stopGlide(obj)
		local n8 = math.clamp(param61, 0, 1) * 360
		obj.arcs[1].Rotation = math.min(n8, 180)
		obj.arcs[2].Rotation = math.clamp(n8, 180, 360)
	end

	num15.resetDesign = function(obj)
		num15.snapDesign(obj)
		local base = obj.base
		local uiCorner = obj.btn:FindFirstChildOfClass("UICorner")

		if uiCorner then
			uiCorner.CornerRadius = base.corner
		end

		obj.btn.BackgroundColor3 = base.body
		obj.btn.ClipsDescendants = false
		obj.stroke.Thickness = base.strokeThk
		local plate = obj.plate
		local platePos = base.platePos
		obj.plate.Size = base.plateSize
		plate.Position = platePos
		obj.plate.BackgroundColor3 = obj.accent
		obj.icon.Size = base.iconSize
		obj.label.Visible = true
		local label = obj.label
		local labelPos = base.labelPos
		local labelSize = base.labelSize
		obj.label.Position = labelPos
		label.Size = labelSize
		obj.footer = 0
		num15.setNow(obj.btn, { BackgroundTransparency = num15.bgRest() })
		num15.setNow(obj.stroke, { Color = obj.accent, Transparency = obj.active and 0 or 0.15 })
		num15.setNow(obj.plate, { BackgroundTransparency = num15.plateT(obj.active, false) })
		num15.setNow(obj.plateStroke, { Transparency = obj.active and 0.15 or 0.55 })
		num15.setNow(obj.icon, { ImageColor3 = num15.glyphC(obj, obj.active) })
		num15.setNow(obj.label, { TextColor3 = num15.labelC(obj.active) })

		if obj.track then
			obj.track.Visible = false
		end

		if obj.fill then
			obj.fill.Visible = false
		end

		if obj.ring then
			obj.ring.Visible = false
		end

		if obj.arcs then
			num15.setRing(obj, 0)
		end
	end

	num15.applyDesign = function(obj)
		if not obj or not obj.btn or not obj.btn.Parent then
			return
		end
		num15.resetDesign(obj)
		local flag105 = num15.designNow()

		if flag105 and flag105.apply then
			pcall(flag105.apply, obj)
		end

		num15.setActive(obj.name, obj.active)
	end

	num15.setDesign = function(param62)
		local designRenamed = num15.DESIGN_RENAMED and num15.DESIGN_RENAMED[param62] or param62

		if not num15.DESIGNS[designRenamed] then
			designRenamed = "Default Design"
		end

		num15.DESIGN = designRenamed
		list2.hudDesign = designRenamed

		for _, value115 in next, num15.parts, nil do
			pcall(num15.applyDesign, value115)
		end
	end

	num15.designSet = function(param63, param64)
		local flag106 = num15.designNow()

		if flag106 and flag106.set then
			pcall(flag106.set, param63, param64)
		end
	end

	num15.designSlide = function(param65, param66)
		local flag107 = num15.designNow()

		if flag107 and flag107.slide then
			pcall(flag107.slide, param65, param66)
		end
	end

	num15.DESIGNS = {
		["Round Design"] = {
			plateless = true,
			rest = 0.12,
			hover = 0.04,
			apply = function(param67)
				local uiCorner = param67.btn:FindFirstChildOfClass("UICorner")

				if uiCorner then
					uiCorner.CornerRadius = UDim.new(1, 0)
				end

				param67.stroke.Thickness = 2
				param67.plate.Position = UDim2.new(0.5, 0, 0.5, 0)
				param67.plate.AnchorPoint = Vector2.new(0.5, 0.5)
				local n8 = num15.iconPx(param67.name) or 26
				param67.icon.Size = UDim2.fromOffset(n8, n8)
				num15.setNow(param67.btn, { BackgroundTransparency = 0.12 })
				num15.setNow(param67.stroke, { Color = param67.accent, Transparency = 0 })
				num15.setNow(param67.plate, { BackgroundTransparency = 1 })
				num15.setNow(param67.plateStroke, { Transparency = 1 })
				num15.setNow(param67.icon, { ImageColor3 = num15.glyphC(param67, param67.active) })
				param67.label.Visible = false
				num15.buildRing(param67)
				param67.ring.Visible = true
				num15.setRing(param67, 0)
			end,
			active = function(flag108, flag109)
				num15.setNow(flag108.stroke, { Transparency = 0 })
				num15.setNow(flag108.icon, { ImageColor3 = num15.glyphC(flag108, flag109) })

				if not flag108.cdUntil then
					num15.setRing(flag108, flag109 and 1 or 0)
				end
			end,
			set = function(param68, param69)
				num15.setRing(param68, param69)
			end,
			slide = function(flag110, num26)
				if not flag110.arcs then
					return
				end
				num15.stopGlide(flag110)
				flag110.arcs[1].Rotation = 180
				flag110.arcs[2].Rotation = 360
				flag110.arcT = TweenService:Create(flag110.arcs[2], TweenInfo.new(num26 / 2, Enum.EasingStyle.Linear), { Rotation = 180 })
				flag110.arcT:Play()
				flag110.glideT = TweenService:Create(flag110.arcs[1], TweenInfo.new(num26 / 2, Enum.EasingStyle.Linear, Enum.EasingDirection.Out, 0, false, num26 / 2), { Rotation = 0 })
				flag110.glideT:Play()
			end,
		},
		["Default Design"] = {
			plateless = true,
			rest = 0.1,
			hover = 0.03,
			apply = function(param70)
				local uiCorner = param70.btn:FindFirstChildOfClass("UICorner")

				if uiCorner then
					uiCorner.CornerRadius = UDim.new(0, 20)
				end

				param70.stroke.Thickness = 1
				local slotPlain = num15.iconPx(param70.name) or num15.SLOT_PLAIN
				param70.icon.Size = UDim2.fromOffset(slotPlain, slotPlain)
				num15.setNow(param70.btn, { BackgroundTransparency = 0.1 })

				num15.setNow(param70.stroke, {
					Color = param70.active and param70.accent or Color3.fromRGB(255, 255, 255),
					Transparency = param70.active and 0.35 or 0.88,
				})

				num15.setNow(param70.plate, { BackgroundTransparency = 1 })
				num15.setNow(param70.plateStroke, { Transparency = 1 })
				local setNow = num15.setNow
				local icon = param70.icon
				local tbl40 = {}
				local color2 = param70.raw and Color3.fromRGB(255, 255, 255)

				if not color2 then
					color2 = func94(param70.accent, param70.active and 0.6 or 0.25)
				end

				tbl40.ImageColor3 = color2
				setNow(icon, tbl40)
				num15.buildBar(param70)
				num15.layout(param70, num15.BAR_H + num15.BAR_DROP)
				param70.track.Visible = true
				param70.fill.Visible = true
				param70.fill.BackgroundColor3 = param70.accent
				num15.stopGlide(param70)
				param70.fill.Size = UDim2.fromScale(param70.active and 1 or 0, 1)
			end,
			active = function(param71, flag111)
				num15.setNow(param71.stroke, { Color = flag111 and param71.accent or Color3.fromRGB(255, 255, 255), Transparency = flag111 and 0.35 or 0.88 })
				local setNow = num15.setNow
				local icon = param71.icon
				local tbl41 = {}
				local color2 = param71.raw and Color3.fromRGB(255, 255, 255)

				if not color2 then
					color2 = func94(param71.accent, flag111 and 0.6 or 0.25)
				end

				tbl41.ImageColor3 = color2
				setNow(icon, tbl41)
				num15.setNow(param71.label, { TextColor3 = num15.labelC(flag111) })

				if param71.fill then
					num15.stopGlide(param71)
					param71.fill.Size = UDim2.fromScale(flag111 and 1 or 0, 1)
				end
			end,
			set = function(flag112, param72)
				if not flag112.fill then
					return
				end
				num15.stopGlide(flag112)
				flag112.fill.Size = UDim2.fromScale(param72, 1)
			end,
			slide = function(flag113, param73)
				if not flag113.fill then
					return
				end
				num15.stopGlide(flag113)
				flag113.fill.Size = UDim2.fromScale(1, 1)
				flag113.glideT = TweenService:Create(flag113.fill, TweenInfo.new(param73, Enum.EasingStyle.Linear), { Size = UDim2.fromScale(0, 1) })
				flag113.glideT:Play()
			end,
		},
	}

	num15.startCooldown = function(param74, cdTotal, text)
		local flag114 = num15.parts[param74]
		if not flag114 or not flag114.label then
			return
		end
		flag114.cdUntil = os.clock() + cdTotal
		flag114.cdTotal = cdTotal
		num15.designSlide(flag114, cdTotal)
		if flag114.cdThread then
			return
		end
		local match = text:match("^[^\n]+") or text

		local function func100(flag115, param75, flag116)
			if not flag115 then
				return
			end
			TweenService:Create(flag115, TweenInfo.new(flag116 or 0.25, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), param75):Play()
		end

		func100(flag114.stroke, { Color = COOLDOWN_GREY })
		func100(flag114.plateStroke, { Color = COOLDOWN_GREY })
		func100(flag114.plate, { BackgroundColor3 = COOLDOWN_GREY })
		func100(flag114.icon, { ImageColor3 = Color3.fromRGB(124, 124, 134) })
		func100(flag114.label, { TextColor3 = Color3.fromRGB(112, 112, 124) })

		flag114.cdThread = task.spawn(function()
			while true do
				local flag117 = num15.parts[param74]

				if not (not flag117 or not flag117.cdUntil) then
					local n8 = flag117.cdUntil - os.clock()

					if not (n8 <= 0) then
						flag117.label.Text = match .. "\n" .. string.format("%.1fs", n8)
						task.wait(0.05)
						continue
					end
				end

				break
			end

			local value116 = num15.parts[param74]

			if value116 then
				value116.cdUntil = nil
				value116.cdThread = nil
				num15.designSet(value116, 0)

				if value116.active then
					local designNow = num15.designNow and num15.designNow()

					if designNow and designNow.active then
						pcall(designNow.active, value116, true)
					end
				end

				if value116.label then
					value116.label.Text = text
				end

				func100(value116.stroke, { Color = value116.accent })
				func100(value116.plateStroke, { Color = value116.accent })
				func100(value116.plate, { BackgroundColor3 = value116.accent })
				func100(value116.icon, { ImageColor3 = num15.glyphC(value116, value116.active) })
				func100(value116.label, { TextColor3 = num15.labelC(value116.active) })
				func100(value116.plate, { BackgroundTransparency = num15.plateT(value116.active, false) })
			end
		end)
	end

	num15.clearCooldown = function(param76)
		local value117 = num15.parts[param76]

		if value117 then
			value117.cdUntil = nil
		end
	end

	num15.destroy = function(param77)
		local value118 = num15.parts[param77]

		if value118 then
			if value118.dragConn then
				value118.dragConn:Disconnect()
			end

			if value118.endConn then
				value118.endConn:Disconnect()
			end
		end

		local obj13 = num15.guis[param77]

		if obj13 then
			obj13:Destroy()
			num15.guis[param77] = nil
		end

		num15.parts[param77] = nil
	end

	num15.destroyAll = function()
		for k in pairs(num15.guis) do
			num15.destroy(k)
		end
	end

	num16 = {
		enabled = false,
		conn = nil,
		smooth = 1,
		part = "UpperTorso",
		murdererOnly = true,
		wallCheck = false,
		fov = 500,
		leadFactor = 1,
		predictedPosition = function(part7)
			if not part7 then
				return nil
			end
			local humanoidRootPart = localPlayer.Character and localPlayer.Character:FindFirstChild("HumanoidRootPart")
			if not humanoidRootPart then
				return part7.Position
			end
			return part7.Position + (part7.AssemblyLinearVelocity or Vector3.zero) * math.clamp((humanoidRootPart.Position - part7.Position).Magnitude / 1200 * num16.leadFactor, 0.01, 0.3)
		end,
		getPart = function(instance4)
			if not instance4 then
				return nil
			end
			return instance4:FindFirstChild(num16.part) or instance4:FindFirstChild("UpperTorso") or instance4:FindFirstChild("Torso") or instance4:FindFirstChild("HumanoidRootPart") or instance4:FindFirstChild("Head")
		end,
		alive = function(player6)
			if not player6 or not player6.Character then
				return false
			end
			local humanoid = player6.Character:FindFirstChildOfClass("Humanoid")
			return humanoid ~= nil and humanoid.Health > 0
		end,
		inFov = function(param78)
			if num16.fov >= 500 then
				return true
			end
			local currentCamera = workspace.CurrentCamera
			local value119, flag118 = currentCamera:WorldToViewportPoint(param78)
			if not flag118 then
				return false
			end
			local n8 = currentCamera.ViewportSize / 2
			return (Vector2.new(value119.X, value119.Y) - n8).Magnitude <= num16.fov
		end,
		getTarget = function()
			local result12 = func15()

			if result12 and result12 ~= localPlayer and num16.alive(result12) then
				local flag119 = num16.getPart(result12.Character)

				if flag119 and num16.inFov(flag119.Position) then
					local flag120 = not num16.wallCheck

					if not flag120 then
						flag120 = func65(result12.Character, localPlayer.Character and localPlayer.Character:FindFirstChild("HumanoidRootPart"))
					end

					if flag120 then
						return result12, flag119
					end
				end
			end

			if num16.murdererOnly then
				return nil, nil
			end
			local currentCamera = workspace.CurrentCamera
			local n8 = currentCamera.ViewportSize / 2
			local huge = math.huge
			local value120 = nil
			local value121 = nil

			for _, player in ipairs(Players:GetPlayers()) do
				if player ~= localPlayer and num16.alive(player) then
					local value122 = num16.getPart(player.Character)

					if value122 then
						local value123, value124 = currentCamera:WorldToViewportPoint(value122.Position)

						if value124 then
							local magnitude = (Vector2.new(value123.X, value123.Y) - n8).Magnitude

							if magnitude <= num16.fov and magnitude < huge then
								local flag121 = not num16.wallCheck
								local value125

								if flag121 then
									value125 = flag121
								else
									value125 = func65(player.Character, localPlayer.Character and localPlayer.Character:FindFirstChild("HumanoidRootPart"))
								end

								if value125 then
									huge = magnitude
									value120 = player
									value121 = value122
								end
							end
						end
					end
				end
			end

			return value120, value121
		end,
	}

	list2.hasGun = function()
		local character = localPlayer.Character
		return character ~= nil and character:FindFirstChild("Gun") ~= nil
	end

	num16.noGunWarned = false

	num16.warnNoGun = function()
		if num16.noGunWarned then
			return
		end
		num16.noGunWarned = true

		obj2:Notify({
			Title = "No Gun",
			Content = "Aimbot is on but you are not holding a gun - it will start aiming the moment you pick one up.",
			Duration = 4,
			Icon = "clock",
		})
	end

	num16.start = function()
		if num16.conn then
			return
		end

		num16.conn = RunService.RenderStepped:Connect(function()
			if not num16.enabled then
				return
			end

			if not list2.hasGun() then
				num16.warnNoGun()
				return
			end
			num16.noGunWarned = false

			pcall(function()
				local flag122
				flag122, flag122 = num16.getTarget()
				if not flag122 then
					return
				end
				local currentCamera = workspace.CurrentCamera
				if not currentCamera then
					return
				end
				currentCamera.CFrame = currentCamera.CFrame:Lerp(CFrame.new(currentCamera.CFrame.Position, num16.predictedPosition(flag122) or flag122.Position), math.clamp(num16.smooth, 0.01, 1))
			end)
		end)
	end

	num16.stop = function()
		if num16.conn then
			num16.conn:Disconnect()
			num16.conn = nil
		end
	end

	num16.refreshLabel = function()
		if num16.label then
			num16.label.Text = num16.enabled and "AIMBOT\nON" or "AIMBOT\nOFF"
		end

		num15.setActive("Aimbot", num16.enabled)
	end

	num16.set = function(enabled)
		num16.enabled = enabled

		if enabled then
			num16.start()
		else
			num16.stop()
		end

		num16.refreshLabel()

		if num16.toggleRef then
			pcall(function()
				num16.toggleRef:Set(enabled)
			end)
		end

		enabled = enabled and list2.enableSilentAim

		if enabled then
			list2.enableSilentAim()
		end
	end

	flag81 = { aimOn = false, aimConn = nil, aimDisabled = {}, conns = {} }
	flag82 = { enabled = false, conn = nil, delay = 0.18, fov = 60, last = 0 }

	local function func101(player7)
		if not player7 or not player7.Character then
			return false
		end
		local humanoid = player7.Character:FindFirstChildOfClass("Humanoid")
		return humanoid ~= nil and humanoid.Health > 0
	end

	local function func102(childName, list17)
		for _, item26 in ipairs(list17) do
			pcall(function()
				item26:Enable()
			end)
		end

		for i = #list17, 1, -1 do
			list17[i] = nil
		end

		if not getconnections then
			return false
		end

		return (pcall(function()
			local character = localPlayer.Character
			character = character and character:FindFirstChild(childName)
			if not character then
				return
			end

			for _, getconnection in ipairs(getconnections(character.Activated)) do
				getconnection:Disable()
				table.insert(list17, getconnection)
			end
		end))
	end

	local function func103(list18)
		for _, item27 in ipairs(list18) do
			pcall(function()
				item27:Enable()
			end)
		end

		for i = #list18, 1, -1 do
			list18[i] = nil
		end
	end

	local function func104(flag123, param79, callback2, param80)
		local function func105(flag124)
			if not flag124 then
				return
			end

			table.insert(param80, flag124.ChildAdded:Connect(function(child)
				if child.Name == flag123 and child:IsA("Tool") and callback2() then
					task.wait(0.1)
					func102(flag123, param79)
				end
			end))
		end

		func105(localPlayer.Character)

		table.insert(param80, localPlayer.CharacterAdded:Connect(function(character)
			if not callback2() then
				return
			end
			task.wait(1)
			func102(flag123, param79)
			func105(character)
		end))
	end

	func74 = function()
		if flag81.aimConn then
			return
		end
		func102("Gun", flag81.aimDisabled)

		if not getconnections then
			obj2:Notify({
				Title = "Silent Aim",
				Content = "Your executor has no getconnections - the normal shot fires too.",
				Duration = 4,
				Icon = "x",
			})
		end

		func104("Gun", flag81.aimDisabled, function()
			return flag81.aimOn
		end, flag81.conns)

		flag81.aimConn = localPlayer:GetMouse().Button1Down:Connect(function()
			if not flag81.aimOn then
				return
			end
			local character = localPlayer.Character
			local gun = character and character:FindFirstChild("Gun")
			gun = gun and gun:FindFirstChild("Shoot")
			character = character and character:FindFirstChild("HumanoidRootPart")
			if not gun or not character then
				return
			end
			local result13 = func15()
			local flag125 = result13 and result13 ~= localPlayer and func101(result13)
			local value126 = nil

			if flag125 then
				local humanoidRootPart = result13.Character:FindFirstChild("HumanoidRootPart")
				local flag126 = humanoidRootPart and (character.Position - humanoidRootPart.Position).Magnitude <= 300
				value126 = nil

				if flag126 then
					if flag78 and not list2.wallbang and not func65(result13.Character, character) then
						obj2:Notify({
							Title = "Wall Detected!",
							Content = "Murderer is behind a wall.",
							Duration = 2,
							Icon = "shield",
						})

						value126 = nil
					else
						value126 = list2.aimAt(result13, humanoidRootPart)
					end
				end
			end

			value126 = value126 or list2.mouseAimPoint()
			if not value126 then
				return
			end
			local gunRaycastAttachment = character:FindFirstChild("GunRaycastAttachment")

			if list2.wallbang and flag125 then
				gun:FireServer(CFrame.new(value126 + Vector3.new(0, 1.5, 0)), CFrame.new(value126))
			else
				gun:FireServer(gunRaycastAttachment and gunRaycastAttachment.WorldCFrame or CFrame.new(character.Position), CFrame.new(value126))
			end
		end)
	end

	func75 = function()
		if flag81.aimConn then
			pcall(function()
				flag81.aimConn:Disconnect()
			end)

			flag81.aimConn = nil
		end

		func103(flag81.aimDisabled)
		list2.dropConns(flag81.conns)
	end

	list2.enableSilentAim = function()
		if flag81.aimOn then
			return
		end
		flag81.aimOn = true
		func74()
		list2.setToggle(list2.el.silentaim, true)
	end

	flag82.start = function()
		if flag82.conn then
			return
		end

		flag82.conn = RunService.Heartbeat:Connect(function()
			if not flag82.enabled then
				return
			end
			local last = flag82.last
			if tick() - last < flag82.delay then
				return
			end

			pcall(function()
				if func16() ~= localPlayer then
					return
				end
				local character = localPlayer.Character
				local gun = character and character:FindFirstChild("Gun")
				gun = gun and gun:FindFirstChild("Shoot")
				if not gun then
					return
				end
				local result14 = func15()
				if not result14 or result14 == localPlayer or not func101(result14) then
					return
				end
				local humanoidRootPart = result14.Character:FindFirstChild("HumanoidRootPart")
				local humanoidRootPart2 = character:FindFirstChild("HumanoidRootPart")
				if not humanoidRootPart or not humanoidRootPart2 then
					return
				end
				local currentCamera = Workspace.CurrentCamera
				local value127, flag127 = currentCamera:WorldToViewportPoint(humanoidRootPart.Position)
				if not flag127 then
					return
				end
				local n8 = currentCamera.ViewportSize / 2
				if flag82.fov < (Vector2.new(value127.X, value127.Y) - n8).Magnitude then
					return
				end

				if flag78 and not list2.wallbang and not func65(result14.Character, humanoidRootPart2) then
					return
				end

				if (humanoidRootPart2.Position - humanoidRootPart.Position).Magnitude > 300 then
					return
				end
				flag82.last = tick()
				local gunRaycastAttachment = humanoidRootPart2:FindFirstChild("GunRaycastAttachment")
				local wallbangAim = list2.aimAt(result14, humanoidRootPart)

				if list2.wallbang then
					gun:FireServer(CFrame.new(wallbangAim + Vector3.new(0, 1.5, 0)), CFrame.new(wallbangAim))
				else
					gun:FireServer(gunRaycastAttachment and gunRaycastAttachment.WorldCFrame or CFrame.new(humanoidRootPart2.Position), CFrame.new(wallbangAim))
				end
			end)
		end)
	end

	flag82.stop = function()
		if flag82.conn then
			pcall(function()
				flag82.conn:Disconnect()
			end)

			flag82.conn = nil
		end
	end

	local function func106()
		local character = localPlayer.Character
		if not character then
			return nil
		end
		local knife = character:FindFirstChild("Knife")
		if knife then
			return knife, character
		end
		local backpack = localPlayer:FindFirstChild("Backpack")
		backpack = backpack and backpack:FindFirstChild("Knife")
		local humanoid = character:FindFirstChildOfClass("Humanoid")

		if backpack and humanoid then
			humanoid:EquipTool(backpack)
			task.wait(0.1)
			local character2 = localPlayer.Character
			return character2 and character2:FindFirstChild("Knife"), character2
		end

		return nil
	end

	local function func107(player8)
		if not player8 or not player8.Character then
			return false
		end
		local humanoid = player8.Character:FindFirstChildOfClass("Humanoid")
		if not humanoid or humanoid.Health <= 0 then
			return false
		end
		local obj14, obj15 = func106()
		if not obj14 or not obj15 then
			return false
		end
		local rightHand = obj15:FindFirstChild("RightHand") or obj15:FindFirstChild("HumanoidRootPart")
		if not rightHand then
			return false
		end
		local flag128 = func83(player8, 600, 0.95)
		if not flag128 then
			return false
		end
		local throw = obj14:FindFirstChild("Throw") or obj14:FindFirstChild("Events") and obj14.Events:FindFirstChild("KnifeThrown")
		if not (throw and throw:IsA("RemoteEvent")) then
			return false
		end
		local handle = obj14:FindFirstChild("Handle")
		throw:FireServer(handle and handle.CFrame or CFrame.new(rightHand.Position), CFrame.new(flag128))

		pcall(function()
			local humanoid2 = obj15:FindFirstChildOfClass("Humanoid")
			humanoid2 = humanoid2 and humanoid2:FindFirstChildOfClass("Animator")
			local throwKnife = obj14:FindFirstChild("ThrowKnife", true)

			if humanoid2 and throwKnife then
				humanoid2:LoadAnimation(throwKnife):Play(0.1, 6, 1)
			end
		end)

		return true
	end

	local function func108(list19, param81)
		local character

		if param81 then
			character = localPlayer.Character
			character = character and character:FindFirstChild("Knife")
		else
			character = func106()
		end

		character = character and character:FindFirstChild("Events")
		if not character then
			return 0
		end
		local knifeStabbed = character:FindFirstChild("KnifeStabbed")
		local handleTouched = character:FindFirstChild("HandleTouched")
		if not (knifeStabbed and handleTouched) then
			return 0
		end

		pcall(function()
			knifeStabbed:FireServer()
		end)

		local n8 = 0

		for _, item28 in ipairs(list19) do
			local character2 = item28.Character
			local humanoidRootPart = character2 and (character2:FindFirstChild("HumanoidRootPart") or character2:FindFirstChild("Torso") or character2:FindFirstChildWhichIsA("BasePart"))

			if humanoidRootPart then
				pcall(function()
					handleTouched:FireServer(humanoidRootPart)
				end)

				n8 += 1
			end
		end

		return n8
	end

	local function func109(flag129)
		local humanoidRootPart = localPlayer.Character and localPlayer.Character:FindFirstChild("HumanoidRootPart")
		local list20 = {}

		for _, player in ipairs(Players:GetPlayers()) do
			if player ~= localPlayer and player.Character then
				local humanoidRootPart2 = player.Character:FindFirstChild("HumanoidRootPart")
				local humanoid = player.Character:FindFirstChildOfClass("Humanoid")

				if humanoidRootPart2 and humanoid and humanoid.Health > 0 then
					local value128 = flag129 and humanoidRootPart
					local flag130 = true

					if value128 then
						flag130 = (humanoidRootPart2.Position - humanoidRootPart.Position).Magnitude <= flag129
					end

					if flag130 then
						list20[#list20 + 1] = player
					end
				end
			end
		end

		return list20
	end

	func76 = function(childName2)
		if not childName2 or childName2 == "" then
			obj2:Notify({ Title = "No target", Content = "Pick a player first.", Duration = 2, Icon = "x" })
			return
		end

		if func15() ~= localPlayer then
			obj2:Notify({ Title = "Not Murderer!", Content = "You don't have the knife.", Duration = 2, Icon = "x" })
			return
		end
		local flag131 = Players:FindFirstChild(childName2)
		if not flag131 then
			obj2:Notify({ Title = "Gone", Content = childName2 .. " isn't in the server.", Duration = 2, Icon = "x" })
			return
		end
		local flag132 = func108({ flag131 })

		obj2:Notify({
			Title = flag132 > 0 and "Stabbed" or "Failed",
			Content = flag132 > 0 and "Stabbed " .. childName2 .. "." or "Couldn't reach " .. childName2 .. ".",
			Duration = 2,
			Icon = flag132 > 0 and "check" or "x",
		})
	end

	func77 = function()
		if func15() ~= localPlayer then
			obj2:Notify({ Title = "Not Murderer!", Content = "You don't have the knife.", Duration = 2, Icon = "x" })
			return
		end
		local flag133 = func108(func109(nil))

		obj2:Notify({
			Title = "Kill All",
			Content = ("Stabbed %d player%s."):format(flag133, flag133 == 1 and "" or "s"),
			Duration = 2,
			Icon = "check",
		})
	end

	num17 = {
		on = false,
		conn = nil,
		show = false,
		ball = nil,
		showConn = nil,
		NORMAL = 1.5,
		STEP = 0.1,
		mult = 1,
		radius = 1.5,
		setMult = function(mult)
			num17.mult = mult
			num17.radius = num17.NORMAL * (1 + (mult - 1) * num17.STEP)
		end,
		stop = function()
			if num17.conn then
				pcall(function()
					num17.conn:Disconnect()
				end)
			end

			num17.conn = nil

			if num17.thrownConn then
				pcall(function()
					num17.thrownConn:Disconnect()
				end)
			end

			num17.thrownConn = nil
		end,
		start = function()
			num17.stop()

			num17.conn = localPlayer:GetMouse().Button1Down:Connect(function()
				if not num17.on then
					return
				end

				if func15() ~= localPlayer then
					return
				end
				func108(func109(num17.radius), true)
			end)

			num17.thrownConn = CollectionService:GetInstanceAddedSignal("ThrowingKnife"):Connect(function(part8)
				if not num17.on then
					return
				end

				task.spawn(function()
					local handleLink = part8:WaitForChild("HandleLink", 3)
					handleLink = handleLink and handleLink.Value
					handleLink = handleLink and handleLink.Parent
					local character = localPlayer.Character
					if not (handleLink and character and handleLink:IsDescendantOf(character)) then
						return
					end
					local events = handleLink:FindFirstChild("Events")
					local knifeStabbed = events and events:FindFirstChild("KnifeStabbed")
					local handleTouched = events and events:FindFirstChild("HandleTouched")
					if not (knifeStabbed and handleTouched) then
						return
					end
					local tbl42 = {}

					while part8.Parent and num17.on do
						local position = part8:IsA("BasePart") and part8.Position
						local position2

						if position then
							position2 = position
						else
							position2 = part8:IsA("Model") and part8:GetPivot().Position
						end

						if position2 then
							for _, player in ipairs(Players:GetPlayers()) do
								if player ~= localPlayer and not tbl42[player] and player.Character then
									local humanoidRootPart = player.Character:FindFirstChild("HumanoidRootPart")
									local humanoid = player.Character:FindFirstChildOfClass("Humanoid")

									if humanoidRootPart and humanoid and humanoid.Health > 0 and (humanoidRootPart.Position - position2).Magnitude <= num17.radius then
										tbl42[player] = true

										pcall(function()
											knifeStabbed:FireServer()
										end)

										pcall(function()
											handleTouched:FireServer(humanoidRootPart)
										end)
									end
								end
							end
						end

						task.wait(0.05)
					end
				end)
			end)
		end,
		hideBall = function()
			if num17.showConn then
				pcall(function()
					num17.showConn:Disconnect()
				end)
			end

			num17.showConn = nil

			if num17.ball then
				pcall(function()
					num17.ball:Destroy()
				end)
			end

			num17.ball = nil
		end,
		showBall = function()
			num17.hideBall()
			local part = Instance.new("Part")
			part.Name = "FVLHitboxSphere"
			part.Shape = Enum.PartType.Ball
			part.Anchored = true
			part.CanCollide = false
			part.CanTouch = false
			part.CanQuery = false
			part.CastShadow = false
			part.Material = Enum.Material.Neon
			part.Color = Color3.fromRGB(255, 90, 90)
			part.Transparency = 0.88
			part.Size = Vector3.one * num17.radius * 2
			part.Parent = Workspace.CurrentCamera
			num17.ball = part

			num17.showConn = RunService.RenderStepped:Connect(function()
				if not part.Parent then
					return
				end
				local character = localPlayer.Character
				if not character then
					return
				end
				local position = nil

				for _, item29 in ipairs(CollectionService:GetTagged("ThrowingKnife")) do
					local handleLink = item29:FindFirstChild("HandleLink")
					local flag134 = handleLink and handleLink.Value
					local parent = flag134 and flag134.Parent

					if parent and parent:IsDescendantOf(character) then
						position = item29:IsA("BasePart") and item29.Position or item29:IsA("Model") and item29:GetPivot().Position
						if not position then
							continue
						end
					else
						continue
					end

					break
				end

				if not position then
					position = character:FindFirstChild("Knife")
					position = position and position:FindFirstChild("Handle")
					position = position and position.Position
				end

				if not position then
					position = character:FindFirstChild("HumanoidRootPart")
					position = position and position.Position
				end

				if position then
					part.Size = Vector3.one * num17.radius * 2
					part.CFrame = CFrame.new(position)
				end
			end)
		end,
	}

	flag83 = {
		on = false,
		conn = nil,
		disabled = {},
		conns = {},
		stop = function()
			if flag83.conn then
				pcall(function()
					flag83.conn:Disconnect()
				end)
			end

			flag83.conn = nil
			func103(flag83.disabled)
			list2.dropConns(flag83.conns)
		end,
		start = function()
			if flag83.conn then
				return
			end
			func102("Knife", flag83.disabled)

			if not getconnections then
				obj2:Notify({
					Title = "Silent Throw",
					Content = "Your executor has no getconnections - the normal throw fires too.",
					Duration = 4,
					Icon = "x",
				})
			end

			func104("Knife", flag83.disabled, function()
				return flag83.on
			end, flag83.conns)

			flag83.conn = localPlayer:GetMouse().Button2Down:Connect(function()
				if not flag83.on then
					return
				end

				if func15() ~= localPlayer then
					return
				end
				local result15 = func66()
				if not result15 then
					return
				end
				local humanoidRootPart = localPlayer.Character and localPlayer.Character:FindFirstChild("HumanoidRootPart")

				if humanoidRootPart and flag78 and not func65(result15.Character, humanoidRootPart) then
					obj2:Notify({
						Title = "Wall Detected!",
						Content = result15.Name .. " is behind a wall.",
						Duration = 2,
						Icon = "shield",
					})

					return
				end

				func107(result15)
			end)
		end,
	}
end

local func110

func110 = function()
	local value129 = flag82
	flag81.aimOn = false
	value129.enabled = false
	func75()
	flag82.stop()
	list2.dropConns(flag81.conns)
	num17.on = false
	num17.stop()
	num17.show = false
	num17.hideBall()
	flag83.on = false
	flag83.stop()
end

MM2_GUN_ICON = "rbxassetid://79658449"

CURSORS = {
	Default = MM2_GUN_ICON,
	Paw = "rbxassetid://11767069582",
	Gengar = "rbxassetid://11759293285",
	Bunny = "rbxassetid://1912438810",
	["Hello Kitty"] = "rbxassetid://11351620343",
	["Kitty v2"] = "rbxassetid://11802094220",
	Heart = "rbxthumb://type=Asset&w=420&h=420&id=11722368344",
	Pentagram = "rbxassetid://51838212",
	Star = "rbxassetid://11716559277",
	["Star v2"] = "rbxassetid://11716557686",
	Osu = "rbxassetid://8390115370",
	["Power Star"] = "rbxassetid://1718840561",
	Troll = "rbxassetid://12438907427",
	Cross = "rbxthumb://type=Asset&w=420&h=420&id=14034486267",
	["Pink Star"] = "rbxthumb://type=Asset&w=420&h=420&id=11719595129",
	Kuromi = "rbxthumb://type=Asset&w=420&h=420&id=11893991373",
	["Red Heart"] = "rbxthumb://type=Asset&w=420&h=420&id=11754042886",
	["Green Heart"] = "rbxthumb://type=Asset&w=420&h=420&id=11754039821",
	["Blue Heart"] = "rbxthumb://type=Asset&w=420&h=420&id=11754037423",
	["Yellow Heart"] = "rbxthumb://type=Asset&w=420&h=420&id=11754042019",
	["Heart Cross"] = "rbxassetid://11739569678",
	["Clean Kitty"] = "rbxassetid://11718192673",
	["Pixel Cat"] = "rbxassetid://10878214990",
	["Evil Kitty"] = "rbxassetid://11734940424",
	["Vamp Face"] = "rbxassetid://11734893655",
	["Glowing Circle"] = "rbxassetid://10891594349",
	Bear = "rbxassetid://11722088774",
	["Shoot this guy"] = "rbxassetid://8680062686",
	Barbie = "rbxassetid://11754489642",
	Death = "rbxassetid://12472046162",
	Donut = "rbxassetid://11717104785",
	Cat = "rbxassetid://11722553511",
	["Blue Donut"] = "rbxassetid://11717093063",
}

local flag135, value130, func111, flag136, func112, func113

do
	local n4 = 55
	flag135 = { style = "Default", onlyWithGun = false, size = 50, spin = false }
	local mouse = localPlayer:GetMouse()
	local value131 = nil
	value130 = nil
	local connection5 = nil
	local mouseIconEnabled = UserInputService.MouseIconEnabled

	local function func114()
		return list2.hasGun()
	end

	local function func115()
		if connection5 then
			pcall(function()
				connection5:Disconnect()
			end)

			connection5 = nil
		end

		if value131 then
			pcall(function()
				value131:Destroy()
			end)

			value131 = nil
		end

		value130 = nil
		UserInputService.MouseIconEnabled = mouseIconEnabled

		pcall(function()
			mouse.Icon = func114() and MM2_GUN_ICON or ""
		end)
	end

	func111 = function()
		func115()
		if flag135.style == "Default" or not CURSORS[flag135.style] then
			return
		end
		local screenGui = Instance.new("ScreenGui")
		screenGui.Name = "FVLCrosshair"
		screenGui.ResetOnSpawn = false
		screenGui.IgnoreGuiInset = true
		screenGui.DisplayOrder = 10000
		screenGui.Parent = CoreGui
		local imageLabel = Instance.new("ImageLabel")
		imageLabel.AnchorPoint = Vector2.new(0.5, 0.5)
		imageLabel.BackgroundTransparency = 1
		imageLabel.Image = CURSORS[flag135.style] or CURSORS.Paw
		imageLabel.Size = UDim2.fromOffset(flag135.size, flag135.size)
		imageLabel.ScaleType = Enum.ScaleType.Stretch
		imageLabel.Parent = screenGui
		value131 = screenGui
		value130 = imageLabel

		connection5 = RunService.RenderStepped:Connect(function(deltaTime)
			if not imageLabel.Parent then
				return
			end

			if flag135.spin then
				imageLabel.Rotation = (imageLabel.Rotation + deltaTime * n4) % 360
			elseif imageLabel.Rotation ~= 0 then
				imageLabel.Rotation = 0
			end

			local visible = not flag135.onlyWithGun or func114()
			imageLabel.Visible = visible

			if visible then
				UserInputService.MouseIconEnabled = false
			else
				UserInputService.MouseIconEnabled = mouseIconEnabled
			end

			if visible then
				local mouseLocation = UserInputService:GetMouseLocation()
				imageLabel.Position = UDim2.fromOffset(mouseLocation.X, mouseLocation.Y)
			end
		end)
	end

	flag136 = false

	func112 = function(callback3)
		return function(...)
			if not flag136 then
				return
			end
			return callback3(...)
		end
	end

	func113 = function()
		flag135.style = "Default"
		func115()
	end
end

local tbl43
tbl43 = {}

ICON = {
	teal = Color3.fromHex("#14B8A6"),
	green = Color3.fromHex("#10B981"),
	grey = Color3.fromHex("#94A3B8"),
	purple = Color3.fromHex("#8B5CF6"),
	blue = Color3.fromHex("#3B82F6"),
	yellow = Color3.fromHex("#F59E0B"),
	red = Color3.fromHex("#F43F5E"),
	pink = Color3.fromHex("#EC4899"),
	gold = Color3.fromHex("#FFC107"),
	mono = Color3.fromHex("#E5E7EB"),
	tile = Color3.fromHex("#6E6E7B"),
}

tbl43.combat = obj3:Tab({
	Title = "Combat",
	Icon = "lucide:shield",
	IconColor = ICON.tile,
	IconShape = "Square",
	Border = true,
})

tbl43.crosshair = obj3:Tab({
	Title = "Crosshair",
	Icon = "lucide:crosshair",
	IconColor = ICON.tile,
	IconShape = "Square",
	Border = true,
})

tbl43.skins = obj3:Tab({
	Title = "Skin Changer",
	Icon = "lucide:sword",
	IconColor = ICON.tile,
	IconShape = "Square",
	Border = true,
})

do
	local color2 = Color3.new(1, 1, 1)
	local flag137 = false

	local function func116()
		for _, descendant in ipairs(obj3.UIElements.Main:GetDescendants()) do
			if descendant:IsA("TextLabel") and descendant.Text == "Skin Changer" then
				for _, descendant2 in ipairs(descendant.Parent.Parent:GetDescendants()) do
					if descendant2:IsA("ImageLabel") and descendant2.Name == "ImageLabel" and descendant2.ImageColor3 ~= ICON.tile then
						descendant2.ImageColor3 = color2

						descendant2:GetPropertyChangedSignal("ImageColor3"):Connect(function()
							if descendant2.ImageColor3 ~= color2 then
								descendant2.ImageColor3 = color2
							end
						end)

						flag137 = true
					end
				end

				return flag137
			end
		end

		return false
	end

	if not func116() then
		task.spawn(function()
			for i = 1, 30 do
				RunService.RenderStepped:Wait()
				if func116() then
					return
				end
			end
		end)
	end
end

tbl43.buttons = obj3:Tab({
	Title = "Buttons",
	Icon = "lucide:gamepad-directional",
	IconColor = ICON.tile,
	IconShape = "Square",
	Border = true,
})

tbl43.esp = obj3:Tab({
	Title = "ESP",
	Icon = "solar:eye-bold",
	IconColor = ICON.tile,
	IconShape = "Square",
	Border = true,
})

tbl43.fling = obj3:Tab({
	Title = "Fling & Teleport",
	Icon = "solar:bolt-bold",
	IconColor = ICON.tile,
	IconShape = "Square",
	Border = true,
})

tbl43.farm = obj3:Tab({
	Title = "Autofarm",
	Icon = "solar:dollar-minimalistic-bold",
	IconColor = ICON.tile,
	IconShape = "Square",
	Border = true,
})

tbl43.player = obj3:Tab({
	Title = "Player",
	Icon = "solar:user-bold",
	IconColor = ICON.tile,
	IconShape = "Square",
	Border = true,
})

tbl43.visuals = obj3:Tab({
	Title = "Visuals",
	Icon = "lucide:sparkles",
	IconColor = ICON.tile,
	IconShape = "Square",
	Border = true,
})

tbl43.visuals:Section({ Title = "Sound Changer" })

tbl43.visuals:Toggle({
	Title = "Error Sound",
	Flag = "Toggle_Sound_Errors",
	Desc = "A cue when something fails or gets refused.",
	Type = "Toggle",
	Value = true,
	Callback = function(error_)
		list2.sfxOn.error = error_
	end,
})

tbl43.visuals:Toggle({
	Title = "Gun Drop Sound",
	Flag = "Toggle_Sound_Gun_Drop",
	Desc = "A cue when the sheriff dies and the gun drops. Useful with the window closed.",
	Type = "Toggle",
	Value = true,
	Callback = function(gun)
		list2.sfxOn.gun = gun
	end,
})

tbl43.visuals:Toggle({
	Title = "Button Click Sound",
	Flag = "Toggle_Sound_Button_Click",
	Desc = "A click when you press an on-screen button.",
	Type = "Toggle",
	Value = true,
	Callback = function(click)
		list2.sfxOn.click = click
	end,
})

tbl43.visuals:Toggle({
	Title = "Toggle Sound",
	Flag = "Toggle_Sound_Switches",
	Desc = "A click when you flip a switch in the menu.",
	Type = "Toggle",
	Value = true,
	Callback = function(toggle)
		list2.sfxOn.toggle = toggle

		if toggle and list2.sfxReady and not list2.sfxQuiet then
			list2.playSfx("toggle")
		end
	end,
})

list2.myRole = function()
	local remotes = ReplicatedStorage:FindFirstChild("Remotes")
	remotes = remotes and remotes:FindFirstChild("Extras")
	local getPlayerData = remotes and remotes:FindFirstChild("GetPlayerData")
	if not getPlayerData then
		return nil
	end

	local ok, result = pcall(function()
		return getPlayerData:InvokeServer()
	end)

	if not ok or type(result) ~= "table" then
		return nil
	end
	local entry4 = result[localPlayer.Name]
	return entry4 and entry4.Role or nil
end

list2.godMode = function()
	if list2.godBusy then
		obj2:Notify({ Title = "God Mode", Content = "Already running.", Duration = 3, Icon = "clock" })
		return
	end
	local value132 = next
	local children, value133 = Workspace:GetChildren()
	local value134 = nil

	for _, value135 in value132, children, value133 do
		if value135:FindFirstChild("CoinAreas") or value135:FindFirstChild("CoinContainer") then
			value134 = value135
		end
	end

	if not value134 then
		obj2:Notify({
			Title = "No Map Yet",
			Content = "Wait till the round starts, then try again.",
			Duration = 5,
			Icon = "clock",
		})

		return
	end

	obj6 = value134
	if not (localPlayer.Character and localPlayer.Character:FindFirstChildOfClass("Humanoid")) then
		obj2:Notify({ Title = "God Mode", Content = "No character to reset.", Duration = 4, Icon = "x" })
		return
	end

	task.spawn(function()
		local flag138 = list2.myRole()

		if flag138 == "Murderer" then
			obj2:Notify({
				Title = "Murderer",
				Content = "This only works for Innocent and Sheriff.",
				Duration = 6,
				Icon = "x",
			})

			return
		end

		if flag138 == "Sheriff" then
			obj2:Popup({
				Title = "ARE YOU SURE YOU WANT TO LOSE UR GUN?",
				Icon = "shield",
				Content = "If you enable god mode you CANT pick up coins or kill someone.",
				Buttons = {
					{
						Title = "Cancel",
						Variant = "Tertiary",
						Callback = function()
						end,
					},
					{
						Title = "Yes, do it",
						Variant = "Primary",
						Callback = function()
							list2.godRun()
						end,
					},
				},
			})

			return
		end

		list2.godRun()
	end)
end

list2.godRun = function()
	if list2.godBusy then
		return
	end
	local humanoid = localPlayer.Character and localPlayer.Character:FindFirstChildOfClass("Humanoid")
	if not humanoid then
		obj2:Notify({ Title = "God Mode", Content = "No character to reset.", Duration = 4, Icon = "x" })
		return
	end
	list2.godBusy = true

	task.spawn(function()
		obj2:Notify({
			Title = "God Mode",
			Content = "Resetting, back on the map in a second...",
			Duration = 3,
			Icon = "shield",
		})

		pcall(function()
			humanoid.Health = 0
		end)

		task.wait(1)
		local now = tick()
		local flag139

		while true do
			flag139 = func47(localPlayer)

			if not flag139 then
				task.wait(0.2)
			end

			if not (flag139 or tick() - now > 10) then
				continue
			end
			break
		end

		if flag139 then
			pcall(list2.teleportHome)

			obj2:Notify({
				Title = "God Mode On!",
				Content = "You cannot pick up coins or the gun now.",
				Duration = 6,
				Icon = "shield",
			})
		else
			obj2:Notify({ Title = "God Mode", Content = "Respawn took too long - try again.", Duration = 5, Icon = "x" })
		end

		list2.godBusy = false
	end)
end

tbl43.keybinds = obj3:Tab({
	Title = "Keybinds",
	Icon = "lucide:keyboard",
	IconColor = ICON.tile,
	IconShape = "Square",
	Border = true,
})

tbl43.settings = obj3:Tab({
	Title = "Settings & Configs",
	Icon = "solar:settings-bold",
	IconColor = ICON.tile,
	IconShape = "Square",
	Border = true,
})


do
	local tbl44 = {
		Combat = ICON.tile,
		Crosshair = ICON.tile,
		["Skin Changer"] = ICON.tile,
		Buttons = ICON.tile,
		ESP = ICON.tile,
		["Fling & Teleport"] = ICON.tile,
		Autofarm = ICON.tile,
		Player = ICON.tile,
		Visuals = ICON.tile,
		Keybinds = ICON.tile,
		["Settings & Configs"] = ICON.tile,
	}

	local color2 = Color3.new(1, 1, 1)
	local tbl45 = {}

	local function func117(param82, num27)
		return math.abs(param82.R - num27.R) < 0.02 and math.abs(param82.G - num27.G) < 0.02 and math.abs(param82.B - num27.B) < 0.02
	end

	task.spawn(function()
		for i = 1, 60 do
			local n4 = 0

			pcall(function()
				for _, descendant in ipairs(obj3.UIElements.Main:GetDescendants()) do
					local parent = descendant:IsA("TextLabel") and tbl44[descendant.Text] and descendant.Parent and descendant.Parent.Parent or nil

					if parent and parent:IsA("ImageButton") then
						local descendants = parent:GetDescendants()
						local value136 = nil

						for _, descendant2 in ipairs(descendants) do
							if descendant2:IsA("ImageLabel") and func117(descendant2.ImageColor3, tbl44[descendant.Text]) then
								value136 = descendant2
								break
							else
								value136 = nil
							end
						end

						if value136 then
							if not value136:FindFirstChildWhichIsA("UIGradient") then
								local uiGradient = Instance.new("UIGradient")
								uiGradient.Rotation = 90
								local new = ColorSequenceKeypoint.new
								local color3 = Color3.fromRGB
								uiGradient.Color = ColorSequence.new({ ColorSequenceKeypoint.new(0, Color3.new(1, 1, 1)), new(1, color3(115, 115, 125)) })
								uiGradient.Parent = value136
								n4 += 1
							end

							for _, descendant2 in ipairs(descendants) do
								if descendant2 ~= value136 and descendant2:IsA("ImageLabel") and descendant2.Name == "ImageLabel" and not tbl45[descendant2] then
									tbl45[descendant2] = true
									descendant2.ImageColor3 = color2

									descendant2:GetPropertyChangedSignal("ImageColor3"):Connect(function()
										if descendant2.ImageColor3 ~= color2 then
											descendant2.ImageColor3 = color2
										end
									end)

									n4 += 1
								end
							end
						end
					end
				end
			end)

			if n4 > 0 then
				return
			end
			RunService.RenderStepped:Wait()
		end
	end)
end

local func118

func118 = function(param83, imageColor3, imageTransparency, textColor3)
	imageTransparency = imageTransparency or 0.55

	for _, descendant in ipairs(obj3.UIElements.Main:GetDescendants()) do
		if descendant:IsA("TextLabel") and descendant.Text == param83 then
			local imageButton = descendant:FindFirstAncestorWhichIsA("ImageButton")

			if imageButton then
				imageButton.ImageColor3 = imageColor3
				imageButton.ImageTransparency = imageTransparency

				imageButton:GetPropertyChangedSignal("ImageColor3"):Connect(function()
					if imageButton.ImageColor3 ~= imageColor3 then
						imageButton.ImageColor3 = imageColor3
					end
				end)

				imageButton:GetPropertyChangedSignal("ImageTransparency"):Connect(function()
					if imageButton.ImageTransparency > imageTransparency then
						imageButton.ImageTransparency = imageTransparency
					end
				end)

				if textColor3 then
					for _, descendant2 in ipairs(imageButton:GetDescendants()) do
						if descendant2:IsA("TextLabel") then
							descendant2.TextColor3 = textColor3

							descendant2:GetPropertyChangedSignal("TextColor3"):Connect(function()
								if descendant2.TextColor3 ~= textColor3 then
									descendant2.TextColor3 = textColor3
								end
							end)
						elseif descendant2:IsA("ImageLabel") and descendant2.Size ~= UDim2.new(1, 0, 1, 0) then
							descendant2.ImageColor3 = textColor3

							descendant2:GetPropertyChangedSignal("ImageColor3"):Connect(function()
								if descendant2.ImageColor3 ~= textColor3 then
									descendant2.ImageColor3 = textColor3
								end
							end)
						end
					end
				end
			end

			return
		end
	end
end

local func119

func119 = function(param84)
	local ok, result = pcall(function()
		return param84.ParagraphFrame.UIElements.Container
	end)

	if ok and typeof(result) == "Instance" then
		return result
	end
	return nil
end

local func120
local tbl46 = {}

func120 = function(imageColor3)
	for _, descendant in ipairs(obj3.UIElements.Main:GetDescendants()) do
		if not tbl46[descendant] and descendant.Name == "ToggleFrame" then
			local layer = descendant:FindFirstChild("Layer")

			if layer then
				tbl46[descendant] = true
				layer.ImageColor3 = imageColor3

				if not layer:FindFirstChildWhichIsA("UIGradient") then
					local uiGradient = Instance.new("UIGradient")
					uiGradient.Rotation = 115

					uiGradient.Color = ColorSequence.new({
						ColorSequenceKeypoint.new(0, Color3.new(1, 1, 1)),
						ColorSequenceKeypoint.new(1, Color3.fromRGB(120, 120, 130)),
					})

					uiGradient.Parent = layer
				end

				local frame = descendant:FindFirstChild("Frame")
				frame = frame and frame:FindFirstChild("Bar")
				frame = frame and frame:FindFirstChild("Highlight")
				local glass = frame and frame:FindFirstChild("Glass")

				if glass then
					glass.ImageColor3 = imageColor3

					glass:GetPropertyChangedSignal("ImageColor3"):Connect(function()
						if glass.ImageColor3 ~= imageColor3 then
							glass.ImageColor3 = imageColor3
						end
					end)
				end
			end
		end
	end
end

tbl43.esp:Section({ Title = "ESP — See Through Walls" })

tbl43.esp:Toggle({
	Title = "ESP Outline",
	Flag = "Toggle_ESP_Outline",
	Desc = "Glowing outline on every player through walls.",
	Type = "Toggle",
	Value = false,
	Callback = function(value)
		flag18 = value

		if func17() then
			func18()
			func21()
		else
			obj4:RemoveGroup("players")
			func22()
		end
	end,
})

tbl43.esp:Toggle({
	Title = "Full Body ESP",
	Flag = "Toggle_Full_Body_ESP",
	Desc = "Fills the whole body in the role colour.",
	Type = "Toggle",
	Value = false,
	Callback = function(value)
		flag19 = value

		if func17() then
			func18()
			func21()
		else
			obj4:RemoveGroup("players")
			func22()
		end
	end,
})

tbl43.esp:Toggle({
	Title = "Display Name ESP",
	Flag = "Toggle_Display_Name_ESP",
	Desc = "Their display name above their head, in the role colour.",
	Type = "Toggle",
	Value = false,
	Callback = function(value)
		flag20 = value

		if func17() then
			func18()
			func21()
		else
			obj4:RemoveGroup("players")
			func22()
		end
	end,
})

tbl43.esp:Toggle({
	Title = "Dropped Gun ESP",
	Flag = "Toggle_Dropped_Gun_ESP",
	Desc = "Shows the gun on the floor after the sheriff dies.",
	Type = "Toggle",
	Value = false,
	Callback = function(value)
		flag21 = value
		func19()
	end,
})

tbl43.esp:Toggle({
	Title = "Trap ESP",
	Flag = "Toggle_Trap_ESP",
	Desc = "Shows traps other players hid around the map.",
	Type = "Toggle",
	Value = false,
	Callback = function(value)
		flag22 = value
		func20()
	end,
})

tbl43.esp:Section({ Title = "Tracers & Distance" })

tbl43.esp:Toggle({
	Title = "Tracers",
	Flag = "Toggle_ESP_Tracers",
	Desc = "Draws a line from the bottom of your screen to every player, in their role colour.",
	Type = "Toggle",
	Value = false,
	Callback = function(lines)
		list2.tr.lines = lines
		list2.tr.sync()
	end,
})

tbl43.esp:Toggle({
	Title = "Distance",
	Flag = "Toggle_ESP_Distance",
	Desc = "How many studs away each player is, written under their feet.",
	Type = "Toggle",
	Value = false,
	Callback = function(dist)
		list2.tr.dist = dist
		list2.tr.sync()
	end,
})

tbl43.esp:Toggle({
	Title = "Off-Screen Arrows",
	Flag = "Toggle_ESP_Arrows",
	Desc = "Arrows around your crosshair pointing at the players you cannot see - including the ones behind you.",
	Type = "Toggle",
	Value = false,
	Callback = function(arrows)
		list2.tr.arrows = arrows
		list2.tr.sync()
	end,
})

tbl43.esp:Section({ Title = "ESP Colours" })

tbl43.esp:Colorpicker({
	Title = "Innocent",
	Flag = "Colorpicker_Innocent",
	Desc = "Outline colour for everyone else",
	Default = espColors.innocent,
	Callback = function(innocent)
		espColors.innocent = innocent
		local value137 = flag18
		local value138

		if flag18 then
			value138 = value137
		else
			value138 = flag19
		end

		if value138 then
			func18()
		end
	end,
})

tbl43.esp:Colorpicker({
	Title = "Sheriff",
	Flag = "Colorpicker_Sheriff",
	Desc = "Outline colour for the sheriff",
	Default = espColors.sheriff,
	Callback = function(sheriff)
		espColors.sheriff = sheriff
		local value139 = flag18
		local value140

		if flag18 then
			value140 = value139
		else
			value140 = flag19
		end

		if value140 then
			func18()
		end
	end,
})

tbl43.esp:Colorpicker({
	Title = "Murderer",
	Flag = "Colorpicker_Murderer",
	Desc = "Outline colour for the murderer",
	Default = espColors.murderer,
	Callback = function(murderer)
		espColors.murderer = murderer
		local value141 = flag18
		local value142

		if flag18 then
			value142 = value141
		else
			value142 = flag19
		end

		if value142 then
			func18()
		end
	end,
})

tbl43.esp:Colorpicker({
	Title = "Dropped Gun",
	Flag = "Colorpicker_Dropped_Gun_Blue",
	Desc = "Highlight colour for the dropped gun",
	Default = espColors.gun,
	Callback = function(gun)
		espColors.gun = gun
		func19()
	end,
})

tbl43.esp:Colorpicker({
	Title = "Traps",
	Flag = "Colorpicker_Traps",
	Desc = "Highlight colour for traps",
	Default = espColors.trap,
	Callback = function(trap)
		espColors.trap = trap
		func20()
	end,
})

func120(ICON.mono)
tbl43.fling:Section({ Title = "Quick Actions" })

list2.el.flingMurd = tbl43.fling:Button({
	Title = "Fling Murderer",
	Desc = "Yeet whoever has the knife",
	Icon = "lucide:flame",
	Callback = function()
		local result16 = func15()
		if not result16 then
			obj2:Notify({ Title = "Error!", Content = "No murderer this round!", Duration = 1.5, Icon = "x" })
			return
		end

		if result16 == localPlayer then
			obj2:Notify({ Title = "Error!", Content = "You can't fling yourself!", Duration = 1.5, Icon = "x" })
			return
		end
		func27(result16)
	end,
})

list2.el.flingSher = tbl43.fling:Button({
	Title = "Fling Sheriff",
	Desc = "Yeet whoever has the gun",
	Icon = "lucide:flame",
	Callback = function()
		local result17 = func16()
		if not result17 then
			obj2:Notify({ Title = "Error!", Content = "No sheriff this round!", Duration = 1.5, Icon = "x" })
			return
		end

		if result17 == localPlayer then
			obj2:Notify({ Title = "Error!", Content = "You can't fling yourself!", Duration = 1.5, Icon = "x" })
			return
		end
		func27(result17)
	end,
})

tbl43.fling:Button({
	Title = "Fling All",
	Desc = "Yeet everyone in the server, one after another. Press again to stop",
	Icon = "lucide:flame",
	Callback = function()
		list2.flingAll()
	end,
})

func118("Fling Murderer", Color3.fromHex("#FCA5A5"))
func118("Fling Sheriff", Color3.fromHex("#93C5FD"))
func118("Fling All", Color3.fromHex("#FDBA74"))

list2.el.tpMurd = tbl43.fling:Button({
	Title = "Teleport to Murderer",
	Desc = "Instantly go to whoever has the knife",
	Icon = "lucide:crosshair",
	Callback = function()
		func31(func15(), "Murderer")
	end,
})

list2.el.tpSher = tbl43.fling:Button({
	Title = "Teleport to Sheriff",
	Desc = "Instantly go to whoever has the gun",
	Icon = "lucide:shield",
	Callback = function()
		func31(func16(), "Sheriff")
	end,
})

tbl43.fling:Section({ Title = "Target Player" })
local connection5

do
	local value143 = nil

	local function func121()
		local tbl47 = {}

		for _, player in ipairs(Players:GetPlayers()) do
			if player ~= localPlayer then
				table.insert(tbl47, player.Name)
			end
		end

		return tbl47
	end

	local obj16 = tbl43.fling:Dropdown({
		Title = "Target",
		Desc = "Pick a player for the buttons below",
		Multi = false,
		Value = nil,
		Values = func121(),
		Callback = function(value)
			value143 = value
		end,
	})

	func28 = function()
		return value143
	end

	local function func122()
		pcall(function()
			obj16:Refresh(func121())
		end)

		pcall(function()
			killTargetDropdown:Refresh(func121())
		end)
	end

	list2.conns[#list2.conns + 1] = Players.PlayerAdded:Connect(func122)
	list2.conns[#list2.conns + 1] = Players.PlayerRemoving:Connect(func122)

	local function func123()
		if not value143 then
			obj2:Notify({ Title = "Error!", Content = "Pick a player first!", Duration = 1.5, Icon = "x" })
			return nil
		end
		local flag140 = Players:FindFirstChild(value143)
		if not flag140 then
			obj2:Notify({ Title = "Error!", Content = "Player left the game!", Duration = 1.5, Icon = "x" })
			return nil
		end

		if flag140 == localPlayer then
			obj2:Notify({ Title = "Error!", Content = "You can't target yourself!", Duration = 1.5, Icon = "x" })
			return nil
		end
		return flag140
	end

	tbl43.fling:Button({
		Title = "Fling Player",
		Desc = "Fling whoever you picked above",
		Icon = "lucide:zap",
		Color = Color3.fromHex("#d6d6d6"),
		Callback = function()
			local result18 = func123()

			if result18 then
				func27(result18)
			end
		end,
	})

	tbl43.fling:Button({
		Title = "Teleport",
		Desc = "Teleport to the selected player",
		Icon = "lucide:navigation",
		Color = Color3.fromHex("#d6d6d6"),
		Callback = function()
			local result19 = func123()

			if result19 then
				func31(result19, result19.Name)
			end
		end,
	})

	local value144 = nil

	value144 = tbl43.fling:Toggle({
		Title = "Spam Fling",
		Flag = "Toggle_Spam_Fling",
		Desc = "Keeps flinging the player picked above until you turn it off",
		Type = "Toggle",
		Value = false,
		Callback = function(value)
			flag34 = value

			if value then
				if not value143 then
					obj2:Notify({
						Title = "Error!",
						Content = "Pick a player from the dropdown first!",
						Duration = 2,
						Icon = "x",
					})

					flag34 = false

					pcall(function()
						value144:Set(false)
					end)

					return
				end

				func29()

				obj2:Notify({
					Title = "Spam Fling ON",
					Content = "Spam flinging " .. value143 .. "!",
					Duration = 2,
					Icon = "flame",
				})
			else
				func30()

				obj2:Notify({
					Title = "Spam Fling OFF",
					Content = "Stopped spam flinging.",
					Duration = 2,
					Icon = "power-off",
				})
			end
		end,
	})

	list2.GUN_ICON = "http://www.roblox.com/asset/?id=197518111"
	list2.KNIFE_ICON = "rbxassetid://584555920"

	list2.FLAG_ICON = {
		Toggle_Sound_Errors = "rbxassetid://83898160590116",
		Toggle_Sound_Button_Click = "rbxassetid://107150227368485",
		Toggle_Sound_Switches = "rbxassetid://85887872573050",
	}

	list2.ROLE_ICON = {
		Toggle_Auto_Grab_Gun = "gun",
		Toggle_Silent_Aim = "gun",
		Toggle_Dropped_Gun_ESP = "gun",
		Toggle_Sound_Gun_Drop = "gun",
		Toggle_Silent_Throw = "knife",
		Toggle_Fling_Murderer_When_Done = "knife",
		Toggle_Kill_All_When_Bag_Full = "knife",
	}

	task.spawn(function()
		local tbl48 = {}

		for k, value145 in pairs(list2.ROLE_ICON) do
			tbl48[k] = value145 == "gun" and list2.GUN_ICON or list2.KNIFE_ICON
		end

		for k, value146 in pairs(list2.FLAG_ICON) do
			tbl48[k] = value146
		end

		local tbl49 = {}
		local n4 = os.clock() + 30

		while os.clock() < n4 do
			local elements = list2.config and list2.config.Elements

			if type(elements) ~= "table" then
				task.wait(0.5)
				continue
			else
				local flag141 = false

				for k, value147 in pairs(tbl48) do
					if not tbl49[k] then
						local entry5 = elements[k]

						if entry5 then
							pcall(function()
								entry5:SetImage(value147, 28)
							end)

							tbl49[k] = true
						else
							flag141 = true
						end
					end
				end

				if flag141 then
					task.wait(0.5)
					continue
				end
			end

			break
		end

		for i = 1, 80 do
			if not (#list2.gunEls > 0 and #list2.knifeEls > 0 and list2.el.flingSher and list2.el.tpSher and list2.el.flingMurd and list2.el.tpMurd) then
				task.wait(0.25)
				continue
			end
			break
		end

		local list21 = {}

		for _, gunEl in ipairs(list2.gunEls) do
			list21[#list21 + 1] = { gunEl, list2.GUN_ICON }
		end

		for _, knifeEl in ipairs(list2.knifeEls) do
			list21[#list21 + 1] = { knifeEl, list2.KNIFE_ICON }
		end

		list21[#list21 + 1] = { list2.el.flingSher, list2.GUN_ICON }
		list21[#list21 + 1] = { list2.el.tpSher, list2.GUN_ICON }
		list21[#list21 + 1] = { list2.el.flingMurd, list2.KNIFE_ICON }
		list21[#list21 + 1] = { list2.el.tpMurd, list2.KNIFE_ICON }
		list2.iconsApplied = 0

		for _, item30 in ipairs(list21) do
			if type(item30[1]) == "table" then
				if pcall(function()
					item30[1]:SetImage(item30[2], 28)
				end) then
					list2.iconsApplied = list2.iconsApplied + 1
				end
			end
		end

		for k in pairs(tbl49) do
			list2.iconsApplied = list2.iconsApplied + 1
		end
	end)

	func120(ICON.mono)
	tbl43.farm:Section({ Title = "Coin Autofarm" })

	tbl43.farm:Toggle({
		Title = "Coin Autofarm",
		Flag = "Toggle_Coin_Autofarm",
		Desc = "Walks you around picking up coins.",
		Type = "Toggle",
		Value = false,
		Callback = function(value)
			if value then
				if flag42 then
					list2.setToggle(list2.el.fly, false, function()
						flag42 = false
						func42()
					end)
				end

				func48()
				list2.startFarmHopWatch()
				obj2:Notify({ Title = "Autofarm Started!", Content = "Farming coins!", Duration = 2, Icon = "check" })
			else
				func49()
				list2.stopFarmHopWatch()
				obj2:Notify({ Title = "Autofarm Stopped!", Content = "Stopped farming.", Duration = 2, Icon = "power-off" })
			end
		end,
	})

	tbl43.farm:Slider({
		Title = "Farm Speed",
		Flag = "Slider_Farm_Speed",
		Desc = "Meters per second",
		Step = 1,
		Value = { Min = 5, Max = 25, Default = 25 },
		Callback = function(value)
			n2 = value >= 25 and 23 or value
		end,
	})

	tbl43.farm:Section({ Title = "Settings" })

	list2.perfFarmToggle = tbl43.farm:Toggle({
		Title = "Performance Mode",
		Flag = "Toggle_Farm_Perf_Master",
		Desc = "Strips textures, shadows, particles and effects for framerate. Same switch as the one on the Visuals tab.",
		Type = "Toggle",
		Value = false,
		Callback = function(value)
			if list2.perf then
				list2.perf.setAll(value)
			end
		end,
	})

	list2.farmHopOn = true

	tbl43.farm:Toggle({
		Title = "Hop When Server Dies",
		Flag = "Toggle_Farm_Dead_Hop",
		Desc = "Hops to a fresh server when this one empties out mid-farm.",
		Type = "Toggle",
		Value = true,
		Callback = function(farmHopOn)
			list2.farmHopOn = farmHopOn
		end,
	})

	tbl43.farm:Toggle({
		Title = "Anti-AFK",
		Flag = "Toggle_Anti_AFK",
		Desc = "Prevents you from getting AFK kicked.",
		Type = "Toggle",
		Value = true,
		Callback = function(value)
			flag47 = value

			if value then
				func52()
				obj2:Notify({ Title = "Anti-AFK Enabled!", Content = "You can go AFK now!", Duration = 2, Icon = "shield" })
			else
				func53()

				obj2:Notify({
					Title = "Anti-AFK Disabled!",
					Content = "AFK protection off.",
					Duration = 2,
					Icon = "power-off",
				})
			end
		end,
	})

	tbl43.farm:Toggle({
		Title = "Auto-Reset When Bag Full",
		Flag = "Toggle_Auto_Reset_When_Bag_Full",
		Desc = "Resets you once your coin bag is full",
		Type = "Toggle",
		Value = true,
		Callback = function(value)
			flag46 = value

			if value then
				func50()
			else
				func51()
			end
		end,
	})

	tbl43.farm:Toggle({
		Title = "Auto Claim Shells",
		Flag = "Toggle_Auto_Claim_Shells",
		Desc = "Claims the end-of-round reward popup for you",
		Type = "Toggle",
		Value = false,
		Callback = function(shellsOn)
			list2.shellsOn = shellsOn

			if shellsOn then
				list2.startShells()

				obj2:Notify({
					Title = "Auto Claim Shells On!",
					Content = "Rewards claim themselves.",
					Duration = 2,
					Icon = "check",
				})
			else
				list2.stopShells()

				obj2:Notify({
					Title = "Auto Claim Shells Off!",
					Content = "Claim them yourself.",
					Duration = 2,
					Icon = "power-off",
				})
			end
		end,
	})

	tbl43.farm:Toggle({
		Title = "Fling Murderer When Done",
		Flag = "Toggle_Fling_Murderer_When_Done",
		Desc = "Yeets the murderer once your bag is full or the coins run out",
		Type = "Toggle",
		Value = false,
		Callback = function(flingWhenDone)
			list2.flingWhenDone = flingWhenDone

			if flingWhenDone then
				list2.flingDoneFired = false
			end
		end,
	})

	tbl43.farm:Toggle({
		Title = "Kill All When Bag Full",
		Flag = "Toggle_Kill_All_When_Bag_Full",
		Desc = "Stabs everyone once your bag fills up. Murderer only.",
		Type = "Toggle",
		Value = false,
		Callback = function(killWhenFull)
			list2.killWhenFull = killWhenFull

			if killWhenFull then
				list2.killFired = false
			end
		end,
	})

	flag47 = true
	func52()
	flag46 = true
	func50()
	tbl43.farm:Section({ Title = "Discord Webhook" })

	list2.el.whUrl = tbl43.farm:Input({
		Title = "Webhook URL",
		Flag = "Input_Discord_Webhook",
		Desc = "Paste a Discord webhook and logging starts. Logs box opens, shell claims and round coins. Empty the box to stop.",
		Placeholder = "https://discord.com/api/webhooks/...",
		Callback = function(value)
			local whUrl = tostring(value or "")

			if whUrl ~= tostring(list2.WH_URL or "") then
				list2.saidHello = false
				list2.whBreak = false
				list2.whLastErr = nil
			end

			list2.WH_URL = whUrl
		end,
	})

	list2.el.whOn = tbl43.farm:Toggle({
		Title = "Start Sender",
		Flag = "Toggle_Discord_Sender",
		Desc = "Starts posting to the webhook above. Logs box opens, shell claims and the coins each round paid out.",
		Type = "Toggle",
		Value = false,
		Callback = function(whOn)
			list2.whOn = whOn
			if not whOn then
				return
			end

			task.spawn(function()
				local flag142, value148 = list2.whHello()

				obj2:Notify({
					Title = flag142 and "Sender Started" or "Sender Failed",
					Content = flag142 and "Posted the opening message to your webhook." or "Could not post: " .. tostring(value148) .. ".",
					Duration = 6,
					Icon = flag142 and "check" or "x",
				})

				if not flag142 then
					list2.whOn = false
					list2.setToggle(list2.el.whOn, false)
				end
			end)
		end,
	})

	tbl43.farm:Section({ Title = "Auto Open Boxes" })
	list2.el.box = {}

	for _, boxe in ipairs(list2.BOXES) do
		local first3 = boxe[1]
		local second3 = boxe[2]
		local value149, flag143 = list2.boxPrice(first3)

		list2.el.box[first3] = tbl43.farm:Toggle({
			Title = "Auto Open " .. second3,
			Flag = "Toggle_Box_" .. first3:gsub("%W", "_"),
			Desc = "Waits until you get " .. (flag143 and list2.comma(flag143) or "?") .. " " .. list2.curName(value149) .. ", then auto-opens the box for you!",
			Type = "Toggle",
			Value = false,
			Callback = function(value)
				list2.boxOn[first3] = value

				if value then
					list2.startBox(first3, second3)
				else
					list2.stopBox(first3)
				end
			end,
		})

		local value150 = list2.boxImage(first3)

		if value150 then
			pcall(function()
				list2.el.box[first3]:SetImage(value150, 30)
			end)
		end

		if first3 == "Summer2026Box" then
			local elementFrame = list2.el.box[first3] and list2.el.box[first3].ElementFrame

			if typeof(elementFrame) == "Instance" then
				local uiGradient = elementFrame:FindFirstChildWhichIsA("UIGradient")

				if uiGradient then
					uiGradient:Destroy()
				end

				local uiGradient2 = Instance.new("UIGradient")
				uiGradient2.Color = ColorSequence.new(ICON.yellow, ICON.teal)
				uiGradient2.Parent = elementFrame
			end
		end
	end

	func120(ICON.mono)

	tbl43.buttons:Toggle({
		Title = "Lock Buttons In Place",
		Flag = "Toggle_Lock_Buttons_In_Place",
		Desc = "Stops the on-screen buttons moving when you tap them.",
		Type = "Toggle",
		Value = false,
		Callback = function(locked)
			num15.locked = locked
		end,
	})

	list2.el.designDrop = tbl43.buttons:Dropdown({
		Title = "Button Design",
		Flag = "Dropdown_Button_Design",
		Desc = "Round Design is a circle with a ring that fills as the cooldown runs. Default Design puts a gauge along the bottom.",
		Multi = false,
		Value = "Default Design",
		Values = num15.DESIGN_LIST,
		Callback = function(value)
			num15.setDesign(tostring(type(value) == "table" and (value[1] or value.Value) or value))
		end,
	})

	list2.el.sizeSlider = tbl43.buttons:Slider({
		Title = "Button Size",
		Flag = "Slider_Button_Size",
		Desc = "Scales the on-screen buttons. 100 is normal.",
		Step = 1,
		Value = { Min = 50, Max = 200, Default = IS_MOBILE and 70 or 100 },
		Callback = function(value)
			local num28 = tonumber(value)
			local flag144

			if num28 then
				flag144 = num28
			else
				flag144 = type(value) == "table" and tonumber(value.Value)
			end

			list2.hudScale = (flag144 or IS_MOBILE and 70 or 100) / 100

			for _, value151 in next, num15.parts, nil do
				if value151.scale then
					local tbl50 = { Scale = list2.hudScale }
					TweenService:Create(value151.scale, TweenInfo.new(0.15, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), tbl50):Play()
				end
			end

			num15.relayout()
		end,
	})

	tbl43.buttons:Section({ Title = "On-Screen Buttons" })

	tbl43.buttons:Toggle({
		Title = "Shoot Murderer",
		Flag = "Toggle_Shoot_Murderer",
		Desc = "Draggable on-screen button that shoots the murderer",
		Type = "Toggle",
		Value = false,
		Callback = function(value)
			if value then
				num15.create("Shoot", "SHOOT\nMURDERER", tbl35.Shoot, HUDAccent.Shoot, HUDIcon.Shoot, func67)
			else
				num15.destroy("Shoot")
			end
		end,
	})

	tbl43.buttons:Toggle({
		Title = "Grab Gun",
		Flag = "Toggle_Grab_Gun",
		Desc = "Grabs the gun off the floor. It only drops when the sheriff dies.",
		Type = "Toggle",
		Value = false,
		Callback = function(value)
			if value then
				num15.create("Grab", "GRAB\nGUN", tbl35.Grab, HUDAccent.Grab, HUDIcon.Grab, func73)
			else
				num15.destroy("Grab")
			end
		end,
	})

	tbl43.buttons:Toggle({
		Title = "Throw Knife",
		Flag = "Toggle_Throw_Knife",
		Desc = "Throws your knife at the nearest player",
		Type = "Toggle",
		Value = false,
		Callback = function(value)
			if value then
				num15.create("Throw", "THROW\nKNIFE", tbl35.Throw, HUDAccent.Throw, HUDIcon.Throw, func68)
			else
				num15.destroy("Throw")
			end
		end,
	})

	tbl43.buttons:Toggle({
		Title = "Bomb Jump",
		Flag = "Toggle_Bomb_Jump",
		Desc = "Bomb jump, with the cooldown shown on the button",
		Type = "Toggle",
		Value = false,
		Callback = function(value)
			if value then
				num15.create("Bomb", "BOMB\nJUMP", tbl35.Bomb, HUDAccent.Bomb, HUDIcon.Bomb, func71)
			else
				num15.destroy("Bomb")
			end
		end,
	})

	tbl43.buttons:Toggle({
		Title = "Wall Hop",
		Flag = "Toggle_Wall_Hop",
		Desc = "Climbs the wall you are standing against.",
		Type = "Toggle",
		Value = false,
		Callback = function(value)
			if value then
				num15.create("WallHop", "WALL\nHOP", tbl35.WallHop, HUDAccent.WallHop, HUDIcon.WallHop, func72)
			else
				num15.destroy("WallHop")
			end
		end,
	})

	tbl43.buttons:Toggle({
		Title = "Aimbot Button",
		Flag = "Toggle_Aimbot_Button",
		Desc = "Turns the aimbot on and off, and shows its state.",
		Type = "Toggle",
		Value = false,
		Callback = function(value)
			if value then
				local Aimbot, value152 = num15.create("Aimbot", "AIMBOT\nOFF", tbl35.Aimbot, HUDAccent.Aimbot, HUDIcon.Aimbot, function()
					num16.set(not num16.enabled)
				end)

				num16.label = value152
				num16.refreshLabel()
			else
				num15.destroy("Aimbot")
				num16.label = nil
				num16.set(false)
			end
		end,
	})

	list2.killSheriff = function()
		local result20 = func16()

		if not result20 then
			obj2:Notify({
				Title = "No Sheriff",
				Content = "Nobody is holding the gun right now.",
				Duration = 2,
				Icon = "x",
			})

			return
		end

		func76(result20.Name)
	end

	tbl43.buttons:Section({ Title = "Extra Buttons" })

	tbl43.buttons:Toggle({
		Title = "Kill All Button  (Murderer Only)",
		Flag = "Toggle_Kill_All_Button",
		Desc = "Stabs every player at once. Murderer only.",
		Type = "Toggle",
		Value = false,
		Callback = function(value)
			if value then
				num15.create("KillAll", "KILL ALL\nMURDER\nONLY", tbl35.KillAll, HUDAccent.KillAll, HUDIcon.KillAll, func77)
			else
				num15.destroy("KillAll")
			end
		end,
	})

	tbl43.buttons:Toggle({
		Title = "Kill Sheriff Button  (Murderer Only)",
		Flag = "Toggle_Kill_Sheriff_Button",
		Desc = "Stabs whoever is holding the gun. Murderer only.",
		Type = "Toggle",
		Value = false,
		Callback = function(value)
			if value then
				num15.create("KillSheriff", "KILL\nSHERIFF", tbl35.KillSheriff, HUDAccent.KillSheriff, HUDIcon.KillSheriff, list2.killSheriff)
			else
				num15.destroy("KillSheriff")
			end
		end,
	})

	tbl43.buttons:Toggle({
		Title = "Free X-Ray Button",
		Flag = "Toggle_Xray_Button",
		Desc = "Unlocks the X-Ray perk for free.",
		Type = "Toggle",
		Value = false,
		Callback = function(value)
			if value then
				num15.create("Xray", "FREE\nX-RAY", tbl35.Xray, HUDAccent.Xray, HUDIcon.Xray, function()
					list2.setXray(not list2.xrayOn)
					num15.setActive("Xray", list2.xrayOn)
				end)

				num15.setActive("Xray", list2.xrayOn)
			else
				num15.destroy("Xray")
			end
		end,
	})

	tbl43.buttons:Toggle({
		Title = "Fly Button",
		Flag = "Toggle_Fly_Button",
		Desc = "On-screen button that turns Fly on and off. Same fly as the Player tab.",
		Type = "Toggle",
		Value = false,
		Callback = function(value)
			if value then
				num15.create("Fly", "FLY", tbl35.Fly, HUDAccent.Fly, HUDIcon.Fly, function()
					flag42 = not flag42

					if flag42 then
						func41()
					else
						func42()
					end

					num15.setActive("Fly", flag42)
					list2.setToggle(list2.el.fly, flag42)
				end)

				num15.setActive("Fly", flag42)
			else
				num15.destroy("Fly")
			end
		end,
	})

	tbl43.buttons:Toggle({
		Title = "Noclip Button",
		Flag = "Toggle_Noclip_Button",
		Desc = "Turns Noclip on and off - walk through walls.",
		Type = "Toggle",
		Value = false,
		Callback = function(value)
			if value then
				num15.create("Noclip", "NOCLIP", tbl35.Noclip, HUDAccent.Noclip, HUDIcon.Noclip, function()
					flag41 = not flag41

					if flag41 then
						func39()
					else
						func40()
					end

					num15.setActive("Noclip", flag41)
					list2.setToggle(list2.el.noclip, flag41)
				end)

				num15.setActive("Noclip", flag41)
			else
				num15.destroy("Noclip")
			end
		end,
	})

	list2.BTN_GLYPH = {
		Toggle_Shoot_Murderer = "Shoot",
		Toggle_Grab_Gun = "Grab",
		Toggle_Throw_Knife = "Throw",
		Toggle_Bomb_Jump = "Bomb",
		Toggle_Wall_Hop = "WallHop",
		Toggle_Aimbot_Button = "Aimbot",
		Toggle_Kill_All_Button = "KillAll",
		Toggle_Kill_Sheriff_Button = "KillSheriff",
		Toggle_Xray_Button = "Xray",
		Toggle_Fly_Button = "Fly",
		Toggle_Noclip_Button = "Noclip",
	}

	task.spawn(function()
		for i = 1, 40 do
			if not (list2.config and type(list2.config.Elements) == "table") then
				task.wait(0.25)
				continue
			end
			break
		end

		local elements = list2.config and list2.config.Elements
		if type(elements) ~= "table" then
			return
		end

		for k, value153 in pairs(list2.BTN_GLYPH) do
			local entry6 = elements[k]
			local entry7 = HUDIcon[value153]
			local value154 = entry7 and ICONS[entry7] or nil

			if entry6 and value154 then
				pcall(function()
					entry6:SetImage(value154, 28)
				end)
			end
		end
	end)

	list2.hudSpawns = {
		Shoot = function()
			num15.create("Shoot", "SHOOT\nMURDERER", tbl35.Shoot, HUDAccent.Shoot, HUDIcon.Shoot, func67)
		end,
		Grab = function()
			num15.create("Grab", "GRAB\nGUN", tbl35.Grab, HUDAccent.Grab, HUDIcon.Grab, func73)
		end,
		Throw = function()
			num15.create("Throw", "THROW\nKNIFE", tbl35.Throw, HUDAccent.Throw, HUDIcon.Throw, func68)
		end,
		Aimbot = function()
			local Aimbot, value155 = num15.create("Aimbot", "AIMBOT\nOFF", tbl35.Aimbot, HUDAccent.Aimbot, HUDIcon.Aimbot, function()
				num16.set(not num16.enabled)
			end)

			num16.label = value155
			num16.refreshLabel()
		end,
		Bomb = function()
			num15.create("Bomb", "BOMB\nJUMP", tbl35.Bomb, HUDAccent.Bomb, HUDIcon.Bomb, func71)
		end,
		WallHop = function()
			num15.create("WallHop", "WALL\nHOP", tbl35.WallHop, HUDAccent.WallHop, HUDIcon.WallHop, func72)
		end,
		KillAll = function()
			num15.create("KillAll", "KILL ALL\nMURDER\nONLY", tbl35.KillAll, HUDAccent.KillAll, HUDIcon.KillAll, func77)
		end,
		KillSheriff = function()
			num15.create("KillSheriff", "KILL\nSHERIFF", tbl35.KillSheriff, HUDAccent.KillSheriff, HUDIcon.KillSheriff, list2.killSheriff)
		end,
		Xray = function()
			num15.create("Xray", "FREE\nX-RAY", tbl35.Xray, HUDAccent.Xray, HUDIcon.Xray, function()
				list2.setXray(not list2.xrayOn)
				num15.setActive("Xray", list2.xrayOn)
			end)

			num15.setActive("Xray", list2.xrayOn)
		end,
		Fly = function()
			num15.create("Fly", "FLY", tbl35.Fly, HUDAccent.Fly, HUDIcon.Fly, function()
				flag42 = not flag42

				if flag42 then
					func41()
				else
					func42()
				end

				num15.setActive("Fly", flag42)
				list2.setToggle(list2.el.fly, flag42)
			end)

			num15.setActive("Fly", flag42)
		end,
		Noclip = function()
			num15.create("Noclip", "NOCLIP", tbl35.Noclip, HUDAccent.Noclip, HUDIcon.Noclip, function()
				flag41 = not flag41

				if flag41 then
					func39()
				else
					func40()
				end

				num15.setActive("Noclip", flag41)
				list2.setToggle(list2.el.noclip, flag41)
			end)

			num15.setActive("Noclip", flag41)
		end,
	}

	local function hudSavedOn(flag)
		local ok, data = pcall(function()
			if isfile and readfile and isfile("WindUI/FVLV2/config/autosave.json") then
				return HttpService:JSONDecode(readfile("WindUI/FVLV2/config/autosave.json"))
			end
		end)

		if ok and type(data) == "table" then
			local elements = type(data.__elements) == "table" and data.__elements or data
			local entry = elements[flag]

			if type(entry) == "table" and entry.value ~= nil then
				return entry.value and true or false
			elseif type(entry) == "boolean" then
				return entry
			end
		end

		return false
	end

	for flag, name2 in pairs(list2.BTN_GLYPH) do
		if hudSavedOn(flag) and list2.hudSpawns[name2] then
			list2.hudSpawns[name2]()
		end
	end

	num15.relayout()

	task.spawn(function()
		RunService.RenderStepped:Wait()

		pcall(function()
			local main = obj3.UIElements.Main
			local num29

			for k in next, num15.guis, nil do
				local textButton = CoreGui:FindFirstChild("FVL" .. k .. "Button")
				textButton = textButton and textButton:FindFirstChildWhichIsA("TextButton")

				if textButton then
					local n4 = textButton.AbsolutePosition.Y + textButton.AbsoluteSize.Y

					if not num29 or n4 > num29 then
						num29 = n4
					end
				end
			end

			if not num29 then
				return
			end
			local viewportSize = Workspace.CurrentCamera.ViewportSize
			local n4 = math.min(560, viewportSize.Y - 40)
			local n5 = main.AbsolutePosition.Y + main.AbsoluteSize.Y / 2
			local n6 = math.min(num29 + 12 + n4 / 2, viewportSize.Y - n4 / 2 - 8) - n5

			if n6 > 0 then
				local position = main.Position
				main.Position = UDim2.new(position.X.Scale, position.X.Offset, position.Y.Scale, position.Y.Offset + n6)
			end
		end)
	end)

	local function func124()
		local value156 = BOMB_COOLDOWN
		if tick() - n3 < value156 then
			return
		end
		n3 = tick()

		if num15 then
			num15.startCooldown("Bomb", BOMB_COOLDOWN, "BOMB\nJUMP")
		end
	end

	local function func125()
		for _, item31 in ipairs(tbl34) do
			pcall(function()
				item31:Disconnect()
			end)
		end

		tbl34 = {}

		local function func126(instance5)
			if not instance5 then
				return
			end
			local fakeBomb = instance5:FindFirstChild("FakeBomb")

			if fakeBomb and fakeBomb:IsA("Tool") then
				table.insert(tbl34, fakeBomb.Activated:Connect(func124))
			end

			table.insert(tbl34, instance5.ChildAdded:Connect(function(child)
				if child.Name == "FakeBomb" and child:IsA("Tool") then
					table.insert(tbl34, child.Activated:Connect(func124))
				end
			end))
		end

		func126(localPlayer:FindFirstChild("Backpack"))
		func126(localPlayer.Character)
	end

	func125()

	connection5 = localPlayer.CharacterAdded:Connect(function(character)
		character:WaitForChild("Humanoid")
		task.wait(0.5)
		func125()
	end)

	func120(ICON.mono)

	local function func127()
		local Players_ = game:GetService("Players")
		local ReplicatedStorage_ = game:GetService("ReplicatedStorage")
		game:GetService("InsertService")
		local localPlayer2 = Players_.LocalPlayer

		pcall(function()
			if setthreadidentity then
				setthreadidentity(2)
			end
		end)

		if _G.__MM2Viz and _G.__MM2Viz.destroy then
			pcall(_G.__MM2Viz.destroy)
		end

		local mM2Viz = { conns = {} }
		_G.__MM2Viz = mM2Viz
		local EquipService = require(ReplicatedStorage_:WaitForChild("ClientServices"):WaitForChild("EquipService"))
		local Sync = require(ReplicatedStorage_:WaitForChild("Database"):WaitForChild("Sync"))
		local ProfileData = require(ReplicatedStorage_:WaitForChild("Modules"):WaitForChild("ProfileData"))
		local weapons = Sync.Weapons
		local inventoryDataChanged = ReplicatedStorage_:WaitForChild("Remotes"):WaitForChild("Inventory"):WaitForChild("InventoryDataChanged")

		local function func128(url8)
			local ok, result = pcall(function()
				return game:HttpGet(url8, true)
			end)

			if ok and type(result) == "string" and #result > 0 then
				return result
			end
			local request_ = syn and syn.request or request or http_request or http and http.request
			if not request_ then
				return nil, tostring(result)
			end
			local ok2, result2 = pcall(request_, { Url = url8, Method = "GET" })
			if ok2 and type(result2) == "table" and type(result2.Body) == "string" and #result2.Body > 0 then
				return result2.Body
			end
			return nil, tostring(ok2 and result2 and result2.StatusCode or result2)
		end

		local lua = nil

		if isfile and readfile and isfile("FVLV2/weapon.lua") then
			local ok, result = pcall(readfile, "FVLV2/weapon.lua")

			if ok and type(result) == "string" and #result > 100000 then
				lua = result
			end
		end

		local flag145 = lua ~= nil
		local value157 = nil

		if not lua then
			lua, value157 = func128("https://raw.githubusercontent.com/kroxn/visual/refs/heads/main/weapon.lua")
		end

		if not lua then
			error("[MM2Viz] could not fetch mesh data from " .. "https://raw.githubusercontent.com/kroxn/visual/refs/heads/main/weapon.lua" .. " -- " .. tostring(value157), 0)
		end

		local chunk, value158 = loadstring(lua .. "\nreturn MESHES_FULL")

		if not chunk and flag145 then
			lua = func128("https://raw.githubusercontent.com/kroxn/visual/refs/heads/main/weapon.lua")
			chunk = lua and loadstring(lua .. "\nreturn MESHES_FULL")
			flag145 = false
			value158 = nil
		end

		if not chunk then
			error("[MM2Viz] mesh data failed to compile -- " .. tostring(value158), 0)
		end

		if not flag145 and writefile then
			pcall(function()
				if makefolder and isfolder and not isfolder("FVLV2") then
					makefolder("FVLV2")
				end

				writefile("FVLV2/weapon.lua", lua)
			end)
		end

		local result21 = chunk()

		if type(result21) ~= "table" or next(result21) == nil then
			error("[MM2Viz] fetched file produced no MESHES_FULL table (is the URL the data file?)", 0)
		end

		local tbl51 = {}

		for k, value159 in pairs(result21) do
			tbl51[k] = value159
		end

		local sweetChroma = tbl51.SweetChroma

		if sweetChroma and sweetChroma.Model and not tbl51.Sweet then
			local value160 = nil

			value160 = function(list22)
				local tbl52 = { Class = list22.Class, Id = list22.Id, Name = list22.Name, Props = list22.Props, Tags = list22.Tags }

				if list22.Children then
					tbl52.Children = {}

					for _, child in ipairs(list22.Children) do
						if not (child.Class == "Decal" and child.Name == "Chroma") then
							tbl52.Children[#tbl52.Children + 1] = value160(child)
						end
					end
				end

				return tbl52
			end

			local tbl53 = {}
			local func129 = pairs
			local meta = sweetChroma.Meta or {}

			for k, value161 in func129(meta) do
				tbl53[k] = value161
			end

			tbl53.Chroma = nil
			tbl51.Sweet = { Complete = false, Meta = tbl53, Model = value160(sweetChroma.Model) }
		end

		local tbl54 = { Godly = true, Ancient = true }

		local function func130(flag146)
			local str25 = tostring(flag146 or "")
			return str25 == "" or str25:match("^%?+$") ~= nil
		end

		local tbl55 = {}
		local n4 = 0

		for k, value162 in pairs(tbl51) do
			local entry8 = weapons[k]

			if type(entry8) == "table" and (entry8.ItemType == "Knife" or entry8.ItemType == "Gun") and tbl54[entry8.Rarity] and not func130(entry8.ItemName) then
				tbl55[k] = value162
			else
				n4 += 1
			end
		end

		local tbl56 = tbl55
		local n5 = 0
		local n6 = 0

		for _, value163 in pairs(tbl56) do
			n5 += 1

			if value163.Model then
				n6 += 1
			end
		end

		local RunService_ = game:GetService("RunService")
		local CollectionService_ = game:GetService("CollectionService")

		local function func131(text3)
			if type(text3) == "string" then
				return (text3:gsub("^%s+", ""):gsub("%s+$", ""))
			end
			return text3
		end

		local function func132(tbl57, list23, tbl58)
			for k, value164 in pairs(list23) do
				if not (tbl58 and tbl58[k]) then
					if k == "MeshId" or k == "TextureId" or k == "TextureID" or k == "Texture" then
						value164 = func131(value164)
					end

					pcall(function()
						tbl57[k] = value164
					end)
				end
			end
		end

		local function createPart(param85)
			local value165 = func131(param85.MeshId or "")
			local size = param85.Size or Vector3.one
			local value166 = nil

			pcall(function()
				value166 = game:GetService("InsertService"):CreateMeshPartAsync(value165, Enum.CollisionFidelity.Box, Enum.RenderFidelity.Precise)
			end)

			if value166 then
				pcall(function()
					value166.Size = size
				end)

				return value166
			end

			local part = Instance.new("Part")
			part.Size = size
			local specialMesh = Instance.new("SpecialMesh")
			specialMesh.MeshType = Enum.MeshType.FileMesh

			pcall(function()
				specialMesh.MeshId = value165
			end)

			pcall(function()
				specialMesh.TextureId = func131(param85.TextureID or "")
			end)

			specialMesh.Parent = part
			return part
		end

		local color2 = Color3.fromRGB(255, 0, 0)
		local color3 = Color3.fromRGB(255, 255, 0)
		local color4 = Color3.fromRGB(0, 255, 0)
		local color5 = Color3.fromRGB(0, 255, 255)
		local color6 = Color3.fromRGB(0, 0, 255)
		local color7 = Color3.fromRGB
		local tbl59 = { color2, color3, color4, color5, color6 }

		do
			local values = table.pack(color7(255, 0, 255))
			table.move(values, 1, values.n, 6, tbl59)
		end

		local function func133(num30)
			local n7 = #tbl59
			local n8 = num30 % n7
			local n9 = math.floor(n8)
			return tbl59[n9 + 1]:Lerp(tbl59[(n9 + 1) % n7 + 1], n8 - n9)
		end

		local function func134(obj17, param86)
			if param86.Meta and param86.Meta.Chroma == true then
				return true
			end
			return obj17:sub(-6) == "Chroma"
		end

		local n7 = 1.8

		local function func135(instance6)
			local list24 = {}
			local list25 = {}
			local list26 = {}
			local list27 = {}
			local flag147 = false

			for _, descendant in ipairs(instance6:GetDescendants()) do
				local attribute = descendant:GetAttribute("MM2Chroma")

				if attribute then
					if attribute == "part" then
						list24[#list24 + 1] = descendant
						flag147 = true
					elseif attribute == "decal" and descendant:IsA("Decal") then
						pcall(function()
							descendant.Texture = "rbxassetid://18363392181"
						end)

						list25[#list25 + 1] = descendant
						flag147 = true
					else
						flag147 = true

						if attribute == "fire" then
							list26[#list26 + 1] = descendant
						end
					end
				end
			end

			if not flag147 then
				for _, descendant in ipairs(instance6:GetDescendants()) do
					if descendant:IsA("BasePart") and (descendant.Material == Enum.Material.Neon or descendant.Name:lower():find("light")) then
						list24[#list24 + 1] = descendant
					elseif descendant:IsA("Decal") and descendant.Name:lower():find("chroma") then
						list25[#list25 + 1] = descendant
					elseif descendant:IsA("Fire") then
						list26[#list26 + 1] = descendant
					end
				end

				if #list25 == 0 then
					list26[#list26 + 1] = instance6
				end
			end

			local tbl60 = {}

			for _, item32 in ipairs(list26) do
				if item32:IsA("BasePart") then
					tbl60[item32] = true
				end
			end

			for _, item33 in ipairs(list24) do
				tbl60[item33] = nil
			end

			for _, descendant in ipairs(instance6:GetDescendants()) do
				if descendant:IsA("SpecialMesh") and descendant.TextureId ~= "" and tbl60[descendant.Parent] then
					list27[#list27 + 1] = descendant
				end
			end

			if instance6:IsA("Part") and tbl60[instance6] then
				local specialMesh = instance6:FindFirstChildWhichIsA("SpecialMesh")

				if specialMesh and specialMesh.TextureId ~= "" then
					list27[#list27 + 1] = specialMesh
				end
			end

			if #list24 == 0 and #list25 == 0 and #list26 == 0 and #list27 == 0 then
				return nil
			end

			return RunService_.Heartbeat:Connect(function()
				local now = os.clock()
				local value167 = func133(now)

				for _, item34 in ipairs(list25) do
					item34.Color3 = value167
				end

				for _, item35 in ipairs(list27) do
					item35.VertexColor = Vector3.new(value167.R, value167.G, value167.B)
				end

				for _, item36 in ipairs(list26) do
					if item36:IsA("Fire") then
						item36.Color = value167
					elseif item36:IsA("BasePart") then
						item36.Color = value167
					end
				end

				local n8 = math.floor(now * n7)

				for i, item37 in ipairs(list24) do
					item37.Color = tbl59[(n8 + i - 1) % #tbl59 + 1]
				end
			end)
		end

		local tbl61 = {
			WeldConstraint = true,
			Weld = true,
			Motor6D = true,
			RigidConstraint = true,
			Bone = true,
			Snap = true,
			ManualWeld = true,
			Rotate = true,
			RotateP = true,
			RotateV = true,
		}

		local function func136(obj18, list28)
			if not (obj18 and list28.Tags) then
				return
			end

			for _, tag in ipairs(list28.Tags) do
				local str26 = tag == "ChromaPart" and "part" or tag == "ChromaDecal" and "decal"
				local flag148

				if str26 then
					flag148 = str26
				else
					flag148 = tag == "ChromaFire" and "fire"
				end

				flag148 = flag148 or nil

				if flag148 then
					pcall(function()
						obj18:SetAttribute("MM2Chroma", flag148)
					end)
				end
			end
		end

		local function func137(param87)
			local class = param87.Class
			if tbl61[class] then
				return nil
			end
			local value168

			if class == "MeshPart" then
				value168 = createPart(param87.Props)
				func132(value168, param87.Props, { MeshId = true, Size = true, RelCF = true, CanCollide = true })
			else
				local ok, result = pcall(Instance.new, class)
				if not ok or not result then
					return nil
				end
				value168 = result
				func132(value168, param87.Props, { RelCF = true })
			end

			if param87.Name then
				pcall(function()
					value168.Name = param87.Name
				end)
			end

			func136(value168, param87)
			return value168
		end

		local value169 = nil

		value169 = function(param88, parent, parent2, tbl62, list29, list30)
			local func138 = ipairs
			local children = param88.Children or {}

			for _, child in func138(children) do
				local obj19 = func137(child)

				if obj19 then
					tbl62[child.Id] = obj19

					if obj19:IsA("BasePart") then
						obj19.Anchored = false
						obj19.CanCollide = false
						obj19.CanQuery = false
						obj19.CanTouch = false
						obj19.Massless = true
						list29[#list29 + 1] = { inst = obj19, relcf = child.Props.RelCF }
						obj19.Parent = parent2
						value169(child, obj19, parent2, tbl62, list29, list30)
					elseif obj19:IsA("Attachment") then
						if child.Props.RelCF then
							pcall(function()
								obj19.CFrame = child.Props.RelCF
							end)
						end

						obj19.Parent = parent2
						value169(child, obj19, parent2, tbl62, list29, list30)
					elseif obj19:IsA("Beam") or obj19:IsA("Trail") then
						obj19.Parent = parent
						list30[#list30 + 1] = { inst = obj19, a0 = child.Att0, a1 = child.Att1 }
						value169(child, obj19, parent2, tbl62, list29, list30)
					else
						obj19.Parent = parent
						value169(child, obj19, parent2, tbl62, list29, list30)
					end
				else
					value169(child, parent, parent2, tbl62, list29, list30)
				end
			end
		end

		local function func139(param89)
			local model = param89.Model
			if not model then
				return nil
			end
			local part

			if model.Class == "MeshPart" then
				part = createPart(model.Props)
				func132(part, model.Props, { MeshId = true, Size = true, RelCF = true, CanCollide = true })
			else
				part = Instance.new("Part")
				func132(part, model.Props, { RelCF = true, CanCollide = true })
			end

			if model.Name then
				pcall(function()
					part.Name = model.Name
				end)
			end

			func136(part, model)
			part.Anchored = false
			part.CanCollide = false
			part.CanQuery = false
			part.CanTouch = false
			part.Massless = true
			local tbl63 = { [model.Id] = part }
			local tbl64 = {}
			local tbl65 = {}
			value169(model, part, part, tbl63, tbl64, tbl65)

			for _, item38 in ipairs(tbl65) do
				if item38.a0 and tbl63[item38.a0] then
					pcall(function()
						item38.inst.Attachment0 = tbl63[item38.a0]
					end)
				end

				if item38.a1 and tbl63[item38.a1] then
					pcall(function()
						item38.inst.Attachment1 = tbl63[item38.a1]
					end)
				end
			end

			return { root = part, parts = tbl64 }
		end

		local function func140(list31, cFrame)
			local root = list31.root

			pcall(function()
				root.CFrame = cFrame
			end)

			for _, part in ipairs(list31.parts) do
				if part.relcf then
					pcall(function()
						part.inst.CFrame = cFrame * part.relcf
					end)
				end

				local weldConstraint = Instance.new("WeldConstraint")
				weldConstraint.Part0 = part.inst
				weldConstraint.Part1 = root
				weldConstraint.Parent = part.inst
			end

			return root
		end

		local tbl66 = {
			ParticleEmitter = true,
			Fire = true,
			Smoke = true,
			Sparkles = true,
			PointLight = true,
			SpotLight = true,
			SurfaceLight = true,
		}

		local function func141(param90)
			local value170 = nil
			local list32 = {}
			local list33 = {}
			local list34 = {}
			local func142 = ipairs
			local display = param90.Display or {}

			for _, value171 in func142(display) do
				if value171.Path == "(root)" then
					value170 = value171
				elseif value171.Class == "SpecialMesh" then
					list32[#list32 + 1] = value171
				elseif value171.Class == "Decal" or value171.Class == "Texture" then
					list33[#list33 + 1] = value171
				elseif tbl66[value171.Class] then
					list34[#list34 + 1] = value171
				end
			end

			if not value170 then
				return nil
			end
			local part

			if value170.Class == "MeshPart" then
				part = createPart(value170.Props)
				func132(part, value170.Props, { MeshId = true, Size = true, CanCollide = true })
			else
				part = Instance.new("Part")
				part.Size = value170.Props.Size or Vector3.one
				func132(part, value170.Props, { Size = true, CanCollide = true })

				for _, item39 in ipairs(list32) do
					local specialMesh = Instance.new("SpecialMesh")
					specialMesh.MeshType = Enum.MeshType.FileMesh
					func132(specialMesh, item39.Props)
					specialMesh.Parent = part
				end
			end

			part.Anchored = false
			part.CanCollide = false
			part.CanQuery = false
			part.CanTouch = false
			part.Massless = true

			if value170.Name then
				pcall(function()
					part.Name = value170.Name
				end)
			end

			for _, item40 in ipairs(list33) do
				local decal = Instance.new("Decal")
				func132(decal, item40.Props)

				if item40.Name then
					pcall(function()
						decal.Name = item40.Name
					end)
				end

				decal.Parent = part
			end

			for _, item41 in ipairs(list34) do
				local ok, result = pcall(Instance.new, item41.Class)

				if ok and result then
					func132(result, item41.Props)

					if item41.Name then
						pcall(function()
							result.Name = item41.Name
						end)
					end

					result.Parent = part
				end
			end

			return { root = part, parts = {} }
		end

		local function func143(param91)
			if param91.Model then
				return func139(param91)
			end

			if param91.Display then
				return func141(param91)
			end
			return nil
		end

		local function func144(param92)
			if param92.Model then
				local model = param92.Model
				if model.Class == "MeshPart" then
					return func131(model.Props.MeshId or "")
				end
				local func145 = ipairs
				local children = model.Children or {}

				for _, child in func145(children) do
					if child.Class == "SpecialMesh" then
						return func131(child.Props.MeshId or "")
					end
				end

				return ""
			end

			local func146 = ipairs
			local display = param92.Display or {}

			for _, value172 in func146(display) do
				if value172.Path == "(root)" and value172.Class == "MeshPart" then
					return func131(value172.Props.MeshId or "")
				end

				if value172.Class == "SpecialMesh" then
					return func131(value172.Props.MeshId or "")
				end
			end

			return ""
		end

		local function func147(instance7)
			if not instance7 then
				return ""
			end

			if instance7:IsA("MeshPart") then
				return func131(instance7.MeshId or "")
			end
			local specialMesh = instance7:FindFirstChildWhichIsA("SpecialMesh", true)

			if specialMesh then
				specialMesh = func131(specialMesh.MeshId or "")
			end

			return specialMesh or ""
		end

		local cframe = CFrame.identity
		local value173 = nil

		value173 = function(param93)
			local func148 = ipairs
			local children = param93.Children or {}

			for _, child in func148(children) do
				if child.Class == "Attachment" and child.Name == "CustomAttachment" and child.Props and child.Props.RelCF then
					return child.Props.RelCF
				end
				local value174 = value173(child)
				if value174 then
					return value174
				end
			end

			return nil
		end

		local function func149(param94)
			if param94.Model then
				return param94.Model.Props and param94.Model.Props.Size
			end
			local func150 = ipairs
			local display = param94.Display or {}

			for _, value175 in func150(display) do
				if value175.Path == "(root)" then
					return value175.Props and value175.Props.Size
				end
			end

			return nil
		end

		local function func151(flag149)
			if not flag149 then
				return nil
			end
			local tbl67 = { { flag149.X, "X" }, { flag149.Y, "Y" }, { flag149.Z, "Z" } }

			table.sort(tbl67, function(tbl68, tbl69)
				return tbl68[1] > tbl69[1]
			end)

			return tbl67[1][2] .. tbl67[2][2] .. tbl67[3][2]
		end

		local tbl70 = {
			Gun_ZYX = CFrame.new(0.12991, -3e-05, 0.075, 1, 0, 0, 0, 0.70713, 0.70708, 0, -0.70708, 0.70713),
			Gun_ZXY = CFrame.new(0.12991, 0, 0.07501, 2e-05, -0.5, -0.86603, 1, -4e-05, 5e-05, -6e-05, -0.86603, 0.5),
			Gun_XYZ = CFrame.new(-0.22989, 0.09821, 0.1, 1e-05, 0.98481, -0.17362, -1e-05, 0.17362, 0.98481, 1, -1e-05, 1e-05),
			Knife_YXZ = CFrame.new(0, 0, 0, -0.0446, -0.00031, -0.99901, 0.03549, 0.99937, -0.00189, 0.99837, -0.03553, -0.04456),
			Knife_ZYX = CFrame.new(0.00151, -0.12701, -0.15448, -0.99867, 0.03727, 0.03568, -0.04098, -0.15276, -0.98741, -0.03135, -0.98756, 0.15409),
			Knife_ZXY = CFrame.new(0.00151, -0.12701, -0.15448, -0.99867, 0.03727, 0.03568, -0.04098, -0.15276, -0.98741, -0.03135, -0.98756, 0.15409),
		}

		local mM2VizLearned = _G.__MM2VizLearned or {}
		_G.__MM2VizLearned = mM2VizLearned
		local mM2VizOverride = _G.__MM2VizOverride or {}
		_G.__MM2VizOverride = mM2VizOverride
		local mM2VizOverrideGrip = _G.__MM2VizOverrideGrip or {}
		_G.__MM2VizOverrideGrip = mM2VizOverrideGrip

		local function func152(instance8)
			if not instance8 then
				return nil
			end
			return instance8:FindFirstChild("CustomAttachment") or instance8:FindFirstChildWhichIsA("Attachment")
		end

		local function func153(param95)
			local flag150 = func147(param95)
			local value176 = func152(param95)

			if flag150 ~= "" and value176 then
				mM2VizLearned[flag150] = value176.CFrame
			end
		end

		local function func154(param96, param97, param98)
			if mM2VizOverride[param96] then
				return mM2VizOverride[param96]
			end

			if param97.Model then
				return value173(param97.Model) or cframe
			end
			local flag151 = func144(param97)
			if flag151 ~= "" and mM2VizLearned[flag151] then
				return mM2VizLearned[flag151]
			end
			local str27 = func151(func149(param97))
			return str27 and tbl70[(param97.Meta and param97.Meta.ItemType or param98) .. "_" .. str27] or cframe
		end

		local function func155(part9, obj20)
			local flag152 = func152(part9)
			return part9.CFrame * (flag152 and flag152.CFrame or cframe) * obj20:Inverse()
		end

		local function func156(list35, instance9)
			if instance9:IsA("BasePart") or instance9:IsA("Decal") then
				list35[#list35 + 1] = { inst = instance9, prop = "Transparency", val = instance9.Transparency }

				pcall(function()
					instance9.Transparency = 1
				end)
			elseif instance9:IsA("ParticleEmitter") or instance9:IsA("Trail") or instance9:IsA("Beam") or instance9:IsA("Fire") or instance9:IsA("Smoke") or instance9:IsA("Sparkles") then
				list35[#list35 + 1] = { inst = instance9, prop = "Enabled", val = instance9.Enabled }

				pcall(function()
					instance9.Enabled = false
				end)
			end
		end

		local function func157(list36)
			for _, item42 in ipairs(list36) do
				pcall(function()
					item42.inst[item42.prop] = item42.val
				end)
			end
		end

		local function func158(list37)
			local list38 = {}

			for _, item43 in ipairs(list37) do
				local inst = item43.inst
				local prop = item43.prop

				list38[#list38 + 1] = inst:GetPropertyChangedSignal(prop):Connect(function()
					if prop == "Enabled" then
						if inst.Enabled then
							inst.Enabled = false
						end
					elseif inst.Transparency ~= 1 then
						inst.Transparency = 1
					end
				end)
			end

			return list38
		end

		local function func159(flag153)
			local func160 = ipairs
			local tbl71 = flag153 or {}

			for _, value177 in func160(tbl71) do
				pcall(function()
					value177:Disconnect()
				end)
			end
		end

		local function func161()
			return localPlayer2.Character
		end

		local function func162(str28)
			local result22 = func161()
			if not result22 then
				return nil
			end
			local flag154 = result22:FindFirstChild("DisplayRef" .. str28)
			return flag154 and flag154.Value or nil
		end

		local function func163(param99, flag155)
			local n8 = os.clock() + (flag155 or 1)

			while os.clock() < n8 do
				local value178 = func162(param99)
				if value178 then
					return value178
				end
				task.wait(0.05)
			end

			return func162(param99)
		end

		local tbl72 = {}
		local tbl73 = {}
		local tbl74 = {}
		local value179 = nil

		local function func164(param100, flag156)
			local weaponDisplays = workspace:FindFirstChild("WeaponDisplays")
			if not weaponDisplays then
				return
			end

			for _, child in ipairs(weaponDisplays:GetChildren()) do
				if child ~= flag156 and child:GetAttribute("MM2VizSlot") == param100 then
					pcall(function()
						child:Destroy()
					end)
				end
			end
		end

		local function func165(param101)
			func164(param101)
			local entry9 = tbl72[param101]
			if not entry9 then
				return
			end

			if entry9.chroma then
				pcall(function()
					entry9.chroma:Disconnect()
				end)
			end

			if entry9.overlay then
				pcall(function()
					entry9.overlay:Destroy()
				end)
			end

			func157(entry9.hidden)
			tbl72[param101] = nil
		end

		local function func166(str29, str30)
			if tbl72[str29] and tbl73[str29] == str30 and str30 ~= nil then
				return
			end
			tbl74[str29] = (tbl74[str29] or 0) + 1
			local entry10 = tbl74[str29]
			func165(str29)
			local flag157 = str30 and tbl56[str30]
			if not flag157 then
				tbl73[str29] = str30
				return
			end
			tbl73[str29] = str30
			local obj21 = func162(str29) or func163(str29, 1.5)
			if tbl74[str29] ~= entry10 then
				return
			end

			if not obj21 then
				if value179 then
					value179("No " .. str29 .. " shown — equip a normal " .. str29 .. " first.", Color3.fromRGB(240, 200, 120))
				end

				return
			end

			func153(obj21)
			if func147(obj21) == func144(flag157) and func147(obj21) ~= "" then
				return
			end
			local value180 = func154(str30, flag157, str29)
			local tbl75 = {}
			func156(tbl75, obj21)

			for _, descendant in ipairs(obj21:GetDescendants()) do
				func156(tbl75, descendant)
			end

			local flag158 = func143(flag157)

			if not flag158 or not flag158.root or tbl74[str29] ~= entry10 or not obj21.Parent then
				func157(tbl75)

				if flag158 and flag158.root then
					flag158.root:Destroy()
				end

				return
			end

			func140(flag158, func155(obj21, value180))
			local root = flag158.root
			root:SetAttribute("MM2VizOverlay", true)
			root:SetAttribute("MM2VizSlot", str29)
			root.Parent = obj21.Parent or obj21
			local weldConstraint = Instance.new("WeldConstraint")
			weldConstraint.Part0 = root
			weldConstraint.Part1 = obj21
			weldConstraint.Parent = root
			local value181 = func134(str30, flag157) and func135(root) or nil
			func164(str29, root)
			tbl72[str29] = { overlay = root, hidden = tbl75, chroma = value181 }

			if value179 then
				value179("Showing: " .. str30 .. " (" .. str29 .. ")", Color3.fromRGB(150, 230, 170))
			end
		end

		local tbl76 = { X = Vector3.new(1, 0, 0), Y = Vector3.new(0, 1, 0), Z = Vector3.new(0, 0, 1) }

		local function func167(param102)
			local tbl77 = { { param102.X, "X" }, { param102.Y, "Y" }, { param102.Z, "Z" } }

			table.sort(tbl77, function(tbl78, tbl79)
				return tbl78[1] > tbl79[1]
			end)

			return tbl77[1][2], tbl77[2][2], tbl77[3][2]
		end

		local tbl80 = {
			Gun = { Vector3.new(0, 0, 1), Vector3.new(0, 1, 0), Vector3.new(-1, 0, 0) },
			Knife = { Vector3.new(0, 1, 0), Vector3.new(0, 0, 1), Vector3.new(1, 0, 0) },
		}

		local tbl81 = {
			Harvester = CFrame.Angles(0, 0, -1.5707963267948966),
			Icepiercer = CFrame.Angles(0, 0, -1.5707963267948966),
		}

		local tbl82 = { Sweet = true, SweetChroma = true }
		local tbl83 = { Harvester = 0.5, Icepiercer = 0.5 }

		local function func168(param103, num31, param104, param105)
			if num31 and tbl82[num31] then
				return cframe
			end
			local flag159 = func149(param104)
			local entry11 = tbl80[param105]
			if not (flag159 and entry11) then
				return cframe
			end
			local value182, value183, value184 = func167(flag159)
			local tbl84 = { [value182] = entry11[1], [value183] = entry11[2], [value184] = entry11[3] }

			if tbl76[value182]:Cross(tbl76[value183]):Dot(tbl76[value184]) < 0 then
				tbl84[value184] = -tbl84[value184]
			end

			local x = tbl84.X
			local y = tbl84.Y
			local z = tbl84.Z
			local n8 = param103.Grip.Rotation * CFrame.fromMatrix(Vector3.new(), x, y, z)
			local value185 = num31 and tbl81[num31]

			if value185 then
				n8 *= value185
			end

			num31 = num31 and tbl83[num31]

			if num31 then
				n8 *= CFrame.new(tbl76[value182] * num31)
			end

			return n8
		end

		local function func169(param106, param107)
			local flag160 = func149(param107)
			if not flag160 then
				return cframe
			end
			local value186, value187, value188 = func167(flag160)
			local value189, value190, value191 = func167(param106)
			local tbl85 = { [value186] = tbl76[value189], [value187] = tbl76[value190], [value188] = tbl76[value191] }

			if tbl76[value186]:Cross(tbl76[value187]):Dot(tbl76[value188]) ~= tbl76[value189]:Cross(tbl76[value190]):Dot(tbl76[value191]) then
				tbl85[value188] = -tbl85[value188]
			end

			local x = tbl85.X
			local y = tbl85.Y
			local z = tbl85.Z
			return CFrame.fromMatrix(Vector3.new(), x, y, z)
		end

		local function func170(text4)
			if not text4 then
				return nil
			end
			return text4:match("^(.-)Chroma$") or text4:match("^Chroma(.+)$")
		end

		local function func171(param108, param109)
			local flag161 = func170(param108)
			local meta = flag161 and tbl56[flag161] and tbl56[flag161].Meta or param109.Meta
			if not meta then
				return nil
			end

			if meta.ItemID then
				return ("rbxthumb://type=Asset&w=150&h=150&id=%d"):format(meta.ItemID)
			end
			return meta.Image
		end

		local obj = setmetatable({}, { __mode = "k" })

		local function func172(param110)
			local entry12 = obj[param110]
			if entry12 and entry12.Parent then
				return entry12
			end
			local playerGui = localPlayer2:FindFirstChild("PlayerGui")
			playerGui = playerGui and playerGui:FindFirstChild("BackpackUI")
			playerGui = playerGui and playerGui:FindFirstChild("BackpackFrame")
			if not playerGui then
				return nil
			end

			for _, child in ipairs(playerGui:GetChildren()) do
				local container = child:IsA("GuiObject") and child:FindFirstChild("Container")
				local nameLabel = container and container:FindFirstChild("NameLabel")

				if nameLabel and container:FindFirstChild("ToolIcon") then
					local name = child.Name
					local text = nameLabel.Text
					child.Name = name .. " "
					task.wait()
					local text2 = nameLabel.Text
					child.Name = name
					task.wait()
					nameLabel.Text = text
					if text2 == param110.Name then
						obj[param110] = container
						return container
					end
				end
			end

			return nil
		end

		local function func173(param111, image)
			task.spawn(function()
				local obj22 = func172(param111)
				if not obj22 then
					return
				end
				local toolIcon = obj22:FindFirstChild("ToolIcon")

				if toolIcon then
					toolIcon.Image = image
				end

				local nameLabel = obj22:FindFirstChild("NameLabel")

				if nameLabel then
					nameLabel.Text = image == "" and param111.Name or ""
				end
			end)
		end

		local function func174(param112, textureId)
			if not textureId or textureId == "" then
				return nil
			end
			local textureId2 = param112.TextureId
			param112.TextureId = textureId
			func173(param112, textureId)
			return textureId2
		end

		local function func175(param113, textureId)
			if not textureId then
				return
			end

			pcall(function()
				param113.TextureId = textureId
			end)

			func173(param113, textureId)
		end

		local tbl86 = {
			Harvester = "rbxassetid://7808472682",
			Icepiercer = "rbxassetid://7808472682",
			Raygun = "rbxassetid://92066070356304",
			RaygunChroma = "rbxassetid://92066070356304",
			Snowcannon = "rbxassetid://136161856273464",
			SnowcannonChroma = "rbxassetid://136161856273464",
			Gingerscope = "rbxassetid://74240492893421",
		}

		local mM2VizSounds = _G.__MM2VizSounds or {}
		_G.__MM2VizSounds = mM2VizSounds

		local function func176()
			for _, player in ipairs(Players_:GetPlayers()) do
				for _, item44 in ipairs({ player.Character, player:FindFirstChild("Backpack") }) do
					local func177 = ipairs
					item44 = item44 and item44:GetChildren() or {}

					for _, value192 in func177(item44) do
						local attribute = value192:IsA("Tool") and value192:GetAttribute("ItemID")
						local handle = attribute and value192:FindFirstChild("Handle")
						handle = handle and handle:FindFirstChild("AltSound")

						if handle and handle:IsA("Sound") and handle.SoundId ~= "" and mM2VizSounds[attribute] ~= handle.SoundId then
							mM2VizSounds[attribute] = handle.SoundId
							print(("learned shot sound -- SHOT_SOUND[%q] = %q"):format(attribute, handle.SoundId))
						end
					end
				end
			end
		end

		local function func178(instance10, param114)
			local flag162 = tbl86[param114] or mM2VizSounds[param114]
			local handle = flag162 and instance10:FindFirstChild("Handle")
			handle = handle and handle:FindFirstChild("Gunshot")
			if not (handle and handle:IsA("Sound")) then
				return nil
			end
			local soundId = handle.SoundId
			handle.SoundId = flag162
			return { sound = handle, old = soundId }
		end

		local function func179(flag163)
			if flag163 and flag163.sound then
				pcall(function()
					flag163.sound.SoundId = flag163.old
				end)
			end
		end

		local tbl87 = {}

		local function func180(obj23)
			if obj23:IsDescendantOf(localPlayer2) then
				return true
			end
			local result23 = func161()
			return result23 ~= nil and obj23:IsDescendantOf(result23)
		end

		local function func181(instance11, param115)
			if tbl87[instance11] then
				return
			end
			local handle = instance11:FindFirstChild("Handle") or instance11:WaitForChild("Handle", 5)
			if not handle then
				return
			end
			local flag164 = ProfileData.Weapons.Equipped[param115]
			local flag165 = flag164 and tbl56[flag164]
			if not flag165 then
				return
			end
			func153(handle)
			local flag166 = func143(flag165)
			if not flag166 or not flag166.root then
				return
			end
			local tbl88 = {}
			func156(tbl88, handle)

			for _, descendant in ipairs(handle:GetDescendants()) do
				func156(tbl88, descendant)
			end

			func140(flag166, handle.CFrame * (mM2VizOverrideGrip[flag164] or func168(instance11, flag164, flag165, param115)))
			local root = flag166.root
			root.Parent = handle
			local weldConstraint = Instance.new("WeldConstraint")
			weldConstraint.Part0 = root
			weldConstraint.Part1 = handle
			weldConstraint.Parent = root
			local value193 = func134(flag164, flag165) and func135(root) or nil
			root:SetAttribute("MM2VizOverlay", true)

			tbl87[instance11] = {
				overlay = root,
				hidden = tbl88,
				chroma = value193,
				icon = func174(instance11, func171(flag164, flag165)),
				skin = flag164,
				guards = func158(tbl88),
				shot = func178(instance11, flag164),
			}
		end

		local function func182(flag167)
			local list39 = {}
			local func183 = ipairs
			local value194 = CollectionService_
			local getTagged = value194.GetTagged
			local str31 = flag167 == "Gun" and "Weapon_Gun" or "Weapon_Knife"

			for _, value195 in func183(getTagged(value194, str31)) do
				if func180(value195) then
					list39[#list39 + 1] = value195
				end
			end

			return list39
		end

		local function func184(param116)
			local entry13 = tbl87[param116]
			if not entry13 then
				return
			end

			if entry13.chroma then
				pcall(function()
					entry13.chroma:Disconnect()
				end)
			end

			if entry13.overlay then
				pcall(function()
					entry13.overlay:Destroy()
				end)
			end

			pcall(func175, param116, entry13.icon)
			func179(entry13.shot)
			func159(entry13.guards)
			func157(entry13.hidden)
			tbl87[param116] = nil
		end

		local mM2VizBaseline = _G.__MM2VizBaseline

		if not mM2VizBaseline then
			mM2VizBaseline = {}

			for k, value196 in pairs(ProfileData.Weapons.Owned) do
				mM2VizBaseline[k] = value196
			end

			_G.__MM2VizBaseline = mM2VizBaseline
		end

		local mM2VizBaselineEq = _G.__MM2VizBaselineEq

		if not mM2VizBaselineEq then
			mM2VizBaselineEq = { Knife = ProfileData.Weapons.Equipped.Knife, Gun = ProfileData.Weapons.Equipped.Gun }
			_G.__MM2VizBaselineEq = mM2VizBaselineEq
		end

		local function spawn(param117, flag168)
			local n8 = flag168 or 1
			local owned = ProfileData.Weapons.Owned
			owned[param117] = (owned[param117] or 0) + n8

			pcall(function()
				inventoryDataChanged:Fire("Weapons", param117, owned[param117])
			end)
		end

		local function despawnAll()
			local owned = ProfileData.Weapons.Owned
			local n8 = 0

			for k in pairs(tbl56) do
				local entry14 = mM2VizBaseline[k]

				if owned[k] ~= entry14 then
					owned[k] = entry14

					pcall(function()
						inventoryDataChanged:Fire("Weapons", k, owned[k] or 0)
					end)

					n8 += 1
				end
			end

			for _, item45 in ipairs({ "Knife", "Gun" }) do
				local flag169 = ProfileData.Weapons.Equipped[item45]

				if flag169 and owned[flag169] == nil then
					local entry15 = mM2VizBaselineEq[item45]

					if not (entry15 and owned[entry15]) then
						entry15 = nil

						for k in pairs(owned) do
							local entry16 = weapons[k]
							if type(entry16) == "table" and entry16.ItemType == item45 then
								entry15 = k
								break
							end
						end
					end

					if not entry15 then
						entry15 = item45 == "Knife" and "DefaultKnife" or "DefaultGun"
					end

					ProfileData.Weapons.Equipped[item45] = entry15

					pcall(function()
						EquipService.EquippedChanged:Fire(item45, entry15)
					end)
				end
			end

			return n8
		end

		local list = {}

		for k in pairs(tbl56) do
			local entry17 = weapons[k]

			list[#list + 1] = {
				key = k,
				name = type(entry17) == "table" and entry17.ItemName or k,
				type = type(entry17) == "table" and entry17.ItemType or "",
				rarity = type(entry17) == "table" and entry17.Rarity or "",
				chroma = func134(k, tbl56[k]),
			}
		end

		table.sort(list, function(param118, param119)
			if param118.type ~= param119.type then
				return param118.type < param119.type
			end

			if param118.rarity ~= param119.rarity then
				return param118.rarity < param119.rarity
			end
			return param118.name:lower() < param119.name:lower()
		end)

		local value197 = nil
		local screenGui = Instance.new("ScreenGui")
		screenGui.Name = "MM2Spawner"
		screenGui.ResetOnSpawn = false
		screenGui.IgnoreGuiInset = true
		screenGui.DisplayOrder = 999999

		pcall(function()
			screenGui.Parent = gethui and gethui() or game:GetService("CoreGui")
		end)

		if not screenGui.Parent then
			screenGui.Parent = localPlayer2:WaitForChild("PlayerGui")
		end

		mM2Viz.gui = screenGui
		local frame = Instance.new("Frame")
		frame.Size = UDim2.fromOffset(290, 420)
		frame.Position = UDim2.new(0, 20, 0.5, -210)
		frame.BackgroundColor3 = Color3.fromRGB(20, 20, 27)
		frame.BorderSizePixel = 0
		frame.Active = true
		frame.Draggable = true
		frame.Parent = screenGui
		Instance.new("UICorner", frame).CornerRadius = UDim.new(0, 10)
		local uiStroke = Instance.new("UIStroke", frame)
		uiStroke.Color = Color3.fromRGB(120, 90, 230)
		uiStroke.Thickness = 1.5
		local textButton = Instance.new("TextButton")
		textButton.Size = UDim2.new(0.5, -14, 0, 26)
		textButton.Position = UDim2.fromOffset(12, 10)
		textButton.BackgroundColor3 = Color3.fromRGB(60, 95, 70)
		textButton.BorderSizePixel = 0
		textButton.Font = Enum.Font.GothamBold
		textButton.TextSize = 12
		textButton.TextColor3 = Color3.fromRGB(200, 255, 215)
		textButton.Text = "Spawn all"
		textButton.Parent = frame
		Instance.new("UICorner", textButton).CornerRadius = UDim.new(0, 6)
		local textButton2 = Instance.new("TextButton")
		textButton2.Size = UDim2.new(0.5, -14, 0, 26)
		textButton2.Position = UDim2.new(0.5, 2, 0, 10)
		textButton2.BackgroundColor3 = Color3.fromRGB(95, 60, 70)
		textButton2.BorderSizePixel = 0
		textButton2.Font = Enum.Font.GothamBold
		textButton2.TextSize = 12
		textButton2.TextColor3 = Color3.fromRGB(255, 205, 215)
		textButton2.Text = "Despawn all"
		textButton2.Parent = frame
		Instance.new("UICorner", textButton2).CornerRadius = UDim.new(0, 6)
		local scrollingFrame = Instance.new("ScrollingFrame")
		scrollingFrame.Size = UDim2.new(1, -20, 1, -56)
		scrollingFrame.Position = UDim2.fromOffset(10, 46)
		scrollingFrame.BackgroundColor3 = Color3.fromRGB(14, 14, 19)
		scrollingFrame.BackgroundTransparency = 0.3
		scrollingFrame.BorderSizePixel = 0
		scrollingFrame.ScrollBarThickness = 6
		scrollingFrame.ScrollBarImageColor3 = Color3.fromRGB(120, 90, 230)
		scrollingFrame.CanvasSize = UDim2.new(0, 0, 0, 0)
		scrollingFrame.AutomaticCanvasSize = Enum.AutomaticSize.Y
		scrollingFrame.Parent = frame
		Instance.new("UICorner", scrollingFrame).CornerRadius = UDim.new(0, 6)
		local uiListLayout = Instance.new("UIListLayout")
		uiListLayout.Padding = UDim.new(0, 2)
		uiListLayout.SortOrder = Enum.SortOrder.LayoutOrder
		uiListLayout.Parent = scrollingFrame
		local uiPadding = Instance.new("UIPadding")
		uiPadding.PaddingTop = UDim.new(0, 3)
		uiPadding.PaddingBottom = UDim.new(0, 3)
		uiPadding.PaddingLeft = UDim.new(0, 3)
		uiPadding.PaddingRight = UDim.new(0, 3)
		uiPadding.Parent = scrollingFrame

		local function func185()
		end

		local tbl89 = { Godly = Color3.fromRGB(255, 110, 190), Ancient = Color3.fromRGB(165, 95, 245) }
		local flag170 = false
		local list40 = {}

		local function func186()
			if flag170 then
				return
			end
			flag170 = true

			task.spawn(function()
				for i, item46 in ipairs(list) do
					local textButton3 = Instance.new("TextButton")
					textButton3.Size = UDim2.new(1, -6, 0, 24)
					textButton3.BackgroundColor3 = item46.type == "Knife" and Color3.fromRGB(48, 44, 70) or Color3.fromRGB(44, 56, 72)
					textButton3.BackgroundTransparency = 0.25
					textButton3.Font = Enum.Font.Gotham
					textButton3.TextSize = 12
					textButton3.TextColor3 = Color3.fromRGB(235, 235, 245)
					textButton3.TextXAlignment = Enum.TextXAlignment.Left
					textButton3.TextTruncate = Enum.TextTruncate.AtEnd
					textButton3.Text = "  " .. item46.name .. (item46.chroma and "  [Chroma]" or "") .. "   -  " .. item46.rarity .. " " .. item46.type
					textButton3.LayoutOrder = i
					textButton3.Parent = scrollingFrame
					Instance.new("UICorner", textButton3).CornerRadius = UDim.new(0, 4)
					local uiStroke2 = Instance.new("UIStroke", textButton3)
					uiStroke2.Color = tbl89[item46.rarity] or Color3.fromRGB(90, 90, 110)
					uiStroke2.Thickness = 1.4
					uiStroke2.ApplyStrokeMode = Enum.ApplyStrokeMode.Border
					local key = item46.key

					textButton3.MouseButton1Click:Connect(function()
						spawn(key, 1)
						func185(key)
						local backgroundColor3 = textButton3.BackgroundColor3
						textButton3.BackgroundColor3 = Color3.fromRGB(0, 150, 100)

						task.delay(0.18, function()
							if textButton3.Parent then
								textButton3.BackgroundColor3 = backgroundColor3
							end
						end)
					end)

					list40[#list40 + 1] = { btn = textButton3, hay = (item46.key .. " " .. item46.name):lower() }

					if i % 60 == 0 then
						task.wait()
					end
				end
			end)
		end

		func186()

		textButton.MouseButton1Click:Connect(function()
			if textButton.Text ~= "Spawn all" then
				return
			end
			textButton.Text = "..."

			task.spawn(function()
				for i, item47 in ipairs(list) do
					spawn(item47.key, 1)

					if i % 25 == 0 then
						task.wait()
					end
				end

				textButton.Text = "Spawn all"
			end)
		end)

		textButton2.MouseButton1Click:Connect(function()
			if textButton2.Text ~= "Despawn all" then
				return
			end
			textButton2.Text = "..."

			task.spawn(function()
				despawnAll()
				textButton2.Text = "Despawn all"
			end)
		end)

		value179 = function(text, textColor3)
			if value197 then
				value197.Text = text
				value197.TextColor3 = textColor3 or Color3.fromRGB(190, 190, 205)
			end
		end

		local tbl90 = { Knife = nil, Gun = nil }

		pcall(function()
			tbl90.Knife = ProfileData.Weapons.Equipped.Knife
			tbl90.Gun = ProfileData.Weapons.Equipped.Gun
		end)

		task.spawn(function()
			for _, item48 in ipairs({ "Knife", "Gun" }) do
				local value198 = ProfileData.Weapons.Equipped[item48]

				if value198 then
					task.spawn(function()
						func166(item48, value198)
					end)
				end
			end

			while _G.__MM2Viz == mM2Viz do
				for _, item49 in ipairs({ "Knife", "Gun" }) do
					local value199 = nil

					pcall(function()
						value199 = ProfileData.Weapons.Equipped[item49]
					end)

					if value199 ~= tbl90[item49] then
						tbl90[item49] = value199
						local value200 = value199

						task.spawn(function()
							func166(item49, value200)
						end)

						for _, item50 in ipairs(func182(item49)) do
							task.spawn(function()
								func184(item50)
								func181(item50, item49)
							end)
						end
					end
				end

				task.wait(0.1)
			end
		end)

		local connection6 = EquipService.EquippedChanged.Event:Connect(function(flag171, param120)
			if flag171 == "Knife" or flag171 == "Gun" then
				tbl90[flag171] = param120

				task.spawn(function()
					func166(flag171, param120)
				end)
			end
		end)

		table.insert(mM2Viz.conns, connection6)

		local function func187(param121)
			local connection7 = param121.ChildAdded:Connect(function(child)
				local name = child.Name

				if name == "DisplayRefKnife" or name == "DisplayRefGun" then
					local str32 = name == "DisplayRefKnife" and "Knife" or "Gun"

					task.delay(0.2, function()
						local value201 = tbl72[str32] and tbl73[str32]

						if value201 then
							tbl72[str32] = nil
							func166(str32, value201)
						end
					end)
				end
			end)

			table.insert(mM2Viz.conns, connection7)
		end

		if func161() then
			local result24 = func161()
			func187(result24)
		end

		local connection7 = localPlayer2.CharacterAdded:Connect(function(character)
			for _, item51 in ipairs({ "Knife", "Gun" }) do
				local entry18 = tbl72[item51]

				if entry18 and entry18.overlay then
					pcall(function()
						entry18.overlay:Destroy()
					end)
				end
			end

			tbl72 = {}
			func187(character)

			task.delay(1, function()
				for _, item52 in ipairs({ "Knife", "Gun" }) do
					if tbl73[item52] then
						func166(item52, tbl73[item52])
					end
				end
			end)
		end)

		table.insert(mM2Viz.conns, connection7)

		for _, item53 in ipairs({ "Weapon_Knife", "Weapon_Gun" }) do
			local str33 = item53 == "Weapon_Gun" and "Gun" or "Knife"

			for _, item54 in ipairs(CollectionService_:GetTagged(item53)) do
				if func180(item54) then
					task.spawn(function()
						func181(item54, str33)
					end)
				end
			end

			table.insert(mM2Viz.conns, CollectionService_:GetInstanceAddedSignal(item53):Connect(function(param122)
				if func180(param122) then
					task.spawn(function()
						func181(param122, str33)
					end)
				end
			end))

			table.insert(mM2Viz.conns, CollectionService_:GetInstanceRemovedSignal(item53):Connect(function(param123)
				func184(param123)
			end))
		end

		local function func188(obj24)
			local knifeVisual = obj24:WaitForChild("KnifeVisual", 5)
			if not knifeVisual then
				return
			end
			local value202 = nil

			for _, descendant in ipairs(knifeVisual:GetDescendants()) do
				if descendant:GetAttribute("MM2VizOverlay") then
					value202 = descendant
					break
				else
					value202 = nil
				end
			end

			if not value202 then
				return
			end
			local tbl91 = {}
			func156(tbl91, knifeVisual)

			for _, descendant in ipairs(knifeVisual:GetDescendants()) do
				if descendant ~= value202 and not descendant:IsDescendantOf(value202) then
					func156(tbl91, descendant)
				end
			end
		end

		table.insert(mM2Viz.conns, CollectionService_:GetInstanceAddedSignal("ThrowingKnife"):Connect(function(param124)
			task.spawn(func188, param124)
		end))

		local tbl92 = {}

		local function func189()
			local result25 = func161()

			for _, item55 in ipairs(CollectionService_:GetTagged("Weapon_Knife")) do
				if item55:IsDescendantOf(localPlayer2) or result25 and item55:IsDescendantOf(result25) then
					return true
				end
			end

			return false
		end

		local function func190(param125)
			local entry19 = tbl92[param125]
			if not entry19 then
				return
			end
			tbl92[param125] = nil

			if entry19.chroma then
				pcall(function()
					entry19.chroma:Disconnect()
				end)
			end

			func159(entry19.guards)

			if entry19.overlay then
				pcall(function()
					entry19.overlay:Destroy()
				end)
			end
		end

		local function func191(parent)
			if tbl92[parent] or not func189() then
				return
			end
			local knife = ProfileData.Weapons.Equipped.Knife
			local flag172 = knife and tbl56[knife]
			if not flag172 then
				return
			end
			tbl92[parent] = {}
			local flag173 = func143(flag172)

			if not flag173 or not flag173.root or not parent.Parent then
				if flag173 and flag173.root then
					flag173.root:Destroy()
				end

				tbl92[parent] = nil
				return
			end

			local tbl93 = {}
			func156(tbl93, parent)

			for _, descendant in ipairs(parent:GetDescendants()) do
				func156(tbl93, descendant)
			end

			func140(flag173, parent.CFrame * func169(parent.Size, flag172))
			local root = flag173.root
			root.Parent = parent
			local weldConstraint = Instance.new("WeldConstraint")
			weldConstraint.Part0 = root
			weldConstraint.Part1 = parent
			weldConstraint.Parent = root
			tbl92[parent] = { overlay = root, chroma = func134(knife, flag172) and func135(root) or nil, guards = func158(tbl93) }

			parent.Destroying:Once(function()
				func190(parent)
			end)
		end

		local function func192(child)
			if child:IsA("BasePart") and child.Name == "StuckKnife" then
				task.spawn(func191, child)
			end
		end

		for _, child in ipairs(workspace:GetChildren()) do
			func192(child)
		end

		table.insert(mM2Viz.conns, workspace.ChildAdded:Connect(func192))

		task.spawn(function()
			while _G.__MM2Viz == mM2Viz do
				pcall(func176)
				task.wait(2)
			end
		end)

		mM2Viz.tune = function(param126, flag174, flag175, flag176)
			local entry20 = tbl73[param126]
			local flag177 = entry20 and tbl56[entry20]
			if not flag177 then
				warn("nothing applied on " .. tostring(param126))
				return
			end
			local n8 = (mM2VizOverride[entry20] or func154(entry20, flag177, param126)) * CFrame.Angles(flag174 or 0, flag175 or 0, flag176 or 0)
			mM2VizOverride[entry20] = n8
			local tbl94 = { n8:GetComponents() }

			for i, item56 in ipairs(tbl94) do
				tbl94[i] = string.format("%.5f", item56)
			end

			print(("OVERRIDE[%q] = CFrame.new(%s)"):format(entry20, table.concat(tbl94, ", ")))

			task.spawn(function()
				tbl73[param126] = nil
				func166(param126, entry20)
			end)
		end

		mM2Viz.tuneGrip = function(param127, flag178, flag179, flag180)
			local value203 = nil

			for k in pairs(tbl87) do
				if (CollectionService_:HasTag(k, "Weapon_Gun") and "Gun" or "Knife") == param127 then
					value203 = k
				end
			end

			local flag181 = value203 and tbl87[value203]
			local flag182 = flag181 and tbl56[flag181.skin]
			if not flag182 then
				warn("not holding a " .. tostring(param127))
				return
			end
			local n8 = (mM2VizOverrideGrip[flag181.skin] or func168(value203, flag181.skin, flag182, param127)) * CFrame.Angles(flag178 or 0, flag179 or 0, flag180 or 0)
			mM2VizOverrideGrip[flag181.skin] = n8
			local tbl95 = { n8:GetComponents() }

			for i, item57 in ipairs(tbl95) do
				tbl95[i] = string.format("%.5f", item57)
			end

			print(("OVERRIDE_GRIP[%q] = CFrame.new(%s)"):format(flag181.skin, table.concat(tbl95, ", ")))

			task.spawn(function()
				func184(value203)
				func181(value203, param127)
			end)
		end

		mM2Viz.nudge = function(param128, flag183)
			local value204 = nil

			for k in pairs(tbl87) do
				if (CollectionService_:HasTag(k, "Weapon_Gun") and "Gun" or "Knife") == param128 then
					value204 = k
				end
			end

			local flag184 = value204 and tbl87[value204]
			if not flag184 then
				warn("not holding a " .. tostring(param128))
				return
			end
			tbl83[flag184.skin] = (tbl83[flag184.skin] or 0) + (flag183 or 0)
			print(("GRIP_NUDGE[%q] = %.2f"):format(flag184.skin, tbl83[flag184.skin]))

			task.spawn(function()
				func184(value204)
				func181(value204, param128)
			end)
		end

		mM2Viz.spawn = spawn
		mM2Viz.despawnAll = despawnAll
		mM2Viz.list = list

		mM2Viz.icon = function(param129)
			local entry21 = tbl56[param129]
			return entry21 and func171(param129, entry21) or nil
		end

		mM2Viz.destroy = function()
			for _, conn in ipairs(mM2Viz.conns) do
				pcall(function()
					conn:Disconnect()
				end)
			end

			for k in pairs(tbl72) do
				pcall(func165, k)
			end

			for k in pairs(tbl87) do
				pcall(func184, k)
			end

			for k in pairs(tbl92) do
				pcall(func190, k)
			end

			if mM2Viz.gui then
				pcall(function()
					mM2Viz.gui:Destroy()
				end)
			end
		end

		value179(("Ready — %d weapons (%d full). Spawn + equip; works in-round too."):format(n5, n6))
		return _G.__MM2Viz
	end

	tbl43.skins:Paragraph({
		Title = "Visual Skin Changer — ONLY YOU CAN SEE THIS!",
		Desc = "Beta - expect the odd bug while holding items. Report them in our YouTube comments.",
	})

	local value205 = nil
	local weapons = nil

	tbl43.skins:Button({
		Title = "Spawn all visual skins",
		Callback = function()
			if not value205 then
				obj2:Notify({
					Title = "Skins",
					Content = "Still loading, try again in a second.",
					Duration = 2,
					Icon = "loader",
				})

				return
			end

			task.spawn(function()
				for _, item58 in ipairs(value205.list) do
					pcall(value205.spawn, item58.key, 1)
				end

				obj2:Notify({ Title = "Skins", Content = ("Spawned %d skins."):format(#value205.list), Duration = 2, Icon = "check" })
			end)
		end,
	})

	tbl43.skins:Button({
		Title = "Despawn all visual skins",
		Callback = function()
			if not value205 then
				return
			end
			pcall(value205.despawnAll)
			obj2:Notify({ Title = "Skins", Content = "Despawned.", Duration = 2, Icon = "check" })
		end,
	})

	local color2 = Color3.fromRGB
	func118("Spawn all visual skins", Color3.fromHex("#D9D9E0"), 0.25, color2(24, 24, 27))
	local color3 = Color3.fromRGB
	func118("Despawn all visual skins", Color3.fromHex("#2A2A32"), 0.25, color3(187, 247, 208))
	local obj25 = tbl43.skins:Paragraph({ Title = "Skins", Desc = "Loading…" })
	local list41 = {}

	local function func193()
		local flag185 = func119(obj25)
		if not flag185 then
			warn("[FVL] couldn't reach the Paragraph container - skin grid skipped")
			return
		end
		local frame = Instance.new("Frame")
		frame.Name = "FVLSkinSearch"
		frame.LayoutOrder = -1
		frame.Size = UDim2.new(1, 0, 0, 30)
		frame.BackgroundColor3 = Color3.fromRGB(10, 10, 13)
		frame.BackgroundTransparency = 0.25
		frame.BorderSizePixel = 0
		frame.Parent = flag185
		Instance.new("UICorner", frame).CornerRadius = UDim.new(0, 8)
		local textBox = Instance.new("TextBox")
		textBox.BackgroundTransparency = 1
		textBox.Size = UDim2.new(1, -18, 1, 0)
		textBox.Position = UDim2.fromOffset(9, 0)
		textBox.Font = Enum.Font.Gotham
		textBox.TextSize = 12
		textBox.TextXAlignment = Enum.TextXAlignment.Left
		textBox.TextColor3 = Color3.fromRGB(230, 230, 240)
		textBox.PlaceholderText = "Search skins..."
		textBox.PlaceholderColor3 = Color3.fromRGB(120, 120, 135)
		textBox.ClearTextOnFocus = false
		textBox.Text = ""
		textBox.Parent = frame
		local frame2 = Instance.new("Frame")
		frame2.Name = "FVLSkinGrid"
		frame2.LayoutOrder = 0
		frame2.BackgroundTransparency = 1
		frame2.Parent = flag185
		local uiGridLayout = Instance.new("UIGridLayout")
		uiGridLayout.CellSize = UDim2.fromOffset(84, 84)
		uiGridLayout.CellPadding = UDim2.fromOffset(6, 6)
		uiGridLayout.SortOrder = Enum.SortOrder.LayoutOrder
		uiGridLayout.HorizontalAlignment = Enum.HorizontalAlignment.Center
		uiGridLayout.Parent = frame2

		local function func194()
			frame2.Size = UDim2.new(1, 0, 0, uiGridLayout.AbsoluteContentSize.Y)
		end

		uiGridLayout:GetPropertyChangedSignal("AbsoluteContentSize"):Connect(func194)
		func194()
		local clone = nil

		pcall(function()
			local playerGui = localPlayer:FindFirstChild("PlayerGui")
			if not playerGui then
				return
			end

			for _, descendant in ipairs(playerGui:GetDescendants()) do
				if descendant:IsA("Frame") and descendant.Name == "Chroma" and descendant:FindFirstChild("BG") then
					clone = descendant:Clone()
					break
				end
			end
		end)

		local tbl96 = { Godly = Color3.fromRGB(255, 110, 190), Ancient = Color3.fromRGB(165, 95, 245) }

		local function func195(param130)
			local value206 = weapons and weapons[param130]

			if value206 then
				local image = type(value206.Image) == "string" and value206.Image or nil
				local pos

				if image then
					pos = image:find("rbxassetid") or image:find("rbxthumb")
				else
					pos = image
				end

				if pos then
					return image
				end

				if image then
					local match = image:match("[Aa]sset[Ii][Dd]=(%d+)") or image:match("[?&]id=(%d+)")
					if match then
						return "rbxthumb://type=Asset&w=150&h=150&id=" .. match
					end
				end

				if tonumber(value206.ItemID) then
					return ("rbxthumb://type=Asset&w=150&h=150&id=%s"):format(tostring(value206.ItemID))
				end
			end

			return value205.icon(param130) or ""
		end

		local tbl97 = { Ancient = 1, Godly = 2 }
		local list42 = {}

		for _, item59 in ipairs(value205.list) do
			list42[#list42 + 1] = item59
		end

		table.sort(list42, function(param131, param132)
			local n4 = tbl97[param131.rarity] or 3
			local n5 = tbl97[param132.rarity] or 3
			if n4 ~= n5 then
				return n4 < n5
			end
			return param131.name:lower() < param132.name:lower()
		end)

		for i, item60 in ipairs(list42) do
			local textButton = Instance.new("TextButton")
			textButton.Name = item60.key
			textButton.LayoutOrder = i
			textButton.Text = ""
			textButton.AutoButtonColor = false
			textButton.BackgroundColor3 = Color3.fromRGB(10, 10, 13)
			textButton.BackgroundTransparency = 0.25
			textButton.BorderSizePixel = 0
			textButton.Parent = frame2
			Instance.new("UICorner", textButton).CornerRadius = UDim.new(0, 10)
			local uiStroke = Instance.new("UIStroke")
			uiStroke.Thickness = 1.5
			uiStroke.ApplyStrokeMode = Enum.ApplyStrokeMode.Border
			uiStroke.Color = tbl96[item60.rarity] or Color3.fromRGB(255, 255, 255)
			uiStroke.Transparency = 0.55
			uiStroke.Parent = textButton
			local imageLabel = Instance.new("ImageLabel")
			imageLabel.BackgroundTransparency = 1
			imageLabel.AnchorPoint = Vector2.new(0.5, 0)
			imageLabel.Position = UDim2.new(0.5, 0, 0, 5)
			imageLabel.Size = UDim2.fromOffset(56, 56)
			imageLabel.Image = func195(item60.key)
			imageLabel.ScaleType = Enum.ScaleType.Fit
			imageLabel.Parent = textButton
			local textLabel = Instance.new("TextLabel")
			textLabel.BackgroundTransparency = 1
			textLabel.AnchorPoint = Vector2.new(0.5, 1)
			textLabel.Position = UDim2.new(0.5, 0, 1, -4)
			textLabel.Size = UDim2.new(1, -6, 0, 18)
			textLabel.Font = Enum.Font.GothamBold
			textLabel.TextSize = 10
			textLabel.TextWrapped = true
			textLabel.TextColor3 = Color3.fromRGB(200, 200, 210)
			textLabel.Text = item60.name
			textLabel.Parent = textButton

			if item60.chroma then
				local clone2

				if clone then
					clone2 = clone:Clone()
					clone2.Visible = true
					clone2.AnchorPoint = Vector2.new(0, 1)
					clone2.Position = UDim2.new(0, 3, 0, 61)
					clone2.Size = UDim2.fromOffset(36, 11)
					local tagName = clone2:FindFirstChild("TagName")

					if tagName and tagName:IsA("TextLabel") then
						tagName.TextSize = 9
					end
				else
					clone2 = Instance.new("TextLabel")
					clone2.BackgroundTransparency = 0.3
					clone2.BackgroundColor3 = Color3.fromRGB(0, 0, 0)
					clone2.AnchorPoint = Vector2.new(0, 1)
					clone2.Position = UDim2.new(0, 3, 0, 61)
					clone2.Size = UDim2.fromOffset(36, 11)
					clone2.Font = Enum.Font.SourceSansBold
					clone2.TextSize = 9
					clone2.TextColor3 = Color3.fromRGB(255, 255, 255)
					clone2.Text = "Chroma"
					Instance.new("UICorner", clone2).CornerRadius = UDim.new(0, 4)
				end

				clone2.Name = "ChromaTag"
				clone2.ZIndex = 5

				for _, descendant in ipairs(clone2:GetDescendants()) do
					if descendant:IsA("GuiObject") then
						descendant.ZIndex = 5
					end
				end

				clone2.Parent = textButton
			end

			textButton.MouseButton1Click:Connect(function()
				local ok = pcall(value205.spawn, item60.key, 1)

				obj2:Notify({
					Title = ok and "Spawned" or "Failed",
					Content = ok and item60.name .. " — equip it from your inventory." or "Couldn't spawn " .. item60.name,
					Duration = 2,
					Icon = ok and "check" or "x",
				})
			end)

			list41[#list41 + 1] = { tile = textButton, search = item60.name:lower() }
		end

		textBox:GetPropertyChangedSignal("Text"):Connect(function()
			local flag186 = textBox.Text:lower()

			for _, item61 in ipairs(list41) do
				item61.tile.Visible = flag186 == "" or item61.search:find(flag186, 1, true) ~= nil
			end
		end)

		obj25:SetDesc(("%d skins — click one to add it, then equip it normally."):format(#value205.list))

		task.spawn(function()
			local list43 = {}

			for _, item62 in ipairs(list41) do
				local imageLabel = item62.tile:FindFirstChildWhichIsA("ImageLabel")

				if imageLabel then
					list43[#list43 + 1] = imageLabel
				end
			end

			pcall(function()
				game:GetService("ContentProvider"):PreloadAsync(list43)
			end)
		end)
	end

	task.spawn(function()
		local flag187 = getthreadidentity and getthreadidentity() or nil
		local ok, result = pcall(func127)

		pcall(function()
			weapons = require(game:GetService("ReplicatedStorage").Database.Sync).Weapons
		end)

		if flag187 and setthreadidentity then
			pcall(setthreadidentity, flag187)
		end

		if not ok or not result then
			pcall(function()
				obj25:SetDesc("Couldn't load skins: " .. tostring(result):sub(1, 120))
			end)

			return
		end

		value205 = result

		pcall(function()
			if value205.gui then
				value205.gui.Enabled = false
			end
		end)

		func193()
	end)

	tbl43.combat:Section({ Title = "Misc" })

	tbl43.combat:Toggle({
		Title = "Auto Grab Gun",
		Flag = "Toggle_Auto_Grab_Gun",
		Desc = "Picks up the dropped gun for you.",
		Type = "Toggle",
		Value = false,
		Callback = function(value)
			if value then
				func70()
			else
				func69()
			end
		end,
	})

	tbl43.combat:Toggle({
		Title = "Wall Check",
		Flag = "Toggle_Wall_Check",
		Desc = "Only act when you can actually see the target. Covers Silent Aim, Triggerbot and the on-screen buttons.",
		Type = "Toggle",
		Value = false,
		Callback = function(value)
			flag78 = value
		end,
	})

	tbl43.combat:Toggle({
		Title = "Wallbang",
		Flag = "Toggle_Wallbang",
		Desc = "Shoots through walls. Skips the wall check and fires from inside the target's hitbox. Covers Shoot Murderer, Silent Aim and Triggerbot.",
		Type = "Toggle",
		Value = false,
		Callback = function(value)
			list2.wallbang = value
		end,
	})

	list2.gunEls = {}
	list2.knifeEls = {}
	tbl43.combat:Section({ Title = "Sheriff — you have the gun" })

	list2.el.silentaim = tbl43.combat:Toggle({
		Title = "Silent Aim",
		Flag = "Toggle_Silent_Aim",
		Desc = "Bends your shots to the murderer when you click. Needs the gun, and the aimbot turns it on too.",
		Type = "Toggle",
		Value = false,
		Callback = function(aimOn)
			flag81.aimOn = aimOn

			if aimOn then
				func74()
			else
				func75()
			end
		end,
	})

	list2.gunEls[#list2.gunEls + 1] = list2.el.silentaim

	list2.gunEls[#list2.gunEls + 1] = tbl43.combat:Toggle({
		Title = "Triggerbot",
		Flag = "Toggle_Triggerbot",
		Desc = "Fires by itself when the murderer crosses your crosshair. Sheriff only.",
		Type = "Toggle",
		Value = false,
		Callback = function(enabled)
			flag82.enabled = enabled

			if enabled then
				flag82.start()
			else
				flag82.stop()
			end
		end,
	})

	tbl43.combat:Section({ Title = "Murderer — you have the knife" })
	local n4 = 0

	UserInputService.InputBegan:Connect(function()
		n4 = os.clock()
	end)

	local function func196()
		return os.clock() - n4 < 1
	end

	num17.on = true
	num17.start()

	list2.knifeEls[#list2.knifeEls + 1] = tbl43.combat:Slider({
		Title = "Change Knife Hitbox  (OP!)",
		Flag = "Slider_Change_Knife_Hitbox",
		Desc = "Change the size of your Knife! (1 is default hitbox)",
		Step = 1,
		Value = { Min = 1, Max = 200, Default = 1 },
		Callback = function(value)
			local num32 = tonumber(value) or type(value) == "table" and tonumber(value.Value)

			if num32 then
				num17.setMult(num32)
			end
		end,
	})

	list2.knifeEls[#list2.knifeEls + 1] = tbl43.combat:Toggle({
		Title = "Show Hitbox",
		Flag = "Toggle_Show_Hitbox",
		Desc = "Draws the reach as a sphere.",
		Type = "Toggle",
		Value = false,
		Callback = function(show)
			if not func196() then
				return
			end
			num17.show = show

			if show then
				num17.showBall()
			else
				num17.hideBall()
			end
		end,
	})

	list2.knifeEls[#list2.knifeEls + 1] = tbl43.combat:Toggle({
		Title = "Silent Throw",
		Flag = "Toggle_Silent_Throw",
		Desc = "Right click throws the knife at the nearest player. Murderer only.",
		Type = "Toggle",
		Value = false,
		Callback = function(on)
			flag83.on = on

			if on then
				flag83.start()
			else
				flag83.stop()
			end
		end,
	})

	killTargetDropdown = tbl43.combat:Dropdown({
		Title = "Target",
		Desc = "Pick who to stab, then use the button below.",
		Multi = false,
		Value = nil,
		Values = func121(),
		Callback = function(value)
			selectedKillTarget = value
		end,
	})
end

list2.knifeEls[#list2.knifeEls + 1] = killTargetDropdown

list2.knifeEls[#list2.knifeEls + 1] = tbl43.combat:Button({
	Title = "Kill Target",
	Desc = "Instantly stabs the player picked above.",
	Callback = function()
		func76(selectedKillTarget)
	end,
})

list2.knifeEls[#list2.knifeEls + 1] = tbl43.combat:Button({
	Title = "Kill All",
	Desc = "Instantly stabs every player in the server.",
	Callback = function()
		func77()
	end,
})

func118("Kill All", Color3.fromHex("#7F1D1D"), 0.25)
func120(ICON.mono)
func118("Change Knife Hitbox  (OP!)", Color3.fromHex("#7F1D1D"), 0.25)

list2.perf = {
	LIGHTING = game:GetService("Lighting"),
	UNCAPPED = 999,
	on = {
		textures = false,
		effects = false,
		weaponfx = false,
		pets = false,
		anims = false,
		lighting = false,
		terrain = false,
		sounds = false,
		quality = false,
		fpsCounter = false,
	},
	el = {},
	stash = {
		parent = {},
		part = {},
		texid = {},
		volume = {},
		enabled = {},
		post = {},
		light = nil,
		terrain = nil,
		quality = nil,
	},
	animConns = {},
	watchConn = nil,
	playerConn = nil,
	owner = {},
}

list2.perf.ours = function(obj)
	while obj do
		if obj.Name:sub(1, 3) == "FVL" then
			return true
		end
		obj = obj.Parent
	end

	return false
end

list2.perf.FX = {
	ParticleEmitter = true,
	Trail = true,
	Smoke = true,
	Fire = true,
	Sparkles = true,
	Beam = true,
	Explosion = true,
	PointLight = true,
	SpotLight = true,
	SurfaceLight = true,
}

list2.perf.reparent = function(obj, parent)
	obj.Parent = parent
end

list2.perf.restorePart = function(obj, tbl98)
	local second4 = tbl98[2]
	local third1 = tbl98[3]
	obj.Material = tbl98[1]
	obj.CastShadow = second4
	obj.Reflectance = third1
end

list2.perf.CHUNK = 75
list2.perf.sweeping = false

list2.perf.breathe = function(num33)
	if num33 % list2.perf.CHUNK == 0 then
		task.wait()
	end
end

list2.perf.keysOf = function(param133)
	local tbl99 = {}
	local n4 = 0

	for k in next, param133, nil do
		n4 += 1
		tbl99[n4] = k
	end

	return tbl99, n4
end

list2.perf.readProp = function(tbl100, param134)
	return tbl100[param134]
end

list2.perf.TERRAIN = {
	{ "Decoration", false },
	{ "WaterWaveSize", 0 },
	{ "WaterWaveSpeed", 0 },
	{ "WaterReflectance", 0 },
	{ "WaterTransparency", 1 },
}

list2.perf.setProp = function(tbl101, param135, param136)
	tbl101[param135] = param136
end

list2.perf.detach = function(obj, param137)
	if list2.perf.stash.parent[obj] ~= nil then
		return
	end
	local parent = obj.Parent
	if not parent then
		return
	end
	list2.perf.stash.parent[obj] = parent
	list2.perf.owner[obj] = param137
	pcall(list2.perf.reparent, obj, nil)
end

list2.perf.stripTexture = function(obj)
	if obj:IsA("Decal") or obj:IsA("Texture") or obj:IsA("SurfaceAppearance") then
		list2.perf.detach(obj, "textures")
	elseif obj:IsA("SpecialMesh") then
		if list2.perf.stash.texid[obj] == nil and obj.TextureId ~= "" then
			list2.perf.stash.texid[obj] = obj.TextureId
			pcall(list2.perf.setProp, obj, "TextureId", "")
		end
	elseif obj:IsA("BasePart") and not obj:IsA("Terrain") then
		if list2.perf.stash.part[obj] == nil then
			list2.perf.stash.part[obj] = { obj.Material, obj.CastShadow, obj.Reflectance }
			obj.Material = Enum.Material.SmoothPlastic
			obj.CastShadow = false
			obj.Reflectance = 0
		end
	end
end

list2.perf.clearEmitter = function(obj26)
	obj26:Clear()
end

list2.perf.killFX = function(obj, param138)
	if obj:IsA("ParticleEmitter") then
		if list2.perf.stash.enabled[obj] == nil then
			list2.perf.stash.enabled[obj] = obj.Enabled
		end

		obj.Enabled = false
		pcall(list2.perf.clearEmitter, obj)
	end

	list2.perf.detach(obj, param138)
end

list2.perf.stripEffect = function(obj)
	if list2.perf.FX[obj.ClassName] then
		list2.perf.killFX(obj, "effects")
	end
end

list2.perf.stripWeaponFX = function(list44)
	for _, descendant in ipairs(list44:GetDescendants()) do
		if list2.perf.FX[descendant.ClassName] then
			list2.perf.killFX(descendant, "weaponfx")
		end
	end
end

list2.perf.stripSound = function(obj)
	if obj:IsA("Sound") and list2.perf.stash.volume[obj] == nil then
		list2.perf.stash.volume[obj] = obj.Volume
		pcall(list2.perf.setProp, obj, "Volume", 0)
	end
end

list2.perf.hookAnimator = function(obj)
	if list2.perf.animConns[obj] then
		return
	end

	pcall(function()
		for _, getPlayingAnimationTrack in ipairs(obj:GetPlayingAnimationTracks()) do
			getPlayingAnimationTrack:Stop(0)
		end
	end)

	local ok, result = pcall(function()
		return obj.AnimationPlayed:Connect(function(obj27)
			if not list2.perf.on.anims then
				return
			end

			pcall(function()
				obj27:Stop(0)
			end)
		end)
	end)

	if ok and result then
		list2.perf.animConns[obj] = result
	end
end

list2.perf.apply = function(obj)
	if list2.perf.ours(obj) then
		return
	end

	if list2.perf.on.textures then
		list2.perf.stripTexture(obj)
	end

	if list2.perf.on.effects then
		list2.perf.stripEffect(obj)
	end

	if list2.perf.on.sounds then
		list2.perf.stripSound(obj)
	end

	if list2.perf.on.anims and obj:IsA("Animator") then
		list2.perf.hookAnimator(obj)
	end

	if list2.perf.on.weaponfx then
		if obj:IsA("Tool") then
			list2.perf.stripWeaponFX(obj)
		elseif list2.perf.FX[obj.ClassName] and obj:FindFirstAncestorWhichIsA("Tool") then
			list2.perf.killFX(obj, "weaponfx")
		end
	end

	if list2.perf.on.pets then
		local parent = obj.Parent

		if parent and parent.Name == "PetContainer" then
			list2.perf.detach(obj, "pets")
		end
	end
end

list2.perf.queue = {}
list2.perf.queueN = 0
list2.perf.drainThread = nil
list2.perf.qHead = 1

list2.perf.enqueue = function(param139)
	local queueN = list2.perf.queueN + 1
	list2.perf.queueN = queueN
	list2.perf.queue[queueN] = param139
end

list2.perf.drainStep = function()
	local queue = list2.perf.queue
	local qHead = list2.perf.qHead
	local queueN = list2.perf.queueN

	if queueN < qHead then
		if queueN > 0 then
			local perf = list2.perf
			local perf2 = list2.perf
			list2.perf.queue = {}
			perf.queueN = 0
			perf2.qHead = 1
		end

		return
	end

	local n4 = qHead + list2.perf.CHUNK - 1

	if not (n4 > queueN) then
		queueN = n4
	end

	for i = qHead, queueN do
		list2.perf.safeApply(queue[i])
		queue[i] = nil
	end

	list2.perf.qHead = queueN + 1
end

list2.perf.stopDrain = function()
	if list2.perf.drainThread then
		pcall(task.cancel, list2.perf.drainThread)
		list2.perf.drainThread = nil
	end

	local perf = list2.perf
	local perf2 = list2.perf
	list2.perf.queue = {}
	perf.queueN = 0
	perf2.qHead = 1
end

list2.perf.startDrain = function()
	list2.perf.stopDrain()

	list2.perf.drainThread = task.spawn(function()
		while true do
			task.wait()
			local ok, result = pcall(list2.perf.drainStep)

			if not ok then
				warn("[FVL] performance queue: " .. tostring(result))
			end
		end
	end)
end

list2.perf.safeApply = function(param140)
	pcall(list2.perf.apply, param140)
end

list2.perf.sweepBody = function()
	local descendants = Workspace:GetDescendants()

	for i = 1, #descendants do
		list2.perf.safeApply(descendants[i])
		list2.perf.breathe(i)
	end

	if list2.perf.on.weaponfx then
		local descendants2 = localPlayer:GetDescendants()

		for i = 1, #descendants2 do
			local entry22 = descendants2[i]

			if entry22:IsA("Tool") then
				pcall(list2.perf.stripWeaponFX, entry22)
			end

			list2.perf.breathe(i)
		end
	end
end

list2.perf.resweep = false

list2.perf.sweep = function()
	if list2.perf.sweeping then
		list2.perf.resweep = true
		return
	end
	list2.perf.sweeping = true

	while true do
		list2.perf.resweep = false
		local ok, result = pcall(list2.perf.sweepBody)

		if not ok then
			warn("[FVL] performance sweep: " .. tostring(result))
		end

		if list2.perf.resweep then
			continue
		end
		break
	end

	list2.perf.sweeping = false
end

list2.perf.PROP_STASHES = { "part", "volume", "texid", "enabled" }

list2.perf.prune = function()
	local n4 = 0

	for _, propStashe in ipairs(list2.perf.PROP_STASHES) do
		local tbl102 = list2.perf.stash[propStashe]

		if tbl102 then
			local tbl103, value207 = list2.perf.keysOf(tbl102)

			for i = 1, value207 do
				local entry23 = tbl103[i]
				local ok, result = pcall(list2.perf.readProp, entry23, "Parent")

				if not ok or result == nil then
					tbl102[entry23] = nil
					n4 += 1
				end

				list2.perf.breathe(i)
			end
		end
	end

	local tbl104, value208 = list2.perf.keysOf(list2.perf.stash.parent)

	for i = 1, value208 do
		local entry24 = tbl104[i]
		local flag188 = list2.perf.stash.parent[entry24]

		if flag188 ~= nil then
			local ok, result = pcall(list2.perf.inGame, flag188)

			if not ok or not result then
				list2.perf.stash.parent[entry24] = nil
				list2.perf.owner[entry24] = nil
				n4 += 1
			end
		end

		list2.perf.breathe(i)
	end

	return n4
end

list2.perf.inGame = function(obj28)
	return obj28:IsDescendantOf(game)
end

list2.perf.PULSE = 10
list2.perf.pulseThread = nil

list2.perf.stopPulse = function()
	if list2.perf.pulseThread then
		pcall(task.cancel, list2.perf.pulseThread)
		list2.perf.pulseThread = nil
	end

	list2.perf.sweeping = false
end

list2.perf.startPulse = function()
	list2.perf.stopPulse()

	list2.perf.pulseThread = task.spawn(function()
		while true do
			task.wait(list2.perf.PULSE)
			local ok, result = pcall(list2.perf.sweep)

			if not ok then
				warn("[FVL] performance re-sweep: " .. tostring(result))
			end

			local ok2, result2 = pcall(list2.perf.prune)

			if not ok2 then
				warn("[FVL] performance prune: " .. tostring(result2))
			end
		end
	end)
end

list2.perf.syncWatcher = function()
	local textures = list2.perf.on.textures or list2.perf.on.effects or list2.perf.on.sounds or list2.perf.on.anims or list2.perf.on.weaponfx or list2.perf.on.pets

	if textures and not list2.perf.watchConn then
		list2.perf.watchConn = Workspace.DescendantAdded:Connect(list2.perf.enqueue)
		list2.perf.startDrain()
		list2.perf.startPulse()
	elseif not textures and list2.perf.watchConn then
		pcall(function()
			list2.perf.watchConn:Disconnect()
		end)

		list2.perf.watchConn = nil
		list2.perf.stopDrain()
		list2.perf.stopPulse()
	end

	if list2.perf.on.weaponfx and not list2.perf.playerConn then
		list2.perf.playerConn = localPlayer.DescendantAdded:Connect(list2.perf.enqueue)
	elseif not list2.perf.on.weaponfx and list2.perf.playerConn then
		pcall(function()
			list2.perf.playerConn:Disconnect()
		end)

		list2.perf.playerConn = nil
	end
end

list2.perf.restoreOwned = function(param141)
	local tbl105, value209 = list2.perf.keysOf(list2.perf.stash.parent)

	for i = 1, value209 do
		local entry25 = tbl105[i]
		local flag189 = list2.perf.stash.parent[entry25]

		if flag189 ~= nil and list2.perf.owner[entry25] == param141 then
			pcall(list2.perf.reparent, entry25, flag189)
			list2.perf.stash.parent[entry25] = nil
			list2.perf.owner[entry25] = nil
		end

		list2.perf.breathe(i)
	end
end

list2.perf.restoreEnabled = function(param142)
	local tbl106, value210 = list2.perf.keysOf(list2.perf.stash.enabled)

	for i = 1, value210 do
		local entry26 = tbl106[i]
		local flag190 = list2.perf.stash.enabled[entry26]

		if flag190 ~= nil and list2.perf.owner[entry26] == param142 then
			pcall(list2.perf.setProp, entry26, "Enabled", flag190)
			list2.perf.stash.enabled[entry26] = nil
		end

		list2.perf.breathe(i)
	end
end

list2.perf.restoreTextures = function()
	list2.perf.restoreOwned("textures")
	local tbl107, value211 = list2.perf.keysOf(list2.perf.stash.texid)

	for i = 1, value211 do
		local entry27 = tbl107[i]
		local flag191 = list2.perf.stash.texid[entry27]

		if flag191 ~= nil then
			if entry27.Parent then
				pcall(list2.perf.setProp, entry27, "TextureId", flag191)
			end

			list2.perf.stash.texid[entry27] = nil
		end

		list2.perf.breathe(i)
	end

	local tbl108, value212 = list2.perf.keysOf(list2.perf.stash.part)

	for i = 1, value212 do
		local entry28 = tbl108[i]
		local flag192 = list2.perf.stash.part[entry28]

		if flag192 ~= nil then
			if entry28.Parent then
				pcall(list2.perf.restorePart, entry28, flag192)
			end

			list2.perf.stash.part[entry28] = nil
		end

		list2.perf.breathe(i)
	end
end

list2.perf.features = {}

do
	local perf = list2.perf
	local perf2 = list2.perf
	list2.perf.gui = nil
	perf.label = nil
	perf2.fpsConn = nil
end

list2.perf.killCounter = function()
	if list2.perf.fpsConn then
		pcall(function()
			list2.perf.fpsConn:Disconnect()
		end)

		list2.perf.fpsConn = nil
	end

	if list2.perf.dragConn then
		pcall(function()
			list2.perf.dragConn:Disconnect()
		end)

		list2.perf.dragConn = nil
	end

	if list2.perf.gui then
		pcall(function()
			list2.perf.gui:Destroy()
		end)

		list2.perf.gui = nil
	end

	list2.perf.label = nil
end

list2.perf.buildCounter = function()
	list2.perf.killCounter()
	local screenGui = Instance.new("ScreenGui")
	screenGui.Name = "FVLFPSButton"
	screenGui.ResetOnSpawn = false
	screenGui.DisplayOrder = 9000
	screenGui.Parent = CoreGui
	local textButton = Instance.new("TextButton")
	textButton.AutoButtonColor = false
	textButton.Text = ""
	textButton.AnchorPoint = Vector2.new(0.5, 0)
	textButton.Position = list2.perf.fpsPos or UDim2.new(0.5, 0, 0, 6)
	textButton.Size = UDim2.fromOffset(72, 26)
	textButton.BackgroundColor3 = Color3.fromRGB(10, 10, 13)
	textButton.BackgroundTransparency = 0.25
	textButton.BorderSizePixel = 0
	textButton.Parent = screenGui
	Instance.new("UICorner", textButton).CornerRadius = UDim.new(0, 8)
	local uiStroke = Instance.new("UIStroke")
	uiStroke.Thickness = 1
	uiStroke.Color = Color3.fromRGB(255, 255, 255)
	uiStroke.Transparency = 0.85
	uiStroke.ApplyStrokeMode = Enum.ApplyStrokeMode.Border
	uiStroke.Parent = textButton
	local textLabel = Instance.new("TextLabel")
	textLabel.BackgroundTransparency = 1
	textLabel.Size = UDim2.fromScale(1, 1)
	textLabel.Font = Enum.Font.GothamBold
	textLabel.TextSize = 13
	textLabel.Text = "-- FPS"
	textLabel.TextColor3 = Color3.fromRGB(240, 240, 246)
	textLabel.Parent = textButton
	local perf = list2.perf
	list2.perf.gui = screenGui
	perf.label = textLabel
	local flag193 = false
	local value213 = nil
	local value214 = nil

	textButton.InputBegan:Connect(function(input)
		if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
			local position = input.Position
			local position2 = textButton.Position
			flag193 = true
			value213 = position
			value214 = position2
		end
	end)

	textButton.InputEnded:Connect(function(input)
		if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
			flag193 = false
			list2.perf.fpsPos = textButton.Position
		end
	end)

	list2.perf.dragConn = UserInputService.InputChanged:Connect(function(input)
		if not flag193 then
			return
		end

		if input.UserInputType ~= Enum.UserInputType.MouseMovement and input.UserInputType ~= Enum.UserInputType.Touch then
			return
		end
		local n4 = input.Position - value213
		textButton.Position = UDim2.new(value214.X.Scale, value214.X.Offset + n4.X, value214.Y.Scale, value214.Y.Offset + n4.Y)
	end)

	local n4 = 0
	local now = os.clock()

	list2.perf.fpsConn = RunService.RenderStepped:Connect(function()
		n4 += 1
		local now2 = os.clock()
		local n5 = now2 - now
		if n5 < 0.5 then
			return
		end
		local n6 = math.floor(n4 / n5 + 0.5)
		n4 = 0
		now = now2
		textLabel.Text = n6 .. " FPS"
		textLabel.TextColor3 = n6 >= 50 and ICON.green or n6 >= 30 and ICON.yellow or ICON.red
	end)
end

list2.perf.batch = false

list2.perf.set = function(str34, flag194)
	local flag195 = flag194 and true or false
	if list2.perf.on[str34] == flag195 then
		return
	end
	local flag196 = list2.perf.features[str34]
	if not flag196 then
		return
	end
	list2.perf.on[str34] = flag195
	if list2.perf.batch and flag195 and flag196.sweeps then
		return
	end
	local ok, result = pcall(flag195 and flag196.on or flag196.off)

	if not ok then
		warn("[FVL] performance '" .. str34 .. "' failed: " .. tostring(result))
	end

	list2.perf.syncWatcher()
end

list2.perf.MASTER = {
	"fpsCounter",
	"textures",
	"effects",
	"weaponfx",
	"pets",
	"anims",
	"lighting",
	"terrain",
	"sounds",
	"quality",
}

list2.perf.MIRRORS = { "master", "masterFarm" }
list2.perf.settingAll = false

list2.perf.setAll = function(param143)
	if list2.perf.settingAll then
		return
	end
	list2.perf.settingAll = true
	list2.perf.sweeping = false
	list2.perf.batch = true

	local ok, result = pcall(function()
		for _, item63 in ipairs(list2.perf.MASTER) do
			list2.setToggle(list2.perf.el[item63], param143)
			list2.perf.set(item63, param143)
		end
	end)

	for _, mirror in ipairs(list2.perf.MIRRORS) do
		list2.setToggle(list2.perf.el[mirror], param143)
	end

	list2.perf.batch = false
	list2.perf.settingAll = false

	if not ok then
		warn("[FVL] performance master failed: " .. tostring(result))
	end

	if param143 then
		pcall(list2.perf.sweep)
	end

	list2.perf.syncWatcher()
end

list2.perf.restoreAll = function()
	list2.perf.stopPulse()
	list2.perf.stopDrain()

	for k in next, list2.perf.features, nil do
		list2.perf.set(k, false)
	end

	list2.perf.killCounter()

	if list2.perf.capped then
		list2.perf.capped = false

		pcall(function()
			if setfpscap then
				setfpscap(list2.perf.UNCAPPED)
			end
		end)
	end
end

list2.perf.el.masterFarm = list2.perfFarmToggle
tbl43.visuals:Section({ Title = "Performance Mode" })

tbl43.visuals:Paragraph({
	Title = "Read me first",
	Desc = "All client-side and fully reversible - switch it off and the map is back. Roughly 10-30% more frames.",
})

list2.perf.el.master = tbl43.visuals:Toggle({
	Title = "Performance Mode",
	Flag = "Toggle_Perf_Master",
	Desc = "Strips textures, shadows, particles, effects, pets, animations and sounds, and drops the graphics quality. Ugly, and fast.",
	Type = "Toggle",
	Value = false,
	Callback = func112(function(param144)
		list2.perf.setAll(param144)
	end),
})

list2.perf.features.fpsCounter = {
	on = function()
		list2.perf.buildCounter()
	end,
	off = function()
		list2.perf.killCounter()
	end,
}

list2.perf.el.fpsCounter = tbl43.visuals:Toggle({
	Title = "FPS Counter",
	Flag = "Toggle_Perf_FPS",
	Desc = "Live framerate at the top of the screen -- drag it anywhere. Green 50+, amber 30+, red below.",
	Type = "Toggle",
	Value = false,
	Callback = func112(function(param145)
		list2.perf.set("fpsCounter", param145)
	end),
})

list2.perf.features.textures = {
	sweeps = true,
	on = function()
		list2.perf.sweep()
	end,
	off = function()
		list2.perf.restoreTextures()
	end,
}

list2.perf.el.textures = tbl43.visuals:Toggle({
	Title = "Remove Textures",
	Flag = "Toggle_Perf_Textures",
	Desc = "Textures and decals off, every part flat, nothing casting a shadow. The biggest single win.",
	Type = "Toggle",
	Value = false,
	Callback = func112(function(param146)
		list2.perf.set("textures", param146)
	end),
})

list2.perf.features.effects = {
	sweeps = true,
	on = function()
		list2.perf.sweep()
	end,
	off = function()
		list2.perf.restoreEnabled("effects")
		list2.perf.restoreOwned("effects")
	end,
}

list2.perf.el.effects = tbl43.visuals:Toggle({
	Title = "Remove Particles & Effects",
	Flag = "Toggle_Perf_Effects",
	Desc = "Particles, trails, beams, smoke, fire and every dynamic light. F$VL's own ESP and crosshair stay.",
	Type = "Toggle",
	Value = false,
	Callback = func112(function(param147)
		list2.perf.set("effects", param147)
	end),
})

list2.perf.features.weaponfx = {
	sweeps = true,
	on = function()
		list2.perf.sweep()
	end,
	off = function()
		list2.perf.restoreEnabled("weaponfx")
		list2.perf.restoreOwned("weaponfx")
	end,
}

list2.perf.features.pets = {
	on = function()
		local petContainer = Workspace:FindFirstChild("PetContainer")

		if petContainer then
			for _, child in ipairs(petContainer:GetChildren()) do
				list2.perf.detach(child, "pets")
			end
		end
	end,
	off = function()
		list2.perf.restoreOwned("pets")
	end,
}

list2.perf.features.anims = {
	sweeps = true,
	on = function()
		list2.perf.sweep()
	end,
	off = function()
		for k, value215 in next, list2.perf.animConns, nil do
			pcall(function()
				value215:Disconnect()
			end)

			list2.perf.animConns[k] = nil
		end
	end,
}

list2.perf.el.anims = tbl43.visuals:Toggle({
	Title = "Remove Animations",
	Flag = "Toggle_Perf_Anims",
	Desc = "Freezes every animation. Everyone slides around, you included. Movement still works.",
	Type = "Toggle",
	Value = false,
	Callback = func112(function(param148)
		list2.perf.set("anims", param148)
	end),
})

list2.perf.features.sounds = {
	sweeps = true,
	on = function()
		list2.perf.sweep()
	end,
	off = function()
		local tbl109, value216 = list2.perf.keysOf(list2.perf.stash.volume)

		for i = 1, value216 do
			local entry29 = tbl109[i]
			local flag197 = list2.perf.stash.volume[entry29]

			if flag197 ~= nil then
				if entry29.Parent then
					pcall(list2.perf.setProp, entry29, "Volume", flag197)
				end

				list2.perf.stash.volume[entry29] = nil
			end

			list2.perf.breathe(i)
		end
	end,
}

list2.perf.el.sounds = tbl43.visuals:Toggle({
	Title = "Mute All Sounds",
	Flag = "Toggle_Perf_Sounds",
	Desc = "Mutes the map. You lose footsteps, so think twice as innocent.",
	Type = "Toggle",
	Value = false,
	Callback = func112(function(param149)
		list2.perf.set("sounds", param149)
	end),
})

list2.perf.features.lighting = {
	on = function()
		if not list2.perf.stash.light then
			list2.perf.stash.light = {
				shadows = list2.perf.LIGHTING.GlobalShadows,
				diffuse = list2.perf.LIGHTING.EnvironmentDiffuseScale,
				spec = list2.perf.LIGHTING.EnvironmentSpecularScale,
				soft = list2.perf.LIGHTING.ShadowSoftness,
			}
		end

		pcall(function()
			list2.perf.LIGHTING.GlobalShadows = false
			list2.perf.LIGHTING.EnvironmentDiffuseScale = 0
			list2.perf.LIGHTING.EnvironmentSpecularScale = 0
			list2.perf.LIGHTING.ShadowSoftness = 0
		end)

		for _, child in ipairs(list2.perf.LIGHTING:GetChildren()) do
			if child:IsA("PostEffect") then
				if list2.perf.stash.post[child] == nil then
					list2.perf.stash.post[child] = child.Enabled

					pcall(function()
						child.Enabled = false
					end)
				end
			elseif child:IsA("Atmosphere") then
				list2.perf.detach(child, "lighting")
			end
		end

		for _, child in ipairs(Workspace.Terrain:GetChildren()) do
			if child:IsA("Clouds") then
				list2.perf.detach(child, "lighting")
			end
		end
	end,
	off = function()
		local light = list2.perf.stash.light

		if light then
			pcall(function()
				list2.perf.LIGHTING.GlobalShadows = light.shadows
				list2.perf.LIGHTING.EnvironmentDiffuseScale = light.diffuse
				list2.perf.LIGHTING.EnvironmentSpecularScale = light.spec
				list2.perf.LIGHTING.ShadowSoftness = light.soft
			end)

			list2.perf.stash.light = nil
		end

		for k, value217 in next, list2.perf.stash.post, nil do
			pcall(function()
				if k.Parent then
					k.Enabled = value217
				end
			end)
		end

		list2.perf.stash.post = {}
		list2.perf.restoreOwned("lighting")
	end,
}

list2.perf.el.lighting = tbl43.visuals:Toggle({
	Title = "Remove Shadows & Lighting FX",
	Flag = "Toggle_Perf_Lighting",
	Desc = "Shadows, bloom, blur, sun rays, depth of field and clouds. Second biggest win after textures.",
	Type = "Toggle",
	Value = false,
	Callback = func112(function(param150)
		list2.perf.set("lighting", param150)
	end),
})

list2.perf.features.terrain = {
	on = function()
		local terrain = Workspace.Terrain
		list2.perf.stash.terrain = list2.perf.stash.terrain or {}

		for _, item64 in ipairs(list2.perf.TERRAIN) do
			local first4 = item64[1]
			local second5 = item64[2]
			local ok, result = pcall(list2.perf.readProp, terrain, first4)

			if ok and list2.perf.stash.terrain[first4] == nil then
				list2.perf.stash.terrain[first4] = result
				pcall(list2.perf.setProp, terrain, first4, second5)
			end
		end
	end,
	off = function()
		local terrain = list2.perf.stash.terrain
		if not terrain then
			return
		end
		local terrain2 = Workspace.Terrain

		for k, value218 in next, terrain, nil do
			pcall(list2.perf.setProp, terrain2, k, value218)
		end

		list2.perf.stash.terrain = nil
	end,
}

list2.perf.el.terrain = tbl43.visuals:Toggle({
	Title = "Flat Terrain & Water",
	Flag = "Toggle_Perf_Terrain",
	Desc = "Kills grass blades and the animated water waves.",
	Type = "Toggle",
	Value = false,
	Callback = func112(function(param151)
		list2.perf.set("terrain", param151)
	end),
})

list2.perf.features.quality = {
	on = function()
		if list2.perf.stash.quality == nil then
			pcall(function()
				list2.perf.stash.quality = settings().Rendering.QualityLevel
			end)
		end

		pcall(function()
			local level01 = Enum.QualityLevel.Level01
			settings().Rendering.QualityLevel = level01
		end)

		pcall(function()
			local qualityLevel1 = Enum.SavedQualitySetting.QualityLevel1
			UserSettings():GetService("UserGameSettings").SavedQualityLevel = qualityLevel1
		end)
	end,
	off = function()
		local quality = list2.perf.stash.quality

		if quality ~= nil then
			pcall(function()
				settings().Rendering.QualityLevel = quality
			end)

			list2.perf.stash.quality = nil
		end

		pcall(function()
			local automatic = Enum.SavedQualitySetting.Automatic
			UserSettings():GetService("UserGameSettings").SavedQualityLevel = automatic
		end)
	end,
}

list2.perf.el.quality = tbl43.visuals:Toggle({
	Title = "Lowest Graphics Quality",
	Flag = "Toggle_Perf_Quality",
	Desc = "Sets Roblox's own graphics slider to 1. Needs a level 8 executor.",
	Type = "Toggle",
	Value = false,
	Callback = func112(function(param152)
		list2.perf.set("quality", param152)
	end),
})

func120(ICON.mono)

do
	local tbl110 = { ToggleGUI = Enum.KeyCode.G }

	local tbl111 = {
		ToggleGUI = function()
			obj3:Toggle()
		end,
		Shoot = function()
			func67()
		end,
		Grab = function()
			func73()
		end,
		Throw = function()
			func68()
		end,
		Bomb = function()
			func71()
		end,
		Aimbot = function()
			num16.set(not num16.enabled)
		end,
		WallHop = function()
			func72()
		end,
		Noclip = function()
			list2.setToggle(list2.el.noclip, not flag41, function(param153)
				flag41 = param153

				if param153 then
					func39()
				else
					func40()
				end
			end)
		end,
		Fly = function()
			list2.setToggle(list2.el.fly, not flag42, function(param154)
				flag42 = param154

				if param154 then
					func41()
				else
					func42()
				end
			end)
		end,
		InfJump = function()
			list2.setToggle(list2.el.infjump, not flag43, function(param155)
				flag43 = param155

				if param155 then
					func43()
				else
					func44()
				end
			end)
		end,
		AntiFling = function()
			list2.setToggle(list2.el.antifling, not flag44, function(param156)
				flag44 = param156

				if param156 then
					func45()
				else
					func46()
				end
			end)
		end,
		Speed = function()
			local humanoid = localPlayer.Character and localPlayer.Character:FindFirstChildOfClass("Humanoid")
			func37(humanoid and humanoid.WalkSpeed ~= 16 and 16 or walkSpeed)
		end,
		Jump = function()
			local humanoid = localPlayer.Character and localPlayer.Character:FindFirstChildOfClass("Humanoid")
			func38(humanoid and humanoid.JumpPower ~= 50 and 50 or jumpPower)
		end,
	}

	keybindConn = UserInputService.InputBegan:Connect(function(input)
		if input.UserInputType ~= Enum.UserInputType.Keyboard then
			return
		end

		if input.KeyCode == Enum.KeyCode.Unknown then
			return
		end

		if UserInputService:GetFocusedTextBox() then
			return
		end

		for k, value219 in pairs(tbl110) do
			value219 = value219 and input.KeyCode == value219

			if value219 then
				local entry30 = tbl111[k]

				if entry30 then
					task.spawn(function()
						pcall(entry30)
					end)
				end
			end
		end
	end)

	local function func197(obj29, param157, param158, str35, param159)
		obj29:Keybind({
			Title = param157,
			Desc = param158,
			Flag = "Keybind_" .. str35,
			Value = param159,
			Callback = function(value)
				local ok, result = pcall(function()
					return Enum.KeyCode[value]
				end)

				if ok and result and result ~= Enum.KeyCode.Unknown then
					tbl110[str35] = result
				else
					tbl110[str35] = nil
				end
			end,
		})
	end

	tbl43.keybinds:Section({ Title = "Interface" })
	func197(tbl43.keybinds, "Toggle GUI", "Show or hide the window.", "ToggleGUI", "G")
	list2.UNBOUND = "Unbound - click to set a key. Ignore the key shown until you do."
	tbl43.keybinds:Section({ Title = "Actions" })
	func197(tbl43.keybinds, "Shoot Murderer", list2.UNBOUND, "Shoot", "Unknown")
	func197(tbl43.keybinds, "Grab Gun", list2.UNBOUND, "Grab", "Unknown")
	func197(tbl43.keybinds, "Throw Knife", list2.UNBOUND, "Throw", "Unknown")
	func197(tbl43.keybinds, "Bomb Jump", list2.UNBOUND, "Bomb", "Unknown")
	func197(tbl43.keybinds, "Toggle Aimbot", list2.UNBOUND, "Aimbot", "Unknown")
	tbl43.keybinds:Section({ Title = "Player" })
	func197(tbl43.keybinds, "Toggle Noclip", list2.UNBOUND, "Noclip", "Unknown")
	func197(tbl43.keybinds, "Toggle Fly", list2.UNBOUND, "Fly", "Unknown")
	func197(tbl43.keybinds, "Toggle Infinite Jump", list2.UNBOUND, "InfJump", "Unknown")
	func197(tbl43.keybinds, "Toggle Anti-Fling", list2.UNBOUND, "AntiFling", "Unknown")
	func197(tbl43.keybinds, "Toggle Walk Speed", list2.UNBOUND .. " Snaps between your slider speed and 16.", "Speed", "Unknown")
	func197(tbl43.keybinds, "Toggle Jump Power", list2.UNBOUND .. " Snaps between your slider jump and 50.", "Jump", "Unknown")
	func197(tbl43.keybinds, "Wall Hop", "Unbound — click to set a key. Ignore the key shown until you do.", "WallHop", "Unknown")
end

tbl43.player:Section({ Title = "Speeds" })

tbl43.player:Slider({
	Title = "Walk Speed",
	Flag = "Slider_Walk_Speed",
	Desc = "How fast you walk — crank it to outrun the murderer",
	Step = 1,
	Value = { Min = 16, Max = 100, Default = 16 },
	Callback = function(value)
		func37(value)
	end,
})

tbl43.player:Slider({
	Title = "Jump Power",
	Flag = "Slider_Jump_Power",
	Desc = "How high you jump",
	Step = 1,
	Value = { Min = 50, Max = 200, Default = 50 },
	Callback = function(value)
		func38(value)
	end,
})

tbl43.player:Section({ Title = "Escape & Defense" })

list2.el.antifling = tbl43.player:Toggle({
	Title = "Anti-Fling",
	Flag = "Toggle_Anti_Fling",
	Desc = "Blocks other players from flinging you. On by default.",
	Type = "Toggle",
	Value = true,
	Callback = function(value)
		flag44 = value

		if value then
			func45()
			obj2:Notify({ Title = "Anti-Fling ON", Content = "Fling protection on!", Duration = 2, Icon = "shield" })
		else
			func46()

			obj2:Notify({
				Title = "Anti-Fling OFF",
				Content = "Fling protection off.",
				Duration = 2,
				Icon = "power-off",
			})
		end
	end,
})

list2.el.noclip = tbl43.player:Toggle({
	Title = "Noclip",
	Flag = "Toggle_Noclip",
	Desc = "Walk through walls",
	Type = "Toggle",
	Value = false,
	Callback = function(value)
		flag41 = value

		if value then
			func39()
		else
			func40()
		end

		if num15 then
			num15.setActive("Noclip", value)
		end
	end,
})

list2.el.infjump = tbl43.player:Toggle({
	Title = "Infinite Jump",
	Flag = "Toggle_Infinite_Jump",
	Desc = "Jump as many times as you want mid-air",
	Type = "Toggle",
	Value = false,
	Callback = function(value)
		flag43 = value

		if value then
			func43()
		else
			func44()
		end
	end,
})

list2.el.fly = tbl43.player:Toggle({
	Title = "Fly",
	Flag = "Toggle_Fly",
	Desc = "Fly around the map freely. WASD + Space / LeftShift",
	Type = "Toggle",
	Value = false,
	Callback = function(value)
		flag42 = value

		if value then
			func41()
		else
			func42()
		end

		if num15 then
			num15.setActive("Fly", value)
		end
	end,
})

tbl43.player:Slider({
	Title = "Fly Speed",
	Flag = "Slider_Fly_Speed",
	Desc = "How fast you fly",
	Step = 1,
	Value = { Min = 10, Max = 200, Default = 50 },
	Callback = function(value)
		n = value
	end,
})

tbl43.player:Section({ Title = "Beta" })

tbl43.player:Button({
	Title = "God Mode  [BETA]",
	Desc = "Nothing can kill you - but you cannot pick up coins or the gun. Needs a round in progress.",
	Callback = function()
		list2.godMode()
	end,
})

func118("God Mode  [BETA]", Color3.fromHex("#FDE68A"))
func120(ICON.mono)
tbl43.crosshair:Section({ Title = "Sheriff Crosshair" })

tbl43.crosshair:Toggle({
	Title = "Spin Cursor",
	Flag = "Toggle_Spin_Cursor",
	Desc = "Slowly rotates the crosshair image.",
	Type = "Toggle",
	Value = false,
	Callback = func112(function(spin)
		flag135.spin = spin
	end),
})

tbl43.crosshair:Slider({
	Title = "Crosshair Size",
	Flag = "Slider_Crosshair_Size",
	Desc = "Size in pixels.",
	Step = 1,
	Value = { Min = 12, Max = 80, Default = 50 },
	Callback = func112(function(size)
		flag135.size = size

		if value130 then
			value130.Size = UDim2.fromOffset(size, size)
		end
	end),
})

CURSOR_ORDER = {
	"Default",
	"Hello Kitty",
	"Kitty v2",
	"Clean Kitty",
	"Evil Kitty",
	"Kuromi",
	"Pixel Cat",
	"Paw",
	"Cat",
	"Heart",
	"Red Heart",
	"Green Heart",
	"Blue Heart",
	"Yellow Heart",
	"Heart Cross",
	"Star",
	"Star v2",
	"Pink Star",
	"Power Star",
	"Cross",
	"Pentagram",
	"Gengar",
	"Bunny",
	"Vamp Face",
	"Osu",
	"Troll",
	"Glowing Circle",
	"Donut",
	"Blue Donut",
	"Death",
	"Bear",
	"Barbie",
	"Shoot this guy",
}

do
	local tbl112 = {}
	local value220 = tbl43.crosshair:Paragraph({ Title = "Crosshair", Desc = "" })

	local function func198()
		for k, value221 in pairs(tbl112) do
			local flag198 = k == flag135.style
			value221.stroke.Color = flag198 and ICON.pink or Color3.fromRGB(255, 255, 255)
			value221.stroke.Transparency = flag198 and 0.1 or 0.85
			value221.label.TextColor3 = flag198 and Color3.fromRGB(240, 240, 246) or Color3.fromRGB(150, 150, 160)
		end
	end

	local flag199 = func119(value220)

	if not flag199 then
		warn("[FVL] couldn't reach the Paragraph container - cursor grid skipped")
	else
		local ceiled = math.ceil(#CURSOR_ORDER / 4)
		local frame = Instance.new("Frame")
		frame.Name = "FVLCursorGrid"
		frame.BackgroundTransparency = 1
		frame.Size = UDim2.new(1, 0, 0, ceiled * 84 + (ceiled - 1) * 6)
		frame.Parent = flag199
		local uiGridLayout = Instance.new("UIGridLayout")
		uiGridLayout.CellSize = UDim2.fromOffset(84, 84)
		uiGridLayout.CellPadding = UDim2.fromOffset(6, 6)
		uiGridLayout.SortOrder = Enum.SortOrder.LayoutOrder
		uiGridLayout.HorizontalAlignment = Enum.HorizontalAlignment.Center
		uiGridLayout.Parent = frame

		local function func199()
			frame.Size = UDim2.new(1, 0, 0, uiGridLayout.AbsoluteContentSize.Y)
		end

		uiGridLayout:GetPropertyChangedSignal("AbsoluteContentSize"):Connect(func199)
		func199()

		for i, item65 in ipairs(CURSOR_ORDER) do
			local textButton = Instance.new("TextButton")
			textButton.Name = item65
			textButton.LayoutOrder = i
			textButton.Text = ""
			textButton.AutoButtonColor = false
			textButton.BackgroundColor3 = Color3.fromRGB(10, 10, 13)
			textButton.BackgroundTransparency = 0.25
			textButton.BorderSizePixel = 0
			textButton.Parent = frame
			Instance.new("UICorner", textButton).CornerRadius = UDim.new(0, 10)
			local uiStroke = Instance.new("UIStroke")
			uiStroke.Thickness = 1.5
			uiStroke.ApplyStrokeMode = Enum.ApplyStrokeMode.Border
			uiStroke.Parent = textButton
			local imageLabel = Instance.new("ImageLabel")
			imageLabel.BackgroundTransparency = 1
			imageLabel.AnchorPoint = Vector2.new(0.5, 0)
			imageLabel.Position = UDim2.new(0.5, 0, 0, 5)
			imageLabel.Size = UDim2.fromOffset(56, 56)
			imageLabel.Image = CURSORS[item65]
			imageLabel.ScaleType = Enum.ScaleType.Stretch
			imageLabel.Parent = textButton
			local textLabel = Instance.new("TextLabel")
			textLabel.BackgroundTransparency = 1
			textLabel.AnchorPoint = Vector2.new(0.5, 1)
			textLabel.Position = UDim2.new(0.5, 0, 1, -4)
			textLabel.Size = UDim2.new(1, -6, 0, 18)
			textLabel.Font = Enum.Font.GothamBold
			textLabel.TextSize = 10
			textLabel.TextWrapped = true
			textLabel.Text = item65
			textLabel.Parent = textButton

			textButton.MouseButton1Click:Connect(function()
				flag135.style = item65
				func111()
				func198()
			end)

			tbl112[item65] = { tile = textButton, stroke = uiStroke, label = textLabel, img = imageLabel }
		end

		func198()
	end
end

flag136 = true
func111()
func120(ICON.mono)
tbl43.settings:Section({ Title = "Interface" })

list2.setOpacity = function(param160)
	local uiOpacity = math.clamp(tonumber(param160) or 60, 0, 100)
	list2.uiOpacity = uiOpacity
	local n4 = 1 - uiOpacity / 100

	pcall(function()
		obj3:SetBackgroundTransparency(n4)
	end)

	pcall(function()
		obj3:SetBackgroundImageTransparency(n4 * 0.875)
	end)

	local opTok = (list2.opTok or 0) + 1
	list2.opTok = opTok

	task.delay(0.12, function()
		if list2.opTok ~= opTok then
			return
		end

		pcall(function()
			local fvlTheme = obj2.Themes and obj2.Themes["F$VL"]
			if not fvlTheme then
				return
			end
			fvlTheme.ElementBackgroundTransparency = math.min(n4 * 0.75, 0.6)
			obj2:SetTheme("F$VL")
		end)
	end)
end

tbl43.settings:Slider({
	Title = "UI Opacity",
	Flag = "Slider_UI_Opacity",
	Desc = "How solid the window is. 100 hides the game behind it completely, low turns it to glass.",
	Step = 1,
	Value = { Min = 0, Max = 100, Default = 60 },
	Callback = function(value)
		list2.setOpacity(tonumber(value) or type(value) == "table" and tonumber(value.Value) or 60)
	end,
})

tbl43.settings:Section({ Title = "Protection" })
list2.antiStealer = false

tbl43.settings:Toggle({
	Title = "Anti Stealer",
	Flag = "Toggle_Anti_Stealer",
	Desc = "Stops other scripts you run from taking your godlys and other valuable items.",
	Type = "Toggle",
	Value = false,
	Callback = function(antiStealer)
		list2.antiStealer = antiStealer
	end,
})

tbl43.settings:Section({ Title = "Server" })

tbl43.settings:Button({
	Title = "Server Hop",
	Desc = "Quickly join another server",
	Icon = "lucide:arrow-right-left",
	Callback = function()
		task.spawn(func32)
	end,
})

tbl43.settings:Button({
	Title = "Smallest Server",
	Desc = "Join the server with the fewest players",
	Icon = "lucide:users",
	Callback = function()
		task.spawn(func33)
	end,
})

tbl43.settings:Section({ Title = "Config" })
list2.cfgName = ""

list2.namedConfig = function(param161)
	local config = obj3.ConfigManager:GetConfig(param161) or obj3.ConfigManager:CreateConfig(param161)

	if config and list2.config and list2.config.Elements then
		config.Elements = list2.config.Elements
	end

	return config
end

list2.hudFileFor = function(str36)
	if not str36 or str36 == "" or str36 == "autosave" then
		return list2.hudFile
	end
	return list2.hudDir .. "/" .. str36 .. ".json"
end

list2.hudSaveTo = function(param162)
	pcall(function()
		if writefile then
			local value222 = HttpService
			local jsonEncode = value222.JSONEncode
			local captureHud = list2.captureHud
			writefile(list2.hudFileFor(param162), jsonEncode(value222, captureHud()))
		end
	end)
end

list2.hudLoadFrom = function(param163)
	pcall(function()
		local hudFileF = list2.hudFileFor(param163)

		if isfile and isfile(hudFileF) then
			local data = HttpService:JSONDecode(readfile(hudFileF))

			if type(data) == "table" then
				list2.hudPos = data
				list2.applyHud()
			end
		end
	end)
end

list2.namedList = function()
	local list45 = {}

	pcall(function()
		local func200 = ipairs
		local config = list2.config and obj3.ConfigManager:AllConfigs() or {}

		for _, value223 in func200(config) do
			if value223 ~= "autosave" and not tostring(value223):match("^fvl_hud") then
				list45[#list45 + 1] = value223
			end
		end
	end)

	return list45
end

list2.el.cfgList = tbl43.settings:Dropdown({
	Title = "Saved Configs",
	Desc = "Pick one, then use Load or Delete",
	Multi = false,
	Value = nil,
	Values = list2.namedList(),
	Callback = function(value)
		list2.cfgName = tostring(value or "")
	end,
})

list2.refreshCfgList = function()
	pcall(function()
		if list2.el.cfgList and list2.el.cfgList.Refresh then
			list2.el.cfgList:Refresh(list2.namedList())
		elseif list2.el.cfgList and list2.el.cfgList.SetValues then
			list2.el.cfgList:SetValues(list2.namedList())
		end
	end)
end

list2.el.cfgInput = tbl43.settings:Input({
	Title = "Config Name",
	Desc = "Name to save under, or type an existing one to load/delete",
	Placeholder = "myconfig",
	Callback = function(value)
		list2.cfgName = tostring(value or "")
	end,
})

list2.DEFAULT_CFG = "F$VL_Default"

pcall(function()
	local config = obj3.ConfigManager:GetConfig(list2.DEFAULT_CFG) or obj3.ConfigManager:CreateConfig(list2.DEFAULT_CFG)

	if list2.config and list2.config.Elements then
		config.Elements = list2.config.Elements
	end

	config:Save()
	local tbl113 = {}

	for k, value224 in next, tbl35, nil do
		tbl113[k] = { value224.X.Scale, value224.X.Offset, value224.Y.Scale, value224.Y.Offset }
	end

	if writefile then
		local value225 = HttpService
		local jsonEncode = value225.JSONEncode
		writefile(list2.hudFileFor(list2.DEFAULT_CFG), jsonEncode(value225, tbl113))
	end
end)

list2.refreshCfgList()

list2.cfgPick = function(flag200)
	local flag201 = (list2.cfgName or ""):gsub("^%s+", ""):gsub("%s+$", "")
	if flag201 == "" then
		obj2:Notify({ Title = "Config", Content = "Pick or type a name first.", Duration = 4, Icon = "x" })
		return nil
	end

	if flag201 == "autosave" then
		obj2:Notify({
			Title = "Config",
			Content = "That name is reserved for the autosave.",
			Duration = 4,
			Icon = "x",
		})

		return nil
	end

	if flag201 == list2.DEFAULT_CFG and flag200 ~= "load" then
		obj2:Notify({
			Title = "Protected Config",
			Content = "F$VL_Default is the built-in fallback - it cannot be " .. (flag200 == "delete" and "deleted." or "overwritten."),
			Duration = 5,
			Icon = "shield",
		})

		return nil
	end

	return flag201
end

list2.cfgApply = function(flag202)
	if flag202 ~= list2.DEFAULT_CFG then
		pcall(function()
			list2.namedConfig(list2.DEFAULT_CFG):Load()
		end)

		task.wait(0.35)
	end

	return (pcall(function()
		list2.namedConfig(flag202):Load()
	end))
end

tbl43.settings:Button({
	Title = "Load Config",
	Desc = "Applies the named config to every setting and button position.",
	Icon = "lucide:folder-open",
	Callback = function()
		local load = list2.cfgPick("load")
		if not load then
			return
		end

		task.spawn(function()
			local flag203 = list2.cfgApply(load)
			list2.hudLoadFrom(load)

			task.delay(1, function()
				pcall(list2.saveNow)
			end)

			obj2:Notify({
				Title = flag203 and "Config Loaded!" or "Config",
				Content = flag203 and "Loaded " .. load or "Could not load that config.",
				Duration = 4,
				Icon = flag203 and "check" or "x",
			})
		end)
	end,
})

tbl43.settings:Button({
	Title = "Save Config",
	Desc = "Writes your current settings and button positions to the name above.",
	Icon = "lucide:save",
	Callback = function()
		local save = list2.cfgPick("save")
		if not save then
			return
		end

		local ok = pcall(function()
			list2.namedConfig(save):Save()
		end)

		list2.hudSaveTo(save)
		list2.refreshCfgList()

		obj2:Notify({
			Title = ok and "Config Saved!" or "Config",
			Content = ok and "Saved as " .. save or "Could not save.",
			Duration = 4,
			Icon = ok and "check" or "x",
		})
	end,
})

tbl43.settings:Button({
	Title = "Delete Config",
	Desc = "Removes the named config. Leaves the autosave alone.",
	Icon = "lucide:trash",
	Callback = function()
		local delete = list2.cfgPick("delete")
		if not delete then
			return
		end

		local ok = pcall(function()
			local config = obj3.ConfigManager:GetConfig(delete)

			if config then
				config:Delete()
			else
				obj3.ConfigManager:DeleteConfig(delete)
			end
		end)

		pcall(function()
			local hudFileF2 = list2.hudFileFor(delete)

			if delfile and isfile and isfile(hudFileF2) then
				delfile(hudFileF2)
			end
		end)

		if list2.cfgName == delete then
			list2.cfgName = ""
		end

		list2.refreshCfgList()

		obj2:Notify({
			Title = ok and "Config Deleted!" or "Config",
			Content = ok and delete .. " removed." or "Could not delete that config.",
			Duration = 4,
			Icon = ok and "check" or "x",
		})
	end,
})

tbl43.settings:Paragraph({
	Title = "Autosave Config",
	Desc = "Everything saves itself a couple of seconds after you change it and comes back next time you execute. Separate from the named configs above.",
})

tbl43.settings:Button({
	Title = "Delete Autosave Config",
	Desc = "Wipes the saved config and goes back to defaults on next execute",
	Icon = "lucide:trash-2",
	Callback = function()
		if not list2.config then
			obj2:Notify({ Title = "Config", Content = "Nothing to delete.", Duration = 3, Icon = "x" })
			return
		end
		list2.cfgWiped = true
		list2.hudPos = {}

		local ok = pcall(function()
			list2.config:Delete()
		end)

		pcall(function()
			if delfile and isfile and isfile(list2.hudFile) then
				delfile(list2.hudFile)
			end
		end)

		obj2:Notify({
			Title = ok and "Config Deleted!" or "Config",
			Content = ok and "Re-execute the script to come up on defaults." or "Could not delete the config file.",
			Duration = 6,
			Icon = ok and "check" or "x",
		})
	end,
})

func118("Load Config", Color3.fromHex("#86EFAC"))
func118("Save Config", Color3.fromHex("#FDE68A"))
func118("Delete Config", Color3.fromHex("#FCA5A5"))
func118("Delete Autosave Config", Color3.fromHex("#FCA5A5"))

local function fvlV2Cleanup()
	func22()
	func30()
	flag18 = false
	flag19 = false
	flag20 = false
	obj4:Destroy()
	list2.unreveal()
	flag41 = false
	flag42 = false
	flag43 = false
	flag44 = false
	func40()
	func42()
	func44()
	func46()
	func37(16)
	func38(50)
	func49()
	func51()
	func53()
	list2.stopShells()
	local func201 = ipairs
	local boxes = list2.BOXES or {}

	for _, boxe in func201(boxes) do
		list2.boxOn[boxe[1]] = false
	end

	list2.stopFarmHopWatch()
	list2.flingAllRunning = false
	num16.enabled = false
	num16.stop()
	func110()
	func69()

	pcall(function()
		if _G.__MM2Viz and _G.__MM2Viz.destroy then
			_G.__MM2Viz.destroy()
		end
	end)

	if keybindConn then
		pcall(function()
			keybindConn:Disconnect()
		end)

		keybindConn = nil
	end

	if obj9 then
		pcall(function()
			obj9:Disconnect()
		end)

		obj9 = nil
	end

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

	if connection4 then
		pcall(function()
			connection4:Disconnect()
		end)

		connection4 = nil
	end

	if connection3 then
		pcall(function()
			connection3:Disconnect()
		end)

		connection3 = nil
	end

	if connection5 then
		pcall(function()
			connection5:Disconnect()
		end)

		connection5 = nil
	end

	for _, item66 in ipairs(tbl34) do
		pcall(function()
			item66:Disconnect()
		end)
	end

	tbl34 = {}
	num15.destroyAll()
	func113()

	pcall(function()
		if list2.perf then
			list2.perf.restoreAll()
		end
	end)

	pcall(function()
		if ROLEBOX then
			ROLEBOX.stop()
		end
	end)

	list2.stopVelTracker()
	list2.tr.stop()
	list2.setXray(false)
	list2.dropConns(list2.conns)
	list2.reclip(list2.clipWas)
	list2.reclip(list2.farmClipWas)
	_G.FVLSilentTarget = nil
end

obj3:OnDestroy(function()
	list2.farewell()
	fvlV2Cleanup()
	local list46 = {}

	pcall(function()
		local hui = gethui and gethui() or CoreGui

		for _, child in ipairs(hui:GetChildren()) do
			if child.Name == "WindUI" or child.Name:match("^WindUI/") then
				list46[#list46 + 1] = child
			end
		end
	end)

	task.delay(0.6, function()
		for _, item67 in ipairs(list46) do
			pcall(function()
				item67:Destroy()
			end)
		end
	end)

	if _G.FVLV2 == obj3 then
		_G.FVLV2 = nil
	end

	if _G.FVLV2Cleanup == fvlV2Cleanup then
		_G.FVLV2Cleanup = nil
	end
end)

_G.FVLV2Cleanup = fvlV2Cleanup
obj3:Open()
list2.pinOpenPill()
obj3:SelectTab(1)

task.spawn(function()
	for i = 1, 60 do
		RunService.RenderStepped:Wait()

		if obj3.CurrentTab ~= 1 then
			obj3:SelectTab(1)
		end
	end
end)

list2.captureHud = function()
	local tbl114 = {}

	for k, value226 in next, list2.hudBtns, nil do
		if value226 and value226.Parent then
			local position = value226.Position
			tbl114[k] = { position.X.Scale, position.X.Offset, position.Y.Scale, position.Y.Offset }
		end
	end

	return tbl114
end

list2.applyHud = function()
	for k, value227 in next, list2.hudPos, nil do
		local flag204 = list2.hudBtns[k]

		if flag204 and flag204.Parent and type(value227) == "table" and #value227 == 4 then
			flag204.Position = UDim2.new(value227[1], value227[2], value227[3], value227[4])
		end
	end
end

list2.snapshot = function()
	if not list2.config then
		return ""
	end

	local ok, result = pcall(function()
		return HttpService:JSONEncode({ data = list2.config:GetData(), hud = list2.captureHud() })
	end)

	return ok and result or ""
end

list2.saveNow = function()
	if list2.cfgWiped then
		return
	end

	pcall(function()
		if writefile then
			writefile(list2.hudFile, HttpService:JSONEncode(list2.captureHud()))
		end
	end)

	if list2.config then
		pcall(function()
			list2.config:Save()
		end)
	end

	list2.cfgSnapshot = list2.snapshot()
end

task.spawn(function()
	if not list2.config then
		list2.notifyReady = true
		list2.sfxReady = true

		list2.notifyNow({
			Title = "Config",
			Content = "ConfigManager unavailable - settings will not persist.",
			Duration = 5,
			Icon = "x",
		})

		return
	end

	pcall(function()
		return list2.config:Load()
	end)

	list2.applyHud()
	task.wait(1)
	list2.cfgSnapshot = list2.snapshot()
	list2.notifyReady = true
	list2.sfxReady = true

	while _G.FVLV2 == obj3 do
		task.wait(2)

		if not list2.cfgWiped then
			local flag205 = list2.snapshot()

			if flag205 ~= "" and flag205 ~= list2.cfgSnapshot then
				list2.saveNow()
			end
		end
	end
end)


list2.notifyNow({
	Title = "F$VL",
	Content = "Loaded. G toggles the window.",
	Duration = 10,
	Icon = "rbxassetid://103877612231883",
})