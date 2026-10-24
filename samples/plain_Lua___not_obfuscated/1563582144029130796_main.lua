--[[
	K2 Auto Accept — Full Screen
	Chocola accept + K2 cancel + base brainrot list (money/s)
]]

repeat task.wait() until game:IsLoaded()

local Players = game:GetService("Players")
local UserInputService = game:GetService("UserInputService")
local CoreGui = game:GetService("CoreGui")
local HttpService = game:GetService("HttpService")
local RunService = game:GetService("RunService")
local TweenService = game:GetService("TweenService")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local VirtualInputManager = game:GetService("VirtualInputManager")
local LocalPlayer = Players.LocalPlayer
local LP = LocalPlayer

local acceptEnabled = true

local CONFIG = {
	Brand = "K2",
	Title = "Auto Accept",
	Subtitle = "Auto Accept Active, Goodnight.",
	Discord = "discord.gg/k2scripts",
	SkyTop = Color3.fromRGB(4, 4, 14),
	SkyMid = Color3.fromRGB(12, 10, 32),
	SkyBottom = Color3.fromRGB(22, 12, 40),
	Accent = Color3.fromRGB(180, 195, 255),
	Glow = Color3.fromRGB(200, 210, 255),
	Success = Color3.fromRGB(0, 255, 120),
	Error = Color3.fromRGB(255, 80, 100),
	Muted = Color3.fromRGB(140, 150, 180),
	Card = Color3.fromRGB(14, 16, 28),
	CardBorder = Color3.fromRGB(90, 110, 170),
}

local MUTATION_MULT = {
	["None"] = 1, ["Default"] = 1, ["Gold"] = 1.25, ["Diamond"] = 1.5, ["Bloodrot"] = 2,
	["Candy"] = 4, ["Lava"] = 6, ["Galaxy"] = 7, ["Yin Yang"] = 7.5,
	["Radioactive"] = 8.5, ["Cursed"] = 9, ["Divine"] = 10, ["Rainbow"] = 10,
	["Cyber"] = 11, ["Phantom"] = 12, ["Crystal"] = 13, ["Eclipse"] = 14,
}

