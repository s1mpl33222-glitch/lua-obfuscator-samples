local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local TweenService = game:GetService("TweenService")
local UserInputService = game:GetService("UserInputService")
local GuiService = game:GetService("GuiService")
local StarterGui = game:GetService("StarterGui")
local MarketplaceService = game:GetService("MarketplaceService")
local LocalPlayer = Players.LocalPlayer

local RENDER_URL = "https://bunnihubbi.onrender.com"
local CONFIG = {
	HubName = "Bunny Hub",
	Version = "3.1",
	Maker = "bonniies",
	Support = "danial",
	KeyLink = "https://bunnihubbi.onrender.com",
	StatusMessage = "Enter your key to continue",
	IntroImage = "rbxassetid://86598373762883",
	HubImage = "rbxassetid://70947888871024",
	KeyFile = "bunny_hub_key.txt",

	PasteBypass = true,
	Blur = true,
	SkipIntro = true,

	Intro = true,
}

do
	local ok, saved = pcall(function()
		return type(getgenv) == "function" and getgenv().BunnyGateConfig or nil
	end)
	if ok and type(saved) == "table" then
		for key in pairs(CONFIG) do
			if saved[key] ~= nil then
				CONFIG[key] = saved[key]
			end
		end
	end
end

local TYPE = {
	caption = 12,
	small = 13,
	body = 14,
	label = 15,
	title = 18,
	heading = 22,
	display = 30,
	metric = 26,
}
local INK = Color3.fromRGB(14, 13, 16)
local SIDE = Color3.fromRGB(20, 18, 24)
local CARD = Color3.fromRGB(30, 28, 34)
local LINE = Color3.fromRGB(58, 48, 68)
local PINK = Color3.fromRGB(255, 143, 214)
local ROSE = Color3.fromRGB(255, 186, 226)
local HOT = Color3.fromRGB(255, 112, 188)
local MUTED = Color3.fromRGB(164, 156, 176)
local TEXT = Color3.fromRGB(240, 236, 244)
local GOOD = Color3.fromRGB(120, 220, 160)
local BAD = Color3.fromRGB(255, 120, 140)

local running = true
local keyFile = CONFIG.KeyFile

local function tween(inst, duration, props, style, direction)
	local info = TweenInfo.new(duration, style or Enum.EasingStyle.Quint, direction or Enum.EasingDirection.Out)
	local t = TweenService:Create(inst, info, props)
	t:Play()
	return t
end

local function tweenBounce(inst, duration, props)
	return tween(inst, duration, props, Enum.EasingStyle.Back)
end

local function corner(inst, radius)
	local c = Instance.new("UICorner")
	c.CornerRadius = UDim.new(0, radius or 12)
	c.Parent = inst
	return c
end

local function stroke(inst, color, thickness, transparency)
	local s = Instance.new("UIStroke")
	s.Color = color or LINE
	s.Thickness = thickness or 1
	s.Transparency = transparency or 0.35
	s.Parent = inst
	return s
end

local function notify(title, text, seconds)
	pcall(function()
		StarterGui:SetCore("SendNotification", {
			Title = title,
			Text = tostring(text),
			Duration = seconds or 3,
		})
	end)
end

local function copyToClipboard(text)
	local copied = false
	if type(setclipboard) == "function" then
		copied = pcall(setclipboard, text)
	elseif type(toclipboard) == "function" then
		copied = pcall(toclipboard, text)
	end
	return copied == true
end

local CoreTarget = gethui and gethui() or game:GetService("CoreGui")
for _, name in ipairs({ "BunnyHub_Loader", "BunnyHub_Intro" }) do
	local existing = CoreTarget:FindFirstChild(name)
	if existing then
		pcall(function()
			existing:Destroy()
		end)
	end
end

local camera = workspace.CurrentCamera
local view = camera and camera.ViewportSize or Vector2.new(1280, 720)
local phone = UserInputService.TouchEnabled and not UserInputService.KeyboardEnabled
	and math.min(view.X, view.Y) <= 900
local panelW = phone and math.clamp(view.X - 24, 320, 560) or 1000
local panelH = phone and math.clamp(view.Y - 96, 420, 660) or 560
local sideW = phone and 0 or 232

local gui = Instance.new("ScreenGui")
gui.Name = "BunnyHub_Loader"
gui.ResetOnSpawn = false
gui.IgnoreGuiInset = true
gui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
gui.DisplayOrder = 90
gui.Parent = CoreTarget

pcall(function()
	GuiService.AutoSelectGuiEnabled = false
	GuiService.SelectedObject = nil
	GuiService.SelectedCoreObject = nil
end)

local function lockCamera()
	-- No-op: el loader no debe bloquear ni manipular el mouse del juego
end

local function unlockCamera()
	-- No-op: el loader no debe desbloquear ni manipular el mouse del juego
end

local function releaseInput()
	-- No-op: no altera el estado del mouse al cerrar el loader
end

local teleportConnection = LocalPlayer.OnTeleport:Connect(function()
	running = false
	releaseInput()
	if teleportConnection then
		pcall(function()
			teleportConnection:Disconnect()
		end)
	end
	if gui then
		pcall(function()
			gui:Destroy()
		end)
	end
end)

local function playSound(id, pitch, volume)
	task.spawn(function()
		pcall(function()
			local sound = Instance.new("Sound")
			sound.SoundId = "rbxassetid://" .. tostring(id)
			sound.Pitch = pitch or 1
			sound.Volume = volume or 0.4
			sound.Parent = CoreTarget
			sound:Play()
			sound.Ended:Wait()
			sound:Destroy()
		end)
	end)
end

local function makeBlob(parent, x, y, w, h, color, round, rot)
	local frame = Instance.new("Frame", parent)
	frame.Size = UDim2.fromOffset(w, h)
	frame.Position = UDim2.fromOffset(x, y)
	frame.BackgroundColor3 = color
	frame.BorderSizePixel = 0
	frame.Rotation = rot or 0
	Instance.new("UICorner", frame).CornerRadius = round and UDim.new(1, 0) or UDim.new(0, 2)
	return frame
end

local function makeBunny(size, color)
	local root = Instance.new("Frame")
	root.Size = UDim2.fromOffset(size, size)
	root.BackgroundTransparency = 1
	local inner = color:Lerp(ROSE, 0.55)
	makeBlob(root, size * 0.22, size * 0.02, size * 0.17, size * 0.46, color, true, -10)
	makeBlob(root, size * 0.61, size * 0.02, size * 0.17, size * 0.46, color, true, 10)
	makeBlob(root, size * 0.27, size * 0.08, size * 0.07, size * 0.32, inner, true, -10)
	makeBlob(root, size * 0.66, size * 0.08, size * 0.07, size * 0.32, inner, true, 10)
	local head = makeBlob(root, size * 0.13, size * 0.42, size * 0.74, size * 0.74, color, true)
	Instance.new("UIGradient", head).Color = ColorSequence.new(Color3.new(1, 1, 1), color:Lerp(Color3.new(0, 0, 0), 0.06))
	local eye = Color3.fromRGB(70, 45, 70)
	makeBlob(root, size * 0.32, size * 0.68, size * 0.09, size * 0.09, eye, true)
	makeBlob(root, size * 0.59, size * 0.68, size * 0.09, size * 0.09, eye, true)
	local blush = Color3.fromRGB(255, 150, 180)
	makeBlob(root, size * 0.22, size * 0.78, size * 0.13, size * 0.08, blush, true)
	makeBlob(root, size * 0.65, size * 0.78, size * 0.13, size * 0.08, blush, true)
	makeBlob(root, size * 0.46, size * 0.83, size * 0.08, size * 0.06, blush, true)
	return root
end

