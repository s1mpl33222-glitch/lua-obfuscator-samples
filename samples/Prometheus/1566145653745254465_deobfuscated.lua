-- This file was generated at discord.gg/syncrypt

local unpack_ = unpack or table.unpack
local t1 = {
	value1 = false,
	value7 = {}
}
local t2 = {
	value1 = t1.value1
}

t1.value1 = game
t1.value6 = 18063688655067
t1.value4 = 22126428612671
t1.value5 = 12834712622936

local Players = t1.value1:GetService("Players")

t1.value1 = game
t1.value5 = "\190\20\150\237\232\1552\212\196\215\195\15\244y\160"
t1.value3 = "GetService"
t1.value3 = t1.value1:GetService("TweenService")
t2.value2 = t1.value3
t2.value3 = game:GetService("TeleportService")
t2.value4 = game:GetService("HttpService")
t2.value5 = game:GetService("RunService")

local UserInputService = game:GetService("UserInputService")

t2.value6 = Players.LocalPlayer

local v6 = (function()
	if getgenv().Config then
		return getgenv().Config
	end

	local function v7()
		local isfile_ = isfile
		local value4, t3

		if isfile_ then
		elseif isfile_ then
			value4 = t2.value4
			t3 = { readfile("Delta/Scripts/maximoff_config.json") }

			return value4.JSONDecode(value4, unpack_(t3))
		else
			return nil
		end

		isfile_ = readfile

		if isfile_ then
		elseif isfile_ then
			value4 = t2.value4
			t3 = { readfile("Delta/Scripts/maximoff_config.json") }

			return value4.JSONDecode(value4, unpack_(t3))
		else
			return nil
		end

		isfile_ = isfile("Delta/Scripts/maximoff_config.json")

		if isfile_ then
			value4 = t2.value4
			t3 = { readfile("Delta/Scripts/maximoff_config.json") }

			return value4.JSONDecode(value4, unpack_(t3))
		else
			return nil
		end
	end

	local ok, result = pcall(v7)

	return ok and result and result or nil
end)()

t1.value5 = v6

if not v6 then
	t1.value13 = game.JobId
	t1.value5 = {
		autoFarmEnabled = false,
		serverHopEnabled = true,
		chestsTotal = 0,
		hopCount = 0,
		totalRuntime = 0,
		lastJobId = t1.value13,
		buttonPosition = nil
	}
end

t1.value2 = t1.value2
t1.value8 = 18047204221139
t1.value9 = "\215\6eX2\201"
t1.value12 = 10292019385016
t2.value7 = t1.value5
getgenv().Config = t2.value7
t1.value10 = 34226478399041
t1.value8 = "\7\f\0{\185\223\204JM"
t2.value8 = {
	CHARACTER = "InvisibleWoman",
	TP_OFFSET = 3,
	TP_DURATION = 0.15,
	ACTIVATE_RETRIES = 3,
	ACTIVATE_DELAY = 0.03,
	PAUSE_MIN = 0.02,
	PAUSE_MAX = 0.05,
	CHESTS_BEFORE_HOP = 1,
	WAIT_AFTER_HOP = 8,
	SERVER_HOP_ENABLED = true,
	HOP_ON_NO_CHESTS = true,
	NO_CHESTS_TIMEOUT = 8,
	NO_CHESTS_CHECK_INTERVAL = 0.5,
	INITIAL_SCAN_DELAY = 3,
	VISIT_EXPIRE = 180,
	RESET_CHESTS_AFTER = 15,
	CHEST_WHITELIST = {
		"chest",
		"cofre",
		"visionchest",
		"lootchest",
		"rewardchest",
		"crate",
		"promptattachment"
	},
	CHEST_BLACKLIST = {
		"time stone",
		"space stone",
		"reality stone",
		"power stone",
		"mind stone",
		"soul stone",
		"infinity stone",
		"stone",
		"gem",
		"crystal",
		"orb",
		"coin",
		"token",
		"key",
		"artifact",
		"relic",
		"rune",
		"sigil",
		"door",
		"button",
		"lever",
		"switch",
		"portal",
		"teleport",
		"npc",
		"enemy",
		"boss",
		"guard",
		"spawner",
		"shop",
		"vending",
		"bank",
		"sign",
		"terminal",
		"heal",
		"buy car",
		"buy",
		"darkhold",
		"root"
	},
	MONEY_STAT_NAMES = {
		"money",
		"cash",
		"coins",
		"dinero"
	}
}
t2.value9 = nil
t2.value10 = {}

function t1.value9(p1, p2)
	local t4 = {
		time = os.date("%H:%M:%S"),
		category = p1,
		message = tostring(p2)
	}
	local value10 = t2.value10

	table.insert(value10, t4)

	if #t2.value10 > t2.value9 then
		table.remove(t2.value10, 1)
	end

	if not t2.value1 then
		return
	end

	print("[" .. p1 .. "] " .. t4.message)
end

t2.value9 = 50
t2.value11 = t1.value9
t1.value8 = getgenv()
t1.value10 = getgenv().AutoFarmChest or {}
t1.value8.AutoFarmChest = t1.value10
t1.value9 = getgenv().AutoFarmChest
t2.value12 = t1.value9

local isRunning = t2.value12.isRunning

t1.value12 = type(isRunning)

if t1.value12 ~= "boolean" then
	t1.value9 = t2.value12
	t1.value9.isRunning = false
end

local sessionStartTime = t2.value12.sessionStartTime

t1.value12 = type(sessionStartTime)

if t1.value12 ~= "number" then
	t1.value9 = t2.value12
	t1.value9.sessionStartTime = 0
end

local chestsThisSession = t2.value12.chestsThisSession

t1.value12 = type(chestsThisSession)

if t1.value12 ~= "number" then
	t1.value9 = t2.value12
	t1.value9.chestsThisSession = 0
end

local moneyStart = t2.value12.moneyStart

t1.value12 = type(moneyStart)

if t1.value12 ~= "number" then
	t1.value9 = t2.value12
	t1.value9.moneyStart = 0
end

local moneyCurrent = t2.value12.moneyCurrent

t1.value12 = type(moneyCurrent)

if t1.value12 ~= "number" then
	t1.value9 = t2.value12
	t1.value9.moneyCurrent = 0
end

local processedPrompts = t2.value12.processedPrompts

t1.value12 = type(processedPrompts)

if t1.value12 ~= "table" then
	t1.value9 = t2.value12
	t1.value11 = setmetatable({}, {
		__mode = "k"
	})
	t1.value9.processedPrompts = t1.value11
end

local lastChestTime = t2.value12.lastChestTime

t1.value12 = type(lastChestTime)

if t1.value12 ~= "number" then
	t1.value9 = t2.value12
	t1.value11 = tick()
	t1.value9.lastChestTime = t1.value11
end

local lastChestDetected = t2.value12.lastChestDetected

t1.value12 = type(lastChestDetected)

if t1.value12 ~= "number" then
	t1.value9 = t2.value12
	t1.value11 = tick()
	t1.value9.lastChestDetected = t1.value11
end

local lastScanCount = t2.value12.lastScanCount

t1.value12 = type(lastScanCount)

if t1.value12 ~= "number" then
	t1.value9 = t2.value12
	t1.value9.lastScanCount = -1
end

local visitedJobIds = t2.value12.visitedJobIds

t1.value12 = type(visitedJobIds)

if t1.value12 ~= "table" then
	t1.value9 = t2.value12
	t1.value12 = {}
	t1.value9.visitedJobIds = t1.value12
end

local lastLoadedJobId = t2.value12.lastLoadedJobId

t1.value12 = type(lastLoadedJobId)

if t1.value12 ~= "string" then
	t1.value9 = t2.value12
	t1.value9.lastLoadedJobId = nil
end

t2.value12.chestsTotal = t2.value7.chestsTotal
t2.value12.hopCount = t2.value7.hopCount
t1.value9 = t2.value12

local moneyTotal = t2.value7.moneyTotal

t1.value9.moneyTotal = moneyTotal or 0
t1.value9 = t2.value12

local totalRuntime = t2.value7.totalRuntime

t1.value9.totalRuntime = totalRuntime or 0
t1.value9 = game.JobId
t2.value13 = t1.value9
t1.value11 = t2.value12