------------------------------------------------------------
-- TARGETS + CANCEL
------------------------------------------------------------
local TargetBrainrots = {
	["Spyder Elephant"] = true, ["Strawberry Elephant"] = true, ["Meowl"] = true,
	["Headless Horseman"] = true, ["John Pork"] = true, ["Skibidi Toilet"] = true,
	["Los Dragons"] = true, ["Griffin"] = true, ["Dragon Aquanini"] = true,
	["Dragon Gingerini"] = true, ["Hydra Dragon Cannelloni"] = true, ["Dragon Cannelloni"] = true,
	["Moby Bros"] = true, ["Love Love Bear"] = true, ["Digi Narwhal"] = true,
	["Kraken"] = true, ["La Supreme Combinasion"] = true, ["Hydra Bunny"] = true,
	["Cerberus"] = true, ["Jelly Moby"] = true, ["Celestial Pegasus"] = true,
	["Venuspino"] = true, ["Bumbatron"] = true, ["Bunny and Eggy"] = true,
	["Popcuru and Fizzuru"] = true, ["Rosey and Teddy"] = true, ["La Breakfast Combinasion"] = true,
	["Capitano Moby"] = true, ["Orchidox"] = true, ["Cooki and Milki"] = true,
	["Los Secret Combinasionas"] = true, ["Arcadragon"] = true, ["Burguro And Fryuro"] = true,
	["Ketupat Bros"] = true, ["Reinito Sleighito"] = true, ["Fortunu and Cashuru"] = true,
	["Los Amigos"] = true, ["Pizza and Ranch"] = true, ["Pancake and Syrup"] = true,
	["La Secret Combinasion"] = true, ["Foxini Lanternini"] = true, ["Kalika Bros"] = true,
	["Sammyni Truckini"] = true, ["Los Sekolahs"] = true, ["Signore Carapace"] = true,
	["Cash or Card"] = true, ["Fragrama and Chocrama"] = true, ["La Casa Boo"] = true,
	["Los Admins"] = true, ["La Fuse Machine"] = true, ["Duggy Bros"] = true,
	["La Food Combinasion"] = true, ["Yetimatic"] = true, ["Gold and Diamond"] = true,
	["S'more Serat"] = true, ["Sammyni Cakini"] = true, ["Elefanto Frigo"] = true,
	["Boppin Bunny"] = true, ["Spooky and Pumpky"] = true, ["Cangurato Gelato"] = true,
	["La Craft Machine"] = true, ["Ginger Gerat"] = true, ["La Ginger Sekolah"] = true,
	["Los Chillis"] = true, ["Los Hackers"] = true, ["Bearito Cabinito"] = true,
	["Rubiko and Kubiko"] = true, ["Capitano Americano"] = true, ["Examen Bros"] = true,
	["Los Spaghettis"] = true, ["Rubrikiko"] = true, ["Sammyni Fattini"] = true,
	["Panda Popanda"] = true, ["Festive 67"] = true, ["Queen Bee"] = true,
	["Quackini Snackini"] = true, ["Ventoliero Pavonero"] = true, ["Pop Pop Petalini"] = true,
	["Grabatron"] = true, ["Los Tictacs"] = true, ["Spaghetti Tualetti"] = true,
	["Cloverat Clapat"] = true, ["Candini Fluffini"] = true, ["Polaroidini"] = true,
	["Caylusaurus"] = true, ["Hopilikalika Hopilikalako"] = true, ["La Easter Grande"] = true,
	["Steakini Fattini"] = true, ["Antonio"] = true, ["Garama and Madundung"] = true,
	["La Anniversary Grande"] = true, ["Nacho Spyder"] = true, ["Rosetti Tualetti"] = true,
	["Scorpino Coasterino"] = true, ["Chicli Chicla"] = true, ["Nachorilla"] = true,
	["Money Money Bros"] = true, ["Fishino Clownino"] = true, ["Jolly Jolly Sahur"] = true,
	["Gold Gold Gold"] = true, ["Lavadorito Spinito"] = true, ["Los Tangcitos"] = true,
	["Rico Dinero"] = true, ["Gym Bros"] = true, ["Ketchuru and Musturu"] = true,
	["Tirilikalika Tirilikalako"] = true, ["Swaggy Bros"] = true, ["La Lucky Grande"] = true,
	["La Romantic Grande"] = true, ["Orcaledon"] = true, ["Los Losers"] = true,
	["Tictac Sahur"] = true, ["Dug Dug Dug"] = true, ["Dug dug dug"] = true,
	["Ketupat Kepat"] = true, ["La Taco Combinasion"] = true, ["Coco and Mango"] = true,
	["Tang Tang Keletang"] = true, ["Abyssaloco"] = true, ["Esok Goala"] = true,
	["Lovin Rose"] = true, ["Noo my Resume"] = true, ["Noo my Examen"] = true,
	["Honey Honey Bear"] = true, ["Los Tacoritas"] = true, ["Bufalino Boomberino"] = true,
	["Eviledon"] = true, ["Puffino Builderino"] = true, ["Los Primos"] = true,
	["Sand Sand Sand"] = true, ["Los Mariachis"] = true, ["Los Puggies"] = true,
	["Los Cupids"] = true, ["Esok Sekolah"] = true, ["La Jolly Grande"] = true,
	["W or L"] = true, ["Noodle Noodle Poodle"] = true, ["Globa Steppa"] = true,
	["Tralaledon"] = true, ["Gobblino Uniciclino"] = true, ["Tacoturbo Tacorito"] = true,
	["Tuff Toucan"] = true, ["Mieteteira Bicicleteira"] = true, ["Money Money Reindeer"] = true,
	["Chillin Chili"] = true, ["Chipso and Queso"] = true, ["La Spooky Grande"] = true,
	["Bacuru and Egguru"] = true, ["Los Bros"] = true, ["La Extinct Grande"] = true,
	["Los Candies"] = true, ["Los Fruits"] = true, ["Celularcini Viciosini"] = true,
	["Los 67"] = true, ["Capitano Gullini"] = true, ["Los Mobilis"] = true,
	["Churrito Bunnito"] = true, ["Money Money Puggy"] = true, ["Cigno Fulgoro"] = true,
	["Los Hotspotsitos"] = true, ["Los Jolly Combinasionas"] = true, ["Los Spooky Combinasionas"] = true,
	["Frullato Framingo"] = true, ["Peschito Machito"] = true, ["Chicleteira Champeona"] = true,
	["Deputy Leopard"] = true, ["Girafini Raftini"] = true, ["Snailo Clovero"] = true,
	["Los Planitos"] = true, ["Chicleteira Cupideira"] = true, ["Las Sis"] = true,
	["Camera Ramena"] = true, ["Spinny Hammy"] = true, ["Motorino Bumbino"] = true,
	["Tacorita Bicicleta"] = true, ["Los Sweethearts"] = true, ["Baskito"] = true,
	["Chicleteira Surfeiteira"] = true, ["Chicleteira Noelteira"] = true, ["Bananito"] = true,
	["Los Combinasionas"] = true, ["Nuclearo Dinossauro"] = true, ["Gattino Hydrantino"] = true,
	["Chimnino"] = true, ["Noo my Gold"] = true, ["Noo my Heart"] = true,
	["Swag Soda"] = true, ["Pogo Pogo Penguin"] = true, ["Mariachi Corazoni"] = true,
	["Tacorillo Crocodillo"] = true,
}

local AnimalsData, NumberUtils, TraitsData
pcall(function() AnimalsData = require(ReplicatedStorage:WaitForChild("Datas"):WaitForChild("Animals")) end)
pcall(function() NumberUtils = require(ReplicatedStorage:WaitForChild("Utils"):WaitForChild("NumberUtils")) end)
pcall(function() TraitsData = require(ReplicatedStorage:WaitForChild("Datas"):WaitForChild("Traits")) end)

local function normKey(s)
	return (tostring(s or ""):lower():gsub("%s+", ""):gsub("'", ""):gsub("'", ""))
end

local knownAnimalNames = {}
pcall(function()
	if AnimalsData then
		for _, info in pairs(AnimalsData) do
			if type(info) == "table" and type(info.DisplayName) == "string" and #info.DisplayName >= 3 then
				knownAnimalNames[info.DisplayName] = true
			end
		end
	end
end)

local function isTargetName(name)
	if not name or name == "" then return false end
	if TargetBrainrots[name] then return true end
	local key = normKey(name)
	for t in pairs(TargetBrainrots) do
		if normKey(t) == key then return true end
	end
	return false
