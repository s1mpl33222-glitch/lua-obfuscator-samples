local Players = game:GetService("Players")
local UserInputService = game:GetService("UserInputService")
local player = Players.LocalPlayer

local PACKS = {
	["Adidas Sports"] = {
		WalkAnim = 18537392113,
		RunAnim  = 18537384940,
		JumpAnim = 18537380791,
		FallAnim = 18537367238,
		SwimIdle = 18537387180,
		Swim     = 18537389531,
		Animation1 = 18537376492,
		Animation2 = 18537371272,
		ClimbAnim = 18537363391,
	},
	["Adidas Community"] = {
		WalkAnim = 122150855457006,
		RunAnim  = 82598234841035,
		JumpAnim = 75290611992385,
		FallAnim = 98600215928904,
		SwimIdle = 109346520324160,
		Swim     = 133308483266208,
		Animation1 = 122257458498464,
		Animation2 = 102357151005774,
		ClimbAnim = 88763136693023,
	},
	["Adidas Aura"] = {
		WalkAnim = 83842218823011,
		RunAnim  = 118320322718866,
		JumpAnim = 109996626521204,
		FallAnim = 95603166884636,
		SwimIdle = 94922130551805,
		Swim     = 134530128383903,
		Animation1 = 110211186840347,
		Animation2 = 114191137265065,
		ClimbAnim = 97824616490448,
	},
	["Wicked Popular"] = {
		WalkAnim = 92072849924640,
		RunAnim = 72301599441680,
		JumpAnim = 104325245285198,
		FallAnim = 121152442762481,
		Animation1 = 118832222982049,
		ClimbAnim = 131326830509784,
		SwimIdle = 113199415118199,
		Swim = 99384245425157,
		Animation2 = 76049494037641,
	},
	Elder = {
		WalkAnim = 10921111375,
		RunAnim  = 10921104374,
		JumpAnim = 10921107367,
		FallAnim = 10921105765,
		SwimIdle = 10921110146,
		Swim     = 10921108971,
		ClimbAnim = 10921100400,
		Animation1 = 10921101664,
		Animation2 = 10921102574,
	},
	Zombie = {
		WalkAnim = 10921355261,
		RunAnim  = 616163682,
		JumpAnim = 10921351278,
		FallAnim = 10921350320,
		SwimIdle = 10921353442,
		Swim     = 10921352344,
		Animation1 = 10921344533,
		Animation2 = 10921345304,
		ClimbAnim = 10921343576,
	},
	Mage = {
		WalkAnim = 10921152678,
		RunAnim  = 10921148209,
		JumpAnim = 10921149743,
		FallAnim = 10921148939,
		SwimIdle = 10921151661,
		Swim     = 10921150788,
		ClimbAnim = 10921143404,
		Animation1 = 10921144709,
		Animation2 = 10921145797,
	},

	["Catwalk Glam"] = {
		WalkAnim = 109168724482748,
		RunAnim  = 81024476153754,
		JumpAnim = 116936326516985,
		FallAnim = 92294537340807,
		SwimIdle = 98854111361360,
		Swim     = 134591743181628,
		ClimbAnim = 119377220967554,
		Animation1 = 133806214992291,
		Animation2 = 94970088341563,
	},
	Astronaut = {
		WalkAnim = 10921046031,
		RunAnim  = 10921039308,
		JumpAnim = 10921042494,
		FallAnim = 10921040576,
		SwimIdle = 10921045006,
		Swim     = 10921044000,
		ClimbAnim = 10921032124,
		Animation1 = 10921034824,
		Animation2 = 10921036806,
	},
	['Wicked "Dancing Through Life"'] = {
		WalkAnim = 73718308412641,
		RunAnim  = 135515454877967,
		JumpAnim = 78508480717326,
		FallAnim = 78147885297412,
		SwimIdle = 129183123083281,
		Swim     = 110657013921774,
		ClimbAnim = 129447497744818,
		Animation1 = 92849173543269,
		Animation2 = 132238900951109,
	},
	Werewolf = {
		WalkAnim = 10921342074,
		RunAnim  = 10921336997,
		JumpAnim = nil,
		FallAnim = 10921337907,
		SwimIdle = 10921341319,
		Swim     = 10921340419,
		ClimbAnim = 10921329322,
		Animation1 = 10921330408,
		Animation2 = 10921333667,
	},
	Superhero = {
		WalkAnim = 10921298616,
		RunAnim  = 10921291831,
		JumpAnim = 10921294559,
		FallAnim = 10921293373,
		SwimIdle = 10921297391,
		Swim     = 10921295495,
		ClimbAnim = 10921286911,
		Animation1 = 10921288909,
		Animation2 = 10921290167,
	},
	Toy = {
		WalkAnim = 10921312010,
		RunAnim  = 10921306285,
		JumpAnim = 10921308158,
		FallAnim = 10921307241,
		SwimIdle = 10921310341,
		Swim     = 10921309319,
		ClimbAnim = 10921300839,
		Animation1 = 10921301576,
		Animation2 = nil,
	},
	["No Boundaries"] = {
		WalkAnim = 18747074203,
		RunAnim  = 18747070484,
		JumpAnim = 18747069148,
		FallAnim = 18747062535,
		SwimIdle = 18747071682,
		Swim     = 18747073181,
		ClimbAnim = 18747060903,
		Animation1 = 18747067405,
		Animation2 = 18747063918,
	},
	NFL = {
		WalkAnim = 110358958299415,
		RunAnim  = 117333533048078,
		JumpAnim = 119846112151352,
		FallAnim = 129773241321032,
		SwimIdle = 79090109939093,
		Swim     = 132697394189921,
		ClimbAnim = 134630013742019,
		Animation1 = 92080889861410,
		Animation2 = 74451233229259,
	},
	["Amazon Unboxed"] = {
		WalkAnim = 90478085024465,
		RunAnim  = 134824450619865,
		JumpAnim = 121454505477205,
		FallAnim = 94788218468396,
		SwimIdle = 129126268464847,
		Swim     = 105962919001086,
		ClimbAnim = 121145883950231,
		Animation1 = 98281136301627,
		Animation2 = nil,
	},
	Vampire = {
		WalkAnim = 10921326949,
		RunAnim  = 10921320299,
		JumpAnim = 10921322186,
		FallAnim = 10921321317,
		SwimIdle = 10921325443,
		Swim     = 10921324408,
		ClimbAnim = 10921314188,
		Animation1 = 10921315373,
		Animation2 = nil,
	},

	["Ninja"] = {
		Run=656118852, Walk=656121766, Jump=656117878, Fall=656115606,
		Swim=656119721, SwimIdle=656121397, Climb=656114359,
		Idle={656117400,656118341,886742569}
	},
	["Robot"] = {
		Run=616091570, Walk=616095330, Jump=616090535, Fall=616087089,
		Swim=616092998, SwimIdle=616094091, Climb=616086039,
		Idle={616088211,616089559,885531463}
	},
	["Levitation"] = {
		Run=616010382, Walk=616013216, Jump=616008936, Fall=616005863,
		Swim=616011509, SwimIdle=616012453, Climb=616003713,
		Idle={616006778,616008087,886862142}
	},
	["Stylish"] = {
		Run=616140816, Walk=616146177, Jump=616139451, Fall=616134815,
		Swim=616143378, SwimIdle=616144772, Climb=616133594,
		Idle={616136790,616138447,886888594}
	},
	["Bubbly"] = {
		Run=910025107, Walk=910034870, Jump=910016857, Fall=910001910,
		Swim=910028158, SwimIdle=910030921, Climb=909997997,
		Idle={910004836,910009958,1018536639}
	},
	["Cartoon"] = {
		Run=742638842, Walk=742640026, Jump=742637942, Fall=742637151,
		Swim=742639220, SwimIdle=742639812, Climb=742636889,
		Idle={742637544,742638445,885477856}
	},
}