local function makeHeart(size, color)
	local root = Instance.new("Frame")
	root.Size = UDim2.fromOffset(size, size)
	root.BackgroundTransparency = 1
	local square = size * 0.7
	local point = makeBlob(root, size * 0.5 - square / 2, size - square * 0.707 - square / 2, square, square, color, false, 45)
	local light = color:Lerp(Color3.new(1, 1, 1), 0.42)
	makeBlob(root, size * 0.04, size * 0.1, size * 0.5, size * 0.5, light, true)
	makeBlob(root, size * 0.46, size * 0.1, size * 0.5, size * 0.5, light, true)
	local glow = makeBlob(root, size * 0.2, size * 0.2, size * 0.2, size * 0.13, Color3.new(1, 1, 1), true, -35)
	glow.BackgroundTransparency = 0.55
	Instance.new("UIGradient", point).Color =
		ColorSequence.new(color:Lerp(Color3.new(1, 1, 1), 0.3), color:Lerp(Color3.new(0, 0, 0), 0.12))
	return root
end

local function playIntro()
	local intro = Instance.new("ScreenGui")
	intro.Name = "BunnyHub_Intro"
	intro.ResetOnSpawn = false
	intro.IgnoreGuiInset = true
	intro.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
	intro.DisplayOrder = 95
	intro.Parent = CoreTarget

	local backdrop = Instance.new("Frame", intro)
	backdrop.Size = UDim2.fromScale(1, 1)
	backdrop.BackgroundColor3 = Color3.fromRGB(10, 7, 15)
	backdrop.BorderSizePixel = 0
	backdrop.ZIndex = 10
	backdrop.Active = false
	pcall(function()
		backdrop.Interactable = false
	end)
	Instance.new("UIGradient", backdrop).Color = ColorSequence.new(
		Color3.fromRGB(24, 8, 26), Color3.fromRGB(10, 7, 15), Color3.fromRGB(30, 12, 34))

	local blur
	if CONFIG.Blur then
		pcall(function()
			blur = Instance.new("BlurEffect")
			blur.Size = 0
			blur.Name = "BunnyHubIntroBlur"
			blur.Parent = game:GetService("Lighting")
		end)
		if blur then
			tween(blur, 1.2, { Size = 40 }, Enum.EasingStyle.Sine, Enum.EasingDirection.InOut)
		end
	end

	local sweep = Instance.new("Frame", backdrop)
	sweep.Size = UDim2.new(1, 0, 0, 3)
	sweep.Position = UDim2.new(0, 0, -0.05, 0)
	sweep.BackgroundColor3 = PINK
	sweep.BackgroundTransparency = 0.55
	sweep.BorderSizePixel = 0
	sweep.ZIndex = 14

	local parts = {}
	local live = true

	task.spawn(function()
		local width, height = view.X, view.Y
		while live do
			for _, part in ipairs(parts) do
				part.y += part.speed / 60
				part.phase += 2 / 60
				if part.y > 1.06 then
					part.y, part.x = -0.06, math.random()
				end
				local drift = math.sin(part.phase) * part.sway
				part.frame.Position = UDim2.fromOffset((part.x + drift) * width, part.y * height)
				if part.spin ~= 0 and part.frame.Parent then
					part.frame.Rotation = (part.frame.Rotation + part.spin / 60) % 360
				end
			end
			task.wait()
		end
	end)

	task.spawn(function()
		while live and sweep.Parent do
			sweep.Position = UDim2.new(0, 0, -0.05, 0)
			local t = TweenService:Create(sweep, TweenInfo.new(2.6, Enum.EasingStyle.Linear), {
				Position = UDim2.new(0, 0, 1.05, 0),
			})
			t:Play()
			t.Completed:Wait()
		end
	end)

	local drift = Instance.new("Frame", backdrop)
	drift.Size = UDim2.fromScale(1, 1)
	drift.BackgroundTransparency = 1
	drift.ZIndex = 11
	for index = 1, 26 do
		local depth = (index % 4) / 3
		local size = 14 + depth * 22
		local holder = Instance.new("Frame", drift)
		holder.Size = UDim2.fromOffset(size, size)
		holder.BackgroundTransparency = 1
		holder.BorderSizePixel = 0
		local group = Instance.new("CanvasGroup", holder)
		group.Size = UDim2.fromScale(1, 1)
		group.BackgroundTransparency = 1
		group.BorderSizePixel = 0
		group.GroupTransparency = 0.25 + (1 - depth) * 0.3
		if index % 3 == 0 then
			makeBunny(size, Color3.fromRGB(255, 236, 244)).Parent = group
		else
			makeHeart(size, Color3.fromRGB(255, 140, 200)).Parent = group
		end
		parts[index] = {
			frame = holder,
			x = math.random(),
			y = math.random(),
			speed = 0.02 + depth * 0.03,
			sway = 0.012 + math.random() * 0.02,
			phase = math.random() * math.pi * 2,
			spin = -14 + math.random() * 28,
		}
	end

	local shake = { amount = 0 }

	local function screenShake(intensity, duration)
		shake.amount = intensity
		task.delay(duration or 0.3, function()
			shake.amount = 0
		end)
	end

	local function shockwave(color, expandTime, maxSize)
		local ring = Instance.new("Frame", backdrop)
		ring.AnchorPoint = Vector2.new(0.5, 0.5)
		ring.Size = UDim2.fromOffset(20, 20)
		ring.Position = UDim2.fromScale(0.5, 0.42)
		ring.BackgroundColor3 = color
		ring.BackgroundTransparency = 0.75
		ring.BorderSizePixel = 0
		ring.ZIndex = 13
		corner(ring, 999)
		tween(ring, expandTime or 0.7, {
			Size = UDim2.fromOffset(maxSize or 500, maxSize or 500),
			BackgroundTransparency = 1,
		}, Enum.EasingStyle.Exponential)
		task.delay((expandTime or 0.7) + 0.05, function()
			if ring.Parent then
				ring:Destroy()
			end
		end)
	end

	local function burst(count, color)
		for _ = 1, (count or 18) do
			local size = math.random(4, 12)
			local piece = makeBlob(drift, 0, 0, size, size, color, true)
			piece.Position = UDim2.fromScale(0.5, 0.42)
			piece.ZIndex = 13
			local angle = math.random() * math.pi * 2
			local distance = 90 + math.random() * 190
			tween(piece, 0.55 + math.random() * 0.35, {
				Position = UDim2.fromScale(0.5, 0.42) + UDim2.fromOffset(math.cos(angle) * distance, math.sin(angle) * distance),
				BackgroundTransparency = 1,
			}, Enum.EasingStyle.Quart)
			task.delay(1.1, function()
				if piece.Parent then
					piece:Destroy()
				end
			end)
		end
	end

	local startedAt = os.clock()
	local skipRequested = false
	local function requestSkip()
		if not running or not CONFIG.SkipIntro or skipRequested then
			return
		end
		if os.clock() - startedAt < 0.7 then
			return
		end
		skipRequested = true
	end

	local skipConnection = UserInputService.InputBegan:Connect(requestSkip)

	task.wait(0.7)
	local flash = Instance.new("Frame", backdrop)
	flash.Size = UDim2.fromScale(1, 1)
	flash.BackgroundColor3 = Color3.new(1, 1, 1)
	flash.BackgroundTransparency = 1
	flash.BorderSizePixel = 0
	flash.ZIndex = 40
	playSound("6895079853", 1.8, 0.9)
	screenShake(10, 0.3)
	tween(flash, 0.05, { BackgroundTransparency = 0.15 })
	task.wait(0.05)
	tween(flash, 0.18, { BackgroundTransparency = 0.7 }, Enum.EasingStyle.Quad, Enum.EasingDirection.In)
	task.wait(0.06)
	flash.BackgroundColor3 = PINK
	tween(flash, 0.02, { BackgroundTransparency = 0.1 })
	task.wait(0.03)
	tween(flash, 0.45, { BackgroundTransparency = 1 }, Enum.EasingStyle.Exponential)
	shockwave(ROSE, 0.7, 480)
	shockwave(PINK, 0.9, 660)
	task.wait(0.35)

	local diamond = Instance.new("Frame", backdrop)
	diamond.AnchorPoint = Vector2.new(0.5, 0.5)
	diamond.Size = UDim2.fromOffset(0, 0)
	diamond.Position = UDim2.fromScale(0.5, 0.38)
	diamond.BackgroundColor3 = PINK
	diamond.BackgroundTransparency = 0.92
	diamond.BorderSizePixel = 0
	diamond.Rotation = 180
	diamond.ZIndex = 13
	corner(diamond, 10)
	local diamondStroke = stroke(diamond, PINK, 2, 0.3)
	playSound("421058925", 1.6, 0.25)
	tweenBounce(diamond, 0.6, { Size = UDim2.fromOffset(118, 118), Rotation = 45 })
	task.spawn(function()
		while live and diamond.Parent do
			diamond.Rotation += 0.4
			task.wait()
		end
	end)
	task.wait(0.45)

	local function bracket(x, y, rotation)
		local mark = Instance.new("TextLabel", backdrop)
		mark.Size = UDim2.fromOffset(40, 40)
		mark.AnchorPoint = Vector2.new(0.5, 0.5)
		mark.Position = UDim2.new(0.5, x, 0.38, y)
		mark.BackgroundTransparency = 1
		mark.Text = "+"
		mark.TextColor3 = PINK
		mark.Font = Enum.Font.Code
		mark.TextSize = 28
		mark.TextTransparency = 0.25
		mark.Rotation = rotation
		mark.ZIndex = 16
		return mark
	end
	local tl = bracket(-170, -62, 0)
	local tr = bracket(170, -62, 90)
	local bl = bracket(-170, 62, 270)
	local br = bracket(170, 62, 180)
	playSound("421058925", 1.4, 0.18)
	tweenBounce(tl, 0.5, { Position = UDim2.new(0.5, -132, 0.38, -42) })
	tweenBounce(tr, 0.5, { Position = UDim2.new(0.5, 132, 0.38, -42) })
	tweenBounce(bl, 0.5, { Position = UDim2.new(0.5, -132, 0.38, 42) })
	tweenBounce(br, 0.5, { Position = UDim2.new(0.5, 132, 0.38, 42) })
	task.wait(0.45)
	tween(diamond, 0.4, {
		Size = UDim2.fromOffset(210, 210),
		BackgroundTransparency = 0.97,
		Rotation = 225,
	}, Enum.EasingStyle.Exponential)
	tween(diamondStroke, 0.4, { Transparency = 0.8 })

	local letters = {}
	local letterRow = Instance.new("Frame", backdrop)
	letterRow.Size = UDim2.fromOffset(660, 82)
	letterRow.AnchorPoint = Vector2.new(0.5, 0.5)
	letterRow.Position = UDim2.fromScale(0.5, 0.38)
	letterRow.BackgroundTransparency = 1
	letterRow.ZIndex = 18
	local layout = Instance.new("UIListLayout", letterRow)
	layout.FillDirection = Enum.FillDirection.Horizontal
	layout.HorizontalAlignment = Enum.HorizontalAlignment.Center
	layout.VerticalAlignment = Enum.VerticalAlignment.Center
	layout.Padding = UDim.new(0, 2)

	local glowText = Instance.new("TextLabel", backdrop)
	glowText.AnchorPoint = Vector2.new(0.5, 0.5)
	glowText.Size = UDim2.fromOffset(660, 92)
	glowText.Position = UDim2.fromScale(0.5, 0.38)
	glowText.BackgroundTransparency = 1
	glowText.Text = CONFIG.Maker
	glowText.TextColor3 = PINK
	glowText.Font = Enum.Font.GothamBlack
	glowText.TextSize = 66
	glowText.TextTransparency = 0.85
	glowText.ZIndex = 15
	glowText.Parent = backdrop

	task.spawn(function()
		while live and glowText.Parent do
			tween(glowText, 1.4, { TextTransparency = 0.74 }, Enum.EasingStyle.Sine, Enum.EasingDirection.InOut)
			task.wait(1.4)
			tween(glowText, 1.4, { TextTransparency = 0.9 }, Enum.EasingStyle.Sine, Enum.EasingDirection.InOut)
			task.wait(1.4)
		end
	end)

	playSound("156646291", 1.4, 0.45)
	for index = 1, #CONFIG.Maker do
		local letter = Instance.new("TextLabel", letterRow)
		letter.Size = UDim2.fromOffset(0, 82)
		letter.BackgroundTransparency = 1
		letter.Text = CONFIG.Maker:sub(index, index)
		letter.TextColor3 = TEXT
		letter.Font = Enum.Font.GothamBlack
		letter.TextSize = 66
		letter.TextTransparency = 1
		letter.ZIndex = 18
		stroke(letter, PINK, 2, 0.2)
		Instance.new("UIGradient", letter).Color = ColorSequence.new(ROSE, TEXT, PINK)
		letters[index] = letter
		playSound("421058925", 2 + index * 0.08, 0.08)
		tweenBounce(letter, 0.35, {
			Size = UDim2.fromOffset(74, 82),
			Position = UDim2.fromOffset(0, 0),
			TextTransparency = 0,
		})
		task.wait(0.06)
	end
	task.wait(0.18)
	shockwave(PINK, 0.6, 400)
	burst(22, PINK)
	screenShake(5, 0.2)
	task.wait(0.2)

	local handle = Instance.new("TextLabel", backdrop)
	handle.AnchorPoint = Vector2.new(0.5, 0.5)
	handle.Size = UDim2.fromOffset(360, 34)
	handle.Position = UDim2.new(0.5, 0, 0.53, 48)
	handle.BackgroundTransparency = 1
	handle.Text = "@" .. LocalPlayer.DisplayName
	handle.TextColor3 = PINK
	handle.Font = Enum.Font.GothamBold
	handle.TextSize = 24
	handle.TextTransparency = 1
	handle.ZIndex = 18
	handle.Parent = backdrop
	stroke(handle, PINK, 1.5, 0.4)

	local credit = Instance.new("TextLabel", backdrop)
	credit.AnchorPoint = Vector2.new(0.5, 0.5)
	credit.Size = UDim2.fromOffset(420, 22)
	credit.Position = UDim2.new(0.5, 0, 0.53, 66)
	credit.BackgroundTransparency = 1
	credit.Text = string.format("made by %s  ·  supported by %s", CONFIG.Maker, CONFIG.Support)
	credit.TextColor3 = MUTED
	credit.Font = Enum.Font.GothamMedium
	credit.TextSize = 14
	credit.TextTransparency = 1
	credit.ZIndex = 18
	credit.Parent = backdrop

	local underline = Instance.new("Frame", backdrop)
	underline.AnchorPoint = Vector2.new(0.5, 0.5)
	underline.Size = UDim2.fromOffset(0, 2)
	underline.Position = UDim2.new(0.5, 0, 0.53, 78)
	underline.BackgroundColor3 = PINK
	underline.BorderSizePixel = 0
	underline.ZIndex = 18
	underline.Parent = backdrop
	corner(underline, 999)
	local underlineGrad = Instance.new("UIGradient", underline)
	underlineGrad.Color = ColorSequence.new(PINK, ROSE, PINK)

	playSound("6895079853", 1.3, 0.25)
	tweenBounce(handle, 0.6, { Position = UDim2.new(0.5, 0, 0.53, 18), TextTransparency = 0 })
	tween(credit, 0.5, { Position = UDim2.new(0.5, 0, 0.53, 62), TextTransparency = 0.2 })
	tween(underline, 0.5, { Size = UDim2.fromOffset(300, 2) }, Enum.EasingStyle.Exponential)
	burst(10, ROSE)
	task.wait(0.35)

	local title = Instance.new("TextLabel", backdrop)
	title.AnchorPoint = Vector2.new(0.5, 0.5)
	title.Size = UDim2.fromOffset(0, 0)
	title.Position = UDim2.fromScale(0.5, 0.66)
	title.BackgroundTransparency = 1
	title.Text = CONFIG.HubName:upper():gsub(" ", "  ")
	title.TextColor3 = TEXT
	title.Font = Enum.Font.GothamBlack
	title.TextSize = 20
	title.TextTransparency = 1
	title.ZIndex = 18
	title.Parent = backdrop
	stroke(title, PINK, 1, 0.4)
	Instance.new("UIGradient", title).Color = ColorSequence.new(ROSE, TEXT, PINK)
	playSound("138081503", 1.1, 0.3)
	tweenBounce(title, 0.45, { Size = UDim2.fromOffset(280, 34), TextTransparency = 0 })

	local version = Instance.new("TextLabel", backdrop)
	version.AnchorPoint = Vector2.new(0.5, 0.5)
	version.Size = UDim2.fromOffset(160, 16)
	version.Position = UDim2.new(0.5, 0, 0.66, 26)
	version.BackgroundTransparency = 1
	version.Text = "v" .. CONFIG.Version
	version.TextColor3 = MUTED
	version.Font = Enum.Font.GothamMedium
	version.TextSize = 11
	version.TextTransparency = 1
	version.ZIndex = 18
	version.Parent = backdrop
	task.wait(0.2)
	tween(version, 0.3, { TextTransparency = 0.3 })
	task.wait(0.3)

	local bar = Instance.new("Frame", backdrop)
	bar.AnchorPoint = Vector2.new(0.5, 0.5)
	bar.Size = UDim2.fromOffset(0, 4)
	bar.Position = UDim2.fromScale(0.5, 0.78)
	bar.BackgroundColor3 = Color3.fromRGB(30, 22, 36)
	bar.BorderSizePixel = 0
	bar.ClipsDescendants = true
	bar.ZIndex = 18
	bar.Parent = backdrop
	corner(bar, 999)
	stroke(bar, PINK, 1, 0.7)

	local fill = Instance.new("Frame", bar)
	fill.Size = UDim2.fromScale(0, 1)
	fill.BackgroundColor3 = PINK
	fill.BorderSizePixel = 0
	fill.ZIndex = 19
	fill.Parent = bar
	corner(fill, 999)
	local fillGrad = Instance.new("UIGradient", fill)
	fillGrad.Color = ColorSequence.new(HOT, ROSE, ROSE, HOT)

	local status = Instance.new("TextLabel", backdrop)
	status.AnchorPoint = Vector2.new(0.5, 0.5)
	status.Size = UDim2.fromOffset(400, 20)
	status.Position = UDim2.fromScale(0.5, 0.82)
	status.BackgroundTransparency = 1
	status.Text = ""
	status.TextColor3 = MUTED
	status.Font = Enum.Font.GothamMedium
	status.TextSize = 12
	status.ZIndex = 18
	status.Parent = backdrop

	local banner = Instance.new("TextLabel", backdrop)
	banner.AnchorPoint = Vector2.new(0.5, 0.5)
	banner.Size = UDim2.fromOffset(320, 20)
	banner.Position = UDim2.fromScale(0.5, 0.88)
	banner.BackgroundTransparency = 1
	banner.Text = CONFIG.SkipIntro and "press anything to skip" or ""
	banner.TextColor3 = LINE
	banner.Font = Enum.Font.Gotham
	banner.TextSize = 11
	banner.TextTransparency = 0.4
	banner.ZIndex = 18
	banner.Parent = backdrop

	tween(bar, 0.5, { Size = UDim2.fromOffset(300, 4) }, Enum.EasingStyle.Exponential)
	task.wait(0.45)

	local steps = {
		"> Connecting to Bunny Hub servers...",
		"> Authenticating user: " .. LocalPlayer.DisplayName,
		"> Whitelist verified.",
		string.format("> Made by %s.", CONFIG.Maker),
		string.format("> Supported by %s.", CONFIG.Support),
		"> Loading UI components...",
		"> Initializing modules...",
		"> Ready.",
	}
	for index, step in ipairs(steps) do
		if skipRequested then
			break
		end
		status.Text = step
		playSound("421058925", 1.2 + math.random() * 0.4, 0.07)
		tween(fill, 0.32, { Size = UDim2.fromScale(index / #steps, 1) }, Enum.EasingStyle.Sine)
		task.wait(0.34)
	end

	status.Text = string.format(">> Welcome, %s! <<", LocalPlayer.DisplayName)
	status.TextColor3 = GOOD
	status.TextSize = 14
	banner.Text = ""
	playSound("2865228021", 1, 0.45)
	tween(fill, 0.25, { BackgroundColor3 = GOOD })
	local welcome = Instance.new("Frame", backdrop)
	welcome.Size = UDim2.fromScale(1, 1)
	welcome.BackgroundColor3 = GOOD
	welcome.BackgroundTransparency = 0.9
	welcome.BorderSizePixel = 0
	welcome.ZIndex = 30
	welcome.Parent = backdrop
	tween(welcome, 0.7, { BackgroundTransparency = 1 }, Enum.EasingStyle.Exponential)
	shockwave(GOOD, 0.6, 480)
	burst(14, GOOD)
	task.wait(0.9)
	if welcome.Parent then
		welcome:Destroy()
	end

	live = false
	local fadeOut = Enum.EasingStyle.Cubic
	for _, letter in ipairs(letters) do
		tween(letter, 0.9, { TextTransparency = 1 }, fadeOut, Enum.EasingDirection.Out)
	end
	for _, mark in ipairs({ tl, tr, bl, br, glowText, handle, credit, title, version, status }) do
		if mark and mark.Parent then
			tween(mark, 0.9, { TextTransparency = 1 }, fadeOut, Enum.EasingDirection.Out)
		end
	end
	for _, piece in ipairs({ bar, sweep }) do
		if piece and piece.Parent then
			tween(piece, 0.9, { BackgroundTransparency = 1 }, fadeOut, Enum.EasingDirection.Out)
		end
	end
	tween(underline, 0.6, { BackgroundTransparency = 1 })
	tween(backdrop, 0.9, { BackgroundTransparency = 1 }, fadeOut, Enum.EasingDirection.Out)
	if blur then
		tween(blur, 0.9, { Size = 0 })
	end
	task.wait(0.95)
	live = false
	if skipConnection then
		pcall(function()
			skipConnection:Disconnect()
		end)
	end
	for _, part in ipairs(parts) do
		if part.frame.Parent then
			part.frame:Destroy()
		end
	end
	if intro.Parent then
		intro:Destroy()
	end
	if blur and blur.Parent then
		blur:Destroy()
	end
end

local introRunning = false
if CONFIG.Intro then
	task.spawn(function()
		introRunning = true
		playIntro()
		introRunning = false
	end)
end

local dimmer = Instance.new("Frame", gui)
dimmer.Size = UDim2.fromScale(1, 1)
dimmer.BackgroundColor3 = Color3.new(0, 0, 0)
dimmer.BackgroundTransparency = 0.35
dimmer.BorderSizePixel = 0
dimmer.ZIndex = 0
dimmer.Active = false
pcall(function()
	dimmer.Interactable = false
end)
lockCamera()

local main = Instance.new("Frame", gui)
main.Size = UDim2.fromOffset(panelW, panelH)
main.AnchorPoint = Vector2.new(0.5, 0.5)
main.Position = UDim2.fromScale(0.5, 0.5)
main.BackgroundColor3 = INK
main.BorderSizePixel = 0
main.Visible = false
main.ZIndex = 2
corner(main, 18)
local mainStroke = stroke(main, PINK, 1.2, 0.8)
local wash = Instance.new("UIGradient", main)
wash.Color = ColorSequence.new(PINK:Lerp(INK, 0.78), PINK:Lerp(INK, 0.93))
wash.Rotation = 118

local scale = Instance.new("UIScale", main)
scale.Scale = 1

local function reveal()
	if not running or main.Visible then
		return
	end
	main.Visible = true
	main.BackgroundTransparency = 1
	scale.Scale = 0.9
	tweenBounce(scale, 0.45, { Scale = 1 })
	tween(main, 0.3, { BackgroundTransparency = 0 })
	tween(mainStroke, 0.4, { Transparency = 0.45, Color = PINK })
	tween(dimmer, 0.35, { BackgroundTransparency = 0.35 })
	unlockCamera()
end

local side = Instance.new("Frame", main)
side.Size = phone and UDim2.new(1, -12, 0, 92) or UDim2.new(0, sideW, 1, -12)
side.Position = UDim2.fromOffset(6, 6)
side.BackgroundColor3 = SIDE
side.BorderSizePixel = 0
side.ZIndex = 3
corner(side, 14)

local logo = Instance.new("ImageLabel", side)
logo.Size = UDim2.fromOffset(phone and 44 or 40, phone and 44 or 40)
logo.Position = phone and UDim2.fromOffset(12, 24) or UDim2.fromOffset(16, 16)
logo.BackgroundColor3 = PINK
logo.BackgroundTransparency = 1
logo.ScaleType = Enum.ScaleType.Fit
logo.Image = "rbxassetid://" .. tostring(CONFIG.HubImage:match("(%d+)") or 0)
logo.ZIndex = 4
corner(logo, 12)

local brand = Instance.new("TextLabel", side)
brand.BackgroundTransparency = 1
brand.Size = phone and UDim2.new(1, -150, 0, 20) or UDim2.new(1, -16, 0, 22)
brand.Position = phone and UDim2.fromOffset(64, 24) or UDim2.fromOffset(16, 60)
brand.Font = Enum.Font.GothamBold
brand.TextSize = TYPE.title
brand.TextXAlignment = Enum.TextXAlignment.Left
brand.TextColor3 = TEXT
brand.Text = CONFIG.HubName
brand.ZIndex = 4

local brandVersion = Instance.new("TextLabel", side)
brandVersion.BackgroundTransparency = 1
brandVersion.Size = phone and UDim2.new(1, -150, 0, 16) or UDim2.new(1, -16, 0, 16)
brandVersion.Position = phone and UDim2.fromOffset(64, 44) or UDim2.fromOffset(16, 82)
brandVersion.Font = Enum.Font.GothamMedium
brandVersion.TextSize = TYPE.caption
brandVersion.TextXAlignment = Enum.TextXAlignment.Left
brandVersion.TextColor3 = PINK
brandVersion.Text = "v" .. CONFIG.Version
brandVersion.ZIndex = 4

if not phone then
	local userCard = Instance.new("Frame", side)
	userCard.Size = UDim2.new(1, -16, 0, 52)
	userCard.Position = UDim2.fromOffset(8, panelH - 12 - 52 - 58)
	userCard.BackgroundColor3 = CARD
	userCard.BorderSizePixel = 0
	userCard.ZIndex = 3
	corner(userCard, 10)

	local avatar = Instance.new("ImageLabel", userCard)
	avatar.Size = UDim2.fromOffset(32, 32)
	avatar.Position = UDim2.fromOffset(10, 10)
	avatar.BackgroundColor3 = PINK
	avatar.Image = "rbxthumb://type=AvatarHeadShot&id=" .. tostring(LocalPlayer.UserId) .. "&w=150&h=150"
	avatar.ScaleType = Enum.ScaleType.Crop
	avatar.ZIndex = 4
	corner(avatar, 999)
	stroke(avatar, PINK, 1.5, 0.2)

	local userName = Instance.new("TextLabel", userCard)
	userName.BackgroundTransparency = 1
	userName.Size = UDim2.new(1, -56, 0, 18)
	userName.Position = UDim2.fromOffset(50, 8)
	userName.Font = Enum.Font.GothamBold
	userName.TextSize = TYPE.small
	userName.TextXAlignment = Enum.TextXAlignment.Left
	userName.TextColor3 = TEXT
	userName.Text = LocalPlayer.DisplayName
	userName.TextTruncate = Enum.TextTruncate.AtEnd
	userName.ZIndex = 4

	local userFoot = Instance.new("TextLabel", userCard)
	userFoot.BackgroundTransparency = 1
	userFoot.Size = UDim2.new(1, -56, 0, 14)
	userFoot.Position = UDim2.fromOffset(50, 26)
	userFoot.Font = Enum.Font.Gotham
	userFoot.TextSize = TYPE.caption
	userFoot.TextXAlignment = Enum.TextXAlignment.Left
	userFoot.TextColor3 = MUTED
	userFoot.Text = "@" .. LocalPlayer.Name
	userFoot.TextTruncate = Enum.TextTruncate.AtEnd
	userFoot.ZIndex = 4

	local credits = Instance.new("TextLabel", side)
	credits.BackgroundTransparency = 1
	credits.Size = UDim2.new(1, -16, 0, 40)
	credits.Position = UDim2.fromOffset(8, panelH - 12 - 40)
	credits.Font = Enum.Font.Gotham
	credits.TextSize = TYPE.caption
	credits.TextWrapped = true
	credits.TextColor3 = MUTED
	credits.TextXAlignment = Enum.TextXAlignment.Left
	credits.TextYAlignment = Enum.TextYAlignment.Top
	credits.Text = string.format("made by %s\nsupported by %s", CONFIG.Maker, CONFIG.Support)
	credits.ZIndex = 4
end

if phone then
	local creditLine = Instance.new("TextLabel", side)
	creditLine.BackgroundTransparency = 1
	creditLine.Size = UDim2.new(1, -70, 0, 20)
	creditLine.Position = UDim2.fromOffset(62, 62)
	creditLine.Font = Enum.Font.Gotham
	creditLine.TextSize = TYPE.caption
	creditLine.TextWrapped = true
	creditLine.TextColor3 = MUTED
	creditLine.TextXAlignment = Enum.TextXAlignment.Left
	creditLine.TextYAlignment = Enum.TextYAlignment.Top
	creditLine.Text = string.format("%s  ·  %s", CONFIG.Maker, CONFIG.Support)
	creditLine.ZIndex = 4
end

local content = Instance.new("Frame", main)
content.BackgroundColor3 = Color3.fromRGB(18, 17, 21)
content.Size = phone and UDim2.new(1, -12, 1, -104) or UDim2.new(1, -(sideW + 16), 1, -12)
content.Position = phone and UDim2.fromOffset(6, 100) or UDim2.fromOffset(sideW + 10, 6)
content.BorderSizePixel = 0
content.ZIndex = 3
corner(content, 14)
stroke(content, LINE, 1, 0.8)

local pageTitle = Instance.new("TextLabel", content)
pageTitle.BackgroundTransparency = 1
pageTitle.Size = UDim2.new(1, -36, 0, phone and 24 or 30)
pageTitle.Position = UDim2.fromOffset(18, 12)
pageTitle.Font = Enum.Font.GothamBold
pageTitle.TextSize = phone and TYPE.heading or TYPE.display
pageTitle.TextXAlignment = Enum.TextXAlignment.Left
pageTitle.TextColor3 = TEXT
pageTitle.Text = "Welcome to " .. CONFIG.HubName .. "!"
pageTitle.ZIndex = 4

local pageStatus = Instance.new("TextLabel", content)
pageStatus.BackgroundTransparency = 1
pageStatus.Size = UDim2.new(1, -36, 0, 18)
pageStatus.Position = UDim2.fromOffset(18, phone and 38 or 44)
pageStatus.Font = Enum.Font.Gotham
pageStatus.TextSize = TYPE.body
pageStatus.TextXAlignment = Enum.TextXAlignment.Left
pageStatus.TextColor3 = MUTED
pageStatus.Text = CONFIG.StatusMessage
pageStatus.ZIndex = 4

local clockLabel = Instance.new("TextLabel", content)
clockLabel.BackgroundTransparency = 1
clockLabel.Size = UDim2.fromOffset(150, 18)
clockLabel.Position = UDim2.new(1, -168, 0, 16)
clockLabel.Font = Enum.Font.GothamMedium
clockLabel.TextSize = TYPE.small
clockLabel.TextXAlignment = Enum.TextXAlignment.Right
clockLabel.TextColor3 = PINK
clockLabel.Text = ""
clockLabel.ZIndex = 4

local page = Instance.new("ScrollingFrame", content)
page.BackgroundTransparency = 1
page.BorderSizePixel = 0
page.Size = UDim2.new(1, -24, 1, -(phone and 66 or 70))
page.Position = UDim2.fromOffset(12, phone and 62 or 66)
page.CanvasSize = UDim2.new()
page.AutomaticCanvasSize = Enum.AutomaticSize.Y
page.ScrollBarThickness = 3
page.ScrollBarImageColor3 = PINK
page.ScrollingEnabled = true
page.ZIndex = 4

local columns = Instance.new("Frame", page)
columns.BackgroundTransparency = 1
columns.Size = UDim2.new(1, 0, 0, 0)
columns.AutomaticSize = Enum.AutomaticSize.Y
columns.ZIndex = 4
local columnsLayout = Instance.new("UIListLayout", columns)
columnsLayout.FillDirection = phone and Enum.FillDirection.Vertical or Enum.FillDirection.Horizontal
columnsLayout.Padding = UDim.new(0, 8)

local function column()
	local frame = Instance.new("Frame", columns)
	frame.BackgroundTransparency = 1
	frame.Size = phone and UDim2.new(1, 0, 0, 0) or UDim2.new(0.5, -4, 0, 0)
	frame.AutomaticSize = Enum.AutomaticSize.Y
	frame.ZIndex = 4
	Instance.new("UIListLayout", frame).Padding = UDim.new(0, 8)
	return frame
end
local left, right = column(), column()

local function card(parent, titleText)
	local frame = Instance.new("Frame", parent)
	frame.Size = UDim2.new(1, 0, 0, 0)
	frame.AutomaticSize = Enum.AutomaticSize.Y
	frame.BackgroundColor3 = CARD
	frame.BorderSizePixel = 0
	frame.ZIndex = 4
	corner(frame, 14)
	local edge = stroke(frame, LINE, 1, 0.45)
	frame.MouseEnter:Connect(function()
		tween(edge, 0.22, { Color = PINK, Transparency = 0.12 })
		tween(frame, 0.22, { BackgroundColor3 = CARD:Lerp(PINK, 0.07) })
	end)
	frame.MouseLeave:Connect(function()
		tween(edge, 0.22, { Color = LINE, Transparency = 0.45 })
		tween(frame, 0.22, { BackgroundColor3 = CARD })
	end)
	local pad = Instance.new("UIPadding", frame)
	pad.PaddingTop = UDim.new(0, 12)
	pad.PaddingBottom = UDim.new(0, 12)
	pad.PaddingLeft = UDim.new(0, 12)
	pad.PaddingRight = UDim.new(0, 12)
	local layout = Instance.new("UIListLayout", frame)
	layout.Padding = UDim.new(0, 8)
	if titleText then
		local heading = Instance.new("TextLabel", frame)
		heading.LayoutOrder = -1
		heading.BackgroundTransparency = 1
		heading.Size = UDim2.new(1, 0, 0, 20)
		heading.Font = Enum.Font.GothamBold
		heading.TextSize = TYPE.heading
		heading.TextXAlignment = Enum.TextXAlignment.Left
		heading.TextColor3 = TEXT
		heading.Text = titleText
		heading.ZIndex = 5
	end
	return frame
end

local function row(parent, height)
	local frame = Instance.new("Frame", parent)
	frame.Size = UDim2.new(1, 0, 0, height or 30)
	frame.BackgroundTransparency = 1
	frame.BorderSizePixel = 0
	frame.ZIndex = 5
	return frame
end

local function label(parent, text, height, color, wrapped, textSize)
	local line = Instance.new("TextLabel", parent)
	line.BackgroundTransparency = 1
	line.Size = UDim2.new(1, 0, 0, height or 18)
	if wrapped then
		line.AutomaticSize = Enum.AutomaticSize.Y
	end
	line.Font = wrapped and Enum.Font.Gotham or Enum.Font.GothamMedium
	line.TextSize = textSize or TYPE.small
	line.TextWrapped = wrapped == true
	line.TextXAlignment = Enum.TextXAlignment.Left
	line.TextYAlignment = wrapped and Enum.TextYAlignment.Top or Enum.TextYAlignment.Center
	line.TextColor3 = color or MUTED
	line.Text = tostring(text or "")
	line.ZIndex = 5
	return line
end

local function chip(parent, text, back, color)
	local holder = row(parent, 22)
	local pill = Instance.new("TextLabel", holder)
	pill.Size = UDim2.new(1, 0, 1, 0)
	pill.BackgroundColor3 = back
	pill.Font = Enum.Font.GothamMedium
	pill.TextSize = TYPE.caption
	pill.TextColor3 = color
	pill.Text = text
	pill.ZIndex = 6
	corner(pill, 8)
	return pill
end

local function button(parent, text, primary, click, size)
	local touch = Instance.new("TextButton", parent)
	touch.Size = size or UDim2.new(1, 0, 0, 34)
	touch.BackgroundColor3 = primary and PINK or Color3.fromRGB(28, 26, 32)
	touch.Font = Enum.Font.GothamMedium
	touch.TextSize = TYPE.body
	touch.TextColor3 = primary and Color3.fromRGB(40, 12, 28) or TEXT
	touch.Text = text
	touch.AutoButtonColor = false
	touch.ZIndex = 6
	corner(touch, 10)
	if primary then
		Instance.new("UIGradient", touch).Color = ColorSequence.new(ROSE, HOT)
		touch.TextColor3 = Color3.fromRGB(40, 12, 28)
	else
		stroke(touch, LINE, 1, 0.3)
	end

	local base = touch.Size
	local function inset(x, y)
		return UDim2.new(base.X.Scale, base.X.Offset - x, base.Y.Scale, base.Y.Offset - y)
	end
	touch.MouseEnter:Connect(function()
		tween(touch, 0.16, {
			BackgroundColor3 = primary and HOT or Color3.fromRGB(40, 34, 48),
			Size = inset(3, 2),
		})
	end)
	touch.MouseLeave:Connect(function()
		tween(touch, 0.16, {
			BackgroundColor3 = primary and PINK or Color3.fromRGB(28, 26, 32),
			Size = base,
		})
	end)
	touch.MouseButton1Click:Connect(function()
		tweenBounce(touch, 0.14, { Size = inset(5, 4) })
		task.delay(0.14, function()
			tweenBounce(touch, 0.16, { Size = base })
		end)
		click()
	end)
	return touch
end

local verifying, hidden = false, false
local setStatus, setBusy, verify, setHidden

local keyCard = card(left, "Your key")
local statusBox = Instance.new("Frame", keyCard)
statusBox.Size = UDim2.new(1, 0, 0, 38)
statusBox.BackgroundColor3 = Color3.fromRGB(24, 20, 30)
statusBox.BorderSizePixel = 0
statusBox.ZIndex = 5
corner(statusBox, 10)
stroke(statusBox, LINE, 1, 0.5)
local statusDot = Instance.new("Frame", statusBox)
statusDot.Size = UDim2.fromOffset(8, 8)
statusDot.Position = UDim2.fromOffset(12, 15)
statusDot.BackgroundColor3 = PINK
statusDot.BorderSizePixel = 0
statusDot.ZIndex = 6
corner(statusDot, 999)
local statusText = Instance.new("TextLabel", statusBox)
statusText.BackgroundTransparency = 1
statusText.Size = UDim2.new(1, -34, 1, 0)
statusText.Position = UDim2.fromOffset(28, 0)
statusText.Font = Enum.Font.GothamMedium
statusText.TextSize = TYPE.body
statusText.TextXAlignment = Enum.TextXAlignment.Left
statusText.TextColor3 = PINK
statusText.Text = CONFIG.StatusMessage
statusText.ZIndex = 6

local inputBox = Instance.new("Frame", keyCard)
inputBox.Size = UDim2.new(1, 0, 0, 40)
inputBox.BackgroundColor3 = Color3.fromRGB(22, 20, 26)
inputBox.BorderSizePixel = 0
inputBox.ZIndex = 5
corner(inputBox, 10)
local inputEdge = stroke(inputBox, LINE, 1, 0.3)

local inputBoxLabel = Instance.new("TextLabel", inputBox)
inputBoxLabel.BackgroundTransparency = 1
inputBoxLabel.Size = UDim2.fromOffset(60, 40)
inputBoxLabel.Position = UDim2.fromOffset(14, 0)
inputBoxLabel.Font = Enum.Font.GothamBold
inputBoxLabel.TextSize = TYPE.small
inputBoxLabel.TextXAlignment = Enum.TextXAlignment.Left
inputBoxLabel.TextColor3 = MUTED
inputBoxLabel.Text = "KEY"
inputBoxLabel.ZIndex = 6

local inputBoxIcon = Instance.new("TextLabel", inputBox)
inputBoxIcon.BackgroundTransparency = 1
inputBoxIcon.Size = UDim2.fromOffset(20, 40)
inputBoxIcon.Position = UDim2.new(1, -28, 0, 0)
inputBoxIcon.Font = Enum.Font.GothamBold
inputBoxIcon.TextSize = TYPE.body
inputBoxIcon.TextColor3 = LINE
inputBoxIcon.Text = ">"
inputBoxIcon.ZIndex = 6

local input = Instance.new("TextBox", inputBox)
input.Size = UDim2.new(1, -122, 1, 0)
input.Position = UDim2.fromOffset(86, 0)
input.BackgroundTransparency = 1
input.Text = ""
input.PlaceholderText = "Enter your key"
input.TextColor3 = TEXT
input.PlaceholderColor3 = LINE
input.Font = Enum.Font.Gotham
input.TextSize = TYPE.body
input.ClearTextOnFocus = false
input.TextXAlignment = Enum.TextXAlignment.Left
input.ZIndex = 6

input.Focused:Connect(function()
	tween(inputEdge, 0.18, { Color = PINK, Transparency = 0 })
	tween(inputBox, 0.18, { BackgroundColor3 = Color3.fromRGB(32, 26, 40) })
end)
input.FocusLost:Connect(function()
	tween(inputEdge, 0.18, { Color = LINE, Transparency = 0.3 })
	tween(inputBox, 0.18, { BackgroundColor3 = Color3.fromRGB(22, 20, 26) })
end)

local redeemButton = button(keyCard, "Redeem key", true, function()
	verify(input.Text:gsub("%s+", ""):upper())
end)
button(keyCard, "Get key", false, function()
	if copyToClipboard(CONFIG.KeyLink) then
		setStatus("Link copied. Paste it in your browser.", false)
		notify(CONFIG.HubName, "Link copied! Paste it in your browser.", 3)
	else
		setStatus("Copy failed. Open the link yourself.", true)
	end
end)

local sessionCard = card(left, "Session")
label(sessionCard, LocalPlayer.DisplayName, 24, TEXT, false, TYPE.title)
label(sessionCard, "@" .. LocalPlayer.Name, 16, MUTED, false, TYPE.caption)
local placeLabel = label(sessionCard, "Connecting to place...", 18, MUTED, true)
local statRow = row(sessionCard, 40)
local function statBlock(xScale, captionText, color)

	local value = label(statRow, "-", 22, color or TEXT, false, TYPE.body)
	value.Size = UDim2.new(1 / 3, -8, 0, 22)
	value.Position = UDim2.new(xScale, 0, 0, 0)
	local caption = label(statRow, captionText, 14, MUTED, false, TYPE.caption)
	caption.Size = UDim2.new(1 / 3, -8, 0, 14)
	caption.Position = UDim2.new(xScale, 0, 0, 24)
	return value
end
local statPlayers = statBlock(0, "PLAYERS", GOOD)
local statPing = statBlock(1 / 3, "PING", Color3.fromRGB(255, 176, 96))
local statFps = statBlock(2 / 3, "FPS")

local infoCard = card(right, "This place")
local infoExecutor = chip(infoCard, "Executor: -", Color3.fromRGB(36, 32, 42), TEXT)
local infoPlatform = chip(infoCard, "Platform: -", Color3.fromRGB(36, 32, 42), TEXT)
chip(infoCard, "HWID: Protected", Color3.fromRGB(28, 48, 40), GOOD)

local changelogCard = card(right, "Changelog")
local scroll = Instance.new("ScrollingFrame", changelogCard)
scroll.Size = UDim2.new(1, 0, 0, 190)
scroll.BackgroundTransparency = 1
scroll.BorderSizePixel = 0

scroll.CanvasSize = UDim2.fromOffset(0, 250)
scroll.ScrollBarThickness = 3
scroll.ScrollBarImageColor3 = PINK
scroll.ZIndex = 5
local changelog = Instance.new("TextLabel", scroll)
changelog.Size = UDim2.new(1, -10, 0, 240)
changelog.BackgroundTransparency = 1
changelog.Font = Enum.Font.Gotham
changelog.TextSize = TYPE.caption
changelog.TextColor3 = MUTED
changelog.TextXAlignment = Enum.TextXAlignment.Left
changelog.TextYAlignment = Enum.TextYAlignment.Top
changelog.TextWrapped = true
changelog.Text = table.concat({
	string.format("v%s  ·  now", CONFIG.Version),
	"• Key gate rebuilt in the Bunny Hub window style",
	"• Cinematic intro: flash, diamond, credits, loading bar",
	string.format("• Made by %s · supported by %s", CONFIG.Maker, CONFIG.Support),
	"",
	"v3.0",
	"• Bunny Hub window: themes, weather, decor, configs",
}, "\n")
changelog.ZIndex = 5

local premiumRow = row(right, 40)
local premiumText = Instance.new("TextLabel", premiumRow)
premiumText.Size = UDim2.new(1, -128, 1, 0)
premiumText.BackgroundTransparency = 1
premiumText.Font = Enum.Font.GothamMedium
premiumText.TextSize = TYPE.caption
premiumText.TextXAlignment = Enum.TextXAlignment.Left
premiumText.TextColor3 = MUTED
premiumText.Text = "Need more? Ask in the Discord."
premiumText.ZIndex = 5
button(premiumRow, "Premium", true, function()
	if copyToClipboard(CONFIG.KeyLink) then
		setStatus("Premium link copied.", false)
	else
		setStatus("Copy failed. Open the link yourself.", true)
	end
end, UDim2.new(0, 116, 0, 32)).Position = UDim2.new(1, -116, 0, 4)

local bottomRow = row(right, 34)
button(bottomRow, "Hide", false, function()
	setHidden(true)
end, UDim2.new(0.5, -4, 1, 0))
button(bottomRow, "Unload", false, function()
	running = false
	releaseInput()
	if teleportConnection then
		pcall(function()
			teleportConnection:Disconnect()
		end)
	end
	if gui then
		gui:Destroy()
	end
end, UDim2.new(0.5, -4, 1, 0)).Position = UDim2.new(0.5, 4, 0, 0)

local function showStatus(text, isError, isGood)
	if not running then
		return
	end
	statusText.Text = tostring(text)
	statusText.TextColor3 = isError and BAD or isGood and GOOD or PINK
	statusDot.BackgroundColor3 = statusText.TextColor3
	pageStatus.Text = tostring(text)
	pageStatus.TextColor3 = isError and BAD or MUTED
end

setStatus = showStatus

setBusy = function(busy)
	verifying = busy
	redeemButton.Text = busy and "Verifying..." or "Redeem key"
	pageTitle.Text = busy and "Checking your key" or ("Welcome to " .. CONFIG.HubName .. "!")
end

local function forgetKey()
	pcall(function()
		if type(isfile) == "function" and isfile(keyFile) then
			if type(delfile) == "function" then
				delfile(keyFile)
			elseif type(writefile) == "function" then
				writefile(keyFile, "")
			end
		end
	end)
end

local function reportError(code)
	setBusy(false)
	if code == "KEY_EXPIRED" then
		forgetKey()
		input.Text = ""
		setStatus("Your key expired. Press Get key for a new one.", true)
	elseif code == "KEY_INVALID" then
		setStatus("That key is invalid or disabled.", true)
	else
		setStatus("This environment is unavailable. Contact support.", true)
	end
end

local function launch(payload)
	setBusy(false)
	setStatus("Key verified. Loading " .. CONFIG.HubName .. "…", false, true)
	pcall(function()
		if type(writefile) == "function" then
			writefile(keyFile, payload.key or "")
		end
	end)
	running = false
	if teleportConnection then
		pcall(function()
			teleportConnection:Disconnect()
		end)
	end
	releaseInput()
	tween(main, 0.35, { BackgroundTransparency = 1 }, Enum.EasingStyle.Quad, Enum.EasingDirection.In)
	tween(dimmer, 0.35, { BackgroundTransparency = 1 }, Enum.EasingStyle.Quad, Enum.EasingDirection.In)
	task.delay(0.4, function()
		if gui then
			gui:Destroy()
		end
		local handed = pcall(function()
			loadstring(payload.body)()
		end)
		if not handed then
			warn("[Bunny Hub] the server payload failed: " .. tostring(payload.body))
		end
	end)
end

verify = function(enteredKey)
	if verifying or not running then
		return
	end
	if enteredKey == "" then
		setStatus("Enter a key first.", true)
		pcall(function()
			input:CaptureFocus()
		end)
		return
	end

	setBusy(true)
	setStatus("Contacting Bunny Hub servers…", false)

	task.spawn(function()
		local url = string.format(
			"%s/api/v1/validate-environment?key=%s&envId=%s&robloxId=%d",
			RENDER_URL, enteredKey, tostring(game.PlaceId), LocalPlayer.UserId)

		local reached, result = pcall(function()
			return game:HttpGet(url)
		end)

		if not running then
			return
		end
		if not reached then
			setBusy(false)
			setStatus("Could not reach the server. Check your connection.", true)
			return
		end

		local code = tostring(result):match("^%s*%-%-%s*%[ERROR%]%s*:%s*([%w_]+)")
		if code then
			reportError(code)
			return
		end

		launch({ key = enteredKey, body = result })
	end)
end

task.spawn(function()
	while running and introRunning do
		task.wait(0.05)
	end
	if running then
		task.wait(0.15)
		reveal()
	end
end)

task.spawn(function()
	pcall(function()
		if type(isfile) == "function" and type(readfile) == "function" and isfile(keyFile) then
			local saved = readfile(keyFile)
			if type(saved) == "string" then
				local key = saved:gsub("%s+", ""):upper()
				if key ~= "" then
					input.Text = key
					setStatus("Saved key found. Verifying…", false)
					verify(key)
				end
			end
		end
	end)
end)

task.spawn(function()
	local executor = "Unknown"
	pcall(function()
		if type(identifyexecutor) == "function" then
			executor = tostring(identifyexecutor())
		end
	end)
	infoExecutor.Text = "Executor: " .. executor
	infoPlatform.Text = "Platform: " .. (UserInputService.TouchEnabled and "Mobile" or "PC")
	task.spawn(function()
		local okInfo, info = pcall(function()
			return MarketplaceService:GetProductInfo(game.PlaceId)
		end)
		if not running or not okInfo or type(info) ~= "table" then
			return
		end
		placeLabel.Text = tostring(info.Name or "Unknown place")
		if info.Creator and info.Creator.Name then
			placeLabel.Text = placeLabel.Text .. "  ·  by " .. tostring(info.Creator.Name)
		end
	end)
end)

local fpsSmooth, pingSmooth, clock = 60, 0, 0
RunService.Heartbeat:Connect(function(dt)
	if not running then
		return
	end
	local ping = 0
	pcall(function()
		ping = LocalPlayer:GetNetworkPing() * 1000
	end)
	fpsSmooth = fpsSmooth * 0.85 + (1 / math.max(dt, 1 / 240)) * 0.15
	pingSmooth = pingSmooth * 0.85 + ping * 0.15
	clock += dt
	if clock < 0.5 then
		if running and main and not main.Visible then
			lockCamera()
		end
		return
	end
	clock = 0
	if running and main and not main.Visible then
		lockCamera()
	end
	statFps.Text = tostring(math.floor(fpsSmooth + 0.5))
	statPing.Text = tostring(math.floor(pingSmooth + 0.5)) .. "ms"
	local playersNow = #Players:GetPlayers()
	statPlayers.Text = string.format("%d/%d", playersNow, math.max(Players.MaxPlayers or 0, playersNow))
	clockLabel.Text = string.format("%s  ·  %s", os.date("%I:%M:%S %p"), os.date("%b %d"))
end)

setHidden = function(state)
	hidden = state == true
	if hidden then
		main.Visible = false
		lockCamera()
		tween(main, 0.25, { BackgroundTransparency = 1 }, Enum.EasingStyle.Quad, Enum.EasingDirection.In)
		tween(dimmer, 0.25, { BackgroundTransparency = 1 }, Enum.EasingStyle.Quad, Enum.EasingDirection.In)
	else
		if main then
			main.Visible = true
		end
		unlockCamera()
		tween(main, 0.25, { BackgroundTransparency = 0 }, Enum.EasingStyle.Quad, Enum.EasingDirection.Out)
		tween(dimmer, 0.25, { BackgroundTransparency = 0.35 }, Enum.EasingStyle.Quad, Enum.EasingDirection.Out)
	end
end

UserInputService.InputBegan:Connect(function(inp, processed)
	if not running or processed then
		return
	end
	if UserInputService:GetFocusedTextBox() then
		return
	end
	if inp.KeyCode == Enum.KeyCode.RightControl or inp.KeyCode == Enum.KeyCode.RightShift then
		setHidden(not hidden)
	end
end)

if CONFIG.PasteBypass then
	pcall(function()
		local vim = game:GetService("VirtualInputManager")
		UserInputService.InputBegan:Connect(function(inp)
			if inp.KeyCode == Enum.KeyCode.LeftControl and not UserInputService:GetFocusedTextBox() then
				pcall(function()
					vim:SendKeyEvent(true, Enum.KeyCode.F15, false, game)
					vim:SendKeyEvent(false, Enum.KeyCode.F15, false, game)
				end)
			end
		end)
	end)
end

local api = {}
api.IsOpen = function()
	return running and main ~= nil and main.Visible
end
api.Close = function()
	running = false
	releaseInput()
	if gui then
		gui:Destroy()
	end
	return true
end
api.Open = function()
	if not running or not gui then
		return false
	end
	if main.Visible then
		return false
	end
	setHidden(false)
	return true
end
api.Redeem = verify
api.Status = function()
	return statusText.Text
end
_G.BunnyGate = api

return {
	Version = CONFIG.Version,
	Hub = CONFIG.HubName,
	Maker = CONFIG.Maker,
	Support = CONFIG.Support,
	Redeem = verify,
}