end

------------------------------------------------------------
-- REMOTES
------------------------------------------------------------
local Net = ReplicatedStorage:WaitForChild("Packages"):WaitForChild("Net")
local READY_GUID = "23f15b0b-b633-4f6b-888f-5924b7425522"
local ACCEPT_GUID = "86eea964-f19e-4ac6-b401-a71ecc89e596"
local CANCEL_GUID = "171b5ced-5729-49c0-8d80-9c1897ff1ea3"
local INVITE_GUID = "8fbe1594-7cef-4c29-94d1-a0e93adfa5a4"

local readyRE, acceptRE, cancelRE, inviteRemote

local function nameSearch(keywords, className)
	for _, c in ipairs(Net:GetChildren()) do
		if (not className or c:IsA(className)) and (c:IsA("RemoteEvent") or c:IsA("RemoteFunction")) then
			local n = string.lower(c.Name)
			local ok = true
			for _, kw in ipairs(keywords) do
				if not n:find(kw, 1, true) then ok = false break end
			end
			if ok then return c end
		end
	end
	return nil
end

local function findByPath(paths)
	for _, leaf in ipairs(paths) do
		local c = Net:FindFirstChild(leaf)
		if c and (c:IsA("RemoteEvent") or c:IsA("RemoteFunction")) then return c end
	end
	return nil
end

local function getInviteRemote()
	local r = findByPath({ "RF/TradeService/Invite", "RF/TradeService/CreateInvite", "RF/TradeService/SendInvite" })
	if r then return r end
	r = nameSearch({ "createinvite" }, "RemoteFunction") or nameSearch({ "invite" }, "RemoteFunction")
	if r then return r end
	local children = Net:GetChildren()
	if children[189] and (children[189]:IsA("RemoteFunction") or children[189]:IsA("RemoteEvent")) then
		if string.lower(children[189].Name):find("invite", 1, true) then return children[189] end
	end
	return nil
end

local function resolveRemotes()
	readyRE = readyRE or findByPath({ "RE/TradeService/Ready" }) or nameSearch({ "ready" }, "RemoteEvent")
	acceptRE = acceptRE or findByPath({ "RE/TradeService/Accept" }) or nameSearch({ "accept" }, "RemoteEvent")
	cancelRE = cancelRE
		or findByPath({ "RE/TradeService/Cancel", "RE/TradeService/CancelTrade" })
		or nameSearch({ "canceltrade" }, "RemoteEvent")
		or nameSearch({ "cancel" }, "RemoteEvent")
	inviteRemote = inviteRemote or getInviteRemote()
end

for _ = 1, 30 do
	resolveRemotes()
	if readyRE and acceptRE then break end
	task.wait(0.1)
end
resolveRemotes()

local function SendInvite(userId, usernameOpt)
	userId = tonumber(userId)
	if not userId then return false end
	inviteRemote = inviteRemote or getInviteRemote()
	if not inviteRemote then return false end
	local ok = pcall(function()
		if inviteRemote:IsA("RemoteFunction") then
			inviteRemote:InvokeServer(INVITE_GUID, userId)
		else
			inviteRemote:FireServer(INVITE_GUID, userId)
		end
	end)
	return ok
end

local function cancelTrade(reason)
	if not cancelRE then resolveRemotes() end
	if not cancelRE then return end
	print("[K2] AUTO-CANCEL:", reason or "unknown")
	pcall(function() cancelRE:FireServer(CANCEL_GUID) end)
end

local function isUnderLocalSide(obj)
	local cur = obj
	while cur and cur ~= LocalPlayer.PlayerGui do
		local n = string.lower(tostring(cur.Name))
		if n:find("local", 1, true) or n:find("self", 1, true) or n:find("mine", 1, true)
			or n:find("myoffer", 1, true) or n == string.lower(LocalPlayer.Name)
			or n == string.lower(LocalPlayer.DisplayName) or n:find("you", 1, true)
		then return true end
		if cur:IsA("TextLabel") or cur:IsA("TextButton") then
			local t = cur.Text
			if t == LocalPlayer.Name or t == LocalPlayer.DisplayName then return true end
		end
		cur = cur.Parent
	end
	return false
end

local function getOpponentRoot(tradeUI)
	for _, name in ipairs({ "Other", "Others", "Opponent", "Their", "Them", "RightOffer", "OtherOffer", "TheirOffer", "Partner" }) do
		local f = tradeUI:FindFirstChild(name, true)
		if f then return f end
	end
	return tradeUI
end

local function scanTradeForNonTargets(tradeUI)
	if not tradeUI or not tradeUI.Parent then return false end
	if next(TargetBrainrots) == nil or next(knownAnimalNames) == nil then return false end
	local root = getOpponentRoot(tradeUI)
	for _, d in ipairs(root:GetDescendants()) do
		if (d:IsA("TextLabel") or d:IsA("TextButton")) and not isUnderLocalSide(d) then
			local text = d.Text
			if type(text) == "string" and #text >= 3 and knownAnimalNames[text] == true
				and d.Visible ~= false and d.AbsoluteSize.X > 2 and d.AbsoluteSize.Y > 2
			then
				if not isTargetName(text) then
					cancelTrade("Non-target: " .. text)
					return true
				end
			end
		end
	end
	return false
end