-- UTILS
local function waitForAnimate(char)
	for _ = 1, 40 do
		local a = char:FindFirstChild("Animate")
		if a and a:FindFirstChild("idle") and a:FindFirstChild("run") and a:FindFirstChild("walk") then
			return a
		end
		task.wait(0.1)
	end
	return nil
end

local function setAnim(animObj, id)
	if animObj and id then
		animObj.AnimationId = "rbxassetid://" .. tostring(id)
	end
end

local function stopAllTracks(hum)
	if not hum then return end
	for _, t in ipairs(hum:GetPlayingAnimationTracks()) do
		pcall(function() t:Stop(0) end)
	end
end

local function ensureAnim(folder, name)
	if not folder then return nil end
	local a = folder:FindFirstChild(name)
	if not a then
		a = Instance.new("Animation")
		a.Name = name
		a.Parent = folder
	end
	return a
end

local function ensureIdleSlots(idleFolder, n)
	if not idleFolder then return end
	n = n or 2
	for i=1,n do
		ensureAnim(idleFolder, "Animation" .. i)
	end
end

-- pick helper (supports both formats)
local function pick(pack, ...)
	for i = 1, select("#", ...) do
		local k = select(i, ...)
		local v = pack[k]
		if v ~= nil then return v end
	end
	return nil