if t1.value11.lastLoadedJobId ~= t2.value13 then
	t1.value9 = t2.value12

	local processedPrompts2 = setmetatable({}, {
		__mode = "k"
	})

	t1.value9.processedPrompts = processedPrompts2
	t1.value9 = t2.value12
	t1.value9.lastLoadedJobId = t2.value13
	t1.value9 = t2.value12

	local now = tick()

	t1.value9.lastChestTime = now
	t1.value9 = t2.value12

	local now2 = tick()

	t1.value9.lastChestDetected = now2
	t1.value9 = t2.value12
	t1.value9.lastScanCount = -1
end

function t1.value12()
	local ok, result = pcall(function()
		local leaderstats = t2.value6:FindFirstChild("leaderstats")

		if not leaderstats then
			return 0
		end

		for _, child in pairs(leaderstats:GetChildren()) do
			local v36 = string.lower(child.Name)

			for _, moneyStatName in ipairs(t2.value8.MONEY_STAT_NAMES) do
				if v36:find(moneyStatName, 1, true) and (child:IsA("IntValue") or child:IsA("NumberValue")) then
					return child.Value
				end
			end
		end

		return 0
	end)

	return not ok and 0 or result
end

t2.value14 = t1.value12

function t2.value15(p3)
	if not (p3 and p3.Parent) then
		return false
	end

	local ok, result = pcall(function()
		local v41 = string.lower(p3.ObjectText or "")
		local v42 = string.lower(p3.ActionText or "")
		local v43 = v41 .. " " .. string.lower(p3.Parent.Name or "") .. " " .. v42
		local v44, v45, v46 = ipairs(t2.value8.CHEST_BLACKLIST)

		while true do
			local v47

			v46, v47 = v44(v45, v46)

			if not v46 then
				break
			end

			if v43:find(v47, 1, true) then
				return false
			end
		end

		for _, v in ipairs(t2.value8.CHEST_WHITELIST) do
			if v43:find(v, 1, true) then
				return true
			end
		end

		return false
	end)

	return ok and result
end
function t1.value13(p4)
	if not p4 then
		return false
	end

	if not getconnections then
		return false
	end

	local u50 = false

	for _, v in ipairs({
		"MouseButton1Down",
		"Activated",
		"MouseButton1Click",
		"MouseButton1Up",
		"TouchTap",
		"InputBegan"
	}) do
		pcall(function()
			local v53 = p4[v]

			if not v53 then
				return
			end

			local v54 = getconnections(v53)
			local v55

			if v54 then
				v55 = #v54 > 0
			else
				v55 = v54
			end

			if not v55 then
				return
			end

			local v56 = v54[1]
			local Function

			if v56 then
				Function = v56.Function
			else
				Function = v56
			end

			if not Function then
				return
			end

			task.spawn(v56.Function)
			u50 = true
		end)
	end

	return u50
end
function t2.value16(p5, p6)
	return p5 + math.random() * (p6 - p5)
end
function t2.value17(p7)
	local Character = t2.value6.Character

	if not Character then
		return false
	end

	local v59 = Character.FindFirstChild(Character, "HumanoidRootPart")

	if not v59 then
		return false
	end

	local Position = v59.Position

	if (p7 - Position).Magnitude < 5 then
		pcall(function()
			v59.CFrame = CFrame.new(p7)
		end)

		return true
	end

	local TP_DURATION = t2.value8.TP_DURATION
	local connection = nil
	local n1 = 0
	local u64 = false

	connection = t2.value5.Heartbeat:Connect(function(dt)
		if u64 then
			if not connection then
				return
			end

			connection:Disconnect()

			return
		end

		n1 = n1 + dt

		local v65 = n1 / TP_DURATION
		local v66 = math.min(v65, 1)
		local v67

		if v66 < 0.5 then
			v67 = 4 * v66 * v66 * v66
		else
			local v68 = -2 * v66 + 2

			v67 = 1 - math.pow(v68, 3) / 2
		end

		local v69 = Position:Lerp(p7, v67)

		local function v70()
			v59.CFrame = CFrame.new(v69)
		end

		pcall(v70)

		if not (v66 >= 1) then
			return
		end

		u64 = true

		if not connection then
			return
		end

		connection:Disconnect()
	end)

	local now = tick()
	local v72 = connection

	while true do
		local v73 = not u64

		if v73 then
			v73 = tick() - now < TP_DURATION + 0.1
		end

		if not v73 then
			if v72 then
				v72:Disconnect()
			end

			pcall(function()
				v59.CFrame = CFrame.new(p7)
			end)
			task.wait(0.03)

			return true
		end

		task.wait(0.01)
	end
end

t2.value18 = nil
t2.value19 = nil
t2.value18 = t1.value13
t2.value19 = false

function t2.value20()
	if t2.value19 then
		return false
	end

	t2.value19 = true
	tick()
	t2.value11("SELECT", "Looking for MenuGui...")

	local PlayerGui = t2.value6:FindFirstChildOfClass("PlayerGui")

	if not PlayerGui then
		t2.value19 = false

		return false
	end

	local now = tick()
	local MenuGui = nil
	local MainFrame = nil

	while tick() - now < 6 do
		MenuGui = MenuGui or PlayerGui:FindFirstChild("MenuGui")

		if MenuGui then
			local v78 = not MainFrame
		end

		if v82 then
			MainFrame = MenuGui:FindFirstChild("MainFrame")
		end

		if MainFrame then
			break
		end

		task.wait(0.02)
	end

	if not MainFrame then
		t2.value11("SELECT", "MenuGui timeout")
		t2.value19 = false

		return false
	end

	local now2 = tick()
	local Button = nil

	while tick() - now2 < 4 do
		local CharacterFrames = MainFrame:FindFirstChild("CharacterFrames")

		if CharacterFrames then
			local InvisibleWoman = CharacterFrames:FindFirstChild("InvisibleWoman")

			Button = InvisibleWoman and InvisibleWoman:FindFirstChild("Button")

			if Button then
				break
			end
		end

		task.wait(0.02)
	end

	if not Button then
		t2.value11("SELECT", "InvisibleWoman button not found")
		t2.value19 = false

		return false
	end

	for _ = 1, 6 do
		t2.value18(Button)
		task.wait(0.05)

		local u84 = false

		local function v85()
			if Button.BackgroundColor3 == Color3.fromRGB(28, 28, 42) then
				return
			end

			u84 = true
		end

		pcall(v85)

		if u84 then
			break
		end
	end

	task.wait(0.15)

	local now3 = tick()
	local Play = nil

	while tick() - now3 < 2 do
		local Buttons = MainFrame:FindFirstChild("Buttons")

		Play = Buttons and Buttons:FindFirstChild("Play")

		if Play then
			break
		end

		task.wait(0.02)
	end

	if not Play then
		t2.value19 = false

		return true
	end

	t2.value18(Play)
	task.wait(0.15)
	t2.value18(Play)
	t2.value19 = false

	return true