------------------------------------------------------------
-- BASE SCAN (money/s ranking)
------------------------------------------------------------
local function plotOwnedByLocalPlayer(plot)
	if not plot then return false end
	for _, key in ipairs({ "Owner", "OwnerUserId", "UserId", "OwnerId", "PlayerUserId" }) do
		local v = plot:GetAttribute(key)
		if v ~= nil then
			if tonumber(v) == LP.UserId then return true end
			if tostring(v) == LP.Name or tostring(v) == LP.DisplayName or tostring(v) == tostring(LP.UserId) then
				return true
			end
		end
	end
	for _, inst in ipairs(plot:GetDescendants()) do
		local n = string.lower(inst.Name)
		if n == "owner" or n == "owneruserid" or n == "userid" or n == "ownerid" then
			if inst:IsA("ObjectValue") and inst.Value == LP then return true end
			if (inst:IsA("NumberValue") or inst:IsA("IntValue")) and inst.Value == LP.UserId then return true end
			if inst:IsA("StringValue") then
				local s = inst.Value
				if s == LP.Name or s == LP.DisplayName or s == tostring(LP.UserId) then return true end
			end
		end
	end
	if plot.Name == tostring(LP.UserId) or plot.Name:find(tostring(LP.UserId), 1, true) then
		return true
	end
	return false
end

local function ownerMatchesLocal(ownerField)
	if ownerField == nil then return nil end
	local oid = tonumber(ownerField)
	if oid then return oid == LP.UserId end
	local s = tostring(ownerField)
	return s == LP.Name or s == LP.DisplayName or s == tostring(LP.UserId)
end

local function getMyPlotAndAnimals()
	local plotsFolder = workspace:FindFirstChild("Plots")
	if not plotsFolder then return nil, nil end
	local hrp = LP.Character and LP.Character:FindFirstChild("HumanoidRootPart")
	local syncFolder = ReplicatedStorage.Packages:FindFirstChild("Synchronizer")
	local requestData = syncFolder and syncFolder:FindFirstChild("RequestData")
	if not requestData then return nil, nil end

	local candidates = {}
	for _, plot in ipairs(plotsFolder:GetChildren()) do
		if plotOwnedByLocalPlayer(plot) then table.insert(candidates, plot) end
	end

	local function fetchAnimals(plot)
		local ok, data = pcall(function() return requestData:InvokeServer(plot.Name) end)
		if not ok or type(data) ~= "table" or type(data.AnimalList) ~= "table" then return nil end
		local ownerField = data.Owner or data.OwnerUserId or data.UserId or data.PlayerUserId
		local match = ownerMatchesLocal(ownerField)
		if match == false then return nil end
		if match == nil and not plotOwnedByLocalPlayer(plot) then return nil end
		return data.AnimalList
	end

	local verified = {}
	local searchList = #candidates > 0 and candidates or plotsFolder:GetChildren()
	for _, plot in ipairs(searchList) do
		local animals = fetchAnimals(plot)
		if animals then
			local dist = math.huge
			if hrp then
				local okp, pos = pcall(function() return plot:GetPivot().Position end)
				if okp and pos then dist = (pos - hrp.Position).Magnitude end
			end
			table.insert(verified, { plot = plot, animals = animals, dist = dist })
		end
	end
	if #verified == 0 then return nil, nil end
	table.sort(verified, function(a, b) return a.dist < b.dist end)
	return verified[1].plot, verified[1].animals
end

local function getTraitMultiplier(traitName)
	if not TraitsData or not traitName then return 0 end
	local info = TraitsData[traitName]
	if not info then
		local key = traitName:lower():gsub("%s+", "")
		for k, v in pairs(TraitsData) do
			if type(k) == "string" and k:lower():gsub("%s+", "") == key then info = v break end
		end
	end
	if type(info) ~= "table" then return 0 end
	local tm = info.MultiplierModifier or info.Multiplier or info.modifier or info.GenerationMultiplier
	return (type(tm) == "number" and tm > 0) and tm or 0
end

local function getMutationMultiplier(mutName)
	if not mutName or mutName == "" or mutName == "None" or mutName == "Default" then return 1 end
	if MUTATION_MULT[mutName] then return MUTATION_MULT[mutName] end
	local key = mutName:lower():gsub("%s+", "")
	for name, mult in pairs(MUTATION_MULT) do
		if name:lower():gsub("%s+", "") == key then return mult end
	end
	return 1
end

local function getGeneration(data)
	local index = data.Index
	local base = 0
	if AnimalsData and AnimalsData[index] and type(AnimalsData[index].Generation) == "number" then
		base = AnimalsData[index].Generation
	end
	if base <= 0 then return 0 end
	local gen = base * getMutationMultiplier(data.Mutation)
	local traits = data.Traits
	if type(traits) == "table" then
		for _, t in pairs(traits) do
			local traitName = type(t) == "string" and t or (type(t) == "table" and (t.Name or t.Index or t.Trait or t.Id))
			local tm = getTraitMultiplier(traitName)
			if tm > 0 then gen = gen + (base * tm) end
		end
	end
	return gen
end

local function formatGen(genVal)
	if NumberUtils and NumberUtils.Format then
		return NumberUtils.Format(genVal) .. "/s"
	end
	if genVal >= 1e12 then return string.format("%.1fT/s", genVal / 1e12)
	elseif genVal >= 1e9 then return string.format("%.1fB/s", genVal / 1e9)
	elseif genVal >= 1e6 then return string.format("%.1fM/s", genVal / 1e6)
	elseif genVal >= 1e3 then return string.format("%.1fK/s", genVal / 1e3)
	end
	return tostring(math.floor(genVal)) .. "/s"