end

-- APPLY PACK
local ATTR_LAST = "AnimPack_Last"
local applying = false

local function applyPack(packName)
	if applying then return false end
	applying = true

	local pack = PACKS[packName]
	if not pack then
		warn("Unknown pack:", packName)
		applying = false
		return false
	end

	local char = player.Character or player.CharacterAdded:Wait()
	local animate = waitForAnimate(char)
	if not animate then
		warn("Animate not found")
		applying = false
		return false
	end

	local hum = char:FindFirstChildOfClass("Humanoid")
	stopAllTracks(hum)

	-- Ensure common objects exist
	local runObj   = ensureAnim(animate:FindFirstChild("run"),   "RunAnim")
	local walkObj  = ensureAnim(animate:FindFirstChild("walk"),  "WalkAnim")
	local jumpObj  = ensureAnim(animate:FindFirstChild("jump"),  "JumpAnim")
	local fallObj  = ensureAnim(animate:FindFirstChild("fall"),  "FallAnim")
	local climbObj = ensureAnim(animate:FindFirstChild("climb"), "ClimbAnim")
	local swimObj  = ensureAnim(animate:FindFirstChild("swim"),     "Swim")
	local swimIdleObj = ensureAnim(animate:FindFirstChild("swimidle"), "SwimIdle")
	local idleFolder = animate:FindFirstChild("idle")

	-- Movement: prefer Format B keys, fallback to Format A keys
	setAnim(walkObj,  pick(pack, "WalkAnim", "Walk"))
	setAnim(runObj,   pick(pack, "RunAnim", "Run"))
	setAnim(jumpObj,  pick(pack, "JumpAnim", "Jump"))
	setAnim(fallObj,  pick(pack, "FallAnim", "Fall"))
	setAnim(climbObj, pick(pack, "ClimbAnim", "Climb"))

	setAnim(swimObj,      pick(pack, "Swim"))
	setAnim(swimIdleObj,  pick(pack, "SwimIdle") or pick(pack, "Swim"))

	-- Idle: Format B Animation1/Animation2 OR Format A Idle array
	if idleFolder then
		local a1 = pick(pack, "Animation1")
		local a2 = pick(pack, "Animation2")

		if a1 or a2 then
			ensureIdleSlots(idleFolder, 2)
			local id1 = a1 or a2
			local id2 = a2 or a1 or id1
			setAnim(idleFolder:FindFirstChild("Animation1"), id1)
			setAnim(idleFolder:FindFirstChild("Animation2"), id2)
		elseif pack.Idle and #pack.Idle > 0 then
			ensureIdleSlots(idleFolder, math.max(2, #pack.Idle))
			setAnim(idleFolder:FindFirstChild("Animation1"), pack.Idle[1])
			setAnim(idleFolder:FindFirstChild("Animation2"), pack.Idle[2] or pack.Idle[1])
			for i = 3, #pack.Idle do
				local a = idleFolder:FindFirstChild("Animation" .. i)
				if a then setAnim(a, pack.Idle[i]) end
			end
		end
	end

	-- Refresh Animate
	animate.Disabled = true
	task.wait(0.06)
	animate.Disabled = false

	-- Nudge state
	if hum then
		pcall(function()
			hum:ChangeState(Enum.HumanoidStateType.Landed)
			task.wait(0.03)
			hum:ChangeState(Enum.HumanoidStateType.Running)
		end)
	end

	pcall(function() player:SetAttribute(ATTR_LAST, packName) end)

	applying = false
	return true
end

-- Reapply on respawn (session)
player.CharacterAdded:Connect(function()
	task.wait(0.6)
	local saved = player:GetAttribute(ATTR_LAST)
	if type(saved) == "string" and saved ~= "" and PACKS[saved] then
		applyPack(saved)
	end
end)

-- GUI
local function getParentGui()
	return player:WaitForChild("PlayerGui")
end

-- cleanup old UI
do
	local pg = getParentGui()
	local old = pg:FindFirstChild("AnimPackGUI")
	if old then old:Destroy() end
end

local gui = Instance.new("ScreenGui")
gui.Name = "AnimPackGUI"
gui.ResetOnSpawn = false
gui.Parent = getParentGui()

local frame = Instance.new("Frame")
frame.Size = UDim2.new(0, 360, 0, 320)
frame.Position = UDim2.new(0.5, -180, 0.5, -160)
frame.BackgroundColor3 = Color3.fromRGB(15, 15, 15)
frame.BorderSizePixel = 0
frame.Parent = gui
frame.Active = true
frame.ClipsDescendants = true

local fc = Instance.new("UICorner"); fc.CornerRadius = UDim.new(0, 12); fc.Parent = frame
local st = Instance.new("UIStroke"); st.Color = Color3.fromRGB(75, 75, 75); st.Transparency = 0.35; st.Parent = frame

local titleBar = Instance.new("Frame")
titleBar.Size = UDim2.new(1, 0, 0, 36)
titleBar.BackgroundTransparency = 1
titleBar.Parent = frame
titleBar.Active = true

local title = Instance.new("TextLabel")
title.Size = UDim2.new(1, -120, 1, 0)
title.Position = UDim2.new(0, 12, 0, 0)
title.BackgroundTransparency = 1
title.TextXAlignment = Enum.TextXAlignment.Left
title.Font = Enum.Font.GothamBold
title.TextSize = 15
title.TextColor3 = Color3.fromRGB(255,255,255)
title.Text = "Animation Packs"
title.Parent = titleBar

local hint = Instance.new("TextLabel")
hint.Size = UDim2.new(0, 110, 1, 0)
hint.Position = UDim2.new(1, -230, 0, 0)
hint.BackgroundTransparency = 1
hint.TextXAlignment = Enum.TextXAlignment.Right
hint.Font = Enum.Font.Gotham
hint.TextSize = 12
hint.TextColor3 = Color3.fromRGB(170,170,170)
hint.Text = "(, hide)"
hint.Parent = titleBar

local miniBtn = Instance.new("TextButton")
miniBtn.Size = UDim2.new(0, 36, 0, 36)
miniBtn.Position = UDim2.new(1, -72, 0, 0)
miniBtn.Text = "-"
miniBtn.Font = Enum.Font.GothamBold
miniBtn.TextSize = 18
miniBtn.TextColor3 = Color3.fromRGB(255,255,255)
miniBtn.BackgroundTransparency = 1
miniBtn.Parent = titleBar

local closeBtn = Instance.new("TextButton")
closeBtn.Size = UDim2.new(0, 36, 0, 36)
closeBtn.Position = UDim2.new(1, -36, 0, 0)
closeBtn.Text = "X"
closeBtn.Font = Enum.Font.GothamBold
closeBtn.TextSize = 16
closeBtn.TextColor3 = Color3.fromRGB(220,80,80)
closeBtn.BackgroundTransparency = 1
closeBtn.Parent = titleBar

-- drag (pc+mobile)
local dragging, dragStart, startPos = false, nil, nil
titleBar.InputBegan:Connect(function(input)
	if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
		dragging = true
		dragStart = input.Position
		startPos = frame.Position
	end
end)
UserInputService.InputEnded:Connect(function(input)
	if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
		dragging = false
	end
end)
UserInputService.InputChanged:Connect(function(input)
	if dragging and (input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch) then
		local delta = input.Position - dragStart
		frame.Position = UDim2.new(startPos.X.Scale, startPos.X.Offset + delta.X, startPos.Y.Scale, startPos.Y.Offset + delta.Y)
	end
end)

-- current label
local current = Instance.new("TextLabel")
current.Size = UDim2.new(1, -24, 0, 20)
current.Position = UDim2.new(0, 12, 0, 40)
current.BackgroundTransparency = 1
current.TextXAlignment = Enum.TextXAlignment.Left
current.Font = Enum.Font.Gotham
current.TextSize = 13
current.TextColor3 = Color3.fromRGB(200,200,200)
current.Text = "Current: (none)"
current.Parent = frame

-- search bar
local searchBox = Instance.new("TextBox")
searchBox.Size = UDim2.new(1, -24, 0, 32)
searchBox.Position = UDim2.new(0, 12, 0, 64)
searchBox.BackgroundColor3 = Color3.fromRGB(35,35,35)
searchBox.TextColor3 = Color3.fromRGB(255,255,255)
searchBox.PlaceholderText = "Search pack... (ex: adidas, zombie, ninja)"
searchBox.Text = ""
searchBox.ClearTextOnFocus = false
searchBox.Font = Enum.Font.Gotham
searchBox.TextSize = 14
searchBox.BorderSizePixel = 0
searchBox.Parent = frame
Instance.new("UICorner", searchBox).CornerRadius = UDim.new(0, 10)

-- list container
local listFrame = Instance.new("Frame")
listFrame.Size = UDim2.new(1, -24, 1, -112)
listFrame.Position = UDim2.new(0, 12, 0, 104)
listFrame.BackgroundColor3 = Color3.fromRGB(25,25,25)
listFrame.BorderSizePixel = 0
listFrame.Parent = frame
Instance.new("UICorner", listFrame).CornerRadius = UDim.new(0, 12)

local scroll = Instance.new("ScrollingFrame")
scroll.Size = UDim2.new(1, -10, 1, -10)
scroll.Position = UDim2.new(0, 5, 0, 5)
scroll.BackgroundTransparency = 1
scroll.BorderSizePixel = 0
scroll.ScrollBarThickness = 6
scroll.CanvasSize = UDim2.new(0, 0, 0, 0)
scroll.Parent = listFrame

local layout = Instance.new("UIListLayout")
layout.Padding = UDim.new(0, 6)
layout.SortOrder = Enum.SortOrder.LayoutOrder
layout.Parent = scroll

local pad = Instance.new("UIPadding")
pad.PaddingTop = UDim.new(0, 6)
pad.PaddingBottom = UDim.new(0, 6)
pad.PaddingLeft = UDim.new(0, 6)
pad.PaddingRight = UDim.new(0, 6)
pad.Parent = scroll

local function refreshCanvas()
	task.wait()
	scroll.CanvasSize = UDim2.new(0, 0, 0, layout.AbsoluteContentSize.Y + 10)
end
layout:GetPropertyChangedSignal("AbsoluteContentSize"):Connect(refreshCanvas)

-- minimize
local minimized = false
local expandedSize = frame.Size
local minimizedSize = UDim2.new(expandedSize.X.Scale, expandedSize.X.Offset, 0, 36)

local function setMinimized(on)
	minimized = on
	if minimized then
		frame.Size = minimizedSize
		miniBtn.Text = "+"
		current.Visible = false
		searchBox.Visible = false
		listFrame.Visible = false
	else
		frame.Size = expandedSize
		miniBtn.Text = "-"
		current.Visible = true
		searchBox.Visible = true
		listFrame.Visible = true
	end
end

miniBtn.Activated:Connect(function()
	setMinimized(not minimized)
end)

closeBtn.Activated:Connect(function()
	gui:Destroy()
end)

-- comma hide/show
UserInputService.InputBegan:Connect(function(input, gp)
	if gp then return end
	if input.KeyCode == Enum.KeyCode.Comma then
		gui.Enabled = not gui.Enabled
	end
end)

-- ordering: Adidas packs always top, then alphabetical
local ADIDAS_TOP_ORDER = { "Adidas Sports", "Adidas Community", "Adidas Aura" }
local adidasRank = {}
for i, n in ipairs(ADIDAS_TOP_ORDER) do adidasRank[n] = i end

local allNames = {}
for name in pairs(PACKS) do table.insert(allNames, name) end

table.sort(allNames, function(a, b)
	local ra, rb = adidasRank[a], adidasRank[b]
	if ra and rb then return ra < rb end
	if ra then return true end
	if rb then return false end
	return a:lower() < b:lower()
end)

local buttonsByName = {}

local function createButton(name, order)
	local btn = Instance.new("TextButton")
	btn.Size = UDim2.new(1, 0, 0, 34)
	btn.BackgroundColor3 = Color3.fromRGB(45,45,45)
	btn.TextColor3 = Color3.fromRGB(255,255,255)
	btn.Font = Enum.Font.GothamBold
	btn.TextSize = 13
	btn.Text = name
	btn.AutoButtonColor = true
	btn.LayoutOrder = order
	btn.BorderSizePixel = 0
	btn.Parent = scroll
	Instance.new("UICorner", btn).CornerRadius = UDim.new(0, 10)

	btn.Activated:Connect(function()
		local ok = applyPack(name)
		current.Text = ok and ("Current: " .. name) or ("Current: (failed) " .. name)
	end)

	buttonsByName[name] = btn
end

for i, name in ipairs(allNames) do
	createButton(name, i)
end
refreshCanvas()

local function applyFilter(text)
	text = (text or ""):lower()
	for name, btn in pairs(buttonsByName) do
		btn.Visible = (text == "") or (name:lower():find(text, 1, true) ~= nil)
	end
	refreshCanvas()
end

searchBox:GetPropertyChangedSignal("Text"):Connect(function()
	applyFilter(searchBox.Text)
end)
applyFilter("")

-- auto-load last pack (session)
task.defer(function()
	local saved = player:GetAttribute(ATTR_LAST)
	if type(saved) == "string" and saved ~= "" and PACKS[saved] then
		current.Text = "Current: " .. saved .. " (saved)"
		task.wait(0.2)
		applyPack(saved)
	end
end)