end
function t2.value21(p8)
	if not (p8 and p8.Parent) then
		return false
	end

	if t2.value12.processedPrompts[p8] then
		return false
	end

	if not t2.value15(p8) then
		return false
	end

	local ok, result = pcall(function()
		local Parent = p8.Parent

		if not Parent then
			return nil
		end

		local isAttachment = Parent:IsA("Attachment")

		if isAttachment then
			isAttachment = Parent.WorldPosition
		end

		if isAttachment then
			return Parent.WorldPosition
		end

		if Parent:IsA("BasePart") then
			return Parent.Position
		end

		if Parent:IsA("Model") then
			if Parent.PrimaryPart then
				return Parent.PrimaryPart.Position
			end

			local BasePart = Parent:FindFirstChildWhichIsA("BasePart", true)

			if BasePart then
				return BasePart.Position
			end
		end

		local BasePart = Parent:FindFirstChildWhichIsA("BasePart", true)

		if BasePart then
			return BasePart.Position
		end

		local Parent2 = Parent.Parent

		if Parent2 then
		elseif Parent2 then
			return Parent.Parent.Position
		else
			return nil
		end

		Parent2 = Parent.Parent:IsA("BasePart")

		if Parent2 then
			return Parent.Parent.Position
		else
			return nil
		end
	end)

	if not ok then
		result = nil
	end

	if not result then
		return false
	end

	if not t2.value17(result + Vector3.new(0, t2.value8.TP_OFFSET, 0)) then
		return false
	end

	local Character = t2.value6.Character

	if Character then
		Character = Character:FindFirstChild("HumanoidRootPart")
	end

	if Character then
		local v97 = result + Vector3.new(0, t2.value8.TP_OFFSET, 0)

		if (Character.Position - v97).Magnitude > 15 then
			t2.value17(v97)
		end
	end

	local Parent = p8.Parent
	local v99 = false

	for _ = 1, t2.value8.ACTIVATE_RETRIES do
		if not p8.Parent then
			v99 = true

			break
		end

		pcall(function()
			fireproximityprompt(p8)
		end)
		pcall(function()
			p8:InputHoldBegin()
			task.wait(0.05)
			p8:InputHoldEnd()
		end)
		pcall(function()
			local HoldDuration = p8.HoldDuration

			if HoldDuration then
				HoldDuration = p8.HoldDuration > 0
			end

			if not HoldDuration then
				return
			end

			p8.HoldDuration = 0
		end)
		task.wait(t2.value8.ACTIVATE_DELAY)

		if not (Parent and Parent.Parent and p8.Parent) then
			v99 = true

			break
		end
	end

	local now = tick()

	while tick() - now < 1 do
		if not (Parent and Parent.Parent and p8.Parent) then
			v99 = true

			break
		end

		task.wait(0.05)
	end

	if not v99 then
		return false
	end

	t2.value12.chestsThisSession = t2.value12.chestsThisSession + 1
	t2.value12.chestsTotal = t2.value12.chestsTotal + 1
	t2.value12.processedPrompts[p8] = true
	t2.value12.lastChestTime = tick()

	local v103 = t2.value14()

	if t2.value12.moneyCurrent < v103 then
		t2.value12.moneyTotal = t2.value12.moneyTotal + (v103 - t2.value12.moneyCurrent)
		t2.value12.moneyCurrent = v103
	end

	t2.value7.chestsTotal = t2.value12.chestsTotal
	t2.value7.moneyTotal = t2.value12.moneyTotal
	getgenv().Config = t2.value7

	local function v104()
		if not writefile then
			return
		end

		local makefolder_ = makefolder

		if makefolder_ then
			makefolder_ = isfolder
		end

		if makefolder_ then
			if not isfolder("Delta") then
				makefolder("Delta")
			end

			if not isfolder("Delta/Scripts") then
				makefolder("Delta/Scripts")
			end
		end

		writefile("Delta/Scripts/maximoff_config.json", t2.value4:JSONEncode(t2.value7))
	end

	pcall(v104)
	t2.value11("CHEST", "#" .. t2.value12.chestsThisSession)
	task.wait(t2.value16(t2.value8.PAUSE_MIN, t2.value8.PAUSE_MAX))

	return true
end
function t2.value22()
	local v106 = "https://games.roblox.com/v1/games/" .. game.PlaceId .. "/servers/Public?limit=100&sortOrder=Asc"
	local ok, result = pcall(function()
		return game:HttpGet(v106)
	end)

	if not (ok and result) then
		return nil
	end

	local function v109()
		return t2.value4:JSONDecode(result)
	end

	local ok2, result2 = pcall(v109)

	if ok2 and (result2 and result2.data) then
		return result2.data
	else
		return nil
	end
end

t2.value23 = nil