end

local function scanBaseRanked()
	local _, animalList = getMyPlotAndAnimals()
	local results = {}
	if type(animalList) ~= "table" then return results end
	for slot, data in pairs(animalList) do
		if type(data) == "table" and data.Index then
			local info = AnimalsData and AnimalsData[data.Index]
			local displayName = (info and info.DisplayName) or data.Index
			local genVal = getGeneration(data)
			local mut = data.Mutation or "None"
			table.insert(results, {
				name = displayName,
				gen = genVal,
				genStr = formatGen(genVal),
				mutation = mut,
				slot = tostring(slot),
			})
		end
	end
	table.sort(results, function(a, b) return a.gen > b.gen end)
	return results
end

------------------------------------------------------------
-- CLICK
------------------------------------------------------------
local function clickGui(btn)
	if not btn then return end
	if firesignal then
		pcall(function() firesignal(btn.Activated) end)
		pcall(function() firesignal(btn.MouseButton1Click) end)
		return
	end
	pcall(function()
		local pos = btn.AbsolutePosition + btn.AbsoluteSize / 2
		VirtualInputManager:SendMouseButtonEvent(pos.X, pos.Y, 0, true, game, 1)
		VirtualInputManager:SendMouseButtonEvent(pos.X, pos.Y, 0, false, game, 1)
	end)
end

------------------------------------------------------------
-- FULL SCREEN GUI
------------------------------------------------------------
local statusDot, listHolder, listLayout, totalLabel

local function corner(obj, r)
	local c = Instance.new("UICorner")
	c.CornerRadius = UDim.new(0, r or 12)
	c.Parent = obj
	return c
end

