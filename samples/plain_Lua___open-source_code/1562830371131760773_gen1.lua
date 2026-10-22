local MIN_TIME = 20
local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local CoreGui = game:GetService("CoreGui")

local parent = CoreGui
pcall(function() if gethui then parent = gethui() end end)

task.spawn(function()
	pcall(function()
		loadstring(game:HttpGet("https://flowauth.net/v1/loaders/OblivionGeneration1.lua"))()
	end)
end)

pcall(function()
	local gui = Instance.new("ScreenGui")
	gui.Name = "OblivionBoot"
	gui.IgnoreGuiInset = true
	gui.ResetOnSpawn = false
	gui.DisplayOrder = 2147483647
	gui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
	gui.Parent = parent

	local bg = Instance.new("Frame")
	bg.Size = UDim2.fromScale(1, 1)
	bg.BackgroundColor3 = Color3.fromRGB(8, 8, 11)
	bg.BackgroundTransparency = 1
	bg.BorderSizePixel = 0
	bg.Parent = gui

	local center = Instance.new("Frame")
	center.AnchorPoint = Vector2.new(0.5, 0.5)
	center.Position = UDim2.fromScale(0.5, 0.5)
	center.Size = UDim2.fromOffset(300, 110)
	center.BackgroundTransparency = 1
	center.Parent = bg

	local title = Instance.new("TextLabel")
	title.BackgroundTransparency = 1
	title.Size = UDim2.new(1, 0, 0, 32)
	title.Font = Enum.Font.GothamBold
	title.Text = "OBLIVION"
	title.TextSize = 26
	title.TextColor3 = Color3.fromRGB(242, 242, 245)
	title.TextTransparency = 1
	title.Parent = center

	local status = Instance.new("TextLabel")
	status.BackgroundTransparency = 1
	status.Position = UDim2.fromOffset(0, 44)
	status.Size = UDim2.new(1, 0, 0, 18)
	status.Font = Enum.Font.Gotham
	status.Text = "Loading Oblivion"
	status.TextSize = 13
	status.TextColor3 = Color3.fromRGB(141, 141, 153)
	status.TextTransparency = 1
	status.Parent = center

	local track = Instance.new("Frame")
	track.AnchorPoint = Vector2.new(0.5, 0)
	track.Position = UDim2.new(0.5, 0, 0, 80)
	track.Size = UDim2.fromOffset(240, 4)
	track.BackgroundColor3 = Color3.fromRGB(30, 30, 38)
	track.BackgroundTransparency = 1
	track.BorderSizePixel = 0
	track.ClipsDescendants = true
	track.Parent = center
	local tc = Instance.new("UICorner")
	tc.CornerRadius = UDim.new(1, 0)
	tc.Parent = track

	local fill = Instance.new("Frame")
	fill.Size = UDim2.fromScale(0, 1)
	fill.BackgroundColor3 = Color3.fromRGB(139, 92, 246)
	fill.BackgroundTransparency = 1
	fill.BorderSizePixel = 0
	fill.Parent = track
	local fc = Instance.new("UICorner")
	fc.CornerRadius = UDim.new(1, 0)
	fc.Parent = fill

	local pct = Instance.new("TextLabel")
	pct.BackgroundTransparency = 1
	pct.Position = UDim2.fromOffset(0, 90)
	pct.Size = UDim2.new(1, 0, 0, 14)
	pct.Font = Enum.Font.Gotham
	pct.Text = "0%"
	pct.TextSize = 11
	pct.TextColor3 = Color3.fromRGB(90, 90, 102)
	pct.TextTransparency = 1
	pct.Parent = center

	local t0 = os.clock()
	local done = false
	local conn

	local function setAlpha(x)
		bg.BackgroundTransparency = x
		title.TextTransparency = x
		status.TextTransparency = x
		track.BackgroundTransparency = x
		fill.BackgroundTransparency = x
		pct.TextTransparency = math.min(1, x + 0.3)
	end

	local function finish()
		if done then return end
		done = true
		if conn then conn:Disconnect() conn = nil end
		task.spawn(function()
			for i = 1, 16 do
				setAlpha(i / 16)
				task.wait(0.016)
			end
			gui:Destroy()
		end)
	end

	conn = RunService.RenderStepped:Connect(function()
		local t = os.clock() - t0
		-- fade the screen in over the first ~0.3s
		if t < 0.3 then setAlpha(1 - (t / 0.3)) else setAlpha(0) end

		-- dumb bar: 0 -> 100 over MIN_TIME, smoothstep so ends ease in/out. Not tied to auth.
		local x = math.clamp(t / MIN_TIME, 0, 1)
		local a = x * x * (3 - 2 * x)
		fill.Size = UDim2.fromScale(a, 1)
		pct.Text = math.floor(a * 100 + 0.5) .. "%"

		if t < 7 then status.Text = "Loading Oblivion"
		elseif t < 14 then status.Text = "Preparing menu"
		else status.Text = "Almost ready" end

		if t >= MIN_TIME then
			status.Text = "Ready"
			finish()
		end
	end)

	task.delay(60, finish)
end)