function t2.value23(p9)
	t2.value11("HOP", p9 or "Changing server...")
	t2.value12.isRunning = false
	t2.value7.autoFarmEnabled = true
	t2.value7.serverHopEnabled = t2.value8.SERVER_HOP_ENABLED
	t2.value7.chestsTotal = t2.value12.chestsTotal
	t2.value7.hopCount = t2.value12.hopCount + 1
	t2.value7.totalRuntime = t2.value12.totalRuntime
	t2.value7.lastJobId = game.JobId
	getgenv().Config = t2.value7

	local function v112()
		if not writefile then
			return
		end

		local makefolder_ = makefolder

		if makefolder_ then
			makefolder_ = isfolder
		end

		if makefolder_ then
			if not isfolder("Delta") then
				makefolder("Delta")
			end

			if not isfolder("Delta/Scripts") then
				makefolder("Delta/Scripts")
			end
		end

		writefile("Delta/Scripts/maximoff_config.json", t2.value4:JSONEncode(t2.value7))
	end

	pcall(v112)

	if type(t2.value12.visitedJobIds) ~= "table" then
		t2.value12.visitedJobIds = {}
	end

	t2.value13 = game.JobId
	t2.value12.visitedJobIds[t2.value13] = tick()

	local now = tick()

	for k, visitedJobId in pairs(t2.value12.visitedJobIds) do
		local v117 = type(visitedJobId) == "number"

		if v117 then
			v117 = now - visitedJobId > t2.value8.VISIT_EXPIRE
		end

		if v117 then
			t2.value12.visitedJobIds[k] = nil
		end
	end

	local v118 = math.random(3, 6)

	t2.value11("HOP", "Esperando " .. v118 .. "s para evitar rate limit...")
	task.wait(v118)
	t2.value11("HOP", "Buscando servidor nuevo...")

	local v119 = t2.value22()
	local v120 = nil
	local v121

	if v119 then
		v121 = #v119 > 0
	else
		v121 = v119
	end

	if v121 then
		local now2 = tick()
		local t5 = {}
		local n2 = 0
		local n3 = 0

		for _, v in ipairs(v119) do
			local v128 = v.playing >= v.maxPlayers
			local v129 = v.id == t2.value13
			local v130 = t2.value12.visitedJobIds[v.id]
			local v131 = false
			local v132

			if v130 then
				v132 = type(v130) == "number"
			else
				v132 = v130
			end

			if v132 then
				if now2 - v130 < t2.value8.VISIT_EXPIRE then
					v131 = true
				else
					n2 = n2 + 1
				end
			end

			if v131 then
				n3 = n3 + 1
			end

			local v133 = not v128

			if v133 then
				v133 = not v129

				if v133 then
					v133 = not v131
				end
			end

			if v133 then
				local id = v.id

				table.insert(t5, id)
			end
		end

		t2.value11("HOP", "Servidores: " .. #v119 .. " | Bloqueados: " .. n3 .. " | Disponibles: " .. #t5)

		if #t5 > 0 then
			v120 = t5[math.random(1, #t5)]
			t2.value11("HOP", "Servidor elegido: " .. string.sub(v120, 1, 8) .. "...")
		else
			t2.value11("HOP", "No hay servidores disponibles")
		end
	else
		t2.value11("HOP", "API no disponible")
	end

	if v120 then
		t2.value12.visitedJobIds[v120] = tick()

		local function v135()
			t2.value3:TeleportToPlaceInstance(game.PlaceId, v120, t2.value6)
		end

		local ok = pcall(v135)

		if ok then
			return true
		end

		t2.value11("HOP", "Error, usando Teleport normal")

		local function v138()
			t2.value3:Teleport(game.PlaceId, t2.value6)
		end

		pcall(v138)
	else
		local function v139()
			t2.value3:Teleport(game.PlaceId, t2.value6)
		end

		pcall(v139)
	end

	return true
end

t2.value24 = nil

function t2.value24(p10)
	return t2.value23(p10)
end
function t2.value25()
	if not t2.value8.HOP_ON_NO_CHESTS then
		return
	end

	if not t2.value12.isRunning then
		return
	end

	local v140, v141, v142 = pairs(workspace:GetDescendants())
	local n4 = 0

	while true do
		local v144

		v142, v144 = v140(v141, v142)

		if not v142 then
			break
		end

		local isProximityPrompt = v144:IsA("ProximityPrompt")

		if isProximityPrompt then
			isProximityPrompt = not t2.value12.processedPrompts[v144]
		end

		if isProximityPrompt and t2.value15(v144) then
			n4 = n4 + 1
		end
	end

	if n4 > 0 then
		t2.value12.lastChestTime = tick()

		return
	end

	local now = tick()
	local v147 = now - t2.value12.lastChestTime
	local v148 = v147 >= 2

	if v148 then
		v148 = t2.value12.lastScanCount == 0
	end

	if v148 then
		t2.value11("HOP", "No chests found after 2s - hopping immediately")
		t2.value12.hopCount = t2.value12.hopCount + 1
		t2.value12.lastChestTime = now
		t2.value24("No chests found")

		return
	end

	local v149 = t2.value8.RESET_CHESTS_AFTER <= v147

	if v149 then
		v149 = t2.value12.lastScanCount == 0
	end

	if v149 then
		t2.value11("HOP", "Reset de cofres procesados")
		t2.value12.processedPrompts = setmetatable({}, {
			__mode = "k"
		})
		t2.value12.lastChestTime = now

		return
	end

	if not (t2.value8.NO_CHESTS_TIMEOUT <= v147) then
		return
	end

	t2.value11("HOP", math.floor(v147) .. "s no chests - hop")
	t2.value12.hopCount = t2.value12.hopCount + 1
	t2.value12.lastChestTime = now
	t2.value24("No chests in map")
end

t2.value26 = nil

function t2.value26()
	local pairs_ = pairs
	local workspace_ = workspace
	local v152, v153, v154 = pairs_(workspace_.GetDescendants(workspace_))
	local t6 = {}

	while true do
		local v156

		v154, v156 = v152(v153, v154)

		if not v154 then
			break
		end

		if not t2.value12.isRunning then
			return
		end

		local isProximityPrompt = v156:IsA("ProximityPrompt")

		if isProximityPrompt then
			isProximityPrompt = not t2.value12.processedPrompts[v156]
		end

		if isProximityPrompt and t2.value15(v156) then
			table.insert(t6, v156)
		end
	end

	if #t6 > 0 then
		t2.value12.lastChestDetected = tick()

		if t2.value12.lastScanCount == #t6 then
			for _, v in ipairs(t6) do
				if not t2.value12.isRunning then
					return
				end

				t2.value21(v)
			end

			return
		end

		t2.value12.lastScanCount = #t6
		t2.value11("SCAN", #t6 .. " chests")
	else
		t2.value12.lastScanCount = 0
	end

	for _, v in ipairs(t6) do
		if not t2.value12.isRunning then
			return
		end

		t2.value21(v)
	end
end
function t2.value27()
	if t2.value12.isRunning then
		return
	end

	t2.value12.isRunning = true
	t2.value12.sessionStartTime = tick()
	t2.value12.chestsThisSession = 0
	t2.value12.moneyStart = t2.value14()
	t2.value12.moneyCurrent = t2.value12.moneyStart
	t2.value12.processedPrompts = setmetatable({}, {
		__mode = "k"
	})
	t2.value12.lastChestTime = tick()
	t2.value12.lastChestDetected = tick()
	t2.value12.lastScanCount = -1
	t2.value12.lastLoadedJobId = game.JobId
	t2.value11("START", "Auto Farm started")
	t2.value7.autoFarmEnabled = true
	getgenv().Config = t2.value7

	local function v162()
		if not writefile then
			return
		end

		local makefolder_ = makefolder

		if makefolder_ then
			makefolder_ = isfolder
		end

		if makefolder_ then
			if not isfolder("Delta") then
				makefolder("Delta")
			end

			if not isfolder("Delta/Scripts") then
				makefolder("Delta/Scripts")
			end
		end

		writefile("Delta/Scripts/maximoff_config.json", t2.value4:JSONEncode(t2.value7))
	end

	pcall(v162)
	task.spawn(function()
		task.wait(0.5)
		t2.value20()

		for _ = 1, 8 do
			task.wait(1.5)

			if t2.value6.Character then
				t2.value11("START", "In match")

				return
			end
		end
	end)
	task.spawn(function()
		task.wait(t2.value8.INITIAL_SCAN_DELAY)

		while t2.value12.isRunning do
			t2.value26()

			if t2.value8.SERVER_HOP_ENABLED and t2.value12.chestsThisSession >= t2.value8.CHESTS_BEFORE_HOP then
				t2.value12.hopCount = t2.value12.hopCount + 1
				t2.value11("HOP", "Hop #" .. t2.value12.hopCount)
				t2.value24("Chest collected")
				task.wait(t2.value8.WAIT_AFTER_HOP)
				t2.value12.chestsThisSession = 0
			end

			task.wait(0.05)
		end
	end)
	task.spawn(function()
		task.wait(t2.value8.INITIAL_SCAN_DELAY + 3)

		while t2.value12.isRunning do
			task.wait(t2.value8.NO_CHESTS_CHECK_INTERVAL)

			if t2.value12.isRunning then
				pcall(t2.value25)
			end
		end
	end)
end
function t2.value28()
	t2.value12.isRunning = false

	if t2.value12.sessionStartTime > 0 then
		t2.value12.totalRuntime = t2.value12.totalRuntime + (tick() - t2.value12.sessionStartTime)
		t2.value12.sessionStartTime = 0
		t2.value7.totalRuntime = t2.value12.totalRuntime
	end

	t2.value7.autoFarmEnabled = false
	getgenv().Config = t2.value7

	local function v165()
		if not writefile then
			return
		end

		local makefolder_ = makefolder

		if makefolder_ then
			makefolder_ = isfolder
		end

		if makefolder_ then
			if not isfolder("Delta") then
				makefolder("Delta")
			end

			if not isfolder("Delta/Scripts") then
				makefolder("Delta/Scripts")
			end
		end

		writefile("Delta/Scripts/maximoff_config.json", t2.value4:JSONEncode(t2.value7))
	end

	pcall(v165)
	t2.value11("STOP", "Auto Farm stopped")
end

t1.value14 = "Color3"
t1.value19 = 14098696231333

local color3 = Color3.fromRGB

t1.value15 = 18
t1.value16 = "\6ȗ\229"
t1.value14 = 18

local color32 = color3(t1.value14, t1.value15, 28)

t1.value15 = Color3
t1.value17 = "\132a\145(\154\148\135\193\158"
t1.value16 = 28
t1.value18 = 12742172743469
t1.value15 = t1.value15.fromRGB(28, t1.value16, 42)
t1.value16 = Color3.fromRGB(38, 38, 55)

local color33 = Color3.fromRGB

t1.value18 = 138
t1.value19 = 43
t1.value17 = color33(t1.value18, t1.value19, 226)
t1.value18 = Color3.fromRGB
t1.value21 = "\191?m"
t1.value20 = 200
t1.value19 = t1.value18(0, t1.value20, 255)
t1.value20 = Color3.fromRGB(220, 40, 60)
t1.value21 = Color3.fromRGB(80, 200, 120)

local color34 = Color3.fromRGB(220, 80, 80)
local color35 = Color3.fromRGB(245, 245, 250)
local color36 = Color3.fromRGB(140, 150, 180)
local color37 = Color3.fromRGB(90, 100, 130)
local color38 = Color3.fromRGB(45, 45, 65)
local color39 = Color3.fromRGB(0, 200, 255)

t2.value29 = {
	Background = color32,
	Card = t1.value15,
	CardHover = t1.value16,
	Purple = t1.value17,
	Cyan = t1.value19,
	Red = t1.value20,
	Success = t1.value21,
	Danger = color34,
	Text = color35,
	TextDim = color36,
	TextMuted = color37,
	ToggleOff = color38,
	ToggleOn = color39
}

local function v176(p11, p12)
	local instance = Instance.new(p11)

	for k, v in pairs(p12) do
		instance[k] = v
	end

	return instance
end
local function v180(p13, p14, p15)
	local tween = t2.value2:Create(p13, TweenInfo.new(p14, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), p15)

	tween:Play()

	return tween
end

t1.value17 = 29166342337805
t1.value19 = 23772463803197
t1.value21 = 13880983935295
t2.value30 = v176("ScreenGui", {
	Name = "MaximoffUI",
	ResetOnSpawn = false,
	DisplayOrder = 2147483647,
	Parent = t2.value6:WaitForChild("PlayerGui")
})
t1.value15 = UDim2
t1.value20 = "\140\151&_"
t1.value18 = "\171n\128"
t1.value17 = 10
t1.value15 = t1.value15.new(0, 10, 0, t1.value17)

local buttonPosition = t2.value7.buttonPosition

t1.value19 = UDim2
t1.value20 = 32
t1.value21 = 32
t1.value19 = t1.value19.new(0, t1.value20, 0, t1.value21)

local value2 = t1.value2
local value22 = t1.value2

t1.value20 = value2
t1.value21 = value22

if buttonPosition then
	buttonPosition = UDim2.new(buttonPosition.xScale, buttonPosition.xOffset, buttonPosition.yScale, buttonPosition.yOffset)
end

t1.value2 = t1.value21

local value15 = buttonPosition or t1.value15

t1.value2 = t1.value20
t1.value22 = 28644960089114
t1.value24 = 35019003641778
t1.value25 = 11418785977541
t1.value23 = "_\4\209"

local Red = t2.value29.Red

t1.value26 = 30762026612724
t1.value24 = ""
t2.value31 = v176("TextButton", {
	Size = t1.value19,
	Position = value15,
	BackgroundColor3 = Red,
	BorderSizePixel = 0,
	Text = "",
	AutoButtonColor = false,
	ClipsDescendants = true,
	Active = true,
	Parent = t2.value30
})
t1.value19 = UDim.new
t1.value20 = 0
v176("UICorner", {
	CornerRadius = t1.value19(t1.value20, 8),
	Parent = t2.value31
})
t1.value19 = UDim2.new
t1.value25 = 21001516770867
t1.value24 = 23377003817605
t1.value20 = 1

local v187 = t1.value19(t1.value20, -4, 1, -4)

t1.value20 = UDim2.new
t1.value22 = 0

local v188 = t1.value20(0.5, 0, 0.5, t1.value22)

t1.value21 = Vector2.new
t1.value22 = 0.5
t1.value23 = "\240#_\223+Ϧs\185\182-l\190\15\1\175>\173xt֨"

local v189 = t1.value21(0.5, t1.value22)
local color310 = Color3.fromRGB

t1.value26 = "\239\1920\172\191\168z\183\150"
t1.value25 = 255
t1.value24 = color310(255, t1.value25, 255)

local Fit = Enum.ScaleType.Fit

t1.value17 = {
	Size = v187,
	Position = v188,
	AnchorPoint = v189,
	BackgroundTransparency = 1,
	Image = "rbxassetid://132166827777190",
	ImageColor3 = t1.value24,
	ScaleType = Fit,
	Parent = t2.value31
}
t1.value22 = "Qڛ"
t1.value20 = "O\208\226tBh\248r"

local ImageLabel = v176("ImageLabel", t1.value17)
local uDimNew = UDim.new

t1.value22 = 3963447052085
t1.value24 = 15907642301679
t1.value20 = uDimNew(0, 6)
t1.value18 = {
	CornerRadius = t1.value20,
	Parent = ImageLabel
}
t1.value20 = "Жs\211\8"
t1.value22 = "=4A"
v176("UICorner", t1.value18)

local uDim2New = UDim2.new

t1.value23 = "\15\147\249\190\23P&"
t1.value22 = 28652443333662
t1.value25 = 5065916205367
t1.value20 = uDim2New(1, 0, 1, 0)
t1.value21 = Color3
t1.value23 = 22435538872527

local fromRGB = t1.value21.fromRGB

t1.value22 = 255
t1.value21 = fromRGB(255, 255, t1.value22)
t2.value32 = v176("Frame", {
	Size = t1.value20,
	BackgroundColor3 = t1.value21,
	BackgroundTransparency = 1,
	BorderSizePixel = 0,
	ZIndex = 2,
	Parent = t2.value31
})

local UDim_ = UDim

t1.value23 = 20186019538103
v176("UICorner", {
	CornerRadius = UDim_.new(0, 8),
	Parent = t2.value32
})
t2.value33 = false
t2.value34 = nil
t2.value35 = nil
t2.value36 = false

local InputBegan = t2.value31.InputBegan

function t1.value21(p16)
	if not (p16.UserInputType == Enum.UserInputType.MouseButton1 or p16.UserInputType == Enum.UserInputType.Touch) then
		return
	end

	t2.value33 = true
	t2.value36 = false
	t2.value34 = p16.Position
	t2.value35 = t2.value31.Position
end

InputBegan:Connect(t1.value21)
t1.value22 = "z_-\206\213\245ߥ8\157\3\'"

local InputChanged = UserInputService.InputChanged

function t1.value21(p17)
	local value33 = t2.value33

	if value33 then
		value33 = p17.UserInputType == Enum.UserInputType.MouseMovement or p17.UserInputType == Enum.UserInputType.Touch
	end

	if not value33 then
		return
	end

	local v200 = p17.Position - t2.value34
	local X = v200.X
	local v202 = math.abs(X) > 5

	if not v202 then
		local Y = v200.Y

		v202 = math.abs(Y) > 5
	end

	if v202 then
		t2.value36 = true
	end

	if not t2.value36 then
		return
	end

	t2.value31.Position = UDim2.new(t2.value35.X.Scale, t2.value35.X.Offset + v200.X, t2.value35.Y.Scale, t2.value35.Y.Offset + v200.Y)
end

local Connect = InputChanged.Connect

t1.value23 = "$\227\191\28"
Connect(InputChanged, t1.value21)

function t1.value21(p18)
	if not (p18.UserInputType == Enum.UserInputType.MouseButton1 or p18.UserInputType == Enum.UserInputType.Touch) then
		return
	end

	local value33 = t2.value33

	if value33 then
		value33 = t2.value36
	end

	if not value33 then
		return
	end

	t2.value7.buttonPosition = {
		xScale = t2.value31.Position.X.Scale,
		xOffset = t2.value31.Position.X.Offset,
		yScale = t2.value31.Position.Y.Scale,
		yOffset = t2.value31.Position.Y.Offset
	}
	getgenv().Config = t2.value7

	local function v206()
		if not writefile then
			return
		end

		local makefolder_ = makefolder

		if makefolder_ then
			makefolder_ = isfolder
		end

		if makefolder_ then
			if not isfolder("Delta") then
				makefolder("Delta")
			end

			if not isfolder("Delta/Scripts") then
				makefolder("Delta/Scripts")
			end
		end

		writefile("Delta/Scripts/maximoff_config.json", t2.value4:JSONEncode(t2.value7))
	end

	pcall(v206)
	t2.value11("DRAG", "Boton movido y guardado")
end

UserInputService.InputEnded:Connect(t1.value21)
t1.value22 = UDim2
t1.value23 = 260
t1.value24 = 280
t1.value22 = t1.value22.new(0, t1.value23, 0, t1.value24)

local uDim2New2 = UDim2.new

t1.value24 = -270
t1.value23 = uDim2New2(1, t1.value24, 0, 50)

local Background = t2.value29.Background

t2.value37 = v176("Frame", {
	Size = t1.value22,
	Position = t1.value23,
	BackgroundColor3 = Background,
	BorderSizePixel = 0,
	Active = true,
	Draggable = true,
	Visible = false,
	Parent = t2.value30
})
t1.value23 = 15761948712107
t1.value24 = 17160146640694
t1.value26 = 12878463326061
t1.value22 = UDim.new
t1.value23 = 0
t1.value25 = 22483137276133
v176("UICorner", {
	CornerRadius = t1.value22(t1.value23, 16),
	Parent = t2.value37
})
t1.value23 = 33976900074957
t1.value24 = 5465413028337
t1.value22 = t2.value29.Purple
v176("UIStroke", {
	Color = t1.value22,
	Thickness = 1,
	Transparency = 0.6,
	Parent = t2.value37
})
t1.value24 = 16740922367603
t1.value25 = "[R%"
t1.value23 = 26305165111257

local UDim2_ = UDim2

t1.value25 = 33306951318677
t1.value24 = 0
t1.value22 = UDim2_.new
t1.value23 = 1

local v211 = t1.value22(t1.value23, 0, t1.value24, 45)

t1.value23 = t2.value29.Card
t1.value26 = 30458372700007

local Frame = v176("Frame", {
	Size = v211,
	BackgroundColor3 = t1.value23,
	BorderSizePixel = 0,
	Parent = t2.value37
})
local uDimNew2 = UDim.new

t1.value24 = 16
t1.value23 = uDimNew2(0, t1.value24)
v176("UICorner", {
	CornerRadius = t1.value23,
	Parent = Frame
})
t1.value23 = "޷\163\22\135"
t1.value24 = "G\1383\162"

local uDim2New3 = UDim2.new

t1.value25 = 12
t1.value24 = 0
t1.value23 = uDim2New3(1, t1.value24, 0, t1.value25)

local uDim2New4 = UDim2.new

t1.value26 = -12
t1.value24 = uDim2New4(0, 0, 1, t1.value26)

local Card = t2.value29.Card
local t7 = {
	Size = t1.value23,
	Position = t1.value24,
	BackgroundColor3 = Card,
	BorderSizePixel = 0,
	Parent = Frame
}

t1.value23 = "\245\210\237ɏ"
v176("Frame", t7)
t1.value23 = UDim2
t1.value25 = 6
t1.value24 = 6
t1.value23 = t1.value23.new(0, t1.value24, 0, t1.value25)
t1.value25 = "\229\0Ӊ\238\19\183\207"
t1.value24 = UDim2.new(0, 12, 0, 20)
t1.value25 = t1.value2

local autoFarmEnabled = t2.value7.autoFarmEnabled

if autoFarmEnabled then
	autoFarmEnabled = t2.value29.Success
end

t1.value2 = t1.value2

local Danger = autoFarmEnabled or t2.value29.Danger
local value25 = t1.value25

t1.value27 = 15360965925873
t1.value28 = "`.;(\23\145"
t1.value2 = value25
t1.value21 = v176("Frame", {
	Size = t1.value23,
	Position = t1.value24,
	BackgroundColor3 = Danger,
	BorderSizePixel = 0,
	Parent = Frame
})
t1.value25 = 32101888309860
t2.value38 = t1.value21
t1.value24 = 8587404726174
t1.value27 = 12539112937166
t1.value23 = UDim.new
t1.value24 = 1
t1.value22 = {
	CornerRadius = t1.value23(t1.value24, 0),
	Parent = t2.value38
}
v176("UICorner", t1.value22)
t1.value24 = 1221473157688
t1.value26 = "z\221\0"
t1.value25 = 15194142841763
t1.value23 = UDim2.new
t1.value24 = 1
t1.value25 = 0

local v221 = t1.value23(t1.value24, -60, t1.value25, 16)

t1.value24 = UDim2.new
t1.value26 = 0
t1.value25 = 0

local v222 = t1.value24(t1.value25, 24, t1.value26, 12)

t1.value27 = ".\177n}"
t1.value22 = {
	Size = v221,
	Position = v222,
	BackgroundTransparency = 1,
	Text = "Maximoff",
	TextColor3 = t2.value29.Text,
	TextSize = 12,
	Font = Enum.Font.GothamBold,
	TextXAlignment = Enum.TextXAlignment.Left,
	Parent = Frame
}
t1.value28 = 28477199070156
v176("TextLabel", t1.value22)
t1.value27 = 26475490684968
t1.value23 = UDim2.new
t1.value24 = 1
t1.value25 = 0

local v223 = t1.value23(t1.value24, -60, t1.value25, 12)
local UDim2_2 = UDim2

t1.value27 = "Om\237\17"
t1.value24 = UDim2_2.new
t1.value26 = 0
t1.value25 = 0
v176("TextLabel", {
	Size = v223,
	Position = t1.value24(t1.value25, 24, t1.value26, 26),
	BackgroundTransparency = 1,
	Text = "Made by @maximoff641",
	TextColor3 = t2.value29.Cyan,
	TextSize = 9,
	Font = Enum.Font.Gotham,
	TextXAlignment = Enum.TextXAlignment.Left,
	Parent = Frame
})
t1.value25 = 32553271606070
t1.value27 = 20653620651409
t1.value23 = UDim2.new
t1.value24 = 0
t1.value25 = 0

local v225 = t1.value23(t1.value24, 24, t1.value25, 24)

t1.value26 = 9041294725234

local UDim2_3 = UDim2

t1.value29 = 20568262092137
t1.value26 = 0
t1.value24 = UDim2_3.new
t1.value25 = 1

local v227 = t1.value24(t1.value25, -32, t1.value26, 10)
local value29 = t2.value29

t1.value27 = "\132\237\186\203\234\254\246\225\238n\207\21\250\239\193"
t1.value29 = "\206rq~"
t1.value28 = 16760239857276
t1.value25 = value29.CardHover
t1.value28 = t2.value29.TextDim

local GothamBold = Enum.Font.GothamBold

t1.value21 = v176("TextButton", {
	Size = v225,
	Position = v227,
	BackgroundColor3 = t1.value25,
	BorderSizePixel = 0,
	Text = "X",
	TextColor3 = t1.value28,
	TextSize = 11,
	Font = GothamBold,
	AutoButtonColor = false,
	Parent = Frame
})
t1.value25 = "\198%\138\14\28\163Y\251-\1555y"

local uDimNew3 = UDim.new

t1.value26 = "H\181\252Ļ~"
t1.value25 = 8
t1.value24 = uDimNew3(0, t1.value25)

local t8 = {
	CornerRadius = t1.value24,
	Parent = t1.value21
}

t1.value24 = "\172\5/\170\245"
v176("UICorner", t8)
t1.value25 = "\139\170\235\144"
t1.value24 = UDim2
t1.value27 = "Ic\204"

local new = t1.value24.new

t1.value25 = -20
t1.value24 = new(1, t1.value25, 0, 50)

local uDim2New5 = UDim2.new

t1.value26 = 10
t1.value27 = 9465382834487
t1.value25 = uDim2New5(0, t1.value26, 0, 55)

local Card2 = t2.value29.Card

t1.value28 = "E\184S\137r\14\138\154\147\02858\2224?"
t1.value29 = 11712597628238

local Frame2 = v176("Frame", {
	Size = t1.value24,
	Position = t1.value25,
	BackgroundColor3 = Card2,
	BorderSizePixel = 0,
	Parent = t2.value37
})

t1.value26 = 9081497129092
t1.value25 = 26712271712406
t1.value27 = 24051121875903
t1.value28 = "\157\232\""
t1.value24 = UDim.new
t1.value25 = 0
t1.value23 = {
	CornerRadius = t1.value24(t1.value25, 10),
	Parent = Frame2
}
v176("UICorner", t1.value23)
t1.value25 = 29735117796886
t1.value27 = 21137456424562
t1.value24 = UDim2.new
t1.value25 = 1

local v236 = t1.value24(t1.value25, -16, 0, 14)
local UDim2_4 = UDim2

t1.value29 = "\248҇y"
t1.value27 = 6
t1.value25 = UDim2_4.new
t1.value28 = 18536189321655
t1.value26 = 0

local v238 = t1.value25(t1.value26, 10, 0, t1.value27)
local value7 = t2.value7
local value23 = t1.value2
local value24 = t1.value2

t1.value27 = value23
t1.value29 = value24

local autoFarmEnabled2 = value7.autoFarmEnabled

t1.value28 = autoFarmEnabled2 and "ACTIVE" or autoFarmEnabled2

local value28 = t1.value28

t1.value2 = t1.value29

local v244 = not t1.value28 and "Stopped" or value28

t1.value2 = t1.value27

local value72 = t2.value7
local value26 = t1.value2

t1.value29 = t1.value2

local autoFarmEnabled3 = value72.autoFarmEnabled

if autoFarmEnabled3 then
	autoFarmEnabled3 = t2.value29.Cyan
end

t1.value2 = value26
t1.value28 = autoFarmEnabled3

if not autoFarmEnabled3 then
	t1.value28 = t2.value29.TextDim
end

t1.value2 = t1.value29

local GothamBold2 = Enum.Font.GothamBold
local Left = Enum.TextXAlignment.Left

t1.value22 = v176("TextLabel", {
	Size = v236,
	Position = v238,
	BackgroundTransparency = 1,
	Text = v244,
	TextColor3 = t1.value28,
	TextSize = 10,
	Font = GothamBold2,
	TextXAlignment = Left,
	Parent = Frame2
})
t1.value25 = "\228M\142\29~\195b\232="
t2.value39 = t1.value22
t1.value25 = UDim2

local new2 = t1.value25.new

t1.value26 = -16
t1.value25 = new2(1, t1.value26, 0, 12)

local uDim2New6 = UDim2.new

t1.value29 = 16447669198315
t1.value26 = uDim2New6(0, 10, 0, 22)
t1.value29 = t2.value29.TextMuted

local Gotham = Enum.Font.Gotham
local Left2 = Enum.TextXAlignment.Left

t1.value22 = v176("TextLabel", {
	Size = t1.value25,
	Position = t1.value26,
	BackgroundTransparency = 1,
	Text = "0 chests - 0 hops",
	TextColor3 = t1.value29,
	TextSize = 8,
	Font = Gotham,
	TextXAlignment = Left2,
	Parent = Frame2
})
t2.value40 = t1.value22
t1.value26 = 5843915213473
t1.value25 = UDim2.new
t1.value26 = 1

local v254 = t1.value25(t1.value26, -20, 0, 42)
local UDim2_5 = UDim2

t1.value28 = 0
t1.value26 = UDim2_5.new
t1.value29 = 115
t1.value22 = v176("Frame", {
	Size = v254,
	Position = t1.value26(0, 10, t1.value28, t1.value29),
	BackgroundColor3 = t2.value29.Card,
	BorderSizePixel = 0,
	Parent = t2.value37
})
t1.value26 = "a\2331\25\0203?\143"
t1.value26 = UDim
t1.value28 = "\160L\19\225\227\15"
t1.value26 = t1.value26.new(0, 10)
v176("UICorner", {
	CornerRadius = t1.value26,
	Parent = t1.value22
})
t1.value26 = "\30k\11\213\238\6\29\137\239"
t1.value29 = "e\231\197"

local uDim2New7 = UDim2.new

t1.value29 = 3344019408405
t1.value28 = 14
t1.value26 = uDim2New7(1, -80, 0, t1.value28)

local UDim2_6 = UDim2

t1.value28 = 10

local uDim2 = UDim2_6.new(0, t1.value28, 0, 6)
local Text = t2.value29.Text
local GothamBold3 = Enum.Font.GothamBold
local Left3 = Enum.TextXAlignment.Left
local t9 = {
	Size = t1.value26,
	Position = uDim2,
	BackgroundTransparency = 1,
	Text = "Auto Farm",
	TextColor3 = Text,
	TextSize = 10,
	Font = GothamBold3,
	TextXAlignment = Left3,
	Parent = t1.value22
}

t1.value26 = "?\166\144zK\228\0\t\7"
v176("TextLabel", t9)

local uDim2New8 = UDim2.new

t1.value28 = 10
t1.value26 = uDim2New8(1, -80, 0, t1.value28)

local UDim2_7 = UDim2

t1.value28 = 10

local uDim22 = UDim2_7.new(0, t1.value28, 0, 22)
local TextMuted = t2.value29.TextMuted
local Gotham2 = Enum.Font.Gotham
local Left4 = Enum.TextXAlignment.Left

v176("TextLabel", {
	Size = t1.value26,
	Position = uDim22,
	BackgroundTransparency = 1,
	Text = "Farm chests",
	TextColor3 = TextMuted,
	TextSize = 8,
	Font = Gotham2,
	TextXAlignment = Left4,
	Parent = t1.value22
})
t1.value29 = "!3_"

local uDim2New9 = UDim2.new

t1.value29 = 5635195750976
t1.value26 = uDim2New9(0, 36, 0, 20)

local uDim2New10 = UDim2.new

t1.value29 = 0.5

local uDim23 = uDim2New10(1, -46, t1.value29, -10)
local autoFarmEnabled4 = t2.value7.autoFarmEnabled

t1.value29 = autoFarmEnabled4

if autoFarmEnabled4 then
	t1.value29 = t2.value29.ToggleOn
end

local value27 = t1.value2
local value292 = t1.value29

t1.value2 = value27
t1.value27 = value292

if not t1.value29 then
	t1.value27 = t2.value29.ToggleOff
end

t2.value41 = v176("TextButton", {
	Size = t1.value26,
	Position = uDim23,
	BackgroundColor3 = t1.value27,
	BorderSizePixel = 0,
	Text = "",
	AutoButtonColor = false,
	Parent = t1.value22
})
v176("UICorner", {
	CornerRadius = UDim.new(1, 0),
	Parent = t2.value41
})
t1.value26 = UDim2.new
t1.value28 = 0
t1.value27 = 14

local v275 = t1.value26(0, t1.value27, t1.value28, 14)
local autoFarmEnabled5 = t2.value7.autoFarmEnabled

t1.value28 = autoFarmEnabled5

if autoFarmEnabled5 then
	t1.value28 = UDim2.new(0, 19, 0.5, -7)
end

local value282 = t1.value28

if not t1.value28 then
	value282 = UDim2.new(0, 3, 0.5, -7)
end

t1.value28 = t2.value29.Text
t2.value42 = v176("Frame", {
	Size = v275,
	Position = value282,
	BackgroundColor3 = t1.value28,
	BorderSizePixel = 0,
	Parent = t2.value41
})
v176("UICorner", {
	CornerRadius = UDim.new(1, 0),
	Parent = t2.value42
})

local uDim24 = UDim2.new(1, -20, 0, 42)

t1.value28 = UDim2.new(0, 10, 0, 162)
t1.value29 = t2.value29.Card

local Frame3 = v176("Frame", {
	Size = uDim24,
	Position = t1.value28,
	BackgroundColor3 = t1.value29,
	BorderSizePixel = 0,
	Parent = t2.value37
})

t1.value27 = UDim.new(0, 10)
v176("UICorner", {
	CornerRadius = t1.value27,
	Parent = Frame3
})
t1.value27 = UDim2.new(1, -80, 0, 14)
t1.value29 = UDim2.new(0, 10, 0, 6)

local Text2 = t2.value29.Text
local GothamBold4 = Enum.Font.GothamBold
local Left5 = Enum.TextXAlignment.Left

v176("TextLabel", {
	Size = t1.value27,
	Position = t1.value29,
	BackgroundTransparency = 1,
	Text = "Hop no chests (8s)",
	TextColor3 = Text2,
	TextSize = 10,
	Font = GothamBold4,
	TextXAlignment = Left5,
	Parent = Frame3
})
t1.value27 = UDim2.new(1, -80, 0, 10)
t1.value29 = UDim2.new(0, 10, 0, 22)

local TextMuted2 = t2.value29.TextMuted
local Gotham3 = Enum.Font.Gotham
local Left6 = Enum.TextXAlignment.Left

v176("TextLabel", {
	Size = t1.value27,
	Position = t1.value29,
	BackgroundTransparency = 1,
	Text = "Change server",
	TextColor3 = TextMuted2,
	TextSize = 8,
	Font = Gotham3,
	TextXAlignment = Left6,
	Parent = Frame3
})
t1.value27 = UDim2.new(0, 36, 0, 20)
t1.value29 = UDim2.new(1, -46, 0.5, -10)

local ToggleOn = t2.value29.ToggleOn

t1.value25 = v176("TextButton", {
	Size = t1.value27,
	Position = t1.value29,
	BackgroundColor3 = ToggleOn,
	BorderSizePixel = 0,
	Text = "",
	AutoButtonColor = false,
	Parent = Frame3
})
t2.value43 = t1.value25
t1.value28 = UDim.new(1, 0)
v176("UICorner", {
	CornerRadius = t1.value28,
	Parent = t2.value43
})
t1.value28 = UDim2.new(0, 14, 0, 14)

local uDim25 = UDim2.new(0, 19, 0.5, -7)
local Text3 = t2.value29.Text

t1.value25 = v176("Frame", {
	Size = t1.value28,
	Position = uDim25,
	BackgroundColor3 = Text3,
	BorderSizePixel = 0,
	Parent = t2.value43
})
t2.value44 = t1.value25
t1.value29 = UDim.new(1, 0)
v176("UICorner", {
	CornerRadius = t1.value29,
	Parent = t2.value44
})
t1.value29 = UDim2.new(1, -20, 0, 36)

local uDim26 = UDim2.new(0, 10, 0, 215)
local Card3 = t2.value29.Card
local Text4 = t2.value29.Text
local GothamBold5 = Enum.Font.GothamBold

t1.value25 = v176("TextButton", {
	Size = t1.value29,
	Position = uDim26,
	BackgroundColor3 = Card3,
	BorderSizePixel = 0,
	Text = "Server Hop Now",
	TextColor3 = Text4,
	TextSize = 10,
	Font = GothamBold5,
	AutoButtonColor = false,
	Parent = t2.value37
})
v176("UICorner", {
	CornerRadius = UDim.new(0, 8),
	Parent = t1.value25
})
t1.value29 = t2.value29.Cyan
v176("UIStroke", {
	Color = t1.value29,
	Thickness = 1,
	Transparency = 0.5,
	Parent = t1.value25
})
v176("TextLabel", {
	Size = UDim2.new(1, -20, 0, 14),
	Position = UDim2.new(0, 10, 1, -18),
	BackgroundTransparency = 1,
	Text = "Maximoff",
	TextColor3 = t2.value29.Success,
	TextSize = 7,
	Font = Enum.Font.Gotham,
	Parent = t2.value37
})

local autoFarmEnabled6 = t2.value7.autoFarmEnabled

function t1.value27(p19, p20, p21)
	local ToggleOn2

	if p21 then
		ToggleOn2 = t2.value29.ToggleOn
	else
		ToggleOn2 = p21
	end

	local ToggleOff = ToggleOn2 or t2.value29.ToggleOff

	if not p21 then
		v309 = p21 or UDim2.new(0, 3, 0.5, -7)
		t2.value2:Create(p19, TweenInfo.new(0.25, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), {
			BackgroundColor3 = ToggleOff
		}):Play()
		t2.value2:Create(p20, TweenInfo.new(0.25, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), {
			Position = v309
		}):Play()

		return
	end

	p21 = UDim2.new(0, 19, 0.5, -7)

	local uDim27 = p21 or UDim2.new(0, 3, 0.5, -7)

	t2.value2:Create(p19, TweenInfo.new(0.25, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), {
		BackgroundColor3 = ToggleOff
	}):Play()
	t2.value2:Create(p20, TweenInfo.new(0.25, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), {
		Position = uDim27
	}):Play()
end

t2.value45 = autoFarmEnabled6
t2.value46 = t1.value27
t2.value41.MouseButton1Click:Connect(function()
	t2.value45 = not t2.value45
	t2.value46(t2.value41, t2.value42, t2.value45)

	if t2.value45 then
		t2.value27()
		t2.value39.Text = "ACTIVE"
		t2.value39.TextColor3 = t2.value29.Cyan
		v180(t2.value38, 0.3, {
			BackgroundColor3 = t2.value29.Success
		})
	else
		t2.value28()
		t2.value39.Text = "Stopped"
		t2.value39.TextColor3 = t2.value29.TextDim
		v180(t2.value38, 0.3, {
			BackgroundColor3 = t2.value29.Danger
		})
	end
end)
t1.value27 = t2.value43.MouseButton1Click

function t1.value29()
	local hopOnNoChests = not t2.value8.HOP_ON_NO_CHESTS

	t2.value8.HOP_ON_NO_CHESTS = hopOnNoChests
	t2.value8.SERVER_HOP_ENABLED = hopOnNoChests
	t2.value7.serverHopEnabled = hopOnNoChests
	t2.value46(t2.value43, t2.value44, hopOnNoChests)
	getgenv().Config = t2.value7

	local function v298()
		if not writefile then
			return
		end

		local makefolder_ = makefolder

		if makefolder_ then
			makefolder_ = isfolder
		end

		if makefolder_ then
			if not isfolder("Delta") then
				makefolder("Delta")
			end

			if not isfolder("Delta/Scripts") then
				makefolder("Delta/Scripts")
			end
		end

		writefile("Delta/Scripts/maximoff_config.json", t2.value4:JSONEncode(t2.value7))
	end

	pcall(v298)
end

t1.value27:Connect(t1.value29)

local value293 = t2.value29;

(function(p22, p23, p24)
	p22.MouseEnter:Connect(function()
		local v301 = p22
		local t10 = {
			BackgroundColor3 = p24
		}

		t2.value2:Create(v301, TweenInfo.new(0.15, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), t10):Play()
	end)
	p22.MouseLeave:Connect(function()
		local v303 = p22
		local t11 = {
			BackgroundColor3 = p23
		}

		t2.value2:Create(v303, TweenInfo.new(0.15, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), t11):Play()
	end)
end)(t1.value25, value293.Card, t2.value29.CardHover)
t1.value28 = t2.value31.MouseEnter
t1.value28:Connect(function()
	local value31 = t2.value31
	local t12 = {
		BackgroundColor3 = Color3.fromRGB(255, 60, 80)
	}

	t2.value2:Create(value31, TweenInfo.new(0.15, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), t12):Play()

	local value32 = t2.value32

	t2.value2:Create(value32, TweenInfo.new(0.15, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), {
		BackgroundTransparency = 0.9
	}):Play()
end)
t1.value28 = t2.value31.MouseLeave
t1.value28:Connect(function()
	local value31 = t2.value31
	local t13 = {
		BackgroundColor3 = t2.value29.Red
	}

	t2.value2:Create(value31, TweenInfo.new(0.15, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), t13):Play()

	local value32 = t2.value32

	t2.value2:Create(value32, TweenInfo.new(0.15, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), {
		BackgroundTransparency = 1
	}):Play()
end)
t2.value47 = false
t1.value28 = t2.value31.MouseButton1Click
t1.value28:Connect(function()
	if not t2.value36 then
		t2.value47 = not t2.value47

		if t2.value47 then
			t2.value37.Visible = true
			t2.value37.Size = UDim2.new(0, 0, 0, 0)
			v180(t2.value37, 0.3, {
				Size = UDim2.new(0, 260, 0, 280)
			})

			return
		else
			v180(t2.value37, 0.2, {
				Size = UDim2.new(0, 0, 0, 0)
			})
			task.wait(0.2)
			t2.value37.Visible = false

			return
		end
	end
end)
t1.value21.MouseButton1Click:Connect(function()
	local value37 = t2.value37
	local t14 = {
		Size = UDim2.new(0, 0, 0, 0)
	}

	t2.value2:Create(value37, TweenInfo.new(0.2, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), t14):Play()
	task.wait(0.2)
	t2.value37.Visible = false
end)
t1.value25.MouseButton1Click:Connect(function()
	t2.value12.hopCount = t2.value12.hopCount + 1
	t2.value24("Manual hop")
end)
task.spawn(function()
	while t2.value30.Parent do
		pcall(function()
			local n5 = 0
			local v314 = t2.value12.sessionStartTime > 0

			if v314 then
				v314 = t2.value12.isRunning
			end

			local v315

			if v314 then
				n5 = tick() - t2.value12.sessionStartTime
				v315 = n5
			else
				v315 = n5
			end

			t2.value39.Text = t2.value12.isRunning and "ACTIVE" or "Stopped"

			local value39 = t2.value39
			local isRunning2 = t2.value12.isRunning

			if isRunning2 then
				isRunning2 = t2.value29.Cyan
			end

			value39.TextColor3 = isRunning2 or t2.value29.TextDim

			local value38 = t2.value38
			local isRunning3 = t2.value12.isRunning

			if not isRunning3 then
				value38.BackgroundColor3 = isRunning3 or t2.value29.Danger
				t2.value40.Text = t2.value12.chestsThisSession .. " chests - " .. t2.value12.hopCount .. " hops - " .. math.floor(v315) .. "s"

				return
			end

			isRunning3 = t2.value29.Success
			value38.BackgroundColor3 = isRunning3 or t2.value29.Danger
			t2.value40.Text = t2.value12.chestsThisSession .. " chests - " .. t2.value12.hopCount .. " hops - " .. math.floor(v315) .. "s"
		end)
		task.wait(1)
	end
end)
task.spawn(function()
	task.wait(3)

	if t2.value7.autoFarmEnabled then
		t2.value11("AFK", "Auto Farm was ACTIVE. Restarting...")
		task.wait(2)
		t2.value46(t2.value41, t2.value42, true)
		t2.value39.Text = "ACTIVE"
		t2.value39.TextColor3 = t2.value29.Cyan
		v180(t2.value38, 0.3, {
			BackgroundColor3 = t2.value29.Success
		})
		t2.value27()
		t2.value11("AFK", "Auto Farm restarted")
	else
		t2.value11("INIT", "Activate \'Auto Farm\' manually")
	end
end)