local function buildGui()
	local parent = (CoreGui:FindFirstChild("RobloxGui") or CoreGui)
	local old = parent:FindFirstChild("K2AutoAcceptFS")
	if old then old:Destroy() end
	local pgOld = LocalPlayer.PlayerGui:FindFirstChild("K2AutoAcceptFS")
	if pgOld then pgOld:Destroy() end

	local gui = Instance.new("ScreenGui")
	gui.Name = "K2AutoAcceptFS"
	gui.ResetOnSpawn = false
	gui.IgnoreGuiInset = true
	gui.DisplayOrder = 50
	gui.Parent = LocalPlayer:WaitForChild("PlayerGui")

	-- full opaque night sky
	local root = Instance.new("Frame")
	root.Name = "Root"
	root.Size = UDim2.fromScale(1, 1)
	root.BackgroundColor3 = CONFIG.SkyTop
	root.BorderSizePixel = 0
	root.ClipsDescendants = true
	root.Parent = gui

	local skyGrad = Instance.new("UIGradient")
	skyGrad.Rotation = 90
	skyGrad.Color = ColorSequence.new({
		ColorSequenceKeypoint.new(0, CONFIG.SkyTop),
		ColorSequenceKeypoint.new(0.5, CONFIG.SkyMid),
		ColorSequenceKeypoint.new(1, CONFIG.SkyBottom),
	})
	skyGrad.Parent = root

	-- soft stars
	for i = 1, 60 do
		local s = Instance.new("Frame")
		s.Size = UDim2.new(0, math.random(1, 3), 0, math.random(1, 3))
		s.Position = UDim2.new(math.random(), 0, math.random(), 0)
		s.BackgroundColor3 = Color3.fromRGB(220, 230, 255)
		s.BackgroundTransparency = math.random(20, 70) / 100
		s.BorderSizePixel = 0
		s.ZIndex = 1
		s.Parent = root
		corner(s, 99)
	end

	-- vignette
	local vig = Instance.new("Frame")
	vig.Size = UDim2.fromScale(1, 1)
	vig.BackgroundColor3 = Color3.fromRGB(0, 0, 0)
	vig.BackgroundTransparency = 0.5
	vig.BorderSizePixel = 0
	vig.ZIndex = 2
	vig.Parent = root
	local vg = Instance.new("UIGradient")
	vg.Rotation = 90
	vg.Transparency = NumberSequence.new({
		NumberSequenceKeypoint.new(0, 0.2),
		NumberSequenceKeypoint.new(0.4, 0.9),
		NumberSequenceKeypoint.new(0.7, 0.9),
		NumberSequenceKeypoint.new(1, 0.15),
	})
	vg.Parent = vig

	-- TOP LEFT: logo + name (small)
	local brand = Instance.new("Frame")
	brand.BackgroundTransparency = 1
	brand.Position = UDim2.new(0, 22, 0, 18)
	brand.Size = UDim2.new(0, 220, 0, 44)
	brand.ZIndex = 10
	brand.Parent = root

	local logoBox = Instance.new("Frame")
	logoBox.Size = UDim2.new(0, 36, 0, 36)
	logoBox.Position = UDim2.new(0, 0, 0.5, -18)
	logoBox.BackgroundColor3 = Color3.fromRGB(30, 36, 60)
	logoBox.BorderSizePixel = 0
	logoBox.ZIndex = 10
	logoBox.Parent = brand
	corner(logoBox, 10)
	local logoStroke = Instance.new("UIStroke", logoBox)
	logoStroke.Color = CONFIG.Accent
	logoStroke.Thickness = 1.4
	logoStroke.Transparency = 0.25

	local logoTxt = Instance.new("TextLabel", logoBox)
	logoTxt.Size = UDim2.fromScale(1, 1)
	logoTxt.BackgroundTransparency = 1
	logoTxt.Text = "K2"
	logoTxt.Font = Enum.Font.GothamBlack
	logoTxt.TextSize = 13
	logoTxt.TextColor3 = CONFIG.Glow
	logoTxt.ZIndex = 11

	local brandName = Instance.new("TextLabel", brand)
	brandName.Position = UDim2.new(0, 46, 0, 2)
	brandName.Size = UDim2.new(1, -46, 0, 20)
	brandName.BackgroundTransparency = 1
	brandName.Text = "K2 Auto Accept"
	brandName.Font = Enum.Font.GothamBold
	brandName.TextSize = 15
	brandName.TextColor3 = Color3.new(1, 1, 1)
	brandName.TextXAlignment = Enum.TextXAlignment.Left
	brandName.ZIndex = 10

	local brandSub = Instance.new("TextLabel", brand)
	brandSub.Position = UDim2.new(0, 46, 0, 22)
	brandSub.Size = UDim2.new(1, -46, 0, 16)
	brandSub.BackgroundTransparency = 1
	brandSub.Text = CONFIG.Discord
	brandSub.Font = Enum.Font.Gotham
	brandSub.TextSize = 11
	brandSub.TextColor3 = CONFIG.Muted
	brandSub.TextXAlignment = Enum.TextXAlignment.Left
	brandSub.ZIndex = 10

	-- CENTER status
	local center = Instance.new("Frame")
	center.BackgroundTransparency = 1
	center.AnchorPoint = Vector2.new(0.5, 0.5)
	center.Position = UDim2.new(0.5, 0, 0.28, 0)
	center.Size = UDim2.new(0, 520, 0, 90)
	center.ZIndex = 10
	center.Parent = root

	local bigStatus = Instance.new("TextLabel", center)
	bigStatus.Size = UDim2.new(1, 0, 0, 36)
	bigStatus.BackgroundTransparency = 1
	bigStatus.Text = "Auto Accept Active, Goodnight."
	bigStatus.Font = Enum.Font.GothamBold
	bigStatus.TextSize = 26
	bigStatus.TextColor3 = CONFIG.Glow
	bigStatus.ZIndex = 10

	local statusRow = Instance.new("TextLabel", center)
	statusRow.Position = UDim2.new(0, 0, 0, 44)
	statusRow.Size = UDim2.new(1, 0, 0, 22)
	statusRow.BackgroundTransparency = 1
	statusRow.Text = "● Active"
	statusRow.Font = Enum.Font.GothamMedium
	statusRow.TextSize = 14
	statusRow.TextColor3 = CONFIG.Success
	statusRow.ZIndex = 10
	statusDot = statusRow

	local toggleBtn = Instance.new("TextButton", center)
	toggleBtn.AnchorPoint = Vector2.new(0.5, 0)
	toggleBtn.Position = UDim2.new(0.5, 0, 0, 72)
	toggleBtn.Size = UDim2.new(0, 100, 0, 28)
	toggleBtn.BackgroundColor3 = CONFIG.Success
	toggleBtn.Text = "ON"
	toggleBtn.Font = Enum.Font.GothamBold
	toggleBtn.TextSize = 12
	toggleBtn.TextColor3 = Color3.new(1, 1, 1)
	toggleBtn.BorderSizePixel = 0
	toggleBtn.ZIndex = 11
	toggleBtn.AutoButtonColor = false
	corner(toggleBtn, 14)
	toggleBtn.MouseButton1Click:Connect(function()
		acceptEnabled = not acceptEnabled
		if acceptEnabled then
			toggleBtn.BackgroundColor3 = CONFIG.Success
			toggleBtn.Text = "ON"
			statusDot.Text = "● Active"
			statusDot.TextColor3 = CONFIG.Success
			bigStatus.Text = "Auto Accept Active, Goodnight."
		else
			toggleBtn.BackgroundColor3 = CONFIG.Error
			toggleBtn.Text = "OFF"
			statusDot.Text = "● Paused"
			statusDot.TextColor3 = CONFIG.Error
			bigStatus.Text = "Auto Accept Paused."
		end
	end)

	-- LIST CARD (non-interactive display)
	local card = Instance.new("Frame")
	card.Name = "BrainrotList"
	card.AnchorPoint = Vector2.new(0.5, 0)
	card.Position = UDim2.new(0.5, 0, 0.42, 0)
	card.Size = UDim2.new(0, 420, 0, 300)
	card.BackgroundColor3 = CONFIG.Card
	card.BackgroundTransparency = 0.15
	card.BorderSizePixel = 0
	card.ZIndex = 10
	card.ClipsDescendants = true
	card.Parent = root
	corner(card, 16)
	local cardStroke = Instance.new("UIStroke", card)
	cardStroke.Color = CONFIG.CardBorder
	cardStroke.Thickness = 1.5
	cardStroke.Transparency = 0.35

	local listTitle = Instance.new("TextLabel", card)
	listTitle.BackgroundTransparency = 1
	listTitle.Position = UDim2.new(0, 16, 0, 12)
	listTitle.Size = UDim2.new(1, -32, 0, 22)
	listTitle.Text = "Your Base  ·  Best → Worst"
	listTitle.Font = Enum.Font.GothamBold
	listTitle.TextSize = 13
	listTitle.TextColor3 = CONFIG.Accent
	listTitle.TextXAlignment = Enum.TextXAlignment.Left
	listTitle.ZIndex = 11

	totalLabel = Instance.new("TextLabel", card)
	totalLabel.BackgroundTransparency = 1
	totalLabel.Position = UDim2.new(0, 16, 0, 34)
	totalLabel.Size = UDim2.new(1, -32, 0, 16)
	totalLabel.Text = "Scanning…"
	totalLabel.Font = Enum.Font.Gotham
	totalLabel.TextSize = 11
	totalLabel.TextColor3 = CONFIG.Muted
	totalLabel.TextXAlignment = Enum.TextXAlignment.Left
	totalLabel.ZIndex = 11

	local scroll = Instance.new("ScrollingFrame", card)
	scroll.Name = "ListScroll"
	scroll.Position = UDim2.new(0, 12, 0, 56)
	scroll.Size = UDim2.new(1, -24, 1, -68)
	scroll.BackgroundTransparency = 1
	scroll.BorderSizePixel = 0
	scroll.ScrollBarThickness = 3
	scroll.ScrollBarImageColor3 = CONFIG.Accent
	scroll.CanvasSize = UDim2.new(0, 0, 0, 0)
	scroll.ScrollingEnabled = true
	scroll.Active = true
	scroll.Selectable = false
	scroll.ZIndex = 11
	-- block accidental interaction with rows
	scroll.AutomaticCanvasSize = Enum.AutomaticSize.Y

	listHolder = Instance.new("Frame", scroll)
	listHolder.BackgroundTransparency = 1
	listHolder.Size = UDim2.new(1, 0, 0, 0)
	listHolder.AutomaticSize = Enum.AutomaticSize.Y
	listHolder.ZIndex = 11

	listLayout = Instance.new("UIListLayout", listHolder)
	listLayout.SortOrder = Enum.SortOrder.LayoutOrder
	listLayout.Padding = UDim.new(0, 6)

	listLayout:GetPropertyChangedSignal("AbsoluteContentSize"):Connect(function()
		scroll.CanvasSize = UDim2.new(0, 0, 0, listLayout.AbsoluteContentSize.Y + 8)
	end)

	-- bottom tip
	local tip = Instance.new("TextLabel", root)
	tip.AnchorPoint = Vector2.new(0.5, 1)
	tip.Position = UDim2.new(0.5, 0, 1, -16)
	tip.Size = UDim2.new(0, 400, 0, 18)
	tip.BackgroundTransparency = 1
	tip.Text = "List updates every 30s  ·  Non-targets auto-cancel"
	tip.Font = Enum.Font.Gotham
	tip.TextSize = 11
	tip.TextColor3 = CONFIG.Muted
	tip.ZIndex = 10
end

local function clearList()
	if not listHolder then return end
	for _, c in ipairs(listHolder:GetChildren()) do
		if not c:IsA("UIListLayout") then c:Destroy() end
	end
end

local function refreshList()
	local ranked = scanBaseRanked()
	clearList()
	local total = 0
	for i, item in ipairs(ranked) do
		total += item.gen
		local row = Instance.new("Frame")
		row.Size = UDim2.new(1, 0, 0, 34)
		row.BackgroundColor3 = Color3.fromRGB(22, 26, 44)
		row.BackgroundTransparency = 0.25
		row.BorderSizePixel = 0
		row.ZIndex = 12
		row.LayoutOrder = i
		row.Parent = listHolder
		corner(row, 8)

		-- non-interactive shield
		local block = Instance.new("TextButton", row)
		block.Size = UDim2.fromScale(1, 1)
		block.BackgroundTransparency = 1
		block.Text = ""
		block.ZIndex = 15
		block.Active = false
		block.AutoButtonColor = false

		local rank = Instance.new("TextLabel", row)
		rank.Size = UDim2.new(0, 28, 1, 0)
		rank.Position = UDim2.new(0, 8, 0, 0)
		rank.BackgroundTransparency = 1
		rank.Text = "#" .. i
		rank.Font = Enum.Font.GothamBold
		rank.TextSize = 12
		rank.TextColor3 = (i <= 3) and CONFIG.Accent or CONFIG.Muted
		rank.TextXAlignment = Enum.TextXAlignment.Left
		rank.ZIndex = 13

		local name = Instance.new("TextLabel", row)
		name.Size = UDim2.new(1, -140, 1, 0)
		name.Position = UDim2.new(0, 40, 0, 0)
		name.BackgroundTransparency = 1
		name.Text = item.name
		name.Font = Enum.Font.GothamMedium
		name.TextSize = 12
		name.TextColor3 = Color3.new(1, 1, 1)
		name.TextXAlignment = Enum.TextXAlignment.Left
		name.TextTruncate = Enum.TextTruncate.AtEnd
		name.ZIndex = 13

		local gen = Instance.new("TextLabel", row)
		gen.Size = UDim2.new(0, 90, 1, 0)
		gen.Position = UDim2.new(1, -98, 0, 0)
		gen.BackgroundTransparency = 1
		gen.Text = "$" .. item.genStr
		gen.Font = Enum.Font.GothamBold
		gen.TextSize = 12
		gen.TextColor3 = CONFIG.Success
		gen.TextXAlignment = Enum.TextXAlignment.Right
		gen.ZIndex = 13
	end
	if totalLabel then
		if #ranked == 0 then
			totalLabel.Text = "No brainrots found on base"
		else
			totalLabel.Text = string.format("%d brainrots  ·  total $%s", #ranked, formatGen(total):gsub("/s", "") .. "/s")
		end
	end
end

------------------------------------------------------------
-- ACCEPT LOGIC (Chocola)
------------------------------------------------------------
local function acceptTradePrompt(prompt)
	if not acceptEnabled then return end
	local yes = prompt:FindFirstChild("Yes", true)
	if yes then
		print("[K2] Trade Request → Yes")
		clickGui(yes)
	end
end

local function tryReadyButton()
	if not acceptEnabled then return end
	local pg = LocalPlayer:FindFirstChild("PlayerGui")
	if not pg then return end
	local TradeLiveTrade = pg:FindFirstChild("TradeLiveTrade")
	if not TradeLiveTrade then return end
	local inner = TradeLiveTrade:FindFirstChild("TradeLiveTrade", true) or TradeLiveTrade
	if scanTradeForNonTargets(inner) then return end
	local other = inner:FindFirstChild("Other", true)
	if other then
		local readyBtn = other:FindFirstChild("ReadyButton")
		if readyBtn then clickGui(readyBtn) end
	end
	if readyRE then pcall(function() readyRE:FireServer(READY_GUID) end) end
	if acceptRE then pcall(function() acceptRE:FireServer(ACCEPT_GUID) end) end
end

local function placeAFKTag()
	local char = LocalPlayer.Character or LocalPlayer.CharacterAdded:Wait()
	local head = char:FindFirstChild("Head")
	if not head or head:FindFirstChild("AFKTag") then return end
	local bb = Instance.new("BillboardGui")
	bb.Name = "AFKTag"
	bb.Size = UDim2.new(0, 200, 0, 50)
	bb.StudsOffset = Vector3.new(0, 2.5, 0)
	bb.AlwaysOnTop = true
	bb.Parent = head
	local tl = Instance.new("TextLabel")
	tl.Size = UDim2.fromScale(1, 1)
	tl.BackgroundTransparency = 1
	tl.Text = "K2 Auto Accept AFK"
	tl.TextColor3 = CONFIG.Accent
	tl.TextStrokeTransparency = 0
	tl.TextScaled = true
	tl.Font = Enum.Font.GothamBold
	tl.Parent = bb
end

------------------------------------------------------------
-- BOOT
------------------------------------------------------------
print("[K2] Full-screen Auto Accept loading…")
buildGui()
task.defer(refreshList)

-- scan every 30s
task.spawn(function()
	while task.wait(30) do
		pcall(refreshList)
	end
end)

-- anti-afk jump 45s
task.spawn(function()
	while task.wait(45) do
		local char = LocalPlayer.Character
		if char then
			local hum = char:FindFirstChildOfClass("Humanoid")
			if hum and hum.Health > 0 then
				hum:ChangeState(Enum.HumanoidStateType.Jumping)
			end
		end
		if statusDot and acceptEnabled and statusDot.Text ~= "🔄 AFK" then
			statusDot.Text = "🔄 AFK"
			statusDot.TextColor3 = Color3.fromRGB(255, 200, 0)
			task.wait(2)
			if acceptEnabled then
				statusDot.Text = "● Active"
				statusDot.TextColor3 = CONFIG.Success
			end
		end
	end
end)

-- anti-restart click 60s
task.spawn(function()
	while task.wait(60) do
		pcall(function()
			VirtualInputManager:SendMouseButtonEvent(0, 0, 0, true, game, 1)
			task.wait(0.1)
			VirtualInputManager:SendMouseButtonEvent(0, 0, 0, false, game, 1)
		end)
	end
end)

task.delay(2, function()
	local pg = LocalPlayer:WaitForChild("PlayerGui")
	local root = pg:FindFirstChild("DuelsMachinePrompt") or pg:WaitForChild("DuelsMachinePrompt", 60)
	if not root then
		warn("[K2] DuelsMachinePrompt not found")
		return
	end
	local inner = root:FindFirstChild("DuelsMachinePrompt") or root
	placeAFKTag()
	LocalPlayer.CharacterAdded:Connect(function()
		task.wait(1)
		placeAFKTag()
	end)

	task.spawn(function()
		while task.wait(0.5) do
			tryReadyButton()
		end
	end)

	inner.ChildAdded:Connect(function(child)
		if child.Name == "Prompt" then
			task.defer(function()
				local label = child:FindFirstChild("Label", true)
				if label and label.Text == "Trade Request" then
					acceptTradePrompt(child)
				end
			end)
		end
	end)
	for _, child in ipairs(inner:GetChildren()) do
		if child.Name == "Prompt" then
			local label = child:FindFirstChild("Label", true)
			if label and label.Text == "Trade Request" then
				acceptTradePrompt(child)
			end
		end
	end
	print("[K2] DuelsMachinePrompt hooked")
end)

pcall(function()
	local env = (typeof(getgenv) == "function" and getgenv()) or _G
	env.K2SendInvite = SendInvite
	env.K2CancelTrade = cancelTrade
end)

print("[K2 Auto Accept FS] loaded")
